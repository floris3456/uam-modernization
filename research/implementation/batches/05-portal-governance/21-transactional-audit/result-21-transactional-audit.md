# Prompt 21 — Transactional audit, tamper evidence, external verification, and audit access

**Result path:** `batches/05-portal-governance/21-transactional-audit/result-21-transactional-audit.md`  
**Research date:** 1 August 2026  
**Decision status:** **RECOMMENDATION — ACCEPT THE ENGINE-NEUTRAL ARCHITECTURE FOR T1 IMPLEMENTATION PROTOTYPES; KEEP THE AUDIT PROOF GATE OPEN; NO PRODUCTION PRIVILEGED SURFACE IS AUTHORIZED**  
**Authority boundary:** transactional audit, audit access, tamper evidence, independent verification, gap handling, and audit-aware restore for the UAM control plane; **not** legal purpose, regulatory or evidentiary sufficiency, production audit retention, production access, independent-verifier ownership, response authority, database selection, key-custody approval, budget, staffing, SLO/RPO/RTO, pilot, or production approval  
**Predecessors:** accepted Batch 01, Batch 02, Batch 03, and Batch 04 review results

This result uses the required evidence labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, restore, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed Prompt 21 implementation baseline. They do not turn a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION.** UAM should implement one **application-owned, typed audit ledger in the same relational database transaction as every privileged mutation**. The mutation and its successful audit record either commit together or both roll back. Audit is not a call to a logging library after the business change; it is part of the command's durable state transition.

The initial design is:

1. a strict, realm-aware audit taxonomy and schema owned by the UAM contract authority;
2. one append-only audit stream per realm plus a separate product-global stream;
3. one monotonic sequence and hash link per stream;
4. sealed segments with Merkle roots and signed checkpoint manifests;
5. an independently operated verifier that recomputes the chain and stores checkpoints outside the ordinary product/database administration boundary;
6. audit-before-disclose for sensitive reads and exports;
7. fail-closed privileged mutation when the transactional audit write cannot commit;
8. a verification hold, not silent repair, when a gap, fork, alteration, stale checkpoint, signature failure, or restore divergence is detected.

**INFERENCE.** This is the smallest architecture that preserves all accepted predecessor decisions. The accepted server is a modular monolith with a relational transaction boundary; the database engine is still unsettled; ordinary diagnostics are explicitly not durable audit; realm authority comes from authenticated context; and a privileged mutation cannot succeed without durable audit. Therefore the primary audit mechanism must be engine-neutral, transactional, typed, and inside the modular monolith. External storage or a transparency log can strengthen detection, but it cannot be the primary sink because a network call cannot atomically commit with the local business mutation across two independent systems.

## 1.2 What is accepted at architecture level

| Conclusion | Classification | Decision |
|---|---|---|
| Mutation and successful audit event share one database transaction | **RECOMMENDATION** | **Accept for implementation** |
| Typed UAM business events, not free-form database statement logs, are authoritative audit semantics | **RECOMMENDATION** | **Accept for implementation** |
| Realm-scoped and product-global streams are separate | **RECOMMENDATION** | **Accept for implementation** |
| Application hash chain plus sealed Merkle segment roots is the portable tamper-evidence core | **RECOMMENDATION** | **Accept for implementation** |
| Independent signed checkpoints are required before production approval | **RECOMMENDATION** | **Accept principle; technology and owner remain open** |
| SQL Server Ledger, SQL Server Audit, and pgAudit are additive controls only | **RECOMMENDATION** | **Accept as optional defense in depth, not the source of truth** |
| Sensitive detail is not released until its audit authorization record commits | **RECOMMENDATION** | **Accept for implementation** |
| Audit source rows are never edited to redact; views and exports apply versioned redaction | **RECOMMENDATION** | **Accept for implementation** |
| Segment-level retention is supported; production periods are not selected | **HUMAN DECISION** | **Open** |
| Verification failure causes a scoped safety hold; exact organizational response is not selected | **HUMAN DECISION** | **Open** |

## 1.3 Primary gate and current status

> **Primary gate:** A privileged mutation cannot succeed without durable audit, and ordinary product/database administration cannot alter history undetected.

**FACT.** No supplied predecessor contains an executed Prompt 21 audit prototype or a passed external-verification/restore drill. The production database is not selected, audit storage technology is explicitly provisional, and audit retention/access remain human decisions.

**Therefore:**

> **The architecture may proceed into strict contracts, pure canonicalization and verification code, engine-neutral schemas, PostgreSQL and SQL Server T1 fault prototypes, and isolated backup/restore experiments. The Prompt 21 gate remains OPEN. No production privileged mutation, audit access, break-glass path, audit export, pruning, verifier trust, or production evidentiary claim is authorized.**

## 1.4 Confidence

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Same-transaction mutation and audit is required | **High** | It directly implements the accepted non-negotiable invariant and avoids cross-system atomicity. | A simpler mechanism that proves the same invariant across every failure boundary. |
| An application-owned typed schema is required | **High** | Native statement logs cannot express UAM purpose, capability, approval, realm, target, minimized diff, and workflow state reliably. | A selected engine-native mechanism demonstrating complete typed semantics without application duplication. |
| External checkpoints materially reduce DBA/host-admin tampering risk | **High** | External digests are independently recomputable and survive local row/file edits when custody is genuinely separate. | A threat model excluding privileged database/host administration or evidence that the external plane is not independent. |
| A per-stream hash chain plus Merkle segment roots is fit for a first prototype | **Medium-High** | Standards and mature transparency systems support append-only verification; UAM composition remains untested. | A model counterexample, unacceptable write contention, or simpler equivalent verification proof. |
| A dedicated transparency-log dependency is needed initially | **Low** | The expected checkpoint rate is small and no public discoverability or multi-party append service is approved. | Regulatory independence, third-party verification, split-view threat, or scale evidence that WORM checkpoints are insufficient. |
| SQL Server Ledger should be mandatory | **Low** | The production engine is open and an engine-neutral design is required. | SQL Server selection plus paired evidence showing substantial assurance benefit at acceptable lifecycle cost. |
| Production audit retention/access can be decided technically | **Low / not established** | These are explicitly human-owned policy and legal decisions. | Recorded decisions from the accountable authorities. |

## 1.5 Residual risk in plain language

Even this design cannot prove that every relevant real-world action was represented correctly. A malicious authorized release can emit a misleading but internally consistent event. A database host administrator can alter unanchored tail data before the next independent checkpoint. A compromised audit signing key can sign false checkpoints. A verifier and product administrator can collude. Time sources can be wrong. Backups can be incomplete. Human approval or purpose data can be false. Tamper evidence reveals inconsistency; it does not automatically identify the attacker or establish legal admissibility.

The architecture contains these risks by minimizing event content, separating authority, sealing frequently under an approved policy, preserving the first failure, preventing ordinary deletion, requiring independent verification, stopping on gaps, and refusing to call UAM telemetry sole forensic proof.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

- typed audit events for authentication, authorization, sensitive reads, exports, policy/rule/task/release changes, diagnostics, approvals, break-glass, deletion, integration, restore, verification, and failures;
- mutation-plus-audit atomicity and audit-before-disclose;
- realm-scoped sequencing, canonicalization, hash linking, segment sealing, Merkle roots, signed checkpoints, and external verification;
- ordinary-admin non-deletion and database/host-admin tamper detection;
- audit search, access control, redaction, exports, alerts, retention mechanics, gap handling, and incident evidence;
- database-native and external tamper-evidence comparisons;
- tests for omitted, duplicated, reordered, altered, rolled-back, unavailable-sink, backup, and restore cases;
- this topic's secure coding, feature flags, observability, accessibility, operations, support, skills, cost, and fitness functions.

## 2.2 Non-goals

This result does not:

- decide lawful purpose, prohibited uses, employee consultation, or whether any real activity should be collected;
- claim UAM audit is sole forensic proof, legal evidence, non-repudiation, or an employee-productivity record;
- select audit retention, audit access, independent verifier owner, regulatory/evidentiary requirements, or organizational response to failure;
- select PostgreSQL or SQL Server;
- select an exact KMS/HSM, signing algorithm, certificate profile, timestamp authority, WORM product, cloud, region, or transparency-log service;
- redesign endpoint diagnostics, ingestion, deletion, restore, release, identity, or portal authorization outside the audit seam;
- introduce a broker, workflow engine, distributed ledger, blockchain, or dedicated audit database by default;
- authorize production use, pilot, production credentials, production signing, or production-derived evidence.

## 2.3 Allowlisted supplied evidence

**FACT.** All eight allowlisted project files were present. No other Project file was read or used.

| Ref | Allowlisted file | SHA-256 of local attachment | Accepted use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted architecture and non-negotiable invariants; not production authority or runtime proof. |
| I02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Legacy shape and target data principles; no production rates, retention, or event fields. |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions and ordered proof gates. |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human authority, and conflict rules. |
| I05 | `result-review-01-foundations.md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted contracts, realm isolation, privacy ceiling, UUIDv7, repository, evidence, and durable-audit invariant. |
| I06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted endpoint privacy boundary, source/event identities, and whole-page atomicity. |
| I07 | `result-review-03-durability-release-identity.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted identity, release, diagnostics, outbox, compatibility, and statement that operational logs are not audit. |
| I08 | `result-review-04-server-platform.md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted server/lifecycle transaction boundaries, minimal privileged audit, realm-first keys, restore/read-enable requirements, and human portal decisions. |

## 2.4 Accepted inputs carried forward

The following are **FACT** from I01 and I05–I08 and remain non-negotiable:

| ID | Accepted input |
|---|---|
| A21-01 | One user, session, installation, service, or realm cannot submit, view, mutate, export, approve, hold, delete, or execute as another. |
| A21-02 | Realm and installation authority comes from authenticated server context, not payload, route, header, certificate text, display name, or client claim. |
| A21-03 | A privileged mutation cannot succeed without durable audit evidence. |
| A21-04 | Operational logs and diagnostics are not the privileged audit ledger. |
| A21-05 | Diagnostics accept only closed value-safe fields and cannot become an arbitrary raw evidence channel. |
| A21-06 | The initial server is a modular monolith with relational transactions and governed module boundaries. |
| A21-07 | The production database engine and audit storage technology are unsettled. |
| A21-08 | PostgreSQL is the reference candidate and SQL Server is a serious fallback; selection is by identical semantic, restore, operations, skills, licensing, and cost evidence. |
| A21-09 | Privileged reprocess, deletion, restore readiness, connector administration, backup expiry, and read enablement require durable audit. |
| A21-10 | Audit stores only the minimum action shell; raw selectors, activity payloads, URLs, arbitrary exception text, and deleted content do not become indefinite audit data. |
| A21-11 | Restore does not enable ordinary reads or egress until acknowledged events, deletion state, and readiness are reconciled. |
| A21-12 | Product and tenant feature controls may narrow, pause, or disable; no feature flag bypasses realm, audit, receipt, tombstone, hold, or readiness invariants. |
| A21-13 | UAM telemetry is fallible operational evidence, not sole forensic proof or an employee-productivity score. |
| A21-14 | Legal purpose, retention, access, ownership, budget, SLO/RPO/RTO, risk acceptance, pilot, and production approval remain human decisions. |

## 2.5 Assumptions

| ID | Assumption | Why it is bounded | How to falsify |
|---|---|---|---|
| AS21-01 | Privileged commands are mediated by UAM application services rather than direct ad hoc SQL. | Accepted modular-monolith and narrow-contract posture. | Database role inventory and hostile direct-SQL test. |
| AS21-02 | One relational transaction can include the business change and audit insert. | Both candidate engines support transactions; UAM schema fit is unproved. | Dual-engine atomicity prototype. |
| AS21-03 | Audit checkpoint volume is low enough for asynchronous segment sealing. | Privileged control-plane actions are expected to be much lower volume than endpoint facts, but no distribution exists. | T1 load and later metadata-only measurement. |
| AS21-04 | A separate administrative failure domain can hold verifier state and checkpoints. | Required for meaningful external verification but no owner/technology is assigned. | Human ownership decision and deployment prototype. |
| AS21-05 | Canonical event bytes can be generated deterministically across supported releases. | Strict contracts and JCS are accepted candidates. | Cross-version/cross-runtime canonical vectors. |
| AS21-06 | Most audit searches can use typed indexed fields rather than arbitrary full-text content. | The recommended schema intentionally excludes arbitrary messages. | Defined support/investigation query corpus. |

## 2.6 Unknowns

- **UNKNOWN:** exact production audit event fields and which actions are legally or regulatorily required.
- **UNKNOWN:** production audit retention, legal hold, deletion, and access rules.
- **UNKNOWN:** whether an independent internal team, external service, regulator, or customer must verify checkpoints.
- **UNKNOWN:** evidentiary requirements for trusted time, signer identity, chain of custody, non-repudiation, and admissibility.
- **UNKNOWN:** maximum acceptable unanchored tail and verifier outage.
- **UNKNOWN:** database engine, edition, topology, backup profile, and whether SQL Server Ledger is available/acceptable.
- **UNKNOWN:** expected privileged-action, sensitive-read, export, and authentication-denial distributions.
- **UNKNOWN:** key custody, threshold/quorum, algorithm, rotation, revocation, recovery, and timestamp profile.
- **UNKNOWN:** acceptable write latency, storage growth, query latency, verification duration, and operational cost.
- **UNKNOWN:** exact portal technology and audit user-interface roles.
- **UNKNOWN:** whether external transparency/discoverability is required rather than private WORM checkpoint storage.
- **UNKNOWN:** how the organization will respond to a verified gap, including whether to stop one realm or all production control-plane work.

## 2.7 Mandatory artifact map

| Mandatory artifact | Normative location | What it contains |
|---|---|---|
| Audit event schema and taxonomy | Sections 5.2–5.4 | Closed event families/types; actor, service, realm, capability, purpose, target, change, result, correlation, time, sequence, hash, and relational constraints |
| Atomic write/verification architecture | Sections 3.5–3.8 and 6.1, 6.5–6.7 | Same-transaction mutation/audit rule; stream head; canonical hash chain; Merkle segments; external checkpoints; independent verification and failure hold |
| Tamper-evidence option matrix | Section 4.1 | Threat, atomicity, independence, retention, operations, licensing, and selection conditions for application, native, WORM, transparency, and external-database options |
| Verification/gap/restore state machines | Sections 6.5–6.7 and 6.10 | Segment/checkpoint lifecycle; PASS/GAP/ALTERED/FORK/STALE handling; declared epochs; isolated restore and readiness reconciliation |
| Access and retention model | Sections 3.9–3.10, 5.8, 6.2, 6.8, and 10 | Audit-before-disclose; realm/purpose/role filtering; redacted projections; export; holds; whole-segment pruning; human decisions |
| Attack/failure test plan | Sections 7, 8, 9, and 11 | Threat register, test matrix, smallest falsifiers, fitness functions, CLI failpoints, tamper corpus, restore verification, and aggregate gate |

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architecture summary

```text
authenticated command
  -> authorization + purpose + approval validation
  -> deterministic business plan + deterministic audit draft
  -> one relational transaction
       lock realm/global audit stream head
       apply privileged business mutation
       append typed audit event
       advance stream sequence and hash head
       enqueue checkpoint/verification work
     COMMIT
  -> response or workflow progression

sealed audit segments
  -> independent read-only verifier
       fetch committed events and stream head
       reconstruct canonical bytes
       verify sequence/hash/Merkle root
       sign checkpoint manifest
       write checkpoint outside ordinary product/DB admin boundary
       report PASS, GAP, ALTERED, FORK, STALE, or UNAVAILABLE
  -> control plane enforces verification freshness policy
```

## 3.2 Components and responsibilities

| Component | Normative responsibility | Explicit prohibitions | Trust boundary |
|---|---|---|---|
| **Authenticated Request Context** | Supply immutable realm, principal/service, credential, session, assurance, and request correlation from trusted identity middleware. | No body/header/display-name authority; no caller override. | Identity boundary → application. |
| **Command Authorization Service** | Evaluate closed capability, realm, target, purpose, approval, policy/release state, and break-glass permit. Produce a content-addressed decision record. | No free-form role logic; no silent default allow; no audit bypass. | Application authorization boundary. |
| **Audit Taxonomy Registry** | Own event types, required fields, allowed target/diff fields, severity, retention class, access class, and compatibility. | No runtime event names, arbitrary strings, extension bags, or tenant-defined event schema. | Release-authorized contract boundary. |
| **Audit Draft Builder** | Construct one deterministic immutable event draft from authenticated context and validated command plan before the transaction. | No exception object, raw request, raw selector, URL, query text, secret, or mutable object graph. | Application → persistence adapter. |
| **Privileged Command Repository** | In one transaction, apply the business change, append the audit event, advance stream head, and enqueue verification work. | No commit without audit; no audit-after-commit callback; no external I/O in transaction. | Modular-monolith module → relational database. |
| **Audit Stream Head** | Serialize sequence/hash advancement per realm or global stream using row lock/CAS and database time. | No wall-clock ordering, client sequence, or reset on deploy/restore. | Database concurrency boundary. |
| **Audit Ledger Tables** | Preserve append-only event, segment, checkpoint-publication work, audit-access events, and retention evidence. | Runtime UPDATE/DELETE/TRUNCATE; arbitrary text; cross-realm key; direct ordinary-admin write. | Database data boundary. |
| **Segment Sealer** | Close eligible contiguous event ranges, compute Merkle root, bind previous segment/checkpoint, and enqueue verification. | No rewriting event rows; no claiming verification; no pruning. | Primary database → verification queue. |
| **Independent Verifier** | Independently canonicalize and recompute sequence, event hashes, segment roots, and checkpoint continuity; sign results with a purpose-separated key. | No business mutation, no trust in stored event hash alone, no use of product signing key, no auto-repair. | Separate process, credential, administration, and preferably storage account. |
| **Checkpoint Store/Anchor** | Retain signed checkpoint manifests outside ordinary product and database administration. | No overwrite, mutable “latest only,” or shared delete authority with product admins. | Independent custody boundary. |
| **Verification Status Projector** | Import authenticated verifier results into a bounded local status cache and enforce stale/gap holds. | No verifier key, no conversion of FAIL to PASS, no self-reenable. | External verifier → control plane. |
| **Sensitive Read Gate** | Execute authorized query, append durable read event, commit, then release result bytes. | No response before audit commit; no bulk raw selector in event; no hidden bypass endpoint. | Database → user disclosure boundary. |
| **Export Orchestrator** | Audit request/approval, build a closed encrypted artifact in private staging, audit manifest/completion, then release a one-use retrieval capability. | No synchronous untracked download; no artifact release before completion audit; no arbitrary export query. | Control plane → export storage/recipient. |
| **Audit Query API/BFF** | Enforce realm/capability/purpose, fixed filters, pagination, redaction profile, access audit, and export workflow. | No direct SQL, full-table dump, arbitrary field selection, unbounded search, or cross-realm cache. | Auditor/support user → audit store. |
| **Retention Controller** | Execute approved whole-segment retention, hold checks, checkpoint preservation, and destruction evidence. | No row-by-row deletion that breaks a retained chain; no ordinary admin purge; no invented duration. | Governance authority → audit store/anchor. |
| **Restore Orchestrator** | Restore into isolated identity; keep mutation/read/export disabled; reconcile against external checkpoints; create readiness evidence. | No trust in restored local head alone; no sequence reset; no ordinary routing before readiness. | Backup domain → isolated restore domain. |
| **Security Alerting** | Alert on audit write failure, sequence conflict, stale anchor, gap, hash/signature mismatch, direct-table attempt, break-glass, export, retention, and verifier failure using finite dimensions. | No subject/realm/user IDs as metric labels; no raw event content. | Audit state → operations/security. |

## 3.3 Trust boundaries and adversaries

The design distinguishes these adversaries:

1. **Untrusted caller** — can submit malformed or unauthorized requests but has no database access.
2. **Authorized ordinary administrator** — can perform specific product operations but must not edit or delete audit history.
3. **Compromised application identity** — can call allowed database procedures; damage is bounded by database grants and transaction invariants.
4. **Database administrator/superuser** — can bypass normal grants and potentially alter rows, DDL, backups, or files; external checkpoints are the detection boundary.
5. **Host/storage administrator** — can edit database files or restore old backups; external checkpoints and restore state prevent silent acceptance.
6. **Verifier operator** — can suppress or falsify verification if its key/storage is compromised; separation, multiple anchors where required, key rotation, and monitoring contain this risk.
7. **Colluding product and verifier administrators** — cannot be eliminated by one internal technical control; third-party witnessing or regulator/customer-held checkpoints may be required by **HUMAN DECISION**.
8. **Malicious authorized release** — can emit semantically false but cryptographically consistent events; independent code review, provenance, typed contracts, and business reconciliation are necessary.
9. **Incident responder/support user** — needs evidence but must not gain raw activity or unrestricted query authority.

## 3.4 Realm isolation

1. Every realm-scoped business, query, cache, export, and authorization key MUST begin with authenticated `realm_id`. The audit schema uses a non-null `audit_scope_id`: for a realm scope it equals the authenticated `realm_id`; for the product-global scope it is a separately registered product-global UUID. This avoids nullable primary keys while preserving realm-first isolation.
2. Product-global actions use the registered `PRODUCT_GLOBAL` audit scope and a distinct global control stream; they cannot be inserted into a realm scope or vice versa. Engine-specific filtered/partial uniqueness plus migration tests enforce exactly one active product-global scope.
3. The external checkpoint may use an opaque random `stream_id`; tenant names and personal identifiers are absent.
4. A global audit reader requires an explicit global capability and purpose. A realm reader cannot widen scope by filter omission.
5. Cross-realm correlation is not a generic query feature. An approved investigation workflow creates an explicit multi-realm case manifest and audits each realm scope.
6. Identical event IDs or target IDs in different realms remain separate. Any cache key that omits realm fails architecture tests.
7. Audit exports are realm-specific unless an explicit global export command and approval contract is used.

## 3.5 Atomic write/verification architecture: mutation-plus-audit rule

For every privileged command classified `AUDIT_REQUIRED_MUTATION`:

```text
BEGIN TRANSACTION;

1. Revalidate authenticated context, capability, purpose, target realm,
   approval/break-glass permit, product/tenant policy, and current safety holds.
2. Lock the appropriate `audit_stream` row.
3. Re-read the business state and construct the final deterministic mutation plan.
4. Apply the business mutation using compare-and-swap/state preconditions.
5. Construct final audit result fields from actual affected state, not caller claims.
6. Canonicalize the event, compute prev_hash and event_hash, and insert audit_event.
7. Update `audit_stream` to the new sequence/hash.
8. Insert any workflow/integration outbox rows and audit_seal_work in the same transaction.
9. Require exactly the expected business and stream-head row counts.
10. COMMIT.

Only after COMMIT may the command return SUCCESS or publish downstream work.
```

Any failure before commit leaves the business state and audit stream unchanged. A commit ambiguity is reconciled by stable `command_id`; the caller never retries with a new identity merely because the response was lost.

## 3.6 Audit-before-disclose for sensitive reads

A sensitive read cannot be rolled back after bytes are disclosed, so the boundary is **release of data**, not the internal database read:

```text
BEGIN TRANSACTION;
1. Authorize fixed query capability, realm, purpose, target class, fields, and bounds.
2. Execute the bounded query under the transaction and compute result count/bounds.
3. Append SENSITIVE_READ_COMPLETED with target manifest digest and result count bucket.
4. COMMIT.
5. Only now serialize/release response bytes.
```

If audit commit fails, the result buffer is discarded and the caller receives a finite safe error. Large reads and exports use an asynchronous artifact workflow; they are never streamed before durable audit.

## 3.7 Hashing, segments, and checkpoints

The portable design uses standard append-only/Merkle proof concepts while keeping UAM event meaning and mutation atomicity in the application transaction [S06–S08].

### Event chain

```text
canonical_event_core = canonical_encode(
  AuditEventV1 excluding previous_event_hash and event_hash
)

