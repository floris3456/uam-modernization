# G5 SQLite outbox, batching, receipts, encryption, migrations, and state machines

**Result path:** `results/batch-03-durability-release-identity/09-g5-sqlite-outbox-state-machines-result.md`  
**Research date:** 31 July 2026  
**Decision status:** **RECOMMENDATION — ACCEPT AS THE IMPLEMENTATION BLUEPRINT; G5 REMAINS A CLI/LAB PROOF GATE**  
**Authority boundary:** endpoint-local durability, batching, delivery-attempt and receipt state, payload-at-rest protection, migrations, corruption handling, cleanup, and their tests. This result is **not** approval of legal purpose, fields, retention, endpoint disk budget, maximum offline duration, acknowledgement grace, encryption assurance, device PKI, pilot, production risk, or deployment.  
**Predecessors:** accepted Batch 01 and Batch 02 review results.  
**Primary gate:** **no cursor-ahead state, missing committed event, silent deletion of unacknowledged data, or duplicate final business effect under model checking and fault injection.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed implementation decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, business, risk, support, or production authority is required.
- **CLI EXPERIMENT** — code, a disposable Windows lab, or measurement must establish the claim.

Normative **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** statements define the proposed G5 implementation contract. They do not convert a **HUMAN DECISION** or an unexecuted **CLI EXPERIMENT** into production approval.

## Evidence boundary and file-presence record

**FACT.** All six allowlisted project files were present. The accepted Batch 01 result was supplied under the local attachment name `batch-01-review-result(3).md`; its title and declared result path identify it as the allowlisted `batch-01-review-result.md`. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted file | SHA-256 reviewed | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted endpoint, privacy, durability, receipt, realm, release, restore, and no-silent-loss invariants; not production authority |
| I02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | target concepts and missing volume/retention/RPO evidence; no production rows or rates |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted one-writer/WAL, at-least-once, custody receipt, and ordered G0–G12 gates |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, primary-source standard, human-decision boundary, and change-proposal rules |
| I05 | `batch-01-review-result.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156d29b7cff238ea7d4e128587b47f4c75b` | accepted strict contracts, UUIDv7, process boundaries, privacy permits, repository/release controls, and G1 prerequisites |
| I06 | `batch-02-review-result.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | accepted page-owned progress, source/effect identity, whole-page transaction handoff, no semantic replay, and exact G5 failpoint requirement |

No accepted-baseline change proposal is raised. This result refines the already accepted one-writer SQLite and at-least-once delivery decisions without redesigning the browser source, privacy transform, server inbox, release, or device-identity boundaries.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION — use one realm-bound SQLite database, one long-lived writer actor, immutable encrypted event payloads, immutable sealed upload batches, and explicit delivery/receipt state machines.** A collection page is committed atomically with its source effects, minimized outbox events, page record, witnesses, and cursor. Network activity never occurs inside that transaction. A batch is constructed and sealed once, then every ambiguous retry sends the exact same bytes and batch identity. A matching authenticated server receipt moves the batch to `RECEIPTED`; it does not mean validated, materialized, visible, or integrated.

In plain language:

1. The endpoint first makes the minimized event and cursor safe together.
2. It later groups safe events into a fixed package and stores the exact package before sending.
3. It records that a send may happen before writing to the network.
4. If the reply is lost, it sends the same package again rather than inventing a new one.
5. It deletes payloads only after a matching durable-custody receipt and an approved grace rule.
6. Under disk pressure it pauses new collection before it discards anything not acknowledged.

**Confidence: High for the logical state model; Medium for Windows/filesystem/TPM operational fitness until G5 fault campaigns run.** SQLite documents the required WAL, transaction, checkpoint, integrity, backup, and result-code primitives [W01–W14]. The predecessors already require page-owned atomic progress and at-least-once idempotency [I01, I03, I06]. Documentation does not prove flush fidelity, antivirus behavior, disk-full recovery, TPM availability, or the implementation's state transitions on the supported estate.

## 1.2 Load-bearing decisions

| ID | Conclusion | Classification | Confidence | Why it is load-bearing |
|---|---|---|---|---|
| G5-D01 | one database file per authenticated realm/installation/store epoch | **RECOMMENDATION** | High | makes accidental cross-realm SQL, key reuse, restore, and cleanup substantially harder |
| G5-D02 | one dedicated writer actor owns one connection; pooling is disabled | **RECOMMENDATION** | High | turns SQLite's single-writer reality into an explicit application invariant and simplifies crash proofs |
| G5-D03 | `WAL` + `synchronous=FULL`; application-owned checkpoints | **RECOMMENDATION** | High for semantics, Medium for measured cost | FULL syncs the WAL on each commit; automatic checkpoints can move latency and corruption exposure into foreground commits [W02–W04] |
| G5-D04 | page effects, outbox events, witnesses, run facts, and cursor commit in one `BEGIN IMMEDIATE` transaction | **RECOMMENDATION** | High | directly enforces the accepted no-cursor-ahead invariant |
| G5-D05 | event natural identity excludes collector/interpretation versions; UUIDv7 event ID is minted once and persisted | **FACT / RECOMMENDATION** | High | preserves the accepted Batch 02 identity rule and one final effect under retry [I06, W27] |
| G5-D06 | batch stores exact compressed wire bytes and immutable hashes before any send | **RECOMMENDATION** | High | makes lost-response replay deterministic and auditable |
| G5-D07 | delivery attempt is durably `PREPARED` before socket write | **RECOMMENDATION** | High | after a crash, the endpoint treats custody as uncertain instead of falsely unsent |
| G5-D08 | matching authenticated receipt is the only ordinary acknowledgement transition | **RECOMMENDATION** | High | preserves the accepted custody boundary; HTTP status alone is not deletion authority |
| G5-D09 | application-level AES-256-GCM protects payload columns before SQLite bind; CNG wraps data keys | **RECOMMENDATION** | Medium-High | keeps plaintext payloads out of the main DB, WAL, SHM, backups, and ordinary SQLite diagnostics while avoiding a SQLite fork |
| G5-D10 | TPM-backed wrapping is preferred when proved; software CNG is a supported profile; DPAPI LocalMachine is not high assurance | **RECOMMENDATION** | Medium | TPM estate and machine-key ACL behavior are unknown; DPAPI LocalMachine can be unprotected by other local processes [W19–W23] |
| G5-D11 | expand/contract migrations maintain an explicit N/N-1 rollback window | **RECOMMENDATION** | High | prevents a failed release from converting the store into an unreadable one-way format |
| G5-D12 | no automatic salvage or delete-and-recreate on corruption | **RECOMMENDATION** | High | salvage can omit or invent relationships; silent recreation would misstate delivery and progress [W06, W09] |
| G5-D13 | reserve space and collection pause protect receipt/recovery writes; unacknowledged data is never silently deleted | **RECOMMENDATION / HUMAN DECISION boundary** | High for rule, Low for exact size | preserves I01/I03; exact disk and outage budgets are absent |

## 1.3 Immediate implementation permission and prohibition

**GO** for:

- pure state models, TLA+/equivalent model specifications, DDL, schema verifiers, and T1 fictional fixtures;
- a one-writer C# storage prototype with an in-process synthetic page producer and synthetic receipt server;
- deterministic fault hooks, kill/reboot/disk-full/corruption loops, and value-free evidence collection;
- CNG/TPM/software-provider capability experiments using generated lab-only keys;
- expand/contract migration fixtures across N and N-1 with synthetic stores in every state;
- privacy-safe health, invariant, and support contracts;
- exact dependency/source/native-binary inventory and license review.

**STOP** before:

- live-source integration unless the exact G1–G4 predecessor evidence has passed;
- production-shaped transport unless G5 passes for the exact store/runtime/provider/OS/filesystem/AV capability;
- cleanup of acknowledged payloads until ACK grace and RPO are approved;
- dropping or sampling unacknowledged events under pressure;
- enabling TPM-only or enterprise-recovery behavior without an approved estate/key-recovery decision;
- destructive migration, automatic salvage, store deletion, realm rebinding, or local support export of payloads;
- pilot or production deployment.

## 1.4 Residual risk

Even after G5 passes, SQLite and cryptography cannot eliminate:

- storage hardware or virtualization that falsely reports durable flush completion;
- physical loss of an endpoint since the last verified backup or server receipt;
- local-administrator control of the machine, executable, process memory, or software-backed keys;
- security/management software that captures process memory or blocks/holds database files;
- silent browser deletion before collection or data already absent from the source;
- operator error during key recovery, migration, quarantine, or restore;
- a server receipt implementation whose claimed failure domain is weaker than its contract;
- business harm from wrong purpose, fields, retention, access, or interpretation.

Containment is explicit detection, pause/hold states, immutable evidence, replay, verified restore, server reconciliation, and refusal to infer success. G5 proves the endpoint algorithm under named conditions; it does not prove the entire end-to-end service or approve production risk.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result specifies:

- store layout, one-writer ownership, connection setup, schema, indexes, constraints, and domain verifiers;
- source/generation/checkpoint, page/effect, event, batch, attempt, receipt, run, policy, health, key, migration, backup, quarantine, and cleanup state;
- atomic event-plus-cursor commit and stable identity behavior;
- batch construction, immutable hashes and bytes, send/unknown/retry/receipt/replay/cleanup transitions;
- WAL/FULL/checkpoint/busy/foreign-key/trusted-schema/integrity behavior;
- disk pressure, reserve, quota, priority, pause, shutdown, antivirus interference, corruption, and recovery;
- payload encryption, CNG/DPAPI/TPM wrapping profiles, rotation, metadata leakage, and local-admin limits;
- expand/contract N/N-1 migrations, backup, repair, quarantine, observability, runbooks, and formal invariants;
- exact G5 tests, fault hooks, model checking, CLI evidence, acceptance criteria, backlog, and ADR proposals.

## 2.2 Non-goals

This result does not:

- choose the legal/business purpose, prohibited uses, event fields, identity projection, time precision, lookback, retention, or access;
- reopen the accepted Windows process/session boundary, Edge acquisition, URL minimization, matcher, or whole-page contract;
- design the server relational inbox, semantic processing, portal, integrations, device PKI, release system, or database engine;
- claim that receipt equals validation, materialization, visibility, or integration;
- introduce endpoint SQL submission, a broker, a general plugin/script channel, an autonomous updater, arbitrary local support queries, or raw-data diagnostics;
- promise zero data loss after physical device destruction, storage firmware failure, unrecoverable key loss, or source deletion before observation;
- approve production limits, RPO/RTO/SLO, support staffing, license spend, or deployment.

## 2.3 Accepted inputs preserved

The following accepted decisions are carried forward without change:

| ID | Accepted invariant |
|---|---|
| A-01 | endpoint persistence receives only minimized typed data; forbidden source values never reach the Coordinator store |
| A-02 | one writer in SQLite WAL atomically stores page effects and progress |
| A-03 | the source cursor never advances ahead of durable minimized effects or approved no-event/progress facts |
| A-04 | natural source-record identity is `(realm, installation, source, generation, native_visit_id)` and excludes runtime/interpretation versions |
| A-05 | UUIDv7 `event_id` is minted and durably reused at the first effect commit |
| A-06 | one page owns snapshot high-water and advancement; no row-level cursor authority; whole page or none |
| A-07 | delivery is at least once; stable identity and central uniqueness produce one final business effect |
| A-08 | uploads are bounded, versioned, authenticated, compressed HTTPS batches |
| A-09 | a receipt means durable custody only in the declared server failure domain |
| A-10 | realm/device authority comes from authenticated registration/context, never payload claims |
| A-11 | no component silently deletes unacknowledged data under pressure |
| A-12 | restore cannot lose acknowledged server custody or expose deleted data before readiness |
| A-13 | exact batch, retry, SQLite, resource, encryption, retention, and ACK-grace values remain measured or human-owned |
| A-14 | passing G5 proves only its named claim/environment and cannot waive later release/network/server/capacity/deletion gates |

## 2.4 Assumptions

- **ASSUMPTION.** The Coordinator has already received one structurally valid, minimized, permit-bound page under the Batch 02 contract.
- **ASSUMPTION.** One endpoint installation is active in one realm at a time. A realm change is a hold/migration event, not an in-place rebinding.
- **ASSUMPTION.** The server ingestion boundary will enforce uniqueness for `event_id` and the stable source natural key, and will return an authenticated receipt bound to the batch identity and content hash. G5 uses a faithful synthetic stub; later ingestion work must prove the real boundary.
- **ASSUMPTION.** Enterprise deployment owns protected directories, ACLs, service identity, executable integrity, and machine configuration established by earlier gates.
- **ASSUMPTION.** The exact supported .NET and SQLite native patches are selected at execution time and recorded in evidence; current reviewed versions are not timeless architecture.
- **ASSUMPTION.** Endpoint clocks can be wrong or roll back. Clock uncertainty therefore blocks destructive cleanup but does not invalidate an already authenticated receipt.
- **ASSUMPTION.** A bounded in-memory batch can be created without raw source data because all inputs are already minimized event payloads.

## 2.5 Unknowns and their required disposition

| Unknown | Classification | Consequence now | Resolution |
|---|---|---|---|
| endpoint event/byte/batch/retry/outage distributions | **UNKNOWN** | all count/byte/time values are bootstrap estimates | T1 load plus approved metadata-only measurement |
| maximum offline duration and pause/loss policy | **HUMAN DECISION** | never auto-drop unacknowledged data; pause when full | product/risk/operations decision with outage evidence |
| local data sensitivity and required encryption assurance | **HUMAN DECISION** | prototype uses application encryption; production provider remains disabled/profile-gated | privacy/security/cryptographic authority decision |
| endpoint disk budget | **HUMAN DECISION** | no production quota or reserve size | endpoint product/SRE/operations decision |
| ACK replay grace tied to RPO | **HUMAN DECISION** | production cleanup stays disabled | data owner/records/SRE/risk decision |
| TPM presence, health, algorithm support, ownership, clearing, and VDI behavior | **UNKNOWN** | TPM is optional capability, not mandatory assumption | approved Windows inventory and destructive lab tests |
| actual filesystem/firmware flush behavior | **UNKNOWN** | `FULL` is required but not claimed sufficient | power-cut and VM-host fault campaign on named estate |
| AV/EDR/CFA/filter-driver interference | **UNKNOWN** | failures pause/hold; no automatic exclusions | supported-estate lab campaign and security decision |
| production backup/RPO and recovery custody | **HUMAN DECISION / UNKNOWN** | pre-migration verified backup only; periodic production backup disabled | RPO/RTO, storage, access, key, and restore drill |
| server receipt failure domain and status-query behavior | **UNKNOWN outside G5** | synthetic contract only; no production cleanup | later ingestion proof and contract acceptance |
| production SQLite provider/native package and support arrangement | **HUMAN DECISION / CLI EXPERIMENT** | narrow prototype adapter only | dependency, license, source/binary, advisory, and support review |
| metric cardinality/access/retention budgets | **HUMAN DECISION** | fixed low-cardinality dimensions only | SRE/privacy/data-governance approval |

## 2.6 Conflict handling

No accepted-baseline contradiction was found. If a prototype later shows that the page transaction, pre-send attempt record, immutable replay, or one-writer profile cannot operate without weakening an accepted invariant, work MUST stop and open a change proposal containing: affected decision, new primary evidence, impact, smallest falsifying experiment, alternatives, migration consequence, and ADR action. A local fallback may not silently alter identity, durability, privacy, realm, or receipt meaning.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Logical topology

```text
Fixed Task Host (already minimized page)
        |
        | G1-authenticated, G4-minimized page
        v
User Host validation
        |
        v
Coordinator ingress validator
        |
        | in-process immutable command
        v
+---------------------------------------------------------------+
| EndpointStore writer actor — only SQLite write authority       |
|                                                               |
| Page commit -> Effects + Events + Witness + Cursor             |
| Batch seal -> Immutable membership + exact wire bytes          |
| Attempt prepare -> durable ambiguity before network            |
| Receipt apply -> custody state + ACK links                     |
| Cleanup -> receipt/grace/key/ref predicates only                |
| Migration/backup/checkpoint/integrity -> exclusive maintenance  |
+---------------------------------------------------------------+
        |                         ^
        | exact stored wire body  | authenticated receipt/status
        v                         |
Transport worker ---------- HTTPS ingestion boundary
```

The transport worker has no SQL connection. It requests a prepared attempt and exact body from the writer actor, performs bounded HTTPS I/O, and returns a typed result. The writer owns every durable transition.

## 3.2 Component responsibilities

| Component | MUST do | MUST NOT do |
|---|---|---|
| `EndpointStoreWriter` | own one connection and serialized command queue; validate realm/store/schema; execute all writes, reads needed for decisions, transactions, checkpoints, backup coordination, migration, integrity, and cleanup | expose SQL; permit a second writer; perform network I/O; accept raw source values; silently retry invariant or corruption failures |
| `PageCommitService` | validate one fixed page, compare checkpoint version, insert one effect per returned native row, insert event if applicable, update witnesses/run/page/checkpoint atomically, return stable prior result on retry | advance on defer/hold/cancel; partially commit a page; regenerate committed event IDs; include interpretation in natural key |
| `BatchBuilder` | select ordered READY events; decrypt only in writer memory; build canonical envelope; compress; hash; encrypt exact wire bytes at rest; atomically insert sealed batch/items and mark events BATCHED | call network; mutate a sealed batch; include unapproved metadata; use raw URL/source values; rebuild bytes after ambiguous send |
| `DeliveryCoordinator` | prepare attempt durably; hand exact bytes to transport; classify result; schedule retry/query; apply receipt through writer | infer custody from socket/HTTP success alone; create a new batch after ambiguous outcome; delete payload |
| `ReceiptVerifier` | require authenticated expected peer; strict contract; expected realm/installation context; matching batch ID/content/wire hashes and durable-failure-domain class; detect repeated matching receipt as idempotent | trust payload realm/device; accept mismatched hash/ID; equate custody with semantic acceptance |
| `DiskGovernor` | track filesystem free bytes, allocated DB/WAL/reserve, logical unacknowledged bytes/events, state; pause new collection before hard exhaustion; protect receipt/cleanup/recovery priority | delete unacknowledged rows; assume `page_count` alone equals usable quota; recreate reserve before recovery margin returns |
| `CheckpointController` | run application-owned PASSIVE/FULL/RESTART/TRUNCATE checkpoints under measured conditions; record frames, duration, busy readers, result codes | leave default auto-checkpoint behavior unmeasured; checkpoint from arbitrary connections; block foreground indefinitely |
| `CryptoService` | generate/wrap/unwrap versioned DEKs; AES-GCM encrypt before bind; bind AAD to realm/install/store/object/schema/content; enforce nonce uniqueness; zero buffers best-effort; maintain key states | log keys/nonces with object IDs; reuse nonce/key; claim protection from local admin; silently fall back to plaintext |
| `MigrationManager` | verify signed/hash-pinned plan, compatibility floor, free space, verified backup, exclusive store state; apply expand/backfill/contract rules; run domain/integrity checks; record immutable evidence | execute tenant SQL; auto-contract before rollback expiry; delete/recreate on failure; mix key rotation with destructive schema change without evidence |
| `IntegrityManager` | run quick/startup/full/domain/FK checks according to trigger; distinguish engine integrity from UAM invariants; enter hold on unexplained failure | treat `quick_check=ok` as complete proof; repair live original; omit WAL from stopped-store evidence |
| `BackupManager` | drain writer, use SQLite Online Backup to protected destination, verify completion/hash/open/integrity/key set, test restore, record storage token | copy live DB/WAL/SHM; call an unverified file copy a backup; retain plaintext payload export |
| `QuarantineManager` | stop store, preserve protected file-set/evidence hashes, issue opaque token, enforce access/expiry/deletion authority | upload raw store by default; run `.recover` automatically; let support browse payloads |
| `HealthReporter` | emit finite reason/state/count/size buckets and gate evidence | emit realm/user/source/event/batch IDs as metric labels; payload, host, path, SQL, exception text, key material, receipt body |
| Support CLI | display accessible text and JSON, stable reason codes, current state, opaque local incident token, safe repair/verify commands | arbitrary SQL, payload decrypt/dump, raw identifiers, color-only meaning, destructive command without explicit authorization/evidence |

## 3.3 Trust boundaries

### TB-G5-01 — process-to-store

Only the Coordinator writer actor holds write-capable SQLite access. Assemblies outside the storage module receive typed interfaces, not connection strings, SQL, table names, or native handles. The protected database directory is accessible to the service identity and deployment/administrative recovery authority only. This is defense in depth, not a barrier to a determined local administrator.

### TB-G5-02 — realm/store binding

Every row key starts with `realm_id` and `installation_id`; the file also contains a singleton binding to `store_id`, `store_epoch`, expected release/runtime profile, and schema. File path, key hierarchy, AES-GCM AAD, backups, receipts, and evidence bind to the same realm/installation/store epoch. An expected-binding mismatch enters `REALM_CHANGE_HOLD`; the store is never rebound in place.

### TB-G5-03 — plaintext/ciphertext

Minimized event plaintext may exist only in bounded Coordinator memory during page validation, batch construction, decryption for send, and approved diagnostics tests. Payload is encrypted before SQLite bind. SQLite sees ciphertext, hashes, lengths, state, and metadata. This reduces DB/WAL/backup disclosure but leaves metadata visible and does not protect process memory from privileged tooling.

### TB-G5-04 — database/network

No transaction includes network I/O. A durable attempt record precedes transport. Network results are untrusted typed observations until the receipt verifier commits a matching receipt. An ambiguous result preserves the same immutable batch and schedules replay/status query.

### TB-G5-05 — migration/release

Only migration resources embedded in the authorized release, with exact hashes and compatibility declarations, may execute. Policy or tenant input cannot contain SQL, table/column names, provider settings, key algorithms, filesystem paths, or migration commands. Contract/destructive steps require release authorization and rollback-window evidence.

### TB-G5-06 — incident/support

Corrupt stores, backups, keys, and diagnostic traces remain local/protected unless a separately authorized incident process approves transfer. Shareable evidence is synthetic or value-free. An opaque incident token references protected evidence without revealing its contents.

## 3.4 Store-per-realm and file layout

**RECOMMENDATION.** Use one protected directory per `(realm_id, installation_id, store_epoch)`:

```text
<ProgramData>\Uam\stores\<opaque-realm-token>\
  current\
    endpoint.db
    endpoint.db-wal
    endpoint.db-shm
    recovery.reserve
    store.manifest.json          # no secret or activity value
  backups\
    <opaque-backup-id>.db
    <opaque-backup-id>.manifest.json
  quarantine\
    <opaque-incident-id>\...
```

The realm token is an installation-keyed, purpose-separated digest, not a display name. The manifest contains only expected file names, release/schema/runtime/profile digests, ACL descriptor hash, and state; it does not contain keys, URLs, users, sources, or payloads. Product-owned cleanup operates only on manifest-authenticated paths and refuses reparse points.

## 3.5 Connection ownership and setup

**RECOMMENDATION — one long-lived connection, pooling disabled.** `Microsoft.Data.Sqlite` asynchronous methods execute synchronously; the actor must not pretend SQLite I/O became nonblocking by using `async` wrappers [W15]. The writer executes on a dedicated bounded worker and exposes asynchronous queue completion to callers. The exact managed/native adapter is admitted separately.

At open, before ordinary work, the writer MUST:

1. open an absolute local path with read/write/create only for the protected product store;
2. disable provider pooling and shared cache;
3. identify the loaded SQLite binary by file hash, `sqlite_version()`, `sqlite_source_id()`, compile options, VFS, provider/package and process architecture;
4. set/check the release-owned connection profile;
5. begin an immediate transaction, verify singleton realm/install/store binding, mark `clean_shutdown=0`, update last-opened evidence, and commit;
6. verify migration ledger/schema SQL/domain invariants;
7. run startup integrity policy based on prior clean shutdown and last verified check;
8. resolve incomplete attempts, batches, migration runs, cleanup runs, and backup state before enabling page commits or transport;
9. enter `READY` only when keys, schema, realm, disk reserve, and mandatory invariants pass.

No ordinary component opens an independent read connection. Backup, integrity, and support requests are serialized through the writer. A future read-only connection requires an ADR and evidence that it cannot starve checkpoints, expose payload, bypass realm checks, or create provider pooling.

## 3.6 Configuration ownership, feature flags, and kill switches

| Control | Owner/source | May tenant broaden? | Fail behavior |
|---|---|---:|---|
| SQLite runtime profile, schemas, migration hashes, encryption algorithms, AAD profile | authorized release | No | hold store if unknown/mismatched |
| maximum hard implementation ceiling for row/batch/DB/WAL/attempt sizes | authorized release | No | reject/hold; never allocate beyond ceiling |
| tenant batch/count/frequency/offline limits | signed tenant policy referencing release IDs | No; narrowing only | keep active valid LKG or disable as predecessor policy rules require |
| emergency collection/transport/cleanup/migration/key-rotation kill | product or tenant emergency narrowing, separate authorities | No; disable/narrow only | cancel new work; preserve committed state |
| OS directory/ACL/service identity | MSI/enterprise deployment | Not applicable | refuse open if weaker/unexpected |
| runtime measured budgets and alerts | approved operations profile within release ceiling | No broadening beyond release | pause/defer, report finite health |

Minimum kill switches:

- `collection_commit_enabled`
- `batch_build_enabled`
- `transport_enabled`
- `cleanup_enabled`
- `checkpoint_aggressive_enabled`
- `migration_expand_enabled`
- `migration_contract_enabled`
- `key_rotation_enabled`
- `store_global_hold`

A kill switch MUST NOT delete or rewrite data. `store_global_hold` stops page commits, batch building, transport, cleanup, migrations, and rotation while allowing integrity evidence and explicitly authorized recovery inspection.

## 3.7 Priority and backpressure

Writer commands use a finite priority order:

1. stop/hold, receipt application, key/integrity failure containment;
2. committed-attempt resolution and state recovery;
3. acknowledged cleanup needed to regain reserve, if cleanup is human-authorized;
4. checkpoint needed to prevent WAL exhaustion;
5. transport attempt preparation/status application;
6. page commit already collected in memory;
7. batch construction;
8. routine maintenance, optimize, incremental vacuum, backups;
9. new collection scheduling.

Priority does not bypass invariants. If a page cannot commit because the hard reserve is reached, it is discarded in memory and its cursor does not advance. The source can be retried. The writer queue is bounded by operation count and estimated bytes; queue overflow pauses producers rather than dropping commands whose effects are unknown.

## 3.8 Data lifecycle summary

```text
validated minimized page
  -> atomic source_effect + outbox_event + cursor
  -> READY event
  -> immutable SEALED batch
  -> durable PREPARED attempt
  -> exact body send
  -> unknown/retry OR matching custody receipt
  -> ACKNOWLEDGED
  -> approved grace + trusted clock + no hold
  -> CLEANUP_ELIGIBLE
  -> ciphertext/wire bytes purged, tombstone retained
  -> free pages reused; bounded incremental vacuum may return space
