# UAM IST in een oogopslag

**Doel van dit blad:** in circa één A4 begrijpen wat de huidige UAM-oplossing doet, hoe zij technisch is opgebouwd en waar de belangrijkste overdrachtsrisico's zitten.

## Wat draait er nu?

De endpointagent is een PowerShell-script van **4.805 regels** dat met PS2EXE als `uam.exe` zonder console wordt uitgevoerd. Voor debugging bestaat een consolevariant. Naast de executable is `dbsettings.txt` nodig; daarin staat de MSSQL-connectieroute versleuteld. Tijdens de start haalt de agent globale instellingen, eventuele gebruikersafwijkingen, filters en eerder opgeslagen checkpoints uit de database.

De agent voert hoofdzakelijk drie collectors uit: **browserhistorie**, **Windows Recent/Quick Access** en **Windows-processen**. Hij controleert per collector of deze actief is en opnieuw moet draaien, verzamelt gegevens, maakt detail- en minimale logging en actualiseert checkpoints. SQL-statements worden eerst in geheugen en CSV gebufferd en daarna transactiewijs rechtstreeks naar MSSQL verstuurd. Bij verbindingsproblemen wordt de CSV-buffer bij een volgende start hersteld.

## Huidige componenten en gegevens

| Onderdeel | IST |
| --- | --- |
| Endpoint | `uam.exe`, gecompileerde PowerShell; orchestratie, collectors, buffering en SQL in één proces. |
| Lokale configuratie | `dbsettings.txt`; nog geen centrale lokale settingsdatabase. |
| Centrale database | 27 tabellen, 569 velden, 13 primary keys, slechts 2 fysieke foreign keys. |
| Grootste historie | `DeviceBrowserLogging_Archive`: circa 2,47 miljoen rijen op het meetmoment. |
| Beheerportaal | PowerShell Universal-app voor gebruikersselectie, loggingdata, settings, uitsluitingen, applicatiematches, taken/planningen, errors en audit. |
| Bronnen | UAM-tabellen plus klantgebonden HR-/AD-structuren; veel relaties bestaan alleen impliciet in code en SQL. |

## Wat is waardevol en moet behouden blijven?

- Checkpoints per collector, deferred verwerking en herstel na tijdelijke storingen.
- Browser-tijdconversies, profiel-/bestandsstabiliteitscontroles en normalisatie van legacy settings.
- Een compacte minimale gebruiksregistratie naast detailgegevens.
- Doelgroep- en gebruikersafwijkingen, uitsluitingen/matches, foutcontext en auditinformatie.
- De bestaande functionele indeling van het PSU-portaal als vertrekpunt voor het nieuwe beheerportaal.

## Belangrijkste knelpunten

- Eén groot proces combineert hosting, scheduling, collectors, SQL, foutafhandeling en self-restart.
- Endpoints schrijven direct naar MSSQL; de CSV bevat complete SQL-statements en is geen robuuste transactional outbox.
- Veel tekstkoppelingen, ontbrekende foreign keys en klantafhankelijke HR-/AD-tabellen maken wijziging en hergebruik lastig.
- Dubbele functies, dynamische SQL, handmatige garbage collection en een aangetroffen hardcoded `$Pwd` vragen om expliciete sanering; het geheim wordt niet meegeleverd.
- Het taken-/planningsdeel is functioneel nog niet af en arbitraire scripts vereisen strengere isolatie en autorisatie.

**Bewijsstand:** legacy agent, productie-DDL, rij-/veldprofielen, data dictionary en DEV-portaalschermen zijn vastgelegd. De laatste geautomatiseerde DEV-heropname en de PROD-browseropname vereisen nog een geldige handmatige PSU-login; bestaande DEV-beelden zijn privacygemaskeerd en uitsluitend via leesacties verkregen.
