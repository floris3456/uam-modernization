#requires -Version 7.2
<#
.SYNOPSIS
    Performs deterministic validation of the UAM handover sources and outputs.
#>
[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $PSScriptRoot '..'),
    [string]$ReportPath = (Join-Path $PSScriptRoot '..\deliverables\validation-report.json')
)

$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($ProjectRoot)
$checks = [Collections.Generic.List[object]]::new()
$issues = [Collections.Generic.List[string]]::new()

function Add-Check {
    param([string]$Name,[bool]$Passed,[string]$Detail)
    $checks.Add([pscustomobject]@{ Check=$Name; Passed=$Passed; Detail=$Detail })
    if (-not $Passed) { $issues.Add("$Name — $Detail") }
}

function Get-BigEndianUInt32 {
    param([byte[]]$Bytes,[int]$Offset)
    ([uint32]$Bytes[$Offset] -shl 24) -bor ([uint32]$Bytes[$Offset+1] -shl 16) -bor ([uint32]$Bytes[$Offset+2] -shl 8) -bor [uint32]$Bytes[$Offset+3]
}

function Get-Mp4DurationSeconds {
    param([string]$Path)
    $bytes = [IO.File]::ReadAllBytes($Path)
    for ($i=0; $i -lt ($bytes.Length-40); $i++) {
        if ($bytes[$i] -eq 0x6d -and $bytes[$i+1] -eq 0x76 -and $bytes[$i+2] -eq 0x68 -and $bytes[$i+3] -eq 0x64) {
            $version = $bytes[$i+4]
            if ($version -eq 0) {
                $timescale = Get-BigEndianUInt32 $bytes ($i+16)
                $duration = Get-BigEndianUInt32 $bytes ($i+20)
                if ($timescale) { return [math]::Round($duration / $timescale,2) }
            }
        }
    }
    0
}

# PowerShell parser checks.
$powerShellFiles = @(
    (Join-Path $root 'uam-logging.ps1'),
    (Join-Path $root 'sources\legacy\uam.redacted.ps1')
) + @(Get-ChildItem -LiteralPath (Join-Path $root 'scripts') -Filter '*.ps1' -File | Select-Object -ExpandProperty FullName)
foreach ($file in $powerShellFiles) {
    $tokens = $null
    $parseErrors = $null
    [Management.Automation.Language.Parser]::ParseFile($file,[ref]$tokens,[ref]$parseErrors) | Out-Null
    Add-Check "PowerShell parse: $([IO.Path]::GetFileName($file))" ($parseErrors.Count -eq 0) "$($parseErrors.Count) parsefouten"
}

$redactedSource = Join-Path $root 'sources\legacy\uam.redacted.ps1'
$redactedText = Get-Content -LiteralPath $redactedSource -Raw
Add-Check 'Legacy credential redacted' ($redactedText.Contains('<REDACTED-HARDCODED-CREDENTIAL>')) 'Credentialplaceholder aanwezig'
$literalSecretPattern = '(?im)(password|passwd|pwd|secret|api[_-]?key|authorization)\s*=\s*["''](?!<REDACTED)[^"'']+["'']'
Add-Check 'Geen literal secret assignment in redacted source' (-not [regex]::IsMatch($redactedText,$literalSecretPattern)) 'Geen resterende literal password/secret assignment'

# Database artifacts.
$metadata = Get-Content -LiteralPath (Join-Path $root 'artifacts\database\00_legacy_uam_schema_metadata.json') -Raw | ConvertFrom-Json
$inventory = Import-Csv -LiteralPath (Join-Path $root 'artifacts\database\00_legacy_uam_prod_inventory.csv')
$dictionaryJson = Get-Content -LiteralPath (Join-Path $root 'artifacts\database\04_legacy_uam_data_dictionary.json') -Raw | ConvertFrom-Json
$dictionaryCsv = Import-Csv -LiteralPath (Join-Path $root 'artifacts\database\04_legacy_uam_data_dictionary.csv')
Add-Check 'Schema: 27 tabellen' (@($metadata.TableName | Sort-Object -Unique).Count -eq 27) "gevonden $(@($metadata.TableName | Sort-Object -Unique).Count)"
Add-Check 'Schema: 569 velden' ($metadata.Count -eq 569) "gevonden $($metadata.Count)"
Add-Check 'Inventory: 27 tabellen' ($inventory.Count -eq 27) "gevonden $($inventory.Count)"
Add-Check 'Dictionary JSON: 569 velden' ($dictionaryJson.Count -eq 569) "gevonden $($dictionaryJson.Count)"
Add-Check 'Dictionary CSV: 569 velden' ($dictionaryCsv.Count -eq 569) "gevonden $($dictionaryCsv.Count)"
Add-Check 'Foreign keys: 2' (@($metadata | Where-Object ForeignKeyName | Select-Object ForeignKeyName -Unique).Count -eq 2) "gevonden $(@($metadata | Where-Object ForeignKeyName | Select-Object ForeignKeyName -Unique).Count)"

