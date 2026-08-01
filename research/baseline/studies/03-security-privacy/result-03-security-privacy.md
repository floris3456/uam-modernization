# UAM replacement security and privacy threat model

**Assessment date:** 30 July 2026  
**Scope:** Windows collectors, local outbox, device identity, update and task delivery, ingestion APIs, queue, workers, relational storage, backups, integrations, admin portal, diagnostics, exports, retention, and deletion.  
**Status:** Technical security and privacy engineering advice; not legal advice.

## Executive determination

The proposed replacement is a defensible default **only if several properties become architectural invariants rather than optional configuration**:

| Area            | Required invariant                                                                                                                                                                               |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Endpoint trust  | A managed endpoint is authenticated, but never assumed truthful or uncompromised. Telemetry from a compromised endpoint is untrusted evidence.                                                   |
| Database access | Endpoints never receive database credentials and never submit SQL or database-shaped commands.                                                                                                   |
| Collection      | Minimization, allowlisting, and redaction happen before data enters the outbox. The server cannot ask an endpoint to bypass hard privacy prohibitions.                                           |
| Privilege       | Per-user data is read by a collector in that user’s session. A separate, narrow service handles transport and storage. Only the updater needs carefully constrained elevated replacement rights. |
| Tasks           | The ordinary control plane distributes declarative, capability-bounded tasks—not arbitrary PowerShell, scripts, DLLs, or command lines.                                                          |
| Identity        | Each device uses a distinct, preferably TPM-backed key and managed certificate. Tenant or organizational realm is derived from authenticated server-side identity, never from a payload field.   |
| Updates         | Authenticode is combined with TUF-style role separation, expiry, hash/length verification, and rollback/freeze protection.                                                                       |
| Administration  | Detail access, diagnostics, exports, policy publication, and break-glass access are separate capabilities requiring justification, approval where appropriate, expiry, and immutable audit.      |
| Deletion        | Retention and deletion cover live databases, queues, replicas, exports, search indexes, backups, endpoint outboxes, and restored environments.                                                   |

The legacy material confirms that this is not merely a transport migration. Static inspection shows endpoint-held database trust, locally deferred SQL-shaped data, configuration-controlled code execution, elevated collection, detailed URLs and paths, rich error information, portal-managed scripts and schedules, broad data mutation, and an ordinary mutable database audit table. Those capabilities must not be carried forward behind an HTTPS API. Static inspection cannot prove every production behavior or external consumer, so the migration inventory still needs runtime validation.

The security model follows zero-trust principles: device ownership or network location grants no implicit trust, and both subject and device authorization are evaluated before access. The software-development baseline should be NIST SSDF; privacy engineering should use NIST Privacy Framework 1.0 as the current final baseline because Privacy Framework 1.1 remains an initial public draft in July 2026. ([NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/207/final "https://csrc.nist.gov/pubs/sp/800/207/final"))

### Residual risks that cannot be designed away

1. **A local administrator or SYSTEM-level malware can observe live plaintext, use a legitimate device key through the running service, disable collection, or fabricate plausible telemetry.** TPM-backed keys prevent straightforward export; they do not make a live compromised computer trustworthy.

2. **A validly signed malicious release can compromise the fleet** if the build environment, approval process, signing service, or sufficient root keys are compromised.

3. **Minimized usage data can still reveal or support sensitive inferences**, especially when joined with identity, HR, location, or case-management data.

4. **Authorized insiders remain a material privacy threat.** RBAC alone does not prevent a person with a nominally valid role from using data for an improper purpose.

5. **Fine-grained secure deletion is limited by WAL files, SSD behavior, replicas, immutable backups, and previous exports.** Cryptographic deletion works only within deliberately engineered key boundaries.

6. **Shared computers, VDI reuse, clock manipulation, browser profile anomalies, and endpoint compromise can cause incorrect attribution.** UAM data must not be treated as sole proof of an employee’s conduct.

---

# 1. System, assets, actors, and trust boundaries

## 1.1 Recommended system decomposition

```text
Software sources and dependencies
        |
        v
Isolated CI/build -> signed provenance/SBOM -> release approval
        |                                      |
        +---------------------------> signing roles/repository
                                                   |
                                                   v
User session -> per-user collector -> authenticated local IPC
                                           |
                                           v
                              low-privilege core service
                                  |             |
                                  |             +--> separate privileged updater
                                  v
                         encrypted SQLite outbox
                                  |
                          TLS 1.3 + device mTLS
                                  |
                                  v
     edge/gateway -> ingestion -> durable queue -> workers -> telemetry store
                                               \-> quarantine/DLQ
                                  |
                                  v
             control API <- portal <- enterprise IdP / JIT privilege
                    |
                    +-> immutable audit sink
                    +-> approved exports/integrations
```

### Windows process split

**Per-user collector**

- Starts in each interactive user session under that user’s ordinary token.

- Reads only that user’s browser profile and recent-item locations.

- Performs canonicalization, allowlisting, sensitive-category denial, redaction, pseudonymization, and schema enforcement locally.

- Sends minimized events over an ACL-protected named pipe or authenticated RPC endpoint.

- Has no update rights, no machine-wide process-debug rights, no database credential, and no arbitrary task interpreter.

**Core service**

- Runs under a dedicated, noninteractive service identity with a service SID and only explicitly required privileges.

- Owns the encrypted outbox, batching, retry, policy verification, health reporting, and mTLS connection.

- Does not traverse arbitrary user profiles.

- Does not accept file paths, commands, SQL, assembly names, or script text from the server.

**Updater**

- A separate small service may run with the rights needed to replace binaries and restart services.

- It has no telemetry query capability, portal token, general remote-execution interface, or access to decrypted outbox events beyond what is strictly required for version migration.

- It accepts only packages authorized by both Windows code signing and update metadata.

- It performs staged replacement, post-install health checks, automatic rollback to the last known-good version, and ring-based rollout.

Windows supports service SIDs, removal of privileges not declared as required, object ACLs specific to a service, and network restrictions. That makes a dedicated least-privilege service preferable to a monolithic LocalSystem agent. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista "https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista"))

## 1.2 Trust boundaries

| Boundary | Untrusted or less-trusted side                    | Protected side                                      | Mandatory decision                                                                                                                    |
| -------- | ------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| B1       | Browser databases, shortcuts, process metadata    | Per-user collector                                  | Treat local source data as hostile input; bound lengths, types, encodings, paths, and timestamps.                                     |
| B2       | User-session collector                            | Core service                                        | Authenticate the pipe caller, verify user SID and session, enforce a fixed message schema, and reject privileged commands.            |
| B3       | Other users and ordinary local processes          | Service files, policy, keys, outbox                 | ACL to service SID and SYSTEM; encrypt events before SQLite insertion; verify signed policy.                                          |
| B4       | Local administrator or SYSTEM malware             | UAM confidentiality and integrity                   | No complete technical boundary exists. Minimize exposure, detect compromise, and classify telemetry as untrusted.                     |
| B5       | Endpoint/network                                  | Ingestion edge                                      | TLS 1.3, client certificate validation, device status, revocation, batch anti-replay, and strict limits.                              |
| B6       | External client-cert headers                      | Internal identity context                           | Strip all inbound identity headers. Only a trusted gateway may create an authenticated internal assertion.                            |
| B7       | Ingestion                                         | Queue and workers                                   | Server-created realm/device identity; signed or integrity-protected envelopes; least-privilege producer/consumer identities.          |
| B8       | Queue                                             | Workers and database                                | Revalidate schema and authorization at consumption; do not assume queue content is safe merely because it is internal.                |
| B9       | Workers                                           | Telemetry database, object storage, search, backups | Parameterized statements, realm isolation, separate service accounts, encryption, lifecycle rules, and deletion propagation.          |
| B10      | Portal user and browser                           | Portal/control API                                  | Enterprise SSO, phishing-resistant MFA, JIT activation, CSRF/session controls, capability and realm authorization.                    |
| B11      | Portal/control API                                | Detail data, exports, diagnostics, policies, tasks  | Purpose, ticket, target, time-window, approval, row limits, and immutable audit.                                                      |
| B12      | One customer, department, or organizational realm | Another realm                                       | Realm identity is server-derived and present in every authorization, queue, storage, cache, export, and audit operation.              |
| B13      | CI runner and dependencies                        | Release signing authority                           | Signing keys are unavailable to build steps; release service verifies provenance and approvals before signing.                        |
| B14      | Update repository/CDN                             | Updater                                             | Repository content remains untrusted until both metadata and package signatures, hashes, lengths, versions, and expiry are validated. |
| B15      | Operational database administrators               | Audit and privacy evidence                          | Privileged DB access is JIT and separately audited; audit evidence is exported to a different security boundary.                      |

Even for an initially single-customer deployment, implement an immutable server-side `realm_id`. A constant realm is safer than omitting the concept and attempting to retrofit isolation after integrations or shared hosting appear.

## 1.3 Prioritized assets

| Priority | Asset                                                                              | Security or privacy consequence of loss                                                                        |
| -------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| 1        | Collection-purpose boundary and hard minimization rules                            | Fleet-wide surveillance expansion, sensitive inference, and collection that cannot be repaired after the fact. |
| 2        | Offline update trust roots and release authorization                               | Persistent compromise of every endpoint and the recovery channel.                                              |
| 3        | Build provenance, source integrity, and online signing roles                       | Validly signed malware or unauthorized task packages.                                                          |
| 4        | Device enrollment authority, private keys, and device-to-realm mapping             | Impersonation, cross-realm submission, and inability to revoke compromised devices.                            |
| 5        | Raw or pseudonymous browser, recent-item, and process telemetry                    | Exposure of employee activity, sensitive interests, customer matters, file locations, or operational details.  |
| 6        | Portal identities and approval state                                               | Insider misuse, mass export, policy expansion, deletion, or remote execution.                                  |
| 7        | Subject and device identity mappings                                               | Reidentification, inaccurate attribution, and data-subject request errors.                                     |
| 8        | Immutable audit evidence                                                           | Inability to detect or prove misuse, policy changes, exports, or break-glass access.                           |
| 9        | Endpoint outbox, local diagnostics, crash data, and logs                           | Local privacy exposure and credential or topology leakage.                                                     |
| 10       | Queue, telemetry database, indexes, object storage, replicas, exports, and backups | Large-scale breach, tampering, retention failure, or cross-realm disclosure.                                   |
| 11       | Availability and fleet-control state                                               | Reconnect storms, disk exhaustion, loss of updates, or uncontrolled collection during outages.                 |
| 12       | Deletion tombstones, key inventory, and backup catalog                             | Data reappearing after restore or cryptographic deletion affecting the wrong scope.                            |

## 1.4 Actors and capabilities

