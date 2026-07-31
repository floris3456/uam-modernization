# Windows feasibility and prototype plan

**Date:** 30 July 2026  
**Decision:** **proceed conditionally with a machine service plus one standard-user process per interactive session. Do not commit to a service-only collector.**

The proposed UAM design is feasible on current Windows, but four claims must be demonstrated before the Browser History vertical slice becomes a production project:

1. A standard-user session process can enumerate every relevant browser profile and obtain a consistent history view without modifying the browser database.

2. Multiple users and sessions remain cryptographically and access-control isolated without the coordinator obtaining user tokens.

3. Events and source checkpoints remain consistent through kills, reboots, disk pressure, and ambiguous upload acknowledgements.

4. Signed staged updates always leave either the old or new version runnable, and an application rollback also preserves local-database compatibility.

## Executive determination

| Question                                                                       | Determination                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Can a Windows service discover sessions and profiles?                          | **Yes for session and loaded-profile metadata.** It can receive session-change notifications and enumerate WTS sessions. It should not load inactive profiles.                                                                                                                                                                                                                                                                                                                                            |
| Can that service read every user’s browser data while remaining low privilege? | **Not as a defensible default.** Services run in Session 0, while interactive users occupy other sessions. Obtaining a user primary token through `WTSQueryUserToken` requires LocalSystem plus `SeTcbPrivilege` and is explicitly intended for highly trusted services. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))                     |
| Where should browser, Recent, and user process collection run?                 | In a **standard-user process in each interactive session**, started by Task Scheduler with an interactive/group logon principal and `TASK_RUNLEVEL_LUA`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype "https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype"))                                                                                                                                                                 |
| What belongs in the service?                                                   | Machine policy, authenticated IPC, the central local outbox, checkpoint transactions, compression/upload, health, and update coordination.                                                                                                                                                                                                                                                                                                                                                                |
| How should locked browser SQLite databases be read?                            | First try a short read-only SQLite transaction. If browser locking prevents it, use the SQLite online-backup API into protected temporary storage. If both fail, defer. Never raw-copy a changing main database independently of its WAL. SQLite’s own documentation specifically notes that Chrome and Firefox may return `SQLITE_BUSY` while using exclusive locking and that the WAL is part of the database’s persistent state. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html")) |
| Should inactive profiles be collected?                                         | **No, unless a future, separately approved requirement justifies it.** Loading or mining logged-off profiles increases privilege, privacy exposure, and profile-container contention.                                                                                                                                                                                                                                                                                                                     |
| Installer default?                                                             | **MSI for installation, repair, ACLs, service/task registration, and major upgrade.** A custom signed updater may service immutable application payloads, but it must not compete with Windows Installer. MSIX remains a possible later packaging experiment, not the initial default.                                                                                                                                                                                                                    |
| Which tests require physical hardware?                                         | ARM64-native operation, Modern Standby, genuine abrupt power loss and storage-cache behavior, OEM/EDR filter drivers, hardware-backed device keys, and meaningful battery/resume measurements.                                                                                                                                                                                                                                                                                                            |

---

# 1. Recommended Windows process and session architecture

## 1.1 Process topology

```text
                       MSI / enterprise deployment
                                  |
                    +-------------v-------------+
                    | Stable launcher + updater |  LocalSystem, on demand
                    | immutable version folders |
                    +-------------+-------------+
                                  |
                    +-------------v-------------+
                    | UAM Coordinator Service   |  LocalService
                    |                           |
                    | policy / IPC / outbox     |
                    | checkpoints / upload      |
                    | health / diagnostics      |
                    +------+------+-------------+
                           |      |
          authenticated    |      | HTTPS with explicit device identity
          local pipe       |      v
                           |   ingestion API
          +----------------+-------------------+
          |                                    |
+---------v-----------+              +---------v-----------+
| User agent          |              | User agent          |
| user A / session 2  |              | user B / session 4  |
| standard token      |              | standard token      |
+---------+-----------+              +---------+-----------+
          |                                    |
   private inherited pipe               private inherited pipe
          |                                    |
+---------v-----------+              +---------v-----------+
| Collector TaskHost |              | Collector TaskHost |
| restricted + job   |              | restricted + job   |
+--------------------+              +--------------------+
```

### Coordinator service

Run the coordinator as **`NT AUTHORITY\LocalService` with a per-service SID**. LocalService has limited local authority and presents anonymous credentials to network servers; UAM should therefore use an explicit device credential—such as an mTLS certificate whose private-key ACL grants read access to the service SID—rather than depending on Windows machine-account authentication. NetworkService should be used only if a proven integration specifically requires the computer account. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/localservice-account "https://learn.microsoft.com/en-us/windows/win32/services/localservice-account"))

The coordinator owns:

- The machine policy cache and policy version.

- Session registration and agent reconciliation.

- Named-pipe endpoints and client authentication.

- `%ProgramData%\Vendor\UAM\Data\uam.db`.

- Event insertion and source-checkpoint transactions.

- Backlog limits, batching, compression, upload, and acknowledgement processing.

- Device health and non-sensitive diagnostics.

- Requests to the privileged updater.

- No direct reads of `%USERPROFILE%`, browser databases, Recent Items, or user registry hives.

It should accept `SESSIONCHANGE`, `POWEREVENT`, and time-change controls through `HandlerEx`, but those notifications are reconciliation signals rather than the mechanism for constructing user tokens. Windows exposes those extended service controls specifically through `HandlerEx`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nc-winsvc-lphandler_function_ex "https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nc-winsvc-lphandler_function_ex"))

### Per-session user agent

Register one machine-wide Task Scheduler definition during installation:

- Logon trigger for eligible users.

- Interactive/group logon type.

- `TASK_RUNLEVEL_LUA`.

- No stored password.

- Restart-on-failure policy.

- No time limit while the interactive session exists.

- Binary in the read-only product directory.

- A singleton mutex scoped to the **logon session**, not the entire machine.

The exact behavior of a group-principal task across console, fast-user-switching, disconnected RDP, and RDS multi-session must be proven by Experiment E2. Task Scheduler documents `TASK_LOGON_INTERACTIVE_TOKEN` and `TASK_LOGON_GROUP` for interactive execution, but the product should not assume that every managed environment configures Task Scheduler identically. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype "https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype"))

The user agent:

- Discovers its own browser profiles and known folders.

- Executes privacy filtering before data leaves the user context.

- Runs collectors in TaskHost subprocesses.

- Maintains no central credentials.

- Does not write the machine outbox directly.

- Sends bounded, typed result envelopes to the service.

- Exits on logoff and closes all profile-container handles promptly.

### Collector TaskHost

Run each collector in a separate TaskHost process under the same user identity but with:

- Unneeded token privileges disabled.

- Administrator groups converted to deny-only where applicable.

- A job object with `JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE`.

- Active-process limit of one unless a collector has an explicitly approved child.

- Per-process and per-job memory limits.

- Execution deadline and cancellation.

- Child-process creation mitigation.

- No breakaway.

- No direct network access.

- A private inherited pipe or handle to the user agent; no access to the global service protocol.

Job objects provide group termination and resource limits, and Windows supports assigning jobs and process mitigations during process creation through `PROC_THREAD_ATTRIBUTE_JOB_LIST` and related attributes. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects"))

Do not load remotely supplied PowerShell or arbitrary assemblies into the long-running service. The legacy configuration’s ability to execute `Invoke-Expression` content is a behavior to remove, not preserve.

## 1.2 Why not launch user collectors from the service?

A service can enumerate sessions using WTS APIs, but `WTSQueryUserToken` requires LocalSystem and `SeTcbPrivilege`; Microsoft labels it an API for highly trusted services. That is a poor default merely to make user-owned browser files readable. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken"))

Avoid this chain:

```text
LocalSystem service
    -> WTSQueryUserToken
    -> DuplicateTokenEx
    -> CreateEnvironmentBlock
    -> CreateProcessAsUser
    -> LoadUserProfile / unload profile
```

It introduces token lifetime, environment, profile-hive, desktop, session, and privilege hazards. Task Scheduler already has the operating-system machinery to run an executable under the existing interactive token.

The service can still reconcile agent health:

1. Receive session-change notification.

2. Enumerate WTS session IDs when permitted.

3. Compare them with authenticated pipe registrations.

4. Report a missing user agent or ask Task Scheduler to run the registered task.

5. Never mint or retain the user token.

If a particular RDS environment prevents the group task from launching, that is an enterprise compatibility finding—not a reason to promote the entire coordinator to LocalSystem.

## 1.3 Named-pipe design

Do not accept the default named-pipe security descriptor. Microsoft documents that the default descriptor gives read access to Everyone and the anonymous account. Create an explicit descriptor and set `PIPE_REJECT_REMOTE_CLIENTS`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights "https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights"))

Recommended connection sequence:

1. The service exposes a small, local-only bootstrap pipe.

2. DACL: service SID and SYSTEM full control; authenticated local users only the minimum connect/read/write rights.

3. Client connects and sends a versioned handshake no larger than a few kilobytes.

4. Service obtains the client process and session IDs from the pipe.

5. It impersonates only long enough to inspect the token SID and logon SID, then always calls `RevertToSelf` in a `finally` path.

6. Service binds the connection to `(client PID, creation time, session ID, user SID, protocol version)`.

7. Every later message is attributed from that binding, not from a claimed username or SID in the payload.

8. Per-client byte, message-rate, and outstanding-request limits prevent a local user from exhausting service memory.

9. A reconnect creates a new authenticated binding and invalidates the old connection.

For stronger isolation, create a per-logon-session pipe whose DACL contains the logon SID; Microsoft specifically recommends logon SIDs for preventing cross-session pipe access. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights "https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights"))

## 1.4 Multi-user and RDP behavior

- **Fast user switching:** one agent per logged-on session. Collection remains attributed by user SID and session ID.

