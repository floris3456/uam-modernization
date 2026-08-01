# Batch 04 review result — server ingestion, database, capacity, and data lifecycle

**Result path:** `results/batch-04-server-platform/batch-04-review-result.md`  
**Review date:** 1 August 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — IMPLEMENTATION PROTOTYPES MAY PROCEED; ALL BATCH 04 PROOF GATES REMAIN OPEN; PRODUCTION ENDPOINT DELETION AFTER ACK IS PROHIBITED**  
**Authority boundary:** reconciliation of server ingestion, relational custody, database comparison, capacity simulation, retention, deletion, backup, restore, exports, and integration lifecycle; **not** legal purpose, lawful basis, prohibited uses, identity level, rights outcomes, retention periods, access, employee consultation, budget, licensing approval, staffing, support commitment, SLO/RPO/RTO, database selection, broker adoption, pilot, production risk acceptance, or deployment approval  
**Predecessors:** accepted Batch 01, Batch 02, and Batch 03 review results  
**Primary batch gate:** **A durable receipt and one-effect idempotency must pass before any endpoint cleanup after ACK is even eligible for consideration. Database, capacity, retention, RPO/RTO, broker, and production cleanup decisions remain measurement- and human-gated.**

## Evidence vocabulary

This review uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, restore, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed consolidated Batch 04 implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 0. Evidence boundary, file-presence record, and review method

## 0.1 Allowlisted project evidence

