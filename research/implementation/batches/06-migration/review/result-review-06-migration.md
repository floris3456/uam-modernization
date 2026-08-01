# Batch 06 review result — legacy discovery, parallel validation, cutover, and decommissioning

**Result path:** `batches/06-migration/review/result-review-06-migration.md`  
**Review date:** 1 August 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — T1 IMPLEMENTATION PROTOTYPES AND READ-ONLY LAB EVIDENCE MAY PROCEED; ALL REAL PARALLEL-RUN, AUTHORITY-TRANSFER, TRUST-REMOVAL, AND FINAL-DECOMMISSION GATES REMAIN OPEN**  
**Authority boundary:** reconciliation of legacy discovery, evidence/traceability, parallel-run authority, comparison semantics, configuration transformation, cutover rings, rollback, legacy read-only/archive operation, credential and network removal, residual monitoring, and decommission evidence; **not** legal purpose, lawful basis, prohibited uses, employee consultation, report meaning, acceptable defects, retention, archive access, ownership, budget, licensing approval, staffing, SLO/RPO/RTO, pilot scope, production risk acceptance, or deployment approval  
**Primary batch gate:** **Named accountable owners MUST approve every consumer and configuration disposition, every reconciliation result, the rollback boundary, every credential or certificate removal, and the final decommission action. No technical pass substitutes for those approvals.**

## Evidence vocabulary

This review uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, observation, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed consolidated Batch 06 implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 0. Evidence boundary, file-presence record, and review method

## 0.1 Allowlisted supplied evidence

**FACT.** All eleven allowlisted Project files were present. The three topic files were supplied locally with a `(1)` suffix and Batch 01 with a `(3)` suffix; their titles and declared result paths identify the allowlisted logical filenames. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Role and limitation |
|---|---|---|---|---|
| I01 | `result-22-legacy-discovery.md` | `22-legacy-discovery-result(1).md` | `d96c2ad36f2c45228caf18aa95f0f01d2b626c60dd72c2136d282cba20df07f7` | Read-only discovery lane, evidence graph, coverage, disposition, consumer/credential/buffer inventory, and removal proof. Proposed architecture and tests; no estate inventory has run. |
| I02 | `result-23-parallel-run-reconciliation.md` | `23-parallel-run-reconciliation-result(1).md` | `de32b260938206a0a2a0dc61bae4b3974d0bb0b7aa5213a0f93a4a273b5c4152` | One-authority/shadow model, comparison contracts, digests, mismatches, tolerances, compatibility projection, configuration transform, cutover fence, and rollback model. Proposed architecture; real report semantics and pilot evidence remain absent. |
| I03 | `result-24-cutover-decommission.md` | `24-cutover-decommission-result(1).md` | `9ad389aed0ccb6035bfcc41e9612821825effb1b1fbbd8e64994bc8e68f0f06b` | Rings, authority transfer, rollback, read-only/archive, credentials, network, buffers, residual monitoring, cleanup, and final acceptance. Proposed implementation design; no production action is authorized. |
| I04 | `result-review-01-foundations.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, fictional-first evidence, identity, privacy ceiling, repository/release boundaries, and Windows topology. |
| I05 | `result-review-02-endpoint-data.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted source continuity, native identity, whole-page progress, and pre-IPC minimization. |
| I06 | `result-review-03-durability-release-identity.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted endpoint durability, immutable release/rollback, installation identity, diagnostics, and exact-tuple compatibility. |
| I07 | `result-review-04-server-platform.md` | `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted relational custody, one-effect identity, typed facts, lifecycle barriers, authoritative receipts, and restore readiness. |
| I08 | `result-review-05-portal-governance.md` | same | `38dc40cc0e07b560da4bcf477d3a0c20e01e2d2aba430e3187eddf21742bed99` | Accepted capability authorization, explicit commands, same-transaction audit, independent verification, accessibility, and restore authority. |
| I09 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Shared accepted baseline and non-negotiable invariants; not runtime evidence or production approval. |
| I10 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted proof order, no-broker default, database posture, and stop rule. |
| I11 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, source quality, human-authority boundaries, and conflict discipline. |

## 0.2 File-presence correction

**FACT.** I02 says I01 was missing when Prompt 23 was written. I03 says I01 and I02 were missing when Prompt 24 was written. Those statements accurately describe the topic chats' evidence boundaries, but they are stale for this Batch 06 review because all three same-stream files are now present and hashed above.

**RECOMMENDATION.** Replace the topic-level “missing file” blockers with two different current states:

1. **Input-presence gate: PASS.** The exact required files are present and reconciled.
2. **Executed-evidence gates: OPEN.** The supplied topic results define architectures and experiments; they do not contain a completed estate inventory, accepted report semantics, a successful real reconciliation, or a cutover/decommission drill for a production topology.

No conclusion from I02 or I03 that depended only on the absence of I01/I02 is carried forward as a current blocker. Conclusions that depend on unexecuted runtime evidence remain blocked for that reason.

## 0.3 Conflict-resolution method

Conflicts were resolved in this order:

1. preserve I04–I10 accepted predecessor decisions and non-negotiable invariants;
2. prefer narrower authority, smaller privacy/security surface, fail-closed behavior, and reversible observation before destructive action;
3. separate business authority from comparison state, cutover orchestration, and deployment ring state;
4. distinguish documented platform capability from UAM-specific fitness;
5. distinguish static presence, runtime observation, owner assertion, and approved disposition;
6. require one canonical source of truth for each state rather than overlapping ledgers with similar names;
7. preserve exact point-in-time versions and numeric values as evidence inputs, not timeless architecture;
8. turn unresolved technical fitness into the smallest falsifying **CLI EXPERIMENT**;
9. leave legal, privacy, ownership, retention, support, budget, and production decisions as **HUMAN DECISION**;
10. open an accepted-baseline change proposal only if a conclusion would actually replace a predecessor invariant.

**FACT.** No accepted-baseline change proposal is required by this review. The most material topic conflicts are resolved by separating state machines and by making legacy rollback explicitly phase-bounded. Any future proposal to restore endpoint SQL/database credentials, execute deferred SQL, permit endpoint dual-write, or recreate a revoked legacy credential would require the formal baseline-change process.

## 0.4 Current primary-source verification scope

Web verification was limited to load-bearing, disputed, or time-sensitive claims rather than repeating the topic research. Primary sources reviewed as of 1 August 2026 include:

- Microsoft SQL Server documentation for `ALTER LOGIN`, `KILL`, `DROP LOGIN`, database `READ_ONLY`, Query Store, Extended Events, sessions, Scheduled Tasks, and services;
- Microsoft safe-deployment guidance, including progressive exposure, bake time, halt-on-health-failure, disable-before-delete, and decommission watch windows;
- Microsoft AD CS decommission guidance, used only conditionally if a dedicated Windows enterprise CA is actually in scope;
- RFC 8785 for JSON canonicalization, RFC 4231 for HMAC-SHA-256 test vectors, and RFC 9162 for domain-separated Merkle-tree construction concepts;
- IANA time-zone database release records where a pinned time profile is needed;
- official immutable repository tags/releases, licenses, security policies, test trees, and advisories for the open-source references discussed in I01–I03.

Vendor marketing, popularity, stars, download counts, and generic benchmark claims are not treated as UAM proof.

## 0.5 Consolidated assumptions and smallest falsifiers

| ID | Classification | Assumption | Smallest falsifier and consequence |
|---|---|---|---|
| AS06-01 | **ASSUMPTION** | An authoritative or reconcilable population source exists for endpoints, servers, databases, portal/runtime components, credentials, reports, exports, and consumers. | Two population sources disagree without an owner or reconciler; coverage remains `UNKNOWN` and retirement stops. |
| AS06-02 | **ASSUMPTION** | Legacy artifacts can be inspected through fixed read-only adapters without executing script or SQL text. | A required behavior is visible only through side-effecting execution; quarantine that behavior and create a separately authorized synthetic characterization plan. |
| AS06-03 | **ASSUMPTION** | Legacy and new systems can use destination-specific binaries, credentials, and network routes. | One endpoint artifact can reach both ordinary destinations; stop because endpoint dual-write is structurally possible. |
| AS06-04 | **ASSUMPTION** | New shadow facts can be isolated from ordinary reports, integrations, exports, lifecycle actions, and portal search. | A lineage/query/mutation test shows shadow data can reach an ordinary consumer; no real parallel run. |
| AS06-05 | **ASSUMPTION** | At least one exact common source range or proved quiesced boundary can fence cutover. | No native/common fence exists and quiescence cannot prove gap/overlap; authority transfer remains blocked. |
| AS06-06 | **ASSUMPTION** | A rollback window can be closed before legacy trust removal and can be represented explicitly. | Operations require indefinite legacy rollback or credential recreation; open a baseline change proposal or keep trust removal blocked. |
| AS06-07 | **ASSUMPTION** | Writer and historical-reader authority can be separated. | One credential or runtime is indispensable for both writes and approved reads; replace/split it before revocation or keep the archive gate closed. |
| AS06-08 | **ASSUMPTION** | Existing runtime evidence and bounded residual sensors have known capture, retention, clock, and reset properties. | A positive control is missed or capture configuration is unknown; non-observation cannot support retirement. |
| AS06-09 | **ASSUMPTION** | Enterprise deployment can stage, pause, rollback, disable, uninstall, and inventory the exact cohort. | One cohort cannot reliably report or apply the required state; remove it from scope or qualify a different management profile. |
| AS06-10 | **ASSUMPTION** | New release N and an authorized N-1 remain contract/storage compatible for the declared rollback window. | N-1 cannot open or safely operate the current store/contracts; ring entry stops. |
| AS06-11 | **ASSUMPTION** | Historical access can be separated from mutation authority and exposed through the accepted BFF/audit model. | A required historical workflow needs direct writes or a generic query path; design a typed workflow or keep history read-blocked. |
| AS06-12 | **ASSUMPTION** | Named owners can review minimized evidence without receiving raw activity, credentials, or executable text. | A decision cannot be made from the approved minimum evidence; use an independently authorized local review ceremony rather than broadening ordinary evidence. |

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The three topic results agree strongly enough to accept the following Batch 06 architecture at implementation-prototype level:

1. **Discovery:** one signed, one-shot C#/.NET discovery CLI with fixed read-only adapters, exact scope authority, no general script/SQL/path/plugin channel, and a sanitized content-addressed evidence graph.
2. **Traceability:** every legacy behavior, consumer, credential, configuration, buffer, report, integration, and archive dependency must have evidence, owner state, disposition, replacement requirement, validation, rollback, and removal proof. A spreadsheet may be a view, not the canonical truth.
3. **Parallel validation:** exactly one business-authoritative path exists for each realm/cohort/semantic surface/authority epoch. The other path is an isolated shadow observation path with no ordinary business egress.
4. **No endpoint dual-write:** the new endpoint never receives legacy database credentials or a legacy destination, and the legacy endpoint never receives the new ingestion credential or protocol.
5. **Server-side comparison:** comparison occurs after minimization through bounded read-only legacy extraction, isolated new shadow facts, deterministic compatibility projection, exact range/window evidence, finite mismatch classes, and privacy-safe digests.
6. **Exact versus tolerant semantics:** realm, privacy, authority, one-effect identity, progress, range closure, contract/version, and shadow isolation are zero-tolerance. A semantic tolerance or known defect exists only as an immutable, scoped, owner-approved, expiring record.
7. **No shadow promotion:** pre-cutover shadow observations remain shadow evidence. Cutover creates a new higher authority epoch and a proved source boundary; it never re-labels shadow history as ordinary facts.
8. **Staged cutover:** use progressive rings, immutable cohort manifests, same-digest promotion, complete monitoring, explicit bake/coverage requirements, automatic pause on hard safety failure, and human promotion.
9. **Three milestones:** authority transfer, legacy trust removal, and final decommission are distinct. They have different rollback, evidence, and owner requirements and must not be represented as one fictitious cross-system transaction.
10. **Phase-bounded rollback:** before an explicit rollback expiry and before legacy trust is revoked, a pre-authorized return to the still-intact legacy authority may be possible only through a new higher authority epoch and a proved fence. After trust removal, rollback means pause, feature disablement, or a known-good new-system release; legacy credential resurrection is prohibited.
11. **Layered read-only/archive:** portal, API, application identity, database permissions/state, active sessions, jobs/integrations, network paths, restore behavior, audit, and monitoring must all agree. A UI label or database `READ_ONLY` setting alone is insufficient.
12. **Explicit trust removal:** disable/revoke credentials, terminate active sessions, remove permissions/ownership and secret copies, block alternate network paths, monitor failed use, and prove cleanup. Uninstall alone and login disablement alone are not security boundaries.
13. **Explicit buffer disposition:** legacy executable SQL/CSV is never executed by the target. Each buffer is drained under the still-authoritative legacy path before the fence, transformed into typed events after semantic proof, quarantined, or discarded only by an accountable human decision.
14. **Residual exceptions:** unreachable devices, unknown consumers, archive dependencies, and late findings are bounded, contained, owner-assigned, expiring exceptions. They cannot authorize legacy writes or auto-renew.
15. **Independent final acceptance:** final decommission is recomputed from immutable evidence by an evaluator that cannot mutate the source state and then decided by the required owner quorum. A checklist, email, or self-asserted completion is insufficient.

**FACT.** I01–I03 contain designs, contracts, experiment plans, and evidence rules, not completed production inventory, accepted report semantics, passed reconciliation, or executed cutover/decommission evidence.

**Therefore:**

> **Batch 06 may proceed with strict contracts, pure state machines, T1 fixtures/oracles, read-only discovery tooling, an isolated shadow/comparator prototype, cutover simulation, disposable Windows/SQL lab actions, evidence verification, accessible review tooling, and game-day preparation. The aggregate Batch 06 gate remains OPEN. No real parallel run, authority transfer, legacy trust removal, archive activation, final deletion, pilot, or production deployment is authorized.**

## 1.2 Consolidated gate status

| Gate | Current status | Required closure evidence | Non-waivable stop condition |
|---|---|---|---|
| **B06-INPUT — exact evidence presence** | **PASS** | The eleven allowlisted files and hashes in section 0.1. | Any unallowlisted substitution or unresolved file identity. |
| **B06-CONTRACT — strict migration contracts and state separation** | **OPEN — CLI EXPERIMENT** | Closed schemas, old/new vectors, state-machine model checks, realm-negative tests, architecture dependency tests. | Unknown authority field accepted; two business authorities representable; state decrease or cross-realm relation succeeds. |
| **B06-DISCOVERY-SAFETY — one-shot read-only lane** | **OPEN — CLI EXPERIMENT** | No-mutation proof, fixed query/parser verification, scope enforcement, canaries, bounded resources, cleanup. | Script/SQL execution, profile/drive crawl, source mutation, secret/raw escape, arbitrary command/query/path, cleanup residue. |
| **B06-DISCOVERY-COVERAGE — population and consumer evidence** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Reconciled population, static/runtime/config/interview facets, observation coverage, unreachable accounting, owner reconciliation. | Unknown material writer/consumer/path, unsupported absence claim, unowned high-risk item, contradictory evidence unresolved. |
| **B06-DISPOSITION — owner-bound migration/removal graph** | **OPEN — HUMAN DECISION + CLI validation** | Every material item has approved preserve/change/retire/investigate disposition, target contract/test, rollback, removal proof. | Any item is migrated or removed without named owner, disposition, validation, or rollback. |
| **B06-SHADOW — no dual-write and no business egress** | **OPEN — CLI EXPERIMENT** | Binary/package/credential/network graph, namespace lineage tests, query/mutation tests, realm negatives. | Endpoint can reach both destinations; shadow reaches ordinary projection, export, integration, lifecycle, or portal. |
| **B06-RECONCILIATION — exact ranges, semantics, and mismatches** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Closed ranges/windows, canonical/digest vectors, exact invariants, approved report semantics, owned defects/tolerances, no unknown material mismatch. | Loss, duplication, realm/privacy/authority error, open window, unowned/expired tolerance, unknown material mismatch. |
| **B06-CONFIG — configuration transformation** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Immutable source snapshot, typed intermediate model, loss/ambiguity manifest, no-broadening proof, approved activation candidate, rollback. | Prohibited or ambiguous item silently activates; target broadens product ceiling; owner absent. |
| **B06-FENCE — authority-transfer and rollback boundaries** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Exact legacy quiesce, final old range, new boundary, no gap/overlap, higher epochs, pre-trust rollback drill, rollback expiry. | Two ordinary writers, ambiguous fence, missing/duplicate effect, lower epoch, unsafe rollback, expired evidence. |
| **B06-RING — progressive cutover readiness** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Immutable cohort/release/config/monitor manifests, complete health model, support/on-call, required coverage, game day, current rollback target. | Hard safety signal, monitor blind/stale, unsupported tuple, changed digest, missing support, unassigned promotion authority. |
| **B06-READONLY-ARCHIVE — historical access without mutation** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Layered write denial, active-session termination, audited least-detail reads, restore read-block, archive owner/purpose/fields/retention. | One unauthorized write, unowned history, unaudited sensitive read, restored mutation path, undefined retention/access. |
| **B06-TRUST-REMOVAL — credentials, secrets, sessions, and network** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Complete ownership/consumer map; disable/revoke/rotate; session termination; permission/ownership cleanup; secret/deployment removal; path denial; failed-use monitoring. | Valid credential remains, active session remains, alternate path succeeds, secret remains in an active package/config, shared consumer unresolved. |
| **B06-BUFFER — deferred-work disposition** | **OPEN, OWNER-BLOCKED** | Value-free inventory/digests, creation freeze, typed disposition, drain/transform/quarantine/discard evidence, unreachable policy. | Raw SQL executes, unacknowledged data silently drops, owner absent, post-fence legacy drain, ambiguous transform. |
| **B06-RESIDUAL — post-removal observation and exceptions** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Multiple independent sensors with positive controls, zero successful writes, classified failed attempts, expiring contained exceptions, inventory reconciliation. | Successful residual write, unknown recurring attempt, expired exception, monitoring blind interval, component silently reappears. |
| **B06-DECOM — final decommission acceptance** | **BLOCKED** | Every applicable gate above passes; exact owner approvals; current game day; archive/lifecycle decisions; independent acceptance record; cleanup. | Any primary predicate false, owner absent, unresolved exception, stale evidence, baseline conflict, or residue. |

## 1.3 Immediate permission

**RECOMMENDATION — GO now** for:

- migration contract catalogue, strict schemas, enums, canonical vectors, and architecture tests;
- pure discovery, evidence-graph, coverage, disposition, authority, comparison, cutover, credential, buffer, archive, exception, and acceptance state machines;
- deterministic T1 fictional estate, consumers, reports, configurations, credentials, buffers, ranges, mismatches, failures, and owner-decision fixtures;
- a one-shot read-only discovery CLI against T1/disconnected fixtures;
- PowerShell and T-SQL static parser prototypes that never execute input;
- an isolated shadow namespace and no-business-egress tests;
- a deterministic compatibility projector and comparator using fictional data;
- canonicalization, HMAC, multiset-root, range/window, mismatch, tolerance, and known-defect prototypes;
- cutover/fence/rollback simulation and an independent gate evaluator;
- disposable Windows/SQL lab experiments for task/service disablement, login/session handling, database read-only, network denial, cleanup, and restore;
- evidence packaging, positive-control canaries, support/game-day runbooks, and accessible review screens;
- no-op or T1 fake adapters for enterprise deployment, PKI, network, archive, SIEM, CMDB, and ticketing boundaries.

## 1.4 Immediate prohibition

**RECOMMENDATION — STOP** before:

- production or employee-data discovery without exact inspection authority, fields, access, retention, resource limits, and support ownership;
- executing a legacy script, report, stored procedure with side effects, deferred SQL statement, PSU action, or caller-supplied command/query/path;
- enabling Query Store, Extended Events, SQL Audit, endpoint sensors, or another instrumentation source under the label “read-only discovery”;
- any endpoint artifact, credential, route, or batch that can write both legacy and new ordinary destinations;
- allowing legacy and new systems to create ordinary effects for the same scope/epoch;
- allowing shadow facts into ordinary reports, exports, integrations, deletion/lifecycle work, or portal views;
- a real parallel run without an approved purpose, cohort, duplicate-storage/access/retention profile, and incident/support coverage;
- an exact-equivalence claim without approved report/configuration semantics and closed comparison ranges;
- generic percentage tolerances, wildcard defects, unknown-as-tolerated, or sample-only sign-off;
- cutover without a proved common fence, rollback boundary, current N/N-1 compatibility, complete monitors, and named authority;
- automatic credential recreation or automatic return to the legacy trust model after a metric failure;
- retaining dormant reusable legacy endpoint database credentials as a decommissioned rollback mechanism;
- importing or executing deferred SQL/CSV as code in the target;
- UI-only read-only mode, login-disable-only trust removal, certificate-revocation-only trust removal, uninstall-only trust removal, or one-sensor residual assurance;
- historical archive access without owner, purpose, minimum fields, access, audit, retention, restore, and deletion responsibilities;
- final deletion of legacy runtime, data, backups, keys, or evidence before approved lifecycle and restore decisions;
- production cutover, final decommission, pilot, or production acceptance.

## 1.5 Executive residual risk

The accepted design contains rather than eliminates risk:

- static and bounded runtime discovery can miss dynamic SQL, manual queries, dormant reports, seasonal workflows, copied spreadsheets, external recipients, or systems outside the population;
- unreachable devices can retain software, buffers, and old configuration even after central trust is removed;
- legacy report formulas, time-zone rules, null/default behavior, known defects, and configuration precedence can remain misunderstood;
- a shared credential, long-lived session, alternative listener, proxy/VPN route, package repair source, failover address, or backup copy can preserve hidden write authority;
- revocation and deny telemetry can be stale, misconfigured, or blind, and local/DB/PKI administrators can hide evidence;
- canonicalization and digest implementations can share a defect or leak linkability if keys or profiles are wrong;
- progressive rollout can still expose rare compatibility, business-cycle, or support failures after a ring passes;
- fail-closed pause, read-block, or revocation can create coverage gaps, backlog, archive outage, and business disruption;
- historical archives and evidence packs remain sensitive even when minimized and content-addressed;
- colluding or compromised owners, release signers, database administrators, network administrators, evidence evaluators, or risk approvers can produce coherent but false acceptance;
- final technical decommission cannot prove deletion of an unmanaged human copy or recipient-controlled data.

Containment is narrow scope, independent evidence classes, strict state separation, one authority, no endpoint dual-write, immutable ranges and digests, automatic pause, explicit rollback expiry, layered trust removal, expiring exceptions, independent recomputation, multi-owner approval, and truthful limitations.

## 1.6 Confidence summary

| Major conclusion | Confidence | Why | Evidence that could change it |
|---|---|---|---|
| One-shot fixed read-only discovery is the correct first lane | **High** | It directly preserves no-script/no-SQL/no-profile-crawl boundaries and minimizes permanent authority. | A smaller alternative passing the same no-execution, privacy, realm, mutation, cleanup, and coverage gates. |
| Evidence graph plus owner-bound disposition is necessary | **High** | Static, runtime, human, and removal evidence have different limits; hidden dependencies require traceable stop conditions. | A simpler governed system proving equivalent lineage, immutability, owner, validation, rollback, and removal completeness. |
| Exactly one business-authoritative path is mandatory | **High** | It follows accepted one-effect, realm, receipt, and audit invariants. | Only a formal baseline change with a complete dual-authority protocol and smaller falsifying prototype. |
| Endpoint dual-write must be structurally impossible | **High** | It would reintroduce legacy SQL credentials and ambiguous two-destination commit/retry semantics. | Formal baseline change evidence showing it is necessary and safer; none is expected. |
| Server-side minimized comparison with isolated shadow state is the right first design | **High** | It permits validation without broadening endpoint authority or ordinary business truth. | A required semantic cannot be compared after minimization and a narrower alternative passes privacy/authority proof. |
| JCS + per-run HMAC + counted Merkle multiset is fit to prototype | **Medium** | Standards provide deterministic building blocks; UAM canonicalization, key handling, cost, and localization remain unproved. | Counterexample, resource failure, linkability issue, or a simpler exact method. |
| Progressive rings and explicit bake/coverage are appropriate | **High** | Primary guidance and engineering logic support progressive exposure, halt on health failures, and disable-before-delete. | A topology where staged coexistence is demonstrably more dangerous than a bounded alternative. |
| Legacy rollback should expire before trust removal | **High** | This reconciles safe pre-removal recovery with the accepted no-legacy-trust target. | An operational requirement for indefinite legacy rollback would require a baseline change or block decommission. |
| Read-only copy behind the new BFF is the preferred archive candidate | **Medium** | It separates history from legacy runtime and composes with accepted authorization/audit controls. | Restore, fidelity, cost, lifecycle, or required workflow evidence favors another approved topology. |
| Credential/session/permission/network cleanup must be layered | **High** | Official platform behavior and independent control gaps show no single control is sufficient. | A selected platform intrinsically and verifiably collapses those controls without losing evidence. |
| Complete legacy inventory and report equivalence are currently known | **Low / not established** | No approved estate discovery run or report-contract approval is supplied. | Executed inventory, consumer reconciliation, accepted semantics, representative fixtures, and owner decisions. |
| Final decommission is currently ready | **Low / not established** | Every operational, human, archive, trust-removal, residual, and acceptance gate remains open. | Current exact evidence passing B06-DECOM plus separate production/risk approval. |

---

# 2. Accepted decisions and invariants

## 2.1 Accepted predecessor invariants carried forward without change

The following are **FACT** from I04–I10 and remain non-negotiable:

| ID | Accepted invariant |
|---|---|
| A06-01 | Windows endpoints use a low-privilege machine Coordinator, one ordinary-token User Host per eligible interactive session, and short-lived fixed Task Hosts. |
| A06-02 | The Coordinator does not crawl or load user profiles, create user tokens, or read user-owned sources. |
| A06-03 | Task Hosts are fixed release-authorized capabilities, not script, plugin, assembly, path, SQL, command, or arbitrary-code channels. |
| A06-04 | A release-authorized product privacy ceiling limits sources, fields, transformations, destinations, diagnostics, and capabilities; tenant policy only narrows it. |
| A06-05 | Minimization occurs before Coordinator IPC, endpoint durability, logs, diagnostics, transport, portal disclosure, exports, and ordinary evidence. |
| A06-06 | Endpoints never receive central database credentials or submit SQL. |
| A06-07 | Endpoint SQLite WAL with one writer atomically stores minimized effects and source progress; a cursor never advances ahead of its durable effects or approved no-event facts. |
| A06-08 | Delivery is at least once; stable event/batch identities and central uniqueness produce one final ordinary business effect. |
| A06-09 | A receipt means durable custody in its declared failure domain, not semantic acceptance, materialization, integration, visibility, or historical access. |
| A06-10 | The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control BFF, and governed integrations. |
| A06-11 | No external broker is the default; measured failure-domain, throughput, replay, fan-out, recovery, or cost evidence is required. |
| A06-12 | PostgreSQL is the reference candidate and SQL Server remains a serious transition/fallback candidate; production selection is open. |
| A06-13 | MSI and enterprise deployment own the stable privileged boundary; any autonomous updater is optional, separately justified, and rollback-safe. |
| A06-14 | An unauthorized, incomplete, stale, frozen, mixed, or downgraded release never executes. |
| A06-15 | Realm, installation, user, session, and product-global authority comes from authenticated context, never payload, browser, header, name, path, or network claims. |
| A06-16 | One user, session, installation, or realm cannot submit, view, mutate, export, delete, restore, audit, or execute as another. |
| A06-17 | A privileged mutation cannot succeed without durable same-transaction authorization/audit evidence. |
| A06-18 | No component silently drops unacknowledged data under pressure. |
| A06-19 | Restores neither lose acknowledged events nor make deleted data, stale authority, or ordinary egress visible before readiness. |
| A06-20 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| A06-21 | A failed earlier proof gate stops dependent work; passing proves only the exact release, environment, profile, workload, and failure tested. |
| A06-22 | Legal purpose, prohibited uses, identity level, retention, access, employee consultation, ownership, budget, staffing, SLO/RPO/RTO, support, pilot, and production approval remain human decisions. |

