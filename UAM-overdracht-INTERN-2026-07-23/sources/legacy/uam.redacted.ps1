##############################################################################
# VERBETER PUNTEN
##############################################################################
# Hoge Prio:
# 1) Complete History ophalen als er nog nooit gelogd is (en dat is dan vooral voor browser hist en recent files)
# 2) Last History max date per browser vast te gaan houden
# 3) Bij wegschrijven UAMprocessMaxMemoryMB (tijdens defer verwerking) ook even UAMprocessMinMemoryMB (nieuw) gaan weggeschrijven en ook datetimeDiffer2DB (nieuw). En ook opnemen in dashboard
#
# Middel Prio:
# 1) Als er nog geen user log record is, dan geen foutmelding
# 2) In Userlog tabel meer en beter vastleggen zoals: complete path uam process
#
# Lage Prio:
# 1) Get-AppSettings aanpassen zodat als je scope user ophaald dat de global niet verwijderd worden
# 2)  
##############################################################################

[CmdletBinding()]
param
(
	[Parameter(Position=0)]
	$SecureConnectionString
)


#############################################################################################################################################
## Variabelen
#############################################################################################################################################

$Global:ProjectName = 'UAM'
$Global:ScriptStartTime = Get-Date
$Global:EnableTranscript = $true    # Wordt later nog bepaald dmv Get-AppSettings 
$Global:CurrentTranscriptFile = ""  # Begin leeg


#############################################################################################################################################
## Controle of UAM.exe elevated draait (voor bepaalde functies zoals killen andere uam.exe sessies (en loggen naar Program Files of het lezen van bepaalde browser data is dat nodig)
#############################################################################################################################################

function Get-CurrentExecutableName {
    <#
    .SYNOPSIS
        Haalt betrouwbaar de naam van het huidige uitvoerende proces op, inclusief .exe.
    .DESCRIPTION
        Deze functie gebruikt de automatische $PID variabele om het huidige proces te identificeren
        en haalt vervolgens de bestandsnaam uit de MainModule. Dit werkt consistent,
        ongeacht of het script draait in ISE, VS Code, een standaard console,
        met of zonder administratorrechten, of is gecompileerd naar een .exe.
    #>
    
    try {
        # Stap 1: Haal het huidige proces op basis van de ingebouwde $PID variabele
        $CurrentProcess = Get-Process -Id $PID -ErrorAction Stop
        
        # Stap 2: Haal de bestandsnaam op uit het fysieke pad (MainModule)
        [string]$ProcessName = [System.IO.Path]::GetFileName($CurrentProcess.MainModule.FileName)
        
        # Stap 3: Controleer of de string leeg is
        if ([string]::IsNullOrWhiteSpace($ProcessName)) {
            # Fallback: als MainModule faalt, gebruik de procesnaam en voeg .exe toe
            $ProcessName = "$($CurrentProcess.ProcessName).exe"
        }
        
        # Stap 4: Controleer expliciet of de naam eindigt op .exe (hoofdletterongevoelig)
        if ($ProcessName -notmatch '(?i)\.exe$') {
            $ProcessName = "$ProcessName.exe"
        }
        
        return $ProcessName
    }
    catch {
        # Laatste redmiddel bij fatale fouten (bijv. extreme restricties)
        Write-Warning "Fout bij ophalen procesnaam: $($_.Exception.Message)"
        return "powershell.exe" # Of een andere veilige default
    }
}

#############################################################################################################################################
Function Test-IsElevated {
#############################################################################################################################################
    [CmdletBinding()]
    param()

    try {
        # Haal de identiteit van het huidige PowerShell proces op
        $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        
        # Koppel de identiteit aan een Principal object om de rechten te kunnen lezen
        $Principal = [System.Security.Principal.WindowsPrincipal]::new($Identity)
        
        # Definieer de ingebouwde Administrator rol
        $AdminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
        
        # Controleer of we die rol bezitten
        [bool]$IsAdmin = $Principal.IsInRole($AdminRole)
        
        return [bool]$IsAdmin
    } 
    catch {
        # Bij een onverwachte fout (bijv. corrupte token) gaan we uit van veiligheid: géén admin
        Write-Host "Fout bij controleren van Elevated status = $($_.Exception.Message)" -ForegroundColor DarkYellow
        return [bool]$false
    }
}

#############################################################################################################################################
## DLL libs
#############################################################################################################################################

# Definieer de DLL koppeling éénmalig voor de hele sessie
$WinSqliteCode = @"
using System;
using System.Runtime.InteropServices;
public class WinSqliteHybride {
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_open(string filename, out IntPtr db);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_close(IntPtr db);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_prepare_v2(IntPtr db, string sql, int numBytes, out IntPtr stmt, IntPtr tail);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_step(IntPtr stmt);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_column_count(IntPtr stmt);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr sqlite3_column_name(IntPtr stmt, int index);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr sqlite3_column_text(IntPtr stmt, int index);
    [DllImport("winsqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_finalize(IntPtr stmt);
}
"@

# Laad de definitie in PowerShell (als dat nog niet gebeurd is)
if (-not ([System.Management.Automation.PSTypeName]"WinSqliteHybride").Type) {
    Add-Type -TypeDefinition $WinSqliteCode
}

#############################################################################################################################################
## SCHOONMAAK EN OPRUIM FUNCTIES 
#############################################################################################################################################

# --- Schoonmaak van oude tijdelijke mappen (Housekeeping) ---
$UamRoot = Join-Path $env:LOCALAPPDATA "UAM"
if (Test-Path $UamRoot) {
    # Zoek alle submappen in de browser-mappen die ouder zijn dan 2 uur
    Get-ChildItem -Path $UamRoot -Recurse -Directory | 
        Where-Object { $_.CreationTime -lt (Get-Date).AddHours(-2) } | 
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

#############################################################################################################################################
## START FUNCTIES 
#############################################################################################################################################

#### ==>> ALGEMENE FUNCTIES <<== ####

# ====================================================================
# Functie: Set-ProcesGeheugenBescherming
# Doel:    Voorkomt trimming van het RAM zonder CPU-prioriteit te wijzigen
# ====================================================================
function Set-ProcesGeheugenBescherming {
    try {
        [System.Diagnostics.Process]$HuidigProces = [System.Diagnostics.Process]::GetCurrentProcess()
        
        # We laten de CPU prioriteit bewust met rust (deze blijft op 'Normal')
        
        # Bescherm het geheugen (Anti-Trimming)
        # Bepaal het minimum én maximum geheugen in Megabytes. Pas dit aan naar wat je exe nodig heeft.
        [int]$MinimumGeheugenMB = 50
        [int]$MaximumGeheugenMB = 200
        
        [long]$NieuweMinBytes = $MinimumGeheugenMB * 1024 * 1024
        [long]$NieuweMaxBytes = $MaximumGeheugenMB * 1024 * 1024
        
        # Huidige grenzen ophalen
        [long]$HuidigeMax = [long]$HuidigProces.MaxWorkingSet

        # Bepalen van de juiste instelvolgorde om de .NET "Ongeldige minimumgrootte" fout te voorkomen
        if ($NieuweMinBytes -gt $HuidigeMax) {
            # Huidige Max is te laag: we moeten EERST de Max verhogen
            $HuidigProces.MaxWorkingSet = [System.IntPtr]::new($NieuweMaxBytes)
            $HuidigProces.MinWorkingSet = [System.IntPtr]::new($NieuweMinBytes)
        }
        else {
            # Veilige situatie: we kunnen EERST de Min instellen, daarna de Max aandraaien
            $HuidigProces.MinWorkingSet = [System.IntPtr]::new($NieuweMinBytes)
            $HuidigProces.MaxWorkingSet = [System.IntPtr]::new($NieuweMaxBytes)
        }
        
        Write-Log "Geheugen grenzen ingesteld -> Min: ${MinimumGeheugenMB}MB / Max: ${MaximumGeheugenMB}MB. Windows mag dit niet meer afsnoepen."
    }
    catch {
        # Foutafhandeling, bijvoorbeeld als het script niet als Admin draait
        [string]$Foutmelding = $_.Exception.Message
        Write-Log "Fout bij instellen minimum geheugen. Draait het script Elevated? Error = $Foutmelding"
    }
    finally {
        # Expliciet opruimen om handle leaks te voorkomen
        if ($null -ne $HuidigProces -and $HuidigProces -is [System.Diagnostics.Process]) {
            $HuidigProces.Dispose()
        }
    }
}


function Test-GroupMembership {
    <#
    .SYNOPSIS
        Extreme performance AD-check voor PS 5.1 & 7 zonder AD-module.
    .VERSION
        1.2.2
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserName,

        # Mandatory op false gezet om de harde PowerShell Parameter crash te voorkomen bij lege strings
        [Parameter(Mandatory = $false)]
        [string]$GroupPatterns = "" 
    )

    process {
        try {
            # 0. Elegante afhandeling: Als er geen pattern is opgegeven, is het antwoord per definitie false
            if ([string]::IsNullOrWhiteSpace($GroupPatterns)) {
                Write-Verbose "Geen GroupPatterns opgegeven (waarde is leeg of null). Return false."
                return [bool]$false
            }

            # 1. Haal de DN van de gebruiker op
            $UserSearcher = [adsisearcher]"(samAccountName=$UserName)"
            [void]$UserSearcher.PropertiesToLoad.Add("distinguishedname")
            $UserResult = $UserSearcher.FindOne()

            if ($null -eq $UserResult) {
                Write-Warning "Gebruiker '$UserName' niet gevonden."
                return [bool]$false
            }
            $UserDN = [string]$UserResult.Properties["distinguishedname"][0]

            # 2. Vind alle matchende groeps-DN's voor de opgegeven patronen
            $Patterns = [string[]]($GroupPatterns -split ';' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" })
            $GroupDNs = [System.Collections.Generic.List[string]]::new()

            foreach ($Pattern in $Patterns) {
                $EscapedPattern = [string]$Pattern.Replace("'", "''")
                $GroupSearcher = [adsisearcher]"(samAccountName=$EscapedPattern)"
                [void]$GroupSearcher.PropertiesToLoad.Add("distinguishedname")
                
                $Results = $GroupSearcher.FindAll()
                if ($null -ne $Results) {
                    foreach ($Res in $Results) { 
                        $DN = [string]$Res.Properties["distinguishedname"][0]
                        if (-not $GroupDNs.Contains($DN)) { [void]$GroupDNs.Add($DN) }
                    }
                }
            }

            if ($GroupDNs.Count -eq 0) {
                Write-Verbose "Geen groepen gevonden voor patronen: $GroupPatterns"
                return [bool]$false
            }

            # 3. BULK QUERY: Bouw één grote 'OR' query voor de server
            # OID 1.2.840.113556.1.4.1941 checkt de hele keten (nested groups)
            $OID = [string]"1.2.840.113556.1.4.1941"
            $GroupFilterParts = [System.Collections.Generic.List[string]]::new()
            foreach ($DN in $GroupDNs) {
                [void]$GroupFilterParts.Add("(memberOf:${OID}:=${DN})")
            }

            $JoinedParts = [string]($GroupFilterParts -join "")
            $FullFilter = [string]"(&(objectClass=user)(distinguishedName=${UserDN})(|${JoinedParts}))"
            
            # 4. Vuur de bulk-check af
            $BulkCheck = [adsisearcher]$FullFilter
            [void]$BulkCheck.PropertiesToLoad.Add("distinguishedname")
            
            $IsLid = [bool]($null -ne $BulkCheck.FindOne())

            return [bool]$IsLid

        } catch {
            Write-Error "Fout in Test-GGGroupMembership: $($_.Exception.Message)"
            return [bool]$false
        }
    }
}
function Test-HasContent {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,
        
        [switch]$Invert
    )

    process {
        $hasValue = $false

        # 1. Basis null en DBNull check (werkt in alle versies)
        if ($null -eq $InputObject -or $InputObject -is [System.DBNull]) {
            $hasValue = $false
        }
        # 2. Hashtables (IDictionary werkt in PS 5.1 en 7)
        elseif ($InputObject -is [System.Collections.IDictionary]) {
            if ($InputObject.Count -gt 0) {
                foreach ($val in $InputObject.Values) {
                    if ($null -ne $val -and ([string]$val).Trim() -ne "") {
                        $hasValue = $true
                        break
                    }
                }
            }
        }
        # 3. Collecties (Arrays, Lists, etc.) - Strings uitsluiten want die zijn ook IEnumerable
        elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            foreach ($item in $InputObject) {
                if ($null -ne $item -and ([string]$item).Trim() -ne "") {
                    $hasValue = $true
                    break
                }
            }
        }
        # 4. Enkelvoudige waarden (String, Int, DateTime, etc.)
        else {
            $hasValue = ([string]$InputObject).Trim() -ne ""
        }

        # Versie-onafhankelijke return (geen Ternary operator)
        if ($Invert) {
            return [bool](-not $hasValue)
        }
        else {
            return [bool]$hasValue
        }
    }
}

function Test-HasNoContent {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )
    process {
        # We roepen simpelweg de hoofdfunctie aan met de -Invert switch
        return Test-HasContent -InputObject $InputObject -Invert
    }
}
function Test-HasRows {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline = $true)]$InputObject)
    process {
        if ($null -eq $InputObject -or $InputObject -is [System.DBNull]) { return [bool]$false }
        
        # 1. Strings: Alleen True als er echt tekst in staat (geen lege of spatie strings)
        if ($InputObject -is [string]) { 
            return [bool](-not [string]::IsNullOrWhiteSpace($InputObject)) 
        }

        # 2. Collecties (Arrays, Lists, etc.)
        if ($InputObject -is [System.Collections.IEnumerable]) {
            if ($null -ne $InputObject.Count) { return [bool]($InputObject.Count -gt 0) }
            if ($null -ne $InputObject.Length) { return [bool]($InputObject.Length -gt 0) }
            return [bool]$InputObject.GetEnumerator().MoveNext()
        }
        
        # 3. Enkele objecten (zoals PSCustomObject, getallen, booleans)
        return [bool]$true
    }
}

function Test-HasNoRows {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline = $true)]$InputObject)
    process {
        return [bool](-not (Test-HasRows $InputObject))
    }
}

function Test-IsTrue {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline = $true)]$InputObject)
    process {
        if ($null -eq $InputObject -or $InputObject -is [System.DBNull]) { return [bool]$false }
        
        # 1. Booleans en SwitchParameters (moeten fysiek op True staan)
        if ($InputObject -is [bool] -or $InputObject -is [System.Management.Automation.SwitchParameter]) {
            return [bool]$InputObject
        }

        # 2. De rest volgt de logica van HasRows (vangoat strings en lege arrays)
        return [bool](Test-HasRows -InputObject $InputObject)
    }
}

function Test-IsFalse {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline = $true)]$InputObject)
    process {
        # Altijd de exacte tegenpool
        $Result = -not (Test-IsTrue -InputObject $InputObject)
        return [bool]$Result
    }
}
function Test-IsDateTime {
    [CmdletBinding()]
    param([Parameter(ValueFromPipeline = $true)]$InputObject)
    process {
        # Check op Null, DBNull en of het type exact DateTime is
        $Result = ($null -ne $InputObject -and 
                   $InputObject -isnot [System.DBNull] -and 
                   $InputObject -is [DateTime])
        
        return [bool]$Result
    }
}


function Format-SqlString {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,

        [int]$MaxLength = 0,
        [switch]$NoQuotes,
        [ValidateSet("String", "DateTime", "DateTime2", "Json")]
        [string]$Type = "String"
    )

    process {
        # 1. Check op geen data
        if (Test-HasNoContent $InputObject) {
            return [string]"NULL"
        }

        $text = ""

        # 2. Afhandeling op basis van type
        if ($Type -eq "DateTime") {
            $val = [datetime]$InputObject
            $text = [string]($val.ToString("yyyy-MM-dd HH:mm:ss.fff"))
        }
        elseif ($Type -eq "DateTime2") {
            $val = [datetime]$InputObject
            $text = [string]($val.ToString("yyyy-MM-dd HH:mm:ss.fffffff"))
        }
        # NIEUW: Voorkom dat door PowerShell verpakte strings (door bijv. Select-Object) onterecht als JSON worden behandeld
        elseif ($Type -eq "Json" -or (($InputObject -is [System.Collections.IDictionary] -or $InputObject -is [PSCustomObject]) -and $InputObject.GetType().Name -ne "String")) {
            $text = [string]($InputObject | ConvertTo-Json -Compress)
            $text = $text.Replace("'", "''")
        }
        else {
            $text = [string]$InputObject
            $text = $text.Replace("'", "''")

            if ($MaxLength -gt 0 -and $text.Length -gt $MaxLength) {
                $text = [string]($text.Substring(0, $MaxLength))
                if ($text.EndsWith("'") -and (Test-IsFalse ($text.EndsWith("''")))) {
                    $text = [string]($text.Substring(0, $text.Length - 1))
                }
            }
        }

        # 3. Return met of zonder quotes
        if (Test-IsTrue $NoQuotes) {
            return [string]$text
        } else {
            return [string]("'$text'")
        }
    }
}

function Format-SqlString_oud_20260413 {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        $InputObject,

        [int]$MaxLength = 0,
        [switch]$NoQuotes,
        [ValidateSet("String", "DateTime", "DateTime2", "Json")]
        [string]$Type = "String"
    )

    process {
        # 1. Check op geen data
        if (Test-HasNoContent $InputObject) {
            return [string]"NULL"
        }

        $text = ""

        # 2. Afhandeling op basis van type
        if ($Type -eq "DateTime") {
            $val = [datetime]$InputObject
            $text = [string]($val.ToString("yyyy-MM-dd HH:mm:ss.fff"))
        }
        elseif ($Type -eq "DateTime2") {
            $val = [datetime]$InputObject
            $text = [string]($val.ToString("yyyy-MM-dd HH:mm:ss.fffffff"))
        }
        # NIEUW: Automatische JSON conversie voor objecten of expliciet type "Json"
        elseif ($Type -eq "Json" -or $InputObject -is [System.Collections.IDictionary] -or $InputObject -is [PSCustomObject]) {
            $text = [string]($InputObject | ConvertTo-Json -Compress)
            $text = $text.Replace("'", "''")
        }
        else {
            $text = [string]$InputObject
            $text = $text.Replace("'", "''")

            if ($MaxLength -gt 0 -and $text.Length -gt $MaxLength) {
                $text = [string]($text.Substring(0, $MaxLength))
                if ($text.EndsWith("'") -and (Test-IsFalse ($text.EndsWith("''")))) {
                    $text = [string]($text.Substring(0, $text.Length - 1))
                }
            }
        }

        # 3. Return met of zonder quotes
        if (Test-IsTrue $NoQuotes) {
            return [string]$text
        } else {
            return [string]("'$text'")
        }
    }
}

#############################################################################################################################################
Function Manage-LogRotation {
#############################################################################################################################################
    param (
        [string]$LogFolder = "$Global:RootPath\Logs",
        [int]$MaxDays = 7,
        [switch]$ForceEnable
    )

    # 1. Controleer of logging überhaupt aan staat in de AppSettings (Tenzij -ForceEnable is meegegeven)
    # Zorg dat je 'LOGGING_ENABLE' ook aanpast in je configuratie/settings file!
    if (-not $ForceEnable -and (Test-IsFalse $global:AppSettings.LOGGING_ENABLE)) {
        if ($Global:LogPath) {
            Write-Log -Message "Logging naar bestand is uitgeschakeld via AppSettings." -Level Warning
            $Global:LogPath = $null
        }
        return
    }

    # 1b. MaxDays dynamisch bepalen via AppSettings (met fallback naar parameter)
    [int]$WerkelijkeMaxDays = $MaxDays
    if ($null -ne $global:AppSettings.LOGGING_MAXDAYS) {
        $WerkelijkeMaxDays = [int]$global:AppSettings.LOGGING_MAXDAYS
    } elseif ($null -ne $global:AppSettings.TRANSSCRIPT_MAXDAYS) {
        # Terugwerkende compatibiliteit voor als de setting nog niet is hernoemd in de config
        $WerkelijkeMaxDays = [int]$global:AppSettings.TRANSSCRIPT_MAXDAYS
    }

    # 2. Bepaal de gewenste bestandsnaam voor VANDAAG
    [string]$DateStr = (Get-Date).ToString("yyyyMMdd")
    [string]$LogFileName = "UAM_Log_$($env:COMPUTERNAME)_$($Global:useridentifier)_$DateStr.log"
    
    [string]$LogFile = Join-Path $LogFolder $LogFileName

    # 3. CHECK: Is de logfile nog actueel? (Voorkomt onnodig opschonen bij elke loop)
    if ($Global:LogPath -eq $LogFile) {
        return # Alles is nog up-to-date
    }

    # --- Als we hier komen, is de datum veranderd of we starten net op ---

    # 4. Zorg dat de map bestaat
    if (!(Test-Path $LogFolder)) { 
        try {
            New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null 
        } catch {
            [string]$Foutmelding = $_.Exception.Message
            Write-Error "Kan logmap niet aanmaken $LogFolder = $Foutmelding"
            return
        }
    }

    # 5. Opschonen oude bestanden (gebaseerd op AppSettings retentie)
    try {
        [datetime]$LimitDate = (Get-Date).AddDays(-$WerkelijkeMaxDays)
        
        # De -Include filter pakt ook oude UAM_Transcript bestanden mee zodat deze vanzelf verdwijnen
        # AANGEPAST: -ErrorAction Stop forceert fouten netjes naar het catch blok.
        Get-ChildItem -Path "$LogFolder\*" -Include "UAM_Log_*.log", "UAM_Transcript_*.log" -ErrorAction Stop | 
            Where-Object { $_.LastWriteTime -lt $LimitDate } | 
            Remove-Item -Force -ErrorAction Stop
    } catch {
        [string]$FoutOpschonen = $_.Exception.Message
        Write-Warning "Fout bij opschonen oude bestanden = $FoutOpschonen"
    }

    # 6. Initialiseer de nieuwe globale LogPath
    $Global:LogPath = $LogFile

    # 7. Schrijf een duidelijke header in het nieuwe custom logbestand
    # AANGEPAST: Alleen schrijven als het bestand fysiek nog niet bestaat!
    if (-not (Test-Path $Global:LogPath)) {
        [string]$Header = @"

--------------------------------------------------------------------------------
LOG START: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
MACHINE:   $env:COMPUTERNAME
USER:      $Global:useridentifier
PID:       $PID
--------------------------------------------------------------------------------
"@
        try {
            [int]$MaxHeaderRetries = 5
            [int]$HeaderRetryCount = 0
            [bool]$HeaderSuccess = [bool]$false

            while ((Test-IsFalse $HeaderSuccess) -and $HeaderRetryCount -lt $MaxHeaderRetries) {
                try {
                    $Header | Out-File -FilePath $Global:LogPath -Append -Encoding UTF8 -ErrorAction Stop
                    $HeaderSuccess = [bool]$true
                } catch {
                    $HeaderRetryCount++
                    if ($HeaderRetryCount -ge $MaxHeaderRetries) { throw $_ }
                    Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 200)
                }
            }
        } catch {
            [string]$FoutHeader = $_.Exception.Message
            Write-Warning "Fout bij wegschrijven header naar logbestand $Global:LogPath = $FoutHeader"
        }
    }

    Write-Log -Message "Nieuw dag-logbestand geactiveerd in map $LogFolder (Retentie: $WerkelijkeMaxDays dagen)" -Level Success
}

#############################################################################################################################################
Function Manage-LogRotation {
#############################################################################################################################################
    param (
        [string]$LogFolder = "$Global:RootPath\Logs",
        [int]$MaxDays = 7,
        [switch]$ForceEnable
    )

    # 1. Controleer of logging überhaupt aan staat in de AppSettings (Tenzij -ForceEnable is meegegeven)
    if (-not $ForceEnable -and (Test-IsFalse $global:AppSettings.LOGGING_ENABLE)) {
        if ($Global:LogPath) {
            Write-Log -Message "Logging naar bestand is uitgeschakeld via AppSettings." -Level Warning
            $Global:LogPath = $null
        }
        return
    }

    # 1b. MaxDays dynamisch bepalen via AppSettings (met veilige error-handling en null-checks)
    [int]$WerkelijkeMaxDays = $MaxDays
    
    if ($null -ne $global:AppSettings.LOGGING_MAXDAYS -and [string]$global:AppSettings.LOGGING_MAXDAYS -ne '') {
        try { $WerkelijkeMaxDays = [int]$global:AppSettings.LOGGING_MAXDAYS } catch {}
    } elseif ($null -ne $global:AppSettings.TRANSSCRIPT_MAXDAYS -and [string]$global:AppSettings.TRANSSCRIPT_MAXDAYS -ne '') {
        try { $WerkelijkeMaxDays = [int]$global:AppSettings.TRANSSCRIPT_MAXDAYS } catch {}
    }

    # --- DE FIX VOOR HET VERDWIJNENDE LOGBESTAND ---
    # Voorkom dat retentie op 0 of negatief staat, want dan verwijdert de opschoon-routine de logs van VANDAAG.
    if ($WerkelijkeMaxDays -le 0) {
        $WerkelijkeMaxDays = 7
    }

    # 2. Bepaal de gewenste bestandsnaam voor VANDAAG
    [string]$DateStr = (Get-Date).ToString("yyyyMMdd")
    [string]$LogFileName = "UAM_Log_$($env:COMPUTERNAME)_$($Global:useridentifier)_$DateStr.log"
    
    [string]$LogFile = Join-Path $LogFolder $LogFileName

    # 3. CHECK: Is de logfile nog actueel? (Voorkomt onnodig opschonen bij elke loop)
    if ($Global:LogPath -eq $LogFile) {
        return # Alles is nog up-to-date
    }

    # --- Als we hier komen, is de datum veranderd of we starten net op ---

    # 4. Zorg dat de map bestaat
    if (!(Test-Path $LogFolder)) { 
        try {
            New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null 
        } catch {
            [string]$Foutmelding = $_.Exception.Message
            Write-Error "Kan logmap niet aanmaken $LogFolder = $Foutmelding"
            return
        }
    }

    # 5. Opschonen oude bestanden (gebaseerd op AppSettings retentie)
    try {
        [datetime]$LimitDate = (Get-Date).AddDays(-$WerkelijkeMaxDays)
        
        # De -Include filter pakt ook oude UAM_Transcript bestanden mee zodat deze vanzelf verdwijnen
        Get-ChildItem -Path "$LogFolder\*" -Include "UAM_Log_*.log", "UAM_Transcript_*.log" -ErrorAction Stop | 
            Where-Object { $_.LastWriteTime -lt $LimitDate } | 
            Remove-Item -Force -ErrorAction Stop
    } catch {
        [string]$FoutOpschonen = $_.Exception.Message
        Write-Warning "Fout bij opschonen oude bestanden = $FoutOpschonen"
    }

    # 6. Initialiseer de nieuwe globale LogPath
    $Global:LogPath = $LogFile

    # 7. Schrijf een duidelijke header in het nieuwe custom logbestand
    # Alleen schrijven als het bestand fysiek nog niet bestaat!
    if (-not (Test-Path $Global:LogPath)) {
        [string]$Header = @"

--------------------------------------------------------------------------------
LOG START: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
MACHINE:   $env:COMPUTERNAME
USER:      $Global:useridentifier
PID:       $PID
--------------------------------------------------------------------------------
"@
        try {
            [int]$MaxHeaderRetries = 5
            [int]$HeaderRetryCount = 0
            [bool]$HeaderSuccess = [bool]$false

            while ((Test-IsFalse $HeaderSuccess) -and $HeaderRetryCount -lt $MaxHeaderRetries) {
                try {
                    $Header | Out-File -FilePath $Global:LogPath -Append -Encoding UTF8 -ErrorAction Stop
                    $HeaderSuccess = [bool]$true
                } catch {
                    $HeaderRetryCount++
                    if ($HeaderRetryCount -ge $MaxHeaderRetries) { break }
                    Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 200)
                }
            }
        } catch {
            # Blijft stil bij harde file locks op de header
        }
    }

    Write-Log -Message "Nieuw dag-logbestand geactiveerd in map $LogFolder (Retentie: $WerkelijkeMaxDays dagen)" -Level Success
}