- **Disconnected RDP:** keep the agent alive while the session remains logged on. The policy may reduce collection cadence, but should not merge it with the console session.

- **Logoff:** cancel collectors, close source handles, submit any complete page, and exit. Never hold an FSLogix container open through sign-out.

- **Same SID in multiple sessions:** process collection remains per-session. Browser and Recent sources require a machine-coordinated source lease keyed by user SID, canonical source path, and source generation so two agents do not collect the same profile concurrently.

- **Temporary profile:** record a health condition and do not silently treat it as the user’s normal profile.

- **Logged-off profile:** no collection.

---

# 1.5 Browser profile discovery

The legacy code recursively searches for browser databases, sorts candidates by last-write time, then selects the first usable database. It therefore collects one “winning” profile per browser rather than all profiles. Its Chromium query filters on individual visits but returns the URL table’s aggregate `last_visit_time`, which can duplicate or misorder visits. Its wildcard file copy is also not a consistent database-snapshot protocol.

The replacement must enumerate and checkpoint **each profile independently**.

### Chromium and Edge

Chromium documents that the user-data directory contains multiple profile subdirectories and that paths vary by branding and release channel. Edge additionally allows enterprise policy or `--user-data-dir` to override the location. ([Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/HEAD/docs/user_data_dir.md "https://chromium.googlesource.com/chromium/src/%2B/HEAD/docs/user_data_dir.md"))

Discovery order:

1. Read configured policy overrides.

2. Inspect the running browser’s command line only when accessible under the same user.

3. Check vendor/channel default user-data roots.

4. Parse `Local State` only for discovery hints; do not treat it as the sole authority.

5. Enumerate every candidate profile directory.

6. Require a regular `History` file beneath the canonical user-data root.

7. Reject reparse-point escapes unless explicitly approved.

8. Open read-only and validate required tables/columns.

9. Create one source identity per canonical profile path and generation.

Support `Default`, `Profile 1`, `Profile 2`, guest-related storage where policy permits, and custom roots explicitly configured by enterprise policy. Do not infer “active profile” from last-write time.

### Firefox

Firefox stores browsing history in `places.sqlite`; Mozilla’s Profile Service manages known profiles through `profiles.ini`. The current source defines `moz_historyvisits.id`, `place_id`, and `visit_date`, and Firefox source uses the timestamp divided by one million with SQLite’s `unixepoch`. ([Mozilla Support](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data "https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data"))

Parse `profiles.ini` and, where relevant, installation-default mapping. Resolve relative paths under the Firefox profile root and absolute paths only if policy permits them. Enumerate all resulting profiles and validate `places.sqlite`.

### Browser schema policy

Browser history schemas are implementation details, not a vendor-supported external telemetry API. Therefore:

- Select an adapter by observed tables, columns, and metadata—not merely by executable version.

- Query only explicitly recognized capabilities.

- Unknown required schema means `UnsupportedSchema`; collect nothing and do not advance the cursor.

- Record browser version, adapter version, schema signature, and failure category.

- Maintain current stable, previous stable, and pre-release compatibility tests.

- Keep a remote kill switch for an adapter, but never a remote SQL string or executable script.

Chromium distinguishes visit IDs from per-URL aggregate information: its source identifies a `VisitID` corresponding to `visits.id`, while `last_visit_time` is a per-URL property. ([Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/master/components/history/core/browser/history_types.h "https://chromium.googlesource.com/chromium/src/%2B/master/components/history/core/browser/history_types.h"))

## 1.6 Reading live browser SQLite databases

Use this ordered strategy:

### Strategy A — direct short read transaction

1. Open the source with `mode=ro`, private cache, extension loading disabled.

2. Set a short busy timeout and `PRAGMA query_only=ON`.

3. Validate the required schema.

4. Start a read transaction.

5. Read one bounded page, for example 500–2,000 visits or at most 2 MiB.

6. End the transaction promptly.

7. Redact and allowlist before serialization.

In WAL mode, a read transaction observes a fixed end mark and therefore a consistent point-in-time view. However, SQLite notes that Chrome and Firefox may use exclusive locking and can return `SQLITE_BUSY`, so this must be measured rather than assumed. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))

### Strategy B — online backup fallback

If direct reading is repeatedly busy, use `sqlite3_backup` or `Microsoft.Data.Sqlite.SqliteConnection.BackupDatabase` to create a consistent temporary database, then query that copy. The online-backup API is designed to snapshot a live SQLite database while other processes may be using it. ([SQLite](https://sqlite.org/backup.html "https://sqlite.org/backup.html"))

Controls for the fallback:

- User-only and SYSTEM ACL.

- Same local NTFS volume.

- Randomized directory name.

- Hard byte limit.

- `PRAGMA quick_check` before querying.

- Maximum lifetime, such as ten minutes.

- Best-effort secure cleanup plus startup reaper.

- No URL, title, or full path in diagnostic logs.

- No upload of the snapshot.

- No checkpoint advancement if backup or validation fails.

### Prohibited approaches

- Copying only the main database.

- Sequentially copying main, `-wal`, and `-shm` while the browser is writing.

- Deleting a browser WAL.

- Opening an active database with `immutable=1`.

- VSS merely to read browser history.

- Retrying indefinitely while holding a profile-container handle.

SQLite states that the WAL is part of persistent database state and separating it can lose committed transactions or corrupt the copy. Its corruption guidance also calls out copying database files while a transaction is active. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))

## 1.7 Visit identity, timestamps, and checkpoints

For Chromium, extract the native visit row:

```sql
SELECT
    v.id          AS native_visit_id,
    v.visit_time  AS raw_visit_time,
    u.url,
    u.title
FROM visits AS v
JOIN urls AS u ON u.id = v.url
WHERE v.id > @lower_bound_id
ORDER BY v.id
LIMIT @page_size;
```

For Firefox:

```sql
SELECT
    v.id          AS native_visit_id,
    v.visit_date  AS raw_visit_time,
    p.url,
    p.title
FROM moz_historyvisits AS v
JOIN moz_places AS p ON p.id = v.place_id
WHERE v.id > @lower_bound_id
ORDER BY v.id
LIMIT @page_size;
```

Store:

- Browser and profile source ID.

- Source generation.

- Native visit ID.

- Raw source timestamp.

- Explicit timestamp epoch.

- Normalized UTC instant.

- Capture UTC and server-received UTC.

- Privacy-transformed URL/title fields only.

Chromium’s time representation uses microseconds from the Windows epoch, while Firefox Places uses microseconds interpreted with the Unix epoch. Preserve the raw integer so conversion defects can be repaired without rereading private history. ([Chromium Git Repositories](https://chromium.googlesource.com/chromium/src/%2B/HEAD/base/time/time.h "https://chromium.googlesource.com/chromium/src/%2B/HEAD/base/time/time.h"))

Use the native visit ID as the main extraction cursor and retain a bounded overlap. A timestamp-only high-water mark can miss a newly synchronized visit whose historical event time precedes the checkpoint.

A checkpoint record should contain:

```text
source_id
source_generation
committed_native_id
max_raw_event_time
adapter_version
schema_signature
last_success_utc
```

The service updates the source checkpoint **in the same SQLite transaction** that inserts the corresponding event page. The user agent receives success only after that transaction commits.

Detect a new source generation when:

- File identity changes.

- Schema metadata is incompatible.

- Maximum native ID regresses materially.

- Browser profile is recreated.

- The path is reused after deletion.

- Database validation indicates a replacement rather than ordinary cleanup.

On uncertain replacement, start a bounded lookback as a new generation; do not force the old cursor into the new database.

## 1.8 Recent Items versus Quick Access

The first release should implement **Windows Recent Items**, not claim full Quick Access support.

Use:

- `SHGetKnownFolderPath(FOLDERID_Recent)`.

- `IPersistFile::Load` to open local `.lnk` files.

- `IShellLinkW` to read stored metadata.

- Raw target path retrieval without calling `Resolve`.

- No `Test-Path`, file open, directory enumeration, or network access to the target.

Microsoft documents the Recent known folder and the Shell Link interfaces, but I found no supported public contract for enumerating the complete, user-visible Quick Access/Home view across pinned, frequent, and application destination data. Microsoft’s Jump List APIs principally govern an application’s own destination lists. Treat parsing `AutomaticDestinations-ms` as unsupported reverse engineering unless Microsoft provides a stable contract. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid "https://learn.microsoft.com/en-us/windows/win32/shell/knownfolderid"))

The legacy Recent collector uses `WScript.Shell` and can test or dereference shortcut targets. That can introduce unwanted access to UNC paths, removable media, or unavailable shares. The replacement must parse shortcut metadata without touching the destination.

## 1.9 Process inventory

Keep process collection in the per-session agent.

Baseline implementation:

1. Take a `CreateToolhelp32Snapshot`.

2. Traverse `Process32First/Process32Next`.

3. Filter with `ProcessIdToSessionId`.

4. Identify a process as `(PID, creation time)` to survive PID reuse.

5. Attempt `QueryFullProcessImageName` with `PROCESS_QUERY_LIMITED_INFORMATION`.

6. Treat access denied as a valid partial result.

7. Never enable `SeDebugPrivilege`.

Tool Help provides a snapshot of running processes; it does not guarantee observation of processes that start and exit between polls. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/toolhelp/tool-help-functions "https://learn.microsoft.com/en-us/windows/win32/toolhelp/tool-help-functions"))

If the business requirement is “inventory of applications observed running,” a 5–15 second adaptive snapshot may be sufficient and is close to legacy behavior. If the requirement is “every process start,” E6 must compare:

- `Win32_ProcessStartTrace`.

- ETW process events.

- Snapshot polling.

No exhaustive process-start claim should be made until an ordinary-user test quantifies short-lived-process loss, elevated-process visibility, CPU cost, and RDS behavior. Do not make Windows Security event 4688 or customer audit-policy changes a product dependency.

