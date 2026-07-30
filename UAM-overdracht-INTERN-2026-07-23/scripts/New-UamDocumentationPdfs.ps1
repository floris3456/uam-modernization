#requires -Version 7.2
<#
.SYNOPSIS
    Converts the UAM Markdown handover set to styled HTML and PDF deliverables.

.DESCRIPTION
    Uses PowerShell's built-in Markdown converter and local headless Chrome.
    Relative image references are resolved to local file URIs. No network
    content is loaded during generation.
#>
[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $PSScriptRoot '..'),
    [string]$ChromePath = 'C:\Program Files\Google\Chrome\Application\chrome.exe',
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\deliverables\pdf'),
    [string]$HtmlDirectory = (Join-Path $PSScriptRoot '..\deliverables\html')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Web
$root = [IO.Path]::GetFullPath($ProjectRoot)
$pdfRoot = [IO.Path]::GetFullPath($OutputDirectory)
$htmlRoot = [IO.Path]::GetFullPath($HtmlDirectory)
[void][IO.Directory]::CreateDirectory($pdfRoot)
[void][IO.Directory]::CreateDirectory($htmlRoot)
if (-not (Test-Path -LiteralPath $ChromePath -PathType Leaf)) { throw "Chrome ontbreekt: $ChromePath" }

$specifications = @(
    [pscustomobject]@{
        Name='UAM-IST-samenvatting-A4'; Title='UAM IST in een oogopslag'; Subtitle='Korte management- en overdrachtssamenvatting'; Mode='summary'; Orientation='portrait'; Files=@('docs\00a-uam-ist-samenvatting-a4.md')
    },
    [pscustomobject]@{
        Name='UAM-doelbeeld-samenvatting-A4'; Title='UAM gewenst doelbeeld in een oogopslag'; Subtitle='Korte samenvatting van wensen en aanbevolen C#-richting'; Mode='summary'; Orientation='portrait'; Files=@('docs\00b-uam-doelbeeld-samenvatting-a4.md')
    },
    [pscustomobject]@{
        Name='UAM-legacy-overdrachtsdossier'; Title='UAM legacy overdrachtsdossier'; Subtitle='Legacy agent, IST/DOEL-samenvattingen, C#-doelarchitectuur en migratieroadmap'; Mode='standard'; Orientation='portrait'; Files=@('docs\00a-uam-ist-samenvatting-a4.md','docs\00b-uam-doelbeeld-samenvatting-a4.md','docs\01-legacy-agent-uam-ps1.md','docs\04-csharp-target-architecture.md','docs\05-migration-map-roadmap.md')
    },
    [pscustomobject]@{
        Name='UAM-databasemodel-en-data-dictionary'; Title='UAM legacy databasemodel en data dictionary'; Subtitle='27 tabellen, 569 velden, relaties, productieprofiel en migratiebeoordeling'; Mode='database'; Orientation='landscape'; Files=@('docs\02-legacy-database-model.md','docs\appendices\legacy-data-dictionary.md')
    },
    [pscustomobject]@{
        Name='UAM-PSU-app-IST'; Title='UAM PowerShell Universal-app — IST'; Subtitle='Functionele schermbeschrijving met privacygemaskeerde DEV-opnamen'; Mode='portal'; Orientation='landscape'; Files=@('docs\03-psu-app-ist.md')
    }
)

