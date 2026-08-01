# Prompt 24 result — cutover, rollback, legacy read-only operation, credential removal, monitoring, and decommissioning

**Result path:** `batches/06-migration/24-cutover-decommission/result-24-cutover-decommission.md`  
**Research date:** 1 August 2026  
**Decision status:** **CONDITIONAL RECOMMENDATION — IMPLEMENTATION-LEVEL DESIGN ACCEPTED FOR T1/LAB SCAFFOLDING; AUTHORITY TRANSFER AND FINAL DECOMMISSION REMAIN BLOCKED**  
**Authority boundary:** enterprise cutover, rollback, legacy read-only operation, credential/network removal, residual monitoring, archive handoff, operational readiness, and decommission evidence; **not** legal purpose, retention, historical-access ownership, bake duration, go/no-go authority, residual-risk acceptance, production change approval, or final production acceptance  
**Primary gate:** **Final decommission requires zero unauthorized legacy writes, dispositioned buffers and consumers, revoked credentials, blocked paths, owned history, tested rollback, and multi-owner acceptance.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed implementation baseline for this topic. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into production approval.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION — use a staged, one-way authority transfer, not a big-bang replacement and not indefinite dual writing.** The new UAM release is pre-staged in disabled or comparison-only mode, moved through explicit rings, observed for an approved bake period, and promoted only when every hard safety signal is healthy. A ring failure automatically **pauses further promotion**. It does not automatically recreate legacy credentials, re-enable legacy endpoint database trust, or execute deferred legacy SQL.

The safest rollback unit is the **new-system release and capability set for one ring**. Rollback means selecting an already-authorized previous new-system payload, disabling a new capability, or pausing collection while durable buffers remain intact. After legacy credentials are revoked or network paths are denied, there is no supported rollback to the legacy endpoint-to-database design. Recreating those credentials would knowingly restore a rejected trust boundary and requires a formal accepted-baseline change proposal rather than an emergency convenience.

**RECOMMENDATION — separate cutover into three irreversible milestones:**

1. **Authority transfer:** the new system becomes the only component authorized to create new UAM activity effects for the cohort.
2. **Legacy trust removal:** legacy schedules are disabled, active sessions are terminated, credentials/certificates/secrets are revoked, and network write paths are blocked.
3. **Final decommission:** historical access has an owner, buffers and consumers are dispositioned, residual exceptions are bounded, cleanup is proved, and multi-owner acceptance is recorded.

These milestones are intentionally not presented as one atomic transaction. Endpoint scheduling, SQL Server sessions, firewall policy, certificate status, archive state, CMDB state, and portal state cross independent systems. UAM MUST instead use an idempotent prepare/verify/commit workflow with durable evidence at each boundary.

## 1.2 Evidence limitation and current disposition

**FACT.** Nine allowlisted predecessor/baseline files were present and reviewed. **UNKNOWN.** The two required same-stream results, `result-22-legacy-discovery.md` and `result-23-parallel-run-reconciliation.md`, were not present. No other project file was substituted.

Consequences:

- the exact inventory of legacy tasks, scripts, service accounts, login ownership, external consumers, deferred SQL buffers, portal mutations, network paths, and unreachable-device behavior is **UNKNOWN**;
- the exact parallel-run comparison key, tolerances, attribution rules, expected mismatch classes, and acceptance logic are **UNKNOWN**;
- this result can define contracts, states, runbooks, lab experiments, evidence records, and stop gates, but it cannot declare a cohort ready for authority transfer or final decommission;
- any conclusion that depends on Prompts 22 or 23 is explicitly provisional and becomes a reconciliation input when those results exist.

## 1.3 Consolidated verdict

**RECOMMENDATION — GO** for the following now:

- strict cutover, ring, authority, exception, credential-removal, archive, and decommission-evidence contracts;
- pure state machines and T1 fictional fixtures;
- a cutover coordinator module inside the accepted server/control-plane boundary;
- read-only inventory and residual-monitoring scripts using placeholders and sanitized evidence;
- disposable Windows/SQL lab experiments for schedule disablement, session termination, login/certificate revocation, firewall denial, new-release rollback, archive reads, and cleanup;
- synthetic operational game days and support training;
- build-time architecture tests that prohibit any legacy credential, SQL text, arbitrary script, or production connection detail from entering the new endpoint or cutover contracts.

**RECOMMENDATION — STOP** before:

- any real authority transfer;
- any production schedule, service, login, certificate, firewall, secret, or database mutation during research;
- any import, execution, or deletion of legacy deferred SQL/CSV without an accepted disposition contract;
- any claim that parallel results are equivalent or sufficiently reconciled;
- any historical archive activation without an owner, access purpose, retention decision, audit path, and restore test;
- any credential recreation for rollback;
- final decommission acceptance while either missing same-stream result remains unresolved.

## 1.4 Gate summary

| Gate | Current state | Required closure evidence | Non-waivable stop condition |
|---|---|---|---|
| **B06-DISCOVERY** | **BLOCKED — missing evidence** | accepted inventory of every legacy writer, reader, task, script, service, login, certificate, secret, network path, deferred buffer, portal mutation, integration, archive, owner, and unreachable-device class | unknown writer/consumer/path or an unowned high-risk item |
| **B06-RECONCILIATION** | **BLOCKED — missing evidence** | accepted parallel-run comparison contract, deterministic identities, mismatch taxonomy, expected gaps, data-quality thresholds, and ring-entry evidence | comparison cannot distinguish expected semantic change from loss, duplication, cross-realm mix, or privacy defect |
| **B06-RING** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | exact cohort manifest, release/storage compatibility, minimum monitoring coverage, support/on-call, approved bake/stop criteria, lab rollback | any hard safety signal, unknown monitor, stale evidence, or unavailable rollback target |
| **B06-AUTHORITY** | **OPEN** | legacy quiesce evidence, final legacy watermark, new authority command, audit, no concurrent ordinary writer, data-gap/overlap statement | two ordinary writers, unauthorized write, cursor/effect conflict, or unsupported environment |
| **B06-READONLY** | **OPEN** | portal mutation routes absent, database writes denied, active write sessions terminated, write probes rejected, historical reads audited | one successful unauthorized write or an unclassified mutation path |
| **B06-CREDENTIAL** | **OPEN** | complete principal/secret/certificate ownership map; disable/revoke/rotate; active sessions terminated; paths blocked; failed-use monitoring; cleanup | credential remains valid, active session remains authorized, secret remains in deployment/config, or alternate path succeeds |
| **B06-BUFFER** | **BLOCKED — discovery/reconciliation dependent** | counts/digests, creation freeze, typed disposition, unreachable-device policy, consumer completion, no silent discard | executable SQL is imported blindly, unacknowledged data is silently dropped, or ownership is absent |
| **B06-ARCHIVE** | **OPEN — HUMAN DECISION + CLI EXPERIMENT** | owner, purpose, fields, retention, access, read-only enforcement, audit-before-disclose, restore, accessibility, deletion responsibilities | writable historical surface, unowned retention, unaudited sensitive read, or restored stale write path |
| **B06-RESIDUAL** | **OPEN** | bounded post-cutover observation, zero successful legacy writes, classified failed attempts, endpoint/software/CMDB reconciliation, expiring exceptions | successful residual write, unknown recurring attempt, exception without owner/expiry, or blind monitoring interval |
| **B06-DECOM** | **BLOCKED** | all gates above, tested new-only rollback, runbooks/training, cleanup receipt, decommission acceptance record and multi-owner sign-off | any primary-gate predicate false or any blocking owner absent |

## 1.5 Confidence and residual risk

**Confidence: High** that rollback must never depend on resurrecting legacy endpoint database trust. This follows directly from the accepted invariant that endpoints never receive central database credentials or submit SQL, from the accepted enterprise-owned release boundary, and from the legacy evidence that the old endpoint can write SQL directly and defer executable SQL text.

**Confidence: Medium** in the proposed ring/authority architecture. Progressive exposure, bake, automatic pause, same-digest promotion, and higher-sequence rollback are strongly supported; exact ring contents, bake periods, and reconciliation signals remain human- and evidence-dependent.

**Confidence: Low** in any exact buffer, consumer, or final-removal plan until Prompts 22 and 23 exist. Static predecessor evidence proves that deferred SQL and broad mutation paths exist, but not their complete runtime inventory or safe disposition.

Residual risk remains from hidden dynamic SQL, manual consumers, unreachable devices, stale installation media, long-lived sessions, delayed certificate revocation information, firewall/GPO drift, archived backups, human workarounds, and collusion or error by privileged operators. The design contains these risks with one-way authority, explicit holds, independent residual monitoring, expiring exceptions, and multi-owner acceptance; it cannot prove their absence through research prose alone.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result covers:

- canary/ring cutover, cohort authority, bake, pause, rollback, and promotion;
- legacy write quiescence and transfer to new-system authority;
- legacy portal read-only transition and historical archive handoff;
- compatibility-write expiry and removal;
- endpoint legacy buffer/deferred-work disposition;
- unreachable devices and residual exceptions;
- schedule, script, service, account, login, certificate, secret, firewall, network, deployment, and CMDB cleanup;
- privacy-safe residual activity monitoring;
- change control, communications, on-call, game day, incident response, support training, runbooks, evidence, owner acceptance, and post-decommission monitoring;
- final retention/archive/deletion responsibility questions without deciding their legal or business answers.

## 2.2 Non-goals

This result does not:

- redesign the accepted endpoint, ingestion, database, portal, audit, release, identity, or deletion architecture;
- select the production database, PKI, secrets manager, workflow platform, SIEM, CMDB, or archive technology;
- define the legal purpose, prohibited uses, identity precision, first-run lookback, retention periods, employee consultation, SLO/RPO/RTO, budget, staffing, support hours, or production authority;
- infer the complete legacy inventory from static evidence;
- approve production changes or provide production-specific hostnames, addresses, credentials, certificate identifiers, login names, SQL text, or SSH material;
- promise continuous coverage across the transfer boundary where source semantics, first-run policy, or unreachable devices make that impossible;
- treat UAM telemetry or a successful cutover as forensic proof that no historical activity existed.

## 2.3 Reviewed project evidence

| Ref | Allowlisted file | SHA-256 | Use | Limitation |
|---|---|---|---|---|
| **I01** | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted architecture and non-negotiable invariants | condensed baseline, not production proof |
| **I02** | `01-existing-system-evidence-summary.md` | `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | legacy PowerShell, direct SQL, deferred executable SQL, schedules, broad mutation evidence | static/sanitized; misses runtime settings, consumers, volumes, and paths |
| **I03** | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions and ordered proof gates | not runtime evidence |
| **I04** | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence quality, labels, human authority, conflict rules | proves no technical behavior |
| **I05** | `result-review-01-foundations.md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | strict contracts, privacy/policy, application identity, repository/release, G1 boundary | conditional architecture; predecessor gates remain relevant |
| **I06** | `result-review-02-endpoint-data.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | source continuity, privacy transform, whole-page progress, data-quality semantics | synthetic/lab gates, not migration inventory |
| **I07** | `result-review-03-durability-release-identity.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | endpoint durability, release rollback, identity/revocation, diagnostics, compatibility | aggregate gate open; exact platform/PKI values provisional |
| **I08** | `result-review-04-server-platform.md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | durable custody, endpoint cleanup hold, lifecycle, tombstones, restore readiness | production cleanup/database/capacity/lifecycle gates open |
| **I09** | `result-review-05-portal-governance.md` | `38dc40cc0e07b560da4bcf477d3a0c20e01e2d2aba430e3187eddf21742bed99` | purpose-bound admin, command/audit transaction, break-glass, restore, accessibility | portal/audit aggregate gate open |
| **M01** | `result-22-legacy-discovery.md` | **MISSING** | required same-stream discovery evidence | no substitution permitted |
| **M02** | `result-23-parallel-run-reconciliation.md` | **MISSING** | required same-stream comparison/reconciliation evidence | no substitution permitted |

No accepted-baseline change proposal is raised. The design preserves the accepted endpoint privacy boundary, no-endpoint-SQL rule, at-least-once/idempotent delivery, durable receipt meaning, MSI/enterprise release ownership, realm isolation, transactional audit, tombstone/restore rules, and no-broker default.

## 2.4 Accepted inputs carried forward

The following are **FACT** from I01 and accepted reviews:

1. Legacy endpoints directly write SQL Server and may defer executable SQL in CSV; this trust model is not carried into the target.
2. New endpoints send only minimized typed HTTPS batches and never hold central database credentials or submit SQL.
3. The target endpoint persists unacknowledged minimized data and source progress atomically; no silent loss is allowed.
4. A server receipt means durable custody only. Production endpoint cleanup remains disabled until the Batch 04 receipt/restore/lifecycle gates and human policies pass.
5. Release rollback uses immutable authorized payloads, side-by-side current/previous slots, higher sequence, and storage compatibility; an unauthorized or downgraded release never executes.
6. Installation identity, realm binding, release/control state, business data, and diagnostics are separate state classes and purpose-separated credentials.
7. Privileged changes require same-transaction authorization and audit; operational logs are not the audit ledger.
8. Restore and historical read enablement are separate privileged transitions and cannot revive deleted data or stale authority.
9. Feature flags and kill switches may narrow, pause, or disable; none may bypass realm, privacy, audit, receipt, tombstone, release, or readiness invariants.

## 2.5 Assumptions and smallest falsifiers

| ID | **ASSUMPTION** | Why bounded | Smallest falsifier / consequence |
|---|---|---|---|
| A24-01 | Enterprise management can deploy a new signed payload and disable/uninstall the legacy package for named cohorts. | MSI/enterprise management is accepted, but the actual tool/estate is unknown. | One claimed cohort cannot reliably stage, disable, rollback, or report state; remove it from scope or qualify its management profile. |
| A24-02 | Legacy SQL writes can be identified by authenticated principal/session/application/network evidence without collecting activity payloads. | SQL Server exposes login/session/audit primitives; exact legacy identity map is missing. | A writer cannot be distinguished from another approved consumer; B06-DISCOVERY remains blocked. |
| A24-03 | A historical archive can be separated from active mutation authority. | SQL Server can enforce read-only at database and permission layers; exact topology is open. | Required historical workflow needs writes into the same legacy database; create a typed archive workflow or keep the archive gate closed. |
| A24-04 | A cohort can have one authoritative activity writer while another implementation runs comparison-only. | Consistent with one-effect identity and bounded parallel validation; exact Prompt 23 contract missing. | Comparison requires both systems to create indistinguishable ordinary business effects; redesign the comparison boundary before cutover. |
| A24-05 | Failed legacy connection attempts can remain visible long enough to identify residual software after credentials are revoked. | SQL Audit/Extended Events/OS monitoring can observe attempts, but retention/access are open. | Monitoring misses a known positive control or creates forbidden high-cardinality/raw data; no residual assurance claim. |
| A24-06 | Legacy write credentials can be revoked globally without losing required historical reads. | Endpoint writer and archive reader authority should be separable; actual login ownership is unknown. | Same credential is shared with an indispensable reader/consumer; split/replace that dependency before revocation. |
| A24-07 | New release N and authorized N-1 remain storage/contract compatible through cutover bake. | Accepted release architecture requires this; exact release evidence is open. | Lab rollback cannot read/write the same store safely; cutover stops before ring entry. |
| A24-08 | Operators can execute a fixed runbook without arbitrary shell/SQL channels in the portal. | Accepted portal architecture requires typed commands; exact enterprise tooling is open. | A required operation cannot be expressed as a finite reviewed capability; create a fixed tool/contract, not a generic command channel. |

## 2.6 Unknowns that block production cutover

- exact legacy writer, reader, login, certificate, task, service, script, package, firewall, DNS/alias, proxy, scheduled job, integration, report, and manual-consumer inventory;
- whether one legacy credential is shared across endpoints or consumers, and which existing sessions survive a disable action;
- amount, age, semantics, and recoverability of deferred executable SQL/CSV on reachable and unreachable endpoints;
- exact new-vs-legacy reconciliation key, time window, semantic transformation, expected omissions, and tolerable data-quality differences;
- approved cohort membership, ring sizes, bake periods, support coverage, communications audience, and rollback/go-no-go authority;
- exact Windows/Edge/network/VDI/EDR tuples in migration scope;
- historical archive owner, purpose, data fields, retention, access roles, legal holds, export obligations, deletion responsibilities, and restore objective;
- exact residual-monitoring duration and thresholds;
- production database engine and legacy topology;
- current enterprise management, PKI, secrets, firewall, CMDB, SIEM, archive, and ticketing platforms;
- budget, staffing, licenses, support hours, SLO/RPO/RTO, and final acceptance authority.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Design invariants

The cutover design MUST preserve these invariants:

1. **Exactly one ordinary authority per cohort/source epoch.** Comparison output is explicitly non-authoritative until transfer.
2. **No legacy trust resurrection.** New rollback never recreates legacy database credentials, endpoint SQL, deferred executable SQL, arbitrary scripts, or direct endpoint database paths.
3. **No cross-system atomicity claim.** Every external action is idempotent, observed, reconciled, and evidence-linked.
4. **Pause before unsafe rollback.** Unknown, stale, blind, cross-realm, privacy, receipt, cursor, audit, or credential state pauses progression.
5. **Buffers survive uncertainty.** Unacknowledged new-system data is retained; legacy deferred work is frozen and dispositioned explicitly, never silently dropped or blindly executed.
6. **Realm-first authority.** Ring, cohort, archive, exception, and decommission records are realm-bound by authenticated context; payload claims do not establish realm.
7. **Read-only is multilayered.** UI, API, application identity, database permissions/state, active sessions, network path, and residual monitoring all agree.
8. **One-way credentials.** Revocation/rotation state is monotonic; reactivation is a new governed issuance with a different purpose, not a rollback toggle.
9. **Same-digest promotion.** Rings promote one verified signed release digest; environments do not rebuild it.
10. **Every privileged transition is audited.** Plan activation, pause, authority transfer, legacy quiesce, revocation, archive enablement, exception, and final acceptance commit authorization and typed audit.
11. **Technical state does not claim legal completion.** Archive/deletion states report capability and evidence, not legal conclusions.
12. **No human workaround becomes architecture.** Manual emergency steps are fixed, typed, independently authorized, expiring, and reconciled.

## 3.2 Components

| Component | Exact responsibility | Explicit prohibitions | Owner function |
|---|---|---|---|
| **Migration/Cutover Module** | Persist immutable plans, cohorts, ring state, prerequisites, commands, observations, holds, exceptions, evidence links, and terminal decisions inside the modular monolith. | No endpoint script execution, SQL console, credential storage, arbitrary path/command, direct firewall/PKI mutation, or hidden auto-promotion. | Cutover Engineering / Architecture |
| **Cutover Plan Compiler** | Validate closed plan schema; resolve release-owned cohort criteria into immutable manifests; bind release, contracts, storage compatibility, privacy ceiling, rollback targets, monitors, and owner roles. | No free-form query, tenant expression, dynamic code, body-derived realm, or production value inference. | Release/Cutover Engineering |
| **Ring Controller** | Evaluate entry, bake, stop, promotion, and pause rules for one immutable cohort manifest and release digest. | No automatic credential recreation, legacy re-enable, threshold invention, or promotion when a monitor is unknown/stale. | Release Operations |
| **Authority Registry** | Hold the authoritative state for legacy/new collection and visibility per realm/cohort/source family/epoch. | No two `PRIMARY` authorities; no state change without audit/evidence; no lower-sequence rollback. | Data Correctness / Cutover |
| **Endpoint Enterprise Deployment Adapter** | Request and observe signed package install/repair/rollback, schedule disablement, service stop/uninstall, and inventory through approved enterprise tooling. | No raw credentials, arbitrary remote shell from portal, user-profile crawl, or direct source read. | Endpoint Management |
| **Legacy Quiesce Adapter** | Execute fixed, pre-reviewed lab/production change procedures for known schedules, scripts, services, SQL jobs, and compatibility writers; return typed evidence. | No discovery by broad production crawl; no arbitrary SQL/script; no action outside an approved inventory item. | Legacy Operations |
| **Credential Revocation Coordinator** | Orchestrate disable/revoke/rotate, active-session termination, ownership cleanup, status publication, secret-store/deployment removal, and verification across SQL/PKI/secrets systems. | Does not hold plaintext secrets; cannot mint a replacement legacy endpoint credential; no automatic destructive action from a metric. | Security/IAM/PKI + Database Security |
| **Network Denial Coordinator** | Apply/verify fixed server-side and enterprise policy rules that block legacy write paths and retain approved archive/new-system paths. | No broad host firewall weakening, tenant-supplied address, endpoint-created allow rule, or direct production mutation during research. | Network Security / Endpoint Security |
| **Legacy Read-Only Gateway** | Serve approved historical read models through the accepted BFF with purpose, realm, field, and audit-before-disclose controls. | No legacy mutation API, direct database credential in browser, generic query, SQL, activity dump, or untracked export. | Archive/Data Product + IAM |
| **Compatibility Writer** | Optional, temporary server-side typed adapter for an indispensable legacy consumer during migration; stable identity, idempotency, audit, kill, and hard expiry. | Never runs on endpoints; no SQL text payload; no indefinite bridge; no broad schema pass-through. | Integration Owner |
| **Buffer Disposition Service** | Inventory value-free counts/digests; freeze creation; classify reachable/unreachable buffers; execute only an approved typed drain/quarantine/expire decision; preserve evidence. | No blind execution/import of deferred SQL; no silent discard; no raw buffer in portal/logs/support bundle. | Data Reliability + Records/Product |
| **Residual Activity Monitor** | Combine database sessions/audit, failed login/cert attempts, network deny evidence, endpoint task/service/package inventory, and CMDB reconciliation into bounded safe findings. | No raw activity, command lines, internal addresses, user identities, unbounded labels, or sole reliance on one sensor. | Security Monitoring / SRE |
| **Exception Registry** | Record unreachable/unsupported/manual-consumer residuals with exact scope, owner, risk, next action, expiry, review, and blocking class. | No permanent exception, wildcard scope, auto-renew, or use as authority to restore legacy trust. | Risk/Operations Governance |
| **Decommission Evidence Builder** | Produce content-addressed, privacy-safe evidence and acceptance records from authoritative states and signed tool outputs. | No self-asserted pass, raw secrets, connection strings, activity, or overwritten failures. | Verification Governance |
| **Independent Gate Evaluator** | Recompute primary predicates, evidence freshness, first failures, exception expiry, and multi-owner approvals; emit pass/hold. | Cannot mutate source state, suppress findings, or infer missing evidence as pass. | Independent Verification / Architecture Review |
| **Support and Incident Plane** | Fixed runbooks, escalation, accessible status, synthetic reproduction, safe evidence, pause/kill, and recovery. | No raw data request as default, remote arbitrary command, unaudited break-glass, or production dump. | Support Operations / Incident Response |

## 3.3 Trust-boundary flow

```text
signed release + storage compatibility + privacy ceiling + contracts
  -> immutable CutoverPlan candidate
  -> server-side validation and owner/approval checks
  -> immutable cohort/ring manifest
  -> enterprise pre-stage (new collection disabled or comparison-only)
  -> exact inventory/reconciliation prerequisites
  -> ring entry decision
  -> comparison observations (non-authoritative)
  -> approved bake with complete monitors
  -> PAUSE on any hard failure or unknown
  -> LegacyQuiesceCommand
       schedules/services/jobs disabled
       deferred-work creation frozen
       final legacy watermark/evidence captured
  -> AuthorityTransferCommand
       one server transaction updates authority epoch + audit + jobs
  -> NewPrimary bake
  -> Legacy portal/application read-only
  -> credential/session revocation and network denial
  -> residual-monitoring interval + exception handling
  -> archive ownership/readiness
  -> final component/service/task/package/CMDB cleanup
  -> independent decommission gate
  -> multi-owner acceptance

