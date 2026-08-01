# Batch 02 review result — endpoint source and privacy transformation

**Result path:** `results/batch-02-endpoint-data/batch-02-review-result.md`  
**Review date:** 31 July 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — IMPLEMENTATION PROTOTYPES ONLY; G2/G3/G4 PROOF GATES REMAIN OPEN**  
**Authority boundary:** endpoint Edge discovery, acquisition, source continuity, cursor semantics, URL-host matching, and pre-IPC privacy-transformation architecture; **not** legal, privacy, employee-monitoring, source/field, identity, retention, access, budget, licensing, staffing, SLO/RPO/RTO, pilot, production-risk, or deployment approval  
**Predecessor:** Batch 01 review result, accepted with mandatory conditions  
**Primary batch gate:** **G1 must pass before any live-source acquisition. G2/G3 and G4 must pass before any source value enters a production outbox. G5 must subsequently prove the atomic event/progress/cursor crash invariant before production-shaped delivery.**  
**Immediate safe permission:** pure contracts and models, T1 fictional fixtures, synthetic Edge profiles and localhost visits, offline URL/rule corpora, disconnected lab scripts, and—after G1 evidence—disposable-VM source and privacy prototypes using no real activity data  
**Immediate prohibition:** real activity, production-derived URLs or profiles, production source enablement, raw URL outside the fixed Task Host, production outbox integration, pilot, production deployment, and any silent weakening of the ordered proof gates

## Evidence vocabulary

This review uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed Batch 02 implementation baseline. They do not convert a **HUMAN DECISION** into approval or a documented platform capability into UAM fitness.

## Evidence boundary and file-presence record