$baseCss = @'
:root{--ink:#0f172a;--muted:#475569;--line:#cbd5e1;--blue:#1d4ed8;--soft:#f8fafc;--warn:#fff7ed}
*{box-sizing:border-box}body{font-family:"Segoe UI",Arial,sans-serif;color:var(--ink);line-height:1.36;margin:0;background:#fff;font-size:10pt}
h1{font-size:24pt;line-height:1.08;color:#0f172a;margin:0 0 8mm;border-bottom:2.5pt solid #2563eb;padding-bottom:3mm}h2{font-size:15pt;margin:7mm 0 2.5mm;color:#1e3a8a;break-after:avoid}h3{font-size:12pt;margin:5mm 0 2mm;color:#1e293b;break-after:avoid}
p{margin:0 0 3mm}ul,ol{margin:1.5mm 0 3mm;padding-left:6mm}li{margin:0 0 1.2mm}strong{color:#0f172a}a{color:#1d4ed8;text-decoration:none}
code{font-family:Consolas,monospace;background:#f1f5f9;padding:.1em .25em;border-radius:3px}pre{font-family:Consolas,monospace;font-size:8pt;background:#0f172a;color:#e2e8f0;padding:4mm;border-radius:6px;white-space:pre-wrap;break-inside:avoid}
table{width:100%;border-collapse:collapse;margin:3mm 0 5mm;font-size:8.3pt;break-inside:auto}thead{display:table-header-group}tr{break-inside:avoid}th{background:#dbeafe;color:#172554;text-align:left;font-weight:700}th,td{border:.5pt solid #cbd5e1;padding:1.6mm;vertical-align:top;overflow-wrap:anywhere}
img{display:block;max-width:100%;max-height:175mm;object-fit:contain;margin:4mm auto 7mm;break-inside:avoid;border:.5pt solid #cbd5e1;border-radius:4px}
blockquote{border-left:3pt solid #2563eb;margin:3mm 0;padding:2mm 4mm;background:#eff6ff}.document-section{position:relative}.document-section+.document-section{break-before:page}
.cover{height:250mm;display:flex;flex-direction:column;justify-content:center;padding:18mm;background:linear-gradient(145deg,#eff6ff,#fff 48%,#ecfeff);border:1pt solid #bfdbfe}.cover h1{font-size:31pt;border:0;margin:0 0 8mm}.cover .subtitle{font-size:16pt;color:#334155;max-width:155mm}.cover .meta{margin-top:28mm;font-size:10pt;color:#64748b}.cover .mark{font-size:9pt;letter-spacing:.18em;text-transform:uppercase;color:#1d4ed8;font-weight:700;margin-bottom:6mm}
.summary{font-size:9.8pt;line-height:1.25}.summary h1{font-size:23pt;margin-bottom:5mm;padding-bottom:2.5mm}.summary h2{font-size:13pt;margin:4.2mm 0 1.8mm}.summary p{margin-bottom:2.4mm}.summary ul,.summary ol{margin:1.2mm 0 2.4mm;padding-left:5.5mm}.summary li{margin-bottom:.8mm}.summary table{font-size:8.2pt;margin:2.2mm 0 3mm}.summary th,.summary td{padding:1.2mm}.summary .document-section{break-before:auto}.summary code{font-size:8pt}
.database{font-size:8pt;line-height:1.25}.database h1{font-size:20pt}.database h2{font-size:12pt;margin-top:4.5mm}.database h3{font-size:10pt}.database table{font-size:6.2pt;table-layout:auto}.database th,.database td{padding:.8mm}.database img{max-height:175mm}
.portal{font-size:9pt}.portal h1{font-size:22pt}.portal h2{font-size:14pt}.portal h3{font-size:11pt}.portal img{max-height:155mm;break-before:auto;box-shadow:0 2px 8px rgba(15,23,42,.12)}
@media print{.cover{break-after:page}a{color:inherit}body{-webkit-print-color-adjust:exact;print-color-adjust:exact}}
'@

function Convert-MarkdownFile {
    param([Parameter(Mandatory)][string]$Path)
    $fullPath = [IO.Path]::GetFullPath((Join-Path $root $Path))
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) { throw "Markdown ontbreekt: $fullPath" }
    $sourceDirectory = Split-Path -Parent $fullPath
    $markdown = Get-Content -LiteralPath $fullPath -Raw
    $fragment = (ConvertFrom-Markdown -InputObject $markdown).Html
    $fragment = [regex]::Replace($fragment,'(?i)(<img\b[^>]*\bsrc=")([^"]+)(")',{
        param($match)
        $source = $match.Groups[2].Value
        if ($source -match '^(data:|https?:|file:)') { return $match.Value }
        $resolved = [IO.Path]::GetFullPath((Join-Path $sourceDirectory ($source -replace '/','\')))
        if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) { throw "Afbeelding ontbreekt: $resolved (uit $fullPath)" }
        # Keep HTML portable inside the transfer set. deliverables/html and
        # artifacts retain the same relative layout on the recipient machine.
        $relative = [IO.Path]::GetRelativePath($htmlRoot,$resolved).Replace('\','/')
        $match.Groups[1].Value + $relative + $match.Groups[3].Value
    })
    "<section class=`"document-section`" data-source=`"$([System.Web.HttpUtility]::HtmlEncode($Path))`">$fragment</section>"
}

function New-CoverHtml {
    param($Specification)
    @"
<section class="cover">
  <div class="mark">UAM overdracht • intern technisch dossier</div>
  <h1>$([System.Web.HttpUtility]::HtmlEncode($Specification.Title))</h1>
  <div class="subtitle">$([System.Web.HttpUtility]::HtmlEncode($Specification.Subtitle))</div>
  <div class="meta">Versie 1.0 • 23 juli 2026<br>Bronnen gefixeerd met SHA-256 • geen tokens of wachtwoorden opgenomen</div>
</section>
"@
}

$profilePath = Join-Path ([IO.Path]::GetTempPath()) ('uam-doc-pdf-' + [guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($profilePath)
try {
    foreach ($specification in $specifications) {
        $body = [System.Text.StringBuilder]::new()
        if ($specification.Mode -ne 'summary') { [void]$body.AppendLine((New-CoverHtml $specification)) }
        foreach ($file in $specification.Files) { [void]$body.AppendLine((Convert-MarkdownFile $file)) }
        $pageRule = if ($specification.Orientation -eq 'landscape') { '@page{size:A4 landscape;margin:10mm}' } elseif ($specification.Mode -eq 'summary') { '@page{size:A4 portrait;margin:8mm}' } else { '@page{size:A4 portrait;margin:15mm}' }
        $html = @"
<!doctype html><html lang="nl"><head><meta charset="utf-8"><title>$([System.Web.HttpUtility]::HtmlEncode($specification.Title))</title><style>$pageRule$baseCss</style></head><body class="$($specification.Mode)">$body</body></html>
"@
        $htmlPath = Join-Path $htmlRoot ($specification.Name + '.html')
        $pdfPath = Join-Path $pdfRoot ($specification.Name + '.pdf')
        [IO.File]::WriteAllText($htmlPath,$html,[Text.UTF8Encoding]::new($false))
        $htmlUri = [uri]$htmlPath
        & $ChromePath '--headless=new' '--disable-gpu' '--allow-file-access-from-files' '--no-pdf-header-footer' "--user-data-dir=$profilePath" "--print-to-pdf=$pdfPath" $htmlUri.AbsoluteUri | Out-Null
        if (-not (Test-Path -LiteralPath $pdfPath -PathType Leaf)) { throw "PDF ontbreekt: $pdfPath" }
        if ((Get-Item -LiteralPath $pdfPath).Length -lt 10000) { throw "PDF is onverwacht klein: $pdfPath" }
    }
}
finally {
    if (Test-Path -LiteralPath $profilePath -PathType Container) {
        $resolved = [IO.Path]::GetFullPath($profilePath)
        $temp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath())
        if ($resolved.StartsWith($temp,[StringComparison]::OrdinalIgnoreCase) -and (Split-Path $resolved -Leaf).StartsWith('uam-doc-pdf-')) {
            Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Get-ChildItem -LiteralPath $pdfRoot -Filter '*.pdf' | Select-Object Name,Length,LastWriteTime