| Actor                                                                              | Assumed capabilities                                                                                                                                 |
| ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Ordinary local user                                                                | Reads and alters user-owned files, browser state, shortcuts, environment variables, and user processes; sends malformed data to the local collector. |
| Malicious local administrator/helpdesk operator                                    | Reads most files, changes services and ACLs, debugs processes, copies disks, changes the clock, and invokes the legitimate service or TPM key.       |
| Endpoint malware                                                                   | Operates with user or administrator rights, fabricates local artifacts, injects into processes, tampers with telemetry, or steals bearer tokens.     |
| Stolen-device operator                                                             | Possesses a disk or a booted enrolled device; may know the user’s credentials or exploit an unlocked session.                                        |
| Network/API attacker                                                               | Replays traffic, floods endpoints, attacks parsers and decompression, abuses certificates, or probes authorization.                                  |
| Compromised tenant/realm administrator                                             | Has valid portal access for one scope and attempts to access or influence another.                                                                   |
| Authorized support, manager, analyst, privacy, security, or platform administrator | Has legitimate but potentially excessive access; may browse, join, export, or retain data for an unintended purpose.                                 |
| Queue, database, cloud, backup, or integration administrator                       | Can access infrastructure beneath application RBAC unless independently controlled.                                                                  |
| Build/release/PKI insider or compromised CI                                        | Can attempt to introduce code, misuse signing, issue device certificates, or weaken trust metadata.                                                  |
| Dependency or vendor compromise                                                    | Introduces malicious source, build tools, packages, browser parsers, or deployment components.                                                       |
| Accidental operator                                                                | Misconfigures a realm mapping, policy, retention, signing key, gateway, export, or restoration process.                                              |

## 1.5 Principal privacy harms

The threat model protects against more than confidentiality loss:

- Chilling effects and loss of workplace trust.

- Inference of health, union activity, religion, sexuality, political interests, financial distress, legal matters, whistleblowing, or personal relationships.

- Misclassification or inaccurate attribution on shared devices and VDI.

- Retaliation, embarrassment, discrimination, or improper disciplinary use.

- Function creep from application adoption analysis to individual productivity assessment.

- Reidentification of “pseudonymous” data by joining it with directory, HR, device, or schedule information.

- Exposure of customer matters, case names, project names, network shares, internal hosts, or security tooling through URLs and paths.

- Inability to exercise access, correction, objection, restriction, or deletion processes because copies cannot be located.

- Disproportionate monitoring of remote workers, contractors, shared-device users, or particular organizational units.

---

# 2. Threat register

## Rating method

- **Likelihood:** H = expected or easy at fleet scale; M = plausible; L = specialized or dependent on another compromise.

- **Impact:** C = fleet-wide, cross-realm, or recovery-root compromise; H = serious confidentiality, integrity, privacy, or availability harm; M = contained harm.

- Ratings are **inherent** before the recommended controls.

- **Residual** describes risk after the controls in this model.

- Owner abbreviations: **EE** endpoint engineering; **PKI** identity/PKI; **RE** release engineering; **PS** product security; **API** platform/API; **DATA** data platform; **PORTAL** portal/IAM; **SOC** security operations/incident response; **PRIV** privacy/data governance.

## 2.1 Endpoint, device identity, and outbox threats

| ID   | Threat and affected boundary                                                                                            | L / I | Prevention                                                                                                                                                                          | Detection                                                                                                      | Response                                                                                                                 | Residual risk                                                                        | Owner                 | Verification test                                                                                                                     |
| ---- | ----------------------------------------------------------------------------------------------------------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------ | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| E-01 | Compromised endpoint fabricates plausible events. B1–B5                                                                 | H / H | Treat events as claims, not trusted facts; per-device identity; signed policy/version; bounded event semantics; no disciplinary conclusion from UAM alone.                          | Sequence gaps, impossible rates, policy/version drift, EDR posture, statistical anomalies.                     | Revoke device, quarantine future batches, mark the compromise window untrusted, re-enroll after remediation.             | **M–H:** a live compromised host can still fabricate realistic activity.             | EE, SOC, PRIV         | Inject syntactically valid false events from malware; system must flag risk and preserve an “untrusted source” state.                 |
| E-02 | Ordinary user disables the collector, replaces user components, edits configuration, or deletes the outbox. B2–B3       | H / M | Signed binaries and policy; Program Files installation; service-SID ACL; App Control where available; service-managed outbox; no user-writable plugin path.                         | Missing heartbeat, binary/hash drift, unexpected service state, event gaps.                                    | Repair/reinstall through managed deployment; flag gap rather than silently implying no activity.                         | **M:** availability cannot be guaranteed on a hostile user session.                  | EE, SOC               | Standard-user test attempts replacement, policy edit, pipe spoofing, service stop, and outbox deletion.                               |
| E-03 | Local administrator or SYSTEM malware reads live events, keys, browser data, or modifies the agent. B4                  | H / H | Minimize before persistence; TPM-backed nonexportable keys; encrypted envelopes; no endpoint secrets beyond device identity; no raw URL/path/arguments.                             | EDR alerts, service/config integrity signals, unexpected key use, diagnostic traces.                           | Revoke, isolate, preserve evidence, declare data from the affected interval unreliable.                                  | **H:** administrative compromise remains outside the product’s enforceable boundary. | EE, SOC, PRIV         | Administrator lab exercise documents exactly what remains accessible and proves no claim of protection against SYSTEM is made.        |
| E-04 | Stolen device or cloned software credential authenticates as a legitimate device. B3–B5                                 | M / H | TPM key generation and attestation; nonexportable key; short certificate lifecycle; MDM state check; certificate-bound token; no bearer refresh token.                              | Concurrent use, abnormal network behavior, expired management state, failed attestation or inventory mismatch. | Immediate serial/key-ID block, CA revocation, token invalidation, device retire/wipe, controlled re-enrollment.          | **M:** a stolen unlocked device can use its genuine key.                             | PKI, SOC              | Clone the disk to another host; authentication must fail. Test a stolen but booted device and exercise rapid revocation.              |
| E-05 | Replay, duplicate delivery, batch reordering, or local sequence rollback. B3–B7                                         | H / H | Random batch ID; per-device sequence; content digest; server receipt time; unique database constraint; certificate binding; disable TLS 0-RTT for state-changing ingestion.         | Duplicate IDs, sequence regression, gap and reorder metrics.                                                   | Return the original idempotent acknowledgement; quarantine persistent regression; require re-enrollment for state reset. | **L** for duplicate effects; **M** for deliberate gap creation.                      | EE, API, DATA         | Replay identical and modified batches, reorder offline batches, reset local state, and run concurrent duplicate submissions.          |
| E-06 | Machine service reads another user’s browser profile or attributes data to the wrong RDS/VDI session. B1–B2             | M / H | User-context collector; no machine-wide profile traversal; pipe ACL includes expected service and user; verify caller SID/session; opaque subject mapping.                          | Collector/session mismatch, duplicate profile ownership, impossible concurrent session assignment.             | Stop affected collector, quarantine events, correct subject mapping, notify privacy owner where required.                | **M:** shared profiles and nonpersistent VDI remain attribution risks.               | EE, PRIV              | Multi-user RDS lab with concurrent sessions, profile redirection, fast user switching, and stale profiles.                            |
| E-07 | SQLite, WAL, temporary files, or filenames disclose event content or collection patterns. B3–B4                         | H / H | Encrypt each event before insertion; minimal plaintext metadata; neutral filenames; service-SID ACL; encrypted volume; bounded WAL and checkpointing.                               | ACL drift, unexpected file access, WAL growth, plaintext scanning.                                             | Rotate outbox key, stop collection, purge eligible files, repair ACL, re-enroll if key access suspected.                 | **M:** file size, timing, and row-count patterns can remain visible.                 | EE, PS                | Search DB/WAL/temp/free space for seeded sensitive strings after insert, update, deletion, checkpoint, crash, and vacuum.             |
| E-08 | Local tampering, rollback, database corruption, or disk exhaustion causes loss or repeated upload. B3                   | H / H | SQLite `synchronous=FULL`; integrity checks; hard byte/row/age quotas; bounded field sizes; controlled WAL checkpoint; authenticated ciphertext; explicit drop/backpressure policy. | Integrity-check failures, quota alarms, repeated sequence numbers, disk-space telemetry.                       | Pause nonessential collection; preserve health-only telemetry; rebuild outbox; record explicit data-loss interval.       | **M:** a local administrator can still delete or corrupt data.                       | EE, SOC               | Power loss, kill during commit, full disk, malformed DB, huge WAL, rollback to an old outbox, and low-space boot tests.               |
| E-09 | Diagnostic mode silently escalates collection or bypasses minimization. B9–B11                                          | M / H | Separate diagnostic capability; signed policy; named target and fields; two-person approval; maximum 24-hour expiry; hard prohibited fields; local expiry enforcement.              | Real-time activation alert, policy diff, target count, field-level sampling, expiry monitor.                   | Fleet kill switch; revoke diagnostic policy; purge over-collected data through all stages; investigate approvers.        | **M:** approved diagnostics may still expose more data than normal.                  | EE, PORTAL, PRIV, SOC | Attempt unsigned, expired, wildcard, backdated, overbroad, and unapproved diagnostic policies.                                        |
| E-10 | Logs, crash dumps, stack traces, configuration snapshots, or support bundles leak raw telemetry or secrets. B3, B5, B11 | H / H | Structured allowlist logging; no bodies; no full stack/config dump by default; dump capture off; local redaction; separate support-bundle approval.                                 | Automated sensitive-string scanner; log-schema tests; bundle inventory and access alerts.                      | Quarantine bundle, purge copies, rotate any exposed credential, correct redaction, notify affected owners.               | **M:** unforeseen exception text can still contain source data.                      | EE, API, SOC, PRIV    | Seed URL queries, filenames, usernames, tokens, certificate data, and SQL-like strings; verify absence from every log and crash path. |

Machine-scope DPAPI alone is not an acceptable outbox control: Microsoft documents that any user on the same computer can decrypt data protected with the machine flag. User-scope DPAPI normally binds data to the matching user and machine and includes an integrity check. The recommended design therefore wraps an outbox data-encryption key with a service-bound, TPM-backed key, using DPAPI only as an additional mechanism rather than the sole boundary. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata "https://learn.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata"))

