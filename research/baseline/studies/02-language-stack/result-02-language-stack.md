# Language and technology-stack decision

## Executive decision

**[Recommendation] Adopt the proposal’s core stack, with one major architectural correction: use C#/.NET 10 across the endpoint and server, ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))rvice.**

The defensible default is:

| Component               | Default technology                                                                       | Exact responsibility                                                                                |
| ----------------------- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Installer/bootstrap     | MSI; WiX 7 subject to license approval; signed C# bootstrap                              | Initial installation, service registration, ACLs, Event Log source, enrollment                      |
| Privileged updater      | C# 14, self-contained .NET 10 Windows Service                                            | Download, signature and metadata verification, version activation, rollback                         |
| Agent service           | C# 14, self-contained .NET 10 Windows Service                                            | Scheduling, local state, SQLite outbox, batching, device identity, HTTPS, health                    |
| User-session collector  | C# 14, .NET 10 process running as the signed-in user                                     | Browser-history and Recent Items access; normally collect-and-exit rather than permanently resident |
| Collector/task host     | C# 14, separate restricted process                                                       | Executes one verified collector/task with time, memory, CPU and capability limits                   |
| Compatibility task host | PowerShell 7.6.4 LTS, optional package                                                   | Strictly bounded legacy scripts that cannot yet be economically rewritten                           |
| Local persistence       | `Microsoft.Data.Sqlite.Core` plus explicitly pinned SQLite 3.53.4-or-newer native engine | Transactional outbox, checkpoints, task/config state                                                |
| Wire protocol           | Versioned JSON using `System.Text.Json` source generation; gzip over HTTPS               | Endpoint ingestion and control contracts                                                            |
| Ingestion/control APIs  | ASP.NET Core 10 / C# 14                                                                  | Device ingestion, enrollment, control plane, portal BFF                                             |
| Workers                 | .NET 10 hosted services                                                                  | Batch validation, normalization, fact loading, integration delivery                                 |
| Default queue           | PostgreSQL durable inbox/job tables                                                      | Transactional receipt, retries, replay, dead-letter states                                          |
| Central database        | PostgreSQL 18.4; Npgsql 10; EF Core 10 only where appropriate                            | Control data, audit, queue, partitioned event facts                                                 |
| Portal                  | React 19.2.7, TypeScript 6.0.3, Vite 8.1; Node 24 LTS build-only                         | Modern administration portal                                                                        |
| Observability           | OpenTelemetry SDKs and Collector                                                         | Server traces, metrics and structured logs; privacy-safe endpoint health telemetry                  |
| Production Rust/Go      | None in the default                                                                      | Add only after a measured proof shows a boundary where they materially outperform the default       |

.NET 10 is the current LTS line, at patch 10.0.10 in July 2026, and is supported through November 14, 2028. C# 14 is the corresponding language version. A self-contained endpoint is appropriate, but the product—not Windows Update—must then deploy each .NET security patch to the fleet. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))fication used below

- **[Fact]** Source-backed current or legacy behavior.

- **[Assumption]** A condition that must be validated locally.

- **[Estimate]** A score, capacity target or proposed threshold.

- **[Recommendation]** The proposed engineering decision.

### Material assumptions

**[Assumption]** The primary fleet is supported Windows 11 Enterprise x64, with possible RDS/Citrix and non-persistent VDI. The organization can run Linux-hosted .NET services and PostgreSQL, can provide an OIDC identity provider, and has stronger PowerShell/SQL experience than Rust-specific systems experience.

**[Assumption]** UAM is an activity and inventory product, not a high-frequency EDR sensor. Browser, Recent Item and process events are collected on policy-controlled intervals rather than requiring lossless kernel-level capture of every sub-second process.

**[Assumption]** URLs, paths and process metadata are sensitive personal or organizational data. A value rejected by endpoint policy must never enter the local outbox, diagnostic logs, support bundle or upload payload.

---

# 1. What the legacy implementation means for the migration

## Findings from the attached code

**[Fact—legacy]** This is substantially more than a PowerShell-to-C# rewrite:

- The endpoint constructs and executes SQL directly against MSSQL, carries a database connection string, and persists deferred **SQL statements** in CSV.

- Checkpoints, user eligibility, collector settings, process status and runtime diagnostics are mixed into `DeviceLoggingUsers`.

- Browser collection P/Invokes the Windows `winsqlite3.dll`, falls back to a bundled executable, recursively discovers profile databases and normally selects one candidate.

- Browser, Recent Item and process collection depend on the signed-in user’s profile and session.

- Recent Item processing dereferences shortcut targets with `Test-Path` and `Get-Item`, potentially causing access to unavailable or remote targets.

- Configuration can provide `PSCode`, which is passed to `Invoke-Expression`.

- The PSU application performs direct SQL CRUD, cross-joins UAM data with AD and HR data, changes AD group membership, embeds JavaScript, and constructs SQL strings in UI callbacks.

- The schema contains event tables without durable event IDs or ingestion idempotency keys, arbitrary script bodies and schedules, control settings, archive tables, audit data and very wide imported directory/HR projections. ctural consequences

**[Recommendation] A Windows Service alone is not sufficient.** Microsoft’s supported pattern for service software needing interaction with a signed-in user is a separate application running in that user’s session and communicating through IPC. Default named-pipe security is broader than UAM should accept, so the pipe must have an explicit descriptor scoped to the service SID and exact logon SID. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/interactive-services "https://learn.microsoft.com/en-us/windows/win32/services/interactive-services"))ndation] Do not port the legacy SQL schema one-for-one.** In particular:

- `DeviceLoggingUsers` should become separate device, installation, session, assignment, agent-health and collector-checkpoint concepts.

- The detailed event tables need stable event identities, batch identities, policy revisions and idempotency constraints.

- `uam_log_minimal` should become a server-derived aggregate rather than endpoint-generated `IF NOT EXISTS` SQL.

- Settings should become typed, revisioned configuration documents.

- `DeviceScripts.Script_Code` must not be migrated as remotely executable arbitrary code. Approved scripts become signed task packages with explicit capabilities.

- The broad AD/HR tables should become narrow directory and organization projections or domain APIs, not be copied wholesale into the new UAM database.

**[Recommendation] During coexistence, project new server-side events into temporary legacy SQL Server compatibility tables.** Do not make the new endpoint dual-write to HTTPS and MSSQL. A server-side compatibility projector is safer, observable and removable.

---

# 2. Weighted language decision

## Weighting rationale

| Criterion                                    | Weight   | Rationale                                                                                                                              |
| -------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Windows endpoint and API fit                 | 22%      | The product’s differentiating work is Windows-specific: services, sessions, COM, Event Log, ACLs, CNG, browser profiles and deployment |
| Security, updater and isolation              | 14%      | The updater and remotely assignable tasks are privileged attack surfaces                                                               |
| Browser access and local persistence         | 11%      | SQLite snapshot correctness and profile edge cases are core data-quality risks                                                         |
| Memory, startup and deployment footprint     | 10%      | Important across 6,000 devices and especially multi-session hosts, but not at the expense of correctness                               |
| Networking, contracts, telemetry and testing | 9%       | Required for reliable offline replay and long-lived schema evolution                                                                   |
| Lifecycle, supply chain and maintainability  | 15%      | The intended life is seven to ten years                                                                                                |
| Server platform and operations               | 10%      | Significant, but the server has fewer platform constraints than the endpoint                                                           |
| Legacy migration fit                         | 9%       | Current behavior and staff knowledge materially affect delivery risk                                                                   |
| **Total**                                    | **100%** |                                                                                                                                        |

## Decision matrix

**[Estimate]** Scores are 1–5. They measure fitness for this UAM design, not language quality in general. An uncertainty of roughly ±0.3 applies to individual scores until the proof-of-technology is completed.