No browser -> database credential
No endpoint -> SQL/database
No portal -> arbitrary shell/script/SQL/firewall/PKI action
No metric -> credential recreation or destructive automatic rollback
No restored legacy environment -> ordinary write or endpoint receipt authority
```

## 3.4 Authority states

The authority registry uses these closed states:

| State | Meaning | Permitted writes | Visibility |
|---|---|---|---|
| `LEGACY_PRIMARY` | Legacy remains the approved ordinary writer for the cohort. | legacy only; new system may be disabled | legacy operational view only |
| `NEW_COMPARISON_ONLY` | New system executes approved T1/controlled comparison and writes segregated comparison evidence, not ordinary business effects. | legacy ordinary; new comparison store only | no ordinary portal impact |
| `TRANSFER_PREPARED` | Cohort, monitors, quiesce plan, final watermark method, rollback target, and approvals are frozen. | legacy still primary | unchanged |
| `LEGACY_QUIESCED` | Known legacy schedules/writers are disabled and creation of new deferred work is frozen; verification is pending. | no approved ordinary legacy write | no new authority yet |
| `NEW_PRIMARY_PROBATION` | New system is sole ordinary writer; legacy trust still partly present only where required for bounded recovery verification. | new only | new facts subject to normal processing/visibility states |
| `NEW_PRIMARY_ACCEPTED` | Ring passed bake and reconciliation. | new only | new system authoritative |
| `LEGACY_READ_ONLY` | Legacy portal/data retained for approved history; all mutation paths denied. | none | approved historical reads only |
| `LEGACY_TRUST_REVOKED` | Legacy write credentials/certs/secrets are revoked and active sessions terminated; paths denied. | none | archive path only if approved |
| `DECOMMISSION_MONITORING` | Components removed/disabled; residual attempts and exceptions observed. | none | archive and safe status only |
| `DECOMMISSIONED` | Primary gate passed and multi-owner acceptance recorded. | none | owned archive only |
| `SAFETY_HOLD` | Evidence is missing, stale, conflicting, or a hard invariant failed. | no new authority transition | bounded safe status only |

`LEGACY_QUIESCED` MUST NOT automatically transition back to `LEGACY_PRIMARY`. Before credential revocation, a human-authorized emergency may re-enable only a specific known legacy schedule if the accepted cutover ADR explicitly permits it and no rejected trust is reintroduced. The recommended default is to pause and repair the new system instead.

## 3.5 Ring, bake, and stop criteria — mandatory artifact

### 3.5.1 Ring model

Ring names describe increasing blast radius, not fixed population numbers:

| Ring | Purpose | Entry scope | Required evidence before promotion |
|---|---|---|---|
| **R0 — disconnected lab** | Prove contracts, state machines, install/rollback, read-only, revocation, network denial, buffer cases, and cleanup with T1 data. | disposable Windows/SQL/archive environment | all hard tests pass; cleanup receipt; no real data/credentials |
| **R1 — designated engineering canary** | Prove the exact release and supported tuple under controlled operational support. | one approved low-blast, representative cohort manifest | accepted predecessor gates for tuple; Prompt 22/23 evidence; rollback game day; support/on-call; monitors complete |
| **R2 — representative operational canary** | Exercise variation in management, network, source, time zone, and operating patterns without broad exposure. | approved representative cohort, excluding unresolved exceptions | R1 bake passed; no hard failures; mismatch classes understood; residual capacity healthy |
| **R3 — constrained broad rollout** | Validate fleet-scale management, backlog, support, and residual monitoring. | bounded larger cohort per realm/site/support domain | R2 passed; capacity/headroom and support queues within human-approved limits |
| **R4 — general rollout** | Complete authority transfer across approved estate. | all currently eligible supported cohorts | all prior rings current; exception population owned; final legacy-revocation plan ready |
| **R5 — residual/unreachable** | Handle devices that return after general rollout or cannot be remediated on schedule. | explicit expiring exceptions only | credential/path denial active; uninstall/new enrollment on return; no ordinary legacy write possible |

**HUMAN DECISION.** Ring membership, population, geographic/realm distribution, support hours, and promotion authority are not selected here.

### 3.5.2 Bake model

**FACT.** Microsoft safe-deployment guidance describes bake time as the interval during which a deployment remains in a group so health can be observed, and recommends increasing bake time across broader rollout groups to observe normal use and time-zone variation [W01–W02].

**RECOMMENDATION.** Each ring definition MUST include:

- `minimumBake`, `maximumObservationWindow`, and `requiredCoverageClasses` as owner-approved values;
- at least one complete expected use/maintenance cycle relevant to the ring, rather than a universal number;
- declared start/pause/resume semantics; time spent while a required monitor is unavailable does not count;
- minimum event/source/endpoint/maintenance diversity, not just elapsed time;
- a stable release/configuration digest for the whole counted interval;
- no unclassified hard failure and no expired waiver;
- support and incident coverage for the entire period.

**Conservative temporary default:** do not auto-promote. Require an explicit human promotion after all hard predicates pass, all required coverage classes were observed, and the minimum bake completed. This default is safe but may slow delivery.

### 3.5.3 Hard automatic-pause criteria

Any one of these MUST pause the ring and all dependent promotions:

- privacy canary or forbidden value outside the Task Host boundary;
- cross-realm/session/installation effect, read, mutation, cache, archive, or audit result;
- cursor/progress ahead of durable effect, changed stable identity, duplicate ordinary effect, or receipt conflict;
- server receipt outside the declared durable failure domain;
- unauthorized, stale, incomplete, downgraded, mixed, or unverified release executes;
- legacy and new system both create ordinary effects for the same authority epoch;
- one successful unauthorized legacy write after quiesce/read-only deadline;
- active legacy credential/session/path remains after its revocation gate;
- hard reconciliation mismatch classified as loss, duplication, realm mix, privacy broadening, or unknown;
- required monitor is stale/unavailable or its positive control fails;
- unacknowledged data is dropped or a buffer is silently discarded;
- privileged command commits without authorization/audit;
- restored/archive environment exposes a mutation path;
- rollback target cannot open the new-system store/contracts safely;
- cleanup leaves a service, task, process, key, certificate, firewall rule, package, or test artifact that the run declared removable.

### 3.5.4 Owner-approved quantitative stop criteria

The following require measurement and **HUMAN DECISION** rather than invented values:

- maximum new-system error/retry/backlog rate and growth;
- maximum operational mismatch by approved reason class;
- acceptable endpoint/install/update failure distribution;
- maximum support incident rate and time-to-triage;
- minimum archive/read-model availability;
- maximum unreachable/residual-exception population and age;
- database, network, storage, CPU, memory, handle, and cardinality budgets;
- recovery and backlog-drain targets after a pause/outage.

Crossing an approved threshold pauses promotion. It does not authorize deletion, credential recreation, or legacy reactivation.

## 3.6 Authority transfer sequence

**RECOMMENDATION.** For each cohort:

1. Freeze the exact cohort manifest, release digest, contract/schema digests, storage compatibility, privacy ceiling, comparison profile, and owner set.
2. Verify all predecessor gates and the accepted Prompt 22/23 outputs for this scope.
3. Pre-stage the new signed payload; keep collection disabled or comparison-only.
4. Verify new endpoint identity, policy, compatibility, local store, upload, receipt, diagnostics, and support path with T1/approved controlled evidence.
5. Freeze changes to legacy schedules/scripts/configuration except approved cutover actions.
6. Stop creation of new legacy deferred SQL/CSV; inventory counts, size classes, oldest/newest classes, owners, and content digests without sharing raw SQL.
7. Disable known legacy collection schedules/services/jobs for the cohort.
8. Capture a final legacy watermark/evidence record and verify no successful writes during the quiesce interval.
9. Commit one `AuthorityTransferCommand` in the new control plane. The transaction advances the authority epoch, writes authorization/audit, and enqueues new-system activation. It does not claim the external legacy actions are atomic.
10. Activate the new system for the cohort. Start from the human-approved first-run policy; record any intentional gap/overlap explicitly.
11. Observe `NEW_PRIMARY_PROBATION`; keep hard pause available.
12. On pass, mark `NEW_PRIMARY_ACCEPTED`, set legacy portal/app read-only, and begin trust removal.
13. Disable/revoke writer credentials and certificates, terminate active sessions, remove/rotate secrets, and block network paths.
14. Enter residual monitoring. Any successful write is an incident and blocks decommission.
15. Move historical access to the owned archive/read-only gateway, then remove the original legacy runtime and remaining components.
16. Generate and independently verify the decommission acceptance record.

## 3.7 Smallest-safe rollback and full rollback conditions

### 3.7.1 Smallest-safe rollback unit

The preferred order is:

1. disable one new capability for one ring/realm/source family;
2. pause new collection while preserving the endpoint store and unacknowledged data;
3. select the already-installed, independently verified previous new-system payload under a higher authorized release sequence;
4. roll back a server module/schema only when N/N-1 compatibility and restore evidence pass;
5. quarantine new comparison/materialization output without changing custody truth;
6. if no safe new payload exists, hold collection and repair out-of-band through enterprise management.

A rollback MUST preserve event/batch identity, endpoint data, receipt state, source checkpoint, realm binding, audit, tombstones, and archive/read-only state.

### 3.7.2 Full rollback triggers

A designated human rollback authority may order broad rollback/pause for:

- confirmed privacy or realm isolation failure;
- false receipt, cursor-ahead, double effect, or acknowledged-data loss;
- widespread source corruption or browser impact;
- compromised release/signing/identity authority;
- widespread unsupported compatibility result;
- material reconciliation evidence of loss/duplication that cannot be contained to a ring;
- database/restore failure that invalidates the declared custody or rollback domain;
- monitoring blindness during a high-risk transition;
- severe operational impact beyond approved threshold.

**RECOMMENDATION.** “Full rollback” means fleet-wide pause or rollback to a known-good **new-system** release. It does not mean reissuing legacy endpoint SQL credentials. If leadership wants that option before trust removal, it must be explicitly time-bounded in the cutover plan, pass a separate threat review, and close before credential revocation. After revocation, the option is unavailable by design.

## 3.8 Legacy read-only, archive, and residual exception model — mandatory artifact

### 3.8.1 Layered legacy read-only state

A legacy environment is `VERIFIED_READ_ONLY` only when all relevant layers pass:

1. **Portal/UI:** mutation controls and routes are absent, not merely hidden.
2. **API/application:** write handlers/jobs/schedulers are disabled; the runtime identity has no write authority.
3. **Database principal:** application/reader identities have only approved read permissions; writer roles/grants are removed or denied.
4. **Database state:** where operationally fit, the archive database or restored copy is set `READ_ONLY`; SQL Server documents that users can read but not modify a database in this state [W12]. This is a candidate control, not a substitute for access/audit.
5. **Sessions:** sessions created under old writer credentials are terminated; disabling a SQL login alone does not end existing sessions [W06–W08].
6. **Network:** write-capable service paths are denied; only approved archive/BFF/database administration paths remain.
7. **Jobs/integrations:** SQL Agent jobs, task schedulers, scripts, ETL, and external writers are disabled or moved to typed replacements.
8. **Audit/monitoring:** write probes, SQL Audit/Extended Events, network denial, and application tests detect attempted mutation.
9. **Restore:** any restored archive starts read-blocked/read-only and must prove the same controls before access.
10. **Evidence:** a signed read-only verification record references exact principal, database, application, route, job, network, and test evidence by digest, without exposing names or addresses.

### 3.8.2 Historical archive options

| Option | Recommendation | Advantages | Risks/conditions |
|---|---|---|---|
| **A. Read-only copy/snapshot served through new BFF** | **Preferred initial candidate** | separates history from legacy runtime; purpose/realm/audit/accessibility can use accepted portal controls | needs owner, retention, restore, schema adapter, performance, and deletion decisions |
| **B. Original legacy DB set read-only with restricted reader identity** | Conditional interim | simplest short-term handoff; preserves exact data shape | retains legacy engine/runtime coupling; privileged DBAs can still alter; background behavior and backup lifecycle must be tested |
| **C. Typed migration into new historical schema** | Conditional long-term | removes legacy runtime and supports governed fields/retention | mapping can reinterpret data; requires provenance, reconciliation, deletion, query, and restore proof |
| **D. Static exports/files** | Rejected as default | low runtime complexity | weak access/revocation/search/deletion/audit; copies proliferate; accessibility and authenticity harder |
| **E. Keep legacy portal indefinitely** | Rejected | avoids migration work | preserves broad mutation/authentication/dependency attack surface and support cost |

Historical data MUST show an accessible “historical as of” time, source/system provenance, known quality limitations, unavailable periods, and the fact that UAM evidence is fallible. It MUST NOT present legacy and new values as directly comparable unless Prompt 23 approves that interpretation.

### 3.8.3 Compatibility write expiry

A compatibility writer, if unavoidable, MUST be:

- server-side, typed, one-purpose, same-realm, idempotent, audited, monitored, and isolated from endpoints;
- bound to an immutable contract, destination, owner, approved reason, start, hard expiry, maximum scope, and kill switch;
- incapable of receiving SQL, script, path, credential, or arbitrary payload from a tenant or endpoint;
- omitted from the final architecture by default;
- automatically disabled at expiry and unable to self-renew;
- treated as a blocker to final decommission until no pending or ambiguous work remains.

### 3.8.4 Residual exception model

```text
ResidualException {
  exceptionId
  realmBinding
  assetOrConsumerClass             # opaque controlled identifier
  exceptionType                    # UNREACHABLE_DEVICE | UNKNOWN_CONSUMER | ARCHIVE_DEPENDENCY | ...
  scopeManifestDigest
  discoveredAtUtc
  lastObservedClass
  riskClass
  ownerFunction
  nextAction
  blocksWhichGate[]
  notBeforeUtc
  expiresAtUtc
  reviewCadenceClass
  networkAndCredentialContainment
  evidenceDigest
  status                           # OPEN | CONTAINED | REMEDIATED | EXPIRED_UNRESOLVED | ACCEPTED_BY_HUMAN
}
```

Rules:

- every exception MUST have an owner, expiry, bounded scope, containment, next action, and explicit gate impact;
- expiry without remediation becomes `EXPIRED_UNRESOLVED` and blocks acceptance; no auto-renew;
- an unreachable device MAY remain installed with legacy software only when legacy credentials are revoked, network paths are blocked, and return-to-service triggers removal/new enrollment before collection;
- an exception cannot authorize legacy writes or credential recreation;
- the final accepting human authority may accept only named residual risk; technical records must still say what was not proved.

## 3.9 Credential, network, buffer, schedule, and component removal checklist — mandatory artifact

The checklist is executed only from an approved inventory. Research and lab use placeholders; production change requires separate authority.

### A. Freeze and inventory

- [ ] Freeze legacy configuration, script, task, job, login, certificate, secret, firewall, package, and schema changes except approved cutover work.
- [ ] Record content-addressed inventory and owner for every known writer, reader, consumer, schedule, service, SQL job, deployment package, configuration source, login, database user/role, certificate, API key/secret, network path, firewall rule, proxy route, DNS/alias, archive, backup, CMDB item, and deferred buffer class.
- [ ] Prove inventory scanners detect planted T1 positive controls.
- [ ] Classify unknowns and open expiring residual exceptions.

### B. Stop new legacy work

- [ ] Disable known endpoint schedules and service start/restart paths; record before/after state.
- [ ] Disable server-side legacy jobs, compatibility writers, portal mutation routes, and manual runbook triggers.
- [ ] Freeze creation of new deferred SQL/CSV and record final count/digest/age classes.
- [ ] Verify no automatic repair, enterprise baseline, login script, GPO, package repair, watchdog, or failover recreates the task/service.

### C. Dispose buffers and consumers

- [ ] New-system buffers remain governed by receipt/cleanup rules; do not delete unacknowledged data.
- [ ] Legacy deferred executable SQL is **not** ingested into the new system as code.
- [ ] For each legacy buffer: select `DRAIN_UNDER_LEGACY_BEFORE_TRANSFER`, `TRANSFORM_TO_TYPED_EVENT_AFTER_PROOF`, `QUARANTINE_FOR_INVESTIGATION`, or `EXPIRE/DISCARD_BY_HUMAN_POLICY`.
- [ ] Record stable counts/digests before/after, final consumer result, ambiguity, and cleanup.
- [ ] For unreachable devices, record containment and on-return behavior; do not claim the local buffer was removed.
- [ ] Prove every external/manual consumer is retired, replaced, or exception-owned.

### D. Portal/database read-only

- [ ] Remove/disable mutation UI routes and background handlers.
- [ ] Replace application identity with an approved read-only identity or move data to a read-only copy.
- [ ] Remove/deny database write permissions and role memberships.
- [ ] Terminate existing writer sessions.
- [ ] Disable write-capable SQL jobs/triggers/integrations as identified.
- [ ] Where fit, set the archive database/copy read-only and verify restore/backup behavior.
- [ ] Execute positive and negative write probes through UI, API, application identity, database identity, and a privileged test boundary.
- [ ] Enable audit-before-disclose for sensitive historical reads/exports.

### E. Credentials and certificates

- [ ] Identify credential purpose, owner, issuer/store, consumers, scope, active sessions, renewal/rotation path, recovery copy, deployment copy, backup copy, and revocation evidence.
- [ ] Disable legacy SQL login or remove authentication path; immediately identify and terminate existing sessions because disablement does not itself disconnect them [W06–W08].
- [ ] Remove grants/role memberships and remap ownership/jobs before dropping a login; dropping can be blocked by owned securables/jobs and can orphan mapped users [W07].
- [ ] Rotate any shared secret still used by an approved consumer; do not leave a disabled-but-known fleet secret as rollback material.
- [ ] Revoke legacy certificates and publish status/CRL according to PKI policy; retain revocation service and evidence for the remaining certificate lifetime. AD CS guidance warns that outstanding/revoked certificates and CRL lifetime affect decommission timing [W09–W11].
- [ ] Remove secret values from deployment systems, enterprise packages, task arguments, configuration stores, protected files, source/build artifacts, support systems, backups where policy permits, and operator workbooks.
- [ ] Delete private-key material only after required evidence/recovery decisions; do not copy it into the decommission record.
- [ ] Prove failed authentication attempts are denied and classified.

### F. Network and firewall

- [ ] Remove or deny legacy endpoint-to-database routes at the server/network boundary.
- [ ] Remove legacy application/service allow rules after approved archive paths are separated.
- [ ] Verify active policy, not only local rule configuration; enterprise policy may override local settings.
- [ ] Verify no alternate port, proxy, VPN, NAT, DNS alias, secondary listener, failover address, or management subnet preserves the path.
- [ ] Use bounded connection/session monitoring and positive controls.
- [ ] Remove temporary lab/test firewall rules and prove cleanup.

### G. Services, tasks, scripts, accounts, packages, and CMDB

- [ ] Disable, then observe, then unregister/remove scheduled tasks and services through enterprise tooling; Microsoft exposes dedicated ScheduledTasks and service cmdlets [W03–W05].
- [ ] Remove scripts, modules, package caches, startup entries, configuration files, and repair sources only after rollback/forensic-evidence decisions.
- [ ] Remove or disable legacy-only service accounts, directory memberships, SPNs, managed identities, and local rights **only when inventory proves ownership and no shared consumer remains**.
- [ ] Remove obsolete firewall/GPO/MDM/package assignments and deployment detection rules.
- [ ] Update CMDB/software catalogue/ownership/support state to `RETIRED`, `ARCHIVE_ONLY`, or the approved equivalent.
- [ ] Verify reinstall/repair does not recreate the legacy component.

### H. Acceptance and residual observation

- [ ] Observe zero successful unauthorized legacy writes for the approved period.
- [ ] Classify every failed attempt; recurring unknown attempts block acceptance.
- [ ] Reconcile endpoint/software inventory, SQL sessions/logins, certificates, secrets, firewall paths, packages, jobs, archive access, backups, and CMDB.
- [ ] Verify rollback game day, support runbooks, on-call, accessible status, and incident communications.
- [ ] Verify every exception is current, owned, contained, and explicitly accepted or blocking.
- [ ] Generate the decommission evidence and acceptance record; obtain multi-owner decision.

## 3.10 Configuration ownership, flags, and kill switches

| Control | Owner function | May do | Must not do |
|---|---|---|---|
| `pauseNewCollection` | Cutover/Incident authority | stop new permits for one scope | delete buffers, change cursor, enable legacy |
| `pauseNewUpload` | Data Reliability/Security | stop sends while retaining sealed batches | mark receipt, purge payload |
| `disableNewCapability` | Product Privacy/Release | narrow one source/field/capability | broaden ceiling or reinterpret history |
| `freezeLegacySchedules` | Legacy/Endpoint Operations | disable approved inventory items | execute arbitrary script or affect unlisted item |
| `denyLegacyNetworkPath` | Network Security | block known legacy route | weaken unrelated controls or add an allow |
| `disableCompatibilityWriter` | Integration Owner | stop temporary typed bridge | extend expiry or restore endpoint SQL |
| `archiveReadBlock` | Archive/Data Security | stop historical disclosure | enable mutation or bypass audit |
| `residualSafetyHold` | Security/Data Reliability | block promotion/acceptance | self-clear or suppress evidence |
| `rollbackNewRelease` | Designated release/rollback authority | select known-good authorized new payload | lower sequence, rebuild, use staging, recreate legacy credential |

All controls are release-owned finite commands with exact realm/scope, reason, idempotency identity, expiry where applicable, authorization, transactional audit, and accessible status. No generic feature-flag system may express `trustLegacyRealm`, `skipAudit`, `ignoreWriteProbe`, `recreateCredential`, `executeDeferredSql`, or equivalent bypasses.

## 3.11 Privacy-safe observability and metric cardinality

Residual and rollout telemetry uses a compile-time catalogue and finite labels such as:

```text
component_class
ring_id_class
phase
release_ring
source_family
legacy_control_class
outcome_family
reason_family
monitor_freshness_class
exception_type
archive_state
credential_state_class
network_path_state
```

Forbidden metric labels/details include realm, tenant, installation, device, user, SID, session, host, address, port, URL, path, task/service/login/certificate/secret name, SQL text, command line, application, buffer content, event ID, batch ID, ticket, exception ID, and arbitrary exception message. Exact identifiers/digests belong in access-controlled evidence records, not global series.

The route/action/metric catalogues MUST compute a theoretical maximum series count in CI. Unknown dynamic labels fail the build. Temporary security monitoring such as Sysmon network/process events can contain command lines and addresses and network event collection is not enabled by default; therefore it is only a bounded, security-approved residual sensor, never the ordinary UAM diagnostic path [W21–W23].

## 3.12 Communications, change control, and on-call

Every ring change record MUST contain:

- exact plan, cohort, release, contract, storage, policy, monitor, rollback, runbook, and evidence digests;
- human go/no-go and rollback authority functions;
- start window, minimum bake, support coverage, freeze scope, and known limitations;
- accessible internal status wording for `PREPARING`, `BAKING`, `PAUSED`, `ROLLING_BACK_NEW`, `LEGACY_READ_ONLY`, `RESIDUAL_MONITORING`, and `DECOMMISSIONED`;
- incident commander, cutover director, endpoint, server/data, database, security/PKI, network, support, archive/records, and communications functions;
- primary/secondary contact mechanism and an out-of-band route;
- precise stop/pause statement and safe next action;
- customer/workforce/legal communication only when the accountable human authority approves it.

The change record MUST say what a pause means: new promotion stops, current buffers remain, no legacy credentials are recreated, and scope-specific service behavior is visible. It MUST not describe an ordinary coverage gap as “no activity.”

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Why rejected or deferred | Evidence/condition that could change it |
|---|---|---|---|
| **Big-bang fleet cutover** | **REJECTED** | Maximizes blast radius, hides cohort-specific compatibility and reconciliation faults, and leaves no evidence-backed pause boundary. | Only an external hard deadline plus proof that staged coexistence is materially more dangerous; would still require lab rollback and formal risk acceptance. |
| **Indefinite dual ordinary writes** | **REJECTED** | Creates two business authorities, duplicate/conflicting effects, reconciliation debt, longer credential exposure, and unclear deletion/restore truth. | A formally versioned dual-authority contract with one-effect proof and bounded expiry; no such need/evidence exists. |
| **New system comparison-only before transfer** | **ACCEPTED** | Supports evidence without changing ordinary business truth when outputs are segregated and Prompt 23 defines comparison semantics. | Must remain disabled if comparison cannot avoid raw-value leakage or duplicate ordinary effects. |
| **Automatically roll back to legacy on metric failure** | **REJECTED** | Can restore direct endpoint DB trust, stale scripts, deferred SQL execution, and old credentials from an ambiguous signal. | No expected change. Automatic action may pause new work or select authorized new N-1 only. |
| **Keep legacy credentials dormant for emergency rollback** | **REJECTED AFTER TRUST-REMOVAL GATE** | Dormant reusable fleet credentials remain attack material and make decommission non-final. | Before revocation, a narrowly time-bounded contingency may exist as a human decision, but it blocks final trust removal and must expire. |
| **Recreate legacy credentials after revocation** | **REJECTED — baseline conflict** | Directly violates the accepted no-endpoint-database-credential/no-SQL architecture. | Requires a formal baseline change proposal with new primary evidence, privacy/security impact, migration cost, and smallest falsifier. |
| **Execute legacy deferred SQL after transfer** | **REJECTED** | Executable text is not a typed event, may target stale schema/realm/state, and bypasses target authorization/audit/idempotency. | A parser/transform can be considered only if Prompt 22/23 proves complete semantics and a typed, synthetic, fail-closed conversion passes; raw execution remains rejected. |
| **Discard every legacy buffer at the deadline** | **REJECTED AS ENGINEERING DEFAULT** | May silently lose unacknowledged or required data; retention/loss is human-owned. | Accountable human policy may authorize a specific bounded discard after counts/digests, impact, legal/records review, and evidence. |
| **Wait for every unreachable endpoint before revoking shared trust** | **REJECTED** | A lost/unreachable device can hold the fleet hostage and prolong credential risk indefinitely. | Named high-value devices may have an approved exception; credentials/paths still require containment and expiry. |
| **Uninstall legacy first, revoke credentials later** | **REJECTED AS PRIMARY CONTROL** | Uninstall coverage is never complete for unreachable devices; remaining binaries can still write while trust exists. | Uninstall remains cleanup, not the security boundary. |
| **Revoke credentials first without inventory/consumer split** | **REJECTED** | Can break required readers/manual integrations and obscure ownership; active sessions may survive login disablement. | Proceed only after inventory, dependency replacement, active-session termination plan, and rollback of the change procedure itself are proved. |
| **UI-only legacy read-only mode** | **REJECTED** | Hidden controls do not block direct API, job, database, or stale-session writes. | No expected change. Layered verification is mandatory. |
| **Database `READ_ONLY` as the sole archive control** | **REJECTED AS SOLE CONTROL** | Privileged roles and operational topology remain; access purpose, audit, exports, restore, and lifecycle are unresolved. | It remains a useful defense-in-depth layer after exact engine tests. |
| **Keep original legacy portal indefinitely for history** | **REJECTED** | Retains broad attack/dependency/support surface and confuses active vs historical data. | Only a short, owner-approved transition with mutation paths removed and hard retirement date. |
| **Static CSV/PDF export as primary archive** | **REJECTED** | Creates uncontrolled copies, weak audit/revocation/deletion, poor query provenance, and accessibility risk. | A very small, legally/records-approved immutable dataset with controlled repository, encryption, access, retention, and deletion may be exceptional. |
| **Generic runbook automation platform with production shell/SQL** | **REJECTED AS ARCHITECTURE** | Imports arbitrary-command, credential, plugin, node, and script authority beyond UAM's closed capabilities. | A platform may orchestrate approved fixed tools from outside UAM after separate security/procurement evidence; UAM still records typed commands/evidence. |
| **Use endpoint firewall rules alone** | **REJECTED** | Local policy can drift/be overridden and the legacy process may run with differing authority. | Endpoint rules may supplement server/network denial and DB revocation. |
| **Use SQL login disablement alone** | **REJECTED** | Existing connections can remain active; permissions/ownership/mapped users persist. | No expected change; terminate sessions, remove rights, block network, monitor. |
| **Use certificate revocation alone** | **REJECTED** | Revocation distribution/cache/validation behavior can be delayed or unavailable; outstanding certificate lifetimes matter. | Keep revocation as one layer with application status and network denial. |
| **Use one monitoring sensor as proof of no residual activity** | **REJECTED** | Every sensor has blind spots and false negatives. | A small set of independent sensors plus positive controls and inventory reconciliation is required. |
| **Adopt an external broker for cutover events** | **REJECTED BY DEFAULT** | Adds a failure/operations/restore domain without a measured need; accepted server already has relational inbox/jobs/audit. | Quantitative fan-out/replay/isolation/cost trigger and separate ADR/prototype. |
| **Make an OSS progressive-delivery controller a runtime dependency** | **REJECTED** | Reviewed tools target Kubernetes traffic/workloads, not Windows endpoint authority, buffers, credentials, realm, or historical archive. | Reuse concepts only; a dependency would need a separately deployed platform requirement and full threat/ops comparison. |
| **Per-realm bespoke cutover code** | **REJECTED** | Duplicates logic, weakens consistent evidence, and increases maintenance/realm-confusion risk. | Realm-specific data/config may narrow one release-owned state machine; code remains shared and tested. |

## 4.1 Conditions that would materially change this recommendation

A formal review is required if new evidence shows:

- Prompt 22 proves the legacy endpoint does not use a reusable credential or direct write path in a material cohort;
- Prompt 23 proves a safe, bounded dual-write mechanism is necessary and simpler than comparison-only;
- enterprise management cannot reliably stage/rollback side-by-side new releases;
- N/N-1 storage compatibility cannot be maintained through bake;
- a legal/records decision requires preserving the exact legacy runtime rather than an archive copy/read model;
- an indispensable external consumer cannot use a typed server-side bridge;
- a selected PKI/secrets/network platform cannot supply timely revocation/denial evidence;
- the operational organization cannot sustain independent monitoring, support, and multi-owner acceptance;
- a database/archive technology makes layered read-only or restore evidence materially impossible.

Any change that permits endpoints to hold central DB credentials, submit SQL, execute arbitrary migration scripts, or make lower-sequence rollback requires the accepted-baseline change process from I01/I04.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Common contract requirements

Every cutover contract MUST:

- use the accepted strict UTF-8, closed-object, bounded contract profile;
- use canonical lower-case UUIDv7 for new UAM IDs and SHA-256 for content/evidence digests under the accepted algorithm-agility rules;
- derive realm, actor, and installation authority from authenticated context, not body claims;
- identify exact contract, schema, product release, storage compatibility, privacy ceiling, policy, route/action, and evidence versions;
- define idempotency, expected current version, state preconditions, finite errors, retry class, timeout/expiry, audit, and rollback meaning;
- contain no credential, certificate private material, address, host, URL, path, SQL, script, command line, personal data, raw activity, raw legacy buffer, or generic extension bag;
- be signed or otherwise authorized under the accepted control-artifact profile where it changes endpoint/release/realm authority;
- use consumer-first compatibility and executable old/new vectors.

## 5.2 `CutoverPlanV1`

```json
{
  "contract": "uam.migration.cutover-plan",
  "version": "1.0.0",
  "planId": "019d0000-0000-7000-8000-000000002401",
  "planSequence": 12,
  "state": "APPROVED",
  "scopeManifestDigest": "sha-256:fictional-scope",
  "targetRelease": {
    "releaseId": "fictional-new-release",
    "releaseSequence": 104,
    "payloadDigest": "sha-256:fictional-payload",
    "storageCompatibilityDigest": "sha-256:fictional-storage"
  },
  "rollbackTargets": [
    {
      "releaseId": "fictional-known-good",
      "releaseSequence": 105,
      "payloadDigest": "sha-256:fictional-known-good",
      "storageCompatibilityDigest": "sha-256:fictional-storage"
    }
  ],
  "contractBundleDigest": "sha-256:fictional-contracts",
  "productCeilingDigest": "sha-256:fictional-ceiling",
  "comparisonProfileDigest": "sha-256:missing-until-prompt-23",
  "legacyInventoryDigest": "sha-256:missing-until-prompt-22",
  "ringDefinitions": ["R0", "R1", "R2", "R3", "R4", "R5"],
  "hardStopProfileId": "cutover-hard-stop-v1",
  "monitorProfileId": "cutover-monitor-v1",
  "bufferDispositionPolicyId": "HUMAN_DECISION_REQUIRED",
  "archivePlanId": null,
  "notBeforeUtc": "2026-08-01T00:00:00Z",
  "expiresAtUtc": "2026-09-01T00:00:00Z",
  "ownerFunctions": [
    "CUTOVER_DIRECTOR",
    "RELEASE_AUTHORITY",
    "SECURITY",
    "DATA_RELIABILITY",
    "ENDPOINT_OPERATIONS"
  ],
  "contentDigest": "sha-256:fictional-plan"
}
```

Normative rules:

- a plan cannot be `APPROVED` while `legacyInventoryDigest` or `comparisonProfileDigest` is missing for a production scope;
- `rollbackTargets` contain only already-authorized new-system releases; legacy packages/credentials are structurally absent;
- expiry stops new transitions; it does not undo completed states;
- same `planId` and sequence with different content is a security failure;
- rollback republishes a prior payload at a higher release sequence.

## 5.3 `RingDefinitionV1`

```json
{
  "contract": "uam.migration.ring-definition",
  "version": "1.0.0",
  "ringId": "R2",
  "cohortManifestDigest": "sha-256:fictional-cohort",
  "entryGateIds": ["B06-DISCOVERY", "B06-RECONCILIATION", "B06-RING"],
  "minimumBakeProfile": "HUMAN_APPROVED_PROFILE",
  "requiredCoverageClasses": [
    "NORMAL_USE_CYCLE",
    "OFFLINE_RECONNECT",
    "SERVICE_RESTART",
    "NEW_RELEASE_ROLLBACK",
    "SUPPORT_TRIAGE"
  ],
  "hardStopProfileId": "cutover-hard-stop-v1",
  "metricThresholdProfileId": "HUMAN_APPROVED_THRESHOLDS",
  "promotionMode": "EXPLICIT_HUMAN",
  "nextRingId": "R3",
  "contentDigest": "sha-256:fictional-ring"
}
```

The cohort manifest contains opaque installation IDs and support/compatibility classes in the protected control plane. It is not emitted to metrics, logs, or browser URLs.

## 5.4 `CutoverObservationV1`

```json
{
  "contract": "uam.migration.cutover-observation",
  "version": "1.0.0",
  "observationId": "019d0000-0000-7000-8000-000000002410",
  "planId": "019d0000-0000-7000-8000-000000002401",
  "ringId": "R2",
  "monitorId": "LEGACY_WRITE_SUCCESS",
  "windowClass": "BAKE_WINDOW",
  "status": "PASS",
  "observedCount": 0,
  "thresholdProfileId": "ZERO_TOLERANCE",
  "freshness": "CURRENT",
  "positiveControl": "PASS",
  "evidenceDigest": "sha-256:fictional-evidence",
  "observedAtUtc": "2026-08-01T12:00:00Z"
}
```

A monitor with `freshness != CURRENT`, missing positive control, or `UNKNOWN` status cannot support promotion.

## 5.5 `AuthorityTransitionCommandV1`

```json
{
  "contract": "uam.migration.authority-transition-command",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000002420",
  "planId": "019d0000-0000-7000-8000-000000002401",
  "ringId": "R2",
  "scopeManifestDigest": "sha-256:fictional-cohort",
  "expectedAuthorityVersion": 8,
  "fromState": "LEGACY_QUIESCED",
  "toState": "NEW_PRIMARY_PROBATION",
  "legacyQuiesceEvidenceDigest": "sha-256:fictional-quiesce",
  "finalLegacyWatermarkDigest": "sha-256:fictional-watermark",
  "newReleaseDigest": "sha-256:fictional-payload",
  "comparisonEvidenceDigest": "sha-256:fictional-reconciliation",
  "reasonCode": "APPROVED_RING_TRANSFER",
  "approvalDigest": "sha-256:fictional-approval"
}
```

Execution uses `commandId` as idempotency identity and compare-and-swap on `expectedAuthorityVersion`. Same ID/different content is an integrity conflict. Final authorization, authority row update, audit event, and activation job commit in one server transaction.

## 5.6 `LegacyControlActionV1`

```json
{
  "contract": "uam.migration.legacy-control-action",
  "version": "1.0.0",
  "actionId": "019d0000-0000-7000-8000-000000002430",
  "inventoryItemToken": "opaque-fictional-item",
  "actionType": "DISABLE_SCHEDULE",
  "expectedState": "ENABLED",
  "desiredState": "DISABLED",
  "executionProfileId": "ENTERPRISE_TASK_DISABLE_V1",
  "environmentClass": "LAB_ONLY",
  "expiresAtUtc": "2026-08-02T00:00:00Z",
  "reasonCode": "CUTOVER_QUIESCE",
  "approvalDigest": "sha-256:fictional-approval"
}
```

Production action adapters accept only inventory tokens resolved server-side. They never accept a task/service/login/path/host/SQL string from the browser or tenant.

## 5.7 `CredentialRevocationRecordV1`

```json
{
  "contract": "uam.migration.credential-revocation-record",
  "version": "1.0.0",
  "revocationId": "019d0000-0000-7000-8000-000000002440",
  "credentialToken": "opaque-fictional-credential",
  "credentialClass": "LEGACY_SQL_LOGIN",
  "priorState": "ACTIVE",
  "newState": "REVOKED",
  "disableEvidenceDigest": "sha-256:fictional-disable",
  "activeSessionTerminationDigest": "sha-256:fictional-sessions",
  "permissionRemovalDigest": "sha-256:fictional-permissions",
  "secretRemovalDigest": "sha-256:fictional-secret-removal",
  "networkDenialDigest": "sha-256:fictional-network",
  "failedUseMonitorDigest": "sha-256:fictional-monitor",
  "effectiveAtUtc": "2026-08-01T13:00:00Z",
  "status": "VERIFIED"
}
```

No secret value, certificate serial, login name, address, or connection string appears in this record.

## 5.8 `BufferDispositionRecordV1`

```json
{
  "contract": "uam.migration.buffer-disposition-record",
  "version": "1.0.0",
  "dispositionId": "019d0000-0000-7000-8000-000000002450",
  "scopeToken": "opaque-fictional-buffer-scope",
  "bufferClass": "LEGACY_DEFERRED_SQL_CSV",
  "reachabilityClass": "REACHABLE",
  "creationFrozen": true,
  "itemCountClass": "BOUNDED_SYNTHETIC",
  "totalBytesClass": "BOUNDED_SYNTHETIC",
  "oldestAgeClass": "SYNTHETIC",
  "contentSetDigest": "sha-256:fictional-buffer-set",
  "decision": "QUARANTINE_FOR_INVESTIGATION",
  "decisionAuthorityReference": "fictional-authority",
  "consumerResult": "NOT_EXECUTED",
  "cleanupState": "PRESERVED_UNDER_HOLD",
  "evidenceDigest": "sha-256:fictional-evidence"
}
```

Raw executable text is structurally absent. A transformed typed-event disposition requires a separate transformation contract and an accepted Prompt 22/23 proof.

## 5.9 `ArchiveAccessProfileV1`

```json
{
  "contract": "uam.migration.archive-access-profile",
  "version": "1.0.0",
  "archiveId": "019d0000-0000-7000-8000-000000002460",
  "sourceSnapshotDigest": "sha-256:fictional-archive",
  "schemaAdapterVersion": "1.0.0",
  "purposeProfileId": "HUMAN_APPROVED_PURPOSE",
  "fieldProfileId": "HUMAN_APPROVED_MINIMUM_FIELDS",
  "accessCapabilityId": "ARCHIVE_READ",
  "auditClass": "AUDIT_BEFORE_DISCLOSE",
  "databaseState": "READ_ONLY",
  "applicationMutationState": "DISABLED",
  "restoreProfileId": "ARCHIVE_RESTORE_V1",
  "retentionPolicyId": "HUMAN_DECISION_REQUIRED",
  "ownerFunction": "UNASSIGNED_BLOCKING",
  "contentDigest": "sha-256:fictional-profile"
}
```

An archive profile with `UNASSIGNED_BLOCKING` cannot become active.

## 5.10 `ResidualExceptionV1`

```json
{
  "contract": "uam.migration.residual-exception",
  "version": "1.0.0",
  "exceptionId": "019d0000-0000-7000-8000-000000002470",
  "scopeManifestDigest": "sha-256:fictional-residual-scope",
  "exceptionType": "UNREACHABLE_DEVICE",
  "riskClass": "LEGACY_BINARY_REMAINS",
  "containment": [
    "LEGACY_CREDENTIAL_REVOKED",
    "LEGACY_NETWORK_PATH_DENIED",
    "COLLECTION_NOT_AUTHORIZED",
    "REMOVE_OR_REENROLL_ON_RETURN"
  ],
  "ownerFunction": "ENDPOINT_OPERATIONS",
  "blocksGateIds": [],
  "expiresAtUtc": "2026-09-01T00:00:00Z",
  "status": "CONTAINED",
  "evidenceDigest": "sha-256:fictional-exception"
}
```

## 5.11 `DecommissionAcceptanceRecordV1` — mandatory artifact

```json
{
  "contract": "uam.migration.decommission-acceptance-record",
  "version": "1.0.0",
  "recordId": "019d0000-0000-7000-8000-000000002480",
  "planId": "019d0000-0000-7000-8000-000000002401",
  "scopeManifestDigest": "sha-256:fictional-final-scope",
  "decision": "NOT_ACCEPTED",
  "gateResults": {
    "zeroUnauthorizedLegacyWrites": "PASS",
    "buffersDispositioned": "BLOCKED_MISSING_EVIDENCE",
    "consumersDispositioned": "BLOCKED_MISSING_EVIDENCE",
    "credentialsRevoked": "PASS",
    "pathsBlocked": "PASS",
    "historyOwned": "BLOCKED_HUMAN_DECISION",
    "rollbackTested": "PASS",
    "residualExceptionsCurrent": "PASS",
    "runbooksAndTraining": "PASS",
    "cleanupVerified": "PASS",
    "multiOwnerAcceptance": "MISSING"
  },
  "legacyInventoryDigest": "sha-256:missing-until-prompt-22",
  "reconciliationDigest": "sha-256:missing-until-prompt-23",
  "readOnlyEvidenceDigest": "sha-256:fictional-readonly",
  "credentialAndNetworkEvidenceDigest": "sha-256:fictional-revocation",
  "archiveEvidenceDigest": null,
  "residualMonitoringDigest": "sha-256:fictional-monitoring",
  "gameDayEvidenceDigest": "sha-256:fictional-gameday",
  "cleanupReceiptDigest": "sha-256:fictional-cleanup",
  "exceptionSetDigest": "sha-256:fictional-exceptions",
  "acceptanceClaims": [],
  "evidenceDigest": "sha-256:fictional-record"
}
```

Normative acceptance rules:

- `decision=ACCEPTED` is impossible unless every primary-gate predicate is `PASS` and no blocking exception or owner remains;
- technical evidence builder cannot insert human acceptance claims;
- acceptance claims name role functions, decision artifact IDs, times, and signatures/authorization evidence, never personal or secret data in the general record;
- a later discovery creates a linked `DecommissionFinding` and can reopen the state; it never edits historical acceptance evidence.

## 5.12 Error taxonomy

| Family | Examples | Default containment | Recovery |
|---|---|---|---|
| `DISCOVERY_INCOMPLETE` | unknown writer, unowned login, missing consumer | block transfer/revocation | update accepted inventory, rerun evidence |
| `RECONCILIATION_UNKNOWN` | mismatch cannot be classified | pause ring | preserve data; analyze with T1/safe evidence; update Prompt 23 contract |
| `AUTHORITY_CONFLICT` | legacy and new both primary, stale version | safety hold | disable affected writers; reconcile one-effect truth |
| `LEGACY_WRITE_SUCCESS` | successful post-quiesce mutation | incident; block gate | terminate session/path, preserve audit, assess data, repeat read-only proof |
| `CREDENTIAL_ACTIVE` | login/cert/secret still authorizes | block trust removal | disable/revoke/rotate, terminate sessions, verify |
| `PATH_ACTIVE` | alternate route succeeds | block trust removal | deny at server/network, remove rule/alias, retest |
| `BUFFER_AMBIGUOUS` | unknown commit/consumer outcome | no deletion/advance | replay/query same identity or quarantine; human disposition if irrecoverable |
| `ARCHIVE_WRITABLE` | mutation route/permission succeeds | block archive | read block, remove authority, restore clean copy, retest |
| `ROLLBACK_UNSAFE` | N-1 incompatible or unverified | pause, no rollback | enterprise repair/known-good release after lab proof |
| `MONITOR_BLIND` | stale sensor/positive-control miss | pause bake | repair sensor; restart counted bake interval as plan defines |
| `CLEANUP_RESIDUE` | task/service/key/rule/package remains | gate failure | remove or exception-own; verify complete diff |
| `EXCEPTION_EXPIRED` | unresolved residual beyond expiry | block acceptance | remediate or explicit new human risk decision; no auto-renew |
| `PRIVACY_OR_REALM` | forbidden value/cross-realm | immediate hold/incident | contain scope, revoke affected authority, independent investigation |
| `AUDIT_FAILURE` | privileged effect without required evidence | fail closed/incident | reconcile command/effect; restore audit integrity before re-enable |
| `UNKNOWN` | unclassified state | fail closed | classification required before retry/promotion |

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Cutover and rollback state machine — mandatory artifact

```text
DRAFT
  -> VALIDATED
       -> REJECTED
       -> APPROVAL_PENDING
            -> APPROVED
                 -> PRESTAGING
                      -> PRESTAGE_FAILED -> SAFETY_HOLD
                      -> PRESTAGED
                           -> COMPARISON_ONLY
                                -> RECONCILIATION_FAILED -> PAUSED
                                -> RING_READY
                                     -> BAKING_COMPARISON
                                          -> PAUSED
                                          -> LEGACY_QUIESCE_PENDING
                                               -> LEGACY_QUIESCING
                                                    -> QUIESCE_FAILED -> SAFETY_HOLD
                                                    -> LEGACY_QUIESCED
                                                         -> AUTHORITY_TRANSFER_PENDING
                                                              -> NEW_PRIMARY_PROBATION
                                                                   -> PAUSED
                                                                   -> ROLLBACK_NEW_PENDING
                                                                        -> NEW_KNOWN_GOOD_PROBATION
                                                                   -> NEW_PRIMARY_ACCEPTED
                                                                        -> LEGACY_READONLY_PENDING
                                                                             -> LEGACY_READ_ONLY
                                                                                  -> TRUST_REMOVAL_PENDING
                                                                                       -> LEGACY_TRUST_REVOKED
                                                                                            -> DECOMMISSION_MONITORING
                                                                                                 -> DECOMMISSION_ACCEPTANCE_PENDING
                                                                                                      -> DECOMMISSIONED
                                                                                                      -> ACCEPTANCE_BLOCKED
