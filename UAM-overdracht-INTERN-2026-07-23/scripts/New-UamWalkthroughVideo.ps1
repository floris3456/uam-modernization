#requires -Version 7.2
<#
.SYNOPSIS
    Builds the editable PPTX, MP4 walkthrough, transcript and SRT captions.

.DESCRIPTION
    Uses the already privacy-masked DEV screenshots. No browser session or PSU
    mutation is performed by this script. The video is intentionally silent:
    all explanations are visible in the frame and duplicated as captions.
#>
[CmdletBinding()]
param(
    [string]$ScreenshotDirectory = (Join-Path $PSScriptRoot '..\artifacts\screenshots\dev'),
    [string]$DiagramDirectory = (Join-Path $PSScriptRoot '..\artifacts\diagrams'),
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\deliverables\video'),
    [ValidateRange(720,1080)]
    [int]$VerticalResolution = 1080,
    [ValidateRange(1,30)]
    [int]$FramesPerSecond = 25
)

$ErrorActionPreference = 'Stop'
$screenRoot = [IO.Path]::GetFullPath($ScreenshotDirectory)
$diagramRoot = [IO.Path]::GetFullPath($DiagramDirectory)
$outputRoot = [IO.Path]::GetFullPath($OutputDirectory)
[void][IO.Directory]::CreateDirectory($outputRoot)

$slides = @(
    [pscustomobject]@{ Title='UAM PSU-app — DEV walkthrough'; Image='00-start.png'; Duration=6; Text='Huidige UAM Activity Monitor|Read-only vastlegging|Privacygemaskeerde schermgegevens|Geen schrijf-, export- of uitvoeracties' },
    [pscustomobject]@{ Title='Veilige opnamewijze'; Image='00-start.png'; Duration=7; Text='Omgeving: lokale DEV-app|Alleen tabs, zoeken/filteren, sorteren en pagineren|Tabelrijen, invoerwaarden, canvas- en accountlabels gemaskeerd|PROD vereist nog een handmatige browserlogin' },
    [pscustomobject]@{ Title='Logging Users'; Image='01-logging-users.png'; Duration=7; Text='Beheer van de populatie die voor logging in aanmerking komt|Status en selectie worden in gebruikers-/apparaatstate bijgehouden|Muterende knoppen zijn tijdens de documentatieronde niet bediend' },
    [pscustomobject]@{ Title='Logging Users — read-only filter'; Image='01-logging-users-read-interaction.png'; Duration=6; Text='Voorbeeld van een tijdelijke zoek-/filteractie|De testwaarde is na de opname weer verwijderd|Geen record is toegevoegd of gewijzigd' },
    [pscustomobject]@{ Title='User Grids'; Image='02-user-grids.png'; Duration=7; Text='Rasterweergave voor gebruikers- en apparaatselectie|Natuurlijke sleutels bestaan uit gebruikersnaam, domein en computer|Het doelmodel vraagt om stabiele identity keys en typed policies' },
    [pscustomobject]@{ Title='Organogram'; Image='03-organogram.png'; Duration=7; Text='Organisatiegerichte selectie vanuit HR-/AD-gegevens|Legacy gebruikt klantgebonden bronstructuren|Doel: smalle configureerbare HR-/AD-views met een versiecontract' },
    [pscustomobject]@{ Title='Logging Data'; Image='04-logging-data.png'; Duration=7; Text='Inzage in browser-, proces- en recente-itemlogging|Detailgegevens en minimal logging bestaan naast elkaar|Retentie, privacy en aggregatie moeten in het doelmodel expliciet worden' },
    [pscustomobject]@{ Title='Device Scripts & Schedules'; Image='05-device-scripts-schedules.png'; Duration=8; Text='Beheergebied voor device types, scripts, planningen en referentiedata|Het legacy taakmodel is slechts gedeeltelijk uitgewerkt|Doel: alle collectors als getekende, versieerbare tasks met timeouts en isolatie' },
    [pscustomobject]@{ Title='UAM Settings — Global Settings'; Image='11-global-settings.png'; Duration=7; Text='Globale runtime-instellingen voor de agent|Legacywaarden zijn grotendeels tekstueel en worden bij start geladen|Doel: typed, versioned policy plus lokaal gevalideerd SQLite-snapshot' },
    [pscustomobject]@{ Title='Process Exclusions'; Image='12-process-exclusions.png'; Duration=7; Text='Legacy denylist voor processen en paden|Nieuwe richting: procesallowlist met pad, publisher en applicatiesleutel|Dataminimalisatie gebeurt vóór buffering en transport' },
    [pscustomobject]@{ Title='Browser Logging Exclusions'; Image='13-browser-logging-exclusions.png'; Duration=7; Text='Legacy uitsluitingen voor browserlogging|Brede URL-verzameling levert te veel data op|Nieuwe richting: URL-allowlist direct gekoppeld aan Application Registry/CMDB' },
    [pscustomobject]@{ Title='Application Matches'; Image='14-application-matches.png'; Duration=7; Text='Domein- en procesexpressies worden aan een applicatie-ID gekoppeld|De huidige koppeling is tekstueel en heeft geen fysieke FK|Doel: revisioned matchregels met een echte applicatiesleutel' },
    [pscustomobject]@{ Title='Errors'; Image='15-errors.png'; Duration=7; Text='Inzage in technische agentfouten en context|Legacy bewaart veel foutinformatie maar redactie is niet overal uniform|Doel: structured logging, correlation IDs, privacyredactie en OpenTelemetry' },
    [pscustomobject]@{ Title='Audit Log'; Image='16-audit-log.png'; Duration=7; Text='Beheerwijzigingen worden als polymorfe audit vastgelegd|TableName plus RecordID kan geen referential integrity afdwingen|Doel: immutable audit events via één geautoriseerde control-plane API' },
    [pscustomobject]@{ Title='Van IST naar C# doelarchitectuur'; Image='csharp-target-component-architecture.png'; Duration=10; Text='Kleine bootstrapper en .NET Worker Service|SQLite transactional outbox en geïsoleerde taskpackages|HTTPS ingestion API, duurzame queue en PostgreSQL|Modern beheerportaal met typed policies, RBAC en audit' }
)

