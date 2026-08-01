# G2/G3 Edge profile discovery, safe acquisition, source identity, and cursor correctness

**Result path:** `results/batch-02-endpoint-data/07-g2-g3-edge-acquisition-cursor-result.md`  
**Research date:** 31 July 2026  
**Decision status:** **ACCEPT FOR G2/G3 IMPLEMENTATION PROTOTYPES WITH MANDATORY STOP GATES**  
**Authority boundary:** endpoint acquisition and source-progress architecture; **not** approval of legal purpose, production fields, time precision, lookback, retention, supported Edge estate, unsupported-environment treatment, pilot, or production use  
**Primary gate:** **failed, busy, locked, unsupported, corrupt, cancelled, identity-conflicted, or cleanup-failed reads never advance; controlled fixture recall is complete; no source write and no cross-profile/session mix occurs**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied input or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — a reasoned conclusion from stated facts.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed UAM decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority is required.
- **CLI EXPERIMENT** — code or lab measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements define the proposed G2/G3 implementation contract. They do not convert a **HUMAN DECISION** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION — use a bounded, user-session-owned Edge collector with three acquisition outcomes:**

1. discover only release-authorized Edge roots in the current User Host session;
2. try one short, hardened, read-only SQLite snapshot;
3. if the live database is busy or cannot provide a safe direct snapshot, use SQLite Online Backup into private memory;
4. if either method is uncertain, unsupported, corrupt, over budget, cancelled, or cannot prove cleanup, defer without moving the cursor.

The design deliberately chooses missed collection opportunities over source mutation or uncertain attribution. It never stops Edge, copies a live `History`/`-wal`/`-shm` triplet, opens a live database with `immutable=1`, scans an entire user home, or uses a timestamp as the cursor.

**RECOMMENDATION — identify a source by the concrete profile-directory lineage, not by a profile label, SID, path, or Edge display name.** A UAM-owned `source_id` represents one profile-directory lineage. A UAM-owned `source_generation_id` changes when the `History` database is replaced, the native ID sequence regresses or conflicts, or the required schema capability changes incompatibly. Raw paths and profile names remain inside the User Host and are neither durable endpoint data nor Coordinator diagnostics.

**RECOMMENDATION — use Chromium's local `visits.id` as the native cursor within one source generation.** Current Chromium source defines `visits.id` as an `INTEGER PRIMARY KEY AUTOINCREMENT`; it also warns that a higher local visit ID need not have a newer visit time because an older synchronized visit can arrive later. Therefore UAM orders progress by native ID and treats visit time only as fallible source data. A bounded native-ID overlap detects recent replacement, mutation, or reuse; it is not a time lookback and does not replace source-generation detection.

**RECOMMENDATION — commit each page as one atomic local transaction.** The Coordinator inserts all minimized events and deterministic zero-effect progress facts for the page, records the page outcome, and advances the source checkpoint in the same SQLite transaction. It acknowledges the User Host only after commit. Any failure before that commit leaves progress unchanged. G5 must still prove the crash invariant with failpoints; this result specifies the boundary but does not claim that G5 has passed.

## 1.2 Why this is the simplest safe choice

**FACT.** The accepted predecessor decision already selects “short read-only attempt, SQLite Online Backup fallback, then defer” and rejects copying a live main/WAL/SHM file set. The accepted process model also requires user-owned sources to be read in the user session, not by the Coordinator.

**FACT.** SQLite documents that WAL readers and writers can coexist, but readers may receive `SQLITE_BUSY`; a read-only WAL database is safe only under specific conditions; and a connection closing as the last connection can otherwise checkpoint or remove WAL state unless checkpoint-on-close is disabled. SQLite also documents that Online Backup takes short shared source locks, automatically restarts after source changes, and reports `BUSY`, `LOCKED`, or fatal results.

**FACT.** Current Chromium source uses local autoincrement visit IDs but explicitly states that ID order is not source-time order. This makes a timestamp-only cursor incorrect for late synchronization and equal timestamps.

**INFERENCE.** A direct snapshot minimizes copying and memory use; Online Backup handles live-write cases more safely than a raw file copy; defer contains every case where neither method can establish a coherent read without source writes. Adding a browser extension, DevTools channel, VSS, a custom page parser, or a general-purpose forensic library would create a larger privilege, privacy, update, and support surface without evidence that G2/G3 needs it.

## 1.3 Confidence and residual risk

| Major conclusion | Confidence | Basis | Main residual risk |
|---|---|---|---|
| Direct read-only attempt, Online Backup fallback, then defer | **High** | accepted predecessor plus official SQLite behavior | exact enterprise Edge/EDR/filesystem behavior is still a lab claim |
| User Host-only bounded discovery | **High** | accepted process boundary and documented Edge root/policy behavior | custom launch roots and virtualized profiles vary by estate |
| UAM source plus generation identity | **Medium-High** | Windows file identity and cursor witnesses provide strong continuity | Windows file IDs can eventually be reused; no read-only method can prove lineage forever |
| Native visit ID cursor rather than time | **High for current Chromium capability; Medium across future Edge versions** | current Chromium schema/source and sync semantics | browser internals are not a stable public API |
| Bounded ID overlap and deterministic dedupe | **High** | directly handles retries, equal times, recent changes, and at-least-once delivery | mutations older than the overlap are not detected without a full scan |
| Complete recall for controlled fixtures | **High as a testable requirement; not yet proved** | deterministic oracle and exact fixture plan | production sync/deletion races may exceed fixture coverage |
| Zero source writes | **High as a gate; not yet proved** | read-only flags, low-integrity containment, no-checkpoint setting, and filesystem tracing | provider/native-library or enterprise policy differences can violate assumptions |

**Residual risk.** Edge history remains an internal browser database, not a promised collection API. File identity can be recycled. A shared profile used concurrently in two sessions cannot reveal which session created a visit. A browser or sync engine can delete a row before UAM observes it. A future Edge release can change schema or locking. A same-user adversary may race path or database replacement. Native SQLite defects can affect read behavior. Research can contain these risks through capability detection, one-source leases, handle identity checks, overlap witnesses, current/previous fixtures, kill switches, and fail-closed errors; it cannot eliminate them through prose.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result specifies:

- Edge channel/root/profile discovery inside an eligible User Host session;
- default and mandatory-policy roots, bounded multi-profile handling, custom/unsupported roots, profile removal/recreation, and same-SID concurrent sessions;
- `source_id`, `source_generation_id`, endpoint-local locator digests, file identity, source leases, and realm separation;
- direct read-only SQLite acquisition, Online Backup fallback, cancellation, memory and optional disk scratch, cleanup, and proof of zero source writes;
- capability-based schema detection without treating browser internals as a public contract;
- fixture generation from synthetic localhost visits and adversarial SQLite databases;
- native visit-ID progress, bounded overlap, late sync, same timestamps, deletion gaps, ID regression/reuse, database replacement, source time, DST, clock changes, sleep, deterministic dedupe, and atomic checkpoint contracts;
- the smallest G2/G3 Windows VM prototypes, browser-impact measurements, fitness functions, runbooks, and stop/go gates.

## 2.2 Non-goals

This result does **not**:

- approve supported Edge channels, versions, release rings, profile technologies, or VDI products;
- approve a first-run lookback, exact event fields, exact identity level, or source-time precision;
- approve production URLs, domains, activity, people, roles, retention, or employee monitoring;
- attribute a database visit to the interactive session that generated it when sessions share the same profile database;
- recover deleted history, parse cache/cookies/downloads/titles, inspect private/incognito activity, or act as forensic evidence;
- redesign G1 process/IPC, G4 privacy transformation, G5 outbox/checkpoint crash proof, server ingestion, application matching, or release signing;
- select a production SQLite wrapper/native package, scratch encryption product, support contract, budget, SLO, or production support policy;
- claim that a synthetic VM proves behavior across the managed estate or 6,000 endpoints.

## 2.3 Allowlisted supplied inputs

All six allowlisted project inputs were available. The predecessor was supplied under the local attachment filename `batch-01-review-result(3).md`; its document declares the allowlisted result path `results/batch-01-foundations/batch-01-review-result.md`. No non-allowlisted Project file was used.

| Ref | Allowlisted input | Reviewed SHA-256 | Use in this result |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | non-negotiable endpoint, minimization, durability, realm, and release invariants |
| I02 | `01-existing-system-evidence-summary.md` | `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | legacy browser/profile/session dependence and evidence limitations |
| I03 | `03-sanitized-windows-lab-capability.md` | `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | existence of a placeholder-only Windows lab lane; no runtime claim |
| I04 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | G2/G3 order and accepted acquisition choice |
| I05 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, human authority, privacy boundary, and change handling |
| I06 | `batch-01-review-result.md` (uploaded local name `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted predecessor contracts, UUIDv7, RunIntent/permit, strict errors, repository gates, and no-live-Edge prohibition before G2 |

## 2.4 Accepted predecessor decisions carried forward

The following are **FACT** from I01, I04, and I06 and are not reopened:

1. the Coordinator is machine-scoped and does not crawl user profiles or create user tokens;
2. the User Host reads user-owned sources in the exact interactive session;
3. a short-lived fixed Task Host is the risky collection boundary;
4. C#/.NET is the default family, while exact versions are execution-time lifecycle inputs;
5. minimization occurs before Coordinator IPC, durable endpoint storage, logs, diagnostics, or transport;
6. the product privacy ceiling authorizes the source and transformation; tenant policy only narrows it;
7. endpoint SQLite has one writer and atomically stores minimized events with progress;
8. the source cursor never advances ahead of durable minimized events or approved zero-effect progress facts;
9. delivery is at least once, so stable identities and uniqueness must make the business effect idempotent;
10. local assignment is a Coordinator `RunIntent` plus an independently checked User Host `CollectionPermit`;
11. source acquisition is direct short read-only attempt, Online Backup fallback, then defer; a raw live-file copy is forbidden;
12. G2 must pass before G3 is accepted, and both must pass before the G4 privacy slice uses a live source.

No accepted-baseline change proposal is raised.

## 2.5 Assumptions

- **ASSUMPTION.** The first implementation reads only the `History` database used by an approved Microsoft Edge desktop profile on Windows.
- **ASSUMPTION.** The User Host can read its own effective Edge policy and local profile root without elevation.
- **ASSUMPTION.** The G1 Task Host can run at low integrity or an equivalent write-denying profile while retaining read access to the relevant browser files. This must be proved, not assumed in production.
- **ASSUMPTION.** The selected native SQLite build exposes the C APIs and file-control operations required by this design.
- **ASSUMPTION.** Product policy can represent a finite allowlist of Edge channel/root kinds and can disable acquisition globally, by channel, capability, or source.
- **ASSUMPTION.** G0 fictional identity, contract, oracle, and canary foundations required by I06 are available before G2 code consumes live sources.

## 2.6 Unknowns

- **UNKNOWN.** Supported Windows versions, Edge channels/versions, Extended Stable policy, Beta inclusion, WebView2, guest profiles, supervised profiles, temporary profiles, roaming profiles, FSLogix, Citrix, RDS, App-V, redirected folders, and network roots.
- **UNKNOWN.** The exact Edge policy precedence and enterprise configuration combinations present in the estate.
- **UNKNOWN.** Whether low integrity, EDR, controlled-folder access, application control, or profile virtualization blocks safe read-only SQLite access.
- **UNKNOWN.** Representative `History` database sizes, WAL sizes, visit rates, profile counts, lock distributions, sync delays, long-offline patterns, and browser-impact budgets.
- **UNKNOWN.** Approved first-run lookback, output fields, time precision, hard-deny URL classes, identity level, and retention.
- **UNKNOWN.** Exact overlap count, page count, timeouts, memory cap, backup step size, retry values, source-absence grace, and tombstone retention.
- **UNKNOWN.** Production native SQLite package/build, compilation options, support arrangement, and whether a managed wrapper exposes every required hardening API.
- **UNKNOWN.** Whether disk scratch is ever necessary and, if so, its encryption/key-wrapping and enterprise backup/indexing treatment.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Component responsibilities

| Component | MUST do | MUST NOT do |
|---|---|---|
| Product privacy ceiling | enumerate allowed Edge source types, channel/root kinds, required fields, transformations, outputs, diagnostics, capabilities, and kill switches | authorize arbitrary paths, SQL, scripts, extensions, DevTools commands, or tenant-defined collectors |
| Tenant policy | select or disable release-owned channel/root/capability IDs and narrow rate/lookback/fields | add a custom filesystem path or broaden the product ceiling |
| Coordinator | issue a bounded `RunIntent`; validate authenticated User Host/session/permit binding; derive realm/installation; HMAC transient file identities into endpoint-local locator digests; serialize acquisition per source generation; atomically commit minimized events/progress | enumerate user directories; open Edge files; accept raw URL/path/profile name; trust payload realm/SID/path as authority; run arbitrary SQL |
| User Host | resolve only authorized roots in its session; discover bounded direct-child profiles; validate path/file identities; issue a one-use `CollectionPermit`; launch the fixed Edge Task Host; validate already-minimized Task Host output before Coordinator IPC | scan the user home; accept raw URLs/titles from Task Host; send raw paths, Local State content, profile display names, accounts, raw URLs, or titles to Coordinator; infer activity session from a shared profile |
| Edge Task Host | execute one compiled Edge-history capability; open source read-only; perform capability detection, direct page read or Online Backup; transform each raw URL/time row under the fixed privacy contract; return only bounded minimized rows to the User Host over inherited handles | use network; write source; stop/restart Edge; load extensions; execute tenant SQL; inspect unrelated browser files; emit or persist raw source data |
| Source registry in endpoint store | persist opaque UAM source/generation IDs, keyed locator digests, capability fingerprints, status, leases, checkpoints, and minimized overlap witnesses | persist raw filesystem paths, raw Windows file IDs, profile names, Edge account identifiers, raw Local State, raw URL hashes, or SID as source identity |
| G0 fixture generator/oracle | create synthetic roots/profiles, browser-driven localhost visits, adversarial databases, expected source/generation/cursor/event outcomes, and exact canaries | derive truth from production acquisition code or use real browsing data |
| Windows lab harness | automate Edge/driver setup, locks, replacements, clocks, sessions, filesystem tracing, browser-impact capture, evidence normalization, and cleanup | include connection details, credentials, real users, internal addresses, production activity, or raw browser records in shareable evidence |

## 3.2 Trust-boundary flow

```text
Release-owned privacy ceiling + narrower tenant policy
                |
                v
Coordinator (session 0, no profile access)
  creates RunIntent + source lease candidate
                |
       authenticated G1 IPC
                v
User Host in exact interactive session
  - resolves allowed root kinds
  - discovers bounded profile candidates
  - opens directory/file identity handles
  - checks effective policy/session
  - issues one-use CollectionPermit
                |
       inherited private Task Host channel
                v
Fixed Edge Task Host
  - low-integrity/write-denying profile (where proved)
  - no network, child process, or arbitrary path
  - direct SQLite read-only snapshot
        OR Online Backup to private memory
  - exact capability adapter/query
  - URL -> approved site/domain representation
  - approved time coarsening and hard denies
  - raw value zeroization before serialization
                |
       minimized result only
                v
User Host
  - revalidates permit, schema, bounds, and forbidden-field absence
                |
       minimized result only
                v
Coordinator
  - binds realm/installation from authenticated state
  - validates source/generation/permit/page
  - atomic minimized event + zero-effect progress + cursor commit
  - ACK only after commit
```

A profile path, relative directory name, `Local State` value, Windows SID, file ID, and raw URL are never server data. File identity is a narrowly authorized local acquisition input: the User Host sends it only in a bounded authenticated source-binding message, the Coordinator immediately computes an installation-keyed digest, and neither the raw identity nor the source path is logged or durably stored.

## 3.3 Supported root discovery

### 3.3.1 Root kinds

**FACT.** Microsoft documents default per-user data directories for Edge Stable, Beta, Dev, and Canary, and documents a mandatory `UserDataDir` policy that overrides command-line `--user-data-dir`. Microsoft also states that network paths are unsupported and may cause hangs, crashes, or corruption. User-data directory variables such as `${client_name}` and `${session_name}` can intentionally distinguish concurrent remote sessions.

**RECOMMENDATION — initial root-kind policy:**

| Root kind | Initial technical state | Reason |
|---|---|---|
| Edge Stable default local root | implemented but disabled until the human support decision | first slice; documented default |
| Edge Extended Stable | same Stable installation/root semantics, selected by version policy rather than a separate root | Microsoft describes Extended Stable as an update option for Stable, not a separate app |
| mandatory Edge `UserDataDir` policy root | implemented only when absolute, local, resolved in the current session, and product-authorized | managed override is the only supported custom-root source in the initial design |
| Edge Beta default root | compiled capability available but disabled pending human version/channel approval | useful pre-release fixture lane; not automatically a production source |
| Edge Dev and Canary roots | disabled/unsupported | Microsoft does not position them as supported enterprise production channels |
| command-line-only `--user-data-dir` | unsupported | discovering it safely would require process command-line inspection or broad scanning; policy may be absent and user override is unconstrained |
| UNC/network/redirected root | unsupported and fail closed | Microsoft warns network paths are unsupported; locking and source identity differ materially |
| arbitrary tenant-supplied path | structurally impossible | tenant policy may only narrow release-owned roots |
| WebView2 user-data folder | out of scope | different application ownership and profile semantics |

**HUMAN DECISION.** The supported Edge channel/version/profile-technology matrix remains unapproved. The conservative temporary default is **all live Edge acquisition disabled**, with Stable and the current human-selected previous Stable available only in the synthetic lab lane.

### 3.3.2 Root resolution algorithm

The User Host MUST perform this bounded algorithm:

1. receive a `RunIntent` containing only a release-owned `rootKindId`, not a path;
2. verify the active product ceiling and tenant policy authorize the root kind and current session;
3. for a default root, derive the documented path from the current user's known local application-data folder; never enumerate parent folders;
4. for `UserDataDir`, read only the exact effective Edge policy value from approved machine/user policy locations, apply the documented Edge variable expansion in the current session, and reject unknown variables;
5. require an absolute local filesystem path; reject UNC, device namespace, volume root, alternate data stream, relative path, over-length input, embedded NUL, or unsupported filesystem;
6. open the root as a directory handle without following a terminal reparse point, obtain `FILE_ID_INFO`, volume information, final normalized path, and reparse attributes;
7. reject a root whose final path escapes the expected local volume, whose identity cannot be obtained, or whose root/ancestor behavior is not in the approved lab matrix;
8. keep the raw root path and identity only in User Host memory for the run;
9. enumerate only bounded direct child directories and only the exact `Local State` file at the root; never recurse.

`Local State` is an untrusted discovery hint, not authority. The parser SHOULD stream only the bounded keys needed from the current Chromium `profile.info_cache` shape and MUST discard values that can include profile display/account metadata. Corrupt, absent, or changed `Local State` does not trigger a broad crawl; UAM falls back to bounded direct-child inspection.

### 3.3.3 Profile candidate algorithm

A direct child becomes a profile candidate only when all conditions pass:

- direct child count, name length, path length, and total enumeration time remain under hard safety ceilings;
- the child is a directory, not a reparse point, and has stable `FILE_ID_INFO` before and after inspection;
- the child contains a regular `History` file at the exact expected relative name;
- the `History` file is not a reparse point, device, directory, alternate stream, or network file;
- the SQLite source can expose a supported capability through the fixed read-only adapter;
- the child does not resolve to an already-bound profile source under another candidate path in the same run.

Unknown extra files and unknown `Local State` profile fields are ignored. Unknown children are not errors unless a safety bound is exceeded.

## 3.4 Multi-profile and same-SID concurrent-session rules

1. Every qualifying profile directory is a separate source lineage.
2. Profile display name, browser account, folder basename, SID, and session ID MUST NOT be a primary source key.
3. A root/profile pair that resolves to the same installation-keyed directory locator digest maps to one `source_id`, even if discovered by two sessions or two syntactic paths.
4. The Coordinator grants at most one active acquisition lease for a `(realm, installation, source_id, generation_id)` tuple.
5. A losing concurrent User Host receives `lease_conflict` and defers; it does not read or advance.
6. If `${session_name}` or `${client_name}` produces different directory identities, each is a different source.
7. If two sessions share the same profile database, UAM may record the acquisition session as local operational provenance, but the business event MUST NOT claim that the visit originated in that session.
8. If approved product semantics require activity-session attribution, shared-root concurrent profiles are unsupported and collection MUST be disabled for that source.
9. Cross-realm equality of a local directory or file identity is irrelevant. Realm and installation are derived from authenticated Coordinator state and included in all uniqueness constraints.

## 3.5 Profile removal, recreation, and unsupported environments

- A profile absent for one discovery run becomes `TemporarilyAbsent`; no source event or checkpoint is deleted.
- After a configurable absence grace, it becomes `Removed`. The exact grace and retention are provisional and do not authorize deletion.
- If the same path returns with a different profile-directory identity, UAM creates a new `source_id` and preserves predecessor lineage.
- If the profile directory remains but `History` has a different file identity, UAM keeps `source_id` and creates a new `source_generation_id`.
- If identity is unavailable, root is network-backed, reparse behavior is unsupported, schema is incompatible, or safe WAL read cannot be established, the source state is `Unsupported` or `Deferred`; progress does not move.
- UAM never silently treats an unsupported source as empty or completed.

## 3.6 Source identity design

### 3.6.1 Identity definitions

- `source_id`: UAM-owned UUIDv7 for one Edge profile-directory lineage in one realm/installation.
- `source_generation_id`: UAM-owned UUIDv7 for one coherent `History` database native-ID lineage within that source.
- `source_sequence`: monotonically increasing integer per source; generation rollback is impossible.
- `root_locator_digest`: `HMAC-SHA-256(K_install_locator, canonical(rootKindId, volumeSerial, fileId128))`.
- `profile_locator_digest`: `HMAC-SHA-256(K_install_locator, canonical(root_locator_digest, profileVolumeSerial, profileFileId128, profileCreationTimeClass))`.
- `history_locator_digest`: `HMAC-SHA-256(K_install_locator, canonical(profile_locator_digest, historyVolumeSerial, historyFileId128))`.
- `capability_fingerprint`: SHA-256 of the normalized required schema metadata, fixed query-plan class, native SQLite source ID, acquisition adapter major, and observed browser version class. It excludes raw profile/path/URL values.

`K_install_locator` is a purpose-separated endpoint installation key held by the Coordinator. Raw file IDs are accepted only over authenticated local IPC, converted immediately, zeroized, and never uploaded. A digest from one installation cannot be correlated with another.

### 3.6.2 Why file identity is necessary but insufficient

**FACT.** Windows `FILE_ID_INFO` provides a volume serial number and 128-bit file identifier. **INFERENCE.** This is stronger than a path because paths can be renamed or aliased. It is still not eternal identity: files can be deleted and identifiers can eventually be reused.

Therefore UAM also maintains bounded generation witnesses:

- last accepted `history_locator_digest`;
- last capability fingerprint;
- highest committed native visit ID;
- observed `sqlite_sequence` high-water when present;
- last bounded overlap map of `native_visit_id -> minimized_record_witness_digest`;
- generation predecessor, start reason, and close reason;
- last successful main-handle identity and `SQLITE_FCNTL_HAS_MOVED` result.

A profile-path hash alone is forbidden: it is rename-sensitive, can expose user information, and cannot distinguish recreation. A file ID alone is not enough to claim perpetual identity. The remaining reuse ambiguity is recorded as residual risk.

## 3.7 Source-generation decision rules

Create a new generation, without advancing the old one, when any of these occurs:

1. the `History` file identity changes while profile identity remains;
2. the SQLite native handle identity does not equal the pre-open candidate identity;
3. `SQLITE_FCNTL_HAS_MOVED` reports moved/deleted during a read;
4. required capability changes incompatibly;
5. observed maximum native visit ID or `sqlite_sequence` high-water regresses below the committed checkpoint;
6. an overlapped native ID produces a different authorized minimized-record witness;
7. the same native visit ID appears twice with incompatible required columns;
8. a restored/replaced database cannot prove continuity through the existing overlap and high-water witnesses.

A changed Edge patch version alone does not create a generation. A changed query adapter major may create a new extraction lineage or replay plan, but it does not pretend the browser database changed; the ADR must define whether this is a new source generation or a new event-contract lineage.

## 3.8 Feature flags and kill switches

All controls are release-owned and can only narrow the product ceiling:

| Control | Default before G2/G3 pass | Scope | Behavior |
|---|---|---|---|
| `edge_history.enabled` | `false` | global/release/realm | disables all new runs |
| `edge_history.channel.stable` | `false` | channel | permits Stable only after human support decision |
| `edge_history.channel.beta` | `false` | channel | lab/canary only unless separately approved |
| `edge_history.root.default` | `false` | root kind | enables documented default root |
| `edge_history.root.managedUserDataDir` | `false` | root kind | enables validated mandatory-policy root |
| `edge_history.acquisition.direct` | `true` in synthetic lab | capability | allows short read-only snapshot |
| `edge_history.acquisition.onlineBackup` | `true` in synthetic lab | capability | allows fallback after eligible direct failure |
| `edge_history.acquisition.diskScratch` | `false` | capability | remains off until separate privacy/security ADR |
| `edge_history.capability.<fingerprint>` | allowlist empty | schema capability | only explicitly tested capabilities execute |
| `edge_history.source.<opaqueId>.disabled` | false | local source | incident/support kill switch; no path in control plane |
| `edge_history.emergencyStop` | `true` before activation | global | immediate stop; outstanding results are discarded and do not advance |

A feature flag cannot add a path, SQL statement, source field, output field, or transformation.

## 3.9 Configuration ownership, realm isolation, skills, and operating cost

**Configuration ownership.** The release/Product Privacy authority owns the compiled channel, root-kind, schema-capability, SQL, transformation, diagnostic, and hard safety-ceiling registries. Tenant policy may reference those release-owned identifiers only to disable or narrow them. The Coordinator owns authenticated realm/installation binding, source leases, local locator-key use, checkpoints, and safety holds. The User Host owns exact-session path resolution and profile discovery. Endpoint Platform/Operations may deploy Edge policy and the UAM release, but deployment configuration cannot itself authorize a new root, field, query, or transform. Every broadened capability requires a new reviewed release/control revision and its named evidence; an administrator cannot edit a local path or SQL escape hatch.

**Realm isolation.** Every source, generation, run, lease, checkpoint, witness, and endpoint-store query is keyed first by the Coordinator-derived realm and installation. Payload realm, SID, session, source, and path claims are non-authoritative. `K_install_locator` is purpose-separated per installation; locator digests are never uploaded or compared across installations/realms. A wrong-realm or wrong-installation value fails before source open or state mutation. Realm-negative vectors and store-query architecture tests are mandatory on every contract/schema change.

**Skills and operating cost.** Safe support requires maintained competence in C#/.NET and `SafeHandle`/P/Invoke review, Windows sessions/filesystems/ACLs and ProcMon/ETW analysis, SQLite C API/WAL/backup behavior, Edge release/schema fixture engineering, privacy-contract testing, and incident/support operations. No single package removes those skills. The recurring cost includes disposable Windows images, exact browser/driver/native archives, candidate-release qualification, fixture and canary maintenance, evidence storage/review, advisory response, and support/on-call drills. Staffing, training, support hours, procurement, and budget are **HUMAN DECISION** matters. Until accountable coverage exists, the affected capability remains disabled and UAM makes no support claim.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Rejection reason | Condition that could change the decision |
|---|---|---|---|
| Broad recursive profile crawl | **Reject** | violates User Host minimization, increases cross-profile/path exposure, and has no bounded completeness contract | none for initial slice; a separately governed source contract would be required |
| Trust only `Local State` | **Reject** | internal untrusted metadata can be absent, corrupt, stale, or changed; may contain profile/account metadata | could remain a hint, never authority |
| Trust only direct-child enumeration | **Reject as sole method** | loses useful profile hints and may waste work; still bounded fallback | acceptable fallback when `Local State` is absent/corrupt |
| Profile folder name or display name as source ID | **Reject** | mutable, non-unique, user-derived, path-sensitive, and privacy-sensitive | none |
| SID plus profile name as source ID | **Reject** | same SID can have multiple sessions/profiles; SID is not browser lineage; realm risk | none |
| Raw path or path hash as durable source identity | **Reject** | renames/recreation break identity; raw path is sensitive; ordinary hash is dictionary-testable | only an installation-keyed locator component, never sole identity |
| Windows file ID as the only source/generation proof | **Reject** | identifiers can be reused and do not prove schema/cursor continuity | remains one witness in the composite design |
| Timestamp cursor | **Reject** | late synchronized visits can have old times; equal times occur; clock/DST/sleep are non-monotonic | none while local visit IDs are available |
| `(timestamp, URL)` dedupe | **Reject** | legitimate separate visits can share both; raw URL is forbidden and mutable | none |
| Chromium sync-originator tuple as cursor | **Reject for first slice** | not needed for local completeness, absent for local visits, internal schema, and creates cross-device semantics | a later approved cross-device dedupe requirement with explicit privacy model |
| Scan by `visit_time` with lookback | **Reject as progress mechanism** | cannot guarantee late sync or same-time order; time precision is a human decision | may be an independently approved first-run filter, never the cursor |
| Direct read-only only | **Reject as complete acquisition strategy** | live WAL/locks may cause safe reads to fail, reducing controlled recall | could be selected for a capability if measurement proves complete recall and lower impact |
| Always use Online Backup | **Reject as default** | copies more pages, uses more memory/time, and may restart repeatedly during writes | could be selected for a measured capability where direct reads have unacceptable lock/failure behavior |
| Raw copy of `History`, `-wal`, and `-shm` | **Reject — baseline conflict** | not an atomic live snapshot and can miss/mix WAL state; already rejected by predecessor | only an explicit accepted-baseline change proposal with new primary evidence, migration impact, and falsifying experiment |
| Open live database with `immutable=1` | **Reject** | SQLite says changes to an immutable database can yield wrong answers or corruption; Edge is live | permitted only on a completed UAM-owned private immutable copy, not the source |
| Use `nolock=1` | **Reject** | SQLite warns it can corrupt if multiple connections exist | none |
| Give Task Host source write permission so SQLite can create SHM | **Reject** | violates zero-source-write invariant and expands impact | evaluate a narrow read-only VFS or defer; never silently weaken the boundary |
| Stop Edge or lock its files | **Reject** | unacceptable user impact and authority; can create loss/corruption risk | only an explicit maintenance workflow outside collection, not endpoint telemetry |
| Volume Shadow Copy Service | **Reject initially** | privileged, broad snapshot scope, operationally heavy, and contrary to simple user-session acquisition | only if approved VDI/filesystem evidence shows no safe user-mode method and a separate privileged-boundary ADR passes |
| Browser extension | **Reject initially** | new browser policy, update, code-in-browser, URL exposure, and user-experience surface | a browser-supported API with materially lower risk and governed deployment could trigger a new ADR |
| DevTools/CDP or WebDriver in production | **Reject** | automation/debug surface, version coupling, policy conflicts, and altered browser behavior | test fixture generation only; production requires a new threat model |
| General-purpose browser-history package as runtime dependency | **Reject** | broad profile crawling, raw URL/title export, different privacy model, and non-.NET/runtime fit | reference/fixture ideas only |
| Forensic parser such as Hindsight as runtime dependency | **Reject** | aims to recover broad/deleted artifacts; threat and minimization model is opposite UAM | differential test reference on synthetic fixtures only, never authority |
| Manual SQLite page/WAL parser | **Reject** | large correctness/security burden and duplicates SQLite's tested concurrency logic | only if official SQLite cannot provide a safe read and a narrowly scoped parser is independently verified—unlikely |
| Disk-backed raw backup by default | **Reject** | creates durable pre-minimization data, key, cleanup, crash-dump, backup, indexing, and incident obligations | separate ADR after memory prototype proves a measured need and encryption/cleanup gates pass |
| Full-history rescan every run | **Reject** | unbounded I/O/browser impact; does not solve source identity; privacy and 6,000-device cost | bounded diagnostic lab mode only, never routine collection |
| Schema-version integer allowlist only | **Reject** | browser database version is internal and does not prove required table/column/query behavior | retain as observation, while capability detection is authoritative |
| Silently skip malformed/corrupt rows and advance | **Reject** | turns unknown data loss into progress and violates the primary gate | only deterministic release-owned zero-effect outcomes may advance atomically |

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Normative contract rules

All G2/G3 messages use the accepted strict contract profile from I06. They MUST be versioned, closed, bounded, locally validated, and bound to the authenticated G1 session and one-use permit. Unknown members, duplicate members, wrong types, invalid UUIDs, over-limit values, unsupported enum values, and wrong state are rejected. Payload claims do not establish realm, installation, user, or session authority.

The following data classes are distinct:

| Data class | Boundary | Durability | Logging rule |
|---|---|---|---|
| raw root/profile path and relative directory key | User Host memory only | never | never |
| raw Windows volume/file identity | bounded User Host -> Coordinator source-binding message | never; immediately HMACed and zeroized | never |
| raw `Local State` content/profile display/account data | User Host parser only | never | never |
| raw URL and exact browser source time | Edge Task Host memory only | never outside Task Host; transformed before output | never |
| native visit ID | Task Host -> User Host -> Coordinator local acquisition envelope | endpoint-local progress/event identity only; omitted from server event unless separately approved | only aggregate/error category, never value |
| minimized site/domain representation | User Host/Coordinator and later event pipeline | only if product ceiling authorizes it | governed event/log rules; never in health metrics |
| source/generation UUIDs | local and event provenance | durable | may be logged only as short opaque correlation tokens, not metric labels |
| keyed locator digests | Coordinator local store | durable endpoint-only | never upload or log |

## 5.2 Profile/source identity schema

The following SQLite schema is normative at the logical level. Physical indexes, exact text/binary encodings, and retention are execution-time decisions. UUID columns are canonical UUIDv7 bytes or canonical lower-case text according to the accepted endpoint-store scalar profile; a deployment MUST use one representation consistently.

```sql
CREATE TABLE edge_profile_source (
    realm_id                 BLOB NOT NULL,
    installation_id          BLOB NOT NULL,
    source_id                BLOB NOT NULL,
    source_kind              TEXT NOT NULL CHECK (source_kind = 'EDGE_HISTORY'),
    channel_id               TEXT NOT NULL,
    root_kind_id             TEXT NOT NULL,
    root_locator_digest      BLOB NOT NULL CHECK (length(root_locator_digest) = 32),
    profile_locator_digest   BLOB NOT NULL CHECK (length(profile_locator_digest) = 32),
    status                    TEXT NOT NULL CHECK (status IN
                              ('DISCOVERED','ACTIVE','TEMPORARILY_ABSENT',
                               'REMOVED','UNSUPPORTED','SAFETY_HOLD')),
    source_sequence          INTEGER NOT NULL CHECK (source_sequence >= 1),
    current_generation_id    BLOB NULL,
    first_seen_utc           INTEGER NOT NULL,
    last_seen_utc            INTEGER NOT NULL,
    row_version              INTEGER NOT NULL CHECK (row_version >= 1),
    PRIMARY KEY (realm_id, installation_id, source_id),
    UNIQUE (realm_id, installation_id, source_kind, profile_locator_digest),
    UNIQUE (realm_id, installation_id, source_id, source_sequence)
) STRICT;

CREATE TABLE edge_source_generation (
    realm_id                    BLOB NOT NULL,
    installation_id             BLOB NOT NULL,
    source_id                   BLOB NOT NULL,
    generation_id               BLOB NOT NULL,
    generation_sequence         INTEGER NOT NULL CHECK (generation_sequence >= 1),
    predecessor_generation_id   BLOB NULL,
    history_locator_digest      BLOB NOT NULL CHECK (length(history_locator_digest) = 32),
    capability_fingerprint      BLOB NOT NULL CHECK (length(capability_fingerprint) = 32),
    acquisition_adapter_major   INTEGER NOT NULL CHECK (acquisition_adapter_major >= 1),
    state                       TEXT NOT NULL CHECK (state IN
                                ('BASELINE_PENDING','ACTIVE','SUSPECT',
                                 'CLOSED','UNSUPPORTED','SAFETY_HOLD')),
    start_reason                TEXT NOT NULL,
    close_reason                TEXT NULL,
    observed_schema_version     INTEGER NULL,
    observed_native_high_water  INTEGER NOT NULL DEFAULT 0 CHECK (observed_native_high_water >= 0),
    created_utc                 INTEGER NOT NULL,
    closed_utc                  INTEGER NULL,
    row_version                 INTEGER NOT NULL CHECK (row_version >= 1),
    PRIMARY KEY (realm_id, installation_id, source_id, generation_id),
    UNIQUE (realm_id, installation_id, source_id, generation_sequence),
    FOREIGN KEY (realm_id, installation_id, source_id)
      REFERENCES edge_profile_source(realm_id, installation_id, source_id)
) STRICT;

CREATE TABLE edge_source_checkpoint (
    realm_id                   BLOB NOT NULL,
    installation_id            BLOB NOT NULL,
    source_id                  BLOB NOT NULL,
    generation_id              BLOB NOT NULL,
    high_visit_id              INTEGER NOT NULL CHECK (high_visit_id >= 0),
    native_sequence_high_water INTEGER NOT NULL CHECK (native_sequence_high_water >= 0),
    overlap_floor_visit_id     INTEGER NOT NULL CHECK (overlap_floor_visit_id >= 0),
    checkpoint_version         INTEGER NOT NULL CHECK (checkpoint_version >= 0),
    last_committed_page_id     BLOB NULL,
    last_committed_run_id      BLOB NULL,
    updated_utc                INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id, generation_id),
    FOREIGN KEY (realm_id, installation_id, source_id, generation_id)
      REFERENCES edge_source_generation(realm_id, installation_id, source_id, generation_id)
) STRICT;

