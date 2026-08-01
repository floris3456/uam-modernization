# Prompt 23 result — parallel-run comparison, reconciliation, compatibility projection, and migration validation

**Result path:** `results/batch-06-migration/23-parallel-run-reconciliation-result.md`  
**Research date:** 1 August 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — T1 IMPLEMENTATION PROTOTYPES MAY PROCEED; SEMANTIC PILOT, CUTOVER, ROLLBACK, AND DECOMMISSION SIGN-OFF ARE BLOCKED**  
**Blocking evidence gap:** the allowlisted `22-legacy-discovery-result.md` was not present. No substitute file was opened or used.  
**Authority boundary:** migration-validation architecture, comparison contracts, shadow paths, compatibility projection, configuration transformation, evidence, pilot gates, and rollback mechanics; **not** approval of report semantics, accepted legacy defects, tolerances, sensitive break-glass access, legal purpose, retention, production volumes, SLO/RPO/RTO, budget, staffing, pilot, cutover, decommissioning, or production deployment.

This result uses the required labels:

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed Prompt 23 implementation baseline. They do not convert an **UNKNOWN**, **HUMAN DECISION**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — use one authoritative business path and two isolated observation paths.** During a parallel run, the legacy path and the new path may independently observe the same approved source, but only one path is allowed to create business-visible effects for a given realm, cohort, semantic surface, and authority epoch. The other path is a **shadow**: it may retain minimized comparison facts in an isolated server-side namespace, but it cannot feed ordinary reports, integrations, exports, decisions, lifecycle actions, or portal views.

The endpoint MUST NOT fan one event, batch, SQL statement, or source record to both systems. The new endpoint MUST contain no legacy SQL client, legacy database credential, legacy deferred-SQL format, or legacy destination route. The legacy endpoint MUST not receive the new ingestion credential or protocol. Parallel validation is therefore **dual observation, not endpoint dual-write**.

**RECOMMENDATION — compare on the server after minimization.** A realm-scoped reconciliation service should read:

1. a bounded, read-only legacy extract;
2. the new system's isolated shadow facts and progress evidence; and
3. a deterministic **compatibility projection** derived from canonical new facts when a legacy-shaped comparison is needed.

The comparator should canonicalize both sides in memory and persist only counts, closed-range evidence, finite mismatch classes, keyed digests, multiset roots, provenance, and owner decisions. Raw source values and general row-level diffs are not a durable comparison dataset.

**RECOMMENDATION — make exact invariants zero-tolerance.** Realm isolation, authority-epoch exclusivity, endpoint dual-write prohibition, privacy canaries, source-range continuity, checkpoint ordering, stable one-effect identity, contract/version binding, and exact digest equality have no percentage tolerance. A mismatch in one of these classes pauses the affected realm/cohort automatically.

**RECOMMENDATION — allow tolerances only as explicit policy records.** A timestamp bucket, rounding rule, known legacy defect, late-arrival window, or report-specific semantic difference may be tolerated only when its exact scope, direction, reason, owner, evidence, expiry, and test are recorded. There is no generic “within X percent” escape hatch. A known legacy defect does not become the new design, and legacy output is not presumed correct.

**RECOMMENDATION — do not promote shadow history at cutover.** Shadow observations created before a cutover remain shadow evidence. A cutover establishes a new, higher authority epoch and an explicit source boundary; only records after that boundary may become new-system business effects. Rollback is another higher authority epoch with a new boundary. It is not a clock rewind and it must never allow both paths to be authoritative for the same range.

**RECOMMENDATION — keep historical legacy data read-only by default.** Do not migrate all historic rows merely because they exist. Preserve the legacy system as a restricted read-only archive for the human-approved period, or import only named datasets with typed provenance, a separately approved purpose, exact transformation evidence, and explicit `LEGACY_IMPORT` origin. Imported history must not be silently merged with native new-system facts.

## 1.2 What may proceed now

**GO** for T1 fictional implementation work:

- strict comparison, authority, window, digest, mismatch, defect, projector, configuration-transform, and evidence contracts;
- a deterministic fictional legacy/new fixture package and independent truth oracle;
- architecture tests that make endpoint dual-write structurally impossible;
- an isolated shadow namespace and no-business-egress tests;
- a server-side comparator using approved fixtures only;
- a deterministic compatibility projector with field-coverage reporting;
- configuration transformation from fictional legacy snapshots into target candidates;
- mismatch classification, owner-review, evidence packaging, and gate evaluation CLIs;
- cutover and rollback state-machine simulation with no production connection;
- current open-source/reference review and dependency-admission records.

## 1.3 What remains prohibited

**STOP** before any of the following:

- a production or employee-data parallel run;
- any endpoint component that can write both legacy and new destinations;
- two business-authoritative paths for the same range;
- shadow data appearing in ordinary reports, exports, integrations, lifecycle actions, or portal search;
- raw production row replication merely for comparison;
- a tolerance or known-defect suppression without an accountable owner and expiry;
- report-equivalence claims while required report semantics are unapproved;
- cutover, rollback, or decommission sign-off while `22-legacy-discovery-result.md` is missing;
- migration of historic legacy data without a named human-approved purpose and target contract;
- pilot or production deployment.

## 1.4 Missing-input consequence

**UNKNOWN.** The missing `22-legacy-discovery-result.md` was required same-stream evidence. The supplied legacy summaries prove direct SQL coupling, deferred executable SQL, broad schema shape, checkpoints, settings, reports/aggregates in some form, and major evidence limitations; they do not establish the exact runtime writers, report formulas, configuration authority, cutover fences, external consumers, known defects, or decommission dependencies. Therefore:

- this result can define a safe architecture and falsifiable contracts;
- it cannot certify that a specific legacy field, report, checkpoint, configuration item, or consumer is covered;
- it cannot select a final common comparison key or source fence for real cutover;
- it cannot authorize semantic pilot, cutover, rollback, or decommissioning.

The first stop/go gate is recovery and review of that exact missing file, followed by a machine-readable legacy semantic/consumer inventory built from it.

## 1.5 Confidence

| Major conclusion | Confidence | Reason | Evidence that could change it |
|---|---|---|---|
| One authoritative business path with isolated shadow comparison is the safest first design | **High** | It preserves accepted one-effect, realm, minimization, receipt, and no-silent-loss invariants while allowing direct comparison. | A smaller architecture that proves the same invariants, rollback, and evidence without a shadow namespace. |
| Endpoint dual-write should be structurally impossible | **High** | The accepted target explicitly removes endpoint SQL/database credentials; fan-out creates ambiguity, duplicate effects, and two failure domains. | A formal baseline change with new primary evidence and a smaller falsifying prototype showing dual-write is necessary and safer. |
| Server-side compatibility projection is preferable to legacy write-back | **High** | Projection keeps canonical facts authoritative and avoids giving the new system mutation authority in the legacy database. | A required consumer that cannot use a read-only projection and a proved alternative with equal isolation and rollback. |
| Keyed multiset digests plus closed-range manifests are sufficient for privacy-safe exact comparison | **Medium-High** | Standards support deterministic canonical bytes, HMAC, and Merkle structures; UAM-specific canonicalization and operational fitness remain untested. | Collision/canonicalization counterexample, unacceptable cost, or a simpler exact method with lower privacy risk. |
| Exact legacy report equivalence can be established now | **Low / not established** | Report formulas, consumers, defects, and runtime configuration are not supplied; Prompt 22 is missing. | Accepted report contracts, legacy discovery evidence, representative fixtures, and owner-approved semantics. |
| A production cutover boundary can be selected now | **Low / not established** | The common source fence and legacy write-disable mechanism are unknown. | Prompt 22 plus a successful authority-fence and rollback drill on the exact environment. |

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

- the authority model for legacy/new parallel validation;
- server-side shadow storage and compatibility projection;
- prohibition of endpoint dual-write;
- exact and tolerant comparison semantics;
- canonical comparison keys, keyed digests, multiset roots, source ranges, and time profiles;
- mismatch classification, known-defect handling, sampling, and sensitive break-glass;
- configuration transformation and validation;
- historical/read-only strategies;
- comparison evidence, owner review, pilot gates, cutover boundaries, rollback triggers, and support runbooks;
- threat modelling, privacy-safe observability, realm isolation, secure coding, accessibility, costs, skills, and architecture fitness functions within this topic.

## 2.2 Non-goals

This result does not:

- rediscover the legacy implementation in place of the missing Prompt 22 evidence;
- approve a legal/business purpose for parallel collection;
- define required production report semantics;
- declare any legacy defect accepted;
- assign real tolerance or break-glass owners;
- choose production retention, SLO/RPO/RTO, budget, pilot population, or cutover date;
- choose the production database engine, broker, portal framework, or audit technology;
- redesign endpoint acquisition, outbox, server custody, portal authorization, or lifecycle architecture outside the narrow interfaces required here;
- treat a current open-source repository as an automatic dependency.

## 2.3 Accepted supplied inputs and evidence boundary