SQLite can overwrite ordinary deleted content with `secure_delete`, but the setting is normally off, the fast mode leaves traces on freelist pages, and virtual-table shadow data is not fully covered. WAL files can persist and, in abnormal circumstances, grow without bound. Secure deletion claims must therefore cover WAL, temporary storage, SSD behavior, encryption keys, and backups—not merely execute `DELETE` or `VACUUM`. ([SQLite](https://sqlite.org/pragma.html "https://sqlite.org/pragma.html"))

## 2.2 Software supply-chain, task, and updater threats

| ID   | Threat and affected boundary                                                                               | L / I | Prevention                                                                                                                                                                            | Detection                                                                                                | Response                                                                                                                           | Residual risk                                                                                                 | Owner              | Verification test                                                                                                        |
| ---- | ---------------------------------------------------------------------------------------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| S-01 | Rogue task package or portal operator gains arbitrary code execution across endpoints. B10–B14             | H / C | No general script task type; declarative capability manifests; fixed trusted executors; separate draft/approve/publish roles; signed target scope and expiry; low-privilege taskhost. | New capability alert, manifest diff, unusual target count, task execution telemetry, EDR.                | Revoke task metadata, stop taskhost, block package hash/version, isolate affected ring, investigate approvers.                     | **M–H:** an authorized capability can still be abused within its scope.                                       | RE, EE, PORTAL, PS | Try PowerShell, command line, DLL loading, path traversal, network access, wildcard targeting, and capability confusion. |
| S-02 | Online targets, timestamp, or signing service key is compromised. B13–B14                                  | M / C | HSM-backed online keys; role separation; threshold approval for production targets; short metadata expiry; signing identity separated from TUF roles; package denylist.               | Unexpected signing time, release without provenance, transparency/inventory mismatch, unusual key use.   | Freeze rollout; rotate/revoke online role with offline root; publish emergency metadata; deny affected hashes and versions.        | **M / H:** valid malware may reach a ring before detection.                                                   | RE, PKI, SOC       | Compromise simulation signs an unauthorized package; release service and clients must reject or rapidly block it.        |
| S-03 | Threshold of offline root keys is compromised. B13–B14                                                     | L / C | Offline hardware tokens; proposed 3-of-5 threshold; geographical and personnel separation; ceremony records; no root key on CI or signing service.                                    | Key-custody reconciliation, ceremony witnesses, hardware-token audit, unexpected root metadata.          | Assume affected endpoints may be compromised; distribute a new trust root through an independent MDM/OS-trusted path or reinstall. | **Low likelihood / catastrophic consequence.** In-band recovery cannot be trusted.                            | CISO, PKI, RE      | Annual root-compromise exercise using only the documented out-of-band recovery channel.                                  |
| S-04 | Repository presents an old, frozen, mixed, or downgraded release. B14                                      | M / H | TUF root/targets/snapshot/timestamp roles; expiry; hash and length; consistent snapshot; highest accepted security version; minimum-version policy.                                   | Stale metadata, version regression, expired timestamp, snapshot/targets mismatch.                        | Reject update, retain last known-good version, alert release operations, refresh through an alternate repository.                  | **L** after correct TUF implementation.                                                                       | RE, EE, PS         | Expired metadata, freeze, rollback, mix-and-match, fast-forward, wrong length/hash, and clock-skew test corpus.          |
| S-05 | CI, compiler, dependency, or build action introduces malicious code that is later legitimately signed. B13 | M / C | Isolated ephemeral builds; pinned dependencies; protected source; reviewed build definitions; SBOM; signed provenance; signing service validates provenance and source revision.      | Reproducibility/diff analysis, dependency alerts, provenance verification, source-to-binary attestation. | Halt signing, rotate CI credentials, rebuild from trusted source, block affected hashes, investigate all signed outputs.           | **M / H:** sophisticated build compromise can produce valid provenance if the platform itself is compromised. | RE, PS, SOC        | Alter source, dependency lock, build runner, or provenance; verify signing refusal and consumer verification.            |
| S-06 | Updater service is hijacked to replace arbitrary files, alter ACLs, or gain SYSTEM execution. B3, B14      | M / C | Tiny updater surface; fixed installation roots; no arbitrary destination; atomic replacement; package manifest allowlist; service SID; named-pipe ACL; no generic “run” command.      | File-integrity monitoring, unexpected destination or service-control operation, updater command audit.   | Disable updater, fall back to managed repair, revoke package, restore known-good ACLs and binaries.                                | **M:** updater remains a valuable local privilege target.                                                     | EE, PS, SOC        | Path traversal, junction/reparse point, symlink, TOCTOU, DLL search-order, rollback, and partial-install attacks.        |
| S-07 | Emergency recovery mechanism bypasses normal signing or privacy controls. B13–B14                          | L / C | Dedicated offline recovery role; narrowly enumerated recovery actions; separate package format; two-person ceremony; out-of-band activation.                                          | Every recovery invocation alerts SOC and executive owner; compare action with incident ticket.           | Stop recovery channel, rotate recovery root, reimage endpoints where trust cannot be re-established.                               | **L / H:** recovery authority necessarily remains powerful.                                                   | PKI, RE, SOC       | Attempt to use recovery credentials for a normal feature release or to enable new collection fields.                     |

TUF separates root, targets, snapshot, and timestamp responsibilities and explicitly recommends keeping root keys offline. Its specification states that compromise of a threshold of root keys requires out-of-band root replacement and may be nearly impossible to recover from safely. Authenticode remains valuable for Windows publisher identity and OS integration, but it does not by itself solve freeze, rollback, or repository-compromise attacks. ([theupdateframework.github.io](https://theupdateframework.github.io/specification/latest/ "https://theupdateframework.github.io/specification/latest/"))

The build pipeline should produce verifiable provenance and preserve an authorized chain of supply-chain steps. SLSA provenance records how and from what inputs an artifact was built; in-toto layouts bind expected steps to authorized functionaries. ([in-toto](https://in-toto.io/docs/getting-started/ "https://in-toto.io/docs/getting-started/"))

## 2.3 API, queue, storage, and availability threats

| ID   | Threat and affected boundary                                                                                                                          | L / I | Prevention                                                                                                                                                                                      | Detection                                                                                                       | Response                                                                                                           | Residual risk                                                               | Owner                | Verification test                                                                                                             |
| ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| A-01 | Client-certificate identity is spoofed through a proxy header, or a CA issues an unauthorized certificate. B5–B6                                      | M / C | Validate mTLS at a controlled edge; strip external identity headers; authenticated edge-to-ingest hop; signed internal identity context; restrictive EKU/issuer; server-side inventory mapping. | Unknown issuer/EKU, duplicate device mapping, unexpected certificate issuance, header/certificate disagreement. | Block issuer, serial, key ID, or edge; rotate intermediate; re-enroll affected population; audit PKI operators.    | **L / H:** CA or edge compromise remains severe.                            | PKI, API, SOC        | Send forged certificate headers directly and through untrusted proxies; issue a cert outside policy; ensure no realm mapping. |
| A-02 | Oversized JSON, deep nesting, duplicate fields, decompression bomb, malformed encoding, or parser differential causes DoS or validation bypass. B5–B7 | H / H | Streaming parse/decompression; compressed and decompressed limits; ratio limit; bounded depth/count/string; one accepted encoding; strict schema; reject unknown fields and duplicate keys.     | Per-reason rejection metrics, CPU/memory ceilings, decompression-ratio alerts.                                  | Terminate request early, rate-limit identity/IP, quarantine repeated offenders, scale edge protection.             | **L–M** with limits and fuzzing.                                            | API, PS              | Grammar fuzzing, zip bombs, nested arrays, duplicate keys, invalid Unicode, integer overflow, and partial streams.            |
| A-03 | Six thousand endpoints reconnect together after outage, overwhelming TLS, ingestion, queue, or database. B5–B9                                        | H / H | Client jitter; exponential backoff; per-device and per-realm admission; queue buffering; bounded concurrency; bulk insert; circuit breakers; no synchronized polling.                           | TLS handshake rate, queue age/depth, saturation, 429 rate, outbox age, DB latency.                              | Shed nonessential health traffic, lengthen backoff, pause collection, add consumers, activate DR.                  | **M:** correlated reconnect remains likely.                                 | API, DATA, EE, SRE   | At least 6,000 near-simultaneous reconnects plus ten times steady-state load and multi-hour backlog recovery.                 |
| A-04 | Tenant/realm confusion, IDOR, cache-key omission, or forged payload field writes or reads another realm. B5–B12                                       | M / C | Derive realm/device from certificate and inventory; ignore payload realm; realm in every key and row; database row security or physically separate stores; scoped cache and object paths.       | Cross-realm canaries, authorization-denial metrics, invariant checks, unusual realm/device pairing.             | Disable affected API, revoke sessions, identify exposed records, correct mappings, conduct breach assessment.      | **L / H:** a single missing scope in a new query remains dangerous.         | API, DATA, PS        | Property-based cross-realm tests over every API, queue consumer, export, cache, search, and deletion operation.               |
| A-05 | Queue exposure, message tampering, poison messages, or confused consumer. B7–B8                                                                       | M / H | Private endpoints; per-service identities; encryption; server-created identity fields; integrity-protected envelope; schema revalidation; bounded retries; DLQ without raw data in alerts.      | Signature/schema failure, repeated consumer crash, DLQ growth, unexpected producer identity.                    | Disable producer/consumer, quarantine partition, rotate credentials, replay only verified messages.                | **M:** queue administrators retain infrastructure-level power.              | API, DATA, SOC       | Direct message injection, realm-field modification, poison messages, retry loops, and unauthorized queue reads.               |
| A-06 | SQL injection, overprivileged service account, portal direct database access, or unsafe dynamic query. B8–B11                                         | M / C | Parameterized statements; fixed stored operations; no client SQL; separate read/write/migration accounts; row security; no portal DB credential; migration approvals.                           | Query-shape monitoring, privilege-use alerts, schema-change audit, DB firewall.                                 | Revoke credentials, isolate database, restore affected data, review all accessed realms.                           | **L / H:** DB-owner or platform-admin compromise remains severe.            | DATA, API, SOC       | Injection suite, least-privilege negative tests, realm bypass tests, migration credential abuse, and portal compromise.       |
| A-07 | Application logs, metrics, traces, APM, reverse proxies, or DLQ alerts copy raw telemetry. B5–B11                                                     | H / H | Structured logging allowlist; no request/response bodies; redact query strings, identifiers, headers, exception data; classify telemetry fields; separate security and usage pipelines.         | Continuous PII/secret scanning, schema registry, access alerts, sampled review.                                 | Stop sink/export, purge eligible copies, rotate secrets, notify privacy/security owners, patch instrumentation.    | **M:** unexpected libraries can log before application redaction.           | API, DATA, SOC, PRIV | Canary strings in every sensitive field; scan all application, proxy, trace, metric-label, DLQ, and SIEM outputs.             |
| A-08 | Endpoint clock manipulation creates misleading ordering, retention, or employee attribution. B1, B5, B8                                               | M / M | Server receipt time is authoritative; bound client event time relative to receipt; preserve coarse collection window; never use endpoint time alone for enforcement.                            | Large skew, time regressions, impossible chronology, repeated future dates.                                     | Quarantine time-invalid events, mark quality flag, correct device time through management.                         | **L–M:** exact local activity time remains uncertain.                       | EE, DATA             | Move clock backward/forward, change time zone, suspend/resume, daylight-saving transitions, and replay old data.              |
| A-09 | Deletion or retention misses replicas, materialized views, search, exports, backups, or restored environments. B9–B12                                 | H / H | Data catalog; lifecycle by class; deletion manifest; tombstones; restore-time deletion replay; export registry; per-scope key inventory; no indefinite backup.                                  | Reconciliation counts, age scans, orphan-object scans, restore audits, failed-job alerts.                       | Freeze new exports/backups as needed, rerun deletion, crypto-shred eligible keys, notify governance owner.         | **M:** immutable media and prior recipient copies may persist until expiry. | DATA, PRIV, SRE      | Delete a seeded subject/realm and prove absence after replica lag, search refresh, export expiry, and full backup restore.    |
| A-10 | Prolonged outage fills outboxes or leads to silent data loss, repeated collection, or post-outage privacy overcollection. B3, B5, B7                  | H / H | Hard outbox age/size; priority classes; explicit oldest-drop or collection-pause policy; checkpoint independent of upload; bounded catch-up window; server admission control.                   | Outbox age/size, dropped-count metric, reconnect batch age, fleet backlog.                                      | Pause lower-value collection, preserve health and update channels, communicate data-quality gap, controlled drain. | **M:** availability and completeness trade-offs are unavoidable.            | EE, API, SRE, PRIV   | Seven-day outage, full disk, intermittent link, repeated crash, and reconnect-storm recovery without duplicate effects.       |

TLS 1.3 protects against eavesdropping, tampering, and message forgery; RFC 9846 is the current TLS 1.3 specification as of 2026. Mutual TLS can also bind an OAuth access token to the certificate presented by the client. ASP.NET Core provides request-decompression size enforcement and rate-limiting mechanisms, but those controls still need explicit endpoint limits and distributed DoS protection. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc8705?utm_source=openai "https://www.rfc-editor.org/rfc/rfc8705?utm_source=openai"))

## 2.4 Portal, insider, privacy, and governance threats

| ID   | Threat and affected boundary                                                                                                                 | L / I | Prevention                                                                                                                                                                      | Detection                                                                                                  | Response                                                                                                              | Residual risk                                                                  | Owner             | Verification test                                                                                                      |
| ---- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | ----------------- | ---------------------------------------------------------------------------------------------------------------------- |
| P-01 | Stolen portal credential or persistent broad administrator role accesses detail, exports, or control functions. B10–B11                      | M / C | Enterprise SSO; phishing-resistant MFA; JIT activation; short sessions; conditional access; separate capabilities; no standing superuser.                                       | Risky sign-in, activation alerts, impossible travel, unusual query/export volume.                          | Revoke sessions and activation, disable account, suspend exports/control plane, investigate accessed subjects.        | **M:** a compromised active privileged session can operate until contained.    | PORTAL, SOC       | Stolen-session simulation, role activation without MFA/approval, stale role, and session revocation latency.           |
| P-02 | Authorized administrator browses colleagues, public figures, complainants, or sensitive activity for curiosity or an unintended purpose. B11 | H / H | No unrestricted subject browser; purpose and ticket required; narrow target/time; JIT detail capability; approval for sensitive detail; no search by raw URL/path.              | Peer/celebrity lookup alerts, repeated unrelated subjects, off-hours access, purpose anomalies.            | Suspend capability, preserve audit, independent review, disciplinary/privacy process as defined by policy.            | **M–H:** legitimate access cannot be made misuse-proof.                        | PRIV, PORTAL, SOC | Insider exercise attempts access without case relationship and attempts to reuse an old ticket.                        |
| P-03 | Policy administrator expands allowlists, changes redaction, or targets selected employees. B11–B14                                           | M / C | Hard-coded prohibited fields; draft/approve/publish separation; signed policy; impact preview; target-count threshold; expiry; privacy approval for increased detail.           | Semantic policy diff, sensitive-category tests, target anomaly, fleet uptake report.                       | Revoke policy, publish signed stop policy, purge data collected under it, investigate approvals.                      | **M:** colluding approvers can still expand an approved capability.            | PRIV, PORTAL, EE  | Add query strings, command lines, wildcard users, sensitive domains, or retroactive collection; publication must fail. |
| P-04 | Bulk export or integration leaks data outside its approved purpose or realm. B11–B12                                                         | M / C | Separate export request/approval/execute; row and field caps; aggregate-first; encrypted short-lived delivery; recipient allowlist; watermark; DLP; export registry.            | Export size, frequency, subject count, destination, download and re-share alerts.                          | Revoke link/key, block recipient/integration, investigate copies, rotate integration credentials.                     | **M:** an authorized recipient can retain a downloaded copy.                   | PRIV, PORTAL, SOC | Export another realm, add prohibited fields, exceed row cap, use unapproved recipient, and access after expiry.        |
| P-05 | Portal or database administrator alters or deletes audit records. B11–B15                                                                    | M / H | Application audit plus independent append-only sink; chained event hashes or signatures; WORM retention; no product-admin delete permission.                                    | Sequence/hash gaps, sink divergence, WORM-policy change alerts, missing daily seal.                        | Preserve external copy, disable affected admin, reconstruct from supporting systems, rotate credentials.              | **L** if the audit boundary and keys are genuinely independent.                | SOC, DATA         | DB owner edits/deletes application audit; external sink must retain verifiable evidence.                               |
| P-06 | Analyst joins UAM with HR, directory, absence, case, health, or performance data to profile workers. B9–B12                                  | H / H | Purpose-specific data products; no ad hoc production joins; separate identity-resolution role; aggregation and minimum cohort thresholds; privacy review; query allowlist.      | Cross-dataset query audit, small-cohort detection, unusual subject resolution, downstream model inventory. | Suspend data product, remove derived data, assess decisions made from it, review affected individuals.                | **M–H:** organizational pressure can create function creep.                    | PRIV, DATA        | Attempt direct joins, single-person cohort, repeated pseudonym resolution, and inferred sensitive-category reporting.  |
| P-07 | Break-glass access becomes routine, remains active, or hides an improper access. B10–B11                                                     | M / H | Separate emergency role; two-person activation; phishing-resistant MFA; incident ID; maximum 60 minutes; no export by default; automatic expiry.                                | Immediate SOC/privacy alert, session recording or detailed action log, post-event review deadline.         | Terminate session, revoke role, investigate incident and approvers, document outcome.                                 | **M:** emergency access necessarily bypasses some normal friction.             | SOC, PRIV, PORTAL | Activate without incident, second approver, MFA, or valid time; attempt export and post-expiry use.                    |
| P-08 | Data-subject access, correction, restriction, or deletion is performed for the wrong person or realm. B9–B12                                 | M / H | Authoritative identity mapping; dual verification; scoped search; preview counts; second-person approval; signed completion manifest.                                           | Unexpected subject count, cross-realm match, deletion-volume anomaly, unresolved aliases.                  | Stop job, restore only where lawful and technically justified, correct mapping, notify governance owner.              | **L–M:** aliases, shared devices, and historical identifiers remain difficult. | PRIV, DATA        | Same name, renamed account, shared device, transferred worker, deleted directory account, and cross-realm cases.       |
| P-09 | Queue, database, cloud, or backup administrator bypasses portal controls. B9, B15                                                            | M / C | JIT infrastructure access; separation of duties; privileged workstation; independent audit; envelope encryption; export restrictions; key access separated from storage access. | Privileged query, snapshot, restore, key-use, and storage-download alerts.                                 | Remove access, rotate service and encryption credentials, identify affected datasets and copies, incident assessment. | **M–H:** platform administrators remain a high-value insider class.            | SOC, DATA, CISO   | Database snapshot/export under admin credentials, direct object download, backup restore, and key-service access.      |

JIT and approval-based privileged activation, MFA, justification, notifications, and access reviews are established capabilities of privileged identity-management systems. Audit evidence should be exported outside the ordinary product database to immutable storage; WORM controls can prevent modification or deletion for a defined interval. ([Microsoft Learn](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure "https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure"))

---

# 3. Misuse and abuse cases

A valid login and valid role do not make the resulting use legitimate. The portal should make improper uses difficult, visible, and reviewable.

| Misuse case                                                                                        | Privacy or security harm                                                                  | Required countermeasure                                                                                                                                                                                                  |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| A manager uses individual usage data as a productivity score or disciplinary shortcut.             | Function creep, inaccurate decisions, workplace chilling, discrimination.                 | Do not create a “productivity” role or metric. Provide aggregate application-adoption information. Contractually and technically prohibit individual performance use unless separately approved under a defined process. |
| Support staff searches for a colleague or prominent employee without an active case.               | Voyeurism and reputational harm.                                                          | Case-bound target access, JIT detail role, reason code, time window, anomaly detection, and independent review.                                                                                                          |
| An administrator adds sensitive domains to an approved collection list to investigate a person.    | Inference about health, union activity, legal advice, religion, politics, or sexuality.   | Hard local deny rules that normal policy cannot override; two-person privacy approval for any exceptional category; targeted policy alerts.                                                                              |
| A diagnostics operator enables detailed capture fleet-wide “temporarily” and fails to turn it off. | Large-scale overcollection and persistence in backups.                                    | Target and field limits, local maximum expiry, two-party approval, automatic purge, visible activation state, real-time alert.                                                                                           |
| An export operator downloads all subject-level records for offline analysis.                       | Uncontrolled copies, unlogged joins, indefinite retention.                                | Aggregate-first exports, row/field caps, recipient approval, encrypted expiring delivery, export registry, DLP, no raw-detail export by default.                                                                         |
| An analyst joins pseudonymous activity with HR and absence records.                                | Reidentification, sensitive inference, profiling, decisions outside the approved purpose. | Separate data products and roles; no direct production joins; minimum cohort thresholds; privacy review and query monitoring.                                                                                            |
| A task administrator deploys a script that harvests unrelated endpoint data.                       | Fleet-wide remote execution and covert surveillance.                                      | Eliminate general script delivery. Fixed, signed capabilities only. Remote shell and arbitrary PowerShell are separate products and threat models.                                                                       |
| A retention administrator extends retention to support a future unspecified use.                   | Purpose creep and increased breach impact.                                                | Approved maximums enforced in code; increases require privacy owner approval and documented purpose; reports of actual age by data class.                                                                                |
| A local administrator fabricates records to implicate or exonerate a user.                         | Incorrect employment or security decisions.                                               | Label endpoint telemetry as non-forensic; corroborate with independent evidence; preserve quality and compromise indicators.                                                                                             |
| Break-glass access is used because ordinary approval is inconvenient.                              | Routine bypass of privacy controls.                                                       | Break-glass does not grant exports, expires rapidly, alerts independent reviewers, and requires post-event review with sanctions for misuse.                                                                             |
| A DB administrator queries data directly, avoiding the portal audit.                               | Invisible insider access.                                                                 | JIT infrastructure access, privileged access workstation, DB-native audit sent externally, envelope encryption, and organizational separation of key and storage administrators.                                         |
| A business integration gradually consumes more fields than originally approved.                    | Silent expansion of purpose and recipient scope.                                          | Versioned integration contracts, field allowlists, recipient-bound credentials, periodic recertification, and automatic rejection of unapproved schema fields.                                                           |

The product should prominently state that **UAM is not an employee-performance scoring system, remote investigation tool, or forensic source of truth**. A technically valid event proves that an enrolled device submitted it; it does not prove who caused the underlying activity.

---

# 4. Device identity and update-signing designs

## 4.1 Recommended device identity

### Primary design: TPM-attested mTLS with optional certificate-bound access token

1. A managed bootstrapper requests enrollment through an authenticated device-management channel.

2. The endpoint creates a private key using the Windows Platform Crypto Provider.

3. Where supported, the enrollment authority verifies TPM key attestation.

4. The CA issues a device-authentication certificate containing:
   
   - an opaque device UUID;
   
   - an enrollment or assurance class;
   
   - an appropriate client-authentication usage;
   
   - no username, email, human-readable hostname, department, or tenant-controlled authorization role.

5. The backend maps certificate issuer, serial/key ID, and opaque device UUID to:
   
   - active/revoked state;
   
   - organizational realm;
   
   - expected hardware assurance;
   
   - allowed API audience and collection channel.

6. Each ingestion request uses mTLS. The payload’s device or realm fields are ignored for authorization.

7. For multiple backend APIs or an API gateway, the device may exchange mTLS authentication for a **5–15 minute certificate-bound OAuth token** with narrow audience and scope.

8. No reusable bearer refresh token is stored on disk.

9. Proposed certificate lifetime is **30–90 days**, with automatic renewal well before expiry and an emergency serial/key-ID block path independent of normal CRL caching.

10. Re-enrollment requires managed-device proof and creates a new key. A device must not silently reset its sequence or identity merely by deleting local state.

Microsoft’s Platform Crypto Provider uses the TPM for hardware-backed key storage, and TPM attestation allows a requester to prove to a CA that a certificate key is TPM-protected. RFC 8705 defines mTLS client authentication and certificate-bound OAuth tokens. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers "https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers"))

### Identity alternatives

| Design                                       | Security properties                                                                              | Operational properties                                              | Decision                                                                                                                                                                                                                |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TPM-attested mTLS certificate                | Nonexportable hardware-bound key; strong device enrollment assurance; direct sender binding.     | Requires compatible TPM/CA/MDM and attestation exception handling.  | **Recommended.**                                                                                                                                                                                                        |
| Managed mTLS certificate without attestation | Unique managed identity and revocation, but software key substitution or export may be possible. | Easier for VDI and older hardware.                                  | **Acceptable exception**, visibly marked lower assurance.                                                                                                                                                               |
| mTLS plus certificate-bound OAuth token      | Adds short-lived audience and scope control while retaining certificate binding.                 | More components and token-service availability requirements.        | **Recommended when multiple APIs/gateways justify it.**                                                                                                                                                                 |
| DPoP-bound OAuth token                       | Application-level proof-of-possession and replay detection without mTLS end to end.              | More nonce/key/token complexity; proxy compatibility may be easier. | **Fallback**, not first choice for this managed Windows fleet. RFC 9449 defines DPoP sender-constrained tokens. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc9449.pdf "https://www.rfc-editor.org/rfc/rfc9449.pdf")) |
| Software-stored certificate only             | Unique identity but weaker extraction resistance.                                                | Broad compatibility.                                                | Temporary quarantine/compatibility exception only.                                                                                                                                                                      |
| Per-device shared secret                     | Secret is exportable; rotation and attribution are difficult.                                    | Superficially simple.                                               | **Reject.**                                                                                                                                                                                                             |
| One fleet-wide secret or certificate         | One compromise impersonates all endpoints; no individual revocation.                             | Easy to deploy.                                                     | **Reject categorically.**                                                                                                                                                                                               |