```

Rules:

- no transition skips required gates;
- `PAUSED` preserves state/data and prevents dependent promotion;
- `ROLLBACK_NEW_PENDING` selects only an authorized new release under a higher release sequence;
- after `LEGACY_TRUST_REVOKED`, no transition to `LEGACY_PRIMARY` exists;
- a late hard finding can move `DECOMMISSIONED` to a linked `POST_DECOMMISSION_FINDING`/hold without rewriting history;
- all state transitions use compare-and-swap, command idempotency, current authorization, and same-transaction audit.

## 6.2 Per-cohort authority state machine

```text
LEGACY_PRIMARY(v)
  -> NEW_COMPARISON_ONLY(v+1)
  -> TRANSFER_PREPARED(v+2)
  -> LEGACY_QUIESCED(v+3)
  -> NEW_PRIMARY_PROBATION(v+4)
       -> NEW_PRIMARY_ACCEPTED(v+5)
       -> PAUSED(v+5)
       -> NEW_KNOWN_GOOD_PROBATION(v+5)
  -> LEGACY_READ_ONLY(v+6)
  -> LEGACY_TRUST_REVOKED(v+7)
  -> DECOMMISSION_MONITORING(v+8)
  -> DECOMMISSIONED(v+9)

Any invariant failure -> SAFETY_HOLD(v+1)
```

Version never decreases. Prior semantic behavior can be reselected only by a higher transition and only if the target remains authorized and compatible.

## 6.3 Legacy read-only/archive lifecycle

```text
LEGACY_WRITABLE
  -> MUTATION_FREEZE_REQUESTED
  -> APPLICATION_WRITES_DISABLED
  -> DATABASE_WRITE_AUTHORITY_REMOVED
  -> ACTIVE_WRITE_SESSIONS_TERMINATED
  -> NETWORK_WRITE_PATH_DENIED
  -> WRITE_PROBES_PASS
  -> VERIFIED_READ_ONLY
       -> ARCHIVE_COPY_BUILDING (optional)
       -> ARCHIVE_VALIDATING
       -> ARCHIVE_READ_BLOCKED
       -> ARCHIVE_READ_READY
       -> ORIGINAL_RUNTIME_RETIRABLE
  -> ARCHIVE_RETIRED / DELETED / RETAINED_UNDER_POLICY
