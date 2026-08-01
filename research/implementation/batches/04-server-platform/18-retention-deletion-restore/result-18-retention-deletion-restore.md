# Prompt 18 research result — retention, deletion, backup, restore, tombstones, exports, and integration deletion

**Result path:** `batches/04-server-platform/18-retention-deletion-restore/result-18-retention-deletion-restore.md`  
**Research date:** 1 August 2026  
**Decision status:** **ACCEPT AS AN IMPLEMENTATION ARCHITECTURE; THE G11 LIFECYCLE/RESTORE GATE REMAINS OPEN**  
**Primary gate:** **A restored environment exposes neither missing acknowledged events nor deleted fictional subjects before it is declared ready.**  
**Authority boundary:** this result designs mechanisms and proof gates. It does not approve purpose, lawful basis, identity level, retention periods, legal holds, rights outcomes, RPO/RTO, backup policy, export or integration obligations, database selection, budget, staffing, pilot, or production.

## Evidence vocabulary

- **FACT** — directly supported by an allowlisted project input or current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — proposed decision with alternatives and trade-offs.
- **UNKNOWN** — missing evidence.
- **HUMAN DECISION** — legal, policy, ownership, budget, risk, support, or business authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed implementation baseline for this topic. They do not convert an unknown, human decision, or unexecuted experiment into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION.** Build a realm-scoped lifecycle control plane inside the accepted modular monolith. Use relational cases, a monotonic tombstone ledger, leased workers, typed store adapters, a connector/export registry, a backup catalogue, and an isolated restore-readiness gate. Do not add a broker or general workflow platform by default.

The safety rule is:

> **Hide first, delete second, verify third. After a restore, keep every normal read and every integration disabled until current tombstones and acknowledged-event coverage are both reconciled.**

The design has six load-bearing mechanisms:

1. **Visibility barrier.** An authorized deletion first commits a suppression tombstone and advances a realm visibility epoch. BFF, APIs, caches, replicas, search, exports, and integration materializers must honor it before any physical delete runs.
2. **Explicit work graph.** The same transaction creates one target per registered store or destination. Workers execute and independently verify targets; the API never pretends all stores share one transaction.
3. **Independent tombstone authority.** Tombstones survive older business-data restores and prevent rematerialization after endpoint replay, connector retry, stale search rebuild, or replica recovery.
4. **Acknowledged-batch coverage.** A server receipt creates a durable-custody obligation. Restore readiness compares the authoritative receipted set with the restored set and replays missing exact batches under stable identity.
5. **Isolated restore.** A restored environment has a new environment identity, no ordinary read role, no connector/export egress, and no endpoint receipt authority until all readiness checks pass.
6. **Truthful external status.** External copies are inventoried. Unsupported destinations and human-downloaded exports produce `EXTERNAL_ACTION_REQUIRED` or `COMPLETE_WITH_LIMITATIONS`, never a false assertion that UAM erased a recipient's copy.

**FACT.** Accepted predecessor decisions require realm isolation, durable audit for privileged mutation, no silent loss of unacknowledged data, one final business effect after retry/replay, narrow receipt semantics, and restores that neither lose acknowledged events nor expose deleted data before readiness [P01–P07].

**FACT.** The EDPB's report adopted 10 February 2026 identifies inconsistent erasure and retention processes and states that, where backup modification is not advisable, controllers should track erasure requests and apply them when data is restored [W02].

**INFERENCE.** A database backup alone cannot satisfy the accepted invariant. The tombstone and receipt-coverage authorities must be protected independently enough that restoring an older business snapshot cannot roll them back silently.

## 1.2 Disposition

| Area | Decision | Reason |
|---|---|---|
| Lifecycle controller in modular monolith | **Accept** | Fits the accepted server architecture and avoids an unproved broker/workflow dependency. |
| Suppress before physical deletion | **Accept** | Contains visibility while slow or unavailable stores are reconciled. |
| Monotonic realm tombstones | **Accept** | Required for replay, restore, cache/search suppression, and accidental reingestion. |
| Exact typed subject resolution | **Accept** | Prevents fuzzy identity guesses and makes scope reproducible. |
| Backup expiry plus restore-time re-deletion | **Accept** | Preserves backup integrity while preventing restored visibility. |
| Per-subject cryptographic erasure by default | **Reject** | Shared pages, indexes, derivatives, key copies, backups, and recipients make the assurance unproved and operationally expensive. |
| Connector/export deletion registry | **Accept** | External lifecycle cannot be governed without capability and evidence inventory. |
| External broker or generic workflow engine | **Reject initially** | No measured throughput, fan-out, replay, or isolation need. |
| Production retention, legal outcomes, RPO/RTO | **Human decision** | Research cannot approve them. |
| G11 readiness | **Open** | No executed old-backup/tombstone/ACK replay drill exists. |

## 1.3 Confidence and residual risk

| Conclusion | Confidence | Why | Evidence that could change it |
|---|---|---|---|
| A visibility barrier must precede deletion | **High** | It is the smallest mechanism that protects asynchronous read stores and the accepted restore invariant. | A simpler mechanism proving atomic invisibility across all stores and failures. |
| Tombstones must outlive every resurrection path | **High** | Otherwise old backups, endpoint replay, connectors, or search snapshots can recreate deleted data. | A storage design that rewrites every copy safely and proves no replay source remains. |
| Acknowledged coverage is a distinct restore proof | **High** | Receipt means durable custody; a restore that omits a receipted batch violates the baseline. | A receipt failure domain intrinsically backed by immutable replay storage and proven across restore. |
| In-place editing of all backups is not the default | **High** | It threatens chain integrity and immutability; official regulator guidance supports tracked re-deletion on restore. | A selected backup platform with supported, chain-safe selective deletion and tested recovery. |
| Relational leased workers are sufficient initially | **Medium-High** | They fit the accepted modular monolith; actual load and fan-out remain unknown. | Capacity or isolation tests that fail the approved service/cost envelope. |
| Per-subject crypto erase is not the default | **High** | NIST conditions require complete key-copy and hierarchy control, which shared UAM stores do not yet prove [W03]. | A measured object/key model that isolates all copies and passes full key-destruction/recovery tests. |
| External deletion can be guaranteed | **Low** | Recipient copies and unsupported destinations remain outside direct technical control. | Exact destination contracts and verified recipient-side deletion evidence. |

**Residual risk.** A human can approve the wrong subject or retention rule; a legal hold can be incomplete; a privileged operator can bypass normal paths; external recipients can retain copies; database and search media can retain blocks until maintenance or sanitization; and crypto erase can fail if any key copy survives. The architecture contains and exposes these risks but does not make them legally or physically impossible.

## 1.4 Immediate stop/go

**GO** for strict contracts, logical schemas, T1 fictional fixtures, pure models, tombstone/read-barrier prototypes, store adapters, backup catalogue, isolated restore tooling, and the full G11 drill.

**STOP** before production retention activation, subject erasure, endpoint receipted-payload cleanup, backup expiry, connector deletion, restored read enablement, pilot, or production until the relevant human decisions and technical gates pass.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Evidence boundary

All seven allowlisted files were present. No other Project file was used.

| Ref | Allowlisted file | SHA-256 | Use and limitation |
|---|---|---|---|
| P01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted architecture/invariants; not production approval. |
| P02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Target concepts and evidence gaps; no production rates or values. |
| P03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted proof order and stop rules. |
| P04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence vocabulary and human-authority boundary. |
| P05 | `result-review-01-foundations.md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, realm identity, audit, oracle, and restore invariant. |
| P06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted stable source identity, one final effect, atomic progress, and governed correction. |
| P07 | `result-review-03-durability-release-identity.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted receipt/cleanup hold, replay, recovery, and still-open deletion/restore gate. |

## 2.2 In scope

- purpose-, field-, store-, and destination-bound retention representation;
- authorized subject deletion and exact subject resolution;
- suppression tombstones, physical deletion, legal-hold interaction, verification, and evidence;
- endpoint outbox/grace, gateway, durable inbox, quarantine, facts, aggregates, caches, replicas, search, logs, audit, exports, integrations, backups, and restored environments;
- connector/export inventory and deletion capability;
- backup chain expiry, isolated restore, restore-time re-deletion, read readiness, and acknowledged-event replay;
- cryptographic deletion boundaries and limitations;
- threat/failure behavior, incident response, secure coding, flags, observability, accessibility, cost/skills/operations, fitness functions, and T1 CLI evidence.

## 2.3 Non-goals

This result does not determine whether an individual request must legally be honored; choose lawful basis, purpose, fields, identity level, retention, holds, deadlines, RPO/RTO, backup cadence, database, index/partition design, support model, or production approval; recall a human-downloaded file; prove anonymisation from identifier removal alone; claim physical sanitization from SQL `DELETE`; or redesign endpoint collection, receipts, release, identity, diagnostics, portal, or broker policy.

## 2.4 Accepted invariants carried forward

| ID | Invariant |
|---|---|
| A18-01 | Realm/device authority is derived from authenticated context, never payload claims. |
| A18-02 | One realm/user/session cannot view, mutate, export, hold, or delete as another. |
| A18-03 | A privileged lifecycle mutation cannot succeed without durable audit evidence. |
| A18-04 | A receipt means durable custody in its declared failure domain, not validation, materialization, integration, or visibility. |
| A18-05 | Stable identities and uniqueness make retry/replay produce one final business effect. |
| A18-06 | No component silently drops unacknowledged data under pressure. |
| A18-07 | Restore neither loses acknowledged events nor makes deleted data visible before readiness. |
| A18-08 | Initial server is a modular monolith with relational durable inbox, leased workers, typed facts/aggregates, BFF/control API, and governed integrations. |
| A18-09 | No external broker is the default. |
| A18-10 | PostgreSQL is target reference; SQL Server remains a serious fallback/transition candidate; selection is benchmark- and operations-gated. |
| A18-11 | Stable source identity is not rewritten by interpretation/version changes; correction/reprocessing is separate. |
| A18-12 | Production endpoint cleanup remains disabled until receipt, RPO, ACK grace, clock, deletion, and restore rules are approved and proved. |

## 2.5 Assumptions

- **ASSUMPTION.** Server entities can use realm-first keys and stable batch, event, subject-projection, export, connector, policy, case, and backup identifiers.
- **ASSUMPTION.** The control API can authenticate an accountable principal and inject immutable realm context before parsing lifecycle payloads.
- **ASSUMPTION.** Leased workers can run in the same deployable or a separately scaled process while remaining one modular monolith.
- **ASSUMPTION.** Every derived reader can expose a tombstone/input/database watermark or be disabled.
- **ASSUMPTION.** Backup tooling can produce ancestry, log/PITR range, copy, key-reference, and integrity manifests.
- **ASSUMPTION.** Endpoint batch/event identities remain stable through the approved replay window.

## 2.6 Unknowns

- approved purpose, fields, identity level, legal basis, rights procedure, retention, holds, access, audit retention, and recipient obligations;
- production event/byte/batch/deletion/export/connector/search rates and subject fan-out;
- production database, partition/index strategy, query corpus, vacuum/ghost behavior, and operational competence;
- receipt failure domain, independent server replay store, ACK grace, RPO, and whether all acknowledged batches are recoverable without endpoints;
- backup technology, copies, object versions, immutability, keys, escrow, test cadence, and media/provider sanitization;
- current hidden/manual exports, legacy tables, logs, diagnostics, search indexes, and recipient copies;
- aggregate contribution lineage and whether any output is legally/technically anonymous;
- connector deletion capabilities and evidence semantics.

## 2.7 Gate naming

The accepted proof list places deletion/restore/acknowledged replay late in the sequence [P03]. The prompt names this topic's drill **G11**. This report uses **G11 lifecycle/restore drill** without reordering predecessor gates. A G11 pass does not substitute for durable-inbox, capacity, or outage/backpressure proof.

No accepted-baseline change proposal is raised.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Principles

1. Logical invisibility precedes physical deletion.
2. One authoritative case creates many explicit, idempotent targets.
3. Restore is a new security boundary, not merely an earlier database state.
4. Tombstones are minimized, protected lifecycle data with their own retention and access rules.
5. Audit retains proof, not deleted payload or raw selectors.
6. External completion is capability-bounded and limitations are explicit.
7. Human policy is versioned data; tenants may narrow but not broaden the product ceiling.
8. Every write, replay, rebuild, and read checks current deletion state.
9. Cross-store atomicity is not claimed; the authoritative relational transaction plus adapters and verifiers provides convergence.
10. Evidence and cleanup are first-class outputs.

## 3.2 Components and trust boundaries

| Component | Responsibility | Prohibited behavior | Owner function / boundary |
|---|---|---|---|
| Lifecycle API | Authenticate, derive realm, validate strict request, enforce idempotency/version/authorization, expose status | Fuzzy subject lookup, arbitrary SQL/path/destination, synchronous “done” claim | Control plane / IAM + Product Governance |
| Retention Policy Registry | Immutable purpose/field/store/destination policies, age basis, action, hold behavior, revision and approval | Invent durations or accept executable tenant logic | Governance / Records + Privacy + Product |
| Subject Resolution Service | Resolve approved typed selectors to exact UAM subject projections and immutable target manifest | Names/fuzzy matching, activity inference, cross-realm widening | Restricted identity boundary / Data Governance + IAM |
| Lifecycle Controller | Case state machine, target graph, leases, retries, flags, final evidence | Direct untyped store mutation or bypass of hold/barrier | Server application / Lifecycle Engineering |
| Tombstone Ledger | Append monotonic realm sequences, serve/replay current watermark, detect gap/fork/rollback | Raw source values or general-purpose audit payload | High-integrity control data / Data Reliability |
| Visibility Guard | Enforce tombstones/epoch in BFF, repositories, search, caches, exports, integration materializers | Trust stale reader eligibility or bypass query | Read boundary / API + Data Platform |
| Store Adapters | Typed prepare/delete/verify for one store class, stable idempotency | Caller-supplied SQL, scripts, object paths, or another adapter's success | Bounded module / store owner |
| Legal Hold Registry | Immutable hold scope, authority reference, effective interval and release; block destruction | Grant ordinary read/export rights or decide legal validity | Restricted governance / Legal + Records |
| Connector/Export Registry | Destination, purpose, owner, object manifests, capability, receipt contract, limitation | Unregistered egress or inferred recipient deletion | Integration boundary / Integration Owner + Privacy |
| Backup Catalogue | Chain/copy/key/log-range/tombstone/receipt watermarks, hold, expiry and test-restore evidence | Delete from date alone | Recovery boundary / SRE + Data Reliability |
| Restore Orchestrator | Isolate, restore, verify, replay tombstones, reconcile ACK coverage, rebuild derivatives, evaluate readiness | Enable reads/egress/receipts early | DR boundary / SRE + Security + Data Reliability |
| Acknowledged Coverage Ledger | Authoritative receipted batch IDs/digests and replay state per realm | Equate HTTP success with custody | Ingestion reliability / Data Reliability |
| Minimal Audit Ledger | Actor/authority/action/state/count/digest/time evidence | Raw subject selector, event payload, URL/site/path, or deleted content | Audit boundary / Security + Governance |
| Evidence Packager | Deterministic privacy-safe case/drill manifests and cleanup receipt | Credentials, internal addresses, production activity, dumps | Verification/support boundary |

## 3.3 Trust-boundary flow

```text
authenticated administrative context
  -> strict lifecycle command
  -> realm + authority checks
  -> restricted exact subject resolution
  -> immutable resolution manifest
  -> policy / rights / hold decision
  -> one relational transaction:
       deletion case
       + suppression tombstone(s)
       + realm visibility epoch
       + deterministic store/connector targets
       + integration deletion outbox
       + minimal audit event
  -> all ordinary reads suppress immediately
  -> leased workers delete and verify
  -> truthful terminal state with limitations

backup restore
  -> new isolated environment identity
  -> no ordinary read, receipt issuance, export, or connector egress
  -> restore base + logs/PITR
  -> verify engine/schema/realm/manifest
  -> replay current tombstones
  -> reconcile acknowledged batches
  -> rebuild derivatives under visibility guard
  -> negative deleted-subject probes + positive acknowledged-event probes
  -> durable readiness decision
  -> separate audited read activation
```

## 3.4 Store-by-store lifecycle matrix

Durations are **HUMAN DECISION**. “Short” or “bounded” is a design direction, not an approved number.