| Candidate                           | Windows 22 | Security 14 | Local 11 | Footprint 10 | Network/test 9 | Lifecycle 15 | Server 10 | Migration 9 | Weighted total |
| ----------------------------------- | ---------- | ----------- | -------- | ------------ | -------------- | ------------ | --------- | ----------- | -------------- |
| **C#/.NET first**                   | 5.0        | 4.5         | 4.7      | 3.5          | 4.8            | 4.8          | 4.9       | 5.0         | **93.8/100**   |
| **C# plus Rust at hard boundaries** | 4.7        | 4.8         | 4.6      | 4.3          | 4.6            | 3.6          | 4.9       | 4.1         | **89.1/100**   |
| **Rust first**                      | 3.7        | 4.7         | 4.5      | 4.9          | 4.2            | 3.3          | 3.8       | 2.9         | **79.4/100**   |
| **Go first**                        | 3.3        | 4.0         | 3.8      | 4.5          | 4.7            | 4.0          | 4.5       | 3.1         | **78.1/100**   |

### C#/.NET

**[Fact]** .NET has first-party Windows Service hosting, Windows interop, certificate authentication, Event Log integration, ASP.NET Core authentication and rate limiting, resilient HTTP handlers, SQLite and PostgreSQL providers, and OpenTelemetry support. ASP.NET Core and EF Core follow the .NET support lifecycle. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/extensions/windows-service "https://learn.microsoft.com/en-us/dotnet/core/extensions/windows-service"))ndation]** It wins because the same runtime covers the difficult Windows portions and the server without forcing one shared deployment model. The legacy PowerShell code also already depends heavily on .NET objects, COM and Windows APIs, reducing conceptual migration risk.

### Rust

**[Fact]** Microsoft’s `windows-rs` provides Windows API bindings, and Rust offers strong native footprint and memory-safety properties. The trade-off is its toolchain support model: Rust supports the latest stable toolchain rather than offering a multi-year LTS line, with stable releases on a rapid cadence. Rust 1.97.1 was the current stable patch in mid-July 2026. ([blog.rust-lang.org](https://blog.rust-lang.org/releases/latest/ "https://blog.rust-lang.org/releases/latest/"))ndation]** Rust is competitive for a small, security-sensitive, natively constrained process. It is not the default for UAM because it would add COM/Win32 binding work, a second operational toolchain and a second staffing requirement without removing the need for .NET on the server.

### Go

**[Fact]** Go provides Windows Service and Event Log support through `x/sys/windows`, and it is an excellent fit for network services. Its Windows plugin mechanism is not supported, however, making a Windows Go design dependent on out-of-process task protocols. The common `go-sqlite3` driver also requires CGO and a C compiler, while pure-Go alternatives create a separate SQLite compatibility and performance validation obligation. ([Go Packages](https://pkg.go.dev/plugin "https://pkg.go.dev/plugin"))ndation]** Go would be more attractive if UAM became a generic uploader with little COM, user-profile or Windows-security work. That is not the current product.

### Mixed C# and Rust

**[Recommendation]** A mixed implementation is credible only across an operating-system process boundary. Do not create an in-process C#↔Rust FFI layer for ordinary collectors. The added ABI, crash, debugging and release coupling would remove much of the isolation benefit.

A reasonable mixed variant is:

- C# service, session orchestration, updater, APIs and workers.

- Rust executable for one proven high-risk parser or ultra-low-footprint continuous sensor.

- Versioned JSON or length-prefixed IPC between them.

- Independent package signatures and SBOMs.

- At least two maintainers capable of reviewing unsafe Rust and Windows bindings.

## Sensitivity analysis

| Scenario                            | Material weighting change                                       | .NET     | Mixed    | Rust     | Go   | Result                                                  |
| ----------------------------------- | --------------------------------------------------------------- | -------- | -------- | -------- | ---- | ------------------------------------------------------- |
| Baseline UAM                        | As above                                                        | **93.8** | 89.1     | 79.4     | 78.1 | .NET                                                    |
| Hard endpoint footprint/isolation   | Footprint 25%, security 20%; lifecycle/server/migration reduced | 89.1     | **89.2** | 84.5     | 80.1 | Statistical tie; PoT decides                            |
| Seven-to-ten-year staffing emphasis | Lifecycle 25%, migration 12%                                    | **95.2** | 86.9     | 76.2     | 77.1 | .NET strengthens                                        |
| Extreme native sensor               | Footprint 60%, security 20%, Windows fit only 5%                | 79.5     | 88.4     | **92.3** | 85.1 | Rust wins, but this is no longer the stated UAM product |

**[Recommendation]** Change the default to mixed C#/Rust only if the proof shows that .NET fails a genuinely hard endpoint budget—for example a total always-resident budget below roughly 50 MB on multi-session hosts—and a Rust prototype meets that budget without compromising Windows correctness or supportability.

---

# 3. Endpoint stack

## 3.1 Process and privilege architecture

### `UamAgentService`

**[Recommendation]**

- C# 14 / .NET 10.

- Windows Service using `Microsoft.Extensions.Hosting.WindowsServices`.

- Runs as `NT SERVICE\UamAgent` or an equivalent virtual service account with a restricted service SID.

- Owns `%ProgramData%\UAM\state`, the device private key ACL, the SQLite outbox and all network communication.

- Does not run as LocalSystem.

- Does not load remotely supplied assemblies into its process.

- Does not access arbitrary user-profile files.

### `UamSessionHost`

**[Recommendation]**

- Runs under the interactive user token.

- Identity is the Windows user SID plus session ID, not mutable `DOMAIN\username`.

- Launched at logon and periodically through a machine-installed Task Scheduler definition.

- Normally collects browser and Recent Item data, sends filtered events to the service and exits.

- A persistent user process is permitted only if polling-based process collection proves necessary.

- One host per active user session on RDS/Citrix; never assume session 1 or a single console user.

This avoids interactive-service behavior and keeps private profile access in the user’s security context. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/interactive-services "https://learn.microsoft.com/en-us/windows/win32/services/interactive-services"))*[Recommendation]**

Use `System.IO.Pipes` with:

- One pipe namespace per session.

- Explicit `PipeSecurity` granting access only to the exact logon SID and UAM service SID.

- A fresh service-generated nonce on each connection.

- Length-prefixed versioned messages with maximum sizes.

- Peer PID, session and token validation before accepting data.

- No passwords, database credentials or reusable bearer tokens over the pipe.

Do not rely on the default named-pipe ACL. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights "https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights"))daterService`

**[Recommendation]**

- Separate minimal C# service.

- Runs as LocalSystem only because it must replace Program Files binaries and service definitions.

- Has no collector, database-query, portal or arbitrary-task functionality.

- Accepts only a narrow local command set: stage, verify, activate, rollback and report status.

- Does not accept update paths or command lines from an unprivileged process without validating them against signed metadata.

### `UamTaskHost`

**[Recommendation]**

Every modular or risky task runs in a separate process with:

- Restricted token and reduced integrity level.

- AppContainer/no-network execution where the required Windows APIs permit it.

- Explicit filesystem ACLs.

- Job Object limits for process count, memory, CPU time and child termination.

- Wall-clock timeout and output-size limit.

- One task per process by default.

- A brokered capability API for the small number of privileged operations.

Windows Job Objects are useful for resource and child-process containment, but they are not a complete security boundary by themselves. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects")) operations must be compiled first-party broker methods—not arbitrary “run elevated” tasks.

## 3.2 Runtime and deployment mode

**[Recommendation]**

Use a self-contained, multi-file `win-x64` .NET 10 deployment:

```text
TargetFramework: net10.0-windows
RuntimeIdentifier: win-x64
SelfContained: true
PublishSingleFile: false
PublishTrimmed: false
PublishReadyToRun: false initially
ServerGarbageCollection: false
```

Reasons:

- Self-contained deployment gives a known runtime and avoids dependency on a separately installed machine runtime.

- Multi-file deployment is easier to inspect, sign, repair, update and diagnose than one opaque single file.

- Trimming is risky around COM, serializers, reflection and dynamically selected collectors.

- NativeAOT currently restricts dynamic loading, runtime code generation and built-in COM support and has diagnostic limitations. Those restrictions conflict with UAM’s Windows integration and support needs. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/ "https://learn.microsoft.com/en-us/dotnet/core/deploying/native-aot/"))n should be tested only for a short-lived SessionHost if cold start fails its target; it needlessly increases installed size for an always-running service.

A self-contained runtime means each Microsoft .NET patch must produce a new signed agent build. Automate monthly rebuild, test and staged rollout; do not leave the embedded runtime unpatched. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))al SQLite outbox

### Library and engine

**[Recommendation]**

Use:

- `Microsoft.Data.Sqlite.Core` 10.x.

- A separately pinned native SQLite engine built from the official amalgamation, initially **3.53.4 or newer**.

- A startup assertion of `sqlite3_libversion()`; fail closed or enter diagnostic-only mode if the loaded engine is older than the approved floor.

- An SBOM and reproducible build for the native DLL.

Do not use the operating system’s `winsqlite3.dll`, because the product cannot control or attest its patch level. Recent SQLite releases corrected a long-lived WAL-reset corruption problem; the current 3.53.4 release was published July 24, 2026. ([SQLite](https://www.sqlite.org/changes.html "https://www.sqlite.org/changes.html")).Data.Sqlite` is a lightweight ADO.NET provider. SQLite does not provide true asynchronous file I/O through these APIs, so UAM should use one dedicated writer queue instead of wrapping every call in nominally asynchronous methods. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/ "https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/"))se settings