event_hash = SHA-256(
  ASCII("UAM-AUDIT-EVENT-V1\0")
  || previous_event_hash                 # exactly 32 bytes
  || uint64_be(length(canonical_event_core))
  || canonical_event_core
)
```

The stream sequence is the authoritative order. `occurred_at_utc` and `recorded_at_utc` are evidence fields, not ordering or authorization.

### Segment root

A segment is a contiguous closed range in one stream. Leaves are ordered by `stream_sequence`; `leaf_hash = SHA-256(0x00 || event_hash)` and `node_hash = SHA-256(0x01 || left_hash || right_hash)`. The root follows the RFC 9162 Merkle Tree Hash split rule and never duplicates an unmatched final leaf. The exact rule is identified by `merkle_profile_id` and frozen with golden vectors. The sealer records:

```text
stream_id
stream_epoch
first_sequence / last_sequence
event_count
first_event_hash / last_event_hash
merkle_root
previous_segment_manifest_digest
schema_profile_id
canonicalization_profile_id
created_at_utc / sealed_at_utc
sealer_release_id
```

Exact segment event count, age, and checkpoint cadence are **ESTIMATE / HUMAN DECISION / CLI EXPERIMENT** inputs. The schema supports both size and age triggers without making either a timeless constant.

### Signed checkpoint

The independent verifier signs a canonical manifest containing at least:

```text
checkpoint_id
verifier_identity and key_id
verification_profile_id
stream_id / stream_epoch
verified_first_sequence / verified_last_sequence
verified_event_count
segment_manifest_digest / merkle_root
previous_trusted_checkpoint_digest
primary_database_incarnation_id
backup_or_restore_lineage_id when applicable
verification_started_at / completed_at
result = PASS | GAP | ALTERED | FORK | STALE_INPUT | INCOMPLETE
safe_findings[]
```

The checkpoint contains roots, counts, opaque IDs, and finite results—not activity, selectors, diffs, actor names, URLs, or target values.

## 3.8 Independence model

Production independence requires all of the following, unless a formally accepted threat model narrows them:

- a verifier executable separately built and reviewed from the write path;
- a read-only database credential that cannot mutate business or audit tables;
- a signing key purpose-separated from release, device, policy, receipt, diagnostic, and database keys;
- checkpoint storage whose delete/overwrite administration is not held solely by ordinary product/database administrators;
- verifier state that is not restored from the same backup as the product database;
- alerts observable outside the affected product plane;
- documented key rotation, revocation, disaster recovery, and first-trust procedure.

**HUMAN DECISION.** Whether this separation is another internal team, a separate cloud account, a third-party service, a regulator/customer-held checkpoint, or a witness quorum is not selected here. The verifier/claim/action separation follows the general verifiable-system claimant model, but the actual UAM authorities remain organizational decisions [S20].

## 3.9 Audit access, redaction, and retention model

The model applies general audit-control and secure-logging principles—defined event content, protected access, review, minimization, injection-safe presentation, and controlled disposal—through UAM-specific closed capabilities [S01–S04]. Capabilities are closed and do not imply organizational role names:

| Capability | Scope | Effect |
|---|---|---|
| `audit.read.realm.summary` | One authenticated realm | Search minimum event shell and finite summaries. |
| `audit.read.realm.detail` | One authenticated realm | View approved detailed fields under purpose and case. |
| `audit.read.global.summary` | Product-global or explicit multi-realm case | Search global control events and approved cross-realm summaries. |
| `audit.export.realm` | One realm and fixed export profile | Start governed asynchronous export. |
| `audit.verify` | Opaque stream/checkpoint data | Run or inspect verifier results; no business mutation. |
| `audit.anchor.publish` | Checkpoint manifest only | Publish signed checkpoint to approved anchor. |
| `audit.retention.execute` | Approved sealed segment manifest | Execute retention after holds and approvals. |
| `audit.breakglass.activate` | Exact capability/realm/time/purpose | Activate a short-lived emergency permit; never bypass audit. |
| `audit.schema.migrate` | Release-authorized migration | Apply expand/backfill/contract migration under audit and evidence. |

Rules:

1. Audit access is itself audited before disclosure.
2. Search uses fixed typed filters: time range, event type, outcome, target class, capability, command/workflow/case ID, actor opaque ID, stream sequence, and safe error code.
3. Arbitrary SQL, regex, full-text payload search, dynamic field selection, and unbounded export are absent.
4. Redaction is a versioned view/export profile. Source audit rows and hashes are never changed to redact.
5. Actor display names are resolved at view time from an authorized identity projection; the durable event stores an opaque principal ID and identity-source revision.
6. Deleted or unavailable display mappings render as an opaque historical actor token; audit integrity does not depend on retaining person attributes forever.
7. Low-entropy or personal values are not stored as ordinary hashes that can be enumerated. Content digests are used only for already-approved canonical artifacts or high-entropy opaque manifests.
8. Every export has a manifest, purpose, approval state, field profile, row count, digest, recipient class, expiry, retrieval state, and deletion evidence.

## 3.10 Retention mechanics without selecting a period

**RECOMMENDATION.** Audit event content is minimized at creation, then retained/pruned by **whole sealed segment**, not by editing individual rows inside a retained chain. This is a UAM-specific mechanism implementing general audit-protection, retention, and safe-disposal objectives rather than a period selected by those sources [S01–S03].

A segment is eligible for destruction only when all predicates are true:

```text
approved retention policy revision applies
AND no legal/incident/verification hold applies
AND segment is externally checkpointed and checkpoint remains retained
AND all required audit exports/cases have completed their own lifecycle
AND minimum predecessor/successor continuity evidence remains
AND deletion target manifest is complete
AND authorized retention command and durable audit event commit
```

The controller then deletes the segment through a typed adapter, verifies absence, retains the signed checkpoint/root and minimum destruction evidence for its separately approved period, and appends a retention event in the current stream. Exact periods, whether roots survive longer than event content, and whether law requires preserving full events are **HUMAN DECISION**.

## 3.11 Feature flags and kill switches

There is no production flag that means “skip audit.” The following controls are narrowing only:

| Control | Allowed effect | Forbidden effect |
|---|---|---|
| `audit.sensitive-read.enabled` | Deny sensitive reads when off. | Allow an unaudited read. |
| `audit.export.enabled` | Deny new exports when off. | Release an existing uncommitted artifact. |
| `audit.breakglass.enabled` | Deny activation when off. | Remove audit or approval requirements. |
| `audit.external-publish.enabled` | Pause publication for containment; start stale timer/hold. | Mark unpublished data verified. |
| `audit.verification-required` | Require current verified checkpoint for configured capabilities. | Be disabled by tenant policy or ordinary admin. |
| `audit.realm-hold` | Deny privileged mutation/read/export in one realm. | Broaden authority. |
| `audit.global-hold` | Deny privileged control-plane work globally. | Rewrite history or clear findings. |
| `audit.retention.enabled` | Prevent pruning when off. | Force pruning despite hold or failed verification. |

Automatic safety shutdown is not an unaudited privileged mutation. An operator-issued configuration change, re-enable, hold clearance, or emergency override remains audit-required.

## 3.12 Privacy-safe observability and cardinality

Metrics and alerts use finite labels only, such as:

```text
component
event_family
stream_scope = REALM | GLOBAL
result_family
verification_state
error_family
database_engine_profile
release_ring
```

Forbidden labels or messages include realm ID, tenant name, actor ID, session ID, command ID, target ID, case ID, URL, policy content, rule text, diff value, free-form reason, exception message, SQL, database name, checkpoint hash, or signature. Exact identifiers and digests belong in access-controlled evidence, not metric labels.

## 3.13 Accessibility requirements

The audit portal and incident workflows MUST:

- be fully keyboard operable with logical focus order and visible focus;
- expose verification, export, and workflow status programmatically, not only by color or animation;
- announce asynchronous completion/failure as accessible status messages without unexpectedly moving focus;
- provide text equivalents for gap/fork/timeline diagrams;
- preserve semantic table headers, sortable-state announcements, and pagination position;
- require confirmation and reversible review before high-impact export, break-glass activation, hold clearance, or retention execution;
- never hide a verification failure behind transient toast-only UI.

These requirements apply WCAG 2.2 and its status-message guidance to the security-critical audit workflow; conformance still requires testing in the selected portal with assistive technologies [S18–S19].

## 3.14 Audit data quality and reconciliation

Audit quality is not a single score. The implementation MUST expose and test these independent dimensions:

| Dimension | Normative rule | Detection and evidence |
|---|---|---|
| Completeness | Every release-catalogued privileged command reaches exactly one allowed terminal audit outcome; every successful business effect has the required success event | Command/effect/event reconciliation, architecture mutations, failpoints, missing-event alarm |
| Validity | Every event conforms to an active exact schema, closed taxonomy, field/profile bounds, and authenticated scope | Strict parser/schema result, contract/profile digest, rejected-vector evidence |
| Uniqueness/idempotency | A stable command/effect produces one terminal success event and one stream sequence; response loss reuses the same identity | Unique constraints, command-state lookup, replay ledger, model histories |
| Ordering | Sequence is contiguous within one scope/stream/epoch; time is not order authority | Head-row transaction, verifier sequence scan, gap/duplicate/reorder findings |
| Provenance | Actor/service/release/authz/purpose/approval fields come from authenticated or release-owned context, not caller claims | Context-binding tests, executable/contract digests, realm-negative tests |
| Semantic consistency | Event type, outcome, target revision, affected count, and diff profile agree with the committed business transition | Deterministic mutation plan, post-state assertions, independent command/effect/event reconciler |
| Timeliness | `recorded_at` and checkpoint freshness are measured with explicit time quality; stale anchors are not presented as current | Database time, verifier timestamps, unanchored age/count/bytes and hold state |
| Privacy quality | Event contains only permitted typed fields; forbidden values and low-entropy derivatives are absent from all sinks | Schema allowlist, canary scanner, hostile input/export tests, retention/access review |
| Restore continuity | Restored stream/checkpoint and authoritative command/effect/event sets agree before readiness | External checkpoint comparison, replay/reconciliation manifests, deleted-negative and expected-positive probes |

Corrections never overwrite the source event. A correction is a new typed event linked to the original, with its own authority, reason code, and effect. Unknown or unprovable quality remains an explicit finding; it is not coerced to `PASS`, averaged away, or converted into a user/productivity score.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Tamper-evidence option matrix

| Option | Mutation atomicity | Detects ordinary app/DB admin deletion | Detects host/file admin tampering | Verification independence | Operations/licensing | UAM fit | Decision |
|---|---|---|---|---|---|---|---|
| **A. Application typed ledger + per-stream chain + external signed checkpoints** | **Yes**, same business transaction | Yes for granted roles; external checkpoint detects privileged alteration | Yes after anchored checkpoint; unanchored tail remains exposed | Configurable and engine-neutral | Custom code and runbooks; no new runtime license by default | Exact UAM semantics, realm, purpose, approval, diff, restore | **RECOMMENDED mandatory core** |
| **B. SQL Server append-only/updatable Ledger + external database digests** | Ledger rows participate in DB transaction | Strong API-level protection; digest verification detects bypass | Yes when digests are independently protected | Strong if digest storage is separately administered | SQL Server 2022+ feature/edition/topology and Azure/on-prem operations must be checked | Valuable defense in depth if SQL Server selected; not portable and not full business taxonomy | **Conditional additive control** |
| **C. SQL Server Audit with `FAIL_OPERATION`** | Can fail audited database operations when target unavailable | Captures engine actions; target protection needed | Depends on target/host protection | Usually limited without separate custody | Native operations; configuration and volume complexity | Useful direct-SQL/DDL backstop; statement semantics are not UAM business semantics | **Supplemental only** |
| **D. PostgreSQL + pgAudit** | Project documentation describes best-effort/nontransactional logging; exact stable-version behavior requires lab proof | Useful statement/object evidence; privileged user/config/log target risk remains | Depends on external log target and host | Separate collector possible but not inherent | Open source; extension version coupled to PostgreSQL major; high log volume possible | Useful direct-SQL/DDL backstop; cannot meet mutation-plus-audit invariant alone | **Supplemental only** |
| **E. Dedicated transparency log (Tessera/Rekor/Trillian)** | No cross-system atomicity with business mutation | Strong append/inclusion/consistency evidence once integrated | Strong when monitored/witnessed | Potentially high; supports third-party verification | Additional service, keys, storage, monitoring, witness, lifecycle, skills | Appropriate if public/multi-party discoverability or split-view resistance is required | **Defer pending measured/governance need** |
| **F. immudb as primary audit database** | Separate transaction boundary unless business state also moves there | Native cryptographic history and auditor | Strong within its threat model, subject to independent roots/auditor | Separate service possible | New database, skills, backup, HA, support, migration, licensing review | Duplicates business transaction and creates dual-write problem | **Reference/lab candidate only; reject as primary** |
| **G. WORM object snapshots/checkpoints only** | No event-level transaction semantics | Detects replacement/deletion of anchored manifests if WORM is correctly configured | Detects local divergence against retained roots | Moderate to high with separate account | Simpler than transparency service; provider/storage policy matters | Good first external anchor, but no inclusion/discoverability or semantic audit by itself | **Recommended first anchor candidate, human-owned selection** |
| **H. Signed syslog/ordinary SIEM pipeline** [S10] | No business transaction atomicity | Can detect some gaps/alteration | Depends on sender/collector/key and delivery | Collector can be separate | Familiar operations but high privacy/volume surface | Useful security telemetry, not authoritative business audit | **Reject as primary** |
| **I. Blockchain/consortium ledger** | Cross-system atomicity still unresolved | Potential multi-party history | Depends on consensus/key/governance | High in suitable multi-party model | Highest complexity, cost, privacy, and governance surface | No approved low-trust multi-party requirement | **Reject now** |

## 4.2 Why the recommended core is engine-neutral

**FACT.** SQL Server Ledger provides cryptographic ledger tables, external database digests, and verification; Microsoft also states a machine-controlling attacker can bypass database checks and that verification against protected external digests is what detects such tampering [S11–S14]. **FACT.** SQL Server Audit can be configured to fail audited operations when its target cannot accept records, but the default is to continue and potentially lose audit [S15]. **FACT.** The current pgAudit project warns about potentially enormous text-log volume and its newer release documentation explicitly describes the mechanism as best-effort and nontransactional [S16–S17].

**INFERENCE.** These features are valuable backstops but cannot be the portable UAM source of truth. They do not replace the application decision record, purpose, approval chain, minimized target, workflow correlation, or cross-engine contract.

## 4.3 Rejected designs

| Design | Decision | Reason |
|---|---|---|
| Write business state, then log success afterward | **REJECTED** | Crash/log failure produces a successful unaudited mutation. |
| Send audit to an external HTTP service before local commit | **REJECTED** | External success followed by local rollback produces false success evidence; external failure blocks without knowing local commit. |
| Send external audit after local commit | **REJECTED AS PRIMARY** | Response loss/outage produces a successful mutation without required durable external record. |
| Distributed transaction/2PC with external verifier | **REJECTED INITIALLY** | Adds coordinator, in-doubt recovery, availability, and operations complexity; external verification is not the business state owner. |
| Database trigger that serializes arbitrary row images for every table | **REJECTED AS PRIMARY** | Over-collects sensitive data, misses purpose/approval semantics, creates schema coupling, and can be disabled by privileged DDL. |
| Free-form JSON `details` or text message column | **REJECTED** | Enables leakage, injection, semantic drift, unbounded cardinality, and unverifiable compatibility. |
| Hash/HMAC every raw target or subject value | **REJECTED BY DEFAULT** | Low-entropy values remain enumerable/linkable and create a second personal-data store. |
| One global sequence for every realm | **REJECTED INITIALLY** | Creates avoidable contention and cross-realm coupling; global actions already have a separate stream. |
| One chain per actor/session | **REJECTED** | Makes lifecycle and verification cardinality unbounded and allows omission by choosing another stream. |
| Timestamp as event ordering | **REJECTED** | Clock changes, concurrency, and precision cannot provide one durable order. |
| Edit source rows to redact or correct | **REJECTED** | Invalidates hashes and destroys evidence. Corrections are new typed events. |
| Delete audit event when the related subject is deleted | **REJECTED GENERALLY** | Destroys privileged-action evidence. Avoid subject content at creation and use separate mappings/lifecycle. |
| Retain all audit forever | **REJECTED** | No blanket purpose; increases privacy, breach, access, and cost risk. |
| Let DBAs prune or clear holds directly | **REJECTED** | Conflicts with ordinary-admin non-deletion and bypasses purpose/approval/audit. |
| Break-glass without audit because it is an emergency | **REJECTED** | Creates the highest-risk unaudited path. Automatic safe shutdown is the emergency fallback. |
| Repair a gap by inserting synthetic normal events | **REJECTED** | Falsifies history. Record an explicit gap declaration and new epoch after authorized investigation. |
| Restore the database and trust its local latest hash | **REJECTED** | The local head can be rolled back with the backup. External trusted state is required. |
| Treat a signature alone as proof the event is true | **REJECTED** | It authenticates bytes/key use, not correctness, lawful purpose, or completeness. |

## 4.4 Conditions that would change the choice

A new ADR/change proposal is required if evidence shows any of the following:

- per-realm head locking causes unacceptable contention under measured privileged/read audit load;
- the selected database cannot atomically enforce the mutation/audit/head update semantics;
- an approved evidentiary regime requires qualified timestamps, external notarization, customer/regulator-held checkpoints, or witness quorum; RFC 3161 supplies one timestamp protocol reference but does not decide the required policy or legal effect [S09];
- independent split-view resistance is required, making a transparency log plus witness preferable to private WORM anchors;
- SQL Server is selected and Ledger materially improves recovery/tamper detection without blocking accepted retention and schema needs;
- a business requirement needs partial audit field expiry that whole-segment retention cannot satisfy, requiring a separately verified encrypted-envelope or redactable-commitment design;
- audit volume is high enough that the primary OLTP database cannot meet approved SLO/cost/backup requirements even after partition/index/segment evidence;
- the threat model requires protection from colluding product, database, cloud-account, and verifier administrators.

The proposal must name the accepted decision affected, new primary evidence, threat/privacy/realm impact, alternatives, smallest falsifying experiment, migration/restore consequence, and ADR action.

---

# 5. Interfaces/protocols and example contracts or schemas; normative audit event taxonomy and schemas

## 5.1 Normative vocabulary and contract rules

The words `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` in this section are normative implementation requirements, subject to the human decisions explicitly left open.

Every audit-producing contract MUST define:

- an immutable contract name and exact semantic version;
- the owning module, producer, required consumers, accountable engineering function, and support function;
- authenticated actor and realm authority sources;
- the event type, capability, purpose, target class, outcome, and correlation rules;
- required, optional, nullable, and prohibited fields;
- strict size, item, nesting, time, and allocation bounds;
- canonicalization and hash-input rules;
- the business transaction and disclosure boundary;
- idempotency, retry, duplicate, conflict, and rollback semantics;
- compatibility and rollout tests;
- allowed logs, metrics, diagnostics, exports, and redactions;
- valid, invalid, boundary, hostile, and old/new vectors;
- incident, verification, gap, restore, retention, and cleanup runbooks.

**RECOMMENDATION.** Audit contracts use the accepted strict UAM JSON profile at HTTP/tool boundaries and a typed in-process/domain representation internally. Persistence is relational typed columns plus closed typed child tables; a generic arbitrary JSON `details` column is prohibited.

## 5.2 Audit event taxonomy

### 5.2.1 Taxonomy design rules

Each audit event has exactly one `event_family`, one `event_type`, one `outcome`, and one `event_version`. A single action MAY create several events only when each marks a distinct, named state transition; one command MUST NOT emit an unbounded narrative stream.

Every event type MUST declare:

- whether it is **transaction-required**, **disclosure-required**, **security-required**, or **operational-only**;
- the minimum actor, capability, purpose, target, correlation, and outcome fields;
- whether an approval or break-glass reference is mandatory;
- whether the event is realm-scoped or product-global;
- whether the event may contain a minimized field-level change summary;
- its retention class, subject-data profile, and export eligibility;
- its alerting and verification severity.

### 5.2.2 Required families and initial event types

| Family | Required initial event types | Transaction/disclosure rule | Notes |
|---|---|---|---|
| `AUTHENTICATION` | `AUTHN_ATTEMPT`, `AUTHN_SUCCEEDED`, `AUTHN_FAILED`, `SESSION_STARTED`, `SESSION_ENDED`, `STEP_UP_SUCCEEDED`, `STEP_UP_FAILED`, `CREDENTIAL_ENROLLED`, `CREDENTIAL_REVOKED` | Security-significant authenticated events are durable; high-volume anonymous spray MAY be bounded security telemetry plus aggregate audit occurrence, not one durable business row per packet | Never store password/token/secret, raw certificate, or arbitrary identity claim |
| `AUTHORIZATION` | `AUTHZ_ALLOWED`, `AUTHZ_DENIED`, `CAPABILITY_GRANTED`, `CAPABILITY_REVOKED`, `ROLE_BINDING_CHANGED`, `ACCESS_POLICY_EVALUATION_FAILED` | A privileged command MUST bind its final authorization decision or digest; denials that reveal or attempt privileged capability are durable | Actor/realm comes from authenticated context, not request body |
| `SENSITIVE_READ` | `SENSITIVE_READ_REQUESTED`, `SENSITIVE_READ_COMPLETED`, `SENSITIVE_READ_DENIED`, `SENSITIVE_READ_FAILED` | No sensitive result bytes may be disclosed before the completion event is committed | Read scope uses typed target and count/bucket; no query text or raw subject selector |
| `EXPORT` | `EXPORT_REQUESTED`, `EXPORT_APPROVAL_REQUIRED`, `EXPORT_APPROVED`, `EXPORT_REJECTED`, `EXPORT_BUILD_STARTED`, `EXPORT_BUILT`, `EXPORT_RELEASED`, `EXPORT_DOWNLOADED`, `EXPORT_REVOKED`, `EXPORT_EXPIRED`, `EXPORT_DELETED`, `EXPORT_FAILED` | Build and release are separate. Release/download requires durable audit before disclosure | Object locator is opaque; content digest is permitted; exported content is not copied into audit |
| `CONTROL_MUTATION` | `POLICY_REVISION_CREATED`, `POLICY_REVISION_ACTIVATED`, `POLICY_REVISION_REJECTED`, `RULE_REVISION_CREATED`, `RULE_REVISION_ACTIVATED`, `TASK_CHANGED`, `SCHEDULE_CHANGED`, `RELEASE_AUTHORIZED`, `RELEASE_REVOKED`, `FEATURE_NARROWED`, `KILL_SWITCH_ACTIVATED`, `KILL_SWITCH_CLEARED`, `CONFIGURATION_CHANGED` | Business mutation and success/failure event commit together | Tenant controls may only narrow accepted product controls |
| `APPROVAL` | `APPROVAL_REQUESTED`, `APPROVAL_GRANTED`, `APPROVAL_DENIED`, `APPROVAL_WITHDRAWN`, `APPROVAL_EXPIRED`, `QUORUM_SATISFIED`, `QUORUM_INVALIDATED` | Approval state transition and audit commit together | No approval may be inferred from UI state or email alone |
| `BREAK_GLASS` | `BREAK_GLASS_REQUESTED`, `BREAK_GLASS_ACTIVATED`, `BREAK_GLASS_ACTION`, `BREAK_GLASS_ENDED`, `BREAK_GLASS_EXPIRED`, `BREAK_GLASS_REVOKED`, `BREAK_GLASS_FAILED` | Activation and every privileged action remain audit-required; automatic expiry is mandatory | Break-glass does not bypass realm, minimization, immutable audit, or destructive-action controls |
| `DIAGNOSTICS_SUPPORT` | `DIAGNOSTIC_PERMIT_ISSUED`, `DIAGNOSTIC_PERMIT_ACTIVATED`, `DIAGNOSTIC_PERMIT_REVOKED`, `SUPPORT_BUNDLE_BUILT`, `SUPPORT_BUNDLE_RELEASED`, `SUPPORT_BUNDLE_DELETED`, `SUPPORT_ACCESS_GRANTED`, `SUPPORT_ACCESS_DENIED`, `DIAGNOSTIC_FAILURE` | Permit/access/bundle release are privileged mutations or disclosures | No raw activity, URL, path, arbitrary log text, dump, or secret in audit |
| `LIFECYCLE` | `RETENTION_POLICY_CHANGED`, `LEGAL_HOLD_PLACED`, `LEGAL_HOLD_RELEASED`, `DELETION_REQUESTED`, `DELETION_AUTHORIZED`, `DELETION_BARRIER_COMMITTED`, `DELETION_TARGET_VERIFIED`, `DELETION_COMPLETED`, `DELETION_LIMITATION_RECORDED`, `BACKUP_EXPIRY_AUTHORIZED`, `RESTORE_STARTED`, `RESTORE_VERIFICATION_FAILED`, `RESTORE_READY`, `READ_ENABLEMENT_GRANTED` | Every privileged lifecycle transition is transaction-audited; read enablement is separate from technical readiness | Subject selector is not copied; use case, manifest, or opaque scope token |
| `INTEGRATION` | `INTEGRATION_CREATED`, `INTEGRATION_CHANGED`, `INTEGRATION_ENABLED`, `INTEGRATION_DISABLED`, `INTEGRATION_TESTED`, `INTEGRATION_DELIVERY_REPLAYED`, `INTEGRATION_CREDENTIAL_ROTATED`, `INTEGRATION_DELETION_REQUESTED`, `INTEGRATION_DELETION_CONFIRMED`, `INTEGRATION_LIMITATION_RECORDED` | Control mutation and audit commit together; external result is a later occurrence | Never record credential or destination URL in event body |
| `REPROCESS_CORRECTION` | `REPROCESS_REQUESTED`, `REPROCESS_APPROVED`, `REPROCESS_STARTED`, `REPROCESS_COMPLETED`, `REPROCESS_FAILED`, `CORRECTION_ISSUED`, `CORRECTION_REJECTED` | Command and authorization audit commit before work starts; terminal result is appended separately | Original evidence is never edited |
| `SECURITY_FAILURE` | `REALM_MISMATCH_BLOCKED`, `AUDIT_WRITE_FAILED`, `AUDIT_INTEGRITY_CONFLICT`, `UNAUTHORIZED_ADMIN_PATH_BLOCKED`, `CANARY_DETECTED`, `SIGNATURE_VALIDATION_FAILED`, `KEY_STATE_INVALID`, `CLOCK_UNCERTAIN`, `DIRECT_DATABASE_MUTATION_DETECTED` | Security failures are durable where the same trusted transaction is available; otherwise enter emergency local evidence and safe hold as section 6 defines | Failure evidence remains value-free and bounded |
| `AUDIT_SYSTEM` | `AUDIT_STREAM_CREATED`, `AUDIT_SEGMENT_SEALED`, `CHECKPOINT_CREATED`, `CHECKPOINT_PUBLISHED`, `CHECKPOINT_COSIGNED`, `VERIFICATION_PASSED`, `VERIFICATION_FAILED`, `VERIFICATION_STALE`, `GAP_DECLARED`, `EPOCH_STARTED`, `KEY_ROTATED`, `KEY_REVOKED`, `AUDIT_SCHEMA_CHANGED`, `AUDIT_SEGMENT_PRUNED`, `AUDIT_EXPORT_CREATED` | These form the audit system's own trace; self-referential events are written to a dedicated system stream | A verification result does not overwrite the verified data |

### 5.2.3 Success, failure, denial, and no-effect rules

- A successful privileged mutation emits exactly one terminal success event for the command identity, even if a network response is lost.
- A failed privileged mutation emits a terminal failure event **only when the failure event can be committed without creating the prohibited business effect**. A transaction rollback cannot preserve an event inside the rolled-back transaction; therefore precondition and authorization denials use a separate short audit-only transaction after the system proves that no business mutation committed.
- Unknown commit outcomes MUST be reconciled by command ID before retry. A retry does not create a second success event.
- A no-effect idempotent replay emits either the original event reference or one bounded `COMMAND_REPLAY_OBSERVED` occurrence, according to the event contract. It MUST NOT masquerade as a new mutation.
- Authentication packet floods, malformed unauthenticated traffic, and health noise MUST NOT create an unbounded audit denial-of-service channel. The product MUST preserve aggregate security evidence, thresholds, and representative samples under a release-owned bounded policy.

## 5.3 Normative audit event schema

### 5.3.1 Logical schema

```text
AuditEventV1 {
  event_id: UUIDv7
  audit_scope_id: UUIDv7               # realm_id for REALM; registered singleton for PRODUCT_GLOBAL
  stream_id: UUIDv7
  stream_epoch: uint64
  stream_sequence: uint64
  realm_scope: REALM | PRODUCT_GLOBAL
  realm_id: UUIDv7?                    # null only for explicitly global stream

  event_family: closed enum
  event_type: closed enum
  event_version: semver
  outcome: SUCCEEDED | FAILED | DENIED | NO_EFFECT | STARTED | EXPIRED | REVOKED
  severity: INFORMATIONAL | NOTICE | WARNING | SECURITY | CRITICAL

  actor: AuditActorV1
  service: AuditServiceV1
  authorization: AuditAuthorizationV1
  purpose: AuditPurposeV1
  target: AuditTargetV1
  change: AuditChangeV1?
  result: AuditResultV1
  correlation: AuditCorrelationV1
  time: AuditTimeV1
  privacy_profile_id: closed identifier

  canonical_profile_id: closed identifier
  schema_digest: SHA-256
  previous_event_hash: SHA-256 | ZERO_GENESIS
  event_hash: SHA-256
}
```

### 5.3.2 Actor

```text
AuditActorV1 {
  actor_type: HUMAN_PRINCIPAL | SERVICE_PRINCIPAL | ENDPOINT_INSTALLATION | SYSTEM_TIMER
  principal_id: UUIDv7?                 # opaque UAM/IAM identifier; no display name
  credential_id: UUIDv7?                # opaque; not certificate/token contents
  authentication_context_id: UUIDv7?
  session_id: UUIDv7?
  assurance_class: closed enum
  delegated_by_principal_id: UUIDv7?
  break_glass_session_id: UUIDv7?
}
```

Rules:

- `principal_id` is authenticated-context authority, not a payload claim.
- Display name, email, username, SID, IP address, user agent, certificate subject, raw token, and group list are absent from the normal event body.
- If incident evidence requires network or device evidence, it uses a separately approved security-evidence contract and retention class, linked by opaque evidence ID.

### 5.3.3 Service and release

```text
AuditServiceV1 {
  service_id: closed identifier
  service_instance_class: closed enum
  product_release_id: UUIDv7
  executable_manifest_digest: SHA-256
  contract_catalogue_digest: SHA-256
}
```

Per-instance host names, pod names, database names, and addresses are excluded from the durable business event. They MAY exist in a separate short-lived operations evidence record.

### 5.3.4 Authorization and capability

```text
AuditAuthorizationV1 {
  decision: ALLOW | DENY
  capability_id: closed identifier
  authorization_policy_id: UUIDv7
  authorization_policy_revision: uint64
  decision_digest: SHA-256
  approval_workflow_id: UUIDv7?
  approval_revision: uint64?
  approval_count: bounded uint16?
  separation_of_duties_result: SATISFIED | NOT_REQUIRED | FAILED
}
```

The `decision_digest` commits to canonical, minimized decision inputs and result; it is not a substitute for the typed fields or a hash of raw personal data.

### 5.3.5 Purpose

```text
AuditPurposeV1 {
  purpose_code: closed release-owned identifier
  purpose_revision: uint64
  case_alias: UUIDv7?                  # case-scoped opaque alias
  justification_code: closed enum?
}
```

Free-form justification text is prohibited. A separately governed case record MAY hold approved correspondence and follows its own access/retention rules.

### 5.3.6 Target and scope

```text
AuditTargetV1 {
  target_type: closed enum
  target_id: UUIDv7?                   # opaque same-realm ID where needed
  target_revision_before: uint64?
  target_revision_after: uint64?
  target_scope_digest: SHA-256?
  target_count_bucket: ZERO | ONE | TWO_TO_TEN | ELEVEN_TO_HUNDRED | OVER_HUNDRED | UNKNOWN
  subject_data_class: NONE | OPAQUE_SUBJECT_LINK | SECURITY_EVIDENCE | RESTRICTED_CASE
}
```

Rules:

- Raw query, selector, SQL, URL, file path, host, application name, user name, or list of subject IDs is prohibited.
- `target_scope_digest` is generated only from a high-entropy canonical manifest or keyed purpose-separated token. It MUST NOT be an ordinary hash of a low-entropy value.
- A bulk action records a content-addressed manifest ID/digest and bucketed count, not every item in one event. Item-level effects remain in typed business tables where required.

### 5.3.7 Change summary

```text
AuditChangeV1 {
  change_profile_id: closed identifier
  changed_fields: [AuditFieldChangeV1]      # bounded and sorted by field_id
}

AuditFieldChangeV1 {
  field_id: closed identifier
  change_kind: ADDED | REMOVED | REPLACED | ENABLED | DISABLED | INCREASED | DECREASED
  old_value_class: closed enum or bounded scalar?
  new_value_class: closed enum or bounded scalar?
  old_content_digest: SHA-256?
  new_content_digest: SHA-256?
}
```

Only fields explicitly admitted in the event type's `change_profile_id` may appear. Secrets, credential material, arbitrary strings, URLs, selectors, SQL, raw policies, and activity payloads MUST NOT appear. For a large policy/rule document, the event records approved revision IDs, semantic summary enums, and canonical content digests.

### 5.3.8 Result and errors

```text
AuditResultV1 {
  safe_result_code: closed enum
  safe_error_code: closed enum?
  retry_class: NEVER | SAFE_SAME_COMMAND | AFTER_AUTHORITY_CHANGE | OPERATOR_REVIEW
  affected_count_bucket: closed bucket
  evidence_id: UUIDv7?
}
```

Dynamic exception messages, stack traces, SQLSTATE/database messages, HTTP response bodies, file paths, or remote addresses are prohibited. Those belong only in privacy-safe operational diagnostics under the accepted diagnostics contract.

### 5.3.9 Correlation

```text
AuditCorrelationV1 {
  command_id: UUIDv7
  request_id: UUIDv7?
  workflow_id: UUIDv7?
  parent_event_id: UUIDv7?
  approval_id: UUIDv7?
  export_id: UUIDv7?
  deletion_case_id: UUIDv7?
  restore_run_id: UUIDv7?
  operation_token: UUIDv7?
}
```

`command_id` is the stable idempotency identity for a privileged command. It is unique per realm and command family. A response retry reuses it.

### 5.3.10 Time

```text
AuditTimeV1 {
  occurred_at_utc: RFC3339-UTC
  recorded_at_utc: RFC3339-UTC
  database_commit_time_utc: RFC3339-UTC?
  time_quality: TRUSTED | DEGRADED | UNCERTAIN
  ordering_source: STREAM_SEQUENCE
}
```

Time is evidence, not sequence authority. Unknown or uncertain time cannot be silently presented as exact. The stream sequence and transaction commit establish order within a stream.

### 5.3.11 Hash input

The canonical event hash is:

```text
canonical_event_core = canonical_cbor_or_jcs_bytes(
  event excluding previous_event_hash and event_hash
)