#############################################################################################################################################
Function Write-Log {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Debug", "Info", "Warning", "Error", "Success", "")]
        [string]$Level = "Info",

        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$ForegroundColor,

        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$BackgroundColor,

        [Parameter(Mandatory = $false)]
        [switch]$NoNewline
    )

    try {
        # 1. Verbosity & Filter Check
        $ShouldShow = $false
        
        if ([string]::IsNullOrEmpty($Level)) {
            $ShouldShow = $true
        }
        else {
            # Haal instellingen op
            $ConfigFilter = $global:AppSettings.SHOWLOGROWLEVELS
            
            # Bepaal de toegestane lijst
            if ([string]::IsNullOrEmpty($ConfigFilter)) {
                # Default gedrag als er niets is ingesteld (geen Debug)
                $AllowedList = @("Info", "Warning", "Error", "Success")
            }
            else {
                # Gebruik de lijst uit de instellingen
                $AllowedList = $ConfigFilter -split ',' | ForEach-Object { $_.Trim() }
            }

            # Controleer of het huidige level getoond mag worden
            if ($AllowedList -contains $Level) { 
                $ShouldShow = $true 
            }
        }

        if (-not $ShouldShow) { return }

        # 2. Kleur bepaling
        if (-not $PSBoundParameters.ContainsKey('ForegroundColor')) {
            $ForegroundColor = switch ($Level) {
                "Debug"   { "DarkGray" }
                "Warning" { "Yellow" }
                "Error"   { "Red" }
                "Success" { "Green" }
                Default   { "White" }
            }
        }

        # 3. Output opbouw
        $Now          = Get-Date
        $TimeStamp    = $Now.ToString("HH:mm:ss")
        $FileDate     = $Now.ToString("yyyy-MM-dd")
        $DisplayLevel = if ([string]::IsNullOrEmpty($Level)) { "LOG" } else { $Level.ToUpper() }
        $FullMessage  = "[$TimeStamp] [$PID] [$($DisplayLevel.PadRight(7))] $Message"

        # 4. Doorgeven aan Write-Host via Splatting
        $HostParams = @{
            Object = $FullMessage
            ForegroundColor = $ForegroundColor
        }
        if ($BackgroundColor) { $HostParams["BackgroundColor"] = $BackgroundColor }
        if ($NoNewline)       { $HostParams["NoNewline"]       = $true }

        Write-Host @HostParams

        # 5. Output naar Bestand
        # Alleen schrijven als het pad bekend is en de instelling op True staat
        if ($Global:LogPath -and (Test-IsTrue $global:AppSettings.TRANSSCRIPT_ENABLE)) { 
            
            [int]$MaxWriteRetries = 5
            [int]$WriteRetryCount = 0
            [bool]$WriteSuccess = [bool]$false
            
            while ((Test-IsFalse $WriteSuccess) -and $WriteRetryCount -lt $MaxWriteRetries) {
                try {
                    "[$FileDate] $FullMessage" | Out-File -FilePath $Global:LogPath -Append -Encoding UTF8 -ErrorAction Stop
                    $WriteSuccess = [bool]$true
                } catch {
                    $WriteRetryCount++
                    if ($WriteRetryCount -lt $MaxWriteRetries) {
                        Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 100)
                    } else {
                        break 
                    }
                }
            }
        }
    } 
    catch {
        $FallbackTime = (Get-Date).ToString('HH:mm:ss')
        Write-Host "[$FallbackTime] [$PID] [WARNING] Log Drop = $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

function Get-ProcessPerformance {
    [CmdletBinding()]
    param (
        [int]$ProcessID = $PID
    )

    process {
        [System.Diagnostics.Process]$proc = $null
        
        try {
            # 1. Bepaal de eigen sessie ter beveiliging op Terminal Servers
            [int]$MySessionId = [int](Get-Process -Id $PID).SessionId

            # 2. Haal het proces object direct op via ID
            [System.Diagnostics.Process]$proc = Get-Process -Id $ProcessID -ErrorAction Stop

            # 3. VEILIGHEIDSCHECK: Is dit proces wel van mij?
            if ($proc.SessionId -ne $MySessionId) {
                Write-Warning "Veiligheidsblokkade: Proces $ProcessID draait in RDS sessie $($proc.SessionId), niet in huidige sessie ($MySessionId)."
                return # Geef niets terug om vervuiling te voorkomen
            }

            # 4. Metrics veilig ophalen in raw bytes (voorkomt math errors bij null)
            [double]$WorkingSetRaw = if ($null -ne $proc.WorkingSet64) { [double]$proc.WorkingSet64 } else { [double]0 }
            [double]$PrivateMemRaw = if ($null -ne $proc.PrivateMemorySize64) { [double]$proc.PrivateMemorySize64 } else { [double]0 }
            [double]$PagedMemRaw   = if ($null -ne $proc.PagedMemorySize64) { [double]$proc.PagedMemorySize64 } else { [double]0 }

            # 4.1. Pas afronden en omzetten naar MB nadat we zeker weten dat we getallen hebben
            [double]$WorkingSetCalc = [math]::Round(($WorkingSetRaw / 1MB), 2)
            [double]$PrivateMemCalc = [math]::Round(($PrivateMemRaw / 1MB), 2)
            [double]$PagedMemCalc   = [math]::Round(($PagedMemRaw / 1MB), 2)

            [int]$ThreadAantal = if ($null -ne $proc.Threads) { $proc.Threads.Count } else { [int]0 }
            [int]$HandleAantal = if ($null -ne $proc.HandleCount) { $proc.HandleCount } else { [int]0 }

            # 5. Veilige teruggave met de expliciete _MB naamgeving
            [PSCustomObject]$Resultaat = [PSCustomObject]@{
                Name           = [string]$proc.ProcessName
                Id             = [int]$proc.Id
                CPU_Sec        = if ($null -ne $proc.CPU) { [double]$proc.CPU } else { [double]0.0 }
                Memory_MB      = [double]$PrivateMemCalc
                WorkingSet_MB  = [double]$WorkingSetCalc
                PagedMemory_MB = [double]$PagedMemCalc
                Threads        = [int]$ThreadAantal
                Handles        = [int]$HandleAantal
            }

            return [PSCustomObject]$Resultaat
        }
        catch {
            Write-Warning "Geen proces gevonden met ID $ProcessID of toegang geweigerd. ($($_.Exception.Message))"
        }
        finally {
            # 6. Achteraf het object altijd netjes opruimen om handle leaks te voorkomen
            if ($null -ne $proc -and $proc -is [System.Diagnostics.Process]) {
                $proc.Dispose()
            }
        }
    }
}

<#
.SYNOPSIS
    Bepaalt en creëert een veilige opslaglocatie voor projectgegevens en logs.

.DESCRIPTION
    Deze functie probeert eerst een map aan te maken in de Roaming AppData van de gebruiker. 
    Indien dit faalt (bijv. door rechten of profielproblemen), schakelt de functie automatisch 
    over naar de lokale Temp-map als fallback. 

    Dit garandeert dat het script altijd een plek heeft om data (zoals CSV-backups) weg te schrijven.

.PARAMETER ProjectName
    De naam van de submap die aangemaakt moet worden (bijv. "UAM_Logging").

.EXAMPLE
    $StoragePath = Get-SafeStoragePath -ProjectName "UAM_Logging"
    # Retourneert bijv: C:\Users\Naam\AppData\Roaming\UAM_Logging
#>
Function Get-SafeStoragePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$ProjectName = "$($Global:ProjectName)_Logging"
    )

    # Lijst met mogelijke locaties in volgorde van voorkeur
    $TargetPaths = @(
        (Join-Path ([Environment]::GetFolderPath('ApplicationData')) $ProjectName), # 1. Roaming AppData
        (Join-Path $env:LOCALAPPDATA $ProjectName),                               # 2. Local AppData
        (Join-Path $env:TEMP $ProjectName)                                        # 3. Temp
    )

    foreach ($Path in $TargetPaths) {
        try {
            if (-not (Test-Path $Path)) {
                # Probeer de map aan te maken
                $null = New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
            }
            
            # Test of we ook echt een bestandje kunnen schrijven (de ultieme check)
            $TestFile = Join-Path $Path "write_test.tmp"
            "Test" | Out-File $TestFile -ErrorAction Stop
            Remove-Item $TestFile -ErrorAction Stop

            Write-Log "Opslaglocatie vastgesteld op: $Path" -Level Debug
            return $Path
        }
        catch {
            Write-Warning "Kon geen gebruik maken van locatie: $Path. Fout: $($_.Exception.Message)"
            continue # Probeer de volgende locatie in de lijst
        }
    }

    # Als alles faalt (hoogst onwaarschijnlijk), gebruik de rauwe Temp map
    return $env:TEMP
}

#############################################################################################################################################
function Convert-WebKitTimeToLocal {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [long]$webkitTime
    )

    try {
        $baseDate = [datetime]::new(1601, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
        
        # 1 tick = 0.1 microseconde. WebKit is in microseconden, dus * 10 voor ticks.
        $ticks = [int64]$webkitTime * 10
        
        $localTime = $baseDate.AddTicks($ticks).ToLocalTime()
        
        return $localTime.ToString("yyyy-MM-dd HH:mm:ss.ffffff")
    } 
    catch {
        # Geen finally nodig: we laten de fout gewoon 'bubbelen' naar de aanroeper
        throw $_
    } 
}

#############################################################################################################################################
function Convert-LocalTimeToWebKitTime {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [datetime]$localTime
    )
    
    try {
        $baseDateUtc = [datetime]::new(1601, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
        $inputTimeUtc = $localTime.ToUniversalTime()
        $timeDifference = $inputTimeUtc - $baseDateUtc
        
        # Converteer naar microseconden (1 tick = 0.1 microseconde, dus deel door 10)
        $webkitTimestamp = [Int64]($timeDifference.Ticks / 10)
        
        return $webkitTimestamp
    } 
    catch {
        throw $_
    } 
}

#############################################################################################################################################
Function Encrypt-String {
#############################################################################################################################################

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Key
    )

    Process {
        $SecureString = $null
        try {
            # 1. Validatie (Gooi een error als de key niet klopt)
            if (($Key.Length -ne 16) -and ($Key.Length -ne 24) -and ($Key.Length -ne 32)) {
                throw "De sleutellengte moet 16, 24 of 32 tekens zijn (huidige lengte $Key.Length)"
            }

            $Bytes = [System.Text.Encoding]::ASCII.GetBytes($Key)

            # 2. SecureString opbouwen
            $SecureString = New-Object System.Security.SecureString
            $String.ToCharArray() | ForEach-Object { $SecureString.AppendChar($_) }

            # 3. Encryptie
            $EncryptedString = $SecureString | ConvertFrom-SecureString -Key $Bytes
            
            return $EncryptedString

        } catch {
            # Bubbel de fout omhoog naar het hoofdscript/ErrorHandler
            throw $_
        } finally {
            if ($null -ne $SecureString) { 
                $SecureString.Dispose() 
            }
        }
    }
}    

#############################################################################################################################################
Function Decrypt-String {
#############################################################################################################################################
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$EncryptedString,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Key
    )

    Process {
        $SecureString = $null
        try {
            # 1. Validatie
            if (($Key.Length -ne 16) -and ($Key.Length -ne 24) -and ($Key.Length -ne 32)) {
                throw "De sleutellengte moet 16, 24 of 32 tekens zijn."
            }

            $Bytes = [System.Text.Encoding]::ASCII.GetBytes($Key)

            # 2. Omzetten naar SecureString
            $SecureString = $EncryptedString | ConvertTo-SecureString -Key $Bytes

            # 3. Plaintext extraheren via PSCredential
            $Credentials = New-Object System.Management.Automation.PSCredential ("User", $SecureString)
            $PlainString = $Credentials.GetNetworkCredential().Password

            return $PlainString

        } catch {
            # Gooi de fout omhoog. Let op: als de Key fout is bij decryptie, 
            # gooit ConvertTo-SecureString zelf al een duidelijke error.
            throw $_
        } finally {
            # Altijd netjes opruimen
            if ($null -ne $SecureString) {
                $SecureString.Dispose()
            }
        }
    }
}


#############################################################################################################################################
Function Wait-Path {
#############################################################################################################################################
    [cmdletbinding()]
    param (
        [string[]]$Path,
        [int]$Timeout = 5,
        [int]$Interval = 1,
        [switch]$Passthru
    )

    $StartDate = Get-Date
    $First = $True

    Write-Debug "Wait-Path gestart. Timeout $Timeout seconden, Interval $Interval seconden."

    Do
    {
        # 1. Wachten indien nodig
        if ($First) {
            $First = $False
        }
        else {
            Write-Debug "Wachten op volgende check ($Interval sec)..."
            Start-Sleep -Seconds $Interval
        }

        # 2. Test paden
        [bool[]]$Tests = foreach($PathItem in $Path) {
            try {
                if (Test-Path -Path $PathItem -ErrorAction Stop) {
                    Write-Debug "Pad gevonden: $PathItem"
                    $True
                }
                else {
                    Write-Verbose "Wachten op '$PathItem'..."
                    $False
                }
            }
            catch {
                Write-Debug "Fout bij testen pad $PathItem = $($_.Exception.Message)"
                $False
            }
        }

        # 3. Zijn alle paden gevonden?
        $AllFound = $Tests -notcontains $False

        if ($AllFound) {
            Write-Debug "Alle opgegeven paden zijn gevonden."
            if ($Passthru) { return $true }
            return # Exit functie zonder error
        }

        # 4. Timeout check
        $Elapsed = ((Get-Date) - $StartDate).TotalSeconds
        if ($Elapsed -gt $Timeout) {
            Write-Debug "Timeout bereikt na $Elapsed seconden."
            if ($Passthru) {
                return $false
            }
            else {
                # Gebruik je eigen Write-Log of ErrorHandler
                if (Get-Command Write-Log -ErrorAction SilentlyContinue) {
                    Write-Log "Timed out waiting for paths $($Path -join ', ')" -Level Error
                }
                throw "Wait-Path: Timed out waiting for paths $($Path -join ', ')"
            }
        }

    } Until ( $False )
}



function Wait-WithCountdown {
    <#
    .SYNOPSIS
        Wacht een opgegeven aantal seconden of tot er op een toets wordt gedrukt.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text,
        
        [Parameter(Mandatory=$true)]
        [int]$WaitInSeconds,

        [Parameter(Mandatory=$false)]
        [switch]$DoNotWait
    )

    try {
        Write-Log "$Text" -NoNewline

        # Haakjes om de check conform jouw instructie [2026-02-17]
        if ((Test-IsFalse $DoNotWait) -and (Test-IsFalse $Global:QuietMode)) {
            Write-Host "(Druk op een toets om door te gaan of wacht $WaitInSeconds sec) " -ForegroundColor Gray 

            $SecondsPassed = 0
            
            while ($SecondsPassed -lt $WaitInSeconds) {
                
                $KeyFound = $false
                try {
                    # Native .NET check omzeilt Host-blokkades in VS Code
                    if ([System.Console]::KeyAvailable) {
                        $null = [System.Console]::ReadKey($true)
                        $KeyFound = $true
                    }
                } catch {
                    # Als de console niet-interactief is, negeren we de key-check
                }

                if ($KeyFound) {
                    Write-Host "[OVERSLAGEN] Direct doorgaan..." -ForegroundColor Cyan 
                    return
                }

                Start-Sleep -Seconds 1
                $SecondsPassed++
            }
            Write-Host "[TIJD OM] Countdown voltooid." -ForegroundColor Gray
        }
    } catch {
        # Geen dubbele punt direct na variabele conform instructie [2026-02-15]
        $ErrorMsg = $_.Exception.Message
        Write-Log "Error in Wait-WithCountDown = $ErrorMsg"
    }
}


#############################################################################################################################################
function Convert-UnixEpochTimeToLocal {
#############################################################################################################################################
    [CmdletBinding()]
    param($unixTimeUs) 

    try {
        # UnixEpoch tijd is microseconden sinds 1 januari 1970 UTC
        $unixEpoch = [datetime]::new(1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
        
        # Voeg het aantal microseconden toe met behulp van AddTicks (precieser dan AddSeconds/Milliseconds)
        # 1 microseconde = 10 ticks (1 tick = 0.1 us)
        $ticksToAdd = $unixTimeUs * 10
        
        $utcTime = $unixEpoch.AddTicks($ticksToAdd)
        
        # Converteer naar lokale tijd en formatteer met microseconden
        return $utcTime.ToLocalTime().ToString("yyyy-MM-dd HH:mm:ss.ffffff")
    } catch {
   		Throw $_
    }
}

#############################################################################################################################################
function Convert-LocalTimeToUnixEpochTime {
#############################################################################################################################################

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [datetime]$localTime
    )
    
    try{
        # Basisdatum voor UnixEpoch tijd is 1 januari 1970 UTC
        $unixEpochUtc = [datetime]::new(1970, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc)
        
        # Converteer lokale tijd naar UTC voor de berekening
        $inputTimeUtc = $localTime.ToUniversalTime()
        
        # Bereken het tijdsverschil (TimeSpan)
        $timeDifference = $inputTimeUtc - $unixEpochUtc
        
        # Haal het totale aantal seconden op met maximale precisie (double)
        $secondsSinceEpoch = $timeDifference.TotalSeconds
        
        # Converteer seconden naar microseconden (als Int64)
        $unixTimestamp = [Int64]($secondsSinceEpoch * 1000000)
        
        return $unixTimestamp
    } catch {
        Throw $_
    }

}

#############################################################################################################################################
Function Check-RAMandCPU {
#############################################################################################################################################
param ($Message)

    try {

        if ($message){
            Write-Log $Message -ForegroundColor Blue  -backgroundColor yellow
        }
        <#
        #	[System.GC]::Collect()
        $Global:CurrentProcessID = [system.diagnostics.Process]::GetCurrentProcess().id

        $PerformanceInfoPowershell = Get-CimInstance Win32_PerfFormattedData_PerfProc_Process |where {$_.idprocess -eq $Global:CurrentProcessID} | 
		    						select name,  @{l="mem";e={[math]::round($_."WorkingSetPrivate"/1MB,2)}}, @{l="cpu";e={[math]::round($_."PercentProcessorTime",1)}}

        if ($global:MaxMemoryUseMB -lt $PerformanceInfoPowershell.mem){
            write-verbose "New MAX Memory: $($PerformanceInfoPowershell.mem)MB  was $($global:MaxMemoryUseMB)MB" 
            $global:MaxMemoryUseMB = $PerformanceInfoPowershell.mem
        }
        #>        

    } catch {
        return
    }
}

Function Invoke-SqlQuery {
    <#
    .SYNOPSIS
        Voert SQL queries uit, ondersteunt batch-verwerking via Defer en herstelt data uit wachtrijen.
    #>
    [CmdletBinding(DefaultParameterSetName='DirectQuery', SupportsShouldProcess = $true)]
    param (
        # --- SET 1: Directe Query (Nieuwe actie) ---
        [Parameter(Mandatory=$false, ParameterSetName='DirectQuery')]
        [String]$Query,

        [Parameter(Mandatory=$false, ParameterSetName='DirectQuery')]
        [PSCustomObject[]]$DataRecord,

        [Parameter(Mandatory=$false, ParameterSetName='DirectQuery')]
        [switch]$Defer,

        # --- SET 2: Deferred Processing (Verwerken van wachtrij) ---
        [Parameter(Mandatory=$true, ParameterSetName='DeferredProcessing')]
        [System.Collections.Generic.List[PSObject]]$DeferredItems,

        # --- Gedeelde Parameters ---
        [String]$SQLInstance = "localhost",
        [String]$Database,
        [String]$ConnectionString = $Global:SecureConnectionString,
        [ValidateSet('SQL','Windows')]
        [String]$AuthMethod = 'Windows',
        [String]$User,
        [String]$Pwd,
        [ValidateSet('DataTable','NonQuery')]
        [String]$queryMethod = "DataTable",
        [Parameter(Mandatory=$false)]
        [ValidateSet('CSV', 'PSCustomObject', 'Pipeline', 'None')]
        [String[]]$OutputTo = @('Pipeline'),
        [String]$CSVPath = $Global:CsvPath,
        [Int]$AutoRetries = 3,
        [Int]$AutoRetryDelaySeconds = 5,
        [Int]$ConnectTimeoutSeconds = 15,
        [Int]$QueryTimeoutSeconds = 120
    )

    Process 
    {
        # Initialisatie van interne collecties
        $IndividualStatements = New-Object System.Collections.Generic.List[PSObject]
        $FinalOutput = New-Object System.Collections.Generic.List[PSObject]
        $Success = $false

        if($ConnectionString){
            try {
                $Builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($ConnectionString)

                # Basis variabelen
                $SQLInstance   = $Builder.DataSource
                $Database      = $Builder.InitialCatalog

                if ($Builder.IntegratedSecurity) {
                    $AuthType = "Windows / Trusted"
                    $Usr      = "$env:USERDOMAIN\$env:USERNAME"
                    $Pwd      = '<REDACTED-HARDCODED-CREDENTIAL>'
                } 
                else {
                    $AuthType = "SQL Server Account"
                    $Usr      = $Builder.UserID
                    $Pwd      = $Builder.Password
                }

                Write-Verbose "--- Verbindingsdetails ---" 
                Write-Verbose "Type:     $AuthType"
                Write-Verbose "Server:   $SQLInstance"
                Write-Verbose "Database: $Database"
                Write-Verbose "User:     $Usr"
                
                if (-not [string]::IsNullOrEmpty($Pwd) -and $Pwd -ne "N/A (Integrated)") {
                    Write-Verbose "Pass:     ********" 
                }
            } catch {
                Write-Warning "Fout bij het uitlezen van ConnectionString: $($_.Exception.Message)"
            }
        }

        # --- 1. GENEREREN / VERZAMELEN VAN STATEMENTS ---
        if ($PSCmdlet.ParameterSetName -eq 'DeferredProcessing') {
            foreach ($item in $DeferredItems) { $null = $IndividualStatements.Add($item) }
        }
        else {
            if ($null -ne $DataRecord) {
                foreach ($Row in $DataRecord) {
                    $CurrentQuery = $Query
                    foreach ($Prop in $Row.PSObject.Properties) {
                        $Token = '$($' + $Prop.Name + ')'
                        if ($CurrentQuery.Contains($Token)) {
                            $Val = Format-SqlString $Prop.Value
                            $CurrentQuery = $CurrentQuery.Replace($Token, $Val)
                        }
                    }
                    $null = $IndividualStatements.Add([PSCustomObject]@{
                        _DateTimeStamp = (Get-Date)
                        _SQLInstance   = $SQLInstance
                        _Database      = $Database
                        _Statement     = $CurrentQuery
                        _Data          = $Row
                    })
                }
            }
            else {
                $null = $IndividualStatements.Add([PSCustomObject]@{
                    _DateTimeStamp = (Get-Date)
                    _SQLInstance   = $SQLInstance
                    _Database      = $Database
                    _Statement     = $Query
                    _Data          = $null
                })
            }
        }

        if ($IndividualStatements.Count -eq 0) { return @()}

            # --- 2. DEFER OF EXECUTE LOGICA ---
            if ((Test-IsTrue $Defer) -and $PSCmdlet.ParameterSetName -eq 'DirectQuery') {
                
                # FIX: Forceer de CSV output als de applicatie in CACHE_CSV modus draait!
                if ($Global:AppSettings.GENERAL_WRITE2DB_METHOD -eq 'CACHE_CSV' -and $OutputTo -notcontains 'CSV') {
                    $OutputTo += 'CSV'
                }

                if (Test-IsFalse $Global:DeferredQueries) {
                    $Global:DeferredQueries = New-Object System.Collections.Generic.List[PSObject]
                }

                if ($Global:DeferredQueries -isnot [System.Collections.Generic.List[PSObject]]) {
                    $TempList = New-Object System.Collections.Generic.List[PSObject]
                    foreach ($q in $Global:DeferredQueries) { $null = $TempList.Add($q) }
                    $Global:DeferredQueries = $TempList
                }

                foreach ($item in $IndividualStatements) { $null = $Global:DeferredQueries.Add($item) }
                $Success = $true
                $IndividualStatements | ForEach-Object { if ($null -ne $_.Data) { $null = $FinalOutput.Add($_.Data) } }
            }        
        else {
            # --- 3. SQL TRANSACTIE BUNDELEN ---
            $BatchSQL = "BEGIN TRY`n    BEGIN TRANSACTION;`n"
            foreach ($s in $IndividualStatements) {
                $CleanStatement = $s._Statement.Trim().TrimEnd(';')
                if (-not [string]::IsNullOrWhiteSpace($CleanStatement)) {
                    $BatchSQL += "    $CleanStatement;`n"
                }
            }
            $BatchSQL += "    COMMIT TRANSACTION;`nEND TRY`nBEGIN CATCH`n    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;`n    THROW;`nEND CATCH"

            # --- 4. EXECUTIE MET GESPLITSTE TRY-CATCH ---
            if ($PSCmdlet.ShouldProcess($SQLInstance, "SQL Batch Uitvoeren")) {
                
                # FASE A: Verbinding maken (Met Retries)
                $RetryCount = 0
                $ConnectionSuccess = $false
                $SqlConnection = $null

                if ([string]::IsNullOrWhiteSpace($ConnectionString)) {
                    if ($AuthMethod -eq "SQL") { $ConnectionString = "Server=$SQLInstance;Database=$Database;Uid=$User;Pwd=$Pwd;Integrated Security=False;Connect Timeout=$ConnectTimeoutSeconds;" }
                    else { $ConnectionString = "Server=$SQLInstance;Database=$Database;Trusted_Connection=True;Integrated Security=True;Connect Timeout=$ConnectTimeoutSeconds;" }
                }

                do {
                    try {
                        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection($ConnectionString)
                        $SqlConnection.Open()
                        $ConnectionSuccess = $true
                    } catch {
                        $RetryCount++
                        $ErrorMsg = if ($_.Exception.InnerException) { $_.Exception.InnerException.Message } else { $_.Exception.Message }
                        Write-Error "Verbindingsfout op $SQLInstance (Poging $RetryCount/$AutoRetries) = $ErrorMsg"
                        
                        if ($RetryCount -lt $AutoRetries) { Start-Sleep -Seconds $AutoRetryDelaySeconds }
                    }
                } until ($ConnectionSuccess -or $RetryCount -ge $AutoRetries)

                # FASE B: Query Uitvoeren (Retry alleen bij Deadlock)
                if ($ConnectionSuccess) {
                    $QueryRetryCount = 0
                    $QuerySuccess = $false
                    
                    do {
                        try {
                            $SqlCmd = $SqlConnection.CreateCommand()
                            $SqlCmd.CommandTimeout = $QueryTimeoutSeconds
                            $SqlCmd.CommandText = $BatchSQL

                            if ($queryMethod -eq "DataTable" -and $PSCmdlet.ParameterSetName -eq 'DirectQuery') {
                                $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($SqlCmd)
                                $DataTable = New-Object System.Data.DataTable
                                $null = $SqlAdapter.Fill($DataTable)
                                $DataTable | ForEach-Object { $null = $FinalOutput.Add($_) }
                            } else {
                                $null = $SqlCmd.ExecuteNonQuery()
                            }
                            $QuerySuccess = $true
                            $Success = $true
                            
                            $DebugFile = Join-Path $Global:RootPath "SQL_Error_Debug.sql"
                            if (Test-Path $DebugFile) { Remove-Item $DebugFile -Force }
                        } catch {
                            $IsDeadlock = ($null -ne $_.Exception.InnerException -and $_.Exception.InnerException.Number -eq 1205) -or ($_.Exception -is [System.Data.SqlClient.SqlException] -and $_.Exception.Number -eq 1205)
                            
                            if ($IsDeadlock -and $QueryRetryCount -lt 1) {
                                $QueryRetryCount++
                                Write-Warning "SQL Deadlock gedetecteerd op $SQLInstance. Eén retry wordt uitgevoerd..."
                                Start-Sleep -Seconds 1
                            } else {
                                $QueryRetryCount = 999 
                                $ErrorMsg = if ($_.Exception.InnerException) { $_.Exception.InnerException.Message } else { $_.Exception.Message }
                                
                                $DebugFile = Join-Path $Global:RootPath "SQL_Error_Debug.sql"
                                $DebugInfo = "-- Executie Error = $ErrorMsg`n-- Time = $(Get-Date)`n$BatchSQL"
                                $DebugInfo | Out-File $DebugFile -Encoding UTF8 -Force
                                
                                Write-Error "SQL Executiefout op $SQLInstance = $ErrorMsg. Zie $DebugFile voor details."
                            }
                        }
                    } while (-not $QuerySuccess -and $QueryRetryCount -le 1)
                    
                    if ($null -ne $SqlConnection) { $SqlConnection.Close(); $SqlConnection.Dispose() }
                }
            } else {
                Write-Host "WhatIf: SQL Batch zou worden uitgevoerd op $SQLInstance" -ForegroundColor Yellow
                $Success = $true
            }
        }

        # --- 5. OUTPUT AFHANDELING ---
        if ($OutputTo -contains 'CSV' -and $null -ne $CSVPath) {
            $IndividualStatements | Export-Csv -Path $CSVPath -Append -NoTypeInformation -Delimiter ";" -Encoding UTF8
        }

        if ($OutputTo -contains 'Pipeline' -or $OutputTo -contains 'PSCustomObject') {
            return ,($FinalOutput.ToArray())
        }

        if ($OutputTo -contains 'None') {
            return $Success
        }

        return @()
    }
}