**FACT.** All ten allowlisted Project files were present. No missing-file substitution was needed. The four topic results were supplied locally with a `(1)` suffix and the Batch 01 predecessor with a `(3)` suffix; their titles and declared result paths identify the allowlisted logical filenames. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Role and limitation |
|---|---|---|---|---|
| I01 | `15-ingestion-relational-inbox-result.md` | `15-ingestion-relational-inbox-result(1).md` | `f9138ddc9971b7a829c665c55475a9fa034ba579c7ff39b30ee1d97787fad94a` | Ingestion API, durable relational custody, leases, whole-batch materialization, quarantine, reconciliation, and broker break-even proposal; architecture recommendation, not executed proof or production approval. |
| I02 | `16-database-comparison-experiment-result.md` | `16-database-comparison-experiment-result(1).md` | `ff84e40e5096d82129feaf6d8f595598bd59647d60763b47b5030fb49b0faa8d` | Engine-neutral PostgreSQL/SQL Server experiment, portable schema, restore/failover/operations/TCO gates; no production engine selected. |
| I03 | `17-capacity-fleet-simulator-result.md` | `17-capacity-fleet-simulator-result(1).md` | `a863b6a9d5b5c4b9bc256b87fbf0703752babe8225884e67fca09464442c9675` | Stateful/open-arrival fleet simulator, capacity equations, reconnect/recovery/fairness/soak design, and broker triggers; no production distribution, threshold, or capacity proof. |
| I04 | `18-retention-deletion-restore-result.md` | `18-retention-deletion-restore-result(1).md` | `be1ecbd6752f74baf2eb8bb7a29508cbbcebbd3a4561af6a6d5a43ad8d0dae9b` | Retention/lifecycle controller, exact subject resolution, tombstones, backups, acknowledged coverage, isolated restore, and connector/export deletion; lifecycle/restore drill remains unexecuted. |
| I05 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, UUIDv7, realm identity, durable audit, independent oracle, repository/dependency/evidence controls, and database benchmark posture. |
| I06 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted source/event identity, interpretation separation, whole-page atomic progress, and privacy boundary. |
| I07 | `batch-03-review-result.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted endpoint batching, durable ambiguous attempts, receipt semantics, cleanup hold, identity, diagnostics, release, compatibility, and later server/restore dependencies. |
| I08 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted architecture and non-negotiable invariants; not runtime or production proof. |
| I09 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted relational-inbox/no-broker posture, database comparison, proof order, and stop rule. |
| I10 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source-quality rules, human-authority boundary, and conflict discipline; not technical proof. |

## 0.2 Review method

Conflicts were resolved in this order:

1. preserve I05–I09 accepted predecessor decisions and non-negotiable invariants;
2. prefer the narrower authority, smaller privacy/security surface, and fail-closed behavior;
3. distinguish immutable custody truth from mutable processing and derived evidence;
4. distinguish source/business identity from implementation, installation, partition, and interpretation convenience;
5. distinguish documented database or tool capability from UAM-specific correctness, recovery, capacity, and operational fitness;
6. require one explicit state/transaction authority instead of overlapping ledgers or implied cross-store atomicity;
7. treat exact versions, limits, rates, durations, headroom, and cost values as execution evidence unless an accountable human approves them;
8. choose the smallest falsifying **CLI EXPERIMENT** where prose cannot decide;
9. create an accepted-baseline change proposal only where the consolidated conclusion actually conflicts with a predecessor decision.

**FACT.** No accepted-baseline change proposal is required by this review. Several topic-level details are corrected or narrowed, but the accepted modular-monolith, relational-inbox, one-effect, realm, receipt, no-broker-default, database-comparison, endpoint-cleanup-hold, and restore-readiness decisions remain intact.

## 0.3 Current primary-source verification scope

Required web verification was limited to load-bearing current or disputed claims: supported database release lines; documented partitioned-uniqueness constraints; queue-lock semantics; backup verification/PITR limitations; regulator guidance on erasure and restored backups; cryptographic-erasure preconditions; and exact repository review points. The result does not use vendor marketing, popularity, download counts, or generic synthetic benchmark claims as UAM proof.

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The four topic results agree strongly enough to accept the following Batch 04 architecture at implementation-prototype level:

1. **Durable custody:** an authenticated ingestion boundary commits immutable batch identity, exact custody bytes, durable receipt, and processable work in one relational transaction, and returns the receipt only after that transaction commits in a declared failure domain.
2. **Asynchronous one-effect processing:** short fenced leases schedule immutable inbox work; parsing occurs outside the lease transaction; one final transaction either materializes the whole batch idempotently or records an explicit terminal quarantine occurrence.
3. **Portable database decision:** PostgreSQL remains the reference candidate and SQL Server remains a serious transition/fallback candidate; one semantic harness must compare both before production selection.
4. **Stateful capacity proof:** a UAM-owned simulator must preserve per-installation event, batch, attempt, ambiguity, receipt, policy, version, offline, and backlog state, while an independent open-arrival lane prevents coordinated omission.
5. **Measured—not assumed—scale:** 6,000 and 12,000 logical installations and soak campaigns are named experiment scenarios, not a production support promise or substitute for event/byte/retry/outage/query/retention distributions.
6. **Suppress-first lifecycle:** an authorized deletion first commits a realm-scoped visibility barrier and monotonic tombstone, then executes and verifies explicit store/destination targets; physical deletion is not allowed to precede invisibility.
7. **Isolated restore:** a restored environment has a new identity, ordinary reads/exports/connectors/receipt authority disabled, and cannot become ready until current tombstones and every authoritative acknowledged batch are reconciled and tested.
8. **Truthful external status:** exports and integration copies are inventoried by capability; unsupported or human-controlled copies produce explicit limitations rather than a false technical-erasure claim.

**FACT.** None of I01–I04 supplies executed evidence that closes the batch. I01 is a G8 architecture proposal, I02 keeps the database ADR open, I03 states that production capacity is unknown, and I04 keeps the lifecycle/restore drill open.

**Therefore:**

> **Batch 04 architecture may proceed into strict-contract, schema, simulator, database-lab, and lifecycle prototypes using T1 fictional data. The aggregate Batch 04 gate remains OPEN. No production receipt class, endpoint payload cleanup, database selection, capacity promise, retention sweep, erasure, backup expiry, connector deletion, restored read enablement, broker, pilot, or production deployment is authorized.**

## 1.2 Consolidated batch gates

The accepted global proof order is preserved. This review uses Batch 04-local gate names rather than silently renumbering the suite.

| Gate | Current status | Required closure evidence | Non-waivable stop condition |
|---|---|---|---|
| **B04-INGEST — durable custody and one effect** | **OPEN — CLI EXPERIMENT** | exact receipt transaction, response-loss replay, batch/event conflict, lease fencing, whole-batch terminal outcome, poison containment, realm-negative tests, reconciliation, restore of the exact custody profile | receipt without committed batch/payload; same event creates more than one ordinary effect; stale lease commits; cross-realm access; unbounded poison; unexplained custody/terminal mismatch |
| **B04-DB — engine semantics, recovery, and operations** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | both candidates pass the identical semantic suite; paired production-shaped load; actual backup restore/PITR/failover; report/maintenance coexistence; operator drills; skills, edition, licensing, support, and TCO assessment | semantic divergence; acknowledged event missing; deleted data visible before readiness; split-brain/false receipt; topology/edition/license ambiguous; no accountable operations owner |
| **B04-CAP — demand, headroom, recovery, and fairness** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | qualified generator; exact 6k/12k/soak scenarios; steady/reconnect/multi-day backlog; query/backup/maintenance coexistence; recovery while new arrivals continue; fairness; approved thresholds and cost envelope | generator cannot sustain intended offered load; correctness fails under load; backlog cannot drain; starvation; silent loss; required inputs/objectives remain unknown |
| **B04-LIFE — deletion, backup, acknowledged replay, and restore readiness** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | exact resolver; barrier/tombstone/read-guard; every store/connector/export target; backup catalogue; old-backup restore; no tombstone gaps; exact acknowledged-set replay; deleted-negative and acknowledged-positive probes; no pre-ready read/egress | wrong/cross-realm subject; deleted data visible; acknowledged event missing/duplicated; tombstone rollback/gap/fork; false external completion; ordinary read/egress/receipt before readiness |
| **B04-AGG — aggregate technical batch gate** | **OPEN** | B04-INGEST plus the required portions of B04-DB, B04-CAP, and B04-LIFE pass for one exact release/topology; ADRs accepted; owners assigned; evidence current; cleanup complete | any hard invariant failure, missing/expired evidence, unresolved contradiction, unassigned blocking owner, or residue |

## 1.3 Immediate permission and prohibition

**GO now** for:

- strict HTTP, receipt, lease, quarantine, fact, projection, integration, deletion, backup, restore, evidence, and simulator contracts;
- engine-neutral pure domain models and an independently implemented oracle;
- T1 fictional realms, installations, batches, events, subjects, exports, connectors, backups, tombstones, receipts, faults, and queries;
- PostgreSQL and SQL Server isolated candidates behind the same semantic adapter contract;
- receipt/response-loss/lease/poison/realm failpoints;
- stateful fleet actors, open-arrival scheduling, production-wire reuse, generator self-tests, 6k/12k/soak scenario compilation, and metadata-only measurement tooling;
- deletion-case, exact-resolver, tombstone/read-guard, store-adapter, connector/export-registry, backup-catalogue, and isolated-restore prototypes;
- actual T1 backup, PITR, failover, and old-backup restore drills in isolated labs;
- architecture, dependency, privacy-canary, cardinality, cleanup, and evidence validation.

**STOP** before:

- returning a production cleanup-eligible receipt or deleting endpoint payload after an ACK;
- accepting a response code, socket completion, replica read, broker ACK, or backup-tool check as durable custody;
- selecting PostgreSQL or SQL Server by prose, familiarity, popularity, one throughput score, or unequal configurations;
- advertising “6,000 devices supported” from endpoint count or a short average-rate run;
- setting production batch, lease, retry, worker, connection, index, partition, headroom, outage, soak, retention, or backup values from the estimates in I01–I04;
- introducing a broker, workflow platform, search engine, CDC system, or per-realm database fleet without its measured trigger and ADR;
- production retention activation, subject erasure, legal-hold release, backup expiry, export deletion, connector deletion, or restored read enablement;
- using production activity, identifiers, credentials, addresses, internal URLs, customer configuration, or raw personal data in the benchmark or lifecycle drill;
- pilot or production approval.

## 1.4 Executive residual risk

The consolidated design contains rather than removes risk:

- a storage, filesystem, replication, cloud, or operator failure can invalidate the declared receipt failure domain;
- a duplicated or incorrectly scoped event ID can become either lost evidence or a double business effect if the central uniqueness rule is wrong;
- a narrow global identity ledger can become a reconnect-storm contention point;
- relational queue plans, locks, vacuum/ghost cleanup, WAL/log growth, checkpoints, reports, backups, or failover can fail only at production-shaped history and concurrency;
- a synthetic generator can hide overload if its offered-arrival schedule, clocks, sockets, or evidence sink saturate;
- subject resolution, legal holds, aggregate contribution lineage, hidden/manual exports, and recipient copies can make deletion incomplete or wrongly scoped;
- an older restore can resurrect deleted data if tombstones or connector obligations are rolled back, or lose acknowledged events if the authoritative receipt set is incomplete;
- a privileged administrator, direct database path, stale cache/search snapshot, or misconfigured replica can bypass normal read suppression;
- exact versions, managed-service behavior, licensing, support, pricing, and operational competence can change after review.

Containment is strict authenticated context, immutable custody, one central effect identity, fenced state machines, exact realm-first keys, independent oracle/reconciliation, synthetic-first tests, actual restore/failover, monotonic tombstones, read/egress barriers, truthful limitations, finite observability, evidence expiry, and stop-on-first-hard-failure.

## 1.5 Confidence summary

| Major conclusion | Confidence | Why | Evidence that could change it |
|---|---|---|---|
| Relational custody plus leased processing is the correct initial server architecture | **High** | It is accepted baseline, composes with stable endpoint identities, and avoids an unproved broker failure domain. | A smaller alternative that passes the same custody, replay, realm, restore, operations, and cost gates. |
| Receipt must be emitted only after the atomic custody transaction commits | **High** | Any earlier signal can authorize endpoint deletion without recoverable bytes. | A different declared custody mechanism with equivalent atomicity and restore proof, accepted by change proposal. |
| Immutable custody and mutable work state should be separate | **High** | It narrows updates, logging, lock amplification, and accidental receipt/payload mutation. | Paired evidence that co-location is simpler and equally immutable, durable, low-contention, and auditable. |
| Event uniqueness belongs at `(realm_id, event_id)` | **High** | The endpoint owns one stable event ID; adding installation to uniqueness weakens clone/re-enrollment/cross-producer conflict detection. | A predecessor-approved event identity contract explicitly making installation part of event identity, with migration and replay proof. |
| Whole-batch first-slice terminal outcomes are safer than partial success | **Medium-High** | They keep receipt-to-terminal and replay semantics small and testable. | Measured poison amplification or batch scale plus a complete per-event terminal/cleanup contract that is demonstrably safer. |
| PostgreSQL and SQL Server require identical semantic and operational evidence | **High** | Both document relevant primitives, but capability does not establish UAM fitness. | A recorded human strategic constraint removes a candidate before comparison; this would be a scope choice, not technical proof. |
| Exact production capacity is currently known | **Low / not established** | Required demand, retention, query, outage, cost, and objective inputs are absent. | Approved distributions, qualified simulator, paired engine runs, recovery/soak, and human objectives. |
| Suppression/tombstone must precede physical deletion | **High** | It is the smallest mechanism that protects asynchronous readers and old restore/replay paths. | A simpler mechanism proving immediate invisibility across every store, restore, and failure. |
| Restore readiness needs both tombstone and authoritative acknowledged-set reconciliation | **High** | Either missing proof can expose deleted data or omit custody-backed data. | A single immutable recovery substrate that intrinsically and testably contains both authorities. |
| External deletion can always be guaranteed | **Low** | Human-downloaded and unsupported recipient copies are outside UAM control. | Binding destination contracts and independently verified recipient-side erasure evidence. |

---

# 2. Accepted decisions and invariants

## 2.1 Accepted predecessor baseline carried forward

The following are **FACT** from I05–I09 and remain non-negotiable:

| ID | Accepted invariant |
|---|---|
| A04-01 | Realm, installation, device, user, and session authority comes from authenticated context, never payload claims. |
| A04-02 | One user, session, installation, or realm cannot submit, view, mutate, export, hold, delete, lease, cache, or execute work as another. |
| A04-03 | A privileged mutation cannot succeed without durable audit evidence. |
| A04-04 | A receipt means durable custody in its declared failure domain only; it does not mean validation, materialization, integration, reporting, or portal visibility. |
| A04-05 | Delivery is at least once; stable event/batch identities and central uniqueness make retry or replay produce one final business effect. |
| A04-06 | No component silently drops unacknowledged data under pressure. |
| A04-07 | Restores neither lose acknowledged events nor make deleted data visible before readiness. |
| A04-08 | The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF, and governed integrations. |
| A04-09 | No external broker is a default. A measured failure-domain, throughput, replay, fan-out, recovery, or cost need must justify it. |
| A04-10 | PostgreSQL is the target reference and SQL Server is a serious transition/fallback candidate; production selection requires identical benchmark, restore, operations, skills, licensing, and support evidence. |
| A04-11 | Stable natural source/event identity is not rewritten by runtime, normalizer, policy, matcher, interpretation, database, or partition changes. |
| A04-12 | Endpoint batches are sealed once; exact body and stable identities survive ambiguous send and replay. |
| A04-13 | Production endpoint payload cleanup remains disabled until receipt failure domain, RPO, clock, ACK grace, deletion, and restore rules are approved and proved together. |
| A04-14 | Facts and aggregates are server-derived; endpoints never submit SQL or hold database credentials. |
| A04-15 | Logs, diagnostics, metrics, and evidence are minimized and use finite value-free dimensions; UAM telemetry is fallible operational evidence, not sole forensic proof or an employee-productivity score. |
| A04-16 | A failed early gate stops dependent work and opens an ADR/change review. Passing proves only the exact claim, workload, release, topology, and failure tested. |

## 2.2 Ingestion and custody

**RECOMMENDATION — ACCEPT as the normative prototype baseline.**

1. The public ingestion route MUST have no realm, installation, or device authority in the body, URL, query, or untrusted forwarding header.
2. The server identity boundary MUST create an immutable authenticated context before ingestion semantics run.
3. The ingestion route MUST enforce one exact release-owned contract/encoding profile, compressed and decompressed limits, counts, syntax, time/allocation limits, and both exact wire and canonical-content digests before custody.
4. A new batch MUST commit immutable batch metadata, exact custody bytes, one immutable custody receipt, and one processable work record in one short relational transaction.
5. A receipt response MUST be created and returned only after that transaction commits according to the configured failure-domain class.
6. Same authenticated batch identity plus the same immutable digests MUST return the committed receipt without another custody or business effect.
7. Same batch identity plus any immutable digest, contract, or binding difference MUST become an explicit integrity conflict; the original committed batch is never overwritten.
8. The receipt table and payload identity are append-only. Processing, lease, retry, visibility, integration, retention, and deletion state MUST NOT be added to or inferred from the receipt.
9. Gateway or API process death after commit and before response is an expected ambiguity. Endpoint replay/status query uses the same batch and wire identity.
10. A production endpoint cleanup decision MUST verify a matching authenticated receipt and a separately approved cleanup-eligibility policy. HTTP status alone is never sufficient.

## 2.3 Work leasing, event identity, materialization, and quarantine

**RECOMMENDATION — ACCEPT WITH CONSOLIDATED CORRECTIONS.**

1. Mutable scheduling state SHOULD live in a narrow `ingest_work` entity separate from immutable batch/payload/receipt rows.
2. Lease acquisition MUST be a short atomic database transaction using database time, a random/unguessable lease token, incrementing fence/version, bounded expiry, and exact realm-first key.
3. Parsing, decompression, semantic validation, reference lookup, and plan construction MUST occur outside the lease transaction.
4. Heartbeat and final commit MUST match realm, batch, lease token, fence/version, and valid lease epoch. Zero affected rows means the worker lost authority and MUST discard local results.
5. The first slice MUST use whole-batch semantic terminal outcomes. One deterministic poison, unsupported semantic schema, or event identity conflict terminally quarantines the batch generation; no subset of new facts from that attempt commits.
6. The central ordinary-effect uniqueness key MUST be `(realm_id, event_id)`. `installation_id` remains immutable provenance and conflict evidence, not a way to permit two ordinary effects for one endpoint-minted event ID.
7. Same event ID and same payload/effect digest is retry-equivalent. Same event ID with different digest, effect, producer provenance, or incompatible identity is an explicit conflict/hold, not an overwrite.
8. The successful materialization transaction MUST fence the lease; insert new event identities and typed facts; record replay provenance; insert projection work and governed integration outbox rows; and move the batch to `MATERIALIZED` atomically.
9. Terminal quarantine MUST be an immutable batch-processing occurrence separate from the event identity ledger. A governed new processing generation retains prior quarantine evidence and does not require editing the custody record.
10. One reconcileable batch terminal outcome MUST exist: `MATERIALIZED`, `QUARANTINED_TERMINAL`, or an explicitly defined safety hold that is not falsely terminal. Processing state is not receipt state.

## 2.4 Facts, projections, integrations, and audit

**RECOMMENDATION — ACCEPT.**

1. Minimized typed facts are authoritative ordinary business effects. Generic mutable JSON is not the normal fact model.
2. A partitioned fact table MAY be used, but global event uniqueness MUST remain independent of unsettled partition grain; the first candidate is a separate unpartitioned event-identity ledger.
3. Projection work MUST be inserted in the fact transaction. A projection contribution ledger with a unique contribution identity MUST prevent the same fact from being applied twice.
4. Aggregates MUST be reproducible from retained authoritative facts or explicit contribution lineage. Any output claimed to survive subject deletion as anonymous requires separate technical and human evidence.
5. Integration messages MUST be inserted in the fact transaction and delivered at least once under a stable message ID. Network I/O never occurs inside materialization.
6. Integration receipt/acceptance never changes custody or fact truth.
7. Privileged reprocess, deletion, restore readiness, connector administration, backup expiry, and read enablement MUST write durable audit evidence. Ordinary operational logs do not substitute for that ledger.
8. Audit retains the minimum action shell under its separately approved purpose; raw selectors, payloads, URLs, subjects, or deleted content do not become indefinite audit data.

## 2.5 Database comparison and physical design

**RECOMMENDATION — ACCEPT THE PROCESS; KEEP THE ENGINE ADR OPEN.**

1. PostgreSQL and SQL Server adapters MAY use engine-specific DDL, queue-lock SQL, bulk APIs, backup, failover, and telemetry controls, but MUST implement identical UAM semantics and expected outcomes.
2. Correctness, realm isolation, custody, replay, one effect, quarantine, restore, and failover are hard gates that precede performance or cost comparison.
3. The primary comparison MUST use the same application build, canonical fixtures, oracle, workload schedule, history volume, query corpus, worker algorithm, durability intent, fault plan, hardware/storage/network class, reset method, and evidence format.
4. Default and tuned profiles MUST be clearly separated. Tuning effort, knobs, iterations, and visibility of results MUST be preregistered and symmetric.
5. A common self-managed profile SHOULD isolate engine behavior first. Managed-service profiles are separately named deployment-option comparisons and MUST NOT be reported as pure engine results.
6. Database row-level security is defense in depth. Realm-first schema/application keys and authenticated server context remain primary; connection-pool/session context is hostile-tested.
7. Queue primitives such as PostgreSQL `SKIP LOCKED` and SQL Server `READPAST` are scheduling aids, not authoritative reads or fairness guarantees.
8. Partition/index design, bulk path, identity-ledger topology, replicas, report routing, connection pools, vacuum/maintenance, and log settings remain measured candidates.
9. Backup verification tools and vendor/service SLAs are supporting evidence only. An actual isolated restore and application-level reconciliation are mandatory.
10. The final database decision includes operations, skills, on-call drills, edition/feature constraints, licensing, support, migration, backup/restore, failover, and three-year TCO. A result may legitimately be `NO ROBUST WINNER`.

## 2.6 Capacity and simulator architecture

**RECOMMENDATION — ACCEPT THE SIMULATOR/MEASUREMENT ARCHITECTURE; KEEP ALL PRODUCTION CAPACITY OPEN.**

1. UAM owns the scenario schema, deterministic seed/clock, stateful installation actors, open-arrival scheduler, truth ledger, production-wire adapter, fault plan, evidence format, and gate evaluator.
2. The stateful lane MUST preserve each installation's generated events, local backlog, sealed immutable batches, attempts, ambiguity, receipts, policies, software versions, online/offline state, and next action.
3. The open-arrival lane MUST schedule offered operations independently of server response time and record offered, started, delayed, dropped-by-generator, and completed work separately.
4. The simulator MUST call the exact production contract, serializer, compressor, digest, authentication client, retry classifier, and receipt verifier. It MUST NOT implement a faster test-only codec or fabricate receipts.
5. A small Windows fidelity cohort MUST prove byte/state/TLS/identity/retry equivalence for the exact endpoint transport. Large logical scale MAY run on cheaper agents only after equivalence passes.
6. Generator saturation, clock error, socket exhaustion, evidence-sink saturation, series-cardinality growth, and partition skew MUST be measured; a saturated generator invalidates the claimed offered range.
7. Capacity results MUST bind fleet/activity, events, bytes, compression, batching, retries, outage/backlog, realm/site mix, contract versions, database/history/query/maintenance, hardware/topology, faults, duration, seed, and human objectives. Endpoint count alone is not a capacity statement.
8. A system that can accept a peak but cannot drain the outage backlog while serving new arrivals with approved tail/fairness/headroom fails.
9. Correctness and privacy invariants remain zero-tolerance at every load. Performance cannot compensate for a false receipt, duplicate effect, cross-realm result, silent loss, or canary escape.
10. The named 6,000, 12,000, 24-hour, and 72-hour values are staged experiment profiles or **ESTIMATE**, not timeless architecture or production commitments.

## 2.7 Retention, deletion, backup, and restore

**RECOMMENDATION — ACCEPT THE MECHANISM ARCHITECTURE; KEEP LEGAL/POLICY VALUES AND THE LIFECYCLE GATE OPEN.**

1. An authorized lifecycle action MUST be based on an immutable policy revision and exact typed subject/scope resolution. Fuzzy names, activity inference, display labels, SQL, paths, or arbitrary scripts are not deletion authority.
2. Subject resolution MUST remain realm-bound, reproducible, versioned, and independently challengeable. Ambiguous, stale, zero, incompatible, or cross-realm resolution does not commit a deletion barrier.
3. The same authoritative transaction MUST create active suppression tombstone(s), advance the realm visibility epoch/watermark, create deterministic store/destination targets, enqueue integration deletion work, append minimal audit, and move the case to `BARRIER_COMMITTED`.
4. BFF/API repositories, caches, replicas, materialized views, search, exports, and integration materializers MUST honor the current tombstone/visibility watermark before being eligible to serve or send data.
5. Physical deletion occurs asynchronously through typed store adapters and is independently verified. Cross-store atomicity is not claimed.
6. An active legal hold MAY block destruction and backup expiry, but MUST NOT restore ordinary visibility or grant read/export authority. Status is explicit, such as `PARTIAL_HELD`.
7. Tombstones MUST dominate every resurrection path: older backup, endpoint replay/grace copy, inbox replay, connector retry, search snapshot, replica recovery, cache, export object version, or derived rebuild.
8. Tombstone authority MUST be independently recoverable relative to an older business backup. This does not require a broker or microservice by default; it requires a monotonic sequence and protected recovery evidence that an old restore cannot silently roll back.
9. The authoritative acknowledged set is the committed custody-receipt relation. Coverage manifests/digests MAY be independently preserved for restore, but MUST NOT become a conflicting second receipt truth.
10. Restore MUST occur under a new isolated environment identity with ordinary reads, endpoint receipt authority, connector/export egress, and production routing disabled.
11. Readiness requires engine/schema/realm verification, current tombstone replay with no gap/fork, exact acknowledged-set reconciliation, replay of recoverable missing batches under stable IDs, rebuild of derived stores under the guard, negative deleted-subject probes, positive acknowledged-event probes, audit/canary checks, and no egress.
12. Any unrecoverable or conflicting acknowledged batch, tombstone gap/fork, stale derived reader, deleted-subject hit, cross-realm result, or cleanup residue keeps the environment `READ_BLOCKED` or `QUARANTINED`.
13. Backup expiry is chain-, copy-, key-, log/PITR-, hold-, replacement-, and actual-restore-aware. A nominal date or tool `check` result alone cannot authorize deletion.
14. External copies have capability-bounded truth. `EXTERNAL_ACTION_REQUIRED` or `COMPLETE_WITH_LIMITATIONS` is required when UAM cannot prove recipient-side deletion.
15. Per-subject cryptographic erase is not the default. It may be reconsidered only where every relevant object, derivative, backup, cache, key copy, wrapping hierarchy, escrow, and recipient is isolated and proved.

## 2.8 Consolidated cross-topic invariants added by this review

| ID | Consolidated invariant |
|---|---|
| X04-01 | Immutable custody truth (`batch`, exact payload identity/bytes, receipt) is physically and logically separate from mutable work, retry, quarantine, visibility, integration, and lifecycle state. |
| X04-02 | One ordinary event effect is globally unique within a realm by `(realm_id, event_id)`; installation, partition, runtime, interpretation, and database are provenance, not uniqueness broadening. |
| X04-03 | A quarantine occurrence does not permanently consume the ordinary event identity. A later governed processor generation can materialize the same stable event once while retaining prior quarantine history. |
| X04-04 | The receipt relation is the authoritative acknowledged-set source. Backup/restore coverage manifests are derived, independently protected reconciliation evidence, not a competing receipt ledger. |
| X04-05 | Tombstone independence means recoverable monotonic authority across an older business-data restore; it does not by itself justify a broker, separate service, or nonrelational store. |
| X04-06 | Restore readiness and ordinary read activation are separate privileged transitions. A technical `READY` decision does not itself authorize production routing or legal/business use. |
| X04-07 | Database, capacity, lifecycle, broker, and endpoint-cleanup gates share the same exact contract/schema/release digests. A result from a different profile cannot be composed silently. |
| X04-08 | A 6k/12k or throughput result is invalid when the generator cannot prove intended offered load, when hard correctness fails, or when history/query/maintenance/restore context differs from the claim. |
| X04-09 | A database backup, transaction log, replica, search snapshot, export, connector, and endpoint ACK grace are all explicit lifecycle copies or resurrection paths. None is omitted because it is “derived” or “temporary.” |
| X04-10 | Every production numeric control must be owned, source-labelled, bounded, versioned, and replaceable. Topic estimates cannot harden into producer limits or SLOs without compatibility and human approval. |
| X04-11 | No feature flag can bypass authenticated realm, immutable receipt meaning, one-effect identity, tombstones, legal holds, durable audit, or restore-readiness checks. Flags may only narrow, pause, or disable. |
| X04-12 | External deletion completion is never inferred from HTTP 2xx, notification, a queued request, or generic `404`; the connector contract defines terminal evidence and limitations. |

---

# 3. Rejected and deferred recommendations

## 3.1 Rejected now

| Recommendation or interpretation | Decision | Reason | Condition that could change it |
|---|---|---|---|
| Return a receipt before the relational custody transaction commits | **REJECTED** | Can authorize endpoint deletion without recoverable bytes and violates accepted receipt meaning. | Only an explicit baseline change with another atomic custody boundary and full replay/restore proof. |
| Treat HTTP success, socket completion, a reverse-proxy ACK, replica visibility, or an in-memory queue as custody | **REJECTED** | None proves committed custody in the declared failure domain. | No ordinary exception; a new named receipt class would require the same failure-domain proof. |
| Use payload/body/route/header/certificate text as realm or installation authority | **REJECTED** | Conflicts with authenticated-context and realm-isolation invariants. | No expected change. |
| Keep lease/retry/processing fields on the immutable receipt | **REJECTED** | Mutates custody evidence and conflates independent states. | No expected change. |
| Permit event uniqueness by `(realm_id, installation_id, event_id)` as the common baseline | **REJECTED** | It permits one endpoint-minted event ID to create multiple ordinary effects after clone, re-enrollment, producer defect, or installation reassociation. | A predecessor-approved event identity redesign with migration, correction, and replay evidence. |
| Put final event uniqueness only on a time-partitioned fact table | **REJECTED AS COMMON BASELINE** | Both engine families constrain partitioned unique keys; event identity would become dependent on unsettled time/partition semantics. | If event identity explicitly includes the partition key and all late-arrival/replay consequences are approved. |
| Mark event IDs terminally `QUARANTINED` in the global effect ledger before a successful effect commit | **REJECTED FOR FIRST SLICE** | It can block governed reprocessing or turn processor failure into permanent business identity truth. | A complete per-event terminal/correction model proving simpler, safe reprocessing. |
| Partially materialize valid siblings from a poison batch without a new contract | **REJECTED** | Creates multiple terminal meanings, cleanup ambiguity, and replay subsets. | Versioned per-event terminal status/receipt/cleanup semantics plus measured need. |
| Arbitrary SQL, scripts, regexes, plugins, handler discovery, or general workflow definitions for ingestion/reprocess/deletion | **REJECTED** | Expands authority beyond release-owned typed contracts and undermines realm/privacy/audit proof. | No general channel; a new fixed capability requires its own contract and gate. |
| An external broker as the initial acceptance boundary | **REJECTED BY BASELINE** | Adds custody, replay, ACL, retention, restore, operations, and migration failure domains without measured need. | Quantitative trigger plus a full change proposal and smaller prototype passing all hard gates. |
| A broker after the relational inbox merely “for scale” | **REJECTED INITIALLY** | Duplicates queue state and requires a transactional handoff/outbox while the relational inbox already owns replay. | Measured isolation/fan-out/replay/DB-resource/TCO trigger and an accepted broker ADR. |
| Synchronous validation/materialization/integration before custody receipt | **REJECTED** | Couples endpoint availability to poison/reference/downstream work and lengthens the critical transaction. | A named business requirement for semantic pre-acceptance plus bounded proof without redefining receipt. |
| Generic message frameworks as the core custody state machine | **REJECTED INITIALLY** | They import broad handler, serializer, broker, migration, dashboard, scheduler, and licensing authority for a small security-sensitive state machine. | Exact dependency admission and a bake-off proving lower defect/operations cost without semantic loss. |
| Select PostgreSQL immediately because it is the reference | **REJECTED** | Reference status is not UAM capacity, recovery, skills, or support proof. | B04-DB plus human strategic/TCO approval. |
| Select SQL Server immediately because legacy skills may exist | **REJECTED** | Familiarity and transition cost are relevant but not sufficient; exact skills, edition, license, topology, and restore evidence are absent. | Same B04-DB and human approval. |
| Let a generic TPC-like benchmark, `pgbench`, HammerDB, BenchBase, or one microbenchmark choose | **REJECTED AS SOLE PROOF** | Omits custody, replay, realm, poison, materialization, reports, retention, restore, and operator behavior. | May remain a secondary hardware/engine diagnostic only. |
| Compare unequal schemas, durability, history, hardware, OS, bulk path, reports, or tuning effort | **REJECTED** | Makes results non-causal and can hide semantic weakening. | No condition; differences must be separate named profiles. |
| Weaken durability, realm isolation, RLS, receipt semantics, backup, or audit to improve a score | **REJECTED** | Hard correctness/security gates precede performance. | No condition. |
| Treat `SKIP LOCKED` or `READPAST` as fairness or correctness proof | **REJECTED** | They are queue scheduling primitives with documented limitations; plan, lock, page, starvation, and failover behavior remain empirical. | Only measured behavior for the exact schema/workload. |
| RLS as the only realm boundary | **REJECTED** | Privileged roles, owner/bypass behavior, session context, pooling, modules, and misconfiguration can bypass it. | No expected change; it remains defense in depth. |
| One database/schema/table per realm by default | **REJECTED INITIALLY** | Creates connection, migration, backup, object-count, uneven sizing, and operations cost without a requirement. | Legal/restore/key isolation decision or measured noisy-neighbor failure that shared isolation cannot contain. |
| Treat 6,000 devices, 12,000 devices, one average rate, or one smoke test as capacity proof | **REJECTED** | Omits events, bytes, retries, outage correlation, queries, history, retention, maintenance, hardware, tails, and objectives. | No single count is sufficient; a fully bound capacity claim may use those scenarios. |
| Closed-loop load generation only | **REJECTED** | Server slowdown reduces offered load and can hide overload/coordinated omission. | A different scheduler proving independent offered arrivals and skipped/delayed start accounting. |
| Stateless HTTP virtual users as the authoritative fleet model | **REJECTED** | Cannot represent local backlog, immutable batch identity, ambiguity, receipts, policy, version, or per-device fairness. | May remain a narrow ingress microbenchmark only. |
| Copy production activity into the simulator for realism | **REJECTED** | Violates synthetic-first minimization and creates uncontrolled disclosure, lineage, deletion, and reproducibility risk. | Only approved minimum aggregate metadata may parameterize fictional distributions. |
| Add worker retries without a finite taxonomy/quarantine bound | **REJECTED** | Poison work can capture the queue and amplify load indefinitely. | No condition; retries remain classified and bounded. |
| Global FIFO as an assumed fairness policy | **REJECTED** | A reconnecting or large realm can starve small/healthy realms. | It may win a measured candidate comparison only if starvation and lag bounds pass. |
| Physical deletion before a visibility barrier | **REJECTED** | Slow/failing readers can continue to expose data. | No expected change. |
| Soft-delete flag alone as deletion completion | **REJECTED** | Easy to bypass and does not cover backups, replay, search, exports, or external copies. | It may be one implementation of the immediate barrier, followed by explicit deletion/verification. |
| Let backups expire without current tombstones on restore | **REJECTED** | An older restore can expose previously deleted data. | No expected change. |
| Edit every historic backup in place by default | **REJECTED** | Can break integrity, immutability, signatures, ancestry, PITR/log continuity, and recovery. | A selected platform proves supported selective mutation and safer end-to-end restore. |
| Backup verification/checksum/file existence as restore proof | **REJECTED** | Tools cannot prove application semantics, acknowledged-set completeness, tombstones, or reader state. | No condition; actual restore remains mandatory. |
| Reopen reads, connectors, exports, or endpoint receipt issuance while restore reconciliation runs | **REJECTED** | Directly violates the accepted restore invariant. | No expected change. |
| Use per-subject cryptographic erase as the default deletion mechanism | **REJECTED** | Shared pages, indexes, logs, caches, derivatives, backups, key copies, and recipients make assurance unproved. | Complete object/key isolation plus all-copy/key-hierarchy sanitization and recovery tests. |
| Treat database `DELETE`, vacuum/ghost cleanup, partition drop, TTL, compaction, or CDC as rights completion | **REJECTED** | These are storage/propagation mechanisms, not scope, visibility, backup, recipient, or restore proof. | May be typed adapter optimizations under the lifecycle controller. |
| HTTP 2xx or notification as external deletion completion | **REJECTED** | May mean accepted/queued and does not prove recipient-side application. | Only connector-specific terminal durable evidence plus independent verification. |
| Universal `404 = deleted` | **REJECTED** | Can hide wrong realm, wrong object, authentication failure, or enumeration behavior. | A connector contract may allow authenticated idempotent not-found after independent binding proof. |
| Delete privileged audit merely because the subject is deleted | **REJECTED GENERALLY** | Destroys evidence of privileged action. | Subject-bearing case material can be separately minimized/expired; minimum audit shell remains policy-bound. |
| Keep all audit, tombstone, case, quarantine, or receipt content forever | **REJECTED** | “Audit” and “safety” are not blanket purposes and create breach/access/cost risk. | Exact field/purpose periods remain human decisions and conjunctive technical expiry gates. |

## 3.2 Deferred technologies, topologies, and values

The following remain **ESTIMATE**, **UNKNOWN**, **HUMAN DECISION**, **CLI EXPERIMENT**, or dependency admission rather than accepted production architecture:

| Area | Provisional items | Resolution path |
|---|---|---|
| Ingestion wire profile | JSON vs another exact envelope; gzip vs zstd or another compressor; canonical byte profile; media type; digest fields; status-query profile | contract ADR, endpoint/server compatibility vectors, decompression/CPU/size measurements, support horizon, execution-time dependency admission |
| Limits | compressed/decompressed bytes, event count, string/depth/property/scalar limits, request time, memory, concurrency, batch age, status-query cadence | T1 fault/load evidence, approved metadata distributions, compatibility, product/SRE/risk decision |
| Receipt failure domain | primary commit, synchronous replica, managed quorum, archive/replay store, correlated exclusions | B04-INGEST/DB restore/failover evidence plus RPO/RTO/risk **HUMAN DECISION** |
| Queue | lease duration, heartbeat, take size, retry/backoff, fairness algorithm/weights, per-realm concurrency, poison thresholds | lease/fairness experiments under reconnect/slow DB/failover and owner objectives |
| Materialization | whole-batch size ceiling, temporary staging strategy, bulk API, isolation level, identity-ledger sharding, correction/reprocess horizon | semantic parity, log/WAL, contention, poison, late-arrival, and recovery experiments |
| Database | engine, version/edition, OS, self-managed/managed service, HA topology, replicas, storage, support provider | B04-DB paired evidence, skills/TCO/licensing/support decision |
| Physical schema | partition/no-partition, receipt vs event time, grain, indexes, clustering, fill factors, compression, materialized views, RLS profile | loaded-history query/maintenance/retention/restore comparison |
| Reporting | exact query corpus, concurrency, freshness, replica need, analytical store | Product/Data/SRE decision plus concurrent workload evidence |
| Capacity | active fleet, sessions, events, bytes, compression, retries, outage, backlog, poison, query/retention, growth, peak correlation | approved aggregate distributions and simulator runs |
| Performance acceptance | SLOs, error budgets, headroom, saturation knee, backlog-drain target, fairness/starvation, maximum outage, soak length | accountable Product/SRE/Risk decisions informed by measured distributions |
| Broker | product, custody position, partitions, keys, retention, replay, ACLs, regions, schema, migration, operator model | only after a quantitative trigger and separate prototype/ADR |
| Observability | metrics backend, histogram encoding, trace scope, series/cardinality budget, retention | safe catalogue, cardinality model, SRE/Privacy/Data Governance decision |
| Retention | purposes, field/store/destination classes, age bases, periods, deletion deadlines, audit/tombstone/quarantine/receipt horizon | Data Controller/Records/Legal/Privacy decisions encoded as immutable revisions |
| Subject identity | allowed selector types, projection source, authoritative mapping, correction, proof burden | Data Governance/IAM/Legal/Privacy decision and exact resolver tests |
| Legal holds | authority, scope, review, release, evidence, access, conflicts | Legal/Records/Security process and immutable technical registry |
| Tombstone protection | same relational system with protected export, separate database, append-only service, object/WORM copy, keying | threat/RPO/restore/operations experiment; no broker assumption |
| Backup | technology, cadence, full/differential/incremental/log chain, copies, immutability, object versions, region, key references, test cadence | B04-DB/LIFE actual restore, operations, cost, RPO/RTO, provider contract |
| Sanitization | SQL deletion, provider deletion, key destruction, media destruction, cryptographic erase boundaries | selected platform/media/KMS evidence and Records/Security/Risk decision |
| Search/cache/replicas | whether introduced, products, consistency, tombstone/readiness watermark, deletion API, snapshot lifecycle | measured product need plus lifecycle adapter/restore tests |
| Exports/connectors | allowed destinations, recipient class, object tracking, deletion capability, receipts, manual action, contract deadlines | Product Privacy, Legal, Integration owner, recipient contracts and test evidence |
| UI/accessibility | portal technology, roles, segregation, status terminology, accessible workflows | Product/IAM/Accessibility/Support decision and UI test evidence |
| Operations | ownership, on-call, incident authority, staffing, maintenance windows, training, commercial support | Engineering/Operations leadership and exercised runbooks |

## 3.3 Numeric values explicitly not accepted as timeless architecture

**RECOMMENDATION.** The following numbers appearing in I01–I04 are useful scenario seeds or review points only: 6,000 and 12,000 installations; 24-hour or 72-hour soak; monthly partitions; seven to fifteen repetitions; 20-minute warmup; 45-minute measurement; any batch/event/byte/age cap; any lease/retry/backoff; 50% recovery headroom; 70% resource ceiling; p99 five seconds; 20% database resource or cost threshold; 25% replay/fan-out threshold; 20% broker NPV threshold; one-month backup example; and every exact retention/expiry period.

Each production value MUST have a named owner, unit, source classification, workload/environment, effective revision, compatibility impact, uncertainty, review trigger, and evidence that invalid or unknown values fail safely.

---

# 4. Contradiction register with evidence-quality resolution

## 4.1 Resolution method

Each conflict was resolved by preserving accepted predecessor invariants; preferring immutable truth and smaller authority; distinguishing identity from provenance; avoiding two sources of truth; keeping exact values provisional; and converting unresolved fitness into an ADR or CLI gate rather than choosing the most confident wording.

## 4.2 Register

| ID | Overlap, contradiction, or authority problem | Evidence-quality assessment | Consolidated resolution | ADR/action |
|---|---|---|---|---|
| C04-01 | I01 uses event uniqueness `(realm_id, event_id)` while I02 uses `(realm_id, installation_id, event_id)`. | Accepted predecessors define one stable endpoint-minted event ID and one final effect, but do not fix the database key. Installation is authenticated provenance, not part of source natural identity. | Use unique `(realm_id, event_id)`. Persist installation/source/batch provenance. Same event ID with different installation or digest is an integrity conflict, not a second effect. | ADR-B04-004; correct I02 logical DDL and oracle. |
| C04-02 | I01 places lease/work state in `ingest_batch`; I02 separates immutable `ingest_batch` from narrow `ingest_work`. | Both preserve semantics, but I02 better protects immutable custody and reduces repeated large-row updates/log amplification. | Normative logical model separates custody (`ingest_batch`, `ingest_payload`, `custody_receipt`) from mutable `ingest_work`. A co-located physical control variant may be benchmarked only if immutability remains enforced. | ADR-B04-003; schema contract tests. |
| C04-03 | I01 first wire example is strict JSON + gzip; I02 shows zstd/NDJSON. | Accepted baseline commits only to bounded, versioned, authenticated, compressed HTTPS. Neither profile has comparative UAM evidence. | Keep one exact release-owned profile per contract; codec/compression remain provisional. No architecture statement selects gzip, zstd, JSON array, or NDJSON. | ADR-B04-002; compatibility/bake-off. |
| C04-04 | I02's `event_identity.effect_kind` permits `QUARANTINED`; I01 treats quarantine as a terminal batch-processing occurrence with no facts. | Whole-batch reprocessing is safer when processor failure does not permanently consume event business identity. | Quarantine is separate immutable occurrence. Ordinary event identity enters the effect ledger only in successful materialization or an explicitly approved deterministic no-event model. | ADR-B04-005; reprocess tests. |
| C04-05 | I01 mixes queue state with custody while describing append-only batch identity. | Logical intent is compatible but schema shape can lead to accidental mutation of immutable fields or larger WAL/log costs. | Enforce column/table immutability and least-privilege roles; mutable queue state is independently updated. | ADR-B04-003/006. |
| C04-06 | I01 describes one batch terminal outcome; I02's `effect_kind=QUARANTINED` can imply per-event terminality. | One batch outcome is explicit and easier to reconcile; per-event terminality is not fully specified. | First slice: whole-batch `MATERIALIZED` or `QUARANTINED_TERMINAL`. Per-event outcome is deferred contract change. | ADR-B04-005. |
| C04-07 | I02 recommends a separate global identity ledger; I01 has an event-dedupe table but physical partition implications are less explicit. | Current primary docs for both engines show partitioned uniqueness constraints; the separate ledger is the stronger portable starting point. | Accept separate unpartitioned event identity ledger as first candidate; measure reconnect contention, retention, restore, and sharding before production. | ADR-B04-004/008. |
| C04-08 | I01 and I02 both use database-native queue hints that can be read as equivalent fairness. | PostgreSQL documents `SKIP LOCKED` as inconsistent but queue-suitable; SQL Server documents `READPAST` as work-queue-oriented and lock-granularity dependent. Capability is not parity. | Share semantic lease/fence tests; use engine-specific SQL; measure page locks, escalation, starvation, plan drift, and failover. | ADR-B04-006; E04-04/E04-08. |
| C04-09 | I02 proposes RLS profiles; predecessor baseline says authenticated application context and realm-first keys are authority. | RLS is documented capability, but owners/bypass roles/session pooling create bypass paths. | RLS is defense in depth only. App/schema keys and server context remain primary; pool reuse and privileged roles are hard negative tests. | ADR-B04-009. |
| C04-10 | I02 uses temporary bulk staging; I01 whole-batch transaction may be implemented row-by-row. | Both can preserve semantics; performance/log amplification is empirical. | Keep row-by-row as correctness comparator; temporary same-session bulk staging is candidate if exact semantic, cancellation, lease, and rollback tests pass. | ADR-B04-007/008. |
| C04-11 | I02's first partition candidate is monthly; I03 includes capacity/storage formulas that can be mistaken as support. | No approved volume, late-arrival, retention, or query distribution exists. | `P0_NONE`, receipt-time, and event-time candidates are measured; month/week/day remain hypotheses, not decisions. | ADR-B04-008. |
| C04-12 | I02 uses a 24-hour soak estimate; I03 promotes a 72-hour campaign. | Both are test-budget hypotheses. Longer duration catches more maintenance cycles but costs more and still proves only the exact run. | Stage a diagnostic soak, then an endurance soak after correctness; duration is selected from observed maintenance/failure timescales and owner budget. Neither is architecture. | ADR-B04-010; E04-15. |
| C04-13 | I03 provides quantitative broker triggers that may look normative. | They are explicit estimates without approved objectives or cost inputs. | Treat trigger categories as accepted, values as replaceable. Crossing a value opens an ADR/prototype; it does not automatically approve a broker. | ADR-B04-011. |
| C04-14 | I03's 6k/12k scenario labels can be mistaken for platform support. | I03 explicitly rejects endpoint count alone; no approved distributions exist. | Reports must say “passed scenario X” and bind the complete workload/environment. No generic device-support statement. | ADR-B04-010; evidence schema. |
| C04-15 | I03 permits large generic agents after a small Windows cohort; endpoint transport is Windows-specific. | Cost-saving inference is reasonable but equivalence is unproved. | Byte-for-byte and state-transition equivalence is a prerequisite; any Windows-only divergence expands the fidelity cohort. | ADR-B04-010; E04-11. |
| C04-16 | I01 receipt table and I04 `acknowledged_batch_coverage` could become two receipt truths. | Receipt is accepted custody authority; a separately populated coverage table risks asynchronous omission/divergence. | Committed receipt relation is authoritative. Generate content-addressed coverage manifests/watermarks transactionally or by complete reconciliation and protect them independently for restore. | ADR-B04-014. |
| C04-17 | I04 calls for independent tombstone authority, which could be read as a separate service/broker. | The load-bearing property is survival and monotonicity across older business restores, not topology. | Initial implementation remains inside the modular monolith/relational platform with independently recoverable tombstone sequence/export. A separate service requires measured need. | ADR-B04-012/013. |
| C04-18 | I04 calls the lifecycle drill G11, while I09's accepted proof order places deletion/restore at the twelfth listed broad stage. | The prompt-local name does not justify changing the accepted suite numbering. | Use Batch 04-local `B04-LIFE` and record any historical topic label as an alias. Do not silently renumber predecessor gates. | Review/gate-catalogue update. |
| C04-19 | I04 may imply every reader directly consumes tombstones; some caches/search/replicas may only expose watermarks. | Direct filtering is strongest, but architecture must support heterogeneous derived stores without claiming cross-store atomicity. | Every reader either applies tombstones at query time or is ineligible until its source and tombstone/visibility watermarks pass; BFF guard remains final defense. | ADR-B04-012. |
| C04-20 | I04 `COMPLETE` state can be read as a legal rights outcome. | Research cannot decide whether a request should be honored or legally complete. | Technical case state is capability/evidence status only. Legal/rights response is a separate human-governed case outcome. | ADR-B04-013/015; UI language. |
| C04-21 | I04 suggests backup expiry plus restore-time re-deletion; some may infer no need to physically delete backups. | Regulator guidance supports tracked restore handling where backup modification is not advisable, but exact legal/retention outcome is human-owned. | Technical default is chain-aware expiry plus restore-time barrier/re-deletion. Human policy still defines periods and obligations. | ADR-B04-013; HD register. |
| C04-22 | I04 rejects per-subject crypto erase, while endpoint/restricted objects may use encryption. | NIST makes CE assurance conditional on all relevant keys/copies and implementation; object-bound keys can still be useful. | Reject as universal database deletion. Permit bounded per-backup/export/restricted-object crypto erase only after complete key-copy and recovery evidence. | ADR-B04-016. |
| C04-23 | I02/03 database restore experiments and I04 lifecycle restore can be run separately and falsely composed. | Restore of custody/facts without tombstones or lifecycle without exact receipt set does not prove the accepted invariant. | The aggregate restore drill uses one exact engine/topology/release and composes database, receipt, tombstone, derived-store, connector, and cleanup evidence. | ADR-B04-013/014; E04-18. |
| C04-24 | I01 endpoint cleanup depends on receipt; I04 restore replay may depend on endpoints retaining batches. | Production cleanup can remove the last replay source if server custody/RPO is insufficient. | Cleanup eligibility is conjunctive: valid receipt class, independent server recovery source or approved endpoint grace, clock confidence, RPO, tombstone/restore proof, no hold. | ADR-B04-014; update Batch 03 cleanup ADR. |
| C04-25 | I01 says exact wire payload initial storage is relational inline; I03 capacity may show size/cost pressure; object storage is an alternative. | Relational inline is simplest atomic custody, but actual payload distributions are absent. | Accept inline for first prototype. Object storage requires a new atomic-manifest/conditional-write custody design and full failover/restore tests. | ADR-B04-003; measured trigger. |
| C04-26 | I01 whole-batch quarantine and I03 long-outage pressure can create large operator backlog. | Safety semantics are stronger than speculative throughput; exact batch size and poison rate are unknown. | Preserve whole-batch safety; measure poison amplification. A per-event contract is a future change, not hidden optimization. | ADR-B04-005/010. |
| C04-27 | I04 proposes monotonic tombstone expiry after all resurrection paths disappear; exact horizon is unknown. | The rule is sound but depends on backup, endpoint, connector, export, dispute, and audit horizons. | Expiry uses conjunctive evidence and remains disabled until every path and owner decision is represented. | ADR-B04-012/013/015. |
| C04-28 | I04's backup catalogue has one tombstone/receipt watermark, but multi-realm or partial backups may not be totally ordered. | A scalar is useful only for a defined scope and sequence domain. | Catalogue binds explicit realm scope digest and per-authority watermarks/digests; partial scope cannot claim global readiness. | ADR-B04-013/014. |
| C04-29 | Connector deletion `NOT_FOUND` can be terminal in some contracts, while generic `404` is unsafe. | Contract-specific authentication/binding determines meaning. | Default is nonterminal/ambiguous. Permit terminal not-found only under exact connector revision, authenticated object binding, and independent verification. | ADR-B04-015. |
| C04-30 | I04 may retain tombstones/audit long enough to dominate every path, while minimization rejects indefinite retention. | Both are valid constraints; duration is not technically derivable. | Store only opaque minimum fields; expiry is policy-bound and conjunctive; indefinite defaults are prohibited. | ADR-B04-012/017; human retention decision. |
| C04-31 | Current point versions in I02/I04 can be mistaken for architecture requirements. | They are time-sensitive review points only. | Evidence records exact release/patch/driver/tool at execution. Architecture references supported lifecycle-selected profiles, not hardcoded point versions. | ADR-B04-018; dependency process. |
| C04-32 | I04 records pgBackRest 2.59.0 as 8 July 2026; current release page shows 20 July 2026. | Direct release metadata is stronger than the supplied date. | Correct the date; retain it only as a conditional PostgreSQL tool review point, not a dependency selection. | Source correction S04-08. |
| C04-33 | I02 rejects Toxiproxy because exact mapping was incomplete, while I03 supplies a stable v2.12.0 review point/full commit. | Later, better repository evidence resolves provenance, but not tool admission or UAM fitness. | Toxiproxy becomes a test-only candidate after exact binary/image digest, license, security, network-isolation, and cleanup admission. | Dependency record correction. |
| C04-34 | Framework/repository “exactly once” wording can conflict with accepted at-least-once plus one effect. | Framework claims have narrower/different scopes and do not prove endpoint custody or UAM business semantics. | Keep UAM wording: at-least-once delivery, stable identities, idempotent final effect. Frameworks remain reference only. | Source-quality rule. |
| C04-35 | Search/CDC/compaction projects illustrate tombstones but can be mistaken as selected technologies. | They are pattern/negative evidence with different threat models. | Reuse lessons only. Search, CDC, broker, and distributed stores remain absent until a measured need and full lifecycle adapter exist. | ADR-B04-011/015/018. |

## 4.3 Accepted-baseline change-proposal status

**FACT.** The consolidated resolutions preserve the accepted baseline. No change proposal is opened.

A future implementation MUST open a formal baseline change proposal before it claims UAM needs any of the following:

- receipt outside the declared atomic custody failure domain;
- payload-derived realm/installation authority;
- event uniqueness broadened by installation, partition, interpretation, or engine;
- partial batch materialization without a new terminal/cleanup contract;
- an external broker as initial custody or a second competing receipt truth;
- silent unacknowledged loss under pressure;
- ordinary reads or egress before restore readiness;
- deletion without a prior visibility barrier or durable audit;
- a tombstone horizon shorter than a remaining resurrection path;
- raw production activity in capacity evidence;
- a database selected without the accepted semantic/restore/operations gate;
- a platform support or capacity claim inferred from endpoint count, vendor SLA, or generic benchmark.

The proposal must state the affected accepted decision, new primary evidence, security/privacy/realm/durability impact, alternatives, smallest falsifying experiment, migration/rollback consequence, and ADR action.

---

# 5. Normative component, interface, schema, and state-machine baseline

## 5.1 Component and authority baseline

| Component | Normative responsibility | Explicit prohibitions | Accountable engineering function |
|---|---|---|---|
| Server identity boundary | Validate direct mTLS or approved gateway proof; consult current credential status; derive immutable realm, installation, epoch, assurance, and credential context | no body/header/route/IP/hostname/certificate-subject authority; no stale soft allow | Identity/IAM + Ingestion Security |
| Ingestion API | Strict method/path/header/media/encoding/body/digest/contract/admission checks; call the custody transaction; return or replay receipt | no semantic materialization, application lookup, integration call, report update, arbitrary logging, or receipt before commit | Ingestion Service Owner |
| Custody writer | Atomically create/replay immutable batch, exact payload, receipt, and work row under authenticated context | no payload mutation, semantic validation, external I/O, or receipt from memory/replica | Data Reliability / Database Engineering |
| Custody store | Preserve exact immutable batch identity, digests, bytes/storage class, receipt, and declared failure domain | no lease/retry/visibility/integration state on receipt; no realm-less key | Data Reliability |
| Work scheduler | Select work fairly; acquire bounded short fenced leases using database time; expose backlog/age | no parsing inside claim transaction; no fairness claim from SQL hint alone | Materialization/SRE |
| Materialization worker | Reverify custody, parse/validate outside transaction, build deterministic plan, heartbeat, commit one-effect outcome | no stale-lease commit, partial first-slice materialization, arbitrary handler/plugin, or network I/O in final transaction | Materialization Owner |
| Quarantine service | Record immutable processing occurrences, finite reasons, processor/schema evidence, eligibility, and governed reprocess history | no raw payload in ordinary UI/logs, direct SQL repair, evidence overwrite, or automatic infinite retry | Data Governance Operations + Security |
| Event identity ledger | Enforce one ordinary effect per `(realm_id,event_id)` and preserve immutable effect/provenance digest | no partition- or installation-broadened duplicate effect; no silent overwrite | Data Correctness Owner |
| Typed fact store | Store minimized typed immutable facts with explicit provenance and interpretation | no endpoint SQL, generic mutable payload as normal model, or cross-realm key | Data Platform |
| Projection worker/contribution ledger | Rebuild/idempotently apply facts to aggregates and views with one contribution effect | no fact mutation or projection readiness as receipt authority | Projection/Data Product Owner |
| Integration outbox worker | Deliver governed typed messages at least once; preserve stable message identity and destination state | no network I/O inside fact transaction; no unregistered destination; no downstream ACK as custody/fact authority | Integration Owner |
| Reconciler | Prove receipt→custody→one terminal batch outcome, event→one effect, projection/outbox completeness, and restore readiness | no invented custody/fact, automatic destructive repair, or suppressed unexplained finding | Data Reliability / Verification |
| Database benchmark harness | Drive identical semantics/workload/faults against both candidates; collect raw and normalized evidence; enforce hard gates | no engine-specific expected answer, unequal durability/hardware/workload, hidden retries, or score after hard failure | Database Reliability + Architecture |
| Fleet simulator | Compile T1 scenarios; schedule stateful actors and open arrivals; reuse production wire; preserve truth; inject declared faults | no production data/secrets, test-only codec, fabricated receipt, wall-clock randomness, or hidden generator drops | Capacity/Test Architecture |
| Fault controller | Apply only preregistered lab faults to disposable infrastructure and record exact timing/evidence | no production route/artifact, arbitrary scenario shell/SQL, shared destructive credential, or truth-ledger mutation | Reliability Test Owner |
| Lifecycle API | Authenticate/admin-authorize, enforce strict idempotent command, derive realm, expose truthful case status | no fuzzy lookup, arbitrary SQL/path/destination, synchronous all-store completion, or legal outcome decision | Lifecycle Engineering + IAM |
| Retention policy registry | Hold immutable product/realm purpose-field-store-destination revisions and age/action semantics | no invented period, executable tenant logic, or broadening product ceiling | Records/Privacy/Product Governance |
| Subject resolution service | Resolve approved typed selectors to exact same-realm subject projection manifest | no names/fragments/fuzzy/activity inference, cross-realm widening, or silent later expansion | Data Governance + IAM |
| Lifecycle controller | Own deletion/retention case state, deterministic target graph, leases, retries, evidence, and limitations | no direct untyped store mutation, hold bypass, or barrier removal after destructive work | Lifecycle Engineering |
| Tombstone ledger | Append monotonic realm sequences, expose current authority/watermark, detect gap/fork/rollback, support independent recovery | no raw selector/source values or general audit payload | Data Reliability + Security |
| Visibility guard | Enforce tombstones/realm visibility epoch at BFF/repositories and derived-reader eligibility | no stale cache/search/replica eligibility or query bypass | API/Data Platform |
| Store adapter | Typed prepare/delete/verify for one store class under stable idempotency | no caller SQL, scripts, arbitrary paths, or claim about another store | Store owner |
| Legal-hold registry | Preserve immutable scoped authority references and block destruction/expiry while maintaining suppression | no ordinary read/export grant or legal-validity decision | Legal/Records technical custodian |
| Connector/export registry | Record destination purpose, owner, object manifests, deletion capability/contract, receipt semantics, and recipient limitations | no unregistered egress, inferred recipient deletion, or destination URL from tenant input | Integration Owner + Privacy |
| Backup catalogue | Inventory chain, copies, object versions, keys, log/PITR range, realm scope, tombstone/receipt watermarks, holds, expiry, test-restore evidence | no expiry from timestamp alone or unknown copy/key assumption | SRE/Data Reliability |
| Restore orchestrator | Create isolated environment, restore, verify, replay tombstones/ACKs, rebuild derivatives, evaluate readiness, clean up | no ordinary read, egress, receipt authority, or routing before readiness | SRE + Security + Data Reliability |
| Minimal audit ledger | Preserve actor/authority/action/state/target-class/count/digest/time for privileged changes | no raw selector, activity payload, URL, arbitrary exception, or indefinite blanket retention | Security/Governance |
| Evidence packager/gate evaluator | Produce content-addressed privacy-safe run/case evidence, preserve first failure, apply zero-tolerance and human-bound gates | no credentials/addresses/raw data, mutable pass, hidden excluded run, or performance waiver of invariant | Verification Governance |

## 5.2 Trust-boundary flows

### 5.2.1 Ingestion and materialization

```text
untrusted network request
  -> TLS / approved gateway identity validation
  -> immutable AuthenticatedDeviceContext
  -> strict route/header/media/encoding/bounds/digest/envelope validation
  -> one relational custody transaction:
       immutable ingest_batch
       + exact ingest_payload
       + immutable custody_receipt
       + mutable ingest_work seed
  -> COMMIT in declared failure domain
  -> receipt response (or response loss)
  -> same-batch replay/status reconciliation
  -> bounded fair lease transaction
  -> parse/semantic validation outside transaction
  -> one final fenced transaction:
       event identity classification
       + typed facts or terminal quarantine occurrence
       + projection work
       + integration outbox
       + terminal batch state
  -> reconciliation