```

No ordinary path skips a state. Terminal or hold states retain enough identity, digest, receipt, and audit evidence to explain why a payload is absent or blocked.

---
# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Reason now | Condition that could change the choice |
|---|---|---|---|
| separate cursor database and outbox database | **REJECT** | no atomic commit across files; creates the exact cursor-ahead/missing-effect risk G5 must eliminate | a proven transactional substrate spanning both stores with lower operational risk, which would be a baseline change |
| multiple SQLite writer connections with busy retry | **REJECT** | converts application serialization into timing behavior, expands busy/deadlock states, and complicates fault proof | measured independent write domains requiring concurrency and a model proving no invariant regression |
| rollback journal instead of WAL | **REJECT FOR DEFAULT** | accepted baseline already selects WAL; WAL gives bounded reader/writer coexistence and explicit checkpoint control | a supported filesystem/security product where WAL cannot pass but rollback journal passes every durability/performance gate, with ADR/change proposal |
| `synchronous=NORMAL` | **REJECT FOR G5** | SQLite documents possible loss of latest committed transactions on power loss in WAL; cursor/effect durability requires the stronger profile [W02] | an accepted human risk decision plus a different end-to-end persistence mechanism that preserves the invariant; latency alone is insufficient |
| `synchronous=EXTRA` | **DO NOT SELECT AS DISTINCT WAL PROFILE** | in WAL it does not materially strengthen the documented commit behavior over FULL; adds semantic noise | future SQLite documentation or lab evidence proves a Windows-specific benefit |
| default WAL auto-checkpoint | **REJECT** | default threshold/foreground PASSIVE behavior is not tied to UAM reserve, readers, or latency budget | exact measurement shows default behavior is superior and equally observable; still must be explicitly configured and evidenced |
| checkpoint on every commit | **REJECT** | excessive latency/write amplification and AV/filter exposure; not required for commit durability | a tiny measured store where it wins every resource/failure criterion |
| unbounded WAL until shutdown | **REJECT** | long outages/readers can exhaust disk and increase recovery work | none; a hard WAL safety ceiling remains required |
| write event payload plaintext and rely only on BitLocker | **REJECT AS DEFAULT** | full-volume encryption does not protect a copied live database from an authorized process, support bundle, backup, or local admin after boot; payload encryption narrows ordinary disclosure | human decision classifies local minimized data as sufficiently low sensitivity and accepts metadata/plaintext exposure with documented compensating controls |
| SQLCipher full-database encryption | **CONDITIONAL ALTERNATIVE** | stronger metadata/page confidentiality, but forks the native stack, changes WAL/backup/recovery/advisory/testing, and adds support/upgrade cost | assurance decision requires encrypted metadata/pages and SQLCipher passes exact native/source/license/performance/recovery/N/N-1 gates |
| SQLite SEE | **CONDITIONAL COMMERCIAL ALTERNATIVE** | official commercial extension, but source-build/licensing/support/interop evidence and exact encryption profile are unresolved [W29] | procurement, support, source-build, crypto review, and full G5 rerun show lower total risk |
| DPAPI `LocalMachine` as sole key protection | **REJECT FOR HIGH ASSURANCE** | any process on the computer can unprotect LocalMachine DPAPI data in the documented scope [W19] | only a low-assurance human decision; it remains suitable for a bounded lab comparison, not an implicit fallback |
| TPM-only wrapping with no software profile | **DEFER** | TPM support/health/VDI/clearing behavior is unknown; mandatory TPM would create unmeasured outage/key-loss paths | supported-estate inventory and recovery drills prove coverage and operations accept fail-closed behavior |
| enterprise escrow/dual wrapping by default | **DEFER / HUMAN DECISION** | improves recoverability but expands who can decrypt, key custody, incident, legal, and access surface | approved sensitivity/recovery/RPO decision and independently controlled enterprise key service |
| one event per HTTP request | **REJECT** | higher overhead and no advantage for immutable receipt/replay; bounded batches are accepted | extremely low measured volume where it lowers total failure/operational cost without changing receipt semantics |
| reconstruct batch bytes on each retry | **REJECT** | library/runtime/compression/order changes can produce different bytes for the same logical events; ambiguous custody becomes unresolvable | none for ordinary replay; a new batch requires authoritative no-custody evidence and a governed supersession contract |
| delete on HTTP 2xx | **REJECT** | 2xx is not the accepted durable-custody receipt | none; only the receipt contract can authorize acknowledgement |
| treat semantic rejection as no custody | **REJECT** | a server may durably receive then reject semantics; custody and validation are distinct | an explicit authenticated receipt/status contract proving no durable custody for that batch |
| external message broker on endpoint or server by default | **REJECT** | accepted baseline defers a broker; endpoint still needs local durable state and broker adds operations/failure domains | later measured server fan-out/replay/throughput/failure-domain trigger; no effect on endpoint atomic page store |
| append-only custom files instead of SQLite | **REJECT** | would reimplement transactions, indexes, crash recovery, compaction, migrations, integrity tools, and backup | a bounded prototype proves materially lower total risk and equal formal/fault evidence |
| EF Core ORM and automatic migrations in endpoint store | **REJECT** | unnecessary change tracking/SQL surface, hidden migration behavior, and reduced control over native profile and exact DDL | none for first implementation; a later narrow read model still requires architecture approval |
| automatic `.recover`, salvage, or delete-and-recreate | **REJECT** | salvage is best-effort and can lose relationships; recreation hides unacknowledged loss and cursor uncertainty [W09] | incident-authorized copy-only recovery whose output passes full UAM reconciliation; never automatic |
| `VACUUM` for routine cleanup | **REJECT** | can require about twice the database size in free space and rewrites the file [W14] | planned offline maintenance with measured need, ample verified space, backup, and explicit operations approval |
| `auto_vacuum=INCREMENTAL` with bounded steps | **ACCEPT AS CANDIDATE** | permits controlled page return without full VACUUM; exact write amplification and effectiveness require measurement [W03] | reject if lab shows unacceptable cost or poor reclaim; free pages can remain reusable in-file |
| drop-oldest or sample under pressure | **REJECT BY INVARIANT** | silently loses unacknowledged data and biases evidence | only an explicit maximum-offline/loss policy approved by accountable humans and represented as an auditable terminal state; conservative default remains pause/no loss |
| store one mixed-realm database | **REJECT** | expands cross-realm query/key/restore/cleanup risk and conflicts with simplest isolation | a formally and operationally proved multi-realm requirement with an explicit baseline change |

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Normative identifier and scalar profile

- All new UAM object IDs are canonical UUIDv7 values; in SQLite they are stored as 16-byte BLOBs in RFC byte order. Text appears only at external contract boundaries.
- `realm_id` and `installation_id` come from authenticated Coordinator registration context and are never accepted from a page or HTTP payload as authority.
- SHA-256 values are 32-byte BLOBs locally and lowercase base64url or lowercase hex under the owning wire contract. Algorithm identity is explicit.
- Time is signed 64-bit Unix epoch milliseconds UTC. Source event precision remains an upstream human decision. Cleanup requires a separate clock-confidence state.
- Exact compressed/uncompressed/item/DB/WAL/queue limits are release-owned safety ceilings plus narrower measured policy values. No receiver infers defaults.
- SQLite `NULL`, absent contract member, and empty value are distinct. The strict contract profile from Batch 01 applies.

## 5.2 `CommitPageCommand`

The storage API receives an in-process immutable object produced only after Batch 02 page validation. The illustrative JSON is fictional and is not an IPC authorization source:

```json
{
  "contract": "uam.endpoint-store.commit-page",
  "version": "1.0.0",
  "pageId": "019d0000-0000-7000-8000-000000000101",
  "runId": "019d0000-0000-7000-8000-000000000102",
  "sourceId": "019d0000-0000-7000-8000-000000000103",
  "sourceGenerationId": "019d0000-0000-7000-8000-000000000104",
  "checkpointVersionObserved": 7,
  "checkpointBefore": 4200,
  "snapshotNativeHighWater": 4250,
  "pageAdvanceTo": 4250,
  "pageCompleteThroughHighWater": true,
  "interpretationId": "sha-256:fictional-interpretation",
  "sourceSchemaCapabilityId": "sha-256:fictional-source-capability",
  "collectorRuntimeProfileId": "sha-256:fictional-runtime-profile",
  "permitDigest": "sha-256:fictional-permit",
  "rows": [
    {
      "nativeVisitId": 4201,
      "effect": {
        "kind": "MINIMIZED_EVENT",
        "eventContractVersion": "1.0.0",
        "canonicalPayloadBase64Url": "eyJmaWN0aW9uYWwiOnRydWV9",
        "payloadContentSha256": "sha-256:fictional-event"
      }
    },
    {
      "nativeVisitId": 4202,
      "effect": {
        "kind": "CONSUMED_NO_EVENT",
        "reasonCode": "SCHEME_UNSUPPORTED",
        "outcomeDigest": "sha-256:fictional-no-event"
      }
    }
  ]
}
```

Normative rules:

1. the object contains no raw URL, path, title, profile/file identity, SID, SQL, exception text, or payload realm/device claim;
2. rows are strictly increasing, unique, and within the requested page range;
3. one interpretation/source capability/runtime/permit applies to the whole page;
4. every returned row has exactly one final effect; defer/retry/hold outcomes are page failures and do not call this interface;
5. canonical payload bytes already satisfy the approved minimized event schema and field limits;
6. the writer recomputes each digest, validates canaries/schema/limits, and refuses mismatch;
7. `page_id` retry with identical command returns the prior committed result; changed content is an invariant conflict.

## 5.3 `CommitPageResult`

```json
{
  "contract": "uam.endpoint-store.commit-page-result",
  "version": "1.0.0",
  "pageId": "019d0000-0000-7000-8000-000000000101",
  "outcome": "COMMITTED_EXISTING_OR_NEW",
  "checkpointVersion": 8,
  "checkpointAfter": 4250,
  "effects": [
    {
      "nativeVisitId": 4201,
      "effectKind": "MINIMIZED_EVENT",
      "eventId": "019d0000-0000-7000-8000-000000000201"
    },
    {
      "nativeVisitId": 4202,
      "effectKind": "CONSUMED_NO_EVENT"
    }
  ]
}
```

A retry returns the same event ID and checkpoint result. A same natural key with a different effect digest returns `IDENTITY_CONFLICT` and enters source/store safety hold; it never overwrites the effect.

## 5.4 Upload batch logical contract

The exact body uses the accepted strict JSON profile, UTF-8, deterministic member ordering/canonical construction under the contract, then deterministic `GZIP_V1` parameters selected and pinned by the release. The server derives realm/device/installation from authentication; those claims are absent from the body.

```json
{
  "contract": "uam.ingestion.batch",
  "version": "1.0.0",
  "batchId": "019d0000-0000-7000-8000-000000000301",
  "createdAtUtc": "2026-07-31T10:00:00Z",
  "events": [
    {
      "eventId": "019d0000-0000-7000-8000-000000000201",
      "eventContractVersion": "1.0.0",
      "payload": { "fictional": true }
    }
  ]
}
```

Hashes:

```text
batch_content_sha256 = SHA-256(canonical uncompressed batch body)
wire_body_sha256     = SHA-256(exact compressed HTTPS body)
```

The local database encrypts the exact compressed body at rest. Before send, it decrypts to bounded memory and verifies `wire_body_sha256`; the transport writes those exact bytes. Batch membership, order, canonical bytes, compression profile, and both hashes are immutable after seal.

Suggested HTTP metadata, subject to the owning ingress contract:

```text
Content-Type: application/vnd.uam.batch+json;version=1
Content-Encoding: gzip
Content-Digest: sha-256=:<RFC 9530 base64>:
Idempotency-Key: <batch UUIDv7>
UAM-Batch-Content-Digest: sha-256=:<base64>:
```

Digest fields provide integrity, not sender authentication [W26]. Authentication and device identity are separate later-gate contracts.

## 5.5 Delivery attempt contract

The writer returns a prepared attempt only after committing it:

```json
{
  "contract": "uam.endpoint-store.prepared-attempt",
  "version": "1.0.0",
  "attemptId": "019d0000-0000-7000-8000-000000000401",
  "batchId": "019d0000-0000-7000-8000-000000000301",
  "attemptNumber": 3,
  "wireBodySha256": "sha-256:fictional-wire",
  "bodyLength": 512,
  "exactBodyHandle": "in-process-one-use-handle"
}
```

`exactBodyHandle` is an in-process bounded lease, not a path or IPC token. After preparation, a crash before the first socket byte and a crash after all bytes are indistinguishable; both replay/query the same batch.

Transport returns one of the finite observations:

```text
VALID_RECEIPT
AUTHENTICATION_FAILURE
CONTRACT_REJECTION_NO_RECEIPT
RETRYABLE_RESPONSE_NO_RECEIPT
TIMEOUT_OR_CONNECTION_LOSS
LOCAL_CANCEL_OR_SHUTDOWN
LOCAL_TLS_OR_PROXY_FAILURE
UNCLASSIFIED_RESPONSE
```

Only `VALID_RECEIPT` may acknowledge. Every other observation preserves payload and batch identity.

## 5.6 Durable-custody receipt

```json
{
  "contract": "uam.ingestion.custody-receipt",
  "version": "1.0.0",
  "receiptId": "019d0000-0000-7000-8000-000000000501",
  "batchId": "019d0000-0000-7000-8000-000000000301",
  "batchContentSha256": "sha-256:fictional-content",
  "wireBodySha256": "sha-256:fictional-wire",
  "custodyState": "DURABLY_RECEIVED",
  "durableAtUtc": "2026-07-31T10:00:01Z",
  "failureDomainClass": "RELATIONAL_PRIMARY_COMMITTED",
  "receiptContractVersion": "1.0.0"
}
```

Normative receipt rules:

- expected authenticated server context supplies realm/device authority; receipt payload claims cannot rebind the endpoint;
- batch ID, content hash, wire hash, contract, custody state, and allowed failure-domain class must match;
- duplicate byte-identical or semantically identical receipt for a batch increments observation evidence and is idempotent;
- a second receipt with a different receipt ID is acceptable only if all authoritative fields and content are identical under the contract; otherwise `HELD_RECEIPT_CONFLICT`;
- durable time is evidence from the server, not cleanup authority by itself;
- receipt does not claim validation, materialization, visibility, or integration;
- a status-query response uses the same receipt contract and validation path.

## 5.7 Error taxonomy

| Family | Example stable codes | Retry class | Required action |
|---|---|---|---|
| store concurrency | `STORE_BUSY_UNEXPECTED`, `CHECKPOINT_BUSY_READER` | bounded retry/maintenance | detect unplanned connection/reader; never spin indefinitely |
| capacity | `DISK_SOFT_RESERVE`, `DISK_HARD_RESERVE`, `SQLITE_FULL`, `QUOTA_REACHED` | pause | stop new collection, preserve receipt/recovery priority |
| I/O | `STORE_IO_TRANSIENT`, `STORE_IO_ACCESS_DENIED`, `STORE_IO_SHARING`, `STORE_IO_DURABILITY_UNKNOWN` | retry then hold | capture value-free OS/SQLite codes and environment evidence |
| integrity | `SQLITE_CORRUPT`, `FOREIGN_KEY_FAILURE`, `DOMAIN_INVARIANT_FAILURE`, `STORE_BINDING_MISMATCH` | hold | stop ordinary work; quarantine/restore workflow |
| crypto | `KEY_UNAVAILABLE`, `KEY_ACCESS_DENIED`, `AUTH_TAG_FAILURE`, `NONCE_COLLISION`, `KEY_REFERENCE_CONFLICT` | security hold | no plaintext fallback; incident evidence |
| migration | `MIGRATION_HASH_MISMATCH`, `MIGRATION_INCOMPATIBLE`, `BACKUP_UNVERIFIED`, `ROLLBACK_FLOOR_EXCEEDED` | hold/old release | do not contract or guess |
| transport | `TIMEOUT`, `TLS_FAILURE`, `PROXY_FAILURE`, `HTTP_RETRYABLE` | replay same batch | preserve immutable bytes and attempt history |
| receipt | `RECEIPT_MISSING`, `RECEIPT_HASH_MISMATCH`, `RECEIPT_PEER_MISMATCH`, `RECEIPT_FAILURE_DOMAIN_UNSUPPORTED` | unknown/hold | never acknowledge; query/replay or security hold |
| policy | `CLEANUP_NOT_AUTHORIZED`, `CLOCK_UNCERTAIN`, `LIMIT_PROFILE_MISSING` | disabled | conservative state; human decision remains open |
| programming | `STATE_TRANSITION_ILLEGAL`, `ROWCOUNT_UNEXPECTED`, `IMMUTABLE_FIELD_CHANGED` | invariant hold | stop component/ring; preserve reproducer |

Messages and metrics contain the code, component, operation, state family, and bounded numeric buckets only. Raw SQLite error strings are kept out of ordinary telemetry because they can include SQL/schema details; restricted local evidence may retain sanitized engine codes and call sites.

## 5.8 DDL conventions

The DDL below is the normative logical starting point. It assumes SQLite 3.53.4 syntax as reviewed, `STRICT` tables, and `WITHOUT ROWID` for composite-key tables [W01, W07]. It is still subject to an executable schema test and exact provider/native admission. Schema resources are hashed, embedded in the signed release, and never downloaded or supplied by tenant policy.

- All tables include realm and installation in their primary/foreign keys.
- Payload ciphertext is nullable only after an acknowledged cleanup transition.
- `source_effect` is the immutable natural-key ledger; `outbox_event` is delivery state for event effects.
- Sealed batch items and immutable content columns are protected by triggers plus application verification.
- `schema_migration` is append-only evidence; `migration_run`/`migration_step` hold resumable execution.
- SQL constraints are necessary but not sufficient; section 5.10 defines domain verifiers.

## 5.9 DDL-level schema and constraints

```sql
CREATE TABLE store_binding (
    singleton_id                  INTEGER NOT NULL PRIMARY KEY CHECK (singleton_id = 1),
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    store_id                      BLOB NOT NULL CHECK (length(store_id) = 16),
    store_epoch                   INTEGER NOT NULL CHECK (store_epoch >= 1),
    schema_version                INTEGER NOT NULL CHECK (schema_version >= 1),
    schema_compat_floor           INTEGER NOT NULL CHECK (
                                       schema_compat_floor >= 1
                                       AND schema_compat_floor <= schema_version),
    store_state                   TEXT NOT NULL CHECK (store_state IN (
                                       'NEW','OPENING','READY','PAUSED_DISK',
                                       'PAUSED_POLICY','MIGRATING','KEY_HOLD',
                                       'INTEGRITY_HOLD','CORRUPTION_HOLD',
                                       'REALM_CHANGE_HOLD','DRAINING','CLOSED')),
    clean_shutdown                INTEGER NOT NULL CHECK (clean_shutdown IN (0,1)),
    clock_confidence              TEXT NOT NULL CHECK (clock_confidence IN (
                                       'TRUSTED','UNCERTAIN','ROLLED_BACK')),
    next_event_seq                INTEGER NOT NULL CHECK (next_event_seq >= 1),
    next_batch_seq                INTEGER NOT NULL CHECK (next_batch_seq >= 1),
    next_cleanup_seq              INTEGER NOT NULL CHECK (next_cleanup_seq >= 1),
    sqlite_runtime_profile_id     BLOB NOT NULL CHECK (length(sqlite_runtime_profile_id) = 32),
    schema_sql_sha256             BLOB NOT NULL CHECK (length(schema_sql_sha256) = 32),
    active_policy_digest          BLOB NULL CHECK (
                                       active_policy_digest IS NULL
                                       OR length(active_policy_digest) = 32),
    created_utc_ms                INTEGER NOT NULL,
    last_opened_utc_ms            INTEGER NULL,
    last_clean_close_utc_ms       INTEGER NULL,
    row_version                   INTEGER NOT NULL CHECK (row_version >= 0),
    UNIQUE (realm_id, installation_id),
    UNIQUE (realm_id, installation_id, store_id, store_epoch)
) STRICT;

CREATE TABLE crypto_key (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    key_id                        BLOB NOT NULL CHECK (length(key_id) = 16),
    purpose                       TEXT NOT NULL CHECK (purpose IN (
                                       'EVENT_PAYLOAD_V1','BATCH_WIRE_BODY_V1',
                                       'POLICY_ARTIFACT_V1')),
    key_version                   INTEGER NOT NULL CHECK (key_version >= 1),
    wrapping_provider             TEXT NOT NULL CHECK (wrapping_provider IN (
                                       'CNG_PLATFORM_TPM','CNG_SOFTWARE',
                                       'DPAPI_LOCAL_MACHINE_TEST','ENTERPRISE_DUAL_WRAP')),
    wrapping_key_id_hash          BLOB NOT NULL CHECK (length(wrapping_key_id_hash) = 32),
    wrap_algorithm                TEXT NOT NULL CHECK (wrap_algorithm IN (
                                       'RSA_OAEP_SHA256','DPAPI_MACHINE_TEST')),
    wrapped_dek                   BLOB NOT NULL CHECK (length(wrapped_dek) > 0),
    recovery_wrapped_dek          BLOB NULL,
    key_state                     TEXT NOT NULL CHECK (key_state IN (
                                       'CREATED','ACTIVE','DECRYPT_ONLY','RETIRED',
                                       'LOST','HOLD')),
    created_utc_ms                INTEGER NOT NULL,
    activated_utc_ms              INTEGER NULL,
    retired_utc_ms                INTEGER NULL,
    key_properties_digest         BLOB NOT NULL CHECK (length(key_properties_digest) = 32),
    PRIMARY KEY (realm_id, installation_id, key_id),
    UNIQUE (realm_id, installation_id, purpose, key_version),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
      DEFERRABLE INITIALLY DEFERRED
) STRICT, WITHOUT ROWID;

CREATE UNIQUE INDEX ux_crypto_key_one_active_per_purpose
ON crypto_key(realm_id, installation_id, purpose)
WHERE key_state = 'ACTIVE';