## 2.2 Legacy discovery baseline

**RECOMMENDATION — ACCEPT.**

1. `Uam.LegacyDiscovery` is a signed one-shot C#/.NET CLI, not a permanent fleet agent by default.
2. It consumes an immutable approved scope reference and supports only release-owned adapter/query IDs. There is no `--sql`, `--script`, `--command`, `--url`, `--host`, `--credential`, arbitrary path, or plugin argument.
3. Endpoint machine inspection reads exact approved service, task, package, registry, file, settings, checkpoint, buffer, and network metadata. It does not use broad profile/drive crawling and does not use side-effect-prone inventory mechanisms as a shortcut.
4. Any user-owned legacy location is read, if approved, by a short-lived ordinary-token session helper in that user session. The machine process does not manufacture a token or inspect another session.
5. SQL discovery uses fixed bounded read-only metadata and existing-runtime-evidence queries under least privilege. It does not execute discovered SQL, invoke side-effecting stored procedures, enable telemetry, or retrieve secret values.
6. PowerShell, T-SQL, XML, JSON, YAML, CSV, report definitions, and PSU configuration are parsed as hostile data. Parsers never import, dot-source, invoke, compile, schedule, render, or execute the content.
7. Secret and buffer classifiers record presence, storage/principal/scope classes, counts, age/size buckets, digests, owner state, and incident flags without copying password/token/private-key/connection-string/raw SQL/activity values into the shareable pack.
8. Publication is allowlist construction into strict JSON/NDJSON, not broad-object redaction. A forbidden-value or secret canary aborts publication.
9. Canonical discovery truth is a content-addressed evidence graph with immutable observations and typed edges. A spreadsheet or dashboard is a projection.
10. Every absence statement is bounded, such as `NOT_OBSERVED_IN_SCOPE`, and records population, time, capture, access, clock, and unreachable limitations. Universal absence is not claimed.
11. Presence is not approval. Every material item receives one disposition: `PRESERVE_APPROVED_OUTCOME`, `DELIBERATELY_CHANGE`, `RETIRE`, or `INVESTIGATE_QUARANTINE`.
12. Migration/removal requires a complete trace from evidence to owner, purpose/criticality decision, target requirement/contract, validation, migration step, rollback step, and removal proof.
13. Existing Query Store, Extended Events, SQL Audit, Agent history, PSU history, or logs may be read only when already enabled and approved. Enabling or changing capture is a separate mutating change with its own ADR, fields, load, retention, access, cleanup, and owner.
14. Reversible disablement and observation precede destructive removal wherever technically possible. Post-removal discovery and residual monitoring are required.

## 2.3 Parallel validation and comparison baseline

**RECOMMENDATION — ACCEPT.**

1. Parallel validation is **dual observation**, not endpoint dual-write and not dual business authority.
2. For every `(realm_id, cohort_id, semantic_surface_id, authority_epoch_sequence)`, exactly one of `LEGACY_AUTHORITY`, `FROZEN_NO_AUTHORITY`, or `NEW_AUTHORITY` exists.
3. A new-system shadow path may accept minimized facts into an isolated namespace while legacy remains authoritative. It has no ordinary business egress.
4. The endpoint does not fan out one source record, event, batch, SQL statement, or retry to both systems. Legacy and new artifacts have destination-specific binaries, credentials, and allowlists.
5. Comparison occurs server-side through a fixed read-only legacy adapter, a new shadow adapter, and where needed a deterministic compatibility projection from canonical new facts.
6. The compatibility projector is derived, read-only, versioned, deterministic, provenance-preserving, and disposable. It does not mutate canonical facts or write the live legacy database.
7. Comparisons bind exact contracts, profile revisions, source ranges/windows, closure evidence, time profile, configuration/reference revisions, canonicalization, key profile, and software digests.
8. Exact comparison uses counted multiplicities. XOR, sum-only, average, sample-only, or order-dependent concatenation is not sufficient proof of multiset equality.
9. Exact invariants have no tolerance: endpoint dual-write, authority uniqueness, realm, privacy canaries, source range closure, checkpoint ordering, stable identity, one effect, retry conflict, contract/version binding, shadow isolation, and evidence integrity.
10. A tolerance is a narrowly scoped semantic relation with direction, fields, range/version, owner, approval, evidence, test, review, and expiry. It does not suppress an exact invariant or unknown mismatch.
11. A known defect is a proven bounded classification record. It does not authorize copying the defect into ordinary target behavior and cannot match realm, privacy, dual-write, authority, durability, receipt, audit, or restore failures.
12. Unknown classification is material and blocking by default.
13. Pre-cutover shadow history never becomes ordinary history. The cutover boundary determines when new facts become business-authoritative.
14. Configuration migration begins from an immutable legacy snapshot, parses to a typed intermediate model, emits a target candidate plus loss/ambiguity manifest, proves no privacy/product-ceiling broadening, and waits for human approval. It never executes configuration as code.
15. Historical legacy data stays in an approved read-only archive by default. Any named import has explicit purpose, typed mapping, provenance, reconciliation, lifecycle, and `LEGACY_IMPORT` origin; it is not silently merged with native new facts.

## 2.4 Business authority, cutover orchestration, and ring separation

**RECOMMENDATION — ACCEPT THE SEPARATION.** Topic-local names are corrected as follows:

1. `AuthorityEpochV1` is the sole business-authority state. It contains only `LEGACY_AUTHORITY`, `FROZEN_NO_AUTHORITY`, or `NEW_AUTHORITY` and a monotonic sequence.
2. `CutoverCohortStateV1` is an operational workflow state. It references the current authority epoch but does not redefine authority.
3. `ComparisonRunStateV1` is a validation workflow state. `SHADOW_READY`, `COMPARING`, or `RECONCILED` never means business authority.
4. Deployment exposure uses a separate `CUT-C0` through `CUT-C5` ring namespace. Discovery maturity uses `DISC-D*`; validation maturity uses `VAL-V*`. This avoids the three topic results' conflicting `R0`, `R1`, and similar labels.
5. Authority transition is not claimed atomic across endpoint management, SQL Server, firewalls, PKI, archive, CMDB, and portal. The system uses idempotent prepare/observe/commit/reconcile commands with evidence at each boundary.
6. A cutover plan freezes exact cohort, release digest, contract/schema/storage compatibility, privacy ceiling, comparison profile, monitors, rollback target, owner set, and evidence references.
7. Promotion uses the same signed digest and configuration. A changed digest or materially changed configuration starts a new bake/evidence generation.
8. Required monitors must be current and positive-control-proven. Time while a required monitor is stale or unavailable does not count toward bake.
9. Any hard safety signal automatically pauses the affected ring and dependent promotion. Pause does not recreate credentials, delete buffers, advance cursors, or claim rollback.
10. Human promotion is the conservative default. No metric alone authorizes destructive action, credential recreation, or final decommission.

## 2.5 Phase-bounded rollback baseline

**RECOMMENDATION — ACCEPT WITH EXPLICIT PHASE RULES.**

1. The smallest safe response order is: disable one new capability; pause new collection/upload while preserving durable data; select an already-authorized new N-1 under a higher release sequence; roll forward with a corrected new release; hold safely if none is available.
2. Before the plan's `legacyRollbackExpiresAtUtc`, before `LEGACY_TRUST_REVOKED`, and only while all exact legacy binaries/configurations/credentials/paths remain intentionally intact, a human-authorized rollback to legacy MAY occur through:
   - `NEW_AUTHORITY(n)` → `FROZEN_NO_AUTHORITY(n+1)`;
   - close and verify the new range;
   - prove the legacy restart boundary with no unproved gap or overlap;
   - `LEGACY_AUTHORITY(n+2)`;
   - record owner approval, command/audit, and rollback evidence.
3. That pre-trust rollback cannot mint a replacement credential, lower an epoch/release sequence, execute deferred SQL blindly, or make both paths authoritative.
4. When the rollback expiry passes, or trust removal begins, the legacy rollback option closes. The state and evidence must say so explicitly.
5. After writer credentials/certificates are revoked, active sessions terminated, secret copies removed/rotated, or network write paths denied, there is no supported rollback to the legacy endpoint-to-database design.
6. Recreating that trust requires a formal accepted-baseline change proposal with new evidence, security/privacy impact, migration consequence, and smallest falsifying experiment. It is not an emergency convenience.
7. Rollback preserves stable event/batch identity, source checkpoints, endpoint buffers, receipts, realm binding, audit, tombstones, archive state, and evidence. It does not rewind clocks or mutate closed comparison evidence.

## 2.6 Legacy read-only and archive baseline

**RECOMMENDATION — ACCEPT THE MECHANISM, KEEP TOPOLOGY AND POLICY OPEN.**

A historical surface is `VERIFIED_READ_ONLY` only when all applicable layers pass:

1. mutation controls and routes are absent, not merely hidden;
2. application write handlers, jobs, schedules, and compatibility writers are disabled;
3. the runtime identity has only approved read authority;
4. database write permissions/roles are removed or denied;
5. where operationally fit, the archive database/copy is placed in `READ_ONLY` state as defense in depth;
6. sessions created under former writer identities are terminated;
7. write-capable network paths are denied while approved archive/BFF/admin paths remain;
8. jobs, ETL, reports, manual integrations, and failover listeners are dispositioned;
9. write probes through UI, API, application, database identity, jobs, and restore are rejected and recorded;
10. sensitive historical reads and exports use accepted purpose, field, realm, and audit-before-disclose controls;
11. restored history starts read-blocked and cannot revive stale write or ordinary receipt authority;
12. an immutable verification record binds the exact application, principal, database, job, route, network, restore, and test evidence without exposing raw names or addresses in the shareable pack.

**RECOMMENDATION.** A read-only copy served through the new BFF is the preferred first archive candidate because it separates historical access from the original broad legacy runtime. The original legacy database in `READ_ONLY` mode is an interim candidate; a typed historical import is a separate long-term option. Static file exports and indefinite retention of the original legacy portal are rejected as defaults.

## 2.7 Credential, certificate, session, secret, and network baseline

**RECOMMENDATION — ACCEPT.**

1. Every credential/certificate/secret has an owner, purpose, issuer/store, consumers, scope, active-session behavior, renewal/rotation/recovery path, deployment copies, backup copies, and removal evidence.
2. Disable/revoke is not sufficient by itself. Existing sessions are identified and terminated; permissions, role memberships, ownership, jobs, mapped users, and impersonation paths are cleaned up or explicitly retained for an approved reader.
3. Shared credentials are split or all remaining approved consumers migrate before writer trust is revoked. A shared dependency blocks removal.
4. Reusable fleet secrets are rotated out of deployment packages, task arguments, configuration stores, scripts, workbooks, support systems, source/build artifacts, and approved backup scopes.
5. Network denial is verified at active policy and server boundaries, not only by reading a local rule. Alternate ports, listeners, DNS aliases, proxies, VPNs, NAT, failover endpoints, and management subnets are tested.
6. Failed authentication and denied network attempts are monitored through bounded privacy-safe records with positive controls. A failed attempt is evidence of residue, not authorization to re-enable trust.
7. Certificate revocation is one layer. Application credential status and network denial remain independent controls. Exact PKI handling depends on the selected enterprise PKI.
8. Microsoft AD CS CA-decommission procedures apply only if discovery proves that a dedicated enterprise CA is actually being retired. Batch 06 does not assume an AD CS topology or authorize CA decommission.
9. Credential state is monotonic. A revoked credential cannot be reactivated as rollback; a future issuance is a new governed purpose and generation.
10. A successful residual legacy write after the quiesce/read-only deadline is a security/data-correctness incident and blocks acceptance.

## 2.8 Buffer and temporary-compatibility baseline

**RECOMMENDATION — ACCEPT.**

1. New-system endpoint buffers remain governed by accepted receipt/cleanup rules. Unacknowledged new data is never discarded by migration convenience.
2. Legacy deferred SQL/CSV is frozen at an approved boundary and inventoried through value-free counts, size/age classes, format/parser status, and content digests.
3. Raw executable text is never sent to or executed by the target.
4. Each legacy buffer receives one approved disposition:
   - `DRAIN_UNDER_LEGACY_BEFORE_FENCE`;
   - `TRANSFORM_TO_TYPED_EVENT_AFTER_PROOF`;
   - `QUARANTINE_FOR_INVESTIGATION_OR_HOLD`;
   - `DISCARD_OR_EXPIRE_BY_HUMAN_POLICY`.
5. A legacy drain occurs only while legacy remains the explicit authority and before the final fence. Post-fence execution is rejected.
6. Typed transformation requires complete semantics, deterministic identity, realm/source binding, privacy transformation, oracle, conflict handling, and replay/one-effect tests.
7. Unreachable-device buffers remain explicit exceptions. Central trust may still be revoked; the device is remediated, removed, or re-enrolled before collection when it returns.
8. The preferred compatibility mechanism is a read-only projection or typed API from the new system. A temporary delivery adapter MAY serve an indispensable named consumer or isolated staging target if it is server-side, typed, same-realm, idempotent, audited, bounded, and hard-expiring.
9. A compatibility adapter MUST NOT run on endpoints, accept SQL/script/path/credential input, write the live legacy authoritative database by default, auto-renew, or survive final decommission.

## 2.9 Residual monitoring, exceptions, and final acceptance baseline

**RECOMMENDATION — ACCEPT.**

1. Residual assurance combines at least two independent evidence classes where applicable: database sessions/audit, failed login or certificate use, network denies, endpoint task/service/package inventory, deployment state, CMDB, archive/API probes, or owner evidence.
2. Every sensor has a positive control and records capture configuration, clock quality, retention/rollover, scope, and blind intervals.
3. A quiet window alone is insufficient. It must be reconciled with the approved population, business cycles, static/configuration evidence, owner evidence, and unreachable exceptions.
4. A residual exception has exact scope, type, risk class, owner, next action, containment, blocking gates, review cadence, expiry, and evidence digest.
5. Expiry without remediation becomes `EXPIRED_UNRESOLVED` and blocks acceptance. No auto-renew exists.
6. Late findings reopen a linked technical case. Prior evidence is immutable and is not edited to conceal the finding.
7. Final acceptance is a typed, content-addressed record generated from authoritative states and evidence. An independent evaluator recomputes every predicate, evidence freshness, exception state, and owner approval.
8. The evaluator cannot mutate the evidence or operational state it evaluates.
9. Final technical state never claims legal completion, perfect absence, forensic truth, or deletion of recipient-controlled copies.
10. Multi-owner acceptance is mandatory. At minimum the accountable functions for discovery/disposition, data correctness/reconciliation, release/cutover, endpoint operations, database, security/IAM/PKI, network, archive/records, support, and designated production risk must sign or explicitly block according to the approved profile.

## 2.10 Consolidated cross-topic invariants added by this review

| ID | Consolidated invariant |
|---|---|
| X06-01 | Discovery maturity, validation maturity, cutover-ring exposure, cutover workflow, and business authority are separate namespaces and state machines. |
| X06-02 | `AuthorityEpochV1` is the only business-authority source of truth; shadow or ring state cannot imply authority. |
| X06-03 | Every business-authority transition is monotonic, audited, content-addressed, and bound to a proved source boundary. |
| X06-04 | `BOTH` ordinary authorities is structurally unrepresentable. `FROZEN_NO_AUTHORITY` is the safe ambiguity/transition state. |
| X06-05 | Comparison-only data has no ordinary projection, integration, export, lifecycle, portal, or downstream decision path. |
| X06-06 | Shadow observations created before cutover remain shadow evidence permanently unless a separately governed historical import contract creates new `LEGACY_IMPORT` facts. |
| X06-07 | A comparison match proves similarity under one profile, not correctness, lawful purpose, supportability, or production fitness. |
| X06-08 | A legacy behavior's presence proves existence, not approval to preserve its implementation. Only an approved outcome may be carried into the target. |
| X06-09 | Non-observation is bounded by population, time, capture, access, clock, and unreachable evidence and never silently becomes absolute absence. |
| X06-10 | A legacy rollback option must have an explicit expiry and closes no later than trust removal. |
| X06-11 | After `LEGACY_TRUST_REVOKED`, legacy credential recreation is outside the approved architecture and requires a baseline change proposal. |
| X06-12 | A metric or monitor may pause or narrow; it cannot create credentials, execute SQL, delete data, or select a destructive rollback. |
| X06-13 | The compatibility projector is not canonical truth, and a defect-normalization rule used for comparison never enters ordinary target behavior. |
| X06-14 | No known defect or tolerance may suppress realm, privacy, authority, dual-write, durability, receipt, audit, tombstone, restore, or evidence-integrity failures. |
| X06-15 | Existing telemetry may be read under approved scope; enabling instrumentation is a separate mutating change with its own lifecycle and cleanup. |
| X06-16 | Discovery tooling remains one-shot. Recurring residual observation uses approved orchestration or existing platform sensors; it does not silently become a new permanent endpoint agent. |
| X06-17 | Deferred executable SQL is never a target event, migration contract, or replay format. |
| X06-18 | A compatibility bridge is temporary, typed, server-side, hard-expiring, and absent from final architecture by default. |
| X06-19 | Database `READ_ONLY`, login disablement, certificate revocation, endpoint uninstall, and firewall denial are individual controls, never complete proof alone. |
| X06-20 | Authority transfer, trust removal, and final decommission are distinct irreversible milestones with distinct evidence and owner decisions. |
| X06-21 | Cross-system cutover actions use idempotent commands and observations; no document may claim atomicity across endpoint management, SQL, PKI, network, archive, CMDB, and portal. |
| X06-22 | Every consumer and configuration disposition, reconciliation result, rollback boundary, credential removal, and final decommission requires a named owner approval. |
| X06-23 | A final technical acceptance record reports limitations, exceptions, archive state, and external-copy limits; it does not claim legal or business completion. |
| X06-24 | Every production numeric value has an owner, units, source, exact profile, uncertainty, review trigger, and fail-safe behavior. Topic estimates do not harden into architecture. |
| X06-25 | A late residual finding reopens a linked case and may invalidate future reliance on the acceptance; prior evidence remains immutable. |

---

# 3. Rejected and deferred recommendations

## 3.1 Rejected now

| Recommendation or interpretation | Decision | Reason | Condition that could change it |
|---|---|---|---|
| Big-bang fleet cutover | **REJECTED** | Maximizes blast radius, hides environment/consumer differences, and provides no evidence-backed pause boundary. | Only a formal risk decision plus proof that staged coexistence is materially more dangerous; hard invariants and rollback evidence still apply. |
| Let both legacy and new feed ordinary reports/integrations during validation | **REJECTED** | Creates two business authorities, duplicate/conflicting effects, and ambiguous lifecycle truth. | No ordinary condition; one authority is a core invariant. |
| Endpoint dual-write or endpoint fan-out | **REJECTED — baseline conflict** | Reintroduces legacy database authority and two-destination commit/retry ambiguity. | Formal baseline change proposal with new primary evidence; none is expected. |
| New server writes legacy-shaped rows into the live legacy authoritative database | **REJECTED AS DEFAULT** | Gives the new system mutation authority in a weakly understood schema and may trigger hidden consumers. | An isolated staging target or named typed consumer adapter may be approved; live authoritative write-back requires a separate ADR and proof. |
| Promote pre-cutover shadow rows into ordinary facts | **REJECTED** | Breaks authority-boundary provenance and can duplicate or reinterpret history. | A separately governed historical import creates new typed `LEGACY_IMPORT` facts; shadow rows themselves remain evidence. |
| Compare and retain all raw row differences | **REJECTED** | Creates a second sensitive warehouse and uncontrolled access/retention obligations. | A narrowly approved transient break-glass sample may inspect a deterministic minimum in memory; no bulk durable diff. |
| Treat legacy output as the truth oracle | **REJECTED** | Legacy behavior may contain defects and unapproved semantics; existence is not correctness. | Legacy remains one evidence side after an independent contract and owner-approved semantics exist. |
| Generic percentage tolerance | **REJECTED** | Can conceal systematic loss, duplicates, realm mix, privacy expansion, or range gaps. | Only a typed scoped semantic relation with owner, direction, evidence, tests, and expiry. |
| Sampling-only reconciliation sign-off | **REJECTED** | Cannot prove rare exact-invariant failures or complete range equality. | Sampling remains a diagnostic aid after exact aggregate/range evidence. |
| Unkeyed hashes of low-entropy names, hosts, identities, or rows | **REJECTED** | Enables enumeration and cross-run linkage. | High-entropy opaque content may use ordinary content digests; comparison rows use purpose-separated keyed digests. |
| XOR or sum of row hashes as the equality proof | **REJECTED** | Duplicate cancellation and algebraic collisions can hide multiset differences. | No expected change; counted leaves and a domain-separated tree/root are the first candidate. |
| Automatically roll back to legacy on a metric failure | **REJECTED** | A metric may be wrong and legacy restart can create gap/overlap or restore rejected trust. | Automatic action may pause or choose an exact pre-authorized new N-1; pre-trust legacy rollback remains a human command after a proved fence. |
| Keep reusable legacy endpoint credentials dormant after trust removal | **REJECTED** | Leaves high-value attack material and makes decommission non-final. | Before trust removal, a time-bounded rollback window may keep the existing credential active under explicit risk authority; it blocks final trust removal and expires. |
| Recreate a revoked legacy endpoint credential | **REJECTED — baseline conflict** | Directly violates the accepted no-endpoint-database-credential/no-SQL design. | Formal baseline change proposal only. |
| Execute deferred SQL or scripts after cutover | **REJECTED** | Text may target stale schema/realm/state, contain secrets, cause side effects, and bypass typed idempotency/audit. | Raw execution remains rejected. A typed semantic transform may be considered after complete proof. |
| Discard every legacy buffer at a deadline | **REJECTED AS ENGINEERING DEFAULT** | Can silently lose required or unacknowledged data. | A named human authority may approve a bounded discard after counts/digests, impact, legal/records review, and evidence. |
| Wait indefinitely for every unreachable device before revoking fleet trust | **REJECTED** | Lost devices can hold the estate hostage and prolong credential risk. | Named devices may remain contained exceptions; central trust and paths still require expiry and owner decision. |
| Uninstall legacy software as the primary security control | **REJECTED** | Unreachable devices, repair sources, and alternate copies can remain while credentials/paths still work. | Uninstall remains cleanup after trust denial. |
| Disable a SQL login and declare credential removal complete | **REJECTED** | Existing sessions continue; permissions, mapped users, ownership, and impersonation remain. | No expected change; terminate sessions and complete layered cleanup. |
| Revoke a certificate and declare trust removal complete | **REJECTED** | Revocation distribution/validation can be delayed or unavailable and application/network paths may remain. | No expected change; revocation is one layer. |
| UI-only read-only mode | **REJECTED** | Direct APIs, jobs, database sessions, or stale routes can still mutate. | No expected change; layered proof is mandatory. |
| Database `READ_ONLY` as the sole archive control | **REJECTED AS SOLE CONTROL** | Does not decide purpose, access, audit, exports, restore, retention, or privileged-admin behavior. | It remains a defense-in-depth control. |
| Keep the original legacy portal indefinitely | **REJECTED** | Retains broad attack/dependency/support surface and confuses active versus historical truth. | A short owner-approved transition with mutation removed and a hard retirement plan. |
| Static CSV/PDF export as the primary archive | **REJECTED** | Weak access/revocation/audit/deletion, proliferating copies, and poor provenance/accessibility. | A very small approved immutable dataset may be exceptional under controlled repository, encryption, access, retention, and deletion. |
| Persistent discovery agent by default | **REJECTED** | Creates another permanent privileged/telemetry lifecycle before a continuing need is proved. | Repeated approved cycles prove a need that enterprise orchestration or existing health sensors cannot meet, followed by a separate ADR. |
| One broad PowerShell discovery script | **REJECTED** | Hard to constrain, sign, prove non-executing, and prevent module/profile/script side effects. | A fixed wrapper may invoke signed compiled commands in an approved lab; it cannot accept arbitrary content. |
| General remote shell, SQL console, runbook engine, or arbitrary command runner in UAM | **REJECTED** | Becomes a lateral-movement, credential, script, plugin, and audit authority far beyond the migration contract. | A separate enterprise tool may orchestrate fixed approved adapters under its own review; UAM still records typed commands/evidence. |
| Enable Query Store/XE/Audit during the “read-only” run | **REJECTED IN THAT LANE** | It is a configuration mutation with performance, privacy, retention, and cleanup effects. | A separate approved instrumentation change may be run when existing evidence is insufficient. |
| One monitoring sensor proves no residual activity | **REJECTED** | Every sensor has blind spots and false negatives. | Multiple independent sensors, population reconciliation, positive controls, and owner evidence are required. |
| Infer owner, purpose, criticality, role, or entitlement from names, logins, paths, query comments, or usage counts | **REJECTED** | These are spoofable/stale hints, not authority. | Correlation may create an interview candidate; a human owner/authority must confirm. |
| Migrate every observed legacy behavior “as is” | **REJECTED** | Would preserve direct SQL, executable buffers, broad mutation, weak identity, and unapproved defects. | Every item receives an approved outcome disposition and target contract. |
| Retire everything quiet in one window | **REJECTED** | Seasonality, telemetry gaps, manual/emergency consumers, and unreachable systems defeat the inference. | Complete scoped coverage, business-cycle evidence, owner approval, reversible validation, and rollback. |
| Add an external broker for migration events by default | **REJECTED BY BASELINE** | Adds another custody/replay/restore/operations domain without measured need. | Quantitative trigger plus separate ADR/prototype. |
| Make an OSS rollout, data-quality, secrets, lineage, or workflow product the UAM authority | **REJECTED** | Reviewed projects target different trust boundaries and import broad plugins, credentials, queries, traffic control, or operational dependencies. | An exact separately approved enterprise/platform requirement and full dependency/security/operations bake-off. |
| Treat final technical decommission as legal completion or perfect absence | **REJECTED** | Research cannot decide legal obligations and cannot prove unmanaged external copies or universal absence. | No expected change; the record remains a bounded technical claim. |

## 3.2 Deferred technologies, dependencies, and topologies

