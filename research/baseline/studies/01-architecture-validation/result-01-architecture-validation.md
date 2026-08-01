# UAM modernization architecture validation

**Review date:** 30 July 2026  
**Overall verdict:** **REVISE**  
**Confidence:** **High—approximately 90%** that the proposal needs the revisions below; **moderate—approximately 75%** that the provisional SQL Server/inbox choice will remain best after workload and operations measurements.

Terminology used below:

- **Fact** means directly supported by the supplied code or a primary source.

- **Assumption** means stated in the prompt or inferred and called out.

- **Recommendation** is the proposed design decision.

- **Unknown** requires measurement, prototype, legal decision, or operations input.

---

## 1. Executive verdict

The proposal has the right **architectural direction**, but it is **not a defensible production default as currently stated**.

Keep the following ideas:

- A managed .NET endpoint component instead of the large PowerShell process.

- No endpoint database credentials.

- A durable local transactional outbox.

- Idempotent HTTPS delivery.

- A durable central acceptance boundary followed by asynchronous processing.

- API-only portal and integrations.

- Process isolation for failure-prone collectors.

Revise the following material decisions:

1. **A machine Windows Service cannot be the sole collector.** Services execute in Session 0, while today’s browser, recent-item, and process behavior is explicitly tied to each interactive user’s profile and session. A per-interactive-session user host is required. Microsoft documents that Session 0 is reserved for services, and a service may run without—or as a different identity from—the logged-on user. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))

2. **“Signed tasks” are not a safe execution model by themselves.** Signing authenticates the publisher; it does not make code least-privileged or harmless. The supplied agent currently executes database-supplied PowerShell via `Invoke-Expression`, and the database contains script code. That capability must not be reproduced in the new agent. `AssemblyLoadContext` provides dependency-loading isolation, explicitly not security, and Microsoft recommends an OS/process boundary for untrusted or failure-prone plugins. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support "https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support"))

3. **“Signed update” is not an update protocol.** It does not by itself address rollback, freeze, stale metadata, key rotation, compromised online keys, bad-version suppression, updater recovery, or authorized emergency downgrade. TUF 1.0.35 explicitly addresses these classes of update attack and separates metadata roles and keys. ([GitHub](https://github.com/theupdateframework/specification/blob/master/tuf-spec.md "https://github.com/theupdateframework/specification/blob/master/tuf-spec.md"))

4. **An external message broker is not justified merely by 6,000 endpoints.** The requirement is a durable acceptance boundary, replay, leases, poison handling, and independent workers. A transactional SQL inbox can provide those at this scale while eliminating an API-to-broker/database dual-write and another production subsystem.

5. **PostgreSQL should not be selected by architecture fashion.** PostgreSQL 18 is credible, but the current estate, schema, administration code, and apparent organizational experience are SQL Server-heavy. SQL Server 2025 is the lower-transition-risk provisional default unless a benchmark, skills assessment, licensing analysis, or strategic platform standard favors PostgreSQL. Both support partitioning and high-throughput load mechanisms. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

6. **Control, data, and software-release authority need three distinct trust planes.** The portal must not be able to sign executable collector code. A compromised tenant administrator must not be able to expand collection beyond a separately approved privacy ceiling.

7. **Acknowledgement and disaster recovery are coupled.** Once an endpoint deletes an acknowledged event, a later central restore must not lose that event. Either acknowledged commits need effectively zero-RPO replication, or endpoints must retain acknowledged payloads beyond the central RPO and recovery/replay interval.

### Approval position

I would approve **architecture prototyping**, but not production implementation, until these five gates pass:

- Multi-session user-host design.

- Atomic event-plus-source-cursor fault testing.

- Update rollback/key-compromise/updater-repair drills.

- 6,000-device reconnect and central inbox benchmark.

- Full privacy-deletion-and-restore exercise.

The remaining risks are not eliminated. The design contains them through privilege separation, durable boundaries, idempotency, explicit terminal states, independently verifiable audit, and recovery paths.

---

## 2. Findings from the supplied code

I read the introduction and inspected the endpoint, PowerShell Universal application, and schema rather than treating the summary as a design specification. The attachment itself correctly says that the code is evidence of current behavior, not a secure design specification.

| Code observation — fact                                                                                                                                                                                    | Architectural consequence                                                                                                                                                                                                                                                  |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Browser discovery uses the current user’s `%APPDATA%` and `%LOCALAPPDATA%`; recent-item collection uses the current user’s Recent folder; process collection filters by the current process’s `SessionId`. | The functional unit is a **user session**, not merely a machine. Moving everything into Session 0 would change behavior and mishandle multi-user/RDS devices.                                                                                                              |
| The endpoint receives or locally decrypts an MSSQL connection string. A fixed key is embedded in the script for `DbSettings.txt`.                                                                          | Direct database credentials and homemade local secret protection must be removed.                                                                                                                                                                                          |
| SQL is constructed as strings, placed in memory or CSV, and replayed later.                                                                                                                                | The deferred artifact is executable SQL, not a typed event. It is hard to validate, version, deduplicate, audit, migrate, or safely replay.                                                                                                                                |
| Browser, recent-file, and process checkpoints are represented as database updates alongside deferred SQL, while in-memory checkpoints are also advanced.                                                   | A crash, failed CSV write, CSV deletion, or partial replay can cause gaps or duplicates. Typed events and their source cursor must commit atomically in one local transaction.                                                                                             |
| One deferred-processing failure path removes the CSV and restarts the process.                                                                                                                             | There is an explicit silent-data-loss path.                                                                                                                                                                                                                                |
| Browser database files are copied with a wildcard, including possible side files, while the browser may still be writing.                                                                                  | Main SQLite files and WAL state can be mismatched. SQLite states that a WAL file is part of persistent database state and separating it can lose committed transactions or corrupt the copy. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html")) |
| `Invoke-Expression` executes `PSCode` obtained from database settings. `DeviceScripts` stores script code.                                                                                                 | The legacy control database can act as a remote code-execution authority. This must not survive as “signed tasks” fetched or generated by the portal.                                                                                                                      |
| PowerShell Universal directly issues SQL updates/deletes and changes AD group membership. Some audit inserts use `SilentlyContinue` or empty catches after the mutation.                                   | A successful administrative mutation can occur without a corresponding audit record. Mutation and audit must be one transaction.                                                                                                                                           |
| `ActionLog` is a normal mutable table.                                                                                                                                                                     | It is an operational history, not a tamper-evident administrative audit trail.                                                                                                                                                                                             |
| Event tables have no stable per-event identifiers or tenant identifiers.                                                                                                                                   | Durable event-level idempotency, tenant isolation, replay, and precise deletion cannot be added safely without a new event model.                                                                                                                                          |
| The portal loads some web assets from public CDNs at runtime.                                                                                                                                              | The new administrative portal should bundle and pin assets and enforce a restrictive Content Security Policy rather than extending its runtime supply chain to third parties.                                                                                              |
| The current process collector takes snapshots of running processes and compares start times.                                                                                                               | It can miss short-lived processes. “Process event” completeness must be defined and measured; polling is not an event stream.                                                                                                                                              |
| Browser discovery generally selects a successful/newest profile database.                                                                                                                                  | Multiple browser profiles and multiple concurrent users need explicit enumeration and ownership rules.                                                                                                                                                                     |

The modernization should preserve observed business behavior only where that behavior is intentional. It should not preserve implementation artifacts such as dynamic SQL, restart-based memory management, mutable server-supplied code, username/computer-name identity, or CSV recovery.

---

# 3. Recommended architecture

## 3.1 Architectural position

Use three independently controlled planes:

1. **Release plane:** signs and publishes software and collector artifacts.

2. **Control plane:** manages devices, collection policies, privacy-narrowing rules, schedules, retention, and integrations.

3. **Data plane:** accepts and processes already-filtered telemetry.

The release plane must not be callable by the portal. The control plane can disable collection or narrow policy, but cannot authorize data fields or executable capabilities beyond a separately signed product privacy ceiling.

## 3.2 Endpoint process model

### Machine service

Run a small Windows Service under **LocalService or a virtual service account with a service SID and an explicit required-privilege list**, not LocalSystem by default. Microsoft supports service SIDs, privilege removal, SCM recovery, and network restrictions to run services without broad machine authority. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))

The machine service owns:

- Device identity and certificate renewal.

- The machine-wide SQLite outbox.

- Local durable source cursors.

- Network transport.

- Rate limiting and retry state.

- Signed policy and package caches.

- Session-host registration and authenticated named-pipe endpoints.

- Health, update state, and non-PII diagnostics.

It does **not** directly crawl arbitrary user profiles.

### Per-session user host

Install an “at logon of any user” scheduled task that starts `UAM.UserHost.exe` with the interactive user’s actual token at `LIMITED` run level. Scheduled tasks can run at the ordinary user privilege level, while using `WTSQueryUserToken` from a service would force the service to run as LocalSystem with `SE_TCB_NAME`, which Microsoft describes as intended for highly trusted services. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken"))

There is one host per eligible interactive session. It owns:

- Discovery of that user’s approved browser profiles.

- Access to that user’s Recent items.

- Session-local process collection.

- Launch and supervision of taskhost children.

- The authoritative endpoint privacy gate.

- Delivery of filtered canonical records to the machine service over authenticated local IPC.

A service that merely impersonates a user does not automatically obtain the normal loaded user profile; loading profiles from a service also adds elevated privilege and lifecycle complexity. That is another reason to prefer a genuine interactive-session process. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-loaduserprofilea "https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-loaduserprofilea"))

### Taskhost processes

Run each risky collector invocation in a fresh or short-lived `UAM.TaskHost.exe` process:

- Start from the interactive user token.

- Create a restricted token with unnecessary privileges and SIDs removed.

- Place it in a Job Object with process-count, CPU, memory, wall-clock, and child-process limits.

- Disallow job breakaway.

- Deny network access.

- Give it read access only to the approved source paths and a private ephemeral working directory.

- Do not give it access to the central certificate, machine outbox, updater state, or service-private directories.

- Kill the entire job on timeout, user logoff, or host failure.

Restricted tokens can remove privileges and apply restricting SIDs, while Job Objects can constrain and terminate a whole child process tree. AppContainer adds stronger default-deny file, process, credential, and network isolation, but browser-profile access from AppContainer must be prototyped because it may require carefully brokered ACLs. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects"))

`AssemblyLoadContext` may still be used **inside a disposable taskhost** for dependency resolution, but it is not a reliability or security boundary and is unnecessary when each task gets its own process.

## 3.3 Privacy architecture

Define two policy layers:

1. **Product privacy ceiling:** part of a security-reviewed signed release. It defines the maximum source types, output fields, normalization rules, and collector capabilities that any tenant can enable.