| Ref | Allowlisted file | SHA-256 of reviewed local file | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted topology, minimization, one writer, at-least-once/one-effect, receipt, realm, release, restore, and human-decision invariants; not runtime proof. |
| I02 | `01-existing-system-evidence-summary.md` | `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | Proves legacy direct SQL, deferred executable SQL, monolithic orchestration, broad source/settings/checkpoint/report/audit presence, and static-inspection limits. |
| I03 | `04-data-and-schema-evidence-summary.md` | `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | Legacy schema shape and target typed/provenance principles; no semantics, rates, retention, query corpus, or benchmark. |
| I04 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted architecture tensions and ordered proof gates. |
| I05 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human authority, and change-proposal discipline. |
| I06 | `batch-01-review-result.md` (local `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted deterministic T1 package/oracle/canaries, strict contracts, UUIDv7/digests, executable compatibility matrices, privacy lattice, and repository boundaries. |
| I07 | `batch-02-review-result.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted source/generation/runtime/interpretation separation, source natural identity, page-owned progress, Task Host minimization, and no automatic historical reinterpretation. |
| I08 | `batch-03-review-result.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted immutable endpoint batches, durable ambiguity, receipt-gated cleanup, release/identity/diagnostic/compatibility controls, and exact-tuple evidence. |
| I09 | `batch-04-review-result.md` (local `batch-04-review-result(1).md`) | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted relational custody, immutable-vs-mutable state, global one-effect identity, typed facts/projections, reconciliation, simulator, deletion/restore, and open production gates. |
| I10 | `22-legacy-discovery-result.md` | **MISSING** | Required same-stream evidence. No substitute was used. Real semantic mapping, common cutover fence, consumer inventory, defect candidates, and decommission plan remain blocked. |

**FACT [I02–I03].** The supplied legacy evidence identifies 27 tables and 569 fields, only 13 primary keys and two physical foreign keys in the inspected DDL, direct endpoint SQL Server writes, executable deferred SQL in CSV, and implicit relationships. Static inspection does not prove every runtime SQL path, report, consumer, configuration, rate, or operational practice.

**FACT [I01, I06–I09].** The accepted target uses minimized typed events, stable identities, one endpoint writer, at-least-once delivery with one final effect, a relational custody boundary, typed facts/aggregates, strict realm authority, and explicit receipt/materialization/visibility states.

## 2.4 Evidence hierarchy for this topic

1. Accepted predecessor review decisions I06–I09.
2. Accepted baseline and gate rules I01/I04.
3. Supplied legacy/schema summaries I02/I03, within their stated limits.
4. Prompt 22 topic evidence, when restored; until then its conclusions are absent.
5. Current primary standards and official repository/release sources.
6. UAM-specific **CLI EXPERIMENT** evidence.
7. Human decisions and risk acceptance.

A legacy behavior is evidence that something occurred; it is not approval to preserve it. A passing comparison to legacy proves similarity under one profile; it does not prove correctness, lawful purpose, usability, or production fitness.

## 2.5 Terms

| Term | Normative meaning |
|---|---|
| **Authority epoch** | A monotonic, audited revision that assigns exactly one business-authoritative path for a realm/cohort/surface and names its effective source boundary. Epoch numbers never decrease. |
| **Business-authoritative path** | The only path whose facts may feed ordinary projections, reports, integrations, exports, lifecycle actions, and portal visibility for the declared scope. |
| **Shadow path** | A path that may persist minimized comparison facts and progress in an isolated namespace but has no ordinary business effect. |
| **Dual observation** | Separate legacy and new executables independently observe an approved source, each using only its own destination and identity. It is not endpoint fan-out. |
| **Endpoint dual-write** | One endpoint component, event, transaction, batch, deferred item, or source record is emitted to both legacy and new destinations, or an endpoint is equipped with authority/credentials/protocols for both. It is prohibited. |
| **Compatibility projection** | A deterministic, versioned, server-side, read-only derivation of legacy-shaped fields or report inputs from canonical new facts. It is not canonical truth and never writes the legacy database. |
| **Comparison profile** | Immutable contract defining source scopes, canonical fields, key type, time/tolerance semantics, versions, defects, limits, and evidence requirements. |
| **Comparison window** | A half-open interval and/or native source range whose two sides are closed under named watermarks before comparison is final. |
| **Exact invariant** | A property for which one mismatch is a failure; percentages and samples cannot waive it. |
| **Approved tolerance** | A narrowly scoped, owner-approved semantic relation that still produces an explicit mismatch record and expires/reviews; it is not silent equality. |
| **Known defect** | A proven, owner-approved, bounded legacy or new defect used only to classify a mismatch. It does not authorize copying the defect. |
| **Material mismatch** | Any mismatch affecting an exact invariant, approved report semantics, source coverage, identity, business effect, privacy, realm, or cutover decision. Unknown classification is material by default. |

## 2.6 Assumptions

| ID | **ASSUMPTION** | Why bounded | Smallest falsifier / consequence |
|---|---|---|---|
| A23-01 | The legacy and new paths can be assigned distinct credentials, binaries, and network destinations. | The accepted target already removes SQL/database credentials from new endpoints. | Static/binary/network inventory finds one endpoint artifact can reach both destinations; stop and redesign packaging/identity/network boundaries. |
| A23-02 | New-system shadow facts can be isolated from business projections and integrations. | The modular-monolith boundary and typed fact/projection model support separate states/namespaces. | Architecture mutation or query test shows shadow rows can reach an ordinary reader; stop before any pilot. |
| A23-03 | A read-only legacy extraction profile can be defined without arbitrary SQL or production mutation. | Legacy data is relational, but exact consumers and dynamic SQL are missing. | Prompt 22 or lab evidence shows required semantics exist only in side-effecting code; build an isolated legacy replay harness or leave the semantic unvalidated. |
| A23-04 | A meaningful subset of output can be compared after minimization without retaining raw row pairs. | The target is site/domain-level minimized output and typed facts. | Approved report semantics require an unavailable detail field; the report remains `UNREPRESENTABLE` until a human decision and new contract. |
| A23-05 | Cutover can be fenced by a common native/source boundary or a proven quiesced boundary. | Both systems have progress/checkpoint concepts, but their exact relation is missing. | Prompt 22 finds no stable common fence and quiescence cannot prove coverage; cutover remains blocked or requires a formal alternative design. |
| A23-06 | A server-side comparator can finish within an approved bounded resource budget. | Digest/partition comparison is simpler than retaining full row diffs, but distributions are unknown. | Prototype exceeds database, memory, duration, or support budget; reduce scope/partitioning or reconsider architecture by ADR. |
| A23-07 | One active IANA tzdb revision can be pinned for each comparison run. | Current tzdb releases are versioned and distributable. | A legacy report uses undocumented local rules or mutable OS behavior; classify the profile as unknown until reconstructed and approved. |

## 2.7 Unknowns that block semantic pilot or cutover

- exact legacy report formulas, filters, null/default behavior, rounding, time zones, and late-data semantics;
- complete legacy writer and consumer inventory, including manual/DEV/production differences and external integrations;
- exact legacy configuration source, overrides, precedence, mutation authority, and deployment process;
- stable legacy source/checkpoint identities and a common cutover/rollback fence;
- accepted legacy defects and their evidence;
- required report semantics and acceptable changes;
- production parallel-run purpose, permitted duplicate storage, access, and retention;
- representative event/count/byte/retry/outage distributions and comparison cost;
- accountable tolerance, defect, break-glass, migration, support, and cutover owners;
- decommission dependencies, archive duration, and legal/records obligations.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Parallel-run architecture

```text
                              RELEASE / GOVERNANCE PLANE
                 signed product ceiling + narrower realm policy
                    comparison profiles + authority epochs
                                      |
          +---------------------------+---------------------------+
          |                                                           |
 LEGACY ENDPOINT PATH                                           NEW ENDPOINT PATH
 legacy signed agent                                            Coordinator/User Host/Task Host
 legacy-only DB identity                                        new-only device identity + HTTPS
 legacy SQL Server writes                                       minimized batches only
          |                                                           |
          v                                                           v
 LEGACY DATABASE / REPORTS                                 NEW RELATIONAL CUSTODY
 business-authoritative while epoch=LEGACY                 -> shadow materialization namespace
          |                                                  (no ordinary projection/integration)
          | read-only bounded adapter                              |
          +----------------------+-------------------------------+
                                 v
                     SERVER-SIDE RECONCILIATION ZONE
          +----------------------+-------------------------------+
          | Legacy Read Adapter                                  |
          | New Shadow Read Adapter                              |
          | Canonicalizer + Keyed Digest Builder                 |
          | Compatibility Projector (new -> legacy-shaped view)  |
          | Window/Watermark Controller                          |
          | Mismatch Classifier + Known-Defect Matcher           |
          | Gate Evaluator + Evidence Packager                   |
          +----------------------+-------------------------------+
                                 |
                         finite metadata only
                                 v
              owner review / pilot gate / incident workflow

CUTOVER:
  close comparison range -> fence old writer -> higher authority epoch=NEW
  pre-cutover shadow remains shadow; only post-boundary new facts become business facts

ROLLBACK:
  pause -> close/fence new range -> higher authority epoch=LEGACY
  resume legacy only after a proved new boundary; never make both authoritative
```

### 3.1.1 Authority rule

For every tuple:

```text
(realm_id, cohort_id, semantic_surface_id, authority_epoch)
```

there MUST be exactly one value of:

```text
LEGACY_AUTHORITY | NEW_AUTHORITY | FROZEN_NO_AUTHORITY
```

`FROZEN_NO_AUTHORITY` is a deliberate safety state during cutover, rollback, incident containment, or unresolved boundary reconciliation. “Both” is not representable. Authority is about business effect, not mere physical storage.

### 3.1.2 Dual observation without endpoint dual-write

During a governed parallel run:

- the legacy executable MAY continue its existing legacy-only write path while it remains authoritative;
- the new executable MAY upload minimized new-format batches to a server shadow namespace;
- neither executable may write or fan out to the other's destination;
- the new server may compare the two server-side datasets;
- no pre-cutover shadow event may become a business effect merely because it matched;
- the parallel period itself requires a human-approved purpose, duplicate-storage period, and cohort.

Architecture tests, binary inventory, package manifests, outbound allowlists, credential inventories, and network-deny tests MUST jointly prove the endpoint dual-write prohibition. A code review statement is insufficient.

## 3.2 Components and responsibilities

| Component | Normative responsibility | Explicit prohibitions | Trust boundary / accountable function |
|---|---|---|---|
| **Authority Epoch Registry** | Store immutable monotonic authority assignments, cohort/surface scope, source boundary, activation/rollback command, evidence digest, and audit reference. | No `BOTH`; no lower epoch rollback; no payload-derived realm; no silent edit. | Migration Control / Security Governance. |
| **Legacy Read Adapter** | Execute one release-owned, read-only, parameterized extraction profile; bind exact schema/report/config revision and watermarks; emit typed in-memory rows. | No arbitrary SQL, write, stored-procedure execution with side effects, broad schema crawl, raw export, cross-realm query, or endpoint credential. | Legacy Migration Engineering. |
| **New Shadow Materializer** | Materialize validated new facts into a realm/cohort shadow state under stable identities and provenance. | No ordinary projection, integration outbox, export, lifecycle action, report visibility, or mutation of canonical authoritative facts. | New Data Platform. |
| **Compatibility Projector** | Deterministically derive legacy-shaped comparison rows/read models from canonical new facts, reference revisions, and an explicit projector profile. | No legacy DB write-back, raw source reconstruction, new fact mutation, unapproved field invention, hidden default, or production defect emulation. | Compatibility/Migration Engineering. |
| **Canonicalizer** | Apply strict field-specific type, Unicode, decimal, null, timestamp, bucket, and ordering profiles before digesting. | No locale/host default, implicit timezone, lossy parse, unknown-field ignore, or free-form plugin. | Contract Authority. |
| **Digest Builder** | Generate realm/run/profile-domain-separated HMAC row digests, duplicate multiplicities, partition roots, and exact multiset root. | No unkeyed low-entropy fingerprints, XOR/sum-only checksum, digest as business identity, or digest metric label. | Data Security / Reconciliation Engineering. |
| **Window and Watermark Controller** | Bind both sides to half-open windows/native ranges, collect closure evidence, classify late data, and create immutable superseding generations. | No final comparison on open/incomplete ranges; no timestamp-only source progress where source order differs; no mutation of closed evidence. | Data Reliability. |
| **Mismatch Classifier** | Produce one finite mismatch family, severity, materiality, evidence references, candidate cause, and required owner. | No silent suppression, free-form reason as authority, wildcard known defect, or unknown-as-tolerated. | Reconciliation Engineering. |
| **Known-Defect Matcher** | Match only immutable owner-approved defect records against exact profile/scope/version/range predicates. | Cannot suppress privacy, realm, authority, dual-write, durability, audit, or canary failures; cannot repair data. | Data Governance / Product Owner. |
| **Gate Evaluator** | Evaluate exact invariants, approved tolerances, owner decisions, evidence validity, cleanup, and rollback readiness; emit `GO`, `PAUSE`, or `STOP`. | No performance waiver of correctness; no automatic production rollback unless a pre-authorized exact rollback profile exists. | Migration Validation / Risk Authority. |
| **Evidence Store** | Retain content-addressed manifests, roots, counts, finite mismatches, approvals, versions, first failures, and cleanup receipts. | No raw URLs, paths, person data, arbitrary row dumps, credentials, database connection strings, or hidden rerun replacement. | Verification Governance. |
| **Break-Glass Sample Examiner** | Under a separately approved case, decrypt/transiently compare a deterministic minimum sample in memory and write only finite findings/evidence. | Disabled by default; no bulk download, general query, export, persistent raw cache, cross-realm sample, or sign-off solely from samples. | Independent Privacy/Security authority. |
| **Configuration Transformer** | Parse an immutable legacy configuration snapshot into a typed intermediate model, classify each element, produce a target candidate and loss/ambiguity manifest, validate narrowing, and await approval. | No arbitrary code/SQL/script execution, inferred purpose/owner, silent default, tenant broadening, or direct activation. | Configuration Migration / Product Privacy. |
| **Migration Review UI/CLI** | Show exact/tolerated/pending/unknown states, provenance, owners, limitations, and accessible review/decision workflows. | No raw activity by default, no color-only status, no hidden override, no generic SQL or file download. | Migration Operations / Accessibility. |

## 3.3 Trust boundaries

1. **Endpoint boundary.** New endpoint bytes are minimized before Coordinator IPC, durable storage, diagnostics, or transport. Legacy raw behavior is not expanded by this design.
2. **Realm boundary.** Every adapter invocation, run, key, window, query, row key, mismatch, evidence record, and approval begins with a trusted realm from authenticated server context. One run covers one realm.
3. **Legacy database boundary.** The adapter uses a dedicated read-only principal, fixed query catalogue, statement timeout, row/byte limits, and no generic SQL surface. A read replica/snapshot MAY be used if its lag and consistency are part of the window contract.
4. **Shadow/business boundary.** Shadow rows are physically or logically separated, use distinct database roles, and are absent from normal BFF, reporting, integration, export, lifecycle, and search dependencies. Architecture tests must prove this negative property.
5. **Comparator boundary.** Canonical source values exist only in bounded memory. Durable output is finite metadata and keyed digests. Process dumps, automatic tracing, raw exception messages, and general telemetry are disabled.
6. **Key boundary.** Comparison keys are purpose-separated per realm/run/profile, held by a managed key service or equivalent approved store, never logged, and retained only for the evidence period. Exact service/algorithm profile is a cryptographic **HUMAN DECISION**; HMAC-SHA-256 is the initial T1 candidate.
7. **Human-review boundary.** Reviewers see finite mismatch evidence by default. Sensitive sampling is a different capability, purpose, case, approval, expiry, audit, and cleanup path.

## 3.4 Compatibility projector boundaries

The compatibility projector is a **derived adapter**, not a second source of truth.

It MUST:

- consume only canonical minimized new facts and explicit reference/configuration revisions;
- produce an immutable output under an exact projector version and profile;
- record field coverage as `EXACT`, `DERIVED_EXACT`, `COARSENED`, `DEFAULTED_APPROVED`, `UNREPRESENTABLE`, or `PROHIBITED`;
- fail closed when a required source field, identity relation, time profile, rule revision, or realm binding is missing;
- be deterministic under the same input bytes and versions;
- preserve provenance back to event/fact IDs through opaque internal references;
- remain read-only and disposable; rebuilding it must not mutate canonical facts;
- expose only a comparison/read contract, not legacy database mutation.

It MUST NOT:

- fabricate a legacy ID from a display name or external reference;
- reconstruct URL path, query, title, user/profile path, or another forbidden value;
- reinterpret already committed source rows merely because rules changed;
- copy a known legacy defect into ordinary new-system behavior;
- hide `UNREPRESENTABLE` fields by zero/empty defaults;
- serve ordinary production consumers until a separate approved compatibility-consumer contract exists.

### 3.4.1 Projector versus comparator-only normalization

A **projector** represents intended compatibility semantics. A **comparator normalization** may account for a proven known legacy defect solely to explain a mismatch. Defect normalization MUST remain outside the production projector so that the new system does not institutionalize the defect.

## 3.5 Comparison hierarchy

Use the strongest available comparison class; do not pretend a weaker class is exact.

| Class | Canonical key | Intended use | Required evidence | Limitation |
|---|---|---|---|---|
| `EVENT_EXACT` | `(realm_id, event_id)` | Retry/replay and central one-effect comparison where a trusted crosswalk exists. | Stable event identity and same semantic payload profile. | Legacy likely lacks the target event ID; cannot be assumed. |
| `SOURCE_RECORD_EXACT` | `(realm, installation, source, generation, native_record_id)` | Exact source-row effect comparison. | Trusted legacy-to-target source/generation/native-ID mapping. | Blocked until Prompt 22 proves legacy cursor/identity semantics. |
| `SOURCE_RANGE_MULTISET` | source scope + closed native range | Exact counts/multiset roots without retaining row values. | Comparable source range and canonical row profile. | Localizes mismatches only through partition roots. |
| `BUCKET_DIMENSION_MULTISET` | approved dimensions + half-open UTC bucket | Reports/aggregates where event identity differs. | Human-approved dimensions, time/bucket semantics, and field coverage. | Cannot prove individual record identity. |
| `REPORT_CONTRACT` | report ID/revision + parameter/scope manifest | End-user report equivalence. | Approved report semantics and reference fixtures. | Missing today; legacy output is not the oracle. |
| `CONFIGURATION_CONTRACT` | config item semantic ID + revision | Configuration transform validation. | Typed source/target semantics and owner decision. | Names/values alone do not prove equivalence. |

Default production-shaped comparison MUST be no more identifying than `SOURCE_RANGE_MULTISET` or approved aggregate dimensions. Person-level comparison is absent until separately approved.

## 3.6 Known-defect register

The register starts empty. Each entry MUST include:

```text
known_defect_id
system_side = LEGACY | NEW | PROJECTOR
realm/cohort/source/report/field/profile scope
first/last affected version or range
exact mismatch family and directional effect
reproducer fixture and evidence digest
why the output is defective rather than merely different
owner and approver function
approval status and review/expiry
permitted classification only; no data rewrite
negative tests proving it cannot match outside scope
```

A known defect cannot match:

- cross-realm data;
- forbidden-value/canary escape;
- endpoint dual-write;
- dual business authority;
- cursor/checkpoint ahead;
- duplicate final business effect;
- invalid receipt/custody;
- unauthorized release/policy;
- audit absence;
- restore/readiness violation.

## 3.7 Feature flags and kill switches

Flags are finite, signed/release-owned, and may only narrow or stop:

| Flag/control | Safe meaning | Forbidden meaning |
|---|---|---|
| `parallelObservationEnabled` | Permit approved cohort dual observation under valid purpose. | Make both paths authoritative. |
| `shadowAcceptanceEnabled` | Accept new minimized batches into shadow only. | Route shadow facts to ordinary business consumers. |
| `comparisonEnabled` | Run bounded named profiles. | Execute arbitrary query/field comparison. |
| `compatibilityProjectorEnabled` | Build named projector profile. | Write legacy DB or invent fields. |
| `breakGlassSamplingEnabled` | Enable one approved case/profile until expiry. | General raw-data access or export. |
| `promotionEnabled` | Allow a gate evaluator to propose a cutover command after all prerequisites. | Bypass human cutover authority or missing evidence. |
| `realmOrCohortKill` | Pause collection/materialization/comparison for a scope. | Delete evidence or clear a hold. |

An unknown, missing, stale, downgraded, wrong-realm, or broadened control disables the affected capability.

## 3.8 Secure coding and review requirements

- Closed contracts and enums; no arbitrary SQL, regular expression, script, plugin, reflection-discovered handler, dynamic field name, file path, or destination.
- Parameterized, release-owned query templates with independent statement-readonly verification where the engine supports it.
- Streaming/bounded reads, hard row/byte/time/allocation limits, cancellation, and cleanup on every path.
- No source row or raw exception in ordinary logs, traces, metrics, audit, support, test result, or evidence package.
- Field-specific Unicode rules, fixed decimal scales, exact UTC/bucket profiles, and pinned tzdb revision.
- Independent oracle and mutation tests for canonicalization, duplicate multiplicity, range closure, tolerance matching, and gate decisions.
- Separate code owners for adapters, canonicalizer/digest, projector, mismatch policy, and gate evaluator.
- No open-source data-quality engine receives production credentials or production rows by default.
- Production build must structurally exclude test keys, raw sample exporters, arbitrary query consoles, and fault controllers.

## 3.9 Privacy-safe observability and cardinality

Metrics MAY use only finite dimensions such as:

```text
component
path_role = LEGACY_AUTH | NEW_SHADOW | NEW_AUTH | FROZEN
source_family
comparison_profile_major
projector_major
mismatch_family
severity
window_state
cohort_ring
outcome_family
```

Metrics MUST NOT label by realm, user, installation, source, event, application, report parameters, row digest, partition digest, defect ID, case ID, or arbitrary exception. Exact IDs and digests belong only in access-controlled evidence.

The catalogue MUST compute a theoretical series maximum and configure a hard SDK cardinality limit below the platform default. The exact production budget is a **HUMAN DECISION** informed by measurement. Overflow must aggregate to a finite `overflow` class and alert; it must not create unbounded labels or silently discard reconciliation evidence.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Reason | Condition that could change it |
|---|---|---|---|
| One endpoint event is written to both legacy and new systems | **REJECTED** | Creates ambiguous commit, retry, custody, privacy, and authority semantics; gives new endpoint legacy SQL authority or legacy endpoint new credentials. | Only a formal accepted-baseline change with new primary evidence and a complete atomic dual-destination protocol, which is not expected. |
| Run both systems and let both feed business reports; compare later | **REJECTED** | Two authorities can disagree, duplicate effects, and drive conflicting decisions/integrations. | No ordinary condition; one authority is a core safety rule. |
| New server writes legacy-shaped rows back into the legacy database | **REJECTED** | Adds write authority to a weakly constrained legacy schema, risks triggering unknown consumers, and makes rollback/ownership ambiguous. | A separately isolated migration staging database, not the live legacy DB, may be used if proven necessary. |
| Database trigger/CDC copies every legacy change into the new canonical model | **DEFERRED / REJECTED INITIALLY** | Copies broad sensitive schema, couples to weak implicit semantics, introduces log/CDC/broker operations, and does not prove report meaning. | A measured need, exact source contract, privacy approval, and full CDC/restore/failure prototype; no broker by default. |
| Compare full raw rows and retain every difference | **REJECTED** | Creates a second sensitive data warehouse and uncontrolled access/retention obligation. | A narrowly approved break-glass case may inspect a minimum deterministic sample transiently, never as the default evidence model. |
| Treat legacy output as the truth oracle | **REJECTED** | Legacy behavior proves existence, not correctness; known defects and report semantics are unresolved. | Legacy may be one side of evidence after independent contracts and owner-approved semantics exist. |
| Accept a generic percentage count tolerance | **REJECTED** | Can conceal systematic loss, duplicates, realm mix, or source gaps and has no semantic owner. | A narrowly scoped tolerance record with direction, rationale, owner, expiry, and tests. |
| Use unkeyed SHA-256 of raw host/identity or low-entropy fields | **REJECTED** | Enables dictionary attacks and stable cross-run linkage. | High-entropy opaque identifiers may be hashed as content evidence; comparison rows use per-run/realm keyed digests. |
| Use XOR or sum of row hashes as the sole table checksum | **REJECTED** | Duplicate cancellation and algebraic collisions can hide multiset differences. | No expected change; use counted leaves and a tree root. |
| Sampling-only validation | **REJECTED FOR SIGN-OFF** | Samples cannot prove exact invariants or rare systematic errors. | Deterministic samples remain diagnostic aids after aggregate/exact gates identify a mismatch. |
| Big-bang cutover with no shadow period | **REJECTED BY DEFAULT** | Prevents comparison, rollback evidence, support rehearsal, and source-boundary validation. | A tiny synthetic-only environment may use it; production requires explicit risk authority and equivalent proof. |
| Permanently retain legacy and new as co-authorities | **REJECTED** | Doubles operations, privacy, retention, security, and reconciliation burden indefinitely. | A legally or operationally mandated separate archive may remain read-only, never co-authoritative. |
| Migrate all historical legacy rows | **REJECTED AS DEFAULT** | Unknown semantics, poor keys, implicit relationships, privacy/retention risk, and no demonstrated consumer need. | Named datasets with approved purpose, exact mapping, provenance, deletion/restore design, and tests. |
| Use a commercial/general data-quality framework as the runtime authority | **REJECTED INITIALLY** | Broad query/plugin/output surfaces and external dependencies exceed the narrow UAM need. | Exact dependency/license/security admission and a bake-off proving lower total assurance cost without semantic loss. |
| Use Debezium/Kafka as the initial parallel-run mechanism | **REJECTED INITIALLY** | Conflicts with the accepted no-broker default and imports CDC offset, retention, schema, ACL, and recovery failure domains. | Measured fan-out/replay/isolation need plus a separate broker/CDC ADR and prototype. |
| Automatically roll back on any mismatch | **REJECTED FOR PRODUCTION DEFAULT** | Rollback itself can create a gap or overlap if the legacy fence is not ready. | Automatic rollback MAY be enabled only for an exact pre-authorized ring/profile after repeated successful fence drills; otherwise automatic action is pause. |
| Decommission immediately after a successful cutover window | **REJECTED** | Unknown consumers, reports, archive/retention, rollback, and support obligations remain. | Complete Prompt 22 evidence, consumer sign-off, read-only archive policy, rollback expiry, and decommission drill. |


---

# 5. Interfaces/protocols and example contracts or schemas — comparison contracts and digest schemas

## 5.1 Common contract rules

Every reconciliation boundary MUST use a separately named, versioned, closed contract that records:

```text
producer and every required consumer
accountable owner and support owner
trusted realm/authority source
privacy stage and permitted fields
strict schema, scalar, Unicode, time, null/absence, and ordering profile
compressed/uncompressed/row/field/depth/time/allocation limits
idempotency and immutable identity
transaction and closure meaning
retry, late-data, conflict, tolerance, and terminal behavior
compatibility, rollout, rollback, and deprecation
logs/metrics/audit/evidence allowlist
valid, boundary, invalid, hostile, old/new, and mutation vectors
runbook, cleanup, dependency, and evidence requirements
```

Objects are closed by default. Unknown authority-bearing fields, generic extension bags, remote schema references, implicit defaults, arbitrary SQL/query text, type names, scripts, and unbounded values are rejected.

## 5.2 `AuthorityEpochV1`

```json
{
  "contract": "uam.migration.authority-epoch",
  "version": "1.0.0",
  "authorityEpochId": "019d0000-0000-7000-8000-000000002301",
  "sequence": 17,
  "realmId": "019d0000-0000-7000-8000-000000002302",
  "cohortId": "pilot-fictional-a",
  "semanticSurfaceId": "edge-site-events-v1",
  "authority": "LEGACY_AUTHORITY",
  "effectiveBoundary": {
    "kind": "SOURCE_RANGE_MANIFEST",
    "manifestDigest": "sha-256:fictional-boundary"
  },
  "priorAuthorityEpochId": "019d0000-0000-7000-8000-000000002300",
  "reasonCode": "PARALLEL_VALIDATION",
  "evidenceDigest": "sha-256:fictional-evidence",
  "issuedAtUtc": "2026-08-01T12:00:00Z"
}
```

Normative rules:

- sequence is strictly increasing;
- `authority` is one of `LEGACY_AUTHORITY`, `NEW_AUTHORITY`, or `FROZEN_NO_AUTHORITY`;
- a rollback is a new higher sequence, not reuse or decrement;
- boundary and evidence are immutable content-addressed manifests;
- authenticated server context supplies realm authority; payload realm is consistency evidence only;
- activation, audit, and required control/outbox work commit atomically in the migration-control store;
- same sequence/different bytes is a security failure.

## 5.3 `ComparisonProfileV1`

```json
{
  "contract": "uam.migration.comparison-profile",
  "version": "1.0.0",
  "comparisonProfileId": "edge-site-bucket-v1",
  "profileRevision": 3,
  "sourceFamily": "EDGE_HISTORY",
  "comparisonClass": "BUCKET_DIMENSION_MULTISET",
  "leftAdapterProfileId": "legacy-edge-report-read-v1",
  "rightAdapterProfileId": "new-edge-shadow-read-v1",
  "projectorProfileId": "legacy-site-view-from-new-v1",
  "canonicalFields": [
    {"id":"application_id","type":"UUID","normalization":"NONE","required":true},
    {"id":"site_value","type":"ASCII_DNS_NAME","normalization":"LOWER_ASCII","required":true},
    {"id":"observed_bucket_start","type":"UTC_BUCKET","precision":"HOUR","required":true},
    {"id":"effect_count","type":"UINT64","required":true}
  ],
  "rowOrder": "IRRELEVANT_MULTISET",
  "timeProfileId": "utc-hour-tzdb-2026c",
  "digestProfileId": "hmac-sha256-jcs-multiset-v1",
  "knownDefectRegisterRevision": 0,
  "toleranceSetRevision": 0,
  "limitsProfileId": "reconcile-bounded-t1-v1",
  "productCeilingDigest": "sha-256:fictional-ceiling",
  "status": "T1_ONLY"
}
```

A comparison profile is release-owned. Tenant/realm configuration may disable it, narrow its cohort/window, or select stricter output, but cannot add fields, query text, normalization code, tolerances, defects, or destinations.

## 5.4 `ComparisonWindowV1`

```json
{
  "contract": "uam.migration.comparison-window",
  "version": "1.0.0",
  "comparisonWindowId": "019d0000-0000-7000-8000-000000002310",
  "runGeneration": 1,
  "realmId": "019d0000-0000-7000-8000-000000002302",
  "cohortId": "pilot-fictional-a",
  "profileId": "edge-site-bucket-v1",
  "interval": {
    "startInclusiveUtc": "2026-07-20T00:00:00Z",
    "endExclusiveUtc": "2026-07-21T00:00:00Z"
  },
  "leftRangeManifestDigest": "sha-256:fictional-left-range",
  "rightRangeManifestDigest": "sha-256:fictional-right-range",
  "leftClosure": {"state":"CLOSED","watermarkClass":"LEGACY_DECLARED","evidenceDigest":"sha-256:fictional"},
  "rightClosure": {"state":"CLOSED","watermarkClass":"NEW_SOURCE_PROGRESS","evidenceDigest":"sha-256:fictional"},
  "lateArrivalDeadlineUtc": "2026-07-22T00:00:00Z",
  "tzdbVersion": "2026c",
  "state": "READY_TO_COMPARE"
}
```

Window rules:

- time intervals are half-open `[start, end)`;
- source-native ranges take precedence over source timestamps for continuity where available;
- a window cannot become final until both sides have closed under their declared watermark semantics and the bounded late-arrival rule has elapsed;
- late data after closure creates `runGeneration + 1` and a superseding record; closed evidence is never edited;
- different tzdb/time profiles cannot be compared as if equivalent;
- a window with missing, stale, forked, or incomparable closure evidence is `PENDING` or `BLOCKED`, never a tolerated pass.

## 5.5 Canonical row and keyed digest profile

### 5.5.1 Canonical scalar profile

Before digesting, the comparator constructs a new closed row containing only profile fields:

- UUIDs: canonical lower-case UUID text;
- integers: exact JSON integers within the declared range;
- decimals: canonical signed decimal strings with a profile-defined fixed scale; no binary floating-point comparison;
- timestamps: RFC 3339 UTC strings plus explicit source precision; bucket values are separately computed under the pinned time profile;
- time-zone-aware legacy values: original zone identifier/revision is comparison metadata only when approved; ordinary row output uses UTC bucket;
- strings: exact code points unless the field contract declares a specific normalization such as lower-case ASCII DNS or NFC;
- `null`, absent, empty string, zero, and `UNKNOWN` are distinct;
- arrays: preserve order only when order is semantic; otherwise sort by a declared canonical key before serialization;
- unknown/extra fields are rejected, not silently ignored.

The row is serialized with the reviewed RFC 8785 JCS profile after semantic validation. Fields that cannot safely fit JCS numeric/string restrictions use the canonical string forms above.

### 5.5.2 Domain-separated keyed row digest

T1 candidate:

```text
row_digest = HMAC-SHA-256(
  K_reconcile_run,
  UTF8("uam-reconcile-row/v1") || 0x00 ||
  realm_id_bytes ||
  profile_id_bytes ||
  comparison_window_id_bytes ||
  JCS(canonical_row)
)
```

Rules:

- `K_reconcile_run` is random, purpose-separated, realm/run/profile-bound, and never emitted to logs or evidence;
- the same key is used for both sides of one run only;
- keys are not reused across realms or unrelated runs;
- row digests are evidence locators, not event/business identity;
- durable evidence contains the key reference/version, not the key;
- key access, retention, rotation, and destruction are governed by a cryptographic ADR and human retention decision;
- RFC 4231 HMAC-SHA-256 vectors and UAM domain-separation vectors are mandatory tests.

### 5.5.3 Exact multiset root

A table/report comparison is a multiset, not a set. For every distinct `row_digest`, compute its exact multiplicity `m`.

```text
leaf_payload = row_digest || uint64_be(m)
```

Sort leaves lexicographically by `row_digest`. Compute a Merkle Tree Hash using the RFC 9162 domain separation and split rule:

```text
MTH(empty)  = SHA-256("")
MTH(one)    = SHA-256(0x00 || leaf_payload)
MTH(many)   = SHA-256(0x01 || MTH(left) || MTH(right))
```

where `left` is the largest power-of-two prefix smaller than the current leaf count. The run stores:

```text
row_count
unique_row_digest_count
multiset_root
partition_depth
partition_roots[]
canonical_profile_digest
digest_profile_id
```

Partition roots use a fixed prefix of `row_digest` and are generated only when needed to localize a mismatch. XOR, sum-only, average, or order-dependent concatenation is prohibited as the sole equality proof.

## 5.6 `ComparisonDigestV1`

```json
{
  "contract": "uam.migration.comparison-digest",
  "version": "1.0.0",
  "side": "LEGACY",
  "comparisonWindowId": "019d0000-0000-7000-8000-000000002310",
  "runGeneration": 1,
  "profileId": "edge-site-bucket-v1",
  "adapterProfileId": "legacy-edge-report-read-v1",
  "projectorProfileId": null,
  "canonicalProfileDigest": "sha-256:fictional-canonical-profile",
  "digestProfileId": "hmac-sha256-jcs-multiset-v1",
  "keyReferenceId": "fictional-kms-key-ref",
  "rangeManifestDigest": "sha-256:fictional-left-range",
  "rowCount": 2500,
  "uniqueRowDigestCount": 2400,
  "multisetRoot": "sha-256:fictional-root",
  "partitionDepth": 8,
  "partitionManifestDigest": "sha-256:fictional-partitions",
  "extractionEvidenceDigest": "sha-256:fictional-extraction",
  "createdAtUtc": "2026-08-01T12:10:00Z"
}
```

`side` is excluded from row digest calculation. Two sides are exact-equal only when contract/profile/range/closure/canonicalization/key references agree and all exact counts/roots agree.

## 5.7 `RangeManifestV1`

```json
{
  "contract": "uam.migration.range-manifest",
  "version": "1.0.0",
  "sourceScopeId": "fictional-source-scope",
  "sourceGenerationId": "019d0000-0000-7000-8000-000000002320",
  "rangeType": "NATIVE_INTEGER_HALF_OPEN",
  "startInclusive": 1001,
  "endExclusive": 2001,
  "observedCount": 990,
  "explicitGapCount": 10,
  "gapPolicy": "PROVED_SOURCE_DELETION_OR_ABSENCE",
  "checkpointBefore": 1000,
  "checkpointAfter": 2000,
  "closureState": "CLOSED",
  "evidenceDigest": "sha-256:fictional-range-evidence"
}
```

A count lower than range width is not automatically loss: source IDs may have legitimate gaps. The profile must distinguish an unobserved gap from a proved absent/deleted native ID. `checkpointAfter` may never advance ahead of durable represented effects/progress.

## 5.8 `CompatibilityProjectionManifestV1`

```json
{
  "contract": "uam.migration.compatibility-projection-manifest",
  "version": "1.0.0",
  "projectorProfileId": "legacy-site-view-from-new-v1",
  "projectorReleaseDigest": "sha-256:fictional-projector-binary",
  "inputFactContractVersion": "1.0.0",
  "outputContractVersion": "legacy-site-view/1.0.0",
  "referenceRevisionDigests": ["sha-256:fictional-app-registry"],
  "fieldCoverage": [
    {"legacyField":"ApplicationRef","status":"DERIVED_EXACT","source":"application_id + approved crosswalk"},
    {"legacyField":"Site","status":"EXACT","source":"canonical_site_value"},
    {"legacyField":"UserPath","status":"PROHIBITED","source":null},
    {"legacyField":"LegacyCalculatedScore","status":"UNREPRESENTABLE","source":null}
  ],
  "determinismEvidenceDigest": "sha-256:fictional",
  "status": "SHADOW_ONLY"
}
```

Every output field has exactly one coverage status. `UNREPRESENTABLE` and `PROHIBITED` are first-class results; zero, empty, or default values cannot conceal them.

## 5.9 `MismatchV1` and error taxonomy

```json
{
  "contract": "uam.migration.mismatch",
  "version": "1.0.0",
  "mismatchId": "019d0000-0000-7000-8000-000000002330",
  "comparisonWindowId": "019d0000-0000-7000-8000-000000002310",
  "profileId": "edge-site-bucket-v1",
  "family": "TIME_BUCKET_DIFFERENCE",
  "materiality": "MATERIAL_PENDING_REVIEW",
  "severity": "BLOCKING",
  "partitionToken": "opaque-partition-3f",
  "leftCount": 42,
  "rightCount": 41,
  "knownDefectMatch": null,
  "toleranceMatch": null,
  "safeEvidence": {
    "leftDigest":"sha-256:fictional",
    "rightDigest":"sha-256:fictional",
    "rangeManifestDigest":"sha-256:fictional"
  },
  "state": "CLASSIFICATION_REQUIRED",
  "ownerFunction": "UNASSIGNED"
}
```

Finite families:

| Family group | Codes | Default action |
|---|---|---|
| Harness/contract | `HARNESS_INTEGRITY`, `SCHEMA_VERSION`, `CANONICALIZATION`, `KEY_PROFILE`, `EVIDENCE_TAMPER` | Stop; result invalid. |
| Authority/security | `ENDPOINT_DUAL_WRITE`, `AUTHORITY_EPOCH_CONFLICT`, `REALM_VIOLATION`, `UNAUTHORIZED_PATH` | Immediate pause/incident. |
| Privacy | `FORBIDDEN_VALUE_ESCAPE`, `CANARY_ESCAPE`, `BREAK_GLASS_SCOPE` | Immediate pause/incident; no retry. |
| Source/progress | `SOURCE_RANGE_GAP`, `SOURCE_RANGE_OVERLAP`, `CHECKPOINT_AHEAD`, `CHECKPOINT_DIVERGENCE`, `WINDOW_NOT_CLOSED`, `LATE_PENDING` | Hold comparison/cutover. |
| Identity/effect | `IDENTITY_MAP_MISSING`, `IDENTITY_MAP_AMBIGUOUS`, `MISSING_NEW`, `EXTRA_NEW`, `DUPLICATE_NEW`, `RETRY_DEDUPE_CONFLICT`, `ONE_EFFECT_CONFLICT` | Blocking until classified/fixed. |
| Time/number | `TIMEZONE_PROFILE`, `TIME_BUCKET_DIFFERENCE`, `PRECISION_DIFFERENCE`, `ROUNDING_DIFFERENCE`, `OVERFLOW` | Blocking unless exact approved tolerance matches. |
| Rules/config | `RULE_VERSION`, `RULE_OUTCOME`, `CONFIG_TRANSFORM`, `CONFIG_BROADENING`, `PROJECTOR_VERSION`, `PROJECTOR_OUTPUT` | Pause affected capability; fix/review. |
| Legacy/report | `LEGACY_KNOWN_DEFECT`, `REPORT_SEMANTIC`, `UNREPRESENTABLE`, `EXTERNAL_CONSUMER_UNKNOWN` | Human decision; cannot auto-pass. |
| Operations | `RESOURCE_LIMIT`, `ADAPTER_TRANSIENT`, `DEPENDENCY_FAILURE`, `CLEANUP_FAILURE` | Bounded retry or stop according to profile. |
| Unknown | `UNKNOWN` | Material/blocking by default. |

Messages, SQL, row values, paths, user identifiers, and arbitrary exception text are absent from durable mismatch records.

## 5.10 Invariant/tolerance and mismatch matrices

The mismatch taxonomy and matrix are defined by `MismatchV1` in section 5.9; the exact-invariant and approved-tolerance matrices below complete the mandatory comparison artifact.


| ID | Area | Exact invariant | Detection | Tolerance allowed? | Automatic action |
|---|---|---|---|---|---|
| INV-01 | Endpoint | No artifact/process/credential/protocol can write both destinations. | Static graph, package manifest, credential and network negative tests. | **No** | Stop release/pilot. |
| INV-02 | Authority | Exactly one business-authoritative path per scope/epoch. | Authority registry uniqueness and runtime guards. | **No** | Pause scope; security incident. |
| INV-03 | Realm | No cross-realm read, key, digest, row, mismatch, cache, or evidence relation. | Realm-negative corpus and DB/API constraints. | **No** | Pause affected service/realm. |
| INV-04 | Privacy | No forbidden source value or reversible derivative crosses approved boundary or appears in comparison sinks. | Exact canaries and schema/assembly checks. | **No** | Immediate safety hold. |
| INV-05 | Source | Every compared exact range is closed, non-overlapping, and coverage-evidenced. | Range manifests and watermarks. | **No** | Keep window open/block cutover. |
| INV-06 | Progress | A checkpoint never advances beyond durable represented effects/progress. | State model and failpoints. | **No** | Pause source; durability incident. |
| INV-07 | Effect | One stable event/source identity creates one final ordinary business effect. | Central uniqueness/digest conflict. | **No** | Hold identity and cutover. |
| INV-08 | Retry | Same identity/same digest is idempotent; same identity/different digest conflicts. | Retry corpus. | **No** | Hold; do not overwrite. |
| INV-09 | Contract | Profile, schema, projector, rule, time, key, and range versions match exactly. | Manifest validation. | **No** | Comparison invalid. |
| INV-10 | Multiset | Counts, multiplicities, and exact roots match for an exact profile. | `ComparisonDigestV1`. | **No** | Classify partitions; block gate. |
| INV-11 | Rules | Same approved rule/snapshot and input produce same finite outcome. | Golden vectors and outcome counts. | **No** | Block profile. |
| INV-12 | Configuration | Target candidate never broadens product ceiling or invents semantics. | Lattice/transform validation. | **No** | Reject candidate. |
| INV-13 | Shadow | Shadow rows cannot reach ordinary projections/integrations/exports/lifecycle/read APIs. | Architecture mutation + query lineage tests. | **No** | Stop pilot; data incident review. |
| INV-14 | Evidence | First failure, manifests, decisions, and cleanup are immutable/content-addressed. | Evidence verifier. | **No** | Gate invalid. |
| INV-15 | Cutover | Old and new authority ranges have neither unproved gap nor overlap. | Boundary manifests and fence drill. | **No** | Stay `FROZEN_NO_AUTHORITY`. |

## 5.11 Tolerance matrix

| Dimension | Conservative comparison | When a tolerance may exist | Required record | Never acceptable |
|---|---|---|---|---|
| Counts | Exact integer equality under the same closed scope. | Only when an approved semantic filter intentionally excludes a precisely described class. | Filter/profile revision, directional effect, exact expected count relation, owner, expiry. | Generic percentage/count delta. |
| Source ranges/checkpoints | Exact continuity and monotonicity. | None. Late data keeps window pending. | N/A. | Gap/overlap, checkpoint-ahead. |
| Timestamps | Compare exact UTC instant when approved; otherwise compare the approved UTC bucket and source precision. | A named bucket relation or documented legacy clock/zone defect. | tzdb version, zone/offset rule, bucket size, affected range, owner. | Host locale/default timezone; broad seconds/minutes allowance. |
| Decimals/rounding | Fixed scale and rounding mode in the contract. | One named legacy/report rounding profile. | Input scale, output scale, mode, boundary vectors, owner. | Floating epsilon without semantic basis. |
| Null/default/empty | Distinct by default. | Only an approved report contract may declare an equivalence. | Exact field/state mapping and negative vectors. | Silent coalescing. |
| Identity | Exact opaque identity/crosswalk. | None for one-effect identity; aggregate comparison may use a weaker declared class. | Comparison class and limitation. | Fuzzy name/external-ID merge. |
| Rule outcomes | Exact under the same rule/normalizer/snapshot. | A version-transition window may compare each side under its own explicitly approved semantics, but it remains a semantic mismatch. | Both versions, migration rule, owner. | Treat version difference as equality. |
| Late data | Pending until closure; superseding run after closure. | Owner may approve a bounded closure rule, not missing data. | Deadline/watermark semantics and evidence. | Counting open windows as passed. |
| Retry/dedupe | Exact identity and one final effect. | None. | N/A. | Duplicate business effect. |
| Errors | Compare finite error/retry family and terminal state. | Implementation-specific safe subcodes may differ if operational meaning is approved equal. | Mapping table, retry/terminal semantics, owner. | Free-form message matching or hidden unknown. |
| Aggregates | Exact result under one approved formula, dimensions, input coverage, and rounding profile. | Explicit rounding or suppressed-small-cell policy. | Formula revision, input manifest, suppression profile, owner. | “Close enough” aggregate without lineage. |
| Reports | No claim until required semantics are approved. | Per-report field/filter/order/rounding/time/unknown-state mappings. | Report contract, owner, reference fixtures, limitations. | Legacy screenshot/output as sole truth. |

## 5.12 Known-defect and tolerance records

```json
{
  "contract": "uam.migration.known-defect",
  "version": "1.0.0",
  "knownDefectId": "KD-FICTIONAL-001",
  "systemSide": "LEGACY",
  "scope": {
    "profileId":"edge-site-bucket-v1",
    "sourceFamily":"EDGE_HISTORY",
    "windowStartInclusiveUtc":"2026-07-01T00:00:00Z",
    "windowEndExclusiveUtc":"2026-07-02T00:00:00Z"
  },
  "mismatchFamily":"TIME_BUCKET_DIFFERENCE",
  "expectedDirection":"LEGACY_ONE_BUCKET_EARLIER",
  "predicateProfileId":"legacy-dst-defect-fixture-v1",
  "reproducerDigest":"sha-256:fictional",
  "ownerFunction":"UNASSIGNED",
  "approvalState":"DRAFT",
  "expiresAtUtc":"2026-09-01T00:00:00Z"
}
```

No entry is active while owner/approval is `UNASSIGNED`/`DRAFT`. A defect/tolerance match reclassifies the mismatch as `EXPLAINED_PENDING_OWNER` or `APPROVED_TOLERANCE`; it does not delete the mismatch.

## 5.13 Configuration transformation contracts

### 5.13.1 Pipeline

```text
immutable legacy configuration snapshot
  -> strict parser
  -> Legacy Intermediate Model (LIM)
  -> per-item semantic classification
  -> pure versioned transformer
  -> Target Configuration Candidate
  -> product-ceiling/tenant-narrowing validation
  -> loss/ambiguity/conflict report
  -> human approval
  -> signed/higher-revision publication
```

### 5.13.2 Classification

| Status | Meaning | Default action |
|---|---|---|
| `EXACT` | Source and target semantics are proved equivalent. | May enter candidate. |
| `SAFE_NARROWER` | Target collects/permits less under accepted ceiling. | May enter candidate with explicit consequence. |
| `HUMAN_REQUIRED` | Business/purpose/ownership/report choice is needed. | Block item and dependent publication. |
| `UNREPRESENTABLE` | Target has no safe equivalent. | Leave disabled; record limitation. |
| `PROHIBITED` | Legacy behavior conflicts with target ceiling/invariant. | Do not transform or enable. |
| `DEFAULT_DISABLED` | Evidence is insufficient; target supports an optional feature. | Keep disabled until approved evidence. |
| `CONFLICT` | Multiple legacy sources/overrides disagree. | Block; do not guess precedence. |

### 5.13.3 `ConfigurationTransformManifestV1`

```json
{
  "contract": "uam.migration.configuration-transform-manifest",
  "version": "1.0.0",
  "legacySnapshotDigest": "sha-256:fictional-legacy-config",
  "legacyParserProfileId": "legacy-config-lim-v1",
  "transformerProfileId": "legacy-to-target-config-v1",
  "productCeilingDigest": "sha-256:fictional-ceiling",
  "targetCandidateDigest": "sha-256:fictional-target",
  "summary": {
    "exact": 12,
    "safeNarrower": 3,
    "humanRequired": 4,
    "unrepresentable": 2,
    "prohibited": 1,
    "conflict": 1
  },
  "lossManifestDigest": "sha-256:fictional-loss",
  "activationState": "BLOCKED_HUMAN_DECISIONS"
}
```

A legacy name, setting presence, script, SQL fragment, or UI option is never copied as target executable authority. Transformation produces data, not code.

## 5.14 Historical/read-only contracts

Default states:

```text
LEGACY_ARCHIVE_READ_ONLY
LEGACY_IMPORT_NOT_REQUESTED
```

A historical import, if approved, MUST have:

- exact dataset/report purpose and field profile;
- source snapshot/backup identity and extraction evidence;
- realm and subject-resolution rules;
- typed target schema and `origin = LEGACY_IMPORT`;
- immutable source/provenance digest and transform revision;
- collision policy against native new events;
- no automatic reinterpretation as endpoint-native truth;
- retention, deletion, legal hold, export, restore, and access treatment;
- quality/known-defect manifest and limitations;
- independent reconciliation and rollback/cleanup plan.

Imported facts MUST NOT reuse a new endpoint event ID unless an exact approved identity crosswalk proves they are the same effect. Otherwise they use a separate import identity namespace and cannot silently contribute twice to aggregates.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Authority lifecycle

```text
LEGACY_AUTHORITY(epoch n)
  -> CUTOVER_REQUESTED
  -> PRECONDITIONS_VERIFIED
  -> FROZEN_NO_AUTHORITY(epoch n+1)
       -> OLD_PATH_FENCED
       -> FINAL_LEGACY_RANGE_CLOSED
       -> NEW_START_BOUNDARY_VERIFIED
  -> NEW_AUTHORITY(epoch n+2)

NEW_AUTHORITY(epoch n)
  -> INCIDENT_OR_ROLLBACK_REQUESTED
  -> FROZEN_NO_AUTHORITY(epoch n+1)
       -> NEW_PATH_FENCED
       -> FINAL_NEW_RANGE_CLOSED
       -> LEGACY_RESUME_BOUNDARY_VERIFIED
  -> LEGACY_AUTHORITY(epoch n+2)

Any missing/ambiguous boundary -> remain FROZEN_NO_AUTHORITY
Any dual-authority evidence -> SECURITY_HOLD
```

The transition transaction stores the new epoch, exact scope, boundary manifest, command ID, actor/authority evidence, audit event, and required control-distribution work atomically. Cross-database or endpoint convergence is not claimed atomic: the frozen state persists until independent fencing evidence is complete.

## 6.2 Parallel-run lifecycle

```text
DRAFT
  -> PROFILE_VALIDATED
  -> T1_FIXTURE_PASSED
  -> SHADOW_BOUNDARIES_PROVED
  -> APPROVED_TO_OBSERVE
  -> CAPTURING
  -> WINDOW_DRAINING
  -> WINDOW_CLOSED
  -> DIGESTED
  -> MISMATCHES_CLASSIFIED
  -> OWNER_REVIEWED
       -> ACCEPTED_FOR_NEXT_RING
       -> BLOCKED_FIX_REQUIRED
       -> SUPERSEDED_BY_NEW_GENERATION
  -> RETIRED
```

A run cannot enter `APPROVED_TO_OBSERVE` without a purpose/duplicate-storage decision for non-T1 data. A window cannot enter `WINDOW_CLOSED` merely because wall-clock time passed.

## 6.3 Reconciliation workflow

```text
PLANNED
  -> AUTHORITY_AND_REALM_BOUND
  -> LEFT_SNAPSHOT_BOUND
  -> RIGHT_SNAPSHOT_BOUND
  -> RANGE_CLOSURE_VERIFIED
  -> EXTRACTED_BOUNDED
  -> CANONICALIZED
  -> DIGESTED
  -> ROOTS_COMPARED
       -> EQUAL_EXACT
       -> PARTITION_LOCALIZATION
           -> MISMATCHES_EMITTED
  -> DEFECT_AND_TOLERANCE_MATCHED
  -> OWNER_REVIEW
  -> GATE_EVALUATED
  -> EVIDENCE_SEALED
```

Every state transition is idempotent under stable `comparison_run_id` and input digests. Same ID/different input is an integrity conflict. A process crash after evidence commit but before response returns the committed state on retry.

## 6.4 Mismatch lifecycle

```text
DETECTED
  -> CLASSIFIED
       -> HARD_INVARIANT_FAILURE
       -> KNOWN_DEFECT_CANDIDATE
       -> TOLERANCE_CANDIDATE
       -> NEW_DEFECT_CANDIDATE
       -> REPORT_SEMANTIC_DECISION_REQUIRED
       -> UNKNOWN

KNOWN_DEFECT_CANDIDATE / TOLERANCE_CANDIDATE
  -> OWNER_APPROVED_ACTIVE
  -> OWNER_REJECTED_FIX_REQUIRED
  -> EXPIRED_REVIEW_REQUIRED

FIX_REQUIRED
  -> CORRECTED_IN_NEW_RUN
  -> RECLASSIFIED_WITH_NEW_EVIDENCE

No mismatch is deleted. Closure links to the superseding run/evidence.
```

## 6.5 Configuration transformation lifecycle

```text
SNAPSHOT_REQUESTED
  -> SNAPSHOT_CAPTURED_READ_ONLY
  -> SNAPSHOT_HASHED
  -> LIM_PARSED
  -> ITEMS_CLASSIFIED
  -> TARGET_DRAFT_GENERATED
  -> PRIVACY_AND_CONTRACT_VALIDATED
  -> LOSS_AND_CONFLICT_REVIEW
       -> BLOCKED
       -> APPROVED_CANDIDATE
  -> SIGNED_HIGHER_REVISION
  -> STAGED_SHADOW
  -> ACTIVATED_AFTER_AUTHORITY_GATE
```

A changed legacy snapshot invalidates prior transformation approval. Rollback republishes prior target semantics at a higher revision; it never reactivates arbitrary legacy script/SQL authority.

## 6.6 Compatibility projector lifecycle

```text
PROFILE_DRAFT
  -> GOLDEN_VECTORS_PASSED
  -> FIELD_COVERAGE_REVIEWED
  -> SHADOW_ENABLED
  -> DETERMINISM_AND_REALM_TESTED
  -> REPORT_COMPARISON_ONLY
  -> OPTIONAL_CONSUMER_CANDIDATE (separate human/contract gate)
  -> RETIRED
```

Projector output is rebuilt from canonical facts. It has no independent mutation API and no backfill authority over source facts.

## 6.7 Window closure and late data

1. Bind both sides to immutable extraction/range manifests.
2. Confirm left and right authority/profile versions.
3. Confirm source-native high waters or the declared aggregate closure mechanism.
4. Wait until the approved late-arrival condition is satisfied.
5. Mark the window closed in one immutable generation.
6. Compare and seal evidence.
7. If later data arrives, create a new generation referencing the prior run and classify the change; do not edit prior roots or decisions.

`LATE_PENDING` is not a pass and not a tolerance. It is an incomplete state.

## 6.8 Cutover boundary rules

The conservative first cutover profile is **pause-and-fence**:

1. Stop new work issuance for the cohort.
2. Drain or cancel in-flight legacy/new collection according to their proven state machines.
3. Enter `FROZEN_NO_AUTHORITY` at a higher epoch.
4. Revoke or technically fence legacy writes for that cohort and prove zero successful post-fence writes.
5. Close the final legacy authoritative range.
6. Bind the new shadow checkpoint and designate a first-authoritative boundary strictly after the shadow-only range.
7. Prove neither gap nor overlap under the common source/report contract.
8. Activate `NEW_AUTHORITY` at a higher epoch.
9. Enable ordinary new materialization/projections only for post-boundary identities.
10. Keep pre-cutover shadow rows permanently non-authoritative or delete them under the approved shadow-retention policy after evidence closure.

**UNKNOWN.** The actual legacy fence mechanism and common boundary are blocked by missing Prompt 22. If legacy uses shared credentials or cannot be cohort-fenced, cutover remains blocked until enterprise deployment/database controls are redesigned and tested.

## 6.9 Rollback rules

Default production action on a hard mismatch is **pause**, not immediate rollback.

Rollback requires:

- a still-supported, verified legacy release and configuration candidate;
- proof that the legacy source checkpoint can resume without skipping or re-emitting the new-authoritative range;
- a frozen state and final new range manifest;
- a higher authority epoch and new legacy start boundary;
- no promotion of shadow duplicates;
- owner-approved operational and data consequences;
- post-rollback reconciliation.

Automatic rollback MAY be used in T1/lab. Production automatic rollback is permitted only if the exact ring/profile, boundary derivation, fencing, and cleanup have repeatedly passed and the responsible human authority pre-authorized it. Otherwise the system auto-pauses and pages the owner.

## 6.10 Historical and decommission lifecycle

```text
LEGACY_ACTIVE_AUTHORITY
  -> LEGACY_FROZEN_READ_ONLY
  -> CONSUMER_DISCOVERY_COMPLETE
  -> ARCHIVE_AND_RETENTION_POLICY_ACTIVE
  -> ROLLBACK_WINDOW_EXPIRED
  -> DECOMMISSION_CANDIDATE
  -> BACKUP/RESTORE/ACCESS/EXPORT/DELETE DRILLS PASSED
  -> DECOMMISSION_APPROVED
  -> CREDENTIALS/WRITERS/ROUTES REMOVED
  -> READ_ONLY_ARCHIVE RETAINED OR DESTROYED PER POLICY
  -> CLEANUP_AND_EVIDENCE COMPLETE
```

No decommission state is legal/business completion by itself. Unknown consumers, missing reports, unresolved legal holds, unproved restore, or absent owner keep the system read-only and not decommissioned.

## 6.11 Compatibility rules

- Consumer-first: comparator/projector consumers deploy before a producer emits a new contract/profile.
- Current and rollback versions are explicitly enumerated per contract; no global “current/previous” promise.
- Profile or canonicalization changes create a new comparison generation; existing evidence is never recanonicalized silently.
- A projector change creates a new output revision and does not mutate prior comparison results.
- A time/tzdb change is a semantic input and must be recorded; comparison across versions requires an explicit transition profile.
- Unsupported/unknown fields or semantics are `UNREPRESENTABLE`/`UNKNOWN`, not defaulted.
- A deprecated legacy report cannot be removed until its consumer and replacement status are recorded.

## 6.12 Transaction boundaries

| Operation | Atomic/durable unit | Outside the transaction | Failure outcome |
|---|---|---|---|
| Authority change | New epoch + scope/boundary digest + command + audit + control/outbox seed. | Endpoint/legacy convergence and fence verification. | Remain/enter frozen; no dual authority. |
| Legacy extraction | Read-only database snapshot/transaction under one profile. | Canonicalization/digest computation. | No partial final digest; window remains pending. |
| New shadow materialization | Stable identities + shadow facts/progress under one authoritative shadow transaction. | Comparison and projection. | Retry same IDs; no business effect. |
| Compatibility projection build | One immutable projector output generation + provenance manifest. | Comparator review. | Prior generation remains; candidate rejected. |
| Digest commit | Side manifest + counts/root/partitions + evidence pointers. | Other-side extraction. | Retry by same run ID; same ID/different input conflicts. |
| Comparison decision | Both side manifests + mismatch set + gate outcome + evidence digest. | Human approval where required. | No partial pass; decision remains pending/blocked. |
| Config candidate publication | Candidate revision + semantic/loss manifest + approval/audit. | Endpoint activation/convergence. | Prior active config remains; no implicit partial activation. |
| Break-glass sample | Permit/case activation and audit are durable; raw sample stays memory-only. | Human analysis. | Expiry/canary/failure stops and cleans memory; no raw artifact. |

---

# 7. Security/privacy threat and failure register

| ID | Trigger / threat | Detection | Containment | Recovery and cleanup | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|
| T23-01 | New endpoint or legacy agent can reach both destinations. | Binary/package dependency graph, credential inventory, outbound trace, denied-write positive controls. | Block release; revoke dual credential; network deny; safety hold. | Rebuild separated artifacts, rotate credentials, re-run full gate, investigate duplicate effects. | Endpoint Security / Release. | E23-02. | Local admin/kernel could alter traffic outside UAM controls. |
| T23-02 | Both paths feed business projections for one range. | Authority uniqueness constraint, projection lineage scan, duplicate event/report probes. | Freeze scope and disable both business materializers. | Reconcile exact ranges, remove duplicate effects through governed correction, issue higher epoch. | Migration Control / Data Reliability. | E23-03/E23-18. | External/manual consumers may have acted before detection. |
| T23-03 | Shadow data leaks to portal, integration, export, lifecycle, or reports. | Architecture mutation tests, SQL lineage, API negative tests, canaries. | Disable shadow acceptance and affected reader; incident hold. | Remove leaked derived copies, re-prove deletion/restore path, fix role/schema dependencies. | Data Platform / Privacy. | E23-04. | Privileged DBA/manual exports remain a threat. |
| T23-04 | Cross-realm comparison or key reuse. | Realm-first constraints, cross-realm hostile fixtures, key-scope verification. | Reject run; revoke key; hold affected evidence. | Rotate key, delete invalid evidence, rerun realm-isolated. | Security / Reconciliation. | E23-05. | Colluding privileged admins can bypass application controls. |
| T23-05 | Raw URL/path/person/config secret enters logs/evidence. | Exact multi-encoding canaries across every sink; closed diagnostic APIs. | Stop process/run, quarantine evidence, incident response. | Delete/revert contaminated artifacts, rotate secrets if any, fix API, rerun positive controls. | Privacy Engineering / Incident Response. | E23-06. | Pagefile/EDR/hypervisor observation cannot be fully excluded. |
| T23-06 | Unkeyed or reusable digest enables dictionary/linkage attack. | Contract/schema review, key-use inventory, static rule. | Reject digest profile and evidence. | Generate new per-run key and recompute; destroy invalid evidence per policy. | Cryptographic Authority. | E23-07. | Low-entropy rows remain guessable to a party holding the key. |
| T23-07 | Weak checksum hides duplicates/collisions. | Adversarial duplicate/cancellation corpus; independent root implementation. | Mark comparison invalid. | Correct multiset algorithm and rerun all windows. | Reconciliation Engineering. | E23-08. | Cryptographic collision risk is nonzero but remote; implementation errors dominate. |
| T23-08 | Arbitrary SQL/query injection through adapter/profile. | Closed schema, static query catalogue, mutation tests, DB audit. | Reject request; disable adapter profile. | Remove unauthorized query path, rotate read credentials if exposed, review accessed data. | Legacy Migration Security. | E23-09. | Read-only queries can still cause resource exhaustion or expose broad data. |
| T23-09 | Legacy read adapter mutates or executes side effects. | Read-only principal, statement classification, transaction mode, database audit, positive-control denied write. | Terminate run; revoke principal; hold database. | Restore/check legacy state, use snapshot/replica, narrow query profile. | Database Reliability. | E23-09. | Some stored procedures/functions may hide side effects; prohibit them by default. |
| T23-10 | Projector reconstructs forbidden fields or broadens semantics. | Field-coverage manifest, canaries, dependency/assembly checks, golden negatives. | Disable projector/profile. | Remove output generation, rebuild from canonical facts after fix, investigate consumers. | Compatibility / Privacy. | E23-10. | Future reference-data changes can alter derivation. |
| T23-11 | Configuration transform silently broadens product ceiling or copies scripts/SQL. | Typed classification, privacy-lattice proof, executable-string canaries. | Reject candidate; keep active target unchanged. | Correct mapping, require human decision, publish higher safe revision. | Configuration Migration / Product Privacy. | E23-11. | Human approvers can authorize an unwise but representable setting. |
| T23-12 | Known-defect register suppresses unrelated or severe mismatches. | Exact scope predicate, mutation tests, expiry, prohibited-family guard. | Disable defect entry; block gate. | Reclassify all affected windows, investigate prior approvals. | Data Governance / Verification. | E23-12. | Colluding owner/reviewer could misclassify evidence. |
| T23-13 | Generic tolerance launders data loss. | Schema forbids percentages without semantic predicate; gate checks owner/expiry. | Treat mismatch as blocking. | Replace with exact mapping or fix system. | Data/Product Owner. | E23-13. | Social pressure may push owners to accept weak explanations. |
| T23-14 | Cherry-picked windows/samples show false success. | Pre-registered run plan, contiguous window manifest, offered/eligible population counts. | Gate invalid; freeze expansion. | Rerun complete declared population/windows; preserve first failed/excluded runs. | Verification Governance. | E23-14. | Unknown production seasonality may remain outside pilot. |
| T23-15 | Window closes before late data/source progress. | Watermark and late-deadline checks; superseding-run detector. | Reopen only by new generation; block cutover. | Wait/drain, create superseding run, reclassify. | Data Reliability. | E23-15. | Permanently unobservable source deletions cannot be recovered. |
| T23-16 | Time-zone/tzdb/clock differences misbucket events. | Pinned tzdb/version, DST/fold/gap corpus, source-precision metadata. | Block affected profile; no host-default fallback. | Approve exact mapping or fix parser/projector; rerun. | Contract/Time Semantics Owner. | E23-16. | Undocumented legacy local-time behavior may be impossible to reconstruct. |
| T23-17 | Missing/ambiguous identity crosswalk causes false missing/extra. | Crosswalk uniqueness/provenance checks; ambiguity count. | Downgrade comparison class or block report. | Human-governed mapping correction; never fuzzy-merge automatically. | Data Governance / IAM. | E23-17. | Legacy identifiers may be irreparably weak. |
| T23-18 | Retry/dedupe difference creates duplicate/missing effect. | Stable identity/digest corpus and central uniqueness. | Hold event/batch/source; stop cutover. | Reconcile same identity, correct state machine, replay under stable ID. | Data Correctness. | E23-18. | Legacy may lack an exact idempotency identity. |
| T23-19 | Legacy report semantics are guessed from output. | Report-contract gate and missing-owner check. | Label `UNAPPROVED_SEMANTICS`; block equivalence claim. | Obtain report owner/formula/fixture decision or retire report through governance. | Report Product Owner. | E23-19. | Manual spreadsheets/consumers may remain undiscovered. |
| T23-20 | Break-glass sample becomes an exfiltration path. | Permit/case/expiry/row cap, memory-only guard, canaries, audit-before-disclose. | Revoke permit; kill process; security hold. | Cleanup memory/temp, review access, rotate keys, incident response. | Independent Privacy/Security. | E23-20. | Authorized reviewer can still observe approved sample values. |
| T23-21 | Evidence, root, approval, or run is altered/rolled back. | Content-addressed manifests, chain/checkpoint, independent verifier, first-failure ledger. | Mark gate invalid; freeze expansion. | Restore authoritative evidence, rerun if necessary, investigate admin boundary. | Verification Governance / Audit. | E23-21. | Collusion across application, DB, verifier, and key admins remains. |
| T23-22 | Cutover leaves a source gap or overlap. | Old/new boundary manifests, denied-write trace, positive/negative probes. | Stay `FROZEN_NO_AUTHORITY`; no report activation. | Correct fence/boundary, replay only under approved stable identities, rerun. | Migration Control / Data Reliability. | E23-22. | Source activity during a long freeze may be lost by legacy source retention. |
| T23-23 | Legacy writes continue after cutover. | DB audit/write counters by credential/cohort, network/credential revocation evidence. | Disable new business activation or freeze both. | Fence/rotate credentials, classify post-boundary writes, correct duplicates. | Legacy Operations / Security. | E23-22. | Shared legacy credentials may make cohort-level attribution difficult. |
| T23-24 | Rollback resumes from wrong checkpoint. | Rollback rehearsal, range closure, source progress comparison. | Do not resume authority; remain frozen. | Repair/derive safe boundary or accept bounded outage through human decision. | Migration Control. | E23-23. | Some source records may be deleted before recovery. |
| T23-25 | Comparator overload harms production DB/ingestion. | Bounded resource metrics, query plans, cancellation, concurrency limits. | Throttle/stop comparison; business path remains prioritized. | Reschedule to snapshot/replica, repartition, tune after evidence. | SRE / Database Reliability. | E23-24. | Large history/poor legacy indexes may make exact comparison costly. |
| T23-26 | Metric cardinality or evidence volume explodes. | Theoretical catalogue bound and runtime hard cap. | Aggregate overflow; pause new profile. | Reduce dimensions/partition depth; preserve core mismatch counts. | SRE / Privacy. | E23-24. | Excess aggregation can reduce diagnosis quality. |
| T23-27 | OSS dependency/plugin leaks data or changes semantics. | Exact source/package/binary lock, SBOM, no-egress test, admission review. | Remove/disable dependency; isolate lane. | Replace with UAM code/reference implementation, rerun evidence. | Dependency Security / Legal. | E23-25. | Transitive supply-chain compromise remains possible. |
| T23-28 | Review workflow is inaccessible or ambiguous. | Keyboard/AT/status-language tests; no color-only state. | Block decision capability; provide accessible non-bypass workflow. | Fix UI/report and rerun task test. | Accessibility / Migration Operations. | E23-26. | No standard covers every user need. |
| T23-29 | Owner absent; mismatches remain operationally ignored. | Gate requires assigned owner/support/runbook. | Keep capability disabled/block expansion. | Assign accountable function, exercise runbook. | Engineering/Operations Leadership. | E23-27. | Staffing turnover can invalidate ownership later. |
| T23-30 | Missing Prompt 22 is silently replaced by inference. | Input manifest exact filename/hash gate. | Block semantic pilot/cutover/decommission. | Restore and review exact file; update result through reviewer/ADR. | Research/Migration Governance. | E23-01. | The recovered result may still contain unproved conclusions. |

## 7.1 Incident response and support ownership

Minimum runbooks before a real parallel run:

1. endpoint dual-write or dual-authority detection;
2. cross-realm comparison/evidence contamination;
3. privacy canary/raw-value escape;
4. source-range/checkpoint gap or overlap;
5. duplicate final business effect;
6. stale/incorrect time or projector profile;
7. known-defect/tolerance misuse;
8. comparator/database overload;
9. cutover freeze that cannot establish a safe boundary;
10. failed rollback or continued legacy writes;
11. evidence tamper/rollback or missing first failure;
12. break-glass misuse/cleanup failure;
13. unknown report consumer discovered after cutover;
14. decommission rollback/archive recovery.

Each runbook names trigger, automatic containment, human authority, evidence, communication, rollback/fix, cleanup, neighboring-cohort protection, and re-enable criteria. No runbook may advise raw database mutation, arbitrary SQL, deleting evidence, or making both paths authoritative.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Smallest falsifying prototypes

### Prototype P23-A — exact multiset comparison

- **Setup:** two T1 NDJSON fixtures of 20 fictional rows, including duplicates, null/empty, Unicode boundaries, fixed decimals, equal timestamps, and one intentional missing duplicate.
- **Instrumentation:** canonical-byte capture by digest only, row multiplicity ledger, independent root calculator, allocation/time counters, canary scanner.
- **Steps:** validate schema; canonicalize twice in separate processes; compute keyed row digests and roots; mutate one duplicate count; compare.
- **Pass:** clean fixtures produce identical roots; duplicate mutation changes count/root and localizes to the correct partition; no raw row in logs/evidence.
- **Fail:** nondeterministic canonical bytes, same root after multiplicity change, canary escape, or unbounded resource use.
- **Evidence:** fixture root, profile digest, key reference, both implementations' roots, mutation result, cleanup receipt.
- **ESTIMATE duration:** 5–15 minutes after build.
- **Cleanup:** delete generated raw fixtures from the run workspace after the canonical package/evidence digest is retained.

### Prototype P23-B — authority and shadow isolation

- **Setup:** fictional realm/cohort, mock legacy writer, new shadow writer, business projection, integration outbox, and authority registry.
- **Instrumentation:** DB constraints, SQL/API lineage, outbound counters, fault hooks before/after authority commit.
- **Steps:** attempt both authority values; insert shadow facts; query ordinary surfaces; simulate response loss; flip to frozen/new epochs.
- **Pass:** `BOTH` cannot be represented; shadow creates zero business/projection/integration effects; retry returns one epoch; wrong realm denied.
- **Fail:** one shadow row appears ordinarily, two authorities commit, or retry creates two epochs.
- **Evidence:** state history, constraints, negative query results, audit/evidence digest.
- **ESTIMATE duration:** 15–30 minutes.
- **Cleanup:** drop fictional realm database/schema and verify no residue.

### Prototype P23-C — configuration transform

- **Setup:** fictional legacy snapshot with exact, narrower, conflicting, prohibited, script/SQL-looking, missing-owner, and unrepresentable settings.
- **Instrumentation:** strict parser, privacy-lattice evaluator, target schema validator, executable-string canaries.
- **Steps:** hash snapshot; parse LIM; transform; classify; mutate precedence and ceiling; attempt activation.
- **Pass:** only exact/safe-narrower items enter candidate; every other item blocks or remains disabled; script/SQL never executes; mutation broadening is rejected.
- **Fail:** silent default, guessed precedence, target broadening, executable content, or activation with unresolved item.
- **Evidence:** snapshot/transform/loss manifests and mutation results.
- **ESTIMATE duration:** 10–20 minutes.
- **Cleanup:** remove candidate and test keys; retain content-addressed evidence only.

### Prototype P23-D — cutover/rollback fence simulator

- **Setup:** deterministic source IDs 1–100, legacy authoritative through a chosen boundary, new shadow processing, in-flight failures, and a simulated legacy writer that tries post-fence writes.
- **Instrumentation:** authority history, range manifests, write-deny counters, business-effect ledger.
- **Steps:** freeze; fence; close left/right; activate new after boundary; inject post-fence legacy writes; trigger rollback; vary checkpoints.
- **Pass:** no range becomes authoritative twice; no unproved gap; post-fence writes are denied/quarantined; unsafe rollback remains frozen.
- **Fail:** duplicate business effect, hidden gap/overlap, lower epoch, or automatic unsafe resume.
- **Evidence:** complete state history, range/effect oracle, first failure, cleanup.
- **ESTIMATE duration:** 15–30 minutes.
- **Cleanup:** reset simulator state and prove deterministic replay.

## 8.2 Detailed matrix

All durations below are **ESTIMATE** for T1 planning and must be replaced by measured execution evidence. Every test uses fictional or approved aggregate fixtures and emits no internal address, credential, raw production value, or SSH material.

| ID | Test / setup | Instrumentation and steps | Pass | Fail / stop | Evidence | Est. duration | Cleanup |
|---|---|---|---|---|---|---|---|
| E23-01 | **Input-manifest gate.** Hash every allowlisted file and require Prompt 22. | Compare exact names/hashes; reject extra/substitute input. | All required inputs present and recorded for semantic work. Current run records Prompt 22 missing and blocks named gates. | Missing/substituted input treated as present. | `input-manifest.json`, missing list. | <5 min | None. |
| E23-02 | **No endpoint dual-write.** Build endpoint artifacts and hostile mutations. | Dependency graph, strings/imports, package file manifest, credential/API inventory, outbound capture; inject SQL client/new-ingress fan-out mutation. | Clean artifacts expose one destination family each; every mutation fails; denied positive control is detected. | Any binary/credential/protocol reaches both destinations or mutation passes. | Graph, SBOM, file hashes, outbound summary, mutation report. | 15–45 min | Remove test credentials/rules; verify tree clean. |
| E23-03 | **Authority uniqueness and idempotency.** T1 DB/model. | Concurrent commands, same ID/same bytes, same ID/different bytes, stale epoch, wrong realm, crash hooks. | One monotonic epoch; no `BOTH`; stable retry; conflicts/realm denied. | Duplicate/lower epoch, dual authority, wrong realm accepted. | State histories, transaction logs by finite code, oracle diff. | 15–30 min | Drop fixture DB. |
| E23-04 | **Shadow non-egress.** Insert fictional shadow facts. | Query every ordinary API/report/projection/integration/export/lifecycle path; architecture mutations add a dependency. | Zero ordinary rows/messages/effects; every dependency mutation fails. | Any shadow effect reaches business surface. | Route/query matrix, outbox counts, mutation results. | 30–60 min | Delete shadow fixture and confirm zero copies. |
| E23-05 | **Realm isolation.** Two fictional realms with colliding IDs/digests. | Cross-realm adapters, caches, keys, evidence lookups, projector, defect register. | Zero cross-realm relation/existence leak; distinct keys/roots. | Any cross-realm result or shared key scope. | Realm-negative corpus and DB/API evidence. | 20–40 min | Destroy realm test keys/data. |
| E23-06 | **All-sink privacy canaries.** Plant raw URL/path/user/config secret canaries. | Scan memory-safe outputs, stdout/stderr, logs, traces, metrics, DB dumps, evidence, crash/support artifacts; positive controls. | Every mandatory positive control detected; production candidate emits zero canaries. | One missed positive control or one candidate escape. | Sink/encoding matrix, scanner hashes, redacted result. | 30–90 min | Delete contaminated artifacts; revert VM/container. |
| E23-07 | **Key/digest profile.** RFC/UAM vectors. | HMAC-SHA-256 vectors, per-realm/run separation, wrong-key tests, key-log canaries. | Exact vectors; cross-key roots differ; no key bytes in sinks. | Vector failure, key reuse, key leak. | Vector report and key-reference inventory. | 10–20 min | Destroy T1 keys. |
| E23-08 | **Canonicalization and multiset root.** Hostile scalar/duplicate corpus. | Two independent implementations; JCS vectors; decimal/time/null/Unicode/order mutations; duplicate cancellation attacks. | Byte/root equality for valid cases; every semantic mutation detected; invalid input rejected. | Nondeterminism, XOR-like cancellation, unknown accepted. | Golden vectors, roots, minimal counterexamples. | 20–60 min | Delete generated raw corpus after package digest. |
| E23-09 | **Legacy adapter read-only/bounds.** Isolated synthetic SQL Server schema only. | Fixed query catalogue, statement-readonly/permissions, DB audit, timeout/cancel, row/byte limits, write/procedure mutations. | Exact expected typed rows; zero mutation; all arbitrary/side-effecting attempts denied; bounded recovery. | Successful write/side effect, raw leak, unbounded query. | Query profile hashes, audit summary, plan class, cleanup. | 30–90 min | Drop DB/user; confirm no objects/residue. |
| E23-10 | **Compatibility projector.** Golden input/output and forbidden fields. | Pure model, deterministic rebuild, field-coverage manifest, projector-version mutation, canaries. | Exact bytes/root; prohibited/unrepresentable stay explicit; no source mutation. | Invented/defaulted field, raw reconstruction, nondeterminism. | Projector manifest, vectors, provenance, mutation report. | 20–60 min | Delete derived generation. |
| E23-11 | **Configuration transformation.** Fictional snapshot. | LIM parser, classification, precedence conflicts, privacy-lattice/property tests, executable-string canaries. | No broadening/guess/execution; unresolved blocks activation. | Any forbidden/defaulted/ambiguous item activates. | Snapshot/target/loss manifests and counterexamples. | 20–45 min | Delete candidate/test keys. |
| E23-12 | **Known-defect matching.** Scoped fictional defects. | Boundary/version/range/family mutations; prohibited-family attempts; expiry clock. | Match only exact intended mismatches; hard families never match; expiry blocks. | Wildcard/overbroad or security failure suppressed. | Match matrix and mutation results. | 15–30 min | Remove test register. |
| E23-13 | **Tolerance enforcement.** Candidate bucket/rounding/null tolerances. | Owner/expiry missing, generic percent, direction, scope, boundary values, stale approval. | Only exact active records classify; mismatch remains visible. | Unowned/expired/generic tolerance passes. | Tolerance matrix, decision history. | 15–30 min | Remove test approvals. |
| E23-14 | **Run selection/cherry-pick guard.** Pre-registered contiguous windows. | Exclude failed window, rerun, sample only, alter eligible population; compare manifest. | Gate includes all declared windows/first failures and reports exclusions. | Selected success hides failure or population drift. | Run-plan/eligibility/evidence reconciliation. | 15–30 min | None beyond fixture cleanup. |
| E23-15 | **Closure/late-data.** Deterministic source schedule. | Delayed records, watermark stalls, post-close arrival, superseding generations, retries. | Open stays pending; close only when valid; late arrival creates new generation. | Closed evidence edited or pending treated pass. | Window histories and roots. | 15–30 min | Reset clock/schedule. |
| E23-16 | **Time/tzdb/DST.** Pinned 2026c and prior revision fixtures. | UTC/local offsets, fold/gap, historical/future rule, precision, RFC 3339/9557 vectors, host-locale changes. | Exact profile behavior independent of host locale; version mismatch explicit. | Silent host default, ambiguous local accepted, unexpected bucket. | Time profile/vector report. | 20–45 min | Restore locale/timezone. |
| E23-17 | **Identity/crosswalk.** Collisions, missing IDs, names, external refs. | Exact uniqueness/provenance, fuzzy/name attempts, split/merge cases. | Ambiguous/missing never auto-merge; comparison class downgrades or blocks. | Display/name/external reference becomes authority. | Crosswalk ledger and negative results. | 15–30 min | Delete fictional mapping. |
| E23-18 | **Retry/dedupe/one effect.** Same IDs and conflicting payloads. | Response loss, duplicate batches, event conflict, projector retry, concurrent workers. | Same/same one result; same/different hold; one business effect. | Duplicate effect, overwrite, lost stable ID. | State histories and central identity counts. | 30–60 min | Drop fixture state. |
| E23-19 | **Report contract harness.** Fictional report formulas only. | Independent expected results, filters, time/rounding/null/unknown states, projector outputs. | Exact contract passes; absent owner/semantics remains blocked. | Legacy output automatically accepted or unapproved report marked pass. | Report contract/vectors/decision. | 20–60 min | Delete report fixture. |
| E23-20 | **Break-glass sample.** Disabled default and approved fictional case. | Permit, purpose, scope, deterministic sample, memory guard, audit-before-disclose, expiry/revoke, canaries. | No access by default; exact bounded case works; raw never durable; expiry cleanup. | Broad/download/cross-realm/raw artifact or stale permit. | Permit/audit/finite findings/cleanup. | 30–60 min | Kill process, destroy key, scan/revert. |
| E23-21 | **Evidence tamper/rollback.** Alter root, decision, sequence, manifest, first failure. | Independent verifier/checkpoint; old-backup evidence restore. | Every alteration/gap/fork/stale input detected; no self-clear. | Tamper survives or local rollback trusted. | Verifier findings and restored comparison. | 30–90 min | Revert evidence lab. |
| E23-22 | **Cutover fence.** Simulator then exact disposable environment after prerequisites. | Freeze, old credential/write fence, final ranges, new boundary, post-fence attempts, business probes. | Zero post-fence legacy writes; no gap/overlap; only post-boundary new effects visible. | Any dual/unknown range or continued write. | Authority/range/write/probe evidence. | 30–120 min | Restore old state or destroy environment. |
| E23-23 | **Rollback fence.** From new authority under faults. | Freeze new, close range, verify legacy candidate/checkpoint, resume higher epoch, delayed writes. | Safe profile resumes without duplicate/gap; unsafe remains frozen. | Automatic wrong-boundary resume or lower epoch. | Full rollback state history and oracle. | 30–120 min | Return lab to clean baseline. |
| E23-24 | **Resource/cardinality/cost.** Synthetic scale sweep. | Offered rows/windows, DB reads, CPU/memory, duration, locks, metric series, evidence bytes; compare baseline. | Correctness at all loads; bounded cancellation; no business-path harm; owner-approved budget candidate. | Saturated generator, invariant failure, uncontrolled lock/load/cardinality. | Raw safe metrics, workload manifest, cost model. | 1–8 h staged | Stop load, drop data, verify DB health. |
| E23-25 | **Dependency admission/no-egress.** Exact candidate tool builds. | Source/package/binary/license/SBOM, network-denied run, plugin/config mutations, vulnerability review. | No unexpected egress/plugin/query; exact provenance; legal status accepted for lane. | Unknown binary, telemetry, dynamic code, credential leak, license blocker. | Admission record and egress log. | 30–120 min/tool | Destroy environment/cache/credentials. |
| E23-26 | **Accessibility.** T1 review UI/report. | Automated semantics plus keyboard, screen reader, zoom/reflow, forced colors, status/error/expiry flow. | Reviewer can distinguish exact/tolerated/pending/unknown and complete decisions without pointer/color. | Critical task inaccessible or ambiguous. | Accessibility task evidence and issues. | 60–180 min | Remove fictional accounts/data. |
| E23-27 | **Runbook/owner exercise.** Tabletop plus scripted T1 incident. | Page correct owner; execute dual-authority/privacy/gap response; preserve evidence; recover. | Named functions respond, contain, clean, and re-enable only after evidence. | Unassigned owner, unsafe workaround, evidence deletion, unclear decision. | Exercise timeline and action items. | 60–120 min | Revoke temporary access, close case. |
| E23-28 | **Historical import/read-only.** Fictional archive and named subset. | Access/read-only guards, import provenance, collision, deletion/restore, aggregate isolation. | Archive cannot mutate; import remains origin-separated; no double contribution. | Silent merge, mutable archive, missing provenance, deleted data visible. | Import/archive manifests and restore probe. | 30–120 min | Destroy fictional archive/import. |


---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness functions

| ID | Fitness function | Measurement | Acceptance criterion | Gate scope |
|---|---|---|---|---|
| FF23-01 | **Endpoint destination singularity** | Count destination/protocol/credential families reachable from each endpoint artifact. | Legacy artifact reaches legacy only; new artifact reaches new only; dual-write mutations fail. | Every build/release. |
| FF23-02 | **Authority exclusivity** | Count active business authorities per realm/cohort/surface/epoch. | Exactly one or deliberately zero (`FROZEN_NO_AUTHORITY`); never two. | Runtime and gate evaluation. |
| FF23-03 | **Shadow non-egress** | Count shadow-derived ordinary facts/projections/messages/exports/lifecycle effects. | Zero. | Build, integration, pilot. |
| FF23-04 | **Realm isolation** | Cross-realm accepted operations/results/cache/evidence/key reuse. | Zero. | Every test/pilot window. |
| FF23-05 | **Privacy containment** | Mandatory canary escapes and forbidden fields in all sinks. | Zero, with positive controls detected. | Every build/run/evidence package. |
| FF23-06 | **Range closure** | Windows with missing/incomparable/stale watermarks marked final. | Zero; all final windows have both closure manifests. | Every comparison decision. |
| FF23-07 | **Progress correctness** | Cursor/checkpoint-ahead histories. | Zero. | State/fault tests and pilot. |
| FF23-08 | **One final effect** | Stable IDs with more than one ordinary business effect or same ID/different digest overwrite. | Zero. | Server materialization and cutover/rollback. |
| FF23-09 | **Exact comparison** | Exact-profile count/root/partition mismatches. | Zero for every window proposed as exact-pass. | Profile/window gate. |
| FF23-10 | **Mismatch completeness** | Material differences without one finite classification. | Zero. | Every compared window. |
| FF23-11 | **Tolerance governance** | Active tolerance matches without owner, rationale, scope, evidence, expiry, or negative tests. | Zero. | Every gate evaluation. |
| FF23-12 | **Known-defect boundedness** | Defect predicates matching outside declared scope or hard-invariant families. | Zero. | Build and every register revision. |
| FF23-13 | **Projector purity** | Same input/profile yielding different bytes; source fact mutation; prohibited/unrepresentable field defaulting. | Zero. | Every projector release. |
| FF23-14 | **Configuration monotonicity** | Target candidate capability/field/source/destination broader than product ceiling or source-approved intent. | Zero. | Every transformed candidate. |
| FF23-15 | **Evidence reproducibility** | Clean reruns with differing canonical roots/manifests absent declared inputs; first-failure loss. | Zero unexplained differences; first failure retained. | Every T1/release gate. |
| FF23-16 | **Cutover boundary integrity** | Unproved source gap/overlap or successful old-path write after fence. | Zero. | Cutover/rollback eligibility. |
| FF23-17 | **Raw comparison retention** | Raw row/value artifacts outside approved fixture or active break-glass memory. | Zero. | Every run and cleanup. |
| FF23-18 | **Observability boundedness** | Actual/theoretical series and evidence volume against the approved budget. | Within recorded budget; no dynamic labels; overflow explicit. | Each profile/load stage. |
| FF23-19 | **Review accessibility** | Critical decision tasks not completable/understandable by keyboard and supported assistive technology. | Zero blocking defects for enabled workflow. | Every UI/report release. |
| FF23-20 | **Owner/support readiness** | Blocking capability/defect/tolerance/runbook with `UNASSIGNED` owner. | Zero before non-T1 observation or ring expansion. | Pilot and production gates. |

## 9.2 Data-quality acceptance dimensions

A comparison result MUST report these separately; a single “match rate” is prohibited:

```text
source coverage and closure
record/effect completeness
uniqueness and duplicate multiplicity
identity/crosswalk quality
field validity and null/unknown states
rule/configuration revision alignment
time precision, timezone, and bucket alignment
retry/dedupe outcomes
projector field coverage
aggregate/report semantic coverage
known-defect/tolerance coverage
unrepresentable/unknown population
privacy/realm/evidence integrity
```

A report may show an overall gate state only after these dimensions remain individually inspectable.

## 9.3 Pilot gates

| Gate | Current status | Required evidence | Non-waivable stop condition |
|---|---|---|---|
| **G23-INPUT — legacy discovery and consumer inventory** | **BLOCKED** | Exact `22-legacy-discovery-result.md`; accepted semantic/report/configuration/consumer inventory; stable evidence hashes. | Missing file, substituted evidence, unknown material consumer/writer/fence. |
| **G23-ARCH — authority, dual-write, shadow isolation** | **OPEN — CLI EXPERIMENT** | FF23-01–03 and realm/security negative tests for exact artifacts/topology. | Any endpoint dual-write capability, dual authority, or shadow business egress. |
| **G23-CONTRACT — canonicalization, digests, windows** | **OPEN — CLI EXPERIMENT** | Independent canonical/root vectors, range closure, late-data, retry, and evidence reproducibility. | Nondeterminism, weak multiset detection, final open window, key/realm mismatch, canary escape. |
| **G23-SEMANTIC — invariants, rules, reports, defects, tolerances** | **BLOCKED IN PART** | Every exact invariant passes; every report profile has approved semantics; every tolerated mismatch has an owner-approved reason; no unknown material mismatch. | One exact mismatch; unapproved report semantics; unowned/expired tolerance; unknown material mismatch. |
| **G23-CONFIG — configuration transformation** | **OPEN — CLI + HUMAN** | Immutable source snapshot, typed transform/loss manifest, no broadening, owners for human-required items, staged rollback candidate. | Prohibited/conflicting/unrepresentable item silently activates; product ceiling broadens. |
| **G23-OPS — security, privacy, support, cost, accessibility** | **OPEN — CLI + HUMAN** | Canaries, break-glass negative/positive case, bounded resources/cardinality, runbooks, owner exercise, accessible review workflow, licensing/skills assessment. | Privacy/realm failure, unbounded impact, inaccessible critical workflow, owner absent, unresolved license. |
| **G23-CUTOVER — common fence and rollback** | **BLOCKED** | Exact old-write fence, final legacy/new ranges, no gap/overlap, post-fence deny, new boundary, rollback drill, cleanup. | Continued old write, ambiguous common fence, duplicate/missing effect, unsafe rollback. |
| **G23-HISTORY — archive/import/decommission** | **BLOCKED** | Consumer/archive/retention decisions; read-only guard; named import evidence if any; restore/deletion/export drills; rollback-window expiry. | Unknown consumer, mutable archive, silent import merge, deleted data visible, acknowledged data missing. |
| **G23-AGG — migration-validation sign-off** | **BLOCKED** | All applicable gates pass for one exact release/topology/cohort/profile; human decisions recorded; evidence current; cleanup complete. | Any hard failure, missing/expired evidence, blocking human decision, unassigned owner, or residue. |

## 9.4 Automated pause and rollback triggers

### 9.4.1 Automatic pause — exact threshold is one occurrence

The affected realm/cohort/profile MUST pause immediately when any of these counters becomes greater than zero:

```text
endpoint_dual_write_detected
dual_business_authority_detected
cross_realm_result_detected
privacy_canary_escape_detected
forbidden_field_detected
checkpoint_ahead_detected
one_effect_conflict_detected
source_range_unproved_gap_or_overlap
post_fence_legacy_write_detected
comparison_evidence_tamper_detected
hard_invariant_mismatch
gate_harness_integrity_failure
```

Also pause ring expansion when:

```text
unclassified_material_mismatch_count > 0
unowned_or_expired_tolerance_count > 0
unapproved_report_semantics_count > 0
window_not_closed_count > 0
blocking_owner_unassigned_count > 0
```

These are logical zero-tolerance conditions, not invented service thresholds.

### 9.4.2 Performance/availability pause

CPU, memory, database load, query duration, lock impact, evidence size, comparison lag, cardinality, and support backlog thresholds are **HUMAN DECISION** values derived from E23-24. Until approved, the conservative behavior is to throttle/stop comparison before it harms the business path. Performance cannot waive a correctness/privacy failure.

### 9.4.3 Rollback triggers

A production rollback MAY be proposed when, after cutover:

- a hard invariant fails;
- an approved critical report contract materially fails;
- new-authoritative source coverage cannot be restored within the human-approved bound;
- a release/configuration/projector defect has no safe forward fix within the approved operational window;
- incident authority determines the new path cannot safely remain authoritative.

Default automation is:

```text
hard trigger -> PAUSE/FREEZE -> collect exact boundary evidence -> human-authorized rollback or forward fix
```

Automatic rollback is disabled unless the exact profile has a pre-authorized safe rollback state machine and repeated successful drills. A rollback proposal is rejected if the old path cannot be fenced/resumed at a proved boundary.

## 9.5 Ring progression

| Ring | Inputs | Allowed claims | Expansion gate |
|---|---|---|---|
| R0 pure model | T1 hand-authored fixtures | Contract/state/root logic only. | All deterministic/mutation tests pass. |
| R1 synthetic server integration | Generated fictional legacy/new DBs | Adapter/projector/digest/shadow isolation. | G23-ARCH/CONTRACT T1 pass. |
| R2 disposable Windows/system lab | Synthetic endpoint observations and isolated databases | Exact artifact/network/authority/fence behavior for one tuple. | G23-OPS and cutover/rollback T1 drill pass. |
| R3 approved sanitized aggregate replay | No raw activity; approved aggregate shapes only | Cost/scale, report mechanics, mismatch workflow. | Generator/evidence qualified; owners assigned. |
| R4 real shadow pilot | Human-approved minimal cohort/data/purpose | Only the named profiles/windows; still no cutover. | G23-INPUT, SEMANTIC, CONFIG, OPS pass; no hard/unknown mismatch. |
| R5 cutover pilot | Exact approved cohort and fence | New authority after explicit boundary. | G23-CUTOVER and rollback readiness; designated human approval. |
| R6 broader rollout | Successive named cohorts | Only evidence-bound profiles/topologies. | Every prior ring current; no unresolved material mismatch; operational capacity/owners approved. |
| R7 decommission | Legacy read-only/archive state | Removal only of proved-unused writers/consumers. | G23-HISTORY, rollback expiry, records/legal/production approval. |

---

# 10. Human decisions and owner questions

Research does not make the decisions below. The role names are accountable functions, not invented assignments. The conservative default is disabled, exact-only, read-only, or blocked.

## 10.1 Decision register

| ID | **HUMAN DECISION** | Options and consequences | Conservative temporary default | Accountable function |
|---|---|---|---|---|
| HD23-01 | Required report semantics | Preserve exact legacy semantics; define corrected target semantics; retire report; run both read-only for transition. Exact preservation can institutionalize defects; correction affects consumers; retirement requires replacement/communication. | No report-equivalence claim; report profile disabled. | Report/Data Product Owner with affected consumer owners. |
| HD23-02 | Known accepted legacy defects | Accept temporarily with expiry; fix before cutover; retire affected surface; declare unrepresentable. Acceptance reduces immediate work but carries operational/privacy risk. | Register empty; every candidate remains blocking. | Data/Product Owner with Security/Privacy where relevant. |
| HD23-03 | Tolerance owners and policy | Central migration owner; per-report/source owner; no tolerances. Distributed ownership improves semantics but increases governance load. | No active tolerance without named owner/approval/expiry. | Product/Data Governance. |
| HD23-04 | Authority for sensitive break-glass comparison | Independent privacy/security approval; dual approval; no break-glass. More access improves diagnosis but increases disclosure and support obligations. | Disabled; aggregate/keyed evidence only. | Privacy/Security authority with Data Controller/Product authority. |
| HD23-05 | Parallel-run legal/business purpose and prohibited uses | Technical migration assurance only; broader operational validation; no real parallel run. | T1 fictional data only. | Data Controller/Business Product Owner with Legal/Privacy/Workforce Governance. |
| HD23-06 | Pilot cohort and duration | Small representative cohort; staged source/report cohorts; no pilot. Larger coverage improves confidence but expands duplicate storage and incident impact. | No real cohort. | Product/Risk Authority with Endpoint and Operations. |
| HD23-07 | Duplicate shadow-data retention/access | Memory-only where possible; short isolated retention; retain digest evidence only; longer troubleshooting retention. | Raw/canonical transient only; minimized shadow retained only as needed for T1; production value unset. | Privacy/Data Governance/Records/Security. |
| HD23-08 | Common cutover/rollback fence | Native source range; quiesced boundary; aggregate/report window; no safe fence. Weaker fences reduce exactness. | No cutover until exact fence is approved and proved. | Migration Control/Data Reliability/Product Owner. |
| HD23-09 | Automatic rollback authority | Disabled; pre-authorized exact ring/profile; broad automated rollback. Broader automation speeds response but risks duplicate/gap. | Automatic pause only; rollback requires human command. | Production/Risk Authority with Operations. |
| HD23-10 | Configuration source of truth and precedence | Legacy setting precedence; target governance precedence; manual reconciliation. | Conflicts block; target stays disabled. | Configuration/Product Governance with Privacy/Security. |
| HD23-11 | Historical strategy | Read-only archive; named subset import; full migration; destruction after retention. Import increases cost/privacy/semantic risk; archive prolongs legacy operations. | Read-only archive; no import. | Data Owner/Records/Legal/Product. |
| HD23-12 | Legacy archive/decommission retention | Defined read-only period; legal hold; immediate destruction after gate; indefinite archive. Indefinite is high cost/risk and not a default. | No destruction and no indefinite promise; retain read-only until policy and consumers are settled. | Records/Data Controller/Legal/Operations. |
| HD23-13 | Identity level for comparison | Source/event aggregate; installation; subject/person. Greater detail improves localization but raises privacy/access risk. | No person-level comparison; source-range/aggregate only. | Data Controller/Product/Privacy/IAM. |
| HD23-14 | Time precision and timezone semantics | UTC instant; named bucket; legacy-local reconstruction; corrected target. | Compare only exact approved UTC/bucket profile; unknown legacy local rules block. | Data Product Owner/Privacy/Report Owner. |
| HD23-15 | Hard-deny and unrepresentable report behavior | Omit; report explicit unavailable; retain legacy read-only; create new approved field. | Explicit `PROHIBITED`/`UNREPRESENTABLE`; no default value. | Product Privacy/Report Owner. |
| HD23-16 | Operational budgets | DB load, comparison lag, memory, evidence size, series, support backlog. | Conservative throttle/stop before business impact; no production claim. | SRE/Operations/Product/Finance. |
| HD23-17 | Support ownership and hours | Dedicated migration team; shared on-call; business-hours only; vendor support. | No real pilot without named coverage and escalation. | Engineering/Operations Leadership. |
| HD23-18 | Licensing/procurement | UAM-owned implementation; admitted OSS; commercial validator/support. | Reference-only OSS; no new runtime dependency. | Architecture/Dependency Security/Legal/Procurement. |
| HD23-19 | Accessibility/browser/assistive-technology support | Named enterprise matrix and WCAG 2.2 AA target; CLI-only review; alternative accessible report. | Standards-first CLI/report plus WCAG 2.2 AA for any UI; formal policy unset. | Accessibility/Product/Support. |
| HD23-20 | Production sign-off and residual-risk acceptance | Go, limited go, extend pilot, fix, rollback, retire profile. | No production sign-off. | Designated Production/Risk Authority. |

## 10.2 Required owner questions

1. Which exact legacy reports, exports, aggregates, operational actions, and downstream integrations must survive, change, or retire?
2. For each required report, what are the authoritative fields, filters, time zone, precision, rounding, null/unknown, late-data, and correction semantics?
3. Which known legacy defects are accepted temporarily, who owns each, and when does acceptance expire?
4. Which differences are genuine tolerances rather than defects, and why can they not conceal loss, duplicates, realm mix, or privacy expansion?
5. Is a real parallel run legally and operationally permitted, for which cohort, source, fields, duration, access, and retention?
6. Is person-level localization necessary? What decision cannot be made from source-range/aggregate evidence?
7. Who can authorize sensitive break-glass, who receives alerts, and what maximum fields/rows/time are permitted?
8. What exact mechanism fences legacy writes by cohort, and can shared credentials or manual writers bypass it?
9. What common native/source/report boundary proves cutover and rollback without source-time guesses?
10. How long must legacy rollback remain available, and what release/configuration/storage support is required during that period?
11. Which legacy configurations are authority, which are merely observed behavior, and which are prohibited in the target?
12. Is historical data required in the new platform? Which named use case cannot use a read-only archive?
13. What are the resource/cardinality/support budgets for comparison, and what business workload has priority?
14. Who owns discovered manual spreadsheets, direct database queries, and unknown consumers?
15. What evidence is sufficient to decommission credentials, scheduled tasks, databases, reports, backups, and support runbooks?

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Proposed tool layout

```text
/src/tools/Uam.Migration.Reconcile/
/src/tools/Uam.Migration.ConfigTransform/
/src/tools/Uam.Migration.Authority/
/src/tools/Uam.Migration.Projector/
/src/tools/Uam.Migration.Evidence/
/tests/migration/{contracts,canonicalization,authority,shadow,projector,config,cutover,rollback,privacy,realm}/
/contracts/migration/**
/fixtures/migration/t1/**
/docs/runbooks/migration/**
```

Every CLI:

- accepts named, release-owned profiles rather than arbitrary SQL/field expressions;
- accepts connection **profile references**, not raw connection strings or passwords on the command line;
- redacts host/user/path/credential material from evidence;
- defaults to no network except the named adapter lane;
- emits an immutable evidence envelope and cleanup status;
- preserves the first failure and links reruns rather than overwriting it.

The command names below are normative implementation targets; they do not assert that the tools already exist.

## 11.2 Commands

### E-CLI-01 — verify allowlisted evidence

```bash
dotnet run --project src/tools/Uam.Migration.Evidence -- \
  input verify \
  --allowlist contracts/migration/research-inputs-v1.json \
  --base /mnt/data \
  --out artifacts/migration/e23-input-manifest.json
```

Must produce:

```text
exact logical and local filenames
size and SHA-256
present/missing status
no-substitution assertion
research date/tool/source revision
blocking-gate list
```

Pass today records `22-legacy-discovery-result.md` as missing and marks semantic/cutover/decommission gates blocked. It must not report aggregate success.

### E-CLI-02 — generate deterministic fictional package

```bash
dotnet run --project src/tools/Uam.Migration.Reconcile -- \
  fixture generate \
  --scenario p23-parallel-exact-v1 \
  --seed 230001 \
  --fixed-clock 2026-08-01T00:00:00Z \
  --out artifacts/migration/fixtures/p23-parallel-exact-v1
```

Must produce byte-identical canonical fixtures on two clean runs, including:

```text
fictional realms/cohorts/sources/ranges/events/reports/configs
duplicates, gaps, retries, late data, DST, null/unknown, conflicts
independent truth ledger
canary registry
lineage and package root
cleanup/deletion policy
```

### E-CLI-03 — prove no endpoint dual-write

```bash
dotnet test tests/migration/architecture \
  --filter FullyQualifiedName~NoEndpointDualWrite \
  --logger "trx;LogFileName=e23-no-dual-write.trx"

dotnet run --project src/tools/Uam.Migration.Evidence -- \
  artifact inspect-destinations \
  --release-manifest artifacts/release/file-manifest.json \
  --policy contracts/migration/endpoint-destination-policy-v1.json \
  --out artifacts/migration/e23-endpoint-destinations.json
```

Must produce:

```text
project/package/API graph
binary import/string/manifest findings
credential-purpose inventory
outbound destination classes
one mutation result per forbidden SQL/new-ingress dependency
positive-control deny result
clean-tree/cleanup proof
```

### E-CLI-04 — validate contracts and profile

```bash
dotnet run --project src/tools/Uam.Migration.Reconcile -- \
  profile validate \
  --profile contracts/migration/profiles/edge-site-bucket-v1.json \
  --schema-bundle contracts/migration/bundle.json \
  --vectors fixtures/migration/t1/profile-vectors \
  --out artifacts/migration/e23-profile-validation.json
```

Must prove strict JSON/schema, closed fields, scalar/time/Unicode rules, local references, limits, owner metadata, and valid/invalid/old/new vectors.

### E-CLI-05 — build canonical/keyed digest

```bash
dotnet run --project src/tools/Uam.Migration.Reconcile -- \
  digest build \
  --side legacy \
  --input artifacts/migration/fixtures/p23-parallel-exact-v1/legacy.ndjson \
  --profile contracts/migration/profiles/edge-site-bucket-v1.json \
  --window fixtures/migration/t1/window-001.json \
  --key-ref lab-key://reconcile/fictional-realm/run-001 \
  --out artifacts/migration/run-001/legacy-digest.json
```

Run equivalently for `--side new`. Evidence must include canonical profile digest, range/closure manifest, counts, multiplicities, root, partition manifest, exact tool/build identity, key reference, resource measurements, and canary result—never key or raw row values.

### E-CLI-06 — compare sides and localize mismatch

```bash
dotnet run --project src/tools/Uam.Migration.Reconcile -- \
  compare run \
  --left artifacts/migration/run-001/legacy-digest.json \
  --right artifacts/migration/run-001/new-digest.json \
  --profile contracts/migration/profiles/edge-site-bucket-v1.json \
  --max-partition-depth 12 \
  --out artifacts/migration/run-001/comparison.json
```

Must produce exact equality state or finite partition-level mismatches, with no raw values and no unbounded recursive query. `--max-partition-depth` is a T1 safety ceiling and not a production default.

### E-CLI-07 — classify every mismatch

```bash
dotnet run --project src/tools/Uam.Migration.Reconcile -- \
  mismatch classify \
  --comparison artifacts/migration/run-001/comparison.json \
  --known-defects contracts/migration/known-defects/revision-000.json \
  --tolerances contracts/migration/tolerances/revision-000.json \
  --out artifacts/migration/run-001/classified-mismatches.json
```

Must produce one finite family, materiality, owner function, defect/tolerance candidate, expiry/review state, and next action for every mismatch. Unknown remains blocking. The command cannot accept free-form suppression text as authority.

### E-CLI-08 — project new facts to legacy-shaped comparison output

```bash
dotnet run --project src/tools/Uam.Migration.Projector -- \
  build \
  --input artifacts/migration/fixtures/p23-parallel-exact-v1/new-facts.ndjson \
  --profile contracts/migration/projectors/legacy-site-view-from-new-v1.json \
  --reference-bundle fixtures/migration/t1/reference-bundle-v1.json \
  --out artifacts/migration/run-001/projected.ndjson \
  --manifest artifacts/migration/run-001/projector-manifest.json
```

Must produce deterministic output, field coverage, provenance, prohibited/unrepresentable counts, resource measurements, and zero canary escapes. It must prove source input files are unchanged.

### E-CLI-09 — snapshot and transform configuration

```bash
dotnet run --project src/tools/Uam.Migration.ConfigTransform -- \
  snapshot verify \
  --input fixtures/migration/t1/legacy-config-snapshot.json \
  --profile contracts/migration/config/legacy-snapshot-v1.json \
  --out artifacts/migration/config/snapshot-manifest.json

dotnet run --project src/tools/Uam.Migration.ConfigTransform -- \
  transform \
  --snapshot artifacts/migration/config/snapshot-manifest.json \
  --transformer contracts/migration/config/legacy-to-target-v1.json \
  --product-ceiling fixtures/migration/t1/product-ceiling.json \
  --out artifacts/migration/config/target-candidate.json \
  --loss-manifest artifacts/migration/config/loss-manifest.json
```

Must produce item-by-item status, provenance, conflicts, human decisions, no-broadening proof, canary results, and activation state. It must never execute source strings.

### E-CLI-10 — simulate authority, cutover, and rollback

```bash
dotnet run --project src/tools/Uam.Migration.Authority -- \
  simulate \
  --scenario fixtures/migration/t1/authority-cutover-rollback-v1.json \
  --seed 230010 \
  --out artifacts/migration/authority/simulation.json
```

Must produce complete epoch/range/effect history, every injected fence/write/crash, expected-vs-actual state, minimal failure, and cleanup. Passing requires no dual authority, no duplicate effect, and unsafe rollback frozen.

### E-CLI-11 — verify shadow non-egress and realm isolation

```bash
dotnet test tests/migration/integration \
  --filter "Category=ShadowIsolation|Category=RealmIsolation" \
  --logger "trx;LogFileName=e23-isolation.trx"
```

Must enumerate every ordinary API, report, projection, integration, export, deletion/lifecycle, cache, and evidence lookup tested, including hostile cross-realm IDs and dependency mutations.

### E-CLI-12 — run canary scan

```bash
dotnet run --project src/tools/Uam.Migration.Evidence -- \
  canary scan \
  --registry fixtures/migration/t1/canary-registry.json \
  --sink-manifest artifacts/migration/run-001/sinks.json \
  --out artifacts/migration/run-001/canary-result.json
```

Must first prove every positive control is found. A missed control or candidate escape returns nonzero and blocks evidence sealing.

### E-CLI-13 — evaluate pilot gate

```bash
dotnet run --project src/tools/Uam.Migration.Evidence -- \
  gate evaluate \
  --gate-profile contracts/migration/gates/g23-aggregate-v1.json \
  --evidence-root artifacts/migration/run-001 \
  --decisions artifacts/migration/run-001/owner-decisions.json \
  --out artifacts/migration/run-001/gate-decision.json
```

Must produce:

```text
GO | PAUSE | STOP
applicable and non-applicable gates
all exact-invariant results
all mismatch classifications
all active tolerances/defects and owners
missing/expired evidence
runbook/owner/cleanup state
productionApproved = false unless a separate human record exists
```

Primary pass assertion:

> Every exact invariant passes; every tolerated mismatch has an owner-approved reason; every material mismatch is classified; endpoint dual-write remains impossible.

### E-CLI-14 — seal and independently verify evidence

```bash
dotnet run --project src/tools/Uam.Migration.Evidence -- \
  seal \
  --run artifacts/migration/run-001 \
  --out artifacts/migration/run-001/evidence-manifest.json

dotnet run --project src/tools/Uam.Migration.Evidence -- \
  verify \
  --manifest artifacts/migration/run-001/evidence-manifest.json \
  --require-first-failure \
  --require-cleanup \
  --out artifacts/migration/run-001/verification.json
```

Must reconcile every file/digest, schema, source/tool version, decision, first failure, rerun lineage, canary result, and cleanup receipt. Unknown or extra artifacts fail closed.

## 11.3 Approved aggregate measurement lane

After T1 gates and human approval, a metadata-only measurement MAY collect only pre-approved aggregates needed to replace estimates, such as:

```text
rows/events per named source family and interval
canonical/minimized bytes per event/batch
late-arrival and retry class distributions
comparison window close latency
legacy query plan/resource classes
projector/comparator CPU, memory, duration, and evidence bytes
mismatch-family counts without identifiers or values
```

It MUST NOT collect raw URLs, paths, identities, application labels, report rows, connection strings, SQL text, credentials, or confidential configuration. The measurement request names question, fields, owner, access, expiry, deletion, and no-raw proof.

---

# 12. ADR proposals

| ADR | Decision | Status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-P23-001 | One business-authoritative path per realm/cohort/surface/epoch; shadow is non-authoritative. | **Proposed — accept** | Dual authority; big bang. | Preserves I01/I07–I09 one-effect/realm/durability and enables comparison. | Architecture / Migration Control. | Counterexample showing isolation impossible or a simpler equivalent design. |
| ADR-P23-002 | Endpoint dual-write is structurally prohibited; parallel run is dual observation by separate destination-specific artifacts. | **Proposed — accept** | Endpoint fan-out; server proxy fan-out. | New endpoint must have no SQL/legacy credentials; dual commit ambiguity is unacceptable. | Endpoint Architecture / Security. | Formal baseline change proposal only. |
| ADR-P23-003 | New parallel observations land in an isolated shadow namespace with no ordinary business egress. | **Proposed — accept** | Shared fact table with flag; separate full platform. | Explicit isolation is easier to test than pervasive filters. | Data Platform. | Measured operations/cost issue and equivalent negative proof. |
| ADR-P23-004 | Reconciliation is server-side after minimization using bounded read-only adapters. | **Proposed — accept** | Endpoint comparison; raw export; external SaaS. | Minimizes endpoint authority and durable sensitive duplication. | Reconciliation Architecture / Privacy. | Required comparison cannot be expressed after minimization. |
| ADR-P23-005 | Compatibility projection is deterministic, read-only, shadow-only, and never writes legacy DB. | **Proposed — accept** | Legacy write-back; new canonical schema mimics legacy. | Keeps canonical facts authoritative and defects out of target behavior. | Compatibility Engineering. | Approved consumer requires a production compatibility API and passes separate gate. |
| ADR-P23-006 | Canonical JCS rows, per-run/realm HMAC-SHA-256, counted leaves, and RFC 9162-style Merkle root are the T1 digest profile. | **Proposed — T1 candidate** | DB-native hashes; unkeyed hashes; PSI; full row diff. | Deterministic/private exact multiset evidence; needs UAM prototype. | Data Security / Reconciliation. | Canonicalization/cost/security counterexample or crypto policy change. |
| ADR-P23-007 | Windows/ranges close under explicit watermarks; late data creates superseding generations. | **Proposed — accept** | Wall-clock-only closure; mutate prior result. | Prevents false equality and preserves evidence. | Data Reliability. | Source discovery establishes a stronger simpler fence. |
| ADR-P23-008 | Exact invariants have zero tolerance; every tolerated mismatch is explicit, owned, scoped, evidenced, and expiring. | **Proposed — accept** | Match percentage; implicit exclusions. | Prevents data-loss laundering and keeps residual differences visible. | Data/Product Governance. | No expected ordinary change. |
| ADR-P23-009 | Known-defect register starts empty and cannot suppress security/privacy/durability/authority failures. | **Proposed — accept** | Copy defects; broad ignore list. | Legacy is evidence, not oracle. | Product/Data Owner / Verification. | Human approval of exact defect record. |
| ADR-P23-010 | Configuration migration uses immutable snapshot -> typed LIM -> pure transform -> no-broadening validation -> human approval. | **Proposed — accept** | Copy files/scripts/SQL; manual direct edit. | Prevents executable authority and guessed semantics. | Configuration Migration / Product Privacy. | Prompt 22 reveals a required config class not representable by LIM. |
| ADR-P23-011 | Historical default is read-only legacy archive; imports are named, provenance-separated `LEGACY_IMPORT`. | **Proposed — accept default** | Full migration; immediate destruction. | Missing semantics/keys/retention make wholesale import unsafe. | Data/Records/Product. | Approved historical use case and complete lifecycle evidence. |
| ADR-P23-012 | Cutover/rollback use monotonic authority epochs, frozen state, exact fences, and no shadow promotion. | **Proposed — accept** | Clock switch; in-place flag; dual running authority. | Avoids overlap/duplicates and makes rollback explicit. | Migration Control / Data Reliability. | Prompt 22/common-fence evidence may refine boundary mechanism. |
| ADR-P23-013 | Default automated response is pause; production rollback requires pre-authorized exact profile or human decision. | **Proposed — accept** | Automatic universal rollback. | Rollback can itself cause gap/overlap. | Operations / Risk Authority. | Repeated exact ring drills and human pre-authorization. |
| ADR-P23-014 | Sensitive break-glass sampling is disabled by default, case-bound, deterministic, bounded, memory-only, and audited. | **Proposed — mechanism accept / authority open** | General raw diff; no diagnostic access. | Provides bounded diagnosis without a second raw warehouse. | Privacy/Security Authority. | Human access decision or evidence that aggregates suffice permanently. |
| ADR-P23-015 | Comparison observability uses finite dimensions and explicit cardinality budget; digests/IDs are evidence only. | **Proposed — accept** | Dynamic per-realm/source labels. | Preserves privacy and operational bounds. | SRE / Privacy. | Approved backend/budget measurement. |
| ADR-P23-016 | OSS projects are reference-only initially; UAM owns the narrow contracts/state machine. | **Proposed — accept** | Adopt DVT/GX/Soda/data-diff as core runtime. | Broad query/plugin/output/license surfaces and threat-model mismatch. | Architecture / Dependency Security / Legal. | Bake-off proving an exact dependency materially lowers total assurance cost. |
| ADR-P23-017 | `22-legacy-discovery-result.md` is a blocking input for semantic pilot, fence selection, cutover, rollback, and decommission. | **Proposed — accept** | Infer from summaries; substitute another result. | Prompt explicitly requires same-stream evidence; summaries state major limitations. | Research/Migration Governance. | Exact file restored and reviewed by batch process. |
| ADR-P23-018 | Migration evidence is content-addressed, immutable, first-failure preserving, independently verifiable, and raw-value free. | **Proposed — accept** | Mutable dashboard/log-only evidence. | Supports trustworthy gates without privacy expansion. | Verification Governance / Audit. | Accepted audit/evidence substrate supersedes implementation details. |

No accepted-baseline change proposal is raised. The design preserves the accepted endpoint topology, privacy boundary, one-writer/one-effect model, relational custody, no-broker default, realm authority, release controls, and restore invariants.

A future implementation MUST open a baseline change proposal before introducing endpoint dual-write, dual business authority, legacy write-back, raw durable comparison, weak/implicit tolerances, payload-derived realm, shadow business egress, or cutover without an exact fence.

---

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Recover and review exact `22-legacy-discovery-result.md`. | None. | Input hash, semantic/writer/consumer/config/report/fence inventory. | Missing/substituted/stale file keeps G23-INPUT blocked. |
| 2 | Create Prompt 23 ADRs and human-decision templates. | 1 may proceed in parallel for generic items. | ADR files, owner/approval/expiry schemas. | Any architecture conflict hidden or blocking owner unassigned before activation. |
| 3 | Scaffold migration contracts/tools/tests with architecture boundaries. | Batch 01 repository rules. | Buildable projects and forbidden-dependency mutation harness. | Endpoint or server boundary mutation survives. |
| 4 | Build deterministic T1 legacy/new/config/report fixture package and independent oracle. | 3. | Fictional package, truth ledger, canaries, lineage. | Nondeterminism, raw/organization value, oracle common-code defect. |
| 5 | Implement strict authority/profile/window/range/digest/mismatch/evidence schemas. | 3–4. | Local schema bundle and hostile vectors. | Unknown/duplicate/default/remote ref accepted. |
| 6 | Implement endpoint destination singularity checks. | 3, exact endpoint artifacts when available. | Static/runtime no-dual-write evidence. | Any artifact can reach both systems. |
| 7 | Implement authority epoch registry and pure state model. | 5. | Monotonic states, realm constraints, idempotency/failpoints. | `BOTH`, lower epoch, or wrong realm accepted. |
| 8 | Implement shadow namespace and no-egress architecture tests. | 5, accepted server module boundaries. | Shadow store/roles and negative surface matrix. | One ordinary business effect from shadow. |
| 9 | Implement canonical scalar/JCS/HMAC/multiset-root library and independent verifier. | 4–5, crypto T1 key profile. | Golden vectors, counted-root algorithm, mutation corpus. | Nondeterminism, duplicate cancellation, key leak. |
| 10 | Implement window/watermark/late-data controller. | 5, source semantics from Prompt 22/new contracts. | Closure state machine and superseding generations. | Open/incomparable window finalizes. |
| 11 | Implement fictional/synthetic legacy read adapter. | 4–5. | Fixed read-only query catalogue and bounds. | Arbitrary/side-effecting query or raw sink. |
| 12 | Define real legacy adapters and report/config profiles from Prompt 22. | 1, 11. | Named profile inventory with limitations and owner candidates. | Unknown material writer/report/consumer or no read-only profile. |
| 13 | Implement new shadow read adapter. | 8, accepted typed fact contracts. | Realm/range/provenance-safe adapter. | Reads authoritative/other realm incorrectly. |
| 14 | Implement compatibility projector framework and first fictional projector. | 5, 9, 13. | Pure projector, field coverage, provenance, canaries. | Field invention/default/prohibited reconstruction. |
| 15 | Implement comparator, partition localization, mismatch classifier, and gate evaluator. | 9–14. | End-to-end T1 reconciliation evidence. | Any material mismatch unclassified or exact mismatch passes. |
| 16 | Implement known-defect/tolerance registries with negative mutation tests. | 5, 15. | Empty initial registers and owner workflows. | Wildcard/hard-family suppression or unowned activation. |
| 17 | Implement configuration snapshot/LIM/transformer/loss manifest. | 1, 4–5. | Fictional then legacy-profile transformer. | Broadening, script/SQL execution, guessed conflict. |
| 18 | Implement privacy-safe evidence, canary, cardinality, and independent verification. | 4–16. | Evidence manifests, first-failure ledger, cleanup verifier. | Canary miss, raw value, tamper not detected, unbounded label. |
| 19 | Build accessible migration-review CLI/report; UI only if needed. | 15–18. | Exact/tolerated/pending/unknown workflows and task tests. | Critical review/incident task inaccessible or ambiguous. |
| 20 | Execute complete R0/R1 T1 campaigns and “harness lies” mutations. | 4–19. | G23-ARCH/CONTRACT/CONFIG T1 evidence. | Any hard invariant or harness failure. |
| 21 | Prepare disconnected exact cutover/rollback lab scripts and support runbooks. | 1, 7, 10–20. | Placeholder-only install/fence/drill/cleanup plans. | Actual connection detail/credential or unsafe untyped command. |
| 22 | Run disposable-system authority/fence/rollback experiments. | Approved lab, 21, predecessor gates. | Exact artifact/topology evidence and cleanup. | Continued old write, gap/overlap, unsafe rollback, residue. |
| 23 | Run approved aggregate scale/cost/cardinality lane. | 20, human measurement approval. | Workload/cost/skills/license evidence replacing estimates. | Generator saturation, business impact, invariant failure. |
| 24 | Obtain report semantics, defect, tolerance, break-glass, purpose, retention, and support decisions. | 1, evidence from 20–23. | Signed/recorded human-decision register. | Required decision/owner absent. |
| 25 | Execute R4 real shadow pilot with no cutover. | G23-INPUT/ARCH/CONTRACT/SEMANTIC/CONFIG/OPS pass; production-purpose approval. | Closed windows and owner-reviewed evidence. | One hard or unknown material mismatch; privacy/realm/ops failure. |
| 26 | Rehearse exact pilot cutover and rollback again with current artifacts. | 25 and exact fence. | Current G23-CUTOVER evidence. | Stale artifact/evidence or any boundary failure. |
| 27 | Human-authorized cutover pilot. | All applicable gates, risk approval. | Higher authority epoch, fence evidence, post-boundary probes. | Any precondition missing; remain frozen/legacy authority. |
| 28 | Stabilize, expand by named cohorts, and preserve rollback window. | 27, approved operational thresholds. | Per-cohort gate/evidence; no inherited support. | Unresolved material mismatch, owner/rollback expiry. |
| 29 | Complete consumer/archive/import/decommission discovery and drills. | 1, 24, stable new authority. | G23-HISTORY evidence and explicit limitations. | Unknown consumer, restore/deletion/access failure. |
| 30 | Human-authorized decommission and cleanup. | 29, rollback-window expiry, records/legal approval. | Removed writers/credentials/routes, archive/destruction evidence, final runbooks. | Missing evidence/owner/hold or residue. |

The critical path is 1 → 4/5 → 7–18 → 20 → 22–24 → 25–27. Work that would make real legacy semantic claims cannot bypass item 1.


---

# 14. Open-source repository assessment table

## 14.1 Assessment method

Repositories were reviewed for current maintenance as of 1 August 2026, exact release/tag/commit, license, tests, security posture, architectural fit, privacy/authority surface, and operational dependency cost. Popularity was not used as evidence. None is recommended as an initial production dependency. Reusable patterns should be reimplemented behind UAM's strict C# contracts unless an exact bake-off later proves lower total assurance cost.

| Repository and reviewed point | Relevant files/directories | License and compatibility | Maintenance, tests, security | Similarities and threat-model differences | Reusable ideas | Ideas not to copy | Suitability |
|---|---|---|---|---|---|---|---|
| **Google Cloud Data Validation Tool (DVT)** — `GoogleCloudPlatform/professional-services-data-validator`, release **v8.9.0**, commit [`3d57ab87e31573dfcfe0ffee0cb4fe4a4b6555c0`](https://github.com/GoogleCloudPlatform/professional-services-data-validator/commit/3d57ab87e31573dfcfe0ffee0cb4fe4a4b6555c0), 31 July 2026. | `data_validation/`, `tests/`, `samples/`, `README.md`, `SECURITY.md`, `LICENSE`. | Apache-2.0. Legal compatibility is generally plausible, but every transitive Python/database driver still needs admission. | Active release immediately before review; validation tests and security policy exist. Project identifies itself as a professional-services/unofficial Google tool rather than a supported managed product. | Directly addresses heterogeneous table/column/row/schema/custom-query validation and supports SQL Server/PostgreSQL. Its normal threat model permits stored connections, broad SQL, raw row validation, and cloud integrations; UAM requires closed profiles, no arbitrary SQL, no raw evidence, and realm/authority gates. | Validation modes, configuration lint, query/result separation, schema comparison vocabulary, reproducible CLI evidence. | Arbitrary custom SQL; generic stored connections; raw unexpected rows; random sampling as sign-off; stable unkeyed row hashes; GCP-specific control plane; automatic tool-defined truth. | **Reference only.** Not a runtime dependency for the first implementation. |
| **Great Expectations** — `fivetran/great_expectations`, release **1.19.1**, commit [`f6d7aec4f43cf0a9bae53a48ad0ec93003dc4bd4`](https://github.com/fivetran/great_expectations/commit/f6d7aec4f43cf0a9bae53a48ad0ec93003dc4bd4), 24 July 2026. | `great_expectations/expectations/`, `great_expectations/checkpoint/`, `tests/expectations/`, `tests/integration/`, `tests/performance/`, `SECURITY.md`, `LICENSE`. | Apache-2.0. Broad Python dependencies and database adapters increase admission/patch surface. | Active project/release; extensive unit, expectation, integration, and performance tests; private vulnerability-reporting policy. | Declarative expectations/checkpoints and result formats resemble profile/gate concepts. It can intentionally return unexpected rows/indexes/queries and supports extensible metric providers, which is incompatible with UAM's minimum-data, closed-authority default. | Declarative expectation identity, checkpoint/run-result concepts, success/failure metadata, test organization. | Data Context/plugin ecosystem, arbitrary expectation code, broad connectors, storing/displaying unexpected rows, dynamic result formats, general validation UI as authority. | **Reference only.** A narrow dependency is not justified. |
| **Soda Core** — `sodadata/soda-core`, release **v4.19.0**, commit [`0416a3d0a47d04c112dd8f8d8b7b5cc017888c57`](https://github.com/sodadata/soda-core/commit/0416a3d0a47d04c112dd8f8d8b7b5cc017888c57), 28 July 2026. | `soda-core/`, `soda-sql/`, `soda-tests/`, contract/check-collection code, release workflows, license/security files. | **Elastic License 2.0**, source-available rather than OSI open source; hosted-service and redistribution implications require Legal/Procurement review. | Active frequent releases; tests cover SQL dialects/contracts. Recent releases included dependency security fixes and SQL Server connection-parameter redaction. Some release commits are explicitly marked `SKIP-TESTS`, so release-process interpretation needs care. | Data contracts, checks, SQL backends, and outcome states are relevant. The system supports broad connectors, YAML/SQL expressions, diagnostics/log upload, and optional cloud workflows beyond UAM's closed, local, privacy-safe comparator. | Contract/check collection grouping, finite scan state, dialect capability tests, credential-redaction lessons. | ELv2 assumption as “open source”; cloud log upload; arbitrary SQL/check language; broad DWH connector authority; failed-row export; runtime plugin surface. | **Reference only; not dependency** absent legal and technical bake-off. |
| **Debezium** — `debezium/debezium`, tag **v3.6.0.Final**, commit [`800ae11b7e7e23ab4f3234765d9d652648e2be00`](https://github.com/debezium/debezium/commit/800ae11b7e7e23ab4f3234765d9d652648e2be00), released 1 July 2026. Stable release: [`v3.6.0.Final`](https://github.com/debezium/debezium/releases/tag/v3.6.0.Final). | `debezium-core/`, `debezium-connector-postgres/`, `debezium-connector-sqlserver/`, `documentation/`, connector unit/integration test trees, `LICENSE.txt`. | Apache-2.0. Runtime implies Kafka Connect and a substantial Java/broker/operator supply chain. | Actively maintained 3.6 line with extensive connector/unit/integration testing and release documentation; release is built around Kafka Connect 4.3.0. | Snapshot/stream transitions, source offsets, consistent-position capture, schema/change events, and retry semantics inform migration state models. UAM's first path does not need database CDC and has an accepted no-broker default. | Explicit snapshot modes, offsets/continuation, schema history awareness, connector capability matrices, failure/restart testing. | Kafka/Kafka Connect as default; broad CDC of legacy personal schema; broker custody/replay as second truth; connector-specific payloads; interpreting change capture as business semantics. | **Reference only.** Reconsider only after a measured CDC/broker trigger. |
| **OpenLineage** — `OpenLineage/OpenLineage`, release **1.52.0**, commit [`cfd47d6f3e1b13167136b2508768c94a2351af23`](https://github.com/OpenLineage/OpenLineage/commit/cfd47d6f3e1b13167136b2508768c94a2351af23), 23 July 2026. | `spec/`, `client/`, `integration/`, Java/Python/Go clients, tests, `CODE_QUALITY_AND_SECURITY.md`, `LICENSE`. | Apache-2.0. Multiple language clients/integrations add surface if adopted. | Active releases; cross-language and integration tests; documented signed-release/code-quality/security practices. | Run, Job, Dataset, and facet concepts are useful for comparison-run provenance. The standard permits custom facets and can capture SQL/source code/errors, which UAM must exclude. | Run/dataset/job identity, versioned facets, parent-child provenance, producer/version metadata. | Generic global lineage service, arbitrary/custom facets, SQL/source-code/error payloads, broad connector ecosystem, using lineage as authorization or evidence truth. | **Reference only** for vocabulary; use a closed UAM provenance schema. |
| **OpenMined PSI** — `OpenMined/PSI`, release **v2.0.6**, commit [`c1aa5a65279b33738a6f971b17ed7b495e8d9caf`](https://github.com/OpenMined/PSI/commit/c1aa5a65279b33738a6f971b17ed7b495e8d9caf), 24 June 2025. | `private_set_intersection/`, C++/Python/Java/Go bindings and tests, including server/client test code, `SECURITY.md`, `LICENSE`. | Apache-2.0. Cryptographic dependency and multi-language/native build demand specialist review. | Latest release about thirteen months before research; CI/CD, Dependabot, tests, and security policy exist. | Provides two-party private-set intersection/cardinality under parties that should not reveal datasets. UAM comparator is a single trusted realm-scoped service reading two authorized sides, so PSI's protocol/operational cost is unnecessary. GCS/Bloom modes can have false positives; exact invariants cannot rely on them. | Explicit privacy threat model, cardinality-only mode, separation between exact/raw/GCS/Bloom trade-offs, cryptographic test discipline. | Treating approximate PSI as exact equality; two-party key/protocol infrastructure; using cryptography to compensate for overbroad internal access; Raw mode as default. | **Reference only.** Not a dependency for the same-trust-boundary comparator. |
| **Liquibase** — `liquibase/liquibase`, release **v5.0.3**, commit [`4d815ea8b10bc33ee9f93b5e5b05ed9f0b532fcb`](https://github.com/liquibase/liquibase/commit/4d815ea8b10bc33ee9f93b5e5b05ed9f0b532fcb), 15 May 2026. | `liquibase-standard/`, core parser/change/checksum code, `liquibase-integration-tests/`, database-specific tests, `LICENSE`, `SECURITY.md`. | From 5.0, Functional Source License 1.1 with a future Apache-2.0 change date; not an ordinary permissive OSS dependency at review time. Exact binary/use terms require Legal. | Active release/security fixes; broad database integration tests. v5.0.3 includes SQL Server/PostgreSQL diff-related fixes and release hardening. | Immutable changesets, checksums, execution ledger, rollback metadata, and database compatibility tests inform configuration/migration evidence. Its purpose is executable database schema/data change, much broader and more privileged than UAM comparison. | Content-addressed change identity, checksums, ordered migration ledger, rollback documentation, database matrix. | Arbitrary SQL changesets, tool-owned database mutation, schema diff as semantic oracle, broad database credentials, current license assumptions. | **Reference only.** No migration runtime dependency selected. |
| **data-diff** — `datafold/data-diff`, release **0.11.2**, 17 May 2024; exact released source artifact SHA-256 `4a6d34a5017098673d65dd926335fe602d25ec9159976ead207ebb17528768d0`; repository archived 17 May 2024. Stable release: [`0.11.2`](https://pypi.org/project/data-diff/0.11.2/). | `data_diff/`, database drivers, hash/bisection algorithms, `tests/`, `README.md`, `LICENSE`. | MIT. Archive/no-maintenance status is the primary compatibility risk; source artifact was not uploaded via trusted publishing. | No active support/development since May 2024. Historical tests and cross-database functionality exist, but security/compatibility drift is unaddressed. | Cross-database hash partitioning and recursive bisection closely resemble mismatch localization. Its CLI accepts connection URIs, can output row differences, supports custom filters, and documentation discusses self-healing writes—outside UAM authority/privacy bounds. | Partition/bisection idea, stateless comparison, primary-key range localization, database type-bridging lessons. | Connection URIs/passwords on command line, raw differing rows, arbitrary filter/column selection, usage analytics, self-healing target writes, archived code as load-bearing dependency. | **Reference only; not dependency.** |

## 14.2 Cost, licensing, skills, and operations conclusion

**RECOMMENDATION.** Implement the narrow comparator/state machine in the accepted C#/.NET repository rather than adopting a general Python/Java data-quality platform. This avoids a second runtime language/patch pipeline, plugin framework, broad database credential surface, and tool-specific evidence schema. It does not make the work free: the project still needs skills in legacy PowerShell/SQL Server discovery, .NET contracts/cryptography, PostgreSQL/SQL Server read semantics, data/report semantics, privacy/security, test-oracle design, SRE, accessibility, and incident response.

Operational costs that must be measured rather than guessed:

- legacy snapshot/replica and query load;
- shadow storage and evidence retention;
- comparator/projector CPU, memory, duration, and database concurrency;
- key management and independent evidence verification;
- owner review and known-defect/tolerance administration;
- recurring time/tzdb, schema, report, release, and consumer qualification;
- cutover/rollback drills and extended legacy support window;
- read-only archive, backups, deletion/restore, and eventual decommission;
- accessibility and support staffing.

No repository above is admitted as a production dependency by this result. Exact versions must be re-reviewed at execution time because maintenance, licenses, advisories, and ownership can change.

---

# 15. Source register with stable links, dates, reviewed versions/commits, claims, and limitations

## 15.1 Supplied project evidence

| Ref | Source/date | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, baseline 31 July 2026, SHA-256 in section 2.3. | Accepted endpoint/server/privacy/durability/realm/release/restore invariants. | Condensed working baseline; not production approval or runtime proof. |
| I02 | `01-existing-system-evidence-summary.md`, reviewed local attachment. | Direct endpoint SQL, deferred executable SQL, monolithic legacy behavior, broad settings/checkpoint/report/audit presence. | Static redacted evidence; runtime configuration, all consumers, values, rates, and practices absent. |
| I03 | `04-data-and-schema-evidence-summary.md`. | Legacy schema shape; target typed/provenance/data-state principles; missing workload evidence. | Metadata/curated summary, no row semantics or throughput. |
| I04 | `05-decisions-contradictions-and-gates.md`. | Accepted architecture tensions and proof-gate order. | Implementation research baseline, not unconditional production authority. |
| I05 | `06-research-evidence-rules.md`. | Evidence vocabulary, source-quality and human-decision boundaries. | Rules, not proof of technical capability. |
| I06 | `batch-01-review-result.md`, review 31 July 2026. | T1 fixtures/oracle/canaries, strict contracts, UUIDv7/digests, compatibility matrices, privacy/repository controls. | Accepted with mandatory conditions; many CLI/human gates open. |
| I07 | `batch-02-review-result.md`, review 31 July 2026. | Source natural identity, interpretation separation, page-owned progress, Task Host minimization, no automatic historical reinterpretation. | G2–G5 runtime gates remain evidence-bound. |
| I08 | `batch-03-review-result.md`, review 31 July 2026. | Endpoint durability/batching, receipt semantics, release/identity/diagnostics/compatibility exact-tuple gates. | No engineering canary or supported platform established at review close. |
| I09 | `batch-04-review-result.md`, review 1 August 2026. | Relational custody, one-effect identity, typed facts/projections, reconciliation, capacity/lifecycle/restore architecture. | All Batch 04 production gates remain open; cleanup after ACK prohibited. |
| I10 | `22-legacy-discovery-result.md`. | Required legacy semantics/consumers/config/fence/decommission evidence. | **Missing. No claim was substituted.** |

## 15.2 Primary standards and specifications

| Ref | Stable link | Source/release date and reviewed version | Claim supported | Limitation |
|---|---|---|---|---|
| S01 | https://www.rfc-editor.org/info/rfc8785/ | RFC 8785, June 2020. | Deterministic JSON representation using I-JSON constraints and property sorting; suitable input to cryptographic digests. | Informational, not Standards Track; JCS preserves parsed strings and has number/I-JSON constraints. UAM semantic normalization remains field-specific. |
| S02 | https://www.rfc-editor.org/info/rfc2104/ | RFC 2104, February 1997. | HMAC construction and purpose-separated keyed integrity concept. | Generic HMAC document predates modern hash choices; UAM uses a reviewed SHA-256 profile, not MD5/SHA-1 examples. |
| S03 | https://www.rfc-editor.org/info/rfc4231/ | RFC 4231, December 2005. | HMAC-SHA-256/384/512 conformance vectors. | Test vectors do not define UAM key lifecycle/domain separation. |
| S04 | https://csrc.nist.gov/pubs/fips/180-4/upd1/final | FIPS 180-4 update, August 2015; NIST notes a future revision is planned. | SHA-256 digest algorithm basis. | Document is slated for revision; exact execution-time crypto policy must be rechecked. |
| S05 | https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final | NIST SP 800-57 Part 1 Rev. 5, May 2020, current final reviewed. | General cryptographic key-management lifecycle and protection considerations. | General guidance, not a UAM KMS/retention/approval decision; Rev. 6 work may supersede it later. |
| S06 | https://www.rfc-editor.org/info/rfc9162/ | RFC 9162, December 2021. | Domain-separated Merkle Tree Hash construction, split rule, and append-only verification patterns. | Certificate Transparency threat/protocol differs; UAM reuses only the tree-hash construction over counted keyed leaves. |
| S07 | https://www.rfc-editor.org/info/rfc3339/ | RFC 3339, July 2002. | Internet UTC timestamp profile basis. | Does not by itself express named zone context or UAM precision/bucket semantics. |
| S08 | https://datatracker.ietf.org/doc/rfc9557/ | RFC 9557, April 2024. | Standard extension syntax for timestamps with additional information such as time-zone annotations. | Zone annotation does not decide legacy business interpretation; UAM still pins tzdb and explicit profile. |
| S09 | https://www.iana.org/time-zones | IANA Time Zone Database **2026c**, released 8 July 2026, latest as of research date. | Point-in-time time-zone rule version for comparison vectors and evidence. | Time-zone rules change; every run must record its exact version and must not hardcode 2026c as timeless architecture. |
| S10 | https://www.w3.org/TR/prov-dm/ | W3C PROV-DM Recommendation, 30 April 2013. | Provenance concepts for entities, activities, agents, derivations, and bundles. | General conceptual model; full RDF/PROV stack is not required or selected. |
| S11 | https://opentelemetry.io/docs/specs/otel/metrics/sdk/ | OpenTelemetry Metrics SDK specification, reviewed 1 August 2026. | SDKs should support hard metric cardinality limits after filtering. | Living specification and generic telemetry model; UAM owns a stricter finite attribute catalogue and budget. |
| S12 | https://www.w3.org/TR/WCAG22/ | WCAG 2.2 W3C Recommendation, 12 December 2024. | Testable accessibility guidance for any migration-review web workflow; automated and human evaluation are both relevant. | Does not cover every user need or decide formal legal/procurement conformance. |

## 15.3 Repository/release sources

| Ref | Stable link and reviewed point | Release/date | Claim supported | Limitation |
|---|---|---|---|---|
| R01 | https://github.com/GoogleCloudPlatform/professional-services-data-validator/commit/3d57ab87e31573dfcfe0ffee0cb4fe4a4b6555c0 | DVT v8.9.0, 31 July 2026. | Active heterogeneous database-validation reference with tests/config/query modes. | Broad Python/SQL/cloud/raw-row authority; unofficial support posture; reference only. |
| R02 | https://github.com/fivetran/great_expectations/commit/f6d7aec4f43cf0a9bae53a48ad0ec93003dc4bd4 | Great Expectations 1.19.1, 24 July 2026. | Declarative expectations/checkpoints and extensive tests. | Unexpected-row/query output and extensibility are privacy/authority risks; reference only. |
| R03 | https://github.com/sodadata/soda-core/commit/0416a3d0a47d04c112dd8f8d8b7b5cc017888c57 | Soda Core v4.19.0, 28 July 2026. | Active data-contract/check framework and SQL dialect tests. | Elastic License 2.0, broad connectors/cloud/log/check language; not selected. |
| R04 | https://debezium.io/releases/3.6/ and https://github.com/debezium/debezium/commit/800ae11b7e7e23ab4f3234765d9d652648e2be00 | Debezium v3.6.0.Final, commit `800ae11b7e7e23ab4f3234765d9d652648e2be00`, 1 July 2026. | CDC snapshot/offset/continuation reference. | Kafka Connect/broker and broad CDC failure domains conflict with initial UAM design. |
| R05 | https://github.com/OpenLineage/OpenLineage/commit/cfd47d6f3e1b13167136b2508768c94a2351af23 | OpenLineage 1.52.0, 23 July 2026. | Run/job/dataset/facet provenance vocabulary and active multi-language project. | Arbitrary facets/SQL/code/error data can exceed UAM privacy contract. |
| R06 | https://github.com/OpenMined/PSI/commit/c1aa5a65279b33738a6f971b17ed7b495e8d9caf | PSI v2.0.6, 24 June 2025. | Private-set cardinality/equality design reference and cryptographic test posture. | Different two-party threat model; approximate modes incompatible with exact gate. |
| R07 | https://github.com/liquibase/liquibase/commit/4d815ea8b10bc33ee9f93b5e5b05ed9f0b532fcb | Liquibase v5.0.3, 15 May 2026. | Changeset/checksum/rollback/database-matrix patterns. | Functional Source License 1.1 for current line and broad mutation authority; reference only. |
| R08 | https://pypi.org/project/data-diff/0.11.2/ and https://github.com/datafold/data-diff | data-diff 0.11.2, 17 May 2024; repository archived same date. | Hash/bisection cross-database diff pattern. | No active maintenance; raw rows, connection URI, arbitrary filters/self-healing writes; not dependency. |

## 15.4 Source-use limitations

- Standards document capabilities and formats, not UAM-specific privacy, correctness, cost, or operational fitness.
- Repository release activity, tests, and licenses do not prove safe production use in UAM.
- No current source establishes the missing legacy report/configuration/consumer semantics.
- Search snippets, stars, popularity, marketing performance, and generic benchmark numbers were not used as UAM proof.
- Exact dependency versions and advisories must be rechecked at implementation/release time.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would lower or raise confidence |
|---|---|---|---|
| One business-authoritative path per scope/epoch is required | **High** | Directly composes with accepted one-effect, realm, audit, receipt, and restore invariants. | Lower only through a formal baseline change with a proved multi-authority transaction model; not expected. |
| Endpoint dual-write must remain impossible | **High** | Target endpoint has no SQL/database authority; fan-out creates irreversible ambiguity and expanded attack surface. | Exact artifact/network evidence raises runtime confidence; a surviving mutation lowers it to stop. |
| Isolated new shadow storage is an acceptable parallel-validation mechanism | **High for architecture; Medium for operations** | It separates observation from business effect and is testable. Storage/load/access cost is unmeasured. | R1/R3 load, lifecycle, role, and non-egress evidence. |
| Server-side reconciliation after minimization is preferable to raw endpoint/server duplication | **High** | Preserves accepted privacy boundary and central trust context. | A required semantic that cannot be represented without a new approved field would narrow the comparison scope. |
| Compatibility projection should be derived/read-only and not legacy write-back | **High** | Avoids legacy mutation/consumer side effects and keeps canonical facts authoritative. | A consumer-specific read API may be added after a separate contract/gate; live legacy write-back remains low confidence. |
| JCS + per-run HMAC-SHA-256 + counted RFC 9162-style multiset root is fit for T1 | **Medium-High** | Primary standards support components and construction avoids duplicate cancellation/linkable unkeyed hashes. UAM vectors/performance are unexecuted. | Independent implementation, hostile canonicalization, collision/multiplicity, key, and scale tests. |
| Exact invariants must have zero tolerance | **High** | Privacy, realm, authority, progress, and one-effect failures cannot be made safe by percentages. | No expected change; only the set of exact report semantics may grow. |
| Tolerances/known defects need owner, scope, evidence, expiry, and visibility | **High** | Prevents hidden loss/defect institutionalization and satisfies explicit prompt authority boundaries. | Human governance failure would lower operational confidence, not change architecture. |
| Configuration snapshot -> LIM -> pure transform -> no-broadening review is the right model | **High** | Legacy executable SQL/scripts and weak evidence make direct copy unsafe; target privacy lattice is accepted. | Prompt 22 may require new typed LIM variants, but not arbitrary execution. |
| Read-only archive is safer than wholesale historical migration by default | **High** | No approved historic use, semantics, keys, retention, or lifecycle evidence exists. | Named approved use cases with complete import/restore/deletion evidence may justify subsets. |
| Cutover/rollback should use frozen state, monotonic epochs, and exact boundaries | **High for principle; Low for current executability** | Principle protects gap/overlap/duplicate effects. Actual legacy fence/common key is unknown. | Prompt 22 plus successful exact environment fence and rollback drills. |
| Real legacy report equivalence is currently established | **Low / no** | Missing Prompt 22, report contracts, consumers, defects, and human semantics. | Accepted report inventory/contracts and representative closed-window evidence. |
| Real production parallel-run cost/capacity is known | **Low / no** | No representative distributions, query corpus, budgets, or resource runs. | E23-24 and approved aggregate measurements on the exact topology. |
| Sensitive break-glass can be operated safely | **Medium-Low** | Mechanism can be bounded, but authority, staffing, monitoring, and human behavior are unproved. | Passed case-bound drills, owner decisions, canaries, cleanup, and incident exercises. |
| An existing OSS framework should be a production dependency now | **Low / no** | Every reviewed project has a broader query/plugin/data/broker/license/language surface or maintenance mismatch. | Exact bake-off and dependency admission proving lower total assurance cost. |
| Semantic pilot, cutover, rollback, or decommission is ready | **Low / explicitly blocked** | Required same-stream legacy discovery is missing and all relevant human/CLI gates are open. | G23-INPUT through applicable aggregate gates plus designated risk approval. |

---

# Residual risk and explicit next stop/go gate

What remains unsafe, uncertain, costly, human-dependent, or impossible to prove through research alone:

- The legacy system may contain undiscovered dynamic SQL paths, manual writers, production-only settings, reports, spreadsheets, integrations, or operational workarounds.
- Exact legacy report meaning, defects, time behavior, source/checkpoint identity, and consumer reliance are unknown without Prompt 22 and owner evidence.
- Parallel observation intentionally creates a second minimized copy for a bounded period; its lawful purpose, access, retention, employee consultation, and risk acceptance are human decisions.
- A keyed digest reduces durable disclosure but does not make underlying in-memory comparison harmless; a privileged process, administrator, dump mechanism, EDR, hypervisor, or key holder can still expose values.
- Cryptographic equality proves equality under the chosen canonical profile, not that the profile is correct, complete, lawful, useful, or free of shared bugs.
- Legacy and new systems may share a conceptual defect, especially if report formulas or source interpretations are reconstructed from the same mistaken assumption.
- Time-zone history, late data, source deletion, weak legacy identity, shared credentials, and manual consumers can make a perfectly exact cutover fence impossible. The safe consequence may be a longer freeze, an acknowledged gap, retirement of a report, or no cutover; only accountable humans can accept those outcomes.
- Fail-closed comparison and authority controls can cause collection/reporting outages and backlog. Operations, support, budget, and user communication are not established.
- A read-only legacy archive prolongs patching, access control, backup, restore, deletion, licensing, and skill obligations. Historic import creates different but equally real lifecycle cost.
- A malicious or mistaken authorized release/owner can create internally coherent profiles, defects, tolerances, or evidence. Independent review and audit reduce but cannot eliminate collusion or governance failure.
- External exports/manual copies and decisions already made from legacy outputs cannot be recalled by technical reconciliation.
- Accessibility evidence must recur as the review interface, browser, assistive technology, and workflow evolve.

## Next stop/go gate

**GO now:** implement and execute the R0/R1 T1 backlog—strict contracts, fictional fixtures/oracle, no-dual-write architecture tests, isolated shadow state, canonical/keyed multiset comparison, projector/configuration prototypes, mismatch workflow, canaries, and evidence verification.

**STOP now:** no real-data parallel run, semantic pilot, cutover, rollback, historical import, decommission, or production claim.

The next decision point is:

> **G23-INPUT plus T1 aggregate gate:** obtain and review the exact `22-legacy-discovery-result.md`; prove endpoint dual-write is impossible; prove shadow non-egress, realm/privacy containment, deterministic digests, complete mismatch classification, and configuration no-broadening with fictional evidence. Only then may owners consider an approved real shadow pilot.

The primary migration-validation gate remains:

> **Every exact invariant passes; every tolerated mismatch has an owner-approved reason; every material mismatch is classified; endpoint dual-write remains impossible.**