CREATE TABLE edge_overlap_witness (
    realm_id                 BLOB NOT NULL,
    installation_id          BLOB NOT NULL,
    source_id                BLOB NOT NULL,
    generation_id            BLOB NOT NULL,
    native_visit_id          INTEGER NOT NULL CHECK (native_visit_id > 0),
    minimized_record_digest  BLOB NOT NULL CHECK (length(minimized_record_digest) = 32),
    extractor_contract_major INTEGER NOT NULL CHECK (extractor_contract_major >= 1),
    PRIMARY KEY (realm_id, installation_id, source_id, generation_id,
                 native_visit_id, extractor_contract_major)
) STRICT;

CREATE TABLE edge_source_run (
    realm_id               BLOB NOT NULL,
    installation_id        BLOB NOT NULL,
    run_id                 BLOB NOT NULL,
    source_id              BLOB NOT NULL,
    generation_id          BLOB NOT NULL,
    permit_digest          BLOB NOT NULL CHECK (length(permit_digest) = 32),
    acquisition_method     TEXT NULL CHECK (acquisition_method IN ('DIRECT','ONLINE_BACKUP')),
    outcome_category       TEXT NOT NULL,
    checkpoint_before      INTEGER NOT NULL,
    checkpoint_after       INTEGER NOT NULL,
    capability_fingerprint BLOB NULL,
    started_utc            INTEGER NOT NULL,
    completed_utc          INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, run_id),
    CHECK (checkpoint_after >= checkpoint_before)
) STRICT;
```

A production migration MAY split health/run history from current source state. It MUST preserve the uniqueness, realm, generation, and cursor invariants.

## 5.3 Transient source-binding contract

This message is local-only, one-use, and never durable in raw form. The values below are visibly fictional.

```json
{
  "contract": "uam.edge.source-binding-candidate",
  "version": "1.0.0",
  "runId": "019c1111-1111-7111-8111-111111111111",
  "rootKindId": "edge.stable.default",
  "channelId": "edge.stable",
  "rootFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000bb"
  },
  "profileFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000cc",
    "creationTimeClass": "2026-07-01T00:00:00Z"
  },
  "historyFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000dd"
  },
  "observedBrowserVersion": "150.0.4078.105"
}
```

Normative rules:

- no path, folder name, profile name, account, SID, URL, title, or Local State value appears;
- file identities MUST come from open handles, not parsed filenames;
- the Coordinator MUST bind the message to the authenticated User Host session and `runId`;
- the Coordinator MUST calculate locator digests, compare/create source state, and clear raw identity buffers before returning;
- the message MUST NOT be logged, traced, crash-dumped, uploaded, or retained in an error object;
- a field identity unavailable/invalid outcome is `file_identity_unavailable` and cannot create or merge a source.

## 5.4 RunIntent and acquisition request

```json
{
  "contract": "uam.edge.acquire-page-request",
  "version": "1.0.0",
  "runId": "019c2222-2222-7222-8222-222222222222",
  "sourceId": "019c3333-3333-7333-8333-333333333333",
  "generationId": "019c4444-4444-7444-8444-444444444444",
  "expectedCheckpointVersion": 12,
  "committedHighVisitId": 4200,
  "overlapCount": 128,
  "maxRows": 512,
  "maxUncompressedBytes": 262144,
  "directReadBudgetMs": 100,
  "backupBudgetMs": 2000,
  "policyDigest": "sha-256:fictional-policy-digest",
  "ceilingDigest": "sha-256:fictional-ceiling-digest",
  "capabilityAllowlistDigest": "sha-256:fictional-capability-list",
  "permitNonce": "fictional-one-use-nonce"
}
```

Every numeric value shown is an **ESTIMATE**, not a production limit. The request MUST NOT include a raw path or SQL text. The User Host resolves the source from its current bounded discovery result and independently verifies policy, source binding, session, and generation before issuing the Task Host permit.

## 5.5 CollectionPermit additions for Edge history

The accepted G1 `CollectionPermit` MUST bind at least:

- realm/installation binding digests from authenticated local state;
- exact User Host session/logon tuple;
- `runId`, `source_id`, `generation_id`, expected checkpoint version, and one-use nonce;
- fixed capability ID `edge.history.site-domain.v1`;
- authorized root kind/channel/capability fingerprint set;
- maximum rows, bytes, duration, memory, backup pages/step, retry count, and overlap;
- approved URL transformation ID, source-time precision ID, output schema ID, and hard-deny registry revision;
- product ceiling, tenant policy, emergency overlay, and application snapshot digests as applicable;
- exact Task Host release/executable profile;
- expiry and cancellation handle.

The permit MUST NOT contain a tenant SQL expression, arbitrary source path, regex, script, URL allowlist, destination, or plugin/assembly name.

## 5.6 Minimized page result

The Task Host performs URL parsing and minimization before emitting a row. The User Host independently validates the result and strips any field not authorized by the effective policy.

```json
{
  "contract": "uam.edge.minimized-page",
  "version": "1.0.0",
  "runId": "019c2222-2222-7222-8222-222222222222",
  "sourceId": "019c3333-3333-7333-8333-333333333333",
  "generationId": "019c4444-4444-7444-8444-444444444444",
  "checkpointVersionObserved": 12,
  "acquisitionMethod": "DIRECT",
  "capabilityFingerprint": "sha-256:fictional-capability",
  "historyLocatorDigest": "hmac-sha-256:fictional-local-only-value",
  "snapshotNativeHighWater": 4388,
  "rows": [
    {
      "nativeVisitId": 4201,
      "outcome": "EMIT",
      "siteKey": "fictional-site-key.example",
      "sourceTimeBucket": "2026-07-31T10:00:00Z",
      "sourceTimeQuality": "VALID",
      "minimizedRecordDigest": "sha-256:fictional-row-digest"
    },
    {
      "nativeVisitId": 4202,
      "outcome": "FILTERED_SCHEME",
      "minimizedRecordDigest": "sha-256:fictional-zero-effect-digest"
    }
  ],
  "pageAdvanceTo": 4388,
  "pageCompleteThroughHighWater": true,
  "sourceHandleUnmoved": true
}
```

The concrete `siteKey`, time bucket, and quality fields are **HUMAN DECISION** inputs and are illustrative. Normative result rules are:

1. rows are strictly increasing by `nativeVisitId` and contain no duplicate ID;
2. every ID is within the requested overlap/snapshot range;
3. each row is either an authorized minimized event or an authorized deterministic zero-effect outcome;
4. `pageAdvanceTo` is no greater than `snapshotNativeHighWater`;
5. if the SQL row limit was reached, `pageAdvanceTo` is the last completely processed row; otherwise it may equal the snapshot high-water, thereby covering deleted ID gaps;
6. raw URL, path, title, referrer, transition, sync originator, profile name, exact file identity, exact policy path, and SQL text are forbidden;
7. `historyLocatorDigest` is endpoint-local and MUST be removed before an upload event is built;
8. any invalid row invalidates the whole page; no partial page commit is permitted.

## 5.7 Deterministic dedupe input

The local natural identity is:

```text
LocalVisitIdentity = canonical(
    realm-bound installation_id,
    source_id,
    source_generation_id,
    native_visit_id,
    extractor_contract_major
)

dedupe_key = SHA-256(LocalVisitIdentity)
```

The minimized payload digest is separate:

```text
payload_digest = SHA-256(canonical(minimized event payload))
```

Rules:

- same `dedupe_key` plus same `payload_digest` is a retry/duplicate and produces one effect;
- same `dedupe_key` plus different `payload_digest` is `identity_conflict`, quarantines the page, and does not advance;
- `event_id` is a UUIDv7 minted once during the atomic endpoint commit and reused on upload retry;
- native visit ID and locator digests need not leave the endpoint; the server receives the stable `event_id` and/or `dedupe_key` according to the later event contract;
- source time, URL text, profile name, session ID, and acquisition time are not part of native record identity.

## 5.8 Error taxonomy

Errors are stable low-cardinality categories. They MUST not interpolate paths, URLs, profile names, SIDs, native IDs, SQL values, or SQLite error strings that can contain filenames.

| Category | Retry class | Cursor effect | Typical routing |
|---|---|---|---|
| `root_default_not_found` | slow retry | none | source absent |
| `root_policy_invalid` | no retry until config change | none | unsupported/safety hold |
| `root_network_unsupported` | no retry | none | unsupported environment |
| `root_reparse_unsupported` | no retry | none | unsupported/safety hold |
| `profile_limit_exceeded` | no automatic retry | none | kill source capability; investigate |
| `local_state_invalid` | continue bounded fallback | none by itself | direct-child discovery |
| `history_missing` | slow retry | none | temporarily absent |
| `file_identity_unavailable` | no retry until environment change | none | unsupported |
| `source_identity_changed` | immediate generation evaluation | old generation unchanged | new generation candidate |
| `schema_unsupported` | no retry until browser/adapter change | none | unsupported capability |
| `sqlite_busy` | eligible for backup/bounded later retry | none unless backup succeeds | fallback/defer |
| `sqlite_locked` | eligible for backup/bounded later retry | none unless backup succeeds | fallback/defer |
| `sqlite_readonly_prerequisite` | bounded backup attempt only if proved useful | none | fallback/defer |
| `sqlite_corrupt` / `sqlite_notadb` | no automatic fallback to extraction | none | safety hold/support |
| `sqlite_io` | bounded later retry | none | defer/support |
| `backup_restart_limit` | later retry | none | defer |
| `backup_size_limit` | no retry until limit/design change | none | defer/unsupported |
| `backup_finish_failed` | later retry | none | defer |
| `cancelled` / `permit_expired` | policy-driven retry | none | cleanup then exit |
| `lease_conflict` | bounded jittered retry | none | another session owns source |
| `generation_regressed` | no old-generation retry | none | new generation review |
| `identity_conflict` | no automatic retry | none | source safety hold |
| `row_invalid` | no partial skip | none | capability/support investigation |
| `minimization_rejected` | no partial skip | none | policy/schema incident |
| `commit_conflict` | reload checkpoint and retry same page | none until commit | Coordinator one-writer conflict |
| `commit_failed` | same page retry | none | storage health |
| `cleanup_failed` | no new runs for source/capability | none | incident and scavenger |
| `source_write_detected` | never retry automatically | none; revoke build/ring | security/privacy incident |
| `cross_profile_mix` / `cross_session_mix` | never retry automatically | none; global kill switch | security/privacy incident |

## 5.9 Privacy-safe observability and cardinality

Allowed metrics are counters/histograms with a fixed dimension set such as:

```text
build_ring
edge_channel_class              # stable/beta; not exact path/profile
acquisition_method              # direct/online_backup/none
capability_family               # bounded release ID, not raw fingerprint
outcome_category                # fixed taxonomy above
schema_adapter_major
```

Forbidden labels include realm, tenant, installation, source, generation, user, SID, session, profile, path, domain, URL, native ID, Edge account, policy digest, or exact browser version if it creates unbounded series. Exact browser/native-library versions belong in bounded inventory/evidence records, not per-source metrics.

A build-time cardinality fitness test MUST calculate the Cartesian maximum for every metric and fail if it exceeds the approved operations budget. No dynamic string from SQLite, Windows, Edge, or input JSON can become a metric label. Logs contain a run correlation ID and category only; a restricted support bundle may map an opaque local source token to a source after explicit local authorization, without exposing its path.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Discovery state machine

```text
RootKindScheduled
  -> PolicyChecked
       -> Disabled                                  [stop; no progress]
       -> RootResolved
            -> RootRejectedUnsupported              [no progress]
            -> RootIdentityVerified
                 -> LocalStateHintParsed             [optional]
                 -> DirectChildrenEnumerated         [bounded]
                      -> ProfileCandidate
                           -> ProfileIdentityVerified
                                -> HistoryCandidate
                                     -> HistoryIdentityVerified
                                          -> SourceBound
                                               -> GenerationBound
                                                    -> Ready

