# UAM legacy overdracht — eerst lezen

**Classificatie:** intern technisch overdrachtsmateriaal  
**Versie:** 1.0 — 23 juli 2026

Dit pakket is de complete overdrachtsset voor de legacy PowerShell-agent
`uam.ps1`, het bijbehorende datamodel, de PowerShell Universal-beheerapp en de
voorgestelde vervanging in C#.

## Snel beginnen

1. Lees `deliverables/pdf/UAM-IST-samenvatting-A4.pdf`.
2. Lees `deliverables/pdf/UAM-doelbeeld-samenvatting-A4.pdf`.
3. Gebruik daarna `UAM-legacy-overdrachtsdossier.pdf` voor de agent en migratie.
4. Open `UAM-databasemodel-en-data-dictionary.pdf` voor het volledige model en
   alle 569 velden.
5. Bekijk `deliverables/video/UAM-PSU-app-walkthrough.mp4` voor de huidige
   beheerapp.

## Inhoud

- `docs`: bewerkbare Nederlandstalige Markdown-bronnen;
- `deliverables/pdf`: vijf PDF-einddocumenten;
- `deliverables/video`: MP4, bewerkbare PowerPoint, transcript en ondertiteling;
- `deliverables/html`: toegankelijke HTML-bronnen van de PDF's;
- `sources/legacy/uam.redacted.ps1`: complete legacy-agent met één geredigeerd
  hardcoded wachtwoord;
- `uam-logging.ps1`: DEV-bron van de huidige PSU-app;
- `artifacts/database`: DDL, data dictionary, productieprofiel,
  referentieconfiguratie en gesaniteerde samples;
- `artifacts/diagrams`: echte SVG- en PNG-diagrammen;
- `artifacts/screenshots`: gemaskeerde DEV-beelden en opname-manifests;
- `scripts`: herhaalbare generatie-, installatie- en opnamescripts;
- `manifest`: bestandenlijst, SHA-256-hashes en eindvalidatie van deze ZIP.

## Beveiliging en vertrouwelijkheid

De originele agent bevatte op regel 1384 een hardcoded `$Pwd`. Alleen die
waarde is in de meegeleverde bronkopie vervangen door een REDACTED-placeholder.
De originele SHA-256 staat in `sources/legacy/README.md`; het oorspronkelijke geheim
wordt niet meegeleverd.

`artifacts/database/02_legacy_uam_reference_data.sql` bevat echte interne
URL-/applicatieconfiguratie. Deel het pakket daarom niet buiten de organisatie
zonder inhoudelijke security-/privacyreview. De SQL-artifacts bevatten geen
`GO` en geen `USE [IAM]`, maar voer ze desondanks alleen via de begrensde
documentatie-installer uit. Gebruik voor de geïsoleerde installatie uitsluitend
`scripts/Install-LegacyUamDocumentationSchema.ps1`; die staat alleen `IAMDEV`
toe en schrijft naar een afgescheiden schema.

Er zijn geen app-tokens, wachtwoorden, cookies, browserprofielen of onbewerkte
productie-appbronnen in het pakket opgenomen.

## Browserbewijs

De 20 DEV-schermafdrukken zijn 1920×1080, privacygemaskeerd en verkregen met
alleen tabnavigatie, zoeken/filteren, sorteren en pagineren. Muterende acties
zijn niet gebruikt. De laatste automatische heropname werd door de PSU-login
geblokkeerd; het dossier en de video gebruiken daarom de bestaande bewezen
DEV-set. Een actuele PROD-opname vereist nog een eenmalige handmatige login.