####################################################
Function Test-SqlConnection {
####################################################
    [CmdletBinding()]
    param (
        [String[]]$SQLInstance,
        $Database,
        $ConnectionString = $Global:SecureConnectionString,
        [ValidateSet('SQL', 'Windows')]
        [String]$AuthMethod = 'Windows',
        $User,
        $Pwd,
        $queryMethod = "DataTable",
        $Query
    )

    # 1. ConnectionString opbouwen
    if (!($PSBoundParameters.ContainsKey('ConnectionString'))) {
        if ($Global:SecureConnectionString) {
            $ConnectionString = $Global:SecureConnectionString
        } else {
            if ($AuthMethod -eq "SQL") {
                $ConnectionString = "Server=$SQLInstance;Database=$Database;Uid=$User;Pwd=$Pwd"
            } else {
                $ConnectionString = "Server=$SQLInstance;Database=$Database;Trusted_Connection=True"
            }
        }
    }

    $SqlConnection = $null # Initialiseer buiten de try

    try {
        # 2. Poging tot verbinden
        $SqlConnection = New-Object -TypeName System.Data.SqlClient.SqlConnection -ArgumentList $ConnectionString
        $SqlConnection.Open(); Write-log "SQL Verbinding succesvol geopend." -Level Debug

        # Als we hier komen, is de verbinding gelukt
        return $true

    } catch {
        # 3. Fout afhandelen
        # Omdat dit een 'Test' functie is, willen we vaak weten WAAROM hij faalt.
        # We gebruiken throw zodat de aanroeper (hoofdscript) de ErrorHandler kan gebruiken.
        Write-log "Test-SqlConnection faalde: $($_.Exception.Message)" -Level Debug; throw $_

    } finally {
        # 4. ALTIJD opruimen!
        if ($null -ne $SqlConnection) {
            if ($SqlConnection.State -eq 'Open') {
                $SqlConnection.Close()
                Write-Verbose "SQL Verbinding netjes gesloten."
            }
            $SqlConnection.Dispose()
        }
    }
}

Function Restore-DeferredQueriesFromCSV {
    [CmdletBinding()]
    param([Parameter(Mandatory=$true)] [String]$CsvPath)

    if (-not (Test-Path $CsvPath)) { return ,(New-Object System.Collections.Generic.List[PSObject]) }

    try {

        $RecoveryList = New-Object System.Collections.Generic.List[PSObject]
        Import-Csv -Path $CsvPath -Delimiter ";" | ForEach-Object {$RecoveryList.Add($_)}

        return ,$RecoveryList # Komma voorkomt unrolling naar Array
    }
    catch {
        Write-Error "Herstel mislukt: $($_.Exception.Message)"
        return ,(New-Object System.Collections.Generic.List[PSObject])
    }
}

function Invoke-DeferredQueryProcessing {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)] [string]$DefferedMethod,
        [Parameter(Mandatory=$true)] [String]$CsvPath
    )

    try{
        # 1. Herstel indien nodig uit CSV
        if ($DefferedMethod -eq 'CACHE_CSV' -and (Test-Path $CsvPath)) {
            $Global:DeferredQueries = Restore-DeferredQueriesFromCSV -CsvPath $CsvPath
        }

        if ($null -eq $Global:DeferredQueries -or $Global:DeferredQueries.Count -eq 0) { 
            Write-Log "Geen actie nodig. Er zijn geen loggegevens om naar de database te schrijven." -ForegroundColor DarkGreen
            return 
        }

<#
# Forceer een punt als decimaal scheidingsteken voor SQL
$Culture = [System.Globalization.CultureInfo]::InvariantCulture

$StatusData = [PSCustomObject]@{
    ProcDate   = $ProcessHistoryDate.ToString("yyyyMMdd HH:mm:ss.fffffff")
    BrowsDate  = $BrowserHistoryDate.ToString("yyyyMMdd HH:mm:ss.fffffff")
    RecentDate = $RecentFilesDate.ToString("yyyyMMdd HH:mm:ss.fffffff")
    # Getallen omzetten naar string met een PUNT ipv KOMMA
    MaxMem     = [string]::Format($Culture, "{0}", [double]$global:MaxMemoryUseMB)
    LastMem    = [string]::Format($Culture, "{0}", [double]$PerformanceInfo.mem)
    User       = $Global:useridentifier
    Domain     = $env:userdomain
    Computer   = $env:computername
    EndDate    = (Get-Date).ToString("yyyyMMdd HH:mm:ss.fffffff")
}

$UpdateQuery = @"
    UPDATE [dbo].[DeviceLoggingUsers] 
    SET [LastProcessLogDateTime]            = '$($StatusData.ProcDate)',
        [LastBrowserLogDateTime]            = '$($StatusData.BrowsDate)',
        [LastRecentFilesAndFoldersDateTime] = '$($StatusData.RecentDate)',
        [UAMprocessMaxMemoryMB]             = $($StatusData.MaxMem),
        [UAMprocessLastMemoryMB]            = $($StatusData.LastMem),
        [LoggingStatus]                     = 'NOT_RUNNING',
        [LoggingEndedDateTime]              = '$($StatusData.EndDate)'
    WHERE [username] = '$($StatusData.User)' 
      AND [userdomain] = '$($StatusData.Domain)' 
      AND [computername] = '$($StatusData.Computer)'
"@
#>
        # Voeg status toe aan de huidige lijst (Defer)
#       $null = Invoke-SqlQuery -Query $UpdateQuery -DataRecord $StatusData -Defer -OutputTo None

        # 3. Verwerk de hele batch
        if (Invoke-SqlQuery -DeferredItems $Global:DeferredQueries -OutputTo None) {
            # Of er nu gekozen is voor defer via CSV of via memory, de $Global:DeferredQueries zal nu geleegd worden...
            $Global:DeferredQueries.Clear()
            
            Write-Log "####---------------------------------------------------------------------------------------####" -Level "Info"
            Write-Log "#### (defer) CSV file mutaties naar database-----------------------------------------------####" -Level "Info"
            Write-Log "####---------------------------------------------------------------------------------------####" -Level "Info"
            Write-Log "(defer) CSV data succesvol weggeschreven naar de database." -Level "Info" -ForegroundColor Green
        
            if ($DefferedMethod -eq 'CACHE_CSV') {
                try {
                    if (Test-Path $CsvPath) {
                        Remove-Item $CsvPath -Force
                        Write-Log "(defer) CSV File succesvol verwijderd." -Level "Info" -ForegroundColor Green
                    } else {
                        # OPGELOST: Veilige waarschuwing zonder ErrorHandler crash
                        Write-Log "(defer) CSV File was al verwijderd. Maar hoe dan?" -Level "Warning" -ForegroundColor Yellow
                    }
                    # (De dubbele $Global:DeferredQueries.Clear() is hier verwijderd)
                } catch {
                    # OPGELOST: Hier mag $_ wel gebruikt worden
                    Write-Log "(defer) CSV File NIET succesvol verwijderd. Data is wel weggeschreven naar de database. $($_.Exception.Message)" -Level "Error" -ForegroundColor Red
                }
            }
            Write-Log "####-------------------------------------------------------------------------####" -Level "Info"

        } else {
            # OPGELOST: $_ verwijderd omdat we in een else-blok zitten, niet in een catch.
            Write-Log "(defer) CSV Batch NIET kunnen verwerken. Gegevens niet weg kunnen schrijven naar de database (wordt over 1 uur opnieuw geprobeerd). Logging gaat door in memory." -Level "Error" -ForegroundColor Red
            $Global:NextDateTimeCheckWrite2DB = [datetime](Get-Date).AddMinutes(60)
        }
    
    } catch {
        Write-Log "Fatale fout in database verwerking: $($_.Exception.Message)" -Level "Error"
        Throw $_
    }
} # <--- DEZE ACCOLADE MISTE (Sluit de functie af)

function Get-AppSetting {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [ValidateSet("Global", "User", "All")]
        [string]$Scope = "All",

        [Parameter(Mandatory=$false)]
        [switch]$ForceRefresh
    )

    try {
        $CurrentTime = Get-Date
        
        # Initialiseer de globale hashtable als deze nog niet bestaat
        if (Test-IsFalse $global:AppSettings) { $global:AppSettings = @{} }

        $NeedsRefresh = $ForceRefresh -or 
                        (Test-IsFalse $global:AppSettings.SettingsLastRetrieveDateTime) -or 
                        ($global:AppSettings.SettingsLastRetrieveDateTime.AddMinutes($global:AppSettings.SettingsRetrieveRefreshMinutes) -lt $CurrentTime)

        if ($NeedsRefresh) {
            Write-Verbose "Instellingen verversen uit database (Scope: $Scope)..."

            # --- GERICHTE OPSCHONING ---
            if ($Scope -eq "All") {
                $global:AppSettings = @{} 
            }
            elseif ($Scope -eq "Global") {
                # Verwijder alles wat GEEN 'USR_' prefix heeft
                $KeysToRemove = $global:AppSettings.Keys | Where-Object { $_ -notlike 'USR_*' -and $_ -ne 'SettingsLastRetrieveDateTime' }
                foreach ($K in $KeysToRemove) { $global:AppSettings.Remove($K) }
            }
            elseif ($Scope -eq "User") {
                # Verwijder alles wat WEL een 'USR_' prefix heeft
                $KeysToRemove = $global:AppSettings.Keys | Where-Object { $_ -like 'USR_*' }
                foreach ($K in $KeysToRemove) { $global:AppSettings.Remove($K) }
            }

            # --- SECTIE 1: GLOBAL SETTINGS ---
            if ($Scope -eq "Global" -or $Scope -eq "All") {
                $GlobalAppSettings = Invoke-SqlQuery -Query "SELECT *, LastRetrieveDateTime = getdate() FROM [dbo].[DeviceLoggingSettings] WHERE Setting_Enabled = 1"
                
                if (Test-IsTrue $GlobalAppSettings) {
                    foreach ($row in $GlobalAppSettings) {
                        if (Test-IsTrue $row.Setting_ValueType) {
                            try {
                                $val = $row.Setting_Value
                                $type = $row.Setting_ValueType
                                
                                Write-Log "DEBUG = Start verwerking voor setting $($row.setting_code)" -Level Debug
                                Write-Log "DEBUG = Originele database waarde `$val = '$val' (Type = $($val.GetType().Name))" -Level Debug
                                Write-Log "DEBUG = Doel type `$type = '$type'" -Level Debug

                                # Onderschep de boolean valstrik!
                                if ($type -match 'bool') {
                                    # Val eerst omzetten naar numeric [int], daarna pas naar [bool]
                                    $ConvertedBool = [bool][int]$val
                                    
                                    $global:AppSettings[$row.setting_code] = $ConvertedBool
                                    Write-Log "DEBUG = Boolean interceptie! Waarde '$val' is via numeric conversie succesvol omgezet naar PowerShell boolean = $ConvertedBool" -Level Debug
                                } else {
                                    $global:AppSettings[$row.setting_code] = $val -as $type
                                    Write-Log "DEBUG = Standaard cast uitgevoerd. Nieuwe waarde = $($global:AppSettings[$row.setting_code])" -Level Debug
                                }
                            } catch {
                                Write-Error "Fout bij casten van $($row.setting_code) naar $type. Foutmelding = $($_.Exception.Message)"
                            }
                        }
                    }
                }
            }

            # --- SECTIE 2: USER SETTINGS ---
            if ($Scope -eq "User" -or $Scope -eq "All") {
                $UserLogSettings = @(Invoke-SqlQuery -Query "SELECT *, LastRetrieveDateTime = getdate() FROM [dbo].[DeviceLoggingUsers] WHERE [username] = '$Global:useridentifier' AND [userdomain] = '$env:userdomain' AND [computername] = '$env:computername'")
                
                # Veiligheidscheck: is de array groter dan 0?
                if ($UserLogSettings.Count -gt 0) {
                    $Record = $UserLogSettings[0]
                    
                    # We pakken het echte data-object vast om arrays af te pellen
                    [psobject]$EchteDataRij = if ($Record -is [array]) { $Record[0] } else { $Record }
                    
                    # EXCLUSIE LIJST: Systeem properties van DataRows en de Primary Key uitsluiten
                    [string[]]$UitgeslotenKolommen = @(
                        'RowError', 
                        'RowState', 
                        'Table', 
                        'ItemArray', 
                        'HasErrors', 
                        'LoggingUserID' # Voeg hier desgewenst extra kolommen toe
                    )

                    # Professionele, snelle en veilige manier om properties uit te lezen
                    foreach ($RawProp in $EchteDataRij.psobject.properties.Name) {
                        [string]$property = $RawProp
                        
                        # Overslaan als de kolom op de zwarte lijst staat
                        if ($property -in $UitgeslotenKolommen) {
                            continue
                        }

                        [string]$Haskey = $property
                        
                        if ($Haskey -notlike 'USR_*') { 
                            $Haskey = 'USR_' + $property 
                        }
                        
                        # Alleen toevoegen als de waarde niet null is
                        $global:AppSettings[$Haskey] = $EchteDataRij.$property
                    }
                } else {
                    Write-Log "Gebruiker $Global:useridentifier niet gevonden in DeviceLoggingUsers of tabel is leeg." -Level Warning
                }
            }

            # --- SECTIE 3: USER OVERRIDES (De "Verflaag" die over ALLES heen gaat) ---
            # Deze sectie draait altijd bij een refresh omdat overrides op elk moment relevant zijn.
            $OverrideQuery = @"
            SELECT dlus.[Setting_code], dlus.[Setting_Value], [Setting_ValueType] = dls.Setting_ValueType
            FROM [dbo].[DeviceLoggingUserSettings] dlus
                JOIN [dbo].[DeviceLoggingSettings] dls  WITH (NOLOCK) ON dls.Setting_code = dlus.Setting_code
            WHERE dlus.[Setting_Enabled] = 1 
              AND dlus.[username] = '$Global:useridentifier'
              AND dlus.[userdomain] = '$env:userdomain'
              AND (dlus.[computername] = '$env:computername' OR dlus.[computername] IS NULL)
"@
            $UserOverrides = Invoke-SqlQuery -Query $OverrideQuery

            if (Test-IsTrue $UserOverrides) {
                foreach ($row in $UserOverrides) {
                    if (Test-IsTrue $row.Setting_ValueType) {
                        try {
                            $val = $row.Setting_Value
                            $type = $row.Setting_ValueType
                            $OldValue = $global:AppSettings[$row.Setting_code] 
                            
                            # Onderschep de boolean valstrik!
                            if ($type -match 'bool') {
                                $ConvertedBool = [bool][int]$val
                                $global:AppSettings[$row.Setting_code] = $ConvertedBool
                                Write-Log "USER OVERRIDE: Setting '$($row.Setting_code)' is nu '$ConvertedBool' voor gebruiker $Global:useridentifier (oude waarde = '$OldValue')." 
                            } else {
                                $global:AppSettings[$row.Setting_code] = $val -as $type
                                Write-Log "USER OVERRIDE: Setting '$($row.Setting_code)' is nu '$val' voor gebruiker $Global:useridentifier (oude waarde = '$OldValue')." 
                            }
                        } catch {
                            Write-Error "Fout bij casten van Override $($row.Setting_code) naar $type"
                        }
                    }
                }
            }

            # Update de algemene timestamp
            $global:AppSettings.SettingsLastRetrieveDateTime = $CurrentTime
            Write-Log "AppSettings ($Scope) succesvol bijgewerkt." -Level Debug
        }
    } catch {
        if (Get-Command ErrorHandler -ErrorAction SilentlyContinue) {
            ErrorHandler -ErrorMessage "Fout in Get-AppSetting = $($_.Exception.Message)"
        } else {
            Write-Error "Fout in Get-AppSetting = $($_.Exception.Message)"
        }
    }
}

#############################################################################################################################################
function Get-SafeSqlString {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$InputString
    )

    try {
        if ([string]::IsNullOrWhiteSpace($InputString)) {
            return ""
        }

        # 1. Enkele quotes naar dubbele enkele quotes (SQL Standaard escape)
        #    Wil je per se een " (double quote)? Vervang dan "''" door '"'
        $clean = $InputString -replace "'", '[QUOTE]' 

        # 2. Verwijder regeleinden (Carriage Return \r en Line Feed \n) en Tabs (\t)
        #    We vervangen ze door een spatie zodat woorden niet aan elkaar plakken.
        $clean = $clean -replace "[\r\n\t]", " "

        # 3. Verwijder "onmogelijke" tekens (non-printable ASCII / control characters)
        #    Dit voorkomt dat SQL Server struikelt over vage binaire restjes in error messages.
        $clean = $clean -replace '[^\x20-\x7E]', ''

        # 4. Dubbele spaties opruimen en Trimmen
        $clean = ($clean -replace "\s+", " ").Trim()

        return $clean
    }
    catch {
        # Gooi de fout door naar je ErrorHandler
        throw $_
    }
}

#############################################################################################################################################
Function Get-FormattedCallStack {
#############################################################################################################################################
    param($RawStack)
    
    if (-not $RawStack) { return "No stacktrace available" }

    # Splits de stack op de pijltjes of nieuwe regels
    $Lines = $RawStack -split ' <- '
    $CleanLines = foreach ($Line in $Lines) {
        # Gebruik regex om de functienaam en regelnummer te isoleren
        if ($Line -match "Function: (?<Func>.*?)\] @ .*?Line: (?<Line>\d+)") {
            "    > $($Matches.Func.PadRight(25)) [Line: $($Matches.Line)]"
        } else {
            "    > $Line"
        }
    }
    
    return ($CleanLines -join "`n")
}


Function Write-DetailedError {
    param (
        [Parameter(Mandatory=$true)]
        $ErrorObject,
        
        [Parameter(Mandatory=$true)]
        [string]$ProcedureName
    )

    # Haal de diepe details uit het PowerShell fout-object
    $LineNumber = $ErrorObject.InvocationInfo.ScriptLineNumber
    $ErrorMessage = $ErrorObject.Exception.Message
    $FailedItem = $ErrorObject.TargetObject
    
    # Bouw een superstrakke log string
    $LogText = "CRASH in [$ProcedureName] op regel $LineNumber!"
    if ($FailedItem) { $LogText += " (Faalde op item: $FailedItem)" }
    $LogText += " Foutmelding: $ErrorMessage"

    # Schrijf naar je lokale log
    Write-Log $LogText -Level Error

    # BONUS: Omdat je toch al een DeviceLoggingErrors tabel hebt, 
    # zou je hier in de toekomst zelfs direct een INSERT INTO kunnen doen!
}

Function ErrorHandler {
    [CmdletBinding(DefaultParameterSetName = "FromErrorRecord")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "FromErrorRecord", Position = 0)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter(Mandatory = $true, ParameterSetName = "FromManualMessage")]
        [string]$ErrorMessage,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Critical')]
        [string]$LogLevel = 'Error',

        [Parameter(Mandatory = $false)]
        [switch]$Terminate 
    )

    $Global:ErrorCount++
    
    # --- STACKTRACE ANALYSE ---
    # We proberen eerst de diepe systeem-stacktrace te pakken, anders de actuele callstack
    $StackTrace = if ($ErrorRecord.ScriptStackTrace) { 
        $ErrorRecord.ScriptStackTrace 
    } else { 
        (Get-PSCallStack | Where-Object { $_.FunctionName -notmatch "ErrorHandler" } | ForEach-Object { "$($_.FunctionName) (Lijn $($_.ScriptLineNumber))" }) -join " <- "
    }

    try {
        if ($PSCmdlet.ParameterSetName -eq "FromManualMessage") {
            $CallerFrame = Get-PSCallStack | Select-Object -Skip 1 -First 1
            $ErrorObject = [pscustomobject]@{   
                Message   = $ErrorMessage
                Script    = if ($CallerFrame.ScriptName) { Split-Path $CallerFrame.ScriptName -Leaf } else { "Dynamisch" }
                Line      = $CallerFrame.ScriptLineNumber
                Function  = $CallerFrame.FunctionName
                CallStack = $StackTrace
                Inner     = $null
            }
        } 
        else {
            # Bepaal het meest nauwkeurige regelnummer
            $BestLine = $ErrorRecord.InvocationInfo.ScriptLineNumber
            if ((Test-IsFalse $BestLine) -or $BestLine -eq 0) {
                if ($ErrorRecord.ScriptStackTrace -match 'line (\d+)') { $BestLine = $Matches[1] }
            }

            $ErrorObject = [pscustomobject]@{   
                Message   = $ErrorRecord.Exception.Message
                Script    = if ($ErrorRecord.InvocationInfo.ScriptName) { Split-Path $ErrorRecord.InvocationInfo.ScriptName -Leaf } else { "uam.ps1" }
                Line      = $BestLine
                Function  = $ErrorRecord.InvocationInfo.MyCommand.Name
                CallStack = $StackTrace
                Inner     = if ($ErrorRecord.Exception.InnerException) { $ErrorRecord.Exception.InnerException.Message } else { $null }
            }
        }

        # --- VISUELE FEEDBACK (Kleur & Structuur) ---
        $StatusColor = switch ($LogLevel) {
            'Critical' { "Red" }
            'Warning'  { "Yellow" }
            'Info'     { "Cyan" }
            Default    { "Magenta" }
        }

        Write-Log " " # Rust in de console
        Write-Log "!! [ $LogLevel ] !! ===========================================" -ForegroundColor $StatusColor
        Write-Log "  BOODSCHAP  = $($ErrorObject.Message)" -ForegroundColor White
        
        if (Test-IsTrue $ErrorObject.Inner) {
            Write-Log "  DETAILS    = $($ErrorObject.Inner)" -ForegroundColor Cyan
        }

        Write-Log "  LOCATIE    = $($ErrorObject.Script) @ Lijn $($ErrorObject.Line) (Functie: $($ErrorObject.Function))" -ForegroundColor Yellow
        Write-Log "  CALLSTACK  = $($ErrorObject.CallStack)" -ForegroundColor Gray
        Write-Log "===========================================================" -ForegroundColor $StatusColor
        Write-Log " "

        # --- DATABASE LOGGING ---
        Write-Error2DB -ErrorObject $ErrorObject -ErrorMessage $ErrorMessage -LogLevel $LogLevel

        # --- STOPPEN INDIEN NODIG ---
        if (Test-IsTrue $Terminate) {
            Write-Log "FATAL = Proces wordt geforceerd gestopt door ErrorHandler." -ForegroundColor Red
            if ($ErrorRecord) { throw $ErrorRecord } else { throw $ErrorMessage }
        }

    } catch {
        # Laatste reddingsboei als de handler zelf crasht
        $msg = "ErrorHandler Crash = $($_.Exception.Message)"
        Write-Log $msg -ForegroundColor Red
        $msg | Out-File (Join-Path $env:TEMP "UAM_Handler_Fail.txt") -Append
    }
}

<#
.SYNOPSIS
    Centrale foutafhandeling voor het script, inclusief logging naar console en database.

.DESCRIPTION
    Deze functie verwerkt zowel systeemfouten ([ErrorRecord]) als handmatige foutmeldingen. 
    Het verzamelt metadata zoals de CallStack, regelnummers en scriptnaam, en stuurt deze door naar de database via Write-Error2DB.
    Daarnaast kan de functie het script geforceerd stoppen bij kritieke fouten.

.PARAMETER ErrorRecord
    Het volledige ErrorRecord ($_) vanuit een try/catch blok. Wordt automatisch gebruikt in de 'FromErrorRecord' parameter set.

.PARAMETER ErrorMessage
    Een handmatige tekstuele foutmelding. Wordt gebruikt in de 'FromManualMessage' parameter set.

.PARAMETER LogLevel
    De ernst van de melding. Keuzes: 'Info', 'Warning', 'Error', 'Critical'. 
    Standaardwaarde is 'Error'. Deze waarde wordt doorgegeven aan de database.

.PARAMETER Terminate
    Indien geactiveerd (switch), zal de functie een 'throw' genereren om het script direct te stoppen na logging.

.EXAMPLE
    # Gebruik in een try/catch blok:
    try { 1/0 } catch { ErrorHandler -ErrorRecord $_ -LogLevel Critical -Terminate }

.EXAMPLE
    # Gebruik voor een handmatige validatie check:
    if (-not $CsvPath) { ErrorHandler -ErrorMessage "Pad is niet gevonden" -LogLevel Warning }

.LINK
    Write-Error2DB