Managed PKI products can automate issuance, renewal, and revocation, but lifecycle behavior must be tested rather than assumed. For example, management operations differ in whether a certificate is removed, revoked, or both. Maintain an application-level denylist and active-device check even when using CRLs. ([Microsoft Learn](https://learn.microsoft.com/en-us/intune/cloud-pki/ "https://learn.microsoft.com/en-us/intune/cloud-pki/"))

### Revocation behavior

The ingestion edge must evaluate:

- certificate chain, issuer, client-authentication usage, validity period, and algorithm;

- current device-inventory state;

- certificate serial/key-ID denylist;

- CRL or equivalent revocation state;

- assurance class, such as TPM-attested versus software;

- approved realm and API scope.

For internal device ingestion, an indeterminate revocation status should not result in indefinite soft-fail access. A short availability grace period may be defined, but the server-side blocklist must be authoritative and rapidly propagated.

## 4.2 Recommended update-signing design

### Independent layers

**Layer 1: Windows package authenticity**

- Authenticode-sign every executable, DLL, MSI, or MSIX.

- Apply a trusted timestamp.

- Validate the signature, chain, allowed publisher, file hash, and expected package type before installation.

- Consider App Control for Business to limit what may execute in the installation and task directories. Microsoft documents App Control as a policy system for declaring trusted applications and drivers. ([Microsoft Learn](https://learn.microsoft.com/en-us/windows/apps/package-and-deploy/code-signing-options "https://learn.microsoft.com/en-us/windows/apps/package-and-deploy/code-signing-options"))

**Layer 2: Repository and version security**

Use TUF-style roles:

| Role               | Suggested key handling                                       | Function                                                                                |
| ------------------ | ------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| Root               | Proposed 3-of-5 offline hardware tokens, separately held     | Authorizes all repository roles and rotations.                                          |
| Production targets | Proposed 2-of-3 approval; keys in HSM-backed release service | Authorizes exact packages, channels, target groups, security version, hash, and length. |
| Delegated targets  | Separate keys per stable/beta/emergency or product component | Limits the blast radius of a channel or component key.                                  |
| Snapshot           | Separate online HSM key                                      | Binds a consistent set of metadata versions.                                            |
| Timestamp          | Separate short-lived online HSM key                          | Prevents indefinite repository freeze.                                                  |
| Recovery           | Offline, separately held                                     | Authorizes only predefined recovery packages/actions.                                   |

Every target record should bind:

- content hash and byte length;

- package and component identity;

- architecture and operating-system constraints;

- release and security version;

- channel and deployment ring;

- minimum permitted predecessor;

- required schema and data-migration version;

- expiry;

- approved capabilities;

- provenance and SBOM digests.

The client stores the highest accepted security version and rejects:

- expired metadata;

- old timestamp or snapshot state;

- package rollback below the approved floor;

- mix-and-match metadata;

- wrong length or hash;

- a package validly signed by an unexpected publisher;

- a package whose manifest requests an undeclared capability.

### Release workflow

1. Protected source change and peer review.

2. Isolated build from pinned inputs.

3. SBOM and signed provenance generation.

4. Security tests and policy/minimization regression tests.

5. Release service verifies provenance, source revision, test attestations, and signer authorization.

6. Two-person production approval.

7. Authenticode signing and TUF target authorization through separate credentials.

8. Deployment to a small canary ring.

9. Automated health and privacy-field checks.

10. Progressive rings with an immediate global pause control.

11. Post-release attestation and archival of metadata, provenance, approvals, and binaries.

### Key rotation and compromise

- Rotate online role keys routinely and immediately on suspected compromise.

- Rotate root keys before expiry through a witnessed offline ceremony.

- Keep old public roots long enough to support safe transition, but remove obsolete trust according to TUF rotation rules.

- Maintain package-hash and version denylists independent of certificate revocation.

- Never use the compromised key to authorize its own emergency replacement where another trust role is available.

- A threshold root compromise triggers out-of-band trust replacement and likely endpoint remediation, not a normal online update.

## 4.3 Task-package design

The ordinary task system should support capabilities such as:

- collect approved browser-domain aggregates;

- collect approved application identity;

- rotate or compact the outbox;

- report fixed health counters;

- validate an installation;

- gather a predefined diagnostic artifact;

- apply a signed configuration;

- request an update check.

A task manifest should contain:

```text
task_type
schema_version
task_id
issuer
target realm/device/ring
not_before / expires_at
maximum_runtime
maximum_output_bytes
network_policy
filesystem_capabilities
required_agent_version
privacy_class
approval_reference
package_hash
```

It must not contain arbitrary source code, executable command lines, DLL entry points, registry paths supplied by the operator, SQL, or free-form file globbing.

Where a bounded PowerShell compatibility action is temporarily unavoidable:

- ship the script inside the signed agent release, not from the portal;

- identify it by a fixed capability ID;

- use Constrained Language/JEA-style restrictions where applicable;

- run under an unprivileged taskhost with no network and narrowly ACL’d files;

- prohibit parameters that become code, paths outside approved roots, or arbitrary environment expansion;

- require a migration deadline for removal.

---

# 5. Endpoint data-minimization specification

## 5.1 Privacy model

**Detailed collection is off by default.** The endpoint accepts only fields enumerated by a signed policy schema. Unknown fields are rejected or dropped before persistence. Exclusion lists are supplementary; they are not the primary protection. An exclusion model leaks every new sensitive value until someone notices and adds it. UAM needs a positive allowlist plus hard deny rules.

Processing order:

1. Read source record under the current user’s token.

2. Validate source type, length, encoding, and timestamp.

3. Canonicalize.

4. Apply hard prohibited-category and prohibited-field rules.

5. Apply explicit approved allowlist.

6. Transform to application/category identifiers.

7. Remove or pseudonymize identity.

8. Apply time bucketing.

9. Validate the outbound schema and size.

10. Encrypt the event.

11. Insert ciphertext into the outbox.

12. Destroy raw in-memory buffers as soon as practical.

## 5.2 Safe defaults by data class

| Data class                   | Safe default                                                                                        | Transformations                                                                                                    | Never collect by default                                                                                                                                                                                  | Exceptional detail                                                                                                           |
| ---------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Browser usage                | Approved application/site category ID or canonical registrable domain; coarse use date/time bucket  | Lowercase and normalize host; remove userinfo and unnecessary port; map approved sites to internal application IDs | Query string, fragment, password/userinfo, page title, form values, cookies, headers, full path, search terms, browser content                                                                            | Only an approved path template or first nonidentifying segment for a specifically authorized domain; never query or fragment |
| Sensitive browser categories | Drop locally                                                                                        | Hard deny before general allowlist                                                                                 | Health, union, religion, sexuality, politics, legal advice, whistleblowing, authentication, personal webmail, financial/banking, or equivalent high-risk categories unless a formally approved use exists | No ordinary policy override; separate exceptional governance and product capability                                          |
| Recent items                 | Approved storage-root alias, document/application class, and extension family                       | Replace root with neutral ID; report depth or class rather than names                                              | Full path, filename, username-bearing home path, UNC server/share, cloud-sync URL, shortcut arguments, file contents                                                                                      | Named approved business repository alias and limited path template only                                                      |
| Processes                    | Internal application ID; signed publisher; product; normalized executable basename/package identity | Strip user/temp/version/hash segments; map trusted install roots                                                   | Command line, arguments, environment, window title, document name, loaded modules, arbitrary full executable path                                                                                         | Approved install-root category where needed for application matching; not a user-specific path                               |
| User identity                | Opaque subject ID issued or resolved by the server                                                  | HMAC or tokenization with key rotation and realm separation                                                        | Username, domain account, email, display name, employee number in telemetry payload                                                                                                                       | Resolution only through a separate capability and audited service                                                            |
| Device identity              | Opaque device UUID derived from authenticated certificate mapping                                   | Server maps to inventory                                                                                           | Human-readable hostname in ordinary events                                                                                                                                                                | Hostname visible only to narrowly scoped support capability where operationally necessary                                    |
| Time                         | Hour or day bucket for usage; server receipt time for transport                                     | Bound event time relative to receipt; record quality flag                                                          | Nanosecond or exact-second activity time unless necessary                                                                                                                                                 | Exact operational timing for updater/API health, stored separately from usage data                                           |
| Organizational attributes    | Server-side approved organizational bucket                                                          | Join after ingestion only in a purpose-specific data product                                                       | Raw manager, job title, HR status, absence, or cost center in endpoint event                                                                                                                              | Approved aggregate reporting with minimum cohort threshold                                                                   |
| Network/location             | None in the telemetry payload                                                                       | Edge may temporarily retain truncated source network information for security                                      | Wi-Fi SSID, GPS, full IP history, nearby devices                                                                                                                                                          | Security logs only, separate access and short retention                                                                      |
| Diagnostics                  | Version, status code, counters, bounded component ID                                                | Enumerated errors; redact paths and identities                                                                     | Raw stack, memory dump, config dump, request body, URL/path samples, browser DB rows                                                                                                                      | Signed, targeted, time-limited diagnostic package with separate retention and approval                                       |

### Important pseudonymization rule

A bare hash of a username, hostname, domain, process name, or frequently used site is vulnerable to dictionary matching. Use a keyed HMAC or tokenization service with realm-specific keys. Even then, the value remains **pseudonymous personal data**, not anonymous data.

## 5.3 URL rules

The endpoint must reject or redact:

- userinfo in a URI;

- query and fragment;

- `file:`, `data:`, `javascript:`, browser-internal, extension, or equivalent non-approved schemes;

- localhost and raw IP literals unless an approved internal application mapping exists;

- authentication callback, password-reset, invite, token, session, and document-share paths;

- encoded values that become prohibited after repeated or ambiguous decoding;

- titles and search terms;

- values over the allowed canonical length.

Server logs must also avoid query strings and fragments. Microsoft now redacts URI query and fragment information by default in relevant .NET HTTP-client logging because those components commonly contain sensitive data. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/compatibility/networking/9.0/query-redaction-logs "https://learn.microsoft.com/en-us/dotnet/core/compatibility/networking/9.0/query-redaction-logs"))

## 5.4 Path rules

A permissible recent-item output resembles:

```text
repository_id: "approved-business-documents"
document_class: "spreadsheet"
extension_family: "office"
path_depth_bucket: "2-3"
used_on: "2026-07-30"
```

It does not resemble a local or network filesystem path. Remove:

- user profile names;

- customer, patient, complainant, employee, project, or case names;

- share/server names;

- GUIDs, emails, ticket numbers, and long numeric identifiers;

- temporary-directory values;

- shortcut arguments and targets outside approved repository classes.

## 5.5 Local outbox protection

### Storage layout

- Store under a machine-wide application-data directory.

- ACL to the core service SID and SYSTEM; deny ordinary interactive users.

- Neutral filenames with no username, hostname, or date range.

- Database, WAL, shared-memory file, temporary files, and backups inherit the same ACL.

- Use SQLite WAL with `synchronous=FULL`, a tested checkpoint policy, `journal_size_limit`, and bounded transactions.

- Set lower application-specific SQLite limits for SQL length, row/blob size, column count, and expression depth, even though only fixed prepared statements should be used.

- Limit proposed outbox occupancy to the smaller of:
  
  - **seven days of events**, or
  
  - **250 MiB per endpoint**,  
    subject to measured fleet volume.

- On approaching quota, stop lower-value collection rather than deleting high-priority security/update state.

- Record only counts and a quality gap—not the discarded values.

### Encryption

- Generate a random data-encryption key for an epoch, such as device plus month or device plus policy version.

- Encrypt each event envelope using authenticated encryption such as AES-GCM with a unique nonce.

- Wrap the epoch key with a TPM-backed service key.

- Keep only:
  
  - opaque row ID;
  
  - state;
  
  - coarse creation bucket;
  
  - retry count;
  
  - ciphertext length;
  
  - key epoch;
  
  - ciphertext and authentication tag.

- Avoid plaintext event type where it would reveal sensitive behavior.

- Destroy acknowledged ciphertext promptly under the approved local retention.

- Rotate the epoch key after suspected compromise and on defined schedule.

### Tamper protection

Authenticated encryption detects alteration of individual records. A sequence and previous-record digest can reveal simple removal or rollback, but it does not defeat an administrator who can control the service or use its key. Report tamper evidence as a data-quality signal rather than claiming forensic integrity.

## 5.6 Secure deletion and cryptographic-deletion boundaries

Local deletion cannot promise that a record is unrecoverable from every SSD cell, WAL page, crash dump, hibernation file, volume snapshot, or endpoint backup. NIST SP 800-88 Rev. 2 defines sanitization as making access infeasible for a defined level of effort and requires a media-specific sanitization program. ([NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/88/r2/final "https://csrc.nist.gov/pubs/sp/800/88/r2/final"))

Central cryptographic deletion should use deliberately narrow key boundaries:

| Boundary                             | Benefit                                 | Limitation                                                              |
| ------------------------------------ | --------------------------------------- | ----------------------------------------------------------------------- |
| Whole-database TDE key               | Protects stolen media                   | Far too coarse for subject, tenant, or retention deletion.              |
| Per-realm key                        | Supports realm/customer offboarding     | Cannot delete one subject or month without affecting all realm data.    |
| Per-realm, data-class, and month key | Practical expiry and incident isolation | A subject-level request still needs row deletion and tombstones.        |
| Per-subject key                      | Supports subject crypto-shredding       | Key count, joins, aggregation, and shared-device events become complex. |
| Per-record key                       | Maximum granularity                     | Usually excessive operational and indexing cost.                        |

Recommended default:

- Per-realm and data-class key hierarchy.

- Monthly or similarly bounded raw-telemetry data-encryption keys.

- Separate keys for diagnostics, exports, and identity mappings.

- No raw telemetry in immutable audit.

- Destruction of a key occurs only after the inventory confirms that every ciphertext copy within its scope is eligible.

- Restored backups must process the deletion/tombstone ledger before becoming queryable.

- Cryptographic deletion must not be claimed for plaintext exports, recipient copies, logs, caches, or systems not covered by the key.

## 5.7 Proposed engineering retention defaults

These are conservative technical defaults for governance approval, not legal conclusions:

| Data class                                                                 | Proposed default                                                                |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Endpoint outbox                                                            | Until acknowledged, with seven-day/250-MiB hard bound                           |
| Ingestion queue and retry storage                                          | Up to 72 hours after successful durable processing                              |
| Subject/device-level raw usage                                             | 30 days                                                                         |
| Approved subject-level daily aggregate                                     | 90 days                                                                         |
| Deidentified organizational aggregate meeting an approved cohort threshold | Up to 13 months where the business purpose requires trend comparison            |
| Elevated diagnostics                                                       | Seven days; shorter where practical                                             |
| Security and privileged-access audit                                       | Approximately 13 months, separate from usage telemetry                          |
| Temporary portal exports                                                   | 24–72 hours, then key destruction and deletion                                  |
| Online database backups                                                    | Proposed 35-day rolling maximum unless a separately approved requirement exists |
| Legal hold                                                                 | Separate explicit process, scope, owner, review date, and immutable-hold audit  |

The shortest period that satisfies the approved purpose should replace these defaults.

---

# 6. Security logging versus privacy

Structured logging and redaction should be schema-controlled. .NET provides explicit data-redaction facilities, and Microsoft warns that HTTP logging can record PII, especially when bodies are enabled. UAM should never enable generic request/response body logging in production. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/core/extensions/data-redaction "https://learn.microsoft.com/en-us/dotnet/core/extensions/data-redaction"))