Any bound/identity/time/child limit breach
  -> DiscoverySafetyHold                             [no progress]
```

`LocalStateHintParsed` never authorizes a source. `Ready` means only that acquisition may be attempted; it does not mean schema or source data is valid.

## 6.2 Source lifecycle

```text
UNSEEN
  -> DISCOVERED
  -> BASELINE_PENDING
       -> ACTIVE
       -> UNSUPPORTED
       -> SAFETY_HOLD

ACTIVE
  -> TEMPORARILY_ABSENT
       -> ACTIVE                         [same directory lineage returns]
       -> REMOVED                        [grace/owner rule]
  -> SUSPECT                             [identity/cursor/schema conflict]
       -> ACTIVE                         [conflict disproved]
       -> GENERATION_CLOSED
            -> BASELINE_PENDING(new generation)
       -> SAFETY_HOLD

REMOVED
  -> DISCOVERED(new source_id)           [new directory identity]
```

A source ID is never reused. Removal never deletes previously collected events or silently erases checkpoint/audit history.

## 6.3 Acquisition state machine

```text
Scheduled
  -> SourceLeaseRequested
       -> LeaseConflict -> DeferredNoAdvance
       -> LeaseGranted
            -> PermitChecked
                 -> Disabled/Expired -> CancelledNoAdvance
                 -> DirectOpen
                      -> DirectIdentityVerified
                           -> DirectSnapshotStarted
                                -> DirectPageComplete
                                     -> MinimizedPageReady
                                -> EligibleBusyOrLock
                                     -> DirectClosed
                                     -> BackupOpen
                                          -> BackupStepping
                                               -> Busy/LockedWithinBudget -> BackupStepping
                                               -> RestartWithinBudget -> BackupStepping
                                               -> BackupDone
                                                    -> SourceClosed
                                                    -> PrivateSnapshotQuery
                                                         -> MinimizedPageReady
                                               -> Limit/Fatal/Cancel -> BackupCleanup -> DeferredNoAdvance
                                -> Corrupt/Unsupported/IdentityChanged
                                     -> DirectCleanup -> SafetyHoldOrDeferredNoAdvance

MinimizedPageReady
  -> UserHostRevalidated
       -> CoordinatorCommitPending
            -> Committed
                 -> Acked
            -> Conflict/Failure
                 -> RetrySamePageNoAdvance

Every terminal path
  -> HandlesClosed -> Scratch/MemoryReleased -> LeaseReleased
```

Only `Committed` changes the checkpoint. An ACK lost after commit causes the exact page to be retried; dedupe returns the prior outcome.

## 6.4 Direct read-only SQLite safety rules

### 6.4.1 Open and OS identity

The Task Host MUST:

1. run under the G1 fixed executable profile with no network, no child process, and a low-integrity or equivalently write-denying token proved by G2;
2. open the profile and `History` candidate with Windows handles using least read/synchronize rights and share read/write/delete, reject reparse points, and obtain `FILE_ID_INFO`;
3. open SQLite through a canonical absolute URI with `mode=ro` and flags equivalent to:

```text
SQLITE_OPEN_READONLY
| SQLITE_OPEN_URI
| SQLITE_OPEN_PRIVATECACHE
| SQLITE_OPEN_NOFOLLOW
| SQLITE_OPEN_EXRESCODE
```

4. MUST NOT use `immutable=1`, `nolock=1`, shared cache, a read/write fallback, a writable temp directory on the source volume, or a connection string that can create the database;
5. verify `sqlite3_db_readonly(db, "main") == 1`;
6. use `sqlite3_file_control(..., SQLITE_FCNTL_WIN32_GET_HANDLE, ...)` to obtain the actual Windows main-database handle where the selected native build supports it, then compare its `FILE_ID_INFO` with the candidate identity;
7. call `SQLITE_FCNTL_HAS_MOVED` before extraction and immediately before accepting the page; any moved/deleted result invalidates the page;
8. fail the capability if the wrapper/native build cannot expose equivalent main-handle identity on the supported Windows target. A path-only comparison is insufficient for production acceptance.

### 6.4.2 Connection hardening

Every configuration call MUST check its return code and effective value. Unsupported required controls fail the capability; they are not ignored.

The source connection MUST set or verify:

```text
sqlite3_extended_result_codes(db, 1)
SQLITE_DBCONFIG_DEFENSIVE = 1
SQLITE_DBCONFIG_TRUSTED_SCHEMA = 0
SQLITE_DBCONFIG_ENABLE_LOAD_EXTENSION = 0
SQLITE_DBCONFIG_ENABLE_ATTACH_CREATE = 0
SQLITE_DBCONFIG_ENABLE_ATTACH_WRITE = 0
SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE = 1
SQLITE_DBCONFIG_ENABLE_TRIGGER = 0
SQLITE_DBCONFIG_ENABLE_VIEW = 0
SQLITE_DBCONFIG_DQS_DDL = 0
SQLITE_DBCONFIG_DQS_DML = 0
PRAGMA query_only = ON                  # read back and verify; secondary defense
PRAGMA temp_store = MEMORY              # read back and verify
```

It MUST disable extension loading at both the configuration and API level, register no application-defined SQL functions/collations/virtual tables, and allow no `ATTACH`, `DETACH`, `VACUUM`, journal-mode change, checkpoint, schema write, writable-schema, or arbitrary PRAGMA. A SQLite authorizer SHOULD allow only the fixed `SELECT`, required `READ` operations on `main.visits`, `main.urls`, `main.sqlite_schema`, and `main.sqlite_sequence`, plus the exact introspection operations. Every prepared statement MUST come from a release-owned constant, be parameterized, and satisfy `sqlite3_stmt_readonly(stmt) == 1`.

`sqlite3_limit` MUST set measured hard maxima for SQL length, value length, column count, expression depth, compound selects, variable count, attached databases, and worker threads. Attached database count is zero where supported. Memory-mapped I/O SHOULD be disabled or bounded through the tested file-control/profile. The direct path uses no busy wait loop: it either obtains the short snapshot within its budget or routes an eligible lock result to Online Backup.

### 6.4.3 Snapshot/query boundary

Each direct page is one short SQLite read transaction:

```sql
BEGIN DEFERRED;

-- capability probes and handle identity are already established.
SELECT COALESCE(MAX(id), 0) AS max_id FROM main.visits;
SELECT COALESCE(seq, 0) AS sequence_high_water
  FROM main.sqlite_sequence
 WHERE name = 'visits';

SELECT v.id, v.visit_time, u.url
  FROM main.visits AS v
  JOIN main.urls AS u ON u.id = v.url
 WHERE v.id >= ?1
   AND v.id <= ?2
 ORDER BY v.id
 LIMIT ?3;

COMMIT;
```

`?2` is the snapshot native high-water, defined as the larger of `MAX(visits.id)` and the supported `sqlite_sequence` value. If `sqlite_sequence` is absent for an empty supported table, zero is allowed. The implementation MUST use checked 64-bit integer handling and reject negative, zero where a visit row is expected, non-integer runtime types, overflow, duplicate IDs, or a missing URL row.

Only `id`, `visit_time`, and `url` are selected. Titles, referrers, transitions, duration, sync-originator fields, segment data, and other browser columns are out of scope. The URL is parsed and minimized inside Task Host memory; the raw buffer is released before the result is serialized.

The read transaction ends after one bounded page. It MUST NOT remain open while waiting for Coordinator storage, network, retry backoff, or another Task Host.

### 6.4.4 Query-plan gate

`EXPLAIN QUERY PLAN` for every supported fixture MUST normalize to an abstract plan with:

- an integer-primary-key/range search on `visits`;
- an integer-primary-key lookup on `urls` for each selected visit;
- no full scan of `visits`;
- no temporary B-tree for ordering;
- no automatic index, view expansion, virtual table, trigger, or user-defined function.

Exact plan wording is not a timeless contract. The lab stores both raw plan text as restricted evidence and a normalized plan class. A changed plan class blocks the capability until reviewed.

### 6.4.5 Zero-source-write controls

Read-only mode alone is not proof. The combined control is:

- low-integrity or equivalent OS write denial to medium-integrity profile files, proved effective;
- no source write API in the fixed Task Host dependency graph;
- SQLite `READONLY`, `query_only`, defensive mode, no attach/create/write, no checkpoint on close, no extension loading;
- no fallback that opens read/write if WAL/SHM prerequisites are missing;
- no source-directory scratch/temp file;
- filesystem tracing proving zero successful create/write/set-information/delete/rename/security operations against the root, profile, `History`, `History-wal`, and `History-shm`;
- a positive-control build that intentionally attempts a fictional source write and is both OS-denied and detected by the trace oracle.

A denied write attempt by the production candidate is still a defect to investigate; the pass condition is zero successful source writes and zero unexpected write-intent operations.

## 6.5 Online Backup safety rules

Online Backup is used only for direct outcomes classified as eligible live-lock/snapshot failures. Corruption, wrong identity, unsupported schema, policy failure, or cross-profile suspicion does not become acceptable merely because backup can copy bytes.

The Task Host MUST:

1. open the source with the same read-only flags, hardening, main-handle identity, and write-denying process profile;
2. create a private destination SQLite database in Task Host memory;
3. initialize `sqlite3_backup_init(destination, "main", source, "main")` and fail if it returns null;
4. call `sqlite3_backup_step` with a measured small page count, yielding and checking cancellation between steps;
5. track elapsed time, page count, remaining pages, memory estimate, result codes, and restart indicators; cap all of them;
6. on `SQLITE_BUSY` or `SQLITE_LOCKED`, use only a bounded permit-defined retry/yield policy; no unbounded sleep or spin;
7. on source changes, permit SQLite's documented automatic restart only within a measured restart/time budget;
8. call `sqlite3_backup_finish` on success, cancellation, and every failure path, and treat its final result as authoritative;
9. accept the destination only after `SQLITE_DONE` and a successful finish;
10. close the source before querying the private destination;
11. apply the same schema capability, fixed query, row validation, minimization, and cursor rules to the destination;
12. close/destroy the destination before Task Host exit.

The backup destination is not an event store and has no retention. It is a process-private acquisition snapshot. Process crash dumps containing it MUST be disabled for the Task Host. The project cannot promise byte-level memory erasure from SQLite internals; short process lifetime and no dump are the containment boundary.

**ESTIMATE.** Initial lab hypotheses may use 16–64 pages per `backup_step`, a 2-second wall-clock budget, and a memory ceiling derived from a measured maximum supported profile. These numbers are not accepted until G2 measures browser impact and fixture completeness.

## 6.6 Cancellation and cleanup

- A permit cancellation handle is checked before open, between backup steps, between rows, and before result serialization.
- `sqlite3_progress_handler` interrupts long prepare/step work; `sqlite3_interrupt` is invoked from the cancellation controller while the connection is valid.
- Cancellation rolls back the direct transaction, finalizes every statement, finishes backup, closes destination/source/Windows handles, releases raw buffers, and exits the Task Host.
- A near-complete SQLite operation may finish after interrupt; its result is discarded when cancellation/permit expiry is observed.
- The Coordinator releases the source lease only after the User Host reports child exit and cleanup state or after it kills the job tree and records a timeout.
- Cancellation, timeout, Task Host crash, User Host exit, Coordinator restart, and machine shutdown never advance the checkpoint without a previously committed page.

## 6.7 Scratch ACL, lifecycle, and default

### 6.7.1 Default

**RECOMMENDATION.** G2 uses an in-memory Online Backup destination. Disk scratch is compiled off and `edge_history.acquisition.diskScratch=false`. This is the smallest design compatible with endpoint-side minimization because it avoids durable raw browser data.

### 6.7.2 Future disk-scratch requirements

If measurement proves memory-only backup infeasible, a separate ADR and privacy/security approval are mandatory. A disk scratch implementation MUST:

- live under a product-owned per-user directory, never under the Edge profile or a shared machine temp directory;
- use a create-new unguessable run directory, protected DACL with inheritance disabled, exact interactive logon SID plus the fixed Task Host access as required, and an integrity label compatible with the proved low-integrity token;
- reject all reparse points and validate final handles/volume/file identities;
- encrypt raw snapshot bytes before durable write with an approved per-run key and approved key wrapping; exact choice is **UNKNOWN/HUMAN DECISION**;
- disable indexing, cloud sync, enterprise backup, crash-dump capture, and support-bundle collection where the accountable operations/security owners can enforce those controls;
- maintain a tiny product-owned manifest containing only run ID, creation/expiry, expected file IDs, and state—no path to source, URL, profile, or identity;
- use states `CREATED -> COPYING -> COMPLETE -> CONSUMING -> CLOSED -> DELETED` or `FAILED -> DELETE_PENDING -> DELETED`;
- on startup, scavenge only expired manifest-authenticated directories under the exact product root; never recursively delete an arbitrary path;
- treat deletion as unlink/cleanup, not guaranteed forensic erasure on SSDs; encryption is required to contain remanence;
- enter `cleanup_failed`, disable the capability/source, and raise an incident if cleanup cannot be proved.

## 6.8 Schema capability detection

### 6.8.1 Principle

**FACT.** Chromium's history schema is implementation source, not a Microsoft Edge public storage API. The current Chromium 150 source reviewed for this result creates `visits.id` and `urls.id` as `INTEGER PRIMARY KEY AUTOINCREMENT`, records visit time and URL references, and currently reports database schema version 70. These facts inform an adapter; Edge support still requires generated fixtures and capability tests.

### 6.8.2 Required capability

A database capability is supported only when all of these pass in the same direct snapshot or completed private backup:

1. SQLite opens read-only with the required hardening and main-handle identity;
2. `main.visits` and `main.urls` are ordinary tables, not views or virtual tables;
3. `PRAGMA table_xinfo('visits')` proves required columns `id`, `url`, and `visit_time` exist once;
4. `PRAGMA table_xinfo('urls')` proves required columns `id` and `url` exist once;
5. `visits.id` and `urls.id` have integer-primary-key/rowid semantics; the normalized table SQL includes `AUTOINCREMENT` for the current adapter;
6. `visits.url` and `visits.visit_time` have compatible integer affinity, and `urls.url` has compatible text affinity;
7. the required tables have no unexpected trigger/view dependency in the extraction path;
8. a bounded runtime probe confirms returned `id`, `visit_time`, and URL reference values have the expected SQLite storage classes;
9. the fixed query prepares as read-only and its normalized query plan passes;
10. the maximum ID/sequence values fit signed 64-bit positive bounds;
11. the adapter's current/previous browser fixtures and adversarial corpus pass exactly.

Unknown extra columns, indexes, tables, and metadata fields are tolerated unless they change the fixed query plan or trust boundary. Missing, renamed, duplicate, virtual, incompatible, or ambiguous required objects produce `schema_unsupported`; no best-effort column guessing occurs.

The observed browser DB version is stored as bounded diagnostic evidence but does not authorize the adapter. Capability is identified by the normalized required shape and behavior.

### 6.8.3 Capability fingerprint

```text
capability_fingerprint = SHA-256(canonical(
    adapter_major,
    normalized required table/column metadata,
    autoincrement/rowid facts,
    normalized query-plan class,
    native sqlite source id,
    selected sqlite compile-option digest,
    browser version class,
    required hardening support bitmap
))
```

The fingerprint contains no data values or path. Product release policy allowlists supported fingerprints/families. A new Edge version may retain the same capability; a changed capability requires fixtures, review, and a release update.

## 6.9 Fixture and visit-generator design

### 6.9.1 Two complementary fixture families

1. **Browser-generated fixtures.** A disposable Windows VM launches an exact Edge build with a fresh synthetic user-data directory, sync/sign-in disabled, and external network blocked. A local HTTP server is visited through fictional `site-NNN.localhost` hostnames. Paths, queries, fragments, titles, redirects, ports, Unicode, invalid URL shapes, and canaries are generated to prove minimization. Edge is closed cleanly before the synthetic profile is captured for restricted test use.
2. **Handcrafted SQLite fixtures.** A deterministic generator creates only the minimum `urls`, `visits`, `sqlite_sequence`, and metadata shapes needed for same timestamps, gaps, high IDs, late old-time insertion, corruption, schema changes, ID regression, replacement, lock, WAL, and query-plan adversaries. These are not claimed to be Edge-created; they falsify the UAM adapter.

Browser fixtures prove compatibility with the selected Edge versions. Handcrafted fixtures prove edge cases that browser automation cannot deterministically create without accounts, clock abuse, or source mutation.

### 6.9.2 Canonical fixture package

```text
fixtures/edge-history/<fixture-id>/
  manifest.json
  visit-plan.ndjson
  expected-source-ledger.ndjson
  expected-generation-ledger.ndjson
  expected-cursor-ledger.ndjson
  expected-minimized-events.ndjson
  expected-zero-effects.ndjson
  canaries.ndjson
  schema-capability.json
  browser-build.json                 # browser fixture only
  generation-script.ps1/.cs
  cleanup-plan.json
```

Generated database files are ephemeral build/lab outputs and are not the truth source. The canonical plan includes fixed clock, deterministic UUIDv7 seed, exact synthetic URLs, expected visit insertion order, source times, profile/root identities, replacement points, and expected result categories. The independent G0 oracle computes truth without calling acquisition/minimization/cursor production code.

### 6.9.3 Required fixture scenarios

- empty profile and missing `History`;
- one and many profiles; stale `Local State`; malformed `Local State`; extra children; child limit;
- exact/suffix localhost hosts, ports, credentials in URL, IPv4/IPv6, IDN, Unicode, path/query/fragment canaries, unsupported schemes, malformed text, and oversized URL;
- same source time for many visits;
- non-monotonic source time; future/past values; checked overflow;
- local visits followed by an inserted old-time visit with a higher ID to model late sync;
- ID gaps/deletions before, inside, and after overlap;
- `sqlite_sequence` higher than `MAX(id)`;
- database file replacement, directory recreation, same path/different identity, schema change, ID regression, and an intentionally reused synthetic file-identity witness;
- direct WAL writes while reading, long reader/writer locks, backup restarts, cancellation at every step, and cleanup failure injection;
- required column missing/renamed/wrong type; view/virtual table; unexpected trigger; corrupt header/page; `NOTADB`; huge schema/string/depth values;
- duplicate native identity with same payload and with conflicting payload;
- two sessions discovering one physical source and two session-variable-separated sources;
- wrong realm/installation/source/generation/permit/checkpoint version;
- current and previous human-selected Edge fixtures, plus one deliberately incompatible future-shaped fixture.

## 6.10 Cursor state machine and algorithm

### 6.10.1 Cursor state machine

```text
UNINITIALIZED
  -> BASELINE_PENDING
       -> BASELINE_COMMIT_PENDING
            -> READY(c0)                       [atomic baseline/zero-lookback commit]
            -> BASELINE_FAILED -> UNINITIALIZED [no progress]