**[Recommendation]**

At creation/open:

```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = FULL;
PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;
PRAGMA trusted_schema = OFF;
```

Use:

- Exactly one long-lived writer connection.

- Short `BEGIN IMMEDIATE` write transactions.

- No shared cache.

- Prepared parameterized SQL only.

- Bounded connection pooling, or no pooling if tests show lifecycle ambiguity.

- `PRAGMA quick_check` after an unclean shutdown.

- A controlled checkpoint policy rather than many competing checkpointers.

`FULL` synchronous mode in WAL is the correct initial durability choice for an outbox whose purpose is surviving crashes and power loss. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))schema

**[Recommendation]**

Use separate tables for:

| Table                    | Purpose                                                                        |
| ------------------------ | ------------------------------------------------------------------------------ |
| `collector_checkpoint`   | Source instance, timestamp, source row ID, scan generation and policy revision |
| `event_outbox`           | Immutable filtered events and deterministic deduplication key                  |
| `upload_batch`           | Batch ID, selected event range, attempts, status and receipt                   |
| `configuration_snapshot` | Last verified signed configuration revision                                    |
| `task_package`           | Verified package metadata, hashes and activation state                         |
| `task_run`               | Task execution outcome and bounded diagnostic output                           |
| `agent_state`            | Installation ID, current version, unclean-shutdown marker                      |
| `schema_history`         | Local migrations and checksums                                                 |

Never store SQL statements for later execution.

### Transactional checkpoint rule

**[Recommendation]**

A collector must insert its events and advance its checkpoint in the **same SQLite transaction**:

1. Read the prior checkpoint.

2. Scan with a controlled overlap window.

3. Normalize and privacy-filter.

4. Insert events with deterministic deduplication keys.

5. Advance `(source timestamp, source row ID, source-instance ID)`.

6. Commit.

A timestamp alone is insufficient because multiple visits or process records may share a timestamp. Browser source row IDs such as Chromium `visits.id` or Firefox history-visit IDs should be incorporated where available.

Uploading is a separate state transition:

1. Select unbatched events.

2. Create an immutable `batch_id`.

3. Commit the batch assignment locally.

4. POST it idempotently.

5. Mark the batch acknowledged only after a durable server receipt.

6. Delete or compact acknowledged events later.

A timeout after submission therefore causes replay of the same batch, not construction of a different batch.

### Disk-pressure behavior

**[Estimate and recommendation]**

Start with a 1 GiB configurable outbox cap and tune from field traces. At approximately:

- 80%: lengthen non-critical collection intervals.

- 90%: pause detailed browser and Recent Item collection.

- 95%: preserve status, minimum inventory and task/update control only.

Do not silently drop an event and still advance its source checkpoint. Record an auditable `collection_paused_disk_pressure` diagnostic.

### Local encryption

**[Recommendation]**

- Protect the database directory with service-SID ACLs.

- Encrypt sensitive payload blobs using AES-GCM.

- Generate a per-installation data-encryption key.

- Seal the key with a non-exportable machine CNG key, TPM-backed through the Platform Crypto Provider when available.

- Use DPAPI machine scope only as a fallback wrapper, not as a substitute for ACLs and key lifecycle management.

Windows supports TPM-backed keys through CNG, while DPAPI offers user- and machine-scoped protection. A local administrator remains part of the endpoint trust boundary; no local encryption scheme can make a fully compromised administrator harmless. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers "https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers"))lectors

### Browser history

**[Recommendation]**

Implement adapters for Edge/Chromium, Chrome/Chromium and Firefox with these rules:

- Discover Chromium profiles through the browser’s profile metadata and `Local State`; discover Firefox profiles through `profiles.ini`.

- Enumerate all eligible profiles. Do not select only the most recently modified history file.

- Assign each profile database a source-instance identity.

- Never copy cookies, login stores, extension data or unrelated browser files.

- First attempt a read-only connection or SQLite backup operation.

- If the live database cannot be opened safely, copy the main file with its `-wal` and `-shm` companions into a user-private temporary directory.

- Run `quick_check` on the snapshot; retry the snapshot if it is inconsistent.

- Query feature/schema availability rather than assuming one fixed browser schema.

- Keep versioned SQL adapters and fixture databases for supported browser generations.

- Apply URL/domain exclusions before IPC and before the outbox.

- Never put a rejected full URL in an error message.

### Recent Items

**[Recommendation]**

Use the Shell Link COM interfaces from the user-session process to parse `.lnk` files. Do not call `Test-Path`, open the target or retrieve live file metadata by default.

That change matters because the legacy behavior may:

- Trigger access to a disconnected UNC path.

- Cause authentication attempts to a remote server.

- Block on unavailable storage.

- Reveal that UAM inspected a target.

- Change resource timestamps in unusual environments.

Collect the link’s own timestamps and embedded target path. Access the target only under an explicit, separately approved policy.

### Processes

**[Recommendation]**

Use the PoT to choose between:

1. **Legacy-parity polling:** Session-scoped `System.Diagnostics.Process` enumeration with overlap and dedupe.

2. **Service ETW:** Process-start events collected centrally, immediately mapped to session/user and privacy-filtered.

3. **Hybrid:** ETW for start/name/session and user-context enrichment only when required.

Start with polling if missing very short-lived processes is acceptable. Choose ETW only if measured business requirements justify its privilege and implementation complexity. Never retain system-wide events and filter them only after upload.

Preserve the legacy default field set—name, path, product and company—rather than silently adding command lines or loaded modules.

## 3.5 Contracts, batching and HTTP

**[Recommendation]**

Use a versioned JSON envelope:

```text
batchId
tenantId
deviceId
installationId
agentVersion
schemaVersion
configurationRevision
createdAtUtc
compression
events[]
```

Each event contains:

```text
eventId
dedupeKey
eventType
eventSchemaVersion
occurredAtUtc
collectedAtUtc
userSid or pseudonymous user key
sessionId
sourceInstanceId
policyRevision
payload
```