| Event                                     | Record                                                                                              | Redact, tokenize, or hash                                                                                           | Access                           | Proposed retention                                      | Never record                                                              |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | -------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------- |
| Device TLS authentication                 | Time, result, issuer class, opaque device ID, realm, assurance level, reason code                   | Truncate or tokenize source network address; store certificate fingerprint/key ID, not full certificate             | SOC and PKI                      | 90–400 days based on security policy                    | Private key, full certificate PEM, usernames from certificate subject     |
| Certificate enrollment/renewal/revocation | Device ID, request ID, assurance result, CA, operator/service, result                               | Attestation details minimized to result and approved hardware class                                                 | PKI and SOC                      | Key lifecycle plus audit period                         | TPM secrets, enrollment challenge, recovery material                      |
| Batch accepted                            | Batch ID, device ID, realm, schema/policy version, counts, bytes, receive time, sequence range      | Event-type counts only where needed                                                                                 | Operations and SOC               | 30–90 days                                              | Event values, URLs, paths, process strings, request body                  |
| Duplicate/replay/gap                      | IDs, sequence, reason, count, server time                                                           | No content digest display outside restricted troubleshooting                                                        | SOC and operations               | 90 days                                                 | Original payload                                                          |
| Schema rejection                          | Field identifier, error code, size/depth, agent version                                             | Do not log rejected value; cap exception text                                                                       | Engineering and SOC              | 30 days                                                 | The malformed value or complete JSON                                      |
| Decompression/rate-limit event            | Compressed/decompressed byte counts, ratio, limiter key, result                                     | Tokenize device/IP as appropriate                                                                                   | SOC and SRE                      | 30–90 days                                              | Decompressed body                                                         |
| Update verification                       | Device ID, old/new version, metadata version, package hash, signer ID, result                       | No local installation paths containing users                                                                        | Release, SOC, support            | 400 days                                                | Package content, signing private material                                 |
| Policy/task publication                   | Author, approver, purpose, diff summary, target count/scope, hashes, expiry                         | Avoid embedding actual sensitive allowlist values in broad audit views; store restricted attachment where essential | Privacy, security, release audit | 400 days or approved audit term                         | Secrets, arbitrary source code in general audit                           |
| Portal login and role activation          | Actor, role/capability, realm, MFA, approval, justification ID, start/end                           | Tokenize device/network data in ordinary admin views                                                                | SOC and IAM                      | 400 days                                                | Authentication token, session cookie                                      |
| Subject/detail access                     | Actor, purpose, ticket, subject token, time window, fields viewed, result                           | Subject remains tokenized in general audit; restricted resolver separate                                            | Privacy, SOC, audit              | 400 days                                                | Returned telemetry values in the audit record                             |
| Search                                    | Actor, approved search type, result count, scope                                                    | Do not log free-form search value; use a controlled search-object ID                                                | Privacy and SOC                  | 180–400 days                                            | Raw URL, filename, path, query, employee-entered free text                |
| Export                                    | Requester, approver, purpose, fields, realm, subject count, row count, recipient, expiry, file hash | Tokenize subjects; restrict recipient details                                                                       | Privacy, SOC, export custodians  | 400 days                                                | Export contents, encryption key                                           |
| Break-glass                               | Incident ID, actors, approvers, capability, start/end, every action                                 | Minimal subject tokens                                                                                              | SOC, privacy, internal audit     | Long audit term                                         | Data viewed, unless a separately protected evidentiary record is required |
| Diagnostic activation                     | Actor, approver, target, field set, start/end, package hash, bytes returned                         | Opaque device/subject tokens in broad view                                                                          | SOC, privacy, support lead       | 400 days for activation; seven days for diagnostic data | Unapproved raw stack/config/body                                          |
| Queue/worker health                       | Message ID, realm, producer/consumer ID, status, latency, retry/DLQ reason                          | No event fields                                                                                                     | SRE and SOC                      | 30–90 days                                              | Message body                                                              |
| Deletion/retention                        | Request ID, scope, approved basis, item counts by store, key IDs destroyed, backup/tombstone status | Opaque subject/realm tokens                                                                                         | Privacy, data custodians, audit  | Long audit term                                         | Deleted content                                                           |
| Application exception                     | Component, enumerated error, correlation ID, version                                                | Redact paths, users, query strings, headers; map exceptions to stable codes                                         | Engineering                      | 14–30 days                                              | Raw SQL, command line, request body, config dump, secrets, browser record |
| Security detection                        | Rule, actor/device token, realm, reason, supporting event IDs                                       | Minimize source details to what the investigation requires                                                          | SOC                              | Incident policy                                         | Entire telemetry payload copied merely for convenience                    |