---

# 1.10 Local SQLite outbox

Use a self-contained, native-architecture .NET 10 build with a bundled, pinned SQLite runtime. As of 30 July 2026, .NET 10 is the active LTS release through 14 November 2028; .NET 8 and .NET 9 both leave support on 10 November 2026, making them poor new-product baselines. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))

Do not depend on an unspecified OS SQLite version. The bundled runtime must contain the WAL-reset fix present in SQLite 3.51.3 or an official backport; SQLite’s July 2026 WAL documentation says the rare corruption bug affected releases through 3.51.2. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))

Recommended database settings:

```sql
PRAGMA journal_mode = WAL;
PRAGMA synchronous = FULL;
PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;
PRAGMA application_id = <assigned value>;
PRAGMA user_version = <schema version>;
```

`FULL` is the defensible initial durability setting. SQLite documents that in WAL mode `NORMAL` may lose recently committed transactions after power loss or a hard reset, whereas `FULL` syncs the WAL on commit. Tune only after measuring real disk cost. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))

Core invariants:

- One in-process writer queue.

- Event insertion and checkpoint advancement in one transaction.

- Upload acknowledgement and pending-row state change in one transaction.

- No delete before an authenticated, batch-specific acknowledgement.

- Stable idempotency key generated before first upload.

- Duplicate server receipt is safe.

- WAL remains on local storage; SQLite says WAL is not suitable for network filesystems. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))

- Bounded read transactions so checkpoints are not starved.

- Size and age quotas applied before the volume becomes full.

- If loss is policy-authorized, emit an explicit dropped-range/tombstone record; never silently delete the queue.

### Full disk

At high water:

1. Stop launching low-priority collectors.

2. Continue upload and compaction.

3. Emit a rate-limited local health event.

4. Preserve already committed rows.

5. Optionally delete a preallocated emergency reserve file to regain enough space for state transitions.

6. Resume collection only below a lower hysteresis threshold.

`SQLITE_FULL`, `SQLITE_BUSY`, `SQLITE_CORRUPT`, `SQLITE_NOTADB`, and I/O errors must be distinct operational states rather than one generic exception. SQLite publishes these result codes for programmatic handling. ([SQLite](https://sqlite.org/rescode.html "https://sqlite.org/rescode.html"))

### Corruption

After an unclean shutdown or on corruption-related error:

- Close all connections.

- Run `PRAGMA quick_check`.

- If it fails, move the database, WAL, and SHM together to a protected quarantine.

- Create a clean database.

- Emit a non-sensitive diagnostic with hashes, sizes, SQLite code, and schema version.

- Do not invoke `.recover` automatically on endpoints.

- Apply a customer-approved quarantine retention limit.

SQLite documents `integrity_check` and `quick_check`; they should be used as detection tools, not as permission to discard evidence silently. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))

### Schema migration and application rollback

- Preflight free space.

- Back up before an irreversible migration.

- Perform migrations in `BEGIN IMMEDIATE`.

- Make migration steps idempotent.

- Use expand/contract changes so binaries N and N−1 can both open the database.

- Do not delete old columns until no rollback to N−1 is possible.

- If migration fails, roll back the SQLite transaction and keep the old version active.

- A successful binary update is not committed until the new version has opened the outbox, completed a local health exchange, and written a heartbeat.

---

# 1.11 Installation and signed updates

## Initial installation and major upgrade

Use an **MSI**, optionally launched by a small signed bootstrapper. MSI owns:

- Product registration and uninstall.

- Stable launcher and updater.

- Windows service creation.

- Scheduled task registration.

- Program Files and ProgramData ACLs.

- Firewall rules.

- Event-log source or ETW manifest.

- Repair and enterprise detection.

- Major version upgrades.

Windows Installer performs rollback by default after an unsuccessful installation and integrates with Restart Manager for files in use. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-installation "https://learn.microsoft.com/en-us/windows/win32/msi/rollback-installation"))

Avoid non-transactional MSI custom actions. Where an external action is unavoidable, create an explicit rollback custom action; Microsoft notes that direct system changes are not automatically reversible merely because they were launched during MSI execution. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/msi/rollback-custom-actions "https://learn.microsoft.com/en-us/windows/win32/msi/rollback-custom-actions"))

## MSIX position

MSIX can package a per-machine Session 0 service on modern Windows and provides clean package servicing, but it does not support per-user Windows services and still requires elevation for a package containing services. The user component would therefore remain a scheduled/background process. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/msix/packaging-tool/convert-an-installer-with-services "https://learn.microsoft.com/en-us/windows/msix/packaging-tool/convert-an-installer-with-services"))

MSIX should be an optional later proof if an enterprise deployment standard mandates it. It does not remove the need to prove:

- All-user interactive task launch.

- External ProgramData outbox persistence.

- Custom ACL and certificate-key access.

- Self-update versus enterprise-update ownership.

- RDS/AVD deployment.

- Rollback-compatible database migrations.

## Self-update model

Use immutable version directories:

```text
Program Files\Vendor\UAM\
    launcher.exe
    updater.exe
    active-a.manifest
    active-b.manifest
    versions\
        10.4.0\
        10.5.0\
```

Update protocol:

1. Coordinator downloads to a non-executable staging directory.

2. Privileged updater starts on demand under LocalSystem.

3. Verify package manifest signature.

4. Verify every file hash.

5. Call `WinVerifyTrust`; only return value zero is success.

6. Require the expected code-signing EKU and an allowlisted signer/key.

7. Validate RFC 3161 timestamp.

8. Reject downgrade unless a separately signed rollback authorization permits it.

9. Copy into a new immutable version directory.

10. Flush staged files.

11. Stop the coordinator and user-agent task launches.

12. Write the inactive A/B manifest with version, hash, generation, and previous version.

13. Atomically replace or activate the manifest.

14. Start the stable launcher.

15. Require health checks before marking the version known-good.

16. On timeout/crash loop, activate the previous valid manifest and restart.

17. Retain at least the current and previous known-good payloads.

`WinVerifyTrust` verifies Authenticode policy and only zero means trusted; SignTool supports signing, verification, and RFC 3161 timestamping. Trust-chain success must be combined with product-signer authorization so that an unrelated trusted publisher cannot become an update signer. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust "https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust"))

Use `ReplaceFileW` only for the small manifest or pointer file, not as a claim that an entire open application directory can be replaced atomically. It replaces one file with another on the same volume and can retain a backup. The A/B manifests allow the launcher to recover even if the last pointer operation was interrupted. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew "https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew"))

The updater itself should normally change only through MSI or a separately proven two-updater protocol. Do not let the running updater overwrite itself.

---

# 2. Compatibility matrix

## 2.1 Windows and runtime

| Platform                                         | Initial status                 | Required proof or condition                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ------------------------------------------------ | ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Windows 11 Enterprise/Education 25H2 x64**     | **Primary baseline**           | All E1–E11 tests. Supported through 10 October 2028. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-and-education "https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-and-education"))                                                                                                                                                                                                           |
| **Windows 11 Enterprise/Education 24H2 x64**     | Supported while serviced       | Same functional suite. Enterprise/Education support ends 12 October 2027. Home/Pro support ends 13 October 2026, so 24H2 Home/Pro should not be a long-lived launch baseline. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-home-and-pro "https://learn.microsoft.com/en-us/lifecycle/products/windows-11-home-and-pro"))                                                                                                          |
| **Windows 11 26H1 ARM64/new hardware**           | Conditional                    | Physical ARM64 test, native installer/runtime/SQLite, browser tests, standby and updater tests. Microsoft says 26H1 is intended for new early-2026 devices and is not an in-place update from 24H2/25H2; 24H2 and 25H2 remain the recommended enterprise releases. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information "https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information")) |
| **Windows 11 Enterprise/Education 23H2**         | Transition only                | Support ends 10 November 2026; do not make it a new-product baseline. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-and-education "https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-and-education"))                                                                                                                                                                                          |
| **Windows 11 Enterprise LTSC 2024**              | Supported after dedicated lane | Validate browser availability, servicing policy, and customer deployment. Lifecycle runs through 9 October 2029. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-ltsc-2024 "https://learn.microsoft.com/en-us/lifecycle/products/windows-11-enterprise-ltsc-2024"))                                                                                                                                                       |
| **Windows 10 22H2**                              | Exception only                 | Customer must be on an approved ESU or eligible LTSC path. General support ended 14 October 2025; commercial ESU requires 22H2. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/release-information "https://learn.microsoft.com/en-us/windows/release-health/release-information"))                                                                                                                                                        |
| **Windows Server 2025 Desktop Experience / RDS** | Conditional                    | Real multi-session/RDS tests, FSLogix/Citrix tests, task launch and process visibility. Server 2025 is supported through 2034, but that does not by itself prove endpoint-agent compatibility. ([Microsoft Learn](https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2025 "https://learn.microsoft.com/en-us/lifecycle/products/windows-server-2025"))                                                                                                 |
| **Windows Server 2022 RDS**                      | Conditional/transition         | Enterprise test; mainstream support ends 13 October 2026, extended support continues. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/release-health/windows-server-release-info "https://learn.microsoft.com/en-us/windows/release-health/windows-server-release-info"))                                                                                                                                                                                  |
| **Windows Server Core**                          | Browser collection unsupported | No interactive desktop browser/profile scenario. Service-only health features could be separately supported.                                                                                                                                                                                                                                                                                                                                                            |
| **x86 Windows/process build**                    | Not supported                  | Product decision: x64 and ARM64 native builds only.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **.NET 10 self-contained**                       | Required baseline              | Ship latest serviced patch. .NET 10 LTS ends 14 November 2028. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))                                                                                                                                                                                                                                           |
| **.NET 8 or 9**                                  | No new baseline                | Both end support 10 November 2026. ([Microsoft](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core "https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core"))                                                                                                                                                                                                                                                                       |