foreach ($slide in $slides) {
    $root = if ($slide.Image -eq 'csharp-target-component-architecture.png') { $diagramRoot } else { $screenRoot }
    $path = Join-Path $root $slide.Image
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Ontbrekende videobron: $path" }
    $slide | Add-Member -NotePropertyName ImagePath -NotePropertyValue $path
}

function Get-OfficeRgb {
    param([int]$Red,[int]$Green,[int]$Blue)
    $Red + (256 * $Green) + (65536 * $Blue)
}

function Set-ShapeText {
    param($Shape,[string]$Text,[int]$Size,[int]$Color,[switch]$Bold,[string]$Font='Segoe UI')
    $range = $Shape.TextFrame.TextRange
    $range.Text = $Text
    $range.Font.Name = $Font
    $range.Font.Size = $Size
    $range.Font.Color.RGB = $Color
    $range.Font.Bold = if ($Bold) { -1 } else { 0 }
    $Shape.TextFrame.MarginLeft = 8
    $Shape.TextFrame.MarginRight = 8
    $Shape.TextFrame.MarginTop = 5
    $Shape.TextFrame.MarginBottom = 5
}

function Add-TextPanel {
    param($Slide,[string]$Title,[string]$Text)
    $panel = $Slide.Shapes.AddShape(5, 690, 92, 250, 370)
    $panel.Fill.ForeColor.RGB = Get-OfficeRgb 15 23 42
    $panel.Fill.Transparency = 0.04
    $panel.Line.ForeColor.RGB = Get-OfficeRgb 71 85 105
    $panel.Line.Weight = 1.25
    $titleShape = $Slide.Shapes.AddTextbox(1, 706, 108, 220, 66)
    Set-ShapeText $titleShape $Title 23 (Get-OfficeRgb 248 250 252) -Bold
    $body = ($Text -split '\|' | ForEach-Object { "• $_" }) -join "`r`n`r`n"
    $bodyShape = $Slide.Shapes.AddTextbox(1, 706, 185, 220, 245)
    Set-ShapeText $bodyShape $body 14 (Get-OfficeRgb 226 232 240)
}

function Add-FittedPicture {
    param($Slide,[string]$Path,[double]$Left,[double]$Top,[double]$Width,[double]$Height)
    $shape = $Slide.Shapes.AddPicture($Path, 0, -1, $Left, $Top, -1, -1)
    $ratio = $shape.Width / $shape.Height
    $targetRatio = $Width / $Height
    if ($ratio -gt $targetRatio) {
        $shape.Width = $Width
        $shape.Height = $Width / $ratio
    }
    else {
        $shape.Height = $Height
        $shape.Width = $Height * $ratio
    }
    $shape.Left = $Left + (($Width - $shape.Width) / 2)
    $shape.Top = $Top + (($Height - $shape.Height) / 2)
    $shape.Line.ForeColor.RGB = Get-OfficeRgb 148 163 184
    $shape.Line.Weight = 1
    $shape
}

function ConvertTo-SrtTime {
    param([double]$Seconds)
    $span = [TimeSpan]::FromSeconds($Seconds)
    '{0:00}:{1:00}:{2:00},{3:000}' -f [int]$span.TotalHours,$span.Minutes,$span.Seconds,$span.Milliseconds
}