event_hash = SHA-256(
  ASCII("UAM-AUDIT-EVENT-V1\0")
  || previous_event_hash
  || uint64_be(length(canonical_event_core))
  || canonical_event_core
)
```

**RECOMMENDATION.** Reuse the suite's signed-control canonicalization decision once accepted. JCS provides one reviewed deterministic JSON profile, including duplicate-member rejection and preservation of parsed string code points, but remains an Informational RFC and must pass UAM semantic vectors [S05]. Until that ADR closes, the audit hash profile remains a blocking codec experiment. Whichever profile is selected MUST have independent vectors, no duplicate members, field-specific Unicode semantics, deterministic integer handling, explicit null/absence semantics, and no remote references.

`previous_event_hash` links to the prior committed event in the same `(audit_scope_id, stream_id, stream_epoch)`. The canonical event derives `realm_scope` and `realm_id` from the registered `audit_scope`; it never trusts a caller-supplied realm field. Genesis uses a defined all-zero value plus a stream-creation event. Hash algorithm changes start a new epoch linked by a signed migration checkpoint; existing history is never recanonicalized.

## 5.4 Relational logical schema

Physical types, partitioning, indexes, RLS, ledger features, and generated columns are engine-specific candidates. The keys, immutability, transaction semantics, and realm boundaries below are normative.

```sql
CREATE TABLE audit_scope (
    audit_scope_id              UUID          NOT NULL PRIMARY KEY,
    scope_class                 VARCHAR(24)   NOT NULL,
    realm_id                    UUID          NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    UNIQUE (realm_id),
    CHECK (
      (scope_class = 'REALM' AND realm_id IS NOT NULL AND audit_scope_id = realm_id)
      OR
      (scope_class = 'PRODUCT_GLOBAL' AND realm_id IS NULL)
    )
);

CREATE TABLE audit_stream (
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    stream_class                VARCHAR(32)   NOT NULL,
    stream_epoch                BIGINT        NOT NULL,
    next_sequence               BIGINT        NOT NULL,
    head_event_id               UUID          NULL,
    head_event_hash             BINARY_32     NULL,
    canonical_profile_id        VARCHAR(64)   NOT NULL,
    schema_profile_id           VARCHAR(64)   NOT NULL,
    state                       VARCHAR(32)   NOT NULL,
    state_version               BIGINT        NOT NULL,
    created_at_utc              TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (audit_scope_id, stream_id, stream_epoch),
    FOREIGN KEY (audit_scope_id)
      REFERENCES audit_scope(audit_scope_id),
    CHECK (next_sequence >= 1),
    CHECK (stream_class IN ('CONTROL','AUDIT_SYSTEM')),
    CHECK (state IN ('ACTIVE','SEALING','HOLD','CLOSED'))
);

CREATE TABLE audit_event (
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    stream_epoch                BIGINT        NOT NULL,
    stream_sequence             BIGINT        NOT NULL,
    event_id                    UUID          NOT NULL,
    event_family                VARCHAR(48)   NOT NULL,
    event_type                  VARCHAR(96)   NOT NULL,
    event_version               VARCHAR(32)   NOT NULL,
    outcome                     VARCHAR(24)   NOT NULL,
    severity                    VARCHAR(24)   NOT NULL,
    actor_type                  VARCHAR(32)   NOT NULL,
    actor_principal_id          UUID          NULL,
    actor_credential_id         UUID          NULL,
    auth_context_id             UUID          NULL,
    actor_session_id            UUID          NULL,
    assurance_class             VARCHAR(32)   NOT NULL,
    service_id                  VARCHAR(64)   NOT NULL,
    product_release_id          UUID          NOT NULL,
    executable_manifest_digest BINARY_32     NOT NULL,
    capability_id               VARCHAR(96)   NOT NULL,
    authz_policy_id             UUID          NOT NULL,
    authz_policy_revision       BIGINT        NOT NULL,
    authz_decision_digest       BINARY_32     NOT NULL,
    purpose_code                VARCHAR(96)   NOT NULL,
    purpose_revision            BIGINT        NOT NULL,
    target_type                 VARCHAR(64)   NOT NULL,
    target_id                   UUID          NULL,
    target_revision_before      BIGINT        NULL,
    target_revision_after       BIGINT        NULL,
    target_scope_digest         BINARY_32     NULL,
    target_count_bucket         VARCHAR(24)   NOT NULL,
    change_profile_id           VARCHAR(96)   NULL,
    safe_result_code            VARCHAR(64)   NOT NULL,
    safe_error_code             VARCHAR(64)   NULL,
    retry_class                 VARCHAR(32)   NOT NULL,
    command_id                  UUID          NOT NULL,
    request_id                  UUID          NULL,
    workflow_id                 UUID          NULL,
    parent_event_id             UUID          NULL,
    approval_id                 UUID          NULL,
    case_alias                  UUID          NULL,
    occurred_at_utc             TIMESTAMP_UTC NOT NULL,
    recorded_at_utc             TIMESTAMP_UTC NOT NULL,
    time_quality                VARCHAR(24)   NOT NULL,
    privacy_profile_id          VARCHAR(64)   NOT NULL,
    canonical_profile_id        VARCHAR(64)   NOT NULL,
    schema_digest               BINARY_32     NOT NULL,
    previous_event_hash         BINARY_32     NOT NULL,
    event_hash                  BINARY_32     NOT NULL,
    PRIMARY KEY (audit_scope_id, stream_id, stream_epoch, stream_sequence),
    UNIQUE (audit_scope_id, event_id),
    UNIQUE (audit_scope_id, command_id, event_type, outcome),
    UNIQUE (audit_scope_id, stream_id, stream_epoch, event_hash),
    FOREIGN KEY (audit_scope_id, stream_id, stream_epoch)
      REFERENCES audit_stream(audit_scope_id, stream_id, stream_epoch),
    CHECK (stream_sequence > 0)
);

CREATE TABLE audit_field_change (
    audit_scope_id              UUID          NOT NULL,
    event_id                    UUID          NOT NULL,
    ordinal                     SMALLINT      NOT NULL,
    field_id                    VARCHAR(96)   NOT NULL,
    change_kind                 VARCHAR(24)   NOT NULL,
    old_value_class             VARCHAR(96)   NULL,
    new_value_class             VARCHAR(96)   NULL,
    old_content_digest          BINARY_32     NULL,
    new_content_digest          BINARY_32     NULL,
    PRIMARY KEY (audit_scope_id, event_id, ordinal),
    UNIQUE (audit_scope_id, event_id, field_id),
    FOREIGN KEY (audit_scope_id, event_id)
      REFERENCES audit_event(audit_scope_id, event_id)
);

CREATE TABLE audit_segment (
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    stream_epoch                BIGINT        NOT NULL,
    segment_sequence            BIGINT        NOT NULL,
    first_event_sequence        BIGINT        NOT NULL,
    last_event_sequence         BIGINT        NOT NULL,
    first_event_hash            BINARY_32     NOT NULL,
    last_event_hash             BINARY_32     NOT NULL,
    event_count                 BIGINT        NOT NULL,
    merkle_profile_id           VARCHAR(64)   NOT NULL,
    merkle_root                 BINARY_32     NOT NULL,
    previous_segment_root       BINARY_32     NULL,
    segment_manifest_digest     BINARY_32     NOT NULL,
    state                       VARCHAR(24)   NOT NULL,
    sealed_at_utc               TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (audit_scope_id, stream_id, stream_epoch, segment_sequence),
    UNIQUE (audit_scope_id, segment_manifest_digest),
    FOREIGN KEY (audit_scope_id, stream_id, stream_epoch)
      REFERENCES audit_stream(audit_scope_id, stream_id, stream_epoch),
    CHECK (last_event_sequence >= first_event_sequence),
    CHECK (event_count = last_event_sequence - first_event_sequence + 1),
    CHECK (state IN ('SEALED','CHECKPOINTED','PRUNE_ELIGIBLE','PRUNED','HOLD'))
);

CREATE TABLE audit_checkpoint_work (
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    stream_epoch                BIGINT        NOT NULL,
    segment_sequence            BIGINT        NOT NULL,
    state                       VARCHAR(32)   NOT NULL,
    attempt_count               BIGINT        NOT NULL,
    lease_token                 UUID          NULL,
    lease_fence                 BIGINT        NOT NULL,
    lease_expires_at_utc        TIMESTAMP_UTC NULL,
    next_attempt_at_utc         TIMESTAMP_UTC NULL,
    last_safe_error_code        VARCHAR(64)   NULL,
    PRIMARY KEY (audit_scope_id, stream_id, stream_epoch, segment_sequence),
    FOREIGN KEY (audit_scope_id, stream_id, stream_epoch, segment_sequence)
      REFERENCES audit_segment(audit_scope_id, stream_id, stream_epoch, segment_sequence)
);

CREATE TABLE audit_checkpoint_observation (
    checkpoint_observation_id   UUID          NOT NULL PRIMARY KEY,
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    stream_epoch                BIGINT        NOT NULL,
    segment_sequence            BIGINT        NOT NULL,
    segment_manifest_digest     BINARY_32     NOT NULL,
    merkle_root                 BINARY_32     NOT NULL,
    checkpoint_profile_id       VARCHAR(64)   NOT NULL,
    checkpoint_id               UUID          NOT NULL,
    verifier_key_id             UUID          NOT NULL,
    verifier_signature          BINARY_LARGE  NOT NULL,
    witness_policy_id           VARCHAR(96)   NULL,
    witness_signature_digest    BINARY_32     NULL,
    external_location_class     VARCHAR(48)   NOT NULL,
    external_receipt_digest     BINARY_32     NOT NULL,
    observed_at_utc             TIMESTAMP_UTC NOT NULL,
    verification_state          VARCHAR(24)   NOT NULL,
    UNIQUE (checkpoint_id),
    UNIQUE (audit_scope_id, stream_id, stream_epoch, segment_sequence, verifier_key_id),
    FOREIGN KEY (audit_scope_id, stream_id, stream_epoch, segment_sequence)
      REFERENCES audit_segment(audit_scope_id, stream_id, stream_epoch, segment_sequence)
);

CREATE TABLE audit_verification_run (
    verification_run_id         UUID          NOT NULL PRIMARY KEY,
    verification_profile_id     VARCHAR(96)   NOT NULL,
    environment_id              UUID          NOT NULL,
    source_checkpoint_id        UUID          NULL,
    start_scope_digest          BINARY_32     NOT NULL,
    state                       VARCHAR(32)   NOT NULL,
    first_bad_scope_id          UUID          NULL,
    first_bad_stream_id         UUID          NULL,
    first_bad_sequence          BIGINT        NULL,
    failure_class               VARCHAR(64)   NULL,
    expected_digest             BINARY_32     NULL,
    observed_digest             BINARY_32     NULL,
    evidence_digest             BINARY_32     NULL,
    started_at_utc              TIMESTAMP_UTC NOT NULL,
    completed_at_utc            TIMESTAMP_UTC NULL,
    CHECK (state IN ('RUNNING','PASSED','FAILED','INCONCLUSIVE','CANCELLED'))
);

CREATE TABLE audit_gap_declaration (
    gap_id                      UUID          NOT NULL PRIMARY KEY,
    audit_scope_id              UUID          NOT NULL,
    stream_id                   UUID          NOT NULL,
    prior_stream_epoch          BIGINT        NOT NULL,
    last_verified_sequence      BIGINT        NOT NULL,
    last_verified_event_hash    BINARY_32     NOT NULL,
    new_stream_epoch            BIGINT        NOT NULL,
    reason_code                 VARCHAR(64)   NOT NULL,
    incident_reference          UUID          NOT NULL,
    approved_by_principal_id    UUID          NOT NULL,
    verifier_evidence_digest    BINARY_32     NOT NULL,
    declared_at_utc             TIMESTAMP_UTC NOT NULL,
    UNIQUE (audit_scope_id, stream_id, new_stream_epoch),
    FOREIGN KEY (audit_scope_id)
      REFERENCES audit_scope(audit_scope_id)
);
```

### 5.4.1 Immutability and role rules

- `audit_event` and `audit_field_change` are insert-only for the application runtime. `UPDATE`, `DELETE`, `TRUNCATE`, and destructive DDL are denied to ordinary application and database administration roles.
- Only the audit writer stored procedure/module may lock/update `audit_stream.next_sequence` and insert an event. It resolves the authenticated realm/global authority to `audit_scope_id` and verifies the canonical event scope against `audit_scope`.
- The audit writer validates event type/profile, canonical bytes, previous hash, sequence, realm, command identity, and field allowlist inside the transaction.
- Segment sealing reads only committed contiguous events. A segment never crosses a stream epoch.
- Checkpoint workers cannot mutate events or segment roots; they append observations and external receipts.
- Verifier credentials have no business-mutation or audit-write permission.
- Ordinary portal administrators cannot prune, clear holds, rotate verifier keys, alter retention, declare gaps, or enable reads after restore.
- Direct database break-glass roles are separately controlled and every invocation is expected to be detected by native database audit and subsequent chain verification; they do not receive an application bypass.

## 5.5 Mutation command interface

### 5.5.1 Example strict command

```json
{
  "contract": "uam.control.policy-activation-command",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000002101",
  "policyId": "019d0000-0000-7000-8000-000000002102",
  "candidateRevision": 12,
  "expectedActiveRevision": 11,
  "approvalId": "019d0000-0000-7000-8000-000000002103",
  "purposeCode": "POLICY_GOVERNANCE_CHANGE",
  "justificationCode": "APPROVED_CHANGE_WINDOW"
}
```

Realm and actor are absent from the body; authenticated server context supplies them. No policy content is in the command. The candidate revision must already be immutable and content-addressed.

### 5.5.2 Mutation result

```json
{
  "contract": "uam.control.policy-activation-result",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000002101",
  "outcome": "SUCCEEDED",
  "activeRevision": 12,
  "auditEventId": "019d0000-0000-7000-8000-000000002104",
  "stateVersion": 27
}
```

The success response is generated only after the transaction containing the policy activation, audit event, and stream-head update commits. Unknown response state is reconciled by `commandId`.

## 5.6 Audit checkpoint protocol

### 5.6.1 Checkpoint payload

```json
{
  "contract": "uam.audit.checkpoint",
  "version": "1.0.0",
  "checkpointId": "019d0000-0000-7000-8000-000000002201",
  "streamScope": "REALM",
  "streamId": "019d0000-0000-7000-8000-000000002202",
  "streamEpoch": 3,
  "segmentSequence": 44,
  "firstEventSequence": 43001,
  "lastEventSequence": 44000,
  "eventCount": 1000,
  "segmentManifestDigest": "sha-256:fictional-segment-manifest",
  "merkleRoot": "sha-256:fictional-merkle-root",
  "previousCheckpointDigest": "sha-256:fictional-prior-checkpoint",
  "canonicalProfileId": "UAM_AUDIT_CANONICAL_V1",
  "createdAtUtc": "2026-08-01T10:00:00Z",
  "verifierKeyId": "019d0000-0000-7000-8000-000000002203",
  "signatureProfileId": "PROVISIONAL_SIGNED_CONTROL_PROFILE"
}
```

The external verifier MUST:

1. authenticate the checkpoint producer and independently read committed audit data through a read-only verification role or immutable export;
2. verify contiguous sequence and previous hashes from the last trusted checkpoint;
3. recompute each event hash and the segment Merkle root;
4. verify the prior checkpoint link and stream/epoch state;
5. sign the canonical checkpoint with a purpose-separated key;
6. store the checkpoint in a location ordinary product and database administrators cannot modify or delete;
7. record a durable external receipt or witness cosignature;
8. append an observation back to UAM without making the external object dependent on the mutable UAM record.

A failed or unavailable external publication does not roll back already committed business mutations. Instead it creates a bounded unanchored tail and triggers the hold/incident state defined in section 6.

## 5.7 Verification report contract

```json
{
  "contract": "uam.audit.verification-report",
  "version": "1.0.0",
  "verificationRunId": "019d0000-0000-7000-8000-000000002301",
  "verificationProfileId": "FULL_CHAIN_AND_EXTERNAL_CHECKPOINT_V1",
  "scope": {
    "streamId": "019d0000-0000-7000-8000-000000002202",
    "streamEpoch": 3,
    "fromSequence": 43001,
    "throughSequence": 44000,
    "trustedCheckpointId": "019d0000-0000-7000-8000-000000002201"
  },
  "decision": "PASSED",
  "checks": {
    "sequenceContiguous": "PASS",
    "eventHashes": "PASS",
    "previousHashLinks": "PASS",
    "segmentMerkleRoot": "PASS",
    "externalSignature": "PASS",
    "checkpointContinuity": "PASS",
    "realmIsolation": "PASS",
    "schemaProfilesKnown": "PASS"
  },
  "evidenceDigest": "sha-256:fictional-verification-evidence",
  "completedAtUtc": "2026-08-01T10:05:00Z"
}
```

A report is append-only. `FAILED` reports include only finite failure class, first bad sequence, expected/observed digests, and evidence ID. They do not include event contents or raw database pages.

## 5.8 Audit search and access interfaces

### 5.8.1 Query request

```json
{
  "contract": "uam.audit.search-request",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000002401",
  "purposeCode": "SECURITY_INCIDENT_REVIEW",
  "caseAlias": "019d0000-0000-7000-8000-000000002402",
  "timeRange": {
    "fromUtc": "2026-08-01T00:00:00Z",
    "toUtcExclusive": "2026-08-02T00:00:00Z"
  },
  "eventFamilies": ["CONTROL_MUTATION", "BREAK_GLASS", "SECURITY_FAILURE"],
  "eventTypes": [],
  "actorPrincipalId": null,
  "targetType": null,
  "targetId": null,
  "outcomes": ["SUCCEEDED", "FAILED", "DENIED"],
  "verificationState": "ANY",
  "pageSize": 100,
  "continuationToken": null
}
```

The BFF derives realm from authorization context. The query grammar is closed; arbitrary SQL, text search, regex, raw JSON predicates, cross-realm wildcard, and free-form export fields are prohibited.

### 5.8.2 Query transaction/disclosure boundary

1. Validate actor, capability, purpose, case/approval, bounds, and exact realm.
2. Execute a bounded read in a database transaction or consistent snapshot.
3. Determine the result event range, count bucket, query-profile digest, and verification state without serializing result bytes to the caller.
4. Append `SENSITIVE_READ_COMPLETED` in the same database transaction where the engine and isolation permit; otherwise commit the read-audit event against a stable snapshot/version and revalidate before disclosure.
5. Commit.
6. Serialize and disclose only the fields allowed by the access profile.

A failure to write the read audit event returns no result bytes. A client disconnect after commit is recorded as attempted/completed disclosure; an optional later `DOWNLOAD_CONFIRMED` event may record transport completion, but it does not erase the original read event.

### 5.8.3 Audit export manifest

```text
AuditExportManifestV1 {
  export_id
  realm_id (authority outside untrusted body)
  request_event_id
  approval_workflow_id
  query_profile_digest
  result_stream_ranges[]
  event_count
  canonical_export_digest
  encryption_profile_id
  wrapped_recipient_key_reference
  built_at
  expires_at
  state
}
```

Exports are encrypted before durable object storage, have an independent object manifest and lifecycle, and require `EXPORT_RELEASED` before any download token is issued. A retrieved external copy is recorded as an uncontrolled recipient-copy class and cannot be technically recalled.

## 5.9 Error taxonomy

| Error family | Example safe codes | Mutation/read behavior | Audit behavior |
|---|---|---|---|
| `CONTRACT` | `AUDIT_CONTRACT_UNKNOWN`, `AUDIT_FIELD_FORBIDDEN`, `AUDIT_VALUE_OUT_OF_BOUNDS` | Reject before mutation/disclosure | Durable denial only when authenticated/security-significant and bounded |
| `AUTHENTICATION` | `AUTHN_REQUIRED`, `CREDENTIAL_INVALID`, `STEP_UP_REQUIRED` | No privileged action | Security event under bounded policy |
| `AUTHORIZATION_REALM` | `CAPABILITY_DENIED`, `REALM_MISMATCH`, `APPROVAL_MISSING`, `SOD_FAILED` | No mutation/disclosure | Durable denial; no existence leak |
| `AUDIT_DURABILITY` | `AUDIT_WRITE_FAILED`, `AUDIT_HEAD_CONFLICT`, `AUDIT_STORE_UNAVAILABLE`, `AUDIT_COMMIT_UNKNOWN` | Roll back or reconcile; no success response | Enter safe hold as applicable |
| `AUDIT_INTEGRITY` | `AUDIT_HASH_MISMATCH`, `AUDIT_SEQUENCE_GAP`, `AUDIT_DUPLICATE_SEQUENCE`, `AUDIT_FORK`, `CHECKPOINT_MISMATCH` | Stop affected privileged surfaces | Append failure to independent system/incident channel when possible |
| `CHECKPOINT` | `CHECKPOINT_PUBLISH_FAILED`, `CHECKPOINT_SIGNATURE_INVALID`, `CHECKPOINT_STALE`, `WITNESS_POLICY_FAILED` | Continue only within approved unanchored-tail policy; otherwise hold | Preserve retry with same checkpoint identity |
| `KEY` | `AUDIT_KEY_UNAVAILABLE`, `AUDIT_KEY_REVOKED`, `AUDIT_KEY_PURPOSE_MISMATCH` | Fail closed for signing/verification transition | Never fall back to another-purpose key |
| `RESOURCE` | `AUDIT_QUOTA_PRESSURE`, `AUDIT_SEGMENT_BACKLOG`, `AUDIT_EXPORT_TOO_LARGE` | Backpressure or deny high-cost operation; no audit drop | Finite health/alert; no dynamic labels |
| `RESTORE` | `RESTORE_CHECKPOINT_MISSING`, `RESTORE_AUDIT_DIVERGENCE`, `RESTORE_UNANCHORED_TAIL`, `RESTORE_READ_BLOCKED` | No ordinary read/egress/receipt authority | Append to isolated restore evidence |
| `UNKNOWN` | `AUDIT_UNKNOWN_FAILURE` | Fail closed | Preserve minimal failure capsule; classification blocks gate |

## 5.10 API and storage security review checklist

Every audit-producing code review MUST answer yes to all applicable checks:

- Is the command ID stable and uniqueness-enforced?
- Is actor/realm authority injected from authenticated context?
- Is the capability and purpose closed and authorized?
- Is every success path inside one transaction with audit and stream-head update?
- Can any retry create a second success event or state effect?
- Is every field present in an approved event/change profile?
- Can any secret, URL, path, selector, SQL, arbitrary exception, or free-form string enter the event?
- Is sensitive output serialized only after read audit commit?
- Are direct database roles unable to mutate/delete audit rows in ordinary operation?
- Are hashes recomputed from canonical typed fields rather than trusted from input?
- Is external checkpoint publication idempotent with stable identity?
- Does unavailable verification produce a bounded, observable state rather than silent success?
- Are all feature flags monotonic narrowing/disable controls?
- Are tests present for omitted, duplicate, reordered, altered, cross-realm, and unavailable-sink cases?

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Privileged mutation state machine

```text
RECEIVED(command_id)
  -> CONTRACT_VALIDATED
  -> AUTHENTICATED_CONTEXT_BOUND
  -> AUTHORIZED(capability, purpose, realm, approval)
       -> DENIED
          -> AUDIT_ONLY_COMMIT_PENDING
          -> DENIAL_AUDITED
          -> SAFE_DENIAL_RESPONSE
       -> PRECONDITIONS_VALIDATED
          -> BUSINESS_AND_AUDIT_TRANSACTION_OPEN
             -> BUSINESS_STATE_STAGED
             -> AUDIT_EVENT_CANONICALIZED
             -> AUDIT_STREAM_HEAD_LOCKED
             -> SEQUENCE_ALLOCATED
             -> EVENT_HASH_COMPUTED
             -> BUSINESS_STATE_WRITTEN
             -> AUDIT_EVENT_WRITTEN
             -> STREAM_HEAD_ADVANCED
             -> COMMIT
                 -> COMMITTED
                 -> SUCCESS_RESPONSE
             -> ROLLBACK
                 -> NO_BUSINESS_EFFECT
                 -> FAILURE_AUDIT_ONLY_COMMIT (when safe and possible)
                 -> SAFE_FAILURE_RESPONSE

response lost after COMMITTED
  -> RETRY_SAME_COMMAND_ID
  -> READ COMMITTED COMMAND OUTCOME
  -> RETURN ORIGINAL RESULT AND AUDIT_EVENT_ID

commit outcome unknown
  -> RECONCILE_BY_COMMAND_ID
       -> FOUND_COMMITTED -> return original
       -> PROVED_NOT_COMMITTED -> retry same command
       -> INCONCLUSIVE -> AUDIT_COMMIT_UNKNOWN hold; no new command identity
```

### 6.1.1 Transaction invariant

For every successful privileged command `C`:

```text
CommittedBusinessEffect(C) = 1
AND CommittedTerminalSuccessAuditEvent(C) = 1
AND both have the same transaction outcome
```

No response, event-bus message, cache invalidation, integration call, or portal refresh is part of this atomicity claim. Those occur after commit using stable outbox/work identities.

### 6.1.2 Audit write failure behavior

- Failure before business write: roll back and return `AUDIT_WRITE_FAILED` or the more specific code.
- Failure after business write but before commit: the transaction rolls back both.
- Process/database failure after commit but before response: reconcile using `command_id`; do not repeat the mutation.
- Database reports an unknown outcome: the handler cannot claim success or initiate a new command; it enters reconciliation.
- Audit stream head conflict: bounded same-command retry is allowed after the transaction rolls back. A different command cannot skip the contended stream.
- Disk/quota failure: block the privileged action and activate the scoped audit safety hold. Do not switch to an unaudited fallback.

## 6.2 Sensitive-read and export state machine

### 6.2.1 Sensitive read

```text
READ_REQUESTED
  -> AUTHENTICATED_AND_AUTHORIZED
  -> BOUNDED_QUERY_PLAN_VALIDATED
  -> CONSISTENT_SNAPSHOT_ACQUIRED
  -> RESULT_SCOPE_AND_COUNT_DERIVED
  -> READ_AUDIT_COMMIT_PENDING
       -> COMMITTED
          -> SERIALIZE_ALLOWED_FIELDS
          -> DISCLOSE
          -> COMPLETED
       -> FAILED
          -> DISCARD_RESULT_BUFFER
          -> NO_DISCLOSURE
```

A transport disconnect after audit commit may mean the user received none, some, or all bytes. The durable event truth is “the system authorized and attempted this disclosure.” A separate download confirmation MAY refine transport state but cannot turn the initial event into “not read.”

### 6.2.2 Export

```text
REQUESTED
  -> APPROVAL_REQUIRED
       -> REJECTED / EXPIRED
       -> APPROVED
  -> BUILD_PENDING
  -> BUILDING_UNRELEASED
  -> BUILT_ENCRYPTED
  -> RELEASE_AUDIT_COMMIT_PENDING
       -> RELEASED
          -> DOWNLOAD_TOKEN_ISSUED
          -> DOWNLOADED | EXPIRED | REVOKED
          -> DELETED_WHEN_ELIGIBLE
       -> FAILED
          -> NO_TOKEN
```

The export object is never downloadable while `BUILDING_UNRELEASED`. A release audit failure leaves the object encrypted and inaccessible. An object-store success does not imply release.

## 6.3 Approval workflow state machine

```text
DRAFT
  -> SUBMITTED
  -> APPROVALS_PENDING
       -> APPROVAL_GRANTED(participant)
       -> APPROVAL_DENIED
       -> APPROVAL_WITHDRAWN
       -> APPROVAL_EXPIRED
  -> QUORUM_SATISFIED
       -> PRECONDITION_REVALIDATION
          -> EXECUTION_ELIGIBLE
          -> INVALIDATED
  -> EXECUTED | CANCELLED | EXPIRED
```

Rules:

- Every approval revision is immutable and audited.
- The executor MUST revalidate approver eligibility, separation of duties, target revision, purpose, time, realm, and policy immediately before mutation.
- An approval does not authorize a different target revision or broadened scope.
- If the actor is also an approver where separation is required, execution fails.
- Email, chat, ticket comment, or UI display is not approval authority unless imported through a governed typed approval contract.

## 6.4 Break-glass state machine

```text
INACTIVE
  -> REQUESTED
  -> STEP_UP_AND_REASON_CODE_VALIDATED
  -> ACTIVATED(expiry, capability subset, realm, case alias)
       -> ACTION_AUTHORIZED
       -> ACTION_AUDITED_WITH_BREAK_GLASS_SESSION
       -> ACTION_COMPLETED
       -> REPEAT_WITHIN_BOUNDS
  -> EXPIRED | REVOKED | ENDED
  -> REVIEW_PENDING
  -> REVIEWED
