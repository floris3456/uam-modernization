# UAM legacy overdracht

Dit dossier beschrijft de overdracht van de PowerShell-agent `uam.ps1`, het legacy SQL-model en de PowerShell Universal-beheerapp. Het bevat daarnaast een doelarchitectuur en migratiepad voor een nieuwe C#-implementatie.

## Eindproducten

- twee korte A4-PDF's voor IST en gewenst doelbeeld;
- drie uitgebreide PDF's voor het overdrachtsdossier, datamodel/data dictionary en de PSU-app IST;
- een MP4-walkthrough met bewerkbare PowerPoint, `.srt` en transcript;
- alle Markdown-, SVG/PNG-, CSV/JSON-, SQL- en PowerShell-bronnen;
- een SHA-256-manifest en geautomatiseerd validatierapport in de definitieve interne ZIP.

## Leesvolgorde

1. [UAM IST in een oogopslag](00a-uam-ist-samenvatting-a4.md)
2. [UAM gewenst doelbeeld in een oogopslag](00b-uam-doelbeeld-samenvatting-a4.md)
3. [Legacy agent `uam.ps1`](01-legacy-agent-uam-ps1.md)
4. [Legacy databasemodel](02-legacy-database-model.md)
5. [PSU-app IST](03-psu-app-ist.md)
6. [C# doelarchitectuur](04-csharp-target-architecture.md)
7. [Migratiekaart en roadmap](05-migration-map-roadmap.md)
8. [Data dictionary per tabel en veld](appendices/legacy-data-dictionary.md)

De databasebestanden en herstelscripts staan in [artifacts/database](../artifacts/database/README.md). De privacygemaskeerde DEV-schermafdrukken staan onder `artifacts/screenshots/dev`; de native SVG- en PNG-diagrammen staan onder `artifacts/diagrams`.

De verzendbare einddocumenten staan onder `deliverables/pdf`. Het tekstgestuurde
walkthroughfilmpje, de bewerkbare PowerPoint, het transcript en de ondertiteling
staan onder `deliverables/video`. Begin bij `README-OVERDRACHT.md` in de
projectroot voor de inhoud, leesvolgorde en beveiligingswaarschuwingen.

## Bronfixatie

| Onderdeel | Bron | Omvang | SHA-256 |
| --- | --- | ---: | --- |
| Legacy agent | `H:\Mijn Documenten\UAM\V0.7\uam.ps1` | 4.805 regels / 240.072 bytes | `44F7CBDB53C5A0100D30B531F1AC478E186EDBB744EEC06BA2A5DA4B699A2B94` |
| DEV PSU-app | `uam-logging.ps1` | 1.217 regels / 105.434 bytes | `FB9BCDB8AE9653FBBD7CCE00432C97197A31503CD0EA57FD3366D0DE809B2176` |
| PROD PSU-app | PSU-app `User Activity Monitor`, route `/UAM` | 2.758 regels / 216.757 tekens | `E1774499D04E1CD3F5AE5E1A8E4C53C2077B36399C0DA0A7274587ABCB056804` |
| Productie-DDL | `01_legacy_uam_prod_schema.sql` | 27 tabellen / 52.523 bytes | `2DCFC2009D3A09B7E56DB4BE2BC8DB611F6832C121DB17987DF140EACD1A3C63` |

De agentbron parseert zonder PowerShell-syntaxfouten. Het bestand bevat 53 functiedefinities; `Manage-LogRotation` en `ErrorHandler` komen elk tweemaal voor.

## Geleverde databasekopie

Het legacy model is geïsoleerd geïnstalleerd in:

```text
GGWVSQLa002 / IAMDEV / schema uam_legacy_doc
```

De installatie bevat 27 tabellen, 569 velden, 13 primary keys, 2 foreign keys, 15 indexen en 4.891 records. Daarvan zijn 4.658 echte referentie-/configuratieregels en 233 gesaniteerde voorbeeldrecords. Bestaande `dbo`-tabellen in IAMDEV zijn niet gewijzigd.

## Status schermafdrukken

De DEV-app is geauthenticeerd en read-only doorlopen. Operationele tabelrijen, invoervelden, canvaslabels en accountlabels zijn vóór iedere opname visueel gemaskeerd. Gewone actieknoppen zoals Toevoegen, Wijzigen, Verwijderen, Exporteren of het starten van scripts zijn niet bediend.

De productiebron en productieconfiguratie zijn via de app-token geanalyseerd. Productieschermafdrukken ontbreken nog: de lokale DEV-adminreferenties worden door productie terecht geweigerd en de app-token kan geen browsercookie maken. Voor een nieuwe opname is één handmatige interactieve productie-login in het geopende tijdelijke Chrome-profiel nodig; wachtwoorden horen niet in chat, scripts of artifacts.

## Vertrouwelijkheid

`02_legacy_uam_reference_data.sql` bevat echte interne configuratie, waaronder applicatie-/URL-patronen. Publiceer dit bestand niet buiten de organisatie zonder inhoudelijke review. De operationele samples zijn gepseudonimiseerd, maar blijven uitsluitend bedoeld als technisch overdrachtsmateriaal.