Use:

- UUIDv7 for batches and ordinary events.

- A deterministic source dedupe key for overlap/re-scan protection.

- `System.Text.Json` source generation.

- UTC timestamps plus the original offset only where analytically necessary.

- Additive contract evolution within a major version.

- Explicit server support for at least the current and two previous event schema versions.

- Gzip initially; do not introduce Protobuf or CBOR unless measured payload cost justifies the added contract/tooling complexity.

- An initial batch limit of **1 MiB compressed or 1,000 events**, whichever comes first, subject to PoT tuning.

ASP.NET Core 10 supports OpenAPI 3.1 for the control-plane APIs. ([Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-10.0?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-10.0?view=aspnetcore-10.0")) use `IHttpClientFactory` and `Microsoft.Extensions.Http.Resilience` with:

- Exponential backoff and full jitter.

- `Retry-After` support.

- Retries only for idempotent requests.

- Randomized fleet scheduling.

- Circuit breaking for persistent failures.

- A bounded retry interval, initially 30 minutes.

- Immediate continuation of local collection while offline, subject to disk pressure. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience "https://learn.microsoft.com/en-us/dotnet/core/resilience/http-resilience"))ice enrollment and authentication

**[Recommendation]**

Use per-device X.509 client certificates:

1. Installer generates the private key locally in machine CNG storage.

2. Use TPM-backed non-exportable storage where supported.

3. A short-lived, one-time enrollment token supplied through Intune, SCCM or the customer deployment system authorizes the CSR.

4. The server issues a short-lived device certificate.

5. The endpoint uses mTLS for ingestion and control-plane polling.

6. Certificates rotate automatically before expiry.

7. Revocation is reflected in the control plane and gateway.

Do not:

- Bake a tenant enrollment secret into a universal MSI.

- Reuse one certificate across a fleet.

- use the computer name as the cryptographic identity.

- store a server API token in a PowerShell file.

- issue database credentials to an endpoint.