| Store/copy | Retention authority / age basis | Delete/suppress mechanism | Restore/replay rule | Verification | Failure containment |
|---|---|---|---|---|---|
| Endpoint outbox and ACK grace | Endpoint policy plus valid receipt, RPO, grace and clock predicates | Purge payload only after approved custody/grace; retain stable identity/tombstone evidence as required | Replayed batch keeps same IDs; server tombstone suppresses deleted events | Receipt/batch digest, cleanup state, exact retry result | Unknown/conflicting receipt, clock, hold, or restore gap blocks cleanup |
| Gateway transient body | Request lifetime and bounded retry | Drop after durable inbox transaction or definite rejection; no durable analytics | Not a recovery source | Batch digest and finite outcome only | No disk spill unless separately approved/encrypted; overflow fails safely |
| Durable inbox raw batch | Minimal custody/validation/recovery purpose using received time | Purge opaque bytes after terminal parse/materialization and approved replay predicate; mixed-subject blob may be purged as a unit once typed custody is safe | Older restored blob cannot rematerialize through active tombstone | Batch/wire digest, parser version, terminal event counts, purge proof | Quarantine on ambiguity; no ordinary UI access |
| Durable inbox event rows | Explicit purpose/field policy | Delete/suppress by realm + stable event/natural key | Stable replay dedupes; tombstone wins | Counts, keys, uniqueness, watermarks | Conflict enters hold; never guess |
| Quarantine/poison | Short support/repair purpose using received time | Delete/expire independently; no indefinite poison archive | Restored quarantine stays invisible and tombstone-filtered | Reason family, digest, age/size inventory | Cap and pause/reject safely; no raw analyst export |
| Typed facts | Purpose/field-specific observed or received age | Barrier then realm/subject/event delete; partition pruning only after proof | Restore/rebuild under current tombstones | Pre/post exact fictional key set and constraints | Target remains incomplete on mismatch |
| Subject projection / identity map | Separate identity-purpose policy | Delete or sever approved relationship; retain only required opaque suppression identity | Identity refresh cannot recreate an active deleted relation | Resolver/source version and exact manifest | Ambiguity blocks scope and readiness |
| Aggregates | Own purpose/window; never silently inherit raw policy | Subtract contribution, recompute bucket, or delete affected bucket; proven anonymous output needs separate authority | Rebuild from retained facts under tombstones | Contribution checksum and independent recompute | Hide affected aggregate until verified; unknown lineage blocks completion |
| Materialized/reporting views | Same or narrower than source | Refresh/rebuild/delete | Do not attach old snapshot before tombstone replay | Source/tombstone watermarks | Remove stale reader from eligibility |
| Application/BFF cache | No independent purpose; bounded TTL | Visibility epoch invalidation and/or targeted delete | Cold after restore; never recovery source | Epoch and negative read probes | Realm/global cache kill switch |
| Database replica | Same as primary | Replicate deletion; reader ineligible until caught up | Promotion/restore needs independent readiness | Database sequence + tombstone watermark + probes | Remove from load balancer on lag/unknown |
| Search index | Derived search purpose if introduced | Tombstone filter immediately; delete documents; rebuild/merge later | Rebuild only from tombstone-filtered facts; old snapshots read-blocked | Task result, refresh/watermark, negative searches | Disable search route; relational BFF guard remains authority |
| Logs/traces/metrics | Closed privacy-safe operational catalogue | Time-based expiry; subject deletion should normally find zero subject data | Restored logs restricted and scanned | Exact canary and cardinality evidence | Subject value is privacy incident, not ordinary lifecycle success |
| Privileged audit | Audit-specific policy | Retain minimal action shell; remove raw selector/attachment from restricted case store when due | Restore before lifecycle administration, but never ordinary payload visibility | Chain/digest, actor, authority, state, counts | Audit write failure blocks privileged transition |
| Restricted case material | Rights/hold correspondence and identity proof | Strongly restricted; redact/delete selectors and attachments under approved case policy | Remains inaccessible until authorization; not a read-readiness dependency | Access log, disposition, purge manifest | Separate encryption/access from business facts |
| Tombstone ledger | Long enough to dominate every backup, endpoint, connector, snapshot and dispute resurrection path | Supersede/expire only after conjunctive evidence that no path remains | Independently protected and replayed before reads/materialization | Monotonic sequence, no gaps/forks, chain/digest, expiry predicates | Any loss/gap/rollback blocks readiness and may block ingestion/materialization |
| Export staging object | Export purpose and explicit expiry | Revoke access first, delete object and wrapped key, verify versions | Restore remains inaccessible; export service disabled | Object/key/version inventory and negative download | Retrieved copy becomes explicit recipient limitation |
| Human-downloaded copy | External recipient obligation | No guaranteed technical recall | Not restorable by UAM | Notification/attestation if applicable | Never claim technical deletion |
| Integration delivery outbox | Destination purpose and contract | Stable deletion command after barrier; purge command payload after custody/evidence policy | Restore replays same command/idempotency key | Request/receipt digests and destination object token | Unsupported/unavailable destination remains explicit pending/limitation |
| Destination copy | Contract/destination capability | Object delete, subject delete, tombstone, overwrite, manual/contractual, or unsupported | Restored UAM must not resend deleted data | Connector-specific durable receipt or manual evidence | `EXTERNAL_ACTION_REQUIRED`, not false success |
| Database backup and WAL/log chain | Approved backup/RPO/RTO/hold policy | Chain-aware expiry; no selective edit by default | Always restore isolated; replay newer tombstones and ACK data before readiness | Tool integrity plus actual test restore and app probes | Expiry blocked by child, hold, missing replacement, copy/key uncertainty |
| Backup copies/object versions | Same policy, all copies registered | Delete every version/copy and key when chain safely expires | No direct read path | Provider inventory and deletion receipts | Unknown copy blocks expiry completion |
| Restored environment | Restore purpose and expiry | Destroy after drill/use | Global read/egress barrier until all checks pass | `readiness.json`, probes, cleanup receipt | Network/role/routing isolation; quarantine on contradiction |
| Lab/test evidence | T1 fictional experiment purpose | Deterministic cleanup/revert | Test restore is part of evidence | Content hashes, canaries, cleanup | No production values, addresses, credentials, or raw activity |

## 3.5 Retention policy representation

An immutable `retention_policy_revision` MUST bind:

- product ceiling revision and optional realm policy that only narrows it;
- `purpose_id`, `data_product_id`, `record_class`, `field_group_id`, and `store_class`;
- explicit age basis: source-observed, durably-received, materialized, case-closed, export-created, or backup-created;
- start condition and approved duration expression;
- action: suppress/delete, payload-delete/tombstone-retain, recompute, backup-chain-expire, review, or no automatic action;
- hold behavior;
- owner functions, approval reference, effective/expiry time, revision and digest;
- downstream destination/evidence profile;
- dry-run and compatibility requirements.

A physical row MUST NOT silently serve incompatible purposes. Materially different retention classes SHOULD be physically separated into purpose/field-group projections or separately encrypted objects. Retention evaluation creates deterministic candidates; it does not directly delete.

## 3.6 Subject resolution

- Only closed typed selectors are accepted, such as an approved UAM `subject_projection_id` or source-qualified opaque reference.
- Names, email fragments, display labels, fuzzy matching, and activity-derived inference are not deletion authority.
- Authenticated realm is injected outside the payload.
- The resolver emits an immutable manifest with exact projection IDs/ranges, resolver/source versions, unresolved conditions, and digest.
- High-impact scopes SHOULD be challenged by an independently implemented query/model.
- Zero, multiple incompatible, stale, or cross-realm matches yield `AMBIGUOUS` or `REVIEW_REQUIRED`; no barrier is committed.
- Later identity changes do not silently widen a case. Amendments create a higher case revision and new audit evidence.
- Raw identity evidence remains only in the restricted case store; long-lived tombstones use opaque tokens and stable UAM IDs.

## 3.7 Tombstones and read barrier

A tombstone is an append-only suppression fact, not just a soft-delete flag on a fact row. Minimum logical fields:

```text
realm_id
realm_tombstone_sequence
tombstone_id / case_id
scope_type
opaque_scope_token or stable UAM ID/range
effective_cutoff
policy/authority class
resolution_manifest_digest
status = ACTIVE | SUPERSEDED | EXPIRED
created_at / supersedes / optional expiry
previous_chain_digest / content_digest / chain_digest
```

Rules:

1. Tombstones and realm visibility epoch commit before destructive workers.
2. Every write/materializer checks the current realm tombstone sequence before a visible business effect.
3. Every ordinary read is guarded even after physical deletion reports complete.
4. Cache keys include the realm visibility epoch or results are post-filtered through the guard.
5. “Undelete” is not ordinary rollback. A higher-sequence correction may change future suppression but cannot recreate purged bytes.
6. Expiry requires proof that every restorable backup, endpoint grace copy, connector retry, export/object version, search snapshot, and derived replay source is gone or permanently blocked.
7. The ledger is protected independently enough that restoring an older business backup cannot roll it back unnoticed.

## 3.8 Audit, erasure, and cryptographic deletion

Split lifecycle records into:

1. restricted case material — selectors, identity proof, correspondence and rationale;
2. operational tombstones — minimum identifiers needed to prevent resurrection;
3. minimal audit events — case, actor/authority, policy revision, transition, target class, counts, digests, outcome and time, without deleted content.

“Immutable audit” means append-only evidence under its own approved policy, not eternal retention of payload or selector. A hold can block destruction while ordinary visibility remains suppressed.

**FACT.** NIST SP 800-88 Rev. 2 treats cryptographic erase as a sanitization technique whose assurance depends on the cryptographic implementation and sanitizing all relevant key copies and hierarchy [W03].

**RECOMMENDATION.** Use ordinary logical/physical deletion, backup expiry, and approved media/provider sanitization as primary lifecycle. Crypto erase is additional at boundaries with real key isolation: per-backup, per-export object, restricted case attachment, or measured purpose/cohort object. Per-subject database keys are not the default because database pages, indexes, WAL/logs, aggregates, caches, search, recipients, escrow and key caches remain shared or duplicated.

## 3.9 Legal holds

Technical behavior only:

- holds are immutable, realm-scoped, versioned, purpose-limited, and reference external human/legal authority;
- the same exact resolver defines scope;
- a hold blocks physical destruction and backup expiry but does not grant ordinary read/export access;
- a deletion case may commit suppression while matching data is isolated under hold;
- status is `PARTIAL_HELD`, not false completion;
- hold release is privileged/audited and re-evaluates current policy rather than exposing data;
- elapsed time alone never auto-releases a hold.

## 3.10 Realm isolation, coding, configuration, flags, and observability

Every lifecycle primary/unique key, lease, cache namespace, search alias, export/connector manifest, backup record, tombstone sequence and audit event begins with or is cryptographically bound to authenticated `realm_id`. Database row-level security may be defense in depth, but application/schema realm keys remain mandatory.

Store adapters expose typed commands only. SQL is parameterized and realm-first. Dynamic identifiers come from a compiled release-owned allowlist. Delete/sweep operations have dry-run manifests, target-set guards, time/lock/resource budgets, and kill switches; exact limits are measured. Audit and tombstone writes share the authoritative transaction. Direct deletion from controllers/BFF is prohibited by architecture tests.

**Configuration ownership is explicit.** Release Engineering owns the compiled product ceiling, contract/schema bundle, adapter catalogue, and feature-flag definitions; tenant administrators may only select approved narrower policy values; Lifecycle Engineering owns case/workflow configuration; SRE/Data Reliability owns environment-specific database, backup, key-reference, scheduler, and restore profiles; Integration owners own approved destination profiles. No tenant or operator can supply executable SQL, scripts, paths, arbitrary endpoints, or an unregistered store/connector through configuration. Every production configuration revision is content-addressed, approved by its accountable function, audited, and rollback-compatible.

Narrowing-only controls:

| Control | Effect |
|---|---|
| `lifecycle.intake.enabled` | Stop new cases; preserve status/barriers. |
| `lifecycle.physical-delete.enabled` | Pause destruction; never restore visibility. |
| `lifecycle.connector-delete.enabled` | Pause external calls without losing obligations. |
| `lifecycle.backup-expiry.enabled` | Pause backup/key destruction. |
| `lifecycle.retention-sweep.enabled` | Pause automatic candidate creation. |
| `lifecycle.restore-readiness.enabled` | Prevent `READY`; cannot force it. |
| `realm.read-block` | Deny ordinary reads/exports for one realm. |
| `global.integration-egress-kill` | Stop connector/export sends without dropping queues. |

No flag bypasses realm binding, tombstones, holds, audit, receipt meaning, or readiness.

Metrics use finite dimensions only: component, store class, operation, stage, outcome family, error family, connector capability class, backup-chain class, restore check, and build ring. Realm, subject, case, event, batch, export, destination name, backup ID, selector, URL/site/path, user, SQL, object key, and free-form exception are forbidden metric labels. Exact IDs belong in restricted evidence, not general telemetry.

## 3.11 Accessibility, operations, cost, and skills

Administrative flows must be keyboard operable, show visible focus, use text and programmatic status rather than color alone, announce asynchronous changes, distinguish suppressed/deleted/held/external/limited/ready in plain language, and provide accessible summaries plus machine-readable evidence [W15].

The smallest operational design adds modules and tables to the accepted relational platform; it does not require Kafka, Cassandra, Kubernetes controllers, OpenSearch, or a workflow SaaS. Cost drivers requiring measurement include tombstone growth, contribution lineage, raw inbox bytes, delete-induced database maintenance, search rebuilds, connector retries, backup copies, isolated restore infrastructure, and drill cadence.

PostgreSQL and SQL Server can provide transactional delete and point-in-time recovery, but physical reclamation is asynchronous and neither engine supplies UAM's cross-store tombstone or acknowledged-coverage proof. Required skills include database and backup/restore operations, transaction/lock analysis, key management, identity resolution, privacy operations, connector support, incident command, and accessible administration.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision now | Reason | Condition that changes it |
|---|---|---|---|
| Synchronous delete across every store in one API call | **Reject** | No distributed transaction covers DB, search, caches, backups, exports and external recipients; timeout/retry creates false completion. | One substrate proves all required stores and destinations with bounded failure isolation. |
| Soft-delete flag only | **Reject as completion** | Easy to bypass, leaves physical data/copies, and does not cover restore/reingestion. | Use only as the immediate visibility barrier followed by deletion and verification. |
| Physical delete before hiding | **Reject** | Slow/failing stores can remain visible. | No expected change. |
| Edit every historic backup in place | **Reject by default** | Risks signatures, immutability, ancestry, PITR/log continuity and recoverability. | Selected platform proves supported selective deletion, chain integrity, restoration and lower total risk. |
| Let backups expire without restore-time tombstones | **Reject** | An older restore can expose deleted subjects. | No expected change. |
| Per-subject encryption key and crypto-shred | **Reject as default** | Shared rows/pages/indexes/derivatives/keys/copies make proof incomplete and operations costly. | A measured object model isolates every subject copy and all key hierarchy/caches. |
| Immutable event store forever plus read tombstones | **Reject** | Conflicts with minimization and retention; increases breach/cost. | Only a separately approved purpose and demonstrably nonpersonal/held payload. |
| Native DB TTL or partition drop as sole authority | **Reject** | Cannot express purpose, fields, holds, integrations, backups and evidence. | May be an adapter optimization after the controller proves scope/holds/dry run. |
| CDC stream as deletion authority | **Reject** | Propagation is not legal scope, backup proof or destination completion. | Use only as a governed transport beneath authoritative relational cases. |
| Kafka compacted topic as tombstone ledger | **Reject initially** | Adds an unproved broker and its own compaction/delete-retention risks. | Measured fan-out/replay requires it and operations pass the same horizon/readiness tests. |
| Kubernetes finalizer/operator as lifecycle engine | **Reject as dependency** | UAM data is not Kubernetes resource lifecycle; finalizers can hang and add control-plane coupling. | Reference pattern only; infrastructure cleanup may use it later, not data-deletion authority. |
| General workflow engine/SaaS | **Reject initially** | Adds DSL, tenancy, secrets, upgrade, retention and availability surfaces without measured need. | Relational jobs fail approved throughput/isolation/cost gate and candidate passes admission. |
| Manual runbooks as normal deletion | **Reject** | Inconsistent, unscalable, hard to verify and not inherently idempotent. | Manual remains explicit fallback for unsupported destinations with evidence. |
| Delete audit with subject | **Reject generally** | Destroys privileged-action proof. | Delete subject-bearing case material; retain only minimum audit shell under approved policy. |
| Keep all audit/case content forever | **Reject** | “Audit” is not blanket purpose and creates breach/access risk. | Exact field/purpose retention remains human-owned. |
| Eventual search/cache rebuild without barrier | **Reject** | Stale copies can expose data. | No expected change. |
| Destination HTTP 2xx means deleted | **Reject** | May mean accepted/queued/non-durable. | A connector-specific contract defines a terminal durable state and verified receipt. |
| Universal `404 = success` | **Reject** | Can hide wrong realm/object/authentication. | Contract may allow authenticated idempotent not-found after independent binding proof. |
| Recipient notification means deletion | **Reject** | Notification is not technical erase. | Closure may carry an approved explicit limitation/attestation. |
| Reopen reads while restore reconciliation runs | **Reject** | Directly violates accepted invariant. | No expected change. |

## 4.1 Engine alternatives

**PostgreSQL reference.** PostgreSQL 18.4 was the current stable maintenance release verified on 1 August 2026; PostgreSQL 19 remained beta [W04]. PostgreSQL supports transactions, declarative partitioning, PITR, logical replication and `pg_verifybackup`, but ordinary `DELETE` leaves dead tuples until vacuum and PITR depends on base backup plus WAL continuity [W05–W08].

**SQL Server transition/fallback.** SQL Server 2025 provides mature full/differential/log backup and point-in-time restore, but edition/licensing, ghost cleanup/version retention, restore operations and organizational competence differ [W09–W10].

**RECOMMENDATION.** Do not let either engine's physical cleanup define UAM case completion. Completion is logical invisibility plus independent adapter verification; storage-space reclamation and media sanitization are separate evidence.

## 4.2 Change-proposal triggers

An explicit baseline change proposal is mandatory before: default broker/workflow adoption; payload-derived realm; deletion without audit; pre-readiness restore access; silent unacknowledged loss; receipt redefinition; raw subject selectors sent to endpoints; tenant SQL/scripts/paths/destinations; destructive backup mutation without recovery proof; or audit/hold used to expose ordinary deleted data.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Common normative profile

Every lifecycle HTTP, persistence, job, connector, backup, restore, audit and evidence boundary MUST have exact version, owner, realm authority, privacy stage, limits, idempotency, transaction/retry meaning, compatibility, runbook and test vectors. New UAM IDs use canonical lower-case UUIDv7 text [W13]. JSON is strict UTF-8 with closed objects, no duplicate members, remote references, implicit defaults, generic extension bags, executable type names or unbounded values. JSON Schema 2020-12 is the structural dialect [W14]. HTTP errors use privacy-safe RFC 9457 problem details [W12]. `202 Accepted` means a durable case exists; it never means deletion complete [W11].

## 5.2 Logical relational schema

Physical types, indexes, partitioning, RLS and lock syntax are adapted to the selected engine and proved in the identical benchmark. Every tenant-data key begins with `realm_id`.

### 5.2.1 Retention and hold

```sql
CREATE TABLE retention_policy_revision (
  realm_id                    UUID NULL,          -- NULL only for release-owned global ceiling
  policy_id                   UUID NOT NULL,
  revision                    BIGINT NOT NULL CHECK (revision > 0),
  status                      VARCHAR(24) NOT NULL,
  purpose_id                  VARCHAR(96) NOT NULL,
  data_product_id             VARCHAR(96) NOT NULL,
  record_class                VARCHAR(96) NOT NULL,
  field_group_id              VARCHAR(96) NOT NULL,
  store_class                 VARCHAR(64) NOT NULL,
  age_basis                   VARCHAR(40) NOT NULL,
  duration_iso8601            VARCHAR(64) NULL,
  action                      VARCHAR(48) NOT NULL,
  legal_hold_mode             VARCHAR(32) NOT NULL,
  product_ceiling_revision    BIGINT NOT NULL,
  tenant_narrowing_digest     BINARY(32) NULL,
  effective_at_utc            TIMESTAMP NOT NULL,
  expires_at_utc              TIMESTAMP NULL,
  authority_reference         VARCHAR(160) NOT NULL,
  accountable_role            VARCHAR(96) NOT NULL,
  content_digest              BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, policy_id, revision)
);

CREATE TABLE legal_hold_revision (
  realm_id                    UUID NOT NULL,
  legal_hold_id               UUID NOT NULL,
  revision                    BIGINT NOT NULL,
  status                      VARCHAR(24) NOT NULL, -- ACTIVE, RELEASED, SUPERSEDED, REVOKED
  scope_type                  VARCHAR(32) NOT NULL,
  scope_manifest_digest       BINARY(32) NOT NULL,
  authority_reference         VARCHAR(160) NOT NULL,
  effective_at_utc            TIMESTAMP NOT NULL,
  released_at_utc             TIMESTAMP NULL,
  review_due_at_utc           TIMESTAMP NULL,
  requested_by_principal_id   UUID NOT NULL,
  approved_by_principal_id    UUID NOT NULL,
  content_digest              BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, legal_hold_id, revision)
);
```