```

### 5.2.2 Capacity and database comparison

```text
T1 scenario + approved aggregate distributions
  -> strict scenario compiler / immutable run plan / root seed
  -> stateful fleet scheduler + independent open-arrival scheduler
  -> load agents using exact production wire client
  -> network/database/process/storage fault boundary
  -> exact server build + one engine profile
  -> query/report/maintenance/backup workload
  -> independent oracle and restricted exact truth ledger
  -> finite metadata evidence + engine-native snapshots
  -> cleanup/revert
  -> same run plan against paired engine profile
  -> semantic gates before performance/TCO analysis
```

### 5.2.3 Lifecycle and restore

```text
authenticated privileged command
  -> strict deletion/retention contract
  -> exact same-realm subject/scope resolution manifest
  -> policy / rights / hold authority checks
  -> one barrier transaction:
       deletion case revision
       + monotonic suppression tombstone(s)
       + realm visibility epoch/watermark
       + deterministic store/connector/export targets
       + integration deletion outbox
       + minimal audit event
  -> all ordinary readers suppress or become ineligible
  -> leased typed delete/verify adapters
  -> truthful COMPLETE / PARTIAL_HELD / COMPLETE_WITH_LIMITATIONS

backup restore
  -> new isolated environment identity
  -> no ordinary reads, exports, connectors, endpoint receipts, or routing
  -> base + log/PITR recovery
  -> engine/schema/realm/manifest verification
  -> current tombstone recovery/replay with no gap/fork
  -> authoritative receipt-set comparison and stable replay
  -> derived facts/aggregates/search/cache/replica rebuild under visibility guard
  -> deleted-negative and acknowledged-positive probes
  -> durable readiness decision
  -> separate audited read/routing enablement
```

## 5.3 Common contract profile

Every HTTP, persistence, job, deletion, connector, backup, restore, audit, simulator, and evidence contract MUST record:

```text
contract name and exact version
producer and required consumers
accountable owner and support owner
authenticated authority and realm source
privacy stage and permitted fields
strict structural schema and local-reference closure
identifier, digest, time, Unicode, enum and null/optional rules
compressed/uncompressed/item/depth/string/time/allocation limits
idempotency and immutable identity
transaction/commit/receipt meaning
state preconditions and terminal outcomes
retry/ambiguity/conflict rules
compatibility, rollout, rollback and deprecation
audit, logs, metrics and diagnostic allowlist
valid, boundary, invalid, adversarial and old/new vectors
runbook, evidence, dependency and cleanup requirements
```

Common rules:

- JSON boundaries use strict UTF-8, closed objects, no duplicate members, unknown authority-bearing fields, implicit defaults, generic extension bags, remote references, executable type names, or unbounded values.
- New UAM IDs use canonical lower-case UUIDv7 text; UUID timestamp bits are never business time, ordering, authorization, or evidence precision.
- SHA-256 is the current content/evidence digest profile; algorithm agility is explicit and no receiver guesses from length.
- Realm and installation authority are structurally absent from untrusted request bodies where authenticated context supplies them.
- HTTP errors use finite privacy-safe problem details. They do not echo identifiers, payloads, digests, certificate data, SQL, or dynamic exception text.
- Every production contract profile is tied to a consumer-first compatibility matrix and exact release manifest.

## 5.4 Core interface contracts

### 5.4.1 Authenticated device context

```text
AuthenticatedDeviceContext {
  realm_id
  installation_id
  enrollment_epoch
  credential_id
  credential_generation
  assurance_level
  credential_status
  status_version
  issuer_id
  trust_domain_id
  authenticated_at_utc
}
```

The context is server-created and immutable for the operation. Body, route, query, forwarding header, certificate subject/SAN, host, IP, SID, or device label cannot create or override it.

### 5.4.2 Ingest batch command

```json
{
  "contract": "uam.server.ingest-batch-command",
  "version": "1.0.0",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "batchContractVersion": "1.0.0",
  "eventContractVersion": "1.0.0",
  "contentEncodingProfile": "PROVISIONAL_PROFILE_V1",
  "eventCount": 128,
  "uncompressedBytes": 65536,
  "compressedBytes": 8192,
  "batchContentDigest": "sha-256:fictional-content",
  "wireContentDigest": "sha-256:fictional-wire",
  "exactBodyRef": "request-owned-bounded-bytes"
}
```

`exactBodyRef` is conceptual; production accepts bounded request bytes, never a client-supplied filesystem/object path. Realm and installation are not authority-bearing body fields.

### 5.4.3 Custody receipt

```json
{
  "contract": "uam.server.custody-receipt",
  "version": "1.0.0",
  "receiptId": "019d0000-0000-7000-8000-000000000201",
  "batchId": "019d0000-0000-7000-8000-000000000101",
  "batchContentDigest": "sha-256:fictional-content",
  "wireContentDigest": "sha-256:fictional-wire",
  "custodyState": "DURABLY_RECEIVED",
  "failureDomainClass": "DECLARED_RELATIONAL_DOMAIN_V1",
  "durableAtUtc": "2026-08-01T12:00:00Z",
  "receiptContractVersion": "1.0.0"
}
```

A response is a valid receipt only when authenticated response context, batch ID, both digests, contract version, state, and approved failure-domain class match the committed rows. Replay returns the original receipt or an explicitly equivalent immutable proof.

### 5.4.4 Work lease

```json
{
  "contract": "uam.server.work-lease",
  "version": "1.0.0",
  "workKey": {
    "realmAlias": "fictional-realm-a",
    "installationAlias": "fictional-installation-001",
    "batchId": "019d0000-0000-7000-8000-000000000101"
  },
  "leaseToken": "019d0000-0000-7000-8000-000000000301",
  "leaseFence": 7,
  "leaseOwnerClass": "MATERIALIZER",
  "leasedAtUtc": "2026-08-01T12:00:01Z",
  "leaseUntilUtc": "2026-08-01T12:00:31Z"
}
```

Human-readable evidence uses fictional aliases. Production contracts use opaque IDs. Final commit requires the exact work key, token, fence, allowed state, and database-time validity or a stronger engine-native fence.

### 5.4.5 Deletion request and status

```json
{
  "contract": "uam.lifecycle.deletion-request",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000001801",
  "caseType": "SUBJECT_ERASURE",
  "selector": {
    "type": "SUBJECT_PROJECTION_ID",
    "value": "019d0000-0000-7000-8000-000000001802"
  },
  "requestedScope": ["ACTIVITY_FACTS", "DERIVED_AGGREGATES", "EXPORTS", "GOVERNED_INTEGRATIONS"],
  "authorityReference": "fictional-authority-reference",
  "reasonCode": "RIGHTS_REQUEST_APPROVED"
}
```

Authenticated context supplies realm and actor. The contract cannot express a name, fuzzy rule, SQL, path, arbitrary field, store, or destination.

```json
{
  "contract": "uam.lifecycle.case-status",
  "version": "1.0.0",
  "caseId": "019d0000-0000-7000-8000-000000001803",
  "state": "BARRIER_COMMITTED",
  "visibilityState": "SUPPRESSED",
  "targetSummary": {
    "pending": 8,
    "verified": 3,
    "held": 0,
    "externalActionRequired": 1
  },
  "limitations": ["UNCONTROLLED_RECIPIENT_COPY"]
}
```

A `202 Accepted` response means a durable lifecycle case exists; it never means deletion complete.

### 5.4.6 Restore-readiness decision

```json
{
  "contract": "uam.restore.readiness-decision",
  "version": "1.0.0",
  "restoreRunId": "019d0000-0000-7000-8000-000000001840",
  "restoredEnvironmentId": "019d0000-0000-7000-8000-000000001841",
  "decision": "READY",
  "checks": {
    "backupIntegrity": "PASS",
    "engineRecovery": "PASS",
    "schemaAndRealm": "PASS",
    "tombstoneContinuity": "PASS",
    "acknowledgedCoverage": "PASS",
    "deletedSubjectNegativeProbes": "PASS",
    "acknowledgedEventPositiveProbes": "PASS",
    "derivedStoreWatermarks": "PASS",
    "connectorAndExportEgressDisabled": "PASS",
    "auditAvailable": "PASS",
    "privacyCanaryScan": "PASS"
  },
  "authoritativeTombstoneDigest": "sha-256:fictional",
  "restoredTombstoneDigest": "sha-256:fictional",
  "authoritativeReceiptSetDigest": "sha-256:fictional",
  "restoredReceiptSetDigest": "sha-256:fictional",
  "evidenceDigest": "sha-256:fictional",
  "decidedAtUtc": "2026-08-01T14:00:00Z"
}
```

The evaluator derives `READY`; an endpoint, operator checkbox, database tool, or backup tool cannot submit it as authority. `READY` is a technical state; production routing/read enablement is a separate audited action.

## 5.5 Normative logical relational schema

Physical data types, indexes, partitioning, compression, RLS, lock syntax, bulk APIs, and generated columns are engine-adapter decisions. The following keys, immutability, constraints, transaction boundaries, and state meanings are normative.

### 5.5.1 Immutable custody and mutable work separation

```sql
CREATE TABLE ingest_batch (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    enrollment_epoch            BIGINT        NOT NULL,
    credential_generation       BIGINT        NOT NULL,
    batch_contract_version      VARCHAR(32)   NOT NULL,
    event_contract_version      VARCHAR(32)   NOT NULL,
    content_encoding_profile    VARCHAR(48)   NOT NULL,
    event_count                 BIGINT        NOT NULL,
    uncompressed_bytes          BIGINT        NOT NULL,
    compressed_bytes            BIGINT        NOT NULL,
    batch_content_digest        BINARY_32     NOT NULL,
    wire_content_digest         BINARY_32     NOT NULL,
    received_at_utc             TIMESTAMP_UTC NOT NULL,
    custody_domain_class        VARCHAR(64)   NOT NULL,
    row_content_digest          BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    CHECK (event_count >= 0),
    CHECK (uncompressed_bytes >= 0),
    CHECK (compressed_bytes >= 0)
);

CREATE TABLE ingest_payload (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    payload_storage_class       VARCHAR(48)   NOT NULL,
    exact_wire_bytes            BINARY_LARGE  NULL,
    object_manifest_token       BINARY_32     NULL,
    wire_content_digest         BINARY_32     NOT NULL,
    compressed_bytes            BIGINT        NOT NULL,
    content_encoding_profile    VARCHAR(48)   NOT NULL,
    payload_state               VARCHAR(24)   NOT NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    purged_at_utc               TIMESTAMP_UTC NULL,
    purge_evidence_id           UUID          NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK (payload_state IN ('PRESENT','PURGE_ELIGIBLE','PURGED','HOLD')),
    CHECK (
      (payload_state <> 'PURGED' AND exact_wire_bytes IS NOT NULL AND purged_at_utc IS NULL)
      OR
      (payload_state = 'PURGED' AND exact_wire_bytes IS NULL AND purged_at_utc IS NOT NULL)
      OR
      (payload_storage_class <> 'RELATIONAL_INLINE_V1' AND object_manifest_token IS NOT NULL)
    )
);

CREATE TABLE custody_receipt (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    receipt_id                  UUID          NOT NULL,
    receipt_contract_version    VARCHAR(32)   NOT NULL,
    batch_content_digest        BINARY_32     NOT NULL,
    wire_content_digest         BINARY_32     NOT NULL,
    custody_state               VARCHAR(24)   NOT NULL,
    failure_domain_class        VARCHAR(64)   NOT NULL,
    durable_at_utc              TIMESTAMP_UTC NOT NULL,
    receipt_content_digest      BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, receipt_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK (custody_state = 'DURABLY_RECEIVED')
);

CREATE TABLE ingest_work (
    realm_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    received_sequence           BIGINT        NOT NULL,
    fairness_class              VARCHAR(32)   NOT NULL,
    state                       VARCHAR(40)   NOT NULL,
    processing_generation       BIGINT        NOT NULL,
    available_at_utc            TIMESTAMP_UTC NOT NULL,
    automatic_attempt_count     BIGINT        NOT NULL,
    lease_owner_id              UUID          NULL,
    lease_token                 UUID          NULL,
    lease_fence                 BIGINT        NOT NULL,
    lease_acquired_at_utc       TIMESTAMP_UTC NULL,
    lease_heartbeat_at_utc      TIMESTAMP_UTC NULL,
    lease_expires_at_utc        TIMESTAMP_UTC NULL,
    terminal_reason_code        VARCHAR(64)   NULL,
    terminal_at_utc             TIMESTAMP_UTC NULL,
    new_event_count             BIGINT        NULL,
    replay_event_count          BIGINT        NULL,
    fact_count                  BIGINT        NULL,
    row_version                 BIGINT        NOT NULL,
    PRIMARY KEY (realm_id, installation_id, batch_id),
    UNIQUE (realm_id, received_sequence),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id),
    CHECK (processing_generation >= 1),
    CHECK (automatic_attempt_count >= 0),
    CHECK (lease_fence >= 0),
    CHECK (state IN (
      'RECEIVED','LEASED','RETRY_WAIT','MATERIALIZED',
      'QUARANTINED_TERMINAL','REPROCESS_PENDING','SAFETY_HOLD'))
);
```

Normative immutability rules:

- identity, contract, digest, size, received-time, custody-domain, and receipt fields cannot be updated after insert;
- only the designated custody role can create a receipt, and only inside the acceptance transaction;
- the work role cannot update custody or receipt rows;
- payload purge is a separately authorized lifecycle transition and never deletes batch/receipt identity;
- an object-storage payload class is not representable until its own atomic custody ADR passes.

### 5.5.2 Conflicts, attempts, quarantine, and reprocess

```sql
CREATE TABLE ingest_batch_conflict (
    realm_id                    UUID          NOT NULL,
    conflict_id                 UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    conflict_code               VARCHAR(64)   NOT NULL,
    expected_batch_digest       BINARY_32     NOT NULL,
    observed_batch_digest       BINARY_32     NOT NULL,
    expected_wire_digest        BINARY_32     NOT NULL,
    observed_wire_digest        BINARY_32     NOT NULL,
    authenticated_credential_id UUID          NOT NULL,
    observed_at_utc             TIMESTAMP_UTC NOT NULL,
    operation_token             UUID          NOT NULL,
    PRIMARY KEY (realm_id, conflict_id),
    FOREIGN KEY (realm_id, installation_id, batch_id)
      REFERENCES ingest_batch(realm_id, installation_id, batch_id)
);

CREATE TABLE processing_attempt (
    realm_id                    UUID          NOT NULL,
    attempt_id                  UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    processing_generation       BIGINT        NOT NULL,
    attempt_sequence            BIGINT        NOT NULL,
    lease_fence                 BIGINT        NOT NULL,
    processor_profile_id        VARCHAR(96)   NOT NULL,
    started_at_utc              TIMESTAMP_UTC NOT NULL,
    completed_at_utc            TIMESTAMP_UTC NULL,
    outcome                     VARCHAR(32)   NOT NULL,
    safe_error_code             VARCHAR(64)   NULL,
    plan_digest                 BINARY_32     NULL,
    evidence_digest             BINARY_32     NULL,
    PRIMARY KEY (realm_id, attempt_id),
    UNIQUE (realm_id, installation_id, batch_id, processing_generation, attempt_sequence)
);

CREATE TABLE quarantine_occurrence (
    realm_id                    UUID          NOT NULL,
    quarantine_id               UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    processing_generation       BIGINT        NOT NULL,
    reason_family               VARCHAR(48)   NOT NULL,
    reason_code                 VARCHAR(64)   NOT NULL,
    failing_stage               VARCHAR(48)   NOT NULL,
    processor_profile_id        VARCHAR(96)   NOT NULL,
    event_contract_version      VARCHAR(32)   NOT NULL,
    safe_expected_digest        BINARY_32     NULL,
    safe_observed_digest        BINARY_32     NULL,
    first_observed_at_utc       TIMESTAMP_UTC NOT NULL,
    terminal_at_utc             TIMESTAMP_UTC NOT NULL,
    reprocess_eligibility       VARCHAR(32)   NOT NULL,
    legal_hold_state            VARCHAR(24)   NOT NULL,
    content_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, quarantine_id),
    UNIQUE (realm_id, installation_id, batch_id, processing_generation)
);

CREATE TABLE reprocess_command (
    realm_id                    UUID          NOT NULL,
    reprocess_id                UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    prior_processing_generation BIGINT        NOT NULL,
    new_processing_generation   BIGINT        NOT NULL,
    target_processor_profile_id VARCHAR(96)   NOT NULL,
    authority_reference         VARCHAR(160)  NOT NULL,
    requested_by_principal_id   UUID          NOT NULL,
    approved_by_principal_id    UUID          NOT NULL,
    requested_at_utc            TIMESTAMP_UTC NOT NULL,
    command_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, reprocess_id),
    UNIQUE (realm_id, installation_id, batch_id, new_processing_generation)
);
```

Quarantine does not contain a general raw-payload copy or arbitrary exception text. Raw custody access, if ever approved, is a separately authorized audited operation and is not required for ordinary support.

### 5.5.3 Event identity, typed facts, projections, and integrations

```sql
CREATE TABLE event_identity (
    realm_id                    UUID          NOT NULL,
    event_id                    UUID          NOT NULL,
    event_identity_id           BIGINT_GENERATED NOT NULL,
    first_installation_id       UUID          NOT NULL,
    first_batch_id              UUID          NOT NULL,
    source_natural_digest       BINARY_32     NOT NULL,
    payload_digest              BINARY_32     NOT NULL,
    effect_digest               BINARY_32     NOT NULL,
    effect_kind                 VARCHAR(32)   NOT NULL,
    first_seen_at_utc           TIMESTAMP_UTC NOT NULL,
    interpretation_digest       BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, event_id),
    UNIQUE (realm_id, event_identity_id),
    CHECK (effect_kind IN ('FACT','CONSUMED_NO_EVENT'))
);

CREATE TABLE activity_fact (
    realm_id                    UUID          NOT NULL,
    fact_partition_time         TIMESTAMP_UTC NOT NULL,
    event_identity_id           BIGINT        NOT NULL,
    event_id                    UUID          NOT NULL,
    installation_id             UUID          NOT NULL,
    batch_id                    UUID          NOT NULL,
    fact_type                   VARCHAR(64)   NOT NULL,
    output_profile_id           VARCHAR(64)   NOT NULL,
    interpretation_digest       BINARY_32     NOT NULL,
    materialized_at_utc         TIMESTAMP_UTC NOT NULL,
    fact_content_digest         BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, fact_partition_time, event_identity_id),
    FOREIGN KEY (realm_id, event_identity_id)
      REFERENCES event_identity(realm_id, event_identity_id)
) PARTITION_BY_CANDIDATE (fact_partition_time);

CREATE TABLE projection_work (
    realm_id                    UUID          NOT NULL,
    projection_work_id          UUID          NOT NULL,
    projection_id               UUID          NOT NULL,
    projection_version          BIGINT        NOT NULL,
    event_identity_id           BIGINT        NOT NULL,
    state                       VARCHAR(32)   NOT NULL,
    available_at_utc            TIMESTAMP_UTC NOT NULL,
    lease_token                 UUID          NULL,
    lease_fence                 BIGINT        NOT NULL,
    lease_expires_at_utc        TIMESTAMP_UTC NULL,
    row_version                 BIGINT        NOT NULL,
    PRIMARY KEY (realm_id, projection_work_id),
    UNIQUE (realm_id, projection_id, projection_version, event_identity_id)
);

CREATE TABLE projection_contribution (
    realm_id                    UUID          NOT NULL,
    projection_id               UUID          NOT NULL,
    projection_version          BIGINT        NOT NULL,
    aggregate_key_digest        BINARY_32     NOT NULL,
    event_identity_id           BIGINT        NOT NULL,
    contribution_digest         BINARY_32     NOT NULL,
    applied_at_utc              TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (
      realm_id, projection_id, projection_version,
      aggregate_key_digest, event_identity_id)
);

CREATE TABLE integration_outbox (
    realm_id                    UUID          NOT NULL,
    integration_message_id      UUID          NOT NULL,
    destination_id              UUID          NOT NULL,
    destination_revision        BIGINT        NOT NULL,
    source_event_id             UUID          NOT NULL,
    contract_version            VARCHAR(32)   NOT NULL,
    message_content_digest      BINARY_32     NOT NULL,
    state                       VARCHAR(32)   NOT NULL,
    attempt_count               BIGINT        NOT NULL,
    next_attempt_at_utc         TIMESTAMP_UTC NULL,
    terminal_receipt_digest     BINARY_32     NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, integration_message_id),
    UNIQUE (realm_id, destination_id, destination_revision, source_event_id)
);
```

The concrete first fact fields remain a **HUMAN DECISION**. Test facts use wholly fictional site/application/time values and must satisfy the accepted pre-transport privacy ceiling.

### 5.5.4 Retention, subject resolution, deletion cases, and tombstones

```sql
CREATE TABLE retention_policy_revision (
    realm_id                    UUID          NULL,
    policy_id                   UUID          NOT NULL,
    revision                    BIGINT        NOT NULL,
    status                      VARCHAR(24)   NOT NULL,
    purpose_id                  VARCHAR(96)   NOT NULL,
    data_product_id             VARCHAR(96)   NOT NULL,
    record_class                VARCHAR(96)   NOT NULL,
    field_group_id              VARCHAR(96)   NOT NULL,
    store_class                 VARCHAR(64)   NOT NULL,
    age_basis                   VARCHAR(40)   NOT NULL,
    duration_expression         VARCHAR(64)   NULL,
    action                      VARCHAR(48)   NOT NULL,
    legal_hold_mode             VARCHAR(32)   NOT NULL,
    product_ceiling_revision    BIGINT        NOT NULL,
    tenant_narrowing_digest     BINARY_32     NULL,
    effective_at_utc            TIMESTAMP_UTC NOT NULL,
    expires_at_utc              TIMESTAMP_UTC NULL,
    authority_reference         VARCHAR(160)  NOT NULL,
    accountable_role            VARCHAR(96)   NOT NULL,
    content_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, policy_id, revision)
);