## 2.2 Browsers

| Browser/profile type                                  | Status                         | Conditions                                                                                                                                                                                                                                                                                              |
| ----------------------------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Chrome Stable and previous Stable, x64                | Targeted                       | All-profile enumeration, direct-read/backup test, schema-capability adapter, standard and custom user-data directory.                                                                                                                                                                                   |
| Chrome native ARM64                                   | Conditional                    | Physical 26H1/ARM64 lane and native SQLite/runtime.                                                                                                                                                                                                                                                     |
| Edge Stable and previous Stable, x64                  | Targeted                       | Default and policy-defined `UserDataDir`; Edge policy can override both the normal path and command-line flag. ([Microsoft Learn](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies/userdatadir "https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies/userdatadir")) |
| Edge native ARM64                                     | Conditional                    | Physical ARM64 lane.                                                                                                                                                                                                                                                                                    |
| Firefox Release and current ESR, x64                  | Targeted                       | Parse `profiles.ini`; test all profiles and current `places.sqlite` schema. ([Mozilla Support](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data "https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data"))                                            |
| Firefox native ARM64                                  | Conditional                    | Physical ARM64 lane.                                                                                                                                                                                                                                                                                    |
| Chrome/Edge Beta, Dev, Canary; Firefox Beta/Nightly   | Test-only                      | Early warning and adapter qualification; no production support promise.                                                                                                                                                                                                                                 |
| Brave, Vivaldi, ungoogled Chromium, portable browsers | Unsupported initially          | Similar SQLite layout does not constitute a compatibility contract. Add only after separate privacy and schema validation.                                                                                                                                                                              |
| Incognito/InPrivate/private browsing                  | No history collection expected | Verify that no private-session data is persisted or inferred.                                                                                                                                                                                                                                           |
| Browser installed from Microsoft Store/MSIX           | Conditional                    | Validate profile path, package identity, update behavior, and ACLs.                                                                                                                                                                                                                                     |

Support should be expressed as a rolling policy—such as current stable plus previous stable—not as a permanently hardcoded July 2026 build number.

## 2.3 Sessions, identity, and profile technologies