#>
Function ErrorHandler {
    [CmdletBinding(DefaultParameterSetName = "FromErrorRecord")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "FromErrorRecord", Position = 0)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord,

        [Parameter(Mandatory = $true, ParameterSetName = "FromManualMessage")]
        [string]$ErrorMessage,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Critical')]
        [string]$LogLevel = 'Error',

        [Parameter(Mandatory = $false)]
        [switch]$Terminate 
    )

    $Global:ErrorCount++
    
    # Haal de geformatteerde CallStack op via de externe helper functie
    $FullStackString = Get-FormattedCallStack -RawStack $StackTrace
    
    # Probeer de directe aanroeper te vinden (voor logging bij handmatige meldingen)
    $CallerFrame = Get-PSCallStack | Select-Object -Skip 1 -First 1

    try {
        if ($PSCmdlet.ParameterSetName -eq "FromManualMessage") {
            # Object opbouw voor handmatige strings
            $ErrorObject = [pscustomobject]@{   
                DateTimeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss.fff")
                ComputerName  = $env:COMPUTERNAME
                UserName      = $Global:useridentifier
                UserDNSDomain = $env:USERDNSDOMAIN
                LogLevel      = $LogLevel  # Nieuwe parameter doorgegeven
                Message       = $ErrorMessage
                Script        = if ($CallerFrame.ScriptName) { $CallerFrame.ScriptName } else { "Function: $($CallerFrame.FunctionName)" }
                Line          = $CallerFrame.ScriptLineNumber
                Position      = 0
                CallStack     = $FullStackString
                InnerMessage  = $null
            }
        } 
        else {
            # Object opbouw voor systeem ErrorRecords
            $BestLine = $ErrorRecord.InvocationInfo.ScriptLineNumber
            if ($ErrorRecord.ScriptStackTrace -match 'line (\d+)') {
                $BestLine = $Matches[1]
            }

            $ErrorObject = [pscustomobject]@{   
                DateTimeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss.fff")
                ComputerName  = $env:COMPUTERNAME
                UserName      = $Global:useridentifier
                UserDNSDomain = $env:USERDNSDOMAIN
                LogLevel      = $LogLevel  # Nieuwe parameter doorgegeven
                Message       = $ErrorRecord.Exception.Message
                Script        = $ErrorRecord.InvocationInfo.ScriptName
                Line          = $BestLine
                Position      = $ErrorRecord.InvocationInfo.OffsetInLine
                CallStack     = $FullStackString
                InnerMessage  = if ($ErrorRecord.Exception.InnerException) { $ErrorRecord.Exception.InnerException.Message } else { $null }
            }
        }

        # --- VISUELE FEEDBACK IN CONSOLE ---
        # Kleur bepalen op basis van ernst
        $ConsoleColor = switch ($LogLevel) {
            'Critical' { "Red" ; break}
            'Warning'  { "Yellow" ; break}
            'Info'     { "Cyan" ; break}
            Default    { "Red" ; break}
        }

       
        Write-log "********* LOG DETAILS [$LogLevel] *********" -ForegroundColor $ConsoleColor
        Write-log "Message: $($ErrorObject.Message)" -ForegroundColor White
        Write-log "Source:  $($ErrorObject.Script) (Line: $($ErrorObject.Line))" -ForegroundColor Gray
        Write-log "Stack:   $($ErrorObject.CallStack)" -ForegroundColor DarkGray
        Write-log "*******************************************"
        
        # --- DATABASE LOGGING ---
        # Geef het object (inclusief LogLevel) door aan de database writer
        Write-Error2DB -ErrorObject $ErrorObject -ErrorMessage $ErrorMessage -LogLevel $LogLevel

        # --- TERMINATIE LOGICA ---
        if ($Terminate) {
            Write-Log "Fataal procesonderbreking: Script wordt geforceerd gestopt." -ForegroundColor Red
            if ($ErrorRecord) { throw $ErrorRecord } else { throw $ErrorMessage }
        }

        # --- GEBRUIKERS INTERACTIE ---
        if ($null -eq $Global:QuietMode -or $Global:QuietMode -eq $false) {
            Write-Log "Druk op een toets om door te gaan..." -ForegroundColor Yellow
            $null = [Console]::ReadKey($true)
        }

    } catch {
        # Ultieme fallback naar een lokaal tekstbestand als SQL of Console faalt
        $BackupLog = Join-Path ([System.IO.Path]::GetTempPath()) "UAM_Critical_Error.txt"
        "$(Get-Date -Format 'u') - [$LogLevel] ErrorHandler Failure: $($_.Exception.Message)" | Out-File $BackupLog -Append
    }
}

<#
.SYNOPSIS
    Schrijft foutdetails naar de centrale SQL-database of een lokaal fallback-bestand.

.DESCRIPTION
    Deze functie is de 'database writer' voor het foutbeheersysteem. Het ontvangt data via een rijk ErrorObject 
    of een platte ErrorMessage. De functie zorgt voor SQL-veiligheid door strings te escapen en verzamelt 
    aanvullende systeemgegevens zoals Windows-versie en procesinformatie.

    Mocht de verbinding met de SQL-server falen, dan schakelt de functie automatisch over naar een 
    lokale CSV-fallback (UAM_Error_Fallback.csv) om dataverlies te voorkomen.

.PARAMETER ErrorObject
    Een PSCustomObject (meestal gegenereerd door de ErrorHandler) dat alle metadata bevat zoals CallStack, 
    Scriptnaam, Lijnnummer en LogLevel. (ParameterSetName: ByObject)

.PARAMETER ErrorMessage
    Een directe string-foutmelding. Gebruik dit voor snelle logging zonder uitgebreid object. 
    (ParameterSetName: ByMessage)

.PARAMETER LogLevel
    Bepaalt de ernst van de melding. Toegestane waarden: Error, Warning, Information, Critical.
    Indien een ErrorObject wordt meegegeven, heeft het LogLevel in dat object voorrang.

.EXAMPLE
    Write-Error2DB -ErrorMessage "Verbinding met API verbroken" -LogLevel Warning
    Schrijft een handmatige waarschuwing direct naar de database.

.EXAMPLE
    $ErrorObj = [pscustomobject]@{Message="Fataal"; LogLevel="Critical"; Script="Main.ps1"; Line=10}
    Write-Error2DB -ErrorObject $ErrorObj
    Verwerkt het object en gebruikt 'Critical' als loglevel voor de SQL-insert.

.NOTES
    Vereist de aanwezigheid van de tabel [DeviceLoggingErrors] en de functie Invoke-SqlQuery.
#>
Function Write-Error2DB {
    [CmdletBinding(DefaultParameterSetName = "ByObject")]
    param (
        [Parameter(ParameterSetName = "ByObject", Position = 0)]
        $ErrorObject,

        [Parameter(ParameterSetName = "ByMessage")]
        [string]$ErrorMessage,

        [Parameter()]
        [ValidateSet("Error", "Warning", "Information", "Critical")]
        [string]$LogLevel = "Error"
    )

    Try {
        # 1. Bepaal de bron van de data
        if ($PSCmdlet.ParameterSetName -eq "ByMessage") {
            $RawMsg = $ErrorMessage
            $FinalLogLevel = $LogLevel
        } else {
            $RawMsg = $ErrorObject.Message
            $FinalLogLevel = if ($ErrorObject.LogLevel) { $ErrorObject.LogLevel } else { $LogLevel }
        }

        # 2. SQL-veilig maken en defaults bepalen
        # We gebruiken Get-SafeSqlString om SQL-injection te voorkomen (enkel quote escaping)
        $DTStamp    = Get-SafeSqlString -InputString $(if (Test-HasContent $ErrorObject.DateTimeStamp) { $ErrorObject.DateTimeStamp } else { (Get-Date).ToString('yyyy-MM-dd HH:mm:ss.fff') })
        $Comp       = Get-SafeSqlString -InputString $(if (Test-HasContent $ErrorObject.ComputerName)  { $ErrorObject.ComputerName }  else { $env:COMPUTERNAME })
        $User       = Get-SafeSqlString -InputString $(if (Test-HasContent $ErrorObject.UserName)      { $ErrorObject.UserName }      else { $env:USERNAME })
        
        $Msg        = Get-SafeSqlString -InputString $RawMsg
        $Script     = Get-SafeSqlString -InputString $(if (Test-HasContent $ErrorObject.Script)    { $ErrorObject.Script }    else { "Manual Log" })
        $CallStack  = Get-SafeSqlString -InputString $(if (Test-HasContent $ErrorObject.CallStack) { $ErrorObject.CallStack } else { "N/A" })
        
        $ExecPath   = Get-SafeSqlString -InputString $(if (Test-HasContent $Global:This_UAM_Process.FullpathExecutable) { $Global:This_UAM_Process.FullpathExecutable } else { "Unknown" })
        $StartTime  = Get-SafeSqlString -InputString $(if (Test-HasContent $Global:This_UAM_Process.starttime) { $Global:This_UAM_Process.starttime.ToString('yyyy-MM-dd HH:mm:ss.fff') } else { $DTStamp })
        
        $LineNo     = $(if (Test-HasContent $ErrorObject.Line) { $ErrorObject.Line } else { 0 })
        $Position   = $(if (Test-HasContent $ErrorObject.Position) { $ErrorObject.Position } else { 0 })
        $WinVersion = Get-SafeSqlString -InputString $(if (Test-HasContent $Global:This_UAM_Process.WindowsVersion) { $Global:This_UAM_Process.WindowsVersion } else { (Get-CimInstance Win32_OperatingSystem).Version })

        # 3. SQL Statement opbouwen
        $SQLStatement = @"
            INSERT INTO DeviceLoggingErrors (
                [DatetimeStamp], [Computername], [UserName], [UserDNSDomain], 
                [ErrorMessage], [LogLevel], [Script], [Line], [Position], [CallStack], 
                UAM_Commandline, UAM_CreationDate, WindowsVersion
            ) 
            VALUES (
                '$DTStamp', '$Comp', '$User', '$($env:USERDNSDOMAIN)', 
                '$Msg', '$FinalLogLevel', '$Script', $LineNo, $Position, '$CallStack', 
                '$ExecPath', '$StartTime', '$WinVersion'
            )
"@

        # 4. Uitvoeren
        Invoke-SqlQuery -Query $SQLStatement -ErrorAction Stop

    } catch {
        # --- FALLBACK LOGICA BIJ DATABASE FOUTEN ---
        Write-Warning "Write-Error2DB: SQL-verbinding faalde. Schrijven naar nood-log..."
        
        try {
            $LogFolder = if ($Global:RootPath) { $Global:RootPath } else { $env:TEMP }
            $CSVPath   = Join-Path -Path $LogFolder -ChildPath "UAM_Error_Fallback.csv"

            $FallbackObject = [PSCustomObject]@{
                TimeStamp     = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                ComputerName  = $env:COMPUTERNAME
                UserName      = $env:USERNAME
                OriginalError = $RawMsg
                SqlError      = $_.Exception.Message
                LogLevel      = $FinalLogLevel
                Script        = $Script
            }

            $FallbackObject | Export-Csv -Path $CSVPath -NoTypeInformation -Append -Delimiter ";" -Encoding UTF8
            Write-Log "Fallback-log bijgewerkt: $CSVPath" -ForegroundColor Yellow
        } catch {
            Write-Error "CRITICAL: Database en CSV logging beide mislukt! Fout: $($_.Exception.Message)"
        }
    }
}

function Invoke-SQLiteQuery {
    param($DbFile, $Query, $BrowserName)

    $Global:LastSqliteQueryFailed = $false
    
    # --- STRATEGIE 1: PROBEER DLL ---
    try {
        $dbHandle = [IntPtr]::Zero
        $stmtHandle = [IntPtr]::Zero
        $results = New-Object System.Collections.Generic.List[PSObject]

        Write-Log "Poging openen SQLite: $DbFile" -Level Debug
        if ([WinSqliteHybride]::sqlite3_open($DbFile, [ref]$dbHandle) -eq 0) {
            if ([WinSqliteHybride]::sqlite3_prepare_v2($dbHandle, $Query, -1, [ref]$stmtHandle, [IntPtr]::Zero) -eq 0) {
                $columnCount = [WinSqliteHybride]::sqlite3_column_count($stmtHandle)
                
                while ([WinSqliteHybride]::sqlite3_step($stmtHandle) -eq 100) {
                    $rowHash = [ordered]@{ }
                    for ($i = 0; $i -lt $columnCount; $i++) {
                        $name = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi([WinSqliteHybride]::sqlite3_column_name($stmtHandle, $i))
                        $val  = [System.Runtime.InteropServices.Marshal]::PtrToStringAnsi([WinSqliteHybride]::sqlite3_column_text($stmtHandle, $i))
                        $rowHash[$name] = $val
                    }
                    $results.Add([PSCustomObject]$rowHash)
                }
                [WinSqliteHybride]::sqlite3_finalize($stmtHandle) | Out-Null
                [WinSqliteHybride]::sqlite3_close($dbHandle) | Out-Null

                return @($results)
            }
            [WinSqliteHybride]::sqlite3_close($dbHandle) | Out-Null
        }
    } catch { 
        Write-Log "DLL methode faalde voor $BrowserName . Error $BrowserName = $($_.Exception.Message)" -Level Debug
    }
    # GEEN System.GC hier!

    # --- STRATEGIE 2: TERUGVAL OP EXE ---
    try {
        $SqliteEXE = Join-Path $Global:RootPath "sqlite\uam.exe"

        if (Test-Path $SqliteEXE) {
            $output = & "$SqliteEXE" -header -csv "$DbFile" "$Query" 2>$null
            
            if ($LASTEXITCODE -eq 0 -and (Test-IsTrue $output)) {
                # Snelle conversie zonder zware filtering vooraf
                return @($output | ConvertFrom-Csv -ErrorAction SilentlyContinue)
            }
        }
    } catch {
        $Global:LastSqliteQueryFailed = $true
        # Geen Throw gebruiken in een discovery loop, dat stopt de hele EXE
        Write-Error "Zowel DLL als EXE methode faalde voor $BrowserName"
    }

    return @()
}

Function Remove-TempFolderWithRetries {
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [int]$MaxRetries = 3,
        [int]$DelayMilliseconds = 500
    )

    $retryCount = 0
    $success = $false

    # BEWAAR de oude instelling en zet de voortgangsbalk UIT
    $oldPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    while (-not $success -and $retryCount -lt $MaxRetries) {
        try {
            if (Test-Path $Path) {
                Remove-Item $Path -Recurse -Force -ErrorAction Stop
            }
            $success = $true
        }
        catch {
            $retryCount++
            if ($retryCount -lt $MaxRetries) {
                Write-Log "Poging $retryCount`: Kon map $Path niet verwijderen. Wachten op retry... ($($_.Exception.Message))" -ForegroundColor Yellow
                Start-Sleep -Milliseconds $DelayMilliseconds
            }
            else {
                Write-Log "Fout: Map $Path kon niet verwijderd worden na $MaxRetries pogingen. Melding: $($_.Exception.Message)" -Level Error
            }
        }
    }

    # ZET de instelling weer TERUG naar wat het was
    $ProgressPreference = $oldPreference
    return $success
}

#############################################################################################################################################
Function Stop-OtherProcesses {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]      
        [int]$ProcessPID,
        [int]$MaxRetries = 3,
        [int]$WaitTimeSeconds = 2
    )

    try {
        Write-Log "Poging tot beëindigen van proces met PID: $ProcessPID..." -ForegroundColor Cyan
        
        # --- VERBETERING 1: Expliciete error-catch om Access Denied (Rechtenprobleem) te ontdekken ---
        $CheckProc = $null
        try {
            $CheckProc = Get-Process -Id $ProcessPID -ErrorAction Stop
        } catch {
            Write-Log "FATALE FOUT bij benaderen van PID $ProcessPID=$($_.Exception.Message)" -ForegroundColor Red
            Write-Log "Tip: Waarschijnlijk draait het doelproces als Administrator en VS Code als normale gebruiker." -ForegroundColor Yellow
            return
        }

        # --- Terminal Server Beveiliging ---
        $MySessionId = [int](Get-Process -Id $PID).SessionId
        
        if ($null -ne $CheckProc -and $CheckProc.SessionId -ne $MySessionId) {
            Write-Log "VEILIGHEIDSBLOKKADE: PID $ProcessPID behoort tot sessie $($CheckProc.SessionId), niet tot huidige sessie ($MySessionId). Kill-order afgebroken!" -ForegroundColor Red
            return
        }

        # --- VERBETERING 2: Native Null-check in plaats van Test-HasNoContent ---
        if ($null -eq $CheckProc) {
            Write-Log "Geen proces gevonden met PID $ProcessPID (mogelijk zojuist afgesloten)." -ForegroundColor Gray
            return
        }

        $PName = [string]$CheckProc.ProcessName
        $Success = [bool]$false
        $RetryCount = [int]0

        while ((Test-IsFalse $Success) -and $RetryCount -lt $MaxRetries) {
            $RetryCount++
            try {
                Write-Log "Kill-commando versturen naar $PName (PID $ProcessPID)... (Poging $RetryCount)" -ForegroundColor Gray

                # Stop het proces (Met expliciete Stop action voor foutafhandeling)
                Stop-Process -Id $ProcessPID -Force -ErrorAction Stop
                
                Start-Sleep -Milliseconds 500
                $StillAlive = Get-Process -Id $ProcessPID -ErrorAction SilentlyContinue
                
                if ($null -eq $StillAlive) {
                    $Success = [bool]$true
                    Write-Log " [OK] PID $ProcessPID succesvol beëindigd." -ForegroundColor Green
                    
                    $DbMsg = [string]"Opschoning: Oude sessie van $PName (PID=$ProcessPID) gestopt door PID=$PID."
                    Write-Error2DB -ErrorMessage $DbMsg -LogLevel "Information" -ErrorAction SilentlyContinue
                }
            }
            catch {
                if ($RetryCount -lt $MaxRetries) {
                    Write-Log " - Kill mislukt: $($_.Exception.Message). Wachten op retry..." -ForegroundColor DarkGray
                    Start-Sleep -Seconds $WaitTimeSeconds
                } else {
                    $ErrMsg = [string]"Kon proces $PName (PID=$ProcessPID) na $MaxRetries pogingen niet stoppen. Fout: $($_.Exception.Message)"
                    ErrorHandler -ErrorMessage $ErrMsg
                    $global:startLogging = [bool]$false # Stop verdere logging om cascade-failures te voorkomen
                }
            }
        }
    }
    catch {
        ErrorHandler -ErrorRecord $_
    }

}


#############################################################################################################################################
Function Test-OtherProcessRunning {
#############################################################################################################################################
    [CmdletBinding()]
    param(
        [string]$ProcessName = $null,
        [string]$Productname = $null,
        [int]$CurrentPID = $PID,
        [switch]$KillProcesses,
        [ValidateSet('NewerProcessesFound', 'OlderProcessesFound')]
        [string]$KillCondition = 'OlderProcessesFound'
    )

    $RetVal = [string]'NonOtherProcesses'

    try {
        $MySessionId = [int](Get-Process -Id $CurrentPID).SessionId

        if (Test-HasNoContent $ProcessName) {
            $ProcessName = [string][System.IO.Path]::GetFileName((Get-Process -Id $CurrentPID).MainModule.FileName)
        }

        # Zorg dat de .exe extensies eraf zijn voor Get-Process
        $ProcessListNet = $ProcessName -split ',' | ForEach-Object { ($_.Trim() -replace '(?i)\.exe$', '') }

        if (Test-HasContent $Global:This_UAM_Process.CreationDate) {
            $CurrentStartTime = [datetime]$Global:This_UAM_Process.CreationDate
        } else {
            $CurrentProc = Get-Process -Id $CurrentPID
            if ($null -ne $CurrentProc.StartTime) {
                $CurrentStartTime = [datetime]$CurrentProc.StartTime
            } else {
                # Fallback mocht de starttijd van onszelf onleesbaar zijn
                $CurrentStartTime = [datetime](Get-Date)
            }
        }

        # Haal ALLE processen op met die naam (ongeacht sessie of gebruiker)
        $RawProcesses = @(Get-Process -Name $ProcessListNet -ErrorAction SilentlyContinue)

        if (Test-HasRows $RawProcesses) {
            foreach ($proc in $RawProcesses) {
                $OtherPID = [int]$proc.Id 

                # Negeer onszelf
                if ($OtherPID -eq $CurrentPID) { continue }

                # Controleer de SessionId voor Terminal Server beveiliging
                try {
                    $ProcSession = [int]$proc.SessionId
                } catch {
                    $ProcSession = [int]-1 # Als we de sessie niet kunnen uitlezen wegens rechten
                }

                if ($ProcSession -ne $MySessionId) {
                    Write-Log "DEBUG: Proces '$($proc.ProcessName)' (PID = $OtherPID) genegeerd. Sessie mismatch ($ProcSession vs $MySessionId)." -ForegroundColor DarkGray
                    continue 
                }

                # Metadata ophalen
                try {
                    $ExePath = [string]$proc.MainModule.FileName
                    if ([string]::IsNullOrWhiteSpace($ExePath)) {
                        $versionInfo = $proc.MainModule.FileVersionInfo
                    } else {
                        $versionInfo = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ExePath)
                    }

                    $extraprocinfo = [PSCustomObject]@{
                        ProcessName = [string]"$($proc.ProcessName).exe"
                        Id          = $OtherPID
                        ProductName = [string]$versionInfo.ProductName
                    }
                } catch { 
                    Write-Log "DEBUG: Proces metadata van PID = $OtherPID overgeslagen (Access Denied). Waarschijnlijk een Admin proces in huidige sessie." -ForegroundColor DarkYellow
                    continue 
                }

                # Filtering en Beoordeling
                try {
                    Write-Log "DEBUG: Proces '$($extraprocinfo.ProcessName)' (PID = $OtherPID) gelezen. Ingebouwde ProductName = '$($extraprocinfo.ProductName)'" -ForegroundColor DarkGray
                    
                    # --- SLIMMER PRODUCTNAME FILTER ---
                    if ($Productname) {
                        if ([string]::IsNullOrWhiteSpace($extraprocinfo.ProductName)) {
                            Write-Log "DEBUG: ProductName van PID = $OtherPID is leeg (waarschijnlijk door ontbrekende Admin rechten). We vertrouwen op de bestandsnaam '$($extraprocinfo.ProcessName)'." -ForegroundColor DarkYellow
                        } 
                        elseif ($extraprocinfo.ProductName -notlike "*$Productname*") {
                            Write-Log "DEBUG: Proces (PID = $OtherPID) afgewezen = ProductName '$($extraprocinfo.ProductName)' is niet gelijk aan '$Productname'." -ForegroundColor DarkYellow
                            continue 
                        }
                    }
                    # ----------------------------------
                        
                    # --- NATIVE NULL-CHECK OM DATETIME CAST CRASHES TE VOORKOMEN ---
                    if ($null -eq $proc.StartTime) {
                        Write-Log "DEBUG: StartTime van PID = $OtherPID is leeg (waarschijnlijk door ontbrekende Admin rechten). Proces overgeslagen." -ForegroundColor DarkYellow
                        continue
                    }
                    $OtherStartTime = [datetime]$proc.StartTime
                    # ---------------------------------------------------------------
                    
                    $StatusTxt = if ($CurrentStartTime -lt $OtherStartTime) { "NIEUWER" } else { "OUDER" }
                    $CurrentStatus = if ($CurrentStartTime -lt $OtherStartTime) { 'NewerProcessesFound' } else { 'OlderProcessesFound' }
                    
                    Write-Log "Gevonden in scope: '$($extraprocinfo.ProcessName)' (PID = $OtherPID). Status = $StatusTxt." -ForegroundColor Gray

                    if ($RetVal -ne 'NewerProcessesFound') {
                        $RetVal = [string]$CurrentStatus
                    }

                    if ($KillProcesses -and ($CurrentStatus -eq $KillCondition)) {
                        Write-Log "KILL-ORDER: Beëindigen van $StatusTxt proces '$($extraprocinfo.ProcessName)' (PID = $OtherPID)..." -ForegroundColor Cyan
                        Stop-OtherProcesses -ProcessPID $OtherPID
                    }

                    if ($CurrentStatus -eq 'NewerProcessesFound') {
                        try {
                            $DbMsg = [string]"CONFLICT: Nieuwere sessie gevonden = $($extraprocinfo.ProcessName) PID = $OtherPID"
                            Write-Error2DB -ErrorMessage $DbMsg -LogLevel "Warning" -ErrorAction SilentlyContinue
                        } catch {}
                    }
                } catch {
                    ErrorHandler -ErrorRecord $_ -Terminate
                }
            } 
        }
    } catch {
        ErrorHandler -ErrorRecord $_ -Terminate
    }

    return [string]$RetVal
}

#############################################################################################################################################
## EINDE ALGEMENE FUNCTIES 
#############################################################################################################################################


#############################################################################################################################################
## BEGIN FUNCTIES TBV TASKS
#############################################################################################################################################



Function New-MinimalLoggingQueryBlock {
    param(
        [string]$Username,
        [string]$UserDomain,
        [string]$TypeData,
        [string]$DataValue,
        [string]$DateString,
        [string]$MinTimeSql
    )
    
    # 1580 limiet om SQL Index Warning te voorkomen
    $cleanData = Format-SqlString -InputObject $DataValue -MaxLength 1580
    
    $Query = @"
IF NOT EXISTS (
    SELECT 1 FROM [dbo].[uam_log_minimal] 
    WHERE [username] = '$Username' AND [userdomain] = '$UserDomain' AND [data_collection_type] = '$TypeData' AND [data] = $cleanData
)
BEGIN
    INSERT INTO [dbo].[uam_log_minimal] ([username], [userdomain], [data_collection_type], [data], [first_logged_datetime])
    VALUES ('$Username', '$UserDomain', '$TypeData', $cleanData, $MinTimeSql);
END;

INSERT INTO [dbo].[uam_log_minimal_dates] ([LogID], [UsedOnDate])
SELECT [LogID], '$DateString'
FROM [dbo].[uam_log_minimal]
WHERE [username] = '$Username' AND [userdomain] = '$UserDomain' AND [data_collection_type] = '$TypeData' AND [data] = $cleanData;

"@

    return $Query
}

#############################################################################################################################################
##>> ==> WEB BROWSER FUNCTIES <<== ##
#############################################################################################################################################