CREATE TABLE legal_hold_revision (
    realm_id                    UUID          NOT NULL,
    legal_hold_id               UUID          NOT NULL,
    revision                    BIGINT        NOT NULL,
    status                      VARCHAR(24)   NOT NULL,
    scope_type                  VARCHAR(32)   NOT NULL,
    scope_manifest_digest       BINARY_32     NOT NULL,
    authority_reference         VARCHAR(160)  NOT NULL,
    effective_at_utc            TIMESTAMP_UTC NOT NULL,
    released_at_utc             TIMESTAMP_UTC NULL,
    requested_by_principal_id   UUID          NOT NULL,
    approved_by_principal_id    UUID          NOT NULL,
    content_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, legal_hold_id, revision)
);

CREATE TABLE deletion_case (
    realm_id                    UUID          NOT NULL,
    case_id                     UUID          NOT NULL,
    case_type                   VARCHAR(32)   NOT NULL,
    idempotency_key_digest      BINARY_32     NOT NULL,
    state                       VARCHAR(40)   NOT NULL,
    state_version               BIGINT        NOT NULL,
    requested_at_utc            TIMESTAMP_UTC NOT NULL,
    authorized_at_utc           TIMESTAMP_UTC NULL,
    barrier_committed_at_utc    TIMESTAMP_UTC NULL,
    completed_at_utc            TIMESTAMP_UTC NULL,
    policy_id                   UUID          NULL,
    policy_revision             BIGINT        NULL,
    authority_reference         VARCHAR(160)  NULL,
    resolution_manifest_id      UUID          NULL,
    resolution_manifest_digest  BINARY_32     NULL,
    bound_tombstone_sequence    BIGINT        NULL,
    limitation_code             VARCHAR(64)   NULL,
    requested_by_principal_id   UUID          NOT NULL,
    authorized_by_principal_id  UUID          NULL,
    content_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, case_id),
    UNIQUE (realm_id, idempotency_key_digest)
);

CREATE TABLE subject_resolution_manifest (
    realm_id                    UUID          NOT NULL,
    manifest_id                 UUID          NOT NULL,
    case_id                     UUID          NOT NULL,
    resolver_profile_id         VARCHAR(96)   NOT NULL,
    resolver_version            VARCHAR(48)   NOT NULL,
    identity_source_revision    VARCHAR(96)   NOT NULL,
    selector_type               VARCHAR(64)   NOT NULL,
    selector_token              BINARY_32     NOT NULL,
    resolved_subject_count      BIGINT        NOT NULL,
    unresolved_condition        VARCHAR(64)   NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    content_digest              BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, manifest_id),
    UNIQUE (realm_id, case_id, content_digest)
);

CREATE TABLE subject_resolution_item (
    realm_id                    UUID          NOT NULL,
    manifest_id                 UUID          NOT NULL,
    subject_projection_id       UUID          NOT NULL,
    scope_class                 VARCHAR(64)   NOT NULL,
    key_range_start             BIGINT        NULL,
    key_range_end               BIGINT        NULL,
    item_digest                 BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, manifest_id, subject_projection_id, scope_class)
);

CREATE TABLE suppression_tombstone (
    realm_id                    UUID          NOT NULL,
    realm_sequence              BIGINT        NOT NULL,
    tombstone_id                UUID          NOT NULL,
    case_id                     UUID          NOT NULL,
    scope_type                  VARCHAR(32)   NOT NULL,
    scope_token                 BINARY_32     NOT NULL,
    effective_cutoff_utc        TIMESTAMP_UTC NULL,
    authority_class             VARCHAR(48)   NOT NULL,
    resolution_manifest_digest  BINARY_32     NOT NULL,
    status                      VARCHAR(24)   NOT NULL,
    supersedes_tombstone_id     UUID          NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    expires_at_utc              TIMESTAMP_UTC NULL,
    previous_chain_digest       BINARY_32     NULL,
    content_digest              BINARY_32     NOT NULL,
    chain_digest                BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, realm_sequence),
    UNIQUE (realm_id, tombstone_id),
    CHECK (realm_sequence > 0),
    CHECK (status IN ('ACTIVE','SUPERSEDED','EXPIRED'))
);

CREATE TABLE realm_visibility_state (
    realm_id                    UUID          NOT NULL PRIMARY KEY,
    visibility_epoch            BIGINT        NOT NULL,
    current_tombstone_sequence  BIGINT        NOT NULL,
    read_state                  VARCHAR(24)   NOT NULL,
    state_version               BIGINT        NOT NULL,
    updated_at_utc              TIMESTAMP_UTC NOT NULL
);
```

Tombstones contain the minimum opaque scope identity required to prevent resurrection. Raw subject selectors and correspondence remain in a separately restricted case store under their own lifecycle.

### 5.5.5 Deletion targets, connectors, and exports

```sql
CREATE TABLE deletion_target (
    realm_id                    UUID          NOT NULL,
    target_id                   UUID          NOT NULL,
    case_id                     UUID          NOT NULL,
    target_class                VARCHAR(48)   NOT NULL,
    target_locator_token        BINARY_32     NOT NULL,
    adapter_profile_id          VARCHAR(96)   NOT NULL,
    required_for_completion     BOOLEAN       NOT NULL,
    state                       VARCHAR(40)   NOT NULL,
    state_version               BIGINT        NOT NULL,
    attempt_count               BIGINT        NOT NULL,
    next_attempt_at_utc         TIMESTAMP_UTC NULL,
    lease_owner_id              UUID          NULL,
    lease_token                 UUID          NULL,
    lease_fence                 BIGINT        NOT NULL,
    lease_expires_at_utc        TIMESTAMP_UTC NULL,
    terminal_reason_code        VARCHAR(64)   NULL,
    delete_evidence_digest      BINARY_32     NULL,
    verify_evidence_digest      BINARY_32     NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    updated_at_utc              TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, target_id),
    UNIQUE (realm_id, case_id, target_class, target_locator_token)
);

CREATE TABLE deletion_attempt (
    realm_id                    UUID          NOT NULL,
    attempt_id                  UUID          NOT NULL,
    target_id                   UUID          NOT NULL,
    attempt_sequence            BIGINT        NOT NULL,
    idempotency_key             VARCHAR(180)  NOT NULL,
    adapter_version             VARCHAR(48)   NOT NULL,
    started_at_utc              TIMESTAMP_UTC NOT NULL,
    completed_at_utc            TIMESTAMP_UTC NULL,
    outcome                     VARCHAR(32)   NOT NULL,
    safe_error_code             VARCHAR(64)   NULL,
    request_digest              BINARY_32     NOT NULL,
    response_digest             BINARY_32     NULL,
    evidence_digest             BINARY_32     NULL,
    PRIMARY KEY (realm_id, attempt_id),
    UNIQUE (realm_id, target_id, attempt_sequence),
    UNIQUE (realm_id, idempotency_key)
);

CREATE TABLE connector_registry_revision (
    realm_id                    UUID          NOT NULL,
    connector_id                UUID          NOT NULL,
    revision                    BIGINT        NOT NULL,
    status                      VARCHAR(24)   NOT NULL,
    destination_class           VARCHAR(64)   NOT NULL,
    purpose_id                  VARCHAR(96)   NOT NULL,
    owner_role                  VARCHAR(96)   NOT NULL,
    support_role                VARCHAR(96)   NOT NULL,
    deletion_capability         VARCHAR(40)   NOT NULL,
    deletion_contract_version   VARCHAR(48)   NULL,
    receipt_profile_id          VARCHAR(96)   NULL,
    recipient_copy_class        VARCHAR(40)   NOT NULL,
    retention_policy_id         UUID          NOT NULL,
    configuration_digest        BINARY_32     NOT NULL,
    approved_at_utc             TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, connector_id, revision)
);

CREATE TABLE connector_object_manifest (
    realm_id                    UUID          NOT NULL,
    connector_id                UUID          NOT NULL,
    connector_revision          BIGINT        NOT NULL,
    source_event_id             UUID          NOT NULL,
    destination_object_token    BINARY_32     NOT NULL,
    delivery_idempotency_key    VARCHAR(180)  NOT NULL,
    delivered_at_utc            TIMESTAMP_UTC NOT NULL,
    delivery_receipt_digest     BINARY_32     NULL,
    deletion_case_id            UUID          NULL,
    deletion_state              VARCHAR(40)   NOT NULL,
    PRIMARY KEY (realm_id, connector_id, connector_revision, source_event_id),
    UNIQUE (realm_id, connector_id, destination_object_token)
);

CREATE TABLE export_manifest (
    realm_id                    UUID          NOT NULL,
    export_id                   UUID          NOT NULL,
    revision                    BIGINT        NOT NULL,
    purpose_id                  VARCHAR(96)   NOT NULL,
    subject_scope_digest        BINARY_32     NOT NULL,
    object_locator_token        BINARY_32     NOT NULL,
    object_content_digest       BINARY_32     NOT NULL,
    wrapped_key_reference       VARCHAR(160)  NOT NULL,
    recipient_copy_class        VARCHAR(40)   NOT NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    expires_at_utc              TIMESTAMP_UTC NOT NULL,
    retrieved_at_utc            TIMESTAMP_UTC NULL,
    state                       VARCHAR(32)   NOT NULL,
    deletion_evidence_digest    BINARY_32     NULL,
    PRIMARY KEY (realm_id, export_id, revision)
);
```

Release-owned deletion capability values are closed, for example `OBJECT_DELETE`, `SUBJECT_DELETE`, `BATCH_TOMBSTONE`, `OVERWRITE`, `CONTRACTUAL_ONLY`, and `NONE`. A retrieved human copy cannot be represented as technically recallable.

### 5.5.6 Backup, receipt coverage, and restore

```sql
CREATE TABLE backup_catalogue (
    backup_id                   UUID          NOT NULL PRIMARY KEY,
    environment_id              UUID          NOT NULL,
    engine_profile_id           VARCHAR(96)   NOT NULL,
    backup_type                 VARCHAR(24)   NOT NULL,
    parent_backup_id            UUID          NULL,
    chain_id                    UUID          NOT NULL,
    realm_scope_digest          BINARY_32     NOT NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    recoverable_from_utc        TIMESTAMP_UTC NULL,
    recoverable_through_utc     TIMESTAMP_UTC NULL,
    database_sequence_watermark VARCHAR(160)  NOT NULL,
    tombstone_authority_digest  BINARY_32     NOT NULL,
    receipt_set_digest          BINARY_32     NOT NULL,
    key_profile_id              VARCHAR(96)   NOT NULL,
    wrapped_key_reference       VARCHAR(160)  NOT NULL,
    manifest_digest             BINARY_32     NOT NULL,
    integrity_status            VARCHAR(24)   NOT NULL,
    last_test_restore_at_utc    TIMESTAMP_UTC NULL,
    test_restore_evidence_digest BINARY_32    NULL,
    legal_hold_count            BIGINT        NOT NULL,
    nominal_expires_at_utc      TIMESTAMP_UTC NULL,
    expiry_state                VARCHAR(32)   NOT NULL
);

CREATE TABLE backup_copy (
    backup_id                   UUID          NOT NULL,
    copy_id                     UUID          NOT NULL,
    provider_class              VARCHAR(64)   NOT NULL,
    object_locator_token        BINARY_32     NOT NULL,
    object_version_token        BINARY_32     NULL,
    state                       VARCHAR(24)   NOT NULL,
    last_inventory_at_utc       TIMESTAMP_UTC NULL,
    deletion_receipt_digest     BINARY_32     NULL,
    PRIMARY KEY (backup_id, copy_id)
);

CREATE TABLE receipt_coverage_manifest (
    coverage_manifest_id        UUID          NOT NULL PRIMARY KEY,
    realm_scope_digest          BINARY_32     NOT NULL,
    source_receipt_min_sequence VARCHAR(160)  NOT NULL,
    source_receipt_max_sequence VARCHAR(160)  NOT NULL,
    receipt_count               BIGINT        NOT NULL,
    canonical_receipt_set_digest BINARY_32    NOT NULL,
    generated_at_utc            TIMESTAMP_UTC NOT NULL,
    generator_version           VARCHAR(48)   NOT NULL,
    previous_manifest_digest    BINARY_32     NULL,
    content_digest              BINARY_32     NOT NULL
);

CREATE TABLE restore_run (
    restore_run_id              UUID          NOT NULL PRIMARY KEY,
    source_environment_id       UUID          NOT NULL,
    restored_environment_id     UUID          NOT NULL UNIQUE,
    requested_backup_id         UUID          NOT NULL,
    target_time_utc             TIMESTAMP_UTC NULL,
    state                       VARCHAR(40)   NOT NULL,
    state_version               BIGINT        NOT NULL,
    network_egress_state        VARCHAR(24)   NOT NULL,
    ordinary_read_state         VARCHAR(24)   NOT NULL,
    connector_state             VARCHAR(24)   NOT NULL,
    endpoint_receipt_state      VARCHAR(24)   NOT NULL,
    restored_tombstone_digest   BINARY_32     NULL,
    authoritative_tombstone_digest BINARY_32  NULL,
    restored_receipt_set_digest BINARY_32     NULL,
    authoritative_receipt_set_digest BINARY_32 NULL,
    readiness_evidence_digest   BINARY_32     NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    ready_at_utc                TIMESTAMP_UTC NULL,
    read_enabled_at_utc         TIMESTAMP_UTC NULL,
    destroyed_at_utc            TIMESTAMP_UTC NULL
);

CREATE TABLE restore_readiness_check (
    restore_run_id              UUID          NOT NULL,
    check_id                    VARCHAR(96)   NOT NULL,
    check_version               VARCHAR(48)   NOT NULL,
    status                      VARCHAR(24)   NOT NULL,
    observed_digest             BINARY_32     NULL,
    expected_digest             BINARY_32     NULL,
    evidence_digest             BINARY_32     NULL,
    completed_at_utc            TIMESTAMP_UTC NULL,
    PRIMARY KEY (restore_run_id, check_id)
);
```

`receipt_coverage_manifest` is derived reconciliation evidence. It cannot create, revoke, or redefine a receipt. Exact receipt rows remain authoritative and must be reproducibly enumerable for the manifest scope.

## 5.6 Transaction boundaries

### 5.6.1 Acceptance transaction

```text
1. Authenticate and freeze AuthenticatedDeviceContext outside payload semantics.
2. Validate strict route/header/media/encoding/bounds/digests/envelope.
3. BEGIN.
4. Look up (realm, installation, batch_id).
5. If absent:
     insert immutable ingest_batch;
     insert exact ingest_payload;
     create stable receipt_id and insert custody_receipt;
     insert ingest_work = RECEIVED;
     update bounded realm scheduling facts;
   If present and immutable digests/context match:
     read existing receipt; create no new custody/work/effect;
   If any immutable value conflicts:
     append conflict evidence; preserve original; create no new receipt.
6. COMMIT according to the configured failure-domain profile.
7. Only after successful COMMIT return the receipt or conflict result.
```

No semantic event validation, application lookup, fact insert, projection, integration, portal, retention, or backup operation belongs in this transaction.

### 5.6.2 Lease transaction

```text
BEGIN;
1. Select an eligible fairness class/realm and bounded work set.
2. Lock only candidate work/scheduler rows using the engine adapter.
3. Set state=LEASED, random lease_token, incremented lease_fence,
   lease owner, database-time acquired/expiry, and attempt count.
4. COMMIT and return lease rows.
```

The worker then reads immutable custody, rechecks digests, parses, validates, and builds a deterministic plan outside a transaction. Heartbeats match token/fence and have bounded frequency.

### 5.6.3 Materialization transaction

```text
BEGIN;
1. Lock work row and require exact realm/install/batch, state, token, fence,
   processing generation, processor profile, and nonexpired database-time lease.
2. Reverify batch/payload digests and deterministic plan digest.
3. For every event, classify by unique (realm_id,event_id):
     NEW
     SAME_REPLAY
     IDENTITY_CONFLICT
4. If any deterministic poison or conflict:
     insert quarantine_occurrence;
     set work QUARANTINED_TERMINAL;
     clear lease and scheduler inflight;
     COMMIT with zero new ordinary facts from this generation.
5. Otherwise:
     insert NEW event_identity rows;
     insert typed facts for NEW effects;
     record bounded provenance for SAME_REPLAY;
     insert projection_work and integration_outbox rows;
     set work MATERIALIZED with counts/digests;
     clear lease and scheduler inflight;
     COMMIT.
```

If the worker dies, either the complete transaction commits or the database rolls it back. A stale or reclaimed worker cannot commit because the fence predicate fails. Uniqueness is a second independent guard.

### 5.6.4 Lifecycle barrier transaction

```text
BEGIN;
1. Load case in authenticated realm and verify idempotency/state/version.
2. Verify exact resolution manifest, policy revision, authority, hold result,
   product ceiling, tenant narrowing, clock class, and kill switches.
3. Lock realm_visibility_state.
4. Allocate strictly increasing realm tombstone sequence(s).
5. Insert active tombstone(s) with chain/content digests.
6. Increment visibility_epoch and current_tombstone_sequence.
7. Insert deterministic deletion targets and connector/export deletion outbox.
8. Append minimal privileged audit event.
9. Move case to BARRIER_COMMITTED and bind its sequence/digests.
COMMIT;
```

A crash before commit leaves previous visibility. A crash after commit resumes the same case and never removes the barrier. Physical workers cannot make data visible.

### 5.6.5 Backup expiry transaction boundary

Backup expiry is not one database transaction across provider copies and keys. The controller MUST create a durable, idempotent work graph:

```text
EXPIRY_CANDIDATE
 -> chain/child/log/PITR dependency analysis
 -> legal-hold and replacement-recovery analysis
 -> PREPARED manifest of every copy/version/key reference
 -> delete/revoke each copy
 -> independently inventory/verify absence
 -> destroy wrapped keys only under approved order and policy
 -> record terminal evidence
```

Unknown child, copy, version, key, provider state, or replacement recovery point blocks expiry.

## 5.7 State machines

### 5.7.1 Custody and batch processing

```text
request received
  -> PRE_CUSTODY_REJECTED
  -> DURABLY_RECEIVED
       -> LEASED
          -> RETRY_WAIT -> LEASED
          -> MATERIALIZED
          -> QUARANTINED_TERMINAL
          -> SAFETY_HOLD

same batch/same digests -> original DURABLY_RECEIVED receipt
same batch/different immutable value -> IDENTITY_CONFLICT (no new receipt)
```

`DURABLY_RECEIVED` never regresses. Processing states do not rewrite the receipt.

### 5.7.2 Lease and attempt

```text
READY/RETRY_WAIT
  -> LEASED(token, fence, expiry)
       -> HEARTBEATED(same token/fence)
       -> COMMITTING(same token/fence)
       -> MATERIALIZED | QUARANTINED_TERMINAL
       -> RETRY_WAIT
lease expiry/reclaim -> new token and higher fence
stale worker -> zero-row heartbeat/commit -> discard local result
```

### 5.7.3 Quarantine and reprocess

```text
QUARANTINED_TERMINAL(generation N)
  -> HOLD / REVIEW
  -> REPROCESS_AUTHORIZED
  -> REPROCESS_PENDING(generation N+1)
  -> LEASED
      -> MATERIALIZED
      -> QUARANTINED_TERMINAL(generation N+1)
```

Prior quarantine occurrences are immutable. Reprocess never edits receipt, batch bytes, or event identity.

### 5.7.4 Deletion case

```text
DRAFT
  -> AUTHORIZED
  -> RESOLVING
       -> AMBIGUOUS / REJECTED
       -> RESOLVED
  -> BARRIER_COMMIT_PENDING
  -> BARRIER_COMMITTED
  -> EXECUTING
       -> WAITING_EXTERNAL
       -> PARTIAL_HELD
       -> EXECUTING
  -> VERIFYING
       -> EXECUTING
       -> FAILED
       -> COMPLETE
       -> COMPLETE_WITH_LIMITATIONS
```

Before the barrier, cancellation may produce `CANCELLED` with no visibility change. After the barrier, an operator may pause destruction but cannot remove suppression. `COMPLETE` is technical adapter completion, not a legal rights judgment.

### 5.7.5 Deletion target

```text
PENDING -> LEASED -> DELETE_PREPARED
  -> DELETED | NOT_PRESENT | HELD | EXTERNAL_ACTION_REQUIRED
  -> RETRY_WAIT | PERMANENT_FAILURE
DELETED / permitted NOT_PRESENT -> VERIFYING -> VERIFIED | RETRY_WAIT | PERMANENT_FAILURE
lease expiry -> same target and stable idempotency identity
```

An ambiguous external result is queried or retried using the same operation. A worker cannot aggregate the case to complete by itself.

### 5.7.6 Retention candidate

```text
POLICY_ACTIVE
  -> CANDIDATE_SCAN
  -> DRY_RUN_MANIFEST
      -> EMPTY
      -> REVIEW_REQUIRED
      -> AUTHORIZED_CANDIDATES
  -> IDEMPOTENT_DELETION_CASES
```

Unknown time, malformed age, clock uncertainty, hold ambiguity, unusual scope, or policy mismatch fails closed and never triggers permissive deletion.

### 5.7.7 Backup expiry

```text
ACTIVE
  -> EXPIRY_CANDIDATE
  -> CHAIN_AND_HOLD_ANALYSIS
      -> BLOCKED_BY_CHAIN
      -> BLOCKED_BY_HOLD
      -> REPLACEMENT_REQUIRED
  -> DELETE_PREPARED
  -> DELETE_COPIES
  -> VERIFY_INVENTORY
  -> DESTROY_KEYS_IF_APPROVED
  -> DELETED
```

### 5.7.8 Restore

```text
REQUESTED
  -> ISOLATED
  -> BASE_RESTORED
  -> ENGINE_VERIFIED
  -> TOMBSTONE_AUTHORITY_RECOVERED
  -> TOMBSTONES_REPLAYED
  -> ACK_COVERAGE_RECONCILING
  -> ACK_COVERAGE_RECONCILED
  -> DERIVED_REBUILDING
  -> DERIVED_REBUILT
  -> READINESS_VERIFYING
      -> READY
      -> READ_BLOCKED
      -> QUARANTINED
