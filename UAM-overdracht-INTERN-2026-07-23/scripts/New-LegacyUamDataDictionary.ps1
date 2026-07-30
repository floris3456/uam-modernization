[CmdletBinding()]
param(
    [string]$MetadataPath = (Join-Path $PSScriptRoot '..\artifacts\database\00_legacy_uam_schema_metadata.json'),
    [string]$ProfilePath = (Join-Path $PSScriptRoot '..\artifacts\database\00_legacy_uam_prod_column_profile.json'),
    [string]$InventoryPath = (Join-Path $PSScriptRoot '..\artifacts\database\00_legacy_uam_prod_inventory.json'),
    [string]$AgentSourcePath = 'H:\Mijn Documenten\UAM\V0.7\uam.ps1',
    [string]$DevAppSourcePath = (Join-Path $PSScriptRoot '..\uam-logging.ps1'),
    [Parameter(Mandatory)]
    [string]$ProdAppSourcePath,
    [string]$DatabaseOutputRoot = (Join-Path $PSScriptRoot '..\artifacts\database'),
    [string]$DocumentationOutputRoot = (Join-Path $PSScriptRoot '..\docs\appendices')
)

$ErrorActionPreference = 'Stop'

foreach ($path in @($MetadataPath, $ProfilePath, $InventoryPath, $AgentSourcePath, $DevAppSourcePath, $ProdAppSourcePath)) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Verplichte invoer ontbreekt: $path"
    }
}

[void](New-Item -ItemType Directory -Path $DatabaseOutputRoot -Force)
[void](New-Item -ItemType Directory -Path $DocumentationOutputRoot -Force)

$metadata = @(Get-Content -Raw -LiteralPath $MetadataPath | ConvertFrom-Json)
$profile = @(Get-Content -Raw -LiteralPath $ProfilePath | ConvertFrom-Json)
$inventory = @(Get-Content -Raw -LiteralPath $InventoryPath | ConvertFrom-Json)
$agentSource = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $AgentSourcePath))
$devAppSource = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $DevAppSourcePath))
$prodAppSource = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $ProdAppSourcePath))

if ($metadata.Count -ne 569 -or $profile.Count -ne 569) {
    throw "Onverwachte invoer: metadata=$($metadata.Count), profiel=$($profile.Count); verwacht 569 velden."
}

$profileByColumn = @{}
foreach ($item in $profile) { $profileByColumn["$($item.TableName).$($item.ColumnName)"] = $item }
$inventoryByTable = @{}
foreach ($item in $inventory) { $inventoryByTable[[string]$item.RequestedName] = $item }

$externalTables = @(
    'AdUsers',
    'GG_YF_Employments',
    'GG_YF_EmploymentsExtensions',
    'GG_YF_OrganizationUnits',
    'vwt_hr_contracts',
    'WIJ_AFAS_Employments'
)
$activeDetailTables = @(
    'DeviceBrowserLogging',
    'DeviceProcessLogging',
    'DeviceRecentFileAndFolderLogging'
)

$tableDescriptions = @{
    ActionLog = 'Polymorf auditspoor van beheeracties in de PSU-app.'
    AdUsers = 'Extern AD-gebruikerssnapshot; breed klantbroncontract en geen eigendom van UAM.'
    DeviceApplicationMatches = 'Koppelt URL-/procespatronen aan een applicatie- of CMDB-identificatie.'
    DeviceBrowserLogging = 'Actieve detailbuffer voor browserhistorie; periodiek naar het archief verplaatst.'
    DeviceBrowserLogging_Archive = 'Historisch browsergebruik en grootste legacy UAM-feitentabel.'
    DeviceBrowserLogging2Exclude = 'Legacy uitsluitlijst voor browserdomeinen en URL-patronen.'
    DeviceLoggingErrors = 'Agentdiagnostiek, foutdetails en uitvoeringscontext.'
    DeviceLoggingSettings = 'Globale key/value-instellingen die de agent bij starten inleest.'
    DeviceLoggingUserAdGroupMembers = 'Materiële selectie/koppeling van te loggen gebruikers en AD-groepen.'
    DeviceLoggingUsers = 'Per gebruiker/apparaat de agentstatus, versie en taakcheckpoints.'
    DeviceLoggingUserSettings = 'Afwijkende instellingen per gebruiker/apparaat.'
    DeviceProcess2Exclude = 'Legacy uitsluitlijst voor procesnamen/paden.'
    DeviceProcessLogging = 'Actieve detailbuffer voor procesgebruik.'
    DeviceProcessLogging_Archive = 'Historisch procesgebruik.'
    DeviceRecentFileAndFolderLogging = 'Actieve detailbuffer voor Windows Recent/Quick Access-koppelingen.'
    DeviceRecentFileAndFolderLogging_Archive = 'Historisch Windows Recent/Quick Access-gebruik.'
    DeviceScripts = 'Definitie van aanvullende uitvoerbare PowerShell-taken.'
    DeviceScriptSchedules = 'Planning en doelgroepselectie voor DeviceScripts.'
    DeviceTypes = 'Apparaattypen en OU-doelgroepen voor taakuitvoering.'
    GG_YF_Employments = 'Extern Youforce-dienstverbandbroncontract.'
    GG_YF_EmploymentsExtensions = 'Extern Youforce-uitbreidingsbroncontract.'
    GG_YF_OrganizationUnits = 'Extern Youforce-organisatiebroncontract.'
    SystemLookups = 'Referentiewaarden voor taakuitvoer en planning.'
    uam_log_minimal = 'Geaggregeerde unieke gebruikers-/datapunten met eerste waarneming.'
    uam_log_minimal_dates = 'Dagelijkse gebruiksdatums bij uam_log_minimal.'
    vwt_hr_contracts = 'Extern HR-contractviewcontract.'
    WIJ_AFAS_Employments = 'Extern AFAS-dienstverbandbroncontract.'
}

