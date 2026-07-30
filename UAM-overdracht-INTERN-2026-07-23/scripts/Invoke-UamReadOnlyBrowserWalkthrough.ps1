#requires -Version 7.2
<#+
.SYNOPSIS
    Captures a read-only, privacy-masked walkthrough of a UAM PSU web app.

.DESCRIPTION
    Drives Chrome through the local Chrome DevTools Protocol (CDP). The script
    uses a temporary browser profile, authenticates from the existing PSU admin
    process variables without logging their values, and never stores cookies,
    browser storage, request bodies or HTML.

    Navigation is restricted to tabs. Per screen, at most one explicitly
    read-only interaction is attempted: search/filter, column sorting, or
    pagination. Table contents, input values and canvas labels are visually
    masked before every screenshot.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [uri]$AppUri,

    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z0-9_-]{2,30}$')]
    [string]$EnvironmentLabel,

    [Parameter(Mandatory)]
    [string]$OutputDirectory,

    [ValidateSet('Auto', 'Chrome', 'Edge')]
    [string]$Browser = 'Auto',

    [string]$ProxyServer = '',

    [ValidateRange(30, 900)]
    [int]$LoginTimeoutSeconds = 180,

    [switch]$InteractiveLogin,

    [switch]$Visible
)

$ErrorActionPreference = 'Stop'
$script:CdpMessageId = 0
$script:CdpSocket = $null
$script:BrowserProcess = $null
$script:BrowserProfilePath = ''