**FACT.** All six allowlisted Project files were present. The accepted predecessor was supplied under the local attachment name `batch-01-review-result(3).md`; its title and declared result path identify it as the allowlisted `batch-01-review-result.md`. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted file | SHA-256 of reviewed attachment | Use and limitation |
|---|---|---|---|
| I01 | `07-g2-g3-edge-acquisition-cursor-result.md` | `d839aa76a7fc73fba7dba02c26635746a5babdc059cd1eeaa36e32a9913ce384` | Edge root/profile discovery, live SQLite acquisition, source/generation continuity, native-ID cursor, synthetic fixtures, failure tests; topic recommendation, not passed runtime evidence |
| I02 | `08-g4-url-privacy-transformation-result.md` | `7f7ecff4b991012fc32e0c15303f97c43409993e4ced2e868e0df4f5f38e08f7` | URL parsing, host matching, privacy transformation, canaries, differential tests; topic recommendation, not field/legal/production authority |
| I03 | `batch-01-review-result.md` (local attachment `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted predecessor contracts, G1 boundary, privacy lattice, application identity/matcher, repository and evidence gates |
| I04 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | non-negotiable endpoint, privacy, durability, realm, release, restore and deletion invariants |
| I05 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted acquisition choice and ordered G0–G12 proof gates |
| I06 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, primary-source rules, human-authority boundary, and change-proposal discipline |

No accepted-baseline change proposal is raised by this review. Several topic-level recommendations are narrowed or corrected so that they do not silently redefine accepted identity, privacy, or durability invariants.

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The batch is coherent enough to authorize implementation prototypes for:

1. bounded, exact-session Edge root and profile discovery;
2. one short, hardened, read-only SQLite snapshot, followed only on eligible outcomes by SQLite Online Backup into private memory, then defer;
3. UAM-owned source and source-generation continuity with a native `visits.id` cursor;
4. raw-URL handling entirely inside the fixed short-lived Task Host;
5. strict HTTP(S) DNS-host processing, exact/suffix application matching, deterministic ambiguity, and endpoint minimization;
6. whole-page validation and a later G5 atomic transaction containing minimized effects, deterministic no-event effects, progress witnesses, and checkpoint movement.

**INFERENCE.** These conclusions protect different stages of one invariant chain. G2 limits where and how source bytes are read; G3 establishes what source lineage and progress mean; G4 ensures forbidden source values are gone before IPC; G5 will make the resulting page durable without cursor-ahead failure. The designs agree on the trust boundary and fail-closed direction. They require correction where topic-local identifiers or versions were allowed to leak across those stages.

## 1.2 Consolidated corrections that are mandatory before implementation-shaped integration

The review makes five load-bearing corrections:

1. **Separate three lineages.** Browser-source continuity, collector/runtime compatibility, and privacy interpretation are different concepts. A browser database generation MUST NOT change merely because .NET, SQLite, Edge, the adapter, policy, normalizer, matcher snapshot, output fields, or time precision changed.
2. **Use one native source-record identity.** Within a source generation, the natural record identity is `(realm, installation, source_id, source_generation_id, native_visit_id)`. It MUST NOT contain an extractor or transform version. A UUIDv7 `event_id` is minted and durably reused at the first atomic commit; it is not derived from a URL.
3. **Make progress page-owned.** Individual G4 events/dispositions do not carry authoritative row cursors. One page envelope owns the snapshot high-water and proposed page advance. Any uncertain row, policy transition, source movement, cleanup failure, or page validation failure invalidates the whole page and leaves the checkpoint unchanged.
4. **Narrow the first URL implementation profile.** ASCII DNS hosts are the first production-capable candidate. Unicode IDN input remains disabled until an exact implementation—not merely `System.Uri` or `IdnMapping` documentation—passes the desired UTS #46/Unicode/runtime conformance and all-sink evidence. Public-suffix processing is not required for exact/suffix matching and remains absent until a human-approved registrable-domain output or specific deny predicate requires it.
5. **Keep exact counts and limits provisional.** The security properties are mandatory; values such as overlap count, page size, milliseconds, backup pages per step, memory caps, trial counts, one-million fuzz cases, latency ratios, and support windows remain **ESTIMATE**, **CLI EXPERIMENT**, or **HUMAN DECISION** inputs.

## 1.3 What this verdict authorizes now

**GO**, subject to the predecessor gates, for:

- pure source, generation, checkpoint, page, URL, matcher, policy-disposition, and transaction models;
- strict closed schemas and fictional golden/invalid vectors;
- deterministic synthetic Edge roots/profiles, handcrafted SQLite databases, and localhost visit generators;
- a fixed ASCII-host URL profile, exact/suffix matcher, privacy-transform reference evaluator, and exact canary corpus;
- a narrow native SQLite API admission spike and loaded-binary inventory;
- disconnected Windows lab preparation containing placeholders only;
- after the exact G1 hostile evidence passes, live access only to approved disposable synthetic Edge profiles in a named lab environment;
- G5 failpoint scaffolding against synthetic page envelopes after the unified page contract is frozen.

## 1.4 What this verdict does not authorize

**STOP** before:

- any live-source attempt while G1 is absent, failed, stale, or does not cover the exact environment;
- any real user profile, real browsing activity, production-derived URL, internal hostname, production catalogue value, or organization-shaped activity;
- raw URL, Unicode source host, path, query, fragment, title, profile path, file identity, or a reversible derivative crossing Task Host output;
- production outbox integration before both G2/G3 and G4 pass for the exact build/environment/fixture capability;
- automatic reinterpretation or replay of committed native records after policy, matcher, normalizer, field, or time changes;
- disk-backed raw scratch, VSS, browser extension, DevTools/CDP collection, raw live-file copy, arbitrary custom paths, process/role/person matching, or session-origin attribution from a shared browser database;
- pilot, production signing/enablement, or production deployment.

## 1.5 Batch gate conditions

| Gate | Classification | Required evidence | Exact stop condition |
|---|---|---|---|
| B02-PRE-G1 | **CLI EXPERIMENT** | accepted G1 gate bound to the exact source tree, installer, Windows image, process/token/IPC profile, cleanup receipt, and owner set | missing/stale G1 evidence; cross-session acceptance; raw-profile access by Coordinator; prohibited privilege; uncontrolled Task Host capability; residue |
| B02-G2 | **CLI EXPERIMENT** | direct-read, backup, cancellation, zero-write, browser-impact and cleanup campaigns on each claimed Edge/OS/native capability | any successful or unexplained UAM source mutation; incomplete backup accepted; browser corruption/crash attributable to UAM; raw escape; unbounded impact; non-success advance |
| B02-G3 | **CLI EXPERIMENT** | bounded discovery, same-SID multi-session, source/generation replacement, native-ID cursor, retry, deletion-gap and conflict model evidence | one controlled recall miss/extra; source/profile/session/realm mix; path/name/SID identity; timestamp cursor; observable discontinuity accepted into old lineage; duplicate final effect |
| B02-G4 | **CLI EXPERIMENT** | golden-before-code, parser/host/IP/matcher/policy/schema/realm tests, canary self-test, full Windows all-sink containment, rollout and incident recovery | one forbidden value/derivative outside approved source fixture; one guessed ambiguity; one cross-realm result; one tenant broadening; one mandatory scanner miss; one unclassified semantic difference |
| B02-PAGE | **CLI EXPERIMENT** | one unified page envelope, fixed interpretation per page, page-level validation, negative contract corpus, exact no-event mapping | row-level cursor authority; mixed interpretation; locator/raw identity in page; partial page acceptance; uncertain row mapped to progress |
| B02-G5-HANDOFF | **CLI EXPERIMENT** | failpoints before/after effect, no-event, witness, checkpoint, commit and ACK writes | cursor ahead; missing effect; double effect; changed natural identity; ACK before commit; failed page changing durable progress |
| B02-OWNERS | **HUMAN DECISION** | accountable functions assigned for collector, native storage, Windows security, data correctness, privacy, registry, release, operations/support, incident and dependency management | any blocking role remains `UNASSIGNED` |
| B02-ADRS | **HUMAN DECISION** | architecture forum accepts or explicitly rejects the ADR actions in section 9 | silent divergence, unresolved blocker contradiction, or accepted topic ADR left inconsistent with this review |

## 1.6 Residual risk

**FACT.** Edge history is an internal browser SQLite database, not a promised telemetry API. SQLite and Windows documentation establish primitives, not the fitness of their composition under Edge, EDR, controlled-folder access, RDS/VDI, profile virtualization, storage filters, or enterprise policy. Chromium source is upstream implementation evidence, not a Microsoft Edge support contract.

**UNKNOWN.** Material residual risks include:

- a browser update can change schema, locking, query plans, profile discovery, or synchronization behavior;
- a same-user process can race profile paths or source replacement; file IDs can eventually be reused;
- a shared profile cannot reveal which simultaneous session caused a visit;
- history deleted before observation and synchronized/deleted races are inherently unobservable;
- an exact source row can change outside the retained native-ID overlap;
- the Task Host cannot guarantee erasure of managed strings from pagefile, crash infrastructure, EDR, hypervisor snapshots, or privileged tooling;
- URL/IDNA runtimes and Unicode data can change semantics across servicing updates;
- hard-deny lists cannot prove that every syntactically public domain is non-sensitive;
- fail-closed behavior can create backlog and coverage gaps before source data is deleted;
- exact operational limits, supported estate, staffing, support cost and incident competence are unproved.

**Containment.** This verdict contains rather than eliminates those risks: synthetic-only inputs, G1-first sequencing, source write denial and tracing, one source lease, handle and generation witnesses, native-ID progress, fixed Task Host capability, raw-value elimination before IPC, strict finite matching, one interpretation per page, atomic effect/progress handoff, versioned kill switches, and stop-on-failure evidence.

---

# 2. Accepted decisions and invariants

## 2.1 Accepted predecessor invariants carried forward without change

The following are **FACT** from I03–I05 and remain non-negotiable:

| ID | Invariant |
|---|---|
| A-01 | The Coordinator is a low-privilege machine service. It does not crawl user profiles, load them, create user tokens, or read Edge source files. |
| A-02 | One ordinary-token User Host per eligible interactive session owns user-session discovery and source authorization. |
| A-03 | A short-lived restricted Task Host executes one fixed release-authorized capability. It is not a plugin, script, assembly, path, SQL, command, or arbitrary-code channel. |
| A-04 | The product privacy ceiling limits source, fields, transformations, destinations, diagnostics and capabilities; tenant policy only narrows it. |
| A-05 | Forbidden source values are removed before Task Host output, User Host/Coordinator IPC, durable endpoint state, logs, diagnostics, traces, transport or support artifacts. |
| A-06 | Endpoint durable state contains minimized typed effects and explicit source progress; a cursor never advances ahead of the durable effects or approved progress facts it represents. |
| A-07 | Endpoint SQLite uses WAL and one writer. At-least-once delivery plus stable identity and uniqueness yields one final business effect. |
| A-08 | Realm, installation, device and session authority come from authenticated context, not payload claims. |
| A-09 | The first functional slice is Edge browser history at site/domain-level minimized output using synthetic data until governance permits otherwise. |
| A-10 | UAM evidence is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| A-11 | A failed early gate stops dependent work and opens an ADR/change review. Passing proves only the named environment and claim. |
| A-12 | Legal purpose, prohibited use, fields, identity, precision, lookback, retention, access, consultation, budget, support, SLO/RPO/RTO and production approval remain human decisions. |

## 2.2 Edge root and profile discovery

- **RECOMMENDATION — ACCEPT.** Discovery runs only in the exact eligible User Host session and begins from a release-owned root-kind ID, never from a tenant or Coordinator path.
- **RECOMMENDATION — ACCEPT.** Initial root candidates are the documented local default Edge root and a mandatory `UserDataDir` policy root after exact in-session resolution and validation. A command-line-only `--user-data-dir` override is unsupported because discovering it safely would require process-command-line inspection or broad crawling. Microsoft documents that a mandatory `UserDataDir` overrides the command-line flag; without the policy, a user can override the default [W02].
- **RECOMMENDATION — ACCEPT.** Network/UNC roots are unsupported initially. Microsoft states that network paths for Edge data policies are unsupported and can lead to hangs, crashes or profile corruption [W03]. Redirected, virtualized, FSLogix, Citrix, RDS and similar roots remain a named support-matrix decision and experiment.
- **RECOMMENDATION — ACCEPT.** The User Host reads only the exact `Local State` file as an untrusted bounded hint and enumerates bounded direct child directories. It never recursively scans the user home. Absence or corruption of `Local State` permits only the bounded fallback, not a crawl.
- **RECOMMENDATION — ACCEPT.** Directory/profile labels, display names, Edge accounts, SIDs, path strings and `Local State` metadata do not identify a source. Profile candidates require stable open-handle identity, exact expected `History` location, no terminal reparse point, local supported storage and a supported source capability.
- **RECOMMENDATION — ACCEPT.** `${session_name}` and `${client_name}` can intentionally produce distinct managed roots; Microsoft documents those variables for simultaneous remote sessions [W03]. Equal physical profile identity across sessions maps to one source and one lease; distinct physical roots map to distinct sources.

## 2.3 Source, generation and version lineage

**RECOMMENDATION — ACCEPT THE FOLLOWING SEPARATION.** The endpoint model has five distinct identifiers:

| Identifier | Meaning | Changes when | Must not contain or imply |
|---|---|---|---|
| `source_id` | one Edge profile-directory lineage in a realm/installation | profile directory is recreated/replaced or continuity is disproved | label, SID, path, account, application, runtime or policy semantics |
| `source_generation_id` | one coherent `History` database native-ID lineage within that source | database identity changes, native high-water regresses/conflicts, moved/replacement is detected, or continuity cannot be proved | .NET/SQLite/Edge build, adapter, normalizer, policy, matcher or output version |
| `source_schema_capability_id` | normalized required source shape/behavior supported by one adapter family | required tables/columns/rowid/autoincrement/query behavior changes | source identity or durable event identity |
| `collector_runtime_profile_id` | exact UAM build, OS image class, native SQLite source ID/compile options, managed wrapper and measured capability | any executable/runtime/native/environment input changes | browser data lineage or business semantics |
| `interpretation_id` | exact ceiling/policy, matcher snapshot, URL profile, optional PSL, transform, output schema, site mode and time precision used for a page | any processing or privacy semantic changes | source generation, native identity or automatic historical replay authority |

This separation is mandatory. It prevents an application upgrade from creating false source generations and prevents a policy or normalizer change from changing the natural identity of already committed browser records.

## 2.4 Safe SQLite acquisition

- **RECOMMENDATION — ACCEPT.** The acquisition sequence is: short direct read-only attempt; Online Backup to private memory only after an explicitly eligible live-lock/snapshot outcome; otherwise defer. This carries the accepted predecessor decision.
- **RECOMMENDATION — ACCEPT.** Never stop Edge, open source read/write, copy the live main/WAL/SHM triplet, use VSS, use `immutable=1` on a live source, use `nolock=1`, or create source-directory scratch. SQLite warns that `immutable` suppresses change/locking checks and is unsafe if the file changes; `nolock` can corrupt concurrent access [W09].
- **RECOMMENDATION — ACCEPT.** Direct reads use an exact admitted native SQLite binary, read-only URI/open flags, required effective `db_config` controls, fixed parameterized statements, statement-readonly verification, bounded limits, cancellation and source-handle continuity checks. The literal option set is a versioned implementation profile and CLI gate, not timeless architecture.
- **RECOMMENDATION — ACCEPT.** `SQLITE_DBCONFIG_NO_CKPT_ON_CLOSE`, or an exact equivalent proven for the selected build, is load-bearing because SQLite can checkpoint and remove WAL/SHM as the last connection closes [W05]. OS write denial and filesystem tracing remain mandatory even when SQLite reports read-only.
- **RECOMMENDATION — ACCEPT.** Online Backup is accepted only after `sqlite3_backup_step()` returns `SQLITE_DONE` and `sqlite3_backup_finish()` returns `SQLITE_OK`. `finish()==SQLITE_OK` alone does not prove completion, and an in-memory destination can return `SQLITE_READONLY` if its page size differs from the source [W06]. Destination page-size handling is therefore part of the capability test.
- **RECOMMENDATION — ACCEPT.** Busy/locked retries, step size, restart allowance, elapsed time, memory and cancellation are bounded by a permit and measured. Corruption, wrong identity, unsupported schema, policy failure and cross-profile suspicion are not made acceptable by backup.
- **RECOMMENDATION — ACCEPT.** Memory-only backup is the default. Disk scratch remains absent/compiled off. A future disk implementation requires a separate ADR, human privacy/security/records decision, encryption/key design, backup/indexing treatment, crash cleanup, residue evidence and a measured need.

## 2.5 Cursor and native record identity

- **RECOMMENDATION — ACCEPT.** Within one source generation, Chromium's local `visits.id` is the progress order. Current Chromium source defines it as an autoincrement integer primary key and warns that a higher local visit ID need not have a newer visit time because synchronized older visits can arrive later [W13–W14].
- **RECOMMENDATION — ACCEPT.** Source time is fallible data, not ordering, dedupe, authorization or continuity evidence. DST, sleep, clock correction and sync cannot move the cursor.
- **RECOMMENDATION — ACCEPT.** The native natural key is:

```text
(realm_id, installation_id, source_id, source_generation_id, native_visit_id)
```

It is independent of collector, adapter, normalizer, policy, matcher, output schema and transform versions.

- **RECOMMENDATION — ACCEPT.** A bounded native-ID overlap detects recent conflicts only while the same `interpretation_id` remains active. Routine collection after an interpretation change starts at `committed_high_visit_id + 1`, resets interpretation-specific overlap witnesses, and does not replay or reinterpret committed IDs. A historical correction/reprocessing operation requires a separate governed contract and ADR.
- **RECOMMENDATION — ACCEPT.** Same natural key plus same persisted outcome digest is a retry. Same natural key plus a different outcome is an `identity_conflict`/safety condition unless an explicit correction contract authorizes a superseding effect. No first-run or upgrade silently overwrites the original effect.
- **RECOMMENDATION — ACCEPT.** A source generation changes on observable source discontinuity, not on processing upgrades. Changed database identity, moved file, high-water/sequence regression, duplicate native ID with incompatible source shape, or continuity failure closes or suspects the old generation. Changed Edge patch alone does not.

## 2.6 URL privacy transformation and application matching

- **RECOMMENDATION — ACCEPT.** Raw URL is a short-lived secret owned by the fixed Task Host. It never enters a general DTO, exception payload, logger, activity tag, cache key, dictionary key, metric, IPC schema, SQLite row, crash/support artifact or transport. Raw and canonical scratch types are inaccessible to User Host, Coordinator, storage and transport assemblies.
- **RECOMMENDATION — ACCEPT.** The first production-capable candidate is `URL_HOST_ASCII_V1`: absolute `http`/`https`, strict authority, no userinfo, DNS host in lower-case ASCII, no IP literal or browser legacy numeric form, explicit trailing-dot and port semantics, exact/suffix label-boundary rules, no DNS lookup, and no path/query/fragment/title matching or output.
- **RECOMMENDATION — ACCEPT WITH DEFERRAL.** Unicode IDN support is a separate disabled candidate. UTS #46 Revision 35/Unicode 17 defines non-transitional processing and independent validation flags [W17]. The reviewed .NET runtime uses ICU by default on supported Windows but may fall back to NLS, and its behavior differs [W15]. Its exact source exposes only public `AllowUnassigned`/STD3 controls, uses ContextJ/non-transitional options, does not set the ICU Bidi option in the reviewed native path, and masks one hyphen error for Windows compatibility [W16]. Therefore documentation alone does not establish the requested G4 profile.
- **RECOMMENDATION — ACCEPT WITH DEFERRAL.** Public-suffix processing is not part of exact/suffix matching. The initial matcher operates without PSL. A pinned local PSL may be introduced only after a human-approved registrable-domain output or specific release-owned deny predicate needs it; it must have an exact commit/digest, explicit ICANN/PRIVATE mode, license approval, no runtime network/update and independent parser/lint evidence.
- **RECOMMENDATION — ACCEPT.** Hard structural suppression and approved hard-deny policy execute before application assignment. Tenant policy may add/narrow denies; it cannot remove product denies or introduce expressions, URLs, regexes, scripts or destinations.
- **RECOMMENDATION — ACCEPT.** Matching evaluates all active same-realm exact/suffix rules, then explicit priority, fixed family authority and provable specificity. Equally maximal rules for different applications yield `AMBIGUOUS`, no application and no activity event. Rule order, name, external ID, creation time and lexicographic UUID never decide.
- **RECOMMENDATION — ACCEPT WITH HUMAN BLOCK.** The accepted baseline remains a site/domain-level first slice. `APPLICATION_ID_ONLY` is permitted as a T1 synthetic test profile and privacy negative control, but it does not silently replace the baseline. Live output requires a human-approved site/domain representation, exact fields and time precision, or an explicit baseline change proposal.

## 2.7 Page and atomic progress boundary

- **RECOMMENDATION — ACCEPT.** A Task Host returns one page under one source generation, source schema capability and `interpretation_id`. It contains only minimized event candidates or deterministic value-free `CONSUMED_NO_EVENT` effects for returned native rows.
- **RECOMMENDATION — ACCEPT.** The page—not each row—owns `snapshot_native_high_water`, `page_advance_to` and `page_complete_through_high_water`. Row results contain no authoritative cursor or locator digest.
- **RECOMMENDATION — ACCEPT.** `DEFER_CONFIGURATION`, `RETRY_TRANSIENT`, `SAFETY_HOLD`, source movement, cancellation, cleanup failure, mixed interpretation, invalid row or page bound violation invalidates the whole page. No partial page commits.
- **RECOMMENDATION — ACCEPT.** The Coordinator one-writer transaction stores each native record's one durable effect, minimized event/outbox row where applicable, deterministic no-event fact where applicable, bounded witnesses, page/run outcome and checkpoint movement atomically. It ACKs only after commit. G5 still must prove this with failpoints.

---

# 3. Rejected or deferred recommendations

## 3.1 Rejected now

| Recommendation | Decision | Reason |
|---|---|---|
| Coordinator, service or machine-wide process scans user profiles | **REJECTED** | violates accepted session authority and expands privacy/privilege surface |
| Recursive user-home/profile crawl | **REJECTED** | unbounded and unnecessary; bounded release-owned roots/direct children are sufficient |
| Tenant-supplied path, SQL, regex, script, plugin, assembly or command | **REJECTED** | creates executable collection authority outside the product ceiling |
| Discover command-line `--user-data-dir` by inspecting arbitrary process command lines | **REJECTED FOR FIRST SLICE** | adds broad process inspection and sensitive command-line collection; mandatory-policy/default roots are narrower |
| Network/UNC root support by default | **REJECTED** | Edge and SQLite document network-path/WAL limitations; no UAM support evidence exists |
| Profile name, folder name, SID, Edge account, raw path or ordinary path hash as source identity | **REJECTED** | mutable, privacy-sensitive, non-unique and unable to distinguish recreation |
| Windows file ID as eternal sole identity | **REJECTED** | useful open-handle witness, but reuse and replacement ambiguity remain |
| Raw file identity in logs, durable store, support bundle or upload | **REJECTED** | local acquisition control metadata only; immediately keyed and zeroized |
| Source generation includes Edge/.NET/SQLite/adapter/normalizer/policy versions | **REJECTED** | confuses source continuity with implementation and privacy semantics; causes false resets/duplicates |
| Dedupe key includes extractor/transform contract major | **REJECTED** | changes natural identity on upgrade and permits duplicate business effects |
| Event ID is a URL hash/HMAC or regenerated random UUID on retry | **REJECTED** | URL derivative violates minimization; random retry breaks one-effect semantics |
| Timestamp, `(timestamp, URL)`, acquisition time or time lookback as cursor | **REJECTED** | late sync/equal time/clock changes make it incorrect; raw URL is forbidden |
| Raw copy of live `History`, `-wal`, `-shm` | **REJECTED — baseline conflict** | not an atomic live snapshot and can omit/mix committed WAL state |
| `immutable=1` or `nolock=1` on live source | **REJECTED** | suppresses safety checks and can return wrong results or corrupt concurrent access [W09] |
| Read/write fallback or source-directory temp file | **REJECTED** | violates zero-source-write invariant |
| Stop/restart Edge, force locks or checkpoints | **REJECTED** | user impact and mutation authority are unacceptable for telemetry |
| Always use Online Backup | **REJECTED AS DEFAULT** | copies more, can restart repeatedly and increases memory/impact; direct bounded read is cheaper when safe |
| Accept backup because `backup_finish()==SQLITE_OK` without observing `SQLITE_DONE` | **REJECTED** | SQLite explicitly says finish can return OK without completion [W06] |
| Disk raw scratch by default | **REJECTED** | creates pre-minimization durable data, keys, cleanup, backup/indexing and incident obligations |
| Send raw URL to User Host/Coordinator or minimize centrally | **REJECTED — baseline conflict** | raw boundary is the fixed Task Host; later minimization is too late |
| Store/transmit SHA-256 or HMAC of raw URL/host/path for telemetry/dedupe | **REJECTED FOR FIRST SLICE** | enumerable/linkable derivative and unnecessary for source identity or matching |
| First-match rule ordering, fuzzy names, catalogue labels, roles or person inference | **REJECTED** | hidden authority and false attribution; no supplied evidence authorizes it |
| URL path/query/fragment/title matching or output | **REJECTED FOR FIRST SLICE** | much higher sensitivity and unresolved semantics/purpose |
| Runtime DNS, reputation, online PSL update or network lookup | **REJECTED** | new privacy, availability, TOCTOU and authority paths |
| Treat PSL membership as ownership, application identity, sensitivity or collection authority | **REJECTED** | PSL is community suffix-boundary data, not business truth |
| Automatically reinterpret/replay historical rows after semantic upgrades | **REJECTED** | changes committed effects and can duplicate collection; requires explicit correction/replay governance |
| Silently skip invalid/ambiguous/uncertain rows and advance | **REJECTED** | uncertainty cannot become progress; only explicit deterministic no-event effects may advance atomically |
| Treat a passing scanner, fixture, upstream source or current/previous version smoke test as production proof | **REJECTED** | each has blind spots and does not prove estate, operations or governance fitness |

## 3.2 Deferred or provisional technologies and values

| Area | Provisional item | Resolution path |
|---|---|---|
| Supported estate | Windows editions/builds, Edge channels/builds, RDS/VDI/FSLogix/Citrix, ReFS, storage filters, EDR/CFA, roaming/redirected roots | human support matrix plus exact G1/G2/G3/G4 campaigns per claimed capability |
| SQLite stack | managed wrapper, SQLitePCLRaw/direct P/Invoke, native binary, compile options, support arrangement | exact package/source/binary mapping, API coverage, license/security review and loaded-module evidence |
| Direct-read profile | precise open flags, `db_config` set, limits, authorizer opcodes, time/row/byte budgets, query-plan class | exact native-version adapter and CLI evidence; mandatory outcomes remain fixed |
| Backup | pages per step, retry/yield, restart inference, elapsed time, page/memory cap, cancellation cadence | G2 lock/churn/impact measurement; destination page-size test |
| Cursor | overlap count, witness retention, absence grace, checkpoint/page size | synthetic model plus measured source distributions and records decision |
| First run | zero lookback, bounded time, time+count cap | Product/Data/Privacy/Legal human decision; technical default is disabled, fallback zero lookback |
| URL parser | exact `System.Uri`/custom lexical wrapper behavior in discarded components | golden/differential/fuzz evidence; authority/host strictness is fixed |
| IDNA | Unicode enablement, exact UTS #46 implementation, ICU/NLS handling, Bidi/hyphen behavior and data version | disabled until conformance/admission; ASCII profile first |
| PSL | whether to ship, ICANN/PRIVATE mode, exact parser/data update cadence | human site-semantics decision, license approval and no-network pinning evidence |
| Output | canonical host vs registrable domain, application ID presence, time precision, identity projection | human field/purpose decisions and G4 contract revision |
| Numeric test volume | 1,000,000 fuzz cases; 10,000 hostile attempts; 100/50 repetitions; 30 paired trials | evidence-budget hypothesis; properties and zero-tolerance invariants fixed, exact counts measured/reviewed |
| Impact | p95/p99 ratios, CPU/memory/handle limits, lock durations | SRE/Product/Endpoint support decision from G2 A/B distributions |
| Observability | metric-series budget, alert thresholds, health retention | SRE/Privacy/Data Governance human decision and cardinality measurement |
| Compatibility | current/previous Edge, normalizer/PSL windows, offline grace | per-family measured fleet evidence and owner commitment; no global promise |
| Disk scratch | encryption, key wrapping, remanence, backup/indexing, scavenger | separate ADR only after measured memory-only failure and human approval |

---

# 4. Contradiction register with evidence-quality resolution

## 4.1 Resolution method

Conflicts were resolved in this order:

1. preserve I03–I05 accepted invariants and gate order;
2. prefer the narrower authority and smaller privacy/security surface;
3. distinguish source truth from collector implementation and interpretation semantics;
4. distinguish documented capability from UAM runtime fitness;
5. prefer one explicit page/transaction authority over overlapping row-level progress concepts;
6. retain uncertainty as an ADR/CLI/human gate rather than selecting the most confident wording.

## 4.2 Register

| ID | Overlap or contradiction | Evidence-quality assessment | Consolidated resolution | ADR/action |
|---|---|---|---|---|
| C-01 | G2/G3 `capability_fingerprint` combines source schema, query plan, native SQLite source ID, adapter major and Edge version, then influences generation | Source schema can show continuity; runtime and browser/adapter versions are execution evidence, not source identity | split into `source_schema_capability_id`, `collector_runtime_profile_id`, and `source_generation_id`; only observable source discontinuity changes generation | ADR-B02-002/006 |
| C-02 | G2/G3 source-generation rules include incompatible capability changes | A source can become unsupported without becoming a new database lineage | incompatible shape blocks the adapter; create a new generation only when continuity cannot be proved or native lineage actually changed | ADR-B02-006 |
| C-03 | G2/G3 dedupe includes `extractor_contract_major` | Conflicts with stable identity/one-effect invariant; upgrade would create a second natural key | natural key excludes interpretation/collector versions; persist interpretation separately | ADR-B02-013 |
| C-04 | G4 introduces a UUIDv7 `SourceOccurrenceId` before durable commit | G3 already has a stable native key; a pre-minted UUID may be lost/regenerated | Task Host uses typed local native record reference; Coordinator mints/persists UUIDv7 `event_id` at first atomic effect commit and reuses it | ADR-B02-013 |
| C-05 | G2/G3 overlap witness is a minimized-record digest; G4 semantics may change it after normalizer/policy upgrade | A changed interpretation is not proof that the browser row changed | compare minimized outcome only under the same `interpretation_id`; reset interpretation-specific overlap on semantic transition; no routine replay | ADR-B02-007/018 |
| C-06 | G4 rows carry `progressAfter`; G2/G3 page contract carries page high-water/advance | Two progress authorities create partial-commit and disagreement risk | remove authoritative row progress; page envelope alone proposes advancement; G5 commits whole page or none | ADR-B02-008 |
| C-07 | G2/G3 page example includes `historyLocatorDigest` in Task Host result | Locator is Coordinator-local acquisition metadata, not privacy-transform output | bind source through permit/page context; omit locator digest from Task Host page and upload contracts | ADR-B02-006/009 |
| C-08 | G2/G3 profile locator includes a `profileCreationTimeClass` | Creation time may be mutable/coarse and is not a documented durable identity | use open-handle volume/file identity as primary keyed locator; creation time may be a secondary local witness only | ADR-B02-006 |
| C-09 | Minimization before IPC appears to forbid raw file IDs User Host→Coordinator for source binding | Accepted privacy invariant targets source activity values; file identity is still sensitive local control metadata | allow one dedicated authenticated, one-use source-binding message; never log/durable/upload; Coordinator HMACs immediately and zeroizes. No raw URL/path accompanies it | ADR-B02-006/009 |
| C-10 | G4 permits `APPLICATION_ID_ONLY`; baseline says site/domain-level first slice | App-only is narrower but silently changes accepted functional slice | retain app-only as T1 test/negative profile only; live baseline requires approved site/domain or explicit change proposal | ADR-B02-011/015 |
| C-11 | G4 accepts a full UTS #46 profile using .NET primitives | UTS #46 exposes independent flags; reviewed .NET implementation does not demonstrate the exact requested Bidi/hyphen profile and can use ICU or NLS | ASCII DNS hosts first; Unicode IDN compiled/flagged off until an exact implementation passes conformance and estate evidence | ADR-B02-010 |
| C-12 | G4 mandates malformed-percent rejection anywhere, including discarded path/query/fragment | Authority-percent rejection is load-bearing; global discarded-component behavior is not proved necessary and may reduce source compatibility | authority/host remains strict; discarded-component handling is versioned and corpus-tested, cannot affect match/output, and cannot leak | ADR-B02-010 |
| C-13 | G4 binds PSL digest/mode to every result | Exact/suffix host matching does not need PSL; shipping data adds license/update semantics | initial profile omits PSL; add only for approved registrable-domain output or a named deny predicate | ADR-B02-012 |
| C-14 | G4 treats 1,000,000 cases as an exact architecture gate | Large deterministic corpora are useful, but exact count is a test-budget hypothesis, not proof | require coverage partitions, mandatory properties, mutation detection and zero escapes; exact case count is measured/recorded and may be revised by ADR | ADR-B02-019 |
| C-15 | G2/G3 Online Backup acceptance emphasizes successful `finish` | SQLite states `finish` may return OK even if step never completed | require observed `SQLITE_DONE` plus successful finish; incomplete destination is never queried | ADR-B02-004 |
| C-16 | G2/G3 uses in-memory backup without a normative page-size condition | SQLite documents `SQLITE_READONLY` for in-memory destination/source page-size mismatch | set/verify compatible destination page size or fail the capability; add fixture for every admitted source page size | ADR-B02-004/005 |
| C-17 | Online Backup is described as fallback for some read-only prerequisites | Backup still needs a safely opened source connection and cannot repair every missing WAL/SHM/write-permission condition | fallback only for enumerated eligible outcomes proven in the exact lab; otherwise defer/unsupported | ADR-B02-004 |
| C-18 | Literal SQLite `db_config`/file-control profile is stated normatively | APIs/options evolve and wrapper/native builds may omit controls | accept required security outcomes; exact opcodes/options are versioned adapter evidence and effective-value gates | ADR-B02-005 |
| C-19 | G2/G3 same-SID sessions may share one profile; G4 has session-bound permits | Permit proves acquisition session, not visit-origin session | one source/lease; record acquisition session only as local operational provenance; never claim business event session origin | ADR-B02-017 |
| C-20 | G2/G3 supports multiple first-run modes; baseline names a first slice but leaves lookback provisional | Purpose/privacy authority is absent | live collection disabled; implementation supports explicit atomic zero-lookback baseline and approved bounded alternatives; no silent history collection | ADR-B02-015 |
| C-21 | G2/G3 suggests invalid time can fail whole page or be zero-effect; G4 gives permanent/transient dispositions | Exact policy is unresolved and affects progress | define a finite mapping by `interpretation_id`; deterministic validated invalid-time rule may be no-event, uncertainty is page failure; human precision/range remains blocked | ADR-B02-008/015 |
| C-22 | G2/G3 examples may expose native IDs or locator digests in later events | Native cursor is useful locally but unnecessary centrally and can reveal sequence | native IDs, locator digests and overlap witnesses stay endpoint-local unless a later approved contract proves necessity | ADR-B02-013/014 |
| C-23 | G2/G3 cites Chromium tag `150.0.7871.187` while current Edge Stable is `150.0.4078.105` | Same major does not prove exact Edge source mapping; Microsoft release notes are point-in-time product evidence | treat Chromium as upstream reference only; exact signed Edge fixture and observed schema/behavior are UAM compatibility evidence | source correction S-03 |
| C-24 | Current/previous Edge support is repeatedly suggested | Planning target from predecessor; no estate/offline/support commitment | human-approved named build matrix; every claimed build passes the same gates; no timeless current/previous promise | ADR-B02-018 |
| C-25 | `Local State` and direct-child enumeration each appear sufficient in places | Neither alone proves complete supported discovery | use `Local State` only as bounded hint plus direct-child candidate inspection; exact supported fixture recall is the gate | ADR-B02-003 |
| C-26 | Beta/Dev/Canary/channel roots are discussed as available capabilities | Microsoft release/support posture and operational drift differ; no business choice exists | Stable default/managed local roots are first candidates; every other channel remains disabled pending human support decision and evidence | ADR-B02-003/018 |
| C-27 | Permanent invalid/unmatched/ambiguous rows may advance, but future interpretation could differ | Advancing is safe only under the exact active semantics; upgrade replay could change outcomes | persist one effect with its `interpretation_id`; routine semantic upgrades do not replay committed rows; governed reprocessing is separate | ADR-B02-008/018 |
| C-28 | G4 parser disagreement can map to per-row SafetyHold while G2 page may contain other valid rows | Partial acceptance would move past uncertainty | any safety/defer/retry outcome invalidates the page; no valid siblings commit from that page | ADR-B02-008 |
| C-29 | Source time and URL output together may be used in event identity examples | Both are privacy/business fields and can change under precision/site decisions | event identity derives from native source key, never payload; payload/time/site changes produce conflict or governed correction, not a new natural key | ADR-B02-013/015 |
| C-30 | Topic results include many exact numeric thresholds and trial counts as normative-looking text | No representative distributions, resource budgets or SLOs exist | preserve zero-tolerance invariants; label every numeric value as estimate/experiment/human budget and record replacement inputs | ADR-B02-019 |

---
# 5. Normative component, interface, schema and state-machine baseline

## 5.1 Components and trust boundaries

| Component | Normative responsibility | Forbidden responsibility |
|---|---|---|
| Product privacy ceiling | enumerate release-owned Edge root/channel/capability IDs, source fields needed inside Task Host, transforms, output profiles, deny predicates, diagnostics, hard limits and kill switches | arbitrary path, SQL, script, plugin, regex, online lookup, tenant-defined destination or unreviewed field |
| Tenant policy | disable or narrow release-owned IDs, frequency, lookback, fields, precision, site mode and rules; add deny | broaden product ceiling; supply executable logic, source address/path, URL, algorithm, destination or parser data |
| Coordinator | derive realm/installation; issue bounded `RunIntent`; validate authenticated User Host/permit/page; immediately key transient file identities; own source lease; validate whole minimized page; perform one-writer atomic persistence | enumerate/open Edge roots; receive raw URL/path/profile name; trust payload realm/SID/session; execute collector SQL; reinterpret source row |
| User Host | resolve release-owned roots in exact session; bounded profile discovery; open/validate handles; issue one-use permit; launch fixed Task Host; validate minimized page | scan user home; send raw paths/Local State/profile/account data to Coordinator; receive raw URL from Task Host; infer visit-origin session |
| Edge Task Host | one fixed capability; source open/read/backup; schema capability check; raw URL parse/deny/match/minimize; return bounded page; close/zero/drop references; exit | network; source write; child process; arbitrary path/SQL; stop Edge; plugin; raw output; durable raw scratch |
| Source registry/store | persist source/generation IDs, keyed locator digests, capability IDs, leases, checkpoint, effects, page/run facts and bounded witnesses | raw path, raw file ID, profile name, Edge account, raw URL/hash/HMAC, SID as source identity |
| URL profile | strict authority/host semantics, finite stable reason codes, ASCII canonical host and optional disabled IDNA adapter | browser recovery as authority; logging input; DNS; PSL online update; application inference |
| Matcher/analyzer | same-realm exact/suffix rules, all-rule evaluation, priority/specificity, ambiguity, static overlap/shadow witnesses | first-match, row order, regex/glob/fuzzy/role/person matching, observed-activity rule generation |
| Privacy transformer | construct new closed minimized result from approved primitives; floor time; produce finite no-event outcome | clone/redact source DTO; hash forbidden value; add hidden field/extension bag or exception detail |
| G0 fixture/oracle/canary | deterministic T1 roots, browser visits, adversarial DBs, URL/rule corpus, independent expected ledgers and all-sink markers | production decision-code dependency, real activity, raw organization values, scanner as sole oracle |
| Windows lab harness | exact synthetic install/browser/native inventory, locks/races/sessions/traces/impact, evidence normalization and cleanup | share connection details, credentials, real identities, raw production activity or unredacted source traces |

### 5.1.1 Trust-boundary sequence

```text
release-owned ceiling + narrower tenant policy + active snapshot
                         |
                         v
Coordinator, session 0
  - authenticated realm/installation
  - RunIntent and prospective source lease
                         |
                accepted G1 IPC
                         v
User Host, exact eligible interactive session
  - resolve only release-owned root kind
  - bounded Local State hint/direct children
  - validate profile/History open-handle identity
  - one-use CollectionPermit
                         |
           inherited private Task Host channel
                         v
Fixed restricted Edge Task Host
  - open source read-only
  - direct short snapshot OR eligible Online Backup to memory
  - fixed query and native-ID page
  - raw URL exists only here
  - strict host profile -> structural deny -> hard deny -> matcher
  - field/time/identity minimization
  - whole minimized page or value-free page failure
                         |
       Task Host -> User Host: minimized page only
                         v
User Host independent permit/schema/bound validation
                         |
       User Host -> Coordinator: minimized page only
                         v
Coordinator one-writer transaction
  - one native record -> one durable effect
  - minimized event/outbox row or no-event fact
  - witnesses/page/run/checkpoint atomically
  - ACK only after COMMIT
```

The first privacy boundary is Task Host result serialization. Raw source values may exist inside Task Host memory only for the bounded operation. The User Host is not a raw-value processing boundary.

## 5.2 Root discovery and source binding

### 5.2.1 Root kinds

The release-owned root registry initially contains:

| Root kind | Prototype state | Production-capable state before decisions |
|---|---|---|
| `edge.stable.default.local` | implemented with T1 fixture and disposable Edge VM | disabled until supported Edge/Windows/profile matrix is approved and gates pass |
| `edge.stable.managed-user-data-dir.local` | implemented only from mandatory policy, exact supported variables and local absolute path | disabled until same decisions/gates |
| Beta default | optional fixture/candidate lane | disabled pending separate channel support decision |
| Dev/Canary | no runtime need | unsupported/disabled |
| command-line-only custom root | not implemented | unsupported |
| UNC/network/redirected/virtualized root | negative fixtures | unsupported until named capability passes separate evidence |
| WebView2 or another browser | out of scope | not representable in this batch |

### 5.2.2 Bounded discovery algorithm

The User Host MUST:

1. receive a release-owned `root_kind_id`, not a path;
2. verify source, root kind, session and current policy authority before filesystem access;
3. derive the default root from the current user's known local application-data location, or read only the exact mandatory `UserDataDir` policy value;
4. expand only the documented variables explicitly supported by the release; reject unknown or repeated variables and any result that is not absolute and local;
5. reject UNC, device namespace, volume root, alternate data stream, embedded NUL, unsupported filesystem, terminal reparse point or over-limit path;
6. open the root as a directory handle, obtain final path class, volume/file identity and reparse attributes; raw values remain local memory;
7. read only the exact bounded `Local State` file as an untrusted hint and discard profile/account/display values immediately;
8. enumerate only bounded direct child directories, never recurse;
9. accept a child only when open-handle identity remains stable, it is not a reparse point, exact `History` is a regular local file, and the fixed adapter can establish a supported source capability;
10. send one dedicated transient source-binding message containing only bounded open-handle identity fields and opaque run/root/channel IDs to the authenticated Coordinator;
11. receive an opaque `source_id`/`source_generation_id` binding and never serialize raw path, profile label or identity into another message;
12. close handles and discard raw identity/path buffers on every path.

### 5.2.3 Transient source-binding contract

The logical contract is local-only and MUST NOT be durable or logged:

```json
{
  "contract": "uam.edge.source-binding-candidate",
  "version": "1.0.0",
  "runId": "019d0000-0000-7000-8000-000000000001",
  "rootKindId": "edge.stable.default.local",
  "channelId": "edge.stable",
  "rootFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000bb"
  },
  "profileFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000cc"
  },
  "historyFileIdentity": {
    "volumeSerialHex": "00000000000000aa",
    "fileId128Hex": "000000000000000000000000000000dd"
  }
}
```

Normative rules:

- raw path, folder/profile name, account, SID, URL, title and `Local State` value are structurally absent;
- identities come from held open handles, not path parsing;
- authenticated G1 context supplies realm, installation, User Host process/logon/session and permit authority;
- Coordinator computes purpose-separated installation-keyed locator digests, compares/creates source state, clears the raw message buffer and returns opaque IDs;
- no trace, dump, metric, error object or support command may capture the raw message;
- unavailable or conflicting identity cannot create or merge a source.

### 5.2.4 Locator digests

```text
root_locator_digest = HMAC-SHA-256(
  K_install_source_locator,
  canonical(root_kind_id, root_volume_serial, root_file_id_128)
)