Function Export-BrowserHistory2DB {
    param ($TaskObject)

    try {
        Write-Log "Export-BrowserHistory2DB gestart met Task = $($TaskObject.Label)" -Level Debug
        $regex = '(?i)https?:\/\/([^\/ :]+)'

        foreach ($BrowserName in $TaskObject.Browsers.Keys) {
            $BData = $TaskObject.Browsers[$BrowserName]
            $ProcessedData = [System.Collections.Generic.List[psobject]]::new()

            if (-not $BData.Enabled) { continue }

            try {
                $Global:LastSqliteQueryFailed = [bool]$false
                $history = @(Get-BrowserHistory -BrowserName $BrowserName -TaskObject $TaskObject)

                if ($Global:LastSqliteQueryFailed) { throw "Sqlite error bij browser $BrowserName" }

                $CleanHistory = $history | Where-Object { $_ -is [PSCustomObject] -and $null -ne $_.Url }
                $LatestItem = $null
                
                if ($CleanHistory.Count -gt 0) {
                    $LatestItem = ($CleanHistory | Measure-Object -Property VisitTime -Maximum).Maximum
                    Write-Log "Nieuwe items gevonden in DB voor $BrowserName = $($CleanHistory.Count)"
                    
                    # --- Exclusie ---
                    foreach ($item in $CleanHistory) {
                        $extractedDomain = [string]"Unknown"
                        if ($item.Url -match $regex) { $extractedDomain = [string]$Matches[1] }

                        $IsExcluded = [bool]$false
                        if ($null -ne $Global:Tasks.BrowserHistory.ExcludeList) {
                            foreach ($Rule in $Global:Tasks.BrowserHistory.ExcludeList) {
                                if ([string]::IsNullOrWhiteSpace($Rule.URLExpression) -and [string]::IsNullOrWhiteSpace($Rule.domainExpression)) { continue }
                                if ($Rule.URLExpression -isnot [System.DBNull] -and -not [string]::IsNullOrWhiteSpace($Rule.URLExpression) -and ($item.Url -notlike $Rule.URLExpression)) { continue }
                                if ($Rule.domainExpression -isnot [System.DBNull] -and -not [string]::IsNullOrWhiteSpace($Rule.domainExpression) -and ($extractedDomain -notlike $Rule.domainExpression)) { continue }
                                $IsExcluded = [bool]$true
                                break
                            }
                        }

                        if (-not $IsExcluded) {
                            [void]$ProcessedData.Add([PSCustomObject]@{
                                Browser   = [string]$item.Browser
                                Url       = [string]$item.Url
                                Title     = [string]$item.Title
                                VisitTime = [datetime]$item.VisitTime
                                domain    = $extractedDomain
                            })
                        }
                    }
                }

                $Query2Execute = [string]""

                if ($ProcessedData.Count -gt 0) {
                    [array]$UniqueDetailedData = $ProcessedData | Sort-Object Url, VisitTime -Unique

                    # --- Detailed Logging ---
                    if ($TaskObject.DetailedLog) {
                        $QueryParts = [System.Collections.Generic.List[string]]::new()
                        foreach ($row in $UniqueDetailedData) {
                            # VEILIGE CAST!
                            $SafeVisitTime = $row.VisitTime -as [datetime]
                            if (-not $SafeVisitTime) { continue }
                            
                            $vTimeSql = Format-SqlString -InputObject $SafeVisitTime.ToString("yyyy-MM-dd HH:mm:ss.fffffff")
                            $cleanUrl = Format-SqlString -InputObject $row.url -MaxLength 2000
                            $cleanDomain = Format-SqlString -InputObject $row.domain -MaxLength 2000
                            [void]$QueryParts.Add("SELECT '$env:computername', '$Global:useridentifier', '$env:userdomain', '$($row.Browser)', $vTimeSql, $cleanDomain, $cleanUrl")
                        }
                        
                        if ($QueryParts.Count -gt 0) {
                            # CHUNKING (Max 500 per SQL transactie)
                            $BatchSize = 500
                            for ($i = 0; $i -lt $QueryParts.Count; $i += $BatchSize) {
                                $Count = if (($i + $BatchSize) -le $QueryParts.Count) { $BatchSize } else { $QueryParts.Count - $i }
                                $Batch = $QueryParts.GetRange($i, $Count)
                                $Query2Execute += "INSERT INTO [dbo].[DeviceBrowserLogging] ([computername],[username],[userdomain],[browser],[datetime],[domain],[url]) `n" 
                                $Query2Execute += "  " + ($Batch -join " UNION ALL ") + ";`n"
                            }
                        }
                    }

                    # --- Minimum Logging (Nieuwe Architectuur) ---
                    if ($TaskObject.MinimumLog) {
                        $TypeData = 'domain'
                        $GroupedDomains = $ProcessedData | Where-Object { -not [string]::IsNullOrWhiteSpace($_.domain) -and $_.domain -ne "Unknown" } | Group-Object domain

                        foreach ($Group in $GroupedDomains) {
                            $DomainName = $Group.Name
                            
                            # VEILIGE MIN-TIME BEREKENING!
                            $MinTimeValue = ($Group.Group | Measure-Object -Property VisitTime -Minimum).Minimum
                            $MinDate = $MinTimeValue -as [datetime]
                            if (-not $MinDate) { $MinDate = (Get-Date) }
                            $vMinTimeSql = Format-SqlString -InputObject $MinDate.ToString("yyyy-MM-dd HH:mm:ss.fffffff")
                            
                            # VEILIGE DAG-EXTRACTIE!
                            $UniqueDaysInBatch = $Group.Group | ForEach-Object { 
                                $dt = $_.VisitTime -as [datetime]
                                if ($dt) { $dt.Date }
                            } | Sort-Object | Select-Object -Unique

                            foreach ($Day in $UniqueDaysInBatch) {
                                if (-not $Day) { continue }
                            
                                $CacheCollection = $Global:PreviouslyLoggedRows.Where({$_.data_collection_type -eq $TypeData -and $_.data -eq $DomainName}, 'First')
                                $CacheMatch = if ($CacheCollection) { $CacheCollection[0] } else { $null }
                                
                                # VEILIGE CACHE CHECK!
                                $AlreadyLogged = $false
                                if ($CacheMatch -and $CacheMatch.LastUsedDate) {
                                    $LastUsedDate = $CacheMatch.LastUsedDate -as [datetime]
                                    if ($LastUsedDate -and $LastUsedDate.Date -ge $Day.Date) {
                                        $AlreadyLogged = $true
                                    }
                                }

                                if ($AlreadyLogged) { continue }

                                $DateStr = $Day.ToString('yyyy-MM-dd')
                                $Query2Execute += New-MinimalLoggingQueryBlock -Username $Global:useridentifier -UserDomain $env:userdomain -TypeData $TypeData -DataValue $DomainName -DateString $DateStr -MinTimeSql $vMinTimeSql

                                # DE FIX: OUDE READ-ONLY ERUIT, NIEUWE ERIN
                                if ($CacheMatch) { [void]$Global:PreviouslyLoggedRows.Remove($CacheMatch) }
                                [void]$Global:PreviouslyLoggedRows.Add([PSCustomObject]@{
                                    data_collection_type = $TypeData
                                    data = $DomainName
                                    LastUsedDate = $Day.Date
                                })
                            }
                        }
                    }
                }

                # --- Checkpoint Verzetten ---
                if ($null -ne $LatestItem) {
                    # VEILIGE CAST VOOR CHECKPOINT
                    $SafeLatest = $LatestItem -as [datetime]
                    if ($SafeLatest) {
                        $vTimeUpdate = $SafeLatest.ToString("yyyy-MM-dd HH:mm:ss.fffffff")
                        $ColName = [string]"LastBrowser$($BrowserName)LogDateTime"
                        
                        if ($ProcessedData.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($Query2Execute)) {
                            $Query2Execute += "UPDATE [dbo].[DeviceLoggingUsers] SET [$ColName] = '$vTimeUpdate' WHERE [username] = '$Global:useridentifier' AND [computername] = '$env:computername';"
                            $null = Invoke-SqlQuery -Query $Query2Execute -Defer -OutputTo CSV
                        } else {
                            $UpdateOnlyQuery = "UPDATE [dbo].[DeviceLoggingUsers] SET [$ColName] = '$vTimeUpdate' WHERE [username] = '$Global:useridentifier' AND [computername] = '$env:computername';"
                            $null = Invoke-SqlQuery -Query $UpdateOnlyQuery -Defer -OutputTo CSV
                        }
                        $BData.Checkpoint.NewestLogDatetime = $SafeLatest
                    }
                }
            } catch {
                # NIEUWE ERROR HANDLER VOOR DE BROWSER LOOP (Inner Catch)
                $BData.Enabled = [bool]$false
                $BData.Error   = [string]$_.Exception.Message
                Write-DetailedError -ErrorObject $_ -ProcedureName "Export-BrowserHistory2DB (Inner loop: $BrowserName)"
            }        
        }
    } catch {   
        # NIEUWE ERROR HANDLER VOOR DE HOOFDFUNCTIE (Outer Catch)
        Write-DetailedError -ErrorObject $_ -ProcedureName "Export-BrowserHistory2DB (Main)"
        throw $_
    }
}


function Get-BrowserHistory {
    param(
        [string]$BrowserName, 
        [object]$TaskObject
    )
    $tempFolder = $null
    
    try {
        $BData = $TaskObject.Browsers[$BrowserName]
        if ($null -eq $BData) { throw "BrowserData voor $BrowserName niet gevonden." }
        
        $Cfg = $BData.FetchInfo
        $Since = $BData.Checkpoint.NewestLogDatetime

        $uniqueID   = [string][guid]::NewGuid().ToString("n").Substring(0, 8)
        $tempFolder = Join-Path $env:LOCALAPPDATA "UAM\$BrowserName\$uniqueID"
        
        if (-not (Test-Path $tempFolder)) { 
            $null = New-Item -Path $tempFolder -ItemType Directory -Force 
        }

        # Datum converteren voor de Query
        $Formula = $Cfg.Formula_fromdate
        $SinceValue = & $Formula $Since

        # Bestanden kopiëren
        $localDb = Join-Path $tempFolder (Split-Path $BData.OriginalPath -Leaf)
        cmd.exe /c copy /y `"$($BData.OriginalPath)*`" `"$tempFolder\`" > $null 2>&1

        $FinalQuery = [string]$Cfg.Query.Replace("<<sinceMicro>>", [string]$SinceValue)
        
        # Haal rijen op en filter direct op PSCustomObject
        $Global:LastSqliteQueryFailed = [bool]$false
        $rows = @(Invoke-SQLiteQuery -DbFile $localDb -Query $FinalQuery -BrowserName $BrowserName) | Where-Object { $_ -is [PSCustomObject] }

        if ($Global:LastSqliteQueryFailed -eq $true){
            return [array]@()
        }

        # PERFORMANCE UPGRADE: List in plaats van Array
        $results = [System.Collections.Generic.List[psobject]]::new()

        foreach ($row in $rows) {
            # Extreem streng filter op lege strings en nulls
            if ([string]::IsNullOrWhiteSpace($row.url) -or $row.url -eq "url") { 
                continue 
            }

            $rawVal = $(if($row.last_visit_time){$row.last_visit_time}else{$row.visit_date})
            $convertedDate = $null

            # --- ROBUUSTE DATUM CONVERSIE ---
            if ($rawVal -is [DateTime]) {
                # De DLL heeft het al netjes gedaan
                $convertedDate = [datetime]$rawVal
            }
            elseif ([string]$rawVal -match '^\d{1,19}$') {
                # Het is een getal (WebKit/Unix), voer formule uit
                $ToDateFormula = $Cfg.Formula_ToDate
                
                try {
                    $convertedDate = [datetime](& $ToDateFormula ([int64]$rawVal))
                } catch {
                    $convertedDate = [DateTime]::new(1753, 1, 1)
                }
            }
            else {
                # Corrupt of onbekend, gebruik epoch fallback om crashes te voorkomen
                $convertedDate = [DateTime]::new(1753, 1, 1)
            }
            # --------------------------------

            $ExtractedUrl = [string]$(if($row.url){$row.url}else{$row.URL})
            $ExtractedTitle = [string]$(if($row.title){$row.title}else{$row.TITLE})

            [void]$results.Add([PSCustomObject]@{
                Browser   = [string]$BrowserName
                Url       = [string]$ExtractedUrl
                Title     = [string]$ExtractedTitle
                VisitTime = [datetime]$convertedDate
            })
        }
        
        # EXPLICIETE CASTING VOOR PSU 5.5
        return [array]$results.ToArray()
    } catch { 
        ErrorHandler $_ 
    } finally {
        if ($tempFolder) { 
            Remove-TempFolderWithRetries -Path $tempFolder 
        }
    }
}

Function Update-DeviceBrowserExcludeList {
    param ($TaskObject)

    try {
        Write-Log "Ophalen van de uit te sluiten URL's en domeinen vanuit de database tabel DeviceBrowserLogging2Exclude" -ForegroundColor Gray
        
        # We halen alle velden op uit de browser exclude tabel, maar filteren direct in SQL op Enabled=1
        $Query = [string]"SELECT * FROM [DeviceBrowserLogging2Exclude] WHERE Enabled=1" 
        $ExcludeData = Invoke-SqlQuery -Query $Query
        
        if (Test-HasRows $ExcludeData) {
            
            # We slaan het hele object op in de correcte, originele eigenschap ExcludeList
            $Global:Tasks.BrowserHistory.ExcludeList = [array]$ExcludeData
            Write-Log "Succes: ExcludeList voor BrowserHistory bijgewerkt. Aantal regels = $($Global:Tasks.BrowserHistory.ExcludeList.Count)" -Level Debug
        }
        else {
            # Expliciet leegmaken als de database query geen resultaten oplevert
            $Global:Tasks.BrowserHistory.ExcludeList = @()
            Write-Log "Info: Geen actieve browser exclude-regels gevonden in de database. ExcludeList is leeggemaakt." -Level Debug
        }
    }
    catch {
        Write-Log "FOUT bij bijwerken van browser exclude-lijst voor taak $($TaskObject.Label) = $($_.Exception.Message)" -ForegroundColor Red
    }
}


# ==============================================================================
# 2. RECENT FILES EXPORT
# ==============================================================================

function Export-RecentFilesAndFolders2DB {
    param ($TaskObject)

    try {
        Write-Log "Export-RecentFilesAndFolders2DB gestart met Task = $($TaskObject.Label)" -Level Debug
        if ((Test-IsFalse $TaskObject.DetailedLog) -and (Test-IsFalse $TaskObject.MinimumLog)){ return }

        $CheckpointDate = $TaskObject.Checkpoint.NewestLogDatetime
        if ($(Test-HasNoContent $CheckpointDate)) { $CheckpointDate = (Get-Date).AddYears(-10) }

        $history = @(Get-RecentFilesAndFolders -fromDateTime $CheckpointDate)

        if ($(Test-HasRows $history)) {
            $Query2Execute = ""

            # --- Detailed Logging ---
            if ($TaskObject.DetailedLog) {
                $QueryParts = [System.Collections.Generic.List[string]]::new()
                $FilesOnly = $history | Where-Object { $_.attributes -notlike '*Directory*' -and -not [string]::IsNullOrWhiteSpace($_.fullname) }
                
                foreach ($row in $FilesOnly) {
                    $cleanPath = Format-SqlString -InputObject $row.fullname -MaxLength 2000
                    $cleanAttr = Format-SqlString -InputObject $row.attributes -MaxLength 255
                    
                    # Veilige Casts (voorkomen crashes bij rare data)
                    $SafeLastOpened = $row.LNK_LastOpened_Datetime -as [datetime]
                    $SafeLnkCreated = $row.Lnk_Created_DateTime -as [datetime]
                    $SafeFileCreated = $row.File_Created_DateTime -as [datetime]
                    $SafeFileModified = $row.File_Modified_DateTime -as [datetime]

                    if (-not $SafeLastOpened) { continue }

                    $Lnk_LastOpened_DateTime = Format-SqlString -InputObject $SafeLastOpened -Type DateTime2
                    $Lnk_Created_DateTime = Format-SqlString -InputObject $SafeLnkCreated -Type DateTime
                    $File_Created_DateTime = Format-SqlString -InputObject $SafeFileCreated -Type DateTime
                    $File_Modified_DateTime = Format-SqlString -InputObject $SafeFileModified -Type DateTime
                    
                    [void]$QueryParts.Add("SELECT '$env:computername', '$Global:useridentifier', '$env:userdomain', $Lnk_LastOpened_DateTime, $Lnk_Created_DateTime, $File_Created_DateTime, $File_Modified_DateTime, $cleanPath, $cleanAttr")
                }
                
                # CHUNKING (500 regels per keer tegen SQL crashes)
                if ($QueryParts.Count -gt 0) {
                    $BatchSize = 500
                    for ($i = 0; $i -lt $QueryParts.Count; $i += $BatchSize) {
                        $Count = if (($i + $BatchSize) -le $QueryParts.Count) { $BatchSize } else { $QueryParts.Count - $i }
                        $Batch = $QueryParts.GetRange($i, $Count)
                        $Query2Execute += "INSERT INTO [dbo].[DeviceRecentFileAndFolderLogging] ([computername],[username],[userdomain],[LnkLastOpenedDateTime],[LnkCreatedDateTime],[FileCreatedDateTime],[FileModifiedDateTime],[pathRecentfileandfolder],[attributes]) `n"
                        $Query2Execute += "  " + ($Batch -join " UNION ALL ") + ";`n"
                    }
                }
            }

            # --- Minimum Logging (Nieuwe Architectuur) ---
            if ($TaskObject.MinimumLog) {
                $TypeData = 'file'
                $GroupedFiles = $history | Where-Object { 
                    $_.attributes -notlike '*Directory*' -and -not [string]::IsNullOrWhiteSpace($_.fullname) -and $_.fullname -ne "Unknown"
                } | Group-Object -Property fullname

                foreach ($Group in $GroupedFiles) {
                    $PathName = $Group.Name
                    
                    # VEILIGE MIN-TIME BEREKENING!
                    $MinTimeValue = ($Group.Group | Measure-Object -Property LNK_LastOpened_Datetime -Minimum).Minimum
                    $MinDate = $MinTimeValue -as [datetime]
                    if (-not $MinDate) { $MinDate = (Get-Date) }
                    $vMinTimeSql = Format-SqlString -InputObject $MinDate.ToString("yyyy-MM-dd HH:mm:ss.fffffff")
                    
                    # VEILIGE DAG-EXTRACTIE!
                    $UniqueDaysInBatch = $Group.Group | Where-Object { $_.LNK_LastOpened_Datetime } | ForEach-Object { 
                        $dt = $_.LNK_LastOpened_Datetime -as [datetime]
                        if ($dt) { $dt.Date } 
                    } | Sort-Object | Select-Object -Unique

                    foreach ($Day in $UniqueDaysInBatch) {
                        if (-not $Day) { continue }

                        $CacheCollection = $Global:PreviouslyLoggedRows.Where({$_.data_collection_type -eq $TypeData -and $_.data -eq $PathName}, 'First')
                        $CacheMatch = if ($CacheCollection) { $CacheCollection[0] } else { $null }
                        
                        # VEILIGE CACHE CHECK!
                        $AlreadyLogged = $false
                        if ($CacheMatch -and $CacheMatch.LastUsedDate) {
                            $LastUsedDate = $CacheMatch.LastUsedDate -as [datetime]
                            if ($LastUsedDate -and $LastUsedDate.Date -ge $Day.Date) {
                                $AlreadyLogged = $true
                            }
                        }

                        if ($AlreadyLogged) { continue }

                        $DateStr = $Day.ToString('yyyy-MM-dd')
                        $Query2Execute += New-MinimalLoggingQueryBlock -Username $Global:useridentifier -UserDomain $env:userdomain -TypeData $TypeData -DataValue $PathName -DateString $DateStr -MinTimeSql $vMinTimeSql

                        # DE FIX: GOOI DE OUDE READ-ONLY ERUIT, ZET EEN VERSE ERIN
                        if ($CacheMatch) { 
                            [void]$Global:PreviouslyLoggedRows.Remove($CacheMatch) 
                        }
                        
                        [void]$Global:PreviouslyLoggedRows.Add([PSCustomObject]@{
                            data_collection_type = $TypeData
                            data = $PathName
                            LastUsedDate = $Day.Date
                        })
                    }
                }
            }

            # --- Checkpoint Verzetten ---
            $LatestItem = ($history | Sort-Object LNK_LastOpened_Datetime -Descending | Select-Object -First 1).LNK_LastOpened_Datetime
            if (Test-HasContent $LatestItem) {
                $SafeLatest = $LatestItem -as [datetime]
                if ($SafeLatest) {
                    $Query2Execute += "UPDATE [dbo].[DeviceLoggingUsers] SET [LastRecentFilesLogDateTime] = '$($SafeLatest.ToString('yyyy-MM-dd HH:mm:ss.fffffff'))' WHERE [username] = '$Global:useridentifier' AND [userdomain] = '$env:userdomain' AND [computername] = '$env:computername';"
                    if (-not [string]::IsNullOrWhiteSpace($Query2Execute)) { $null = Invoke-SqlQuery -Query $Query2Execute -Defer -OutputTo CSV }
                    $TaskObject.Checkpoint.NewestLogDatetime = $SafeLatest
                }
            }
        }
    } catch {
        # NIEUWE ERROR HANDLER!
        Write-DetailedError -ErrorObject $_ -ProcedureName "Export-RecentFilesAndFolders2DB"
        Throw $_
    }
}

