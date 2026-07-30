# Migratiekaart en roadmap

## Legacy naar doelcomponent

| Legacy | Nieuwe verantwoordelijkheid | Migratievorm |
| --- | --- | --- |
| PS2EXE `UAM.exe` | `uam.exe` bootstrapper + Windows Service `uam-agent.exe` | Nieuwe implementatie; legacy alleen als gedragsspecificatie. |
| `Invoke-PreStart` | bootstrap/install/policy initialization | Opsplitsen in idempotente lifecyclestappen. |
| `Start-Logging` | scheduler + task orchestrator | Nieuwe state machine. |
| Browserfuncties | `Uam.Task.BrowserHistory` | Vertical slice als eerste collector. |
| Recent-itemfuncties | `Uam.Task.RecentItems` | Privacybeleid vóór eventwrite. |
| Procesfuncties | `Uam.Task.ProcessInventory` | Allowlist/publisher matching. |
| Browserextensiewens | `Uam.Task.BrowserExtensions` | Aparte incidentele/periodieke plugin. |
| `DeviceLoggingSettings` | centrale typed policy + lokale snapshot | Migreren met schema/revision. |
| `DeviceLoggingUserSettings` | scoped override policy | Normaliseren op user/device/task. |
| `DeviceLoggingUsers` | device/user identity, task checkpoint, runtime health | Opsplitsen in meerdere tabellen/entities. |
| Deferred SQL CSV | SQLite transactional outbox | Niet converteren naar SQL; alleen records/events. |
| `Invoke-SqlQuery` endpoint | HTTPS ingestion client | Databasecredentials verwijderen. |
| Active/archive logtabellen | gepartitioneerde eventfacts + retention | Dual-write/backfill waar nodig. |
| Minimal tables | idempotente aggregate projector | Natuurlijke unique key toevoegen. |
| `DeviceScripts` | signed task package catalog | PowerShell alleen als begrensde compatibiliteit. |
| `DeviceScriptSchedules` | scheduler policy + target relations + run history | Gedenormaliseerde lijsten vervangen. |
| `DeviceApplicationMatches` | application registry + URL/process rule revisions | Externe CMDB-key behouden. |
| `DeviceLoggingErrors` | structured diagnostics/fingerprint store | Redactie en correlation. |
| `ActionLog` | immutable typed audit events | Polymorf TableName/RecordID afbouwen. |
| PSU-app | nieuwe admin portal/control-plane API | Capability-RBAC en revisions. |

## Fases

### Fase 0 — baseline en governance

- bronhashes en database-DDL bevriezen;
- event-/setting-/taskcontracten vastleggen;
- gegevensclassificatie, doeleinden en retention goedkeuren;
- 20-50 representatieve pilotdevices kiezen;
- legacy metrics verzamelen: eventvolume, backlog, memory, foutpercentages.

Exit: goedgekeurde contracts v1 en meetbare legacybaseline.

### Fase 1 — platform skeleton

- repository/CI, signing en package manifest;
- bootstrapper met atomic install/rollback;
- agent Windows Service;
- SQLite migrations, task state en outbox;
- control-plane heartbeat/settings endpoint;
- structured logs en supportbundle.

Exit: agent kan veilig installeren/updaten, policy ophalen en offline events vasthouden.

### Fase 2 — verticale BrowserHistory-slice

- Chromium/Firefox reader;
- URL-allowlist en redactie op endpoint;
- task checkpoint + outbox in één transactie;
- HTTPS batch ingestie, queue en PostgreSQL worker;
- minimale portalview voor fleet/ingestion.

Exit: end-to-end pilot zonder directe SQL-connectie en zonder dataverlies bij outage.

### Fase 3 — overige collectors

- ProcessInventory met publisher/product matching;
- RecentItems met padminimalisatie;
- BrowserExtensions als aparte task;
- taskhostproces voor native/risicovolle tasks;
- centraal taskcatalogus-/schedulecontract.

Exit: functionele pariteit voor de drie actieve legacy collectors plus extensie-inventarisatie.

### Fase 4 — schaal en datamodel

- 6.000-agent load/reconnecttests;
- databasepartitionering, indexes en retention;
- queue/worker autoscaling en dead-letter flow;
- idempotent minimal aggregate;
- HR/AD-/CMDB-viewadapters.

Exit: capaciteitstest voldoet aan overeengekomen ingestie-, backlog- en query-SLA.

### Fase 5 — beheerportal

- population/policy editor;
- agent health en diagnostics;
- task catalog/schedules/targeting;
- application registry en allowlists;
- usage explorer, errors en audit;
- impact preview, approval en rollback.

Exit: alle normale beheerhandelingen kunnen zonder PSU en met capability-RBAC.

### Fase 6 — parallel pilot en uitrol