READY -> separate audited READ_ENABLE_REQUEST -> READ_ENABLED
end of drill/use -> DESTROYED + cleanup receipt
```

No automatic transition from engine recovery to readiness or from readiness to production routing exists.

## 5.8 Restore-readiness algorithm

The restore orchestrator MUST execute this order:

1. create a new environment identity, credentials, routes, DNS/service-registration state, and network policy that cannot receive endpoint traffic or reach connectors/exports;
2. restore base backup and required log/WAL/PITR sequence under the selected engine profile;
3. verify backup manifest, engine recovery, schema/migration sequence, realm scope, security roles, and expected database sequence;
4. recover the current independently protected tombstone authority and verify chain, scope, sequence continuity, no fork, and no rollback;
5. apply every post-backup active tombstone before any ordinary read or materialization path is enabled;
6. enumerate the authoritative committed receipt set for the defined realm/time scope and compare it with the restored set:

```text
missing_acknowledged = authoritative_receipts - restored_receipts
unexpected_restored  = restored_receipts - authoritative_receipts
conflicting_batches  = same (realm, installation, batch_id) with different immutable digest
```

7. replay missing exact batches from independent server custody where available; use endpoint grace copies only under approved stable-ID, clock, authorization, and cleanup policy;
8. apply tombstones during replay so a deleted event can be durably recognized/suppressed without recreating facts, aggregates, search, or integrations;
9. reconcile every receipt to exact payload and one batch terminal outcome; reconcile every materialized event to one effect;
10. rebuild facts/projections/aggregates/views/search/caches and replica eligibility under current tombstones and record source/database/tombstone watermarks;
11. run negative probes for every fictional deleted subject/scope across every ordinary reader and destination staging path;
12. run positive exact probes for every selected nondeleted acknowledged event and expected aggregate/query result;
13. prove connector/export egress remains disabled, no endpoint receipt can be issued, and no normal route can reach the environment;
14. verify privileged audit, privacy canaries, finite telemetry, first-failure evidence, and cleanup plan;
15. commit the readiness decision; only then may a separate authorized action enable ordinary reads.

Any missing/conflicting receipt, tombstone gap/fork, failed negative/positive probe, stale derived watermark, cross-realm effect, unknown copy, canary escape, or cleanup failure blocks readiness.

## 5.9 Realm isolation, roles, and secure coding

1. Every business primary key, foreign key, unique key, cache namespace, lease, job, tombstone sequence, export/connector manifest, and audit event begins with or is cryptographically bound to authenticated `realm_id`, except explicitly global release metadata.
2. Endpoints never receive database credentials or submit SQL.
3. Runtime roles are separated at least into custody/API, materializer, projection, integration, lifecycle controller, store adapters, reconciler, backup/restore, control API, and migrator.
4. Dynamic SQL identifiers are release-owned allowlist entries. Values are parameterized. Tenant/operator configuration cannot supply SQL, paths, scripts, arbitrary endpoints, serializer types, queue names, or executable expressions.
5. RLS policies, where used, are forced against nonowner runtime roles and are tested with pooling, retries, cancellation, prepared commands, security-definer/`EXECUTE AS` modules, cross-database access, and privileged bypass roles.
6. A connection cannot execute a realm query before authenticated context is set and verified. Pool return/exception paths cannot leak realm context.
7. Delete/sweep operations have dry-run manifests, target-set guards, lock/time/resource budgets, kill switches, and independently implemented verification queries.
8. Migration is explicit, signed/release-owned, expand/backfill/contract, crash-resumable, compatibility-tested, and never an uncontrolled application-startup mutation.
9. Direct database administration that can bypass lifecycle/realm controls is privileged, auditable, separated, and covered by incident/reconciliation runbooks.
10. Test fault controllers, destructive credentials, lab CAs, fixtures, and production-wire simulators are structurally absent from production artifacts/SBOMs.

## 5.10 Feature flags and kill switches

All flags are finite, release-owned, narrowing-only, auditable, and cannot bypass hard invariants.

| Control | Safe effect |
|---|---|
| `ingestion.accept.enabled` | Reject new custody; never issue receipt while disabled. |
| `materializer.lease.enabled` | Stop new leases; preserve existing custody. |
| `materializer.commit.enabled` | Prevent terminal materialization; active workers safely requeue/hold. |
| `projection.<id>.enabled` | Stop/rebuild one projection without changing facts/receipts. |
| `integration.<destination>.enabled` | Stop egress and retain outbox obligations. |
| `lifecycle.intake.enabled` | Stop new cases; preserve existing barriers/status. |
| `lifecycle.physical-delete.enabled` | Pause destruction; never restore visibility. |
| `lifecycle.connector-delete.enabled` | Pause external calls; preserve obligations. |
| `lifecycle.retention-sweep.enabled` | Stop automatic candidate creation. |
| `lifecycle.backup-expiry.enabled` | Stop copy/key destruction. |
| `realm.read-block` | Deny ordinary reads/exports for one realm. |
| `global.integration-egress-kill` | Stop all connector/export sends without dropping work. |
| `restore.readiness-evaluation.enabled` | Prevent `READY`; cannot force it. |
| `restore.read-enable.enabled` | Prevent routing/read enablement; cannot bypass failed readiness. |
| `broker.prototype.enabled` | Test-only and off; cannot change production custody without ADR. |

## 5.11 Observability, evidence, and accessibility

Allowed metric dimensions are fixed finite classes such as component, operation family, stage, outcome family, error family, contract major, batch-size bucket, backlog-age bucket, fairness class, engine profile, database wait class, fault class, connector capability class, backup-chain class, restore check, and build ring.

Forbidden ordinary metric labels/log fields include realm/device/installation/batch/event/receipt/subject/case/export/backup IDs; user/SID/session; URL/host/path/application/source; certificate fields; IP/address/proxy; SQL parameters; object keys; payload/digest values; and arbitrary exception text.

Exact fictional IDs are permitted only in the restricted run/case truth store and are replaced by run-scoped ordinals or opaque aliases in shareable evidence. Every evidence package contains:

```text
source/release/schema/contract/policy/adapter digests
engine/topology/OS/storage/network profile
fixture/scenario/oracle/root seed digests
fault schedule and actual fault timeline
offered/started/delayed/dropped/completed load evidence
receipt, terminal outcome, event effect and realm reconciliation
query/maintenance/backup/restore/failover evidence
tombstone and receipt-set authority digests
negative deleted and positive acknowledged probe results
first failure and all reruns
privacy-canary and cardinality results
owners, ADRs, exceptions and expiry
cleanup/revert receipt
```

Administrative status must be keyboard operable, programmatically exposed, announced when asynchronous state changes, and expressed in text—not color alone. Status terms such as `DURABLY_RECEIVED`, `MATERIALIZED`, `QUARANTINED`, `SUPPRESSED`, `DELETED`, `HELD`, `EXTERNAL_ACTION_REQUIRED`, `COMPLETE_WITH_LIMITATIONS`, `READ_BLOCKED`, and `READY` must have plain-language definitions that do not overstate legal or technical completion.

---

# 6. Human decision register

Research does not approve the following matters. Accountable names are role functions, not invented assignments.

| ID | Human decision | Accountable role/function | Consequence of delay | Earliest blocked work |
|---|---|---|---|---|
| HD04-01 | Legal/business purpose, lawful basis, prohibited uses, and whether UAM is an appropriate processing activity | Data Controller / Business Product Owner with Legal and Privacy | no live activity, production retention, rights outcome, pilot, or production use | production-shaped data and deployment |
| HD04-02 | Employee consultation, notices, workforce governance, and prohibited productivity/disciplinary uses | Employee Relations / Works Council authority with Legal/Privacy | workforce pilot and production remain prohibited | pilot/production |
| HD04-03 | Production event fields, subject/identity projection, site/domain representation, and time precision | Product/Data Owner with Privacy and Security | fact schemas, resolver scope, reports, and lifecycle obligations cannot be approved | active contracts and policy |
| HD04-04 | Authoritative subject-resolution selectors and identity sources | Data Governance/IAM with Legal/Privacy | subject deletion cannot be authorized safely; only fictional resolver tests proceed | production lifecycle cases |
| HD04-05 | Rights-request assessment, exceptions, deadlines, response language, and evidence burden | Data Controller/Legal/Privacy | technical case cannot be presented as legal completion | rights workflow/production deletion |
| HD04-06 | Purpose-specific retention periods, age bases, start conditions, and review triggers by field/store/destination | Records Management/Data Controller/Privacy | production retention policy remains disabled; storage/cost projections remain provisional | retention sweep, storage sizing |
| HD04-07 | Legal-hold authority, scope, access, review, release, conflict, and evidence policy | Legal/Records with Security | hold registry can be prototyped but no production destruction or expiry | production retention/deletion/backup expiry |
| HD04-08 | Audit purpose, fields, access, immutability, retention, and separation of duties | Security/Governance/Records | privileged lifecycle/reprocess/restore cannot be production-approved | control API and production admin |
| HD04-09 | Raw custody/quarantine access, if any, including roles, dual approval, purpose, and retention | Data Controller/Privacy/Security | support must remain metadata-only; unresolved cases may require narrower support promise | production support/reprocess |
| HD04-10 | Receipt failure domain and which correlated failures are inside/outside `DURABLY_RECEIVED` | Product Risk/Data Owner/SRE/Data Reliability | no production cleanup-eligible receipt class; endpoints retain payload | production ingestion and endpoint cleanup |
| HD04-11 | SLO, error budget, RPO, RTO, maximum outage, recovery target, and service criticality | Product/Operations/SRE/Risk | capacity and database results have no acceptance thresholds; no production topology | B04-DB/CAP and production |
| HD04-12 | Endpoint ACK grace, clock confidence, minimum replay source, cleanup horizon, and loss handling | Product Risk/Data Owner/Endpoint Reliability/Records | production endpoint cleanup remains disabled | endpoint cleanup after ACK |
| HD04-13 | Production database engine, edition/service, OS, topology, HA/DR, support provider, and strategic platform fit | Architecture/Product/Operations/Procurement | only paired prototypes; no production schema/tuning/topology commitment | production platform selection |
| HD04-14 | Database licensing interpretation, passive/readable replicas, cores, service tiers, support, and three-year TCO | Procurement/Legal/Finance/Operations | database ADR cannot close even if technical tests pass | B04-DB ADR |
| HD04-15 | Database operations ownership, on-call hours, maintenance windows, patch cadence, and required competence | Engineering Leadership/Operations | restore/failover/maintenance evidence lacks accountable execution path | production engine/topology |
| HD04-16 | Production demand inputs: fleet, active/session distributions, events, bytes, batching, retries, outages, backlog, query/retention growth | Product/Data/Endpoint Operations/SRE | exact capacity, storage, cost, and broker analysis remain unknown | B04-CAP decision |
| HD04-17 | Headroom, backlog-drain, tail latency, fairness/starvation, query priority, and saturation acceptance | Product/SRE/Risk | simulator can measure but cannot pass a production capacity gate | capacity approval |
| HD04-18 | Permitted metadata-only measurement cohort, aggregation, access, expiry, and deletion | Data Controller/Privacy/Data Governance | capacity model remains synthetic-only and may poorly match reality | production-shaped capacity inputs |
| HD04-19 | Exact ingestion contract support horizon, batch/codec profile, compatibility window, and producer limits | Contract Authority/Product/Support/SRE | one lab profile may proceed; production rollout/long-offline compatibility cannot | active ingestion contract |
| HD04-20 | Broker requirement, trigger thresholds, architecture, product, ownership, replay/retention, regions, and migration | Architecture/SRE/Security/Finance | no broker implementation or procurement; relational design remains default | any broker adoption |
| HD04-21 | Backup cadence, classes, PITR horizon, copies, regions, immutability, provider, test frequency, and replacement policy | SRE/Data Reliability/Product Risk/Records | backup catalogue can be built, but no production recovery or expiry policy | production receipt/retention/DR |
| HD04-22 | Backup and data-encryption key custody, KMS/HSM, escrow, rotation, destruction, recovery, and sanctions on crypto erase | Cryptographic Authority/Security/Records/Risk | no production crypto-erasure claim or approved backup-key destruction | encryption/sanitization/expiry |
| HD04-23 | Media/provider sanitization standard and accepted residual risk | Security/Records/Risk/Infrastructure Owner | SQL deletion/provider receipt cannot be called final media sanitization | decommission and physical disposal |
| HD04-24 | Allowed exports, connectors, recipients, destination purposes, deletion obligations, deadlines, and limitations | Product Privacy/Legal/Integration Owners | unregistered egress remains disabled; external completion cannot be promised | production integrations/exports |
| HD04-25 | Whether human-downloaded or uncontrolled recipient copies permit case closure with limitations | Data Controller/Legal/Privacy/Risk | technical system reports explicit limitation and cannot close legal case itself | rights response/workflow |
| HD04-26 | Aggregate/anonymisation claim, contribution retention, recomputation, and legal/technical standard | Data Controller/Data Science/Privacy/Legal/Security | affected aggregates remain suppressed/deleted/recomputed; no anonymous-survival claim | lifecycle completion for aggregates |
| HD04-27 | Tombstone, receipt, case, quarantine, and restricted identity-evidence retention | Records/Privacy/Security/Data Reliability | safe minimum can be prototyped, but expiry stays disabled | production lifecycle/storage |
| HD04-28 | Portal/control access roles, segregation, approval quorum, emergency authority, and accessible workflow obligations | IAM/Product Governance/Accessibility/Support | production privileged surfaces and read enablement cannot be approved | control portal/production operations |
| HD04-29 | Incident command for false receipt, cross-realm access, lost acknowledged data, tombstone rollback, or deleted-data exposure | Security Incident Authority/Data Reliability/Product Risk | no credible production response or re-enable authority | production readiness |
| HD04-30 | Staffing, support tiers, training, blind drills, budget, observability, lab, and recurring qualification capacity | Engineering Leadership/Operations/Product/Finance | one-off prototypes may run, but supportability and evidence renewal are not sustainable | pilot/production |
| HD04-31 | Pilot scope, production risk acceptance, go-live, rollback criteria, and customer/realm onboarding | Designated Production/Risk Authority | no pilot or production deployment regardless of technical result | pilot/production |

## 6.1 Human decisions not required to begin safe implementation

The following work can begin without approving the decisions above: repository scaffolding; strict contracts and schemas; T1 fixtures/oracles; pure state machines; relational custody and lifecycle prototypes; isolated PostgreSQL/SQL Server labs; production-wire simulator code with fictional identities; fault controllers restricted to disposable infrastructure; privacy-canary/cardinality/evidence tooling; backup catalogue schema; and old-backup/tombstone/ACK drills using fictional data.

## 6.2 Owner questions that must be answered before a production-shaped pilot

1. What exact systems and commit/replication conditions constitute `DURABLY_RECEIVED`, and what failure remains outside that promise?
2. Which durable server replay source exists after an endpoint deletes a receipted payload, for how long, and under which RPO?
3. Who owns a receipt at 03:00 when the API returned it but restore evidence cannot find its batch?
4. What exact identity source and selector authorize a subject scope, and what happens when sources disagree?
5. Which data products, stores, fields, caches, replicas, exports, backups, and recipients are in scope for each purpose?
6. What must remain suppressed while a legal hold blocks physical destruction?
7. What exact evidence permits a tombstone to expire without risking replay or restore resurrection?
8. Which destination contracts prove deletion, and which can only support notification or manual attestation?
9. Which aggregates can be recomputed/subtracted, and which must remain hidden because contribution lineage is incomplete?
10. What outage/reconnect/backlog and report workload must the platform recover from, and within what approved time/cost/fairness envelope?
11. Which database profile can the organization patch, monitor, back up, restore, fail over, and troubleshoot under intended support hours?
12. What quantitative evidence would justify a broker, and who owns the new custody/replay/retention/security failure domain?
13. Which privileged operations require two-person approval, and where does their durable audit survive restore?
14. What support cases must be diagnosable without raw payload, unrestricted database access, or dynamic high-cardinality telemetry?
15. Which exact pass conditions authorize endpoint cleanup, and who accepts the residual risk if server replay is unavailable?

---

# 7. CLI experiment and measurement plan

## 7.1 Evidence rules for every experiment

Every experiment MUST:

1. run only against T1 fictional data unless a separately approved minimum aggregate metadata input is named;
2. use an immutable manifest with source-tree, contract, schema, oracle, fixture, scenario, dependency-lock, application, engine, OS/image, storage, network, fault, and cleanup digests;
3. state which inputs are **FACT**, **ESTIMATE**, approved aggregate measurement, or **HUMAN DECISION**;
4. predeclare the expected state transitions, hard invariants, performance measurements, fault schedule, stop conditions, and cleanup;
5. create expected truth before execution through an independently implemented oracle;
6. preserve the first failure and all reruns; unexplained nondeterminism is a failure, not an averaging issue;
7. collect intended offered work separately from started/completed work and prove the generator/evidence plane did not saturate;
8. use finite privacy-safe telemetry and pass mandatory positive-control canaries before trusting a scanner;
9. record exact software release/tag/commit/binary/image/configuration and licenses at execution time;
10. execute cleanup/revert and prove zero residual databases, routes, credentials, certificates, objects, keys, exports, connectors, VMs/containers, or privileged processes;
11. emit machine-readable `PASS`, `FAIL`, `BLOCKED`, or `INVALID` with reasons; no manual green checkbox can override a hard failure;
12. set `productionApproved=false` in every Batch 04 technical evidence artifact.

A representative command form is:

```text
uam-b04 <experiment> \
  --manifest <T1_MANIFEST> \
  --engine-profile <ENGINE_PROFILE> \
  --environment-profile <ENVIRONMENT_PROFILE> \
  --evidence-dir <EVIDENCE_DIR> \
  --cleanup-plan <CLEANUP_PLAN>
```

Actual connection strings, addresses, credentials, private keys, internal realm names, SSH details, or production configuration MUST NOT appear in commands, manifests, logs, screenshots, or shareable evidence.

## 7.2 Ordered experiment matrix

### E04-00 — input, toolchain, repository, and evidence inventory

**Purpose:** establish that the run uses only allowed T1 inputs and exact admitted tools.

**Evidence:**

- hashes of all allowlisted project evidence and generated implementation artifacts;
- source-tree and lock-file digests;
- exact SDK/runtime/database/driver/tool/image versions and source/tag/commit mapping;
- license, notices, security-policy, vulnerability/advisory, provenance, and owner records;
- architecture scan proving production projects do not reference simulator/fault-controller/destructive-test projects;
- secret/canary positive-control results;
- lab isolation and cleanup plan.

**PASS:** no missing/ambiguous source mapping, floating dependency, production secret/data, forbidden project reference, scanner miss, or unowned blocking artifact.  
**FAIL/STOP:** any unpinned load-bearing input, mutable branch/tag only, hidden binary, prohibited value, or cleanup authority gap.

### E04-01 — strict contracts, schemas, migrations, and independent oracle

**Purpose:** freeze one coherent semantic baseline before database or load work.

**Work:** validate HTTP/receipt/lease/materialization/quarantine/deletion/connector/backup/restore/simulator/evidence schemas; generate valid/boundary/invalid vectors; run official/local JSON Schema tests; create engine-neutral migration model; mutate implementation and oracle rules.

**Evidence:**

- local closed schema bundle and content digest;
- valid, boundary, duplicate-field, wrong-case, unknown-member, invalid UTF-8, overflow, compression-bomb, wrong-realm-claim, old/new compatibility vectors;
- logical DDL and invariant manifest;
- independent expected receipt/effect/tombstone/restore ledger;
- mutation survivors and corrected results;
- both engine adapters rejecting unsupported semantics rather than silently approximating.

**PASS:** all strict vectors and invariants agree; no duplicate/unknown authority field accepted; oracle detects required mutations; no adapter semantic drift.  
**FAIL/STOP:** hidden default/coercion, remote schema resolution, common-mode oracle defect not detected, or engine adapter cannot represent the contract.

### E04-02 — atomic custody, response loss, and false-receipt failpoints

**Purpose:** falsify receipt creation before durable custody.

**Fault points:** before transaction, after batch insert, after payload insert, after receipt insert, before commit, during log flush, after commit/before response, API process kill, network reset, database restart/failover around commit, duplicate replay.

**Evidence:**

- operation history with exact batch/wire/content digests;
- committed batch/payload/receipt/work rows;
- database transaction/log evidence;
- returned responses and endpoint retry decisions;
- oracle reconciliation after crash/restart/restore;
- first failure and cleanup.

**PASS:** zero valid receipts without exact committed custody; every committed new batch has one immutable receipt and one work row; response loss returns/replays the same receipt; no duplicate custody.  
**FAIL/STOP:** receipt exists without payload, payload without receipt, changed retry identity, unknown commit guessed as success/failure, or cleanup residue.

### E04-03 — replay, identity conflict, event uniqueness, and realm isolation

**Purpose:** prove stable retry and the consolidated `(realm_id,event_id)` rule.

**Cases:** same batch/same digests; same batch/different wire; same batch/different content; same content/new batch; same event/same effect across batches; same event/different effect; same event from different installation; colliding IDs in different realms; wrong-realm receipt lookup; wrong-realm job/cache/report/delete.

**Evidence:** exact expected/actual receipt, conflict, event identity, fact, and authorization ledgers; normalized error timing/class; cross-realm negative matrix; database unique-constraint evidence.

**PASS:** one receipt per stable batch identity; one ordinary effect per `(realm,event_id)`; every incompatible reuse is explicit conflict; zero cross-realm existence/result/timing leak beyond approved generic behavior.  
**FAIL/STOP:** duplicate effect, overwrite, installation-broadened duplicate, cross-realm row/job/cache/report, or enumerable response difference.

### E04-04 — lease fencing, database-time behavior, fairness, and stale workers

**Purpose:** prove recoverable scheduling without stale authority or starvation.

**Cases:** simultaneous workers, lock contention, lease expiry, lost heartbeat, worker pause, database clock step profile, process kill, failover, page locks/escalation, plan drift, hot realm, reconnecting large realm, poison realm, scheduler-row corruption/reconciliation.

**Evidence:** lease grant/heartbeat/commit history, token/fence values, database timestamps, queue plans/waits/locks, per-class oldest/p99 lag and starvation, scheduler derived-state reconciliation, engine-specific snapshots.

**PASS:** zero stale-token/fence commits; each work item has at most one terminal commit; expired work is recoverable; no class exceeds the owner-approved starvation/lag bound; scheduling aids reconcile exactly.  
**FAIL/STOP:** stale worker commits, double terminal outcome, work permanently hidden, global starvation, unbounded lock/plan regression, or clock ambiguity accepted.

### E04-05 — whole-batch materialization, poison, quarantine, and governed reprocess

**Purpose:** prove one terminal batch outcome and safe repair.

**Cases:** all-new batch, all-replay, mixed new/replay, one deterministic poison among valid siblings, unsupported event schema, transient reference failure, event conflict, worker death before/after final commit, reprocess under new processor generation, repeated reprocess.

**Evidence:** plan digest, event identity/fact rows, quarantine occurrences, work generations, reprocess audit, projection/integration work, exact counts/digests.

**PASS:** successful batch commits complete effects/work/outbox atomically; poison/conflict generation commits zero new ordinary facts and one immutable quarantine occurrence; governed reprocess may later produce the one allowed effect without deleting prior evidence; no infinite retry.  
**FAIL/STOP:** partial first-slice facts, overwritten quarantine, event identity consumed incorrectly, unbounded retries, direct SQL repair, or missing audit.

### E04-06 — projections, aggregates, integrations, and reconciliation

**Purpose:** prove that derived work is idempotent and reconstructible.

**Cases:** projection worker death before/after contribution commit, duplicate contribution, algorithm/version cutover, rebuild, integration response loss/retry, destination duplicate, terminal/permanent failure, portal/readiness hold.

**Evidence:** fact ledger, projection work/contribution/aggregate digests, integration outbox/receipt histories, rebuild equivalence, visibility state, reconciliation findings.

**PASS:** each fact contributes at most once per projection/version; rebuild matches oracle; integration retry uses stable message ID; integration failure never changes receipt/fact; unready projection is not served.  
**FAIL/STOP:** double aggregate, lost derived work, fact mutation, integration network inside fact transaction, or visibility before readiness.

### E04-07 — portable logical schema and engine semantic parity

**Purpose:** establish that PostgreSQL and SQL Server implement the same UAM semantics before comparison.

**Workloads:** correctness, replay, conflict, poison, late arrival, skew, reports, retention fixture, backup/restore, and realm-negative suite at low rate.

**Evidence:** exact DDL/migration/index/role/RLS profiles; input/oracle digests; raw operation histories; canonical result hashes; provider/driver versions; semantic diff report.

**PASS:** both candidates produce identical approved semantic outcomes and pass all hard invariants.  
**FAIL/STOP:** one candidate silently approximates a contract, weakens durability/isolation, or produces a different final result.

### E04-08 — database realm context, privileges, pool reuse, and bulk-path safety

**Purpose:** falsify cross-realm and provider-specific boundary failures.

**Cases:** pooled connection reuse across realms, failed/cancelled transaction, prepared statements, retry, background job context, PostgreSQL owner/`BYPASSRLS`/security-definer path, SQL Server `EXECUTE AS`/ownership chain/session context/cross-database path, same-session temporary staging, bulk cancellation and constraint conflict.

**Evidence:** role grants, effective principal/context, database audit, query/result matrix, pool checkout/return traces, bulk transaction histories, canary scan.

**PASS:** zero cross-realm results or writes; no runtime bypass role; context is set before every realm query; bulk path rolls back atomically and matches row comparator.  
**FAIL/STOP:** one leaked context, bypassable RLS profile, trigger/constraint semantic difference, orphan temporary data, or payload/canary leak.

### E04-09 — paired database workload, history, reports, maintenance, and saturation

**Purpose:** measure candidate fitness without forcing a winner.

**Profiles:** no partition, receipt-time candidate, event-time candidate; default and preregistered tuned configurations; loaded historical volume; steady/reconnect/skew/late/poison; approved synthetic query corpus; statistics/index/vacuum-or-ghost/backup operations.

**Evidence:** randomized paired run plan, offered/completed work, receipt/materialization/query distributions, queue age, CPU/memory/I/O/connections, locks/waits/deadlocks, WAL/log/checkpoints, table/index sizes, plan fingerprints/changes, maintenance duty, generator capacity, confidence/uncertainty and raw failed runs.

**PASS:** all hard invariants remain zero and the profile meets owner-approved throughput/tail/recovery/resource/cost criteria with stated uncertainty.  
**FAIL/STOP:** correctness failure, generator invalidity, log/WAL unbounded growth, maintenance starvation, query interference beyond approved bound, or no stable operating region.

### E04-10 — actual backup, PITR, failover, fencing, and operator drill

**Purpose:** prove recovery for each candidate topology, not just backup creation.

**Cases:** backup under load, restore to isolated environment, point-in-time target before/after selected transactions, planned failover, primary process/host failure, connection loss around receipt/materialization, replica lag, log/WAL archive interruption, corrupted/missing segment, operator blind runbook.

**Evidence:** backup/copy/key/log manifests, actual restore timelines, database sequence, receipts/effects/quarantine/query result reconciliation, failover fencing, client retry histories, operator actions/errors, RPO/RTO measurements, cleanup.

**PASS:** no false receipt, split-brain effect, duplicate materialization, missing in-scope acknowledged data, or pre-ready read; actual measured recovery is compared with—not declared to meet—human objectives.  
**FAIL/STOP:** tool check without usable restore, failed fencing, unreconciled receipt/effect, operator cannot recover safely, or topology/edition/license mismatch.

### E04-11 — simulator determinism and production-wire equivalence

**Purpose:** prove the simulator is a faithful controlled producer.

**Cases:** same seed/run plan repeated; repartitioning across agent counts; Windows cohort vs generic agent; ambiguity and retry; contract/version changes; exact compressed body replay.

**Evidence:** compiled per-device timelines/seeds, byte digests, state-transition histories, receipt verification, agent partition mapping, Windows transport/TLS/module inventory, deterministic root hashes.

**PASS:** same plan produces identical device histories and exact wire bytes independent of partitioning; Windows and generic lanes agree for the qualified subset; ambiguity never rebuilds identity/body.  
**FAIL/STOP:** nondeterminism, shared random-stream ordering, wire mismatch, fabricated/loosely verified receipt, or unsupported transport divergence.

### E04-12 — generator capacity, open-arrival accuracy, clocks, and evidence cardinality

**Purpose:** prove the load/evidence system is not the bottleneck or a coordinated-omission source.

**Cases:** no-SUT sink, fast mock SUT, intended maximum offer, agent loss, clock disturbance, telemetry backend slow/down, theoretical series-bound breach, network/socket saturation.

**Evidence:** offered/started/delayed/dropped/completed counters, planned-vs-actual start distribution, CPU/memory/GC/thread/socket/TLS/network, clock error, partition skew, series theoretical/actual counts, evidence loss ledger.

**PASS:** generator and evidence plane meet the preregistered accuracy/capacity/cardinality budgets with zero unexplained dropped work.  
**FAIL/STOP:** intended offer not sustained, delayed/dropped work hidden, clock order invalid, telemetry backpressure changes load, or unbounded labels.

### E04-13 — 6,000-installation steady and reconnect-recovery campaign

**Purpose:** establish one fully bound reference scenario, not a support claim.

**Phases:** warm state, steady arrivals, approved synthetic query mix, site outage, exact local backlog creation, deterministic reconnect spread, response-loss/retry amplification, continued new arrivals, drain, post-recovery normalization.

**Evidence:** full unit-of-capacity manifest; receipt/materialization/query tails; local/central backlog events/bytes/age; net drain rate; per-realm fairness/starvation; log/WAL/storage; retries; generator validity; cost/resource profile; correctness reconciliation.

**PASS:** zero hard invariant failures, backlog drains while new arrivals continue within human-approved objectives, fairness passes, and resources normalize.  
**FAIL/STOP:** false receipt/duplicate effect/cross-realm/silent loss, queue age grows without recovery, one class starves, generator invalid, or objective absent.

### E04-14 — 12,000-installation saturation, knee, and headroom campaign

**Purpose:** find failure modes and sustainable capacity; not prove production demand.

**Work:** stepwise offered load, worker/connection sweeps, history/query/maintenance active, retry/fault phases, recovery from each level.

**Evidence:** sustainable region and knee with uncertainty; latency/error/queue slopes; resource and WAL/log inflection; plan/lock changes; recovery ability; cost per endpoint/event/GiB; exact first failed level.

**PASS:** reports the complete curve and first failure honestly; any proposed production profile lies below the human-approved recovery-aware boundary and passes all hard invariants.  
**FAIL/STOP:** result reports only headline throughput, hides failed runs/retries, correctness fails, or no recovery below the claimed point.

### E04-15 — endurance, maintenance, backup, and leak campaign

**Purpose:** expose bloat/fragmentation, log retention, memory/session leaks, plan drift, scheduler drift, and recurring maintenance conflicts.

**Work:** staged diagnostic and endurance soaks; mixed traffic; scheduled reports, statistics/index/vacuum-or-ghost tasks, backups, connector simulations, retention dry runs, process rotation, and fault recovery.

**Evidence:** time series of queue age, bloat/free-space proxies, log/WAL/archive, memory/handles/connections, plan fingerprints, maintenance duration, backup throughput, error/retry accumulation, generator/evidence health, cleanup.

**PASS:** no correctness/privacy failure, unbounded growth, unrecoverable drift, or resource leak; duration covers the declared maintenance cycles.  
**FAIL/STOP:** exact duration is insufficient to exercise a claimed cycle, or any unexplained monotonic degradation/residue exists.

### E04-16 — subject resolver, visibility barrier, and internal store adapters

**Purpose:** prove suppress-first lifecycle and exact scope.

**Cases:** exact fictional subject, zero/ambiguous/stale selector, colliding IDs across realms, hold before/after barrier, API/BFF/cache/replica/materialized view/search fixture, write/replay arriving after barrier, worker crash and retry, adapter delete/verify conflict.

**Evidence:** resolution manifests/digests, barrier transaction, tombstone chain/visibility epoch, every read result, target/attempt histories, hold state, replay suppression, independent verifier outputs, audit.

**PASS:** no barrier on ambiguous/wrong scope; after barrier zero ordinary reader exposes the subject; replay creates no visible effect; targets are idempotent and independently verified; hold preserves suppression.  
**FAIL/STOP:** wrong/cross-realm subject, visible stale reader, barrier removed, untyped SQL/path mutation, false verification, or missing audit.

### E04-17 — connectors, exports, backup catalogue, and chain-aware expiry

**Purpose:** expose external and recovery-copy obligations truthfully.

**Cases:** object delete, subject delete, queued/nonterminal response, authenticated not-found, timeout after apply, unsupported destination, human download, export access revocation/object/key deletion, backup parent/child/log dependency, unknown object version, hold, missing replacement restore point, provider deletion ambiguity.

**Evidence:** connector/export registry revisions, object manifests, stable deletion commands/receipts, limitation states, backup graph/copy/version/key inventory, actual replacement restore evidence, expiry attempts and verification.

**PASS:** no unregistered egress; external terminal state follows exact contract; unsupported/human copies are limitations; backup expiry blocks on every unknown/dependency/hold; every deleted copy/key has evidence.  
**FAIL/STOP:** 2xx/notification/404 guessed as deletion, false `COMPLETE`, expired required recovery chain, unknown copy assumed absent, or key destroyed before safe order.

### E04-18 — old-backup, current-tombstone, acknowledged-replay lifecycle drill

**Purpose:** directly falsify the accepted restore invariant.

**Fixture chronology:**

1. create fictional realm, subjects, events, receipts, facts, projections, integrations, exports, and backup A;
2. after backup A, durably receive additional acknowledged batches;
3. authorize deletion of selected fictional subjects and commit tombstones/barrier;
4. execute partial/full store/connector deletion and create a later backup/copy manifest;
5. restore backup A into a new isolated environment;
6. recover current tombstone and receipt-set authorities;
7. replay missing acknowledged batches under stable IDs while applying tombstones;
8. rebuild all derived stores and evaluate readiness;
9. attempt prohibited reads, egress, connector send, endpoint receipt, and routing before readiness;
10. clean up every environment, credential, route, object, key, and evidence staging resource.

**Evidence:** complete chronology/digests, backup and recovery manifests, exact authoritative/restored receipt sets, tombstone chain, replay ledger, fact/projection/connector/export states, negative deleted probes, positive acknowledged probes, attempted pre-ready access/egress results, readiness decision, cleanup receipt.

**PASS:** zero pre-ready ordinary reads or egress; zero visible deleted subjects; zero missing, conflicting, or duplicate nondeleted acknowledged effects; zero tombstone gaps/forks/rollback; zero cross-realm effect; zero false external completion; zero canary escape; zero cleanup residue.  
**FAIL/STOP:** any nonzero primary invariant count. No performance result or human waiver compensates.

### E04-19 — aggregate Batch 04 gate and decision package

**Purpose:** determine whether the technical baseline may be updated for one exact profile.

**Evidence:** content-addressed roots for E04-00 through every required experiment; gate versions; first failures and reruns; owner/ADR states; database/capacity/lifecycle decision matrices; human decisions explicitly open; evidence expiry; cleanup.

**PASS:** B04-INGEST and the required exact-profile portions of B04-DB, B04-CAP, and B04-LIFE pass, contradictions are closed, blocking technical owners are assigned, and evidence is current. The output explicitly states `productionApproved=false`.  
**FAIL/STOP:** any hard gate fails, evidence/profile differs, required human input is silently assumed, or cleanup/owner/ADR is incomplete.

## 7.3 Primary acceptance expressions

### B04-INGEST

```text
B04_INGEST_PASS =
    ZERO_RECEIPTS_WITHOUT_EXACT_COMMITTED_CUSTODY
    AND EVERY_COMMITTED_BATCH_HAS_ONE_IMMUTABLE_RECEIPT
    AND EVERY_RECEIPT_HAS_EXACTLY_ONE_BATCH_TERMINAL_OUTCOME_AFTER_DRAIN
    AND TERMINAL_OUTCOME_IN {MATERIALIZED, QUARANTINED_TERMINAL}
    AND EVERY_REALM_EVENT_ID_HAS_AT_MOST_ONE_ORDINARY_EFFECT
    AND SAME_EVENT_SAME_EFFECT_REPLAY_CREATES_ZERO_ADDITIONAL_EFFECTS
    AND INCOMPATIBLE_IDENTITY_REUSE_IS_EXPLICIT_CONFLICT
    AND ZERO_STALE_LEASE_COMMITS
    AND ZERO_CROSS_REALM_EFFECTS
    AND ZERO_UNBOUNDED_POISON_RETRIES
    AND ZERO_FORBIDDEN_CANARY_ESCAPES
    AND ZERO_UNEXPLAINED_RESTORE_FINDINGS
    AND ZERO_CLEANUP_RESIDUE