function Get-RecentFilesAndFolders {
    param (
        [int]$minutes = 1440,
        [datetime]$fromDateTime
    )

    # Initialiseer de lijsten buiten de try om ze in de finally beschikbaar te hebben
    $retval = [System.Collections.Generic.List[psobject]]::new()
    $ErrorList = [System.Collections.Generic.List[string]]::new()
    $shell = $null

    try {
        $timeLimit = if ($(Test-HasContent $fromDateTime)) { $fromDateTime } else { (Get-Date).AddMinutes(-$minutes) }
        $recentPath = "$env:APPDATA\Microsoft\Windows\Recent"
        $shell = New-Object -ComObject WScript.Shell 
        
        $MAPS_NOT_LOGGED = $global:AppSettings.RECENTFILES_MAPS_EXCLUDED -split ';'
        $LnkFiles = Get-Childitem -Path $recentPath -Filter *.lnk | Where-Object { $_.LastWriteTime -gt $timeLimit }

        foreach ($lnk in $LnkFiles) {
            $targetPath = $null
            $item = $null
            try {
                $shortcut = $shell.CreateShortcut($lnk.FullName)
                $targetPath = $shortcut.TargetPath
                
                if ([string]::IsNullOrWhiteSpace($targetPath)) { 
                    Write-Log "Overgeslagen: Onleesbare protocol link $($lnk.Name)"
                    continue 
                }

                $LogItem = $true
                $currentAttributes = "Archive"

                # STAP 1: Toegangstest
                $CanAccess = $false
                try {
                    if (Test-Path -Path $targetPath -ErrorAction Stop) {
                        $CanAccess = $true
                    }
                } catch {
                    [void]$ErrorList.Add("$($lnk.Name) ($targetPath)")
                }

                # STAP 2: Details ophalen
                if ($CanAccess) {
                    try {
                        $item = Get-Item -LiteralPath $targetPath -ErrorAction Stop
                        if (Test-HasContent $item){
                            $currentAttributes = $item.Attributes
                            if ((Test-IsTrue $global:AppSettings.RECENTFILES_MAPS_NOT_LOGGED) -and ($currentAttributes -like '*Directory*')) {
                                $LogItem = $false
                            }
                        }
                    } catch {
                        [void]$ErrorList.Add("$($lnk.Name) ($targetPath) [Get-Item-Error]")
                        $currentAttributes = "Unreachable/NoAccess"
                    }
                } else {
                    $currentAttributes = "Unreachable/NoAccess"
                }

                # STAP 3: Filtering (Geoptimaliseerd met short-circuiting)
                if ($LogItem) {
                    $MAPS_NOT_LOGGED_FOUND = $MAPS_NOT_LOGGED.Where({ $targetPath -like $_ }, 'First')
                    if ($MAPS_NOT_LOGGED_FOUND) { $LogItem = $false }
                }

                # STAP 4: Resultaat toevoegen
                if ($LogItem) {
                    [void]$retval.Add([PSCustomObject]@{
                        Name                    = $lnk.BaseName
                        Fullname                = $targetPath
                        LNK_LastOpened_Datetime = $lnk.LastWriteTime
                        LNK_Created_Datetime    = $lnk.CreationTime
                        File_Modified_Datetime  = if($item){ $item.LastWriteTime } else { $null }
                        File_Created_Datetime   = if($item){ $item.CreationTime } else { $null }
                        Attributes              = $currentAttributes
                    })
                }
            } catch {
                [void]$ErrorList.Add("$($lnk.Name) (Fout: $($_.Exception.Message))")
                continue 
            }
        }
    } catch {
        # Log de fatale fout als die optreedt
        Write-Log "Fatale fout in Get-RecentFilesAndFolders = $($_.Exception.Message)" -ForegroundColor Red
        Throw $_
    } finally {
        # --- FINALLY: Altijd uitvoeren, ook bij errors ---
        
        # 1. Toon de onbereikbare items
        if (Test-HasRows $ErrorList) {
            $ErrorSummary = $ErrorList -join " ; "
            Write-Log "Onbereikbare recent items gevonden ($($ErrorList.Count)) = $ErrorSummary" -Level Warning
        }

        # 2. Ruim het COM object op
        if (Test-HasContent $shell) { 
            [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
            $shell = $null 
        }

        # 3. Forceer Garbage Collection voor de laptop performance
        #[System.GC]::Collect()
    }

    # Expliciet casten bij return conform afspraak
    return [array]$retval
}


# ==============================================================================
# 3. WINDOWS PROCESSES EXPORT
# ==============================================================================

function Export-WindowsProcesses2DB {
    param ($TaskObject)

    try {
        Write-Log "Export-WindowsProcesses2DB gestart met Task = $($TaskObject.Label)" -Level Debug
        if ((Test-IsFalse $TaskObject.DetailedLog) -and (Test-IsFalse $TaskObject.MinimumLog)) { return }

        $CheckpointDate = $TaskObject.Checkpoint.NewestLogDatetime
        if (Test-HasNoContent $CheckpointDate) { $CheckpointDate = Get-Date }

        $history = @(get-WindowsProcesses $CheckpointDate)
            
        if (Test-HasRows $history) {
            $LatestItem = ($history | Sort-Object starttime -Descending | Select-Object -First 1).starttime

            # --- Geavanceerde Exclusie ---
            if (Test-HasRows $Global:Tasks.WindowsProcesses.ExcludeList) {
                $history = $history.Where({
                    $Proc = $_
                    $ExcludeThis = [bool]$false
                    foreach ($Rule in $Global:Tasks.WindowsProcesses.ExcludeList) {
                        if ([string]::IsNullOrWhiteSpace($Rule.processnameExpression) -and [string]::IsNullOrWhiteSpace($Rule.FullpathExecutableExpression) -and [string]::IsNullOrWhiteSpace($Rule.productExpression) -and [string]::IsNullOrWhiteSpace($Rule.companyExpression)) { continue }
                        if ((-not [string]::IsNullOrWhiteSpace($Rule.processnameExpression)) -and ($Proc.ProcessName -notlike $Rule.processnameExpression)) { continue }
                        if (-not [string]::IsNullOrWhiteSpace($Rule.FullpathExecutableExpression)) {
                            if (($Proc.FullpathExecutable -match 'Unknown|Toegang geweigerd') -and ($Rule.FullpathExecutableExpression -like "*$($Proc.ProcessName)*")) { }
                            elseif ($Proc.FullpathExecutable -notlike $Rule.FullpathExecutableExpression) { continue }
                        }
                        if ((-not [string]::IsNullOrWhiteSpace($Rule.productExpression)) -and ($Proc.product -notlike $Rule.productExpression)) { continue }
                        if ((-not [string]::IsNullOrWhiteSpace($Rule.companyExpression)) -and ($Proc.company -notlike $Rule.companyExpression)) { continue }
                        $ExcludeThis = [bool]$true; break 
                    }
                    return (-not $ExcludeThis)
                })
            }
        }

        if (Test-HasRows $history) {
            $Query2Execute = ""

            # --- Detailed Logging ---
            if ($TaskObject.DetailedLog) {
                $QueryParts = [System.Collections.Generic.List[string]]::new()
                $DetailedHistory = $history | Group-Object -Property @{
                    Expression = { if ([string]::IsNullOrEmpty($_.FullpathExecutable)) { $_.ProcessName } else { $_.FullpathExecutable } }
                } | ForEach-Object { $_.Group | Sort-Object starttime -Descending | Select-Object -First 1 }

                foreach ($row in $DetailedHistory) {
                    if ([string]::IsNullOrWhiteSpace($row.FullpathExecutable) -or $row.FullpathExecutable -eq "Unknown") { continue }
                    $cleanProc = Format-SqlString -InputObject $row.ProcessName -MaxLength 500
                    $cleanPath = Format-SqlString -InputObject $row.FullpathExecutable -MaxLength 2000
                    $cleanProd = Format-SqlString -InputObject $row.Product -MaxLength 500
                    $cleanComp = Format-SqlString -InputObject $row.Company -MaxLength 200
                    
                    $SafeDate = $row.starttime -as [datetime]
                    if (-not $SafeDate) { continue }
                    
                    $startTime = Format-SqlString -InputObject $SafeDate -Type DateTime2
                    [void]$QueryParts.Add("SELECT '$env:computername', '$Global:useridentifier', '$env:userdomain', $startTime, $cleanProc, $cleanPath, $cleanProd, $cleanComp")
                }
                
                # CHUNKING
                if ($QueryParts.Count -gt 0) {
                    $BatchSize = 500
                    for ($i = 0; $i -lt $QueryParts.Count; $i += $BatchSize) {
                        $Count = if (($i + $BatchSize) -le $QueryParts.Count) { $BatchSize } else { $QueryParts.Count - $i }
                        $Batch = $QueryParts.GetRange($i, $Count)
                        $Query2Execute += "INSERT INTO [dbo].[DeviceProcessLogging] ([computername],[username],[userdomain],[starttime],[processname],[FullPathExecutable],[product],[company]) `n" 
                        $Query2Execute += "  " + ($Batch -join " UNION ALL ") + ";`n"
                    }
                }
            }

            # --- Minimum Logging (Nieuwe Architectuur) ---
            if ($TaskObject.MinimumLog) {
                $TypeData = 'process'
                $GroupedProcesses = $history | Group-Object -Property {
                    $val = $_.FullpathExecutable
                    if ($val -isnot [System.DBNull] -and -not [string]::IsNullOrWhiteSpace($val) -and [string]$val -ne 'unknown') { [string]$val } else { [string]$_.ProcessName }
                } | Where-Object { -not [string]::IsNullOrWhiteSpace($_.Name) -and $_.Name -ne "NULL" -and $_.Name -ne "unknown" }
                
                foreach ($Group in $GroupedProcesses) {
                    $ProcessPath = $Group.Name
                    
                    $MinTimeValue = ($Group.Group | Measure-Object -Property starttime -Minimum).Minimum
                    $MinDate = $MinTimeValue -as [datetime]
                    if (-not $MinDate) { $MinDate = (Get-Date) }
                    $vMinTimeSql = Format-SqlString -InputObject $MinDate.ToString("yyyy-MM-dd HH:mm:ss.fffffff")
                    
                    $UniqueDaysInBatch = $Group.Group | Where-Object { $_.starttime } | ForEach-Object { 
                        $dt = $_.starttime -as [datetime]
                        if ($dt) { $dt.Date } 
                    } | Sort-Object | Select-Object -Unique

                    foreach ($Day in $UniqueDaysInBatch) {
                        if (-not $Day) { continue } 
                        
                        $CacheCollection = $Global:PreviouslyLoggedRows.Where({$_.data_collection_type -eq $TypeData -and $_.data -eq $ProcessPath}, 'First')
                        $CacheMatch = if ($CacheCollection) { $CacheCollection[0] } else { $null }
                        
                        $AlreadyLogged = $false
                        if ($CacheMatch -and $CacheMatch.LastUsedDate) {
                            $LastUsedDate = $CacheMatch.LastUsedDate -as [datetime]
                            if ($LastUsedDate -and $LastUsedDate.Date -ge $Day.Date) {
                                $AlreadyLogged = $true
                            }
                        }

                        if ($AlreadyLogged) { continue }

                        $DateStr = $Day.ToString('yyyy-MM-dd')
                        $Query2Execute += New-MinimalLoggingQueryBlock -Username $Global:useridentifier -UserDomain $env:userdomain -TypeData $TypeData -DataValue $ProcessPath -DateString $DateStr -MinTimeSql $vMinTimeSql

                        # DE FIX: GOOI DE OUDE READ-ONLY ERUIT, ZET EEN VERSE ERIN
                        if ($CacheMatch) { 
                            [void]$Global:PreviouslyLoggedRows.Remove($CacheMatch) 
                        }
                        
                        [void]$Global:PreviouslyLoggedRows.Add([PSCustomObject]@{
                            data_collection_type = $TypeData
                            data = $ProcessPath
                            LastUsedDate = $Day.Date
                        })
                    }
                }
            }
            
            # --- Checkpoint Verzetten ---
            if (Test-HasContent $LatestItem) {
                $SafeLatest = $LatestItem -as [datetime]
                if ($SafeLatest) {
                    $Query2Execute += "UPDATE [dbo].[DeviceLoggingUsers] SET [LastWindowsProcessesLogDateTime] = '$($SafeLatest.ToString('yyyy-MM-dd HH:mm:ss.fffffff'))' WHERE [username] = '$Global:useridentifier' AND [userdomain] = '$env:userdomain' AND [computername] = '$env:computername';"
                    if (-not [string]::IsNullOrWhiteSpace($Query2Execute)) { $null = Invoke-SqlQuery -Query $Query2Execute -Defer -OutputTo CSV }
                    $TaskObject.Checkpoint.NewestLogDatetime = $SafeLatest
                }
            }
        }
    } catch {
        Write-DetailedError -ErrorObject $_ -ProcedureName "Export-WindowsProcesses2DB"
        Throw $_ 
    }
}


#############################################################################################################################################
function Get-WindowsProcesses {
#############################################################################################################################################
    
param ([datetime]$FromDateTime )

    Write-Verbose "Begin Get-WindowsProcesses"  

    try {

        if (Test-HasNoContent $FromDateTime){
            Write-Verbose "Variable fromDateTime was empty. Setting to current time." 
            $FromDateTime = [datetime](Get-Date)
        }

        Write-Verbose "Checking processes on $(Get-Date) from datetime: $($FromDateTime.ToString("yyyyMMddHHmmss.fffffff"))" 

        # We gebruiken direct het [datetime] object. De string-conversie stap is verwijderd 
        # voor maximale CPU-winst tijdens het vergelijken.

        # High-performance lijst voor de resultaten
        $NewProcesses = [System.Collections.Generic.List[psobject]]::new()

        # --- NIEUW: Bepaal het Sessie ID van de huidige UAM gebruiker ---
        $MySessionId = [int](Get-Process -Id $PID).SessionId

        Write-Verbose "Ophalen processen via .NET [System.Diagnostics.Process]..."
        $AlleProcessen = [System.Diagnostics.Process]::GetProcesses()

        foreach ($Proc in $AlleProcessen) {
            try {
                # --- NIEUW: Negeer processen van andere RDS/Citrix gebruikers en SYSTEM ---
                if ($Proc.SessionId -ne $MySessionId) { continue }

                # Starttijd opvragen. Dit faalt bij beveiligde OS-processen (Access Denied).
                $StartTime = [datetime]$Proc.StartTime
                
                if ($StartTime -gt $FromDateTime) {
                    
                    # Default waarden initialiseren om NULL in SQL te voorkomen
                    $ProcPath = "Unknown"
                    $ProcProduct = "Unknown"
                    $ProcCompany = "Unknown"
                    $ProcDesc = "Unknown"

                    try {
                        $MainMod = $Proc.MainModule
                        if ($null -ne $MainMod) {
                            if (-not [string]::IsNullOrWhiteSpace($MainMod.FileName)) { $ProcPath = [string]$MainMod.FileName }
                            
                            $FVI = $MainMod.FileVersionInfo
                            if ($null -ne $FVI) {
                                if (-not [string]::IsNullOrWhiteSpace($FVI.ProductName)) { $ProcProduct = [string]$FVI.ProductName }
                                if (-not [string]::IsNullOrWhiteSpace($FVI.CompanyName)) { $ProcCompany = [string]$FVI.CompanyName }
                                if (-not [string]::IsNullOrWhiteSpace($FVI.FileDescription)) { $ProcDesc = [string]$FVI.FileDescription }
                            }
                        }
                    } catch {
                        # Als het ophalen van de MainModule faalt (bijv. race condition of access denied)
                        $ProcPath = "Toegang geweigerd of beëindigd"
                    }

                    [void]$NewProcesses.Add([PSCustomObject]@{
                        ProcessName        = [string]($Proc.ProcessName + ".exe")
                        FullpathExecutable = [string]$ProcPath
                        starttime          = [datetime]$StartTime
                        product            = [string]$ProcProduct
                        company            = [string]$ProcCompany
                        description        = [string]$ProcDesc
                    })
                }
            } catch {
                # Lokale catch: Toegang geweigerd tot systeemprocessen negeren we geruisloos.
                # Hierdoor crasht de functie niet en wordt jouw 'Throw' niet onterecht getriggerd.
            } finally {
                # Voorkomt geheugenlekken door het proces netjes af te sluiten
                $Proc.Dispose()
            }
        }
                        
    } catch {

        Write-Verbose "Begin catch Get-WindowsProcesses"        
        Write-Verbose "End catch Get-WindowsProcesses before Throw..."        

        # Alleen Throwen zodat de foutmelding in de hoofdLus gelogd wordt met ErrorHandler
        Throw $_   

    }

    # Teruggeven als een standaard array, expliciet gecast
    return [array]$NewProcesses

}

#############################################################################################################################################
Function Update-DeviceProcessExcludeList {
#############################################################################################################################################
    param ($TaskObject)

    try {
        Write-Log "Ophalen van de uit te sluiten Windows processen vanuit de database tabel DeviceProcess2Exclude" -ForegroundColor Gray
        
        # We halen nu alle relevante velden op voor geavanceerd filteren
        $Query = [string]"SELECT * FROM [DeviceProcess2Exclude] WHERE enabled=1" # processname, FullpathExecutable, product, company
        $ExcludeData = Invoke-SqlQuery -Query $Query
        
        if (Test-HasRows $ExcludeData) {
            
            # We slaan het hele object op in de correcte, originele eigenschap ExcludeList
            $Global:Tasks.WindowsProcesses.ExcludeList = [array]$ExcludeData
            Write-Log "Succes: ExcludeList voor WindowsProcesses bijgewerkt. Aantal regels = $($Global:Tasks.WindowsProcesses.ExcludeList.Count)" -Level Debug
        }
        else {
            # Expliciet leegmaken als de database query geen resultaten oplevert
            $Global:Tasks.WindowsProcesses.ExcludeList = @()
            Write-Log "Info: Geen actieve exclude-regels gevonden in de database. ExcludeList is leeggemaakt." -Level Debug
        }
    }
    catch {
        Write-Log "FOUT bij bijwerken van exclude-lijst voor taak $($TaskObject.Label) = $($_.Exception.Message)" -ForegroundColor Red
    }
}


#############################################################################################################################################
## EINDE FUNCTIES TBV TASKS
#############################################################################################################################################

Function Invoke-PreStart{

try {
    
    Write-Log "######################################################################################################## "  -ForegroundColor Gray
    Write-Log "Starting Script... (pid=$($PID))" -ForegroundColor Cyan
    Write-Log "######################################################################################################## "  -ForegroundColor Gray


    ## Om te voorkomen dat het RAM geheugen steeds verder af nam en er uiteindelijk een crash kwam, heb ik besloten om aan het begin van dit script de geheugenbescherming in te stellen op een vaste waarde.
    Set-ProcesGeheugenBescherming

    #############################################################################################################################################
    ## DECLARE VARIABLES
    #############################################################################################################################################

    #  Voorkom CMD UNC-pad waarschuwingen bij externe commando's ---
    Set-Location -Path $env:TEMP -ErrorAction SilentlyContinue

    [System.Environment]::CurrentDirectory = $env:TEMP

    # Variabele that counts errors, so we can stop this whole program/script when too many errors occur
    $Global:ErrorCount = 0

    # (Windows) PID van dit UAM proces
    $Global:CurrentProcessID = [system.diagnostics.Process]::GetCurrentProcess().id

    # (Windows) naam van dit UAM proces 
    $Global:CurrentProcessName = Get-CurrentExecutableName

    # User identifier (username). To use a extra variable instead of only $env:username, we can change this in the future to a more unique identifier if needed
    $Global:useridentifier = $env:username

    # This variable keeps track of the maximum memory used by this UAM process. So when more memory is used, this info is written to the database and this variable is updated
    $Global:MaxMemoryUseMB = 0

    # Variable to keep track of actions that should be skipped during logging with uam that has no console/output
    $Global:QuietMode = $true

    # Variable to indicate if logging should start (or not if a error occurs during startup)
    $global:startLogging = $true

    $SysInfo = New-Object -ComObject "ADSystemInfo"
    [string]$Global:ComputerDN = $SysInfo.GetType().InvokeMember("ComputerName", "GetProperty", $null, $SysInfo, $null)
    Remove-Variable -Name SysInfo -ErrorAction SilentlyContinue

    $Global:UAMStartedElevated = [bool](Test-IsElevated)

    ###############################################################
    # APP STORAGE PATH (Gebruikt voor CSV file en misschien voor meer zoals de Transcript file en andere output files, maar dat moet nog nagekeken worden..)
    ###############################################################

    $Global:AppStoragePath = Get-SafeStoragePath -ProjectName $Global:ProjectName

    ## Bepaal hier de plek waar de de CSV weggeschreven kan worden (en zal worden indien gekozen is voor defer mbv CSV). 
    ## In de variabel $Global:AppSettings.usr_csv_path zou ook nog een ander path (en csv file) kunnen voorkozen van een vorige UAM sessie (die niet helemaal goed afgesloten is geweest), 
    ## en als daar nog een csv bestand staat, dan zal die alsnog ingelezen worden in de database voordat het echte loggen gaan beginnen. In $Global:CsvPath zou een ander path gekozen 
    ## kunnen zijn, en in dat path zal dan ook de nieuwe csv bestand gezet worden.
    $Global:CsvPath = Join-Path -Path $Global:AppStoragePath -ChildPath "UAM_OUTPUT4DB_$($env:COMPUTERNAME)_$($Global:useridentifier).csv"

    ###############################################################
    # DECLARE Var $Global:RootPath 
    ###############################################################
    $Global:RootPath = ""

    # 1. Bepaal het pad naar de EXE of het Script
    $CurrentPath = ""
    try {
        # Haal het volledige pad op (EXE of script)
        $CurrentPath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        
        if ($CurrentPath -match "powershell\.exe|pwsh\.exe") {
            $CurrentPath = $PSCommandPath
            $Global:QuietMode = $false
        }
    } catch {
        $CurrentPath = $PSCommandPath
    }

    # Gebruik jouw .NET methode om de map te isoleren
    $RootPath = [System.IO.Path]::GetDirectoryName($CurrentPath)

    # Ultieme fallback voor het geval alles faalt (bijv. bij interactief gebruik)
    if (Test-HasNoContent $RootPath) {
        $RootPath = $PSScriptRoot
    }

    $global:RootPath = Join-Path $RootPath '\'

    Write-Log "RootPath = $Global:RootPath" -ForegroundColor Cyan

    ###############################################################
    ## END DECLARING RootPath 
    ###############################################################

    ###############################################################
    # We zetten hierbij de logging even aan, ook al wordt deze later uitgezet vanwege de settings. Hiermee zie we hoe UAM.exe gestart is en kunnen we eventuele fouten in dit beginproces ook loggen.
    # Eerder aanroepen kon niet omdat de RootPath nog niet bekend was, en die is nodig voor het loggen. We kunnen nu ook al zien of er een console is of niet, en dat loggen we ook meteen.
    ###############################################################

    Manage-LogRotation -LogFolder "$Global:RootPath\Logs" -MaxDays ([int]$global:AppSettings.TRANSSCRIPT_MAXDAYS) -ForceEnable

    ###############################################################
    # Global:This_UAM_Process Variabelen
    ###############################################################

# Stap 1: Bepaal het pad met meerdere fallbacks
$UAM_Path = ""
if ($MyInvocation.MyCommand.Path) { 
    $UAM_Path = $MyInvocation.MyCommand.Path 
} elseif ($PSCommandPath) { 
    $UAM_Path = $PSCommandPath 
} else {
    # Laatste strohalm: kijk welk bestand er nu geladen is via de callstack of process
    $UAM_Path = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
}

# Stap 2: Alleen Get-Item uitvoeren als we een pad hebben
$UAM_File = $null
if (Test-HasContent $UAM_Path) {
    $UAM_File = Get-Item -Path $UAM_Path -ErrorAction SilentlyContinue
}

# Stap 3: Versie-extractie (Regex op pad OF FileVersion)
$UAM_Version_String = "0.0"
if (Test-HasContent $UAM_Path) {
    $UAM_Version_String = [regex]::Match($UAM_Path, '(?<=V)[\d\.]+').Value
}

if ((Test-HasNoContent $UAM_Version_String) -and $UAM_File.VersionInfo.FileVersion) {
    $UAM_Version_String = $UAM_File.VersionInfo.FileVersion
}

# Stap 4: Bouw het object (met extra beveiliging voor lege waarden)
$Global:This_UAM_Process = [PSCustomObject]@{
    ProcessName        = if($MyProcess){ $MyProcess.Name } else { "uam.exe" }
    FullpathExecutable = $UAM_Path
    StartTime          = if($MyProcess){ $MyProcess.CreationDate } else { (Get-Date) }
    Handle             = $PID
    CommandLine        = if($MyProcess){ $MyProcess.CommandLine } else { "" }
    WindowsVersion     = [Environment]::OSVersion.VersionString
    # FIX: We gebruiken LastWriteTime voor de 'UAMCreated' logica omdat dit de build-datum is
    # CreationTime is enkel wanneer het bestand naar de huidige folder is gekopieerd
    ExeCreationDate    = if($UAM_File){ [datetime]$UAM_File.LastWriteTime } else { [datetime](Get-Date) }
    ExeInstallDate     = if($UAM_File){ [datetime]$UAM_File.CreationTime } else { [datetime](Get-Date) }
    ProductVersionRaw  = $UAM_Version_String
    Company            = if($UAM_File -and $UAM_File.VersionInfo){ $UAM_File.VersionInfo.CompanyName } else { "Eigen Beheer" }
    Product            = if($UAM_File -and $UAM_File.VersionInfo){ $UAM_File.VersionInfo.ProductName } else { "UAM" }
}

    Write-Log "== INFO ABOUT THIS UAM PROCESS ======================================= " -ForegroundColor Green
    Write-Log $($Global:This_UAM_Process  | out-string)  -ForegroundColor Green

    if (Test-HasContent $Global:This_UAM_Process.ProductVersionRaw) {
        Write-Log "UAM Process Version Info: ProductVersion = $($Global:This_UAM_Process.ProductVersionRaw), CompanyName = $($Global:This_UAM_Process.Company), ProductName = $($Global:This_UAM_Process.Product)" -ForegroundColor Cyan
    } else {
        Write-Log "UAM Process Version Info could not be retrieved." -ForegroundColor Yellow
    }
    #Write-Log "====================================================================== "  -ForegroundColor Green

    if ($Global:This_UAM_Process.FullpathExecutable -like '*uam_console*'){
        $Global:QuietMode = $false
    }

    #--------------------------------------------------------------------------------------------------------------------#
    # READING AND CHECKING DBSETTINGS FILE (DBSETTINGS ZIJN NODIG VOOR DE DATABASE CONNECTIE)
    #--------------------------------------------------------------------------------------------------------------------#

    $CreateSecureConnectionStringFile = $false
    $DbSettingsFile = $Global:RootPath + "DbSettings.txt"
    Write-Log "Checking dbsettings file: $($DbSettingsFile)" -ForegroundColor Cyan
    $DbsettingsFileExists = test-path -literalpath $DbSettingsFile

    if ((Test-IsFalse $DbsettingsFileExists) -and -not $PSBoundParameters.Containskey('SecureConnectionString')){
        Write-Log "DbSettingsFile file ontbreekt. Aanmaken kan door deze exe aan te roepen met een juiste en complete MSSQL connectie string mee te geven zoals bijvoorbeeld: UAM.exe 'Server=SQL01 ;Database=db1 ;Uid=uam_user;Pwd=Qq323||32REtEed%%FDS!'"	
        $global:startLogging=$false
        wait-event -Timeout 15
    }
    if ($global:startLogging){
        if ($DbsettingsFileExists){
            $Global:SecureConnectionString = Decrypt-String -EncryptedString $(get-content $DbSettingsFile) -Key "Daar komt de @@p uit de sleeve!#"
            $TestConnectionString=$Global:SecureConnectionString
        }else{
            if ($PSBoundParameters.Containskey('SecureConnectionString')){
                $TestConnectionString = $SecureConnectionString
                $CreateSecureConnectionStringFile = $true
            }
        }

        $QueryResult = @(Invoke-SqlQuery -connectionstring $TestConnectionString -Query "select test=1")
        # Dit moet mooier kunnen en kan nog onderzocht worden....
        if ((Test-HasNoRows $QueryResult) -or ($QueryResult.test -ne 1)){
            $global:startLogging=$false
            Write-Log "ConnectieString is onjuist!"
            wait-event -Timeout 10
        }else{
            if ($CreateSecureConnectionStringFile){
                $test = Encrypt-String -String $SecureConnectionString -Key "Daar komt de @@p uit de sleeve!#"
                $test | Out-File $DbSettingsFile -force
                Write-Log "$DbSettingsFile file aangemaakt. Start de exe opnieuw op."
            }
        }
    }

    Get-AppSetting -ForceRefresh -Scope All

#   if (Test-IsTrue $global:startLogging) {

        #--------------------------------------------------------------------------------------------------------------------#
        # UAM logt data per user/computer en voor elke user/computer wordt er een record aangemaakt in [DeviceLoggingUsers]. 
        # Slechts 1 record wordt aangemaakt per user/computer. Het kan wel voorkomen dat een user meerdere records heeft als die op meerdere
        # computers werkt. Dit zal je zien met Flex VDI en Laptop bijvoorbeeld. Een Non-Persistent VDI zal steeds hetzelfde record updaten ook al heeft die steeds een nieuwe computername.
        # Als er voor een user/computer al eens gelogd is geweest, dan zal er al een record bestaan in [DeviceLoggingUsers] en zal het record geupdate worden.
        # De belangrijkste velden voor [DeviceLoggingUsers] zijn de datum/tijd (t/m) dat log opgehaald voor is van de Browser History, Windows Processen, Recent Files.
        # Dit is nodig om te weten vanaf welke datum/tijd de logging de volgende keer opgehaald mag worden.
        #--------------------------------------------------------------------------------------------------------------------#

        $Global:user_uam_adgroupmember = Test-GroupMembership -UserName $Global:useridentifier -GroupPatterns $global:AppSettings.GENERAL_ENABLE_LOGGING_FOR_ADGROUP    

        $Query2Execute = ""

        if ($Global:ComputerDN -like "*$($global:AppSettings.GENERAL_NONPERSISTENT_VDI_OU)*") {
            Write-Log "Computer is in de OU $($global:AppSettings.GENERAL_NONPERSISTENT_VDI_OU), dus we gaan ervan uit dat dit een non-persistent VDI is. Logging zal plaatsvinden op basis van computernaam en niet op basis van user/computer combinatie." -ForegroundColor Yellow
            $Query2Execute = @"
            IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[DeviceLoggingUsers] WHERE [username] = '$Global:useridentifier' AND [userdomain] = '$env:userdomain' AND [NonPersistentComputer] = 1 ) 
            BEGIN
                INSERT INTO [dbo].[DeviceLoggingUsers] ([username],[userdomain],[computername],[NonPersistentComputer],[startlogging]) SELECT '$Global:useridentifier','$env:userdomain', '$env:computername', 1, '$(if($Global:user_uam_adgroupmember){1}else{0})'
            END
            ELSE 
            BEGIN
                UPDATE [dbo].[DeviceLoggingUsers]
                    SET [computername] = '$env:computername'
                    WHERE    [username]     = '$Global:useridentifier' 
                        AND  [userdomain]   = '$env:userdomain' 
                        AND  [NonPersistentComputer] = 1
            END
"@ 
        }else {
            $Query2Execute = @"
            IF NOT EXISTS (SELECT TOP 1 1 FROM [dbo].[DeviceLoggingUsers] WHERE [username] = '$Global:useridentifier' AND [userdomain] = '$env:userdomain' AND [computername] = '$env:computername' )  
            BEGIN
                INSERT INTO [dbo].[DeviceLoggingUsers] ([username],[userdomain],[computername],[startlogging]) SELECT '$Global:useridentifier','$env:userdomain', '$env:computername', '$(if($Global:user_uam_adgroupmember){1}else{0})'
            END 
"@
        }

        $Query2Execute += @"
        UPDATE [dbo].[DeviceLoggingUsers]
            SET [lastlogon]                     = '$((get-date).tostring("yyyyMMdd HH:mm:ss"))'
                ,[UAMProcessName]               = '$($Global:This_UAM_Process.FullpathExecutable)'
                ,[UAMVersion]                   = '$($Global:This_UAM_Process.ProductVersionRaw)'
                ,[UAMCreated]                   = '$(($Global:This_UAM_Process.ExeCreationDate).tostring("yyyyMMdd HH:mm:ss"))'
                ,[UAMInstallDate]               = '$(($Global:This_UAM_Process.ExeInstallDate).tostring("yyyyMMdd HH:mm:ss"))'
                ,[UAMStartedElevated]           = '$(if($Global:UAMStartedElevated){1}else{0})'
                ,[UAMStartupDateTime]           = GETDATE()
                ,[UAMShutdownDateTime]          = NULL
                ,[LoggingStartedUAMprocessPID]  = '$($PID)'
                ,[UAMprocessMaxMemoryMB]        = 0
        WHERE    [username]     = '$($Global:useridentifier)' 
            AND  [userdomain]   = '$env:userdomain' 
            AND  [computername] = '$env:computername'
"@
        # Moet direct weggeschreven worden en niet via CSV!!! Dus geen -defer parameter gebruiken.
        $null = Invoke-SqlQuery -query $Query2Execute
 #   }

    ## Read AppSettings from database to Global:AppSettings (hashtable). Alleen de User/Computer scope wordt nu opgeshaald nu we weten welke user/computer het nu betreft en ook in de database staat (dmv vorige inser/update statements voor de user/computer)
    Get-AppSetting -ForceRefresh

    $global:startLogging = $Global:AppSettings.USR_startlogging

    if (Test-IsTrue $global:startLogging) {

        #--------------------------------------------------------------------------------------------------------------------#
        # CHECK AND UPDATE CSVPATH (en csv files)
        #
        # 1. Indien er nog een csv file aanwezig is van een vorige UAM sessie (die niet goed afgesloten is geweest) en die nog verwerkt moet worden, 
        #    dan zal deze eerst verwerkt worden voordat we verder gaan. Dit voorkomt dat er data verloren gaat van een vorige sessie.
        #
        # 2. Indien de Global:CsVPath (die in het geheugen staat) niet gelijk is aan de Global:AppSettings.USR_CsVPath (die in de database staat), 
        #    dan zal de database geupdate worden met de waarde van Global:CsVPath. Dit zorgt ervoor dat als er een verschil is tussen wat er in het geheugen staat en wat er in de database staat, 
        #    dat dit gecorrigeerd wordt. 
        #
        # !! $Global:CsVPath is leidend voor het pad waar de csv file weggeschreven moet worden en opgehaald wordt. De database waarde is voor inzicht bij beheer en voor als UAM nogmaals opgestart en gekeken kan worden of er nog een csv file verwerkt moet worden van een vorige sessie. 
        #    Maar het is niet de bedoeling dat de database waarde leidend is voor het pad waar de csv file weggeschreven moet worden, want dat kan namelijk verouderd zijn of van een vorige sessie zijn die niet goed afgesloten is geweest.
        #--------------------------------------------------------------------------------------------------------------------#

        Write-Log "### Checken van de CsVPath variabelen..."

        if (Test-HasContent $Global:AppSettings.USR_csvPath) {
            Write-Log "Controleren op bestaande (defer sql) CSV bestanden van eerdere UAM instanties die nog verwerkt moeten worden..." 

            [bool]$csvPath4Now = try { Test-Path -LiteralPath $Global:AppSettings.USR_csvPath -ErrorAction Stop } catch { $false }

            if (Test-IsTrue $csvPath4Now) {
                Write-Log "--> Bestand: Global:AppSettings.USR_CsVPath = $($Global:AppSettings.USR_csvPath) bestaat en zal eerst verwerkt worden (aka verwerkt/weggeschreven worden in de database)." -ForegroundColor Green

                Invoke-DeferredQueryProcessing -DefferedMethod $Global:AppSettings.GENERAL_WRITE2DB_METHOD -CsvPath $($Global:AppSettings.USR_csvPath) 

                # We halen nu nogmaals de usr settings op omdat daar ook de datums van laatste scan opgehaald worden, en het kan zijn dat Invoke-DeferredQueryProcessing (hierboven) deze waardes nog aangepast heeft, want anders gaan we de data dubbel ophalen
                Get-AppSetting  -ForceRefresh -Scope User  
            }
        }

        if ($Global:csvPath -ne $Global:AppSettings.USR_csvPath ) {
            Write-Log "--> Global:csvPath is ongelijk aan Global:AppSettings.USR_csvPath, dus we gaan $Global:csvPath updaten in de database tabel [DeviceLoggingUsers]." -ForegroundColor Yellow

            $Query2Execute = [string]@"
            UPDATE [dbo].[DeviceLoggingUsers]
                SET [csvPath]       = '$($Global:csvPath)'
            WHERE    [username]     = '$($Global:useridentifier)' 
                AND  [userdomain]   = '$env:userdomain' 
                AND  [computername] = '$env:computername'
"@
            # Moet direct weggeschreven worden en niet via CSV!!! Dus geen -defer parameter gebruiken.
            $null = Invoke-SqlQuery -query $Query2Execute
            Write-Log "--> database tabel [DeviceLoggingUsers] is bijgewerkt." -ForegroundColor Yellow
        }

        #--------------------------------------------------------------------------------------------------------------------#
        # APPLICATION LOGGING
        #
        # Start Transcript logging if enabled in AppSettings (en vandaar dat dit hier van aangezet kan worden nadat de Get-AppSetting aangeroepen wordt)
        # Manage-Transcript -Enable $($Global:AppSettings.TRANSSCRIPT_ENABLE) -LogFolder $global:RootPath -MaxDays $($Global:AppSettings.TRANSSCRIPT_MAXDAYS)
        #--------------------------------------------------------------------------------------------------------------------#

# 1. Start de log rotatie (dit vult $Global:LogPath met het volledige pad)
        Manage-LogRotation -LogFolder "$Global:RootPath\Logs" -MaxDays ([int]$global:AppSettings.TRANSSCRIPT_MAXDAYS)

        # We zetten de succes-vlag standaard op false. 
        # Hij wordt pas op het allerlaatst op true gezet.
        $Global:ScriptFinishedGracefully = $false

        # 2. De "Trap" - Dit vangt alle onvoorziene fouten op in dit scriptblok
        trap {
            $ErrorMessage = "UNEXPECTED TERMINATING ERROR = $($_.Exception.Message)"
            if ($_) { $ErrorMessage += " | ScriptStackTrace = $($_.ScriptStackTrace)" }
            Write-Log -Message $ErrorMessage -Level Error
            continue 
        }

        # 3. Registreer afsluit-event voor fatale systeemfouten
        $ExitingEventParams = @{
            SourceIdentifier = "PowerShell.Exiting"
            Action = {
                # Controleer of het script GEEN natuurlijke dood stierf, en er een fout was.
                if (-not $Global:ScriptFinishedGracefully -and $global:error[0]) {
                    $LastErr = $global:error[0]
                    # Gebruik rechtstreeks Out-File omdat de sessie stopt
                    "[$((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))] [FATAL] Script onverwacht gecrasht! Fout = $($LastErr.Exception.Message)" | 
                        Out-File -FilePath $Global:LogPath -Append -Encoding UTF8
                }
            }
        }
        Register-EngineEvent @ExitingEventParams | Out-Null

        # Moet de check op elevated rechten uitgevoerd worden bij het starten van dit UAM proces? Dit is optioneel en aan te zetten in de AppSettings
        if (Test-IsTrue $global:startLogging) {

            if (    ($Global:This_UAM_Process.FullpathExecutable -like '*uam_console.*' -and (Test-IsTrue $global:AppSettings.START_UAM_CONSOLE_ELEVATED_CHECK)) -or  
                    ($Global:This_UAM_Process.FullpathExecutable -like '*uam.*' -and (Test-IsTrue $global:AppSettings.START_UAM_ELEVATED_CHECK))
            ) {

                if ($Global:UAMStartedElevated) {
                    Write-Host "Process is succesvol gestart MET Administrator rechten (Elevated)." -ForegroundColor Green
                } else {
                    Write-Host "Process draait in normale gebruikersmodus (Niet Elevated). Dit proces MOET elevated gestart worden. Verdere executie stopt hier." -ForegroundColor DarkYellow 
                    Wait-Event -Timeout 10
                    $global:startLogging = $false
                    return -1
                }
            }
        }

        #--------------------------------------------------------------------------------------------------------------------#
        # CHECK IF SQLITE3 EXE EXISTS ON THE PATH DEFINED IN APPSETTINGS
        #--------------------------------------------------------------------------------------------------------------------#
        $SqliteCMD = Join-Path -path $Global:RootPath -ChildPath $Global:AppSettings.WEBBROWSER_SQLITE3_EXE
        if (-not (Test-Path $SqliteCMD)) {$ErrorText = "SQLite EXE not found in path: $SqliteCMD" ; Write-Log "$ErrorText."} 

        #--------------------------------------------------------------------------------------------------------------------#
        # Show AppSettings
        #--------------------------------------------------------------------------------------------------------------------#

        # 1. Bepaal de lengte van de langste Key voor de uitlijning
        $maxKeyLength = ($Global:AppSettings.Keys | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum

        # 2. Bouw de gesorteerde en uitgelijnde string
        $Settings = ($Global:AppSettings.GetEnumerator() | Sort-Object Name | ForEach-Object { 
            # PadRight zorgt dat elke Key evenveel ruimte inneemt, gevolgd door de waarde
            "$($_.Key.PadRight($maxKeyLength)) = $($_.Value)" 
        }) -join "`n"

        # Toon het resultaat (mooi onder elkaar in je Transcript)
        Write-Log "--- AppSettings ---`n$Settings" -ForegroundColor Cyan
    }
    # Hier bepalen welke sqlite3 client gebruikt gaat worden voor het uitlezen van browser historie. Dit kan nu want de AppSettings zijn nu geladen.
    #    $Global:WEBBROWSER_SQLITE3_CLIENT_CHOOSEN = 'EXE'

    #############################################################################################################################################
    ## CHECK IF ANOTHER UAM.EXE PROCESS IS ALREADY RUNNING (and the older one should be stopped, but has to stop itself, so we wait here)
    #############################################################################################################################################

    if (Test-IsTrue $global:startLogging) {
        $WaitLoop = 0
        $MaxWaitLoop = 10
        $WaitInLoopSeconds = 6 # Iets korter wachten is vaak fijner

        # Eerste check
        $StatusOtherProcesses = Test-OtherProcessRunning -ProcessName 'uam.exe' -Productname 'User Activity Monitor'
        Write-Log "Status OtherProcesses: $StatusOtherProcesses"

        # CRITIEK: Als er een NIEUWER proces is, moeten WIJ direct stoppen.
        if ($StatusOtherProcesses -eq 'NewerProcessesFound') {
            Write-Log "Deze sessie wordt afgesloten omdat er een nieuwere UAM sessie actief is." -Level Warning
            $global:startLogging = $false
        }

        # Als er OUDERE processen zijn, geef ze even de tijd om netjes te sluiten
        while ($global:startLogging -and $StatusOtherProcesses -eq 'OlderProcessesFound' -and $WaitLoop -lt $MaxWaitLoop) {
            $WaitLoop++
            Write-Log "Wacht ($WaitInLoopSeconds sec) op zelf-afsluiten oudere UAM.exe... (Poging $WaitLoop/$MaxWaitLoop)" -ForegroundColor Gray
            Start-Sleep -Seconds $WaitInLoopSeconds
            
            $StatusOtherProcesses = Test-OtherProcessRunning -ProcessName 'uam.exe' -Productname 'User Activity Monitor'
        }

        # FORCEER KILL: Als er na het wachten nog steeds oudere processen zijn, grijpen we in.
        if ($global:startLogging -and $StatusOtherProcesses -eq 'OlderProcessesFound') {
            Write-Log "Oudere sessies zijn niet vrijwillig gestopt. Forceer afsluiten..." -ForegroundColor Cyan
            
            # BELANGRIJK: Geef hier ALTIJD de namen mee, anders filtert de functie niet goed!
            $null = Test-OtherProcessRunning -ProcessName 'uam.exe' -Productname 'User Activity Monitor' -KillProcesses -KillCondition OlderProcessesFound
            
            # Laatste check of het gelukt is
            $StatusOtherProcesses = Test-OtherProcessRunning -ProcessName 'uam.exe' -Productname 'User Activity Monitor'
        }
    }

    } catch {

        ErrorHandler -ErrorRecord $_
        $global:startLogging = $false
        Wait-Event -Timeout 20


    } finally {

    }

    return $global:startLogging

}

#############################################################################################################################################
Function Start-Logging {
#############################################################################################################################################
[CmdletBinding()]
param ()

    try {

        # Geheugen even opruimen
#        [System.GC]::Collect()
#        [System.GC]::WaitForPendingFinalizers()

        # Ophalen van performance info (zoals max geheugen) van dit UAM proces. Dit is alleen informatief en wordt weggeschreven naar de database.
        Write-Log "Ophalen van performance info" 
        $PerformanceInfo = Get-ProcessPerformance
        # Omdat UAM gestart kan worden vanaf Visual Code en vanaf uam.exe en vanaf uam_console.exe moet de max use memory wel zuiver blijven (en dat is vooral een issue bij development, en niet normale users want die gebruiken altijd uam.exe)
        if ($Global:This_UAM_Process.ProcessName -ne $Global:AppSettings.usr_UAMProcessName){
            $global:MaxMemoryUseMB = 0
        } else {
            $global:MaxMemoryUseMB = $global:AppSettings.usr_UAMprocessMaxMemoryMB
        }
        if ($global:MaxMemoryUseMB -lt $PerformanceInfo.Memory_MB){
            Write-Log "New MAX Memory: $($PerformanceInfo.Memory_MB)MB was $($global:MaxMemoryUseMB)MB." 
            $global:MaxMemoryUseMB = $PerformanceInfo.Memory_MB
        }

        Write-Log "Fetch previously logged records [uam_log_minimal] for current user..."

        # VDI-Proof: Haal de laatste gebruiksdatum op per applicatie/domein voor deze specifieke user
        $CacheQuery = @"
        SELECT m.[data_collection_type], m.[data], MAX(d.[UsedOnDate]) AS [LastUsedDate]
        FROM [dbo].[uam_log_minimal] m
        INNER JOIN [dbo].[uam_log_minimal_dates] d ON m.[LogID] = d.[LogID]
        WHERE m.[username] = '$Global:useridentifier'
        AND m.[userdomain] = '$env:userdomain'
        GROUP BY m.[data_collection_type], m.[data]
"@

        $RawRows = @(Invoke-SqlQuery -Query $CacheQuery)

        if ($null -ne $RawRows -and $RawRows.Count -gt 0) {
            $Global:PreviouslyLoggedRows = [System.Collections.Generic.List[psobject]]::new([psobject[]]$RawRows)
        } else {
            $Global:PreviouslyLoggedRows = [System.Collections.Generic.List[psobject]]::new()
        }

        Write-Log "Geladen in cache: $($Global:PreviouslyLoggedRows.Count) unieke records voor de huidige gebruiker." -Level Debug


        # Variabelen die nodig zijn om te weten wanneer er naar de database geschreven mag gaan worden
        $Global:NextDateTimeCheckWrite2DB               = (get-date).AddMinutes($Global:AppSettings.GENERAL_WRITE2DB_DELAY_MINUTES)

        ###################################################################################################################
        # OPBOUWEN $Global:Tasks
        ###################################################################################################################
        Write-Log "### OPBOUWEN hash tabel Global:Tasks met de volgende onderdelen (hieronder):"

        # De vaste gegevens die nodig zijn voor het ophalen van data uit de Browsers (sqlite) database)... Dit kunnen we beter overbrengen naar de db
        $BrowserHistoryFetchInfo = @{
            "Firefox" = @{
                Root             = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"
                File             = "places.sqlite" 
                Formula_fromdate = 'Convert-LocalTimeToUnixEpochTime'
                Formula_todate   = 'Convert-UnixEpochTimeToLocal'
                TestQuery        = "SELECT id FROM moz_places LIMIT 1;"
                Query            = "SELECT moz_places.url, moz_places.title, moz_places.visit_count, moz_historyvisits.visit_date AS last_visit_time FROM moz_places JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id WHERE moz_historyvisits.visit_date > <<sinceMicro>>;"
            }
            "Edge"    = @{
                Root             = "$(Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data"),$(Join-Path $env:APPDATA "Microsoft\Edge\User Data")"
                File             = "History"
                Formula_fromdate = 'Convert-LocalTimeToWebKitTime'
                Formula_todate   = 'Convert-WebKitTimeToLocal'
                TestQuery        = "SELECT id FROM urls LIMIT 1;"
                Query            = "SELECT urls.url, urls.title, urls.visit_count, last_visit_time FROM urls JOIN visits ON urls.id = visits.url WHERE visits.visit_time > <<sinceMicro>>;"
            }
            "Chrome"  = @{
                Root             = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
                File             = "History"
                Formula_fromdate = 'Convert-LocalTimeToWebKitTime'
                Formula_todate   = 'Convert-WebKitTimeToLocal'
                TestQuery        = "SELECT id FROM urls LIMIT 1;"
                Query            = "SELECT urls.url, urls.title, urls.visit_count, last_visit_time FROM urls JOIN visits ON urls.id = visits.url WHERE visits.visit_time > <<sinceMicro>>;"
            }
        }

###################################################################################################################
# BROWSER DISCOVERY & TASK SETUP
###################################################################################################################

# 1. Dynamische detectie van virtualisatie/cache mappen (o.a. voor Avanti/AppSense)
Write-Log "--> Dynamische detectie van virtualisatie/cache mappen (o.a. voor Avanti/AppSense)"

$PotentialVirtualPaths = @(
    "C:\AppSenseVirtual",
    "C:\AvantiVirtual",
    "$env:LOCALAPPDATA\VDI\Cache",
    "$env:ProgramData\AppSense"
)
$DetectedVirtualPaths = @()
foreach ($VPath in $PotentialVirtualPaths) {
    if (Test-Path $VPath) {
        $DetectedVirtualPaths += $VPath
        Write-Log "Virtualisatiepad gedetecteerd $VPath = " -Level Debug
    }
}

# 2. Bouw de BrowserCollection
Write-Log "--> Bouw de BrowserCollection voor de volgende browsers (hieronder):"

$BrowserCollection = @{}
$ConfiguredBrowsers = $global:AppSettings.WEBBROWSER_BROWSERS2CHECK -split ',' | ForEach-Object { $_.Trim() }

foreach ($BName in $ConfiguredBrowsers) {
    Write-Log "-----> $($BName):"

    if ($BrowserHistoryFetchInfo.ContainsKey($BName)) {
        $FetchInfo = $BrowserHistoryFetchInfo[$BName]
        $ErrorReason = "Geen werkende database gevonden"
        $SuccessfulFile = $null
        $FinalTempPath = $null

        $CurrentBrowserPaths = @()
        if ($FetchInfo.Root) { $CurrentBrowserPaths += $FetchInfo.Root -split ',' }
        $CurrentBrowserPaths += $DetectedVirtualPaths

:PathLoop foreach ($RootPath in $CurrentBrowserPaths) {
            try {
                if ([string]::IsNullOrWhiteSpace($RootPath) -or -not (Test-Path $RootPath)) { continue }
                
                # 1. Behoud de snelle en AppSense-veilige CMD zoekopdracht
                $DirCommand = "dir /s /b `"$RootPath\$($FetchInfo.File)`" 2>nul"
                [array]$FoundRawFiles = cmd /c $DirCommand
                
                if (Test-HasNoContent $FoundRawFiles) { continue } 

                # 2. Zet de kale tekstpaden om in objecten zodat we de datum kunnen lezen
                $FileObjects = [System.Collections.Generic.List[psobject]]::new()
                foreach ($CandidateStr in ($FoundRawFiles -split "`r`n")) {
                    if (-not [string]::IsNullOrWhiteSpace($CandidateStr) -and (Test-Path -LiteralPath $CandidateStr)) {
                        $FileInfo = Get-Item -LiteralPath $CandidateStr -ErrorAction SilentlyContinue
                        if ($null -ne $FileInfo) {
                            [void]$FileObjects.Add($FileInfo)
                        }
                    }
                }

                # 3. Sorteer op de nieuwste datum (zodat Profile 1 wint van Default)
                [array]$SortedCandidates = $FileObjects | Sort-Object LastWriteTime -Descending | Select-Object -ExpandProperty FullName

                foreach ($CandidateFile in $SortedCandidates) {
                    if ([string]::IsNullOrWhiteSpace($CandidateFile)) { continue }

                    try {
                        # Maak een tijdelijk TaskObject voor de test
                        $FakeTask = [PSCustomObject]@{
                            Browsers = @{
                                $BName = [PSCustomObject]@{
                                    OriginalPath = [string]$CandidateFile
                                    FetchInfo    = $FetchInfo
                                    Checkpoint   = [PSCustomObject]@{ NewestLogDatetime = (Get-Date) }
                                }
                            }
                        }

                        $Global:LastSqliteQueryFailed = [bool]$false
                        [array]$TestResults = Get-BrowserHistory -BrowserName $BName -TaskObject $FakeTask
                        
                        # Als de functie niet is gecrasht: SUCCES (actieve profiel vastgezet)
                        if ($Global:LastSqliteQueryFailed -eq $false) {
                            $SuccessfulFile = [string]$CandidateFile
                            $ErrorReason = $null
                            Write-Log "Validatie geslaagd via Get-BrowserHistory voor $BName op $CandidateFile" -Level Debug
                            break PathLoop 
                        }
                    } catch {
                        Write-Log "Test via Get-BrowserHistory faalde voor $BName op $CandidateFile = $($_.Exception.Message)" -Level Debug
                        continue
                    }
                }
            } catch {
                continue
            }
        }

        # Checkpoint ophalen en object vullen
        $SettingName = "USR_LastBrowser$($BName)LogDateTime"
        $RawDate     = $global:AppSettings.$SettingName
        $FinalDate   = if (Test-HasContent $RawDate) { [datetime]$RawDate } else { (Get-Date).AddYears(-10) }

        $BrowserCollection[$BName] = [PSCustomObject]@{
            Enabled        = [bool](-not $ErrorReason)
            Error          = $ErrorReason
            dbFileFullName = $FinalTempPath
            OriginalPath   = $SuccessfulFile
            FetchInfo      = $FetchInfo
            Checkpoint     = [PSCustomObject]@{ NewestLogDatetime = $FinalDate }
        }
    }
}

# Definieer alle hoofd-taken
        $Global:Tasks = [ordered]@{
            "WindowsProcesses" = [PSCustomObject]@{
                Label        = "CheckWindowsProcesses"
                Enabled      = ([bool]$global:AppSettings.WINPROCESSES_MINIMUM_LOG_ON -or [bool]$global:AppSettings.WINPROCESSES_DETAIL_LOG_ON)
                NextRun      = (Get-Date)
                FunctionName = "Export-WindowsProcesses2DB"
                MinimumLog   = [bool]$global:AppSettings.WINPROCESSES_MINIMUM_LOG_ON
                DetailedLog  = [bool]$global:AppSettings.WINPROCESSES_DETAIL_LOG_ON 
                IntervalSec  = $global:AppSettings.WINPROCESSES_CHECKINTERVALSECONDS 
                ExcludeList  = @()
            }
            "BrowserHistory" = [PSCustomObject]@{
                Label        = "CheckBrowserHistory"
                Enabled      = (([bool]$global:AppSettings.WEBBROWSER_MINIMUM_LOG_ON -or [bool]$global:AppSettings.WEBBROWSER_DETAIL_LOG_ON) -and $BrowserCollection.Count -gt 0)
                NextRun      = (Get-Date)
                FunctionName = "Export-BrowserHistory2DB"
                MinimumLog   = [bool]$global:AppSettings.WEBBROWSER_MINIMUM_LOG_ON 
                DetailedLog  = [bool]$global:AppSettings.WEBBROWSER_DETAIL_LOG_ON
                IntervalSec  = $global:AppSettings.WEBBROWSER_CHECKINTERVALSECONDS
                Browsers     = $BrowserCollection 
                ExcludeList  = @()
            }
            "RecentFiles" = [PSCustomObject]@{
                Label        = "CheckRecentFilesAndFolders"
                Enabled      = ([bool]$global:AppSettings.RECENTFILES_MINIMUM_LOG_ON -or [bool]$global:AppSettings.RECENTFILES_DETAIL_LOG_ON)
                NextRun      = (Get-Date)
                FunctionName = "Export-RecentFilesAndFolders2DB"
                MinimumLog   = [bool]$global:AppSettings.RECENTFILES_MINIMUM_LOG_ON 
                DetailedLog  = [bool]$global:AppSettings.RECENTFILES_DETAIL_LOG_ON
                IntervalSec  = $global:AppSettings.RECENTFILES_CHECKINTERVALSECONDS
            }
        }

        # Voeg checkpoints toe voor de overige (non-browser) taken
        foreach ($Key in $Global:Tasks.Keys) {
            $T = $Global:Tasks[$Key]
            if ($Key -eq "BrowserHistory" -or (Test-IsFalse $T.Enabled) -or ($T.FunctionName -eq "Invoke-DatabaseFlush")) { continue }

            $SettingName = "usr_Last$($Key)LogDateTime" 
            $RawDate = $global:AppSettings.$SettingName
            $Fallback = if ($Key -eq "WindowsProcesses") { Get-Date } else { (Get-Date).AddYears(-10) }
            $FinalDate = if (Test-HasContent $RawDate) { [datetime]$RawDate } else { $Fallback }

            $T | Add-Member -MemberType NoteProperty -Name "Checkpoint" -Value ([PSCustomObject]@{ NewestLogDatetime = $FinalDate })
            Write-Log "Checkpoint geïnitialiseerd voor taak $Key = $FinalDate" -Level Debug
        }

Write-Log "--- Gedetailleerd Overzicht van geconfigureerde Taken ---" -ForegroundColor Cyan

# Zorg dat we een array hebben, ook als er maar 1 taak is
$DisplayTasks = @($Global:Tasks.Values | Where-Object { $null -ne $_ })

if ($DisplayTasks.Count -eq 0) {
    Write-Log "Waarschuwing = Geen actieve taken gevonden" -ForegroundColor Yellow
} else {
    foreach ($Task in $DisplayTasks) {
        # Jouw fix voor de ?? operator
        # We voegen $() toe rondom de if-statement
        $CleanLabel = [string]($( if (Test-HasContent $Task.Label) { $Task.Label } else { "ONBEKENDE TAAK" }))
        $Status = if ($Task.Enabled) { "AAN" } else { "UIT" }
        
        # Hoofdtaak informatie
        Write-Log "Taak $($CleanLabel.PadRight(35)) = Status $Status" -ForegroundColor White
        Write-Log "  [i] Functie: $($Task.FunctionName) | Interval: $($Task.IntervalSec)s | NextRun: $($Task.NextRun)" -ForegroundColor Gray
        Write-Log "  [i] Logging: Minimum=$($Task.MinimumLog) | Detailed=$($Task.DetailedLog)" -ForegroundColor Gray

        # Checkpoint informatie voor de taak zelf
        if (Test-HasContent $Task.Checkpoint) {
            Write-Log "  [i] Laatste Checkpoint: $($Task.Checkpoint.NewestLogDatetime)" -ForegroundColor Gray
        }

        # Browser detail-sectie (Niveau 2)
        if (Test-HasContent $Task.Browsers) {
            foreach ($BName in $Task.Browsers.Keys) {
                $BData = $Task.Browsers[$BName]
                $BStatus = if ($BData.Enabled) { "OK" } else { "FOUT" }
                
                # Check nu puur op OriginalPath voor de weergave
                $PathStatus = if ($BData.OriginalPath) { "Pad gevonden" } else { "Pad ONTBREEKT" }
                
                Write-Log "    > Browser $($BName.PadRight(15)) = $BStatus ($PathStatus)" -ForegroundColor Cyan
                
                # Diepere details (Niveau 3 - FetchInfo & Checkpoints)
                if ($BData.Enabled) {
                    Write-Log "      - Actieve DB: $($BData.OriginalPath)" -ForegroundColor Gray
                    Write-Log "      - Checkpoint: $($BData.Checkpoint.NewestLogDatetime)" -ForegroundColor Gray
                    Write-Log "      - Formules: $($BData.FetchInfo.Formula_fromdate) -> $($BData.FetchInfo.Formula_todate)" -ForegroundColor Gray
                } elseif ($BData.Error) {
                    Write-Log "      - FOUTMELDING: $($BData.Error)" -ForegroundColor Red
                }
            }
        }
        Write-Log " " # Lege regel voor leesbaarheid tussen taken
    }
}
Write-Log "---------------------------------------------------------" -ForegroundColor Cyan

Wait-WithCountdown -Text "Configuratie gecontroleerd. Doorgaan??" -WaitInSeconds 60 -DoNotWait:$Global:QuietMode

        # Werk de ExcludeList bij indien nodig
        if ($Global:Tasks.WindowsProcesses.Enabled) {
            Update-DeviceProcessExcludeList
        }
        if ($Global:Tasks.BrowserHistory.Enabled) {
            Update-DeviceBrowserExcludeList -TaskObject $Tasks.BrowserHistory
        }

        # Dit is een variabele die aangeeft dat Logging door mag gaan indien True en False dan stopt UAM. 
        # Deze var staat los van de vars AppSettings.STARTLOGGING en AppSettings.USR_STARTLOGGING. Deze geven alleen maar aan dat er niet gelogd mag worden, maar dat UAM blijft draaien.
        $global:startLogging = $true

        $Write2DBNow = ''

        ############################ START MAIN LOOP ############################

        # Voer eventueel extra PowerShell code uit uit de database.
        if (Test-HasContent $Global:AppSettings.PSCode){
            invoke-expression $($Global:AppSettings.PSCode)
        }

        :MainLoop while ($global:startLogging){

            try {

                Manage-LogRotation -LogFolder "$Global:RootPath\Logs" -MaxDays ([int]$global:AppSettings.TRANSSCRIPT_MAXDAYS)

                # Vult $Global:AppSettings (om de zoveel tijd want er is een setting die bepaald wanneer de settings uit de database gehaald mogen worden (ZOLANG -ForceRefresh niet gebruikt wordt))
                Get-AppSetting 

                # Geheugen even opruimen
                [int]$MaxGeheugenVoorGC = 130

                if ($PerformanceInfo.Memory_MB -gt $MaxGeheugenVoorGC) {
                    $PerformanceInfo = Get-ProcessPerformance
                    Write-Log "Geheugendrempel overschreden Private RAM ($($PerformanceInfo.Memory_MB)MB > ${MaxGeheugenVoorGC}MB). Start handmatige opruiming... (Indien Private RAM > $($Global:AppSettings.GENERAL_MAX_MEMORY_KILL_UAM) MB --> Auto Restart UAM)"
                    [System.GC]::Collect()
                    [System.GC]::WaitForPendingFinalizers()
                }

                # Voor de algemene logging is het wel handig om te zien als de max memory overschreden wordt.
                $PerformanceInfo = Get-ProcessPerformance

                Write-Log "Current Memory -> RAM Private: $($PerformanceInfo.Memory_MB)MB // WorkingSet: $($PerformanceInfo.WorkingSet_MB)MB // PagedMemory: $($PerformanceInfo.PagedMemory_MB)MB"
                Write-Log "Current CPU Time: $($PerformanceInfo.CPU_Sec) sec"
                Write-Log "Current Threads: $($PerformanceInfo.Threads) // Handles: $($PerformanceInfo.Handles)"

                if ($global:MaxMemoryUseMB -lt $PerformanceInfo.Memory_MB){
                    Write-Log "New MAX Private RAM: $($PerformanceInfo.Memory_MB)MB was $($global:MaxMemoryUseMB)MB // (Indien Private RAM > $($Global:AppSettings.GENERAL_MAX_MEMORY_KILL_UAM) MB --> Auto Restart UAM)" 
                    $global:MaxMemoryUseMB = $PerformanceInfo.Memory_MB
                }
                #Alleen nodig voor uam.exe / $Global:QuietMode is eigenlijk al genoeg en $Global:CurrentProcessName -like '*uam.exe*' hoeft dan eigenlijk niet meer
                if ($PerformanceInfo.Memory_MB -gt $global:AppSettings.GENERAL_MAX_MEMORY_KILL_UAM){
                    Write-Log "Gebruikte RAM memory is groter dan de gewenste ingestelde hoeveelheid $($global:AppSettings.GENERAL_MAX_MEMORY_KILL_UAM)MB. Een nieuwe UAM.exe start en deze wordt gekilled." -Level Warning -ForegroundColor Yellow

                    if ($Global:CurrentProcessName -like '*uam*.exe*') {
                        Write-Log "Huidige process: $($Global:CurrentProcessName) met PID $PID zal worden gekilled na het starten van de nieuwe $($Global:CurrentProcessName)." -ForegroundColor Yellow

                        # Start een nieuwe UAM.exe en kill deze direct weer, hiermee worden alle resources vrijgegeven...
                        [string]$NewUamPath = Join-Path -Path $Global:RootPath -ChildPath $Global:CurrentProcessName

                        # Bereid de start-parameters veilig voor (Splatting)
                        $StartParams = @{
                            FilePath = $NewUamPath
                        }

                        # Alleen een Verb toevoegen als we écht elevated moeten starten
                        if ($Global:UAMStartedElevated) {
                            $StartParams.Add('Verb', 'RunAs')
                        }

                        try {
                            Start-Process @StartParams -ErrorAction Stop
                        } catch {
                            Write-Log "FATALE FOUT bij het starten van nieuwe UAM.exe: $($_.Exception.Message)" -ForegroundColor Red
                        }
                        $global:startLogging = $false
                        continue MainLoop
                    } else {
                        Write-Log "Huidige process: $($Global:CurrentProcessName) met PID=$PID is niet uam*.exe, dus er wordt geen nieuwe UAM sessie gestart, en deze wordt ook niet gekilled. Er wordt alleen een waarschuwing gelogd." -ForegroundColor Yellow
                    }
                }
                # UAM automatisch herstarten  na een bepaalde tijd, zodat nieuwe versies gestart kunnen worden en geheugen vrijgemaakt wordt etc etc.
                if (($Global:AppSettings.AUTO_RESTART_UAM -ne 0)) {
                    
                    [datetime]$TargetTime = $Global:ScriptStartTime.AddMinutes($Global:AppSettings.AUTO_RESTART_UAM)
                    
                    if ((Get-Date) -ge $TargetTime) {
                        Write-Log "UAM automatisch herstarten na een bepaalde tijd." -Level Warning -ForegroundColor Yellow

                        if ($Global:CurrentProcessName -like '*uam*.exe*') {
                            Write-Log "UAM runt langer dan de ingestelde AUTO_RESTART_UAM tijd ($($Global:AppSettings.AUTO_RESTART_UAM) minuten) actief. Een nieuwe $($Global:CurrentProcessName) start en deze wordt gekilled." -Level Info -ForegroundColor Yellow

                            # Start een nieuwe UAM.exe en kill deze direct weer, hiermee worden alle resources vrijgegeven...
                            [string]$NewUamPath = Join-Path -Path $Global:RootPath -ChildPath $Global:CurrentProcessName

                            # Bereid de start-parameters veilig voor (Splatting)
                            $StartParams = @{
                                FilePath = $NewUamPath
                            }

                            # Alleen een Verb toevoegen als we écht elevated moeten starten
                            if ($Global:UAMStartedElevated) {
                                $StartParams.Add('Verb', 'RunAs')
                            }

                            try {
                                Start-Process @StartParams -ErrorAction Stop
                            } catch {
                                Write-Log "FATALE FOUT bij het starten van nieuwe UAM.exe: $($_.Exception.Message)" -ForegroundColor Red
                            }

                            # Stop de huidige loop
                            $global:startLogging = $false
                            continue MainLoop
                        } else {
                            Write-Log "Huidige process: $($Global:CurrentProcessName) met PID=$PID is niet uam*.exe, dus er wordt geen nieuwe UAM sessie gestart, en deze wordt ook niet gekilled. Er wordt alleen een waarschuwing gelogd." -ForegroundColor Yellow
                        }                            
                    }
                }

                # Dit is een centrale plek voor een Message en wachtmoment (waarbij nog wel bepaalde controles plaatsvinden tijdens het wachten)
                if (Test-HasContent $WaitWithCountDownParams){

                    # De message zelf met de tekst waarom er gewacht wordt, en hoe lang er gewacht gaat worden.
                    Write-Log $($WaitWithCountDownParams.Text + " (Wacht voor $($WaitWithCountDownParams.WaitInSeconds) seconde)") -NoNewline

                    if ($WaitWithCountDownParams.ContainsKey('ActionAfterWait')){
                        if ($WaitWithCountDownParams.ActionAfterWait -eq 'quitUAM'){
                            $global:startLogging = $false
                            break
                        }
                    }
                    
                    # Nu wordt de tijd bepaald tot wanneer er gewacht gaat worden, en gaan we in een loop waarbij we regelmatig controleren of er een nieuwere UAM versie is gestart (en dus dat deze sessie moet stoppen), en ook of er input is van de gebruiker (om direct door te gaan of juist om af te sluiten).  
                    $WaitUntil = (get-date).AddSeconds($WaitWithCountDownParams.WaitInSeconds)
                    
                    $doorgaan = $true

                    while ($WaitUntil -gt (get-date) -and $doorgaan){

                        # Hier kunnen checks opgenomen worden die plaatsvinden tijdens het wachten
                        # Checks zijn alleen maar nodig als er nog gelogd moet gaan worden
                        $OtherProcessRunning = (Test-OtherProcessRunning -ProcessName "uam.exe,uam_console.exe" -Productname 'User Activity Monitor' -CurrentPID $PID)
                        if ($OtherProcessRunning -eq 'NewerProcessesFound'){
                            Write-Log "Er is een nieuwere UAM versie actief, en deze sessie zal zich nu moeten afsluiten. There can only be one process active." 
                            $global:startLogging = $false
                            $doorgaan = $false
                            break MainLoop
                        }

                        if (Test-IsFalse $Global:QuietMode){
                            # We checken gedurende 1 seconde in kleine stapjes op input
                            for ($i = 0; $i -lt 10 -and $doorgaan; $i++) {
                                if ((Test-IsFalse $Global:QuietMode) -and [System.Console]::KeyAvailable) {
                                    $keypressed = [System.Console]::ReadKey($true)

                                    if ($keypressed.Key -eq 'w' -and $keypressed.Modifiers -eq 'Control') {
                                        $Write2DBNow = 'yes'
                                        Write-Host "[OVERSLAGEN] Direct doorgaan... Write 2DB Now" -ForegroundColor Cyan 
                                        $doorgaan = $false
                                    } elseif ($keypressed.Key -eq 'Escape') {
                                        Write-Host "`n[CONFIRM] DRUK NOGMAALS OP [ESC] OM AF TE SLUITEN (OF WACHT 5 SEC)..." -ForegroundColor Yellow
                                        
                                        $ConfirmWait = 0
                                        $Confirmed = $false
                                        while ($ConfirmWait -lt 50) { 
                                            if ((Test-IsFalse $Global:QuietMode) -and [System.Console]::KeyAvailable) {
                                                $confirmKey = [System.Console]::ReadKey($true)
                                                if ($confirmKey.Key -eq 'Escape') {
                                                    $Confirmed = $true
                                                    break
                                                }
                                            }
                                            Start-Sleep -Milliseconds 100
                                            $ConfirmWait++
                                        }

                                        if ($Confirmed) {
                                            if (-not $Global:ScriptStartTime) { $Global:ScriptStartTime = Get-Date }
                                            $Uptime = (Get-Date) - [datetime]$Global:ScriptStartTime
                                            $UptimeString = "{0} dagen, {1} uren, {2} minuten" -f $Uptime.Days, $Uptime.Hours, $Uptime.Minutes
                                            
                                            Write-Log -Message "[EXIT] Gebruiker heeft afsluiten bevestigd. Totale Uptime $UptimeString =" -Level Success
                                            
                                            $global:startLogging = $false
                                            $doorgaan = $false
                                            continue MainLoop
                                        } else {
                                            Write-Log -Message "[CONTINUE] Geen bevestiging ontvangen, UAM gaat door =" -Level Info
                                            $doorgaan = $false 
                                        }
                                        } else {
                                            Write-Host "[OVERSLAGEN] Direct doorgaan..." -ForegroundColor Cyan 
                                            $doorgaan = $false
                                        }
                                        break
                                }                                
                            Start-Sleep -Milliseconds 100
                            }
                        } else {
                            Start-Sleep -Seconds 10
                        }
                    }
                    if (!$global:startLogging){
                        continue
                    }
                    if ($WaitWithCountDownParams.ActionAfterWait){
                        Invoke-Expression $WaitWithCountDownParams.ActionAfterWait
                    }
                    $WaitWithCountDownParams = @{}
                }

                ###################################################################################################
                # START controles
                ###################################################################################################

                # 1. Zoek naar alle taken die Enabled zijn. 
                # We filteren 'Write2DB' er even uit, omdat dat een systeemtaak is en geen inhoudelijke logtaak.
                $ActiveTaskCount = ($Global:Tasks.Values | Where-Object { $_.Enabled -and $_.Label -ne "Moment write to database" }).Count

                # 2. Als er geen enkele inhoudelijke taak meer aan staat:
                if ($ActiveTaskCount -eq 0) {
                    $WaitWithCountDownParams = @{
                        Subject       = '' 
                        # Aangepast naar jouw nieuwe tekst-stijl
                        Text          = "Er valt niets te loggen want alle actieve logtaken staan uit op dit moment..."
                        WaitInSeconds = 60 
                    }
                    
                    Write-Log $WaitWithCountDownParams.Text -ForegroundColor Yellow
                    # Roep hier je countdown functie aan (bijv. Start-WaitWithCountDown @WaitWithCountDownParams)
                    continue
                }

                <# Deze code uitgezet omdat we nu naar csv loggen, dan is het van minder belang dat de database online is, en de code dus nog even bewaard om later aan te vullen met code zodat het automatisch werkt als er wel realtime naar een database geschreven wordt.
                if (!(Test-SqlConnection)){
                    $WaitWithCountDownParams = @{Subject = "DataBaseConnecionProblem"; Text = "a Connection to the database was not possible (Test-SqlConnection) (at the moment), so we wait for 10 minutes and try again"; WaitInSeconds = 600}
                    continue
                }
                #>     

                # Check bij elke start van de loop of we een nieuwe dag-log nodig hebben
                #Manage-Transcript -Enable $($Global:AppSettings.TRANSSCRIPT_ENABLE) -LogFolder $global:RootPath -MaxDays $($Global:AppSettings.TRANSSCRIPT_MAXDAYS)

                if ($Global:ErrorCount -gt 100){
                    $WaitWithCountDownParams = @{Subject='100Errors'; 
                                                Text = "More then 100 errors occured, so this uam proces will be stopped. Errors are written to database and/or error files or transscript.";
                                                WaitInSeconds = 60 ;
                                                ActionAfterWait = 'quitUAM'
                                                }
                    continue
                }

                # Wegschijven van de gelogde date vanuit een Array of database (indien het daar tijd voor is)
                if ($Global:AppSettings.GENERAL_WRITE2DB_METHOD -in ('CACHE_CSV','MEMORY')){
                    if (($Global:NextDateTimeCheckWrite2DB -lt (get-date)) -or $Write2DBNow -eq 'yes'){

                        # Update de database veld [UAMprocessMaxMemoryMB] met de nieuwe waarde van het maximale geheugen gebruik van dit UAM proces. Zo kunnen we in de gaten houden hoeveel geheugen er gebruikt wordt en of dat steeds meer wordt (wat een indicatie kan zijn dat er een memory leak is).
                        
                        $Query2Execute = @"
                        UPDATE [dbo].[DeviceLoggingUsers]
                                SET [UAMprocessMaxMemoryMB] = $($PerformanceInfo.Memory_MB)
                        WHERE    [username]     = '$($Global:useridentifier)' 
                            AND  [userdomain]   = '$env:userdomain' 
                            AND  [computername] = '$env:computername'                           
"@
                        # Moet direct weggeschreven worden en niet via CSV!!! Dus geen -defer parameter gebruiken.
                        $null = Invoke-SqlQuery -query $Query2Execute -Defer -CSVPath $Global:CsvPath

                        if ((Test-HasContent $Global:CsvPath)){
                            Try{
                                Invoke-DeferredQueryProcessing -DefferedMethod $($Global:AppSettings.GENERAL_WRITE2DB_METHOD) -CsvPath $($Global:CsvPath) 
                            } catch{
                                Write-Log "Fout bij Invoke-DeferredQueryProcessing met CsvPath $($Global:CsvPath) = $($_.Exception.Message)" -Level Error
                                Write-Log "Csv file wordt verwijderd" -Level Error
                                # Veiligheidscheck: Voorkom dat een gelockt of onvindbaar bestand de catch laat crashen
                                if (Test-Path $Global:CsvPath) { 
                                    Remove-Item -Path $Global:CsvPath -Force -ErrorAction SilentlyContinue 
                                }
                                Write-Log "Een nieuwe UAM.exe start en deze wordt gekilled."

                                # Start een nieuwe UAM.exe en kill deze direct weer, hiermee worden alle resources vrijgegeven en kan er daarna een nieuwe UAM.exe gestart worden die dan weer binnen de gewenste geheugen hoeveelheid blijft.
                                Start-Process -FilePath "$Global:RootPath\uam.exe"  -Verb $(if($Global:UAMStartedElevated) { "RunAs" } else { "Default" })
                                $global:startLogging = $false
                                continue MainLoop
                            }

                        } else {
                            # Deze methode moet nog getest worden en gaat dan om GENERAL_WRITE2DB_METHOD = MEMORY
                            Invoke-DeferredQueryProcessing -DefferedMethod $($Global:AppSettings.GENERAL_WRITE2DB_METHOD) 
                        }
                        
                        # Direct een nieuwe datum/tijd bepalen voor de volgende keer dat we naar de database gaan schijven
                        $Global:NextDateTimeCheckWrite2DB = (get-date).AddMinutes($Global:AppSettings.GENERAL_WRITE2DB_DELAY_MINUTES)
                        $Write2DBNow = ''
                    }
                }
                # Controleren of er iets te loggen valt, of dat we nog moeten wachten tot de eerstvolgende taak...
                $Now = Get-Date

