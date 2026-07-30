# UAM PSU-app walkthrough — transcript

De video is stil en bevat alle toelichting in beeld. Deze tekst is dezelfde inhoud in machineleesbare vorm.

## 1. UAM PSU-app — DEV walkthrough

- Huidige UAM Activity Monitor
- Read-only vastlegging
- Privacygemaskeerde schermgegevens
- Geen schrijf-, export- of uitvoeracties

## 2. Veilige opnamewijze

- Omgeving: lokale DEV-app
- Alleen tabs, zoeken/filteren, sorteren en pagineren
- Tabelrijen, invoerwaarden, canvas- en accountlabels gemaskeerd
- PROD vereist nog een handmatige browserlogin

## 3. Logging Users

- Beheer van de populatie die voor logging in aanmerking komt
- Status en selectie worden in gebruikers-/apparaatstate bijgehouden
- Muterende knoppen zijn tijdens de documentatieronde niet bediend

## 4. Logging Users — read-only filter

- Voorbeeld van een tijdelijke zoek-/filteractie
- De testwaarde is na de opname weer verwijderd
- Geen record is toegevoegd of gewijzigd

## 5. User Grids

- Rasterweergave voor gebruikers- en apparaatselectie
- Natuurlijke sleutels bestaan uit gebruikersnaam, domein en computer
- Het doelmodel vraagt om stabiele identity keys en typed policies

## 6. Organogram

- Organisatiegerichte selectie vanuit HR-/AD-gegevens
- Legacy gebruikt klantgebonden bronstructuren
- Doel: smalle configureerbare HR-/AD-views met een versiecontract

## 7. Logging Data

- Inzage in browser-, proces- en recente-itemlogging
- Detailgegevens en minimal logging bestaan naast elkaar
- Retentie, privacy en aggregatie moeten in het doelmodel expliciet worden

## 8. Device Scripts & Schedules

- Beheergebied voor device types, scripts, planningen en referentiedata
- Het legacy taakmodel is slechts gedeeltelijk uitgewerkt
- Doel: alle collectors als getekende, versieerbare tasks met timeouts en isolatie

## 9. UAM Settings — Global Settings

- Globale runtime-instellingen voor de agent
- Legacywaarden zijn grotendeels tekstueel en worden bij start geladen
- Doel: typed, versioned policy plus lokaal gevalideerd SQLite-snapshot

## 10. Process Exclusions

- Legacy denylist voor processen en paden
- Nieuwe richting: procesallowlist met pad, publisher en applicatiesleutel
- Dataminimalisatie gebeurt vóór buffering en transport

## 11. Browser Logging Exclusions

- Legacy uitsluitingen voor browserlogging
- Brede URL-verzameling levert te veel data op
- Nieuwe richting: URL-allowlist direct gekoppeld aan Application Registry/CMDB

## 12. Application Matches

- Domein- en procesexpressies worden aan een applicatie-ID gekoppeld
- De huidige koppeling is tekstueel en heeft geen fysieke FK
- Doel: revisioned matchregels met een echte applicatiesleutel

## 13. Errors

- Inzage in technische agentfouten en context
- Legacy bewaart veel foutinformatie maar redactie is niet overal uniform
- Doel: structured logging, correlation IDs, privacyredactie en OpenTelemetry

## 14. Audit Log

- Beheerwijzigingen worden als polymorfe audit vastgelegd
- TableName plus RecordID kan geen referential integrity afdwingen
- Doel: immutable audit events via één geautoriseerde control-plane API

## 15. Van IST naar C# doelarchitectuur

- Kleine bootstrapper en .NET Worker Service
- SQLite transactional outbox en geïsoleerde taskpackages
- HTTPS ingestion API, duurzame queue en PostgreSQL
- Modern beheerportaal met typed policies, RBAC en audit

