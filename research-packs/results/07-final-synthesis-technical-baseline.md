# UAM modernization — final synthesis and technical baseline

**Decision date:** 30 July 2026  
**Status:** Baseline for proof and implementation planning; production authority remains gated  
**Scope:** Windows endpoint, release and update plane, ingestion, relational data platform, control plane, portal, integrations, migration, operations, privacy, and security  
**Evidence base:** `01-architecture-result.md` through `06-requirements-migration-result.md`, plus `UAM-CODE-REFERENCE.md`  
**Overall confidence:** High for the endpoint process split, privacy boundary, transactional outbox, idempotent delivery, and separation of trust planes. Moderate for the central database engine, exact resource limits, capacity, retention, and operational targets because production measurements and policy decisions are missing.

The legacy code is evidence of behavior, not an approved specification. Static inspection does not reveal every runtime setting, external consumer, dynamic SQL path, or production dependency. This baseline therefore preserves approved outcomes and explicitly retires unsafe implementation mechanisms.

---

# 1. Executive recommendation in easy language

## 1.1 Recommendation

Build the replacement as a small set of clearly separated components rather than a single powerful agent.

On each Windows device, a low-privilege machine service should own identity, policy verification, the local SQLite queue, uploads, and health. Browser and Recent-item collection should run in the signed-in user’s session, because Windows services run in Session 0 and should not be given broad powers merely to enter user profiles. Each risky collector should run in a short-lived restricted child process. Microsoft’s service and task-scheduler guidance supports this split, while `WTSQueryUserToken` would require a highly trusted LocalSystem service with `SeTcbPrivilege`, which is not the defensible default. ([Microsoft service isolation](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista), [Task Scheduler logon types](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype), [WTSQueryUserToken](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken))

Filter and minimize data before it enters the endpoint outbox. A release-signed **product privacy ceiling** defines the maximum fields and capabilities the software can ever collect. Customer or organizational policy may narrow that ceiling but cannot broaden it. No rejected URL, path, title, process detail, or identity value may enter SQLite, logs, crash material, metrics, or network payloads.

Use C# 14 and .NET 10 for the endpoint, APIs, workers, and BFF. Use a pinned SQLite engine locally. Use versioned JSON with gzip over mTLS, stable batch and event identities, full-jitter retry, and a durable receipt. Start centrally with a **relational durable inbox and workers**, not an external broker. Six thousand devices alone does not justify RabbitMQ, Kafka, or another queueing platform; event and byte rates, outage duration, replay, fan-out, and failure-domain requirements must justify that extra system. PostgreSQL explicitly supports queue-like consumers with `FOR UPDATE SKIP LOCKED`. ([PostgreSQL `SKIP LOCKED`](https://www.postgresql.org/docs/current/sql-select.html))

Use PostgreSQL 18.4 as the **target-state reference implementation**, while retaining SQL Server as a migration boundary and benchmark fallback. Before production commitment, run the same production-shaped workload, failover, restore, retention, and report tests on PostgreSQL 18.4 and SQL Server 2025. If PostgreSQL fails the operational-readiness or total-cost gate, phase one may use SQL Server 2025 without changing endpoint contracts or the architectural boundaries. This resolves the research disagreement by separating target architecture from transition risk rather than voting between the packs.