```

A restored archive starts at `ARCHIVE_READ_BLOCKED`, not `ARCHIVE_READ_READY`. Any successful write returns the component to `READONLY_FAILED` and blocks access/decommission.

## 6.4 Credential lifecycle

```text
DISCOVERED
  -> OWNERSHIP_VERIFIED
  -> DEPENDENCIES_RESOLVED
  -> REVOCATION_PREPARED
  -> DISABLED_OR_REVOKED
  -> ACTIVE_SESSIONS_TERMINATED
  -> PERMISSIONS_AND_MEMBERSHIPS_REMOVED
  -> SECRET_COPIES_REMOVED_OR_ROTATED
  -> NETWORK_PATH_DENIED
  -> FAILED_USE_MONITORING
  -> VERIFIED_REVOKED
  -> DROPPED_OR_RETAINED_AS_TOMBSTONE_EVIDENCE

Unknown/shared dependency -> BLOCKED_SHARED_DEPENDENCY
Any successful use       -> REVOCATION_FAILED / INCIDENT
```

Disabling, revoking, dropping, and deleting are distinct. SQL Server `ALTER LOGIN ... DISABLE` does not terminate existing connections, while `DROP LOGIN` can be blocked by active login/ownership and can orphan users; the runbook separates these steps [W06–W08].

## 6.5 Buffer lifecycle

```text
CREATING
  -> CREATION_FREEZE_REQUESTED
  -> FROZEN
  -> INVENTORIED_VALUE_FREE
  -> DISPOSITION_PENDING
       -> DRAINING_UNDER_LEGACY
       -> TRANSFORMING_TO_TYPED_EVENTS
       -> QUARANTINED
       -> DISCARD_PENDING_HUMAN_AUTHORITY
  -> DISPOSITION_VERIFIED
  -> CLEANED_OR_RETAINED_UNDER_HOLD

UNREACHABLE -> CONTAINED_EXCEPTION -> ON_RETURN_RECONCILE -> DISPOSITION_VERIFIED
```

No state permits `EXECUTE_RAW_SQL_IN_NEW_SYSTEM`. An unknown commit or consumer result remains ambiguous; it does not become success or discard.

## 6.6 Residual exception lifecycle

```text
DISCOVERED
  -> CLASSIFIED
  -> CONTAINMENT_REQUIRED
  -> CONTAINED
  -> REVIEW_DUE
       -> REMEDIATED
       -> EXTENSION_REQUESTED (new human decision; not auto-renew)
       -> EXPIRED_UNRESOLVED
  -> CLOSED
```

`EXPIRED_UNRESOLVED` blocks final acceptance unless a designated human authority records a new, explicit risk decision; the technical finding remains visible.

## 6.7 Transaction boundaries

| Transition | Atomic unit | External actions outside transaction | Reconciliation rule |
|---|---|---|---|
| Plan approval | plan revision + owner/approval references + audit | none | same ID/content replay returns prior result |
| Ring promotion/pause | ring state/version + decision evidence + audit + job | enterprise deployment/monitoring | job status and observed endpoint state must converge before next state |
| Authority transfer | authority epoch/version + audit + activation job | legacy task/service/job disable; endpoint activation | no ordinary writer until external quiesce evidence and activation result verified |
| Legacy read-only command | application state + audit + verification job | DB permissions/state, sessions, network, jobs | layered write probes and state inventory determine verified state |
| Credential revocation | credential-control case + audit + tasks | issuer/SQL/secrets/network actions | each typed receipt required; successful use reopens case |
| Buffer disposition | disposition case + immutable counts/digests + audit | endpoint/legacy consumer actions | same stable item set and consumer outcomes; no unexplained delta |
| Archive activation | archive profile + access state + audit | backup/restore/copy/read-only DB operations | restore/read probes, field/access contract, audit-before-disclose |
| Final acceptance | immutable acceptance record + human claims + audit | none | independent gate evaluator recomputes every predicate and evidence freshness |

No server transaction can atomically disable a Windows task, revoke a certificate, kill a SQL session, change a firewall rule, and update CMDB. The design uses stable operation IDs, prepared state, typed action receipts, retries only where idempotent, and explicit ambiguity/hold.

## 6.8 Rollout and compatibility rules

1. The same signed new-system digest is promoted through rings.
2. Endpoint/server/portal/control contracts use consumer-first compatibility and exact executable matrices.
3. New payload N and authorized rollback payload N-1 MUST both satisfy the same `EndpointStorageCompatibility` artifact through probation.
4. Destructive one-way migrations are prohibited during autonomous/ring probation. They require enterprise maintenance, backup/restore, rollback, and human approval.
5. Legacy schema is frozen at the start of cutover except approved security/read-only changes.
6. A temporary compatibility writer is a separate contract and does not change legacy schema broadly.
7. Historical archive adapters are versioned read projections. Unsupported fields fail closed or display `UNKNOWN/UNAVAILABLE`; they are not guessed.
8. Parallel-run interpretation changes do not rewrite source/event identity. Prompt 23 must define whether a semantic difference is expected, comparable, or non-comparable.
9. First-run lookback, time precision, site/domain output, and subject identity remain human decisions and are recorded in the authority-transfer evidence.
10. A cohort with stale platform, release, policy, identity, monitor, or comparison evidence receives no transfer permit.
11. Old credentials, scripts, and packages are not compatibility mechanisms.
12. Compatibility expiry is explicit. An expired bridge or contract stops; it does not self-extend.

## 6.9 Post-decommission monitoring lifecycle

```text
INTENSIVE_RESIDUAL_MONITORING
  -> STABLE_ZERO_SUCCESSFUL_WRITES
  -> REDUCED_MONITORING
  -> PERIODIC_ASSERTION
  -> MONITORING_RETIRED_BY_HUMAN_DECISION

Any successful write / unknown recurring attempt / inventory reappearance
  -> POST_DECOMMISSION_FINDING
  -> INCIDENT_OR_REMEDIATION
  -> INTENSIVE_RESIDUAL_MONITORING