- legacy en nieuw naast elkaar op pilots;
- compare aggregates, niet klakkeloos gevoelige detailregels;
- canarygroepen 1%, 5%, 20%, 50%, 100%;
- automatische rollbackgrenzen;
- support/runbooks en eigenaarsoverdracht.

Exit: datakwaliteit, performance, privacy en operationele acceptatie zijn ondertekend.

### Fase 7 — legacy afbouw

- endpoint-MSSQL-credentials intrekken;
- legacy schedules/PSU-writefuncties uitschakelen;
- dataretentie/backfillbesluit uitvoeren;
- oude executables, CSV-buffer en fixed-key DbSettings verwijderen;
- legacy portal read-only maken en daarna uitfaseren.

## Datamigratie

Niet alle detailhistorie hoeft naar het nieuwe operationele model. Beslis per dataset:

| Dataset | Voorkeur |
| --- | --- |
| Global settings en geldige overrides | Transformeren naar typed policy v1, met bron/provenance. |
| Application matches | Opschonen en migreren naar application/rule revisions. |
| Process/browser excludes | Alleen als input voor allowlistontwerp; niet blind kopiëren. |
| Task/scripts/schedules | Handmatig reviewen; geen arbitraire scriptcode automatisch activeren. |
| Minimal logs/dates | Backfill naar aggregate model indien rapportagehistorie nodig is. |
| Detail archives | Bij voorkeur read-only legacy/archive store; selectieve backfill na businesscase. |
| Errors/audit | Bewaren volgens compliance; eventueel in apart legacy auditarchief. |
| HR/AD tabellen | Niet migreren als UAM-data; vervangen door broncontracten/views. |

## Veldreview

De dictionary markeert vier kandidaten, geen verwijderbesluiten:

- `DeviceBrowserLogging2Exclude.Remarks`;
- `DeviceScriptSchedules.IntervalMinutes`;
- `DeviceScriptSchedules.SpecificRunTime`;
- `DeviceScriptSchedules.LastRunTime`.

Beslis na controle op externe rapporten, ad-hoc SQL en gewenst nieuw schedulercontract. De vele externe `AdUsers`-/HR-velden worden niet individueel “verwijderd”; de nieuwe bronview projecteert uitsluitend benodigde velden.

## Acceptatiecriteria

### Agent

- idle- en piekgeheugen binnen afgesproken budget;
- crash/reboot verliest geen geaccepteerde lokale events;
- taskcheckpoint loopt nooit vooruit op outboxcommit;
- update kan automatisch rollbacken;
- tasks kunnen worden gestopt en native taskhostresources verdwijnen.

### Ingestie

- duplicate batch levert geen duplicate facts;
- outage/reconnect voldoet aan backlog recovery SLA;
- `429`/retry veroorzaakt geen thundering herd;
- ongeldige schema-/tenant-/devicepayload wordt deterministisch afgewezen;
- geen raw payload/secrets in platformlogs.

### Data/privacy

- niet-allowlisted URLs/processen verlaten het endpoint niet;
- URL query/fragment en paden volgen redactiebeleid;
- retention/partition purge is aantoonbaar;
- detailtoegang is scoped en geaudit;
- aggregates vergelijken binnen overeengekomen tolerantie met legacy.

### Portal

- read en write capabilities zijn gescheiden;
- iedere mutatie heeft actor/reason/revision;
- impact preview en rollback zijn beschikbaar;
- diagnosticsbeleid verloopt automatisch;
- audit is immutable en doorzoekbaar.

## Open ontwerpbesluiten

1. PostgreSQL-only basis of optionele TimescaleDB deployment.
2. Queuekeuze per deploymentprofiel.
3. Deviceauthenticatie: mTLS, managed certificate of korte tokenflow.
4. Exacte URL-/padminimalisatie per businessdoel.
5. Retentie detail versus aggregates.
6. In-process ALC versus out-of-process per tasktype.
7. Portaltechnologie en hostingmodel.
8. Welke legacy historie aantoonbaar moet worden gebackfilled.
9. Wie eigenaar is van de centrale application registry voor andere IAM-modules.

## Eerste backlog

1. ADR's voor agent/service, SQLite/outbox, ingestion en database.
2. Contractpackages `Uam.Contracts`, `Uam.TaskSdk`, `Uam.Ingestion.Contracts`.
3. Bootstrapper prototype met signed package en rollback.
4. SQLite schema/migration en power-loss tests.
5. BrowserHistory vertical slice met allowlist.
6. Ingestion API + idempotency + queue worker.
7. 6.000-agent synthetic load harness.
8. Portal read-only fleet/usage prototype.
9. Policy revision/approval/audit flow.
10. Pilotrunbook en legacy comparison dashboard.