| Scenario                                        | Initial status    | Notes                                                                                                                                                                                                                                                                                                                                                                                         |
| ----------------------------------------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| One local/AD/Entra user, console session        | Targeted          | Identity key is the Windows SID, not a mutable display name or UPN.                                                                                                                                                                                                                                                                                                                           |
| Fast user switching                             | Targeted after E2 | One agent per session and source lease for shared profile paths.                                                                                                                                                                                                                                                                                                                              |
| RDP with one logged-on user                     | Targeted after E2 | Test connect, disconnect, reconnect, lock, and logoff.                                                                                                                                                                                                                                                                                                                                        |
| Several simultaneous RDS/AVD users              | Conditional       | Requires Windows Server/AVD environment; a client VM cannot prove it.                                                                                                                                                                                                                                                                                                                         |
| Same user SID in several sessions               | Conditional       | Per-session process data; browser source lease; profile technology may expose divergent views.                                                                                                                                                                                                                                                                                                |
| Local profile                                   | Targeted          | Collect only while loaded.                                                                                                                                                                                                                                                                                                                                                                    |
| Windows roaming profile                         | Conditional       | Handle delayed sync, reset, and logoff; no open handles during unload.                                                                                                                                                                                                                                                                                                                        |
| FSLogix Profile Container                       | Conditional       | FSLogix redirects the complete profile into an attached VHD/VHDX at sign-in. Concurrent and multiple connections use specialized differencing-disk modes, so this must be tested in the customer topology. ([Microsoft Learn](https://learn.microsoft.com/en-us/fslogix/how-to-configure-profile-containers "https://learn.microsoft.com/en-us/fslogix/how-to-configure-profile-containers")) |
| Citrix UPM, Omnissa/VMware DEM, Ivanti/AppSense | Unknown           | Enterprise-environment tests required.                                                                                                                                                                                                                                                                                                                                                        |
| Temporary profile or failed container attach    | Fail closed       | No assumption that the apparent local path represents the normal user profile.                                                                                                                                                                                                                                                                                                                |
| Non-persistent VDI                              | Conditional       | Offline data is lost when the VM is destroyed unless ProgramData or the outbox volume is persistent.                                                                                                                                                                                                                                                                                          |
| EFS-protected browser/profile data              | Unknown           | Must test whether the ordinary user agent has access and whether scheduled-task launch receives the correct usable token.                                                                                                                                                                                                                                                                     |
| Assigned Access/kiosk/shared device             | Conditional       | Session and privacy semantics require product decision.                                                                                                                                                                                                                                                                                                                                       |

---

# 3. Experiment backlog ordered by architectural risk

The thresholds below are **proposed engineering acceptance criteria**, not measured product facts.

| ID                                                    | Hypothesis                                                                                                                                         | Setup and steps                                                                                                                                                                    | Instrumentation                                                                                                        | Pass/fail threshold                                                                                                                                                                       | Cleanup                                                    | Expected duration                                 |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------- | ------------------------------------------------- |
| **E1 — live browser SQLite consistency**              | A standard-user collector can obtain complete, non-corrupt visit pages while Chrome, Edge, and Firefox are writing, without writing the source DB. | Temporary profiles; localhost site generating unique visits; compare direct read and online backup; inject busy/exclusive fixture locks; final reconciliation after browser close. | Structured SQLite codes/timing; browser version; schema signature; ProcMon source-path writes; local-server truth log. | 10,000 snapshot attempts with zero malformed accepted views; zero collector writes to source; all expected visits found after final reconciliation; busy operation never advances cursor. | Delete profiles, scratch, fixture DBs.                     | 1.5–2 engineering days plus 4–8 hours automation. |
| **E2 — session launch and isolation**                 | Task Scheduler can start one ordinary-user agent per eligible session, and the service can authenticate it without user-token creation.            | Two standard users; console, fast switch, RDP/disconnect; group logon task; hostile cross-user pipe attempts.                                                                      | WTS/session logs; token dump; AccessChk; ProcMon; pipe audit counters.                                                 | No core LocalSystem/`SeTcb`; one agent per session; zero cross-user accepted messages in 1,000 attempts; service opens no profile files.                                                  | Remove users, task, service, ACLs.                         | 1 day on client VM; add 1–2 days on RDS.          |
| **E3 — outbox/checkpoint crash consistency**          | Transactional insertion and cursor advancement never diverge despite arbitrary kills or reboots.                                                   | Synthetic source and loopback ingestion server; random kill point in insert, checkpoint, upload, ack, and deletion paths; 10,000 iterations.                                       | Model checker; SQLite quick check; transaction/ack journal; idempotency-key counters.                                  | Zero checkpoint-ahead-of-event violations; zero missing committed IDs; duplicate delivery accepted but zero duplicate server records; DB valid every run.                                 | Delete test DB and server ledger.                          | 2 days engineering; 2–6 hours unattended run.     |
| **E4 — signed atomic update and rollback**            | Every interruption leaves a verifiable old or new payload, and an unhealthy new version rolls back.                                                | Test certificate; v1/v2/bad-v2; tampered, unsigned, and wrong-signer packages; interruption at each update phase.                                                                  | Updater state journal; Authenticode result; file hashes; service health; active manifest sequence.                     | Unauthorized code executed zero times; all interruption points recover within two starts; unhealthy v2 restores v1; DB remains readable.                                                  | Remove test trust root and payloads; reinstall v1 cleanly. | 1.5–2 days.                                       |
| **E5 — all-profile discovery and cursor correctness** | All profiles are found and late/old-timestamp visits are not lost.                                                                                 | Three profiles per browser; default/custom roots; identical timestamps; late rows; renamed/recreated DB; unsupported schema fixture.                                               | Expected-event manifest; discovered-source list; generation and cursor log.                                            | 100% expected final events; no profile mixing; no loss from old timestamps; recreated DB creates new generation; unknown schema makes no checkpoint progress.                             | Delete profiles/fixtures.                                  | 1–1.5 days.                                       |
| **E6 — process-observation fidelity**                 | The ordinary-user implementation meets the agreed “inventory” or “start-event” contract without debug privilege.                                   | Generate processes lasting 50 ms–10 min, elevated and ordinary; compare polling, WMI trace, and ETW where allowed.                                                                 | Ground-truth launcher log; CPU/working set; access-denied count; missed event histogram.                               | Inventory mode: ≥99% of processes lasting at least twice the poll interval. Start-event mode: threshold to be agreed; no `SeDebugPrivilege`.                                              | Stop generators and remove test binaries.                  | 1 day.                                            |
| **E7 — suspend, resume, reboot, and clock changes**   | Scheduling and cursors survive sleep/reboot and wall-clock changes without skips or storms.                                                        | Suspend/resume; reboot; ±24-hour clock jump; timezone/DST change; overdue jobs.                                                                                                    | Service control events; monotonic and UTC timestamps; task-launch and batch-rate metrics.                              | No duplicate storm above configured cap; no source-ID loss; catch-up begins with jitter within 60 seconds; persisted state remains valid.                                                 | Restore time/timezone and clear fixtures.                  | 0.5–1 day VM; Modern Standby requires device.     |
| **E8 — file locks and filter-driver interference**    | Transient sharing violations and latency cause bounded deferral, not corruption or busy loops.                                                     | Lock fixture DB/sidecars; inject delayed I/O; run Defender and available EDR; repeatedly open/close browser.                                                                       | ProcMon; SQLite extended codes; retry counts; task duration.                                                           | CPU remains bounded; no source writes; task exits within deadline; next eligible run succeeds.                                                                                            | Release locks; remove test filter configuration.           | 1 day, plus vendor-EDR access.                    |
| **E9 — disk full and backlog quota**                  | The agent protects committed data and degrades predictably before volume exhaustion.                                                               | Small expandable VHD; build backlog; fill volume at selected transaction phases.                                                                                                   | Free-space series; DB/WAL size; SQLite codes; collection/backpressure state.                                           | No silent deletion; no tight retry loop; existing DB passes quick check; collection pauses before critical free-space floor; upload resumes after recovery.                               | Detach/remove VHD and fixtures.                            | 1 day.                                            |
| **E10 — corruption and migration failure**            | Browser corruption, outbox corruption, and failed migration are contained and diagnosable.                                                         | Bit flips/truncation in copies; corrupt WAL; migration exception; kill during migration.                                                                                           | Integrity results; quarantine manifest; application version; migration journal.                                        | Browser corruption never alters cursor; outbox corruption enters controlled recovery; failed migration leaves old schema usable; no repeated crash loop.                                  | Securely delete corrupt fixtures.                          | 1 day.                                            |
| **E11 — Recent Items without dereference**            | Shortcut metadata can be read without accessing its target.                                                                                        | Local, missing, UNC, offline share, removable, and malformed `.lnk` fixtures.                                                                                                      | ProcMon network/file filters; packet capture; collector results.                                                       | Zero opens or network connections to targets; malformed shortcut isolated; only approved metadata emitted.                                                                                | Remove shortcuts and test share.                           | 0.5 day.                                          |
| **E12 — browser update/schema transition**            | An in-place browser update either remains compatible or fails closed.                                                                              | Stable-to-next update with active profile and pending cursor; downgrade fixture where possible.                                                                                    | Adapter/schema metrics; browser update logs; cursor/event comparison.                                                  | Supported schema continues with no loss; unsupported schema collects zero and holds cursor; kill switch works.                                                                            | Remove test channels/profiles.                             | 1 day per quarterly qualification run.            |
| **E13 — RDS/FSLogix/concurrent profile**              | Session and source leases prevent duplicate/cross-user collection in profile-container environments.                                               | AVD/RDS, FSLogix VHDX, several users, same-user multiple sessions, attach failure, forced logoff.                                                                                  | FSLogix logs; handle tracing; source leases; per-session event ledger.                                                 | No cross-user event; no profile detach blocked by UAM handle; duplicate rate after idempotency zero; attach failure fails closed.                                                         | Remove containers/users/policies.                          | 2–4 days with enterprise lab.                     |
| **E14 — native ARM64 and physical power**             | Native ARM64 binaries, SQLite, browser access, update, and resilience behave equivalently.                                                         | 26H1 ARM64 device; native browsers; standby and hard-power tests.                                                                                                                  | Architecture/module inventory; energy report; ETW; DB checks; updater state.                                           | No x64-only dependency; all core gates pass; no DB invariant violation after power tests; acceptable idle resource use.                                                                   | Restore clean image.                                       | 2–3 days after hardware availability.             |

---

# 4. Detailed first five VM prototypes

## Prototype 1 — consistent browser-history acquisition

### Hypothesis

A standard-user collector can read live browser history consistently without writing or blocking the browser, using a short read-only transaction in the common case and online backup as a bounded fallback.

### Setup

- Windows 11 25H2 x64 VM, fully patched.

- Two local standard users, but run this prototype under one user.

- Current stable Chrome, Edge, and Firefox.

- Temporary, dedicated test profiles only.

- Local HTTP service on `127.0.0.1`, serving URLs such as:

```text
http://127.0.0.1:48123/visit/<browser>/<profile>/<sequence>?nonce=<guid>
```

- Ground-truth server log containing sequence ID and request time.

- Collector harness built against the exact proposed SQLite package.

- ProcMon with filters for collector PID and browser History/Places paths.

### Steps

1. Create one fresh profile for each browser.

2. Visit 100 deterministic unique URLs while each browser is closed between groups; establish the basic schema/query.

3. Keep the browser open and generate 5,000 further navigations over 30–60 minutes.

4. Every 1–5 seconds, randomly choose:
   
   - Direct read-only transaction.
   
   - Online backup to scratch.
   
   - Cancellation during read.
   
   - Collector process kill.

5. Maintain a fixture SQLite database in WAL and rollback-journal modes with a helper process that holds read, write, and exclusive locks.

6. Verify behavior for `BUSY`, `LOCKED`, sharing violation, cancellation, timeout, and browser close.

7. After workload completion, close the browser normally.

8. Take a final offline reference read.

9. Compare emitted native IDs and URLs with the final database and HTTP truth log.

10. Repeat while a browser update is installed between runs.

### Instrumentation

For each attempt record:

```text
browser/version
profile source ID/generation
adapter/schema signature
read strategy
SQLite primary and extended result
busy retries
read/backup duration
rows examined
rows retained after privacy filter
first/last native ID
cursor candidate
scratch bytes and lifetime
collector CPU/working set
```

ProcMon must demonstrate no `WriteFile`, rename, delete, or create operation by the collector in the source browser directory. The browser’s own writes are expected.

### Pass threshold

- 10,000 acquisition attempts.

- Zero accepted snapshots failing `quick_check`.

- Zero collector writes to source database, WAL, SHM, or browser directory.

- Zero cursor advances after a failed or cancelled acquisition.

- After final reconciliation, every controlled visit present in the browser database is emitted exactly once after idempotent reduction.

- No TaskHost exceeds its deadline.

- Proposed performance gate: p95 direct read below 500 ms; p95 backup below 3 seconds for the test profiles; browser navigation p95 degradation below 5%.

- No full-history scratch copy remains ten minutes after task completion or reboot.

### Cleanup

Close browsers, delete temporary profiles and scratch directories, stop the local HTTP server, remove ProcMon backing files, and verify no scheduled task or service remains.

### Expected duration

One engineering day for harness and baseline, plus 4–8 hours of automated stress and half a day for analysis.

---

## Prototype 2 — per-session launch and authenticated IPC

### Hypothesis

A machine service running as LocalService and a Task Scheduler user process can support console, fast-user-switching, and RDP session transitions without LocalSystem, `SeTcbPrivilege`, or cross-user leakage.

### Setup

- Windows 11 Pro or Enterprise VM.

- Standard users `UamTestA` and `UamTestB`.

- Coordinator service under LocalService.

- Service SID enabled.

- Machine-wide logon-trigger task with group principal and LUA run level.

- User agent that sends only synthetic events.

- Explicit named-pipe DACL and `PIPE_REJECT_REMOTE_CLIENTS`.

- Test client capable of malformed and spoofed messages.

- AccessChk, Process Explorer, ProcMon, and WTS session logger.

### Steps

1. Install the service and scheduled task through the prototype MSI.

2. Log on as A and confirm one agent with A’s ordinary token.

3. Fast-switch to B; confirm a distinct agent and session.

4. Disconnect and reconnect each available session.

5. Lock/unlock, then log off one user.

6. Kill each agent and verify Task Scheduler restart behavior.

7. Start two agent copies in one session; verify the session mutex rejects the duplicate.

8. From A:
   
   - Guess and connect to B’s pipe.
   
   - Claim B’s SID in an envelope.
   
   - Replay an old handshake.
   
   - Send an oversized length prefix.
   
   - Send partial frames and stall.
   
   - Reuse a PID after terminating a process.

9. Inspect service token privileges.

10. Use ProcMon to prove the service never reads either user’s browser or profile files.

11. Confirm the service derives SID/session from the connection token and pipe metadata, not payload claims.

12. Run 1,000 randomized connect/disconnect/spoof cycles.

### Instrumentation

- Task Scheduler Operational log.

- Service `HandlerEx` session events.

- WTS session inventory.

- Client PID, creation time, SID, logon SID, and session ID.

- Pipe rejection reason and rate-limit counters.

- Process token groups, privileges, integrity level, and elevation type.

- Profile-path file operations by service and updater.

### Pass threshold

- Coordinator token is LocalService; no `SeTcbPrivilege`, `SeDebugPrivilege`, `SeBackupPrivilege`, or `SeRestorePrivilege`.

- No call path uses `WTSQueryUserToken`.

- Exactly one healthy user agent per eligible session.

- Agent always runs at medium or lower integrity with no elevated token.

- Zero cross-user or wrong-session messages accepted in 1,000 attempts.

- Oversized/partial clients consume bounded memory and are disconnected within the protocol deadline.

- Service opens zero user-profile files.

- Logoff removes agent and TaskHost processes and closes source handles within five seconds.

- Reconnect completes within 30 seconds.

A Windows client VM cannot demonstrate several simultaneously active RDS desktops; that part moves to E13.

### Cleanup

Delete test users and profiles, unregister the task and service, remove ProgramData state and pipe ACL test objects, and confirm no service recovery action remains queued.

### Expected duration

One engineering day on the available VM.

---

## Prototype 3 — transactional outbox and checkpoint invariant

### Hypothesis

No process termination, reboot, lost response, or duplicate acknowledgement can produce a checkpoint that is ahead of durable events.

### Setup

- Synthetic source emitting sequential IDs and timestamps.

- Proposed outbox schema.

- Local loopback ingestion stub with a durable receipt ledger and idempotency index.

- Fault hooks around every transaction and network transition.

- Model checker that reconstructs expected state.

Suggested state:

```text
source_checkpoint(source_id, generation, committed_native_id, ...)
outbox_event(event_key, source_id, generation, native_id, payload, state, ...)
upload_batch(batch_id, state, attempt, ...)
batch_event(batch_id, event_key)
server_receipt(event_key, first_batch_id, ...)
```

### Steps

1. Generate 100,000 deterministic events.

2. Insert events in randomly sized pages.

3. At randomized hooks, kill with `TerminateProcess` or `Environment.FailFast`:
   
   - Before event transaction.
   
   - After first insert.
   
   - Before checkpoint update.
   
   - After checkpoint update but before commit.
   
   - Immediately after commit.
   
   - During batch creation.
   
   - After HTTP send but before response.
   
   - After server commit but before client receives response.
   
   - During acknowledgement transaction.

4. Restart and recover after every kill.

5. Every hundred iterations, force a VM reset.

6. Randomly return duplicate, delayed, malformed, and retryable responses.

7. Run `PRAGMA quick_check` after recovery.

8. Have the model checker evaluate invariants.

9. Repeat with WAL checkpoints and database sizes representative of a long backlog.

### Instrumentation

- Durable transaction journal with hook ID.

- SQLite primary/extended codes.

- Source-page ID range.

- Before/after checkpoint value.

- Event and batch idempotency keys.

- Server receipt ledger.

- WAL size/checkpoint result.

- Recovery duration.

### Pass threshold

For 10,000 fault iterations:

1. `checkpoint <= highest durable source event`.

2. Every event at or below the checkpoint exists either in the pending outbox or the server receipt ledger.

3. No acknowledged event disappears without a server receipt.

4. Ambiguous sends may cause retransmission, but the server contains one logical record per idempotency key.

5. `quick_check` returns `ok` after every recovery.

6. No automatic queue deletion.

7. Recovery reaches a ready state within 30 seconds on the VM.

8. No WAL-reset-vulnerable SQLite runtime is loaded.

### Cleanup

Stop the stub server, archive only aggregate test results, and delete source, client, and server test databases.

### Expected duration

One to two days to implement the harness, followed by several hours of unattended fault execution.

---

## Prototype 4 — signed update, interruption, and rollback

### Hypothesis

The updater executes only authorized content and every interruption leaves a launcher-selected known-valid payload.

### Setup

- Prototype MSI installing stable launcher, coordinator v1, and updater.

- Locally generated test code-signing root and signer, trusted only on the VM.

- Valid v2.

- v2 that starts but deliberately fails health.

- Unsigned package.

- Correctly signed package altered after signing.

- Package signed by a different locally trusted signer.

- Local HTTP update endpoint; no production credentials.

- A/B active manifests.

### Steps

1. Verify clean v1 install, repair, and uninstall.

2. Update v1 to healthy v2.

3. Repeat while killing power/process at these boundaries:
   
   - Partial download.
   
   - Download complete before verification.
   
   - Manifest verified before file hashes.
   
   - Version directory partly populated.
   
   - Service stopped.
   
   - Inactive active-manifest written.
   
   - Manifest activation.
   
   - New process started before health.
   
   - Health succeeded before old-version cleanup.

4. Attempt unsigned, tampered, expired-test, wrong-signer, and downgrade packages.

5. Install unhealthy v2 and verify automatic v1 rollback.

6. Induce a v2 database migration failure.

7. Reboot after each interruption and invoke launcher recovery.

8. Attempt path traversal, junction, and hard-link substitutions in staging.

9. Test update while MSI repair is active; one must take the global installer/update lock and the other must fail safely.

### Instrumentation

- Package hash and signer identity.

- Exact `WinVerifyTrust` return.

- Timestamp and chain status.

- Updater state-machine phase.

- A/B manifest generation and checksum.

- Service start/exit/health codes.

- Active binary hash and version.

- Outbox schema/open result.

- File-system operations in staging and version directories.

### Pass threshold

- Unauthorized package execution count: zero.

- At every interruption point, launcher selects either complete v1 or complete v2—never a partially staged directory.

- Unhealthy v2 rolls back to v1 within two starts or 60 seconds.

- Rollback retains all committed outbox events.

- N−1 opens the post-attempt database or the migration is restored before rollback.

- Update never follows a staging reparse point outside the controlled root.

- MSI and self-updater never modify the product concurrently.

- Test trust root is not accepted outside the VM.

### Cleanup

Uninstall, delete the test certificate and root from all stores, remove version and staging directories, and reinstall a clean unsigned-development build only after the trust test is complete.

### Expected duration

Two engineering days.

---

## Prototype 5 — profile discovery, generation, and late-arrival cursor

### Hypothesis

The collector discovers all supported profiles and does not miss visits because of aggregate timestamps, browser sync-style late insertion, profile replacement, or identical event times.

### Setup

- Three temporary profiles each for Chrome, Edge, and Firefox.

- One default root, one non-default profile, one custom user-data/profile root.

- Unique localhost URL namespace per profile.

- Fixture copies for controlled SQL mutation while browsers are closed.

- Expected-event manifest.

### Steps

1. Create ten visits in every profile.

2. Give several visits the same source timestamp.

3. Run an initial collection and commit cursors.

4. Add new visits normally.

5. In fixture copies, add rows with new native IDs but old event timestamps to emulate late synchronized history.

6. Delete old rows without resetting the database.

7. Replace a database with a new file at the same path and lower IDs.

8. Rename and recreate a profile.

9. Introduce an unknown schema version or remove a required column.

10. Run two agents for the same SID/source and exercise the source lease.

11. Collect until no source has further rows.

12. Compare all event keys with the expected manifest.

### Instrumentation

- Every candidate root and rejection reason.

- Canonical path and file identity.

- Source ID and generation.

- Browser executable and schema signature.

- Native-ID range examined and committed.

- Overlap/deduplication count.

- Source-lease owner/session.

- Unsupported-schema event.

### Pass threshold

- Every supported profile is discovered.

- Zero events attributed to the wrong profile or user.

- New native IDs with old timestamps are collected.

- Identical timestamps do not collapse distinct native visits.

- Replaced database creates a new generation.

- Unsupported schema emits no data and does not advance a cursor.

- Concurrent session collectors produce one logical event after service deduplication.

- Final expected-event recall: 100% for the controlled fixtures.

### Cleanup

Close browsers, delete profiles and fixtures, release source leases, and verify that the ordinary user’s normal browser configuration was never read.

### Expected duration

One to one-and-a-half engineering days.

---

# 5. Fault-injection matrix

| Fault                        | Injection                                                         | Required behavior                                                                               | Pass evidence                                               |
| ---------------------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| **Normal reboot**            | Reboot with pending events and active sessions.                   | Service restarts, DB recovers, tasks resume at logon, no cursor jump.                           | `quick_check=ok`; model invariants; expected pending count. |
| **Hard VM power-off**        | Power off at random transaction/checkpoint points.                | Last incomplete transaction rolls back; committed transaction survives under agreed durability. | Event/checkpoint model; WAL recovery logs.                  |
| **Kill coordinator**         | Terminate during insertion, upload, and ack.                      | SCM recovery starts it; no partially committed page.                                            | Transaction invariants and recovery time.                   |
| **Kill user agent**          | Terminate during read and after result send.                      | Task restarts; unacknowledged cursor is reread and deduplicated.                                | No loss; duplicate count bounded.                           |
| **Kill TaskHost**            | Terminate or exceed job limit.                                    | Job cleanup; no partial result accepted; source cursor unchanged.                               | Job event and checkpoint log.                               |
| **Disk full**                | Fill small test volume before/during commit and checkpoint.       | Collection pauses; existing queue preserved; no busy loop or silent truncation.                 | Free-space/backpressure trace; `quick_check`.               |
| **Locked browser DB**        | Hold exclusive fixture lock; keep real browser active.            | Short bounded retry, then defer; no fallback raw copy.                                          | `BUSY/LOCKED` classification; cursor unchanged.             |
| **Corrupt browser database** | Truncate/bit-flip a fixture source.                               | Source rejected; no write or cursor advance; browser itself untouched.                          | Adapter error and unchanged source checkpoint.              |
| **Corrupt outbox DB/WAL**    | Truncate copies, swap WAL, flip pages.                            | Stop writes, quarantine complete set, create controlled clean state, diagnostic.                | Quarantine manifest; no crash loop.                         |
| **Network loss**             | Drop route, close connection after server commit, return 5xx/429. | Jittered retry; queue retained; idempotent replay.                                              | One server record per event key.                            |
| **Clock change**             | ±24 hours, timezone change, DST boundary.                         | Scheduling recalculates; source-ID cursor prevents skips; no burst above cap.                   | ID sequence and batch-rate trace.                           |
| **Sleep/resume**             | VM suspend and physical Modern Standby.                           | No assumption that timers fired during sleep; jittered catch-up.                                | Power event and due-work trace.                             |
| **Update interruption**      | Kill updater or power off at every state transition.              | Valid v1 or v2 selected; partial staging never active.                                          | Manifest validation and active binary hash.                 |
| **Signature failure**        | Unsigned, tampered, wrong signer, invalid timestamp.              | Reject before executable placement/launch.                                                      | `WinVerifyTrust`/signer audit; execution count zero.        |
| **Health-check rollback**    | v2 exits, hangs, or cannot open outbox.                           | Restore previous manifest and v1; preserve data.                                                | Health timeout, rollback event, DB comparison.              |
| **Migration failure**        | Throw or kill mid-migration.                                      | SQLite transaction rolls back or pre-migration backup restores; old binary works.               | Schema and application-open test.                           |
| **Antivirus/filter delay**   | Hold files, inject access denied, scan staging and DB.            | Bounded backoff; no recommendation for a broad exclusion; actionable diagnostic.                | ProcMon and retry-duration limits.                          |
| **Profile detach/logoff**    | Forced logoff while TaskHost reads.                               | Cancellation and handle close; profile/container detach not blocked.                            | Handle trace and FSLogix event log.                         |
| **Poisoned IPC message**     | Oversize, invalid lengths/types, decompression bomb.              | Reject within limits; service remains healthy.                                                  | Memory/CPU ceiling and rejection metric.                    |

---

# 6. Recommended tools and APIs

## Use

| Area                     | Recommended API/tool                                                                                        | Reason                                                                                                                                                                                                                                                                                                             |
| ------------------------ | ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Session discovery        | `WTSEnumerateSessions`, `WTSQuerySessionInformation`, service `HandlerEx`                                   | Supported session enumeration and change notification without obtaining a user primary token. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsenumeratesessionsw "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsenumeratesessionsw")) |
| User launch              | Task Scheduler 2.0 logon trigger; interactive/group principal; LUA run level                                | Uses the already authenticated interactive token rather than service token duplication. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype "https://learn.microsoft.com/en-us/windows/win32/taskschd/principal-logontype"))                                           |
| Known folders            | `SHGetKnownFolderPath`                                                                                      | Avoids hardcoded localized profile paths.                                                                                                                                                                                                                                                                          |
| Recent shortcuts         | `IPersistFile`, `IShellLinkW` with raw metadata                                                             | Reads the shortcut without resolving/accessing the target.                                                                                                                                                                                                                                                         |
| Browser SQLite           | Read-only connection and bounded transaction; SQLite online-backup API fallback                             | Maintains SQLite consistency and avoids racing file copies. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))                                                                                                                                                                                  |
| Local outbox             | `Microsoft.Data.Sqlite` or a thin wrapper over a pinned official SQLite amalgamation                        | Controlled version and native architecture.                                                                                                                                                                                                                                                                        |
| DB validation            | `PRAGMA quick_check`; extended SQLite result codes                                                          | Explicit corruption and operational classification. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))                                                                                                                                                                                    |
| Process snapshot         | `CreateToolhelp32Snapshot`, `Process32First/Next`, `ProcessIdToSessionId`, `QueryFullProcessImageName`      | Supported process inventory without debug privilege. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/toolhelp/tool-help-functions "https://learn.microsoft.com/en-us/windows/win32/toolhelp/tool-help-functions"))                                                                              |
| IPC                      | `CreateNamedPipe` with explicit security descriptor, overlapped I/O, `PIPE_REJECT_REMOTE_CLIENTS`           | Local, authenticated, bounded channel. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights "https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights"))                                                                  |
| Child isolation          | Job objects, `UpdateProcThreadAttribute`, process mitigation policy                                         | Limits process tree and resources from creation. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects "https://learn.microsoft.com/en-us/windows/win32/procthread/job-objects"))                                                                                              |
| Service configuration    | `ChangeServiceConfig2` for service SID, required privileges, delayed start, preshutdown and failure actions | Native SCM controls for least privilege and recovery. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_failure_actionsa "https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_failure_actionsa"))                                           |
| Code trust               | `WinVerifyTrust`, certificate-chain policy, SignTool in release pipeline                                    | Authenticode validation and timestamping. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust "https://learn.microsoft.com/en-us/windows/win32/api/wintrust/nf-wintrust-winverifytrust"))                                                                   |
| Update pointer           | Versioned directories plus A/B manifests; `ReplaceFileW` for the small pointer                              | Avoids overwriting running executables. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew "https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-replacefilew"))                                                                             |
| Installer coordination   | MSI, Restart Manager                                                                                        | Enterprise lifecycle and files-in-use handling. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/rstmgr/about-restart-manager "https://learn.microsoft.com/en-us/windows/win32/rstmgr/about-restart-manager"))                                                                                   |
| File and token diagnosis | ProcMon, Process Explorer, AccessChk, Handle                                                                | Verify real ACL, token, lock and write behavior.                                                                                                                                                                                                                                                                   |
| Performance              | WPR/WPA, ETW, `dotnet-counters`, EventPipe                                                                  | CPU, allocation, I/O and pause measurements.                                                                                                                                                                                                                                                                       |
| Test automation          | xUnit/NUnit, Pester for deployment harness, model-based state checker                                       | Reproducible unit, integration and fault tests.                                                                                                                                                                                                                                                                    |