profile_locator_digest = HMAC-SHA-256(
  K_install_source_locator,
  canonical(root_locator_digest, profile_volume_serial, profile_file_id_128)
)

history_locator_digest = HMAC-SHA-256(
  K_install_source_locator,
  canonical(profile_locator_digest, history_volume_serial, history_file_id_128)
)
```

The key is purpose-separated and local to the installation. Locator digests are endpoint-local and never uploaded or used as event identity. Creation time, display name and path may be transient secondary diagnostics in a restricted lab but are not digest identity inputs.

## 5.3 Source and generation state

### 5.3.1 Source lifecycle

```text
UNSEEN
  -> DISCOVERED
  -> BASELINE_PENDING
      -> ACTIVE
      -> UNSUPPORTED
      -> SAFETY_HOLD

ACTIVE
  -> TEMPORARILY_ABSENT
      -> ACTIVE                       same directory lineage returns
      -> REMOVED                      only under approved absence rule
  -> SUSPECT
      -> ACTIVE                       suspicion disproved
      -> GENERATION_CLOSED
          -> BASELINE_PENDING(new generation)
      -> SAFETY_HOLD

REMOVED
  -> DISCOVERED(new source_id)        recreated/different directory lineage
```

A source ID is immutable, never reused and scoped by authenticated realm and installation. Removal does not erase event/progress/audit history.

### 5.3.2 Generation decision

A new `source_generation_id` is created when one of these is established:

1. `History` open-handle identity changes while profile lineage remains;
2. actual SQLite main-handle identity does not match the validated candidate;
3. the source moves/is replaced during the snapshot and the selected native control reports it or post-read identity differs;
4. observed maximum native ID or `sqlite_sequence` high-water regresses below the committed checkpoint;
5. the same native ID appears incompatibly within the same source schema and interpretation evidence;
6. a restored/replaced source cannot establish continuity through file identity, native high-water and retained same-interpretation witnesses;
7. a required source-schema change makes the prior native-ID lineage uninterpretable and continuity cannot otherwise be proved.

These do **not** create a generation by themselves: Edge/.NET/SQLite patch change, adapter rebuild, query-plan wording change, policy revision, rule snapshot, URL normalizer, PSL, site mode, time precision, output schema, or product release. They may block support or create new collector/interpretation evidence.

## 5.4 SQLite acquisition profile

### 5.4.1 Direct path

For each page, Task Host MUST:

1. run under the passed G1 fixed executable/token/job/handle/network profile;
2. hold validated Windows handles to the profile and `History`; reject reparse/moved/substituted targets;
3. open SQLite through a canonical absolute local URI with read-only, URI, private-cache, no-follow and extended-result behavior supported by the exact admitted build;
4. prohibit `immutable=1`, `nolock=1`, shared cache, read/write fallback and source-directory temp files;
5. verify `sqlite3_db_readonly(main)==1`;
6. establish actual SQLite main-file handle identity through the tested file-control/API or fail the capability—path-only comparison is not an accepted production fallback;
7. apply and read back the required defensive/trusted-schema/extension/attach/write/checkpoint/trigger/view/double-quoted-string/query-only/temp-memory controls supported by that adapter;
8. install a fixed authorizer/statement allowlist, no application functions/collations/virtual tables, and bounded `sqlite3_limit` values;
9. prepare only release-owned parameterized statements and require statement-readonly status;
10. begin one short read transaction, bind the source snapshot high-water, read one bounded native-ID page, recheck source movement/identity, then commit/close before IPC or Coordinator storage;
11. on any uncertainty, close and classify the outcome without progress.

The exact `db_config` numbers and limits are recorded in `collector_runtime_profile_id`; an unsupported mandatory control fails that capability rather than being ignored.

### 5.4.2 Fixed source query class

The first adapter requires only:

```sql
BEGIN DEFERRED;

SELECT COALESCE(MAX(id), 0)
FROM main.visits;

SELECT COALESCE(seq, 0)
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

Only `id`, `visit_time` and `url` are read. Titles, referrers, transitions, duration, sync-originator fields, downloads, cache, cookies and other browser artifacts are out of scope. Every returned value is type/bound checked. Raw URL is transformed before any page row exists.

The normalized query-plan gate requires an integer-primary-key range on `visits`, primary-key lookup on `urls`, no full scan of `visits`, no temporary sort, no automatic index, no trigger/view/virtual-table execution and no user function. Exact plan text is evidence, not a timeless equality contract.

### 5.4.3 Online Backup path

Online Backup is entered only after an adapter-defined eligible direct outcome. It MUST:

1. use the same source open/hardening/handle-identity profile;
2. create a process-private destination connection in memory;
3. set or verify a destination page size compatible with the source before backup;
4. initialize one backup object and call bounded page steps;
5. check permit cancellation, elapsed time, memory, remaining/page count and retry/restart budget between steps;
6. retry only `BUSY`/`LOCKED` according to bounded policy; fatal `READONLY`, `NOMEM`, `IOERR` and equivalent stop the backup;
7. accept only after a step returns `SQLITE_DONE` and `backup_finish` returns `SQLITE_OK`;
8. close the source before querying the completed private destination;
9. run the same source-schema, fixed query, row validation, privacy transformation and page rules on the destination;
10. close/destroy the destination and exit the Task Host; no dump or scratch survives.

A source that cannot be safely opened is not rescued by backup. Corrupt, wrong-identity, unsupported-schema, policy, realm or cross-profile failures are never eligible.

### 5.4.4 Zero-source-write proof

A G2 pass requires all of these controls together:

- Task Host OS token/integrity/ACL profile denies source mutation in the named environment;
- architecture tests prohibit source write APIs, writable open flags, journal/checkpoint/vacuum/attach/write statements and arbitrary process/network paths;
- source SQLite reports and effectively behaves read-only;
- checkpoint-on-close is disabled/equivalently prevented by the selected profile;
- no source-directory temp/scratch exists;
- per-process filesystem tracing records zero successful create/write/set-information/rename/delete/security operations against the root, profile, main, WAL and SHM;
- a separate fictional positive-control build deliberately attempts a write and proves both OS denial and trace-oracle detection;
- before/after source metadata and Edge reopen/history-health checks pass.

A denied write attempt by the production candidate is not a clean pass; it is an implementation defect requiring review. The target is zero unexpected write intent and zero successful source writes.

## 5.5 URL host profile and privacy transform

### 5.5.1 Initial profile: `uam-url-host-ascii-v1`

The accepted first implementation profile performs, in order:

1. validate active permit, realm/session binding, source/generation, ceiling/policy/snapshot/output IDs, expiry, kill switches and page budget;
2. reject null/empty/over-limit input before expensive processing;
3. reject invalid UTF-16, BOM and configured control/line-separator characters;
4. reject leading/trailing whitespace and raw backslash;
5. require exact absolute `http://` or `https://` form, case-insensitive scheme and no base resolution;
6. isolate raw authority before `/`, `?` or `#`; reject empty authority, userinfo/`@`, percent in authority, malformed bracket/colon and control characters;
7. parse using the exact admitted candidate runtime and require parser boundaries to agree with the strict authority scanner;
8. require a DNS-name host; reject IPv4, IPv6, zone identifiers and browser legacy numeric IPv4 forms through raw and parsed checks;
9. require ASCII host input for this profile; lower-case using ordinal/ASCII rules;
10. accept/remove exactly one terminal dot; reject leading dot, multiple terminal dots and empty labels;
11. validate ASCII DNS labels and total lengths under the versioned profile;
12. canonicalize explicit default port 80/443 to absent; reject malformed ports and, by default, every non-default port unless a release-owned exact-port rule is enabled;
13. suppress single-label, localhost/local and the release-owned structural special-use set;
14. discard path/query/fragment/title references without copying, hashing, measuring exactly or allowing them to affect match/output; exact invalid-syntax handling in those discarded components is versioned by the corpus;
15. evaluate product hard deny and tenant-added narrowing;
16. evaluate all same-realm exact/suffix rules and deterministic ambiguity;
17. require an approved output field/time/identity profile;
18. construct a new closed minimized row or a finite value-free deterministic no-event row;
19. validate permit, schema, field allowlist, provenance, bounds and canary guard before serialization;
20. drop raw/canonical scratch references and exit promptly.

`System.Uri` or another parser is an implementation candidate behind this profile, not the profile specification. Browser WHATWG behavior is a differential reference, not authority.

### 5.5.2 Disabled Unicode candidate

`uam-url-host-idna-v1` MAY be developed with T1 vectors but MUST remain disabled in production-shaped code until:

- the exact implementation supports the approved UTS #46/IDNA options, not an inferred subset;
- exact runtime globalization mode and Unicode/ICU data identity are captured;
- official Unicode conformance vectors, A-label round-trip, Bidi/Joiner/hyphen, length, malformed A-label, confusable-presentation and cross-runtime tests pass;
- a servicing update semantic-diff gate exists;
- the product/security/accessibility owners approve Unicode input and admin review behavior;
- all-sink canaries prove Unicode source spelling never leaves Task Host.

If no admitted implementation can meet the profile, ASCII-only remains the supported behavior rather than weakening validation silently.

### 5.5.3 Matcher grammar

```text
URL_HOST_RULE_V1 {
  rule_id: UUIDv7
  application_id: UUIDv7
  schemes: non-empty subset {http, https}
  host_mode: EXACT | SUFFIX
  canonical_ascii_host: DNS name under exact normalizer version
  include_apex: boolean              required only for SUFFIX
  port_mode: DEFAULT_OR_OMITTED | EXACT
  exact_port: uint16                 required only for EXACT
  priority: bounded integer
  normalization_version: exact ID
}
```

Rules are immutable same-realm snapshot entries. Suffix uses DNS-label boundaries. After scheme/port filtering, maximum priority and fixed family authority, the maximal set under provable specificity determines the outcome. One application means `MATCHED`; multiple applications mean `AMBIGUOUS`; no rule means `UNMATCHED`. Unknown analysis blocks publication rather than meaning safe.

### 5.5.4 Output profiles

The product ceiling may eventually authorize one site/domain profile, subject to human decision:

| Profile | Meaning | Current state |
|---|---|---|
| `APPLICATION_ID_PLUS_CANONICAL_HOST` | opaque application UUID plus lower-case canonical ASCII host | disabled pending purpose/field/time decision and G4 evidence |
| `APPLICATION_ID_PLUS_REGISTRABLE_DOMAIN` | opaque application UUID plus pinned-PSL registrable domain | disabled; also requires PSL mode/license/data decision |
| `APPLICATION_ID_ONLY_TEST` | no site value; synthetic privacy/control testing | T1 only; not a silent replacement for accepted site/domain slice |
| no event | deterministic deny/unmatched/ambiguous/invalid or output not authorized | used according to finite disposition mapping |

Raw person/session/SID/profile identity is absent. Source time, if approved, is converted with checked UTC semantics and floored to the coarsest approved precision. It never orders the cursor or forms natural identity.

## 5.6 Unified page contract

### 5.6.1 Logical envelope

```json
{
  "contract": "uam.edge.minimized-page",
  "version": "1.0.0",
  "runId": "019d0000-0000-7000-8000-000000000101",
  "sourceId": "019d0000-0000-7000-8000-000000000102",
  "sourceGenerationId": "019d0000-0000-7000-8000-000000000103",
  "checkpointVersionObserved": 12,
  "interpretationId": "sha-256:fictional-interpretation-digest",
  "sourceSchemaCapabilityId": "sha-256:fictional-source-capability",
  "collectorRuntimeProfileId": "sha-256:fictional-runtime-profile",
  "acquisitionMethod": "DIRECT",
  "snapshotNativeHighWater": 4388,
  "pageAdvanceTo": 4388,
  "pageCompleteThroughHighWater": true,
  "rows": [
    {
      "nativeVisitId": 4201,
      "effect": {
        "kind": "MINIMIZED_EVENT_CANDIDATE",
        "applicationId": "019d0000-0000-7000-8000-000000000201",
        "siteMode": "APPLICATION_ID_PLUS_CANONICAL_HOST",
        "siteValue": "portal.fictional-example.test",
        "observedBucketStartUtc": "2026-07-31T10:00:00Z",
        "timePrecision": "HOUR",
        "payloadDigest": "sha-256:fictional-minimized-payload"
      }
    },
    {
      "nativeVisitId": 4202,
      "effect": {
        "kind": "CONSUMED_NO_EVENT",
        "reasonCode": "SCHEME_UNSUPPORTED",
        "outcomeDigest": "sha-256:fictional-no-event-outcome"
      }
    }
  ]
}
```