Normative enums are release-owned and closed. A lower revision never activates as rollback; prior semantics are republished at a higher revision. A hold grants no ordinary read/export authority.

### 5.2.2 Deletion case, subject resolution and tombstones

```sql
CREATE TABLE deletion_case (
  realm_id                    UUID NOT NULL,
  case_id                     UUID NOT NULL,
  case_type                   VARCHAR(32) NOT NULL,
  idempotency_key_digest      BINARY(32) NOT NULL,
  state                       VARCHAR(40) NOT NULL,
  state_version               BIGINT NOT NULL,
  requested_at_utc            TIMESTAMP NOT NULL,
  authorized_at_utc           TIMESTAMP NULL,
  barrier_committed_at_utc    TIMESTAMP NULL,
  completed_at_utc            TIMESTAMP NULL,
  policy_id                   UUID NULL,
  policy_revision             BIGINT NULL,
  authority_reference         VARCHAR(160) NULL,
  resolution_manifest_id      UUID NULL,
  resolution_manifest_digest  BINARY(32) NULL,
  bound_tombstone_sequence    BIGINT NULL,
  limitation_code             VARCHAR(64) NULL,
  requested_by_principal_id   UUID NOT NULL,
  authorized_by_principal_id  UUID NULL,
  content_digest              BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, case_id),
  UNIQUE (realm_id, idempotency_key_digest)
);

CREATE TABLE subject_resolution_manifest (
  realm_id                    UUID NOT NULL,
  manifest_id                 UUID NOT NULL,
  case_id                     UUID NOT NULL,
  resolver_profile_id         VARCHAR(96) NOT NULL,
  resolver_version            VARCHAR(48) NOT NULL,
  identity_source_revision    VARCHAR(96) NOT NULL,
  selector_type               VARCHAR(64) NOT NULL,
  selector_token              BINARY(32) NOT NULL,
  resolved_subject_count      BIGINT NOT NULL CHECK (resolved_subject_count >= 0),
  unresolved_condition        VARCHAR(64) NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  content_digest              BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, manifest_id),
  UNIQUE (realm_id, case_id, content_digest)
);

CREATE TABLE subject_resolution_item (
  realm_id                    UUID NOT NULL,
  manifest_id                 UUID NOT NULL,
  subject_projection_id       UUID NOT NULL,
  scope_class                 VARCHAR(64) NOT NULL,
  key_range_start             BIGINT NULL,
  key_range_end               BIGINT NULL,
  item_digest                 BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, manifest_id, subject_projection_id, scope_class)
);

CREATE TABLE suppression_tombstone (
  realm_id                    UUID NOT NULL,
  realm_sequence              BIGINT NOT NULL CHECK (realm_sequence > 0),
  tombstone_id                UUID NOT NULL,
  case_id                     UUID NOT NULL,
  scope_type                  VARCHAR(32) NOT NULL,
  scope_token                 BINARY(32) NOT NULL,
  effective_cutoff_utc        TIMESTAMP NULL,
  authority_class             VARCHAR(48) NOT NULL,
  resolution_manifest_digest  BINARY(32) NOT NULL,
  status                      VARCHAR(24) NOT NULL, -- ACTIVE, SUPERSEDED, EXPIRED
  supersedes_tombstone_id     UUID NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  expires_at_utc              TIMESTAMP NULL,
  previous_chain_digest       BINARY(32) NULL,
  content_digest              BINARY(32) NOT NULL,
  chain_digest                BINARY(32) NOT NULL,
  PRIMARY KEY (realm_id, realm_sequence),
  UNIQUE (realm_id, tombstone_id)
);

CREATE TABLE realm_visibility_state (
  realm_id                    UUID NOT NULL PRIMARY KEY,
  visibility_epoch            BIGINT NOT NULL,
  current_tombstone_sequence  BIGINT NOT NULL,
  read_state                  VARCHAR(24) NOT NULL,
  state_version               BIGINT NOT NULL,
  updated_at_utc              TIMESTAMP NOT NULL
);
```

### 5.2.3 Targets and attempts

```sql
CREATE TABLE deletion_target (
  realm_id                    UUID NOT NULL,
  target_id                   UUID NOT NULL,
  case_id                     UUID NOT NULL,
  target_class                VARCHAR(48) NOT NULL,
  target_locator_token        BINARY(32) NOT NULL,
  adapter_profile_id          VARCHAR(96) NOT NULL,
  required_for_completion     BOOLEAN NOT NULL,
  state                       VARCHAR(40) NOT NULL,
  state_version               BIGINT NOT NULL,
  attempt_count               BIGINT NOT NULL DEFAULT 0,
  next_attempt_at_utc         TIMESTAMP NULL,
  lease_owner_id              UUID NULL,
  lease_expires_at_utc        TIMESTAMP NULL,
  terminal_reason_code        VARCHAR(64) NULL,
  delete_evidence_digest      BINARY(32) NULL,
  verify_evidence_digest      BINARY(32) NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  updated_at_utc              TIMESTAMP NOT NULL,
  PRIMARY KEY (realm_id, target_id),
  UNIQUE (realm_id, case_id, target_class, target_locator_token)
);

CREATE TABLE deletion_attempt (
  realm_id                    UUID NOT NULL,
  attempt_id                  UUID NOT NULL,
  target_id                   UUID NOT NULL,
  attempt_sequence            BIGINT NOT NULL,
  idempotency_key             VARCHAR(180) NOT NULL,
  adapter_version             VARCHAR(48) NOT NULL,
  started_at_utc              TIMESTAMP NOT NULL,
  completed_at_utc            TIMESTAMP NULL,
  outcome                     VARCHAR(32) NOT NULL,
  safe_error_code             VARCHAR(64) NULL,
  request_digest              BINARY(32) NOT NULL,
  response_digest             BINARY(32) NULL,
  evidence_digest             BINARY(32) NULL,
  PRIMARY KEY (realm_id, attempt_id),
  UNIQUE (realm_id, target_id, attempt_sequence),
  UNIQUE (realm_id, idempotency_key)
);
```

Target classes include inbox blob/event, quarantine, fact, subject projection, aggregate, view, cache, replica, search, log scan, restricted attachment, audit minimization, export, connector object, backup obligation and endpoint replay guard. Worker code cannot invent classes at runtime.

### 5.2.4 Connector and export registry

```sql
CREATE TABLE connector_registry_revision (
  realm_id                    UUID NOT NULL,
  connector_id                UUID NOT NULL,
  revision                    BIGINT NOT NULL,
  status                      VARCHAR(24) NOT NULL,
  destination_class           VARCHAR(64) NOT NULL,
  purpose_id                  VARCHAR(96) NOT NULL,
  owner_role                  VARCHAR(96) NOT NULL,
  support_role                VARCHAR(96) NOT NULL,
  deletion_capability         VARCHAR(40) NOT NULL,
  deletion_contract_version   VARCHAR(48) NULL,
  receipt_profile_id          VARCHAR(96) NULL,
  recipient_copy_class        VARCHAR(40) NOT NULL,
  retention_policy_id         UUID NOT NULL,
  configuration_digest        BINARY(32) NOT NULL,
  approved_at_utc             TIMESTAMP NOT NULL,
  PRIMARY KEY (realm_id, connector_id, revision)
);

CREATE TABLE connector_object_manifest (
  realm_id                    UUID NOT NULL,
  connector_id                UUID NOT NULL,
  connector_revision          BIGINT NOT NULL,
  source_event_id             UUID NOT NULL,
  destination_object_token    BINARY(32) NOT NULL,
  delivery_idempotency_key    VARCHAR(180) NOT NULL,
  delivered_at_utc            TIMESTAMP NOT NULL,
  delivery_receipt_digest     BINARY(32) NULL,
  deletion_case_id            UUID NULL,
  deletion_state              VARCHAR(40) NOT NULL,
  PRIMARY KEY (realm_id, connector_id, connector_revision, source_event_id),
  UNIQUE (realm_id, connector_id, destination_object_token)
);

CREATE TABLE export_manifest (
  realm_id                    UUID NOT NULL,
  export_id                   UUID NOT NULL,
  revision                    BIGINT NOT NULL,
  purpose_id                  VARCHAR(96) NOT NULL,
  subject_scope_digest        BINARY(32) NOT NULL,
  object_locator_token        BINARY(32) NOT NULL,
  object_content_digest       BINARY(32) NOT NULL,
  wrapped_key_reference       VARCHAR(160) NOT NULL,
  recipient_copy_class        VARCHAR(40) NOT NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  expires_at_utc              TIMESTAMP NOT NULL,
  retrieved_at_utc            TIMESTAMP NULL,
  state                       VARCHAR(32) NOT NULL,
  deletion_evidence_digest    BINARY(32) NULL,
  PRIMARY KEY (realm_id, export_id, revision)
);
```

Deletion capability values: `OBJECT_DELETE`, `SUBJECT_DELETE`, `BATCH_TOMBSTONE`, `OVERWRITE`, `CONTRACTUAL_ONLY`, `NONE`. Recipient classes include controlled service, processor, joint controller, human download, and uncontrolled recipient.

### 5.2.5 Backup, receipt coverage and restore

```sql
CREATE TABLE backup_catalogue (
  backup_id                   UUID NOT NULL PRIMARY KEY,
  environment_id              UUID NOT NULL,
  engine_profile_id           VARCHAR(96) NOT NULL,
  backup_type                 VARCHAR(24) NOT NULL,
  parent_backup_id            UUID NULL,
  chain_id                    UUID NOT NULL,
  realm_scope_digest          BINARY(32) NOT NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  recoverable_from_utc        TIMESTAMP NULL,
  recoverable_through_utc     TIMESTAMP NULL,
  database_sequence_watermark VARCHAR(160) NOT NULL,
  tombstone_watermark         BIGINT NOT NULL,
  receipt_coverage_watermark  VARCHAR(160) NOT NULL,
  key_profile_id              VARCHAR(96) NOT NULL,
  wrapped_key_reference       VARCHAR(160) NOT NULL,
  manifest_digest             BINARY(32) NOT NULL,
  integrity_status            VARCHAR(24) NOT NULL,
  last_test_restore_at_utc    TIMESTAMP NULL,
  test_restore_evidence_digest BINARY(32) NULL,
  legal_hold_count            BIGINT NOT NULL DEFAULT 0,
  nominal_expires_at_utc      TIMESTAMP NULL,
  expiry_state                VARCHAR(32) NOT NULL
);

CREATE TABLE backup_copy (
  backup_id                   UUID NOT NULL,
  copy_id                     UUID NOT NULL,
  provider_class              VARCHAR(64) NOT NULL,
  object_locator_token        BINARY(32) NOT NULL,
  object_version_token        BINARY(32) NULL,
  state                       VARCHAR(24) NOT NULL,
  last_inventory_at_utc       TIMESTAMP NULL,
  deletion_receipt_digest     BINARY(32) NULL,
  PRIMARY KEY (backup_id, copy_id)
);

CREATE TABLE acknowledged_batch_coverage (
  realm_id                    UUID NOT NULL,
  batch_id                    UUID NOT NULL,
  batch_content_digest        BINARY(32) NOT NULL,
  wire_body_digest            BINARY(32) NOT NULL,
  receipt_id                  UUID NOT NULL,
  failure_domain_class        VARCHAR(64) NOT NULL,
  durably_received_at_utc     TIMESTAMP NOT NULL,
  coverage_sequence           BIGINT NOT NULL,
  replay_state                VARCHAR(32) NOT NULL,
  PRIMARY KEY (realm_id, batch_id),
  UNIQUE (realm_id, receipt_id),
  UNIQUE (realm_id, coverage_sequence)
);

CREATE TABLE restore_run (
  restore_run_id              UUID NOT NULL PRIMARY KEY,
  source_environment_id       UUID NOT NULL,
  restored_environment_id     UUID NOT NULL UNIQUE,
  requested_backup_id         UUID NOT NULL,
  target_time_utc             TIMESTAMP NULL,
  state                       VARCHAR(40) NOT NULL,
  state_version               BIGINT NOT NULL,
  network_egress_state        VARCHAR(24) NOT NULL,
  ordinary_read_state         VARCHAR(24) NOT NULL,
  connector_state             VARCHAR(24) NOT NULL,
  restored_tombstone_watermark BIGINT NULL,
  authoritative_tombstone_watermark BIGINT NULL,
  restored_ack_digest         BINARY(32) NULL,
  authoritative_ack_digest    BINARY(32) NULL,
  readiness_evidence_digest   BINARY(32) NULL,
  created_at_utc              TIMESTAMP NOT NULL,
  ready_at_utc                TIMESTAMP NULL,
  destroyed_at_utc            TIMESTAMP NULL
);

CREATE TABLE restore_readiness_check (
  restore_run_id              UUID NOT NULL,
  check_id                    VARCHAR(96) NOT NULL,
  check_version               VARCHAR(48) NOT NULL,
  status                      VARCHAR(24) NOT NULL,
  observed_digest             BINARY(32) NULL,
  expected_digest             BINARY(32) NULL,
  evidence_digest             BINARY(32) NULL,
  completed_at_utc            TIMESTAMP NULL,
  PRIMARY KEY (restore_run_id, check_id)
);
```

## 5.3 Authoritative barrier transaction

```text
BEGIN;
1. Load case by authenticated realm and idempotency key.
2. Verify state/version, authorization, resolution digest, product ceiling,
   tenant narrowing, hold result, clock confidence and kill switches.
3. Lock realm_visibility_state.
4. Allocate strictly increasing realm tombstone sequence(s).
5. Insert tombstone(s).
6. Increment visibility_epoch and current_tombstone_sequence.
7. Insert deterministic deletion targets and connector/export deletion outbox rows.
8. Append minimal privileged audit event.
9. Move case to BARRIER_COMMITTED and bind the watermark.
COMMIT;
```

After commit, ordinary reads MUST suppress matching data even if all targets remain pending. A crash before commit leaves the previous visibility state. A crash after commit resumes the same case; it never removes the barrier.

## 5.4 Deletion request/status contract

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

Realm and actor are absent from the body and come from authenticated context. The contract cannot express names, fuzzy rules, SQL, arbitrary paths, fields or destinations.

```http
HTTP/1.1 202 Accepted
Location: /lifecycle/cases/019d0000-0000-7000-8000-000000001803
ETag: "1"
```

```json
{
  "contract": "uam.lifecycle.case-status",
  "version": "1.0.0",
  "caseId": "019d0000-0000-7000-8000-000000001803",
  "state": "BARRIER_COMMITTED",
  "visibilityState": "SUPPRESSED",
  "targetSummary": {"pending": 8, "verified": 3, "held": 0, "externalActionRequired": 1},
  "limitations": ["UNCONTROLLED_RECIPIENT_COPY"]
}
```

## 5.5 Connector deletion contract

```json
{
  "contract": "uam.integration.deletion-command",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000001810",
  "deletionCaseId": "019d0000-0000-7000-8000-000000001803",
  "connectorId": "019d0000-0000-7000-8000-000000001811",
  "connectorRevision": 7,
  "operation": "DELETE_OBJECTS",
  "objectTokens": ["opaque-fictional-token-1", "opaque-fictional-token-2"],
  "idempotencyKey": "del:fictional:case:connector:target",
  "notAfterUtc": "2026-08-02T00:00:00Z"
}
```

```json
{
  "contract": "uam.integration.deletion-receipt",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000001810",
  "connectorId": "019d0000-0000-7000-8000-000000001811",
  "connectorRevision": 7,
  "state": "APPLIED",
  "appliedObjectCount": 2,
  "destinationOperationId": "opaque-fictional-operation",
  "completedAtUtc": "2026-08-01T12:00:00Z",
  "evidenceDigest": "sha-256:fictional"
}
```

`ACCEPTED` is nonterminal and is queried with the same operation ID. `NOT_FOUND` is terminal only where authenticated binding and the connector contract make it idempotent. `RETRYABLE` reuses the same key. `PERMANENT_UNSUPPORTED` becomes external action/limitation. `CONFLICT` is a safety hold.

## 5.6 Export and backup contracts

Export deletion first revokes access, then deletes object and key, then verifies all versions. A non-null retrieval time creates a recipient-copy limitation.

```json
{
  "contract": "uam.export.deletion-command",
  "version": "1.0.0",
  "exportId": "019d0000-0000-7000-8000-000000001820",
  "exportRevision": 3,
  "deletionCaseId": "019d0000-0000-7000-8000-000000001803",
  "operation": "SUPPRESS_THEN_DELETE",
  "expectedObjectDigest": "sha-256:fictional"
}
```

Backup catalogue entry:

```json
{
  "contract": "uam.backup.catalogue-entry",
  "version": "1.0.0",
  "backupId": "019d0000-0000-7000-8000-000000001830",
  "chainId": "019d0000-0000-7000-8000-000000001831",
  "backupType": "FULL",
  "parentBackupId": null,
  "engineProfileId": "postgresql-18-fictional-profile",
  "realmScopeDigest": "sha-256:fictional",
  "databaseSequenceWatermark": "fictional-lsn",
  "tombstoneWatermark": 912,
  "receiptCoverageWatermark": "fictional-coverage-1200",
  "keyProfileId": "backup-key-profile-v1",
  "manifestDigest": "sha-256:fictional",
  "integrityStatus": "VERIFIED",
  "expiryState": "ACTIVE"
}
```

Expiry requires: no hold; no retained child/log/PITR dependency; an approved replacement recovery point for every required interval/realm; exact registered copy/version inventory; safe key order; recent actual restore evidence; and current human-approved policy. A nominal expiry timestamp alone is insufficient.