CREATE TABLE schema_migration (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    migration_seq                 INTEGER NOT NULL CHECK (migration_seq >= 1),
    migration_id                  TEXT NOT NULL,
    migration_sha256              BLOB NOT NULL CHECK (length(migration_sha256) = 32),
    migration_kind                TEXT NOT NULL CHECK (migration_kind IN (
                                       'EXPAND','BACKFILL','CONTRACT','REPAIR')),
    from_schema_version           INTEGER NOT NULL CHECK (from_schema_version >= 1),
    to_schema_version             INTEGER NOT NULL CHECK (to_schema_version >= from_schema_version),
    min_reader_schema_version     INTEGER NOT NULL CHECK (min_reader_schema_version >= 1),
    release_id                    TEXT NOT NULL,
    applied_utc_ms                INTEGER NOT NULL,
    evidence_digest               BLOB NOT NULL CHECK (length(evidence_digest) = 32),
    PRIMARY KEY (realm_id, installation_id, migration_seq),
    UNIQUE (realm_id, installation_id, migration_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE migration_run (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    migration_run_id              BLOB NOT NULL CHECK (length(migration_run_id) = 16),
    target_schema_version         INTEGER NOT NULL CHECK (target_schema_version >= 1),
    release_id                    TEXT NOT NULL,
    plan_digest                   BLOB NOT NULL CHECK (length(plan_digest) = 32),
    backup_id                     BLOB NULL CHECK (backup_id IS NULL OR length(backup_id) = 16),
    run_state                     TEXT NOT NULL CHECK (run_state IN (
                                       'PREPARED','BACKUP_VERIFIED','APPLYING','VERIFYING',
                                       'APPLIED','ROLLED_BACK','FAILED_HOLD','ABANDONED')),
    started_utc_ms                INTEGER NOT NULL,
    completed_utc_ms              INTEGER NULL,
    failure_code                  TEXT NULL,
    evidence_digest               BLOB NULL CHECK (
                                       evidence_digest IS NULL OR length(evidence_digest) = 32),
    PRIMARY KEY (realm_id, installation_id, migration_run_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id),
    FOREIGN KEY (realm_id, installation_id, backup_id)
      REFERENCES store_backup(realm_id, installation_id, backup_id)
      DEFERRABLE INITIALLY DEFERRED
) STRICT, WITHOUT ROWID;

CREATE TABLE migration_step (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    migration_run_id              BLOB NOT NULL CHECK (length(migration_run_id) = 16),
    step_ordinal                  INTEGER NOT NULL CHECK (step_ordinal >= 0),
    step_id                       TEXT NOT NULL,
    step_kind                     TEXT NOT NULL CHECK (step_kind IN (
                                       'DDL_TRANSACTION','BACKFILL_CHUNK','VERIFY','CONTRACT')),
    step_state                    TEXT NOT NULL CHECK (step_state IN (
                                       'PENDING','RUNNING','COMMITTED','VERIFIED','FAILED_HOLD')),
    progress_key                  BLOB NULL,
    rows_processed                INTEGER NOT NULL DEFAULT 0 CHECK (rows_processed >= 0),
    step_digest                   BLOB NOT NULL CHECK (length(step_digest) = 32),
    started_utc_ms                INTEGER NULL,
    completed_utc_ms              INTEGER NULL,
    PRIMARY KEY (realm_id, installation_id, migration_run_id, step_ordinal),
    UNIQUE (realm_id, installation_id, migration_run_id, step_id),
    FOREIGN KEY (realm_id, installation_id, migration_run_id)
      REFERENCES migration_run(realm_id, installation_id, migration_run_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE store_backup (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    backup_id                     BLOB NOT NULL CHECK (length(backup_id) = 16),
    backup_kind                   TEXT NOT NULL CHECK (backup_kind IN (
                                       'PRE_MIGRATION','PERIODIC_RPO','INCIDENT','PRE_KEY_CHANGE')),
    schema_version                INTEGER NOT NULL CHECK (schema_version >= 1),
    store_epoch                   INTEGER NOT NULL CHECK (store_epoch >= 1),
    file_manifest_sha256          BLOB NOT NULL CHECK (length(file_manifest_sha256) = 32),
    backup_file_sha256            BLOB NOT NULL CHECK (length(backup_file_sha256) = 32),
    key_set_digest                BLOB NOT NULL CHECK (length(key_set_digest) = 32),
    backup_state                  TEXT NOT NULL CHECK (backup_state IN (
                                       'CREATING','VERIFIED','RESTORED_TESTED',
                                       'QUARANTINED','DELETED')),
    created_utc_ms                INTEGER NOT NULL,
    verified_utc_ms               INTEGER NULL,
    storage_token                 TEXT NOT NULL,
    PRIMARY KEY (realm_id, installation_id, backup_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE policy_artifact (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    policy_artifact_id            BLOB NOT NULL CHECK (length(policy_artifact_id) = 16),
    artifact_kind                 TEXT NOT NULL CHECK (artifact_kind IN (
                                       'PRODUCT_CEILING','TENANT_POLICY','EMERGENCY_NARROWING',
                                       'MATCHER_SNAPSHOT','STORE_LIMITS')),
    revision                      INTEGER NOT NULL CHECK (revision >= 1),
    content_sha256                BLOB NOT NULL CHECK (length(content_sha256) = 32),
    artifact_bytes                BLOB NOT NULL CHECK (length(artifact_bytes) > 0),
    artifact_state                TEXT NOT NULL CHECK (artifact_state IN (
                                       'CANDIDATE','ACTIVE','SUPERSEDED','EXPIRED','QUARANTINED')),
    not_before_utc_ms             INTEGER NULL,
    expires_utc_ms                INTEGER NULL,
    stored_utc_ms                 INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, policy_artifact_id),
    UNIQUE (realm_id, installation_id, artifact_kind, revision),
    CHECK (expires_utc_ms IS NULL OR not_before_utc_ms IS NULL
           OR expires_utc_ms > not_before_utc_ms),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE UNIQUE INDEX ux_policy_one_active_kind
ON policy_artifact(realm_id, installation_id, artifact_kind)
WHERE artifact_state = 'ACTIVE';

CREATE TABLE source (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_kind                   TEXT NOT NULL CHECK (source_kind = 'EDGE_HISTORY'),
    root_kind_id                  TEXT NOT NULL,
    channel_id                    TEXT NOT NULL,
    root_locator_digest           BLOB NOT NULL CHECK (length(root_locator_digest) = 32),
    profile_locator_digest        BLOB NOT NULL CHECK (length(profile_locator_digest) = 32),
    source_state                  TEXT NOT NULL CHECK (source_state IN (
                                       'BASELINE_PENDING','ACTIVE','TEMPORARILY_ABSENT',
                                       'SUSPECT','UNSUPPORTED','SAFETY_HOLD','REMOVED')),
    source_sequence               INTEGER NOT NULL CHECK (source_sequence >= 1),
    current_generation_id         BLOB NULL CHECK (
                                       current_generation_id IS NULL
                                       OR length(current_generation_id) = 16),
    first_seen_utc_ms             INTEGER NOT NULL,
    last_seen_utc_ms              INTEGER NOT NULL,
    row_version                   INTEGER NOT NULL CHECK (row_version >= 0),
    PRIMARY KEY (realm_id, installation_id, source_id),
    UNIQUE (realm_id, installation_id, source_kind, profile_locator_digest),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id),
    FOREIGN KEY (realm_id, installation_id, source_id, current_generation_id)
      REFERENCES source_generation(
        realm_id, installation_id, source_id, source_generation_id)
      DEFERRABLE INITIALLY DEFERRED
) STRICT, WITHOUT ROWID;

CREATE TABLE source_generation (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    generation_sequence           INTEGER NOT NULL CHECK (generation_sequence >= 1),
    predecessor_generation_id     BLOB NULL CHECK (
                                       predecessor_generation_id IS NULL
                                       OR length(predecessor_generation_id) = 16),
    history_locator_digest        BLOB NOT NULL CHECK (length(history_locator_digest) = 32),
    source_schema_capability_id   BLOB NOT NULL CHECK (length(source_schema_capability_id) = 32),
    generation_state              TEXT NOT NULL CHECK (generation_state IN (
                                       'BASELINE_PENDING','ACTIVE','SUSPECT','CLOSED','SAFETY_HOLD')),
    start_reason                  TEXT NOT NULL,
    close_reason                  TEXT NULL,
    observed_native_high_water    INTEGER NOT NULL DEFAULT 0 CHECK (observed_native_high_water >= 0),
    created_utc_ms                INTEGER NOT NULL,
    closed_utc_ms                 INTEGER NULL,
    row_version                   INTEGER NOT NULL CHECK (row_version >= 0),
    PRIMARY KEY (realm_id, installation_id, source_id, source_generation_id),
    UNIQUE (realm_id, installation_id, source_id, generation_sequence),
    FOREIGN KEY (realm_id, installation_id, source_id)
      REFERENCES source(realm_id, installation_id, source_id)
      DEFERRABLE INITIALLY DEFERRED
) STRICT, WITHOUT ROWID;

CREATE TABLE source_checkpoint (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    high_native_visit_id          INTEGER NOT NULL CHECK (high_native_visit_id >= 0),
    native_sequence_high_water    INTEGER NOT NULL CHECK (native_sequence_high_water >= 0),
    checkpoint_version            INTEGER NOT NULL CHECK (checkpoint_version >= 0),
    active_interpretation_id      BLOB NULL CHECK (
                                       active_interpretation_id IS NULL
                                       OR length(active_interpretation_id) = 32),
    last_committed_page_id        BLOB NULL CHECK (
                                       last_committed_page_id IS NULL
                                       OR length(last_committed_page_id) = 16),
    updated_utc_ms                INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id, source_generation_id),
    FOREIGN KEY (realm_id, installation_id, source_id, source_generation_id)
      REFERENCES source_generation(
        realm_id, installation_id, source_id, source_generation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE collection_run (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    run_id                        BLOB NOT NULL CHECK (length(run_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    run_state                     TEXT NOT NULL CHECK (run_state IN (
                                       'INTENT','PERMITTED','PAGE_RECEIVED','COMMITTED',
                                       'DEFERRED','CANCELLED','FAILED','SAFETY_HOLD')),
    permit_digest                 BLOB NOT NULL CHECK (length(permit_digest) = 32),
    interpretation_id             BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    source_schema_capability_id   BLOB NOT NULL CHECK (length(source_schema_capability_id) = 32),
    collector_runtime_profile_id  BLOB NOT NULL CHECK (length(collector_runtime_profile_id) = 32),
    outcome_code                  TEXT NULL,
    started_utc_ms                INTEGER NOT NULL,
    completed_utc_ms              INTEGER NULL,
    PRIMARY KEY (realm_id, installation_id, run_id),
    FOREIGN KEY (realm_id, installation_id, source_id, source_generation_id)
      REFERENCES source_generation(
        realm_id, installation_id, source_id, source_generation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE page_commit (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    page_id                       BLOB NOT NULL CHECK (length(page_id) = 16),
    run_id                        BLOB NOT NULL CHECK (length(run_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    permit_digest                 BLOB NOT NULL CHECK (length(permit_digest) = 32),
    interpretation_id             BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    source_schema_capability_id   BLOB NOT NULL CHECK (length(source_schema_capability_id) = 32),
    collector_runtime_profile_id  BLOB NOT NULL CHECK (length(collector_runtime_profile_id) = 32),
    acquisition_method            TEXT NOT NULL CHECK (acquisition_method IN (
                                       'SYNTHETIC','DIRECT','ONLINE_BACKUP')),
    checkpoint_version_before     INTEGER NOT NULL CHECK (checkpoint_version_before >= 0),
    checkpoint_version_after      INTEGER NOT NULL CHECK (
                                       checkpoint_version_after = checkpoint_version_before + 1),
    checkpoint_before             INTEGER NOT NULL CHECK (checkpoint_before >= 0),
    snapshot_native_high_water    INTEGER NOT NULL CHECK (snapshot_native_high_water >= checkpoint_before),
    page_advance_to               INTEGER NOT NULL CHECK (
                                       page_advance_to >= checkpoint_before
                                       AND page_advance_to <= snapshot_native_high_water),
    page_complete_through_high    INTEGER NOT NULL CHECK (page_complete_through_high IN (0,1)),
    returned_row_count            INTEGER NOT NULL CHECK (returned_row_count >= 0),
    event_effect_count            INTEGER NOT NULL CHECK (event_effect_count >= 0),
    no_event_effect_count         INTEGER NOT NULL CHECK (no_event_effect_count >= 0),
    page_command_sha256           BLOB NOT NULL CHECK (length(page_command_sha256) = 32),
    committed_utc_ms              INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, page_id),
    UNIQUE (realm_id, installation_id, run_id, page_id),
    CHECK (returned_row_count = event_effect_count + no_event_effect_count),
    FOREIGN KEY (realm_id, installation_id, run_id)
      REFERENCES collection_run(realm_id, installation_id, run_id),
    FOREIGN KEY (realm_id, installation_id, source_id, source_generation_id)
      REFERENCES source_generation(
        realm_id, installation_id, source_id, source_generation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE source_effect (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    native_visit_id               INTEGER NOT NULL CHECK (native_visit_id > 0),
    interpretation_id             BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    effect_kind                   TEXT NOT NULL CHECK (effect_kind IN (
                                       'MINIMIZED_EVENT','CONSUMED_NO_EVENT')),
    event_id                      BLOB NULL CHECK (event_id IS NULL OR length(event_id) = 16),
    effect_digest                 BLOB NOT NULL CHECK (length(effect_digest) = 32),
    reason_code                   TEXT NULL,
    page_id                       BLOB NOT NULL CHECK (length(page_id) = 16),
    created_utc_ms                INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id),
    UNIQUE (realm_id, installation_id, event_id),
    CHECK ((effect_kind = 'MINIMIZED_EVENT'
            AND event_id IS NOT NULL AND reason_code IS NULL)
        OR (effect_kind = 'CONSUMED_NO_EVENT'
            AND event_id IS NULL AND reason_code IS NOT NULL)),
    FOREIGN KEY (realm_id, installation_id, page_id)
      REFERENCES page_commit(realm_id, installation_id, page_id),
    FOREIGN KEY (realm_id, installation_id, source_id, source_generation_id)
      REFERENCES source_generation(
        realm_id, installation_id, source_id, source_generation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE overlap_witness (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    native_visit_id               INTEGER NOT NULL CHECK (native_visit_id > 0),
    interpretation_id             BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    effect_digest                 BLOB NOT NULL CHECK (length(effect_digest) = 32),
    recorded_utc_ms               INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id, interpretation_id),
    FOREIGN KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id)
      REFERENCES source_effect(
        realm_id, installation_id, source_id, source_generation_id, native_visit_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE outbox_batch (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    batch_id                      BLOB NOT NULL CHECK (length(batch_id) = 16),
    batch_seq                     INTEGER NOT NULL CHECK (batch_seq >= 1),
    contract_version              TEXT NOT NULL,
    compression                   TEXT NOT NULL CHECK (compression IN ('GZIP_V1','NONE_TEST')),
    batch_state                   TEXT NOT NULL CHECK (batch_state IN (
                                       'SEALED','IN_FLIGHT_UNKNOWN','RETRY_WAIT',
                                       'HELD_AUTH','HELD_CONTRACT','HELD_RECEIPT_CONFLICT',
                                       'RECEIPTED','CLEANUP_ELIGIBLE','PAYLOAD_PURGED')),
    event_count                   INTEGER NOT NULL CHECK (event_count > 0),
    first_event_seq               INTEGER NOT NULL CHECK (first_event_seq >= 1),
    last_event_seq                INTEGER NOT NULL CHECK (last_event_seq >= first_event_seq),
    uncompressed_length           INTEGER NOT NULL CHECK (uncompressed_length > 0),
    compressed_length             INTEGER NOT NULL CHECK (compressed_length > 0),
    batch_content_sha256          BLOB NOT NULL CHECK (length(batch_content_sha256) = 32),
    wire_body_sha256              BLOB NOT NULL CHECK (length(wire_body_sha256) = 32),
    wire_key_id                   BLOB NULL CHECK (wire_key_id IS NULL OR length(wire_key_id) = 16),
    wire_nonce                    BLOB NULL CHECK (wire_nonce IS NULL OR length(wire_nonce) = 12),
    wire_tag                      BLOB NULL CHECK (wire_tag IS NULL OR length(wire_tag) = 16),
    wire_ciphertext               BLOB NULL,
    created_utc_ms                INTEGER NOT NULL,
    sealed_utc_ms                 INTEGER NOT NULL,
    next_attempt_not_before_ms    INTEGER NULL,
    receipted_utc_ms              INTEGER NULL,
    cleanup_eligible_utc_ms       INTEGER NULL,
    hold_reason_code              TEXT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, installation_id, batch_seq),
    UNIQUE (realm_id, installation_id, batch_content_sha256),
    CHECK ((batch_state = 'PAYLOAD_PURGED'
            AND wire_ciphertext IS NULL AND wire_nonce IS NULL
            AND wire_tag IS NULL AND wire_key_id IS NULL)
        OR (batch_state <> 'PAYLOAD_PURGED'
            AND wire_ciphertext IS NOT NULL AND length(wire_ciphertext) > 0
            AND wire_nonce IS NOT NULL AND wire_tag IS NOT NULL
            AND wire_key_id IS NOT NULL)),
    CHECK ((batch_state IN ('RECEIPTED','CLEANUP_ELIGIBLE','PAYLOAD_PURGED')
            AND receipted_utc_ms IS NOT NULL)
        OR (batch_state NOT IN ('RECEIPTED','CLEANUP_ELIGIBLE','PAYLOAD_PURGED'))),
    FOREIGN KEY (realm_id, installation_id, wire_key_id)
      REFERENCES crypto_key(realm_id, installation_id, key_id)
) STRICT, WITHOUT ROWID;

CREATE UNIQUE INDEX ux_batch_wire_nonce
ON outbox_batch(realm_id, installation_id, wire_key_id, wire_nonce)
WHERE wire_nonce IS NOT NULL;

CREATE INDEX ix_batch_send_queue
ON outbox_batch(realm_id, installation_id, batch_state,
                next_attempt_not_before_ms, batch_seq);

CREATE TABLE outbox_event (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    event_id                      BLOB NOT NULL CHECK (length(event_id) = 16),
    event_seq                     INTEGER NOT NULL CHECK (event_seq >= 1),
    source_id                     BLOB NOT NULL CHECK (length(source_id) = 16),
    source_generation_id          BLOB NOT NULL CHECK (length(source_generation_id) = 16),
    native_visit_id               INTEGER NOT NULL CHECK (native_visit_id > 0),
    interpretation_id             BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    event_contract_version        TEXT NOT NULL,
    payload_content_sha256        BLOB NOT NULL CHECK (length(payload_content_sha256) = 32),
    payload_plaintext_length      INTEGER NOT NULL CHECK (payload_plaintext_length > 0),
    payload_key_id                BLOB NULL CHECK (payload_key_id IS NULL OR length(payload_key_id) = 16),
    payload_nonce                 BLOB NULL CHECK (payload_nonce IS NULL OR length(payload_nonce) = 12),
    payload_tag                   BLOB NULL CHECK (payload_tag IS NULL OR length(payload_tag) = 16),
    payload_ciphertext            BLOB NULL,
    delivery_state                TEXT NOT NULL CHECK (delivery_state IN (
                                       'READY','BATCHED','ACKNOWLEDGED',
                                       'CLEANUP_ELIGIBLE','HELD')),
    payload_state                 TEXT NOT NULL CHECK (payload_state IN ('PRESENT','PURGED')),
    current_batch_id              BLOB NULL CHECK (
                                       current_batch_id IS NULL OR length(current_batch_id) = 16),
    acknowledged_receipt_id       BLOB NULL CHECK (
                                       acknowledged_receipt_id IS NULL
                                       OR length(acknowledged_receipt_id) = 16),
    created_utc_ms                INTEGER NOT NULL,
    acknowledged_utc_ms           INTEGER NULL,
    cleanup_eligible_utc_ms       INTEGER NULL,
    PRIMARY KEY (realm_id, installation_id, event_id),
    UNIQUE (realm_id, installation_id, event_seq),
    UNIQUE (realm_id, installation_id, source_id,
            source_generation_id, native_visit_id),
    CHECK ((delivery_state = 'READY' AND current_batch_id IS NULL)
        OR (delivery_state IN ('BATCHED','ACKNOWLEDGED','CLEANUP_ELIGIBLE','HELD')
            AND current_batch_id IS NOT NULL)),
    CHECK ((payload_state = 'PURGED'
            AND payload_ciphertext IS NULL AND payload_nonce IS NULL
            AND payload_tag IS NULL AND payload_key_id IS NULL)
        OR (payload_state = 'PRESENT'
            AND payload_ciphertext IS NOT NULL AND length(payload_ciphertext) > 0
            AND payload_nonce IS NOT NULL AND payload_tag IS NOT NULL
            AND payload_key_id IS NOT NULL)),
    CHECK ((delivery_state IN ('ACKNOWLEDGED','CLEANUP_ELIGIBLE')
            AND acknowledged_receipt_id IS NOT NULL AND acknowledged_utc_ms IS NOT NULL)
        OR (delivery_state NOT IN ('ACKNOWLEDGED','CLEANUP_ELIGIBLE'))),
    CHECK (payload_state = 'PRESENT' OR delivery_state IN ('ACKNOWLEDGED','CLEANUP_ELIGIBLE')),
    FOREIGN KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id)
      REFERENCES source_effect(
        realm_id, installation_id, source_id, source_generation_id, native_visit_id),
    FOREIGN KEY (realm_id, installation_id, current_batch_id)
      REFERENCES outbox_batch(realm_id, installation_id, batch_id)
      DEFERRABLE INITIALLY DEFERRED,
    FOREIGN KEY (realm_id, installation_id, payload_key_id)
      REFERENCES crypto_key(realm_id, installation_id, key_id),
    FOREIGN KEY (realm_id, installation_id, acknowledged_receipt_id)
      REFERENCES delivery_receipt(realm_id, installation_id, receipt_id)
      DEFERRABLE INITIALLY DEFERRED
) STRICT, WITHOUT ROWID;

CREATE UNIQUE INDEX ux_event_payload_nonce
ON outbox_event(realm_id, installation_id, payload_key_id, payload_nonce)
WHERE payload_nonce IS NOT NULL;

CREATE INDEX ix_event_ready_queue
ON outbox_event(realm_id, installation_id, delivery_state, event_seq);

CREATE INDEX ix_event_cleanup
ON outbox_event(realm_id, installation_id, delivery_state,
                cleanup_eligible_utc_ms, event_seq);

CREATE TABLE outbox_batch_item (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    batch_id                      BLOB NOT NULL CHECK (length(batch_id) = 16),
    item_ordinal                  INTEGER NOT NULL CHECK (item_ordinal >= 0),
    event_id                      BLOB NOT NULL CHECK (length(event_id) = 16),
    event_seq                     INTEGER NOT NULL CHECK (event_seq >= 1),
    event_payload_sha256          BLOB NOT NULL CHECK (length(event_payload_sha256) = 32),
    PRIMARY KEY (realm_id, installation_id, batch_id, item_ordinal),
    UNIQUE (realm_id, installation_id, batch_id, event_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES outbox_batch(realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, event_id)
      REFERENCES outbox_event(realm_id, installation_id, event_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE delivery_attempt (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    attempt_id                    BLOB NOT NULL CHECK (length(attempt_id) = 16),
    batch_id                      BLOB NOT NULL CHECK (length(batch_id) = 16),
    attempt_no                    INTEGER NOT NULL CHECK (attempt_no >= 1),
    attempt_state                 TEXT NOT NULL CHECK (attempt_state IN (
                                       'PREPARED','OUTCOME_UNKNOWN','RETRYABLE',
                                       'RECEIPT_OBSERVED','AUTH_HOLD',
                                       'CONTRACT_HOLD','CANCELLED')),
    wire_body_sha256              BLOB NOT NULL CHECK (length(wire_body_sha256) = 32),
    prepared_utc_ms               INTEGER NOT NULL,
    send_started_utc_ms           INTEGER NULL,
    response_observed_utc_ms      INTEGER NULL,
    completed_utc_ms              INTEGER NULL,
    transport_result_code         TEXT NULL,
    http_status_class             INTEGER NULL CHECK (
                                       http_status_class IS NULL
                                       OR http_status_class BETWEEN 1 AND 5),
    retry_not_before_utc_ms       INTEGER NULL,
    receipt_observation_sha256    BLOB NULL CHECK (
                                       receipt_observation_sha256 IS NULL
                                       OR length(receipt_observation_sha256) = 32),
    PRIMARY KEY (realm_id, installation_id, attempt_id),
    UNIQUE (realm_id, installation_id, batch_id, attempt_no),
    UNIQUE (realm_id, installation_id, attempt_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES outbox_batch(realm_id, installation_id, batch_id)
) STRICT, WITHOUT ROWID;

CREATE INDEX ix_attempt_batch
ON delivery_attempt(realm_id, installation_id, batch_id, attempt_no);

CREATE TABLE delivery_receipt (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    receipt_id                    BLOB NOT NULL CHECK (length(receipt_id) = 16),
    batch_id                      BLOB NOT NULL CHECK (length(batch_id) = 16),
    receipt_contract_version      TEXT NOT NULL,
    batch_content_sha256          BLOB NOT NULL CHECK (length(batch_content_sha256) = 32),
    wire_body_sha256              BLOB NOT NULL CHECK (length(wire_body_sha256) = 32),
    custody_state                 TEXT NOT NULL CHECK (custody_state = 'DURABLY_RECEIVED'),
    durable_at_utc_ms             INTEGER NOT NULL,
    observed_at_utc_ms            INTEGER NOT NULL,
    last_observed_at_utc_ms       INTEGER NOT NULL,
    observation_count             INTEGER NOT NULL CHECK (observation_count >= 1),
    failure_domain_class          TEXT NOT NULL CHECK (failure_domain_class IN (
                                       'RELATIONAL_PRIMARY_COMMITTED',
                                       'DURABLE_INBOX_COMMITTED',
                                       'OTHER_REVIEWED_DURABLE_BOUNDARY')),
    failure_domain_id_hash        BLOB NOT NULL CHECK (length(failure_domain_id_hash) = 32),
    authenticated_peer_hash       BLOB NOT NULL CHECK (length(authenticated_peer_hash) = 32),
    receipt_body_sha256           BLOB NOT NULL CHECK (length(receipt_body_sha256) = 32),
    accepted_attempt_id           BLOB NOT NULL CHECK (length(accepted_attempt_id) = 16),
    PRIMARY KEY (realm_id, installation_id, receipt_id),
    UNIQUE (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, installation_id, batch_id, batch_content_sha256),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES outbox_batch(realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, accepted_attempt_id, batch_id)
      REFERENCES delivery_attempt(
        realm_id, installation_id, attempt_id, batch_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE quarantine_item (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    quarantine_id                 BLOB NOT NULL CHECK (length(quarantine_id) = 16),
    object_kind                   TEXT NOT NULL CHECK (object_kind IN (
                                       'STORE_FILE_SET','BATCH','RECEIPT_OBSERVATION',
                                       'MIGRATION','KEY','BACKUP','INVARIANT')),
    object_id                     BLOB NULL CHECK (object_id IS NULL OR length(object_id) = 16),
    reason_code                   TEXT NOT NULL,
    quarantine_state              TEXT NOT NULL CHECK (quarantine_state IN (
                                       'OPEN','PRESERVED','REPAIRED','SUPERSEDED',
                                       'DELETED_BY_AUTHORITY')),
    evidence_sha256               BLOB NOT NULL CHECK (length(evidence_sha256) = 32),
    storage_token                 TEXT NULL,
    created_utc_ms                INTEGER NOT NULL,
    resolved_utc_ms               INTEGER NULL,
    PRIMARY KEY (realm_id, installation_id, quarantine_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE health_state (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    component                     TEXT NOT NULL,
    health_code                   TEXT NOT NULL,
    severity                      TEXT NOT NULL CHECK (severity IN (
                                       'INFO','DEGRADED','PAUSED','HOLD')),
    first_observed_utc_ms         INTEGER NOT NULL,
    last_observed_utc_ms          INTEGER NOT NULL,
    occurrence_count              INTEGER NOT NULL CHECK (occurrence_count >= 1),
    value_bucket                  TEXT NULL,
    build_ring                    TEXT NULL,
    PRIMARY KEY (realm_id, installation_id, component, health_code),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE maintenance_run (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    maintenance_run_id            BLOB NOT NULL CHECK (length(maintenance_run_id) = 16),
    operation_kind                TEXT NOT NULL CHECK (operation_kind IN (
                                       'CHECKPOINT_PASSIVE','CHECKPOINT_FULL',
                                       'CHECKPOINT_RESTART','CHECKPOINT_TRUNCATE',
                                       'QUICK_CHECK','INTEGRITY_CHECK','FOREIGN_KEY_CHECK',
                                       'DOMAIN_VERIFY','OPTIMIZE','INCREMENTAL_VACUUM',
                                       'BACKUP','RESTORE_VERIFY','KEY_ROTATION')),
    operation_state               TEXT NOT NULL CHECK (operation_state IN (
                                       'PREPARED','RUNNING','COMPLETED','DEFERRED','FAILED_HOLD')),
    input_digest                  BLOB NOT NULL CHECK (length(input_digest) = 32),
    result_code                   TEXT NULL,
    result_digest                 BLOB NULL CHECK (
                                       result_digest IS NULL OR length(result_digest) = 32),
    started_utc_ms                INTEGER NOT NULL,
    completed_utc_ms              INTEGER NULL,
    PRIMARY KEY (realm_id, installation_id, maintenance_run_id),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TABLE cleanup_run (
    realm_id                      BLOB NOT NULL CHECK (length(realm_id) = 16),
    installation_id               BLOB NOT NULL CHECK (length(installation_id) = 16),
    cleanup_run_id                BLOB NOT NULL CHECK (length(cleanup_run_id) = 16),
    cleanup_seq                   INTEGER NOT NULL CHECK (cleanup_seq >= 1),
    cleanup_state                 TEXT NOT NULL CHECK (cleanup_state IN (
                                       'PREPARED','APPLYING','COMMITTED','DEFERRED','FAILED_HOLD')),
    policy_digest                 BLOB NOT NULL CHECK (length(policy_digest) = 32),
    selection_digest              BLOB NOT NULL CHECK (length(selection_digest) = 32),
    selected_event_count          INTEGER NOT NULL CHECK (selected_event_count >= 0),
    selected_batch_count          INTEGER NOT NULL CHECK (selected_batch_count >= 0),
    payload_bytes_purged          INTEGER NOT NULL DEFAULT 0 CHECK (payload_bytes_purged >= 0),
    key_reference_delta_digest    BLOB NULL CHECK (
                                       key_reference_delta_digest IS NULL
                                       OR length(key_reference_delta_digest) = 32),
    started_utc_ms                INTEGER NOT NULL,
    completed_utc_ms              INTEGER NULL,
    result_code                   TEXT NULL,
    PRIMARY KEY (realm_id, installation_id, cleanup_run_id),
    UNIQUE (realm_id, installation_id, cleanup_seq),
    FOREIGN KEY (realm_id, installation_id)
      REFERENCES store_binding(realm_id, installation_id)
) STRICT, WITHOUT ROWID;

CREATE TRIGGER tr_store_binding_identity_immutable
BEFORE UPDATE OF realm_id, installation_id, store_id, store_epoch
ON store_binding
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_STORE_BINDING');
END;

CREATE TRIGGER tr_schema_migration_no_update
BEFORE UPDATE ON schema_migration
BEGIN
  SELECT RAISE(ABORT, 'APPEND_ONLY_SCHEMA_MIGRATION');
END;

CREATE TRIGGER tr_schema_migration_no_delete
BEFORE DELETE ON schema_migration
BEGIN
  SELECT RAISE(ABORT, 'APPEND_ONLY_SCHEMA_MIGRATION');
END;

CREATE TRIGGER tr_source_effect_no_update
BEFORE UPDATE ON source_effect
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_SOURCE_EFFECT');
END;

CREATE TRIGGER tr_source_effect_no_delete
BEFORE DELETE ON source_effect
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_SOURCE_EFFECT');
END;

CREATE TRIGGER tr_batch_item_no_update
BEFORE UPDATE ON outbox_batch_item
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_BATCH_ITEM');
END;

CREATE TRIGGER tr_batch_item_no_delete
BEFORE DELETE ON outbox_batch_item
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_BATCH_ITEM');
END;

CREATE TRIGGER tr_batch_content_immutable
BEFORE UPDATE OF contract_version, compression, event_count,
                 first_event_seq, last_event_seq, uncompressed_length,
                 compressed_length, batch_content_sha256, wire_body_sha256,
                 created_utc_ms, sealed_utc_ms
ON outbox_batch
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_BATCH_CONTENT');
END;

CREATE TRIGGER tr_event_identity_immutable
BEFORE UPDATE OF event_seq, source_id, source_generation_id, native_visit_id,
                 interpretation_id, event_contract_version,
                 payload_content_sha256, payload_plaintext_length, created_utc_ms
ON outbox_event
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_EVENT_IDENTITY');
END;

CREATE TRIGGER tr_receipt_authority_immutable
BEFORE UPDATE OF receipt_id, batch_id, receipt_contract_version,
                 batch_content_sha256, wire_body_sha256, custody_state,
                 durable_at_utc_ms, failure_domain_class,
                 failure_domain_id_hash, authenticated_peer_hash,
                 receipt_body_sha256, accepted_attempt_id
ON delivery_receipt
BEGIN
  SELECT RAISE(ABORT, 'IMMUTABLE_RECEIPT_AUTHORITY');
END;
```

## 5.10 Domain-verifier queries and non-SQL assertions

SQLite constraints cannot recompute cryptographic hashes, decrypt payloads, prove canonical batch bytes, or express every cross-row transition. The writer runs a release-owned verifier at startup, after migration/restore, and under fault tests. Any unexpected row enters `INTEGRITY_HOLD`.

Minimum SQL checks:

```sql
PRAGMA foreign_key_check;
PRAGMA integrity_check;

-- One current generation, and it is active or baseline-pending.
SELECT s.source_id
FROM source AS s
LEFT JOIN source_generation AS g
  ON g.realm_id = s.realm_id
 AND g.installation_id = s.installation_id
 AND g.source_id = s.source_id
 AND g.source_generation_id = s.current_generation_id
WHERE s.current_generation_id IS NOT NULL
  AND (g.source_generation_id IS NULL
       OR g.generation_state NOT IN ('ACTIVE','BASELINE_PENDING'));

-- Every event effect has exactly one matching outbox event and stable event ID.
SELECT e.source_id, e.source_generation_id, e.native_visit_id
FROM source_effect AS e
LEFT JOIN outbox_event AS o
  ON o.realm_id = e.realm_id
 AND o.installation_id = e.installation_id
 AND o.event_id = e.event_id
WHERE e.effect_kind = 'MINIMIZED_EVENT'
  AND (o.event_id IS NULL
       OR o.source_id <> e.source_id
       OR o.source_generation_id <> e.source_generation_id
       OR o.native_visit_id <> e.native_visit_id);

-- No no-event effect has an outbox event.
SELECT e.source_id, e.source_generation_id, e.native_visit_id
FROM source_effect AS e
JOIN outbox_event AS o
  ON o.realm_id = e.realm_id
 AND o.installation_id = e.installation_id
 AND o.source_id = e.source_id
 AND o.source_generation_id = e.source_generation_id
 AND o.native_visit_id = e.native_visit_id
WHERE e.effect_kind = 'CONSUMED_NO_EVENT';

-- Batch membership count and sequence envelope.
SELECT b.batch_id
FROM outbox_batch AS b
LEFT JOIN (
  SELECT realm_id, installation_id, batch_id,
         COUNT(*) AS c, MIN(event_seq) AS mn, MAX(event_seq) AS mx
  FROM outbox_batch_item
  GROUP BY realm_id, installation_id, batch_id
) AS i
  ON i.realm_id = b.realm_id
 AND i.installation_id = b.installation_id
 AND i.batch_id = b.batch_id
WHERE i.c IS NULL OR i.c <> b.event_count
   OR i.mn <> b.first_event_seq OR i.mx <> b.last_event_seq;

-- BATCHED/ACK events have exactly one membership in current batch.
SELECT o.event_id
FROM outbox_event AS o
LEFT JOIN outbox_batch_item AS i
  ON i.realm_id = o.realm_id
 AND i.installation_id = o.installation_id
 AND i.batch_id = o.current_batch_id
 AND i.event_id = o.event_id
WHERE o.delivery_state IN ('BATCHED','ACKNOWLEDGED','CLEANUP_ELIGIBLE','HELD')
  AND i.event_id IS NULL;

-- Receipt, batch, and acknowledged event bindings agree.
SELECT o.event_id
FROM outbox_event AS o
JOIN delivery_receipt AS r
  ON r.realm_id = o.realm_id
 AND r.installation_id = o.installation_id
 AND r.receipt_id = o.acknowledged_receipt_id
JOIN outbox_batch AS b
  ON b.realm_id = o.realm_id
 AND b.installation_id = o.installation_id
 AND b.batch_id = o.current_batch_id
WHERE o.delivery_state IN ('ACKNOWLEDGED','CLEANUP_ELIGIBLE')
  AND (r.batch_id <> b.batch_id
       OR r.batch_content_sha256 <> b.batch_content_sha256
       OR r.wire_body_sha256 <> b.wire_body_sha256);

-- Purged payloads must remain acknowledged and receipt-bound.
SELECT event_id
FROM outbox_event
WHERE payload_state = 'PURGED'
  AND (delivery_state NOT IN ('ACKNOWLEDGED','CLEANUP_ELIGIBLE')
       OR acknowledged_receipt_id IS NULL);

-- Cursor/page relation.
SELECT c.source_id, c.source_generation_id
FROM source_checkpoint AS c
LEFT JOIN page_commit AS p
  ON p.realm_id = c.realm_id
 AND p.installation_id = c.installation_id
 AND p.page_id = c.last_committed_page_id
WHERE c.last_committed_page_id IS NOT NULL
  AND (p.page_id IS NULL
       OR p.source_id <> c.source_id
       OR p.source_generation_id <> c.source_generation_id
       OR p.page_advance_to <> c.high_native_visit_id
       OR p.checkpoint_version_after <> c.checkpoint_version);
```

The non-SQL verifier MUST additionally prove:

- every page command hash matches a deterministic reconstruction of its durable effects and page fields;
- every event ciphertext authenticates with its key/AAD and decrypts to bytes matching `payload_content_sha256` and exact length/schema;
- every batch item order and event payload reconstructs the canonical uncompressed batch and both content/wire hashes;
- every batch ciphertext authenticates with its key/AAD and contains the exact compressed body;
- no `(key_id, nonce)` repeats across current or retained key metadata;
- receipt body digest and authenticated peer/failure-domain evidence match the receipt contract;
- all state transitions are legal according to section 6;
- each cleanup selection contains only receipt-bound, grace-eligible, non-held objects under trusted clock state;
- schema SQL hash, migration ledger, `user_version`, compatibility floor, and release manifest agree;
- logical byte/event counters equal recomputed bounded counts;
- no table contains forbidden field names, extension blobs, SQL, raw activity, or dynamic metric labels.

## 5.11 Encryption envelope

For each payload object:

```text
DEK            = 256 random bits generated by approved CSPRNG
nonce          = 96 random bits; unique for this DEK and object purpose
AAD            = encode_v1(
                   realm_id,
                   installation_id,
                   store_id,
                   store_epoch,
                   object_kind,
                   object_id,
                   schema_or_contract_version,
                   content_sha256,
                   plaintext_length)
ciphertext,tag = AES-256-GCM(DEK, nonce, plaintext, AAD, tag_length=128 bits)
```

`.NET AesGcm` supports the selected AES-GCM profile, and the reviewed cross-platform documentation records 12-byte nonces and 16-byte tags on Windows [W17–W18]. Nonce uniqueness is mandatory; randomness is not treated as proof by itself. The database has unique indexes, the crypto service checks collision before commit, and the test suite forces collisions.

DEKs are purpose-separated for event payloads, batch wire bodies, and optional policy artifact encryption. They are wrapped by a machine-scoped CNG key. Candidate wrapping profile: nonexportable RSA key under Microsoft Platform Crypto Provider when a healthy TPM and required OAEP-SHA256 operation are proved; otherwise a tightly ACLed nonexportable Microsoft Software Key Storage Provider key. Exact key size/provider/flags/ACL/attestation/recovery are execution-time profiles and human assurance decisions [W20–W23].

A key reference is never deleted while any event, batch, backup, or migration evidence refers to it. Rotation is additive: new `ACTIVE`, old `DECRYPT_ONLY`, new writes use the new key, bounded maintenance may re-encrypt retained payloads, and retirement occurs only after zero references and backup/recovery decisions.

## 5.12 Metadata leakage register

Application payload encryption does **not** conceal:

- database existence, approximate file/WAL size, write timing, checkpoint timing, free pages, and backup timing;
- counts of sources, effects, events, batches, attempts, receipts, failures, and migrations;
- UUIDs, local sequences, state values, timestamps, reason codes, contract/profile hashes, ciphertext lengths, and key-reference metadata;
- source/generation locator digests and local progress values;
- process memory while decrypting or sending;
- data observed by a local administrator, injected trusted code, debugger, kernel/EDR, pagefile/hibernation/hypervisor capture, or authorized support tool.

**RECOMMENDATION.** Treat payload encryption as minimization of ordinary at-rest disclosure and backup/WAL handling, not as protection from the machine owner. A requirement to hide metadata/pages from ordinary file readers is the trigger to evaluate SQLCipher/SEE, not to overclaim column encryption.

---
# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 SQLite runtime profile

The runtime profile is a release-owned, hash-addressed object. Exact numeric budgets are populated from measurement; the following semantic settings are mandatory.

| Setting/control | Required value or rule | Rationale/evidence |
|---|---|---|
| loaded native identity | exact file hash, `sqlite_version()`, `sqlite_source_id()`, compile options, VFS | managed package version does not prove native binary; current reviewed source is 3.53.4 [W01] |
| `PRAGMA journal_mode` | set and verify `wal` | accepted baseline and explicit checkpoint/recovery model [W02] |
| `PRAGMA synchronous` | set and verify `FULL` | latest commit survives documented WAL power-loss model; NORMAL may lose latest commits [W02–W03] |
| `PRAGMA foreign_keys` | `ON`, set outside transaction and verify | SQLite does not guarantee default; FK enforcement is part of correctness [W03, W12] |
| `PRAGMA trusted_schema` | `OFF` | reduces use of application functions/virtual tables in schema expressions [W03] |
| `sqlite3_db_config(SQLITE_DBCONFIG_DEFENSIVE)` | `ON`, verify return/effective value | disallows dangerous ordinary schema/database operations |
| load extension | disabled in provider/native API and no extension entry point in storage assembly | no dynamic code/SQL capability |
| DQS DDL/DML | disabled through exact native profile | removes legacy double-quoted string ambiguity |
| `SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE` | `ON`, verified | prevents hidden last-close checkpoint; application owns checkpoint timing |
| `PRAGMA wal_autocheckpoint` | `0` | disables unmeasured default 1000-page PASSIVE auto-checkpoint [W03–W04] |
| `PRAGMA recursive_triggers` | `OFF` | schema uses narrow nonrecursive guard triggers |
| `PRAGMA temp_store` | `MEMORY` | avoids product-created plaintext temp files; memory budget is measured |
| `PRAGMA mmap_size` | `0` initially | simplifies memory/AV/fault analysis and reduces mapped ciphertext/payload exposure; may change only by evidence |
| provider pooling | disabled | enforces single connection/owner; provider pooling defaults can otherwise preserve hidden connections [W16] |
| shared cache | disabled | unnecessary and discouraged with WAL in the reviewed provider guidance [W16] |
| busy timeout | zero for ordinary writer operations | an ordinary write busy indicates another connection/ownership defect; checkpoints classify busy readers separately |
| `PRAGMA auto_vacuum` | `INCREMENTAL` fixed before first schema creation, candidate pending measurement | supports bounded OS-space return without full VACUUM [W03] |
| `PRAGMA page_size` | release profile, initial candidate 4096, fixed before WAL | current default is commonly 4096; exact page size is measured and immutable per store |
| `PRAGMA max_page_count` | derived hard DB ceiling | engine-enforced last boundary; not the only logical quota |
| `PRAGMA journal_size_limit` | measured finite WAL retention ceiling | prevents persistent oversized WAL after checkpoint |
| `PRAGMA secure_delete` | `OFF` initially | payload is ciphertext; secure deletion does not cover WAL/backups/SSD and adds writes. A metadata-remanence requirement is a human/ADR trigger |
| `PRAGMA application_id` | release-owned UAM constant verified against the SQLite application-ID registry | rejects opening an unrelated SQLite file; exact value recorded in ADR/tooling |
| `PRAGMA user_version` | schema version mirror | convenience only; migration ledger/schema hash remain authoritative |
| `PRAGMA optimize` | after schema/index change and bounded periodic maintenance | SQLite-recommended statistics maintenance [W03] |
| `PRAGMA quick_check` | unclean startup/periodic trigger | fast engine check; not a replacement for full/domain/FK verification |
| `PRAGMA integrity_check` + `foreign_key_check` | pre-release gate, restore/migration/corruption trigger, periodic approved maintenance | broader engine/index/constraint evidence; can be costly [W03] |

The writer verifies effective values after every open and after a provider/native upgrade. An unsupported mandatory setting is `STORE_RUNTIME_PROFILE_UNSUPPORTED`, not a warning or fallback.

## 6.2 Store startup state machine

```text
CLOSED or process absent
  -> OPENING
       -> validate directory/ACL/reparse/file manifest
       -> load exact provider/native identity
       -> apply and verify runtime profile
       -> bind realm/installation/store/application/schema
       -> mark clean_shutdown = 0
       -> resolve migration/key/attempt/cleanup/backup states
       -> quick/full/domain checks as triggered
       -> verify reserve/quota/clock/policy
           -> READY
           -> PAUSED_DISK
           -> PAUSED_POLICY
           -> KEY_HOLD
           -> INTEGRITY_HOLD
           -> CORRUPTION_HOLD
           -> REALM_CHANGE_HOLD
```

Startup recovery rules:

1. `PREPARED`, `OUTCOME_UNKNOWN`, or process-abandoned attempts mean custody is unknown. The same batch is eligible for status query/replay; no new batch is created.
2. `IN_FLIGHT_UNKNOWN` batch without a receipt remains immutable and retryable.
3. a page is either fully visible after commit or absent; no application repair updates a partially observed page.
4. incomplete transactional DDL is rolled back by SQLite; resumable backfill uses the migration-step ledger.
5. `clean_shutdown=0` increases integrity/checkpoint scrutiny but does not itself mean corruption.
6. any key reference whose wrapping key cannot be opened enters `KEY_HOLD`; the store does not delete or recreate ciphertext.
7. schema hash/ledger/user-version disagreement enters `INTEGRITY_HOLD`.
8. a wrong realm/install/store epoch enters `REALM_CHANGE_HOLD` before any ordinary query.

## 6.3 Store shutdown

```text
READY/PAUSED/HOLD
  -> DRAINING
       stop accepting new page/batch/attempt commands
       cancel transport after bounded grace; preserve prepared attempt
       finish or roll back active SQLite transaction
       persist final attempt/result observations already available
       run bounded checkpoint selected by policy
       run mandatory domain/FK quick verifier
       set clean_shutdown = 1 and store_state = CLOSED in final transaction
       optional bounded TRUNCATE checkpoint
       close connection and crypto handles
  -> CLOSED
```

A failed final checkpoint is recorded but does not authorize force-deleting WAL. If the final verification or close path is uncertain, leave `clean_shutdown=0` or a hold state. Service-control timeout causes process termination; the next startup performs unclean recovery. No shutdown path waits indefinitely for network or a reader.

## 6.4 Atomic page transaction

### 6.4.1 Transaction boundary

All command-shape, schema, field, size, canary, digest, page-order, and permit checks that require no durable read occur before `BEGIN IMMEDIATE`. The writer then rechecks all durable preconditions inside one transaction.

```text
FUNCTION CommitPage(command):
  assert writer actor and expected authenticated realm/install
  validate closed command, bounds, canonical payloads, hashes, canaries
  compute page_command_sha256

  BEGIN IMMEDIATE

  binding = load store_binding singleton
  require binding.store_state in {READY, PAUSED_DISK only for receipt/recovery, PAUSED_POLICY as policy permits}
  require exact realm/install/store/schema/runtime

  existing_page = find page_commit(page_id)
  IF existing_page exists:
      require existing_page.page_command_sha256 == page_command_sha256
      reconstruct and return stable committed result
      COMMIT read-equivalent transaction
      RETURN

  source_generation = load exact active generation
  checkpoint = load exact checkpoint
  require checkpoint.checkpoint_version == command.checkpointVersionObserved
  require checkpoint.high_native_visit_id == command.checkpointBefore
  require command interpretation/source capability/permit still active and matching

  insert collection_run if new or verify same immutable run
  insert page_commit with known effect counts and checkpoint before/after

  next_event_seq = binding.next_event_seq
  FOR each row in strict native-id order:
      existing_effect = find by natural key
      IF existing_effect exists:
          require same effect_kind and effect_digest
          require event ID and payload hash agree when event
          add prior result; continue

      IF row is CONSUMED_NO_EVENT:
          insert immutable source_effect with reason/digest
      ELSE:
          event_id = mint UUIDv7 once
          event_seq = next_event_seq; next_event_seq++
          encrypt canonical minimized payload before bind
          insert immutable source_effect(event_id, natural key, digest)
          insert outbox_event(READY, PRESENT, ciphertext, key/AAD metadata)
      insert/update same-interpretation bounded overlap witness

  compare-and-swap source_checkpoint by expected checkpoint_version
  require exactly one row changed
  update generation observed high-water if greater
  update collection_run to COMMITTED
  update store_binding.next_event_seq and row_version

  run cheap in-transaction rowcount/natural-key/page/checkpoint assertions
  COMMIT

  clear plaintext and return stable result
END
```

### 6.4.2 Required outcomes

| Failure point | Durable result |
|---|---|
| before `BEGIN` | no row/state change |
| after any insert/update but before commit | SQLite rollback; prior checkpoint/effects remain |
| power/process loss during commit | either complete prior state or complete new page state under WAL/FULL; never application-accepted intermediate state |
| after commit before result/IPC ACK | retry returns same effect/event IDs and checkpoint |
| same page ID, changed command hash | invariant hold |
| same natural key, changed effect digest | source/store identity-conflict hold; no overwrite |
| stale checkpoint version | reject entire page; no effect/advance |
| disk full at any precommit write | rollback; pause; no cursor advance |

## 6.5 Batch construction and immutable seal

Batch construction is serialized inside the writer actor but avoids holding a write transaction while performing bounded decryption/compression.

```text
FUNCTION BuildNextBatch(profile):
  require batching enabled, store not held, keys available
  candidate = select earliest READY events within count/plain/compressed-age planning ceilings
  IF none: return NO_WORK

  while holding the actor's exclusive logical turn:
      decrypt each candidate payload to bounded memory
      verify event hash/schema/AAD
      construct canonical batch body in event_seq order
      compute content hash
      compress using pinned deterministic profile
      compute exact wire hash
      encrypt exact wire body at rest with active batch key
      mint batch_id and read proposed batch_seq

      BEGIN IMMEDIATE
      re-read every candidate by ID, state, event_seq, content hash and key reference
      require all still READY and no current batch
      insert outbox_batch in SEALED state with exact immutable metadata/ciphertext
      insert ordered outbox_batch_item rows
      update every event READY -> BATCHED and set current_batch_id
      advance next_batch_seq
      require changed event count == batch event_count
      COMMIT

  clear plaintext/compressed buffers
  return SEALED batch summary
END
```

A process crash before the transaction leaves all events READY. A crash during the transaction leaves either all READY or one complete sealed batch. There is no durable `BUILDING` state and no orphan reservation to repair. Exact count/byte/age limits are bounded bootstrap estimates until measured.

A sealed batch is immutable. If a later contract cannot accept it, the batch enters `HELD_CONTRACT`. Ordinary code does not unbatch or rebuild it. A future supersession feature requires authenticated authoritative proof of **no durable custody**, a new ADR, explicit old/new linkage, and server/idempotency tests.

## 6.6 Attempt preparation, send, lost response, receipt, and replay

### 6.6.1 Prepare attempt transaction

```text
BEGIN IMMEDIATE
  select oldest SEALED or due RETRY_WAIT batch not held
  verify exact wire ciphertext/key/AAD/hash and size
  allocate attempt_no = max(batch attempts) + 1
  mint attempt_id
  insert delivery_attempt(PREPARED, wire hash, prepared time)
  set batch_state = IN_FLIGHT_UNKNOWN
COMMIT
return exact decrypted wire body lease only after commit
```

`PREPARED` deliberately means “may be sent.” This closes the dangerous gap in which bytes could leave without durable ambiguity evidence.

### 6.6.2 Transport outside transaction

The transport worker:

1. verifies the exact body hash and size;
2. writes only the bounded authenticated HTTPS request;
3. never changes body, batch ID, compression, headers covered by contract, or event order on retry;
4. applies cancellation/timeouts without deleting attempt/batch state;
5. returns finite transport metadata and a bounded receipt body, never an exception dump or raw proxy response.

### 6.6.3 Result application

| Observation | Attempt transition | Batch transition | Payload action |
|---|---|---|---|
| timeout, connection reset, process loss, 2xx without valid receipt | `OUTCOME_UNKNOWN` | `IN_FLIGHT_UNKNOWN` then bounded query/replay | none |
| explicit retryable status with no valid receipt | `RETRYABLE` | `RETRY_WAIT` | none |
| local cancel/shutdown after prepare | `OUTCOME_UNKNOWN` or `CANCELLED` only if no handoff was provably made | immutable/retry | none |
| authentication/authorization failure | `AUTH_HOLD` | `HELD_AUTH` | none |
| unsupported contract/semantic rejection without custody receipt | `CONTRACT_HOLD` | `HELD_CONTRACT` | none; do not infer no custody |
| valid matching receipt | `RECEIPT_OBSERVED` | `RECEIPTED` | mark member events acknowledged |
| malformed/mismatched/conflicting receipt | invariant/security failure | `HELD_RECEIPT_CONFLICT` | none; quarantine observation |

### 6.6.4 Receipt transaction

```text
FUNCTION ApplyReceipt(attempt_id, authenticated_context, receipt_bytes):
  strict-parse and bound receipt outside transaction
  verify expected peer/channel identity and allowed failure-domain profile
  compute receipt body digest

  BEGIN IMMEDIATE
    load attempt and exact batch
    require receipt batch_id/content_hash/wire_hash/contract/custody match
    existing = receipt for batch

    IF existing exists:
       require every authoritative field is identical
       increment observation_count and last_observed time
    ELSE:
       insert delivery_receipt bound to attempt and authenticated peer

    mark attempt RECEIPT_OBSERVED with receipt digest
    mark batch RECEIPTED and receipted time
    mark all current batch events ACKNOWLEDGED with same receipt and time
    require changed member count == batch.event_count
    require every member digest/order still matches sealed batch
  COMMIT
END
```

A crash before commit leaves the batch unknown/retryable. A crash after commit but before transport sees completion causes the same receipt to be re-applied idempotently. A status query and a send response use the same function.

## 6.7 ACK replay grace and cleanup

**HUMAN DECISION.** Grace is tied to server receipt durability, endpoint/server backup RPO, support/replay needs, and legal retention. Until approved, `cleanup_enabled=false`; acknowledged ciphertext remains bounded by the human disk decision.

When approved, cleanup eligibility requires all of:

```text
matching receipt exists
AND receipt failure-domain profile is currently allowed
AND event/batch is not held or quarantined
AND active cleanup policy references the receipt contract/version
AND clock_confidence = TRUSTED
AND now >= approved cleanup_not_before
AND backup/replay/RPO predicate is satisfied
AND key-reference plan is valid
```

Cleanup transaction:

```text
BEGIN IMMEDIATE
  create cleanup_run PREPARED with policy and deterministic selection digest
  reselect exact bounded batch/event IDs and re-evaluate every predicate
  update selected event payload_state PRESENT -> PURGED; null ciphertext/key/nonce/tag
  keep event ID, natural linkage, hashes, batch, receipt, timestamps and state evidence
  update selected batch state -> PAYLOAD_PURGED; null wire ciphertext/key/nonce/tag
  update key reference evidence; never remove key still referenced
  update cleanup_run COMMITTED with counts/bytes
COMMIT
```

This is logical payload removal, not guaranteed physical erasure. Ciphertext may remain in free pages, old WAL segments, backups, SSD remapping, crash captures, or security tooling. A later checkpoint and bounded incremental vacuum may return space, but must not be described as secure wipe. Key retirement can make retained ciphertext unavailable only after every approved recovery/backup dependency is resolved.

## 6.8 Event state machine

```text
READY + payload PRESENT
  -> BATCHED + payload PRESENT
      -> ACKNOWLEDGED + payload PRESENT
          -> CLEANUP_ELIGIBLE + payload PRESENT
              -> CLEANUP_ELIGIBLE + payload PURGED

Any pre-cleanup state -> HELD + payload PRESENT
HELD -> prior safe state only through authorized repair/revalidation
```

| Transition | Preconditions | Transaction | Illegal behavior |
|---|---|---|---|
| new effect -> READY | page/natural identity/payload valid; active key | page transaction | event without effect; cursor before event |
| READY -> BATCHED | sealed immutable batch contains event exactly once | batch transaction | two current batches; order/hash change |
| BATCHED -> ACKNOWLEDGED | matching receipt for current batch | receipt transaction | HTTP status as ACK; mismatched receipt |
| ACKNOWLEDGED -> CLEANUP_ELIGIBLE | approved grace/RPO/clock/no hold | bounded cleanup-selection transaction or state marking | implicit default grace |
| PRESENT -> PURGED | still eligible; selection digest; receipt linkage | cleanup transaction | deleting identity/tombstone or unacknowledged payload |
| any -> HELD | crypto/invariant/receipt/security problem | containment transaction | auto-unhold or payload deletion |

## 6.9 Batch state machine

```text
SEALED
  -> IN_FLIGHT_UNKNOWN
       -> RECEIPTED
       -> RETRY_WAIT -> IN_FLIGHT_UNKNOWN
       -> HELD_AUTH
       -> HELD_CONTRACT
       -> HELD_RECEIPT_CONFLICT

RECEIPTED -> CLEANUP_ELIGIBLE -> PAYLOAD_PURGED

HELD_AUTH -> SEALED/RETRY_WAIT only after authenticated recovery
HELD_CONTRACT -> send only after compatible consumer/release decision
HELD_RECEIPT_CONFLICT -> no automatic exit
```

`PAYLOAD_PURGED` is terminal for local wire bytes but retains immutable batch identity, event membership, hashes, receipt link, and cleanup evidence. A batch in any unknown or held state is never rebuilt or deleted by ordinary maintenance.

## 6.10 Attempt and receipt state machines

```text
PREPARED
  -> RECEIPT_OBSERVED
  -> RETRYABLE
  -> OUTCOME_UNKNOWN
  -> AUTH_HOLD
  -> CONTRACT_HOLD
  -> CANCELLED (only before transport handoff is proved)
```

An attempt is append-only evidence except its finite state/timestamps/result fields. Attempts are never reused. Retries create a new attempt ID/number against the same batch.

```text
No receipt
  -> DURABLY_RECEIVED receipt recorded
      -> repeat identical observation (count++)
      -> conflicting observation -> receipt-conflict hold
```

There is at most one authoritative receipt record per batch. Duplicate observations update count/last-observed only; authority fields are immutable.

## 6.11 Store, key, migration, backup, quarantine, and cleanup states

### Store

```text
NEW -> OPENING -> READY
READY -> PAUSED_DISK | PAUSED_POLICY | MIGRATING | DRAINING
any ordinary state -> KEY_HOLD | INTEGRITY_HOLD | CORRUPTION_HOLD | REALM_CHANGE_HOLD
DRAINING -> CLOSED
hold -> READY only through named recovery verifier and authorized transition
```

### Key

```text
CREATED -> ACTIVE -> DECRYPT_ONLY -> RETIRED
any usable state -> HOLD
missing/unrecoverable -> LOST
```

Only one active key per purpose. `RETIRED` means zero live references under approved backup/recovery policy. `LOST` does not trigger deletion/recreation; it triggers incident/recovery.

### Migration

```text
PREPARED -> BACKUP_VERIFIED -> APPLYING -> VERIFYING -> APPLIED
                    \-> ROLLED_BACK
any stage -> FAILED_HOLD
```

A transactional expand step is all-or-none. Backfill chunks commit progress and data together. Contract steps require rollback-window closure and old-reader exclusion.

### Backup

```text
CREATING -> VERIFIED -> RESTORED_TESTED
    \-> QUARANTINED
VERIFIED/RESTORED_TESTED -> DELETED only by retention authority
```

### Quarantine

```text
OPEN -> PRESERVED -> REPAIRED | SUPERSEDED | DELETED_BY_AUTHORITY
```

No automatic transition out of `OPEN` or `PRESERVED`.

### Cleanup run

```text
PREPARED -> APPLYING -> COMMITTED
     \-> DEFERRED
     \-> FAILED_HOLD
```

A crash before commit yields no payload-state change. A crash after commit yields a complete cleanup run; startup re-verifies counts and references.

## 6.12 WAL and checkpoint algorithm

**FACT.** In WAL mode, commits append to WAL; checkpoints copy frames to the database. PASSIVE does not wait for readers, FULL waits for writers/readers according to documented rules, RESTART also ensures readers are off the WAL, and TRUNCATE additionally truncates the WAL on success [W02, W04].

**RECOMMENDATION.** Disable auto-checkpoint and use one controller:

```text
After commit:
  update in-memory WAL frame/byte/age estimates from exact APIs/file metadata
  if below soft threshold: no checkpoint
  if soft threshold or maintenance interval reached:
      enqueue PASSIVE checkpoint at maintenance priority
  if hard threshold approached and no active reader/backup:
      pause new page/batch commits
      run bounded FULL then RESTART checkpoint
  if clean shutdown or controlled reclaim and safe:
      run bounded TRUNCATE checkpoint
  if checkpoint reports BUSY:
      identify unexpected reader/operation, keep WAL, retry with bounded backoff
  if IOERR/FULL/CORRUPT:
      pause/hold according to taxonomy; never delete WAL
```

Thresholds use replaceable inputs: DB page size, free-space reserve, maximum commit burst, backup duration, measured checkpoint throughput/latency, and human disk/SLO budgets. No numeric threshold in source code is treated as production-approved without evidence.

No long-lived reader is permitted. Backup/integrity operations declare their read lifetime to the controller. A checkpoint cannot block indefinitely and cannot kill an unknown process to force progress.

## 6.13 Busy handling

- `BEGIN IMMEDIATE` returning `SQLITE_BUSY` in the one-writer design is an invariant/environment signal, not a normal contention loop.
- The writer records a finite code, identifies loaded connections/handles in restricted lab evidence, and performs at most a small bounded retry only for a known self-owned maintenance reader.
- Checkpoint `BUSY` is expected when an approved reader is active; the controller defers and records frame counts.
- No `busy_timeout` hides an external process, leaked pooled connection, or antivirus/file-lock problem.
- Transport retries are independent of SQLite busy behavior.

## 6.14 Disk governor, reserve, quotas, and no-silent-loss rule

The governor uses both physical and logical measurements:

```text
physical:
  volume free bytes
  db/wal/shm/reserve/backup/quarantine allocated bytes
  filesystem allocation unit and sparse/compression state
logical:
  unacknowledged event count and ciphertext bytes
  sealed/unknown/held batch count and wire bytes
  oldest unacknowledged age bucket
  pending page/batch/attempt queue sizes
  free-list pages and max_page_count headroom
```

A product-owned, ACL-protected, non-sparse `recovery.reserve` file is allocated and verified during healthy operation. Exact size is a **HUMAN DECISION / CLI EXPERIMENT**. It exists solely to permit receipt recording, cleanup of already acknowledged payloads, checkpoint/recovery metadata, and safe shutdown when ordinary free space is exhausted.

```text
NORMAL
  -> SOFT_PRESSURE: stop/slow new collection scheduling; keep page retry semantics
  -> HARD_PRESSURE: pause page commits and batch construction; prioritize receipts/checkpoints
  -> RESERVE_RELEASED: release reserve once under writer/operations control
  -> PAUSED_DISK: no new collection until free margin and reserve are restored
  -> DISK_HOLD: IO/full behavior uncertain or recovery writes cannot complete
```

Rules:

1. reserve release is an evidence-bearing state transition, not an ad hoc file deletion;
2. reserve is not recreated until the approved healthy margin exists;
3. unacknowledged/unknown/held payload is never deleted to regain space under the conservative default;
4. acknowledged cleanup runs only when already authorized by grace/RPO and must not weaken the receipt predicate under pressure;
5. backups/quarantine cannot consume the operational reserve without preflight and separate space budget;
6. SQLite `max_page_count` is the final engine ceiling; the governor pauses earlier;
7. an approved future loss policy must create an explicit auditable terminal state and cannot be smuggled in as “cleanup.”

## 6.15 Antivirus, EDR, controlled-folder, and filesystem interference

The store treats these as environmental failure modes, not reasons to weaken ACLs or add exclusions automatically.

| Trigger | Classification | Containment | Recovery |
|---|---|---|---|
| sharing violation/access denied on DB/WAL/SHM/reserve | retry only if known transient; then `PAUSED_DISK`/I/O hold | stop new commits; preserve file set | security/endpoint owner verifies product/filter behavior; resume after exact self-test |
| delayed close/rename/delete by scanner | bounded maintenance defer | do not force-delete or rename live WAL | retry after process/filter evidence; no broad exclusion by code |
| apparent successful write but failed durability/power test | `STORE_IO_DURABILITY_UNKNOWN` | stop support claim for capability | storage/VM profile excluded or compensated by stronger mechanism |
| crash dump/memory capture containing plaintext | privacy incident candidate | disable affected diagnostics/source/ring | delete/contain under incident authority; update dump policy/canaries |
| scanner causes checkpoint starvation/latency | pause/threshold breach | keep WAL and data; no source loss | measured configuration decision by endpoint security |

A lab uses per-process filesystem tracing and deliberately planted positive controls. Shareable evidence contains operation categories/counts and opaque hashes, not paths, payloads, users, hosts, or security-product secrets.

## 6.16 Corruption detection, containment, recovery, and cleanup

### Detection

- SQLite extended result codes `CORRUPT`, `NOTADB`, `IOERR_*`, `FULL`, `READONLY`, constraint failures, and unexpected `BUSY` are mapped to finite UAM codes [W10].
- unclean startup runs `quick_check`, FK check, and UAM domain verifier; severe/uncertain results escalate to full integrity check.
- migrations, restores, native/provider upgrades, and reported anomalies run full integrity/FK/domain checks.
- periodic checks and their cost are measured; a green engine check never replaces domain/hash/crypto validation.

### Containment

1. stop page commits, batching, transport, cleanup, migrations, rotation, and ordinary support reads;
2. close the writer without checkpointing or mutating further when corruption is suspected;
3. after process stop, hash and preserve the complete DB/WAL/SHM/manifest/reserve evidence set in the protected quarantine area;
4. record only an opaque incident token and value-free codes in ordinary health;
5. do not delete, copy live, run `.recover` on the original, or create a new store automatically.

### Recovery order

1. verify environment, file identities, realm/store binding, keys, and source of corruption;
2. prefer a verified backup whose schema/key set and restore drill pass;
3. restore into a new protected directory/store-readiness state, never over the quarantined original;
4. run exact runtime profile, integrity/FK/domain/crypto/hash checks;
5. reconcile batch receipts/status with the authenticated server before transport or cleanup;
6. replay immutable unacknowledged batches from the restored state;
7. re-acquire source rows only under existing G2–G4 rules and stable natural identity; never invent cursor progress;
8. if no verified recovery is possible, remain held and record explicit data-loss uncertainty. Human authority decides next steps.

SQLite's recovery extension and `.recover` are incident/lab tools only [W09]. Salvaged rows are untrusted candidates requiring full schema/domain/receipt/key reconciliation and may never overwrite the original evidence.

## 6.17 Backup algorithm

```text
FUNCTION CreateVerifiedBackup(kind):
  require approved backup kind/policy and sufficient non-reserve space
  drain writer command queue; no active transaction or long reader
  create store_backup(CREATING) record and opaque destination token
  use SQLite Online Backup from writer-owned source connection
  require backup_step reaches DONE and finish returns OK
  fsync/close according to exact Windows/provider profile
  hash backup file and manifest; bind schema/store epoch/key-set digest
  open destination read-only under exact runtime profile
  run quick/full/FK/domain and sampled decrypt/hash checks
  mark VERIFIED only after all pass
  optionally restore-test in disposable directory and mark RESTORED_TESTED
END
```

A live file copy of DB/WAL/SHM is not a backup. Periodic backup frequency, destination, access, encryption, retention, and RPO remain human decisions. Pre-migration backup is mandatory for migrations whose rollback cannot be proved transactionally within the active N/N-1 store.

## 6.18 Expand/contract migration and N/N-1 compatibility

### Rules

1. every migration has an immutable ID, hash, kind, from/to version, minimum reader, release ID, plan, verifier, rollback statement, and test fixtures for every durable state;
2. release N+1 MUST open schema N before applying an expand migration;
3. expand adds compatible tables/columns/indexes without removing old representation;
4. backfill is bounded and resumable; each chunk writes data and `migration_step.progress_key` in the same transaction;
5. while rollback is required, N and N+1 read/write a compatibility representation defined by the ADR; no hidden dual-write drift;
6. contract removal occurs only after the N/N-1 rollback window is formally closed, old binaries are excluded, verified backup exists, and the contract flag is authorized;
7. schema version, compatibility floor, schema SQL hash, migration ledger, and release manifest must agree;
8. migrations run only in `MIGRATING` with transport/page commits/cleanup paused as specified;
9. tenant policy cannot initiate or parameterize SQL;
10. exact point-in-time SQLite ALTER capabilities do not replace an explicit migration plan [W11].

### Crash behavior

| Failure | Expected state |
|---|---|
| before migration-run commit | old schema/state, no run |
| during transactional DDL | old or complete new expand schema; ledger agrees |
| after DDL before ledger in same transaction | impossible by design; one transaction |
| during backfill chunk | prior committed progress/data only; repeat same next chunk |
| after all steps before verification | `VERIFYING`; ordinary work remains disabled |
| verification failure | `FAILED_HOLD`; restore/roll-forward decision, no auto-recreate |
| rollback to N while schema compat floor <= N | old release opens and passes all-state tests |
| rollback when floor > N | updater/launcher blocks old release and requires forward recovery; no downgrade execution |

### Key rotation separation

Schema migration does not implicitly rotate or re-encrypt keys. Key rotation is a separate maintenance state machine and evidence record so that failures have one cause and rollback path. A migration may add encryption metadata columns under expand rules, but bulk re-encryption is resumable maintenance.

## 6.19 Rollout and compatibility

- G5 contracts, DDL, model, runtime profile, and fault catalog are versioned and digest-bound to the release.
- Consumer support precedes producer activation: a release that can read/apply an older receipt/batch/store state deploys before a policy enables new fields or state transitions.
- Endpoint release N+1 is tested against stores containing every N state: READY, BATCHED, unknown attempts, all holds, receipt, cleanup eligible, old keys, migration running, backup/quarantine metadata, disk pause, and unclean shutdown.
- Rollback N is tested after every N+1 expand/backfill state. Contract migration waits until N is no longer an authorized rollback.
- A runtime/native/provider/crypto change reruns schema, crash, WAL, disk, backup, corruption, migration, and all-sink gates. Version number alone is not compatibility proof.
- Promotion moves the same signed digest; environments do not rebuild or change migration resources.
- Feature flags only narrow. New cleanup, contract migration, TPM-only, enterprise recovery, or loss-policy behavior remains disabled until its human and CLI gates pass.

## 6.20 Terminal states

| Object | Terminal ordinary state | Retained evidence |
|---|---|---|
| source effect | immutable forever until approved whole-store retention/deletion | natural key, effect kind/digest, event ID or no-event reason, page |
| event payload | `PURGED` after receipt/grace | event ID/seq, natural linkage, hashes, batch, receipt, timestamps, cleanup record |
| batch wire body | `PAYLOAD_PURGED` after receipt/grace | batch ID/seq, membership, hashes, receipt, attempts, cleanup record |
| attempt | one final finite state | ID/number, batch, wire hash, bounded result/times |
| receipt | immutable authority fields; observation count can increase | all custody bindings and peer/failure-domain hashes |
| migration | `APPLIED`, `ROLLED_BACK`, `FAILED_HOLD`, or `ABANDONED` | plan/step/evidence hashes and backup link |
| key | `RETIRED` or `LOST` | purpose/version/provider/property hashes and lifecycle evidence; wrapped material retention follows key policy |
| backup | `DELETED` only by retention authority | metadata/tombstone and deletion evidence |
| quarantine | resolved state only by incident authority | opaque evidence hash/token and resolution |

Whole-store retention/deletion is outside this prompt. It must later preserve acknowledged-custody and deletion/restore invariants and cannot be inferred from per-payload cleanup.

---
# 7. Security/privacy threat and failure register

Role labels below identify accountable functions, not assigned people. Every blocking function must be assigned before its gate.

## 7.1 Consolidated register

| ID | Trigger/threat | Detection | Containment | Recovery | Cleanup/evidence | Owner function | Test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T-01 | cursor update commits without all page effects | model/domain verifier; failpoint state diff | invariant hold; stop source/store | fix implementation; restore prior verified state | preserve DB/WAL and minimal counterexample | Endpoint Storage/Data Correctness | G5-01, 02, 03 | storage stack may still lie about commit durability |
| T-02 | event commits but cursor/page does not | page/effect/checkpoint verifier | hold; no ad hoc cursor edit | retry page returns existing effect; repair only through tested migration | immutable ledger and fault trace | Endpoint Storage | G5-02 | source may delete data before retry |
| T-03 | same natural key gets different effect | unique key plus digest comparison | source/store safety hold | investigate interpretation/source discontinuity; governed correction only | retain both proposed digests in T1 incident evidence, never raw payload | Data Correctness/Privacy | G5-04 | a conceptual transform defect can be shared by oracle and implementation |
| T-04 | event UUID changes after ACK loss/retry | page retry result and natural-key ledger | invariant hold | return persisted ID; restore/repair from verified state | model counterexample | Endpoint Storage | G5-05 | unrecoverable loss of all local state can lose minted ID; server dedupe/RPO remains later gate |
| T-05 | two writers or hidden pooled connection | unexpected `SQLITE_BUSY`, handle/connection instrumentation | stop second owner; pause store | close leak; restart exact build; rerun | value-free connection/stack hash evidence | Storage Architecture | G5-06 | external privileged process can still open file |
| T-06 | batch membership/bytes mutate after seal | guard triggers; hash reconstruction | held batch; transport disabled | fix/rebuild release; never rewrite uncertain batch | preserve ciphertext/hashes/attempts | Transport/Storage | G5-07 | memory corruption or malicious code can bypass application controls |
| T-07 | socket write occurs before attempt is durable | instrumentation ordering/model | stop transport/ring | enforce prepare-then-handoff | causal trace | Transport/Storage | G5-08 | OS/network may buffer unpredictably after handoff |
| T-08 | response lost after server custody | attempt remains unknown; no receipt locally | replay/status same batch | apply matching receipt idempotently | attempt timeline and server stub ledger | Transport/Ingestion Contract | G5-09 | real status endpoint/failure domain not yet proved |
| T-09 | endpoint creates new batch after ambiguous send | state invariant/model | transport hold | replay original; remove rebatching path | batch/attempt ID trace | Transport | G5-10 | manual operator action could still violate without authorization controls |
| T-10 | 2xx or semantic response treated as ACK | receipt-link/domain verifier | no ACK; retry/hold | obtain valid receipt/status | bounded response class and receipt absence | Ingestion Contract | G5-11 | server may have custody but be unavailable to confirm |
| T-11 | forged/wrong-peer receipt | TLS/device-context/peer hash and strict verifier | security hold; no ACK | restore trust configuration; query approved endpoint | quarantined receipt digest, no raw secrets | Device Identity/Security | G5-12 | compromised trusted server/key is outside endpoint proof |
| T-12 | receipt batch/content/wire mismatch | exact comparison | `HELD_RECEIPT_CONFLICT` | incident/server reconciliation | retain both hashes/receipt digest | Ingestion/Storage | G5-13 | malicious server can consistently lie unless receipt failure domain is independently assured |
| T-13 | duplicate matching receipt | unique batch receipt and semantic comparison | idempotent observation count | none | increment bounded evidence | Storage | G5-14 | clock/observation count is not custody strength |
| T-14 | purge without receipt/grace | FK/domain/cleanup predicate | block cleanup; invariant hold if attempted | restore payload from transaction rollback/backup if affected | cleanup selection digest and first failure | Records/Data/Storage | G5-15 | physical remanence remains after logical purge |
| T-15 | drop-oldest under pressure | code/architecture mutation and invariant query | pause collection | free approved acknowledged data, add disk, or human decision | health state and no-deletion proof | Product/SRE/Storage | G5-16 | long outage can create coverage gap at source even without endpoint deletion |
| T-16 | filesystem reaches zero bytes | free-space/reserve/SQLITE_FULL | hard pause; release reserve once | checkpoint/receipt/authorized cleanup; restore reserve | allocation/free-space trace | Endpoint Operations/SRE | G5-17 | OS/log/security products may consume remaining space concurrently |
| T-17 | sparse/compressed reserve does not yield real bytes | allocation verification and disk-full drill | do not mark healthy | recreate non-sparse reserved allocation | file allocation evidence | Endpoint Operations | G5-18 | storage dedup/thin provisioning can still lie |
| T-18 | WAL grows due to long reader/checkpoint starvation | WAL frames/bytes/age, checkpoint BUSY | pause new writes at hard bound | close approved reader; bounded checkpoint | reader identity class and checkpoint results | Storage/SRE | G5-19 | AV/filter readers may be opaque |
| T-19 | checkpoint/delete/rename interference by AV/EDR | SQLite/OS codes and per-process tracing | defer/hold; no force deletion | approved configuration or unsupported capability | sanitized operation categories | Endpoint Security/Support | G5-20 | estate variability and updates require recurring qualification |
| T-20 | storage acknowledges flush but loses FULL commit on reboot/power cut | hard power/VM-host fault loop and state oracle | mark capability unsupported | storage/VM remediation or stronger mechanism | exact hardware/VM profile and first failure | Endpoint Platform/Storage | G5-21 | destructive tests cannot cover every firmware defect |
| T-21 | DB/WAL corruption | result codes, quick/full/FK/domain/crypto checks | corruption hold; stop all ordinary work | verified backup/incident recovery | stopped complete file-set hashes | Storage/Incident | G5-22 | corruption may destroy unacknowledged data beyond recovery |
| T-22 | `.recover` output trusted automatically | code review/runbook guard | never operate on original/ordinary path | copy-only salvage and full reconciliation | incident authorization/evidence | Incident/Data Correctness | G5-23 | salvage cannot prove completeness or original ordering |
| T-23 | delete-and-recreate hides loss | architecture mutation and store-epoch audit | prohibit; global hold | human recovery decision/new store with explicit loss incident | old quarantine plus new-store linkage | Product Risk/Incident | G5-24 | business may later accept loss; must remain explicit |
| T-24 | wrong realm/store file is opened | path token, singleton binding, AAD/key mismatch | `REALM_CHANGE_HOLD` before ordinary reads | select correct store or governed realm migration | opaque file/binding hashes | Realm Security/Storage | G5-25 | local admin can replace both file and executable/configuration |
| T-25 | cross-realm SQL relation/cache | composite keys/FKs, separate file/key, negative tests | reject/hold | fix schema/query; no data merge | synthetic realm-collision evidence | Realm Security/Data | G5-26 | same installation compromise affects all local realms sequentially |
| T-26 | plaintext payload reaches DB/WAL/log/dump/backup | exact canaries and sink scanners | privacy incident; disable source/store/transport | remove sink, rotate affected key where relevant, delete under authority | all-sink manifests and positive controls | Privacy/AppSec/Incident | G5-27 | EDR/pagefile/hypervisor capture cannot be completely ruled out |
| T-27 | AES-GCM nonce reuse | DB unique index, crypto collision check, forced test | security hold; no commit | generate new nonce; inspect RNG/key scope; rotate if exposure possible | collision evidence without key/plaintext | Cryptographic Authority/Storage | G5-28 | random collision is negligible but implementation/RNG defects remain |
| T-28 | wrong AAD/object/realm decrypts | negative vectors | auth failure/key hold | correct binding only through verified data; no fallback | vector IDs/result codes | Cryptographic Authority | G5-29 | compromised code with key can decrypt correctly bound data |
| T-29 | key unavailable after reboot/service identity change | startup unwrap/self-test | `KEY_HOLD`, no plaintext fallback | repair ACL/provider/TPM; enterprise recovery if approved | provider/property/ACL hashes | Endpoint Security/Crypto/Support | G5-30 | TPM clear/motherboard replacement can make data unrecoverable |
| T-30 | software key export or local-admin memory read | provider property/export tests; threat review | document assurance boundary; release integrity/ACLs | move to TPM/enterprise profile if approved | no key bytes; property/test result | Security/Risk | G5-31 | local admin remains capable of driving authorized service or replacing code |
| T-31 | DPAPI LocalMachine mistaken for strong isolation | configuration verifier rejects production profile unless approved | hold/disabled | select approved CNG profile | profile evidence | Cryptographic Authority | G5-32 | DPAPI still useful only under lower-assurance decision |
| T-32 | key rotation removes still-referenced key | reference verifier/backups/key-state checks | block retirement | restore key state; complete re-encryption/recovery decision | reference-count digest | Crypto/Records/Storage | G5-33 | stale/offline backup inventory can be incomplete |
| T-33 | migration resource modified/substituted | signed release/hash/ledger comparison | migration hold | reinstall authorized release; restore backup if needed | plan/resource hashes | Release/Storage | G5-34 | compromised signing/repository authority is a later release risk |
| T-34 | migration crashes mid-DDL/backfill | SQLite transaction and step ledger | remain migrating/hold; ordinary work off | rollback/resume exact step | all-state store snapshots | Storage/Release | G5-35 | SQLite/provider defects may violate assumptions; exact-version rerun required |
| T-35 | N rollback cannot read N+1 store | compatibility floor and executable matrix | block downgrade execution | roll forward or restore verified N backup | installer/store compatibility evidence | Release/Storage | G5-36 | long-offline endpoint may miss rollback window |
| T-36 | contract migration runs before old release excluded | rollout inventory/flag/ADR | keep expand representation | wait/republish release; no contract | deployment and decision evidence | Release/Product | G5-37 | fleet inventory can be stale; conservative delay required |
| T-37 | backup incomplete or key set absent | backup DONE/finish/hash/open/decrypt/integrity test | mark quarantined; cannot authorize migration/RPO | create new verified backup | backup manifest | Storage/Operations | G5-38 | backup destination/media can later degrade |
| T-38 | restore resurrects already-cleaned payload or resends ACKed data | server receipt reconciliation and restored cleanup ledger | `RESTORE_VERIFYING`, transport/visibility off | apply receipt states/cleanup policy, then replay only unknown | before/after receipt/event ledger | Storage/Ingestion/Records | G5-39 | server unavailable can prolong hold |
| T-39 | restore loses acknowledged server custody evidence | server status query plus batch/event IDs in backup | no destructive cleanup/normal operation until reconciled | recover receipt/status; central custody remains authoritative | reconciliation evidence | Ingestion/Storage | G5-40 | backup may predate locally minted IDs for later events; RPO/server uniqueness remains essential |
| T-40 | retry/backoff value creates storm or excessive delay | attempt metrics and synthetic outage | bounded jitter/backoff, global transport pause | update measured profile consumer-first | distributions without endpoints/IDs | SRE/Transport | G5-41 | network/proxy behavior varies by estate |
| T-41 | health/metrics leak IDs or explode cardinality | schema lint, runtime series budget, canaries | reject emission; privacy hold if value escape | remove label/log field; rotate telemetry artifact | series/field inventory | SRE/Privacy | G5-42 | rare combinations can still enable population inference |
| T-42 | support CLI exposes arbitrary SQL/decrypt/dump | architecture/API tests and command allowlist | disable tool; incident | replace with fixed verifier/opaque token | command/version/audit evidence | Support/Security | G5-43 | privileged offline forensic access remains possible under separate authority |
| T-43 | inaccessible/color-only diagnostics hinder recovery | accessibility tests, JSON/text parity | release/support block | add text labels/order/focus/screen-reader test | synthetic output snapshots | Support/Product Accessibility | G5-44 | terminal/assistive-technology differences remain |
| T-44 | feature flag broadens tenant authority | policy monotonic verifier | reject/SafetyHold | higher-revision valid narrowing artifact | policy proof | Privacy/Policy | G5-45 | compromised product signing authority can still broaden within release ceiling |
| T-45 | cleanup/migration self-reenables after kill | state/flag restart tests | keep disabled through restart | authorized higher-revision recovery and self-test | activation timeline | Incident/Operations | G5-46 | operator may bypass deployment controls outside product |
| T-46 | exact SQLite version has known WAL/corruption defect | source ID/advisory inventory; release history | block affected build/ring | update exact native binary and rerun all G5 tests | binary/source/SBOM hashes | Dependency Security/Release | G5-47 | undisclosed defects remain possible |
| T-47 | provider wrapper silently loads different native SQLite | loaded-module/source-ID mismatch | startup hold | correct package/installer/source mapping | loaded file manifest | Dependency/Storage | G5-48 | side-loading by local admin remains outside app boundary |
| T-48 | model and implementation share conceptual defect | independent model/oracle, hand cases, mutations | stop gate on disagreement | third review/reference model | minimal counterexamples | Test Architecture/Data Correctness | G5-49 | formal model abstracts OS/storage/crypto implementation |
| T-49 | server applies duplicate final business effect | synthetic durable inbox uniqueness stub | fail G5 gate; no production-shaped transport | fix endpoint/server contract; later real ingestion proof | server ledger/event/batch trace | Ingestion/Data Correctness | G5-50 | G5 stub is not production server proof |
| T-50 | physical device destruction before receipt/backup | absence/incident, no local recovery | explicit loss state, never silent success | source reacquisition if available; server/backup reconciliation | incident and last known custody evidence | Product Risk/Operations | G5-51 | impossible to eliminate without replication and human RPO/cost decision |

## 7.2 Disk and storage failure matrix

| Fault injection | Expected SQLite/UAM observation | Mandatory containment | Recovery evidence | Pass condition |
|---|---|---|---|---|
| `SQLITE_FULL` on first event insert | transaction error | rollback whole page, pause disk | checkpoint/effect counts unchanged | no event/cursor/page row; source retry succeeds after space |
| `SQLITE_FULL` after event before checkpoint update | commit fails/rolls back | same | WAL/reopen truth | no event and no cursor after reopen |
| `SQLITE_FULL` during batch insert/items | transaction rollback | events stay READY | exact state diff | no partial batch/membership |
| `SQLITE_FULL` preparing attempt | transaction rollback | no network handoff | transport trace | zero socket writes without committed PREPARED attempt |
| disk full while applying receipt | receipt tx fails | preserve batch unknown and payload; release reserve if policy | server stub retains custody; retry apply | matching receipt later commits once |
| disk full during authorized cleanup | transaction rollback | payload remains | cleanup ledger/state diff | no subset purged |
| WAL reaches soft limit | controller observation | enqueue PASSIVE; slow collection | frames/bytes/latency | no data loss, bounded latency |
| WAL reaches hard limit with reader | checkpoint BUSY | pause new writes, close approved reader | reader/checkpoint trace | recovery without WAL deletion or unack loss |
| reserve file release | explicit governor transition | only recovery-priority work | allocation/free-byte evidence | enough space for receipt/checkpoint/clean close in matrix |
| reserve absent at startup | state check | PAUSED_DISK | recreate only at healthy margin | no collection until verified reserve |
| power cut during FULL commit | SQLite recovery | restart/check/domain verify | repeated physical/VM fault trace | old or new complete state only |
| power cut during checkpoint | SQLite WAL recovery | no manual file deletion | source ID/file hashes/checks | integrity/domain pass; no committed loss |
| AV holds WAL/SHM | access/sharing/IO code | bounded defer/hold | filter/process-class evidence | no force delete, no false clean state |
| unexpected second writer | BUSY/handle evidence | invariant hold | close leak/rerun | no contention hidden by timeout |
| corrupt one DB page | integrity/domain/crypto failure | corruption hold/quarantine | verified backup restore | no ordinary operations on corrupt original |
| corrupt WAL header/frame | recovery/result code | hold/quarantine | backup/server reconciliation | no guessed checkpoint/cursor |
| corrupt SHM only while stopped | recreate per SQLite behavior after protected verification | startup verification | exact file-set diff | store opens only if engine/domain checks pass |
| storage flush lies | post-power committed state missing | capability fail | hardware/VM profile | zero missing FULL commit in claimed matrix |

## 7.3 Encryption/key failure matrix

| Fault | Detection | State | Recovery | Pass condition |
|---|---|---|---|---|
| random nonce collision forced | unique index/precommit lookup | security hold for faulty operation | generate fresh nonce; investigate RNG | no commit with duplicate `(key,nonce)` |
| ciphertext bit flip | GCM tag failure | integrity/key hold | restore/reconstruct object from verified source/backup | no plaintext returned or ACK/purge transition |
| tag/AAD/object ID altered | GCM failure | hold | correct binding only through verified store | every cross-object/realm/store test fails closed |
| wrong wrapping key/provider | unwrap failure | KEY_HOLD | approved provider repair/recovery | no plaintext fallback/new empty store |
| service SID ACL removed | key open denied | KEY_HOLD | deployment repair and self-test | unapproved process denied; repaired service succeeds |
| TPM unavailable/transient | provider error | defer then KEY_HOLD | health/estate recovery or approved software profile chosen before data | no implicit provider downgrade |
| TPM clear/motherboard replacement | persistent key unavailable | LOST/HOLD | enterprise recovery wrap if approved; otherwise explicit loss incident | no secret invention or silent deletion |
| software key export attempt | provider property/API test | capability fails if export succeeds against profile | strengthen provider/ACL or reject assurance profile | expected export prohibition and negative principal results |
| DPAPI machine blob opened by another process | documented/experimented capability | marks profile low assurance | no use unless human approves | report accurately; not labeled isolation |
| rotation crash after new key creation | key ledger | CREATED or ACTIVE with old ACTIVE/DECRYPT_ONLY constraints | idempotent resume | exactly one active key per purpose |
| rotation crash during re-encryption | object/key references | resumable | retry same object; old key retained | every ciphertext decrypts with recorded key; no nonce reuse |
| old key retirement with backup reference | reference verifier | block retirement | retain until backup decision | zero dangling key reference |
| enterprise recovery unwrap by wrong realm | AAD/key-purpose/realm checks | security hold | incident | cross-realm unwrap/decrypt never yields plaintext |
| process crash with plaintext buffers | canaries/dump policy | privacy incident if escape | disable dumps/source; cleanup under authority | no marker in declared dumps/traces; acknowledge residual memory risk |

## 7.4 Migration/rollback failure matrix

| Failure point | Required durable state | N behavior | N+1 behavior | Pass |
|---|---|---|---|---|
| before migration plan recorded | schema N | normal | retries preflight | no partial metadata |
| after run PREPARED before backup | schema N, run PREPARED | normal if release permits | resume backup | no schema change |
| backup interrupted | schema N, backup CREATING/QUARANTINED | normal | requires new verified backup | migration cannot proceed |
| during expand DDL transaction | schema N or complete expanded schema | opens both | verifies/continues | no half table/index/ledger |
| after expand commit before process result | expanded schema + migration ledger | N opens under compat | N+1 recognizes applied | idempotent restart |
| during backfill chunk | prior chunks and progress only | reads old representation | resumes exact next chunk | data/progress atomic |
| incompatible/corrupt row during backfill | FAILED_HOLD | old release only if schema compat/representation intact | held | no row skipped silently |
| verification fails | FAILED_HOLD | rollback/backup decision | no ordinary work | failure evidence retained |
| rollback N after expand | compatible expanded schema | all-state tests pass | can reinstall | no loss/state reinterpretation |
| rollback N during partial backfill | dual representation consistent | N passes | N+1 resumes later | no hidden dual-write drift |
| contract flag absent | expanded schema remains | N allowed | no drop | exact old-reader protection |
| contract begins then crash | transactional old or contracted schema | N blocked if floor raised | N+1 recovers | no unauthorized downgrade |
| migration hash differs from release | no execution | prior version | hold | zero SQL executed |
| provider/native changes during migration | identity mismatch | prior release | hold/restart with exact release | no mixed binary evidence |
| disk reserve would be breached | no migration | prior release | defer | no use of recovery reserve |
| restored N backup after N+1 receipts | RESTORE_VERIFYING | no normal transport | reconcile server receipts first | no duplicate final effect or premature cleanup |

## 7.5 Secure coding and review requirements

- Storage APIs expose typed commands/results only; no caller-supplied SQL, table, column, path, pragma, connection string, collation, function, or migration identifier.
- All SQL is static, parameterized, locally bundled, and code-reviewed. Identifier interpolation is prohibited.
- Native interop is isolated behind safe handles; every return/extended result code is checked; no finalizer performs semantic writes.
- Every transaction checks affected row counts and explicit state preconditions before commit.
- Cryptography uses framework/CNG primitives, fixed algorithms, explicit tag lengths, zero-length edge vectors, constant-time tag verification from the library, and no home-grown crypto.
- Plaintext buffers are bounded, never pooled across tenants/realms, cleared best-effort, and excluded from logs/dumps. Clearing managed memory is not claimed as guaranteed erasure.
- Schema/transition changes require two reviewers from storage/data correctness and security/privacy as applicable, plus mutation tests.
- Fuzzing targets strict contracts, receipt parsing, schema migration input bundles, corruption readers, and state-transition command sequencing using T1 only.
- Static analysis bans `ATTACH`, extension loading, arbitrary `Process.Start`, scripting, broad file enumeration, EF migration execution, raw exception logging, and unbounded metric labels in the storage module.
- Dependency/native updates require exact source/package/binary mapping, advisory review, SBOM/provenance, two clean builds, and full relevant regression gates.

## 7.6 Incident response and support ownership

Before G5 passes, runbooks must exist and be exercised for:

1. cursor/effect invariant failure;
2. duplicate final server effect;
3. disk reserve exhaustion and unrecoverable `SQLITE_FULL`;
4. WAL checkpoint starvation/AV interference;
5. corruption and quarantine;
6. key unavailable/lost/nonce reuse/tag failure;
7. receipt conflict or forged peer;
8. migration/rollback failure;
9. backup/restore reconciliation;
10. privacy canary/plaintext escape;
11. dependency/native SQLite incident;
12. support evidence request without raw payload.

Each runbook names authorization, detection, containment, first evidence, recovery, cleanup/deletion boundaries, re-enable tests, neighboring gates, communications, and the owner function. Support tooling must provide accessible text plus machine-readable JSON, stable reason codes, predictable ordering, and no color-only status.

---
# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Common test setup

All G5 tests use T1 fictional inputs only unless a separately approved capability measurement contains value-free metadata. The minimum harness contains:

- a deterministic page/event/no-event generator and independent expected ledger;
- a pure reference state model and a separate implementation adapter;
- a SQLite production-profile build plus a test-only fault-injecting VFS/build that cannot ship;
- a synthetic HTTPS ingestion server with durable-inbox uniqueness, receipt/status endpoints, controllable response loss, and one-final-effect ledger;
- a disposable Windows VM matrix with exact OS/filesystem/storage/virtualization/AV capability identities;
- a bounded virtual disk/VHD for repeatable free-space exhaustion and corruption copies;
- process-kill, service-restart, logoff/shutdown, hard VM power-off/revert, file-lock, and network fault controllers;
- exact file/module/SBOM/provenance inventory;
- filesystem/handle/process/SQLite extended-code/commit/checkpoint/resource instrumentation;
- canary registry and scanners for DB/WAL/SHM, backups, logs, traces, metrics, dumps, HTTP, evidence, and support output;
- before/after cleanup inventory for processes, handles, files, ACLs, keys, certificates, tasks/rules, server rows, and VM state.

Every test evidence envelope records source tree, DDL/model/fault/fixture/canary hashes, exact runtime/native/provider/OS/storage profile, command identity with connection material removed, first failure, all retries, assertions, resource samples, scanner result, and cleanup receipt. A rerun never erases a first failure.

## 8.2 Fault-hook catalog

Production code exposes internal semantic seams, but only the test assembly may activate hooks. Release architecture/SBOM tests prove no hook controller ships.

| Hook family | Exact boundaries |
|---|---|
| page | before begin; after page row; after each effect/event/witness; before/after checkpoint CAS; before commit; after commit before result |
| batch | after candidate read; after each decrypt; after canonical build; after compression/hash/encryption; before begin; after batch row; after each item/event update; before/after commit |
| attempt | before begin; after attempt insert; after batch unknown update; before/after commit; after durable handoff before first byte; after first/middle/last socket byte |
| receipt | before parse; after peer validation; before begin; after receipt insert; after attempt update; after batch update; after each event ACK; before/after commit |
| cleanup | after selection; before begin; after cleanup-run insert; after each event purge; after batch purge; after key reference update; before/after commit |
| checkpoint | before call; after each mode/result; during reader; before/after WAL truncate; process kill/power cut |
| crypto | before nonce; forced nonce; after encrypt; ciphertext/tag/AAD/key substitution; before/after unwrap; rotation state boundaries |
| migration | preflight; backup create/finish/verify; run record; each DDL statement; each backfill chunk/data/progress; verifier; compat floor; contract; commit/result |
| backup/restore | backup init/step/DONE/finish/fsync/hash/open/check/decrypt; restore copy/open/binding/key/integrity/receipt reconciliation/readiness |
| disk/I/O | fail allocation/write/sync/truncate/delete/rename/open/lock at the Nth matching operation; VHD full; reserve release; thin-provision/power failure |

Fault activation is deterministic by hook ID, invocation count, seed, and fault action. Every failing seed produces a minimal replay command.

## 8.3 Exact G5 acceptance tests

Durations are **ESTIMATE** planning inputs, not SLOs or promises.

| ID | Setup and instrumentation | Steps/faults | Pass/fail and primary assertion | Required evidence | Duration estimate | Cleanup |
|---|---|---|---|---|---|---|
| G5-01 model page invariant | finite sources/pages/events/no-events/checkpoints; TLC or equivalent plus independent C# model | enumerate/reorder/crash/retry every page transition | **PASS:** no reachable cursor-ahead, missing effect, double effect, changed event ID; **FAIL:** one counterexample | model/version/config, explored states/transitions, minimal trace | 5–30 min per bounded config | delete T1 model outputs after digest retention |
| G5-02 model batch/attempt/receipt | page outputs plus batch/attempt/server custody states | loss before/after every send/receipt observation; duplicate/conflicting receipt | same batch/bytes replayed; ACK only matching custody; no duplicate final effect | counterexample-free report and mutation positives | 10–45 min | reset synthetic server/model |
| G5-03 model disk/cleanup | capacity tokens, reserve, ACK/grace/clock/holds | arbitrary commits/receipts/full/cleanup/clock rollback | no unack purge; collection pauses before forbidden loss; cleanup only predicate | model trace and killed-mutant list | 10–45 min | T1 outputs |
| G5-04 DDL compile/profile | empty DB, exact SQLite native | execute schema with FK ON; inspect `sqlite_schema`, STRICT flags, indexes/triggers | zero syntax/FK mismatch; exact schema hash | SQL/source ID/compile options/schema dump hash | <10 min | delete DB |
| G5-05 DDL/trigger mutation | populated all-state store | attempt orphan FK, duplicate natural/event/nonce, batch-item mutation/delete, effect mutation, receipt authority mutation | every invalid mutation rejected with expected code | mutation matrix | 10–30 min | delete DB |
| G5-06 domain-verifier mutation | all-state canonical store and independent oracle | remove/mismatch one effect/event/item/receipt/cursor/hash/key/state at a time via test bypass copy | every mandatory invariant mutation detected; clean store passes | mutation ID/result/minimal SQL only | 30–90 min | destroy corrupted copies |
| G5-07 one-writer ownership | production profile, pooling off, handle/connection tracing | start leaked provider connection, external writer, approved backup reader | ordinary second writer produces detectable busy/hold; approved reader declared and bounded | connection/handle classes, result codes | 30–60 min | close handles/revert VM |
| G5-08 page idempotent baseline | fixed page with mixed event/no-event rows | commit; lose result; retry 100 times; restart between retries | one page/effect each, same event IDs, one checkpoint increment | DB ledger and result hashes | 15–30 min | delete store/server |
| G5-09 page process-kill matrix | fresh store per hook | kill process at every page hook and every row ordinal; restart/retry | precommit exact old state; postcommit exact full new state; no cursor-ahead | store/WAL hashes and expected/actual ledger per hook | 1–4 h | revert store each case |
| G5-10 page hard-reboot matrix | VM/VHD with production FULL/WAL | hard power off at randomized commit/sync hooks across repeated seeds | only old or complete page state; integrity/domain pass | VM/storage profile, seed, WAL recovery ledger | 4–24 h | revert VM/synthetic data |
| G5-11 page disk-full matrix | bounded VHD, test VFS Nth-write failures | inject FULL before/after every page write/sync | rollback/no checkpoint delta until full commit; retry succeeds after space | operation/fault/state matrix | 2–6 h | delete VHD/recreate reserve |
| G5-12 event sequence/UUID | fixed clock collisions, restart, rollback, many events | generate/commit/retry/rollback transaction/clock regression | UUIDv7 valid/unique; persisted ID stable; committed `event_seq` unique/ordered; gaps allowed only documented | vectors and ledger | 30–60 min | delete store |
| G5-13 no-event progress | page only no-event plus native-ID gaps | kill/retry at every boundary | no outbox event, immutable no-event effects, cursor advances only with page commit | effect/page/checkpoint ledger | 30–60 min | delete store |
| G5-14 natural identity conflict | commit natural key then propose different effect/interpretation cases | same digest retry; changed digest; runtime upgrade | same digest idempotent; changed digest holds; runtime version never changes key | conflict state/evidence | 20–40 min | delete T1 copies |
| G5-15 whole-page rejection | malformed/mixed interpretation/out-of-order/raw field/oversize/stale checkpoint pages | submit each and valid sibling rows | entire page rejected; zero partial effects/progress | parser/state/DB diff | 30–60 min | delete store |
| G5-16 deterministic batch seal | fixed READY events across paths/time zones/locales/restarts | build twice; inspect canonical/compressed/wire hashes/order | byte-identical canonical and compressed bytes for pinned profile; exact membership/order | manifests/hashes/dependency IDs | 20–60 min | clear plaintext/copies |
| G5-17 batch crash matrix | fresh READY events per hook | kill at every build/seal/item/event-update/commit hook | either events remain READY/no batch or one complete immutable batch | DB/WAL/state matrix | 1–3 h | revert store |
| G5-18 batch immutability | sealed batch | attempt SQL/API/order/compression/content/member mutations; retry send | all authoritative mutations blocked/detected; exact body hash before send | mutation matrix | 20–45 min | delete store/server |
| G5-19 attempt-before-send | socket byte counter and causal tracing | kill before/after prepare commit/handoff/first byte | zero socket bytes unless PREPARED committed; all prepared attempts safely replayable | ordered causal trace | 1–2 h | reset server/network |
| G5-20 lost-response replay | durable server receives then drops response at every byte/receipt stage | restart client; status/replay same batch repeatedly | server one custody/final effect; endpoint one receipt; exact same batch/body | endpoint/server ledgers and body hashes | 1–3 h | clear server/store |
| G5-21 transport response taxonomy | synthetic TLS/proxy/DNS/timeouts and 1xx–5xx/malformed bodies | apply every observation | only valid receipt ACKs; others preserve payload and finite state | response/result matrix | 1–3 h | reset proxy/server |
| G5-22 duplicate receipt | same valid receipt delivered across attempts/restarts | apply 100 repeats | one receipt authority, observation count 100, one ACK transition | receipt/event/batch ledger | 20–40 min | clear data |
| G5-23 conflicting receipt | wrong ID/hash/wire/peer/failure domain/attempt and second conflict | submit each | zero ACK/purge; batch conflict hold; observation quarantined | verifier outcomes | 30–60 min | delete T1 observations |
| G5-24 duplicate final-effect stub | server uniqueness on event ID; repeated batches/receipts/restore | cause all retry paths | exactly one materialized synthetic effect per event; conflicts classified | server uniqueness and event ledger | 1–2 h | reset server |
| G5-25 retry/backoff storm | thousands of endpoints simulated locally, one store each or state model | outage, recovery, Retry-After, clock skew | bounded attempts/CPU/queue; jitter distribution; no ID/body change | aggregate distributions no endpoint labels | 1–4 h | delete simulation |
| G5-26 soft/hard disk governor | VHD with measured free space/reserve | grow events/batches through watermarks, release reserve, recover | collection pauses before hard failure; receipts/recovery fit reserve; no unack deletion | allocation/state/action timeline | 2–6 h | restore VHD/reserve |
| G5-27 WAL starvation | declared long reader and leaked reader variants | sustained writes, PASSIVE/FULL/RESTART/TRUNCATE | soft/hard policy works; leaked reader detected; no force delete/data loss | frame counts, busy readers, latency | 2–4 h | close reader/checkpoint/revert |
| G5-28 checkpoint kill/reboot | WAL with committed pages | kill/power off during each checkpoint mode | integrity/domain and all committed pages preserved | WAL/DB state across hooks | 2–8 h | revert VM |
| G5-29 AV/EDR/file-lock matrix | supported security profiles; synthetic locker positive control | lock/scan/delay DB/WAL/SHM/reserve at opens/sync/checkpoint | bounded defer/hold; no weaker pragma/force delete; clean recovery | operation categories, no internal config | 2–8 h/profile | remove test lock/revert |
| G5-30 `max_page_count`/quota | small exact limits | fill DB/event/batch/metadata and release acknowledged data | engine and governor boundaries match; FULL rolls back; free pages reused/reclaimed as designed | page/freelist/logical byte ledger | 1–3 h | delete store |
| G5-31 shutdown/restart | active page/batch/attempt/checkpoint states | SCM stop timeout, graceful, forced kill, OS shutdown | no indefinite wait; proper clean flag; ambiguous attempt replay; no orphan handles | lifecycle trace/cleanup | 1–3 h | revert VM |
| G5-32 AES-GCM vectors | official/framework and UAM vectors | encrypt/decrypt zero/boundary/max, wrong key/tag/nonce/AAD | exact interoperability; every negative fails; no plaintext on failure | vector IDs/results only | 20–60 min | zero lab keys/buffers |
| G5-33 nonce collision/RNG | deterministic fault RNG and production CSPRNG identity | force duplicates at event/batch and concurrent logical requests | duplicate rejected before commit; key/nonce indexes clean | nonce counts/collision trace | 30–60 min | destroy keys/store |
| G5-34 crypto tamper/cross-binding | copied ciphertext among objects/realms/stores/epochs | flip/truncate/substitute every field | all authentication fails/holds; no cross-decrypt | result matrix | 30–90 min | delete stores/keys |
| G5-35 CNG provider/ACL | software and available TPM KSP; synthetic principals | create/open/use/export/ACL/service restart/negative principal | exact approved service succeeds; negatives/export fail as profile requires; properties captured | provider/algorithm/property/SD hash | 1–4 h | delete lab keys/identities |
| G5-36 reboot/TPM-clear/recovery | disposable TPM-capable VM where authorized | reboot, service SID repair, suspend, simulated/actual clear, machine restore | expected recoverable paths succeed; clear/loss enters explicit HOLD/LOST; no fallback | capability/recovery ledger | 2–8 h | remove lab keys/revert TPM VM |
| G5-37 key rotation | stores with payloads/batches/backups under old key | kill at every rotation/re-encrypt/retire hook | one active key; all objects decrypt with recorded key; old retained until zero approved refs; no nonce reuse | key/object/reference ledger | 2–6 h | destroy test keys/backups |
| G5-38 plaintext all-sink containment | exact canaries in minimized fictional payloads | success, retry, crash, corrupt, backup, support, dump-policy cases | marker only in approved transient source/plaintext memory harness; zero in DB/WAL/SHM/log/trace/metric/backup/evidence/dump | scanner positive controls and sink manifest | 2–6 h | delete all artifacts/revert |
| G5-39 expand migration | schema N stores in every state | install N+1, expand, kill around DDL/ledger | N or complete expanded schema; N and N+1 open/read/write all states | compatibility/state matrix | 2–6 h | restore templates |
| G5-40 resumable backfill | large synthetic state diversity | chunk sizes, kills, disk full, invalid row | data/progress atomic; exact resume; invalid row holds, never skips | per-chunk ledger | 2–8 h | delete copies |
| G5-41 N/N-1 rollback | after every N+1 expand/backfill state | start N, create/retry pages/batches/receipts, then N+1 | all authorized states preserved; no reinterpretation/double effect | old/new executable matrix | 4–12 h | restore VM/store templates |
| G5-42 contract migration | old release inventory/flag simulations | attempt early contract; authorized contract; crash/downgrade | early blocked; authorized all-or-none; old release blocked after floor raised | rollout/DDL/compat evidence | 2–6 h | restore backup/templates |
| G5-43 migration disk/backup faults | small VHD and fault VFS | fail preflight, backup steps, DDL, verify, ledger, restore | migration never consumes reserve or proceeds without verified backup; correct hold/rollback | fault matrix | 4–12 h | delete backups/revert VHD |
| G5-44 backup completeness/restore | all-state store with keys/unknown attempts/receipts | backup step faults; verify; delete source copy in test; restore | accept only DONE+finish OK/hash/integrity/decrypt; restored state exact | file/key/state manifests | 2–6 h | delete test backups/keys |
| G5-45 corruption/quarantine/recovery | copies with targeted DB/WAL/index/ciphertext corruption | startup/operation checks; attempt prohibited auto repair; restore | hold and complete stopped file-set; no original mutation; verified restore works; salvage only untrusted copy | quarantine/recovery receipt | 4–12 h | delete incident copies under T1 manifest |
| G5-46 restore/receipt reconciliation | backup predates receipt/cleanup and server has custody | restore offline, then server unavailable/available/conflicting status | no normal readiness/cleanup until verified; matching status yields idempotent ACK; conflict holds | before/server/restored ledgers | 2–6 h | reset server/store |
| G5-47 realm/store swap | two fictional realms/installations/stores/keys with colliding local IDs | swap files/manifests/keys/receipts; attempt attach/cross query | every mismatch holds before ordinary work; no cross-row/decrypt/ACK | negative matrix | 1–3 h | delete stores/keys |
| G5-48 observability/cardinality | high synthetic object counts/reason combinations | emit all health/errors/metrics/support JSON | no forbidden/dynamic labels or values; series under approved candidate budget; stable codes | field/series inventory and canary scan | 1–3 h | delete telemetry artifacts |
| G5-49 support/accessibility | CLI on all states, screen reader/keyboard/plain terminal/JSON | verify ordering, text labels, no color-only meaning, authorization, destructive negatives | actionable without raw payload/SQL; accessible formats; every mutation audited/blocked | output snapshots and accessibility checklist | 1–3 h | remove support artifacts |
| G5-50 dependency/native substitution | exact package/native/SBOM/provenance and tampered variants | side-load/replace provider/native/migration/tool; clean rebuilds | startup/build rejects mismatch; shipped files reconcile; no test hook ships | file/SBOM/provenance/tamper report | 1–3 h | revert install/cache |
| G5-51 resource/endurance/recovery | named Windows/storage profile, long synthetic outage/load, periodic crashes | measure page/batch/attempt/checkpoint/backup/migration and recovery over sustained run | zero primary invariant failures/leaks; bounded memory/handles/WAL/queue; measured percentiles supplied for human budgets | time series, event/state oracle, first failures, cleanup | 24–72 h/profile | full uninstall/revert/secure T1 deletion |

## 8.4 Primary zero-tolerance expression

```text
G5_PRIMARY_PASS =
    cursor_ahead_states = 0
AND missing_committed_effects = 0
AND partial_page_commits = 0
AND changed_event_ids_on_retry = 0
AND duplicate_natural_effects = 0
AND mutable_sealed_batches = 0
AND network_sends_without_prepared_attempt = 0
AND acknowledgements_without_matching_receipt = 0
AND receipt_conflicts_accepted = 0
AND unacknowledged_payloads_purged = 0
AND duplicate_final_server_effects = 0
AND cross_realm_store_or_decrypt_successes = 0
AND nonce_reuse_commits = 0
AND plaintext_canary_escapes = 0
AND migration_half_states_accepted = 0
AND unverified_backups_accepted = 0
AND corruption_auto_recreates = 0
AND cleanup_residue_or_lab_privacy_escapes = 0
```

Performance, success percentages, or risk acceptance cannot compensate for a nonzero primary count.

## 8.5 Smallest falsifying prototypes

### P-G5-01 — atomic page/effect/cursor

**Claim.** A page with one event and one no-event effect is either wholly absent or wholly committed with one checkpoint increment under every process-kill, disk-full, and hard-reboot boundary.

**Setup.** One fresh T1 store, exact production SQLite profile, fixed page, independent ledger, high-level hooks, test VFS, and VM power controller.

**Steps.** Run baseline; inject one failure at each page hook and SQLite write/sync ordinal; restart; run integrity/domain checks; retry identical page.

**Pass.** No cursor-ahead, no missing/extra effect, same event UUID after ACK loss, old-or-new complete state only, and zero canary escape.

**Fail/stop.** One intermediate state, changed UUID, hidden repair, or unexplained SQLite/OS outcome.

**Evidence.** Exact source/runtime/store/WAL hashes, hook/seed, before/after ledger, result codes, model comparison, cleanup receipt. **ESTIMATE:** 2–8 hours per named storage capability. Cleanup deletes/reverts T1 stores and VM snapshots.

### P-G5-02 — immutable batch and ambiguous receipt

**Claim.** Once sealed, a batch's members and exact bytes never change; every lost response replays/status-queries the same batch and produces one final server effect.

**Setup.** Three READY events, deterministic builder, synthetic durable inbox/receipt server, network byte/response fault controller.

**Steps.** Seal; kill at every attempt/handoff/socket/receipt boundary; drop replies after durable custody; restart/replay; inject duplicate and conflicting receipts.

**Pass.** Exact body hash/ID on every replay, one server custody/final effect, one local matching receipt/ACK, conflicts held, no purge.

**Fail/stop.** New batch after uncertainty, changed bytes, 2xx ACK, duplicate final effect, or accepted mismatch. **ESTIMATE:** 1–4 hours. Cleanup resets server/store and verifies no socket/listener residue.

### P-G5-03 — disk reserve and no-silent-loss

**Claim.** A real allocated reserve allows receipt/recovery writes after ordinary space exhaustion, while new collection pauses before any unacknowledged deletion.

**Setup.** Small VHD, non-sparse reserve, READY/BATCHED/unknown/receipted events, exact allocation and filesystem tracing.

**Steps.** Fill through soft/hard thresholds; inject FULL at page/batch/attempt/receipt/cleanup/checkpoint stages; release reserve once; recover space and recreate reserve.

**Pass.** No unacknowledged row/payload changes; page transactions roll back; matching receipt can be committed within designed reserve; collection stays paused until margin/reserve restored.

**Fail/stop.** Reserve yields no physical bytes, hidden drop, partial cleanup, false READY state, or recovery cannot complete. **ESTIMATE:** 2–6 hours. Cleanup destroys VHD and confirms reserve state reset.

### P-G5-04 — payload encryption/key failure

**Claim.** Main DB/WAL/backup contain no plaintext payload; wrong object/realm/store/key/AAD fails; key loss produces an explicit hold without fallback.

**Setup.** T1 canary payloads, software CNG and available TPM profile, negative principals, all-sink scanner, reboot/clear-capable disposable VM.

**Steps.** Commit/send/backup/crash; scan; tamper/substitute; reboot; deny key; rotate; optionally clear lab TPM under approval.

**Pass.** Zero forbidden sink marker, all tamper/cross-binding failures, one active key, no nonce reuse, exact hold/loss behavior, no plaintext/new empty store fallback.

**Fail/stop.** One marker escape, successful cross-decrypt/export contrary to profile, or silent provider downgrade. **ESTIMATE:** 2–8 hours/profile. Cleanup deletes generated keys/certs/stores and reverts TPM VM.

### P-G5-05 — expand/contract N/N-1 plus recovery

**Claim.** N+1 can expand and resumably backfill every N state while N remains a valid rollback; contract is impossible until authorized, and restore reconciles receipts before readiness.

**Setup.** N/N+1 binaries, all-state schema-N templates, small VHD, verified backup, migration hooks, synthetic server with post-backup receipts.

**Steps.** Kill/fill disk at every expand/backfill/verify/contract point; launch N after each state; authorize contract only in final lane; restore pre-receipt backup and reconcile.

**Pass.** Old or complete expanded state, atomic backfill progress, N works throughout rollback window, early contract blocked, post-floor N blocked, restored store held until receipt reconciliation, no duplicate final effect.

**Fail/stop.** Half schema, skipped row, hidden incompatibility, unverified backup use, or ordinary readiness before reconciliation. **ESTIMATE:** 4–16 hours. Cleanup deletes T1 backups/stores and restores release/VM state.

---
# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Continuous architecture fitness functions

| ID | Fitness function | Enforcement lane | Pass criterion |
|---|---|---|---|
| FF-G5-001 | raw/source-bearing types cannot reference Coordinator storage assembly | architecture test | every injected reference fails; minimized contract is the first accepted input |
| FF-G5-002 | no storage caller supplies SQL, connection string, pragma, table/column/path, migration script, or arbitrary command | API/source analyzer | zero prohibited public parameters/APIs |
| FF-G5-003 | exactly one production write-capable connection owner and pooling/shared cache disabled | architecture/runtime self-test | one owner/connection; no hidden pooled handle after close/restart |
| FF-G5-004 | exact SQLite native identity is known and allowed | startup/release gate | file hash, source ID, compile options and provider map to admitted record |
| FF-G5-005 | runtime pragmas/db-config are explicit and effective | startup test | every mandatory value matches; unsupported value holds store |
| FF-G5-006 | DDL compiles under minimum/current exact native profiles | schema CI | zero syntax/FK mismatch; schema hash equals release manifest |
| FF-G5-007 | every table relation is realm/installation-scoped | schema linter and mutations | zero unscoped durable relation; cross-realm mutations rejected |
| FF-G5-008 | source natural identity excludes runtime/interpretation version | schema/API test | key is exactly realm/install/source/generation/native ID |
| FF-G5-009 | page/effect/cursor transition satisfies formal invariant | model + implementation property tests | zero counterexample and killed unsafe mutations |
| FF-G5-010 | page transaction failpoint coverage is complete | fault-catalog check | every semantic write/commit/result boundary has a passing old-or-new case |
| FF-G5-011 | event ID is persisted once and stable | retry/restore tests | zero changed ID for a retained natural effect |
| FF-G5-012 | no-event effect is durable and produces no outbox event | schema/domain tests | exact one no-event ledger row, zero transport event |
| FF-G5-013 | batch bytes and membership are deterministic and immutable | clean-build/runtime vectors | byte-identical pinned outputs; every mutation blocked/detected |
| FF-G5-014 | attempt precedes any socket byte | causal instrumentation | zero network writes without committed `PREPARED` attempt |
| FF-G5-015 | all ambiguous outcomes replay/status-query same batch | transport model/fault tests | batch ID/content/wire hash unchanged across every retry |
| FF-G5-016 | receipt is the sole ACK authority | receipt mutation tests | zero ACK from status/HTTP/transport alone; all mismatches held |
| FF-G5-017 | synthetic central inbox has one final effect under all replays | endpoint/server integration test | uniqueness violations/final duplicates = 0 |
| FF-G5-018 | cleanup cannot select unacknowledged, unknown, held, clock-uncertain, or grace-ineligible rows | cleanup model/DDL/domain test | forbidden selections/purges = 0 |
| FF-G5-019 | disk governor pauses before invariant-threatening exhaustion | VHD/fault test | no unack loss; reserve supports named recovery operations |
| FF-G5-020 | WAL remains bounded and checkpoint starvation is observable | endurance/reader tests | no unexplained growth; hard threshold causes pause, not deletion |
| FF-G5-021 | FULL commit survives named power/reboot matrix | destructive lab | missing committed page/effect/checkpoint = 0 |
| FF-G5-022 | corruption never triggers automatic salvage/recreate | architecture/runbook/fault test | ordinary recovery mutations on original = 0 |
| FF-G5-023 | backup is accepted only after completion/hash/open/integrity/decrypt evidence | backup fault test | incomplete/unverified backup accepted = 0 |
| FF-G5-024 | migration remains N/N-1 compatible through rollback window | executable all-state matrix | every authorized old/new combination passes; early contract blocked |
| FF-G5-025 | schema/key rotation are independently resumable | fault tests | no mixed cause/half state; one active key per purpose |
| FF-G5-026 | payload plaintext never enters declared durable/diagnostic sinks | canary self-test and all-sink scan | mandatory scanner misses = 0; escapes = 0 |
| FF-G5-027 | nonce/key pairs are unique | DB index, crypto checks, forced collision | committed reuse = 0 |
| FF-G5-028 | wrong realm/object/store/key/AAD cannot decrypt or ACK | crypto/receipt/realm matrix | cross-binding successes = 0 |
| FF-G5-029 | no dynamic/high-cardinality telemetry labels | schema/runtime cardinality lint | only approved finite dimensions; measured series under candidate budget |
| FF-G5-030 | support interface is fixed, value-free, accessible and non-SQL | API/accessibility/security tests | no payload/SQL/raw ID; text/JSON parity; no color-only state |
| FF-G5-031 | test fault hooks cannot ship | build file manifest/SBOM/source guard | zero hook-controller/test VFS symbols/files in release payload |
| FF-G5-032 | dependency/native/migration bytes are reproducible and provenance-bound | release gate | two clean unsigned builds match; every shipped byte reconciles |
| FF-G5-033 | all human-owned features remain disabled without approved record | configuration/state test | cleanup/loss/contract/TPM-only/escrow flags cannot activate implicitly |
| FF-G5-034 | every hold requires named authorized recovery and self-test | state-machine test | no self-reenable/restart bypass; recovery evidence linked |
| FF-G5-035 | cleanup/uninstall/lab teardown is complete | before/after manifest | no process/handle/file/key/cert/rule/server/VM residue beyond approved evidence |

## 9.2 Measurable acceptance criteria

| Area | Mandatory criterion | Status type |
|---|---|---|
| correctness | all primary counts in section 8.4 equal zero | non-waivable technical gate |
| formal model | required bounded configurations complete without counterexample; every seeded unsafe mutation produces a counterexample | CLI evidence |
| fault coverage | every hook in section 8.2 exercised at least once; every durable write/sync ordinal covered by deterministic representative matrix | CLI evidence |
| realm isolation | zero wrong-realm file open, relation, key decrypt, receipt ACK, cleanup, backup restore, or support view | non-waivable technical gate |
| privacy | scanner positive controls all pass; zero plaintext/forbidden marker in every declared sink | non-waivable technical gate |
| cryptography | all vectors pass; nonce reuse commits zero; wrong key/tag/AAD/realm/object failures all fail closed | non-waivable technical gate |
| durability | named process-kill/reboot/power/storage profile produces old-or-complete state only; zero missing FULL commit in claimed scope | capability-specific technical gate |
| disk | no unacknowledged deletion; pause/hold transitions occur before failed recovery margin; reserve operation is proved | technical gate; exact sizes human/measurement |
| WAL | no unexplained reader; checkpoint duration/frames/bytes and worst-case recovery measured; no hard-bound overrun without pause | CLI measurement plus human budget |
| batching | exact deterministic bytes and immutable membership across clean runs, restart and retries | technical gate |
| receipt | only matching allowed failure-domain receipt ACKs; duplicate matching receipt idempotent; conflict held | technical gate |
| migrations | all-state N/N-1 executable matrix passes; no early contract; backup/rollback/restore evidence complete | technical/release gate |
| backup/restore | every accepted backup reaches DONE/finish OK, exact hash, open, integrity/FK/domain/decrypt; restore reconciliation passes | technical gate; cadence/RPO human |
| resources | page/batch/receipt/checkpoint/migration p50/p95/p99/max latency, CPU, working set, handles, DB/WAL growth and recovery duration measured on each named profile | measurement; thresholds human/SLO |
| operations | assigned owners, exercised runbooks, escalation, support commands, evidence access/deletion, dependency advisory path | human/operations gate |
| licensing/support | exact native/provider/encryption/test tools have approved license, notices, support/removal plan | human/procurement/security gate |
| accessibility | support/health output usable without color, keyboard/mouse dependency or raw data; text and JSON stable | product/support gate |
| production authority | purpose/fields/retention/access/disk/offline/encryption/grace/RPO/SLO/risk decisions recorded and later gates passed | human gate; never inferred from G5 |

## 9.3 Provisional performance/resource measurements

No numeric production threshold is accepted. The prototype must report at least:

- page commit latency by event/no-event count and ciphertext bytes;
- batch build latency by event count, canonical bytes, compression ratio and key provider;
- attempt/receipt transaction latency independent of network;
- WAL bytes/frames per page, batch, attempt, receipt, cleanup and migration operation;
- PASSIVE/FULL/RESTART/TRUNCATE checkpoint duration, blocked-reader time and bytes copied;
- unclean restart recovery duration and first-ready time;
- DB/free-list/OS allocated bytes before/after cleanup/incremental vacuum;
- writer queue depth/age, process CPU, working set, GC allocation, handles and key handles;
- backup throughput/space overhead, integrity-check duration and restore verification duration;
- migration expand/backfill/contract duration/space/rollback cost;
- sustained outage event/batch/attempt growth and oldest-unacknowledged age;
- security-product impact versus baseline.

Every value is labeled by exact fixture, hardware/VM, OS/filesystem, SQLite source ID, provider, encryption provider, AV profile and build. Synthetic performance is implementation evidence, not a 6,000-endpoint capacity or production SLO claim.

---

# 10. Human decisions and owner questions

Role/function names identify accountability categories; they do not assign a person or claim organizational approval.

## 10.1 Mandatory decision HD-G5-01 — maximum offline duration and pause/loss policy

**HUMAN DECISION.** Accountable function: **Product/Risk Authority**, advised by Data Owner, Privacy/Legal, Operations/SRE, Endpoint Support, and Records Management.

| Option | Consequences |
|---|---|
| A. retain unacknowledged data indefinitely within available disk; pause new collection at quota | strongest no-silent-loss behavior; indefinite endpoint disk/support burden; source coverage may still be lost while paused; no bounded recovery promise |
| B. defined maximum offline duration, then remain paused while retaining all local data | bounds collection behavior but not disk retention; explicit coverage gap after pause; requires portal/support semantics that absence is not no activity |
| C. defined duration/quota followed by an explicit audited lossy terminal policy | controls disk but intentionally loses unacknowledged evidence and can bias data; requires legal/privacy/data-quality approval, user/administrator communication, central audit, exact selection semantics and change to conservative invariant handling |
| D. add another durable replica before local loss | reduces local risk but adds network, identity, server capacity, cost, privacy and failure-domain design; not solved by endpoint code alone |

**Conservative temporary default:** option B behavior with **no automatic loss**: retain and retry; pause new collection at hard quota; emit value-free health; require human intervention. This is safe for prototypes but does not approve a maximum duration or production disk need.

Decision record must state duration origin, offline/clock definition, pause trigger, loss prohibition/permission, administrator semantics, source-deletion consequences, recovery/re-enable, retention interaction, and review trigger.

## 10.2 Mandatory decision HD-G5-02 — local data sensitivity and encryption assurance

**HUMAN DECISION.** Accountable function: **Product Security/Cryptographic Authority with Privacy/Data Controller**, advised by Endpoint Platform, Operations/Support, Legal/Procurement, and Records Management.

| Option | Protection/limitations and operational cost |
|---|---|
| A. volume encryption/ACL only | simplest; payload plaintext exists in DB/WAL/backups after boot and for authorized readers; relies heavily on endpoint controls; lowest application complexity |
| B. application payload AES-GCM + software CNG nonexportable machine key | recommended prototype; protects ordinary DB/WAL/backup copies from readers lacking key; metadata visible; local admin/trusted code can access process/key operations; recoverability depends on key/backup design |
| C. application payload AES-GCM + TPM-backed CNG wrapping | stronger nonexportability/hardware binding where available; TPM/VDI/repair/clear/algorithm/estate failures can make data unavailable; still not protection from malicious authorized code/local admin driving the service |
| D. option B/C plus enterprise dual wrap/recovery | improves recoverability/RPO; expands decrypt authority, key service dependency, legal/access/audit/incident surface and cost |
| E. SQLCipher or SEE full-database encryption | hides more metadata/pages from ordinary file readers; changes native SQLite stack, licensing/support, performance, WAL/backup/migration/recovery evidence; still exposes data in authorized process memory |

**Conservative temporary default:** T1 prototype enables application AES-256-GCM with software CNG and separately tests TPM. Production data collection/cleanup remains disabled until an assurance/recovery option is approved. DPAPI LocalMachine is not silently substituted for B/C.

Decision record must state threat actor, metadata sensitivity, local-admin assumption, TPM coverage, key export/attestation, enterprise recovery/escrow, lost-device/motherboard/TPM-clear response, backup key retention, crypto lifecycle/advisory ownership, and acceptable outage/data-loss consequences.

## 10.3 Mandatory decision HD-G5-03 — endpoint disk budget and ACK grace tied to RPO

**HUMAN DECISION.** Accountable function: **Product Owner and Operations/SRE**, with Data Owner, Records Management, Privacy/Security, Endpoint Platform/Support, and Finance.

| Option | Disk/grace consequence |
|---|---|
| A. small fixed disk budget + zero cleanup until manual approval | early pause and coverage gaps; simple/no premature purge; high support frequency |
| B. measured per-endpoint budget + cleanup after one verified custody receipt and grace ≥ worst approved endpoint/server backup RPO | balanced but requires reliable RPO evidence, clock policy, status query and restore drills; exact grace may retain more ciphertext |
| C. cleanup only after receipt plus repeated status confirmation or server durable-replica milestone | stronger custody assurance and safer restore; more server API/availability/state and local retention |
| D. large/elastic enterprise-managed budget | fewer pauses; variable cost and estate impact; still needs hard maximum/reserve/cleanup rules |

**Conservative temporary default:** no production disk number; use a deliberately small T1 lab quota to exercise pressure. `cleanup_enabled=false`, so ACK grace is effectively infinite until approved. Reserve size is measured for receipt/checkpoint/clean-shutdown/migration-rollback operations but is not production-approved.

Decision record must state total DB/WAL/backup/quarantine/reserve budget, logical event/batch quotas, soft/hard thresholds, reserve operations, server/endpoint backup RPO, grace formula and clock uncertainty, cleanup/tombstone retention, large-outage behavior, support/alert thresholds, cost, and review triggers.

## 10.4 Additional human decisions

| ID | Decision | Accountable function | Conservative state until decided | Blocked capability |
|---|---|---|---|---|
| HD-G5-04 | server receipt failure-domain classes and status-query contract | Ingestion/Data/Operations | synthetic only; no production ACK cleanup | production transport/cleanup |
| HD-G5-05 | periodic endpoint backup, destination, access, key custody, retention and restore RPO/RTO | Operations/Data/Records/Security | pre-migration T1 only | production backup/restore claim |
| HD-G5-06 | production SQLite managed/native provider and support arrangement | Architecture/Dependency Security/Legal/Procurement/Support | prototype adapter only | production store |
| HD-G5-07 | SQLCipher/SEE/full-metadata encryption need | Security/Privacy/Architecture/Procurement | application payload encryption candidate | full DB encryption |
| HD-G5-08 | exact batch count/byte/age and retry/backoff limits | Product/SRE/Ingestion | bounded lab estimates | production profile |
| HD-G5-09 | exact page/DB/WAL/queue/memory/CPU/handle/checkpoint limits | Endpoint Product/SRE/Support | bounded lab estimates | production profile |
| HD-G5-10 | migration rollback duration and contract authorization | Release/Product/Support | expand only; no contract | destructive migrations |
| HD-G5-11 | key rotation/recovery frequency and old-key/backup retention | Cryptographic Authority/Records/Operations | manual T1 rotation only | production rotation/retirement |
| HD-G5-12 | corruption evidence access, retention, transfer and deletion | Incident/Privacy/Records/Security | local protected T1 only | production incident workflow |
| HD-G5-13 | AV/EDR/CFA exclusions or compatibility policy | Endpoint Security/Platform | no automatic exclusion; unsupported on failure | affected estate support |
| HD-G5-14 | health/metric cardinality, access, retention and alert semantics | SRE/Privacy/Data Governance | fixed local/value-free dimensions | production monitoring |
| HD-G5-15 | support roles, hours, destructive authorization, escalation and training | Engineering Leadership/Operations/Support | capability disabled without owner | pilot/production |
| HD-G5-16 | accessibility standard and supported support interfaces | Product Accessibility/Support | text + JSON baseline | production support UX |
| HD-G5-17 | budget/licensing/commercial support | Product/Finance/Legal/Procurement | no unapproved spend | provider/encryption/tool selection |
| HD-G5-18 | SLO/RPO/RTO and production risk acceptance | Product/Risk/Operations | no production objective/approval | pilot/production |

## 10.5 Owner questions

1. What local threat actor and metadata exposure must encryption address, and is local administrator compromise explicitly out of assurance scope?
2. Which endpoints lack usable TPMs or use VDI/rollback/snapshot patterns, and what happens after TPM clear or motherboard replacement?
3. Who may recover a DEK, under what dual control, and how is recovery audited without creating a general decrypt service?
4. What exact server transaction/failure domain permits a `DURABLY_RECEIVED` receipt, and can status reproduce the same receipt after response loss?
5. What endpoint and server backup RPO determines the earliest safe payload cleanup?
6. What happens when the clock rolls back or remains uncertain beyond grace?
7. What maximum local allocation is acceptable across DB, WAL, reserve, backups and quarantine on each estate class?
8. Is any automatic loss ever permitted? If yes, what explicit terminal state, authority, notification and data-quality caveat apply?
9. How long must N remain an authorized rollback, and who authorizes the contract migration?
10. Which native SQLite/provider build, advisory feed, commercial support and patch-response owner are approved?
11. Can security products open/lock/scan the protected directory without breaking measured durability, and who approves any exclusion?
12. What evidence may support/incident staff access, and how is raw store transfer prevented or separately authorized?
13. What metric dimensions and rare-event reporting avoid person/device/realm singling-out while still detecting disk/corruption/key incidents?
14. Who can globally kill collection, transport, cleanup, migration or rotation, and what exact evidence permits re-enable?
15. What constitutes production acceptance after G5, given later identity/network/inbox/capacity/deletion/restore gates remain?

---

# 11. CLI experiments/measurements and exact evidence

The commands below are proposed repository tools. They use placeholders only and never include SSH configuration, credentials, internal addresses, users, raw activity, or production identifiers.

## 11.1 Exact environment and native inventory

```powershell
& .\artifacts\bin\uam-g5-inventory.exe capture `
  --store-root .\work\store-a `
  --output .\artifacts\inventory\environment.json

& .\artifacts\bin\uam-g5-store.exe self-test-runtime `
  --profile .\spec\runtime\sqlite-profile-candidate.json `
  --output .\artifacts\inventory\sqlite-runtime.json
```

Must produce: sanitized OS/build/architecture/filesystem/storage/virtualization/security capability classes; .NET SDK/runtime; managed provider package/hash; loaded SQLite path token/hash, version, source ID, compile options and VFS; effective pragmas/db-config; pooling/shared-cache/connection count; directory/ACL descriptor hash; application/schema/profile hashes. Any unknown/floating/mismatched native input fails.

## 11.2 Model state machine

```powershell
& .\artifacts\bin\uam-g5-model.exe check `
  --spec .\spec\model\G5.tla `
  --configs .\spec\model\configs `
  --mutations .\spec\model\unsafe-mutations.json `
  --output .\artifacts\model
```

Must produce model/tool version, spec/config hashes, explored states/transitions/diameter, invariant/temporal-property results, every killed mutation, and minimal replayable counterexamples. Required properties include page atomicity, stable ID, immutable batch, prepare-before-send, receipt-only ACK, no unack purge, realm isolation, nonce uniqueness abstraction, migration compatibility, and one server effect.

## 11.3 DDL/schema/domain verifier

```powershell
& .\artifacts\bin\uam-g5-schema.exe verify `
  --ddl .\src\storage\schema\001-initial.sql `
  --migrations .\src\storage\schema\migrations `
  --fixture .\fixtures\g5-t1\all-states `
  --mutations .\spec\faults\schema-domain-mutations.json `
  --output .\artifacts\schema
```

Must produce exact schema SQL/hash, object/column/index/FK/trigger inventory, compile result on every admitted SQLite profile, FK/integrity/domain results, query plans for queue/cleanup/verifier queries, and expected rejection for every mutation. Remote SQL/reference resolution is prohibited.

## 11.4 Page crash/disk matrix

```powershell
& .\artifacts\bin\uam-g5-fault.exe run-page-matrix `
  --store-template .\work\templates\fresh-store `
  --fixture .\fixtures\g5-t1\pages\mixed-page.json `
  --fault-catalog .\spec\faults\page-faults.json `
  --modes process-kill,sqlite-full,ioerr,sync-fail,hard-reboot `
  --output .\artifacts\faults\page
```

Must produce per-hook/ordinal seed, before/after DB/WAL hashes, engine/OS codes, effects/events/page/checkpoint/sequence ledger, startup integrity/domain result, retry result and cleanup. Primary counts must be zero.

## 11.5 Batch/attempt/receipt/server idempotency

```powershell
& .\artifacts\bin\uam-g5-testserver.exe start `
  --fixture .\fixtures\g5-t1\server\durable-inbox.json `
  --fault-plan .\spec\faults\network-receipt-faults.json `
  --evidence .\artifacts\server

& .\artifacts\bin\uam-g5-fault.exe run-delivery-matrix `
  --store-template .\work\templates\ready-events `
  --server-token .\work\testserver\local-token `
  --output .\artifacts\faults\delivery
```

Must produce canonical/uncompressed/compressed body hashes, sealed membership, attempt-before-byte causal trace, exact bytes per retry, endpoint/server custody and final-effect ledgers, response taxonomy, receipt verification, conflict holds, attempt/backoff distributions, and zero duplicate final effects. Shareable evidence replaces local server endpoint details with a digest.

## 11.6 WAL, disk reserve, latency and recovery

```powershell
& .\artifacts\bin\uam-g5-disklab.exe create `
  --size-profile tiny-falsifier `
  --output-token .\work\vhd\disk-token

& .\artifacts\bin\uam-g5-fault.exe run-disk-wal-matrix `
  --disk-token .\work\vhd\disk-token `
  --store-template .\work\templates\all-delivery-states `
  --reader-plans .\spec\faults\reader-checkpoint-plans.json `
  --output .\artifacts\disk-wal
```

Must produce actual allocated/free bytes, sparse/compression facts, DB/WAL/SHM/reserve/freelist/logical byte counts, watermarks/states, checkpoint modes/frame counts/BUSY readers/durations, FULL rollback behavior, reserve release/recreate proof, page/batch/receipt/cleanup latency and zero unack deletion.

## 11.7 Process/service/reboot/power/corruption loops

```powershell
& .\artifacts\bin\uam-g5-vmctl.exe run-recovery-campaign `
  --vm-profile <APPROVED-DISPOSABLE-WINDOWS-PROFILE> `
  --campaign .\spec\faults\reboot-power-corruption.json `
  --evidence .\artifacts\recovery
```

Must produce sanitized VM/storage profile, hook/seed/power action, pre/post DB/WAL/file hashes, clean-shutdown state, SQLite recovery codes, integrity/FK/domain/crypto verification, quarantined-copy manifest, restore result, process/handle/file/key cleanup and no credential/address/VM connection detail.

## 11.8 Encryption/key measurements

```powershell
& .\artifacts\bin\uam-g5-crypto.exe vectors `
  --profile aes256-gcm-v1 `
  --output .\artifacts\crypto\vectors.json

& .\artifacts\bin\uam-g5-crypto.exe provider-matrix `
  --providers platform-tpm,software,dpapi-machine-test `
  --service-sid-profile lab-coordinator `
  --output .\artifacts\crypto\providers.json

& .\artifacts\bin\uam-g5-crypto.exe rotation-matrix `
  --store .\work\store-a\endpoint.db `
  --fault-catalog .\spec\faults\key-faults.json `
  --output .\artifacts\crypto\rotation

& .\artifacts\bin\uam-canary-scan.exe `
  --manifest .\fixtures\g5-t1\canaries\manifest.json `
  --sinks .\work\store-a,.\artifacts\logs,.\artifacts\traces,.\artifacts\dumps,.\artifacts\backups `
  --output .\artifacts\crypto\all-sink-scan.json
```

Must produce official/UAM vectors, nonce uniqueness counts, wrong-key/tag/AAD results, provider/export/usage/machine-scope/security-descriptor hashes, service/negative-principal access, reboot/TPM-clear behavior, key-reference/rotation state, scanner positive controls and zero forbidden escapes. No key bytes, entropy, credentials or raw private/public material enter evidence.

## 11.9 Migration and N/N-1 matrix

```powershell
& .\artifacts\bin\uam-g5-migrate.exe plan verify `
  --from-schema 1 `
  --to-schema 2 `
  --release-manifest .\artifacts\release\manifest.json `
  --output .\artifacts\migration\plan.json

& .\artifacts\bin\uam-g5-fault.exe run-migration-matrix `
  --store-template .\work\templates\all-states-schema1 `
  --plan .\artifacts\migration\plan.json `
  --old-release .\artifacts\releases\N `
  --new-release .\artifacts\releases\Nplus1 `
  --fault-catalog .\spec\faults\migration-faults.json `
  --output .\artifacts\migration\matrix
```

Must produce exact SQL/resource hashes, backup completion/hash/integrity/key evidence, preflight free-space calculation versus actual, state at every fault, migration/step ledger, schema SQL diff, domain/FK/integrity results, N/N-1 read/write/replay/cleanup outcomes, and restore proof.

## 11.10 Backup, restore, receipt reconciliation and cleanup

```powershell
& .\artifacts\bin\uam-g5-backup.exe run-matrix `
  --store-template .\work\templates\backup-all-states `
  --fault-catalog .\spec\faults\backup-restore-faults.json `
  --testserver-token .\work\testserver\local-token `
  --output .\artifacts\backup-restore

& .\artifacts\bin\uam-g5-fault.exe run-cleanup-matrix `
  --store-template .\work\templates\cleanup-all-states `
  --policy .\fixtures\g5-t1\policies\cleanup-candidate.json `
  --clock-plan .\fixtures\g5-t1\clock\uncertainty.json `
  --fault-catalog .\spec\faults\cleanup-faults.json `
  --output .\artifacts\cleanup\matrix
```

Must produce backup step/DONE/finish/hash/open/check/decrypt evidence, restored store readiness/reconciliation timeline, selected cleanup IDs only as opaque T1 IDs, selection digest, changed rows/count, receipt/hold/grace/clock predicate per row, key references, bytes released, restart outcome and zero unacknowledged/held mutation. Cleanup remains a candidate test until HD-G5-03 approval.

## 11.11 Observability, support and accessibility

```powershell
& .\artifacts\bin\uam-g5-observe.exe exercise-all-states `
  --store-template .\work\templates\all-states `
  --cardinality-budget .\spec\observability\candidate-budget.json `
  --output .\artifacts\observability

& .\artifacts\bin\uam-g5-support.exe verify `
  --store-token .\work\store-a\local-token `
  --formats text,json `
  --accessibility-profile .\spec\accessibility\support-cli.json `
  --output .\artifacts\support
```

Must produce field/label/series inventory, finite reason/state matrix, cardinality counts, canary results, exact command allowlist, authorization/destructive negative tests, text/JSON semantic parity, screen-reader/plain-terminal/keyboard checklist and zero raw payload/path/user/realm/event/batch/key/SQL output.

## 11.12 Exact aggregate gate artifact

```powershell
& .\artifacts\bin\uam-g5-gate.exe evaluate `
  --evidence-root .\artifacts `
  --required .\spec\gates\g5-required-evidence.json `
  --output .\artifacts\g5-gate.json
```

`g5-gate.json` must bind:

- six internal evidence hashes and public/open-source register revision;
- source tree, release, contract, DDL, model, fault, fixture and canary digests;
- exact runtime/native/provider/OS/filesystem/AV/VM capability identities;
- every G5-01–G5-51 assertion and first failure;
- all primary invariant counts, each zero;
- performance/resource measurements and which remain unapproved estimates;
- ADR states, assigned owner functions, human-decision states, exceptions and expiry;
- backup/restore, key, test-server, VM and product cleanup receipts.

The gate fails on missing/stale evidence, blocked mandatory fault, a nonzero primary invariant, unassigned blocking owner, expired exception, scanner miss, unsupported environment described as passed, or an implicitly enabled human decision.

---
# 12. ADR proposals: decision, status, alternatives, rationale, evidence, owner, and review trigger

The ADRs below separate accepted logical rules from environment-dependent profiles and human decisions. An ADR marked **accept architecture / proof pending** authorizes implementation and tests, not production use. No ADR may become production-accepted while its named owner function is unassigned, its required evidence is stale or missing, or a human-owned value has been enabled implicitly.

| ADR | Decision | Proposed status | Alternatives considered | Rationale and evidence | Accountable owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-G5-001 | one authenticated realm and installation per SQLite store epoch; realm change never mutates the existing binding in place | **Accept architecture / G5 proof pending** | one multi-realm database; realm column only; delete-and-recreate | separate files, keys, backups, quarantine, and cleanup reduce accidental cross-realm joins and restore mistakes; preserves I01/I06 realm authority | Endpoint Storage Owner with Realm/Identity Security | registration/realm model change, VDI cloning evidence, cross-realm test failure |
| ADR-G5-002 | one long-lived writer actor owns the only writable connection; provider pooling disabled; readers are bounded snapshots | **Accept architecture / G5 proof pending** | multiple writers with busy retry; per-operation connections; ORM unit-of-work writers | explicitly matches SQLite's single-writer behavior, bounds lock ownership, and makes crash/fault state enumerable [W02, W13, W16] | Endpoint Storage Owner | measured actor bottleneck, unsupported provider behavior, hidden second writer detected |
| ADR-G5-003 | WAL, `synchronous=FULL`, `wal_autocheckpoint=0`, Coordinator-owned bounded checkpoints | **Accept architecture / exact runtime profile pending** | rollback journal; WAL/NORMAL; default 1,000-page auto-checkpoint; checkpoint on every commit | FULL syncs WAL on commit; application checkpoints avoid surprise foreground work and expose starvation/limits [W02–W04] | Native Storage Owner with SRE | exact native change, power-cut result, unacceptable measured latency, checkpoint defect/advisory |
| ADR-G5-004 | one `BEGIN IMMEDIATE` transaction writes page effects, minimized events, no-event facts, witnesses, page/run record, and cursor compare-and-swap | **Accept invariant / non-waivable proof gate** | event then cursor; cursor then event; per-row commits; network inside transaction | directly implements the accepted page-owned no-cursor-ahead rule [I01, I03, I06] | Endpoint Storage and Data Correctness Owners | any G5-01–G5-14 failure or page-contract revision |
| ADR-G5-005 | source-record natural key is version-independent; `event_id` UUIDv7 is minted once at first insert; local `event_sequence` is monotonic store order only | **Accept architecture / proof pending** | payload hash identity; random retry ID; include interpretation/runtime; source time ordering | preserves one source record/one effect across retry and upgrade, while separating local processing order from business/source time [I05, I06, W27] | Contract Authority with Data Correctness | correction/reprocessing design, central uniqueness contract change, collision/rollback evidence |
| ADR-G5-006 | batch construction is a database transaction that selects eligible immutable events, fixes membership order, creates exact compressed wire bytes, and seals hashes before send | **Accept architecture / proof pending** | rebuild bytes on every retry; stream directly from event rows; mutable batch membership | deterministic replay, stable receipt binding, bounded memory, and auditable content identity require immutable bytes | Endpoint Delivery Owner | wire contract/version change, measured memory failure, server receipt contract change |
| ADR-G5-007 | each network attempt is durably `PREPARED` before socket write; ambiguous completion replays the same batch and bytes | **Accept invariant / proof pending** | write attempt after send; assume no response means failure; create new batch after timeout | turns lost response into explicit uncertainty and prevents duplicate logical batches | Endpoint Delivery Owner | transport stack change, status-query contract, failpoint or packet-capture contradiction |
| ADR-G5-008 | only a valid authenticated receipt matching realm context, batch ID, content hash, counts, and protocol can transition a batch to `RECEIPTED` | **Accept invariant / server dependency open** | HTTP 2xx as ACK; TLS completion as ACK; semantic materialization as ACK | preserves the accepted durable-custody meaning and separates transport from later semantic states [I01, I03, I06, W26] | Ingestion Contract Owner and Endpoint Delivery Owner | real server inbox proof, receipt-field revision, custody failure-domain change |
| ADR-G5-009 | cleanup is explicit, selection-hashed, receipt-gated, grace-gated, clock-confidence-gated, and never deletes held/unacknowledged state | **Accept safety rule / production disabled pending HD-G5-03** | delete immediately on receipt; time-only purge; quota-based drop; sampling | no-silent-loss and restore/RPO rules prohibit implicit deletion; exact grace is a human decision | Records/Data Owner with SRE and Endpoint Storage | approved RPO/grace, deletion/restore design, clock incident, cleanup invariant failure |
| ADR-G5-010 | payload columns are encrypted before SQLite bind with AES-256-GCM; envelope metadata is explicit; nonces are unique per DEK and enforced by schema/domain checks | **Accept candidate / crypto admission pending** | plaintext with ACL only; full-database SQLCipher/SEE; DPAPI per payload; OS EFS | protects minimized payloads in DB/WAL/backups/ordinary tools without importing a SQLite fork; metadata remains visible and documented [W17–W18, W25] | Product Security/Cryptographic Authority | algorithm guidance, nonce/key defect, performance failure, approved full-db requirement |
| ADR-G5-011 | DEKs are random and versioned; KEKs are non-exportable CNG machine keys where possible; TPM provider is preferred only after capability proof; software CNG is explicit fallback; DPAPI LocalMachine is not high assurance | **Accept profiles / human assurance decision open** | DPAPI LocalMachine; password-derived key; embedded key; TPM-only; central online key dependency | separates data-key rotation from provider changes and keeps offline capability; local-admin residual risk is explicit [W19–W23] | Cryptographic Authority with Endpoint Security | HD-G5-02 decision, TPM/VDI inventory, recovery drill, provider deprecation or key incident |
| ADR-G5-012 | reserve file and disk governor protect commits, receipts, checkpoints, migration/backup metadata, and controlled shutdown; pressure pauses collection before data loss | **Accept architecture / sizes unapproved** | rely on filesystem free space; delete oldest; compress in place under pressure; continue until `SQLITE_FULL` | a reserved recovery margin is necessary to record custody or hold state when space is scarce; exact budget remains human-owned | Endpoint Product with SRE/Operations | HD-G5-01/03 decisions, measured outage distribution, reserve test failure |
| ADR-G5-013 | migrations use immutable manifests, expand/contract phases, resumable idempotent steps, preflight backup, and an explicit N/N-1 read/write compatibility window | **Accept architecture / exact window approval pending** | one destructive migration; downgrade by restoring old binary only; ORM auto-migrate; copy everything to a new store every release | release rollback must not depend on an unreadable schema; SQLite ALTER limitations and large transforms need explicit copy/verify/swap [W11] | Storage Schema Owner with Release Engineering | schema change, rollback-window decision, migration fault or duration budget failure |
| ADR-G5-014 | backup uses SQLite Online Backup or an equivalently proved API, exact source/target/key metadata, completion plus validation; raw main/WAL/SHM copies are forbidden | **Accept architecture / RPO policy open** | filesystem copy; VSS without application protocol; `VACUUM INTO` as universal backup; no backup | SQLite's backup API provides a coherent snapshot; restore still requires hash, schema, integrity, decryption, realm, and receipt reconciliation [W08, W14] | Endpoint Storage/Operations | approved RPO, backup destination/key design, restore drill, API/provider change |
| ADR-G5-015 | corruption, key loss, invariant violation, receipt conflict, and migration ambiguity enter scoped hold/quarantine; no automatic `.recover`, delete, recreate, or silent continue | **Accept invariant** | auto-salvage; reset cursor; recreate DB; skip bad rows; accept latest receipt | recovery tools are forensic/best-effort and cannot prove relational or delivery meaning; uncertainty must not become loss or duplicate effect [W06, W09] | Incident Response with Storage/Data Owners | incident drill, superior formally bounded repair, production correction authority |
| ADR-G5-016 | health/support interfaces are command allowlisted, value-free, low-cardinality, non-SQL, and non-destructive by default; destructive operations require separate authorization/audit | **Accept architecture / access decisions open** | arbitrary sqlite3 shell; raw export; dynamic metric labels; remote support dump | preserves minimization and realm boundaries while still exposing actionable state | Support/Operations with Privacy and Security IAM | support inability, cardinality/access decision, diagnostic incident |
| ADR-G5-017 | the executable state model plus deterministic fault hooks is a release gate; passing ordinary unit tests is insufficient | **Accept invariant** | happy-path tests; random chaos only; post-release monitoring | the primary failures occur at narrow crash/flush/ACK boundaries and require systematic exploration | Test Architecture and Endpoint Storage Owners | model/tool replacement, escaped defect, state-space coverage gap |
| ADR-G5-018 | exact SQLite native/provider/runtime binaries, compile options, loaded module, license, advisories, SBOM, and source mapping are recorded per release | **Accept supply-chain rule** | trust managed package version; OS-provided unknown SQLite; floating native bundle | managed version does not establish loaded native code; recent WAL defects show exact source identity matters [W01, W30–W32] | Dependency Security/Release Engineering | dependency update, advisory, source/binary mismatch, support policy change |
| ADR-G5-019 | full-database encryption remains an alternative, not the initial dependency; SQLCipher/SEE require separate fit, migration, licensing, performance, and recovery evidence | **Defer** | adopt SQLCipher now; buy SEE now; never support full-db encryption | application encryption meets the current payload-at-rest goal with smaller native divergence; exact local assurance is human-owned [W28–W29] | Architecture with Security, Legal/Procurement, Operations | HD-G5-02 requires metadata/full-file protection or application encryption fails a named gate |

## 12.1 ADR acceptance rule

An ADR moves from `Proposed` to `Accepted for implementation` only when its owner function, dependency, contract, and smallest falsifying experiment are recorded. `Accepted for production` additionally requires: the exact supported environment, successful G5 aggregate gate, applicable human decisions, real server receipt proof, release/signing gate, support/runbook drill, and designated production authority. A failed invariant supersedes convenience and opens a new ADR/change proposal; it cannot be waived by increasing retry counts or disk limits.

---

# 13. Ordered implementation backlog with dependencies and stop gates

The backlog follows the predecessor gate order. Pure G5 models and synthetic storage work may run while other Batch 03 topics proceed, but no live-source or production-shaped delivery claim is created by doing so.

| Order | Repository task | Depends on | Concrete deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | record the six-file evidence manifest and create ADR/human-decision records | none | immutable reviewed-input manifest; ADR-G5-001–019 files; HD-G5-01–03 records | missing/changed/unallowlisted input or silent predecessor conflict |
| 2 | assign accountable owner functions and incident escalation | 1 | owner register for storage, delivery, data correctness, crypto, release, SRE, support, incident, dependency, records, ingestion contract | any safety-critical owner remains `UNASSIGNED` before its task begins |
| 3 | add G5 projects and hard dependency boundaries | Batch 01 repository rules, 1–2 | `Uam.Coordinator.Storage`, `Uam.Coordinator.Delivery`, `Uam.Storage.Contracts`, `Uam.Storage.Model`, `Uam.Storage.Crypto`, `Uam.Storage.Migrations`, `Uam.Storage.Faults`; architecture tests | collector/raw-source/network/server-domain/SQL-shell dependency crosses the boundary |
| 4 | freeze logical contracts and finite state/reason catalogues | 3, Batch 02 page contract | page-commit, batch, attempt, receipt, maintenance, backup, migration, cleanup, health, key, quarantine schemas and invalid vectors | ambiguous receipt/cursor/cleanup semantics or dynamic error payload |
| 5 | implement the pure executable reference model | 4 | deterministic transition engine; invariants; model traces; small exhaustive state space | model permits cursor-ahead, unacknowledged deletion, mutable batch, duplicate final effect, or cross-realm transition |
| 6 | write and validate the DDL bundle and domain verifier | 4–5 | migration `0001`; strict tables, FKs, checks, triggers, indexes; verifier queries; schema digest | DDL fails exact native compile, FK check, domain check, or admits an invalid state |
| 7 | build exact runtime/native/provider inventory | Batch 01 dependency controls, 3 | loaded SQLite binary hash/source ID/compile options, provider package/source mapping, `.NET --info`, OS/filesystem class | unknown/floating native, unsupported runtime, source/binary mismatch, missing mandatory API |
| 8 | implement safe native/managed SQLite adapter | 6–7 | one narrow connection factory; extended result codes; authorizer/config/limit setup; no broad raw API exposure | mandatory pragma/config cannot be set/read back, provider hides required error/backup/checkpoint behavior |
| 9 | implement store directory, ACL, store binding, epoch, reserve-file manager | G1 installer boundary, 3, 8 | protected path manifest; realm/install binding; atomic reserve create/release/recreate; no user-writable parent | realm rebinding, unsafe ACL, uncontrolled path/reparse, reserve cannot be verified |
| 10 | implement single-writer actor and bounded read API | 5, 8–9 | bounded command channel, single writable connection, no pooling, cancellation/drain protocol, snapshot reader lease | second writer detected, unbounded queue, write connection escapes actor, shutdown loses command result |
| 11 | implement connection hardening and startup self-check | 8–10 | WAL/FULL/foreign keys/trusted-schema-off/defensive/limits/temp-memory/manual-checkpoint profile; actual-value evidence | any required setting ignored or WAL/FULL not effective |
| 12 | implement application encryption envelope and T1 software CNG profile | 4, 7–11 | AES-GCM codec, AAD canonicalization, nonce allocator, DEK/KEK tables, generated lab key, zeroization tests | nonce reuse, plaintext bind, unauthenticated metadata, key accessible to wrong identity, canary escape |
| 13 | add TPM capability spike and explicit unsupported path | 12, approved lab | Platform Crypto Provider create/open/encrypt/decrypt/restart/ACL/clear evidence on disposable VM | TPM absence described as failure/pass rather than capability; key cannot be recovered/cleaned; wrong identity decrypts |
| 14 | implement atomic page commit | 4–12 | compare-and-swap checkpoint, effect/event/no-event/page/run/witness transaction and stable outcome return | any G5-01–G5-14 failpoint produces cursor-ahead, missing effect, changed event ID, or partial page |
| 15 | add deterministic transaction fault hooks | 5, 10–14 | hook catalogue before/after each insert/update/commit/return; kill/throw/full/ioerr injection | uninstrumented mutation boundary or hooks alter production semantics when disabled |
| 16 | implement batch eligibility query and immutable seal | 4, 10–12, 14 | priority/age/size bounded selector, membership ordinals, exact compressed bytes, hashes/counts, encrypted wire blob | event in two open batches, membership mutation, nondeterministic bytes/hash, raw payload outside crypto boundary |
| 17 | implement prepared delivery attempts and transport adapter interface | 4, 10, 16 | attempt row before send, exact batch byte stream, timeout/cancel/result classification, no DB transaction during network | first network byte precedes durable attempt; retry creates new content; socket callback writes SQLite outside actor |
| 18 | build synthetic durable-custody server and status-query test double | 4, 17 | realm-bound authenticated endpoint; inbox uniqueness; response-loss/drop/duplicate/conflict modes; receipt signer | test server cannot distinguish custody/validation; dedupe effect not observable; endpoint trusts payload realm |
| 19 | implement strict receipt verifier and apply transition | 4, 10, 17–18 | canonical receipt parser, auth verification, batch/hash/count binding, duplicate/conflict states, receipt transaction | HTTP status alone acknowledges; wrong hash/realm/key accepted; conflicting receipt overwrites first evidence |
| 20 | implement retry scheduler, pause, backoff, kill switches, and clock-independent due order | 17–19 | persisted next-attempt monotonic-safe representation, bounded jitter, network/source/global pause, no starvation | retry storm, clock rollback authorizes cleanup, high-priority event permanently starves ordinary events |
| 21 | implement checkpoint governor and starvation controls | 10–11, 14–20 | WAL page/byte/read-age inputs, PASSIVE cadence, bounded RESTART/TRUNCATE maintenance only in reader gaps, evidence | checkpoint runs in foreground page transaction, unbounded WAL, reader starvation unobserved, concurrent checkpointer appears |
| 22 | implement disk governor and reserve escalation | 9–21 | soft/hard/critical states, pause order, reserve release only for named recovery writes, `SQLITE_FULL` classification | oldest unacknowledged row deleted, reserve consumed for ordinary work, state cannot be recorded, silent collection continues |
| 23 | implement privacy-safe health and metric-cardinality lint | 4, 10–22 | finite store/batch/attempt/key/migration/disk states; aggregate counts/bytes; no dynamic identifiers; lint budget | canary or sensitive identifier in log/trace/metric/support output; unbounded label set |
| 24 | implement local support CLI and authorization boundary | 23, IAM decision | text/JSON status, invariant check, checkpoint/backup request, hold details by finite code; destructive verbs absent/default-denied | SQL/payload/path/key exposure, cross-realm store open, unaudited mutation, accessibility parity failure |
| 25 | implement backup creation and validation | 8–12, 21–24 | Online Backup state machine; observed completion; target hash; schema/FK/quick/integrity/decrypt checks; manifest | incomplete backup marked verified, source/wire key absent, raw main/WAL/SHM copied, restore not testable |
| 26 | implement quarantine and read-only incident copy protocol | 9–12, 23–25 | immutable incident manifest, protected copy authorization, evidence hashes, store hold, no automatic export | store automatically recreated or raw artifact enters ordinary support/evidence bundle |
| 27 | implement corruption/startup recovery classifier | 8–12, 23–26 | result-code/stage taxonomy; bounded retry; quick/full integrity schedule; no auto-salvage; runbook link | corruption treated as empty queue, cursor reset, `.recover` output automatically accepted, infinite reopen loop |
| 28 | implement migration runner and manifest verifier | 6, 8–12, 25–27 | append-only migration table, source/target hashes, idempotent steps, leases, progress, preflight backup | migration SQL is mutable, no rollback-read path, partial step cannot resume or classify |
| 29 | implement expand/dual-read/dual-write/contract N/N-1 fixtures | 28, release contract | every durable state generated at N-1; N expands/reads/writes; N-1 rollback; N contracts after fleet gate | old binary cannot read required state, destructive contract precedes rollback closure, duplicate semantics during dual write |
| 30 | implement key rotation and re-encryption maintenance | 12, 20–29 | new DEK/KEK creation, bounded row rewrite, idempotent resume, mixed-key read, retirement preconditions | old key retired while referenced, nonce collision, plaintext temp, retry changes event/batch identity |
| 31 | implement receipt reconciliation and cleanup candidate with destructive path compiled off | 19–30 | server-status reconciliation model; explicit grace/clock/hold predicates; selection digest and dry-run evidence | any unreceipted/held row selected; receipt mismatch ignored; cleanup enabled without HD-G5-03 |
| 32 | complete model-to-code traceability and mutation tests | 5, 14–31 | every transition/invariant maps to code branch/test/fault; mutations for ACK, cursor, hash, key, cleanup, realm | mandatory mutation survives or code transition absent from model/catalogue |
| 33 | complete dependency, license, SBOM, provenance, and clean-build gates | 7–32, Batch 01 release controls | exact files/packages/native/license notices/source, two challenged builds, provenance subject, tamper rejection | unmapped native/generated file, unexplained binary difference, mutable tag/source, unresolved license |
| 34 | prepare placeholder-only Windows VM scripts | 9–33 | install/inventory/disk-fill/kill/reboot/power/AV/corrupt/key/migrate/restore/cleanup scripts with no connection material | credential/address/real identity/activity appears; preflight mutates before inventory |
| 35 | approve named Windows/filesystem/virtualization/security capability matrix | human owners, 34 | support-scope record and lab authorization | unknown environment described as supported or a blocked campaign counted as pass |
| 36 | run G5-01–G5-51 on each claimed capability | 14–35 | immutable evidence per exact runtime/native/store/schema/key/OS/filesystem/AV/VM capability | any primary invariant nonzero, cleanup residue, scanner miss, first failure overwritten |
| 37 | run hard-power/VM-host, disk-full, checkpoint-starvation, AV/EDR, corruption, key-loss, and migration soak campaigns | 36 | repeated recovery distributions, WAL/latency/memory/disk evidence, sanitized failure artifacts | flush claim contradicted, silent loss/duplicate, indefinite hold without runbook, unbounded resource growth |
| 38 | exercise incident, restore, key, receipt-conflict, and support runbooks | 25–37 | owner-authorized drills and cleanup receipts | operator must view raw payload, wrong authority can re-enable/delete, restoration skips reconciliation |
| 39 | obtain HD-G5-01–03 and other blocking human decisions | evidence from 36–38 | signed decision records with values, consequences, review triggers, conservative fallback | a value remains implicit in code/configuration or decision exceeds measured evidence |
| 40 | produce `g5-gate.json` and architecture review | 1–39 | exact evidence/ADR/owner/human-decision binding with all zero-tolerance counters | missing/stale/waived invariant, unsupported environment, unassigned owner, expired exception |
| 41 | update the main technical baseline for accepted G5 refinements only | passed 40 and forum action | baseline patch separating invariant, measured profile, and human decision | adjacent component redesign, provisional number hardened as timeless, receipt meaning broadened |
| 42 | permit production-shaped **synthetic** endpoint delivery integration | 40–41 and predecessor exact gates | same release/page/store/transport synthetic chain; no real activity | real source/value, production credentials/signing, or pilot authority appears |
| 43 | proceed to release, device identity/network, real inbox/idempotency, capacity, outage, deletion/restore gates | 42 and global proof order | later topic evidence | G5 pass is treated as server, 6,000-device, retention, deletion, pilot, or production approval |

## 13.1 Parallel work and dependency rules

The pure reference model, DDL, crypto envelope, migration fixtures, synthetic server, and disconnected fault scripts may proceed in parallel after the contracts are frozen. Exact provider admission must precede runtime claims. Batch/attempt/receipt work must use committed T1 events only. Cleanup code may exist as a dry-run candidate but its destructive branch remains compile-time or release-artifact disabled until HD-G5-03 and the later deletion/restore gate. A failed G5 invariant stops all delivery-dependent work even when unrelated performance tests pass.

---

# 14. Open-source repository assessment table

**Assessment rule.** Popularity, download counts, or a reputable maintainer are not dependency evidence. Each candidate below is evaluated against UAM's Windows endpoint, one-writer, privacy-minimized, offline, realm-bound, immutable-batch, and explicit-receipt threat model. “Reference only” authorizes design study and pinned T1 test comparison; it does not authorize copying code, shipping a binary, adopting its wire protocol, or inheriting its license assumptions.

| Repository and reviewed revision | Relevant files/directories | License and compatibility | Maintenance, tests, and security posture | Architectural similarity and threat-model difference | Reusable ideas; ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| [SQLite official source](https://sqlite.org/src/doc/trunk/README.md), release **3.53.4**, source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`, 24 Jul 2026 | `src/`, `test/`, `ext/recover/`, `test/fuzzcheck.c`, `test/dbfuzz2.c`; official [release history](https://www.sqlite.org/changes.html) | core SQLite is public domain [W31]; bundled extensions/tools can have separate terms and must be inventoried | actively maintained; unusually extensive upstream test, fuzz, corruption, and fault infrastructure; 3.53.0/3.51.3 WAL-reset fix demonstrates that exact patch/source identity matters | exact embedded engine and storage model; upstream does not define UAM's event identity, realm, encryption, receipt, cleanup, or support policy | reuse documented transaction/checkpoint/backup/result-code patterns and upstream test ideas; do not copy internal test-only controls into production or assume upstream tests prove Windows estate fitness | **Runtime engine candidate/required reference**, only as an exact admitted native binary and compile profile |
| [Microsoft.Data.Sqlite.Core](https://github.com/dotnet/efcore/tree/v10.0.10/src/Microsoft.Data.Sqlite.Core), tag **v10.0.10**, 14 Jul 2026 line | provider source, connection/command/reader/transaction APIs; EF Core repository tests around SQLite | MIT; native SQLite provider/bundle is separate, so package graph and loaded DLL require independent license/source mapping | Microsoft-maintained and aligned to supported .NET; broad repository CI; documentation states async ADO.NET methods execute synchronously [W15] | fits C# default and can provide a narrow managed layer; it is not a one-writer state machine, encryption layer, or native-binary assurance mechanism | reuse parameterization, transaction and error abstractions after spike; do not use EF ORM/migrations, shared cache, provider defaults, pooling, or managed package version as proof of native behavior | **Managed adapter candidate after admission**; direct native calls may still be required for exact checkpoint/config/backup evidence |
| [SQLCipher](https://github.com/sqlcipher/sqlcipher/tree/810db22f575ee7cf94ea96a3e91622b5fcece3dc), **v4.17.0**, commit `810db22f575ee7cf94ea96a3e91622b5fcece3dc`, 8 Jul 2026 | `src/`, `test/`, `sqlcipher-resources/`, `CHANGELOG.md`, provider integrations | community edition license text is BSD-3-Clause-style in reviewed repository; commercial support/features have separate terms; fork/native packaging and cryptographic export/compliance need Legal/Security | active 2026 release, based on SQLite 3.53.3; project tests and upstream-derived tests, but its changelog notes format/compat changes across major profiles and not every upstream configuration is equivalent | encrypts full database pages including more metadata than column encryption; adds a divergent native engine, key PRAGMAs, migration/backup/recovery and licensing/support surface | reuse compatibility-test, wrong-key, format-version, rekey, corruption and memory-test ideas; do not copy default settings, assume SQLCipher tag equals current SQLite, or adopt solely because “encrypted SQLite” sounds simpler | **Conditional dependency alternative**, only if HD-G5-02 requires full-file/metadata protection and a separate bake-off passes |
| [Litestream](https://github.com/benbjohnson/litestream/tree/4e3f0c0f98a8808788c721b3637b41e7f9ce4a9c), **v0.5.15**, commit `4e3f0c0f98a8808788c721b3637b41e7f9ce4a9c`, 21 Jul 2026 | `db.go`, `db_shutdown_test.go`, `compactor.go`, `leaser.go`, `replica.go`, `restore_fuzz_test.go`, `wal_reader.go`, `tests/`, `testdata/`, `SECURITY.md` | Apache-2.0 in reviewed repository; remote backends add SDK licenses/credentials/egress | active signed release; changes include bounded sync work, hardened checkpoint snapshots, surfaced disk-full staging errors, fsync race fixes, and restore soak tests; Windows binaries are explicitly not officially supported | strong WAL, checkpoint, replication, restore, disk-full, and shutdown lessons; its purpose is continuous off-device replication with remote credentials, unlike UAM's endpoint custody/receipt contract | reuse fault categories, bounded work, checkpoint snapshot, restore soak, first-failure retention; do not ship its daemon, remote credentials, replication protocol, VFS, or treat a replica as server custody | **Reference only**; Windows unsupported makes it unsuitable as UAM dependency |
| [Wolverine](https://github.com/JasperFx/wolverine/tree/d49a1f5b472aa4b2765528503337ce0ce131e744), **V6.24.2**, commit `d49a1f5b472aa4b2765528503337ce0ce131e744`, 30 Jul 2026 | `src/Persistence/Wolverine.Sqlite/Schema/`, `Transport/`, `SqliteAdvisoryLock.cs`, `SqliteBackedPersistence.cs`, `SqliteMessageStore.cs`; SQLite persistence tests | MIT; optional paid support exists; broad dependency graph if consumed | very active, signed 2026 releases, extensive integration/compliance tests and recent durability/ack regressions documented in releases | durable messaging/outbox/inbox and SQLite persistence are close concepts; Wolverine is a server-side message bus/framework with broad transports, handlers, dead letters, diagnostics and multi-node semantics absent from UAM endpoint | reuse compliance-test shapes, stable envelope identity, pause/recovery, dead-letter and ACK regression lessons; do not import framework, handler discovery, transport abstractions, broad diagnostics, leasing, or mutable admin operations | **Reference only**; total dependency and threat surface is disproportionate |
| [goqite](https://github.com/maragudk/goqite/tree/471f9d49ce356737fc756a287007d7b4c54c61e1), **v0.4.0**, commit `471f9d49ce356737fc756a287007d7b4c54c61e1`, 9 Feb 2026 | `goqite.go`, `goqite_test.go`, `schema_sqlite.sql`, `jobs/`, `internal/` | MIT; Go runtime/library mismatch for UAM | maintained release with tests; signed tag; supports SQLite/PostgreSQL, priorities, visibility timeout extension, receive/delete patterns | useful small durable queue comparison; its visibility-timeout worker queue permits re-delivery/ownership semantics that differ from UAM's immutable outbound batch and external receipt | reuse queue-state tests, UTC/timeout and priority edge cases; do not copy polling, lease-as-ACK, delete-on-consume, arbitrary payload or multi-engine abstraction | **Reference only** |
| [Watermill SQLite Pub/Sub](https://github.com/ThreeDotsLabs/watermill-sqlite/tree/a2a915319684f030296ccb15403b37f292640ad2), tags **wmsqlitemodernc/v0.1.2** and **wmsqlitezombiezen/v0.1.2**, commit `a2a915319684f030296ccb15403b37f292640ad2`, 22 Sep 2025 | `wmsqlitemodernc/`, `wmsqlitezombiezen/`, `test/`, `DEVELOPMENT.md` | MIT; Go and alternative SQLite implementations are not UAM runtime candidates | repository labels implementation beta/stable but not widely production-tested; signed tags; v0.1.2 fixed idle polling that wrote/locked the DB, created WAL replication traffic, slowed restore, and consumed CPU | demonstrates how “read-only” polling can still mutate/lock and harm WAL/backup behavior; pub/sub consumer model is broader and less privacy constrained | reuse idle/no-write tests and WAL side-effect awareness; do not copy busy polling, dual driver variants, pub/sub API, or treat beta status as endpoint fitness | **Reference only** |
| [TLA+ tools](https://github.com/tlaplus/tlaplus/tree/30cc360), **v1.8.0 Clarke pre-release**, commit `30cc360`, 18 Jul 2026 | `tlatools/org.lamport.tlatools/`, `tla2tools.jar`, `docs/`, TLC models/examples | MIT; Java/JVM toolchain and artifact provenance must be admitted; model files themselves remain UAM-owned | active command-line tools and issue tracking; 1.8.0 is marked pre-release; the Toolbox has separate UI/maintenance concerns, so use the CLI artifact in a sealed lane | directly suitable for finite state/invariant exploration; it cannot model real SQLite flush, Windows process, provider, filesystem or crypto implementation behavior | reuse TLC state exploration, invariants, counterexamples and simulation; do not treat a model pass as runtime proof or require the Toolbox GUI in CI | **Test-tool candidate after exact artifact admission**; reference model remains independently reviewable text |

## 14.1 Commercial non-open-source alternative

[SQLite SEE](https://sqlite.org/see) is an official SQLite encryption extension with commercial licensing and source access. The [purchase page](https://sqlite.org/purchase/see) listed a perpetual source license at the reviewed date; price and terms are point-in-time procurement facts, not architecture. SEE could reduce upstream-fork distance compared with another encrypted fork, but it still requires Legal/Procurement, cryptographic-profile, build, key, migration, backup, incident, Windows, performance, and support evidence. It is **reference/conditional alternative only**, not part of the open-source dependency recommendation [W29].

## 14.2 Repository review conclusion

The recommended initial dependency surface is intentionally small: one exact SQLite native build, one narrow C# adapter if it exposes the required behavior, platform cryptography already present in .NET/Windows, and a model-checking tool only in tests. Litestream, Wolverine, goqite, and Watermill provide valuable negative and fault-test patterns but have different authority, data, transport, and operations models. SQLCipher or SEE becomes rational only after the human encryption-assurance decision demonstrates that application payload encryption and protected metadata are insufficient.

---

# 15. Source register with stable links, dates, versions/commits, claims, and limitations

## 15.1 Supplied internal evidence

| Ref | Source and reviewed date | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline 31 Jul 2026, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted endpoint topology, minimization, one-writer WAL, at-least-once, receipt custody, realm, release, no-loss and restore invariants | condensed accepted baseline, not runtime proof or production authority |
| I02 | `04-data-and-schema-evidence-summary.md`, reviewed 31 Jul 2026, SHA-256 `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | target source/generation/cursor/event/batch/receipt concepts and absence of representative volume/RPO/retention evidence | contains no production rows, throughput or approved semantics |
| I03 | `05-decisions-contradictions-and-gates.md`, reviewed 31 Jul 2026, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted direct G5 proof order, one-writer/WAL and receipt/idempotency rules | implementation research baseline, not unconditional approval |
| I04 | `06-research-evidence-rules.md`, reviewed 31 Jul 2026, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source-quality rules, human authority, conflict/change-proposal discipline | research governance, not technical fact |
| I05 | `batch-01-review-result.md` (local attachment `batch-01-review-result(3).md`), 31 Jul 2026, SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | strict contracts, UUIDv7, G1 process boundaries, privacy permits, repository/build/dependency controls | predecessor accepted with conditions; exact Windows/codec/crypto values remain gated |
| I06 | `batch-02-review-result.md`, 31 Jul 2026, SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | page-owned progress, source identity, stable event persistence, whole-page G5 transaction handoff, no semantic replay | G2/G3/G4 proof remains required for live source; G5 implementation was not yet proved |

## 15.2 Primary public technical sources

| Ref | Primary source, document/release date and reviewed version | Claim supported | Limitation |
|---|---|---|---|
| W01 | SQLite, [Release History](https://www.sqlite.org/changes.html), **3.53.4**, 24 Jul 2026, source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`, reviewed 31 Jul 2026 | current reviewed SQLite point; exact source identity; 3.53.0/3.51.3 WAL-reset corruption fix history | release page does not prove provider packaging, compile options or UAM fitness |
| W02 | SQLite, [Write-Ahead Logging](https://www.sqlite.org/wal.html), page updated 13 Apr 2026, reviewed 31 Jul 2026 | WAL concurrency, FULL vs NORMAL sync behavior, automatic/application checkpoint behavior, starvation and WAL persistence | filesystem/firmware durability and UAM workload remain experimental |
| W03 | SQLite, [PRAGMA statements](https://sqlite.org/pragma.html), page updated 4 Jun 2026, reviewed 31 Jul 2026 | foreign keys, synchronous, trusted schema, WAL auto-checkpoint, integrity/quick check, max page count, optimize and related connection settings | exact support/default/effect depends on selected native build; some PRAGMAs are connection-local |
| W04 | SQLite, [`sqlite3_wal_checkpoint_v2`](https://sqlite.org/c3ref/wal_checkpoint_v2.html), reviewed 31 Jul 2026 | PASSIVE/FULL/RESTART/TRUNCATE checkpoint semantics and busy/result behavior | does not decide UAM thresholds or reader scheduling |
| W05 | SQLite, [Atomic Commit](https://www.sqlite.org/atomiccommit.html), reviewed 31 Jul 2026 | transaction/flush model and assumptions about filesystem behavior | storage stacks can violate assumptions; power-cut proof remains required |
| W06 | SQLite, [How To Corrupt An SQLite Database File](https://www.sqlite.org/howtocorrupt.html), reviewed 31 Jul 2026 | misuse, locking, WAL separation, unsafe copy/delete and hardware/filesystem corruption modes | not a UAM recovery runbook or proof of cause for an incident |
| W07 | SQLite, [STRICT Tables](https://www.sqlite.org/stricttables.html), reviewed 31 Jul 2026 | `STRICT` table behavior and integrity checking of column types | domain/state invariants still require application checks/triggers |
| W08 | SQLite, [Online Backup API](https://sqlite.org/backup.html) and [C API](https://sqlite.org/c3ref/backup_finish.html), reviewed 31 Jul 2026 | coherent online copy, step/DONE/finish semantics, retry and snapshot behavior | encryption keys, destination protection, RPO, restore readiness and UAM resource limits are separate |
| W09 | SQLite, [Recovery API](https://sqlite.org/recovery.html), reviewed 31 Jul 2026 | recovery is best-effort extraction from corrupt databases and may need interpretation | recovered output is not proof of complete/correct relational or delivery state; no automatic acceptance |
| W10 | SQLite, [Result and extended result codes](https://sqlite.org/rescode.html), page current 18 Feb 2026, reviewed 31 Jul 2026 | distinguish BUSY, LOCKED, FULL, IOERR subcodes, CORRUPT, NOTADB, CANTOPEN, READONLY and others | provider must preserve extended codes; codes do not by themselves determine safe recovery |
| W11 | SQLite, [ALTER TABLE](https://www.sqlite.org/lang_altertable.html), reviewed 31 Jul 2026 | supported schema changes and need for explicit copy/verify patterns for complex/destructive transforms | newer releases can add features; UAM still needs N/N-1 compatibility and fault evidence |
| W12 | SQLite, [Foreign Key Support](https://sqlite.org/foreignkeys.html), reviewed 31 Jul 2026 | foreign keys must be enabled per connection; parent/child/index and deferred behavior | FK constraints do not express all lifecycle invariants |
| W13 | SQLite, [Transactions](https://sqlite.org/lang_transaction.html), reviewed 31 Jul 2026 | DEFERRED/IMMEDIATE/EXCLUSIVE behavior, implicit/explicit transactions, busy outcomes | managed/provider cancellation and exact timing require experiments |
| W14 | SQLite, [VACUUM](https://sqlite.org/lang_vacuum.html), reviewed 31 Jul 2026 | rewrite/free-space behavior and `VACUUM INTO` copy capability | can require substantial free space and is not the default backup/migration mechanism |
| W15 | Microsoft, [Async limitations in Microsoft.Data.Sqlite](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/async), reviewed 31 Jul 2026 | SQLite does not support asynchronous I/O; provider async ADO.NET methods execute synchronously; WAL suggested for concurrency | does not establish one-writer correctness, latency or native identity |
| W16 | Microsoft, [SQLite connection strings](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/connection-strings), reviewed 31 Jul 2026 | mode/cache/pooling/foreign-key connection options; shared-cache cautions | options can differ by package/native version; UAM verifies actual connection state |
| W17 | Microsoft, [.NET `AesGcm`](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.aesgcm?view=net-10.0) and [`Encrypt`](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.aesgcm.encrypt?view=net-10.0), .NET 10 docs reviewed 31 Jul 2026 | authenticated encryption API, nonce/tag/AAD inputs and platform support surface | correct nonce/key lifecycle, zeroization, FIPS/compliance and UAM performance remain design/test obligations |
| W18 | Microsoft, [.NET cross-platform cryptography](https://learn.microsoft.com/en-us/dotnet/standard/security/cross-platform-cryptography), reviewed 31 Jul 2026 | .NET algorithm implementation/provider behavior varies by OS and runtime | does not select an enterprise assurance profile or prove installed provider configuration |
| W19 | Microsoft, [`DataProtectionScope`](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.dataprotectionscope) and [How to use data protection](https://learn.microsoft.com/en-us/dotnet/standard/security/how-to-use-data-protection), how-to updated 22 Jul 2026 | DPAPI user/machine scope and documented warning that machine-scope data may be unprotected by other processes on the computer | exact ACL/service/attacker behavior and recovery policy remain lab/human decisions |
| W20 | Microsoft, [CNG key storage providers](https://learn.microsoft.com/en-us/windows/win32/seccertenroll/cng-key-storage-providers), reviewed 31 Jul 2026 | Microsoft Software and Platform Crypto Providers and provider concepts | availability/algorithms/TPM state vary by machine and policy |
| W21 | Microsoft, [TPM fundamentals](https://learn.microsoft.com/en-us/windows/security/hardware-security/tpm/tpm-fundamentals) and [How Windows uses the TPM](https://learn.microsoft.com/en-us/windows/security/hardware-security/tpm/how-windows-uses-the-tpm), reviewed 31 Jul 2026 | TPM-backed key isolation and Windows uses/capability context | not evidence of coverage, ownership, health, VDI behavior or recoverability in the UAM estate |
| W22 | Microsoft, [`NCryptCreatePersistedKey`](https://learn.microsoft.com/en-us/windows/win32/api/ncrypt/nf-ncrypt-ncryptcreatepersistedkey), reviewed 31 Jul 2026 | creation of persisted CNG keys in selected key storage provider | exact flags, ACLs, algorithms and provider support must be proved |
| W23 | Microsoft, [CNG key storage property identifiers](https://learn.microsoft.com/en-us/windows/win32/seccng/key-storage-property-identifiers) and [`NCryptSetProperty`](https://learn.microsoft.com/en-us/windows/win32/api/ncrypt/nf-ncrypt-ncryptsetproperty), reviewed 31 Jul 2026 | key properties, export policy, usage, length and security descriptor configuration | property support and effective security depend on provider and timing; lab readback/effective-access required |
| W24 | Microsoft, [Windows privilege constants](https://learn.microsoft.com/en-us/windows/win32/secauthz/privilege-constants) and [process security/access rights](https://learn.microsoft.com/en-us/windows/win32/procthread/process-security-and-access-rights), reviewed 31 Jul 2026 | local administrators/debug privilege can open/manipulate processes and defeat same-machine secrecy assumptions | does not mean every attack succeeds automatically; defines residual-risk boundary rather than authorization |
| W25 | Microsoft Security Development Lifecycle, [Cryptographic recommendations](https://learn.microsoft.com/en-us/security/engineering/cryptographic-recommendations), 18 Aug 2025, reviewed 31 Jul 2026 | current Microsoft algorithm/key-management guidance and need for authenticated encryption/approved primitives | general guidance; enterprise compliance and algorithm profile remain human/security decisions |
| W26 | IETF/RFC Editor, [RFC 9530 — Digest Fields](https://www.rfc-editor.org/rfc/rfc9530.html), Feb 2024 | content digest syntax/semantics and distinction between integrity metadata and sender authentication | does not define UAM receipt custody or replace authenticated receipt binding |
| W27 | IETF/RFC Editor, [RFC 9562 — UUIDs](https://www.rfc-editor.org/rfc/rfc9562.html), May 2024 | UUIDv7 layout and canonical UUID rules | UUID timestamp is not source/business time, durability proof or authorization |
| W28 | SQLCipher, [v4.17.0 release](https://github.com/sqlcipher/sqlcipher/releases/tag/v4.17.0), [commit tree](https://github.com/sqlcipher/sqlcipher/tree/810db22f575ee7cf94ea96a3e91622b5fcece3dc), 8 Jul 2026 | current reviewed SQLCipher release, SQLite 3.53.3 baseline and encryption-fork alternative | dependency/license/support/format/performance/UAM fit not approved |
| W29 | SQLite, [SQLite Encryption Extension](https://sqlite.org/see) and [purchase page](https://sqlite.org/purchase/see), reviewed 31 Jul 2026 | official commercial full-database encryption alternative and point-in-time procurement route | terms/pricing/support can change; technical and legal fit require separate review |
| W30 | Microsoft, [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), reviewed 31 Jul 2026 | .NET 10 active LTS; latest listed patch 10.0.10 dated 14 Jul 2026; support through 14 Nov 2028; supported systems must remain current on patches | point-in-time lifecycle input, not timeless architecture or UAM runtime proof |
| W31 | SQLite, [Copyright/public-domain statement](https://sqlite.org/copyright.html), reviewed 31 Jul 2026 | SQLite core source is dedicated to the public domain | ancillary tools/extensions/build distributions and third-party notices still require inventory |
| W32 | Microsoft/EF Core, [`Microsoft.Data.Sqlite.Core` v10.0.10 source](https://github.com/dotnet/efcore/tree/v10.0.10/src/Microsoft.Data.Sqlite.Core), reviewed 31 Jul 2026 | exact reviewed managed-provider source tree and MIT repository license | does not include/prove the loaded native SQLite binary or expose every low-level control |

## 15.3 Open-source engineering references

| Ref | Repository, exact revision, release date | Claim/idea supported | Limitation and classification |
|---|---|---|---|
| O01 | SQLite 3.53.4 source ID `bf7c7f...`, 24 Jul 2026 | engine/test/fuzz/recovery implementation reference | runtime candidate only under exact binary/compile/source admission |
| O02 | SQLCipher v4.17.0, commit `810db22f575ee7cf94ea96a3e91622b5fcece3dc`, 8 Jul 2026 | full-file encryption, key/format/rekey test ideas | conditional alternative, divergent native/format/license/support surface |
| O03 | Litestream v0.5.15, commit `4e3f0c0f98a8808788c721b3637b41e7f9ce4a9c`, 21 Jul 2026 | WAL/checkpoint/disk-full/fsync/restore-soak fault patterns | reference only; Windows not officially supported and remote replication differs |
| O04 | Wolverine V6.24.2, commit `d49a1f5b472aa4b2765528503337ce0ce131e744`, 30 Jul 2026 | durable messaging compliance, ACK and pause/recovery regressions | reference only; broad server message-bus framework |
| O05 | goqite v0.4.0, commit `471f9d49ce356737fc756a287007d7b4c54c61e1`, 9 Feb 2026 | small queue priority/visibility/delete tests | reference only; worker queue semantics and Go stack differ |
| O06 | Watermill SQLite tags `wmsqlitemodernc/v0.1.2`, `wmsqlitezombiezen/v0.1.2`, commit `a2a915319684f030296ccb15403b37f292640ad2`, 22 Sep 2025 | idle polling can cause DB locks/writes/WAL replication and restore cost | reference only; beta/limited production evidence and different drivers/model |
| O07 | TLA+ v1.8.0 Clarke pre-release, commit `30cc360`, 18 Jul 2026 | systematic finite-state exploration and counterexample generation | test-tool candidate only; model does not prove SQLite/Windows execution |
| O08 | Microsoft.Data.Sqlite.Core v10.0.10 source tree, 14 Jul 2026 line | narrow C# provider candidate and package source mapping | dependency candidate only after native/API/behavior admission |

## 15.4 Source-quality conclusion

Primary SQLite and Microsoft documentation establishes capabilities and failure semantics, not UAM fitness. Exact runtime evidence must include the loaded native SQLite source ID and compile options because managed package labels can hide or substitute native binaries. Open-source systems demonstrate useful failure patterns, especially around ACK ordering, idle polling, checkpointing, disk full, restore, and state ownership, but none has UAM's exact privacy ceiling, user/session topology, realm binding, receipt custody, or human deletion authority. This result therefore treats external architectures as challengers and test inputs, not templates to copy wholesale.

---

# 16. Confidence table for every major conclusion

Confidence describes evidence strength, not probability. **High** means primary documentation plus strong consistency with accepted invariants; **Medium** means the design is reasoned and testable but material environment or operations evidence is missing; **Low** means the conclusion is mostly a provisional numerical/profile choice or human decision.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| one realm/installation/store epoch per database is the safest initial isolation | **High** | simple physical, key, backup and recovery boundary aligned with accepted realm invariant | measured operational impossibility or a formally/enforceably equivalent multi-realm design with lower total risk and migration evidence |
| one dedicated writer actor is the correct connection-ownership model | **High** | matches SQLite's one-writer behavior and makes transaction/fault boundaries enumerable | throughput/resource measurements showing an unacceptable bottleneck plus a multi-writer model that preserves every invariant |
| WAL with `synchronous=FULL` is the correct G5 durability candidate | **High for documented semantics; Medium for estate durability** | SQLite explicitly syncs WAL on FULL commit; predecessor requires crash-safe cursor/effect | hard-power evidence showing the target storage stack violates durability, or a supported alternative journal/profile with superior proof |
| application-owned checkpointing is safer than default auto-checkpointing for this agent | **High** | controls latency, exposes starvation, and prevents a second checkpoint owner | evidence that exact native/provider cannot support it safely or that a simpler default meets all latency/WAL/fault gates |
| page effects and cursor must share one SQLite transaction | **High** | direct accepted invariant and simplest atomic boundary | no ordinary evidence should weaken it; only an explicit baseline change replacing the source/progress model |
| stable native natural identity must exclude runtime and interpretation versions | **High** | prevents upgrade-generated duplicates and preserves Batch 02 decision | approved correction/event-sourcing model that explicitly supersedes rather than duplicates effects |
| UUIDv7 event identity should be minted once and persisted | **High** | standard interoperable ID and stable retry behavior | central contract constraint requiring another standard profile with migration/dedupe evidence |
| immutable sealed batch membership and exact bytes are required | **High** | makes receipt/hash/replay deterministic and auditable | a streaming protocol with equally strong content identity and lost-response proof at lower cost |
| delivery attempt must be durable before network write | **High** | prevents crash ambiguity from being misclassified as never sent | a transport primitive offering atomic send-and-local-record semantics with primary evidence and no new failure domain |
| ambiguous sends should replay the exact same batch | **High** | at-least-once plus server uniqueness makes one final effect; new batch would widen ambiguity | real server contract that proves a different status-query/recovery protocol while preserving stable effect identity |
| receipt is durable custody, not semantic success | **High** | explicitly accepted predecessor boundary | an approved cross-system contract redefines custody/failure domain through a formal baseline change; portal/materialization still remain separate |
| HTTP status or completed TLS is insufficient ACK authority | **High** | neither proves durable custody of exact content | a protocol with cryptographic/durable proof equivalent to the receipt and accepted by ingestion/storage owners |
| ordinary cleanup must require matching receipt, grace, clock confidence and no hold | **High for safety rule; Low for timing** | prevents silent loss; exact grace/RPO are human-owned and absent | approved HD-G5-03 plus restore/deletion evidence could set the predicates, not remove receipt binding |
| application AES-256-GCM before SQLite bind is the smallest initial payload protection design | **Medium-High** | standard platform AEAD, avoids fork, protects payloads in WAL/backups/tools | security decision requiring metadata/full-file confidentiality, nonce/key incident, performance failure, or full-db alternative proving lower total risk |
| a CNG KEK plus random DEKs is preferable to DPAPI LocalMachine per payload | **Medium-High** | supports non-exportability/profile separation and independent key rotation; DPAPI machine scope has broad same-machine residual risk | exact estate/provider/API evidence showing CNG cannot meet offline/recovery requirements or approved DPAPI assurance scope |
| TPM-backed KEK should be preferred where proved, but cannot be assumed | **Medium** | platform isolation is attractive; coverage, VDI, clearing and recovery are unknown | approved inventory and repeated create/open/restart/recovery tests could raise confidence; incompatibility could remove the profile |
| application encryption cannot protect against a determined local administrator controlling the running endpoint | **High** | administrator/debug/process and software-key authority exceed the endpoint trust boundary | a stronger hardware/isolated execution boundary and approved threat model; it would still not solve all endpoint control risks |
| reserve space and pressure-driven collection pause are necessary | **High for principle; Low for exact bytes** | receipt/recovery writes need margin and no-silent-loss forbids drop-on-full | measured write amplification/outage/restore data and human disk budget determine exact reserve and thresholds |
| unacknowledged events must never be sampled, aged out or overwritten automatically | **High** | direct accepted invariant | only explicit human loss policy plus baseline change; absence of disk is not implicit authority |
| expand/contract migration with N/N-1 compatibility is the right rollback model | **High logically; Medium operationally** | limits irreversible release failure and handles SQLite ALTER constraints | migration duration/disk evidence could change mechanism; any alternative must still prove rollback across every durable state |
| backup must be API-coherent, verified and restore-tested | **High** | main/WAL/SHM filesystem copying is unsafe; backup existence alone is not readiness | another exact SQLite-supported snapshot mechanism with equal coherence/key/reconciliation proof |
| automatic `.recover`, salvage acceptance or delete-and-recreate is unsafe | **High** | cannot establish complete relational/delivery/cursor truth and would silently change state | a narrowly proved repair for a specific corruption class with independent invariant/reconciliation evidence and human authority |
| result-code taxonomy and bounded retry are required | **High** | BUSY, FULL, IOERR, CORRUPT, NOTADB and key failures require different containment | provider/native inability to expose extended codes would force a narrower adapter or stop, not generic retry |
| fixed low-cardinality, value-free observability is sufficient for initial G5 operations | **Medium-High** | state/reason/count/byte data can diagnose most durability conditions without payloads | runbook exercises showing an unavoidable gap may add a bounded approved field, never an unrestricted dump |
| arbitrary local SQL/support shell is incompatible with the trust model | **High** | bypasses schema, realm, audit, privacy and destructive authorization | no expected ordinary change; an offline incident tool remains separately authorized and isolated from normal support |
| TLA+/equivalent model checking is useful but not sufficient | **High** | explores state transitions/counterexamples; cannot model real storage flush, AV, process or provider behavior | a superior executable formal tool may replace it, but runtime fault injection remains mandatory |
| exact current SQLite/.NET/provider versions must be execution-time inputs | **High** | lifecycle/advisories and loaded native identity change; recent SQLite WAL defects are point-in-time evidence | no stable timeless patch exists; process may change but exact identity requirement remains |
| Microsoft.Data.Sqlite.Core is a plausible managed adapter, not yet an accepted complete stack | **Medium** | maintained and C#-aligned but native/API/async limitations require spike | exact admission and API/fault evidence can accept it; hidden behavior or native mismatch can reject it |
| SQLCipher or SEE should remain conditional rather than default | **Medium-High** | full-file protection adds native, format, migration, licensing/support cost absent an approved need | HD-G5-02 could require it, followed by a successful identical fault/migration/recovery bake-off |
| the exact batch sizes, retry delays, busy timeout, WAL threshold, quota, reserve, overlap and grace are not research conclusions | **High** | representative distributions, budgets and SLO/RPO/RTO are explicitly absent | approved measurements and owner decisions can set versioned values; they remain reviewable configuration, not timeless architecture |
| G5 can prove endpoint durability only for a named exact environment | **High** | documentation cannot prove filesystem, firmware, AV, VM or implementation behavior | broader repeated evidence can expand the support matrix; it cannot make the claim universal |
| a G5 pass is not server inbox, 6,000-endpoint capacity, retention/deletion, pilot or production approval | **High** | accepted proof-gate order and human authority are explicit | only later technical gates and designated authorities can change those statuses |

# Final residual risk and next stop/go gate

**Residual risk.** The proposed design still cannot guarantee durability when storage firmware, virtualization, or the operating system falsely reports completed flushes; recover data from a physically destroyed endpoint without an approved backup or prior receipt; keep plaintext secret from a determined local administrator or privileged security product while the process is using it; recover a non-exportable key after TPM clear or machine loss unless an approved recovery profile exists; infer the server's real custody failure domain from an HTTP response; or decide how much local data, outage, disk use, retention, and replay risk the organization should accept. SQLite corruption tools, encryption, checksums, retries, and receipts reduce or expose risk; they do not make uncertain data true.

**Operational cost.** FULL synchronization, encrypted payloads, immutable wire bytes, exact backups, N/N-1 migrations, recurring native/browser/runtime qualification, power/disk/corruption labs, key lifecycle, low-level incident skills, and privacy-safe support are real engineering and support costs. A simpler implementation is cheaper only if it still meets the zero-tolerance invariants under the same fault campaign. No exact budget or staffing commitment is available here.

**Human dependencies.** Maximum offline duration and pause/loss policy, local encryption assurance, endpoint disk budget, ACK grace/RPO, backup/restore target, retention/deletion, metric/access policy, supported estate, incident authority, dependency/support procurement, and production risk remain explicit decisions. Conservative temporary behavior is: collect synthetic data only; encrypt payloads in the prototype; do not destructively clean up; pause rather than drop when protected space is exhausted; disable a capability on key/corruption/receipt/migration uncertainty.

**Next stop/go gate.** **GO** for repository tasks 1–38 using T1 fictional data and an approved disposable Windows lab after their predecessors. **STOP** before production-shaped cleanup, live-source delivery, pilot, or production until all of these are true:

```text
G5_STOP_GO =
    exact predecessor G1–G4 evidence is valid for the build/environment
    AND executable model invariants pass
    AND G5-01 through G5-51 pass on every claimed capability
    AND cursor_ahead_count = 0
    AND missing_committed_effect_count = 0
    AND unacknowledged_or_held_deleted_count = 0
    AND duplicate_final_server_effect_count = 0
    AND receipt_conflict_accepted_count = 0
    AND batch_content_changed_after_seal_count = 0
    AND encryption_nonce_reuse_count = 0
    AND cross_realm_transition_count = 0
    AND migration_or_restore_unreconciled_activation_count = 0
    AND privacy_canary_escape_count = 0
    AND cleanup_residue_count = 0
    AND exact runtime/native/provider/dependency evidence passes
    AND blocking ADR count = 0
    AND blocking owner count = 0
    AND HD-G5-01, HD-G5-02 and HD-G5-03 are decided for the requested scope
    AND the real server receipt/custody boundary has its own later proof
    AND designated production authority approves the remaining risk.
```

A nonzero primary invariant, missing fault campaign, unsupported environment, unassigned owner, expired exception, or implicitly enabled human choice is **STOP**. The response is containment, recovery evidence, and an ADR/change review—not a silent retry increase, local database reset, data deletion, or weaker receipt definition.