```

Normative constraints:

- Break-glass grants a finite release-owned capability subset, one realm or product-global emergency scope, a short expiry, and a byte/action/rate budget.
- It cannot grant cross-realm browse, arbitrary SQL, direct audit mutation, retention deletion, verifier-key use, or signing-key use.
- Activation fails if the audit ledger cannot commit. The safe emergency alternative is a product or realm kill switch that narrows/stops behavior, not an unaudited mutation.
- Every break-glass action includes the session ID and case alias; no free-form reason is stored in the event.
- Post-use review is a separate human workflow and does not erase or bless the technical evidence.

## 6.5 Segment sealing and checkpoint state machine

```text
ACTIVE_STREAM
  -> SEGMENT_THRESHOLD_REACHED
  -> SEALING
       -> VERIFY_CONTIGUOUS_RANGE
       -> RECOMPUTE_EVENT_HASHES
       -> BUILD_MERKLE_TREE
       -> INSERT_SEALED_SEGMENT
       -> ENQUEUE_CHECKPOINT_WORK
       -> ACTIVE_STREAM

CHECKPOINT_WORK_READY
  -> LEASED(fence)
  -> INDEPENDENT_VERIFICATION
       -> FAILED_INTEGRITY
          -> VERIFICATION_FAILED
          -> STREAM/REALM HOLD
       -> PASSED_LOCAL
          -> SIGNED_CHECKPOINT
          -> EXTERNAL_PUBLICATION
              -> RECEIPTED
                 -> CHECKPOINTED
              -> AMBIGUOUS
                 -> QUERY/RETRY SAME CHECKPOINT
              -> FAILED_TRANSIENT
                 -> RETRY_WAIT
              -> FAILED_SECURITY
                 -> VERIFIER HOLD
```

Segment size is **ESTIMATE/CLI EXPERIMENT**, not architecture. Sealing may be triggered by event count, canonical bytes, or time, but every segment is bounded and closes only on a committed event boundary.

## 6.6 Verification state machine

```text
NO_TRUSTED_CHECKPOINT
  -> GENESIS_BOOTSTRAP_PENDING
  -> GENESIS_TRUSTED (after approved ceremony)

GENESIS_TRUSTED / LAST_VERIFIED_CHECKPOINT
  -> DAILY_OR_TRIGGERED_RUN
  -> LOAD_TRUSTED_EXTERNAL_CHECKPOINT
  -> VERIFY_SIGNATURE_AND_KEY_STATE
  -> VERIFY_STREAM_EPOCH_AND_PRIOR_LINK
  -> VERIFY_SEQUENCES_AND_EVENT_HASHES
  -> VERIFY_SEGMENTS_AND_MERKLE_ROOTS
  -> VERIFY_NEW_CHECKPOINT_CONTINUITY
       -> PASSED
          -> ADVANCE_TRUSTED_CHECKPOINT
       -> FAILED
          -> VERIFICATION_FAILURE
          -> SCOPED_HOLD
       -> INCONCLUSIVE
          -> VERIFICATION_STALE/UNKNOWN
          -> HOLD WHEN APPROVED TOLERANCE EXPIRES
```

The verifier MUST preserve the first failure and exact source/checkpoint/evidence digests. A rerun does not replace a failed record. A passed rerun after remediation is a new report linked to the failure.

## 6.7 Verification gap, fork, and integrity-incident state machine

```text
INTEGRITY_EXPECTED
  -> GAP_OR_FORK_SIGNAL
  -> AFFECTED_SCOPE_FROZEN
  -> FIRST_FAILURE_EVIDENCE_PRESERVED
  -> INDEPENDENT_REVERIFICATION
       -> FALSE_POSITIVE
          -> HIGHER-REVISION CLEARANCE
          -> RESUME
       -> CONFIRMED_TAMPER_OR_LOSS
          -> INCIDENT_ACTIVE
          -> TRUSTED_CHECKPOINT_SELECTED
          -> RECOVERY_OPTION ASSESSED
              -> RESTORE_TO_VERIFIED_POINT
              -> RECONSTRUCT FROM INDEPENDENT EVIDENCE
              -> ACCEPT DECLARED GAP (human response decision)
          -> OLD_EPOCH_CLOSED
          -> GAP_DECLARATION_COMMITTED
          -> NEW_EPOCH_GENESIS LINKED TO LAST TRUSTED CHECKPOINT
          -> CONTROLLED RESUME
```

A gap declaration records what cannot be proven. It does not fabricate missing events. The response choice is a **HUMAN DECISION**; the conservative technical default is to hold affected privileged surfaces and ordinary audit disclosure.

## 6.8 Retention and pruning state machine

```text
SEALED_SEGMENT
  -> CHECKPOINTED
  -> RETENTION_CANDIDATE
  -> POLICY_AND_PURPOSE_EVALUATED
  -> LEGAL_HOLD_EVALUATED
  -> EXTERNAL_CHECKPOINT_AND_RESTORE_DEPENDENCIES_EVALUATED
       -> BLOCKED
       -> PRUNE_APPROVAL_REQUIRED
          -> APPROVED
          -> PRUNE_MANIFEST_COMMITTED_AND_AUDITED
          -> SEGMENT_PAYLOAD_DELETED
          -> ABSENCE_VERIFIED
          -> PRUNED_TOMBSTONE_RETAINED
```

Rules:

- Pruning occurs only at whole sealed-segment boundaries unless a future ADR proves a different cryptographic/lifecycle design.
- The retained tombstone includes stream/epoch/range, event count, Merkle root, segment manifest digest, checkpoint IDs, policy/authority reference, prune evidence digest, and time. It contains no event payload.
- Pruning cannot create a sequence gap: verification treats a correctly pruned range as an externally anchored summarized range.
- A segment is not eligible while required for a legal hold, incident, active appeal, restore dependency, regulatory/evidentiary rule, or unresolved verification failure.
- Exact periods and access are **HUMAN DECISION**.

## 6.9 Audit key lifecycle

```text
KEY_CANDIDATE
  -> PURPOSE/ALGORITHM/PROVIDER VERIFIED
  -> ACTIVE_SIGNING
  -> ROTATION_PENDING
       -> NEW_KEY_ACTIVE
       -> OLD_KEY_VERIFY_ONLY
  -> RETIRED_VERIFY_ONLY
  -> REVOKED
  -> DESTROYED_WHEN_ALL_RETENTION/RESTORE REQUIREMENTS EXPIRE
```

Keys are purpose-separated:

- event/hash chains do not require a secret key;
- verifier checkpoint signing key;
- optional witness key;
- audit export encryption/wrapping key;
- audit evidence/provenance signing key;
- database-native ledger/audit credentials;
- release/control/device keys.

One key MUST NOT serve two purposes. Rotation is itself audited and externally checkpointed. A key compromise does not authorize rewriting old checkpoints; incident handling records the affected validity interval and starts a higher-revision key state.

## 6.10 Restore verification and replay state machine

```text
RESTORE_REQUESTED
  -> ISOLATED_ENVIRONMENT_CREATED
  -> ORDINARY_READS_DISABLED
  -> EXPORT/CONNECTOR/RECEIPT AUTHORITY DISABLED
  -> BUSINESS_DATABASE_RESTORED
  -> AUDIT_SCHEMA_AND_ROLE VERIFICATION
  -> EXTERNAL TRUSTED CHECKPOINT LOADED
  -> AUDIT CHAIN/SEGMENT VERIFICATION TO RESTORED HEAD
       -> DIVERGENCE / ROLLBACK / GAP
          -> READ_BLOCKED / QUARANTINED
       -> MATCHED_TO_CHECKPOINT
          -> DETERMINE AUTHORITATIVE POST-BACKUP EVENTS
          -> REPLAY RECOVERABLE BUSINESS/AUDIT COMMANDS UNDER STABLE IDS
          -> VERIFY ONE EFFECT + ONE SUCCESS AUDIT EVENT
          -> REPLAY CURRENT TOMBSTONES/HOLDS
          -> REBUILD DERIVED AUDIT SEARCH INDEXES
          -> NEGATIVE/PROTECTED ACCESS PROBES
          -> READY_TECHNICAL
          -> SEPARATE AUDITED READ_ENABLEMENT_GRANTED