<#
                # Zoek de eerstvolgende tijd waarop een actieve taak moet draaien van alle geplande taken
                $NextTaskRun = $Global:Tasks.Values | Where-Object { $_.Enabled } | Measure-Object -Property NextRun -Minimum | Select-Object -ExpandProperty Minimum

                if ($null -ne $NextTaskRun -and $NextTaskRun -gt $Now) {
                    # Geen enkele taak is op dit moment aan de beurt
                    $WaitWithCountDownParams = @{
                        Text            = $LogText; 
                        WaitInSeconds   = $Global:AppSettings.TIMEINTERVALSECCHECKCHANGES;
                        ActionAfterWait = ''
                    }
                    continue
                }
#>
                # Als in de database logging is uitgezet (voor iedereen), dan volgende loop. Hier is data vanuit Get-AppSettings voor nodig! En Get-AppSettings haalt dit uit de database (na een bepaald aantal seconden, en dus niet elke keer)
                if (Test-IsFalse $Global:AppSettings.STARTLOGGING){
                    $WaitWithCountDownParams = @{Text = "Database waarde [DeviceLoggingSettings].STARTLOGGING = 0 // Logging staat voor iedereen uit --> Wait for the next check..."; 
                                                WaitInSeconds = $($Global:AppSettings.TimeIntervalSecondsCheckStartLogging);
                                                ActionAfterWait = 'Get-AppSetting -ForceRefresh -Scope Global'
                                            }
                    continue
                }

              # nu wordt er specifiek voor de user gekeken of er gelogd mag worden. Bij nieuwe users staat dat default uit en moet dit aangezet worden in een database tabel
                if ((Test-IsFalse $Global:AppSettings.usr_Startlogging)){
                    $WaitWithCountDownParams = @{Text = "Database waarde [DeviceLoggingUsers].STARTLOGGING = 0 (in record voor huidige gebruiker) --> Wait for the next check..." ;
                                                WaitInSeconds = $($Global:AppSettings.TimeIntervalSecondsCheckStartLogging);
                                                ActionAfterWait = 'Get-AppSetting -ForceRefresh -Scope User'  
                                                }
                    continue
                }

                ###################################################################################################
                # Alle controles zijn uitgevoerd
                ###################################################################################################

                ####################################################################################################################################
                ## Uitvoeren van de taken (en dus waar het eigenlijk om ging bij UAM)
                ####################################################################################################################################

                ## Doorlopen van de taken en kijken of er nog iets opgestart moet worden
                $Now = Get-Date

                foreach ($Key in $Global:Tasks.Keys) {
                    $Task = $Global:Tasks[$Key]

                    # Check of taak aan staat en of het tijd is
                    if ($Task.Enabled -and $Now -ge $Task.NextRun) {
                        
                        # Aangepast: Dubbele punt na variabele verwijderd en vervangen door '='
                        Write-Log "Uitvoeren taak $($Task.Label)" -ForegroundColor Blue -BackgroundColor Yellow
                        
                        # Voer de functie uit en geef het taak-object mee als parameter
                        try {
                            & $Task.FunctionName -TaskObject $Task
                            
                            # Bereken nieuwe tijd
                            $Task.NextRun = (Get-Date).AddSeconds($Task.IntervalSec)
                            
                            # Aangepast: Geen 'debug' tekst in de string omdat -Level Debug aanwezig is
                            Write-Log "Taak $($Task.Label) voltooid. Volgende run op $($Task.NextRun.ToString('HH:mm:ss'))" 
                        }
                        catch {
                            # AANGEPAST: De illegale parameter -Level is verwijderd!
                            ErrorHandler -ErrorMessage "Fout bij uitvoeren van taak $($Task.Label) = $($_.Exception.Message)"
                            
                            # Verhoog de tijd alsnog om een oneindige error-loop te voorkomen
                            $Task.NextRun = (Get-Date).AddSeconds($Task.IntervalSec)
                        }
                    }
                }

                ####################################################################################################################################
                ## Een overzicht tonen voor wat er gescheduled staat
                ####################################################################################################################################

                $LogText =  "`n####---------------------------------------------------------------------------------------####`n" 
                
                $LogText += "#### Wachten tot de volgende geplande log datum/tijd is bereikt om te starten...           ####`n" 
                $LogText += "####---------------------------------------------------------------------------------------####`n"
                
                try{
                    foreach ($Key in $Global:Tasks.Keys) {
                        $T = $Global:Tasks[$Key]
                        $TimeStr = if ($T.Enabled) { $T.NextRun.ToString("yyyy-MM-dd HH:mm:ss") } else { "Disabled" }
                        
                        # Check voor extra info bij BrowserHistory (zoals geskipte browsers)
                        $ExtraInfo = ""
                        if ($Key -eq "BrowserHistory") {
                            $Skipped = $T.Browsers.Keys | Where-Object { -not $T.Browsers[$_].Enabled }
                            if (Test-HasContent $Skipped) { $ExtraInfo = " (Browsers skipped = $($Skipped -join ', '))" }
                        }

                        $LogText += "Next $($T.Label.PadRight(40)) = $TimeStr$ExtraInfo`n"
                    }

                    # Nog ook even de volgende csv -> database dump datum/tijd laten zien
                    $TimeStr = $Global:NextDateTimeCheckWrite2DB.ToString("yyyy-MM-dd HH:mm:ss")
                    $LogText += "Next $('Dumping Data from CSV -> DB'.PadRight(40)) = $TimeStr$ExtraInfo`n"
                }catch{
                    $LogText += "`nFout bij het samenstellen van de tekst rond geplande zaken ($($_.Exception.Message))`n"
                }

                $LogText += "####---------------------------------------------------------------------------------------####`n"
                $LogText += "#### T/m de volgende datum/tijd zijn onderstaande te loggen onderdelen reeds vastgelegd... ####`n" 
                $LogText += "####---------------------------------------------------------------------------------------####`n"

                # DYNAMISCH GEDEELTE: Checkpoints ophalen uit de Tasks
                try {
                    foreach ($Key in $Global:Tasks.Keys) {
                        $T = $Global:Tasks[$Key]
                        
                        # --- Gedeelte voor Browsers ---
                        if ($T.Browsers) {
                            foreach ($BName in $T.Browsers.Keys) {
                                $B = $T.Browsers[$BName]
                                $RawTime = $B.Checkpoint.NewestLogDatetime
                                
                                # Formatteer naar yyyy-MM-dd HH:mm:ss.ffffff
                                $TimeStr = if ($RawTime -is [datetime]) { 
                                    $RawTime.ToString("yyyy-MM-dd HH:mm:ss.ffffff") 
                                } elseif ($null -ne $RawTime -and $RawTime -ne "") {
                                    # Mocht het al een string zijn (met microseconden), probeer casten of direct tonen
                                    try { ([datetime]$RawTime).ToString("yyyy-MM-dd HH:mm:ss.ffffff") } catch { $RawTime }
                                } else { "N/A" }

                                $LogText += "$("Last$($BName)HistoryUntil".PadRight(40)) = $TimeStr`n"
                            }
                        } 
                        # --- Gedeelte voor overige taken (WindowsProcesses, etc.) ---
                        elseif ($T.Checkpoint) {
                            $RawTime = $T.Checkpoint.NewestLogDatetime
                            
                            $TimeStr = if ($RawTime -is [datetime]) { 
                                $RawTime.ToString("yyyy-MM-dd HH:mm:ss.ffffff") 
                            } elseif ($null -ne $RawTime -and $RawTime -ne "") {
                                try { ([datetime]$RawTime).ToString("yyyy-MM-dd HH:mm:ss.ffffff") } catch { $RawTime }
                            } else { "N/A" }

                            # Gebruik de Label of de Key voor de naamgeving
                            $LabelName = if ($T.Label) { $T.Label } else { $Key }
                            $LogText += "$("Last$($LabelName)Until".PadRight(40)) = $TimeStr`n"
                        }
                    }
                }catch{
                    $LogText += "`nFout bij het samenstellen van de tekst rond volgende datum/tijd onderdelen ($($_.Exception.Message))`n"
                }


                $LogText += "####---------------------------------------------------------------------------------------####`n"

                # Toon het overzicht in de log
                Write-Log $LogText

                ####################################################################################################################################
                ## Einde van de MAIN loop 
                ####################################################################################################################################
                $WaitWithCountDownParams = @{Text = "Wait to overview the changes... Only in UAM_Console.exe (ESC = Quit UAM)";
                                                WaitInSeconds = $($Global:AppSettings.TIMEINTERVALSECCHECKCHANGES);
                                                ActionAfterWait = 'if (!$Global:QuietMode){clear-host}' 
                                            }
       
            } catch {

                ErrorHandler -ErrorRecord $_
                continue

            } finally {

                #[System.GC]::Collect()
	    	    #[System.GC]::WaitForPendingFinalizers()
                Write-verbose "End Start-Logging"

            }

        } ####################################### END MAIN LOOP #######################################

        # Ophalen van performance info van dit UAM proces. Dit is alleen informatief en wordt weggeschreven naar de database.
        $PerformanceInfo = Get-ProcessPerformance
        Write-Log "Used Memory for UAM.exe before closing UAM.exe: $($PerformanceInfo.Memory_MB)MB"
        $global:MaxMemoryUseMB = $PerformanceInfo.Memory_MB
        Invoke-SqlQuery -Defer -OutputTo CSV -CSVPath $global:CsvPath -query "UPDATE [dbo].[DeviceLoggingUsers] SET [UAMprocessMaxMemoryMB] = '$($PerformanceInfo.Memory_MB)', [UAMShutdownDateTime] = GETDATE() WHERE [username] = '$($Global:useridentifier)' AND  [userdomain] = '$env:userdomain' AND  [computername] = '$env:computername'"

        # We ZIJN nu uit de MAIN loop en UAM komt ten einde en schrijven nu alle data naar de database
        # Zijn er nog defer csv bestanden die nog naar de database geschreven dienen te worden? Ook als defer naar geheugen psCustomObject is gebruikt moet dit gebeuren.
        Invoke-DeferredQueryProcessing -DefferedMethod $Global:AppSettings.GENERAL_WRITE2DB_METHOD -CsvPath $Global:CsvPath 


    } catch {

        ErrorHandler -ErrorRecord $_
    
    }  ## Waarom deze catch ook al weer?

}