$manualFieldNotes = @{
    'ActionLog.RecordID' = 'Polymorfe tekstsleutel; de doelentiteit wordt alleen via TableName geïnterpreteerd.'
    'ActionLog.ChangedFields' = 'Vrije auditpayload; kan persoonsgegevens en oude/nieuwe waarden bevatten.'
    'DeviceApplicationMatches.DeviceApplicationID' = 'Tekstuele externe applicatiesleutel zonder fysieke FK; in het nieuwe model als echte application/CMDB-relatie modelleren.'
    'DeviceApplicationMatches.DeviceApplicationDomainExpression' = 'Legacy patroonexpressie; nieuwe oplossing wil een expliciete URL-allowlist.'
    'DeviceApplicationMatches.DeviceApplicationProcessnameExpression' = 'Legacy patroonexpressie; nieuwe oplossing wil een expliciete proces-allowlist.'
    'DeviceBrowserLogging.url' = 'Volledige URL kan querystrings, documentnamen of andere gevoelige inhoud bevatten; minimaliseren vóór ingestie.'
    'DeviceLoggingErrors.UAM_Settings' = 'Diagnostische settingsnapshot; voorkom secrets en pas veldniveau-redactie toe.'
    'DeviceLoggingErrors.uam_commandline' = 'Commandline kan paden, parameters of gevoelige waarden bevatten; standaard redigeren.'
    'DeviceLoggingUsers.CsVPath' = 'Verwijst naar de legacy CSV met complete SQL-statements; vervangen door de SQLite-outbox.'
    'DeviceLoggingUsers.LastBrowserEdgeLogDateTime' = 'Browserspecifiek checkpoint; overlapt met het latere geconsolideerde LastBrowserLogDateTime.'
    'DeviceLoggingUsers.LastBrowserFireFoxLogDateTime' = 'Browserspecifiek checkpoint; overlapt met het latere geconsolideerde LastBrowserLogDateTime.'
    'DeviceLoggingUsers.LastBrowserChromeLogDateTime' = 'Browserspecifiek checkpoint; overlapt met het latere geconsolideerde LastBrowserLogDateTime.'
    'DeviceLoggingUsers.LastWindowsProcessesLogDateTime' = 'Ouder taakspecifiek checkpoint; overlapt met LastProcessLogDateTime.'
    'DeviceLoggingUsers.LastRecentFilesLogDateTime' = 'Ouder taakspecifiek checkpoint; overlapt met LastRecentFilesAndFoldersDateTime.'
    'DeviceLoggingUsers.UAMprocessMaxMemoryMB' = 'Legacy self-protection voor de monolithische PowerShell-agent; opnieuw beoordelen voor de kleine C# worker.'
    'DeviceLoggingUsers.UAMprocessLastMemoryMB' = 'Legacy memorytelemetrie; in C# liever gestandaardiseerde metrics/observability.'
    'DeviceScripts.Script_Code' = 'Arbitraire PowerShell-code; hoog risico. Nieuwe taken als ondertekende/versioned plugins met expliciete capabilities.'
    'DeviceScriptSchedules.ExecuteOnTheseDeviceOUs' = 'Gedenormaliseerde lijst; vervangen door een doelgroeptabel.'
    'DeviceScriptSchedules.ExecuteOnTheseDevices' = 'Gedenormaliseerde lijst; vervangen door een doelgroeptabel.'
    'DeviceScriptSchedules.ExecuteNotOnTheseDevices' = 'Gedenormaliseerde lijst; vervangen door een uitsluitingstabel.'
    'uam_log_minimal.LogID' = 'Logische hoofdrecord; productie heeft geen unieke constraint op de natuurlijke combinatie.'
    'uam_log_minimal_dates.LogID' = 'Enige fysiek afgedwongen FK naast DeviceScriptSchedules.Script_GUID.'
}