```

A restored database's local stream head is not trusted until it matches an independent checkpoint and all authoritative later commands are reconciled. Missing audit for an acknowledged business mutation blocks readiness.

## 6.11 Native database defense-in-depth lifecycle

### 6.11.1 SQL Server candidate

If SQL Server is selected, a prototype MAY configure:

- append-only or updatable Ledger tables for `audit_event`, stream/segment metadata, and selected privileged-state tables;
- automatic or manual external database digest storage in an account ordinary DB/product administrators cannot alter;
- SQL Server Audit for direct DDL/DML/role activity with `ON_FAILURE = FAIL_OPERATION` where the exact audited action set and availability impact pass testing;
- least-privilege roles that separate application mutation, audit writer, verifier read, DBA operations, and digest administration.

Ledger limitations—including no deletion of older append-only/history data and irreversible ledger-database choices—MUST be reconciled with approved audit retention before selection. Native digest verification is additive; the UAM event chain and external checkpoint remain the portable semantic evidence.

### 6.11.2 PostgreSQL candidate

If PostgreSQL is selected, a prototype MAY configure:

- append-only role/permission and trigger/policy guards for UAM tables;
- pgAudit for selected direct DDL, role, and privileged DML evidence;
- database/cluster log export to a separately protected target;
- event-trigger/configuration drift detection;
- physical/logical backup and restore checks that include audit data and roles.

pgAudit and PostgreSQL logs are supplemental. They do not replace the same-transaction application event. Exact extension-to-major compatibility, logging volume, transaction behavior, collector loss, role bypass, and failover behavior require CLI evidence.

## 6.12 Rollout plan

### Phase 0 — contracts and T1 oracle

- Implement taxonomy, schemas, canonical vectors, domain models, state machines, DDL, independent verifier model, tamper corpus, and architecture tests.
- Use only T1 fictional realms, actors, policies, reads, exports, deletion cases, and releases.
- No production or organization-derived activity or identity.

**Stop gate:** any event type requires free-form content, any mutation path cannot name its audit contract, or canonicalization is unresolved.

### Phase 1 — isolated transactional prototype

- Implement one fictional privileged mutation, one denial, one sensitive read, and one export release against PostgreSQL and SQL Server candidates.
- Inject audit write failure, disk pressure, deadlock, process death, response loss, and unknown commit.
- Implement chain verification and local sealed segments.

**Stop gate:** one successful mutation/read disclosure lacks a durable event or any retry creates duplicates.

### Phase 2 — external checkpoint prototype

- Implement independent verifier, purpose-separated lab key, stable checkpoint identity, WORM/object candidate, daily/triggered verification, and backup/restore comparison.
- Alter, delete, duplicate, reorder, fork, and roll back T1 events outside ordinary APIs.

**Stop gate:** any mandatory tamper mutation survives or verifier shares implementation decision code with the writer.

### Phase 3 — administrative surface coverage

- Inventory every privileged route, background command, CLI, scheduler, repair, integration, release, lifecycle, and support capability.
- Require compile-time/runtime registration linking each command to an event profile and capability.
- Add coverage mutation tests that remove one audit call/profile from each path.

**Stop gate:** unclassified privileged path, generic “admin action” event, direct SQL repair, or skip-audit flag.

### Phase 4 — engine-native defense-in-depth comparison

- Run SQL Server Ledger/Audit and PostgreSQL pgAudit candidates under the same direct-admin and restore corpus.
- Measure availability, storage/log volume, backup/restore, retention interaction, failover, operations, licensing, and support skill.

**Stop gate:** native feature weakens portability, accepted retention, restore, or application atomicity.

### Phase 5 — portal access and blind incident exercise

- Implement bounded search, verification status, export workflow, accessible failure presentation, separation of duties, and local encrypted T1 export.
- Conduct blind incident review using only minimized audit/search evidence.

**Stop gate:** operator requires raw activity or unrestricted DB access to solve the defined scenario, or a verification failure can be hidden/cleared by ordinary admin.

### Phase 6 — production-eligibility gate

Production-shaped activation remains disabled until:

- all mandatory CLI experiments pass for the exact release, database engine/topology, verifier, checkpoint store, key profile, and portal;
- audit retention/access and verification-failure response are approved by accountable humans;
- independent verifier ownership and support are assigned;
- regulatory/evidentiary requirements are recorded, including an explicit “no special evidentiary claim” if that is the decision;
- restore and deletion composition with Batch 04 passes;
- all owner/runbook, cost, licensing, privacy, accessibility, SLO/RPO/RTO, and incident gates are current.

## 6.13 Compatibility rules

1. Audit producer and consumer contracts follow consumer-first rollout and executable old/new matrices.
2. An active producer emits only event versions accepted by the current database schema, verifier, search BFF, export tool, and restore tooling.
3. Unknown event type, capability, purpose, target, field-change profile, canonical profile, hash algorithm, signature profile, or stream epoch fails closed; it is not ignored as forward-compatible.
4. Additive optional fields are permitted only when the exact event version and canonicalization rules define their absence and all consumers prove compatibility.
5. A change to hash/canonical semantics starts a new linked stream epoch. Existing events are never rehashed in place.
6. A schema migration must be expand/backfill/contract, preserve N/N-1 read/verification through rollback, and be crash-resumable. Destructive history migration is an enterprise maintenance event with independent backup/restore proof.
7. A verifier upgrade must verify both old and new profiles during the declared overlap and cannot discard the last working verifier until a new externally anchored checkpoint is accepted.
8. Retired event types remain decodable and verifiable through their retention period; retirement stops new production only.
9. Search/export fields are a view profile, not authorization to expose every persisted field.
10. Native SQL Server/PostgreSQL audit features may vary by engine, but the UAM business event contract and expected outcomes remain identical.
11. Exact dependency versions, database patches, cloud storage behavior, and cryptographic algorithms are execution-time evidence, not timeless architecture.

## 6.14 Feature flags and kill switches

Allowed flags are release-owned, finite, signed/authorized, and monotonic narrowing:

| Control | Allowed effect | Forbidden effect |
|---|---|---|
| `audit.privileged-surface.kill` | stop a named privileged capability | permit unaudited fallback |
| `audit.sensitive-read.kill` | stop named read/export profile | return data without read event |
| `audit.checkpoint.pause` | stop new checkpoint publication during controlled maintenance while staleness policy still applies | declare verification passed |
| `audit.verification.hold` | freeze affected realm/global privileged actions | clear a failure or alter evidence |
| `audit.export.kill` | stop export build/release/download | expose object directly |
| `audit.native-db-defense.disable-candidate` | remove optional SQL Server Ledger/Audit or pgAudit candidate after incident | disable application audit core |
| `audit.segment.seal-now` | trigger earlier segment closure | change existing event/segment content |
| `audit.break-glass.kill` | disable new emergency sessions | bypass active audit or realm controls |

There is no representable `skipAudit`, `ignoreVerification`, `forceSuccess`, `clearGap`, `crossRealm`, `disableHash`, or `adminDeleteHistory` flag.

---

# 7. Security/privacy threat and failure register

Owner names below are accountable functions, not assigned people. An unassigned blocking function keeps the associated capability disabled.

| ID | Trigger / threat | Detection | Containment | Recovery | Cleanup / evidence | Accountable function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T21-01 | Application code commits a privileged mutation without invoking the audit writer | command/effect reconciliation; architecture mutation; coverage registry | reject release; stop affected capability | add typed contract, repair code, rerun full mutation/failpoint corpus | preserve first failing command/effect/audit diff | Control API + Audit Architecture | E21-03, E21-15 | A common-mode defect may exist in both registry and implementation |
| T21-02 | Audit insert fails after business state is staged | transaction error/failpoint | transaction rollback; scoped audit hold | restore capacity/permission and retry same command ID | DB transaction trace, pre/post state, no-effect proof | Database Reliability | E21-04 | Storage may report ambiguous commit and require reconciliation |
| T21-03 | Response lost after successful mutation/audit commit | command ID found committed | no new command identity; return prior result | replay same response from durable state | attempt timeline and event/effect identities | Control API | E21-05 | Client may independently initiate a semantically duplicate command with new ID |
| T21-04 | DB commit outcome is unknown after connection/process loss | no response plus uncertain driver state | block command family/target until reconciliation | query exact command/effect/audit uniqueness; retry only if proved absent | first network/driver error and DB evidence | Control API + DB Reliability | E21-05 | Some catastrophic failures may leave evidence inconclusive until recovery |
| T21-05 | Concurrent commands race the same stream head | row/version conflict, uniqueness violation | rollback losing transaction; bounded retry | same-command retry under fresh head | conflict count and deterministic ordering evidence | Audit Store | E21-06 | Hot realms may create latency/availability pressure |
| T21-06 | One realm attempts to write/read another realm's audit stream | authenticated-context mismatch, realm-first key failure | deny without existence disclosure; security alert | investigate credential/context/cache path | finite realm-negative event and sanitized trace | IAM + Audit API | E21-07 | Compromised server identity boundary remains a high-impact threat |
| T21-07 | Ordinary portal admin tries to delete/update history or clear hold | authorization denial, DB role denial, native DB audit | deny; preserve history; possibly suspend principal | review grants and remove unauthorized role | effective-access evidence and denied command event | IAM + DB Security | E21-08 | A sufficiently privileged infrastructure administrator may bypass logical controls |
| T21-08 | DBA edits data files, disables constraints, or uses owner/superuser path | external checkpoint mismatch; native database audit/config drift | freeze affected realm/global privileged surfaces | restore to verified point or declare gap under incident authority | original files/snapshots remain restricted; share digests only | Security Incident + DB Reliability | E21-09, E21-12 | Collusion with external checkpoint administrator can defeat detection |
| T21-09 | Event row altered without changing head metadata | event hash/segment root mismatch | integrity hold | restore/reconstruct from trusted checkpoint and backups | first bad sequence and expected/observed digest | Independent Verifier | E21-09 | Unanchored tail may be altered before first checkpoint |
| T21-10 | Event and all later hashes are recomputed by privileged attacker | mismatch with protected external checkpoint/witness | integrity hold | select last trusted checkpoint; recover or declare gap | checkpoint receipts/signatures and fork evidence | Independent Verifier | E21-09 | If attacker controls both DB and verifier/anchor, detection can fail |
| T21-11 | Event deleted, duplicated, or reordered | sequence continuity, uniqueness, hash links, Merkle root | hold exact stream/epoch | recover from backup/evidence; no synthetic repair | tamper corpus ID and first bad sequence | Independent Verifier | E21-09 | A whole rollback to an older unanchored state needs external state to detect |
| T21-12 | Split view: different checkpoints shown to different verifiers | witness/checkpoint gossip or consistency-proof conflict | stop checkpoint trust and affected operations | investigate fork; choose approved recovery | preserve all conflicting signed checkpoints | Verifier Governance | E21-10 | Private single-verifier deployment has weaker split-view resistance |
| T21-13 | External checkpoint store unavailable | publish errors, stale-tail age/size metrics | bounded retry; hold when approved tolerance exceeded | restore external service or switch through approved higher-revision profile | stable checkpoint ID, attempts, no duplicate anchors | Verifier Operations | E21-11 | Fail-closed hold can cause administrative outage |
| T21-14 | External store returns success but object is absent/changed | read-after-write receipt verification; scheduled retrieval | mark ambiguous/failed; do not advance trusted checkpoint | retry/query same checkpoint; incident on conflict | object version/receipt digest and retrieval proof | Verifier Operations | E21-11 | Provider/systemic failure can affect object and evidence simultaneously |
| T21-15 | Verifier signing key unavailable | key-provider result and signer health | no unsigned checkpoint; staleness policy applies | restore key service or execute approved rotation/recovery | key state and failed checkpoint identity | Cryptographic Authority | E21-13 | Availability depends on chosen key service and recovery design |
| T21-16 | Verifier key compromised or wrong-purpose key used | signature/key-purpose verification; key-state feed | revoke key, freeze affected interval/checkpoints | reverify from last pre-compromise trust point and issue higher-revision key state | signed key incident record; no old checkpoint rewrite | Cryptographic Authority + Security | E21-13 | Past forged checkpoints may be hard to distinguish without witnesses/timestamps |
| T21-17 | Clock rollback or uncertainty affects ordering/expiry | clock-confidence state and monotonic checks | use sequence for order; stop expiry-sensitive actions | restore clock confidence and re-evaluate candidates | time-quality events and bounded evidence | Platform/SRE | E21-14 | Absolute event time may remain uncertain even when order is known |
| T21-18 | Free-form field or exception leaks subject data/secret into audit | compile analyzer, schema rejection, canary scan | reject event/transaction; privacy hold if sink already written | remove code path; governed deletion only under approved audit/lifecycle model | canary evidence and impacted segment/checkpoint IDs | Privacy Engineering + AppSec | E21-15 | Opaque values can still become personal data through linkage |
| T21-19 | Log injection/control characters corrupt display or export | strict scalar validation and output encoding tests | reject input; render encoded text only | patch parser/UI; regenerate safe view, not history | hostile corpus and accessibility evidence | Portal Security | E21-16 | A downstream tool may reinterpret exported values incorrectly |
| T21-20 | Raw selector/query/URL is hashed and stored as “safe” | field-profile analyzer and derivative canaries | reject transaction or event | remove field; assess whether stored digest is personal data | mutation test and data-impact manifest | Privacy Engineering | E21-15 | High-entropy scope manifests may still reveal sensitive association to authorized viewers |
| T21-21 | Audit event cardinality/volume causes denial of service | queue/store/lock/segment metrics; rate-class alerts | backpressure privileged surfaces; aggregate bounded unauthenticated noise | scale/tune within approved profile; change event policy through ADR | offered/accepted/dropped-by-policy counts | SRE + Audit Owner | E21-17 | Attackers may intentionally trade availability for forced fail-closed behavior |
| T21-22 | Anonymous authentication spray creates unbounded durable events | pre-auth rate/aggregation thresholds | aggregate and sample under fixed policy; preserve security signal | adjust release-owned thresholds after attack review | raw packets excluded; finite aggregate evidence | IAM Security | E21-17 | Aggregation may reduce individual attempt detail |
| T21-23 | Sensitive read result is disclosed before audit commit | instrumentation at serialization/write boundary | abort response and discard buffer | fix boundary and rerun; incident if real data escaped | zero-byte-before-commit trace | Audit API + Portal | E21-18 | OS/proxy buffers are difficult to reason about without exact integration test |
| T21-24 | Audit read/export fails after audit commit but before full delivery | transport state/optional confirmation event | no false “not attempted” claim; object/token lifecycle remains bounded | retry download under same export identity if permitted | delivery attempt timeline | Portal/Export Owner | E21-18 | Cannot prove exactly what a remote client retained |
| T21-25 | Export object is downloadable before approval/release audit | object ACL/token negative test and lifecycle state | revoke token/object; export kill switch | rebuild after correction and approval | access logs, manifest, deletion evidence | Export Owner + Security | E21-19 | Cloud-provider or account compromise can bypass application token policy |
| T21-26 | Break-glass session bypasses audit or over-broadens capability | contract/authorization checks; event linkage; action budget | revoke session; break-glass kill switch | incident review; new constrained profile | complete action/event set and expiry evidence | Security IAM | E21-20 | Emergency pressure can cause human misuse of a legitimately authorized capability |
| T21-27 | Approval is stale, self-approved, or applied to changed target | pre-execution revision/SOD revalidation | deny and invalidate workflow | request fresh approvals | approval graph and target digests | Governance Workflow | E21-21 | Colluding approvers remain a governance risk |
| T21-28 | Direct DB change bypasses application audit | SQL Server Audit/pgAudit candidate, reconciliation, chain divergence, state digest mismatch | freeze affected module/realm | restore/correct via typed audited operation; do not hand-edit silently | native audit and business/audit diff | DB Security + Module Owner | E21-08, E21-22 | Supplemental native logs may themselves be disabled or lost |
| T21-29 | Database-native audit target unavailable | engine-specific health/failure mode | if selected, `FAIL_OPERATION` or equivalent scoped stop; application core still fails closed | repair target/configuration | native target evidence and UAM audit state | DB Security | E21-22 | PostgreSQL supplemental logging may not provide equivalent synchronous failure semantics |
| T21-30 | Segment sealing omits an event or includes noncontiguous range | independent range query and count/hash verification | do not publish checkpoint; segment hold | rebuild segment from immutable events under same identity if no checkpoint existed; otherwise incident | seal plan and recomputed tree | Audit Store + Verifier | E21-23 | Shared canonicalization defect can affect both sealer and verifier |
| T21-31 | Merkle implementation/proof bug | independent implementation/vector/mutation tests | reject checkpoint/profile | patch and reverify; new profile/epoch if semantics changed | minimal failing tree/proof vector | Cryptographic Engineering | E21-23 | Cryptographic code assurance is not mathematical proof of surrounding completeness |
| T21-32 | Audit search index/cache is stale and hides events | source/index watermark mismatch | mark view ineligible; query authoritative store or deny | rebuild under verified watermark | index state and result comparison | Audit Search Owner | E21-24 | Authoritative store queries may be costly during rebuild |
| T21-33 | Audit search/export crosses realm via cache or continuation token | realm-bound token MAC/context and negative tests | deny, revoke tokens, global audit-search kill | repair cache/token keying; incident assessment | token/correlation evidence, no subject data | Portal Security | E21-07, E21-24 | Compromised server authorization context remains outside this module's proof |
| T21-34 | Restore uses local head and rolls audit history backward | comparison with external trusted checkpoint | keep environment read/egress blocked | restore newer point or replay authoritative commands; declare gap if unresolved | checkpoint/receipt/restore digests | Restore Orchestrator + Verifier | E21-12 | Authoritative post-backup command source may be incomplete |
| T21-35 | Restore replays business mutation without matching audit or vice versa | one-effect/one-event reconciliation | readiness failure | replay stable command or recover missing evidence; no manual overwrite | command/effect/event set diff | Restore/Data Reliability | E21-12 | Catastrophic loss of all independent copies may be irrecoverable |
| T21-36 | Retention prune deletes uncheckpointed or held segment | eligibility predicate, checkpoint/hold manifest, failpoints | deny prune; lifecycle hold | restore segment from backup if deletion occurred; incident | prune command/audit/object deletion receipts | Records + Audit Store | E21-25 | Provider/versioned copies may remain after nominal deletion |
| T21-37 | Retention policy removes evidence needed for an active incident/legal hold | conjunctive hold/incident check | block target; `PARTIAL_HELD` | re-evaluate after authorized release | policy/hold revisions and target manifest | Records/Legal Technical Custodian | E21-25 | Human authority may make a legally incorrect decision |
| T21-38 | Event subject linkage prevents deletion/minimization obligations | schema/privacy profile review | prohibit raw linkage; restricted opaque mapping | expire/delete separate mapping when approved while preserving event shell | mapping lifecycle evidence | Privacy/Data Governance | E21-26 | Opaque IDs can still be identifying when joined by privileged actors |
| T21-39 | Verification alert is missed or ordinary admin clears it | external alert path, immutable incident state, SOD | scoped automatic hold; ordinary admin cannot clear | authorized incident clearance after independent pass | alert delivery and clearance workflow evidence | Security Operations | E21-27 | Alert fatigue or unavailable responders can prolong outage |
| T21-40 | Metrics labels expose actors/targets or grow unbounded | catalogue lint, runtime cardinality monitor, canaries | reject unknown label; disable metric family if unsafe | patch catalogue and backfill no sensitive values | series budget and sink scan | SRE + Privacy | E21-28 | Metric backend access/retention remains human-governed |
| T21-41 | Accessibility defect hides failure state from keyboard/screen-reader user | automated/manual WCAG/status-message tests | block portal release; preserve API failure state | fix UI and rerun assistive-technology workflow | screenshots/DOM/accessibility results using T1 data | Portal + Accessibility | E21-25 | Accessibility tooling cannot cover every assistive technology/user need |
| T21-42 | Checkpoint/witness or OSS dependency is compromised | lock/provenance/SBOM/advisory monitoring; behavior tests | pin/disable candidate; keep application ledger local | update or replace after admission; reverify all affected checkpoints | dependency/source/binary digests | Supply Chain Security | E21-00, E21-10, E21-21 | Authorized malicious upstream release may evade ordinary scanning |
| T21-43 | Independent verifier is not operationally independent | access review, role/credential/account topology audit | block production eligibility | assign separate function/account/key and run separation drill | effective access and incident exercise | Architecture Governance | E21-27 | Organizational collusion cannot be eliminated technically |
| T21-44 | Audit retention/access/regulatory decisions remain unapproved | decision register shows `UNASSIGNED/OPEN` | production privileged/audit portal capability disabled | obtain accountable decisions and encode revisions | signed decision references | Product Governance | HD-21-01..04 | Technical defaults cannot make a lawful or evidentiary decision |
| T21-45 | Verification failure response is improvised | missing approved response matrix | conservative scoped technical hold | incident authority selects approved recovery/acceptance path | decision/audit/runbook records | Incident/Risk Authority | E21-27 | Business pressure may seek unsafe manual bypass |
| T21-46 | Audit or checkpoint cleanup leaves test keys, objects, roles, or data | before/after inventory and deletion/revert receipt | gate failure; quarantine/revert lab | remove residue and rerun from clean environment | cleanup manifest and canary scan | Lab Operations | Every CLI experiment | No cleanup process proves absence from undiscovered provider backups |

## 7.1 Mandatory incident runbooks

Before the primary gate can pass, T1 exercises MUST exist for:

1. privileged mutation rejected because audit write is unavailable;
2. ambiguous commit after response loss;
3. ordinary administrator attempting audit deletion/DDL;
4. confirmed altered/deleted/reordered event;
5. conflicting external checkpoints or witness signatures;
6. checkpoint publication outage and staleness hold;
7. verifier-key compromise/rotation;
8. privacy canary in audit/search/export/backup/evidence;
9. sensitive-read audit failure with zero disclosed bytes;
10. break-glass misuse or expiry failure;
11. prune/hold conflict;
12. database restore behind the trusted checkpoint;
13. supplemental native audit target failure;
14. dependency/verifier supply-chain incident;
15. cleanup/residue failure.

Each runbook MUST identify: trigger, automatic containment, who can widen or clear the hold, evidence to preserve, forbidden shortcuts, recovery options, data/realm impact analysis, communication path, cleanup, re-verification, and exact re-enable gate.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test evidence rules

Every run MUST produce a content-addressed evidence directory containing:

```text
experiment.json                 # assertion, owner, start/end UTC, result
source-tree.json                # commit/tree, clean-state proof
contracts-and-schemas.json      # exact names, versions, digests
build-and-dependencies.json     # SDK, packages, native modules, tools, licenses
engine-and-topology.json        # engine/version/edition/topology/durability profile
fixture-manifest.json           # T1 package and independent-oracle digests
fault-plan.json                 # exact hook/fault schedule and seed
durable-before/                 # typed logical dump and hashes
durable-after/                  # typed logical dump and hashes
operation-history.ndjson        # finite commands/events/faults, fictional IDs
verification-report.json
all-sink-canary-report.json
resource-summary.json
first-failure.json              # preserved even if rerun later passes
cleanup-receipt.json
files.sha256
```

Evidence MUST NOT contain credentials, internal addresses, SSH material, real identities, raw activity, production values, arbitrary DB logs, or unredacted memory/process dumps. Destructive raw traces stay in the disposable lab and are deleted/reverted after sanitized evidence is accepted.

Durations below are **ESTIMATE** planning values, not SLOs or approval. The exact duration is recorded in each run.

## 8.2 Core test matrix

| ID | Setup and instrumentation | Steps / injected fault | Pass | Fail / stop | Evidence | Est. duration | Cleanup |
|---|---|---|---|---|---|---:|---|
| TM21-01 — contract strictness | Pure parser, official JSON/JCS or selected canonical vectors, UAM hostile corpus | Duplicate/wrong-case/unknown fields, null/absence, invalid UTF-8, depth/size, enum, remote ref, free-form detail | Exact acceptance matrix; no allocation/time escape; canonical bytes deterministic | Any permissive unknown/duplicate, remote fetch, parser differential, nondeterminism | vector results, allocations, canonical bytes, minimal reproducer | 20 min | remove generated corpus/cache; clean tree |
| TM21-02 — taxonomy coverage | Compile-time command/event registry and architecture analyzer | Remove registration/audit profile from each privileged route/handler/job; add generic admin path | Build/test fails for every mutation; no unclassified path | One privileged path remains executable without typed audit profile | command→capability→event coverage graph | 30 min | revert mutations and prove clean diff |
| TM21-03 — atomic success | T1 policy mutation in PostgreSQL and SQL Server candidate; transaction trace | Execute one command and retry response | One business revision, one terminal success event, one head advance; replay returns same event/result | Missing/duplicate effect/event, different retry ID, wrong sequence | before/after tables, transaction timeline | 10 min/engine | drop disposable DB; verify objects removed |
| TM21-04 — injected audit write failure | Same mutation; failpoint before audit insert, at insert, before head update, before commit | Trigger each fault | Zero business effect and zero success response; safe failure/hold | Business mutation commits or caller sees success | failpoint capsule for each boundary | 20 min/engine | remove failpoint build and DB |
| TM21-05 — response loss/unknown commit | Proxy/socket fault plus process kill after DB commit; command uniqueness | Lose response after commit; retry same command; separately inject unknown driver outcome before/after commit | Reconcile exact committed state; one effect/event; no new command | Duplicate effect/event or unsafe retry under inconclusive state | network timeline, DB truth, command reconciliation | 30 min/engine | stop proxy, delete test certs/routes |
| TM21-06 — stream concurrency | Multiple T1 principals/commands in one realm and several realms; barrier scheduler | Start simultaneous mutations; delay head locks; create deadlock/retry candidates | Per-stream contiguous unique order; each command one result; realms independent | Gap/duplicate/reorder, cross-realm blocking beyond design, infinite retry | schedule seed, lock/plan evidence, histories | 30 min/engine | terminate actors; clean DB |
| TM21-07 — realm isolation | Two fictional realms with colliding IDs, caches, continuation tokens | Submit/read/search/export with wrong body/header/token/DB session context | Zero cross-realm result/mutation; generic denial; durable realm-mismatch evidence | One cross-realm row or existence leak | negative matrix, query plans/session state | 20 min/engine | revoke tokens and remove realms |
| TM21-08 — ordinary-admin non-deletion | Product admin, module admin, ordinary DBA-like role; effective access tooling | Attempt update/delete/truncate/DDL/disable trigger/clear hold/prune | Every attempt denied or detected; product remains operable; no history change | Any ordinary role alters history or disables detection | grant graph, denied commands, native audit | 30 min/engine | revoke roles; compare before/after grants |
| TM21-09 — tamper corpus | Offline clone of DB/data files plus verifier and trusted checkpoint | Alter field, hash, sequence; delete, duplicate, reorder; recompute local chain; rollback whole DB | Every mandatory mutation detected with first bad scope; no false pass | One tamper survivor or unbounded verifier behavior | tamper ID→expected/actual matrix | 45 min/engine | destroy tampered clones and keys |
| TM21-10 — split view/witness | Lab log/checkpoint publisher, two verifiers, optional witness candidate | Serve conflicting checkpoints/consistency histories | Conflict detected; neither view silently becomes global truth | Both clients accept incompatible histories without signal | signed checkpoints, consistency/cosignature evidence | 30 min | delete lab log/witness DB and keys |
| TM21-11 — checkpoint outage/ambiguity | External object/WORM emulator or approved T1 provider; network/proxy faults | Fail before/after upload, lose response, change object/version, deny reads | Stable checkpoint ID; query/retry; staleness visible; hold at configured test threshold | Duplicate/conflicting checkpoint accepted, staleness hidden, silent advance | object manifests, receipt/readback timeline | 45 min | delete versions/containers; verify absence |
| TM21-12 — backup/restore verification | Actual DB backup, trusted checkpoint outside backup, later T1 commands | Restore older backup; verify; replay authoritative later commands; inject missing event/business effect | Older local head detected; readiness only after exact one-effect/one-event reconciliation | Restore marked ready with rollback, missing acknowledged mutation, or deleted data visible | backup IDs, trusted checkpoint, set diffs, readiness report | 60 min/engine | destroy isolated restore and backup copies |
| TM21-13 — key lifecycle | Lab KMS/HSM or local protected key candidate; exact signer/verifier | Rotate, revoke, wrong-purpose, unavailable key, restore with old verify key | New checkpoints use new key; old verify; wrong-purpose rejected; no unsigned fallback | Silent key fallback, unverifiable retained history, key residue | key state/signature vectors, provider properties | 40 min | destroy lab keys/trust entries and prove |
| TM21-14 — time uncertainty | Controllable test clock and DB time | Step backward/forward, mark uncertain, cross expiry boundaries | Sequence remains order; time quality explicit; expiry-sensitive actions fail safely | Timestamp used as chain order; stale authority silently accepted | clock history, event time/sequence comparison | 20 min | restore clock/config; destroy VM |
| TM21-15 — privacy/schema canaries | Exact canaries in forbidden URL/path/selector/secret/exception locations; all declared sinks | Execute success, denial, failure, crash, export, verification, evidence packaging | Zero forbidden marker/derivative outside fixture; positive controls all detected | One escape or scanner miss | sink/encoding matrix and redacted report | 30 min | delete fixtures/artifacts; revert lab |
| TM21-16 — injection/UI encoding | Hostile Unicode/control/CSV/formula/HTML strings in rejected inputs and safe enum labels | Search/render/export rejected and accepted records | No script/formula/control execution; output remains accessible and deterministic | Injection, corrupted export, or hidden status | browser/DOM/export tests, screenshots with fictional data | 25 min | delete downloads and browser profile |
| TM21-17 — volume/backpressure | Open-arrival audit command generator, resource metrics, segment/checkpoint workers | Increase privileged/read/auth-failure load; pause verifier; fill configured reserve | No successful unaudited action or silent event loss; bounded pressure/hold; generator load proven | Lost event, success without event, unbounded tail/resource, hidden generator drop | offered/started/committed/rejected counts, resource curves | 60 min/engine | stop load; drain/delete T1 DB; clean agents |
| TM21-18 — audit-before-disclose | Instrumented BFF/serializer/socket proxy and sensitive query fixture | Fail audit insert/commit; kill after commit; disconnect mid-response | Zero bytes before audit commit; failure discloses none; committed attempt remains audited | Any body byte before commit or unaudited disclosed result | byte timestamp trace, event/transaction timeline | 30 min | delete captures/client certs; clean DB |
| TM21-19 — export lifecycle | Encrypted object store, token issuer, approval workflow | Fail build, approval, release audit, token issuance; use stale/revoked token | Object inaccessible until release commit; no plaintext temp; expiry/revoke/delete work | Early download, plaintext residue, wrong-realm token, false delete | object ACL/version, token, audit timeline, residue scan | 45 min | delete object versions/keys/tokens |
| TM21-20 — break-glass | T1 emergency capability, step-up, short expiry, action budget | Activate, perform allowed/denied actions, audit sink failure, expire/revoke/restart | Every action linked/audited; forbidden scope denied; audit failure blocks activation/action; expiry survives restart | Any unaudited/emergency bypass or self-extension | session/action ledger, authz matrix | 35 min | revoke session, delete lab credentials |
| TM21-21 — approval/SOD | Fictional approvers with role changes and target revisions | Self-approve, stale approval, withdraw, change target after approval, quorum race | Execution only after current eligible quorum/SOD; every transition audited | Stale/self approval executes or approval state is mutable without event | approval graph and command results | 30 min | remove principals/workflows |
| TM21-22 — native DB audit comparison | SQL Server Audit/Ledger candidate; PostgreSQL pgAudit/log candidate | Direct DML/DDL/role attempts, target unavailable, failover/restore | Supplemental evidence captures configured direct activity; exact failure semantics documented; application audit unaffected | Native feature claimed as primary, loses activity silently contrary to profile, or blocks recovery unacceptably | native config/version/log/digest evidence | 60 min/profile | remove extensions/audits/storage and verify |
| TM21-23 — segment/Merkle verifier | Two independent implementations or languages; official/custom vectors | Empty/one/odd/even trees, omitted leaf, swapped leaves, proof mutation, segment boundary crash | Same roots/proofs for valid vectors; all mutations fail; segment inserted atomically | Root differential, omitted event, checkpoint before sealed commit | vector corpus, roots, proof results | 30 min | remove generated trees |
| TM21-24 — search/index watermark | Authoritative ledger plus disposable search index/cache | Delay/drop indexing; restore stale index; wrong continuation token | Stale view ineligible or clearly bounded; authoritative query exact; no hidden events | Portal reports complete while watermark stale or returns wrong realm | source/index counts and watermarks | 30 min | delete index/cache and tokens |
| TM21-25 — retention/prune/hold | Sealed/checkpointed T1 segments, hold/incident/restore dependencies, versioned object copies | Attempt premature prune, crash each step, release hold, delete segment/object/key | No prune until all predicates; retained tombstone verifies summarized range; object copies handled | Uncheckpointed/held evidence lost, sequence treated as unexplained gap, residue | prune work graph, receipts, verifier result | 60 min | delete all test copies/keys and restore baseline |
| TM21-26 — subject minimization | Events linked only by approved opaque IDs plus separate mapping | Delete/expire mapping, run search/export/verification/incident case | Event integrity remains; prohibited subject value absent; authorized shell usable | Raw subject embedded or chain breaks on mapping lifecycle | schema scan, canary, before/after access results | 30 min | remove mappings/events per T1 manifest |
| TM21-27 — alert and clearance | Independent alert sink, on-call simulator, immutable incident state | Cause verification failure/stale checkpoint; attempt ordinary-admin clear; delayed responder | Alert delivered; auto hold; only approved higher-revision clearance after independent pass | Silent failure, ordinary clear, or auto self-reenable | alert receipts, IAM/clearance audit | 30 min | remove alerts/incidents and lab accounts |
| TM21-28 — observability/cardinality | Closed metric catalogue and adversarial distinct IDs | Emit many realms/actors/targets/errors, unknown labels | Fixed bounded series formula; sensitive/dynamic labels rejected | Series grows with subjects or leaks identifiers/digests | theoretical/actual series report, sink scan | 25 min | delete metric namespace/data |
| TM21-29 — accessibility | Portal T1 fixture, keyboard, screen reader, automated tooling | Search, sort, paginate, failure, export approval, hold, verification status | Keyboard complete; programmatic status; text equivalents; no color/toast-only failure | Blocking WCAG/workflow defect or inaccessible security state | automated report and manual script/result | 45 min | delete fixture/account/browser state |
| TM21-30 — supply chain and verifier independence | Exact dependency locks, SBOM/provenance, separate verifier implementation | Substitute binary/package/commit; break checker; make writer and verifier share code | Substitution/checker mutation detected; verifier has independent canonical/hash implementation or independently reviewed comparator | Mutable input, unknown binary, common decision code erases defect | file manifest, SBOM/provenance, architecture graph | 40 min | remove substituted artifacts/caches |
| TM21-31 — organizational separation | Lab identities/accounts for product admin, DBA, verifier admin, key custodian, incident approver | Attempt cross-role operations and collusion subsets | Required separation enforced; verifier anchor cannot be altered by ordinary product/DB admin | One ordinary role controls mutation + history + checkpoint/clearance | effective access matrix and signed drill report | 30 min | delete lab accounts/keys/policies |

## 8.3 Smallest falsifying prototypes

### P21-01 — mutation-plus-audit atomicity

**Claim.** A privileged mutation cannot commit without exactly one durable typed success audit event and stream-head transition.

**Setup.** One fictional realm, one policy row, one audit stream, one command handler, one PostgreSQL candidate and one SQL Server candidate. Use a test-only fault controller excluded from release artifacts.

**Instrumentation.** Transaction hooks before business write, after business write, before audit insert, after audit insert, before head update, after head update, before commit, after commit/before response. Capture typed logical state after process restart.

**Steps.** Execute the same command under every hook action: return error, kill process, database connection loss, database restart, disk denial, and response loss.

**Pass.** For every run, durable state is either `(old business, no success event, old head)` or `(new business, one success event, advanced head)`. Retrying the same command returns the original result/event. No intermediate combination exists.

**Fail.** Any committed business state without its event/head, event without business effect for a claimed success, duplicate effect/event, or success response before commit.

**Evidence.** One failure capsule per hook/engine with command ID, state digests, transaction/driver outcome, and cleanup receipt.

**Duration.** **ESTIMATE:** 30–60 minutes per engine after harness setup.

**Cleanup.** Drop the disposable database; remove test hooks/controller; prove the production artifact lacks them; delete lab credentials and traces.

### P21-02 — altered, reordered, duplicated, and missing records

**Claim.** The verifier detects every required synthetic alteration and reports the first affected stream/sequence without trusting local head state.

**Setup.** Generate three sealed segments with a trusted external checkpoint. Clone the database offline.

**Instrumentation.** Independent canonical/hash/Merkle implementation; tamper corpus driver; protected checkpoint file/object.

**Steps.** For separate clones: flip a typed field, replace event hash, delete a middle/last event, duplicate sequence, swap events, change previous hash, alter segment root, recompute all later local hashes, roll back the whole database, and create two conflicting checkpoint views.

**Pass.** Every case is `FAILED` or `INCONCLUSIVE` as expected; none is `PASSED`. Whole-chain recomputation still fails against the trusted checkpoint. Split view is detected when witness/gossip profile is enabled.

**Fail.** Any mandatory mutation survives; verifier crashes/unbounds; or it accepts a checkpoint solely because it is locally stored.

**Evidence.** Tamper ID, exact expected failure class, first bad sequence, expected/observed digests, checkpoint signatures, and minimal reproducer.

**Duration.** **ESTIMATE:** 45 minutes per engine-independent fixture.

**Cleanup.** Destroy all tampered clones and lab keys; retain only sanitized digests/results.

### P21-03 — external digest after backup and restore

**Claim.** An older backup cannot be declared ready merely because its local audit chain is internally consistent.

**Setup.** Commit and externally checkpoint segment A; take backup; then commit/checkpoint segment B and record authoritative command/effect/event set. Restore the old backup into an isolated environment.

**Instrumentation.** Restore network/role guard, external checkpoint reader, command-set reconciler, event/effect oracle.

**Steps.** Verify the restored local head against latest trusted checkpoint; attempt ordinary read enablement; replay recoverable commands under the original IDs; rerun verification and positive/negative probes.

**Pass.** Initial restore is blocked as rolled back. After exact stable-ID replay, each business effect and success event exists once, chain/checkpoint continuity passes, and only then can technical readiness be recorded. Read enablement remains a separate audited action.

**Fail.** Old restore marked ready; missing acknowledged command; duplicate effect/event; or read/export/connector/receipt authority active during reconciliation.

**Evidence.** Backup ID, latest checkpoint, before/after command/effect/event set digests, readiness decision, and cleanup.

**Duration.** **ESTIMATE:** 60–90 minutes per engine/topology.

**Cleanup.** Destroy restored environment, temporary backups, keys, routes, and test principals; verify provider object versions as applicable.

### P21-04 — audit before sensitive disclosure

**Claim.** No sensitive audit-query/export bytes leave the server before the read/release audit event commits.

**Setup.** Fictional audit records, instrumented BFF serializer/socket, strict search profile, failing audit writer.

**Steps.** Fail before event insert, before commit, after commit/before first byte, and mid-response. Repeat for search and export release.

**Pass.** Pre-commit failures disclose zero bytes. Post-commit response loss leaves a durable attempted/completed disclosure event. Export object remains inaccessible until release commit.

**Fail.** Any result or token before commit, or failure path that logs/exports the query/subject selector.

**Evidence.** Byte-boundary timestamps, DB commit evidence, event ID, object/token state, canary report.

**Duration.** **ESTIMATE:** 30 minutes.

**Cleanup.** Delete captures, exports, tokens, fixture data, and browser/client state.

### P21-05 — ordinary administrator cannot alter history undetected

**Claim.** Product administrators and normal database operators cannot change or delete audit history, disable verification, or clear holds; higher infrastructure compromise is detected after checkpoint.

**Setup.** Effective-access matrix with fictional product admin, module admin, ordinary DBA, backup operator, verifier operator, and key custodian.

**Steps.** Attempt API delete, SQL update/delete/truncate, trigger/constraint disable, role grant, checkpoint object delete, verifier-key use, hold clearance, offline data-file edit, and restored-backup rollback.

**Pass.** Ordinary operations are denied and audited. Offline/higher-privilege changes produce checkpoint verification failure. No single ordinary role controls business mutation, audit history, external checkpoint, and failure clearance.

**Fail.** Any ordinary role can alter history without denial/detection or can clear the resulting failure alone.

**Evidence.** Effective permissions, commands/results, native audit, external verification, and role-separation graph.

**Duration.** **ESTIMATE:** 45 minutes per engine/topology.

**Cleanup.** Revoke all lab grants/keys/accounts; destroy tampered DB/object versions; compare access baseline.

### P21-06 — unavailable audit and checkpoint sinks

**Claim.** Primary audit unavailability blocks privileged success, while external checkpoint unavailability creates a bounded visible tail and then a scoped hold rather than corrupting transaction truth.

**Setup.** Separate primary relational store and external checkpoint store with independent fault controls.

**Steps.** Disable audit table/index permission/storage; separately disable checkpoint network/credentials/object target; continue fictional commands through test thresholds.

**Pass.** Primary audit failure yields zero successful mutations/reads. Checkpoint outage leaves correctly audited local commands but visible pending checkpoint work; same checkpoint identity retries; hold activates at the test policy bound.

**Fail.** Unaudited privileged success, silent checkpoint loss, duplicate/conflicting checkpoint, or permanent self-reenable.

**Evidence.** Command results, local chain, checkpoint attempt ledger, staleness/hold timeline.

**Duration.** **ESTIMATE:** 30 minutes.

**Cleanup.** Restore permissions/network; publish/reconcile same checkpoint; delete test objects and fault rules.

### P21-07 — prune, hold, and verification continuity

**Claim.** Whole-segment pruning cannot remove held or uncheckpointed evidence and leaves a verifiable summarized chain.

**Setup.** Three segments: one uncheckpointed, one checkpointed/held, one checkpointed/eligible; object versions and restore catalogue.

**Steps.** Attempt prune for each, crash after manifest/before delete and after delete/before verify, then rerun.

**Pass.** First two remain. Eligible segment reaches `PRUNED` only after manifest/audit/delete/absence verification. Chain verification recognizes its anchored summary; retry is idempotent.

**Fail.** Held/uncheckpointed payload disappears, unexplained gap, prune event missing, or provider copy survives while state says complete.

**Evidence.** Eligibility predicates, work graph, object inventories, checkpoint/tombstone, verifier report.

**Duration.** **ESTIMATE:** 45 minutes.

**Cleanup.** Delete all T1 segments/copies/keys according to fixture manifest and verify absence.

## 8.4 Attack/failure test plan and acceptance rule

The attack/failure plan passes only when all of the following are zero:

```text
SUCCESSFUL_PRIVILEGED_MUTATIONS_WITHOUT_DURABLE_AUDIT
SENSITIVE_RESULT_BYTES_BEFORE_AUDIT_COMMIT
DUPLICATE_TERMINAL_SUCCESS_EVENTS_PER_COMMAND
DUPLICATE_BUSINESS_EFFECTS_PER_COMMAND
CROSS_REALM_AUDIT_RESULTS_OR_MUTATIONS
ORDINARY_ADMIN_UNDETECTED_HISTORY_CHANGES
MANDATORY_TAMPER_CORPUS_SURVIVORS
EXTERNAL_CHECKPOINT_RESTORE_ROLLBACKS_ACCEPTED
UNEXPLAINED_AUDIT_SEQUENCE_GAPS_OR_FORKS
MANDATORY_PRIVACY_CANARY_ESCAPES_OR_SCANNER_MISSES
UNAUTHORIZED_BREAK_GLASS_ACTIONS
PREMATURE_OR_FALSE_PRUNE_COMPLETIONS
READ/EXPORT/CONNECTOR ENABLEMENT BEFORE RESTORE VERIFICATION
CLEANUP_RESIDUES
```

Performance, availability, operator confidence, or low failure percentage cannot compensate for a nonzero hard-invariant count.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Hard correctness and security functions

These functions run in CI, integration labs, restore drills, and release evidence. A result of `UNKNOWN`, missing evidence, or expired evidence is a failure for production eligibility.

| ID | Fitness function | Required result |
|---|---|---|
| FF21-01 | `count(successful_privileged_command where terminal_success_audit_event_count != 1)` | `0` |
| FF21-02 | `count(terminal_success_audit_event where committed_business_effect_count != 1)` | `0` |
| FF21-03 | `count(command where business_commit_tx_identity != audit_commit_tx_identity)` for transaction-required events | `0` |
| FF21-04 | `count(sensitive_disclosure where first_output_byte_time < audit_commit_time)` | `0` |
| FF21-05 | `count(command_id with >1 business terminal effect or >1 terminal success event)` | `0` |
| FF21-06 | `count(stream_epoch where sequences are not exactly contiguous from genesis/pruned-summary to head)` | `0` |
| FF21-07 | `count(event where recomputed_hash != stored_event_hash)` | `0` |
| FF21-08 | `count(event where previous_event_hash != prior committed event_hash)` | `0` |
| FF21-09 | `count(sealed_segment where recomputed_merkle_root != stored_merkle_root)` | `0` |
| FF21-10 | `count(checkpoint where signature/key-purpose/continuity/external receipt invalid)` | `0` accepted as trusted |
| FF21-11 | `count(mandatory_tamper_case where verifier_decision == PASSED)` | `0` |
| FF21-12 | `count(ordinary_admin_attempt that changed/deleted audit history or cleared hold)` | `0` |
| FF21-13 | `count(cross_realm_audit_read_write_export_or_cache_result)` | `0` |
| FF21-14 | `count(event_or_export_sink containing forbidden_canary_or_declared_derivative)` | `0` |
| FF21-15 | `count(mandatory_canary_positive_control not detected)` | `0` |
| FF21-16 | `count(restore marked READY with local_head != trusted_external_checkpoint/reconciled authoritative state)` | `0` |
| FF21-17 | `count(pruned_segment not checkpointed, held, unresolved, or not absence-verified)` | `0` |
| FF21-18 | `count(break_glass_action without active bounded session and linked audit event)` | `0` |
| FF21-19 | `count(active feature/control that can broaden or skip audit/verification/realm)` | `0` |
| FF21-20 | `count(release artifact containing test fault controller, lab key, arbitrary audit command, or skip path)` | `0` |

## 9.2 Structural architecture functions

CI MUST fail when:

- a privileged command handler is not registered to exactly one capability, purpose family, and terminal event profile;
- a transaction-required command writes a privileged business table outside the approved transaction wrapper/stored procedure/module;
- application code references `UPDATE`, `DELETE`, or destructive DDL against audit history;
- the audit domain references generic logging, arbitrary dictionary/JSON details, exception serialization, raw SQL, URL/path, user display identity, or secret types;
- search/export code bypasses the audit-before-disclose wrapper;
- verifier code references the writer's event-hash implementation rather than an independently versioned implementation or independently reviewed comparator;
- an audit metric label is not in the closed finite catalogue;
- realm is accepted from an untrusted command body;
- a feature flag can skip audit, accept an unverifiable checkpoint, clear a gap, or broaden cross-realm scope;
- a native database audit/ledger feature is configured as the sole source of business event semantics.

## 9.3 Verification freshness and tail criteria

Let:

```text
T_unanchored = current_time - committed_time_of_last_externally_trusted_checkpoint
N_unanchored = current_stream_head_sequence - last_checkpoint_sequence
B_unanchored = canonical_bytes_after_last_checkpoint
```

The system MUST expose all three as bounded finite metrics, without realm/actor/target labels. The approved production limits are **HUMAN DECISION/ESTIMATE**. Until approved, the conservative production state is no activation; T1 tests use deliberately small values.

Fitness conditions:

```text
checkpoint_work_oldest_age <= approved_age_limit
AND unanchored_event_count <= approved_count_limit
AND unanchored_bytes <= approved_byte_limit
OR affected_privileged_surface_state == HOLD
```

No test or operator may mark verification healthy merely because the local chain is internally consistent.

## 9.4 Realm and access criteria

For every access profile and API:

```text
AuthorizedResult = AuthenticatedRealm
                 ∩ CapabilityScope
                 ∩ PurposeScope
                 ∩ Case/ApprovalScope
                 ∩ TargetScope
                 ∩ TimeScope
                 ∩ FieldViewProfile
                 ∩ CurrentVerificationState
                 ∩ CurrentHold/RestoreState
```

Any missing, stale, conflicting, or unknown term yields no disclosure or mutation. Realm wildcard access is representable only for an explicitly product-global security/governance capability and requires a separate global stream event; it is never implied by a tenant-admin role.

## 9.5 Data minimization and cardinality criteria

- Every event type has a machine-readable allowed-field set and change profile.
- Every persisted field maps to a named purpose and retention class.
- Unknown event fields and enums are rejected.
- No event contains raw activity, URL, path, selector, query, SQL, secret, token, credential, arbitrary exception, or free-form narrative.
- Metric series satisfy:

```text
actual_series_per_metric
  <= product_of_declared_finite_label_cardinalities
  <= approved_metric_series_budget