```

The monitoring period is a **HUMAN DECISION**. Conservative default: keep server-side denial and failed-use alerts at least until all credential/certificate lifetimes, unreachable-device exception horizons, deployment/package cleanup, archive transition, and approved observation conditions have passed. This is a safety posture, not a selected retention period.

---

# 7. Security/privacy threat and failure register

| ID | Trigger / threat | Detection | Containment | Recovery | Cleanup | Owner function | Test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T24-01 | Legacy and new create ordinary effects concurrently | authority registry, event identity conflicts, reconciliation | pause cohort; disable both if needed | establish one authoritative epoch; replay stable new IDs only | remove stale writer/schedule | Data Correctness / Cutover | E24-08 | hidden writer may evade inventory |
| T24-02 | Hidden legacy dynamic SQL/manual consumer | SQL sessions/audit, network, inventory diff, positive controls | block transfer/revocation until classified | add owner/replacement/exception | remove access and monitor | Legacy/Data Operations | E24-03/E24-14 | static evidence cannot prove completeness |
| T24-03 | Deferred SQL executes after authority transfer | buffer creation/write monitors, endpoint inventory | freeze/quarantine; deny DB path | typed transformation only if proved; otherwise human disposition | delete/retain under policy after evidence | Data Reliability / Records | E24-09 | unreachable local buffers may remain |
| T24-04 | Unreachable device returns with legacy binary | failed auth/network attempt, enterprise inventory, CMDB return event | credential revoked/path denied; no collection permit | uninstall legacy; install/enroll new; reconcile buffers | verify package/task/service removal | Endpoint Operations | E24-15 | device can remain absent indefinitely |
| T24-05 | Login disabled but active SQL session keeps writing | `sys.dm_exec_sessions`, SQL Audit/Extended Events, write probe | kill session; deny network | remove permissions/ownership then drop/retain tombstone | verify zero sessions and writes | Database Security | E24-11 | privileged/internal sessions may be misclassified |
| T24-06 | Shared credential breaks required consumer or remains usable | ownership/dependency inventory, failed/successful auth tests | pause revocation or isolate consumer; no endpoint trust restoration | issue new purpose-specific consumer credential; rotate old | remove old copies | IAM/Database/App Owner | E24-10 | undiscovered shared use |
| T24-07 | Revoked certificate accepted due cache/CRL gap | application status, TLS negative tests, CRL/status monitoring | server-side deny/network block | publish status; terminate connections; rotate trust | remove cert/private key per policy | PKI/Security | E24-12 | offline caches and long-lived sessions |
| T24-08 | Alternate network path bypasses deny | connection matrix, server firewall/database listener logs | block at listener/network; isolate source | remove alias/route/proxy rule | verify active policy and cleanup | Network Security | E24-13 | undocumented tunnels or privileged admin paths |
| T24-09 | Legacy portal says read-only but API/job writes | route catalogue, write probes, audit, DB state | read block; stop runtime/jobs | remove handlers/permissions; restore clean archive | retest all layers | Portal/Legacy Operations | E24-06 | privileged DBA can still alter without independent detection |
| T24-10 | Archive restored with stale writable authority | restore identity/state checks, write probes | keep reads/egress blocked | replay current access/revocation/tombstone/audit state; set read-only | delete failed restore | Archive/SRE/Security | E24-17 | backup may contain unknown secrets/config |
| T24-11 | Automatic rollback recreates legacy trust | architecture test, route/action catalogue, release manifest | block build/release; safety hold | use authorized new N-1 or pause | remove forbidden code/config | Release/Security | E24-01/E24-18 | human may attempt manual workaround |
| T24-12 | New N-1 cannot read current endpoint/server store | compatibility matrix, rollback game day | pause before migration/activation | enterprise repair or compatible known-good payload | restore lab/environment | Release/Storage | E24-05 | failure may appear only at scale/corruption |
| T24-13 | Monitoring blind during bake | freshness/positive-control status | pause bake and promotion | repair sensor, replay safe evidence where possible | classify blind interval | SRE/Security Monitoring | E24-02 | some historical gap cannot be reconstructed |
| T24-14 | Privacy leak in residual telemetry | canary scanners, schema/catalogue, sink scans | stop sensor/export; incident hold | remove unsafe field/config; rotate affected artifacts | delete/contain leaked evidence per policy | Privacy/Security | E24-02/E24-20 | EDR/SIEM may capture privileged memory outside UAM |
| T24-15 | Metric cardinality explosion or sensitive labels | CI series bound, backend cardinality alerts | disable offending metric/config | fixed finite label release | remove high-cardinality series per policy | SRE/Privacy | E24-20 | backend cost/retention already incurred |
| T24-16 | Cross-realm cohort/archive/exception association | realm-negative tests, DB constraints, cache keys | hold affected realm/action | repair mapping under audit; no merge | purge incorrect projection/cache | Realm Security/Data | E24-04 | privileged collusion remains possible |
| T24-17 | Operator uses generic shell/SQL/runbook path | route catalogue, audit, architecture/dependency tests | revoke path/session; incident | replace with fixed typed capability | remove generic tooling/credentials | Security/Operations | E24-01/E24-19 | external enterprise tooling may retain broad rights |
| T24-18 | Waiver auto-renews or loses owner | exception expiry evaluator | block gate/promotion | new explicit human decision or remediation | close stale exception | Risk Governance | E24-16 | accepted residual risk may still be costly |
| T24-19 | Legacy package/task/service reappears via repair/GPO | recurring inventory, Windows task/service events, enterprise deployment state | network/credential denial limits effect | remove assignment/repair source; uninstall | verify before/after and no recurrence | Endpoint Management | E24-14/E24-15 | offline devices remain outside observation |
| T24-20 | Credential/secret remains in source, package, backup, workbook, support system | exact canaries/secret inventory, artifact manifests | restrict access; rotate/revoke secret | remove approved copies; rebuild artifacts | cleanup evidence | Security/Release/Records | E24-21 | scanners have false negatives; backups governed separately |
| T24-21 | Buffer silently discarded under disk/deadline pressure | before/after counts/digests, endpoint store invariants | pause collection/cleanup | retain/quarantine or human loss decision | evidence and tombstone | Data Reliability/Product | E24-09 | physical failure can still destroy data |
| T24-22 | Reconciliation treats expected semantic difference as loss, or loss as expected | Prompt 23 oracle, golden cases, independent review | pause ring | refine typed mismatch class; rerun | preserve original result | Data Quality/Verification | E24-07/E24-08 | common-mode model defect |
| T24-23 | History has no owner or indefinite retention | archive gate/owner registry | no archive access/final acceptance | human decision and policy revision | remove unauthorized copies | Records/Data Controller | HD24-03 | legal obligations cannot be proved technically |
| T24-24 | Sensitive archive read released before audit | BFF access-audit failpoints | block disclosure | repair audit path; retry stable request | discard buffer/artifact | Portal/Audit | E24-17 | authorized misuse still possible |
| T24-25 | Successful legacy write after decommission acceptance | SQL/network/residual monitors, data reconciliation | incident; reopen decommission state; isolate writer | identify path/credential, assess effects, restore controls | remove component/path and repeat observation | Incident Command/Data Security | E24-14 | a blind path may exist until used |
| T24-26 | CMDB says retired while technical component remains | independent inventory reconciliation | mark acceptance blocked | correct CMDB and technical state | verify both directions | Asset/Endpoint Operations | E24-14 | CMDB freshness/process weakness |
| T24-27 | Backup/export contains old credentials or writable portal config | backup catalogue, isolated restore, secret canaries | quarantine/read block | sanitize/rebuild or retain under restricted hold | destroy/expire per policy | SRE/Records/Security | E24-17/E24-21 | old immutable backups may not be editable |
| T24-28 | Supply-chain compromise in cutover tool | same-digest verification, SBOM/provenance, signature, architecture tests | stop release/tool, revoke authority | known-good build/OOB recovery | remove compromised artifacts/keys | Release Security | E24-01/E24-18 | trusted malicious release can create coherent false evidence |
| T24-29 | Runbook step succeeds but evidence upload fails | local immutable operation receipt, command idempotency | do not repeat destructive step blindly; mark ambiguous | query actual target state, attach evidence | resolve temporary files | Verification/Operations | E24-19 | external system may not expose definitive state |
| T24-30 | Support asks for raw SQL/activity/credentials to diagnose cutover | request/evidence policy, canaries, audit | deny unsafe collection; use synthetic reproduction/value-free state | add safe signal if justified | delete accidental collection | Support/Privacy/Security | E24-20 | some production-only failures remain hard to diagnose |
| T24-31 | Accessibility failure hides pause/rollback/read-only status | manual keyboard/AT tests, support reports | block affected workflow; alternate fixed recovery CLI only if approved | repair semantic workflow | retest matrix | Portal/Accessibility | E24-22 | diverse user needs can exceed tested matrix |
| T24-32 | Break-glass clears safety hold or enables legacy write | capability catalogue/state tests/audit | revoke grant; incident | fixed recovery-only commands; independent review | close/revoke grant | Security/IAM | E24-19 | emergency pressure encourages workarounds |
| T24-33 | Database/read-only setting harms required backup/restore/report behavior | lab database/restore tests | remain on layered permission/read-copy approach | choose fit archive topology | restore lab state | DBA/SRE/Archive | E24-06/E24-17 | exact production topology unknown |
| T24-34 | Post-decommission monitoring retained too long or too broadly | policy/field/retention registry | stop unauthorized collection | narrow/delete under policy | deletion evidence | Privacy/Records/SRE | HD24-05/E24-20 | security evidence and privacy minimization can conflict |

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Evidence rules for every experiment

Every experiment MUST emit a machine-readable, content-addressed record containing:

- experiment ID and one falsifiable claim;
- source tree, release, contract, plan, fixture, oracle, tool, script, package, and configuration digests;
- exact lab OS/database/runtime/module/tool versions and sanitized capability classes;
- T1 fictional realm, installation, host, account, certificate, URL, task, service, login, buffer, and archive identities;
- start/end UTC and time-quality class;
- command identity with host/address/user/credential/path redacted or replaced by placeholders;
- first failure and all rerun links;
- pre/post state snapshots, typed operation receipts, monitoring/positive-control results, canary scan, and cleanup receipt;
- owner/reviewer functions and exception/ADR references;
- explicit statement that no production revoke/disable/delete occurred.

A rerun never overwrites the first failure. A cleanup failure is a failed experiment.

## 8.2 Test matrix

| ID | Setup | Instrumentation | Steps | Pass | Fail / stop | Evidence | Duration classification | Cleanup |
|---|---|---|---|---|---|---|---|---|
| **E24-01 Architecture prohibition** | clean repository; T1 contracts | dependency/API/route/action scanners; canaries | inject then revert endpoint SQL client, credential field, arbitrary command, legacy rollback target, `skipAudit` | every mutation fails; clean build passes | one forbidden path compiles/routes/serializes | graph, mutation report, file manifest | bounded CI run | clean-tree proof |
| **E24-02 Monitor positive controls/cardinality** | synthetic SQL/task/service/network/archive events | monitor catalogue, fake clock, series calculator, canaries | inject successful/failed legacy write, stale sensor, forbidden label, blind interval | all hard cases detected; dynamic labels rejected; bounded series | missed positive control, raw/sensitive field, unbounded series | monitor matrix, theoretical bound, sink scan | bounded deterministic | delete T1 telemetry |
| **E24-03 Legacy inventory compiler** | T1 fictional estate with known hidden writers/readers | inventory adapters and independent truth | enumerate approved sources; add unknown writer, shared login, repair source, manual consumer | exact set and ownership gaps found; no raw secrets/addresses | miss/extra, broad crawl, real value, unowned item accepted | inventory root, truth diff | bounded; replace with measured production-safe run later | remove fixtures |
| **E24-04 Realm/cohort isolation** | two fictional realms and overlapping labels | DB constraints, cache/job/export/archive monitors | submit wrong realm/body claims; collide cohort/exception/archive IDs | zero cross-realm state/read/effect/existence disclosure | any cross-realm result | negative matrix, audit | bounded | drop T1 realms |
| **E24-05 New-release rollback** | disposable Windows VM; signed/test-signed N and N-1; synthetic store | launcher logs, file hashes, store verifier, process/service inventory | install N-1, upgrade N, create buffered data, fail health, higher-sequence rollback, restart/reboot | N-1 exact digest runs; store/events/batches/cursors intact; no legacy component/cred | mixed payload, incompatible store, data loss, lower sequence, staging execution | release/store histories, cleanup | one complete lifecycle; exact time recorded | uninstall/revert VM |
| **E24-06 Layered read-only** | synthetic legacy portal/API/SQL DB/jobs | HTTP tests, SQL audit/XE, permissions, sessions, DB state, network trace | disable UI/API/jobs; remove write rights; kill sessions; optionally set DB read-only; run positive/negative writes | every unauthorized write rejected; reads work per profile; attempts detected | any successful write or missed probe | read-only verification record | bounded; include restart/restore cycle | restore snapshot/revert |
| **E24-07 Reconciliation oracle** | T1 paired legacy/new outputs with expected semantic differences | independent oracle and mutation tests | generate exact match, expected transform, omission, duplicate, time-shift, cross-realm, privacy leak | finite correct classifications; hard defects stop | unknown treated as pass; mandatory mutation survives | mismatch ledger, minimal counterexamples | deterministic corpus | delete fixtures |
| **E24-08 Ring/authority model** | pure state model plus synthetic services | model checker/property tests/fake clock | random valid/invalid transitions, concurrent commands, response loss, stale version, monitor blindness | one primary; monotonic version; stable idempotency; no skipped gate | dual primary, stale promotion, legacy resurrection | history capsules | deterministic campaign | none |
| **E24-09 Buffer disposition** | synthetic deferred SQL/CSV and new-system batches; reachable/unreachable endpoints | counts/digests, file/process trace, oracle | freeze creation; drain/quarantine/typed-transform/discard-authority cases; crash each boundary | no blind execution/silent loss; stable evidence; unreachable exception correct | SQL executes in new path, unexplained delta, unACK new data deleted | disposition records, before/after digests | bounded plus crash matrix | securely delete T1 buffers/revert |
| **E24-10 Shared credential split** | lab SQL with fictional writer/reader consumers | sessions/permissions/audit, secret inventory | identify shared login; create purpose-specific reader; rotate; disable old; test dependencies | archive reader works; endpoint writer denied; no old session | unknown consumer or old credential succeeds | dependency/revocation evidence | bounded | drop lab principals/db |
| **E24-11 SQL disable/session/drop** | lab SQL Server fictional login/user/job/securable | `sys.dm_exec_sessions`, audit/XE, permission inventory | open sessions; disable login; prove existing session state; kill; remove permissions/ownership; drop or retain tombstone | no active/authorized session; expected ownership/orphan checks | active write survives or drop causes unhandled orphan/breakage | typed SQL evidence, no names | bounded | restore DB snapshot |
| **E24-12 Certificate revocation** | lab CA/client/server and fictional cert | TLS traces, app status, CRL/status, connection inventory | authenticate; revoke; publish status; test cached/long-lived/new connections; network deny | application denies current status; new/renewed use fails; evidence retained | revoked credential authorizes or monitor blind | PKI evidence by opaque IDs | includes propagation window measured | remove lab CA/certs/trust |
| **E24-13 Network path denial** | disposable endpoints/server with multiple fictional routes/aliases | firewall active policy, TCP connection state, server listener logs, packet metadata | test approved route; apply deny; test alternate port/alias/proxy/VPN class; positive-control allow in isolated scope | zero legacy successful path; new/archive approved paths unaffected | bypass or unrelated outage | route matrix, policy hashes | bounded per profile | remove test rules/revert |
| **E24-14 Residual monitoring** | synthetic post-decommission endpoints, tasks, service, SQL attempts, CMDB | SQL audit/XE, task/service audit, network sensor, enterprise inventory, CMDB diff | generate known attempts/reappearance/success and blind one sensor | independent sensors classify all; success triggers incident; CMDB mismatch blocks | known positive missed or one sensor treated as sole proof | residual finding set | approved observation simulation | delete events/revert |
| **E24-15 Unreachable-device return** | VM offline during revocation/rollout | enterprise state, network/SQL denial, install logs | keep offline; revoke/block; return with old binary/buffer; attempt write; uninstall/install/enroll new; disposition buffer | old write denied; no legacy authority; new identity/store clean; exception closes | legacy write succeeds or old identity reused | exception and on-return evidence | one full return lifecycle | revert VM/keys |
| **E24-16 Exception expiry** | fake-clock exception registry | gate evaluator/audit | create contained, blocking, expired, extension-requested, remediated cases | no auto-renew; expired unresolved blocks; new decision linked | expiry silently extends or disappears | state history | deterministic | none |
| **E24-17 Archive restore/access** | T1 legacy backup/read-copy, new BFF, two realms | restore guard, write probes, access audit, canaries, accessibility | restore under new identity; prove read block; apply read-only/access profile; query/export; wrong realm; mutation; delete/rebuild | reads only after readiness/audit; zero mutation/cross-realm; accessible status | pre-ready disclosure, writable path, unaudited bytes | restore/readiness/access evidence | one full restore | destroy restored environment |
| **E24-18 Supply-chain/tamper** | candidate cutover binaries/scripts/evidence verifier | signatures, file manifests, SBOM/provenance, tamper corpus | substitute binary/config/script; modify evidence; use stale release; reparse path | every substitution/stale/tamper rejected | unknown byte executes or evidence verifies | manifest/verification report | bounded | remove artifacts |
| **E24-19 Typed runbook/idempotency** | lab adapters for task/service/login/firewall | command ledger, external state query, audit | lose response before/after action; retry same command; submit changed command same ID; unauthorized request | one effect; changed digest conflict; actual state reconciled; audit correct | duplicate/destructive repeat, arbitrary input accepted | operation history | deterministic + lab | restore baseline |
| **E24-20 Privacy-safe evidence/support** | all logs/metrics/bundles/reports from tests | exact canaries, schema scanner, encoding decoders | plant raw URL/path/credential/address/SQL/user markers; create support bundle | all detected; shareable output contains only approved fields | one escape/miss or external upload | sink matrix | bounded | delete contaminated artifacts |
| **E24-21 Secret/artifact cleanup** | T1 secret planted in package/config/source/cache/backup/workbook | exact canaries, package manifests, inventory | rotate/revoke; rebuild; scan all declared stores; restore old backup | active artifacts clean; backup status truthful; positive controls work | secret remains in active path or scanner miss | cleanup manifest | bounded + restore | delete lab secrets/backup |
| **E24-22 Accessibility/status workflow** | representative portal/recovery CLI T1 screens | automated semantics plus keyboard/screen reader/zoom/forced colors | perform approve, pause, rollback, read-only, exception, acceptance denied, incident | complete/understandable without pointer/color; status announced; errors recoverable | critical workflow inaccessible or ambiguous | accessibility task record | manual matrix | clear sessions/data |
| **E24-23 Final gate evaluator** | complete synthetic evidence set with mutations | independent evaluator | remove/expire/alter each primary predicate and owner claim | only complete valid set yields `ACCEPTED`; every mutation blocks | missing evidence accepted or human claim forged | gate mutation report | deterministic | none |

## 8.3 Smallest falsifying prototypes

### P24-A — one-way rollback proof

- **Setup:** two signed/test-signed new payloads, one synthetic endpoint store, no legacy credential.
- **Claim:** a failed N rollout can recover to authorized N-1 without restoring legacy trust or losing durable data.
- **Falsifier:** N-1 cannot open the store, stable identities change, buffered data disappears, or any legacy credential/path is required.
- **Decision:** any falsifier blocks R1 and opens a release/storage ADR.

### P24-B — layered read-only proof

- **Setup:** minimal legacy-like portal/API, SQL database, writer/reader identities, one job, one active session.
- **Claim:** layered controls allow approved reads and reject every mutation, including an already-connected writer.
- **Falsifier:** one successful write or one undetected positive-control attempt.
- **Decision:** no archive/read-only claim until corrected and repeated after restart/restore.

### P24-C — buffer ambiguity proof

- **Setup:** one synthetic deferred SQL file with stable digest, one new-system sealed batch, crash points around drain/quarantine/evidence.
- **Claim:** no path executes raw SQL in the new system or deletes ambiguous/unacknowledged data.
- **Falsifier:** raw execution, silent loss, or differing disposition on retry.
- **Decision:** B06-BUFFER remains blocked.

### P24-D — residual path proof

- **Setup:** one offline VM, one revoked fictional login/cert, one denied network route, one hidden repair source.
- **Claim:** return of an old endpoint cannot write and repair-source reappearance is detected.
- **Falsifier:** a successful write or undetected task/service/package recreation.
- **Decision:** trust removal and decommission fail.

### P24-E — independent acceptance proof

- **Setup:** complete fictional decommission record; mutate one predicate at a time.
- **Claim:** no single owner or component can self-assert final acceptance.
- **Falsifier:** accepted state with missing Prompt 22/23 evidence, expired exception, missing credential proof, missing history owner, failed rollback, or absent sign-off.
- **Decision:** redesign gate/evidence authority.

## 8.4 Operational game-day plan — mandatory artifact

### Purpose

Prove that the team can pause, contain, recover, verify, communicate, and clean up without raw data, arbitrary commands, or legacy credential resurrection.

### Preconditions

- disposable/reverted lab only;
- T1 fictional identities, activity, tasks, services, logins, certificates, routes, buffers, and archive;
- exact release N/N-1, contracts, plan, monitor, and runbook digests;
- approved destructive-lab authority and role assignments;
- evidence sink and privacy canaries active;
- cleanup/revert method proved before injection.

### Role functions

- Game-Day/Incident Commander;
- Cutover Director;
- Change/Go-No-Go Authority observer;
- Endpoint Deployment lead;
- New Endpoint Runtime lead;
- Server/Data Reliability lead;
- Database/Legacy Operations lead;
- Security/IAM/PKI lead;
- Network Security lead;
- Support lead;
- Archive/Records observer;
- Accessibility observer;
- Independent Evidence Verifier.

These are accountable functions, not assigned people or production authority.

### Scenario sequence

1. **Brief and freeze.** Verify exact artifacts, roles, clocks, communication channels, stop phrase, rollback target, and cleanup.
2. **Pre-stage.** Install N in disabled/comparison-only state; verify new identity/store/monitoring.
3. **Comparison.** Run controlled paired events; inject one expected semantic difference and one hard duplicate/loss defect. Team must classify the first and pause on the second.
4. **Resume after repair.** Re-run comparison with stable evidence; record that prior failure remains linked.
5. **Quiesce.** Disable synthetic legacy task/service/job; freeze deferred buffer; capture watermark.
6. **Transfer.** Commit authority transition; activate N.
7. **Inject new-release failure.** Break health after durable local data exists. Ring must pause; team selects authorized N-1 at higher sequence. No legacy credential exists or is requested.
8. **Read-only.** Move synthetic legacy portal/database through layered read-only; maintain an active old SQL session as a trap. Team must detect/terminate it and prove writes fail.
9. **Revoke/block.** Disable/revoke fictional login/cert, publish status, block route, and generate failed legacy attempts. Team verifies denial and monitoring.
10. **Unreachable return.** Bring old VM online with legacy package/buffer. Write must fail; endpoint is removed/re-enrolled; buffer receives approved T1 disposition.
11. **Archive restore.** Restore an old synthetic backup with stale writable config. Reads remain blocked until controls/audit/read-only pass.
12. **Residual finding.** Reintroduce a task via a repair source. Monitoring must find it, reopen the finding, and block final acceptance.
13. **Support exercise.** A support analyst diagnoses from safe status/evidence only; a request for raw SQL/activity is denied and escalated.
14. **Accessibility exercise.** Keyboard/screen-reader user completes pause, rollback, read-only verification, exception review, and acceptance-denied workflows.
15. **Acceptance mutation.** Remove one sign-off/evidence item; independent evaluator must refuse `ACCEPTED`.
16. **Cleanup/revert.** Remove tasks/services/rules/logins/certs/keys/files/packages, destroy archive restore, scan sinks, and produce residue diff.
17. **After-action review.** Record first failures, decision latency classes, unclear ownership, unsafe workarounds, runbook changes, and gate outcome.

### Pass criteria

- zero unauthorized legacy writes and zero cross-realm/privacy/cursor/receipt/audit failures;
- new-only rollback preserves durable data and identity;
- active legacy sessions are detected and terminated;
- revoked credentials and denied paths fail;
- raw deferred SQL never executes in the new system;
- inaccessible/unknown state causes pause, not promotion;
- independent evaluator refuses incomplete acceptance;
- no lab residue or secret/canary escape.

### Failure disposition

A hard failure blocks the corresponding production gate. A rerun may prove a fix but does not erase the original failure. Any request to restore legacy endpoint trust opens an architecture review and is not executed in the game day.

---

# 9. Architecture fitness functions and measurable acceptance criteria

The following are release/build/run-time fitness functions. A hard invariant has zero tolerance; a quantitative operational threshold remains a human-owned profile.

| ID | Fitness function | Measurement | Acceptance |
|---|---|---|---|
| FF24-01 | No endpoint DB trust | architecture scan + release file/config scan | zero SQL clients/connection strings/central DB credentials/SQL payload contracts in endpoint artifacts |
| FF24-02 | No arbitrary migration channel | route/action/project dependency scan | zero generic shell, script, SQL, path, plug-in, command, or tenant expression paths |
| FF24-03 | One primary authority | authority-state model + database constraint + reconciliation | exactly one `PRIMARY` for every active scope/epoch; comparison cannot create ordinary effects |
| FF24-04 | Monotonic state | state-history checker | plan, authority, release, credential, exception, and archive versions never decrease; same version/different content rejected |
| FF24-05 | Safe rollback | N/N-1 lab matrix | known-good new payload starts; store/contracts/events/batches/cursors preserved; no legacy credential/path required |
| FF24-06 | No skipped gate | plan compiler/model mutation | every prohibited transition rejected; missing/stale Prompt 22/23 evidence blocks production plan |
| FF24-07 | Complete monitor coverage | monitor catalogue and positive controls | every hard stop has at least one primary and one independent corroborating signal where feasible; all positive controls pass |
| FF24-08 | Monitor freshness | fake-clock/operational evaluator | stale/unavailable required monitor pauses bake; blind time does not count |
| FF24-09 | Zero unauthorized legacy writes | SQL/app/network write probes and audit | zero successful writes after the applicable quiesce/read-only deadline |
| FF24-10 | Credential revocation completeness | principal/session/permission/secret/path reconciliation | every inventoried credential is purpose-resolved and in approved final state; zero active authorized sessions/use |
| FF24-11 | Network denial completeness | path matrix | zero successful legacy write path across all approved route classes; approved new/archive paths remain functional |
| FF24-12 | Buffer truth | before/after count/digest and consumer ledger | every buffer/consumer is drained, transformed, quarantined, policy-discarded, or exception-owned; zero unexplained delta |
| FF24-13 | No silent new-data loss | endpoint store/batch/receipt checker | zero unacknowledged deletion, cursor-ahead, changed retry identity, or receipt conflict |
| FF24-14 | Layered read-only | UI/API/app/DB/session/network/job probes | every unauthorized mutation fails and is detected; approved reads pass with audit-before-disclose |
| FF24-15 | Archive restore safety | isolated restore evaluator | no read/egress/mutation before readiness; zero deleted/cross-realm/writable result; current authority reconciled |
| FF24-16 | Residual exception quality | registry schema/fake clock | 100% of open exceptions have scope, owner, containment, next action, expiry, review, and gate effect; no auto-renew |
| FF24-17 | Cleanup completeness | before/after component inventory | zero unexplained service/task/process/package/key/cert/rule/file/job/test residue |
| FF24-18 | Evidence integrity | independent digest/signature/schema verifier | every accepted predicate references current immutable evidence; any mutation/omission invalidates acceptance |
| FF24-19 | Audit atomicity | failpoint tests | zero privileged transition without final decision + audit; zero audit success without matching effect |
| FF24-20 | Realm isolation | multi-realm negative suite | zero cross-realm state, effect, read, archive, cache, job, exception, or evidence association |
| FF24-21 | Privacy containment | all-sink canaries | zero raw activity/SQL/path/address/credential/user data in new contracts, logs, metrics, diagnostics, evidence, or support bundles |
| FF24-22 | Metric cardinality | static catalogue calculator + backend observation | actual series no greater than declared finite bound; no dynamic/sensitive label |
| FF24-23 | Accessible operations | representative task matrix | every critical cutover/denial/rollback/read-only/incident/acceptance workflow completes with keyboard and selected AT; status not color-only |
| FF24-24 | Supportability | blind T1 support exercise | defined failure set diagnosed from safe evidence within owner-approved support objective; no raw-data workaround |
| FF24-25 | Reappearance detection | repair/GPO/package positive controls | every planted task/service/package/credential/path reappearance detected and acceptance reopened |
| FF24-26 | Final primary gate | independent evaluator | all primary predicates pass, no blocking exception/owner/evidence gap, and multi-owner decision exists |

## 9.1 Primary-gate expression

The independent evaluator MUST implement, at minimum:

```text
FinalDecommissionEligible =
    DiscoveryAccepted