function Get-CodeReferenceCounts {
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Name
    )
    $escaped = [regex]::Escape($Name)
    $strongPattern = '(?i)\[{0}\]|\.{0}(?![A-Za-z0-9_])|[''"]{0}[''"]' -f $escaped
    $tokenPattern = "(?i)(?<![A-Za-z0-9_])$escaped(?![A-Za-z0-9_])"
    [pscustomobject]@{
        Strong = [regex]::Matches($Source, $strongPattern).Count
        Token = [regex]::Matches($Source, $tokenPattern).Count
    }
}

function Get-SqlTypeDisplay {
    param([Parameter(Mandatory)][object]$Column)
    $type = ([string]$Column.TypeName).ToLowerInvariant()
    switch ($type) {
        { $_ -in @('nvarchar', 'nchar') } {
            $length = if ([int]$Column.MaxLength -eq -1) { 'max' } else { ([int]$Column.MaxLength / 2).ToString('0') }
            return "$type($length)"
        }
        { $_ -in @('varchar', 'char', 'varbinary', 'binary') } {
            $length = if ([int]$Column.MaxLength -eq -1) { 'max' } else { [string][int]$Column.MaxLength }
            return "$type($length)"
        }
        { $_ -in @('decimal', 'numeric') } { return "$type($([int]$Column.Precision),$([int]$Column.Scale))" }
        { $_ -in @('datetime2', 'datetimeoffset', 'time') } { return "$type($([int]$Column.Scale))" }
        default { return $type }
    }
}

function Get-DataSensitivity {
    param([string]$TableName, [string]$ColumnName)
    if ($ColumnName -match '(?i)password|secret|token|settings|commandline|callstack|error|changedfields|script_code') {
        return 'gevoelige diagnostiek/configuratie'
    }
    if ($TableName -match '(?i)Logging|AdUsers|Employments|contracts' -or
        $ColumnName -match '(?i)user|name|mail|phone|address|domain|url|path|computer|employee|manager|department|title|guid|sid') {
        return 'persoons-/gebruiksgegeven'
    }
    return 'intern/configuratie'
}