ASP.NET Core provides certificate-authentication support, and OAuth security guidance supports keeping user-facing authorization flows distinct from device credentials. ([Microsoft Learn](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/certauth?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/aspnet/core/security/authentication/certauth?view=aspnetcore-10.0"))ging, diagnostics and telemetry

**[Recommendation]**

Endpoint logging has three destinations:

- **Windows Event Log:** service lifecycle, update security events, enrollment and fatal failures.

- **Bounded structured JSON files:** rotating diagnostic details, with a strict redaction layer.

- **Health events through the outbox:** version, queue age, queue size, collector status and update outcome.

Do not upload:

- Raw URLs, paths or process names as OpenTelemetry span attributes.

- HTTP bodies.

- Certificates or private-key metadata.

- Usernames when a SID-derived pseudonymous key is sufficient.

- Full task stdout/stderr without filtering and size limits.

A support bundle must include a manifest showing every file and redaction rule and must be tested with seeded secrets.

## 3.8 Packaging, signing and updater

### MSI

**[Recommendation]**

Use MSI for:

- Initial install.

- Enterprise detection and inventory.

- Silent install, repair and uninstall.

- Service and scheduled-task registration.

- Event Log source creation.

- ACL provisioning.

- Major bootstrap/updater changes.

WiX 7.0.0 was released in April 2026 but uses the Open Source Maintenance Fee licensing model. Legal/procurement approval is therefore an ADR prerequisite. If it is not approved, use an organization-approved commercial MSI authoring tool rather than freezing on an unsupported WiX line. ([GitHub](https://github.com/wixtoolset/wix/releases/ "https://github.com/wixtoolset/wix/releases/"))d updates

**[Recommendation]**

The MSI installs a small stable bootstrap and updater. Application releases live in versioned directories:

```text
C:\Program Files\UAM\bootstrap\
C:\Program Files\UAM\versions\10.4.2\
C:\Program Files\UAM\versions\10.4.3\
C:\ProgramData\UAM\update-staging\
```

Update flow:

1. Poll signed release metadata for the assigned ring.

2. Download with BITS to a staging directory.

3. Verify metadata expiry, version monotonicity, artifact length and hashes.

4. Verify Authenticode on every PE/DLL and the MSI.

5. Verify the package is authorized by threshold-signed root/targets metadata.

6. Stop or drain tasks.

7. Activate by atomic pointer/configuration change.

8. Start and run a bounded health check.

9. Roll back automatically if startup or migration fails.

10. Retain at least one known-good version.

BITS supports resumable transfers across network interruptions and reboot, making it appropriate for endpoint updates. SignTool and `WinVerifyTrust` provide Windows artifact signing and runtime signature verification. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/bits/background-intelligent-transfer-service-portal "https://learn.microsoft.com/en-us/windows/win32/bits/background-intelligent-transfer-service-portal"))style trust model with offline root keys, threshold signatures, expiring timestamp/snapshot metadata and explicit rollback/freeze protection. These protections address risks that Authenticode alone does not solve, such as serving an old but validly signed vulnerable release. ([The Update Framework](https://theupdateframework.github.io/specification/latest/ "https://theupdateframework.github.io/specification/latest/"))that require all software changes through Intune/SCCM must be able to disable autonomous payload activation and consume the same signed release as an enterprise package.

## 3.9 PowerShell’s bounded role

**[Recommendation] PowerShell remains a compatibility mechanism, not an application runtime.**

Permitted:

- One-time deployment detection or migration helpers.

- A separately installed PowerShell 7.6 compatibility task host.

- Signed and hash-allowlisted scripts.

- Explicit input/output schemas.

- Fixed timeout, memory and output limits.

- No network by default.

- No database credentials.

- No access to updater keys.

- A capability manifest reviewed when the package is published.

Forbidden:

- `Invoke-Expression`.

- PowerShell code sourced from database configuration.

- In-process PowerShell inside the agent service.

- Unsigned `.ps1` downloaded through a general task channel.

- Windows PowerShell 5.1 for new product logic.

- Allowing a script to choose its own executable, arguments, working directory or elevation.

PowerShell 7.6.4 is the current LTS line and is supported through November 14, 2028. PowerShell 7.4 and 7.5 both reach end of support on November 10, 2026. ([Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle?view=powershell-7.6 "https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle?view=powershell-7.6"))Server stack

## 4.1 Deployment shape

**[Recommendation] Build a modular monolith with separate deployables, not a microservice estate.**

One repository and solution may contain:

| Deployable                | Responsibility                                                             |
| ------------------------- | -------------------------------------------------------------------------- |
| `Uam.Ingestion.Api`       | mTLS device ingestion, receipt lookup, enrollment and certificate rotation |
| `Uam.Control.Api`         | Device/config/task/release/audit administration                            |
| `Uam.Portal.Bff`          | OIDC login, browser session, CSRF protection and portal APIs               |
| `Uam.Worker.Ingestion`    | Batch validation, normalization, dedupe and fact loading                   |
| `Uam.Worker.Control`      | Assignments, rollout orchestration and command expiry                      |
| `Uam.Worker.Integrations` | Customer-specific directory, HR, ITSM and export adapters                  |
| `Uam.DatabaseMigrator`    | One-shot, versioned migration job                                          |
| React static assets       | Served by the BFF or an approved static-asset tier                         |

They may initially deploy together in two or three containers, while retaining clean module boundaries.

## 4.2 API and authentication

**[Recommendation]**

- ASP.NET Core 10.

- Standard OIDC/OAuth for administrator identities.

- BFF pattern with secure, HttpOnly, SameSite cookies.

- Keep access and refresh tokens server-side, not in browser local storage.

- Policy-based authorization using UAM permissions rather than directly embedding one customer’s group names.

- JWT bearer support for approved machine-to-machine control clients.

- mTLS and device-certificate identity for endpoint APIs.

- Separate hostnames or listener policies for device and administrator traffic.

- Per-device and per-tenant rate limits.

- CSRF protection on BFF mutations.

- Step-up or four-eyes approval for task publication and production update promotion.

ASP.NET Core provides JWT bearer, certificate authentication, OIDC claim mapping and rate limiting. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.jwtbearerextensions.addjwtbearer?view=aspnetcore-10.0 "https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.jwtbearerextensions.addjwtbearer?view=aspnetcore-10.0"))plication permissions:

```text
devices.read
devices.control
policy.read
policy.write
tasks.publish
tasks.assign
releases.promote
audit.read
directory.group.manage
integrations.manage
```

Customer group and role claims map to these permissions through tenant-specific configuration.

## 4.3 Queue and inbox

**[Recommendation] Use PostgreSQL as the default durable inbox.**

Ingestion transaction:

1. Authenticate the device certificate.

2. Validate headers, compressed size and batch envelope.

3. Insert `ingest_batch` with a unique constraint on `(tenant_id, device_id, batch_id)`.

4. Store the compressed body or an immutable object-storage reference.

5. Commit.

6. Return `202 Accepted` and a receipt ID.

A duplicate returns the existing receipt rather than inserting another job.

Workers claim rows using:

```sql
SELECT ...
FROM ingest_batch
WHERE status = 'pending'
ORDER BY received_at
FOR UPDATE SKIP LOCKED
LIMIT ...
```

PostgreSQL explicitly documents `SKIP LOCKED` as suitable for queue-like multiple-consumer access. Npgsql’s binary COPY support is appropriate for moving validated event sets into fact tables efficiently. ([PostgreSQL](https://www.postgresql.org/docs/current/sql-select.html "https://www.postgresql.org/docs/current/sql-select.html"))tempt counters and next-attempt timestamps.

- Exponential retry.

- Lease/heartbeat recovery for dead workers.

- Explicit poison/dead-letter state.

- Batch receipt query API.

- Retention and partitioning for completed inbox records.

- An outbox table for outbound integrations so database commits and external delivery are not dual-written.

### When to add RabbitMQ

**[Estimate and recommendation]** Add RabbitMQ quorum queues only when measured requirements show one or more of:

- Sustained ingestion materially above approximately 1,000 batches per second.

- Many independent consumer teams requiring separate delivery lifecycles.

- Cross-system fan-out that should not share the PostgreSQL failure domain.

- PostgreSQL queue activity causing unacceptable WAL, vacuum or control-plane latency.

- A need for broker-level flow control or geographically independent consumers.

RabbitMQ quorum queues provide replicated Raft-based durable queues, but the open-source community support window for RabbitMQ 4.3.4 ends November 30, 2026. Adopting it therefore creates a fast broker-upgrade cadence and should buy a measured capability rather than be architectural decoration. ([RabbitMQ](https://www.rabbitmq.com/release-information "https://www.rabbitmq.com/release-information"))tgreSQL and data access

**[Recommendation]**

- PostgreSQL **18.4**.

- Npgsql 10.

- EF Core 10 for control-plane aggregates and ordinary CRUD.

- Direct Npgsql commands and binary COPY for ingestion and analytical write paths.

- No universal repository abstraction.

- No EF Core model shared with endpoint SQLite.

- Versioned, reviewed SQL migration files for event partitions, indexes, constraints and retention.

- Migration job obtains a PostgreSQL advisory lock before applying changes.

PostgreSQL 18 is supported through November 14, 2030. PostgreSQL 14 reaches end of support on November 12, 2026 and should not be selected for a new platform. ([PostgreSQL](https://www.postgresql.org/support/versioning/ "https://www.postgresql.org/support/versioning/"))ted central model

Control plane:

```text
tenant
device
device_installation
device_certificate
user_principal_projection
organization_unit_projection
policy
policy_revision
assignment
task_package
task_assignment
task_run
agent_release
release_ring
rollout
audit_event
integration_definition
```

Ingestion:

```text
ingest_batch
ingest_batch_error
outbound_integration_job
```

Partitioned event facts:

```text
browser_visit_event
recent_item_event
process_start_event
agent_health_event
collector_diagnostic_event
```

Use:

- Monthly partitions initially, adjusted by measured volume.

- `received_at_utc` as the operational partition key.

- `occurred_at_utc` as a separate analytical timestamp.

- Typed columns for queried fields.

- `jsonb` only for sparse extension fields, not the entire core model.

- A dedicated unpartitioned or appropriately partitioned idempotency table where global uniqueness is required.

- Partition detach/drop for retention rather than mass deletes.

PostgreSQL supports declarative partitioning, and Npgsql 10 provides the current .NET provider line. ([Npgsql](https://www.npgsql.org/doc/release-notes/10.0.html "https://www.npgsql.org/doc/release-notes/10.0.html"))tal

**[Recommendation]**

Use:

- React 19.2.7.

- TypeScript 6.0.3 initially.

- Vite 8.1.

- Node 24.18.1 LTS in the build pipeline only.

- Generated OpenAPI clients and types.

- React Query-style server-state handling; ordinary React state for local UI concerns.

- Server-side table paging, filtering and sorting.

- Playwright 1.62 for end-to-end tests.

- No Node process in the production runtime.

- No React Server Components in the first portal release; the static SPA plus BFF is operationally simpler.

React 19.2.7 is the current patch line. TypeScript 7.0.2 is current, but TypeScript 7.0 does not yet ship a compiler API and its own release guidance supports running TypeScript 6 side-by-side for tools that need that API. TypeScript 6.0.3 is therefore the lower-risk initial portal compiler; re-evaluate at TypeScript 7.1. ([React](https://react.dev/blog/2025/10/01/react-19-2 "https://react.dev/blog/2025/10/01/react-19-2")).1 was the current Node 24 security patch on July 29, 2026, and Node 24 remains in LTS through April 2028. Vite 8.1 and Playwright 1.62 are the corresponding current tool lines. ([Node.js](https://nodejs.org/en/blog/vulnerability/july-2026-security-releases "https://nodejs.org/en/blog/vulnerability/july-2026-security-releases"))t Blazor as the default

**[Recommendation]** Blazor is viable where no frontend engineering capability exists, but it should not be chosen merely to claim one language. The portal’s data grids, filtering, organization visualization and administrative workflows are normal web-client work. React keeps browser concerns in the browser layer and prevents C# server entities from leaking into the UI.

## 4.6 Observability

**[Recommendation]**

Use OpenTelemetry for server metrics, traces and structured-log correlation:

- ASP.NET Core and outbound HTTP instrumentation.

- Npgsql instrumentation.

- Worker queue lag and job attempts.

- Batch age from endpoint creation to normalized storage.

- API latency and rejection categories.

- PostgreSQL connections, WAL, bloat and vacuum.

- Release rollout and rollback rates.

- Endpoint version distribution.

- Configuration revision adoption.

- Certificate-expiry horizon.

Export OTLP to an OpenTelemetry Collector and then to the organization’s approved backend. This keeps the application independent from a specific commercial APM. ([OpenTelemetry](https://opentelemetry.io/docs/languages/dotnet/ "https://opentelemetry.io/docs/languages/dotnet/"))ot an ordinary log stream. Store append-only audit records with:

```text
tenant
actor subject
actor display snapshot
permission
operation
target
before/after or change set
correlation ID
source IP
user agent
outcome
timestamp
approval reference
```

## 4.7 Deployment and testing

**[Recommendation]**

Server deployment:

- Linux OCI containers.

- Official .NET 10 runtime images.

- Non-root container user.

- Immutable image digests.

- Separate API, worker and migrator images.

- Two or more API replicas and worker replicas.

- Managed PostgreSQL 18 with HA and point-in-time recovery where available.

- Kubernetes is optional; two well-operated Linux hosts behind a load balancer are sufficient at this scale.

- No Node or browser build tooling in runtime images.

- Secrets from the platform secret store.

- SBOM and signed provenance per release.

Testing:

- xUnit v3 for .NET tests.

- Real PostgreSQL integration tests in disposable containers.

- Contract fixtures for every accepted endpoint schema.

- Duplicate/replay and property-based tests.

- Migration tests against a production-shaped anonymized schema.

- Playwright for portal authorization and critical workflows.

- Trace-derived load tests rather than synthetic microbenchmarks as product evidence.

- Fault injection for database restarts, delayed acknowledgements, duplicate HTTP delivery and worker death.

---

# 5. Migration strategy

## 5.1 Preserve behavior, not implementation

**[Recommendation]** Define canonical event and control contracts from the legacy evidence before translating code. Preserve:

- Browser inclusion/exclusion semantics.

- Detailed versus minimum collection modes.

- Per-user and per-device assignments.

- Non-persistent VDI behavior.

- Checkpoint overlap and resumption.

- Process field meanings.

- Admin audit requirements.

- Existing analytical views where they remain legitimate.

Do not preserve:

- Endpoint database credentials.

- SQL text as an event format.

- `Invoke-Expression`.

- Arbitrary database-hosted PowerShell.

- Computer name as the device primary key.

- Central checkpoint advancement before durable endpoint acknowledgement.

- UI components that directly construct SQL.

- `NOLOCK`-based business behavior.

- Dereferencing Recent Item targets.

## 5.2 SQL Server coexistence

The PSU application currently depends on T-SQL and same-database joins to AD and HR projections. PostgreSQL is therefore not a zero-cost substitution.

**[Recommendation]**

1. Create narrow `DirectoryPerson`, `EmploymentSummary` and `OrganizationUnit` integration contracts.

2. Synchronize only required fields into PostgreSQL or query an authoritative domain API.

3. Temporarily retain a server-side compatibility projector that writes new UAM status/events into legacy SQL Server tables.

4. Point the existing PSU portal at compatibility views during endpoint rollout.

5. Reconcile counts and hashes between new facts and compatibility tables.

6. Replace PSU features with control APIs one bounded workflow at a time.

7. Retire compatibility writes after all consumers are identified and migrated.

**Decision gate:** If same-instance transactional joins to existing HR/AD data must remain for several years and the organization cannot build those projections, retaining SQL Server centrally for phase one is more defensible than pretending that PostgreSQL migration risk does not exist. That changes the database decision, not the C# language decision.

## 5.3 Configuration and tasks

Legacy:

```text
global setting
+ user/computer columns
+ user override rows
+ executable PSCode
```

Replacement:

```text
typed policy document
+ immutable revision
+ assignment scope
+ effective-from/expiry
+ endpoint acknowledgement
+ signed task-package references
```

Each event reports the policy revision under which it was collected. That makes privacy and audit questions answerable later.

---

# 6. Supported-version and lifecycle table

**[Fact—current] Valid on July 30, 2026.**

| Component              | July 2026 line                          | Lifecycle / warning                                                                                                                                                                                                                                                                                                                                 | Decision |
| ---------------------- | --------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| .NET / C#              | .NET 10.0.10, C# 14                     | LTS through **Nov 14, 2028**. .NET 8 and 9 both end **Nov 10, 2026**. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core")).NET 10; do not begin this product on .NET 8                                                                    |          |
| ASP.NET Core / EF Core | 10.x                                    | Follow the .NET 10 lifecycle. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core "https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core"))ET Core 10; EF only for appropriate server domains                                                                              |          |
| PowerShell             | 7.6.4 LTS                               | Supported through **Nov 14, 2028**. 7.4 and 7.5 end **Nov 10, 2026**. ([Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle?view=powershell-7.6 "https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle?view=powershell-7.6"))compatibility host only |          |
| SQLite                 | 3.53.4                                  | Rolling upstream releases; no product-length LTS promise. Recent WAL bug history makes engine attestation essential. ([SQLite](https://www.sqlite.org/changes.html "https://www.sqlite.org/changes.html"))d assert 3.53.4+                                                                                                                          |          |
| PostgreSQL             | 18.4                                    | Major 18 supported through **Nov 14, 2030**; 14 ends **Nov 12, 2026**. ([PostgreSQL](https://www.postgresql.org/support/versioning/ "https://www.postgresql.org/support/versioning/"))L 18.4                                                                                                                                                        |          |
| Npgsql                 | 10.x                                    | Aligned with .NET/EF 10 generation. ([Npgsql](https://www.npgsql.org/doc/release-notes/10.0.html "https://www.npgsql.org/doc/release-notes/10.0.html"))rect APIs plus EF Core 10                                                                                                                                                                    |          |
| Node.js                | 24.18.1 LTS                             | Node 24 LTS through **April 2028**. ([Node.js](https://nodejs.org/en/blog/vulnerability/july-2026-security-releases "https://nodejs.org/en/blog/vulnerability/july-2026-security-releases"))eline only                                                                                                                                              |          |
| React                  | 19.2.7                                  | Rolling patch line; no fixed enterprise LTS date in the release material. ([React](https://react.dev/blog/2025/10/01/react-19-2 "https://react.dev/blog/2025/10/01/react-19-2")) patch, quarterly review                                                                                                                                            |          |
| TypeScript             | 7.0.2 current; 6.0.3 compatibility line | 7.0 lacks compiler API; 7.1 is expected to introduce the new API. ([Microsoft for Developers](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/ "https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/"))h 6.0.3; re-evaluate 7.1                                                                                 |          |
| Vite                   | 8.1 line                                | Rolling frontend tooling. ([vitejs](https://vite.dev/blog/announcing-vite8-1 "https://vite.dev/blog/announcing-vite8-1")) version in lockfile                                                                                                                                                                                                       |          |
| Playwright             | 1.62 line                               | Rolling browser/test support. ([Playwright](https://playwright.dev/docs/release-notes "https://playwright.dev/docs/release-notes"))ers and package together                                                                                                                                                                                         |          |
| Rust                   | 1.97.1                                  | Latest-stable support model and rapid release cadence; no LTS line. ([blog.rust-lang.org](https://blog.rust-lang.org/releases/latest/ "https://blog.rust-lang.org/releases/latest/"))hard-boundary only                                                                                                                                             |          |
| Go                     | 1.26.5; 1.25.12 also serviced           | Go supports a major line until two newer major versions exist. ([Go](https://go.dev/doc/devel/release "https://go.dev/doc/devel/release"))only                                                                                                                                                                                                      |          |
| WiX                    | 7.0.0                                   | Current line with OSMF commercial/legal implications. ([GitHub](https://github.com/wixtoolset/wix/releases/ "https://github.com/wixtoolset/wix/releases/"))after explicit legal ADR                                                                                                                                                                 |          |
| RabbitMQ               | 4.3.4                                   | Community support for this line ends **Nov 30, 2026**; commercial support differs. ([RabbitMQ](https://www.rabbitmq.com/release-information "https://www.rabbitmq.com/release-information"))scale/fan-out escalation                                                                                                                                |          |

## Windows support warning

Windows 10 22H2 is already out of support except for separately serviced LTSC editions. Windows 10 Enterprise LTSC 2021 ends support on January 12, 2027. Windows 11 Enterprise 23H2 ends November 10, 2026; 24H2 and later provide a more defensible deployment baseline. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-enterprise-and-education "https://learn.microsoft.com/en-us/lifecycle/products/windows-10-enterprise-and-education"))ndation]** Define the v1 support baseline as supported Windows 11 Enterprise releases plus explicitly tested Windows Server/RDS releases. If Windows 10 LTSC must be supported, create a dated compatibility policy and do not let it constrain the architecture indefinitely.

---

# 7. Where not to share code or technology

Using C# on both sides does not justify a single shared application model.

| Do not share                                                                  | Reason                                                                                                      |
| ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| EF Core entities between endpoint and server                                  | SQLite and PostgreSQL have different schemas, migrations, lifecycle and consistency requirements            |
| A common “database repository” abstraction                                    | It would hide the transactional outbox and bulk-ingestion semantics that need to remain explicit            |
| Endpoint and server retry policies                                            | Endpoint retries across hours or days; server retries occur in a controlled datacenter environment          |
| Endpoint and server logging configuration                                     | Endpoint logs are bounded and privacy-sensitive; server observability is centralized and high-volume        |
| Device certificate/key code with portal token code                            | They have different principals, stores, rotation and threat models                                          |
| In-process collector/plugin interfaces                                        | They couple runtime and dependency versions and defeat crash containment                                    |
| Server integration SDKs on the endpoint                                       | HR, AD, ITSM and customer credentials belong server-side                                                    |
| UI models generated from database entities                                    | The browser consumes API contracts, not persistence shapes                                                  |
| Update metadata and ordinary configuration documents                          | Update trust is a higher-security channel with separate keys, approvals and expiry                          |
| Endpoint privacy filtering implementation with server analytics normalization | The semantic policy can share test vectors, but endpoint enforcement must not depend on server availability |
| PostgreSQL migration code with SQLite migrations                              | Different failure and rollback behavior                                                                     |
| Generic utility assemblies with transitive server dependencies                | They tend to grow until endpoint binaries accidentally inherit unsuitable packages                          |

Safe sharing is deliberately narrow:

- Contract schemas.

- Source-generated contract DTOs with no business logic.

- Event-type identifiers.

- Canonical test vectors.

- Redaction-rule semantics.

- Cryptographic format specifications.

- Compatibility fixtures.

---

# 8. Principal risks and mitigations

| Risk                                                  | Impact                                     | Mitigation                                                                                                                                            |
| ----------------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Self-contained .NET runtime becomes stale             | Endpoint carries a vulnerable runtime      | Monthly automated rebuild, canary rollout, version compliance dashboard and patch SLA                                                                 |
| User-session collection fails on RDS/VDI              | Missing or cross-user data                 | SID-scoped IPC, per-session tests, ephemeral SessionHost, explicit non-persistent pool identity                                                       |
| Browser schema or live-WAL behavior changes           | Missed or duplicated history               | Versioned adapters, profile fixtures, main/WAL/SHM snapshot validation, overlap plus deterministic dedupe                                             |
| SQLite corruption or wrong DLL loaded                 | Loss of unacknowledged outbox              | Pinned 3.53.4+ engine, startup version assertion, one writer, `FULL`, crash tests, quick-check and protected corrupt-file preservation                |
| Updater compromise                                    | Fleet-wide code execution                  | Separate minimal service, HSM-protected signing, Authenticode plus expiring threshold metadata, release approvals, rings and automatic rollback       |
| Signed task becomes a general remote shell            | Privilege escalation and audit failure     | Capability manifest, no arbitrary elevation, separate process, restricted token, package expiry, output limits and brokered privileged operations     |
| PostgreSQL inbox grows or creates WAL pressure        | Ingestion and control-plane latency        | Partition/retention, bounded payloads, batch COPY, queue metrics, autovacuum tuning and a defined RabbitMQ escalation threshold                       |
| PostgreSQL migration ignores SQL Server HR/AD joins   | Portal regression and schedule failure     | Narrow projections, compatibility projector, reconciliation and explicit database decision gate                                                       |
| Direct legacy SQL behavior is subtly changed          | Analytical discrepancies                   | Golden fixtures, old/new parallel comparison, field-level reconciliation and documented semantic differences                                          |
| Frontend/npm supply chain                             | Portal compromise                          | Lockfile, internal package policy, SBOM, Node build-only, CSP and dependency patch SLA                                                                |
| WiX licensing or maintenance model is unacceptable    | Installer delivery blocked                 | Complete legal ADR before implementation and retain a commercial MSI-authoring alternative                                                            |
| PowerShell compatibility becomes permanent            | Recreates legacy attack surface            | Per-script retirement date, explicit owner, no general scripting API and dashboard of remaining compatibility packages                                |
| Endpoint policy misconfiguration uploads private data | Legal/privacy incident                     | Signed policy revision, endpoint-side deny tests, canary secrets, four-eyes policy changes and audit trail                                            |
| mTLS conflicts with intercepting enterprise proxies   | Devices cannot enroll/upload               | Early proxy PoT, configurable direct endpoint, customer gateway option and a separately designed application-proof fallback—not a shared fleet secret |
| Team lacks .NET service/Windows security experience   | Slow delivery despite language familiarity | Windows-service, ACL, CNG and crash-debugging training; mandatory security design reviews                                                             |

---

# 9. Two viable fallback stacks

## Fallback A — C# platform with Rust hard-boundary components

### Responsibilities

- C#/.NET 10: installer, service orchestration, session access, updater control, APIs, workers and BFF.

- Rust 1.97.1 or later stable: one or more separately signed native collectors or parsers.

- SQLite/PostgreSQL/React remain as in the default.

- JSON or length-prefixed process IPC; no native FFI between managed and Rust code.

### Conditions that favor it

Choose this when all are true:

1. The PoT demonstrates a hard resident-memory or startup requirement that .NET cannot meet.

2. The component is narrow and stable enough to have a small IPC contract.

3. Crash or memory-corruption containment materially improves through a native Rust process.

4. The organization has at least two experienced Rust maintainers.

5. Rust’s rapid toolchain cadence is accepted in the release process.

6. The Rust process does not recreate complex COM and Windows-session orchestration already handled well by .NET.

Typical candidate: a continuous high-rate ETW parser or high-risk binary parser—not ordinary browser SQL.

## Fallback B — Go-first endpoint and server

### Responsibilities

- Go 1.26.x service, user-session executable, updater and server APIs/workers.

- `x/sys/windows` for service, token, Event Log and low-level Windows functions.

- Out-of-process task executables only; no Go plugins on Windows.

- SQLite through a deliberately chosen and tested CGO/native or pure-Go implementation.

- PostgreSQL and React portal as above.

### Conditions that favor it

Choose this when:

1. The product scope is narrowed so COM-heavy Recent Item processing and advanced Windows security work are minor.

2. Continuous process capture is not required or is delegated to a small native helper.

3. The team is demonstrably stronger in Go than C#.

4. A single static executable and low startup overhead have hard operational value.

5. The SQLite build and Windows installer toolchains pass the crash and deployment gates.

6. The organization accepts that modular tasks are process-isolated rather than plugins.

Go is not favored merely because its server concurrency model is attractive; the server is not the dominant language-selection constraint.

---

# 10. Two-week proof-of-technology

## Work plan

| Day | Deliverable                                                                                                                 |
| --- | --------------------------------------------------------------------------------------------------------------------------- |
| 1   | Pin toolchains; create Windows 11, RDS and non-persistent-VDI test matrix; define test events and privacy canaries          |
| 2   | Install MSI skeleton, `UamAgentService`, explicit service SID/ACLs, enrollment key generation and Event Log channel         |
| 3   | Build Task Scheduler/session launch, SID-scoped named pipe and multi-session isolation tests                                |
| 4   | Implement Edge/Chrome/Firefox profile discovery, live snapshot/copy logic, schema fixtures and endpoint exclusion filtering |
| 5   | Implement Recent Item parsing without target access; process polling prototype and ETW comparison                           |
| 6   | Build SQLite outbox, atomic checkpointing, batching, crash recovery, disk pressure and seven-day trace replay               |
| 7   | Implement signed package staging, BITS download, Authenticode checks, expiring metadata, activation and rollback            |
| 8   | Build ASP.NET ingestion API, PostgreSQL inbox, `SKIP LOCKED` worker, idempotency and binary COPY                            |
| 9   | Add OIDC BFF/RBAC, minimal React portal, OpenTelemetry, audit and privacy-safe support bundle                               |
| 10  | Run reconnect load, fault injection and 24-hour soak; re-score matrix and produce ADR evidence                              |

Parallel work is expected, but each gate below must have an attributable test report.

## Pass/fail gates

### Session and security isolation

**Pass:**

- Zero cross-session events in at least 10,000 deliberately interleaved IPC messages across multiple RDS users.

- A different unprivileged user cannot connect to another session’s pipe.

- SessionHost cannot read the service database or device private key.

- An unsigned or hash-modified task is rejected in 100% of tests.

- Task child processes terminate with the task Job Object.

### Browser correctness

**Pass:**

- At least 99.9% of seeded eligible visits collected across 100 locked/live snapshot cycles.

- Zero excluded canary URL or domain values reach the service outbox.

- Zero duplicate final server facts after crash, overlap and replay.

- Multiple Chromium and Firefox profiles are independently discovered.

- Every unsupported schema returns a typed diagnostic rather than an empty-success result.

### Recent Items privacy

**Pass:**

- Seeded local and UNC `.lnk` files are parsed.

- Packet capture shows no connection attempt to the UNC target.

- Rejected paths do not occur in local logs or the support bundle.

### Process collection

**Pass:**

- Polling reproduces the legacy interval behavior without cross-session records.

- If ETW is selected, at least 99.99% of controlled process-start events are captured under load.

- No unfiltered system-wide event is persisted.

### Outbox durability

**Pass:**

- Zero acknowledged-event loss across 100 random process-kill cycles and 100 VM hard-power-off cycles.

- Zero duplicate normalized facts after replay.

- `quick_check` succeeds after every recovery cycle.

- Atomic event/checkpoint invariants hold under injected exceptions.

- A trace-scaled seven-day offline backlog drains without manual repair.

### Resource envelope

**[Estimate] Pass targets:**

- Agent service idle private memory: ≤55 MB.

- Agent service average idle CPU over 30 minutes: ≤0.25% of one logical processor.

- Periodic SessionHost peak private memory: ≤45 MB and normal exit within 20 seconds after collection.

- No unexplained working-set or handle growth above 10% over a 24-hour soak.

- Installed base package: ≤150 MB before optional compatibility packages.

- On a ten-session RDS test, aggregate resource use remains within the agreed host budget.

Failure does not automatically select Rust; it requires profiling that identifies a component-level cause and proves a materially better alternative.

### Updater

**Pass:**

- 100/100 ordinary upgrades succeed.

- 100/100 kills during activation either complete safely or roll back.

- Expired metadata, unsigned binaries, wrong hashes and rollback releases are rejected.

- The known-good version remains bootable after failed migration.

- MSI repair and uninstall continue to work after payload updates.

### Server scale

**[Estimate] Pass targets:**

- 200 accepted batches/second for 30 minutes.

- 1,000 batches/second for a 60-second reconnect burst.

- p95 durable acceptance below 2 seconds while PostgreSQL is healthy.

- No duplicate `ingest_batch` or fact records.

- Worker lag returns below 60 seconds after the burst.

- Control-plane p95 latency remains below 500 ms during ingestion.

- Queue table, WAL and vacuum behavior remain within agreed operational thresholds.

### Audit and diagnostics

**Pass:**

- Every policy, task, release and device-control mutation has an actor, tenant, target, before/after data, outcome and correlation ID.

- Seeded URL, path, token, certificate-key and enrollment-secret canaries do not appear in logs, traces or support bundles.

- A support engineer can diagnose one deliberately injected browser, SQLite, certificate and update failure without direct database access to the endpoint.

---

# 11. ADRs required before implementation

1. **ADR-001 — Supported Windows editions, release baselines and CPU architectures.**

2. **ADR-002 — .NET 10 adoption and embedded-runtime patch cadence.**

3. **ADR-003 — Endpoint process model, service accounts and privilege boundaries.**

4. **ADR-004 — User-session launch strategy and RDS/non-persistent VDI identity model.**

5. **ADR-005 — Named-pipe protocol, authentication and exact SDDL.**

6. **ADR-006 — Approved collection fields, privacy filtering, legal basis and retention.**

7. **ADR-007 — Browser profile discovery, snapshot algorithm and supported schema policy.**

8. **ADR-008 — Process collection: interval polling, ETW or hybrid.**

9. **ADR-009 — Event identity, deduplication, checkpoint and acknowledgement semantics.**

10. **ADR-010 — SQLite engine sourcing, WAL settings, encryption, migrations and corruption recovery.**

11. **ADR-011 — Device enrollment, certificate issuance, rotation and revocation.**

12. **ADR-012 — Wire contracts, schema compatibility window and batch limits.**

13. **ADR-013 — Task-package format, capability model, process isolation and compatibility contract.**

14. **ADR-014 — PowerShell compatibility policy and script-retirement process.**

15. **ADR-015 — Update trust roots, threshold signing, metadata expiry, rings and rollback.**

16. **ADR-016 — MSI authoring product and WiX 7 licensing decision.**

17. **ADR-017 — Server modular-monolith boundaries and deployable units.**

18. **ADR-018 — PostgreSQL inbox versus external broker and quantitative escalation triggers.**

19. **ADR-019 — PostgreSQL schema, partitioning, idempotency, retention and migration tooling.**

20. **ADR-020 — PostgreSQL versus transitional SQL Server and HR/AD projection strategy.**

21. **ADR-021 — Administrator OIDC, BFF session handling, RBAC and high-risk approvals.**

22. **ADR-022 — Tenant isolation, database RLS or deployment-per-customer policy.**

23. **ADR-023 — Audit immutability and administrative evidence requirements.**

24. **ADR-024 — External-integration adapter model and credential storage.**

25. **ADR-025 — React/TypeScript toolchain and TypeScript 7.1 reevaluation gate.**

26. **ADR-026 — Observability, redaction, support bundles and service-level objectives.**

27. **ADR-027 — CI, dependency policy, SBOM, provenance and isolated signing pipeline.**

28. **ADR-028 — Legacy coexistence, compatibility projection, reconciliation and cutover.**

29. **ADR-029 — Backup, disaster recovery, RPO and RTO.**

30. **ADR-030 — Conditions for introducing Rust, Go or RabbitMQ.**

# Final conclusion

**[Recommendation] The best defensible default is C# 14/.NET 10 for all Windows endpoint executables and all server APIs/workers, PostgreSQL 18.4 centrally, a product-pinned SQLite 3.53.4-or-newer engine locally, and React/TypeScript for the portal.**

That recommendation is not based on language popularity. It follows from the product’s unusually high concentration of Windows security, session, COM, filesystem, installer and update requirements; the legacy PowerShell/.NET migration surface; the value of a real LTS policy; and the absence of a measured endpoint constraint that currently justifies a second production language.

The proposal should therefore be accepted with these corrections:

1. Split service, user-session collector, updater and task host.

2. Keep all privacy filtering before the outbox.

3. Pin and attest the SQLite native engine.

4. Use a PostgreSQL inbox before adding an external broker.

5. Treat the updater and task channel as separate high-security systems.

6. Keep PowerShell only in a restricted compatibility process.

7. Replace direct SQL and same-database HR/AD coupling with APIs and narrow projections.

8. Use server-side compatibility projection during migration rather than endpoint dual writes.

9. Prevent shared C# code from turning endpoint and server into one coupled application.

10. Make the proof-of-technology gates—not synthetic benchmarks—the final authority on footprint, process collection and queue escalation.
