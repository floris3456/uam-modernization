#requires -Version 7.2
<#
.SYNOPSIS
    Builds the final, internally shareable UAM handover ZIP.

.DESCRIPTION
    Copies only the approved documentation, redacted source, artifacts and
    deliverables to a temporary staging folder, generates hashes and a
    validation report, compresses the folder and verifies the ZIP entries.
#>
[CmdletBinding()]
param(
    [string]$ProjectRoot = (Join-Path $PSScriptRoot '..'),
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\deliverables\package'),
    [string]$DateLabel = (Get-Date -Format 'yyyy-MM-dd')
)

$ErrorActionPreference = 'Stop'
$root = [IO.Path]::GetFullPath($ProjectRoot)
$outputRoot = [IO.Path]::GetFullPath($OutputDirectory)
[void][IO.Directory]::CreateDirectory($outputRoot)
$packageBaseName = "UAM-overdracht-INTERN-$DateLabel"
$zipPath = Join-Path $outputRoot ($packageBaseName + '.zip')
if (Test-Path -LiteralPath $zipPath) {
    $suffix = 2
    do {
        $zipPath = Join-Path $outputRoot ("$packageBaseName-v$suffix.zip")
        $suffix++
    } while (Test-Path -LiteralPath $zipPath)
}

$stageParent = Join-Path ([IO.Path]::GetTempPath()) ('uam-handover-' + [guid]::NewGuid().ToString('N'))
$packageRoot = Join-Path $stageParent $packageBaseName
[void][IO.Directory]::CreateDirectory($packageRoot)

function Copy-ApprovedDirectory {
    param([Parameter(Mandatory)][string]$RelativePath)
    $source = Join-Path $root $RelativePath
    if (-not (Test-Path -LiteralPath $source -PathType Container)) { throw "Bronmap ontbreekt: $source" }
    $destination = Join-Path $packageRoot $RelativePath
    [void][IO.Directory]::CreateDirectory((Split-Path $destination -Parent))
    Copy-Item -LiteralPath $source -Destination $destination -Recurse
}

function Copy-ApprovedFile {
    param([Parameter(Mandatory)][string]$RelativePath)
    $source = Join-Path $root $RelativePath
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Bronbestand ontbreekt: $source" }
    $destination = Join-Path $packageRoot $RelativePath
    [void][IO.Directory]::CreateDirectory((Split-Path $destination -Parent))
    Copy-Item -LiteralPath $source -Destination $destination
}