```

The budget is a **HUMAN DECISION/ESTIMATE**. Actor, realm, target, event ID, command ID, checkpoint hash, case ID, or error text cannot be a metric label.

## 9.6 Performance and operations criteria

**UNKNOWN / HUMAN DECISION.** No audit latency, throughput, storage, checkpoint, search, export, recovery, or cost target is approved. The following measurements are mandatory before values can be proposed:

- privileged command arrival distribution and concurrency;
- sensitive read/export volume and result-size buckets;
- event canonical bytes by type and change profile;
- stream-head lock wait and retry distributions by realm;
- segment-sealing CPU, memory, duration, and backlog;
- checkpoint publication and verification duration/failure distribution;
- daily/full verification I/O and recovery impact;
- audit search query corpus and history size;
- backup/restore/replay time and external checkpoint availability;
- native SQL Server Ledger/Audit or pgAudit storage/CPU/operations impact;
- operator staffing, incident frequency, and evidence-export cost.

A production performance gate MUST use owner-approved SLOs and cost limits. It cannot weaken any hard zero-tolerance invariant.

## 9.7 Availability and failure criteria

- Audit primary-store unavailability results in zero successful privileged mutations and zero sensitive disclosures.
- External checkpoint unavailability never changes the truth of committed local transactions; it creates bounded `PENDING/STALE/HOLD` state.
- Verifier or checkpoint failure is visible through an independent alert route and cannot be cleared by an ordinary product/DB administrator.
- An audit failure does not silently fall back to ordinary logs, SIEM, local file, browser storage, or in-memory buffer as authoritative evidence.
- Recovery and re-enable require a new verification report and an audited higher-revision clearance; service restart alone cannot clear a hold.

## 9.8 Accessibility and usability criteria

The portal gate requires:

- complete keyboard operation for search, filters, sorting, pagination, detail, approval, export, verification, and incident workflow;
- programmatic names/roles/states for tables, filters, badges, timeline and verification diagrams;
- status changes announced without focus theft;
- failure/hold/gap states conveyed by text and semantics, not color alone;
- accessible confirmation and error recovery for high-impact actions;
- no hidden truncation of event type, outcome, verification, purpose, or target class that changes meaning;
- automated WCAG 2.2 checks plus manual keyboard/screen-reader execution of the critical T1 workflow.

## 9.9 Primary gate expression

```text
P21_PRIMARY_GATE_PASS =
    PRIVILEGED_MUTATION_ATOMICITY_PASS
    AND SENSITIVE_READ_AUDIT_BEFORE_DISCLOSE_PASS
    AND COMMAND_IDEMPOTENCY_PASS
    AND REALM_ISOLATION_PASS
    AND ORDINARY_ADMIN_NON_DELETION_PASS
    AND TAMPER_CORPUS_DETECTION_PASS
    AND EXTERNAL_CHECKPOINT_RESTORE_PASS
    AND GAP_FORK_STATE_MACHINE_PASS
    AND AUDIT_ACCESS_EXPORT_PASS
    AND RETENTION_PRUNE_HOLD_PASS
    AND PRIVACY_CANARY_PASS
    AND ACCESSIBILITY_CRITICAL_WORKFLOW_PASS
    AND NATIVE_DB_DEFENSE_PROFILE_RECORDED
    AND ALL_BLOCKING_OWNER_FUNCTIONS_ASSIGNED
    AND REQUIRED_HUMAN_DECISIONS_RECORDED
    AND ALL_EVIDENCE_CURRENT
    AND ZERO_CLEANUP_FAILURES
```

The primary gate means only:

> A privileged mutation cannot succeed without durable audit, and ordinary product/database administration cannot alter history undetected, for the exact release, engine/topology, verifier, checkpoint store, key profile, contracts, and test scope named by the evidence.

It does not establish lawful purpose, legal admissibility, production retention, adequate staffing, commercial support, or production approval.

---

# 10. Human decisions and owner questions

Research MUST NOT make the four decisions explicitly reserved by the prompt. Conservative defaults below are technical containment only, not approval.

## 10.1 Mandatory human decisions

| ID | HUMAN DECISION | Options | Consequences | Conservative temporary default | Accountable function |
|---|---|---|---|---|---|
| HD21-01 | **Audit retention and access** | (A) short operational retention; (B) purpose-specific tiered retention; (C) longer regulated/evidentiary retention; (D) realm-specific narrower periods; access by security, compliance, tenant admin, support, auditor, or combinations with approval | Longer retention improves investigation/verification horizon but increases privacy, breach, cost, access, and deletion burden. Narrow access reduces misuse but may slow response. Segment-level pruning may constrain granularity. | T1 fictional evidence only with manifest-defined short expiry. No production audit portal or pruning until immutable policy revisions, roles, holds, backup/restore, and approval are recorded. | Data Controller/Records Management with Security, Privacy, Product Governance, Legal and Audit owner |
| HD21-02 | **Independent verifier owner** | (A) Security Engineering; (B) Internal Audit/Compliance technology function; (C) independent SRE/platform account; (D) external managed verifier/witness; (E) shared quorum | More independence raises detection credibility but adds staffing, key, availability, procurement, incident, and support complexity. Product/DB team ownership is operationally simple but weakens independence. | `UNASSIGNED` blocks production eligibility. Use a disposable separately credentialed lab verifier only. | Architecture Governance and designated Risk/Audit authority |
| HD21-03 | **Regulatory/evidentiary requirements** | (A) no special evidentiary claim beyond operational integrity; (B) internal-control/compliance evidence; (C) qualified timestamp/notary requirements; (D) regulator/customer-held checkpoints; (E) formal chain-of-custody/export requirements | Higher claims may require qualified time, external witnesses, certified providers, retention, legal hold, documented procedures, signatures, personnel separation, and jurisdictional controls. Cryptographic integrity alone is insufficient. | Explicitly state **no special legal admissibility or regulatory sufficiency claim**. Keep production disabled until the chosen claim and evidence standard are documented. | Legal/Compliance/Risk authority with Security and Records |
| HD21-04 | **Response to verification failure** | (A) automatic scoped hold; (B) global privileged-surface hold; (C) continue selected safety-narrowing actions only; (D) restore to trusted point; (E) declare a gap and continue under approved risk; (F) notify regulator/customer/employee bodies | Broad hold protects integrity but creates outage; narrow hold needs precise dependency proof; gap acceptance preserves availability but concedes incomplete evidence; restore can lose later work unless reconciled. | Automatic technical hold for affected realm/stream and all actions that depend on it; allow only fixed safety-narrowing/containment actions that themselves remain auditable. No ordinary admin clearance. Organizational/legal response remains undecided. | Security Incident/Risk Authority with Product, Legal, Privacy, Operations and Audit owner |

## 10.2 Additional human decisions

| ID | HUMAN DECISION | Conservative state until decided | Consequence of delay | Accountable function |
|---|---|---|---|---|
| HD21-05 | Which actor/subject identity level is necessary in audit and search | Opaque authenticated principal ID only; no display identity in durable event | Limits human-readable search; blocks production identity view profile | IAM/Product Governance with Privacy |
| HD21-06 | Approved purpose codes, prohibited uses, and audit-query purposes | T1 closed fictional codes only | Blocks production reads/exports and event activation | Data Controller/Product Governance with Legal/Privacy |
| HD21-07 | Which privileged commands require approval, quorum, or separation of duties | All destructive/broadening/export/break-glass/lifecycle examples require T1 approval; no production rule assumed | Blocks production workflow execution | Security IAM/Product Governance |
| HD21-08 | Break-glass capability set, expiry, approval, review, and on-call authority | Break-glass disabled; safety kill switches remain available | May limit emergency repair; blocks emergency admin path | Security/Risk/Operations |
| HD21-09 | Checkpoint maximum unanchored age/count/bytes and daily verification schedule | Deliberately small T1 limits; no production activation | Blocks availability tuning and production gate | Security/SRE/Risk |
| HD21-10 | External checkpoint technology, account, region, immutability/WORM, witness, and availability profile | Local/disposable T1 anchor only; no production trust | Blocks independent detection claim | Security Architecture/SRE/Procurement |
| HD21-11 | Checkpoint signing/witness algorithms, KMS/HSM, key custodians, quorum, rotation, recovery, and compromise response | Lab key only; exact crypto profile provisional | Blocks production checkpoints and evidentiary claims | Cryptographic Authority |
| HD21-12 | Whether SQL Server Ledger/Audit or PostgreSQL pgAudit is required and who operates it | Supplemental features off by default outside test matrix | Direct DB evidence may be weaker; no production DB profile | Database Security/Architecture/Operations |
| HD21-13 | Audit event field catalogue and minimized change profiles | Only T1 event profiles in this result | Blocks production command activation | Product Data Owner with Security/Privacy |
| HD21-14 | Audit search roles, cross-realm product-global roles, case requirements, approval, and field views | No production search; exact-realm T1 views only | Blocks support/security/compliance use | IAM/Product Governance/Privacy |
| HD21-15 | Audit export recipients, encryption, download, expiry, retrieval, uncontrolled-copy response, and deletion | Local encrypted T1 export only; no remote recipient | Blocks production export/inspection workflow | Security/Compliance/Records/Crypto |
| HD21-16 | Legal holds and incident preservation scope over audit/checkpoints/backups | T1 fixture holds only | Blocks production prune/backup expiry | Legal/Records/Security Incident |
| HD21-17 | Retention interaction with SQL Server Ledger's nondeletable history and selected backup/store technology | Engine decision remains open; no production Ledger retention claim | Can rule out or reshape SQL Server Ledger usage | Database Architecture/Records/Legal/Operations |
| HD21-18 | Audit SLO, RPO, RTO, checkpoint availability, recovery time, and acceptable administrative outage | No production objectives; fail closed | Blocks capacity, topology, staffing, and production acceptance | Product/Risk/SRE |
| HD21-19 | Capacity, storage, search, backup, key, witness, and operations budget | T1 bounds only | Blocks technology selection and sustainable operation | Product/Finance/Operations/Procurement |
| HD21-20 | Staffing, on-call, verifier operations, incident command, support hours, training, and destructive-lab authority | Capability disabled when owner unavailable | Blocks primary and production gates | Engineering/Operations Leadership |
| HD21-21 | Database engine/topology and audit-store physical design | Both candidates remain prototypes | Blocks production schema/index/HA/backup choice | Architecture/Product/Operations/Procurement |
| HD21-22 | Whether customer, regulator, works council, or employee representatives receive verification evidence or notification | No external publication; no such claim | Blocks external transparency/notification workflow | Legal/Privacy/Product Governance |
| HD21-23 | Metric/access/retention budgets and alert thresholds | Fixed low-cardinality T1 metrics only | Blocks production dashboards and response automation | SRE/Privacy/Data Governance |
| HD21-24 | Pilot and production risk acceptance | T1 disposable lab only | Blocks all live/pilot/production use | Designated Production/Risk Authority |

## 10.3 Owner questions that must be answered

1. Which exact privileged actions, reads, exports, lifecycle operations, and failures must be auditable, and which high-volume events are safely aggregated?
2. What purpose justifies each audit field, and which fields are prohibited even for security review?
3. Which actors may search by opaque principal/target ID, and who may resolve those IDs to human-readable identity?
4. Is a private independently stored checkpoint sufficient, or is witness/gossip/customer-held evidence required?
5. What maximum unanchored tail is acceptable before administrative operations stop?
6. Which verification failure classes stop one realm, all realms, or only one capability?
7. Who can clear a hold, what independent evidence is required, and what approvals/separation apply?
8. What audit retention is required for each event class, checkpoint, gap declaration, verification report, export, and native DB audit?
9. How do legal holds, employee/subject rights, deletion, backup expiry, and restored systems interact with audit evidence?
10. Does SQL Server Ledger's retention limitation fit the approved lifecycle, or should it be limited to selected tables/omitted?
11. Is pgAudit/SQL Server Audit needed to monitor direct DBA/DDL paths, and what availability/log-volume trade-off is acceptable?
12. Which key service and custodians can remain independent from product and database administrators?
13. Which defined incident scenarios must support staff solve without raw activity, unrestricted SQL, or process memory?
14. What accessibility conformance and assistive-technology coverage is required before the portal is acceptable?
15. Who pays for and operates checkpoint storage, witnesses, verification, recurring tamper drills, restore drills, and long-term key verification?
16. What external or legal statements may UAM make about “tamper-evident,” “verified,” “complete,” or “forensic,” and which statements are prohibited?

---

# 11. CLI experiments, measurements, and exact evidence

## 11.1 CLI lane safety and conventions

All commands below are repository-task specifications. They use placeholders and T1 fictional data only. They MUST NOT accept or print a raw connection string, password, certificate private key, SSH command, host, address, user name, internal URL, production identifier, or production activity.

Recommended command conventions:

```text
--lab-profile <path-to-sanitized-profile>     # opaque local reference; file excluded from evidence
--engine-profile <postgresql|sqlserver>-<id>  # public class, not address
--fixture-root <content-digest-or-path>
--evidence-root <new-empty-directory>
--seed <fixed-hex>
--fault <closed-id>
--cleanup required
--redaction-policy strict
```

Every command exits nonzero on a failed assertion, missing cleanup, missing positive control, expired evidence, unknown enum, or incomplete output. A rerun creates a new evidence root and links the previous failure; it never overwrites it.

## 11.2 Ordered experiments

### E21-00 — evidence and dependency inventory

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  inventory \
  --lab-profile <SANITIZED_LAB_PROFILE> \
  --evidence-root evidence/e21-00-inventory \
  --redaction-policy strict \
  --cleanup required
```

Must produce:

```text
environment.json
source-tree.json
files.sha256
managed-packages.json
native-modules.json
tools-and-actions.json
licenses.json
sbom-reconciliation.json
provenance-verification.json
test-hook-absence.json
cleanup-receipt.json
```

**Pass:** every executable byte maps to an exact reviewed source/package/binary; release artifact lacks test hooks, lab keys, arbitrary audit collectors, and skip paths. **Stop:** mutable input, unknown native module, unresolved license for selected use, or cleanup failure.

### E21-01 — contracts, canonicalization, and schema vectors

```bash
dotnet test tests/Uam.Audit.Contracts.Tests/Uam.Audit.Contracts.Tests.csproj \
  --configuration Release \
  --no-restore \
  --logger "trx;LogFileName=e21-01-contracts.trx"

dotnet run --project tools/Uam.ContractCheck/Uam.ContractCheck.csproj -- \
  verify-catalogue \
  --catalogue contracts/audit/catalogue.json \
  --vectors tests/vectors/audit \
  --evidence-root evidence/e21-01-contracts
```

Must produce exact valid/invalid matrix, canonical bytes/hashes, allocation/time bounds, local-reference closure, event-field catalogue, and test result digests.

**Pass:** duplicate, unknown, wrong-case, remote-reference, free-form, forbidden-field, and invalid canonical inputs are rejected; valid vectors are byte-identical across two clean runs.

### E21-02 — command-to-audit architecture mutations

```bash
dotnet test tests/Uam.Architecture.Tests/Uam.Architecture.Tests.csproj \
  --configuration Release \
  --filter "AuditCoverage|AuditForbiddenDependencies|RealmAuthority|NoSkipAudit"

dotnet run --project tools/Uam.RepoGuard/Uam.RepoGuard.csproj -- \
  run-mutation-pack \
  --pack audit-command-coverage-v1 \
  --evidence-root evidence/e21-02-architecture
```

Must prove every privileged command, job, CLI, repair, scheduler, export, lifecycle, integration, release, diagnostic, and break-glass path is registered to a closed event profile; every injected missing registration or forbidden API fails.

### E21-03 — basic transactional success and idempotency

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  transactional-mutation \
  --engine-profile <ENGINE_PROFILE> \
  --fixture-root fixtures/audit/atomicity-v1 \
  --scenario success-and-replay \
  --seed 21030001 \
  --evidence-root evidence/e21-03-<ENGINE_PROFILE> \
  --cleanup required
```

Must produce business state, event state, stream head, command result, transaction identity, retry result, and independent-oracle reconciliation.

**Pass:** one business effect, one terminal success event, one sequence/head advance; retry returns same IDs.

### E21-04 — inject primary audit write failure

```bash
for FAULT in \
  audit.before_insert \
  audit.insert_denied \
  audit.after_insert_before_head \
  audit.head_update_conflict \
  transaction.before_commit \
  storage.disk_full
 do
  dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
    transactional-mutation \
    --engine-profile <ENGINE_PROFILE> \
    --fixture-root fixtures/audit/atomicity-v1 \
    --scenario policy-activation \
    --fault "$FAULT" \
    --seed 21040001 \
    --evidence-root "evidence/e21-04-<ENGINE_PROFILE>-$FAULT" \
    --cleanup required || exit 1
 done
```

This is the prompt-mandated **inject audit write failure** lane.

Must produce one capsule per fault with exact pre/post business/effect/event/head state, driver/transaction outcome, safe response, hold state, resource state, and cleanup.

**Pass:** zero successful privileged mutation and zero sensitive disclosure for every failed audit write. **Fail:** any new business revision, success response, or unaudited fallback.

### E21-05 — response loss and unknown commit reconciliation

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  commit-ambiguity \
  --engine-profile <ENGINE_PROFILE> \
  --fixture-root fixtures/audit/atomicity-v1 \
  --fault-set faults/commit-ambiguity-v1.json \
  --seed 21050001 \
  --evidence-root evidence/e21-05-<ENGINE_PROFILE> \
  --cleanup required
```

Must produce socket/process/DB fault timeline, command reconciliation, one-effect/one-event set, retries, first failure, and no duplicate IDs.

### E21-06 — concurrency, sequence, and lock behavior

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  stream-concurrency \
  --engine-profile <ENGINE_PROFILE> \
  --fixture-root fixtures/audit/concurrency-v1 \
  --actors 64 \
  --realms 8 \
  --operations 10000 \
  --seed 21060001 \
  --evidence-root evidence/e21-06-<ENGINE_PROFILE> \
  --cleanup required
```

`64`, `8`, and `10000` are **ESTIMATE/test-budget** values. Evidence must include offered/started/committed/retried operations, lock wait/deadlock distributions, sequence continuity, realm isolation, resource curves, and generator saturation proof.

### E21-07 — realm and cache/token isolation

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  realm-negative-matrix \
  --engine-profile <ENGINE_PROFILE> \
  --fixture-root fixtures/audit/realm-collisions-v1 \
  --include search,export,continuation-token,cache,approval,break-glass \
  --evidence-root evidence/e21-07-<ENGINE_PROFILE> \
  --cleanup required
```

Must produce zero cross-realm accepted rows/mutations and finite generic denials without existence leakage.

### E21-08 — ordinary administrator non-deletion and effective access

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  admin-tamper-matrix \
  --engine-profile <ENGINE_PROFILE> \
  --role-fixture fixtures/audit/roles-v1.json \
  --attack-pack attacks/audit-ordinary-admin-v1.json \
  --evidence-root evidence/e21-08-<ENGINE_PROFILE> \
  --cleanup required
```

Must test API and SQL attempts to update/delete/truncate/drop/disable, clear holds, change grants, and prune. Evidence includes effective grants before/after, denied statements as digests/safe classes, native DB supplemental evidence, chain/checkpoint verification, and cleanup.

### E21-09 — alter, reorder, gap, duplicate, and rollback synthetic records

```bash
dotnet run --project tools/Uam.AuditTamper/Uam.AuditTamper.csproj -- \
  generate \
  --fixture-root fixtures/audit/three-segments-v1 \
  --tamper-pack attacks/audit-integrity-v1.json \
  --output-root lab/tampered-copies/e21-09

dotnet run --project tools/Uam.AuditVerify/Uam.AuditVerify.csproj -- \
  verify-pack \
  --input-root lab/tampered-copies/e21-09 \
  --trusted-checkpoint fixtures/audit/checkpoints/trusted-v1.json \
  --expected-results fixtures/audit/oracle/tamper-results-v1.json \
  --evidence-root evidence/e21-09-tamper \
  --cleanup required
```

This is the prompt-mandated **alter/reorder/gap synthetic records** lane.

Tamper pack MUST include field alteration, hash alteration, deletion, last-event deletion, duplication, sequence reuse, reordering, previous-link change, segment-root change, local full-chain recomputation, whole-database rollback, and conflicting checkpoints.

**Pass:** zero mandatory survivors. Evidence identifies the first bad stream/sequence and expected/observed digests without exposing event content.

### E21-10 — checkpoint consistency and witness spike

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  checkpoint-split-view \
  --checkpoint-profile private-signed-v1 \
  --witness-profile <NONE_OR_T1_WITNESS_PROFILE> \
  --fixture-root fixtures/audit/checkpoint-forks-v1 \
  --evidence-root evidence/e21-10-checkpoint \
  --cleanup required
```

Must prove checkpoint continuity and, when witness is enabled, detection/prevention of conflicting views. No OSS service is admitted by this command alone.

### E21-11 — external checkpoint outage and ambiguous publication

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  checkpoint-publication-faults \
  --external-store-profile <T1_EXTERNAL_STORE_PROFILE> \
  --fault-set faults/checkpoint-publication-v1.json \
  --fixture-root fixtures/audit/checkpoint-publication-v1 \
  --evidence-root evidence/e21-11-checkpoint-store \
  --cleanup required
```

Must produce stable checkpoint IDs, write/read/version receipts, retry/query behavior, unanchored-tail metrics, hold transition, and object/key cleanup. A write response without verified readback remains ambiguous.

### E21-12 — verify external digest after backup/restore

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  backup-restore-verify \
  --engine-profile <ENGINE_PROFILE> \
  --backup-profile <T1_BACKUP_PROFILE> \
  --fixture-root fixtures/audit/restore-v1 \
  --trusted-checkpoint fixtures/audit/checkpoints/post-backup-v1.json \
  --fault-set faults/restore-replay-v1.json \
  --evidence-root evidence/e21-12-<ENGINE_PROFILE> \
  --cleanup required
```

This is the prompt-mandated **verify external digest after backup/restore** lane.

Must produce actual backup/restore identifiers, isolated environment identity, disabled read/egress/receipt state, local-versus-trusted checkpoint comparison, authoritative command/effect/event set reconciliation, replay result, tombstone/hold checks, readiness decision, and destruction receipt.

**Pass:** an old restore is blocked until exact reconciliation; no missing/duplicate business effect or audit event; ordinary access remains disabled until separate audited enablement.

### E21-13 — key purpose, rotation, revocation, and recovery

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  checkpoint-key-lifecycle \
  --key-profile <T1_KEY_PROFILE> \
  --fixture-root fixtures/audit/keys-v1 \
  --fault-set faults/audit-keys-v1.json \
  --evidence-root evidence/e21-13-keys \
  --cleanup required
```

Must prove wrong-purpose denial, no private export, rotation overlap, old verification, revocation interval, unavailable-key behavior, restore verification, and deletion of lab keys/trust.

### E21-14 — clock and expiry uncertainty

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  time-quality \
  --clock-profile controllable-t1-v1 \
  --fixture-root fixtures/audit/time-v1 \
  --fault-set faults/clock-v1.json \
  --evidence-root evidence/e21-14-time \
  --cleanup required
```

Must prove sequence ordering independent of wall time and fail-safe behavior for approval, permit, checkpoint staleness, export expiry, and break-glass expiry.

### E21-15 — all-sink privacy canaries and code mutations

```bash
dotnet run --project tools/Uam.CanaryScan/Uam.CanaryScan.csproj -- \
  self-test \
  --registry tests/canaries/audit-canaries-v1.json \
  --evidence-root evidence/e21-15-canary-self-test

dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  all-sink-privacy \
  --fixture-root fixtures/audit/privacy-v1 \
  --sink-manifest tests/manifests/audit-sinks-v1.json \
  --evidence-root evidence/e21-15-all-sink \
  --cleanup required
```

Must scan database tables/index/search artifacts, checkpoints, object metadata, logs, metrics, traces, portal/API responses, exports, backups, restore evidence, crash/test output, and evidence bundle in declared encodings. Every positive control must be detected before zero-escape claims.

### E21-16 — hostile display and export encoding

```bash
dotnet test tests/Uam.Audit.Portal.Security.Tests/Uam.Audit.Portal.Security.Tests.csproj \
  --configuration Release \
  --filter "Injection|CsvFormula|UnicodeControl|OutputEncoding|Csp"
```

Must produce browser/export artifacts with fictional strings, CSP/output-encoding evidence, and zero execution/corruption.

### E21-17 — offered-load, pressure, checkpoint backlog, and cardinality

```bash
dotnet run --project tools/Uam.AuditLoad/Uam.AuditLoad.csproj -- \
  run \
  --engine-profile <ENGINE_PROFILE> \
  --scenario tests/scenarios/audit-pressure-v1.json \
  --seed 21170001 \
  --evidence-root evidence/e21-17-<ENGINE_PROFILE> \
  --cleanup required
```

Must reuse production command/audit/canonical/checkpoint paths, schedule open arrivals, measure generator saturation, event bytes/type, stream contention, segment/checkpoint lag, search/backup coexistence, metric series, and fail-closed outcomes. Exact thresholds are not approved by this experiment.

### E21-18 — sensitive read and export audit-before-disclose

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  disclose-boundary \
  --fixture-root fixtures/audit/read-export-v1 \
  --fault-set faults/disclose-boundary-v1.json \
  --evidence-root evidence/e21-18-disclosure \
  --cleanup required
```

Must record DB commit and first-byte/token timestamps with zero forbidden content. Any precommit body byte or token is a hard failure.

### E21-19 — export lifecycle, encryption, and deletion

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  export-lifecycle \
  --object-profile <T1_OBJECT_PROFILE> \
  --key-profile <T1_EXPORT_KEY_PROFILE> \
  --fixture-root fixtures/audit/export-v1 \
  --fault-set faults/export-v1.json \
  --evidence-root evidence/e21-19-export \
  --cleanup required
```

Must prove approval/release separation, memory-only plaintext assembly or approved bounded equivalent, encryption before durable object write, token scoping, wrong-realm denial, expiry/revoke/delete, object-version inventory, and explicit uncontrolled recipient-copy status.

### E21-20 — break-glass and approval workflow

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  governance-workflows \
  --fixture-root fixtures/audit/governance-v1 \
  --scenario-set break-glass,approval,sod,expiry,revocation \
  --evidence-root evidence/e21-20-governance \
  --cleanup required
```

Must produce every workflow state/event, action-capability matrix, stale/self-approval negatives, audit-failure behavior, restart/expiry behavior, and post-use review state.

### E21-21 — native database defense-in-depth comparison

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  native-db-audit-profile \
  --engine-profile <ENGINE_PROFILE> \
  --native-profile <SQLSERVER_LEDGER_AUDIT_OR_POSTGRESQL_PGAUDIT_PROFILE> \
  --attack-pack attacks/direct-db-v1.json \
  --evidence-root evidence/e21-21-<ENGINE_PROFILE> \
  --cleanup required
```

Must record exact engine/edition/extension/profile, DDL, target failure behavior, log/digest volume, failover/restore, direct-admin detections, false gaps, operational procedures, licenses, and limitations. It cannot emit “recommended dependency” without a separate ADR/human selection.

### E21-22 — segment/Merkle independent implementation

```bash
dotnet run --project tools/Uam.AuditVerify/Uam.AuditVerify.csproj -- \
  vector-suite \
  --vectors tests/vectors/audit-merkle-v1 \
  --implementation primary
<INDEPENDENT_VERIFIER_COMMAND> \
  --vectors tests/vectors/audit-merkle-v1 \
  --implementation independent \
  --evidence-root evidence/e21-22-independent-verifier
```

`<INDEPENDENT_VERIFIER_COMMAND>` is selected by the dependency/implementation ADR and must be pinned. Must prove identical valid roots/proofs and identical rejection of the mandatory mutation set.

### E21-23 — search/index/continuation-token correctness

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  search-index \
  --fixture-root fixtures/audit/search-v1 \
  --fault-set faults/search-index-v1.json \
  --evidence-root evidence/e21-23-search \
  --cleanup required
```

Must prove bounded strict query grammar, realm-bound continuation tokens, watermark eligibility, stale-index behavior, sorting/pagination completeness, field-view authorization, and audit-before-disclose.

### E21-24 — retention, holds, prune, and object copies

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  retention-prune \
  --engine-profile <ENGINE_PROFILE> \
  --object-profile <T1_OBJECT_PROFILE> \
  --fixture-root fixtures/audit/retention-v1 \
  --fault-set faults/retention-prune-v1.json \
  --evidence-root evidence/e21-24-<ENGINE_PROFILE> \
  --cleanup required
```

Must prove whole-segment eligibility, checkpoint/hold/incident/restore predicates, crash-resumable deletion, version/copy/key inventory, retained prune tombstone, post-prune verification, and no false completion.

### E21-25 — accessibility critical workflow

```bash
npm run test:a11y:audit-portal -- \
  --fixture fixtures/audit/portal-accessibility-v1.json \
  --output evidence/e21-25-accessibility/automated.json

dotnet run --project tools/Uam.AccessibilityEvidence/Uam.AccessibilityEvidence.csproj -- \
  record-manual-workflow \
  --script tests/accessibility/audit-critical-workflow-v1.md \
  --evidence-root evidence/e21-25-accessibility
```

The selected portal toolchain is provisional; an equivalent command is allowed when recorded. Must cover keyboard, focus, screen-reader status, tables, timeline text alternative, hold/failure, approval, export, and error recovery.

### E21-26 — alert, incident, clearance, and no-self-reenable

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  incident-clearance \
  --fixture-root fixtures/audit/incidents-v1 \
  --fault-set faults/verification-incidents-v1.json \
  --evidence-root evidence/e21-26-incidents \
  --cleanup required
```

Must prove independent alert receipt, automatic hold, ordinary-admin clearance denial, higher-revision authorized clearance only after independent pass, and preservation of initial failure.

### E21-27 — role and organizational separation drill

```bash
dotnet run --project tools/Uam.AuditLab/Uam.AuditLab.csproj -- \
  separation-of-control \
  --role-fixture fixtures/audit/separation-v1.json \
  --attack-pack attacks/control-collusion-subsets-v1.json \
  --evidence-root evidence/e21-27-separation \
  --cleanup required
```

Must show no ordinary single role can perform business mutation, alter audit history, modify/delete external checkpoint, use verifier key, and clear failure. Required human owner assignment is checked separately.

### E21-28 — aggregate gate

```bash
dotnet run --project tools/Uam.Gate/Uam.Gate.csproj -- \
  evaluate \
  --gate contracts/gates/prompt-21-primary-gate-v1.json \
  --evidence-index evidence/index.json \
  --decision-register docs/decisions/human-decisions.json \
  --adr-register docs/adr/index.json \
  --output evidence/prompt-21-gate.json