## Avoid as production dependencies

| Avoid                                                                           | Reason                                                                                                                                                                                                                                                                                     |
| ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `WTSQueryUserToken` and `CreateProcessAsUser` in the normal coordinator path    | Requires a highly trusted LocalSystem design and expands token-handling risk. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken "https://learn.microsoft.com/en-us/windows/win32/api/wtsapi32/nf-wtsapi32-wtsqueryusertoken")) |
| `LoadUserProfile` to mine logged-off profiles                                   | Privilege, hive lifetime, profile-container and privacy complications.                                                                                                                                                                                                                     |
| LocalSystem for the long-running coordinator                                    | Excess authority relative to required work.                                                                                                                                                                                                                                                |
| `SeDebugPrivilege`, `SeBackupPrivilege`, `SeRestorePrivilege`, `SeTcbPrivilege` | Not justified for approved per-user collection.                                                                                                                                                                                                                                            |
| Interactive services or service-hosted UI                                       | Services are isolated in Session 0. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))                                           |
| Raw copy of active SQLite main/WAL/SHM files                                    | Not a consistent snapshot protocol and can omit committed state. ([SQLite](https://sqlite.org/wal.html "https://sqlite.org/wal.html"))                                                                                                                                                     |
| `immutable=1` against a live browser database                                   | It bypasses normal change assumptions and is inappropriate for a changing source.                                                                                                                                                                                                          |
| Deleting a browser WAL or changing its pragmas                                  | The browser owns the database.                                                                                                                                                                                                                                                             |
| Writing any browser database                                                    | Unsupported and unnecessary.                                                                                                                                                                                                                                                               |
| Timestamp-only browser checkpoint                                               | Can miss late insertion with old event time.                                                                                                                                                                                                                                               |
| One “newest” browser profile                                                    | Loses multi-profile activity; legacy behavior must not be carried forward.                                                                                                                                                                                                                 |
| `WScript.Shell` plus `Test-Path` on Recent targets                              | Can touch unavailable or network destinations.                                                                                                                                                                                                                                             |
| Parsing private Quick Access/Jump List storage as a supported contract          | Version-dependent reverse engineering without a stable global API.                                                                                                                                                                                                                         |
| Arbitrary PowerShell or `Invoke-Expression` from policy                         | Remote-code-execution and auditability risk. The legacy behavior should be removed.                                                                                                                                                                                                        |
| Security event 4688 as the process-source dependency                            | Requires customer audit-policy changes and privileged log access.                                                                                                                                                                                                                          |
| Broad antivirus exclusions                                                      | Weakens endpoint protection and hides real interoperability defects.                                                                                                                                                                                                                       |
| MSI and custom updater operating concurrently                                   | Creates split ownership and unrepairable state.                                                                                                                                                                                                                                            |
| Overwriting the running service executable in place                             | Causes sharing, rollback, and partial-update problems.                                                                                                                                                                                                                                     |

---

# 7. Permissions and least-privilege table

| Component                    | Identity                                           | Required access                                                                                                                                                  | Explicitly not granted                                                                                                                       |
| ---------------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| MSI/bootstrapper             | Elevated administrator / Windows Installer service | Install Program Files payload; create service and task; create ACLs; register firewall/event resources; uninstall/repair                                         | Ongoing data collection; persistent credentials                                                                                              |
| Privileged updater           | LocalSystem, on demand                             | Read signed staging; write immutable version directories; update A/B manifests; stop/start product service; read outbox schema for health only                   | Browser/profile reads; arbitrary command execution; general-purpose shell; central DB credentials                                            |
| Coordinator service          | LocalService plus `NT SERVICE\UAMCoordinator` SID  | Full control to UAM ProgramData database/log directories; create pipe; read product configuration; read device private key; outbound HTTPS to approved endpoints | User-profile ACLs; service-control access beyond product updater; `SeTcb`, `SeDebug`, `SeBackup`, `SeRestore`; write access to Program Files |
| User agent                   | Interactive user, LUA                              | Read its own profile and browser data; read/execute product binaries; write its own scratch; connect to authenticated pipe                                       | Machine outbox file; other users’ profiles; elevation; direct network upload                                                                 |
| Collector TaskHost           | Restricted form of interactive user                | Read only approved source roots; write its isolated scratch; inherited IPC handle                                                                                | Global pipe discovery where avoidable; network; child process; ProgramData DB; update directories                                            |
| Uploader                     | Within coordinator                                 | Read pending minimized events; device credential; outbound HTTPS                                                                                                 | Raw browser databases and user-profile access                                                                                                |
| Ordinary local user          | User                                               | Read/execute signed binaries; start own scheduled task                                                                                                           | ProgramData queue/logs; update staging; other users’ scratch                                                                                 |
| Local administrator          | Administrator                                      | Administrative recovery is inherently possible                                                                                                                   | Product does not pretend ACLs can defend against a fully malicious local administrator                                                       |
| Enterprise deployment system | SYSTEM/admin during deployment                     | MSI install, repair, upgrade and removal                                                                                                                         | Runtime telemetry access unless separately authorized                                                                                        |

Recommended filesystem outline:

```text
C:\Program Files\Vendor\UAM\
    SYSTEM, Administrators: Full
    Users: Read & Execute
    Coordinator service SID: Read & Execute
    Updater: Full through SYSTEM identity

C:\ProgramData\Vendor\UAM\Data\
    SYSTEM, Coordinator service SID: Full
    Administrators: administrative access
    Users: No access

C:\ProgramData\Vendor\UAM\Staging\
    SYSTEM, Updater: Full
    Coordinator service SID: create/write downloaded package
    Users: No access; files not executable

%LOCALAPPDATA%\Vendor\UAM\Scratch\
    Current user, SYSTEM: Full
    Other users: No access
```

Set the service’s required-privilege list with `SERVICE_CONFIG_REQUIRED_PRIVILEGES_INFO` after testing the exact dependencies. Microsoft exposes required privileges and service SID configuration through `ChangeServiceConfig2`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-changeserviceconfig2w "https://learn.microsoft.com/en-us/windows/win32/api/winsvc/nf-winsvc-changeserviceconfig2w"))