### Always prohibited in ordinary logs

- Access tokens, refresh tokens, passwords, cookies, private keys, DPAPI plaintext, or signing material.

- Request or response bodies.

- Full URLs, query strings, fragments, page titles, or search terms.

- Filenames, full paths, UNC paths, command lines, arguments, window titles, or environment blocks.

- Arbitrary SQL or database connection strings.

- Full policy/configuration snapshots.

- Complete stack traces containing local values.

- Raw browser databases or shortcut files.

- Unbounded exception objects.

- Full client certificates when a fingerprint, issuer class, and key ID suffice.

---

# 7. Controls for pilot and broad rollout

## 7.1 Minimum controls before any pilot

| Control area         | Pilot gate                                                                                                                                                                        |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Legacy trust removal | No endpoint database credential, direct database connection, submitted SQL, or deferred SQL file remains.                                                                         |
| Remote execution     | Configuration-driven arbitrary code execution and ordinary portal script delivery are removed.                                                                                    |
| Process split        | User-context collector, low-privilege service, separate updater, authenticated local IPC, and explicit service privileges are implemented.                                        |
| Device identity      | Unique managed device certificate, server-side device/realm mapping, revocation path, and no fleet-wide secret. TPM-backed key for supported pilot devices.                       |
| Transport            | TLS 1.3, mTLS, external identity-header stripping, and secure gateway-to-ingestion identity propagation.                                                                          |
| Updates              | Authenticode, hash/length verification, pinned update root, expiry, minimum version, rollback/freeze tests, and canary ring.                                                      |
| Local privacy        | Full URL, query, fragment, title, filename, full path, command line, arguments, window title, and raw username are absent from default collection.                                |
| Outbox               | Event-level authenticated encryption, service-SID ACL, hard quotas, tested WAL/checkpoint behavior, and no sensitive filenames.                                                   |
| API                  | Strict versioned schema, unknown-field rejection, bounded depth/strings/counts, compressed/decompressed limits, streaming parse, idempotency, sequence handling, and rate limits. |
| Realm isolation      | Realm is derived from device identity; cross-realm API, queue, cache, storage, export, and deletion tests pass.                                                                   |
| Portal               | Enterprise SSO, MFA, capability RBAC, no standing broad detail role, case-bound detail access, export disabled or tightly approved.                                               |
| Audit                | Independent append-only privileged-access and policy/update audit outside the ordinary product database.                                                                          |
| Retention/deletion   | Automated live-store deletion, queue expiry, export expiry, backup catalog, tombstones, and restore-with-deletion test.                                                           |
| Diagnostics          | Off by default; signed, targeted, field-bounded, approved, and automatically expiring.                                                                                            |
| Operations           | Device, CA, update-key, overcollection, cross-realm, queue, database, and deletion incident runbooks.                                                                             |
| Privacy review       | Approved purpose, prohibited uses, pilot population, notice, fields, retention, and access roles documented before collection starts.                                             |