| Area | Provisional matter | Classification | Resolution path |
|---|---|---|---|
| Discovery parser | Exact SQL Script DOM package/source mapping, parser version, PowerShell SDK version, structured-data libraries | **DEPENDENCY ADMISSION + CLI EXPERIMENT** | Exact source/tag/license/SBOM/security mapping; hostile corpus; allocation/time limits; no-execution proof. |
| Discovery orchestration | Enterprise deployment product, target resolver, read-only account mechanism, PSU API/repository method | **HUMAN DECISION + CLI EXPERIMENT** | Named platform inventory, least privilege, scope/cleanup, support and licensing. |
| Runtime observation | Existing Query Store/XE/Audit/log sources; whether new instrumentation is needed | **HUMAN DECISION + CLI EXPERIMENT** | Capture/retention/clock/gap evidence; separate change ADR if enabling. |
| Evidence storage | File package, relational evidence store, object storage, signing/checkpoint service, enterprise lineage integration | **DEFERRED** | Access/retention/immutability/multi-party verification/scale requirements and bake-off. |
| Comparison digest | JCS subset, field canonicalization, HMAC algorithm/service, key retention/destruction, Merkle profile, partition depth | **T1 CANDIDATE + HUMAN CRYPTO DECISION** | Independent vectors, canonicalization counterexamples, performance/linkability/key-lifecycle tests. |
| Time semantics | Pinned tzdb version, legacy-local reconstruction, bucket sizes, late-arrival deadline | **HUMAN DECISION + CLI EXPERIMENT** | Approved report contracts and exact time/differential fixtures. |
| Comparison identity | Event exact, source-record exact, source-range multiset, bucket dimensions, report contract | **HUMAN DECISION + CLI EXPERIMENT** | Discovery evidence, report semantics, privacy decision, and stable fence proof. |
| Tolerances/defects | Exact fields, directions, ranges, owners, expiry, review cadence | **HUMAN DECISION** | Approved semantic register; exact invariants remain untolerated. |
| Configuration source | Legacy precedence, target governance precedence, manual reconciliation, migration scope | **HUMAN DECISION** | Inventory, owner decisions, no-broadening proof, and rollback candidate. |
| Shadow storage | Tables/schema/database, encryption, lifecycle, access roles, retention, cleanup | **DEFERRED** | Database decision, privacy/records decision, resource and deletion/restore tests. |
| Cutover rings | Cohort composition, population, geography/realm/site distribution, support window, promotion authority | **HUMAN DECISION** | Exact estate inventory, risk model, operational capacity, and current evidence. |
| Bake/observation | Minimum bake, maximum observation, required business cycles, monitor freshness, pause/resume rules | **HUMAN DECISION + ESTIMATE** | Measured latent-failure/business-cycle behavior and owner risk acceptance. |
| Rollback | Expiry, legacy restart allowance, new N-1 horizon, gap policy, decision quorum | **HUMAN DECISION + CLI EXPERIMENT** | Exact fence and repeated rollback drills; closes before trust removal. |
| Archive | Original DB read-only, read-only copy, typed history import, managed archive; database engine/storage | **HUMAN DECISION + CLI EXPERIMENT** | Purpose/fields/access/retention, fidelity, restore, deletion, performance, operations, cost. |
| Credential platform | SQL/Windows identities, enterprise PKI, secrets manager, device certificate status, directory ownership | **HUMAN DECISION + CLI EXPERIMENT** | Exact inventory and platform-specific revoke/rotate/session/path drills. |
| Network control | Firewall product, host/network boundary, proxy/VPN/NAT/listener/failover representation | **HUMAN DECISION + CLI EXPERIMENT** | Exact topology, policy simulation, deny proof, and recovery. |
| Residual monitoring | SIEM, SQL Audit/XE, endpoint inventory, CMDB, certificate status, network telemetry | **HUMAN DECISION + CLI EXPERIMENT** | Positive controls, minimization, retention/access, blind-interval evidence, cost. |
| Compatibility delivery | None, read-only projection/API, isolated staging, temporary typed bridge | **DEFERRED / DISABLED BY DEFAULT** | Indispensable consumer, exact contract, no live legacy authority, hard expiry, support/cost. |
| OSS tools | Argo Rollouts, Flagger, Rundeck, OpenBao, osquery, in-toto, OpenLineage, data-quality tools | **REFERENCE ONLY BY DEFAULT** | Exact platform need and full admission record; no automatic runtime dependency. |
| Accessibility | Browser/AT matrix, localization, report format, review/approval UI technology | **HUMAN DECISION + CLI EXPERIMENT** | Organizational target plus end-to-end critical-task evidence. |
| Operations | Staffing, on-call, change windows, incident command, support hours, communications | **HUMAN DECISION** | Accountable leadership decision and exercised runbooks. |
| Service objectives | SLO/RPO/RTO, acceptable gap/overlap, backlog drain, archive availability, support response | **HUMAN DECISION** | Product/SRE/Risk approval informed by measurements. |
| Retention | Discovery working set, evidence, shadow facts, mismatch evidence, archive, revocation evidence, residual telemetry, backups | **HUMAN DECISION** | Records/Privacy/Legal/Data Controller decisions encoded as immutable profiles. |

## 3.3 Numeric values explicitly not accepted as timeless architecture

The following are **ESTIMATE**, scenario labels, or owner inputs rather than accepted production values:

- discovery row, byte, allocation, time, concurrency, retry, and observation-window limits;
- ring populations, percentages, site/realm distributions, and names;
- any fixed 24-hour, multi-day, week, month-end, quarter-end, or year-end bake/observation duration;
- comparison window size, late-arrival deadline, partition depth, sample size, break-glass rows, or digest-key lifetime;
- tolerated count, percentage, timestamp, rounding, precision, lag, or report difference;
- maximum buffer age/size/count and drain/transform throughput;
- rollback window, N/N-1 support period, credential overlap, certificate evidence horizon, or residual-monitoring duration;
- acceptable unreachable population, exception count/age, support queue, error rate, backlog, resource headroom, or recovery time;
- archive retention, evidence retention, backup expiry, secret-copy cleanup period, and final deletion date;
- database, network, CPU, memory, disk, handle, query, metric-series, and cost budgets.

Every production value MUST record owner, unit, source, environment, release/profile, uncertainty, failure behavior, compatibility impact, and review trigger.

---

# 4. Contradiction register with evidence-quality resolution

## 4.1 Resolution method

Each conflict was resolved by preserving predecessor invariants; preferring one explicit authority; separating observation from business effect; preserving narrower privacy/security scope; rejecting fictitious cross-system atomicity; keeping values provisional; and creating a CLI or human gate where prose cannot establish fitness.

## 4.2 Register

| ID | Overlap, contradiction, or authority problem | Evidence-quality assessment | Consolidated resolution | ADR/action |
|---|---|---|---|---|
| C06-01 | I02 says I01 is missing; I03 says I01/I02 are missing. | True for their topic chats, false for current review. | Mark exact input-presence gate `PASS`; keep executed inventory/reconciliation gates open. | Update topic blockers; retire missing-input ADR as current blocker. |
| C06-02 | I01 discovery rollout, I02 validation rings, and I03 cutover rings reuse `R0`, `R1`, etc. | All are local naming recommendations and can be confused operationally. | Use `DISC-D*`, `VAL-V*`, and `CUT-C*` namespaces. | ADR-B06-016. |
| C06-03 | I03's “authority states” mix comparison, transfer, read-only, credential, and decommission workflow with business authority. | I02 provides the narrower exact business-authority model. | `AuthorityEpochV1` contains only legacy/frozen/new. `CutoverCohortStateV1` holds workflow. | ADR-B06-003/016; schema correction. |
| C06-04 | I02 permits higher-epoch rollback to legacy; I03 says rollback must not recreate legacy trust and becomes unavailable after revocation. | Both are correct in different phases. | Permit pre-authorized legacy rollback only before explicit expiry and trust removal, using existing intact trust and a new fence/epoch. Prohibit it afterward. | ADR-B06-008. |
| C06-05 | I03 describes “one-way authority transfer,” while a pre-trust rollback window may exist. | “One-way” is too broad before the rollback window closes. | Authority sequences are monotonic, but authority value may return to legacy before trust-removal under strict rules. Trust removal is the one-way milestone. | Wording and state-machine update. |
| C06-06 | I02 says shadow history is never promoted; some migration shorthand could imply promotion after a match. | No supplied evidence justifies promotion. | Shadow is permanently non-authoritative. Named historical import is a separate contract/origin. | ADR-B06-004. |
| C06-07 | I02 rejects live legacy write-back; I03 allows an optional compatibility writer. | A typed bridge to a named consumer differs from live authoritative DB write-back, but I03's term is too broad. | Prefer read-only projection/API. Permit temporary typed delivery only to named consumer/isolated staging; live authoritative DB write-back remains disabled by default. | ADR-B06-015. |
| C06-08 | I01 rejects a persistent agent; I03 needs residual monitoring over time. | Recurring observation does not require a new permanent UAM agent. | Use existing sensors and enterprise-scheduled one-shot snapshots. A persistent agent needs a separate need/ADR. | ADR-B06-001/014. |
| C06-09 | I01 permits reading existing Query Store/XE/Audit; operational pressure may seek to enable them for coverage. | Reading and enabling have different authority/load/privacy. | Existing evidence is read-only; enabling is a separate approved change with cleanup and lifecycle. | ADR-B06-014. |
| C06-10 | I01 says absence cannot be absolute; I03 final decommission seeks zero unauthorized writes. | Zero writes is a scoped observation claim, not universal absence. | Final record states exact population, sensors, window, blind intervals, exceptions, and positive controls; it never claims universal absence. | Acceptance schema and wording. |
| C06-11 | I01 defaults buffers to quarantine; I02 considers semantic transformation; I03 includes drain/discard. | These are compatible dispositions at different evidence/authority stages. | Closed four-state buffer disposition; drain only pre-fence under legacy, transform only after proof, discard only human-authorized. | ADR-B06-011. |
| C06-12 | I02 defaults to read-only archive; I03 prefers read-only copy but also discusses original DB and typed import. | Topology is a human/CLI choice; mechanism agreement is strong. | Accept layered read-only and BFF access; prefer copy as first candidate; keep topology open. | ADR-B06-009. |
| C06-13 | I03's credential checklist could be read as “disable then done.” | Microsoft documents that disabling a SQL login does not terminate existing sessions and permissions remain. | Disable/revoke + terminate sessions + permission/ownership cleanup + secret removal/rotation + network denial + monitoring. | ADR-B06-010. |
| C06-14 | I03 cites AD CS decommission steps, while device PKI integration remains provisional. | AD CS docs establish capability only for that topology. | Make CA-decommission actions conditional on discovery proving a dedicated enterprise CA is in scope. | Source correction; no PKI assumption. |
| C06-15 | Safe-deployment sources discuss bake time and sometimes example durations; topic text might harden a number. | Guidance supports hours/days, increasing exposure, and business-cycle observation, not a UAM universal duration. | Exact bake and coverage are human/measurement values; no auto-promotion. | ADR-B06-007. |
| C06-16 | I02 proposes JCS/HMAC/Merkle as if close to normative; exact key/canonicalization fitness is untested. | Standards are strong building blocks, not UAM proof. | Accept as T1 candidate only; independent implementation and resource/linkability gates remain open. | ADR-B06-005. |
| C06-17 | I02 lists automated pause/rollback triggers; I03 rejects automatic legacy rollback. | Automatic pause and automatic destructive/authority rollback are different. | Hard signals automatically pause; rollback is a separate pre-authorized or human command. New N-1 may be automated only after exact repeated proof and authority. | ADR-B06-008. |
| C06-18 | Authority epoch sequence and cutover workflow version can be conflated. | They have different correctness meaning. | Separate `authorityEpochSequence` from `cutoverStateVersion` and `planRevision`; no inference between them. | Contract correction. |
| C06-19 | Compatibility bridge hard expiry can be treated as a timer that silently disables a critical consumer. | Timer is safe only with owner/transition evidence and explicit state. | Expiry prevents renewal/ordinary use, creates a blocking incident/hold, and never silently drops pending work. | ADR-B06-015 and bridge state machine. |
| C06-20 | Topic repository versions are point-in-time and some became stale by this review date. | Current source review is stronger for maintenance state; architecture should not freeze versions. | Record reviewed tag/commit/date; execution-time dependency admission selects current supported exact versions. | Section 11 corrections. |
| C06-21 | “Exact report equivalence” can conflict with intentional target corrections or unrepresentable fields. | Report semantics are human-owned and legacy is not oracle. | Every surface is exact-preserve, deliberate-change, retire, or unrepresentable; no silent default. | ADR-B06-006 and human register. |
| C06-22 | Legacy configuration might be treated as source of truth, but accepted product ceiling and target governance constrain it. | Observed settings prove behavior, not authority. | Typed transform classifies preserve/change/retire/investigate and proves no broadening; conflicts block activation. | ADR-B06-006. |
| C06-23 | Topic designs contain many technical “owner” fields, but prompt requires named approvals for specific decisions. | An owner field without an approval event is insufficient. | Require immutable owner-decision records for each disposition, reconciliation result, rollback boundary, credential removal, and final action. | ADR-B06-002/013. |
| C06-24 | I03 `DECOMMISSIONED` can be misread as legal/records completion. | Research authority is technical only. | State means bounded technical acceptance; legal/business/records outcomes are separate. | Schema/UI language correction. |
| C06-25 | Discovery/removal can inventory exports, but recipient-controlled copies may remain. | Technical control is capability-bounded. | Final status uses `EXTERNAL_ACTION_REQUIRED` or `COMPLETE_WITH_LIMITATIONS`; no false erasure claim. | Lifecycle/acceptance integration with Batch 04. |
| C06-26 | Temporary legacy rollback may appear to conflict with the no-endpoint-SQL baseline. | It does not introduce new target endpoint SQL if it reactivates only the unchanged legacy product before trust removal; risk remains high. | Allow only as a pre-expiry contingency with existing legacy artifact/trust and explicit human authority. No target component gains SQL. | ADR-B06-008; threat review. |
| C06-27 | Topic gate tables classify missing inputs as blocked; current presence might be mistaken as readiness. | Presence is necessary but not evidence execution. | Distinguish `B06-INPUT=PASS` from all operational gates `OPEN/BLOCKED`. | Gate catalogue update. |
| C06-28 | Some questions can be answered by prose while the prompt requires CLI evidence for runtime claims. | Platform capability and architecture reasoning cannot prove UAM behavior. | Every runtime safety, no-mutation, isolation, fence, rollback, read-only, revocation, path, restore, and cleanup claim has a CLI/lab gate. | Section 7. |
| C06-29 | A final acceptance evaluator could become self-authorizing. | Evaluation and human decision are different authorities. | Evaluator emits `PASS/HOLD` only; designated humans approve or block. It cannot alter source state or approvals. | ADR-B06-013. |
| C06-30 | Existing evidence hashes prove integrity but not source truth or completeness. | A malicious/defective authorized collector can hash coherent false output. | Use independent evidence classes, positive controls, owner challenge, population reconciliation, and immutable first failures. | Threat/evidence design. |

## 4.3 Accepted-baseline change-proposal status

**FACT.** No consolidated decision above changes the accepted baseline. The review preserves the endpoint topology, privacy boundary, no-endpoint-SQL rule, one-writer durability, at-least-once/one-effect delivery, receipt meaning, modular monolith, relational inbox, no-broker default, MSI release boundary, realm isolation, transactional audit, tombstone/restore rules, and human-decision boundary.

A future implementation MUST open an explicit baseline change proposal before claiming any of the following is necessary:

- endpoint possession of a central database credential or SQL submission;
- endpoint dual-write or two ordinary authorities;
- raw source value crossing the fixed Task Host/minimization boundary;
- promotion of shadow rows into ordinary facts without a historical-import contract;
- lower-sequence authority or release rollback;
- recreation of a revoked legacy endpoint credential;
- execution of deferred SQL or tenant/admin-supplied script/query/path as migration behavior;
- silent unacknowledged loss, unknown-as-tolerated, or cursor movement past uncertainty;
- privileged mutation without same-transaction audit;
- restore/read/archive access before readiness;
- a generic command, plugin, policy-language, or workflow authority inside UAM;
- a broker or external authority service without its measured trigger.

The proposal must identify the affected decision, new primary evidence, alternatives, security/privacy/realm/durability impact, smallest falsifying experiment, migration/rollback consequence, and ADR action.

---

# 5. Normative component, interface, schema, and state-machine baseline

## 5.1 Consolidated trust-boundary architecture

```text
HUMAN / GOVERNANCE AUTHORITY
  inspection purpose + exact scope + fields + access + retention
  owner / disposition / semantics / tolerance / rollback / cutover decisions
  production and final-decommission authority
                         |
                         v
MIGRATION CONTROL PLANE — accepted modular monolith / BFF boundary
  contract catalogue + route/action catalogue
  discovery plan references + evidence registry
  authority epoch registry
  comparison profiles + shadow isolation
  cutover plans + cohort manifests + ring controller
  typed commands + same-transaction authorization/audit
  holds + exceptions + independent gate evaluation
                         |
      +------------------+-------------------+
      |                                      |
      v                                      v
ONE-SHOT DISCOVERY LANE                  PARALLEL VALIDATION LANE
fixed endpoint/SQL/PSU/adapters          legacy read adapter (read-only)
parse only; no execution                 new shadow materializer
local sensitive working set              compatibility projector
sanitizer + evidence graph               canonicalizer/digest/range controller
coverage + disposition                   mismatch/defect/tolerance evaluator
      |                                      |
      +------------------+-------------------+
                         v
              IMMUTABLE MIGRATION EVIDENCE
  manifests, observations, digests, ranges, first failures, decisions,
  approvals, cleanup receipts, limitations; no raw activity/secrets/SQL
                         |
                         v
                   CUTOVER COORDINATION
  immutable plan -> CUT-C0 lab -> CUT-C1..CUT-C4 progressive exposure
  hard failure -> PAUSE; human promotion; exact rollback boundary
                         |
                         v
BUSINESS AUTHORITY
  LEGACY_AUTHORITY(n)
      -> FROZEN_NO_AUTHORITY(n+1)
      -> NEW_AUTHORITY(n+2)

  pre-trust rollback only:
  NEW_AUTHORITY(n)
      -> FROZEN_NO_AUTHORITY(n+1)
      -> LEGACY_AUTHORITY(n+2)

  after LEGACY_TRUST_REVOKED:
  NEW_AUTHORITY only, with pause / capability disable / new N-1 / roll-forward
                         |
                         v
LEGACY READ-ONLY / TRUST REMOVAL / DECOMMISSION
  disable schedules/jobs/writers
  layered read-only + archive BFF
  terminate sessions + revoke/rotate/remove credentials/secrets
  deny network paths + classify failed use
  disposition buffers + unreachable exceptions
  remove runtime/packages/rules/CMDB references
  independent acceptance + multi-owner decision

No endpoint -> two destinations
No endpoint -> SQL/database credential
No browser/admin -> arbitrary script/SQL/path/credential action
No shadow -> ordinary business egress
No monitor -> destructive automatic action
No restored legacy environment -> ordinary write, receipt, or mutation authority
```

## 5.2 Component and authority baseline

| Component | Normative responsibility | Explicit prohibitions | Accountable function |
|---|---|---|---|
| **Migration Contract Authority** | Own strict contract catalogue, schema bundles, enums, canonical profiles, compatibility matrix, route/action catalogue, and deprecation. | No runtime remote schema, silent default, generic extension bag, executable configuration, or body-derived realm. | Architecture / Contract Governance |
| **Scope Authority Registry** | Record approved discovery/comparison question, realm, target-set reference, adapters, fields, time, access, expiry, deletion, support, and authority reference. | No wildcard, raw address/credential in shareable scope, self-approval, or operator broadening. | System/Data Owner + Governance |
| **Legacy Discovery Run Controller** | Verify scope/tool/clock/target membership; run fixed adapters; preserve first failure; publish only after verification; clean up. | No dynamic assembly, general shell, arbitrary SQL/path/URL/credential, plugin, or persistent scheduler. | Discovery Engineering |
| **Endpoint Discovery Adapters** | Read approved services, tasks, packages, files, registry, settings, checkpoints, buffers, network classes, signatures, and states. | No profile/drive crawl, source collection, task/service mutation, command-line/raw identity export, or side-effect-prone product inventory shortcut. | Endpoint Operations / Discovery |
| **SQL Metadata Adapter** | Execute fixed reviewed bounded read-only catalogue/DMF/runtime-evidence queries; record effective permission and coverage limits. | No DDL/DML, `EXEC`, DBCC, backup/restore, telemetry enablement, arbitrary identifier/query, secret/hash retrieval, or raw activity export. | Database Migration Engineering |
| **PSU Repository/GET Adapter** | Read approved repository/configuration and fixed GET-only management metadata; compare repository/runtime states. | No script/job/endpoint invocation, app rendering, POST/PUT/PATCH/DELETE, token export, or generic URL. | Legacy Application Operations |
| **Static Parser Boundary** | Parse PowerShell, T-SQL, report/configuration formats into finite typed facts and capability flags. | No runspace, module import, dot-source, macro/formula, external reference, SQL execution, type initialization, or arbitrary code. | Secure Tooling / Language Owners |
| **Credential and Buffer Classifier** | Inventory type, store, principal/scope class, presence, owner/use state, counts/age/size classes, parser status, digest, and incident flags. | No password/token/private key/connection string/raw SQL/activity copy or display. | Security/IAM + Data Reliability |
| **Sanitizer/Alias Service** | Construct closed shareable records; create purpose-separated local aliases; remove raw working values; run exact canary checks. | No reversible map in shareable pack, raw low-entropy hash, cross-purpose alias reuse, broad redaction object, or raw exception. | Privacy Engineering |
| **Evidence Graph Builder** | Create immutable typed nodes/edges linking legacy item, evidence, owner, disposition, requirement, target component, contract, test, migration, rollback, and removal proof. | No inferred owner/purpose, free-form executable edge, cross-realm edge, orphan disposition, or hidden overwrite. | Verification Governance |
| **Coverage Evaluator** | Reconcile population, static, configuration, runtime, network/export, interview, time, clock, access, and unreachable evidence. | No absolute absence, percentage confidence, or quiet-window retirement. | Discovery Verification |
| **Disposition Registry** | Hold immutable owner decisions for preserve/change/retire/investigate and enforce prerequisites. | No tool self-approval, migration/removal default, or approval from names/usage. | Product/Data/Application Owners |
| **Authority Epoch Registry** | Store monotonic business authority, scope, effective boundary, prior epoch, command, reason, evidence, and audit reference. | No `BOTH`, lower sequence, payload-derived realm, silent edit, or shadow-as-authority. | Migration Control / Data Correctness |
| **New Shadow Materializer** | Persist validated minimized new facts in isolated realm/cohort shadow state under stable identities/provenance. | No ordinary projections, integrations, exports, lifecycle, portal visibility, or canonical-authoritative mutation. | New Data Platform |
| **Legacy Read Adapter** | Execute one fixed read-only extraction profile against an approved legacy source/copy; bind schema/report/config revision and closure evidence. | No arbitrary SQL, write, side-effecting stored procedure, broad row export, cross-realm query, or endpoint credential. | Legacy Migration Engineering |
| **Compatibility Projector** | Deterministically derive legacy-shaped comparison/read outputs from canonical new facts and explicit reference/config revisions. | No live legacy write-back, raw-source reconstruction, hidden default, field invention, canonical fact mutation, or ordinary defect emulation. | Compatibility Engineering |
| **Canonicalizer and Digest Builder** | Apply field-specific types/normalization/time rules; produce per-run/realm keyed row digests, multiplicities, partitions, and roots. | No host/locale default, lossy parse, unkeyed low-entropy fingerprint, XOR/sum-only proof, or digest as business identity. | Contract/Data Security |
| **Window/Watermark Controller** | Bind both sides to half-open time/native ranges, prove closure, classify late data, and create immutable superseding generations. | No final open window, timestamp-only continuity where native order differs, or edit of closed evidence. | Data Reliability |
| **Mismatch/Defect/Tolerance Service** | Emit finite mismatch classes; match exact approved defect/tolerance records; route owner decisions; preserve unknowns. | No silent suppression, wildcard record, unknown-as-pass, free-form reason authority, or suppression of exact invariants. | Reconciliation Engineering + Data Governance |
| **Configuration Transformer** | Convert immutable legacy snapshot to typed intermediate model, candidate, loss/ambiguity manifest, no-broadening proof, and owner queue. | No script/SQL execution, owner/purpose inference, direct activation, hidden default, or product-ceiling broadening. | Configuration Migration / Product Privacy |
| **Cutover Plan Compiler** | Validate closed plan; resolve release-owned cohort criteria into immutable manifest; bind release/contracts/storage/policy/comparison/monitors/rollback/owners. | No free-form query/code, tenant expression, dynamic destination, production value inference, or hidden auto-promotion. | Cutover Engineering |
| **Ring Controller** | Evaluate entry, bake, required coverage, hard stops, promotion proposal, pause, and evidence freshness for one immutable ring. | No threshold invention, unknown monitor as green, credential recreation, legacy re-enable, or final human decision. | Release Operations |
| **Legacy Control Adapter** | Execute fixed inventory-bound disable/quiesce/read-only/removal operations after approved production change authority; return typed observations. | No broad discovery, arbitrary script/SQL, action outside inventory, or research mutation. | Legacy Operations |
| **Enterprise Deployment Adapter** | Request/observe signed package stage, activate, pause, N-1, disable, uninstall, and inventory through approved management. | No raw credentials, arbitrary remote shell, tenant-supplied command/path, user-profile crawl, or direct source read. | Endpoint Management |
| **Credential Revocation Coordinator** | Orchestrate disable/revoke/rotate, session termination, permission/ownership cleanup, secret-copy removal, status, and verification. | No plaintext secret storage, automatic replacement legacy credential, or metric-triggered destructive action. | Security/IAM/PKI + Database Security |
| **Network Denial Coordinator** | Request/observe fixed approved rules denying legacy write routes while retaining approved new/archive/admin paths. | No endpoint-created allow, broad firewall weakening, tenant-supplied address, or research-time production mutation. | Network Security |
| **Buffer Disposition Service** | Freeze creation, inventory, execute only approved drain/typed-transform/quarantine/discard state, reconcile counts/digests, and preserve evidence. | No raw execution/import, silent discard, post-fence legacy drain, or raw buffer in portal/logs/support. | Data Reliability + Records/Product |
| **Legacy Read-Only Gateway** | Serve approved historical read models through accepted BFF with realm, purpose, field, audit-before-disclose, and accessibility controls. | No mutation API, direct browser DB credential, generic query/SQL, raw activity dump, or untracked export. | Archive/Data Product + IAM |
| **Residual Activity Monitor** | Combine bounded DB/auth/network/endpoint/package/CMDB/archive evidence and positive controls into finite findings. | No raw activity, command line, internal address, user identity, unbounded label, or sole-sensor assurance. | Security Monitoring / SRE |
| **Residual Exception Registry** | Record exact scope, type, owner, risk, containment, next action, expiry, review, evidence, and blocking gates. | No wildcard, permanent exception, auto-renew, or authority to restore legacy trust. | Risk/Operations Governance |
| **Independent Gate Evaluator** | Recompute gates, evidence freshness, first failures, exception expiry, owner approvals, and acceptance predicates; emit `PASS/HOLD`. | No source-state mutation, approval invention, finding suppression, or production go/no-go. | Independent Verification |
| **Decommission Evidence Builder** | Produce content-addressed acceptance candidates and cleanup receipts from authoritative states and signed observations. | No self-asserted pass, raw secret/activity/address, overwritten failure, or legal-completion claim. | Verification Governance |
| **Support/Incident Plane** | Provide fixed runbooks, accessible state, pause/kill/new-release rollback, synthetic reproduction, escalation, communications, and postmortem evidence. | No arbitrary remote command, raw-data default, unaudited break-glass, or credential resurrection. | Support Operations / Incident Response |

