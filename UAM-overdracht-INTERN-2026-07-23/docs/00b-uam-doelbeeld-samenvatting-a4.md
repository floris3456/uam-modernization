# UAM gewenst doelbeeld in een oogopslag

**Doel van dit blad:** in circa één A4 begrijpen hoe de gewenste C#-oplossing eruitziet en welke ontwerpkeuzes de legacyproblemen oplossen.

## Kern van het doelbeeld

De nieuwe UAM wordt geen één-op-één vertaling van PowerShell naar C#. Er komt een kleine, ondertekende **`uam.exe` bootstrapper** die controleert of de gewenste agentversie aanwezig is, pakketten veilig installeert, atomair wisselt en kan terugrollen. **`uam-agent.exe`** wordt een .NET Worker Service die alleen policy, planning, gezondheid en taakcoördinatie verzorgt.

Collectors worden afzonderlijke, versieerbare taskpackages: Browser History, Recent Items/Quick Access, Process Inventory en Browser Extensions. Eenvoudige volledig managed taken kunnen tijdelijk in een collectible `AssemblyLoadContext` draaien. Taken met native dependencies, PowerShell of een groter storings-/geheugenrisico draaien geïsoleerd in **`uam-taskhost.exe`**, zodat afsluiten aantoonbaar geheugen vrijmaakt.

## Gewenste componenten en gegevensstroom

| Onderdeel | Doelbeeld |
| --- | --- |
| Lokale opslag | SQLite in WAL-modus voor settingssnapshot, gebruikersafwijkingen, taskstate, checkpoints en transactional outbox. |
| Upload | Kleine idempotente HTTPS-batches, gecomprimeerd met gzip, met retries, jitter en backpressure. |
| Centrale verwerking | Ingestion API → duurzame queue → schaalbare workers; endpoints krijgen nooit directe databasetoegang. |
| Centrale database | PostgreSQL met partitionering als voorkeursbasis; TimescaleDB pas kiezen na een representatieve benchmark. |
| Beheer | Moderne adminportal via een control-plane API, typed policyrevisies, capability-RBAC en volledige audit. |
| Integraties | Configureerbare HR-/AD-views/adapters en een interne Application Registry met optionele FK naar de echte CMDB. |

## Functionele richting

- Maak **alles een taak** met een expliciet contract, versie, schedule, timeout, privacyclassificatie en uitvoerformaat.
- Vervang brede logging door configureerbare **URL- en procesallowlists**, rechtstreeks gekoppeld aan een applicatiesleutel uit de Application Registry/CMDB.
- Maak globale instellingen en afwijkingen typed, versioned en centraal publiceerbaar; de agent gebruikt een lokaal gevalideerd snapshot.
- Voeg structured logging, correlatie-ID's, OpenTelemetry en instelbare diagnostiek toe, tijdelijk en gericht per gebruiker/apparaat.
- Bouw privacy, minimale gegevensverwerking, retentie, redactie van secrets/PII en veilige standaardwaarden in het ontwerp in.

## Schaal en betrouwbaarheid

Ontwerp en test voor minimaal **6.000 gebruikers** en gelijktijdige pieken. De SQLite-outbox voorkomt dat metingen verloren gaan; idempotency voorkomt dubbele verwerking; queue en workers vlakken pieken af. Meet batchgrootte, compressie, wachtrijduur, database-inserts, storagegroei en herstel na langdurige uitval voordat een database-extensie of cloudproduct wordt gekozen.

## Aanbevolen migratievolgorde

1. Leg gedrag, privacybeleid, eventcontracten en acceptatiematen vast.
2. Bouw bootstrapper, Worker Service, SQLite/outbox en package signing.
3. Lever Browser History als eerste verticale slice van endpoint tot portal.
4. Voeg overige collectors en geïsoleerde taskhost toe.
5. Bewijs schaal, retentie en herstel; bouw daarna het beheerportaal uit.
6. Draai een gecontroleerde parallelle pilot, migreer alleen bruikbare configuratie en bouw legacy daarna gefaseerd af.

**Beoogd resultaat:** een kleine en herstelbare endpointagent, een portable/open platform waar mogelijk, een aantoonbaar schaalbare ingestieketen en een sneller, veiliger en beter configureerbaar beheerportaal.