## 5.7 Restore-readiness and ACK replay contracts

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
    "tombstoneWatermark": "PASS",
    "acknowledgedCoverage": "PASS",
    "deletedSubjectNegativeProbes": "PASS",
    "acknowledgedEventPositiveProbes": "PASS",
    "derivedStoreWatermarks": "PASS",
    "connectorEgressDisabled": "PASS",
    "auditAvailable": "PASS",
    "privacyCanaryScan": "PASS"
  },
  "authoritativeTombstoneWatermark": 1204,
  "restoredTombstoneWatermark": 1204,
  "authoritativeAckDigest": "sha-256:fictional",
  "restoredAckDigest": "sha-256:fictional",
  "evidenceDigest": "sha-256:fictional",
  "decidedAtUtc": "2026-08-01T14:00:00Z"
}
```

The endpoint cannot submit `READY`; the evaluator derives it from immutable evidence. Missing, stale, blocked, or failed required checks produce `READ_BLOCKED`.

ACK reconciliation computes exact sets:

```text
missing_acknowledged = authoritative_ack_set - restored_ack_set
unexpected_restored  = restored_ack_set - authoritative_ack_set
conflicting_batches  = same batch_id with different digest
```

Missing batches are replayed from independent server custody where available, then from endpoints only under approved grace and stable IDs. An active tombstone suppresses a replayed deleted event without altering receipt meaning. Any unrecoverable or conflicting acknowledged batch blocks readiness.

## 5.8 Error taxonomy and evidence

| Error family | Examples | Action |
|---|---|---|
| `CONTRACT` | unknown/duplicate field, size/version | reject, no mutation |
| `AUTHENTICATION` | invalid principal/service identity | re-authenticate only |
| `AUTHORIZATION_REALM` | wrong realm/role/cross-realm selector | reject, security audit |
| `RESOLUTION` | zero/ambiguous/stale identity | review; no barrier |
| `LEGAL_HOLD` | active/uncertain hold | suppress, block destruction |
| `POLICY` | missing/expired/broadening rule or bad clock | pause candidate/worker |
| `DURABILITY` | unknown commit, tombstone gap, ACK conflict | same-identity reconciliation; fail closed |
| `TRANSIENT_DEPENDENCY` | DB lock, search or connector timeout | bounded retry; barrier stays active |
| `PERMANENT_UNSUPPORTED` | destination cannot delete | external action/limitation |
| `VERIFICATION` | residue/stale reader after claimed delete | retry/rebuild; no completion |
| `BACKUP_CHAIN` | child/hold/missing key or manifest | block expiry |
| `RESTORE_READINESS` | missing tombstone/ACK/watermark | read/egress disabled |
| `PRIVACY` | subject value in log/evidence | kill path and incident |
| `CLEANUP` | VM/object/key/route residue | gate fails |
| `UNKNOWN` | unclassified result | fail closed and classify |

Every case/drill evidence manifest contains release/schema/policy/adapter/fixture digests, opaque realm alias, resolution digest, tombstone and receipt watermarks, target/attempt outcomes by finite class, verification IDs/digests, first failure and reruns, owners/ADRs/exceptions, UTC/clock class, canary/cardinality result, and cleanup receipt. It contains no raw subject, production activity, credentials, addresses, SQL values, object keys or SSH material.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility

## 6.1 Deletion case

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

Before the barrier, cancellation can produce `CANCELLED` with no visibility change. After the barrier, “cancel” can pause destruction but cannot remove suppression. `COMPLETE` requires every required target verified and no uncontrolled-recipient limitation; `COMPLETE_WITH_LIMITATIONS` names each approved external/held limitation.

## 6.2 Target and attempt

```text
PENDING -> LEASED -> DELETE_PREPARED
  -> DELETED | NOT_PRESENT | HELD | EXTERNAL_ACTION_REQUIRED
  -> RETRY_WAIT | PERMANENT_FAILURE

DELETED / NOT_PRESENT -> VERIFYING -> VERIFIED | RETRY_WAIT | PERMANENT_FAILURE
lease expiry -> same target under same idempotency identity
```

Lease and `PREPARED` attempt commit before destructive external I/O. An ambiguous result is queried/retried with the same operation. The verifier reads through a fresh path and records adapter version/evidence. A worker cannot mark the aggregate case complete.

## 6.3 Retention and hold

```text
POLICY_ACTIVE -> CANDIDATE_SCAN -> DRY_RUN_MANIFEST
  -> EMPTY | REVIEW_REQUIRED | AUTHORIZED_CANDIDATES
  -> IDEMPOTENT_DELETION_CASES
```

Candidate identity is deterministic from realm, policy revision, record class and evaluation interval. Unknown time, malformed age field, clock uncertainty, hold ambiguity or unusual scope never triggers permissive deletion.

```text
HOLD_DRAFT -> AUTHORITY_VERIFIED -> SCOPE_RESOLVED
  -> AMBIGUOUS | ACTIVE -> SUPERSEDED
  -> RELEASE_REQUESTED -> RELEASED -> POST_RELEASE_REEVALUATION
```

A hold arriving after barrier but before delete moves matching targets to `HELD`; suppression remains. Data already destroyed before a later hold cannot be recreated.

## 6.4 Backup expiry

```text
ACTIVE -> EXPIRY_CANDIDATE -> CHAIN_AND_HOLD_ANALYSIS
  -> BLOCKED_BY_CHAIN | BLOCKED_BY_HOLD | REPLACEMENT_REQUIRED
  -> DELETE_PREPARED -> DELETE_COPIES -> VERIFY_INVENTORY
  -> DESTROY_WRAPPED_KEYS_IF_APPROVED -> DELETED
```

Unknown child/copy/version/key becomes blocked, not assumed absent. Object deletion and key sanitization are separately evidenced.

## 6.5 Restore

```text
REQUESTED -> ISOLATED -> BASE_RESTORED -> ENGINE_VERIFIED
  -> TOMBSTONE_REPLAYING -> TOMBSTONES_REPLAYED
  -> ACK_COVERAGE_RECONCILING -> ACK_COVERAGE_RECONCILED
  -> DERIVED_REBUILDING -> DERIVED_REBUILT
  -> READINESS_VERIFYING -> READY | READ_BLOCKED | QUARANTINED
READY -> separate audited ordinary-read activation
end of drill/use -> DESTROYED + cleanup receipt
```

Mandatory order:

1. create new environment identity and deny ordinary reads, receipts, exports and egress;
2. restore base plus required WAL/log/PITR range;
3. verify engine, manifest, schema, realm and migration state;
4. obtain current independent tombstone authority and replay every post-backup sequence with no gap/fork;
5. compare exact acknowledged sets and replay missing stable batches;
6. apply tombstones during replay so deleted records never rematerialize;
7. rebuild facts, aggregates, views, search, caches and replica eligibility;
8. verify all input/database/tombstone watermarks;
9. run negative probes for deleted fictional subjects and positive exact probes for nondeleted receipted events;
10. prove zero connector/export egress and current audit/canary state;
11. commit readiness evidence;
12. separately authorize/read-enable.

## 6.6 Accidental reingestion

```text
stable batch received -> authenticated realm -> dedupe -> tombstone check
  active tombstone:
    preserve custody/receipt semantics
    record one SUPPRESSED_REPLAY outcome
    no fact/aggregate/search/integration effect
  no tombstone:
    normal validation/materialization
```

The system may durably receive and suppress; it must not falsify receipt semantics. Repeated replay creates one final suppression effect.

## 6.7 Connector/export lifecycle

```text
registered connector -> delivery/object manifest -> deletion barrier
  -> stable deletion command PREPARED -> SENT
    -> ACCEPTED -> query same operation
    -> APPLIED -> independent verify -> VERIFIED
    -> NOT_FOUND -> contract/binding check -> VERIFIED or CONFLICT
    -> RETRYABLE -> same idempotency key
    -> PERMANENT_UNSUPPORTED -> EXTERNAL_ACTION_REQUIRED
    -> CONFLICT -> SAFETY_HOLD