## 5.3 Common contract profile

Every Batch 06 boundary MUST use a separately named, owned, versioned, bounded contract that records:

- exact producer and every required consumer;
- accountable engineering owner, business/data owner where applicable, and support owner;
- authenticated realm/authority source and privacy stage;
- strict closed schema, enum, scalar, Unicode, time, null/absence, ordering, and canonicalization profile;
- compressed/uncompressed bytes, items, fields, nesting, time, allocation, and concurrency limits;
- immutable identity, idempotency, conflict, replay, revision, and state-precondition semantics;
- transaction meaning and explicit external non-atomic boundaries;
- finite errors, retry class, terminal state, hold state, and recovery action;
- compatibility, consumer-first rollout, rollback, expiry, deprecation, and evidence validity;
- permitted and forbidden logs, metrics, audit, support, and evidence fields;
- valid, boundary, invalid, hostile, old/new, mutation, cleanup, and realm-negative vectors;
- dependency/source identities, runbook, owner decisions, and evidence requirements.

Common structural rules:

1. strict UTF-8 without BOM;
2. duplicate, wrong-case, malformed, over-limit, trailing, and unknown authority-bearing fields are rejected;
3. local immutable JSON Schema Draft 2020-12 bundles only; no remote `$ref` or runtime schema download;
4. canonical lower-case UUIDv7 for new UAM-owned IDs; UUID time bits are not source/business time, ordering, or authority;
5. SHA-256 content/file/evidence digests under an explicit algorithm profile;
6. RFC 3339 UTC instants plus separately declared clock/precision class where material;
7. no generic `metadata`, `properties`, `details`, `extension`, `script`, `query`, `command`, `path`, `credential`, or arbitrary dictionary field;
8. authenticated context supplies realm/installation/actor authority; payload fields are consistency evidence only;
9. no silent default or inferred owner/purpose/criticality/tolerance;
10. producer-first activation is prohibited: consumers, validators, evidence, and rollback deploy first.

## 5.4 Canonical naming and state namespaces

| Namespace | Purpose | Example states | Authority meaning |
|---|---|---|---|
| `DISC-D0..D4` | Discovery maturity/coverage | `D0_T1_ONLY`, `D1_LAB_PROVED`, `D2_BOUNDED_READONLY`, `D3_REPRESENTATIVE_COVERAGE`, `D4_DISPOSITION_COMPLETE` | None; evidence maturity only. |
| `VAL-V0..V4` | Parallel validation maturity | `V0_FIXTURE`, `V1_SHADOW_ISOLATED`, `V2_RANGES_CLOSED`, `V3_SEMANTICS_ACCEPTED`, `V4_CUTOVER_ELIGIBLE` | None; validation maturity only. |
| `CUT-C0..C5` | Progressive cutover exposure | `C0_DISCONNECTED_LAB`, `C1_ENGINEERING_CANARY`, `C2_REPRESENTATIVE_CANARY`, `C3_CONSTRAINED_BROAD`, `C4_GENERAL`, `C5_RESIDUAL` | None by itself; references authority epoch. |
| `AuthorityEpoch` | Ordinary business authority | `LEGACY_AUTHORITY`, `FROZEN_NO_AUTHORITY`, `NEW_AUTHORITY` | Sole authority source. |
| `CutoverCohortState` | Operational workflow | `DRAFT`, `PREPARED`, `BAKING_SHADOW`, `QUIESCING`, `NEW_PROBATION`, `TRUST_REMOVAL`, `RESIDUAL_MONITORING`, `DECOMMISSIONED`, `SAFETY_HOLD` | Never implies authority without epoch reference. |
| `ComparisonRunState` | Reconciliation workflow | `PLANNED`, `EXTRACTING`, `PENDING_CLOSURE`, `COMPARING`, `OWNER_REVIEW`, `PASSED`, `FAILED`, `SUPERSEDED` | No business authority. |
| `CredentialRemovalState` | Trust-removal workflow | `INVENTORIED`, `DISABLE_REQUESTED`, `SESSIONS_TERMINATED`, `RIGHTS_REMOVED`, `SECRETS_REMOVED`, `PATHS_DENIED`, `VERIFIED`, `FAILED_HOLD` | No authority except explicit registry status. |
| `BufferDispositionState` | Deferred-work lifecycle | `DISCOVERED`, `FROZEN`, `DISPOSITION_APPROVED`, `DRAINING`, `TRANSFORMING`, `QUARANTINED`, `DISCARDED_APPROVED`, `VERIFIED`, `FAILED_HOLD` | No authority to execute raw content. |

## 5.5 Core contracts

### 5.5.1 `LegacyEvidenceGraphRevisionV1`

```json
{
  "contract": "uam.migration.legacy-evidence-graph-revision",
  "version": "1.0.0",
  "graphRevisionId": "019d0000-0000-7000-8000-000000006001",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "scopeDigest": "sha-256:fictional-scope",
  "populationManifestDigest": "sha-256:fictional-population",
  "nodesDigest": "sha-256:fictional-nodes",
  "edgesDigest": "sha-256:fictional-edges",
  "coverageClaimsDigest": "sha-256:fictional-coverage",
  "dispositionsDigest": "sha-256:fictional-dispositions",
  "ownerDecisionsDigest": "sha-256:fictional-owner-decisions",
  "firstFailureDigest": null,
  "publicationState": "VERIFIED_SANITIZED",
  "productionChangeAuthorized": false,
  "removalAuthorized": false,
  "createdAtUtc": "2026-08-01T12:00:00Z"
}
```

Normative rules:

- graph nodes/edges are strict typed contracts, not arbitrary property graphs;
- every high-risk edge (`WRITES`, `EXECUTES`, `AUTHENTICATES_AS`, `EXPORTS_TO`) cites direct static/configuration/runtime evidence; interview-only assertion is not fact;
- owner, purpose, criticality, and disposition remain typed decision records, not inferred node fields;
- `productionChangeAuthorized` and `removalAuthorized` remain false in discovery output; separate command authorization decides changes;
- any revision is immutable and superseded by a new revision.

### 5.5.2 `AuthorityEpochV1`

```json
{
  "contract": "uam.migration.authority-epoch",
  "version": "1.0.0",
  "authorityEpochId": "019d0000-0000-7000-8000-000000006010",
  "sequence": 42,
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "cohortId": "fictional-cohort-a",
  "semanticSurfaceId": "edge-site-events-v1",
  "authority": "FROZEN_NO_AUTHORITY",
  "effectiveBoundary": {
    "kind": "SOURCE_RANGE_MANIFEST",
    "manifestDigest": "sha-256:fictional-boundary"
  },
  "priorAuthorityEpochId": "019d0000-0000-7000-8000-000000006009",
  "transitionCommandId": "019d0000-0000-7000-8000-000000006011",
  "reasonCode": "CUTOVER_FENCE",
  "evidenceDigest": "sha-256:fictional-authority-evidence",
  "issuedAtUtc": "2026-08-01T12:10:00Z"
}
```

Rules:

- sequence strictly increases; same sequence/different bytes is a security failure;
- authority is exactly one of `LEGACY_AUTHORITY`, `FROZEN_NO_AUTHORITY`, `NEW_AUTHORITY`;
- no `BOTH`, shadow, read-only, probation, or decommission state appears here;
- rollback is a new higher sequence and new boundary;
- the trusted control-plane context supplies realm; payload realm is consistency evidence;
- activation, final authorization decision, audit, and required control/outbox work commit atomically in the migration-control transaction;
- external legacy/endpoint/network actions are referenced observations, not claimed part of that transaction.

### 5.5.3 `ComparisonResultV1`

```json
{
  "contract": "uam.migration.comparison-result",
  "version": "1.0.0",
  "comparisonResultId": "019d0000-0000-7000-8000-000000006020",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "cohortId": "fictional-cohort-a",
  "profileId": "edge-site-bucket-v1",
  "profileRevision": 3,
  "windowId": "019d0000-0000-7000-8000-000000006021",
  "runGeneration": 1,
  "leftDigestManifest": "sha-256:fictional-left",
  "rightDigestManifest": "sha-256:fictional-right",
  "rangeClosureManifest": "sha-256:fictional-closure",
  "exactInvariantState": "PASS",
  "materialMismatchCount": 0,
  "pendingOwnerDecisionCount": 0,
  "unknownMismatchCount": 0,
  "toleranceDecisionManifest": "sha-256:fictional-tolerances",
  "knownDefectDecisionManifest": "sha-256:fictional-defects",
  "ownerApprovalManifest": "sha-256:fictional-approvals",
  "result": "PASSED_FOR_DECLARED_PROFILE_ONLY",
  "limitations": ["NO_PERSON_LEVEL_COMPARISON", "HISTORICAL_SHADOW_NOT_PROMOTABLE"],
  "evidenceDigest": "sha-256:fictional-comparison-evidence"
}
```

Rules:

- `PASS` requires both ranges closed under the exact profile and no exact-invariant failure;
- any unknown material mismatch or owner decision pending prevents `PASSED_FOR_DECLARED_PROFILE_ONLY`;
- owner approvals bind the exact bytes of the result, profile, scope, tolerance/defect registers, and limitations;
- this result does not authorize authority transfer by itself;
- rerun/late data creates a new generation and superseding record; prior evidence is immutable.

### 5.5.4 `CutoverPlanV1`

```json
{
  "contract": "uam.migration.cutover-plan",
  "version": "1.0.0",
  "cutoverPlanId": "019d0000-0000-7000-8000-000000006030",
  "planRevision": 7,
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "cohortManifestDigest": "sha-256:fictional-cohort",
  "releaseDigest": "sha-256:fictional-release",
  "contractBundleDigest": "sha-256:fictional-contracts",
  "storageCompatibilityDigest": "sha-256:fictional-storage",
  "privacyCeilingDigest": "sha-256:fictional-ceiling",
  "configurationCandidateDigest": "sha-256:fictional-config",
  "comparisonResultDigest": "sha-256:fictional-comparison",
  "legacyQuiesceProfileId": "legacy-quiesce-v1",
  "authorityBoundaryProfileId": "source-range-fence-v1",
  "newRollbackTargetDigest": "sha-256:fictional-n-minus-one",
  "legacyRollbackExpiresAtUtc": "2026-08-15T00:00:00Z",
  "requiredMonitorManifestDigest": "sha-256:fictional-monitors",
  "ringDefinitionDigest": "sha-256:fictional-ring",
  "runbookDigest": "sha-256:fictional-runbook",
  "ownerProfileDigest": "sha-256:fictional-owners",
  "state": "CANDIDATE_NOT_AUTHORIZED"
}
```

Rules:

- all examples are fictional; production values require human authority and current evidence;
- a changed release/configuration/contract/storage/monitor/cohort digest creates a new revision and resets applicable bake;
- `legacyRollbackExpiresAtUtc` cannot be later than trust-removal start and cannot auto-extend;
- an absent safe new rollback target blocks ring entry;
- the plan cannot encode credentials, scripts, SQL, hostnames, addresses, arbitrary paths, or dynamic commands;
- candidate validation and production change approval are separate states.

### 5.5.5 `CutoverCohortStateV1`

```json
{
  "contract": "uam.migration.cutover-cohort-state",
  "version": "1.0.0",
  "cohortStateId": "019d0000-0000-7000-8000-000000006040",
  "cutoverPlanId": "019d0000-0000-7000-8000-000000006030",
  "cutoverStateVersion": 18,
  "ring": "CUT-C1_ENGINEERING_CANARY",
  "workflowState": "NEW_PRIMARY_PROBATION",
  "currentAuthorityEpochId": "019d0000-0000-7000-8000-000000006010",
  "bakeStartedAtUtc": "2026-08-01T12:20:00Z",
  "countedBakeDurationClass": "PENDING_REQUIRED_COVERAGE",
  "monitorFreshnessState": "ALL_CURRENT",
  "hardFailureState": "NONE",
  "rollbackAvailability": "NEW_N_MINUS_ONE_AND_PRE_TRUST_LEGACY",
  "firstFailureDigest": null,
  "evidenceDigest": "sha-256:fictional-cohort-state"
}
```

Rules:

- `workflowState` never establishes authority; `currentAuthorityEpochId` does;
- `cutoverStateVersion` is optimistic concurrency for workflow only and is independent of authority sequence;
- bake does not count during a required monitor outage, changed digest, unresolved hard failure, or unsupported environment;
- `rollbackAvailability` is computed from current plan, trust-removal state, expiry, and evidence; it is not manually asserted by browser input;
- same command ID/same digest is idempotent; same ID/different digest is an integrity conflict.

### 5.5.6 `CredentialRemovalCaseV1`

```json
{
  "contract": "uam.migration.credential-removal-case",
  "version": "1.0.0",
  "credentialRemovalCaseId": "019d0000-0000-7000-8000-000000006050",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "credentialReferenceAlias": "hmac256:fictional-credential",
  "credentialClass": "SQL_LOGIN_REFERENCE",
  "purposeClass": "LEGACY_ENDPOINT_WRITER",
  "consumerManifestDigest": "sha-256:fictional-consumers",
  "ownerApprovalDigest": "sha-256:fictional-owner-approval",
  "disableOrRevokeEvidenceDigest": "sha-256:fictional-disable",
  "sessionTerminationEvidenceDigest": "sha-256:fictional-sessions",
  "permissionOwnershipCleanupDigest": "sha-256:fictional-permissions",
  "secretCopyRemovalDigest": "sha-256:fictional-secret-copies",
  "networkDenialEvidenceDigest": "sha-256:fictional-network",
  "failedUseMonitorEvidenceDigest": "sha-256:fictional-monitor",
  "state": "VERIFIED_REMOVED",
  "reactivationPermitted": false
}
```

Rules:

- no secret value, login name, address, connection string, certificate subject, or private-key material appears in the shareable record;
- `VERIFIED_REMOVED` requires all applicable layers and named owner approval;
- a shared indispensable consumer keeps state `BLOCKED_SHARED_DEPENDENCY`;
- `reactivationPermitted` is always false after verified removal;
- a new credential is a new case/generation and cannot be treated as rollback.

### 5.5.7 `BufferDispositionRecordV1`

```json
{
  "contract": "uam.migration.buffer-disposition-record",
  "version": "1.0.0",
  "bufferDispositionId": "019d0000-0000-7000-8000-000000006060",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "bufferClass": "LEGACY_DEFERRED_EXECUTABLE_SQL_CSV",
  "scopeManifestDigest": "sha-256:fictional-buffer-scope",
  "countAndAgeManifestDigest": "sha-256:fictional-buffer-counts",
  "creationFrozenEvidenceDigest": "sha-256:fictional-freeze",
  "disposition": "QUARANTINE_FOR_INVESTIGATION_OR_HOLD",
  "semanticProfileDigest": null,
  "ownerDecisionDigest": "sha-256:fictional-owner-decision",
  "beforeDigest": "sha-256:fictional-before",
  "afterDigest": null,
  "state": "FROZEN_PENDING_ACTION",
  "rawExecutionPermitted": false
}
```

Rules:

- disposition is a closed enum; no arbitrary action or code;
- `DRAIN_UNDER_LEGACY_BEFORE_FENCE` becomes invalid after the final legacy fence;
- typed transform requires an approved semantic profile/oracle and one-effect identity evidence;
- discard requires human policy and evidence; it is never an engineering default;
- raw buffer content is absent from portal, general logs, metrics, and shareable evidence.

### 5.5.8 `ResidualExceptionV1`

```json
{
  "contract": "uam.migration.residual-exception",
  "version": "1.0.0",
  "residualExceptionId": "019d0000-0000-7000-8000-000000006070",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "exceptionType": "UNREACHABLE_DEVICE",
  "scopeManifestDigest": "sha-256:fictional-exception-scope",
  "riskClass": "HIGH_CONTAINED",
  "ownerFunction": "ENDPOINT_OPERATIONS",
  "nextActionCode": "REMOVE_AND_REENROLL_ON_RETURN",
  "containmentProfileId": "REVOKED_CREDENTIAL_AND_DENIED_PATH",
  "blocksGates": ["B06-RESIDUAL", "B06-DECOM"],
  "expiresAtUtc": "2026-09-01T00:00:00Z",
  "evidenceDigest": "sha-256:fictional-exception-evidence",
  "status": "CONTAINED_OPEN"
}
```

Rules:

- every exception has exact scope, owner, containment, next action, expiry, evidence, and gate impact;
- expiry never auto-renews; it becomes `EXPIRED_UNRESOLVED`;
- an exception cannot authorize legacy writes, credential recreation, or hidden acceptance;
- final risk authority may accept a named contained exception only if the approved acceptance profile permits it; the technical record still states what was not proved.

### 5.5.9 `DecommissionAcceptanceRecordV1`

```json
{
  "contract": "uam.migration.decommission-acceptance-record",
  "version": "1.0.0",
  "decommissionAcceptanceRecordId": "019d0000-0000-7000-8000-000000006080",
  "realmId": "019d0000-0000-7000-8000-000000006002",
  "scopeManifestDigest": "sha-256:fictional-final-scope",
  "lastAuthorityEpochId": "019d0000-0000-7000-8000-000000006010",
  "discoveryGraphDigest": "sha-256:fictional-discovery",
  "reconciliationDecisionDigest": "sha-256:fictional-reconciliation",
  "rollbackBoundaryDecisionDigest": "sha-256:fictional-rollback-boundary",
  "archiveReadinessDigest": "sha-256:fictional-archive",
  "credentialRemovalManifestDigest": "sha-256:fictional-credentials",
  "networkDenialManifestDigest": "sha-256:fictional-network",
  "bufferDispositionManifestDigest": "sha-256:fictional-buffers",
  "componentCleanupManifestDigest": "sha-256:fictional-cleanup",
  "residualObservationDigest": "sha-256:fictional-residual",
  "exceptionManifestDigest": "sha-256:fictional-exceptions",
  "independentEvaluationDigest": "sha-256:fictional-evaluation",
  "ownerApprovalManifestDigest": "sha-256:fictional-final-approvals",
  "technicalResult": "PASS_WITH_DECLARED_LIMITATIONS",
  "limitations": ["UNMANAGED_RECIPIENT_COPIES_NOT_PROVABLE"],
  "legalCompletionClaimed": false,
  "productionDecision": "NOT_RECORDED_IN_TECHNICAL_SCHEMA"
}
```

Rules:

- the builder cannot set owner approvals or production decision;
- the independent evaluator recomputes every referenced predicate and evidence freshness;
- any missing/expired/conflicting evidence produces `HOLD`, not partial silent pass;
- owner approvals bind the exact record bytes and declared limitations;
- late findings create a linked reopen record; this record remains immutable;
- the schema cannot claim legal completion, perfect absence, forensic truth, or external-copy erasure.

## 5.6 State machines

### 5.6.1 Discovery maturity

```text
DISC-D0_T1_ONLY
  -> DISC-D1_LAB_PROVED
       strict contracts, parser/query safety, no-mutation, sanitizer/canaries
  -> DISC-D2_BOUNDED_READONLY
       one approved non-production target per class; exact scope and cleanup
  -> DISC-D3_REPRESENTATIVE_COVERAGE
       population reconciliation, runtime/static/interview facets, business cycles
  -> DISC-D4_DISPOSITION_COMPLETE
       every material item owner-approved with validation/rollback/removal proof

Any secret/raw escape, unexplained mutation, cross-realm result, population conflict,
unknown material writer/consumer, or cleanup failure -> SAFETY_HOLD.
```

A later revision may supersede an earlier maturity result. Maturity is profile/scope/evidence-specific and does not transfer automatically across realms, environments, or time.

### 5.6.2 Validation maturity

```text
VAL-V0_FIXTURE_ONLY
  -> VAL-V1_SHADOW_ISOLATED
       no endpoint dual-write; no shadow ordinary egress
  -> VAL-V2_RANGES_CLOSED
       exact profile, closure, canonical/digest evidence
  -> VAL-V3_SEMANTICS_ACCEPTED
       report/config semantics; owned defects/tolerances; no unknown material mismatch
  -> VAL-V4_CUTOVER_ELIGIBLE
       common fence, rollback drill, owner approvals, current evidence

Exact invariant failure -> FAILED_SAFETY_HOLD.
Late data -> new runGeneration; prior result SUPERSEDED, never edited.
```

### 5.6.3 Business authority

```text
LEGACY_AUTHORITY(n)
  -> FROZEN_NO_AUTHORITY(n+1)       # legacy quiesced / boundary under proof
  -> NEW_AUTHORITY(n+2)             # new-only ordinary effects

Pre-trust rollback, only before expiry:
NEW_AUTHORITY(n)
  -> FROZEN_NO_AUTHORITY(n+1)
  -> LEGACY_AUTHORITY(n+2)

After trust removal begins:
NEW_AUTHORITY(n)
  -> NEW_AUTHORITY(n+1)             # new release/capability change
  or remain NEW_AUTHORITY with collection paused

Forbidden:
LEGACY_AUTHORITY + NEW_AUTHORITY for same scope/epoch
lower sequence
reusing a prior epoch
shadow-as-authority
payload/body/browser selecting authority
```

### 5.6.4 Cutover cohort workflow

```text
DRAFT
  -> VALIDATED_CANDIDATE
  -> PRESTAGED_DISABLED
  -> BAKING_SHADOW
  -> TRANSFER_PREPARED
  -> LEGACY_QUIESCING
  -> FENCE_VERIFYING
  -> NEW_PRIMARY_PROBATION
  -> NEW_PRIMARY_ACCEPTED
  -> LEGACY_READONLY_VERIFYING
  -> TRUST_REMOVAL
  -> RESIDUAL_MONITORING
  -> COMPONENT_CLEANUP
  -> DECOMMISSION_ACCEPTANCE_PENDING
  -> DECOMMISSIONED_TECHNICAL

Any hard failure / stale monitor / missing owner / changed digest
  -> SAFETY_HOLD

From eligible pre-trust states only:
  -> PRE_TRUST_ROLLBACK_PREPARING
  -> FENCE_VERIFYING
  -> LEGACY_REACTIVATED_HIGHER_EPOCH

After TRUST_REMOVAL starts, no transition to LEGACY_REACTIVATED exists.
```

### 5.6.5 Credential removal

```text
DISCOVERED
  -> OWNERS_AND_CONSUMERS_RESOLVED
  -> DISABLE_OR_REVOKE_REQUESTED
  -> NEW_AUTHENTICATION_DENIED
  -> ACTIVE_SESSIONS_TERMINATED
  -> PERMISSIONS_OWNERSHIP_JOBS_CLEANED
  -> SECRET_COPIES_ROTATED_OR_REMOVED
  -> NETWORK_PATHS_DENIED
  -> FAILED_USE_MONITOR_VERIFIED
  -> VERIFIED_REMOVED

Any shared dependency, successful authentication/write, surviving session/path,
unknown copy, or cleanup failure -> FAILED_HOLD.

VERIFIED_REMOVED has no reactivation transition.
```

### 5.6.6 Buffer disposition

```text
DISCOVERED
  -> INVENTORIED_VALUE_FREE
  -> CREATION_FROZEN
  -> OWNER_DISPOSITION_PENDING
      -> DRAIN_APPROVED_PRE_FENCE
      -> TRANSFORM_APPROVED_TYPED
      -> QUARANTINE_APPROVED
      -> DISCARD_APPROVED_HUMAN

DRAIN_APPROVED_PRE_FENCE -> DRAINING -> RECONCILED_VERIFIED
TRANSFORM_APPROVED_TYPED -> TRANSFORMING -> ORACLE_RECONCILED -> VERIFIED
QUARANTINE_APPROVED -> QUARANTINED_HELD
DISCARD_APPROVED_HUMAN -> DISCARDED -> EVIDENCE_VERIFIED

Raw execution, post-fence drain, count/digest conflict, or silent loss -> FAILED_HOLD.
```

### 5.6.7 Archive/read-only

```text
UNDECIDED
  -> OWNER_PURPOSE_FIELDS_ACCESS_APPROVED
  -> COPY_OR_TOPOLOGY_PREPARED
  -> APPLICATION_MUTATION_DISABLED
  -> DB_RIGHTS_AND_STATE_READONLY
  -> SESSIONS_JOBS_PATHS_CLEANED
  -> WRITE_PROBES_PASSED
  -> RESTORE_READBLOCK_PROVED
  -> AUDITED_READS_PROVED
  -> ARCHIVE_READY_TECHNICAL
  -> HUMAN_READ_ENABLE_DECISION

Any successful write, unaudited read, stale authority, restore mutation,
undefined retention/owner, or lifecycle conflict -> READ_BLOCKED_HOLD.
```

### 5.6.8 Final acceptance and late findings

```text
ACCEPTANCE_CANDIDATE_BUILT
  -> INDEPENDENT_EVALUATION_PASS
  -> OWNER_APPROVALS_COMPLETE
  -> DECOMMISSIONED_TECHNICAL

Any false predicate / stale evidence / expired exception / missing approval
  -> ACCEPTANCE_HOLD

DECOMMISSIONED_TECHNICAL
  -> LATE_FINDING_OPENED
  -> CONTAINMENT_AND_REMEDIATION
  -> REEVALUATION_REQUIRED

Historical acceptance record remains immutable throughout.
```

## 5.7 Transaction and authority boundaries

1. **Discovery run:** source reads occur outside the evidence publication transaction. The local staging package is private and incomplete until schema, canary, lineage, hash, and cleanup verification pass; publication is atomic by manifest/reference, not by pretending the sources are transactional.
2. **Comparison run:** extraction/canonicalization occurs in bounded processes. Closed range manifests and digest results are immutable. A final comparison result transaction records exact profiles, roots, mismatches, owner-decision references, audit, and evidence status.
3. **Authority transition:** final authorization decision, new `AuthorityEpochV1`, command outcome, audit event, and control outbox commit in one relational transaction. External quiesce/activation actions are preconditions/observations, not participants in that database transaction.
4. **Cutover commands:** every external action has immutable command ID, exact inventory target, desired state, idempotency digest, authorization, expiry, evidence expectation, and reconciliation. Same command/same digest returns prior outcome; same ID/different digest is conflict.
5. **Read-only transition:** application route/job state, runtime identity change, database permission/state, session termination, and network denial are independent actions. The archive state advances only after every applicable observation passes.
6. **Credential removal:** secret values never enter control contracts. External systems retain their own authoritative credential status; UAM stores aliases, typed observations, evidence digests, and owner decisions.
7. **Buffer transform:** raw buffer is local restricted input. The target receives only schema-valid minimized typed events after identity/privacy/oracle validation. Event/fact commit uses accepted one-effect transactions; migration evidence references the source-buffer digest without retaining raw code.
8. **Final acceptance:** evidence builder and evaluator are separate. Evaluation has read-only access to authoritative states. Human approvals are separately authenticated commands and audit events; the builder cannot manufacture them.
9. **No cross-store atomicity claim:** endpoint store, legacy database, new database, PKI, secrets manager, firewall, deployment platform, archive, object storage, SIEM, and CMDB are reconciled through idempotent state/evidence, not a distributed transaction fiction.