Use MSI and the existing enterprise deployment platform for installation, repair, and the stable privileged boundary. An autonomous updater is optional: where required, it must be a tiny LocalSystem component that can activate only repository-authorized immutable versions, prove health, and roll back. Authenticode alone is insufficient; combine it with TUF-style role separation, expiry, hashes, lengths, and rollback/freeze protection. ([TUF specification](https://theupdateframework.github.io/specification/latest/), [WinVerifyTrust](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust))

The server should begin as a modular monolith with separate deployables for ingestion, control/BFF, workers, and database migration. The portal uses enterprise OIDC, capability-based authorization, purpose-bound access, and transactional audit. Customer integrations run server-side through an integration outbox and never receive database credentials.

This design is not bulletproof. A local administrator or SYSTEM-level malware can still observe plaintext in use, suppress or fabricate telemetry, and invoke a genuine device key through the legitimate service. A sufficiently broad release-signing compromise can still harm the fleet. Authorized insiders and incorrect policy remain material privacy risks. UAM data must be treated as fallible operational evidence, not sole forensic proof or an employee-productivity score.

## 1.2 Where the six packs agree

| Agreement | Baseline consequence |
| --- | --- |
| A service-only collector is not defensible | Use one low-privilege machine service plus one standard-user host per interactive session. |
| Legacy database trust must disappear | Endpoints receive no central database credentials, submit no SQL, and cannot reach the database port. |
| Deferred SQL is the wrong offline format | Store typed, versioned, minimized events and checkpoints in a transactional SQLite outbox. |
| Privacy is an endpoint invariant | Allowlisting, reduction, redaction, and schema enforcement occur before durable local storage. |
| Signing does not make arbitrary code safe | No database- or portal-supplied scripts, command lines, SQL, or assemblies in the normal task channel. |
| Collection and checkpoints must be atomic | Insert eligible events and advance the source cursor in the same SQLite transaction. |
| Delivery is at least once; business effect is idempotent | Stable batch IDs, deterministic source dedupe keys, durable receipts, and unique central constraints are mandatory. |
| Six thousand endpoints is not a throughput requirement | Capacity is expressed in events/s, bytes/s, batch rate, backlog age, recovery time, WAL, storage, and query load. |
| A broker is an escalation, not a default | Begin with a relational inbox; add a broker only after a quantitative break-even gate. |
| Release, control, and data authority must be separate | The portal cannot sign executable releases; tenant policy cannot exceed the product privacy ceiling. |
| Migration must preserve approved outcomes, not insecure mechanisms | Use server-side compatibility projection and governed reconciliation; never endpoint dual-write. |
| Legal and organizational policy cannot be inferred from code | Purpose, lawful basis, retention, access, ownership, reporting semantics, and budget require named decisions. |

## 1.3 Missing evidence that prevents unconditional production approval

The packs contain no representative production event-rate or payload-size distribution; no proven maximum offline duration; no complete inventory of portal, SQL, HR/AD, or reporting consumers; no approved field-level purpose and retention register; no demonstrated PostgreSQL or SQL Server operating capability for the new workload; no RDS/Citrix/FSLogix production matrix; no proxy and mTLS compatibility evidence; no proven update-key recovery procedure; and no end-to-end deletion-after-restore evidence.

These gaps are not reasons to stop. Each is converted below into a bounded experiment, owner decision, or migration inventory task.

## 1.4 Approval position

Approve the baseline for a falsification-oriented proof program and the first Browser History vertical slice. Do not approve broad live deployment until the gates in sections 8 and 9 pass, the stakeholder decisions in section 11 are recorded, and the production engine, retention, RPO/RTO, and operational ownership ADRs are accepted.

---

# 2. Requirements and constraints that every design must satisfy

## 2.1 Context constraints

- At least 6,000 managed Windows endpoints, including expected outages and reconnect waves.
- Browser History, Windows Recent Items, and process observations are the current source families; extension inventory may follow.
- Collection is policy-controlled workplace telemetry with material privacy risk.
- Endpoint operation must continue offline within an approved storage and age envelope.
- Customer-specific HR, directory, ITSM, and export integrations must remain server-side and independently failure-contained.
- The design must support staged deployment, rollback, audit, incident response, deletion, restore, and eventual legacy decommissioning.
- Production estimates are not requirements. Numeric values below marked *provisional* are test hypotheses until measurements and owners ratify them.

## 2.2 Baseline requirements

| ID | Requirement | Acceptance meaning | Source/evidence |
| --- | --- | --- | --- |
| BL-REQ-001 | Every source and output field has a named purpose, owner, recipient, retention class, and deletion method. | A policy cannot enable an unregistered field or source. | `06` PRI-01; [GDPR](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng) |
| BL-REQ-002 | A release-signed product privacy ceiling defines the maximum data and capabilities; tenant policy may only narrow it. | A policy-expansion test fails closed and creates an audited alert. | `01` §3.3; `03` executive invariants |
| BL-REQ-003 | Minimization and redaction occur before endpoint persistence. | Forbidden canaries are absent from SQLite, WAL, logs, support bundles, network capture, queues, traces, and rejection records. | `03` §5; `06` PRI-02 |
| BL-REQ-004 | Endpoints never receive central DB credentials or submit SQL/database-shaped commands. | Secret scan and network tests find no credential or database connectivity. | Legacy evidence; `06` SEC-01 |
| BL-REQ-005 | User-owned data is collected in the user’s interactive session under an ordinary token. | The coordinator never opens browser/profile files and uses no `WTSQueryUserToken`. | `04` G1; [Microsoft service isolation](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista) |
| BL-REQ-006 | Risky collectors execute out of process with restricted token, Job Object limits, no breakaway, and no network. | Timeout kills the full process tree; child cannot reach the device key, outbox, update state, or other users’ sources. | `01` §3.2; [Job Objects](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects) |
| BL-REQ-007 | Local IPC authenticates the caller from OS token, PID, creation time, session, SID, and logon SID; payload identity is not authoritative. | Cross-session and spoofing test corpus has zero accepted messages. | `04` §1.3; [Named-pipe security](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights) |
| BL-REQ-008 | Policy is typed, versioned, signed, expiring, explainable, and rollback-capable. | Unsupported, invalid, expired, or revoked policy produces zero new collection. | `06` FUN-06; `01` §3.3 |
| BL-REQ-009 | Events and source progress commit atomically to a local SQLite outbox. | No fault point yields a cursor ahead of durable events. | `04` E3; [SQLite WAL](https://sqlite.org/wal.html) |
| BL-REQ-010 | SQLite uses a pinned approved engine, one writer, WAL, `synchronous=FULL`, foreign keys, bounded transactions, and integrity checks. | Runtime version attestation and 10,000 fault cycles pass; no OS `winsqlite3.dll` ambiguity. | `02` §3.3; `04` §1.10; [SQLite changes](https://www.sqlite.org/changes.html) |
| BL-REQ-011 | Outbox pressure is explicit and bounded by bytes, age, and host free space. | Collection pauses before OS danger; no unacknowledged event is silently deleted. | `05` §4.2; `06` REL-05 |
| BL-REQ-012 | Device identity is unique, revocable, server-mapped to realm, and preferably TPM-backed. | Cloned, revoked, wrong-realm, expired, and unknown identities are rejected. | `03` §4.1; [CNG key providers](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers) |
| BL-REQ-013 | The authoritative realm/device identity comes from authenticated registration, never request-body fields or untrusted proxy headers. | Property-based cross-realm tests cover every API, queue, store, cache, export, and deletion path. | `03` A-01/A-04 |
| BL-REQ-014 | Uploads are bounded, authenticated, confidential, replay-safe, and idempotent. | Same ID/same hash returns the original receipt; same ID/different hash is a security conflict. | `05` §4.1; [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) |
| BL-REQ-015 | A server success response means durable central custody in the declared failure domain. | Process/host/failover tests show the acknowledged batch remains recoverable. | `01` invariant 3; `05` state definitions |
| BL-REQ-016 | Deep-invalid, poison, duplicate, and unsupported-schema inputs cannot block unrelated data. | Invalid batches reach terminal quarantine; workers make progress without retry loops. | `05` resilience matrix; `06` REL-07 |
| BL-REQ-017 | Endpoint and central dedupe remain effective for the maximum outage plus replay and restore horizon. | Replays after the full declared horizon still produce one business effect. | `01` criterion 20; `05` §5.3 |
| BL-REQ-018 | Installation and updates verify repository authorization, Authenticode, hash, length, version, expiry, and rollback rules. | Wrong signer, stale metadata, tampering, freeze, downgrade, and partial activation never execute. | `03` §4.2; [TUF](https://theupdateframework.github.io/specification/latest/) |
| BL-REQ-019 | A failed update leaves either the old or new complete version runnable, and DB migrations remain rollback-compatible. | Kill-at-every-step and unhealthy-version tests recover automatically. | `04` E4; [MSI rollback](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-installation) |
| BL-REQ-020 | Administrative authorization is capability-based, deny-by-default, tenant-scoped, purpose-aware, and tested at the API—not only hidden in UI. | Every route/mutation/export has positive and negative role tests. | `06` SEC-05/POR-01 |
| BL-REQ-021 | Administrative mutation and its audit evidence commit together. | If audit storage is unavailable, the mutation fails. | `01` §3.9; `06` SEC-06 |
| BL-REQ-022 | Audit evidence is externally verifiable and ordinary product administrators cannot erase it. | Privileged DB tampering is detected against an independent sink/digest. | `03` P-05; [SQL Ledger concepts](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17) |
| BL-REQ-023 | Retention and deletion cover live stores, inbox/queue, replicas, caches, exports, integrations, endpoint outboxes, backups, and restored environments. | A seeded subject remains absent after a full restore and tombstone replay. | `01` §6.3; `03` A-09; [EDPB erasure annex](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf) |
| BL-REQ-024 | Integrations consume governed contracts through a tenant-scoped integration outbox; they never query central tables directly. | Seven-day destination outage does not block core processing and replays idempotently. | `01` §3.9; `06` DAT-08 |
| BL-REQ-025 | Capacity decisions use measured distributions and recovery equations, not endpoint count alone. | 28-day measurement and production-shaped load tests establish the knee and ≥1.5× provisional headroom. | `05` final commitment gates |
| BL-REQ-026 | Observability uses bounded labels and excludes activity payloads, URLs, paths, user names, tokens, certificates, and HTTP bodies. | Automated canary scanning covers endpoint/server logs, traces, metrics, DLQ, proxy, and support bundle. | `03` §6; `05` §6.6 |
| BL-REQ-027 | Legacy coexistence has one authoritative writer per contract, reconciliation, rollback, and a dated removal plan. | Endpoint dual-write is impossible; compatibility writes occur only server-side. | `02` §5.2; `06` DEP-07 |
| BL-REQ-028 | UAM telemetry is labeled non-forensic and is not a general productivity or disciplinary score. | Product wording, portal design, access workflows, and training reflect the limitation. | `03` residual risk and misuse cases |
| BL-REQ-029 | Every alert and high-risk capability has a named operational, security, privacy, data, and support owner where applicable. | Game days route incidents without relying on an unavailable developer. | `06` SUP-01/OPS-05 |
| BL-REQ-030 | Supported OS, browser, profile, architecture, and runtime combinations are explicit and rolling. | Unsupported environments fail closed or report a typed health state; no silent “success with no data.” | `04` compatibility matrix |

## 2.3 Prohibited defaults

The baseline rejects: one LocalSystem service crawling every profile; inactive-profile mining; arbitrary PowerShell or remote shell; `AssemblyLoadContext` as a security boundary; endpoint SQL or DB credentials; raw-copying a live browser database; timestamp-only browser cursors; silent oldest-event deletion; broker-native dedup as the only idempotency control; signing without anti-rollback metadata; portal or integration direct DB access; mutable best-effort audit; unbounded diagnostics; production retention inferred from a database schema; and partitioning or an external broker added before evidence.

---

# 3. Recommended architecture

## 3.1 Reconciled terminology

| Baseline term | Meaning | Terms reconciled from the packs |
| --- | --- | --- |
| **Coordinator Service** | Low-privilege machine Windows Service owning identity, policy cache, SQLite outbox, batching, upload, and health. | Agent Service, Core Service, Machine Service, Coordinator |
| **User Host** | One standard-user process per eligible interactive session; source discovery and final privacy gate. | SessionHost, User Agent, Per-user Collector |
| **Task Host** | Short-lived restricted process executing one collector invocation. | Collector TaskHost, taskhost, restricted collector process |
| **Collector** | Source-specific adapter logic, such as Edge History. It is not an arbitrary script. | Task, collector package, adapter |
| **Product privacy ceiling** | Release-signed maximum source/field/capability set. | Hard privacy policy, product ceiling |
| **Tenant policy** | Signed, versioned configuration that may only narrow the ceiling. | Customer policy, organizational policy |
| **Endpoint outbox** | Local SQLite store containing minimized events, cursors, batch state, policy, task state, and receipts. | SQLite WAL outbox |
| **Central inbox** | Relational durable custody/receipt ledger for immutable batches. | SQL inbox, durable queue, receipt ledger |
| **Durably received** | Server committed the batch to the declared failure domain and returned a receipt. | Accepted |
| **Materialized** | Valid events committed to facts/aggregates, or the batch/event reached explicit terminal quarantine. | Processed |
| **Visible** | Materialized data is retrievable through authorized API/query paths. | Portal-visible |
| **Realm** | Server-derived customer/tenant isolation boundary. | Tenant, organizational realm |
| **Task** | Declarative invocation of a preapproved fixed capability. | Never arbitrary source code, command line, SQL, DLL entry point, or file glob |

## 3.2 Text architecture diagram

```text
                                  RELEASE PLANE
       protected source + pinned dependencies + isolated CI/build
                         | SBOM + signed provenance
                         v
       offline threshold root / HSM-backed delegated signing roles
                         | TUF-style metadata + Authenticode
                         v
       enterprise deployment / repository / out-of-band MSI repair

+--------------------------------------------------------------------------------+
|                                WINDOWS DEVICE                                  |
|                                                                                |
|  MSI + stable launcher + optional minimal updater (LocalSystem, on demand)     |
|                              |                                                 |
|                              v                                                 |
|  Coordinator Service (LocalService + service SID)                              |
|    - device certificate and enrollment epoch                                   |
|    - signed privacy ceiling and tenant-policy cache                            |
|    - one-writer SQLite WAL outbox                                               |
|    - batch, receipt, retry, disk-pressure, health, update coordination          |
|    - fixed outbound mTLS endpoints only                                         |
|            ^                                                                   |
|            | authenticated local-only, per-logon-SID IPC                        |
|            | caller token/PID/session validation                               |
|            |                                                                   |
|  User Host A / session 2                  User Host B / session 5               |
|    - ordinary user token                    - ordinary user token               |
|    - source discovery                       - source discovery                  |
|    - final privacy gate                      - final privacy gate               |
|          | inherited private handle               |                            |
|          v                                        v                            |
|    Task Host: Edge History                 Task Host: Edge History              |
|    restricted token + Job Object           restricted token + Job Object       |
|    no network, no outbox, no device key     no cross-session access             |
|                                                                                |
|  SQLite transaction: approved event page + compound source cursor + sequence   |
+-----------------------------------|--------------------------------------------+
                                    |
                     bounded canonical JSON + gzip + mTLS
                     stable batch ID/hash; full-jitter retry
                                    |
                                    v
+--------------------------------------------------------------------------------+
|                                  DATA PLANE                                    |
|  controlled edge/gateway: mTLS, header stripping, limits, rate/fairness        |
|             |                                                                  |
|             v                                                                  |
|  Ingestion API -> one relational transaction                                  |
|    receipt + immutable compressed batch + authenticated device/realm metadata  |
|             | durable receipt                                                  |
|             v                                                                  |
|  Inbox workers: deep validation, event dedupe, normalization, quarantine       |
|             |                                                                  |
|             +--> typed event facts and server-derived aggregates               |
|             +--> integration outbox and tenant-isolated connectors             |
|             +--> deletion/tombstone workflow                                   |
|             +--> privacy-safe OpenTelemetry                                    |
+--------------------------------------------------------------------------------+

+--------------------------------------------------------------------------------+
|                                CONTROL PLANE                                   |
|  Enterprise IdP -> Portal BFF -> Control API                                   |
|    - capability RBAC/ABAC, JIT and approvals                                   |
|    - policy/release assignment, device health, governed queries                |
|    - mutation and audit in one transaction                                     |
|    - external immutable audit verification                                     |
|                                                                                |
|  No direct database access from browser, endpoint, customer connector, or UI   |
|  No ability for the portal to sign executable releases                         |
+--------------------------------------------------------------------------------+
```

## 3.3 Endpoint boundaries

### Coordinator Service

Run as `LocalService` with a service SID and explicit ACLs. It owns `%ProgramData%\<Vendor>\UAM\`, the machine certificate key ACL, the outbox, upload, and health. It does not traverse user profiles, run tenant-authored code, or write Program Files. LocalService supplies limited local authority; mTLS supplies the explicit network identity. ([LocalService account](https://learn.microsoft.com/en-us/windows/win32/services/localservice-account))

### User Host

Install one machine-wide scheduled task that starts at interactive logon with LUA run level and no stored password. One host runs per eligible session. The host discovers only its user’s supported profiles, launches collectors, applies the final privacy transformation, and sends typed records through authenticated IPC. Same-SID concurrent sessions require a source lease keyed by SID, canonical source, and generation.

### Task Host

One collector invocation per process by default. Apply a restricted token, process mitigations, Job Object process/memory/CPU/wall-clock limits, kill-on-job-close, no breakaway, and no network. AppContainer is an optional stronger sandbox only after access and supportability are proven; it is not required for the first slice.

### Local storage

Use `Microsoft.Data.Sqlite.Core` with a pinned official SQLite native engine, initially 3.53.4 or newer. At startup, assert the native library version. Use WAL, `synchronous=FULL`, foreign keys, trusted schema off, a busy timeout, one long-lived writer, prepared parameterized statements, short transactions, and controlled checkpointing. SQLite WAL is persistent database state; never delete or separate it from the main database. ([SQLite WAL](https://sqlite.org/wal.html), [SQLite PRAGMA](https://sqlite.org/pragma.html))

Store sensitive event payloads as authenticated ciphertext with a per-installation/epoch data key wrapped by a service-controlled CNG key, TPM-backed where available. ACLs, BitLocker, and encryption reduce lost-disk and ordinary-user exposure but do not defeat a malicious local administrator controlling the live host.

### Browser acquisition

For live browser SQLite sources: first attempt a short read-only transaction; if locking prevents it, use SQLite’s online backup API into a protected user scratch directory; if both fail, defer without advancing the cursor. Do not raw-copy main/WAL/SHM files, open an active database as immutable, delete browser WAL, or use VSS for ordinary collection. ([SQLite online backup](https://sqlite.org/backup.html))

Use source-native visit IDs plus source generation as the primary cursor, retaining source time and a bounded overlap. Timestamp-only high-water marks can miss late-synchronized or same-time visits. Chromium time is microseconds from the Windows epoch; Firefox Places uses microseconds from the Unix epoch. ([Chromium time representation](https://chromium.googlesource.com/chromium/src/%2B/HEAD/base/time/time.h))

## 3.4 Delivery and central acceptance

The endpoint creates an immutable batch locally before sending. The initial hypotheses are no more than 1 MiB compressed, 4 MiB decompressed, or 1,000 events, but these are test values, not production requirements.

The gateway authenticates the device, strips external identity headers, enforces compressed/decompressed limits, and derives realm/device from registration. The ingestion API performs cheap envelope, hash, schema-family, and size checks; then commits one immutable batch row and receipt. A duplicate `(realm, device, batch_id)` with the same hash returns the original receipt. A different hash is a conflict and security signal.

Workers claim inbox rows with a lease, perform deep event validation, derive authoritative identities, enforce dedupe, materialize facts, and either complete or quarantine. A batch can be durably received even if it later contains terminal-invalid events; the receipt means custody, not semantic approval or portal visibility.

Keep accepted payloads or replay material on the endpoint for a configurable grace period longer than the central RPO plus detection and restore interval. The exact period is an RPO/RTO decision. This prevents a central point-in-time restore from losing data that endpoints already deleted.

## 3.5 Data model

Control-plane entities:

```text
realm, device, installation, device_certificate, subject_projection,
policy, policy_revision, assignment, capability_package, task_assignment,
release, release_ring, rollout, integration_definition, audit_event,
deletion_request, legal_hold
```

Data-plane entities:

```text
ingest_batch, ingest_batch_error, event_dedupe,
browser_visit_event, recent_item_event, process_observation_event,
agent_health_event, collector_diagnostic_event,
integration_outbox, deletion_tombstone
```

Do not port `DeviceLoggingUsers` or the legacy event tables one-for-one. Device, installation, session, assignment, health, and checkpoint are distinct concepts. Generate minimized aggregates server-side from facts; do not upload SQL-shaped aggregate commands.

## 3.6 Control plane, portal, audit, and integrations

Use an ASP.NET Core BFF: browser tokens remain server-side; the portal receives secure HttpOnly cookies and CSRF protection. Capabilities such as `policy.write`, `telemetry.detail.read`, `export.execute`, `tasks.publish`, `releases.promote`, and `audit.read` remain separate. Sensitive detail, export, diagnostic, policy expansion, and break-glass access require purpose, ticket, target, time window, expiry, and approval where policy requires.

Audit records contain actor, realm, capability, target, before/after or precise diff, reason, approval, correlation ID, source context, result, and time. Do not copy raw telemetry into ordinary audit. Export audit evidence to a separate immutable or externally verifiable boundary.

Each customer integration has its own versioned contract, vault credential, retry/circuit state, idempotency key, delivery health, replay authorization, deletion propagation, and dead-letter state. It cannot block core ingestion.

## 3.7 Release and deployment

MSI owns service/task registration, ACLs, Event Log/ETW resources, installation inventory, repair, and uninstall. The endpoint-management platform is the preferred core-update owner. A self-updater is enabled only when a stated patch-latency or disconnected-estate requirement cannot be met otherwise.

Use immutable version directories and an A/B pointer or manifest. The updater verifies TUF-style metadata and Authenticode, stages to a non-executable path, verifies every file, activates one complete version, runs a bounded health proof, suppresses bad versions, and retains a known-good rollback. Database migrations use expand/contract compatibility across N/N−1.

---

# 4. Recommended language and stack by component

**Point-in-time versions below are those cited by the research packs on 30 July 2026.** Patch automation must always select the latest approved security patch within the chosen supported line.

| Component | Baseline | Deployment/use | Lifecycle and replacement review | Decision status |
| --- | --- | --- | --- | --- |
| Endpoint language/runtime | C# 14 on .NET 10.0.10 LTS | Self-contained, multi-file `win-x64`; no trimming or NativeAOT initially | Supported through **14 Nov 2028**; replacement review **15 May 2028** | Accepted |
| Coordinator Service | .NET 10 Windows Service hosting | LocalService + service SID | Same as .NET; monthly embedded-runtime rebuild/rollout | Accepted |
| User Host / Task Host | C# 14 / .NET 10 | Standard-user and restricted child processes | Same as .NET | Accepted |
| Optional compatibility host | PowerShell 7.6.4 LTS | Separate optional package only; never in-process or general remote shell | Supported through **14 Nov 2028**; review **15 May 2028** | Deferred; not in first slice |
| Endpoint SQLite provider | `Microsoft.Data.Sqlite.Core` 10.x | ADO.NET wrapper; one writer | Follows .NET line | Accepted |
| Native SQLite | Official pinned 3.53.4+ amalgamation | Product-built/attested native DLL; assert version at startup | Rolling upstream; security review monthly, replacement review **31 Oct 2026** and quarterly thereafter | Accepted |
| Endpoint contract | Versioned strict JSON, `System.Text.Json` source generation, gzip, HTTPS/mTLS | Current + at least two prior event schema versions during rollout | Contract compatibility review per release | Accepted |
| APIs/BFF/workers | ASP.NET Core 10 / C# 14 | Linux OCI containers, non-root; separate API/worker/migrator images | .NET lifecycle; review **15 May 2028** | Accepted |
| Central DB target reference | PostgreSQL 18.4 | Durable inbox, control data, facts, audit metadata, integration outbox | Major 18 supported through **14 Nov 2030**; replacement review **15 May 2030** | Proposed; production benchmark gate |
| Central DB fallback | SQL Server 2025 (17.x) | Phase-one fallback if transition/ops/TCO gate favors it | Confirm Microsoft lifecycle and CU policy before ADR acceptance; annual review | Proposed fallback |
| PostgreSQL driver | Npgsql 10 | Direct commands/COPY for ingest; EF Core 10 for suitable control CRUD | Align with .NET/PostgreSQL reviews | Proposed with PostgreSQL |
| ORM | EF Core 10, selectively | Control-plane aggregates and ordinary CRUD; not universal repository, not hot ingest | .NET lifecycle | Accepted with limits |
| Relational queue | Inbox/lease tables, `SKIP LOCKED` or engine-equivalent | Default central durable queue | Re-evaluate after measured break-even triggers | Accepted architecture; engine-specific implementation proposed |
| External broker | None initially | RabbitMQ/managed broker only after break-even gate | Review on trigger, not calendar | Deferred |
| Portal | React 19.2.7 | Static assets served by BFF; no production Node process; no RSC initially | Rolling; quarterly review, next **31 Oct 2026** | Accepted |
| Portal language | TypeScript 6.0.3 initially | Generated OpenAPI clients/types | Re-evaluate TypeScript 7.1 or by **31 Oct 2026** | Accepted, time-bounded |
| Portal build | Vite 8.1; Node 24.18.1 LTS build-only | Locked CI toolchain; no Node runtime in production | Node 24 LTS through Apr 2028; replacement review **31 Oct 2027**; frontend quarterly | Accepted |
| Portal E2E | Playwright 1.62 | Authorization and critical-workflow tests | Package/browser quarterly review | Accepted |
| Observability | OpenTelemetry SDKs + Collector | OTLP to approved backend; privacy-safe schemas | Quarterly review, next **31 Oct 2026** | Accepted |
| Installer authoring | MSI; WiX 7.0.0 only after legal/procurement approval, otherwise approved commercial tool | Installation, repair, ACLs, service/task resources | Legal ADR before selection; annual review **31 Jul 2027** | Proposed |
| Update transport | Enterprise management first; BITS for optional autonomous payload download | Resumable staged downloads | Review after patch-latency measurement | Conditional |
| Windows baseline | Windows 11 Enterprise/Education 25H2 x64 primary; 24H2 while serviced | Native x64 first | Quarterly OS support review; next **31 Oct 2026** | Accepted |
| Conditional Windows | Windows 11 26H1 ARM64/new hardware; Windows Server 2025/RDS; LTSC 2024; FSLogix/Citrix | Dedicated lanes and physical/enterprise tests | No production claim until platform gate | Conditional |
| Windows 10 | Exception-only under an approved serviced path | Dated compatibility policy | Review per customer exception | Deferred/exception |
| Browsers | Edge/Chrome current and previous stable; Firefox current Release and ESR when adapters are approved | Rolling schema-capability tests and fixture databases | Qualification on every stable/ESR release | Target policy; first slice narrower |
| Rust/Go | No production component by default | Introduce only across a process boundary after measured need and staffing gate | Trigger-based ADR | Deferred |

The same implementation language does not justify sharing endpoint and server persistence entities, retry policies, logging configuration, secrets, or migrations. Shared code is limited to contract DTOs, identifiers, canonical test vectors, and cryptographic format specifications.

---

# 5. Decision register

| ID | Decision | Chosen option | Alternatives considered | Rationale and evidence | Confidence | Owner | Review trigger | ADR status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| D-001 | Endpoint process model | Coordinator Service + per-session User Host + restricted Task Hosts | Service-only; service launches user tokens; monolith | Correct Windows identity/profile boundary and smallest privilege; `01`, `02`, `03`, `04` agree. | High | Endpoint Architecture | Cross-session or launch gate fails | Accepted / ADR required |
| D-002 | Primary implementation language | C# 14/.NET 10 for endpoint and server | Rust-first, Go-first, mixed | Strongest Windows API, LTS, migration, staffing, and server fit; weighted stack result 93.8/100. | High | Chief Architect | Hard resource budget fails after profiling | Accepted |
| D-003 | Coordinator identity | LocalService + service SID and explicit ACL/privilege list | Virtual service account; NetworkService; LocalSystem | Most specific Windows feasibility evidence; explicit mTLS avoids machine-account dependence. | High | Endpoint + Security | Required integration cannot operate under LocalService | Accepted |
| D-004 | User-process launch | Machine-installed Task Scheduler logon task at LUA | `WTSQueryUserToken`; startup folder; persistent service impersonation | Avoids LocalSystem/`SeTcbPrivilege`; uses existing interactive token. | High | Endpoint | RDS/customer task policy prevents reliable launch | Accepted; enterprise test gate |
| D-005 | Privacy authority | Release-signed product ceiling plus signed narrowing tenant policy | Tenant-admin field selection; collector self-filter only; server-only filter | Prevents compromised control plane or collector from expanding collection. | High | Product Security + Privacy | New source/field requested | Accepted |
| D-006 | Task model | Fixed declarative capabilities in restricted process | Arbitrary scripts; signed DLL plugins; in-process ALC | Signing authenticates publisher but does not constrain power; removes legacy RCE authority. | High | Product Security | Separately approved automation product | Accepted; arbitrary code rejected |
| D-007 | Local outbox | Pinned SQLite WAL, FULL, one writer, event+cursor transaction | CSV; ESE; file queue; OS SQLite | Simplicity, local durability, queryable state; direct response to legacy failure modes. | High | Endpoint/Data | Fault test or resource gate fails | Accepted |
| D-008 | Local payload protection | ACL + BitLocker baseline and AES-GCM event blobs with CNG-wrapped per-install key | ACL only; full DB encryption extension | Stronger ordinary-user/lost-disk protection while acknowledging local-admin residual risk. | Medium | Security + Endpoint | Supportability/performance test fails or threat model changes | Proposed |
| D-009 | Browser live-read strategy | Short read-only transaction; SQLite online backup fallback; otherwise defer | Raw copy main/WAL/SHM; VSS; immutable open | Online backup is designed for live DB snapshots; raw copy risks inconsistent state. | High | Browser Collector Owner | Browser vendor behavior changes | Accepted |
| D-010 | Browser cursor | Per-profile source generation + native visit ID + source time/overlap | Timestamp-only; one newest profile | Avoids duplicate/missed visits and handles profile replacement and late sync. | High | Browser/Data | Unsupported schema or source identity ambiguity | Accepted |
| D-011 | Event/batch identity | UUIDv7 event/batch IDs plus deterministic source dedupe and stream sequence | Random ID only; batch-only dedupe; timestamp key | Traceability plus authoritative replay/idempotency across rebuilt batches. | High | Data Architecture | Collision/storage benchmark or contract change | Accepted |
| D-012 | Device authentication | Per-device mTLS cert, TPM-backed where possible, short-lived managed enrollment | Fleet secret; bearer refresh token; shared cert | Unique revocation and sender binding; software-key fallback is explicit lower assurance. | High | PKI/Endpoint | Proxy, TPM, VDI, or CA compatibility gate fails | Proposed pending lab |
| D-013 | Wire format | Strict versioned JSON + gzip initially | Protobuf, CBOR | Inspectable, sufficient at expected request rates; binary benefit unmeasured. | High | API Architecture | Payload/network cost becomes material | Accepted |
| D-014 | Durable acceptance | Relational immutable batch inbox and receipt before ACK | Direct-to-final facts; broker-first | Clear custody boundary, replay, poison isolation, fewer components. | High | Platform/Data | Acceptance SLO or failure-domain gate fails | Accepted architecture |
| D-015 | Deep validation timing | Cheap envelope checks before receipt; deep event validation/materialization asynchronously | Full synchronous event processing; accept completely opaque data | Keeps ACK bounded while retaining explicit quarantine; receipt means custody. | Medium-High | Platform/Data | Poison storage or regulatory requirement demands pre-accept deep validation | Proposed |
| D-016 | External broker | Do not add initially | RabbitMQ, managed Service Bus, Kafka | Endpoint count is not throughput; synthetic high case still modest request rate. | High | SRE/Architecture | Break-even gate in C-006 is crossed | Deferred |
| D-017 | Target central DB | PostgreSQL 18.4 reference implementation | SQL Server 2025; other managed relational | Detailed inbox/capacity design, open platform, supported line; transition risk handled separately. | Medium | Data Platform + CTO | Comparative benchmark/restore/skills/TCO gate | Proposed |
| D-018 | Transition DB strategy | SQL Server compatibility projector and read-only historical estate | Endpoint dual-write; big-bang PostgreSQL migration; direct table compatibility forever | Contains migration risk without retaining endpoint DB trust. | High | Migration/Data | Consumers are fully migrated and reconciled | Accepted |
| D-019 | Partitioning | Partition-ready model; choose grain from measured retention/query benchmark | Monthly from day one; daily by convention; no partitioning ever | Avoids premature uniqueness/catalog complexity; enables retention when justified. | High | Data Platform | Projected/actual size and retention benchmark | Experiment required |
| D-020 | Server structure | Modular monolith with separate deployables for ingestion, control/BFF, workers, migrator | Microservices; single process | Simplest deployment that preserves failure/identity boundaries. | High | Platform Architecture | Independent scaling/ownership requires split | Accepted |
| D-021 | Portal architecture | React SPA + ASP.NET Core BFF, OIDC, server-side tokens | PSU replacement with direct SQL; pure SPA bearer tokens; Blazor default | Standard admin workflows, secure token boundary, broad frontend ecosystem. | High | Portal/IAM | Frontend staffing or BFF operational gate fails | Accepted |
| D-022 | Audit | Mutation and audit in one transaction plus independent immutable verification | Best-effort log insert; mutable DB table only | Prevents successful unaudited changes and detects privileged tampering. | High | Security/Audit/Data | Selected DB/audit technology ADR | Accepted principle |
| D-023 | Update ownership | MSI/enterprise management owns stable boundary; optional minimal self-updater for immutable payloads | Autonomous updater for everything; MSI-only regardless of patch SLO | Preserves out-of-band repair and minimizes SYSTEM attack surface. | High | Release/Endpoint Ops | Management coverage cannot meet patch SLA | Accepted conditional model |
| D-024 | Release trust | Authenticode + TUF-style roles/expiry/hash/rollback protection + provenance/SBOM | Authenticode only; repository TLS only | Addresses freeze, rollback, key compromise, and supply chain. | High | Release Security | Key ceremony/recovery test fails | Accepted |
| D-025 | PowerShell | No PowerShell in first baseline; later fixed compatibility host only under separate ADR | Port scripts directly; embedded runspace | Avoids recreating remote shell; retains bounded economic escape hatch. | High | Product/Endpoint | Named legacy outcome cannot be rewritten economically | Deferred |
| D-026 | Outbox limit | Configurable age+bytes+free-space policy; pilot hypothesis 250 MiB/7 days; pause rather than silent loss | 1 GiB fixed; 512 MiB soft/2 GiB hard; oldest-drop | Packs’ numbers are estimates; measurement and business outage policy must decide. | High on mechanism, Low on number | Product/SRE/Privacy | 28-day measurement + outage objective | Experiment required |
| D-027 | Resource budget | 150 MiB combined steady-state pilot no-go ceiling; lower service/host values are optimization targets | 55/45 MiB hard requirements; no ceiling | Reconciles differing estimates without pretending they are requirements. | Medium | Endpoint/SRE | Multi-session host measurement | Proposed test gate |
| D-028 | Process collection | Defer mechanism choice; poll first only if best-effort inventory is approved | ETW; WMI trace; hybrid | Completeness and privilege requirement is unknown; not part of Browser slice. | High | Product + Endpoint | Stakeholder defines capture semantics and E6 data | Deferred/experiment |
| D-029 | Retention | No production period chosen; engineering defaults only for bounded pilot | 30/90/400-day defaults; legacy periods | Legal/business/records decision, not an architecture inference. | High | Privacy/Records/Data Owner | Approved purpose and records schedule | Stakeholder decision |
| D-030 | DR and acknowledged replay | ACKed payload grace or synchronous replicated custody sufficient for declared RPO; tombstones before restored read access | Delete immediately after ACK; restore without re-deletion | Couples acknowledgement, RPO, and erasure correctness. | High | SRE/Data/Privacy | RPO/RTO decision and restore drill | Proposed principle |
| D-031 | Initial Browser slice | Edge Stable, current user, multiple profiles, domain/site-level minimized output | All browsers and sources at once; full URLs | Smallest end-to-end slice that tests the hard Windows/privacy/durability path. | High | Product/Endpoint | Edge prototype gate passes; add next adapter separately | Accepted scope |

---

# 6. Contradiction register

| ID | Packs in tension | Disagreement and cause | Resolution | Required experiment/decision | Owner/status |
| --- | --- | --- | --- | --- | --- |
| C-001 | `01` vs `02`/`05` | SQL Server 2025 transition-first versus PostgreSQL 18.4 target-first. The former is an estate/skills inference; the latter assumes a new target platform and supplies detailed PG design. | PostgreSQL 18.4 is the target reference; SQL Server remains the phase-one fallback and compatibility boundary. Contracts stay engine-neutral. | Identical data, schema, ingest, report, failover, restore, retention, skills, licensing/TCO comparison. | Data Platform; open ADR |
| C-002 | `01` vs `02`/`03`/`04` | Enterprise deployment should own core updates versus a dedicated privileged updater. | MSI/enterprise management owns the stable boundary. Optional updater may service immutable payloads only, can be disabled, and never competes with MSI. | Measure management coverage and emergency patch latency; updater interruption and repair drill. | Release/Endpoint; conditional |
| C-003 | `02` vs `04` | Copying main/WAL/SHM as a browser fallback versus explicit prohibition of raw live copies. | Direct read-only transaction, then SQLite online backup, then defer. No raw-copy fallback in v1. | E1 live-lock/snapshot test across supported browsers. | Browser Owner; resolved |
| C-004 | `01` vs `02`/`03` | ACL/BitLocker with optional column encryption versus encrypted local payloads as baseline. | Use encrypted payload blobs plus ACL/BitLocker for the first sensitive slice; do not claim protection from local admin/SYSTEM. | Measure CPU, recovery, key rotation, TPM/software fallback, and support burden. | Security/Endpoint; proposed |
| C-005 | `02` vs `03`/`05`/`06` | 1 GiB, 250 MiB/7-day, and 512 MiB/2 GiB outbox proposals. | Implement policy controls, not one hard-coded number. Pilot uses a conservative hypothesis; production value follows measurements and approved outage/loss policy. | 28-day distributions plus 30/60/90-day backlog fill/drain. | Product/SRE/Privacy; open |
| C-006 | `01` vs `02`/`05` wording | “Central SQL inbox” is agreed, but SQL Server vs PostgreSQL and acceptance payload shape differ. | Architecture is engine-neutral: immutable batch custody/receipt, leased workers, dedupe ledger. Engine and parsed-vs-compressed payload are benchmark parameters. | API acceptance, WAL/storage, poison, replay, and restore benchmark. | Platform/Data; open implementation ADR |
| C-007 | `01` vs `02` | Service identity may be LocalService or a virtual account. | LocalService + service SID is the baseline because the Windows pack provides the most specific proof plan. A virtual account needs an explicit advantage. | Token/ACL/network matrix on supported Windows/RDS. | Endpoint Security; resolved with gate |
| C-008 | `01` vs `02`/`05` | API transaction may insert canonical events immediately, or only an immutable batch for async parsing. | Commit receipt + immutable batch synchronously; deep-validate/materialize asynchronously. “Durably received” is distinct from “materialized.” | Compare acceptance latency, storage/WAL, poison isolation, and support diagnostics. | Platform/Data; proposed |
| C-009 | `02` vs `01`/`05` | Monthly partitions initially versus benchmark before choosing daily/weekly/monthly. | Make schema partition-ready; do not fix production grain before measured data. | One-year-shaped dataset, late arrivals, rollover, purge, and portal workload. | Data Platform; resolved by experiment |
| C-010 | `02` vs `01`/`04` | Endpoint memory gates of roughly 55 MB service/45 MB SessionHost versus 150 MiB combined. | 150 MiB combined is a pilot stop ceiling; 55/45 MB are optimization targets. | 24-hour soak and ten-session RDS test. | Endpoint/SRE; proposed |
| C-011 | `02` vs `03`/`01` | Optional PowerShell compatibility host versus categorical rejection of arbitrary script delivery. | No PowerShell in baseline. A later package may expose only fixed signed capability IDs with owner and retirement date. | Per-script business disposition; security review. | Product Security; deferred |
| C-012 | `03` engineering defaults vs `06` governance | Suggested raw/aggregate retention periods versus explicit owner/legal decisions. | Treat all periods as pilot hypotheses only. No production retention is selected by this baseline. | Purpose/necessity/records/legal workshop and deletion cost model. | Privacy/Records; stakeholder decision |
| C-013 | `04`/`02` vs unresolved product requirement | Polling, ETW, WMI, or hybrid process collection. | Leave out of Browser slice; select the least-privileged mechanism meeting a documented completeness contract. | E6 short-lived-process ground-truth test plus stakeholder semantics. | Product/Endpoint; deferred |
| C-014 | `02` update packaging vs `01` simplicity | Self-contained .NET is chosen, but this transfers runtime patch duty from OS to product. | Use self-contained multi-file endpoint deployment with an explicit monthly rebuild/security rollout SLA. | Patch automation and version-compliance dashboard. | Release Engineering; resolved |
| C-015 | `03`/`04` broad browser support vs thin vertical slice | Full product needs Edge/Chrome/Firefox; a first slice should be narrow. | Prove the generic process/privacy/outbox path with Edge first; qualify Chrome and Firefox as separate adapter gates before broad rollout. | Current/previous stable and Firefox ESR fixture suites. | Product/Browser Owner; resolved |

---

# 7. Consolidated risk register

Ratings are inherent before controls. **Residual** is the expected remaining exposure after the baseline controls; it is not zero.

| ID | Risk | L | I | Baseline controls | Residual risk | Owner | Review/alert trigger |
| --- | --- | --- | --- | --- | --- | --- | --- |
| R-001 | Policy or implementation collects prohibited data | M | Critical | Privacy ceiling, tenant narrowing only, endpoint canary tests, two-person expansion approval, kill switch | M: approved code/policy can still be wrong | Privacy + Product Security | Any forbidden value; immediate collector stop |
| R-002 | Local admin/SYSTEM malware reads, suppresses, or fabricates telemetry | H | High | Minimize early, encrypted blobs, TPM keys, EDR signals, label telemetry untrusted/non-forensic | H: no product boundary defeats live SYSTEM | Endpoint Security/SOC | Compromise signal or impossible-rate anomaly |
| R-003 | Cross-user/session collection or attribution | M | Critical | Per-session host, logon-SID pipe ACL, OS-derived caller identity, source leases, RDS tests | L-M: shared profiles/VDI remain complex | Endpoint + Privacy | Any cross-session canary; fleet stop |
| R-004 | Browser lock/schema/update produces gaps or duplicates | H | High | Read-only/backup strategy, capability-based adapters, native-ID cursor, overlap/dedupe, unsupported-schema fail closed | M: vendor internals can change without notice | Browser Owner | Unsupported schema or recall gate failure |
| R-005 | Event/checkpoint divergence on crash | M | Critical | One SQLite transaction, model checker, 10,000 fault points, stable event keys | L after proof | Endpoint/Data | Any cursor-ahead invariant violation |
| R-006 | SQLite corruption, wrong native DLL, WAL growth, or disk full | M | High | Pinned engine/version assertion, FULL, one writer, quick_check, quotas, emergency reserve, preserve quarantine set | M: hardware/rogue admin can corrupt | Endpoint/SRE | Integrity failure, 85/95% pressure, WAL trend |
| R-007 | Stolen/cloned device identity or VDI golden-image credential | M | Critical | Per-device key, TPM where possible, post-clone enrollment, short certs, server denylist, enrollment epoch | M: stolen unlocked device can use genuine key | PKI/SOC | Concurrent identity, stale management, clone test |
| R-008 | mTLS incompatible with proxy/VPN or revocation path | M | High | Early proxy matrix, controlled gateway, explicit fallback design—not shared secret, rapid app denylist | M: enterprise middleboxes vary | Network/PKI | Auth failure > agreed cohort threshold |
| R-009 | CI/signing/update compromise distributes malicious release | M | Critical | Isolated build, provenance/SBOM, HSM roles, offline threshold root, approvals, rings, blocklist, rollback | M-H: valid malicious release may reach canary | Release Security | Unexpected signature/provenance or canary privacy/crash signal |
| R-010 | Updater becomes a SYSTEM arbitrary-file primitive | M | Critical | Tiny command surface, fixed roots, reparse/TOCTOU defenses, manifest allowlist, MSI repair, no general run command | M | Endpoint Security | Unexpected destination/ACL/service operation |
| R-011 | Task channel becomes remote shell | M | Critical | Declarative fixed capabilities, no scripts/command lines, restricted process, no network, package expiry and approval | L-M within approved capability | Product Security | Manifest requests undeclared capability |
| R-012 | API decompression/parser abuse | H | High | Streaming limits, ratio/depth/count/string bounds, strict duplicate-field handling, fuzzing, rate limits | L-M | API Security | Rejection/CPU/memory anomaly |
| R-013 | Replay or ambiguous response causes duplicates or loss | H | High | Stable batch ID/hash, deterministic event dedupe, receipt lookup, idempotent worker, long dedupe horizon | L | API/Data | Same ID/different hash or reconciliation mismatch |
| R-014 | Fleet reconnect overwhelms gateway, inbox, DB, or WAN | H | High | Stable phase spread, full jitter, per-device/site/realm fairness, `Retry-After`, recovery budget, 6k/12k tests | M | SRE | Backlog age rising; fast SLO burn |
| R-015 | Relational inbox or final DB saturates through WAL/index/vacuum pressure | M | High | Separate acceptance/materialization pools, bulk load, minimal indexes, queue-age SLO, headroom gate, autovacuum/maintenance metrics | M | Data/SRE | Cannot sustain 1.5× required rates or WAL/archive RPO |
| R-016 | Wrong central database choice raises migration or operating risk | M | High | Engine-neutral contracts, comparative benchmark, restore/failover/skills/TCO gate, SQL Server fallback | M | CTO/Data Platform | Gate failure or on-call skills gap |
| R-017 | Partition rollover, missing partition, or retention purge loses/blocks data | M | High | Precreation/probe, inbox isolation, reconciliation before detach, bounded locks, no default catch-all | L-M | Data Platform | Boundary insert failure or retention mismatch |
| R-018 | Central restore loses already acknowledged data | M | Critical | Durable ACK failure-domain definition, endpoint replay grace, receipt reconciliation, idempotent restore replay | L after drill | SRE/Data | Any missing acknowledged batch |
| R-019 | Restore resurrects erased data; exports/backups escape deletion | H | High | Tombstone ledger, restore readiness gate, export registry, connector deletion, key boundaries, backup expiry | M: recipient copies/immutable media persist until expiry | Privacy/Data/Records | Missed deletion or restore test mismatch |
| R-020 | Realm confusion exposes another customer | M | Critical | Server-derived realm, scoped keys/rows/cache/object paths, API and RLS defense, cross-realm property tests | L but severe | Platform Security | Any cross-realm canary; stop affected plane |
| R-021 | Authorized admin/insider misuses detail, export, diagnostics, or joins | H | High | JIT capability, purpose/ticket/time, approval, aggregate-first views, anomaly detection, independent audit | M-H: legitimate access can be abused | Privacy/IAM/SOC | Unrelated-subject lookup, unusual export/join |
| R-022 | Audit is altered or omitted | M | High | Mutation+audit transaction, external immutable verification, separate access, daily seal | L | Audit/SOC | Sequence/hash divergence or audit-write failure |
| R-023 | Integration leaks data or remains unavailable | M | High | Per-tenant outbox/credential, field allowlist, expiry, DLP, circuit, idempotency, deletion contract | M: recipient may retain copy | Integration Owner/Privacy | Delivery age, unusual fields/recipient, deletion failure |
| R-024 | Portal/frontend dependency compromise | M | High | Lockfile, SBOM, internal policy, CSP, bundled assets, Node build-only, patch SLA, authorization server-side | L-M | Portal Security | Dependency/provenance alert or CSP violation |
| R-025 | Legacy behavior/report semantics silently change | H | High | Disposition matrix, frozen baseline, digest comparison, owner-defined semantics, compatibility projector, mismatch classification | M until consumer inventory is complete | Product/Data/Migration | Exact invariant or tolerance failure |
| R-026 | Legacy buffers, credentials, mutation paths, or unreachable devices survive cutover | M | Critical | Inventory/hash/quarantine, never execute SQL buffer blindly, revoke DB logins, network deny, residual-activity monitoring | M | Migration/Security/Ops | Any endpoint DB login/write after cutover |
| R-027 | Process collection misses short-lived processes or overclaims completeness | H | Medium-High | Define inventory vs event contract; polling/ETW/WMI ground-truth test; label quality | M | Product/Endpoint | Measured capture below accepted threshold |
| R-028 | Unsupported RDS/FSLogix/ARM64/EDR behavior causes gaps or profile locks | M | High | Conditional support lanes, source lease, handle/logoff tests, physical hardware and enterprise lab | M until tested | Endpoint Engineering | Profile detach blocked or cross-session duplication |
| R-029 | Logs, traces, crash dumps, or support bundles leak telemetry/secrets | H | High | Allowlisted structured logging, body logging off, redaction library, seeded scanners, case-scoped bundles | M: unforeseen exception text | Security/SRE/Support | Any canary in a diagnostic sink |
| R-030 | Operational ownership, staffing, or runbooks are inadequate | M | High | Named RACI, game days, support training, SLOs, kill switches, on-call evidence, no unsupported components | M | Service Owner | Failed exercise or ownerless alert |
| R-031 | Retention or access policy is selected without lawful/business authority | M | Critical | Stakeholder decision register, conservative off/defaults, no broad rollout before assessment | L-M depending governance | Privacy/Legal/Service Owner | Missing sign-off or changed purpose |
| R-032 | UAM data is treated as productivity score or sole disciplinary evidence | M | High | Product prohibition, aggregate-first portal, no score, access purpose, user notice, training, quality flags | M: organizational misuse remains possible | Service Owner/Privacy | New scoring/report request or misuse incident |

---

# 8. Minimal proof program ordered by ability to invalidate the design

A failed early gate stops dependent work and produces an ADR change or scoped redesign. Passing a gate proves only the stated claim.

| Order / gate | Claim being tested | Minimum environment and method | Pass gate | Fail action / design consequence |
| --- | --- | --- | --- | --- |
| G0 — Purpose and source contract | The Browser slice has an approved outcome and lawful/governed data shape. | PO/Privacy/Legal/Data workshop; field and purpose register; synthetic examples; prohibited-use statement. | Named owner, domain/site output decision, identity/time precision, first-run lookback, pilot retention, access, notice/DPIA/consultation disposition all signed. | No live collection. Keep implementation synthetic-only. |
| G1 — Session launch and IPC isolation | A low-privilege service and Task Scheduler User Hosts work without user-token creation or cross-session leakage. | Windows 11 x64 VM; two standard users; console, fast switch, RDP/disconnect; hostile pipe client; AccessChk/ProcMon. | LocalService, no `SeTcb/SeDebug/SeBackup/SeRestore`; one host/session; 0/10,000 cross-session accepted messages; service opens zero profile files; bounded malformed-client resource use. | Redesign launch/IPC. Do not promote service to LocalSystem as a shortcut. |
| G2 — Live browser acquisition | A standard-user collector obtains a consistent view while Edge writes, without modifying source data. | Temporary Edge profiles; deterministic localhost visits; direct read and online backup; injected locks; ProcMon; final offline truth reconciliation. | 10,000 attempts; zero source writes; zero malformed accepted snapshots; failed/busy read never advances cursor; all final controlled visits present after reconciliation. | Change acquisition method or support claim; do not start vertical slice. |
| G3 — Profile/source-generation and cursor correctness | Multiple profiles, late historical times, same timestamps, deletion, and source recreation do not lose or mix visits. | Default + additional profiles; custom roots; synthetic DB fixtures; new IDs with old times; replacement DB; unsupported schema. | 100% fixture recall; zero profile/user mixing; new generation on replacement; unsupported schema emits zero data and no cursor progress. | Redesign source ID/cursor/adapter policy. |
| G4 — Endpoint privacy gate | Forbidden source values cannot escape even through failures and diagnostics. | Golden and fuzz corpus with sensitive URL/path/token/user canaries; inspect TaskHost output, IPC, DB/WAL/free pages, logs, crash path, network, support bundle. | Zero forbidden durable/transmitted values across at least 1,000,000 generated records; invalid/expired policy yields zero new collection. | Release blocker and privacy incident if live data is involved. |
| G5 — Outbox/checkpoint crash invariant | Kills, reboots, lost replies, and duplicate ACKs cannot create a cursor gap or duplicate business effect. | Model-based synthetic source, real SQLite, loopback API/receipt ledger; hook every transaction/network transition; VM resets. | 10,000 randomized fault cycles; no cursor-ahead state; `quick_check=ok`; no missing committed IDs; one final event per dedupe key; recovery ≤30 s provisional. | Redesign schema/state machine; no pilot. |
| G6 — Update authorization and rollback | Only authorized complete versions run and rollback preserves outbox compatibility. | MSI v1, good/bad v2, test signing/TUF repo; kill at every phase; tampered/wrong-signer/stale/downgrade/reparse cases. | 100/100 normal updates; unauthorized execution zero; every interruption boots v1 or v2 complete; unhealthy v2 rolls back within two starts/60 s; N−1 can open DB. | Remove autonomous updater or redesign activation/migrations. |
| G7 — Device identity and enterprise network | mTLS enrollment, rotation, revocation, proxy behavior, and clone handling work in target environments. | Managed cert/TPM and software fallback; proxy/VPN; clock skew; revocation; cloned VM/golden image; 100 clone simulation. | Clone disk cannot authenticate as same managed instance; wrong/expired/revoked cert rejected; renewal succeeds before expiry; proxy path meets availability without fleet secret. | Define lower-assurance exception or customer gateway; no silent bearer-secret fallback. |
| G8 — Durable inbox/idempotency/poison | The server can take durable custody quickly and materialize safely. | ASP.NET API, candidate relational DBs, immutable batch, worker leases, duplicate/poison/schema mismatch, worker kills. | Same ID/hash returns same receipt; different hash conflicts; 0 duplicate facts; poison does not block; worker death recovers; accepted batch always materialized or terminally quarantined. | Redesign receipt/inbox or select alternate engine. |
| G9 — Engine and 6,000-device capacity | The default relational design meets measured steady/reconnect/recovery load with headroom and portal coexistence. | 28-day metadata distributions; stateful 6,000–12,000-agent simulator; Windows fidelity cohort; open-arrival transport load; PostgreSQL 18.4 and SQL Server 2025 candidates. | Acceptance and materialization ≥1.5× required rates; p99 durable receipt ≤2 s and p99.9 ≤5 s provisional; oldest age decreases; control p95 ≤500 ms; no connection/WAL/archive/replica failure; 72-hour soak. | Choose better engine, simplify indexes, scale, or cross explicit broker gate. |
| G10 — Disk/backpressure and long outage | Endpoint and central backlogs degrade predictably without silent loss. | 30/60/90-day p99-shaped local backlog; disk-full VHD; one-hour and multi-day outages; site fairness; drain test. | Collection pauses before free-space floor; committed rows survive; live traffic remains healthy during drain; approved recovery objective met; no synchronized storm. | Change cap, collection priority, recovery objective, or add capacity. |
| G11 — Deletion, restore, and acknowledged replay | Restore neither loses acknowledged events nor resurrects deleted data. | Seed events/subject, accept, delete, backup, restore to earlier point, replay endpoint grace, apply independent tombstones, test connector/export inventory. | Reconciliation finds zero missing acknowledged batches and zero visible deleted subject records before read readiness; approved RPO/RTO met. | Production block; redesign durability/tombstone/key boundaries. |
| G12 — Extended Windows fidelity | Conditional platform claims are supportable. | Real RDS/AVD/FSLogix/Citrix, same-SID sessions, physical ARM64, Modern Standby, hard power loss, Defender/customer EDR. | No cross-user records, no blocked profile detach, native dependencies, equivalent update/outbox gates, agreed host/battery budget. | Keep platform unsupported/conditional or redesign component. |

## 8.1 Provisional performance and reliability targets

These targets are hypotheses for the proof program, not business requirements:

- Coordinator idle CPU average ≤0.25% of one logical processor; combined steady-state service + one User Host <150 MiB private memory; lower 55 MiB/45 MiB figures remain optimization goals.
- A periodic User Host normally exits within 20 seconds after collection; a persistent host is permitted only if process-observation requirements justify it.
- Direct browser read p95 <500 ms and online backup p95 <3 seconds on test profiles; browser navigation p95 degradation <5%.
- No unexplained working-set or handle growth >10% over a 24-hour endpoint soak.
- Initial server test: 200 accepted batches/s for 30 minutes and 1,000 batches/s for a 60-second reconnect burst, then replace with the measured capacity equation.
- No error budget exists for missing acknowledged batches, cross-realm disclosure, forbidden fields, duplicate final event keys, or unaudited successful privileged mutation.

---

# 9. First Browser History vertical slice

## 9.1 Objective

Prove the complete security, privacy, durability, delivery, materialization, and minimal portal path for one real source without pretending the rest of UAM is already supported.

## 9.2 Included scope

| Area | Included |
| --- | --- |
| OS | Windows 11 Enterprise/Education 25H2 x64; 24H2 test lane while serviced. |
| Browser | Microsoft Edge Stable using one version currently installed plus previous-version and schema fixtures. |
| Sessions | Current interactive standard user; console, lock/unlock, fast user switching, one ordinary RDP lane. |
| Profiles | All eligible Edge profiles beneath approved default or policy-defined user-data roots for that user; one source identity per profile. |
| Source read | Short read-only transaction; SQLite online backup fallback; defer on failure. |
| First run | Start at policy activation/installation time; no historical backfill. |
| Cursor | Source generation + native Chromium `visits.id`; source time retained for validation; bounded overlap and deterministic dedupe. |
| Privacy output | Approved `site_id` or canonical domain-level identifier only; no page-level detail. Reporting uses a coarse approved time bucket. |
| Endpoint path | Task Host → User Host privacy gate → authenticated pipe → SQLite event/cursor transaction → batch/receipt. |
| Server path | mTLS gateway → durable batch inbox → worker validation/dedupe → Browser fact + daily aggregate → minimal health/aggregate API and portal. |
| Operations | Policy assignment, kill switch, health, backlog, version, source status, audit, and redacted support bundle. |

## 9.3 Explicitly excluded

Chrome and Firefox live production support; incognito/InPrivate content; logged-off or inactive profiles; arbitrary/custom portable browsers; full URLs, query strings, fragments, page titles, search terms, userinfo, cookies, headers, or content; Recent Items, Quick Access, processes, extensions, HR/AD joins, raw exports, free-form search, historical data migration, RDS/FSLogix/ARM64 production claims, external broker, Rust/Go, arbitrary tasks, PowerShell compatibility, and autonomous updater activation unless G6 is being tested.

## 9.4 Interfaces

1. **Collector invocation contract** — fixed capability, policy digest, source descriptor, cursor, page/byte deadline; typed result or typed failure.
2. **Task Host → User Host contract** — source-native rows over inherited private IPC; no network and no machine credentials.
3. **Privacy transformation contract** — canonicalization version, allowlist/site mapping, hard deny classes, field-level output schema, redaction reason IDs.
4. **User Host → Coordinator IPC** — length-prefixed local-only protocol, per-session binding, maximum message/event sizes, service-issued nonce.
5. **SQLite transaction contract** — event page, source cursor, source generation, stream sequence, policy/adapter/schema version in one commit.
6. **Upload contract** — immutable batch ID/hash, device assertion for consistency, agent/schema/policy versions, compressed event list.
7. **Receipt contract** — durable receipt ID, batch hash, server time, duplicate status, receipt lookup; later terminal materialization/quarantine status is separately queryable.
8. **Policy contract** — signed immutable revision, privacy-ceiling compatibility, effective/expiry, target, allowed Edge roots/profiles/sites, time precision, schedule, limits.
9. **Control/query contract** — device/source health, policy adoption, backlog, receipt status, minimized daily site-use aggregates, audited administrative mutations.

## 9.5 Event contract

Illustrative canonical event; exact optionality is fixed by the approved field register:

```json
{
  "eventId": "uuidv7",
  "dedupeKey": "versioned deterministic digest",
  "eventType": "browser.visit.v1",
  "eventSchemaVersion": 1,
  "realmId": "server-derived; echoed only as consistency assertion",
  "deviceId": "opaque device UUID",
  "installationId": "opaque enrollment epoch",
  "subjectToken": "realm-scoped opaque token",
  "sessionId": 3,
  "browserFamily": "edge",
  "profileSourceId": "opaque stable source ID",
  "sourceGeneration": 2,
  "nativeVisitId": 18442,
  "sourceTimestampEpoch": "webkit_microseconds_1601_utc",
  "rawSourceTimestamp": 13415000000000000,
  "occurredAtUtc": "2026-07-30T09:15:32.123456Z",
  "usageBucketStartUtc": "2026-07-30T09:00:00Z",
  "siteId": "approved-site-0042",
  "policyRevision": "uuid",
  "adapterVersion": "1.0.0",
  "schemaSignature": "sha256:...",
  "collectedAtUtc": "2026-07-30T09:16:00Z",
  "qualityFlags": []
}
```

`realmId` in storage is set from authenticated server context. The exact source timestamp is operationally restricted and retained only if the approved contract needs reconciliation or ordering; business views expose the coarser bucket. A bare hash is not anonymous; subject/site tokenization uses realm-specific keyed transformation or a resolver service.

## 9.6 Privacy rules

- Accept only `http` and `https` sources that match an approved allowlist/site mapping.
- Remove userinfo, query, fragment, title, path, port unless explicitly part of an approved site identity, and any value that becomes prohibited after canonical decoding.
- Hard deny sensitive categories defined by governance; ordinary tenant policy cannot override them.
- Never log the rejected value. Emit only rule ID, category, bounded length/shape, adapter/source ID, and correlation ID.
- Unknown policy fields, source schemas, URL schemes, or normalization versions fail closed.
- The Task Host may temporarily read the source row but has no network. The User Host is the final gate before IPC and durable storage.
- Full source snapshots are never uploaded and are removed from scratch under a bounded reaper; scratch names contain no user/site information.
- Private/InPrivate sessions are expected not to persist history; tests must verify no inference or unrelated browser store is read.

## 9.7 Test set

Functional and fidelity tests:

- Default and multiple Edge profiles; enterprise `UserDataDir`; profile added/removed/renamed/recreated.
- Same timestamps, late row with old event time and new ID, deleted rows, ID regression/source replacement.
- Browser open under continuous writes; read locks; online backup; cancel/kill during read; browser update; unsupported/missing column; corrupt fixture.
- WebKit epoch conversion, UTC, time-zone and DST changes, clock forward/backward, suspend/resume.

Security/privacy tests:

- Cross-user pipe attempts, spoofed SID/session, PID reuse, oversized/partial frames, local remote-pipe attempt.
- Forbidden URL components, encoded secrets, sensitive categories, very long/invalid Unicode, duplicate JSON fields, compression bomb.
- Secret/PII canary scan of source scratch, TaskHost output, IPC, DB/WAL/SHM, logs, Event Log, crash artifacts, request body, gateway, inbox, worker errors, traces, metrics, portal, support bundle.
- Revoked/wrong-realm/expired certificate and forged proxy identity header.

Durability tests:

- Kill at every event/cursor/batch/send/receipt transition; hard VM reset; disk full; corrupt outbox copy; lost HTTP response after server commit; repeated receipt; duplicate batch with changed body; worker death after fact insert.

Migration/comparison tests:

- Frozen legacy policy and known-defect manifest; compare only counts, source ranges, keyed digests, rule IDs, and timestamps in shadow mode. Raw data inspection requires approved break-glass.

## 9.8 Telemetry

Endpoint metrics use bounded labels only:

```text
collector_runs_total{collector,result}
collector_duration_seconds{collector,result}
events_examined_total{collector}
events_retained_total{collector,rule_class}
outbox_events / outbox_bytes / outbox_oldest_age_seconds
sqlite_commit_duration_seconds / sqlite_wal_bytes
batch_events / batch_compressed_bytes / batch_flush_reason
upload_attempts_total{outcome,status_class}
policy_revision_adoption
source_health{collector,status_class}
```

Server metrics cover durable receipt latency, requests/events/bytes, duplicate/conflict counts, decompression rejection, inbox batches/events/bytes/oldest age, worker leases/retries/quarantine, materialization latency, fact reconciliation, WAL/index/storage growth, policy adoption, and portal query class. Device, subject, URL, domain, event, and batch IDs are not metric labels.

## 9.9 Acceptance criteria

The slice is accepted for an engineering canary only when all of the following hold:

1. Governance G0 is signed; no live pilot otherwise.
2. Zero forbidden values across the full canary corpus and every diagnostic/storage/network sink.
3. Zero cross-session accepted records in at least 10,000 hostile/transition attempts.
4. Ten thousand live acquisition attempts produce zero accepted corrupt views and zero writes to browser source files.
5. Final controlled-fixture recall is 100%; final central duplicate facts are zero.
6. Failed, busy, unsupported, cancelled, or corrupt-source reads never advance the cursor.
7. Ten thousand outbox/network fault cycles preserve the event/cursor invariant and `quick_check=ok`.
8. Same batch ID/hash returns one durable receipt; changed hash is rejected; worker replay has one business effect.
9. No unacknowledged event is silently dropped under disk pressure; collection pauses predictably.
10. Unauthorized update/policy execution is zero; rollback and N−1 DB compatibility pass if updater is in the slice.
11. Provisional endpoint and browser-impact budgets in section 8.1 pass without unexplained growth.
12. Support can diagnose one browser lock/schema, policy, certificate, outbox, and server failure using metadata-only tools.
13. Every administrative mutation has actor, realm, capability, reason, target, before/after, outcome, and correlation ID; audit failure blocks mutation.
14. Deletion/restore G11 passes before any production-authoritative use.

---

# 10. Phased roadmap with dependencies and decision gates

The roadmap is a dependency sequence, not a staffing or calendar promise.

| Phase | Scope | Dependencies | Exit decision gate |
| --- | --- | --- | --- |
| P0 — Governance and evidence baseline | Assign owners; approve purpose/prohibited uses; inventory consumers, settings, rules, scripts, buffers, credentials, reports, HR/AD joins; freeze legacy comparison baseline. | None | P0 requirements and Browser G0 approved; unknown items disabled/quarantined. |
| P1 — Architecture falsification | Run G1–G7 on Windows; build minimal release/key ceremony; prove privacy, browser source, outbox, updater, identity. | P0 | Any failed invariant is redesigned; architecture ADRs accepted before slice implementation. |
| P2 — Edge Browser vertical slice | Implement the section 9 end-to-end path with synthetic fixtures and lab portal/health. | P1 gates | All section 9 acceptance criteria pass in lab. |
| P3 — Server engine and capacity selection | Collect 28-day metadata-only workload; build 6k simulator; compare PostgreSQL 18.4 and SQL Server 2025; prove inbox, failover, restore, retention, report coexistence. | Working slice transport/contracts | D-017 production ADR accepted; broker remains deferred or has explicit evidence. |
| P4 — Engineering canary | 10–25 managed devices, shadow/comparison summaries only; detail not authoritative; staffed support and kill switches. | P2, identity, signed release, monitoring | No P0 violation; stable resources; every discrepancy classified; approved bake evidence. |
| P5 — Representative pilot | 50–100 devices spanning hardware, network, profiles, Edge versions, user patterns; approved short pilot retention. | P3 and P4; privacy/security pilot approval | Data quality, support, restore/deletion, operational game days, and owner acceptance pass. |
| P6 — Additional browser adapters and platform lanes | Chrome adapter, Firefox Release/ESR adapter; RDS/FSLogix/ARM64 lanes as separately gated. | P5 architecture stable | Each adapter/platform has its own source, privacy, cursor, schema, and support acceptance. |
| P7 — Production rings | Controlled population sequence such as 1%, 5%, 20%, 50%, remaining managed fleet; explicit bake and automatic stop gates. | Production authority, capacity/DR, support/on-call | No threshold breach; approved fleet coverage; exceptions have owner, reason, expiry. |
| P8 — Additional collectors and portal workflows | Recent Items without target dereference; process mechanism after E6; approved integrations; governed administrative workflows. | Core platform production stable | Each feature passes purpose, privacy, source-fidelity, fault, scale, RBAC, audit, and migration gates. |
| P9 — Cutover and legacy read-only | New server is authoritative; server-side compatibility projector only where needed; legacy portal mutation disabled; historical estate read-only. | Consumer reconciliation, rollback readiness | Zero unauthorized legacy writes; all buffers/consumers dispositioned; report owners sign. |
| P10 — Decommission | Remove endpoint DB paths/credentials, PSU mutation functions, obsolete schedules/scripts, accounts, firewall rules, and compatibility writes; retain governed history. | Stable cutover and records decisions | Residual-activity monitoring passes; final multi-owner acceptance and CMDB/architecture update. |

Ring expansion is an explicit decision. A full-fleet rollback is not the first response: prefer the smallest safe unit—policy, rule, collector, capability package, then agent version.

---

# 11. Decide now, measure first, ask stakeholders, and defer safely

## 11.1 Decide now

| Decision | Baseline |
| --- | --- |
| Endpoint shape | Coordinator Service + per-session User Host + restricted Task Hosts. |
| Language | C# 14/.NET 10 for endpoint and server. |
| Trust | No endpoint database credential, SQL, direct DB path, or tenant-authored code. |
| Privacy | Release-signed ceiling; final endpoint filtering before outbox; invalid policy fails closed for new collection. |
| Local durability | Pinned SQLite WAL, FULL, one writer, atomic events/cursor/sequence. |
| Identity | Per-device mTLS and server-derived realm/device context. |
| Transport | Bounded versioned JSON/gzip with stable IDs, hash, full-jitter retry, and durable receipt. |
| Server topology | Relational durable inbox + idempotent workers; modular monolith; no broker by default. |
| Trust planes | Release, control, and data authority are independently credentialed and operated. |
| Portal | API-only React/BFF, OIDC, capability authorization, purpose-bound high-risk access. |
| Audit | Privileged mutation and audit commit together; audit is independently verifiable. |
| Migration | Server-side compatibility projection; no endpoint dual-write; legacy history read-only by default. |
| Updates | MSI/enterprise management for stable boundary; Authenticode plus TUF-style anti-rollback. |
| Browser read | Direct read-only, online-backup fallback, no raw live file copy. |
| Data interpretation | Telemetry is fallible, non-forensic, and not a productivity score. |

## 11.2 Measure first

| Unknown | Measurement/decision rule |
| --- | --- |
| PostgreSQL vs SQL Server production engine | Same production-shaped ingest, report, retention, failover, restore, skills, licensing, and on-call exercise; choose on total evidence. |
| Event, byte, batch, active-fleet, retry, and outage distributions | 28 consecutive days of metadata-only measurements; size from p99/tails and defined recovery objective. |
| Outbox age/byte caps and priority behavior | 30/60/90-day fill/drain plus approved maximum offline duration and loss/pause policy. |
| Batch limits and flush interval | Measure p50/p95/p99 body sizes, occupancy, compression, proxy behavior, API decode/commit cost. |
| Partitioning grain and indexes | One-year-shaped data, required query classes, late arrivals, rollover, retention, WAL/storage delta. |
| Need for external broker | Add only if relational inbox misses SLO/headroom, DB-outage acceptance is required, replay/fan-out is independent, or cost crossover is proven. |
| AppContainer | Adopt only if supported sources remain accessible and support burden is acceptable; otherwise restricted token + Job Object. |
| Process mechanism | Ground-truth polling/WMI/ETW capture and stakeholder-defined completeness. |
| Resident resources | Real device and ten-session RDS soaks; profile causes before considering Rust. |
| Self-updater need | Enterprise management coverage and emergency patch SLA across every endpoint class. |
| mTLS/proxy/TPM/VDI behavior | Customer network and certificate lab, including clone and revocation. |
| SLO/RPO/RTO and ACK grace | Business availability decision plus full restore/replay drills. |
| Reporting platform | Top query corpus and concurrency against replica/materialized views before warehouse/lakehouse. |

## 11.3 Ask stakeholders

| Decision | Accountable role |
| --- | --- |
| Approved purpose and prohibited uses for each signal | Service owner, business data owner, Privacy/Legal |
| Exact Browser output: site ID, domain, path, title, and time precision | Product Owner, Privacy, Data Owner |
| First-installation lookback and handling of deliberately filtered rows | Product Owner, Privacy, Reporting |
| Whether identity is device, account, session, pseudonymous subject, or person | Product Owner, IAM, Privacy |
| Detail, aggregate, diagnostics, audit, export, staging, backup, and legal-hold retention | Privacy/Legal, Records, Data Owner |
| Who may view detail, resolve identity, export, enable diagnostics, change policy, publish tasks, delete, or break glass | IAM, Privacy, Security, Service Owner |
| Whether UAM data may support disciplinary, productivity, security, HR, or case decisions | Executive Sponsor, HR/Legal, Privacy |
| DPIA, notice, employee-representation/works-council, rights, and consultation obligations | DPO/Legal/HR |
| Required Windows/browser/RDS/VDI/ARM64 support and exception policy | Product Owner, Endpoint Operations |
| Required offline duration, data-loss policy, service SLO, RPO/RTO, and support hours | Service Owner, SRE, Privacy, Finance |
| HR/AD source ownership and whether same-instance joins must remain | HR/IAM/Data Owners |
| Historical reports/data that must remain available and their semantics | Reporting/Data Owner, Records, Product Owner |
| Budget, licensing, hosting, and managed-service constraints | Sponsor, Platform, Procurement/Finance |

## 11.4 Defer safely

| Item | Safe deferred state |
| --- | --- |
| Full URL, path, title, command line, window title, file content | Not collected; separate future purpose/privacy ADR required. |
| Quick Access/Home reverse engineering | Unsupported; implement only Recent Items through supported APIs when approved. |
| Arbitrary scripts and legacy schedules | Encrypted read-only archive/disabled drafts; never execute automatically. |
| PowerShell compatibility | No package installed; any future fixed capability has owner and retirement date. |
| Rust or Go components | None in production; reconsider only after profiled hard boundary and maintainer gate. |
| External broker, Kafka, lakehouse, OLAP stream estate | Not deployed; activate only through quantitative ADR trigger. |
| AppContainer | Experimental lane only. |
| RDS/FSLogix/Citrix/ARM64/Modern Standby production support | Conditional/unsupported until G12 passes. |
| Historical detail migration | Keep governed legacy history read-only; do not copy into active facts by default. |
| Person-level export, raw search, scores, profiling, automated recommendations | Disabled; separate governance/product capability required. |
| Long retention and immutable raw batch archives | No default; must be reconciled with purpose, deletion, and key boundaries. |

---

# 12. Source-quality appendix

## 12.1 Evidence-quality assessment

### Strongest evidence

The most reliable claims rely on primary standards, regulator material, official Microsoft Windows/.NET documentation, official SQLite and PostgreSQL documentation, RFCs, NIST publications, and official TUF material. These strongly support the session boundary, least privilege, SQLite WAL semantics, HTTP/idempotency constraints, device identity options, update-role separation, relational queue primitives, and deletion-after-restore requirement.

### Internal evidence

`UAM-CODE-REFERENCE.md` is high-value evidence of legacy implementation behavior—direct MSSQL access, SQL-shaped CSV deferral, user/session dependence, browser SQLite access, `Invoke-Expression`, portal SQL mutation, scripts/schedules, and mutable audit—but it is incomplete by its own classification. Runtime configuration, dynamic data, external consumers, and production practices require inventory and observation.

### Vendor implementation details

Chromium and Firefox schema/source references are authoritative descriptions of current implementation details, not supported public telemetry APIs. Adapter code must use capability detection, fixtures, rolling qualification, and fail-closed behavior. Browser support claims should be current/previous release policies, not perpetual schema promises.

### Rolling or short-lifecycle dependencies

SQLite, React, TypeScript, Vite, Playwright, Node, Rust, Go, RabbitMQ, browser releases, Windows releases, and WiX move faster than the product lifecycle. Their point-in-time versions are useful only with an explicit patch and replacement review cadence. React and common frontend tools do not provide a product-length enterprise LTS promise. WiX 7 also has legal/licensing implications that technical evidence cannot settle.

### Weak, inferred, or conflicting claims converted to gates

- SQL Server’s transition advantage is an inference from the legacy estate and skills surface; PostgreSQL’s target advantage assumes operational competence. The comparative engine gate replaces confidence wording.
- All low/base/high rates, storage values, local caps, batch limits, resource limits, SLOs, and headroom factors are estimates or starting hypotheses, not requirements.
- Retention defaults are technical proposals, not legal conclusions.
- TPM coverage, mTLS/proxy compatibility, AppContainer access, RDS/FSLogix behavior, ARM64 fidelity, and browser live-lock behavior require local proof.
- TypeScript 7.1 expectations and other future tooling statements are time-sensitive and must not be treated as committed roadmaps.
- The security pack contains one imprecise TLS/RFC wording around a link to RFC 8705; this baseline relies on the actual cited TLS/mTLS standards and not that wording.
- A vendor’s security or lifecycle page establishes capability/support, not UAM-specific correctness, performance, or staffing readiness.

## 12.2 Load-bearing primary sources

| Subject | Source | Use in this baseline |
| --- | --- | --- |
| Windows services and Session 0 | [Microsoft service isolation](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista) | Supports service/user-session split and least privilege. |
| Task Scheduler user context | [Principal logon types](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype) | Supports ordinary interactive-token launch. |
| Highly trusted token API | [WTSQueryUserToken](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken) | Explains why service-driven user-token creation is rejected. |
| Named-pipe ACLs | [Microsoft named-pipe security](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights) | Supports explicit logon-SID security and rejection of defaults. |
| Process containment | [Windows Job Objects](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects) | Supports child process/resource containment. |
| SQLite durability | [SQLite WAL](https://sqlite.org/wal.html), [PRAGMA](https://sqlite.org/pragma.html) | Supports WAL persistence, FULL durability, checkpoint and integrity behavior. |
| Live DB snapshot | [SQLite online backup](https://sqlite.org/backup.html) | Supports safe browser fallback. |
| HTTP retries | [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) | Requires application-level idempotency for retried POST semantics. |
| Device sender binding | [RFC 8705](https://www.rfc-editor.org/rfc/rfc8705), [CNG providers](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers) | Supports mTLS/certificate-bound device identity and TPM-backed keys. |
| Update security | [TUF specification](https://theupdateframework.github.io/specification/latest/) | Supports role separation, expiry, rollback/freeze protection, and recovery planning. |
| Relational inbox | [PostgreSQL `SKIP LOCKED`](https://www.postgresql.org/docs/current/sql-select.html) | Supports queue-like worker claiming. |
| Partitioning limits | [PostgreSQL partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html) | Supports retention operations and explains global uniqueness/partition complexity. |
| Runtime lifecycle | [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Supports .NET 10 LTS selection and replacement date. |
| Security architecture | [NIST SP 800-207](https://csrc.nist.gov/pubs/sp/800/207/final), [NIST SSDF](https://csrc.nist.gov/pubs/sp/800/218/final) | Supports zero-trust assumptions and secure-development practices. |
| Deletion and restore | [EDPB erasure annex](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf) | Supports restore-time re-deletion/tombstone procedure. |
| Data protection | [GDPR](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng) | Establishes the legal framework; exact applicability remains counsel/controller decision. |
| Load methodology | [k6 open arrival rate](https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/) | Prevents a closed-load model from hiding overload. |
| Observability | [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/) | Supports portable, consistent telemetry schemas. |

## 12.3 Preserved citation register

The following deduplicated register preserves the primary and official citations carried by the six research packs. Inclusion records provenance; it does not imply that every source settles a UAM-specific decision without local proof.

| ID | Source | Quality note | Used by pack(s) |
| --- | --- | --- | --- |
| SRC-001 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista) | Official primary/vendor documentation | 01, 03, 04 |
| SRC-002 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support) | Official primary/vendor documentation | 01 |
| SRC-003 | [GitHub](https://github.com/theupdateframework/specification/blob/master/tuf-spec.md) | Official project repository/tool source; verify maintainer and release context | 01 |
| SRC-004 | [PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html) | Official primary/vendor documentation | 01, 05 |
| SRC-005 | [SQLite](https://www.sqlite.org/wal.html) | Official primary/vendor documentation | 01, 05 |
| SRC-006 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken) | Official primary/vendor documentation | 01, 04 |
| SRC-007 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-loaduserprofilea) | Official primary/vendor documentation | 01 |
| SRC-008 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects) | Official primary/vendor documentation | 01, 02, 04 |
| SRC-009 | [RFC Editor](https://www.rfc-editor.org/info/rfc9562/) | Standard/regulator primary | 01 |
| SRC-010 | [SQLite](https://sqlite.org/pragma.html) | Official primary/vendor documentation | 01, 02, 03, 04, 05 |
| SRC-011 | [SQLite](https://www.sqlite.org/see/doc/trunk/www/readme.wiki) | Official primary/vendor documentation | 01 |
| SRC-012 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccrypto/time-stamping-authenticode-signatures) | Official primary/vendor documentation | 01 |
| SRC-013 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew) | Official primary/vendor documentation | 01, 04 |
| SRC-014 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation) | Official primary/vendor documentation | 01 |
| SRC-015 | [Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure) | Official primary/vendor documentation | 01 |
| SRC-016 | [Protocol Buffers](https://protobuf.dev/programming-guides/proto3/) | Vendor/project documentation; verify context | 01 |
| SRC-017 | [Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0) | Official primary/vendor documentation | 01 |
| SRC-018 | [RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html) | Standard/regulator primary | 01, 05 |
| SRC-019 | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection) | Official primary/vendor documentation | 01 |
| SRC-020 | [PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html) | Official primary/vendor documentation | 01, 02, 05 |
| SRC-021 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17) | Official primary/vendor documentation | 01 |
| SRC-022 | [Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Official primary/vendor documentation | 01, 02, 04 |
| SRC-023 | [IETF Datatracker](https://datatracker.ietf.org/doc/html/rfc8446) | Standard/regulator primary | 01 |
| SRC-024 | [OpenTelemetry](https://opentelemetry.io/docs/specs/semconv/) | Official primary/vendor documentation | 01 |
| SRC-025 | [EDPB](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf) | Standard/regulator primary | 01 |
| SRC-026 | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/advanced-features-overview) | Official primary/vendor documentation | 01 |
| SRC-027 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/database-engine/service-broker/creating-service-broker-queues?view=sql-server-ver17) | Official primary/vendor documentation | 01 |
| SRC-028 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicebase?view=net-11.0-pp) | Official primary/vendor documentation | 01 |
| SRC-029 | [SQLite](https://www.sqlite.org/howtocorrupt.html) | Official primary/vendor documentation | 01 |
| SRC-030 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver17) | Official primary/vendor documentation | 01 |
| SRC-031 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/interactive-services) | Official primary/vendor documentation | 02 |
| SRC-032 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/extensions/windows-service) | Official primary/vendor documentation | 02 |
| SRC-033 | [blog.rust-lang.org](https://blog.rust-lang.org/releases/latest/) | Official ecosystem/release documentation | 02 |
| SRC-034 | [Go Packages](https://pkg.go.dev/plugin) | Official primary/vendor documentation | 02 |
| SRC-035 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights) | Official primary/vendor documentation | 02, 04 |
| SRC-036 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/) | Official primary/vendor documentation | 02 |
| SRC-037 | [SQLite](https://www.sqlite.org/changes.html) | Official primary/vendor documentation | 02 |
| SRC-038 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/) | Official primary/vendor documentation | 02 |
| SRC-039 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers) | Official primary/vendor documentation | 02, 03 |
| SRC-040 | [Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-10.0?view=aspnetcore-10.0) | Official primary/vendor documentation | 02 |
| SRC-041 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience) | Official primary/vendor documentation | 02 |
| SRC-042 | [Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/certauth?view=aspnetcore-10.0) | Official primary/vendor documentation | 02 |
| SRC-043 | [GitHub](https://github.com/wixtoolset/wix/releases/) | Official project repository/tool source; verify maintainer and release context | 02 |
| SRC-044 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/bits/background-intelligent-transfer-service-portal) | Official primary/vendor documentation | 02 |
| SRC-045 | [The Update Framework / theupdateframework.github.io](https://theupdateframework.github.io/specification/latest/) | Official primary/vendor documentation | 02, 03 |
| SRC-046 | [Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle?view=powershell-7.6) | Official primary/vendor documentation | 02 |
| SRC-047 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.jwtbearerextensions.addjwtbearer?view=aspnetcore-10.0) | Official primary/vendor documentation | 02 |
| SRC-048 | [RabbitMQ](https://www.rabbitmq.com/release-information) | Official primary/vendor documentation | 02 |
| SRC-049 | [PostgreSQL](https://www.postgresql.org/support/versioning/) | Official primary/vendor documentation | 02 |
| SRC-050 | [Npgsql](https://www.npgsql.org/doc/release-notes/10.0.html) | Official primary/vendor documentation | 02 |
| SRC-051 | [React](https://react.dev/blog/2025/10/01/react-19-2) | Official primary/vendor documentation | 02 |
| SRC-052 | [Node.js](https://nodejs.org/en/blog/vulnerability/july-2026-security-releases) | Official primary/vendor documentation | 02 |
| SRC-053 | [OpenTelemetry](https://opentelemetry.io/docs/languages/dotnet/) | Official primary/vendor documentation | 02 |
| SRC-054 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core) | Official primary/vendor documentation | 02 |
| SRC-055 | [Microsoft for Developers](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/) | Official ecosystem/release documentation | 02 |
| SRC-056 | [vitejs](https://vite.dev/blog/announcing-vite8-1) | Official primary/vendor documentation | 02 |
| SRC-057 | [Playwright](https://playwright.dev/docs/release-notes) | Official primary/vendor documentation | 02 |
| SRC-058 | [Go](https://go.dev/doc/devel/release) | Official primary/vendor documentation | 02 |
| SRC-059 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-enterprise-and-education) | Official primary/vendor documentation | 02 |
| SRC-060 | [NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/207/final) | Standard/regulator primary | 03 |
| SRC-061 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata) | Official primary/vendor documentation | 03 |
| SRC-062 | [in-toto](https://in-toto.io/docs/getting-started/) | Official primary/vendor documentation | 03 |
| SRC-063 | [RFC Editor](https://www.rfc-editor.org/rfc/rfc8705?utm_source=openai) | Standard/regulator primary | 03 |
| SRC-064 | [Microsoft Learn](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure) | Official primary/vendor documentation | 03 |
| SRC-065 | [RFC Editor](https://www.rfc-editor.org/rfc/rfc9449.pdf) | Standard/regulator primary | 03 |
| SRC-066 | [Microsoft Learn](https://learn.microsoft.com/en-us/intune/cloud-pki/) | Official primary/vendor documentation | 03 |
| SRC-067 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/apps/package-and-deploy/code-signing-options) | Official primary/vendor documentation | 03 |
| SRC-068 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/compatibility/networking/9.0/query-redaction-logs) | Official primary/vendor documentation | 03 |
| SRC-069 | [NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/88/r2/final) | Standard/regulator primary | 03 |
| SRC-070 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/extensions/data-redaction) | Official primary/vendor documentation | 03 |
| SRC-071 | [NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final) | Standard/regulator primary | 03 |
| SRC-072 | [Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/migrate-from-newtonsoft) | Official primary/vendor documentation | 03 |
| SRC-073 | [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng) | Standard/regulator primary | 03 |
| SRC-074 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype) | Official primary/vendor documentation | 04 |
| SRC-075 | [SQLite](https://sqlite.org/wal.html) | Official primary/vendor documentation | 04 |
| SRC-076 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/localservice-account) | Official primary/vendor documentation | 04 |
| SRC-077 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nc-winsvc-lphandler_function_ex) | Official primary/vendor documentation | 04 |
| SRC-078 | [Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/HEAD/docs/user_data_dir.md) | Official primary/vendor documentation | 04 |
| SRC-079 | [Mozilla Support](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data) | Official primary/vendor documentation | 04 |
| SRC-080 | [Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/master/components/history/core/browser/history_types.h) | Official primary/vendor documentation | 04 |
| SRC-081 | [SQLite](https://sqlite.org/backup.html) | Official primary/vendor documentation | 04 |
| SRC-082 | [Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/HEAD/base/time/time.h) | Official primary/vendor documentation | 04 |
| SRC-083 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid) | Official primary/vendor documentation | 04 |
| SRC-084 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/toolhelp/tool-help-functions) | Official primary/vendor documentation | 04 |
| SRC-085 | [SQLite](https://sqlite.org/rescode.html) | Official primary/vendor documentation | 04 |
| SRC-086 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-installation) | Official primary/vendor documentation | 04 |
| SRC-087 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-custom-actions) | Official primary/vendor documentation | 04 |
| SRC-088 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/msix/packaging-tool/convert-an-installer-with-services) | Official primary/vendor documentation | 04 |
| SRC-089 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust) | Official primary/vendor documentation | 04 |
| SRC-090 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-and-education) | Official primary/vendor documentation | 04 |
| SRC-091 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-home-and-pro) | Official primary/vendor documentation | 04 |
| SRC-092 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information) | Official primary/vendor documentation | 04 |
| SRC-093 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-ltsc-2024) | Official primary/vendor documentation | 04 |
| SRC-094 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/release-information) | Official primary/vendor documentation | 04 |
| SRC-095 | [Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2025) | Official primary/vendor documentation | 04 |
| SRC-096 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/windows-server-release-info) | Official primary/vendor documentation | 04 |
| SRC-097 | [Microsoft Learn](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies/userdatadir) | Official primary/vendor documentation | 04 |
| SRC-098 | [Microsoft Learn](https://learn.microsoft.com/en-us/fslogix/how-to-configure-profile-containers) | Official primary/vendor documentation | 04 |
| SRC-099 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsenumeratesessionsw) | Official primary/vendor documentation | 04 |
| SRC-100 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_failure_actionsa) | Official primary/vendor documentation | 04 |
| SRC-101 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/rstmgr/about-restart-manager) | Official primary/vendor documentation | 04 |
| SRC-102 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-changeserviceconfig2w) | Official primary/vendor documentation | 04 |
| SRC-103 | [Microsoft Learn](https://learn.microsoft.com/en-us/fslogix/reference-configuration-settings) | Official primary/vendor documentation | 04 |
| SRC-104 | [Microsoft Learn](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-version-26h1) | Official primary/vendor documentation | 04 |
| SRC-105 | [SQLite](https://sqlite.org/c3ref/wal_autocheckpoint.html) | Official primary/vendor documentation | 05 |
| SRC-106 | [PostgreSQL](https://www.postgresql.org/docs/current/functions-admin.html) | Official primary/vendor documentation | 05 |
| SRC-107 | [PostgreSQL](https://www.postgresql.org/docs/current/monitoring-stats.html) | Official primary/vendor documentation | 05 |
| SRC-108 | [PostgreSQL](https://www.postgresql.org/docs/current/app-pgverifybackup.html) | Official primary/vendor documentation | 05 |
| SRC-109 | [PostgreSQL](https://www.postgresql.org/docs/current/runtime-config-wal.html) | Official primary/vendor documentation | 05 |
| SRC-110 | [PostgreSQL](https://www.postgresql.org/docs/current/populate.html) | Official primary/vendor documentation | 05 |
| SRC-111 | [RabbitMQ](https://www.rabbitmq.com/docs/confirms) | Official primary/vendor documentation | 05 |
| SRC-112 | [Grafana Labs](https://grafana.com/docs/k6/latest/using-k6/scenarios/executors/constant-arrival-rate/) | Official primary/vendor documentation | 05 |
| SRC-113 | [GitHub](https://github.com/shopify/toxiproxy) | Official project repository/tool source; verify maintainer and release context | 05 |
| SRC-114 | [OpenTelemetry](https://opentelemetry.io/docs/specs/otel/metrics/api/) | Official primary/vendor documentation | 05 |
| SRC-115 | [PostgreSQL](https://www.postgresql.org/docs/current/sql-createindex.html) | Official primary/vendor documentation | 05 |
| SRC-116 | [PostgreSQL](https://www.postgresql.org/docs/current/brin.html) | Official primary/vendor documentation | 05 |
| SRC-117 | [PostgreSQL](https://www.postgresql.org/docs/current/routine-vacuuming.html) | Official primary/vendor documentation | 05 |
| SRC-118 | [PostgreSQL](https://www.postgresql.org/docs/current/sql-vacuum.html) | Official primary/vendor documentation | 05 |
| SRC-119 | [PostgreSQL](https://www.postgresql.org/docs/current/pgstatstatements.html) | Official primary/vendor documentation | 05 |
| SRC-120 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-objects/sys-dm-db-partition-stats-transact-sql?view=sql-server-ver17) | Official primary/vendor documentation | 05 |
| SRC-121 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/functions/datalength-transact-sql?view=sql-server-ver17) | Official primary/vendor documentation | 05 |
| SRC-122 | [Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-ver17) | Official primary/vendor documentation | 05 |
| SRC-123 | [NASA](https://www.nasa.gov/reference/4-2-technical-requirements-definition/) | Official primary/vendor documentation | 06 |
| SRC-124 | [EUR-Lex](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX%3A02016R0679-20160504) | Standard/regulator primary | 06 |
| SRC-125 | [NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/218/final) | Standard/regulator primary | 06 |
| SRC-126 | [NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/61/r3/final) | Standard/regulator primary | 06 |
| SRC-127 | [Microsoft Learn](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments) | Official primary/vendor documentation | 06 |
| SRC-128 | [Microsoft Learn](https://learn.microsoft.com/th-th/azure/cloud-adoption-framework/migrate/execute-migration) | Official primary/vendor documentation | 06 |


## Exact first ten actions

1. Appoint the accountable service owner and the named Product, Privacy/Legal, Security, Endpoint, Platform/SRE, Data, Records, Portal/IAM, Release, and Support owners in one signed decision record.
2. Approve or reject the first Browser History use case, prohibited uses, Edge-only slice, site/domain output, identity level, exact-time need, no-backfill default, pilot retention, access, notice, consultation, and DPIA disposition.
3. Freeze and hash the legacy policy, exclusions, application matches, checkpoints, portal/report definitions, script/schedule inventory, known defects, and external-consumer inventory for the comparison baseline.
4. Create the first ADR set for the three trust planes, endpoint process/identity model, privacy ceiling, local IPC, SQLite outbox/event-cursor invariant, device identity, wire/receipt semantics, update trust, and legacy coexistence.
5. Build G1 first: a LocalService coordinator, LUA Task Scheduler User Host, per-logon-SID named pipe, hostile IPC harness, and token/ProcMon evidence on the Windows VM.
6. Build G2 and G3 next: deterministic Edge profiles and visit generator, direct read-only plus online-backup acquisition, all-profile discovery, native-ID/source-generation cursor, and unsupported-schema fixtures.
7. Implement the endpoint privacy gate and million-record canary/fuzz suite before writing the production outbox or sending any live payload.
8. Implement the one-writer pinned-SQLite outbox and model-based G5 fault harness, including event/cursor atomicity, disk pressure, lost response, duplicate receipt, `quick_check`, and replay.
9. Instrument a 28-day metadata-only measurement on a representative approved cohort and build the stateful 6,000-agent simulator using the production serializer, compression, IDs, retry, and receipt code.
10. Run the PostgreSQL 18.4 versus SQL Server 2025 production-shaped benchmark, failover, restore, retention, report-concurrency, skills, and TCO gate; record the production database ADR before any broad pilot.