All values are fictional. The concrete site and time fields are not approved by this review; they illustrate the envelope.

### 5.6.2 Page invariants

The page MUST satisfy all of these:

1. one authenticated run, source, generation, checkpoint version, permit and interpretation;
2. rows strictly increasing by positive native ID with no duplicate;
3. every row lies within the requested overlap/new-ID range and at or below the bound snapshot high-water;
4. exactly one effect per returned source row: minimized candidate or deterministic `CONSUMED_NO_EVENT`;
5. no `DEFER`, `RETRY` or `SAFETY_HOLD` row in a committable page;
6. no raw URL, Unicode source spelling, userinfo, path, query, fragment, title, referrer, profile/path/file identity, locator digest, SID, session claim, SQL or exception detail;
7. one interpretation ID across every row; an authority change while processing cancels/discards the page;
8. `page_advance_to` is no lower than the prior checkpoint and no greater than snapshot high-water;
9. if row limit was reached, advance only through the last completely processed returned ID; if the bounded query proved no more rows through snapshot high-water, advancement may cover absent/deleted gaps;
10. whole-page schema, permit, source, generation, capability, size and canary validation before transaction;
11. any invalid row invalidates the page; no partial commit;
12. locator/native cursor fields are removed before any central upload event is built.

### 5.6.3 Page failure envelope

A failed page carries only finite, value-free state:

```json
{
  "contract": "uam.edge.page-failure",
  "version": "1.0.0",
  "runId": "019d0000-0000-7000-8000-000000000101",
  "sourceId": "019d0000-0000-7000-8000-000000000102",
  "sourceGenerationId": "019d0000-0000-7000-8000-000000000103",
  "checkpointVersionObserved": 12,
  "outcome": "DEFER",
  "reasonCode": "SQLITE_BUSY",
  "stage": "DIRECT_READ"
}
```

No proposed page advance appears. The Coordinator records operational health only according to approved retention/cardinality; the checkpoint and record effects remain unchanged.

## 5.7 Local logical schema

The following is normative at the logical level. Physical types, indexes and retention remain implementation/measurement decisions. All keys begin with authenticated realm and installation.

```sql
CREATE TABLE edge_source (
    realm_id                BLOB NOT NULL,
    installation_id         BLOB NOT NULL,
    source_id               BLOB NOT NULL,
    source_kind             TEXT NOT NULL CHECK (source_kind = 'EDGE_HISTORY'),
    channel_id              TEXT NOT NULL,
    root_kind_id            TEXT NOT NULL,
    root_locator_digest     BLOB NOT NULL CHECK (length(root_locator_digest) = 32),
    profile_locator_digest  BLOB NOT NULL CHECK (length(profile_locator_digest) = 32),
    status                   TEXT NOT NULL,
    source_sequence         INTEGER NOT NULL CHECK (source_sequence >= 1),
    current_generation_id   BLOB NULL,
    first_seen_utc           INTEGER NOT NULL,
    last_seen_utc            INTEGER NOT NULL,
    row_version              INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id),
    UNIQUE (realm_id, installation_id, source_kind, profile_locator_digest)
) STRICT;

CREATE TABLE edge_source_generation (
    realm_id                    BLOB NOT NULL,
    installation_id             BLOB NOT NULL,
    source_id                   BLOB NOT NULL,
    source_generation_id        BLOB NOT NULL,
    generation_sequence         INTEGER NOT NULL CHECK (generation_sequence >= 1),
    predecessor_generation_id   BLOB NULL,
    history_locator_digest      BLOB NOT NULL CHECK (length(history_locator_digest) = 32),
    source_schema_capability_id BLOB NOT NULL CHECK (length(source_schema_capability_id) = 32),
    state                       TEXT NOT NULL,
    start_reason                TEXT NOT NULL,
    close_reason                TEXT NULL,
    observed_native_high_water  INTEGER NOT NULL DEFAULT 0 CHECK (observed_native_high_water >= 0),
    created_utc                 INTEGER NOT NULL,
    closed_utc                  INTEGER NULL,
    row_version                 INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id, source_generation_id),
    UNIQUE (realm_id, installation_id, source_id, generation_sequence),
    FOREIGN KEY (realm_id, installation_id, source_id)
      REFERENCES edge_source(realm_id, installation_id, source_id)
) STRICT;

CREATE TABLE edge_checkpoint (
    realm_id                    BLOB NOT NULL,
    installation_id             BLOB NOT NULL,
    source_id                   BLOB NOT NULL,
    source_generation_id        BLOB NOT NULL,
    high_native_visit_id        INTEGER NOT NULL CHECK (high_native_visit_id >= 0),
    native_sequence_high_water  INTEGER NOT NULL CHECK (native_sequence_high_water >= 0),
    checkpoint_version          INTEGER NOT NULL CHECK (checkpoint_version >= 0),
    active_interpretation_id    BLOB NULL,
    last_committed_page_id      BLOB NULL,
    updated_utc                 INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id, source_generation_id),
    FOREIGN KEY (realm_id, installation_id, source_id, source_generation_id)
      REFERENCES edge_source_generation(
        realm_id, installation_id, source_id, source_generation_id)
) STRICT;

CREATE TABLE edge_record_effect (
    realm_id                 BLOB NOT NULL,
    installation_id          BLOB NOT NULL,
    source_id                BLOB NOT NULL,
    source_generation_id     BLOB NOT NULL,
    native_visit_id          INTEGER NOT NULL CHECK (native_visit_id > 0),
    interpretation_id        BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    effect_kind              TEXT NOT NULL CHECK (effect_kind IN
                              ('MINIMIZED_EVENT','CONSUMED_NO_EVENT')),
    event_id                 BLOB NULL,
    payload_or_outcome_digest BLOB NOT NULL CHECK (length(payload_or_outcome_digest) = 32),
    reason_code              TEXT NULL,
    minimized_payload        BLOB NULL,
    created_utc              INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id),
    CHECK ((effect_kind = 'MINIMIZED_EVENT' AND event_id IS NOT NULL
            AND minimized_payload IS NOT NULL AND reason_code IS NULL)
        OR (effect_kind = 'CONSUMED_NO_EVENT' AND event_id IS NULL
            AND minimized_payload IS NULL AND reason_code IS NOT NULL))
) STRICT;

CREATE TABLE edge_overlap_witness (
    realm_id                   BLOB NOT NULL,
    installation_id            BLOB NOT NULL,
    source_id                  BLOB NOT NULL,
    source_generation_id       BLOB NOT NULL,
    native_visit_id            INTEGER NOT NULL CHECK (native_visit_id > 0),
    interpretation_id          BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    effect_digest              BLOB NOT NULL CHECK (length(effect_digest) = 32),
    PRIMARY KEY (realm_id, installation_id, source_id,
                 source_generation_id, native_visit_id, interpretation_id)
) STRICT;

CREATE TABLE edge_page_run (
    realm_id                    BLOB NOT NULL,
    installation_id             BLOB NOT NULL,
    page_id                     BLOB NOT NULL,
    run_id                      BLOB NOT NULL,
    source_id                   BLOB NOT NULL,
    source_generation_id        BLOB NOT NULL,
    permit_digest               BLOB NOT NULL CHECK (length(permit_digest) = 32),
    interpretation_id           BLOB NOT NULL CHECK (length(interpretation_id) = 32),
    source_schema_capability_id BLOB NOT NULL CHECK (length(source_schema_capability_id) = 32),
    collector_runtime_profile_id BLOB NOT NULL CHECK (length(collector_runtime_profile_id) = 32),
    acquisition_method          TEXT NULL CHECK (acquisition_method IN ('DIRECT','ONLINE_BACKUP')),
    outcome_category            TEXT NOT NULL,
    checkpoint_before           INTEGER NOT NULL,
    checkpoint_after            INTEGER NOT NULL,
    started_utc                 INTEGER NOT NULL,
    completed_utc               INTEGER NOT NULL,
    PRIMARY KEY (realm_id, installation_id, page_id),
    CHECK (checkpoint_after >= checkpoint_before)
) STRICT;
```

`edge_record_effect` enforces one final ordinary effect for a native natural key. It does not silently support reinterpretation. A governed correction design would require explicit supersession/audit tables rather than changing this row in place.

## 5.8 Atomic transaction algorithm

The Coordinator one writer processes a validated page as follows:

```text
BEGIN IMMEDIATE;

1. Load source, generation, lease and checkpoint by authenticated realm,
   installation and opaque IDs.
2. Verify active generation, permit digest, exact interpretation, source-schema
   capability, collector-runtime allowability and expected checkpoint version.
3. Verify page order, row bounds, snapshot high-water, page advance and all
   schema/canary/forbidden-field invariants.
4. For every native row:
     a. derive the natural key without interpretation/runtime versions;
     b. compute the approved effect digest from the minimized payload or finite
        no-event outcome;
     c. if no existing effect: mint UUIDv7 event_id only for an event, insert
        edge_record_effect and the minimized outbox row where applicable;
     d. if existing key and same effect digest: reuse prior effect/event_id;
     e. if existing key and different digest: ROLLBACK as identity_conflict.
5. Replace/prune same-interpretation bounded overlap witnesses.
6. Insert page/run outcome and any approved page-gap progress fact.
7. Compare-and-swap checkpoint_version and update high_native_visit_id,
   native_sequence_high_water, active_interpretation_id and last page.
8. Require exactly one checkpoint row update.
9. COMMIT.
10. ACK the stable page/effect results to User Host.
```

Any exception, disk full, stale version, source/permit/policy mismatch, identity conflict, cancellation, invalid page, process loss or crash before commit leaves all effects and checkpoint unchanged. A crash after commit and before ACK causes the identical page to retry and receive the committed outcome. G5 must instrument every numbered boundary.

## 5.9 Interpretation transitions

An `interpretation_id` binds at least:

```text
product ceiling digest
+ tenant policy digest
+ emergency/local narrowing digests
+ rule snapshot digest and matcher/interpreter version
+ URL normalization version
+ optional PSL commit/digest/mode
+ hard-deny registry revision
+ output schema and transform version
+ site/domain mode
+ source-time precision/validity profile
+ subject-identity profile
```

Rules:

1. one page uses one interpretation;
2. a policy/snapshot/normalizer/output transition cancels outstanding pages under old authority unless they already committed;
3. a new interpretation starts routine acquisition at the existing committed high native ID plus one; it does not replay committed IDs;
4. same-interpretation overlap witnesses may validate recent retries/mutation; cross-interpretation content comparison is not claimed because raw-derived hashes/HMACs are forbidden;
5. historical reprocessing requires a separate signed control contract, privacy/legal approval, stable correction identity, server behavior and audit/deletion design;
6. interpretation change never creates a source generation by itself.

## 5.10 State machines

### 5.10.1 Discovery

```text
RootKindScheduled
  -> AuthorityChecked
      -> Disabled
      -> RootResolved
          -> RootRejectedUnsupported
          -> RootIdentityVerified
              -> LocalStateHintParsed(optional)
              -> DirectChildrenEnumerated(bounded)
                  -> ProfileCandidate
                      -> ProfileIdentityVerified
                          -> HistoryIdentityVerified
                              -> SourceBound
                                  -> GenerationBound
                                      -> Ready

Any identity/bound/reparse/realm inconsistency -> DiscoverySafetyHold
```

### 5.10.2 Acquisition and transformation

```text
Scheduled
  -> LeaseRequested
      -> LeaseConflict -> DeferredNoAdvance
      -> LeaseGranted
          -> PermitVerified
              -> Disabled/Expired -> CancelledNoAdvance
              -> DirectOpen
                  -> SourceIdentityVerified
                      -> DirectSnapshot
                          -> RawRow
                              -> URLAuthorityAndHostProfile
                                  -> StructuralOrHardDeny
                                  -> Matcher
                                  -> MinimizedEffect
                                  -> DeterministicNoEventEffect
                                  -> PageBlockingFailure
                          -> PageReady
                      -> EligibleBusyOrLock
                          -> DirectClosed
                          -> BackupOpenAndStep
                              -> DONE+FinishOK -> PrivateSnapshotQuery
                              -> Limit/Fatal/Cancel -> Cleanup -> DeferredNoAdvance
                  -> Corrupt/Unsupported/Moved/Conflict -> Cleanup -> HoldOrDefer

PageReady
  -> UserHostRevalidated
      -> CoordinatorValidated
          -> CommitPending
              -> Committed -> Acked
              -> Conflict/Failure -> RetrySamePageNoAdvance

Every terminal path -> handles closed -> private memory released -> Task Host exit -> lease release
```

### 5.10.3 Cursor

```text
UNINITIALIZED
  -> BASELINE_PENDING
      -> BASELINE_COMMIT_PENDING
          -> READY(c0)
          -> BASELINE_FAILED -> UNINITIALIZED

READY(c)
  -> SNAPSHOT_BOUND(high_water, generation, interpretation)
      -> PAGE_PREPARED(advance_to >= c)
          -> COMMIT_PENDING(expected_version)
              -> COMMITTED(c') -> READY(c')
              -> ACK_LOST -> READY(c')
              -> STALE/FAIL/CANCEL/HOLD -> READY(c)

READY or SNAPSHOT_BOUND
  -> SOURCE_DISCONTINUITY
      -> OLD_GENERATION_FROZEN
      -> NEW_GENERATION_BASELINE_PENDING

READY
  -> INTERPRETATION_CHANGED
      -> READY(same generation, same cursor, new interpretation; no replay)
```

### 5.10.4 Page disposition

| Condition | Page outcome | Cursor/effect authority |
|---|---|---|
| all rows become minimized event or deterministic no-event and page validates | `COMMITTABLE` | whole page may commit atomically |
| source row permanently invalid under exact active interpretation and mapping says final | row `CONSUMED_NO_EVENT` | may commit only within otherwise valid page |
| output not approved, missing ordinary compatible artifact, transient busy/resource/runtime failure | `DEFER` or `RETRY` | no page effect, no advance |
| realm mismatch, source movement, identity conflict, raw/canary escape, policy broadening, impossible parser/schema invariant | `SAFETY_HOLD` | no effect/advance; source or capability disabled |
| cancellation, session ineligible, permit expiry, service restart, Task Host crash, cleanup failure | `CANCELLED/FAILED` | no effect/advance unless page already committed before ACK loss |

## 5.11 Privacy-safe observability

Endpoint logs, metrics and health MUST use finite value-free fields only. Candidate dimensions are:

```text
component
source_family
edge_channel_class
root_kind_class
acquisition_method
outcome_family
reason_family
source_schema_adapter_major
url_profile_major
build_ring
```

Forbidden labels/details include realm, tenant, installation, source, generation, user, SID, session, profile, path, URL, host, registrable domain, application, rule, native ID, exact browser version as an unbounded label, policy digest, exception message and exact input length. Exact versions/digests belong in bounded inventory/evidence records, not per-source series.

A support CLI MAY expose a short-lived opaque local source token and finite state after local authorization. It MUST NOT reveal a profile path, URL, host, account or raw file identity. Support inability to diagnose without raw activity is an accepted containment trade-off, not permission to add a bypass.

---
# 6. Human decision register

Research does not make the decisions below. Role names identify accountable functions, not assigned people. Delay preserves the conservative disabled/fail-closed state; it does not authorize an engineering default.

| ID | HUMAN DECISION | Accountable role/function | Conservative state until decided | Consequence of delay / blocked work |
|---|---|---|---|---|
| HD-01 | legal/business purpose, lawful basis and prohibited uses | Data Controller/Business Product Owner with Legal and Privacy | synthetic data only; no live source | blocks all live collection, pilot and production |
| HD-02 | employee consultation, notice and workforce governance | Employee Relations/Works Council authority with Legal/Privacy | no workforce deployment | blocks pilot/production regardless of technical pass |
| HD-03 | supported Edge channels and exact version commitment | Endpoint Product Owner with Endpoint Platform/Support and Security | no live channel; named lab builds only | blocks source policy activation and support claim |
| HD-04 | supported Windows/profile/storage estate, including RDS/VDI/FSLogix/Citrix/EDR/CFA/redirected roots | Endpoint Platform/Product Support with Security | only exact disposable lab capability; everything else unsupported | blocks G1/G2/G3/G4 applicability beyond lab |
| HD-05 | first-run lookback and activation semantics | Product/Data Owner with Privacy and Legal | live disabled; technical fallback is explicit atomic zero-lookback baseline | blocks production checkpoint initialization |
| HD-06 | approved site/domain representation | Product/Data Owner with Privacy and Legal | no production event; app-only T1 testing only | blocks the accepted site/domain functional slice |
| HD-07 | exact event fields and source-time precision/validity range | Product/Data Owner with Privacy | no live fields/time; synthetic profile only | blocks output schema, payload digest and interpretation activation |
| HD-08 | person/subject/device/session identity level | Data Controller/Product Owner with Privacy and IAM | no person or visit-origin session identity in event | blocks identity projection and reports |
| HD-09 | hard-deny categories, classifier authority and appeal/change process | Product Privacy Authority with Security/Legal | structural IP/local/special-use suppression only; semantic output disabled | blocks live permit and deny registry |
| HD-10 | non-default port support | Product/Registry Governance with Security | reject all non-default ports | blocks exact-port rules where business need exists |
| HD-11 | Unicode IDN production support | Product Owner with Security, Internationalization and Accessibility | ASCII-only profile | blocks IDN source coverage; does not block ASCII slice |
| HD-12 | whether PSL is needed and ICANN/PRIVATE semantics | Product/Data Governance with Privacy | no PSL in endpoint; no registrable-domain output | blocks registrable-domain mode, not exact/suffix host matching |
| HD-13 | whether shared-profile concurrent sessions are supported without visit-origin attribution | Product/Data Owner with Privacy and Risk | one source/lease; omit origin session; disable if attribution is required | blocks some RDS/VDI scenarios |
| HD-14 | unsupported/busy/coverage semantics shown to administrators | Product Support/Risk Owner with Data Governance | finite fail-closed health category; never interpret absence as no activity | blocks portal/support semantics |
| HD-15 | overlap/page/time/memory/backup/resource budgets | Endpoint Product and SRE/Operations with Privacy for retained metadata | labeled lab estimates only | blocks production limits and capacity/scheduling |
| HD-16 | browser-impact budget and automatic ring-stop thresholds | Product Risk Owner with Operations/Endpoint Support/Security | source write, corruption, cross-mix or crash always stops; other thresholds provisional | blocks rollout automation |
| HD-17 | permission for disk scratch and its encryption/key/remanence model | Privacy, Endpoint Security, Cryptographic Authority, Records Management and Operations | disk scratch absent/disabled | large profiles may defer; blocks disk fallback |
| HD-18 | source/overlap/run/evidence retention and deletion | Records Management/Data Controller/Data Owner | no automatic production deletion rule; T1 follows fixture manifest | blocks cleanup/deletion implementation and support retention |
| HD-19 | native SQLite/provider/support arrangement and commercial support need | Engineering Architecture with Dependency Security, Legal/Procurement and Support | prototype-only narrow adapter; no production package selected | blocks runtime dependency admission |
| HD-20 | application/rule source-of-truth, owner and publication roles | Application Registry/Data Governance | fictional rules only; no real rule publication | blocks real application attribution |
| HD-21 | policy/snapshot/release signing, key custody, expiry and emergency authority | Signing/Cryptographic Authority with Security/Release/Operations | unsigned or test-signed T1 artifacts only | blocks production control artifacts |
| HD-22 | administrative access, support evidence and separation of duties | Security IAM/Product Governance with Privacy | opaque value-free local support only; no production admin mutation | blocks support/control plane |
| HD-23 | crash dump, WER, EDR, pagefile and remote-support capture policy | Endpoint Security/Operations/Incident Response | automatic raw Task Host dumps disabled; no process-memory support bundle | blocks production diagnostics profile |
| HD-24 | metric cardinality, access, rare-population suppression and retention | SRE with Privacy/Data Governance | fixed value-free endpoint dimensions only | blocks production dashboards/alerts |
| HD-25 | semantic reprocessing/correction of already committed browser records | Data Owner/Data Governance with Privacy, Legal and Storage/Server owners | no routine replay or reinterpretation | blocks historical correction feature; upgrades continue forward only |
| HD-26 | SLO, RPO, RTO, backlog tolerance and long-offline behavior | Product/Operations/SRE | no production objective; fail closed and retain unacknowledged data | blocks production acceptance/capacity |
| HD-27 | staffing, skills, support hours and incident ownership | Engineering Leadership with Endpoint, Security, Privacy, Data and Operations | capability disabled without assigned coverage | blocks live gate and recurring Edge/runtime qualification |
| HD-28 | budget, licensing and procurement | Product/Finance/Legal/Procurement | no unapproved dependency/service/support spend | blocks selected native/test/data tooling and operations |
| HD-29 | pilot scope, risk acceptance and production go-live | Designated Production/Risk Authority | fictional disposable lab only | blocks pilot/production even after technical gates |