Service recovery should be conservative:

- Delayed automatic start.

- Restart after approximately 5 seconds, 30 seconds, then 120 seconds.

- Reset failure count after a stable day.

- After the configured actions, remain stopped and surface a diagnostic rather than restart indefinitely.

- A fatal internal condition should terminate with an error so SCM recovery can act; a permanently broken service should not spin in an internal loop.

SCM failure actions apply when a service terminates without reporting `SERVICE_STOPPED`. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_failure_actionsa "https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_failure_actionsa"))

---

# 8. Known unknowns requiring enterprise access

These cannot be closed convincingly on an ordinary standalone VM:

1. **RDS/AVD concurrent sessions:** all-user Task Scheduler launch, source leasing, process visibility, session reconnect, and resource density.

2. **FSLogix:** VHD/VHDX attach/detach, same-user concurrent and multiple connections, profile differencing disks, abrupt session termination, compaction, and stale handles. FSLogix documents specialized modes for concurrent/multiple connections, so a single local-profile test is insufficient. ([Microsoft Learn](https://learn.microsoft.com/en-us/fslogix/reference-configuration-settings "https://learn.microsoft.com/en-us/fslogix/reference-configuration-settings"))

3. **Citrix UPM, Omnissa/VMware DEM, and Ivanti/AppSense:** profile root changes, exclusions, streaming, and logoff behavior.

4. **Non-persistent VDI:** whether the ProgramData outbox persists across recompose, image update, reset, and host evacuation.

5. **Enterprise browser policy:** custom user-data directories, disabled history, forced profiles, roaming/sync, release rings, and Store/MSIX browser installations.

6. **EDR and antivirus:** filter-driver lock behavior, Controlled Folder Access, application control, anti-tamper, and code reputation.

7. **WDAC/AppLocker:** signer policy, versioned directories, TaskHost child restrictions, emergency rollback signer, and certificate rotation.

8. **Device identity:** LocalMachine certificate enrollment, private-key ACLs, TPM-backed keys, renewal, theft/re-enrollment, and operation during domain or Entra connectivity loss.

9. **Proxy and TLS inspection:** mTLS behavior, authenticated proxy, CRL/OCSP reachability, offline signature verification, and enterprise root stores.

10. **Deployment authority:** Intune, Configuration Manager, Group Policy Software Installation, third-party tooling, maintenance windows, MSI repair, and self-update disablement.

11. **EFS and protected profiles:** whether a scheduled user process receives usable decryption access.

12. **Recent Items on enterprise shares:** shortcuts to DFS, Offline Files, SharePoint/OneDrive placeholders, removable media, and unavailable targets—without dereferencing them.

13. **Browser sync:** real late-arriving historical visits, deletion propagation, profile reset, and user sign-out.

14. **Privacy decisions:** whether title collection is permitted, URL path/query redaction, allowlist precedence, diagnostic escalation, local quarantine retention, and behavior at backlog limits.

15. **Quick Access scope:** whether stakeholders truly need Recent `.lnk` entries, pinned folders, frequent locations, Jump Lists, or the exact Explorer Home UI.

## Claims requiring physical Windows devices

| Claim                                           | Why a VM is inadequate                                                                                                                                                                                                                                               |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Native ARM64 installation and service operation | Emulation does not prove native PE, native SQLite, browser, installer, and updater behavior.                                                                                                                                                                         |
| Windows 11 26H1 new-device support              | Microsoft positions 26H1 for new 2026 hardware rather than broad in-place deployment. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/whats-new/windows-11-version-26h1 "https://learn.microsoft.com/en-us/windows/whats-new/windows-11-version-26h1")) |
| Modern Standby/S0 low-power idle                | Hypervisor suspend does not reproduce OEM firmware, network-connected standby, battery policy, or device-driver resume ordering.                                                                                                                                     |
| Genuine abrupt power loss                       | VM “power off” tests software crash recovery but not SSD write caches, storage firmware, controller barriers, or failing media.                                                                                                                                      |
| OEM EDR/storage/filter drivers                  | The meaningful interference occurs in actual enterprise images and drivers.                                                                                                                                                                                          |
| TPM/hardware-backed client key                  | A virtual TPM can test API flows but not every physical provisioning and recovery behavior.                                                                                                                                                                          |
| Battery/thermal/idle-resource claim             | VM CPU accounting cannot establish battery drain or OEM thermal effects.                                                                                                                                                                                             |
| Wi-Fi loss and roaming during resume            | Virtual NIC disconnect is useful but does not reproduce physical radio/driver timing.                                                                                                                                                                                |