## 7.2 Additional controls before broad rollout

| Control area          | Broad-rollout requirement                                                                                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Hardware identity     | TPM attestation coverage targets, lower-assurance exception inventory, expiry, and remediation deadlines.                                                                          |
| Signing governance    | Offline threshold root, HSM-backed online roles, witnessed ceremonies, routine rotation, emergency metadata, and out-of-band recovery drill.                                       |
| Build assurance       | Protected source, ephemeral isolated CI, pinned dependencies, SBOM, signed provenance, provenance-gated signing, and dependency response process.                                  |
| Fleet rollout         | Canary and progressive rings, automatic pause thresholds, privacy-field canaries, last-known-good rollback, and fleet version inventory.                                           |
| App control           | App Control/WDAC policy where compatible, at least for updater, service, taskhost, and plugin directories.                                                                         |
| Scalability           | Sustained and reconnect-storm testing above expected fleet volume; queue and DB failure injection; measured outbox catch-up time.                                                  |
| Portal privilege      | JIT/PIM activation, approval for detail/export/publish roles, quarterly access reviews, phishing-resistant MFA, privileged workstations for highest-risk operations.               |
| Insider detection     | Case-relationship analytics, unusual subject access, bulk-export alerts, small-cohort detection, and direct DB-access monitoring.                                                  |
| Privacy assurance     | Automated forbidden-field scanning of outbox, wire, queue, DB, logs, exports, and backups; periodic manual sample review.                                                          |
| Security validation   | Independent penetration test, threat-model update, code review of updater/parser/authz boundaries, and endpoint red-team exercise.                                                 |
| Data lifecycle        | Proven deletion across replicas, indexes, archives, restored backups, and integration recipients; cryptographic-key inventory reconciliation.                                      |
| Governance            | Completed DPIA or equivalent assessment where required, worker-representation process where applicable, approved notices, data-subject workflow, and formal prohibited-use policy. |
| Resilience            | CA and signing service DR, queue and database recovery, outage collection policy, and exercises covering multi-day network loss.                                                   |
| Customer independence | Per-realm identities, keys, storage boundaries, integrations, export policies, and deletion without shared customer secrets.                                                       |

### Broad-rollout no-go conditions

Do not proceed beyond a tightly bounded pilot while any of the following remains true:

- An endpoint has a database credential.

- The server can make the endpoint run arbitrary code through ordinary configuration or tasks.

- Full URLs, filenames, paths, process arguments, or usernames are collected by default.

- A portal administrator can both author and publish an update, task, or privacy-expanding policy.

- Tenant/realm scope comes from request data.

- Audit is editable by the same administrator whose actions it records.

- Diagnostic escalation lacks local expiry.

- A restored backup can reintroduce deleted data without replaying deletion state.

- A compromised signing or CA key has no rehearsed containment and recovery path.

---

# 8. Incident and key-compromise recovery

| Scenario                                              | Immediate containment                                                                                                       | Recovery                                                                                                                          | Evidence and privacy action                                                                                                     |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Compromised or stolen endpoint                        | Block device key/serial; revoke cert; invalidate bound tokens; quarantine new batches; isolate through endpoint management. | Remediate or reimage; generate new TPM key; re-enroll; reset sequence only through controlled server workflow.                    | Mark prior telemetry quality as uncertain from the earliest credible compromise time; assess local outbox exposure.             |
| Software device key copied                            | Block key ID and all certs using it; search for concurrent use.                                                             | Re-enroll with TPM-backed key; retire lower-assurance exception.                                                                  | Identify endpoints and realms that accepted the identity; review false submissions.                                             |
| Device issuing CA or enrollment authority compromised | Pause enrollment; block affected issuer/serial range; tighten edge trust; disable automated certificate issuance.           | Create or activate new issuing hierarchy; distribute trust; re-enroll affected devices; retire old CA after transition.           | Audit issued certificates, PKI operators, device mappings, and any cross-realm effects.                                         |
| Online update targets/signing key compromised         | Freeze all rollout; disable repository path; block suspicious package hashes and versions.                                  | Rotate online role using offline root; publish short-expiry emergency metadata; ship known-good package through verified channel. | Inventory every device that downloaded, installed, or executed the package; treat installed devices as potentially compromised. |
| Threshold offline root compromise                     | Stop all normal updates; assume update trust is lost.                                                                       | Out-of-band new root through independently trusted MDM/OS deployment or reinstallation; rotate all subordinate roles.             | Executive incident; preserve ceremonies and key-custody evidence; assess fleet compromise.                                      |
| CI compromise but signing keys remain protected       | Halt signing and release; preserve runner and provenance evidence; block affected source/build range.                       | Rebuild CI from trusted baseline; rotate CI credentials; rebuild and compare artifacts; sign only after independent verification. | Identify every signed artifact derived from the compromised platform and its deployment population.                             |
| Valid malicious package deployed                      | Pause updater and tasks; deny package hash/version; isolate affected rings.                                                 | Roll back only to a known nonvulnerable version; patch or reimage if privilege compromise occurred.                               | Determine what code executed, what data it could access, and whether endpoint identity keys were usable.                        |
| Cross-realm authorization defect                      | Disable affected endpoint or portal operation globally; revoke relevant sessions/tokens; preserve audit.                    | Correct all realm derivation and storage paths; add invariant tests; reprocess only verified messages.                            | Identify records read, written, exported, queued, cached, or deleted in the wrong realm; conduct notification assessment.       |
| Queue or database exposure                            | Restrict network and identities; stop exports/detail views; rotate service credentials and relevant DEKs.                   | Restore clean service, validate integrity, rebuild indexes/caches, re-encrypt where appropriate.                                  | Determine realms, fields, time ranges, administrator actions, downloads, and backup access.                                     |
| Diagnostic overcollection                             | Publish signed stop policy; stop upload and processing; disable diagnostic capability.                                      | Delete endpoint, queue, database, log, export, and backup-eligible copies; rotate diagnostic data keys.                           | Identify targets, fields, approvers, viewers, and recipient systems; perform privacy-incident assessment.                       |
| Retention/deletion failure                            | Stop new exports and affected backup jobs; prevent an unprocessed restore from becoming queryable.                          | Reconcile inventory, rerun deletion, apply tombstones, destroy eligible keys, verify restored backup.                             | Document affected subjects/realms, duration, systems, and failed control; update completion records.                            |
| Portal credential or insider misuse                   | Revoke sessions and JIT roles; disable exports and detail capability; preserve independent audit.                           | Reset identity, review role assignments, correct workflow, apply organizational response.                                         | Enumerate subjects, fields, searches, exports, tickets, and downstream copies accessed.                                         |
| Prolonged ingestion outage                            | Maintain update/revocation channel; activate bounded client backoff; pause low-value collection before disk exhaustion.     | Drain in controlled waves; prioritize oldest permissible data; discard expired data rather than extending retention.              | Record a transparent data-quality gap and confirm no catch-up policy bypassed minimization or retention.                        |

### Recovery principles

- **Freeze first, rotate second, restore trust third.**

- Keep device identity, update signing, audit signing, database encryption, and export keys in separate hierarchies.

- Do not solve a signing-key incident by granting broader portal remote execution.

- Do not accept “the binary still has a valid Authenticode signature” as sufficient after release-system compromise.

- Do not delete incident evidence by purging over-collected telemetry before recording a minimized, access-controlled incident manifest.

- Do not restore a backup into production until deletion tombstones and compromised-credential state have been replayed.