READY(c)
  -> SNAPSHOT_BOUND(high_water, generation, capability)
       -> PAGE_PREPARED(advance_to >= c)
            -> COMMIT_PENDING(expected_checkpoint_version)
                 -> COMMITTED(c') -> READY(c') [c' >= c]
                 -> ACK_LOST -> READY(c')       [retry returns committed outcome]
                 -> STALE/CONFLICT/FAIL/CANCEL/CLEANUP_FAILED
                      -> READY(c)                [exact prior checkpoint]

READY(c) or SNAPSHOT_BOUND
  -> GENERATION_DISCONTINUITY
       -> OLD_GENERATION_FROZEN(c)
       -> NEW_GENERATION_BASELINE_PENDING       [new cursor namespace]

SOURCE_REMOVED/UNSUPPORTED/SAFETY_HOLD
  -> CURSOR_FROZEN(c)                           [no implicit completion]
```

Normative rules:

1. only the Coordinator store transaction reaching `COMMITTED` may create or increase a checkpoint; acquisition completion and Task Host/User Host ACKs are not progress authority;
2. a baseline is itself an explicit atomic progress fact, never an in-memory assignment or silent first-run skip;
3. `c'` never decreases within a generation, and a new generation starts a new cursor namespace rather than rewriting the old checkpoint;
4. stale checkpoint compare-and-swap, duplicate-key/different-payload, identity conflict, policy cancellation, source movement, SQLite failure, cleanup failure, or process loss returns to the exact previous committed cursor;
5. a crash after commit but before ACK retries the same page identity and returns the prior committed outcome;
6. no terminal non-success state may prune overlap witnesses, close a generation as successfully completed, or record a higher native high-water as committed progress.

### 6.10.2 Native ordering

**FACT.** Current Chromium source states that `VisitID` is the local `visits.id`, that IDs start at one, and that higher IDs need not represent newer visit times because late sync can insert an older visit later. Redirect visits can also share a timestamp.

Therefore:

- `high_visit_id` is the committed native progress cursor inside one generation;
- source time is never used for ordering, dedupe, authorization, or generation continuity;
- equal timestamps require no tie-breaker beyond native ID;
- late synchronized records with higher local IDs are collected even when their source time is older, subject to the approved field/lookback policy;
- an exact overlap is expressed in native ID count, not elapsed time.

### 6.10.3 Page selection

```text
start_id = max(1, committed_high_visit_id - overlap_count + 1)
```

Within one source snapshot:

1. obtain `snapshot_high_water = max(MAX(visits.id), sqlite_sequence('visits'))`;
2. query IDs from `start_id` through `snapshot_high_water`, ordered by ID, with `maxRows`;
3. for overlap IDs already committed, compare the new minimized-record witness with the stored witness;
4. emit no second event for an exact duplicate;
5. fail the entire page on a conflicting witness;
6. process every new row as an authorized event or deterministic zero-effect outcome;
7. if the row limit is reached, set `pageAdvanceTo` to the last completely processed ID;
8. if fewer than the limit are returned, set `pageAdvanceTo` to `snapshot_high_water`, safely covering deleted/gap IDs in that snapshot;
9. retain only the newest configured overlap witnesses after commit.

The overlap count is an **ESTIMATE** selected by G3 measurements. It detects recent mutation/reuse; it cannot prove that a row older than the overlap was never changed.

### 6.10.4 Deletions

A deleted visit is an absent native ID. UAM does not emit a deletion event, reconstruct deleted content, rewind, or treat a gap as corruption. When a bounded query proves there are no rows through the snapshot high-water, an atomic zero-effect progress fact may advance across the gap. History deletion that occurs before UAM ever observed a row is inherently unobservable and remains residual risk.

### 6.10.5 ID regression, reuse, and database replacement

- changed main file identity: close old generation; create candidate new generation;
- unchanged file identity but sequence/max below checkpoint: `generation_regressed`; no old-generation advance;
- overlapped ID with changed minimized witness: `identity_conflict`; no advance; generation/safety investigation;
- same path with recreated profile directory: new `source_id`;
- restored database with apparently continuous file identity and high-water: overlap/capability witnesses decide only within their bounds; UAM does not claim perfect restore detection;
- source generation UUID prevents an ID reused after replacement from colliding with the old event.

### 6.10.6 Source time, DST, clock, and sleep

Current Chromium stores `base::Time` as microseconds since the Windows epoch. The adapter performs checked conversion to a UTC instant and then applies the approved UAM time precision before output.

- DST does not alter native progress because the stored value is converted as UTC and the cursor is ID-based.
- Manual clock change, NTP correction, VM resume, sleep, and browser sync may make source times old, future, or non-monotonic; UAM records only an approved low-cardinality quality class and does not reorder or rewind.
- Invalid/overflowing time is handled by an explicit release-owned rule: whole-page failure or deterministic zero-effect filtering. It is never silently clamped into a plausible time.
- acquisition time is operational provenance, not a replacement for source time.
- exact allowed precision and future/past tolerance are **HUMAN DECISION/CLI EXPERIMENT** inputs.

### 6.10.7 First run

The cursor design supports three policy options but does not choose one:

| Option | Behavior | Consequence |
|---|---|---|
| activation baseline / zero lookback | atomically set checkpoint to current native high-water without emitting old rows | strongest minimization and lowest load; no pre-activation history |
| bounded source-time lookback | process existing IDs whose approved source-time predicate is in range; persist zero-effect progress for older IDs | more historical data and load; clock/sync semantics must be defined |
| bounded time plus maximum count/bytes | apply the time predicate and a strict newest-N/bytes cap | contains load but may truncate history; truncation must be explicit evidence |

**HUMAN DECISION.** Product/Data Owner with Privacy and Legal decides first-run lookback. Conservative temporary default: live collection disabled; for a purely technical baseline field, use activation baseline/zero lookback rather than silently collecting history.

## 6.11 Atomic endpoint transaction

The Coordinator's one-writer store processes a page as follows:

```text
BEGIN IMMEDIATE;

1. Load source/generation/checkpoint by authenticated realm + installation + IDs.
2. Verify source lease, active generation, permit digest, capability, and
   expected checkpoint_version.
3. Verify page source/history locator binding, row order, bounds, witnesses,
   and pageAdvanceTo.
4. For each EMIT row:
     - derive local dedupe_key;
     - insert minimized event with event_id and payload_digest;
     - on same key/same digest, reuse prior event outcome;
     - on same key/different digest, ROLLBACK as identity_conflict.
5. Insert deterministic zero-effect progress facts for filtered rows/page gaps.
6. Replace bounded overlap witnesses.
7. Insert source run/page outcome.
8. UPDATE checkpoint SET high_visit_id = pageAdvanceTo,
                         native_sequence_high_water = snapshotHighWater,
                         checkpoint_version = checkpoint_version + 1,
                         last_committed_page_id = ...
   WHERE checkpoint_version = expected;
9. Require exactly one checkpoint row updated.
10. COMMIT;
11. ACK committed event IDs/outcome to User Host.
```

Any exception, process crash before commit, storage full, uniqueness conflict, stale checkpoint, invalid permit, cancellation before commit, or failed source-page validation rolls back and sends no success ACK. A crash after commit and before ACK causes an identical retry; uniqueness returns the committed result. G5 must implement failpoints around every numbered boundary.

## 6.12 Compatibility and rollout rules

1. Browser internals are supported by capability fixtures, not by “Chromium-based” marketing or version number alone.
2. The human-approved matrix identifies exact Edge channel and version ranges. Current/previous-version support is a conservative planning target from I06, not yet a production commitment.
3. A candidate Edge release enters the synthetic fixture lane before any endpoint ring. It must pass schema, query plan, direct/backup, minimization, cursor, source-write, and impact tests.
4. Consumer/adapter support deploys before a policy can authorize the new capability fingerprint.
5. Ring rollout uses the same signed release digest and begins with synthetic/canary endpoints. A changed browser capability without an authorized adapter fails closed.
6. Rollback publishes a higher control revision that selects the previous authorized adapter/release semantics; it does not decrement a revision or reinterpret committed event identities.
7. An endpoint that is outside the supported Edge/OS/profile matrix reports one bounded unsupported category and does not repeatedly probe at high frequency.
8. Extended offline/version support and removal grace require measured fleet evidence and a human support decision.

# 7. Security/privacy threat and failure register

## 7.1 Topic threat model

Assets and invariants in this scope are:

- browser availability and integrity;
- separation of profiles, sessions, realms, installations, sources, and generations;
- absence of forbidden source values outside the Task Host/User Host transformation boundary;
- cursor correctness and deterministic one-effect retry behavior;
- integrity of the fixed SQLite adapter/native library;
- bounded CPU, memory, handle, disk, lock, and diagnostic impact;
- complete cleanup of temporary acquisition state.

Threat actors/fault sources considered are:

- a malformed or adversarial browser database controlled by the same user;
- an ordinary same-user process racing paths, files, locks, or IPC;
- simultaneous sessions for one SID;
- Edge itself writing, checkpointing, syncing, deleting, replacing, or migrating its database;
- EDR, profile virtualization, redirected storage, filesystem, power, memory, and clock behavior;
- a mistaken or malicious tenant/control-plane request that attempts a custom path or broader source;
- dependency/supply-chain defects in the managed provider, native SQLite build, browser driver, or test tooling;
- implementation errors that log raw values, advance on failure, or mix source state.

The Task Host is fixed trusted product code with hostile input; it is not a sandbox for arbitrary code and does not claim confidentiality from every same-user process.

## 7.2 Threat/failure register

| ID | Trigger / failure | Detection | Containment | Recovery | Cleanup evidence | Accountable role/function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| R-01 | Coordinator or machine service opens a profile path | architecture/API guard; ProcMon by service PID | build fails; runtime emergency stop | remove forbidden dependency/code; reinstall same approved digest | clean file/registry trace | Endpoint Architecture + Windows Security | architecture mutation and G2 filesystem trace | indirect OS/library access must also be covered |
| R-02 | tenant/control message supplies a raw/custom path | strict contract rejects unknown/path fields | no run/permit; candidate quarantine | republish valid narrower policy | candidate and active-policy state proof | Privacy Policy Owner + Contract Owner | hostile policy vectors | a compromised signed product ceiling remains a separate release risk |
| R-03 | root resolves to UNC/network/device/volume root | canonical path/volume classification and handle facts | mark unsupported; no SQLite open | owner changes support policy or root | no source handles/files | Endpoint Platform/Support | root matrix | virtualized storage can look local while having network semantics |
| R-04 | reparse point or path substitution crosses profile boundary | per-component reparse checks; final handle identity; SQLite native handle identity; `HAS_MOVED` | discard page; source safety hold | rediscover; new source/generation if legitimate | handles closed; no cursor delta | Windows Security | reparse/race prototype | WAL/SHM sibling race and same-user attacks are not completely eliminated |
| R-05 | profile/direct-child count or path length is adversarial | hard count/length/time limit | stop discovery for root; no partial expansion | raise limit only by measured release change | enumerator exit; no retained names | Collector Owner | generated root bomb | a too-low bound can create support misses |
| R-06 | `Local State` is malformed or contains sensitive account/profile data | strict bounded streaming parser; canary scanner | discard content; fallback direct-child enumeration | browser repair or adapter update | no raw content in logs/dumps | Privacy Engineering | malformed/canary corpus | parser defect can still expose a value before scanner catches it |
| R-07 | two sessions discover the same physical profile | equal keyed locator digest; source lease conflict | one lease; loser does not read | retry after lease expiry | one active Task Host; no duplicate run | Endpoint Runtime | same-SID RDS prototype | cannot attribute a shared DB visit to its originating session |
| R-08 | two different profiles are merged because of path/name similarity | UAM UUID + handle identity + unique locator digest | reject merge; `cross_profile_mix` kill switch | rebuild source binding from evidence; quarantine affected events | source ledger reconciliation | Data Correctness Owner | multi-profile canary test | eventual Windows file-ID reuse remains possible |
| R-09 | SQLite opens a different file than the validated candidate | `WIN32_GET_HANDLE` and `FILE_ID_INFO` mismatch | close immediately; no query/result | rediscover; investigate race | handle closure and zero cursor delta | Native Storage Owner | path swap after validation | selected wrapper may not expose the control without native interop |
| R-10 | connection performs checkpoint/delete of WAL on close | `NO_CKPT_ON_CLOSE` effective-value check; per-PID trace | capability disabled if control unavailable; low-integrity write denial | select supported native build; adapter fix | zero write/delete trace | Native Storage Owner + Windows Security | last-reader close campaign | undocumented provider behavior must be caught by trace |
| R-11 | SQLite or dependency attempts source write/create | MIC/ACL denial plus ProcMon/ETW | terminate Task Host; global/ring kill switch; no advance | revoke release, root-cause dependency/API, rerun positive controls | normalized operation report; no residue | Product Security Incident Owner | zero-write test with positive-control build | tracing coverage/tool failure is residual; use two evidence sources where feasible |
| R-12 | live Edge lock causes `BUSY`/`LOCKED` | extended SQLite code and elapsed budget | close direct; eligible Online Backup; then defer | bounded later retry | no lingering lock/handle | Collector Owner | continuous-writer/lock matrix | repeated deferral can create data gaps before browser deletion |
| R-13 | Online Backup repeatedly restarts under writes | remaining/page-count/time/restart telemetry | stop at hard budget; no destination acceptance | later retry or measured policy adjustment | `backup_finish`, source/dest close, memory process exit | Native Storage Owner | churn/restart prototype | API does not expose a perfect semantic restart counter; elapsed/remaining is an approximation |
| R-14 | corrupt/NOTADB/malicious schema | extended result code, strict capability, fuzz limits | no backup-as-acceptance; source safety hold; no advance | browser repair/new generation/adapter update after support review | no scratch; process termination | Collector Security Owner | corrupt/schema fuzz corpus | SQLite/native parser vulnerabilities remain supply-chain risk |
| R-15 | required table is a view/virtual table or invokes untrusted schema code | `sqlite_schema`, `table_xinfo`, disabled views/triggers/trusted schema, authorizer | unsupported; no prepare/extract | new reviewed adapter only | statement finalization | Native Storage Owner | malicious schema fixtures | SQLite metadata parsing still processes untrusted schema text |
| R-16 | unbounded scan/query plan after schema/update | normalized `EXPLAIN QUERY PLAN`; step/time/progress budget | capability blocked | adapter/index predicate change and fixture rerun | cancelled statement/closed connection | Performance Owner + Collector Owner | query-plan mutation | planner can vary across native SQLite versions; exact source ID is part of capability |
| R-17 | oversized URL/text causes allocation or parser attack | SQLite length limits, row byte cap, URL parser limits, process job memory | fail whole page; kill on hard limit; no advance | explicit zero-effect rule only if safely parsed enough to classify | Task Host exit; memory/handle baseline | Collector Security Owner | boundary/fuzz corpus | denial of service from a persistent bad row can require source disablement |
| R-18 | raw URL/path/title leaks to IPC/log/metric/crash/support bundle | exact canaries in every source part; schema scanner; dump disabled | block build/evidence; emergency stop if runtime | rotate/revoke artifacts, delete contaminated evidence, fix sink | all-sink rescan and deletion receipt | Privacy Incident Owner | canary positive controls | scanners can have false negatives; exact controlled canaries reduce but do not remove risk |
| R-19 | invalid row is silently skipped and checkpoint advances | page reconciliation against input IDs and zero-effect ledger | whole page rollback | adapter/policy rule fix; replay same page | checkpoint before/after equality | Data Correctness Owner | mutation test | repeated poison row can block source until supported resolution |
| R-20 | native visit ID duplicate with different minimized payload | local unique key plus payload digest and overlap witness | `identity_conflict`; rollback; source suspect | generation investigation/new generation or adapter correction | quarantined page metadata only | Data Correctness Owner | conflicting-identity fixture | minimized witness may not distinguish changes hidden by approved minimization |
| R-21 | IDs regress after DB restore/replacement | high-water/checkpoint comparison and file identity | close generation; no old cursor advance | create new generation with human/automatic baseline rule | predecessor link and source ledger | Data Correctness Owner | replacement/regression prototype | apparently continuous restore beyond overlap can evade detection |
| R-22 | ID reuse after deletion | AUTOINCREMENT capability, sequence witness, generation UUID, overlap | conflict/new generation when observed | source support review | witness rotation proof | Data Correctness Owner | synthetic ID-reuse mutation | file-ID and ID reuse outside overlap cannot be proved impossible |
| R-23 | late sync has old time and is missed by time cursor | native-ID cursor oracle | no timestamp progress logic permitted | fix adapter if mutation introduced | cursor trace | Data Correctness Owner | late-old-time fixture | sync may update old existing rows in future browser versions; overlap is bounded |
| R-24 | same timestamp visits collapse | unique native-ID dedupe | one event per native identity | correct erroneous dedupe and replay generation if allowed | event/dedupe ledger | Data Correctness Owner | 10,000 same-time synthetic rows | server aggregation may intentionally group later; that is a separate contract |
| R-25 | clock/DST/sleep produces future/old/nonmonotonic source times | checked UTC conversion and quality category | no cursor effect; fail/zero-effect by explicit rule | policy/adapter update; replay only under governed contract | no exact time in diagnostics | Data/Product Owner | clock/time-boundary corpus | source time remains fallible and unsuitable as forensic proof |
| R-26 | cancellation/timeout completes operation after signal | cancellation state checked after each call and before serialization/commit | discard result; close/kill process; no advance | same page later retry | process/job/handle/scratch baseline | Endpoint Runtime Owner | cancellation at every state | `sqlite3_interrupt` cannot guarantee an already-finished call did no work, only that result is discarded |
| R-27 | memory exhaustion during in-memory backup | job memory cap, backup page/size estimates, OOM handling | abort backup; no disk fallback by default | later retry or separate scratch ADR | Task Host exit and memory baseline | Operations + Collector Owner | large-database/low-memory test | repeated deferral on large profiles until product decision |
| R-28 | disk scratch raw data persists | feature off by default; manifest/ACL/encryption if later enabled | capability/source disabled on cleanup failure | incident cleanup, key revocation, fixed build | exact product-root before/after diff | Privacy + Endpoint Security + Operations | future scratch kill/crash matrix | SSD remanence cannot be proved away; encryption is required |
| R-29 | endpoint realm/installation is taken from payload | Coordinator derives authenticated binding; DB composite keys | reject mismatch; no commit | registration/session correction | realm-negative ledger | Realm Security Owner | wrong-realm contract vectors | local machine compromise is outside ordinary-token containment |
| R-30 | metric labels create source/user cardinality or privacy leak | build-time schema/cardinality lint and runtime label allowlist | metric dropped and build blocked | fixed metric definition | metric inventory diff | Observability Owner + Privacy | label mutation/large-source simulation | opaque build/version labels can still grow without governance |
| R-31 | Edge update silently changes schema/locking | capability fingerprint and current/previous fixture gate | unsupported; no progress | adapter release before policy activation | fixture/evidence manifest | Browser Compatibility Owner | candidate Edge lane | release cadence creates recurring operational cost |
| R-32 | EDR/CFA/application control changes access or timing | supported-environment inventory and error distribution | defer/unsupported; no privilege/write fallback | vendor/policy exception only through human governance | no residue; policy evidence sanitized | Endpoint Platform + Security | representative enterprise VM | estate heterogeneity may be broader than lab |
| R-33 | browser impact: hang/crash/latency/history corruption | A/B navigation, Edge crash/event logs, source DB open after run | kill switch/ring halt | revert release/config; investigate lock/page budget | browser/profile health and cleanup report | Endpoint Product + Operations | G2 impact prototype | synthetic localhost workload may not represent all user behavior |
| R-34 | native SQLite package/source mismatch or stale vulnerable build | `sqlite_version`, `sqlite_source_id`, compile options, package/file hashes, SBOM | dependency admission fails | pin/rebuild/update and rerun all G2/G3 fixtures | exact binary manifest | Dependency/Supply-chain Owner | toolchain capture and tamper test | advisories and package lag continue after research date |
| R-35 | support operator asks for raw profile/URL evidence | runbook prohibits it; support CLI emits only opaque IDs/categories | deny collection; escalate privacy-safe experiment | add synthetic reproduction or local-only guided check | support bundle canary scan | Product Support + Privacy | support-runbook tabletop | difficult incidents may remain unresolved without prohibited data; that is acceptable containment |
| R-36 | crash after local commit but before ACK | local unique event/dedupe and checkpoint transaction | exact page retry returns prior result | G5 failpoint recovery | durable store/restart evidence | Endpoint Storage Owner | G5 dependency | not proved by G2/G3 alone |

## 7.3 Failure and compatibility matrix

| Environment/condition | Direct read outcome | Online Backup outcome | Source/cursor action | Supported status |
|---|---|---|---|---|
| local NTFS, existing readable WAL/SHM, ordinary writes | short snapshot expected | fallback available | commit only successful page | candidate; G2 proof required |
| local NTFS, browser not running, rollback-journal/clean DB | direct expected | unnecessary | normal page | candidate if capability passes |
| WAL mode, required WAL/SHM absent and source directory not writable | may fail read-only prerequisite | likely same prerequisite; bounded attempt only if lab shows benefit | defer, no advance | supported only if fixture proves safe read; otherwise unsupported state |
| Edge/another connection holds lock | `BUSY`/`LOCKED` | bounded retry/restart | defer after budget | candidate behavior |
| Edge uses exclusive locking mode | may repeatedly busy | may busy/lock | no busy spin; defer | environment may be unsupported if persistent |
| source database corrupt/NOTADB | fail | backup is not used to legitimize extraction | safety hold, no advance | unsupported until repaired/new generation |
| source file replaced before SQLite open | handle identity mismatch | not attempted | generation evaluation | supported detection |
| source moved/replaced during direct read | `HAS_MOVED`/post-handle mismatch | result discarded | no advance; new generation candidate | supported detection |
| source changes during Online Backup | automatic restart within budget | complete final consistent backup or limit | commit only after DONE/finish | candidate; churn budget measured |
| network/UNC Edge root | no open | no open | unsupported, no cursor | initially unsupported |
| local mounted VHD/FSLogix profile | unknown | unknown | fail closed until matrix approved | **HUMAN DECISION/CLI EXPERIMENT** |
| ReFS local profile | file identity available in principle; locking/Edge support unknown | unknown | fail closed until tested | provisional |
| FAT/exFAT/no effective MIC/ACL containment | write-denial proof likely fails | same | unsupported | initial no-go |
| root/profile reparse point | rejected | rejected | no source binding | unsupported |
| extra unknown schema columns/tables | allowed if required capability/plan unchanged | same | normal | compatible |
| required column missing/renamed | unsupported | unsupported | no advance | incompatible |
| required object becomes view/virtual table | unsupported | unsupported | no advance | incompatible |
| native SQLite lacks required hardening/file-control API | capability failure | capability failure | no advance | incompatible build |
| direct page over time/row/byte budget | cancel/eligible fallback by exact category | bounded backup or defer | no partial page | safe failure |
| memory backup exceeds cap | n/a | abort | no advance | defer; disk scratch remains off |
| cancellation at any state | rollback/close | finish/close | no advance | safe failure |
| same SID, two sessions, same physical profile | one source lease; one reader | same | loser defers; no duplicate | supported only without session-origin claim |
| same SID, session-variable roots differ | separate source IDs | separate | independent leases/cursors | candidate if root variables approved |
| profile directory deleted/recreated | new source identity | n/a | new source/baseline rule | supported detection with residual reuse risk |
| History DB replaced within profile | new generation | n/a | old generation closed | supported detection |
| max/sequence below checkpoint | generation regression | n/a | no old-generation advance | supported detection |
| overlap same ID/same witness | duplicate | duplicate | one effect, may advance | supported |
| overlap same ID/different witness | identity conflict | identity conflict | rollback/safety hold | supported containment |
| deleted IDs/gaps | no rows for gaps | same | advance through proved snapshot high-water | supported |
| old-time late insert with higher ID | read by ID | same | collect/filter by approved policy; advance | supported for controlled fixture |
| Edge version changes but capability identical | blocked until candidate fixture/release policy authorizes | same | no silent activation | rollout-compatible after evidence |
| Dev/Canary/channel not authorized | no discovery | no acquisition | disabled | unsupported by initial policy |

## 7.4 Incident response and runbooks

The following runbooks are mandatory before a G2/G3 pilot-shaped ring:

1. **Source write detected.** Stop global capability; preserve sanitized per-PID trace; revoke candidate ring; verify browser/profile integrity; scan all sinks; fix and rerun positive controls. Never continue because the write “looked harmless.”
2. **Cross-profile/session/realm mix.** Global emergency stop; quarantine affected local unsent events; block upload if not already in durable server custody; preserve source/generation/permit/dedupe metadata only; repair identity/lease logic; run full multi-session matrix.
3. **Cursor advanced on non-success.** Stop source capability and G5-dependent work; compare checkpoint/event/page ledger; restore from last valid local backup only under the later storage runbook; fix and replay synthetic oracle. Production correction requires a separate data-governance plan.
4. **Schema/capability drift.** Mark unsupported; do not guess columns; obtain exact synthetic fixture from the candidate Edge build; review adapter and query plan; deploy consumer support before policy authorization.
5. **Persistent busy/impact regression.** Narrow/disable backup/direct feature; reduce frequency only through policy; collect aggregate lock/latency evidence; do not stop Edge or add privileges.
6. **Scratch cleanup failure.** Disable scratch and source; kill job tree; delete only manifest-authenticated product paths; revoke per-run key if applicable; produce cleanup receipt; never run a broad recursive delete.
7. **Native dependency incident.** Freeze promotion; bind package/source/native hashes; update/rebuild; run SQLite corruption/WAL/backup and all G2/G3 tests; retain prior failure evidence.
8. **Privacy canary escape.** Treat as a privacy incident candidate; stop collection/transport for affected build; locate every sink; delete/rotate contaminated artifacts under governance; add exact regression canary.

Every runbook names the incident commander function, collector owner, Windows security owner, privacy owner, endpoint operations/support owner, evidence location, re-enable authority, and exact pass conditions. Assignment of people is a **HUMAN DECISION**.

## 7.5 Support ownership

- **Collector/Browser Compatibility Owner:** root discovery, schema adapters, Edge fixture lane, release notes, and source-state runbook.
- **Native Storage Owner:** SQLite build/API profile, hardening, backup behavior, query plans, fuzz corpus, and source-write proof.
- **Windows Security Owner:** Task Host token/integrity, handles/reparse checks, filesystem tracing, same-session threat model, and ACL/scratch design.
- **Data Correctness Owner:** source/generation/cursor/dedupe oracle, reconciliation, and incident correction semantics.
- **Privacy Engineering/Product Privacy Owner:** field/time transformation, canaries, observability, prohibited data, and scratch approval.
- **Endpoint Operations/Product Support:** supported environment matrix, rollout, kill switches, browser impact, runbooks, and user-visible support.
- **Dependency/Release Owner:** exact package/native/browser/driver provenance, SBOM, advisories, and same-digest promotion.

No G2/G3 capability becomes active while any of these functions is `UNASSIGNED`.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Common lab rules

Every prototype uses only synthetic local accounts, fictional realms/installations/source IDs, a loopback web server, and disposable/reverted Windows VMs. No internal hostname, address, credential, SSH material, real profile, production activity, or raw organizational value enters the evidence package.

The lab harness records:

- exact Windows edition/build/architecture and session model;
- exact Edge executable version/hash/channel and update policy state;
- exact driver/tool version/hash and disabled telemetry setting;
- exact .NET SDK/runtime and managed package lock;
- native `sqlite3_libversion`, `sqlite3_sourceid`, compile-option digest, binary hash, and loaded module path class;
- product build/release digest and active ceiling/policy/capability digests;
- fixture package root hash and oracle revision;
- ProcMon/ETW filter definition and tool version;
- CPU, working set/private bytes, handle/thread count, file I/O, SQLite result categories, page/backup timing, Edge crash/hang/event data, and cleanup diff;
- machine-readable pass/fail assertions and retained first-failure evidence.

Raw browser databases and raw filesystem traces remain in the restricted disposable lab. Shareable evidence contains digests, operation categories/counts, synthetic fixture IDs, and sanitized minimal reproducers.

## 8.2 Summary test matrix

| Test family | Unit/property | Integration synthetic DB | Browser-generated fixture | Live Edge VM | Multi-session VM | Release gate |
|---|---:|---:|---:|---:|---:|---:|
| strict root/path parsing and limits | required | required | required | required | required | G3 |
| source/generation identity | required | required | required | required | required | G3 |
| SQLite hardening return/effective values | required | required | required | required | n/a | G2 |
| native main-handle identity/moved detection | adapter test | required | required | required | n/a | G2/G3 |
| schema capability and query plan | required | required | current/previous | current candidate | n/a | G2/G3 |
| direct read under live writes | n/a | required | required | required | n/a | G2 |
| Online Backup busy/restart/cancel | API tests | required | required | required | n/a | G2 |
| zero source writes | static/mutation | required | required | required | required | G2 |
| cursor late sync/same time/gaps | property | required | generated plan | selected live checks | n/a | G3 |
| replacement/regression/reuse | property | required | required | controlled lab only | n/a | G3 |
| same-SID shared/distinct roots | state model | n/a | synthetic profiles | n/a | required | G3 |
| cross-realm/session/profile negative | required | required | required | required | required | G3 |
| minimization/canary all sinks | required | required | required | required | required | G2/G3/G4 prerequisite |
| browser impact/resource bounds | n/a | baseline | baseline | required A/B | optional | G2 |
| cleanup/crash/power/cancel | unit/failpoint | required | required | required | required | G2/G3 |

## 8.3 Prototype G2-P1 — direct live read, native-handle identity, and zero source writes

| Field | Specification |
|---|---|
| **Claim falsified** | A short direct read-only transaction can acquire a complete bounded page from a live supported Edge profile without a UAM source write or browser corruption. |
| **Setup** | Disposable approved Windows VM; one synthetic local interactive account; exact candidate Edge Stable build; fresh default user-data root; sync/sign-in disabled; outbound network blocked except loopback; local `site-NNN.localhost` HTTP server; fixed G0 visit plan; G1 Task Host profile installed. |
| **Instrumentation** | ProcMon 4.04 or approved equivalent filtered to Coordinator/User Host/Task Host PIDs and source root; ETW kernel file provider where available; Edge process/event/crash logs; SQLite trace/result counters; native handle/FileId evidence; process/job resource counters; before/after source directory metadata. |
| **Steps** | (1) Generate at least **ESTIMATE 1,000** localhost visits while Edge remains open. (2) Start continuous low-rate navigation. (3) Run direct acquisition repeatedly across empty, small, overlap, and gap pages. (4) Pause after pre-open validation and attempt a same-user path swap in a synthetic variant; require actual SQLite handle mismatch or moved detection. (5) Close UAM connection while Edge is otherwise the last writer/reader in selected cases. (6) Reopen Edge and verify synthetic history continuity. (7) Run an intentionally unsafe positive-control build against a separate fictional profile to prove the trace/write-denial oracle detects it. |
| **Pass** | exact oracle page rows/zero-effects; no extra/missing/duplicate event; actual SQLite main handle equals candidate; moved swap is rejected; zero successful UAM create/write/set/delete/rename/security operation on source/WAL/SHM; no unexpected write-intent operation; no Edge crash/hang; source opens normally afterward; every failed variant has cursor delta zero. |
| **Fail/stop** | any UAM source write, raw canary outside Task Host, handle mismatch accepted, query-plan scan, browser corruption/crash, cross-profile row, or non-success cursor advance. Stop G2 and all dependent G3 live work. |
| **Evidence** | `g2-p1-evidence.json`, normalized operation counts, exact tool/build/native hashes, plan class, source/cursor oracle diff, positive-control result, Edge health summary, cleanup receipt. |
| **Duration** | **ESTIMATE 2–4 hours** automated per Edge/OS capability after image preparation. |
| **Cleanup** | exit Edge; kill Task Host job; remove synthetic user/profile/server/certs/rules/product files; revert VM snapshot; verify service/task/process/file/firewall/certificate diff. |

## 8.4 Prototype G2-P2 — Online Backup under live writes, locks, and restart pressure

| Field | Specification |
|---|---|
| **Claim falsified** | Online Backup can produce a coherent private snapshot under measured live-write conditions without source writes, unbounded lock impact, or cursor advance on incomplete backup. |
| **Setup** | G2-P1 VM plus (a) browser-generated live Edge profile and (b) handcrafted WAL fixture with deterministic writer/lock controller. Memory destination only. |
| **Instrumentation** | all G2-P1 instrumentation plus backup step result, remaining/page count, elapsed/step duration, restart indicator, source-lock timing, memory high-water, cancellation state, `backup_finish` result. |
| **Steps** | Execute fixed campaigns: no writer; one visit/sec; burst writes; checkpoint churn; held read lock; held write/reserved/exclusive lock on synthetic DB; source changes during every backup step; source file replacement; corruption; cancellation at every Nth step; low-memory job limit. Use **ESTIMATE 100** repetitions per class and a **10,000-change** aggregate churn fixture. |
| **Pass** | every accepted backup reaches `SQLITE_DONE`, successful finish, exact private-snapshot oracle, source closed before query, bounded memory/time/step lock, zero source write; `BUSY`/`LOCKED`/restart/size/cancel/fatal cases either complete within declared budget or defer; every incomplete case cursor delta zero and no residual process/memory-dump/scratch file. |
| **Fail/stop** | accepted incomplete destination; unbounded restart/retry; backup result queried before successful finish; source write; browser-impact budget breach; cancellation advances; memory cap bypass; corruption accepted. |
| **Evidence** | per-case state trace, result-code histogram, step timing/remaining series, memory/handle series, exact oracle diff, source-write trace, cleanup receipt. |
| **Duration** | **ESTIMATE 4–8 hours** automated per native SQLite/Edge capability. |
| **Cleanup** | finish/close every handle; terminate job; confirm no disk destination; revert synthetic DB/VM. |

## 8.5 Prototype G2-P3 — cancellation, crash, cleanup, and optional scratch falsification

| Field | Specification |
|---|---|
| **Claim falsified** | Every cancellation/crash boundary leaves no source write, no accepted partial page, no orphan process/handle, no raw residue, and no cursor movement. |
| **Setup** | Synthetic direct and large backup fixtures; Task Host job; cancellation injector; process-kill injector; Coordinator/User Host restart harness. Disk scratch remains disabled. A separate future branch may test encrypted scratch only after its ADR. |
| **Instrumentation** | state transition log, job notifications, handle/process snapshots, filesystem/registry/firewall/certificate before/after, endpoint-store transaction/checkpoint, dump configuration, canary scan. |
| **Steps** | Cancel/kill before open, after open, after handle identity, during prepare, after each returned row, every backup step, after private backup, during minimization, during serialization, before Coordinator transaction, during each future G5 failpoint, after commit before ACK, on User Host exit, Coordinator restart, logoff, and machine restart. Run **ESTIMATE 50** repetitions per boundary. |
| **Pass** | pre-commit boundaries: zero checkpoint/event change; post-commit/pre-ACK: exact duplicate retry returns prior committed outcome; no orphan Task Host/job/handle; no raw canary in dump/log/file; source write count zero; cleanup state complete. |
| **Fail/stop** | one orphan, residue, raw dump, partial event/page, unknown checkpoint delta, broad scavenger delete, or source write. |
| **Evidence** | boundary-indexed ledger, process/handle diff, canary scan, endpoint-store before/after, reboot cleanup evidence. |
| **Duration** | **ESTIMATE 6–12 hours** automated including reboots. |
| **Cleanup** | product-owned cleanup only, then VM revert. The harness proves it never deletes outside the exact synthetic product root. |

## 8.6 Prototype G2-P4 — browser-impact A/B measurement

| Field | Specification |
|---|---|
| **Claim falsified** | The selected direct/backup budgets do not cause unacceptable Edge latency, hangs, crashes, lock waits, or history corruption in the supported lab capability. |
| **Setup** | Identical disposable VMs or randomized alternating baseline/collector runs; fixed Edge/OS/hardware; loopback navigation plan with cold/warm starts, redirects, multiple profiles, continuous browsing, and idle periods. |
| **Instrumentation** | WebDriver navigation timing, browser process CPU/working set/I/O, Task Host resources, Windows responsiveness, Edge crash/hang/event logs, SQLite lock/step timing, source-write trace. Driver first three version parts match Edge; driver telemetry is disabled. |
| **Steps** | Run at least **ESTIMATE 30** paired trials and **1,000** navigations per mode: no UAM baseline, direct pages, backup under moderate writes, backup under churn, cancellation. Randomize order and reset fixture state. |
| **Temporary pass hypotheses** | zero Edge crash/hang/history corruption; zero source write; p95 navigation-duration ratio collector/baseline <= **1.05** and p99 <= **1.10**; no individual SQLite source-lock step above the permit hard cap; Task Host memory/CPU/handles remain inside job limits; no statistically or operationally material sustained Edge resource increase. These are **ESTIMATE** guardrails, not production SLOs. |
| **Fail/stop** | any crash/corruption/source write, or a guardrail breach without an approved revised measurement plan. Online Backup may be disabled independently if direct passes. |
| **Evidence** | raw synthetic timing retained in lab; shareable paired summary, distribution/quantile method, confidence interval, outlier classification, machine/build hashes, and browser health. |
| **Duration** | **ESTIMATE 8–16 hours** automated per environment. |
| **Cleanup** | stop server/browser/product, collect sanitized summary, revert VM. |

## 8.7 Prototype G3-P1 — bounded discovery, multi-profile identity, and same-SID sessions

| Field | Specification |
|---|---|
| **Claim falsified** | Discovery finds every supported synthetic profile within the authorized roots, creates no false source merge, does not crawl outside bounds, and serializes a shared physical source across same-SID sessions. |
| **Setup** | Disposable VM with fictional default and managed-policy roots; profiles with unique canary visit sets; missing/corrupt/stale `Local State`; direct-child decoys/reparse points/limits. For same-SID concurrency, an approved RDS/Windows environment that can establish two interactive logon sessions for one synthetic local/domain test account; if unavailable, this gate remains blocked rather than simulated. |
| **Instrumentation** | directory access trace, transient file-identity capture with raw values restricted to lab, Coordinator keyed locator/source ledger, lease state, per-profile event oracle, process/session tuples. |
| **Steps** | Discover one/many profiles; rename profile; remove/recreate directory; point managed `UserDataDir` to valid local root, invalid relative/UNC/root/reparse paths; use `${session_name}`/`${client_name}` distinct roots; launch two same-SID sessions against one shared root and against separate variable roots; inject same display/folder names across profiles/realms. |
| **Pass** | exact supported profile set; zero access outside root/direct children/exact files; no raw path/name in durable/diagnostic output; same physical profile -> one source and one lease; separate physical roots -> distinct sources; different directory identity after recreation -> new source; unique canaries never cross source; losing session makes no source read/cursor change. |
| **Fail/stop** | recursive crawl, unsupported root opened, path/name/SID merge, two active readers for shared source, cross-profile canary, wrong realm, or missing supported fixture profile. |
| **Evidence** | discovery/source ledger diff, bounded-access operation list, lease trace, source/generation IDs, canary/oracle result, cleanup receipt. |
| **Duration** | **ESTIMATE 4–8 hours** plus RDS image preparation. |
| **Cleanup** | remove synthetic profiles/policy values/accounts/tasks; close sessions; revert VM. No actual connection details appear in evidence. |

## 8.8 Prototype G3-P2 — cursor, overlap, late synchronization, equal time, deletion, and dedupe

| Field | Specification |
|---|---|
| **Claim falsified** | Native-ID progress with bounded overlap returns exactly the controlled fixture oracle under retries, old-time late inserts, equal timestamps, gaps, and duplicates. |
| **Setup** | Deterministic handcrafted SQLite fixture generator plus selected browser fixture; independent truth ledger; randomized model-based operation sequence. |
| **Instrumentation** | source snapshot high-water, returned IDs, overlap witnesses, zero-effect facts, endpoint event/dedupe/checkpoint transaction ledger, actual-versus-expected reconciler. |
| **Steps** | Generate **ESTIMATE 10,000** visits sharing one timestamp; insert older source-time records at later IDs; delete arbitrary ID ranges; set sequence above max; retry each page before/after ACK; reorder acquisition scheduling; inject filtered schemes/invalid rows; run randomized sequences of insert/delete/read/cancel/retry for at least **ESTIMATE 100,000** model operations. |
| **Pass** | exact event and zero-effect set; one business effect per natural identity; checkpoint monotonically follows only committed outcomes; late higher IDs observed regardless of time; equal-time rows remain distinct; gaps advance only when proved in snapshot; failed/cancelled/invalid pages leave checkpoint unchanged; same key/different payload produces conflict. |
| **Fail/stop** | any oracle miss/extra, duplicate effect, timestamp-order dependency, silent invalid-row skip, unproved gap advance, conflict accepted, or non-success cursor delta. |
| **Evidence** | seed, minimal counterexample, full model ledger digest, mutation results, checkpoint/event reconciliation, exact dependency/build IDs. |
| **Duration** | **ESTIMATE 1–3 hours** per deterministic seed set; nightly broader campaign. |
| **Cleanup** | delete only generated fixture/output directories; verify clean repository/workspace. |

## 8.9 Prototype G3-P3 — replacement, regression, moved-file race, and generation lifecycle

| Field | Specification |
|---|---|
| **Claim falsified** | Every observable database/profile discontinuity creates a new source or generation before reused/regressed native IDs can collide with old events. |
| **Setup** | Synthetic profile fixtures with controlled directory/database replacements, checkpointed old generation, file-swap race injector, capability change fixtures, injected file-identity provider for otherwise hard-to-force reuse cases. |
| **Instrumentation** | root/profile/history handle identities, keyed locator digests, `HAS_MOVED`, max/sequence, overlap witnesses, source/generation ledger, event uniqueness. |
| **Steps** | Replace `History` before open, after pre-open handle check, during direct read, during backup; rename/move/delete main; replace with lower/equal/higher max IDs; restore old copy; recreate profile directory at same path; change schema capability; inject same synthetic file identity with conflicting witnesses; run **ESTIMATE 100** cycles per class. |
| **Pass** | changed profile identity -> new source; changed History identity/regression/conflicting overlap/incompatible capability -> old generation unchanged and new/suspect state; moved file result discarded; no old/new event collision; no automatic continuity based only on path/version. |
| **Fail/stop** | one discontinuity accepted into old generation, old checkpoint reset, path-only merge, or conflicting reused ID committed. |
| **Evidence** | transition-by-transition source/generation/cursor ledger, handle facts, minimal race reproducer, oracle diff. |
| **Duration** | **ESTIMATE 4–8 hours**. |
| **Cleanup** | close all handles/processes; remove generated profiles; revert VM. |

## 8.10 Prototype G3-P4 — current/previous Edge capability and incompatible fixture lane

| Field | Specification |
|---|---|
| **Claim falsified** | The adapter works against each human-selected supported Edge build and fails closed on an incompatible future-shaped schema without relying solely on a DB version integer. |
| **Setup** | Disposable offline Windows images with exact signed Edge installers and matching driver; current and previous versions chosen by the accountable support owner; one deliberately incompatible handcrafted fixture. As of 31 July 2026, the latest reviewed official Stable release note is Edge `150.0.4078.105` dated 27 July 2026; this is point-in-time evidence, not a timeless support choice. |
| **Instrumentation** | installer/executable/driver hashes and signatures, browser version, generated fixture manifest, schema metadata, DB version observation, capability fingerprint, query plan, direct/backup/cursor/minimization results. |
| **Steps** | Generate the same localhost visit plan on each build; run closed-browser and live-browser acquisition; compare capability; add unknown columns/tables; remove/rename/change required fields; convert required object to view/virtual table; alter query plan; run candidate new Edge release before policy authorization. |
| **Pass** | every supported selected build passes exact oracle and zero-write/impact gates; harmless extra schema is tolerated; incompatible shape fails `schema_unsupported`; DB version alone never activates support; candidate version remains disabled until fixture evidence and release policy update. |
| **Fail/stop** | version-number allowlist bypasses capability, guessed column mapping, incompatible fixture emits, or supported fixture misses. |
| **Evidence** | per-build signed manifest, capability diff, plan class, oracle/trace result, release-authorization state. |
| **Duration** | **ESTIMATE 2–4 hours** per Edge build after image provisioning. |
| **Cleanup** | uninstall/revert image; delete synthetic fixture outputs according to G0 manifest. |

## 8.11 Secure coding and review tests

In addition to the prototypes:

- fuzz the bounded `Local State` streaming parser, URI parser, URL minimizer, SQLite schema normalizer, contract parser, and native interop boundary;
- run sanitizers/native hardening where the selected SQLite build/toolchain supports them;
- mutation-test every branch that maps an SQLite/Windows error to success/defer/unsupported/new generation;
- statically ban write-capable SQLite open flags, `FileMode.Create/OpenOrCreate/Append`, arbitrary SQL, `ATTACH`, `VACUUM`, checkpoint/journal-mode PRAGMAs, process launch, network clients, and broad directory enumeration from the Task Host project;
- review every unsafe/P/Invoke declaration and generated binding against the exact Windows/SQLite headers;
- enforce SafeHandle ownership, single-threaded connection use, bounded integer conversions, and no logging of exception messages from SQLite/Windows without category mapping;
- run package/native tamper tests and a dependency admission review for every update;
- require two reviewers for source identity, cursor, transaction, and privacy-boundary changes, including one reviewer independent of the implementation author.

# 9. Architecture fitness functions and measurable acceptance criteria

These functions run in CI, the disposable Windows lab, or both. A release exception cannot waive the primary invariant; it must instead disable the affected capability.

| ID | Fitness function | Measurement | Acceptance criterion | Frequency / gate |
|---|---|---|---|---|
| FF-01 | Coordinator has no profile/source filesystem capability | project dependency/API scan plus ProcMon by Coordinator PID | zero profile-root file operation; forbidden API mutation fails CI | every build; G2 |
| FF-02 | Task Host has no generic collection channel | release manifest and architecture test | exactly one fixed Edge capability; no plugin/script/path/SQL/process argument surface | every build; G2 |
| FF-03 | Root discovery is bounded | generated root tree and operation trace | only authorized root, exact `Local State`, direct children, and exact `History` candidates accessed; hard limit terminates | every adapter change; G3 |
| FF-04 | No unsupported root is opened | UNC/device/reparse/relative/volume-root corpus | zero SQLite open attempt for rejected root | every build; G3 |
| FF-05 | Actual SQLite main handle is the validated source | `WIN32_GET_HANDLE`/`FILE_ID_INFO` comparison | equality required; unsupported file-control is capability failure | every native build/OS; G2/G3 |
| FF-06 | Source is never written by UAM | per-PID ProcMon/ETW normalized operation oracle | zero successful create/write/set-info/delete/rename/security on source; mandatory positive control detected | every native/provider/OS/Edge update; G2 primary |
| FF-07 | SQLite source connection is hardened | return/effective-value manifest | all required flags/configs succeed; `db_readonly=1`; no read/write fallback | every run self-check plus CI adapter test; G2 |
| FF-08 | SQL surface is fixed/read-only | static SQL allowlist, authorizer and `stmt_readonly` tests | only approved statements; every mutation/ATTACH/PRAGMA attack rejected | every build; G2 |
| FF-09 | Direct read is bounded | transaction/step/allocation/row/byte timing | all operations remain within permit ceilings; overage cancels/defer with cursor delta zero | every build/nightly and release; G2 |
| FF-10 | Backup is complete before use | backup state trace | destination queried only after `DONE` plus successful `finish`; incomplete backup never serializes a page | every build; G2 |
| FF-11 | Backup retry/restart is bounded | step/restart/time/memory series | no spin/unbounded sleep; all limit cases terminate and clean up | every native build; G2 |
| FF-12 | Browser impact is within approved budget | randomized paired A/B distributions | zero crash/hang/corruption/source write and approved p95/p99/resource limits | each supported Edge/OS capability; G2 |
| FF-13 | No forbidden value crosses privacy boundary | exact path/URL/title/query/fragment/profile canaries in all sinks | zero canary outside Task Host restricted trace/fixture; scanner positive controls all detected | every build/release; G2/G3/G4 prerequisite |
| FF-14 | Profile identity never depends on label/path/SID | mutation tests and generated collisions | same labels/paths across distinct handle identities remain distinct; rename preserves source only when directory lineage proves it | every build; G3 |
| FF-15 | Same physical source has at most one active lease | concurrency model plus RDS campaign | max concurrent active acquisition count per source/generation = 1 | every runtime change; G3 |
| FF-16 | Realm/installation are authenticated, not payload-derived | wrong-realm/installation vectors | every mismatch rejected before source/event mutation | every build; G3 |
| FF-17 | Generation changes on observable discontinuity | replacement/regression/capability corpus | exact expected new-generation/safety state; old checkpoint unchanged | every build and Edge candidate; G3 |
| FF-18 | Cursor is monotonic within a generation | property/model ledger | committed `high_visit_id` never decreases; only transaction commit increases it | every build/nightly; G3 |
| FF-19 | Non-success never advances | inject every error/cancel/crash category | `checkpoint_after == checkpoint_before` for failed/busy/locked/unsupported/corrupt/cancelled/conflict/cleanup failures | every build; G2/G3 primary |
| FF-20 | Controlled fixture recall is exact | independent expected-versus-actual set reconciliation | no missing, extra, cross-source, or duplicate final effect; every input has event or approved zero-effect outcome | every build/release; G3 primary |
| FF-21 | Late old-time and equal-time correctness | deterministic fixture | every higher native ID observed independent of source time; equal timestamps remain distinct | every build; G3 |
| FF-22 | Deletion gaps do not stall or fabricate events | gap/sequence fixture | no fabricated event; checkpoint advances only through high-water proven in the snapshot | every build; G3 |
| FF-23 | Retry has one effect | pre/post-ACK retry matrix | same dedupe key/digest returns one persisted event; conflicting digest blocks page | every build; G3/G5 |
| FF-24 | Schema support is capability-based | current/previous/incompatible fixture matrix | supported fixtures pass; changed required shape/plan fails; DB version alone cannot authorize | each Edge/native release; G3 |
| FF-25 | Query plan remains bounded | normalized plan classifier | required PK range/lookup plan; no full visit scan/temp sort/view/virtual table | each fixture/native release; G2/G3 |
| FF-26 | Overlap memory is bounded | endpoint-store inspection | witness count <= configured cap per generation; pruning occurs in same checkpoint transaction | every build; G3 |
| FF-27 | Observability cardinality is bounded | metric schema linter and source-count simulation | no dynamic labels; maximum series <= approved budget | every telemetry change; G2/G3 |
| FF-28 | Cleanup is complete | process/handle/file/registry/task/firewall/certificate before/after diff | no orphan/residue; cleanup failure disables capability and never advances | every lab run/release; G2/G3 |
| FF-29 | Evidence is reproducible and accessible | regenerate evidence, JSON schema validation, text rendering | same fixture/seed yields same canonical ledger; outputs have machine-readable JSON and text, no color-only meaning, stable error codes, and keyboard/screen-reader-compatible documentation | every release evidence build |
| FF-30 | Exact native dependency is known | loaded-module and source-ID capture | loaded binary hash/source ID/compile options match admitted manifest | startup self-check and release; G2 |

## 9.1 Primary acceptance expression

A G2/G3 build is eligible for predecessor review only when this logical expression is true:

```text
G2_G3_PASS =
    FF_01..FF_30 required results pass
    AND source_write_success_count = 0
    AND cross_profile_or_session_mix_count = 0
    AND non_success_cursor_delta_count = 0
    AND controlled_fixture_missing_count = 0
    AND controlled_fixture_extra_count = 0
    AND final_business_duplicate_count = 0
    AND unresolved_identity_conflict_count = 0
    AND cleanup_residue_count = 0
    AND blocking_owner_count = 0
    AND blocking_ADR_count = 0
```

No ratio or confidence interval can compensate for a nonzero primary invariant count.

## 9.2 Data-quality acceptance

Data quality is expressed as explicit, non-personal operational facts:

- source state: active/absent/removed/unsupported/safety hold;
- acquisition outcome and method;
- schema capability family;
- snapshot high-water and checkpoint transition, endpoint-local only;
- event/zero-effect/duplicate/conflict counts;
- source-time quality class, if approved;
- completeness only against controlled fixtures, never a claim that browser history is complete real-world activity.

UAM MUST display or document that telemetry can be missing because history was deleted, sync was delayed, Edge was unsupported/busy, policy disabled the source, or the endpoint was offline. It MUST NOT convert absence into “no activity.”

---

# 10. Human decisions and owner questions

Research does not make the decisions below. Role names identify accountable functions, not assigned people.

| ID | Decision / owner question | Options and consequences | Conservative temporary default | Accountable role/function | Blocked work if delayed |
|---|---|---|---|---|---|
| H-01 | Which Edge channels and exact version window are supported? | Stable only minimizes variability; Stable+Extended Stable follows enterprise cadence; Beta adds pre-release coverage/cost; Dev/Canary materially increase drift and are not Microsoft-supported enterprise channels | all live channels disabled; lab tests human-selected current and previous Stable | Endpoint Product Owner with Endpoint Platform/Support and Security | policy activation and production support claim |
| H-02 | Which profile technologies/environments are supported? | local default profiles are simplest; managed local `UserDataDir` adds enterprise flexibility; FSLogix/RDS/Citrix/roaming/redirected profiles require separate locking/identity tests; WebView2 is a separate source | local NTFS default and managed local root in lab only; everything else unsupported | Endpoint Platform/Product Support | supported environment matrix and rollout |
| H-03 | What is the first-run lookback? | zero lookback minimizes privacy/load; bounded time includes pre-activation records; time+count contains load but can truncate | collection disabled; implementation fallback is activation baseline/zero lookback | Product/Data Owner with Privacy and Legal | baseline activation/cursor semantics |
| H-04 | What source-time precision and validity range are allowed? | exact time increases sensitivity; minute/hour/day buckets reduce it; future/past tolerances affect zero-effect/failure outcomes | do not emit live time; synthetic tests use an explicit fixture precision | Product/Data Owner with Privacy | event schema, transformation, witness digest |
| H-05 | What is the unsupported-environment policy? | fail closed and report health; silently ignore; or user/admin remediation. Silent ignore hides coverage gaps; repeated retry can harm endpoints | fail closed, low-frequency bounded health category, no source progress | Product Support/Risk Owner with Endpoint Platform | operational runbook and portal semantics |
| H-06 | Are shared-profile concurrent sessions allowed without session-origin attribution? | allow source-level evidence only; disable shared source; or require a new attribution-capable source. Claiming session origin is unsupported | one source/one lease; omit business session-origin; disable if attribution is required | Product/Data Owner with Privacy and Risk | RDS/VDI support |
| H-07 | Which URL/site/domain fields and hard-deny classes are approved? | registrable domain, host, application match, or coarser category have different privacy/utility; paths/query/title are out of current scope | live output disabled; synthetic site key only | Product Privacy Authority + Data Owner | Task Host minimizer and G4 |
| H-08 | May native visit ID be retained locally and/or sent centrally? | local retention supports cursor/dedupe; central transmission may expose volume/sequence and is unnecessary if dedupe key suffices | local endpoint only; omit from upload | Product Privacy/Data Governance | final event/upload contract |
| H-09 | Exact overlap/page/time/memory/backup retry budgets? | higher values improve tolerance/recall but increase impact and retained witnesses; lower values defer more | use only labeled lab estimates; no production authorization | Endpoint Product + Operations/SRE + Privacy for retained metadata | production limits and capacity |
| H-10 | Is disk scratch permitted if memory backup cannot support large profiles? | remain memory-only/defer; encrypted scratch with key/cleanup burden; or narrower supported profile size | disk scratch disabled | Privacy, Endpoint Security, Operations, Records Management | support for large databases |
| H-11 | Scratch encryption/key-wrapping and remanence policy? | DPAPI/user key, TPM/device key, enterprise KMS-assisted wrapping, or no scratch; each affects offline/recovery/support | no scratch, therefore no raw-at-rest key | Cryptographic Authority + Privacy + Operations | future scratch ADR |
| H-12 | How long are absent/removed source records and overlap witnesses retained? | short retention reduces metadata; longer aids restore/support; deletion must preserve audit/cursor invariants | retain until explicit records decision; do not delete automatically | Records Management/Data Controller/Data Owner | cleanup and deletion implementation |
| H-13 | What performance/resource budget is acceptable? | strict budget defers more; broad budget can affect Edge; per-environment budgets may be needed | temporary falsification guardrails in G2-P4 only | Product/Operations/SRE with Endpoint Support | G2 acceptance and scheduling |
| H-14 | Which browser-impact outcome triggers automatic emergency stop? | any crash/corruption/source write is non-negotiable; latency/resource thresholds need risk authority | source write, corruption, cross-mix, or crash -> immediate stop; estimate thresholds block rollout | Product Risk Owner + Security + Operations | kill-switch automation |
| H-15 | What is the production native SQLite/provider/support arrangement? | Microsoft.Data.Sqlite.Core plus selected SQLitePCLRaw/native build; direct narrow P/Invoke; commercial support/native feed; or self-built SQLite. Each changes provenance/API/support cost | no production selection; prototype narrow adapter with exact source ID | Engineering Architecture + Security + Legal/Procurement + Support | dependency admission and release |
| H-16 | What Edge update cadence and fixture support commitment is funded? | test every Stable patch, selected milestones, or managed delay; cadence affects compatibility risk and staffing | every candidate supported build must pass before policy authorization | Product/Endpoint Platform/Engineering Leadership | ongoing operations |
| H-17 | Who can re-enable a source/build after safety hold? | collector owner alone is too weak for privacy/security incidents; dual approval improves control but increases outage | disable remains until named incident and privacy/security authority approve evidence | Security/Privacy/Release Governance | incident recovery |
| H-18 | What local support evidence may an administrator view? | opaque IDs/categories only; local path reveal may aid support but creates privacy exposure | opaque source token, category, capability and timestamps only; no path/URL/profile name | Product Support + Privacy + IAM | support tooling/runbook |
| H-19 | Is an endpoint/user notification UI required? | no UI; OS/enterprise notice; portal documentation. This is legal/product/accessibility territory | no new endpoint UI in G2/G3; do not hide mandatory notice requirements | Product/Legal/Privacy/Accessibility Owner | production deployment, not prototype |
| H-20 | Who owns source correctness and data correction after a defect? | product/data owner defines correction; engineering cannot silently rewrite events | no automatic production correction; quarantine and stop | Data Owner/Data Governance + Product Risk | incident and later deletion/replay work |
| H-21 | Which functions are staffed, trained, and available to support the required Windows/SQLite/Edge/privacy skills and incident coverage? | dedicated maintained capability; shared specialist pool; or no supported capability. Understaffing increases update lag, unsafe workarounds, and outage duration | capability disabled; no production support claim or live rollout | Engineering Leadership with Endpoint Platform/Support, Security, Privacy, and Operations | G2/G3 live gate, recurring compatibility, incident recovery, production support |

## 10.1 Questions that must be answered before live activation

1. What exact Edge channel/build/profile/Windows matrix is claimed as supported?
2. Does any supported environment use network, redirected, virtualized, or concurrently shared roots?
3. What is the legal/product purpose, and which exact site/domain representation and time bucket are necessary for it?
4. Is pre-activation history permitted; if so, what time/count cap and how are late synchronized old-time records treated?
5. Is session-origin attribution required? If yes, this database source cannot satisfy it for shared profiles.
6. What is the acceptable unsupported/busy coverage signal in the portal and support process?
7. What browser-impact and resource budget blocks a ring?
8. Is memory-only/defer acceptable for large/locked databases, or is encrypted scratch worth its privacy/operations cost?
9. Which native SQLite build, support channel, advisory process, and package-to-source mapping are approved?
10. Which named functions own compatibility, correctness, privacy, incident response, and re-enable approval?

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 CLI evidence conventions

Commands below are repository-facing examples with placeholders. They do not contain or request an SSH command, host, address, user, key, port, credential, internal domain, or production value. A lab transport wrapper may be used locally, but connection material is outside the evidence chain.

Every command writes under a new evidence directory and emits `evidence.json` with source tree, inputs, exact binaries, times, classifications, result, first failure, and cleanup. A rerun creates a new directory; it never overwrites a failure.

## 11.2 Experiment command set

### E-G23-00 — verify allowlisted inputs and toolchain

```powershell
pwsh ./eng/evidence/New-EvidenceRun.ps1 `
  -ExperimentId E-G23-00 `
  -Output <EVIDENCE_ROOT>/E-G23-00

dotnet --info | Out-File <EVIDENCE_ROOT>/E-G23-00/dotnet-info.txt

dotnet run --project ./src/tools/Uam.NativeInventory -- `
  --format json `
  --output <EVIDENCE_ROOT>/E-G23-00/native-inventory.json
```

Must produce:

- hashes of the six allowlisted inputs;
- exact SDK/runtime, Windows build class, package lock/source mapping;
- loaded SQLite binary hash/path class, `sqlite_version()`, `sqlite_source_id()`, compile options, and required API bitmap;
- exact Edge/driver inventory only when run in the approved VM;
- pass only when every runtime input is identifiable and supported by the current experiment manifest.

### E-G23-01 — generate deterministic synthetic profiles and localhost visits

```powershell
dotnet run --project ./src/tools/Uam.EdgeFixture -- generate `
  --manifest ./fixtures/plans/edge-g23-v1/manifest.json `
  --output <WORK_ROOT>/edge-fixtures `
  --classification T1 `
  --network loopback-only `
  --clean

dotnet run --project ./src/tools/Uam.EdgeFixture -- verify-determinism `
  --left <WORK_ROOT>/edge-fixtures-a `
  --right <WORK_ROOT>/edge-fixtures-b `
  --output <EVIDENCE_ROOT>/E-G23-01/determinism.json
```

Browser lane wrapper:

```powershell
pwsh ./eng/lab/Invoke-EdgeVisitPlan.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -EdgePackage <PINNED_SYNTHETIC_EDGE_PACKAGE> `
  -DriverPackage <MATCHING_PINNED_DRIVER_PACKAGE> `
  -VisitPlan ./fixtures/plans/edge-g23-v1/visit-plan.ndjson `
  -ExternalNetwork Disabled `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce:

- byte-identical canonical plan/oracle outputs for the same seed;
- exact synthetic URL plan and canary registry, with no real value;
- browser/driver hashes/signatures and version match;
- proof external network was blocked and driver telemetry disabled;
- exact expected profile/source/generation/cursor/event ledgers;
- clean-exit capture only; no raw live production-like profile.

### E-G23-02 — root/profile discovery and source identity

```powershell
dotnet test ./tests/Uam.Edge.Discovery.Tests `
  --configuration Release `
  --logger "trx;LogFileName=discovery.trx"

dotnet run --project ./src/tools/Uam.EdgeProbe -- discover `
  --root-kind edge.stable.default `
  --fixture-root <SYNTHETIC_ROOT> `
  --policy ./fixtures/policy/edge-g23-lab-policy.json `
  --output <EVIDENCE_ROOT>/E-G23-02/discovery.json
```

Must produce exact attempted-path categories, child counts, handle identity classes, source mappings, rejection reasons, and proof that raw paths/profile names were not serialized. Pass requires exact oracle source set and no out-of-bound operation.

### E-G23-03 — SQLite hardening and fixed-query capability

```powershell
dotnet run --project ./src/tools/Uam.EdgeProbe -- capability `
  --history <SYNTHETIC_HISTORY_PATH> `
  --mode read-only `
  --require-native-handle `
  --output <EVIDENCE_ROOT>/E-G23-03/capability.json

dotnet test ./tests/Uam.Edge.SqliteSecurity.Tests `
  --configuration Release `
  --filter Category=Required
```

Must produce every `sqlite3_open_v2` flag; each `db_config` return/effective value; `db_readonly`; authorizer denials; statement-readonly results; main Windows handle identity; moved state; schema metadata; normalized query plan; native source ID/compile options. Pass requires all mandatory controls and the fixed plan.

### E-G23-04 — direct live-read and filesystem zero-write proof

```powershell
pwsh ./eng/lab/Invoke-EdgeAcquisitionCampaign.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Campaign DirectLive `
  -FixturePackage <SIGNED_T1_FIXTURE_PACKAGE> `
  -TraceConfig ./eng/lab/procmon-edge-source-write.pmc `
  -Output <RESTRICTED_LAB_OUTPUT>

dotnet run --project ./src/tools/Uam.TraceNormalize -- `
  --input <RESTRICTED_PML_OR_ETL> `
  --policy ./eng/evidence/source-write-policy.json `
  --output <EVIDENCE_ROOT>/E-G23-04/source-write-summary.json
```

Must produce per-UAM-process counts for open intent, create, write, set information, rename, delete, and security operations; direct read timing/results; source handle equality; browser health; cursor before/after; positive-control detection. Pass is zero successful source mutation and exact recall.

### E-G23-05 — lock/update/Online Backup campaign

```powershell
pwsh ./eng/lab/Invoke-EdgeAcquisitionCampaign.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Campaign BackupLockAndChurn `
  -Cases ./fixtures/campaigns/g2-backup-cases.json `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce step-by-step result codes, remaining/page count, elapsed/lock time, inferred restarts, memory/handle series, cancellation points, `backup_finish`, oracle diff, source-write summary, cursor delta, and cleanup. Every incomplete case must show zero cursor delta.

### E-G23-06 — cursor and deterministic dedupe model

```powershell
dotnet test ./tests/Uam.Edge.CursorModel.Tests `
  --configuration Release `
  --settings ./tests/runsettings/g23-model.runsettings `
  --logger "trx;LogFileName=cursor-model.trx"

dotnet run --project ./src/tools/Uam.EdgeModelCheck -- `
  --plan ./fixtures/plans/edge-g23-v1/model-operations.json `
  --seeds ./fixtures/plans/edge-g23-v1/seeds.txt `
  --output <EVIDENCE_ROOT>/E-G23-06/model-ledger.json
```

Must produce seed, operation count, minimal counterexample, expected/actual event and zero-effect sets, dedupe conflicts, checkpoint transitions, and mutation score. Pass requires exact set equality and non-success cursor delta zero.

### E-G23-07 — source-generation/replacement/race campaign

```powershell
pwsh ./eng/lab/Invoke-EdgeGenerationCampaign.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Cases ./fixtures/campaigns/g3-generation-cases.json `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce pre/actual/post handle identities, moved results, locator digests only in shareable evidence, max/sequence/witness transitions, exact new-source/new-generation/safety decisions, and proof no old-generation event collision.

### E-G23-08 — same-SID concurrent sessions

```powershell
pwsh ./eng/lab/Invoke-EdgeMultiSessionCampaign.ps1 `
  -LabAlias <APPROVED_MULTISESSION_LAB_ALIAS> `
  -SyntheticAccountSeed <T1_SEED_REFERENCE> `
  -Cases ./fixtures/campaigns/g3-same-sid-cases.json `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce sanitized session/logon tuple classes, source locator equality/inequality, lease timeline, Task Host counts, source event oracle, and cross-session canary results. Pass requires one active reader for a shared source and distinct sources for distinct session-variable roots. If the approved environment cannot create the required sessions, the result is `BLOCKED`, not `PASS`.

### E-G23-09 — clock, DST, sleep, and source-time conversion

```powershell
dotnet test ./tests/Uam.Edge.SourceTime.Tests `
  --configuration Release

pwsh ./eng/lab/Invoke-EdgeTimeCampaign.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Cases ./fixtures/campaigns/g3-time-cases.json `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce checked conversion vectors for Windows epoch microseconds, min/max/overflow, same/nonmonotonic/future/past values, DST-zone independence, sleep/resume trace, quality categories, and proof the cursor/order is unchanged by source time.

### E-G23-10 — current/previous Edge compatibility lane

```powershell
pwsh ./eng/lab/Invoke-EdgeCompatibilityMatrix.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Matrix ./eng/lab/edge-supported-candidate-matrix.json `
  -FixturePlan ./fixtures/plans/edge-g23-v1/manifest.json `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce exact signed installer/executable/driver hashes, versions, capability fingerprints, query plans, direct/backup results, zero-write/impact results, and incompatible-fixture rejection. A candidate version cannot be authorized by this command; it only supplies evidence to the human/release ADR.

### E-G23-11 — browser-impact A/B

```powershell
pwsh ./eng/lab/Invoke-EdgeImpactBenchmark.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Plan ./fixtures/campaigns/g2-impact-plan.json `
  -RandomizeOrder `
  -Output <RESTRICTED_LAB_OUTPUT>
```

Must produce paired raw synthetic timing in restricted storage, normalized p50/p95/p99 ratios, confidence intervals, Edge/UAM CPU-memory-I/O distributions, crashes/hangs, lock durations, source-write count, and declared temporary/approved budget comparison.

### E-G23-12 — cancellation, cleanup, and canary scan

```powershell
pwsh ./eng/lab/Invoke-EdgeFailureCampaign.ps1 `
  -LabAlias <APPROVED_LAB_ALIAS> `
  -Cases ./fixtures/campaigns/g2-g3-failure-boundaries.json `
  -Output <RESTRICTED_LAB_OUTPUT>

dotnet run --project ./src/foundation/Uam.CanaryScan -- `
  --manifest ./fixtures/canaries/g23-canaries.json `
  --roots <EVIDENCE_AND_TEST_OUTPUT_ROOTS> `
  --output <EVIDENCE_ROOT>/E-G23-12/canary-result.json
```

Must produce per-boundary endpoint-store delta, process/job/handle diff, source-write summary, scratch/product-root diff, dump setting, all-sink canary result, and cleanup receipt. Mandatory canary miss or residue fails.

### E-G23-13 — aggregate gate

```powershell
dotnet run --project ./src/tools/Uam.Gate -- evaluate `
  --gate ./eng/gates/g2-g3-edge.json `
  --evidence-root <EVIDENCE_ROOT> `
  --output <EVIDENCE_ROOT>/g2-g3-gate.json
```

The gate file must bind exact evidence digests, source tree, owners, ADR states, human-decision states, Edge/OS/native capability matrix, exceptions, and expiry. Pass requires all primary invariants to be zero and no blocking exception. The gate output is reviewed; it does not self-authorize production.

## 11.3 Exact evidence retention/cleanup rule

- T1 plans, schemas, normalized ledgers, and redacted summaries may be committed according to G0 policy.
- Raw PML/ETL, browser-generated profile/database files, process dumps, and raw identity records remain in restricted disposable lab storage and are deleted/reverted after summary approval.
- Evidence manifests retain digests and deletion receipts, not raw source values.
- A cleanup failure invalidates the experiment and blocks the capability.

---

# 12. ADR proposals

| ADR | Decision | Proposed status | Alternatives | Rationale/evidence | Accountable owner/function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-G23-001 | User Host discovers only release-owned default or mandatory-policy local Edge roots; bounded direct children; no custom command-line root | **Proposed — accept for prototype** | broad crawl; Local State-only; arbitrary tenant path | accepted session boundary plus Microsoft root/policy/network guidance | Collector/Browser Compatibility Owner + Privacy | supported root technology change or failed discovery prototype |
| ADR-G23-002 | `source_id` is UAM UUIDv7 profile-directory lineage; locator digests are installation-keyed; labels/path/SID are non-authoritative | **Proposed — accept** | path hash; SID/name; raw file ID | privacy, rename/recreation, multi-session and realm correctness | Data Correctness Owner + Windows Security | file-identity lab failure or new supported filesystem |
| ADR-G23-003 | `source_generation_id` changes on History identity replacement, regression, incompatible capability, moved file, or overlap conflict | **Proposed — accept** | reset cursor in place; version-only generation | prevents reused native IDs from colliding and preserves lineage | Data Correctness Owner | controlled replacement false negative or migration need |
| ADR-G23-004 | Acquisition is short direct read-only page, Online Backup to memory on eligible live-lock failure, then defer | **Proposed — accept; carries predecessor decision** | direct only; always backup; raw file copy; VSS | simplest bounded method consistent with official SQLite and accepted baseline | Native Storage Owner + Endpoint Product | source write/impact/recall failure or superior supported API |
| ADR-G23-005 | Source SQLite profile requires native main-handle identity, read-only flags, defensive/trusted-schema/attach/extension/view/trigger controls, no checkpoint on close, fixed SQL and query-plan gate | **Proposed — accept for prototype** | managed defaults only; path comparison only | zero-write, TOCTOU, malicious schema, and bounded query requirements | Native Storage Owner + Windows Security | provider cannot expose required APIs or lab behavior differs |
| ADR-G23-006 | Disk scratch is disabled; any raw disk snapshot needs a separate encrypted scratch ADR | **Proposed — accept** | plaintext scratch; OS temp; default disk backup | endpoint minimization and cleanup/remanence cost | Privacy + Endpoint Security + Operations | measured memory-only failure on an approved profile distribution |
| ADR-G23-007 | Browser schema support is capability/fixture based; current/previous is a provisional planning target; DB version alone is not authority | **Proposed — accept principle; support window deferred** | version allowlist; best-effort columns | browser internals are not public API; current/previous fixtures are falsifiable | Browser Compatibility Owner + Product Support | Edge schema/plan change or human support decision |
| ADR-G23-008 | Cursor is native `visits.id` per generation with bounded ID overlap; source time never orders progress | **Proposed — accept** | timestamp; timestamp+URL; full rescan | current Chromium local-ID and late-sync semantics | Data Correctness Owner | supported capability lacks equivalent monotonic native ID |
| ADR-G23-009 | Event dedupe uses realm-bound installation/source/generation/native ID/contract major; payload digest conflict blocks page | **Proposed — accept** | random event only; URL/time key | at-least-once one-effect invariant and replacement isolation | Data Correctness + Contract Owner | event-contract migration or central dedupe requirement |
| ADR-G23-010 | Each page's minimized events, zero-effect facts, witnesses, run record, and checkpoint commit atomically; ACK follows commit | **Proposed — accept boundary; proof deferred to G5** | checkpoint after ACK; partial row commit | accepted cursor-ahead prohibition | Endpoint Storage Owner | G5 failpoint evidence or store redesign |
| ADR-G23-011 | Same physical profile across same-SID sessions is one source with one lease; UAM does not claim visit session-origin | **Proposed — accept technical rule; business support deferred** | per-session duplicate source; guess attribution; disable all | database contains source records, not reliable origin session | Product/Data Owner + Runtime Owner | human attribution requirement or RDS evidence |
| ADR-G23-012 | Stable low-cardinality errors/metrics; raw paths/URLs/profile IDs/native IDs excluded from observability | **Proposed — accept** | dynamic exception/path labels | privacy boundary and operational cardinality | Observability + Privacy Owner | incident where categories are insufficient, handled via new bounded code |
| ADR-G23-013 | Live capability activation requires zero-write, exact recall, no mix, non-success no-advance, current/previous fixture, impact, cleanup, owner, and ADR gate | **Proposed — accept** | rollout on unit tests only | public docs do not prove UAM fitness | Release Governance + Endpoint Product | material gate change or new supported environment |
| ADR-G23-014 | Production managed/native SQLite dependency is selected by an admission spike; exact current packages are not timeless architecture | **Proposed — defer package selection** | Microsoft.Data.Sqlite; SQLitePCLRaw; direct P/Invoke; self-build/commercial feed | required C APIs, native provenance, patch cadence, support and license must all fit | Architecture + Dependency Security + Legal/Procurement | completion of dependency spike/advisory |
| ADR-G23-015 | Supported Edge channels/versions/profile technologies, first-run lookback/time precision, and unsupported-environment treatment remain human decisions with fail-closed defaults | **Proposed — record human boundary** | engineering chooses defaults | explicitly prohibited research decisions | designated human functions in section 10 | signed human decision record |

No ADR may be `Accepted` while its accountable owner is `UNASSIGNED`, a required CLI gate is missing, or a primary invariant has a nonzero failure count.

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Backlog

| Order | Work item | Dependencies | Deliverable | Exact pass/fail test | Stop gate |
|---:|---|---|---|---|---|
| 1 | Record G2/G3 evidence manifest and open ADRs | Batch 01 accepted predecessor | input hashes, ADR files, owner placeholders, gate schema | manifest includes only six allowlisted inputs and current source register | extra/missing/unreviewed input |
| 2 | Assign accountable owner functions and human-decision records | 1 | owner register and section 10 decision templates | no blocking item `UNASSIGNED` before its gate | unassigned G2/G3 safety owner |
| 3 | Add Edge G2/G3 contract projects and architecture guards | 1 | strict contracts, error enums, API/package bans, source-state model | forbidden path/SQL/write/network/plugin mutation fails CI | any architecture mutation survives |
| 4 | Implement native SQLite inventory/admission spike | 2–3 | narrow C API interface; loaded binary/source ID/compile-option evidence; provider comparison | all required open/db-config/file-control/backup/interrupt/progress APIs available and exact native mapped | unknown native binary, missing main-handle identity, or provenance gap |
| 5 | Select prototype-only managed/native adapter behind one internal interface | 4 | ADR evidence; locked package/binary; SafeHandle wrappers; removal path | package-to-source/binary mapping and license/security review pass; no broad ORM | do not select by convenience/popularity |
| 6 | Implement deterministic Edge fixture plan and independent oracle | G0 foundations, 3 | T1 browser and handcrafted fixture generators; source/generation/cursor ledgers | clean double-generation identical; mutations caught; all canaries detected | nondeterminism, real value, oracle common-code dependency |
| 7 | Implement Windows path/handle identity library in `Uam.Windows.Interop` | 3 | directory/file open, reparse rejection, `FILE_ID_INFO`, final path class, safe handles | reparse/path-swap/long-path/identity corpus passes; no raw logging | unsupported handle identity or unsafe P/Invoke |
| 8 | Implement bounded root and profile discovery in User Host | 6–7 | default/managed root resolver, bounded Local State hint, direct-child enumerator | G3-P1 single-session cases exact; no access outside bounds | recursive access or raw profile metadata sink |
| 9 | Implement transient source-binding/HMAC service in Coordinator | 3, 7–8 | purpose-separated locator digest, source registry, raw-buffer zeroization | synthetic collisions/realm/session/rename/recreation tests exact | path/SID/name authority or raw identity durable/logged |
| 10 | Implement source/generation/checkpoint schema and pure state transitions | 3, 6, 9 | migrations/models, transition validator, overlap witness bounds | all illegal transitions/mutations rejected; no ID reuse | schema lacks realm/install/generation uniqueness |
| 11 | Implement SQLite source connection hardening | 4–5, 7 | read-only open, db-config verification, authorizer, limits, native handle comparison, moved check | E-G23-03 passes on every admitted native/OS | any required control ignored or read/write fallback |
| 12 | Implement capability detector and query-plan classifier | 6, 11 | required table/column/rowid/autoincrement/runtime-type/plan adapter | supported fixtures pass; incompatible fixtures fail; DB version-only mutation fails | guessed columns, view/virtual table, full scan |
| 13 | Implement direct bounded page reader | 11–12 | one-snapshot high-water/query/page result, cancellation | direct synthetic/live oracle exact; time/row/byte limits defer; zero write | source write, partial page, unbounded transaction |
| 14 | Implement fixed Task Host URL minimization boundary | G4 contract skeleton, 3, 6, 13 | raw URL confined to Task Host; synthetic site/domain output; canaries | raw URL/path/query/title canaries absent from Task Host output and all later sinks | no live activation until G4 field/precision approval |
| 15 | Implement in-memory Online Backup fallback | 11–14 | step/retry/restart/memory/cancel state machine and private query | E-G23-05 exact; incomplete destination never used; zero source write | disk fallback or unbounded retry appears |
| 16 | Keep disk scratch code absent/compiled off | ADR-G23-006 | feature manifest assertion | build contains no raw scratch implementation/path | measured need opens separate ADR; do not sneak in temp files |
| 17 | Implement Coordinator source lease and same-source serialization | 9–10 | lease acquire/renew/release/expiry bound to source/generation/session | concurrency model max active lease one; loser no read | two active readers for one source |
| 18 | Implement native-ID cursor/overlap/dedupe pure model | 6, 10, 13–15 | page selection/advance, witness compare, natural identity, conflict outcomes | E-G23-06 model/property/mutation campaign exact | any timestamp-based progress or conflict acceptance |
| 19 | Implement page validation and atomic local commit adapter | 10, 17–18 | minimized event/zero-effect/witness/run/checkpoint transaction and ACK result | transaction integration tests; stale version conflict; same key/digest idempotent; different digest rollback | G5 still required before production durability claim |
| 20 | Implement low-cardinality health, metrics, and privacy-safe support CLI | 3, 9–19 | fixed categories, metric schemas, opaque local source token, accessible JSON/text output | cardinality lint; dynamic label mutation; canary scan; no color-only result | path/URL/source/user metric/log leak |
| 21 | Implement incident kill switches and source safety hold | 3, 10, 17–20 | global/channel/capability/source disable, outstanding-result discard, higher-revision recovery | policy narrowing/cancel tests; no disabled permit/result advances | kill switch cannot preempt or result still commits |
| 22 | Prepare disconnected placeholder-only Windows lab scripts | 1–21 | inventory, fixture, install, trace, campaign, evidence, cleanup scripts | lint proves no connection material/real identity and read-only inventory first | any credential/address/SSH material or production value |
| 23 | Obtain human-approved Edge/Windows/profile lab matrix | H-01/H-02/H-05 | signed decision record for claimed test scope | exact environments/builds named; unsupported states defined | no environment may be described as supported without this |
| 24 | Run approved read-only inventory and native self-check | 22–23 | sanitized OS/Edge/session/filesystem/EDR capability evidence | environment matches matrix; no mutation during inventory | unknown/unsupported environment treated as pass |
| 25 | Execute G2-P1/P2/P3/P4 | 13–16, 19–24 | direct/backup/cleanup/impact evidence | all G2 primary gates pass on every claimed capability | any source write, browser corruption/crash, raw leak, non-success advance |
| 26 | Review G2 gate and freeze acquisition profile | 25 | accepted/rejected ADR updates and immutable G2 evidence digest | architecture/security/privacy/data-correctness chairs accept exact evidence | G3 live campaigns do not start after failed G2 |
| 27 | Execute G3-P1/P2/P3/P4 | 18–20, 24, passed 26 | discovery/session/cursor/generation/current-previous evidence | exact recall; no mix; all discontinuities correct; unsupported fails closed | any controlled recall miss/extra/mix/conflict |
| 28 | Run all-sink canary, dependency, reproducibility, and cleanup gates | 25–27 plus Batch 01 build controls | release evidence bundle | every positive control detected; exact binaries; no residue | any scanner miss, provenance gap, unexplained build difference |
| 29 | Aggregate `g2-g3-gate.json` and predecessor review | 1–28 | machine-readable gate, human review record, residual risk | zero primary failures; owners/ADRs/evidence current; no expired exception | do not self-authorize live collection |
| 30 | Hand off accepted source/cursor contracts to G4 and G5 | passed 29 | fixed minimized candidate/progress contracts and failpoint list | G4 can narrow only; G5 proves atomic crash boundary | no live upload/pilot until G4/G5 and later gates pass |
| 31 | Establish recurring Edge candidate compatibility lane | 23, 27–29 | current/previous/candidate image pipeline and runbook | every supported candidate reruns capability/zero-write/cursor/impact before policy | version auto-authorized without evidence |

## 13.2 Dependency and parallelism rules

- Source-state pure models, fixture/oracle work, native API spike, and disconnected lab preparation may proceed in parallel after Batch 01 contracts exist.
- Root discovery may be implemented with synthetic roots while the native SQLite package decision is pending.
- Live Edge file access cannot begin until G1 hostile isolation, G0 canary/oracle, strict contracts, fixed Task Host capability, privacy permit skeleton, and zero-write tracing are in place.
- G3 model tests may run before G2, but G3 live profile/session claims do not pass until G2 source safety passes.
- G4 may define the exact site/domain transformation in parallel, but no live raw URL may cross Task Host output and no live event is authorized until G2/G3/G4 gates all pass.
- G5 may scaffold endpoint-store failpoints, but no crash-durability claim is accepted until the G2/G3 page contract is frozen.
- Disk scratch, VSS, browser extension, DevTools collection, custom roots, path/process matching, and session attribution are not parallel “spikes” under this backlog; each requires a new ADR and authority.

## 13.3 Exact G2/G3 stop/go sequence

1. **GO** for pure contracts/models, T1 fixtures, native API spike, synthetic roots, and disconnected lab scripts.
2. **STOP** before live Edge access until G0/G1 prerequisites and Task Host zero-write instrumentation exist.
3. **GO to G2 lab** only for approved disposable synthetic Edge profiles.
4. **STOP G2** on one source write, raw-source escape, browser corruption/crash attributable to UAM, unbounded lock/resource use, incomplete backup acceptance, cleanup residue, or non-success cursor movement.
5. **GO to G3 live lab** only after G2 passes for the exact Edge/OS/native capability.
6. **STOP G3** on one controlled recall miss/extra, duplicate business effect, profile/session/realm mix, observable replacement accepted into the old generation, timestamp cursor dependency, or identity conflict accepted.
7. **GO to G4/G5 integration** only after the immutable G2/G3 gate binds exact evidence and ADRs.
8. **STOP before pilot/production** until human channel/version/lookback/time/unsupported decisions and all later G4–G12 proof gates pass.

---

# 14. Open-source repository assessment table

**Decision rule.** No repository is a dependency merely because it is open source or popular. A candidate requires exact source/package/binary mapping, license approval, maintained release evidence, tests, security/advisory review, UAM-specific fuzz and fixture results, owner, support/removal plan, and locked promotion. “Reference only” authorizes no source copy or runtime binary.

| Repository, reviewed revision, relevant files | License / compatibility | Maintenance, tests, security posture | Architectural fit and threat-model difference | Reusable ideas / ideas not to copy | Suitability |
|---|---|---|---|---|---|
| [Chromium `src`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/), tag `150.0.7871.187`, root commit `30f6543ae91e6a860e73b76e3216b663b050f4e5`; `components/history/core/browser/visit_database.cc`, `history_types.h`, `history_database.cc`, `url_database.cc`; `chrome/common/pref_names.h`; `sql/statement.cc`; `sql/README.md` | BSD-style root license plus extensive third-party notices; copying isolated code requires notice and transitive review | exact July 2026 tag; very active, massive CI/test/security engineering; source is Chrome, not a support promise for Microsoft Edge | closest schema/semantic evidence for local IDs, sync timing, profile hints, time encoding, and SQL practices; browser owns/writes DB and can change internals at any release | reuse schema concepts and adversarial tests; do **not** copy browser architecture, profile manager, sync model, telemetry, or assume Edge source identity | **Reference only**, load-bearing source evidence; never runtime dependency |
| [SQLite](https://sqlite.org/src/), release `3.53.4`, 24 July 2026, source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`; relevant `src/backup.c`, `src/wal.c`, `src/os_win.c`, C API and public tests | core SQLite is public domain; some ancillary/test assets have separate terms; proprietary TH3 is not available to UAM | exceptionally active official project with public regression/fuzz infrastructure; 3.53.0 fixed a WAL-reset corruption bug, showing exact patch/source ID matters | exact storage engine/API UAM uses; official behavior is necessary but does not prove selected compiled binary, wrapper, filesystem, or UAM configuration | use official Online Backup, WAL, file-control, limits, authorizer, interrupt and tests; do not use private/undocumented file-format parsing or assume provider package equals current native | **Runtime native candidate** only through admitted exact binary/build; official docs are normative reference |
| [dotnet/efcore](https://github.com/dotnet/efcore/tree/v10.0.10/src/Microsoft.Data.Sqlite.Core), tag `v10.0.10`, release commit `db55508` (verified release 15 July 2026); `src/Microsoft.Data.Sqlite.Core/`, `test/Microsoft.Data.Sqlite.Tests/` | MIT; package transitives and selected native SQLite/provider are separate license/provenance decisions | Microsoft-maintained, active release/test process; Core package intentionally includes no native SQLite binary; public issue history shows native dependency/version lag must be monitored | useful managed connection/command/reader layer and .NET alignment; G2 needs lower-level db-config/file-control/backup APIs that may require SQLitePCLRaw/direct interop | reuse parameterization, SafeHandle patterns and managed tests; do not use EF ORM/migrations/change tracking or assume Core package hardens native access | **Managed-layer candidate after spike**; not sufficient alone |
| [ericsink/SQLitePCL.raw](https://github.com/ericsink/SQLitePCL.raw), NuGet `SQLitePCLRaw.core 3.0.5`, repository head observed at commit `ed04611` (“chg version to 3.0.5”); `src/`, `gen_providers/`, `test_nupkgs/`, `v3.md` | Apache-2.0; native `SourceGear.sqlite3` is separate; encryption builds/support may be commercial and SEE is proprietary | active maintainer who is also on SQLite core; v3 packaging current in 2026; tests/package projects exist; no UAM-specific security audit; exact 3.0.5 package-to-full-source-commit mapping was not established by this review | exposes low-level C APIs needed by G2 and separates provider/native selection; broad raw API intentionally makes unsafe use possible | reuse narrow provider abstraction and explicit native initialization; do not expose `raw` broadly, bundle an unidentified native library, or accept package version without loaded source ID | **NO-GO until exact package/source/binary mapping and required API tests; then runtime candidate** |
| [SeleniumHQ/selenium](https://github.com/SeleniumHQ/selenium/tree/selenium-4.46.0), tag `selenium-4.46.0`, release commit `df5a634`, 11 July 2026; `dotnet/src/webdriver/`, `dotnet/test/common/`, test web server | Apache-2.0; Microsoft Edge WebDriver binary/Edge terms and exact binary provenance are separate | active verified release with broad multi-language tests and security-related fixes; release includes .NET fixture work and path-traversal hardening; no proof of UAM browser-impact fidelity | good for repeatable localhost visit generation and timing; automation changes browser behavior and is not production acquisition | reuse deterministic navigation/test-server/driver lifecycle patterns; do not use Selenium Manager network downloads, Grid, BiDi/CDP collection, or driver telemetry in UAM evidence | **Test-only candidate**, pinned/offline with matching Edge driver; preferred over carrying two automation stacks |
| [microsoft/playwright](https://github.com/microsoft/playwright/tree/v1.62.1), tag `v1.62.1`, release commit `26a9e47`, 30 July 2026; `packages/playwright-core/`, `tests/`, browser launch/fixture code | Apache-2.0; bundled browser downloads and Node dependency graph add separate provenance/license surface | very active, verified releases and large cross-browser test suite/security policy; v1.62.1 immediately fixed v1.62 regressions, showing fast churn | strong alternative for fixtures, traces, contexts, and localhost automation; heavier Node/browser-download surface than the C# Selenium lane | reuse fixture isolation and trace concepts; do not download bundled Chromium, use production CDP, or add a second framework without measured benefit | **Test-only alternative/reference**; choose Selenium **or** Playwright after a small bake-off, not both by default |
| [browser-history/browser-history](https://github.com/browser-history/browser-history/tree/v0.5.0), tag `v0.5.0`, release commit `943dd5e`, 28 December 2025; `browser_history/browsers/`, `browser_history/generic.py`, `tests/` | Apache-2.0 | maintained release with platform/bookmark tests and Dependabot; repository showed no established dedicated security posture in the reviewed UI | simple cross-browser/profile discovery and history extraction, but deliberately supports broad “all browsers” crawling and returns raw timestamp/URL/title data | reuse fixture/profile edge-case ideas and differential-test cases; do not copy broad discovery, raw export, path defaults, or Python runtime architecture | **Reference only; not a dependency** |
| [RyanDFIR/hindsight](https://github.com/RyanDFIR/hindsight/tree/v2026.06), tag `v2026.06`, release commit `25bfb16`, 8 July 2026; `pyhindsight/`, browser/artifact parsers, output plugins/tests | Apache-2.0 | actively maintained forensic project; 2026 releases add Firefox, sync, variants and many artifact families; broad parser surface and plugins increase attack/dependency scope | useful independent parser/reference for synthetic differential checks; forensic goal is to recover and enrich broad/deleted artifacts—the opposite of UAM minimization | reuse synthetic schema-change test ideas and parser-differential warnings; do not use deleted-data recovery, plugins, broad artifact parsing, rich output, account/profile enrichment, or runtime code | **Reference-only differential challenger; neither runtime nor oracle authority** |

## 14.1 Dependency recommendation

**RECOMMENDATION.** Implement a very small UAM-owned native SQLite adapter interface. Compare:

1. `Microsoft.Data.Sqlite.Core` for ordinary fixed query/reader handling plus narrow SQLitePCLRaw/direct native calls for missing hardening/file-control/backup functions; and
2. a direct generated P/Invoke layer against one exact admitted SQLite binary.

Select the option with the smaller verified API and dependency surface after E-G23-00/E-G23-03. Do not use EF Core. Do not accept a batteries-included bundle without proving the loaded native binary/source ID. A commercial native feed/support agreement may improve patch latency and accountability, but licensing, budget, procurement, offline distribution, and incident support are **HUMAN DECISION** matters.

For fixture automation, use one pinned test-only stack. Selenium .NET is the initial fit because the accepted implementation family is C#/.NET and Microsoft documents Edge WebDriver version matching; Playwright is a credible alternative if its trace/isolation value outweighs Node/browser-package cost. Neither belongs on endpoints.


---

# 15. Source register with stable links, source/release dates, reviewed versions/commits, claim supported, and limitations

## 15.1 Allowlisted project evidence

Only the six project files named in the prompt were used. No other Project file was opened, searched, summarized, quoted, or substituted.

| Ref | Allowlisted project source | Date/status and reviewed digest | Claim supported in this result | Limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | baseline dated 31 July 2026; SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | three-context endpoint topology; user-session source reads; minimization before Coordinator IPC/storage/log/transport; atomic event/progress invariant; Edge site/domain first slice; realm and release invariants | working implementation baseline, not production, legal, privacy, support, budget, or runtime proof |
| I02 | `01-existing-system-evidence-summary.md` | sanitized summary reviewed 31 July 2026; SHA-256 `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | the legacy agent is monolithic, collection is user/profile/session dependent, browser collection exists, and legacy checkpoints/deferred behavior need replacement | static and redacted evidence cannot prove dynamic SQL, runtime settings, profile semantics, rates, data quality, or desired target behavior |
| I03 | `03-sanitized-windows-lab-capability.md` | capability inspection dated 31 July 2026; SHA-256 `8da73d913e7f1b01d943e4c8b0ed7bb2722571ff6a3a20cef0b8f47738a4658f` | an approved Windows VM connection path can exist and CLI work must use placeholders and sanitized evidence | proves no OS, Edge, profile, RDS/VDI, filesystem, EDR, runtime, or permission capability; no connection was made |
| I04 | `05-decisions-contradictions-and-gates.md` | July 2026 accepted synthesis; SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | G2 precedes G3; browser acquisition is short read-only attempt, Online Backup fallback, then defer; never raw-copy live main/WAL/SHM files | implementation-research gate order, not runtime proof or production approval |
| I05 | `06-research-evidence-rules.md` | reviewed 31 July 2026; SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | required evidence labels, primary-source preference, human-authority boundary, conflict handling, and CLI-proof discipline | governs research quality; it is not technical evidence that a proposed design works |
| I06 | `batch-01-review-result.md` supplied as `batch-01-review-result(3).md` | review dated 31 July 2026; status `ACCEPT WITH MANDATORY CONDITIONS`; local SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted strict contracts, UUIDv7, G0 oracle/canaries, G1 session isolation, Coordinator `RunIntent` plus User Host permit, fixed Task Host, privacy lattice, repository/CI boundaries, and ordered stop gates | predecessor decisions are conditional on their own ADRs, owners, and CLI evidence; no permission for live Edge collection or production use |

**Conflict result.** No supplied primary evidence requires changing an accepted predecessor decision. This result narrows and implements the accepted G2/G3 direction. It does not silently move minimization back to the User Host: raw URL and exact source time are confined to fixed Task Host memory, and only minimized rows may leave that process.

## 15.2 Primary public source register

The research date is **31 July 2026**. “Reviewed” means the page or immutable revision was inspected on that date; it does not imply a vendor support commitment to UAM.

| Ref | Primary source and stable link | Source/release date and reviewed version/commit | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| S01 | Microsoft, [Edge Stable and Extended Stable release notes](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel) | latest reviewed official Stable note: `150.0.4078.105`, 27 July 2026; page updated 27 July 2026 | exact Edge Stable build current in the official release-note page at the research cutoff; releases are patched progressively | release notes do not document the History database contract, profile identity, or safe third-party reads; a later staged rollout/build may exist after the cutoff |
| S02 | Microsoft, [Overview of Microsoft Edge channels](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-channels) | reviewed 31 July 2026 | Stable, Extended Stable, and Beta are supported channels; Dev and Canary are not; Extended Stable is an update option for Stable rather than a separate application | channel support does not approve UAM support, and “supported by Microsoft” does not make browser storage a public API |
| S03 | Microsoft, [Microsoft Edge release schedule](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-release-schedule) | reviewed 31 July 2026; schedule states Stable version 152 begins a two-week major cadence | browser compatibility must be a recurring gate rather than an annual migration task | dates are explicitly approximate and can change with build status; a schedule is not an installed-estate inventory |
| S04 | Microsoft, [`UserDataDir` policy](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies/userdatadir) | page updated 22 May 2026; reviewed 31 July 2026 | mandatory policy is supported, requires restart, is not per-profile, and overrides `--user-data-dir`; without it a user can use the command-line override | reading configured policy does not prove that a running browser has restarted onto that root; UAM must bind the actual directory/file identity |
| S05 | Microsoft, [Create Edge user-data-directory variables](https://learn.microsoft.com/en-us/deployedge/edge-learnmore-create-user-directory-vars) | reviewed 31 July 2026 | network paths are unsupported and may cause hangs/crashes/corruption; `${client_name}` and `${session_name}` can distinguish simultaneous remote sessions | variable expansion and environment behavior still require exact-session lab tests; page does not establish filesystem identity or locking semantics |
| S06 | Microsoft, [DevTools MCP documentation—default Edge channel user-data directories](https://learn.microsoft.com/en-us/microsoft-edge/web-platform/devtools-mcp-server#user-data-directory-for-each-edge-channel) | reviewed 31 July 2026 | documented Windows defaults for Stable, Beta, Dev, and Canary, with an explicit warning that paths can vary by configuration/version/policy | documentation is for developer tooling and remote debugging, not a supported history-acquisition interface; UAM uses only the default-root facts |
| S07 | Microsoft, [Use WebDriver to automate Microsoft Edge](https://learn.microsoft.com/en-us/microsoft-edge/webdriver/) | page updated 20 June 2025; reviewed 31 July 2026 | EdgeDriver's first three version components must match Edge; Selenium 4 is required if Selenium is used | WebDriver is a fixture/impact tool only; it can change timing and browser behavior and cannot prove real-user workload impact |
| S08 | Chromium, [source tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/) and [root license](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/LICENSE) | immutable tag reviewed; root revision `30f6543ae91e6a860e73b76e3216b663b050f4e5`, authored 22 July 2026 | fixed point-in-time source for current Chromium history/profile/SQL implementation evidence | Chromium tag/build numbering differs from Edge `150.0.4078.105`; Edge may patch, configure, or diverge. Capability fixtures, not tag similarity, decide UAM support |
| S09 | Chromium, [`visit_database.cc` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/components/history/core/browser/visit_database.cc) | blob `73bd519289c2dda2f24c8adb7c9ed6904e75f524`; reviewed 31 July 2026 | `visits.id` is `INTEGER PRIMARY KEY AUTOINCREMENT`; the comment explains non-reuse is required for Sync; redirects can share timestamps | internal implementation, not Edge public API; future schema, sync, or migration behavior can change without notice |
| S10 | Chromium, [`history_types.h` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/components/history/core/browser/history_types.h) | immutable tag reviewed 31 July 2026 | `VisitID` is the local `visits.id`; a higher local ID does not imply a newer visit because older synced visits can arrive later; local IDs have no cross-device meaning | supports an ID cursor only within one observed database generation; it does not authorize central exposure of native IDs |
| S11 | Chromium, [`history_database.cc` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/components/history/core/browser/history_database.cc) | immutable tag; current internal version `70`, compatible version `16`, minimum migration version `15` | browser metadata/version is useful diagnostic input and proves internals evolve | UAM must not treat one version number as a compatibility API or run Chromium migrations; required tables/columns/types/indexes/query plans are detected directly |
| S12 | Chromium, [`url_database.cc` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/components/history/core/browser/url_database.cc) | immutable tag reviewed 31 July 2026 | `urls.id` uses AUTOINCREMENT for sync/non-reuse and the URL is stored in the URL table joined by `visits.url` | UAM reads only the minimum URL column needed for immediate minimization; title and other URL metadata remain forbidden |
| S13 | Chromium, [`sql/statement.cc` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/sql/statement.cc) | immutable tag reviewed 31 July 2026 | Chromium stores `base::Time` as microseconds since the Windows epoch | source-time conversion still needs checked arithmetic, fixture vectors, approved precision/coarsening, and no cursor dependence on time |
| S14 | Chromium, [`chrome/common/pref_names.h` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/chrome/common/pref_names.h) | immutable tag reviewed 31 July 2026 | names current profile hint keys including `profile.last_used`, `profile.last_active_profiles`, `profile.info_cache`, and deleted basenames | these are internal, privacy-bearing hints, not authority; parser must be bounded and direct-child/file capability checks remain decisive |
| S15 | Chromium, [`sql/README.md` at tag `150.0.7871.187`](https://chromium.googlesource.com/chromium/src/+/refs/tags/150.0.7871.187/sql/README.md) | immutable tag reviewed 31 July 2026 | explicit selected columns, parameter binding, and `ORDER BY` for multirow queries are Chromium's own SQL guidance | style guidance does not prove UAM query cost or index selection; `EXPLAIN QUERY PLAN` and controlled large fixtures are required |
| S16 | SQLite, [Release history](https://sqlite.org/changes.html) | `3.53.4`, 24 July 2026; source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | exact current reviewed SQLite release/source ID; release history also records the WAL-reset corruption fix introduced in `3.53.0` | managed package version does not prove the native binary loaded at runtime; exact source ID and compile options must be evidence |
| S17 | SQLite, [Write-Ahead Logging](https://sqlite.org/wal.html) | official documentation reviewed 31 July 2026 | WAL permits readers and a writer concurrently but still has locking, read-only, shared-memory, checkpoint, and recovery conditions | capability does not prove Edge impact or UAM zero-write behavior on Windows/EDR/filesystem variants |
| S18 | SQLite, [Backup API overview](https://sqlite.org/backup.html) and [Online Backup C API](https://sqlite.org/c3ref/backup_finish.html) | official API documentation reviewed 31 July 2026 | backup can copy a live source consistently in bounded steps; `BUSY`/`LOCKED`, source modification restarts, fatal errors, and mandatory `finish` cleanup are explicit | UAM must bound steps, restarts, memory, cancellation, and browser impact; an incomplete or failed destination is never queryable evidence |
| S19 | SQLite, [URI filenames](https://sqlite.org/uri.html) | reviewed 31 July 2026 | `mode=ro` is available; `immutable=1` and `nolock=1` have dangerous correctness conditions when a file can change or locking is required | URI flags are not a substitute for Windows handle identity, SQLite read-only verification, authorizer controls, or tracing |
| S20 | SQLite, [Database connection configuration options](https://sqlite.org/c3ref/c_dbconfig_defensive.html) | reviewed 31 July 2026 against admitted runtime candidate | documents `DEFENSIVE`, `TRUSTED_SCHEMA`, load-extension, trigger/view, DQS, ATTACH create/write, and `NO_CKPT_ON_CLOSE` controls | availability depends on the exact compiled SQLite; UAM must set, read back where possible, and fail closed if a required control is absent or ignored |
| S21 | SQLite, [standard file-control opcodes](https://sqlite.org/c3ref/c_fcntl_begin_atomic_write.html) | reviewed 31 July 2026 | `SQLITE_FCNTL_WIN32_GET_HANDLE` can expose the Windows handle for the actual database file and `SQLITE_FCNTL_HAS_MOVED` can detect a moved/replaced file | file controls are VFS/platform dependent and need exact Windows/native tests; they do not make file identity permanent |
| S22 | SQLite, [Transactions](https://sqlite.org/lang_transaction.html) and [AUTOINCREMENT](https://sqlite.org/autoinc.html) | transaction page updated 18 February 2026; AUTOINCREMENT page updated 22 February 2024 | a read transaction sees a stable snapshot; AUTOINCREMENT prevents committed row-ID reuse, uses `sqlite_sequence`, permits gaps, and does not imply contiguous IDs | browser replacement/copy/rollback can still reset the lineage; deleted rows are absent and cannot be reconstructed by the cursor |
| S23 | SQLite, [PRAGMA documentation](https://sqlite.org/pragma.html), [limits](https://sqlite.org/limits.html), and [authorizer API](https://sqlite.org/c3ref/set_authorizer.html) | reviewed 31 July 2026 | schema introspection, `query_only`, memory temp store, runtime limits, and an authorization callback are available; unknown PRAGMAs may be silently ignored | `query_only` alone is insufficient and a typo can be silent; UAM uses fixed C APIs/read-back and treats the authorizer as defense in depth, not sole proof |
| S24 | SQLite, [`sqlite3_interrupt`](https://sqlite.org/c3ref/interrupt.html) and [progress handler](https://sqlite.org/c3ref/progress_handler.html) | reviewed 31 July 2026 | long operations can be cooperatively bounded/cancelled | cancellation is not instantaneous at every instruction and must be combined with Task Host process/job termination and cleanup evidence |
| S25 | SQLite, [Copyright and public-domain dedication](https://sqlite.org/copyright.html) | reviewed 31 July 2026 | SQLite core is dedicated to the public domain; optional commercial warranty/support is separately available | ancillary tools/tests and redistributed binaries still require provenance review; license status is not security/support fitness |
| S26 | Microsoft, [`FILE_ID_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-file_id_info) | Microsoft Learn page reviewed 31 July 2026 | Windows exposes a volume serial number and 128-bit file ID for a handle | identifiers can be unavailable on unsupported filesystems and are not guaranteed eternal after deletion/reuse; UAM adds generation witnesses and keyed local digests |
| S27 | Microsoft, [`CreateFileW`](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew) | reviewed 31 July 2026 | exact access/share flags, directory handles, reparse-point handling, and open-existing behavior can be controlled | desired flags can be blocked or behave differently under filesystem/EDR policy; final-path/file-ID checks and lab evidence remain mandatory |
| S28 | Microsoft Sysinternals, [Process Monitor](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon) | version `4.04`, 17 June 2026 | per-process filesystem, registry, process, and thread tracing is available for a zero-write campaign | a trace tool can miss activity if configured incorrectly or disrupted; positive-control writes and a second evidence source should challenge it |
| S29 | Microsoft, [Mandatory Integrity Control](https://learn.microsoft.com/en-us/windows/win32/secauthz/mandatory-integrity-control) | reviewed 31 July 2026 | integrity labels can restrict write-up behavior and contribute to Task Host write containment | MIC is not a complete sandbox and can break runtime/scratch dependencies; effective token/access tests decide whether the profile is usable |
| S30 | IETF/RFC Editor, [RFC 9562—UUIDs](https://www.rfc-editor.org/rfc/rfc9562.html) | May 2024 | UUIDv7 structure and canonical standards basis for UAM-owned source/generation/run IDs | UUID time bits are not browser event time, source order, authorization, or forensic truth |
| S31 | Microsoft/dotnet, [`Microsoft.Data.Sqlite.Core` at EF Core `v10.0.10`](https://github.com/dotnet/efcore/tree/v10.0.10/src/Microsoft.Data.Sqlite.Core), [release](https://github.com/dotnet/efcore/releases/tag/v10.0.10), and [NuGet package](https://www.nuget.org/packages/Microsoft.Data.Sqlite.Core/10.0.10) | release 15 July 2026, commit `db55508`; NuGet `10.0.10` updated 14 July 2026 | maintained C# ADO.NET layer aligned to the accepted implementation family; Core deliberately does not bundle a native SQLite binary | it does not expose/prove every required hardening, file-control, backup, or loaded-native property; no ORM or implicit native bundle is accepted |
| S32 | Eric Sink/SourceGear, [SQLitePCLRaw repository at commit `ed046114d5a30534e13294d94d78eb73de896ad4`](https://github.com/ericsink/SQLitePCL.raw/tree/ed046114d5a30534e13294d94d78eb73de896ad4) and [NuGet `SQLitePCLRaw.core 3.0.5`](https://www.nuget.org/packages/SQLitePCLRaw.core/3.0.5) | package updated 27 July 2026; repository commit message records the `3.0.5` version | low-level access can expose the C APIs UAM requires and separates provider/native selection | this review did not prove a complete package-to-source-to-native-binary chain; broad raw APIs increase misuse risk. **No-go until mapping, API, binary, license, and security gates pass** |
| S33 | SeleniumHQ, [Selenium tag `selenium-4.46.0`](https://github.com/SeleniumHQ/selenium/tree/selenium-4.46.0) and [release list](https://github.com/SeleniumHQ/selenium/releases) | released 11 July 2026, signed commit `df5a634` | actively maintained cross-browser automation with .NET bindings for deterministic localhost visit and timing fixtures | test-only; Selenium Manager downloads, Grid, remote endpoints, BiDi/CDP collection, and telemetry are disabled in the evidence lane |
| S34 | Microsoft, [Playwright tag `v1.62.1`](https://github.com/microsoft/playwright/tree/v1.62.1) and [release](https://github.com/microsoft/playwright/releases/tag/v1.62.1) | released 30 July 2026, signed commit `26a9e47`; patch fixed `1.62` regressions | credible fixture/trace/isolation alternative and evidence of active maintenance | Node/browser-download supply chain is larger; select it only if a measured bake-off beats the simpler Selenium .NET lane, and never install it on endpoints |
| S35 | browser-history, [tag `v0.5.0`](https://github.com/browser-history/browser-history/tree/v0.5.0) and [release](https://github.com/browser-history/browser-history/releases/tag/v0.5.0) | released 28 December 2025, signed commit `943dd5e` | maintained browser/profile reader useful for independent fixture and discovery edge-case ideas | broad crawling and raw URL/title export conflict with UAM minimization/session/root rules; reference only, not dependency or oracle |
| S36 | RyanDFIR, [Hindsight tag `v2026.06`](https://github.com/RyanDFIR/hindsight/tree/v2026.06) and [release](https://github.com/RyanDFIR/hindsight/releases/tag/v2026.06) | released 8 July 2026, signed commit `25bfb16` | actively maintained independent forensic parser useful as a differential challenger for synthetic fixtures and schema changes | deliberately recovers/correlates many raw, deleted, account, extension, cookie, storage, and other artifacts; threat model is opposite to UAM minimization. Reference only |

## 15.3 Evidence-quality resolution and freshness rules

1. **FACT.** Microsoft Edge documentation is authoritative for Edge channel support, policy behavior, and documented roots. It does not publish a stable History database API.
2. **FACT.** Chromium source is the strongest available primary evidence for current history schema intent and visit-ID semantics, but Microsoft Edge is a different product/build. The Edge fixture gate overrides any inference from a Chromium tag.
3. **FACT.** SQLite documents the capabilities used by the design. **CLI EXPERIMENT.** Only the exact loaded native binary, compile options, provider/VFS, Windows filesystem, and UAM configuration can prove those controls exist and behave safely.
4. **FACT.** Windows documents handle/file-identity and integrity primitives. **CLI EXPERIMENT.** Enterprise GPO, EDR, RDS/VDI, redirected storage, and filesystem variants can materially change fitness.
5. **RECOMMENDATION.** Every Edge candidate that enters a supported ring MUST rerun schema capability, query-plan, zero-write, lock/backup, cursor, profile/session, and browser-impact tests. Matching a major version or internal schema version never auto-authorizes collection.
6. **RECOMMENDATION.** Point-in-time dependency versions in this register are evidence of what was reviewed, not timeless architecture. Adoption requires an exact lock, binary/source mapping, license decision, advisory check, reproducible build evidence, SBOM/provenance reconciliation, and a removal/support plan.
7. **UNKNOWN.** No approved estate inventory establishes which Edge channels, OS builds, profile technologies, filesystems, RDS/VDI products, policy roots, sync states, or native SQLite binaries exist in production. This result makes no prevalence claim.
8. **UNKNOWN.** Research cannot prove that a future browser release will preserve `visits.id`, `visit_time`, table names, column meanings, WAL behavior, profile hints, or file layout. Fail-closed capability detection and recurring fixtures contain that uncertainty.

---

# 16. Confidence table for every major conclusion

Confidence is qualitative and evidence-based. It does not represent a probability or production risk acceptance.

| Major conclusion | Confidence | Why | Evidence that would lower, raise, or change it |
|---|---|---|---|
| The Coordinator must not crawl Edge roots or open user-owned browser files | **High** | accepted predecessor security/privacy boundary; user-session ownership is explicit and avoids service-created user authority | only a formally reviewed baseline change with stronger Windows evidence and a smaller privacy/attack surface could change it |
| User Host discovery must be bounded to release-owned default/mandatory-policy roots and direct children | **High** | supports multi-profile use without a home-directory crawl; Edge documents roots and managed override; arbitrary paths are unnecessary for the first slice | a supported profile technology that cannot be represented by a bounded root kind, plus a safe falsifying prototype and human support decision |
| Edge Stable default and mandatory local `UserDataDir` are the smallest initial root families | **Medium-High** | documented and sufficient for the first slice; Extended Stable shares the Stable application; policy override is enterprise-manageable | approved estate inventory showing another required root or policy behavior; lab evidence that effective root cannot be determined safely |
| Dev, Canary, command-line-only custom roots, UNC/network roots, arbitrary tenant paths, and WebView2 should remain off | **High** | unsupported channel/root or materially different discovery/locking/ownership; enabling them increases ambiguity and privacy surface | separate human support decision, primary documentation, exact capability design, zero-write/cursor/profile tests, and an ADR with containment |
| `Local State` profile keys are hints, not authority | **High** | current Chromium source labels them preferences/cache and they may contain profile metadata; physical direct-child/file capability is stronger | a documented Edge API with stable identifiers and privacy-safe semantics could supersede the hint parser |
| One UAM source lineage should represent one physical profile directory within a realm/installation | **High** | path/name/SID/session are mutable or non-unique; stable UAM identity preserves history across rename while preventing cross-realm authority | file-identity lab failures that make directory lineage unknowable would force unsupported status or a new approved identity mechanism |
| Installation-keyed HMAC locator digests are preferable to persisting paths/raw file IDs | **Medium-High** | they minimize local identity material, prevent cross-install correlation, and preserve equality within one installation | key-management or collision/rotation evidence showing the scheme cannot maintain continuity; a platform opaque identifier with stronger lifecycle guarantees |
| Windows file identity is necessary but insufficient for generation continuity | **High** | FILE_ID_INFO is stronger than a path but deletion/reuse/replacement and unsupported filesystems remain; capability/cursor/overlap witnesses add independent checks | platform evidence giving stronger immutable file incarnation identity, or lab evidence that FILE_ID_INFO is unavailable on an approved support class |
| Same physical source discovered by concurrent sessions must have one Coordinator lease and one reader | **High as a design invariant; Medium until lab proof** | prevents duplicate reads, races, mixed progress, and false session attribution | G1/G3 same-SID RDS/VDI campaign showing lease/identity cannot be enforced safely; then shared-root profiles become unsupported |
| UAM must not claim originating session for visits in a profile shared by concurrent sessions | **High** | the database records visits, not a reliable UAM session provenance relation; acquisition session is not activity session | a documented, approved browser field/source contract that reliably binds each visit to an authenticated session without expanding privacy scope |
| A short read-only SQLite transaction is the simplest first acquisition path | **Medium-High** | SQLite snapshots are documented; it avoids copying and extra memory when the browser permits it; fixed PK-range query is small | G2 impact/lock tests showing unacceptable browser interference, persistent `BUSY`, or a provider/VFS that cannot prove zero writes |
| SQLite Online Backup to private memory is the correct bounded fallback | **High for documented capability; Medium-High for UAM fitness** | official API handles live sources consistently and avoids unsafe main/WAL/SHM copying; memory removes raw disk residue | backup restart/lock/impact/memory tests failing on supported Edge/OS/native combinations, or a simpler supported snapshot API becoming available |
| Failed, busy, locked, unsupported, corrupt, cancelled, moved, conflicted, or cleanup-failed acquisition must defer without progress | **High** | direct consequence of the non-negotiable cursor-ahead invariant and primary prompt gate | no evidence should weaken it; inability to meet it stops the capability rather than changes the rule |
| Raw main/WAL/SHM copying, `immutable=1`, `nolock=1`, VSS, stopping Edge, extensions, and DevTools collection are wrong defaults | **High** | raw copy can be inconsistent; URI flags bypass correctness assumptions; alternatives add privilege, user impact, network/control, or broader collection surfaces | only a separately authorized source contract and falsifying safety/impact/privacy experiment could admit an alternative; none is justified now |
| Disk scratch should be absent by default; in-memory backup is the initial design | **High** | avoids durable raw browser data, ACL/encryption/deletion complexity, and forensic-remanence claims | measured large-profile memory failures plus a human-approved encrypted-scratch ADR, key design, ACL/MIC proof, cleanup drill, and retention decision |
| Read-only proof requires open flags, `mode=ro`, `db_readonly`, db-config hardening, authorizer, statement checks, handle identity, moved check, and filesystem tracing together | **High** | no single control proves zero writes or correct source binding; layered independent checks contain wrapper/native/SQL/config errors | a platform-supported immutable snapshot API could simplify the set, but zero-write tracing and positive controls would remain |
| Required SQLite controls must be verified against the actual loaded native source ID and compile options | **High** | wrapper/package version can differ from native binary; recent SQLite correctness fixes show patch identity matters | a hermetic UAM-owned native build with reproducible subject/provenance can reduce runtime discovery but not remove the evidence requirement |
| Schema support must be capability-based, not browser version or internal DB version alone | **High** | browser internals are not a public API; required tables/columns/types/PK/index/plan can be tested directly | an official stable Edge history-read API/schema with explicit compatibility guarantees could replace internal capability probing |
| Current and previous approved Edge builds need generated browser fixtures plus handcrafted adversarial SQLite fixtures | **High** | browser fixtures prove real writer output; handcrafted fixtures force rare regression/replacement/corruption/late-sync cases deterministically | fixture-generation inability under enterprise policy or evidence that a candidate build cannot be preserved/reproduced would require another controlled fixture method |
| `visits.id` is the correct native progress cursor within one generation | **High for current Chromium semantics; Medium-High across future Edge releases** | current source defines local AUTOINCREMENT non-reuse and explicitly warns ID is not event time; PK-range query is deterministic | an Edge candidate where required AUTOINCREMENT/PK semantics or query plan disappear; capability then fails and a new adapter/ADR is required |
| `visit_time` must never drive cursor order | **High** | sync can insert old-time visits with higher local IDs; equal timestamps exist; clocks/DST/sleep do not define row insertion lineage | no expected evidence would justify a time-only cursor; an official immutable change stream with its own sequence could replace native ID |
| Same timestamps and late synchronization are handled by ID order, not timestamp tie-breaking | **High** | direct current Chromium evidence; deterministic event identity includes generation/native ID | candidate fixture showing rows can be inserted with an already-used local ID within the same unchanged generation would trigger a generation/conflict redesign |
| Deletions create gaps and do not cause rewind or inferred deletion events | **High** | deleted rows are absent; AUTOINCREMENT allows gaps; UAM cannot prove when/why a deletion occurred from a later read | a separately approved browser deletion feed with stable semantics and privacy purpose could add deletion facts; it is outside this source contract |
| `MAX(id)` plus `sqlite_sequence` and overlap witnesses are useful generation/discontinuity evidence | **Medium-High** | combines current rows, historical allocation high-water, and recent minimized row consistency | lab false positives/negatives under Edge migration, restore, copy, sync, or explicit sequence manipulation; witness rules and thresholds may need revision |
| A bounded ID overlap is a conflict detector, not the primary recall mechanism | **High** | new rows are found by `id > checkpoint`; overlap detects changed/reused recent IDs while keeping work bounded | evidence of legitimate mutation to old IDs outside any practical bound would require a different immutable source or generation policy; it cannot be silently accepted |
| Exact overlap count, page size, busy timeout, backup pages/step, retries, memory, and run budgets remain estimates | **High** | no representative metadata-safe distributions, support SLOs, or approved resource budgets exist | approved T3 aggregate measurements and repeated G2/G3 impact campaigns can replace each estimate through a compatibility-aware ADR |
| Deterministic dedupe identity must include realm-bound installation, source, generation, native visit ID, and extractor-contract major | **High** | prevents cross-realm/profile/generation collision and supports at-least-once retries; payload witness detects semantic conflict | a server contract proving an equally strong narrower key, or a migration requiring stable identity across extractor-major change with explicit semantics |
| Same natural key plus different minimized payload is a conflict and must not advance | **High** | accepting one silently would corrupt idempotency and hide source/transform mutation | no normal operation should weaken this; only an explicit corrected-event/versioning model could resolve conflict while preserving evidence |
| Exact browser time must be converted with checked arithmetic then coarsened under approved policy; it is not progress authority | **High for conversion rule; Low for final precision** | source encoding is evidenced; privacy precision is intentionally undecided | human time-precision decision, G4 data contract, boundary vectors, and legal/privacy approval determine final output precision |
| Page events, zero-effect progress facts, overlap witnesses, run outcome, and checkpoint must commit atomically before ACK | **High as architecture; Medium until G5 failpoint proof** | accepted endpoint invariant and deterministic retry design require one local transaction | G5 crash/fault experiments could expose a storage schema/locking flaw; failure stops progress and opens an ADR, not a weaker commit rule |
| Raw URL and exact source time must remain inside Task Host memory; only minimized rows leave | **High** | accepted minimization-before-IPC rule plus fixed risky-collector boundary; reduces blast radius of User Host/Coordinator/storage/logs | a predecessor change proposal with stronger containment could alter process placement, but not the privacy boundary itself |
| Privacy-safe observability must use fixed low-cardinality categories and local opaque tokens only | **High** | paths, profile names, IDs, URLs, SQLite values, and dynamic labels create disclosure/cardinality risk | operational evidence showing a missing diagnostic may add only a bounded release-owned category after privacy review and canary tests |
| Zero source writes must be proved with positive-control filesystem tracing, not inferred from read-only intent | **High** | wrappers, SQLite close/checkpoint behavior, temp files, crash handlers, and dependencies can write despite design intent | a stronger OS-enforced read-only snapshot still requires a trace/positive-control campaign to prove UAM did not reach another write path |
| G2/G3 support is a recurring compatibility cost on each Edge candidate | **High** | Edge cadence is accelerating and browser internals are not stable; schema/plan/native/impact can change independently | an official supported Edge history-read API with a contractual compatibility window could reduce, not eliminate, qualification work |
| Selenium or Playwright may generate T1 visits, but neither is an endpoint dependency or acquisition oracle | **High** | automation is suitable for controlled fixtures but changes browser behavior and adds broad tooling surfaces | a bake-off selects one test stack; neither can become production source authority without a new architecture, which is not recommended |
| Chromium, browser-history, and Hindsight are reference/differential inputs, not runtime dependencies | **High** | license/size/language/threat models and raw forensic/crawling behavior do not fit UAM's fixed minimized capability | a narrowly extracted idea may be reimplemented after license/security review; source copying or dependency adoption requires a separate admission record |
| `Microsoft.Data.Sqlite.Core` plus narrow native calls and direct P/Invoke are both viable candidates, but neither is selected by research prose | **Medium** | maintained managed layer exists; G2 requires APIs below ordinary ADO.NET; exact package/native mapping and API surface remain unproved | E-G23-00/E-G23-03 API, provenance, fuzz, performance, support, and removal evidence will select or reject a candidate |
| Browser-impact guardrails in section 8 are temporary hypotheses, not SLOs | **High** | no approved SLO/budget or representative workload exists | product/operations decision plus repeated controlled and approved metadata-safe estate measurements establish final thresholds |
| This design is not production approval and does not prove 6,000-endpoint cost/capacity | **High** | prompt and predecessor authority boundaries are explicit; G2/G3 are per-source correctness gates, not fleet ingestion/capacity proof | only later capacity, outage, operations, support, legal/privacy, pilot, and production-authority gates can change that status |

## 16.1 Final residual risk and next stop/go gate

Material residual risk remains even if every proposed prototype passes:

- Edge History storage is an internal implementation and can change without a public compatibility contract.
- A row deleted before UAM's first successful read is unknowable; an old row legitimately changed outside the bounded overlap may be detected only by generation/capability evidence or never detected.
- Windows file identifiers are filesystem-scoped and not eternal; replacement, copy, restore, virtualization, profile containers, network redirection, reparse behavior, and EDR can create untested identity/locking cases.
- Same-user processes and browser code remain in the broader user security boundary; Task Host containment limits UAM faults but is not a complete confidentiality sandbox against every same-user actor.
- Native SQLite, provider, VFS, Edge, Windows, automation driver, and tracing-tool defects can create common-mode failures. Exact versions, two evidence methods where feasible, positive controls, and a kill switch contain but cannot eliminate this risk.
- In-memory backup can repeatedly defer on very large or highly active profiles; disk scratch remains unavailable unless humans approve its security, privacy, licensing, support, retention, and cost consequences.
- Browser qualification every supported update is an ongoing engineering and operations cost. Required staffing, candidate-image supply, lab ownership, incident coverage, SLOs, and budget are not approved.
- Supported Edge channels/versions/profile technologies, first-run lookback, output time precision, unsupported-environment behavior, shared-session business semantics, final event fields, and production retention remain **HUMAN DECISION** matters.
- G2/G3 do not prove G4 minimization policy, G5 crash durability, upload custody, central idempotency, fleet capacity, long outage, deletion/restore, or production operations.

**Next stop/go gate:**

1. **GO now** for sections 11 and 13 items covering pure contracts/state models, T1 fixtures/oracle, exact native-API/provenance spike, synthetic root/identity code, architecture tests, and disconnected placeholder-only lab preparation.
2. **STOP before live Edge access** until the Batch 01 G0/G1 prerequisites, fixed Task Host privacy permit, all-sink canaries, zero-write positive-control tracing, exact native self-check, and human-approved disposable lab matrix are present.
3. **GO to G2 live lab** only against approved synthetic Edge profiles. Pass requires: complete controlled recall for the run's declared snapshot; zero source writes; no raw value outside Task Host; no browser corruption/crash attributable to UAM; bounded direct/backup behavior; complete cancellation and cleanup; and no cursor movement on any non-success.
4. **GO to G3 live lab** only for the exact Edge/OS/native capability that passed G2. Pass requires: exact multi-profile/source identity; no cross-profile/session/realm mix; one lease for a shared source; correct removal/recreation/replacement/regression generations; late-sync and equal-time recall; deterministic duplicate behavior; and conflict/defer without progress.
5. **GO to G4/G5 integration** only after an immutable `g2-g3-gate.json` binds the exact source/native/Edge/OS revisions, fixtures, oracle, traces, cleanup, ADRs, owners, and zero primary failures.
6. **STOP immediately** on one source write, controlled recall miss or extra, raw-source escape, cross-boundary mix, accepted identity/payload conflict, replacement/regression folded into the old generation, incomplete backup use, cleanup residue, or any failed/busy/locked/unsupported/corrupt/cancelled run that advances progress. The failure opens the named ADR/change process; it never authorizes a silent weaker fallback.