$dictionary = [System.Collections.Generic.List[object]]::new()
foreach ($column in $metadata) {
    $key = "$($column.TableName).$($column.ColumnName)"
    $columnProfile = $profileByColumn[$key]
    if ($null -eq $columnProfile) { throw "Productieprofiel ontbreekt voor $key" }

    $agentRefs = Get-CodeReferenceCounts -Source $agentSource -Name ([string]$column.ColumnName)
    $devRefs = Get-CodeReferenceCounts -Source $devAppSource -Name ([string]$column.ColumnName)
    $prodRefs = Get-CodeReferenceCounts -Source $prodAppSource -Name ([string]$column.ColumnName)
    $allTokenRefs = $agentRefs.Token + $devRefs.Token + $prodRefs.Token
    $allStrongRefs = $agentRefs.Strong + $devRefs.Strong + $prodRefs.Strong
    $isExternal = $externalTables -contains [string]$column.TableName
    $isPrimaryKeyColumn = [int]$column.PrimaryKeyOrdinal -gt 0
    $isStructural = [bool]$column.IsIdentity -or $isPrimaryKeyColumn -or -not [string]::IsNullOrWhiteSpace([string]$column.ForeignKeyName)
    $totalRows = [long]$columnProfile.TotalRows
    $nonNullRows = [long]$columnProfile.NonNullRows
    $fillPercent = if ($totalRows -eq 0) { $null } else { [Math]::Round(($nonNullRows * 100.0) / $totalRows, 2) }

    [string]$assessment = ''
    [string]$recommendation = ''
    [string]$evidenceNote = ''
    if ($isExternal) {
        $assessment = 'extern bronveld'
        $recommendation = 'broncontract configureren'
        $evidenceNote = 'Niet als UAM-eigendom beoordelen; alleen projecteren wat de module werkelijk nodig heeft.'
    }
    elseif ($isStructural) {
        $assessment = 'structureel'
        $recommendation = 'behouden/hermodelleren'
        $evidenceNote = 'Onderdeel van identity-, primary-key- of foreign-keystructuur.'
    }
    elseif ($allTokenRefs -gt 0) {
        $assessment = if ($nonNullRows -eq 0 -and $totalRows -gt 0) { 'codegebruik, productie leeg' } else { 'actief in code' }
        $recommendation = 'migreren na semantische controle'
        $evidenceNote = "Exacte codetokens: agent=$($agentRefs.Token), DEV-app=$($devRefs.Token), PROD-app=$($prodRefs.Token)."
    }
    elseif ($totalRows -eq 0 -and $activeDetailTables -contains [string]$column.TableName) {
        $assessment = 'actief schema, nu leeg'
        $recommendation = 'behouden via taakcontract'
        $evidenceNote = 'De actieve detailtabel is door archivering leeg; beoordeel samen met de archieftabel.'
    }
    elseif ($totalRows -eq 0) {
        $assessment = 'onvoldoende productiegegevens'
        $recommendation = 'handmatig verifiëren'
        $evidenceNote = 'De tabel bevat geen productierijen; leegte bewijst geen ongebruik.'
    }
    elseif ($nonNullRows -eq 0) {
        $assessment = 'kandidaat vervallen'
        $recommendation = 'review vóór verwijderen'
        $evidenceNote = 'In productie nooit gevuld en geen exacte codeverwijzing aangetroffen.'
    }
    else {
        $assessment = 'data aanwezig, codegebruik niet aangetroffen'
        $recommendation = 'herkomst/consument verifiëren'
        $evidenceNote = 'Productiedata aanwezig; dynamisch SQL of een externe consument kan statische codezoeking omzeilen.'
    }

    $manualNote = [string]$manualFieldNotes[$key]
    $note = @($manualNote, $evidenceNote) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $keyRole = @()
    if ([bool]$column.IsIdentity) { $keyRole += 'IDENTITY' }
    if ($isPrimaryKeyColumn) { $keyRole += "PK($([int]$column.PrimaryKeyOrdinal))" }
    if (-not [string]::IsNullOrWhiteSpace([string]$column.ForeignKeyName)) { $keyRole += "FK->$($column.ForeignTable).$($column.ForeignColumn)" }

    $dictionary.Add([pscustomobject][ordered]@{
        TableName = [string]$column.TableName
        TablePurpose = [string]$tableDescriptions[[string]$column.TableName]
        Ownership = if ($isExternal) { 'External source contract' } else { 'Legacy UAM' }
        ColumnOrdinal = [int]$column.ColumnOrdinal
        ColumnName = [string]$column.ColumnName
        SqlType = Get-SqlTypeDisplay -Column $column
        Nullable = [bool]$column.IsNullable
        KeyRole = ($keyRole -join '; ')
        DefaultDefinition = [string]$column.DefaultDefinition
        IndexNames = [string]$column.IndexNames
        ProductionRows = $totalRows
        ProductionNonNullRows = $nonNullRows
        ProductionFillPercent = $fillPercent
        AgentStrongReferences = [int]$agentRefs.Strong
        AgentTokenReferences = [int]$agentRefs.Token
        DevAppStrongReferences = [int]$devRefs.Strong
        DevAppTokenReferences = [int]$devRefs.Token
        ProdAppStrongReferences = [int]$prodRefs.Strong
        ProdAppTokenReferences = [int]$prodRefs.Token
        AllStrongReferences = [int]$allStrongRefs
        AllTokenReferences = [int]$allTokenRefs
        DataSensitivity = Get-DataSensitivity -TableName ([string]$column.TableName) -ColumnName ([string]$column.ColumnName)
        Assessment = $assessment
        MigrationRecommendation = $recommendation
        Note = ($note -join ' ')
    })
}

$jsonPath = Join-Path $DatabaseOutputRoot '04_legacy_uam_data_dictionary.json'
$csvPath = Join-Path $DatabaseOutputRoot '04_legacy_uam_data_dictionary.csv'
$markdownPath = Join-Path $DocumentationOutputRoot 'legacy-data-dictionary.md'
[System.IO.File]::WriteAllText($jsonPath, ($dictionary | ConvertTo-Json -Depth 6), [System.Text.UTF8Encoding]::new($false))
$dictionary | Export-Csv -LiteralPath $csvPath -NoTypeInformation -Encoding utf8