## 5.8 Normative cutover algorithm

For one realm/cohort/surface:

1. Freeze the exact discovery graph revision, owner/disposition manifest, comparison result, configuration candidate, cohort manifest, release, contracts, storage compatibility, privacy ceiling, monitors, runbooks, support coverage, and rollback profile.
2. Verify every predecessor gate relevant to the exact endpoint/server/database/portal/archive topology.
3. Pre-stage the signed new payload and configuration with collection disabled or shadow-only.
4. Prove no endpoint dual-write, no shadow business egress, and complete monitor positive controls.
5. Complete the human-approved shadow bake and required coverage classes. Unknown, stale, or unowned results pause.
6. Freeze non-cutover legacy changes. Freeze creation of new deferred legacy work and record value-free counts/digests.
7. Disable known legacy schedules/services/jobs/writers for the cohort using exact inventory-bound commands.
8. Capture the final legacy range/watermark and verify no successful writes during the quiesce interval.
9. Commit `FROZEN_NO_AUTHORITY` at the proved boundary.
10. Verify the new start boundary and explicit first-run/gap/overlap decision.
11. Commit `NEW_AUTHORITY` at a higher epoch and activate the new system.
12. Enter new-primary probation. Preserve endpoint buffers and accepted one-effect/receipt semantics. Hard failures pause.
13. If probation passes, record owner-approved reconciliation and mark new primary accepted operationally.
14. Before rollback expiry, either keep the pre-trust legacy rollback contingency explicitly current or close it early by owner decision. No hidden rollback option exists.
15. Move legacy application/database to layered verified read-only and prepare the approved archive.
16. Begin trust removal: credentials/certificates/sessions/permissions/secrets/network paths.
17. Once trust removal starts, close legacy rollback permanently. Record `LEGACY_TRUST_REVOKED` in the workflow, not as a business authority value.
18. Run bounded residual monitoring, reconcile inventory/CMDB/packages/backups, and process expiring exceptions.
19. Remove legacy runtime/components and prove they do not reappear through repair/deployment policy.
20. Re-run required game day, restore/read-only, support, accessibility, and cleanup evidence if release/topology changed.
21. Build the decommission acceptance candidate; independently recompute; collect required owner approvals; record the separate production/risk decision.

## 5.9 Hard automatic-pause conditions

Any one of the following MUST pause the affected scope and dependent promotion:

- forbidden-value or privacy canary outside the approved raw boundary;
- cross-realm/session/installation read, write, cache, evidence, archive, comparison, or audit result;
- endpoint artifact, credential, or route can reach both destinations;
- legacy and new both create ordinary effects for the same scope/epoch;
- cursor/progress ahead of durable effects, changed natural identity, duplicate ordinary effect, or receipt conflict;
- unauthorized, incomplete, mixed, stale, frozen, downgraded, or wrong-digest release executes;
- shadow data reaches an ordinary consumer;
- range/window is open, forked, stale, or incomparable;
- exact reconciliation mismatch in loss, duplicate, realm, privacy, authority, identity, progress, receipt, audit, or evidence integrity;
- unknown material mismatch or expired/unowned tolerance/defect;
- required monitor stale/unavailable or positive control fails;
- successful unauthorized legacy write after quiesce/read-only deadline;
- active legacy credential/session/path survives its gate;
- unacknowledged data drops or buffer is silently discarded;
- privileged command commits without authorization/audit;
- archive/restored environment exposes mutation or ordinary egress;
- new rollback target cannot safely operate the current store/contracts;
- cleanup leaves or recreates a removable service, task, package, process, key, certificate, rule, script, job, or test artifact;
- a required owner approval is absent, revoked, expired, or bound to different bytes.

Automatic pause never authorizes credential recreation, legacy reactivation, data deletion, or final acceptance.

## 5.10 Primary gate expression

The independent evaluator implements the logical minimum below. It may add narrower owner-approved predicates but cannot remove these:

```text
B06_DECOM_PASS =
  input_manifest_exact
  AND contracts_strict_and_current
  AND discovery_safety_pass
  AND discovery_population_reconciled
  AND every_material_item_disposition_approved
  AND no_unknown_material_writer_consumer_path
  AND endpoint_dual_write_structurally_impossible
  AND shadow_business_egress_zero
  AND exact_reconciliation_invariants_pass
  AND report_config_semantics_approved
  AND tolerance_defect_records_current_owned
  AND no_unknown_material_mismatch
  AND authority_fence_no_unproved_gap_or_overlap
  AND new_release_and_n_minus_one_compatible
  AND ring_required_coverage_complete
  AND all_required_monitors_current_positive_controlled
  AND layered_archive_readonly_pass
  AND all_writer_credentials_sessions_rights_secrets_paths_removed
  AND all_buffers_dispositioned_and_reconciled
  AND residual_successful_legacy_writes_zero_in_declared_scope
  AND all_failed_attempts_classified
  AND every_exception_current_owned_contained_and_allowed_by_profile
  AND component_package_job_rule_cmdb_cleanup_pass
  AND restore_and_readblock_evidence_current
  AND support_game_day_accessibility_cleanup_pass
  AND independent_evidence_evaluation_pass
  AND every_required_owner_approval_bound_to_exact_record
  AND separate_production_risk_decision_recorded
```

Any `UNKNOWN`, stale evidence, missing owner, conflicting digest, blind interval outside the approved profile, or hard failure makes the result `HOLD`.

## 5.11 Common error and recovery taxonomy

| Family | Example codes | Default action |
|---|---|---|
| Contract/evidence | `SCHEMA_INVALID`, `UNKNOWN_FIELD`, `DIGEST_CONFLICT`, `EVIDENCE_TAMPER`, `FIRST_FAILURE_MISSING` | Stop; result invalid. |
| Scope/realm | `SCOPE_EXPIRED`, `TARGET_OUTSIDE_POPULATION`, `REALM_VIOLATION`, `CROSS_REALM_EDGE` | Immediate safety hold. |
| Discovery safety | `MUTATION_OBSERVED`, `EXECUTION_ATTEMPT`, `SECRET_ESCAPE`, `RAW_VALUE_ESCAPE`, `ARBITRARY_INPUT` | Stop run; incident/cleanup. |
| Coverage | `UNREACHABLE`, `ACCESS_DENIED`, `TELEMETRY_GAP`, `CLOCK_UNKNOWN`, `POPULATION_CONFLICT`, `CONTRADICTORY_EVIDENCE` | Never absence; owner review/hold. |
| Authority/shadow | `ENDPOINT_DUAL_WRITE`, `AUTHORITY_CONFLICT`, `LOWER_EPOCH`, `SHADOW_EGRESS` | Immediate pause/security incident. |
| Range/progress | `WINDOW_NOT_CLOSED`, `RANGE_GAP`, `RANGE_OVERLAP`, `CHECKPOINT_AHEAD`, `LATE_PENDING` | Hold comparison/cutover. |
| Canonicalization/digest | `CANONICALIZATION_DIFFERENCE`, `KEY_PROFILE_MISMATCH`, `MULTISET_ROOT_MISMATCH`, `RESOURCE_LIMIT` | Result invalid or bounded retry after profile review. |
| Semantics | `REPORT_UNAPPROVED`, `UNREPRESENTABLE`, `TOLERANCE_EXPIRED`, `DEFECT_UNOWNED`, `UNKNOWN_MISMATCH` | Human decision; blocking by default. |
| Configuration | `CONFIG_BROADENING`, `CONFIG_AMBIGUITY`, `PROHIBITED_ITEM`, `SOURCE_PRECEDENCE_CONFLICT` | Reject candidate/hold. |
| Cutover | `MONITOR_STALE`, `HARD_SIGNAL`, `FENCE_AMBIGUOUS`, `ROLLBACK_TARGET_UNSAFE`, `PLAN_DIGEST_CHANGED` | Pause; recompute or new plan. |
| Read-only/archive | `WRITE_PROBE_SUCCEEDED`, `MUTATION_ROUTE_PRESENT`, `SESSION_STILL_ACTIVE`, `RESTORE_WRITE_PATH`, `UNAUDITED_READ` | Read-block and incident. |
| Credential/network | `CREDENTIAL_VALID`, `SESSION_SURVIVES`, `RIGHT_REMAINS`, `SECRET_COPY_REMAINS`, `ALTERNATE_PATH_SUCCEEDS` | Trust-removal hold. |
| Buffer | `POST_FENCE_DRAIN`, `RAW_EXECUTION`, `COUNT_DIGEST_CONFLICT`, `SILENT_DISCARD`, `TRANSFORM_IDENTITY_CONFLICT` | Quarantine/hold. |
| Residual | `SUCCESSFUL_LEGACY_WRITE`, `UNKNOWN_RECURRING_ATTEMPT`, `EXCEPTION_EXPIRED`, `COMPONENT_REAPPEARED`, `MONITOR_BLIND` | Reopen/hold; contain. |
| Approval | `OWNER_UNASSIGNED`, `APPROVAL_EXPIRED`, `APPROVAL_DIGEST_MISMATCH`, `SELF_APPROVAL_FORBIDDEN` | Deny transition. |
| Cleanup | `PROCESS_REMAINS`, `FILE_OR_KEY_REMAINS`, `RULE_REMAINS`, `TEST_ARTIFACT_REMAINS`, `CLEANUP_UNVERIFIED` | Gate invalid. |

Errors and evidence MUST NOT echo raw SQL, scripts, paths, URLs, hostnames, users, credentials, addresses, command lines, activity values, or arbitrary exceptions.

## 5.12 Privacy-safe observability, cardinality, and accessibility

Metrics MAY use only finite release-owned dimensions such as:

```text
component_class
stage
adapter_id
source_family
ring_class
workflow_state
path_role
comparison_profile_major
mismatch_family
reason_family
outcome_family
monitor_freshness_class
credential_state_class
network_path_state
buffer_disposition
archive_state
exception_type
```

Metrics MUST NOT label by realm, tenant, user, device, installation, session, host, address, port, path, URL, task/service/login/certificate/secret name, SQL text, command line, event/batch/case/exception/evidence ID, digest, report parameters, or arbitrary error. Exact opaque IDs and digests belong only in access-controlled evidence.

The route/action/adapter/metric catalogue MUST compute a theoretical maximum series count in CI. An unknown dynamic label fails the build. Overflow aggregates to a finite `overflow` outcome and alerts; it does not create an unbounded series or discard gate evidence.

Accessibility is part of correctness for owner review, pause, rollback, exception, credential, archive, and final-acceptance workflows:

- every state and limitation is programmatically exposed and not color-only;
- complete workflows are keyboard operable with visible focus and predictable restoration;
- asynchronous holds, monitor failures, expiry, and late findings are announced;
- exact scope, authority, rollback availability, risk, owner, expiry, and limitations are available as text/table equivalents;
- time-limited approvals warn accessibly but do not extend authority;
- destructive or irreversible milestones require accessible review and error prevention;
- automated scanning is supplemented by manual keyboard, screen-reader, zoom/reflow, forced-colors, and representative task evidence for the approved browser/AT matrix.

---

# 6. Human decision register

Research and tooling do not make the decisions below. Role names identify accountable functions, not assigned people. The conservative default is disabled, read-only, exact-only, blocked, or `INVESTIGATE_QUARANTINE`.

| ID | HUMAN DECISION | Conservative temporary default | Accountable role/function | Consequence of delay |
|---|---|---|---|---|
| HD06-01 | Authority to inspect exact systems, fields, evidence classes, and time windows | No real connection; T1/offline only. | System/Data Owner with Security, Privacy, Legal/Workforce Governance as applicable | Estate discovery and every dependent migration claim remain blocked. |
| HD06-02 | Authoritative population sources and reconciliation owner | Population conflicts remain `UNKNOWN`; no retirement. | Asset/CMDB Owner + Endpoint/Server/Database Owners | Coverage cannot be bounded; hidden systems may remain. |
| HD06-03 | Named owner and approved purpose for every legacy item/consumer/configuration | `UNASSIGNED`, purpose `UNKNOWN`, disposition `INVESTIGATE_QUARANTINE`. | Product/Data/Application Governance | Item cannot be preserved, changed, retired, or removed. |
| HD06-04 | Consumer criticality and outage consequence | `UNDECIDED`; no removal or equivalence promise. | Business/Product Owner + Operations/Risk | Validation, rollback, support, and cutover profile cannot be selected. |
| HD06-05 | Final disposition for every behavior, report, script, schedule, integration, and configuration | No target behavior inferred from legacy; no removal. | Accountable Service/Data Owner + Architecture | Discovery graph cannot reach `DISC-D4`; cutover remains blocked. |
| HD06-06 | Required report/export/aggregate semantics | No report-equivalence claim; profile disabled. | Report/Data Product Owner + all affected consumer owners | Reconciliation cannot distinguish defect, intended change, or loss. |
| HD06-07 | Accepted legacy defects and expiry | Register empty; every candidate mismatch remains blocking. | Product/Data Owner with Security/Privacy as relevant | Target behavior cannot be validated or deliberately changed. |
| HD06-08 | Tolerance ownership, scope, direction, tests, review, and expiry | No active tolerances. | Product/Data Governance | Only exact comparisons may pass; more surfaces remain blocked. |
| HD06-09 | Real parallel-run legal/business purpose, prohibited uses, fields, cohort, access, and retention | T1 fictional data only. | Data Controller/Business Product Owner + Legal/Privacy/Workforce Governance | No employee/production shadow run. |
| HD06-10 | Identity level for comparison and break-glass sampling | Source-range/aggregate only; break-glass disabled. | Data Controller/Product/Privacy/IAM + Independent Security | Fine-grained mismatch localization may remain unavailable; no broadened access. |
| HD06-11 | Time precision, time-zone, bucket, rounding, null/default, and late-data semantics | Exact approved UTC/bucket profile only; unknown legacy-local behavior blocks. | Data Product/Report Owner + Privacy | Time-related report validation and cutover range remain blocked. |
| HD06-12 | Configuration source of truth and precedence | Conflicts block; target remains disabled. | Configuration/Product Governance + Privacy/Security | Configuration candidate cannot activate. |
| HD06-13 | Handling prohibited or unrepresentable legacy fields/outcomes | Explicit `PROHIBITED`/`UNREPRESENTABLE`; no default value. | Product Privacy + Report/Product Owner | Affected surface stays legacy-read-only, changes deliberately, or retires. |
| HD06-14 | Whether new instrumentation may be enabled | Do not enable; use existing evidence only. | Database/System Owner + Security/Privacy/SRE | Discovery recall may remain lower; retirement cannot rely on missing telemetry. |
| HD06-15 | Observation windows and required business cycles | Runtime silence never authorizes retirement. | Business Owner + SRE/Operations/Data Governance | Discovery and residual confidence remain bounded; rollout delayed. |
| HD06-16 | Unreachable-device handling | Revoke central trust, deny paths, contain, and remove/re-enroll on return; record exception. | Endpoint/Asset Owner + Security/Risk/Support | Residual exception remains open; final acceptance may be blocked or limited. |
| HD06-17 | Legacy buffer disposition | Freeze/quarantine; never execute or delete. | Data Owner + Records/Privacy/Legal + Data Reliability | Buffer cleanup and trust removal/final decommission remain blocked. |
| HD06-18 | Dynamic SQL/script outcome disposition | Quarantine; preserve no implementation by default. | Application/Data Owner + Architecture/Security | Related consumer/report migration remains blocked. |
| HD06-19 | Manual exports, spreadsheets, recipients, and external copies | `EXTERNAL_ACTION_REQUIRED` / unknown; no complete-erasure claim. | Data Owner/Privacy/Records/Integration Owner | Final record carries limitations; some retirement/lifecycle work remains open. |
| HD06-20 | Cutover go/no-go and final promotion authority | No authority transfer without named final authority and independent technical gate. | Designated Production/Change Risk Authority | Rings remain candidate/lab only. |
| HD06-21 | Immediate pause, new N-1 rollback, and pre-trust legacy rollback authorities | Any approved on-call may pause; only named authority selects rollback; no automatic legacy return. | Incident Command + Release/Risk Authority | Recovery may be slower, but unsafe rollback remains blocked. |
| HD06-22 | Common cutover fence and accepted gap/overlap policy | No cutover until exact fence is proved; report any unavoidable gap honestly. | Migration Control/Data Reliability/Product Owner | Authority transfer and rollback remain blocked. |
| HD06-23 | Legacy rollback expiry and contingency scope | Close before trust removal; no hidden indefinite option. | Product/Risk/Operations + Security | Trust removal cannot start while expiry/contingency is undefined. |
| HD06-24 | Ring membership, progression, bake, coverage, and promotion criteria | Explicit human promotion after all required coverage; no auto-promotion. | Product Risk + SRE/Support + Cutover Authority | Broader rollout delayed; exact evidence cannot be composed. |
| HD06-25 | SLO/RPO/RTO, acceptable coverage gap, backlog drain, archive availability, and support thresholds | No production objective or promise. | Product/Data Owner + SRE/Risk | Quantitative stop/promotion and recovery targets remain unset. |
| HD06-26 | Historical archive owner and purpose | Archive remains read-blocked under existing approved custody. | Data Controller/Records Management/Product Governance | Historical access and final acceptance remain blocked. |
| HD06-27 | Archive topology | Read-only copy behind new BFF is first candidate; no selection. | Data/Archive Architecture + Records + Operations | Implementation and restore/lifecycle proof remain provisional. |
| HD06-28 | Archive minimum fields, identity, precision, roles, exports, and audit | No person/activity detail or export. | Data Controller/Product/Privacy/IAM | Historical workflows may remain unavailable. |
| HD06-29 | Archive retention, deletion, legal hold, backup, and restore responsibilities | Preserve under existing approved policy; no new indefinite retention. | Records Management/Data Controller/Legal/SRE | Final data/runtime deletion and read enablement remain blocked. |
| HD06-30 | Temporary compatibility adapter allowance and expiry | None. | Integration/Product Owner + Architecture/Security | Indispensable consumers must migrate or remain on read-only legacy; decommission may delay. |
| HD06-31 | Credential, certificate, secret, login, account, and service-identity treatment | Do not copy values; no removal until owner/consumer map complete. | Security/IAM/PKI + Database/Platform Owners | Trust-removal gate remains open; risk exposure continues. |
| HD06-32 | Credential/certificate evidence horizon and revocation-status retention | Minimum opaque evidence under current audit policy; exact duration unset. | Security/IAM/PKI + Records | Final proof may expire or be insufficient for incident/restore horizons. |
| HD06-33 | Network routes, aliases, proxy/VPN/failover paths, and denial ownership | No production rule change; exact topology unknown. | Network Security/Architecture | Alternate path risk remains; trust removal cannot pass. |
| HD06-34 | Residual-monitoring sensors, fields, access, retention, and duration | Bounded failed-use/deny monitoring until known horizons close; exact profile unset. | Security Monitoring + Privacy/Records + Risk | Final assurance/acceptance delayed or limited. |
| HD06-35 | Residual exception classes and final risk acceptance | Every exception blocks unless a named authority accepts the exact contained scope. | Designated Production/Risk Authority + affected owner | Final decommission remains `HOLD` or carries explicit limitation. |
| HD06-36 | Final deletion of legacy runtime, data, backups, keys, and evidence | No deletion until archive/retention/restore/hold decisions and evidence pass. | Records/Data Controller + Security/SRE | Legacy cost and attack surface continue; irreversible loss is avoided. |
| HD06-37 | Support/on-call/staffing and incident coverage | Do not enter a real ring without named full-window coverage. | Engineering/Operations/Security Leadership | Real bake, rollback, and trust removal cannot start. |
| HD06-38 | Communications, workforce/customer notice, change calendar, and regulator obligations | Research/game-day internal synthetic communication only. | Product/Legal/Privacy/Communications | Production change cannot be scheduled or announced correctly. |
| HD06-39 | Accessibility, browser/AT, localization, and alternative review format | Standards-first CLI/HTML; no production approval UI until tested. | Product Accessibility/Product Owner/Support | Human decisions may be invalid or inaccessible; production gate blocked. |
| HD06-40 | Tool/platform selection, licensing, commercial support, and procurement | No new runtime dependency; native/approved APIs in lab only. | Architecture + Platform Owners + Security + Legal/Procurement | Some implementation work remains reference-only; no production support commitment. |
| HD06-41 | Discovery/evidence/shadow/archive/residual retention and deletion | Working set removed after verified run cleanup; all other periods unset. | Records/Data Governance/Privacy/Security | Real evidence publication and lifecycle cannot proceed safely. |
| HD06-42 | Budget and recurring staffing for discovery, comparison, lab, support, monitoring, and review | Pure/offline/T1 work only. | Product/Finance/Engineering Leadership | Estate-wide execution and recurring evidence renewal remain infeasible. |
| HD06-43 | Final decommission owner quorum and exact acceptance profile | No final technical acceptance without the required named functions. | Designated Production/Risk Authority + Architecture Governance | `B06-DECOM` remains blocked even if technical evidence passes. |
| HD06-44 | Production cutover, pilot, risk acceptance, and deployment | No production approval. | Designated Production/Risk Authority | Work remains T1/lab/read-only evidence only. |

## 6.1 Mandatory owner approvals at the batch gate

The following approvals are non-substitutable and must bind exact content digests:

1. **Every consumer disposition:** owner, purpose/criticality, preserve/change/retire/investigate decision, target/validation, rollback, and removal proof.
2. **Every configuration disposition:** source/precedence, preserve/change/retire/unrepresentable decision, loss/ambiguity manifest, no-broadening proof, activation and rollback candidate.
3. **Every reconciliation result:** exact profile/ranges/digests, material mismatches, tolerances/defects, limitations, and readiness conclusion.
4. **The rollback boundary:** legacy rollback expiry, allowed states/actions, fence method, new N-1 target, decision authority, and consequence after trust removal.
5. **Every credential/certificate removal:** consumer map, disable/revoke, active-session handling, permissions/ownership, secret copies, network paths, monitoring, and recovery consequence.
6. **Final decommission:** archive/lifecycle state, residual exceptions, cleanup, game-day currency, independent evaluation, limitations, and production/risk decision.

A role field, ticket reference, meeting note, or email is not sufficient unless the approved system records the authenticated approver, exact digest, authority, decision, time, expiry/review, and audit evidence.

## 6.2 Human decisions not required to begin safe T1 implementation

The following work does not require production policy choices, provided all inputs are fictional and all external adapters are disconnected/fake:

- strict schemas, enums, models, state machines, validators, and mutation tests;
- fictional discovery graph and independent oracle;
- static parser/query-pack safety tests;
- shadow isolation and no-egress architecture tests;
- canonicalization/digest/range/mismatch fixtures;
- cutover/fence/rollback simulation;
- disposable lab-only Windows/SQL actions and cleanup;
- evidence builder/evaluator, canaries, and accessibility scaffolding;
- ADR drafts, decision templates, owner-question guides, and runbooks.

No placeholder decision may be interpreted as a production default.

---

# 7. CLI experiment and measurement plan with evidence and pass/fail

## 7.1 Safety rules for every experiment

1. Use T1 fictional data, reserved names, placeholder connection references, lab-only credentials, and disposable/reverted environments unless an exact real read-only scope is separately approved.
2. Never print, attach, or persist actual hostnames, addresses, ports, users, paths, connection strings, credentials, private keys, SQL text, scripts, URLs, activity, or organization identifiers in the research package.
3. Inventory consumers and credential references read-only. Do not execute deferred SQL or a discovered script/report/job/action.
4. Production mutation is prohibited during research. Disable/revoke/KILL/firewall/certificate/task/service experiments run only in a disposable lab with synthetic principals and paths.
5. Every command records tool/source revision, dependency lock, schema bundle, environment profile, scope digest, seed/clock, start/end, exit, first failure, resource use, cleanup, and evidence hashes.
6. A zero exit code is not proof. Mandatory positive controls must be detected; deliberate harness mutation must make the gate fail.
7. Reruns do not overwrite the first failure. Nondeterminism is `FLAKY_UNCLASSIFIED` and blocks the gate.
8. Cleanup is a first-class result. Residual process, file, task, service, login, certificate, firewall rule, package, key, database object, or test credential fails the run.
9. Every real source query has a fixed immutable ID, exact result schema, expected permissions, row/byte/time/allocation bounds, cancellation, sensitive-field handling, and synthetic corpus.
10. Every claimed absence records population, target reachability, access, capture configuration, clock, retention/rollover, window, business-cycle coverage, and blind intervals.

## 7.2 Suggested repository/tool entry points

Logical commands are release-owned and accept only opaque references or local tool-owned fixture paths:

```text
dotnet run --project tools/Uam.LegacyDiscovery -- validate-scope --scope-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- inventory --scope-ref <opaque> --adapter-id <closed-id>
dotnet run --project tools/Uam.LegacyDiscovery -- parse-artifacts --run-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- build-graph --run-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- coverage --package-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- disposition-check --package-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- verify-pack --package-ref <opaque>
dotnet run --project tools/Uam.LegacyDiscovery -- cleanup --run-ref <opaque>

dotnet run --project tools/Uam.MigrationValidation -- verify-shadow-isolation --scenario-ref <opaque>
dotnet run --project tools/Uam.MigrationValidation -- canonical-vectors --profile-id <closed-id>
dotnet run --project tools/Uam.MigrationValidation -- compare-fixture --run-ref <opaque>
dotnet run --project tools/Uam.MigrationValidation -- verify-config-transform --snapshot-ref <opaque>
dotnet run --project tools/Uam.MigrationValidation -- gate --evidence-ref <opaque>

dotnet run --project tools/Uam.CutoverModel -- explore --scenario-ref <opaque>
dotnet run --project tools/Uam.CutoverModel -- verify-plan --plan-ref <opaque>
dotnet run --project tools/Uam.CutoverModel -- simulate-fence --plan-ref <opaque>
dotnet run --project tools/Uam.CutoverModel -- simulate-rollback --plan-ref <opaque>
dotnet run --project tools/Uam.DecommissionEvidence -- build --scope-ref <opaque>
dotnet run --project tools/Uam.DecommissionEvidence -- verify --record-ref <opaque>
```

There is no general `--sql`, `--script`, `--command`, `--host`, `--url`, `--credential`, source path, destination, or plugin parameter.

## 7.3 Ordered experiment matrix