AND ReconciliationAccepted
AND ZeroUnauthorizedLegacyWrites
AND AllLegacyBuffersDispositionedOrOwnedException
AND AllLegacyConsumersRetiredReplacedOrOwnedException
AND AllLegacyWriterCredentialsRevoked
AND AllActiveLegacyWriterSessionsTerminated
AND AllLegacyWritePathsBlocked
AND HistoricalArchiveOwnedAndReadyOrHumanApprovedNoArchive
AND NewOnlyRollbackPassed
AND LayeredReadOnlyPassed
AND ResidualMonitoringPassed
AND AllExceptionsCurrentOwnedContained
AND RunbooksAndTrainingPassed
AND CleanupPassed
AND EvidenceCurrentAndIndependentlyVerified
AND MultiOwnerAcceptanceRecorded
```

Unknown, missing, stale, conflicting, expired, or multiply resolved input evaluates to `false`, not `true`.

## 9.2 Data-quality acceptance

Prompt 23 must define the exact reconciliation profile. This result requires at least these properties:

- comparison identity does not depend on raw URL, mutable runtime version, or legacy row order;
- expected semantic differences have finite codes and owner-approved interpretation;
- loss, duplicate, cross-realm, privacy broadening, source-generation conflict, and unknown are hard-stop classes;
- zero/unknown/offline/deferred/unsupported/suppressed are distinct;
- comparisons bind exact source generation, interpretation, release, contract, policy, and time-quality classes;
- the oracle is independent and mutation-tested;
- a passing aggregate cannot hide a hard individual invariant failure.

---

# 10. Human decisions and owner questions

Role names below are accountable functions, not assigned people. Research does not claim any approval.

## 10.1 Required decisions with options, consequences, conservative temporary defaults, and accountable roles

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function |
|---|---|---|---|---|
| HD24-01 | Go/no-go authority | Single accountable executive; quorum; change advisory plus technical gate. Too diffuse delays response; too concentrated weakens challenge. | No transfer without one named final authority and independent technical gate. | Designated Production/Change Risk Authority |
| HD24-02 | Rollback authority | Cutover director; incident commander; release authority; two-person rule. Must distinguish pause from destructive rollback. | Any on-call may invoke a pre-authorized **pause**; only named authority may select new N-1 or broaden scope. | Release/Risk Authority with Incident Command |
| HD24-03 | Historical archive owner and purpose | Data/records owner; product owner; legal/records jointly. No owner means no access or final acceptance. | Keep archive read-blocked; preserve only under existing approved custody until decided. | Data Controller/Records Management/Product Governance |
| HD24-04 | Required bake periods/support coverage | Per-ring fixed periods; event-cycle/coverage based; risk-based combination. Longer increases confidence/cost; shorter raises latent-risk chance. | Explicit human promotion after complete required coverage; no auto-promotion. | Product Risk + SRE/Support + Cutover Authority |
| HD24-05 | Post-decommission monitoring duration/retention | Through credential/cert lifetime; through exception horizon; fixed period; ongoing minimal deny telemetry. Longer improves detection but increases privacy/cost. | Keep bounded server-side failed-use/denial monitoring until every known residual horizon is closed; exact duration unselected. | Security Monitoring + Privacy/Records + Risk |
| HD24-06 | Deferred legacy buffer disposition | Drain before transfer; typed transform; quarantine; discard/expire. Each affects coverage, risk, cost, and retention. | Freeze and quarantine; do not execute or delete until Prompt 22/23 and human decision. | Data Owner + Records/Privacy/Legal + Data Reliability |
| HD24-07 | Unreachable-device policy | Wait; contain and proceed; write off/remove from management; replace. Waiting prolongs trust; proceeding creates residual exceptions. | Revoke shared trust and block paths; contain device; remove/re-enroll on return. | Endpoint Product/Operations + Security/Risk |
| HD24-08 | Compatibility writer allowance/expiry | None; short typed bridge; extended bridge. Longer reduces migration pressure but retains legacy coupling. | None unless an indispensable consumer is proved; hard expiry and no endpoint use. | Integration/Product Owner + Architecture/Security |
| HD24-09 | Read-only/archive topology | Original DB read-only; read-only copy; typed migration; managed archive. Trade-offs in cost, lifecycle, fidelity, and attack surface. | Read-only copy behind new BFF as first candidate; original runtime remains transitional only. | Data/Archive Architecture + Records + Operations |
| HD24-10 | Archive fields, identity, precision, access, exports | Minimum operational history; broader investigation detail; aggregated only. Broader fields increase privacy and misuse risk. | No person/activity detail or export until purpose and minimum contract approved. | Data Controller/Product/Privacy/IAM |
| HD24-11 | Archive retention/deletion/legal hold | Periods and age bases by data class; legal holds; backup expiry. Cannot be derived technically. | Preserve under existing approved policy; do not invent new indefinite retention. | Records Management/Data Controller/Legal |
| HD24-12 | Residual exception/final acceptance | Zero exceptions; accept contained classes; risk-based exception set. Acceptance can leave cost and uncertainty. | Blocking exception remains blocking unless named authority accepts its exact scope and residual risk. | Designated Production/Risk Authority with affected owner |
| HD24-13 | Credential/certificate evidence horizon | Keep tombstone/status evidence through cert/secret/backup/incident horizon; exact field periods. | Retain minimum opaque revocation/operation evidence under existing audit policy; values unselected. | Security/IAM/PKI + Records |
| HD24-14 | Support/on-call/staffing | Dedicated cutover bridge; follow-the-sun; business-hours; vendor support. Insufficient coverage invalidates bake/incident response. | Do not enter a ring without named coverage for its full bake and rollback window. | Engineering/Operations Leadership |
| HD24-15 | Communications and workforce/customer obligations | Technical-only; customer/workforce notice; legal/regulator; change calendar. | Limit research/game-day communication to approved internal synthetic context; production communication awaits authority. | Product/Legal/Privacy/Communications |
| HD24-16 | Database/PKI/secrets/network/CMDB tools and licenses | Existing enterprise platforms; new product; custom adapters. Affects skills, procurement, support, and exit cost. | Use native/approved platform APIs in lab; make no production dependency selection. | Architecture + Platform Owners + Procurement/Legal |
| HD24-17 | SLO/RPO/RTO and acceptable coverage gap | No gap; bounded gap; explicit unknown period; backlog drain target. No-gap may be impossible across semantic/source changes. | Report any gap/overlap honestly; do not infer activity or silently fill. | Product/Data Owner + SRE/Risk |
| HD24-18 | Final deletion of legacy runtime/data/backups | Immediate after acceptance; staged expiry; retained archive; media sanitization. | No final deletion until archive/retention/restore/hold decisions and evidence pass. | Records/Data Controller + Security/SRE |
| HD24-19 | Break-glass profile during cutover | Pause only; recovery-only fixed actions; broader emergency admin. | Pause and new-release rollback only; no legacy credential recreation or arbitrary SQL. | Security/IAM/Risk Authority |
| HD24-20 | Production cutover and decommission approval | Pilot/general rollout/final acceptance. | T1/lab only until all technical gates and human decisions pass. | Designated Production/Risk Authority |

## 10.2 Owner questions

1. Who can pause immediately, who can select new N-1, and who can authorize authority transfer or final acceptance?
2. Which exact cohorts, realms, endpoint management profiles, Windows/Edge/network tuples, and support windows are in each ring?
3. What complete legacy inventory and external-consumer evidence from Prompt 22 must be accepted before transfer?
4. What exact comparison identity, semantic-difference taxonomy, hard mismatch classes, and acceptance thresholds from Prompt 23 apply?
5. What is the approved first-run behavior at transfer, and how are gap, overlap, offline return, and late source records described?
6. Which legacy deferred buffers are required records, which may be transformed, and who may authorize discard?
7. Can writer and reader credentials be separated for every required historical consumer? If not, which dependency must be replaced?
8. Which archive topology, fields, purpose, access, retention, legal hold, export, deletion, restore, and accessibility rules are approved?
9. Which credential/certificate/private-key/secret copies exist in packages, stores, backups, scripts, operator workbooks, and support systems?
10. What network routes, aliases, listeners, proxies, VPNs, failover paths, and management networks must be denied or retained?
11. What residual exception classes may be accepted, for how long, and with what containment and on-return behavior?
12. What successful-write/failed-attempt monitoring can be retained, for what period, by whom, and with which privacy-safe fields?
13. What SLO/RPO/RTO, backlog, support queue, capacity, and cost thresholds govern ring pause and promotion?
14. Which roles own SQL/PKI/network/endpoint/portal/archive/CMDB changes and can prove cleanup?
15. What evidence and owner quorum constitutes final acceptance, and who reopens a decommission after a late finding?

---

# 11. CLI experiments/measurements and exact evidence

## 11.1 Safety constraints

- All commands below use placeholders such as `<LAB_TASK>`, `<LAB_SERVICE>`, `<LAB_DB>`, `<LAB_LOGIN>`, `<LAB_HOST>`, and `<LAB_CERT>`.
- Research commands are read-only unless explicitly marked `LAB-ONLY MUTATION`.
- Never paste production names, hosts, addresses, ports, users, certificates, keys, connection strings, SSH material, SQL text, or activity into evidence.
- Production revoke/disable/delete is prohibited during research.
- Shareable evidence contains normalized classes, counts, opaque tokens, hashes, result codes, and cleanup status only.
- Raw traces remain in the disposable restricted lab and are deleted/reverted after sanitized evidence is generated.

## 11.2 Read-only Windows inventory

```powershell
# E24-CLI-01 — scheduled task inventory (read-only)
Get-ScheduledTask |
  Select-Object State, TaskPath, TaskName |
  ConvertTo-Json -Depth 4

# Shareable evidence MUST replace TaskPath/TaskName with keyed opaque tokens.

# E24-CLI-02 — task runtime status (read-only)
Get-ScheduledTask -TaskName '<LAB_TASK>' -TaskPath '<LAB_TASK_PATH>' |
  Get-ScheduledTaskInfo |
  Select-Object LastRunTime, LastTaskResult, NextRunTime, NumberOfMissedRuns

# E24-CLI-03 — service inventory (read-only)
Get-CimInstance Win32_Service |
  Select-Object State, StartMode, ProcessId, Name, StartName, PathName

# Shareable evidence stores only controlled classes and digests for Name/StartName/PathName.

# E24-CLI-04 — active connections (read-only)
Get-NetTCPConnection -State Established,Listen |
  Select-Object State, OwningProcess, LocalPort, RemotePort

# Addresses are not exported. Ports are converted to approved service classes.

# E24-CLI-05 — active firewall policy (read-only)
Get-NetFirewallRule -PolicyStore ActiveStore |
  Select-Object Enabled, Direction, Action, Profile, PolicyStoreSourceType, DisplayName

# DisplayName is tokenized before evidence leaves the lab.
```

**Evidence:** exact PowerShell/OS version; script digest; item counts by finite class; keyed-token inventory; positive-control item found; no broad user-profile crawl; no secret/address/path in shareable output.

## 11.3 Lab-only schedule/service disable and removal

Microsoft provides dedicated cmdlets for disabling/unregistering scheduled tasks and stopping/disabling/removing services [W03–W05]. These commands are **LAB-ONLY MUTATION**:

```powershell
# LAB-ONLY: disable and verify a fictional task
Disable-ScheduledTask -TaskName '<LAB_TASK>' -TaskPath '<LAB_TASK_PATH>'
Get-ScheduledTask -TaskName '<LAB_TASK>' -TaskPath '<LAB_TASK_PATH>' |
  Select-Object State

# LAB-ONLY: unregister after observation/rollback evidence
Unregister-ScheduledTask -TaskName '<LAB_TASK>' -TaskPath '<LAB_TASK_PATH>' -Confirm:$false

# LAB-ONLY: stop and disable a fictional service
Stop-Service -Name '<LAB_SERVICE>' -Force
Set-Service -Name '<LAB_SERVICE>' -StartupType Disabled

# LAB-ONLY: remove only after rollback/cleanup decision
Remove-Service -Name '<LAB_SERVICE>'
```

**Pass evidence:** pre/post inventory digest; operation ID; exact result; no task/service restart after reboot/repair test; revert/uninstall cleanup. **Fail:** reappearance, wrong item, unbounded selection, or residue.

## 11.4 SQL Server inventory and read-only verification

Use a lab account with minimum required view permissions. Output names are tokenized.

```sql
-- E24-CLI-06 — database state (read-only)
SELECT database_id, state_desc, user_access_desc, is_read_only
FROM sys.databases
WHERE name = N'<LAB_DB>';

-- E24-CLI-07 — current sessions (read-only)
SELECT session_id, login_time, status, host_process_id, program_name,
       login_name, original_login_name
FROM sys.dm_exec_sessions
WHERE is_user_process = 1;

-- E24-CLI-08 — principals and role memberships (read-only)
SELECT sp.principal_id, sp.type_desc, sp.is_disabled
FROM sys.server_principals AS sp;

SELECT role_principal_id, member_principal_id
FROM sys.server_role_members;

-- E24-CLI-09 — database permission classes (read-only)
USE [<LAB_DB>];
SELECT class_desc, permission_name, state_desc, grantee_principal_id
FROM sys.database_permissions;
```

**Evidence:** DB state, active-session count by opaque principal/program class, permission/role digests, inventory completeness, and positive-control writer/reader classifications. No SQL text, hostname, login name, or address leaves the lab.

## 11.5 Lab-only SQL disable, session termination, permission removal, and read-only

```sql
-- LAB-ONLY MUTATION — disabling does not end existing sessions
ALTER LOGIN [<LAB_LOGIN>] DISABLE;

-- LAB-ONLY — identify exact fictional session, then terminate
KILL <LAB_SESSION_ID>;

-- LAB-ONLY — remove a fictional database permission/role membership
USE [<LAB_DB>];
REVOKE INSERT, UPDATE, DELETE, EXECUTE FROM [<LAB_USER>];
ALTER ROLE [<LAB_WRITER_ROLE>] DROP MEMBER [<LAB_USER>];

-- LAB-ONLY — layered archive candidate; requires exclusive access and restore test
USE [master];
ALTER DATABASE [<LAB_DB>] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE [<LAB_DB>] SET READ_ONLY;
ALTER DATABASE [<LAB_DB>] SET MULTI_USER;

-- LAB-ONLY — DROP only after owned securables/jobs and mapped users are handled
DROP LOGIN [<LAB_LOGIN>];
```

**Required evidence:** active session existed before disable; new login denied; existing session behavior measured; `KILL` completed/rollback status recorded; permission mutation verified; approved reads pass; write probes fail; SQL Audit/XE detects attempts; database backup/restore and read-only state tested; all lab objects removed/reverted.

## 11.6 SQL residual monitoring

```sql
-- E24-CLI-10 — bounded session count by approved opaque principal class
SELECT COUNT_BIG(*) AS active_session_count
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
  AND login_name = N'<LAB_LOGIN>';

-- E24-CLI-11 — SQL Audit / Extended Events are configured in the lab
-- using fixed event sets for login success/failure, permission change, and writes.
-- Do not export statement text, client address, user identity, or object names.
```

SQL Server Audit includes failed-login auditing and Extended Events is a configurable event framework [W13–W15]. UAM-specific fitness still requires positive-control and privacy tests.

## 11.7 Network denial experiments

```powershell
# E24-CLI-12 — read-only connectivity classification
Test-NetConnection -ComputerName '<LAB_HOST>' -Port <LAB_PORT_CLASS_VALUE> -InformationLevel Detailed

# LAB-ONLY MUTATION — create fixed block rule with a generated lab-only name
New-NetFirewallRule -DisplayName '<LAB_RULE>' -Direction Outbound -Action Block `
  -Program '<LAB_LEGACY_BINARY_PATH>' -Protocol TCP -RemotePort <LAB_PORT_CLASS_VALUE>

# Verify active policy, then remove during cleanup
Get-NetFirewallRule -DisplayName '<LAB_RULE>' | Get-NetFirewallApplicationFilter
Remove-NetFirewallRule -DisplayName '<LAB_RULE>'
```

Windows firewall can be managed from PowerShell/netsh, but effective enterprise policy and precedence must be inspected; local configuration alone is not proof [W16–W19].

**Evidence:** route classes tried, expected/actual success, active policy digest, server-side corroboration, approved new/archive route continuity, and rule cleanup.

## 11.8 Certificate revocation lab

```powershell
# E24-CLI-13 — read-only certificate-store inventory by opaque token
Get-ChildItem -Path 'Cert:\LocalMachine\My' |
  Select-Object NotBefore, NotAfter, HasPrivateKey, EnhancedKeyUsageList, Thumbprint

# Shareable evidence replaces Thumbprint and subject/issuer with opaque digests/classes.

# LAB-ONLY — use the approved lab CA procedure / certutil profile with placeholders.
# Exact commands depend on the lab CA and must not be copied to production.
certutil -revoke '<LAB_CERT_SERIAL>'
certutil -crl
```

**Evidence:** issuer/tool profile, opaque cert token, status before/after, fresh and existing connection tests, application deny state, CRL/status publication class, key/trust cleanup. Certificate serials, subjects, URLs, and private material do not enter shareable evidence.

## 11.9 Buffer inventory and disposition harness

```powershell
# E24-CLI-14 — fictional bounded buffer inventory only
$root = '<LAB_BUFFER_ROOT>'
Get-ChildItem -LiteralPath $root -File -Force |
  ForEach-Object {
    [pscustomobject]@{
      ItemToken = '<computed-purpose-separated-digest>'
      LengthClass = '<bucketed>'
      AgeClass = '<bucketed>'
      ContentDigest = '<sha256>'
    }
  } | ConvertTo-Json -Depth 3
```

The harness MUST NOT print file names, paths, SQL text, URLs, user data, or raw contents. It must implement synthetic drain/quarantine/discard-authority cases, crash after each durable boundary, and compare before/after set digests.

**Evidence:** creation-freeze proof, item-set digest, count/size/age classes, decision authority, per-item-set terminal state, no raw execution, and cleanup/hold state.

## 11.10 Cutover model, contracts, and gate CLI

```bash
# E24-CLI-15 — strict contract and state vectors
dotnet test tests/migration/Uam.Migration.Contracts.Tests \
  --configuration Release --no-restore

dotnet test tests/migration/Uam.Migration.StateModel.Tests \
  --configuration Release --no-restore

# E24-CLI-16 — compile a fictional plan and evaluate gates
dotnet run --project src/tools/Uam.CutoverCheck -- \
  validate-plan --input fixtures/t1/cutover-plan.json \
  --evidence-root fixtures/t1/evidence \
  --output artifacts/t1/cutover-gate.json

# E24-CLI-17 — generate a privacy-safe acceptance record
dotnet run --project src/tools/Uam.DecommissionEvidence -- \
  build --plan fixtures/t1/cutover-plan.json \
  --gate artifacts/t1/cutover-gate.json \
  --output artifacts/t1/decommission-record.json
```

**Evidence:** strict valid/invalid vector results, state-transition histories, mutation results, deterministic output digests, missing evidence correctly blocking, and no test hooks/tools in production artifacts.

## 11.11 Residual inventory comparison

```powershell
# E24-CLI-18 — compare two sanitized, tokenized inventory snapshots
param(
  [Parameter(Mandatory)] [string] $BeforeJson,
  [Parameter(Mandatory)] [string] $AfterJson
)

$before = Get-Content -Raw -LiteralPath $BeforeJson | ConvertFrom-Json
$after  = Get-Content -Raw -LiteralPath $AfterJson  | ConvertFrom-Json

Compare-Object -ReferenceObject $before.items -DifferenceObject $after.items `
  -Property ItemToken, StateClass, OwnerClass