```

Retiring a connector does not erase its object manifest or obligations. Old command versions remain consumable until outstanding cases reach terminal state.

## 6.8 Derived-store eligibility

Every derived adapter exposes `applied_database_sequence`, `applied_tombstone_sequence`, and `visibility_epoch`, or an equivalent proved tuple. It is read-eligible only when values meet the BFF requirement. Old reader versions that do not enforce tombstones are incompatible and deploy no later than the producer that activates deletion.

## 6.9 Rollout and compatibility

1. Deploy dark schemas and contracts; intake disabled.
2. Run visibility guard in T1 observe mode and compare to independent oracle.
3. Deploy all consumers—BFF, repositories, caches, search, exports, connectors and restore tooling—before tombstone producers.
4. Activate T1 barriers with physical workers off.
5. Enable one verified adapter class at a time under kill switch.
6. Exercise connector/export hostile stubs and limitations.
7. Run old-backup G11 drill and all fault branches.
8. Run identical PostgreSQL/SQL Server lifecycle/restore benchmark if both candidates remain.
9. Obtain human decisions.
10. Bind predecessor ingestion/capacity/outage evidence before production-shaped T1 gate.

Schema changes are expand/backfill/contract and support N/N-1 during the rollback window. No enum/state/target class is removed while active cases can contain it. Tombstone encoding is append-compatible. Restore tooling supports every published supported backup profile. Policy rollback is a higher revision; completed deletion is not reversed. Exact dependency versions remain execution-time evidence.

---

# 7. Security/privacy threat and failure register

The table is the required failure/evidence matrix. Owner names are role functions, not assigned people.

| ID | Trigger/threat | Detection | Containment | Recovery and cleanup | Owner | Mandatory evidence/test | Residual risk |
|---|---|---|---|---|---|---|---|
| T18-01 | Realm supplied in body/job/cache/connector differs from authenticated realm | Context/body differential, realm-first constraints, audit | Reject before resolution; no case mutation | Correct caller; rotate credential if compromised; prove no target exists | IAM + Lifecycle Security | Cross-realm corpus across API/DB/cache/search/connector/backup | Compromised valid realm authority can act inside its realm |
| T18-02 | Wrong subject through fuzzy/stale identity | Resolver zero/multiple/stale result and independent manifest comparison | `AMBIGUOUS`; no barrier/delete | Correct source or obtain exact approved selector; purge temporary evidence | Data Governance + Rights Operations | Fictional collisions, rename, shared ID, cross-realm same reference | Human identity proof remains fallible |
| T18-03 | Accidental/malicious mass retention rule | Dry-run distribution/size guard, policy diff, approval separation | Pause sweep/destruction; no barrier until authorization | Revoke by higher revision, investigate, remove candidate rows | Records + Privacy + Security | Narrow-to-broad mutation, clock jump, all-realm partition | Authorized humans can approve harmful policy |
| T18-04 | Barrier transaction crashes/unknown outcome | DB failpoints and reconciliation | Fail closed; query same idempotency key | Resume prior committed state; no manual row edit; validate cleanup | Lifecycle + DB Reliability | Kill before/after every statement and commit | Storage can still fail outside tested boundary |
| T18-05 | Read path bypasses guard | Architecture mutation tests, exact canary, route inventory | Realm read block; remove reader | Fix consumer, rebuild, investigate any disclosure/export | API/BFF + Security | Direct table/admin/report/old-client bypass | Shadow/manual reader may be undiscovered |
| T18-06 | Cache retains deleted response | Epoch mismatch and negative probe | Bump epoch, disable realm cache | Purge namespace and verify all tiers | Cache Platform | Delete during hit, restart, regional partition | Browser/client caches outside UAM remain possible |
| T18-07 | Replica serves stale data or is promoted | Replay/tombstone watermark and probe | Remove from load balancer | Replay/restore and run readiness; drop if irreconcilable | DB Reliability | Lag, failover, stale snapshot promotion | Routing/control delay can create exposure |
| T18-08 | Search delete reports success but document remains | Independent query/document count/refresh watermark | Disable search route; BFF guard stays active | Retry or rebuild; delete old aliases/snapshots | Search Platform | Delete task loss, refresh failure, old index attach | Segment bytes persist until merge/sanitization |
| T18-09 | Aggregate retains subject contribution | Contribution checksum, independent recompute, small-cohort check | Hide affected buckets/product | Subtract/rebuild/delete bucket; clean obsolete views/caches | Data Processing + Privacy | Concurrent delete/new event, missing lineage | Anonymity remains contextual/human/legal |
| T18-10 | Raw inbox blob still contains deleted subject | Blob/event manifest mapping and canary scan | Suppress access | Reparse safely or purge whole blob once custody predicates permit; verify versions | Ingestion Reliability | Mixed-subject batch, delete before parse, corrupt blob | Whole-blob purge may reduce replay options |
| T18-11 | Quarantine becomes indefinite hidden archive | Age/size/terminal-state report | Cap/pause/reject safely; no analyst export | Fix parser or expire/delete; purge indexes/copies | Ingestion + Support | Poison event, unsupported schema, full quota | Fail-closed behavior can pressure availability |
| T18-12 | Endpoint replays deleted event | Stable IDs plus active tombstone | Receive/dedupe but suppress materialization/integration | Return stable receipt/status; purge under approved policy | Ingestion + Endpoint Reliability | Replay before/after restore and response loss | Premature tombstone expiry can resurrect |
| T18-13 | Acknowledged batch absent after restore | Exact authoritative-restored set difference | Keep reads/receipts/connectors disabled | Replay server custody then endpoint grace if approved; destroy failed restore if unresolved | Data Reliability + SRE | Old backup with post-backup receipt; both replay sources missing branch | Data can be irrecoverable if all copies gone |
| T18-14 | Deleted subject visible after old backup restore | Tombstone watermark gap and end-to-end negative probe | Global read/egress block | Replay current tombstones, re-delete/rebuild; destroy failed environment | SRE + Lifecycle | Primary G11 drill | Independent authority compromise/operator bypass |
| T18-15 | Tombstone ledger loss/rollback/fork/gap | Sequence, chain digest and independent copy comparison | Stop materialization/readiness/expiry | Restore/reconcile authority; quarantine fork; rotate integrity keys if needed | Data Reliability + Security | Delete copy, restore older ledger, same sequence/different content | Malicious authorized writer can create harmful tombstone |
| T18-16 | Tombstone expires while resurrection path exists | Expiry proof enumerates backups/endpoints/connectors/snapshots/versions | Block expiry | Extend policy; eliminate path and rerun proof | Records + Data Reliability | Hidden backup, offline endpoint, retired connector queue | Shadow copy can escape inventory |
| T18-17 | Legal hold races with deletion | Hold version check at authorization and immediately before destruction | Move target `HELD`; keep suppressed | Human review; after release re-evaluate current policy | Legal/Records + Lifecycle | Hold before barrier, after barrier, pre/post delete | Completed destruction cannot be reversed |
| T18-18 | Hold is broad/stale or grants access | Hold review and access audit | Suppression stays; deny ordinary reads | Supersede/release through privileged workflow; remove temporary access | Legal + IAM | Wrong realm/date/product, expired authority | Human/legal dispute persists |
| T18-19 | Destination accepts but never applies deletion | Poll/status timeout and reconciliation | Keep `WAITING_EXTERNAL`; stop new sends for matching objects | Query/retry same operation; escalate/manual action | Integration Owner + Support | Accepted forever, lost response, destination restart | Destination can lie or retain undisclosed copies |
| T18-20 | Destination `404` hides wrong object/realm/auth | Independent binding and auth status | `CONFLICT`; stop connector | Repair mapping/credential, re-resolve manifest, inspect adjacent objects | Integration Security | Authorized/unauthorized/already-deleted 404 variants | APIs may intentionally obscure state |
| T18-21 | Destination cannot delete or user downloaded export | Registry capability/retrieval state | Stop further sends; suppress UAM copy | Notification/contractual process/attestation or explicit limitation | Integration/Export Owner + Privacy | `NONE`, contractual-only and human-download scenarios | UAM cannot prove recipient-side deletion |
| T18-22 | Export URL/object remains usable | Token/object/version negative probe | Revoke token and mark suppressed | Delete object/key/versions/CDN cache; verify | Export Service | Download race, token reuse, object versioning | Recipient may already possess bytes |
| T18-23 | Backup expiry removes parent/only recovery point | Chain graph, interval coverage, hold and dry run | Block deletion/key destruction | Create verified replacement and rerun | Backup/SRE | Full+incremental/log chain, missing parent | Catalogue defect can misstate provider reality |
| T18-24 | Backup object/key/copy deletion is partial | Provider inventory and key audit | Mark partial/failed | Delete remaining copies/keys or restore key only if not sanitized and authorized | Backup + Cryptographic Authority | Versioning, replication, escrow, delayed key deletion | Provider internal remanence may be opaque |
| T18-25 | Backup verification passes but app restore fails | Scheduled actual restore and app-level checks | Backup not accepted as recovery point | Repair tooling/config, create replacement, preserve prior point | SRE + DB Reliability | Missing log/key, corrupt piece, wrong tool/schema | Failure can arise between drills |
| T18-26 | Restore receives users or sends integrations early | Network/route/role/egress canary | Isolate; privacy/security incident | Recreate clean environment; revoke creds; delete unintended copies | SRE + Security | Route misconfiguration, admin bypass, scheduler starts | Privileged infrastructure operator can bypass |
| T18-27 | Restore rebuilds derivatives before tombstones | Orchestrator state assertions | No reads; discard wrong derivatives | Replay tombstones first, rebuild and reverify | Restore Engineering | Step-order mutation and early worker start | Privileged internal inspection remains residual |
| T18-28 | Restore uses stale tombstone/receipt authority | Watermark/digest comparison with independent current authority | `READ_BLOCKED` | Obtain current authority and investigate outage/mix-up | Data Reliability | Stale replica, wrong environment, partition | Simultaneous compromise of both authorities |
| T18-29 | Large delete causes locks/log/WAL/lag/outage | Lock, log/WAL, CPU, disk, latency and replica instrumentation | Pause/throttle workers; barrier stays active | Smaller chunks/partition operation after measurement; engine maintenance | DB Operations | Large fictional subject under concurrent query load | Long logical-to-physical interval increases privileged exposure |
| T18-30 | Vacuum/ghost/merge mistaken for case completion | Separate logical vs reclamation states | No false sanitization claim | Run approved maintenance/media process and record evidence | DB Operations + Security | Inspect pages/segments before/after maintenance | Physical remanence remains environment-specific |
| T18-31 | Crypto erase leaves key copy | Key inventory, audit, reset and recovery attempt | Do not claim crypto erase; restrict ciphertext/key | Sanitize every key copy/hierarchy, rotate parents, clear caches/processes | Cryptographic Authority | KMS recovery window, escrow, memory, backup key | Provider internals/prior plaintext may remain |
| T18-32 | Audit write fails or leaks subject | Transaction failure and exact canary | Privileged transition fails; kill leaked sink | Repair/rerun same idempotency; delete leaked value under incident authority | Security Audit + Privacy | Failure between case/audit; logging mutation | Audit compromise can hide evidence |
| T18-33 | Logs/diagnostics/support contain subject data | All-sink exact canary/schema scan | Kill affected diagnostics/export; incident | Fix catalogue and rerun all-sink gate; delete contaminated copies | Observability + Privacy | Split/encoded canary, exception/SQL/object key | EDR/cloud products may copy outside product control |
| T18-34 | Case completes while a store/connector is unregistered | Registry-to-schema/infra reconciliation | Do not complete; block affected realm/read path as needed | Register adapter, backfill lineage and execute target | Architecture + Data Governance | Add table/bucket/index/connector mutation | Manual extracts can evade inventory |
| T18-35 | Duplicate workers/non-idempotent destination | Unique keys and operation history | Retry/query same operation only | Reconcile ambiguous result; repair lease; clean duplicate temp objects | Lifecycle Engineering | Kill after external apply before local commit | Non-idempotent third-party API remains risky |
| T18-36 | Clock rollback/uncertainty causes early expiry | Clock-confidence state and monotonic timers | Pause automatic retention/tombstone/backup expiry | Restore trusted time; rerun dry run; remove invalid candidates | SRE + Security | Forward/backward jump, timezone/leap behavior | No time source is infallible |
| T18-37 | Missing provenance/lineage makes deletion incomplete | Coverage report and unknown-target count | Suppress known scope; no false complete | Backfill lineage or delete broader safe unit under authority | Data Governance | Orphan fact, legacy relation, aggregate without contributions | Some legacy data may be unresolvable precisely |
| T18-38 | Privileged direct SQL/object/route bypass | Privileged access audit and drift detection | Revoke/break-glass containment; read block; incident | Reconstruct cases/tombstones/audit, restore verified state, rotate credentials | Security + DB/SRE | Direct SQL delete/restore, route enable, trigger disable | Insider/control-plane compromise remains residual |
| T18-39 | Evidence nondeterministic/incomplete/leaky | Schema/digest/double-generation/canary | Gate failure | Repair generator, retain first failure, delete unsafe package | Verification + Privacy | Missing target, hidden first failure, dynamic timestamp | Evidence can share implementation defect |
| T18-40 | Cleanup leaves VM/DB/object/key/credential/route | Before/after inventory and cleanup receipt | Gate fails; isolate residue | Manifest-scoped cleanup or disposable-environment revert | Lab/SRE Operations | Kill during cleanup, version lock, pending key delete | Provider hold/retention may delay cleanup |

## 7.1 Incident rules

**Privacy/cross-realm exposure:** stop the narrowest safe read/export/connector paths; preserve privacy-safe first-failure evidence; inventory every store/recipient; strengthen suppression before broad cleanup; invoke accountable privacy/security/legal process; rerun adjacent gates before re-enable.

**Missing acknowledged data:** keep restored reads, receipt issuance and egress disabled; freeze/compare exact receipt sets; replay exact server custody then approved endpoint grace; if unrecoverable, record explicit hold/loss evidence and require human decision—never invent data or silently call it deleted.

**Partial external deletion:** maintain internal suppression, query/retry the same operation, escalate owner, preserve manifests, and use external-action/limitation status only under approved authority.

**Backup/tombstone failure:** stop expiry and restore readiness; preserve copies and keys; restore independent tombstone/receipt authority; run isolated restore; resume only after verified replacement recovery evidence.

The design does not claim protection from a malicious kernel/hypervisor, unlogged DBA, maliciously authorized policy authority, recipient who copies bytes, or forensic recovery outside the selected sanitization standard.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Evidence rules

Every experiment uses fictional realms, subjects, events, applications, exports, destinations, backups and credentials. It records source/release/schema/policy/adapter/fixture/oracle/canary/database/tool/environment digests; exact sanitized commands; initial/final tombstone/receipt/derived watermarks; operation history, failpoint, first failure and shrink chain; safe counts; resource distributions; all-sink canary/cardinality result; and cleanup receipt. Passing one exact version/profile proves only that profile. A rerun never overwrites the first failure. Cleanup failure is test failure.

## 8.2 Test matrix

| ID | Assertion and setup | Steps/instrumentation | Pass | Stop/fail | Evidence | Duration estimate | Cleanup |
|---|---|---|---|---|---|---|---|
| E18-00 | Exact allowlisted input/evidence root | Hash inputs and generate manifest twice | Seven exact files, deterministic | Missing/extra/changed input | `e18-00-inputs/` | minutes | Remove duplicate generation; retain approved hashes only. |
| E18-01 | Strict contracts remain closed/bounded | Valid/boundary/invalid JSON, allocation limits | Exact matrix, no remote fetch/coercion | Unknown/duplicate/unbounded accepted | `e18-01-contracts/` | minutes | Delete transient request bodies/traces and reset validator process. |
| E18-02 | Realm isolation across all lifecycle boundaries | Two realms reuse all local IDs/tokens | Zero cross-realm read/mutation/target | Any cross-realm effect | `e18-02-realm/` | <1 hour | Drop both fixture realms and purge cache/search/connector stubs. |
| E18-03 | Resolver is exact and no-guess | Collision/rename/stale/shared-ID fixtures; independent resolver | Exact manifest or ambiguity | False match/negative, mutable scope | `e18-03-resolver/` | hours | Delete restricted selector material and reset resolver fixture store. |
| E18-04 | Barrier transaction is atomic/idempotent | Failpoint before/after every statement/commit | Either no change or full case+tombstone+epoch+targets+audit | Any partial/duplicate authority | `e18-04-barrier/` | hours | Restore clean DB snapshot; keep only sanitized failure capsules. |
| E18-05 | Barrier hides before physical delete | Facts/cache/replica/search; workers paused | Deleted fictional subject absent everywhere, control subject exact | Any route visible or wrong subject hidden | `e18-05-visibility/` | hours | Delete fixture rows and purge/rebuild cache, replica and index. |
| E18-06 | Adapter retries create one effect | Kill after apply before local commit; lease expiry | Same command/target, verified once | False success or harmful duplicate | `e18-06-adapters/` | 1–2 days all classes | Release leases; delete stub objects/commands and restore adapter fixture. |
| E18-07 | Retention candidates respect purpose/age/hold/clock | Fictional partitions/times/holds under concurrent query | Exact candidates/deletes; held/invalid excluded | Early/cross-purpose/cross-realm delete | `e18-07-retention/` | hours/engine | Drop fixture partitions, reset clock and remove candidate manifests. |
| E18-08 | Aggregate contribution removed exactly | Known contributions and independent calculator | Exact recompute; read hidden until verified | Residue/unrelated change/unsupported anonymity claim | `e18-08-aggregates/` | hours | Delete contribution/aggregate fixtures and rebuilt derivatives. |
| E18-09 | Inbox/quarantine lifecycle cannot resurrect | Mixed-subject/corrupt batches, delete pre/post parse | Custody retained correctly; no rematerialization; bounded poison | Visible deleted payload or indefinite archive | `e18-09-inbox/` | hours | Delete raw blobs, quarantine rows and parser fixture stores. |
| E18-10 | Stale cache/replica/search is ineligible | Hold updates, promote old replica, attach old index | Guard denies until watermark/probe | Transient visibility/false eligibility | `e18-10-derived/` | hours | Drop stale replica/index/cache namespaces and recreate clean controls. |
| E18-11 | Legal-hold race is safe | Hold before/after barrier and pre/post delete | Valid race blocks destruction, suppression remains | Held data destroyed or hold grants read | `e18-11-holds/` | hours | Release fictional holds and delete held-data fixtures. |
| E18-12 | Connector status semantics are truthful | Hostile stubs for accepted/applied/not-found/retry/unsupported/conflict | Same idempotency and correct terminal classification | 2xx/404 false success or lost obligation | `e18-12-connectors/` | day | Delete stub destination objects/queues and revoke test credentials. |
| E18-13 | Export suppression/deletion and limitations | Versioned object/CDN/token cache, before/after retrieval | Immediate access denial; all controlled copies/keys removed | Object/link/version remains or recall falsely claimed | `e18-13-exports/` | hours | Revoke links; delete every object version, CDN entry and test key. |
| E18-14 | Backup expiry is chain/hold/copy/key aware | Full+incremental/log chains, holds, copies, versioning | Unsafe blocked; safe obsolete chain completely verified | Broken chain/only point/partial called success | `e18-14-expiry/` | day/tool/engine | Delete lab chains/copies/keys only after retained recovery point is reverified. |
| E18-15 | Tool verification is not restore proof | Corrupt piece/remove key/log; run verify and actual restore | Defect found; only app restore marks test-restored | Manifest check alone accepted | `e18-15-backup-restore/` | hours–day | Destroy restored environments and corrupted backup fixtures. |
| E18-16 | Tombstone ledger detects gap/fork/rollback | Independent copies and chain digests | Materialization/readiness blocked until exact recovery | Stale/forked/gapped accepted | `e18-16-tombstones/` | hours | Delete corrupt/forked ledger copies and reseed clean authority. |
| E18-17 | Old endpoint replay stays suppressed | Delete, retain exact batch, replay before/after restore | Stable custody/dedupe; zero visible/derived/integration effect | New ID/effect or changed receipt meaning | `e18-17-reingestion/` | hours | Clear replay copies, endpoint queues and suppression fixtures. |
| E18-18 | ACK reconciliation is exact | Old backup omits receipted batch; server/endpoint/none branches | All recovered exactly or readiness blocked | READY with missing/conflicting batch | `e18-18-ack/` | hours | Delete coverage/replay stores and reset endpoint/server stubs. |
| E18-19 | Restore isolation has zero early access/egress | Network deny, DB roles, BFF, schedulers, egress canary | Zero ordinary read/receipt/export/connector before ready | Any succeeds | `e18-19-isolation/` | hours | Destroy environment, routes, roles, schedulers and credentials. |
| E18-20 | Full G11 gate | Section 8.4 scenario and fault matrix | Exact primary expression passes | Any primary term nonzero | `e18-20-g11/` | 1–3 lab days/profile | Run manifest-scoped full cleanup and independently prove zero residue. |
| E18-21 | Engine lifecycle/resource comparison | Identical workload on candidates, lock/log/WAL/maintenance/replica metrics | No invariant failure; measured distributions | Wrong rows/outage/unbounded pressure | `e18-21-engine/` | days | Drop candidate DBs/backups/replicas and remove metric/test artifacts. |
| E18-22 | Observability/evidence contains no subject values | Exact canaries in all fields and crash paths | Zero escape and bounded series | One escape/scanner miss/dynamic label | `e18-22-observability/` | hours | Delete canary sinks/traces and reset telemetry backends. |
| E18-23 | Admin UI is accessible | Keyboard/screen reader/zoom/status-message flow | Critical states/actions operable and announced | Hidden state/focus loss/color-only/ambiguous action | `e18-23-accessibility/` | day + review | Remove test accounts/session artifacts and restore accessibility fixture. |
| E18-24 | Harness detects deliberate defects | Disable verifier/target/check/cleanup/canary | Every mutation blocks with minimal counterexample | Any mutant survives | `e18-24-harness/` | hours | Remove mutants and temporary harness outputs; retain first sanitized failures. |
| E18-25 | Operators execute incident runbooks safely | Blind T1 wrong-subject, missing-ACK, stale-restore, destination-down cases | Correct contain/recover/cleanup/re-enable without raw data | False completion/early ready/raw-data request | `e18-25-runbooks/` | half-day/scenario | Reset simulated incidents/cases and revoke exercise credentials. |
| E18-26 | Cleanup leaves no unauthorized residue | Kill cleanup; inventory VM/DB/object/key/route/credential/evidence | Zero residue except approved digests | Any residual resource | `e18-26-cleanup/` | hours | Retain only approved immutable digests after zero-residue inventory. |

## 8.3 Smallest falsifying prototypes

### P18-01 — barrier before delete

One realm, two fictional subjects, facts, aggregate, cache, lagged replica and search document. Pause physical workers, commit subject A barrier, then query every ordinary path, restart BFF/cache and promote stale replica. **Pass:** A absent everywhere, B exact, lifecycle status available without payload. **Fail:** one A result or B incorrectly hidden.

### P18-02 — no-guess resolver

Two realms and colliding names/external references plus one exact subject projection. Submit name, fragment, wrong realm, duplicate, stale and exact selector. **Pass:** only exact same-realm approved selector creates one manifest; all others reject/ambiguous with zero target. **Fail:** fuzzy/name match becomes authority.

### P18-03 — partial connector deletion

Three stubs: immediate applied, accepted forever and permanently unsupported; one retrieved export. Lose responses and retire connectors mid-case. **Pass:** internal suppression/deletion succeeds, commands retain identity, case remains waiting or explicitly limited, recipient copy not called deleted. **Fail:** HTTP success/retirement yields false complete.

### P18-04 — chain-aware backup expiry

One full plus incrementals/logs, two copies, one hold and per-backup wrapped keys. Propose deletion of parent, held item, only recovery point and safe obsolete chain; fault copy/key deletion. **Pass:** unsafe blocks; safe chain deletes/verifies every copy/key in order. **Fail:** retained recovery breaks or partial is called success.

### P18-05 — accidental reingestion

Ingest/receipt batch, delete its subject, preserve exact endpoint bytes/IDs, replay before/after physical delete and after old restore with response loss. **Pass:** stable receipt/dedupe and one suppression outcome, no visible/derived/integration effect. **Fail:** new event/business effect.

### P18-06 — old-backup readiness

Two fictional subjects, old backup, post-backup deletion and post-backup acknowledged batch. **Pass:** all pre-ready reads denied; after readiness deleted subject absent and all nondeleted acknowledged events present exactly once. **Fail:** early access, deleted visibility, missing or duplicate acknowledged effect.

## 8.4 G11 lifecycle drill and acceptance plan

### 8.4.1 Assertion and fictional scenario

Create realm A and negative-control realm B; subjects `S-KEEP`, `S-DELETE`, `S-OTHER-REALM`; stable batches `B-BASE`, `B-DELETE-SOURCE`, `B-AFTER-BACKUP`; facts, contributions/aggregates, cache, replica, search, staged export and two connector objects. Take `BK-OLD` after the first two batches are receipted/materialized but before deletion. Then delete `S-DELETE`, preserve the current tombstone outside `BK-OLD`, and receive/acknowledge `B-AFTER-BACKUP` for `S-KEEP`. Preserve endpoint replay copies and authoritative tombstone/ACK ledgers outside the old backup.

All values are wholly fictional and must not resemble real people, organizations, domains, addresses or credentials.

### 8.4.2 Ordered drill

1. Generate the T1 package twice and require byte-identical canonical inputs and independent truth ledger.
2. Start exact server/database/backup/derived versions in an isolated lab.
3. Ingest the two pre-backup batches and issue receipts only after the declared durable-custody transaction.
4. Materialize expected facts/derivatives and verify oracle.
5. Create `BK-OLD`, record chain/key/tombstone/ACK watermarks, and verify it.
6. Authorize and execute deletion of `S-DELETE`, including barrier, store targets, export and connector stubs; exercise one unavailable destination.
7. Verify `S-DELETE` invisible and required internal targets verified; retain tombstone/minimal audit outside the backup.
8. Ingest and receipt `B-AFTER-BACKUP` for `S-KEEP`.
9. Create a new restored environment with ordinary DB roles, BFF routes, receipt issuance, export and connector egress disabled.
10. Restore `BK-OLD` and only the chosen old log/PITR point, deliberately excluding the deletion and post-backup batch.
11. Attempt every read and egress path before reconciliation; all must fail or return only nonpayload readiness status.
12. Verify engine/schema/realm/backup integrity.
13. Replay tombstones from backup watermark + 1 through current, with no gap/fork.
14. Reconcile ACK coverage and replay `B-AFTER-BACKUP` from server custody. Run a separate endpoint-only replay branch and a no-copy failure branch.
15. Replay old `B-DELETE-SOURCE`; it must be receipted/deduped/suppressed without materialization.
16. Rebuild facts, aggregates, views, search, caches and replica eligibility under current tombstones.
17. Run negative probes for every `S-DELETE` key/object and positive exact probes for every nondeleted acknowledged `S-KEEP` event.
18. Prove realm B unchanged and zero cross-realm query/mutation.
19. Prove connector/export egress remained disabled.
20. Run canary/cardinality/evidence checks.
21. Ask deterministic readiness evaluator; it must refuse any missing/stale/failed/blocked check.
22. On success, commit `READY`; then separately enable ordinary reads.
23. Repeat post-ready probes.
24. Destroy restore environment and all test objects/keys/routes/credentials; independently inventory zero residue.

### 8.4.3 Pass expression

```text
G11_PASS =
  RESTORE_ENVIRONMENT_ISOLATED
  AND PRE_READY_SUCCESSFUL_ORDINARY_READ_COUNT = 0
  AND PRE_READY_RECEIPT_EXPORT_CONNECTOR_EGRESS_COUNT = 0
  AND TOMBSTONE_SEQUENCE_GAPS = 0
  AND TOMBSTONE_FORKS = 0
  AND RESTORED_TOMBSTONE_WATERMARK = AUTHORITATIVE_TOMBSTONE_WATERMARK
  AND ACKNOWLEDGED_BATCHES_MISSING_AFTER_RECONCILIATION = 0
  AND ACKNOWLEDGED_BATCH_DIGEST_CONFLICTS = 0
  AND DELETED_SUBJECT_VISIBLE_RESULTS = 0
  AND DELETED_SUBJECT_DERIVED_OBJECTS = 0
  AND NONDELETED_ACKNOWLEDGED_EVENT_MISSING = 0
  AND NONDELETED_ACKNOWLEDGED_EVENT_DUPLICATES = 0
  AND CROSS_REALM_EFFECTS = 0
  AND PRIVACY_CANARY_ESCAPES = 0
  AND CLEANUP_RESIDUE = 0
  AND REQUIRED_READINESS_CHECK_FAILURES = 0