## 6.1 Owner questions that must be answered before live activation

1. What exact purpose requires Edge site/domain evidence, and which prohibited uses are enforceable?
2. Which Edge/Windows/profile/storage combinations are supported, and which remain explicitly unsupported?
3. Is pre-activation history necessary; if so, what bounded time/count semantics apply to late synchronized old-time records?
4. Which site representation and UTC precision are the minimum necessary fields?
5. Is subject or visit-origin session attribution required? If origin-session attribution is required for a shared database, this source does not satisfy it.
6. Which domain classes are denied regardless of application match, and who maintains them without mining employee activity?
7. Is ASCII-only coverage acceptable? If not, which exact IDNA implementation/profile is approved and supported?
8. Does registrable-domain output justify shipping and governing PSL data, and how are PRIVATE entries interpreted?
9. What source lock/resource/browser-impact budget blocks a ring?
10. Is memory-only/defer acceptable for large profiles, or is encrypted scratch worth the added privacy and operations surface?
11. Which exact SQLite binary, wrapper, advisory path and support owner are approved?
12. Who can stop and re-enable a source/build after source-write, privacy, identity or parser incidents?
13. What may support staff view without obtaining raw URLs, paths, profiles or memory?
14. What are the retention/deletion/access rules for local effects, no-event facts, health and evidence?
15. Who approves semantic correction/reprocessing, and how will it avoid duplicate business effects?

---

# 7. CLI experiment and measurement plan

## 7.1 Evidence rules for every experiment

Every experiment MUST emit a machine-readable immutable evidence record containing:

- experiment ID and one falsifiable claim;
- source commit/tree and all contract/configuration/artifact digests;
- exact SDK/runtime, native SQLite binary hash/source ID/compile options, managed packages, Edge executable/driver signatures and versions, runner/VM image and tool hashes;
- named supported-scope label and sanitized OS/session/storage/security capability facts;
- T1 fixture/corpus package root and independent oracle revision;
- start/end UTC, command identity with connection material removed, first failure and all retry links;
- pass/fail assertions, result-code distributions and bounded resource evidence;
- exact canary scanner/configuration identity, positive-control result and escape count;
- process/handle/file/task/service/firewall/certificate before/after cleanup receipt;
- accountable owner/reviewer functions and exception/expiry references;
- no credential, host, address, SSH material, real identity, real URL, raw profile/path/file identity or production activity.

A rerun cannot overwrite or erase a failure. Raw browser DBs, PML/ETL, memory captures and transient file identities stay in restricted disposable lab storage and are deleted/reverted after sanitized evidence approval.

## 7.2 Ordered experiments

| ID | Classification and experiment | Required evidence | Pass | Fail / stop |
|---|---|---|---|---|
| E-B02-00 | **FACT/CLI EXPERIMENT — input manifest**: hash six allowlisted files and record review/public-source identities | exact names, sizes, SHA-256, review date, no extra Project input | exact table in evidence boundary | missing/changed/substituted/unallowlisted Project input |
| E-B02-01 | **CLI EXPERIMENT — predecessor gate binding**: validate G0/G1/contract/policy/repository gate artifacts for exact source and lab scope | immutable predecessor gate, owner/ADR states, process/token/IPC/cleanup evidence digests | G1 passes every claimed environment; no expired exception | live-source work remains blocked |
| E-B02-02 | **CLI EXPERIMENT — toolchain/native inventory**: `dotnet --info`, package locks/sources, loaded SQLite module, source ID, compile options, required API bitmap | sanitized JSON inventory and exact binary/source mapping | all inputs supported, exact and admitted; no provider/native mismatch | unknown/floating/unmapped native or package; required API absent |
| E-B02-03 | **CLI EXPERIMENT — repository architecture mutations**: inject raw-type, path, SQL, write, network, plugin, generic DTO, logging and cursor-ownership violations | dependency/API graph and each mutation result | every forbidden mutation fails; clean tree restored | one mutation survives or cleanup differs |
| E-B02-04 | **CLI EXPERIMENT — deterministic T1 Edge package**: generate synthetic roots/profiles, localhost visit plans, handcrafted DBs, rule/URL corpus and independent truth twice | byte-identical canonical roots, lineage/cursor/page/effect truth, canary registry, no real value | determinism and independent oracle/mutation gates pass | nondeterminism, real/organization value, oracle production-code dependency, mandatory mutation survivor |
| E-B02-05 | **CLI EXPERIMENT — canary self-test**: plant every raw URL component, Unicode spelling, profile/path/identity and known derivative in declared sinks/encodings | marker/sink/encoding matrix, scanner binary/config digests, redacted report | every mandatory positive control detected before any containment claim | one miss, broad suppression, external upload or report leak |
| E-B02-06 | **CLI EXPERIMENT — bounded root/profile discovery**: default/managed local roots, corrupt/stale Local State, decoys, reparse, limits, invalid policy paths | attempted-operation categories, exact source oracle, no serialized raw names/paths | exact supported profile set; no access outside bounded roots/files | recursive access, unsupported root opened, raw metadata sink or supported fixture miss |
| E-B02-07 | **CLI EXPERIMENT — source binding and realm isolation**: rename/recreate/collide labels/UUIDs/realms and race path substitution | transient identity trace restricted to lab; keyed locator/source ledger in shareable evidence | rename continuity only with same directory identity; recreation new source; no cross-realm merge | path/name/SID authority, raw identity durable/logged, wrong realm accepted |
| E-B02-08 | **CLI EXPERIMENT — SQLite security profile**: open flags, effective `db_config`, authorizer, limits, statement-readonly, main-handle identity, moved checks, query plan | exact native profile and return/effective values | every required control succeeds; fixed plan; path swap rejected | ignored control, write fallback, actual handle mismatch, view/virtual/full scan, unknown native behavior |
| E-B02-09 | **CLI EXPERIMENT — G2 direct live read and zero source write**: approved disposable Edge profile with loopback visits and continuous writes | per-PID filesystem operation counts, source before/after, actual handle equality, oracle page, Edge health | exact page/no-event effects; zero source mutation/write intent defect; no crash/corruption; failures no advance | any source write, raw escape, handle mismatch accepted, impact/corruption or non-success advance |
| E-B02-10 | **CLI EXPERIMENT — Online Backup lock/churn/page-size/cancel**: direct-eligible lock outcomes, source churn, destination page-size variants, fatal errors and cancellation | step result sequence, observed DONE, finish result, page counts, memory/time, oracle, cleanup | query only after DONE+finish OK; bounded retries/restarts; exact snapshot; zero write/residue; every incomplete case no advance | finish-only acceptance, page-size mismatch mishandled, unbounded retry, incomplete query, source write, residue |
| E-B02-11 | **CLI EXPERIMENT — G2 browser-impact A/B**: randomized paired baseline/direct/backup/cancel runs on named capability | raw T1 timings restricted; sanitized quantiles/intervals, Edge/UAM resources, lock duration, crash/hang/corruption counts | zero crash/corruption/source write; human-approved measured guardrails pass | primary invariant failure or unexplained material regression |
| E-B02-12 | **CLI EXPERIMENT — cancellation/crash/cleanup**: cancel/kill/restart/logoff/shutdown at every acquisition/transform/page boundary | state trace, process/job/handle/store delta, dump policy, canary scan, cleanup receipt | pre-commit zero effect/advance; post-commit/pre-ACK stable retry; no orphan/raw residue | orphan, dump escape, partial page/effect, unknown checkpoint delta, cleanup failure |
| E-B02-13 | **CLI EXPERIMENT — same-SID multi-session**: one shared physical profile and session-variable distinct roots in an approved multi-session VM | sanitized logon/session classes, source/lease timeline, Task Host count, canary/event oracle | shared source max one active acquisition; loser no read/advance; distinct roots distinct sources; no origin-session claim | two active readers, duplicate source/effect, cross-session mix; unavailable environment is BLOCKED not PASS |
| E-B02-14 | **CLI EXPERIMENT — native-ID cursor model**: equal times, late old-time inserts, gaps, sequence above max, retries, invalid rows, random operation model | seed, operation count, minimal counterexample, expected/actual effect and checkpoint ledger | exact set equality; time-independent order; gaps only through proved snapshot; one effect per native key; failures no advance | miss/extra/duplicate, timestamp dependency, silent skip, unproved gap advance or conflict accepted |
| E-B02-15 | **CLI EXPERIMENT — source/generation discontinuity**: History/profile replacement before/during reads, moved file, regression, restore, schema change and injected identity reuse | handle/locator/generation/checkpoint transition ledger | new source/generation/suspect state exactly as oracle; old cursor/effects unchanged | discontinuity accepted into old lineage, path-only merge, old checkpoint reset or collision |
| E-B02-16 | **CLI EXPERIMENT — collector/interpretation lineage separation**: vary Edge/.NET/SQLite/adapter/policy/normalizer/snapshot/output independently | source/generation/capability/runtime/interpretation IDs and transition ledger | runtime/interpretation changes never reset source/generation or natural key; unsupported runtime blocks; semantic change moves forward without replay | false generation, duplicate effect, changed natural identity or silent historical reinterpretation |
| E-B02-17 | **CLI EXPERIMENT — current named Edge capability matrix**: exact human-selected builds plus incompatible future-shaped fixture | signed Edge/driver hashes, source capability, plans, direct/backup/zero-write/cursor/privacy results | every claimed build passes; harmless extras tolerated; incompatible shape disabled; version number alone cannot authorize | guessed schema, unsupported emits, current/previous prose treated as pass |
| E-B02-18 | **CLI EXPERIMENT — golden-before-code ASCII URL profile**: strict authority/host/IP/port/trailing-dot/discarded-component vectors and unsafe mutations | vector root, independent reference graph, exact stage/reason/canonical tuple, mutation report | exact expected matrix; no exception/raw echo; unsafe mutations detected | production-first oracle, unclassified acceptance, IP/userinfo/authority smuggling or raw value |
| E-B02-19 | **CLI EXPERIMENT — optional IDNA candidate**: exact runtime/globalization mode, UTS #46/Unicode vectors, Bidi/Joiner/hyphen/round-trip/differential tests | implementation/source/data identities and semantic-diff report | only if exact approved profile passes with zero unclassified difference; otherwise feature remains disabled | any unsupported flag/profile assumption, ICU/NLS drift or unclassified accepted error |
| E-B02-20 | **CLI EXPERIMENT — matcher/policy/realm analysis**: synthetic exact/suffix rules, permutations, overlaps/shadows, same UUIDs across realms, tenant broadening | independent/production maximal sets, witnesses, monotonic counterexamples | order-independent; cross-app maxima ambiguous; no cross-realm result; tenant never broadens | guessed tie, missed conflict, unknown treated safe or broadening |
| E-B02-21 | **CLI EXPERIMENT — full G4 all-sink containment**: Task Host→User Host→Coordinator synthetic chain, event/no-event/reject/defer/hold/crash cases | both IPC captures, SQLite/WAL/SHM, logs/traces/metrics/network/dump/support manifests and canary report | zero forbidden marker or declared derivative outside approved source fixture; only closed page/failure contracts | one escape, scanner miss, uncontrolled dump/egress, hidden field or residue |
| E-B02-22 | **CLI EXPERIMENT — page contract negatives**: mixed interpretation, out-of-order/duplicate IDs, locator/raw field, wrong source/generation/permit, partial row and bounds | parser/validator/state result for every hostile page | every invalid page rejected as a whole before transaction; no proposed/actual advance | any partial acceptance or row-level cursor authority |
| E-B02-23 | **CLI EXPERIMENT — G5 failpoint handoff**: crash before/after every effect/no-event/witness/page/checkpoint/commit/ACK operation | durable DB/WAL/SHM truth after each failpoint and retry | cursor never ahead; one effect; same event ID reused; uncertainty no progress; ACK only after commit | loss, duplicate, changed event ID, cursor ahead, effect without checkpoint relation |
| E-B02-24 | **CLI EXPERIMENT — rollout/kill/recovery**: old/new runtime, source adapter, interpretation, snapshot, unsupported candidate, lower sequence and incident signals | activation/lease/cancel/effect timeline and higher-revision recovery evidence | consumer support precedes producer policy; one active interpretation; no lower revision; kill stops new work; no self-reenable | partial activation, duplicate semantics, silent fallback, stale work commits or unauthorized recovery |
| E-B02-25 | **CLI EXPERIMENT — dependency/SBOM/provenance**: reconcile loaded native and shipped files to locks/source, simulate substitution | file manifest, dependency records, SBOM(s), provenance subject/materials, tamper results | every byte maps to admitted source/binary/license; substitution rejected | source/package/native mismatch, omitted component, mutable/latest input or unresolved license/security gap |
| E-B02-26 | **CLI EXPERIMENT — aggregate gate**: evaluate exact evidence/ADR/owner/human-disable states | `batch-02-gate.json` binding all evidence and cleanup digests | all required claims pass for named scope; zero primary failures; no unassigned blocker/expired exception | no live/outbox permission; open named ADR and stop dependent work |

## 7.3 Smallest falsifying prototypes

### P-B02-01 — source write and live snapshot

**Claim.** A bounded direct snapshot can read the exact synthetic native-ID page from a live supported Edge profile without a UAM source write, browser corruption or wrong-file acceptance.

**Setup.** Approved disposable Windows VM, passed G1 build, one fictional local account, exact Edge build, fresh synthetic default root, sync/sign-in disabled, loopback-only web server and fixed visit plan.

**Pass.** Exact effect/no-event oracle; actual SQLite handle equals candidate; path-swap variant rejected; zero successful or unexplained write intent against root/main/WAL/SHM; Edge reopens cleanly; every failed attempt has zero checkpoint delta.

**Stop.** One source mutation, raw escape, handle mismatch accepted, browser corruption/crash attributable to UAM or non-success advance.

### P-B02-02 — backup completion and churn

**Claim.** Online Backup can produce a coherent private snapshot only after complete bounded transfer under eligible live-write conditions.

**Setup.** Browser-generated and handcrafted WAL fixtures, destination page-size variants, lock/churn/cancellation controller and memory-only destination.

**Pass.** Every accepted case observes `SQLITE_DONE`, then successful finish, exact private-snapshot oracle, source closed before destination query, bounded resource/lock, zero write and complete cleanup. Every incomplete/fatal/cancel case has zero durable effect/advance.

**Stop.** Querying incomplete destination, finish-only acceptance, unbounded restart, page-size error misclassification, memory cap bypass or residue.

### P-B02-03 — lineage separation

**Claim.** Source/generation identity survives implementation and privacy upgrades without duplicate effects, while actual database replacement creates a new generation.

**Setup.** One source with committed native IDs; vary runtime/native/adapter/normalizer/policy/snapshot/output, then replace/regress the database.

**Pass.** Implementation/interpretation changes preserve source/generation/cursor/natural key and start forward-only semantics; source replacement/regression closes old generation; no historical auto-replay or duplicate event.

**Stop.** Upgrade resets cursor/generation, changes natural key, emits a second effect for an old native ID or replacement remains in old generation.

### P-B02-04 — full raw-value containment

**Claim.** Raw URL and every forbidden component/known derivative remain inside Task Host source memory across success, deterministic no-event, failure, crash and retry.

**Setup.** Exact canary registry, synthetic source adapter, both IPC captures, endpoint store, logs/traces/metrics/network/dump/support collectors and canary self-test.

**Pass.** Only minimized page or value-free page failure appears outside Task Host; zero marker/derivative in every sink; cleanup complete; invalid/mixed page cannot commit.

**Stop.** One escape, scanner positive-control miss, unapproved dump/egress or residue.

### P-B02-05 — whole-page crash invariant

**Claim.** One page produces one effect per native record and advances only in the same transaction; ACK loss does not duplicate.

**Setup.** Synthetic page with event and no-event rows, SQLite WAL one writer and failpoints at every transaction boundary.

**Pass.** Every pre-commit crash restores exact prior state; every post-commit/pre-ACK retry returns the existing event/no-event and checkpoint; no mixed interpretation/partial page state exists.

**Stop.** Cursor ahead, orphan event, lost no-event fact, duplicate event, changed UUID or ACK before commit.

## 7.4 Exact primary acceptance expression