2. **Tenant policy:** signed, versioned, expiring configuration that can only narrow the ceiling—for example, allowed browsers, domain filtering, process fields, schedules, and retention class.

The stable user host—not task code—must apply the final filter before any event:

- Is written to local durable storage.

- Is sent to the machine service.

- Is placed in a diagnostic log.

- Is included in a crash dump.

- Is emitted as a metric label.

The taskhost can temporarily see source data needed to parse the approved source, but it has no network and no outbox access. Only the stable user host is allowed to talk to the service pipe.

A missing, invalid, revoked, or expired privacy policy should be **fail-closed for new collection**. Transport of already-approved queued events and health status may continue.

No centrally authored arbitrary PowerShell, C#, SQL, or script body should execute on endpoints by default.

## 3.4 Local transactional outbox

Use one machine-wide SQLite database on local NTFS under `%ProgramData%\UAM`, ACLed to the service SID. Do not place it in a roaming profile, network share, user-writable directory, or temporary directory.

Recommended baseline:

- `journal_mode=WAL`

- `synchronous=FULL`

- `foreign_keys=ON`

- `busy_timeout` explicitly configured

- SQLite defensive mode where supported

- One application writer

- Short-lived read transactions

- Monitored WAL size and checkpoint result

- `max_page_count` plus independent free-disk limits

- Periodic `quick_check`

- Schema migrations that are additive and backward-compatible across at least N/N-1 agent versions

SQLite documents that WAL commits append to the WAL, that checkpointing is a separate operation, and that passive checkpoints may not complete while readers are present. It also documents that `synchronous=NORMAL` in WAL mode remains consistent but can lose the last committed transactions after power loss, whereas `FULL` adds a WAL sync after each transaction. For an endpoint outbox whose purpose is surviving power loss, `FULL` is the defensible default unless a measured performance test supports an explicit loss budget. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html"))

### Atomic collection invariant

For each source scan, the machine service commits in one transaction:

```text
zero or more approved canonical events
+ new opaque source cursor/high-water mark
+ next per-stream sequence value
+ policy version and collector version
+ scan outcome metadata
```

This matters even when every source row is excluded: the scan cursor still has to advance so the same excluded records are not reread forever.

Use source-specific compound cursors rather than timestamp-only cursors:

- Browser history: source visit row ID plus source timestamp.

- Recent items: stable file/link identity plus timestamp, with an overlap window.

- Process events: boot ID plus process creation identity, not PID alone.

- Any timestamp cursor: include a deterministic tie-breaker.

Recommended event identity:

- `event_id`: UUIDv7 for traceability and locality-friendly indexing.

- Authoritative idempotency tuple:  
  `{device_id, enrollment_epoch, stream_id, sequence}`.

- `batch_id`: UUIDv7.

- A repeated `batch_id` with a different body hash is a conflict/security event, not a duplicate success.

UUIDv7 is standardized in RFC 9562 and is time ordered, but it should not replace explicit per-stream sequencing. ([RFC Editor](https://www.rfc-editor.org/info/rfc9562/ "https://www.rfc-editor.org/info/rfc9562/"))

### Cleanup and outage behavior

Delete only terminal events:

- Centrally accepted, or

- Explicitly and permanently rejected per event.

Keep accepted payloads locally for a bounded replay grace period longer than the central RPO plus detection and restore interval. This is required to recover centrally acknowledged data after a point-in-time restore.

Do not silently discard the oldest unacknowledged events when the quota fills. The default behavior should be:

1. Continue transport.

2. Stop new collection before the device disk is endangered.

3. Emit a privacy-safe critical health status.

4. Resume only after capacity is available.

An optional lossy mode may exist only as an explicit tenant policy with documented priority classes and loss accounting.

SQLite is resistant to corruption, but its own documentation states it is not immune and cannot stop another process from overwriting the file. On detected corruption, preserve the database, WAL, and SHM as a set, create a new enrollment/outbox epoch only under a recorded recovery workflow, attempt offline recovery, and rescan sources with overlap where possible. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))

### Local encryption

SQLite core does not provide transparent database encryption. SQLite’s official SEE is a separate licensed extension, and even it leaves data plaintext in process memory. ([SQLite](https://www.sqlite.org/see/doc/trunk/www/readme.wiki "https://www.sqlite.org/see/doc/trunk/www/readme.wiki"))

Defensible baseline:

- Enforce BitLocker or equivalent full-volume encryption.

- Service-SID ACLs.

- No raw event content in logs.

- Disable ordinary-user access to service storage.

- Encrypt especially sensitive payload columns with a TPM-sealed device key only if the threat model justifies the operational complexity.

This contains lost-disk and ordinary-user exposure. It does not protect plaintext from a compromised kernel or a local administrator controlling the running machine; that remains a residual endpoint risk.

## 3.5 Update and bootstrap ownership

### Default for a managed enterprise fleet

Use a signed MSI and the existing endpoint-management platform—such as Intune, Configuration Manager, or equivalent—to own installation, core service upgrades, repair, and uninstall.

Keep the bootstrap/repair layer small and slow-changing. Let the service update only nonprivileged, versioned worker and collector packages.

This is safer and simpler than inventing a second privileged software-deployment system.

### When autonomous self-update is a hard requirement

Add a minimal privileged maintenance component, separate from collection and transport, that:

- Does not parse collector event content.

- Does not accept arbitrary paths or command lines from the portal.

- Installs only repository-authorized packages.

- Can be repaired out-of-band by MSI.

- Retains the previous compatible versions.

- Maintains an append-only update journal.

Use TUF-style repository metadata:

- Offline threshold root keys.

- Separate targets, snapshot, and online timestamp keys.

- Delegated targets by component or release channel.

- Metadata expiry.

- Monotonic metadata versions.

- Persisted highest-seen versions.

- A separately authorized emergency downgrade role.

- Signed minimum-supported-version policy.

- Hash and length verification before content is exposed to the installer.

TUF’s current specification explicitly addresses rollback, freeze, mix-and-match, fast-forward, key-compromise, and wrong-file attacks, while also noting that it secures acquisition and verification, not the application-specific file switch itself. ([GitHub](https://github.com/theupdateframework/specification/blob/master/tuf-spec.md "https://github.com/theupdateframework/specification/blob/master/tuf-spec.md"))

Also Authenticode-sign and RFC 3161 timestamp executable files. Authenticode supplies authorship and integrity and keeps a correctly timestamped signature verifiable after certificate expiry, but it is an additional check—not the rollback protocol. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccrypto/time-stamping-authenticode-signatures "https://learn.microsoft.com/en-us/windows/win32/seccrypto/time-stamping-authenticode-signatures"))

### Safe switch and rollback

Use:

```text
packages/
  <component>/<version>/<content-hash>/...
state/
  current.json
  previous.json
  update-journal
```

Never update an executing binary in place.

The stable supervisor selects an immutable candidate directory. A candidate must prove:

- Signature and repository authorization.

- Local database schema compatibility.

- Policy compatibility.

- IPC compatibility with user hosts.

- Ability to start all enabled collectors.

- Ability to authenticate to the service/API.

- Survival through a probation interval.

- No material crash or privacy-filter error regression.

Only then switch the small version pointer. Retain at least two previous compatible versions.

Do not assume one Windows file replacement call makes the process infallibly atomic: `ReplaceFileW` documents multiple partial failure states, and its write-through flag is unsupported. Use a recovery journal plus immutable directories so startup can deterministically choose the last complete version. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew "https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew"))

A failed version is quarantined until a newer release or explicit operator override. Do not alternate indefinitely between two versions. Do not perform irreversible outbox schema migration before candidate health proof.

## 3.6 Device identity and HTTPS protocol

Use mTLS:

- One stable logical `device_id`.

- One `enrollment_epoch` per reinstall, database reset, or clone-safe enrollment.

- Renewable device certificate in the LocalMachine store.

- Nonexportable TPM-backed key where available.

- Software-key fallback only under an explicit assurance policy.

- Short-lived, one-time enrollment authorization bound to the tenant.

- Server-side certificate-to-device-to-tenant registry.

TPM-attested keys provide higher assurance through nonexportability and hardware isolation, although availability and CA deployment model must be validated. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation"))

Never trust `tenant_id`, `device_id`, or a certificate subject string supplied in the event body. Derive the authoritative tenant and device from authenticated certificate registration and compare body identifiers only as consistency checks.

For nonpersistent VDI:

- Never bake a device certificate or enrollment token into the golden image.

- Enroll after clone specialization.

- Model either each clone lifetime as an enrollment epoch or define a separate logical pool identity with session-level streams.

- Revoke or expire stale clone identities.

- Rate-limit staged enrollment.

Microsoft’s VDI identity guidance documents stale-identity accumulation and registration throttling in nonpersistent deployments, so this cannot be left to ordinary desktop enrollment behavior. ([Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure "https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure"))

### Wire contract

Use a versioned canonical envelope. Strict JSON plus gzip is adequate at this scale and easier to inspect; protobuf is reasonable only if the bandwidth/CPU prototype shows a material advantage.

A batch should include:

```text
protocol_version
batch_id
device_id assertion
enrollment_epoch
agent/version and policy/version
created_at and boot_id
ordered event envelopes:
    event_id
    stream_id
    sequence
    event_type
    schema_version
    occurred_at
    payload
body_sha256
```

Protocol behavior:

- Hash the exact uncompressed canonical batch bytes or the exact transmitted bytes; specify one and test it.

- Compress only above a measured threshold.

- Bound compressed size, decompressed size, event count, string lengths, nesting, and per-event processing time.

- Reject unsupported encodings.

- Parse and validate events independently after the outer envelope is valid.

- Return terminal status per event.

- Treat a permanent rejection as terminal for contiguous acknowledgement so one poison event cannot block all later events.

- Support N, N-1, and N-2 endpoint protocol versions during staged rollout.

- Reserve removed field numbers/names if protobuf is chosen; its official guidance warns that reuse can cause ambiguity, PII leakage, and corruption. ([Protocol Buffers](https://protobuf.dev/programming-guides/proto3/ "https://protobuf.dev/programming-guides/proto3/"))

ASP.NET Core’s decompression guidance explicitly requires a decompressed request limit to contain zip/decompression bombs. ([Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0"))

### Retry and rate behavior

HTTP POST is not inherently safe to retry. RFC 9110 says a client should not automatically retry a non-idempotent request unless the application makes the semantics idempotent or knows the first request was not applied. Event-level idempotency is therefore mandatory, not an optimization. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html "https://www.rfc-editor.org/rfc/rfc9110.html"))

Use:

- Connect, TLS, request, and total-operation timeouts separately.

- Exponential backoff with full jitter.

- Stable startup spread derived from device identity plus random jitter.

- Per-device token bucket.

- Server `Retry-After`.

- Retry budgets.

- Backpressure based on oldest outbox age and central backlog.

- No tight retry after certificate or permanent-schema errors.

- Batch splitting after `413`.

- Per-event quarantine after permanent rejection.

Do not rely on broker duplicate detection as endpoint idempotency. Azure Service Bus, for example, retains duplicate IDs for at most seven days, which is shorter than a credible long-outage/recovery horizon. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection "https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection"))