```

No success percentage, average, manual assertion, or risk acceptance offsets a nonzero primary count.

### 8.4.4 Mandatory fault branches

Run: tombstone authority unavailable; sequence gap; same-sequence fork; server replay missing but endpoint available; both unavailable; endpoint replays deleted subject; stale search snapshot; stale replica promotion; cache survives restore; connector scheduler starts; BFF/read role enabled early; hold arrives after barrier; backup key missing; verification passes but app restore fails; readiness checker/canary scanner disabled; cleanup interrupted.

Each branch must produce the expected blocked/held/quarantined state and a minimal reproducible failure capsule.

### 8.4.5 Evidence package

```text
e18-20-g11/
  manifest.json
  inputs.sha256
  environment.json
  fixtures/ and oracle/
  backup-catalogue-before.json
  restore-run.ndjson
  tombstone-ledger-before-after.json
  acknowledged-coverage-before-after.json
  target-state-ledger.ndjson
  derived-watermarks.json
  pre-ready-access-results.json
  post-ready-probes.json
  connector-egress-results.json
  canary-cardinality.json
  failure-branches/
  readiness.json
  cleanup-receipt.json
```

**ESTIMATE.** After automation, one exact engine/tool profile with required fault branches may require one to three lab days. This is a scheduling hypothesis, not an RTO or SLO.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Zero-tolerance invariants

```text
FF18-01 cross_realm_lifecycle_effect_count == 0
FF18-02 privileged_transition_without_audit_count == 0
FF18-03 barrier_without_tombstone_or_epoch_count == 0
FF18-04 target_without_authoritative_case_count == 0
FF18-05 ordinary_visible_result_matching_active_tombstone_count == 0
FF18-06 complete_case_with_unverified_required_target_count == 0
FF18-07 complete_case_without_explicit_recipient_limitation_count == 0
FF18-08 tombstone_gap_fork_or_rollback_accepted_count == 0
FF18-09 reingested_deleted_event_business_effect_count == 0
FF18-10 acknowledged_batch_missing_at_ready_count == 0
FF18-11 acknowledged_digest_conflict_at_ready_count == 0
FF18-12 pre_ready_successful_ordinary_read_count == 0
FF18-13 pre_ready_receipt_export_connector_egress_count == 0
FF18-14 deleted_subject_visible_after_ready_count == 0
FF18-15 nondeleted_acknowledged_event_missing_or_duplicate_count == 0
FF18-16 retention_target_destroyed_while_held_count == 0
FF18-17 backup_chain_broken_by_expiry_count == 0
FF18-18 backup_accepted_without_actual_restore_under_policy_count == 0
FF18-19 forbidden_subject_value_in_logs_metrics_traces_evidence_count == 0
FF18-20 cleanup_residue_count == 0
```

Any nonzero value blocks the applicable release, realm, restore or tool profile.

## 9.2 Domain queries

```sql
-- A completed case has no required nonterminal target.
SELECT c.realm_id, c.case_id
FROM deletion_case c
JOIN deletion_target t
  ON t.realm_id = c.realm_id AND t.case_id = c.case_id
WHERE c.state IN ('COMPLETE','COMPLETE_WITH_LIMITATIONS')
  AND t.required_for_completion = TRUE
  AND t.state NOT IN ('VERIFIED','HELD','EXTERNAL_ACTION_REQUIRED')
GROUP BY c.realm_id, c.case_id;
-- zero rows

-- A barriered case has tombstone authority.
SELECT c.realm_id, c.case_id
FROM deletion_case c
LEFT JOIN suppression_tombstone s
  ON s.realm_id = c.realm_id AND s.case_id = c.case_id
WHERE c.state IN ('BARRIER_COMMITTED','EXECUTING','WAITING_EXTERNAL',
                  'PARTIAL_HELD','VERIFYING','COMPLETE',
                  'COMPLETE_WITH_LIMITATIONS','FAILED')
GROUP BY c.realm_id, c.case_id, c.bound_tombstone_sequence
HAVING COUNT(s.tombstone_id) = 0 OR c.bound_tombstone_sequence IS NULL;
-- zero rows

-- Visibility state matches its maximum tombstone sequence.
SELECT v.realm_id
FROM realm_visibility_state v
JOIN (SELECT realm_id, MAX(realm_sequence) AS max_seq
      FROM suppression_tombstone GROUP BY realm_id) s
  ON s.realm_id = v.realm_id
WHERE v.current_tombstone_sequence <> s.max_seq;
-- zero rows
```

Equivalent engine adapters are checked against an independent logical model.

## 9.3 Readiness implication

```text
restore.state == READY
IMPLIES
  authoritative_tombstone_watermark == restored_tombstone_watermark
  AND authoritative_ack_digest == restored_ack_digest
  AND all_required_checks == PASS
  AND deleted_subject_negative_probe_visible_count == 0
  AND acknowledged_positive_probe_set == exact_expected_set
  AND connector/export/receipt authority remained disabled before decision
  AND privacy_canary_escapes == 0
```

The read credential/routing state cannot be enabled unless a matching durable readiness row and audit event bind the same restored environment ID. A restore operator cannot supply a `READY` flag.

## 9.4 Store registry completeness

Every table, object prefix, search index/alias, cache namespace, export type, connector, backup repository, audit store and restored environment class has exactly one classification:

```text
REGISTERED_WITH_ADAPTER
REGISTERED_DERIVED_NO_INDEPENDENT_DELETE
REGISTERED_NONPERSONAL_WITH_EVIDENCE
REGISTERED_EXTERNAL_LIMITATION
PROHIBITED
```

`UNKNOWN` or `UNREGISTERED` blocks production lifecycle completion. CI compares migrations and infrastructure manifests with the registry and must fail a deliberate added-table/bucket/index/connector mutation.

## 9.5 Policy monotonicity and data quality

For tenant policy `T` and product ceiling `C`:

```text
EffectiveRetention(T,C) <= C.maximum
EffectiveFields(T,C) subset_of C.fields
EffectiveStores(T,C) subset_of C.stores
EffectiveDestinations(T,C) subset_of C.destinations
TenantCannotDisable(ProductHardDenyOrDeleteRequirement)
```

Every visible fact has realm, stable event identity, provenance, purpose/data-product class, age field and subject-projection status or explicit non-subject classification. Every aggregate has contribution lineage or separately approved nonpersonal/anonymity evidence. Every egress object has a manifest before egress. Every recovery point has chain/copy/key/watermark metadata and actual restore evidence.

## 9.6 Measured operations criteria

Exact budgets remain human decisions. The harness records distributions for barrier latency; physical-delete throughput; DB locks/log/WAL/vacuum/ghost backlog/replica lag/query latency; tombstone size and lookup cost; restore phase durations; acknowledged replay source/age; connector pending age; backup expiry/inventory/key delays; metric cardinality; and blind-operator success. A budget breach pauses/throttles work; it never weakens primary invariants or shortens tombstone horizon silently.

## 9.7 Architecture mutations CI must reject

- repository/controller reads personal facts without visibility guard;
- direct delete/truncate/object-delete outside typed adapters;
- arbitrary SQL/script/path/URL/destination/object key;
- lifecycle key, cache or index alias without realm binding;
- new target/store class without restore/evidence/compatibility support;
- worker or API directly marks case/readiness complete;
- selector/event/export/object/free-form exception in general logs/metrics;
- store/connector/backup source without lifecycle classification;
- tombstone expiry from time alone;
- backup expiry without chain/hold/replacement/restore proof.

---

# 10. Human decisions and owner questions

Research cannot make these decisions. The conservative temporary state is T1-only, disabled, retain-and-suppress, or fail closed.

| ID | Human decision | Options and consequences | Conservative temporary default | Accountable role/function | Blocked work |
|---|---|---|---|---|---|
| HD18-01 | Purpose and lawful basis per data product | Approve narrow purpose, split purposes, or reject. Mixed/broad purpose increases fields, access and retention conflict. | T1 only | Data Controller/Product Governance with Legal/Privacy | Live data and production policy |
| HD18-02 | Prohibited uses and interpretation | Define enforceable prohibitions or stop use; undefined use raises misuse risk. | No productivity score or sole forensic proof | Product/Privacy/Workforce Governance | Portal, access, production |
| HD18-03 | Subject identity level | Person/account relation/device/installation/no person linkage. More precision raises privacy and verification obligations. | Exact fictional subject projection only | Data Controller + IAM/Data Governance | Resolver and rights intake |
| HD18-04 | Rights adjudication and exceptions | Approve/refuse/restrict/partially hold/request more proof. | No production request handled by engineering inference | Legal/Privacy Rights Operations | Subject deletion authorization |
| HD18-05 | Retention per purpose/field/store | Fixed, criteria-based, event-triggered review, or no collection. | No production automatic sweep | Records + Data Controller/Product Owner | Policy activation, partitioning, sizing |
| HD18-06 | Retention age basis and clock failure | Source-observed, received, materialized, case/export/backup-created; define missing/invalid time. | Unknown time never deletes | Records + Data Owner + SRE/Security | Evaluator |
| HD18-07 | Legal-hold grounds/scope/review/release | Subject/event/date/product/backup scope; review and release authority. | Destruction blocked where hold state unknown | Legal + Records | Hold module, backup expiry, completion |
| HD18-08 | Audit and restricted case retention | Minimal audit shell; selector/attachment period; appeal/claim/hold handling. | Minimal T1 audit and fixture cleanup | Security Audit + Legal/Privacy/Records | Audit/case production schema |
| HD18-09 | Tombstone retention/expiry | Tie to oldest backup, endpoint grace, connector retry, snapshot and dispute paths; indefinite is costly/personal. | Do not expire production tombstones | Data Reliability + Records + Privacy | Capacity and restore |
| HD18-10 | Receipt failure domain and RPO | Independent server replay, endpoint supplement, or explicit approved loss semantics. | No production endpoint cleanup; no READY with missing batch | Product/Risk + Ingestion/Data Reliability + SRE | Cleanup, backup, restore |
| HD18-11 | RTO and recovery topology | Full restore/rebuild, warm/hot standby, multi-region. Shorter RTO increases cost/complexity. | No production RTO claim | Product/Risk + SRE | Capacity and DR architecture |
| HD18-12 | Backup cadence, copies, immutability and retention | Full/diff/log or base/WAL; regions/offline/object lock; test cadence. | T1 short chain, no production expiry | SRE/Data Reliability + Security/Records | Backup tooling and G11 production claim |
| HD18-13 | Backup/export encryption, recovery and crypto erase | Per-backup/object keys, provider/customer keys, escrow/recovery window; erasure vs recoverability trade-off. | Lab keys only; no crypto-erasure claim | Cryptographic Authority + Security + SRE + Records | Key lifecycle |
| HD18-14 | Production database engine | PostgreSQL, SQL Server, or defer based on identical evidence, skills, licensing, support and migration. | PostgreSQL reference prototype only | Architecture + Data Platform + Ops + Procurement | Physical design and deployment |
| HD18-15 | Export purpose and recipient class | Controlled service/processor/joint controller/human download/uncontrolled; notification/attestation and expiry. | Exports disabled except T1 | Product/Data Owner + Privacy/Legal + Security | Export service |
| HD18-16 | Integration owner obligations | Require delete API/receipt, contractual/manual, reject destination, or accept explicit limitation. | No unregistered integration; `NONE` blocks egress | Integration Owner + Privacy/Legal + Data Owner | Production connectors |
| HD18-17 | Completion with unsupported recipient copies | Keep case open, close with approved limitation, or refuse integration. | Never claim technical deletion | Data Controller/Rights Ops + Legal | Case UI/reporting |
| HD18-18 | Access roles and separation of duties | Requester, resolver, authorizer, hold, destructive worker, readiness approver, auditor, break-glass. | T1 local roles only | IAM + Security Governance | Control API/operations |
| HD18-19 | Rights/SLO/deletion timing objectives | Legal response, internal stages, connector escalation, backup overwrite horizon. | No timing promise beyond zero-tolerance visibility invariant | Legal/Privacy + Product/SRE/Support | Alerting/staffing/capacity |
| HD18-20 | Cost/resource budgets | Tombstones, lineage, inbox, backups, search rebuild, restore lab, staffing. | Measurement only | Product/Finance + SRE/Architecture | Capacity/procurement |
| HD18-21 | Logs/diagnostics/support retention/access | Closed catalogue duration, incident exceptions, evidence access. | T1 value-free signals and cleanup | Observability + Privacy/Records/Support | Production support |
| HD18-22 | Physical sanitization standard | Provider delete, versions, key erase, media clear/purge/destroy and certificate evidence. | Do not equate SQL delete with sanitization | Security + Infrastructure/Cloud + Records | Decommission/final erase claims |
| HD18-23 | Aggregate anonymity/small-cohort rule | Delete/recompute all influence or approve specific anonymous outputs under attack model. | Treat influenced aggregate as deletion target | Data Controller + Privacy + Data Science | Analytics lifecycle |
| HD18-24 | Owners, support and incident command | Assign lifecycle, resolver, DB, backup, connector, privacy, audit, restore and on-call roles. | Disabled if blocking owner absent | Engineering/Operations Leadership | G11/pilot/production |
| HD18-25 | Pilot/production risk | Approve exact scope, engine, policy, backups, destinations, limitations and residual risk, or reject. | Disposable T1 lab only | Designated Production/Risk Authority | Pilot/production |

Owner questions include: exact purpose/field separation; definition of subject; authoritative identity sources and requester proof; erasure/restriction/refusal/hold grounds; late/offline-event age basis; maximum tombstone horizon; receipt failure domain and replay source; behavior when all acknowledged copies are gone; complete backup/version/key inventory; approved backup mutation model; connector capabilities and evidence; downloaded-export limitations; aggregate lineage/anonymity basis; RPO/RTO/rights objectives; kill/re-enable authorities; sanitized restore-drill operators; and decommission sanitization evidence.

---

# 11. CLI experiments and exact evidence

Proposed repository-facing shape:

```text
dotnet run --project src/tools/Uam.LifecycleCli -- <command> [strict options]
```

All commands require a controlled evidence root, T1 fixture root, fictional environment ID, pinned config and JSON output. They refuse non-T1 fixtures, unknown schema, evidence paths outside the lab root, dirty source unless explicitly recorded, or unredacted connection strings.

## 11.1 Commands

```bash
# Deterministic fixture and oracle
dotnet run --project src/tools/Uam.LifecycleCli -- fixture create \
  --scenario g11-minimal --seed fictional-seed-018 \
  --fixed-clock 2026-08-01T10:00:00Z \
  --output artifacts/t1/g11-minimal \
  --evidence-root evidence/x18-01 --json

# Schema/domain verification
dotnet run --project src/tools/Uam.LifecycleCli -- database initialize \
  --engine-profile <fictional-engine-profile> --schema lifecycle-v1 \
  --fixture-root artifacts/t1/g11-minimal \
  --evidence-root evidence/x18-02 --json

dotnet run --project src/tools/Uam.LifecycleCli -- database verify-domain \
  --expected-schema-digest <sha256> --evidence-root evidence/x18-02 --json

# Exact subject resolution
dotnet run --project src/tools/Uam.LifecycleCli -- subject resolve \
  --realm-alias fictional-realm-a \
  --selector-type SUBJECT_PROJECTION_ID \
  --selector-value fictional-subject-delete \
  --resolver-profile fictional-resolver-v1 \
  --evidence-root evidence/x18-03 --json

# Barrier and failpoint campaign
dotnet run --project src/tools/Uam.LifecycleCli -- deletion authorize \
  --request artifacts/t1/g11-minimal/requests/delete-subject.json \
  --evidence-root evidence/x18-04 --json
dotnet run --project src/tools/Uam.LifecycleCli -- deletion commit-barrier \
  --case-id <fictional-case-id> \
  --fault-schedule artifacts/t1/g11-minimal/faults/barrier-all-boundaries.json \
  --evidence-root evidence/x18-04 --json

# Visibility probe before physical delete
dotnet run --project src/tools/Uam.LifecycleCli -- visibility probe \
  --case-id <fictional-case-id> \
  --routes BFF,REPORTING,CACHE,REPLICA,SEARCH,EXPORT \
  --expect-subject-absent fictional-subject-delete \
  --expect-subject-present fictional-subject-keep \
  --evidence-root evidence/x18-05 --json

# Adapter execution and independent verification
dotnet run --project src/tools/Uam.LifecycleCli -- deletion run-workers \
  --case-id <fictional-case-id> --worker-profile all-t1-adapters \
  --fault-schedule artifacts/t1/g11-minimal/faults/ambiguous-outcomes.json \
  --evidence-root evidence/x18-06 --json
dotnet run --project src/tools/Uam.LifecycleCli -- deletion verify \
  --case-id <fictional-case-id> \
  --oracle artifacts/t1/g11-minimal/truth/deletion.json \
  --evidence-root evidence/x18-06 --json

# Connector hostile stubs and export lifecycle
dotnet run --project src/tools/Uam.LifecycleCli -- connector-stub serve \
  --scenario accepted-then-applied,permanent-unsupported,conflicting-404 \
  --fixture-root artifacts/t1/g11-minimal \
  --evidence-root evidence/x18-07-stub
dotnet run --project src/tools/Uam.LifecycleCli -- deletion run-connectors \
  --case-id <fictional-case-id> --evidence-root evidence/x18-07 --json

# Backup chain, actual restore and expiry faults
dotnet run --project src/tools/Uam.LifecycleCli -- backup create-fixture-chain \
  --engine-profile <fictional-engine-profile> --chain-profile base-plus-log \
  --fixture-root artifacts/t1/g11-minimal \
  --evidence-root evidence/x18-08 --json
dotnet run --project src/tools/Uam.LifecycleCli -- backup verify \
  --backup-id <fictional-old-backup-id> \
  --include-tool-verification --include-actual-restore \
  --evidence-root evidence/x18-08 --json
dotnet run --project src/tools/Uam.LifecycleCli -- backup expire \
  --policy artifacts/t1/g11-minimal/policies/backup-expiry.json \
  --candidate-chain <fictional-chain-id> --dry-run \
  --evidence-root evidence/x18-09 --json

# Complete G11 drill
dotnet run --project src/tools/Uam.LifecycleCli -- restore drill \
  --plan artifacts/t1/g11-minimal/plans/g11.json \
  --backup-id <fictional-old-backup-id> \
  --authoritative-tombstones artifacts/t1/g11-minimal/authority/tombstones.json \
  --authoritative-ack-coverage artifacts/t1/g11-minimal/authority/ack-coverage.json \
  --fault-matrix artifacts/t1/g11-minimal/faults/g11-mandatory.json \
  --evidence-root evidence/x18-10 --json