NIST key-management guidance covers key protection, lifecycle, compromise, trust anchors, and split knowledge; those concepts should be reflected in the operational key inventory and ceremonies. ([NIST Computer Security Resource Center](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final "https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final"))

---

# 9. Security and privacy acceptance tests

## 9.1 CI tests

| Test family          | Required tests                                                                                                                                                            | Pass condition                                                                           |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Minimization         | Property-based URL, IDNA, encoding, query, fragment, userinfo, localhost, sensitive-domain, file URI, UNC path, username path, email, GUID, command-line, and title tests | Zero prohibited values survive the endpoint transformation.                              |
| Outbound schema      | Unknown fields, duplicate keys, type confusion, integer overflow, excessive strings, arrays, timestamps, malformed Unicode                                                | Rejected before outbox insertion; no rejected value appears in a log.                    |
| Privacy snapshots    | Seed raw URL queries, filenames, paths, usernames, tokens, and process arguments through every collector                                                                  | Outbox plaintext, wire model, test queue, DB model, logs, and traces contain none.       |
| Cryptography         | Nonce uniqueness, tag failure, wrong epoch key, swapped ciphertext, truncated record, key rotation                                                                        | Altered or wrongly keyed events are rejected without plaintext logging.                  |
| Idempotency          | Identical, concurrent, reordered, partially retried, and content-modified batches                                                                                         | One durable effect per batch ID; modified replay fails digest or ID invariant.           |
| Realm authorization  | Change every payload realm/device/subject field; omit realm from caches and object paths in mutation tests                                                                | Authenticated server mapping wins; all cross-realm attempts fail.                        |
| Certificate binding  | Wrong certificate, wrong token certificate, expired/revoked cert, wrong EKU/issuer/audience                                                                               | Authentication denied and auditable without exposing cert content.                       |
| Parser/decompression | Fuzz JSON/CBOR parser; deep nesting; duplicate properties; compression bombs; ratio attack; partial stream                                                                | CPU, memory, compressed bytes, decompressed bytes, depth, and time remain within limits. |
| SQL/data access      | Injection corpus, ORM/raw-query review, least-privilege database tests                                                                                                    | No input becomes SQL structure; accounts cannot access another role or realm.            |
| Logging              | Automated canary scanner over application, proxy, worker, trace, metric, DLQ, and test SIEM output                                                                        | Zero secrets and zero prohibited telemetry fields.                                       |
| Update metadata      | Wrong root, expired metadata, freeze, rollback, mix-and-match, wrong hash/length, unauthorized channel, lower security version                                            | Updater rejects safely and remains on last known-good release.                           |
| Provenance           | Wrong source revision, unapproved build runner, altered SBOM, missing test attestation, unsigned provenance                                                               | Signing/release authorization fails.                                                     |
| Task capabilities    | Command injection, path traversal, wildcard targets, network use, arbitrary code, output overflow, timeout                                                                | Task rejected or contained; no privilege or network escape.                              |
| Portal authorization | Capability, realm, purpose, target, approval, and expiry matrix generated from policy                                                                                     | Deny by default; UI visibility never substitutes for API authorization.                  |
| Retention code       | Boundary dates, time zones, legal holds, failed jobs, idempotent deletion, tombstone creation                                                                             | Exact approved behavior with stable audit and no content in completion record.           |

ASP.NET Core’s default model-binding depth is bounded, but UAM should configure stricter application-specific depth and count limits rather than rely on framework defaults. ([Microsoft Learn](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/migrate-from-newtonsoft "https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/migrate-from-newtonsoft"))

## 9.2 Windows laboratory tests

- Standard user attempts to read the outbox, WAL, keys, policy, service pipe, installation directory, and updater endpoint.

- A different logged-on user attempts to impersonate the collector or read another user’s source profile through UAM.

- Concurrent RDS/VDI sessions verify user, session, and profile attribution.

- Administrator exercise demonstrates the documented residual ability to inspect or tamper, without yielding any central or fleet-wide secret.

- TPM and non-TPM enrollment, attestation failure, key deletion, motherboard change, certificate renewal, revocation, and re-enrollment.

- Disk clone to another host.

- Proxy and TLS interception, forged client-certificate headers, untrusted CA, wrong client certificate, TLS downgrade, and 0-RTT attempt.

- Power loss during SQLite transaction, service kill, OS restart, hibernation, full disk, WAL growth, database corruption, and old-database rollback.

- Search allocated DB, WAL, temp files, free pages, and support bundles for seeded sensitive strings.

- Update path traversal, reparse points, junctions, locked files, partial install, invalid ACL, DLL search-order, rollback, and failed health check.

- Taskhost sandbox escape, child process, network connection, registry access, excessive output, and timeout.

- App Control/EDR compatibility and false-positive testing.

- System clock and time-zone manipulation.

- Browser profile locked, corrupt, enormous, unusually encoded, or replaced during collection.

## 9.3 Pilot acceptance

A pilot is successful only when:

- Zero prohibited fields are found in sampled outboxes, network captures, queues, stores, logs, traces, or exports.

- One hundred percent of detail views, subject resolutions, diagnostic activations, policy publications, exports, and break-glass sessions have actor, purpose, scope, approval where required, and expiry.

- A revoked device is blocked within the documented emergency-revocation objective.

- Six thousand reconnecting endpoints are absorbed without cross-realm effects, unbounded memory, unbounded WAL, or uncontrolled database load.

- Duplicate delivery produces exactly one durable effect.

- A seven-day endpoint outage respects outbox limits and does not upload expired data afterward.

- Portal and DB administrators cannot erase independently stored audit evidence.

- A seeded deletion is absent from live storage, replicas, indexes, exports, and a restored backup.

- Diagnostic access expires locally even if the endpoint cannot contact the server.

- Lower-assurance devices are visibly identified and cannot silently receive higher-risk capabilities.

- Privacy and security owners review actual pilot output, not merely configuration screenshots.

## 9.4 Operational exercises before broad rollout

Conduct and record:

1. Online update-key compromise and emergency rotation.

2. Offline root-threshold compromise and out-of-band recovery.

3. Device issuing-CA compromise and mass re-enrollment.

4. Valid malicious package in a canary ring.

5. Cross-realm API defect.

6. Queue/database breach.

7. Authorized administrator voyeurism.

8. Break-glass misuse.

9. Diagnostic overcollection.

10. Deletion failure discovered after a backup restore.

11. Seven-day ingestion outage followed by fleet reconnect.

12. Revocation service and PKI renewal outage.

Each exercise needs an owner, decision authority, evidence sources, stop condition, RTO/RPO, privacy escalation point, communications path, and post-exercise corrective actions.

---

# 10. Unresolved legal and policy questions

These questions require the organization’s legal, privacy, employment, worker-representation, HR, information-security, and business owners. Technical controls do not determine the lawful basis or make a disproportionate monitoring purpose acceptable.

| Question                                                                                                    | Why it must be resolved                                                                                                          |
| ----------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| What precise business purpose is approved for each data class?                                              | “Application insight” is too broad to constrain fields, roles, retention, and outputs.                                           |
| Which uses are expressly prohibited?                                                                        | Performance scoring, discipline, attendance inference, covert investigation, and employee ranking need explicit treatment.       |
| Is collection necessary and proportionate, and were less intrusive alternatives evaluated?                  | Determines whether domain-level, application-level, aggregate, sampled, or no individual telemetry is appropriate.               |
| What lawful basis and employment-law conditions apply in each jurisdiction?                                 | Consent in an employment relationship may not provide an appropriate default; jurisdiction and purpose matter.                   |
| Is a DPIA required, and does it show an acceptable residual risk?                                           | Systematic employee monitoring and potentially sensitive inferences may create high privacy risk.                                |
| Is consultation or approval from a works council or other worker-representation body required?              | Dutch guidance states that use of a staff-tracking system to monitor employees requires works-council approval.                  |
| What notice will workers receive?                                                                           | Notice should describe fields, purpose, recipients, retention, rights, diagnostics, shared-device behavior, and prohibited uses. |
| How are personal, off-hours, remote-work, BYOD, shared-device, VDI, and contractor contexts handled?        | These contexts materially change attribution and proportionality.                                                                |
| Are sensitive-category domains always prohibited, or is any exception contemplated?                         | Even domain-only data can reveal health, union, political, religious, legal, or financial interests.                             |
| May data be used in an employment or disciplinary decision?                                                 | Endpoint telemetry can be incomplete or fabricated and should not be sole evidence.                                              |
| What correction or dispute process exists for inaccurate attribution?                                       | Shared devices, compromised endpoints, and profile reuse can associate an event with the wrong person.                           |
| What access, objection, restriction, portability, or deletion rights apply?                                 | The identity mapping, backups, exports, and recipients must support the approved procedure.                                      |
| What retention period is justified for raw, aggregate, diagnostic, security-audit, export, and backup data? | Each class has a different purpose and risk; one blanket period is inappropriate.                                                |
| Which legal holds may suspend deletion, who approves them, and when are they reviewed?                      | Indefinite or overly broad holds defeat purpose limitation and deletion.                                                         |
| Who is controller, joint controller, processor, or subprocessor for each hosted service and integration?    | Determines contracts, instructions, access, incident response, and data-subject handling.                                        |
| Are international transfers or external support access involved?                                            | Changes storage, access, contractual, and transfer requirements.                                                                 |
| Can organizational aggregates be released when cohorts are small?                                           | Small groups can allow reidentification or expose individual behavior.                                                           |
| May UAM data be joined with HR, absence, case, security, or financial data?                                 | Joins may create a new purpose and much higher inference risk.                                                                   |
| Are automated recommendations, risk scores, or profiling planned?                                           | These require separate assessment and should not be introduced as an incidental analytics feature.                               |
| What incident-notification and worker-communication thresholds apply?                                       | Needed before overcollection, insider misuse, or cross-realm incidents occur.                                                    |

For an EU/Dutch deployment, the GDPR remains the central statutory source. The Dutch supervisory authority states that employee monitoring must meet privacy-law conditions, that a DPIA is mandatory for processing likely to create high privacy risk, and that works-council approval is required for a staff-tracking system used to monitor employees. These are issues for qualified local counsel and governance bodies, not conclusions supplied by this technical model. ([EUR-Lex](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng "https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng"))

# Final risk decision

**A controlled pilot is supportable after every pilot gate in section 7.1 is met.** The architecture is not ready for broad deployment while endpoint database trust, arbitrary remote code, full-detail collection, broad standing administration, mutable audit, or unproven deletion remains.

The most important design decisions are:

1. Treat endpoints as authenticated but untrusted.

2. Split user-context collection from machine service and updater privilege.

3. Make minimization a non-bypassable endpoint function.

4. Use TPM-backed per-device mTLS identity, not bearer secrets.

5. Combine Authenticode with TUF role separation and anti-rollback metadata.

6. Replace general scripts with signed declarative capabilities.

7. Derive realm and device authorization server-side at every stage.

8. Bind detail access to purpose, target, time, approval, and independent audit.

9. Design deletion and restoration together.

10. State plainly that UAM telemetry is not forensic proof and must not become a general employee-performance system.