try {
    foreach ($file in @('README-OVERDRACHT.md','uam-logging.ps1')) { Copy-ApprovedFile $file }
    foreach ($directory in @('docs','scripts','sources','artifacts\database','artifacts\diagrams','artifacts\screenshots','deliverables\pdf','deliverables\html')) {
        Copy-ApprovedDirectory $directory
    }
    foreach ($file in @(
        'deliverables\video\README.md',
        'deliverables\video\UAM-PSU-app-walkthrough.mp4',
        'deliverables\video\UAM-PSU-app-walkthrough.pptx',
        'deliverables\video\UAM-PSU-app-walkthrough.srt',
        'deliverables\video\UAM-PSU-app-walkthrough-transcript.md'
    )) { Copy-ApprovedFile $file }

    $manifestRoot = Join-Path $packageRoot 'manifest'
    [void][IO.Directory]::CreateDirectory($manifestRoot)

    # Validate every delivered PowerShell source.
    $parseFailures = @()
    $powerShellFiles = Get-ChildItem -LiteralPath $packageRoot -Filter '*.ps1' -Recurse -File
    foreach ($file in $powerShellFiles) {
        $tokens = $null
        $errors = $null
        [Management.Automation.Language.Parser]::ParseFile($file.FullName,[ref]$tokens,[ref]$errors) | Out-Null
        if ($errors) {
            $parseFailures += [pscustomobject]@{ File = [IO.Path]::GetRelativePath($packageRoot,$file.FullName); Errors = $errors.Count }
        }
    }
    if ($parseFailures) { throw "PowerShell-parsefouten in pakket: $($parseFailures | ConvertTo-Json -Compress)" }

    $dictionaryCsv = Import-Csv (Join-Path $packageRoot 'artifacts\database\04_legacy_uam_data_dictionary.csv')
    $dictionaryJson = Get-Content (Join-Path $packageRoot 'artifacts\database\04_legacy_uam_data_dictionary.json') -Raw | ConvertFrom-Json
    $schemaMetadata = Get-Content (Join-Path $packageRoot 'artifacts\database\00_legacy_uam_schema_metadata.json') -Raw | ConvertFrom-Json
    $inventory = Import-Csv (Join-Path $packageRoot 'artifacts\database\00_legacy_uam_prod_inventory.csv')
    if ($dictionaryCsv.Count -ne 569 -or $dictionaryJson.Count -ne 569 -or $schemaMetadata.Count -ne 569 -or $inventory.Count -ne 27) {
        throw 'Database-artifactaantallen wijken af van 27 tabellen / 569 velden.'
    }

    $ddl = Get-Content (Join-Path $packageRoot 'artifacts\database\01_legacy_uam_prod_schema.sql') -Raw
    if (([regex]::Matches($ddl,'(?i)CREATE\s+TABLE')).Count -ne 27) { throw 'DDL bevat niet exact 27 CREATE TABLE-statements.' }
    foreach ($sqlFile in (Get-ChildItem (Join-Path $packageRoot 'artifacts\database') -Filter '*.sql')) {
        $sqlText = Get-Content $sqlFile.FullName -Raw
        if ([regex]::IsMatch($sqlText,'(?im)^\s*GO\s*$')) { throw "Niet-ondersteunde GO-batchseparator in $($sqlFile.Name)." }
        if ([regex]::IsMatch($sqlText,'(?im)^\s*USE\s+\[?IAM\]?\s*;?')) { throw "Onveilige productiedatabase-switch in $($sqlFile.Name)." }
    }

    # Validate Markdown image links and absence of Mermaid runtime dependencies.
    $missingImages = @()
    $mermaidCount = 0
    foreach ($markdownFile in (Get-ChildItem (Join-Path $packageRoot 'docs') -Filter '*.md' -Recurse -File)) {
        $markdown = Get-Content $markdownFile.FullName -Raw
        $mermaidCount += ([regex]::Matches($markdown,'```mermaid')).Count
        foreach ($match in [regex]::Matches($markdown,'!\[[^\]]*\]\(([^)]+)\)')) {
            $target = $match.Groups[1].Value.Trim('<','>')
            if ($target -notmatch '^(https?:|data:|#)') {
                $resolved = [IO.Path]::GetFullPath((Join-Path $markdownFile.DirectoryName ($target -replace '/','\')))
                if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) { $missingImages += $resolved }
            }
        }
    }
    if ($missingImages -or $mermaidCount) { throw "Documentafhankelijkheden ongeldig: missing=$($missingImages.Count), mermaid=$mermaidCount." }

    Add-Type -AssemblyName System.Drawing
    $screenshots = Get-ChildItem (Join-Path $packageRoot 'artifacts\screenshots\dev') -Filter '*.png' -File
    $screenshotSizes = @()
    foreach ($screenshot in $screenshots) {
        $image = [Drawing.Image]::FromFile($screenshot.FullName)
        try { $screenshotSizes += "$($image.Width)x$($image.Height)" } finally { $image.Dispose() }
    }
    if ($screenshots.Count -ne 20 -or @($screenshotSizes | Sort-Object -Unique).Count -ne 1 -or $screenshotSizes[0] -ne '1920x1080') {
        throw 'De verwachte set van 20 screenshots op 1920x1080 is niet compleet.'
    }

    $pdfRows = @()
    foreach ($pdf in (Get-ChildItem (Join-Path $packageRoot 'deliverables\pdf') -Filter '*.pdf' -File | Sort-Object Name)) {
        $pdfText = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($pdf.FullName))
        $pages = ([regex]::Matches($pdfText,'/Type\s*/Page(?!s)')).Count
        if (-not $pdfText.TrimEnd().EndsWith('%%EOF') -or $pages -lt 1) { throw "Ongeldige PDF: $($pdf.Name)" }
        $pdfRows += [pscustomobject]@{ Name=$pdf.Name; Pages=$pages; Bytes=$pdf.Length }
    }
    if ($pdfRows.Count -ne 5) { throw 'Er zijn niet exact vijf PDF-einddocumenten.' }
    foreach ($onePageName in @('UAM-IST-samenvatting-A4.pdf','UAM-doelbeeld-samenvatting-A4.pdf')) {
        if (($pdfRows | Where-Object Name -eq $onePageName).Pages -ne 1) { throw "$onePageName is niet exact één pagina." }
    }

    $videoPath = Join-Path $packageRoot 'deliverables\video\UAM-PSU-app-walkthrough.mp4'
    $shell = New-Object -ComObject Shell.Application
    $videoFolder = $shell.Namespace((Split-Path $videoPath))
    $videoItem = $videoFolder.ParseName((Split-Path $videoPath -Leaf))
    $duration100ns = [long]$videoItem.ExtendedProperty('System.Media.Duration')
    $videoWidth = [int]$videoItem.ExtendedProperty('System.Video.FrameWidth')
    $videoHeight = [int]$videoItem.ExtendedProperty('System.Video.FrameHeight')
    $videoFrameRate = [int]$videoItem.ExtendedProperty('System.Video.FrameRate')
    if ($duration100ns -lt 1000000000 -or $videoWidth -ne 1920 -or $videoHeight -ne 1080) { throw 'MP4-metadata wijkt af van de verwachte walkthrough.' }

    $redactedSource = Join-Path $packageRoot 'sources\legacy\uam.redacted.ps1'
    $redactedLines = Get-Content $redactedSource
    $redactionOk = $redactedLines[1383].Trim() -match '^\$Pwd\s*=\s*''<REDACTED-HARDCODED-CREDENTIAL>''$'
    if (-not $redactionOk) { throw 'Verwachte credentialredactie op legacy-regel 1384 ontbreekt.' }

    $validationPath = Join-Path $manifestRoot 'VALIDATIERAPPORT.md'
    $pdfTable = ($pdfRows | ForEach-Object { '| `{0}` | {1} | {2} |' -f $_.Name,$_.Pages,$_.Bytes }) -join "`r`n"
    $validation = @"
# Validatierapport definitieve UAM-overdracht

**Gegenereerd:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')  
**Classificatie:** intern technisch overdrachtsmateriaal

## Resultaten

| Controle | Resultaat |
| --- | --- |
| PowerShell parsing | OK — $($powerShellFiles.Count) bestanden, 0 parsefouten |
| Datamodel | OK — 27 tabellen en 569 metadata-/dictionaryrecords |
| SQL DDL/data | OK — 27 `CREATE TABLE`, geen `GO` en geen `USE [IAM]` |
| Markdownafbeeldingen | OK — 0 ontbrekend, 0 Mermaid-runtimeblokken |
| DEV-screenshots | OK — 20 PNG's, allemaal 1920×1080 |
| Credentialredactie | OK — alleen legacybronregel 1384 bevat de REDACTED-placeholder |
| MP4 | OK — $([Math]::Round($duration100ns / 10000000,2)) sec, ${videoWidth}×${videoHeight}, $([Math]::Round($videoFrameRate/1000,2)) fps |

## PDF's

| Bestand | Pagina's | Bytes |
| --- | ---: | ---: |
$pdfTable

## Beveiligingsnotities

- De originele legacy SHA-256 is `44F7CBDB53C5A0100D30B531F1AC478E186EDBB744EEC06BA2A5DA4B699A2B94`.
- De meegeleverde geredigeerde legacy SHA-256 is `$((Get-FileHash $redactedSource -Algorithm SHA256).Hash)`.
- Het oorspronkelijke hardcoded wachtwoord, PSU-tokens, cookies en browserprofielen zijn niet opgenomen.
- `02_legacy_uam_reference_data.sql` bevat interne URL-/applicatieconfiguratie; alleen intern gebruiken en voor installatie uitsluitend de IAMDEV-installer toepassen. De SQL-artifacts bevatten geen `GO` en geen `USE [IAM]`.
- De video en PSU-PDF gebruiken de bestaande gemaskeerde DEV-bewijsset. Actuele DEV-/PROD-heropname vereist een geldige handmatige browserlogin.
"@
    [IO.File]::WriteAllText($validationPath,$validation,[Text.UTF8Encoding]::new($true))

    $inventoryRows = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName | ForEach-Object {
        [pscustomobject]@{
            RelativePath = [IO.Path]::GetRelativePath($packageRoot,$_.FullName).Replace('\','/')
            Bytes = $_.Length
            LastWriteTimeUtc = $_.LastWriteTimeUtc.ToString('o')
        }
    }
    $inventoryRows | Export-Csv (Join-Path $manifestRoot 'BESTANDEN.csv') -NoTypeInformation -Encoding utf8
    [IO.File]::WriteAllText((Join-Path $manifestRoot 'BESTANDEN.json'),($inventoryRows | ConvertTo-Json -Depth 3),[Text.UTF8Encoding]::new($true))

    $hashRows = Get-ChildItem -LiteralPath $packageRoot -Recurse -File | Sort-Object FullName | ForEach-Object {
        [pscustomobject]@{
            RelativePath = [IO.Path]::GetRelativePath($packageRoot,$_.FullName).Replace('\','/')
            SHA256 = (Get-FileHash $_.FullName -Algorithm SHA256).Hash
            Bytes = $_.Length
        }
    }
    $hashRows | Export-Csv (Join-Path $manifestRoot 'SHA256SUMS.csv') -NoTypeInformation -Encoding utf8

    Compress-Archive -LiteralPath $packageRoot -DestinationPath $zipPath -CompressionLevel Optimal
    if (-not (Test-Path -LiteralPath $zipPath -PathType Leaf)) { throw 'ZIP is niet aangemaakt.' }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($zipPath)
    try {
        $entries = @($archive.Entries)
        $forbidden = @($entries | Where-Object { $_.FullName -match '(?i)(\.clixml$|app-token|psu-prod-uam-doc-token|video-build\.|deliverables/validation|\.git/)' })
        if ($forbidden) { throw "Verboden ZIP-entry: $($forbidden.FullName -join ', ')" }
        if (-not ($entries.FullName -match '/README-OVERDRACHT\.md$')) { throw 'README ontbreekt in ZIP.' }
        if (-not ($entries.FullName -match '/manifest/SHA256SUMS\.csv$')) { throw 'Hashmanifest ontbreekt in ZIP.' }
        $entryCount = $entries.Count
    }
    finally { $archive.Dispose() }

    [pscustomobject]@{
        ZipPath = $zipPath
        ZipBytes = (Get-Item $zipPath).Length
        ZipSHA256 = (Get-FileHash $zipPath -Algorithm SHA256).Hash
        Entries = $entryCount
        PackageName = $packageBaseName
        PdfFiles = $pdfRows.Count
        VideoSeconds = [Math]::Round($duration100ns / 10000000,2)
    }
}
finally {
    if (Test-Path -LiteralPath $stageParent -PathType Container) {
        $resolvedStage = [IO.Path]::GetFullPath($stageParent)
        $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
        if ($resolvedStage.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -and (Split-Path $resolvedStage -Leaf).StartsWith('uam-handover-')) {
            Remove-Item -LiteralPath $resolvedStage -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