$powerPoint = $null
$presentation = $null
try {
    $powerPoint = New-Object -ComObject PowerPoint.Application
    $powerPoint.Visible = 1
    try { $powerPoint.WindowState = 2 } catch { }
    $powerPoint.WindowState = 2
    $presentation = $powerPoint.Presentations.Add()
    $presentation.PageSetup.SlideWidth = 960
    $presentation.PageSetup.SlideHeight = 540

    [int]$index = 0
    foreach ($item in $slides) {
        $index++
        $slide = $presentation.Slides.Add($index, 12)
        $background = $slide.Shapes.AddShape(1, 0, 0, 960, 540)
        $background.Fill.ForeColor.RGB = Get-OfficeRgb 2 6 23
        $background.Line.Visible = 0

        $header = $slide.Shapes.AddTextbox(1, 24, 15, 910, 55)
        Set-ShapeText $header $item.Title 28 (Get-OfficeRgb 248 250 252) -Bold
        $accent = $slide.Shapes.AddShape(1, 24, 72, 912, 4)
        $accent.Fill.ForeColor.RGB = Get-OfficeRgb 37 99 235
        $accent.Line.Visible = 0

        [void](Add-FittedPicture $slide $item.ImagePath 24 92 640 370)
        Add-TextPanel $slide $item.Title $item.Text

        $footer = $slide.Shapes.AddTextbox(1, 24, 485, 912, 34)
        Set-ShapeText $footer "UAM overdracht • DEV • read-only • privacygemaskeerd • scherm $index/$($slides.Count)" 11 (Get-OfficeRgb 148 163 184)
        $slide.SlideShowTransition.AdvanceOnClick = 0
        $slide.SlideShowTransition.AdvanceOnTime = -1
        $slide.SlideShowTransition.AdvanceTime = [double]$item.Duration
    }

    $pptxPath = Join-Path $outputRoot 'UAM-PSU-app-walkthrough.pptx'
    $mp4Path = Join-Path $outputRoot 'UAM-PSU-app-walkthrough.mp4'
    $presentation.SaveAs($pptxPath, 24)

    $transcript = [System.Text.StringBuilder]::new()
    [void]$transcript.AppendLine('# UAM PSU-app walkthrough — transcript')
    [void]$transcript.AppendLine()
    [void]$transcript.AppendLine('De video is stil en bevat alle toelichting in beeld. Deze tekst is dezelfde inhoud in machineleesbare vorm.')
    [void]$transcript.AppendLine()
    $srt = [System.Text.StringBuilder]::new()
    [double]$cursor = 0
    for ($i=0; $i -lt $slides.Count; $i++) {
        $item = $slides[$i]
        $start = $cursor
        $cursor += [double]$item.Duration
        [void]$transcript.AppendLine("## $($i+1). $($item.Title)")
        [void]$transcript.AppendLine()
        foreach ($line in ($item.Text -split '\|')) { [void]$transcript.AppendLine("- $line") }
        [void]$transcript.AppendLine()
        [void]$srt.AppendLine([string]($i+1))
        [void]$srt.AppendLine("$(ConvertTo-SrtTime $start) --> $(ConvertTo-SrtTime $cursor)")
        [void]$srt.AppendLine($item.Title)
        [void]$srt.AppendLine(($item.Text -replace '\|','; '))
        [void]$srt.AppendLine()
    }
    [IO.File]::WriteAllText((Join-Path $outputRoot 'UAM-PSU-app-walkthrough-transcript.md'),$transcript.ToString(),[Text.UTF8Encoding]::new($false))
    [IO.File]::WriteAllText((Join-Path $outputRoot 'UAM-PSU-app-walkthrough.srt'),$srt.ToString(),[Text.UTF8Encoding]::new($false))

    $presentation.CreateVideo($mp4Path, $true, 7, $VerticalResolution, $FramesPerSecond, 85)
    $deadline = [DateTime]::UtcNow.AddMinutes(20)
    # PpMediaTaskStatus: 1=in progress, 2=queued, 3=done, 4=failed.
    while ($presentation.CreateVideoStatus -in @(1,2) -and [DateTime]::UtcNow -lt $deadline) {
        Start-Sleep -Seconds 2
    }
    if ($presentation.CreateVideoStatus -ne 3) {
        throw "PowerPoint-video-export is niet geslaagd; status=$($presentation.CreateVideoStatus)."
    }
    if (-not (Test-Path -LiteralPath $mp4Path -PathType Leaf)) { throw 'MP4 ontbreekt na geslaagde exportstatus.' }
}
finally {
    if ($presentation) { try { $presentation.Close() } catch {} }
    if ($powerPoint) { try { $powerPoint.Quit() } catch {} }
    if ($presentation) { [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($presentation) }
    if ($powerPoint) { [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($powerPoint) }
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()
}

Get-ChildItem -LiteralPath $outputRoot -File | Select-Object Name,Length,LastWriteTime