| ID | CLI EXPERIMENT | Minimum method | Required evidence | Pass condition | Fail/stop condition |
|---|---|---|---|---|---|
| E06-01 | Allowlist/file identity and clean build | Hash exact eleven inputs; locked restore; two clean builds for canonical tools | Input manifest, lock/source map, build file manifests, reproducibility/variance report | Exact files only; no hidden input; unexplained build differences absent | Missing/substituted file, floating dependency, unexplained binary/source mismatch |
| E06-02 | Contract strictness and state-model mutation | Run valid/boundary/invalid/hostile/old-new vectors; mutate authority/ring/state rules | Vector results, mutation survivors, model counterexamples, schema closure report | Unknown/duplicate/wrong-case/over-limit rejected; no dual authority/lower epoch/state confusion | Any invalid authority accepted or required mutation survives |
| E06-03 | Discovery scope enforcement | Attempt wildcard, expired scope, target outside population, unknown adapter, path/query/host injection | Scope decision evidence and finite errors | All broadenings fail closed before source access | Operator can broaden scope or supply executable/source locator |
| E06-04 | Endpoint discovery zero-mutation | Synthetic Windows fixture; before/after services/tasks/files/registry/ACL/firewall/process/network; process tracing | Before/after manifests, trace, positive-control write attempt, cleanup receipt | Zero unexpected mutation intent/success outside private output; positive control detected/denied | Any unexplained mutation, profile crawl, residue, or missed positive control |
| E06-05 | SQL query-pack safety | Compile/lint fixed queries; hostile T-SQL; execute only SELECT metadata against synthetic SQL lab under least privilege | AST/lint report, effective permission, row/byte/time bounds, before/after DB config/object digest | Forbidden statement families impossible; no object/config/data mutation; partial visibility explicit | DDL/DML/EXEC/dynamic query allowed; source mutation; empty view treated as absence |
| E06-06 | Parser non-execution | Feed scripts with module imports, profiles, type initializers, macros, external refs, dynamic SQL, side effects | OS/process/network/file trace, parser outputs, canary detections | No child/runspace/network/external fetch/write; finite typed classifications | Any input executes, fetches, imports, writes, or leaks raw content |
| E06-07 | Sanitization and evidence-package integrity | Seed secret/raw/activity/path/address/SQL/script canaries in every source/sink/encoding; tamper files | Canary report, schema validation, hashes/root, first failure, cleanup | Every mandatory canary found before publication; sanitized pack contains none; tamper detected | One mandatory canary miss, raw escape, mutable publication, or hidden overwrite |
| E06-08 | Evidence graph completeness | Generate fictional graph with missing owner, orphan disposition, cross-realm edge, missing rollback/removal proof | Graph validator results and minimal counterexamples | All mandatory paths enforced; spreadsheet export round-trips only as view | Orphan/high-risk relation passes; owner inferred; cross-realm edge accepted |
| E06-09 | Population and coverage reasoning | Synthetic population with unreachable, stale telemetry, quiet seasonal consumer, contradictory interview/static/runtime facets | Coverage claims, limitation codes, business-cycle model, mutation tests | Claims remain bounded; quiet/unreachable never becomes absent; contradictions block | Absolute absence or retirement from incomplete evidence |
| E06-10 | Endpoint dual-write structural prohibition | Static dependency/package credential/route graph; binary strings/imports; network deny/positive tests | Architecture report, package manifest, credential inventory, packet/deny evidence | New endpoint cannot link/reach SQL/legacy route; legacy cannot use new credential/protocol | One artifact can reach both ordinary destinations or fan out a record |
| E06-11 | Shadow no-business-egress | Mutation/query lineage tests across facts, projections, reports, integrations, exports, lifecycle, BFF/search | Dependency graph, DB role tests, hostile query tests, canary route evidence | Zero ordinary consumer can read or act on shadow data | Any shadow fact reaches ordinary output/effect |
| E06-12 | Canonicalization/HMAC/Merkle vectors | Independent implementations; RFC vectors; duplicate multiplicity, Unicode/decimal/time/null/order adversarial cases | Canonical byte corpus, HMAC vectors, root vectors, differential report, resource profile | Byte/root equality across implementations; multiplicity differences detected; bounded resources | Nondeterminism, collision/cancellation counterexample, key/realm mix, excessive cost |
| E06-13 | Range/window closure and late data | Native ranges, gaps, overlaps, open watermarks, late arrivals, superseding generations, tzdb profiles | Range manifests, closure evidence, generation lineage, first failures | Final only when both sides closed; late data creates immutable superseding generation | Open/incomparable range passes; prior evidence edited; timestamp used as false source order |
| E06-14 | Mismatch/defect/tolerance safety | Seed every finite mismatch, wildcard/expired/unowned tolerance, defect attempting exact-invariant suppression | Classification matrix, owner-decision binding, mutation report | Exact failures always block; unknown blocks; records match only exact scope | Generic percentage, wildcard, expired/unowned record, or exact failure suppressed |
| E06-15 | Compatibility projector determinism and coverage | Exact/coarsened/defaulted/unrepresentable/prohibited fields; changed reference/config revisions | Projection manifest, field coverage, deterministic runs, provenance checks | Same inputs/versions produce same output; missing required field fails closed | Hidden default, raw reconstruction, defect copied to ordinary behavior, live DB write |
| E06-16 | Configuration transform no-broadening | Immutable snapshots with conflicts, executable values, unknown precedence, prohibited settings | Typed intermediate model, loss/ambiguity manifest, lattice/no-broadening proof, rollback candidate | No script/SQL executes; ambiguous/prohibited items block; approved candidate only narrows | Silent default, owner inference, product-ceiling broadening, direct activation |
| E06-17 | Authority/cutover model exploration | Exhaustive/random command/fault histories across authority, workflow, ring, rollback expiry, trust removal | Model histories, invariant checker, minimized counterexamples | No `BOTH`, lower epoch, post-trust legacy rollback, skipped gate, or self-promotion | Any invalid state reachable or first failure overwritten |
| E06-18 | Fence and gap/overlap simulation | Synthetic legacy/new source streams; quiesce races; late writes; response loss; rollback boundary | Old/new range manifests, authority epochs, effect oracle, audit/evidence | Exactly one ordinary effect; no unproved gap/overlap; ambiguity stays frozen | Concurrent writers, duplicate/missing effect, ambiguous fence accepted |
| E06-19 | New-system N/N-1 rollback | Exact signed N/N-1, shared store/contracts, ambiguous sends, backlog, policy/realm/audit state | Release/storage compatibility evidence, state/data digests, cleanup | N-1 safely operates store/contracts and preserves all identities/evidence | Store unreadable, identity changes, data loss, lower sequence, unauthorized payload |
| E06-20 | Pre-trust legacy rollback drill | Disposable dual environment; existing legacy trust only; freeze new; close range; reselect legacy at higher epoch | Authority/range/effect evidence, owner-command simulation, rollback-expiry enforcement | No gap/overlap/dual authority/new credential; higher epoch; cleanup | Credential minted, both writers active, lower epoch, gap/duplicate, rollback after expiry |
| E06-21 | Layered legacy read-only | Synthetic portal/API/jobs/runtime identity/DB/login/sessions/network/restore; positive/negative write probes | Route/job inventory, permissions, session list, DB state, network evidence, audit-before-disclose, restore evidence | Every unauthorized write rejected; approved reads audited; restore starts blocked | One mutation succeeds or sensitive bytes disclose before audit |
| E06-22 | SQL login/session/permission cleanup | Lab-only disable login, maintain existing session positive control, KILL, remove rights/ownership/job dependencies, drop/remap | Before/after principals/roles/sessions/ownership/jobs, write/auth probes, cleanup | Existing session termination proved; permissions/ownership resolved; authentication/write denied | Login disable alone counted pass; surviving session/right/owned object/orphan ignored |
| E06-23 | Network alternate-path denial | Synthetic listener/alias/alternate port/proxy/VPN/failover/NAT/management route; server and endpoint controls | Active policy, connection attempts, deny logs, positive/negative controls, cleanup | Every legacy write route denied; approved new/archive/admin paths retain intended access | Alternate path succeeds, management path accidentally broken without recovery, residue |
| E06-24 | Certificate/application-status revocation | Lab PKI or selected platform; live session/cache/revocation/status/network combinations | Issue/revoke/status evidence, challenge/auth attempts, cache/freshness, cleanup | Revoked credential cannot authorize; application status/network denial contain distribution delay | Revoked cert still authorizes ordinary work; unbounded fail-open; key/cert residue |
| E06-25 | Buffer disposition harness | Fictional deferred SQL/CSV with duplicates, malformed rows, secrets, unreachable device, typed transform oracle | Value-free inventory, freeze proof, dispositions, before/after counts/digests, transform effect oracle | No raw execution; drain only pre-fence; transform exact/idempotent; discard explicit | Silent loss, post-fence drain, raw SQL execution, identity conflict, raw evidence escape |
| E06-26 | Residual monitoring positive controls | Plant synthetic task/service/package/login/session/path/cert/repair-source/recurrent attempt across independent sensors | Sensor configs, detections, false negatives, correlation, blind intervals, cardinality, cleanup | Every mandatory positive control detected/classified; no successful writes; finite safe fields | One mandatory control missed, raw/high-cardinality leak, unknown recurring attempt |
| E06-27 | Unreachable-device/on-return workflow | Simulate offline device retaining old package/buffer after trust removal, then return | Exception state, denied write evidence, enterprise removal/re-enrollment, buffer disposition, cleanup | Device cannot write while offline/returning; remediation precedes collection | Old credential/path works, collection resumes before remediation, exception auto-renews |
| E06-28 | Archive restore/read-block drill | Backup/restore older legacy archive; stale writer/session/job/config; current access/audit/tombstones | New environment identity, read-block evidence, write probes, audit, lifecycle reconciliation | No ordinary read/write/egress before readiness; approved reads work only after separate decision | Stale authority revives, deleted data visible, mutation path remains, unaudited disclosure |
| E06-29 | Deployment repair/reappearance cleanup | Remove legacy task/service/package/rule then trigger repair/GPO/MDM/package detection/watchdog scenarios | Before/after inventory, reappearance detection, policy/package state, cleanup | Retired component does not reappear; known positive control detected | Component recreated silently or removal proof ignores repair source |
| E06-30 | Game day, blind support, incident, and accessibility | Run pause, hard mismatch, monitor blindness, new N-1, pre-trust rollback, credential incident, archive hold, late finding with representative operators | Timelines, decision/audit, accessible task results, support findings, residue, postmortem | Operators complete safe actions without raw data/arbitrary command; authority respected; cleanup complete | Credential recreation requested, unsafe workaround needed, inaccessible critical workflow, unbounded confusion |
| E06-31 | Independent acceptance evaluator | Deliberately omit/stale/tamper evidence, approvals, exception expiry, first failure; run separate evaluator | Evaluator binary/source identity, recomputation report, mutation corpus | Every false predicate produces hold; evaluator cannot mutate source/approvals | Self-asserted pass, missing approval ignored, tamper survives, evaluator changes state |
| E06-32 | Exact final decommission rehearsal | Full fictional/disposable flow through discovery, validation, cutover, read-only, trust removal, residual, cleanup, acceptance, late finding | Complete evidence package, owner-decision fixtures, acceptance record, reopen lineage, cleanup | Gate expression passes only on complete case; late finding reopens; limitations truthful | Skipped owner/gate, stale evidence, external-copy overclaim, residue, immutable record edited |

## 7.4 Required evidence bundle layout

```text
manifest.json
inputs/allowlist-and-hashes.json
build/source-and-dependency-map.json
contracts/catalogue.json
contracts/vectors/**
fixtures/t1-estate/**
oracle/expected-ledgers/**
discovery/scope-summary.json
discovery/inventory-nodes.ndjson
discovery/inventory-edges.ndjson
discovery/observations.ndjson
discovery/coverage-claims.ndjson
discovery/dispositions.ndjson
validation/profiles/**
validation/range-manifests/**
validation/digests/**
validation/mismatches.ndjson
validation/owner-decisions.ndjson
cutover/plans/**
cutover/authority-epochs.ndjson
cutover/cohort-states.ndjson
cutover/observations.ndjson
trust/credential-removal.ndjson
trust/network-denial.ndjson
buffers/dispositions.ndjson
archive/read-only-and-restore.ndjson
residual/findings-and-exceptions.ndjson
acceptance/candidate.json
acceptance/independent-evaluation.json
acceptance/owner-approvals.ndjson
failures/first-failure.json
cleanup/receipt.json
canaries/results.json
hashes.sha256
package-root.json
```

The package MUST NOT contain raw database dumps, activity rows, URLs, paths, addresses, usernames, credentials, private keys, connection strings, SQL/script/report bodies, command lines, packet payloads, crash dumps, or unclassified attachments.

## 7.5 Aggregate machine-checkable gate

A release candidate CLI should emit one finite result:

```text
PASS_T1_IMPLEMENTATION_ONLY
PASS_BOUNDED_READONLY_DISCOVERY
PASS_VALIDATION_PROFILE_ONLY
PASS_CUTOVER_RING_CANDIDATE
PASS_DECOMMISSION_TECHNICAL_WITH_LIMITATIONS
HOLD_MISSING_HUMAN_DECISION
HOLD_MISSING_OR_STALE_EVIDENCE
HOLD_HARD_INVARIANT_FAILURE
HOLD_UNKNOWN_MATERIAL_ITEM
HOLD_EXCEPTION_OR_RESIDUAL
INVALID_EVIDENCE
```

No result string implies production authorization. The separate production/risk decision is recorded through the accepted administrative authorization/audit system.

---

# 8. Threat, failure, and recovery gaps

## 8.1 Consolidated threat/failure/recovery register

| ID | Threat or failure | Current containment | Missing proof / residual gap | Required recovery or stop action |
|---|---|---|---|---|
| T06-01 | Hidden dynamic SQL, manual query, report, script, or seasonal consumer | Static/config/runtime/interview evidence classes; bounded absence claims; owner dispositions | No estate campaign has run; dormant/emergency paths may remain | Keep item/estate `UNKNOWN`; extend approved observation/owner review; no removal |
| T06-02 | Authoritative population incomplete or conflicting | Population manifest and reconciler; unreachable accounting | Actual CMDB/deployment/database/report population not supplied | Stop coverage/retirement; assign population owner; reconcile sources |
| T06-03 | Discovery tool mutates source or executes hostile content | Fixed compiled adapters, query lint, parser isolation, tracing, private output | Exact Windows/SQL/PSU profiles unproved | Abort run; incident and cleanup; invalidate evidence; fix and rerun in lab |
| T06-04 | Secret, raw activity, internal locator, SQL, script, or address escapes evidence | Closed publication schema, local aliases, exact canaries, independent verifier | Scanner/parser false negatives and privileged memory observation remain | No publication; incident handling; rotate exposed secret where applicable; evidence invalid |
| T06-05 | Authorized malicious/defective collector emits coherent false pack | Content hashes, independent evidence classes, positive controls, owner challenge | Hashes cannot prove source truth; privileged collusion possible | Independent rerun/source witness; mark conflict; no disposition/removal |
| T06-06 | Evidence pack or owner decision tampered/rolled back | Immutable hashes, manifest roots, audit, first-failure preservation, independent evaluation | External checkpoint/signing topology and retention open | Safety hold; compare protected prior state; investigate; new linked epoch, never edit history |
| T06-07 | Endpoint artifact can reach both legacy and new destinations | Package/credential/network architecture tests and deny rules | Exact production package/network inventory not proved | Stop release/parallel run; remove credential/client/route; rerun structural proof |
| T06-08 | Shadow row leaks into ordinary report, export, integration, lifecycle, or portal | Isolated namespace, separate roles, lineage/mutation tests | Exact query/report/integration graph unproved | Pause affected realm; treat as data/privacy incident; remove downstream effect and reprove |
| T06-09 | Dual ordinary authority or ambiguous epoch | Unique authority registry and no-`BOTH` model | Cross-system writers/manual paths can bypass registry | Enter `FROZEN_NO_AUTHORITY`; stop writers; reconcile ranges/effects; incident if duplicate |
| T06-10 | Legacy or new range gap/overlap at cutover/rollback | Native range manifests, quiesce, higher epochs, exact fence drills | Real common fence and manual writer inventory unknown | Stay frozen; do not infer coverage; repair/reconcile or abandon cutover |
| T06-11 | Timestamp/time-zone/precision mismatch misclassified as loss or tolerance | Pinned time profile, half-open windows, typed mismatch, owner semantics | Legacy local-time/report rules unapproved | Block affected profile; reconstruct/approve semantics; never generic-tolerate |
| T06-12 | Canonicalization or digest common-mode defect | Independent implementation, RFC vectors, mutation/differential corpus | UAM field profiles, key service, scale not executed | Invalidate comparison; freeze profile; fix/version; recompute from source evidence |
| T06-13 | Keyed digest leaks linkability or key compromise permits correlation | Per-realm/run/profile purpose-separated keys, finite evidence, key reference only | KMS/HSM, retention/destruction and insider model open | Revoke/destroy key under policy; invalidate affected evidence if integrity/confidentiality uncertain |
| T06-14 | Generic tolerance hides systematic loss/duplication/realm/privacy fault | Exact-invariant non-suppressibility, scoped records, expiry | Owner pressure or bad classification remains | Automatic hold; independent review; remove tolerance; rerun exact profile |
| T06-15 | Known legacy defect copied into new ordinary behavior | Defect normalization remains comparator-only; projector coverage explicit | Actual defects/report contracts not approved | Block projector/consumer; fix target or deliberate human change decision |
| T06-16 | Configuration transform silently broadens privacy or activates ambiguous behavior | Typed intermediate model, no-broadening lattice, loss/ambiguity manifest, owner approval | Exact legacy precedence and target policy not settled | Reject candidate; keep capability disabled; owner reconciliation/new revision |
| T06-17 | Automatic health signal is wrong or monitor is blind | Automatic pause only; positive controls; monitor freshness; no auto-credential action | Sensor false positives/negatives and correlation gaps | Pause; preserve data; investigate with independent sensors; resume only after evidence |
| T06-18 | New release fails during probation | Same-digest rings, N/N-1 compatibility, durable buffers, pause/kill | Exact release/storage/estate evidence open | Disable capability, pause collection/upload, select authorized new N-1 or roll forward |
| T06-19 | Pre-trust legacy rollback creates gap/overlap or dual authority | Explicit expiry, frozen epoch, new range close, old restart boundary, human command | Real legacy restart behavior and shared credentials unknown | Remain frozen/new paused; do not reactivate legacy until exact fence passes |
| T06-20 | Operator attempts legacy rollback after trust removal | State machine has no transition; credential reactivation prohibited | Social/incident pressure and out-of-band administrator action remain | Security incident; preserve hold; use new-only recovery; baseline change process if demanded |
| T06-21 | SQL login disabled but existing sessions keep writing | Mandatory session inventory/termination and write probes | Exact sessions/jobs/proxies/ownership not inventoried | KILL/terminate in lab/approved change; remove rights/ownership; block network; incident on write |
| T06-22 | Dropping/removing login breaks shared consumers or creates orphans | Consumer/ownership/job/user map before removal | Sharedness and database mappings unknown | Stop removal; split/replace consumer; remap ownership/users; rerun tests |
| T06-23 | Revoked certificate remains usable due cache/offline validation | Application status and network denial independent of PKI revocation | Selected PKI/gateway/cache behavior unknown | Deny application credential, terminate session/connection, block route; investigate distribution |
| T06-24 | Alternate listener/port/alias/proxy/VPN/failover path bypasses firewall | Multiple path inventory and active connection tests | Production topology absent | Trust-removal hold; deny path at server/network; update inventory/positive controls |
| T06-25 | Secret remains in package, task argument, backup, workbook, support system, or build | Secret-copy manifest and rotation/removal evidence | Backup and human-copy coverage incomplete | Rotate secret so residual copy is unusable; remove under policy; record limitation/incident |
| T06-26 | Unreachable device writes when it returns | Central credential revoked, path denied, exception, on-return remove/re-enroll | Device may retain unknown buffers/config and alternate credentials | Quarantine network; inventory/remediate before collection; do not auto-enroll/advance |
| T06-27 | Legacy deferred SQL executes after fence or against changed schema | Closed buffer disposition; raw execution prohibited | Volume/semantics/owners unknown | Quarantine; incident if executed; restore/reconcile effects; no cursor/coverage inference |
| T06-28 | Typed buffer transform duplicates or changes event identity | Stable source identity, oracle, one-effect central uniqueness, before/after digests | Actual legacy buffer format/semantics unproved | Hold conflicting event; no overwrite; correct transform/profile and replay deterministically |
| T06-29 | Human-authorized discard loses required data | Counts/digests, impact, explicit decision, audit, limitations | Legal/business consequence and unobserved local copies uncertain | Record exact loss/limitation; stop if approval absent; no silent recovery claim |
| T06-30 | Archive read-only control bypassed by API/job/DBA/restore | Layered controls, write probes, audit-before-disclose, read-blocked restore | Privileged administrator collusion and exact topology remain | Read-block; incident; revoke routes/identity; re-verify every layer before enablement |
| T06-31 | Archive migration/import reinterprets or merges legacy history | Explicit `LEGACY_IMPORT`, provenance, typed mapping, reconciliation | Named historical use/purpose and mapping absent | Keep read-only archive; reject import; no silent merge |
| T06-32 | Old restore revives legacy writers, credentials, deleted data, or stale authority | New environment identity, restore read-block, current tombstone/authority/credential reconciliation | Combined archive/lifecycle/authority drill not run | Keep isolated; deny reads/egress/receipts; replay current controls; destroy/retry if conflict |
| T06-33 | Residual sensor misses a planted component or write path | Mandatory positive controls and independent sensors | Production capture/retention/clock/cardinality open | Invalidate observation window; repair sensor; restart watch with current evidence |
| T06-34 | Recurring failed attempt is normalized as harmless noise | Every attempt classified, owner/exception/expiry | High-volume operational noise may obscure source | Hold acceptance; locate/remediate source; rate-limit safely without losing evidence |
| T06-35 | Successful residual write occurs after read-only/trust-removal deadline | Server/database one-effect evidence, audit/monitoring, automatic hold | Impact scope and hidden writer identity may be unknown | Security/data-correctness incident; freeze affected authority, quarantine effects, investigate/reconcile |
| T06-36 | Removed component reappears through repair, GPO, MDM, package cache, watchdog, or image | Reappearance experiments and post-removal inventory | Exact enterprise management behavior unproved | Reopen decommission; disable/remove repair source; rerun observation and cleanup |
| T06-37 | Residual exception becomes permanent through repeated renewal | No auto-renew, expiry blocks, owner/review | Governance pressure may accept broad waivers | Expire to hold; require new exact risk decision or remediation |
| T06-38 | Final evaluator and operational owners share one failure domain or collude | Separate evaluator executable/access, immutable evidence, multi-owner decision | Organizational independence, signing/checkpoint custody open | Production tamper-evidence/acceptance claim blocked or requires stronger witness model |
| T06-39 | Owner approves wrong bytes or stale result | Digest-bound approvals, expiry/review, current gate recomputation | Identity/authentication/approval implementation not yet built for this batch | Deny transition; reacquire approval on exact current record |
| T06-40 | Support requires raw data or arbitrary command during incident | Closed diagnostics, synthetic reproduction, fixed runbooks, pause/new-release rollback | Some real failures may remain irreproducible | Narrow support promise or add safe finite signal through separate ADR; never default to raw |
| T06-41 | Critical cutover/approval workflow inaccessible | WCAG-oriented design and manual task testing | Exact browser/AT/localization matrix open | Block capability/ring; redesign workflow; provide approved accessible alternative |
| T06-42 | External recipient/manual copy remains after decommission | Inventory, owner/recipient action, truthful limitation states | UAM cannot compel or prove unmanaged deletion | Record `EXTERNAL_ACTION_REQUIRED`/limitation; legal/records follow-up; no complete claim |
| T06-43 | Budget/staffing lapse makes evidence stale or monitoring unsupported | Evidence expiry, ring support prerequisites, owner gates | No staffing/budget decisions supplied | Pause progression; expire claims; do not operate unsupported capability |
| T06-44 | Open-source/reference tool supply-chain or license changes | Exact tag/commit/license/security/admission; reference-only default | Future versions/advisories and transitive dependencies change | Revoke admission, pin/fix/replace; rerun positive controls; no automatic upgrade |
| T06-45 | Late finding after final acceptance | Linked reopen state and immutable old record | Business/public interpretation may still treat old acceptance as final | Alert owners, contain, reopen, reassess impact, issue superseding record and decision |

## 8.2 Mandatory recovery hierarchy

Recovery proceeds in this order unless a security incident requires immediate containment:

1. **Stop expansion.** Pause the affected ring, commands, sensitive reads, or trust-removal step. Preserve current evidence and first failure.
2. **Narrow safely.** Disable one new capability, shadow profile, comparison profile, adapter, archive route, or residual sensor. Do not delete buffers or alter closed evidence.
3. **Preserve durable truth.** Keep endpoint unacknowledged data, immutable custody/receipt truth, source checkpoints, authority epochs, audit, tombstones, comparison generations, and evidence.
4. **Contain trust.** Revoke current application authorization, terminate sessions, deny paths, quarantine credentials/buffers/components, and isolate restored/archive environments.
5. **Select known-good new state.** Use an already-authorized new N-1 or a forward fix that passes storage/contract/identity evidence.
6. **Use pre-trust legacy rollback only if still explicitly available.** Enter frozen authority, prove both boundaries, use existing intact trust only, obtain named authority, and create a higher epoch.
7. **After trust removal, never recreate legacy trust.** Stay paused or use new-system recovery. Any proposal otherwise enters baseline-change governance.
8. **Reconcile effects and evidence.** Identify gaps, overlaps, duplicates, unauthorized writes, archive disclosures, residual attempts, and owner/approval impact. Do not synthesize missing normal evidence.
9. **Clean up and reprove.** Remove test/failed artifacts, rerun positive controls, regenerate a new immutable evidence generation, and repeat affected bake/watch windows.
10. **Human decision.** Designated owners decide resume, rollback, deliberate gap, exception, extended observation, or abandonment. Technical tooling does not self-clear.

## 8.3 Immediate safety-hold incident classes

The following require an immediate scoped safety hold and incident process:

- endpoint dual-write capability or two ordinary authorities;
- cross-realm result or authority confusion;
- forbidden-value/secret/raw-SQL/script escape;
- cursor/checkpoint ahead, false receipt, duplicate effect, or acknowledged-data loss;
- successful unauthorized legacy write after quiesce/read-only;
- compromised release/signing/identity/credential authority;
- credential/session/path that remains authorized after removal gate;
- shadow business egress;
- restored/archive mutation or pre-ready disclosure;
- evidence tamper, missing first failure, owner-approval forgery, or evaluator integrity failure;
- raw deferred SQL execution or silent buffer discard;
- unknown recurring residual attempt after the accepted watch start;
- accessibility failure that blocks safe pause, rollback, credential, archive, or acceptance workflow.

---

# 9. ADR create/update list

## 9.1 Batch 06 ADR register

