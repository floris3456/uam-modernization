# Prompt 22 result — legacy consumer, report, script, schedule, credential, buffer, and integration discovery

**Result path:** `results/batch-06-migration/22-legacy-discovery-result.md`  
**Research date:** 1 August 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — IMPLEMENT A READ-ONLY DISCOVERY LANE; MIGRATION, CUTOVER, REMOVAL, AND SECRET HANDLING REMAIN GATED**  
**Authority boundary:** discovery architecture, evidence contracts, safe inventory methods, traceability, coverage reasoning, disposition mechanics, and falsifying experiments; **not** legal authority to inspect, approval of purposes, named ownership, consumer criticality, retirement, handling of unreachable devices, production change, retention, incident severity, budget, staffing, SLO/RPO/RTO, or deployment approval  
**Primary gate:** **No legacy behavior, data, credential, script, buffer, report, integration, or consumer is migrated or removed without evidence, owner, disposition, validation, and rollback.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, business, budget, support, or risk authority is required.
- **CLI EXPERIMENT** — code, lab work, observation, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed implementation baseline for this topic. They do not turn an **UNKNOWN**, **HUMAN DECISION**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — build a narrow, one-shot discovery tool rather than another permanent agent.** It should use fixed, reviewed, read-only adapters to inspect only approved endpoint locations, SQL Server metadata, existing workload evidence, PowerShell Universal configuration, scripts, schedules, reports, credentials, buffers, exports, firewall paths, and integrations. It should produce a sanitized, content-addressed evidence pack and traceability graph. It must not run a legacy script, deferred SQL statement, report, job, endpoint, or PSU action.

**FACT.** The supplied legacy evidence proves that the endpoint is a monolithic PowerShell system combining collection, scheduling, direct SQL Server access, deferred executable SQL in CSV, recovery, and restart behavior. It also proves that settings, checkpoints, schedules/scripts, application matching, broad administration, HR/directory relationships, aggregates, and audit exist in some form. It does **not** prove every runtime configuration, dynamic SQL path, report, manual consumer, external integration, or operational practice. [I02–I03]

**INFERENCE.** A static scan is necessary but cannot close migration or retirement decisions. Dynamic SQL, ad-hoc queries, copied exports, manual workflows, unreachable endpoints, expired telemetry, and undocumented people-dependent processes can all be absent from source code while still being operationally important. Therefore, every retirement claim needs three independent evidence classes where applicable: static evidence, bounded runtime observation, and owner/operator evidence.

**RECOMMENDATION.** The canonical result is not “the inventory spreadsheet.” It is a versioned evidence graph in which each legacy item links to its evidence, realm, owner state, disposition, replacement requirement, new component, contract, tests, migration step, rollback step, and removal proof. Missing links are executable stop conditions.

## 1.2 Decision summary

| Decision | Classification | Result |
|---|---|---|
| Discovery execution model | **RECOMMENDATION** | One-shot signed C#/.NET CLI with fixed adapters; no persistent fleet agent by default. |
| Endpoint scope | **RECOMMENDATION** | Exact release-owned machine locations and approved ordinary-token user-session locations only; never crawl profiles or arbitrary drives. |
| SQL scope | **RECOMMENDATION** | Fixed, bounded metadata and already-existing telemetry queries under least privilege; no caller-supplied SQL and no enabling telemetry in the read-only lane. |
| Script/SQL treatment | **RECOMMENDATION** | Parse only; never dot-source, import, invoke, compile, execute, schedule, or replay. |
| Secret/raw activity treatment | **RECOMMENDATION** | Classify and count in place; do not copy. Stop and invoke incident handling on a shareable-output escape. |
| Identity in evidence | **RECOMMENDATION** | UAM UUIDv7 IDs plus local purpose-separated HMAC aliases; raw names, hosts, accounts, paths, addresses, and URLs remain outside the shareable pack. |
| Evidence package | **RECOMMENDATION** | Strict JSON/NDJSON, local schemas, SHA-256 file manifest, deterministic sanitization, canary scan, immutable publication. |
| Absence claim | **RECOMMENDATION** | `NOT_OBSERVED_IN_SCOPE`, never absolute absence. Retirement requires complete scoped coverage, observation continuity, owner evidence, and rollback. |
| Disposition | **RECOMMENDATION** | `PRESERVE_APPROVED_OUTCOME`, `DELIBERATELY_CHANGE`, `RETIRE`, or `INVESTIGATE_QUARANTINE`. |
| Telemetry enablement | **RECOMMENDATION** | Not part of read-only discovery. A new Query Store/XE/audit session is a separate approved change with its own ADR and cleanup. |
| Removal authority | **HUMAN DECISION** | Technical evidence may recommend; an accountable owner approves criticality and retirement. |

## 1.3 What this result authorizes

**RECOMMENDATION — GO** for:

- strict discovery schemas, validators, fictional fixtures, parsers, query-pack static analysis, canaries, and evidence-pack verification;
- a disconnected endpoint collector prototype using only T1 fictional files, registry keys, services, tasks, connections, and buffers;
- a synthetic SQL Server lab containing fictional schemas, jobs, dynamic SQL, Query Store/XE history, credentials, linked servers, reports, and consumers;
- a PowerShell Universal repository/API read-only prototype against fictional configuration;
- interview templates, owner/disposition workflow, traceability rules, and coverage scoring;
- approved later read-only inventory runs using opaque target references and sanitized outputs.

## 1.4 What this result does not authorize

**RECOMMENDATION — STOP** before:

- running any command supplied by a legacy script, SQL text, schedule, report definition, PSU route/action, CSV buffer, tenant, administrator, or discovery response;
- enabling Query Store, creating an Extended Events session, changing SQL audit, starting jobs, invoking endpoints, rendering apps, or modifying firewall/task/service state in the read-only lane;
- requesting or exporting raw credentials, password hashes, tokens, private keys, connection strings, internal addresses, URLs, user names, production activity, HR data, or confidential reference data;
- recursively crawling user profiles, shares, drives, databases, repositories, or source-control history outside the approved scope manifest;
- inferring an owner, business purpose, criticality, role, entitlement, identity, or approved migration behavior from a name, path, query text, job title, application label, or usage count;
- treating one quiet observation window, one owner interview, one static dependency report, or one unreachable endpoint as proof of absence;
- migrating direct SQL access, executable deferred SQL, shared secrets, arbitrary PowerShell channels, or legacy implementation structure into the target design;
- removing or disabling any item while its evidence, owner, disposition, validation, rollback, or removal proof is incomplete.

## 1.5 Confidence and residual risk

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| A fixed read-only collector is safer than a general inventory framework | **High** | It follows the accepted no-script/no-SQL/no-profile-crawl boundaries and minimizes authority. | A bounded alternative passing the same non-execution, privacy, realm, load, and cleanup gates with lower assurance cost. |
| Static evidence alone cannot close consumer discovery | **High** | Supplied evidence explicitly lists dynamic SQL, reports, manual consumers, runtime settings, and integrations as missing. | A complete independently reconciled runtime/consumer registry with proved coverage and no manual paths. |
| Existing telemetry can materially improve coverage | **High** | Query Store and Extended Events can retain workload evidence, but their capture/retention/settings limit completeness. [W08–W11] | Evidence that the selected telemetry is incomplete or unsafe for a specific environment; the claim would narrow, not disappear. |
| A new telemetry session belongs outside the read-only lane | **High** | Enabling Query Store or creating XE is a database change, not observation. [W08, W12] | A platform mechanism that proves equivalent observation without persistent or configuration mutation. |
| The traceability graph can enforce the migration gate | **Medium-High** | Required links are finite and machine-testable, but organizational inputs and hidden consumers remain human-dependent. | A prototype showing the graph cannot represent a necessary dependency without unsafe free-form data. |
| “Absence” can be proved absolutely | **Low / not established** | Unreachable devices, telemetry gaps, ad-hoc access, manual exports, and human memory make universal absence unprovable. | A closed-world system with independently verified exhaustive instrumentation and population control. |
| The current estate is fully discoverable | **Low / not established** | No approved runtime inventory, consumer registry, owner map, query corpus, or observation window has run. | Passed CLI evidence and owner reconciliation for the approved scope. |

**Residual risk.** A read-only collector can still reveal sensitive metadata, load a fragile database, miss dynamic behavior, be fooled by stale telemetry, or be compromised. Local administrators and DBAs can hide or alter evidence. Human interviews can be wrong. Some endpoints may remain unreachable. A historical consumer may run only outside the observation window. HMAC aliases can still be linkable within a pack. These risks are contained by least privilege, exact scopes, fixed queries, local sanitization, independent evidence classes, immutable hashes, canaries, owner sign-off, conservative disposition, and rollback—not eliminated.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Evidence boundary and accepted inputs

**FACT.** All six allowlisted project files were present. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Use and limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted architecture and invariants; not production approval or runtime proof. |
| I02 | `01-existing-system-evidence-summary.md` | same | `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | Sanitized legacy endpoint, PSU DEV app, and production-DDL characteristics; static and incomplete. |
| I03 | `04-data-and-schema-evidence-summary.md` | same | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Legacy data shape and target data principles; no row values, rates, retention, or query corpus. |
| I04 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions and ordered proof gates. |
| I05 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, privacy boundaries, and human-authority rules. |
| I06 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted predecessor contracts, test-data, identity, privacy, repository, and G1 boundaries. |

The initiating prompt was reviewed separately with SHA-256 `20bc3e6f33b98ba05327b79d10af9145f8cefe9a27081f91fdb6ee3ad5e54727`.

## 2.2 In scope

The discovery lane covers, within a signed/approved scope:

1. endpoint agent versions, installed artifacts, signatures, settings, overrides, checkpoints, services, tasks, schedules, restart/recovery mechanisms, known buffers, and current network-flow classes;
2. database instances/databases, objects, modules, dependency metadata, principals, permissions, logins, credentials, proxies, linked/external data sources, SQL Agent jobs/schedules/history, existing Query Store/XE/audit evidence, and bounded live-session metadata;
3. PSU repositories, endpoints, routes, methods, scripts, schedules, triggers, jobs/history, apps/pages/actions, environments, roles, variables, app-token presence, management API surfaces, and configuration provenance;
4. reports, exports, spreadsheets, file drops, dashboards, manual extracts, scheduled delivery, service accounts, firewall paths, and recipient systems;
5. HR/AD/directory/CMDB/application joins and the authority or ambiguity of their keys;
6. owner interviews, operational runbooks, support practices, end-of-period activities, exception handling, and undocumented manual work;
7. unreachable device accounting and coverage limitations;
8. disposition, traceability, migration validation, rollback, and removal evidence.

## 2.3 Non-goals

This topic does not:

- redesign the endpoint, server, portal, identity, retention, or audit architecture beyond discovery interfaces;
- approve any legacy behavior for preservation merely because it exists;
- define a new general remote-management, script, SQL, report, workflow, or plug-in platform;
- normalize or repair production data during discovery;
- inspect raw activity or confidential reference data for “realism”;
- retrieve secret values, private keys, password hashes, token bodies, SSH material, or connection strings;
- determine legal purpose, employee consultation, prohibited use, retention, owner identity, business criticality, budget, or production authority;
- promise that every hidden or dormant consumer will be found;
- execute migration, cutover, decommissioning, or credential rotation.

## 2.4 Accepted predecessor invariants carried forward

**FACT.** These predecessor decisions directly constrain discovery:

- endpoints never receive central database credentials or submit SQL;
- tenant policy cannot introduce scripts, SQL, regexes, arbitrary paths, transforms, or destinations;
- user/session boundaries are security and privacy boundaries;
- UAM-owned stable identity is not derived from labels or external references;
- strict, bounded, versioned contracts and local schema bundles are required;
- test data is fictional-first, with an independent oracle and canary scanning;
- arbitrary Task Host/plugin/script channels are prohibited;
- a failed earlier gate stops dependent work. [I01, I04, I06]

**INFERENCE.** Discovery may observe legacy direct SQL and executable buffers, but the target traceability disposition must preserve only an approved outcome, not those implementation mechanisms.

## 2.5 Assumptions and falsifiers

| ID | Classification | Assumption | Smallest falsifier and consequence |
|---|---|---|---|
| AS22-01 | **ASSUMPTION** | Approved operators can provide an authoritative target population or at least bounded population sources. | Population sources disagree without a reconciler; coverage cannot exceed `UNKNOWN`, and removal stops. |
| AS22-02 | **ASSUMPTION** | The legacy endpoint has release-owned or administratively known roots sufficient for a bounded scan. | Critical artifacts occur only through broad profile/drive crawling; open an ADR and human privacy/security decision rather than broadening silently. |
| AS22-03 | **ASSUMPTION** | SQL metadata can be read with a dedicated least-privilege principal. | Required metadata needs `sysadmin`, secret access, or unsafe execution; narrow the claim or use an approved restored copy. |
| AS22-04 | **ASSUMPTION** | PSU configuration is substantially represented in repository/configuration and/or a GET-only management surface. | A critical behavior exists only through runtime state or hidden extension code; classify as `INVESTIGATE_QUARANTINE`. |
| AS22-05 | **ASSUMPTION** | Existing runtime evidence has enough clock, retention, and capture metadata to be interpreted. | Capture mode, reset, rollover, clock, or retention is unknown; runtime evidence cannot support absence. |
| AS22-06 | **ASSUMPTION** | Owners can validate semantic outcomes without receiving raw activity or secret values. | A claimed owner cannot decide from minimized evidence; use an authorized local review ceremony, never broaden the shareable pack by default. |
| AS22-07 | **ASSUMPTION** | One realm can be processed and published independently. | Shared artifacts cannot be assigned without cross-realm disclosure; quarantine and obtain governance direction. |
| AS22-08 | **ASSUMPTION** | File and object hashes plus stable local locators can support repeat discovery. | Mutable/generated artifacts make hashes unstable; introduce a versioned semantic fingerprint with false-match tests. |

## 2.6 Unknowns that block decommissioning

**UNKNOWN.** The supplied evidence does not establish:

- the authoritative endpoint and server population;
- current agent versions/settings/checkpoint locations and buffer volumes;
- all databases, schemas, instances, linked servers, reports, SQL Agent jobs, logins, service accounts, or firewall paths;
- whether Query Store, XE, SQL Audit, PSU history, task history, or application logs are enabled, complete, retained, or reset;
- every dynamic SQL or ad-hoc consumer;
- every HR/AD/directory key and join semantic;
- every manual report/export recipient or spreadsheet copy;
- named owners, approved purposes, criticality, observation window, or retirement approval;
- how unreachable devices must be handled;
- exact discovery resource budgets, concurrency, maintenance windows, or support staffing.

No item in this list may be converted into a convenient default that authorizes removal.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architecture overview

**RECOMMENDATION.** Implement `Uam.LegacyDiscovery` as a signed, one-shot C#/.NET CLI. It consumes an approved immutable scope manifest, executes only compiled adapter/query IDs, creates a local restricted working set, sanitizes before publication, and exits. It does not install a service, scheduler, database object, PSU script, browser extension, or remote shell.

```text
approved authority + scope manifest
             |
             v
      Scope Gate / Run Controller
             |
   +---------+-----------+-------------------+
   |                     |                   |
   v                     v                   v
Endpoint adapters     SQL adapter         PSU adapter
(machine context)     (least privilege)   (repo first / GET only)
   |                     |                   |
   +---------- local raw/secret boundary ----+
                         |
               Static parsers/classifiers
          (PowerShell AST, T-SQL AST, XML/JSON)
                         |
               Sanitizer + local HMAC aliases
                         |
          strict observations + provenance graph
                         |
             canary/schema/hash verification
                         |
              immutable sanitized evidence pack
                         |
     coverage + interviews + disposition + trace graph
                         |
          migration / rollback / removal stop gates