$sqlFiles = Get-ChildItem -LiteralPath (Join-Path $root 'artifacts\database') -Filter '*.sql' -File
foreach ($sqlFile in $sqlFiles) {
    $sql = Get-Content -LiteralPath $sqlFile.FullName -Raw
    Add-Check "SQL zonder GO: $($sqlFile.Name)" (-not [regex]::IsMatch($sql,'(?im)^\s*GO\s*(?:--.*)?$')) 'Geen batchseparator'
    Add-Check "SQL zonder USE IAM: $($sqlFile.Name)" (-not [regex]::IsMatch($sql,'(?im)^\s*USE\s+\[?IAM\]?\s*;?')) 'Geen productiedatabase-switch'
}

# Markdown links and diagrams.
$markdownFiles = Get-ChildItem -LiteralPath (Join-Path $root 'docs') -Filter '*.md' -Recurse -File
foreach ($markdownFile in $markdownFiles) {
    $markdown = Get-Content -LiteralPath $markdownFile.FullName -Raw
    foreach ($match in [regex]::Matches($markdown,'!\[[^\]]*\]\(([^)]+)\)')) {
        $relative = $match.Groups[1].Value.Trim('<','>')
        if ($relative -notmatch '^(https?:|data:|#)') {
            $target = [IO.Path]::GetFullPath((Join-Path $markdownFile.DirectoryName ($relative -replace '/','\')))
            Add-Check "Afbeeldingslink: $($markdownFile.Name) → $relative" (Test-Path -LiteralPath $target -PathType Leaf) $target
        }
    }
}
$diagramFiles = Get-ChildItem -LiteralPath (Join-Path $root 'artifacts\diagrams') -File
Add-Check 'Diagrammen: 5 SVG' (@($diagramFiles | Where-Object Extension -eq '.svg').Count -eq 5) "gevonden $(@($diagramFiles | Where-Object Extension -eq '.svg').Count)"
Add-Check 'Diagrammen: 5 PNG' (@($diagramFiles | Where-Object Extension -eq '.png').Count -eq 5) "gevonden $(@($diagramFiles | Where-Object Extension -eq '.png').Count)"

# Screenshot evidence.
$screenshots = Get-ChildItem -LiteralPath (Join-Path $root 'artifacts\screenshots\dev') -Filter '*.png' -File
Add-Check 'DEV screenshots: 20 PNG' ($screenshots.Count -eq 20) "gevonden $($screenshots.Count)"
foreach ($screenshot in $screenshots) {
    $signature = [IO.File]::ReadAllBytes($screenshot.FullName)[0..7]
    $isPng = ($signature -join ',') -eq '137,80,78,71,13,10,26,10'
    Add-Check "PNG-signature: $($screenshot.Name)" $isPng "$($screenshot.Length) bytes"
}

# PDF output and page count.
$expectedPdfs = @(
    'UAM-IST-samenvatting-A4.pdf',
    'UAM-doelbeeld-samenvatting-A4.pdf',
    'UAM-legacy-overdrachtsdossier.pdf',
    'UAM-databasemodel-en-data-dictionary.pdf',
    'UAM-PSU-app-IST.pdf'
)
$pdfPageCounts = @{}
foreach ($pdfName in $expectedPdfs) {
    $pdfPath = Join-Path $root "deliverables\pdf\$pdfName"
    $exists = Test-Path -LiteralPath $pdfPath -PathType Leaf
    Add-Check "PDF bestaat: $pdfName" $exists $pdfPath
    if ($exists) {
        $bytes = [IO.File]::ReadAllBytes($pdfPath)
        $text = [Text.Encoding]::Latin1.GetString($bytes)
        $pages = [regex]::Matches($text,'/Type\s*/Page(?!s)').Count
        $pdfPageCounts[$pdfName] = $pages
        Add-Check "PDF-structuur: $pdfName" ($text.StartsWith('%PDF-') -and $text.Contains('%%EOF') -and $pages -gt 0) "$pages pagina's; $($bytes.Length) bytes"
    }
}
Add-Check 'IST-samenvatting exact één A4' ($pdfPageCounts['UAM-IST-samenvatting-A4.pdf'] -eq 1) "$($pdfPageCounts['UAM-IST-samenvatting-A4.pdf']) pagina's"
Add-Check 'Doelbeeld-samenvatting exact één A4' ($pdfPageCounts['UAM-doelbeeld-samenvatting-A4.pdf'] -eq 1) "$($pdfPageCounts['UAM-doelbeeld-samenvatting-A4.pdf']) pagina's"

# Video set.
$videoRoot = Join-Path $root 'deliverables\video'
$mp4Path = Join-Path $videoRoot 'UAM-PSU-app-walkthrough.mp4'
$pptxPath = Join-Path $videoRoot 'UAM-PSU-app-walkthrough.pptx'
$srtPath = Join-Path $videoRoot 'UAM-PSU-app-walkthrough.srt'
$transcriptPath = Join-Path $videoRoot 'UAM-PSU-app-walkthrough-transcript.md'
Add-Check 'Walkthrough MP4 bestaat' (Test-Path -LiteralPath $mp4Path -PathType Leaf) $mp4Path
if (Test-Path -LiteralPath $mp4Path -PathType Leaf) {
    $mp4Bytes = [IO.File]::ReadAllBytes($mp4Path)
    $head = [Text.Encoding]::ASCII.GetString($mp4Bytes,0,[math]::Min(64,$mp4Bytes.Length))
    $duration = Get-Mp4DurationSeconds $mp4Path
    Add-Check 'Walkthrough MP4-container' ($head.Contains('ftyp') -and $mp4Bytes.Length -gt 1000000) "$($mp4Bytes.Length) bytes"
    Add-Check 'Walkthroughduur circa 107 seconden' ($duration -ge 100 -and $duration -le 115) "$duration seconden"
}
Add-Check 'Bewerkbare PPTX bestaat' (Test-Path -LiteralPath $pptxPath -PathType Leaf) $pptxPath
Add-Check 'SRT bestaat' (Test-Path -LiteralPath $srtPath -PathType Leaf) $srtPath
Add-Check 'Transcript bestaat' (Test-Path -LiteralPath $transcriptPath -PathType Leaf) $transcriptPath
if (Test-Path -LiteralPath $srtPath -PathType Leaf) {
    $cueCount = [regex]::Matches((Get-Content -LiteralPath $srtPath -Raw),'(?m)^\d+\r?$').Count
    Add-Check 'SRT: 15 schermhoofdstukken' ($cueCount -eq 15) "gevonden $cueCount"
}

$result = [pscustomobject]@{
    GeneratedAt = Get-Date
    Passed = ($issues.Count -eq 0)
    CheckCount = $checks.Count
    FailureCount = $issues.Count
    PdfPageCounts = $pdfPageCounts
    Checks = $checks
    Issues = $issues
}
$json = $result | ConvertTo-Json -Depth 8
[IO.File]::WriteAllText([IO.Path]::GetFullPath($ReportPath),$json,[Text.UTF8Encoding]::new($false))
[pscustomobject]@{
    Passed = $result.Passed
    CheckCount = $result.CheckCount
    FailureCount = $result.FailureCount
    PdfPageCounts = $result.PdfPageCounts
    Issues = $result.Issues
    ReportPath = [IO.Path]::GetFullPath($ReportPath)
} | ConvertTo-Json -Depth 5
if ($issues.Count) { exit 1 }