The VM is sufficient for most logical correctness work: live browser locking, profile discovery, faulted processes, virtual disk-full conditions, network drop, clock changes, service recovery, Task Scheduler launch, signed-update interruption, and model-based outbox testing.

---

# 9. Go/no-go gates before the full Browser History vertical slice

## Gate G0 — privacy and source contract

**Go only when:**

- Approved browsers, fields, profiles, users, and URL transformations are explicitly defined.

- Private/incognito behavior is defined as non-collection.

- Titles, query strings, fragments, file URLs, localhost, intranet, and diagnostic escalation have written policies.

- Quick Access is not ambiguously bundled into “Recent.”

- Local scratch and corruption-quarantine retention are approved.

**No-go:** requirements depend on collecting first and filtering centrally.

## Gate G1 — low-privilege session architecture

**Go only when E2 proves:**

- Coordinator is LocalService.

- No `WTSQueryUserToken`, profile loading, `SeTcbPrivilege`, `SeDebugPrivilege`, backup privilege, or restore privilege.

- Exactly one ordinary-user agent starts per eligible session.

- Cross-user and cross-session messages are rejected.

- Service opens no browser/profile files.

**No-go:** production reliability requires promoting the coordinator to LocalSystem merely to access user data.

## Gate G2 — source acquisition correctness

**Go only when E1 proves:**

- Direct read or online backup returns consistent data.

- Source browser files receive zero writes from UAM.

- Busy/locked sources are deferred without checkpoint movement.

- No raw file-copy fallback is required.

- Scratch lifetime and size are bounded.

**No-go:** correctness depends on racing `copy History*` or assuming browsers are closed.

## Gate G3 — profile and cursor correctness

**Go only when E5 proves:**

- Every supported profile is independently discovered.

- Native visit identity is collected.

- Late old-timestamp rows are found.

- Profile recreation creates a new generation.

- Unknown schema fails closed.

- Final controlled-fixture recall is 100%.

**No-go:** one browser-wide datetime remains the only checkpoint.

## Gate G4 — durable local transaction model

**Go only when E3 proves across at least 10,000 injected failures:**

- Zero checkpoint-ahead-of-event violations.

- Zero loss of committed events.

- `quick_check` succeeds after normal crash recovery.

- Ambiguous HTTP outcomes produce retransmission but no server duplicate.

- No error path deletes the queue.

The legacy deferred-CSV path deletes its pending CSV after processing failure, which must not be reproduced.

## Gate G5 — signed update and rollback

**Go only when E4 proves:**

- Unsigned, tampered, and wrong-signer packages execute zero times.

- Every interruption leaves a valid v1 or v2.

- A health-failing version rolls back automatically.

- N−1 remains compatible with the local schema.

- MSI repair and self-update cannot run concurrently.

- Signer rotation and emergency rollback have an approved key procedure.

**No-go:** rollback is only “reinstall the old MSI” after an irreversible database migration.

## Gate G6 — IPC and collector containment

**Go only when:**

- Explicit pipe DACL and remote-client rejection are tested.

- Identity is token-derived.

- Message sizes, nesting, decompression, rate and time are bounded.

- TaskHost is killed with its job.

- TaskHost cannot start arbitrary children or access the network.

- No remote policy can name an arbitrary executable, DLL, SQL statement, or PowerShell expression.

## Gate G7 — endpoint resource budget

Initial proposed threshold on a 2-vCPU test VM:

- Combined service and idle user agent average CPU below 0.5% over 30 minutes.

- Combined idle private working set below 150 MiB.

- No TaskHost remains after its deadline.

- No idle database write loop.

- Browser p95 navigation impact below 5% during stress collection.

- Direct browser read p95 below 500 ms for normal incremental pages.

- Catch-up work is rate-limited after resume/reconnect.

These values may be revised after measurements, but a measurable budget must exist before broad deployment.

## Gate G8 — supported-platform minimum

Before the first pilot:

- Windows 11 25H2 x64 passes all core gates.

- Windows 11 24H2 Enterprise/Education passes regression tests if still in support.

- Chrome, Edge, Firefox Release, and Firefox ESR each pass current-adapter tests.

- At least one browser in-use update passes.

- The team publishes explicit unsupported cases.

- ARM64, RDS, and FSLogix remain labelled conditional until their respective gates pass.

## Gate G9 — operational recovery

**Go only when support staff can distinguish and act on:**

- User agent missing.

- Profile unavailable.

- Browser busy.

- Browser schema unsupported.

- Policy rejected.

- Outbox full.

- Outbox corrupt.

- Network offline.

- Authentication failure.

- Signature failure.

- Update rollback.

- Repeated service crash.

Diagnostics must identify category, version, source pseudonym, timestamps, and error codes without logging raw URLs, titles, usernames, or full private paths.

---

# Final recommendation

Build the first five prototypes before implementing the production Browser History vertical slice. The likely winning design is:

- **MSI-installed stable launcher and privileged on-demand updater.**

- **LocalService machine coordinator with a service SID.**

- **One Task Scheduler-launched standard-user agent per interactive session.**

- **Out-of-process TaskHosts constrained by job objects.**

- **Direct read-only browser queries with SQLite online backup only as a protected fallback.**

- **Per-profile, generation-aware native visit cursors.**

- **Machine-owned SQLite WAL outbox with event and checkpoint in one transaction.**

- **Versioned signed payload directories and health-checked A/B rollback.**

A service-only collector should be rejected unless the prototypes uncover a browser or enterprise-profile constraint that cannot be solved in user context. Even then, the exception should be narrowly scoped; it should not turn the main coordinator into a general LocalSystem profile-mining agent.