## 3.7 Central durable acceptance: SQL inbox by default

Use a transactional central inbox rather than an external broker initially.

The ingestion API performs one database transaction:

1. Resolve certificate to tenant/device.

2. Validate enrollment status, protocol, policy floor, size, and schema.

3. Insert or retrieve the `ingestion_batch` receipt.

4. Insert event idempotency keys.

5. Insert accepted canonical events into `event_inbox`.

6. Record permanent per-event rejections.

7. Commit.

8. Return the durable terminal response.

A success response means **durably committed centrally**, not “queued in memory” or “validation started.”

Suggested central tables:

```text
device_registration
device_certificate
ingestion_batch
event_key                  -- authoritative dedup/tombstone key
event_inbox                -- validated canonical event + processing lease
event_fact_browser
event_fact_recent_item
event_fact_process
device_health
integration_outbox
deletion_tombstone
admin_audit
```

Workers atomically claim inbox rows using a lease and skip-locked/read-past pattern. PostgreSQL explicitly documents `SKIP LOCKED` for multiple consumers of a queue-like table; SQL Server can implement an equivalent lease claim or use Service Broker if the team already operates it. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html "https://www.postgresql.org/docs/current/sql-select.html"))

Worker materialization must be idempotent. Prefer either:

- Materialize and mark complete in one database transaction, or

- Insert normalized data under the unique event key, then safely reclaim expired leases.

### When to add a separate broker

Add Azure Service Bus, RabbitMQ quorum queues, Kafka, or another broker only when a prototype demonstrates one or more of these requirements:

- The ingestion API must accept data while the primary relational database is deliberately unavailable.

- Several independent consumers require long replay and fan-out.

- Multi-region active ingestion is required.

- Reconnect throughput materially exceeds safe database write capacity.

- Backlog retention is longer or larger than the relational inbox can economically support.

- An existing platform team already operates the broker to an agreed SLO.

At that point, the broker should become the **sole durable acceptance record** for the API request; do not add an uncontrolled queue-plus-database dual-write.

## 3.8 Database recommendation

### Provisional default: SQL Server 2025

Reasons:

- The current schema, application, procedures, and staff workflows appear SQL Server-centric.

- Migration can focus first on security and delivery correctness rather than simultaneously replacing the database operating model.

- `SqlBulkCopy`, table-valued parameters, partitioning, RLS, Always On/PITR options, and Ledger are credible for this workload.

- The new API and canonical model can remain database-portable.

This is an inference from the supplied material, not proof that the team can operate the new design.

### PostgreSQL 18 remains a first-class alternative

Choose PostgreSQL when:

- It is an organizational platform standard.

- The on-call team demonstrates restore, failover, vacuum, replication, partition, and upgrade competence.

- Licensing/TCO materially favors it.

- The benchmark shows equal or better ingest and reporting behavior.

- Portability away from the Microsoft stack is a strategic requirement.

### Partitioning

Do not treat partitioning as an automatic performance feature.

Use:

- A small nonpartitioned or separately partitioned `event_key` table for global idempotency.

- Monthly event-fact partitions only after volume/retention measurements justify them.

- Precreated future partitions with monitoring.

- Server `received_at` as the operational partition key unless legal retention requires another model.

- `occurred_at` retained and indexed separately.

- Archive/rollup on partition detach/switch.

- Reporting replicas, columnar archives, or a warehouse for heavy analytics.

PostgreSQL documents that an insert with no matching partition fails and that cross-partition uniqueness requires the partition key in the unique constraint. It also documents rapid retention by dropping/detaching partitions. SQL Server characterizes partitioning primarily as a manageability and performance facility for large tables. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))

## 3.9 Control plane, portal, audit, and integrations

### Control plane

Separate from ingestion by:

- Hostname and network policy.

- Workload identity.

- Database role/schema.

- deployment pool.

- rate limits.

- secrets.

- authorization model.

- monitoring and incident procedures.

The control plane publishes versioned signed configuration snapshots. Endpoints cache the last-known-good snapshot until expiry. Control-plane failure must not stop delivery of already-collected events.

Privacy-expanding policy changes require:

- Two-person approval.

- A machine-readable diff.

- A reason/ticket.

- Effective and expiry times.

- Compatibility validation.

- Transactional audit.

- Optional canary scope.

### Portal

The portal:

- Uses OIDC and MFA.

- Calls only the control/query APIs.

- Has no direct database credentials.

- Uses tenant-scoped RBAC/ABAC.

- Bundles web assets and enforces CSP.

- Does not use dirty-read hints as a substitute for read models.

- Cannot publish executable code or sign releases.

- Cannot complete an administrative mutation unless its audit record commits.

### Audit

For every administrative change, store in the same transaction:

- Actor and authenticated principal.

- Tenant and delegated scope.

- Request/correlation ID.

- Before/after canonical values or a precise field diff.

- Reason/ticket.

- Approval identity where required.

- Timestamp and result.

- Source IP/client context.

- Policy/release version affected.

Use an append-only/tamper-evident audit mechanism, plus external immutable digests or exports. SQL Server Ledger can cryptographically chain rows and publish database digests to external tamper-resistant storage, but its own documentation notes that a machine-controlling administrator can still tamper with files; external digest verification is what detects this. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17"))

### Customer-independent integrations

Publish integrations from a per-tenant **integration outbox**, not from the portal and not through direct database access.

Each connector has:

- A versioned canonical event contract.

- Per-tenant credentials in a vault.

- Independent retry, rate, and circuit state.

- Delivery idempotency key.

- Dead-letter state.

- Backfill/replay authorization.

- Deletion propagation.

- Customer-visible delivery health.

- No ability to block core ingestion/materialization.

---

## 3.10 Text data-flow diagram

```text
                            RELEASE PLANE
   Offline threshold root keys / HSM-backed release process
            |
            +--> TUF-style signed metadata
            +--> Authenticode + RFC3161-signed MSI/bundles
            |
   Enterprise endpoint management / out-of-band MSI repair
            |
            v
+------------------------------------------------------------------+
|                         WINDOWS DEVICE                            |
|                                                                  |
|  Stable installation / repair boundary                           |
|       |                                                          |
|       +--> UAM Machine Service                                   |
|       |      identity: LocalService or virtual service account    |
|       |      service SID; narrow required privileges              |
|       |                                                          |
|       |      +--> device cert / enrollment epoch                  |
|       |      +--> signed policy and package cache                 |
|       |      +--> single-writer SQLite WAL outbox                 |
|       |      +--> HTTPS transport / retry / rate control          |
|       |                                                          |
|  Logon task, once per eligible interactive session               |
|       |                                                          |
|       +--> UAM User Host -- actual user token, non-elevated       |
|              |                                                   |
|              +--> TaskHost(browser) -- restricted token/job      |
|              +--> TaskHost(recent)  -- restricted token/job      |
|              +--> TaskHost(process) -- restricted token/job      |
|              |        no network; no outbox access               |
|              |                                                   |
|              +--> product privacy ceiling                        |
|              +--> tenant policy that may only narrow             |
|              +--> canonical schema validation                    |
|              |                                                   |
|              +--> authenticated named pipe                       |
|                       filtered events + source cursor             |
|                              |                                   |
|                              v                                   |
|                   SQLite transaction:                            |
|                   event(s) + cursor + sequence                    |
+------------------------------|-----------------------------------+
                               |
                   gzip above measured threshold
                   mTLS HTTPS, bounded batches
                   full-jitter retry and token bucket
                               |
                               v
+------------------------------------------------------------------+
|                           DATA PLANE                             |
|                                                                  |
|  WAF / load balancer                                             |
|         |                                                        |
|         v                                                        |
|  Ingestion API                                                   |
|    certificate -> registered device -> authoritative tenant      |
|         |                                                        |
|         v                                                        |
|  ONE CENTRAL SQL TRANSACTION                                     |
|    batch receipt + event dedup keys + validated inbox events     |
|         |                                                        |
|         +------------------> durable per-event ACK                |
|         |                                                        |
|         v                                                        |
|  Leased inbox workers                                            |
|         |                                                        |
|         +--> normalized event facts / device health              |
|         +--> integration outbox                                  |
|         +--> retention/archive/rollups                           |
|         +--> non-PII OpenTelemetry signals                       |
+------------------------------------------------------------------+

+------------------------------------------------------------------+
|                         CONTROL PLANE                            |
|                                                                  |
|  Modern portal --> Control API --> tenant/device/policy state     |
|                                      |                           |
|                                      +--> signed config snapshot |
|                                      +--> transactional audit    |
|                                                                  |
|  No endpoint DB credentials                                      |
|  No portal DB credentials                                        |
|  No portal authority to sign executable releases                 |
+------------------------------------------------------------------+
```

## 3.11 Non-negotiable invariants

1. No value rejected by the privacy policy reaches durable endpoint storage, endpoint logs, or the network.

2. Source cursor advancement and insertion of its resulting events occur in the same SQLite transaction.

3. Server success means a durable central commit.

4. Tenant identity comes from authenticated device registration, not payload.

5. Taskhost cannot access the network, device certificate, or outbox.

6. An event’s terminal server result is idempotent for the full replay horizon.

7. A poison event cannot block later events in the same stream.

8. Administrative mutation and audit commit together.

9. A restored central system applies deletion tombstones before serving data.

10. A bad update version is suppressed rather than retried indefinitely.

11. No control-plane administrator can exceed the product privacy ceiling.

12. No customer integration receives central database credentials.

---

# 4. Component decision table