| ADR | Decision | Proposed status | Alternatives | Owner function | Review trigger |
|---|---|---|---|---|---|
| **ADR-B06-001** | One-shot fixed read-only discovery CLI; no persistent agent by default | **ACCEPT FOR IMPLEMENTATION** | Manual spreadsheet; broad PowerShell; persistent osquery/custom agent | Discovery Architecture / Security | Repeated approved cycles prove a continuing need unavailable through orchestration/existing sensors |
| **ADR-B06-002** | Canonical content-addressed evidence graph and owner-bound disposition; spreadsheets are projections | **ACCEPT FOR IMPLEMENTATION** | Spreadsheet as truth; free-form document repository | Verification Governance | Prototype cannot express a necessary relation without unsafe free-form content |
| **ADR-B06-003** | `AuthorityEpochV1` is the sole business-authority state with legacy/frozen/new only | **ACCEPT — LOAD-BEARING** | Mixed cutover authority states; dual authority | Migration Control / Data Correctness | Formal baseline change only |
| **ADR-B06-004** | Parallel run is dual observation with isolated shadow and no endpoint dual-write or shadow promotion | **ACCEPT — LOAD-BEARING** | Endpoint fan-out; dual ordinary paths; shared fact table flag | Endpoint/Data Architecture / Security | Formal baseline change or isolation counterexample |
| **ADR-B06-005** | JCS + per-run/realm HMAC-SHA-256 + counted RFC-9162-style multiset root is the T1 comparison candidate | **PROVISIONAL T1** | Full raw diff; DB-native checksum; PSI; another exact digest | Data Security / Reconciliation | Canonicalization, privacy, cost, or collision/localization experiment fails |
| **ADR-B06-006** | Compatibility projection/config transform are deterministic, typed, read-only, no-broadening, and owner-approved | **ACCEPT FOR IMPLEMENTATION** | Legacy write-back; copy settings/defects as-is; arbitrary transform language | Compatibility / Product Privacy | Approved semantics cannot be represented or a simpler safe mechanism emerges |
| **ADR-B06-007** | Progressive `CUT-C0..C5` rings, immutable cohort manifests, complete monitors, explicit coverage, human promotion | **ACCEPT FOR IMPLEMENTATION** | Big bang; ad hoc waves; automatic promotion | Cutover/Release Architecture | Cohorts cannot be formed or staged coexistence proves materially riskier |
| **ADR-B06-008** | Rollback is phase-bounded: new-only by default; legacy only pre-trust before explicit expiry/fence; impossible after trust removal | **ACCEPT — LOAD-BEARING** | Automatic legacy rollback; dormant credential; no rollback at all | Release/Security/Risk | Operational requirement conflicts; formal baseline change if trust must be recreated |
| **ADR-B06-009** | Layered legacy read-only and archive BFF; read-only copy is preferred first candidate | **ACCEPT MECHANISM / TOPOLOGY OPEN** | UI-only; DB-only; original portal indefinite; static exports; immediate full import | Archive/Data Security | Human archive topology or restore/fidelity evidence changes choice |
| **ADR-B06-010** | Credential removal requires disable/revoke, sessions, rights/ownership, secret copies, paths, monitoring, and owner approval | **ACCEPT — LOAD-BEARING** | Login disable only; certificate only; uninstall only | Security/IAM/PKI/DB/Network | Selected platform provides equivalent intrinsically verified lifecycle |
| **ADR-B06-011** | Legacy buffers use closed drain/typed-transform/quarantine/human-discard dispositions; raw execution prohibited | **ACCEPT — LOAD-BEARING** | Execute after cutover; blanket discard; raw import | Data Reliability / Records | Complete semantics justify a typed transform; raw execution remains rejected |
| **ADR-B06-012** | Residual exceptions are exact, contained, owner-assigned, expiring, non-renewing by default | **ACCEPT FOR IMPLEMENTATION** | Permanent waiver; wildcard exception | Risk Governance | No expected architectural change; new exception types may extend enum by contract |
| **ADR-B06-013** | Independent gate evaluator and content-addressed final acceptance; evaluator cannot approve or mutate source | **ACCEPT FOR IMPLEMENTATION** | Checklist/email/self-attestation | Independent Verification / Architecture Review | Organizational witness model or stronger external verification requirement changes |
| **ADR-B06-014** | Existing telemetry may be read; enabling instrumentation is a separate mutating ADR/change; discovery remains one-shot | **ACCEPT FOR IMPLEMENTATION** | Silent enablement; permanent discovery sensor | System/Database/Privacy/SRE | Repeated evidence gap justifies an approved minimum instrumentation profile |
| **ADR-B06-015** | Compatibility delivery is read-only projection/API by default; any typed bridge is server-side, named, isolated/hard-expiring, and not live legacy authority | **ACCEPT DISABLED-BY-DEFAULT** | Indefinite live legacy write-back; endpoint bridge | Integration Architecture | Indispensable consumer and exact safe prototype |
| **ADR-B06-016** | Separate `DISC-D*`, `VAL-V*`, `CUT-C*`, authority, workflow, credential, buffer, and acceptance state namespaces | **ACCEPT FOR IMPLEMENTATION** | Reuse ambiguous `R0/R1` and mixed authority states | Contract Authority | None expected beyond versioned enum expansion |
| **ADR-B06-017** | OSS/repositories are reference/test inputs by default; no Batch 06 production runtime dependency selected | **ACCEPT** | Adopt Argo/Flagger/Rundeck/OpenBao/osquery/data-quality platform directly | Architecture / Dependency Security | Exact platform need and full admission evidence |
| **ADR-B06-018** | AD CS CA-decommission guidance is conditional; Batch 06 makes no PKI topology assumption | **ACCEPT** | Assume dedicated AD CS CA | PKI Architecture | Discovery proves a dedicated CA is in scope and human authority approves its retirement |
| **ADR-B06-019** | Late findings reopen a linked technical case; prior evidence/acceptance is immutable | **ACCEPT** | Edit old acceptance; ignore finding | Audit/Verification | None expected |
| **ADR-B06-020** | Named owner approvals are mandatory for every disposition, reconciliation result, rollback boundary, credential removal, and final action | **ACCEPT — BATCH GATE** | Aggregate committee approval without item-level binding | Architecture Governance / Risk | Organizational approval model changes while preserving exact digest-bound authority |
| **ADR-B06-021** | No accepted-baseline change is made; legacy trust resurrection and related conflicts require formal change proposal | **ACCEPT** | Treat incident workaround as local ADR | Chief Architecture / Security | New primary evidence and explicit proposal |

## 9.2 Topic ADR corrections and supersession

| Topic ADR/action | Review action |
|---|---|
| I02 `ADR-P23-001` one authority | **Incorporate into ADR-B06-003.** |
| I02 `ADR-P23-002` no endpoint dual-write | **Incorporate into ADR-B06-004; load-bearing.** |
| I02 `ADR-P23-003` isolated shadow | **Incorporate into ADR-B06-004.** |
| I02 `ADR-P23-004` server-side minimized comparison | **Accept; reference ADR-B06-004/005.** |
| I02 `ADR-P23-005` compatibility projector | **Accept with ADR-B06-006/015.** |
| I02 `ADR-P23-006` digest profile | **Keep provisional T1 under ADR-B06-005.** |
| I02 authority lifecycle rollback wording | **Update with phase-bounded ADR-B06-008.** |
| I03 `ADR-B06-001` staged rings | **Supersede identifier with review ADR-B06-007; retain substance.** |
| I03 `ADR-B06-002` authority state | **Replace mixed workflow meaning with ADR-B06-003/016.** |
| I03 `ADR-B06-003` no legacy credential resurrection | **Retain and clarify pre-trust phase via ADR-B06-008.** |
| I03 `ADR-B06-004` three milestones | **Retain as accepted invariant X06-20.** |
| I03 `ADR-B06-005` layered read-only | **Retain under ADR-B06-009.** |
| I03 `ADR-B06-006` compatibility writer | **Narrow under ADR-B06-015; no live authoritative write-back by default.** |
| I03 `ADR-B06-007` buffer disposition | **Retain under ADR-B06-011.** |
| I03 `ADR-B06-008` layered credential removal | **Retain under ADR-B06-010.** |
| I03 `ADR-B06-009` unreachable exceptions | **Retain under ADR-B06-012.** |
| I03 `ADR-B06-010` multiple residual sensors | **Retain in component/experiment baseline.** |
| I03 `ADR-B06-011` independent acceptance | **Retain under ADR-B06-013/020.** |
| I03 `ADR-B06-012` exception expiry | **Retain under ADR-B06-012.** |
| I03 `ADR-B06-013` game day | **Retain as mandatory experiment/backlog gate.** |
| I03 `ADR-B06-014` late finding | **Retain under ADR-B06-019.** |
| I03 `ADR-B06-015` OSS reference-only | **Retain under ADR-B06-017.** |
| I03 `ADR-B06-016` missing Prompt 22/23 | **Close as input-presence blocker; replace with executed-evidence gates.** |

## 9.3 Predecessor ADR updates without baseline change

| Predecessor area | Required update |
|---|---|
| Batch 01 contract catalogue | Add migration evidence, authority, comparison, cutover, credential, buffer, archive, exception, and acceptance contracts plus closed state namespaces. |
| Batch 01 repository architecture | Add `Uam.LegacyDiscovery`, `Uam.MigrationValidation`, `Uam.CutoverModel`, `Uam.DecommissionEvidence`, and architecture prohibitions for endpoint SQL/dual destination/shadow egress. |
| Batch 02 source/progress ADRs | Reference cutover range/fence manifests without changing natural source/event identity or replaying history automatically. |
| Batch 03 release rollback ADR | Add explicit difference between new release rollback and pre-trust business-authority rollback; close legacy option at trust removal. |
| Batch 03 identity/revocation ADR | Add migration credential-removal evidence and unreachable-device/on-return behavior; no reactivation after verified removal. |
| Batch 03 diagnostics/compatibility ADR | Add residual-monitor positive controls and exact migration tuple/evidence expiry; no raw migration diagnostics. |
| Batch 04 ingestion/one-effect ADR | Ensure shadow namespace has no ordinary effect and historical import uses explicit origin/one-effect identity. |
| Batch 04 lifecycle/restore ADR | Add legacy archive read-block, trust-removal status, external-copy limitations, and old-legacy restore negative tests. |
| Batch 05 authorization/audit ADR | Add typed migration/cutover commands, owner-decision records, acceptance approvals, and audit-before-disclose for historical reads/evidence. |
| Batch 05 verifier ADR | Permit independent Batch 06 gate evaluator/checkpoint evidence while keeping technical evaluation separate from production approval. |

## 9.4 ADR acceptance order

1. ADR-B06-003, 004, 008, 010, 011, 020, and 021 first because they protect accepted invariants and define prohibited states.
2. ADR-B06-001, 002, 006, 014, 016, and 019 next because they define discovery/evidence/state boundaries.
3. ADR-B06-005, 007, 009, 012, 013, and 015 after the core models because they contain implementation candidates and workflow details.
4. ADR-B06-017 and 018 after exact platform/dependency inventory.
5. Any ADR that selects a production value, tool, topology, or human profile remains `PROPOSED/PROVISIONAL` until its CLI and human gates pass.

---

# 10. Ordered implementation backlog and dependency/stop gates

## 10.1 Sequencing rule

The smallest safe sequence is evidence and pure-state first, then disconnected tooling, then bounded read-only observation, then shadow validation, then cutover simulation/lab, then separately authorized real rings. A failed earlier phase blocks every dependent phase. No backlog item may use a later gate as if it were already passed.

## 10.2 Ordered backlog

| Order | Backlog item | Depends on | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record exact Batch 06 input manifest and hashes | none | Immutable allowlist/presence record | Any unallowlisted input or unresolved identity |
| 2 | Create/accept load-bearing ADRs and owner placeholders | 1 | ADR-B06 register, predecessor update plan | Silent conflict or missing load-bearing ADR |
| 3 | Define state namespaces and strict contract catalogue | 1–2, Batch 01 contracts | Schemas, enums, vectors, compatibility matrix | `BOTH`, lower epoch, unknown authority field, generic extension |
| 4 | Implement pure authority/cutover/credential/buffer/archive/exception models | 3 | C# models, model checker, independent oracle | Invalid state reachable or mutation survivor |
| 5 | Implement architecture dependency and route/action/metric guards | 3–4 | CI tests preventing endpoint SQL/dual destination/shadow egress/arbitrary actions | Forbidden dependency/route/label survives |
| 6 | Build deterministic T1 fictional migration fixture/oracle package | 3–5, G0 | Fictional estate, consumers, reports, configs, credentials, buffers, ranges, failures, truth | Real value, nondeterminism, oracle common-mode gap, canary miss |
| 7 | Implement evidence package, graph, sanitizer, positive controls, and verifier | 3–6 | `Uam.DecommissionEvidence` foundation and package schemas | Raw/secret escape, tamper miss, orphan graph path, cleanup failure |
| 8 | Implement fixed discovery adapters against T1/disconnected fixtures | 3, 5–7 | Endpoint/SQL/PSU adapter contracts and fakes | Arbitrary input, mutation, execution, broad crawl |
| 9 | Implement static parser/query-pack compiler and hostile corpora | 5–8 | PowerShell/T-SQL/config classifiers, lint, resource bounds | Input executes or forbidden query compiles |
| 10 | Execute E06-01 through E06-09 | 3–9 | Discovery safety/graph/coverage evidence | Any hard safety/realm/privacy/mutation failure |
| 11 | Implement isolated shadow namespace and no-egress architecture | 3–7 | Shadow roles/schema/modules and lineage tests | Ordinary consumer can reach shadow |
| 12 | Implement canonicalizer/digest/range/mismatch core | 3, 6–7, 11 | Comparison profiles and independent vectors | Nondeterminism, weak multiset proof, open range pass |
| 13 | Implement compatibility projector and configuration transformer | 3, 6, 11–12 | Field-coverage and loss/ambiguity manifests | Hidden default, live write-back, privacy broadening |
| 14 | Execute E06-10 through E06-16 | 11–13 | Validation architecture evidence | Dual-write/shadow/semantic/config hard failure |
| 15 | Implement cutover plan compiler, ring controller, authority registry, and gate evaluator | 3–7, 12–14 | Pure/T1 migration-control module | Auto-promotion, state confusion, missing audit, cross-realm |
| 16 | Implement lab-only fixed action adapters behind structural `LAB_ONLY` boundary | 5, 7–10, 15 | Task/service/login/session/firewall/cert/package action receipts | Production artifact contains test controller/arbitrary command |
| 17 | Execute cutover/fence/new N-1/pre-trust rollback model and disposable-lab tests | 15–16 | E06-17 through E06-20 evidence | Dual authority, gap/overlap, lower epoch, unsafe rollback |
| 18 | Implement/read-test archive gateway and layered read-only lab | 3, 7, 15–17, Batch 05 controls | Read-only/archive contracts, restore/read-block proof | Mutation or unaudited sensitive read |
| 19 | Execute credential/session/network/certificate/buffer lab matrix | 16–18 | E06-21 through E06-25 evidence and cleanup | Surviving trust/path, raw execution, silent loss, residue |
| 20 | Implement residual monitor adapters/fakes and exception registry | 7, 15–19 | Finite findings, positive controls, exception state | One-sensor assumption, raw labels, auto-renew |
| 21 | Execute residual/on-return/archive/deployment-reappearance experiments | 18–20 | E06-26 through E06-29 evidence | Positive-control miss, write succeeds, stale authority, reappearance |
| 22 | Run full T1 game day, blind support, accessibility, evaluator, and final rehearsal | 10–21 | E06-30 through E06-32 evidence, runbooks, postmortem | Unsafe workaround, inaccessible workflow, evaluator miss, residue |
| 23 | Complete T1 aggregate architecture gate | 1–22 | `PASS_T1_IMPLEMENTATION_ONLY` package | Any hard failure, stale/missing evidence, unresolved ADR |
| 24 | Obtain real inspection authority, fields, retention, resource, support, and population decisions | 23 + HD06 decisions | Approved scope profiles | Missing owner/authority; invented defaults |
| 25 | Execute one bounded read-only non-production target per required class | 24 | `DISC-D2` evidence | Mutation, raw escape, access ambiguity, cleanup failure |
| 26 | Run representative discovery waves and owner interviews | 25 | Population reconciliation, `DISC-D3`, contradictions, unreachable list | Unknown material writer/consumer/path or coverage gap |
| 27 | Complete item-level owner dispositions and target traceability | 26 + target contracts | `DISC-D4` evidence graph and approvals | Any material item unassigned/incomplete |
| 28 | Obtain parallel-run purpose/cohort/access/retention/support decisions | 23, 27 + governance | Approved real shadow plan | Purpose/access/retention/support absent |
| 29 | Qualify exact production-like shadow isolation and comparison profiles in approved environment | 28 + predecessor gates | `VAL-V1/V2` current evidence | Dual-write, shadow egress, open range, unsupported tuple |
| 30 | Approve report/config semantics, defects, tolerances, and reconciliation results | 27–29 + owners | `VAL-V3` owner decisions | Unknown material mismatch or unowned/expired record |
| 31 | Prove exact cutover/rollback fence in the approved environment | 29–30 | `VAL-V4`, authority/fence/rollback evidence | Gap/overlap, dual authority, unsafe rollback |
| 32 | Decide archive, buffer, credential, network, ring, bake, SLO, support, and rollback-expiry profiles | 27–31 + human register | Immutable cutover-plan inputs | Any blocking human decision absent |
| 33 | Compile one `CUT-C1` candidate and independently evaluate | 15, 27–32 | Immutable plan/cohort/release/monitor/runbook/evidence digests | Evaluator hold, missing support, stale/changed digest |
| 34 | Obtain separate production change/pilot authority | 33 | Approved change record | Research evidence treated as production authority |
| 35 | Execute `CUT-C1` with automatic pause and human decision | 34 | Ring observations, first failure, promotion/rollback decision | Any hard stop, monitor blindness, owner unavailable |
| 36 | Progress `CUT-C2` to `CUT-C4` only by explicit current evidence | 35 | Ring-by-ring immutable results | Skipped ring, changed digest, stale evidence, unresolved mismatch |
| 37 | Complete new-primary acceptance and close pre-trust rollback at approved expiry | 35–36 | Owner-approved authority/reconciliation/rollback-boundary record | Contingency undefined, owner absent, N/N-1 unsafe |
| 38 | Transition legacy application/database to layered read-only/archive | 37 + archive decisions | Archive technical readiness and separate read-enable decision | Write succeeds, unowned/unaudited/undefined lifecycle |
| 39 | Remove writer credentials/sessions/rights/secrets/network paths | 38 + exact inventory/owners | Verified credential-removal cases | Shared dependency, active session/path/secret copy |
| 40 | Execute buffer dispositions and residual/unreachable workflow | 37–39 | Reconciled buffers, findings, contained exceptions | Raw execution, silent discard, successful write, expired exception |
| 41 | Remove legacy runtime/packages/jobs/rules and reconcile CMDB/backups/repair sources | 38–40 | Cleanup and reappearance evidence | Residue, component returns, unowned copy |
| 42 | Repeat current game day/restore/support/accessibility if topology/release changed | 38–41 | Current exact evidence | Stale game-day or cleanup evidence |
| 43 | Build independent final acceptance candidate and owner-approval package | 27–42 | `DecommissionAcceptanceRecordV1` candidate/evaluation | Any predicate/approval/limitation missing |
| 44 | Record designated production/risk final decision and post-decommission watch transition | 43 | Accepted/blocked decision, monitoring and reopen plan | Self-acceptance, legal overclaim, no late-finding path |

## 10.3 Permitted parallelism

The following can proceed in parallel after the contracts/state namespaces are stable:

- discovery adapter fakes, parser corpora, sanitizer/canaries, and evidence graph;
- shadow storage/no-egress design, digest vectors, projector, and config transformer;
- pure cutover model, lab action adapter interfaces, archive read model, and exception model;
- runbooks, owner templates, accessibility scaffolding, dependency reviews, and evidence verifier.

The following MUST remain sequential:

- live discovery before inspection authority and T1 safety pass;
- disposition before population/evidence/owner reconciliation;
- real shadow run before no-dual-write/no-egress proof and approved purpose;
- semantic sign-off before report/config owners decide meaning;
- cutover before exact reconciliation/fence/rollback evidence;
- trust removal before new-primary acceptance/archive plan and rollback-window decision;
- final cleanup before credential/network/buffer/residual gates;
- final acceptance before independent evaluation and required owner approvals.

## 10.4 Critical stop/go summary

```text
GO: contracts + T1 models + fictional fixtures + read-only/disconnected tooling
  only after sections 3/5/7 safety boundaries are enforced.

GO: bounded non-production read-only discovery
  only after T1 aggregate pass + HD06-01/02/14/15/37/41 approvals.

GO: real shadow validation
  only after DISC-D4 + purpose/access/retention/support + dual-write/no-egress proof.

GO: CUT-C1 candidate
  only after VAL-V4 + exact fence/rollback + archive/buffer/credential plans + owners.

GO: trust removal
  only after new primary accepted + legacy rollback closed + layered read-only ready.

GO: final technical decommission
  only after zero scoped successful legacy writes, every buffer/consumer/config disposition,
  verified credentials/sessions/secrets/paths, owned archive, current restore/game-day evidence,
  expiring exceptions, independent evaluation, and every required owner approval.

STOP on any hard invariant, unknown material item, stale evidence, unassigned owner,
blind monitor, changed digest, residue, or baseline conflict.
```

---

# 11. Source and open-source quality corrections

## 11.1 Evidence hierarchy and source-use rules

For this batch, evidence is ordered as follows:

1. accepted predecessor review decisions I04–I08 and the shared baseline/gates I09–I10;
2. the three supplied Batch 06 topic results I01–I03, within their declared authority and evidence limits;
3. current official platform documentation and standards for documented capability;
4. immutable repository tags/releases, exact source/binary/license/security/test evidence;
5. UAM-specific **CLI EXPERIMENT** evidence for fitness;
6. authenticated **HUMAN DECISION** and risk acceptance.

Source quality rules:

- a platform document proves a primitive or documented behavior, not UAM composition fitness;
- a repository release proves an identified review point, not dependency admission or production support;
- a legacy observation proves that behavior exists, not that it is correct, lawful, required, or safe to preserve;
- a passing comparison proves similarity under the exact profile, not semantic correctness or production readiness;
- a hash proves byte integrity, not source completeness or truth;
- a quiet window proves only non-observation under the declared sensors/scope/time;
- a human approval proves authority to decide the exact record, not technical correctness beyond its evidence;
- exact versions, dates, commits, and document revisions belong in evidence and dependency records, not timeless architecture statements.

## 11.2 Corrections to supplied-source use

| Correction | Resolution |
|---|---|
| I02/I03 missing-file statements | Historical evidence-boundary facts only. All same-stream inputs are present for this review; executed evidence remains open. |
| Safe-deployment bake values | Microsoft guidance supports progressive exposure, health-gated phases, sufficient bake measured in hours/days, increasing coverage, halt-on-failure, disable-before-delete, and watch windows. It does not establish a universal UAM ring size or duration. |
| SQL login disablement | Official SQL Server documentation states disabling a login does not affect existing connections; disabled logins retain permissions and can be impersonated. Therefore session termination and rights/ownership cleanup are mandatory. |
| `DROP LOGIN` cleanup | Official SQL Server documentation notes active logins cannot be dropped, owned securables/jobs can block removal, and mapped database users may become orphaned. Inventory/remapping is required. |
| Database `READ_ONLY` | Official documentation establishes that ordinary users cannot modify a database in that state. It does not establish application/API/job/network/audit/restore fitness or constrain every privileged administrator. |
| Query Store/XE evidence | Existing capture may support bounded discovery, but capture modes, retention, rollover, clearing, and gaps limit absence claims. Enabling or changing capture is a mutation, not read-only discovery. |
| AD CS decommission | Microsoft guidance is current and useful only if discovery proves a dedicated Windows enterprise CA is being retired. Batch 06 does not assume AD CS or authorize CA removal. |
| JCS/HMAC/Merkle | RFCs establish deterministic algorithms/test vectors/construction concepts. UAM field semantics, key management, privacy, scale, and independent implementation still require CLI proof. |
| IANA time-zone data | A comparison run may pin a released tzdb revision, but a current revision does not reconstruct undocumented legacy-local behavior. Exact time semantics remain owner-approved. |
| OpenLineage version in I01 | I01 reviewed 1.46.0. I02 reviewed the newer signed 1.52.0 release/commit in July 2026; use 1.52.0 as the current review point, still reference-only. |
| SQL Script DOM package | The current NuGet package point is relevant, but exact package-to-repository commit/source mapping was not closed. It remains a leading candidate only after provenance and hostile-input admission. |
| Gitleaks v8.30.1 | Reject this review point. GitHub issues report an orphaned tag/source-lineage problem and a canonical positive control returning a silent no-find result. A later version must prove source/binary mapping and mandatory UAM canaries. |
| `data-diff` | Repository is archived and unmaintained since May 2024. Hash-partition ideas remain reference material; it is not a load-bearing dependency. |
| Liquibase | Current 5.x community source uses FSL-1.1 with a future Apache change rather than an ordinary current permissive OSS license. Legal review is mandatory; the tool remains change-oriented reference only. |
| Argo Rollouts/Flagger | Current maintained Kubernetes rollout controllers provide useful state-model references. Their cluster/traffic/metrics/secrets authority does not fit Windows endpoint migration and must not be imported as UAM runtime authority. |
| Rundeck | A useful negative/operational comparator for jobs and runbooks, but its general command/plugin/credential model is broader than UAM's fixed typed capabilities. |
| OpenBao | A maintained secrets/PKI platform reference and possible separately governed enterprise service. It is not assumed present and its policy/root/unseal/plugin authority is not imported into UAM. |
| osquery | A broad queryable endpoint-inventory reference/lab sensor, not the first discovery deployment. Arbitrary/distributed SQL, extensions, and permanent agent authority are outside the accepted first lane. |
| in-toto-golang | Useful evidence/layout concepts and test-tool reference. It is not an in-process C# runtime dependency and artifact hashes do not prove operational state. |

## 11.3 Stable primary-source register for load-bearing claims