```

**Pass:** every expected removal appears; no unexplained addition/reappearance; expected archive/new-system items remain. **Evidence:** input/output hashes, diff, owner classification, positive control, and cleanup.

## 11.12 Exact evidence package

Each CLI lane produces:

```text
evidence/24/<experiment-id>/
  manifest.json
  environment.sanitized.json
  source-and-tools.sha256
  input-root.json
  command-profile.json            # placeholders/digests, not connection details
  observations.ndjson
  state-before.json
  state-after.json
  positive-controls.json
  canary-scan.json
  first-failure.json?              # never overwritten
  reruns.ndjson
  cleanup-receipt.json
  evidence-root.json
```

The package is T1 or approved sanitized aggregate evidence. It contains no production connection values or raw internal evidence.

---

# 12. ADR proposals

| ADR | Decision | Status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| **ADR-B06-001** | Staged ring cutover with immutable cohort manifests and explicit human promotion | **PROPOSED — accept for implementation** | big bang; ad hoc waves | smaller blast radius; same-digest promotion; measurable bake/stop [I05, I07, W01–W02] | Cutover/Release Architecture | Prompt 22/23 conflict, operational inability to form cohorts |
| **ADR-B06-002** | Exactly one ordinary authority per cohort/source epoch; new comparison output is non-authoritative | **PROPOSED — blocking pending Prompt 23** | indefinite dual write; legacy-only until instant switch | preserves one-effect/realm truth and bounded comparison | Data Correctness | accepted reconciliation model requires another boundary |
| **ADR-B06-003** | Smallest safe rollback is new capability/ring/release pause or authorized N-1; no legacy credential resurrection | **PROPOSED — accept** | automatic legacy rollback; dormant fleet credential | preserves accepted endpoint trust and release invariants | Release/Security | new primary evidence proves target cannot recover without baseline change |
| **ADR-B06-004** | Cutover has three irreversible milestones: authority transfer, trust removal, final decommission | **PROPOSED — accept** | one giant transaction/checklist | cross-system actions are not atomic; evidence and rollback differ | Cutover Architecture | selected platforms provide a genuinely atomic common authority (unlikely) |
| **ADR-B06-005** | Layered verified read-only and archive gateway; UI label alone insufficient | **PROPOSED — accept** | keep portal writable; DB read-only only; static exports | reduces mutation surface and supports purpose/audit/restore | Archive/Data Security | human archive decision or engine test changes topology |
| **ADR-B06-006** | Compatibility writer is optional typed server-side bridge with hard expiry; never endpoint SQL | **PROPOSED — disabled by default** | indefinite legacy integration; endpoint bridge | preserves typed authority and bounds migration debt | Integration Architecture | Prompt 22 proves indispensable consumer and accepted prototype passes |
| **ADR-B06-007** | Legacy deferred SQL/CSV is frozen and explicitly dispositioned; never blindly imported/executed | **PROPOSED — blocking pending Prompt 22/23 + human decision** | execute after cutover; blanket discard | executable text conflicts with target contracts and no-silent-loss rule | Data Reliability/Records | complete semantics and safe typed transform proof |
| **ADR-B06-008** | Credential removal is disable/revoke + session termination + permission/ownership cleanup + secret rotation/removal + network denial + failed-use monitoring | **PROPOSED — accept** | login disable only; cert revocation only; uninstall only | each layer has documented/operational gaps [W06–W11] | Security/IAM/DB/Network | selected platform evidence requires different sequence |
| **ADR-B06-009** | Unreachable devices become contained expiring exceptions; fleet trust is still revoked | **PROPOSED — accept** | wait indefinitely; accept active credential | avoids hostage devices while preventing residual writes | Endpoint Security/Risk | approved business need for a different device class |
| **ADR-B06-010** | Residual monitoring uses multiple bounded privacy-safe sensors with positive controls | **PROPOSED — accept** | one SIEM query/sensor; raw endpoint telemetry | independent blind spots and minimization | Security Monitoring/Privacy | monitor bake-off shows simpler equivalent coverage |
| **ADR-B06-011** | Final acceptance is a content-addressed record recomputed by an independent evaluator and multi-owner decision | **PROPOSED — accept** | checklist/email/self-asserted completion | prevents missing evidence/owner from silently passing | Verification Governance | organizational approval model changes |
| **ADR-B06-012** | Residual exceptions always expire and never auto-renew | **PROPOSED — accept** | permanent waiver | prevents hidden permanent legacy surface | Risk Governance | none expected; extensions remain new decisions |
| **ADR-B06-013** | Operational game day is mandatory before R1 and again before final trust removal for the exact release/topology | **PROPOSED — accept** | tabletop only | proves rollback, revocation, read-only, support, cleanup | Operations/Verification | platform/topology/release or critical runbook changes |
| **ADR-B06-014** | Post-decommission findings reopen a linked technical state; historical evidence is immutable | **PROPOSED — accept** | edit acceptance record; ignore late finding | preserves audit truth and remediation | Audit/Verification | none expected |
| **ADR-B06-015** | OSS tools are reference/input only by default; no runtime dependency selected in this topic | **PROPOSED — accept** | adopt Argo/Flagger/Rundeck/OpenBao/osquery/in-toto directly | threat/platform mismatch and unproved operations/licensing fit | Architecture/Dependency Security | explicit platform need and full admission evidence |
| **ADR-B06-016** | Missing Prompt 22/23 evidence is a hard gate, not a replaceable assumption | **PROPOSED — accept** | infer inventory/reconciliation from static baseline | prompt allowlist and evidence rules prohibit substitution | Architecture Review | files become available and are reconciled |

No ADR above changes the accepted baseline. A future request to restore legacy endpoint SQL trust must create a baseline change proposal, not merely update ADR-B06-003.

---

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Backlog item | Depends on | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record evidence boundary and missing-file blockers | none | immutable input manifest, M01/M02 blockers | any unallowlisted substitution |
| 2 | Create ADRs B06-001 through B06-016 and owner placeholders | 1 | reviewable ADRs | blocking ADR silently omitted |
| 3 | Define migration contract catalogue and strict schemas | 1–2, Batch 01 contracts | contracts in section 5 + valid/invalid vectors | unknown field/default/realm authority accepted |
| 4 | Implement pure cutover/authority/credential/buffer/archive/exception state models | 3 | deterministic C# models and independent checker | dual primary, state decrease, legacy resurrection, skipped gate |
| 5 | Implement route/action/metric catalogues and architecture prohibitions | 3–4 | CI tests for no SQL/credential/script/bypass | one forbidden dependency/route survives |
| 6 | Build T1 fixture/oracle package for cutover and decommission | 3–5, G0 | fictional estate, buffers, credentials, archive, failures, truth | nondeterminism, real value, common-mode oracle defect |
| 7 | Implement evidence envelope, positive controls, canary scans, cleanup receipts | 5–6 | `Uam.DecommissionEvidence`, scanner, evaluator | mandatory canary/evidence mutation miss |
| 8 | Implement read-only inventory adapters (Windows, SQL, PKI/network placeholders, CMDB abstraction) | 3, 7 | read-only scripts and sanitized normalized output | broad crawl, secret/address/path leak, positive-control miss |
| 9 | Implement typed lab action adapters with `LAB_ONLY` build boundary | 3–8 | task/service/login/session/firewall/cert action receipts | production artifact contains destructive test controller or arbitrary input |
| 10 | Execute R0 pure/model/architecture/monitor tests | 4–9 | E24-01–04, 07–08, 16, 18–23 evidence | any hard invariant failure |
| 11 | Execute disposable Windows/SQL/PKI/network lab matrix | 8–10 | E24-05–06, 09–15, 17–19, cleanup | production detail appears; rollback/read-only/revocation/path failure |
| 12 | Run operational game day and blind support/accessibility exercises | 10–11 | game-day evidence and updated runbooks | legacy credential requested/recreated, raw data needed, inaccessible workflow, residue |
| 13 | Implement cutover module scaffolding in modular monolith | 3–12 | plan/ring/authority/exception/evidence APIs with same-transaction audit | generic admin/action, cross-realm, missing audit |
| 14 | Implement enterprise deployment/legacy control integration interfaces as no-op/T1 fakes | 13 | exact adapter contracts, idempotency/reconciliation | browser/tenant can provide command/path/host |
| 15 | Obtain and review `result-22-legacy-discovery.md` | external same-stream | accepted inventory digest, contradictions, blockers | missing/incomplete/unowned legacy path |
| 16 | Obtain and review `result-23-parallel-run-reconciliation.md` | external same-stream | accepted comparison profile, oracle, thresholds/classes | unknown/loss/duplication/realm/privacy ambiguity |
| 17 | Reconcile Prompt 24 ADRs/contracts with 22/23 | 15–16 | updated plan compiler/gates; explicit conflicts | baseline conflict without change proposal |
| 18 | Assign accountable human functions and decide ring/bake/archive/buffer/exception/support policies | 17 + governance | signed decisions and profiles | any blocking `UNASSIGNED` or invented default |
| 19 | Qualify exact production-like platform/deployment/database/archive profiles in approved lab | predecessors + 17–18 | current exact evidence | stale/unsupported tuple, missing rollback/restore |
| 20 | Compile one R1 cutover candidate | 13–19 | immutable plan/cohort/release/monitor/runbook/evidence digests | gate evaluator not fully pass; no support coverage |
| 21 | Separate production change approval | 20 | approved change record | research evidence treated as production authority |
| 22 | Execute R1 under live governance | 21 | ring observations, first failures, pause/promotion decision | any hard stop or monitor blindness |
| 23 | Repeat for R2–R4 only through explicit promotion | 22 | ring-by-ring evidence | skipped ring/changed digest/expired evidence |
| 24 | Execute legacy read-only and archive transition | accepted new primary + archive decisions | layered read-only and archive readiness | successful write, unowned history, unaudited access |
| 25 | Execute credential/session/secret/network trust removal | 24 + inventory | verified revocation records | active credential/session/path/shared dependency |
| 26 | Execute residual monitoring and unreachable exception workflow | 25 | residual findings, contained exceptions | successful write, unknown recurring attempt, expired exception |
| 27 | Remove legacy runtime/components and reconcile CMDB/backups/packages | 26 | cleanup receipt and asset state | residue/reappearance/unowned copy |
| 28 | Re-run exact game day/restore/rollback evidence if release/topology changed | 24–27 | current evidence | stale evidence |
| 29 | Build independent decommission acceptance record | 15–28 | `DecommissionAcceptanceRecordV1` | any predicate/owner/evidence missing |
| 30 | Multi-owner final decision and post-decommission monitoring transition | 29 | accepted/blocked decision plus next monitoring state | self-acceptance, waiver without expiry, legal/technical overclaim |

## 13.1 Stop-gate dependency summary

```text
Prompt 22 accepted ─┐
                    ├─> B06-DISCOVERY/RECONCILIATION ─> R1 candidate
Prompt 23 accepted ─┘

R1 -> R2 -> R3 -> R4
       any hard failure -> PAUSE / new-only rollback / repair

NewPrimaryAccepted
  -> LayeredReadOnly
  -> CredentialSessionSecretNetworkRemoval
  -> ResidualMonitoring + Exceptions
  -> ArchiveOwned/Ready
  -> Cleanup + CMDB/Backup Reconciliation
  -> Independent Evidence
  -> MultiOwner Acceptance
  -> Decommissioned