# Deterministic gate aggregation
dotnet run --project src/tools/Uam.LifecycleCli -- gate evaluate \
  --gate G11 --evidence-index evidence/g11-index.json \
  --schema contracts/gates/g11.schema.json \
  --output evidence/g11-gate.json --json
```

The aggregator accepts no caller-supplied pass value and always emits `productionApproved:false`. It validates required experiments, exact digests, first failures, owners, ADRs, evidence freshness, canaries and cleanup.

## 11.2 Engine comparison

```bash
dotnet run --project src/tools/Uam.LifecycleCli -- benchmark lifecycle \
  --engine-profile postgresql-18-candidate \
  --workload artifacts/t1/g11-minimal/workloads/lifecycle.json \
  --evidence-root evidence/engine-postgresql --json

dotnet run --project src/tools/Uam.LifecycleCli -- benchmark lifecycle \
  --engine-profile sqlserver-2025-candidate \
  --workload artifacts/t1/g11-minimal/workloads/lifecycle.json \
  --evidence-root evidence/engine-sqlserver --json
```

Evidence includes exact build/edition/licence assumption, configuration, environment class, DDL/index/plans, backup tool/profile, lock/log/WAL/maintenance/replica measurements, restore evidence, operator steps and cleanup. Synthetic throughput alone cannot select the engine.

## 11.3 Prohibited evidence

No real identity/activity; internal URL/domain/address/host/user/port/connection/object key; credential/token/private key/certificate private material; raw SQL parameters; unrestricted DB/network/memory dump; raw connector response; SSH configuration; or confidential catalogue/reference data may enter the shareable package.

---

# 12. ADR proposals

| ADR | Decision | Status | Key alternatives | Owner / review trigger |
|---|---|---|---|---|
| ADR-18-001 | Realm-scoped relational lifecycle controller and leased typed adapters | Accept architecture; gate open | Broker/workflow, synchronous API | Lifecycle Architecture; revisit on measured capacity/isolation failure |
| ADR-18-002 | Tombstone + visibility epoch before physical delete | Accept | Soft-delete only, physical first | Data Platform/Security; new reader or bypass evidence |
| ADR-18-003 | Independently protected monotonic realm tombstone ledger | Accept logical model; CLI open | Backup mutation, Kafka topic | Data Reliability; scale/integrity/broker change |
| ADR-18-004 | Exact typed subject resolution and immutable manifest | Accept | Name/fuzzy/activity inference | Data Governance/IAM; identity model change |
| ADR-18-005 | Purpose/field/store retention revisions; sweeps create cases | Accept model; policy open | DB TTL/hard-coded jobs | Records/Privacy; new purpose/store/law |
| ADR-18-006 | Minimal audit shell + separately retained restricted case material | Accept | Delete all audit, retain all payload | Audit/Records; rights/audit decision or incident |
| ADR-18-007 | Hold blocks destruction, not suppression; release re-evaluates current policy | Accept technical behavior | Hold grants visibility/auto-expires | Legal/Records; hold platform or authority change |
| ADR-18-008 | Chain-aware backup expiry and restore-time re-deletion; no backup editing by default | Accept | Edit backups, expiry without replay | SRE/Data Reliability; proved selective-delete tool |
| ADR-18-009 | Restore readiness requires tombstones, ACK coverage, derivatives, probes and zero early access | Accept; G11 open | Engine recovery/manual checklist only | SRE/Data Reliability; topology/RPO change |
| ADR-18-010 | Independent acknowledged-batch coverage ledger | Accept logical model; ingestion dependency | Endpoint replay only, ordinary backup only | Ingestion Reliability; receipt failure-domain change |
| ADR-18-011 | Replayed deleted events preserve custody but produce one suppression effect | Accept | Reject receipt or rematerialize/delete | Ingestion/Lifecycle; event/receipt contract change |
| ADR-18-012 | Connector/export registry, stable deletion command and explicit limitations | Accept | Unregistered/manual, 2xx means done | Integration/Privacy; new destination/capability |
| ADR-18-013 | No default per-subject crypto erase; use isolated backup/export/case keys | Accept | Per-subject DB keys | Crypto/Security; proved key-isolated model |
| ADR-18-014 | Derived stores expose current input/tombstone/visibility watermarks | Accept | Eventual rebuild without guard | Data/Search/Cache; new technology/store |
| ADR-18-015 | Completion distinguishes verified, held, external, limited and failed | Accept | Binary done/not-done | Product Governance; rights/recipient policy change |
| ADR-18-016 | Store registry is a release gate | Accept | Best-effort documentation | Architecture/Data Governance; schema/infra change |
| ADR-18-017 | No broker/workflow engine initially | Accept baseline | Kafka/workflow SaaS | Architecture/SRE; measured trigger exceeded |
| ADR-18-018 | G11 is technical gate and always `productionApproved=false` | Accept | Paper/backup-only review | Verification/Architecture Forum; gate schema change |

---

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Work | Dependency | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record exact input/result evidence manifest | none | hashes/classification | Missing/extra/changed input |
| 2 | Create ADR and human-decision records | 1 | ADRs/owner templates | Code implies unapproved policy/legal/RPO choice |
| 3 | Build lifecycle store registry and architecture guards | Batch 01 contracts/repo | schema/infra scanners, mutations | Unregistered store survives |
| 4 | Define strict contracts/logical schema/error catalogue | 2–3 | schemas/vectors/DDL | Payload realm, arbitrary SQL/path/destination, unknown field |
| 5 | Build independent T1 fixture/oracle/canaries/evidence formats | G0 + 4 | deterministic package | Nondeterminism/real value/shared oracle logic/canary miss |
| 6 | Build pure case/target/hold/retention/backup/restore models | 4–5 | property/model histories and shrinker | Mandatory mutation survives |
| 7 | Implement DB-neutral domain verifier and first schema adapter | 4–6 | migrations/constraints/checker | Cross-realm/mutable revision/partial audit/tombstone |
| 8 | Implement exact fictional subject resolver | 4–7 | immutable manifest/ambiguity tests | Name/fuzzy/implicit identity authority |
| 9 | Implement authoritative barrier transaction | 6–8 | case+tombstone+epoch+targets+audit | Any partial/duplicate result |
| 10 | Implement visibility guard and query architecture tests | 3–9 | guarded BFF/repositories | Any bypass visibility |
| 11 | Implement cache/replica/view watermarks | 9–10 | eligibility protocol | Stale reader eligible |
| 12 | Implement inbox/quarantine/fact/subject adapters | 7–11 | typed adapters/verifiers | Wrong realm/arbitrary command/false verify/raw leak |
| 13 | Implement aggregate contribution/recompute adapter | 5,7–12 | exact recompute | Residual contribution/unsupported anonymity |
| 14 | Implement search stub/adapter if selected | 9–13 | filter/delete/rebuild/watermark | Stale search visibility |
| 15 | Implement export manifests/suppression/object-key deletion | 4–14 | T1 export lifecycle | Access after barrier/false recall |
| 16 | Implement connector registry and hostile stubs | 4–15 | capabilities/commands/receipts | Universal 2xx/404, lost obligation |
| 17 | Implement retention dry-run/candidate evaluator | human values remain T1 | fictional rules/clock/hold guards | Direct delete/permissive unknown time/tenant broadening |
| 18 | Implement technical hold registry/races | 6–9,12–17 | activation/release/pre-delete checks | Held target destroyed or hold grants read |
| 19 | Implement minimal audit and restricted case separation | 4–18 | transactional audit/access/purge | Privileged mutation without audit/raw selector retained |
| 20 | Implement independent tombstone protection/integrity | 6–19 | gap/fork/rollback recovery | Stale/forked authority accepted |
| 21 | Implement acknowledged coverage and replay stubs | Batch 03 receipts + 5–20 | stable server/endpoint branches | HTTP success=receipt, new replay identity, missing ignored |
| 22 | Implement backup catalogue and first tool adapter | 7,20–21 | chain/copy/key/watermark manifests | Date-only expiry or verify-only proof |
| 23 | Implement chain-aware expiry | 22 | dry run/executor/faults | Parent/held/only point/partial success |
| 24 | Implement restore isolation/readiness state | 9–23 | denied network/read/egress | Any early access/send |
| 25 | Implement restore tombstone replay/re-deletion | 20,24 | sequence replay/probes | Gap/fork/visible deleted subject |
| 26 | Implement ACK reconciliation/replay | 21,24–25 | exact sets/conflict hold | READY with missing/conflict |
| 27 | Implement derived rebuild/read eligibility | 11–16,24–26 | exact watermarks | Stale derivative accepted |
| 28 | Implement deterministic readiness/gate aggregator | 5–27 | `readiness.json`, `g11-gate.json` | Caller pass/missing check/nondeterminism |
| 29 | Implement privacy-safe observability/evidence/accessibility/support | 4–28 | closed catalogue/canaries/UI | Raw/dynamic field or inaccessible critical flow |
| 30 | Run E18-00–19 on exact T1 profile | 1–29 | pre-G11 index | First invariant failure stops |
| 31 | Run E18-20 G11 and mandatory faults | 30 | G11 evidence package | Any primary term fails |
| 32 | Run identical PG/SQL Server benchmark if both remain | 31 | engine/ops/licensing/restore evidence | No prose-only engine choice |
| 33 | Run incident/key/backup/destination/operator exercises | 29–32 | runbook evidence | Raw-data request/false complete/unsafe re-enable |
| 34 | Architecture forum reviews ADRs/G11/residual risk | 31–33 | accepted/rejected baseline patch | Missing owner/evidence/expired exception |
| 35 | Human authorities decide policy/RPO/backup/recipient/access/owners/budget | section 10 | signed decision records | No production policy/data |
| 36 | Bind earlier ingestion/capacity/outage gates and exact versions | global sequence | aggregate server gate | G11 cannot substitute |
| 37 | Production-shaped T1 nonproduction topology gate | 34–36 | end-to-end evidence | Any invariant/canary/cleanup failure |
| 38 | Designated authority decides pilot/production | all | explicit scoped approval | No implicit production permission |

Parallel work after contracts/oracle: resolver model, lifecycle state/schema, read guard, connector/export stubs, tombstone integrity, backup/restore scripts, observability/accessibility. Destructive workers cannot precede barrier/read guard; retention cannot precede approved policy; expiry cannot precede chain/hold/restore proof; real connector deletion cannot precede contract/owner review; reads cannot precede G11 readiness; production cannot precede all predecessor gates and human decisions.

---

# 14. Open-source repository assessment

## 14.1 Method

The review searched official project repositories, release pages and documentation for deletion/tombstone controllers, replay behavior, backup/restore validation, expiry, and deletion propagation. Exact tags/releases below are point-in-time evidence as of 1 August 2026, not timeless dependency recommendations. Popularity was not used as proof. No repository architecture is copied wholesale.

## 14.2 Repository review table

| Repository and exact review point | Relevant files/directories | License / compatibility | Maintenance, tests and security posture | Similarity and threat-model difference | Reusable ideas / ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| [Kubernetes](https://github.com/kubernetes/kubernetes), release [`v1.36.3`](https://github.com/kubernetes/kubernetes/releases/tag/v1.36.3), 23 Jul 2026, tag commit shown as `0f29094` [W16] | [`staging/src/k8s.io/apimachinery/pkg/apis/meta/v1/types.go`](https://github.com/kubernetes/kubernetes/blob/v1.36.3/staging/src/k8s.io/apimachinery/pkg/apis/meta/v1/types.go); [`pkg/controller/garbagecollector/`](https://github.com/kubernetes/kubernetes/tree/v1.36.3/pkg/controller/garbagecollector); controller tests | Apache-2.0; generally compatible, but a dependency would add a massive platform surface | Very active, extensive unit/integration/e2e/conformance infrastructure and formal security response. This review did not execute the suite or establish a UAM-specific audit. | `deletionTimestamp` plus finalizers/garbage collection resembles “mark, reconcile dependencies, then finish.” Kubernetes objects are cluster resources, not personal-data cases; finalizers can hang and do not address rights, backups, recipients or realm read barriers. | Reuse explicit pending dependencies, finalizer visibility, stuck-work escalation and idempotent reconcile. Do not make UAM deletion a Kubernetes custom resource or depend on cluster control plane for data authority. | **Reference only.** |
| [Apache Kafka](https://github.com/apache/kafka), source release/tag [`4.3.1`](https://github.com/apache/kafka/tree/4.3.1), official release notes 25 Jun 2026 [W18] | [`storage/.../log/LogCleaner.java`](https://github.com/apache/kafka/blob/4.3.1/storage/src/main/java/org/apache/kafka/storage/internals/log/LogCleaner.java); `LogCleanerManager`; log-cleaner tests | Apache-2.0; compatible, but broker admission and operations are major commitments | Active ASF release, broad unit/integration/system tests and ASF security/release-signature process. No UAM-specific availability or deletion proof. | Compacted-topic tombstones model deletion propagation and show that tombstones must remain long enough for lagging consumers. Compaction is not immediate physical erase and delete-retention settings can remove markers. | Reuse the horizon lesson and stable-key tombstone semantics. Do not equate compaction with erasure or add Kafka without measured broker trigger. | **Reference only; no default dependency.** |
| [Apache Cassandra](https://github.com/apache/cassandra), tag [`cassandra-5.0.8`](https://github.com/apache/cassandra/tree/cassandra-5.0.8), 16 Apr 2026 [W20] | [`src/java/org/apache/cassandra/db/DeletionTime.java`](https://github.com/apache/cassandra/blob/cassandra-5.0.8/src/java/org/apache/cassandra/db/DeletionTime.java); [`tombstones.adoc`](https://github.com/apache/cassandra/blob/cassandra-5.0.8/doc/modules/cassandra/pages/managing/operating/compaction/tombstones.adoc); [`src/java/org/apache/cassandra/db/compaction/`](https://github.com/apache/cassandra/tree/cassandra-5.0.8/src/java/org/apache/cassandra/db/compaction); compaction tests | Apache-2.0 | Active ASF maintenance, substantial tests and ASF security process; no reproduced suite here | Cassandra tombstones and `gc_grace`/repair demonstrate zombie resurrection when delete markers disappear before replicas reconcile. UAM is relational/modular-monolith and does not need Cassandra's distributed storage model. | Reuse the “marker horizon must dominate lag/repair/restore” warning. Do not copy `gc_grace` as a UAM retention rule or adopt Cassandra for this problem. | **Negative/reference-only evidence.** |
| [Debezium](https://github.com/debezium/debezium), release [`v3.6.0.Final`](https://github.com/debezium/debezium/releases/tag/v3.6.0.Final), 1 Jul 2026, tag commit shown as `800ae11` [W22] | [`RelationalChangeRecordEmitter.java`](https://github.com/debezium/debezium/blob/v3.6.0.Final/debezium-connector-common/src/main/java/io/debezium/relational/RelationalChangeRecordEmitter.java); [`debezium-connect-plugins/.../transforms/outbox/`](https://github.com/debezium/debezium/tree/v3.6.0.Final/debezium-connect-plugins/src/main/java/io/debezium/transforms/outbox); [outbox tests](https://github.com/debezium/debezium/tree/v3.6.0.Final/debezium-connect-plugins/src/test/java/io/debezium/transforms/outbox) | Apache-2.0 | Active releases and extensive connector/integration CI. Security posture is that of a CDC framework, not a rights/backup controller; this review did not execute its matrices. | Delete records followed by tombstones and outbox routing resemble integration propagation. Debezium reports source changes, usually through Kafka; it does not decide legal scope, backup re-deletion, read barriers or recipient completion. | Reuse stable key, explicit delete fact and idempotent consumer ideas. Do not use CDC as deletion authority or introduce Kafka solely for this feature. | **Reference only.** |
| [PostgreSQL source](https://github.com/postgres/postgres), tag [`REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4), release 14 May 2026 [W04, W24] | [`src/backend/access/heap/vacuumlazy.c`](https://github.com/postgres/postgres/blob/REL_18_4/src/backend/access/heap/vacuumlazy.c); [`src/backend/replication/logical/`](https://github.com/postgres/postgres/tree/REL_18_4/src/backend/replication/logical); [`src/bin/pg_verifybackup/`](https://github.com/postgres/postgres/tree/REL_18_4/src/bin/pg_verifybackup); regression/TAP tests | PostgreSQL License, permissive | Mature release/security process and extensive regression/TAP tests. Documentation/source prove primitives, not UAM fitness or organizational restore competence. | It is the target reference data/recovery substrate. Transactions, WAL/PITR, replica identity and backup verification are directly relevant, but do not provide cross-store lifecycle authority. | Reuse transactional barrier, recovery and verification primitives. Do not equate SQL `DELETE`, vacuum or `pg_verifybackup` with full UAM deletion/readiness. | **Runtime candidate; production selection remains benchmark/operations-gated.** |
| [pgBackRest](https://github.com/pgbackrest/pgbackrest), release [`2.59.0`](https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F2.59.0), 8 Jul 2026, tag commit shown as `f84c835` [W25] | [`src/command/backup/`](https://github.com/pgbackrest/pgbackrest/tree/release/2.59.0/src/command/backup); `restore/`, `expire/`, `check/`; [`test/src/module/command/`](https://github.com/pgbackrest/pgbackrest/tree/release/2.59.0/test/src/module/command) | MIT; compatible, subject to normal SBOM/notices/support admission | Recent release and substantial project test suite. This review found mature operational design but no independent UAM support commitment or reproduced destructive/restore campaign. | Backup/restore/expire/check and repository manifests align with PostgreSQL chain management. It does not know UAM tombstones, ACK coverage, rights or external copies. | Reuse chain-aware expiry, exact repository inventory and actual restore discipline. Do not accept tool `check` alone as app recovery proof. | **Conditional dependency candidate only if PostgreSQL is selected and bake-off passes.** |
| [restic](https://github.com/restic/restic), release [`v0.19.1`](https://github.com/restic/restic/releases/tag/v0.19.1), 5 Jul 2026, tag commit shown as `6aa3a51` [W26] | [`cmd/restic/cmd_forget.go`](https://github.com/restic/restic/blob/v0.19.1/cmd/restic/cmd_forget.go); `cmd_prune.go`; `cmd_check.go`; [`internal/repository/`](https://github.com/restic/restic/tree/v0.19.1/internal/repository); `internal/checker/` | BSD-2-Clause; compatible | Active release, broad tests and published security handling. Cryptography/repository correctness is security-sensitive; no UAM-specific audit or support commitment was established. | Encrypted content-addressed repositories and separate forget/prune/check stages resemble catalogue, logical expiry, physical reclamation and verification. It is not a transaction-consistent database backup controller. | Reuse stage separation, repository inventory and append-only/verification ideas. Do not use it as the primary database-consistent backup or claim `forget` is physical erasure. | **Reference; conditional utility for non-database artifacts only after admission.** |
| [OpenSearch Index Management](https://github.com/opensearch-project/index-management), release [`3.6.0.0`](https://github.com/opensearch-project/index-management/releases/tag/3.6.0.0), 7 Apr 2026 [W27] | [`src/main/kotlin/.../indexstatemanagement/action/`](https://github.com/opensearch-project/index-management/tree/3.6.0.0/src/main/kotlin/org/opensearch/indexmanagement/indexstatemanagement/action); job/transition runners; integration tests | Apache-2.0 | Actively aligned with OpenSearch releases, CI/integration tests and project security process. Version alignment and cluster operations are nontrivial. | Policy-driven index actions and state/history resemble derived-store lifecycle jobs. It is index-level and cannot decide subject-level cross-store erasure or backup readiness. | Reuse explicit action states, retries, history and failed-action visibility. Do not make index policy the lifecycle authority or select OpenSearch without a search need. | **Reference only; search technology unselected.** |
| [Mozilla Glean](https://github.com/mozilla/glean), release [`v69.0.0`](https://github.com/mozilla/glean/releases/tag/v69.0.0), 22 Jun 2026, tag commit shown as `566b08e` [W28] | [`glean-core/src/upload/`](https://github.com/mozilla/glean/tree/v69.0.0/glean-core/src/upload); [`glean-core/src/database/`](https://github.com/mozilla/glean/tree/v69.0.0/glean-core/src/database); deletion-request ping documentation [W29] | MPL-2.0; file-level copyleft requires review if code is modified/distributed; reference use has no dependency consequence | Active Mozilla release, broad cross-language tests and telemetry/data-review discipline. No UAM backend deletion/restore guarantee. | A separately prioritized deletion-request signal and local clearing are relevant. Glean's client telemetry/opt-out model does not cover central subject resolution, realms, backups, search, exports or recipient evidence. | Reuse explicit deletion signal priority and separation from ordinary telemetry. Do not assume signal delivery equals backend completion or embed the SDK for server lifecycle. | **Reference only.** |

## 14.3 Consolidated open-source conclusion

- **Potential dependency after selection/admission:** PostgreSQL itself as already accepted target reference; pgBackRest only if PostgreSQL wins and exact restore/expiry/security/operations tests pass.
- **Possible narrow utility:** restic for non-database T1 evidence or artifact repositories only after exact cryptographic/repository admission; not a database backup substitute.
- **Reference only:** Kubernetes, Kafka, Cassandra, Debezium, OpenSearch Index Management and Mozilla Glean.
- **Ideas deliberately rejected:** broker-as-default; finalizer/operator as UAM authority; compaction/TTL/`gc_grace` as erasure; CDC as rights completion; search policy as cross-store deletion; deletion signal as backend proof; backup-tool verification without actual restore.

Every admitted dependency needs exact source/tag/digest, licence/notices, SBOM, vulnerability/security policy, reproducible or otherwise evidenced build/provenance, N/N-1/rollback compatibility, operations/runbook, performance/resource data, and owner/support decision. Recent release activity is evidence of maintenance, not proof of UAM fitness.

---

# 15. Source register with dates, versions, limitations, and citation-quality notes

## 15.1 Project evidence

P01–P07 are the exact allowlisted files and hashes recorded in section 2. They are sanitized internal summaries or accepted predecessor reviews. Accepted reviews are stronger project context than the original baseline, but none is production evidence. The data summary contains no production values, rates, retention, RPO/RTO or engine benchmark. The research-rules file governs labels and authority; it is not evidence that a mechanism works.

## 15.2 Public primary sources

| Ref | Source, date/version reviewed | Use | Limitation / citation-quality note |
|---|---|---|---|
| W01 | [Regulation (EU) 2016/679 — GDPR](https://eur-lex.europa.eu/eli/reg/2016/679/oj), 27 Apr 2016 / OJ 4 May 2016 | Storage limitation, erasure, restriction, security and accountability context | Authoritative law text; this technical result does not make legal conclusions for UAM. |
| W02 | [EDPB 2025 Coordinated Enforcement Framework report on the right to erasure](https://www.edpb.europa.eu/system/files/2026-02/edpb_cef-report_2025_right-to-erasure_en.pdf), adopted 10 Feb 2026 | Current regulator evidence on structured erasure, retention consistency, backups and reapplying requests after restore | Primary regulator report, not binding case-specific legal advice; findings span participating authorities and organizations. PDF text and relevant pages were visually checked. |
| W03 | [NIST SP 800-88 Rev. 2 — Guidelines for Media Sanitization](https://doi.org/10.6028/NIST.SP.800-88r2), Sep 2025 | Current sanitization/cryptographic-erase terminology and key-copy/hierarchy limits | Authoritative US technical guidance; does not select UAM threat model, provider, media or legal standard. PDF relevant sections were visually checked. |
| W04 | [PostgreSQL 18.4 release announcement](https://www.postgresql.org/about/news/postgresql-184-1710-1614-1518-and-1423-released-3297/), 14 May 2026 | Confirms current stable maintenance release line at research date | Version fact only; does not prove UAM fitness. PostgreSQL 19 beta is not used as production reference. |
| W05 | [PostgreSQL 18 — Routine Vacuuming](https://www.postgresql.org/docs/18/routine-vacuuming.html), version 18 docs | Deleted/obsolete row versions, vacuum and space-reuse behavior | Official capability semantics; real lock/space/latency effects require CLI measurement. |
| W06 | [PostgreSQL 18 — Continuous Archiving and PITR](https://www.postgresql.org/docs/18/continuous-archiving.html) | Base backup + WAL recovery and recovery-point semantics | Cluster/tool/environment operations remain unproved. |
| W07 | [PostgreSQL 18 — `pg_verifybackup`](https://www.postgresql.org/docs/18/app-pgverifybackup.html) | Backup-manifest verification and its limits | Verification is not an application-level restore test. |
| W08 | [PostgreSQL 18 — Logical replication publication](https://www.postgresql.org/docs/18/logical-replication-publication.html) | Delete/update publication and replica-identity considerations | Capability only; UAM does not choose logical replication here. |
| W09 | [Microsoft lifecycle — SQL Server 2025](https://learn.microsoft.com/en-us/lifecycle/products/sql-server-2025), reviewed 1 Aug 2026 | Current support lifecycle context for fallback candidate | Living vendor lifecycle page; edition/licensing/support decision remains human-owned. |
| W10 | [Microsoft Learn — Back up and restore SQL Server databases](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases), reviewed 1 Aug 2026 | Full/differential/log and restore concepts; need to test restore | Official capability docs, not UAM operational competence or performance evidence. |
| W11 | [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110), Jun 2022 | `202 Accepted`, request/response semantics | Protocol semantics only; UAM adds stricter custody/deletion states. |
| W12 | [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457), Jul 2023 | Standard safe HTTP error shape | Does not define UAM error taxonomy/privacy redaction. |
| W13 | [RFC 9562 — Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562), May 2024 | UUIDv7 canonical identifier profile | UUID time bits are not business time, ordering authority or evidence precision. |
| W14 | [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12), reviewed 1 Aug 2026 | Structural schema dialect | Tool compatibility and semantic/privacy rules still require executable vectors. |
| W15 | [W3C Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/), Recommendation 5 Oct 2023 | Accessible lifecycle/restore administration | Conformance requires testing; this report does not certify a UI. |
| W16 | [Kubernetes v1.36.3 release](https://github.com/kubernetes/kubernetes/releases/tag/v1.36.3), 23 Jul 2026 | Exact repository review point for finalizer/garbage-collection pattern | Reference pattern only; release popularity/quality does not justify dependency. |
| W17 | [Kubernetes — Finalizers](https://kubernetes.io/docs/concepts/overview/working-with-objects/finalizers/), reviewed 1 Aug 2026 | Documented mark-before-delete/finalizer semantics | Infrastructure object lifecycle differs materially from personal-data erasure. |
| W18 | [Apache Kafka 4.3.1 source/release notes](https://archive.apache.org/dist/kafka/4.3.1/RELEASE_NOTES.html) and [tag](https://github.com/apache/kafka/tree/4.3.1), 25 Jun 2026 | Exact review point for log cleaner/tombstones | Broker not selected; compaction is not erasure. |
| W19 | [Apache Kafka 4.3 design — log compaction](https://kafka.apache.org/43/design/design/#log_compaction_basics) | Tombstone and lagging-consumer horizon semantics | Official design, but UAM-specific horizon/operations require tests. |
| W20 | [Apache Cassandra `cassandra-5.0.8`](https://github.com/apache/cassandra/tree/cassandra-5.0.8), 16 Apr 2026 | Exact review point for deletion markers/compaction | Database architecture is not a UAM candidate here. |
| W21 | [Apache Cassandra — tombstones](https://cassandra.apache.org/doc/stable/cassandra/managing/operating/compaction/tombstones.html), reviewed 1 Aug 2026 | Primary warning about tombstone removal and zombie data/repair | Used as negative/reference evidence, not design selection. |
| W22 | [Debezium v3.6.0.Final](https://github.com/debezium/debezium/releases/tag/v3.6.0.Final), 1 Jul 2026 | Exact review point for delete/tombstone/outbox patterns | CDC framework does not provide rights/restore completion. |
| W23 | [Debezium 3.6 PostgreSQL connector documentation](https://debezium.io/documentation/reference/3.6/connectors/postgresql.html) | Delete-event/tombstone and connector behavior | Connector-specific; normally assumes Kafka ecosystem. |
| W24 | [PostgreSQL source tag `REL_18_4`](https://github.com/postgres/postgres/tree/REL_18_4) | Exact source review point for vacuum/logical/verify code | Source inspection was architectural, not a reproduced build/security audit. |
| W25 | [pgBackRest 2.59.0](https://github.com/pgbackrest/pgbackrest/releases/tag/release%2F2.59.0), 8 Jul 2026 | Exact backup/restore/expire/check reference | Conditional candidate only; exact environment and restore drill required. |
| W26 | [restic v0.19.1](https://github.com/restic/restic/releases/tag/v0.19.1), 5 Jul 2026 | Exact forget/prune/check/repository reference | Not a DB-consistent backup by itself; crypto/repository admission required. |
| W27 | [OpenSearch Index Management 3.6.0.0](https://github.com/opensearch-project/index-management/releases/tag/3.6.0.0), 7 Apr 2026 | Exact index lifecycle action reference | Search/index technology unselected and cannot be lifecycle authority. |
| W28 | [Mozilla Glean v69.0.0](https://github.com/mozilla/glean/releases/tag/v69.0.0), 22 Jun 2026 | Exact client deletion-request reference point | Client telemetry model does not prove backend deletion. |
| W29 | [Mozilla Glean deletion-request ping documentation](https://mozilla.github.io/glean/book/user/pings/deletion-request.html), reviewed 1 Aug 2026 | Documents the explicit, retried deletion-request signal and its deliberately narrow contents | Used only as a design reference; signal delivery is not backend deletion completion and this is not a UAM protocol dependency. |
| W30 | [pgBackRest User Guide](https://pgbackrest.org/user-guide.html), reviewed 1 Aug 2026 | Operational backup/restore/expire/check details | Living documentation; exact selected version/config must be pinned. |
| W31 | [restic documentation — removing backup snapshots](https://restic.readthedocs.io/en/stable/060_forget.html), reviewed 1 Aug 2026 | Forget/prune/check semantics | File repository semantics; not proof of provider/media erase. |

## 15.3 Source-quality corrections

- Regulator/statutory and standards sources support principles and documented requirements, not a case-specific legal conclusion.
- Database/vendor documentation proves documented capability, not UAM performance, durability, security or operations.
- Repository tag/release activity proves the reviewed code point and current maintenance signal, not architectural fitness, independent audit or support commitment.
- Search snippets, download counts, stars and vendor marketing were not used as proof.
- Every time-sensitive version in architecture is recorded as a reviewed point, not hardened into a timeless requirement.

---

# 16. Confidence by major conclusion and evidence that could change it

| Major conclusion | Confidence | Evidence basis | Evidence that changes it |
|---|---|---|---|
| Realm-scoped relational cases plus leased adapters are the simplest initial orchestration | **Medium-High** | Accepted modular monolith/no-broker baseline; explicit cross-store state model | Measured throughput/fan-out/isolation/cost failure with a safer admitted alternative |
| Barrier+tombstone must precede physical deletion | **High** | Direct accepted visibility/restore invariant and asynchronous store behavior | Equivalent simpler mechanism proving zero visibility through all faults |
| Tombstone authority must be independent of an old business backup | **High** | Restore-resurrection logic, EDPB backup guidance, Cassandra/Kafka reference warnings | Safe verified mutation/removal of every restorable copy and replay source |
| Restore readiness needs acknowledged-batch reconciliation | **High** | Receipt is durable custody; missing receipted data violates baseline | Receipt architecture proves immutable replay in the restored failure domain |
| Exact no-guess subject resolution is mandatory | **High** | Realm/privacy impact of false positive and accepted identity boundaries | A different resolver with equal exactness, auditability and lower privacy risk |
| Backup chain expiry plus restore-time re-deletion is preferred | **High** | Backup integrity/immutability and regulator guidance | Supported selective backup deletion with chain-safe test restore and lower risk |
| Minimal audit separated from restricted case material best reconciles erasure/accountability | **Medium-High** | Accepted durable-audit invariant and minimization | Human/legal/audit authority requires a different minimum field/retention model |
| Per-subject crypto erase is not the default | **High** | NIST key-copy conditions and shared UAM copies/derivatives | Complete per-subject object/key isolation and all-copy destruction evidence |
| Derived stores need explicit tombstone/input/read-eligibility watermarks | **High** | Stale cache/replica/search failure modes | A stronger atomic reader architecture with equal restore/replay proof |
| External deletion completion must expose limitations | **High** | Destination/recipient is outside UAM transaction/control | Binding destination contract and independently verified recipient deletion |
| PostgreSQL remains target reference and SQL Server serious candidate | **High as architecture context; Low for final selection** | Accepted baseline and current supported products | Identical benchmark, restore operations, skills, licence/cost and support decision |
| G11 drill is sufficient to close this topic's technical architecture gate | **Medium-High** | It directly falsifies the primary invariant and all identified lifecycle paths | Missing store/recipient/failure path, harness mutation survivor, or predecessor conflict |
| A G11 pass authorizes production | **High confidence that it does not** | Explicit evidence rules and unresolved human/predecessor gates | Only separate complete aggregate gate and designated production authority |

## 16.1 Exact baseline-update condition

This result may update the technical baseline only when all are true:

```text
LIFECYCLE_ARCHITECTURE_ADRS_ACCEPTED
AND REQUIRED_BATCH01_TO_BATCH03_EVIDENCE_CURRENT_AND_MATCHING
AND E18_00_THROUGH_E18_19_REQUIRED_PASS
AND G11_PRIMARY_EXPRESSION_PASS
AND G11_MANDATORY_FAULT_BRANCHES_PASS
AND ZERO_CROSS_REALM_EFFECTS
AND ZERO_PRE_READY_ORDINARY_READ_OR_EGRESS
AND ZERO_DELETED_SUBJECT_VISIBILITY
AND ZERO_MISSING_OR_DUPLICATE_NONDELETED_ACKNOWLEDGED_EFFECTS
AND ZERO_TOMBSTONE_GAPS_OR_FORKS
AND ZERO_FALSE_EXTERNAL_COMPLETIONS
AND ZERO_PRIVACY_CANARY_ESCAPES
AND ZERO_CLEANUP_RESIDUE
AND ALL_BLOCKING_TECHNICAL_OWNER_FUNCTIONS_ASSIGNED
AND EVIDENCE_MANIFEST_CURRENT_AND_CONTENT_ADDRESSED
AND productionApproved = false
```

A failure leaves the existing baseline unchanged and stops dependent work; it does not create a waiver or nearest-match fallback.

## 16.2 Conditions for later production enablement

In addition to the technical update above:

- the earlier durable-inbox/idempotency/poison, capacity, and long-outage/backpressure gates must pass in the exact production-shaped topology;
- purpose, lawful basis, prohibited uses, identity, fields, retention, legal holds, rights process, access, audit, RPO/RTO, backup, keys/sanitization, exports/recipients, integration obligations, owners, staffing, budget, support and production risk must be approved;
- the exact database, backup tool, storage provider, KMS, search/cache/replica topology, connector versions and release must be admitted and evidence-current;
- production policies remain disabled until those decisions are signed and executable compatibility/runbook evidence exists;
- endpoint acknowledged-payload cleanup remains disabled until the receipt failure domain, replay source, ACK grace, RPO and G11 restore evidence are mutually consistent.

---

# Final residual risk and next stop/go gate

The proposed architecture is coherent and decision-ready, but there is still no executed evidence that the composed UAM system can delete a subject across every internal and external copy, retain enough tombstone authority to prevent resurrection, and restore every acknowledged nondeleted event without exposing anything early. The most serious residual risks are wrong-subject resolution, hidden/manual copies, recipient retention, tombstone or receipt-authority rollback, privileged bypass, aggregate lineage gaps, backup/key inventory gaps, database maintenance pressure, and operator error during disaster recovery.

**Next GO:** create the ADRs/contracts/T1 fixture and implement the barrier, visibility guard, tombstone ledger, exact resolver, independent acknowledged-coverage model, backup catalogue and restore isolation. Run E18-00 through E18-19.

**Next STOP:** do not enable production retention, erasure, backup expiry, connector deletion, restored reads, or endpoint receipt-based cleanup.

**Next decisive gate:** run **E18-20 / G11** against an exact database and backup-tool profile. The gate passes only when an old restored environment has zero successful ordinary reads or egress before readiness, zero visible deleted fictional subjects, zero missing or duplicate nondeleted acknowledged events, zero tombstone gaps/forks, zero cross-realm effects, zero privacy-canary escapes, and zero cleanup residue. Even a pass sets `productionApproved=false`; the aggregate predecessor and human decision gates remain mandatory.