| Ref | Source, reviewed date/version | Claim supported | UAM limitation |
|---|---|---|---|
| W06-01 | Microsoft, [Safe deployment practices](https://learn.microsoft.com/en-us/devops/operate/safe-deployment-practices), last updated 28 Nov 2022 | Progressive exposure through tiers; bake time before expansion; quality signals; rollback practice. | Example durations are guidance, not UAM production values. |
| W06-02 | Microsoft Azure Well-Architected Framework, [Architecture strategies for safe deployment practices](https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments), updated 17 Jun 2026 | Progressive exposure, health checks, immediate halt on issues, bake in hours/days, increased coverage, disable-before-delete, watch windows. | Azure examples are not direct UAM implementation proof. |
| W06-03 | Microsoft, [`ALTER LOGIN`](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-login-transact-sql?view=sql-server-ver17), current SQL Server documentation reviewed 1 Aug 2026 | Disabling login does not terminate existing connections; disabled login retains permissions and can be impersonated. | Exact legacy topology, session ownership, and operational effect require lab/production evidence. |
| W06-04 | Microsoft, [`KILL`](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/kill-transact-sql?view=sql-server-ver17), reviewed 1 Aug 2026 | Terminates a specified SQL Server connection and its associated work. | Requires correct session targeting and approved change authority; UAM fitness unproved. |
| W06-05 | Microsoft, [`DROP LOGIN`](https://learn.microsoft.com/en-us/sql/t-sql/statements/drop-login-transact-sql?view=sql-server-ver17), reviewed 1 Aug 2026 | Active login/owned securable/job limitations; mapped users may become orphaned. | Does not choose the UAM cleanup sequence or authorize removal. |
| W06-06 | Microsoft, [`ALTER DATABASE ... SET` options](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-set-options?view=sql-server-ver17), reviewed 1 Aug 2026 | SQL Server database read-only and Query Store modes/settings. | Database setting alone is not layered UAM read-only proof. |
| W06-07 | Microsoft, [Manage Query Store](https://learn.microsoft.com/en-us/sql/relational-databases/performance/manage-the-query-store?view=sql-server-ver17), reviewed 1 Aug 2026 | Query Store captures persisted query/runtime evidence subject to configuration and lifecycle. | Capture modes, cleanup, resets, permissions, and omitted activity constrain completeness. |
| W06-08 | Microsoft, [Extended Events targets](https://learn.microsoft.com/en-us/sql/relational-databases/extended-events/targets-for-extended-events-in-sql-server?view=sql-server-ver17) and [`CREATE EVENT SESSION`](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-event-session-transact-sql?view=sql-server-ver17), reviewed 1 Aug 2026 | Existing targets have retention/rollover limitations; creating a session changes configuration. | Existing evidence may be incomplete; enabling capture needs a separate approved change. |
| W06-09 | Microsoft, [How to decommission a Windows enterprise certification authority](https://learn.microsoft.com/en-us/troubleshoot/windows-server/certificates-and-public-key-infrastructure-pki/decommission-enterprise-certification-authority-and-remove-objects), updated 12 Feb 2026 | Outstanding certificates/revocation handling; CRL lifetime should exceed remaining revoked-certificate lifetime; CA objects/keys/data cleanup. | Applies only to an actually discovered/approved AD CS CA topology. |
| W06-10 | Microsoft PowerShell SDK, [`Parser.ParseInput`](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.language.parser.parseinput?view=powershellsdk-7.6.0), reviewed 1 Aug 2026 | PowerShell text can be parsed into AST/tokens/errors without normal execution. | UAM must still prove no module/profile/type/script side effects around its composition. |
| W06-11 | RFC Editor, [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/info/rfc8785/), June 2020 | Deterministic JSON canonicalization profile and string-preservation rules. | Field semantics and accepted numeric/string subset remain UAM contracts. |
| W06-12 | RFC Editor, [RFC 4231 — HMAC test vectors](https://www.rfc-editor.org/info/rfc4231/), December 2005 | HMAC-SHA-256 identifiers and test vectors. | Key generation, storage, domain separation, retention, and privacy are UAM decisions. |
| W06-13 | RFC Editor, [RFC 9162 — Certificate Transparency Version 2.0](https://www.rfc-editor.org/info/rfc9162/), December 2021 | Domain-separated Merkle-tree hashing and split construction concepts. | UAM comparison tree is an application profile, not a CT log or proof of fitness. |
| W06-14 | IANA, [Time Zone Database](https://www.iana.org/time-zones) and [tz announce archive](https://lists.iana.org/hyperkitty/list/tz-announce%40iana.org/), release `2026c` reviewed for 1 Aug 2026 | Current versioned time-zone rule data can be pinned in a comparison profile. | Does not establish legacy report time semantics or authorize reinterpretation. |
| W06-15 | W3C, [PROV-O](https://www.w3.org/TR/prov-o/) / PROV family | Provenance concepts for entities, activities, agents, derivation, generation, and attribution. | UAM uses a smaller closed schema and does not import arbitrary provenance payloads. |

## 11.4 Consolidated open-source/repository audit

**Audit rule.** A repository recommendation is rejected as a dependency unless it has an immutable tag/commit, understood license, current maintenance evidence, relevant tests, security process/advisories, exact fit, source/binary mapping, transitive-dependency review, and explicit classification. “Reference” means ideas/vocabulary/test corpus only; it grants no runtime authority.

| Project and reviewed point | License / maintenance / tests / security | Fit and material risk | Consolidated classification |
|---|---|---|---|
| **PSScriptAnalyzer 1.25.0**, commit `f05704d`, 20 Mar 2026 | MIT; signed active release; substantial rules/tests; security policy | Helpful PowerShell diagnostics, but module/custom-rule/runtime surfaces are broader than a non-executing parser. | **Reference and isolated test candidate.** Direct PowerShell parser remains narrower core. |
| **DacFx / Microsoft.Build.Sql sdk-2.2.0**, commit `f23e116`, 6 Jun 2026 | MIT; Microsoft-maintained signed release; tests/release notes | Database-model vocabulary useful; extraction/deployment/change authority is too broad and does not prove runtime consumers. | **Reference / conditional isolated test candidate.** |
| **Microsoft SQL Script DOM NuGet 180.78.1**, published 30 Jul 2026 | MIT; active Microsoft package/repository; 1,100+ stated tests, security/support files; exact package-to-source commit unresolved | Strong T-SQL AST fit; parse success is not semantic safety; malicious-input/resource profile unproved. | **Leading candidate after exact provenance and hostile-corpus admission; currently reference only.** |
| **Syft v1.50.0**, commit `16223e6`, 28 Jul 2026 | Apache-2.0; signed active release; tests/security policy | Useful SBOM/file reconciliation; security boundary does not promise malicious-input completeness. | **Test-only SBOM candidate; never sole oracle.** |
| **osquery 5.23.1**, commit `b753833`, 24 Jun 2026 | Repository contains Apache-2.0/GPL components; active security-fix release; broad tests/assurance/security docs | Broad persistent SQL/plugin/distributed-query agent exceeds narrow one-shot lane and has security-sensitive native surface. | **Reference only; optional isolated lab sensor after separate review.** |
| **OpenLineage 1.52.0**, commit `cfd47d6`, 23 Jul 2026 | Apache-2.0; active signed release; cross-language/integration tests; security/code-quality docs | Provenance vocabulary useful; open/custom facets can carry SQL, URLs, code, and errors and create a network platform. | **Reference only; UAM keeps a closed local graph.** |
| **SQLGlot 30.14.0**, 27 Jul 2026 package point | MIT; active large test suite; exact package/tag mapping unresolved and no root security policy identified in supplied review | Useful differential SQL corpus; generic Python multi-dialect parser/transpiler/execution surfaces unnecessary. | **Reference/differential-test only.** |
| **SQL Server First Responder Kit 20260708**, commit `7562068`, 8 Jul 2026 | MIT; active signed community release, tests/docs | Operational question catalogue useful; installs/runs broad diagnostic procedures and can expose detailed query/plan data. | **Reference only; never installed or executed in discovery lane.** |
| **Liquibase v5.0.3**, commit `4d815ea`, 15 May 2026 | FSL-1.1-ALv2 at current release; active tests/security fixes; legal review required | Change/migration tool with broad DB mutation; cannot discover hidden consumers or serve as semantic oracle. | **Reference only for change-record discipline; not a dependency.** |
| **DataHub v1.6.0**, commit `059a36c`, 21 May 2026 | Apache-2.0; large active platform, tests/security/upgrade surface | Metadata graph ideas useful; broad services/connectors/search/UI/operations and open fields are disproportionate. | **Reference only; possible future adapter to an already-approved enterprise instance.** |
| **Google Cloud Data Validation Tool v8.9.0**, commit `3d57ab8`, 31 Jul 2026 | Apache-2.0; active, tests/security; professional-services/unofficial support posture | Validation vocabulary useful; arbitrary SQL, stored connections, raw row differences, cloud integrations conflict with closed minimum-data model. | **Reference only.** |
| **Great Expectations 1.19.1**, commit `f6d7aec`, 24 Jul 2026 | Apache-2.0; active extensive tests/security; broad Python/database dependency surface | Expectation/checkpoint ideas useful; extensible providers and unexpected-row output are too broad. | **Reference only.** |
| **Soda Core v4.19.0**, commit `0416a3d`, 28 Jul 2026 | Elastic License 2.0, source-available; active releases/tests/security fixes; legal review required | Contracts/check states useful; SQL/YAML expression, cloud/log upload, connector/plugin surfaces too broad. | **Reference only; not a dependency.** |
| **Debezium v3.6.0.Final**, commit `800ae11`, 1 Jul 2026 | Apache-2.0; active extensive connector/integration tests | Snapshot/offset/restart ideas useful; implies Kafka Connect/broker and broad CDC of legacy schema, conflicting with no-broker/minimization default. | **Reference only; reconsider only after measured CDC/broker trigger.** |
| **OpenMined PSI v2.0.6**, commit `c1aa5a`, 24 Jun 2025 | Apache-2.0; security policy/tests; multi-language/native crypto complexity | Two-party PSI not needed inside one trusted realm-scoped comparator; approximate modes cannot prove exact invariants. | **Reference only.** |
| **data-diff 0.11.2**, archived 17 May 2024 | MIT; historical tests; no active maintenance/support | Partition/bisection ideas useful; connection URI/raw row/self-healing surfaces and archive status make it unsuitable. | **Reference only; not a dependency.** |
| **Argo Rollouts v1.9.1**, commit `b6bd3bc`, Jul 2026 review point | Apache-2.0; maintained release, tests/security/governance in Kubernetes ecosystem | Progressive state ideas useful; cluster credentials, CRDs, traffic/metric authority do not model Windows endpoints, credentials, buffers, archive, or UAM audit. | **Reference only.** |
| **Flagger v1.44.0**, commit `15bd6ad`, signed release 21 Jul 2026 | Apache-2.0; active signed release, tests/governance/security through Flux/CNCF | Canary/conformance ideas useful; Kubernetes/mesh/secret synchronization and default thresholds are inappropriate authority. | **Reference only.** |
| **Rundeck 6.0.1 review point**, commit `9fe4ed6` | Apache-2.0 source at reviewed point; broad tests/security; enterprise distribution/plugins require procurement review | Job/history/runbook patterns useful; general remote commands, plugins, nodes, credentials, and user-authored workflows are explicitly broader than UAM. | **Reference / separately governed external enterprise-tool candidate only.** |
| **OpenBao v2.6.1**, commit `ba7ad88`, 22 Jul 2026 | MPL-2.0; active security-fix releases/tests; large HA/root/unseal/plugin/operations surface | Credential lease/revocation ideas useful; may be enterprise service candidate, but UAM cannot assume or embed its policy/root authority. | **Reference / possible separately governed service; no selection.** |
| **in-toto-golang v0.11.0**, commit `36d782f`, 4 May 2026 | Apache-2.0; maintained release with security fix and tests | Evidence-layout/material/product concepts useful; Go toolchain and command execution/path rules do not prove operational state. | **Reference / evidence-format test-tool candidate.** |
| **Gitleaks v8.30.1**, tag commit `83d9cd6` | MIT; reviewed tag has reported orphan/source-lineage problem and a reported canonical positive-control silent miss | Secret scanning can supplement exact canaries, but this exact version is unsafe as a gate and scanners never prove credential removal. | **REJECTED at reviewed version.** Reconsider only a later exact release after provenance and mandatory canaries. |

## 11.5 Open-source adoption rules

Before any reference becomes a dependency or deployed service, the admission record MUST include:

1. immutable tag and full commit; source/binary/package/container digest mapping;
2. license and all transitive/optional/enterprise-feature terms approved by Legal/Procurement;
3. current maintenance, release, security policy, advisories, and support/exit plan;
4. relevant source areas, tests, hostile-input/resource/cleanup evidence, and independent positive controls;
5. exact UAM purpose, trust boundary, data fields, credentials, network access, plugin/expression surfaces, and failure modes;
6. operational topology, upgrades, backup/restore, observability, on-call, incident, and removal cost;
7. classification as `REFERENCE`, `TEST_ONLY`, `BUILD_TOOL`, `RUNTIME_LIBRARY`, `DEPLOYED_SERVICE`, or `REJECTED`;
8. proof that the dependency cannot become migration authority, expand the privacy ceiling, execute arbitrary input, or bypass realm/audit/evidence gates;
9. replacement and data/metadata migration plan;
10. execution-time re-verification because all point-in-time versions may be stale.

**RECOMMENDATION.** No reviewed repository is admitted as a Batch 06 production runtime dependency by this review.

---

# 12. Confidence by major conclusion, residual risk, and baseline-update conditions

## 12.1 Confidence register

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Fixed one-shot discovery with strict read-only adapters is safer than a broad script or persistent agent | **High** | Directly preserves accepted least-authority/no-script/no-profile-crawl boundaries and creates a small falsifiable surface. | A bounded alternative passing every no-execution, no-mutation, privacy, realm, cleanup, evidence, and operations gate at lower cost. |
| Static evidence alone cannot close legacy discovery | **High** | Supplied legacy summaries and I01 explicitly identify dynamic/manual/runtime/unreachable gaps. | A closed-world authoritative registry and exhaustive instrumentation with independent proof for a specific scope. |
| Content-addressed graph plus owner decisions is the correct canonical migration record | **High** | Required evidence/owner/validation/rollback/removal paths are finite and machine-testable; manual documents are insufficient. | Prototype demonstrates an essential relation cannot be represented safely or another system proves equivalent integrity/governance. |
| Exactly one business-authoritative path is non-negotiable | **High** | It follows accepted one-effect, receipt, realm, audit, and lifecycle truth. | Formal baseline-change evidence for a complete safer dual-authority protocol. |
| Endpoint dual-write should be structurally impossible | **High** | It would restore direct database trust and two-destination ambiguity. | Formal baseline change; none expected. |
| Server-side minimized comparison with isolated shadow is the right initial validation architecture | **High** | Enables direct evidence without ordinary business effects or endpoint authority broadening. | Required semantics cannot be expressed after minimization and a narrower alternative passes the same gates. |
| Shadow history must not be promoted | **High** | Authority and provenance boundaries would otherwise be rewritten and duplicates become likely. | A separately approved historical-import design; it would not change the shadow rule itself. |
| Exact invariants need zero tolerance | **High** | Tolerance could conceal the accepted safety failures. | No expected change; only the exact invariant set may be extended. |
| JCS/HMAC/counted-Merkle profile is suitable for T1 | **Medium** | Standards and reasoning are strong; UAM canonicalization, key management, scale, and privacy have not run. | Independent counterexample, resource/linkability failure, or a simpler exact method. |
| Report and configuration equivalence are currently established | **Low / not established** | Real formulas, consumers, defects, precedence, and owners are not approved. | Discovery results, independent fixtures, report contracts, owner decisions, and representative reconciliation. |
| Progressive rings with complete monitors and human promotion are the safest cutover default | **High** | Strong topic agreement, primary guidance, and clear blast-radius/failure-containment reasoning. | Evidence that staging increases risk for the exact system and a smaller alternative passes equivalent proof. |
| Legacy rollback may exist only before trust removal and must expire | **High** | Reconciles operational recovery with the no-legacy-trust target and prevents dormant credentials becoming architecture. | Requirement for indefinite rollback; that would block trust removal or require a baseline change. |
| New N/N-1 rollback is operationally fit | **Medium-Low currently** | Accepted release architecture requires it, but no exact migration release/store drill is supplied. | Repeated exact-tuple rollback evidence with buffers, receipts, policies, archive, and cleanup. |
| Layered read-only is necessary | **High** | UI, application, DB, session, job, network, restore, and audit controls have independent bypasses. | A selected platform provides an intrinsically equivalent single control with independent proof. |
| Read-only copy behind the new BFF is the best first archive candidate | **Medium** | It reduces legacy runtime surface and uses accepted portal controls, but fidelity/cost/lifecycle are open. | Restore/fidelity/performance/lifecycle evidence or human requirements favor original DB or typed import. |
| Credential/session/permission/secret/network removal sequence is correct | **High** | Official platform behavior and threat analysis show no single control suffices. | Exact platform evidence requires a different order/control while preserving all outcomes. |
| Complete credential/path inventory is known | **Low / not established** | No real discovery run or ownership map exists. | Executed inventory, consumer reconciliation, active-session/path tests, and owner approval. |
| Deferred legacy buffers can be safely transformed | **Low / not established** | Actual formats, semantics, identities, volumes, owners, and privacy are absent. | Complete static/runtime semantics, typed transform, independent oracle, one-effect and failure evidence. |
| Multiple residual sensors can provide bounded useful assurance | **Medium-High** | Independent sensors and positive controls reduce blind spots, but exact capture/retention/topology remain open. | Lab/production-shaped positive-control campaign and population reconciliation. |
| Final decommission can be accepted through an independent record/evaluator | **Medium-High** | Predicates and approvals are finite and machine-testable; organizational independence and runtime evidence remain open. | Prototype finds unrepresentable necessary truth, evaluator common-mode failure, or stronger witness requirement. |
| Any real cutover/decommission is currently ready | **Low / not established** | All executed discovery, semantic, ring, archive, trust-removal, residual, and human gates remain open. | Complete current evidence and separate production/risk approval. |

## 12.2 Evidence most likely to change architecture or priority

The following future evidence could materially change implementation priority or selected topology without changing the core invariants:

1. a complete legacy discovery graph showing materially fewer or different writers/consumers than static evidence suggests;
2. report contracts proving some surfaces are intentionally changed or retired rather than compared exactly;
3. inability to establish a common native/quiesced cutover fence;
4. inability to keep N/N-1 storage/contract compatibility through the required rollback window;
5. an indispensable consumer that cannot use a read-only compatibility projection or typed API;
6. archive restore/fidelity/cost evidence favoring original read-only DB or typed historical import over a copy;
7. selected enterprise PKI/secrets/network/platform behavior that changes the removal sequence or available evidence;
8. evidence that enterprise deployment cannot reliably stage/pause/rollback/inventory a material cohort;
9. measured comparison cost or privacy risk invalidating the T1 digest/profile;
10. positive-control evidence showing proposed residual sensors have unacceptable blind spots;
11. legal/records decisions requiring preservation of exact legacy runtime or forbidding a real parallel run;
12. operational inability to staff independent monitoring, support, owner review, and multi-owner acceptance.

Evidence that endpoints need database credentials, dual ordinary authority, raw SQL execution, lower-sequence rollback, or post-revocation legacy resurrection would not silently change priority; it would trigger the formal accepted-baseline change process.

## 12.3 Unresolved risks and blocked dependencies

### Technical unknowns

- authoritative endpoint/server/database/portal/report/export/credential/network/archive population;
- exact legacy writers, readers, jobs, manual consumers, dynamic SQL paths, settings precedence, source fences, buffer volumes, and unreachable-device state;
- approved report semantics, known defects, tolerances, time rules, first-run behavior, and configuration changes;
- exact enterprise deployment, database, PKI, secrets, network, SIEM, CMDB, archive, backup, and ticketing platforms;
- current release/storage compatibility and safe new N-1 behavior;
- exact shadow storage, digest/key profile, comparison resource cost, and evidence lifecycle;
- archive topology, restore/read-only behavior, retention/deletion, and historical access fields;
- active sessions, shared credentials, secret copies, alternate paths, package repair sources, backups, and residual-monitor coverage;
- exact ring/bake/support/observation/error/backlog/cost objectives.

### Human-owned blockers

- inspection authority and workforce/privacy/legal purpose;
- named owners, criticality, disposition, report/configuration semantics, accepted defects/tolerances;
- real parallel-run purpose/cohort/access/retention;
- rollback authority/expiry, gap/overlap acceptance, cutover promotion, support coverage;
- archive owner/purpose/fields/access/retention/legal hold;
- buffer discard/transform, unreachable devices, compatibility bridge, credentials/certificates, residual exceptions;
- final deletion, communications, budget, staffing, SLO/RPO/RTO, licensing, risk, and production approval.

### Operational residual risk that remains even after a pass

- dormant or unmanaged human consumers can appear after the watch window;
- privileged collusion or compromised authorized releases can create coherent false evidence;
- endpoint/DB/network/PKI/security products and enterprise policies can change after qualification;
- fail-closed behavior can cause data-coverage gaps and business outage;
- external recipient copies and unmanaged backups cannot always be technically removed or proved absent;
- historical UAM data remains fallible and can be misinterpreted despite access controls;
- evidence, monitoring, support, and owner approvals expire and require recurring investment.

## 12.4 Exact conditions for updating the main technical baseline

Batch 06 may update the main technical baseline only when all applicable conditions below are true for an exact release, contract set, topology, realm/cohort, and evidence generation:

1. **Contracts and ADRs:** all load-bearing Batch 06 ADRs are accepted; strict schemas/state namespaces/compatibility vectors pass; no silent conflict with predecessor ADRs remains.
2. **Discovery safety:** one-shot discovery no-mutation/no-execution/privacy/realm/cleanup gates pass on every claimed target class.
3. **Discovery coverage:** authoritative population is reconciled; static/configuration/runtime/interview/time/unreachable evidence is bounded; no unknown material writer, consumer, credential, path, report, integration, or buffer remains outside an approved exception.
4. **Disposition:** every material consumer and configuration has a named owner, purpose/criticality decision, preserve/change/retire/investigate disposition, target contract, validation, rollback, and removal proof.
5. **Shadow isolation:** endpoint dual-write is structurally impossible and shadow ordinary egress is zero under architecture, role, query, mutation, and realm-negative tests.
6. **Reconciliation:** exact ranges/windows close; canonical/digest evidence passes independently; exact invariants have zero failures; every report/configuration semantic is approved; every tolerance/defect is scoped, owned, tested, current; no unknown material mismatch remains.
7. **Cutover fence:** legacy quiesce and final old range, new boundary, first-run behavior, no-unproved-gap/overlap, higher authority epochs, and rollback drills pass.
8. **Release rollback:** current new release and authorized N-1 pass exact storage/contract/identity/receipt/buffer/audit/cleanup evidence for the declared rollback window.
9. **Ring evidence:** immutable cohort/release/config/monitor/runbook manifests, required coverage, complete monitor positive controls, support/on-call, automatic pause, human promotion, and first-failure preservation pass through the required rings.
10. **Rollback boundary:** named owners approve the exact legacy rollback expiry and actions; the option is closed before trust removal; no credential recreation is needed.
11. **Archive/read-only:** owner, purpose, minimum fields, access, audit, retention, legal hold, deletion, restore, accessibility, and layered write denial pass; separate human read-enable authority exists.
12. **Credential/trust removal:** every writer credential/certificate/session/permission/ownership/job/secret copy/network path is inventory-bound, removed or explicitly retained for an approved non-writer purpose, independently verified, and owner-approved.
13. **Buffers:** every legacy and new buffer is dispositioned; no raw SQL/script executes; counts/digests reconcile; unreachable cases are contained and owner-approved.
14. **Residual:** required sensors detect positive controls; zero successful legacy writes occur in the declared scope/window; every failed attempt is classified; every exception is current, exact, owned, contained, and allowed by the acceptance profile.
15. **Cleanup and restore:** legacy packages/tasks/services/jobs/scripts/rules/repair sources/CMDB/backups are reconciled; archive/old-backup restore does not revive stale authority, mutation, deleted data, or ordinary egress; cleanup leaves no unapproved residue.
16. **Support/accessibility:** current game day, blind support, incident, communications, and accessibility tasks pass for the exact workflow and supported matrix without raw data or arbitrary commands.
17. **Independent evaluation:** separate evaluator recomputes the exact acceptance record and detects all mandatory omissions/tampering/expiry mutations.
18. **Owner approvals:** authenticated digest-bound approvals exist for every consumer/configuration disposition, each reconciliation result, rollback boundary, every credential removal, and final decommission, plus every other required owner in the approved profile.
19. **Human decisions:** legal/privacy/records/access/budget/licensing/staffing/SLO/RPO/RTO/risk and production decisions are recorded by accountable functions.
20. **Evidence currency:** no evidence, dependency, release, platform tuple, owner approval, exception, or monitor profile is stale, expired, superseded, or inconsistent.

Passing these conditions may add the following to the main technical baseline:

- the accepted Batch 06 state namespaces and contracts;
- the one-shot discovery/evidence-graph/disposition mechanism;
- the one-authority/isolated-shadow/comparison mechanism;
- the exact cutover, rollback-expiry, read-only, trust-removal, residual, and acceptance mechanisms;
- only those exact platform profiles, tools, dependencies, numeric values, and human profiles that passed their named evidence and decision gates.

It does **not** automatically approve a future realm, cohort, release, dependency version, archive period, ring size, or production change. Those remain exact, expiring claims.

## 12.5 Conditions requiring a formal baseline change rather than a Batch 06 update

A Batch 06 implementation cannot approve the following merely by passing local tests:

- endpoint SQL/database credentials or endpoint dual-write;
- two ordinary business-authoritative paths;
- promotion of shadow history without an explicit typed historical import;
- raw URL/activity/SQL/script/secret crossing accepted minimization/evidence boundaries;
- lower-sequence rollback or reuse of old authority/release state;
- recreation of revoked legacy endpoint trust after trust removal;
- arbitrary tenant/admin script, SQL, path, command, plugin, or policy language;
- silent unacknowledged loss or unknown-as-success;
- privileged mutation without transactional audit;
- restore/archive read or mutation before readiness;
- broker/external authority as default without measured trigger.

Each requires the accepted change-proposal contents: affected decision, new primary evidence, alternatives, impact, smallest falsifying experiment, migration consequence, and ADR action.

## 12.6 Final residual risk and disposition

**Final disposition: ACCEPT WITH MANDATORY CONDITIONS; aggregate gate OPEN.**

Unresolved risks remain from hidden consumers and manual copies, dynamic SQL, unreachable devices, stale telemetry, unknown report/configuration semantics, shared credentials, long-lived sessions, alternate network paths, certificate-status delay, package repair, buffers on offline devices, archive/backup resurrection, owner error, malicious authorized tooling, evaluator common-mode failure, and insufficient staffing or monitoring. These risks are not resolved by prose or by the presence of the three topic results.

The batch is blocked from real cutover and final decommission until:

- the discovery lane produces an accepted current estate graph with owner-bound dispositions;
- parallel validation passes exact safety invariants and owner-approved semantics;
- an exact authority fence and both applicable rollback paths are proved;
- archive, buffer, credential, network, support, retention, and exception decisions are recorded;
- the exact rings pass with complete monitoring and current evidence;
- all legacy writer trust and residual paths are removed and verified;
- final evidence is independently recomputed; and
- named owners approve every consumer/configuration disposition, reconciliation result, rollback boundary, credential removal, and final decommission action.

Until then, the main technical baseline may be updated only with the **mechanism-level** decisions accepted in this review—strict state separation, one authority, no endpoint dual-write, isolated shadow, phase-bounded rollback, layered read-only/trust removal, explicit buffer/exception handling, and independent multi-owner acceptance. Production values, estate claims, tools, dependencies, archive policy, and decommission status remain provisional or blocked.
