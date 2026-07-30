# Legacy UAM database artifacts

## Bestanden

| Bestand | Inhoud |
| --- | --- |
| `00_legacy_uam_prod_inventory.json/.csv` | Productietabellen, rijtellingen, omvang en fysieke objectcounts. |
| `00_legacy_uam_prod_column_profile.json` | Per veld alleen productie total/non-null counts; geen waarden. |
| `00_legacy_uam_schema_metadata.json` | Datatype, nullability, default, identity, PK/FK en indexmembership uit `IAMDEV.uam_legacy_doc`. |
| `01_legacy_uam_prod_schema.sql` | Productie-DDL van 27 tabellen; geen `GO`. |
| `02_legacy_uam_reference_data.sql` | 4.658 echte referentie-/configuratie-inserts. Intern vertrouwelijk. |
| `03_legacy_uam_sanitized_samples.sql` | 233 gepseudonimiseerde operationele voorbeelden. |
| `04_legacy_uam_data_dictionary.csv/.json` | 569 velden met model-, productie-, codegebruik-, privacy- en migratiekenmerken. |

## Productiedata in de insertbestanden

Volledig opgenomen omdat de tabellen relatief klein/configuratief zijn:

- `DeviceApplicationMatches`;
- `DeviceBrowserLogging2Exclude`;
- `DeviceLoggingSettings`;
- `DeviceProcess2Exclude`;
- `DeviceTypes`;
- `DeviceScripts`;
- `DeviceScriptSchedules`;
- `SystemLookups`.

Operationele/logtabellen bevatten maximaal 25 gesaniteerde voorbeelden; `DeviceLoggingUserSettings` bevat de 8 aanwezige overrides in gepseudonimiseerde vorm.

`02_legacy_uam_reference_data.sql` bevat echte interne URL-/applicatieconfiguratie. Niet extern publiceren zonder review.

De drie SQL-artifacts bevatten geen `GO` en geen `USE [IAM]`. De uitvoerende installer bepaalt zelf uitsluitend de expliciet toegestane IAMDEV-database en het afgescheiden schema.

## IAMDEV-installatie

De artifacts zijn geïnstalleerd in:

```text
GGWVSQLa002 / IAMDEV / uam_legacy_doc
```

Uitgevoerd via de PSU-runtime met:

```powershell
.\scripts\Install-LegacyUamDocumentationSchema.ps1 `
    -SqlInstance GGWVSQLa002 `
    -Database IAMDEV `
    -Schema uam_legacy_doc `
    -Confirm:$false
```

Veiligheidskenmerken:

- databaseparameter accepteert alleen exact `IAMDEV`;
- doelschema is afgescheiden van `dbo`;
- bestaande tabellen worden nooit overschreven;
- installatie is één transactie;
- geen `DROP`, `TRUNCATE` of productiewrite;
- referentie- en sampledata kunnen afzonderlijk worden uitgeschakeld.

Verificatie na installatie:

| Metric | Waarde |
| --- | ---: |
| Tabellen | 27 |
| Velden | 569 |
| Primary keys | 13 |
| Foreign keys | 2 |
| Indexen | 15 |
| Referentieregels | 4.658 |
| Gesaniteerde samples | 233 |
| Totaal | 4.891 |

## Regenereren data dictionary

`scripts/New-LegacyUamDataDictionary.ps1` combineert metadata, productieprofiel en broncodehits. De productie-appbron wordt bij uitvoering alleen tijdelijk geladen en niet als artifact opgeslagen.

De beoordeling `kandidaat vervallen` is bewust streng en blijft een reviewstatus. Dynamisch SQL, externe rapporten en ad-hoc consumers kunnen statische codeanalyse omzeilen.