#############################################################################################################################################
#############################################################################################################################################
## EINDE FUNCTIES
#############################################################################################################################################
#############################################################################################################################################

$global:startLogging = Invoke-PreStart

if (Test-IsTrue $global:startLogging) {
    # Now everything is checked and ok, the logging can be started.
    
    if (!$Global:QuietMode){
        
        Write-Log "==============================================================================================================================" -ForegroundColor Green
        Wait-WithCountdown -text "All preperations are performed..." -WaitInSeconds 60 -DoNotWait:$Global:QuietMode
        Clear-Host
        Write-Log "==============================================================================================================================" -ForegroundColor Green

    }

    ##### We kunnen nu beginnen met Loggen #####
    Start-Logging #-verbose

}else{

    Write-Error2DB -ErrorMessage "UAM startup could not be started. See previous logging for more details." -LogLevel Critical

    $ErrorText = "`n==============================================================================================================================`n"
    $ErrorText += "This UAM session could not started. See previous logging. This session will quit...`n"
    $ErrorText += "==============================================================================================================================`n"

    Write-Log $ErrorText -ForegroundColor Red
    Wait-WithCountdown -Text ' ' -WaitInSeconds 60 -DoNotWait:$Global:QuietMode
}

# Dit vertelt de Exit Handler dat we succesvol, zonder harde crashes, het einde hebben gehaald!
$Global:ScriptFinishedGracefully = $true

Write-Log "######################################################################################################## "  -ForegroundColor Gray
Write-Log "EINDE SESSIE (pid=$($PID))"
Write-Log "######################################################################################################## "  -ForegroundColor Gray