```

## 3.2 Components and responsibilities

| Component | Normative responsibility | Explicit prohibitions | Trust boundary / accountable function |
|---|---|---|---|
| **Scope Authority Registry** | Store approved question, realm, target-set references, adapter IDs, evidence fields, access, expiry, and deletion requirements. | No raw host/address/credential in the shareable manifest; no implicit wildcard; no self-approval. | Human governance to discovery execution. |
| **Run Controller** | Verify scope digest/expiry/signature, tool release, clock, target membership, output location, concurrency, and kill switches; orchestrate fixed adapters. | No dynamic assembly/plugin loading, general shell, arbitrary SQL, arbitrary path, or caller-supplied code. | Control plane inside disposable discovery process. |
| **Target Resolver** | Resolve opaque approved target references locally; bind target to one realm and expected asset class. | No target address emitted to pack; no nearest-match or cross-realm fallback. | Sensitive local configuration boundary. |
| **Endpoint Machine Adapter** | Read exact service/task/package/registry/file/settings/checkpoint/buffer/network metadata from release-owned machine locations. | No user-profile crawl, `Win32_Product`, process injection, service/task start, firewall mutation, or raw command-line export. | Machine administrator/read-only execution context. |
| **Endpoint User-Session Adapter** | Under an existing ordinary user token, read only approved legacy-owned user locations where machine context cannot safely do so. | No token creation, impersonation by Coordinator, other-user session access, browser/activity collection, or recursive home scan. | User/session privacy boundary. |
| **SQL Metadata Adapter** | Execute fixed, reviewed, bounded `SELECT` queries and documented read-only catalog/DMF access; record effective permissions and gaps. | No DDL/DML, `EXEC`, DBCC, backup/restore, configuration change, arbitrary query, secret/hash retrieval, or telemetry enablement. | Database least-privilege boundary. |
| **Existing Runtime Evidence Adapter** | Read only already-enabled Query Store, XE file/ring-buffer, SQL Audit, Agent history, or approved logs; locally parse and aggregate. | No creation/alter/start/stop of sessions, Query Store mode change, plan forcing, audit change, or raw query-text export. | Runtime telemetry and privacy boundary. |
| **PSU Repository Adapter** | Read repository files and configuration metadata from an approved read-only source; enumerate endpoints, scripts, schedules, triggers, apps, roles, and variables. | No module import, dot-sourcing, script invocation, app rendering, endpoint request, job run, or repository write. | Source/configuration boundary. |
| **PSU GET-only API Adapter** | When repository evidence is insufficient, call a release-owned allowlist of GET endpoints using a dedicated least-privilege app-token reference. | No POST/PUT/PATCH/DELETE, no invoke/run endpoint, no token export, no generic URL. | Management API boundary. |
| **PowerShell Static Parser** | Use `System.Management.Automation.Language.Parser` to return AST/tokens/errors; classify commands, APIs, dynamic invocation, data sinks, and secret indicators without execution. [W19–W20] | No runspace, script block invocation, module import, type initialization, argument completer, formatter, or profile load. | Untrusted script text to typed static facts. |
| **T-SQL Static Parser** | Parse module/job/report/deferred SQL text locally, classify statement families, dependencies, dynamic construction, external access, and write/execute capability. | No database execution or “validation by running”; parse success is not semantic correctness. | Untrusted SQL text to typed static facts. |
| **Structured Configuration Parser** | Parse XML/JSON/YAML/CSV using bounded local parsers; disable external entities/references and formulas/macros. | No external fetch, schema URL, DTD/XXE, macro, spreadsheet formula execution, or archive traversal. | Untrusted configuration to typed facts. |
| **Credential/Buffer Classifier** | Record presence, locator alias, store/type, privilege/scope class, exportability, use evidence, volume/age buckets, and incident flags. | No value, password hash, token body, private key, connection string, raw SQL buffer, or raw activity copy. | Secret/raw-data boundary. |
| **Sanitizer and Alias Service** | Apply schema allowlists; replace sensitive locators with purpose-separated local HMAC aliases; normalize finite enums/buckets; zero/drop raw buffers after use. | No reversible map in shareable pack; no raw SHA of low-entropy names; no alias reuse across unrelated purposes/realms. | Local sensitive working set to sanitized evidence. |
| **Evidence Writer** | Write strict NDJSON to a private staging directory; compute per-file SHA-256 and package root; preserve first failure; atomically publish after validation. | No partial published pack, hidden overwrite, dynamic field, external upload before canary pass, or mutable published revision. | Local staging to evidence authority. |
| **Traceability Graph Builder** | Validate node/edge types and mandatory paths from legacy evidence to requirement, component, test, migration, rollback, owner, and removal proof. | No free-form executable relation, cross-realm edge, orphan disposition, or inferred owner. | Evidence to migration-governance boundary. |
| **Coverage Evaluator** | Reconcile population, static, runtime, interview, network, data, and time coverage; issue bounded `PRESENT`, `NOT_OBSERVED_IN_SCOPE`, `UNKNOWN`, or `CONTRADICTORY` claims. | No absolute absence, percentage confidence, or quiet-window retirement. | Evidence interpretation boundary. |
| **Disposition Service** | Maintain immutable revisions and approvals for preserve/change/retire/investigate; enforce stop conditions. | No discovery tool self-approval, silent default, or migration/removal without complete trace path. | Technical recommendation to human authority. |
| **Pack Verifier/Canary Scanner** | Independently validate schemas, hashes, lineage, forbidden fields, secret/raw canaries, metric dimensions, and trace completeness. | No “zero exit code means complete”; mandatory positive controls must be detected. | Evidence release gate. |

## 3.3 Trust boundaries

### TB-01 — human authority to executable scope

Only an approved scope manifest can enable an adapter/target/field. The CLI MUST fail closed on missing owner function, expired authority, changed manifest bytes, unknown adapter, target outside the population, or cross-realm mapping. A local operator cannot broaden scope with command-line paths, queries, or URLs.

### TB-02 — machine context to user session

The machine adapter MUST NOT crawl profiles or manufacture user tokens. User-owned locations, if required, are read by a short-lived ordinary-token session helper under the exact logged-on user and exact scope. Its output is already structural/sanitized before returning to machine context.

### TB-03 — database and PSU sources to local raw working set

Definitions, job commands, Query Store text, XE payloads, configuration variables, and buffer samples may be sensitive. They may exist transiently only inside the adapter/parser process. They MUST NOT enter general DTOs, logs, exceptions, metrics, crash dumps, support bundles, or the shareable evidence pack.

### TB-04 — local raw working set to shareable evidence

Publication is allowlist construction, not redaction of a broad object. Each output contract has closed fields. Sensitive identifiers become local HMAC aliases or finite classes; raw values are structurally absent. A canary hit aborts publication and starts incident handling.

### TB-05 — evidence to decision

Presence proves only observed legacy behavior, not approval to preserve it. Non-observation proves only the declared scope/time/evidence conditions. Owners and accountable decision functions approve criticality and disposition; the tool enforces required evidence but cannot invent authority.

## 3.4 Mandatory artifact — read-only collection/query plan

**RECOMMENDATION.** The endpoint collector uses Windows APIs/CIM/registry/file metadata directly or fixed PowerShell cmdlets invoked by compiled code only where necessary. It reads exact scope-owned locations and emits sanitized facts.

| Area | Fixed read-only evidence | Shareable output | Exclusions/notes |
|---|---|---|---|
| OS/runtime | OS family/build class, architecture, PowerShell/.NET version classes, boot-time bucket | finite version/profile IDs and exact tool evidence digest | Exact rapidly changing versions belong in restricted evidence, not metric labels. |
| Agent installation | uninstall registry entries, exact approved roots, file sizes/hashes/signature states | artifact aliases, versions, hashes, signer class, missing/conflict state | Do not use `Win32_Product`; Microsoft documents slow consistency checks and repair side effects. [W24] |
| Service | `Win32_Service`/Service Control Manager query of exact service names | start type/state/account class/binary alias/ACL digest | Do not start/stop/configure. Raw account and path remain local. |
| Scheduled tasks | `Get-ScheduledTask`/Task Scheduler COM and `Get-ScheduledTaskInfo` for approved folders/names | task alias, enabled/state, trigger/action classes, principal class, last/next-run buckets, XML digest | Arguments may contain secrets; parse/classify locally, never export raw. |
| Settings/checkpoints | exact approved registry keys/files | schema/version, field-presence bitmap, value type/size/bucket/digest | No raw user override, URL, path, SQL, or identity. |
| Buffers | exact known directories/files; size/count/time/type/parser metadata | buffer class, record count bucket, bytes bucket, oldest/newest bucket, content digest, secret/raw flags | Never copy content; never execute. Unknown format is quarantine. |
| Network | current TCP connection metadata and firewall-rule classes for exact process/service | direction, protocol, port class, destination class, rule/profile/action class, observation time | IP/host/address and remote endpoint omitted; one snapshot is not historical proof. |
| Files/scripts | exact approved file list, hashes, signatures, AST classification | artifact node, parser result, capability flags, dependency aliases | No recursive drive/profile search; no module import. |
| Errors/restarts | exact event provider IDs or product-owned logs if approved and structurally safe | finite reason/status/count/time buckets | No event-message text or arbitrary log ingestion. |

**Read-only proof.** A lab run MUST compare services, tasks, registry, files, ACLs, firewall, processes, network listeners, and product source directories before/after. Process-level filesystem/registry tracing MUST show zero successful mutation outside the private output directory and zero unexpected mutation intent.

## 3.5 SQL Server portion of the read-only collection/query plan

**RECOMMENDATION.** Use a dedicated integrated-authentication principal or equivalent credential reference with only the minimum metadata permissions required for the approved queries. Exact grants vary by SQL Server version and topology; the evidence pack records effective permissions and any hidden rows. Metadata visibility can return partial or empty results when permissions are insufficient, so an empty view is never automatically absence. [W03]

### Fixed query groups

| Query group ID | Sources | Purpose | Important limitations |
|---|---|---|---|
| `sql.instance.v1` | `SERVERPROPERTY`, `sys.configurations`, database catalogue | version/edition/topology/config classes | Configuration names/values may be sensitive; output is a finite allowlist/bucket. |
| `sql.schema.v1` | `sys.objects`, `sys.schemas`, `sys.tables`, `sys.columns`, types, keys, indexes, constraints, synonyms | object shape and integrity surface | Visibility depends on permission; encrypted modules remain opaque. |
| `sql.dependencies.v1` | `sys.sql_expression_dependencies`, `sys.dm_sql_referenced_entities`, `sys.dm_sql_referencing_entities`, `sys.sql_modules` | persisted module dependencies and static SQL structure | By-name dependency metadata misses or cannot resolve dynamic/caller-dependent/temp/system cases. [W01–W02] |
| `sql.security.v1` | server/database principals, role membership, permissions, credentials/proxies metadata | access, service-account, credential and execution paths | Never select password hashes, credential secrets, token/provider strings, or private keys. |
| `sql.agent.v1` | documented `msdb` SQL Agent tables for jobs, steps, schedules, history, proxies | schedules/scripts/commands and observed runs | Command text stays local; history retention may be short or purged. [W13] |
| `sql.external.v1` | linked servers, synonyms, external data sources, assemblies, Service Broker metadata where present | external routes/integrations | Provider strings/remote names are locally aliased; existence does not prove current use. |
| `sql.querystore.v1` | `sys.database_query_store_options` and Query Store catalog views | historical query/plan/runtime evidence if already enabled | Capture mode can omit queries; cleanup/retention/reset/state matter; Query Store omits DDL. [W08–W09] |
| `sql.xe-existing.v1` | existing session metadata and approved local XE file/ring-buffer readers | existing runtime events and client/query classes | No new/altered session; rollover/target loss and predicate coverage must be recorded. [W10–W12] |
| `sql.sessions.v1` | bounded current session/request metadata | point-in-time client/program/login/database classes | One snapshot is weak evidence; client-supplied names are hints, not identity. |
| `sql.backup-report.v1` | backup/report-subscription/catalogue metadata where approved | report/export destinations and schedules | Do not enumerate file/share paths into the shareable output. |

### Query-pack rules

The query-pack compiler MUST reject any batch containing or resolving to:

- `INSERT`, `UPDATE`, `DELETE`, `MERGE`, `TRUNCATE`, `CREATE`, `ALTER`, `DROP`, `GRANT`, `DENY`, `REVOKE`, `BACKUP`, `RESTORE`, `DBCC`, `KILL`, `WAITFOR`, `BULK`, `OPENROWSET`, `OPENDATASOURCE`, `xp_*`, OLE automation, CLR execution, Service Broker send, external script execution, or arbitrary `EXEC/EXECUTE`;
- temporary persistence, caller-provided object identifiers, dynamic SQL, output-to-file, linked-server pass-through, or network access;
- reads of password hashes, secret values, private keys, credential identities beyond approved classes, or row-level activity data not required by the discovery contract.

Every query MUST have an immutable ID, supported engine range, expected permission set, maximum rows/bytes/time, cancellation behavior, result schema, sensitive columns handled locally, and a synthetic golden/invalid corpus. Connections SHOULD use an application name and read-only intent where supported, but permissions and query review—not connection hints—are the security boundary. Use a low deadlock priority, bounded lock/command timeout, cancellation, and explicit row caps. Do not use `NOLOCK` as a universal answer; it can make evidence internally inconsistent.

## 3.6 PSU discovery plan

**FACT.** Current PowerShell Universal documentation describes repository-backed configuration, scripts, schedules, triggers, endpoints, jobs, a management API, and app tokens. Scripts can run manually, on schedules, or on events; triggers can react to events; the management API requires an app token. [W25–W33]

**RECOMMENDATION.** Use this order:

1. read a read-only repository snapshot or filesystem checkout first;
2. parse configuration scripts/XML/JSON without importing or executing PowerShell;
3. use the GET-only management API only for state not represented in the repository, under a dedicated least-privilege app-token reference;
4. compare repository and runtime metadata; disagreement becomes `CONTRADICTORY`;
5. never call a custom endpoint, invoke a script/job, start an environment, render an app, or follow an endpoint URL during discovery.

The adapter inventories endpoint route/method/authentication class/action AST, scripts, schedules, triggers, jobs/history, apps/pages/actions, environments, roles, module/dependency declarations, variables/secret-presence flags, app-token count/status classes, and deployment/repository revision. It publishes no script body, route, token, URL, user, or secret.

## 3.7 Static and runtime evidence composition

**RECOMMENDATION.** Each behavior/consumer claim records independent evidence facets:

```text
static artifact evidence
+ configuration/control-plane evidence
+ existing runtime observation
+ data/schema dependency evidence
+ network/export evidence
+ owner/operator interview
+ population/time/clock/retention coverage
= bounded coverage claim, not automatic truth
```

A static dependency with no runtime evidence is `PRESENT_STATIC_ONLY`. Runtime use with no static owner is `PRESENT_RUNTIME_UNOWNED`. Interview-only evidence is `PRESENT_ASSERTED_UNVERIFIED`. Contradictions are first-class and block retirement.

## 3.8 Privacy-safe observability and metric-cardinality limits

The discovery CLI itself emits only finite metrics:

```text
component
adapter_id
asset_class
stage
outcome_family
reason_family
source_type
coverage_state
confidence_level
runtime_profile_major
```

Realm, target, host, user, account, service, task, database, object, query, script, report, application, path, URL, address, credential, buffer, owner, and evidence IDs MUST NOT be metric labels. Exact IDs and hashes belong only in access-controlled evidence. The route/adapter catalogue computes the theoretical series maximum; a new dynamic label fails CI.

## 3.9 Configuration ownership, flags, and kill switches

- Product/release code owns adapter IDs, fixed queries, fields, parsers, limits, sanitization, and schema versions.
- An approved scope manifest may only choose a subset, narrower targets, shorter duration, smaller concurrency, and stronger exclusions.
- No scope or feature flag can enable script/SQL execution, raw export, profile crawling, cross-realm joins, secret access, telemetry mutation, or bypass of evidence scanning.
- Kill switches may disable an adapter, target class, runtime observation, or publication. They cannot mark missing evidence as present or clear a safety hold.
- A secret/raw canary hit, cross-realm finding, query-pack integrity failure, unexplained mutation, or package hash conflict causes immediate stop and no publication.


---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Alternative assessment

| Alternative | Decision | Rejection reason | Condition that could change the choice |
|---|---|---|---|
| Manual spreadsheet and interviews only | **REJECTED AS PRIMARY METHOD** | It cannot prove exact artifact hashes, query/parser coverage, target population, contradictions, or absence of execution. It is vulnerable to stale copies and transcription errors. | It remains a human-input view generated from the canonical evidence graph, never the source of technical truth. |
| One broad PowerShell discovery script | **REJECTED** | The legacy failure mode already combines orchestration, scripts, SQL, credentials, scheduling, and mutable behavior. A broad script is difficult to constrain, sign, statically prove, and keep free of profile/module side effects. | A fixed, generated PowerShell wrapper MAY invoke signed compiled commands in an approved lab, but it cannot accept arbitrary script text or become the discovery authority. |
| Persistent fleet inventory agent | **REJECTED BY DEFAULT** | It creates a permanent privileged/telemetry surface, lifecycle and patch obligations, buffering, remote control, and a second endpoint agent before a continuing need is established. | Reconsider only after repeated approved discovery cycles prove a continuing requirement that cannot be met by enterprise deployment or the target UAM health plane, followed by a separate privacy/security/cost ADR. |
| General remote-management shell or arbitrary command runner | **REJECTED** | It becomes an executable administration channel with credential, lateral-movement, audit, and realm risks far beyond discovery. | No general form is accepted. A new fixed release-owned capability needs its own contract, test, authorization, and rollback. |
| Execute deferred SQL or scripts in a sandbox to learn behavior | **REJECTED** | Deferred text may mutate systems, disclose secrets, reach external services, depend on production data, or behave differently in a sandbox. Execution would convert discovery into change. | Never part of this lane. A separately authorized functional characterization lab MAY reimplement a minimal synthetic case after static review; it still does not execute production text. |
| Restore a database copy and inspect it offline only | **REJECTED AS COMPLETE METHOD** | A restore can show stored objects and some data shape but cannot prove current consumers, external reports, ad-hoc activity, unreachable endpoints, current permissions, or manual workflows. It may also contain unnecessary personal/confidential data. | An isolated sanitized metadata-only restore can supplement the fixed query lane where production metadata access is unsafe, subject to the same minimization, deletion, and provenance controls. |
| Enable Query Store or Extended Events during the read-only run | **REJECTED IN THIS LANE** | Both are configuration changes with storage, performance, privacy, retention, and cleanup consequences. The read-only claim would be false. | A separate ADR and approved instrumentation experiment may authorize a minimum capture profile, exact duration, resource budget, fields, access, cleanup, and incident handling when existing evidence is insufficient. |
| Read packet payloads or perform broad packet capture | **REJECTED** | It risks credentials, URLs, personal data, application payloads, TLS interference, and broad third-party traffic collection; it is unnecessary for route existence. | A separately approved lab-only synthetic network experiment may prove one fixed protocol path. Production payload capture remains outside discovery. |
| Infer consumers from SQL login names, host names, program names, or query comments | **REJECTED** | These values can be spoofed, shared, stale, generic, or absent. They are evidence hints, not identity, owner, purpose, or criticality. | Correlation MAY support an interview candidate when combined with authenticated configuration, runtime evidence, and owner confirmation. |
| Migrate every observed legacy behavior “as is” | **REJECTED** | Presence proves behavior, not approval. It would preserve direct SQL, executable buffers, broad mutation, weak identity, and privacy risks that conflict with accepted target invariants. | Each item must receive an explicit disposition; only the approved outcome may be preserved, through a governed target contract. |
| Retire every item not observed in one window | **REJECTED** | Capture modes, retention, seasonality, outages, unreachable devices, manual work, and ad-hoc consumers make one quiet window weak evidence. | Retirement requires the coverage method in section 6, owner approval, a bounded dark/parallel-validation period, rollback, and removal proof. |
| Use SQL Server First Responder Kit as the discovery engine | **REJECTED AS DEPENDENCY/EXECUTION PATH** | The toolkit installs and runs broad stored procedures, can collect detailed query/plan data, and has options outside the fixed minimum discovery surface. It changes the database and is not a UAM evidence contract. | Selected implementation ideas may be reviewed as reference only; no stored procedure from the toolkit runs in the read-only lane. |
| Use osquery as a permanent endpoint agent | **REJECTED FOR FIRST LANE** | It provides a broad SQL/plugin/distributed-query surface and a persistent high-authority agent. Its threat model and lifecycle differ materially from a one-shot fixed collector. | It may remain a reference for table design. A future dependency requires an exact plugin/query allowlist, no remote arbitrary SQL, privacy proof, signed deployment, and lower total operations cost. |
| Use DataHub/OpenLineage as the migration evidence platform | **REJECTED INITIALLY** | They introduce a large service/connector/metadata platform, network ingestion, broad schemas, and operational dependencies before a local evidence graph need is proved. Open lineage payloads may contain SQL/source details that UAM must not publish. | Reconsider only if the approved enterprise metadata platform already exists and a narrow adapter can publish the sanitized UAM graph without broadening fields or authority. |
| Use Liquibase as the discovery and rollback authority | **REJECTED** | Liquibase is change/migration oriented, not an observer of hidden consumers. Its current licensing also needs separate legal review. A changelog does not prove runtime use or removal safety. | Changelog/rollback concepts may inform migration records after a database change technology is selected. |
| Build a machine-learning classifier for ownership/criticality | **REJECTED** | Names, usage, departments, and query patterns do not establish purpose, owner, entitlement, or retirement authority; opaque inference would be hard to contest and can expose personal data. | No automated owner/criticality decision. A model may only prioritize interview queues using approved aggregate features and must not change disposition automatically. |
| Create one database/schema per realm for discovery evidence | **REJECTED BY DEFAULT** | It adds object, migration, backup, restore, and access complexity without a requirement. The evidence package is immutable and realm-bound already. | A legal/contractual isolation requirement or measured shared-store failure could justify a separate design. |
| Introduce a broker/workflow platform for discovery jobs | **REJECTED** | A one-shot bounded lane does not need a new custody/replay/fan-out failure domain. Durable local packages and explicit reruns are simpler. | Reconsider only after measured multi-site orchestration, replay, or isolation requirements cannot be met by existing enterprise deployment and repository workflows. |

## 4.2 Why the fixed CLI is the smallest sufficient choice

**INFERENCE.** The fixed CLI keeps the dangerous authority local and short-lived: a signed executable, one immutable scope, one target at a time or a bounded batch, fixed adapters, no inbound listener, no persistent scheduler, no arbitrary code, and a package that can be independently verified. It composes with the accepted C#/.NET family and repository controls without creating a new production service.

**RECOMMENDATION.** Enterprise software deployment MAY launch the signed CLI and retrieve the sanitized package, but the deployment product remains transport/orchestration only. It MUST NOT inject commands, queries, credentials, paths, or transformations into the collector.

## 4.3 Change triggers

Open an ADR before changing the architecture when any of these is established:

1. a required consumer cannot be discovered through static metadata, existing telemetry, bounded interviews, and approved enterprise inventory;
2. repeated cycles create an approved continuing-monitoring requirement;
3. one-shot target resolution cannot cover a named estate without unacceptable risk or cost;
4. an approved instrumentation need requires database/endpoint mutation;
5. the evidence graph must interoperate with an existing enterprise lineage platform;
6. the local evidence package cannot meet approved retention, multi-party verification, or operational scale;
7. a fixed parser cannot classify a required language or binary artifact safely;
8. a legal/contractual requirement demands stronger isolation or independently witnessed evidence.

A change proposal MUST state the affected invariant, new primary evidence, alternatives, security/privacy/realm impact, smallest falsifying experiment, migration/rollback consequence, and ADR action.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Common contract rules

All discovery contracts MUST follow the accepted strict-contract profile:

- strict UTF-8 without BOM;
- closed objects and enums; duplicate, unknown authority-bearing, wrong-case, malformed, over-limit, and trailing data are rejected;
- local immutable JSON Schema Draft 2020-12 bundles only; no remote `$ref` or runtime schema download;
- canonical lower-case UUIDv7 for UAM-owned IDs; UUID time bits do not establish business time, ordering, authority, or evidence precision;
- SHA-256 for file/content/evidence digests under the current profile; algorithm identity is explicit;
- RFC 3339 UTC instants plus separately declared clock/precision class where material;
- no generic `metadata`, `properties`, `details`, `extension`, `script`, `query`, or arbitrary dictionary field;
- authenticated/local execution context supplies realm and target authority; evidence bodies use opaque aliases and cannot override context;
- explicit byte, row, item, nesting, time, and allocation limits recorded by adapter version;
- finite privacy-safe errors; no raw exception, path, command, SQL, script, URL, account, host, address, or payload echo;
- producer-first generation is forbidden: consumers and validators deploy before a new producer contract is activated.

## 5.2 Discovery package layout

A published package revision MUST be immutable and contain only the files declared by `manifest.json`:

```text
manifest.json
scope/scope-summary.json
inventory/nodes.ndjson
inventory/edges.ndjson
evidence/observations.ndjson
coverage/claims.ndjson
disposition/items.ndjson
trace/nodes.ndjson
trace/edges.ndjson
interviews/responses.ndjson
incidents/events.ndjson
schemas/**
hashes.sha256
package-root.json
```

Optional files are represented by an empty valid NDJSON file and manifest entry rather than silently omitted. The package MUST NOT contain a raw working directory, database dump, event trace, SQL text, script body, connection string, address list, credential export, HR/directory rows, activity rows, screenshots, crash dump, or unclassified attachment.

## 5.3 Scope manifest

The shareable scope summary omits resolvable target addresses. The local signed scope contains opaque references resolved from protected enterprise configuration.

```json
{
  "contract": "uam.legacy-discovery.scope-manifest",
  "version": "1.0.0",
  "scopeId": "019d0000-0000-7000-8000-000000002201",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "questionIds": ["LEGACY_DEPENDENCY_DISCOVERY_V1"],
  "targetSetRef": "opaque-approved-target-set",
  "allowedAdapterIds": [
    "endpoint.machine.v1",
    "sql.schema.v1",
    "sql.dependencies.v1",
    "psu.repository.v1"
  ],
  "fieldProfileId": "DISCOVERY_SANITIZED_V1",
  "maximumConcurrency": 1,
  "notBeforeUtc": "2026-08-01T00:00:00Z",
  "notAfterUtc": "2026-08-08T00:00:00Z",
  "authorityReference": "opaque-approval-reference",
  "deletionProfileId": "DISCOVERY_WORKING_SET_DELETE_V1",
  "scopeContentDigest": "sha-256:fictional"
}
```

All example values are fictional. Production values and exact limits require approved scope evidence. The local target set is encrypted/access-controlled and is not copied into the shareable package.

## 5.4 Mandatory artifact — discovery inventory schema

### 5.4.1 Inventory node

```json
{
  "contract": "uam.legacy-discovery.inventory-node",
  "version": "1.0.0",
  "nodeId": "019d0000-0000-7000-8000-000000002210",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "assetClass": "SQL_AGENT_JOB",
  "locatorAlias": "hmac256:local-purpose-separated-fictional",
  "sourceSystemClass": "SQL_SERVER",
  "lifecycleState": "OBSERVED",
  "capabilityFlags": ["SCHEDULED", "CONTAINS_EXECUTABLE_TEXT"],
  "sensitivityFlags": ["POTENTIAL_SECRET", "POTENTIAL_PERSONAL_DATA"],
  "firstObservedUtc": "2026-08-01T09:00:00Z",
  "lastObservedUtc": "2026-08-01T09:00:00Z",
  "clockQuality": "SYNCHRONIZED",
  "evidenceObservationIds": ["019d0000-0000-7000-8000-000000002211"],
  "ownerState": "UNASSIGNED",
  "contentDigest": "sha-256:fictional"
}
```

### 5.4.2 Allowed node classes

| Category | `assetClass` values | Minimum required facts | Structurally forbidden facts |
|---|---|---|---|
| Endpoint | `LEGACY_AGENT_INSTALLATION`, `SERVICE`, `SCHEDULED_TASK`, `SETTINGS_STORE`, `CHECKPOINT_STORE`, `BUFFER_STORE`, `SCRIPT_ARTIFACT`, `EXPORT_ARTIFACT`, `FIREWALL_RULE`, `NETWORK_OBSERVATION` | target alias, version/state class, source adapter, observation time, evidence | user name, profile path, address, command line, raw settings/activity |
| Database | `SQL_INSTANCE`, `DATABASE`, `SCHEMA_OBJECT`, `SQL_MODULE`, `SQL_AGENT_JOB`, `SQL_AGENT_SCHEDULE`, `SQL_LOGIN_CLASS`, `DATABASE_PRINCIPAL`, `CREDENTIAL_REFERENCE`, `PROXY`, `LINKED_SERVER`, `EXTERNAL_DATA_SOURCE`, `REPORT`, `REPORT_SUBSCRIPTION`, `QUERY_PATTERN` | instance/database aliases, object class, definition digest/parser state, permission/capture limits | SQL text, server/database names, password/hash, provider string, report parameters/output |
| PSU | `PSU_ENDPOINT`, `PSU_SCRIPT`, `PSU_SCHEDULE`, `PSU_TRIGGER`, `PSU_APP`, `PSU_ACTION`, `PSU_ENVIRONMENT`, `PSU_ROLE`, `PSU_VARIABLE_REFERENCE`, `PSU_APP_TOKEN_REFERENCE`, `PSU_JOB_PATTERN` | repository/runtime revision, AST/capability flags, schedule/trigger class, auth class | route, script body, token, user, URL, secret value |
| Identity/integration | `SERVICE_ACCOUNT_REFERENCE`, `HR_JOIN`, `DIRECTORY_JOIN`, `CMDB_JOIN`, `EXPORT_DESTINATION`, `INTEGRATION`, `MANUAL_WORKFLOW`, `CONSUMER` | source/target classes, join/key class, direction, owner state, use evidence | identity values, group names, addresses, recipient names, row samples |
| Evidence/governance | `EVIDENCE_SOURCE`, `OWNER_ASSERTION`, `REQUIREMENT`, `NEW_COMPONENT`, `CONTRACT`, `TEST`, `MIGRATION_STEP`, `ROLLBACK_STEP`, `REMOVAL_PROOF`, `RISK`, `HUMAN_DECISION` | immutable ID, revision/digest, state, owner function where applicable | free-form executable content or sensitive selector |

### 5.4.3 Inventory edge

```json
{
  "contract": "uam.legacy-discovery.inventory-edge",
  "version": "1.0.0",
  "edgeId": "019d0000-0000-7000-8000-000000002220",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "fromNodeId": "019d0000-0000-7000-8000-000000002210",
  "relation": "EXECUTES",
  "toNodeId": "019d0000-0000-7000-8000-000000002219",
  "evidenceObservationIds": ["019d0000-0000-7000-8000-000000002211"],
  "directionConfidence": "MEDIUM",
  "state": "OBSERVED_STATIC",
  "contentDigest": "sha-256:fictional"
}
```

Allowed inventory relations are closed: `CONTAINS`, `CONFIGURES`, `EXECUTES`, `SCHEDULES`, `TRIGGERS`, `READS`, `WRITES`, `AUTHENTICATES_AS`, `CONNECTS_TO`, `EXPORTS_TO`, `IMPORTS_FROM`, `JOINS_TO`, `PRODUCES`, `CONSUMES`, `DEPENDS_ON`, `CALLS`, `SUPERSEDES`, and `CONFLICTS_WITH`.

An edge MUST cite at least one observation. A cross-realm edge is invalid. `AUTHENTICATES_AS`, `WRITES`, `EXECUTES`, and `EXPORTS_TO` are high-risk relations and require either direct static/configuration evidence or runtime evidence; interview-only assertion cannot create them as fact.

## 5.5 Evidence observation and provenance

```json
{
  "contract": "uam.legacy-discovery.evidence-observation",
  "version": "1.0.0",
  "observationId": "019d0000-0000-7000-8000-000000002211",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "runId": "019d0000-0000-7000-8000-000000002230",
  "adapterId": "sql.agent.v1",
  "targetAlias": "hmac256:fictional-target",
  "evidenceKind": "CONFIGURATION",
  "subjectNodeId": "019d0000-0000-7000-8000-000000002210",
  "assertionCode": "JOB_STEP_CONTAINS_DYNAMIC_SQL",
  "result": "PRESENT",
  "observedAtUtc": "2026-08-01T09:00:00Z",
  "sourceTimeRange": null,
  "clockQuality": "SYNCHRONIZED",
  "coverageLimitCodes": ["AGENT_HISTORY_RETENTION_UNKNOWN"],
  "parserProfileId": "TSQL_STATIC_V1",
  "sourceArtifactDigest": "sha-256:fictional-restricted-source",
  "sanitizationProfileId": "DISCOVERY_SANITIZED_V1",
  "contentDigest": "sha-256:fictional"
}
```

`sourceArtifactDigest` may refer to a restricted local artifact but MUST NOT permit low-entropy reverse lookup. Where a digest would enable enumeration, use a keyed local alias and retain the original only in the separately governed restricted evidence store.

**RECOMMENDATION.** Provenance aligns with W3C PROV concepts—entity, activity, agent, derivation, generation, and attribution—but uses a smaller closed UAM schema so no arbitrary source payload is imported. [W40–W41]

## 5.6 Read-only command and query interface

The logical CLI surface is fixed:

```text
uam-legacy-discovery validate-scope   --scope-ref <opaque>
uam-legacy-discovery inventory         --scope-ref <opaque> --adapter-id <closed-id>
uam-legacy-discovery parse-artifacts   --run-ref <opaque>
uam-legacy-discovery build-graph       --run-ref <opaque>
uam-legacy-discovery verify-pack       --package <local-private-path>
uam-legacy-discovery compare-runs      --prior <pack> --current <pack>
uam-legacy-discovery coverage          --package <pack> --window-ref <opaque>
uam-legacy-discovery disposition-check --package <pack>
uam-legacy-discovery cleanup            --run-ref <opaque>
```

The path arguments above identify local tool-owned directories only; the operator cannot supply source-system paths. There is no `--sql`, `--script`, `--command`, `--url`, `--host`, `--credential`, `--module`, or plugin parameter.

Each adapter returns one of:

```text
SUCCESS_COMPLETE
SUCCESS_PARTIAL
NOT_APPLICABLE
UNREACHABLE
ACCESS_DENIED
UNSUPPORTED_VERSION
UNSUPPORTED_CONFIGURATION
LIMIT_EXCEEDED
CANCELLED
SAFETY_HOLD
INTERNAL_ERROR_SAFE
```

`SUCCESS_PARTIAL` MUST list finite coverage limitations. `ACCESS_DENIED`, `UNREACHABLE`, `UNSUPPORTED_*`, `LIMIT_EXCEEDED`, and `INTERNAL_ERROR_SAFE` never become absence.

## 5.7 Mandatory artifact — consumer, credential, and buffer traceability model

### 5.7.1 Consumer model

```json
{
  "contract": "uam.legacy-discovery.consumer-record",
  "version": "1.0.0",
  "consumerId": "019d0000-0000-7000-8000-000000002240",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "consumerClass": "SCHEDULED_REPORT",
  "consumerAlias": "hmac256:fictional-consumer",
  "interfaceClasses": ["SQL_READ", "FILE_EXPORT"],
  "inputNodeIds": ["019d0000-0000-7000-8000-000000002241"],
  "outputClass": "AGGREGATE_REPORT",
  "runtimeEvidenceState": "PRESENT_WITHIN_WINDOW",
  "ownerState": "UNASSIGNED",
  "purposeState": "UNKNOWN",
  "criticalityState": "UNDECIDED",
  "dispositionState": "INVESTIGATE_QUARANTINE",
  "traceCompleteness": "INCOMPLETE",
  "contentDigest": "sha-256:fictional"
}
```

`consumerClass` is closed: `ENDPOINT_AGENT`, `SQL_MODULE`, `SQL_AGENT_JOB`, `REPORT`, `REPORT_SUBSCRIPTION`, `PSU_ENDPOINT`, `PSU_SCRIPT`, `PSU_JOB`, `EXPORT_PIPELINE`, `INTEGRATION_SERVICE`, `MANUAL_QUERY`, `MANUAL_SPREADSHEET`, `SUPPORT_WORKFLOW`, `UNKNOWN_ADHOC`, or `OTHER_FIXED_V1`.

### 5.7.2 Credential observation

```json
{
  "contract": "uam.legacy-discovery.credential-observation",
  "version": "1.0.0",
  "credentialReferenceId": "019d0000-0000-7000-8000-000000002250",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "locatorAlias": "hmac256:fictional-credential-location",
  "credentialClass": "SQL_CREDENTIAL_REFERENCE",
  "storageClass": "DATABASE_METADATA",
  "principalClass": "SERVICE_IDENTITY",
  "scopeClass": "INSTANCE_OR_EXTERNAL_RESOURCE",
  "exportabilityClass": "UNKNOWN",
  "secretPresent": true,
  "secretRead": false,
  "lastUseEvidenceClass": "CONFIGURATION_ONLY",
  "sharednessClass": "UNKNOWN",
  "rotationState": "UNKNOWN",
  "ownerState": "UNASSIGNED",
  "incidentState": "NONE",
  "contentDigest": "sha-256:fictional"
}
```

Allowed `credentialClass` values include `WINDOWS_SERVICE_ACCOUNT_REFERENCE`, `SCHEDULED_TASK_LOGON_REFERENCE`, `SQL_LOGIN_REFERENCE`, `SQL_CREDENTIAL_REFERENCE`, `SQL_AGENT_PROXY_REFERENCE`, `PSU_APP_TOKEN_REFERENCE`, `PSU_SECRET_VARIABLE_REFERENCE`, `CERTIFICATE_KEY_REFERENCE`, `FILE_EMBEDDED_SECRET_INDICATOR`, `CONNECTION_STRING_INDICATOR`, and `UNKNOWN_SECRET_INDICATOR`.

The discovery output records whether a secret appears to exist and the security/ownership questions it creates. It MUST NOT read or prove the value. SQL Server credentials can map a login to an external identity and contain authentication information; only metadata and approved classes are inventoried. [W14]

### 5.7.3 Buffer observation

```json
{
  "contract": "uam.legacy-discovery.buffer-observation",
  "version": "1.0.0",
  "bufferId": "019d0000-0000-7000-8000-000000002260",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "locatorAlias": "hmac256:fictional-buffer",
  "bufferClass": "DEFERRED_EXECUTABLE_SQL_CSV",
  "formatClass": "CSV",
  "recordCountBucket": "ONE_TO_TEN",
  "byteSizeBucket": "SMALL",
  "oldestAgeBucket": "OLDER_THAN_APPROVED_WINDOW",
  "newestAgeBucket": "RECENT_WITHIN_WINDOW",
  "contentCapabilityFlags": ["EXECUTABLE_TEXT", "POTENTIAL_ACTIVITY", "POTENTIAL_SECRET"],
  "parserResult": "STRUCTURE_ONLY",
  "executionState": "NEVER_EXECUTED_BY_DISCOVERY",
  "migrationEligibility": "BLOCKED",
  "incidentState": "NONE",
  "contentDigest": "sha-256:fictional-metadata-only"
}
```

Allowed buffer classes are `DEFERRED_EXECUTABLE_SQL_CSV`, `MINIMIZED_TYPED_EVENT_BUFFER`, `RAW_ACTIVITY_BUFFER`, `EXPORT_STAGING`, `ERROR_RETRY_FILE`, `UNKNOWN_FILE_QUEUE`, and `OTHER_FIXED_V1`. Any `EXECUTABLE_TEXT`, `RAW_ACTIVITY`, `SECRET`, `UNKNOWN_FORMAT`, or mixed-realm indicator forces `INVESTIGATE_QUARANTINE` and blocks migration/removal until a separately approved treatment exists.

### 5.7.4 Traceability graph

The mandatory trace node types are:

```text
LegacyEvidence
LegacyBehavior
LegacyConsumer
LegacyReport
LegacyScript
LegacySchedule
LegacyCredential
LegacyBuffer
LegacyIntegration
Requirement
NewComponent
Contract
Test
MigrationStep
RollbackStep
Owner
Disposition
RemovalProof
Risk
HumanDecision
```

The mandatory trace edge types are:

```text
EVIDENCES
DEPENDS_ON
READS
WRITES
AUTHENTICATES_AS
SCHEDULED_BY
PRODUCES
CONSUMED_BY
PRESERVED_AS
REPLACED_BY
TESTED_BY
MIGRATED_BY
ROLLED_BACK_BY
OWNED_BY
REMOVED_BY
BLOCKED_BY
CONFLICTS_WITH
```

Normative trace rules:

1. Every legacy behavior MUST have at least one `EVIDENCES` edge and one disposition revision.
2. `PRESERVE_APPROVED_OUTCOME` and `DELIBERATELY_CHANGE` MUST connect to a requirement, new component, contract, validation test, migration step, rollback step, and owner.
3. `RETIRE` MUST connect to an accountable owner, approved observation/validation window, dependent-consumer resolution, rollback/re-enable step, removal proof, and post-removal observation.
4. `INVESTIGATE_QUARANTINE` MUST connect to an open risk/question and MUST block migration and removal.
5. A credential MUST connect to every known consumer/use path, owner state, replacement/retirement treatment, rotation/revocation action, and incident state.
6. A buffer MUST connect to its producer, consumer, data/execution class, migration treatment, and cleanup proof.
7. A report/export/integration MUST connect to its input facts, destination/recipient class, owner, purpose state, retention/deletion capability, replacement, and rollback.
8. No edge crosses a realm. Product-global evidence is a separate explicitly typed scope.
9. A graph revision is immutable. Corrections create superseding nodes/edges and preserve the original evidence.

## 5.8 Coverage claim contract

```json
{
  "contract": "uam.legacy-discovery.coverage-claim",
  "version": "1.0.0",
  "claimId": "019d0000-0000-7000-8000-000000002270",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "subjectClass": "SQL_CONSUMER",
  "subjectNodeId": "019d0000-0000-7000-8000-000000002240",
  "claimState": "NOT_OBSERVED_IN_SCOPE",
  "confidence": "LOW",
  "populationCoverage": "PARTIAL",
  "staticCoverage": "COMPLETE_FOR_DECLARED_ROOTS",
  "configurationCoverage": "PARTIAL",
  "runtimeCoverage": "NOT_AVAILABLE",
  "timeCoverage": "INSUFFICIENT",
  "ownerEvidence": "MISSING",
  "networkCoverage": "POINT_IN_TIME_ONLY",
  "dataCoverage": "METADATA_ONLY",
  "contradictionState": "NONE_OBSERVED",
  "unreachableCountClass": "NONZERO",
  "limitationCodes": ["QUERY_STORE_DISABLED", "OWNER_UNASSIGNED"],
  "validThroughUtc": "2026-08-08T00:00:00Z",
  "contentDigest": "sha-256:fictional"
}
```

The only claim states are `PRESENT`, `NOT_OBSERVED_IN_SCOPE`, `UNKNOWN`, and `CONTRADICTORY`. `NOT_OBSERVED_IN_SCOPE` is never rendered or exported as “unused,” “absent,” “safe to remove,” or “zero risk.”

## 5.9 Disposition item contract

```json
{
  "contract": "uam.legacy-discovery.disposition-item",
  "version": "1.0.0",
  "dispositionId": "019d0000-0000-7000-8000-000000002280",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "subjectNodeId": "019d0000-0000-7000-8000-000000002240",
  "decision": "INVESTIGATE_QUARANTINE",
  "decisionRevision": 1,
  "ownerState": "UNASSIGNED",
  "purposeState": "UNKNOWN",
  "criticalityState": "UNDECIDED",
  "validationState": "NOT_STARTED",
  "rollbackState": "NOT_DEFINED",
  "removalProofState": "NOT_APPLICABLE",
  "blockerCodes": ["DYNAMIC_SQL_UNRESOLVED", "OWNER_UNASSIGNED"],
  "authorityReference": null,
  "contentDigest": "sha-256:fictional"
}
```

The discovery tool may propose a disposition based on deterministic rules, but `PRESERVE_APPROVED_OUTCOME`, `DELIBERATELY_CHANGE`, and `RETIRE` do not become approved until the accountable human function records authority. The safe default is `INVESTIGATE_QUARANTINE`.

## 5.10 Interview response contract

Interview content is structured to minimize free text:

```json
{
  "contract": "uam.legacy-discovery.interview-response",
  "version": "1.0.0",
  "responseId": "019d0000-0000-7000-8000-000000002290",
  "realmId": "019d0000-0000-7000-8000-000000002202",
  "interviewGuideId": "CONSUMER_OWNER_V1",
  "subjectNodeId": "019d0000-0000-7000-8000-000000002240",
  "respondentFunctionClass": "SERVICE_OWNER_CANDIDATE",
  "assertions": [
    {"questionCode": "CURRENT_USE", "answerCode": "UNKNOWN"},
    {"questionCode": "FAILURE_CONSEQUENCE", "answerCode": "OWNER_REVIEW_REQUIRED"}
  ],
  "supportingEvidenceRefs": [],
  "recordedAtUtc": "2026-08-01T11:00:00Z",
  "verifiedState": "UNVERIFIED",
  "contentDigest": "sha-256:fictional"
}
```

Free text, when unavoidable, remains in a separately access-controlled case system and is not copied into the shareable package. The package records a digest/reference and finite assertion codes.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Scope and run state machine

```text
DRAFT_SCOPE
  -> REVIEW_PENDING
  -> APPROVED_NOT_YET_VALID
  -> ACTIVE
       -> RUN_CREATED
       -> TARGET_RESOLVED
       -> PRECHECKED
       -> COLLECTING
       -> PARSING
       -> SANITIZING
       -> VERIFYING
            -> PUBLISHED
            -> SAFETY_HOLD
       -> CANCELLED
       -> FAILED_SAFE
  -> EXPIRED
  -> REVOKED
```

Rules:

1. Only exact approved bytes enter `ACTIVE`.
2. A run binds one scope digest, tool/release digest, schema bundle, adapter versions, target-set revision, clock state, and sanitization profile.
3. A scope expiry/revocation prevents new work and publication. A run already collecting stops at the next safe boundary and cleans its working set.
4. A raw/secret canary hit, cross-realm mapping, query-pack mismatch, mutation observation, or package-hash conflict enters `SAFETY_HOLD`.
5. `FAILED_SAFE`, `CANCELLED`, and `SAFETY_HOLD` preserve minimal failure evidence but publish no ordinary inventory package.

## 6.2 Evidence observation lifecycle

```text
SOURCE_IDENTIFIED
  -> ACCESS_CHECKED
       -> UNREACHABLE / ACCESS_DENIED / UNSUPPORTED
       -> READ_STARTED
          -> READ_COMPLETE
          -> READ_PARTIAL
          -> READ_FAILED_SAFE
  -> PARSED
       -> CLASSIFIED
       -> UNCLASSIFIED_QUARANTINE
  -> SANITIZED
       -> SCHEMA_VALIDATED
       -> CANARY_VALIDATED
       -> HASHED
       -> PUBLISHED
```

A partial read cannot become `COMPLETE`. Parser errors do not cause execution or permissive fallback. Unknown format or unsupported language is quarantined and blocks any dependent retirement claim.

## 6.3 Disposition lifecycle

```text
DISCOVERED
  -> TRIAGE_PENDING
  -> INVESTIGATE_QUARANTINE
       -> EVIDENCE_COMPLETE_PENDING_OWNER
       -> PRESERVE_APPROVED_OUTCOME
       -> DELIBERATELY_CHANGE
       -> RETIRE_CANDIDATE
  -> VALIDATION_PENDING
       -> VALIDATED
       -> FAILED_VALIDATION
  -> MIGRATION_OR_RETIREMENT_SCHEDULED
  -> EXECUTED
  -> PARALLEL_OR_DARK_VALIDATION
       -> ACCEPTED
       -> ROLLED_BACK
  -> REMOVAL_PROOF_PENDING
  -> CLOSED
```

A content, dependency, owner, purpose, target, or requirement change invalidates prior approval and returns the item to `INVESTIGATE_QUARANTINE` or `VALIDATION_PENDING`. `RETIRE_CANDIDATE` is not removal authority.

## 6.4 Credential incident lifecycle

```text
REFERENCE_OBSERVED
  -> CLASSIFIED_NO_VALUE_READ
  -> OWNER_AND_USE_MAPPING_PENDING
       -> ACTIVE_REPLACEMENT_REQUIRED
       -> RETIREMENT_CANDIDATE
       -> UNKNOWN_QUARANTINE

Any value/raw escape or unauthorized read:
  -> SUSPECTED_EXPOSURE
  -> COLLECTION_STOPPED
  -> EVIDENCE_ISOLATED
  -> INCIDENT_TRIAGE
       -> ROTATION_OR_REVOCATION_REQUIRED
       -> NO_SECRET_EXPOSED_PROVED
  -> CONTAMINATED_ARTIFACT_PURGED
  -> CANARY_AND_ACCESS_REVALIDATED
  -> APPROVED_RESUME or CLOSED
```

The discovery process does not decide incident severity or rotation necessity. It supplies evidence to the accountable security/credential owner and remains stopped until that authority records the outcome.

## 6.5 Removal and rollback lifecycle

```text
RETIRE_APPROVED
  -> PRE_REMOVAL_BASELINE_CAPTURED
  -> DEPENDENT_CONSUMERS_VALIDATED
  -> ROLLBACK_READY
  -> DISABLE_OR_ISOLATE (preferred before destructive delete)
  -> OBSERVATION_WINDOW
       -> FAILURE_OR_USE_OBSERVED -> ROLLBACK
       -> NO_USE_OBSERVED_IN_SCOPE
  -> REMOVE
  -> POST_REMOVAL_VALIDATION
       -> FAILURE -> RESTORE/ROLLBACK
       -> PASS
  -> REMOVAL_PROOF_PUBLISHED
  -> CLOSED
```

Destructive removal SHOULD follow a reversible disable/isolation period where technically possible. The exact window is a **HUMAN DECISION** informed by business cycles and telemetry retention. A rollback must restore the prior approved behavior, not merely files or database objects.

## 6.6 Transaction and publication boundaries

### 6.6.1 Source reads

- Endpoint reads are independent observations; no global atomic snapshot of services, tasks, files, registry, processes, and network is claimed.
- SQL metadata query groups SHOULD run under one bounded connection/session and record database time before/after, isolation level, permissions, database state, and query-group outcomes. A transaction snapshot MAY be used only where supported and proved not to create unacceptable blocking or version-store pressure; otherwise each result records its own observation interval.
- Query Store/XE/Agent history is historical evidence with its own source interval and retention/capture limitations; it is not combined into a fictitious atomic state.
- PSU repository revision and runtime API revision are independently recorded. A mismatch becomes a contradiction.

### 6.6.2 Local evidence staging

The evidence writer creates a new private staging directory. It appends observations only through the typed writer, then closes files, validates line counts/schemas, scans canaries, computes hashes, writes `package-root.json`, fsyncs/flushes according to the selected platform profile, and atomically renames the complete directory into a published location. Publication failure leaves no partially authoritative pack.

A rerun creates a new `runId` and package revision. It never overwrites a prior package or first failure.

### 6.6.3 Graph and disposition revisions

Inventory/evidence/trace nodes are immutable. A correction or later observation creates a superseding node or edge and an explicit relation. Dispositions are immutable revisions. Approval references bind the exact graph root and disposition digest so later evidence cannot inherit stale approval.

## 6.7 Mandatory artifact — coverage and confidence method

### 6.7.1 Coverage dimensions

Every claim is evaluated across these independent dimensions:

| Dimension | Complete means | Common failure/limit |
|---|---|---|
| Population | Every target in the approved authoritative population has a terminal collection state, and duplicates/retired records are reconciled. | Unreachable, stale CMDB, duplicate imaging, unknown off-network endpoints. |
| Static artifact | All approved source/repository/database object roots were enumerated and parsed, with unsupported/encrypted artifacts explicit. | Dynamic construction, encrypted modules, external source, unscanned history. |
| Configuration | Services, tasks, schedules, jobs, reports, credentials, firewall/integration configuration were read under sufficient metadata visibility. | Permission-filtered metadata, hidden product stores, stale configuration. |
| Runtime | Existing telemetry covers the declared behavior class and records capture mode, start/end, resets, rollover, retention, and loss. | Telemetry disabled, filtered, purged, restarted, overloaded, or missing ad-hoc channel. |
| Time | The observation interval covers every approved business/maintenance/seasonal cycle relevant to the item. | Month/quarter/year-end, incident-only/manual run, holidays, outages. |
| Owner/operator | An accountable owner or operator has reviewed the exact item/graph and supplied evidence for purpose/use/failure consequence. | No owner, departed knowledge, assertion without evidence, conflicting owners. |
| Network/export | Fixed routes, current connections, firewall paths, export manifests, connector/subscription state, and manual handoffs are represented. | Point-in-time snapshot, encrypted traffic, unmanaged copies, recipients outside control. |
| Data/schema | Physical and implicit joins, identifiers, aggregates, report inputs, and expected outputs are represented without raw data. | Semantics hidden in code/manual process, weak FKs, undocumented data dictionary. |
| Realm/isolation | Every node/edge is realm-bound and negative tests prove no cross-realm inference or merge. | Shared account/database/path, ambiguous realm, product-global artifact. |
| Evidence integrity | Tool/scope/schema/source digests, clocks, permissions, failures, canaries, and cleanup are complete and independently verified. | Mutable evidence, missing first failure, scanner miss, clock uncertainty. |

### 6.7.2 Confidence classification

Confidence is qualitative and deterministic:

- **High** — the relevant dimensions are complete for the exact claim; at least two independent evidence classes agree; no material contradiction; no unreachable target affecting the claim; owner evidence is verified where business use matters; evidence is current.
- **Medium** — the item is positively observed or strongly bounded, but one non-critical dimension is partial, owner evidence is provisional, or runtime coverage is narrower than the business cycle. It may guide investigation or migration design but cannot by itself authorize retirement.
- **Low** — one evidence class only, material coverage gaps, stale evidence, unverified assertion, no owner, no runtime evidence for a dynamic consumer, or any unreachable population affecting the claim.

Any contradiction, cross-realm ambiguity, secret/raw incident, unsupported parser, unknown dynamic SQL, or missing authoritative population forces the affected claim to `CONTRADICTORY` or `UNKNOWN` regardless of other evidence. No numerical confidence percentage is produced.

### 6.7.3 Bounded absence rule

A claim may be `NOT_OBSERVED_IN_SCOPE` only when:

1. the exact subject class and scope are declared;
2. every in-scope target has a terminal collection state;
3. static/configuration roots are complete or their limits are listed;
4. runtime evidence is either complete for the declared interval or explicitly unavailable;
5. the interval and business cycles are stated;
6. metadata visibility and capture settings are recorded;
7. no contradictory owner/runtime/static evidence exists;
8. unreachable/unsupported targets are counted and shown to not affect the claim—or the claim remains low confidence;
9. the evidence validity date has not expired.

`NOT_OBSERVED_IN_SCOPE` alone never satisfies the retirement gate. Retirement adds owner approval, criticality decision, parallel/dark validation, rollback, and post-removal proof.

## 6.8 Dynamic SQL and ad-hoc consumer rules

1. Static string fragments, concatenation, `EXEC`, `sp_executesql`, provider/linked-server calls, PowerShell `Invoke-Sqlcmd`, ADO.NET command construction, report expressions, and PSU script-generated SQL are classified as dynamic-capability evidence.
2. The parser records operation families, referenced literal object aliases, parameterization indicators, source/sink classes, and unresolved construction—not raw SQL.
3. Runtime query text, when already captured and approved, is parsed locally and reduced to a semantic fingerprint. Raw text is not published.
4. Static and runtime fingerprints are linked only when the parser/profile and evidence establish a non-ambiguous match. Similar text is not identity.
5. Dynamic construction that cannot be resolved remains `UNKNOWN_DYNAMIC_PATH` and forces `INVESTIGATE_QUARANTINE`.
6. Ad-hoc client/program/login names are hints. Owner confirmation and authenticated configuration are required before assigning a consumer identity.
7. No deferred or discovered SQL is executed to validate it.

## 6.9 Rollout rules

| Stage | Scope | Allowed evidence | Exit gate | Stop condition |
|---|---|---|---|---|
| R0 — pure/offline | fictional files, schemas, ASTs, graphs | T1 only | parser/schema/canary/property gates | any production-derived value or execution path |
| R1 — synthetic lab | disposable Windows, SQL Server, PSU with fictional identities/data | full fixed adapters and faults | zero mutation, exact truth, cleanup | mutation, raw escape, parser/query mismatch, residue |
| R2 — one approved target per class | one non-production endpoint, DB, PSU repository/API | read-only sanitized package | owner review; expected evidence/limits match | unexpected permission, load, mutation, secret/raw handling, cross-realm ambiguity |
| R3 — representative approved wave | bounded target set covering declared variants | same contracts, no new fields | population reconciliation, resource/operations evidence | scanner miss, excessive load, unresolved target mismatch, support gap |
| R4 — estate discovery | approved authoritative population | immutable package per run/wave | aggregate evidence current; all failures represented | hidden exclusions, unassigned safety incident, package mismatch |
| R5 — parallel validation | only items with approved preserve/change/retire plans | new/legacy outcome comparisons; no silent cutover | trace path, acceptance, rollback drill | material semantic difference, consumer failure, unknown owner |
| R6 — cutover/removal | separately approved migration plan | minimum operational evidence | post-cutover/removal proof | any primary invariant failure or rollback unavailable |

A stage pass applies only to the exact tool, adapter, target/platform/database/PSU version, scope, permissions, parser, and evidence profile tested.

## 6.10 Compatibility rules

1. Each adapter declares exact supported Windows/PowerShell/.NET, SQL Server, database compatibility level, PSU, schema/API, file-format, and parser profiles.
2. Unknown, newer incompatible, older unsupported, encrypted, malformed, or partially visible sources fail closed as `UNSUPPORTED_*` or `SUCCESS_PARTIAL`.
3. No “closest version,” major-only, or generic SQL/PowerShell compatibility claim is permitted.
4. A parser/library upgrade runs the complete golden/adversarial/canary/differential corpus. Semantic differences create a new profile and invalidate prior equivalence until reviewed.
5. Evidence packages preserve exact tool/package/source identities. Architecture does not hardcode point patches as timeless requirements.
6. The consumer-first rule applies: graph validators, reviewers, and importers support the new contract before the collector emits it.
7. Evidence validity expires on target/source version change, telemetry reset/capture-mode change, repository revision, permission change, parser profile change, material owner/consumer change, incident, or the declared review date.

## 6.11 Mandatory artifact — disposition backlog and stop conditions

| Backlog state | Required evidence before entry | Required work | Exit condition | Stop condition |
|---|---|---|---|---|
| `NEW_UNTRIAGED` | observed node/evidence | assign triage function; identify class and risk flags | finite class and initial evidence limits | raw/secret incident or cross-realm ambiguity |
| `INVESTIGATE_QUARANTINE` | any unknown/contradiction/high-risk capability | collect missing static/runtime/config evidence; interviews; resolve owner and purpose | contradiction resolved and trace minimum complete | dynamic SQL/script unresolved, owner absent, secret unknown, unreachable material population |
| `PRESERVE_CANDIDATE` | approved outcome/purpose need, evidence of current use | write requirement and target contract; define minimum semantics/privacy | owner approves `PRESERVE_APPROVED_OUTCOME` | copying implementation/direct SQL/secret/arbitrary script proposed |
| `CHANGE_CANDIDATE` | current behavior known and approved need differs | document deliberate semantic/privacy/operational change; impact and appeals | owner approves `DELIBERATELY_CHANGE` | unacknowledged loss of consumer/business outcome or no rollback |
| `RETIRE_CANDIDATE` | coverage complete enough for exact claim; dependents resolved | dark/disable plan, observation window, rollback, communication/support | accountable retirement approval | any unknown dependent, owner missing, insufficient business-cycle coverage, unreachable affected target |
| `VALIDATION_PENDING` | target component/contract/test plan linked | run synthetic and parallel validation; reconcile outputs and failures | acceptance evidence and rollback drill pass | semantic mismatch, privacy escape, duplicate/lost effect, support failure |
| `CUTOVER_READY` | complete trace path and approvals | execute separately authorized migration/cutover plan | stable accepted outcome through observation window | stale evidence, changed dependency, rollback unavailable |
| `REMOVAL_PROOF_PENDING` | reversible disable and observation passed | remove, inventory again, verify no use/error/backlog, preserve minimal proof | owner/verifier accept proof | new use/failure, residue, hidden copy, inconsistent graph |
| `CLOSED` | all mandatory edges/evidence and no open blocker | retain minimum governed evidence until approved expiry | expiry/deletion proof | later contradictory evidence reopens item |

**Primary stop rule.** No item may enter `CUTOVER_READY`, destructive removal, or `CLOSED` while any mandatory trace edge is missing, any owner/purpose/criticality decision is unresolved, any material target is unreachable, any contradiction is open, or rollback is untested.

---

# 7. Security/privacy threat and failure register

The register below is normative for this discovery lane. “Owner” names an accountable function, not an assigned person.

| ID | Threat/failure and trigger | Detection | Containment | Recovery | Cleanup/evidence | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T22-01 | **Scope tamper or expiry:** local scope bytes, adapter list, target set, approval, or time window differs from the authorized revision. | Signature/digest/sequence/time verification; compare local target-set revision; startup self-check. | Refuse all source access; record finite `SCOPE_INVALID`; no partial inventory. | Obtain a newly approved immutable scope; never edit the old scope in place. | Preserve invalid digest and safe reason; delete unresolved local target material. | Discovery Governance + Security | Mutate every field/signature/time boundary; prove zero adapter invocation. | Compromised signing/approval authority can authorize harmful scope. |
| T22-02 | **Wrong target or cross-realm target resolution:** opaque target maps to another realm, duplicate asset, stale address, or changed host. | Realm/asset-class binding, independent target identity checks, target-set membership, negative fixture matrix. | Stop that target; hold the run if any evidence may have mixed. | Correct authoritative population/target mapping; rerun from clean staging. | Purge mixed package/working set; retain minimal incident digest/counts. | Asset/Realm Authority + Discovery Engineering | Realm collision, stale DNS/address, cloned endpoint, duplicate database alias tests. | Enterprise inventories can remain stale or wrong despite checks. |
| T22-03 | **Arbitrary code path introduced:** plugin loading, shell, dynamic assembly, reflection-discovered adapter, tenant script, or caller command becomes reachable. | Architecture tests, allowlisted CLI grammar, binary dependency/file manifest, mutation tests, code review. | Build/release block; runtime refuses unknown adapter/command. | Remove path; rotate/revoke any affected release; rerun admission and hostile tests. | Preserve source/binary diff and failure; prove production artifact lacks test hooks. | Product Security + Repository/Release | Inject plugin, `Process.Start`, runspace, `Assembly.Load`, arbitrary SQL/path; all must fail CI. | A malicious authorized release can still contain hidden code. |
| T22-04 | **SQL mutation or side effect:** query pack contains DDL/DML/EXEC, implicit write, unsafe function, lock escalation, or provider side effect. | AST allowlist/denylist, reviewed immutable query IDs, least privilege, before/after metadata/log checks, database audit in lab. | Cancel connection; revoke discovery login if needed; stop run. | Restore lab/production state through approved DBA process; correct query pack and permissions. | Capture exact query ID/digest, transaction/log evidence, affected objects; delete contaminated pack. | Database Security/Reliability | One mutation per forbidden family; malicious identifier; stored-procedure call; prove rejection and zero change. | Read-only metadata functions can still consume resources or expose sensitive definitions. |
| T22-05 | **SQL metadata invisibility:** insufficient permission returns empty/partial catalog rows, leading to false absence. | Effective-permission inventory; known-positive canary objects; compare privileged lab oracle; source returns `SUCCESS_PARTIAL`. | Downgrade claims to `UNKNOWN`/low confidence; block retirement. | Obtain approved minimum visibility or isolated metadata source; rerun. | Record hidden-row indicators, grants class, canary result, and limitation. | Database Owner + Discovery Evidence Owner | Deny `VIEW DEFINITION`, encrypt module, hide cross-database dependency; verify no absence claim. | SQL Server metadata rules and ownership chains can be subtle and version-specific. |
| T22-06 | **Parser exploitation or differential:** malformed PowerShell/T-SQL/XML/JSON/CSV causes crash, resource exhaustion, or permissive classification. | Fuzzing, allocation/time limits, independent corpora, parser-version inventory, watchdog, canary AST cases. | Kill parser process/job; mark artifact `UNCLASSIFIED_QUARANTINE`; continue only if isolation proved. | Patch/pin parser; rerun all prior artifacts and differential corpus. | Retain minimized reproducer, parser/build digest, first failure; delete raw artifact copy after approved handling. | Secure Coding/Parser Owner | Deep nesting, token bombs, invalid encodings, interpolation, alternate streams, parser differential. | Parser libraries can have undisclosed vulnerabilities and semantic gaps. |
| T22-07 | **External entity/reference/archive traversal:** configuration parser fetches network/file resources, expands entities, formulas, macros, or paths outside staging. | Network-denied parser sandbox; disabled resolvers; file-open trace; archive path validation; positive controls. | Stop parser; isolate target artifact; security incident if egress or file access occurred. | Fix parser profile; invalidate affected evidence; rerun in disposable environment. | Preserve finite accessed-resource classes and canary results; remove extracted residue. | Application Security | XXE, billion laughs, remote `$ref`, zip slip, symlink, formula/macro fixtures. | Native/third-party libraries may perform hidden resource access. |
| T22-08 | **Source TOCTOU/substitution:** endpoint file, task XML, repository, SQL module, or PSU config changes between identity, read, and hash. | Open-handle/final-path checks where available; pre/post identity/digest/revision; repository commit binding; database time/version evidence. | Mark observation `CONTRADICTORY` or `READ_PARTIAL`; do not merge versions. | Rerun under a stable maintenance/read window or capture distinct revisions explicitly. | Record both digests/revisions and interval; no overwrite. | Discovery Engineering + Source Owner | Rename/replace/reparse/race fixtures and concurrent repository/database changes. | Some sources lack stable snapshot APIs; exact simultaneity is unprovable. |
| T22-09 | **Secret read or output escape:** token, password, private key, credential identity, connection string, provider secret, or low-entropy secret derivative enters memory outside classifier or package/log. | Exact secret canaries, schema allowlist, entropy/pattern secondary scanners, API type restrictions, all-sink scan, access tracing. | Immediate `SAFETY_HOLD`; stop collection/publication; restrict package/runner access. | Incident triage; rotate/revoke if exposure cannot be disproved; rebuild from clean environment. | Purge contaminated files/logs/caches; retain minimal incident shell/digests; prove canary detection and deletion. | Security Incident Response + Credential Owner | Canary in every store/encoding/sink; scanner/config mutation; crash/error path tests. | Scanners can miss unknown secret formats; privileged platform tools may observe memory. |
| T22-10 | **Raw activity or personal/confidential data escape:** URLs, queries with literals, event rows, HR records, user/profile names, report parameters, exports, or script bodies enter evidence. | Type-level source/raw wrappers, schema construction, exact canaries, forbidden-key scanner, review of cardinality/rare values. | Stop and isolate; no share/upload; notify privacy/security authority. | Remove root cause; reclassify/delete contaminated artifacts; rerun from approved source. | Access log, deletion proof, affected-sink inventory, minimum incident evidence. | Privacy/Data Protection + Incident Response | Raw URL/path/person/query literals across exceptions, traces, NDJSON, evidence, metrics, support. | Sanitized aggregates can still enable inference in rare populations. |
| T22-11 | **Dynamic SQL/script false negative:** constructed execution or reflection is classified as harmless/static. | AST semantic rules, taint-like source/sink analysis, mutation corpus, runtime fingerprint comparison, independent manual review for high-risk artifacts. | Force `UNKNOWN_DYNAMIC_PATH` and `INVESTIGATE_QUARANTINE`; no retirement/migration. | Enhance grammar/classifier; rerun all affected artifacts; owner-assisted behavior mapping. | Record parser profile, unresolved nodes, minimal safe witness/digest. | Legacy Analysis + Security Review | Concatenation, encoding, aliasing, `Invoke-Expression`, reflection, `sp_executesql`, nested jobs, indirect PSU calls. | General program behavior is not fully decidable; obfuscated paths can remain unknown. |
| T22-12 | **Existing telemetry gap presented as coverage:** Query Store/XE/Audit/Agent history disabled, filtered, reset, purged, rolled over, or capture mode omits work. | Read capture/settings/retention/state/reset times; known-positive synthetic query in lab; compare multiple evidence classes. | Mark runtime dimension partial/unavailable; prohibit absence or retirement inference. | Separate approved instrumentation decision or longer owner/parallel validation. | Record exact capture configuration and time ranges; preserve gap codes. | Database/SRE + Evidence Owner | AUTO/NONE/CUSTOM capture, cleanup, restart, XE loss/rollover, Agent purge fixtures. | Even complete-looking telemetry may omit encrypted, external, or manual behavior. |
| T22-13 | **Discovery overload or production interference:** scans consume CPU/I/O/locks, block jobs, flood network, or trigger EDR. | Per-adapter time/row/byte/resource budgets; server/endpoint resource observation; cancellation; low concurrency; synthetic stress. | Cancel adapter; open circuit for target class; no automatic aggressive retry. | Reschedule/narrow scope; tune fixed query/parser with evidence; obtain operations approval. | Record offered work, actual duration/resources, cancellation outcome, and no residue. | SRE/Endpoint/Database Operations | Large catalogs, deep scripts, busy DB, slow share, EDR delay; prove bounded termination. | Some metadata reads can have unpredictable cost on very large/fragmented systems. |
| T22-14 | **Unbounded retry/reconnect:** unreachable or failing targets are hammered, creating load or lockouts. | Finite retry taxonomy, attempt ledger, per-target budget, circuit breaker, metrics. | Stop after approved bound; state remains `UNREACHABLE`/`UNKNOWN`. | Human-directed reschedule or alternate approved path. | Preserve attempt classes/times; no raw addresses; cleanup credentials/sessions. | Discovery Operations | Timeouts, auth failures, DNS churn, offline endpoints, DB failover; verify no retry storm. | Long outages can delay evidence and leave population uncertain. |
| T22-15 | **Credential misuse by collector:** discovery identity has write/admin rights, is shared, exported, cached, or used beyond scope. | Effective-permission capture, dedicated credential reference, token/session expiry, target/audience binding, access logs, no-secret architecture test. | Revoke/disable identity; stop all runs using it; investigate access. | Issue least-privilege replacement; rerun permission and negative tests. | Remove cached token/material; record credential generation and affected runs without value. | IAM/Database/PSU Security | Write attempt, wrong target/realm, expired token, shared token clone, cached-session reuse. | Some platforms cannot express perfect metadata-only privilege separation. |
| T22-16 | **PSU API/action invocation:** adapter accidentally calls a custom endpoint, job/run route, or mutating management operation. | Compile-time URI/method catalogue, GET-only transport, synthetic server asserting no other method/path, repository-first rule. | Stop API adapter; revoke token; hold run. | Correct route catalogue and token permissions; rerun synthetic hostile server tests. | Preserve safe request class/count; no route/token value in pack; clear client state. | PSU Platform Owner + Security | Redirect, method override, hidden POST, GET-with-side-effect endpoint, malicious base URL fixtures. | A product GET endpoint could itself have side effects or expose excess data; exact version testing remains necessary. |
| T22-17 | **Buffer accidentally executed, imported, moved, or consumed:** opening/parsing a CSV/script triggers handler or discovery alters queue semantics. | No shell/file association; open read-only handle; process/file trace; content parser isolated; before/after count/time/digest. | Stop target; preserve source state; incident if queue changed. | Restore affected file/state if possible; correct adapter; rerun only after owner approval. | Source before/after evidence, process trace, cleanup; do not copy content. | Endpoint Reliability + Security | File associations, antivirus/script hooks, lock/rename race, malformed CSV formula, deferred SQL fixtures. | Reading can still alter access-time metadata or trigger security tooling on some systems. |
| T22-18 | **Credential/buffer classification underestimates sensitivity:** unknown format or mixed content marked safe. | Fail-closed unknown class, positive/negative corpus, secondary scanners, owner review. | `INVESTIGATE_QUARANTINE`; no migration/removal/raw copy. | Add explicit profile or decide to retire in place through separate approved process. | Preserve metadata-only evidence and classifier version. | Privacy/Security/Data Owner | Polyglot files, encrypted archives, compressed blobs, mixed rows, embedded connection strings. | Encryption can prevent classification without safe decryption authority. |
| T22-19 | **Alias linkability/re-identification:** stable HMAC alias reused across realms/purposes or low-entropy raw SHA enables guessing. | Key-purpose/realm separation tests, schema review, no raw SHA rule, alias-collision tests. | Stop publication; rotate alias key/profile; invalidate affected packages. | Reissue packages under new profile; delete old packages if policy requires. | Key/profile digest and affected package IDs; never export key/mapping. | Cryptographic/Privacy Architecture | Cross-purpose/realm corpus and dictionary attack simulation. | A local privileged operator with the alias key and source candidates can correlate. |
| T22-20 | **Evidence package tamper, truncation, or substitution:** files/lines changed, omitted, reordered, or mixed across runs. | Per-file hashes, package root, schema/line counts, run/scope binding, independent verifier, immutable storage. | Reject package; no disposition/import. | Restore from known-good package or rerun discovery. | Preserve tamper finding and source package ID; do not “repair” in place. | Evidence/Release Governance | Bit flip, line delete/add, cross-run file swap, manifest edit, duplicate node/edge, stale schema. | SHA-256 integrity does not prove source truth or prevent authorized malicious generation. |
| T22-21 | **First failure or contradictory evidence suppressed:** rerun overwrites failure or UI displays only latest/pass. | Append-only run registry, first-failure links, gate aggregation requiring all runs, contradiction queries. | Gate remains failed/held; no closure. | Investigate and explicitly disposition the failure; rerun is additive. | Preserve all run roots, reviewer decisions, and supersession links. | Verification Governance | Force failure then pass; delete/exclude failure; verify gate still fails. | Human reviewers can still misinterpret or accept weak exceptions. |
| T22-22 | **Unreachable devices hidden from denominator:** inventory exports omit offline/unmanaged/retired-looking endpoints. | Authoritative population reconciliation, terminal state per target, duplicate/retired rules, count/digest comparison. | Coverage remains partial/low; removal blocked for affected behavior. | Decide handling through accountable human process; alternate approved evidence or quarantine. | Population snapshot digest, terminal-state distribution, unresolved aliases. | Asset Management + Product/Risk | Omit targets, stale CMDB, duplicate clones, long-offline endpoints, decommissioned-but-active case. | No technical method can prove behavior on a permanently unreachable device. |
| T22-23 | **Owner interview false, stale, coerced, or overconfident:** assertion is treated as evidence of use/absence/criticality. | Structured answer states, supporting evidence refs, respondent function and date, conflict comparison, independent review. | Keep `PRESENT_ASSERTED_UNVERIFIED` or `UNKNOWN`; no retirement. | Obtain corroboration, alternate owner/operator input, or runtime evidence. | Preserve immutable response and contradiction; protect access to free text. | Business/Data Owner Governance | Conflicting interviews, departed owner, “never used” contradicted by runtime, self-approval. | Human memory and incentives remain fallible. |
| T22-24 | **Manual/ad-hoc consumer remains invisible:** spreadsheet, direct query, copied export, or emergency runbook is not in code/configuration. | Existing workload evidence, access/audit logs where already enabled, report/export inventories, interviews, controlled dark/disable validation. | Classify `UNKNOWN_ADHOC`; retirement blocked. | Owner campaign, longer observation, communication and reversible disablement. | Record limitations and discovered manual workflow without raw recipients/content. | Product/Data Governance + Operations | Synthetic ad-hoc connections, scheduled manual query, month-end spreadsheet, emergency-only consumer. | Unmanaged copies outside UAM control may never be discoverable. |
| T22-25 | **Service-account/shared-login ambiguity:** multiple consumers use one identity or one consumer rotates identities. | Correlate configuration, client/app classes, schedules, query fingerprints, target scope, owner evidence; never identity by login alone. | Keep shared/unknown class; no owner/consumer merge. | Replace with governed service identities during migration; monitor approved transition. | Mapping evidence and conflict state; no account name. | IAM + Application Owners | Shared login across jobs/services, proxy, credential rotation, impersonation. | Legacy platforms may lack enough evidence to disaggregate historic use. |
| T22-26 | **Network/firewall path inference is wrong:** point-in-time connection or rule does not prove intended/historical route; dynamic proxy/VPN/NAT hides path. | Record evidence class/time, configuration plus existing telemetry, exact process binding, owner/network confirmation. | Treat as hint/partial; do not approve migration/removal. | Separate approved network lab/measurement or target integration proof. | Finite route classes and limitations; no addresses. | Network Security/Operations | Connection race, proxy, DNS change, dormant rule, blocked rule, shared process. | Encrypted/middlebox paths can remain opaque. |
| T22-27 | **HR/AD/CMDB join leakage or semantic misclassification:** join keys, people, org structure, or entitlements are exported or inferred incorrectly. | Metadata-only field/key classes, no row values, schema/AST analysis, data-owner interview, synthetic join tests. | Stop that adapter/output; quarantine join; no target identity inference. | Define narrow future integration contract and authoritative field matrix; rerun with approved evidence. | Delete contaminated output; record join-class/digest and incident if values escaped. | Data Governance/IAM/Privacy | Implicit casts, reused IDs, history tables, many-to-many joins, null/duplicate keys, cross-realm data. | Semantics may be encoded in data values or manual conventions unavailable to research. |
| T22-28 | **Observability cardinality/privacy failure:** dynamic identifiers become metric labels or exact rare counts expose assets/users. | Catalogue-based series-bound test, schema review, runtime label enumeration, rare-value suppression. | Disable telemetry/export for run; hold publication if sensitive dimension escaped. | Remove dynamic dimension; aggregate/bucket; invalidate affected evidence. | Preserve metric schema and cardinality proof; delete leaked series under policy. | SRE + Privacy Engineering | Inject target/object/error text into labels; high-cardinality target set; rare count. | Operational troubleshooting is less detailed by design. |
| T22-29 | **Crash dump/log/EDR/pagefile disclosure:** parser/collector memory containing raw text is captured outside UAM controls. | Dumps disabled for process profile where approved, closed logging APIs, no exception text, EDR/support policy inventory, all-sink canaries in lab. | Stop and isolate host/evidence; incident triage if capture occurred. | Reproduce with T1 data; change process/dump policy through accountable authority; rotate secrets if needed. | Remove dumps/support artifacts where authorized; record external-copy limitation. | Endpoint Security/Incident Response | Forced crash, unhandled exception, WER/dump policy, EDR collection, verbose logging. | Kernel/admin/hypervisor/security products can observe process memory. |
| T22-30 | **Cleanup incomplete:** working set, tokens, temp files, parser children, handles, task/service/firewall changes, database sessions, or local alias keys persist. | Before/after inventory, process/handle/file/registry/network diff, key/token disposal checks, disposable VM revert. | Gate failure; quarantine target/runner; no evidence accepted. | Complete cleanup or revert environment; rotate credentials if residue is uncertain. | Signed cleanup receipt and residue diff; preserve failure. | Lab/Discovery Operations | Kill at every phase, disk full, locked file, process orphan, reboot, token cache. | Underlying OS/storage snapshots may retain deleted bytes beyond tool control. |
| T22-31 | **Inaccessible review/workflow causes unsafe decision:** owner cannot perceive state, limitations, contradiction, stop condition, or rollback and uses an inaccessible workaround. | Semantic Markdown/HTML generation, keyboard/screen-reader/zoom/contrast review of disposition UI, machine-readable status, no color-only meaning. | Do not approve the affected workflow; provide accessible alternative within the governed system, not direct DB/spreadsheet bypass. | Fix presentation/workflow; repeat representative task test. | Accessibility evidence and issue linkage; no sensitive screenshots. | Product Accessibility + Governance | Navigate inventory, compare contradictions, approve/reject disposition, inspect rollback/removal proof with keyboard/AT. | Accessibility needs vary; recurring regressions remain possible. |
| T22-32 | **Cost/licensing/support surprise:** selected parser/tool/license or recurring discovery operations are unsustainable or legally incompatible. | Exact dependency/source/license record, TCO/skills inventory, run duration/storage/support evidence, procurement review. | Keep dependency as reference only; block production admission. | Select simpler/admitted implementation; migrate package profile if necessary. | Dependency decision record, SBOM, removal plan, benchmark evidence. | Architecture + Legal/Procurement + Operations | License mutation, transitive package, abandoned project, support outage, operator skill drill. | Future license/security/maintenance changes require recurring review. |

## 7.1 Incident response minimum

**RECOMMENDATION.** Use the NIST SP 800-61 Rev. 3 incident-response lifecycle as current primary guidance, adapted to UAM: prepare; detect/analyze; contain; eradicate; recover; and feed lessons into governance and engineering. [W42]

A discovery incident runbook MUST define:

1. the trigger and automatic stop scope;
2. who may isolate the runner, package, target credential, or adapter;
3. preservation of minimum evidence without copying the sensitive value;
4. access-log review and external-copy inventory;
5. secret rotation/revocation or privacy response decision authority;
6. deletion/quarantine of contaminated packages, logs, caches, dumps, and temporary storage;
7. scanner/parser/query-pack correction and positive-control rerun;
8. reauthorization and exact conditions for resuming collection;
9. neighboring target/package review for common-mode exposure;
10. post-incident ADR, test, and evidence-expiry actions.

## 7.2 Secure coding and review requirements

- Threat-model every adapter and parser as processing attacker-controlled input.
- Use safe typed handles and bounded streams; never concatenate shell/SQL/path expressions.
- Keep unsafe/native interop in one reviewed module with explicit API surface.
- Compile with nullable analysis, analyzers, warnings-as-errors for the governed profile, dependency lock, SBOM/provenance, and architecture tests.
- Require two reviewers for query-pack, sanitizer, alias/key logic, credential/buffer classifier, publication, and scope-verification changes.
- Mutation-test the deny rules and canary scanner; a new parser/tool version cannot be admitted on upstream tests alone.
- Production artifacts MUST structurally exclude fixture secrets, lab credentials, destructive fault controls, test CAs, and arbitrary command helpers.
- A dependency or executable CI action is admitted by exact source/package/binary/license/security identity, not popularity.


---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test evidence rules

Every test run MUST emit a machine-readable record containing:

```text
test/experiment ID and exact assertion
source tree and dirty-state digest
tool, adapter, parser, query-pack, schema, dependency, native binary and OS/runtime identities
scope/target/fixture/evidence-package roots and classification
start/end UTC, clock-quality class and duration
steps/fault schedule and first failure
expected and actual finite outcomes
resource and mutation observations
all-sink canary/scanner identity and positive-control result
cleanup/revert receipt
owner/reviewer functions and ADR/exception references
```

A rerun never overwrites the first failure. A harness failure is neither a product pass nor a product failure; it remains `HARNESS_FAULT` until repaired. All fixtures use fictional identities, reserved domains/addresses where an address is unavoidable inside the isolated lab, and no production-derived activity or configuration.

Durations below are **ESTIMATE** test-budget seeds, not SLOs or production windows.

## 8.2 Detailed test matrix

| ID | Setup and instrumentation | Steps/faults | Pass criteria | Fail/stop criteria | Required evidence | Duration estimate | Cleanup |
|---|---|---|---|---|---|---|---|
| E22-00 — evidence boundary | Clean checkout; hash the six allowlisted project inputs; file-access audit for research build | Build source manifest; attempt to reference an unallowlisted project file in a test | Exact expected files/hashes only; no extra Project input | Missing/changed input or any unallowlisted Project dependency | `input-manifest.json`, hashes, access audit | 5–15 min | Delete temporary copied text; preserve manifest |
| E22-01 — scope/CLI grammar | Signed/test-signed scope fixtures; command parser; adapter catalogue | Mutate realm, target set, times, fields, signature, command/flag; inject path/SQL/script/URL/plugin | Invalid scope/unknown command invokes zero adapter/source access | Any broadened scope or arbitrary input reaches adapter | Invocation trace, scope decisions, zero-access proof | 15–30 min | Remove local scope/target fixtures and keys |
| E22-02 — architecture mutation | Compiled solution with architecture analyzers and binary scan | Add `Process.Start`, runspace, dynamic assembly/plugin, arbitrary SQL/path, network client in wrong module | Every forbidden mutation fails build/test; release artifact has no helper/test hook | One mutation survives or hidden dependency/file ships | Mutation matrix, dependency/file graph, clean-tree proof | 30–60 min | Revert mutations; verify clean checkout |
| E22-03 — PowerShell parser | Fictional benign/malicious scripts; exact PowerShell SDK parser; process sandbox | Parse syntax errors, dynamic invocation, aliases, encoded strings, nested script blocks, modules, reflection, jobs, SQL calls | No execution/network/child; expected capability flags and unresolved cases exact | Any command executes, input escapes, or high-risk path classified safe | AST/token/error fingerprints, process/file/network trace, corpus results | 1–2 h | Destroy sandbox; delete raw fixtures if generated |
| E22-04 — T-SQL parser/query pack | Fictional schema/modules/jobs/reports/deferred SQL; selected parser | Parse every statement family; inject DDL/DML/EXEC/DBCC/external access; obfuscated dynamic SQL | Fixed SELECT pack accepted; all forbidden/unknown constructs rejected or quarantined | Forbidden batch admitted, parser crash, dynamic path marked harmless | Parser vectors, query-pack digest, mutation results | 1–2 h | Drop/revert synthetic DB; remove raw query fixtures |
| E22-05 — structured parser | Hostile XML/JSON/YAML/CSV/archives; no-network sandbox | XXE, entity bomb, remote refs, formulas, macros, traversal, encoding/depth/size faults | Bounded rejection; no external/file access outside fixture; structure-only output | Egress, arbitrary file access, macro/formula execution, resource runaway | File/network trace, allocation/time, minimal reproducers | 1–2 h | Revert VM; delete extracted/staging files |
| E22-06 — endpoint machine read-only | Disposable Windows VM with fictional service/task/files/registry/buffer/firewall; ProcMon/ETW or equivalent; before/after snapshot | Run fixed endpoint adapter; inject access denied, replacement, reparse, locked files, large buffers | Exact expected nodes/limits; zero successful mutation outside output; no profile crawl; bounded termination | Any source mutation, unexpected write intent, recursive crawl, raw output, residue | Before/after diff, operation categories, package root, canary result | 1–3 h | Uninstall/remove fixtures or revert VM; verify no service/task/firewall residue |
| E22-07 — user-session boundary | Two fictional users/sessions; per-user legacy-owned locations; ordinary-token helper | Run under session A; attempt B access, machine crawl, stale session, logout/cancel | Only exact session A location observed; sanitized output; helper exits and leaves no raw data | Cross-session/profile access, token creation/elevation, raw path/value escape | Token/session facts, file-access trace, output graph, cleanup | 1–2 h | Log off users, remove fixtures, revert VM |
| E22-08 — SQL permission/visibility | Synthetic SQL Server with canary objects, encrypted module, cross-db refs, multiple permission profiles | Run under full lab metadata oracle then reduced discovery principal; revoke grants mid-run | Partial visibility is explicit; known positive missing => no absence; no write permission | Empty/partial result treated complete; write succeeds; cross-realm DB merged | Effective grants, canary-object matrix, query outcomes, DB diff | 1–2 h | Drop principals/DBs or revert snapshot |
| E22-09 — SQL load/read-only | Large fictional catalog/job/query history; server resource/locks/log tracing | Run every query group under concurrency/faults; timeout/cancel; deadlock victim; failover where available | Limits/cancellation work; no DDL/DML/logical source change; finite load evidence | Blocking/resource budget breach, retry storm, source mutation, silent truncation | Query IDs/plans/classes, duration/resource/lock metrics, before/after hashes | 2–4 h | Drop lab DBs/logins; reset instance snapshot |
| E22-10 — Query Store coverage | Synthetic queries across capture modes/state/reset/cleanup; exact Query Store metadata | Execute fictional workloads before observation; vary AUTO/NONE/CUSTOM/read-only/error; purge history | Capture limitations/time ranges represented; missing workload never becomes absence | Tool claims complete use without settings/retention; raw query text published | Option/history evidence, expected vs observed fingerprints | 1–3 h | Drop synthetic DB or restore snapshot; no production setting changes |
| E22-11 — existing XE/Audit history | Precreated lab XE/audit sessions and files with loss/rollover/predicate cases | Read existing targets only; deny create/alter/start/stop; corrupt/truncate/rollover targets | Exact captured subset and loss limitations; zero session/config change | Collector creates/alters session or claims full coverage after loss | Session before/after, target digests, event-class results | 1–2 h | Drop lab sessions through fixture teardown; revert instance |
| E22-12 — Agent/report/export inventory | Fictional SQL Agent jobs, proxies, schedules, history; report/subscription metadata | Commands with secrets/dynamic SQL/external paths; disabled jobs; purged history | Metadata-only classifications, schedule links, secret flags; no job/report run | Job/report invoked, command/path/recipient emitted, history gap hidden | Inventory/edge truth, Agent/job history settings, canary scan | 1–2 h | Drop fixture jobs/proxies/reports; revoke lab credentials |
| E22-13 — PSU repository/API | Fictional PSU repository/runtime; synthetic management API that records calls | Parse repo; compare changed runtime; redirects; unauthorized methods/routes; token expiry | Repository/runtime contradiction explicit; only allowlisted GET; no script/job/endpoint/app invocation | POST/PUT/PATCH/DELETE/custom endpoint call, route/token leak, side effect | HTTP method/route-class trace, repo revision, package root | 1–3 h | Revoke/delete lab token; reset PSU fixture/repository |
| E22-14 — credential classification | Fictional Windows/SQL/PSU credential references and embedded-secret canaries | Enumerate metadata; deny secret-read APIs; attempt output/log/error/crash paths | Presence/class/use/owner questions only; `secretRead=false`; every canary detected | Any value/hash/token/key/connection string or reversible derivative leaves classifier | Access/API trace, canary matrix, output schemas, incident simulation | 1–2 h | Revoke lab secrets; delete caches/dumps; revert VM |
| E22-15 — buffer classification | Fictional CSV deferred SQL, raw activity, typed events, unknown/encrypted/polyglot queues | Read metadata/structure; locked/raced files; formulas; malformed/large/unknown formats | Never executed/moved; correct high-risk flags; unknown quarantined; before/after source stable | Content executed/copied; queue changed; raw rows published; unsafe marked migratable | Process/file trace, bucket truth, source before/after, graph/disposition | 1–3 h | Remove/revert fixture buffers; prove no temp copies |
| E22-16 — sanitization/all-sink canaries | Plant unique secret, URL, path, account, address, HR, raw-query/script markers in every source/sink/encoding | Exercise success, partial, exception, cancellation, crash, verification, evidence import/export | All mandatory markers caught; valid package contains none; positive-control scanner never misses | One mandatory miss, broad allowlist, external upload before pass | Marker/sink/encoding matrix, scanner/config hashes, redacted findings | 2–4 h | Purge contaminated artifacts/logs; revert runner |
| E22-17 — alias/realm separation | Fictional same names across realms/purposes; keyed alias service | Generate aliases; rotate purpose/realm key/profile; collision/dictionary attempts | Same input differs across realm/purpose; deterministic within profile; no raw SHA; collision handled | Cross-realm/purpose correlation or exported key/map | Golden vectors, key/profile evidence, collision/dictionary results | 30–90 min | Destroy lab keys/maps; retain only vectors/digests |
| E22-18 — package integrity | Valid package and tampered variants; independent verifier implementation | Delete/add/reorder/duplicate lines; swap run files; edit manifest/schema; truncate; bit flip | Every tamper rejected; clean package deterministic under fixed inputs; no partial publish | Tamper accepted, prior package overwritten, first failure omitted | Tamper corpus, verifier results, roots, atomic-publication trace | 1–2 h | Delete tampered copies; preserve minimal reproducers |
| E22-19 — graph completeness | Synthetic graph covering preserve/change/retire/investigate and malformed/orphan/cross-realm cases | Remove each mandatory edge; create cycles/conflicts/owner inference; change graph after approval | Every incomplete/invalid path blocks; exact complete paths pass; stale approval invalidates | Cutover/removal ready with missing edge or cross-realm link | Graph vectors, rule/mutation results, approval-binding evidence | 1–2 h | Delete fixture graph/keys; preserve golden vectors |
| E22-20 — coverage/absence | Synthetic population with unreachable targets, static-only, runtime-only, reset telemetry, contradictions, seasonality | Evaluate claims under every combination; mutate denominator and time window | Only bounded states/confidence produced; no absolute absence; retirement blocked on gaps | `NOT_OBSERVED` rendered/used as absent/safe; unreachable hidden | Coverage decision table, minimal counterexamples, UI/API snapshot | 1–2 h | Delete fixture population; retain vectors |
| E22-21 — interview conflict | Fictional structured interviews and evidence; access-controlled free-text references | Contradict owner claims with runtime/static facts; self-approval; stale respondent | Assertions remain separate/unverified; contradictions block; no owner inferred | Interview overrides facts or authorizes own retirement without required authority | Response/decision graph, SoD and contradiction results | 30–60 min | Delete free text; retain finite response fixtures |
| E22-22 — dynamic/ad-hoc recall | Fictional direct queries, monthly job, emergency script, copied export, shared login | Combine static/runtime/interview windows; hide each evidence class in turn | Known consumers found when evidence exists; hidden cases remain unknown, not falsely absent | Controlled hidden consumer retired/closed | Expected recall ledger and claim/disposition outputs | 2–4 h plus seasonal simulation | Drop users/jobs/files; clear lab history |
| E22-23 — population/unreachable | Authoritative fictional inventory with duplicates, clones, stale/retired/offline devices | Omit wave, fail connections, change asset status, duplicate alias/realm | Every target terminal/reconciled; unresolved denominator visible; no silent exclusion | Aggregate claims omit failures or count duplicate as complete | Population digests, terminal distribution, reconciliation report | 1–2 h | Delete target map and lab credentials |
| E22-24 — resource/backoff | Large target set and slow/failing services; generator independent of collector response | Concurrency, timeout, cancellation, disk pressure, retry, network blackhole | Bounded resources/retries; no target hammering; no silent evidence drop | Unbounded growth, retry storm, disk overwrite, missing failure | Resource/time series with finite labels, attempt ledger, cleanup | 2–6 h | Terminate agents; clear output; revert infrastructure |
| E22-25 — observability/cardinality | Instrumented CLI and theoretical catalogue bound | Inject dynamic IDs/errors/targets into logs/metrics; high-cardinality corpus | Only finite labels; theoretical and observed bound match; no raw value | Dynamic/sensitive label, unbounded series, raw exception | Catalogue/bound report, label inventory, canary scan | 30–90 min | Delete test telemetry from backend/local store |
| E22-26 — incident drill | Lab secret/raw canary escape and compromised package fixture | Trigger stop; isolate; revoke; inventory copies; purge; correct; reauthorize | No publication; every copy accounted for; rotation/deletion decisions recorded; resume requires approval | Continued collection, missed copy, self-clear, incomplete cleanup | Incident timeline, access/copy inventory, revocation/deletion proof, rerun | 2–4 h | Revert runner/target; destroy lab credentials |
| E22-27 — accessibility/review | Generated HTML/portal projection of fictional evidence; keyboard and screen reader/zoom/forced-colors | Complete triage, contradiction, owner, disposition, rollback/removal-proof tasks | State/limitations/action accessible without pointer/color; no hidden bypass | Critical task impossible/misleading; direct DB/spreadsheet workaround required | Manual task record, automated semantics report, issue links | 2–4 h per supported matrix | Delete screenshots/session data; keep safe findings |
| E22-28 — cleanup/crash | Disposable VM/DB/PSU; kill at every run phase; reboot/disk full/locked output | Run cleanup and before/after inventory; token/session/handle/process checks | No service/task/rule/key/token/temp/parser child/source change residue; package state truthful | Any residue, source mutation, undeletable contaminated artifact | Cleanup receipt, residue diff, crash phase outcomes | 2–6 h | Revert VM/DB; revoke lab tokens/keys |
| E22-29 — compatibility | Exact supported and unsupported Windows/SQL/PSU/parser versions | Run matrix; newer/older/malformed/encrypted/partial features | Exact supported pass; unsupported explicit/fail closed; no closest match | Unsupported source silently parsed as supported or loses evidence | Environment/module/source identities and matrix results | 1–3 h per profile | Revert environments; delete fixtures |
| E22-30 — OSS dependency admission | Exact candidate source/package/binary in isolated build/test lane | License/security/source mapping, malicious corpus, network/telemetry, removal/replacement | Complete mapping and tests; no unexpected egress; UAM oracle remains independent | Mutable/unmapped artifact, license unresolved, scanner/parser false negative, hard removal path | Admission record, SBOM, provenance, test results, removal spike | 0.5–2 days per candidate | Delete caches/images/packages; verify clean build |
| E22-31 — parallel/dark retirement rehearsal | Synthetic legacy/new consumer with stable fictional outputs and faults | Disable legacy reversibly, compare outputs/failures, inject delayed/manual use, rollback | Controlled delayed consumer detected; rollback restores outcome; no duplicate/lost effect | Hidden consumer missed, rollback fails, “no activity” treated success | Trace graph, comparison ledger, alert/support/rollback evidence | 1–3 days simulated/accelerated | Restore fixture; remove migration state |

## 8.3 Smallest falsifying prototypes

### P22-01 — fixed-scope, no-arbitrary-execution CLI

**Claim.** The CLI cannot be turned into a shell, arbitrary SQL client, path crawler, or plugin host.

**Setup.** Minimal signed/test-signed scope; one fictional adapter; architecture tests; process/file/network tracing; release binary manifest.

**Instrumentation.** Invocation audit, adapter-call counter, process-child trace, dynamic-load trace, opened-path trace, network trace.

**Steps.**

1. Run one valid fixed adapter.
2. Submit unknown adapter IDs, extra switches, source paths, UNC/device paths, SQL, scripts, URLs, response files, environment-variable injection, and malformed Unicode.
3. Add compile-time mutations for dynamic assembly, runspace, `Process.Start`, arbitrary HTTP, and broad file enumeration.
4. Inspect the production binary/dependencies for test/destructive helpers.

**Pass.** Valid fixed command works; every broadening input fails before source access; every architecture mutation fails CI; no child/dynamic load/network/source path is observed; production manifest is clean.

**Fail.** Any arbitrary value reaches source logic or any mutation ships/runs.

**Evidence.** `p22-01/{invocations.ndjson,architecture-mutations.json,process-file-network.json,release-files.sha256,cleanup.json}`.

**Duration.** **ESTIMATE:** 2–4 hours.

**Cleanup.** Destroy test keys/scope; revert mutations; verify clean tree and no output residue.

### P22-02 — SQL query-pack read-only proof

**Claim.** The SQL adapter can inventory the minimum metadata without changing the database and cannot run deferred/discovered SQL.

**Setup.** Disposable SQL Server with fictional schemas, encrypted module, dynamic SQL, SQL Agent jobs/proxies, linked server metadata, credentials, Query Store/XE fixtures, and write-denied discovery login.

**Instrumentation.** DDL/data/schema hashes; transaction log/audit/event evidence; locks/resource counters; exact statement IDs; network and file activity.

**Steps.**

1. Run the approved query pack and compare to a privileged synthetic oracle.
2. Remove metadata permissions and verify partial/unknown outcomes.
3. Inject every forbidden statement into candidate query-pack source and dynamic identifier fields.
4. Place executable SQL in jobs/modules/buffers and prove parser-only treatment.
5. Cancel/time out queries and simulate failover/disconnect.

**Pass.** All expected metadata nodes/limitations appear; zero source mutation; no forbidden statement is admitted; executable text is never executed; partial visibility never yields absence; cancellation is bounded.

**Fail.** One write/config/job/SQL execution, false complete result, or unbounded load.

**Evidence.** `p22-02/{query-pack.json,permission-matrix.json,before-after.json,statement-audit.json,resource.json,package-root.json,cleanup.json}`.

**Duration.** **ESTIMATE:** 4–8 hours.

**Cleanup.** Drop synthetic databases/logins/jobs/sessions or revert instance snapshot; prove no external target contacted.

### P22-03 — PowerShell/PSU non-execution proof

**Claim.** PowerShell and PSU artifacts can be classified without runspace/module/job/endpoint execution.

**Setup.** Hostile fictional PowerShell corpus and PSU repository/runtime/API. Scripts include profiles, module initializers, type accelerators, reflection, jobs, `Invoke-Expression`, web/SQL calls, encoded commands, and secret canaries.

**Instrumentation.** Process/module/network/file traces; synthetic PSU request log; parser result oracle; canary scanner.

**Steps.**

1. Parse every artifact via `Parser.ParseFile`/equivalent bounded stream.
2. Attempt malicious import/profile/formatter/argument-completer side effects.
3. Compare repository and runtime revisions.
4. Redirect API requests and expose mutating/custom routes.
5. Force parse errors, resource limits, and process crash.

**Pass.** No script/module/profile/action executes; only allowlisted GET metadata calls occur; contradictions and unknown dynamic paths are explicit; canaries remain local and are caught on attempted escape.

**Fail.** Any child/action/job/endpoint/network call outside the fixed API metadata route or any high-risk path marked safe.

**Evidence.** `p22-03/{ast-results.ndjson,psu-call-log.json,process-module-network.json,canary.json,cleanup.json}`.

**Duration.** **ESTIMATE:** 4–8 hours.

**Cleanup.** Revoke/delete lab token; reset repository/PSU instance; destroy runner.

### P22-04 — endpoint and buffer zero-mutation proof

**Claim.** The endpoint adapter observes service/task/settings/checkpoint/buffer/network metadata without crawling profiles, executing buffers, or changing source state.

**Setup.** Disposable Windows VM with fictional service, scheduled tasks, exact registry/file roots, two user sessions, CSV deferred SQL, raw-activity and typed-event buffers, reparse/locked/large/unknown files, firewall rules, and network fixtures.

**Instrumentation.** Before/after service/task/registry/file/ACL/firewall/process/network state; per-process file/registry trace; token/session facts; canaries.

**Steps.**

1. Run machine adapter, then ordinary-token helper for one exact session.
2. Race rename/reparse/replacement and logoff.
3. Kill at every phase and fill output disk.
4. Verify buffers were not moved, locked beyond run, parsed via handlers, or copied.
5. Attempt other-user/profile/drive access.

**Pass.** Expected sanitized facts; zero successful source mutation; no recursive/profile/cross-session access; no buffer execution/copy; bounded cancellation; complete cleanup.

**Fail.** Any source change, cross-session access, raw value escape, or residue.

**Evidence.** `p22-04/{before-after.json,operation-trace.json,token-session.json,buffer-oracle.json,package-root.json,cleanup.json}`.

**Duration.** **ESTIMATE:** 4–8 hours.

**Cleanup.** Revert VM and verify fixture service/task/firewall/credentials no longer exist.

### P22-05 — sanitization and evidence-package proof

**Claim.** A shareable package cannot contain a forbidden source value or be silently altered.

**Setup.** Every adapter fixture contains unique markers for secret, URL, address, user, account, path, SQL literal, script body, HR key, activity, and report destination in multiple encodings and failure paths.

**Instrumentation.** Exact schema-aware scanner, secondary secret scanner, all-sink collector, independent package verifier, file-open trace.

**Steps.**

1. Run success, partial, access denied, parser error, cancellation, crash, and cleanup failures.
2. Verify all mandatory positive controls are detected.
3. Generate a valid package and scan every file/log/result/metric.
4. Tamper with every package file and manifest relation.
5. Test alias realm/purpose separation and dictionary resistance.

**Pass.** Valid package contains no marker; every positive control and tamper is detected; raw working set is deleted; aliases do not correlate across purposes/realms.

**Fail.** One marker/tamper miss, broad suppression, partial authoritative package, or exported alias key/map.

**Evidence.** `p22-05/{marker-matrix.json,scanners.json,package-root.json,tamper-results.json,alias-vectors.json,cleanup.json}`.

**Duration.** **ESTIMATE:** 4–8 hours.

**Cleanup.** Purge all contaminated artifacts/caches/logs and destroy lab alias keys.

### P22-06 — coverage/absence falsifier

**Claim.** The coverage evaluator cannot turn a quiet, partial, inaccessible, or unreachable estate into an absence/removal conclusion.

**Setup.** Fictional population with static-only consumer, runtime-only consumer, monthly consumer, emergency manual query, unreachable device, metadata-hidden object, Query Store reset, XE rollover, conflicting owner assertions, and copied spreadsheet.

**Instrumentation.** Independent truth ledger; fake clock/business-cycle scheduler; population reconciliation; decision mutation tests.

**Steps.**

1. Evaluate every evidence combination and interval.
2. Omit one target/evidence dimension at a time.
3. Run beyond short and simulated full cycles.
4. Attempt to mark each unknown/not-observed item `RETIRE`.
5. Mutate evaluator to treat `NOT_OBSERVED_IN_SCOPE` as absence.

**Pass.** Present items are found when evidence exists; hidden items remain unknown; unreachable/telemetry gaps reduce confidence; every retirement attempt blocks until owner/validation/rollback; mutation is caught.

**Fail.** One controlled hidden consumer becomes “unused,” “absent,” or removal-ready.

**Evidence.** `p22-06/{truth-ledger.ndjson,coverage-claims.ndjson,disposition-results.json,mutations.json}`.

**Duration.** **ESTIMATE:** 2–4 hours using simulated time; real observation windows remain a **HUMAN DECISION**.

**Cleanup.** Delete fictional population/interviews and reset fake clock.

### P22-07 — traceability and disposition gate

**Claim.** No preserve/change/retire item can reach cutover/removal without the mandatory evidence-to-rollback path.

**Setup.** Synthetic complete and incomplete graphs for every disposition, including credentials, buffers, reports, integrations, manual consumers, and cross-realm conflicts.

**Instrumentation.** Graph validator, path query engine, approval-digest binder, mutation framework.

**Steps.**

1. Remove each mandatory node/edge independently.
2. Add orphan tests, owner inferred from name, stale approval, conflicting requirement, cross-realm relation, and rollback marked untested.
3. Change graph bytes after approval.
4. Attempt cutover/removal/closure.

**Pass.** Only exact complete same-realm approved graph passes; every mutation blocks with a finite reason; post-approval change invalidates authority.

**Fail.** Any incomplete, contradictory, cross-realm, or stale-approved item passes.

**Evidence.** `p22-07/{graph-vectors/,path-results.json,approval-binding.json,mutation-results.json}`.

**Duration.** **ESTIMATE:** 2–4 hours.

**Cleanup.** Destroy test signing keys and fixture graph store.

### P22-08 — secret/raw incident drill

**Claim.** A discovery escape stops publication and can be contained, cleaned, and reauthorized without preserving the sensitive value in ordinary evidence.

**Setup.** Lab-only canary credential and raw-activity marker deliberately routed into a temporary evidence/log sink by a fault-injected build.

**Instrumentation.** Access/copy logs, package registry, credential status, cleanup scanner, incident timeline.

**Steps.**

1. Trigger the escape.
2. Verify automatic safety hold and no publication/upload.
3. Inventory copies and access; revoke/rotate lab credential.
4. Purge contaminated outputs/caches/dumps and preserve minimum incident evidence.
5. Fix build; rerun positive controls; obtain explicit resume authorization.

**Pass.** No ordinary package is published; every controlled copy is accounted for/deleted; lab credential is revoked/rotated; resume requires separate authority; clean rerun passes.

**Fail.** Continued collection, missing copy, sensitive value in incident report, self-clear, or cleanup uncertainty presented as pass.

**Evidence.** `p22-08/{incident-shell.json,access-copy-inventory.json,credential-action.json,deletion-proof.json,rerun-root.json}`.

**Duration.** **ESTIMATE:** 2–4 hours.

**Cleanup.** Revert runners/targets, destroy lab secrets, validate surrounding storage and telemetry.

### P22-09 — reversible retirement rehearsal

**Claim.** A candidate can be disabled and restored without hidden consumer loss, and absence is not inferred from a short quiet period.

**Setup.** Synthetic legacy report/job/integration with ordinary, delayed, month-end, and emergency consumers; replacement contract; rollback artifact.

**Instrumentation.** Stable fictional outcome ledger, consumer health, alerts, audit, fake time, graph/disposition state.

**Steps.**

1. Capture baseline and approve a reversible disable plan.
2. Disable legacy path without deleting it.
3. Run ordinary and delayed consumers, then trigger month-end/emergency behavior.
4. Verify failure detection and rollback.
5. Repeat with replacement active and compare approved outcomes.
6. Remove only after all gates pass; run post-removal inventory.

**Pass.** Delayed consumer prevents false retirement; rollback restores outcome; eventual replacement produces accepted semantics; removal proof captures absence within the declared scope and no residue.

**Fail.** Consumer loss is silent, rollback fails, outputs diverge without approved change, or short quiet period authorizes delete.

**Evidence.** `p22-09/{baseline.json,disable-audit.json,consumer-ledger.json,rollback.json,parallel-validation.json,removal-proof.json}`.

**Duration.** **ESTIMATE:** 1–3 accelerated test days. Production observation duration is a **HUMAN DECISION**.

**Cleanup.** Restore lab state, remove fixture integrations/credentials/exports, and revert environment.

### P22-10 — blind owner/reviewer and accessibility exercise

**Claim.** An authorized reviewer can make a safe disposition using only sanitized evidence and can perceive all uncertainty, blockers, and rollback state without raw data or inaccessible workarounds.

**Setup.** Fictional package with present, unknown, contradictory, secret-bearing, and unreachable cases; generated accessible review UI/HTML and structured interview workflow.

**Instrumentation.** Task-success script, keyboard/screen-reader/zoom/forced-colors evidence, decision log, prohibited raw-data request log.

**Steps.**

1. Ask reviewers to identify current evidence and limitations.
2. Triage/assign owner questions without seeing raw names/paths/queries.
3. Attempt preserve/change/retire decisions with missing links.
4. Complete rollback/removal-proof review using keyboard and assistive technology.
5. Attempt direct spreadsheet/DB bypass and raw-data request.

**Pass.** Reviewers reach correct bounded states; incomplete decisions block; no raw data is needed; critical tasks are accessible; bypass is unavailable.

**Fail.** Reviewer is misled by empty/green status, cannot find uncertainty/rollback, requires raw values, or uses an inaccessible/unaudited alternative.

**Evidence.** `p22-10/{task-results.json,accessibility.json,decision-log.json,raw-request-events.json,issues.json}`.

**Duration.** **ESTIMATE:** 2–4 hours per representative reviewer/accessibility profile.

**Cleanup.** Delete sessions/free text/screenshots containing unnecessary data; retain safe task evidence.


---

# 9. Architecture fitness functions and measurable acceptance criteria

A fitness function is executable where possible and evidence-bound where human authority is required. Zero-tolerance means one counterexample fails the claimed profile.

| ID | Fitness function / invariant | Measurement or executable assertion | Acceptance criterion | Evidence / review trigger |
|---|---|---|---|---|
| FF22-01 | No arbitrary execution surface | Enumerate CLI verbs/flags, loaded modules, child processes, network destinations, and architecture-mutation results | Only fixed catalogue entries; zero arbitrary shell/SQL/script/plugin/path/URL capability | Every release; any new adapter/dependency |
| FF22-02 | Scope can only narrow | Property-test effective scope against release catalogue and approved manifest | `EffectiveScope ⊆ ProductDiscoveryCeiling`; unknown/conflict denies | Scope contract or policy change |
| FF22-03 | Realm isolation | Run full same-name/cross-realm node, alias, target, graph, cache, and package negative suite | Zero cross-realm node/edge/claim/alias reuse or existence disclosure | Every release and key/profile change |
| FF22-04 | Zero source mutation | Before/after state plus process-level file/registry/DB/PSU/API traces | Zero successful mutation outside private output; zero unexpected mutation intent | Every adapter/platform/version profile |
| FF22-05 | SQL query pack is read-only and closed | AST scan all statements; compare query IDs/digests; execute under write-denied lab principal | Every batch matches an approved `SELECT` profile; all forbidden/unknown constructs rejected | Query/engine/parser change |
| FF22-06 | Script/SQL/config parsing never executes | Trace children, modules, network, file writes, runspaces, DB calls while hostile corpus parses | Zero execution/egress/child; bounded time/allocation; unknown quarantined | Parser/runtime/dependency update |
| FF22-07 | Secrets are never read/exported | Instrument secret APIs; all-sink exact canary corpus | `secretRead == false`; zero mandatory canary in any published/logged/metric/evidence sink | Every release/scanner/config change |
| FF22-08 | Raw activity/personal/confidential values never cross publication boundary | Schema allowlist and exact markers across all success/failure paths | Zero forbidden fields/markers/reversible derivatives in package or ordinary telemetry | Every release and new field/source |
| FF22-09 | Alias separation | Golden vectors across realm, purpose, profile, and key revisions | Equal input aliases only within same approved purpose/realm/profile; collision fails closed | Alias/key/profile change |
| FF22-10 | Evidence package is immutable and complete | Independent verify hashes, line counts, schemas, run/scope binding, package root, atomic publication | Clean package passes; every tamper/truncation/mix rejected; no partial authoritative pack | Every package and verifier release |
| FF22-11 | First failure is preserved | Force fail then successful rerun; query aggregate gate | Original failure remains visible and blocks until explicitly resolved | Harness/gate change |
| FF22-12 | Population denominator is explicit | Reconcile target-set digest to terminal outcomes; duplicate/retired rules | Every approved target appears once in terminal reconciliation; unresolved count visible | Every wave/run and population revision |
| FF22-13 | Unreachable is never absence | Decision-table/property tests | Any material `UNREACHABLE`/`ACCESS_DENIED`/`UNSUPPORTED` keeps affected claim `UNKNOWN` or low-confidence scoped non-observation | Coverage algorithm change |
| FF22-14 | Metadata invisibility is detected | Known-positive canary objects under each permission profile | Missing known positive makes query group partial/unknown; never complete/absent | SQL permission/engine change |
| FF22-15 | Runtime telemetry limitations are explicit | Capture setting/time/reset/loss/retention completeness validator | A runtime claim cannot be current without all required metadata; gaps lower confidence/block absence | Telemetry source/config reset/change |
| FF22-16 | No absolute absence vocabulary or behavior | Schema/UI/API/static text and decision-rule scan | Only `PRESENT`, `NOT_OBSERVED_IN_SCOPE`, `UNKNOWN`, `CONTRADICTORY`; no alias such as `UNUSED`/`SAFE_TO_DELETE` derived automatically | Contract/UI/report change |
| FF22-17 | Dynamic code remains fail-closed | Mutation corpus for constructed SQL/PowerShell/PSU actions | Every unresolved construction yields `UNKNOWN_DYNAMIC_PATH` and `INVESTIGATE_QUARANTINE` | Parser/classifier update |
| FF22-18 | Credential values are structurally absent | Contract reflection/schema/serialization tests; API access trace | No value/hash/token/key/string field; only closed classes/state; secret-read API unused | Credential adapter/schema change |
| FF22-19 | Buffers are never executed or copied | Process/file trace and source before/after; output scanner | Zero execution/move/rename/content copy; metadata-only output; unsafe/unknown blocks migration | Buffer adapter/parser change |
| FF22-20 | Trace path completeness gates disposition | Graph path query plus one-edge-at-a-time mutations | Every preserve/change/retire path contains all mandatory nodes/edges; any omission blocks | Graph rule/contract change |
| FF22-21 | Approval binds exact evidence | Change graph/package/disposition after approval in fixtures | Changed root/digest invalidates prior authority; no approval inheritance | Approval or evidence format change |
| FF22-22 | Retirement is reversible before destructive removal | Rehearsal state and rollback tests | Reversible disable, current rollback, delayed-use observation, owner approval, and post-removal proof all pass | Every retirement plan |
| FF22-23 | Parallel validation preserves approved outcome | Compare stable fictional identities/effects and explicit approved differences | Zero unexplained missing/duplicate/semantic difference; approved deliberate changes documented | Every migration/cutover candidate |
| FF22-24 | Resource use and retries are bounded | Measure peak/steady memory, CPU, handles, DB locks, rows/bytes/time, attempts under stress | Within human-approved profile; cancellation succeeds; no retry storm or silent truncation | Adapter/estate/limit change |
| FF22-25 | Metrics have finite cardinality | Static label catalogue and runtime unique-series count | Observed labels are subset of catalogue and within computed maximum; no dynamic/sensitive labels | Telemetry catalogue/change |
| FF22-26 | Cleanup is complete | Before/after process/service/task/file/registry/firewall/key/token/DB-session diff | Zero unexplained residue; contaminated working set absent; cleanup receipt valid | Every lab/target run; crash profile change |
| FF22-27 | Compatibility is exact and fail-closed | Matrix against supported/unsupported source versions/profiles | Exactly supported combinations pass; no closest/major-only fallback; unsupported state explicit | OS/SQL/PSU/parser release change |
| FF22-28 | Dependency provenance is complete | Reconcile lock graph, source tag/commit, package, binary, license, SBOM and shipped files | No unexplained executable/dependency; legal/security review complete; removal path demonstrated | Every dependency update/advisory/license change |
| FF22-29 | Incident safety hold cannot self-clear | Trigger canary/cross-realm/query mutation/package conflict; attempt ordinary retry/operator clear | New collection/publication remains blocked until separately authorized recovery evidence | Incident/runbook/control change |
| FF22-30 | Interview assertions cannot override technical contradictions | Synthetic conflicting assertions and SoD tests | Assertion remains separately typed; contradiction blocks; respondent cannot self-approve prohibited decision | Interview/workflow change |
| FF22-31 | Review workflows are accessible | Complete critical tasks with keyboard, screen reader, zoom/reflow, forced colors; automated semantics | Every in-scope task can be completed/understood without pointer/vision/color or direct-DB bypass | UI/design-system/browser/AT change |
| FF22-32 | Data-quality limitations remain visible | Golden cases for null/duplicate/implicit joins, stale settings, partial history | No silent merge/default; finite quality/limitation states propagate to coverage/disposition | Schema/import/parser change |
| FF22-33 | Production-shape evidence remains synthetic/sanitized | Scan fixtures/packages/repository lineage against classification manifest | No unapproved production-derived value/distribution; every input classified and deletable | Every fixture/evidence addition |
| FF22-34 | Cost/skills/operations are bounded and owned | Measure run/operator time, storage, lab/runner/dependency cost, failure/support workload | Named human owner accepts sustainable profile; no unowned recurring lane/dependency | Pilot/estate expansion or major release |
| FF22-35 | No neighboring accepted invariant is silently changed | ADR/gate checker compares this result and predecessor baseline | Direct SQL/secret/script/profile crawl/broker assumptions remain prohibited; conflicts open a change proposal | Every architecture decision/review |

## 9.1 Aggregate acceptance criteria

The discovery lane is technically eligible for one approved read-only target only when:

1. FF22-01 through FF22-20 and FF22-24 through FF22-29 pass for the exact tool/profile;
2. the scope authority, target population, access, deletion, incident, and support functions are assigned;
3. the package verifier and canary scanner pass independent positive controls;
4. zero primary security/privacy/realm/mutation failure exists;
5. cleanup evidence is complete;
6. all numeric limits remain labelled and within the approved run profile;
7. the package states `productionChangeAuthorized=false` and `removalAuthorized=false`.

Migration or removal eligibility additionally requires FF22-20 through FF22-23, owner/purpose/criticality approval, and the relevant accepted target-system proof gates. A discovery pass never substitutes for target implementation, capacity, audit, lifecycle, or production approval.

---

# 10. Human decisions and owner questions

Research and tooling cannot make the decisions below. A role name identifies an accountable function, not an assigned person.

## 10.1 Mandatory human decision register

| ID | Decision | Options and consequences | Conservative temporary default | Accountable function | Blocks |
|---|---|---|---|---|---|
| HD22-01 | **Authority to inspect systems** | Approve exact targets/adapters/fields/time/access; approve narrower metadata-only alternative; or deny. Broader authority increases disclosure/load risk; denial leaves unknowns. | No connection or source access; offline T1 only. | System/Data Owner with Security, Privacy, Legal/Workforce Governance as applicable | Any real read-only run |
| HD22-02 | **Named owners and approved purposes** | Assign accountable owner/purpose; record multiple bounded owners; or leave unassigned. Unassigned items cannot be preserved, changed, or retired safely. | `UNASSIGNED` / purpose `UNKNOWN`; `INVESTIGATE_QUARANTINE`. | Product/Data/Application Governance | Disposition approval, migration, retirement |
| HD22-03 | **Consumer criticality** | Critical, important, convenience, prohibited/unapproved, or unknown under an approved vocabulary. Consequences affect validation, rollback, support, and outage tolerance. | `UNDECIDED`; no removal and no promise to preserve implementation. | Business/Product Owner with Operations/Risk | Cutover/removal and validation profile |
| HD22-04 | **Retirement approval** | Approve reversible disable/removal after evidence; defer; reject; or require longer validation. | No disable/remove. | Accountable Service/Data Owner and Change/Risk Authority | Disable/removal |
| HD22-05 | **Handling unreachable devices** | Wait/reschedule; alternate approved evidence; quarantine/exclude with accepted risk; enterprise remediation; decommission through separate asset process. Each affects coverage and residual risk. | Count as `UNREACHABLE`, affected claims `UNKNOWN`; no inference or removal. | Endpoint/Asset Owner with Product/Risk and Support | Estate completeness and affected retirement |
| HD22-06 | **Observation window and business cycles** | Exact cycles such as daily/weekly/month-end/quarter/year-end/incident-only; a longer window improves recall but delays migration and increases telemetry/storage cost. | No retirement based on runtime silence; use only positive observations. | Business Owner with SRE/Operations/Data Governance | Absence/retirement claim |
| HD22-07 | **Whether to enable new instrumentation** | Do not instrument; enable minimum Query Store/XE/audit profile; use alternative owner/dark validation. Instrumentation adds mutation, load, privacy, retention, and cleanup duties. | Do not enable; existing evidence only. | Database/System Owner with Security/Privacy/SRE | Coverage improvement, not initial static discovery |
| HD22-08 | **Discovery fields and sensitive metadata** | Approve exact structural fields/buckets; narrow further; deny a source. More fields improve diagnosis but increase disclosure/linkability. | Minimum closed structural metadata; no raw values. | Data Controller/Product Privacy Authority with Security | Scope manifest and schemas |
| HD22-09 | **Evidence access, retention, deletion, and legal hold** | Set periods/access/hold/deletion for raw working set, restricted evidence, shareable package, interview case, and removal proof. | Working set deleted at successful/failed run cleanup; package retained only in controlled research repository pending policy; no indefinite default. | Records/Data Governance/Privacy/Security | Real package publication/operation |
| HD22-10 | **Credential treatment** | Rotate/revoke/replace, retain temporarily, decommission, investigate exposure, or accept bounded exception. | Do not read/copy; mark owner/use unknown; no migration; stop on suspected exposure. | Credential/IAM Owner with Security Incident Response | Credential-dependent cutover/removal |
| HD22-11 | **Buffer treatment** | Translate approved outcome into typed events; drain through separately approved legacy path; freeze/quarantine; delete after proof; legal hold. | Never execute/migrate raw; quarantine and preserve in place under existing controls until decided. | Data/Application Owner with Privacy/Security/Records | Buffer migration/cleanup |
| HD22-12 | **Dynamic SQL/script behavior treatment** | Preserve approved outcome via typed contract; deliberately change; retire; or investigate. | Quarantine; no execution and no migration. | Application/Data Owner with Architecture/Security | Any dynamic path disposition |
| HD22-13 | **HR/AD/CMDB/application join authority** | Select authoritative source/field/temporal semantics; permit only a projection; reject relation. | No person/role/entitlement inference; metadata-only join class. | Data Governance/IAM/Product Privacy | Identity mapping and reports |
| HD22-14 | **Manual exports and recipient copies** | Register/govern/delete/replace; require recipient action; accept limitation; prohibit. | Treat current recipient copies as `UNKNOWN`/`EXTERNAL_ACTION_REQUIRED`; no complete-erasure or retirement claim. | Data Owner/Privacy/Records/Integration Owner | Export disposition, lifecycle claims |
| HD22-15 | **Migration semantics** | Preserve outcome exactly; deliberately change with approved impact; retire. | No target contract or implementation choice inferred from legacy code. | Product/Data Owner with Architecture | Requirement and acceptance tests |
| HD22-16 | **Rollback objective and authority** | Restore legacy behavior, switch traffic, restore configuration/data, or accept irreversible cutover; exact time/objective varies. | Require tested reversible rollback before cutover/removal. | Product/Risk/Operations | Cutover-ready state |
| HD22-17 | **Resource/concurrency/maintenance limits** | Approve per-target query/time/CPU/I/O/rows/bytes/concurrency/retry window or decline production access. | One target, one adapter at a time; deliberately small lab limits only. | System Owner/SRE/DBA/Endpoint Operations | Real run profile |
| HD22-18 | **Support and incident ownership** | Assign on-call/escalation/cleanup/recovery; restrict runs to staffed windows; or defer. | Capability disabled without assigned coverage. | Engineering/Operations/Security Leadership | Approved real run and recurring use |
| HD22-19 | **Accessibility and localization target** | Adopt WCAG 2.2 AA or organizational standard, supported browser/AT/language matrix, and exception process. | Semantic Markdown/HTML and keyboard-readable machine states; no production approval workflow until tested. | Product Accessibility/Product Owner | Human review/approval interface |
| HD22-20 | **Dependencies, licensing, and support** | Admit candidate, reference-only, replace, procure commercial support, or reject. | No new external dependency until exact admission; prefer built-in/narrow code. | Architecture, Security, Legal/Procurement, Support | Dependency use in release |
| HD22-21 | **Budget and staffing** | Fund one-time discovery, recurring observation, lab, database/PSU expertise, interviews, evidence review, and support—or reduce scope/delay. | Pure/offline work only; no unsupported estate campaign. | Product/Finance/Engineering Leadership | Estate-scale execution |
| HD22-22 | **SLO/RPO/RTO and production migration risk** | Define objectives for discovery availability, cutover, rollback, evidence freshness, and legacy support period. | No production objective or cutover promise. | Product/Risk/SRE/Operations | Migration/cutover/production |
| HD22-23 | **Production go/no-go** | Approve pilot/production after all predecessor/target gates, accept residual risk, or defer/reject. | T1/lab/read-only evidence only; `productionApproved=false`. | Designated Production/Risk Authority | Pilot/production |

## 10.2 Owner questions that must be answered before disposition

1. What approved business outcome, if any, does this item support?
2. Which people/functions are accountable for the outcome, source, consumer, credential, destination, and support path?
3. What is the failure consequence if the item is unavailable, delayed, duplicated, wrong, or removed?
4. Is the observed implementation approved, prohibited, tolerated temporarily, or simply unknown?
5. Which exact inputs, outputs, fields, identities, time semantics, schedules, and quality rules are necessary?
6. Which consumers and recipients exist, including manual, seasonal, emergency, and external copies?
7. What evidence would prove the replacement equivalent—or justify a deliberate difference?
8. What must be reversible, for how long, and who can authorize rollback?
9. Which legal/records/privacy/security/access obligations apply to source data, buffers, reports, credentials, exports, and evidence?
10. What observation window covers the real business cycle, and what known gaps remain?
11. What must happen for unreachable devices or owners who cannot be contacted?
12. Who signs the final preserve/change/retire decision and accepts residual risk?

## 10.3 Mandatory artifact — interview guides

Interviews supplement evidence; they do not replace it. The interviewer MUST avoid requesting raw credentials, internal addresses, URLs, personal data, production activity, SSH material, full query/script text, or confidential report contents. Supporting artifacts are referenced by approved digest/identifier or inspected locally under separate authority.

### Guide A — inspection authority and scope approver

| Question code | Question | Evidence sought | Unsafe request to avoid |
|---|---|---|---|
| `A01_AUTHORITY` | Which systems, realms, target classes, dates, and adapter classes are authorized? | Approved scope/authority reference and expiry | Raw host list in the shareable interview record |
| `A02_FIELDS` | Which structural fields and buckets are the minimum necessary? | Field-profile decision | Raw values “for completeness” |
| `A03_ACCESS` | Which identity, access path, operator, and review separation are approved? | Credential reference and effective-permission plan | Password/token/key or actual connection command |
| `A04_RETENTION` | How long may working/restricted/shareable evidence persist, and who deletes it? | Records/deletion profile | Indefinite “keep everything” default |
| `A05_INCIDENT` | Who is notified and can stop/resume after a secret/raw/mutation finding? | Incident owner/escalation | Informal self-clear by operator |

### Guide B — legacy system/service owner

| Question code | Question | Evidence sought |
|---|---|---|
| `B01_OUTCOME` | What outcome does the system provide, and to whom? | Approved purpose/requirement candidate |
| `B02_BOUNDARIES` | Which components, environments, realms, schedules, and failure modes exist? | Architecture/runbook references |
| `B03_CHANGE_HISTORY` | Which recent changes, emergency workarounds, or frozen areas affect discovery? | Change/incident references and dates |
| `B04_CRITICALITY` | What happens if collection, processing, reporting, export, or restart stops? | Failure consequence and recovery evidence |
| `B05_UNKNOWN` | Which parts do you not control or cannot verify? | Explicit unknown/dependency list |
| `B06_OWNER` | Which functions own source, database, reports, integrations, credentials, and support? | Owner candidates, not inferred assignments |

### Guide C — consumer/report/business owner

| Question code | Question | Evidence sought |
|---|---|---|
| `C01_USE` | Which report/output/aggregate is used, by what process, and at what business cycle? | Report/job/case reference, schedule class, evidence of use |
| `C02_DECISION` | What decision or workflow depends on it, and is that use approved? | Purpose/prohibited-use decision reference |
| `C03_FIELDS` | What is the minimum needed result and acceptable precision/freshness/quality? | Target contract acceptance candidate |
| `C04_FAILURE` | What would reveal missing, stale, duplicate, or changed output? | Validation oracle/alert/support evidence |
| `C05_MANUAL` | Are there manual downloads, spreadsheets, emails, re-runs, or emergency steps? | Manual workflow/export inventory |
| `C06_RETIRE` | What evidence and observation period would permit retirement? | Owner-defined acceptance/stop/rollback conditions |

### Guide D — DBA/database reliability owner

| Question code | Question | Evidence sought |
|---|---|---|
| `D01_TOPOLOGY` | Which instances/databases/replicas/jobs/report stores are in scope and authoritative? | Sanitized topology/realm scope digest |
| `D02_VISIBILITY` | Which metadata is hidden by permissions/encryption/cross-database boundaries? | Effective-permission and limitation plan |
| `D03_RUNTIME` | Which Query Store/XE/Audit/Agent histories already exist, with what capture/retention/resets? | Configuration/time-range evidence |
| `D04_ADHOC` | How are ad-hoc/direct consumers governed and observed? | Access/audit/process evidence class |
| `D05_EXTERNAL` | Which linked servers, external data sources, proxies, reports, exports, or service accounts exist? | Metadata references/owner candidates |
| `D06_LOAD` | What query/maintenance windows and resource limits are safe? | Approved run budget and stop thresholds |
| `D07_RESTORE` | What isolated metadata/restore option exists if production reads are denied? | Sanitized alternative evidence plan |

### Guide E — endpoint/platform/support owner

| Question code | Question | Evidence sought |
|---|---|---|
| `E01_POPULATION` | What is the authoritative device population and decommission/duplicate/offline rule? | Population snapshot/digest process |
| `E02_VARIANTS` | Which OS/agent versions, installation modes, session/profile variants, and management channels exist? | Support matrix candidates |
| `E03_LOCATIONS` | Which exact machine/user-owned legacy locations are approved for read-only inspection? | Release-owned root IDs, not raw paths in shareable output |
| `E04_BUFFERS` | Which buffer/error/retry files exist, how are they normally consumed, and what must never execute? | Buffer classes/producer/consumer/retention evidence |
| `E05_UNREACHABLE` | How should long-offline, isolated, broken, or ownerless devices be handled? | Human decision options and consequence |
| `E06_SUPPORT` | Which diagnostics/runbooks detect breakage after disable/removal? | Safe support and rollback plan |

### Guide F — PSU administrator/owner

| Question code | Question | Evidence sought |
|---|---|---|
| `F01_REPOSITORY` | Which repository/revision is authoritative relative to runtime state? | Read-only source and deployment provenance |
| `F02_ENDPOINTS` | Which routes/actions exist and what approved outcomes do they provide? | Endpoint/action classes and owner candidates |
| `F03_AUTOMATION` | Which scripts, schedules, triggers, environments, modules, and jobs are active/seasonal/manual? | Static and runtime evidence references |
| `F04_SECRETS` | Which secret/app-token references exist and who owns rotation/revocation? | Metadata-only credential mapping |
| `F05_MUTATION` | Which scripts/actions mutate database, files, directory, integrations, or UAM configuration? | Capability classification and target classes |
| `F06_DECOMMISSION` | What is needed to disable/restore each endpoint/script/job safely? | Fixed rollback/removal plan |

### Guide G — IAM/security/credential owner

| Question code | Question | Evidence sought |
|---|---|---|
| `G01_IDENTITIES` | Which service accounts/logins/proxies/tokens/certificates serve which approved consumers? | Purpose/scope/consumer mapping |
| `G02_SHARED` | Which identities are shared, embedded, exportable, unmanaged, or difficult to rotate? | Risk/owner/exception state |
| `G03_ACCESS` | Which discovery permissions are the minimum and how are they time/target bound? | Least-privilege access design |
| `G04_EXPOSURE` | What event requires immediate rotation/revocation, and who decides? | Incident/credential runbook |
| `G05_REPLACEMENT` | What target identity model replaces direct SQL/shared secrets? | New component/contract/migration linkage |
| `G06_RETIRE` | What proves a credential is unused and can be revoked? | Use observation, owner approval, rollback/reissue plan |

### Guide H — HR/AD/directory/CMDB/data governance owner

| Question code | Question | Evidence sought |
|---|---|---|
| `H01_AUTHORITY` | Which source owns each identifier/attribute and historical correction? | Field-authority matrix |
| `H02_JOIN` | What exact join type, null/duplicate/history semantics, and realm boundary apply? | Typed integration requirement |
| `H03_PURPOSE` | Which uses are approved/prohibited, and what minimum projection is needed? | Purpose/privacy decision |
| `H04_QUALITY` | How are stale, missing, merged, split, or conflicting identities handled? | Quality states/test cases |
| `H05_LIFECYCLE` | What retention/deletion/access/appeal obligations apply to the projection? | Lifecycle/access decision |
| `H06_MIGRATION` | Which legacy relation should be preserved, changed, or retired? | Disposition authority |

### Guide I — integration/export/manual-workflow owner

| Question code | Question | Evidence sought |
|---|---|---|
| `I01_ROUTE` | What produces and consumes the output, by which governed interface class? | Producer/consumer/contract references |
| `I02_DESTINATION` | Which destination/recipient class, owner, and realm applies? | Destination registration without raw address |
| `I03_DELIVERY` | What proves accepted, processed, failed, replayed, or deleted? | Receipt/status/operational evidence |
| `I04_COPIES` | Are there file shares, mail, downloads, spreadsheets, backups, or recipient copies? | Copy/lifecycle limitation inventory |
| `I05_SECRET` | Which credentials/keys/service identities authorize delivery? | Metadata-only credential links |
| `I06_CUTOVER` | How can delivery be mirrored, paused, rolled back, and verified? | Parallel validation and rollback plan |

### Guide J — migration/retirement approver

| Question code | Question | Evidence sought |
|---|---|---|
| `J01_DISPOSITION` | Is the approved decision preserve outcome, deliberate change, retire, or investigate? | Signed/recorded disposition revision |
| `J02_TRACE` | Are evidence, requirement, owner, target component, contract, test, migration, rollback, and removal proof linked? | Graph-root validation |
| `J03_WINDOW` | Which dark/parallel/post-removal window and business cycles are required? | Approved window/coverage profile |
| `J04_STOP` | Which signal immediately stops or rolls back? | Finite stop conditions/runbook |
| `J05_RESIDUAL` | Which unknowns/limitations remain and who accepts them? | Risk decision reference |
| `J06_CLOSE` | What exact evidence permits closure and later expiry/deletion? | Removal proof and records decision |

## 10.4 Interview quality rules

- Interview response is **FACT** only that the assertion was made; its subject matter remains **ASSUMPTION** until corroborated.
- A respondent does not become the accountable owner merely by answering.
- Self-approval and role conflicts are tested under the governance profile.
- “No one uses it,” “always,” “never,” “temporary,” “just a report,” and “safe to delete” require evidence and are not accepted vocabulary by themselves.
- Unknown is an acceptable answer and must not be coerced into a guess.
- Contradictory interviews remain visible; the system does not select the most senior or confident statement automatically.
- Accessible interview/review workflows are part of the decision correctness gate.


---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Safety rules for all commands

- Commands use placeholders and opaque references only. No actual host, address, user, credential, token, key, path to a source system, connection string, or SSH configuration appears in evidence or this result.
- The release CLI resolves targets and credentials from separately protected approved configuration; it never accepts them on the command line.
- Shell history, process listings, CI logs, and job parameters therefore cannot reveal source connection material.
- Raw adapter working output stays in a tool-owned private directory and is never printed to stdout/stderr. Console output contains finite status codes and package IDs only.
- A command returning exit code zero proves only that its declared checks passed; the aggregate gate independently verifies the evidence root, canary positives, failures, and cleanup.

## 11.2 Reproducible build and dependency evidence

```powershell
# T1/offline repository lane only
$ErrorActionPreference = 'Stop'

dotnet --info
dotnet restore .\Uam.sln --locked-mode
dotnet build .\Uam.sln -c Release --no-restore
dotnet test .\Uam.sln -c Release --no-build --logger "trx"
dotnet publish .\src\tools\Uam.LegacyDiscovery\Uam.LegacyDiscovery.csproj `
  -c Release --no-build --self-contained false `
  -o .\artifacts\legacy-discovery

dotnet run --project .\src\tools\Uam.ReleaseManifest -- `
  create --input .\artifacts\legacy-discovery `
  --output .\artifacts\legacy-discovery-manifest
```

**Required evidence:** exact SDK/runtime/package/tool/source mapping; lock/source configuration; file/SHA-256 manifest; architecture-test results; test-hook absence; SBOM/provenance candidates; source-tree digest and clean state; build start/end; no undeclared network after locked restore.

**Pass:** every executable byte and dependency maps to an admitted exact source/package/binary; all tests pass; production artifact has no lab key, fault controller, shell, plugin, arbitrary SQL/path, or secret fixture.

**Fail:** floating/mutable input, unexplained binary/native module, license/security decision missing, test/destructive capability in release, or network source outside the approved restore phase.

## 11.3 Contract, parser, and query-pack commands

```powershell
dotnet run --project .\src\tools\Uam.ContractCheck -- `
  verify --catalog .\contracts\legacy-discovery\catalog.json `
  --schemas .\contracts\legacy-discovery\schemas `
  --vectors .\tests\contracts\legacy-discovery

dotnet run --project .\src\tools\Uam.LegacyDiscovery.QueryPackCheck -- `
  verify --catalog .\src\legacy-discovery\query-packs\catalog.json `
  --queries .\src\legacy-discovery\query-packs

dotnet run --project .\src\tools\Uam.LegacyDiscovery.ParserCorpus -- `
  verify --corpus .\tests\legacy-discovery\corpus `
  --profiles POWERSHELL_STATIC_V1,TSQL_STATIC_V1,STRUCTURED_CONFIG_V1

dotnet run --project .\src\tools\Uam.CanaryScan -- `
  self-test --registry .\tests\legacy-discovery\canaries\registry.json
```

**Required evidence:** schema dialect/tool identity; strict valid/invalid results; query AST/statement-family report; parser corpus partitions and resource bounds; mandatory canary positive-control matrix; mutation results for each forbidden path.

**Pass:** no remote schema reference; every forbidden query/contract/parser case fails as expected; all positive controls detected.

**Fail:** duplicate/unknown authority field accepted, query pack admits side effect/EXEC/dynamic identifier, parser executes/egresses, mandatory canary missed, or unsupported artifact receives a permissive classification.

## 11.4 Disconnected synthetic lab preparation

```powershell
dotnet run --project .\src\tools\Uam.LegacyDiscovery.LabFixture -- `
  create --fixture-profile LEGACY_DISCOVERY_T1_V1 `
  --output .\artifacts\lab-fixture

dotnet run --project .\src\tools\Uam.LegacyDiscovery.LabFixture -- `
  verify --fixture .\artifacts\lab-fixture
```

The fixture generator creates fictional endpoint services/tasks/registry/files/buffers, SQL schemas/jobs/Query Store/XE states, PSU repository/runtime metadata, consumers, credentials, integrations, and independent truth. It MUST NOT encode a real organizational name, URL, address, account, query, report, role, application, or distribution.

**Required evidence:** fixture classification, generator/oracle source revisions, deterministic package roots from two clean runs, truth ledger, canary registry, mutation sensitivity, and deletion/cleanup manifest.

## 11.5 Approved read-only inventory command sequence

The following commands are designed for a future separately authorized run. They are not authorization to connect now.

```powershell
# The opaque scope reference resolves protected targets and credential references.
uam-legacy-discovery validate-scope `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE>

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id endpoint.machine.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id endpoint.user-session.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.instance.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.schema.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.dependencies.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.security.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.agent.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.external.v1

# These read existing evidence only. They do not enable or alter capture.
uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.querystore.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id sql.xe-existing.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id psu.repository.v1

uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_SCOPE_REFERENCE> `
  --adapter-id psu.management-get.v1

uam-legacy-discovery parse-artifacts `
  --run-ref <OPAQUE_RUN_REFERENCE>

uam-legacy-discovery build-graph `
  --run-ref <OPAQUE_RUN_REFERENCE>

uam-legacy-discovery verify-pack `
  --package <TOOL_OWNED_PRIVATE_PACKAGE_DIRECTORY>

uam-legacy-discovery cleanup `
  --run-ref <OPAQUE_RUN_REFERENCE>
```

### Required evidence per command

| Command | Exact evidence produced |
|---|---|
| `validate-scope` | scope ID/digest/signature/sequence/time result; tool/release/schema/query-pack/sanitization profile digests; target-set revision/digest and count class; authority/owner function state; no target values |
| each `inventory` | adapter start/end/outcome; target alias; effective permissions/capability profile; source version/state; row/byte/time/resource counts; limitation codes; source pre/post identity; no-mutation evidence; observations/nodes/edges; first failure |
| `parse-artifacts` | parser profile/source/package identities; artifact count/classes; parse errors; dynamic/unsafe capability flags; unresolved/quarantine cases; allocation/time; no-execution trace |
| `build-graph` | node/edge counts by finite class; orphan/cross-realm/conflict findings; mandatory-path results; graph root/digest |
| `verify-pack` | schemas/line counts/hashes/package root; all-sink canary and forbidden-key results; provenance completeness; first-failure inclusion; independent verifier identity |
| `cleanup` | before/after process/file/registry/service/task/firewall/key/token/session/database-connection categories; working-set deletion result; residue findings; target-source unchanged evidence |

The run is accepted only when `cleanup` succeeds and the independent gate verifies all earlier evidence. An inventory package with failed cleanup remains quarantined.

## 11.6 Hashing and sanitization evidence

```powershell
uam-legacy-discovery verify-pack `
  --package <TOOL_OWNED_PRIVATE_PACKAGE_DIRECTORY> `
  --emit-verification <TOOL_OWNED_VERIFICATION_DIRECTORY>

uam-legacy-discovery export-sanitized `
  --package <TOOL_OWNED_PRIVATE_PACKAGE_DIRECTORY> `
  --profile DISCOVERY_SANITIZED_V1 `
  --output <TOOL_OWNED_SHAREABLE_DIRECTORY>

uam-legacy-discovery verify-pack `
  --package <TOOL_OWNED_SHAREABLE_DIRECTORY>
```

The first package may contain only restricted metadata permitted by the approved field profile, never secrets or raw activity. The shareable export is rebuilt from typed observations; it does not copy and redact arbitrary files.

**Required evidence:** input package root; output package root; schema/profile digests; exact dropped/retained field-class counts; local alias/key profile ID; every canary result; forbidden key/value scan; file manifest; exporter/verifier source/binary identity; deletion status for transient intermediate data.

## 11.7 Residual-use observation over an approved window

Observation is a sequence of immutable one-shot runs, not a persistent arbitrary monitor:

```powershell
# Invoked only by approved enterprise orchestration at approved points in the window.
uam-legacy-discovery inventory `
  --scope-ref <OPAQUE_APPROVED_OBSERVATION_SCOPE_REFERENCE> `
  --adapter-id <CLOSED_EXISTING_EVIDENCE_ADAPTER_ID>

uam-legacy-discovery compare-runs `
  --prior <TOOL_OWNED_PRIOR_SHAREABLE_PACKAGE> `
  --current <TOOL_OWNED_CURRENT_SHAREABLE_PACKAGE>

uam-legacy-discovery coverage `
  --package <TOOL_OWNED_AGGREGATED_PACKAGE> `
  --window-ref <OPAQUE_APPROVED_WINDOW_REFERENCE>

uam-legacy-discovery disposition-check `
  --package <TOOL_OWNED_AGGREGATED_PACKAGE>
```

The observation scope MUST identify the behavior/consumer classes, existing telemetry sources, capture configuration, expected business cycles, target population, start/end, evidence expiry, and owner review. It MUST NOT silently expand into new telemetry enablement or raw event collection.

**Required evidence:** all run roots and gaps; exact target population revisions; per-run terminal outcomes; Query Store/XE/Agent/PSU capture states/time ranges/resets/loss/retention; static/configuration changes; positive use observations; interviews; unreachable/unsupported targets; contradiction list; `PRESENT`/`NOT_OBSERVED_IN_SCOPE`/`UNKNOWN`/`CONTRADICTORY` claims; confidence rationale; no absolute absence.

**Primary pass gate for a retirement candidate:** complete mandatory graph; no open contradiction; accountable owner and criticality/retirement decision; observation interval covers approved cycles; material unreachable population resolved by human decision; reversible disable/rollback plan; parallel/dark validation; post-disable evidence.

## 11.8 Minimum CLI experiment catalogue

| Experiment ID | Command/fault focus | Exact proof required | Stop condition |
|---|---|---|---|
| CLI22-01 | build/toolchain/dependency capture | exact source/package/binary/license/SBOM/file graph | any unexplained executable or mutable dependency |
| CLI22-02 | strict contract/schema vectors | exact accepted/rejected corpus | authority-bearing malformed input accepted |
| CLI22-03 | fixed CLI/scope hostile inputs | zero adapter invocation on invalid/broadened input | arbitrary source/query/path/code reaches adapter |
| CLI22-04 | PowerShell static parser | no runspace/module/profile/child/network; expected AST flags | execution or unsafe false negative |
| CLI22-05 | T-SQL parser/query pack | no forbidden statement/dynamic identifier; zero DB mutation | DDL/DML/EXEC/external action admitted |
| CLI22-06 | XML/JSON/YAML/CSV/archive parser | no external access/formula/macro/traversal; bounded resources | egress/arbitrary read/execution/resource runaway |
| CLI22-07 | endpoint machine/session inventory | exact scope, zero mutation/cross-session/profile crawl | one source mutation or privacy-boundary violation |
| CLI22-08 | SQL metadata visibility | known-positive and permissions prove partial/complete semantics | hidden rows treated as absence |
| CLI22-09 | existing telemetry coverage | settings/time/reset/loss/retention captured; gaps explicit | quiet telemetry presented as complete absence |
| CLI22-10 | PSU repository/GET-only API | no endpoint/script/job/action invocation or token leak | mutating/custom call or side effect |
| CLI22-11 | credential/buffer classifiers | no secret/raw read/copy; unsafe/unknown quarantined | value escape or executable buffer touched |
| CLI22-12 | sanitizer/all-sink canaries | every mandatory positive detected; clean package has zero | one mandatory canary miss |
| CLI22-13 | package integrity/atomic publish | all tamper/partial/mix rejected | altered/incomplete package accepted |
| CLI22-14 | graph/disposition mutations | every missing path/owner/rollback blocks | incomplete item reaches ready/closed |
| CLI22-15 | coverage/absence model | controlled hidden/unreachable cases stay unknown | hidden consumer marked unused/retire-ready |
| CLI22-16 | resource/retry/cancellation | bounded use and attempts; no silent truncation | production interference/retry storm/unbounded growth |
| CLI22-17 | incident/cleanup | stop, isolate, copy inventory, revoke/delete, approved resume, zero residue | self-clear, missed copy, residue, sensitive incident report |
| CLI22-18 | accessibility/reviewer task | critical workflow task completion and safe interpretation | inaccessible/misleading workflow or bypass |
| CLI22-19 | repeated residual-use window | immutable runs/gaps/capture states/owners/claims | omitted run/failure, expired evidence, one quiet run treated proof |
| CLI22-20 | reversible retirement rehearsal | delayed use detected; rollback and removal proof pass | hidden breakage or rollback failure |

---

# 12. ADR proposals

| ADR | Decision | Proposed status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-022-001 | Adopt the primary migration gate: no legacy item migrated/removed without evidence, owner, disposition, validation, and rollback | **Proposed — accept** | Informal checklist; owner-only approval | Machine-testable path protects supplied evidence gaps and accepted invariants | Architecture Governance + Product/Risk | Falsifying migration experience or baseline change |
| ADR-022-002 | Use one-shot signed C#/.NET fixed-command discovery CLI | **Proposed — accept** | PowerShell script; persistent agent; generic inventory platform | Smallest authority/lifecycle surface; aligns with accepted implementation family | Discovery Engineering + Security | Continuing-monitoring need or scale failure |
| ADR-022-003 | Scope is immutable, signed/approved, exact-realm, and narrowing only | **Proposed — accept** | Operator arguments; free-form target/query config | Prevents local broadening and confused-deputy collection | Governance/IAM/Security | New orchestration/topology or control-artifact profile |
| ADR-022-004 | No arbitrary script, SQL, command, path, URL, plugin, report, or endpoint execution | **Proposed — accept** | Sandboxed execution; remote shell | Discovery is observation; execution recreates legacy risk and violates baseline | Product Security | Formal baseline change proposal only |
| ADR-022-005 | Endpoint discovery uses exact machine roots and ordinary-token user-session helper only where required | **Proposed — accept** | Machine profile crawl; service impersonation/token creation | Preserves accepted machine/session privacy boundary | Endpoint Security/Engineering | Required source cannot be safely observed |
| ADR-022-006 | SQL adapter uses fixed bounded SELECT query packs under least privilege; no telemetry enablement | **Proposed — accept** | Ad-hoc DBA script; stored toolkit; enable Query Store/XE | Proves read-only intent and exposes visibility gaps | Database Reliability/Security | Approved instrumentation need or engine change |
| ADR-022-007 | Repository-first PSU discovery with GET-only API supplement | **Proposed — accept** | Invoke endpoints/scripts; runtime-only API; direct DB | Minimizes action/secret surface and preserves provenance | PSU Platform Owner | PSU product/API/repository architecture change |
| ADR-022-008 | Parse PowerShell/T-SQL/configuration statically in isolated bounded parsers | **Proposed — accept** | Import/execute for validation; regex-only scanning | AST/parser evidence is safer and more precise; unresolved remains unknown | Secure Coding/Legacy Analysis | Parser cannot represent required language safely |
| ADR-022-009 | Use strict sanitized evidence package with local purpose-separated HMAC aliases and SHA-256 roots | **Proposed — accept principles; crypto profile dependency** | Raw inventory; reversible mapping; low-entropy SHA | Supports traceability without publishing names/addresses/secrets | Privacy/Cryptographic Architecture | Alias threat, algorithm/profile change, enterprise lineage integration |
| ADR-022-010 | Evidence graph is canonical; spreadsheets/UI are projections | **Proposed — accept** | Spreadsheet as source of truth; narrative-only report | Mandatory paths and contradictions become executable gates | Migration Governance/Data Architecture | Graph model cannot represent necessary relation |
| ADR-022-011 | Coverage states are `PRESENT`, `NOT_OBSERVED_IN_SCOPE`, `UNKNOWN`, `CONTRADICTORY`; no absolute absence | **Proposed — accept** | Used/unused boolean; confidence percentage | Reflects telemetry/population/static/interview limits honestly | Evidence Governance | Closed-world proof architecture established |
| ADR-022-012 | Disposition vocabulary is preserve approved outcome, deliberately change, retire, investigate/quarantine | **Proposed — accept** | Migrate/ignore/delete; confidence-based automation | Separates approved outcome from legacy implementation and makes unknown safe | Product/Data Governance | New disposition requires exact state/authority semantics |
| ADR-022-013 | Credential/buffer discovery is metadata/classification only; values/raw contents never copied or executed | **Proposed — accept** | Secret export; buffer migration as files; run deferred SQL | Directly contains highest legacy risks | Security/Privacy/Data Owner | Separate approved incident/migration treatment |
| ADR-022-014 | Existing runtime evidence may be read; enabling Query Store/XE/Audit is a separate mutating ADR | **Proposed — accept** | Treat enablement as discovery | Honest read-only boundary and resource/privacy governance | Database/SRE/Privacy | Coverage need established and instrumentation proposal ready |
| ADR-022-015 | Publication is immutable, content-addressed, independently verified, and atomic | **Proposed — accept** | Mutable evidence DB/file share; partial upload | Preserves first failure and decision binding | Evidence/Release Governance | Multi-party/witness/scale requirement |
| ADR-022-016 | Retirement uses reversible disable/dark validation before destructive removal where possible | **Proposed — accept** | Immediate deletion after inventory | Detects hidden/seasonal/manual consumers and preserves recovery | Product/Risk/Operations | Technology cannot support reversible state; requires exception/change plan |
| ADR-022-017 | Owner interviews are typed evidence assertions, not ownership or truth by themselves | **Proposed — accept** | Free-form survey decides; seniority wins contradiction | Prevents confident unsupported retirement and limits sensitive free text | Governance/Accessibility | New case/workflow system or evidence model |
| ADR-022-018 | Realm/product-global evidence and alias/key scopes are separate | **Proposed — accept** | Shared graph/alias namespace | Protects tenant isolation and re-identification risk | Realm Security/Cryptographic Architecture | Approved multi-realm oversight use case |
| ADR-022-019 | Discovery telemetry uses finite release-owned labels and bounded cardinality | **Proposed — accept** | Per-target/object/query labels | Avoids secondary inventory/PII leakage and operations failure | SRE/Privacy Engineering | New observability backend/use case |
| ADR-022-020 | OSS projects are reference or test candidates until exact admission; none is architecture authority | **Proposed — accept** | Select by popularity/vendor alignment | Maintenance/license/testing/security/threat fit differ materially | Architecture/Dependency Security/Legal | Exact candidate admission or project/license/security change |
| ADR-022-021 | Accessibility is a correctness gate for human disposition/removal workflows | **Proposed — accept principle** | Accessibility after implementation; spreadsheet/direct DB fallback | Misread uncertainty or inaccessible rollback creates safety/security risk | Product Accessibility/Governance | Organizational standard or UI technology change |
| ADR-022-022 | Run/target/evidence limits are execution-time profiles, not timeless numbers | **Proposed — accept** | Hardcode topic estimates | Estate, platform, and operations evidence is missing | Product/SRE/System Owners | Approved measurement and compatibility review |

No ADR may move to `Accepted` while its accountable owner function is unassigned, its required CLI gate is open, or it silently changes an accepted predecessor invariant.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record this result, six-input evidence manifest, and ADR templates | none | immutable review/evidence roots and decision register | missing/changed input or unreviewed Project dependency |
| 2 | Assign accountable functions for discovery governance, security, privacy, evidence, endpoint, database, PSU, migration, support, incident, accessibility | human governance | owner-function register and escalation map | any implementation-critical function unassigned |
| 3 | Define product discovery ceiling and immutable scope contract | 1–2; ADR-022-003/004 | strict schema, catalogue, vectors, authority/expiry/state model | any arbitrary query/path/code/target broadening representable |
| 4 | Scaffold `Uam.LegacyDiscovery` repository projects and architecture tests | 1–3; accepted Batch 01 repository boundary | buildable empty CLI/adapters/parsers/writer/verifier; protected paths | forbidden dependency/API mutation survives |
| 5 | Lock toolchain/package sources and dependency admission workflow | 4 | exact SDK/tool/package/source mapping; no-secret untrusted CI | floating/mutable/unmapped executable input |
| 6 | Implement shared strict contracts/scalars/errors/package schema | 3–5 | schemas, local bundles, valid/invalid/golden vectors | unknown/duplicate/remote/unbounded field accepted |
| 7 | Implement deterministic T1 discovery fixture generator and independent truth | 4–6 | fictional endpoint/SQL/PSU/consumer/credential/buffer corpus | production-derived value, nondeterminism, oracle common decision code |
| 8 | Implement exact canary registry and all-sink verifier | 4–7 | positive controls for every forbidden class/encoding/sink | one mandatory marker miss or broad suppression |
| 9 | Implement scope verifier, opaque target resolver interface, and fixed CLI grammar | 3–8 | no-source-access negative tests; local protected resolver stub | invalid/broadened input reaches adapter |
| 10 | Implement PowerShell static parser adapter and hostile corpus | 5–9 | AST/capability/unresolved contracts and no-execution proof | runspace/module/profile/child/network path or unsafe false negative |
| 11 | Implement T-SQL parser/query-pack compiler and statement policy | 5–9 | fixed query catalogue, AST verifier, golden/mutation corpus | DDL/DML/EXEC/external/dynamic query admitted |
| 12 | Implement bounded XML/JSON/YAML/CSV/archive parser | 5–9 | resolver-disabled structure-only parser and adversarial corpus | external fetch, formula/macro/traversal, unbounded resource |
| 13 | Implement sanitizer, realm/purpose-separated aliases, typed evidence writer, atomic publication | 6–12; crypto/privacy review | package output and independent verify/tamper proof | secret/raw/cross-realm/tamper/partial publication |
| 14 | Implement inventory/trace graph, coverage evaluator, disposition validator | 6–13 | mandatory artifacts and mutation-tested path/absence rules | incomplete/cross-realm/stale-approved item passes |
| 15 | Implement evidence-only interview import and accessible review projection | 6, 14 | structured guides/responses, contradiction and accessibility tests | assertion becomes owner/truth automatically; inaccessible critical task |
| 16 | Implement synthetic endpoint machine adapter | 7–13 | exact fixed roots, services/tasks/settings/buffers/network metadata | source mutation/profile crawl/raw escape/resource runaway |
| 17 | Implement synthetic ordinary-token user-session adapter | 7–13, 16 | exact-session fixture and cross-session negatives | token creation/elevation/cross-session/profile access |
| 18 | Implement SQL metadata adapter/query groups in synthetic lab | 7, 11, 13 | schema/dependency/security/Agent/external/session evidence | mutation, visibility gap hidden, unbounded load |
| 19 | Implement existing Query Store/XE/Audit/Agent history adapters | 7, 11, 13, 18 | capture/retention/reset/loss-aware runtime evidence | telemetry enablement/change or false completeness |
| 20 | Implement PSU repository and GET-only API adapters | 7, 10, 12, 13 | repo/runtime contradiction and no-action proof | custom/mutating call, token/route leak, script/job execution |
| 21 | Implement credential and buffer classifiers | 8, 10–13, 16–20 | metadata-only mappings and incident integration | secret value/raw copy/unsafe buffer marked migratable |
| 22 | Execute aggregate synthetic hostile campaign P22-01 through P22-08 | 1–21 | content-addressed evidence and cleanup roots | any zero-tolerance failure or residue |
| 23 | Complete dependency/OSS admission decisions for any chosen package/tool | 5, 10–12, 22 | exact source/package/binary/license/security/removal records | unresolved provenance/license/advisory or UAM false negative |
| 24 | Prepare disconnected approved-run scripts, runbooks, evidence schema, and support workflow | 15–23 | placeholder/opaque-ref-only operational bundle | any actual connection/credential/address/raw identifier in evidence |
| 25 | Obtain HD22-01/08/09/17/18 authority for one target of each approved class | human decisions; 22–24 | signed scope, field/access/deletion/resource/incident/support profile | missing authority/owner or unsafe access path |
| 26 | Run R2 one-target read-only endpoint experiment | 25; endpoint platform approval | exact package, no-mutation/resource/cleanup evidence | unexpected access/load/mutation/raw/residue |
| 27 | Run R2 one-target read-only SQL experiment | 25; DBA approval | permission/canary/query/runtime/cleanup evidence | write/lock/load/visibility/secret/raw failure |
| 28 | Run R2 PSU repository/API read-only experiment | 25; PSU owner approval | repository/API/no-action/cleanup evidence | unexpected route/method/action/secret/raw failure |
| 29 | Review R2 evidence with source owners and resolve contradictions | 26–28; HD22-02/03 | verified owner assertions and refined scope/coverage | unsupported conclusions or unresolved safety finding |
| 30 | Define authoritative estate population and representative R3 wave | 29; Asset/Data/System owners | target-set revision, variant matrix, run/stop/support plan | denominator unknown or unhandled unreachable policy |
| 31 | Execute R3 representative wave and resource/operations measurements | 30 | bounded package set, population reconciliation, cost/support evidence | scanner/mutation/load/retry/cleanup/cardinality/support failure |
| 32 | Decide whether estate discovery R4 is authorized/funded | 31; HD22-21 | estate plan or explicit defer | no sustainable operations/owners/budget |
| 33 | Execute approved R4 waves and aggregate graph/coverage | 32 | complete run roots/failures/unreachable/contradictions/owner queue | omitted run/target/failure, stale evidence, unresolved incident |
| 34 | Create item-level disposition backlog | 14–15, 29 or 33 | preserve/change/retire/investigate revisions and mandatory trace gaps | automatic owner/purpose/criticality or removal inferred |
| 35 | Resolve credentials, buffers, dynamic SQL, reports, integrations, HR/AD joins, and manual workflows | 21, 34; relevant human decisions | target requirements/contracts or explicit quarantine/retire plans | secret/raw execution/copy, owner/purpose unknown, cross-realm ambiguity |
| 36 | Link preserve/change items to accepted target architecture/contracts/tests | 34–35; predecessor/target batch gates | complete trace path and synthetic acceptance oracle | direct SQL/secret/script/plugin or target gate missing |
| 37 | Define item-specific parallel/dark validation and rollback | 36; HD22-06/15/16 | comparison plans, stop conditions, support/runbook | no independent oracle, rollback untested, business cycle omitted |
| 38 | Execute T1 migration/retirement rehearsals P22-09/P22-10 | 37 | delayed-use, rollback, accessibility, removal-proof evidence | hidden consumer, semantic mismatch, rollback/accessibility failure |
| 39 | Obtain accountable cutover/retirement approvals | 34–38; HD22-02/03/04/15/16/23 | authority bound to exact evidence/graph roots | any mandatory human decision or gate open |
| 40 | Execute separately authorized parallel validation/cutover/disable | 39; target implementation/release gates | stable outcomes and first-failure evidence | material difference, privacy/security/durability/support failure |
| 41 | Perform reversible observation and rollback as needed | 40; HD22-06 | bounded residual-use evidence | new/delayed/manual consumer or unresolved failure |
| 42 | Perform separately authorized destructive removal only after pass | 41 | removal action and audit | rollback unavailable, stale evidence, unknown/unreachable affected scope |
| 43 | Run post-removal discovery and publish removal proof | 42 | no-use-in-scope, no residue, support/consumer verification, graph closure | any use/error/residue/contradiction |
| 44 | Retain/delete evidence under approved lifecycle and schedule recurring review | 43; HD22-09 | deletion/retention proof and review triggers | indefinite/unowned retention or expired evidence used as authority |

## 13.2 Stop-gate hierarchy

A lower item cannot waive a higher stop condition:

1. **Safety gate:** secret/raw escape, cross-realm evidence, arbitrary execution, source mutation, package tamper, or cleanup failure stops the lane.
2. **Evidence gate:** missing population, visibility, capture, parser, time, or first-failure evidence blocks coverage/absence claims.
3. **Ownership gate:** missing purpose, owner, criticality, inspection authority, unreachable-device decision, or retention blocks migration/removal.
4. **Trace gate:** missing requirement/component/contract/test/migration/rollback/removal-proof edge blocks cutover/closure.
5. **Target gate:** the new system's privacy, durability, release, identity, server, lifecycle, portal, audit, capacity, and compatibility gates remain independent and must pass where relevant.
6. **Production gate:** a technical pass never authorizes pilot/production without designated risk/production approval.


---

# 14. Open-source repository assessment table

Open-source review is design evidence, not automatic dependency approval. Exact execution-time admission still requires source/package/binary mapping, license/procurement review, advisories, malicious-input tests, SBOM/provenance, and a removal plan.

| Project and reviewed point | Relevant files/directories | License / maintenance / security / tests | Architectural similarity and threat-model difference | Reusable ideas | Ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| **PSScriptAnalyzer** — https://github.com/PowerShell/PSScriptAnalyzer; release [`1.25.0`](https://github.com/PowerShell/PSScriptAnalyzer/releases/tag/1.25.0), 20 March 2026, commit `f05704d`, signed | [`Engine/`](https://github.com/PowerShell/PSScriptAnalyzer/tree/1.25.0/Engine), [`Rules/`](https://github.com/PowerShell/PSScriptAnalyzer/tree/1.25.0/Rules), [`Tests/`](https://github.com/PowerShell/PSScriptAnalyzer/tree/1.25.0/Tests), [`docs/`](https://github.com/PowerShell/PSScriptAnalyzer/tree/1.25.0/docs), `SECURITY.md` | MIT; active 2026 release; substantial test/rule corpus and security policy. Running the module supports custom scripted/compiled rules and normal PowerShell module behavior. | Similar: static PowerShell diagnostics and rules. Different: UAM treats script as hostile evidence and must guarantee no module/custom-rule/profile execution or raw result leakage. | Rule vocabulary, compatibility/security smells, test-corpus construction, parser-error handling. | Do not import production artifacts, load custom rules from discovered paths, run formatter/fix, or use rule output as the UAM oracle. | **Reference and isolated test candidate.** Direct `System.Management.Automation.Language.Parser` remains the narrower core. |
| **DacFx / Microsoft.Build.Sql** — https://github.com/microsoft/DacFx; tag [`sdk-2.2.0`](https://github.com/microsoft/DacFx/releases/tag/sdk-2.2.0), GA 6 June 2026, commit `f23e116`, signed | [`src/Microsoft.Build.Sql`](https://github.com/microsoft/DacFx/tree/sdk-2.2.0/src/Microsoft.Build.Sql), [`test`](https://github.com/microsoft/DacFx/tree/sdk-2.2.0/test), [`release-notes`](https://github.com/microsoft/DacFx/tree/sdk-2.2.0/release-notes) | MIT; Microsoft-maintained; current signed release and tests. DacFx/SqlPackage also support extraction, deployment, comparison, and database lifecycle operations. | Similar: T-SQL/database model parsing and dependency concepts. Different: UAM discovery is fixed read-only metadata observation; DacFx has broad deploy/extract/change authority and its model does not prove runtime consumers. | Model comparison vocabulary, package/source identity discipline, synthetic database-project fixtures. | Do not deploy, extract production databases broadly, generate changes, or treat a DAC model as complete dependency/runtime proof. | **Reference; conditional isolated test candidate.** Not required for first CLI. |
| **SQL Script DOM** — https://github.com/microsoft/SqlScriptDOM; NuGet [`Microsoft.SqlServer.TransactSql.ScriptDom 180.78.1`](https://www.nuget.org/packages/Microsoft.SqlServer.TransactSql.ScriptDom/180.78.1), published 30 July 2026. Repository source corresponding exactly to that package was not proven in this review; repository visibly contains `SqlScriptDom/`, `Test/`, `SECURITY.md`, and documentation stating 1,100+ tests. | [`SqlScriptDom/`](https://github.com/microsoft/SqlScriptDOM/tree/main/SqlScriptDom), [`Test/`](https://github.com/microsoft/SqlScriptDOM/tree/main/Test), [`release-notes/`](https://github.com/microsoft/SqlScriptDOM/tree/main/release-notes), `SECURITY.md`, `SUPPORT.md` | MIT; Microsoft-owned NuGet namespace; active package/repository; large stated test suite and security policy. Exact package-to-source/commit mapping remains open. | Similar: exact T-SQL AST and version-specific grammar. Different: parser acceptance does not prove semantic/runtime dependencies and malicious-input/resource fitness is unproved for UAM. | AST visitor, dialect/version selection, parser-error vectors, statement-family classification. | Do not execute parsed SQL, trust parse success as safety, or admit the package without exact source/binary/provenance and hostile corpus. | **Leading candidate dependency after admission; currently reference only.** |
| **Syft** — https://github.com/anchore/syft; immutable signed release [`v1.50.0`](https://github.com/anchore/syft/releases/tag/v1.50.0), 28 July 2026, commit `16223e6` | [`syft/`](https://github.com/anchore/syft/tree/v1.50.0/syft), [`schema/`](https://github.com/anchore/syft/tree/v1.50.0/schema), [`internal/`](https://github.com/anchore/syft/tree/v1.50.0/internal), [`cmd/`](https://github.com/anchore/syft/tree/v1.50.0/cmd) | Apache-2.0; very recent immutable signed release; active tests/security policy. Its security policy says intentionally malicious content may confuse it or cause omissions outside its expected threat boundary. | Similar: software/component inventory and content-addressed output. Different: UAM inputs may be hostile and completeness is gate-critical; Syft is not designed as a malicious-content oracle. | SBOM formats, cataloger isolation ideas, source/location evidence, file/package reconciliation. | Do not scan arbitrary production roots, accept omissions as proof of absence, or use Syft as sole dependency/file oracle. | **Test-only SBOM candidate after admission.** Never authoritative alone. |
| **osquery** — https://github.com/osquery/osquery; release [`5.23.1`](https://github.com/osquery/osquery/releases/tag/5.23.1), 24 June 2026, commit `b753833`; release fixed Windows `processes` and `authenticode` heap overflows | [`osquery/`](https://github.com/osquery/osquery/tree/5.23.1/osquery), [`specs/`](https://github.com/osquery/osquery/tree/5.23.1/specs), [`tests/`](https://github.com/osquery/osquery/tree/5.23.1/tests), `ASSURANCE.md`, `SECURITY.md` | Repository carries Apache-2.0 and GPL-2.0 files; legal boundary requires exact component review. Active security-fix release, broad native/plugin code and persistent-agent ecosystem. | Similar: queryable endpoint inventory across Windows. Different: broad SQL tables, plugins/extensions, remote/distributed query, persistent monitoring, and high-authority agent are outside the narrow one-shot UAM threat model. | Table schemas, platform-fact normalization, test/assurance documentation, query-result typing. | Do not deploy a persistent osquery agent or expose arbitrary/distributed SQL/plugins for this lane; do not inherit its broad data fields. | **Reference only; neither dependency nor deployment for first lane.** |
| **OpenLineage** — https://github.com/OpenLineage/OpenLineage; signed release [`1.46.0`](https://github.com/OpenLineage/OpenLineage/releases/tag/1.46.0), 21 April 2026, commit `ab0b1a9` | [`spec/`](https://github.com/OpenLineage/OpenLineage/tree/1.46.0/spec), [`client/`](https://github.com/OpenLineage/OpenLineage/tree/1.46.0/client), [`integration/`](https://github.com/OpenLineage/OpenLineage/tree/1.46.0/integration), [`tests/`](https://github.com/OpenLineage/OpenLineage/tree/1.46.0/tests) | Apache-2.0; active LF AI & Data project; signed release, clients/integrations/tests. Extensible facets and transports can carry source-code locations, SQL, URLs, and runtime metadata. | Similar: job/dataset/run lineage and provenance. Different: UAM needs a closed privacy-minimized migration graph, not runtime event transport or open custom facets. | Entity/activity/run vocabulary, producer/consumer lineage, versioned schemas, integration inventory concepts. | Do not adopt open facets, automatic source URL/code/SQL emission, network lineage backend, or runtime-instrument-everything model. | **Reference only.** UAM’s closed graph is safer for first lane. |
| **SQLGlot** — https://github.com/tobymao/sqlglot; PyPI [`30.14.0`](https://pypi.org/project/sqlglot/30.14.0/), 27 July 2026. Exact PyPI artifact-to-GitHub commit/tag mapping was not closed in this review. | [`sqlglot/`](https://github.com/tobymao/sqlglot/tree/main/sqlglot), [`tests/`](https://github.com/tobymao/sqlglot/tree/main/tests), [`benchmarks/`](https://github.com/tobymao/sqlglot/tree/main/benchmarks), integration-test submodule | MIT; highly active and large test suite; no repository `SECURITY.md` was found in the reviewed root navigation. Generic Python parser/transpiler/optimizer with SQL-building/execution features. | Similar: SQL AST, lineage/metadata helpers, dialect differential testing. Different: generic multi-dialect behavior is not T-SQL authority; Python/runtime and execution/optimizer surfaces are unnecessary. | Differential corpus, AST traversal, dialect/error test ideas. | Do not use as sole T-SQL parser, execute/transpile discovered SQL, or add Python runtime without measured need and exact source mapping. | **Reference/differential-test only.** |
| **SQL Server First Responder Kit** — https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit; signed tag [`20260708`](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/releases/tag/20260708), 8 July 2026, commit `7562068` | Repository stored procedures/scripts including `sp_Blitz*`, install scripts, tests/docs at the reviewed tag | MIT; active annual 2026 release, community-maintained and signed tag. It is designed to install/run diagnostic stored procedures and can inspect detailed plan-cache/query/database state; some options integrate external/AI paths. | Similar: SQL Server operational/dependency/workload discovery. Different: UAM requires no installation, no broad procedure execution, metadata-only privacy, and exact query contracts. | Diagnostic question catalogue, known SQL Server edge cases, operational limitation ideas. | Do not install or run the kit, copy broad query output, call external AI, or treat its findings as UAM evidence truth. | **Reference only; neither dependency nor execution path.** |
| **Liquibase** — https://github.com/liquibase/liquibase; signed release [`v5.0.3`](https://github.com/liquibase/liquibase/releases/tag/v5.0.3), 15 May 2026, commit `4d815ea`; release includes two security fixes | [`liquibase-standard/`](https://github.com/liquibase/liquibase/tree/v5.0.3/liquibase-standard), [`liquibase-integration-tests/`](https://github.com/liquibase/liquibase/tree/v5.0.3/liquibase-integration-tests), changelog/rollback tests and docs | FSL-1.1-ALv2 for current community source; not treated as ordinary OSI open source here and requires Legal/Procurement review. Active releases/tests/security fixes. | Similar: versioned database changes, rollback, checksums, changelog trace. Different: change-first migration tool; it cannot discover hidden consumers or runtime dependencies and introduces mutation authority. | Changelog/checksum/rollback discipline and migration evidence concepts. | Do not use it to discover use, execute legacy SQL, or make its changelog the rollback/consumer oracle. | **Reference only for migration records; not a first-lane dependency.** |
| **DataHub** — https://github.com/datahub-project/datahub; signed release [`v1.6.0`](https://github.com/datahub-project/datahub/releases/tag/v1.6.0), 21 May 2026, commit `059a36c` | [`metadata-models/`](https://github.com/datahub-project/datahub/tree/v1.6.0/metadata-models), [`metadata-ingestion/`](https://github.com/datahub-project/datahub/tree/v1.6.0/metadata-ingestion), [`datahub-graphql-core/`](https://github.com/datahub-project/datahub/tree/v1.6.0/datahub-graphql-core), tests and upgrade docs | Apache-2.0; large active platform with many services, connectors, dependencies, migration and operations requirements; signed release/security-quality surface. | Similar: metadata graph, ownership, lineage, schema/entity relationships. Different: enterprise metadata platform with broad connectors, network ingestion, search/UI/service topology, and open metadata fields. | Ownership/lineage/entity concepts, connector capability inventory, upgrade/migration discipline. | Do not deploy a new platform for this bounded lane, ingest raw SQL/source/addresses, or inherit its broad connector/operational failure domains. | **Reference only.** A future narrow adapter to an already-approved enterprise instance is possible. |

## 14.1 Repository-review conclusion

**RECOMMENDATION.** No reviewed repository should be copied as an architecture. The strongest possible first-lane dependency candidate is SQL Script DOM, but only after exact package/source/binary mapping and UAM hostile-input admission. PSScriptAnalyzer and SQLGlot are useful differential/reference tools; Syft may be a secondary SBOM tool; all others are reference-only or unsuitable for deployment in this lane.

---

# 15. Source register with stable links, dates, versions/commits, claims, and limitations

## 15.1 Supplied project evidence

| Ref | Source | Date/version/hash | Claim supported | Limitation |
|---|---|---|---|---|
| P00 | Initiating Prompt 22 attachment | SHA-256 `20bc3e6f33b98ba05327b79d10af9145f8cefe9a27081f91fdb6ee3ad5e54727`; reviewed 1 August 2026 | Required questions, constraints, output order, human decisions, web/OSS review, primary gate | Instruction, not evidence that a technical claim is true |
| I01 | `00-accepted-baseline-attachment.md` | baseline 31 July 2026; SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted endpoint/server/privacy/durability/realm/release invariants and human-decision boundary | Condensed baseline; not runtime proof or production approval |
| I02 | `01-existing-system-evidence-summary.md` | SHA-256 `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | Legacy monolithic PowerShell, direct SQL, executable deferred CSV SQL, collectors, settings/checkpoints, PSU/admin/schema characteristics and evidence gaps | Static sanitized summary; no runtime configuration, raw code, external consumer completeness, rates, or operational truth |
| I03 | `04-data-and-schema-evidence-summary.md` | SHA-256 `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | 27 tables/569 fields/weak physical relationships, implicit joins, executable deferred SQL, target typed/provenance principles | No row values, query corpus, rates, retention, engine benchmark, or semantics proof |
| I04 | `05-decisions-contradictions-and-gates.md` | SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted architecture choices and ordered proof gates | Implementation-research baseline, not unconditional production authority |
| I05 | `06-research-evidence-rules.md` | SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, primary-source preference, privacy boundaries, human authority, conflict/change rules | Research-quality rules; not proof of platform behavior |
| I06 | `batch-01-review-result.md` (reviewed local `batch-01-review-result(3).md`) | 31 July 2026; SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, UUIDv7/SHA-256, fictional-first evidence, privacy lattice, application identity, repository/release, process/session boundaries | Foundation architecture accepted with mandatory conditions; Windows/runtime/security gates remain empirical |

## 15.2 Microsoft SQL Server primary sources

| Ref | Stable source | Source/review date and version | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| W01 | Microsoft Learn — [`sys.sql_expression_dependencies`](https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-sql-expression-dependencies-transact-sql?view=sql-server-ver17) | SQL Server v17 documentation; reviewed 1 August 2026 | Persisted by-name SQL expression dependency metadata and documented scope/limitations | Does not resolve all dynamic/caller-dependent/temp/external/runtime behavior; metadata visibility applies |
| W02 | Microsoft Learn — [`sys.dm_sql_referenced_entities`](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-functions/sys-dm-sql-referenced-entities-transact-sql?view=sql-server-ver17) and [`sys.dm_sql_referencing_entities`](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-functions/sys-dm-sql-referencing-entities-transact-sql?view=sql-server-ver17) | SQL Server v17 documentation; reviewed 1 August 2026 | Referenced/referencing entity discovery and documented exceptions | By-name/static metadata is not complete runtime lineage and can fail/omit under unsupported constructs/permissions |
| W03 | Microsoft Learn — [Metadata Visibility Configuration](https://learn.microsoft.com/en-us/sql/relational-databases/security/metadata-visibility-configuration?view=sql-server-ver17) | updated 20 July 2026; reviewed 1 August 2026 | Metadata returned by catalog views/functions is permission-scoped and may be partial/empty | Exact visibility depends on effective ownership/permissions and target version; known-positive canaries still needed |
| W08 | Microsoft Learn — [Monitor performance by using Query Store](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver17) | updated 20 July 2026; SQL Server v17 docs | Query Store retains query/plan/runtime history; configuration/defaults/version behavior | Query Store is not all SQL activity, can be disabled/read-only/reset/cleaned, and enabling it is a change |
| W09 | Microsoft Learn — [`sys.database_query_store_options`](https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-database-query-store-options-transact-sql?view=sql-server-ver17) | updated 20 July 2026; SQL Server v17 docs | Actual/desired state, capture mode, cleanup/limits, and configuration evidence | A configured state does not prove capture completeness or no dropped/filtered queries |
| W10 | Microsoft Learn — [Extended Events overview](https://learn.microsoft.com/en-us/sql/relational-databases/extended-events/extended-events?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | XE session/event/target model and use for runtime observation | Session design, predicates, target loss, retention, load, privacy, and UAM fitness remain empirical |
| W11 | Microsoft Learn — [`sys.fn_xe_file_target_read_file`](https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-xe-file-target-read-file-transact-sql?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | Existing XE event-file target data can be read through a documented function | File path/access, rollover, schema/event payload, permissions, and potentially sensitive data require strict local handling |
| W12 | Microsoft Learn — [`CREATE EVENT SESSION`](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-event-session-transact-sql?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | Creating/changing XE sessions is a configuration operation | Supports the conclusion that new capture is outside the read-only lane; exact production effects require measurement |
| W13 | Microsoft Learn — [SQL Server Agent tables](https://learn.microsoft.com/en-us/sql/relational-databases/system-tables/sql-server-agent-tables-transact-sql?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | Documented `msdb` tables for Agent jobs, steps, schedules, history, proxies and related metadata | Command/history data may be sensitive; retention/purging and permissions prevent completeness claims |
| W14 | Microsoft Learn — [Credentials (Database Engine)](https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/credentials-database-engine?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | SQL credentials map authentication information to external resources and require security handling | Discovery must not retrieve secret values; metadata alone does not prove owner/current use/exportability |
| W15 | Microsoft Learn — [Linked servers](https://learn.microsoft.com/en-us/sql/relational-databases/linked-servers/linked-servers-database-engine?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | Linked-server capability and external data access surface | Existence/configuration does not prove current use; provider strings/remote names are sensitive and locally aliased |
| W16 | Microsoft Learn — [`sys.external_data_sources`](https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-external-data-sources-transact-sql?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | External data source metadata for governed external-route inventory | Feature availability/version and credentials/endpoints vary; no raw location/secret export |
| W17 | Microsoft Learn — [`sys.dm_exec_sessions`](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql?view=sql-server-ver17) | SQL Server v17 docs; reviewed 1 August 2026 | Current session/client/program/login/database metadata exists for point-in-time observation | Values can be client-supplied/spoofed; one snapshot is not historical use or owner identity |

## 15.3 Windows and PowerShell primary sources

| Ref | Stable source | Source/review date/version | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| W19 | Microsoft .NET API — [`System.Management.Automation.Language.Parser`](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser?view=powershellsdk-7.6.0) | PowerShell SDK 7.6 API profile; reviewed 1 August 2026 | Parser API exposes AST/tokens/errors without requiring script invocation | UAM must still sandbox/bound input and map exact runtime/package; parser does not prove behavior/safety |
| W20 | Microsoft .NET API — [`Parser.ParseFile`](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parsefile?view=powershellsdk-7.6.0) | PowerShell SDK 7.6 API profile; reviewed 1 August 2026 | Static file parsing interface for PowerShell source | File access/encoding/resource behavior and malicious corpus remain UAM tests; do not import/execute modules |
| W21 | Microsoft Learn — [`Get-ScheduledTask`](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/get-scheduledtask?view=windowsserver2025-ps) | Windows Server 2025 PowerShell docs; reviewed 1 August 2026 | Read scheduled-task definitions | Exact OS/task-service behavior, permissions, XML sensitivity, and zero-mutation need lab proof |
| W22 | Microsoft Learn — [`Get-ScheduledTaskInfo`](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/get-scheduledtaskinfo?view=windowsserver2025-ps) | Windows Server 2025 PowerShell docs; reviewed 1 August 2026 | Read task runtime information such as last/next run and state | History can be absent/stale and does not prove business use; task action/arguments can be sensitive |
| W23 | Microsoft Learn — [`Get-NetTCPConnection`](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection?view=windowsserver2025-ps) | Windows Server 2025 PowerShell docs; reviewed 1 August 2026 | Current TCP connection metadata can support bounded point-in-time route evidence | One snapshot is not historical/intent proof; remote/local values are sensitive and omitted from shareable output |
| W24 | Microsoft Learn — [Working with software installations](https://learn.microsoft.com/en-us/powershell/scripting/samples/working-with-software-installations?view=powershell-7.6) | updated 17 March 2023; reviewed 1 August 2026 | Microsoft warns `Win32_Product` is slow and can trigger consistency checks/repair | Supports avoiding it; exact safer inventory APIs and enterprise estate behavior still need qualification |

## 15.4 PowerShell Universal primary sources

These are live vendor documentation pages reviewed on 1 August 2026. The exact deployed PSU version and API/repository behavior must be captured at execution; documentation capability is not UAM fitness.

| Ref | Stable source | Claim supported | Limitation |
|---|---|---|---|
| W25 | Devolutions — [API endpoints](https://docs.devolutions.net/powershell-universal/api/endpoints) | Endpoints/routes/actions and API hosting concepts exist | Custom endpoints can execute code and must never be called during discovery |
| W26 | Devolutions — [Automation scripts](https://docs.devolutions.net/powershell-universal/automation/scripts) | Scripts can be configured and run through PSU automation | Script definitions/history may contain secrets/logic; repository/static parse only |
| W27 | Devolutions — [Schedules](https://docs.devolutions.net/powershell-universal/automation/schedules) | Scripts/jobs can be scheduled | Schedule existence/history does not prove owner/purpose/current use |
| W28 | Devolutions — [Triggers](https://docs.devolutions.net/powershell-universal/automation/triggers) | Event triggers can initiate automation | Trigger coverage/event sources and runtime effects require exact local evidence |
| W29 | Devolutions — [Jobs](https://docs.devolutions.net/powershell-universal/automation/jobs) | PSU retains job/runtime concepts and histories | History can be bounded/purged; discovery never starts/restarts a job |
| W30 | Devolutions — [Repository configuration](https://docs.devolutions.net/powershell-universal/config/repository) | Repository-backed configuration/provenance is a primary discovery source | Repository/runtime can diverge; exact deployment/revision must be compared |
| W31 | Devolutions — [Management API](https://docs.devolutions.net/powershell-universal/config/management-api) | Management API can expose configuration/runtime metadata | API permissions/routes/version and side effects require exact GET-only qualification |
| W32 | Devolutions — [App tokens](https://docs.devolutions.net/powershell-universal/security/app-tokens) | App tokens authorize API access and are sensitive credential references | Token values must never be exported; exact least-privilege/rotation behavior is human/CLI gated |
| W33 | Devolutions — [API overview/about](https://docs.devolutions.net/powershell-universal/api/about) | PSU API/application architecture context | Documentation is not a stable contract for the installed version without compatibility evidence |

## 15.5 Standards and incident/provenance sources

| Ref | Stable source | Date/version | Claim supported | Limitation |
|---|---|---|---|---|
| W34 | JSON Schema — [Draft 2020-12](https://json-schema.org/draft/2020-12) | 2020-12 | Structural validation dialect and local bundle profile | Validator conformance and semantic/privacy correctness need UAM vectors |
| W35 | IETF RFC 8259 — [The JSON Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259) | December 2017 | Base JSON syntax/UTF-8 interoperability guidance | Does not define UAM strict duplicate/unknown/limit semantics |
| W36 | IETF RFC 3339 — [Date and Time on the Internet](https://www.rfc-editor.org/rfc/rfc3339) | July 2002 | UTC timestamp representation profile | Clock quality, precision, business ordering and privacy remain separate |
| W37 | IETF RFC 8785 — [JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785) | June 2020 | Candidate deterministic canonical JSON bytes for compatible objects | Informational profile with number/string constraints; UAM canonicalization remains an ADR/experiment |
| W38 | IETF RFC 9562 — [Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562) | May 2024 | UUIDv7 layout and canonical identifier standard | UUID time bits are not business time, authorization, ordering, or evidence precision |
| W40 | W3C — [PROV-DM](https://www.w3.org/TR/prov-dm/) | Recommendation, 30 April 2013 | Entity/activity/agent/provenance concepts | UAM uses a smaller closed privacy-safe model; the full standard is not an automatic schema/dependency |
| W41 | W3C — [PROV-O](https://www.w3.org/TR/prov-o/) | Recommendation, 30 April 2013 | Formal provenance ontology relationships | RDF/OWL/open properties are broader than needed and can expose source details |
| W42 | NIST SP 800-61 Rev. 3 — [Incident Response Recommendations and Considerations for Cybersecurity Risk Management](https://csrc.nist.gov/pubs/sp/800/61/r3/final) | final April 2025 | Current incident-response lifecycle/process guidance | Organizational severity, notification, legal, staffing, and exact runbooks remain human-owned |

## 15.6 Open-source review points

| Ref | Repository/release | Reviewed point/date | Claim supported | Limitation |
|---|---|---|---|---|
| O01 | [PowerShell/PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer), [1.25.0](https://github.com/PowerShell/PSScriptAnalyzer/releases/tag/1.25.0) | commit `f05704d`, 20 March 2026 | Static rule/test/reference design for PowerShell | Module/custom-rule execution surface; not UAM oracle/dependency by default |
| O02 | [microsoft/DacFx](https://github.com/microsoft/DacFx), [sdk-2.2.0](https://github.com/microsoft/DacFx/releases/tag/sdk-2.2.0) | commit `f23e116`, GA 6 June 2026 | Database model/build/compare concepts | Broad extract/deploy/change surface; no runtime-consumer proof |
| O03 | [microsoft/SqlScriptDOM](https://github.com/microsoft/SqlScriptDOM), [NuGet 180.78.1](https://www.nuget.org/packages/Microsoft.SqlServer.TransactSql.ScriptDom/180.78.1) | package 30 July 2026; exact source commit mapping unresolved | T-SQL AST candidate, MIT/security policy/test suite | No dependency admission until source/package/binary mapping and hostile tests close |
| O04 | [anchore/syft](https://github.com/anchore/syft), [v1.50.0](https://github.com/anchore/syft/releases/tag/v1.50.0) | commit `16223e6`, 28 July 2026 | SBOM/cataloger design and secondary inventory | Explicit malicious-content omission/confusion limitation; not sole oracle |
| O05 | [osquery/osquery](https://github.com/osquery/osquery), [5.23.1](https://github.com/osquery/osquery/releases/tag/5.23.1) | commit `b753833`, 24 June 2026 | Endpoint inventory table/reference concepts | Broad persistent agent/plugin/query surface and mixed license files |
| O06 | [OpenLineage/OpenLineage](https://github.com/OpenLineage/OpenLineage), [1.46.0](https://github.com/OpenLineage/OpenLineage/releases/tag/1.46.0) | commit `ab0b1a9`, 21 April 2026 | Lineage/run/job/dataset vocabulary | Open facets/transports/source metadata are too broad for UAM first lane |
| O07 | [tobymao/sqlglot](https://github.com/tobymao/sqlglot), [PyPI 30.14.0](https://pypi.org/project/sqlglot/30.14.0/) | 27 July 2026; exact source commit mapping unresolved | Differential generic SQL parsing/test ideas | Not T-SQL authority; Python/execution/optimizer surface; no reviewed SECURITY.md |
| O08 | [SQL Server First Responder Kit](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit), [20260708](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/releases/tag/20260708) | commit `7562068`, 8 July 2026 | SQL Server operational-question reference | Installs/runs broad stored procedures and collects detailed data; never run in discovery |
| O09 | [liquibase/liquibase](https://github.com/liquibase/liquibase), [v5.0.3](https://github.com/liquibase/liquibase/releases/tag/v5.0.3) | commit `4d815ea`, 15 May 2026 | Changelog/checksum/rollback concepts | FSL-1.1-ALv2/legal review and mutation-first architecture; not discovery dependency |
| O10 | [datahub-project/datahub](https://github.com/datahub-project/datahub), [v1.6.0](https://github.com/datahub-project/datahub/releases/tag/v1.6.0) | commit `059a36c`, 21 May 2026 | Metadata graph/ownership/lineage concepts | Large platform/connectors/services and broad data model; reference only |

## 15.7 Source-quality conclusion

**FACT.** Vendor and standards documentation establishes capabilities and documented limitations, not UAM-specific safety, completeness, resource use, privacy, realm isolation, or operational competence. Repository releases and tests establish maintained implementation evidence at a reviewed point, not dependency fitness. Every load-bearing composition remains a CLI/lab gate.

---

# 16. Confidence table for every major conclusion

| ID | Major conclusion | Confidence | Basis | Evidence that would change it |
|---|---|---|---|---|
| C22-01 | The legacy system contains direct SQL, executable deferred SQL, scheduling, settings/checkpoints, broad administration, and implicit data relationships | **High** | Direct supplied sanitized evidence I02–I03 | A corrected source-evidence package showing the summarized facts were wrong |
| C22-02 | The supplied evidence does not enumerate every runtime consumer/report/integration/manual workflow | **High** | I02 explicitly states the static evidence limits | Independently verified exhaustive runtime/consumer registry with closed population and all channels |
| C22-03 | A one-shot fixed CLI is the safest sufficient first discovery architecture | **High** | Accepted no-script/no-SQL/no-profile-crawl/repository boundaries plus smaller authority than alternatives | Prototype showing it cannot meet a required approved use while a narrower/equally safe alternative can |
| C22-04 | A persistent generic inventory agent is not justified initially | **High** | No continuing-monitoring requirement; large added authority/lifecycle | Repeated approved cycles and measured operations evidence proving persistent need/lower total risk |
| C22-05 | Discovery must never execute deferred SQL/scripts/jobs/PSU actions | **High** | Direct conflict with observation purpose and accepted target invariants; high mutation/exfiltration risk | Only a formal baseline change with compelling primary evidence; no ordinary expectation |
| C22-06 | Static PowerShell/T-SQL parsing can materially classify capability without execution | **High for documented capability; Medium for UAM completeness** | Microsoft parser/Script DOM capabilities and OSS rule/parser evidence | Hostile corpus or real artifacts show material paths cannot be represented safely |
| C22-07 | Static parsing can prove all program behavior | **Low / not established** | Dynamic construction/reflection/external state/general program behavior | A closed restricted language/profile with exhaustive formal semantics and evidence |
| C22-08 | SQL dependency catalog/DMFs are useful but incomplete | **High** | Microsoft dependency docs and supplied dynamic/implicit evidence gaps | New SQL mechanism proving complete static/runtime dependency across required constructs |
| C22-09 | SQL metadata visibility can create false empty/partial inventories | **High** | Microsoft metadata-visibility documentation | A query principal/profile with independent canaries proving complete visibility for exact scope |
| C22-10 | Existing Query Store/XE/Agent history improves consumer evidence | **High** | Official runtime-history capabilities | Selected environment shows capture disabled, unsafe, too incomplete, or too costly; conclusion narrows per source |
| C22-11 | Existing telemetry can prove universal absence | **Low / not established** | Capture/retention/reset/filter/ad-hoc/unreachable limitations | Closed-world instrumentation with complete population and independently proved no-loss coverage |
| C22-12 | Enabling Query Store/XE belongs outside read-only discovery | **High** | Official configuration operations and added storage/load/privacy | A non-mutating equivalent observation mechanism |
| C22-13 | Repository-first PSU discovery plus GET-only supplement is appropriate | **Medium-High** | Official repository/API/script/schedule/trigger/job/token concepts; reduces action surface | Exact deployed PSU version lacks complete repo/API visibility or GET endpoints have unsafe behavior |
| C22-14 | Endpoint machine/user-session boundaries must match accepted target security model | **High** | I01/I04/I06 accepted invariants | Formal predecessor change proposal with new platform proof |
| C22-15 | Raw credentials/activity/internal locators need not enter the shareable package | **High** | Required output can be structural/aliased; privacy baseline | A specific approved task cannot be completed with minimum sanitized fields; requires separate field ADR |
| C22-16 | Purpose-separated local HMAC aliases reduce shareable linkability | **Medium-High** | Cryptographic reasoning and narrow threat model | Dictionary/correlation prototype or key-management constraints show unacceptable residual risk |
| C22-17 | SHA-256/content-addressed immutable packages provide useful integrity/provenance | **High** | Accepted Batch 01 profile and standard engineering practice | Cryptographic profile change/advisory or stronger multi-party evidence requirement |
| C22-18 | Integrity hashes prove source truth/completeness | **Low / rejected as claim** | Authorized malicious/buggy collector can produce coherent false evidence | Independent exhaustive source witnesses/formal attestation; still would have limitations |
| C22-19 | A closed evidence graph can enforce mandatory migration/removal links | **Medium-High** | Finite required entities/relations and executable graph tests | Prototype finds irreducible required relation that cannot be represented without unsafe free-form content |
| C22-20 | Spreadsheets should be projections, not canonical evidence | **High** | Immutability/provenance/path validation needs exceed manual spreadsheet guarantees | A governed spreadsheet system proves equivalent strict schemas, provenance, immutability, graph gates, and access |
| C22-21 | Four disposition states are sufficient for the first lane | **High** | They cover approved preserve, deliberate change, retire, and uncertainty safely | A real item needs a distinct authority/state with materially different tests/rollback semantics |
| C22-22 | `NOT_OBSERVED_IN_SCOPE` is safer and more truthful than “unused/absent” | **High** | Population/telemetry/time/manual/unreachable limits | Closed-world exhaustive observation evidence for a specific class |
| C22-23 | A quiet window alone cannot authorize retirement | **High** | Seasonal/manual/emergency/telemetry-gap scenarios and supplied missing runtime evidence | Complete business-cycle/population/owner evidence plus reversible validation; still not window alone |
| C22-24 | Unreachable devices must remain explicit unknowns until humans decide handling | **High** | No source behavior can be observed reliably; prompt reserves authority | Approved alternative evidence proving the exact item on the exact device or accountable risk decision |
| C22-25 | Owner interviews are necessary but insufficient | **High** | Manual workflows/criticality are human knowledge; assertions are fallible | Complete authenticated operational registry removing owner knowledge need for a specific claim |
| C22-26 | Credentials can be inventoried without reading values | **High** | Metadata references/storage/principal/use classes meet discovery need | A platform exposes no safe metadata and an approved credential migration needs another separately governed proof |
| C22-27 | Unknown/executable/raw buffers must be quarantined and not copied/executed | **High** | Supplied executable deferred SQL and privacy/security constraints | Separate approved treatment with typed transformation, incident, rollback, and zero-raw proof |
| C22-28 | Reversible disablement before destructive removal reduces hidden-consumer risk | **High** | Failure-containment logic and synthetic delayed-use falsifier | Technology cannot support reversible state; then a human exception and stronger backup/rollback proof is required |
| C22-29 | Post-removal discovery is required for removal proof | **High** | Residue/consumer/reconfiguration can remain after action | A stronger independently verified configuration/state mechanism that intrinsically proves complete removal |
| C22-30 | Exact resource limits and observation durations are currently known | **Low / not established** | No estate distributions, business cycles, budgets, or SLOs supplied | R2/R3 measurements plus accountable system/business decisions |
| C22-31 | Current estate-wide discovery coverage is known | **Low / not established** | No authoritative population or executed read-only runs | Approved R2–R4 runs with population reconciliation and complete evidence |
| C22-32 | Every current consumer can be identified through research alone | **Low** | Ad-hoc/manual/unmanaged/external/unreachable paths may remain hidden | Closed-world instrumentation, population control, owner corroboration and dark-validation evidence |
| C22-33 | SQL Script DOM is likely the best first T-SQL dependency candidate | **Medium** | Microsoft-owned T-SQL AST, current package, MIT/security/test evidence | Exact mapping/admission fails, hostile corpus fails, or a simpler in-box parser meets all needs |
| C22-34 | PSScriptAnalyzer should not be the primary production parser/oracle | **High** | Module/custom-rule/runtime surface is broader than direct parser and rule findings are not behavior truth | Isolated admission shows lower total risk and no dynamic execution while direct parser is insufficient |
| C22-35 | osquery/DataHub/OpenLineage/Liquibase/FRK should not be deployed for first lane | **High** | Material threat/authority/operations/license mismatch and no need | Existing approved enterprise platform plus narrow adapter or new measured requirement with full ADR |
| C22-36 | Syft can be a useful secondary SBOM tool but not sole oracle | **High** | Current security policy explicitly excludes malicious omission/confusion from expected threat boundary | Another exact tool/profile plus positive controls proves stronger malicious-input completeness; still independent reconciliation needed |
| C22-37 | Accessibility affects migration-decision correctness | **High** | Reviewers must perceive uncertainty, stop, rollback, and evidence; inaccessible bypass creates governance risk | A non-visual/non-UI automated authority path replaces human decision—which prompt forbids for key decisions |
| C22-38 | The design can support 6,000 managed endpoints operationally | **Medium-Low** | One-shot waves are scalable in principle but no fleet/run/resource/support evidence exists | Representative R3/R4 throughput, retry, failure, support, cost and cleanup evidence |
| C22-39 | A discovery pass authorizes migration, removal, pilot, or production | **Low / explicitly false** | Prompt, baseline, and this result preserve independent human/target gates | Only separate accepted evidence and designated authority can approve those actions |

## 16.1 Residual risk

The following remains unsafe, uncertain, costly, human-dependent, or impossible to prove through this research alone:

- Static and existing-runtime evidence can miss obfuscated dynamic code, emergency actions, direct queries, old reports, manual spreadsheets, copied exports, and recipient-controlled copies.
- Permanently unreachable devices and systems outside the authoritative population cannot be proven clean or unused.
- Metadata visibility, telemetry filters, resets, retention, clock quality, and product-version differences can create false quietness.
- An authorized malicious or defective collector release, scope approver, source administrator, or evidence reviewer can produce coherent but misleading evidence.
- Local aliases and sanitized aggregates can still be correlated by a privileged party with source access or expose rare-population facts.
- Parser, SQL Server, Windows, PSU, EDR, filesystem, database, and dependency behavior must be requalified for exact versions and configurations.
- Reading can still cause operational load, access-time/security-tool effects, or reveal sensitive text transiently in process memory to administrators, EDR, hypervisors, dumps, or backups outside UAM control.
- Owner knowledge can be incomplete, stale, conflicted, or strategically biased; criticality and approved purpose are not technically derivable.
- Reversible disablement and rollback can fail only in a real business cycle; accelerated synthetic tests cannot prove every production dependency.
- Discovery, repeated observation, interviews, evidence review, accessibility testing, incident response, and post-removal validation require sustained skills, staffing, budget, and authority not established here.
- No research result can guarantee that an unregistered human copy or unknown third-party recipient has been found or deleted.

Containment is narrow authority, synthetic-first proof, fixed read-only adapters, parser/process isolation, zero-raw publication, explicit gaps, immutable evidence, owner-bound disposition, reversible validation, rollback, truthful limitations, and stop-on-first-primary-failure.

## 16.2 Explicit next stop/go gate

> **NEXT GATE — GO only for repository scaffolding, strict contracts, T1 fictional fixtures, static parsers, query-pack verification, evidence/graph/coverage models, canary scanning, interview templates, accessible review prototypes, and disconnected lab preparation.**
>
> **STOP before any real system access until HD22-01, HD22-08, HD22-09, HD22-17, and HD22-18 are recorded for one exact target and the aggregate synthetic hostile campaign passes.**
>
> After that, the smallest next empirical step is one approved, read-only, sanitized R2 inventory against one non-production target of each needed class. Passing R2 authorizes only a bounded representative-wave proposal—not migration, removal, pilot, or production.

The primary migration/decommission gate remains:

> **No legacy behavior, data, credential, script, buffer, report, integration, or consumer is migrated or removed without evidence, owner, disposition, validation, and rollback.**