```

---

# 14. Open-source repository assessment table

**Method.** Repositories were reviewed as design evidence, not by popularity. Exact review points are pinned below. A later dependency decision MUST repeat source/package/binary provenance, license, advisories, maintenance, tests, threat fit, removal, and operational evidence at execution time.

| Repository and review point | Relevant files/directories | License and compatibility | Maintenance, tests, and security posture | Similarities and threat-model differences | Reusable ideas | Ideas not to copy | Suitability |
|---|---|---|---|---|---|---|---|
| **Argo Rollouts** — [repo](https://github.com/argoproj/argo-rollouts), [tag `v1.9.1`](https://github.com/argoproj/argo-rollouts/tree/v1.9.1), [release](https://github.com/argoproj/argo-rollouts/releases/tag/v1.9.1), commit `b6bd3bc`; release notes dated 6 Jul 2026 | `rollout/`, `analysis/`, `controller/`, `pkg/apis/rollouts/v1alpha1/`, `metricproviders/`, `test/`, `docs/`, `SECURITY.md` | Apache-2.0. Permissive, but transitive Kubernetes/metrics/ingress dependencies and operational platform remain substantial. | Active release; v1.9.1 is a security maintenance release addressing CVE-2026-35469 and a gRPC update. Repository has unit/E2E test areas, CI, code owners, and a security policy. Upstream tests prove Kubernetes behavior, not UAM. | Similar: canary/blue-green states, analysis gates, pause/promotion, rollback. Different: Kubernetes workload/traffic controller with cluster credentials; no Windows endpoint source, realm, buffer, credential-revocation, archive, or transactional UAM audit model. | Explicit rollout states; analysis run identity; pause before promotion; stable revision; manual judgment; metric providers as replaceable adapters. | Kubernetes CRDs/controllers, weighted network traffic as authority, generic metrics automatically deciding credential/legacy rollback, plugin/provider breadth. | **Reference only.** Do not add as UAM runtime dependency. |
| **Flagger** — [repo](https://github.com/fluxcd/flagger), [tag `v1.44.0`](https://github.com/fluxcd/flagger/tree/v1.44.0), [release](https://github.com/fluxcd/flagger/releases/tag/v1.44.0), commit `15bd6ad`; released 21 Jul 2026 | `pkg/controller/`, `pkg/canary/`, `pkg/metrics/`, `pkg/router/`, `test/`, `docs/`, `charts/`, `.github/` | Apache-2.0. Kubernetes, mesh/ingress, chart, and monitoring integrations expand dependency/operations scope. | Signed tag and recent release; repository includes tests, CI, governance/maintainers, and security reporting through the Flux/CNCF project. Exact integration quality varies by provider. | Similar: progressive exposure, metric checks, conformance tests, promotion/rollback. Different: reconciles Kubernetes resources and traffic, can synchronize Secrets/ConfigMaps, and assumes cluster/operator authority; UAM cutover must not let metrics or generic objects control legacy credentials/scripts. | Declarative staged plan; bounded analysis interval; conformance hooks; explicit failed-check threshold concept; status conditions. | Default numeric thresholds; automatic rollback to an unsafe predecessor; synchronizing secrets/config as a generic pattern; service-mesh assumptions. | **Reference only.** Useful second design comparator to avoid copying one project's state model. |
| **Rundeck** — [repo](https://github.com/rundeck/rundeck), [review commit `9fe4ed6fce109829e7af3e9be4e280b180adaf1a`](https://github.com/rundeck/rundeck/tree/9fe4ed6), corresponding 6.0.1-20260715 review point | `rundeckapp/`, `core/`, `rundeck-storage/`, `functional-test/`, `rundeckapp/src/test/`, `plugins/`, `docs/`, `SECURITY.md` | Apache-2.0 source license at the reviewed commit. Actual deployment may involve separate enterprise plugins/features/licenses; procurement must verify the selected distribution. | Broad unit/functional/Selenium tests and security policy/advisories. Major 6.0 release notes describe dependency/security modernization; the reviewed commit includes authentication/role regression tests. Large Java/Grails/plugin surface and historical advisories require dedicated hardening and patch operations. | Similar: runbook/job states, approvals/ACLs, execution history, retry, node inventory. Different: designed to execute commands/workflows across nodes and hold credentials/plugins; that is precisely broader than UAM's fixed typed cutover capabilities. | Stable job/step identity; immutable execution history; pause/retry semantics; operator views; external runbook ownership patterns. | General remote shell, arbitrary scripts/commands, node plugins, credential storage, user-authored workflows as UAM's authority plane. | **Reference only / external enterprise-tool candidate under separate review.** **Not** a UAM dependency or portal command engine. |
| **OpenBao** — [repo](https://github.com/openbao/openbao), [tag `v2.6.1`](https://github.com/openbao/openbao/tree/v2.6.1), [release](https://github.com/openbao/openbao/releases/tag/v2.6.1), commit `ba7ad88`; released 22 Jul 2026 | `vault/`, `logical/`, `audit/`, `api/`, `sdk/logical/`, `command/`, `physical/`, `helper/testhelpers/`, `website/content/docs/`, `SECURITY.md` | MPL-2.0 file-level copyleft; service use may be compatible, but embedding/modification/distribution and plugins need legal review. Operational cost includes HA, unseal/root recovery, storage, audit, upgrades, and incident response. | Active releases and explicit security disclosure. v2.6.x release notes include multiple security fixes and policy/lease/cache fixes. Large test suite and security-sensitive codebase, but UAM fitness/key governance is not established. | Similar: purpose-specific credentials, leases, expiry, revocation trees, audit, dynamic secrets, recovery. Different: general secrets/PKI platform with root/seal/policy/plugin/workflow authority; UAM must not assume an existing deployment or import its policy language. | Monotonic leases; revocation as a first-class state; purpose separation; short-lived credentials; explicit recovery; audit of secret use. | Generic secrets workflows, unauthenticated/configurable workflows, broad ACL/template language, treating lease expiry alone as proof that every external session/path stopped. | **Reference only / possible organization-wide service candidate.** No selection in this topic. |
| **osquery** — [repo](https://github.com/osquery/osquery), [tag `5.23.1`](https://github.com/osquery/osquery/tree/5.23.1), [release](https://github.com/osquery/osquery/releases/tag/5.23.1), commit `b753833`; released 24 Jun 2026 | `osquery/tables/system/windows/`, `osquery/events/windows/`, `specs/windows/`, `tests/`, `tools/tests/`, `plugins/`, `SECURITY.md` | Repository contains Apache-2.0 and GPL-2.0 licensing material; exact components/binary distribution require legal review. A deployed fleet adds daemon/config/query/transport/extension/upgrade operations. | Active security/bug-fix release; 5.23.1 fixed Windows `processes` and `authenticode` heap overflows plus other security defects. Strong table/spec/test structure and security policy, but broad instrumentation has had security-sensitive parser/table bugs. | Similar: endpoint inventory, task/service/process/network/certificate visibility, scheduled queries. Different: SQL-powered general OS instrumentation and optional distributed queries/extensions; UAM endpoint architecture prohibits arbitrary query/plugin channels and sensitive raw diagnostics. | Typed inventory tables; schema-defined observations; query scheduling separated from transport; local evidence collection; test fixtures. | Remote arbitrary SQL, broad process/command-line/address collection, extensions/plugins, treating one agent as complete residual proof. | **Reference only; optional isolated lab sensor candidate.** Native fixed PowerShell/.NET inventory is simpler for the first lane. |
| **in-toto-golang** — [repo](https://github.com/in-toto/in-toto-golang), [tag `v0.11.0`](https://github.com/in-toto/in-toto-golang/tree/v0.11.0), [release](https://github.com/in-toto/in-toto-golang/releases/tag/v0.11.0), commit `36d782f`; released 4 May 2026 | `in_toto/`, `in_toto/model/`, `in_toto/runlib.go`, `in_toto/verifylib.go`, `in_toto/*_test.go`, `test/`, `.github/` | Apache-2.0. Go implementation does not align with accepted C# default as an in-process dependency; a separate verifier CLI/service adds toolchain and key operations. | Maintained release. v0.11.0 patches the published inconsistent-negation advisory GHSA-pmwq-pjrm-6p5r. Repository includes unit/integration/demo verification tests and signed metadata concepts; path/rule semantics require exact vectors. | Similar: signed layouts, expected steps/materials/products, link metadata, independent verification. Different: software supply-chain steps and filesystem artifacts, not operational state, SQL sessions, network denial, buffers, or human cutover authority. | Content-addressed evidence; declared steps; independent verification; products/materials digests; failure on undeclared artifacts; signed attestations. | Generic command execution through `run`; assuming artifact hashes prove operational truth; permissive/default path-rule semantics without final deny; Go library inside UAM runtime. | **Reference only / evidence-format test-tool candidate.** UAM should own its contracts and verifier. |
| **Gitleaks** — [repo](https://github.com/gitleaks/gitleaks), [tag `v8.30.1`](https://github.com/gitleaks/gitleaks/tree/v8.30.1), commit `83d9cd6` (tag review point; no normal GitHub release) | `detect/`, `config/`, `cmd/`, `testdata/`, `SECURITY.md`, issues [#2086](https://github.com/gitleaks/gitleaks/issues/2086) and [#2170](https://github.com/gitleaks/gitleaks/issues/2170) | MIT. License is permissive, but exact binary/source/tag provenance and scanner correctness are load-bearing. | Exact reviewed tag is problematic: issue #2086 reports it is an orphaned tag with no corresponding normal release, and issue #2170 reports a v8.30.1 binary silently detecting no secrets for a canonical positive control. Batch 01 already rejected this review point. | Similar: detect credential residue in source/files. Different: regex/entropy scanner cannot inventory active sessions, PKI status, firewall paths, encrypted stores, backups, or operational use. | Mandatory positive controls; exact-version pinning; layered scanning; scanner result as evidence input, not oracle. | Treating zero exit as proof; using v8.30.1; broad allowlists; uploading repositories/evidence to external services. | **Neither at the reviewed version.** Reconsider a later exact release only after source/binary provenance and UAM positive controls pass. |

## 14.1 Repository conclusion

**RECOMMENDATION.** No reviewed repository should become a UAM production runtime dependency from this topic. Argo Rollouts and Flagger are useful state-model references; Rundeck is a negative/operational comparator for command authority; OpenBao is a credential-lifecycle reference and possible separately governed enterprise service; osquery is a broad residual-monitoring reference or lab-only candidate; in-toto-golang is an evidence-design reference; Gitleaks v8.30.1 is rejected.

---

# 15. Source register with stable links, dates, reviewed versions/commits, claims, and limitations

## 15.1 Supplied project sources

| Ref | Source/date | Reviewed identity | Claim supported | Limitation |
|---|---|---|---|---|
| I01 | Shared accepted baseline, 31 Jul 2026 | SHA-256 `919cce38...e35c7a` | accepted target architecture and invariants | condensed; not runtime or production approval |
| I02 | Existing-system evidence summary, Jul 2026 | SHA-256 `bb34186d...7fa6` | legacy monolithic PowerShell, direct SQL, deferred executable SQL, schedules/settings/broad mutations | static, sanitized; misses runtime config, dynamic paths, consumers, volumes |
| I03 | Accepted decisions/contradictions/gates, Jul 2026 | SHA-256 `ed67d887...f4c6b7a` | accepted decisions and proof order | not execution evidence |
| I04 | Research evidence rules, Jul 2026 | SHA-256 `7e3bab7...634a729` | evidence labels, source/authority/conflict rules | not technical proof |
| I05 | Batch 01 review, 31 Jul 2026 | SHA-256 `10d5e1e...c75b` | contracts, G1, privacy/policy, release/repository, audit/runbook foundations | conditional gates; no migration inventory |
| I06 | Batch 02 review, 31 Jul 2026 | SHA-256 `98aace5...01ef` | source/privacy/progress/interpretation/data-quality rules | synthetic/lab scope; no parallel-run result |
| I07 | Batch 03 review, 31 Jul 2026 | SHA-256 `76854c3...a785` | release rollback, endpoint durability, credential identity/revocation, diagnostics, compatibility | aggregate gate open; exact platforms/PKI/values provisional |
| I08 | Batch 04 review, 1 Aug 2026 | SHA-256 `232fec0...5ed4` | durable custody, cleanup hold, lifecycle/tombstone/restore | production cleanup/database/capacity/lifecycle open |
| I09 | Batch 05 review, 1 Aug 2026 | SHA-256 `38dc40c...d99` | purpose-bound admin, transactional audit, archive access, break-glass, restore, accessibility | portal/audit production gate open |
| M01 | `result-22-legacy-discovery.md` | **missing** | required runtime legacy inventory | no substitution; blocks B06-DISCOVERY |
| M02 | `result-23-parallel-run-reconciliation.md` | **missing** | required comparison/reconciliation contract | no substitution; blocks B06-RECONCILIATION |

## 15.2 Current primary and official sources

| Ref | Stable source | Source/release date and reviewed profile | Claim supported | Limitation |
|---|---|---|---|---|
| **W01** | Microsoft, [Safe deployment practices](https://learn.microsoft.com/en-us/devops/operate/safe-deployment-practices) | updated 28 Nov 2022; reviewed 1 Aug 2026 | bake time and progressive exposure concepts | general service deployment guidance, not UAM endpoint proof |
| **W02** | Microsoft Azure Well-Architected, [Safe deployment practices](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments) | updated 17 Jun 2026 | bake periods may span hours/days and increase across groups to observe normal use/time zones | Azure/general guidance; exact UAM periods remain human decisions |
| **W03** | Microsoft PowerShell, [Disable-ScheduledTask](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/disable-scheduledtask?view=windowsserver2025-ps) | Windows Server 2025 module view; reviewed 1 Aug 2026 | documented task disable capability | does not prove enterprise GPO/repair/estate behavior |
| **W04** | Microsoft PowerShell, [Unregister-ScheduledTask](https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/unregister-scheduledtask?view=windowsserver2025-ps) | Windows Server 2025 module view; reviewed 1 Aug 2026 | documented task removal capability | cleanup/rollback/permissions must be tested |
| **W05** | Microsoft PowerShell, [Set-Service](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-service?view=powershell-7.6) and [Remove-Service](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/remove-service?view=powershell-7.6) | PowerShell 7.6 view; reviewed 1 Aug 2026 | documented stop/startup/removal mechanisms | does not prove MSI/SCM/GPO/EDR interactions |
| **W06** | Microsoft SQL Server, [ALTER LOGIN](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-login-transact-sql?view=sql-server-ver17) | SQL Server 17.x docs; reviewed 1 Aug 2026 | login disablement and caveat that existing connections are not affected | exact legacy login ownership/topology unknown |
| **W07** | Microsoft SQL Server, [DROP LOGIN](https://learn.microsoft.com/en-us/sql/t-sql/statements/drop-login-transact-sql?view=sql-server-ver17) | SQL Server 17.x docs; reviewed 1 Aug 2026 | active login/owned securable/job constraints and orphaned-user consequence | no UAM-specific safe-drop proof |
| **W08** | Microsoft SQL Server, [KILL](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver17) and [`sys.dm_exec_sessions`](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-objects/sys-dm-exec-sessions-transact-sql?view=sql-server-ver17) | session DMV updated 20 Jul 2026; reviewed 1 Aug 2026 | active-session inventory and termination capability | permissions and rollback time/side effects need lab evidence |
| **W09** | Microsoft Support, [Decommission an enterprise certification authority and remove objects](https://learn.microsoft.com/en-us/troubleshoot/windows-server/certificates-and-public-key-infrastructure-pki/decommission-enterprise-certification-authority-and-remove-objects) | updated 12 Feb 2026 | revoke active certs; outstanding certificate/CRL lifetime influences decommission | CA decommission guidance, not UAM PKI selection |
| **W10** | Microsoft Windows Server, [`certutil`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/certutil) | current docs; reviewed 1 Aug 2026 | Windows certificate/CA administration command capability | exact enterprise CA/permissions/procedure unknown; commands can be destructive |
| **W11** | Microsoft NPS, [Certificate revocation list overview](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/network-policy-server-certificate-revocation-list-overview) | current docs; reviewed 1 Aug 2026 | CRL checking dependencies/limitations support layered revocation | NPS-specific framing; application status/network controls remain UAM decisions |
| **W12** | Microsoft SQL Server, [ALTER DATABASE SET options](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-set-options?view=sql-server-ver17) and [Database Properties — Options](https://learn.microsoft.com/en-us/sql/relational-databases/databases/database-properties-options-page?view=sql-server-ver17) | properties page updated 30 Apr 2026; reviewed 1 Aug 2026 | database `READ_ONLY` allows reads and rejects data/object modification; exclusive access considerations | privileged deletion/admin remains possible; not a complete archive/access control |
| **W13** | Microsoft SQL Server, [SQL Server Audit](https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-database-engine?view=sql-server-ver17) | current SQL Server 17.x docs; reviewed 1 Aug 2026 | native audit capability | not UAM transactional business audit; exact configuration/retention open |
| **W14** | Microsoft SQL Server, [Audit action groups and actions](https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions?view=sql-server-ver17) | updated 23 Feb 2026 | failed-login and permission/action classes available | volume/privacy/coverage need exact tests |
| **W15** | Microsoft SQL Server, [Quick start: Extended Events](https://learn.microsoft.com/en-us/sql/relational-databases/extended-events/quick-start-extended-events-in-sql-server?view=sql-server-ver17) | updated 20 Jul 2026 | configurable database event observation | statement/client fields can be sensitive; not sole proof |
| **W16** | Microsoft Windows Security, [Configure Windows Firewall with command line](https://learn.microsoft.com/en-us/windows/security/operating-system-security/network-security/windows-firewall/configure-with-command-line) | updated 14 May 2026 | PowerShell/netsh firewall management and policy considerations | enterprise precedence and UAM route matrix require testing |
| **W17** | Microsoft PowerShell, [Remove-NetFirewallRule](https://learn.microsoft.com/en-us/powershell/module/netsecurity/remove-netfirewallrule?view=windowsserver2025-ps) | Windows Server 2025 view; reviewed 1 Aug 2026 | rule-removal capability | local rule state is not necessarily effective enterprise policy |
| **W18** | Microsoft PowerShell, [Get-NetTCPConnection](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection?view=windowsserver2025-ps) | Windows Server 2025 view; reviewed 1 Aug 2026 | local TCP connection/state inventory | addresses/process data are sensitive and evidence must be minimized |
| **W19** | Microsoft PowerShell, [Test-NetConnection](https://learn.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection?view=windowsserver2025-ps) | Windows Server 2025 view; reviewed 1 Aug 2026 | bounded path/connectivity test | one test does not prove every route, policy, or time condition |
| **W20** | NIST, [SP 800-53 Rev. 5, Update 1](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final) | final control catalogue, 2020; reviewed 1 Aug 2026 | change control, inventory, authentication management, monitoring, contingency testing as governance references | controls are tailorable; not UAM implementation proof or legal requirement by themselves |
| **W21** | Microsoft Windows Security, [Sysmon overview](https://learn.microsoft.com/en-us/windows/security/operating-system-security/sysmon/overview) | updated 24 Feb 2026 | built-in/current Sysmon capability and event collection | broad security telemetry can collect sensitive values and requires policy |
| **W22** | Microsoft Windows Security, [Sysmon events](https://learn.microsoft.com/en-us/windows/security/operating-system-security/sysmon/sysmon-events) | updated 23 Feb 2026 | process/network event semantics; network event is configuration-dependent | high volume and sensitive command/address fields; not ordinary UAM diagnostics |
| **W23** | Microsoft Sysinternals, [Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon) | updated 17 Jun 2026 | downloadable Sysmon profile and current maintenance | exact deployment/config/privacy/support fit unproved |
| **W24** | Microsoft Windows auditing, [Audit Other Object Access Events](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/audit-other-object-access-events) | archived/current reference reviewed 1 Aug 2026 | scheduled-task create/delete/enable/disable/update event IDs | event availability depends on audit policy and OS; not complete inventory |
| **W25** | Microsoft Windows auditing, [Event 4697 — service installed](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4697) | archived/current reference reviewed 1 Aug 2026 | service-install security event | audit policy and event retention/collection vary |
| **W26** | NIST, [SP 800-137 — Information Security Continuous Monitoring](https://csrc.nist.gov/pubs/sp/800/137/final) | final 30 Sep 2011 | continuous monitoring should provide asset/control visibility and timely risk response | general guidance; exact UAM sensors/retention remain human and experimental |
| **W27** | NIST, [SP 800-88 Rev. 2 — Guidelines for Media Sanitization](https://csrc.nist.gov/pubs/sp/800/88/r2/final) | final 26 Sep 2025; planning note 17 Jul 2026 | media sanitization program and technique selection by sensitivity/effort | does not decide UAM retention, legal hold, backup expiry, or archive purpose |

## 15.3 Open-source sources

| Ref | Stable source and review point | Date | Claim supported | Limitation |
|---|---|---|---|---|
| **G01** | Argo Rollouts [`v1.9.1`](https://github.com/argoproj/argo-rollouts/releases/tag/v1.9.1), [repository](https://github.com/argoproj/argo-rollouts/tree/v1.9.1), [license](https://github.com/argoproj/argo-rollouts/blob/v1.9.1/LICENSE) | release notes 6 Jul 2026; GitHub release publication observed Jul 2026 | progressive rollout/analysis/pause patterns; active security maintenance; Apache-2.0 | Kubernetes-specific; not UAM runtime fitness |
| **G02** | Flagger [`v1.44.0`](https://github.com/fluxcd/flagger/releases/tag/v1.44.0), [repository](https://github.com/fluxcd/flagger/tree/v1.44.0), [license](https://github.com/fluxcd/flagger/blob/v1.44.0/LICENSE) | 21 Jul 2026 | metrics/conformance-driven progressive delivery; Apache-2.0 | Kubernetes/mesh/operator model differs |
| **G03** | Rundeck [commit `9fe4ed6fce109829e7af3e9be4e280b180adaf1a`](https://github.com/rundeck/rundeck/tree/9fe4ed6), [security policy](https://github.com/rundeck/rundeck/security/policy), [license](https://github.com/rundeck/rundeck/blob/9fe4ed6/LICENSE) | 6.0.1-20260715 review point; reviewed 1 Aug 2026 | runbook/job/history/functional-test patterns and generic-command risk | distribution/plugins/licensing/operations need separate evaluation; broad authority unsuitable for UAM core |
| **G04** | OpenBao [`v2.6.1`](https://github.com/openbao/openbao/releases/tag/v2.6.1), [repository](https://github.com/openbao/openbao/tree/v2.6.1), [license/security](https://github.com/openbao/openbao) | 22 Jul 2026 | secret leases/revocation/audit patterns; active security maintenance; MPL-2.0 | general secrets platform; no UAM selection or fitness proof |
| **G05** | osquery [`5.23.1`](https://github.com/osquery/osquery/releases/tag/5.23.1), [repository](https://github.com/osquery/osquery/tree/5.23.1), [license](https://github.com/osquery/osquery/blob/5.23.1/LICENSE) | 24 Jun 2026 | Windows inventory/monitoring table patterns and current security-fix activity | broad SQL/extension/telemetry surface; mixed licensing context; not complete proof |
| **G06** | in-toto-golang [`v0.11.0`](https://github.com/in-toto/in-toto-golang/releases/tag/v0.11.0), [repository](https://github.com/in-toto/in-toto-golang/tree/v0.11.0), [license](https://github.com/in-toto/in-toto-golang/blob/v0.11.0/LICENSE), [GHSA fix](https://github.com/in-toto/in-toto-golang/security/advisories/GHSA-pmwq-pjrm-6p5r) | 4–5 May 2026 | signed evidence/layout verification concepts; Apache-2.0; security fix review point | supply-chain/file-step model and Go toolchain differ from UAM operations/C# |
| **G07** | Gitleaks [`v8.30.1`](https://github.com/gitleaks/gitleaks/tree/v8.30.1), [license](https://github.com/gitleaks/gitleaks/blob/v8.30.1/LICENSE), [orphan-tag issue](https://github.com/gitleaks/gitleaks/issues/2086), [silent-miss issue](https://github.com/gitleaks/gitleaks/issues/2170) | issues opened 16 Apr and 14 Jun 2026 | exact reviewed version has provenance/correctness concerns; MIT | issue evidence, not a blanket judgment on all future versions; UAM positive controls decide |

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Staged ring cutover is safer than big bang | **High** | accepted same-digest release/ring principles, blast-radius containment, and current safe-deployment guidance | evidence that enterprise management cannot form stable cohorts or staged coexistence creates a greater proved risk |
| Automatic response should pause, not restore legacy | **High** | avoids acting destructively on ambiguous metrics and preserves rejected trust boundary | a formally accepted, safer automated mechanism with no credential/SQL resurrection |
| Rollback target must be an authorized new release or capability set | **High** | directly follows accepted no-endpoint-SQL, release, storage-compatibility, and identity invariants | accepted-baseline change supported by new primary evidence and full migration/security proof |
| Cutover should separate authority transfer, trust removal, and final decommission | **High** | systems are not transactionally atomic and each milestone has different evidence/rollback | a common atomic control plane that genuinely covers endpoint, SQL, PKI, network, archive, and CMDB without weakening authority |
| Exactly one ordinary authority per cohort/source epoch | **High** | central one-effect identity and clear reconciliation require it | Prompt 23 proves another bounded authority model with equivalent one-effect and restore behavior |
| Comparison-only before transfer is fit | **Medium** | narrowest way to gather evidence without changing business truth | Prompt 23 may reveal comparison requires a different safe boundary or cannot avoid privacy/duplicate effects |
| Exact ring sizes/bake periods can be selected from research | **Low / not established** | workload, support, risk tolerance, estate, time-zone, and thresholds are absent | human decisions plus measured representative ring evidence |
| Layered read-only is required | **High** | UI, API, application, DB, sessions, jobs, and network each have bypasses; primary docs support controls but not composition | a simpler architecture proving identical denial, audit, restore, and access semantics |
| A read-only copy behind the new BFF is the best first archive candidate | **Medium** | lowers legacy runtime attack surface and reuses accepted authorization/audit | human archive purpose/topology or engine/restore evidence favors original read-only DB or typed migration |
| Legacy deferred SQL must not execute in the new system | **High** | conflicts with typed endpoint/server contracts, realm authority, audit, and no-endpoint-SQL invariant | no expected ordinary change; only a proven typed transformation could process its semantics without executing text |
| Exact buffer disposition is known | **Low / blocked** | Prompt 22/23 and human retention/loss decisions are missing | complete buffer/consumer inventory, semantic reconciliation, and accountable policy decision |
| Unreachable devices should not delay fleet credential revocation indefinitely | **High** | revocation/network denial can contain old binaries while waiting creates continuing fleet risk | evidence that credentials are device-unique and revocation of reachable devices can be isolated safely, or a human risk decision |
| Login/certificate revocation must be layered with session/network controls | **High** | official SQL/PKI docs show disablement/revocation alone has active-session/distribution constraints | selected platform demonstrates stronger immediate semantics and passes adversarial tests |
| Residual monitoring requires more than one sensor and positive controls | **High** | each source has blind spots; accepted evidence rules reject scanner/tool as sole oracle | a simpler independent mechanism proves complete relevant coverage in the exact estate |
| osquery/Rundeck/OpenBao should be dependencies from this topic | **Low / not established** | each adds broad authority, operations, licensing, or platform mismatch; no measured UAM need | separate organizational requirement, full dependency/security/operations bake-off, and lower total assurance cost |
| in-toto concepts are useful for decommission evidence | **Medium-High** | content-addressed layouts/link evidence align with independent verification | UAM-owned simpler evidence model passes all mutation/operations needs without the additional concepts |
| Gitleaks v8.30.1 is suitable | **Low / rejected review point** | reported orphan-tag and silent positive-control miss; predecessor rejected it | later exact release with source/binary provenance and all mandatory UAM positive controls passing |
| The legacy inventory is complete | **Low / not established** | required Prompt 22 missing and static evidence explicitly misses dynamic/runtime consumers | accepted discovery result plus production-safe inventory/reconciliation evidence |
| Parallel-run equivalence is established | **Low / not established** | required Prompt 23 missing; semantics/fields/precision/lookback are open | accepted reconciliation result and ring evidence |
| Final archive retention/deletion can be decided technically | **Low / human-owned** | purpose, legal hold, fields, access, retention, recipient copies, and ownership require human authority | recorded accountable decisions and verified technical implementation |
| Final decommission can currently be accepted | **Low / blocked** | missing Prompts 22/23, open predecessor gates, unassigned human decisions, and no executed production evidence | every primary-gate predicate, current evidence, and multi-owner decision |

---

# Final residual risk and next stop/go gate

## What remains unsafe, uncertain, costly, or human-dependent

- **UNKNOWN:** hidden dynamic SQL, manual consumers, shared logins, external jobs, stale packages, alternate network paths, and deferred-work semantics until Prompt 22 is accepted.
- **UNKNOWN:** whether parallel comparison can reliably distinguish expected semantic changes from loss, duplication, privacy defects, source-generation changes, and cross-realm errors until Prompt 23 is accepted.
- **HUMAN DECISION:** go/no-go, rollback authority, ring membership, bake/support coverage, first-run behavior, acceptable gaps, archive purpose/owner/fields/access/retention, buffer loss/discard, exception acceptance, monitoring duration, staffing, budget, SLO/RPO/RTO, and final acceptance.
- **OPERATIONAL COST:** maintaining side-by-side new releases, disposable labs, SQL/PKI/network/endpoint/portal/archive expertise, independent verification, accessible workflows, positive controls, recurrent game days, archive restore tests, and residual monitoring.
- **SECURITY RISK:** privileged operators or a malicious authorized release can create coherent but false evidence; independent sensors/checkpoints reduce but do not eliminate collusion.
- **PRIVACY RISK:** residual/security tools can collect addresses, command lines, identities, SQL text, and rare-event metadata unless tightly configured, access-controlled, and expired.
- **DURABILITY RISK:** physical failure, unrecoverable endpoint loss, incorrect receipt failure domain, or backup gaps can still cause data loss despite correct software state machines.
- **COVERAGE RISK:** unreachable devices and source/semantic transitions can create honest unknown periods; UAM must report them rather than infer activity.
- **ARCHIVE RISK:** old backups can contain writable configuration, stale grants, credentials, deleted data, or unsupported dependencies; every restore starts blocked.
- **HUMAN WORKAROUND RISK:** incident pressure can lead to requests for legacy credentials, raw data, direct SQL, or broad firewall exceptions; the runbook must make pause/new-only recovery the normal path.

## Explicit next stop/go gate

> **STOP:** Do not compile a production R1 authority-transfer plan until `result-22-legacy-discovery.md` and `result-23-parallel-run-reconciliation.md` are present, reviewed, reconciled with this result, and their blocking evidence is accepted.
>
> **GO after that only for an R1 candidate:** all accepted predecessor gates for the exact release/platform must be current; new N/N-1 rollback, layered read-only, buffer cases, credential/session revocation, network denial, residual monitoring, archive restore, support/accessibility, game day, and cleanup must pass in an approved lab; owner decisions and coverage must be recorded.
>
> **Final decommission remains a later gate:** zero unauthorized legacy writes, dispositioned buffers and consumers, revoked credentials, blocked paths, owned history, tested new-only rollback, current contained exceptions, verified cleanup, independent evidence, and multi-owner acceptance must all be true at the same evidence revision.