```

### B04-LIFE

```text
B04_LIFE_PASS =
    ZERO_WRONG_OR_CROSS_REALM_RESOLUTIONS
    AND ZERO_BARRIER_COMMITS_FOR_AMBIGUOUS_SCOPE
    AND ZERO_ORDINARY_DELETED_SUBJECT_VISIBILITY_AFTER_BARRIER
    AND ZERO_PRE_READY_ORDINARY_READS
    AND ZERO_PRE_READY_CONNECTOR_OR_EXPORT_EGRESS
    AND ZERO_PRE_READY_ENDPOINT_RECEIPTS
    AND ZERO_TOMBSTONE_GAPS_FORKS_OR_ROLLBACK
    AND ZERO_MISSING_CONFLICTING_OR_DUPLICATE_NONDELETED_ACKNOWLEDGED_EFFECTS
    AND ZERO_DELETED_EFFECT_REMATERIALIZATION_AFTER_REPLAY
    AND ZERO_FALSE_EXTERNAL_COMPLETIONS
    AND ZERO_CROSS_REALM_EFFECTS
    AND ZERO_PRIVACY_CANARY_ESCAPES
    AND ZERO_CLEANUP_RESIDUE
```

### Capacity and database performance gates

There is intentionally no invented universal number. Performance gates combine:

```text
ALL_HARD_INVARIANTS_PASS
AND GENERATOR_VALID
AND MEASURED_WORKLOAD_MATCHES_APPROVED_INPUT_PROFILE
AND MEASURED_TAILS_WITH_UNCERTAINTY_MEET_HUMAN_OBJECTIVES
AND BACKLOG_RECOVERS_WHILE_NEW_ARRIVALS_CONTINUE
AND FAIRNESS_MEETS_HUMAN_OBJECTIVES
AND BACKUP_RESTORE_FAILOVER_MEET_HUMAN_OBJECTIVES
AND COST_SKILLS_SUPPORT_LICENSE_PROFILE_APPROVED
```

A missing human objective yields `BLOCKED`, not a technical pass.

## 7.4 Evidence bundle layout

```text
evidence/b04/<run-or-case-id>/
  manifest/
    run-manifest.yaml
    inputs.sha256
    source-tree.json
    contracts-schemas.json
    dependencies-licenses.json
    environment.json
    engine-config.json
    fault-plan.json
    cleanup-plan.json
  generator/
    compiled-run-plan.json
    deterministic-seeds.json
    generator-capacity.json
  oracle/
    expected-receipts.ndjson
    expected-effects.ndjson
    expected-lifecycle.ndjson
    expected-restore.ndjson
  operations/
    raw-operations.ndjson.zst
    error-ledger.ndjson
    lease-history.ndjson
    conflict-ledger.ndjson
  database/
    schema-indexes-roles.json
    normalized-metrics.csv
    engine-native-snapshots/
    query-plans/
    wal-log-accounting.json
    maintenance-events.ndjson
  capacity/
    offered-load.ndjson
    latency-histograms/
    backlog-fairness.json
    storage-cost.json
  lifecycle/
    resolution-manifests/
    tombstone-chain.ndjson
    deletion-targets.ndjson
    connector-export-evidence.ndjson
    backup-catalogue.json
  restore/
    restore-timeline.ndjson
    receipt-set-reconciliation.json
    tombstone-reconciliation.json
    readiness-checks.json
    positive-negative-probes.json
  analysis/
    semantic-diff.json
    paired-summary.json
    uncertainty.csv
    tco-inputs.json
    sensitivity.json
    gate-result.json
  privacy/
    canary-results.json
    cardinality-results.json
  reports/
    result.md
    result.html
  cleanup/
    cleanup-receipt.json
```

Raw engine snapshots and exact fictional identifier ledgers remain access-controlled. Shareable evidence contains finite classes, fictional values, counts, digests, public software versions, configurations, first failures, and cleanup—not production data or infrastructure details.

---

# 8. Threat, failure, and recovery gaps

## 8.1 Consolidated register

| ID | Threat/failure | Current containment | Missing proof or recovery path | Owner function / effect if unresolved |
|---|---|---|---|---|
| T04-01 | Receipt returned before durable commit | acceptance transaction and post-commit response rule | process/database/failover failpoints and actual restore reconciliation | Ingestion/Data Reliability; blocks B04-INGEST and endpoint cleanup |
| T04-02 | Database reports commit but declared replica/storage failure domain loses it | named failure-domain class and exact engine profile | correlated failure, replica/log/archive, restore, and RPO evidence | SRE/Product Risk; no production cleanup-eligible receipt |
| T04-03 | Response lost after commit | same immutable batch replay/status lookup | endpoint/server compatibility and receipt replay under every network/gateway path | Endpoint + Ingestion; persistent backlog or duplicate custody risk |
| T04-04 | Batch ID reused with changed bytes | both wire and canonical content digests; immutable conflict | digest implementation/canonicalization vectors and compromised producer incident path | Contract/Security; blocks receipt trust |
| T04-05 | Event ID reused by another installation or changed effect | unique `(realm,event_id)` and conflict hold | clone/re-enrollment/producer-defect incident and correction policy | Data Correctness/Security; duplicate or lost effect risk |
| T04-06 | Hash/canonicalization common-mode defect | two digests, strict bytes, independent oracle | independent implementation, mutation, cross-language vectors, algorithm-agility plan | Contract Authority; false replay/conflict risk |
| T04-07 | Large immutable payload row amplifies WAL/log, lock, backup, or cost | separate mutable work row; bounded batch | production-shaped payload distributions and object-storage break-even | Data Reliability/Capacity; engine/cost decision blocked |
| T04-08 | Object-store custody proposal creates dual-write ambiguity | rejected initially | atomic conditional object write + relational manifest + replay/restore proof if needed | Architecture/Data Reliability; no object payload class |
| T04-09 | Stale worker commits after lease reclaim | token/fence/database-time predicate and unique constraints | process pause, failover, clock, provider cancellation, long final transaction tests | Materialization; hard B04-INGEST failure |
| T04-10 | Queue scan/plan regresses or page locks hide work | narrow work table, indexes, engine-specific hints | aged-data plan, lock escalation, statistics/maintenance, version upgrade evidence | Database Reliability; starvation/backlog risk |
| T04-11 | Busy realm or reconnect site starves others | two-level/fair scheduler candidate and per-class metrics | exact fairness objective, algorithm comparison, failure recovery | Product/SRE; capacity gate blocked |
| T04-12 | Poison batch loops and captures workers | finite taxonomy, bounded retries, terminal quarantine | exact retry classification, operator/reprocess SLA, poison-at-scale campaign | Materialization/Data Governance; availability/support risk |
| T04-13 | Whole-batch quarantine magnifies one poison event | bounded batch and explicit terminal outcome | measured poison/batch distribution; future per-event contract only if needed | Product/Contract; may limit batch size/capacity |
| T04-14 | Governed reprocess creates duplicate facts | new processing generation, global event uniqueness, immutable prior evidence | processor upgrade/replay/failover matrix and correction authority | Data Correctness; hard one-effect risk |
| T04-15 | Projection contribution lost/doubled | transactional work + unique contribution ledger | rebuild/cutover/version rollback and aggregate lineage tests | Projection Owner; incorrect reports/deletion |
| T04-16 | Integration response loss creates duplicate recipient objects | stable message/object identity and destination contract | each connector's idempotency/status/receipt semantics and replay tests | Integration Owner; external duplication/deletion gap |
| T04-17 | Realm context leaks through connection pool or job | realm-first keys, application context, RLS defense in depth | hostile pool/cancel/retry/module/privileged-role matrix | IAM/Database Security; hard security failure |
| T04-18 | Privileged DBA bypasses application/lifecycle guards | least privilege, audit, reconciliation, separation of duties | direct-access policy, detection, incident and post-bypass reconciliation | Security/Governance; production blocked |
| T04-19 | Logs/traces/metrics capture payload, subject, SQL values, or identifiers | closed catalogue, finite labels, canaries | all-sink runtime campaign under errors/failover/backups/tools | Privacy/Security; hard privacy failure |
| T04-20 | Database comparator shares a defect across both adapters | independent oracle and semantic invariants | oracle mutation, third implementation/model review, result-hash challenge | Verification Governance; engine result invalid |
| T04-21 | Unequal engine tuning/hardware/edition biases result | preregistered paired blocks and exact manifests | blind/randomized run order, symmetric tuning budget, edition/license validation | Architecture/DB Reliability; ADR blocked |
| T04-22 | Database meets steady throughput but fails checkpoint/vacuum/ghost/backup/report | complete concurrent workload and endurance plan | loaded-history maintenance/soak/backup/failover evidence | SRE/DB Reliability; capacity/engine blocked |
| T04-23 | Global event identity ledger becomes hot | narrow key/row and bulk candidate | reconnect-storm lock/log/partition/shard experiments | Data Reliability; may require physical redesign |
| T04-24 | WAL/log/archive grows without bound | rate/storage/lag SLIs and backpressure | archive interruption, replica lag, backup, long outage and recovery tests | SRE; false availability/cost risk |
| T04-25 | Generator coordinated omission | independent open-arrival scheduler | no-SUT calibration, planned-vs-start timing, dropped/delayed accounting | Capacity Engineering; performance result invalid |
| T04-26 | Generator/evidence sink saturates before SUT | self-metrics, theoretical series bound, restricted truth store | maximum-offer calibration, network/socket/clock/telemetry faults | Capacity Engineering; result invalid |
| T04-27 | Synthetic distributions miss production correlation | sensitivity/correlated stress and approved aggregates | minimum metadata cohort and recurring drift comparison | Product/Data/SRE; capacity confidence remains low |
| T04-28 | Reconnect clients synchronize despite intended jitter | deterministic per-device streams | timer/clock/restart/agent partition and Windows cohort evidence | Capacity/Endpoint; underestimated peak |
| T04-29 | Backlog accepts peak but never recovers | explicit net drain/age model | human recovery target, continuous-arrival drain runs, resource normalization | Product/SRE; capacity fail |
| T04-30 | Cost model omits licenses, support, people, backups, egress, or incidents | complete versioned TCO schema | actual quotes/contracts, staffing, training, DR, migration inputs | Finance/Procurement; engine/broker decision blocked |
| T04-31 | Wrong subject is deleted or hidden | exact typed resolver and immutable manifest | authoritative source decisions, independent challenge query, correction workflow | Data Governance/Legal; lifecycle production blocked |
| T04-32 | Identity source changes after resolution and silently widens scope | immutable manifest/case revision | amendment and notification/legal workflow | Data Governance; wrong-scope risk |
| T04-33 | Hold arrives after barrier or during deletion | suppression remains; target can move to `HELD` | race/failover tests and rule for already destroyed data | Legal/Records/Lifecycle; evidence and response risk |
| T04-34 | Reader bypasses tombstone via stale cache, replica, search, or direct query | visibility epoch, watermark eligibility, BFF guard | each actual reader adapter, stale snapshot, failover, direct-access test | API/Data Platform; deleted-data exposure |
| T04-35 | Endpoint or server replay rematerializes deleted event | active tombstone check before business effect | exact batch replay after old restore and connector retry campaign | Data Reliability/Lifecycle; hard restore failure |
| T04-36 | Tombstone sequence is lost, forked, or rolled back | monotonic chain/digest and independent recovery copy | corruption, concurrent writer, old backup, restore, key/privilege attacks | Data Reliability/Security; readiness blocked |
| T04-37 | Tombstone expires while a resurrection path remains | conjunctive horizon rule | complete inventory of backups, endpoints, connectors, exports, search, disputes | Records/Lifecycle; expiry disabled |
| T04-38 | Receipt coverage manifest diverges from committed receipts | receipt relation authoritative; derived digest | full-set generation/reconciliation, chain, backup, corruption tests | Data Reliability; restore readiness blocked |
| T04-39 | Authoritative receipt set itself is restored too old | independent protected coverage/replay source | exact topology design and old-backup drill; endpoint grace only if approved | Product Risk/SRE; endpoint cleanup prohibited |
| T04-40 | Missing acknowledged batch cannot be recovered after cleanup | cleanup conjunctive gate and independent server custody | RPO/replay source/ACK grace decision plus destructive restore drill | Product Risk; no production cleanup |
| T04-41 | Backup file passes tool check but cannot start or has wrong semantics | actual isolated restore and application probes | repeated blind restore across copies/versions/topologies | SRE/Data Reliability; receipt/retention/DB blocked |
| T04-42 | Backup chain expiry deletes a required parent/log/copy/key | catalogue graph and prepared manifest | provider-specific ancestry/version/key inventory and replacement recovery proof | SRE/Records; expiry disabled |
| T04-43 | Unknown object version/copy survives deletion | explicit copy/version inventory and verification | provider API consistency, manual/offline media, deletion receipt semantics | Infrastructure/Records; completion blocked |
| T04-44 | Crypto erase leaves key copy, cache, escrow, wrapped/derived key | reject per-subject default; separate key policy | all-copy/hierarchy/KMS/cache/reset/sanitization evidence | Security/Crypto; no CE claim |
| T04-45 | Aggregate contribution cannot be removed or recomputed | contribution ledger and hide-first behavior | actual aggregate algorithms, retained lineage, independent recompute | Data Product/Privacy; case remains incomplete/suppressed |
| T04-46 | External connector says accepted but not applied | stateful command/status contract | destination-specific terminal receipt and independent probe | Integration Owner; `WAITING_EXTERNAL` or limitation |
| T04-47 | Destination returns not-found for wrong realm/object/auth | generic not-found is not terminal by default | authenticated object binding and exact connector revision tests | Integration/Security; external completion blocked |
| T04-48 | Human-downloaded or uncontrolled recipient copy persists | explicit recipient class/limitation | contractual notification/attestation and legal outcome | Legal/Privacy; cannot claim technical erase |
| T04-49 | Restore environment accidentally receives production traffic or sends egress | new identity, no routes/egress/receipt authority | network/DNS/service-registration/credential hostile tests | SRE/Security; hard lifecycle failure |
| T04-50 | Readiness evaluator or operator forces `READY` | immutable checks and separate read-enable transition | evaluator mutation, missing-check, stale-evidence, authorization tests | Verification/Security; hard restore failure |
| T04-51 | Derived rebuild completes from stale facts before tombstones | mandated tombstone replay first and watermark checks | ordering/failpoint tests for each derived store | Data Platform; deleted-data exposure |
| T04-52 | Cleanup leaves credentials, objects, routes, VMs, copies, or keys | cleanup plan/receipt and final inventory | destructive lab residue and retry/escalation runbook | Lab/SRE/Security; evidence invalid |
| T04-53 | Clock error changes retention, lease, receipt, or case behavior | database time/control clock class/fail closed | NTP/clock-step/unknown-time experiments and human tolerance | SRE/Security/Records; deletion/lease/cleanup blocked |
| T04-54 | Operator follows wrong or stale runbook | content-addressed runbooks and blind drills | recurring exercise, version binding, first-failure retention | Operations Leadership; production blocked |
| T04-55 | Dependency/tool update changes semantics or licensing | exact admission and evidence expiry | update diff, regression/fault/restore rerun, procurement review | Dependency/Release Governance; profile expires |

## 8.2 Mandatory recovery hierarchy

Recovery follows this order; later steps cannot conceal a failed earlier invariant:

1. **Stop authority:** disable new ingestion, leasing, egress, retention, deletion, backup expiry, or read enablement as narrowly as possible.
2. **Preserve evidence:** retain immutable custody, receipt, work, tombstone, audit, manifests, first failure, and exact configuration before repair.
3. **Reconcile identity:** determine authenticated realm/installation, batch/event/case/backup identity, digests, and commit state without guessing.
4. **Restore one authoritative state machine:** use stable identity and fencing; never create replacement IDs to make an ambiguous operation appear new.
5. **Rebuild derived state:** facts only from valid custody/identity; projections/integrations only from facts; readers only under current tombstones.
6. **Verify independently:** use oracle/reconciler and negative/positive probes, not the repairing component's success response alone.
7. **Clean up:** remove test/failed environments, stale routes, credentials, objects, keys, exports, and privileged residue.
8. **Re-enable separately:** a privileged audited action verifies current evidence/owners/ADRs and enables the minimum affected function.
9. **Rerun adjacent gates:** a fix to custody, schema, queue, identity, backup, tombstone, connector, or dependency invalidates dependent evidence.

## 8.3 Incident classes requiring an immediate safety hold

The system MUST enter a safety/read/egress hold for at least:

- valid receipt with missing/conflicting payload;
- same batch/event identity with incompatible content/effect;
- cross-realm result or leaked realm context;
- stale lease terminal commit;
- unexplained duplicate or missing ordinary effect;
- tombstone gap, fork, rollback, or wrong-scope application;
- deleted-subject visibility after barrier;
- acknowledged-set mismatch after restore;
- pre-ready read, connector/export egress, endpoint receipt, or routing;
- backup chain/copy/key inventory contradiction;
- privacy canary escape;
- unbounded metric cardinality or evidence loss that prevents correctness proof;
- unknown destructive operation outcome;
- cleanup residue affecting another run/environment.

A safety hold stops dependent work but does not erase custody, remove suppression, invent completion, or authorize a destructive repair.

---

# 9. ADR create/update list

## 9.1 Batch 04 ADR register

| ADR | Action | Decision scope | Current status / closure evidence |
|---|---|---|---|
| ADR-B04-001 — Durable custody and receipt failure-domain classes | **CREATE** | atomic batch/payload/receipt/work transaction; response/replay; failure-domain vocabulary; endpoint cleanup ineligibility by default | Proposed baseline; close only with E04-02/E04-10 and HD04-10–12 |
| ADR-B04-002 — Ingestion wire contract, codec, compression, digests, and limits | **CREATE** | exact media/envelope/encoding profile, canonical bytes, bounds, compatibility, status query | Profile provisional; close contract vectors and compatibility evidence, not point-version prose |
| ADR-B04-003 — Relational inbox custody/work schema and payload storage class | **CREATE** | immutable custody vs mutable work split; inline relational payload first; object-storage change trigger | Accept logical split; object storage deferred to change proposal |
| ADR-B04-004 — Event identity and global uniqueness | **CREATE** | unique `(realm_id,event_id)`; installation/source/batch provenance; conflict and correction semantics; partition independence | Accept as consolidated correction; migration/prototype proof required |
| ADR-B04-005 — Whole-batch materialization, quarantine, and governed reprocess | **CREATE** | first-slice terminal semantics; poison/conflict; processing generations; no partial commit | Accept with measured batch/poison review trigger |
| ADR-B04-006 — Relational leasing, fencing, fairness, and backpressure | **CREATE** | work table, DB time, token/fence, heartbeat, retries, realm fairness, pressure behavior | Candidate algorithms/values remain experimental |
| ADR-B04-007 — Facts, projections, contribution lineage, and integration outbox | **CREATE** | typed fact authority; rebuild/cutover; one contribution; stable integration ID | Accept logical architecture; concrete fact/report fields human-gated |
| ADR-B04-008 — Portable database schema, partition/index candidates, and bulk path | **CREATE** | global identity ledger, P0/P1/P2 candidates, bulk staging, engine-specific SQL under common semantics | Physical design open until paired evidence |
| ADR-B04-009 — Realm isolation and database defense in depth | **CREATE** | realm-first keys, least-privilege roles, RLS/session context, pool/job/cache negative tests | RLS explicitly non-authoritative alone |
| ADR-B04-010 — Fleet simulator, capacity claim unit, fairness, soak, and evidence | **CREATE** | stateful/open-arrival design, production-wire reuse, Windows cohort, complete capacity-claim manifest | Accept architecture; all thresholds and capacity open |
| ADR-B04-011 — Broker break-even and custody migration | **CREATE / UPDATE accepted no-broker decision** | trigger categories, prototype eligibility, one custody boundary, replay/restore/ACL/TCO/migration | `NO_BROKER` remains default; no product selected |
| ADR-B04-012 — Tombstone ledger and visibility/read-eligibility barrier | **CREATE** | exact tombstone scope, realm sequence/chain, visibility epoch, derived-store watermark, expiry predicates | Accept architecture; protection technology/horizon open |
| ADR-B04-013 — Lifecycle cases, exact subject resolution, legal-hold interaction, and store adapters | **CREATE** | case/resolver/target state machines, suppress-first rule, technical completion/limitations | Technical architecture accepted; legal decisions open |
| ADR-B04-014 — Acknowledged receipt coverage, restore reconciliation, and endpoint cleanup eligibility | **CREATE / UPDATE Batch 03 cleanup decision** | receipt relation authority, coverage manifest, replay sources, old-backup drill, conjunctive cleanup policy | Production cleanup remains disabled until B04-LIFE and human decisions pass |
| ADR-B04-015 — Connector/export lifecycle and external limitations | **CREATE** | registry, object manifests, deletion command/receipt, not-found semantics, human recipient copies | No unregistered production egress; destination contracts open |
| ADR-B04-016 — Backup catalogue, chain-aware expiry, keys, and sanitization boundaries | **CREATE** | copies/versions/logs/PITR/keys/holds/replacement restore; crypto erase limits | Tool/provider/period/key choices open |
| ADR-B04-017 — Minimal audit, restricted case material, evidence, and observability | **CREATE** | separate audit/case/tombstone content, finite telemetry, evidence bundle/access/retention | Exact audit/access/retention human-gated |
| ADR-B04-018 — Database/tool/dependency lifecycle and qualification | **CREATE** | execution-time exact versions, source mapping, license/security/provenance, update/rerun triggers | Open; section 11 is current review snapshot only |
| ADR-B04-019 — Restore environment isolation and read-enable authority | **CREATE** | environment identity/routes/credentials, no receipt/egress/read, readiness checks, separate read activation | Accept architecture; exact platform implementation experimental |
| ADR-B04-020 — Batch 04 aggregate gate and evidence expiry | **CREATE** | composition of ingest/DB/capacity/lifecycle evidence, profile matching, first failure, cleanup, no production approval | Open until E04-19 and required human/owner states |

## 9.2 Predecessor ADR updates

| Predecessor area | Required update | Reason |
|---|---|---|
| Batch 01 contract/identifier baseline | Register server custody, lease, lifecycle, connector, backup, restore, and evidence contracts; confirm lower-case UUIDv7 and strict closed profiles | Batch 04 adds named boundaries but does not change scalar rules |
| Batch 01 repository/dependency baseline | Add database benchmark, simulator, lifecycle, restore, and fault-test projects with production dependency prohibitions | Test/destructive authority must remain structurally absent from production |
| Batch 02 event identity | Clarify that endpoint-minted stable `event_id` is globally unique within realm at central ordinary-effect boundary; installation is provenance | Resolves C04-01 without changing source natural identity |
| Batch 02 interpretation/correction | State that server materialization does not create a second effect after interpretation/processor change; correction remains explicit | Prevents replay/version drift |
| Batch 03 `CustodyReceipt` | Bind receipt to exact server custody schema/failure-domain ADR and response-loss replay | Batch 03 used a future server receipt contract |
| Batch 03 endpoint cleanup | Keep `cleanup_enabled=false`; add conjunctive dependency on receipt coverage, RPO, clock/ACK grace, tombstone/restore drill, and no hold | The later gate is now specified but not passed |
| Batch 03 verification architecture | Add E04 fault/restore/capacity histories and evidence schemas to the common invariant registry | Avoid duplicate test authority |
| Accepted database decision | Record PostgreSQL reference/SQL Server candidate as context only; link final choice to ADR-B04-008/020 | No production selection in this review |
| Accepted no-broker decision | Add measured trigger categories and baseline-change requirements from ADR-B04-011 | Prevent “6,000 devices” from becoming broker rationale |
| Proof-gate catalogue | Add Batch 04-local gate aliases and preserve accepted global order; do not renumber deletion/restore based on topic-local G11 name | Resolves C04-18 |

## 9.3 ADR acceptance rule

An ADR cannot move from `PROPOSED` to `ACCEPTED` when it:

- assigns a **HUMAN DECISION** to engineering by default;
- embeds an **ESTIMATE** as a timeless numeric requirement;
- lacks a smallest falsifying experiment, migration/rollback consequence, owner, support path, and evidence expiry;
- relies on a repository without exact source/tag/commit, license, security, tests, fit, and dependency/reference classification;
- weakens a predecessor invariant silently;
- claims production approval from a technical gate.

---

# 10. Ordered implementation backlog and dependency/stop gates

## 10.1 Smallest safe critical path

| Order | Work package | Depends on | Deliverable | Stop/go gate |
|---:|---|---|---|---|
| 1 | Evidence and ownership scaffold | accepted repository/evidence baseline | Batch 04 manifest schema, allowed project graph, exact input hashes, owner/ADR templates, canary/cardinality/cleanup harness | **STOP** if an allowed input/tool/owner is missing or production projects reference test/destructive code |
| 2 | Consolidated contracts and vocabulary | 1 | strict custody/receipt/lease/effect/quarantine/lifecycle/connector/backup/restore/evidence schemas and vectors | **STOP** on unresolved identity/state/receipt contradiction or parser/oracle mutation survivor |
| 3 | Independent T1 oracle and fixture package | 2 | fictional realms/installations/batches/events/subjects/connectors/backups/fault chronology; expected receipt/effect/tombstone/restore ledgers | **STOP** if truth depends on production decision code or a canary escapes |
| 4 | Engine-neutral domain model and logical schema | 2–3 | immutable custody + narrow work split; `(realm,event_id)` identity; state machines; transaction invariants | **STOP** if either engine adapter must change business semantics |
| 5 | PostgreSQL and SQL Server isolated provisioning | 1, 4 | exact disposable profiles, roles, migrations, reset/cleanup, provider adapters, environment evidence | **STOP** if edition/license/source/image/config is ambiguous or reset is not clean |
| 6 | Atomic custody and replay prototype | 4–5 | acceptance transaction, original-receipt replay, conflict evidence, failpoints, reconciler | **B04-INGEST partial STOP** on any false receipt, duplicate custody, cross-realm result, or unknown commit guessed |
| 7 | Lease/fence/fairness and whole-batch materialization | 6 | scheduler/work table, token/fence, worker, event identity/facts, terminal quarantine/reprocess | **STOP** on stale commit, duplicate effect, partial batch, infinite poison, or unreconciled terminal state |
| 8 | Projection, contribution, integration outbox | 7 | idempotent derived work, rebuild, stable integration messages, visibility/readiness states | **STOP** on double aggregate, lost work, integration inside fact transaction, or unready visibility |
| 9 | Low-rate semantic parity and realm/security matrix | 6–8 | E04-03 through E04-08 evidence for both candidates | **STOP** one candidate/profile on any semantic/security divergence; do not continue performance comparison for a failed profile |
| 10 | Actual backup/PITR/failover and operator recovery | 9 | E04-10 evidence, receipt/effect reconciliation, runbooks, cleanup | **STOP** engine/topology on false receipt, missing acknowledged data, split-brain, pre-ready read, or unsafe operator recovery |
| 11 | Production-wire simulator and Windows fidelity subset | 2–3, Batch 03 qualified transport prerequisites | deterministic stateful/open-arrival simulator, exact wire adapter, Windows equivalence | **STOP** if wire/state differs, generator cannot be qualified, or any production value/credential appears |
| 12 | Capacity model and fully bound 6k scenario | 7–11 | executable formulas, scenario compiler, generator self-test, 6k steady/reconnect/recovery evidence | **STOP** capacity claims on generator invalidity, hard invariant failure, no recovery, or absent human objective |
| 13 | Saturation, 12k, maintenance, query, backup, and endurance | 12 | E04-14/E04-15 paired curves and first-failure evidence for surviving engine profiles | **STOP** on correctness/privacy failure, unbounded growth, hidden failed run, or no stable region |
| 14 | Database decision package | 9–13 | semantic, performance, recovery, operations, skills, edition/license/support/TCO and sensitivity matrix | **STOP** ADR if any hard gate fails, cost/topology is ambiguous, or result is weight-sensitive without explicit tie decision |
| 15 | Lifecycle policy/resolver/barrier core | 2–4, 7 | policy/hold/case/resolver/tombstone/visibility schemas, barrier transaction, read guard | **STOP** on ambiguous/cross-realm barrier, visible subject after barrier, missing audit, or tombstone discontinuity |
| 16 | Internal store adapters and derived-reader eligibility | 8, 15 | fact/inbox/quarantine/projection/cache/replica/search-fixture delete/verify adapters and watermarks | **STOP** on false verification, stale eligible reader, untyped SQL/path, or replay rematerialization |
| 17 | Connector/export registry and adapters | 8, 15 | destination revisions, object/export manifests, stable deletion commands, limitations | **STOP** on unregistered egress, guessed 2xx/404 completion, or missing owner/contract |
| 18 | Backup catalogue and chain-aware expiry prototype | 10, 15 | backup/copy/version/key/log graph, holds/replacement recovery, prepared expiry/verification | **STOP** on unknown copy/dependency/key, tool-check-only proof, or destructive order ambiguity |
| 19 | Independent tombstone/receipt recovery evidence | 6, 10, 15, 18 | content-addressed receipt-set and tombstone authority manifests/recovery path | **STOP** on second truth, gap/fork/rollback, incomplete scope, or inability to survive old business restore |
| 20 | Full old-backup/ACK/tombstone/derived-store drill | 16–19 plus exact surviving DB profile | E04-18 readiness evidence and cleanup | **B04-LIFE STOP** on any nonzero primary invariant count |
| 21 | Aggregate Batch 04 gate | all required above | E04-19, ADR/owner/evidence-expiry package | **GO to technical baseline update only** when exact-profile gates pass; `productionApproved=false` |
| 22 | Human approvals and production design | 14, 21 plus HD04 decisions | selected engine/topology, objectives, policies, owners, support, budget, pilot/rollback plan | **STOP** until designated authorities approve; technical pass is not production permission |

## 10.2 Parallel work allowed

After work packages 1–4 freeze the common semantics, these lanes may proceed in parallel:

- PostgreSQL and SQL Server adapter/provisioning work;
- simulator state model, scenario compiler, oracle, and generator self-tests;
- lifecycle pure models, exact fictional resolver, tombstone chain, and read-guard unit tests;
- connector/export registry schemas using fictional destinations;
- backup catalogue and restore-manifest schemas;
- dependency/source/license review;
- privacy-canary, evidence, cardinality, accessibility, and cleanup tooling.

Parallel lanes MUST NOT independently redefine receipt, event identity, realm, terminal batch state, tombstone, acknowledged-set authority, or readiness. Any such change returns to work package 2 and invalidates dependent evidence.

## 10.3 Work that must remain sequential

1. **Custody correctness before load.** No capacity claim may use a receipt implementation that has not passed E04-02 through E04-06.
2. **Semantic parity before engine ranking.** A candidate that fails correctness/realm/restore is disqualified regardless of throughput.
3. **Generator qualification before SUT conclusions.** E04-12 precedes 6k/12k performance interpretation.
4. **Recovery before endpoint cleanup.** No production cleanup policy proceeds until receipt failure domain, actual restore, acknowledged replay, tombstones, and human RPO/ACK decisions align.
5. **Barrier before destructive adapters.** Physical deletion prototypes cannot run against a store class before the read barrier/visibility guard for that class passes.
6. **Tombstones before restore rebuild.** Current tombstone authority is applied before replay/materialization/derived-reader enablement.
7. **Database selection before production physical design.** Portable schema/prototypes are allowed; irreversible engine-specific production coupling waits for the ADR.
8. **Technical gate before production approval.** E04-19 can only update technical baseline, never authorize live data or deployment.

## 10.4 Dependency and stop graph

```text
contracts/oracle
  -> custody/receipt
     -> lease/materialization
        -> projections/integrations
           -> database semantics/recovery
              -> capacity campaigns
              -> lifecycle store adapters
                 -> old-backup + ACK + tombstone restore
                    -> Batch 04 aggregate technical gate
                       -> human database/capacity/retention/RPO/support decisions
                          -> pilot/production authority