```

The gate evaluator accepts no free-form `pass` field. It recomputes evidence digests, freshness, zero-tolerance counts, owners, decisions, exceptions, and cleanup.

Required output:

```json
{
  "gate": "P21_TRANSACTIONAL_AUDIT_PRIMARY",
  "decision": "PASS_OR_FAIL",
  "exactReleaseDigest": "sha-256:...",
  "engineProfileId": "...",
  "verifierProfileId": "...",
  "checkpointStoreProfileId": "...",
  "blockingFailures": [],
  "firstFailures": [],
  "humanDecisions": [],
  "owners": [],
  "evidenceExpiryUtc": "...",
  "productionApproved": false
}
```

## 11.3 Measurements required before production values

The CLI lane must additionally produce replaceable distributions—not guessed constants—for:

- audit events per command/read/export and canonical bytes by event type;
- per-realm/global stream write concurrency and lock wait;
- database transaction latency with and without audit/native defense controls;
- segment count/bytes/time and seal CPU/memory;
- checkpoint publication/readback/signature/witness latency and availability;
- daily incremental and full verification duration/I/O;
- audit search volume, query shapes, pagination, export sizes, and index lag;
- backup size, restore duration, trusted-checkpoint comparison, replay volume, and readiness time;
- retention/prune/delete/absence-verification time and copy count;
- native SQL Server Ledger/Audit or pgAudit log/storage overhead;
- alert-to-containment and responder time;
- metric series/cardinality and backend cost;
- engineering/support/key/verifier operations effort and licensing.

Each numeric proposal must cite the exact evidence run, workload, environment, release, owner, uncertainty, safety consequence, compatibility impact, and review trigger.

---

# 12. ADR proposals

Each ADR includes the proposed decision, status, alternatives, rationale, evidence, accountable owner function, and review trigger. No ADR is `Accepted` while a blocking owner is unassigned or its required CLI gate is open.

| ADR | Decision | Proposed status | Alternatives considered | Rationale / evidence | Accountable owner | Review trigger |
|---|---|---|---|---|---|---|
| ADR-021-001 | Use an application-owned typed transactional audit ledger as the mandatory semantic source of privileged-action evidence | **PROPOSED — BLOCKING** | ordinary logs/SIEM; DB trigger; external audit service; native DB audit alone | Only same business transaction protects the accepted “no successful privileged mutation without durable audit” invariant across PostgreSQL/SQL Server | Audit Architecture + Control API | P21 atomicity failure, required engine cannot support semantics, or formal baseline change |
| ADR-021-002 | Separate per-realm streams plus one product-global stream; sequence by locked stream head | **PROPOSED** | one global stream; per actor/session; timestamp order | Preserves realm isolation and avoids unnecessary global contention while keeping one complete order per authority scope | Audit Store | Measured stream-head contention or requirement for cross-realm total order |
| ADR-021-003 | Adopt the closed audit taxonomy, typed event/change profiles, and prohibition on free-form details | **PROPOSED — BLOCKING** | generic JSON/text event; arbitrary metadata bag | Minimizes leakage, supports compatibility, prevents injection/cardinality drift, and makes coverage testable | Audit Contract Authority + Privacy | New event cannot be represented without unsafe field; field-purpose review |
| ADR-021-004 | Use stable `command_id` for mutation idempotency and one terminal success event/effect | **PROPOSED — BLOCKING** | random event per attempt; request timestamp; endpoint-generated retry IDs | Required to reconcile response loss and unknown commit without duplicate business/audit effects | Control API + Data Correctness | Counterexample under failpoint/model test or upstream command contract change |
| ADR-021-005 | Require audit-before-disclose for sensitive reads and export release | **PROPOSED — BLOCKING** | log after response; pre-log intent only; external telemetry | A read/export cannot be undone; committing before first byte/token is the smallest enforceable evidence boundary | Audit API + Export Owner | Protocol/platform cannot prove byte boundary; alternative with equivalent evidence |
| ADR-021-006 | Chain events per stream, seal bounded Merkle segments, and publish independently signed external checkpoints | **PROPOSED — BLOCKING** | row hashes only; native DB ledger only; transparency service as primary; no external state | Detects deletion/reorder/rollback and privileged file tampering while preserving engine-neutral business semantics | Audit Store + Independent Verifier | Tamper survivor, unacceptable cost/latency, or evidentiary/witness requirement |
| ADR-021-007 | Store external checkpoints outside ordinary product/DB administration and keep verifier keys purpose-separated | **PROPOSED — HUMAN/CLI BLOCKED** | same DB/account/admin; product signer key; unsigned object | Independence is necessary to detect recomputed/rolled-back local history | Security Architecture + Crypto Authority | Verifier owner/key/store decision or control-separation failure |
| ADR-021-008 | Use whole sealed-segment retention/pruning with retained anchored tombstones | **PROPOSED — HUMAN BLOCKED** | per-row deletion; retain forever; editable/redactable chain | Whole segments keep verification simple; periods/holds/access remain human decisions | Records + Audit Store | Approved requirement for finer field expiry or native ledger constraint |
| ADR-021-009 | Treat gaps/forks as explicit incidents; close epoch and append a gap declaration rather than repairing history | **PROPOSED — BLOCKING** | synthetic replacement events; silent reset; edit chain | Preserves truthful evidence boundary and prevents false completeness | Security Incident + Verifier | Recovery prototype proves a stronger truthful mechanism |
| ADR-021-010 | Restore stays read/egress blocked until local audit matches external checkpoint and authoritative command/effect/event sets reconcile | **PROPOSED — BLOCKING** | trust local head/checksum; enable reads during replay | Required by accepted restore invariants and prevents rollback/missing-audit resurrection | Restore/Data Reliability + Verifier | New recovery substrate intrinsically proves both authorities |
| ADR-021-011 | Native SQL Server Ledger/Audit and PostgreSQL pgAudit are optional defense-in-depth, never primary business audit | **PROPOSED** | require one native feature; omit native evidence; let native logs define taxonomy | Features have useful but engine-specific threat/availability/retention semantics and lack UAM purpose/approval contracts | Database Security/Architecture | Engine selection, native experiment, regulatory requirement, lifecycle conflict |
| ADR-021-012 | Break-glass remains realm/capability/time bounded and fully audit-required; only safety-narrowing actions are emergency fallback | **PROPOSED — HUMAN BLOCKED** | unaudited emergency access; unrestricted DBA; no break-glass | Emergency is the highest-risk path; an unaudited bypass defeats the primary invariant | Security IAM/Risk | Human emergency design, incident exercise, or operational infeasibility |
| ADR-021-013 | No arbitrary search SQL/text; use closed realm-bound audit query profiles and field views | **PROPOSED** | generic DB reporting; SIEM full text; unrestricted JSON filters | Enforces access, minimization, query bounds, realm isolation, and audit-before-disclose | Audit Search/Portal + IAM | Approved investigation case cannot be met by closed grammar |
| ADR-021-014 | Export is an approved workflow: build encrypted/inaccessible, audit release, then issue bounded download token | **PROPOSED — HUMAN BLOCKED** | synchronous CSV; direct object URL; portal page download | Separates data preparation from disclosure and makes approval/audit atomic at release | Export Owner + Security/Records | Recipient/encryption/access decision or business requirement change |
| ADR-021-015 | Audit metrics use fixed value-free dimensions and no actor/realm/target/event/checkpoint labels | **PROPOSED** | dynamic labels; log-derived metrics | Prevents privacy leakage/cardinality denial while retaining operational health | SRE + Privacy | Defined diagnostic need not expressible within bounded catalogue |
| ADR-021-016 | Independent verifier uses an independently versioned canonical/hash/Merkle implementation and preserves first failure | **PROPOSED — BLOCKING** | share writer library; trust DB hashes; overwrite failed runs | Reduces common-mode defects and ensures reruns cannot erase evidence | Verification Architecture | Independent implementation cost/fitness evidence or formal verification alternative |
| ADR-021-017 | Exact checkpoint signing/witness profile remains provisional under the suite signed-control/key ADR | **PROPOSED — DEFER PROFILE** | hardcode algorithm/KMS/quorum now | Security properties are known; organizational, compliance, offline, and recovery inputs are not | Cryptographic Authority | HD21-03/10/11 and E21-13/E21-10 evidence |
| ADR-021-018 | Verification failure triggers an automatic scoped technical hold; organizational response is human-owned | **PROPOSED — HUMAN BLOCKED** | continue silently; immediate global shutdown; ordinary admin override | Conservative containment without inventing legal/business response | Incident/Risk Authority | HD21-04 decision and incident exercises |
| ADR-021-019 | No audit retention/access or legal-admissibility claim is inferred from cryptographic integrity | **PROPOSED — HUMAN BLOCKED** | default long retention; market “forensic proof” | Research cannot establish purpose, lawful retention, or evidence admissibility | Legal/Privacy/Records/Product Governance | Recorded HD21-01/03 decisions |
| ADR-021-020 | Portal critical audit workflows meet WCAG 2.2-oriented accessibility gate and expose persistent semantic integrity status | **PROPOSED** | visual-only dashboard; toast-only errors | Integrity failures and approvals must be usable by all authorized operators | Portal + Accessibility | Accessibility test failure or selected conformance policy change |

## 12.1 ADR change-proposal rule

Any future implementation that requires one of these must open a baseline change proposal rather than silently weakening the design:

- business commit before/without audit;
- sensitive output before read/release audit commit;
- actor/realm authority from request payload;
- free-form event details or raw source/activity values;
- lower-sequence history reset or synthetic gap repair;
- ordinary admin delete/update of history or failure clearance;
- local-only verification without independent checkpoint;
- native DB audit/ledger as the sole semantic source;
- an unaudited break-glass/direct-SQL channel;
- restore read enablement before trusted checkpoint/command reconciliation;
- retention/prune without hold/incident/restore/checkpoint predicates;
- a feature flag that can bypass audit, verification, realm, or approval.

The proposal must state new primary evidence, affected accepted invariant, security/privacy/realm/restore impact, alternatives, smallest falsifying prototype, migration and rollback consequences, and ADR action.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record Prompt 21 evidence manifest and source register | none | exact input hashes, public source/repository review points | missing/changed/unallowlisted project input or unresolved source claim |
| 2 | Assign blocking owner functions and open human decision records | governance | owner/decision register with `OPEN/ASSIGNED` state | independent verifier/audit owner unassigned for production-shaped work |
| 3 | Create ADR-021 set and command/event taxonomy catalogue | 1–2 | ADR drafts, event families/types, capability/purpose/target/change profiles | generic event/details or silent contradiction |
| 4 | Extend governed monorepo with audit boundaries | Batch 01 repo baseline, 3 | `Uam.Audit.Contracts`, `Domain`, `Store`, `Verify`, `Checkpoint`, `Search`, tests/tools | forbidden dependency/reference mutation survives |
| 5 | Implement strict contracts and canonical vectors | 3–4, suite canonical ADR | schemas, valid/invalid vectors, deterministic bytes/hashes | canonical profile unresolved or parser false accept |
| 6 | Implement pure transaction/audit reference model and independent verifier model | 3–5 | command/effect/event state model, tamper oracle, shrinker | verifier shares writer decision code or mutation survivor |
| 7 | Implement engine-neutral logical DDL and role model | 3–6 | stream/event/change/segment/checkpoint/verification/gap schema | mutable audit row, realm-less key, ordinary destructive grant |
| 8 | Implement one T1 privileged mutation through atomic wrapper | 5–7 | policy-activation prototype with command reconciliation | any business/audit partial state |
| 9 | Run PostgreSQL and SQL Server atomicity/failpoint lanes | 8 | E21-03–06 evidence for both candidates | one unaudited success, duplicate, gap, unknown unsafe retry |
| 10 | Implement audit coverage registry and architecture mutations | 3–9 | every privileged path classified; CI hard gate | unclassified command/job/repair/CLI |
| 11 | Implement per-stream hash chain and independent verification | 5–10 | event canonicalization, head, full verifier, tamper corpus | mandatory tamper survivor or unbounded verifier |
| 12 | Implement segment sealing and Merkle vectors | 11 | bounded segment/seal work, independent roots/proofs | omitted/noncontiguous event or implementation differential |
| 13 | Implement independent checkpoint signer/store abstraction | 2, 11–12 | stable checkpoint protocol, lab key/store, readback/receipt | product/DB admin can modify trusted object; key-purpose confusion |
| 14 | Run checkpoint outage, split-view candidate, and tamper campaigns | 13 | E21-09–11 evidence | silent stale tail, conflicting checkpoint accepted, cleanup failure |
| 15 | Implement sensitive-read audit-before-disclose wrapper | 5–14 | bounded search prototype and byte-boundary tests | any result byte before commit or raw query/selector event |
| 16 | Implement export workflow and encrypted T1 object | 15 plus human test profile | approval/build/release/token/delete states | object downloadable before release or plaintext residue |
| 17 | Implement approval and break-glass state machines | 3–16 | T1 workflow prototypes and SOD/expiry tests | unaudited emergency action, stale/self approval |
| 18 | Implement verification failure/hold/alert/clearance | 11–17 | immutable incident state, independent alert, no-self-reenable | ordinary admin clears failure or alert missed in required lane |
| 19 | Implement retention/prune work graph and anchored tombstone | 12–18, Batch 04 lifecycle contracts | whole-segment T1 prune, holds, copy/key inventory | held/uncheckpointed evidence lost or false completion |
| 20 | Compose actual backup/restore with external checkpoint | 9–19, Batch 04 restore prototype | E21-12 exact engine/topology evidence | rollback accepted, missing effect/event, pre-ready read/egress |
| 21 | Compare SQL Server Ledger/Audit and PostgreSQL pgAudit defense profiles | 9–20 | identical direct-admin/failure/restore/operations report | native feature changes semantic baseline or lifecycle incompatibility |
| 22 | Implement audit portal field views, verification status, accessibility | 15–21 | T1 portal, bounded search/export, WCAG critical workflow | cross-realm result, hidden failure, accessibility blocker |
| 23 | Run load/cardinality/search/verification/restore measurements | 9–22 | replaceable distributions and cost/skill evidence | generator saturation, hard invariant failure, unbounded cardinality |
| 24 | Complete runbooks, blind incident exercise, and separation drill | 18–23, owner assignments | exercised response/clearance/restore/support evidence | raw data/unrestricted SQL required, role collusion gap, runbook owner missing |
| 25 | Evaluate Prompt 21 primary gate | all above + HD decisions | `prompt-21-gate.json`, exact profile and expiry | any failed/missing/expired evidence, open blocking decision/ADR, residue |
| 26 | Submit result to Batch 05 reviewer | 25 | accepted/rejected conditions and conflicts | do not infer reviewer acceptance from topic result |
| 27 | Consider production-shaped activation | accepted Batch 05 review plus earlier/later gates | exact canary/pilot proposal | no production authority; any legal/privacy/support/risk decision open |

## 13.2 Parallel work allowed

After contracts/canonicalization are fixed, these may proceed in parallel:

- pure taxonomy/schema/coverage tooling;
- independent verifier and tamper corpus;
- PostgreSQL and SQL Server DDL adapters;
- portal accessibility fixture and closed field views;
- OSS reference/admission spikes;
- human decision templates and runbooks.

These may not start early:

- production-shaped privileged route enablement before atomicity and coverage gates;
- external checkpoint trust before independent verifier/key/store separation;
- audit search/export disclosure before audit-before-disclose proof;
- retention/prune before checkpoint, hold, restore, and human retention decisions;
- native DB feature selection before lifecycle/operations comparison;
- production checkpoint key, real identities, or real audit data before governance and production authority;
- any claim of regulatory sufficiency, legal admissibility, “forensic proof,” or production support.

## 13.3 Repository tasks

Minimum projects/directories:

```text
/contracts/audit/**
/src/server/modules/audit/
  Uam.Audit.Contracts/
  Uam.Audit.Domain/
  Uam.Audit.Store.Abstractions/
  Uam.Audit.Store.PostgreSql/
  Uam.Audit.Store.SqlServer/
  Uam.Audit.Writer/
  Uam.Audit.Segments/
  Uam.Audit.Checkpoints/
  Uam.Audit.Verify/                 # independent implementation boundary
  Uam.Audit.Search/
  Uam.Audit.Export/
  Uam.Audit.Retention/
/src/tools/
  Uam.AuditLab/
  Uam.AuditTamper/
  Uam.AuditVerify/
  Uam.AuditLoad/
/tests/
  audit-contracts/
  audit-architecture/
  audit-model/
  audit-atomicity/
  audit-tamper/
  audit-checkpoint/
  audit-restore/
  audit-access-export/
  audit-retention/
  audit-accessibility/
/docs/
  adr/audit/
  threat-models/audit/
  runbooks/audit/
  evidence/audit/
```

Dependency rules:

- `Uam.Audit.Domain` references no web, ORM, database provider, logging framework, portal, or native ledger API.
- `Uam.Audit.Verify` cannot reference `Uam.Audit.Writer` or its canonical/hash implementation.
- Business modules call one audit-aware transaction boundary, not a generic logger.
- Portal/search/export never references raw business tables or database provider APIs directly.
- Engine adapters cannot redefine event meaning or expected outcomes.
- OSS transparency/database references are isolated behind a lab adapter until admitted.

## 13.4 Stop/go rule

**GO** after the Prompt 21 primary gate only for an exact T1 engineering integration of portal governance and audit within the accepted Batch 05 scope.

**STOP** on any:

- successful unaudited mutation or disclosure;
- ordinary-admin undetected history alteration;
- tamper-corpus survivor;
- unverifiable restore or missing command/effect/event;
- cross-realm access;
- privacy canary escape;
- unassigned independent verifier/incident/audit owner;
- open mandatory human decision;
- hidden verification failure;
- cleanup residue;
- silent divergence from an accepted predecessor decision.

---

# 14. Open-source repository assessment

## 14.1 Assessment rule

Popularity, stars, public use, or a project calling itself immutable/production-ready is not UAM fitness. A repository becomes a dependency only after exact source/package/binary mapping, license approval, dependency/SBOM review, security/advisory review, deterministic vectors, fault tests, operations/restore evidence, named owner, update policy, and removal plan.

**RECOMMENDATION.** No reviewed transparency-log or immutable-database project is a mandatory UAM runtime dependency for the first implementation. Reuse protocols, data-structure ideas, verifier tests, fault patterns, and operational lessons. The mandatory core remains the application-owned relational event ledger plus independent UAM verifier. Tessera/witness may be used in an isolated T1 comparison if split-view resistance or externally discoverable checkpoints become a requirement.

## 14.2 Repository table

| Repository and exact review point | Relevant files/directories | License / compatibility | Maintenance and release activity | Testing and security posture | Similarities and threat-model differences | Reusable ideas / do not copy | Suitability |
|---|---|---|---|---|---|---|---|
| **Tessera** — https://github.com/transparency-dev/tessera ; tag [`v1.0.4`](https://github.com/transparency-dev/tessera/tree/v1.0.4), release 16 July 2026, commit [`6bca8e8`](https://github.com/transparency-dev/tessera/commit/6bca8e8) | `entry.go`, `log.go`, `append_lifecycle.go`, `witness.go`, storage driver directories, `cmd/fsck`, `*_test.go`, `SECURITY.md`, `.github/workflows` | Apache-2.0. Go library/service integration and cloud/POSIX drivers add a non-.NET operational and supply-chain surface. Deployment/provider licenses and costs are separate. | Active; v1.0.4 followed v1.0.3 within days to restore missed fixes. Repository describes stable API, production-ready status, migration, witness, monitoring, and multiple drivers. | Broad unit/integration tests, fault-injection and `fsck` tooling are visible; security policy uses private GitHub advisory reporting. Exact UAM storage driver, binary, and release artifact still require admission. | Similar: append-only tile/Merkle log, checkpoints, witness support, consistency and integrity tooling. Different: transparency log accepts independent entries and optimizes public/static proofs; UAM requires atomic mutation plus typed realm/purpose audit inside the business DB. | **Reuse:** tile layout concepts, checkpoint publication, witnessing, fsck, fault tests, stable entry limits, separation of log personality. **Do not copy:** external-log append as the primary transaction; public discoverability assumptions; provider-specific topology; best-effort dedupe as business identity. | **Reference first; optional isolated checkpoint/transparency prototype. Not a primary audit dependency.** |
| **Trillian** — https://github.com/google/trillian ; tag [`v1.7.3`](https://github.com/google/trillian/tree/v1.7.3), release 30 March 2026, commit [`16c60b3`](https://github.com/google/trillian/commit/16c60b3) | `server/`, `storage/`, `integration/`, `log/`, `merkle/`, `examples/deployment`, claimant-model docs, tests/Cloud Build | Apache-2.0. Go/gRPC plus storage/election/deployment stack is materially larger than UAM's initial need. | Maintained but official documentation says Trillian is in maintenance mode and recommends Tessera for new logs. v1.7.3 updated Go, PostgreSQL TLS/storage, limits, and dependencies. | Long production history, integration/storage tests, signed releases, Google vulnerability intake. Maintenance status and broad dependency/topology remain concerns for new adoption. | Similar: sequenced Merkle log and independent proofs. Different: multi-tenant transparency-log server, separate acceptance transaction, public claim/discoverability model, and broader distributed operations. | **Reuse:** consistency/inclusion proof vectors, claimant-model roles, log sequencing failure tests, quota/election lessons. **Do not copy:** large server as UAM business audit store; “exactly once” wording outside its narrow scope; legacy deployment complexity. | **Reference only. New runtime dependency rejected.** |
| **Witness** — https://github.com/transparency-dev/witness ; reviewed pseudo-version `v0.0.0-20260720115447-2e1c6971d19e`, commit [`2e1c6971d19e`](https://github.com/transparency-dev/witness/commit/2e1c6971d19e), 20 July 2026 | `witness/`, `omniwitness/`, `api/`, `client/http/`, `persistence/`, `cmd/`, `config/`, tests | Apache-2.0. Go service; SQLite persistence and HTTP operational profile are separate from UAM's C# server. No stable tagged release was found for the reviewed point. | Active commits in 2026; repository provides OmniWitness and C2SP witness compatibility. Lack of a stable tag increases pinning/support risk. | Unit/service code and C2SP protocol implementation are present. GitHub showed no repository `SECURITY.md` at review time, so vulnerability reporting/support evidence is weaker than Tessera/Rekor. | Similar: independent state, consistency proof verification, checkpoint cosigning, split-view defense. Different: assumes a verifiable transparency log and protects one checkpoint per log; it neither validates UAM business semantics nor supplies mutation atomicity. | **Reuse:** key/identity separation, trusted-first-checkpoint ceremony, consistency/cosignature state machine, conflict handling, tiny independent state. **Do not copy:** TOFU as automatic production trust; same-team witness; untagged mutable dependency. | **Reference and bounded T1 witness prototype only; no production dependency until tagged/admitted and owner assigned.** |
| **Rekor v1** — https://github.com/sigstore/rekor ; tag [`v1.5.3`](https://github.com/sigstore/rekor/tree/v1.5.3), release 2 July 2026, commit [`7d9dcff`](https://github.com/sigstore/rekor/commit/7d9dcff) | `pkg/`, `cmd/rekor-server`, `cmd/rekor-cli`, `types/`, `openapi.yaml`, `e2e-test.sh`, Docker/Trillian integration, tests and fuzzing | Apache-2.0. Go/OpenAPI/Trillian/Sigstore dependency set and software-supply-chain schemas differ from UAM. Public service is inappropriate for private audit content. | v1 remains released but official repository says it is in maintenance mode while Rekor v2/tile-based architecture is developed. Recent releases fixed vulnerabilities and dependency issues. | Sigstore security policy and response process, signed releases, e2e tests and multiple advisories are visible. Version transitions and prior SSRF/input issues reinforce the need for strict admission and no external URL-fetch semantics. | Similar: signed metadata, inclusion/integrity proof, immutable public log. Different: supply-chain artifacts, public discovery/non-repudiation, schema extensibility, separate service, Trillian v1 backend. | **Reuse:** signed entry/checkpoint/proof workflows, CLI verification UX, evidence bundles, vulnerability/advisory discipline. **Do not copy:** extensible arbitrary entry types, public upload, URL/key fetching, Rekor v1 architecture for a new private audit system. | **Reference only; v1 maintenance transition makes new dependency unsuitable.** |
| **immudb** — https://github.com/codenotary/immudb ; tag [`v1.11.1`](https://github.com/codenotary/immudb/tree/v1.11.1), release 26 June 2026, commit [`37ebcef`](https://github.com/codenotary/immudb/commit/37ebcef) | `embedded/store/`, `embedded/sql/`, `pkg/server/`, `cmd/immuadmin`, `cmd/immuclient`, `test/`, `tests/repro/`, verification/auditor code, `SECURITY.md` | Apache-2.0. New database/server/clients, Go stack, backup/HA/support and operational competence would be required; client SDK licensing/transitives need separate review. | Active; v1.11.1 followed v1.11.0 and fixed two server-crashing panics and SQL correctness issues, demonstrating both maintenance responsiveness and material regression risk. | Large test/repro surface and a detailed security policy; only latest version is stated as security-supported. Exact UAM durability, backup, HA, Windows operations, and restore remain unproved. | Similar: cryptographically coherent append-only history, client verification, structured audit features. Different: separate database transaction boundary; making it primary creates dual-write atomicity unless business state moves there, conflicting with accepted relational engine posture. | **Reuse:** verified-state clients/auditor concepts, proof/checkpoint state, corruption/recovery tests, structured audit ideas. **Do not copy:** dual-write primary audit service, “immutable means true/complete,” benchmark claims, automatic database substitution. | **Reference and isolated lab comparison only; reject as primary or default dependency.** |
| **pgAudit** — https://github.com/pgaudit/pgaudit ; tag [`18.0`](https://github.com/pgaudit/pgaudit/tree/18.0), release 24 September 2025, commit [`f39f8db`](https://github.com/pgaudit/pgaudit/commit/f39f8db) | `pgaudit.c`, `pgaudit--18.0.sql`, `test/`, `sql/`, `expected/`, `Makefile`, `.github/workflows` | PostgreSQL License. Must match exact PostgreSQL major; logging target/collector/storage licensing and operations are additional. | 18.0 added PostgreSQL 18 support and fixes; repository activity continued in July 2026. Major-version coupling requires lifecycle qualification. | Regression tests are present. GitHub showed no repository `SECURITY.md` at review time. Project warns that output can be enormous; newer development documentation describes best-effort/nontransactional logging, so exact stable behavior must be tested. | Similar: direct session/object DDL/DML/role evidence. Different: standard PostgreSQL log facility, statement/object semantics, no UAM purpose/approval/change profile, not same-transaction durable business event, vulnerable to privileged configuration/log target control. | **Reuse:** direct-DB/DDL coverage as a supplemental backstop, statement/object event catalogue, role/configuration drift tests. **Do not copy:** log text as business audit, `log_statement=all`, raw SQL/parameters, assumption of complete synchronous evidence. | **Conditional supplemental candidate only if PostgreSQL is selected and E21-21 passes.** |

## 14.3 Repository conclusions

1. **RECOMMENDATION — reference-only by default.** None solves mutation-plus-audit atomicity because each separate log/database introduces a second transaction boundary.
2. **RECOMMENDATION — Tessera before Trillian/Rekor for any new transparency spike.** Tessera is the maintained tile-based successor; Trillian and Rekor v1 explicitly point to newer architectures or maintenance modes.
3. **RECOMMENDATION — witness only after an independence requirement.** A witness adds value against split views, but it does not improve the truth/completeness of the underlying UAM events and needs a separate owner/key/account.
4. **RECOMMENDATION — immudb not as primary.** Its verified database ideas are useful; adopting it would add a database and dual-write/recovery failure domain without displacing the accepted PostgreSQL/SQL Server business transaction.
5. **RECOMMENDATION — pgAudit/SQL Server Audit only as direct-admin backstops.** They supplement but cannot replace typed application audit.
6. **UNKNOWN.** No reviewed repository has passed UAM's exact privacy, realm, Windows/server operations, backup/restore, retention, licensing, cost, and support gates.

## 14.4 Dependency-admission checklist for any future selection

A future ADR MUST record:

- immutable tag/full commit and source archive digest;
- package/container/binary-to-source mapping and signature/provenance;
- license, notices, transitive licenses, managed-service/EULA, export/compliance, and commercial support terms;
- maintained version line, release cadence, security policy, advisories, unresolved critical issues, and end-of-life/migration plan;
- required files/directories and smallest API surface;
- network, parser, storage, key, backup, HA, restore, monitoring, and privilege threat model;
- deterministic UAM vectors and malformed/fuzz/resource/fault tests;
- tenant/realm isolation, privacy-canary, metric-cardinality, and cleanup evidence;
- operator skills, staffing, incident response, cost, and removal/migration plan;
- explicit statement that the dependency is `runtime`, `build/test`, `reference only`, or `rejected`.

---
# 15. Source register with stable links, dates, reviewed versions, claims, and limitations

## 15.1 Supplied project sources

The supplied sources below are the only Project files used. Their classifications and authority limits remain in force. Accepted batch-review results are stronger predecessor decisions than the condensed shared baseline; none is runtime proof, legal approval, or production authority.

| Ref | Source and reviewed attachment | SHA-256 | Source/review date | Claim supported in this result | Limitation |
|---|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Baseline 31 July 2026 | Non-negotiable privileged-mutation audit invariant; realm, privacy, receipt, restore, and human-authority boundaries | Condensed working baseline; not technical evidence or production approval |
| I02 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Curated July 2026 evidence | Legacy schema weakness; target separation of audit, policy, deletion, integration, and typed facts; missing event/retention/query/operations evidence | Metadata-only; no row semantics, rate, quality, or production behavior proof |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | 31 July 2026 synthesis | Accepted modular-monolith, relational-inbox, database-comparison, and ordered-gate posture | Implementation research baseline, not unconditional production approval |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | July 2026 | Evidence labels, primary-source preference, CLI proof boundary, human-decision and conflict rules | Governs research quality; proves no technical claim by itself |
| I05 | `result-review-01-foundations.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Review 31 July 2026 | Strict contracts, UUIDv7, realm identity, product privacy ceiling, repository boundaries, independently verifiable artifacts, durable-audit invariant | Foundation architecture accepted with mandatory gates; no Prompt 21 runtime audit proof |
| I06 | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Review 31 July 2026 | Endpoint minimization, source/event identity, one-effect semantics, whole-page transaction, realm boundary | Endpoint source/privacy architecture; not portal audit/access evidence |
| I07 | `result-review-03-durability-release-identity.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Review 31 July 2026 | Operational logs are not privileged audit; release, identity, diagnostics, support, and compatibility controls; signed-control separation | Batch gate remains open; no production platform or audit technology approved |
| I08 | `result-review-04-server-platform.md` (local `batch-04-review-result(1).md`) | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Review 1 August 2026 | Server relational transaction boundaries, database-engine neutrality, lifecycle audit needs, restore isolation/readiness, one-effect and realm invariants | Batch proof gates remain open; database, capacity, retention, restore, and cleanup not approved |
| P21 | `Pasted text(20).txt` — Prompt 21 | `92520e530d3523a59ed8b2788af55f4c0a2065288210acf282d58dc91ea535a7` | Received 1 August 2026 | Scope, required questions, artifacts, source-review requirements, primary gate, output order, and human-decision exclusions | Task specification, not evidence that a proposed mechanism works |

## 15.2 Standards, government guidance, and security guidance

| Ref | Stable source | Source/release date and version reviewed | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| S01 | NIST SP 800-53 Rev. 5, Update 1 — https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final | Rev. 5 published 10 December 2020; Update 1 published 7 November 2023; reviewed 1 August 2026 | AU-family control objectives for event definition/content, review, protection, non-repudiation, retention, generation, and cross-organizational logging | A control catalogue, not a UAM schema, architecture, legal mapping, or implementation conformance certificate |
| S02 | NIST SP 800-92, *Guide to Computer Security Log Management* — https://csrc.nist.gov/pubs/sp/800/92/final | September 2006; reviewed 1 August 2026 | Log-management lifecycle, infrastructure, operational review, protection, and incident-use considerations | Old and general; does not define modern cloud/database tamper-evidence or UAM privacy semantics |
| S03 | OWASP Logging Cheat Sheet — https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html | Living guidance reviewed 1 August 2026 | Event attributes, sensitive-data exclusion, injection-safe encoding, logging failure testing, access and disposal considerations | Community guidance, not a formal standard or proof of complete logging |
| S04 | OWASP Log Injection — https://owasp.org/www-community/attacks/Log_Injection | Living guidance reviewed 1 August 2026 | Hostile display/export data can forge log presentation unless encoded and structurally separated | Describes a class of attack; does not provide the full audit data model |
| S05 | RFC 8785, JSON Canonicalization Scheme — https://www.rfc-editor.org/rfc/rfc8785.html | June 2020, Informational; reviewed 1 August 2026 | Deterministic canonical JSON for hashing/signing; I-JSON constraints; duplicate-property rejection; preservation of string code points | Not IETF Standards Track; number/string constraints require UAM-specific semantic validation and independent vectors |
| S06 | RFC 9162, Certificate Transparency Version 2.0 — https://www.rfc-editor.org/rfc/rfc9162.html | December 2021, Experimental; reviewed 1 August 2026 | Merkle inclusion/consistency concepts, signed checkpoints, append-only verification, and the distinction between detecting inconsistency and proving entry truth | Certificate-specific and experimental; does not supply UAM business-event completeness, realm isolation, or mutation atomicity |
| S07 | C2SP `tlog-tiles` v0.1.0 — https://c2sp.org/tlog-tiles@v0.1.0 | Versioned profile reviewed 1 August 2026 | Tile-based Merkle log/checkpoint layout and cacheable immutable resources | Public HTTP transparency profile; not required for the first private UAM checkpoint store and does not solve dual-write atomicity |
| S08 | C2SP `tlog-witness` v1.0.0 — https://c2sp.org/tlog-witness@v1.0.0 | Versioned profile reviewed 1 August 2026 | Witness consistency checking, checkpoint cosigning, atomic witness state, rollback/fork conflict behavior | Assumes an existing verifiable log; request authentication and public-witness assumptions require a separate UAM threat model |
| S09 | RFC 3161, Time-Stamp Protocol — https://www.rfc-editor.org/rfc/rfc3161.html | August 2001, Standards Track; reviewed 1 August 2026 | Optional third-party proof that a digest existed before a stated time | Does not prove event truth, completeness, sequence, or legal admissibility; TSA policy, keys, cost, and long-term validation are human/operational decisions |
| S10 | RFC 5848, Signed Syslog Messages — https://www.rfc-editor.org/rfc/rfc5848.html | May 2010, Standards Track; reviewed 1 August 2026 | Reference design for signed log blocks and detecting missing/reordered messages | Syslog/message-transport model does not fit UAM same-transaction typed business audit and is not selected |
| S18 | WCAG 2.2 — https://www.w3.org/TR/WCAG22/ | W3C Recommendation 5 October 2023; current publication reviewed 1 August 2026 | Accessible audit search, workflow, status, focus, error, authentication, and non-color-only presentation requirements | Does not prescribe UAM roles, wording, or security controls; accessibility must be tested in the actual portal |
| S19 | WCAG 2.2 Understanding 4.1.3 Status Messages — https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html | Current supporting guidance reviewed 1 August 2026 | Verification/hold/export progress and result messages must be programmatically exposed without forcing focus | Informative understanding document; actual conformance requires UI and assistive-technology testing |
| S20 | Transparency.dev, *How to design a verifiable system* — https://transparency.dev/how-to-design-a-verifiable-system/ | Living design guidance reviewed 1 August 2026 | Separate claimant, believer, verifier, claim, and action roles; define what the log proves and who verifies it | Design guidance, not a protocol or assurance certification; UAM-specific roles remain human-owned |

## 15.3 Database and platform primary documentation

| Ref | Stable source | Source/release date and reviewed version | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| S11 | Microsoft, SQL Server Ledger overview — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17 | Last updated 7 August 2025; SQL Server 2022 (16.x) and later / current v17 documentation reviewed 1 August 2026 | Ledger hashes transactions/rows into Merkle structures; external database digests support later verification; machine-controlling administrators can bypass local checks but tampering can be detected against protected digests | SQL Server-specific; detects protected ledger-state tampering but does not define UAM purpose/capability/approval semantics or prove event completeness |
| S12 | Microsoft, Ledger digest management — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-digest-management?view=sql-server-ver17 | Current documentation reviewed 1 August 2026; applies to SQL Server 2022+ and Azure SQL | Digests must be kept where database-privileged users cannot alter them; automatic Azure-backed and manual storage models; restore incarnations need distinct digest lineage | Automatic SQL Server storage is Azure-specific; storage independence, credentials, immutability, cost, and recovery remain UAM decisions/tests |
| S13 | Microsoft, Verify a ledger table/database — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-verify-database?view=sql-server-ver17 | Last updated 29 January 2026; SQL Server 2022+ / current v17 docs reviewed 1 August 2026 | Verification uses protected historical digests and reports mismatched blocks; multiple digests are needed for historical coverage; digest location must itself be trusted | Vendor procedure proves ledger consistency only for the configured database; UAM still needs independent command/effect/event and restore reconciliation |
| S14 | Microsoft, Ledger considerations and limitations — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-limits?view=sql-server-ver17 | Last updated 25 February 2026; SQL Server 2022+ / current v17 docs reviewed 1 August 2026 | Ledger is irreversible at database/table level and does not support deleting old append-only/history rows or `TRUNCATE`; lists replication/index/data-type constraints | Can conflict with approved retention/deletion and transition requirements; exact edition/topology and lifecycle cost must be tested before selection |
| S15 | Microsoft, `CREATE SERVER AUDIT` — https://learn.microsoft.com/en-us/sql/t-sql/statements/create-server-audit-transact-sql?view=sql-server-ver17 | Current v17 documentation reviewed 1 August 2026 | `ON_FAILURE=FAIL_OPERATION` can fail audited database actions when the target cannot write; default `CONTINUE` can permit unaudited operations | Captures database actions, not UAM typed business meaning; target access, configuration, rollover, direct host tampering, volume, and failover still require tests |
| S16 | PostgreSQL 18 documentation and release — https://www.postgresql.org/docs/18/ and https://www.postgresql.org/about/news/postgresql-18-released-3142/ | PostgreSQL 18.0 released 25 September 2025; current 18 documentation reviewed 1 August 2026 | Current reference engine line, transactional DDL/DML, roles, extensions, logging, backup/restore, and operational primitives available for the paired UAM prototype | PostgreSQL has no native equivalent that replaces the UAM typed application ledger; documented primitives do not prove UAM atomicity, durability, capacity, or operations |
| S17 | pgAudit repository/release — https://github.com/pgaudit/pgaudit and https://github.com/pgaudit/pgaudit/releases/tag/18.0 | pgAudit 18.0 released 24 September 2025, commit `f39f8db`; repository/release activity reviewed 1 August 2026 | PostgreSQL session/object audit coverage; current development documentation explicitly characterizes logging as best-effort and nontransactional; volume can be large | PostgreSQL-major coupling, text logs, configuration/collector failure, sensitive SQL/parameter risk, and lack of UAM typed workflow semantics make it supplemental only |
| S21 | Microsoft, Database ledger — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-database-ledger?view=sql-server-ver17 | Last updated 4 September 2024; SQL Server 2022+ docs reviewed 1 August 2026 | Block/transaction construction and database ledger internals support the native-option comparison | Implementation-specific and not a portable UAM contract |
| S22 | Microsoft, Recover a ledger database after tampering — https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-how-to-recover-after-tampering?view=sql-server-ver17 | Current documentation reviewed 1 August 2026 | Native recovery is a deliberate restore/reconciliation process, not silent history editing | Vendor procedure does not prove UAM command/effect completeness, realm isolation, or safe portal re-enablement |

## 15.4 Open-source source register

The architectural assessment is in section 14. This table records exact source identity and the narrow claim for which each repository was reviewed.

| Ref | Repository and immutable review point | Release/source date | License | Claim supported | Limitation / classification |
|---|---|---|---|---|---|
| O01 | Tessera — https://github.com/transparency-dev/tessera ; tag https://github.com/transparency-dev/tessera/tree/v1.0.4 ; commit https://github.com/transparency-dev/tessera/commit/6bca8e8 | v1.0.4, 16 July 2026 | Apache-2.0 | Maintained tile-based transparency log, checkpoints, witness integration, `fsck`, storage drivers, fault/operations patterns | **Reference; optional isolated checkpoint/transparency prototype.** Separate Go/service/storage boundary cannot be the primary mutation audit transaction |
| O02 | Trillian — https://github.com/google/trillian ; tag https://github.com/google/trillian/tree/v1.7.3 ; commit https://github.com/google/trillian/commit/16c60b3 | v1.7.3, 30 March 2026 | Apache-2.0 | Mature Merkle-log server, proof vectors, storage and sequencing lessons | **Reference only.** Official maintenance posture recommends Tessera for new logs; broad Go/gRPC/deployment surface is mismatched |
| O03 | Witness — https://github.com/transparency-dev/witness ; commit https://github.com/transparency-dev/witness/commit/2e1c6971d19e | Pseudo-version `v0.0.0-20260720115447-2e1c6971d19e`, 20 July 2026 | Apache-2.0 | Independent checkpoint state, consistency verification, cosigning, split-view/rollback conflict behavior | **Reference/bounded T1 prototype.** No stable tag at review point and no repository security policy observed; ownership/trust ceremony unresolved |
| O04 | Rekor v1 — https://github.com/sigstore/rekor ; tag https://github.com/sigstore/rekor/tree/v1.5.3 ; commit https://github.com/sigstore/rekor/commit/7d9dcff | v1.5.3, 2 July 2026 | Apache-2.0 | Signed transparency-entry/checkpoint/proof workflow, CLI verification UX, security/advisory lessons | **Reference only.** v1 maintenance transition, public supply-chain semantics, extensible entry types, and Trillian dependency are unsuitable for new UAM core use |
| O05 | immudb — https://github.com/codenotary/immudb ; tag https://github.com/codenotary/immudb/tree/v1.11.1 ; commit https://github.com/codenotary/immudb/commit/37ebcef | v1.11.1, 26 June 2026 | Apache-2.0 | Verified-state/auditor concepts, immutable database and corruption/recovery tests | **Reference/isolated comparison only.** A second database creates dual-write, backup, HA, support, migration, and operations failure domains |
| O06 | pgAudit — https://github.com/pgaudit/pgaudit ; tag https://github.com/pgaudit/pgaudit/tree/18.0 ; commit https://github.com/pgaudit/pgaudit/commit/f39f8db | 18.0, 24 September 2025; active 2026 development reviewed | PostgreSQL License | PostgreSQL-native direct SQL/DDL/session audit backstop and failure/volume test input | **Conditional supplemental candidate.** Best-effort text logging is not mutation-plus-audit atomicity or UAM business semantics |

## 15.5 Source-quality conclusions

1. **FACT.** Standards and vendor documentation establish mechanisms and control objectives, not UAM-specific fitness.
2. **FACT.** The accepted predecessor reviews establish project invariants and architecture authority, not execution evidence.
3. **INFERENCE.** The strongest portable evidence supports a layered design: relational transaction for completeness, application hash/Merkle verification for engine neutrality, and externally protected checkpoints for independence.
4. **RECOMMENDATION.** SQL Server Ledger is the most complete reviewed engine-native tamper-evidence option, but its irreversibility and retention/topology constraints prevent making it mandatory while engine and lifecycle decisions are open.
5. **RECOMMENDATION.** SQL Server Audit and pgAudit are useful for detecting direct database/DDL activity outside ordinary application paths, but neither is the authoritative UAM audit ledger.
6. **UNKNOWN.** No source proves that any selected combination meets UAM performance, restore, retention, access, key, staffing, cost, evidentiary, or production-risk requirements. Those remain CLI and human gates.

---

# 16. Confidence table for every major conclusion

## 16.1 Consolidated confidence table

| Major conclusion | Confidence | Evidence and reasoning | Evidence that would lower or change confidence |
|---|---|---|---|
| Every privileged mutation must insert its successful audit event in the same relational transaction | **High** | Direct expression of the accepted invariant; avoids an unprovable distributed dual-write; supported by predecessor transaction architecture | A smaller implementation proving the invariant through every crash/commit ambiguity without sharing the transaction |
| Audit insertion failure must prevent mutation success | **High** | Otherwise the primary gate is false by construction | A formally approved exception class with equivalent durable evidence before effect—none is currently accepted |
| The application-owned typed event is the authoritative business-audit semantic record | **High** | UAM needs actor, authenticated realm, capability, purpose, approval, target, bounded diff, result, correlation, and workflow state; native statement logs do not express these reliably | A selected engine-native mechanism proving the same closed semantics, privacy limits, compatibility, and testability without duplication |
| Successful and denied/failed privileged attempts require different transaction semantics | **High** | Successful effects can share a transaction; rejected attempts have no business effect and need a separate bounded durable attempt record | A model showing one simpler transaction/state design with no false success, duplicate attempt, or loss under response ambiguity |
| Sensitive reads and exports require audit-before-disclose | **High** | Once bytes leave the service, a later audit failure cannot recall them; the record must commit before release | A controlled disclosure mechanism that atomically couples receipt of data to durable audit through all delivery boundaries |
| Realm-scoped audit streams and a separate product-global stream are required | **High** | Preserves authenticated realm isolation and avoids one global contention/privacy domain; product-global actions have no single realm | A workload or governance model proving a different partition with equal realm isolation, ordering, verification, and restore behavior |
| Stream sequence must be allocated by the database transaction, not client time or UUID order | **High** | Database serialization is the authoritative commit order; clocks and UUID time are not trusted ordering evidence | An engine-neutral ordering primitive with stronger semantics and equal failure/restore proof |
| A hash link over canonical event content provides useful portable tamper evidence | **High** | Detects alteration, deletion, insertion, and reordering relative to a trusted anchor; independent of engine selection | A cryptographic/model defect, canonicalization differential, or unacceptable write-contention result |
| Sealed Merkle segments are preferable to publishing every event hash | **Medium-High** | Bound verification work and checkpoint volume while preserving inclusion/consistency evidence; mature transparency designs support the concept | Measured segment complexity/latency exceeding benefit, or a simpler chain checkpoint passing the same restore and proof gates |
| The canonicalization and verifier implementation must be independently owned/code-separated from the writer | **High** | Reduces common-mode defects and forged self-verification; follows accepted independent-oracle discipline | Strong formal proof or diverse generated implementation showing separation adds no detection value |
| External checkpoints are required before production approval | **High** | Local database/host administrators can alter local rows/files and recompute local state; protected off-system roots expose divergence | A threat model formally excluding privileged local administration or an equally independent hardware/platform evidence boundary |
| The external checkpoint sink need not be synchronously available for each mutation | **Medium-High** | Cross-system synchronous dependence would break local atomicity/availability; a bounded unanchored tail can be measured and held | Regulatory/evidentiary requirement for synchronous external witnessing, or risk decision disallowing any unanchored tail |
| A stale external checkpoint must eventually stop new privileged mutations | **Medium-High** | Otherwise an attacker can suppress anchoring indefinitely and expand the undetectable tail | Human-approved risk model permitting a longer/indefinite tail with compensating controls and tested response |
| Immutable object/WORM checkpoint storage is the simplest first external anchor | **Medium** | Low checkpoint rate and no approved public/multi-party transparency need; lower operational surface than a new log service | Split-view, third-party verification, discoverability, regulatory independence, or scale requirements that WORM alone cannot meet |
| A transparency log plus witness is optional, not the first mandatory dependency | **Medium-High** | Adds service, keys, storage, monitoring, availability, and supply-chain scope without solving primary mutation atomicity | Approved independent-verification requirement or demonstrated WORM insider/collusion weakness that witnessing materially reduces |
| Ordinary product and database administrators must lack delete/update/truncate rights over audit history | **High** | Directly required by the primary gate and least-authority design | An accepted operational model with equivalent non-deletion and independent detection under effective-access tests |
| Privileged host/root or engine-superuser tampering cannot be prevented completely; it must be detectable against independent anchors | **High** | Vendor documentation and threat analysis acknowledge machine-level bypass; independent digests provide containment/detection | A trusted-hardware/confidential-computing boundary with independently proved stronger prevention and recovery |
| Gaps and forks must never be silently repaired or hidden | **High** | Fabricated continuity destroys evidentiary honesty; a new declared epoch preserves uncertainty and investigation evidence | A formally verifiable recovery method that reconstructs exactly from independent authoritative copies without hiding the incident |
| Restore readiness requires chain/checkpoint verification plus command/effect/event-set reconciliation | **High** | Cryptographic consistency alone can preserve a complete but wrong/incomplete restored universe; predecessor restore invariant requires acknowledged/business completeness | A single authoritative recovery substrate that intrinsically and independently proves both integrity and completeness |
| Audit search indexes/caches are derived and cannot be verification authority | **High** | Derived stores can be stale, partial, or mutable; source ledger/checkpoints remain authoritative | A selected immutable query technology with exact source completeness and same trust boundary—still unlikely to replace source authority |
| Audit source events should not be edited for display redaction | **High** | Editing breaks immutable history; role/purpose-aware projections can minimize disclosure without changing source bytes | A retention/legal requirement demanding source-field removal and a new cryptographically verifiable supersession/redaction model |
| Retention should prune only complete sealed segments after holds, checkpoints, backups, restores, and references are reconciled | **Medium-High** | Whole-segment lifecycle avoids unverifiable holes and simplifies proof continuity | Approved field-level erasure requirement or storage evidence requiring a different cryptographic tombstone/supersession design |
| Production audit retention and access cannot be selected by research | **High** | Prompt and predecessors explicitly reserve them for human authority | Recorded decisions from accountable legal/privacy/records/security/product owners |
| The independent verifier owner cannot be selected by research | **High** | Independence is organizational authority and risk allocation, not a technical fact | Recorded accountable assignment and separation-of-duties decision |
| Regulatory/evidentiary sufficiency cannot be claimed from cryptographic design alone | **High** | Depends on law, policy, chain of custody, identity, procedures, people, jurisdiction, and admissibility | Formal determination from accountable legal/compliance/evidentiary authorities plus exercised procedures |
| Response to verification failure cannot be fully automated or selected by research | **High** | Scope, shutdown, disclosure, preservation, investigation, and recovery are risk/legal/operations decisions | Approved incident policy, authority matrix, tested runbooks, and bounded automation rules |
| SQL Server Ledger is a valuable conditional defense in depth | **High for capability; Medium for UAM fitness** | Current Microsoft docs establish ledger/digest/verification capability and machine-admin detection; UAM lifecycle/operations remain untested | SQL Server not selected, retention conflicts, unacceptable performance/operations, or failed paired restore/tamper tests |
| SQL Server Audit `FAIL_OPERATION` is a useful direct-DB backstop | **High for capability; Medium for UAM fitness** | Current docs explicitly support failing audited actions when target writes fail | Excessive availability impact, incomplete action coverage, failover/target gaps, sensitive volume, or engine not selected |
| pgAudit is supplemental only | **High** | Current project behavior is text-log based, best-effort/nontransactional, major-version coupled, and potentially high-volume | A new transactional facility or wrapper that passes complete UAM atomicity, privacy, failover, and restore gates |
| immudb, Tessera, Trillian, Rekor, or Witness should not be the primary mutation audit store | **High** | Each is a separate transaction/service or a transparency layer; adopting it creates dual-write or database-replacement consequences | A baseline change moving authoritative business state into that system with complete migration, operations, privacy, and restore proof |
| The proposed schema/taxonomy is implementation-ready at logical level | **Medium-High** | Covers every requested event family and predecessor workflow; strict fields, bounds, and examples are supplied | Contract review finding missing semantics, privacy overcollection, incompatible portal workflow, or engine constraint |
| Exact event fields, diff profiles, time precision, segment size, checkpoint interval, retry, and resource budgets are ready for production | **Low / not established** | No representative workload, retention, access, incident, or SLO inputs exist | T1/T3-safe measurements plus human decisions and compatibility evidence |
| The architecture can support at least 6,000 endpoints without audit becoming the bottleneck | **Low / not established** | Prompt scope is control-plane audit; no approved administrator/read/export rates or database topology benchmark exists | E21-17 under paired engine/load/restore conditions and approved objectives |
| The Prompt 21 primary gate is currently closed | **Low / false** | No implementation, fault injection, tamper corpus, independent checkpoint, access test, or restore drill has passed | Exact aggregate E21-28 evidence accepted by the batch reviewer and accountable human owners |

## 16.2 Residual risk — what remains unsafe, uncertain, costly, or dependent on humans

Even after this architecture is implemented correctly, the following residual risks remain:

1. **Malicious authorized software.** A compromised or intentionally malicious release can emit a coherent but false or incomplete event, misuse an approved purpose/capability, or omit a code path before the audit boundary. Hashes prove what was recorded, not that the software was honest. Containment requires reviewed contracts, release provenance, mutation tests, independent reconciliation, and separation of release/audit/verifier authority.
2. **Common-mode defects.** Writer, canonicalizer, Merkle builder, verifier, database adapter, and restore checker can share a mistaken interpretation. Separate code ownership and independent vectors reduce but cannot eliminate this risk.
3. **Unanchored tail.** Events committed after the latest externally protected checkpoint can be altered with less independent evidence if the database and local checkpoint state are both compromised. The maximum permitted tail is a **HUMAN DECISION** backed by measured checkpoint latency and a fail-closed stale-anchor rule.
4. **Collusion and ownership failure.** Product, database, verifier, object-storage, key, and incident administrators may collude or be controlled by one organization/account. Cryptography does not create organizational independence. The independent owner, credentials, billing account, support path, and emergency authority remain **HUMAN DECISION**.
5. **Key compromise or loss.** Checkpoint signing-key compromise permits forged future checkpoints; loss can block progress or complicate verification. Rotation, overlap, revocation, archival validation, recovery, and destruction require a selected KMS/HSM/PKI profile and exercised ceremonies.
6. **Clock uncertainty.** Commit sequence is reliable within a stream, but human-readable time and expiry can be wrong under clock rollback, drift, or restore. Time-stamping services can strengthen existence-time evidence but add policy, trust, cost, and long-term-validation obligations.
7. **Availability cost of fail-closed behavior.** Audit storage pressure, sequence contention, checkpoint outage, key failure, or verification hold can stop administrative changes and sensitive disclosures. This is intentional containment, but acceptable outage, emergency narrowing, and service objectives are human-owned.
8. **Database-native lifecycle conflict.** SQL Server Ledger can improve tamper detection but prevents ordinary removal of older ledger/history data and has topology/type/replication constraints. It may be incompatible with approved retention, portability, transition, or cost requirements.
9. **Restore ambiguity.** If external checkpoints, command/effect inventories, backups, keys, or audit segments are missing or disagree, research cannot prove the exact historical truth. The safe state is read/mutation blocked, with a declared gap or new epoch—not guessed repair.
10. **Privacy and insider access.** Audit metadata can reveal sensitive administrative intent, targeted subjects, investigations, exports, diagnostics, or break-glass use even without raw activity. Minimization, role/purpose filtering, rare-population protection, short-lived exports, and human access/retention policy remain essential.
11. **External copies and evidence packages.** Once an authorized audit export is downloaded or given to a third party, UAM may not control deletion, further disclosure, or evidentiary handling. The export manifest and audit trail can record this limitation but cannot erase uncontrolled copies.
12. **Regulatory and evidentiary uncertainty.** No technical design alone establishes lawful purpose, admissibility, non-repudiation, records periods, subject rights, employee consultation, or acceptable chain of custody. Those remain accountable human determinations.
13. **Operations, skills, licensing, and cost.** Independent verification, WORM/object lock, keys, restore drills, native database features, on-call response, and recurring tamper tests impose real staffing and infrastructure cost not established by supplied evidence.
14. **Impossible absolute proof.** Research and testing cannot prove that every future privileged code path, kernel, hypervisor, administrator, backup copy, or external recipient is honest. The design provides bounded prevention, independent detection, containment, and truthful uncertainty—not absolute immutability or complete forensic truth.

## 16.3 Explicit next stop/go gate

**Current decision: STOP for production.** No production privileged mutation, sensitive-detail read, audit export, break-glass action, pruning, verifier trust, or audit-based evidentiary claim is authorized.

**GO now only for T1 implementation and lab work** that preserves the accepted boundaries: strict contracts and fictional fixtures; engine-neutral writer/verifier models; same-transaction PostgreSQL and SQL Server prototypes; external checkpoint prototypes using lab-only keys/storage; hostile access/tamper/export tests; and isolated backup/restore drills.

**Next stop/go gate — `P21-AUDIT-PRIMARY`:** all of the following must pass for one exact release, schema, database profile, verifier profile, checkpoint sink, key set, and restore topology:

```text
P21_AUDIT_PRIMARY_PASS =
    PRIVILEGED_MUTATION_WITHOUT_DURABLE_SUCCESS_AUDIT = 0
    AND SENSITIVE_DISCLOSURE_WITHOUT_DURABLE_ACCESS_AUDIT = 0
    AND ORDINARY_PRODUCT_ADMIN_HISTORY_DELETE_OR_UPDATE = 0
    AND ORDINARY_DATABASE_ADMIN_UNDETECTED_HISTORY_CHANGE = 0
    AND TAMPER_ALTER_REORDER_GAP_DUPLICATE_ROLLBACK_SURVIVORS = 0
    AND CROSS_REALM_AUDIT_ACCESS_OR_STREAM_EFFECT = 0
    AND CANARY_OR_FORBIDDEN_VALUE_ESCAPES = 0
    AND RESTORE_EXTERNAL_CHECKPOINT_MISMATCHES_UNDETECTED = 0
    AND RESTORE_MISSING_OR_DUPLICATED_COMMAND_EFFECT_EVENT = 0
    AND STALE_OR_CONFLICTING_CHECKPOINT_SILENT_CONTINUATION = 0
    AND VERIFICATION_FAILURE_SELF_CLEARED = 0
    AND CLEANUP_RESIDUE = 0
    AND REQUIRED_HUMAN_DECISIONS_RECORDED
    AND INDEPENDENT_VERIFIER_AND_INCIDENT_OWNER_ASSIGNED
    AND EVIDENCE_CURRENT_AND_CONTENT_BOUND
```

The required minimum evidence is E21-00 through E21-28, including the three prompt-mandated experiments: **E21-04 audit-write failure**, **E21-09 altered/reordered/gapped synthetic records**, and **E21-12 external-digest verification after backup/restore**. A pass authorizes only the exact T1 engineering integration named by the gate record. It does not authorize retention, production access, legal/evidentiary sufficiency, pilot, or production deployment; those require the Batch 05 reviewer and the accountable human authorities.