```text
BATCH_02_TECHNICAL_PASS =
    PREDECESSOR_G1_PASS
    AND G2_ZERO_SOURCE_WRITES = 0
    AND G2_INCOMPLETE_BACKUP_ACCEPTED = 0
    AND G2_ATTRIBUTABLE_BROWSER_CORRUPTION_OR_CRASH = 0
    AND G3_CONTROLLED_FIXTURE_MISSING = 0
    AND G3_CONTROLLED_FIXTURE_EXTRA = 0
    AND G3_CROSS_SOURCE_SESSION_REALM_MIX = 0
    AND G3_NON_SUCCESS_CURSOR_DELTA = 0
    AND G3_FINAL_BUSINESS_DUPLICATES = 0
    AND G4_FORBIDDEN_VALUE_OR_DERIVATIVE_ESCAPES = 0
    AND G4_GUESSED_AMBIGUITIES = 0
    AND G4_CROSS_REALM_RESULTS = 0
    AND G4_TENANT_BROADENING_COUNTEREXAMPLES = 0
    AND G4_MANDATORY_SCANNER_MISSES = 0
    AND PAGE_PARTIAL_OR_MIXED_INTERPRETATION_COMMITS = 0
    AND G5_CURSOR_AHEAD_OR_DOUBLE_EFFECT = 0
    AND CLEANUP_RESIDUE = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

No percentage, recall ratio, latency average, support exception or risk statement can compensate for a nonzero primary invariant count.

---
# 8. Threat, failure and recovery gaps

## 8.1 Consolidated register

| ID | Threat/failure | Current containment | Missing evidence or recovery path | Owner/gate |
|---|---|---|---|---|
| T-01 | Coordinator or another privileged machine process accesses Edge profile | architecture/API bans; accepted process boundary; per-PID trace | prove zero indirect filesystem access on every claimed environment and dependency update | Endpoint Architecture/Windows Security; G1/G2 |
| T-02 | mandatory/default root resolution escapes to unsupported path | release-owned root IDs, absolute/local checks, handle/final-path/reparse validation | exact policy precedence/variable/storage matrix under enterprise settings | Collector/Endpoint Platform; G3 |
| T-03 | malicious/corrupt `Local State` leaks account/profile data or exhausts parser | bounded streaming hint, no authority, canaries, direct-child fallback | parser fuzz, all-sink proof, support behavior for repeated corruption | Collector Security/Privacy; G3/G4 |
| T-04 | same-user process swaps root/profile/History between checks | held handles, `FILE_ID_INFO`, actual SQLite main handle, moved/post-read checks | race campaign across filesystems/security products; no path-only fallback | Windows Security/Native Storage; G2/G3 |
| T-05 | Windows file identity is eventually reused | UAM UUID source/generation, native high-water and overlap witnesses | no read-only scheme proves eternal lineage; document ambiguity and correction response | Data Correctness; residual/G3 |
| T-06 | shared physical profile used by two sessions | keyed locator equality and one source lease | approved RDS environment and business decision on absent origin attribution | Runtime/Product/Data; G3/HD-13 |
| T-07 | session-variable roots unexpectedly collide or expose client/session labels | physical identity, no raw labels, distinct source if distinct handle identity | exact variable expansion and enterprise profile tests | Endpoint Platform/Privacy; G3 |
| T-08 | source write/checkpoint/WAL cleanup by UAM | OS write denial, read-only SQLite, no checkpoint-on-close, zero-write trace, positive control | exact selected native/provider behavior under last-connection and recovery races | Native Storage/Windows Security; G2 |
| T-09 | read-only WAL prerequisites are absent | no write fallback; eligible backup only; defer/unsupported | exact Edge states showing which combinations can be read safely | Native Storage/Support; G2 |
| T-10 | direct reader holds locks or harms Edge | short transaction, fixed query/plan, cancellation and resource budget | paired browser impact on every supported capability and real enterprise controls | Endpoint Product/SRE; G2 |
| T-11 | backup accepted incomplete | explicit `SQLITE_DONE` plus finish OK; no destination use before completion | implementation mutation and failpoint proof | Native Storage; G2 |
| T-12 | in-memory backup page-size mismatch | destination page-size set/validated; fatal READONLY classification | fixtures for all supported source page sizes/native builds | Native Storage; G2 |
| T-13 | continuous writes cause unbounded backup restart/CPU/memory | permit-bound step/retry/time/page/memory caps | measured restart inference and browser-impact trade-off | Native Storage/SRE; G2 |
| T-14 | corrupt/malicious SQLite schema exploits native parser or triggers untrusted code | defensive/trusted-schema/authorizer/trigger/view/extension controls, fixed query, Task Host bounds | native fuzz/advisory response, exact compile options, malformed corpus | Collector Security/Dependency; G2 |
| T-15 | wrapper silently substitutes another native SQLite binary | loaded module hash/source ID/compile options and SBOM/provenance | selected package/mirror/installer and recurring startup self-check | Dependency/Release; G2 |
| T-16 | Edge changes schema/query plan/locking | source capability IDs, current candidate fixtures, kill switch | recurring exact signed Edge compatibility lane and support commitment | Browser Compatibility/Support; G2/G3 |
| T-17 | Chromium upstream source is mistaken for exact Edge contract | source register distinguishes upstream reference from Edge fixture evidence | exact Edge source mapping is generally unavailable; rely on behavior/fixture and fail closed | Architecture/Browser Compatibility |
| T-18 | native IDs regress or are reused after replacement | source generation namespace, file/high-water/witness checks | restore scenarios beyond overlap can evade detection; incident/correction policy | Data Correctness; G3 |
| T-19 | source row changes older than overlap | overlap is bounded and same-interpretation only | no raw/hash retention allowed; cannot prove old-row immutability | Data Correctness/Privacy; residual |
| T-20 | interpretation upgrade causes false conflict or duplicate | separate interpretation ID; no routine replay; natural key version-independent | correction/reprocessing contract and migration evidence if business later requires replay | Data Governance/Storage; HD-25 |
| T-21 | invalid row blocks a source indefinitely | finite deterministic no-event mapping; source-specific disable/health | poison-row support/recovery without raw support evidence | Collector/Data/Operations; G3/G4 |
| T-22 | time conversion overflow/non-monotonic clock misused | checked conversion, finite quality/disposition, ID cursor | approved time range/precision and exact Chromium/Edge fixture behavior | Product/Data/Privacy; HD-07 |
| T-23 | raw URL copied through string/exception/logger/serializer | Task Host-only type boundary, no raw DTO, fixed exception map, canaries, dump suppression | managed/pagefile/EDR capture cannot be fully controlled; enterprise diagnostics decision | Privacy/Runtime/Security; G4/HD-23 |
| T-24 | raw URL hash/HMAC added as “safe” diagnostic or dedupe | explicit architecture/schema ban and derivative canaries | reviewer/tool false negatives; recurring mutation tests | Privacy/AppSec; G4 |
| T-25 | browser-compatible parser recovery changes authority | strict raw authority scanner and parser-boundary agreement | exhaustive/differential corpus for runtime patches | URL Profile/Security; G4 |
| T-26 | legacy numeric IP bypasses DNS-host rule | raw and parsed independent IP detection; structural suppression | complete generated/reference corpus and runtime patch diff | URL Profile/Security; G4 |
| T-27 | Unicode/IDNA implementation does not match desired profile | ASCII-only default; IDNA candidate disabled | exact UTS #46 options/data/runtime conformance or admitted dedicated library | Internationalization/Security; G4 |
| T-28 | PSL drift or PRIVATE semantics changes output | no initial PSL; future exact pin/digest/mode/no-network | human site-semantics/license decision and dual parser/update diff | Data Governance/Registry; HD-12 |
| T-29 | valid public host is sensitive despite syntax | hard-deny before match, product ceiling, no unmatched output | human category authority can never be complete; prohibited-use/access controls | Product Privacy/Legal; HD-09 |
| T-30 | rule overlap silently misattributes application | closed grammar, all-rule maximal set, ambiguity, static analyzer | business rule owner/review process and observed coverage without raw-value mining | Registry Governance; G4/HD-20 |
| T-31 | wrong-realm artifact/cache/page | authenticated realm, realm-keyed caches/store, same-realm snapshot, negative tests | upstream registration/PKI compromise remains outside G4 proof | Realm Security/Registry; G4 |
| T-32 | policy/snapshot changes while page runs | one interpretation per page; cancel/discard on transition | kill latency, offline/stale endpoints and restart campaign | Policy/Runtime; G4 |
| T-33 | deterministic no-event is incorrectly treated as permanent | reason mapping bound to interpretation; no replay on upgrade | semantic review/mutation tests and governed correction design | Data/Privacy/Storage; G4/G5 |
| T-34 | page with one unsafe row partially commits valid siblings | whole-page rejection and schema/state validator | failpoints/mutations around every validation/transaction stage | Storage/Data Correctness; PAGE/G5 |
| T-35 | event UUID changes on retry | UUID minted/persisted at first effect insert; natural uniqueness | G5 pre/post-commit/ACK failpoint proof | Storage; G5 |
| T-36 | cursor advances over effect/no-event loss | one-writer atomic transaction and compare-and-swap checkpoint | G5 implementation and disk-full/process-loss/restore evidence | Storage; G5 |
| T-37 | long fail-closed outage causes source rows to disappear before collection | no silent drop; health/backlog state; conservative retries | SLO/backlog/support decisions and measured Edge retention/deletion behavior | Product/SRE/Support; HD-26 |
| T-38 | metrics/logs create covert value/cardinality channel | finite dimensions/reason codes, no dynamic values, cardinality lint | rare-population access/retention policy and incident exercises | SRE/Privacy; HD-24 |
| T-39 | support requests raw URL/profile/dump | support contract prohibits it; synthetic reproduction and opaque local state | organizational enforcement and vendor/EDR governance | Support/Privacy/Incident; HD-22/23 |
| T-40 | canary scanner misses split/encoded/vendor sink | exact markers, declared encodings, positive controls and multiple sink collectors | no finite scanner proves absence in opaque tooling; enterprise agent inventory | Privacy/AppSec/Endpoint Security; G4 |
| T-41 | cleanup fails after Task Host crash or future scratch | job kill-on-close, memory-only destination, exact cleanup diff and source disable | machine reboot/power-loss matrix; scratch remains absent | Runtime/Operations; G2/G4 |
| T-42 | dependency/supply-chain compromise alters parser/native/test oracle | locked sources/binaries, two builds, SBOM/provenance, independent references | signing/mirror/CI platform and incident drill | Supply Chain/Release; B02-25 |
| T-43 | fail-closed control cannot be re-enabled safely | protected kill/SafetyHold, higher-revision recovery, self-test | assigned authority, offline endpoint behavior, runbook drill | Incident/Policy/Operations; B02-24 |
| T-44 | telemetry absence interpreted as no user activity | distinct unsupported/busy/deferred/absent/denied states and product warning | portal/report governance and prohibited-use enforcement | Product/Data Governance; HD-14 |

## 8.2 Mandatory recovery runbooks

Before a Batch 02 technical gate can pass, these runbooks MUST exist, name owner functions, and be exercised with T1 data:

1. **Source write or browser corruption.** Immediate global/ring source stop; preserve sanitized per-process operation evidence; verify source/browser health; revoke candidate release; update native/profile and rerun all G2 controls.
2. **Cross-profile/session/realm mix.** Global stop; quarantine unsent local effects; prevent upload where custody has not occurred; preserve opaque source/generation/effect metadata; repair identity/lease/cache logic and rerun full multi-session/realm matrix.
3. **Cursor/effect invariant failure.** Stop G3/G5-dependent work; compare effect/page/checkpoint ledgers; do not hand-edit production data; fix and rerun all failpoints. Any production correction requires a separate data-governance plan.
4. **Schema/capability drift.** Mark source unsupported; do not guess columns or plan; create exact signed Edge fixture; update consumer adapter before control policy can authorize it.
5. **Persistent busy/impact regression.** Disable backup or source capability; collect aggregate lock/resource evidence; never stop Edge, add privilege or write source as a workaround.
6. **Privacy canary/raw derivative escape.** Stop G4 source and transport for affected build/ring; locate every sink; revoke/quarantine artifacts; delete/contain under incident/retention authority; add neighboring encodings and rerun complete all-sink gate.
7. **Parser/IDNA semantic disagreement.** Disable affected normalizer/Unicode capability; create a fictional minimal reproducer; classify against primary standards/references; release a new semantic version or keep input disabled.
8. **Rule ambiguity/publication defect.** Emit no activity event; stop snapshot if threshold indicates unsafe publication; correct and republish at higher sequence after analysis/review.
9. **Native dependency incident.** Freeze promotion; bind loaded binary/source/package hashes; update/rebuild; rerun corruption/WAL/backup/source-write/cursor/privacy campaigns; retain first failure.
10. **Cleanup/residue failure.** Disable source/capability; kill exact job/processes; delete only product-owned manifest-authenticated paths; remove test certs/rules/tasks; produce before/after receipt; never broad-delete user directories.
11. **Policy/snapshot kill and recovery.** Stop new permits, cancel outstanding work, discard stale pages, require higher-revision authorized recovery artifact and passed self-test; no local self-reenable.
12. **Support without raw data.** Reproduce with exact T1 fixture/runtime/source-capability facts; use opaque source token and finite state only; escalate unresolved cases rather than exporting raw source or memory.

Each runbook must state trigger, authorization, containment, evidence, rollback/recovery, cleanup/deletion limits, re-enable conditions, and the adjacent gates that must be rerun.

---

# 9. ADR create/update list

## 9.1 Batch-level ADRs to create

| ADR | Decision | Status from this review | Evidence/review trigger |
|---|---|---|---|
| ADR-B02-001 | Batch 02 conditional scope, G1-first order, G2/G3+G4 before production outbox, and no real data | **Create — accept** | explicit baseline change proposal only |
| ADR-B02-002 | Separate source generation, source schema capability, collector runtime profile and interpretation ID | **Create — accept** | lineage falsification or migration evidence |
| ADR-B02-003 | Release-owned default/mandatory-policy local Edge roots; bounded Local State hint/direct children; no command-line/custom crawl | **Create — accept for prototype** | supported root technology change or failed discovery evidence |
| ADR-B02-004 | Direct short read-only snapshot, eligible Online Backup to memory, then defer; DONE+finish acceptance | **Create — accept; carries predecessor acquisition decision** | source-write/impact/recall failure or superior supported API |
| ADR-B02-005 | Versioned SQLite security adapter: actual main-handle identity, effective controls, fixed SQL/plan and zero-write proof | **Create — accept outcomes; exact profile gated** | native/provider/API or environment change |
| ADR-B02-006 | UAM source/generation identity and local keyed locator handling; raw identities transient only | **Create — accept** | file-identity failure or new filesystem capability |
| ADR-B02-007 | Native `visits.id` cursor, same-interpretation overlap and no semantic-upgrade replay | **Create — accept** | supported source lacks equivalent native order or governed reprocessing need |
| ADR-B02-008 | Unified whole-page contract; page-owned progress; atomic effect/no-event/witness/checkpoint handoff | **Create — accept logical model; G5 proof mandatory** | G5 failpoint result or store redesign |
| ADR-B02-009 | Raw URL and final transformation stay inside fixed Task Host; only minimized page/value-free failure crosses IPC | **Create — accept invariant** | no expected ordinary change; topology change requires baseline proposal |
| ADR-B02-010 | `uam-url-host-ascii-v1` first; authority/host strictness; Unicode IDNA disabled pending exact conformance | **Create — accept ASCII / defer IDNA** | IDNA admission evidence or parser counterexample |
| ADR-B02-011 | Exact/suffix DNS-host matcher, all-rule evaluation, deterministic ambiguity and site/domain baseline preservation | **Create — accept** | approved new matcher family or functional-slice change proposal |
| ADR-B02-012 | PSL absent initially; if introduced, exact pinned local data/digest/mode/no-network/license and no authority semantics | **Create — accept deferral/invariants** | human registrable-domain/deny need and license/admission evidence |
| ADR-B02-013 | Natural record identity excludes interpretation/runtime; UUIDv7 event minted/persisted at first atomic commit | **Create — accept** | correction/replay or central dedupe contract change |
| ADR-B02-014 | No raw/reversible derivative, native cursor or locator in transport/observability; finite value-free health | **Create — accept** | bounded diagnostic need with equal privacy/cardinality containment |
| ADR-B02-015 | First-run lookback, site/time/identity/output and hard-deny content remain human decisions with disabled defaults | **Create — record boundary** | approved decision records |
| ADR-B02-016 | Disk scratch absent/disabled; separate encrypted-scratch ADR required after measured need | **Create — accept** | memory-only infeasibility plus human approval |
| ADR-B02-017 | Same physical profile across sessions is one source/lease; no visit-origin session claim | **Create — accept technical rule / business support deferred** | attribution requirement or multi-session evidence |
| ADR-B02-018 | Consumer-first source-adapter/interpretation rollout, one semantic path, no automatic historical reinterpretation | **Create — accept** | fleet/offline/correction evidence |
| ADR-B02-019 | All exact limits, campaign counts, impact thresholds and support windows are replaceable estimates until measured/approved | **Create — accept** | each measured budget or escaped defect |
| ADR-B02-020 | OSS/data/test-tool admission and classification; exact package/source/binary/license/security/test/removal evidence | **Create — accept** | dependency update/admission |

## 9.2 Topic/predecessor ADR actions

| Existing topic/predecessor area | Required action |
|---|---|
| Batch 01 raw Task Host boundary, RunIntent/permit, strict contracts, finite matcher, privacy lattice and repository gates | **Preserve without change** |
| G23 source capability fingerprint/generation ADRs | **Update:** split source schema capability, collector runtime profile and source generation; remove runtime/interpretation from generation identity |
| G23 dedupe ADR | **Update:** remove extractor/contract major from natural key; event UUID minted/persisted at first commit |
| G23 page/result schemas | **Update:** remove `historyLocatorDigest` and row-level progress; add fixed interpretation/runtime/source-capability provenance and page-owned progress |
| G23 overlap ADR | **Update:** same-interpretation outcome witness only; interpretation transition resets witness without replay/generation reset |
| G23 source locator ADR | **Update:** remove creation time from primary locator identity; raw handle identity is transient local control metadata |
| G23 Online Backup ADR | **Update:** require observed `SQLITE_DONE` plus finish OK and destination page-size evidence |
| G23 SQLite hardening ADR | **Keep proposed:** outcomes accepted; literal opcodes/limits are exact adapter CLI evidence |
| G23 current/previous Edge support text | **Keep provisional:** named human-approved matrix, no global commitment |
| G4 raw boundary/minimized DTO/finite matcher/ambiguity/realm/policy/no-derivative ADRs | **Accept and carry forward** |
| G4 URL profile ADR | **Update:** ASCII first; strict authority/host; discarded-component details versioned; browser/parser implementation not authority |
| G4 UTS #46/.NET ADR | **Update:** Unicode feature disabled until exact desired profile is proved; do not claim current .NET API equals full profile |
| G4 PSL ADRs | **Update:** PSL not shipped/required initially; retain pin/no-network/mode/license rules if later introduced |
| G4 site-mode ADR | **Update:** app-only is T1 test profile; accepted site/domain functional slice remains human-blocked, not replaced |
| G4 million-case gate ADR | **Update:** coverage/properties/zero failures are mandatory; exact count is an evidence-budget estimate |
| G4 G5 disposition ADR | **Merge with ADR-B02-008:** page-level, not row-level, progress authority |

No ADR may be marked accepted for production while its owner is `UNASSIGNED`, its named CLI evidence is missing, a required human decision is implicitly enabled, or a primary invariant has a nonzero failure count.

---
# 10. Ordered implementation backlog and dependency/stop gates

## 10.1 Critical path

| Order | Work item | Dependencies | Deliverable | Exact stop gate |
|---:|---|---|---|---|
| 1 | record Batch 02 evidence manifest and open ADR files | none | six-file hash manifest, public-source register, ADR/owner templates | missing/extra Project input or unreviewed predecessor conflict |
| 2 | assign accountable owner functions and create human-decision records | 1 | owner/escalation register with disabled defaults | any safety-critical function `UNASSIGNED` before its work begins |
| 3 | bind exact Batch 01/G1 gate to the source tree and intended lab | 1–2 | predecessor evidence index and supported-scope statement | no live-source code may execute without exact G1 pass |
| 4 | add Batch 02 contract/model projects and architecture guards | 3 | source/generation/capability/runtime/interpretation/page/effect types and forbidden API/type tests | raw type, arbitrary path/SQL/write/network/plugin or row-cursor mutation survives |
| 5 | implement deterministic T1 Edge/URL/rule/canary package and independent oracle | G0 foundations, 4 | browser/handcrafted fixture plans, expected source/generation/page/effect ledgers | nondeterminism, real value, common production decision code or scanner miss |
| 6 | implement native/runtime inventory and SQLite admission spike | 3–5 | exact loaded module/source ID/compile options/API bitmap and package/source comparison | unknown native, provenance/license gap or required API absent |
| 7 | select one prototype-only SQLite adapter behind a narrow interface | 6 | SafeHandle/P/Invoke boundary, package lock, removal path | convenience/popularity selection, broad raw API exposure or unmapped binary |
| 8 | implement Windows directory/file identity and final-path/reparse library | 4, 7 | safe typed open-handle identity methods and race tests | unsafe interop, path-only identity fallback or raw logging |
| 9 | implement bounded default/managed-root discovery in User Host | 5, 8 | exact policy/root resolver, bounded Local State hint and child enumeration | recursive crawl, command-line root discovery or unsupported root open |
| 10 | implement Coordinator transient source-binding/HMAC service | 4, 8–9 | one-use raw identity contract, keyed locator, source registry | raw identity durable/logged/uploaded or path/name/SID becomes authority |
| 11 | implement source/generation/schema-capability/runtime/interpretation models | 4–10 | pure transitions and realm-negative tests | runtime/interpretation can change source generation or natural identity |
| 12 | implement logical endpoint schema/migrations with natural uniqueness | 11 | source/generation/checkpoint/effect/witness/page tables | key includes extractor version; effect can be silently overwritten; realm/install missing |
| 13 | implement direct SQLite security adapter and capability detector | 5–12 | read-only/effective-control/fixed-query/handle/plan/cancel profile | any mandatory control ignored, read/write fallback or unbounded plan |
| 14 | implement ASCII URL host profile and independent golden vectors before production matcher | 4–5 | strict authority/host/IP/port/trailing-dot/discarded-component profile | production behavior defines oracle, unsafe mutation survives or raw value logged |
| 15 | implement exact/suffix matcher, analyzer and finite policy/no-event mapping | 4–5, 14 | same-realm snapshots, ambiguity/shadow witnesses and monotonic tests | first-match/order tie, cross-realm result, tenant broadening or unknown treated safe |
| 16 | implement Task Host raw-source adapter and closed privacy transform | 13–15 | raw types private, new minimized effect/no-event structs, canary guard | raw/hash/HMAC/hidden field crosses serializer; live fields implicitly enabled |
| 17 | implement direct bounded native-ID page | 11–16 | snapshot high-water, fixed query, one interpretation and page envelope | source write, mixed interpretation, raw locator, partial row/page or time cursor |
| 18 | implement Online Backup memory fallback | 7, 13, 16–17 | page-size handling, DONE+finish state, bounded step/cancel/cleanup | disk fallback, finish-only acceptance, unbounded retry or incomplete destination use |
| 19 | keep disk scratch absent and assert it in build manifest | ADR-B02-016 | architecture/file manifest test | any raw temp/snapshot path appears without separate ADR |
| 20 | implement source lease and same-source serialization | 10–12 | lease acquire/renew/release/expiry bound to generation/session | two active acquisitions for one physical source |
| 21 | implement native-ID cursor/overlap model and interpretation transition | 5, 11–12, 17 | pure page-selection/effect/conflict model and no-replay transition | timestamp dependency, cross-interpretation witness conflict or upgrade reset |
| 22 | implement User Host and Coordinator whole-page validators | 4, 11, 16–21 | strict contracts, fixed page progress and hostile corpus | one invalid/mixed page partially accepted or row cursor trusted |
| 23 | implement one-writer atomic page transaction and stable ACK result | 12, 21–22 | effect/no-event/outbox/witness/page/checkpoint transaction | accepted as implementation only; no durability claim until G5 failpoints |
| 24 | implement finite health/metrics and privacy-safe local support CLI | 4, 10–23 | fixed descriptor schema, cardinality lint, opaque source token | dynamic/sensitive label, exception detail or raw support field |
| 25 | implement source/capability/global kill and SafetyHold paths | 11, 20–24 | cancel/discard outstanding page, higher-revision recovery hook | disabled/stale work can commit or endpoint self-reenables |
| 26 | prepare placeholder-only disconnected Windows lab scripts | 1–25 | inventory, install, fixture, trace, session, impact, failure and cleanup scripts | any connection material, credential, real identity/value or mutating preflight |
| 27 | obtain human-approved lab support matrix | HD-03/04/13/19 | named Edge/Windows/profile/native/session capabilities | unknown environment described as supported |
| 28 | execute read-only inventory and confirm exact G1 evidence | 26–27 | sanitized environment/native/Edge/G1 binding | mismatch, expired G1 or unsupported capability |
| 29 | execute G2 direct/backup/impact/cancel/cleanup campaigns | 17–20, 23–28 | immutable G2 evidence bundle | any primary G2 failure stops all live G3/G4 work |
| 30 | review/freeze G2 source-safety adapter profile | 29 | accepted/rejected ADR update and exact capability digest | no G3 live or G4 source-chain claim after failed G2 |
| 31 | execute G3 discovery/session/cursor/generation/lineage campaigns | 20–25, passed 30 | immutable G3 evidence bundle | recall miss/extra/mix/duplicate/false generation/non-success advance |
| 32 | execute G4 ASCII profile/matcher/policy/all-sink/incident campaigns | 14–25, passed G1; source-chain lane after passed 30/31 | immutable G4 evidence bundle | raw/derivative escape, guessed ambiguity, cross-realm result, broadening or scanner miss |
| 33 | run optional Unicode IDNA candidate lane | 14, source-free T1 first | conformance/admission evidence or explicit disabled result | no production enablement on partial profile or unclassified difference |
| 34 | run exact Edge candidate compatibility lane | 27–32 | per-build signed fixture/source-capability evidence | version number alone activates support or incompatible schema emits |
| 35 | execute G5 whole-page failpoints and restart/retry proof | 23, frozen G2/G3/G4 page contract | atomic durability/ACK evidence | cursor ahead, effect loss/double, changed UUID or partial page |
| 36 | execute dependency/SBOM/provenance and clean rebuild gates | 6–35 plus Batch 01 release controls | exact file/dependency/provenance reconciliation | unmapped component, unexplained build difference or mutable input |
| 37 | exercise incident and support runbooks | 24–36 | kill, hold, recovery, support and cleanup receipts | work continues, raw support artifact, self-reenable or incomplete cleanup |
| 38 | aggregate `batch-02-gate.json` and architecture review | 1–37 | exact evidence/ADR/owner/human-disable index | any failed/missing/expired/waived primary invariant |
| 39 | update main technical baseline for accepted refinements only | passed 38 and forum approval | baseline patch distinguishing invariant/provisional/human decision | silent adjacent redesign or provisional value hardened as timeless |
| 40 | permit production-shaped synthetic outbox integration | passed 38–39 and G5 | synthetic minimized events only | real source/value, production credential or pilot authority appears |
| 41 | proceed to later release/network/server/capacity/deletion gates | accepted global order | later evidence | no pilot/production before every applicable gate and human decision |

## 10.2 Parallelism rules

The following may proceed in parallel after the contracts/lineage model exists:

- T1 Edge fixtures/oracle/canaries;
- native SQLite admission spike;
- synthetic root/source-generation models;
- ASCII URL golden/reference/matcher/policy work;
- endpoint schema and G5 failpoint scaffolding;
- disconnected lab script preparation.

The following may not be pulled forward:

- any live source open before exact G1 pass and source-write instrumentation;
- G3 live profile/session claims before G2 passes the exact capability;
- a raw URL through the process chain before the Task Host privacy transform/all-sink harness exists;
- production outbox integration before G2/G3 and G4 pass;
- durability claims before G5 failpoints;
- Unicode, PSL, disk scratch, custom roots, path/process matching, session attribution or semantic replay as informal side spikes—each needs its named ADR/authority;
- pilot/production before human purpose/source/field/identity/retention/access/support/risk decisions and all later gates.

## 10.3 Exact stop/go sequence

1. **GO** for pure contracts/models, T1 fixtures, reference evaluators, ASCII URL profile, native API spike and disconnected scripts.
2. **STOP** before live Edge source access until exact G1 hostile evidence passes for the intended lab capability.
3. **GO to G2** only in an approved disposable VM with synthetic Edge profiles and loopback activity.
4. **STOP G2** on one source write, incomplete backup acceptance, attributable browser corruption/crash, raw escape, unbounded impact, non-success advance or cleanup residue.
5. **GO to G3 live** only after G2 passes the exact Edge/OS/native capability.
6. **STOP G3** on one controlled recall miss/extra, profile/session/realm mix, duplicate effect, timestamp cursor, false generation, observable replacement in old generation or conflict acceptance.
7. **GO to G4 full-chain** only after G1, and use live synthetic source bytes only after G2/G3 pass; pure G4 can run earlier on T1 strings.
8. **STOP G4** on one forbidden value/derivative sink, scanner miss, unclassified semantic difference, guessed ambiguity, cross-realm result, tenant broadening or invalid page partial acceptance.
9. **GO to G5 handoff** after the page contract is frozen by G2/G3/G4 review.
10. **STOP G5** on cursor-ahead, lost/double effect, changed event identity, partial page or ACK-before-commit.
11. **GO to production-shaped synthetic outbox** only after the immutable Batch 02 gate and baseline update.
12. **STOP before real source/pilot/production** until human decisions and all later proof gates pass. There is no implicit risk acceptance in code or configuration.

---
# 11. Source and open-source quality corrections

## 11.1 Corrections to the supplied results

| Supplied result | Strong contribution retained | Required correction |
|---|---|---|
| G2/G3 Edge acquisition/cursor | strongest bounded discovery, direct/backup/defer, handle continuity, native-ID cursor, source-write and Windows fixture plan | split source schema/runtime/interpretation from generation; remove extractor version from natural identity; page-level progress; remove locator from page; DONE+finish and destination page-size rule; Chromium is upstream reference, not exact Edge contract |
| G4 URL/privacy | strongest raw Task Host boundary, strict finite matcher, ambiguity, no derivative, canary/all-sink and policy-monotonic design | ASCII-first; exact .NET IDNA profile not proved; PSL deferred; discarded-component behavior versioned; app-only is T1 test profile; exact one-million count provisional; progress moved from row to page |
| Batch 01 predecessor | correct contracts, process boundary, privacy lattice, application identity, repository and evidence gates | preserve; do not reopen literal G1/contract questions except through predecessor ADR/evidence |
| Accepted baseline/gates | correct invariants and direct-read/backup/defer choice | preserve G1→G2→G3→G4→G5 order and site/domain functional slice |

## 11.2 Time-sensitive primary-source verification

| Ref | Verified source, date/version reviewed | Supported conclusion | Limitation/correction |
|---|---|---|---|
| W01 | Microsoft, [Edge Stable and Extended Stable release notes](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-relnote-stable-channel), updated 27 July 2026 | point-in-time latest reviewed Stable was `150.0.4078.105`, dated 27 July 2026 | not a UAM support decision or source-schema promise; progressive rollout and later updates require recapture |
| W02 | Microsoft, [`UserDataDir` policy](https://learn.microsoft.com/en-us/deployedge/microsoft-edge-policies/userdatadir), updated 22 May 2026 | mandatory policy overrides `--user-data-dir`; without policy, command-line override is possible; policy requires browser restart | does not prove estate configuration or safe UAM discovery |
| W03 | Microsoft, [Edge user-data directory variables](https://learn.microsoft.com/en-us/deployedge/edge-learnmore-create-user-directory-vars), reviewed 31 July 2026 | absolute-path guidance; network paths unsupported; `${client_name}`/`${session_name}` distinguish remote sessions | documentation is capability/configuration evidence, not UAM root fitness |
| W04 | Microsoft, [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), updated 14 July 2026 | .NET 10 LTS active; latest listed patch `10.0.10` dated 14 July 2026; support through 14 November 2028 | point-in-time lifecycle input; exact patch is not timeless architecture and must remain current |
| W05 | SQLite, [WAL documentation](https://sqlite.org/wal.html), last updated 13 April 2026 | WAL readers/writers can coexist; readonly WAL has prerequisites; network FS unsupported; BUSY can occur; last-close checkpoint/WAL cleanup matters; WAL-reset bug history | general engine behavior, not selected binary/provider/UAM proof |
| W06 | SQLite, [Online Backup API](https://sqlite.org/c3ref/backup_finish.html), reviewed 31 July 2026 | `SQLITE_DONE` marks completed transfer; BUSY/LOCKED may retry; source changes restart; in-memory page-size mismatch can return READONLY; finish OK does not alone prove completion | exact runtime/resource/browser impact remains CLI evidence |
| W07 | SQLite, [database-connection configuration options](https://sqlite.org/c3ref/c_dbconfig_defensive.html), reviewed 31 July 2026 | defensive/trusted-schema/checkpoint/attach and related controls exist in versioned APIs | exact availability/default/effective value depends on admitted native build |
| W08 | SQLite, [standard file-control opcodes](https://sqlite.org/c3ref/c_fcntl_begin_atomic_write.html), reviewed 31 July 2026 | moved-file and Windows-handle controls exist for applicable VFS/builds | wrapper/native/OS support and UAM race fitness require experiments |
| W09 | SQLite, [URI filenames](https://sqlite.org/uri.html), reviewed 31 July 2026 | `immutable` suppresses locking/change detection and assumes no change; `nolock` is unsafe with concurrent access | supports rejection on live Edge source |
| W10 | SQLite, [release history](https://sqlite.org/changes.html), release `3.53.4` dated 24 July 2026, source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | exact current reviewed release/source ID and recent WAL-reset fix history show why loaded source identity matters | package version does not prove loaded native binary; future releases must be re-reviewed |
| W11 | Microsoft, [`FILE_ID_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-file_id_info), reviewed 31 July 2026 | volume serial plus 128-bit identifier identifies the file represented by an open handle on a computer | not an eternal globally unique lineage; reuse/residual ambiguity remains |
| W12 | Chromium source, [`visit_database.cc`](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/components/history/core/browser/visit_database.cc), current source reviewed 31 July 2026 | current upstream `visits.id` uses integer primary-key/autoincrement semantics | moving upstream source; exact Edge behavior needs pinned source snapshot and signed Edge fixtures |
| W13 | Chromium source, [`history_types.h`](https://chromium.googlesource.com/chromium/src/+/master/components/history/core/browser/history_types.h), current source reviewed 31 July 2026 | local visit IDs can be higher while visit time is older because of sync; ID is local | internal implementation, not stable Edge public API; branch reference must be pinned at execution |
| W14 | Chromium source, [`base/time/time.h`](https://chromium.googlesource.com/chromium/src/+/HEAD/base/time/time.h), current source reviewed 31 July 2026 | Chromium `base::Time` is UTC microseconds from Windows epoch and wall-clock time can jump/skew | does not decide UAM output precision/validity or source completeness |
| W15 | Microsoft, [.NET ICU globalization change](https://learn.microsoft.com/en-us/dotnet/core/compatibility/globalization/5.0/icu-globalization-api), updated 13 March 2026 | .NET 5+ uses ICU by default on supported Windows and may fall back to NLS; `IdnMapping` behavior differs | runtime mode/data must be captured; API documentation does not prove UAM IDNA profile |
| W16 | .NET runtime `v10.0.10`, [`IdnMapping.Icu.cs`](https://github.com/dotnet/runtime/blob/8f030f80c0dd2722eb2f618984e9db6784765963/src/libraries/System.Private.CoreLib/src/System/Globalization/IdnMapping.Icu.cs) and [`pal_idna.c`](https://github.com/dotnet/runtime/blob/8f030f80c0dd2722eb2f618984e9db6784765963/src/native/libs/System.Globalization.Native/pal_idna.c), commit `8f030f80c0dd2722eb2f618984e9db6784765963` | exact public options and ICU flags in the reviewed source: ContextJ and non-transitional processing, optional STD3; no `UIDNA_CHECK_BIDI` in that path; hyphen-3/4 error masked for Windows consistency | supports deferring a stronger claimed UTS #46 profile; installed bits still need evidence |
| W17 | Unicode Consortium, [UTS #46 Revision 35](https://www.unicode.org/reports/tr46/tr46-35.html), Unicode 17.0.0, 4 September 2025 | non-transitional processing is current; validation options and conformance data are explicit | a Unicode implementation/profile must be established; conformance does not resolve visual sensitivity or field approval |
| W18 | WHATWG, [URL Standard](https://url.spec.whatwg.org/), current snapshot reviewed 31 July 2026 | browser URL processing deliberately includes interoperability recovery and legacy host/IP behavior useful for differential tests | browser behavior is not UAM privacy-boundary authority |
| W19 | Public Suffix List project, [project site](https://publicsuffix.org/) and exact supplied-result commit `e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20` | PSL is maintained community suffix-boundary data with ICANN/PRIVATE sections | not ownership, sensitivity, public reachability, application identity or collection authority; license/semantics human decisions |

## 11.3 Source-quality conclusions

1. **FACT.** Official SQLite documentation is the authority for API behavior; upstream Chromium source is implementation evidence for schema/ID/time semantics; exact signed Edge fixtures are the UAM compatibility gate.
2. **FACT.** Microsoft Edge release notes and policy documentation establish point-in-time product/configuration facts, not support for reading internal history databases.
3. **FACT.** .NET and Unicode sources show that “uses UTS #46” is not enough to claim a particular combination of Bidi, Joiner, hyphen, STD3 and data-version behavior. The exact implementation must be tested.
4. **RECOMMENDATION.** Every implementation evidence package records immutable source snapshots or commit IDs. Mutable `HEAD`, current branch and “latest” URLs may appear only as discovery links, not as the sole reproducibility anchor.
5. **RECOMMENDATION.** Search snippets, product marketing, popularity and synthetic performance alone are rejected as proof.

## 11.4 Consolidated open-source audit

**Decision rule.** No open-source repository, package, native binary, test corpus or data file is admitted by this review alone. Admission requires exact source/package/binary mapping, stable tag/commit, license/notice approval, maintenance and security evidence, tests, UAM-specific fit/resource/canary evidence, owner, SBOM/provenance and removal path. “Reference only” authorizes no endpoint/runtime dependency or source copying.

### 11.4.1 Runtime and build candidates after an admission experiment

| Project/revision reviewed | License | Maintenance/test/security/fit assessment | Classification/correction |
|---|---|---|---|
| [.NET runtime `v10.0.10`](https://github.com/dotnet/runtime/tree/8f030f80c0dd2722eb2f618984e9db6784765963), commit `8f030f80c0dd2722eb2f618984e9db6784765963` | MIT plus component notices | active supported platform with extensive tests/security process; parser/globalization behavior can change by patch/ICU/NLS | **inherent runtime candidate** under accepted .NET family; exact installed files and semantic regression gate mandatory; not URL/IDNA authority |
| [SQLite `3.53.4`](https://sqlite.org/changes.html), source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc` | core public domain; ancillary assets vary | official active engine with public tests/fuzz; recent WAL bug demonstrates patch importance | **native runtime candidate** only as exact admitted binary/compile profile; public docs are normative API reference |
| [Microsoft.Data.Sqlite.Core `v10.0.10`](https://github.com/dotnet/efcore/tree/v10.0.10/src/Microsoft.Data.Sqlite.Core), supplied-result release commit `db55508` | MIT; native provider separate | maintained/tested managed query layer; does not include native SQLite and may not expose all low-level controls | **managed-layer candidate after spike**; no EF ORM/migrations; insufficient alone |
| [SQLitePCLRaw.core `3.0.5`](https://github.com/ericsink/SQLitePCL.raw), supplied-result repository point `ed04611` | Apache-2.0; native bundles/support vary | useful low-level API, active maintainer/tests; exact package-to-full-source/native mapping not established | **NO-GO now**; may become runtime candidate only after exact package/source/binary mapping, API and security tests |
| [Public Suffix List exact commit](https://github.com/publicsuffix/list/tree/e1b8015c3b2f0f4f8c18659c2480fc1a22c07b20) | MPL-2.0 | active governed data and tests; semantics can change and are not business truth | **data candidate only if needed**, after human semantics/license decision, exact pin, dual parser/lint and no-network gate; absent initially |

### 11.4.2 Test-only candidates

| Project/revision reviewed | License | Assessment | Classification |
|---|---|---|---|
| [Selenium `4.46.0`](https://github.com/SeleniumHQ/selenium/tree/selenium-4.46.0), supplied-result commit `df5a634`, 11 July 2026 | Apache-2.0; EdgeDriver terms/provenance separate | active tests/security fixes; good C# loopback fixture/timing fit; automation alters browser behavior | **pinned offline test candidate**; disable manager downloads/telemetry/Grid/BiDi/CDP; exact matching driver |
| [Playwright `1.62.1`](https://github.com/microsoft/playwright/tree/v1.62.1), supplied-result commit `26a9e47`, 30 July 2026 | Apache-2.0 plus Node/browser package surface | strong fixtures/traces and active tests; heavier supply chain and rapid churn | **test-only alternative**; choose Selenium or Playwright by bake-off, not both by default; no bundled browser download in evidence lane |
| [WPT URL tests](https://github.com/web-platform-tests/wpt/tree/181476aa16e8b28a07698bef3a0275fa53dd22e5/url), commit `181476aa16e8b28a07698bef3a0275fa53dd22e5` | BSD-3-Clause contributions | broad browser corpus; lacks UAM privacy/realm/resource semantics | **pinned reference/test-data candidate**, selected subset with notices and UAM expected classifications; never sole oracle |

### 11.4.3 Reference only — not endpoint/runtime dependencies

| Project/revision reviewed | License/posture | Useful evidence | UAM-fit decision |
|---|---|---|---|
| Chromium source tag `150.0.7871.187`, root commit `30f6543ae91e6a860e73b76e3216b663b050f4e5` from I01 | BSD-style root plus extensive third-party notices; massive active test/security estate | history schema, local IDs, sync/time and profile concepts | **reference only**. Tag is Chrome/Chromium, not an exact Microsoft Edge source contract; no runtime/code reuse assumption |
| [WHATWG URL commit `9dc3827...`](https://github.com/whatwg/url/tree/9dc3827fc722ac4af3f11061aa3e9adb44a17c8b) | specification CC BY 4.0; code portions BSD-3-Clause; living standard | browser parser terminology/recovery and differential behavior | **normative external reference only**; UAM profile separately pinned/versioned and intentionally stricter |
| [Ada `v4.0.0`](https://github.com/ada-url/ada/tree/b12a893a45809da8103bb4f1e2f6f5ee13f9100b), commit `b12a893a45809da8103bb4f1e2f6f5ee13f9100b` | Apache-2.0/MIT; tests/fuzz/security policy; native ABI cost | independent URL/IDNA/IP/bounds differential runner | **high-value reference runner; native dependency rejected initially**. New ABI/installer/support ADR only if .NET candidate fails |
| [Rust URL `v2.5.7`](https://github.com/servo/rust-url/tree/43f47e2fcfdd132c531fb05aa16171ca85be95f4), commit `43f47e2fcfdd132c531fb05aa16171ca85be95f4` | Apache-2.0/MIT; mature tests/security policy; Rust/FFI cost | independent parser/IDNA runner reduces common-mode defects | **reference runner only**, exact container/build admission required; no runtime dependency need |
| [TRowbotham/idna `v0.3.0`](https://github.com/TRowbotham/idna/tree/504900acc8e465a17668a61ae30391d1aebbb4f2), commit `504900acc8e465a17668a61ae30391d1aebbb4f2` | MIT; focused tests/resources; no reviewed dedicated security policy; PHP runtime mismatch | optional independent Unicode 17/UTS #46 vector challenger | **reference only**; official Unicode conformance data remains primary |
| [browser-history `v0.5.0`](https://github.com/browser-history/browser-history/tree/v0.5.0), commit `943dd5e` | Apache-2.0; maintained tests, broad crawler/raw output model | profile/fixture edge cases | **reference only**; broad crawl and raw URL/title export conflict with UAM |
| [Hindsight `v2026.06`](https://github.com/RyanDFIR/hindsight/tree/v2026.06), commit `25bfb16` | Apache-2.0; active forensic parser/plugins | synthetic schema-change/differential ideas | **reference only**; deleted-artifact recovery/enrichment is opposite UAM minimization; never oracle/runtime |
| [Cedar `v4.12.0`](https://github.com/cedar-policy/cedar/tree/fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5), commit `fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5` | Apache-2.0 plus notices; active tests/security/symbolic tools | schema, deny, counterexample and policy-test patterns | **reference only; endpoint runtime rejected**. General executable policy weakens finite monotonic proof and expands authority |

### 11.4.4 No-go as reviewed

| Candidate | Reason for no-go | Reconsideration condition |
|---|---|---|
| [Nager.PublicSuffix `3.8.0`](https://www.nuget.org/packages/Nager.PublicSuffix/3.8.0), reviewed repo commit `33ff36876529dddcd00916ad5dcb3f32a8a60926` | exact package-to-source mapping absent; HTTP/hot-reload providers conflict with immutable offline endpoint; security/fuzz/resource evidence insufficient | exact mapping, license/security admission, offline-only feature exclusion, malformed/resource comparison and actual need for PSL |
| SQLitePCLRaw `3.0.5` as an automatic accepted dependency | exact package/native mapping unresolved; broad raw API; bundled native identity may differ | section 7 admission evidence and loaded source ID/compile options pass |
| Ada/Rust URL as embedded runtime | no demonstrated need; native/FFI/toolchain/installer/signing/crash/SBOM/support surface | .NET/ASCII candidate fails a required use case and a new ADR proves lower total risk |
| General policy engines, regex/glob/browser-filter grammars | unnecessary executable authority, overlap/monotonic/resource complexity | a finite new matcher requirement that cannot be represented now, with formal/static proof and explicit baseline change—not a general engine |
| browser-history/Hindsight as endpoint collectors | broad profile crawl/raw/deleted artifact goals conflict with fixed source/minimization | no expected reconsideration for this slice; differential fixtures only |

## 11.5 Open-source correction summary

- Exact tags/commits in supplied results are useful point-in-time evidence, not automatic dependencies.
- A package version without source and loaded-native mapping is no-go even when the repository is reputable.
- Test/reference runners execute only in sealed T1 lanes and cannot define UAM expected privacy outcomes by themselves.
- Choose one browser automation stack and one production SQLite integration; duplicated stacks enlarge evidence and support cost.
- No endpoint PSL parser/data is needed for exact/suffix matching. Avoid admitting one before the human field semantics exist.
- Runtime URL/IDNA behavior is part of `interpretation_id` evidence, not source generation or native identity.

---
# 12. Confidence by major conclusion and evidence that could change it

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| G2/G3 and G4 share a compatible Task Host privacy boundary | **High** | both keep user-owned read in session and require minimized output before IPC; aligns directly with predecessor invariants | a CLI result showing safe acquisition cannot coexist with pre-IPC minimization under the supported estate |
| Bounded default/mandatory-policy local-root discovery is the smallest safe first scope | **High** | official Edge policy/path guidance plus accepted no-crawl boundary | approved estate evidence that another root type is necessary and passes equal identity/locking/privacy gates |
| `Local State` should be only a hint plus bounded direct-child validation | **High** | internal metadata can be absent/corrupt/sensitive; handle-based candidate checks are stronger | an official stable Edge profile enumeration API with narrower authority and equivalent fixtures |
| Direct read-only, eligible Online Backup to memory, then defer is the right acquisition direction | **High** | accepted predecessor and official SQLite concurrency/backup behavior | source-write/impact/recall failure in a claimed environment or a stronger supported browser API |
| Exact SQLite security settings remain adapter/version evidence | **High** | APIs/defaults/builds evolve; outcomes are stable but literal opcodes are not | a stable supported wrapper profile that proves all outcomes across the support matrix and is adopted by ADR |
| Online Backup requires observed DONE plus finish OK | **High** | explicit SQLite API semantics | a future SQLite contract change, reviewed and versioned, that provides another authoritative completion signal |
| Zero source write is a non-waivable G2 gate | **High** | direct accepted invariant and browser integrity requirement | no evidence should weaken it; only a baseline change proposal replacing the source mechanism entirely |
| Source, source generation, source schema capability, collector runtime and interpretation must be separate | **High** | prevents false lineage resets and duplicate/reinterpreted effects; supported by distinct evidence domains | a formal model/implementation showing a simpler identity preserves every continuity, rollout and one-effect invariant |
| Native `visits.id` is the correct cursor for the current supported source capability | **High for reviewed Chromium semantics; Medium across future Edge builds** | upstream schema/late-sync behavior makes timestamp progress incorrect | a supported Edge capability without equivalent native monotonic local ID, requiring a new source contract/ADR |
| Bounded overlap detects only recent same-interpretation conflicts | **High** | raw/hash retention is forbidden and a finite overlap cannot prove old immutability | an approved privacy-preserving source witness that is non-linkable/non-reversible and demonstrably useful |
| Natural record identity must exclude extractor/interpretation versions | **High** | one browser record should not become a new record on software/policy upgrade | an approved correction/event-sourcing model that explicitly supersedes effects without duplicate business meaning |
| Whole-page progress is safer than row-level cursor fields | **High** | single transaction/page validation prevents partial effect/progress disagreement | a formally verified row-stream protocol preserving the same atomicity and lower operational risk |
| Raw URL must remain inside fixed Task Host and no reversible derivative may leave | **High** | direct baseline privacy invariant and smallest trust boundary | no ordinary evidence should weaken it; a stronger isolation topology could only preserve or narrow the boundary |
| ASCII-only is the correct initial production-capable URL profile | **Medium-High** | .NET/ICU/NLS and desired UTS #46 profile are not equivalent by documentation; ASCII satisfies first implementation safety | exact IDNA implementation conformance, runtime/data lifecycle, all-sink evidence and human Unicode-support decision |
| Strict authority/host handling is safer than browser recovery | **High** | browser standards deliberately recover inputs for interoperability; UAM is a privacy/matching boundary | corpus evidence that a strict rule creates unavoidable unsafe misclassification and a narrower alternative preserves invariants |
| Discarded-component syntax details should be versioned, not over-hardened as timeless architecture | **Medium-High** | path/query/fragment cannot affect output; global malformed-percent rejection is not load-bearing | a demonstrated parser-smuggling or privacy bypass requiring a specific permanent lexical prohibition |
| PSL is unnecessary for exact/suffix host matching | **High** | label-boundary matching is independent of registrable-domain derivation | a human-approved output/deny requirement that explicitly needs PSL; it still remains non-authoritative and pinned |
| Deterministic ambiguity is required | **High** | prevents hidden rule order from becoming attribution authority | a new finite grammar with a proved total specificity relation and equal privacy/security behavior |
| Site/domain output remains human-blocked and app-only cannot silently replace it | **High** | accepted baseline explicitly names site/domain functional slice; fields/purpose remain human decisions | an explicit accepted-baseline change proposal with business/privacy impact and migration plan |
| Permanent no-event progress must be interpretation-bound | **High** | future semantics can change; progress is safe only under the exact active mapping | a source-level invariant proving the input can never become an event under any future approved interpretation |
| Current/previous Edge support is not an architectural promise | **High** | no fleet/offline/support evidence or owner commitment exists | human support decision plus recurring exact build evidence and rollback/support runbook |
| Test counts and performance limits remain provisional | **High** | no representative distribution or SLO/budget exists; counts are hypotheses | measured fault-detection/resource evidence and accountable owner approval |
| Open-source references reduce common-mode error but are not runtime authority | **High** | threat models differ and package/source/binary/license mapping is separate | an admission ADR proving a selected dependency lowers total risk and passes UAM-specific evidence |
| Batch 02 is not live-source, pilot or production approval | **High** | prompt, predecessor and unresolved human/later-gate boundaries are explicit | only designated authorities plus all applicable technical proof gates can change status |

## 12.1 Evidence that would force an explicit baseline change proposal

The following findings would conflict with an accepted decision and therefore require the full change-proposal form from I03/I04 rather than a local implementation workaround:

- a supported environment cannot read the approved Edge source safely without Coordinator profile access, source write, new privilege or another process topology;
- raw URL must cross Task Host IPC for the approved purpose;
- direct read/Online Backup/defer cannot meet controlled fixture recall and browser-integrity gates, and another source mechanism is proposed;
- a shared profile must provide visit-origin session attribution that the database cannot prove;
- the functional slice is changed from site/domain-level output to application-only or another source/value;
- disk scratch, VSS, browser extension, DevTools/CDP, arbitrary roots or another privileged source boundary is proposed;
- source generation must intentionally include processing versions or historical rows must automatically replay;
- one natural source record must create multiple ordinary business effects outside an explicit correction/supersession model.

A change proposal must name the affected decision, new primary evidence, security/privacy/durability/realm impact, alternatives, smallest falsifying CLI experiment, migration consequence, rollback and ADR action.

## 12.2 Exact conditions for updating the main technical baseline

This batch may update the main technical baseline only when all of the following are true:

1. the architecture forum accepts ADR-B02-001 through ADR-B02-020 for their stated scope;
2. all blocking owner functions in section 6 are assigned;
3. the immutable predecessor gate proves G1 for every environment claimed by Batch 02;
4. E-B02-02 through E-B02-08 pass for the exact source tree/tool/native inputs;
5. E-B02-09 through E-B02-12 pass G2 for every claimed Edge/Windows/native capability with zero source write, incomplete backup acceptance, attributable corruption/crash, raw escape, non-success advance and cleanup residue;
6. E-B02-13 through E-B02-17 pass G3 with exact controlled recall, source/session/realm isolation, correct source/generation lineage and version-independent natural identity;
7. E-B02-18, E-B02-20 through E-B02-22 and E-B02-24 pass G4/page/rollout for the ASCII profile with zero forbidden escape, guessed ambiguity, cross-realm result, tenant broadening, scanner miss, mixed interpretation or partial page acceptance;
8. Unicode IDN and PSL remain technically disabled unless their separate E-B02-19/data/license/human gates pass;
9. E-B02-23 proves the G5 page crash invariant and stable ACK/event identity;
10. E-B02-25 proves exact dependency/native/SBOM/provenance mapping and release evidence;
11. E-B02-26 emits immutable `batch-02-gate.json` binding the exact inputs, source tree, contracts, runtime/native/Edge capability, fixtures, ADRs, owners, evidence, scanner and cleanup receipts with no failed, missing, expired or silently waived primary invariant;
12. the baseline patch adds only the accepted refinements and clearly labels every exact limit, runtime/package, IDNA/PSL option, supported estate, output field and human decision as provisional or blocked where applicable.

The baseline update may then add:

- bounded User Host Edge discovery from release-owned local roots;
- the direct-read/eligible-memory-backup/defer acquisition contract;
- UAM source/generation identity and native-ID cursor;
- separate source capability/runtime/interpretation provenance;
- raw URL confined to fixed Task Host;
- ASCII exact/suffix host matching and deterministic ambiguity;
- one whole-page minimized-effect/no-event/progress contract;
- version-independent native natural identity and stable UUIDv7 event persistence;
- the Batch 02 zero-write, containment, realm and page stop gates.

It must keep live sources, exact fields/site/time/identity, lookback, hard-deny content, retention/access, Unicode IDN, PSL, non-default ports, disk scratch, extended estate, numeric budgets, semantic replay/correction, support commitments, pilot and production approval explicitly provisional or disabled.

## 12.3 Unresolved risks and blocked dependencies

**UNKNOWN.** At review close, the batch remains blocked by:

- absent runtime evidence that G1 passes the exact intended Windows/Edge lab capability;
- no G2 source-write, backup-completion, impact or cleanup measurements;
- no G3 controlled recall, same-SID session, replacement/regression or natural-identity evidence;
- no G4 golden/matcher/all-sink/realm/monotonic/incident evidence for the exact build;
- no G5 implementation/failpoint proof for the unified page transaction;
- no admitted native SQLite/provider stack or exact recurring Edge compatibility lane;
- unresolved purpose, fields, site/domain mode, time, identity, lookback, deny categories, supported estate, retention/access, diagnostics, staffing, budget, SLO/RPO/RTO and production decisions;
- no production signing/control/release or support authority.

**Residual risk after a technical pass** will still include browser internal-API drift, same-user races, eventual file-ID reuse, unobservable deletion before collection, old-row mutation beyond overlap, absent origin-session attribution for shared profiles, managed-memory/pagefile/EDR capture, incomplete hard-deny coverage, fail-closed data gaps, dependency defects and operator error. Those risks must be documented, monitored and governed; a passing synthetic gate does not erase them.

## 12.4 Final stop rule

**Non-waivable stop condition:** any forbidden source value or reversible derivative crossing the Task Host privacy boundary; any UAM source mutation; any cross-profile, cross-session-authority or cross-realm mix; any incomplete backup accepted; any observable source discontinuity retained in the old generation; any processing upgrade changing native natural identity or silently replaying history; any guessed application ambiguity; any tenant broadening; any page partially committed; any cursor ahead of its durable effect/no-event fact; any retry producing more than one final business effect; any unauthorized/stale/downgraded release execution; any silent loss of unacknowledged data; or any cleanup residue stops dependent work and requires the named ADR/change review.

There is no silent risk acceptance in code, configuration, test exceptions or support practice.

---

# Appendix A. Batch 02 evidence envelope

```json
{
  "schemaVersion": "1.0.0",
  "experimentId": "E-B02-00",
  "claim": "one falsifiable sentence",
  "classification": "T1",
  "startedAtUtc": "<RFC3339-Z>",
  "endedAtUtc": "<RFC3339-Z>",
  "sourceTreeSha256": "<digest>",
  "contracts": [{"id":"<id>","sha256":"<digest>"}],
  "runtime": {
    "dotnetSdk": "<exact>",
    "dotnetRuntime": "<exact>",
    "osBuildClass": "<sanitized>",
    "architecture": "<exact>",
    "runnerImageDigest": "<digest>",
    "sqliteBinarySha256": "<digest>",
    "sqliteSourceId": "<exact>",
    "sqliteCompileOptionsDigest": "<digest>",
    "edgeExecutableVersion": "<exact when applicable>",
    "edgeExecutableSha256": "<digest when applicable>"
  },
  "inputs": [{"id":"<T1 package>","rootSha256":"<digest>"}],
  "commands": [{"argvRedacted":"<placeholder-only command>","exitCode":0}],
  "artifacts": [{"relativePath":"<safe path>","sha256":"<digest>","classification":"T1"}],
  "assertions": [{"id":"<id>","result":"PASS"}],
  "canaryScan": {
    "scannerDigest":"<digest>",
    "positiveControlsPassed":true,
    "escapes":0
  },
  "cleanup": {"result":"PASS","receiptSha256":"<digest>"},
  "ownerFunction":"<assigned function>",
  "reviewerFunction":"<independent function>",
  "exceptions": []
}
```

# Appendix B. Baseline-change proposal template

```markdown
# Change proposal — <title>

Affected accepted decision/invariants:
New primary evidence and reviewed dates/versions:
Problem in the accepted design:
Alternatives and why they fail:
Proposed change:
Security/privacy/realm/durability impact:
Smallest falsifying CLI experiment:
Pass/fail and stop behavior:
Migration and compatibility consequence:
Rollback and cleanup:
Human decisions required:
ADR actions:
```

# Final residual risk, blocked dependencies and baseline-update condition

**Residual risk.** Edge history remains a fallible, mutable internal source. Even after synthetic proof, UAM cannot guarantee observation of rows deleted before collection, detect every old mutation beyond a bounded same-interpretation overlap, attribute visits to one simultaneous session sharing a profile, erase every raw byte from operating-system or security-agent memory paths, classify every sensitive public domain, or prevent all future browser/runtime/dependency defects. The containment strategy is to collect less, fail closed, keep raw values inside one fixed process, preserve source lineage, make progress atomic, expose coverage states honestly, and require recurring exact-version evidence.

**Blocked dependencies.** Live-source work is blocked by exact G1 evidence, named support owners/matrix and approved disposable lab. Production-shaped endpoint data is additionally blocked by G2/G3/G4 and G5 evidence, admitted native/runtime dependencies, approved site/time/identity/lookback/deny/retention/access semantics, signed control/release authority, incident/support readiness, budget/SLO decisions and designated production risk approval.

**Exact baseline-update condition.** The main technical baseline may be updated only after ADR acceptance, owner assignment, exact G1 coverage, successful G2/G3/G4/page/G5/dependency experiments with zero primary invariant failures, complete cleanup, and an immutable `batch-02-gate.json` binding the reviewed evidence. The update may contain only the accepted refinements listed in section 12.2 and must preserve all disabled/provisional/human-owned matters explicitly.