function ConvertTo-MarkdownCell {
    param([AllowNull()][object]$Value)
    if ($null -eq $Value) { return '' }
    ([string]$Value).Replace('|', '\|').Replace("`r", '').Replace("`n", '<br>')
}

$candidateCount = @($dictionary | Where-Object Assessment -eq 'kandidaat vervallen').Count
$markdown = [System.Text.StringBuilder]::new()
[void]$markdown.AppendLine('# Legacy UAM data dictionary')
[void]$markdown.AppendLine()
[void]$markdown.AppendLine('Deze appendix is gegenereerd uit het productie-DDL, een read-only productieprofiel en statische codezoeking in `uam.ps1`, de DEV-app en de productie-app.')
[void]$markdown.AppendLine()
[void]$markdown.AppendLine("- Tabellen: $(@($dictionary.TableName | Sort-Object -Unique).Count)")
[void]$markdown.AppendLine("- Velden: $($dictionary.Count)")
[void]$markdown.AppendLine("- Voor review gemarkeerde velden: $candidateCount")
[void]$markdown.AppendLine('- Productieprofiel: `COUNT_BIG(*)` en non-null-aantallen met `NOLOCK`; er zijn geen veldwaarden geëxporteerd.')
[void]$markdown.AppendLine('- Codegebruik is een lexicale indicatie. Dynamisch SQL, `Invoke-Expression` en externe consumenten kunnen niet altijd statisch worden bewezen.')
[void]$markdown.AppendLine('- `kandidaat vervallen` betekent: niet gevuld én niet in de drie onderzochte codebases aangetroffen. Het is geen automatisch verwijderadvies.')
[void]$markdown.AppendLine()
[void]$markdown.AppendLine('De volledige machineleesbare details, inclusief afzonderlijke sterke/tokenreferentietellingen, staan in `artifacts/database/04_legacy_uam_data_dictionary.csv` en `.json`.')

foreach ($tableGroup in @($dictionary | Group-Object TableName | Sort-Object Name)) {
    $tableName = [string]$tableGroup.Name
    $rows = @($tableGroup.Group | Sort-Object ColumnOrdinal)
    $inventoryItem = $inventoryByTable[$tableName]
    [void]$markdown.AppendLine()
    [void]$markdown.AppendLine("## $tableName")
    [void]$markdown.AppendLine()
    [void]$markdown.AppendLine([string]$tableDescriptions[$tableName])
    [void]$markdown.AppendLine()
    [void]$markdown.AppendLine("Productie: $([long]$rows[0].ProductionRows) rijen; $([Math]::Round([double]$inventoryItem.ReservedMB, 2)) MB gereserveerd. Eigendom: $($rows[0].Ownership).")
    [void]$markdown.AppendLine()
    [void]$markdown.AppendLine('| # | Veld | Type | Null | Sleutel | Vulling | Codegebruik | Beoordeling | Opmerking |')
    [void]$markdown.AppendLine('| ---: | --- | --- | :---: | --- | ---: | --- | --- | --- |')
    foreach ($row in $rows) {
        $fill = if ($null -eq $row.ProductionFillPercent) { 'n.v.t.' } else { "$($row.ProductionFillPercent)%" }
        $usage = "agent $($row.AgentTokenReferences); DEV $($row.DevAppTokenReferences); PROD $($row.ProdAppTokenReferences)"
        $values = @(
            $row.ColumnOrdinal,
            $row.ColumnName,
            $row.SqlType,
            $(if ($row.Nullable) { 'ja' } else { 'nee' }),
            $row.KeyRole,
            $fill,
            $usage,
            $row.Assessment,
            $row.Note
        ) | ForEach-Object { ConvertTo-MarkdownCell $_ }
        [void]$markdown.AppendLine('| ' + ($values -join ' | ') + ' |')
    }
}

[System.IO.File]::WriteAllText($markdownPath, $markdown.ToString(), [System.Text.UTF8Encoding]::new($false))

[pscustomobject]@{
    Tables = @($dictionary.TableName | Sort-Object -Unique).Count
    Fields = $dictionary.Count
    CandidateForRetirement = $candidateCount
    Json = $jsonPath
    Csv = $csvPath
    Markdown = $markdownPath
}
