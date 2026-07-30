#requires -Version 7.2
<#
.SYNOPSIS
    Generates the native SVG diagrams used by the UAM handover documents.

.DESCRIPTION
    Produces portable SVG files without Mermaid, Graphviz or network
    dependencies. The physical overview is generated from the captured SQL
    metadata and production inventory. The logical and target diagrams are
    explicit design views and label non-enforced relationships as logical.
#>
[CmdletBinding()]
param(
    [string]$MetadataPath = (Join-Path $PSScriptRoot '..\artifacts\database\00_legacy_uam_schema_metadata.json'),
    [string]$InventoryPath = (Join-Path $PSScriptRoot '..\artifacts\database\00_legacy_uam_prod_inventory.csv'),
    [string]$OutputDirectory = (Join-Path $PSScriptRoot '..\artifacts\diagrams')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Web

$outputRoot = [System.IO.Path]::GetFullPath($OutputDirectory)
[void][System.IO.Directory]::CreateDirectory($outputRoot)
$metadata = Get-Content -LiteralPath $MetadataPath -Raw | ConvertFrom-Json
$inventory = Import-Csv -LiteralPath $InventoryPath

$tableInfo = @{}
foreach ($group in ($metadata | Group-Object TableName)) {
    $row = $inventory | Where-Object { $_.RequestedName -ieq $group.Name } | Select-Object -First 1
    $pk = @($group.Group | Where-Object PrimaryKeyOrdinal | Sort-Object PrimaryKeyOrdinal | ForEach-Object ColumnName)
    $tableInfo[$group.Name] = [pscustomobject]@{
        Columns = $group.Count
        Rows = if ($row) { [long]$row.RowCount } else { 0L }
        PrimaryKey = $pk -join ', '
    }
}

function ConvertTo-XmlText {
    param([AllowEmptyString()][string]$Text)
    [System.Web.HttpUtility]::HtmlEncode($Text)
}

function New-SvgCanvas {
    param([int]$Width, [int]$Height, [string]$Title)
    $builder = [System.Text.StringBuilder]::new()
    [void]$builder.AppendLine("<svg xmlns=`"http://www.w3.org/2000/svg`" width=`"$Width`" height=`"$Height`" viewBox=`"0 0 $Width $Height`" role=`"img`" aria-label=`"$(ConvertTo-XmlText $Title)`">")
    [void]$builder.AppendLine(@'
<defs>
  <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%"><feDropShadow dx="0" dy="3" stdDeviation="4" flood-color="#0f172a" flood-opacity="0.14"/></filter>
  <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,6 L9,3 z" fill="#334155"/></marker>
  <marker id="arrowBlue" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto" markerUnits="strokeWidth"><path d="M0,0 L0,6 L9,3 z" fill="#2563eb"/></marker>
  <style>
    .title{font:700 30px 'Segoe UI',Arial,sans-serif;fill:#0f172a}.subtitle{font:400 15px 'Segoe UI',Arial,sans-serif;fill:#475569}
    .panel-title{font:700 17px 'Segoe UI',Arial,sans-serif;fill:#0f172a}.box-title{font:700 14px 'Segoe UI',Arial,sans-serif;fill:#0f172a}.box-title-small{font:700 11px 'Segoe UI',Arial,sans-serif;fill:#0f172a}
    .box-meta{font:400 12px 'Segoe UI',Arial,sans-serif;fill:#475569}.entity-field{font:400 13px Consolas,'Segoe UI',monospace;fill:#334155}
    .entity-key{font:700 13px Consolas,'Segoe UI',monospace;fill:#0f172a}.label{font:600 12px 'Segoe UI',Arial,sans-serif;fill:#334155}
    .small{font:400 11px 'Segoe UI',Arial,sans-serif;fill:#64748b}.zone{font:700 18px 'Segoe UI',Arial,sans-serif;fill:#1e293b}
  </style>
</defs>
'@)
    [void]$builder.AppendLine("<rect width=`"$Width`" height=`"$Height`" fill=`"#f8fafc`"/>")
    [void]$builder.AppendLine("<text x=`"40`" y=`"48`" class=`"title`">$(ConvertTo-XmlText $Title)</text>")
    $builder
}

function Add-SvgText {
    param($Canvas,[int]$X,[int]$Y,[string]$Text,[string]$Class='label',[string]$Anchor='start')
    [void]$Canvas.AppendLine("<text x=`"$X`" y=`"$Y`" text-anchor=`"$Anchor`" class=`"$Class`">$(ConvertTo-XmlText $Text)</text>")
}

function Add-SvgPanel {
    param($Canvas,[int]$X,[int]$Y,[int]$Width,[int]$Height,[string]$Title,[string]$Fill='#eef2ff')
    [void]$Canvas.AppendLine("<rect x=`"$X`" y=`"$Y`" width=`"$Width`" height=`"$Height`" rx=`"18`" fill=`"$Fill`" stroke=`"#cbd5e1`" stroke-width=`"1.5`"/>")
    Add-SvgText $Canvas ($X+20) ($Y+31) $Title 'panel-title'
}

function Add-SvgArrow {
    param($Canvas,[int]$X1,[int]$Y1,[int]$X2,[int]$Y2,[string]$Label='', [switch]$Dashed, [string]$Color='#334155')
    $dash = if ($Dashed) { ' stroke-dasharray="8 6"' } else { '' }
    $marker = if ($Color -eq '#2563eb') { 'arrowBlue' } else { 'arrow' }
    [void]$Canvas.AppendLine("<line x1=`"$X1`" y1=`"$Y1`" x2=`"$X2`" y2=`"$Y2`" stroke=`"$Color`" stroke-width=`"2`"$dash marker-end=`"url(#$marker)`"/>")
    if ($Label) { Add-SvgText $Canvas ([int](($X1+$X2)/2)) ([int](($Y1+$Y2)/2)-7) $Label 'small' 'middle' }
}

function Add-SvgPathArrow {
    param($Canvas,[string]$Path,[string]$Label='', [int]$LabelX=0,[int]$LabelY=0,[switch]$Dashed,[string]$Color='#334155')
    $dash = if ($Dashed) { ' stroke-dasharray="8 6"' } else { '' }
    $marker = if ($Color -eq '#2563eb') { 'arrowBlue' } else { 'arrow' }
    [void]$Canvas.AppendLine("<path d=`"$Path`" fill=`"none`" stroke=`"$Color`" stroke-width=`"2`"$dash marker-end=`"url(#$marker)`"/>")
    if ($Label) { Add-SvgText $Canvas $LabelX $LabelY $Label 'small' 'middle' }
}

function Add-TableBox {
    param($Canvas,[string]$Name,[int]$X,[int]$Y,[int]$Width=245,[int]$Height=72,[string]$Header='#dbeafe')
    $info = $tableInfo[$Name]
    if (-not $info) { throw "No metadata found for table $Name" }
    $rows = $info.Rows.ToString('N0',[Globalization.CultureInfo]::GetCultureInfo('nl-NL'))
    $pk = if ($info.PrimaryKey) { "PK: $($info.PrimaryKey)" } else { 'geen PK' }
    [void]$Canvas.AppendLine("<g filter=`"url(#shadow)`"><rect x=`"$X`" y=`"$Y`" width=`"$Width`" height=`"$Height`" rx=`"10`" fill=`"#ffffff`" stroke=`"#94a3b8`"/><rect x=`"$X`" y=`"$Y`" width=`"$Width`" height=`"27`" rx=`"10`" fill=`"$Header`"/><rect x=`"$X`" y=`"$($Y+18)`" width=`"$Width`" height=`"9`" fill=`"$Header`"/></g>")
    $titleClass = if ($Name.Length -gt 29) { 'box-title-small' } else { 'box-title' }
    Add-SvgText $Canvas ($X+10) ($Y+19) $Name $titleClass
    Add-SvgText $Canvas ($X+10) ($Y+45) "$($info.Columns) velden | $rows productierijen" 'box-meta'
    Add-SvgText $Canvas ($X+10) ($Y+63) $pk 'box-meta'
}

function Add-EntityBox {
    param($Canvas,[string]$Title,[int]$X,[int]$Y,[int]$Width,[string[]]$Fields,[string]$Header='#dbeafe',[string]$Footer='')
    $height = 52 + ($Fields.Count * 22) + $(if($Footer){28}else{10})
    [void]$Canvas.AppendLine("<g filter=`"url(#shadow)`"><rect x=`"$X`" y=`"$Y`" width=`"$Width`" height=`"$height`" rx=`"12`" fill=`"#ffffff`" stroke=`"#64748b`"/><rect x=`"$X`" y=`"$Y`" width=`"$Width`" height=`"38`" rx=`"12`" fill=`"$Header`"/><rect x=`"$X`" y=`"$($Y+26)`" width=`"$Width`" height=`"12`" fill=`"$Header`"/></g>")
    $titleClass = if ($Title.Length -gt 31) { 'box-title-small' } else { 'panel-title' }
    Add-SvgText $Canvas ($X+14) ($Y+25) $Title $titleClass
    for ($i=0; $i -lt $Fields.Count; $i++) {
        $class = if ($Fields[$i] -match '^(PK|FK|PK/FK) ') { 'entity-key' } else { 'entity-field' }
        Add-SvgText $Canvas ($X+15) ($Y+61+($i*22)) $Fields[$i] $class
    }
    if ($Footer) { Add-SvgText $Canvas ($X+15) ($Y+$height-11) $Footer 'small' }
    $height
}

function Complete-SvgCanvas {
    param($Canvas,[string]$Path)
    [void]$Canvas.AppendLine('</svg>')
    [System.IO.File]::WriteAllText($Path,$Canvas.ToString(),[System.Text.UTF8Encoding]::new($false))
}

# Physical overview: all 27 production tables, row counts and enforced keys.
$svg = New-SvgCanvas 1800 1020 'Legacy UAM fysiek datamodel — alle 27 productietabellen'
Add-SvgText $svg 40 76 'Doorgetrokken blauw = fysieke foreign key; gestippeld = aantoonbare logische gegevensstroom.' 'subtitle'
Add-SvgPanel $svg 35 100 570 275 'Agentstate en settings' '#eef2ff'
Add-SvgPanel $svg 620 100 575 275 'Operationele logging' '#ecfeff'
Add-SvgPanel $svg 1210 100 555 365 'Archief en aggregatie' '#f0fdf4'
Add-SvgPanel $svg 35 395 570 275 'Filtering en applicatiematching' '#fff7ed'
Add-SvgPanel $svg 620 395 575 275 'Taken en planning' '#faf5ff'
Add-SvgPanel $svg 1210 485 555 395 'Externe HR/AD-bronstructuren' '#fefce8'
Add-SvgPanel $svg 35 700 570 150 'Beheer en audit' '#f1f5f9'

Add-SvgArrow $svg 605 238 620 238 'logische sleutel' -Dashed
Add-SvgArrow $svg 1195 238 1210 238 'archivering' -Dashed
Add-SvgArrow $svg 1038 532 1038 567 'FK Script_GUID' -Color '#2563eb'
Add-SvgArrow $svg 1622 327 1622 362 'FK LogID' -Color '#2563eb'

Add-TableBox $svg 'DeviceLoggingUsers' 60 150
Add-TableBox $svg 'DeviceLoggingSettings' 330 150
Add-TableBox $svg 'DeviceLoggingUserSettings' 60 245
Add-TableBox $svg 'DeviceLoggingUserAdGroupMembers' 330 245

Add-TableBox $svg 'DeviceBrowserLogging' 645 150
Add-TableBox $svg 'DeviceProcessLogging' 915 150
Add-TableBox $svg 'DeviceRecentFileAndFolderLogging' 645 245
Add-TableBox $svg 'DeviceLoggingErrors' 915 245

Add-TableBox $svg 'DeviceBrowserLogging_Archive' 1235 150 245 72 '#dcfce7'
Add-TableBox $svg 'DeviceProcessLogging_Archive' 1505 150 235 72 '#dcfce7'
Add-TableBox $svg 'DeviceRecentFileAndFolderLogging_Archive' 1235 245 245 72 '#dcfce7'
Add-TableBox $svg 'uam_log_minimal' 1505 245 235 72 '#dcfce7'
Add-TableBox $svg 'uam_log_minimal_dates' 1505 340 235 72 '#dcfce7'

Add-TableBox $svg 'DeviceBrowserLogging2Exclude' 60 445
Add-TableBox $svg 'DeviceProcess2Exclude' 330 445
Add-TableBox $svg 'DeviceApplicationMatches' 60 540

Add-TableBox $svg 'DeviceTypes' 645 445 245 72 '#f3e8ff'
Add-TableBox $svg 'DeviceScripts' 915 445 245 72 '#f3e8ff'
Add-TableBox $svg 'SystemLookups' 645 540 245 72 '#f3e8ff'
Add-TableBox $svg 'DeviceScriptSchedules' 915 540 245 72 '#f3e8ff'

Add-TableBox $svg 'AdUsers' 1235 535 245 72 '#fef9c3'
Add-TableBox $svg 'GG_YF_Employments' 1500 535 240 72 '#fef9c3'
Add-TableBox $svg 'GG_YF_EmploymentsExtensions' 1235 630 245 72 '#fef9c3'
Add-TableBox $svg 'GG_YF_OrganizationUnits' 1500 630 240 72 '#fef9c3'
Add-TableBox $svg 'vwt_hr_contracts' 1235 725 245 72 '#fef9c3'
Add-TableBox $svg 'WIJ_AFAS_Employments' 1500 725 240 72 '#fef9c3'

Add-TableBox $svg 'ActionLog' 60 750
Add-SvgText $svg 40 915 'Legenda' 'panel-title'
Add-SvgArrow $svg 130 938 260 938 'fysiek afgedwongen FK' -Color '#2563eb'
Add-SvgArrow $svg 500 938 630 938 'logische relatie / gegevensstroom' -Dashed
Add-SvgText $svg 40 982 'Bron: productie-inventory en schema-metadata; rijaantallen zijn het vastgelegde meetmoment, geen live teller.' 'small'
Complete-SvgCanvas $svg (Join-Path $outputRoot 'legacy-physical-data-model.svg')

# Logical logging model.
$svg = New-SvgCanvas 1800 1030 'Legacy UAM logisch loggingmodel'
Add-SvgText $svg 40 76 'De meeste relaties zijn natuurlijke sleutels in code/SQL en niet als database-FK afgedwongen.' 'subtitle'
Add-EntityBox $svg 'DeviceLoggingUsers' 45 155 360 @('PK LoggingUserID : int','username : nvarchar','userdomain : nvarchar','computername : nvarchar','LastBrowserLogDateTime : datetime2','LastProcessLogDateTime : datetime2','LastRecentFilesAndFoldersDateTime : datetime2') '#dbeafe' 'Runtime-state en collectorcheckpoints' | Out-Null
Add-EntityBox $svg 'DeviceBrowserLogging' 500 105 360 @('datetimestamp : datetime','username / domain','computername : nvarchar','browser : nvarchar','url / title : nvarchar') '#cffafe' 'Actieve detailfeiten' | Out-Null
Add-EntityBox $svg 'DeviceProcessLogging' 500 385 360 @('datetimestamp : datetime','username / domain','computername : nvarchar','processname : nvarchar','FullpathExecutable : nvarchar') '#cffafe' 'Actieve detailfeiten' | Out-Null
Add-EntityBox $svg 'DeviceRecentFileAndFolderLogging' 500 665 360 @('datetimestamp : datetime','username / domain','computername : nvarchar','pathRecentfileandfolder','file/folder metadata') '#cffafe' 'Actieve detailfeiten' | Out-Null
Add-EntityBox $svg 'DeviceBrowserLogging_Archive' 980 105 360 @('zelfde feitstructuur','langdurige historie','2.474.721 rijen gemeten') '#dcfce7' 'Periodieke archivering, geen FK' | Out-Null
Add-EntityBox $svg 'DeviceProcessLogging_Archive' 980 385 360 @('zelfde feitstructuur','langdurige historie','61.747 rijen gemeten') '#dcfce7' 'Periodieke archivering, geen FK' | Out-Null
Add-EntityBox $svg 'DeviceRecentFileAndFolderLogging_Archive' 980 665 360 @('zelfde feitstructuur','langdurige historie','13.037 rijen gemeten') '#dcfce7' 'Periodieke archivering, geen FK' | Out-Null
Add-EntityBox $svg 'DeviceLoggingErrors' 1400 105 350 @('DatetimeStamp : datetime','Computername : nvarchar','UserName : nvarchar','ErrorMessage / context','collector en stackinformatie') '#fee2e2' 'Technische fouten; geen FK' | Out-Null
Add-EntityBox $svg 'uam_log_minimal' 1400 420 350 @('PK LogID : bigint','username / userdomain','data_collection_type','data : nvarchar','first_logged_datetime') '#dcfce7' 'Compact gebruikssignaal' | Out-Null
Add-EntityBox $svg 'uam_log_minimal_dates' 1400 720 350 @('PK/FK LogID : bigint','PK UsedOnDate : date') '#dcfce7' 'Unieke gebruiksdagen per signaal' | Out-Null

Add-SvgPathArrow $svg 'M405 250 C450 250 455 195 500 195' 'username + domain + computer' 455 205 -Dashed
Add-SvgPathArrow $svg 'M405 300 C450 300 455 475 500 475' '' 0 0 -Dashed
Add-SvgPathArrow $svg 'M405 350 C450 350 455 755 500 755' '' 0 0 -Dashed
Add-SvgArrow $svg 860 195 980 195 'archivering' -Dashed
Add-SvgArrow $svg 860 475 980 475 'archivering' -Dashed
Add-SvgArrow $svg 860 755 980 755 'archivering' -Dashed
Add-SvgPathArrow $svg 'M405 225 C900 20 1300 20 1400 175' 'user/device-context' 910 38 -Dashed
Add-SvgPathArrow $svg 'M405 375 C900 1000 1290 650 1400 530' 'genormaliseerd signaal' 1030 930 -Dashed
Add-SvgArrow $svg 1575 607 1575 720 'FK LogID' -Color '#2563eb'
Add-SvgText $svg 40 997 'Doorgetrokken blauw: fysieke FK. Gestippeld: relatie uit agentcode, SQL en archiveringsgedrag.' 'small'
Complete-SvgCanvas $svg (Join-Path $outputRoot 'legacy-logical-logging-model.svg')

# Configuration, task and source model.
$svg = New-SvgCanvas 1800 1110 'Legacy UAM configuratie-, taak- en bronnenmodel'
Add-SvgText $svg 40 76 'Fysieke sleutels zijn expliciet gemarkeerd; overige koppelingen zijn functionele/logische contracten.' 'subtitle'
Add-EntityBox $svg 'DeviceLoggingSettings' 40 120 315 @('PK Setting_code','Setting_Value','Setting_ValueType','Setting_Enabled') '#e0e7ff' 'Globale instelling' | Out-Null
Add-EntityBox $svg 'DeviceLoggingUserSettings' 420 120 335 @('PK DeviceLoggingUserSettingID','username / domain / computer','Setting_code','Setting_Value') '#e0e7ff' 'Override zonder fysieke FK' | Out-Null
Add-EntityBox $svg 'DeviceBrowserLogging2Exclude' 820 120 300 @('PK ...ExcludeID','URL/domain/patroon','Enabled','Remarks') '#ffedd5' 'Legacy denylist' | Out-Null
Add-EntityBox $svg 'DeviceProcess2Exclude' 1170 120 280 @('PK Process2ExcludeID','process / path / publisher','Enabled') '#ffedd5' 'Legacy denylist' | Out-Null
Add-EntityBox $svg 'DeviceApplicationMatches' 1500 120 270 @('PK ...MatchID','DeviceApplicationID','domain expression','process expression') '#ffedd5' 'Logische CMDB-koppeling' | Out-Null
Add-SvgArrow $svg 355 220 420 220 'Setting_code' -Dashed

Add-EntityBox $svg 'DeviceTypes' 40 455 280 @('PK DeviceTypeID','type / description','Enabled') '#f3e8ff' 'Doelgroepcatalogus' | Out-Null
Add-EntityBox $svg 'DeviceScripts' 385 410 330 @('PK Script_GUID','Script_Description_short','Script_Code','ScriptEnabled','output/type hints') '#f3e8ff' 'Uitvoerbare taakdefinitie' | Out-Null
Add-EntityBox $svg 'DeviceScriptSchedules' 800 410 350 @('PK ScheduleID','FK Script_GUID','ScheduleType','CronExpression','ScheduleEnabled') '#f3e8ff' 'Planning; deels onaf' | Out-Null
Add-EntityBox $svg 'SystemLookups' 1235 455 270 @('PK LookupID','LookupType','LookupCode','LookupValue') '#f3e8ff' 'Referentiewaarden' | Out-Null
Add-EntityBox $svg 'ActionLog' 1540 455 230 @('PK LogID','TableName','RecordID','ChangedFields') '#e2e8f0' 'Polymorfe audit' | Out-Null
Add-SvgArrow $svg 715 505 800 505 'FK Script_GUID' -Color '#2563eb'
Add-SvgArrow $svg 320 525 385 525 'doeltype' -Dashed
Add-SvgArrow $svg 1235 535 1150 535 'lookupcode' -Dashed

Add-EntityBox $svg 'AdUsers' 40 790 280 @('ObjectGUID / SID','SamAccountName','HR-/AD-attributen','235 velden') '#fef9c3' 'Externe bronstructuur' | Out-Null
Add-EntityBox $svg 'DeviceLoggingUserAdGroupMembers' 370 770 350 @('AdGroup metadata','AdUser_ObjectGuid','username / domain') '#fef9c3' 'Groepsselectie zonder FK' | Out-Null
Add-EntityBox $svg 'DeviceLoggingUsers' 780 770 300 @('PK LoggingUserID','username / domain','computername','logging flags/checkpoints') '#dbeafe' 'Te loggen populatie/state' | Out-Null
Add-EntityBox $svg 'HR-bronstructuren' 1150 755 315 @('GG_YF_Employments','GG_YF_EmploymentsExtensions','GG_YF_OrganizationUnits','vwt_hr_contracts','WIJ_AFAS_Employments') '#fef9c3' 'Vervangen door configureerbare views' | Out-Null
Add-EntityBox $svg 'ExternalApplicationCMDB' 1530 790 240 @('application key','naam / eigenaar','classificatie') '#ecfccb' 'Doelcontract, niet fysiek aanwezig' | Out-Null
Add-SvgArrow $svg 320 880 370 880 'ObjectGuid' -Dashed
Add-SvgArrow $svg 720 880 780 880 'username/domain' -Dashed
Add-SvgArrow $svg 1150 880 1080 880 'populatie' -Dashed
Add-SvgPathArrow $svg 'M1635 330 C1720 500 1720 700 1650 790' 'DeviceApplicationID' 1715 575 -Dashed
Add-SvgPathArrow $svg 'M1650 620 C1450 690 1120 700 950 770' 'TableName + RecordID' 1320 690 -Dashed
Add-SvgText $svg 40 1078 'Doelrichting: typed policies, expliciete bronadapters, CMDB-sleutels en referential integrity in plaats van impliciete tekstkoppelingen.' 'small'
Complete-SvgCanvas $svg (Join-Path $outputRoot 'legacy-configuration-task-source-model.svg')

# C# target component architecture.
$svg = New-SvgCanvas 1800 1030 'C# doelarchitectuur — endpoint, ingestie en control plane'
Add-SvgText $svg 40 76 'Kleine endpoint-agent, lokale duurzame buffer, idempotente HTTPS-ingestie en centraal beheer.' 'subtitle'
Add-SvgPanel $svg 35 105 570 845 'Endpoint (Windows)' '#eef2ff'
Add-SvgPanel $svg 625 105 570 845 'Ingestie- en dataplatform' '#ecfeff'
Add-SvgPanel $svg 1215 105 550 845 'Beheer en distributie' '#f0fdf4'

Add-EntityBox $svg 'uam.exe bootstrapper' 85 155 470 @('signed manifest ophalen','versie/hash/signature controleren','atomic install/swap','rollback en service-start') '#dbeafe' 'Geen collectorlogica' | Out-Null
Add-EntityBox $svg 'uam-agent.exe — Worker Service' 85 370 470 @('policy/schedule evaluator','single-instance + health','taskcoördinatie','structured diagnostics') '#dbeafe' 'Kleine orchestrator' | Out-Null
Add-EntityBox $svg 'Lokale SQLite (WAL)' 85 610 230 @('settings snapshot','user overrides','task state','checkpoints','transactional outbox') '#e0e7ff' 'Versleutelde/ACL-beveiligde opslag' | Out-Null
Add-EntityBox $svg 'Task runner / taskhost' 335 610 220 @('collectible ALC voor simpel','out-of-process voor native','timeouts en resource limits','Browser / Recent / Process','Extensions / PowerShell adapter') '#f3e8ff' 'Expliciet taskcontract' | Out-Null

Add-EntityBox $svg 'HTTPS ingestion API' 675 180 470 @('device identity + scopes','gzip batches','schema- en omvangvalidatie','idempotency key','rate limits / backpressure') '#cffafe' 'Geen endpoint-naar-databaseverbinding' | Out-Null
Add-EntityBox $svg 'Duurzame queue' 675 455 470 @('partition key','retry / dead-letter','watermarks','horizontale schaal') '#cffafe' 'Ontkoppelt piekbelasting' | Out-Null
Add-EntityBox $svg 'Ingestion workers' 675 650 225 @('batch insert','deduplicatie','retention/projectors','OpenTelemetry') '#cffafe' 'Stateless schaalbaar' | Out-Null
Add-EntityBox $svg 'PostgreSQL' 920 650 225 @('partitioned event facts','policy/config revisions','application registry','audit/diagnostics') '#dcfce7' 'TimescaleDB alleen na benchmark' | Out-Null

Add-EntityBox $svg 'Admin portal' 1260 180 455 @('loggingbeleid','URL-/procesallowlists','tasks en schedules','diagnostics per persoon/device','audit en operationele status') '#dcfce7' 'Capability-RBAC; veilige defaults' | Out-Null
Add-EntityBox $svg 'Control-plane API' 1260 485 455 @('typed policy revisions','optimistic concurrency','validation + four-eyes options','CMDB/HR/AD adapters','audit trail') '#dcfce7' 'Enige mutatieroute' | Out-Null
Add-EntityBox $svg 'Signed package/policy store' 1260 735 455 @('versioned agent packages','task DLL packages','ETag/delta policies','signatures + rollout rings') '#ecfccb' 'Canary, rollback en provenance' | Out-Null

Add-SvgArrow $svg 320 315 320 370 'install/start' -Color '#2563eb'
Add-SvgArrow $svg 245 555 200 610 'state/outbox'
Add-SvgArrow $svg 400 555 445 610 'run task'
Add-SvgPathArrow $svg 'M315 735 C560 735 575 290 675 290' 'HTTPS gzip + idempotency' 570 520 -Color '#2563eb'
Add-SvgArrow $svg 910 377 910 455 'enqueue'
Add-SvgArrow $svg 910 575 790 650 'consume'
Add-SvgArrow $svg 900 760 920 760 'batch write'
Add-SvgArrow $svg 1487 410 1487 485 'beheeractie'
Add-SvgArrow $svg 1487 655 1487 735 'publish'
Add-SvgPathArrow $svg 'M1260 830 C850 1000 430 980 320 555' 'poll/ETag + signature' 820 970 -Dashed -Color '#2563eb'
Add-SvgPathArrow $svg 'M1260 570 C1180 570 1170 760 1145 760' 'config/audit' 1190 670
Add-SvgText $svg 40 995 'OpenTelemetry en privacyredactie gelden end-to-end; secrets staan in een secret store en nooit in policy, log of pakket.' 'small'
Complete-SvgCanvas $svg (Join-Path $outputRoot 'csharp-target-component-architecture.svg')

# Legacy runtime flow used by the agent analysis document.
$svg = New-SvgCanvas 1500 1050 'Legacy uam.ps1 uitvoeringsflow'
Add-SvgText $svg 40 76 'Samengevat uit 4.805 regels PowerShell; de flow verklaart de migratiegrenzen.' 'subtitle'
$steps = @(
    @{x=470;y=110;w=560;t='1. Processtart en guards';d='Executable, elevation, single-instance en werksetlimieten'},
    @{x=470;y=220;w=560;t='2. Configuratie en connectie';d='dbsettings ontsleutelen, MSSQL testen, globale/user settings laden'},
    @{x=470;y=330;w=560;t='3. Herstel deferred buffer';d='SQL-statements uit CSV terug in geheugen halen'},
    @{x=470;y=440;w=560;t='4. Schedulerbesluit';d='Welke collectors zijn actief en zijn hun intervallen verlopen?'},
    @{x=80;y=585;w=380;t='Browserhistorie';d='Browserprofielen, tijdconversie, URL-data'},
    @{x=560;y=585;w=380;t='Recent / Quick Access';d='LNK/recent items, paden en bestandmetadata'},
    @{x=1040;y=585;w=380;t='Windows-processen';d='Procesnaam, pad, sessie en executable-metadata'},
    @{x=470;y=745;w=560;t='5. Opbouw writes en checkpoints';d='Detail-SQL, minimal log, errorcontext en nieuwe state'},
    @{x=470;y=855;w=560;t='6. Flush en lifecycle';d='CSV/in-memory buffer naar MSSQL, logrotatie, GC en self-restart'}
)
foreach($s in $steps){
    [void]$svg.AppendLine("<g filter=`"url(#shadow)`"><rect x=`"$($s.x)`" y=`"$($s.y)`" width=`"$($s.w)`" height=`"82`" rx=`"14`" fill=`"#ffffff`" stroke=`"#64748b`"/><rect x=`"$($s.x)`" y=`"$($s.y)`" width=`"$($s.w)`" height=`"34`" rx=`"14`" fill=`"#dbeafe`"/><rect x=`"$($s.x)`" y=`"$($s.y+24)`" width=`"$($s.w)`" height=`"10`" fill=`"#dbeafe`"/></g>")
    Add-SvgText $svg ($s.x+16) ($s.y+23) $s.t 'panel-title'
    Add-SvgText $svg ($s.x+16) ($s.y+58) $s.d 'box-meta'
}
Add-SvgArrow $svg 750 192 750 220
Add-SvgArrow $svg 750 302 750 330
Add-SvgArrow $svg 750 412 750 440
Add-SvgPathArrow $svg 'M650 522 C500 545 360 555 270 585' 'actief/vervallen' 450 548 -Dashed
Add-SvgArrow $svg 750 522 750 585 'actief/vervallen' -Dashed
Add-SvgPathArrow $svg 'M850 522 C1000 545 1140 555 1230 585' 'actief/vervallen' 1050 548 -Dashed
Add-SvgPathArrow $svg 'M270 667 C330 710 500 720 620 745' '' 0 0
Add-SvgArrow $svg 750 667 750 745
Add-SvgPathArrow $svg 'M1230 667 C1170 710 1000 720 880 745' '' 0 0
Add-SvgArrow $svg 750 827 750 855
Add-SvgPathArrow $svg 'M1030 900 C1370 900 1370 155 1030 155' 'wachten of self-restart' 1380 520 -Dashed
Add-SvgText $svg 40 1010 'Migratiekern: behoud gedrag en checkpoints; vervang directe SQL, SQL-in-CSV, duplicaten en handmatige geheugensturing.' 'small'
Complete-SvgCanvas $svg (Join-Path $outputRoot 'legacy-agent-execution-flow.svg')

Get-ChildItem -LiteralPath $outputRoot -Filter '*.svg' | Select-Object Name,Length,LastWriteTime
