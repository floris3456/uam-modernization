[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter()]
    [string]$SqlInstance = 'GGWVSQLa002',

    [Parameter()]
    [ValidateSet('IAMDEV')]
    [string]$Database = 'IAMDEV',

    [Parameter()]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9_]{0,127}$')]
    [string]$Schema = 'uam_legacy_doc',

    [Parameter()]
    [bool]$IncludeReferenceData = $true,

    [Parameter()]
    [bool]$IncludeSanitizedSamples = $true,

    [Parameter(DontShow)]
    [ValidateRange(0, 1000000)]
    [int]$DiagnosticSqlLineNumber = 0
)

$ErrorActionPreference = 'Stop'

if ($Database -cne 'IAMDEV') {
    throw "Deze installer mag uitsluitend naar IAMDEV schrijven; ontvangen: '$Database'."
}

$repositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$databaseArtifactRoot = Join-Path $repositoryRoot 'artifacts\database'
$schemaPath = Join-Path $databaseArtifactRoot '01_legacy_uam_prod_schema.sql'
$referenceDataPath = Join-Path $databaseArtifactRoot '02_legacy_uam_reference_data.sql'
$sampleDataPath = Join-Path $databaseArtifactRoot '03_legacy_uam_sanitized_samples.sql'

foreach ($requiredPath in @($schemaPath, $referenceDataPath, $sampleDataPath)) {
    if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
        throw "Verplicht database-artifact ontbreekt: $requiredPath"
    }
}

if (-not (Get-Command Invoke-SqlQuery -ErrorAction SilentlyContinue)) {
    $modulePath = 'C:\ProgramData\UniversalAutomation\Repository\Modules\PSU_DD_Apps\1.0.0\PSU_DD_Apps.psd1'
    if (Test-Path -LiteralPath $modulePath) {
        Import-Module $modulePath -Force -ErrorAction Stop
    }
    else {
        Import-Module PSU_DD_Apps -Force -ErrorAction Stop
    }
}

if (-not (Get-Command Invoke-SqlQuery -ErrorAction SilentlyContinue)) {
    throw 'Invoke-SqlQuery is niet beschikbaar. Voer deze installer uit in de bedoelde PSU-runtime.'
}

function ConvertTo-IsolatedLegacySql {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$TargetSchema
    )

    $sql = Get-Content -Raw -LiteralPath $Path
    $sql = [regex]::Replace(
        $sql,
        '(?im)^\s*USE\s+\[IAM\]\s*;?\s*$',
        '-- USE [IAM] verwijderd door de IAMDEV-installer.'
    )
    $sql = $sql.Replace('[dbo].', "[$TargetSchema].")
    return $sql
}

$schemaSql = ConvertTo-IsolatedLegacySql -Path $schemaPath -TargetSchema $Schema
$referenceSql = if ($IncludeReferenceData) {
    ConvertTo-IsolatedLegacySql -Path $referenceDataPath -TargetSchema $Schema
}
else {
    '-- Referentiegegevens zijn op verzoek overgeslagen.'
}
$sampleSql = if ($IncludeSanitizedSamples) {
    ConvertTo-IsolatedLegacySql -Path $sampleDataPath -TargetSchema $Schema
}
else {
    '-- Gesaniteerde voorbeeldrecords zijn op verzoek overgeslagen.'
}

$quotedSchema = "[$Schema]"
$schemaLiteral = $Schema.Replace("'", "''")
$databaseLiteral = $Database.Replace("'", "''")

$installSql = @"
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF DB_NAME() <> N'$databaseLiteral'
    THROW 51000, 'Veiligheidscontrole mislukt: de actieve database is niet IAMDEV.', 1;

IF SCHEMA_ID(N'$schemaLiteral') IS NOT NULL
   AND EXISTS (
       SELECT 1
       FROM sys.tables
       WHERE schema_id = SCHEMA_ID(N'$schemaLiteral')
   )
    THROW 51001, 'Doelschema bevat al tabellen; de installer overschrijft niets.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF SCHEMA_ID(N'$schemaLiteral') IS NULL
        EXEC(N'CREATE SCHEMA $quotedSchema AUTHORIZATION [dbo];');

$schemaSql

$referenceSql

$sampleSql

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

SELECT
    DatabaseName = DB_NAME(),
    SchemaName = N'$schemaLiteral',
    TableCount = COUNT_BIG(*),
    InstalledAtUtc = SYSUTCDATETIME()
FROM sys.tables
WHERE schema_id = SCHEMA_ID(N'$schemaLiteral');
"@

if ($DiagnosticSqlLineNumber -gt 0) {
    $sqlLines = @($installSql -split "`r?`n")
    $firstLine = [Math]::Max(1, $DiagnosticSqlLineNumber - 3)
    $lastLine = [Math]::Min($sqlLines.Count, $DiagnosticSqlLineNumber + 3)
    for ($lineNumber = $firstLine; $lineNumber -le $lastLine; $lineNumber++) {
        [pscustomobject]@{
            LineNumber = $lineNumber
            Text = $sqlLines[$lineNumber - 1]
        }
    }
    return
}

$target = "$SqlInstance/$Database/$Schema"
if (-not $PSCmdlet.ShouldProcess($target, 'Legacy UAM-documentatieschema en geselecteerde data atomisch installeren')) {
    return
}

Invoke-SqlQuery `
    -SQLInstance $SqlInstance `
    -Database $Database `
    -Query $installSql `
    -ErrorAction Stop