if ($null -eq ('UamLocalWebSocket' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;

public sealed class UamLocalWebSocket : IDisposable
{
    private const string WebSocketGuid = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
    private readonly TcpClient client;
    private readonly NetworkStream stream;

    private UamLocalWebSocket(TcpClient client)
    {
        this.client = client;
        this.stream = client.GetStream();
    }

    public static UamLocalWebSocket Connect(Uri uri)
    {
        if (uri == null || !String.Equals(uri.Scheme, "ws", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Only a local ws:// CDP endpoint is permitted.");
        if (!String.Equals(uri.Host, "127.0.0.1", StringComparison.OrdinalIgnoreCase) &&
            !String.Equals(uri.Host, "localhost", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("Only the local CDP host is permitted.");

        var tcp = new TcpClient();
        tcp.NoDelay = true;
        tcp.Connect("127.0.0.1", uri.Port);
        var socket = new UamLocalWebSocket(tcp);
        try
        {
            byte[] nonce = new byte[16];
            RandomNumberGenerator.Fill(nonce);
            string key = Convert.ToBase64String(nonce);
            string request =
                "GET " + uri.PathAndQuery + " HTTP/1.1\r\n" +
                "Host: 127.0.0.1:" + uri.Port + "\r\n" +
                "Upgrade: websocket\r\n" +
                "Connection: Upgrade\r\n" +
                "Origin: http://127.0.0.1:" + uri.Port + "\r\n" +
                "Sec-WebSocket-Key: " + key + "\r\n" +
                "Sec-WebSocket-Version: 13\r\n\r\n";
            byte[] requestBytes = Encoding.ASCII.GetBytes(request);
            socket.stream.Write(requestBytes, 0, requestBytes.Length);
            socket.stream.Flush();

            string response = socket.ReadHttpHeader(65536);
            string[] lines = response.Split(new[] { "\r\n" }, StringSplitOptions.None);
            if (lines.Length == 0 || lines[0].IndexOf(" 101 ", StringComparison.Ordinal) < 0)
            {
                int contentLength = 0;
                foreach (string line in lines)
                {
                    int colon = line.IndexOf(':');
                    if (colon > 0 && String.Equals(line.Substring(0, colon).Trim(), "Content-Length", StringComparison.OrdinalIgnoreCase))
                        Int32.TryParse(line.Substring(colon + 1).Trim(), out contentLength);
                }
                string detail = contentLength > 0 && contentLength <= 2048
                    ? Encoding.UTF8.GetString(socket.ReadExact(contentLength)).Replace("\r", " ").Replace("\n", " ").Trim()
                    : String.Empty;
                throw new IOException("Local CDP WebSocket handshake did not return HTTP 101 (" +
                    (lines.Length == 0 ? "no status" : lines[0]) +
                    (String.IsNullOrWhiteSpace(detail) ? String.Empty : "; " + detail) + ").");
            }

            string accept = null;
            foreach (string line in lines)
            {
                int colon = line.IndexOf(':');
                if (colon > 0 && String.Equals(line.Substring(0, colon).Trim(), "Sec-WebSocket-Accept", StringComparison.OrdinalIgnoreCase))
                    accept = line.Substring(colon + 1).Trim();
            }
            byte[] acceptHash = SHA1.HashData(Encoding.ASCII.GetBytes(key + WebSocketGuid));
            string expectedAccept = Convert.ToBase64String(acceptHash);
            if (!String.Equals(accept, expectedAccept, StringComparison.Ordinal))
                throw new IOException("Local CDP WebSocket handshake validation failed.");
            return socket;
        }
        catch
        {
            socket.Dispose();
            throw;
        }
    }

    public void SendText(string text)
    {
        SendFrame(0x1, Encoding.UTF8.GetBytes(text ?? String.Empty));
    }

    public string ReceiveText(int timeoutMilliseconds)
    {
        if (timeoutMilliseconds < 1) timeoutMilliseconds = 1;
        client.ReceiveTimeout = timeoutMilliseconds;
        using (var message = new MemoryStream())
        {
            bool started = false;
            while (true)
            {
                int first = ReadByteRequired();
                int second = ReadByteRequired();
                bool final = (first & 0x80) != 0;
                int opcode = first & 0x0F;
                bool masked = (second & 0x80) != 0;
                ulong length = (ulong)(second & 0x7F);
                if (length == 126)
                {
                    byte[] extended = ReadExact(2);
                    length = ((ulong)extended[0] << 8) | extended[1];
                }
                else if (length == 127)
                {
                    byte[] extended = ReadExact(8);
                    length = 0;
                    for (int i = 0; i < 8; i++) length = (length << 8) | extended[i];
                }
                if (length > 32UL * 1024UL * 1024UL)
                    throw new IOException("Local CDP WebSocket message exceeded the safety limit.");
                byte[] mask = masked ? ReadExact(4) : null;
                byte[] payload = ReadExact((int)length);
                if (masked)
                    for (int i = 0; i < payload.Length; i++) payload[i] ^= mask[i % 4];

                if (opcode == 0x8) throw new IOException("Local CDP WebSocket was closed.");
                if (opcode == 0x9) { SendFrame(0xA, payload); continue; }
                if (opcode == 0xA) continue;
                if (opcode == 0x1) started = true;
                else if (opcode != 0x0 || !started) throw new IOException("Unexpected local CDP WebSocket frame.");

                message.Write(payload, 0, payload.Length);
                if (final) return Encoding.UTF8.GetString(message.ToArray());
            }
        }
    }

    private void SendFrame(int opcode, byte[] payload)
    {
        var header = new List<byte>();
        header.Add((byte)(0x80 | (opcode & 0x0F)));
        ulong length = (ulong)payload.Length;
        if (length < 126)
        {
            header.Add((byte)(0x80 | (byte)length));
        }
        else if (length <= UInt16.MaxValue)
        {
            header.Add(0xFE);
            header.Add((byte)((length >> 8) & 0xFF));
            header.Add((byte)(length & 0xFF));
        }
        else
        {
            header.Add(0xFF);
            for (int shift = 56; shift >= 0; shift -= 8) header.Add((byte)((length >> shift) & 0xFF));
        }
        byte[] mask = new byte[4];
        RandomNumberGenerator.Fill(mask);
        header.AddRange(mask);
        byte[] encoded = new byte[payload.Length];
        for (int i = 0; i < payload.Length; i++) encoded[i] = (byte)(payload[i] ^ mask[i % 4]);
        byte[] headerBytes = header.ToArray();
        stream.Write(headerBytes, 0, headerBytes.Length);
        stream.Write(encoded, 0, encoded.Length);
        stream.Flush();
    }

    private string ReadHttpHeader(int maximumBytes)
    {
        using (var buffer = new MemoryStream())
        {
            int state = 0;
            while (buffer.Length < maximumBytes)
            {
                int value = ReadByteRequired();
                buffer.WriteByte((byte)value);
                state = (state == 0 && value == 13) ? 1 :
                        (state == 1 && value == 10) ? 2 :
                        (state == 2 && value == 13) ? 3 :
                        (state == 3 && value == 10) ? 4 : 0;
                if (state == 4) return Encoding.ASCII.GetString(buffer.ToArray());
            }
        }
        throw new IOException("Local CDP WebSocket handshake exceeded the safety limit.");
    }

    private int ReadByteRequired()
    {
        int value = stream.ReadByte();
        if (value < 0) throw new EndOfStreamException("Local CDP WebSocket ended unexpectedly.");
        return value;
    }

    private byte[] ReadExact(int length)
    {
        byte[] result = new byte[length];
        int offset = 0;
        while (offset < length)
        {
            int read = stream.Read(result, offset, length - offset);
            if (read <= 0) throw new EndOfStreamException("Local CDP WebSocket ended unexpectedly.");
            offset += read;
        }
        return result;
    }

    public void Dispose()
    {
        try { stream.Dispose(); } catch { }
        try { client.Dispose(); } catch { }
    }
}
'@
}

function Get-UamBrowserInfo {
    [array]$candidates = switch ($Browser) {
        'Chrome' { @('C:\Program Files\Google\Chrome\Application\chrome.exe') }
        'Edge' { @('C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe') }
        default {
            @(
                'C:\Program Files\Google\Chrome\Application\chrome.exe',
                'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
            )
        }
    }
    $path = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
    if ([string]::IsNullOrWhiteSpace($path)) {
        throw "Geen ondersteunde Chromium-browser gevonden voor keuze '$Browser'."
    }
    [pscustomobject]@{ Path = $path; Name = if ($path -like '*msedge.exe') { 'Edge' } else { 'Chrome' } }
}

function Start-UamBrowser {
    param([Parameter(Mandatory)][object]$BrowserInfo)

    $tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\')
    $profilePath = Join-Path $tempRoot ('uam-logging-doc-' + [guid]::NewGuid().ToString('N'))
    [void](New-Item -ItemType Directory -Path $profilePath -Force)
    $script:BrowserProfilePath = $profilePath

    [array]$arguments = @(
        '--remote-debugging-address=127.0.0.1',
        '--remote-debugging-port=0',
        '--remote-allow-origins=*',
        '--window-size=1942,1178',
        "--user-data-dir=$profilePath",
        '--no-first-run',
        '--no-default-browser-check',
        '--disable-background-networking',
        '--disable-component-update',
        '--disable-default-apps',
        '--disable-sync',
        '--disable-extensions',
        '--disable-notifications',
        '--metrics-recording-only',
        '--no-pings',
        '--disable-breakpad',
        '--disable-crash-reporter',
        '--disable-features=PasswordManagerOnboarding,OptimizationHints,MediaRouter,AutofillServerCommunication',
        $AppUri.AbsoluteUri
    )
    if (-not [string]::IsNullOrWhiteSpace($ProxyServer)) {
        $arguments = @("--proxy-server=$ProxyServer", '--proxy-bypass-list=localhost;127.0.0.1;<-loopback>') + $arguments
    }
    if (-not $Visible.IsPresent) {
        $arguments = @('--headless=new', '--disable-gpu') + $arguments
    }

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $startInfo.FileName = $BrowserInfo.Path
    $startInfo.UseShellExecute = $false
    $startInfo.WindowStyle = if ($Visible.IsPresent) {
        [System.Diagnostics.ProcessWindowStyle]::Normal
    }
    else {
        [System.Diagnostics.ProcessWindowStyle]::Hidden
    }
    $startInfo.CreateNoWindow = -not $Visible.IsPresent
    foreach ($argument in $arguments) { [void]$startInfo.ArgumentList.Add([string]$argument) }

    # Authentication is sent only over CDP after browser startup. Child browser
    # processes do not inherit the plaintext process variables.
    [void]$startInfo.Environment.Remove('PSUDefaultAdminName')
    [void]$startInfo.Environment.Remove('PSUDefaultAdminPassword')
    $script:BrowserProcess = [System.Diagnostics.Process]::Start($startInfo)

    $portFile = Join-Path $profilePath 'DevToolsActivePort'
    $deadline = (Get-Date).AddSeconds(45)
    [int]$port = 0
    do {
        if (Test-Path -LiteralPath $portFile -PathType Leaf) {
            try {
                $portText = [System.IO.File]::ReadAllText($portFile)
                $candidate = @($portText -split '\r?\n')[0].Trim()
                if ([int]::TryParse($candidate, [ref]$port) -and $port -gt 0) { break }
            }
            catch [System.IO.IOException] { $port = 0 }
        }
        Start-Sleep -Milliseconds 150
    } while ((Get-Date) -lt $deadline)

    if ($port -le 0) {
        $exitText = if ($script:BrowserProcess.HasExited) { "; exitcode $($script:BrowserProcess.ExitCode)" } else { '' }
        throw "Browser leverde geen lokale CDP-poort$exitText."
    }

    $targetDeadline = (Get-Date).AddSeconds(45)
    $target = $null
    do {
        try {
            $targetResponse = Invoke-RestMethod -Uri "http://127.0.0.1:$port/json/list" -NoProxy -TimeoutSec 5
            [array]$targets = @($targetResponse)
            $target = $targets | Where-Object {
                $_.type -eq 'page' -and (
                    [string]$_.url -like "*$($AppUri.AbsolutePath)*" -or
                    [string]$_.url -like '*/login*'
                )
            } | Select-Object -First 1
            if ($null -eq $target) {
                $target = $targets | Where-Object { $_.type -eq 'page' } | Select-Object -First 1
            }
        }
        catch { $target = $null }
        if ($null -eq $target) { Start-Sleep -Milliseconds 250 }
    } while ($null -eq $target -and (Get-Date) -lt $targetDeadline)

    if ($null -eq $target -or [string]::IsNullOrWhiteSpace([string]$target.webSocketDebuggerUrl)) {
        throw 'Geen bestuurbaar browsertabblad gevonden.'
    }
    [pscustomobject]@{
        Port = $port
        WebSocketUri = [uri][string]$target.webSocketDebuggerUrl
    }
}

function Connect-UamCdp {
    param([Parameter(Mandatory)][uri]$WebSocketUri)
    $localBuilder = [System.UriBuilder]::new($WebSocketUri)
    $localBuilder.Host = '127.0.0.1'
    [UamLocalWebSocket]::Connect($localBuilder.Uri)
}

function Invoke-UamCdpCommand {
    param(
        [Parameter(Mandatory)][string]$Method,
        [hashtable]$Parameters = @{},
        [ValidateRange(1, 120)][int]$TimeoutSeconds = 30
    )

    $script:CdpMessageId++
    $messageId = $script:CdpMessageId
    $payload = @{ id = $messageId; method = $Method; params = $Parameters } | ConvertTo-Json -Compress -Depth 40
    $script:CdpSocket.SendText($payload)

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $remaining = [Math]::Max(1, [int][Math]::Ceiling(($deadline - (Get-Date)).TotalMilliseconds))
        $message = ($script:CdpSocket.ReceiveText($remaining) | ConvertFrom-Json -Depth 50)

        if ($null -eq $message.PSObject.Properties['id'] -or [int]$message.id -ne $messageId) { continue }
        if ($null -ne $message.PSObject.Properties['error']) {
            throw "CDP-opdracht '$Method' is mislukt."
        }
        if ($null -eq $message.PSObject.Properties['result']) { return $null }
        return $message.result
    }
    throw "Timeout tijdens CDP-opdracht '$Method'."
}

function Invoke-UamEvaluate {
    param(
        [Parameter(Mandatory)][string]$Expression,
        [ValidateRange(1, 120)][int]$TimeoutSeconds = 30
    )
    $response = Invoke-UamCdpCommand -Method 'Runtime.evaluate' -Parameters @{
        expression = $Expression
        returnByValue = $true
        awaitPromise = $true
        userGesture = $true
    } -TimeoutSeconds $TimeoutSeconds
    if ($null -ne $response.PSObject.Properties['exceptionDetails']) {
        $details = $response.exceptionDetails
        $line = if ($null -ne $details.PSObject.Properties['lineNumber']) { [int]$details.lineNumber + 1 } else { 0 }
        $column = if ($null -ne $details.PSObject.Properties['columnNumber']) { [int]$details.columnNumber + 1 } else { 0 }
        throw "JavaScript-fout in de privacyveilige browserhelper (regel $line, kolom $column)."
    }
    if ($null -eq $response.result -or $null -eq $response.result.PSObject.Properties['value']) { return $null }
    $response.result.value
}

function Wait-UamDocumentReady {
    param([int]$TimeoutSeconds = 60)
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        try {
            $state = Invoke-UamEvaluate -Expression "({ready:document.readyState,origin:location.origin,path:location.pathname})" -TimeoutSeconds 5
            if ($state.ready -in @('interactive', 'complete')) { return $state }
        }
        catch { }
        Start-Sleep -Milliseconds 300
    } while ((Get-Date) -lt $deadline)
    throw 'De browserpagina werd niet tijdig gereed.'
}

function Invoke-UamLogin {
    [string]$username = [Environment]::GetEnvironmentVariable('PSUDefaultAdminName', 'Process')
    [string]$password = [Environment]::GetEnvironmentVariable('PSUDefaultAdminPassword', 'Process')
    if ([string]::IsNullOrWhiteSpace($username) -or [string]::IsNullOrWhiteSpace($password)) {
        throw 'PSUDefaultAdminName en PSUDefaultAdminPassword ontbreken in de procesomgeving.'
    }

    $expectedOriginJson = $AppUri.GetLeftPart([System.UriPartial]::Authority) | ConvertTo-Json -Compress
    $expectedPathJson = $AppUri.AbsolutePath | ConvertTo-Json -Compress
    [string]$globalObjectId = ''
    try {
        $global = Invoke-UamCdpCommand -Method 'Runtime.evaluate' -Parameters @{ expression = 'globalThis'; returnByValue = $false }
        $globalObjectId = [string]$global.result.objectId
        if ([string]::IsNullOrWhiteSpace($globalObjectId)) { throw 'Logincontext kon niet worden geopend.' }

        $response = Invoke-UamCdpCommand -Method 'Runtime.callFunctionOn' -Parameters @{
            objectId = $globalObjectId
            functionDeclaration = @'
async function(usernameValue, passwordValue, expectedOrigin, expectedPath) {
  if (location.origin !== expectedOrigin || location.pathname.toLowerCase() !== '/login') return 'unexpected-location';
  const forms = [...document.querySelectorAll('form')].filter(form => {
    const action = new URL(form.action, location.href);
    return action.origin === expectedOrigin && action.pathname === '/api/v1/signin/form';
  });
  if (forms.length !== 1) return `form-count-${forms.length}`;
  const action = new URL(forms[0].action, location.href);
  const returnUrl = action.searchParams.get('returnurl') || action.searchParams.get('returnUrl') || '';
  if (returnUrl && returnUrl.toLowerCase() !== expectedPath.toLowerCase()) return 'return-url';
  const body = new URLSearchParams();
  body.set('username', usernameValue);
  body.set('password', passwordValue);
  const login = await fetch(action.href, {
    method: 'POST',
    headers: {'Content-Type':'application/x-www-form-urlencoded'},
    body: body.toString(),
    credentials: 'same-origin',
    redirect: 'follow',
    cache: 'no-store'
  });
  body.delete('username'); body.delete('password');
  if (!login.ok) return `http-${login.status}`;
  const finalUrl = new URL(login.url);
  if (finalUrl.origin !== expectedOrigin) return 'final-origin';
  if (finalUrl.pathname.toLowerCase() === '/login') return 'not-authenticated';
  return 'authenticated';
}
'@
            arguments = @(
                @{ value = $username },
                @{ value = $password },
                @{ value = ($expectedOriginJson | ConvertFrom-Json) },
                @{ value = ($expectedPathJson | ConvertFrom-Json) }
            )
            returnByValue = $true
            awaitPromise = $true
            userGesture = $true
        } -TimeoutSeconds ([Math]::Min(120, $LoginTimeoutSeconds))
        if ([string]$response.result.value -ne 'authenticated') {
            throw "PSU-login is niet gelukt (controlecode: $([string]$response.result.value))."
        }
    }
    finally {
        if (-not [string]::IsNullOrWhiteSpace($globalObjectId)) {
            try { [void](Invoke-UamCdpCommand -Method 'Runtime.releaseObject' -Parameters @{ objectId = $globalObjectId } -TimeoutSeconds 5) }
            catch { }
        }
        $username = $null
        $password = $null
    }

    [void](Invoke-UamCdpCommand -Method 'Page.navigate' -Parameters @{ url = $AppUri.AbsoluteUri } -TimeoutSeconds 10)
}

function Wait-UamAppReady {
    $pathJson = $AppUri.AbsolutePath | ConvertTo-Json -Compress
    $deadline = (Get-Date).AddSeconds($LoginTimeoutSeconds)
    $lastState = $null
    $lastExceptionType = ''
    do {
        try {
            $state = Invoke-UamEvaluate -Expression @"
(() => ({
  ready: document.readyState === 'complete',
  origin: location.origin,
  path: location.pathname,
  login: location.pathname.toLowerCase() === '/login',
  body: !!document.body && document.body.innerText.trim().length > 0,
  expected: location.pathname.toLowerCase().startsWith(($pathJson).toLowerCase())
}))()
"@ -TimeoutSeconds 5
            $lastState = $state
            if ($state.ready -and $state.body -and $state.expected -and -not $state.login) { return }
        }
        catch { $lastExceptionType = $_.Exception.GetType().FullName }
        Start-Sleep -Milliseconds 500
    } while ((Get-Date) -lt $deadline)
    if ($null -ne $lastState) {
        throw "De UAM-app werd niet tijdig gereed (origin=$([string]$lastState.origin); pad=$([string]$lastState.path); ready=$([bool]$lastState.ready); login=$([bool]$lastState.login); body=$([bool]$lastState.body); expected=$([bool]$lastState.expected))."
    }
    throw "De UAM-app werd niet tijdig gereed; structurele status kon niet worden gelezen (fouttype=$lastExceptionType)."
}

function Wait-UamUiSettled {
    param([int]$TimeoutSeconds = 30)
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    do {
        $busy = Invoke-UamEvaluate -Expression @'
(() => {
  const visible = e => !!(e && e.getClientRects().length && getComputedStyle(e).visibility !== 'hidden');
  return [...document.querySelectorAll('[role="progressbar"],.MuiCircularProgress-root,.udx-table-loading')].some(visible);
})()
'@ -TimeoutSeconds 5
        if (-not $busy) { Start-Sleep -Milliseconds 600; return }
        Start-Sleep -Milliseconds 300
    } while ((Get-Date) -lt $deadline)
}

function Set-UamPrivacyMask {
    $labelJson = ("$EnvironmentLabel · READ-ONLY DOCUMENTATIE") | ConvertTo-Json -Compress
    $expression = @'
(() => {
  let style = document.getElementById('uamDocPrivacyStyle');
  if (!style) {
    style = document.createElement('style');
    style.id = 'uamDocPrivacyStyle';
    style.textContent = `
      tbody, [role="rowgroup"] [role="row"]:not(:first-child), .MuiDataGrid-virtualScrollerContent { filter: blur(7px) !important; }
      tbody *, [role="rowgroup"] [role="row"]:not(:first-child) * { user-select:none !important; }
      canvas { filter: blur(10px) saturate(.45) !important; }
      input, textarea { -webkit-text-security: disc !important; }
      [aria-label*="account" i] span, [aria-label*="user" i] span, a[href*="account" i] span { color:transparent !important; }
      #uamDocEnvironmentBadge { position:fixed; right:18px; top:14px; z-index:2147483647; padding:8px 12px;
        border-radius:7px; background:#7f1d1d; color:#fff; font:700 13px/1.2 Segoe UI,sans-serif;
        box-shadow:0 3px 12px rgba(15,23,42,.35); pointer-events:none; }
      #uamDocPrivacyNotice { position:fixed; right:18px; bottom:14px; z-index:2147483647; padding:7px 11px;
        border-radius:7px; background:rgba(15,23,42,.92); color:#fff; font:600 12px/1.2 Segoe UI,sans-serif;
        pointer-events:none; }
    `;
    document.head.appendChild(style);
  }
  let badge = document.getElementById('uamDocEnvironmentBadge');
  if (!badge) { badge=document.createElement('div'); badge.id='uamDocEnvironmentBadge'; document.body.appendChild(badge); }
  badge.textContent = __UAM_ENVIRONMENT_LABEL__;
  let notice = document.getElementById('uamDocPrivacyNotice');
  if (!notice) { notice=document.createElement('div'); notice.id='uamDocPrivacyNotice'; document.body.appendChild(notice); }
  notice.textContent = 'Operationele gegevens visueel afgeschermd';
  return true;
})()
'@
    $expression = $expression.Replace('__UAM_ENVIRONMENT_LABEL__', $labelJson)
    [void](Invoke-UamEvaluate -Expression $expression)
}

function Get-UamSafeUiInventory {
    Invoke-UamEvaluate -Expression @'
(() => {
  const visible=e=>!!(e&&e.getClientRects().length&&getComputedStyle(e).visibility!=='hidden'&&getComputedStyle(e).display!=='none');
  const clean=s=>String(s||'').replace(/\s+/g,' ').trim().slice(0,80);
  return {
    title: clean(document.title),
    path: location.pathname,
    tabs: [...document.querySelectorAll('[role="tab"]')].filter(visible).map(e=>clean(e.innerText)).filter(Boolean),
    tables: [...document.querySelectorAll('table,[role="grid"]')].filter(visible).length,
    searchControls: [...document.querySelectorAll('input[type="search"],input[type="text"]')].filter(e=>visible(e)&&/zoek|search|filter/i.test(`${e.placeholder||''} ${e.getAttribute('aria-label')||''}`)).length,
    sortableHeaders: [...document.querySelectorAll('th button,[role="columnheader"] button')].filter(visible).length,
    nextPageControls: [...document.querySelectorAll('button')].filter(e=>visible(e)&&!/true/i.test(e.getAttribute('disabled')||'')&&/next page|volgende pagina/i.test(`${e.getAttribute('aria-label')||''} ${e.title||''}`)).length
  };
})()
'@
}

function Invoke-UamTabClick {
    param([Parameter(Mandatory)][string]$Label)
    $labelJson = $Label | ConvertTo-Json -Compress
    $safeCustomLabelsJson = @('Device Types', 'Scripts', 'Planningen (Schedules)', 'Reference Data') | ConvertTo-Json -Compress
    Invoke-UamEvaluate -Expression @"
(() => {
  const visible=e=>!!(e&&e.getClientRects().length&&getComputedStyle(e).visibility!=='hidden'&&getComputedStyle(e).display!=='none');
  const clean=s=>String(s||'').replace(/\s+/g,' ').trim();
  const expected=$labelJson;
  const safeCustomLabels=$safeCustomLabelsJson;
  const matches=[...document.querySelectorAll('[role="tab"]')].filter(e=>visible(e)&&clean(e.innerText).toLowerCase()===expected.toLowerCase());
  if (matches.length) {
    matches[matches.length-1].click();
    return {clicked:true,label:expected,selector:'role=tab'};
  }
  if (!safeCustomLabels.some(label=>label.toLowerCase()===expected.toLowerCase())) return {clicked:false,label:expected};
  const custom=[...document.querySelectorAll('button,a')].filter(e=>
    visible(e) && clean(e.innerText).toLowerCase()===expected.toLowerCase() &&
    !e.closest('form,tbody,[role="dialog"]') && String(e.type||'').toLowerCase()!=='submit'
  );
  if (!custom.length) return {clicked:false,label:expected};
  custom[custom.length-1].click();
  return {clicked:true,label:expected,selector:'explicit-readonly-subtab'};
})()
"@
}

function Invoke-UamReadInteraction {
    # Only these three selector families are permitted. No ordinary app action
    # button, row action, menu option or form submit is ever clicked.
    Invoke-UamEvaluate -Expression @'
(async () => {
  const visible=e=>!!(e&&e.getClientRects().length&&getComputedStyle(e).visibility!=='hidden'&&getComputedStyle(e).display!=='none');
  const clean=s=>String(s||'').replace(/\s+/g,' ').trim().slice(0,80);
  const input=[...document.querySelectorAll('input[type="search"],input[type="text"]')].find(e=>visible(e)&&/zoek|search|filter/i.test(`${e.placeholder||''} ${e.getAttribute('aria-label')||''}`));
  if (input) {
    const setter=Object.getOwnPropertyDescriptor(HTMLInputElement.prototype,'value').set;
    setter.call(input,'__uam_documentation_readonly__');
    input.dispatchEvent(new Event('input',{bubbles:true}));
    input.dispatchEvent(new Event('change',{bubbles:true}));
    await new Promise(r=>setTimeout(r,900));
    return {performed:true,kind:'search',label:clean(input.placeholder||input.getAttribute('aria-label')||'Zoeken')};
  }
  const sort=[...document.querySelectorAll('th button,[role="columnheader"] button')].find(visible);
  if (sort) {
    sort.click(); await new Promise(r=>setTimeout(r,900));
    return {performed:true,kind:'sort',label:clean(sort.closest('th,[role="columnheader"]')?.innerText||sort.getAttribute('aria-label')||'Kolom')};
  }
  const next=[...document.querySelectorAll('button')].find(e=>visible(e)&&!e.disabled&&/next page|volgende pagina/i.test(`${e.getAttribute('aria-label')||''} ${e.title||''}`));
  if (next) {
    next.click(); await new Promise(r=>setTimeout(r,900));
    return {performed:true,kind:'pagination',label:'Volgende pagina'};
  }
  return {performed:false,kind:'none',label:''};
})()
'@
}

function Restore-UamReadInteraction {
    param([Parameter(Mandatory)][string]$Kind)
    $kindJson = $Kind | ConvertTo-Json -Compress
    $expression = @'
(async () => {
  const visible=e=>!!(e&&e.getClientRects().length&&getComputedStyle(e).visibility!=='hidden'&&getComputedStyle(e).display!=='none');
  const kind=__UAM_INTERACTION_KIND__;
  if (kind==='search') {
    const input=[...document.querySelectorAll('input[type="search"],input[type="text"]')].find(e=>visible(e)&&e.value==='__uam_documentation_readonly__');
    if (input) { const setter=Object.getOwnPropertyDescriptor(HTMLInputElement.prototype,'value').set; setter.call(input,''); input.dispatchEvent(new Event('input',{bubbles:true})); input.dispatchEvent(new Event('change',{bubbles:true})); }
  } else if (kind==='sort') {
    const sort=[...document.querySelectorAll('th button,[role="columnheader"] button')].find(visible); if(sort) sort.click();
  } else if (kind==='pagination') {
    const previous=[...document.querySelectorAll('button')].find(e=>visible(e)&&!e.disabled&&/previous page|vorige pagina/i.test(`${e.getAttribute('aria-label')||''} ${e.title||''}`)); if(previous) previous.click();
  }
  await new Promise(r=>setTimeout(r,500)); return true;
})()
'@
    $expression = $expression.Replace('__UAM_INTERACTION_KIND__', $kindJson)
    [void](Invoke-UamEvaluate -Expression $expression)
}

function ConvertTo-UamFileSlug {
    param([Parameter(Mandatory)][string]$Text)
    $slug = $Text.ToLowerInvariant() -replace '[^a-z0-9]+', '-'
    $slug.Trim('-')
}

function Save-UamScreenshot {
    param([Parameter(Mandatory)][string]$Path)
    Set-UamPrivacyMask
    $capture = Invoke-UamCdpCommand -Method 'Page.captureScreenshot' -Parameters @{
        format = 'png'
        fromSurface = $true
        captureBeyondViewport = $false
    } -TimeoutSeconds 45
    [System.IO.File]::WriteAllBytes($Path, [Convert]::FromBase64String([string]$capture.data))
}

function Stop-UamBrowser {
    if (-not [string]::IsNullOrWhiteSpace($script:BrowserProfilePath)) {
        try {
            $profile = [System.IO.Path]::GetFullPath($script:BrowserProfilePath)
            $tempRoot = [System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()).TrimEnd('\') + '\'
            if ($profile.StartsWith($tempRoot, [System.StringComparison]::OrdinalIgnoreCase) -and
                [System.IO.Path]::GetFileName($profile).StartsWith('uam-logging-doc-', [System.StringComparison]::Ordinal)) {
                Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
                    Where-Object { $_.CommandLine -like "*$profile*" } |
                    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
                Start-Sleep -Milliseconds 400
                if (Test-Path -LiteralPath $profile -PathType Container) { Remove-Item -LiteralPath $profile -Recurse -Force }
            }
        }
        catch { Write-Verbose 'Het tijdelijke browserprofiel kon niet volledig worden opgeruimd.' }
    }
}

$outputRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
[void](New-Item -ItemType Directory -Path $outputRoot -Force)
$browserInfo = Get-UamBrowserInfo
$walkthrough = [ordered]@{
    Environment = $EnvironmentLabel
    AppUri = $AppUri.AbsoluteUri
    Browser = $browserInfo.Name
    StartedAtUtc = [DateTime]::UtcNow
    Safety = [ordered]@{
        Navigation = 'role=tab only'
        Interactions = @('search/filter input', 'sortable column header', 'previous/next pagination')
        MutatingActions = 'not permitted'
        ScreenshotMasking = @('table bodies', 'grid rows', 'input values', 'canvas labels', 'account labels')
    }
    Screens = [System.Collections.Generic.List[object]]::new()
}

try {
    $browserState = Start-UamBrowser -BrowserInfo $browserInfo
    $script:CdpSocket = Connect-UamCdp -WebSocketUri $browserState.WebSocketUri
    [void](Invoke-UamCdpCommand -Method 'Page.enable')
    [void](Invoke-UamCdpCommand -Method 'Runtime.enable')
    $state = Wait-UamDocumentReady -TimeoutSeconds 75
    if ([string]$state.path -eq '/login') {
        if (-not $InteractiveLogin.IsPresent) {
            Invoke-UamLogin
        }
    }
    elseif (-not ([string]$state.path).StartsWith($AppUri.AbsolutePath, [System.StringComparison]::OrdinalIgnoreCase)) {
        [void](Invoke-UamCdpCommand -Method 'Page.navigate' -Parameters @{ url = $AppUri.AbsoluteUri })
    }
    Wait-UamAppReady
    Wait-UamUiSettled

    $initialPath = Join-Path $outputRoot '00-start.png'
    Save-UamScreenshot -Path $initialPath
    $walkthrough.Screens.Add([pscustomobject]@{
        Sequence = 0
        Screen = 'Start'
        Screenshot = [System.IO.Path]::GetFileName($initialPath)
        Inventory = Get-UamSafeUiInventory
        Interaction = [pscustomobject]@{ performed = $false; kind = 'none'; label = '' }
    })

    [array]$screenLabels = @(
        'Logging Users',
        'User Grids',
        'Organogram',
        'Logging Data',
        'Device Scripts & Schedules',
        'Device Types',
        'Scripts',
        'Planningen (Schedules)',
        'Reference Data',
        'UAM Settings',
        'Global Settings',
        'Process Exclusions',
        'Browser Logging Exclusions',
        'Application Matches',
        'Errors',
        'Audit Log'
    )

    [int]$sequence = 0
    foreach ($label in $screenLabels) {
        $click = Invoke-UamTabClick -Label $label
        if (-not [bool]$click.clicked) {
            $walkthrough.Screens.Add([pscustomobject]@{
                Sequence = ++$sequence
                Screen = $label
                Screenshot = $null
                Inventory = $null
                Interaction = [pscustomobject]@{ performed = $false; kind = 'tab-not-found'; label = $label }
            })
            continue
        }
        Wait-UamUiSettled
        Set-UamPrivacyMask
        $baseName = ('{0:D2}-{1}' -f (++$sequence), (ConvertTo-UamFileSlug -Text $label))
        $screenPath = Join-Path $outputRoot ($baseName + '.png')
        Save-UamScreenshot -Path $screenPath

        $interaction = Invoke-UamReadInteraction
        $interactionScreenshot = $null
        if ([bool]$interaction.performed) {
            Wait-UamUiSettled
            $interactionPath = Join-Path $outputRoot ($baseName + '-read-interaction.png')
            Save-UamScreenshot -Path $interactionPath
            $interactionScreenshot = [System.IO.Path]::GetFileName($interactionPath)
            Restore-UamReadInteraction -Kind ([string]$interaction.kind)
            Wait-UamUiSettled
        }

        $walkthrough.Screens.Add([pscustomobject]@{
            Sequence = $sequence
            Screen = $label
            Screenshot = [System.IO.Path]::GetFileName($screenPath)
            InteractionScreenshot = $interactionScreenshot
            Inventory = Get-UamSafeUiInventory
            Interaction = $interaction
        })
    }
    $walkthrough.CompletedAtUtc = [DateTime]::UtcNow
    $walkthrough.Result = 'Completed'
}
catch {
    $walkthrough.CompletedAtUtc = [DateTime]::UtcNow
    $walkthrough.Result = 'Failed'
    $walkthrough.ErrorType = $_.Exception.GetType().FullName
    $walkthrough.ErrorMessage = $_.Exception.Message
    throw
}
finally {
    if ($null -ne $script:CdpSocket) {
        try { $script:CdpSocket.Dispose() } catch { }
    }
    Stop-UamBrowser
    $manifestPath = Join-Path $outputRoot 'walkthrough.json'
    $walkthrough | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $manifestPath -Encoding utf8
}

$walkthrough