| Component             | Proposed choice                   | Verdict                      | Recommended choice                                                                                     | Reason and evidence                                                                                                                                                                                                                                                                                                                                         | Validation needed                                                         |
| --------------------- | --------------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Core installer        | Signed bootstrapper               | **Revise**                   | Signed MSI owned by endpoint management; bootstrap only for install/repair                             | Reduces privileged custom updater code and preserves an out-of-band repair route                                                                                                                                                                                                                                                                            | Inventory Intune/ConfigMgr/other coverage and offline estates             |
| Autonomous updater    | Implied self-update               | **Conditional**              | Add only if common enterprise deployment cannot meet patch SLO; use minimal maintenance component      | Signing alone does not address update-system attacks; TUF does not itself perform the local switch. ([GitHub](https://github.com/theupdateframework/specification/blob/master/tuf-spec.md "https://github.com/theupdateframework/specification/blob/master/tuf-spec.md"))                                                                                   | Patch-latency requirement; repair drill                                   |
| Runtime               | .NET Service                      | **Keep with condition**      | .NET 10 LTS, latest patch, where supported by endpoint OS baseline                                     | .NET 10.0.10 was current on 14 July 2026 and is supported to 14 November 2028. Framework-dependent deployments receive Microsoft servicing; self-contained deployments own runtime patching. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core")) | OS support matrix; framework-dependent versus self-contained package test |
| Machine process       | One Windows Service               | **Reject as sole collector** | Low-privilege machine service plus one user host per eligible session                                  | Session 0 is isolated from interactive users. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))                                                                                                  | Windows 10/11, RDS, Citrix, FSLogix and VDI lab                           |
| Service identity      | Unspecified                       | **Revise**                   | LocalService or virtual account, service SID, explicit required privileges                             | Microsoft supports service isolation and privilege stripping without LocalSystem. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))                                                              | Privilege-access matrix and Windows firewall test                         |
| User-process launch   | Service likely launches tasks     | **Revise**                   | LIMITED scheduled task at interactive logon                                                            | Avoids LocalSystem plus `SE_TCB_NAME` required by `WTSQueryUserToken`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken"))                                                                         | Logon/logoff, fast-user-switch, disconnected RDS test                     |
| Collector packaging   | Signed collector tasks            | **Revise**                   | Release-built, signed, hash-authorized capability-specific bundles; no tenant-authored executable code | Signed code can still misuse all privileges it receives                                                                                                                                                                                                                                                                                                     | Release pipeline and malicious-signed-task exercise                       |
| Privacy authority     | Not fully specified               | **Missing**                  | Stable user-host privacy ceiling plus signed tenant-narrowing policy                                   | Prevents a task or compromised tenant admin from expanding collection                                                                                                                                                                                                                                                                                       | Golden corpus, policy monotonicity, expiry and emergency disable tests    |
| `AssemblyLoadContext` | Possible task boundary            | **Reject as boundary**       | Process per risky invocation; ALC only inside disposable taskhost if useful                            | ALC is assembly-loading isolation and provides no security. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support "https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support"))                                                                                        | Measure process-start overhead before adding pooling                      |
| Task reliability      | Separate `taskhost`               | **Keep and strengthen**      | Restricted token, Job Object, no breakaway, no network, wall-time/CPU/RAM limits                       | OS process boundaries contain hangs, native crashes, and process trees. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects"))                                                                                                                | Hostile task suite and child-process escape tests                         |
| Browser access        | Collector reads profile DB        | **Revise**                   | Per-session, read-only access; test SQLite backup/read strategy; enumerate approved profiles           | Raw wildcard copy can mismatch database/WAL state. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html"))                                                                                                                                                                                                                            | Live Chrome/Edge/Firefox writes, schema upgrades, multiple profiles       |
| Process collection    | Process events                    | **Unknown mechanism**        | Keep polling only if best-effort is acceptable; otherwise prototype ETW/WMI source                     | Current snapshot model misses short processes                                                                                                                                                                                                                                                                                                               | Synthetic process ground-truth test                                       |
| Local outbox          | SQLite WAL                        | **Keep**                     | One writer, local NTFS, WAL, `synchronous=FULL`, bounded short transactions                            | WAL is suitable, but durability and checkpoint settings are material. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html"))                                                                                                                                                                                                         | Power-cut, filesystem, antivirus and contention test                      |
| Cursor/checkpoint     | Implied outbox transaction        | **Strengthen**               | Event rows, source cursor, sequence, and scan metadata in one transaction                              | Prevents the legacy CSV/checkpoint gap                                                                                                                                                                                                                                                                                                                      | Fault injection at every commit boundary                                  |
| SQLite quota          | Not specified                     | **Missing**                  | `max_page_count`, free-disk reserve, outbox-age budget, stop-collection behavior                       | SQLite exposes a database page cap; disk full remains an application concern. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))                                                                                                                                                                                                   | 30/60/90-day modeled outage                                               |
| SQLite cleanup        | Not specified                     | **Missing**                  | Chunk terminal-row deletion; page reuse; deliberate checkpoints; no routine full VACUUM                | Avoids long locks and uncontrolled WAL growth                                                                                                                                                                                                                                                                                                               | Long-running reader and cleanup load test                                 |
| Local encryption      | Implicit/unspecified              | **Revise**                   | BitLocker + service ACL baseline; optional TPM-sealed payload encryption                               | SQLite core is not encrypted; encrypted SQLite is still plaintext in memory. ([SQLite](https://www.sqlite.org/see/doc/trunk/www/readme.wiki "https://www.sqlite.org/see/doc/trunk/www/readme.wiki"))                                                                                                                                                        | Threat model and support-cost test                                        |
| Corruption recovery   | Not specified                     | **Missing**                  | `quick_check`, preserve DB/WAL/SHM, offline recovery, new epoch only under workflow                    | SQLite is resistant but not immune to corruption. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))                                                                                                                                                                                                                               | Bit-flip, truncation, rogue writer and stale-WAL tests                    |
| Device identity       | HTTPS device identity unspecified | **Revise**                   | mTLS certificate mapped server-side to tenant/device; TPM-backed key where available                   | TLS supports client certificate authentication; TPM attestation raises assurance. ([IETF Datatracker](https://datatracker.ietf.org/doc/html/rfc8446 "https://datatracker.ietf.org/doc/html/rfc8446"))                                                                                                                                                       | Cert renewal, revocation, TPM reset, software fallback                    |
| VDI identity          | Not explicit                      | **Missing**                  | Post-clone enrollment and enrollment epochs; no credential in golden image                             | Nonpersistent VDI produces stale/duplicate identity problems. ([Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure "https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure"))                                            | Clone 100 VMs and observe uniqueness/throttling                           |
| HTTP batching         | gzip/idempotent batches           | **Keep and specify**         | Bounded versioned envelope, per-event terminal status, body hash, batch splitting                      | Decompression and semantic limits are security controls, not implementation details. ([Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0"))               | Compression threshold and poison-event test                               |
| Retry                 | HTTPS retries                     | **Revise**                   | Separate timeouts, full jitter, stable reconnect spread, token bucket, `Retry-After`                   | Retrying POST safely depends on application idempotency. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html "https://www.rfc-editor.org/rfc/rfc9110.html"))                                                                                                                                                                                          | 6,000-device outage/reconnect test                                        |
| Idempotency           | “Idempotent”                      | **Insufficiently defined**   | Event key `{device, epoch, stream, sequence}` plus batch receipt and body hash                         | Batch-only dedup is insufficient when a restarted client rebuilds batches                                                                                                                                                                                                                                                                                   | Replay after response loss, 30+ days, and central restore                 |
| Ordering              | Not specified                     | **Missing**                  | Per-stream sequence only; no global ordering promise                                                   | Global endpoint ordering is expensive and unnecessary                                                                                                                                                                                                                                                                                                       | Out-of-order and duplicate materialization tests                          |
| Ingestion durability  | API → durable queue               | **Revise**                   | API → transactional central SQL inbox → durable ACK                                                    | Eliminates another subsystem and a split durable boundary                                                                                                                                                                                                                                                                                                   | SQL inbox benchmark at 2× forecast reconnect load                         |
| External broker       | Durable queue                     | **Reject as default**        | Add only for measured outage isolation, fan-out, replay, multi-region, or throughput                   | Six thousand devices alone does not establish need; broker dedupe windows may be too short. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection "https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection"))                                                                      | Compare SQL-only versus broker-first failure behavior and TCO             |
| Workers               | Queue consumers                   | **Keep**                     | Leased, idempotent workers with poison state and integration outbox                                    | Preserves independent scaling and replay                                                                                                                                                                                                                                                                                                                    | Kill workers after every write step                                       |
| Primary database      | Partitioned PostgreSQL            | **Revise**                   | Provisional SQL Server 2025; preserve engine-neutral model and benchmark PostgreSQL 18                 | Existing estate lowers SQL Server transition risk; both engines are credible                                                                                                                                                                                                                                                                                | Representative ingest/report/retention benchmark and skills assessment    |
| Partitioning          | Partitioned from day one          | **Conditional**              | Start partition-ready; enable monthly facts based on row count/retention evidence                      | Partitioning adds missing-partition and global-uniqueness complications. ([PostgreSQL](https://www.postgresql.org/docs/current/ddl-partitioning.html "https://www.postgresql.org/docs/current/ddl-partitioning.html"))                                                                                                                                      | One-year projected dataset and retention benchmark                        |
| Reporting             | Same relational tables            | **Revise**                   | Read replica/materialized views/columnar archive or warehouse for heavy reports                        | Protect ingestion from exploratory and long-running queries                                                                                                                                                                                                                                                                                                 | Production-like report concurrency test                                   |
| Control/data plane    | APIs and portal                   | **Keep and strengthen**      | Separate data, control, and release identities and deployment pools                                    | Limits blast radius and prevents portal-to-code-signing escalation                                                                                                                                                                                                                                                                                          | Credential-compromise exercises                                           |
| Portal                | Modern portal                     | **Keep**                     | API-only OIDC portal, bundled assets, CSP, tenant-scoped RBAC                                          | Removes direct SQL/AD and CDN runtime dependencies                                                                                                                                                                                                                                                                                                          | Threat model, authorization matrix and browser security test              |
| Audit                 | Auditability                      | **Replace legacy design**    | Transactional append-only audit plus external digest/WORM verification                                 | An ordinary table and best-effort insert are insufficient. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17"))                                         | Block audit writes, privileged tamper and verification tests              |
| Integrations          | Customer-independent              | **Specify**                  | Versioned integration API/outbox and isolated connectors                                               | Prevents customer-specific credentials and failures from entering core ingest                                                                                                                                                                                                                                                                               | 7-day destination outage and replay test                                  |
| Observability         | Not specified                     | **Missing**                  | Non-PII OpenTelemetry traces, metrics and logs across endpoint/API/workers                             | Common semantic naming improves correlation across components. ([OpenTelemetry](https://opentelemetry.io/docs/specs/semconv/ "https://opentelemetry.io/docs/specs/semconv/"))                                                                                                                                                                               | Verify no event payload in logs or metric labels                          |
| Deletion/DR           | Not specified                     | **Missing**                  | Subject index, tombstones, connector deletion, restore-time re-deletion                                | EDPB’s 2026 erasure work identifies restoring deleted data from backups as a concrete failure. ([EDPB](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf "https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf"))                                            | Erase, archive, backup, restore, and serve-readiness drill                |

---

# 5. Concrete failure scenarios

## 5.1 Endpoint, sessions, and local storage

| #   | Failure scenario                                                        | Detection                                                                           | Containment                                                                                      | Recovery                                                                                              | Test method                                                                      |
| --- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| 1   | Service starts before a user logs on or before the profile is available | Session inventory shows no registered user host; health state `awaiting_session`    | Do not fall back to the SYSTEM profile or scan `C:\Users`                                        | Logon task starts host; source scan resumes from durable cursor                                       | Cold boot with delayed domain, roaming and FSLogix profile attachment            |
| 2   | Two or more simultaneous RDS/Citrix sessions                            | Registered host keyed by SID, session ID and host PID; duplicate registration alarm | One stream namespace and quota per session/user/source; authenticated pipe client                | Terminate orphaned registration and restart only affected host                                        | Ten concurrent sessions, including same user in two sessions                     |
| 3   | User disconnects or logs off during a scan                              | Session-change event, taskhost exit, pipe break                                     | No cursor commit until the service transaction containing scan results completes; kill child job | Restart at next eligible session and rescan overlap                                                   | Inject logoff/disconnect at every scan and IPC fault point                       |
| 4   | User profile path is unavailable, redirected, or changes                | Explicit profile/source discovery error, profile type telemetry                     | Never scan another user’s path as fallback                                                       | Backoff, rediscover after profile mount, keep source-specific cursor                                  | Roaming profile, OneDrive redirection, FSLogix attach/detach, nonpersistent VDI  |
| 5   | Browser database is locked, schema changes, or snapshot is inconsistent | SQLite error code, schema fingerprint mismatch, snapshot validation failure         | Disable only that browser collector/version; do not advance cursor                               | Deploy compatible parser; rescan with overlap                                                         | Browser actively writing while collecting; browser upgrade; main/WAL mismatch    |
| 6   | Polling misses short-lived processes                                    | Synthetic ground-truth process count versus collected count                         | Document best-effort semantics; do not claim completeness                                        | Adopt ETW/WMI/event source if requirement demands it                                                  | Launch 10,000 processes with 25–500 ms lifetimes                                 |
| 7   | Sleep, hard reboot, or power loss occurs mid-transaction                | Boot ID change; unclean-start marker; WAL recovery metrics                          | `synchronous=FULL`; atomic cursor/event transaction                                              | SQLite recovery, replay unacknowledged events, resume with jitter                                     | VM hard reset and power-fault injection across at least 10,000 commit points     |
| 8   | Taskhost hangs, leaks, creates children, or consumes CPU                | Wall-clock timeout; Job Object CPU/RAM/process counters                             | Restricted token, no breakaway, no network, process-count and memory limits                      | Terminate whole job, quarantine task version, continue other collectors                               | Malicious collectors: infinite loop, memory leak, fork bomb, native crash        |
| 9   | Task emits a field or value forbidden by privacy policy                 | User-host schema/privacy rejection metric containing only rule ID and hash          | Stable privacy gate before service IPC, disk and logs; taskhost has no network                   | Disable offending task/policy, rotate version, trigger deletion workflow if central exposure occurred | Golden corpus plus property-based and mutation fuzzing                           |
| 10  | Local disk approaches full or outbox reaches quota                      | Alerts at 70/85/95%, oldest-event age, SQLite page count, free-space reserve        | Stop new collection; keep transmission active; no silent eviction                                | Drain backlog, increase approved quota, or invoke explicit lossy policy                               | Fill volume during 30-, 60-, and 90-day simulated outage                         |
| 11  | Long reader prevents checkpoint and WAL grows                           | WAL byte count, checkpoint busy result, reader age                                  | Single writer; short readers; taskhost never opens outbox DB                                     | Terminate stale internal reader and perform controlled checkpoint                                     | Deliberately hold a read transaction for hours while ingesting                   |
| 12  | SQLite corruption, antivirus interference, or rogue local write         | `quick_check`, I/O errors, unexpected file hash/change owner                        | Stop collection; preserve DB, WAL and SHM together; deny other writers by ACL                    | Offline recovery; create a recorded new epoch; source rescan where possible                           | Bit flips, truncated files, deleted WAL, stale copied WAL, direct file overwrite |

## 5.2 Update, identity, and transport

| #   | Failure scenario                                                   | Detection                                                                                        | Containment                                                                                           | Recovery                                                                          | Test method                                                            |
| --- | ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| 13  | Online release-signing key is compromised                          | Release transparency/repository monitoring, anomalous targets metadata, incident alert           | Offline threshold root, delegated roles, canary rings, server minimum-version control                 | Revoke/rotate target key, publish fresh metadata, emergency block affected hashes | Exercise with a deliberately exposed online target key                 |
| 14  | Mirror or attacker replays stale metadata or a vulnerable package  | Expiry, monotonic metadata versions, highest-seen version, version floor                         | Reject rollback/freeze/replay; TLS is not the only protection                                         | Fetch current metadata or use signed offline repair media                         | Replay old repository snapshots, alter clock, block timestamp updates  |
| 15  | Authorized emergency downgrade is required                         | Explicit security incident/change record                                                         | Only a separate threshold-signed rollback authorization may cross version floor                       | Roll back to named hash for bounded period; issue repaired forward version        | Attempt ordinary downgrade, expired downgrade and wrong-hash downgrade |
| 16  | Candidate starts but crashes later, creating a rollback loop       | Probation health, crash rate by version/ring, update journal                                     | One automatic rollback; mark candidate bad; never alternate indefinitely                              | Return to previous compatible version and await newer release                     | Inject failure after 5, 30 and 120 minutes                             |
| 17  | Updater or stable supervisor itself breaks                         | Missing SCM heartbeat, repair check, fleet-version divergence                                    | Core remains repairable by MSI/endpoint management; mutable payload cannot overwrite repair component | Enterprise redeploy or offline repair package                                     | Corrupt updater binary, ACL and state file separately                  |
| 18  | Candidate performs a schema change incompatible with rollback      | Preflight schema compatibility check and migration journal                                       | Expand/contract migrations; no irreversible migration before health proof                             | Roll back code on compatible schema or run signed repair migration                | Upgrade N→N+1, kill mid-migration, then attempt N rollback             |
| 19  | Device certificate expires, is revoked, or TPM is cleared          | Expiry-days metric, revocation and TLS failure categories                                        | Overlapping renewal window; revoke compromised cert without deleting device record                    | Controlled one-time reenrollment through management assertion                     | Expired, not-yet-valid, revoked, changed chain, TPM-clear cases        |
| 20  | Golden VDI image clones a device identity                          | Same certificate used concurrently by implausibly many hosts; conflicting boot/enrollment claims | No cert/token in image; post-clone enrollment; per-clone epoch                                        | Revoke duplicates and reenroll clones                                             | Create and start 100 simultaneous clones                               |
| 21  | Server commits but the HTTP response is lost                       | Client retry hits existing batch/event key                                                       | Unique event key and deterministic terminal response                                                  | Return the same acceptance/rejection result without rematerializing               | Drop connection after commit before every possible response byte       |
| 22  | All 6,000 devices reconnect together                               | TLS handshake rate, request concurrency, 429 rate, inbox depth/age                               | Stable reconnect spread, full jitter, token buckets, admission control                                | Drain backlog under controlled rate; widen temporary capacity only if safe        | Disconnect fleet for 24 hours, restore endpoint simultaneously         |
| 23  | gzip bomb, malformed gzip, oversized strings, or excessive nesting | Compressed/decompressed byte counters and parse-limit errors                                     | Stream with hard limits; abort before buffering or database access                                    | Endpoint splits a valid batch or quarantines malformed event                      | High-ratio compression, truncated stream, deep nesting, 100 MB field   |
| 24  | One poison event blocks a per-stream acknowledgement               | Repeated permanent validation failure at same sequence                                           | Per-event terminal rejection; rejected sequence counts as terminal                                    | Store hash/reason, remove raw event after policy period, continue later sequence  | One malformed event surrounded by 999 valid events                     |
| 25  | Endpoint retries after broker/database dedup history expired       | Persistent event-key hit or non-PII dedup tombstone                                              | Dedup horizon covers maximum outage, accepted-retention and restore replay                            | Reconcile by event key; never rely only on seven-day broker dedup                 | Retry identical events after 30, 90 and 180 days                       |
| 26  | Endpoint clock jumps backward/forward                              | Clock-skew metric versus server receive time and boot monotonic clock                            | Ordering uses sequence, not wall clock; retention uses server policy                                  | Correct display/analytics while preserving original timestamp                     | ±1 year clock changes, DST, NTP step, suspended VM resume              |

## 5.3 Central, control plane, integrations, and DR

| #   | Failure scenario                                                     | Detection                                                       | Containment                                                                                   | Recovery                                                                | Test method                                                                |
| --- | -------------------------------------------------------------------- | --------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| 27  | Worker dies after inserting a fact but before marking inbox complete | Expired lease; unique-key conflict on retry                     | Materialize and complete in one transaction, or make insert independently idempotent          | Reclaim lease and replay safely                                         | Kill worker after each SQL statement and commit                            |
| 28  | Future partition was not created or retention job fails              | Partition-horizon alert; retention-lag metric                   | Inbox remains independent so ingestion can continue while materialization pauses              | Create/repair partition and replay inbox                                | Delete next partition and advance clock across boundary                    |
| 29  | Primary relational database is unavailable                           | Connection health, API readiness, failover status               | Return retryable 503; do not acknowledge; endpoints retain data                               | Fail over or restore; endpoints retry with jitter                       | Four-hour planned outage plus unplanned failover                           |
| 30  | Tenant is spoofed in payload or noisy tenant exhausts capacity       | Payload/auth mismatch, per-tenant rate and storage metrics      | Derive tenant from certificate registry; RLS defense in depth; quotas                         | Revoke device, isolate tenant traffic, replay unaffected tenants        | Cross-tenant authorization suite and abusive-tenant load                   |
| 31  | Control-plane credential is compromised                              | Anomalous policy scope, approval bypass attempt, audit alert    | Privacy ceiling, two-person approval, separate control/data/release credentials               | Revoke control identity and restore last-known-good policy              | Red-team tenant and platform administrator accounts                        |
| 32  | Portal mutation succeeds but audit write fails                       | Transaction abort; audit health metric                          | Mutation and audit use same transaction; fail the mutation closed                             | Retry whole command with same command idempotency key                   | Deny audit-table insert while issuing admin actions                        |
| 33  | Audit data or database files are altered by privileged administrator | Ledger/hash verification failure against external digest        | Separation of duties and externally immutable digest/export                                   | Incident response, restore verified state, preserve evidence            | Modify table/file under privileged account and verify detection            |
| 34  | Customer destination is unavailable for seven days                   | Integration backlog age, attempt and circuit state              | Per-tenant outbox and circuit; core ingestion does not wait                                   | Resume/replay in order under destination rate limit                     | Return 500, timeout and malformed response for seven days                  |
| 35  | Integration accepts event but response is lost                       | Connector retry receives duplicate-id result                    | Stable integration delivery key                                                               | Treat duplicate as accepted and advance outbox                          | Drop response after destination commit                                     |
| 36  | Central restore returns to a point before acknowledged events        | Restore generation mismatch, endpoint/server reconciliation gap | Synchronous durable replication or retained accepted events beyond RPO+recovery               | Request endpoint replay; rebuild inbox and facts idempotently           | Acknowledge events, restore to T−5 minutes, prove no loss                  |
| 37  | Restore also resurrects previously erased personal data              | Deletion-tombstone replay status blocks read readiness          | Tombstone ledger stored independently and restored first                                      | Reapply deletions to hot, archive and integration queues before serving | Delete a subject, back up, restore older backup, query all stores          |
| 38  | Subject deletion misses archive or external recipient                | Deletion workflow shows incomplete store/recipient receipts     | Subject index, connector deletion contracts, no “complete” until all required states terminal | Retry, restrict access, escalate recipient failure                      | Seed subject data in every tier and connector, then erase                  |
| 39  | Heavy portal report starves ingestion                                | Database wait/CPU/I/O correlated with report request            | Read replica, workload group, timeout, row/scan caps                                          | Cancel report; route to materialized/warehouse copy                     | Production-scale report concurrency during reconnect test                  |
| 40  | Observability pipeline captures raw URLs or file paths               | Automated log/trace scanner and DLP rule                        | Structured allowlisted telemetry fields; no payload serialization in exceptions               | Purge affected telemetry and rotate instrumentation                     | Inject canary secrets/URLs and inspect all logs, traces, dumps and metrics |

---

# 6. Security and privacy boundaries

## 6.1 Trust-boundary table

| Boundary                     | Permitted data access                                              | Permitted output                                         | Principal controls                                                                                 |
| ---------------------------- | ------------------------------------------------------------------ | -------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **Taskhost**                 | Only approved source files/APIs for one collector and session      | Typed records to its parent user host                    | User-derived restricted token, Job Object, no network, no outbox/cert access                       |
| **User host / privacy gate** | Task output and user-session source metadata                       | Only approved canonical events to machine-service pipe   | Actual interactive user token; signed stable binary; tenant policy can only narrow product ceiling |
| **Machine service**          | Filtered canonical events, local cursor, identity and health state | mTLS HTTPS to fixed data/control endpoints               | LocalService/virtual account, service SID, explicit privileges, outbound firewall restriction      |
| **Release repository**       | Signed artifacts and metadata only                                 | Immutable packages and TUF metadata                      | Offline threshold root; delegated online keys; no portal credentials                               |
| **Ingestion API**            | Authenticated device request                                       | Transactional inbox writes and durable terminal response | Device certificate mapped to authoritative tenant/device; no portal identity                       |
| **Inbox workers**            | Leased validated events                                            | Normalized facts and integration outbox                  | No control-plane administration or release-signing authority                                       |
| **Control API**              | Tenant/device/policy administrative state                          | Versioned configuration snapshots and audited mutations  | OIDC, MFA, RBAC/ABAC, approval policy                                                              |
| **Portal**                   | API-filtered views                                                 | Control API requests only                                | No SQL, AD, signing-key, device-certificate, or event-ingest credentials                           |
| **Integration worker**       | Tenant-scoped normalized events                                    | One configured customer destination                      | Per-tenant vault secret, rate limits, separate delivery state                                      |
| **Audit verifier**           | Audit stream and external digests                                  | Verification result and incident signal                  | Separate operators/credentials from database administrators                                        |
| **Backup/restore operator**  | Encrypted backups and deletion tombstone set                       | Controlled restore environment                           | Readiness gate prevents serving before reconciliation and re-deletion                              |

## 6.2 Multi-tenancy rules

- Every central row that can contain customer data has an authoritative `tenant_id`.

- Tenant is assigned at authentication, never copied blindly from the body.

- RLS is defense in depth, not the sole isolation control.

- Every API query requires tenant scope at the repository/data-access boundary.

- Per-tenant rate, backlog, integration, retention, export, and deletion state are explicit.

- High-assurance customers may require a separate database, encryption key, region, or deployment cell. Shared-table tenancy should not be mandatory.

- Platform support access is time-bounded, approved, and audited.

- No tenant administrator can enumerate another tenant’s device IDs, event IDs, counts, error messages, or integration state.

## 6.3 Data ownership

These roles cannot be finalized from code alone:

| Data/object                                | Recommended accountable owner                                     | Notes                                                                                         |
| ------------------------------------------ | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| Employee activity purpose and lawful basis | Customer data controller/privacy owner                            | Must approve purpose, subjects, transparency, proportionality, retention, access and deletion |
| Product privacy ceiling                    | Product security and privacy governance                           | A release decision, not an ordinary tenant setting                                            |
| Tenant-narrowing policy                    | Authorized customer administrator with privacy approval           | Cannot exceed product ceiling                                                                 |
| Endpoint device identity                   | Customer endpoint/identity team; platform custodian               | Enrollment, revocation, VDI lifecycle and disposal responsibilities                           |
| Source cursor and local outbox             | Endpoint service under customer policy                            | Temporary custody; local retention and loss behavior documented                               |
| Central event data                         | Customer as controller; platform role depends contract/deployment | Processor/controller roles need explicit legal determination                                  |
| Administrative audit                       | Platform security/compliance owner                                | Retention may differ from activity events; avoid storing unnecessary event values             |
| Connector destination copy                 | Customer and recipient/integration owner                          | Delivery creates another copy with its own retention and deletion obligations                 |
| Release keys and packages                  | Product release/security engineering                              | Separate from customer administration                                                         |
| Backups and tombstones                     | Data-platform and privacy operations jointly                      | Restores cannot be declared ready until tombstones are replayed                               |

### Privacy deletion

A defensible deletion workflow needs:

- A stable subject key and subject-to-event index.

- Hot-table deletion or irreversible anonymization according to policy.

- Archive/object-store handling.

- Integration recipient notification and confirmation.

- Search/index/cache invalidation.

- A non-PII deletion tombstone.

- Backup expiry policy.

- Restore-time automatic re-deletion before user access.

- Evidence of completion without retaining the deleted content itself.

The EDPB’s February 2026 erasure report specifically identifies the absence of procedures preventing deleted data from returning during backup restoration and describes documented repeated deletion after restore as the necessary organizational mechanism where selective backup mutation is impractical. ([EDPB](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf "https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf"))

## 6.4 Residual risks

The architecture still cannot fully prevent:

- A local administrator or kernel compromise from reading collection data in memory.

- A sufficiently broad signing-key compromise before revocation propagates.

- A legally or semantically incorrect privacy policy that technically executes as designed.

- Upstream browser/source schema changes causing collection gaps.

- Offline periods exceeding the approved endpoint capacity.

- Source-clock errors or process-event incompleteness.

- A privileged insider who controls both production data and the external audit-verification system.

- A customer integration retaining or redistributing data contrary to contract.

- Physical or platform-wide disasters beyond the selected DR topology.

The goal is to detect these conditions, limit the affected boundary, preserve evidence, and provide a tested recovery path.

---

# 7. Alternatives rejected or deferred

## 7.1 Alternative A — managed broker first

```text
Endpoint outbox
  -> ingestion API
  -> Azure Service Bus / RabbitMQ quorum queue
  -> workers
  -> SQL Server or PostgreSQL
  -> integration outbox
```

**Why it is not the default:** additional cost, credentials, monitoring, capacity planning, dead-letter administration, and duplicate semantics without a demonstrated requirement. It does not remove the need for event-level database idempotency.

**When it becomes preferable:**

- The relational database must undergo long maintenance while ingestion remains available.

- There are many independent consumers and substantial replay.

- Managed Service Bus is already a supported organizational platform.

- Multi-region ingestion is required.

- Benchmarks show reconnect bursts cannot safely commit directly to the central inbox.

- The broker’s availability SLO is demonstrably higher than the chosen database boundary.

Azure Service Bus offers sessions, transactions, dead-lettering, and duplicate detection, but its duplicate-history maximum is seven days; endpoint event idempotency still belongs in the application/database model. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/advanced-features-overview "https://learn.microsoft.com/en-us/azure/service-bus-messaging/advanced-features-overview"))

## 7.2 Alternative B — object-store landing zone and lakehouse

```text
Endpoint outbox
  -> ingestion/auth API
  -> encrypted immutable batch object + manifest
  -> object-created notification / queue
  -> validation and compaction
  -> Parquet/Iceberg/Delta-style lake
  -> query warehouse
  -> serving API
```

**Strengths:**

- Excellent burst absorption.

- Cheap long-term retention.

- Natural immutable raw-batch replay.

- Analytics-oriented storage.

- Relational database is not the first durable write.

**Reasons not to use it as the initial default:**

- Per-event acknowledgement is harder.

- Poison handling and low-latency operational queries require more infrastructure.

- Precise privacy deletion from immutable/compacted objects is materially harder.

- Administrative/device state still needs a transactional database.

- Small operational queries often need a separate serving store.

**When it becomes preferable:**

- Multi-year high-volume retention dominates.

- Reporting is mostly aggregate/analytical.

- Latency can be minutes rather than seconds.

- The organization already operates a governed lakehouse.

- Deletion is implemented through keyed encryption destruction or tested rewrite/index workflows.

## 7.3 Alternative C — Kafka/Redpanda plus stream processing and OLAP

```text
Endpoint
  -> regional ingest
  -> Kafka-compatible log
  -> stream validation/enrichment
  -> ClickHouse/Druid/lakehouse
  -> control DB and APIs
```

**Why deferred:** materially greater operational and schema-governance burden than justified by 6,000 endpoints, especially for deletion, tenant isolation, and connector replay.

**When preferable:**

- Endpoint count or event volume grows by an order of magnitude.

- Dozens of independent real-time consumers require replay.

- Multi-region event-log replication is a core business requirement.

- The organization already runs Kafka and an OLAP serving platform with staffed on-call support.

## 7.4 Alternative D — SQL Server with Service Broker

```text
Ingestion stored procedure
  -> SQL Server canonical event + Service Broker conversation
  -> activated procedures/workers
  -> fact tables and integration outbox
```

This is viable in a strongly Microsoft/on-premises organization. It is not the first recommendation because ordinary inbox tables and external .NET workers are simpler to inspect, test, deploy, and migrate. It becomes preferable when the database team already operates Service Broker and wants queue activation and transactionality entirely inside SQL Server. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/database-engine/service-broker/creating-service-broker-queues?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/database-engine/service-broker/creating-service-broker-queues?view=sql-server-ver17"))

## 7.5 Explicitly rejected defaults

| Rejected default                                              | Reason                                                                                                |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| One LocalSystem service that opens all user profiles          | Excess privilege, Session 0/profile lifecycle complexity, and multi-user ambiguity                    |
| `AssemblyLoadContext` as crash/security containment           | Same process, same permissions, same native crash and memory-corruption fate                          |
| Tenant-authored scripts or database-stored executable code    | Recreates the present remote-code-execution authority                                                 |
| Signing alone as update security                              | Does not prevent replay, rollback, freeze, or compromised online-key abuse                            |
| Automatic deletion of oldest unacknowledged endpoint events   | Converts capacity pressure into silent evidence loss                                                  |
| Infinite retry of malformed event                             | One poison item can consume endpoint and server capacity forever                                      |
| Broker duplicate detection as idempotency                     | History is bounded and often shorter than the endpoint outage/replay horizon                          |
| Portal or integration direct database access                  | Couples customers to schema, bypasses policy/audit, and spreads high-value credentials                |
| PostgreSQL migration without operational proof                | Adds a database-platform migration to an already high-risk endpoint and protocol rewrite              |
| Partitioning every table from day one                         | Adds operational and uniqueness complexity before volume is known                                     |
| Audit inserted after business mutation on a best-effort basis | Allows an unaudited successful administrative action                                                  |
| Raw batch WORM retention without deletion design              | Immutability can directly conflict with required erasure unless retention and key design are explicit |

---

# 8. Decisions that documents cannot settle

| Unknown decision                   | Smallest useful prototype or measurement                                                                      | Decision rule                                                                                       |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Actual event rate and payload size | Two weeks of counters on 100 representative endpoints; record counts and byte histograms only, not raw values | Size outbox and ingest at p99 device/day plus at least 20% headroom                                 |
| Reconnect shape                    | Replay captured histograms into a 6,000-device load generator                                                 | Add broker only if SQL inbox cannot meet SLO with reasonable scale                                  |
| Required offline duration          | Business/privacy decision plus laptop and VDI usage data                                                      | Set hard outbox capacity and idempotency horizon from declared duration                             |
| Concurrent-session prevalence      | Fleet inventory and one RDS/Citrix pilot                                                                      | Confirm one-host-per-session resource budget and session policy                                     |
| Browser profile variants           | 25-device matrix across Chrome, Edge, Firefox, multiple profiles, FSLogix and live writes                     | Select direct read, backup API or coordinated snapshot based on zero-gap result                     |
| Process-event completeness         | Compare polling, WMI and ETW against synthetic short-lived process ground truth                               | Select least-privileged mechanism meeting documented capture percentage                             |
| AppContainer feasibility           | Run browser/recent collectors in AppContainer with only required path ACLs                                    | Use AppContainer if access remains supportable; otherwise restricted token + Job Object             |
| SQLite durability/performance      | 10,000 kill/power faults under representative write rate with FULL and NORMAL                                 | Use NORMAL only if the accepted loss budget and measured gain justify it                            |
| Long-outage storage behavior       | Fill outbox with 30/60/90 days of p99 workload, then drain                                                    | Define stop-collection thresholds, cleanup cost and disk reserve                                    |
| SQL Server versus PostgreSQL       | Same schema, indexes, retention and 2× reconnect workload; include failover and restore                       | Decide on SLO, operator skill, TCO and restore—not insert-only benchmark                            |
| Partition interval                 | One projected year of event facts and representative report/delete workload                                   | Use monthly/daily partitions only when maintenance and pruning benefits are demonstrated            |
| Need for external broker           | Deliberately remove primary DB for four hours under both designs                                              | Broker wins only if accepting during DB outage is required and operational cost is justified        |
| Core update ownership              | Measure patch latency and management coverage across all endpoint classes                                     | Prefer MSI/management if it meets emergency patch SLO                                               |
| Health-proof interval              | Canary tests with immediate and delayed injected faults                                                       | Interval covers the common delayed-failure distribution without blocking urgent patches excessively |
| Device certificate model           | TPM, software-key, cert renewal and nonpersistent VDI lab                                                     | Define assurance tiers and supported fallback                                                       |
| Subject identifier                 | Privacy/legal workshop plus deletion prototype                                                                | Use the least identifying stable key that still permits access control and erasure                  |
| Retention and archive              | Legal/business decision by event class and tenant                                                             | Database and partitioning follow approved policy, not vice versa                                    |
| Reporting platform                 | Capture top 20 intended queries and concurrency                                                               | Keep on relational replica if SLO holds; otherwise materialize/warehouse                            |
| Integration fan-out                | Build two representative connectors, one fast and one failing for seven days                                  | Validate outbox sizing and customer-visible delivery state                                          |
| DR topology                        | Restore primary, idempotency tables, audit and deletion ledger into isolated environment                      | Production only after no acknowledged event or deleted subject is lost/resurrected                  |
| Operations readiness               | On-call game day: certificate failure, backlog, bad update, DB failover, corruption                           | Selected components require named owners, runbooks and successful exercise                          |

---

# 9. Measurable architecture acceptance criteria

Values marked **provisional** should be replaced after the prototypes above, not silently weakened during implementation.

## 9.1 Privacy and security

1. **Zero forbidden durable values** across at least 1,000,000 golden-corpus and fuzz-generated source records, including endpoint logs, SQLite, crash dumps, network capture and central rejection logs.

2. Invalid, expired, revoked, or privacy-ceiling-incompatible policy produces **zero new collection** and a health alert.

3. Taskhost has:
   
   - No successful outbound network connection.
   
   - No read access to the device private key.
   
   - No write access to the outbox.
   
   - No access to another session’s approved source.

4. No endpoint package, registry value, config file, log, or memory dump intentionally contains a central database credential.

5. One hundred percent of tenant authorization tests demonstrate that payload tenant identifiers are ignored as authority.

6. Every privacy-expanding policy change requires the configured approval count and produces a machine-readable audited diff.

## 9.2 Endpoint correctness and durability

7. Across at least **10,000 process termination/power-fault points**, there is never:
   
   - A committed source cursor without its events, or
   
   - A committed event batch without the corresponding new cursor/sequence state.

8. Replaying an accepted batch ten times produces exactly one materialized event per event key and the same terminal response.

9. One permanent poison event does not prevent subsequent valid events from becoming terminal.

10. Outbox capacity supports the declared outage duration at p99 workload plus **20% provisional margin**.

11. Capacity alerts trigger at **70%, 85%, and 95%**, and no unacknowledged event is silently evicted.

12. `quick_check` and WAL/checkpoint health are reported without exposing event values.

13. **Provisional endpoint budget:** below 1% average CPU, below 3% p95 CPU while collecting, below 150 MB aggregate steady-state private memory for service plus one user host, excluding short taskhost peaks.

14. Taskhost exceeding wall-time or resource limit is fully terminated, including descendants, within **5 seconds provisional**.

15. Fast-user-switch and ten-concurrent-session tests show zero cross-session records and zero orphaned long-running taskhosts.

## 9.3 Delivery and central capacity

16. **Provisional request limits:** no more than 1 MiB compressed, 8 MiB decompressed, 1,000 events, and 256 KiB for any individual event. Final values come from measurement.

17. A malformed compressed body is rejected before database work and does not increase process memory beyond the configured streaming limit.

18. In a 6,000-device reconnect test spread over ten minutes at twice forecast p99 backlog:
- Durable-ACK p95 below **2 seconds provisional**.

- API 5xx below **0.1% provisional**, excluding deliberate fault periods.

- No database connection-pool starvation.

- Inbox oldest age returns below five minutes within **30 minutes provisional**.
19. A 429 response with `Retry-After` causes compliant delayed retry; no synchronized retry spike occurs at the delay boundary.

20. Idempotency records or tombstones remain effective for at least:

```text
maximum supported endpoint outage
+ local accepted-event grace period
+ central restore/replay interval
```

21. Unsupported protocol or schema versions receive an explicit permanent response; supported N/N-1/N-2 versions pass the compatibility suite.

## 9.4 Update safety

22. Every executable verifies both repository authorization and Authenticode signature/timestamp.

23. Old metadata, wrong hash, expired metadata, wrong delegated role, and unauthorized downgrade all fail installation.

24. Root and delegated key rotation succeeds in a disconnected test repository.

25. Canary rings proceed at explicit stages—for example 1%, 5%, 25%, 100%—and stop automatically when crash, privacy, or upload-error thresholds are crossed.

26. Bad-version rollback completes within **five minutes provisional**, and the bad version is not automatically retried.

27. A broken updater is repaired through MSI/endpoint management without relying on the broken updater.

28. N and N-1 binaries can open the current outbox schema throughout the rollback window.

## 9.5 Audit, privacy deletion, and recovery

29. Blocking the audit insert causes the corresponding administrative mutation to fail.

30. External audit digest/export lag remains below **five minutes provisional**, with alerting before the audit retention buffer fills.

31. Privileged modification of audited database content is detected by the scheduled verification process.

32. Online subject deletion completes from hot data and serving indexes within **24 hours provisional**, except documented legal holds.

33. Required integration recipients complete or acknowledge deletion within **seven days provisional**, with outstanding recipients visible.

34. Restoring a backup containing deleted data cannot make the system read-ready until deletion tombstones have been reapplied.

35. There is **no acknowledged-event loss** under the declared DR design:
- Either the durable acceptance layer has RPO 0 for acknowledged commits, or

- Endpoint accepted-event retention and replay demonstrably close the RPO gap.
36. **Provisional RTO:** four hours for data ingestion and query service following a regional or primary-database recovery.

37. Quarterly restore drills include idempotency, audit verification, tenant isolation, integration state, and deletion state—not only database startup.

## 9.6 Operations and observability

38. Every batch can be followed by non-PII correlation identifiers from endpoint creation through receipt, inbox processing and connector delivery.

39. Required fleet metrics include:
- Outbox rows/bytes/oldest age.

- Policy and collector versions.

- Certificate expiry.

- Update state and rollback count.

- Session-host count.

- Permanent rejection rate.

- Ingestion duplicate rate.

- Inbox oldest age and lease expiry.

- Integration backlog.

- Audit export lag.

- Deletion backlog.
40. No URL, file path, title, user name, command line, or payload body is permitted as a metric label.

41. Representative reporting load does not increase ingest p95 latency by more than **20% provisional**.

42. Each production component has a named owner, on-call path, capacity limit, backup responsibility and tested runbook.

---

# 10. Proposed ADR list, in priority order

1. **ADR-001 — Product privacy ceiling and prohibition on arbitrary endpoint code**

2. **ADR-002 — Machine service plus per-interactive-session user-host model**

3. **ADR-003 — Endpoint principal, service SID, privilege and network model**

4. **ADR-004 — Taskhost process isolation, token restrictions and Job Object limits**

5. **ADR-005 — Canonical event model and approved data fields**

6. **ADR-006 — Atomic source-cursor and outbox-event transaction invariant**

7. **ADR-007 — Event identity, enrollment epochs, ordering and idempotency**

8. **ADR-008 — Device enrollment, certificate rotation, TPM assurance and VDI clone handling**

9. **ADR-009 — Core installation, repair and update ownership**

10. **ADR-010 — Update metadata trust, key rotation, rollback and emergency downgrade**

11. **ADR-011 — Candidate health proof, version switching and rollback-loop suppression**

12. **ADR-012 — SQLite durability settings, writer model and schema migration**

13. **ADR-013 — Endpoint quota, cleanup, corruption and explicit data-loss policy**

14. **ADR-014 — Transport envelope, compression and request limits**

15. **ADR-015 — Retry, jitter, rate limiting and reconnect admission control**

16. **ADR-016 — Durable central ACK and per-event terminal response semantics**

17. **ADR-017 — Transactional SQL inbox versus external broker escalation criteria**

18. **ADR-018 — SQL Server 2025 versus PostgreSQL 18 selection**

19. **ADR-019 — Central partitioning, global dedup keys, retention and archive**

20. **ADR-020 — Worker lease, poison and idempotent materialization model**

21. **ADR-021 — Control, data and release plane separation**

22. **ADR-022 — Tenant isolation, RLS, quotas and deployment-cell options**

23. **ADR-023 — Portal authorization and prohibition on direct database access**

24. **ADR-024 — Administrative audit transactionality and external verification**

25. **ADR-025 — Integration outbox, connector contract and deletion propagation**

26. **ADR-026 — Subject identity, deletion tombstones and restore-time re-deletion**

27. **ADR-027 — Backup, replication, endpoint replay grace, RPO and RTO**

28. **ADR-028 — Observability schema and prohibition on personal data in telemetry**

29. **ADR-029 — Browser snapshot strategy and profile enumeration**

30. **ADR-030 — Process-event completeness and source mechanism**

31. **ADR-031 — Legacy checkpoint migration and cutover reconciliation**

32. **ADR-032 — Canary rollout, fleet rings and automated halt thresholds**

ADRs 1–18 are implementation blockers. The others can proceed in parallel once the core trust and durability model is fixed.

---

# 11. Primary source register and inference notes

Each citation below opens the primary source directly.

| Source                                                   | Date/version                                                                  | Used for                                                                                                    | Fact versus inference                                                                                                                                                                                                                                                                                                                                                                               |
| -------------------------------------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Supplied UAM code reference and production schema        | Schema captured 23 July 2026                                                  | Current endpoint session behavior, direct SQL, CSV replay, script execution, portal mutation/audit behavior | **Fact from supplied material.** Organizational SQL Server skill is an inference and must be confirmed.                                                                                                                                                                                                                                                                                             |
| Microsoft, Service Changes / Session 0                   | Last updated 7 January 2021; stable current Windows behavior                  | Session 0, service SIDs, required privileges, SCM recovery                                                  | **Fact.** Recommendation for a separate user host is an architectural inference. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))                                                                                                       |
| Microsoft, `ServiceBase`                                 | Current .NET API documentation retrieved July 2026                            | Service lifecycle and noninteractive account behavior                                                       | **Fact.** ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicebase?view=net-11.0-pp "https://learn.microsoft.com/en-us/dotnet/api/system.serviceprocess.servicebase?view=net-11.0-pp"))                                                                                                                                                                    |
| Microsoft, `WTSQueryUserToken`                           | Last updated 13 October 2021                                                  | LocalSystem and `SE_TCB_NAME` requirement                                                                   | **Fact.** Avoiding this mechanism by default is a least-privilege inference. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken"))                                                                                                           |
| Microsoft, `LoadUserProfile`                             | Last updated 20 November 2024                                                 | Impersonation does not automatically load the profile                                                       | **Fact.** ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-loaduserprofilea "https://learn.microsoft.com/en-us/windows/win32/api/userenv/nf-userenv-loaduserprofilea"))                                                                                                                                                                                    |
| Microsoft, .NET plugin and ALC documentation             | .NET 10 documentation retrieved July 2026                                     | ALC dependency isolation and absence of security boundary                                                   | **Fact.** Rejecting ALC as a collector boundary follows directly. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support "https://learn.microsoft.com/en-us/dotnet/core/tutorials/creating-app-with-plugin-support"))                                                                                                                          |
| Microsoft, Job Objects / restricted token / AppContainer | AppContainer last updated 8 July 2025; related Win32 docs retrieved July 2026 | Process-tree, resource, token, file and network containment                                                 | **Fact.** Exact combination needs endpoint prototyping. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects"))                                                                                                                                                                        |
| Microsoft .NET support policy                            | .NET 10.0.10 current 14 July 2026; support through 14 November 2028           | Runtime baseline and servicing model                                                                        | **Fact.** OS compatibility remains an unknown. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))                                                                                                                                                                                       |
| The Update Framework specification                       | TUF 1.0.35, 15 July 2026                                                      | Key roles, rollback/freeze/mix-and-match protection and update threat model                                 | **Fact.** Using a TUF-conformant or TUF-derived repository is a recommendation. ([GitHub](https://github.com/theupdateframework/specification/blob/master/tuf-spec.md "https://github.com/theupdateframework/specification/blob/master/tuf-spec.md"))                                                                                                                                               |
| Microsoft Authenticode timestamping                      | Current documentation retrieved July 2026                                     | Authorship, integrity, SHA-256 and RFC 3161 timestamping                                                    | **Fact.** Authenticode being insufficient as an update protocol is an inference from its defined scope. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccrypto/time-stamping-authenticode-signatures "https://learn.microsoft.com/en-us/windows/win32/seccrypto/time-stamping-authenticode-signatures"))                                                                      |
| SQLite WAL and PRAGMA documentation                      | Current SQLite documentation retrieved 30 July 2026                           | WAL persistence, checkpointing, FULL/NORMAL durability, page cap, integrity check                           | **Fact.** `synchronous=FULL` is the recommended default because the outbox’s purpose is power-loss durability. ([SQLite](https://www.sqlite.org/wal.html "https://www.sqlite.org/wal.html"))                                                                                                                                                                                                        |
| SQLite corruption and SEE documentation                  | Current documentation retrieved 30 July 2026                                  | Corruption limits and encryption limitations                                                                | **Fact.** Baseline use of BitLocker/ACL rather than SEE is a threat-model and operations recommendation. ([SQLite](https://www.sqlite.org/howtocorrupt.html "https://www.sqlite.org/howtocorrupt.html"))                                                                                                                                                                                            |
| RFC 9110                                                 | June 2022, Internet Standard HTTP semantics                                   | Idempotent retry requirements                                                                               | **Fact.** Event-level idempotency design is the application inference. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html "https://www.rfc-editor.org/rfc/rfc9110.html"))                                                                                                                                                                                                                    |
| RFC 9562                                                 | May 2024                                                                      | UUIDv7                                                                                                      | **Fact.** Use of UUIDv7 plus explicit sequence is a recommendation. ([RFC Editor](https://www.rfc-editor.org/info/rfc9562/ "https://www.rfc-editor.org/info/rfc9562/"))                                                                                                                                                                                                                             |
| ASP.NET Core 10 request decompression                    | Current July 2026 documentation                                               | Decompressed request limits and bomb containment                                                            | **Fact.** Exact batch limits are provisional. ([Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/aspnet/core/fundamentals/middleware/request-decompression?view=aspnetcore-10.0"))                                                                                              |
| Protocol Buffers proto3 guide                            | Current documentation retrieved July 2026                                     | Field-number/name reservation and privacy/corruption risk                                                   | **Fact.** Strict JSON is still the provisional default because binary efficiency is unproven. ([Protocol Buffers](https://protobuf.dev/programming-guides/proto3/ "https://protobuf.dev/programming-guides/proto3/"))                                                                                                                                                                               |
| Microsoft TPM key attestation                            | Last updated 12 May 2025                                                      | Nonexportability and assurance properties                                                                   | **Fact.** Requiring TPM for every device is not recommended until compatibility is measured. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/tpm-key-attestation"))                                                       |
| Microsoft VDI device identity guidance                   | Current documentation retrieved July 2026                                     | Nonpersistent VDI registration and stale identity behavior                                                  | **Fact.** Enrollment-epoch model is the recommended UAM adaptation. ([Microsoft Learn](https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure "https://learn.microsoft.com/en-us/entra/identity/devices/howto-device-identity-virtual-desktop-infrastructure"))                                                                              |
| Azure Service Bus duplicate detection                    | Current documentation retrieved July 2026                                     | Ten-minute default and seven-day maximum dedup history                                                      | **Fact.** This is evidence that broker dedup cannot replace application idempotency. ([Microsoft Learn](https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection "https://learn.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection"))                                                                                                                     |
| PostgreSQL 18 documentation                              | Version 18                                                                    | Queue-like `SKIP LOCKED`, partitioning and global uniqueness constraints                                    | **Fact.** PostgreSQL remains a credible option; not selecting it by default is a transition-risk inference. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html "https://www.postgresql.org/docs/current/sql-select.html"))                                                                                                                                                       |
| SQL Server 2025 documentation                            | SQL Server version 17/2025                                                    | Partitioning and managed bulk loading                                                                       | **Fact.** Provisional preference derives from the existing estate, not a claim that SQL Server is inherently superior. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver17")) |
| SQL Server Ledger                                        | Last updated 7 August 2025                                                    | Append-only audit, cryptographic chaining and external digests                                              | **Fact.** Exact audit technology may instead be another tamper-evident store. ([Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17 "https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17"))                                                              |
| EDPB erasure annex                                       | February 2026                                                                 | Backup restoration and repeated deletion/tombstone need                                                     | **Primary regulatory engineering evidence.** Legal applicability and exact response periods require counsel/controller decisions. ([EDPB](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf "https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_annex_en.pdf"))                                                 |
| OpenTelemetry semantic conventions                       | Version 1.43.0                                                                | Cross-component observability naming                                                                        | **Fact.** Which backend to use remains an implementation choice. ([OpenTelemetry](https://opentelemetry.io/docs/specs/semconv/ "https://opentelemetry.io/docs/specs/semconv/"))                                                                                                                                                                                                                     |

## Final decision

**Revise rather than replace.**

The strongest defensible default is:

> **Per-session least-privilege collection with a stable endpoint privacy gate; a low-privilege machine service owning a transactional SQLite outbox and device identity; bounded idempotent mTLS delivery; a transactional central SQL inbox as the initial durable queue; idempotent workers; provisional SQL Server 2025 storage; independent control, data, and release planes; and transactional, externally verifiable audit and deletion-aware disaster recovery.**

The external broker, PostgreSQL migration, autonomous privileged updater, AppContainer, and lakehouse should remain **explicit escalation decisions**, each activated by a measured requirement rather than included pre-emptively.