```

A failure at a node invalidates all dependent evidence. It does not permit a waiver, nearest-match profile, reduced evidence standard, or silent architecture fork.

## 10.5 Batch stop/go rule

**GO for the next implementation increment** only when the immediately preceding work package has:

- a content-addressed contract/schema/release/environment identity;
- zero hard invariant failures;
- no unresolved privacy canary or cross-realm result;
- complete first-failure and rerun evidence;
- an accepted cleanup receipt;
- assigned technical owner and runbook;
- no hidden **HUMAN DECISION** encoded as a default.

**STOP the batch and open/update an ADR** when:

- receipt, one-effect, realm, audit, no-silent-loss, or restore invariant fails;
- two components claim authority for the same receipt, event identity, tombstone sequence, or readiness state;
- a selected technology needs a broker, raw production data, arbitrary code, or weaker durability/isolation to pass;
- a database result cannot be reproduced under the identical profile;
- a capacity run is generator-limited, backlog-growing, unfair, or missing objectives;
- an old restore exposes a deleted subject or omits an acknowledged event;
- a required owner, license, support, RPO/RTO, retention, or production authority is absent.


---

# 11. Source and open-source quality corrections

## 11.1 Evidence hierarchy and correction rule

**RECOMMENDATION.** Batch 04 implementation and ADR evidence MUST use this order:

1. accepted predecessor invariants and this reconciled contract baseline;
2. executable UAM semantic, fault, restore, and cleanup evidence for the exact build/profile;
3. current official product specifications, lifecycle pages, standards, and regulator publications;
4. exact tagged/full-commit source and repository evidence;
5. independently reproduced generic benchmark or reference-tool results;
6. vendor marketing, popularity, stars, downloads, search snippets, and unrelated synthetic scores — discovery only, never decision proof.

A current source can establish that a feature or release exists. It cannot establish UAM correctness, capacity, operational competence, lawful use, supportability, cost fitness, or production readiness. A tagged repository can inform tests without becoming a dependency. An external tool can execute a lab step without becoming the semantic oracle.

Point-in-time release facts in this section are verified as of **1 August 2026**. They MUST be refreshed when an experiment is executed and when the database or dependency ADR is reviewed. Architecture references supported release families and evidence profiles; it does not freeze these patch numbers into a timeless design.

## 11.2 Current primary-source corrections and verified claims

| ID | Current primary-source finding | Correction or evidence-quality resolution | Architectural consequence |
|---|---|---|---|
| S04-01 | **FACT.** [PostgreSQL 18.4](https://www.postgresql.org/) was the current stable maintenance release on 1 August 2026, released 14 May 2026; PostgreSQL 19 remained a development/beta line. | Preserve the supplied 18.4 review point, but do not call a future or beta line production-current. | Every run pins exact PostgreSQL package/build/OS/configuration. The ADR is invalid if a different release is substituted without a new profile and affected reruns. |
| S04-02 | **FACT.** Microsoft's [SQL Server 2025 build history](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/sqlserver-2025/build-versions) listed CU7, build `17.0.4065.4`, released 16 July 2026, as the current CU reviewed. | Preserve SQL Server 2025 as the candidate family, but bind every result to exact CU, edition, OS, driver, durability and HA topology. | “SQL Server” is not one comparable candidate; the exact licensed edition/topology is part of the architecture and TCO evidence. |
| S04-03 | **FACT.** [Npgsql v10.0.3](https://github.com/npgsql/npgsql/releases/tag/v10.0.3), released 27 May 2026, maps to commit `d3768398c17877b3a916c3c4d87e8e11698991fc`. | The supplied runtime-candidate record is current enough for this review and has a full source revision. | It remains a runtime candidate only after NuGet, transitive, protocol, pooling, cancellation, security and support admission. |
| S04-04 | **FACT.** [Microsoft.Data.SqlClient v7.0.2](https://github.com/dotnet/SqlClient/releases/tag/v7.0.2), released 25 June 2026, maps to commit `8c70cec98444338ddb0b97be94c34fde93970241`. | The supplied runtime-candidate record is current enough for this review and has a full source revision. | It remains a runtime candidate only after managed/native SNI, authentication, encryption, retry, pooling, transitive and platform admission. |
| S04-05 | **FACT.** PostgreSQL documents that a unique or primary-key constraint on a partitioned table must include all partition-key columns: [declarative partitioning limitations](https://www.postgresql.org/docs/current/ddl-partitioning.html). | The supplied conclusion is capability evidence, not proof that a separate ledger will scale. | A non-partitioned realm/event identity ledger is the portable first candidate; its contention and lifecycle cost are a **CLI EXPERIMENT**. |
| S04-06 | **FACT.** SQL Server documents that unique partitioned indexes must include the partitioning column: [partitioned tables and indexes](https://learn.microsoft.com/en-us/sql/relational-databases/partitions/partitioned-tables-and-indexes?view=sql-server-ver17). | Resolve the PostgreSQL/SQL Server overlap the same way: identity must not silently depend on an unsettled time partition. | The common model owns global realm/event uniqueness; engine-specific fact partitions remain replaceable. |
| S04-07 | **FACT.** PostgreSQL documents that `SKIP LOCKED` gives an inconsistent view and is suitable for queue-like access, not general authoritative reads: [`SELECT`](https://www.postgresql.org/docs/current/sql-select.html). | Reject wording that treats `SKIP LOCKED` as fairness, correctness, or complete queue semantics. | Use it only inside the tested scheduling adapter; uniqueness, fencing, reconciliation and fairness remain UAM responsibilities. |
| S04-08 | **FACT.** SQL Server documents `READPAST` primarily as a work-queue technique and notes that it skips row locks, not page locks: [table hints](https://learn.microsoft.com/en-us/sql/t-sql/queries/hints-transact-sql-table?view=sql-server-ver17). | Reject wording that treats `READPAST`/`ROWLOCK` as guaranteed row locking or starvation prevention. | Page locks, escalation, missed eligibility, plan drift and fairness are mandatory paired workload tests. |
| S04-09 | **FACT.** PostgreSQL states that [`pg_verifybackup`](https://www.postgresql.org/docs/current/app-pgverifybackup.html) checks a base backup against its manifest but cannot prove that every restore or recovery will succeed. | Correct any implication that tool verification closes restore readiness. | Only an actual isolated restore, recovery, application reconciliation, tombstone replay and acknowledged-set proof can pass B04-LIFE. |
| S04-10 | **FACT.** PostgreSQL [continuous archiving and PITR](https://www.postgresql.org/docs/current/continuous-archiving.html) requires a valid base backup plus the needed continuous WAL sequence. | File presence or one valid base backup is insufficient recovery evidence. | The backup catalogue MUST model ancestry, WAL/log range, copies, keys, holds and replacement recovery points. |
| S04-11 | **FACT.** The EDPB's [CEF 2025 Right to Erasure report](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_en.pdf), adopted 10 February 2026, identifies inconsistent erasure/retention processes and explains that where modifying backup data is not advisable, requests should be tracked and applied if the backup is restored. | This supports tracked restore-time re-deletion as a defensible mechanism; it does not decide a UAM rights request, retention period, backup policy, deadline, or legal outcome. | Preserve suppress-first, backup expiry, isolated restore and pre-readiness reapplication of current tombstones. Legal case handling remains **HUMAN DECISION**. |
| S04-12 | **FACT.** [NIST SP 800-88 Rev. 2](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-88r2.pdf), September 2025, conditions cryptographic erase on the cryptographic design and sanitization of all relevant key copies and hierarchy; backed-up or escrowed keys/data require separate treatment. | Reject a universal claim that destroying one per-subject key proves deletion from shared pages, logs, replicas, caches, indexes, exports, backups and recipients. | Crypto erase is an additional boundary-specific mechanism, not the default cross-store lifecycle authority. |
| S04-13 | **FACT.** [pgBackRest 2.59.0](https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F2.59.0) maps to commit `f84c8357d49ea9452cd606531e9c4c322c41bc2e`; the official release page shows **20 July 2026**, not 8 July 2026. | Correct the date recorded in I04. The revision itself remains usable as a review point. | pgBackRest remains conditional on PostgreSQL selection, full admission and an actual UAM restore/expiry campaign. |
| S04-14 | **FACT.** [Toxiproxy v2.12.0](https://github.com/Shopify/toxiproxy/releases/tag/v2.12.0), released 18 March 2025, maps to full commit `3ccd6a79cbc6c6a72b884d295ad314b75cdf3962` and the repository publishes a security policy. | I02's “short-prefix/no-go” provenance concern is resolved by I03's full commit review. This does not establish binary/image provenance or UAM semantic fit. | It becomes a **test-only candidate after admission**, never a production component or custody oracle. |
| S04-15 | **FACT.** Current [MassTransit](https://masstransit.io/) product documentation identifies v9 as a commercial release line. | Apache-2.0 terms for the reviewed v8 repository MUST NOT be projected onto current-major operational or licensing assumptions. | MassTransit remains reference-only; any later spike requires exact current package/source/license/support review and a measured need. |

## 11.3 Corrections to source use in the supplied topic results

1. **RECOMMENDATION.** Keep official database documentation as capability evidence only. `SKIP LOCKED`, `READPAST`, partitioning, RLS, backup, PITR, replication, failover and bulk APIs do not prove that the UAM transaction/state composition is correct.
2. **RECOMMENDATION.** Keep PostgreSQL 18.4, SQL Server 2025 CU7, Npgsql 10.0.3 and SqlClient 7.0.2 only as review snapshots. Execution selects an exact supported release under lifecycle policy and records the complete digest/profile.
3. **RECOMMENDATION.** Treat managed-service documentation as a separate deployment-option source. A managed PostgreSQL or SQL Server service cannot inherit results from a self-managed topology, another provider, region, tier or SLA.
4. **RECOMMENDATION.** Do not use public TPC-like, `pgbench`, HammerDB, BenchBase, vendor or cloud benchmark scores to rank candidates. At most they are hardware/tool sanity cross-checks after the UAM semantic harness passes.
5. **RECOMMENDATION.** Treat regulator and NIST publications narrowly. They support process principles and sanitization conditions; they do not approve a UAM purpose, legal response, retention, deadline, backup policy, key architecture or risk acceptance.
6. **RECOMMENDATION.** Correct the pgBackRest release date in I04 and the Toxiproxy provenance status in I02. Neither correction changes the database or lifecycle architecture.
7. **RECOMMENDATION.** Preserve first-failure, failed-run and cleanup evidence. A repository's own test suite, signed tag, release cadence or security policy cannot substitute for UAM-specific positive/negative controls.
8. **RECOMMENDATION.** Full source commit/tag, package or binary mapping, lockfile, image digest, licence/notices and security posture are mandatory for execution. A short prefix is acceptable only for human reference where no code or binary is admitted.
9. **RECOMMENDATION.** Do not cite mutable `main`, `dev`, “latest”, unpinned documentation branches or mutable container tags as load-bearing experiment evidence.
10. **RECOMMENDATION.** Direct links in an evidence manifest identify the reviewed source; the manifest also records retrieval time, local content digest where retained, and the exact claim/limitation so a changed page cannot silently rewrite old evidence.

## 11.4 Open-source admission standard

A repository or binary may move beyond `REFERENCE ONLY` only when one admission record establishes all of the following:

1. immutable full commit/tag and exact package, archive, image or binary digest;
2. package/binary-to-source mapping, build inputs and transitive dependency graph;
3. licence, notices, commercial terms and intended-use approval;
4. maintenance state, supported release/lifecycle and security-reporting process;
5. relevant unit/integration/fault tests and independently run UAM positive/negative controls;
6. bounded execution authority, credentials, network, filesystem, database and cleanup behavior;
7. exact architectural fit and explicit semantics that remain owned by UAM;
8. SBOM/provenance and vulnerability/advisory handling;
9. accountable owner, support/runbook, upgrade/rollback and removal/replacement path.

Failure of any item leaves the project `REFERENCE ONLY` or `NO-GO AS REVIEWED`. A strong repository may still be rejected because its authority or threat model is disproportionate.

## 11.5 Consolidated repository audit

The table reconciles every repository recommendation materially used by I01–I04. “Security” means the reviewed repository had an identifiable security process/policy or a mature upstream security regime; it does not mean an independent UAM security audit was performed.

| Repository and immutable review point | Licence / commercial issue | Maintenance, tests and security evidence | UAM fit and retained ideas | Consolidated classification |
|---|---|---|---|---|
| [PostgreSQL `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4) | PostgreSQL Licence | Mature release/security process; extensive regression, isolation, recovery and TAP tests | Reference database candidate; source clarifies WAL, vacuum, locking and backup tools. Does not prove UAM fitness. | **PLATFORM CANDIDATE.** Production selection remains DBX-gated. |
| [Npgsql v10.0.3 / `d3768398…`](https://github.com/npgsql/npgsql/tree/d3768398c17877b3a916c3c4d87e8e11698991fc) | PostgreSQL Licence; exact NuGet/transitives required | Active mature provider, extensive CI/tests and public security handling | Thin PostgreSQL adapter, binary COPY, cancellation and pooling tests. Provider types/semantics stay outside domain contracts. | **RUNTIME CANDIDATE after full admission.** |
| [Microsoft.Data.SqlClient v7.0.2 / `8c70cec…`](https://github.com/dotnet/SqlClient/tree/8c70cec98444338ddb0b97be94c34fde93970241) | MIT; native/managed SNI, auth and transitive notices required | Active Microsoft provider, broad tests/security handling | Thin SQL Server adapter, `SqlBulkCopy`, pooling/session-context/retry failure tests. | **RUNTIME CANDIDATE after full admission.** |
| [pgBackRest 2.59.0 / `f84c835…`](https://github.com/pgbackrest/pgbackrest/tree/f84c8357d49ea9452cd606531e9c4c322c41bc2e) | MIT; adds repository credentials and operations surface | Active project with extensive backup/restore/archive tests and documentation | Chain/archive/catalogue ideas; command success is not readiness. | **CONDITIONAL TOOL CANDIDATE only if PostgreSQL is selected and bake-off passes.** |
| [dbatools v2.8.3 / `e1f250f…`](https://github.com/dataplat/dbatools/tree/e1f250f786c3d585a4e52ab73a9707297368d134) | MIT; broad high-authority PowerShell surface | Active releases, broad Pester tests/docs; command/remoting/credential breadth needs containment | Optional SQL Server lab/runbook automation behind a fixed allowlist; never runtime or oracle. | **LAB/OPERATIONS CANDIDATE after admission; reference initially.** |
| [Testcontainers for .NET v4.13.0 / `1717807…`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb) | MIT; every container image has separate licence/provenance | Active tests, security policy and package provenance; Docker daemon is high authority | Fast T1 contract/provider/schema tests and cleanup; not HA, physical durability, restore or licensing proof. | **TEST-ONLY CANDIDATE after image-digest/licence admission.** |
| [Toxiproxy v2.12.0 / `3ccd6a7…`](https://github.com/Shopify/toxiproxy/tree/3ccd6a79cbc6c6a72b884d295ad314b75cdf3962) | MIT; binary/image/admin API require containment | Maintained tagged release, tests, metrics and `SECURITY.md` | Deterministic TCP latency/reset/timeout/cut tests paired with UAM semantic checkers. | **TEST-ONLY CANDIDATE after full binary/image admission.** |
| [HammerDB v6.0 / `d33f879…`](https://github.com/TPC-Council/HammerDB/tree/d33f879aec858063edd17aa2daa46db03abb2bae) | GPL-3.0; executable/binary use needs Legal review | Active multi-engine release, scripts/docs; no UAM oracle or dedicated reviewed security policy | Optional sealed T1 hardware/engine sanity cross-check only. | **REFERENCE/CROSS-CHECK after licence and binary pin; never primary evidence.** |
| [CMU BenchBase](https://github.com/cmu-db/benchbase) mutable `main` | Apache-2.0; Java/JDBC/Maven runtime | Active CI/workloads; correctness issues reinforce independent oracle need; no immutable reviewed source | Rate/mix/histogram ideas only. Cannot execute a gate from mutable source. | **NO-GO FOR EXECUTION AS REVIEWED; REFERENCE ONLY until full commit/dependencies are pinned.** |
| [Microsoft SQL Server samples](https://github.com/microsoft/sql-server-samples), reviewed only at prefix `1ab31bc` | MIT repository with possible per-sample notices | Heterogeneous examples; support/security/testing varies by directory | Small syntax examples may be re-reviewed against current docs. | **NO-GO FOR EXECUTION/COPY AS REVIEWED until full SHA and selected-file audit.** |
| [River v0.40.0 / `cd033be…`](https://github.com/riverqueue/river/tree/cd033bea27ed7db8cb0dc778c0465b53b3113b32) | MPL-2.0; Go and file-level copyleft considerations | Active tests/migrations; PostgreSQL-specific queue | Queue leasing/uniqueness test ideas; not a two-engine UAM dependency. | **REFERENCE ONLY.** |
| [MassTransit v8.5.9](https://github.com/MassTransit/MassTransit/tree/v8.5.9) | v8 repository Apache-2.0; current v9 is commercial and needs new terms | Large mature test/source estate and security process; current-major transition is material | Transactional outbox/retry/fault ideas; general bus, serializer and transport authority is disproportionate. | **REFERENCE ONLY; current-major adoption rejected without fresh licence/support/fit review.** |
| [CAP v10.0.1](https://github.com/dotnetcore/CAP/tree/v10.0.1) | MIT plus selected plugin/transitive licences | Active providers/tests; broad plugin/dashboard surface; no dedicated reviewed security policy established | Local outbox/retry/backpressure lessons; not endpoint custody or narrow modular-monolith authority. | **REFERENCE ONLY.** |
| [Brighter 10.7.0](https://github.com/BrighterCommand/Brighter/tree/10.7.0) | MIT plus optional provider/transport transitives | Active release/tests/benchmarks; recent concurrency/outbox fixes; no dedicated reviewed security policy established | Inbox/outbox/sweeper/provider-parity test ideas; dynamic handler/service-activator authority is too broad. | **REFERENCE ONLY.** |
| [Wolverine V6.24.2 / `d49a1f5…`](https://github.com/JasperFx/wolverine/tree/d49a1f5b472aa4b2765528503337ce0ce131e744) | MIT plus companion/provider/support considerations | Very active, extensive source/repro/tests; no dedicated reviewed security policy established | Retention-growth, ownership/catch-up, dead-letter and pruning regressions become mandatory UAM tests. Framework architecture is rejected. | **REFERENCE ONLY.** This supersedes the older V6.22.0 review point in I01. |
| [`pg-boss` 12.26.3 / `b98853b…`](https://github.com/timgit/pg-boss/tree/b98853bf67032ccca996edfa675d0c07c6182369) | MIT; Node.js mismatch | Active tests; severe group-concurrency plan regression is useful negative evidence; no dedicated reviewed security policy established | Add skew/plan/fairness/CPU-knee tests; do not adopt its schema or “exactly once” wording. | **REFERENCE ONLY.** |
| [Grafana k6 v2.1.0 / `83a87a4…`](https://github.com/grafana/k6/tree/83a87a41e2c56eedbadbab4001dc11fe78d95942) | AGPL-3.0; extension/embedding/service use needs Legal review | Active, broad tests/security/support; signed release point | Independent open-arrival/dropped-start cross-check; cannot own UAM device state, wire truth or custody semantics. | **REFERENCE ONLY initially; optional isolated cross-check after admission.** |
| [NBomber v6.5.0 / `68aa75d…`](https://github.com/PragmaticFlow/NBomber/tree/68aa75d12fde2fccd5d9ef50b5212d21ffc53b6e) | Organizational use is commercially licensed; exact vendor terms required | Recent deterministic runner work; source/examples/performance project; dedicated security policy not established | Independent .NET arrival-model comparison only; never device-state/oracle authority. | **REFERENCE ONLY / PROCUREMENT-GATED.** |
| [Azure IoT Telemetry Simulator 1.15.0 / `e475619…`](https://github.com/Azure-Samples/Iot-Telemetry-Simulator/tree/e47561951c54bab746e90279590f8b23cef4d265) | MIT files; examples use cloud connection strings/SAS and service-specific infrastructure | Tagged but old 2023 release, tests/security/automation; release-signing key shown expired in reviewed record | Device partition/distribution ideas only; identity, AMQP multiplexing and cloud success semantics conflict with UAM. | **REFERENCE ONLY; no package/image/credential/deployment adoption.** |
| [Kubernetes v1.36.3](https://github.com/kubernetes/kubernetes/tree/v1.36.3) | Apache-2.0; enormous platform dependency | Very active, formal security response and extensive conformance/e2e tests | Finalizer/pending-dependency/stuck-work ideas only; UAM deletion is not Kubernetes resource lifecycle. | **REFERENCE ONLY.** |
| [Apache Kafka 4.3.1](https://github.com/apache/kafka/tree/4.3.1) | Apache-2.0; broker operations/security/cost are major commitments | Active ASF release, broad tests and formal security/release process | Tombstone-horizon lesson only; compaction is not erasure or immediate deletion. | **REFERENCE ONLY; no broker default.** |
| [Apache Cassandra 5.0.8](https://github.com/apache/cassandra/tree/cassandra-5.0.8) | Apache-2.0 | Active ASF maintenance/tests/security | Zombie-resurrection/marker-horizon negative evidence; distributed Cassandra storage is unnecessary. | **NEGATIVE REFERENCE ONLY.** |
| [Debezium v3.6.0.Final](https://github.com/debezium/debezium/tree/v3.6.0.Final) | Apache-2.0; usually adds CDC/Kafka deployment surface | Active releases and extensive connector/integration CI | Stable delete-record/outbox ideas only; CDC cannot decide scope, backups, read barriers or recipient completion. | **REFERENCE ONLY.** |
| [restic v0.19.1](https://github.com/restic/restic/tree/v0.19.1) | BSD-2-Clause; cryptographic repository is security-sensitive | Active release, broad tests and published security handling | Forget/prune/check and inventory staging ideas; not transaction-consistent database backup and not physical-erasure proof. | **REFERENCE; CONDITIONAL NON-DATABASE T1 UTILITY after admission.** |
| [OpenSearch Index Management 3.6.0.0](https://github.com/opensearch-project/index-management/tree/3.6.0.0) | Apache-2.0; requires aligned cluster/plugin operations | Active release-aligned CI/integration tests and project security process | Explicit derived-index actions/retries/history ideas; not cross-store or subject-lifecycle authority. | **REFERENCE ONLY; search technology remains unselected.** |
| [Mozilla Glean v69.0.0](https://github.com/mozilla/glean/tree/v69.0.0) | MPL-2.0; file-level copyleft if modified/distributed | Active Mozilla release, broad cross-language tests and data-review discipline | Prioritized deletion signal/local clearing lesson only; signal delivery is not backend completion. | **REFERENCE ONLY.** |

## 11.6 Repository decisions by execution boundary

| Boundary | Approved posture after this review |
|---|---|
| Production server runtime | Only the selected database provider and narrowly admitted direct dependencies. No generic inbox/outbox, broker, workflow, CDC, search or telemetry framework is authorized by Batch 04. |
| Database platform | PostgreSQL and SQL Server remain candidates. Exact engine/edition/topology is selected only by the paired gate and human ADR. |
| Trusted T1 integration CI | Testcontainers MAY be admitted for fast semantics; results do not establish physical durability, HA, licensing or production capacity. |
| Isolated fault lab | Toxiproxy MAY be admitted for TCP faults; semantic failpoints, real process/database/storage faults and independent reconciliation remain mandatory. |
| Database operations lab | pgBackRest or dbatools MAY be admitted conditionally for the selected candidate after least-authority command profiles and cleanup are proved. |
| Independent benchmark cross-check | HammerDB, k6 or NBomber MAY be used only after licence/procurement/admission and cannot rank engines or define UAM truth. |
| Design/regression input | All remaining repositories stay `REFERENCE ONLY`; no package, service, schema, handler model, broker or control plane is inherited. |

## 11.7 Public-source quality conclusion

**RECOMMENDATION.** The supplied public-source research is broadly strong enough to support the proposed architecture, subject to the corrections above. The load-bearing claims are deliberately modest:

- relational transactions, queue-lock primitives, partitioning, backup and restore capabilities exist;
- both database candidates can plausibly implement the portable contract;
- backup verification is not an actual restore;
- partitioned uniqueness and queue-lock behavior create measurable design constraints;
- regulator guidance supports tracked restore-time erasure handling rather than blind backup mutation;
- cryptographic erase is conditional and cannot be generalized across uncontrolled copies;
- external projects provide test ideas, not UAM semantics or automatic dependencies.

No public source establishes production engine choice, capacity, SLO/RPO/RTO, retention, legal outcome, broker need, external erasure completion, or production readiness. Those remain **CLI EXPERIMENT** and **HUMAN DECISION** matters.

---

# 12. Confidence by major conclusion, residual risk, blocked dependencies, and baseline-update conditions

## 12.1 Confidence by major conclusion

Confidence describes the strength of the architecture/review conclusion, not production readiness. A **High**-confidence rule can still require a **CLI EXPERIMENT** because documented capability and reasoning do not prove the exact implementation or environment.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| The initial server should remain a modular monolith with a relational durable inbox and leased workers | **High** | It is the accepted predecessor baseline and the four results converge without a measured broker requirement. | A smaller or brokered alternative that passes identical custody, one-effect, realm, restore, capacity, operations, migration and cost gates with lower total risk. |
| A receipt must be returned only after the exact custody transaction commits | **High** | Returning it earlier can authorize endpoint deletion without recoverable custody. | A different explicitly declared custody substrate that atomically binds bytes and receipt and passes old-restore/replay/failover proof through a change proposal. |
| Immutable custody rows and mutable scheduling/work rows should be separate | **High** | It narrows mutation authority, lock/index amplification, audit ambiguity and accidental receipt/payload changes. | Paired implementation evidence showing a co-located design is simpler while preserving immutability, performance, reconciliation and least privilege under all faults. |
| Batch replay identity requires both exact canonical-content and exact wire evidence | **High** | Endpoint batches are sealed once; recompression or changed bytes after ambiguity must not be guessed equivalent. | An accepted protocol revision that defines one different canonical replay identity and proves gateway, endpoint, restore and conflict behavior. |
| Ordinary event uniqueness belongs at `(realm_id, event_id)` | **High** | The endpoint owns one stable event ID; adding installation to uniqueness could allow a clone/re-enrollment to create a second effect. | A predecessor-approved identity contract explicitly making installation part of event identity, with migration, clone, replay, correction and conflict evidence. |
| A separate non-partitioned event-identity ledger is the first portable candidate | **Medium-High** | It avoids making global identity depend on partition grain in either engine. Its contention/storage cost is unmeasured. | Measured reconnect/saturation/retention results showing an unacceptable hotspot, or an equally safe partitioning/key model approved by ADR. |
| Whole-batch materialization/quarantine is the safer first-slice semantic boundary | **Medium-High** | It gives one receipt-to-terminal outcome and avoids partial replay/cleanup ambiguity. | Measured poison amplification or batch-size pressure plus a complete per-event terminal, receipt-status, replay, repair and endpoint-cleanup contract that reduces total risk. |
| Terminal quarantine should be separate from immutable custody and ordinary event identity | **High** | Reprocessing generations must preserve original bytes/receipt and prior failure evidence without inventing an ordinary event effect. | A simpler append-only model that preserves every generation, one-effect semantics, replay and audit without mutating custody. |
| Realm-first application/schema keys plus RLS as defense in depth are appropriate | **High** | Application authorization remains primary; RLS helps contain coding/pool-context faults but privileged bypass remains possible. | Negative tests showing the chosen RLS/session model is unreliable or imposes unacceptable operational risk, requiring an equally strong alternative defense. |
| PostgreSQL must remain the reference candidate and SQL Server a full serious candidate until the database gate | **High** | This is accepted baseline; both document required primitives and neither has UAM fitness evidence. | A recorded human strategic/procurement constraint removes a candidate, or one exact candidate repeatedly fails a non-waivable semantic/restore gate. |
| The production engine/edition/topology can be selected now | **Low / not established** | No paired production-shaped semantic, recovery, operations, skills, licensing and TCO evidence exists. | A complete DBX evidence package, robust decision/sensitivity result and accountable approvals. |
| One portable semantic workload with thin engine adapters is the fairest primary comparison | **High** | It controls business-semantic drift while permitting native SQL, bulk, telemetry and recovery implementations. | A demonstrated UAM requirement that cannot be represented portably without materially distorting one candidate, followed by a reviewed asymmetric comparison method. |
| Queue primitives such as `SKIP LOCKED` and `READPAST` are scheduling aids, not fairness/correctness proof | **High** | Official documentation narrows their semantics and does not guarantee global visibility, row locking or starvation freedom. | No likely architectural reversal; evidence may choose a different scheduler/claim mechanism. |
| The capacity simulator must be stateful and reuse production wire/receipt logic | **High** | Stateless virtual users cannot represent sealed batches, ambiguity, local backlog, policy/version state or one-effect replay. | A reviewed external or simpler tool that proves identical durable device state, production bytes, deterministic replay and independent truth with less authority. |
| An independent open-arrival lane is required | **High** | Closed loops reduce offered load when the server slows and can hide overload. | Another scheduler that independently preserves intended arrival times and records delayed/dropped starts and generator saturation. |
| A smaller exact Windows fidelity cohort can validate the large logical lane | **Medium-High** | It controls cost while checking endpoint TLS/compression/retry/runtime behavior; equivalence is not yet executed. | Windows results showing material timer, socket, TLS, EDR, CPU, memory or retry behavior absent from generic agents, requiring a larger Windows lane. |
| Passing a 6,000-device scenario is a production capacity statement | **Low / rejected as a claim** | Endpoint count omits events, bytes, sessions, retries, outage, retention, queries, topology, objectives and generator capacity. | No evidence can make endpoint count alone sufficient; a complete bound scenario may support a narrowly worded exact-profile claim. |
| Exact production capacity, worker count, index set and hardware are known | **Low / not established** | Representative distributions, objectives, retention, query corpus, infrastructure and operations evidence are absent. | Approved metadata distributions, qualified simulator, paired saturation/recovery/soak campaigns and human objectives. |
| A system that handles peak arrival but cannot drain backlog while serving new work is unacceptable | **High** | Queue recovery requires sustainable service rate greater than continuing arrivals and agreed recovery headroom. | A different approved operating policy that intentionally remains backlogged without violating freshness/support objectives; this would be a human decision, not a throughput proof. |
| No external broker should be added by default | **High** | Endpoint count alone is not a trigger and a broker adds custody, replay, security, schema, availability and operations surfaces. | A preregistered trigger is crossed and the smallest broker prototype passes semantics, restore, migration, cost, security and operations better than the relational design. |
| Quantitative broker triggers can be finalized now | **Medium-Low** | Trigger categories are clear, but thresholds depend on approved SLO/cost/failure-domain objectives and measured curves. | Human objectives plus relational and broker prototype evidence establish decision boundaries. |
| An authorized deletion must commit a visibility barrier before physical deletion | **High** | It is the smallest mechanism that protects asynchronous stores, caches, replicas, search, exports and old restores. | A simpler mechanism proving atomic invisibility across every store and failure without a barrier/tombstone. |
| Tombstones must be monotonic and recoverable independently of an older business-data restore | **High** | Otherwise restore, endpoint replay or derived rebuild can resurrect deleted data. | A single recovery substrate that intrinsically preserves current lifecycle state across every business restore and proves no rollback/gap/fork. |
| Acknowledged-batch coverage is a distinct restore-readiness proof | **High** | Receipt means custody; a restored business database can predate later receipts. | A receipt substrate whose immutable recovery set is inseparable from every permitted restore and has passed exact reconciliation faults. |
| Receipt rows remain the authoritative operational truth; coverage manifests are derived recovery evidence | **High** | Two writable receipt truths would create divergence and false readiness. | An accepted change proposal for a different single authoritative custody ledger with migration and endpoint semantics. |
| Backups should normally expire as chains and apply current deletion state on isolated restore rather than be edited in place | **High** | In-place editing can break immutability, signatures, ancestry and PITR; current guidance supports tracked restore-time reapplication. | A selected backup technology proves supported selective mutation, chain integrity, actual restore, lower total risk and legal/records acceptance. |
| `pg_verifybackup`, backup checksums or provider status are not restore proof | **High** | Official documentation and accepted invariants require actual application recovery and reconciliation. | No likely reversal; a future platform might supply an independently witnessed full-restore service, but UAM readiness probes would still be required. |
| Per-subject cryptographic erasure should not be the default | **High** | Shared pages, indexes, WAL/logs, derivatives, caches, backups, key copies and recipients defeat a simple universal assurance claim. | A measured object/key model isolates every relevant copy and passes key-destruction, backup, escrow, cache and recovery verification. |
| Every external recipient copy can be technically erased by UAM | **Low / not established** | Human downloads and unsupported recipients are outside UAM control. | Exact destination contracts plus independently verified recipient-side deletion or legally approved limitation evidence. |
| The lifecycle controller can initially remain inside the modular monolith with relational leased work | **Medium-High** | It matches the accepted architecture and no measured fan-out/failure-domain need exists. | Throughput, isolation, replay or operations evidence showing relational lifecycle work cannot meet approved requirements, followed by a successful bounded alternative. |
| Batch 04 can authorize production endpoint cleanup after this review alone | **Low / explicitly false** | Receipt, restore, RPO, ACK grace, clock, lifecycle and human gates are open. | All technical and human cleanup-eligibility conditions in section 12.4 pass for the exact production profile. |
| The consolidated Batch 04 architecture is coherent enough for implementation prototypes | **High** | Contradictions have a single resolved authority and no accepted predecessor invariant needs changing. | A model counterexample or prototype showing that custody, event identity, restore or lifecycle cannot compose without changing a predecessor decision. |

## 12.2 Unresolved risks and containment

| Unresolved risk | Current containment | Evidence or decision required to reduce it |
|---|---|---|
| Storage, filesystem, controller, virtualization or managed service acknowledges a commit that is later lost | Receipt failure-domain profile, exact durability settings, response-loss replay, actual failover/restore reconciliation | E04-02/E04-10 on exact topology; approved RPO and receipt class |
| Database split brain or client failover produces false receipt or duplicate effect | One-authority receipt transaction, stable IDs, fencing, conflict states, no driver inference | Real planned/unplanned failover under commit load and operator drill |
| Event-identity ledger becomes a reconnect hotspot | Narrow ledger, bounded transactions, partition-independent key, monitoring | Paired saturation/skew/late-arrival/maintenance results; alternative-key ADR if falsified |
| Queue plan degrades, page locks/escalation occur, or one realm starves others | Two-level fairness, finite classes, plan/wait capture, per-realm lag and starvation gates | 6k/12k skew/reconnect/poison campaigns on both engines |
| Load generator saturates or coordinated omission hides overload | Independent open-arrival scheduler, offered/started/delayed/dropped accounting, agent self-tests | E04-12 generator qualification and resource headroom evidence |
| Synthetic distributions underrepresent production tails/correlation | T1 sensitivity and bounded worst cases; no production claim from one scenario | Approved metadata-only T3 distributions, lineage/expiry and repeated scenario recalibration |
| Query, maintenance, backup or retention work collapses ingest headroom | Concurrent mixed workload and recovery-aware capacity gate | E04-14/E04-15 with approved query/maintenance/retention objectives |
| Backup catalogue misses a copy, version, key, WAL/log child or hold | Exact inventory, chain graph, fail-closed unknown state, prepared deletion and verification | Selected platform inventory evidence and repeated actual restore/expiry drills |
| Tombstone or acknowledged-set authority shares a hidden failure with the restored business database | Content-addressed recovery manifests, independent comparison source, readiness block | E04-17/E04-18 loss/rollback/fork campaigns and approved custody architecture |
| A stale cache, replica, search snapshot or integration replay exposes deleted data | Visibility epoch, read guard, reader eligibility/watermarks, connector kill switch | Store-specific delete/verify and old-snapshot/rebuild tests |
| Identity resolution selects the wrong person or scope | Closed typed selector, exact manifest, independent challenge, no fuzzy/name authority | Human-approved identity sources/procedure and fictional ambiguity/cross-realm tests |
| Legal hold is incomplete, late or mis-scoped | Versioned exact hold scope; suppression remains; destruction blocks on uncertainty | Legal/Records authority, hold integration and incident exercises |
| Privileged DBA/operator bypasses the normal lifecycle path | Least-privilege roles, append-only audit, direct-DML detection, read barrier at BFF, incident process | Privileged-path threat test, audit-store decision and operator separation |
| SQL/file/media remnants remain after logical delete | Distinguish logical invisibility, physical reclamation and media sanitization; no false claim | Engine maintenance evidence, provider/media policy and approved NIST-aligned sanitization plan |
| External recipient retains or re-copies data | Connector/export registry, capability-specific status, explicit limitation | Destination contracts, owner, recipient evidence or approved limitation |
| Exact dependency/release changes invalidate evidence | Content-addressed manifests, lifecycle selection, evidence expiry and rerun triggers | Release-time source/advisory review and affected regression campaign |
| Operations team cannot safely restore, fail over, diagnose or clean up | Runbooks, blind drills, finite telemetry, cleanup evidence, no production claim from automation alone | Named staffing/support model and repeated operator exercises |
| A human approves an unlawful, overly broad or operationally unsafe policy | Research does not approve policy; product ceiling, audit and human register expose authority | Legal/Privacy/Records/Product/Risk decisions and independent governance review |

## 12.3 Blocked dependencies

The following dependencies remain blocking for claims beyond pure implementation prototypes:

| Blocked dependency | Classification | Blocks | Accountable closure |
|---|---|---|---|
| Current accepted Batch 03 G5 receipt/outbox/cleanup prerequisites for the exact endpoint build | **CLI EXPERIMENT** | production endpoint cleanup and full end-to-end acknowledged replay | Endpoint Durability + Verification |
| Final ingestion/batch/receipt/error/compatibility contract bundle | **ADR + CLI EXPERIMENT** | stable simulator wire adapter, engine parity and endpoint/server integration | Contract Authority + Ingestion Engineering |
| Exact receipt failure-domain and allowed cleanup receipt classes | **HUMAN DECISION + CLI EXPERIMENT** | any endpoint deletion after ACK | Data Reliability + SRE + Risk/Product |
| Representative metadata-only demand distributions | **CLI EXPERIMENT + HUMAN APPROVAL** | production capacity, limits, headroom, worker/index/hardware choices | Capacity Engineering + Data Governance/Privacy |
| Approved query corpus and freshness/priority objectives | **HUMAN DECISION + CLI EXPERIMENT** | production engine/capacity/replica decision | Product/Data Owner + SRE |
| Exact PostgreSQL and SQL Server lab profiles, editions, licensing and support paths | **HUMAN DECISION + DEPENDENCY ADMISSION** | paired database ADR | Database Reliability + Procurement/Legal/Architecture |
| Approved SLO, error budget, maximum outage, RPO, RTO and recovery target | **HUMAN DECISION** | capacity, topology, failover, backup and endpoint cleanup | Product + SRE + Risk |
| Production retention, hold, audit, case and rights procedure | **HUMAN DECISION** | retention sweeps, destruction, backup expiry and external completion | Data Controller/Legal/Privacy/Records |
| Authoritative subject-identity source and selector procedure | **HUMAN DECISION + CLI EXPERIMENT** | real subject deletion/intake | Data Governance + IAM + Privacy |
| Complete store/export/connector/backup-copy inventory and owners | **HUMAN DECISION + CLI EXPERIMENT** | truthful deletion completion and restore readiness | Data Platform + Integration + SRE + Records |
| Tombstone and acknowledged-set recovery authority implementation | **ADR + CLI EXPERIMENT** | B04-LIFE | Data Reliability + Lifecycle Engineering |
| Broker quantitative objectives and prototype evidence | **HUMAN DECISION + CLI EXPERIMENT** | any broker adoption | Architecture + SRE + Finance/Procurement |
| Staffing, on-call, incident command, support hours and training | **HUMAN DECISION** | operational acceptance, pilot and production | Engineering Leadership + Operations |
| Budget, licence, service, storage, backup, observability and lab funding | **HUMAN DECISION** | engine/topology/capacity selection and recurring drills | Product/Finance/Procurement |
| Pilot and production risk authority | **HUMAN DECISION** | live data and deployment | Designated Production/Risk Authority |

## 12.4 Exact conditions for endpoint cleanup after ACK

Production endpoint payload cleanup remains hard-disabled unless this entire expression is true for the exact release, realm policy, receipt class and environment:

```text
ENDPOINT_CLEANUP_AFTER_ACK_ELIGIBLE =
    BATCH_03_G5_EXACT_PROFILE_PASS
    AND B04_INGEST_PASS
    AND B04_LIFE_PASS
    AND RECEIPT_FAILURE_DOMAIN_HUMAN_APPROVED
    AND RPO_RTO_HUMAN_APPROVED
    AND ACK_REPLAY_GRACE_HUMAN_APPROVED
    AND CLOCK_UNCERTAINTY_POLICY_HUMAN_APPROVED
    AND ENDPOINT_PRESSURE_AND_LONG_OUTAGE_POLICY_APPROVED
    AND PRODUCTION_RETENTION_AND_HOLD_POLICY_APPROVED
    AND SERVER_ACKNOWLEDGED_SET_RECOVERABLE
    AND TOMBSTONE_AUTHORITY_RECOVERABLE
    AND ACTUAL_OLD_BACKUP_RESTORE_PASS
    AND ZERO_MISSING_ACKNOWLEDGED_BATCHES
    AND ZERO_VISIBLE_DELETED_SUBJECTS
    AND ZERO_RECEIPT_OR_DIGEST_CONFLICTS
    AND CLEANUP_COMMAND_AND_AUDIT_PASS
    AND ACCOUNTABLE_OWNER_APPROVALS_PRESENT
```

Even when this expression is true, cleanup is enabled only through an audited narrowing policy for approved receipt classes and remains reversible by an emergency disable. A technical pass does not decide how long data should be kept or whether collection is lawful.

## 12.5 Exact conditions for database, capacity and broker decisions

### 12.5.1 Database profile selection

```text
DATABASE_PROFILE_SELECTABLE =
    BOTH_CANDIDATES_RAN_IDENTICAL_SEMANTIC_BASELINE
    AND SELECTED_PROFILE_DBX_CORRECTNESS_PASS
    AND SELECTED_PROFILE_DBX_RESTORE_PASS
    AND SELECTED_PROFILE_DBX_FAILOVER_PASS
    AND SELECTED_PROFILE_DBX_OPERATIONS_PASS
    AND SELECTED_PROFILE_CAPACITY_AND_RECOVERY_PASS
    AND SELECTED_PROFILE_QUERY_MAINTENANCE_PASS
    AND EXACT_EDITION_TOPOLOGY_LICENSE_SUPPORT_KNOWN
    AND TCO_AND_SENSITIVITY_ROBUST
    AND DATA_RELIABILITY_SRE_ARCHITECTURE_PROCUREMENT_APPROVALS_PRESENT
```

A candidate that fails a hard semantic, realm, receipt, restore or fencing gate is disqualified regardless of speed or price. If neither candidate is robust, the ADR result is `NO ROBUST WINNER`, not a forced choice.

### 12.5.2 Production capacity claim

```text
PRODUCTION_CAPACITY_CLAIM_ELIGIBLE =
    GENERATOR_SELF_TEST_PASS
    AND WINDOWS_WIRE_STATE_EQUIVALENCE_PASS
    AND SCENARIO_BOUND_TO_APPROVED_DISTRIBUTIONS
    AND EXACT_ENGINE_TOPOLOGY_RELEASE_PROFILE_SELECTED
    AND STEADY_RECONNECT_LONG_OUTAGE_QUERY_MAINTENANCE_BACKUP_RUNS_PASS
    AND BACKLOG_DRAINS_WITH_APPROVED_HEADROOM
    AND FAIRNESS_AND_NO_STARVATION_PASS
    AND SOAK_HAS_NO_UNBOUNDED_RESOURCE_OR_STORAGE_GROWTH
    AND SLO_ERROR_BUDGET_RPO_RTO_RECOVERY_TARGETS_APPROVED
    AND COST_SUPPORT_STAFFING_APPROVED
```

The resulting claim names the exact scenario, release, topology, storage, worker configuration, query/maintenance mix, duration, seed, objectives and evidence expiry. It is never phrased only as “supports 6,000 devices.”

### 12.5.3 External broker eligibility

```text
BROKER_ADR_ELIGIBLE =
    ONE_OR_MORE_APPROVED_QUANTITATIVE_TRIGGERS_CROSSED
    AND RELATIONAL_TUNING_AND_RECOVERY_OPTIONS_EXHAUSTED_OR_DISPROPORTIONATE
    AND SMALLEST_BROKER_PROTOTYPE_PASSES_CUSTODY_IDEMPOTENCY_REALM_POISON_REPLAY_RESTORE
    AND ONE_CUSTODY_AUTHORITY_AND_HANDOFF_ARE_UNAMBIGUOUS
    AND MIGRATION_ROLLBACK_AND_DUAL_RUN_RECONCILIATION_ARE_PROVED
    AND SECURITY_OPERATIONS_SKILLS_LICENSE_COST_ARE_APPROVED
    AND TOTAL_RISK_OR_COST_IS_LOWER_THAN_RELATIONAL_BASELINE
```

Crossing a trigger opens an ADR; it does not automatically authorize a broker.

## 12.6 Exact conditions for lifecycle/retention baseline values

```text
PRODUCTION_LIFECYCLE_POLICY_ACTIVATABLE =
    B04_LIFE_PASS
    AND EXACT_SUBJECT_RESOLUTION_AND_AUTHORITY_APPROVED
    AND PURPOSE_FIELDS_IDENTITY_ACCESS_AND_RIGHTS_PROCEDURE_APPROVED
    AND RETENTION_HOLD_AUDIT_CASE_BACKUP_EXPORT_CONNECTOR_POLICIES_APPROVED
    AND COMPLETE_STORE_COPY_KEY_RECIPIENT_INVENTORY_VERIFIED
    AND EVERY_REQUIRED_ADAPTER_AND_READER_GUARD_PASSES
    AND ACTUAL_RESTORE_READINESS_AND_CLEANUP_DRILL_PASSES
    AND PRIVILEGED_AUDIT_AND_INCIDENT_RUNBOOKS_PASS
    AND LEGAL_PRIVACY_RECORDS_SECURITY_SRE_PRODUCT_APPROVALS_PRESENT
```

Until this is true, lifecycle code may run only against T1 fictional data in a controlled lab. It may not accept a real rights case, execute production retention, expire a production backup, issue a destination deletion or declare a production subject erased.

## 12.7 Conditions under which Batch 04 may update the main technical baseline

The update is deliberately tiered so that accepting architecture does not smuggle in unproved product values.

### Tier A — architectural baseline update

Batch 04 MAY update the main technical baseline with the **architecture and invariants** in sections 2 and 5 when all of the following are true:

```text
B04_ARCHITECTURE_BASELINE_UPDATE =
    THIS_REVIEW_ACCEPTED_BY_ARCHITECTURE_AUTHORITY
    AND NO_UNRESOLVED_PREDECESSOR_CONFLICT
    AND CONTRADICTION_REGISTER_ACTIONS_ACCEPTED
    AND LOAD_BEARING_ADRS_B04_001_THROUGH_B04_012_CREATED_OR_UPDATED
    AND COMMON_CONTRACT_SCHEMA_STATE_MACHINE_BUNDLE_CONTENT_ADDRESSED
    AND EVENT_IDENTITY_RECEIPT_TOMBSTONE_ACKNOWLEDGED_SET_AUTHORITIES_UNAMBIGUOUS
    AND SOURCE_AND_REPOSITORY_CORRECTIONS_INCORPORATED
    AND BLOCKING_TECHNICAL_OWNER_FUNCTIONS_ASSIGNED
    AND ALL_NUMERIC_OR_POLICY_VALUES_REMAIN_EXPLICITLY_PROVISIONAL
    AND PRODUCTION_APPROVED_EQUALS_FALSE
```

This tier accepts the relational-custody, portable-database-experiment, stateful-simulator, suppress-first lifecycle and isolated-restore design as the implementation direction. It does **not** claim the implementation passes, select a database, choose capacity, set retention/RPO/RTO, add a broker, enable endpoint cleanup or authorize production.

### Tier B — implemented ingestion baseline update

The main technical baseline MAY mark the server custody/idempotency path as proved only when:

```text
B04_INGESTION_IMPLEMENTATION_UPDATE =
    B04_ARCHITECTURE_BASELINE_UPDATE
    AND B04_INGEST_PASS
    AND EXACT_RELEASE_ENGINE_TOPOLOGY_EVIDENCE_CURRENT
    AND ZERO_PRIMARY_INVARIANT_FAILURES
    AND CLEANUP_AND_RERUN_EVIDENCE_COMPLETE
```

The evidence statement names the exact failure domain and explicitly says whether endpoint cleanup remains disabled.

### Tier C — database and capacity baseline update

The main technical baseline MAY name a production database profile, physical design and capacity envelope only when `DATABASE_PROFILE_SELECTABLE` and `PRODUCTION_CAPACITY_CLAIM_ELIGIBLE` are true and the accountable human decision package is accepted. Any later material change to release, edition, topology, storage, schema, workload, retention, query mix or objectives expires affected evidence.

### Tier D — lifecycle and restore baseline update

The main technical baseline MAY mark lifecycle/restore readiness proved and record approved retention/backup/connector mechanics only when `PRODUCTION_LIFECYCLE_POLICY_ACTIVATABLE` is true. Technical completion and legal/rights completion remain separate fields.

### Tier E — endpoint cleanup and production use

Endpoint cleanup after ACK, pilot and production remain separate decisions. They require the expressions in sections 12.4–12.6 plus the designated production/risk authority. No Tier A–D technical update alone authorizes them.

## 12.8 Final residual risk and disposition

**Residual risk.** Even after every Batch 04 technical gate passes, UAM can still be affected by a storage device or service violating durability assumptions; a disaster outside the tested failure envelope; an unrepresentative workload shift; a database/provider defect; a privileged operator bypass; incomplete copy/recipient inventory; a wrong human subject, hold or policy decision; surviving media/key copies; external recipients retaining data; and common-mode defects in implementation and oracle. Actual tests prove only the exact profile and failure exercised. Repeated drills, evidence expiry, least authority, independent reconciliation, truthful limitations and human governance reduce—not eliminate—these risks.

**Blocked production decisions.** Production database/edition/topology, capacity, SLO/error budget, RPO/RTO, retention, backup policy, legal hold, rights outcome, access, external-recipient obligation, broker, budget, staffing, support and production risk acceptance remain open.

**Current disposition.**

- **GO** for the ordered T1 implementation and CLI work in section 10.
- **GO** for Tier A architecture-baseline adoption only after its exact acceptance conditions are met.
- **STOP** all production endpoint cleanup after ACK.
- **STOP** database, capacity, broker, retention, backup-expiry and production-lifecycle selections until their measured and human gates pass.
- **STOP** restored ordinary reads, receipt issuance, exports and connector egress until B04-LIFE readiness passes.
- **STOP** pilot and production until the designated authorities approve the exact evidence-bound profile.

No accepted predecessor decision is silently replaced. Any implementation that requires early receipt, payload-derived realm, duplicate ordinary effects, silent loss, broker-as-default, fuzzy deletion scope, pre-readiness restore access, or false external-erasure completion MUST open a formal baseline change proposal with new primary evidence, affected invariants, alternatives, smallest falsifying experiment, security/privacy impact, migration/rollback consequence and ADR action.
