# Batch 05 review result — portal authorization, workflows, and audit

**Result path:** `results/batch-05-portal-governance/batch-05-review-result.md`  
**Review date:** 1 August 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS — T1 IMPLEMENTATION PROTOTYPES MAY PROCEED; THE BATCH 05 GATE REMAINS OPEN; NO ADMINISTRATIVE PRODUCTION USE IS AUTHORIZED**  
**Authority boundary:** reconciliation of portal/control-plane authorization, purpose-bound access, JIT grants, approvals, break-glass, browser/BFF security, portal information architecture, administrative workflows, accessibility, transactional audit, tamper evidence, independent verification, audit access, and audit-aware restore; **not** legal purpose, lawful basis, prohibited uses, employee consultation, organizational role assignment, approver identity, retention periods, access approval, independent-verifier ownership, evidentiary sufficiency, database selection, key custody, licensing, budget, staffing, SLO/RPO/RTO, pilot, production risk acceptance, or deployment approval  
**Predecessors:** accepted Batch 01, Batch 02, Batch 03, and Batch 04 review results  
**Primary batch gate:** **Capability authorization, purpose-bound access, transactional audit, accessibility, and bounded break-glass controls must all pass for one exact release and topology before any administrative production use.**

## Evidence vocabulary

This review uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement or an accountable decision.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, browser automation, fault injection, accessibility testing, restore work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed consolidated Batch 05 implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

# 0. Evidence boundary, file-presence record, and review method

## 0.1 Allowlisted supplied evidence

**FACT.** All ten allowlisted Project files were present. No missing-file substitution was required. The three topic results and two predecessor results carried local suffixes, but their titles and declared result paths identify the allowlisted logical files. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Role and limitation |
|---|---|---|---|---|
| I01 | `19-portal-authorization-result.md` | `19-portal-authorization-result(1).md` | `9375ba44492369a43c9109d70980b5cc07f7b8b5450ba3f4f42f13777f6b80cb` | Capability RBAC, closed conditions, realm/purpose/target evaluation, JIT, approvals, break-glass, BFF sessions, service identities, decision evidence, restore, tests, and repository review. It is a recommendation, not passed runtime evidence or production authority. |
| I02 | `20-portal-information-workflows-result.md` | `20-portal-information-workflows-result(1).md` | `f8b75878b3108424c40b8c296a5df3861e0cc29739ce3190720bb9d313be92e6` | Portal/BFF trust boundary, information architecture, aggregate-first read models, explicit command workflows, accessibility, usability, jobs, recovery, framework/design-system candidates, and tests. It does not decide actual users, roles, purposes, retention, or production technology. |
| I03 | `21-transactional-audit-result.md` | `21-transactional-audit-result(1).md` | `769502a491ece4182f8757c3535e5a6ac05cf52596bf9c9f6e80817e5892d722` | Same-transaction typed audit, audit-before-disclose, hash/Merkle structure, external checkpoints, verification, gaps, audit access, restore, native database controls, tests, and repository review. It does not establish legal admissibility, retention, verifier ownership, key custody, or production readiness. |
| I04 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, UUIDv7, realm isolation, product privacy ceiling, tenant narrowing, application identity, repository/release boundaries, and durable privileged-audit invariant. |
| I05 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted endpoint source/privacy boundary, source/event identity, whole-page atomic progress, minimized outputs, and interpretation limits. |
| I06 | `batch-03-review-result.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted release, identity, diagnostics/support, compatibility, endpoint durability, and the rule that operational logs are not privileged audit. |
| I07 | `batch-04-review-result.md` | `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted server modular-monolith boundary, relational transactions, durable custody, typed facts, lifecycle barriers, restore read blocking, audit obligations, exports/integrations, and database-engine comparison posture. |
| I08 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Shared accepted baseline and non-negotiable invariants; condensed architecture, not runtime or production proof. |
| I09 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted proof order, resolved tensions, no-broker default, and stop rule. |
| I10 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, primary-source preference, human-authority boundary, and conflict discipline; proves no technical claim by itself. |

## 0.2 Review hierarchy and conflict resolution

Conflicts were resolved in this order:

1. preserve I04–I09 accepted predecessor decisions and non-negotiable invariants;
2. prefer the design with narrower authority, smaller privacy/security surface, and clearer fail-closed behavior;
3. distinguish authentication from authorization, authorization from approval, approval from execution, execution from audit, and audit from independent verification;
4. distinguish portal presentation schemas from canonical domain and audit schemas;
5. distinguish documented platform capability from UAM-specific transactional, accessibility, restore, and operational fitness;
6. prefer one canonical source of truth and one explicit state machine over overlapping records with similar names;
7. preserve human-owned policy choices as disabled or conservative defaults rather than inventing roles, purposes, durations, or legal outcomes;
8. preserve exact versions and numbers as execution-time evidence unless the architecture genuinely depends on a protocol version;
9. require the smallest falsifying **CLI EXPERIMENT** where prose cannot settle correctness or fitness;
10. open an accepted-baseline change proposal only if the consolidated decision would actually replace a predecessor invariant.

**FACT.** No accepted-baseline change proposal is required by this review. The topic results are largely consistent. The significant conflicts are resolved by making I03's audit ledger canonical, treating I01's authorization decision as a separately typed decision object referenced by that ledger, and treating I02's portal audit contract as a read projection rather than a competing ledger schema.

## 0.3 Current primary-source verification scope

Required web verification was intentionally limited to load-bearing disputed or time-sensitive claims. The reviewed primary sources include:

- RFC 9700, *Best Current Practice for OAuth 2.0 Security*, January 2025;
- `draft-ietf-oauth-browser-based-apps-27`, dated 6 July 2026, explicitly still an Internet-Draft and work in progress;
- WCAG 2.2, W3C Recommendation published 12 December 2024;
- ETSI's 16 July 2026 status page listing EN 301 549 V4.1.0 (2026-06) as **On Approval**, while V3.2.1 remains the current published reference used by existing harmonisation/procurement material;
- Microsoft SQL Server Ledger, digest, verification, limitation, and SQL Server Audit documentation current to the review date;
- pgAudit repository and 18.0 release, including its current documentation's explicit best-effort, nontransactional caveat;
- immutable release/tag points for the load-bearing .NET, authorization-reference, portal-component, and transparency-log repositories listed in section 11.

Vendor marketing, popularity, stars, search snippets, and upstream claims of production readiness were not used as proof of UAM fitness.

## 0.4 Scope of the consolidated result

This review resolves the Batch 05 architecture for:

- browser/BFF/session trust boundaries;
- route, action, resource, realm, purpose, target, output, and state authorization;
- standing, delegated, JIT, approval-gated, service, and emergency grants;
- task-oriented portal information architecture and least-detail read models;
- explicit administrative commands, impact previews, concurrency, idempotency, durable jobs, notifications, and recovery;
- accessibility of complete administrative workflows;
- same-transaction authorization decision, business mutation, and typed audit event;
- audit-before-disclose for sensitive reads and exports;
- audit streams, hash/Merkle verification, independent checkpoints, access, export, retention mechanics, gaps, and restore;
- synthetic personas, route catalogues, test fixtures, fault injection, accessibility testing, and gate evidence.

It does not select or approve the human-owned matters listed in section 6.

## 0.5 Consolidated assumptions and falsifiers

| ID | **ASSUMPTION** | Why it is bounded | Smallest falsifier / consequence |
|---|---|---|---|
| AS05-01 | The initial portal can be served through the same origin as its control BFF. | It matches the accepted modular-monolith/control-BFF posture and reduces browser token/CORS surfaces. | Deployment prototype shows a required topology cannot support same-origin; open an ADR and run the full alternate token/CSRF/realm matrix. |
| AS05-02 | Enterprise human authentication can be integrated through an OIDC-capable confidential client. | Current enterprise IdPs commonly expose such profiles, but the actual provider/topology is not selected. | Exact IdP inventory lacks required issuer, code-flow, logout, session, or step-up behavior; select and prove another federation profile. |
| AS05-03 | The finite first-slice resource/action set can be represented by release-owned typed capabilities and closed conditions. | The supplied workflows are explicit and bounded; no tenant-authored policy need is established. | Route/capability inventory produces irreducible policy complexity or independent-service sharing that the pure kernel cannot safely express. |
| AS05-04 | Normal administration can be completed from aggregate, status, revision, quality, and workflow evidence without person/activity detail. | The accepted baseline treats telemetry as fallible operational evidence and leaves detail purpose human-owned. | Representative approved tasks cannot be completed without a defined minimum detail contract; open the detail-purpose/access/retention ADR rather than adding a generic route. |
| AS05-05 | Privileged portal commands are mediated by application/domain services rather than direct ad hoc SQL. | This follows the modular-monolith and narrow-contract predecessor decisions. | Effective-access inventory finds an ordinary operational path that requires direct DB mutation; remove it or open a baseline change proposal and equivalent audit/recovery proof. |
| AS05-06 | The selected relational engine can atomically commit final authorization evidence, business mutation, audit event, stream head, and required job/outbox rows. | Both candidate engines support transactions, but the exact UAM schema and provider behavior are unproved. | E05-11 produces a partial or unresolvable commit history on either candidate; narrow the design or change the transaction mechanism by ADR. |
| AS05-07 | Privileged command/audit volume is materially lower than endpoint fact ingestion and can initially use one ordered stream per realm plus product-global streams. | Control-plane actions are expected to be less frequent, but no approved distribution exists. | E05-27 shows unacceptable hot-stream contention, starvation, or cost; introduce a complete stream-partition manifest and reprove omission detection. |
| AS05-08 | An administrative failure domain separate from ordinary product/database administration can hold verifier credentials, signing keys, state, checkpoints, and alerts. | Meaningful external verification requires this separation, but no owner/topology is assigned. | Organization/topology cannot supply independent administration; production tamper-evidence claim remains blocked or requires an external/witness model. |
| AS05-09 | Canonical audit bytes and verification semantics can remain deterministic across supported releases and independent implementations. | Strict contracts and standard-derived profiles make this plausible, but no cross-version vectors have passed. | E05-15 finds semantic/canonical divergence; freeze the affected profile and open a migration/epoch ADR before persistence. |
| AS05-10 | Critical administrative workflows can be completed in supported browsers with accessible, standards-first controls. | The design avoids exotic interaction patterns, but exact browser/AT/framework behavior is unproved. | E05-24/25 finds a critical task that cannot be made accessible without changing the workflow or technology; block that capability and redesign. |

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The three topic results agree strongly enough to accept the following consolidated Batch 05 architecture for T1 implementation prototypes:

1. a same-origin browser application and ASP.NET Core control BFF inside the accepted modular monolith;
2. a small in-process, deny-by-default authorization kernel using release-owned capability RBAC plus a closed set of purpose, realm, target, time, state, approval, authentication, output, and safety conditions;
3. explicit task-oriented read models and command handlers rather than generic CRUD, direct database administration, arbitrary policy languages, or hidden production actions;
4. aggregate-first, least-detail portal views with no person/activity-detail route or API until an accountable human decision approves a purpose and minimum data contract;
5. a reusable safe command pattern using immutable preview, current version, idempotency identity, finite reason, exact approvals, final transactional reauthorization, durable audit, and durable job state;
6. one canonical application-owned typed audit ledger written in the same relational transaction as every privileged business mutation;
7. audit-before-disclose for sensitive reads, audit queries, downloads, support bundles, and exports;
8. one realm/global audit-stream model with monotonic sequence, event hash chain, sealed Merkle segments, and independently protected signed checkpoints;
9. a fixed, bounded break-glass recovery profile that never becomes a universal superuser or an unaudited path;
10. WCAG 2.2 Level AA as the engineering target for every in-scope workflow, with automated checks plus manual keyboard and assistive-technology execution;
11. restore behavior that blocks ordinary reads, egress, privileged mutation, stale grants, and audit trust until current authorization state, tombstones, acknowledged data, audit continuity, and verification state reconcile.

**FACT.** None of I01–I03 contains executed evidence that closes the consolidated gate. I01's authorization gates, I02's portal/accessibility gates, and I03's transaction/verification gates all remain open.

**Therefore:**

> **The architecture is accepted for strict contracts, pure models, fictional fixtures, same-origin BFF scaffolding, read-only aggregate portal screens, synthetic persona tests, command/audit prototypes, independent verifier prototypes, accessibility tooling, and isolated restore drills. The Batch 05 gate remains OPEN. No administrative production use, real role assignment, live detail access, production export, destructive lifecycle command, connector activation, break-glass activation, audit pruning, verifier trust, evidentiary claim, pilot, or production deployment is authorized.**

## 1.2 Consolidated batch gates

| Gate | Current status | Required closure evidence | Non-waivable stop condition |
|---|---|---|---|
| **B05-CATALOGUE — complete route/capability/action inventory** | **OPEN — CLI EXPERIMENT** | Every route, background command, job phase, sensitive field profile, and emergency operation maps to an immutable descriptor and exact capability; generated negative tests and owner records exist. | One executable action lacks a descriptor, uses wildcard/default authority, or is callable only through a hidden/unclassified path. |
| **B05-SESSION — BFF/OIDC/session/CSRF/token boundary** | **OPEN — CLI EXPERIMENT** | Confidential-client integration; server-side tokens/session; fixation, mix-up, logout, realm-switch, CSRF, storage, XSS-token-extraction, cache, and expiry tests. | Browser-accessible access/refresh token; unsafe cross-site state change; stale privileged session after logout/revocation/realm switch; authority from browser claim. |
| **B05-REALM — realm isolation and confused-deputy resistance** | **OPEN — CLI EXPERIMENT** | Multi-realm/persona campaign across API, BFF, read models, jobs, caches, exports, deletion, audit, verifier status, and service identities. | One cross-realm authorization, row, field, object, cache hit, job effect, export, audit result, checkpoint association, or existence disclosure. |
| **B05-PURPOSE — purpose, target, output, and case binding** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Approved purpose registry mechanics; exact target/scope manifests; ticket/case binding; output-field profiles; unknown/missing/stale negatives. | A sensitive capability succeeds with missing, stale, mismatched, free-form, or unapproved purpose/target/output authority. |
| **B05-JIT — grant, approval, revocation, and long-job authority** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Fake-clock and database-time campaigns, content-bound approvals, SoD negatives, grant activation/expiry/revocation, epoch invalidation, cache behavior, job phase reauthorization. | Expired/revoked grant commits; changed request reuses approval; requester self-approves where forbidden; long job continues effects beyond authority. |
| **B05-WORKFLOW — explicit safe administrative commands** | **OPEN — CLI EXPERIMENT** | Preview/execute TOCTOU tests, `If-Match`, command idempotency, scope snapshots, durable jobs, pause/kill/rollback, truthful failure/limitation, no generic mutation. | Generic row mutation or SQL path; stale preview executes; response loss duplicates effect; job state exists only in browser; hidden production action. |
| **B05-AUDIT-ATOMIC — transactional decision/mutation/audit** | **OPEN — CLI EXPERIMENT** | Failpoints at every transaction boundary for decision, business effect, audit insert, stream head, job/outbox, commit, and response; command reconciliation. | Privileged effect commits without its required authorization decision and success audit; audit claims success without effect; retry creates a second effect. |
| **B05-AUDIT-ACCESS — audit-before-disclose and minimum access** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Sensitive-read, audit-query, export, support-bundle, and download buffering/release tests; purpose/realm/redaction/export profiles; hostile encoding tests. | Sensitive bytes leave the server before access audit commits; unauthorized field/cross-realm result; arbitrary SQL/full dump; untracked export. |
| **B05-AUDIT-VERIFY — tamper evidence and independent restore verification** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Alter/reorder/gap/duplicate/rollback corpus; independent canonicalization/Merkle implementation; signed external checkpoint; ordinary-admin/DBA tests; old-backup restore comparison. | Any required tamper survives undetected; local rollback is trusted without external state; ordinary product/DB administration can alter history undetected; failed verification self-clears. |
| **B05-ACCESSIBILITY — complete critical workflows** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Automated semantics, keyboard, screen-reader, zoom/reflow, forced-colors, reduced-motion, status-message, timeout, error-recovery, destructive-confirmation, and task-success evidence. | A critical authorized/denied/approval/break-glass/audit/restore workflow cannot be completed or understood without pointer, vision, color, or inaccessible authentication. |
| **B05-BREAKGLASS — bounded emergency recovery** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Disabled-by-default fixed profile; independent activation/revocation; hard expiry; alert; recovery-only commands; audit/checkpoint continuity; post-review; lockout drill. | Universal bypass; self-activation; detail/export by default; no expiry; ordinary portal/DB admin silently clears; no independent evidence or alert. |
| **B05-RESTORE — authority and audit continuity after recovery** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | Restore under new environment identity; current grant/revocation/catalogue/tombstone/checkpoint replay; deleted-negative and authorized-positive probes; no pre-ready read/egress/mutation. | Restored stale session/grant/approval/break-glass becomes active; missing/gapped audit accepted; reads/egress/mutation enabled before readiness. |
| **B05-OWNERS — accountable human authority** | **OPEN — HUMAN DECISION** | Owners for capability catalogue, purposes, roles, approvals, accessibility, audit access/retention, verifier, break-glass, support, incident response, and production risk are recorded. | Any production capability, workflow, audit class, verifier, emergency path, or critical support obligation has no accountable owner. |
| **B05-AGG — aggregate portal-governance gate** | **OPEN** | All required technical gates pass for one exact release/topology; required human decisions are recorded; ADRs accepted; evidence current; cleanup complete. | Any hard failure, missing/expired evidence, unresolved contradiction, blocking human decision, unassigned owner, or cleanup residue. |

## 1.3 Immediate permission

**RECOMMENDATION — GO now** for:

- immutable capability, route, event, command, page-state, workflow, and audit catalogues;
- pure C# authorization, grant, approval, break-glass, preview, state-machine, canonicalization, hash, and verification models;
- deterministic fictional realms, principals, personas, capabilities, purposes, resources, approvals, cases, commands, audit events, exports, checkpoints, gaps, and restore fixtures;
- same-origin BFF session and CSRF prototypes against a synthetic identity provider;
- read-only aggregate portal shell, task-oriented navigation, standard page states, and accessibility scaffolding;
- exact command/idempotency/preview/job infrastructure in T1;
- same-transaction PostgreSQL and SQL Server audit prototypes using fictional data;
- isolated verifier/checkpoint-store prototypes with lab-only keys and credentials;
- route, realm, purpose, output, cache, fault, tamper, accessibility, and restore tests;
- front-end/design-system and optional dependency bake-offs without production commitment.

## 1.4 Immediate prohibition

**RECOMMENDATION — STOP** before:

- mapping real people, directory groups, job titles, departments, or organization roles to capabilities;
- enabling any live activity/person detail route, audit-detail route, export, support bundle, deletion, integration, policy publication, release promotion, authorization administration, or break-glass capability;
- accepting an identity-provider role, OAuth scope, hidden button, route name, browser realm value, database RLS rule, or operational log as the sole authorization/audit boundary;
- exposing access or refresh tokens to JavaScript-visible browser storage;
- introducing a generic external policy engine, relationship graph, workflow platform, admin generator, table editor, arbitrary JSON Patch, SQL, regex, script, plug-in, command, path, URL, or destination channel;
- permitting a privileged business effect without same-transaction decision/audit evidence;
- releasing sensitive response bytes before durable access audit;
- claiming audit non-repudiation, legal admissibility, regulatory sufficiency, or complete forensic truth;
- trusting a restored local audit head without current external checkpoint and authority reconciliation;
- using SQL Server Ledger, SQL Server Audit, pgAudit, a transparency log, or an immutable database as a substitute for the canonical typed application ledger;
- pilot or production deployment.

## 1.5 Executive residual risk

The accepted architecture contains rather than eliminates risk:

- an authorized or colluding human can approve harmful but permitted work;
- a compromised identity provider can authenticate an attacker, and a compromised browser/BFF can misuse current authority;
- a malicious authorized release can emit a cryptographically coherent but semantically false or incomplete audit record;
- application, database, host, verifier, key, object-storage, and incident administrators can collude or share one failure domain;
- the unanchored audit tail remains more exposed than externally checkpointed history;
- hash chains and signatures prove byte relationships and key use, not lawful purpose, truth, completeness, or legal admissibility;
- fail-closed authorization, audit, verifier, accessibility, or restore controls can cause administrative outage and backlog;
- audit metadata, aggregate views, rare populations, case identifiers, export manifests, and support evidence can still enable inference;
- accessibility conformance does not cover every user need and can regress with browser, assistive-technology, design-system, or framework updates;
- downloaded exports and unsupported recipient copies cannot be technically recalled by UAM;
- recurring negative tests, accessibility testing, independent verification, key ceremonies, restore drills, support, and evidence renewal require staffing and budget not established by supplied evidence.

Containment is explicit authority, least detail, immutable contracts, same-transaction enforcement, stable idempotency, independent verification, scoped safety holds, no self-reenable, accessible recovery, synthetic-first evidence, and truthful uncertainty.

## 1.6 Confidence summary

| Major conclusion | Confidence | Why | Evidence that could change it |
|---|---|---|---|
| Same-origin BFF with server-side session/tokens is the right initial browser boundary | **High** | It fits the accepted modular monolith and minimizes browser token, CORS, realm, and duplicate-authorization surfaces; current OAuth guidance supports the pattern. | A deployment constraint and alternative prototype that passes identical token, CSRF, realm, revocation, audit, accessibility, and support tests with lower assurance cost. |
| Capability RBAC plus closed conditions is the right first authorization model | **High** | The UAM resource/action set is finite and release-owned; purpose, target, state, time, approval, and output need more than pure RBAC but not a tenant policy language. | Route/capability growth or multi-service deployment evidence showing an alternative is materially simpler and equally analyzable. |
| Explicit command/read models are safer than generic administration | **High** | Preview, state, idempotency, approval, audit, rollback, and recovery are domain-specific and cannot be reliably supplied by generic CRUD. | A bounded framework proving complete semantic equivalence, lower risk, and lower total cost for every critical workflow. |
| Aggregate-first, no-detail-by-default is the correct initial portal posture | **High** | It preserves minimization and avoids turning fallible telemetry into person/productivity evidence while detail purpose remains human-owned. | Approved purpose, minimum schema, access/retention/appeal controls, consultation, and representative task evidence showing detail is necessary. |
| Same-transaction typed audit is required | **High** | It directly implements the accepted invariant and avoids successful unaudited mutations or false success logs. | A simpler mechanism proving identical atomicity across all failure and restore boundaries. |
| Independent external checkpoints are required before privileged production use | **High** | Local-only append controls do not detect all database/host-admin alteration; independently protected state materially changes the threat boundary. | A formally accepted threat model excluding those administrators or another independently recoverable mechanism proving equivalent detection. |
| Per-realm/global hash chains plus sealed Merkle segments are fit for a first prototype | **Medium-High** | Standard append-only verification concepts fit engine neutrality; UAM composition, contention, and retention remain untested. | Model counterexample, unacceptable write contention, or a simpler equivalent proof structure. |
| Break-glass can be safe enough for production | **Medium-Low** | A bounded recovery-only design is plausible, but actual authority, custodians, monitoring, staffing, and recovery environment are unknown. | Passed independent drills plus recorded human authority, key, monitoring, and operational coverage. |
| WCAG 2.2 AA is the correct engineering target | **High** | It is the current stable W3C Recommendation and directly covers focus, status, authentication, input, and error requirements relevant to these workflows. | A recorded organizational/legal policy imposing a stronger or different target. |
| Any administrative production surface is currently ready | **Low / not established** | Every technical aggregate gate and material human decision remains open. | Current exact evidence passing B05-AGG plus separate production risk approval. |

---

# 2. Accepted decisions and invariants

## 2.1 Accepted predecessor invariants carried forward without change

The following are **FACT** from I04–I09 and remain non-negotiable:

| ID | Accepted invariant |
|---|---|
| A05-01 | Realm, installation, device, user, session, and product-global authority comes from authenticated server/runtime context, never a browser/body/header/display-name claim. |
| A05-02 | One user, session, installation, or realm cannot view, submit, mutate, export, approve, hold, delete, audit, restore, or execute as another. |
| A05-03 | A privileged mutation cannot succeed without durable audit evidence. |
| A05-04 | The product privacy ceiling is release-authorized; tenant policy may only narrow it. Portal flags, roles, workflows, and break-glass cannot broaden it. |
| A05-05 | Minimization precedes durable storage, logs, diagnostics, support, transport, exports, and portal disclosure. |
| A05-06 | Operational logs, metrics, diagnostics, identity-provider claims, and browser state are not the privileged audit ledger. |
| A05-07 | The initial server is a modular monolith with a control API/BFF and relational transaction boundary. |
| A05-08 | The production database and audit storage technologies remain provisional; PostgreSQL is the reference candidate and SQL Server a serious fallback. |
| A05-09 | Stable identities and central uniqueness make retry/replay produce one final business effect. |
| A05-10 | Receipt, validation, materialization, integration, visibility, deletion, restore readiness, and audit verification are distinct states. |
| A05-11 | Restore cannot expose deleted data, lose acknowledged events, revive stale authority, or enable ordinary reads before readiness. |
| A05-12 | Signed/release/control rollback republishes prior semantics at a higher revision/sequence; state does not silently move backward. |
| A05-13 | Feature flags and kill switches may narrow, pause, or disable; none bypasses realm, audit, receipt, tombstone, release, or readiness invariants. |
| A05-14 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| A05-15 | Legal purpose, prohibited use, identity level, retention, access, employee consultation, budget, SLO/RPO/RTO, ownership, pilot, production risk, and deployment approval remain human decisions. |
| A05-16 | A failed early gate stops dependent work and opens an ADR/change review. Passing proves only the exact claim, release, environment, topology, and evidence scope. |

## 2.2 Browser, BFF, session, and realm authority

**RECOMMENDATION — ACCEPT.**

1. The portal is initially a same-origin browser application served through an ASP.NET Core control BFF inside the modular monolith.
2. The browser is an untrusted presentation client. It does not authorize, derive realm, hold general API credentials, sign control artifacts, compile policy, or mutate persistence models.
3. Access, refresh, and ID tokens remain server-side. The browser receives an opaque `Secure`, `HttpOnly`, host-scoped session cookie and an explicit CSRF mechanism for unsafe methods.
4. The BFF creates an immutable authenticated context containing principal, principal type, authentication context, one active realm or explicit product-global mode, session generation, authorization epoch, and expiry.
5. Realm switch creates a new security context, invalidates realm-scoped caches, clears realm-scoped browser state, rotates CSRF/session state, and is announced accessibly.
6. A route/query/body realm may be a display or hostile-test field but never authority. The trusted target resolver derives target realm and compares it with the authenticated context before data access.
7. Product-global actions use a distinct route, capability, scope, stream, and audit namespace. Missing realm never means global authority.
8. `GET`, `HEAD`, and `OPTIONS` are side-effect free. Mutations use explicit named commands, not generic persistence verbs.
9. Sensitive and personalized responses use `Cache-Control: no-store`; initial administration routes are not service-worker/offline mutation surfaces.
10. Button visibility and returned capability hints improve usability only. Every direct route, background command, and job phase reauthorizes server-side.

## 2.3 Capability, purpose, target, and output authorization

**RECOMMENDATION — ACCEPT.**

1. UAM owns an immutable release-authorized capability catalogue. A capability is an exact resource/action tuple with scope kinds, risk class, grant modes, purpose requirement, approval profile, authentication profile, output profile, audit class, and lifecycle.
2. There is no wildcard capability, implicit superuser, default allow, tenant-authored action, or mutable role-name authority.
3. Roles are immutable versioned bundles of exact capabilities and constraints. Role display names and identity-provider group names are not final route authority.
4. The authorization predicate is deny-by-default. Missing, unknown, stale, conflicting, malformed, cross-realm, multiply resolved, or unsupported inputs deny.
5. The initial condition language is closed and release-owned. It may evaluate only defined primitives such as realm match, target membership, resource state/version, purpose, ticket/case, grant activity, approval/SoD, authentication profile, output profile, destination approval, product/tenant policy, restore/readiness, compatibility/release, and bounded operation budget.
6. Tenant configuration may choose narrower values, shorter times, smaller scopes, and stricter profiles; it cannot add expressions, scripts, SQL, regexes, paths, network attributes, arbitrary identity attributes, or external data fetches.
7. Purpose is an approved identifier and revision, not free text. Sensitive capabilities deny while their approved purpose registry is empty.
8. Target scope is an immutable typed manifest or release-owned bounded filter snapshot. A browser-selected page or list is not execution authority.
9. Authorization obligations select the permitted response/read/export field profile before query/projection; the server does not fetch a broad object and rely on late client redaction.
10. Cross-realm oversight, if ever approved, is a separate product-global or case-bound capability with a content-addressed multi-realm manifest, not a generic combined dashboard.

## 2.4 Standing, delegated, JIT, approval, and service authority

**RECOMMENDATION — ACCEPT THE MECHANISMS; KEEP REAL PROFILES HUMAN-OWNED.**

1. Standing grants are candidates only for explicitly approved low/moderate-risk capability classes and always bind principal, realm/global mode, role/capability revision, exact scope, purpose classes, not-before, expiry/review, assignment generation, and owner/approval evidence.
2. Delegation is disabled by default and, where approved, is a strict subset of the delegator's capability, realm, scope, purpose, authentication, duration, approval, and delegation-depth envelope.
3. Sensitive detail, export, audit export, diagnostic escalation, destructive lifecycle work, authorization administration, high-risk release/policy publication, and break-glass are JIT or explicitly exception-gated candidates rather than broad standing defaults.
4. A JIT request binds beneficiary, realm, exact capabilities, target/scope, purpose, ticket/case, output profile, start/end, authentication profile, current resource/control versions, and immutable request digest.
5. Approval authorizes activation of the exact request; it is not itself an active grant. Request content change, target change, preview expiry, version change, or authority change invalidates prior approval.
6. Separation profiles can require distinct author, requester, beneficiary, approver, executor, verifier, restore operator, and read-enabler. Which profile applies is a **HUMAN DECISION**.
7. Final high-risk authorization is re-evaluated under current database time and current locked/transactional state. A precheck or cached allow is not final authority.
8. Background work uses a narrow service identity plus job authorization lease. It does not inherit an unlimited snapshot of the submitting user's browser session.
9. Jobs reauthorize at claim and irreversible phase boundaries; revocation stops future effects without rewriting already committed history.
10. Service identities have exact audience, endpoint, realm/global scope, capability, owner, credential generation, expiry, and rotation. They cannot approve human JIT, impersonate a human, or download human-facing exports by default.

## 2.5 Portal information architecture and least-detail read models

**RECOMMENDATION — ACCEPT FOR T1 PROTOTYPES.**

1. Navigation is realm-scoped, task-oriented, capability-filtered for usability, and independently reauthorized.
2. The first navigation structure is: Overview; Fleet; Policy; Applications; Releases and tasks; Evidence; Operations; Support; Administration.
3. Internal database/service names are not primary navigation and persistence tables are never exposed as administration screens.
4. The portal starts from operational aggregates, data quality, freshness, coverage, safety holds, jobs, and controlled changes—not persons or raw events.
5. `0`, `NO_DATA`, `NOT_COLLECTED`, `SUPPRESSED`, `UNSUPPORTED`, `OFFLINE`, `DEFERRED`, `PARTIAL`, `STALE`, `SAFETY_HOLD`, and `UNKNOWN` are distinct states. The UI cannot render them as a single empty or green-success state.
6. Every summary states scope/denominator, as-of time, freshness, quality, excluded/unknown counts, and limitations.
7. The initial operational installation detail is limited to safe identifiers/aliases, compatibility, release/policy, source health, backlog/receipt/processing classes, finite error codes, and runbook links.
8. Person/activity detail is structurally absent until an approved purpose, exact minimum fields, access/retention, consultation, interpretation, appeal, and audit model exists.
9. Search is fixed, bounded, realm-scoped, metadata-only, and cannot become SQL, regex, raw activity, or arbitrary field search.
10. Empty, loading, forbidden, stale, offline, partial, unsupported, conflict, safety-hold, retryable, terminal, and completed-with-limitations states are explicit screen contracts with accessible recovery actions.

## 2.6 Administrative command and workflow baseline

**RECOMMENDATION — ACCEPT.**

Every high-impact administrative action follows this common pattern:

```text
read current immutable revision/state
  -> create or edit a draft using closed fields
  -> validate structural and semantic rules
  -> resolve server-owned scope and compute immutable impact preview
  -> collect exact approvals required by current policy
  -> execute with command ID + If-Match/version + preview digest + finite reason
  -> reauthorize against current state inside the transaction
  -> commit business transition + authorization decision + audit + durable job/outbox
  -> observe durable job/progress state
  -> pause, kill, rollback, revoke, or recover through separate explicit commands
  -> verify terminal state and close
```

Normative refinements:

1. There is no generic table editor, object save, arbitrary JSON Patch, dynamic handler, GraphQL explorer mutation, SQL console, script, regex, command, path, plug-in, or free-form destination.
2. Bulk scope is resolved and content-addressed by the server. The browser cannot execute a stale list obtained from pagination.
3. An impact preview binds command type, resource/version, scope digest, command digest, current dependencies, affected/excluded/unknown counts, risk, approvals, limitations, and recovery controls.
4. Execution recomputes current preconditions. Any material change returns `PREVIEW_STALE`; the server never silently applies old approval to new state.
5. `command_id` is the idempotency identity. Same ID/same digest returns the prior result; same ID/different digest is an integrity conflict.
6. `If-Match` and domain version protect revisioned resources; no last-write-wins behavior is allowed for privileged administration.
7. A `202 Accepted` response means a durable command/job exists, not that the business outcome completed.
8. Durable jobs preserve first failure, retry lineage, milestones, cancellation rules, current authority, and recovery links. Browser refresh or reconnect cannot create a new operation identity.
9. Notifications are secondary delivery and never transaction, approval, completion, or custody authority.
10. Policy/rule/release rollback republishes prior approved semantics at a higher revision or sequence.
11. Deletion commits a visibility barrier before physical deletion; external recipients receive truthful limitation states.
12. Kill switches have distinct activate and clear commands; clear requires recovery evidence and cannot self-clear.

## 2.7 Transactional authorization decision and canonical audit ledger

**RECOMMENDATION — ACCEPT.**

1. `AuthorizationDecisionV1` is a typed immutable decision record containing actor/context, capability, purpose, target, grant, approval, policy/catalogue/route revisions, output obligations, result, finite reason, evaluation time, and validity.
2. `AuditEventV1` is the canonical typed business audit event. It references the authorization decision ID and digest for privileged operations instead of duplicating a second independently mutable authorization truth.
3. For a successful privileged mutation, final authorization decision, business mutation, canonical audit event, audit stream-head advance, and required job/outbox rows commit in one relational transaction.
4. A failed or denied command records a separate bounded audit-only outcome only after the system proves no prohibited business mutation committed.
5. Unknown commit result is reconciled by stable `command_id`; retry does not mint a new command or audit success identity.
6. The canonical event uses closed family/type/outcome/severity fields, opaque actor and target identifiers, approved purpose code, minimized change profile, finite result/error code, command/workflow/case correlation, explicit time quality, stream sequence, previous hash, and event hash.
7. Free-form request/response payload, token, group list, URL, path, SQL, selector, activity, arbitrary exception, stack, credential, secret, and dynamic diagnostic text are structurally absent.
8. Realm-scoped and product-global streams are distinct. One stream sequence establishes order; wall-clock time and UUID timestamp bits do not.
9. Source audit rows are never updated to redact or correct. Redaction is a versioned read/export projection; correction is a new linked event.
10. Ordinary runtime roles cannot update, delete, truncate, or reset the audit ledger. Privileged database/host tampering is addressed by independent verification, not by pretending database grants constrain superusers absolutely.

## 2.8 Audit-before-disclose

**RECOMMENDATION — ACCEPT.**

1. The security boundary for a sensitive read is release of bytes, not the internal database query.
2. The server authorizes the exact read, executes/buffers the bounded result, appends the access event, commits, and only then serializes/releases response bytes.
3. If audit commit fails, the result buffer is discarded and no sensitive bytes are released.
4. Large results use an asynchronous export workflow: request/approval audit, bounded artifact build in private staging, manifest/content digest, completion audit, then one-use retrieval capability.
5. Audit query and audit export are themselves sensitive capabilities with separate purpose, field/redaction profile, case/approval where required, pagination, and access audit.
6. Search filters are fixed typed fields. Arbitrary SQL, unbounded full-text payload search, hidden fields, and “download all” are absent.
7. Export artifacts record purpose, exact scope manifest, field profile, row count, digest, recipient class, expiry, retrieval, revocation, and deletion/limitation state. Export content is not copied into the audit event.

## 2.9 Tamper evidence and independent verification

**RECOMMENDATION — ACCEPT THE PORTABLE CORE; KEEP TECHNOLOGY, OWNER, AND VALUES OPEN.**

1. Each event is canonicalized under a frozen profile and linked to the prior event hash in its stream.
2. A sealed segment covers one contiguous stream range and records first/last sequence/hash, count, canonicalization/schema profiles, previous segment digest, and Merkle root.
3. An independent verifier re-canonicalizes events and recomputes sequence, event hashes, segment root, and checkpoint continuity. It does not trust stored hashes alone.
4. The verifier uses read-only database access, a separate executable/build review path, a purpose-separated signing key, separately protected state, and checkpoint storage outside ordinary product/database administration.
5. Production privileged use requires a current independently protected checkpoint under an approved freshness policy. External checkpointing is optional only for early isolated transaction prototypes, not for production eligibility.
6. Verification returns finite states such as `PASS`, `GAP`, `ALTERED`, `FORK`, `STALE_INPUT`, `INCOMPLETE`, or `UNAVAILABLE`; unknown never becomes pass.
7. Verification failure creates an automatic scoped technical hold on affected privileged work and sensitive disclosure. Ordinary administration cannot clear it.
8. Gaps are not repaired by synthetic normal events. An approved investigation may declare a gap and begin a new linked epoch; the missing evidence remains explicit.
9. Checkpoints contain opaque stream/epoch IDs, counts, roots, digests, key/verifier identity, lineage, times, and finite findings—not activity content, actor names, selectors, or change details.
10. SQL Server Ledger, SQL Server Audit, and pgAudit may provide defense in depth after exact engine-specific tests. None replaces UAM event semantics or same-transaction application audit.

## 2.10 Audit access, retention mechanics, and restore

**RECOMMENDATION — ACCEPT THE MECHANISMS; KEEP POLICY OPEN.**

1. Audit access is capability-, purpose-, realm-, case-, field-, and redaction-profile bound and is itself audited before disclosure.
2. Display identity is resolved at view time from an authorized projection; durable events retain opaque principal identity and provenance revision.
3. Audit event content is minimized at creation. Production fields, access, and periods are **HUMAN DECISION**.
4. Retention/pruning is by whole sealed segment after approved policy, no hold, external checkpoint, continuity, export/case completion, target manifest, authorized command, and durable audit.
5. Source events are not edited for field expiry. A future field-level expiry requirement needs a new cryptographic/data model and baseline change proposal.
6. Checkpoint/root and minimum destruction evidence may have a different approved period from event content; no period is selected here.
7. Restore uses a new isolated environment identity and begins with ordinary reads, sensitive disclosure, connector/export egress, privileged mutation, receipt authority, and breakpoint-clearance disabled.
8. Restore readiness reconciles current authorization catalogue/epochs/revocations/grants/approvals, tombstones, acknowledged data, audit stream/checkpoints, command/effect/event inventories, keys, and verifier state.
9. The restored local audit head is never trusted as the latest truth without independent checkpoint comparison.
10. Readiness and actual read enablement are separate privileged decisions. Break-glass cannot bypass restore reconciliation.

## 2.11 Accessibility, usability, and safe interpretation

**RECOMMENDATION — ACCEPT WCAG 2.2 AA AS THE ENGINEERING TARGET; FORMAL POLICY REMAINS HUMAN-OWNED.**

1. Accessibility applies to complete authorized, denied, approval, expiry, job, audit, break-glass, hold, export, and recovery workflows—not merely page templates.
2. Native HTML is preferred; ARIA fills semantic gaps and does not replace correct native controls.
3. Every workflow is keyboard operable with logical focus, visible focus, predictable focus restoration, and no pointer-only action.
4. Realm, environment, authorization, expiry, risk, verification, hold, partial, stale, job, and error states are exposed programmatically and not by color alone.
5. Asynchronous status messages are announced without unexpectedly stealing focus.
6. High-impact commands provide accessible review, exact scope/risk, error prevention, confirmation, and recovery; destructive confirmation does not rely on inaccessible cognitive puzzles.
7. Time-limited sessions/JIT grants warn accessibly; warning does not extend authority. Safe draft state may survive, but execution reauthorizes.
8. Charts and timelines have text/table equivalents; verification gaps/forks are not conveyed only through diagrams.
9. Critical tables expose headers, sort state, pagination position, and row/action names correctly.
10. Automated scanners are necessary but insufficient. Manual keyboard, screen-reader, zoom/reflow, forced-colors, reduced-motion, and representative task testing are gate evidence.
11. WCAG conformance does not imply legal/procurement conformance with EN 301 549 or every user need. Formal mapping remains a **HUMAN DECISION**.

## 2.12 Break-glass and emergency recovery

**RECOMMENDATION — ACCEPT THE FIXED RECOVERY MODEL; KEEP IT DISABLED UNTIL OWNERS AND DRILLS EXIST.**

1. Break-glass is a separately authenticated, time-bounded, incident-bound grant for a fixed recovery capability profile. It is not `admin:*`.
2. Initial candidate operations are limited to freezing privileged mutations, revoking compromised sessions/grants, activating an already approved narrowing control, restoring a known-good authorization catalogue revision, or binding a preregistered repair identity to a repair-only plane.
3. Ordinary detail, audit export, activity export, connector-secret display, arbitrary role assignment, arbitrary SQL, and bypass of realm/privacy/audit/restore controls are prohibited by default.
4. Activation requires independent authority under the approved human profile, recent/strong recovery authentication, incident reference, exact scope, hard expiry, immediate independent alert, durable decision/audit, and post-use review.
5. It cannot be approved or cleared by the beneficiary through the normal portal.
6. Expiry is non-renewable by default; extension is a new request/decision.
7. Automatic safe shutdown or product narrowing is not break-glass and may occur without a human command, but any operator-issued configuration, re-enable, or clearance remains audit-required.
8. If the ordinary portal is unavailable, a separately protected minimal recovery CLI may expose only the fixed operations and same audit/checkpoint obligations.
9. A verifier-integrity hold cannot be cleared merely by break-glass. The recovery path may preserve/contain and repair authority, but evidence uncertainty remains explicit.
10. Exact custodians, quorum, credentials, key storage, durations, alert recipients, and on-call coverage are **HUMAN DECISION**.

## 2.13 Privacy-safe observability and feature controls

**RECOMMENDATION — ACCEPT.**

1. Metrics use finite dimensions such as component, route/action class, decision result, reason family, risk class, actor type, grant mode, verification state, freshness class, database profile, and release ring.
2. Realm, principal, session, target, command, case, purpose, role name, application, URL, path, export, checkpoint hash, signature, and arbitrary exception are not metric labels.
3. Exact identifiers/digests belong in access-controlled evidence records, not global metric labels or ordinary logs.
4. The route/action catalogue computes a theoretical series bound; unknown dynamic labels fail CI.
5. A flag may disable detail, export, audit query, break-glass, checkpoint publication, retention, or a workflow. It cannot mark missing audit as verified or make a prohibited action available.
6. A safety hold can narrow or stop one realm/stream or the global plane. It cannot rewrite history or self-clear.
7. Production code contains no `skipAudit`, `ignorePurpose`, `allowCrossRealm`, `bypassApproval`, `disableCsrf`, `trustBrowserRealm`, `restoreWithoutVerify`, or equivalent flag.

## 2.14 Consolidated cross-topic invariants added by this review

| ID | Consolidated invariant |
|---|---|
| X05-01 | One route/action catalogue is authoritative for browser routes, internal command handlers, background job phases, audit events, and support/recovery operations. |
| X05-02 | A UI capability list, IdP group, OAuth scope, or route metadata is never final authority; the server kernel evaluates the exact target and current state. |
| X05-03 | `AuthorizationDecisionV1` and `AuditEventV1` are distinct but linked: the decision records why authority was allowed/denied; the event records the business/security transition. Neither silently substitutes for the other. |
| X05-04 | The canonical audit ledger is I03's typed schema. I02's portal audit representation is a redacted read model, not a second event store. |
| X05-05 | JIT eligibility, approval, grant activation, command authorization, and business execution are separate states; approval alone never creates a business effect. |
| X05-06 | A sensitive query may run before its access audit only while its bytes remain inside a bounded server buffer; no disclosure occurs before commit. |
| X05-07 | External checkpointing is a production prerequisite for the privileged surface, although transaction prototypes may precede it. |
| X05-08 | Verification holds are technical state; organizational response, notification, gap acceptance, and risk treatment remain human decisions. |
| X05-09 | A role/persona name in fixtures is not a production role, entitlement, owner, or evidence of organizational need. |
| X05-10 | One active realm per normal browser session is the first model. Product-global and approved multi-realm case workflows are separate explicit planes. |
| X05-11 | High-risk jobs reauthorize at each irreversible phase. A durable job does not preserve expired human authority indefinitely. |
| X05-12 | Break-glass may recover authority and contain incidents but cannot create purpose, broaden privacy, erase audit uncertainty, or bypass restore readiness. |
| X05-13 | Audit retention cannot be inferred from database-native irreversibility. If SQL Server Ledger conflicts with approved lifecycle needs, Ledger is optional or rejected, not the retention authority. |
| X05-14 | Whole-segment audit pruning is accepted as the first verifiable mechanism; exact periods and any future field-level expiry remain open. |
| X05-15 | Accessibility is a correctness/security gate for privileged workflows; an inaccessible control is not an acceptable hidden fallback. |
| X05-16 | A design-system or external authorization/transparency project is replaceable implementation machinery behind UAM contracts, never architecture authority by popularity. |
| X05-17 | Restore must reconcile both authorization freshness and audit integrity. Passing one does not imply the other. |
| X05-18 | No generic direct-database path is normal administration. Any separately approved emergency database operation must be fixed, independently authorized, externally detectable, reconciled, and audited. |
| X05-19 | The portal cannot claim legal completion, forensic truth, productivity meaning, or external deletion from a technical success state. |
| X05-20 | Every production numeric value—session, grant, checkpoint, page, query, export, retention, retry, performance, or availability—has a named owner, units, source, uncertainty, safety behavior, and review trigger. |


---

# 3. Rejected and deferred recommendations

## 3.1 Rejected now

| Recommendation or interpretation | Decision | Reason | Condition that could change it |
|---|---|---|---|
| Identity-provider groups, directory roles, job titles, or OAuth scopes are the UAM authorization system | **REJECTED** | They do not express exact realm, target, purpose, output, JIT, approval, lifecycle, restore, or durable-audit semantics. | They may remain authenticated identity or assignment-proposal inputs; no expected change to final UAM authorization. |
| UI-only role checks, hidden buttons, disabled controls, or route secrecy | **REJECTED** | Direct API, background job, stale client, or crafted request bypasses presentation. | No expected change. |
| Browser-supplied realm, tenant, role, purpose, or actor as authority | **REJECTED** | Violates authenticated-context and confused-deputy invariants. | No expected change. |
| Browser SPA stores access/refresh tokens and calls a broad public control API directly | **REJECTED FOR THE FIRST CONTROL PLANE** | Adds token extraction, CORS, refresh, revocation, duplicate authorization, and realm complexity without demonstrated need. | A deployment constraint and alternate architecture passing the entire B05 session/realm/audit matrix. |
| Generic `admin`, wildcard capability, default allow, inherited tenant superuser, or emergency superuser | **REJECTED** | Unbounded authority cannot be reviewed, purpose-bound, or safely tested. | No ordinary condition; requires a formal accepted-baseline change and complete threat proof. |
| General tenant-authored ABAC/XACML/Rego/CEL/policy expression language | **REJECTED INITIALLY** | Expands executable authority, external-data dependencies, test state, provenance, privacy, and outage behavior beyond the finite need. | A bounded condition need that cannot be represented safely, followed by an ADR and exact conformance/fault prototype. |
| External authorization PDP or microservice from day one | **REJECTED INITIALLY** | Creates a synchronous distributed dependency and separates final authorization from business mutation/audit inside an accepted modular monolith. | Multiple independently deployed APIs or measured scale/ownership need plus proof of transaction, cache, outage, restore, and audit semantics. |
| Relationship-graph database as the initial authority source | **REJECTED INITIALLY** | First-slice relationships are shallow; a second datastore adds tuple lifecycle, consistency, backup, restore, migration, and realm failure modes. | Real relationship depth/fan-out and a bake-off that beats the typed relational model without semantic loss. |
| Commercial PIM or Entra PIM activation is direct route authority | **REJECTED AS DIRECT AUTHORITY** | PIM can establish eligibility/approval but not UAM target, purpose, output, lifecycle, or final transaction state. | It may become an upstream workflow signal under a narrow integration contract. |
| Database RLS is the sole realm/authorization control | **REJECTED** | It does not model purpose, approval, response fields, jobs, break-glass, audit decisions, and privileged bypass roles. | No expected change; retain as defense in depth after application tests. |
| Generic admin generator, ORM CRUD surface, table editor, broad GraphQL mutation, or JSON Patch | **REJECTED** | Mass assignment and persistence coupling cannot safely express preview, purpose, state, SoD, idempotency, audit, rollback, or recovery. | No expected change for privileged UAM operations. |
| Arbitrary SQL, script, command, path, URL, regex, plug-in, transform, workflow, or destination supplied by a tenant/admin | **REJECTED** | It becomes an executable collection/egress/privilege channel outside the release-owned product ceiling. | A new fixed release-owned capability with its own contract and gate; never a general channel. |
| Client-side “select all matching” bulk authority | **REJECTED** | Browser scope is stale/incomplete and creates TOCTOU. | No expected change; server filter snapshot and impact preview are the accepted mechanism. |
| Email or notification link is approval/command authority | **REJECTED** | Links can be stale, forwarded, lack exact context, and fail accessible review. | Notification may deep-link to the authenticated portal; decision remains content-bound there. |
| Person/activity detail as default navigation or default fleet view | **REJECTED** | Conflicts with aggregate-first minimization and invites productivity/disciplinary interpretation without approved purpose. | Human-approved need and complete purpose, field, access, retention, consultation, appeal, misuse, and accessibility evidence. |
| Cross-realm combined dashboard by default | **REJECTED** | Increases rare-population, cache, confused-deputy, and disclosure risks. | A separate approved oversight purpose, minimum aggregate contract, suppression, product-global authority, and multi-realm test suite. |
| Free-form audit/query/search builder or arbitrary full-text audit payload search | **REJECTED** | Expands sensitive data, injection, accidental broad disclosure, cost, and unverifiable access semantics. | A new fixed query profile with minimum fields and separate approval; no generic expression. |
| Write the business mutation and then log success afterward | **REJECTED** | Crash or logging failure creates a successful unaudited mutation. | No expected change. |
| Send audit to an external service before or after the local commit as the primary mechanism | **REJECTED** | Before commit can record false success; after commit can lose required evidence. Cross-system atomicity is absent. | A different atomic custody architecture accepted by formal change proposal. |
| Separate authoritative audit database transaction | **REJECTED AS PRIMARY** | Can commit business without audit or audit without business. | Only if the business state and audit share a proved atomic transaction substrate. |
| Generic database trigger serializing arbitrary row images | **REJECTED AS PRIMARY** | Over-collects data, lacks purpose/approval semantics, couples schema, and can be disabled/bypassed by privileged DDL. | May be a narrow defense-in-depth check for selected tables, never the canonical event model. |
| Free-form audit `message`, generic `details` JSON, exception object, request body, SQL, or selector | **REJECTED** | Enables leakage, log injection, semantic drift, unbounded cardinality, and compatibility ambiguity. | No general exception; a new typed bounded field must pass privacy/contract review. |
| Ordinary hash/HMAC of low-entropy subject, URL, host, name, or selector as safe audit identity | **REJECTED BY DEFAULT** | Such values remain enumerable/linkable and create a secondary personal-data store. | Only a high-entropy canonical manifest or separately approved keyed token with explicit purpose/lifecycle. |
| One global audit stream for all realm actions | **REJECTED INITIALLY** | Creates avoidable contention and cross-realm coupling. | Measured need and a privacy/operations ADR; product-global control remains separate. |
| One audit stream per actor/session | **REJECTED** | Unbounded cardinality, difficult completeness, and omission by selecting another stream. | No expected change. |
| Timestamp as authoritative audit ordering | **REJECTED** | Concurrency, precision, clock changes, and restore make it unreliable. | No expected change; stream sequence remains authority. |
| Edit source audit rows to redact, correct, or repair a gap | **REJECTED** | Invalidates hashes and falsifies evidence. | Corrections/gap declarations are new typed events and linked epochs. |
| Delete audit merely because the related subject/business row is deleted | **REJECTED GENERALLY** | Destroys evidence of privileged action. | Minimize identity/content at creation and apply separately approved audit retention. |
| Retain all audit forever | **REJECTED** | No blanket purpose; creates privacy, breach, access, cost, and deletion risk. | Exact human-approved periods and holds only. |
| SQL Server Ledger, SQL Server Audit, or pgAudit is the authoritative UAM business audit | **REJECTED** | Native mechanisms do not express complete UAM purpose/capability/approval/workflow semantics; pgAudit is not transactional. | They may be supplemental after engine-specific evidence. |
| A transparency log or immutable database is the primary mutation audit store | **REJECTED INITIALLY** | Separate service/database creates dual-write and restore/operations failure domains. | A baseline change moving authoritative business state into the same substrate with complete migration and proof. |
| Signed syslog/SIEM is the authoritative audit ledger | **REJECTED** | No business transaction atomicity; transport and collector failures create gaps. | Supplemental security telemetry only. |
| Blockchain/consortium ledger | **REJECTED NOW** | No approved low-trust multi-party requirement; highest complexity, privacy, cost, and governance surface while local transaction atomicity remains unresolved. | An approved multi-party threat model and comparative proof. |
| Break-glass without audit because it is an emergency | **REJECTED** | Creates the highest-risk unaudited path. | No expected change. |
| Break-glass grants arbitrary detail/export/role administration | **REJECTED** | Converts recovery into a universal bypass. | A named operation requires its own human decision and exact T1 proof; default remains absent. |
| Ordinary product/database admin clears an integrity hold | **REJECTED** | Allows the potentially affected authority to erase the failure signal. | Independent incident authority and verified recovery evidence only. |
| Restore and trust the local latest authorization/audit state | **REJECTED** | Restored grants/revocations and audit heads can be rolled back with the backup. | Current external authority/checkpoint reconciliation remains mandatory. |
| Automated accessibility scanner or design-system claim proves conformance | **REJECTED** | Scanners miss focus, task, announcement, authentication, comprehension, and composition defects. | No expected change; manual AT/task evidence remains required. |
| Inaccessible hidden fallback or direct database access for users who cannot operate the portal | **REJECTED** | Creates unequal and unaudited authority and fails the stated gate. | Fix the accessible workflow; no bypass. |
| Service worker/offline portal mutation | **REJECTED** | Stale authority, replay, cached sensitive content, and ambiguous commits. | A separately signed offline-command protocol with measured field requirement; not expected for administration. |
| Notification delivery equals completion, approval, escalation, or evidence | **REJECTED** | Notification is asynchronous and fallible; business state remains authoritative. | No expected change. |
| Technical lifecycle state labelled as legal completion, productivity truth, or forensic certainty | **REJECTED** | Exceeds technical evidence and human authority. | No technical state may make these claims. |

## 3.2 Deferred technologies, dependencies, and topologies

| Area | Deferred/provisional items | Classification | Resolution path |
|---|---|---|---|
| Portal rendering | server-rendered/progressive HTML, React/TypeScript, another standards-based client | **CLI EXPERIMENT + HUMAN DECISION** | Same representative workflow bake-off: accessibility, security, performance, bundle, maintenance, skills, support, removal. |
| Design system | PatternFly React, Fluent UI, Carbon, or small local native components | **DEPENDENCY ADMISSION + CLI EXPERIMENT** | Exact release/source/license/advisory review and E05 design-system bake-off. |
| BFF dependency | built-in ASP.NET Core, Duende BFF, other commercial package | **DEPENDENCY ADMISSION + HUMAN DECISION** | Exact feature, license, source/package, security, session, operations, and removal comparison. |
| Identity provider | issuer/federation topology, logout, PAR, PKCE, step-up, assurance, token/session profile | **HUMAN DECISION + CLI EXPERIMENT** | IAM inventory and exact provider interop/failure tests. |
| External PDP/PIM | OPA, Cedar, OpenFGA, SpiceDB, Cerbos, commercial PIM | **DEFERRED / REFERENCE** | Reconsider only after measured model/service need and parity on all hard semantics. |
| Browser/AT support | exact Edge/Chrome/Firefox/Safari and Narrator/NVDA/JAWS/VoiceOver versions | **HUMAN DECISION + RECURRING CLI/MANUAL TEST** | Accessibility policy, actual workforce technology, exact recurring matrix. |
| Audit canonicalization | JCS or a canonical CBOR profile; numeric/string profile and migration | **CLI EXPERIMENT + ADR** | Independent implementation vectors, strict parser, cross-version bytes, fuzzing, semantic review. |
| Audit stream sharding | one control stream per realm vs multiple named streams | **CLI EXPERIMENT** | Contention/load/verification/retention measurement; explicit complete stream manifest if split. |
| External checkpoint | WORM object store, separate account, transparency log, witness quorum, regulator/customer-held checkpoint | **HUMAN DECISION + CLI EXPERIMENT** | Threat model, owner independence, availability, key, restore, cost, and split-view requirements. |
| Native database audit | SQL Server Ledger/Audit, PostgreSQL pgAudit | **CONDITIONAL SUPPLEMENTAL** | Exact selected engine/topology and direct-admin/failover/retention tests. |
| Audit search | relational indexes, separate search projection, read replica | **CLI EXPERIMENT + HUMAN DECISION** | Approved query corpus, fields, freshness, lifecycle/readiness watermark, cost, restore. |
| Audit export | format, encryption, recipient binding, watermarking, object store, retrieval | **HUMAN DECISION + CLI EXPERIMENT** | Purpose/access/retention/crypto/recipient/cleanup decisions and tests. |
| Key management | algorithms, KMS/HSM, threshold/quorum, rotation, revocation, long-term validation | **HUMAN DECISION + CLI EXPERIMENT** | Cryptographic authority ADR and exercised ceremonies. |
| Trusted time | database time only, external timestamp authority, secure time service | **HUMAN DECISION + CLI EXPERIMENT** | Evidentiary requirement, clock threat, cost, and recovery tests. |
| Database engine | PostgreSQL, SQL Server, edition/topology, managed/self-managed | **B04/B05 CLI EXPERIMENT + HUMAN DECISION** | Paired semantics/restore/operations/skills/licensing/TCO evidence. |
| Notification channels | in-portal, email, managed paging, registered webhook | **HUMAN DECISION + SECURITY REVIEW** | Recipient/payload/urgency/privacy/dedupe/availability contract. |
| Cross-realm oversight | none, product-global aggregate, explicit case manifest | **HUMAN DECISION + CLI EXPERIMENT** | Purpose, minimum fields, suppression, authority, access, audit, realm-negative tests. |
| Direct DB emergency path | no path, fixed repair CLI, controlled DBA runbook | **HUMAN DECISION + CLI EXPERIMENT** | Independent authority, fixed commands, no ordinary read/export, external detection, reconciliation. |
| Localization | supported languages, translation review, RTL, time-zone defaults | **HUMAN DECISION + TEST** | Product/localization/accessibility ownership and recurring tests. |
| Support backend | permit system, case system, encrypted bundle transport/storage | **HUMAN DECISION + CLI EXPERIMENT** | Accepted Batch 03 boundary, access/retention/crypto/owner, blind-support evidence. |

## 3.3 Numeric values explicitly not accepted as timeless architecture

The following values in I01–I03 are useful T1 seeds or measurement candidates only and MUST NOT become production architecture by repetition:

- session idle, absolute, refresh, and authentication-freshness durations;
- JIT, approval, delegation, break-glass, export, checkpoint, witness, and case expiry;
- authorization cache TTL, revocation objective, outage grace, and decision latency;
- page size, maximum filter/scope manifest, bulk count, preview validity, command timeout, and job heartbeat;
- audit segment event count/age/bytes, checkpoint cadence, maximum unanchored tail, verifier retry, and stale threshold;
- search page size, query time range, export rows/bytes, artifact expiry, download count, and audit retention;
- UI route/bundle/memory/performance thresholds, Core Web Vitals targets, browser support windows, and accessibility-test repetition counts;
- metrics cardinality, sampling, alert thresholds, denial aggregation, and operational log retention;
- database connection, lock, sequence contention, index, partition, backup, restore, RPO/RTO, and storage limits;
- quorum, key overlap, clock tolerance, recovery ceremony interval, and incident response time.

Every accepted production value MUST record owner, units, source/evidence class, exact workload/topology, uncertainty, failure behavior when unknown, compatibility impact, review trigger, and expiry.

---

# 4. Contradiction register with evidence-quality resolution

## 4.1 Resolution method

Each contradiction was resolved by preserving predecessor invariants, preferring narrower authority and one source of truth, separating technical mechanisms from human policy, distinguishing architecture from execution-time versions, and converting unproved fitness into a gate rather than choosing the most confident prose.

## 4.2 Register

| ID | Overlap, contradiction, or authority problem | Evidence-quality assessment | Consolidated resolution | ADR/action |
|---|---|---|---|---|
| C05-01 | I02 calls external immutable audit archival optional/later; I03 requires independent checkpoints before production. | I02 addresses the portal transaction/read workflow; I03 explicitly evaluates DBA/host tampering and external verification. The latter is stronger and narrower for production integrity. | Same-transaction local audit is sufficient for T1 mutation prototypes. A current independently protected checkpoint is mandatory before privileged production use. | ADR-B05-018; B05-AUDIT-VERIFY. |
| C05-02 | I01 has durable authorization-decision evidence; I03 has a canonical audit event authorization section. | Both are needed but can diverge if duplicated. | Preserve `AuthorizationDecisionV1` as immutable final-decision evidence. `AuditEventV1` references its ID/digest and copies only stable minimum fields required for audit interpretation. Both commit together for privileged mutation. | ADR-B05-010/013; schema conformance tests. |
| C05-03 | I02 supplies a simple `uam.audit.privileged-event`; I03 supplies a larger typed taxonomy/schema. | I02's contract is screen/workflow illustrative; I03 owns audit semantics and tamper evidence. | I03 schema/taxonomy is canonical. I02's shape becomes `AuditEventPortalProjectionV1`, generated from the canonical ledger under a redaction profile. | ADR-B05-013/021; remove competing write contract. |
| C05-04 | I02 labels the audit component a “non-repudiation/accountability boundary”; I03 rejects cryptographic/legal overclaim. | Legal non-repudiation depends on identity, keys, procedures, law, and admissibility beyond the supplied evidence. | Use “transactional accountability and tamper-evidence boundary.” No legal non-repudiation or evidentiary sufficiency claim. | Source/terminology correction; UI content test. |
| C05-05 | I01 provisional personas and I02 screen actors can appear to define real roles. | Both explicitly reserve organizational mapping for humans. | All personas are T1 workshop fixtures only. Production role mappings remain empty until approved. | ADR-B05-006; owner workshop gate. |
| C05-06 | I01 JIT grant approval and I02 command approval can look like one mechanism. | They govern different state: temporary capability eligibility vs approval of one exact business command/preview. | Model separate `JitRequest/Grant` and `ApprovalRequest/Decision`. A command may require both. Neither creates the other automatically. | ADR-B05-006/007; state-machine tests. |
| C05-07 | I01 allows standing low-risk roles; I02 uses task-based portal capability lists. | Compatible if capability lists are presentation hints and standing grants remain explicit/reviewed. | Accept narrow standing candidates only after human decision; server reauthorizes every read/action. | ADR-B05-006; B05-JIT. |
| C05-08 | I01 proposes one active realm; I02 has a realm switcher/global search; some workflows imply central oversight. | One active realm minimizes confusion; product-global oversight is a different authority plane. | Normal sessions have one active realm. Global routes/capabilities are explicit and do not carry realm data by omission. Cross-realm cases use signed/immutable scope manifests. | ADR-B05-004; realm tests. |
| C05-09 | I01 BFF profile cites current browser-app guidance as if normative; the current document is draft-27. | RFC 9700 is BCP; the browser-app document remains an Internet-Draft dated 6 July 2026. | Treat the draft as current design guidance, not a final standard. Architecture relies on accepted security properties and exact provider tests, not draft status alone. | Source correction; ADR-B05-002 review trigger. |
| C05-10 | I01 says Authorization Code + PKCE and PAR when supported; I02 states a generic enterprise authentication session. | Compatible; exact IdP support is unknown. | Accept confidential-client BFF, code flow and PKCE; use PAR when supported and admitted. Exact issuer/logout/session details remain IAM evidence. | ADR-B05-002; E05-04. |
| C05-11 | I02's browser framework choice remains open, while I01 accepts ASP.NET Core BFF. | Server host family and browser rendering framework are separate decisions. | Accept ASP.NET Core control BFF in the .NET family. Keep front-end rendering/design system open behind screen/command/accessibility contracts. | ADR-B05-001/028. |
| C05-12 | I01 lists Duende BFF as a candidate; I02 can implement the BFF locally. | Duende adds commercial/license and package behavior but is not architecturally required. | Built-in ASP.NET Core is first T1 candidate. Duende remains a conditional commercial bake-off candidate, not an automatic dependency. | ADR-B05-029; dependency gate. |
| C05-13 | I02 makes WCAG 2.2 AA the target and describes EN 301 549 status; exact European mapping can change. | W3C status is stable; ETSI V4.1.0 was on approval on 1 August 2026, not final. | WCAG 2.2 AA is the engineering target. Formal EN 301 549/procurement/legal conformance is human-owned and rechecked after final publication/harmonisation. | Source correction; ADR-B05-027. |
| C05-14 | I02 includes provisional Core Web Vitals thresholds; no UAM SLO exists. | Current web guidance is useful but workload/estate/objectives are absent. | Keep as diagnostic T1 budgets only. Product/SRE approve named production budgets after measurement. | E05-27; human decision HD05-38. |
| C05-15 | I02 says no activity detail; I01 contains a candidate `ACTIVITY_DETAIL` capability. | Capability modelling does not authorize route existence. | Catalogue may model a disabled future capability, but no route/API/read model is built or enabled until the human gate opens. | ADR-B05-011; architecture test for absent route. |
| C05-16 | I01 allows detailed authorization reasons for reviewers; I02 requires non-enumerating ordinary errors. | Different audiences and purposes. | Ordinary callers receive generic safe errors; authorized audit/support reviewers may access finite reason codes after purpose-bound access audit. | ADR-B05-009/010; response-profile tests. |
| C05-17 | I01 high-volume summary-read logging is human-owned; I03 requires audit-before-disclose for sensitive reads. | Not every aggregate read is necessarily sensitive, but privileged/sensitive disclosure requires durable evidence. | Classify reads by release-owned audit class. Sensitive/detail/audit/export/support reads are audit-before-disclose. Summary-read logging policy remains human/measurement, never a bypass for classified reads. | ADR-B05-015/021; route catalogue. |
| C05-18 | I03 uses one stream per realm plus global; high audit/read volume could contend. | No representative portal rates or benchmark exists. | Accept as first prototype. Measure sequence/head contention. Any split uses a release-owned complete stream manifest and preserves completeness/verification. | ADR-B05-016; E05-27. |
| C05-19 | I03 proposes JCS/canonical JSON while Batch 01 keeps signed-control canonicalization open. | JCS is documented but informational and has semantic constraints; predecessor ADR remains authoritative. | Reuse the eventual accepted canonical profile if fit. Until then, audit canonicalization is a blocking independent-vector experiment; no history is recanonicalized. | ADR-B05-017; update Batch 01 canonicalization ADR. |
| C05-20 | I03 fixes Merkle leaf/node formulas and RFC 9162 split rule. | The design is clear and standard-derived, but UAM independent implementation is untested. | Accept the logical profile for T1 and freeze it with independent golden vectors before persistence. Algorithm/profile changes start a linked epoch. | ADR-B05-017; E05-15/16. |
| C05-21 | I03's independent verifier and checkpoint owner are described technically, but organizational independence is unassigned. | Cryptographic separation without independent administration can be illusory. | Require separate credentials/build/state/storage and an assigned owner before production; exact organizational model is human-owned. | ADR-B05-019; HD05-18. |
| C05-22 | I03 automatic scoped verification hold vs prompt's human decision on response. | Immediate containment can be technical; business/legal/notification/recovery scope is human. | Automatic affected-realm/stream hold is accepted. Only fixed safety-narrowing actions continue. Organizational response, global escalation, gap acceptance, disclosure, and risk acceptance remain human decisions. | ADR-B05-020; incident runbook. |
| C05-23 | I03 whole-segment pruning may conflict with field-specific retention/erasure. | Whole-segment pruning preserves verifiability; no approved field-level requirement exists. | Accept whole-segment mechanism first. Field-level expiry requires a new privacy/cryptographic design and change proposal. | ADR-B05-022. |
| C05-24 | SQL Server Ledger offers native immutability but has deletion/retention limitations. | Microsoft docs establish capabilities and irreversibility, not UAM lifecycle fitness. | Ledger is conditional defense in depth if SQL Server is selected and retention/topology/restore tests pass. Never make it mandatory while retention is open. | ADR-B05-023; E05-20. |
| C05-25 | SQL Server Audit `FAIL_OPERATION` can fail audited DB actions; application audit already fails closed. | Native audit can cover direct DB paths but has different semantics and target availability. | Use only as supplemental direct-admin/DDL backstop under a tested profile. It cannot replace typed business audit. | ADR-B05-023. |
| C05-26 | pgAudit is presented as a PostgreSQL audit option; current docs say best-effort/nontransactional. | The caveat directly contradicts the privileged mutation invariant if used alone. | pgAudit is supplemental only. Exact stable-version behavior, volume, privacy, collector, superuser, failover, and restore are tested if PostgreSQL is selected. | Source correction; ADR-B05-023. |
| C05-27 | I03 suggests Tessera/Witness for stronger transparency; no external log is needed initially. | A transparency layer strengthens split-view/public verification but adds a service and cannot solve local mutation atomicity. | No mandatory transparency dependency. First anchor candidate is separately protected immutable checkpoint storage; Tessera/Witness is an optional T1 comparison only when the threat/policy requires it. | ADR-B05-018/019/024. |
| C05-28 | I03 mentions signed checkpoint key and optional trusted time; exact crypto profile remains open from predecessors. | Security properties are required; algorithms, KMS/HSM, quorum, timestamps, and recovery are human/execution choices. | Purpose-separated keys, explicit profiles, rotation/revocation/recovery are normative; exact algorithms/services remain open. | ADR-B05-019; crypto authority decision. |
| C05-29 | I01 break-glass and I03 break-glass state machines overlap; I02 also has accessible emergency workflow. | They agree on boundedness but use slightly different names and scopes. | One canonical break-glass state machine covers request, approval, activation, action, expiry/revocation, review, and closure; UI is a projection. Automatic safety actions are separate. | ADR-B05-025; E05-22/24. |
| C05-30 | I01 proposes offline recovery CLI; I03 says every action remains transactional/audited. | An offline repair path cannot silently write a second unverifiable history. | Minimal recovery CLI may change only fixed authorization/containment state and must write to the same canonical audit transaction or a separately protected emergency evidence channel reconciled before re-enable. | ADR-B05-025; recovery drill. |
| C05-31 | I02 allows read-only audit portal; I03 requires audit access itself be audited before disclosure. | The latter is the stronger access invariant. | Every nonpublic audit read, including summary where classified, follows the audit-access route class and release-before-disclose rule. | ADR-B05-015/021; E05-13. |
| C05-32 | I02 may resolve actor display names in portal data; I03 stores opaque actor IDs. | Display needs and durable minimization differ. | Durable event stores opaque identity; authorized view-time identity projection supplies display text, with revision and access control. | ADR-B05-013/021; privacy canaries. |
| C05-33 | I02 generic notification/escalation state can expose sensitive actor/action data. | Notification is secondary and broader channels may have weaker access/retention. | Use fixed safe templates, opaque links, finite event classes, no sensitive payload. Recipients/channels are human-owned. | ADR-B05-030; notification tests. |
| C05-34 | I02's export workflow and I03 audit export each define manifests. | They are same pattern for different data classes and should not diverge. | Use one `GovernedExport` framework with data-class-specific field/purpose/access profiles and canonical audit events. No generic export definition. | ADR-B05-030. |
| C05-35 | I02's deletion/restore flows and I03 audit retention/restore can be tested separately and falsely composed. | Passing one subsystem does not prove the joint restore invariant. | Aggregate restore drill uses one exact release/engine/topology and reconciles authorization, audit checkpoints, tombstones, acknowledged set, jobs, exports, and read enablement together. | ADR-B05-026; E05-21. |
| C05-36 | I01 authorization cache and I02 BFF/read caches can have different invalidation truth. | Competing epochs create stale allows or stale fields. | One authoritative authorization epoch/generation model; cache keys include realm, principal/session generation, catalogue/policy revisions, and output profile. High risk rechecks authoritative state. | ADR-B05-009; cache interleaving tests. |
| C05-37 | I02 supports capability-filtered navigation; a route may disappear without explaining loss of access. | Usability and enumeration requirements must be balanced. | Menus may omit unavailable actions, but direct bookmarked routes return an accessible generic denial and authorized reviewers retain finite reason evidence. | ADR-B05-009/027. |
| C05-38 | Topic results include exact release versions/commits that can be read as timeless dependencies. | They are point-in-time source review and may already be superseded later. | Record them in source/OSS review only. Execution selects current supported exact versions, reruns admission, and locks source/package/binary identity. | ADR-B05-033; dependency process. |
| C05-39 | PatternFly, Fluent, and Carbon upstream accessibility claims may appear equivalent. | Upstream intent does not prove integrated UAM task behavior or exact transitive packages. | Treat all as candidates in the same bake-off. No preferred winner by popularity/vendor alignment. | ADR-B05-028; E05-26. |
| C05-40 | A successful technical gate could be presented as production approval. | Prompt and predecessors explicitly separate technical evidence from human production authority. | Gate artifact always states `productionApproved=false`; separate designated risk authority decides pilot/production. | B05-AGG schema; governance control. |

## 4.3 Accepted-baseline change-proposal status

**FACT.** The resolutions above preserve the accepted baseline. No change proposal is opened.

A future implementation MUST open a formal change proposal before it claims UAM needs any of the following:

- browser or payload authority for realm/role/purpose;
- wildcard/default authorization or a tenant-authored policy language;
- a privileged business effect outside the canonical decision/audit transaction;
- sensitive disclosure before access audit;
- a separate primary audit database/log service without atomic business state;
- local-only audit trust against privileged database/host administrators;
- break-glass that bypasses realm, purpose, privacy, audit, or restore readiness;
- generic administration, script, SQL, plug-in, query, export, or destination channels;
- production person/activity detail without the human purpose/access/retention gate;
- inaccessible alternative workflows or direct DB fallback;
- restored stale authority or audit state without current reconciliation;
- field-level audit history deletion that breaks retained verification;
- legal, productivity, or forensic claims derived from technical status.

The proposal must name the affected accepted decision, new primary evidence, security/privacy/accessibility/realm/audit impact, alternatives, smallest falsifying experiment, migration/restore consequence, and ADR action.


---

# 5. Normative component, interface, schema, and state-machine baseline

## 5.1 Consolidated trust-boundary architecture

```text
enterprise browser
  -> same-origin TLS
  -> Portal BFF
       - OIDC confidential-client session
       - opaque cookie + CSRF
       - one active realm or explicit product-global context
       - screen/read-model composition
       - strict route/command contract validation
  -> trusted target resolver
  -> release-owned route/capability descriptor
  -> authorization kernel
       - active grants/JIT/delegation
       - exact realm/scope/target
       - purpose/ticket/case
       - authentication freshness
       - approval/SoD
       - product ceiling + tenant narrowing + emergency/restore state
       - response/output obligations
  -> read path
       - purpose-built aggregate projection
       - sensitive query buffer
       - access audit transaction
       - release bytes only after COMMIT
  -> command path
       - current resource/version/preview revalidation
       - final authorization under transaction state
       - business mutation
       - AuthorizationDecisionV1
       - AuditEventV1 + stream head
       - durable job/outbox where needed
       - COMMIT
  -> asynchronous job workers
       - narrow service identity
       - job authorization lease
       - reauthorize at irreversible phases
  -> audit segment sealer
  -> independent read-only verifier
       - independent canonicalization/hash/Merkle recomputation
       - signed checkpoint
       - checkpoint storage outside ordinary product/DB administration
  -> verification status projector
       - PASS or explicit GAP/ALTERED/FORK/STALE/UNAVAILABLE
       - scoped safety hold; no self-clear

No browser -> database path
No browser -> endpoint path
No browser -> signing/KMS path
No browser -> connector secret path
No browser -> generic module/table API
No privileged mutation -> external audit network call inside transaction
No ordinary admin -> audit update/delete/hold-clear path
```

## 5.2 Component and authority baseline

| Component | Normative responsibility | Explicit prohibitions | Trust boundary / owner function |
|---|---|---|---|
| **Portal Web Client** | Render semantic HTML; manage local presentation state; submit closed requests; show realm/environment, freshness, quality, authority, risk, progress, verification, limitations, and recovery; support keyboard/AT/localization. | No authorization, realm derivation, token storage, SQL, signing, policy compilation, generic mutation, secret access, hidden production action, offline mutation, or business completion inference. | Untrusted browser; Portal UI/Accessibility. |
| **Portal BFF** | Terminate same-origin session; derive actor/realm; enforce CSRF/body/content/security headers; compose screen models; invoke exact authorization and domain interfaces; apply route limits and `no-store`. | No business truth, generic reverse proxy, persistence model exposure, client role/realm trust, token return, or bypass of domain authorization. | Browser/Internet to authenticated server context; Portal Platform/IAM. |
| **Identity Provider Adapter** | Validate discovery/metadata, issuer, audience/client, state, nonce, code, PKCE, redirect, token signature/time, logout, and minimal subject binding under an exact profile. | No direct UAM capability from IdP role/group; no unverified realm; no browser token exposure; no arbitrary redirect. | Federation boundary; IAM/Federation Engineering. |
| **BFF Session Manager** | Store tokens/references server-side; issue opaque host-only session; bind principal, authn context, active realm, grant generation, authorization epoch, expiry, and CSRF; rotate on login/realm/privilege changes; revoke/logout. | No local/session storage token, no stale realm reuse, no privilege extension beyond upstream/local expiry. | Identity to portal session; Portal IAM. |
| **Realm Context Broker** | Establish exactly one active realm for normal sessions; explicit product-global mode; rotate context on switch; clear caches; provide safe display alias. | No default tenant, no body/query realm authority, no implicit cross-realm aggregation, no stale realm cache. | Confused-deputy boundary; Realm Security. |
| **Route/Action Descriptor Registry** | Enumerate every public/internal route, command handler, background phase, sensitive output, emergency operation, audit class, risk, owner, and tests. Fail build/startup on missing/duplicate descriptors. | No runtime inference from method/controller name, dynamic handler discovery, hidden endpoint, unowned action, wildcard. | Release-authorized API boundary; API Architecture. |
| **Capability Catalogue** | Own immutable resource/action definitions, scope kinds, grant modes, risk, purpose, approval, authn, audit, output, delegation, service, break-glass, lifecycle, and compatibility. | No tenant-created capability, mutable active semantics, `*`, executable expression, implicit admin. | Authorization contract authority; Authorization Architecture. |
| **Role Template Registry** | Own immutable exact capability bundles and constraints; expose revisions for assignment review. | No role-name authority, mutable in-place bundle, automatic IdP mapping, inferred legacy role. | IAM governance boundary. |
| **Purpose Registry** | Own immutable approved purpose definitions, permitted capabilities/data/output profiles, prohibited uses, ticket/case, maximum grant mode, lifecycle, and owner. | No free-text purpose, no caller-created purpose, no implicit lawful basis, no logging of unrestricted justification. | Human-governed policy boundary; Product/Privacy/Legal. |
| **Target/Scope Resolver** | Resolve exact resource under authenticated realm; produce typed current state/version and immutable scope manifest; conceal cross-realm existence. | No display-name lookup as authority, no browser list authority, no SQL/filter expression, no cross-realm fallback. | Application realm/data boundary. |
| **Authorization Kernel** | Pure deterministic evaluation of actor, descriptor, capability, grants, realm, target, purpose, ticket, authn, approval, policy, state, output, safety, and time; return finite decision/obligations/validity. | No HTTP, ORM, network, script, reflection policy, unknown-as-allow, general dictionary inputs, external PDP requirement. | Core decision boundary; Authorization Architecture. |
| **Authorization Store/Grant Service** | Persist assignments, standing/delegated/JIT/service/break-glass grants, generations, revocations, epochs, owners, and immutable request/approval linkage. | No self-grant, silent fallback, grant beyond delegator envelope, missing expiry where required, direct role-by-name. | IAM governance state; IAM Engineering. |
| **Approval Service** | Bind approval request/decisions to exact content/preview/resource/scope digests, eligible approver authority, SoD/quorum, time, status, and reason code. | No approval reuse after change, self-approval where forbidden, email link authority, free-form command, approval as active grant. | Human authority boundary; Workflow/IAM. |
| **Authorization Cache** | Cache immutable definitions and resolved low-risk decisions using realm/principal/session/grant/catalogue/policy/target/output revisions and earliest expiry; consume invalidations. | No realm-less key, indefinite TTL, cache-only high-risk mutation decision, stale allow after epoch change. | Performance boundary; Platform/SRE. |
| **Read Model Gateway** | Expose purpose-built realm-first aggregate projections with `asOf`, freshness, quality, pagination, capability-filtered fields, and readiness watermarks. | No ORM entity, generic query, arbitrary join/column, raw payload/event, hidden field, broad detail fallback. | Least-detail read boundary; Domain/Data Product. |
| **Sensitive Read Gate** | Authorize exact query/output; execute bounded query; buffer result; write access decision/audit; commit; release bytes; discard on failure. | No streaming before audit, no raw selector/query text in audit, no hidden bypass endpoint. | Database-to-disclosure boundary; Domain + Audit. |
| **Filter Snapshot / Impact Preview Service** | Resolve server-side scope; compute diff, affected/excluded/unknown/stale/held counts, dependencies, risk, approvals, limitations, rollback/kill options; content-address and expire. | No trust in browser counts/lists, no preview execution after material change, no sensitive value leakage. | Bulk/TOCTOU boundary; Domain Workflow. |
| **Command Gateway** | Accept only named versioned commands; require command ID, version/ETag, preview when needed, finite reason, exact approval refs; construct immutable command plan; invoke final transaction. | No generic PATCH/DELETE/table operation, arbitrary handler, last-write-wins, client actor/realm override. | Mutation authority boundary; API/Domain. |
| **Mutation Transaction Guard** | Re-resolve and lock current state; evaluate final authorization using database time/current epoch; apply business effect; insert decision/audit/job/outbox; commit atomically. | No stale precheck as final authority, no external network call, no successful return before commit, no commit without audit. | Modular-monolith to relational DB; Domain + Data Reliability. |
| **Domain Workflow Modules** | Own explicit finite state machines for policy, registry/rules, releases/tasks, exports, lifecycle, integrations, support, authorization, and audit access. | No general tenant workflow language, UI-written state, hidden transition, arbitrary connector/script. | Domain consistency boundary. |
| **Job/Progress Service** | Persist durable jobs, state versions, milestones, first failure, retry/cancel rules, authorization lease, scope digest, recovery links, and terminal evidence. | No browser-memory-only progress, notification-as-completion, new identity on response loss, authority snapshot without recheck. | Async execution boundary. |
| **Notification Service** | Consume typed events; dedupe; create safe in-portal notifications; optional governed channels; track acknowledgement. | No sensitive payload/identity/path/secret, no business state authority, no free-form webhook/destination. | Secondary delivery boundary. |
| **Authorization Decision Writer** | Persist immutable `AuthorizationDecisionV1` where required, including exact inputs/revisions/result/obligations without sensitive payload. | No request body, token, claim dump, URL, SQL, dynamic exception, name as authority. | Decision evidence boundary; Security Audit. |
| **Audit Taxonomy Registry** | Own event families/types, required fields, change/output/retention/access profiles, severity, scope, compatibility, and tests. | No runtime event names, tenant schema, arbitrary details, extension bag, unowned event. | Audit contract authority. |
| **Audit Draft Builder** | Build deterministic immutable event draft from authenticated context, final command plan, actual effect, and decision linkage. | No caller-claimed realm/actor/result; no mutable object graph; no exception/request serialization. | Application-to-persistence boundary. |
| **Audit Stream Writer/Head** | Serialize per-scope stream sequence/hash; append event and advance head in the business transaction; enforce uniqueness/immutability. | No timestamp ordering, client sequence, deploy/restore reset, runtime update/delete. | Relational concurrency boundary; Audit/Data Reliability. |
| **Audit Ledger Store** | Preserve typed events, streams, segments, checkpoint work/status, audit-access/export evidence, gaps/epochs, and retention evidence. | No ordinary update/delete/truncate; no free-form payload; no direct product-admin write. | Database data boundary. |
| **Segment Sealer** | Seal contiguous eligible ranges, compute Merkle root and manifest digest, link prior segment/checkpoint, enqueue verification. | No event rewrite, no self-declared independent pass, no pruning. | Primary DB to verifier work boundary. |
| **Independent Verifier** | Independently canonicalize and recompute sequence/hash/Merkle/checkpoint continuity; reconcile command/effect/event where required; sign finite report. | No business mutation, no trust in stored hash alone, no product signing key, no auto-repair or pass conversion. | Separate process/credential/admin boundary. |
| **Checkpoint Anchor/Store** | Retain signed checkpoint manifests and trusted verifier state outside ordinary product/DB admin overwrite/delete authority. | No mutable “latest only”, no shared ordinary delete authority, no activity payload. | Independent custody boundary; human owner open. |
| **Verification Status Projector** | Authenticate verifier reports; maintain bounded local state; expose freshness/findings; enforce scoped holds. | No verifier private key, no `FAIL` to `PASS`, no self-reenable, no local-only latest trust. | Verifier-to-control-plane boundary. |
| **Audit Query BFF/API** | Enforce purpose/capability/realm/case/redaction; fixed filters; pagination; audit-before-disclose; export workflow. | No direct SQL, full dump, unbounded search, hidden fields, cross-realm cache, source-row edit. | Auditor/support disclosure boundary. |
| **Governed Export Service** | Preview exact scope/fields; require approvals; build bounded artifact privately; scan/encrypt; write manifest/completion audit; issue one-use retrieval; track expiry/revocation/deletion/limitation. | No generic table export, formula-active unsafe output, uncontrolled destination, release before audit, false external deletion claim. | Data-egress boundary. |
| **Lifecycle/Restore Service** | Apply barrier/tombstone, typed deletion targets, holds, isolated restore, current authority/checkpoint replay, readiness evidence, separate read enablement. | No fuzzy selector, direct deletion before barrier, old-authority trust, read/egress/mutation before readiness. | Lifecycle/recovery boundary. |
| **Integration Admin** | Manage immutable connector revisions, purpose, allowlisted destination class, opaque secret references, test/activate/deactivate/delete capability states. | No secret return, arbitrary URL/header/script, browser-side test, inferred deletion success. | SSRF/secret/egress boundary. |
| **Diagnostics/Support** | Expose closed safe health, permits, bundles, case timelines, and runbooks under predecessor Batch 03 constraints. | No remote shell, arbitrary command/file/registry/log/dump/raw activity, production debugger. | Support disclosure/control boundary. |
| **Break-Glass Recovery Controller** | Execute fixed incident-bound recovery operations under separate identity/approval, expiry, alert, audit, and post-review. | No universal bypass, ordinary detail/export, arbitrary grant/SQL, self-approval, audit/restore bypass. | Emergency authority boundary; Security Incident/Identity Recovery. |
| **Feature/Kill Control** | Apply finite release-owned narrowing, disablement, hold, expiry, owner, reason, audit, and recovery state. | No broaden, hidden code, bypass, self-clear. | Emergency product/tenant control boundary. |
| **Portal/Audit Observability** | Emit finite safe metrics, evidence IDs, series model, performance/accessibility health, and external alerts. | No high-cardinality identifiers, raw content, request body, exception/SQL, audit substitution. | Operations/security boundary. |
| **Contract/Dependency/Gate Tooling** | Generate inventories, strict schemas/vectors, architecture tests, canary scans, dependency records, evidence manifests, and aggregate gate. | No manually typed pass, mutable tags, unowned dependency, production secret/data in evidence. | Repository/release governance boundary. |

## 5.3 Common contract profile

Every portal, authorization, workflow, audit, verifier, export, restore, and emergency contract MUST record:

```text
immutable contract name and exact semantic version
producer, required consumers, accountable engineering owner, support owner
trust boundary and authenticated authority source
realm/global semantics and realm-first key rules
required capability, purpose mode, risk, authn, approval, audit, and output profile
strict closed schema; required/optional/null semantics; no implicit defaults
identifier, digest, time, Unicode, enum, canonicalization, and case rules
item/page/byte/depth/string/allocation/time/concurrency limits
idempotency, version/ETag, replay, duplicate, conflict, and unknown-commit behavior
transaction, disclosure, receipt, job, audit, checkpoint, and verification meaning
compatibility, rollout, rollback, deprecation, expiry, restore, and cleanup rules
permitted/forbidden logs, metrics, diagnostics, exports, and support evidence
valid, boundary, invalid, hostile, old/new, realm-negative, privacy-canary, and accessibility vectors
runbook, evidence schema, dependency identities, and review/expiry triggers
```

Initial HTTP/tool boundaries use strict UTF-8 JSON under the accepted Batch 01 profile and RFC 9457 problem details. Internal domain models and persistence models remain separately typed. Unknown authority-bearing members/enums fail closed. Remote schema references and general extension bags are prohibited.

## 5.4 Canonical identifiers and scalar rules

1. New UAM entity/message/decision/command/job/event/segment/checkpoint/grant/approval/case/export IDs use canonical lower-case UUIDv7 under the predecessor contract profile.
2. UUID timestamp bits are not business time, order, expiry, evidence precision, or authorization.
3. SHA-256 identifies canonical content, schemas, manifests, files, previews, decisions, events, segments, checkpoints, and evidence. Algorithm changes are explicit profile/epoch changes.
4. Time uses explicit UTC instants and a declared quality/precision where material. Database time is authoritative for transactional grant/approval/sequence decisions.
5. Stream sequence, not time, orders audit events.
6. Display/search normalization is field-specific. Canonical signed/hashed identity preserves exact profile semantics; no global Unicode normalization is silently applied.
7. Free-form human comments are disabled by default. A future bounded comment field needs separate purpose, retention, injection, localization, and access review.


## 5.5 Core authorization and portal contracts

### 5.5.1 `AuthenticatedPortalContextV1`

Created only by trusted identity/session middleware:

```text
AuthenticatedPortalContextV1 {
  principal_id: UUIDv7
  principal_type: HUMAN | SERVICE | RECOVERY
  identity_issuer_id: closed identifier
  external_subject_binding_digest: SHA-256
  authentication_session_id: UUIDv7
  authentication_profile_id: closed identifier
  authenticated_at_utc: RFC3339-UTC
  authentication_valid_until_utc: RFC3339-UTC
  active_context: REALM | PRODUCT_GLOBAL
  active_realm_id: UUIDv7?              # required only for REALM
  session_generation: uint64
  authorization_epoch: uint64
  csrf_context_id: UUIDv7?               # human browser only
  request_id: UUIDv7
}
```

Normative rules:

- The body cannot provide or override any field.
- A normal browser context contains exactly one realm.
- Product-global mode is explicit, separately authorized, and has no implicit realm fallback.
- Realm switch produces a new session/security context.
- Disabled principal, revoked session, stale generation, unknown authentication profile, or uncertain expiry denies protected work.

### 5.5.2 `RouteAuthorizationDescriptorV1`

```text
RouteAuthorizationDescriptorV1 {
  descriptor_id: UUIDv7
  revision: uint64
  route_or_handler_id: closed identifier
  operation_kind: READ | SENSITIVE_READ | COMMAND | JOB_PHASE | RECOVERY
  resource_type: closed enum
  action: closed enum
  actor_types_allowed: closed set
  realm_mode: REALM | PRODUCT_GLOBAL | EXPLICIT_CASE_MANIFEST
  capability_id: UUIDv7
  purpose_mode: NONE | REQUIRED | CASE_BOUND
  target_resolver_id: closed identifier
  output_profile_id: closed identifier?
  authentication_profile_id: closed identifier
  approval_profile_id: closed identifier?
  audit_class: NONE | AGGREGATE_READ | PRIVILEGED_READ | PRIVILEGED_MUTATION | SECURITY_FAILURE
  risk_class: LOW | MODERATE | HIGH | RESTRICTED_DATA | RECOVERY
  preview_required: boolean
  version_required: boolean
  idempotency_required: boolean
  owner_function: closed identifier
  support_function: closed identifier
  status: CANDIDATE | ACTIVE | DEPRECATED | RETIRED
}
```

Every executable route/handler/job phase has exactly one active descriptor. Missing or duplicate descriptors fail build/startup and the gate.

### 5.5.3 `CapabilityDefinitionV1`

```text
CapabilityDefinitionV1 {
  capability_id: UUIDv7
  revision: uint64
  resource_type: closed enum
  action: closed enum
  allowed_scope_kinds: closed set
  grant_modes: STANDING | DELEGATED | JIT | SERVICE | BREAK_GLASS
  risk_class: closed enum
  requires_purpose: boolean
  allowed_purpose_class_ids: closed set
  requires_ticket_or_case: boolean
  condition_profile_id: closed identifier
  approval_profile_id: closed identifier?
  authentication_profile_id: closed identifier
  audit_class: closed enum
  output_profile_id: closed identifier?
  delegable: boolean
  service_identity_allowed: boolean
  break_glass_allowed: boolean
  product_ceiling_revision: uint64
  status: CANDIDATE | ACTIVE | RETIRED
}
```

A semantic change creates a new immutable revision. Retired IDs are never repurposed.

### 5.5.4 `PurposeDefinitionV1`

```text
PurposeDefinitionV1 {
  purpose_id: UUIDv7
  revision: uint64
  purpose_class_id: closed identifier
  approved_statement_ref: UUIDv7
  permitted_capability_ids: bounded set
  permitted_output_profile_ids: bounded set
  prohibited_use_codes: bounded closed set
  ticket_or_case_profile_id: closed identifier?
  maximum_grant_mode: STANDING | JIT_ONLY | DISABLED
  owner_function: closed identifier
  status: CANDIDATE | ACTIVE | RETIRED
}
```

The durable decision/audit stores only `purpose_id`, revision, and optional opaque case alias. The approved statement and human correspondence live in separately governed records.

### 5.5.5 `ScopeManifestV1`

```text
ScopeManifestV1 {
  scope_manifest_id: UUIDv7
  realm_id: UUIDv7?                     # null only for explicit product-global scope
  scope_kind: REALM | RESOURCE_SET | INSTALLATION | APPLICATION | CASE | DESTINATION | RELEASE_RING
  resource_type: closed enum
  normalized_selector_profile_id: closed identifier
  resource_ids_or_set_reference: bounded typed content
  source_watermark_digest: SHA-256
  manifest_digest: SHA-256
  created_at_utc: RFC3339-UTC
  expires_at_utc: RFC3339-UTC
}
```

No SQL, regex, path prefix, directory query, display name, role, or arbitrary predicate is permitted. Bulk resolution is reproducible under the recorded source watermark.

### 5.5.6 `GrantV1`

```text
GrantV1 {
  grant_id: UUIDv7
  grant_type: STANDING | DELEGATED | JIT | SERVICE | BREAK_GLASS
  principal_id: UUIDv7
  realm_or_global_context: typed identifier
  capability_revision_ids: bounded set
  scope_manifest_id: UUIDv7
  purpose_class_ids: bounded set
  output_profile_ids: bounded set
  authentication_profile_id: closed identifier
  approval_request_id: UUIDv7?
  not_before_utc: RFC3339-UTC
  expires_at_utc: RFC3339-UTC
  generation: uint64
  authorization_epoch_at_activation: uint64
  delegation_parent_grant_id: UUIDv7?
  status: PENDING | ACTIVE | REVOKED | EXPIRED | SUPERSEDED
}
```

Grant activation is a separate audited transaction. Approval alone does not make `ACTIVE`.

### 5.5.7 `ApprovalRequestV1` and `ApprovalDecisionV1`

```text
ApprovalRequestV1 {
  approval_request_id: UUIDv7
  approval_class_id: closed identifier
  requester_principal_id: UUIDv7
  beneficiary_principal_id: UUIDv7?
  realm_or_global_context: typed identifier
  resource_id: UUIDv7?
  resource_version: uint64?
  scope_manifest_id: UUIDv7?
  content_digest: SHA-256
  preview_digest: SHA-256?
  purpose_id: UUIDv7
  required_profile_revision: uint64
  created_at_utc: RFC3339-UTC
  expires_at_utc: RFC3339-UTC
  state: PENDING | SATISFIED | REJECTED | EXPIRED | WITHDRAWN | INVALIDATED
}

ApprovalDecisionV1 {
  approval_decision_id: UUIDv7
  approval_request_id: UUIDv7
  approver_principal_id: UUIDv7
  decision: APPROVE | REJECT
  reason_code: closed enum
  approver_authority_generation: uint64
  decided_at_database_time_utc: RFC3339-UTC
  decision_digest: SHA-256
}
```

The approval service calculates quorum and SoD; the command body cannot assert them.

### 5.5.8 `AuthorizationDecisionV1`

```text
AuthorizationDecisionV1 {
  decision_id: UUIDv7
  request_or_command_id: UUIDv7
  actor_principal_id: UUIDv7
  actor_type: HUMAN | SERVICE | RECOVERY
  session_or_credential_generation: uint64
  authentication_profile_id: closed identifier
  authenticated_at_utc: RFC3339-UTC
  audit_scope_id: UUIDv7
  realm_scope: REALM | PRODUCT_GLOBAL
  resource_type: closed enum
  target_id_or_manifest_id: UUIDv7?
  target_version: uint64?
  action: closed enum
  capability_id: UUIDv7
  capability_revision: uint64
  grant_id: UUIDv7
  grant_generation: uint64
  purpose_id: UUIDv7?
  purpose_revision: uint64?
  case_alias: UUIDv7?
  approval_request_id: UUIDv7?
  approval_evidence_digest: SHA-256?
  catalogue_revision: uint64
  route_descriptor_revision: uint64
  product_ceiling_revision: uint64
  tenant_policy_revision: uint64?
  authorization_epoch: uint64
  resource_state_digest: SHA-256
  requested_output_profile_id: closed identifier?
  allowed_output_profile_id: closed identifier?
  result: ALLOW | DENY
  reason_code: closed enum
  obligation_profile_ids: bounded closed set
  evaluated_at_database_time_utc: RFC3339-UTC
  valid_until_utc: RFC3339-UTC
  decision_digest: SHA-256
}
```

It MUST NOT contain request/response payload, query, URL, host, path, name, group list, token, arbitrary claim, exception, SQL, or free text.

### 5.5.9 `FilterSnapshotV1` and `ImpactPreviewV1`

```text
FilterSnapshotV1 {
  snapshot_id: UUIDv7
  resource_type: closed enum
  realm_id: UUIDv7
  filter_profile_id: closed identifier
  normalized_filter: closed typed structure
  scope_manifest_id: UUIDv7
  scope_digest: SHA-256
  resolved_count: uint64
  excluded_count: uint64
  unknown_count: uint64
  source_watermark_digest: SHA-256
  created_at_utc: RFC3339-UTC
  expires_at_utc: RFC3339-UTC
}

ImpactPreviewV1 {
  preview_id: UUIDv7
  command_type: closed enum
  resource_id: UUIDv7?
  resource_version: uint64?
  scope_manifest_id: UUIDv7?
  scope_digest: SHA-256
  command_digest: SHA-256
  preview_digest: SHA-256
  risk_class: closed enum
  affected_counts: typed finite counts
  exclusion_reason_counts: bounded closed list
  semantic_change_summary: bounded typed list
  dependencies: bounded typed list
  required_approval_classes: bounded closed list
  recovery_controls: bounded closed list
  limitations: bounded closed list
  generated_at_utc: RFC3339-UTC
  expires_at_utc: RFC3339-UTC
}
```

### 5.5.10 `PortalCommandV1`

```text
PortalCommandV1 {
  command_id: UUIDv7
  command_type: closed enum
  resource_id: UUIDv7?
  expected_version: uint64?
  preview_id: UUIDv7?
  preview_digest: SHA-256?
  reason_code: closed enum
  approval_request_ids: bounded UUIDv7 set
  purpose_id: UUIDv7?
  case_alias: UUIDv7?
  parameters: command-specific closed typed object
}
```

The BFF supplies actor, realm, authn, request correlation, and server time. The body cannot override them. `If-Match` is also required for revisioned HTTP resources.

### 5.5.11 `CommandResultV1` and `JobStatusV1`

```text
CommandResultV1 {
  command_id: UUIDv7
  outcome: SUCCEEDED | ACCEPTED | DENIED | FAILED | NO_EFFECT | UNKNOWN_RECONCILE_REQUIRED
  resource_id: UUIDv7?
  resource_version: uint64?
  job_id: UUIDv7?
  authorization_decision_id: UUIDv7?
  audit_event_id: UUIDv7?
  safe_result_code: closed enum
  accepted_or_completed_at_utc: RFC3339-UTC
  safe_links: bounded typed map
}

JobStatusV1 {
  job_id: UUIDv7
  job_type: closed enum
  realm_or_global_context: typed identifier
  state: closed enum
  state_version: uint64
  command_id: UUIDv7
  scope_digest: SHA-256
  authorization_lease_id: UUIDv7
  progress: finite typed counts/milestones
  first_failure_code: closed enum?
  retry_generation: uint64
  available_actions: bounded closed set
  recovery_links: bounded typed list
  created_at_utc: RFC3339-UTC
  updated_at_utc: RFC3339-UTC
}
```

## 5.6 Canonical audit contracts

### 5.6.1 Audit event families

The initial required families are:

| Family | Representative required types | Core rule |
|---|---|---|
| `AUTHENTICATION` | attempt/success/failure, session start/end, step-up, credential enrol/revoke | Security evidence is bounded; never store secret/token/claim dump. |
| `AUTHORIZATION` | allow/deny, grant/revoke, role binding, policy evaluation failure | Privileged commands bind the final decision ID/digest. |
| `SENSITIVE_READ` | requested/completed/denied/failed | No result bytes before completed event commits. |
| `EXPORT` | requested, approval, build, built, released, downloaded, revoked, expired, deleted, failed | Build and release are separate; artifact content is not copied into audit. |
| `CONTROL_MUTATION` | policy/rule/task/schedule/release/configuration/feature/kill changes | Mutation and success audit commit together. |
| `APPROVAL` | requested, granted, denied, withdrawn, expired, quorum satisfied/invalidated | Approval content is immutable and separate from execution. |
| `BREAK_GLASS` | requested, activated, action, ended, expired, revoked, failed | Every emergency action remains realm/purpose/audit bound. |
| `DIAGNOSTICS_SUPPORT` | permit issued/activated/revoked, bundle built/released/deleted, access allowed/denied | Closed safe fields only. |
| `LIFECYCLE` | retention/hold/deletion barrier/target/completion/backup/restore/read enablement | Technical lifecycle status is not legal outcome. |
| `INTEGRATION` | connector create/change/enable/disable/test/credential rotate/deletion request/confirmed/limited | No secret or destination URL in event body. |
| `REPROCESS_CORRECTION` | reprocess request/approval/start/complete/fail, correction issued/rejected | Original evidence is never edited. |
| `SECURITY_FAILURE` | realm mismatch, audit write failure, integrity conflict, unauthorized path, canary, signature/key/clock/direct DB failure | Bounded, value-free, and safety-hold aware. |
| `AUDIT_SYSTEM` | stream create, segment seal, checkpoint create/publish/cosign, verification pass/fail/stale, gap, epoch, key rotate/revoke, schema change, prune | Written to a dedicated audit-system stream; verification does not overwrite verified events. |

### 5.6.2 `AuditEventV1`

```text
AuditEventV1 {
  event_id: UUIDv7
  audit_scope_id: UUIDv7
  realm_scope: REALM | PRODUCT_GLOBAL
  realm_id: UUIDv7?
  stream_id: UUIDv7
  stream_epoch: uint64
  stream_sequence: uint64

  event_family: closed enum
  event_type: closed enum
  event_version: semantic version
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

Minimum nested semantics:

```text
AuditActorV1:
  actor_type, principal_id?, credential_id?, authentication_context_id?,
  session_id?, assurance_class, delegated_by_principal_id?, break_glass_session_id?

AuditServiceV1:
  service_id, service_instance_class, product_release_id,
  executable_manifest_digest, contract_catalogue_digest

AuditAuthorizationV1:
  decision_id, decision_digest, decision ALLOW|DENY, capability_id,
  policy/revision, grant_id/generation, approval_request_id/revision/count,
  separation_of_duties_result

AuditPurposeV1:
  purpose_id?, purpose_revision?, case_alias?, justification_code?

AuditTargetV1:
  target_type, target_id?, target_revision_before?, target_revision_after?,
  target_scope_digest?, target_count_bucket, subject_data_class

AuditChangeV1:
  change_profile_id, bounded sorted changed_fields with closed field IDs and
  semantic change kinds; no arbitrary strings/secrets/raw policy/activity

AuditResultV1:
  safe_result_code, safe_error_code?, retry_class,
  affected_count_bucket, evidence_id?

AuditCorrelationV1:
  command_id, request_id?, workflow_id?, parent_event_id?, approval_id?,
  export_id?, deletion_case_id?, restore_run_id?, operation_token?

AuditTimeV1:
  occurred_at_utc, recorded_at_utc, database_commit_time_utc?,
  time_quality TRUSTED|DEGRADED|UNCERTAIN, ordering_source STREAM_SEQUENCE
```

### 5.6.3 Hash and segment profile

The logical event hash is:

```text
canonical_event_core = canonical_encode(
  AuditEventV1 excluding previous_event_hash and event_hash
)

event_hash = SHA-256(
  ASCII("UAM-AUDIT-EVENT-V1\0")
  || previous_event_hash
  || uint64_be(length(canonical_event_core))
  || canonical_event_core
)
```

Segment leaves and nodes use domain-separated hashes under a frozen Merkle profile. The first T1 candidate follows the RFC 9162 tree split rule and never duplicates an unmatched final leaf. Independent golden vectors are mandatory before persistence.

`AuditSegmentManifestV1` contains:

```text
segment_id
stream_id / stream_epoch
first_sequence / last_sequence / event_count
first_event_hash / last_event_hash
merkle_root
previous_segment_manifest_digest
schema_profile_id / canonical_profile_id / merkle_profile_id
created_at_utc / sealed_at_utc
sealer_release_id
segment_manifest_digest
```

### 5.6.4 `AuditCheckpointV1` and `VerificationReportV1`

```text
AuditCheckpointV1 {
  checkpoint_id: UUIDv7
  verifier_identity_id: UUIDv7
  verifier_key_id: UUIDv7
  verification_profile_id: closed identifier
  stream_id: UUIDv7
  stream_epoch: uint64
  verified_first_sequence: uint64
  verified_last_sequence: uint64
  verified_event_count: uint64
  segment_manifest_digest: SHA-256
  merkle_root: SHA-256
  previous_trusted_checkpoint_digest: SHA-256?
  primary_database_incarnation_id: UUIDv7
  backup_or_restore_lineage_id: UUIDv7?
  verification_started_at_utc: RFC3339-UTC
  verification_completed_at_utc: RFC3339-UTC
  result: PASS | GAP | ALTERED | FORK | STALE_INPUT | INCOMPLETE
  safe_findings: bounded closed list
  checkpoint_digest: SHA-256
  signature_profile_id: closed identifier
  signature: bytes
}

VerificationReportV1 {
  report_id: UUIDv7
  checkpoint_id: UUIDv7?
  stream_id / epoch / range
  result: PASS | GAP | ALTERED | FORK | STALE | UNAVAILABLE | INCOMPLETE
  first_failing_sequence: uint64?
  expected_digest: SHA-256?
  observed_digest: SHA-256?
  safe_finding_codes: bounded closed list
  recommended_hold_scope: REALM | STREAM | GLOBAL | NONE
  verifier_release_id / executable_digest / contract_digest
  started_at / completed_at / time_quality
  report_digest / signature
}
```

Checkpoint/report content is opaque and value-free. It does not expose event payload, actor name, purpose statement, selector, change value, URL, or target text.

### 5.6.5 Audit search and export contracts

```text
AuditSearchRequestV1 {
  query_id: UUIDv7
  purpose_id: UUIDv7
  case_alias: UUIDv7?
  scope: exact realm | approved product-global/case manifest
  time_range: bounded UTC range
  event_families/types: bounded closed set
  outcomes/severity: bounded closed set
  actor_opaque_id: UUIDv7?
  target_type/id: closed enum / UUIDv7?
  capability_id: UUIDv7?
  command/workflow/case/event/sequence: exact optional values
  redaction_profile_id: closed identifier
  page_size: bounded integer
  continuation_token: opaque integrity-protected token?
}

AuditSearchResultV1 {
  query_id
  as_of_utc / verification_status / checkpoint_freshness
  redaction_profile_id
  items: bounded AuditEventPortalProjectionV1[]
  next_token?
  limitations: bounded closed list
  access_audit_event_id
}

AuditExportManifestV1 {
  export_id
  purpose_id / case_alias / approval_request_id?
  scope_manifest_id / query_digest / redaction_profile_id / format_profile_id
  row_count / byte_count / content_digest
  recipient_class / encryption_profile_id / retrieval_state
  created_at / expires_at / retrieved_at? / deleted_at?
  limitation_codes
  manifest_digest
}
```

The continuation token binds realm, principal/capability, purpose, filter, sort, redaction profile, source watermarks, expiry, and server key generation.


## 5.7 Normative logical relational schema

Physical types, partitioning, indexes, RLS, ledger features, and generated columns are engine-specific candidates. The logical entities, keys, immutability, realm-first rules, and transaction semantics below are normative.

### 5.7.1 Authorization and workflow tables

| Table | Primary/unique identity | Required logical fields | Normative constraints |
|---|---|---|---|
| `authz_capability_definition` | `(capability_id, revision)` | resource/action, scope/grant/risk/purpose/approval/authn/audit/output profiles, delegation/service/break-glass flags, product ceiling, status | Immutable revision; one active semantic revision; no wildcard; release-owned only. |
| `authz_route_descriptor` | `(descriptor_id, revision)`; unique active `route_or_handler_id` | capability, resolver, operation, realm mode, risk, preview/version/idempotency/audit/output, owners, status | Every executable route/job phase has one active descriptor; startup fails on gaps/duplicates. |
| `authz_role_template` | `(role_template_id, revision)` | display metadata, exact capability revision members, constraints, status | Immutable revision; display name is not authority. |
| `authz_purpose_definition` | `(purpose_id, revision)` | purpose class, approved statement ref, permitted capabilities/outputs, prohibited uses, ticket/case, max grant mode, owner/status | Human-approved; no free-form runtime purpose. |
| `authz_principal` | `(principal_id)` | principal type, issuer/subject binding digest, status/version, owner for service/recovery identities | No display name as key; disabled state fail-closed. |
| `authz_assignment` | `(assignment_id)`; unique active envelope as defined | principal, realm/global context, role/capability revisions, scope, purpose classes, grant mode, generation, lifecycle, owner/approval refs | No self-assignment where prohibited; immutable activation history; revocation advances epoch. |
| `authz_grant` | `(grant_id)` | grant type, principal, realm/global, capabilities, scope, purpose/output/authn, approval, time, generation, status | `ACTIVE` only through audited activation; expiry/revocation fail-closed. |
| `authz_delegation_envelope` | `(delegation_id)` | parent grant, strict capability/scope/purpose/time/depth maxima, status | Child must be provable subset; no cycle/depth overflow. |
| `authz_jit_request` | `(jit_request_id)`; unique realm/request digest where appropriate | requester/beneficiary, realm, capability set, scope, purpose, ticket/case, time, output/authn, request digest, state | Content change creates new request; approval does not activate. |
| `authz_approval_request` | `(approval_request_id)` | class, requester/beneficiary, realm, target/scope, content/preview digests, policy profile, expiry, state/version | Immutable content; state changes optimistic/transactional. |
| `authz_approval_decision` | `(approval_decision_id)`; unique `(approval_request_id, approver_id, generation)` | decision, reason, authority generation, database time, digest | Append-only; revoked/expired approver authority invalidates unsatisfied quorum. |
| `authz_break_glass_request` | `(break_glass_request_id)` | incident, requester, realm/global target, fixed profile, scope, purpose, requested expiry, digest, state | Disabled without active human policy; no arbitrary capabilities. |
| `authz_break_glass_session` | `(break_glass_session_id)` | activated grant, principal, fixed profile, incident, activation/expiry/revoke, alert/post-review refs, state/version | Hard expiry; no silent renewal; every action references session. |
| `authz_service_identity` | `(service_principal_id)` | owner, purpose, audience, endpoint set, realms, capabilities, credential generation/status/time | No shared fleet secret; no human impersonation/approval by default. |
| `authz_epoch` | `(realm_or_global_context)` | current epoch, changed_at, reason, source event | Monotonic; restore must reconcile current external/control authority. |
| `authz_decision` | `(decision_id)`; unique stable decision relation as declared | canonical `AuthorizationDecisionV1` fields/digest | Append-only; minimum sensitive content; linked from audit. |
| `portal_filter_snapshot` | `(realm_id, snapshot_id)` | normalized filter, scope manifest, source watermarks, counts, digest, expiry | Immutable; browser cannot change membership. |
| `portal_impact_preview` | `(realm_or_global_context, preview_id)` | command/resource/version/scope/command/preview digests, counts, dependencies, approvals, limitations, expiry | Immutable; changed state makes stale, never updates in place. |
| `portal_command` | `(realm_or_global_context, command_id)` | command type/digest, resource/version, preview, purpose, approvals, actor, state, result refs | Same ID/same digest replay; same ID/different digest conflict. |
| `portal_job` | `(realm_or_global_context, job_id)` | command, type, scope, state/version, authorization lease, progress, first failure, retry, terminal evidence | Durable finite state; no browser-only truth. |
| `portal_job_transition` | `(job_id, transition_sequence)` | from/to, actor/service, decision/audit refs, time, reason/evidence | Append-only; first failure preserved. |
| `portal_notification` | `(realm_or_global_context, notification_id)` | event class, safe template, opaque link, recipient class, state, dedupe, time | Secondary only; no sensitive payload or business authority. |

### 5.7.2 Audit tables

| Table | Primary/unique identity | Required logical fields | Normative constraints |
|---|---|---|---|
| `audit_scope` | `(audit_scope_id)`; unique realm mapping | `REALM` with `audit_scope_id=realm_id`, or registered `PRODUCT_GLOBAL` singleton; created time/status | No nullable key ambiguity; product-global cannot contain realm event by omission. |
| `audit_stream` | `(audit_scope_id, stream_id, stream_epoch)` | stream class, next sequence, head event/hash, canonical/schema profiles, state/version | One active control and one audit-system stream per initial scope; row lock/CAS advances sequence. |
| `audit_event` | `(audit_scope_id, stream_id, stream_epoch, stream_sequence)`; unique `(audit_scope_id, event_id)` | canonical typed event fields, decision linkage, prior/event hash, schema/profile, times | Append-only; exact sequence; no update/delete/truncate by runtime/admin roles. |
| `audit_event_change` | `(audit_scope_id, event_id, field_sequence)` | closed field ID, change kind, bounded typed old/new class/digest | Bounded, sorted, profile-constrained; no generic value text. |
| `audit_segment` | `(audit_scope_id, stream_id, stream_epoch, segment_id)`; unique range | first/last sequence/hash, count, Merkle root, prior manifest digest, profiles, seal state/digest | Covers contiguous range; immutable after seal; no overlapping sealed range. |
| `audit_checkpoint_work` | `(checkpoint_work_id)` | stream/range/segment, state, lease/fence, attempts, safe failure | Scheduling only; not trusted verification outcome. |
| `audit_checkpoint` | `(checkpoint_id)`; unique stream/range/verifier generation as defined | signed `AuditCheckpointV1`, anchor location/class, publication/verification state | Append-only; protected external copy is authoritative for independence. |
| `audit_verification_report` | `(verification_report_id)` | signed report, range, result, finding codes, hold recommendation, verifier evidence | Append-only; no pass overwrite; contradiction is new report/finding. |
| `audit_hold` | `(hold_id)` | scope/stream/range, cause report, state, created/cleared authority/evidence | Ordinary admin cannot clear; clear is separate authorized audited transition. |
| `audit_gap_epoch` | `(audit_scope_id, stream_id, stream_epoch)` | prior epoch/checkpoint linkage, declared gap range/reason/evidence, authority | A declared new epoch never fabricates missing events. |
| `audit_access_request` | `(access_request_id)` | principal, realm/case, purpose, filters, redaction profile, decision, result count bucket, status | Access audit commits before disclosure; query text absent. |
| `audit_export` | `(audit_scope_id, export_id)` | governed manifest, approval, object ref, digest, recipient, lifecycle, limitation | No source content in audit row; private object lifecycle tracked. |
| `audit_retention_policy_revision` | `(policy_id, revision)` | scope/event classes, periods/age basis, hold rules, checkpoint treatment, approvals/status | **HUMAN DECISION** content; immutable revision. |
| `audit_prune_case` | `(audit_scope_id, prune_case_id)` | policy revision, segment manifest, holds, approvals, state, audit refs, deletion verification | Whole sealed segments only in first model; no ordinary admin direct delete. |
| `audit_key_record` | `(key_id, generation)` | purpose, public metadata, validity, status, rotation/revoke/recovery refs | No private key material in DB; purpose separation enforced. |

### 5.7.3 Essential relational constraints

The implementation MUST enforce equivalent constraints in both database candidates:

```text
UNIQUE active route_or_handler_id
UNIQUE active product-global audit scope
UNIQUE (realm_or_global_context, command_id)
UNIQUE (audit_scope_id, event_id)
UNIQUE (audit_scope_id, stream_id, stream_epoch, stream_sequence)
UNIQUE non-overlapping sealed segment sequence ranges
FOREIGN KEY every realm-scoped target/grant/job/decision/audit key begins with realm/scope
CHECK active grant not_before < expires_at and status/time semantics are valid
CHECK product-global rows cannot carry realm data except explicit case manifests
CHECK break-glass capability set is subset of fixed profile
CHECK decision result/obligations/output profile conform to route/capability revisions
CHECK audit event family/type/version/profile combination exists in catalogue
CHECK previous_event_hash and stream_sequence relationship under writer transaction
CHECK audit source rows are never updated/deleted by runtime or ordinary admin roles
```

Application architecture tests also prohibit repository methods whose key omits authenticated realm/scope or whose model accepts arbitrary dictionaries/JSON payload for authority-bearing state.

## 5.8 Transaction boundaries and algorithms

### 5.8.1 Low-risk aggregate read

```text
1. Validate session, CSRF where relevant, route descriptor, current realm.
2. Resolve fixed aggregate read model and current readiness/freshness state.
3. Evaluate capability and output profile.
4. Query only the approved projection under realm-first key.
5. Return typed screen model with as-of/freshness/quality/limitations.
6. Apply the approved aggregate-read evidence policy.
```

A route classified as sensitive cannot use this lighter evidence path.

### 5.8.2 Sensitive read / audit query

```text
BEGIN TRANSACTION;
1. Revalidate principal/session, realm, capability, purpose, case, target, output/redaction profile, readiness, and current verification hold.
2. Execute the bounded fixed query under the transaction or an equivalent consistent snapshot.
3. Buffer result entirely inside the server boundary; compute bounded result metadata and query/scope digest.
4. Insert AuthorizationDecisionV1 where required.
5. Append SENSITIVE_READ_COMPLETED or AUDIT_ACCESS_COMPLETED and advance the audit stream head.
6. COMMIT.
7. Only after COMMIT serialize/release bytes.
```

Failure before commit discards the buffer. Streaming sensitive results is prohibited unless a future chunked protocol proves that every disclosed chunk has prior durable authorization/audit semantics.

### 5.8.3 Preview generation

```text
1. Authenticate and authorize preview capability for exact realm/resource/action.
2. Resolve current resource/version and server-owned scope/filter snapshot.
3. Validate command-specific closed parameters without mutating state.
4. Compute deterministic command digest and impact from current authoritative data.
5. Record excluded/unknown/stale/held populations, dependencies, approvals, limitations, and recovery controls.
6. Persist immutable preview with source watermarks and expiry.
7. Return preview; no execution authority is created.
```

### 5.8.4 Privileged mutation

```text
BEGIN TRANSACTION;
1. Load current authenticated principal/session/service status, grant generation, authorization epoch, route/capability/purpose/approval profiles, and database time.
2. Resolve and lock the target/resource version and any scope manifest needed for the effect.
3. Recompute preview-critical preconditions; reject stale preview/version/approval/scope/policy/hold.
4. Evaluate final AuthorizationDecisionV1 using locked current facts.
5. If DENY, apply no business effect; rollback or commit a separately specified denial-only transaction.
6. Apply the deterministic business transition using compare-and-swap/state preconditions.
7. Construct the audit event from actual transition/result and the decision ID/digest.
8. Lock the audit stream head; allocate next sequence; canonicalize; compute previous/event hash; insert event; advance head.
9. Insert durable job/outbox/projection work required by the command.
10. Require exact affected-row counts and invariant checks.
11. COMMIT.
12. Return success/accepted result only after commit.
```

An exception, audit write error, sequence conflict, job/outbox error, affected-row mismatch, or commit failure yields no successful response and no partially committed business effect.

### 5.8.5 Denied/precondition-failed command

A denial/failure event cannot survive a rolled-back mutation transaction. Therefore:

1. prove through transaction outcome and stable command lookup that no prohibited effect committed;
2. write a bounded denial/failure decision and audit event in a short audit-only transaction when the event catalogue requires it;
3. reuse the same command/request identity;
4. never label unknown commit as denied until reconciliation is complete.

### 5.8.6 JIT activation/revocation

Grant activation transaction:

```text
validate current request digest, approvals, SoD, authn, realm, scope, purpose, time
insert/activate GrantV1 with generation and expiry
advance authorization epoch/generation as specified
insert decision and audit event in same transaction
commit, then expose active grant
```

Revocation transaction:

```text
lock current grant
transition to REVOKED and advance generation/epoch
insert decision and audit event
commit
publish invalidation as secondary delivery
```

High-risk operations consult authoritative current state even if invalidation delivery is delayed.

### 5.8.7 Export build and release

```text
request -> preview -> approval -> command transaction creates EXPORT_AUTHORIZED and durable job
job claims under service identity and reauthorizes exact grant/approval/scope
build bounded artifact in private staging
scan/schema/canary/encryption checks
transaction commits manifest, content digest, EXPORT_BUILT audit
separate retrieval command reauthorizes recipient and commits EXPORT_RELEASED/DOWNLOADED audit
only then issue/redeem one-use retrieval capability
```

### 5.8.8 Segment seal/checkpoint

```text
Sealer:
  select contiguous committed unsealed range under stream state
  recompute/validate event hashes and sequence locally
  compute Merkle root/manifest digest
  insert immutable segment + checkpoint work in transaction

Verifier:
  independently read range using read-only credential
  independently canonicalize/recompute sequence/hash/Merkle/previous checkpoint
  create signed report/checkpoint
  publish to separately protected anchor
  return authenticated report to projector

Projector:
  verify verifier key/profile/signature and report continuity
  record local report state
  enforce PASS freshness or scoped hold
```

Publication ambiguity never marks a checkpoint trusted. The verifier/anchor protocol must query/reconcile by stable checkpoint ID/digest.

### 5.8.9 Retention/pruning

```text
1. Authorize exact prune case under approved retention policy revision.
2. Reverify no legal/incident/verification hold and required external checkpoint continuity.
3. Verify whole sealed segment target, object/backup copies, export/case dependencies, and successor/predecessor evidence.
4. Commit prune authorization/audit and durable target work.
5. Execute typed deletion outside the transaction under fenced work state.
6. Verify absence/copy lifecycle.
7. Append AUDIT_SEGMENT_PRUNED in the current stream; retain minimum checkpoint/destruction evidence under its policy.
```

No row-by-row source-event edit/delete occurs in the first model.

## 5.9 State machines

### 5.9.1 BFF session

```text
UNAUTHENTICATED
  -> AUTHENTICATING
      -> ACTIVE_REALM
      -> AUTHENTICATION_FAILED

ACTIVE_REALM
  -> STEP_UP_REQUIRED -> ACTIVE_REALM
  -> REALM_SWITCH_PENDING -> ACTIVE_REALM(new session generation)
  -> AUTHORITY_CHANGED -> REVALIDATING -> ACTIVE_REALM | REVOKED
  -> IDLE_WARNING -> ACTIVE_REALM | EXPIRED
  -> LOGOUT_PENDING -> REVOKED
  -> PROVIDER_UNAVAILABLE -> LIMITED_EXISTING_SESSION | REVOKED

Any revoked/expired/mismatched generation denies protected work.
```

### 5.9.2 Assignment and JIT

```text
DRAFT
  -> SUBMITTED
  -> APPROVAL_PENDING
      -> REJECTED
      -> EXPIRED
      -> APPROVAL_SATISFIED
           -> ACTIVATION_PENDING
                -> ACTIVE
                -> ACTIVATION_FAILED

ACTIVE
  -> REVOKED
  -> EXPIRED
  -> SUPERSEDED
  -> COMPLETED_EARLY
```

A content change from any pending state creates a new request generation and invalidates approvals.

### 5.9.3 Approval

```text
PENDING
  -> DECISION_RECORDED (one approver)
  -> QUORUM_PENDING
      -> SATISFIED
      -> REJECTED
      -> EXPIRED
      -> INVALIDATED_BY_CONTENT_OR_AUTHORITY_CHANGE
  -> WITHDRAWN
```

`SATISFIED` is evidence for a later activation/execution; it is not the effect.

### 5.9.4 Preview/command/job

```text
Preview: CREATED -> VALID -> EXPIRED | STALE | CONSUMED

Command:
RECEIVED
  -> VALIDATING
  -> DENIED | CONFLICT | PREVIEW_STALE | IDEMPOTENCY_CONFLICT
  -> TRANSACTION_PENDING
       -> COMMITTED_SUCCEEDED
       -> COMMITTED_ACCEPTED(job)
       -> ROLLED_BACK_FAILED
       -> COMMIT_UNKNOWN_RECONCILING

Job:
QUEUED -> CLAIMED -> REAUTHORIZED -> RUNNING_STAGE
  -> PAUSED | CANCEL_REQUESTED | SAFETY_HOLD
  -> COMPLETED | COMPLETED_WITH_LIMITATIONS | FAILED
  -> RETRY_PENDING(same job identity, incremented generation)
```

### 5.9.5 Sensitive read

```text
REQUESTED
  -> AUTHORIZED_QUERYING
  -> RESULT_BUFFERED
  -> ACCESS_AUDIT_PENDING
      -> COMMITTED -> DISCLOSED
      -> FAILED -> BUFFER_DISCARDED
  -> DENIED | FAILED_NO_DISCLOSURE
```

### 5.9.6 Export

```text
DRAFT -> PREVIEWED -> APPROVAL_PENDING -> AUTHORIZED
  -> BUILD_QUEUED -> BUILDING -> BUILT_PRIVATE
  -> RELEASE_AUTHORIZED -> AVAILABLE
  -> RETRIEVED
  -> REVOKED | EXPIRED | DELETION_PENDING -> DELETED
  -> FAILED | COMPLETE_WITH_LIMITATIONS
```

No state before `AVAILABLE` authorizes retrieval. External copies may remain `COMPLETE_WITH_LIMITATIONS`.

### 5.9.7 Break-glass

```text
DISABLED
  -> REQUESTED
  -> INDEPENDENT_APPROVAL_PENDING
      -> REJECTED | EXPIRED
      -> APPROVED
  -> ACTIVATION_PENDING
      -> ACTIVE
      -> ACTIVATION_FAILED

ACTIVE
  -> ACTION_AUTHORIZED -> ACTION_COMMITTED (repeat only within fixed profile/time/scope)
  -> EXPIRING_WARNING
  -> EXPIRED | REVOKED | ENDED
  -> POST_REVIEW_PENDING -> CLOSED | INCIDENT_ESCALATED
```

Every action has its own decision/audit event. `ACTIVE` never bypasses another explicit deny such as wrong realm, forbidden output, restore block, or audit integrity hold.

### 5.9.8 Audit segment/checkpoint

```text
OPEN_STREAM
  -> SEGMENT_ELIGIBLE
  -> SEALING
      -> SEALED_LOCAL
      -> SEAL_FAILED
  -> VERIFICATION_QUEUED
  -> VERIFYING
      -> VERIFIED_PASS
      -> GAP | ALTERED | FORK | INCOMPLETE | STALE | UNAVAILABLE
  -> CHECKPOINT_PUBLICATION_PENDING
      -> CHECKPOINT_TRUSTED
      -> PUBLICATION_AMBIGUOUS
```

Only a valid, continuous, independently protected checkpoint becomes trusted. Local seal success is not external verification.

### 5.9.9 Integrity incident and hold

```text
FINDING_DETECTED
  -> HOLD_APPLIED
  -> EVIDENCE_PRESERVED
  -> INVESTIGATING
      -> FALSE_POSITIVE_PROVED
      -> REPAIR_FROM_TRUSTED_STATE
      -> GAP_DECLARATION_REQUIRED
      -> COMPROMISE_CONFIRMED
  -> INDEPENDENT_REVERIFY
      -> HOLD_CLEARANCE_PENDING
      -> REMAINS_HELD
  -> CLEARED_BY_AUTHORIZED_INCIDENT_DECISION
```

No affected ordinary administrator self-clears. The first failure remains immutable.

### 5.9.10 Audit retention

```text
ACTIVE_SEGMENT
  -> RETENTION_CANDIDATE
  -> HOLD_CHECK
      -> HELD
      -> ELIGIBLE
  -> PRUNE_AUTHORIZED
  -> DELETE_PENDING
  -> DELETED_VERIFIED
  -> PRUNE_AUDIT_COMMITTED
```

### 5.9.11 Restore/read enablement

```text
RESTORE_REQUESTED
  -> ISOLATED_RESTORE_CREATED(new environment identity)
  -> READ_MUTATION_EGRESS_BLOCKED
  -> ENGINE_SCHEMA_KEY_VERIFIED
  -> CURRENT_AUTHORITY_REPLAYED
  -> TOMBSTONES_ACKNOWLEDGED_SET_RECONCILED
  -> AUDIT_CHECKPOINT_RECONCILED
  -> DERIVED_STORES_REBUILT_UNDER_GUARD
  -> NEGATIVE_AND_POSITIVE_PROBES
      -> TECHNICALLY_READY
      -> QUARANTINED_OR_READ_BLOCKED
  -> READ_ENABLEMENT_APPROVAL_PENDING
  -> READ_ENABLED
```

Break-glass cannot skip any reconciliation state. Technical readiness does not itself authorize production routing or legal/business use.

## 5.10 Portal information architecture baseline

### 5.10.1 Global frame

```text
Skip link
Product/environment header
  - UAM product and exact environment label
  - active realm switcher and realm status
  - realm-scoped global search
  - notification inbox
  - help/support
  - signed-in identity/session controls
Primary task navigation
Breadcrumbs + one primary page heading
Page freshness/data-quality/verification banner
Main content
Contextual help/runbook links
```

Environment and realm are continuously visible as text, not only color. Production/non-production differentiation is redundant and programmatic.

### 5.10.2 Primary navigation

```text
1. Overview
   - Operational summary
   - Required attention
   - Recent privileged changes

2. Fleet
   - Health
   - Population and eligibility
   - Installations/devices (operational detail only)
   - Compatibility and coverage

3. Policy
   - Effective policy
   - Drafts and reviews
   - Publication history
   - Emergency narrowing and safety holds

4. Applications
   - Registry
   - Imports and data quality
   - Rules
   - Conflicts and ambiguities
   - Published snapshots

5. Releases and tasks
   - Releases
   - Rollouts and rings
   - Tasks/jobs
   - Kill switches

6. Evidence
   - Aggregates
   - Coverage and data quality
   - Detail (absent until human approval)

7. Operations
   - Diagnostics and errors
   - Integrations
   - Exports
   - Deletion and lifecycle
   - Audit and verification

8. Support
   - Cases
   - Support bundles
   - Runbooks and known conditions

9. Administration
   - Realm configuration
   - Capability/role-template/assignment revisions
   - Notification policies
   - Control/signing/verifier status (read-only unless exact capability)
   - Feature and hold inventory
```

### 5.10.3 Standard page states

Every route implements at least:

| State | Required behavior |
|---|---|
| `LOADING` | Accessible status; title/structure present; no focus stealing; navigation/cancel usable. |
| `EMPTY_VALID` | Scope, filter, as-of, explanation, next valid action; never imply no activity. |
| `NO_AUTHORITY` | Generic non-enumerating result and safe support reference. |
| `STALE` | Last successful as-of, freshness class, reason, restrictions, recovery. |
| `OFFLINE_SOURCE` | Affected scope/count, last-contact class, limitations; not collapsed to zero. |
| `PARTIAL` | Included/excluded/unknown counts, dependency, restrictions. |
| `UNSUPPORTED` | Exact capability/profile class and safe remediation; no impossible action. |
| `SAFETY_HOLD` | Hold reason family, scope, owner/runbook, safe next step; no self-clear. |
| `VERIFICATION_FAILED` | Textual finding class, affected scope/range/freshness, disabled actions, incident link. |
| `ERROR_RETRYABLE` | Safe code, same-id retry, operation/job status link. |
| `ERROR_TERMINAL` | Safe code, state certainty, containment, rollback/recovery/support path. |
| `CONFLICT` | Current version/change summary, reload/re-preview; no overwrite. |
| `COMPLETED_WITH_LIMITATIONS` | Completed targets, unresolved copies/holds, explicit limitation; no misleading green complete. |

## 5.11 Error taxonomy

The public API uses RFC 9457 problem details with stable safe types/codes. Representative families:

```text
AUTHENTICATION_REQUIRED
AUTHENTICATION_STALE
SESSION_REVOKED
CSRF_VALIDATION_FAILED
ACCESS_NOT_PERMITTED
WRONG_REALM_OR_NOT_FOUND
PURPOSE_REQUIRED_OR_NOT_ALLOWED
TICKET_OR_CASE_INVALID
TARGET_SCOPE_INVALID
OUTPUT_PROFILE_NOT_ALLOWED
GRANT_EXPIRED_OR_REVOKED
APPROVAL_REQUIRED_OR_INVALID
SEPARATION_OF_DUTIES_FAILED
STALE_VERSION
PREVIEW_STALE
IDEMPOTENCY_CONFLICT
SAFETY_HOLD_ACTIVE
RESTORE_NOT_READY
AUDIT_WRITE_UNAVAILABLE
AUDIT_SEQUENCE_CONFLICT
VERIFICATION_STALE
VERIFICATION_INTEGRITY_FAILURE
EXPORT_NOT_READY
COMMAND_COMMIT_UNKNOWN
RATE_OR_BUDGET_UNAVAILABLE
DEPENDENCY_UNAVAILABLE
```

Ordinary responses do not expose hidden policy, cross-realm existence, SQL, stack, token, claim, dynamic exception, or audit internals. Authorized audit/support routes may reveal finite detailed reason codes under their own purpose and access audit.


---

# 6. Human decision register

Research MUST NOT approve the matters below. The accountable roles are functions, not invented organizational assignments. The conservative state is technical containment only.

| ID | **HUMAN DECISION** | Options / decision content | Conservative state until decided | Accountable role/function | Consequence of delay / blocked work |
|---|---|---|---|---|---|
| HD05-01 | Legal/business purpose, lawful basis, prohibited uses, workforce consultation, notice | Exact purposes for aggregates, detail, audit, export, diagnostics, lifecycle, and investigations; prohibited productivity/disciplinary/forensic uses | T1 fictional data only; no live activity/detail/export | Data Controller/Product Governance with Legal, Privacy, Workforce Governance | Blocks live data, production evidence/detail/export, pilot, and production use. |
| HD05-02 | Real portal user groups and priority workflows | Which tasks exist, frequency, consequence, realm/global scope, out-of-hours need | Fictional capability personas only; read-only aggregate prototype first | Product Governance with Operations, Support, IAM, Privacy | Blocks production role mapping, task-success acceptance, and IA finalization. |
| HD05-03 | Capability catalogue ownership and production scope | Which resource/actions exist, risk classes, owners, deprecation, global plane | Candidate catalogue only; high-risk capabilities disabled | Authorization Architecture + Product/domain owners | Blocks activation of any unowned production route/action. |
| HD05-04 | Role templates and assignments | Task-based bundles, individuals/groups, review/expiry, orphan handling | No production assignments | IAM Governance + accountable business/domain owners | Blocks production access. |
| HD05-05 | Realm definition, product-global authority, delegated boundaries | Legal/customer/data boundaries; whether central oversight exists; delegation depth | One fictional realm per T1 scenario; product-global only for fixed tests | Data Controller/Product Governance + IAM/Data Architecture | Blocks production realm mapping, delegation, and oversight. |
| HD05-06 | Approved purpose registry | Purpose classes, permitted actions/outputs, prohibited uses, ticket/case, lifecycle | Empty production registry for detail/export/audit-export/enhanced diagnostics | Data Controller/Product Owner + Legal/Privacy | Sensitive capabilities remain structurally denied. |
| HD05-07 | Detail access necessity and minimum fields | No detail, limited operational detail, subject/activity detail under exact purpose | No person/activity detail route/API | Data Controller/Product Owner + Privacy/Legal/Workforce Governance/IAM | Blocks detail workflow; protects against premature overcollection. |
| HD05-08 | Aggregate definitions and interpretation | Approved dimensions, time buckets, denominators, suppression, quality/freshness language | Fictional operational aggregates only | Product/Data Owner + Privacy/Legal | Blocks production evidence views and interpretation claims. |
| HD05-09 | Approval profiles and quorum | One approver, maker/checker, two distinct functions, executor/verifier, restore/read-enable | Strong synthetic separation; high-risk production actions disabled | Security Governance + Product/domain owners | Blocks publish, rollout, export, deletion, integration, authorization admin, and recovery. |
| HD05-10 | Separation-of-duty conflict sets and staffing exceptions | Author/publisher, requester/beneficiary/approver, executor/verifier, operator/read-enabler | Conservative distinct synthetic personas | Security Governance + Operations/Engineering Leadership | Blocks production if required separation cannot be staffed or exception not accepted. |
| HD05-11 | Standing vs JIT capability classes | Which low-risk reads/drafts may stand; which capabilities are JIT-only | Only fictional summary/health standing; high-risk JIT/disabled | Product Governance + Security/Privacy | Blocks grant policy activation and access-review design. |
| HD05-12 | JIT, delegation, approval, and review durations | Not-before/expiry, renewal, review cadence, delegation depth, early completion | Short T1 values; break-glass non-renewable | IAM/Risk + domain owners | Blocks production grant lifecycle and cache/objective configuration. |
| HD05-13 | Authentication assurance and freshness | Provider profiles, step-up, passkey/MFA, reauth by capability, accessible alternatives | High-risk requires fresh strong candidate; no production activation | Identity Security + Risk/Product Accessibility | Blocks high-risk commands and recovery activation. |
| HD05-14 | Identity provider/federation and session policy | Issuers, guests, logout, PAR, PKCE, session idle/absolute/refresh, shared devices | One synthetic issuer; finite T1 session; no guest production access | Enterprise IAM/Federation + Product/SRE/Accessibility | Blocks production authentication and session support statement. |
| HD05-15 | Ticket/case authority and evidence | Which case system, signed assertion/lookup/manual reference, correction/outage | Local fictional case binding only | Case/Workflow System Owner + IAM/Security | Blocks case-bound detail, audit, export, diagnostics, and break-glass. |
| HD05-16 | Service identity and workload binding | mTLS/private-key JWT/workload identity, owner, audience, rotation, realms | T1 service credentials only | Service IAM + Domain/Application owners | Blocks production jobs/connectors/integrations. |
| HD05-17 | Break-glass authority, capability set, custodians, quorum, duration | Fixed recovery operations, emergency identities, offline recovery, monitoring | Break-glass disabled | Security Incident Authority + Identity Recovery + Cryptographic Authority + Architecture | Blocks emergency administrative recovery path. |
| HD05-18 | Independent verifier owner and organizational separation | Security, Audit/Compliance, independent SRE/account, external service, quorum | `UNASSIGNED`; lab verifier only | Architecture Governance + designated Risk/Audit authority | Blocks production tamper-detection claim and B05-AUDIT-VERIFY. |
| HD05-19 | Response to audit verification failure | Realm/global hold, safety actions, restore, gap declaration, notification, disclosure | Automatic scoped hold; no ordinary clearance | Security Incident/Risk + Product/Legal/Privacy/Operations/Audit | Blocks production incident policy and hold-clearance automation. |
| HD05-20 | Audit purpose, event fields, identity level, change profiles | Which actions/reads/failures; opaque vs display identity; minimum fields; prohibited content | T1 taxonomy/profiles only; opaque actor IDs | Security/Audit + Product Data Owner + Privacy/IAM | Blocks production event activation and search views. |
| HD05-21 | Audit access and reviewer roles | Realm/global/case access, detail, redaction, approval, audit-export | No production audit access/export | Security Governance + IAM + Privacy/Records | Blocks operational/compliance audit use. |
| HD05-22 | Audit retention, holds, pruning, and backup treatment | Periods by event/segment/checkpoint/export; age basis; hold/release; roots after content | Short T1 fixture expiry; no production pruning | Data Controller/Records + Legal/Privacy/Security/Audit | Blocks retention activation, backup expiry, Ledger selection, and production audit storage. |
| HD05-23 | Regulatory/evidentiary claim | Operational integrity only, internal control, qualified timestamp, external witness, chain of custody | Explicitly no legal admissibility/non-repudiation claim | Legal/Compliance/Risk + Records/Security | Blocks external evidentiary representation and may change key/time/checkpoint design. |
| HD05-24 | Audit checkpoint freshness and unanchored-tail tolerance | Max age/count/bytes, verifier schedule, outage response | Small T1 limits; production disabled | Security/SRE/Risk | Blocks production availability/capacity settings. |
| HD05-25 | Checkpoint technology, account, region, WORM/witness model | Immutable object, separate account, transparency log, customer/regulator checkpoint | Local/disposable lab anchor only | Security Architecture/SRE/Procurement/Audit owner | Blocks independent custody profile and disaster recovery. |
| HD05-26 | Audit/verifier key custody and trusted time | Algorithms, KMS/HSM, quorum, rotation/revocation/recovery, timestamp authority | Lab keys only; exact crypto profile provisional | Cryptographic Authority + Security/Risk | Blocks production checkpoints, long-term validation, and evidentiary claims. |
| HD05-27 | Native database audit controls | Require SQL Server Ledger/Audit or pgAudit; operator/access/retention profile | Supplemental controls off outside lab | Database Security/Architecture/Operations | Blocks final engine-specific defense-in-depth profile. |
| HD05-28 | Database engine/topology and physical audit schema | PostgreSQL/SQL Server; edition; HA; partition/index; replicas; backup | Both T1 candidates; no production choice | Architecture/Product/Operations/Procurement | Blocks production DDL, capacity, restore, and native audit selection. |
| HD05-29 | Portal framework, design system, and BFF dependency | Server-rendered/React/etc.; PatternFly/Fluent/Carbon/local; built-in/Duende | No production front-end dependency selected | Architecture/Front-end + Accessibility + Security/Legal/Procurement | Blocks production UI scaffold lock and support strategy. |
| HD05-30 | Accessibility conformance/support policy | WCAG 2.2 AA or stricter, EN 301 549 mapping, AT/browser matrix, exception/VPAT | WCAG 2.2 AA engineering target; no formal conformance claim | Accessibility Owner + Product/Legal/Procurement/Support | Blocks production accessibility statement and support commitment. |
| HD05-31 | Terminology, localization, and time-zone policy | Neutral terms, prohibited productivity language, languages, RTL, translation review | Neutral operational language; pseudolocalization/RTL T1 | Product/UX/Localization + Accessibility/Legal/Privacy | Blocks localized production UI and terminology approval. |
| HD05-32 | Notification channels, recipients, deadlines, acknowledgement, escalation | In-portal/email/paging/registered webhook; privacy and fatigue controls | In-portal T1 only | Operations/Support/Product + Privacy/Security | Blocks external notifications and on-call automation. |
| HD05-33 | Export purposes, formats, recipients, encryption, expiry, deletion | Exact fields, CSV/JSON/PDF/etc., recipient binding, uncontrolled copies | Export disabled in production; local encrypted T1 only | Data Controller/Data Owner + Privacy/Legal/Security/Records | Blocks production export and audit export. |
| HD05-34 | Deletion/lifecycle authority and legal status wording | Selector types, holds, deadlines, technical vs legal completion, external copies | T1 mechanism only; no real rights outcome | Data Controller/Records/Legal/Privacy + Lifecycle owner | Blocks production deletion workflow and UI wording. |
| HD05-35 | Connector destinations, purposes, secrets, deletion evidence | Registered destination classes, contracts, secret system, recipient capability | Fictional connector only | Integration Owner + Security/Privacy/Legal/Procurement | Blocks production integration administration. |
| HD05-36 | Support promise, safe failure set, permit/bundle access/retention | D0–D2 profiles, support hours, approvers, blind support, backend | T1 blind-support only | Product Support + Security/Privacy/Operations | Blocks production support workflow and staffing. |
| HD05-37 | Kill-switch, safety-hold, and recovery authorities | Product vs realm incident authority, expiry, clear criteria, communication | T1 controls only; production actions disabled | Product Security/Incident + Release/Operations/Audit | Blocks production emergency operation. |
| HD05-38 | Performance, availability, freshness, capacity, SLO/RPO/RTO | Session/authz latency, command, job, audit, verifier, restore, portal UX | No production objectives; fail closed | Product/Risk/SRE/Operations | Blocks topology, capacity, alert, staffing, and production acceptance. |
| HD05-39 | Metrics cardinality, access, sampling, retention, alert thresholds | Safe labels, rare-population suppression, reviewer access | Minimal T1 metrics | SRE + Privacy/Data Governance/Security | Blocks production observability configuration. |
| HD05-40 | Ownership, on-call, incident command, evidence renewal, support | 24/7/business hours, realm/product split, recurring tests, cleanup authority | Capability disabled when owner absent | Engineering/Operations Leadership | Blocks B05-OWNERS and sustainable production operation. |
| HD05-41 | Budget, staffing, licenses, lab, assistive technology, verifier infrastructure | Funding and procurement for recurring controls | No unapproved spend/dependency | Product/Finance/Procurement/Legal/Leadership | Blocks selected technologies and recurring evidence. |
| HD05-42 | Pilot and production risk acceptance | Exact release, roles, purposes, realms, workflows, residual risk, runbooks | T1 lab only | Designated Production/Risk Authority | Blocks pilot/production even after technical pass. |

## 6.1 Human decisions not required to begin safe T1 implementation

The following work may start without resolving production policy, provided every fixture is fictional and every production capability remains disabled:

- route/capability/audit catalogues and strict schemas;
- pure authorization and audit models;
- fictional personas, purposes, approvals, cases, scopes, events, and checkpoints;
- same-origin BFF/session prototype with a synthetic IdP;
- read-only aggregate portal shell and accessibility scaffolding;
- preview/command/idempotency/job infrastructure;
- same-transaction audit prototypes and independent verifier code;
- automated and manual accessibility test harnesses;
- restore and break-glass drills using lab-only identities/keys.


---

# 7. CLI experiment and measurement plan with evidence and pass/fail

## 7.1 Common evidence rules

Every experiment in this section is a **CLI EXPERIMENT** unless the row explicitly includes a **HUMAN DECISION**. A browser screenshot, manual assertion, unit-test pass, framework claim, accessibility score, database feature flag, or successful demonstration is not sufficient by itself.

Each run MUST emit one immutable machine-readable `evidence-manifest.json` containing at least:

```text
evidence_id and schema_version
experiment_id and gate_ids
started_at_utc / completed_at_utc
repository_commit and clean_tree_before/after
product_release_id and exact artifact digests
contract/catalogue/schema/canonicalization digests
OS, architecture, container/VM image, browser, assistive technology,
.NET runtime/SDK, database engine/edition/build, native modules, and tools
exact package/source/binary/license/advisory mapping
scenario ID, deterministic seed, fixed/fake clock profile, realm/persona fixture digests
fault schedule and positive-control mutation IDs
raw-evidence inventory and access classification
expected oracle digest and actual result digest
first failure and shrink/replay capsule
privacy-canary and secret-positive-control outcomes
cleanup receipt and residual-artifact scan
pass | fail | flaky_unclassified | blocked
owner, independent reviewer, evidence expiry, and superseding incident/advisory
```

Normative evidence rules:

1. Inputs are T1 fictional. Production activity, real identities, customer configuration, internal URLs, credentials, signing keys, addresses, or SSH material are prohibited.
2. The same canonical contract, command, serializer, authorization kernel, audit canonicalizer, and database adapter used by the candidate product MUST be used by the test; a faster or more permissive test-only path invalidates the claim.
3. The expected-result oracle MUST be independently implemented from the production evaluator, workflow handler, hash verifier, and accessibility component where practical.
4. Deterministic runs MUST replay from one seed and preserve the first failure. Reruns do not overwrite a failure or convert unexplained nondeterminism into a pass.
5. Every scanner, route check, architecture rule, authorization matrix, canonicalizer, verifier, and accessibility gate MUST have a deliberately broken positive control proving that the gate can fail.
6. Raw traces, database copies, browser recordings, and assistive-technology transcripts are access-controlled evidence, not normal logs or portal data. They are scanned before publication.
7. Evidence applies only to the exact release, contract, database profile, identity/session profile, browser/assistive-technology tuple, deployment topology, and fault set named in the manifest.
8. A security, privacy, accessibility, authorization, audit, restore, dependency, or supply-chain incident expires affected evidence until the owning gate is rerun.
9. Cleanup is part of the pass: no session, cookie, token, credential, key, export, checkpoint, object version, database, temporary file, service, job, policy, test account, network rule, or synthetic personal-like value may remain outside the declared retained evidence set.
10. A blocked **HUMAN DECISION** cannot be changed into a pass by a technical fixture. The experiment may prove mechanism only and MUST report `productionApproved=false`.

## 7.2 Required test fixture package

**RECOMMENDATION.** Build one deterministic `uam-b05-fixtures-v1` package before endpoint or portal framework code depends on it. It MUST contain:

- at least three fictional realms plus a separate fictional product-global scope;
- same-valued resource IDs deliberately reused across realms to expose missing realm keys;
- fictional human, service, disabled, expired, revoked, guest, delegated, approver, verifier, and emergency principals;
- release-owned capabilities covering summary read, draft, publish, sensitive read, audit read/export, authorization administration, export, lifecycle, integration, release, restore, and break-glass;
- fictional purpose definitions, ticket/case bindings, target manifests, response profiles, role templates, standing/JIT/delegated grants, approvals, revocations, epochs, and safety holds;
- resources in every relevant state and version, including stale and cross-realm twins;
- commands with stable IDs, stale previews, response loss, duplicate retries, commit ambiguity, cancellation, and long-running phases;
- canonical audit events, expected hashes, segment trees, checkpoints, key rotations, gap/fork/alter/rollback cases, and restore lineages;
- aggregate/read-model values with `CURRENT`, `STALE`, `OFFLINE`, `UNKNOWN`, `PARTIAL`, `SUPPRESSED`, `UNSUPPORTED`, and `SAFETY_HOLD` states;
- accessibility fixtures for errors, long labels, localization expansion, RTL, high zoom, reduced motion, forced colors, keyboard-only use, and expiring sessions;
- exact fictional privacy canaries in forbidden strings, hidden fields, exception messages, query parameters, paths, tokens, catalogue-like names, audit diffs, exports, notifications, metrics, browser storage, and support evidence.

The package MUST include declarative expected decisions, business effects, audit events, read fields, disclosure timing, verification findings, accessible names/roles/states, focus outcomes, cleanup, and residual objects. It MUST NOT encode final production role assignments or legal purposes.

## 7.3 Ordered experiment matrix

| ID | Experiment and method | Exact evidence | Pass condition | Fail / stop condition | Prerequisites |
|---|---|---|---|---|---|
| **E05-00** | **Input, source, toolchain, and dependency inventory.** Hash the ten allowlisted inputs; record repository commit; run `dotnet --info`; capture browser, AT, database, container/VM, package, source, binary, license, notices, and advisory identities. | `inputs.sha256`, `environment.json`, source/package/binary map, SBOM, notices, advisory snapshot, clean-tree receipt | Every executable input is immutable or content-addressed, supported at execution time, source/package/binary mapped, licensed for the experiment, and owned. | Missing/unallowlisted Project file; mutable tag/image/action; binary without source/package mapping; unknown license; unsupported runtime; dirty or unrecoverable tree. | None. |
| **E05-01** | **Contract, catalogue, schema, and canonicalization gate.** Compile all route, capability, purpose, role, grant, approval, command, workflow, page-state, audit, segment, checkpoint, error, flag, notification, export, and support contracts. Run valid/invalid/hostile/old-new vectors and independent canonicalization. | Catalogue inventory; schema closure; golden bytes/digests; duplicate/unknown/null/Unicode/number/limit vectors; old-new compatibility matrix; mutation report | Zero unowned or duplicate IDs; closed authority-bearing schemas; byte-identical canonical output across supported implementations; every invalid/authority-unknown vector rejects; every planted defect fails. | Missing owner/descriptor; remote schema; duplicate/unknown authority accepted; canonical byte divergence; field normalization changes meaning; unsupported version coerced; mutation survives. | E05-00. |
| **E05-02** | **Deterministic persona/realm/resource/audit fixture package.** Generate twice from clean checkouts and reconcile with independent oracle. | Package root digests, truth ledger, lineage, canary registry, generated DB/object fixtures, cleanup evidence | Byte-identical package roots; all causal inputs have expected terminal state; no real or source-derived value; canaries present and scanner detects them. | Nondeterminism; missing expected denial/no-effect; source-derived value; canary miss; undeletable artifact. | E05-01. |
| **E05-03** | **Repository and route architecture mutations.** Inject realm-less repository overload, string permission, direct IdP role grant, UI-only check, generic mutation endpoint, browser DB client, mutable audit row, unaudited mutation, dynamic policy/script, hidden job handler, and production fault path. | Architecture-test report, route/job inventory, planted-mutation matrix, restored clean-tree digest | Every forbidden mutation fails build/start/test; every executable route/job/background phase has one descriptor; production artifact contains no test controller/key/schedule. | One mutation survives; one route/job lacks descriptor; browser references persistence/secret code; test hook reaches release artifact; cleanup leaves diff. | E05-01. |
| **E05-04** | **BFF/OIDC/session/token/CSRF boundary.** Use a synthetic OIDC provider and browser automation to test code flow, PKCE, PAR candidate, state/nonce/mix-up, cookie flags, fixation, step-up, realm switch, logout, back-channel revocation, multi-tab, cross-site forms/fetch, origins, content types, browser storage, service worker/cache, CSP, and XSS token extraction. | HAR/DOM/storage snapshots with canary-safe redaction; server session transitions; cookie/header/CSP reports; IdP/BFF traces; attack results | Tokens remain server-side; opaque session rotates on login/step-up/realm switch; unsafe cross-site requests fail; logout/revoke invalidates privileged use; no sensitive cache/service-worker entry; browser cannot override actor/realm/authn. | Access/refresh token in DOM, JS memory export, local/session/IndexedDB/cache; successful CSRF; fixation/mix-up; stale privileged session; unsafe redirect; client realm becomes authority. | E05-00–03. |
| **E05-05** | **Route completeness and API-shape verification.** Generate one positive and comprehensive negatives for every route, HTTP method, command, background handler, job phase, field profile, and emergency operation. | Descriptor-to-executable reconciliation, OpenAPI/endpoint metadata diff, generated test IDs, unused/hidden route report | Exact one-to-one classification; state-changing `GET/HEAD/OPTIONS` absent; every response field is profile-owned; direct route and UI path share the same enforcement. | Unclassified/duplicate route; hidden production command; method side effect; field outside profile; route accessible through alternate handler without same decision/audit. | E05-01, E05-03. |
| **E05-06** | **Realm, resource, cache, and confused-deputy campaign.** Reuse identical IDs in multiple realms; alter route/body/query/header/cookie; switch realm mid-tab; race cache and cursor; test jobs, exports, audit, notifications, checkpoints, object names, search, service identities, and product-global routes. | Decision/effect/field oracle; database/object/cache traces; cross-realm canary report; timing/error-equivalence report | Zero cross-realm allow, row, field, count, existence, cache hit, job effect, export, audit result, checkpoint binding, or notification; global routes require explicit global context. | Any cross-realm data/effect/existence disclosure; realm-less cache/key; missing realm interpreted as global; service or verifier crosses scope. | E05-02, E05-04–05. |
| **E05-07** | **Purpose, target, case, and output-profile authorization.** Vary absent/unknown/expired/revoked purposes, ticket/case binding, target set, output fields, resource state/version, authentication freshness, restore/kill state, and explicit denies. | Cartesian/covering decision matrix; independent evaluator oracle; response-field scanner; denial-equivalence evidence | ALLOW only for exact current approved conjunction; unknown is deny; response contains exactly the permitted profile; no broad fetch followed by accidental leakage. | Missing/stale/free-form purpose succeeds; case reused for changed scope; output field escapes; unknown/deny overridden by another role; target found cross-realm. | E05-01–06; production purpose values remain human-blocked. |
| **E05-08** | **Role, standing grant, delegation, and mapping model.** Exercise exact role revisions, narrowing, retirement, orphaned mappings, principal disable, group drift inputs, delegation subset/depth, and self-benefit conflicts. | Grant graph, subset proofs, mapping review output, effective-capability diffs, revocation/epoch traces | Role is only an exact bundle; no wildcard; delegation is a strict subset by every dimension; disabled/retired authority is ineffective; IdP groups do not directly grant. | Wildcard/default admin; role-name string grants; delegated authority exceeds envelope; retired revision silently changes semantics; self-assignment or orphan remains active. | E05-01–07. |
| **E05-09** | **JIT request, approval, activation, expiry, revocation, cache, and long-job authority.** Use fake/database clocks; mutate request after approval; race activation/revoke; restart nodes; lose invalidation; run multi-phase jobs across expiry. | State-machine histories; approval/request digests; database-time evidence; cache keys/epochs; job phase decisions; first-failure capsules | Approval binds exact immutable request; configured SoD/quorum enforced; earliest expiry bounds decision/cache; revoke stops next uncommitted phase; stale cache cannot authorize high risk. | Requester self-approves where forbidden; changed content keeps approval; expired/revoked grant commits; cache extends authority; job continues future effects after expiry/revoke. | E05-07–08; human approval profiles required for production claim. |
| **E05-10** | **Impact preview, concurrency, idempotency, and workflow state.** Race resource/policy/scope changes; stale `If-Match`; replay same/different command digests; lose responses; restart jobs; cancel/pause/kill/rollback; inject partial downstream failure. | Preview/command digests; transaction histories; job/event timeline; idempotency table; state-machine oracle; recovery transcript | Stale preview/version returns finite conflict with no effect; same command/digest returns prior result; same ID/different digest conflicts; jobs survive browser/server restart; only legal transitions occur; limitations remain explicit. | Generic patch/row edit; stale preview executes; response loss duplicates effect; last-write-wins; browser memory is job truth; hidden transition; false completion/rollback. | E05-01–09. |
| **E05-11** | **Mutation, final authorization, decision, business state, audit, stream head, and job/outbox atomicity.** Insert failpoints before/after each write and commit; kill process/database; inject deadlock, serialization retry, disk/full/log failure, response loss, and unknown commit. Run against PostgreSQL and SQL Server candidate profiles. | Per-failpoint before/after DB snapshots; transaction logs; command reconciliation; exact row/effect/event/head counts; independent oracle | Every committed privileged effect has exactly one matching terminal authorization decision and success audit; no uncommitted effect/audit survives; stream is contiguous; stable command resolves ambiguity without duplicate. | Effect without required audit/decision; success audit without effect; stream head/event mismatch; partial job/outbox; retry duplicates; new command identity used after unknown commit; unsafe automatic repair. | E05-01–10; E05-23 for final engine-specific claim. |
| **E05-12** | **Authorization denial and no-effect audit semantics.** Inject precondition, authorization, validation, rate, dependency, and transaction failures; verify no business effect and correct separate audit-only transaction where required. | Effect absence proof; denial/failure events; safe error mapping; flood/aggregation behavior | No prohibited effect; required high-risk denial is durably recorded without fabricating mutation success; unauthenticated flood cannot exhaust authoritative audit. | Rolled-back event presented as committed; missing required denial evidence; denial leaks target/realm/policy; anonymous flood creates unbounded durable rows. | E05-07–11. |
| **E05-13** | **Audit-before-disclose for sensitive read, audit search, download, support bundle, and export.** Delay/fail audit commit, disconnect client, stream large result, expire grant, revoke access, alter profile, and race realm switch. | Network byte capture, server buffering/spool lifecycle, access event, export manifest, object ACL/expiry, cleanup receipt | Zero protected result bytes before committed access/completion audit; failed audit discards buffer/artifact; result fields and realm match authorization; artifact release is separate, one-use/expiring as designed. | First byte leaves before audit commit; direct object URL bypass; untracked export/download; field/realm escape; failed/revoked request retains retrievable object; formula/script-active export content. | E05-07–12; human access/export profiles for production. |
| **E05-14** | **Audit privacy, schema, and all-sink canary campaign.** Inject URLs, paths, identities, tokens, selectors, SQL, exceptions, headers, catalogue-like strings, low-entropy hashes, and hostile Unicode into commands/errors/diffs. Scan DB, logs, metrics, traces, exports, checkpoints, alerts, backups, browser, and support evidence. | Schema decision report; canary scanner with positive controls; sink inventory; redaction/export views | Event contains only permitted typed fields; forbidden value/derivative absent from every undeclared sink; metrics labels finite; UI escapes content; checkpoint contains only opaque integrity metadata. | Canary/secret escapes; generic JSON/details/free text; low-entropy ordinary hash; raw SQL/exception/token; dynamic metric label; source-row edit used for redaction. | E05-01–13. |
| **E05-15** | **Hash-chain, canonicalization, Merkle, segment, and checkpoint vectors.** Implement independent verifier in a separate project/process; cross-check canonical bytes, genesis, sequence, leaf/node rules, odd trees, segment links, key rotation, epochs, algorithm migration, and golden vectors. | Two independent implementations; canonical vectors; tree/proof vectors; signed checkpoint manifests; reproducible verifier build | Byte-identical canonical core and hashes; roots/checkpoints agree; malformed/unknown profile rejects; algorithm/key change starts explicitly linked epoch; verifier does not trust stored hashes alone. | Shared production canonicalizer as sole verifier; divergent root; duplicate member/normalization ambiguity; silent recanonicalization; unsigned/unknown checkpoint accepted. | E05-01–02, E05-11, E05-14. |
| **E05-16** | **Tamper, omission, duplication, reorder, fork, rollback, and gap corpus.** Directly alter/delete/insert/reorder event rows, stream head, segment, checkpoint cache, business row, backup, time, and restore lineage under ordinary admin, database superuser, and host/storage test roles. | Tamper corpus manifest; verifier finding; affected sequence/segment; alert/hold state; original evidence preserved | Every in-scope alteration is detected and classified as `GAP`, `ALTERED`, `FORK`, `ROLLBACK`, `SIGNATURE_INVALID`, `STALE`, or bounded `INCOMPLETE`; no silent repair; first finding retained. | Required tamper passes; verifier trusts local head; synthetic normal event fills gap; finding overwritten/averaged; ordinary admin clears hold. | E05-15. |
| **E05-17** | **Independent verifier/anchor separation and ordinary-admin access.** Deploy verifier with read-only DB credential, distinct build/key/account/storage; test product admin, DB operator, host admin, verifier operator, storage operator, and combinations allowed by the approved lab threat model. | Effective-access inventory; credential/key/object policies; delete/overwrite attempts; signer/use logs; build/source separation; alert path | Product/ordinary DB admins cannot mutate checkpoint store or signer; verifier cannot mutate business/audit; external state is not restored with product DB; out-of-plane alert remains observable. | Shared delete/sign/mutation authority; verifier uses product key; checkpoint overwritten; same backup restores trust state; ordinary product admin marks fail as pass. | E05-00, E05-15–16; human organizational independence remains open. |
| **E05-18** | **Checkpoint publication ambiguity, outage, stale-tail, split-view, and recovery.** Fail between verify/sign/store/import/response; partition anchor; present divergent checkpoints; rotate/revoke key; lose verifier state; vary unanchored tail. | Publication attempts; checkpoint/object versions; trusted-state histories; stale timers/holds; recovery ceremony transcript | Replay is idempotent; divergent same-history claims are held; no local pass substitutes for absent external anchor; stale threshold invokes configured safe state; recovery starts from explicitly trusted checkpoint. | “Latest” mutable object only; split view accepted; stale checkpoint displayed as current; local admin resets first trust; key revocation ignored; outage silently disables verification requirement. | E05-15–17; production thresholds/owners human-blocked. |
| **E05-19** | **Audit query, redaction, export, retention, legal-hold mechanics, and pruning.** Test fixed filters, pagination, realm/case profiles, source immutability, view-time identity resolution, whole-segment eligibility, hold race, checkpoint preservation, partial failure, and backup/object cleanup. | Query/access audit; export manifest/digest; segment eligibility proof; hold/retention transaction; destruction/absence evidence; retained checkpoint continuity | Query cannot widen scope; source rows unchanged; export governed; hold blocks destruction; only complete eligible segments prune; retained checkpoints/minimum destruction evidence verify remaining epochs. | Arbitrary SQL/full text; source row edited; row-level prune breaks retained chain; hold bypass; ordinary admin purge; untracked copy; policy period invented by code. | E05-13–18; human retention/access decisions required. |
| **E05-20** | **Direct database/native audit supplemental comparison.** For the exact candidate engines, test application-role grants, direct DML/DDL, trigger/extension disablement, SQL Server Ledger digest verification, SQL Server Audit target failure/`FAIL_OPERATION`, pgAudit configuration/failure/volume, backup/failover, and privacy of statement text. | Exact DDL/config/edition/extension; direct-admin test results; log/digest volume; restore/failover; license/ops notes; comparison to canonical ledger | Canonical typed ledger remains authoritative; supplemental control detects intended direct paths without leaking prohibited data or changing transaction semantics; failure behavior is explicit and operated. | Native feature presented as primary UAM audit; SQL/parameters leak; default `CONTINUE` mistaken for fail-close; pgAudit best-effort log treated as atomic; engine/edition unsupported; operational burden unowned. | E05-11, E05-14–19; B04 database decision remains separate. |
| **E05-21** | **Backup/restore and joint authority/audit continuity.** Restore an older product DB into isolated identity; keep reads/egress/mutation/receipt disabled; import current grant revocations, catalogue/purpose/kill state, tombstones, acknowledged set, and externally trusted checkpoints; rebuild projections; run negative/positive probes. | Restore lineage; old/new checkpoint comparison; grant/session/approval reconciliation; tombstone/receipt manifests; read/egress probes; readiness and separate enablement audit | No restored session/JIT/approval/break-glass is current by default; audit matches trusted external state or stays held; deleted data remains invisible; acknowledged effects present once; no pre-ready disclosure/effect. | Local restored head trusted; stale grant revives; missing acknowledged effect; deleted subject visible; audit gap accepted; verifier state restored from same backup; ordinary read/egress/mutation before readiness. | B04 restore prototype plus E05-06–20; human RPO/RTO/read-enable authority open. |
| **E05-22** | **Break-glass, portal lockout, IdP outage, key compromise, and offline recovery drill.** Disable normal authority; require fixed independent activation; exercise only predeclared recovery commands; expire/revoke; alert externally; review and clean up. | Activation request/permit; quorum/identity evidence; allowed/denied command matrix; audit/checkpoint trail; alerts; expiry/revocation; post-use review; cleanup | Disabled by default; cannot self-activate; exact recovery-only capability; no detail/export; hard expiry; independent revoke/alert; every action audited and verified; normal authority restored through reviewed state. | Universal/broad superuser; ordinary daily credential; no expiry; same actor self-approves; verifier/audit bypass; detail/export; hidden direct SQL; no out-of-plane alert; residue. | E05-04–21; human break-glass/key/owner decisions required. |
| **E05-23** | **Automated accessibility and semantic regression.** Run HTML validator, accessibility engine(s), component/unit semantics, keyboard model, focus trap/recovery, accessible names/descriptions/states, status messages, table/grid semantics, target size, contrast/forced-color rules, locale/RTL, zoom/reflow, timeout warnings, and error association. Plant violations. | Tool versions/config; DOM snapshots; violation inventory; planted-defect results; component and route coverage; false-positive dispositions | Zero unresolved critical/serious issue in critical workflows; every planted defect detected by at least one gate; semantic structure remains after styling/JS failure; no color-only state. | Critical issue; scanner cannot detect positive controls; unlabeled action; focus lost/trapped; hidden status; inaccessible timeout; custom widget without required semantics; exception without owner/expiry. | E05-01–05; exact tool choice execution-time. |
| **E05-24** | **Manual keyboard, screen-reader, zoom/reflow, forced-colors, reduced-motion, and authentication execution.** Use the approved candidate matrix, initially at least Edge+Narrator and Firefox+NVDA in T1, on every critical task: realm switch, denial, JIT, approval, preview, publish, audit search, export, break-glass, integrity hold, restore, and error recovery. | Scripted task transcripts; keystrokes/focus; spoken-output captures/notes; screen recordings under restricted evidence; defects and retest; participant/accessibility review | Every critical task is operable and understandable without pointer/vision/color; status and scope announced; no focus surprise; errors recoverable; time limit warns/extends only session where allowed, never grant authority. | Task cannot complete; wrong realm/scope unclear; destructive action ambiguous; status only visual; AT cannot identify/activate/control; authentication has no accessible alternative; severe cognitive/timeout barrier. | E05-23; exact support matrix and formal conformance remain human-owned. |
| **E05-25** | **Task-success, aggregate-first interpretation, and usability safety.** Synthetic representative personas perform priority tasks; test empty/stale/offline/partial/unknown/forbidden states, preview comprehension, recovery, and absence of detail/productivity inference. | Preregistered tasks; observed errors/backtracks/completion; comprehension questions; state-interpretation oracle; accessibility co-review | Users distinguish zero/no-data/offline/unknown/partial; can identify realm, scope, impact, status, recovery; normal tasks need no DB/direct detail; no screen implies productivity/forensic certainty. | Users repeatedly misread state/scope; need generic DB access; destructive scope unclear; hidden action; task depends on person/activity detail without approved purpose; accessibility workaround changes authority. | E05-02, E05-10, E05-23–24; actual production users/tasks human-blocked. |
| **E05-26** | **Front-end/framework/design-system/BFF dependency bake-off.** Implement the same shell, paged table, form, dialog, tree, status, preview, job, audit, and error workflows with candidates and standards-first local components; compare exact packages, accessibility, security, bundle, SSR/hydration, performance, localization, tests, maintenance, licenses, source mapping, removal. | Same task/AT scripts; bundle/file/SBOM; security headers; dependency graph; build/repro; defects; upgrade/removal spike; total lifecycle assessment | Candidate passes every hard accessibility/security/contract gate, has acceptable exact dependency/license/maintenance evidence, and is not worse than local components; no-winner is valid. | Selection by popularity/look; critical AT failure; unbounded package closure; preview/unstable package; license/provenance gap; impossible removal; hidden authority/client data cache; no owner. | E05-00, E05-23–25. |
| **E05-27** | **Performance, contention, availability, and cardinality characterization.** Open-arrival tests for BFF sessions, decision evaluation, preview, command, audit head locking, sensitive reads, audit queries, segment seal, verifier, restore, browser rendering, and reconnect storms. Use one-realm hot spot and many-realm mix. | Offered/started/completed operations; latency distributions; DB locks/log/WAL; queue/backlog; CPU/memory; browser timings; series count; unanchored tail; generator saturation proof | No correctness/privacy/accessibility failure under offered range; generator sustains schedule; per-realm contention is bounded/recoverable; backlog drains while arrivals continue; metrics remain within declared finite model. | Cross-realm/correctness failure; starvation; unbounded head contention; audit write disabled for speed; generator saturation hidden; cardinality explosion; stale verification silently accepted; browser task unusable. | E05-01–26; numeric objectives human-owned. |
| **E05-28** | **Export, lifecycle, integration, diagnostic/support, and notification safety.** Exercise registered contracts, secret references, SSRF/path/header attacks, external deletion states, formula injection, notification dedupe, support permits/bundles, expiry/revocation, partial/limitation states, and all-sink canaries. | Destination/egress traces; secret-access logs; object manifests; connector state; deletion evidence; notification bodies; support bundle inventory; canary scan | Only fixed registered destinations/profiles; no secret to browser/audit; truthful `COMPLETE_WITH_LIMITATIONS`; dedupe without hiding first failure; permits expire/revoke; no arbitrary command/file/dump/raw activity. | Arbitrary URL/header/path/script; SSRF; secret returned; HTTP 2xx treated as deletion; recipient copy falsely claimed removed; formula-active export; notification leaks sensitive data; support becomes remote shell/raw evidence channel. | E05-10, E05-13–14, E05-19; human destination/purpose/access decisions open. |
| **E05-29** | **Incident hold, no-self-reenable, runbook, support, and cleanup campaign.** Trigger realm mismatch, audit unavailable, tamper, stale checkpoint, key compromise, accessibility regression, export leak, authorization cache fault, dependency advisory, and restore failure. Use operator runbooks without direct DB bypass. | Alert and case timeline; hold/kill state; operator actions; first-failure preservation; recovery evidence; re-enable approvals; cleanup | Safe scope enters hold/deny; ordinary admin cannot clear; first evidence preserved; recovery follows explicit command and current verification; no direct DB/generic bypass; support succeeds with safe evidence. | Alert absent/unbounded; automatic broadening/retry; admin self-clears; runbook requires raw activity/direct SQL; evidence overwritten; affected release reenabled without gate; residue. | E05-04–28; owner assignments required for production. |
| **E05-30** | **Aggregate Batch 05 gate replay.** Rebuild exact candidate from clean locked inputs; rerun all load-bearing tests and human-approved profiles; reconcile artefacts, source, package, SBOM, evidence, owners, ADRs, runbooks, cleanup, and expiry. | Signed/approved gate manifest referencing every evidence root; hard-failure count; owner/decision/ADR matrix; clean-room replay; cleanup receipt | Every required gate is current and exact; hard failures are zero; blocking human decisions/owners recorded; no unresolved contradiction; evidence and product digests reconcile; production approval remains separately false until granted. | Any hard failure, missing/stale/mismatched evidence, unresolved owner/decision/ADR, hidden dependency, changed digest, cleanup residue, or report overclaim. | E05-00–29 plus accepted predecessor gates required by the intended release. |

## 7.4 Aggregate machine-checkable gate

The gate evaluator MUST calculate, at minimum:

```text
B05_TECHNICAL_PASS =
  missing_route_descriptors == 0
  AND wildcard_or_default_allows == 0
  AND browser_token_escapes == 0
  AND unsafe_cross_site_mutations == 0
  AND cross_realm_effects_or_disclosures == 0
  AND purpose_target_output_bypasses == 0
  AND expired_or_revoked_commits == 0
  AND stale_authorization_cache_commits == 0
  AND approval_or_sod_bypasses == 0
  AND hidden_or_generic_admin_actions == 0
  AND stale_preview_executions == 0
  AND duplicate_command_business_effects == 0
  AND privileged_effects_without_decision_and_audit == 0
  AND success_audit_without_business_effect == 0
  AND sensitive_disclosures_before_audit_commit == 0
  AND forbidden_value_or_canary_escapes == 0
  AND required_tamper_survivors == 0
  AND ordinary_admin_undetected_audit_alterations == 0
  AND restored_stale_authority_activations == 0
  AND verification_failures_self_cleared == 0
  AND break_glass_out_of_profile_actions == 0
  AND critical_accessibility_failures == 0
  AND cleanup_failures == 0
  AND flaky_unclassified_failures == 0
  AND evidence_profile_mismatches == 0
  AND blocking_owner_or_adr_gaps == 0
  AND all_required_evidence_current == true
```

`B05_TECHNICAL_PASS=true` proves only the exact tested implementation profile. It MUST NOT set `productionApproved`, `legalPurposeApproved`, `roleAssignmentsApproved`, `auditRetentionApproved`, `supportCommitmentApproved`, or `riskAccepted`.

## 7.5 Suggested CLI/repository entry points

Concrete filenames may change with the accepted repository scaffold, but the release candidate MUST provide equivalent deterministic entry points:

```text
dotnet tool restore --locked-mode
dotnet restore --locked-mode
dotnet build -c Release --no-restore

dotnet test tests/Uam.Portal.Contracts.Tests --no-build
dotnet test tests/Uam.Portal.Architecture.Tests --no-build
dotnet test tests/Uam.Authorization.Model.Tests --no-build
dotnet test tests/Uam.Authorization.Property.Tests --no-build
dotnet test tests/Uam.Portal.Bff.Security.Tests --no-build
dotnet test tests/Uam.Portal.RealmIsolation.Tests --no-build
dotnet test tests/Uam.Portal.Workflow.Tests --no-build
dotnet test tests/Uam.Audit.Atomicity.Tests --no-build
dotnet test tests/Uam.Audit.Verification.Tests --no-build
dotnet test tests/Uam.Portal.Restore.Tests --no-build

node ./eng/accessibility/run-static.mjs
node ./eng/accessibility/run-browser.mjs
node ./eng/portal/run-task-scripts.mjs

./eng/lab/run-db-audit-pair.sh --profile <exact-profile>
./eng/lab/run-tamper-corpus.sh --profile <exact-profile>
./eng/lab/run-restore-reconciliation.sh --profile <exact-profile>
./eng/lab/run-breakglass-drill.sh --profile <exact-profile>
./eng/evidence/verify-manifest.sh <evidence-root>
./eng/evidence/scan-all-sinks.sh <evidence-root>
./eng/evidence/prove-cleanup.sh <run-id>
```

These are normative in intent. Exact tool versions, shell choice, CI service, browsers, accessibility tools, database images, and package managers are execution-time dependency decisions and MUST be captured by E05-00.

---

# 8. Threat, failure, and recovery gaps

## 8.1 Threat/failure/recovery register

| ID | Threat or failure | Accepted containment | Residual gap / **UNKNOWN** | Required test, runbook, and owner | Safe state |
|---|---|---|---|---|---|
| T05-01 | Identity provider compromise or malicious federation issuer | Issuer/audience/metadata allowlist, server-side session, UAM capability mapping, fresh auth profile, revocation, no direct IdP-role authority | A validly authenticated attacker may receive whatever UAM grants remain; upstream compromise detection and assurance are organizational | E05-04/07/09; identity-compromise runbook; IAM/Security Incident | Revoke issuer/sessions/grants; deny new login/step-up/JIT; keep minimum static outage page. |
| T05-02 | Session theft, fixation, replay, multi-tab confusion, logout failure | Opaque host-only secure cookie, rotation, server state, CSRF, realm-bound session, absolute/idle expiry, revocation generation | Endpoint/browser malware can use current session; exact device/browser binding may harm accessibility or privacy | E05-04; session emergency revoke runbook; Portal IAM | Revoke session family; force reauthentication; preserve unsent non-sensitive draft only. |
| T05-03 | CSRF, login CSRF, mix-up, malicious origin, method confusion | State/nonce/PKCE, fixed redirects, same-origin BFF, antiforgery token, Origin/Fetch Metadata, side-effect-free safe methods | Provider/topology quirks and reverse-proxy normalization remain unproved until exact deployment | E05-04; BFF incident runbook; Portal Security | Deny request/login; invalidate affected session; no mutation. |
| T05-04 | XSS, malicious catalogue/display string, third-party script compromise | Native text rendering, strict CSP, no browser tokens, minimized models, dependency lock, no arbitrary HTML | XSS can still submit actions within current session; framework/design-system defects recur | E05-04/14/26; front-end supply-chain/XSS runbook | Kill affected route/release, revoke sessions, narrow capabilities, no unsafe CSP weakening. |
| T05-05 | Cross-realm IDOR or confused deputy | One active server realm, realm-first keys, target resolution under realm, generic deny/not-found, global plane separate | Privileged direct DB/infrastructure path remains outside app predicate; rare aggregate inference | E05-06; realm-breach runbook; Realm Security/Data Reliability | Realm/route/global hold; revoke affected release/session; no result disclosure. |
| T05-06 | Product-global route accidentally treats missing realm as global | Explicit global session/context/capability and namespace; ordinary realm session cannot omit realm into global | Tooling or migration may introduce nullable/missing-scope shortcuts | E05-01/03/05/06; catalogue and schema owner | Fail build/start or deny; global control plane disabled. |
| T05-07 | Stale authorization cache or invalidation outage | Cache keys include epochs/revisions; earliest expiry; high-risk final DB recheck; unknown deny | Low-risk stale-read policy and exact revocation objective are human/SRE decisions | E05-09/27; invalidation outage runbook; Authorization/SRE | High risk deny; bounded low-risk read only if explicitly approved; otherwise deny. |
| T05-08 | Role/group drift, orphaned owner, hidden wildcard | Release-owned immutable capabilities/role revisions; no direct group authority; review/expiry; owner gate | Organization mapping, group lifecycle, and separation staffing are unresolved | E05-08; access-review runbook; IAM Governance | Disable/orphan grant; do not infer replacement owner. |
| T05-09 | Approval collusion, self-approval, ceremonial review, changed content | Exact digest binding, eligibility/SoD/quorum, immutable preview, expiry/revoke, changed-content invalidation | Technical controls cannot prove independent judgment or prevent off-system coercion | E05-09/10; approval incident/runbook; Security Governance | Deny/expire request; invalidate approvals; hold affected workflow. |
| T05-10 | JIT expiry or revoke races with commit | Database time, final transactional authorization, generation/epoch, job phase recheck | Distributed external effect already released cannot always be undone | E05-09/11/13/28; grant-revocation runbook | Stop future effects; preserve committed evidence; revoke unreleased artifact/destination where possible. |
| T05-11 | Background job carries submitting user's full/permanent authority | Narrow job authorization envelope, service capability, phase reauthorization, stable scope/digests | Long external operations and compensation semantics vary by workflow | E05-09/10/28; job containment runbook; Workflow owner | Pause/cancel before next effect; no automatic broad retry. |
| T05-12 | Preview/execute TOCTOU, bulk scope drift, stale object | Server-owned scope snapshot, preview digest/expiry, `If-Match`, re-resolve and compare | Large scopes may be costly to freeze; exact expiry/size values unmeasured | E05-10/27; stale-preview recovery; Command owner | `PREVIEW_STALE`; no mutation; require new preview/approval. |
| T05-13 | Generic admin endpoint, hidden action, direct ORM/table mutation | Compiled descriptor/catalogue, explicit commands, architecture tests, least DB grants | Emergency operator pressure can create undocumented bypasses | E05-03/05/29; route incident runbook; API Architecture/Security | Remove/disable route, revoke role, hold affected release, audit/reconcile all calls. |
| T05-14 | Audit database/sink unavailable | Same transaction as effect; privileged mutation and sensitive disclose fail closed; safe finite error | Administrative outage, backlog, and emergency recovery availability | E05-11/13/27; audit-unavailable runbook; Audit/Data Reliability/SRE | Deny effect/disclosure; keep health and recovery-only plane if independently safe. |
| T05-15 | Unknown commit/response loss | Stable command ID/digest and status reconciliation; retry same identity | Operator/client bugs may generate a new ID; exact timeout/retry values unmeasured | E05-10/11; commit-ambiguity runbook; API/Workflow | Report `COMMAND_COMMIT_UNKNOWN`; query prior command; no new command until resolved. |
| T05-16 | Audit stream contention, deadlock, sequence gap, head corruption | Per-scope stream, row lock/CAS, database transaction, verifier, explicit hold | Hot global/realm stream may limit throughput; sharding/alternate sequencing unproved | E05-11/15/16/27; stream-integrity runbook; Audit/Data Reliability | Roll back command; enter scoped `AUDIT_SEQUENCE_CONFLICT` hold; no synthetic repair. |
| T05-17 | Canonicalization/hash/Merkle implementation defect | Frozen profiles, independent implementation, golden vectors, domain separation, explicit epochs | Both implementations may share a conceptual specification error | E05-01/15/16; crypto/audit change runbook; Contract/Audit/Crypto owners | Stop sealing/verification; deny operations requiring current verification; preserve bytes and old profile. |
| T05-18 | Malicious authorized release emits false but internally consistent event | Release provenance, strict catalogue, code review, business/effect/event reconciliation, independent verifier | Cryptography cannot establish semantic truth or completeness against a malicious release | E05-03/11/14/29; malicious-release/incident review; Release/Security/Audit | Revoke release and authority; hold affected scopes/time; compare business truth and independent evidence. |
| T05-19 | Ordinary product administrator edits/deletes audit | DB grants, append-only application path, no normal update/delete, external checkpoints | Misconfiguration or indirect procedure privilege may bypass | E05-16/17/20; direct-admin runbook; DB Security/Audit | Block user/role; integrity hold; preserve first failure and checkpoint evidence. |
| T05-20 | Database superuser or host/storage administrator tampers | Independent signed checkpoints outside ordinary admin boundary, restore comparison | Unanchored tail can be altered before next checkpoint; collusion with verifier remains | E05-16–18; tamper-response runbook; Security Incident/Audit/Operations | Hold affected stream/realm/global plane; no clear until independent investigation and declared continuity. |
| T05-21 | Verifier/operator/key/storage compromise or collusion | Purpose-separated read-only verifier, separate key/account/storage/alerts, key rotation/revocation, optional witnesses | Organizational independence, quorum, and external party requirements unresolved | E05-17/18/22; verifier/key compromise runbook; Audit/Risk/Crypto | Revoke key, freeze trust at last accepted checkpoint, stop production claims/affected actions, establish new epoch by ceremony. |
| T05-22 | Checkpoint outage, stale anchor, publication ambiguity, split view | Idempotent manifests, immutable object versions, trusted previous digest, stale timers, conflicting-checkpoint hold | Acceptable unanchored age and service availability are human decisions | E05-18/27; checkpoint outage runbook; Verifier/SRE | Continue only explicitly allowed low-risk operations; deny configured privileged actions; never mark current. |
| T05-23 | Clock uncertainty or malicious time | Stream sequence is order; database time for grants/transactions; time-quality field; trusted timestamp optional | Legal/evidentiary time requirements and cross-system skew profile unresolved | E05-09/15/18/22; clock incident runbook; SRE/Crypto/Identity | Deny expiry-sensitive JIT/approval/break-glass; mark time uncertain; no silent extension. |
| T05-24 | Restore rolls back grants, revocations, tombstones, audit, or verifier state | New isolated identity, current authority/tombstone/receipt/checkpoint replay, no pre-ready read/egress/mutation | Exact RPO/RTO, independent authorities, and old-backup coverage are open | E05-21; restore runbook; Data Reliability/IAM/Audit/Lifecycle | `READ_BLOCKED`/`MUTATION_BLOCKED`/`EGRESS_BLOCKED`; destroy/quarantine failed restore. |
| T05-25 | Audit query, rare-population, actor/case correlation misuse | Purpose/capability/realm filters, minimum fields, access audit, view-time names, fixed queries, export governance | Even opaque metadata may enable inference; suppression rules/access periods are human decisions | E05-13/14/19/25; audit misuse runbook; Privacy/Audit/IAM | Revoke access/export, hold view/profile, investigate access trail; no source-row rewriting. |
| T05-26 | Export copied externally or retained by recipient | Manifest, recipient class, encryption, one-use release, expiry, deletion state, limitation text | Human-controlled/offline copies cannot be recalled or independently deleted by default | E05-13/28; export compromise/recipient runbook; Data Owner/Privacy/Security | Revoke UAM object/link; mark `EXTERNAL_ACTION_REQUIRED` or `COMPLETE_WITH_LIMITATIONS`; notify authority. |
| T05-27 | Audit/lifecycle retention destroys required evidence or retains too much | Minimize at creation, whole-segment pruning, holds, checkpoint preservation, typed policy revision | Legal periods, subject mappings, backup copies, and root retention are unresolved | E05-19/21; retention/hold runbook; Records/Legal/Audit | Retention disabled on uncertainty; hold blocks pruning; no ad hoc purge. |
| T05-28 | Break-glass abuse, credential loss, or inability to recover lockout | Fixed disabled recovery profile, separate identity/credential, quorum candidate, hard expiry, external alert, no detail/export | Real custodians, key recovery, staffing, and independent path do not exist yet | E05-22; break-glass runbook; Security Incident/Identity Recovery | Keep disabled until approved; during incident freeze normal mutations and use out-of-band organizational recovery. |
| T05-29 | Critical workflow inaccessible during normal or emergency use | WCAG 2.2 AA target, native semantics, full workflow tests, accessible timeout/status, alternate authentication | Browser/AT regressions, cognitive needs, and out-of-hours assistive support remain | E05-23–25/29; accessibility incident runbook; Accessibility/Product/Support | Disable affected action or provide reviewed equivalent accessible path; never use direct DB as accessibility workaround. |
| T05-30 | Design-system/framework update regresses security/accessibility | Exact dependency lock, bake-off, component tests, recurring AT matrix, staged rollout, removal plan | Upstream release cadence and long-term maintenance capacity are unknown | E05-26/29; dependency incident runbook; Front-end/Accessibility/Security | Freeze/rollback higher authorized release; disable affected workflow; no unreviewed patch. |
| T05-31 | Notification overload, loss, duplicate, leakage, or false authority | Typed safe templates, in-portal source of truth, dedupe, status links, no completion inference | Recipients/channels/escalation/SLA are human decisions; external channel compromise | E05-28/29; notification runbook; Operations/Privacy | Business state remains authoritative; suppress unsafe channel; show in-portal incident status. |
| T05-32 | Metrics/traces leak identifiers or explode cardinality | Compile-time finite catalogue, forbidden dynamic labels, canary scan, calculated series bound | Rare combinations and backend defaults can still leak or saturate | E05-14/27/29; observability runbook; SRE/Privacy | Disable affected exporter/instrument; preserve business/audit path; no fallback to raw text. |
| T05-33 | Direct database emergency maintenance bypasses app/audit | Ordinary ops use explicit commands; DB roles minimized; native supplemental audit; reconciliation | True disaster recovery may require privileged DB action; approved protocol/owner absent | E05-16/20/21/22; emergency DB change procedure; Data Reliability/Security/Audit | Freeze portal/egress, record independent incident evidence, perform only approved recovery, reconcile before re-enable. |
| T05-34 | External dependency/service outage or compromised update | Small dependency surface, exact pin/source mapping, fail closed, no external PDP/workflow/log by default | IdP, KMS, database, object anchor, browser, package source, and CI remain failure domains | E05-00/04/17/18/26/29; supply-chain/outage runbook; Platform/Security | Use verified last-known-good only where authority remains current; deny new high-risk authority; revoke compromised artifact. |
| T05-35 | Support requests raw logs, dumps, activity, direct access, or arbitrary commands | Closed diagnostics/support capabilities, permits, safe bundles, no remote shell, audit-before-release | Some defects may remain unreproducible; support competence/staffing unproved | E05-14/28/29; privacy-safe support runbook; Support/Security/Privacy | Reproduce with T1; narrow support promise; do not broaden data collection or create bypass. |
| T05-36 | Legal/compliance/evidentiary overclaim | Explicit labels and limitations; no sole-forensic/productivity/non-repudiation claim; human registry | Users may still infer stronger truth from UI wording or signed checkpoints | E05-25/29; claim/wording review; Legal/Compliance/Product | Remove/disable misleading claim/view; issue correction; preserve technical evidence and limitations. |

## 8.2 Mandatory runbooks before production candidacy

Each runbook MUST name trigger, scope, authority, first evidence, safe state, allowed commands, prohibited commands, communication, external dependencies, recovery proof, cleanup, evidence retention, and re-enable gate. At minimum:

1. identity-provider compromise and mass session/grant revocation;
2. BFF/session/CSRF or browser-token incident;
3. cross-realm authorization or data-return incident;
4. stale/incorrect authorization cache or catalogue deployment;
5. audit transaction unavailable or stream-sequence conflict;
6. audit gap/alteration/fork/rollback/signature failure;
7. verifier, checkpoint store, signer, or trusted-first-checkpoint compromise;
8. key rotation, revocation, loss, and algorithm/profile migration;
9. checkpoint outage and stale/unanchored-tail containment;
10. inaccessible critical workflow or assistive-technology regression;
11. break-glass activation, revocation, post-use review, and credential replacement;
12. export/access compromise and external-recipient limitation handling;
13. direct database emergency recovery and later reconciliation;
14. old-backup restore, authority/tombstone/receipt/audit reconciliation, and failed-restore destruction;
15. dependency/advisory/supply-chain compromise;
16. privacy-canary or secret-positive-control detection;
17. support failure that cannot be diagnosed with the approved safe evidence;
18. role/owner orphaning, purpose withdrawal, or legal/policy change requiring immediate disablement.

## 8.3 Gaps that remain human- or later-batch-blocked

- **UNKNOWN:** whether ordinary product, database, host, verifier, cloud-account, and key administrators are genuinely separate in the target organization.
- **UNKNOWN:** whether regulatory or contractual requirements demand qualified timestamps, customer/regulator-held checkpoints, witness quorum, non-repudiation claims, or a different retention design.
- **UNKNOWN:** exact human roles, purposes, approval duties, support/on-call, accessibility policy, audit access, retention, break-glass authority, incident response, and production risk acceptance.
- **UNKNOWN:** exact identity-provider, database, KMS/HSM, object/WORM anchor, portal framework, design system, browser/AT support matrix, and deployment topology.
- **UNKNOWN:** production rates, hot-realm distribution, audit/read/export volume, checkpoint cadence, retention growth, outage duration, restore objectives, and cost.
- **UNKNOWN:** whether the organization can sustain recurring cross-realm tests, manual accessibility execution, independent verification, key ceremonies, dependency admission, restore drills, and evidence renewal.
- **INFERENCE:** Until those gaps are resolved, the safest truthful system state is a T1-only implementation with production capabilities disabled, not a weaker authorization/audit/accessibility profile.


---

# 9. ADR create/update list

## 9.1 ADR creation actions

`PROPOSED — ACCEPT` means this review recommends the architecture forum record the decision as the implementation baseline while keeping its named proof and human gates open. `PROPOSED — DEFER` means the alternatives and trigger are recorded but no production technology/authority is selected. `PROPOSED — HUMAN DECISION` records a technical representation whose policy values cannot be selected by engineering research.

| ADR ID | Decision record | Proposed status | Decision / boundary | Alternatives retained | Gate or review trigger |
|---|---|---|---|---|---|
| **ADR-B05-001** | Same-origin portal BFF boundary | **PROPOSED — ACCEPT** | Browser is untrusted presentation; ASP.NET Core BFF inside modular monolith holds server session/tokens, derives realm, composes read models, and invokes explicit domain commands. | Server-rendered-only candidate; public browser API with tokens only by change proposal. | E05-04–06, E05-26; topology or deployment constraint. |
| **ADR-B05-002** | OIDC, browser session, CSRF, logout, and token profile | **PROPOSED — ACCEPT WITH EXECUTION-TIME PROFILE** | Confidential-client authorization code flow, PKCE, PAR where supported, server-side tokens, opaque secure cookie, rotation, CSRF, fixed redirects, current logout/revocation. | Exact IdP, cookie/session store, PAR/back-channel support, durations remain open. | E05-04; IAM human decisions HD05-13–14. |
| **ADR-B05-003** | In-process authorization kernel | **PROPOSED — ACCEPT** | Small pure C# evaluator; release-owned capability RBAC plus closed conditions; no general policy language, network, ORM, UI, or reflection-discovered policy. | Cedar/OPA/external PDP as references or later comparator only. | E05-01/03/05/07; measured multi-service/policy-complexity trigger. |
| **ADR-B05-004** | Realm and product-global authority model | **PROPOSED — ACCEPT** | One active realm per normal session; explicit separate product-global context/capabilities; realm-first keys; target resolved under authenticated realm; missing realm is never global. | Approved central multi-realm oversight workflow with explicit manifests. | E05-06; HD05-05. |
| **ADR-B05-005** | Capability and response-field catalogue | **PROPOSED — ACCEPT** | Immutable resource/action capability revisions bind risk, scope kinds, purpose, authn, approval, audit, output, delegability, service/break-glass eligibility, and owner. | No wildcard/tenant action definition. | E05-01/05/07; route/capability growth review. |
| **ADR-B05-006** | Role templates, assignments, standing grants, and delegation | **PROPOSED — ACCEPT MECHANISM / HUMAN VALUES OPEN** | Roles are exact bundles; grants bind principal/realm/scope/purpose/time/revision; delegation is strict subset; no self-grant or implicit IdP role authority. | External PIM may provide upstream eligibility/approval signal later. | E05-08; HD05-02–05, 10–12. |
| **ADR-B05-007** | JIT request/approval/activation/revocation model | **PROPOSED — ACCEPT** | Request, approval, and grant are separate immutable states; approval binds exact request/preview; database time, epochs, expiry, revoke, SoD, and job reauthorization apply. | Exact duration/quorum profiles human-owned. | E05-09; HD05-09–13. |
| **ADR-B05-008** | Purpose, ticket/case, target, and output obligations | **PROPOSED — ACCEPT MECHANISM / HUMAN REGISTRY OPEN** | Sensitive authorization requires approved purpose ID, exact target/scope, case/ticket where defined, and output profile; unknown/missing/stale denies. | No free-form purpose or broad post-fetch redaction. | E05-07; HD05-06–08, 15. |
| **ADR-B05-009** | Authorization cache, revocation epoch, and outage behavior | **PROPOSED — ACCEPT PRINCIPLES / NUMERIC VALUES OPEN** | Cache immutable inputs by realm/principal/session/generation/revisions; earliest expiry; high-risk final authoritative recheck; unknown/outage deny. | Exact TTL/availability profile remains measured/human. | E05-09/27; HD05-38. |
| **ADR-B05-010** | Authorization decision and safe error evidence | **PROPOSED — ACCEPT** | Typed finite decision record links actor/context/capability/grant/purpose/target/approval/policy/result/obligations without raw request, claims, query, token, or exception. Ordinary errors are generic; authorized audit sees finite details. | No generic logs as decision record. | E05-07/11/12/14. |
| **ADR-B05-011** | Aggregate-first, least-detail portal information architecture | **PROPOSED — ACCEPT** | Default portal exposes operational aggregates, coverage, quality, freshness, workflow and safety state; person/activity detail route/API is structurally absent until approved. | Later purpose-specific minimum detail view by ADR/human decision. | E05-25; HD05-02, 07–08. |
| **ADR-B05-012** | Explicit command, preview, idempotency, and job pattern | **PROPOSED — ACCEPT** | Named commands only; server scope snapshot, immutable preview, `If-Match`, stable command ID, finite reason, exact approvals, final reauthorization, durable job, explicit pause/kill/rollback/recovery. | No generic CRUD/patch/table editor/workflow language. | E05-10/11; measured state-machine counterexample. |
| **ADR-B05-013** | Canonical application-owned typed audit ledger | **PROPOSED — ACCEPT** | One authoritative typed ledger in the relational business transaction; portal audit schema is a projection of it; diagnostics/native logs are supplemental. | Separate primary audit DB/service rejected absent atomic mechanism. | E05-11–16. |
| **ADR-B05-014** | Privileged mutation transaction composition | **PROPOSED — ACCEPT** | Final authorization decision, business mutation, success audit event, stream-head advance, and required job/outbox rows commit together; commit ambiguity reconciles by command ID. | No external network call or post-commit primary log. | E05-11/12. |
| **ADR-B05-015** | Audit-before-disclose | **PROPOSED — ACCEPT** | Sensitive read/audit query/export/download/support result is buffered/built; access/completion audit commits before bytes or retrieval capability are released. | No streaming-before-audit or direct object bypass. | E05-13. |
| **ADR-B05-016** | Audit scope, sequence, and stream model | **PROPOSED — ACCEPT** | Separate realm control/system streams and product-global control/system streams; monotonic sequence is order; time is evidence; no global all-realms business stream by default. | Sharding/additional stream only after measured contention and proof of completeness. | E05-11/15/27. |
| **ADR-B05-017** | Audit canonicalization, hash chain, Merkle segment profile | **PROPOSED — ACCEPT FOR PROTOTYPE / CODEC PROFILE OPEN** | Domain-separated event hash, contiguous per-stream chain, sealed segment Merkle roots, previous-manifest linkage, golden vectors, explicit epochs/profile migration. | JCS versus another accepted canonical representation follows common control-artifact ADR and vectors. | E05-01/15/16; profile-change ADR. |
| **ADR-B05-018** | Independent signed checkpoint prerequisite | **PROPOSED — ACCEPT PRINCIPLE** | External independently protected checkpoint and verifier are mandatory before privileged production use; not required to begin local transaction prototypes. | Private WORM, witness, transparency service, regulator/customer-held checkpoint remain candidates. | E05-17/18/21; HD05-18, 24–26. |
| **ADR-B05-019** | Verifier, anchor, key, and first-trust separation | **PROPOSED — ACCEPT PRINCIPLES / HUMAN TOPOLOGY OPEN** | Separate build/process/read-only credential/key/account/storage/alert; verifier state not restored with product DB; explicit trusted-first-checkpoint/key rotation/revocation. | Internal independent team, external service, quorum/witness topology. | E05-17/18/22; HD05-18, 25–26. |
| **ADR-B05-020** | Audit verification findings and safety hold | **PROPOSED — ACCEPT** | Gap/alter/fork/rollback/signature/stale findings preserve first failure, enter scoped hold, prohibit silent repair/self-clear, and require explicit incident/recovery evidence. | Exact realm/global response human-owned. | E05-16/18/29; HD05-19. |
| **ADR-B05-021** | Audit access, redaction, export, and source immutability | **PROPOSED — ACCEPT MECHANISM / ACCESS VALUES OPEN** | Fixed realm/global/case capabilities and filters; access audited; display names resolved at view time; redaction is versioned view/export; source events never edited. | Exact reviewer roles/fields/purpose/retention human-owned. | E05-13/14/19; HD05-20–23. |
| **ADR-B05-022** | Audit retention and whole-segment pruning | **PROPOSED — ACCEPT MECHANISM / PERIODS OPEN** | Minimize at creation; prune only complete externally checkpointed segments after policy/hold/export predicates; retain signed root and destruction evidence as separately approved. | Partial field expiry/encrypted envelope only by new ADR and proof. | E05-19/21; HD05-22–23. |
| **ADR-B05-023** | Database-native audit controls | **PROPOSED — DEFER SELECTION / ACCEPT SUPPLEMENTAL ROLE** | SQL Server Ledger/Audit and pgAudit may supplement direct-DB/DDL detection; they never replace typed UAM audit. | Exact engine/edition/config/access/retention profile after B04 DB decision. | E05-20; HD05-27–28. |
| **ADR-B05-024** | Dedicated transparency/immutable-log dependency | **PROPOSED — DEFER** | No Tessera/Rekor/Trillian/immudb or other service is a default runtime dependency. Reuse design/test ideas; private immutable checkpoint storage is the smaller first anchor candidate. | External discoverability, split-view, multi-party witnessing, regulatory, scale, or cost trigger. | E05-17/18/27; HD05-23–25. |
| **ADR-B05-025** | Break-glass and offline lockout recovery | **PROPOSED — ACCEPT MODEL / DISABLED PENDING HUMAN AUTHORITY** | Fixed recovery-only capability, separate credential/path, no detail/export, hard expiry, independent alert/revoke, same audit/verification, post-review. | Exact identities/quorum/crypto/duration/commands human-owned. | E05-22; HD05-17, 26. |
| **ADR-B05-026** | Restore authority and audit continuity | **PROPOSED — ACCEPT** | New isolated environment identity; no ordinary read/egress/mutation/receipt; current grants/revocations/catalogue/purposes/tombstones/receipts/checkpoints reconcile; readiness and enablement separate. | No trust in restored local head/session/grant. | E05-21; B04 lifecycle gate; HD05-38, 42. |
| **ADR-B05-027** | Accessibility engineering target and gate | **PROPOSED — ACCEPT TARGET / FORMAL POLICY OPEN** | WCAG 2.2 AA across complete workflows; native semantics first; automated plus manual keyboard/AT/zoom/forced-color/reduced-motion/status/authentication tests; critical failure blocks. | Stricter legal/procurement target or additional EN 301 549 clauses. | E05-23–25; HD05-30–31. |
| **ADR-B05-028** | Portal framework and design-system selection process | **PROPOSED — DEFER SELECTION** | Framework-neutral BFF/screen/command/accessibility contracts; compare exact candidates and local components; at most one general component system; no-winner allowed. | E05-26 and ownership/procurement. | E05-26; HD05-29–31, 41. |
| **ADR-B05-029** | BFF library/dependency choice | **PROPOSED — DEFER AUTOMATIC DEPENDENCY** | Built-in ASP.NET Core primitives are first candidate; Duende BFF is commercial candidate only if exact bake-off/license/operations result wins. | Identity-provider/topology complexity and total-cost evidence. | E05-00/04/26; HD05-14, 29, 41. |
| **ADR-B05-030** | Export, integration, lifecycle, diagnostic, and notification governance | **PROPOSED — ACCEPT CLOSED-CONTRACT PRINCIPLE / HUMAN VALUES OPEN** | Registered typed profiles, fixed destinations, opaque secret refs, audit-before-release, explicit limitations, no arbitrary URL/path/header/script/file/dump, notification is not truth. | Exact destinations/formats/recipients/retention/support human-owned. | E05-28; HD05-32–36. |
| **ADR-B05-031** | Portal/audit observability and cardinality | **PROPOSED — ACCEPT PRINCIPLES / BUDGET OPEN** | Finite compile-time labels; no realm/principal/target/case/digest/free text; canaries and series calculation; diagnostics never audit. | Backend/sampling/threshold/retention human-owned. | E05-14/27/29; HD05-39. |
| **ADR-B05-032** | Feature flags, kill switches, and safety holds | **PROPOSED — ACCEPT** | Finite release-owned controls only narrow/deny/pause; no bypass of realm/purpose/audit/tombstone/restore/verification; no self-clear. | Exact operators/expiry/communications human-owned. | E05-10/18/29; HD05-37. |
| **ADR-B05-033** | Source/dependency admission and recurring verification | **PROPOSED — ACCEPT** | Exact tags/commits/source-package-binary/license/advisory/test/security mapping; fast-moving versions execution-time; references are not dependencies; removal plan required. | Product-specific procurement/support choices. | E05-00/26/29; HD05-41. |
| **ADR-B05-034** | Batch 05 aggregate evidence gate | **PROPOSED — ACCEPT** | Machine-checkable zero-tolerance technical gate plus required human decisions/owners/current evidence/cleanup; technical pass never sets production approval. | No waiver of cross-realm, audit, accessibility, break-glass, or cleanup hard failures. | E05-30; HD05-42. |

## 9.2 Predecessor ADR updates without baseline change

The following predecessor records SHOULD be updated by reference, not silently rewritten:

| Existing subject | Update action | Reason | Prohibited interpretation |
|---|---|---|---|
| Batch 01 strict contracts and repository boundaries | Add Batch 05 route/capability/audit/accessibility catalogues, canonical vectors, architecture mutations, and dependency admission as downstream consumers. | Preserves one contract/evidence authority across portal and audit. | Do not make UI DTO, audit row, domain model, and persistence entity one shared type. |
| Batch 01 privacy ceiling and tenant narrowing | Add portal capability/output profiles, diagnostic/export controls, flags, and kill switches as release-owned/narrowing-only dimensions. | Portal actions and outputs are capabilities/destinations governed by the same monotonic rule. | Tenant cannot add action, script, destination, field, matcher, audit schema, or verifier bypass. |
| Batch 03 identity/server-authenticated realm | Add human BFF session and service principal contexts while preserving server-derived realm and no payload authority. | Human portal authority must compose with device/server realm rules. | IdP group, browser realm, route, host, or certificate text is not final UAM authority. |
| Batch 03 diagnostics/support | Link diagnostic permits, bundle release, and support access to Batch 05 capability/purpose/audit-before-disclose controls. | Makes support a governed portal workflow without turning diagnostics into audit. | No raw log/dump/file/command or normal audit substitution. |
| Batch 04 control API/BFF boundary | Replace the provisional portal detail with ADR-B05-001 through 012 while preserving modular-monolith/domain ownership. | Batch 05 supplies the missing normal administration architecture. | BFF does not own business truth or expose generic module/table APIs. |
| Batch 04 durable privileged audit invariant | Point to ADR-B05-013 through 023 as the canonical application audit implementation and verification gate. | Resolves P20/P21 overlap and makes external verification a production prerequisite. | Native DB logs or portal projection cannot become separate source of truth. |
| Batch 04 deletion/restore readiness | Add current authorization, session/grant/revocation, audit checkpoint, verifier state, and break-glass reconciliation to read enablement. | Prevents restore from reviving stale authority or trusting rolled-back audit. | Technical restore completion does not itself authorize reads/egress/production. |
| Batch 04 export/integration lifecycle | Add explicit portal previews, approvals, audit-before-release, destination capabilities, and limitation states. | Makes administration safe without redefining custody/fact/deletion truth. | HTTP success/notification remains insufficient for external deletion completion. |

## 9.3 ADR acceptance order

The architecture forum SHOULD process the ADRs in this order because later decisions depend on earlier authority:

1. ADR-B05-001 through 010: browser/session/realm/authorization authority;
2. ADR-B05-011 through 012: portal information architecture and command pattern;
3. ADR-B05-013 through 017: canonical transactional audit and integrity profile;
4. ADR-B05-018 through 024: external verification, access, retention, and supplemental technologies;
5. ADR-B05-025 through 027: emergency recovery, restore, and accessibility hard gates;
6. ADR-B05-028 through 033: replaceable technologies, governed integrations, observability, flags, and dependencies;
7. ADR-B05-034: aggregate gate after the preceding decision records define its exact evidence inputs.

An ADR acceptance records architecture and a proof obligation. It does not convert an open **CLI EXPERIMENT** or **HUMAN DECISION** into a production approval.


---

# 10. Ordered implementation backlog and dependency/stop gates

## 10.1 Sequencing rule

**RECOMMENDATION.** Build the smallest falsifiable authority and evidence core before building attractive administration screens. The critical path is:

```text
accepted contracts and T1 fixtures
  -> complete executable-action catalogue
  -> same-origin session and exact realm context
  -> pure deny-by-default authorization
  -> explicit read/preview/command/job infrastructure
  -> same-transaction decision + business effect + canonical audit
  -> audit-before-disclose
  -> independent verification and restore continuity
  -> accessible complete critical workflows
  -> bounded break-glass recovery
  -> aggregate Batch 05 gate
  -> separate human pilot/production decision
```

A failure at one stage stops dependent work and opens the relevant ADR or change proposal. Teams MAY continue work that cannot conceal or depend on the failed claim—for example, fictional fixture generation or independent verifier model work—but MUST NOT integrate around the failed boundary or weaken it.

## 10.2 Ordered backlog

| Order | Backlog item | Deliverable / acceptance evidence | Dependencies | GO condition | STOP condition |
|---:|---|---|---|---|---|
| 1 | **B05-001 — Create Batch 05 evidence/source manifest** | Ten allowlisted file hashes, research source register, exact tool/source/package/binary/license map, clean repository baseline | None | E05-00 inputs complete and reproducible | Missing/unallowlisted input, mutable executable dependency, unresolved license/source mapping |
| 2 | **B05-002 — Accept ADR-B05-001 through 010 at architecture level** | Recorded BFF/session/realm/authorization/decision boundaries and open human values | 1 | Architecture forum records decisions or explicit alternatives | Silent divergence, browser authority, external PDP selected without gate, unresolved baseline conflict |
| 3 | **B05-003 — Scaffold portal/authorization/audit projects and architecture tests** | Separate browser/BFF/domain/authorization/audit/verifier/persistence/test projects; forbidden-reference mutations | 1–2, Batch 01 repository baseline | Every planted forbidden dependency fails; production artifacts exclude test authority | Shared DTO/persistence/domain model, browser DB/secret dependency, dynamic policy/plugin path, mutation survives |
| 4 | **B05-004 — Build immutable contract and catalogue authority** | Route, capability, purpose, role, grant, approval, response, command, workflow, audit, segment, checkpoint, error, flag, export, support catalogues | 2–3 | E05-01 passes; all items have owner/support placeholders and exact IDs | Duplicate/unowned authority, wildcard, remote schema, canonicalization divergence, unknown authority accepted |
| 5 | **B05-005 — Build deterministic T1 fixture/oracle package** | Fictional realms/personas/resources/commands/audit/tamper/accessibility fixtures and independent truth ledger | 4 | E05-02 passes twice from clean checkouts | Real/source-derived value, nondeterminism, missing negative/no-effect truth, canary miss |
| 6 | **B05-006 — Implement pure authorization model and evaluator** | No-I/O C# evaluator, closed condition primitives, deny precedence, obligations, deterministic decision record | 4–5 | Unit/property/model tests match independent oracle; unknown/missing denies | Network/ORM/UI/reflection dependency, string role authority, default allow, unbounded expression |
| 7 | **B05-007 — Generate executable-action/field inventory** | Build/start reconciliation of routes, commands, jobs, scheduled tasks, repository mutations, response fields to descriptors | 3–6 | B05-CATALOGUE/E05-05 passes | One unclassified/hidden action, generic mutation, field outside profile, side-effecting safe HTTP method |
| 8 | **B05-008 — Implement same-origin BFF shell and synthetic OIDC adapter** | Server-side session/token store, opaque cookie, CSRF, fixed redirects, active realm, session generation/revoke, minimal browser model | 3–7 | E05-04 passes for one exact synthetic provider/browser profile | Token reaches browser storage, CSRF succeeds, fixation/mix-up, client realm/role authority, logout leaves privilege |
| 9 | **B05-009 — Implement realm context and realm-first repository interfaces** | Typed `RealmContext`, explicit product-global context, realm-first keys/caches/cursors, generic denied/not-found | 6–8 | E05-06 core API/database/cache negatives pass | Cross-realm row/effect/existence, missing realm becomes global, realm-less overload/cache |
| 10 | **B05-010 — Implement read-only aggregate portal shell** | Global frame, realm/environment visibility, task-oriented navigation, standard page states, aggregate/health fictional read models, no detail route | 4–9 | Read authorization and basic accessibility semantics pass; no sensitive/live data | Person/activity detail, persistence entities, hidden actions, stale/no-data semantics collapsed, client authorization |
| 11 | **B05-011 — Implement role/grant/delegation state models** | Immutable role revisions, assignments, standing/delegated grants, review/expiry/revoke, strict subset proof | 4–9 | E05-08 mechanism tests pass with fictional personas | Wildcard/admin default, direct IdP group grant, self-grant, delegation broadens, retired grant remains active |
| 12 | **B05-012 — Implement purpose, target, case, and output registries** | Closed fictional purpose/case/scope/output profiles; target resolver; response projection tied to obligations | 4–11 | E05-07 passes with fictional values; production sensitive registries remain empty | Free-form purpose, broad target wildcard, post-fetch leakage, unknown-as-allow, cross-realm resolution |
| 13 | **B05-013 — Implement JIT and approval state machines** | Request/approval/activation/revoke/expire models; exact digests; database-time abstraction; SoD/quorum profile mechanism | 11–12 | E05-09 passes for fictional profiles | Approval reuse after change, self-approval where profile forbids, expired/revoked activation/commit, cache extends authority |
| 14 | **B05-014 — Implement service identities and background authority envelopes** | Exact service principal/capability/realm/audience/credential generation; job lease/phase reauthorization | 6–13, Batch 03 identity principles | Human/service separation and E05-06/09 service/job negatives pass | Human impersonation/default approval, full user session in queue, credential/realm payload authority, post-revoke job effects |
| 15 | **B05-015 — Implement filter snapshot and impact preview service** | Server-owned normalized scope, current watermarks, exact counts/unknowns/limitations, command/preview digests and expiry | 9–14 | E05-10 preview/TOCTOU subset passes | Browser list authoritative, stale preview executes, hidden excluded/unknown population, raw sensitive selector copied |
| 16 | **B05-016 — Implement explicit command gateway and idempotency ledger** | Closed command envelopes, `If-Match`, command ID/digest replay, finite reasons/errors, no generic CRUD | 7, 13–15 | E05-10 command concurrency/replay passes | Generic patch/table editor, last-write-wins, same ID/different digest accepted, response-loss duplicate |
| 17 | **B05-017 — Implement durable job/progress state machines** | Job states/milestones/first failure/retry lineage/cancel-pause-kill-rollback availability; browser transport as presentation only | 14–16 | Restart/reconnect/duplicate/state-transition tests pass | Browser memory is truth, hidden transition, notification equals completion, first failure overwritten, unauthorized phase continues |
| 18 | **B05-018 — Accept canonical audit ADR-B05-013 through 017** | Architecture forum records one typed ledger, transaction composition, streams, canonicalization/Merkle prototype profile | 4–17 | No unresolved schema/source-of-truth conflict | Portal audit projection becomes separate truth, native DB log selected as primary, external post-commit log required for transaction |
| 19 | **B05-019 — Implement canonical audit taxonomy and pure event builder** | Closed event families/types/change profiles, deterministic draft from trusted context and actual mutation plan, forbidden-field analyzers | 4–18 | Contract/privacy/canonical vectors pass | Free-form details/message, raw request/exception/selector/secret, caller actor/realm/result authority |
| 20 | **B05-020 — Implement audit relational schema, stream head, and immutable grants** | Engine-neutral logical DDL plus PostgreSQL/SQL Server candidate migrations; least-privilege application/admin roles; append-only constraints | 18–19, Batch 04 DB adapters | Schema/constraint/role tests pass in both candidates | Runtime update/delete/truncate, nullable/ambiguous scope, sequence/head not transactional, engine semantics silently diverge |
| 21 | **B05-021 — Compose final authorization + mutation + decision + audit + job/outbox transaction** | One command repository/transaction guard, failpoint hooks, stable commit reconciliation | 6–20 | E05-11/12 pass against both candidates for representative commands | Effect without decision/audit, success audit without effect, partial head/job/outbox, duplicate after ambiguity |
| 22 | **B05-022 — Implement audit query projection and access model** | Fixed typed filters, realm/global/case scope, versioned redaction, view-time actor display, pagination/cursor, audit-access events | 12–21 | E05-13/14 audit-query subset passes with fictional records | Arbitrary SQL/full text/field selection, source event edit, cross-realm result, unaudited sensitive query |
| 23 | **B05-023 — Implement audit-before-disclose gate** | Result buffering/spooling, access/completion event transaction, post-commit serializer/release, discard/revoke cleanup | 21–22 | E05-13 passes for sensitive read/audit search/local export fixtures | Any protected byte/retrieval capability released before audit commit, direct object bypass, artifact residue after failure |
| 24 | **B05-024 — Implement governed export and support-bundle prototype** | Fixed export/support profiles, manifest, scan, encryption candidate, one-use retrieval, expiry/revoke/delete, limitation states | 17, 21–23, Batch 03/04 safe support/lifecycle | T1 E05-13/14/28 subset passes | Generic table export, formula/script content, arbitrary destination/file/dump, secret/raw activity, false recipient deletion claim |
| 25 | **B05-025 — Implement independent canonical verifier** | Separate project/process/build, read-only DB adapter, independent canonicalization/hash/tree/checkpoint validation, finite findings | 18–21 | E05-15/16 passes against tamper corpus | Verifier imports production canonicalizer as sole logic, trusts stored hash/head, auto-repairs, cannot classify gap/fork/alter |
| 26 | **B05-026 — Implement lab checkpoint signer/store and status importer** | Purpose-separated lab key, immutable object versions, previous checkpoint digest, idempotent publication, authenticated local status cache | 25 | E05-17/18 mechanism passes; production independence remains false | Shared product key/admin/delete authority, mutable “latest” only, local pass substitutes for external state, same backup restores verifier |
| 27 | **B05-027 — Implement verification safety holds and no-self-clear** | Realm/global hold state, current/fresh checkpoint obligations, explicit incident/recovery transition, alerts outside product plane | 25–26 | E05-16/18/29 passes | Ordinary admin clears fail/stale, hidden feature bypass, synthetic event repairs history, first failure lost |
| 28 | **B05-028 — Implement segment sealing and retention mechanics** | Contiguous immutable segments, Merkle roots, checkpoint publication work, whole-segment eligibility, hold/export predicates, destruction evidence | 20–27 | E05-15/19 mechanism passes with T1 periods | Row-level edit/prune, uncheckpointed prune, hold bypass, indefinite retention hardcoded, ordinary admin purge |
| 29 | **B05-029 — Integrate accessibility semantics into the component contract** | Native HTML primitives, focus/status/error/timeout/table/dialog/notification requirements, lint/automated tests with positive controls | 10, 15–17, 22–24 | E05-23 passes on component and route fixtures | Critical issue, positive-control miss, custom inaccessible widget, color-only/silent status, inaccessible timeout/authentication |
| 30 | **B05-030 — Complete critical T1 workflows end to end** | Realm switch, denial, JIT, approval, preview/execute, job recovery, audit query, export, integrity hold, restore status, break-glass fixture | 13–29 | E05-24/25 pass for candidate browser/AT matrix and synthetic personas | Any critical task inaccessible/misleading, direct DB/detail needed, realm/scope/impact unclear, unsafe workaround |
| 31 | **B05-031 — Run framework/design-system/BFF dependency bake-off** | Exact same workflow implementations, SBOM/license/security/accessibility/performance/removal comparison; one/no winner | 29–30 | E05-26 produces accepted dependency record or standards-first local decision | Selection before hard tests, license/provenance gap, critical regression, unbounded closure, no removal/support owner |
| 32 | **B05-032 — Implement closed notification, integration, lifecycle, and diagnostics administration fixtures** | Registered revisions, secret references, fixed destinations/actions, truthful limitations, safe notifications, no arbitrary channels | 17, 21–24, 29–31 | E05-28 passes T1 mechanism | SSRF/arbitrary URL/header/path/script/file/command, secret to browser, notification becomes authority, false completion |
| 33 | **B05-033 — Implement break-glass and offline recovery mechanism in isolated T1** | Disabled fixed profile, independent lab identity/key/quorum fixture, recovery-only commands, hard expiry/revoke, alert, post-review | 13–27, 29–30 | E05-22 passes mechanism; no production activation | Universal bypass, self-activation, detail/export, no expiry/alert/audit/checkpoint, normal portal/DB is sole recovery |
| 34 | **B05-034 — Compose Batch 04 restore with authorization/audit continuity** | Old-backup isolated restore, current grants/revocations/purposes/tombstones/receipts/checkpoints, rebuild, negative/positive probes, separate read enable | 21–28, 33, Batch 04 lifecycle prototype | E05-21 passes one exact engine/topology/release profile | Restored stale authority active, deleted data visible, acknowledged effect missing, audit gap accepted, pre-ready read/egress/mutation |
| 35 | **B05-035 — Run native database supplemental audit comparison** | SQL Server Ledger/Audit and PostgreSQL pgAudit/direct-admin profiles, privacy/volume/failure/restore/ops evidence | 20–28, Batch 04 DB candidates | E05-20 records conditional value/limitations without changing canonical audit | Native logs selected as primary, sensitive SQL leakage, fail-open default ignored, unowned feature/edition/license |
| 36 | **B05-036 — Run performance/contention/cardinality characterization** | Open-arrival and hot-realm tests for session/authz/command/audit/query/seal/verifier/browser; generator self-proof | 21–35 | E05-27 produces bound scenario evidence with zero hard failures | Correctness/privacy/accessibility failure, starvation, hidden generator saturation, audit disabled for score, unbounded series |
| 37 | **B05-037 — Exercise all mandatory incident/support runbooks** | First-failure, hold, alert, recovery, re-enable, cleanup evidence for threats in section 8 | 21–36 | E05-29 passes for every blocking runbook and owner function | Direct DB/raw activity workaround, self-clear, evidence overwrite, inaccessible recovery, unassigned owner, residue |
| 38 | **B05-038 — Record production-scope human decisions** | Signed/approved purpose, role, approval/SoD, access, retention, verifier, key, accessibility, support, SLO/RPO/RTO, ownership records | Technical mechanisms sufficiently understood; may begin earlier as workshops | Every capability/workflow has exact accountable authority and conservative disabled default lifted only explicitly | Missing owner/purpose/access/retention/verifier/break-glass/accessibility/support decision; technical test cannot substitute |
| 39 | **B05-039 — Accept remaining ADR-B05-018 through 034 for exact candidate** | Architecture/technology/human-policy records reconcile with tested artifacts and predecessor ADRs | 25–38 | No unresolved contradiction; exact decisions map to evidence and owners | Silent technology selection, version drift, predecessor conflict without change proposal, unaccepted residual risk |
| 40 | **B05-040 — Clean-room aggregate gate replay** | Locked build, E05-30 machine gate, all evidence roots, SBOM/provenance, accessibility/restore/break-glass/manual results, cleanup | 1–39 and required predecessor gates | `B05_TECHNICAL_PASS=true`, owners/decisions/ADRs current, no residue | Any hard failure, stale/mismatched evidence, blocking decision, hidden dependency, cleanup failure |
| 41 | **B05-041 — Separate pilot/production decision** | Exact candidate release/topology/realm/purpose/role rollout, residual-risk acceptance, support/incident capacity, rollback/kill, monitoring and review plan | 40 | Designated human authorities explicitly approve exact scope | No authority, expired evidence, changed release/profile, unresolved residual risk; technical gate alone is insufficient |

## 10.3 Phase stop gates and permitted parallelism

### Phase A — contracts and pure authority (`B05-001` through `B05-007`)

**GO:** pure models, schemas, catalogues, fixtures, oracles, architecture checks, and dependency/source review.

**STOP:** no web server or UI route may become a production candidate until the executable-action catalogue is complete. Failure of strict contracts or canonicalization stops every downstream audit, authorization, and workflow claim.

### Phase B — read-only browser/session/realm (`B05-008` through `B05-010`)

**GO:** synthetic authentication, session, active-realm switching, read-only fictional aggregate screens, semantic HTML, page-state scaffolding.

**STOP:** any token escape, CSRF, stale session, browser authority, or cross-realm result stops all state-changing endpoint work. UI styling/design-system comparison may continue only against static fictional data.

### Phase C — authorization and temporary authority (`B05-011` through `B05-014`)

**GO:** fictional role/JIT/approval/service-identity mechanics and negative tests.

**STOP:** no production role mapping; no sensitive/detail/export capability; any default allow, self-grant, expired/revoked commit, or job authority leak stops command integration.

### Phase D — command/workflow safety (`B05-015` through `B05-017`)

**GO:** T1 previews, commands, idempotency, jobs, state machines, pause/kill/rollback/recovery.

**STOP:** no command that lacks preview/version/idempotency/audit semantics for its risk class; generic CRUD or stale-preview execution stops all privileged workflow integration.

### Phase E — canonical transactional audit (`B05-018` through `B05-024`)

**GO:** dual-engine T1 schemas and failpoints, audit query projections, local encrypted fictional exports/support bundles.

**STOP:** any privileged effect without required decision/audit, success audit without effect, disclosure before audit, forbidden-value escape, or retry duplicate stops the batch. External verifier work may continue independently but cannot compensate for a failed transaction core.

### Phase F — independent verification and retention mechanics (`B05-025` through `B05-028`)

**GO:** isolated verifier, lab key/account/object store, tamper corpus, safety holds, whole-segment retention fixtures.

**STOP:** no privileged production claim while verifier/anchor owner, separation, key, freshness, and incident response are unassigned; any required tamper survivor or self-clear stops audit-access and production-administration work.

### Phase G — accessibility, usability, and replaceable UI technology (`B05-029` through `B05-032`)

**GO:** automated/manual T1 workflow testing and same-contract technology bake-off.

**STOP:** a critical accessibility failure blocks the affected workflow, not merely its conformance statement. Direct DB, raw detail, or a parallel inaccessible emergency page is not an acceptable workaround.

### Phase H — emergency recovery, restore, engine supplement, and operational proof (`B05-033` through `B05-037`)

**GO:** lab-only break-glass, old-backup restore, native audit comparison, open-arrival measurement, incident drills.

**STOP:** no production break-glass, restored read enablement, native audit reliance, or capacity promise. A failure remains a scope restriction or ADR issue; it does not authorize weakening realm, audit, accessibility, or restore controls.

### Phase I — governance, aggregate gate, and separate production authority (`B05-038` through `B05-041`)

**GO:** accountable human workshops may proceed throughout the project using the exact technical catalogue and fictional examples.

**STOP:** production remains disabled until every required human decision is recorded for the exact candidate. Passing B05-AGG is necessary but not sufficient for pilot/production approval.

## 10.4 Work that may proceed in parallel

After B05-004/B05-005 are stable, these streams may proceed independently, provided they share the exact contracts and do not assume another stream has passed:

- pure authorization evaluator and route inventory;
- same-origin BFF protocol/session prototype;
- aggregate portal semantic shell and accessibility component tests;
- command/idempotency/job models;
- canonical audit/hash/Merkle pure models;
- independent verifier implementation;
- PostgreSQL and SQL Server T1 schema adapters;
- human role/purpose/accessibility/audit workshops using fictional task descriptions;
- OSS/design-system/source review;
- restore and break-glass runbook drafting.

Integration is allowed only when the prerequisite gate has passed. Parallel code is not parallel evidence: one stream cannot cite another stream's unexecuted design as proof.

## 10.5 Smallest safe vertical slice

The first integrated slice SHOULD be intentionally non-destructive and fictional:

```text
one synthetic IdP
one fictional realm plus a cross-realm twin
one aggregate fleet-health read model
one low-risk draft command that changes a fictional non-sensitive label/class
one immutable preview and If-Match version
one fictional two-person approval profile
one same-transaction authorization decision + business revision + audit event
one audit query available to a separate fictional reviewer
one independent segment/checkpoint verification
one keyboard/screen-reader complete workflow
one response-loss retry and one old-backup restore test
```

The slice fails if it uses direct database administration, activity/person detail, a generic editor, browser authority, post-commit logging, an unverified restored audit head, or an inaccessible approval/recovery path. Passing the slice authorizes the next T1 workflow only; it does not authorize live data or production administration.


---

# 11. Source and open-source quality corrections

## 11.1 Corrections to claims and authority

| ID | Supplied overlap or claim risk | Evidence-quality correction | Consolidated use in this review |
|---|---|---|---|
| S05-01 | The OAuth browser-application document can be cited as if it were a completed standard. | The reviewed document is IETF Internet-Draft `draft-ietf-oauth-browser-based-apps-27`, dated 6 July 2026. It is work in progress and may change. RFC 9700, published January 2025, is the stable OAuth 2.0 security BCP. | Use RFC 9700 as stable security guidance and the browser-app draft as current design input, not normative proof that one BFF implementation is correct. |
| S05-02 | A same-origin BFF can be presented as secure because current guidance recommends the pattern. | Guidance establishes patterns and threat considerations, not UAM token containment, realm authority, logout, CSRF, IdP interoperability, or operations. | BFF is accepted because it is the smallest architecture compatible with predecessor invariants; E05-04 is the UAM proof. |
| S05-03 | ASP.NET Core authorization/authentication primitives can be mistaken for the UAM authorization system. | Framework handlers, policies, cookies, antiforgery, and OIDC support mechanisms; they do not define UAM realm, purpose, target, JIT, approval, output, workflow, audit, or restore semantics. | ASP.NET Core is an expected platform primitive after exact-version admission, not the decision oracle or durable audit authority. |
| S05-04 | WCAG 2.2 is sometimes dated 5 October 2023 without identifying the currently reviewed publication. | The current W3C Recommendation page reviewed for this batch is dated 12 December 2024. The older date identifies the original WCAG 2.2 Recommendation history. | Record the exact reviewed publication date; target Level AA; prove complete workflows with automated and manual evidence. |
| S05-05 | An automated accessibility scanner or conforming design system can be treated as WCAG conformance. | WCAG is a standard; scanners and component libraries cover subsets and can miss context, focus, status, authentication, error recovery, cognition, and task completion. | E05-23 is supporting automation; E05-24/25 manual workflow execution is mandatory. No formal conformance claim is made by this research. |
| S05-06 | EN 301 549 V4.1.0 can be cited as the current final European accessibility standard. | ETSI listed V4.1.0 (2026-06) as `On Approval` on the reviewed Human Factors page. The current published edition remains EN 301 549 V3.2.1 (2021-03) at the research date. | Re-evaluate after final publication; do not harden an on-approval draft mapping into the architecture. |
| S05-07 | RFC 9457 or RFC 9110 can be treated as UAM business error/concurrency semantics. | They define generic HTTP problem details and conditional request semantics, not safe error fields, realm concealment, command idempotency, approval, or workflow state. | Reuse the standards' wire semantics inside stricter UAM contracts and tests. |
| S05-08 | JCS can be treated as a universal canonicalization and Unicode-normalization solution. | RFC 8785 is Informational, depends on I-JSON/ECMAScript number/string serialization rules, rejects/limits some inputs, and preserves parsed string code points rather than normalizing them. | JCS is one candidate profile behind strict parse and field semantics; independent vectors and explicit null/number/Unicode rules remain blocking. |
| S05-09 | RFC 9162 Merkle structures can be treated as proof that UAM's whole audit architecture is correct. | RFC 9162 specifies Certificate Transparency v2 structures/proofs under a different public-log ecosystem. It does not provide UAM mutation atomicity, event taxonomy, realm isolation, retention, or verifier ownership. | Reuse domain-separated leaf/node and tree-size concepts with UAM-specific vectors and state machines. |
| S05-10 | RFC 3161 timestamps can be treated as legal admissibility or non-repudiation. | RFC 3161 specifies a time-stamp protocol. Legal effect, trust anchors, qualified providers, retention, and evidentiary sufficiency are jurisdictional/human decisions. | Keep trusted-time service optional and human-gated; never claim signature/timestamp alone proves truth or legal status. |
| S05-11 | SQL Server Ledger may be described as preventing all database/host-administrator tampering. | Microsoft documents cryptographic ledger structures and digest verification, but also explains that an attacker controlling the machine can bypass local database checks; independently protected database digests are what enable later detection. | Conditional defense in depth only if SQL Server is selected; external UAM checkpoints and typed event semantics remain mandatory. |
| S05-12 | SQL Server Audit may be described as fail-closed by default. | `CREATE SERVER AUDIT` supports `ON_FAILURE = FAIL_OPERATION`, but the default is `CONTINUE`, which permits the audited operation while audit can be lost. Edition/topology/target behavior and operations must be tested. | Supplemental direct-DB backstop only under an exact explicit configuration and failure campaign. |
| S05-13 | pgAudit may be described as transactional authoritative business audit. | pgAudit emits PostgreSQL audit log records through the standard logging facility; project documentation warns about large volume, major-version coupling, and current development documentation characterizes logging as best effort/nontransactional. | Conditional direct-SQL/DDL/session backstop only. It cannot satisfy mutation-plus-audit atomicity or UAM purpose/approval/change semantics. |
| S05-14 | A hash chain, signed checkpoint, Ledger digest, transparency proof, or immutable database can be called non-repudiation or proof that an action occurred truthfully. | Those mechanisms authenticate/relate bytes and key use within their trust models. They do not establish completeness, semantic truth, lawful purpose, human intent, or exclusive key control. | Use `tamper evidence`, `integrity verification`, and `independent checkpoint`; reserve legal/evidentiary claims for HD05-23. |
| S05-15 | P20's “external immutable archival is optional and later” can be read as allowing local-only privileged production audit. | P20 focused on portal workflow and treated the relational transaction as the logical rule; P21 directly analyzed the DBA/host threat and external verification. The narrower load-bearing conclusion is stronger. | External checkpoints are optional for local transaction prototypes but a prerequisite before privileged production administration. |
| S05-16 | P20's portal `uam.audit.privileged-event` example and P21's `AuditEventV1` can become separate schemas. | The P20 example is a screen/API illustration and lacks the canonical stream/hash/segment fields and full taxonomy. | P21-derived typed ledger is canonical; portal read models project its permitted fields. |
| S05-17 | P19 authorization decision logging and P21 audit can become independent, asynchronously correlated logs. | The accepted privileged invariant requires final authorization, mutation, and audit to agree atomically. | `AuthorizationDecisionV1` is a typed record linked in the same transaction to the business effect and `AuditEventV1`; operational decision telemetry is secondary. |
| S05-18 | Repository popularity, active releases, a security policy, or upstream tests can establish UAM fitness. | These are source-quality inputs only. UAM must prove exact semantics, realm, privacy, accessibility, transaction, restore, operations, licensing, and removal. | Every repository remains reference/candidate until the admission checklist and E05 tests pass. |
| S05-19 | Absence of a repository `SECURITY.md` can prove no vulnerability-reporting process exists. | It is a negative observation about the reviewed repository surface, not proof that the project has no private reporting route or organizational process. | Treat it as weaker discoverability/support evidence and require an explicit security/advisory contact before dependency admission. |
| S05-20 | A point version current on 1 August 2026 can become timeless architecture. | Versions, patches, advisories, licenses, maintenance status, browser/AT behavior, and managed-service features change. | Record exact review points below; select and reverify supported versions at execution/release time under ADR-B05-033. |
| S05-21 | OPA's fixed Compile API SQL-injection issue proves OPA is generally unsafe or unsuitable. | The fix demonstrates active maintenance and a concrete risk in translating a general policy language into query logic; it does not by itself condemn all OPA uses. | OPA remains reference-only because UAM does not need the language/service surface and SQL translation cannot be the sole row boundary. |
| S05-22 | Upstream product UI improvements or defects prove a design system/product is accessible or inaccessible overall. | Individual release notes provide useful regression cases, not complete conformance or product fitness. | Reuse test cases; run the exact UAM component/workflow matrix. |
| S05-23 | Trillian/Rekor/immudb “production” or “immutable” claims can justify adoption. | Their transaction boundaries, data models, public/private threat assumptions, operations, and lifecycle differ; Trillian and Rekor v1 have explicit maintenance/successor context. | Reference patterns only; no primary audit dependency. Tessera is the first optional transparency spike if a trigger arises. |
| S05-24 | A database-engine-native feature comparison can select the production engine within Batch 05. | Batch 04 deliberately keeps the PostgreSQL/SQL Server decision open pending identical semantic, load, restore, operations, skills, licensing, and TCO evidence. | Batch 05 supplies an identical audit semantics test to both; it does not select the engine. |

## 11.2 Stable primary source register for load-bearing current claims

| Ref | Primary source, reviewed date/version | Claim supported | Limitation |
|---|---|---|---|
| **W05-01** | [RFC 9700 — Best Current Practice for OAuth 2.0 Security](https://www.rfc-editor.org/rfc/rfc9700), January 2025 | Current stable OAuth security BCP; deprecations and attack mitigations relevant to authorization-code/OIDC integrations | Does not prescribe UAM realm/capability/audit architecture or prove an implementation |
| **W05-02** | [OAuth 2.0 for Browser-Based Applications, draft-ietf-oauth-browser-based-apps-27](https://datatracker.ietf.org/doc/draft-ietf-oauth-browser-based-apps/), 6 July 2026 | Current browser-app/BFF design and threat guidance at research date | Internet-Draft, work in progress; not a completed standard |
| **W05-03** | [Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/), W3C Recommendation 12 December 2024 | Stable accessibility success criteria and Level AA target | Conformance requires content/workflow evaluation; automated tools alone are insufficient |
| **W05-04** | [WAI-ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) and [First Rule of ARIA](https://www.w3.org/TR/using-aria/#rule1) | Reference patterns and preference for native HTML semantics | Examples are not automatic conformance or a substitute for user-agent/AT testing |
| **W05-05** | [ETSI Human Factors / accessibility standards status](https://www.etsi.org/technologies/human-factors), reviewed 1 August 2026 | Published EN 301 549 V3.2.1 and V4.1.0 status context | V4.1.0 was `On Approval`, not final at review time; legal mapping remains human-owned |
| **W05-06** | [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457), July 2023 | Standard problem-details envelope | UAM safe codes, concealment, retry, audit, and workflow semantics are additional |
| **W05-07** | [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110), June 2022 | Validators and `If-Match` conditional request semantics | Does not replace domain revision, preview, command idempotency, or audit |
| **W05-08** | [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785), June 2020 | One deterministic JSON canonicalization profile | Informational; number/I-JSON/Unicode constraints; no normalization; UAM vectors still required |
| **W05-09** | [RFC 9162 — Certificate Transparency Version 2.0](https://www.rfc-editor.org/rfc/rfc9162), December 2021 | Domain-separated Merkle leaf/node and proof concepts | CT threat/model/operation differs from private UAM audit and does not provide transaction atomicity |
| **W05-10** | [RFC 3161 — Time-Stamp Protocol](https://www.rfc-editor.org/rfc/rfc3161), August 2001 | A standard protocol for cryptographic time-stamp tokens | Does not decide trusted provider, legal status, key custody, retention, or UAM need |
| **W05-11** | [SQL Server Ledger overview](https://learn.microsoft.com/en-us/sql/relational-databases/security/ledger/ledger-overview?view=sql-server-ver17), reviewed page updated 7 August 2025 | SQL Server 2022+ ledger capabilities, digests, and threat/verification boundaries | Engine/edition/topology-specific; not UAM typed semantics; local machine control can bypass checks |
| **W05-12** | [CREATE SERVER AUDIT (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-server-audit-transact-sql?view=sql-server-ver17), reviewed page updated 21 July 2026 | `ON_FAILURE` choices including `FAIL_OPERATION`; default `CONTINUE` | Exact target/failure/edition/HA behavior and UAM privacy/volume require lab proof |
| **W05-13** | [pgAudit repository](https://github.com/pgaudit/pgaudit) and [18.0 tag](https://github.com/pgaudit/pgaudit/tree/18.0), release 24 September 2025, commit `f39f8db` | PostgreSQL session/object audit extension, tests, major-version coupling and volume considerations | Text logging is not UAM mutation-audit transaction or typed business semantics; current behavior/config must be measured |
| **W05-14** | [ASP.NET Core v10.0.10 source](https://github.com/dotnet/aspnetcore/tree/v10.0.10), release 15 July 2026, tag commit `2adedfc` | Current reviewed .NET BFF/authentication/authorization/antiforgery platform source | Exact supported runtime at execution may differ; framework primitives do not prove UAM semantics |

## 11.3 Consolidated open-source repository review

The table below audits every repository recommendation in I01–I03. A stable tag/commit is necessary but not sufficient. `REFERENCE` means ideas/tests may be reused; `CANDIDATE` means a later exact admission/bake-off is allowed; neither means approved production dependency.

| Repository and immutable review point | License / maintenance / security / test quality | UAM fit and principal risk | Consolidated classification and correction |
|---|---|---|---|
| **ASP.NET Core** — `v10.0.10`, 15 July 2026, commit `2adedfc` | MIT; Microsoft-supported line; extensive source/tests/security servicing; exact transitive/runtime inventory still required | Direct fit for C# BFF, cookies, OIDC, authorization handlers, antiforgery. Does not supply UAM catalogue, realm, JIT, data-shape, transaction, or audit semantics. | **EXPECTED PLATFORM PRIMITIVE / DEPENDENCY CANDIDATE.** Admit exact runtime/packages at execution; retain UAM-owned kernel and tests. |
| **Open Policy Agent** — `v1.19.0`, 30 July 2026, commit `1e32c796e8979b1bda2f768138500b1deb95ff24` | Apache-2.0; active; broad tests/conformance/security process; reviewed release fixed Compile API SQL injection | General Rego, bundles, external data, service/WASM, decision logs, and partial-eval/SQL surfaces exceed need and introduce authority/availability/operations risk. | **REFERENCE ONLY.** Reuse corpus/unknown/config/fuzz ideas. No tenant Rego or initial PDP dependency. |
| **Cedar** — `v4.12.0`, 28 July 2026, commit `fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5` | Apache-2.0; active; parser/validator/evaluator/symbolic tests and security reporting | Strong typed principal/action/resource ideas; Rust/WASM/FFI and policy/entity model do not directly provide UAM purpose/output/workflow/audit. | **REFERENCE / OPTIONAL TEST COMPARATOR.** No initial runtime dependency or unrestricted policy language. |
| **OpenFGA** — `v1.18.1`, 29 June 2026, commit `69efbd95b3d44afb2e2567d485dcc792c7d79e3f` | Apache-2.0; active tests/release automation/provenance | Adds relationship store, consistency, API, backup/restore, and second authorization truth for shallow first-slice relations. | **REFERENCE ONLY.** Reconsider only after measured graph depth/volume and full consistency/restore/TCO gate. |
| **SpiceDB** — `v1.56.0`, 24 July 2026, commit `8422483147151728d39c47b439b5ed8090966d48` | Apache-2.0; active; broad datastore/integration/security tests | Rich ReBAC/caveats and consistency surface; remote/embedded Go engine cannot replace transaction-local closed UAM conditions. | **REFERENCE ONLY.** No tenant CEL/caveats or remote check as sole destructive authority. |
| **Cerbos** — `v0.54.0`, 20 July 2026, commit `6b40a5f9fa6305a7014a8ea274afefaaa7771679` | Apache-2.0; active compiler/E2E/load/security work | YAML/CEL, sidecar/embedded PDP, bundle/Hub and configuration surface are broader than first need. | **REFERENCE / LATER BAKE-OFF CANDIDATE** only after measured need; do not copy TLS bypass/general authoring. |
| **Teleport** — `v18.10.0`, 9 July 2026, commit `ddaa46b8f4ee579d43480cd2d3b6a14b18e3ef7d` | Mixed Apache/AGPL/commercial terms; very active security product with extensive tests | Valuable JIT/access-request/revocation patterns, but infrastructure proxy/session/credential architecture and licensing are far larger/different. | **REFERENCE ONLY.** No code/dependency without path-specific legal review; do not infer infrastructure JIT solves UAM data-purpose authorization. |
| **oauth2-proxy** — `v7.15.3`, 9 June 2026, commit `66b3a17db09f0b51a4bc3159d4c7fe3fbeca1288` | MIT; active integration/security fixes | Authentication reverse proxy does not implement server-side UAM BFF semantics, realm/capability, mutation transaction, or audit. Header/session trust adds another boundary. | **REFERENCE ONLY.** Use hostile provider/header/cookie tests; not the core BFF or final authority. |
| **Duende BFF** — `4.2.0` source point, 10 June 2026, commit `de013a7802cb49e7584eeebcabb1a9d511ccef8c` | Source-available/commercial; dedicated BFF source/tests/support; production license generally required subject to terms | Very close session/token pattern but still lacks UAM domain authorization. Adds commercial lifecycle, migration, session-store and procurement considerations. | **COMMERCIAL CANDIDATE / REFERENCE.** Compare exact version against built-in ASP.NET Core via E05-26; no automatic selection. |
| **PatternFly React** — `v6.6.0`, 28 July 2026, commit `6f2385b` | MIT; current release/test/examples; trademark/assets separate; upstream security-policy evidence not load-bearing | Strong dense admin components and accessibility examples; integrated UAM focus, realm, bulk safety and workflows unproved. | **DESIGN-SYSTEM CANDIDATE** after E05-26; exact packages/assets/transitives and recurring AT tests required. |
| **Fluent UI** — release cluster 26 May 2026, representative `@fluentui/react-tree_v9.16.1`, source rev `9317e51` | MIT source; fonts/icons separate terms; active fine-grained packages/tests | Useful Microsoft familiarity, focus/ARIA/dialog/table/tree primitives; package closure/version coordination can be large. | **DESIGN-SYSTEM CANDIDATE** after E05-26; pin minimum package closure, reject preview/compat packages unless admitted. |
| **Carbon Design System** — `v11.113.0`, 30 July 2026, commit `a57cf8a89` | Apache-2.0; active; NOTICE/trademark/assets review; broad packages/tests | Useful admin components/tokens; design-system feature flags must not become UAM authority. | **DESIGN-SYSTEM CANDIDATE** after E05-26; reference only until exact accessibility/security/bundle/removal proof. |
| **Fleet** — `fleet-v4.89.2`, 24 July 2026, commit `89b1cb5` | Mixed MIT/CC BY-SA/separate enterprise paths; active endpoint-management release/tests | Useful fleet health/status/error patterns; broad host/query/software-management/detail authority conflicts with minimized UAM. | **REFERENCE ONLY.** Reuse truthful state/failure lessons; no raw query/detail/product architecture. |
| **Argo CD** — `v3.4.6`, 31 July 2026, commit `e1becb7` | Apache-2.0; active; signed/provenance release practices and broad tests | Useful desired/observed diff, staged rollout, rollback/health UI; GitOps/Kubernetes authority differs. | **REFERENCE ONLY.** Do not copy auto-sync, repository plug-ins, cluster credentials, or Git-as-business-approval. |
| **Backstage** — `v1.53.1`, 29 July 2026, commit `eb8e4c0` | Apache-2.0; very active large plugin ecosystem/tests | Navigation/catalogue ideas, but plug-ins, names/relations, broad integrations and schema-warning behavior conflict with closed authority. | **REFERENCE ONLY; NOT PORTAL PLATFORM.** No plug-in marketplace or human-readable identity authority. |
| **Grafana** — `v13.1.1`, 21 July 2026, commit `a9cee6e` | AGPL-3.0; active and strong dashboard/accessibility regression experience; material network/source obligations | Useful aggregate/stale/alert/pagination patterns; arbitrary data-source/query/plugin model is not safe command administration. | **REFERENCE ONLY; DEPENDENCY NO-GO without Legal and new ADR.** Not mutation authority. |
| **Keycloak** — `26.7.0`, 9 July 2026, commit `6c73e30` | Apache-2.0; active security/standards tests | Useful realm/session/admin-console test patterns; it is an identity provider, not UAM domain/purpose/output authority. | **REFERENCE ONLY** unless separately selected as enterprise IdP by IAM; IdP roles remain non-authoritative inputs. |
| **Tessera** — `v1.0.4`, 16 July 2026, commit `6bca8e8` | Apache-2.0; active stable API, tests/fault/fsck/security policy; Go/storage drivers add operations | Strong tile/Merkle/checkpoint/witness patterns; separate log cannot atomically commit UAM business mutation and public-log assumptions differ. | **REFERENCE FIRST / OPTIONAL ISOLATED TRANSPARENCY SPIKE.** Not primary audit dependency. |
| **Trillian** — `v1.7.3`, 30 March 2026, commit `16c60b3` | Apache-2.0; maintained/tests/security intake; official docs recommend Tessera for new logs | Mature sequenced Merkle concepts but larger Go/gRPC/storage/election server and maintenance status. | **REFERENCE ONLY; NEW DEPENDENCY REJECTED.** |
| **Witness** — pseudo-version `v0.0.0-20260720115447-2e1c6971d19e`, commit `2e1c6971d19e`, 20 July 2026 | Apache-2.0; active code/tests; no stable tag and no repository security policy observed at review | Valuable tiny independent checkpoint/cosigning state; untagged support/pinning and first-trust/owner issues. | **REFERENCE / BOUNDED T1 PROTOTYPE ONLY.** No production dependency until stable/admitted and independent owner exists. |
| **Rekor v1** — `v1.5.3`, 2 July 2026, commit `7d9dcff` | Apache-2.0; signed/e2e/security activity; v1 maintenance while newer tile architecture develops | Useful proof/evidence CLI patterns; public supply-chain log, extensible entries, URL/key fetch and Trillian stack differ and expose privacy risk. | **REFERENCE ONLY; UNSUITABLE FOR NEW PRIVATE AUDIT DEPENDENCY.** |
| **immudb** — `v1.11.1`, 26 June 2026, commit `37ebcef` | Apache-2.0; active tests/security policy; latest-only security support; recent crash/correctness fixes show lifecycle risk | Verified database ideas are useful, but a separate DB creates dual-write atomicity, backup/HA/skills/support/migration surface. | **REFERENCE / ISOLATED LAB ONLY; REJECT AS PRIMARY OR DEFAULT.** |
| **pgAudit** — `18.0`, 24 September 2025, commit `f39f8db` | PostgreSQL License; regression tests; major-version coupling; no repository security policy observed; large log volume | Direct session/object/DDL/DML evidence only; statement logs may leak and are not same-transaction UAM business audit. | **CONDITIONAL SUPPLEMENTAL CANDIDATE** only if PostgreSQL is selected and E05-20 passes. |

## 11.4 Open-source and dependency admission checklist

No repository or package may become a release dependency unless one immutable admission record contains:

1. exact tag and full commit; source archive digest; package/image/binary digest; reproducible source-to-binary mapping or an explicit independently verified supplier attestation;
2. license, notices, trademarks/assets/fonts/icons, transitive licenses, commercial/EULA/managed-service terms, export/compliance and procurement approval;
3. supported runtime/OS/browser/database range, maintenance policy, release cadence, security-support horizon, advisory/reporting channel, current relevant vulnerabilities, and update owner;
4. source directories and features actually used; disabled/removed features; configuration/schema/bundle identities; no mutable online discovery or runtime code/policy download;
5. unit/integration/conformance/fuzz/accessibility evidence and UAM positive/negative/cross-realm/privacy/fault/restore tests for the exact feature set;
6. least privilege, network/data/secret access, telemetry/logging, storage/backup, key, tenancy, cache, and failure-mode threat review;
7. no broadening of tenant or operator authority and no replacement of UAM final transaction, realm, output, audit, or restore checks;
8. performance/capacity/cardinality and failure-recovery evidence under the exact intended topology;
9. accessibility/browser/AT evidence for every user-facing component and no unsupported custom semantics;
10. install/upgrade/rollback/removal/migration/backup/restore/incident/cleanup runbooks and an independently tested removal path;
11. accountable engineering, security, accessibility, legal/procurement, operations/support, and incident owner functions;
12. evidence expiry tied to version/advisory/incident/support lifecycle and same-digest promotion in the accepted release process.

A project with no stable tag MAY be used only in an isolated T1 reference spike at a full commit, never as a production dependency, unless Architecture, Security, Legal/Procurement, and Operations explicitly approve the additional lifecycle risk and every other gate passes.

## 11.5 Source-quality conclusion

**RECOMMENDATION.** The supplied results' architectural conclusions remain valid after the corrections above, with four important limits:

1. current standards and vendor features support mechanisms, not UAM-specific fitness;
2. external checkpointing is a production prerequisite, not an optional nicety, under the accepted database/host-administrator threat;
3. no general policy engine, admin platform, design system, transparency service, immutable database, or native audit feature is automatically admitted;
4. every exact version is a 1 August 2026 review point and must be reverified when an executable release is built.

No open-source recommendation passes directly to production from this review. ASP.NET Core is the expected platform primitive; PatternFly, Fluent, Carbon, and Duende BFF are conditional bake-off candidates; pgAudit and SQL Server native features are conditional supplemental controls; all other listed repositories are reference or isolated-prototype material.


---

# 12. Confidence by major conclusion and evidence that could change it

## 12.1 Confidence register

| Major conclusion | Confidence | Basis | Evidence that would change the conclusion or its scope |
|---|---|---|---|
| The browser must not be an authorization, realm, signing, persistence, or policy authority | **High** | Directly follows accepted authenticated-context, realm-isolation, privacy, and durable-audit invariants; every topic agrees. | A simpler client architecture proving equivalent token containment, realm derivation, field control, revocation, audit, restore, and accessibility under hostile tests. |
| A same-origin confidential-client BFF is the smallest safe initial browser boundary | **High** | Fits the modular monolith, avoids browser-held API tokens and broad CORS, and centralizes current realm/session/CSRF behavior. | Deployment evidence showing same-origin is infeasible plus an alternative passing E05-04/06 with lower total assurance/operations cost. |
| Server-side OAuth/OIDC tokens and an opaque browser session are required for the first control plane | **High** | Reduces token extraction and supports server-side revoke/realm/session state; current stable/draft guidance supports the pattern. | A non-token browser architecture or proof-bound alternative with equivalent browser-compromise, logout, accessibility, and operations evidence. |
| UAM requires a release-owned executable-action and response-field catalogue | **High** | Route/background/field completeness is necessary to prove deny-by-default behavior and prevent hidden commands/data. | A formally equivalent generated mechanism with complete build/runtime reconciliation and less drift risk. |
| Capability RBAC plus a small closed set of conditions is the correct first authorization model | **High** | UAM actions/resources are finite; pure RBAC is insufficient for realm/purpose/target/time/state/output, while general policy languages add unneeded authority. | Measured policy/relationship complexity or independently deployed services showing an alternative is smaller, more analyzable, and passes identical transaction/restore gates. |
| Identity-provider groups/roles, OAuth scopes, UI visibility, or database RLS cannot be final UAM authority | **High** | None represents the full UAM realm, purpose, target, output, state, approval, lifecycle, and audit decision. | No expected change to the final-authority conclusion; they may remain upstream/coarse/defense-in-depth signals. |
| One active realm per ordinary human session and an explicit separate product-global plane are required | **High** | Minimizes confused-deputy and cache risk and preserves realm-first predecessor invariants. | A specifically approved cross-realm workflow with minimum aggregate fields and a complete multi-realm authority/test contract; ordinary missing realm would still not mean global. |
| Purpose, exact target/scope, and output profile must be part of sensitive authorization | **High** | Capability alone cannot establish permitted use or minimum response; all three topic results converge. | A human decision that a named low-risk action needs no purpose/case; the catalogue would explicitly encode `NOT_REQUIRED`, not omit the mechanism. |
| Production role/persona assignments can be derived by technical research | **Low / not established** | Supplied evidence contains no actual authorized organizational roles, owners, duties, or purposes, and research lacks authority. | Recorded accountable mapping decisions plus representative task and separation-of-duty evidence. |
| JIT access is the appropriate default for high-risk detail, export, diagnostics, lifecycle, release, authorization administration, and break-glass | **Medium-High** | It reduces standing privilege and supports exact purpose/target/expiry/approval evidence. | A human risk/operations decision demonstrating a narrower standing grant is necessary and equally controlled, or evidence that JIT failure creates greater unacceptable risk. |
| Request, approval, activation, and grant must be distinct states bound by immutable digests | **High** | Prevents changed-content approval reuse, self-activation ambiguity, and hidden authority; directly testable. | A simpler state model proving identical separation, expiry, revoke, retry, and audit under concurrency. |
| Long-running jobs must reauthorize at claim and effect boundaries | **High** | Creation-time authority may expire/revoke or resource state may change before later effects. | A job model with all effects in one immediate transaction; otherwise no expected change. |
| Explicit read models and named commands are safer than generic CRUD/admin generation | **High** | UAM preview, scope, approval, audit, idempotency, rollback, deletion, export, and recovery semantics are action-specific. | A bounded framework proving every semantic, privacy, accessibility, recovery, and audit property with lower lifecycle risk. |
| Aggregate-first and no activity/person detail by default is the correct initial portal posture | **High** | Preserves minimization and avoids false productivity/forensic interpretation while purpose/access remain unresolved. | An approved purpose and exact minimum detail workflow that cannot be completed safely from aggregate/operational evidence, with consultation/access/retention/appeal tests. |
| “No data,” zero, stale, offline, unsupported, partial, suppressed, hold, and unknown must remain distinct | **High** | Collapsing them makes operational evidence misleading and can cause unsafe administrative decisions. | No expected architectural change; wording/thresholds may change through human/product evidence. |
| Preview, current version, stable command ID, reason, approval, final authorization, durable job, and audit are the reusable command pattern | **High** | Controls TOCTOU, stale updates, response loss, bulk scope, authority, and recovery. | A workflow-specific counterexample showing one element is unnecessary or another control is required; the command catalogue would record the exception explicitly. |
| Final authorization, business mutation, decision record, success audit, stream head, and required job/outbox must commit atomically | **High** | This is the direct implementation of the accepted privileged-audit invariant and avoids cross-system dual-write ambiguity. | A different single failure-domain mechanism proving identical all-or-nothing semantics and restore/replay behavior. |
| Audit operational logs, SIEM, SQL statement logs, or an external HTTP audit service cannot be the primary mutation evidence | **High** | They are separate/nontransactional boundaries and lack complete typed UAM semantics. | No expected change absent moving the business transaction to the same authoritative system, which would require a baseline change and migration proof. |
| Sensitive reads, audit searches, downloads, exports, and support releases require audit-before-disclose | **High** | Disclosure cannot be rolled back after bytes leave; the durable boundary must precede release. | A response mechanism that proves no protected byte/capability leaves before an equally durable access record. |
| One application-owned typed event taxonomy is required | **High** | Native statement logs cannot reliably express UAM actor authority, purpose, approval, target, minimized change, workflow, result, and privacy class. | A selected native engine mechanism demonstrating complete typed semantics without duplication and with engine-neutral migration—currently unlikely. |
| Realm/global per-stream sequence and hash chain are appropriate first-order integrity structures | **Medium-High** | They are simple, portable, deterministic, and independently verifiable; exact throughput/composition is untested. | Model counterexample, unacceptable measured hot-stream contention, or a simpler complete integrity structure. |
| Sealed Merkle segments and signed checkpoints are appropriate for independent verification | **Medium-High** | They permit compact external state and bounded recomputation while retaining typed local events. | A simpler checkpoint structure with equivalent gap/fork/rollback/restore proof, or an evidentiary regime requiring a different log/witness/timestamp profile. |
| Independently protected external checkpoints are required before privileged production administration | **High** | Local controls do not detect all database/host-admin alteration; external state changes the trust boundary and old-backup restore result. | A formally accepted threat model excluding those administrators, or another independently recoverable verification plane proving equivalent detection. |
| A dedicated transparency-log service is required initially | **Low** | Checkpoint volume appears small and no public discoverability, multi-party append, or witness requirement is approved. | Split-view/multi-party/regulator/customer verification requirement, scale/operations evidence, or cost proof favoring Tessera/witness over private immutable checkpoints. |
| SQL Server Ledger/Audit and pgAudit are supplemental, not authoritative | **High** | Engine-specific semantics and documented limitations do not supply UAM typed mutation audit or portable transaction truth. | A selected engine and exact paired evidence showing a native feature materially improves assurance; it would remain supplemental unless business semantics move into it. |
| Whole-segment pruning is the safest first audit-retention mechanism | **Medium** | It preserves retained-chain integrity and avoids source edits; production field-specific/legal needs are unknown. | Approved need for independent field expiry plus a tested encrypted-envelope/redactable commitment design that preserves verification and minimization. |
| Restores must reconcile current authorization and external audit state in addition to Batch 04 tombstones/receipts | **High** | Otherwise old backups can revive stale grants/approvals/break-glass or trust rolled-back audit. | A single independently current recovery substrate intrinsically containing all authorities and passing equivalent old-backup tests. |
| Break-glass should be fixed recovery-only, never a universal bypass | **High** | Emergency paths are highest risk and still need realm, minimization, audit, expiry, alert, and review. | No expected change; the exact recovery command set and authority are human decisions. |
| A safe production break-glass path is currently established | **Low / not established** | No custodians, keys, quorum, monitoring, staffing, or drill evidence exists. | HD05-17/26 decisions plus E05-22 and recurring independent drills. |
| WCAG 2.2 Level AA is the correct engineering target | **High** | Current stable W3C Recommendation and direct relevance to critical admin, status, input, authentication, focus, and error workflows. | Organizational/legal policy requiring stricter/additional criteria or an updated stable standard; never evidence for a weaker inaccessible path. |
| Automated accessibility testing alone can close the gate | **Low / rejected** | It cannot prove keyboard/AT task completion, status comprehension, cognitive safety, or integrated workflow behavior. | No expected change; better automation may reduce but not eliminate manual testing. |
| PatternFly, Fluent UI, Carbon, or any one framework/design system is the production choice | **Low / not established** | No exact UAM bake-off, AT matrix, dependency/license/security/removal result exists. | E05-26 and accountable architecture/accessibility/procurement decision. |
| ASP.NET Core built-in BFF primitives will be lower risk than Duende BFF | **Medium** | Smaller expected dependency/commercial surface, but implementation/support burden is unmeasured. | Exact E05-26 comparison showing Duende materially lowers defect/operations cost under acceptable license and migration terms. |
| Exact production authorization/audit latency, checkpoint cadence, retention growth, and capacity are known | **Low / not established** | No approved distributions, topology, objectives, retention, or open-arrival measurements exist. | HD05-38/39 decisions plus E05-27 on the exact selected profile and Batch 04 capacity evidence. |
| Administrative production use is ready | **Low / not established** | All Batch 05 technical aggregate gates and material human decisions are open. | E05-30/B05-AGG pass, current predecessor evidence, recorded human decisions, accepted ADRs, cleanup, and separate risk approval. |

## 12.2 Conclusions with the strongest evidence

The following may be recorded as architecture-level decisions with **High** confidence even while proof gates remain open:

- browser presentation and same-origin BFF/server authority separation;
- deny-by-default release-owned capabilities and closed conditions;
- authenticated realm and realm-first keys;
- explicit read/preview/command/job workflows with no generic mutation;
- final transactional authorization plus canonical typed audit;
- audit-before-disclose;
- independent external verification before privileged production use;
- aggregate-first/no-detail default;
- fixed recovery-only break-glass;
- complete-workflow accessibility as a hard gate;
- restore reconciliation of current authority and audit state.

These are architecture conclusions, not proof that the selected implementation satisfies them.

## 12.3 Conclusions that must remain provisional

The main technical baseline MUST continue to label these as **UNKNOWN**, **HUMAN DECISION**, **ESTIMATE**, **CLI EXPERIMENT**, or replaceable implementation choice:

- real users, roles, assignments, purposes, case/ticket sources, approval/quorum/SoD, JIT/step-up/session durations;
- detail, audit-access, export, diagnostic, lifecycle, integration, notification, and break-glass authority;
- audit event fields/change profiles, retention, holds, access, external checkpoint freshness, evidentiary/time requirements;
- identity provider, session store, database engine/edition/topology, native audit controls, KMS/HSM, checkpoint/WORM/witness technology;
- portal framework, design system, BFF dependency, exact browser/assistive-technology support matrix;
- performance, capacity, series budgets, SLO/RPO/RTO, staffing, budget, licensing, support, incident response, pilot, and production approval;
- all exact point versions and numeric thresholds.

---

# Residual risk, blocked dependencies, and exact baseline-update conditions

## Unresolved residual risks

1. **Human authority and misuse.** Correct technical authorization cannot prove that a purpose is lawful, an approver is independent, a decision is wise, or an allowed action will not be misused.
2. **Malicious or colluding privileged actors.** Product, database, host, verifier, cloud-account, key, incident, and legal/audit administrators can collude. A private internal checkpoint cannot eliminate a fully colluding trust domain.
3. **Semantic falsehood.** A malicious authorized release can write internally consistent but false/incomplete audit events; signatures and Merkle proofs do not prove real-world completeness or truth.
4. **Unanchored tail.** Events after the last independently protected checkpoint remain more exposed; the acceptable age/count/byte window and outage response are undecided.
5. **Identity and browser compromise.** A compromised IdP, browser, endpoint, or current session can exercise existing grants. Server-side tokens reduce extraction but do not make the browser trustworthy.
6. **Availability versus fail-closed safety.** Authorization-store, audit, verifier, IdP, database, KMS, checkpoint, accessibility, or restore failures can deny legitimate administration and create backlog or emergency pressure.
7. **Inference and secondary copies.** Audit metadata, aggregate rare populations, case links, exports, notifications, support evidence, backups, and recipient copies may remain sensitive even when raw activity is absent.
8. **Accessibility drift.** Browser, assistive-technology, framework, design-system, identity-provider, and localization updates can break critical workflows after a prior pass.
9. **Restore and lifecycle composition.** Old backups, stale sessions/grants, independent tombstones/checkpoints, recipient copies, and partial derived stores can diverge unless recurring joint restore drills remain current.
10. **Operational sustainability.** Independent verification, manual AT testing, key ceremonies, cross-realm negatives, incident drills, dependency admission, restore campaigns, and evidence renewal require unapproved staffing, budget, and on-call capacity.
11. **Legal/evidentiary limits.** No supplied evidence establishes lawful purpose, regulatory sufficiency, trusted-time profile, non-repudiation, chain-of-custody admissibility, retention, employee consultation, or production risk acceptance.
12. **Unknown scale and technology fitness.** Portal load, hot-realm audit contention, access/export distributions, retention growth, database behavior, checkpoint cadence, and exact technology operations are unmeasured.

## Blocked dependencies and authorities

The following are blocking for privileged production use:

- HD05-01 through HD05-42 as applicable to the exact intended scope, especially purpose, role/approval/SoD, detail/access/export, audit fields/access/retention, verifier/key/checkpoint owner, break-glass, accessibility policy, support, SLO/RPO/RTO, ownership, and production risk;
- B05-CATALOGUE, SESSION, REALM, PURPOSE, JIT, WORKFLOW, AUDIT-ATOMIC, AUDIT-ACCESS, AUDIT-VERIFY, ACCESSIBILITY, BREAKGLASS, RESTORE, OWNERS, and AGG;
- accepted predecessor gates for the exact release/topology, including Batch 04 database/lifecycle/restore evidence and any endpoint/server evidence the intended administrative workflow depends on;
- production database selection and exact engine-native control profile;
- production identity-provider/federation/session integration;
- production verifier, anchor/WORM/witness topology, signer/key custody, trusted-first-checkpoint and incident ownership;
- exact portal framework/design-system/BFF dependency selection, license/procurement/support, and recurring browser/AT matrix;
- exact operational objectives, capacity, monitoring, staffing, support, incident, backup/restore, and evidence-renewal programme.

## Exact conditions for updating the main technical baseline

### A. Architecture-level baseline update

The main technical baseline MAY incorporate this batch's architecture as **“accepted with mandatory conditions; Batch 05 gate open”** when all of the following are true:

1. the architecture forum accepts this review and records ADR-B05-001 through ADR-B05-034, or explicitly records equivalent decisions and their proof obligations;
2. no unresolved contradiction with Batch 01–04 accepted invariants exists; any future conflict has a formal change proposal naming the affected decision, new primary evidence, impact, smallest falsifying experiment, migration consequence, and ADR action;
3. the update includes only architecture invariants, not real roles/purposes/access/retention, exact technologies, numeric values, or production authority;
4. the update states that external independently protected audit checkpoints are optional for local transaction prototypes but mandatory before privileged production administration;
5. the update preserves the exact stop rule: one cross-realm authorization/data return, unaudited privileged effect, sensitive disclosure before audit, undetected required tamper, inaccessible critical workflow, out-of-profile break-glass action, restored stale authority, or cleanup failure blocks the affected release;
6. all provisional and human-owned matters in section 12.3 remain explicitly labelled and disabled by conservative default.

The architecture-level baseline may then add these consolidated statements:

- administrative browser use is mediated by a same-origin BFF and server-side session;
- UAM authorization is release-owned capability RBAC plus closed purpose/realm/target/time/state/approval/authentication/output/safety conditions;
- normal administration uses aggregate-first read models and explicit previewed/idempotent/audited commands, never generic database/row mutation;
- final authorization, business mutation, decision evidence, canonical typed audit, stream head, and required job/outbox state share one transaction;
- sensitive disclosure occurs only after durable access audit;
- realm/global audit streams are independently verifiable through chained events, sealed segments, and externally protected signed checkpoints;
- critical workflows target WCAG 2.2 AA and require automated plus manual assistive-technology evidence;
- break-glass is fixed recovery-only, disabled until approved and drilled;
- restore keeps reads/egress/mutation blocked until current authorization, lifecycle, custody, and audit authorities reconcile.

### B. Production-candidate technical baseline update

The baseline MAY mark one exact portal-governance implementation as **technically eligible for a separately authorized pilot/production decision** only when:

1. E05-30 reports `B05_TECHNICAL_PASS=true` for one exact product release, repository commit, artefact set, contracts, database engine/edition/topology, IdP/session profile, verifier/anchor/key profile, portal framework/design system, browser/AT matrix, and deployment topology;
2. every required Batch 05 gate in section 1.2 passes with current immutable evidence, zero hard failures, no flaky-unclassified result, and complete cleanup;
3. all required predecessor evidence is current and matches the exact same release/contract/database/restore profile; evidence from a different topology or version is not silently composed;
4. every production capability, purpose, output, role, approval/SoD, grant mode, session/authentication profile, audit event/access/retention class, export/integration/support path, verifier, checkpoint, break-glass operation, accessibility support matrix, incident path, and runbook has an accountable owner and recorded human decision;
5. the production database and supplemental native audit profile pass the Batch 04 engine/restore/operations decision and E05-20 without replacing the canonical typed ledger;
6. the independently protected checkpoint, verifier ownership, signer/key custody, trusted-first-checkpoint, rotation/revocation, stale-tail policy, alert, incident response, and restore procedure are deployed and drilled outside the ordinary product/database administration boundary;
7. cross-realm, purpose/output, JIT/revocation, transaction failpoint, audit-before-disclose, tamper, old-backup restore, break-glass, accessibility, privacy-canary, performance/contention, dependency, incident, and cleanup evidence all pass;
8. Architecture, Security, Privacy, Accessibility, IAM, Data/Records, Operations/SRE, Support, Legal/Compliance, Procurement/Finance, and designated production-risk authorities accept the exact residual risk within their authority;
9. a staged rollout, kill/hold, rollback, evidence-expiry, recurring verification/accessibility/restore schedule, support model, and removal/recovery plan are recorded;
10. a separate designated authority explicitly approves pilot or production. `B05_TECHNICAL_PASS` alone never sets production approval.

### C. Conditions requiring a new baseline change proposal

A change proposal is mandatory before any implementation claims it needs:

- browser-held access/refresh tokens or browser-enforced realm/authorization;
- a general tenant-authored policy/workflow/script/query language;
- a generic admin/table/row/JSON-patch or direct database production path;
- an external authorization service that is the final authority for a local mutation without equivalent transaction semantics;
- a privileged effect outside the canonical same-transaction decision/audit boundary;
- sensitive streaming before durable access audit;
- a local-only audit trust model for privileged production use under the current DBA/host threat;
- audit source-row editing, silent gap repair, lower-sequence rollback, or ordinary-admin hold clearance;
- identity-provider role, OAuth scope, route, header, certificate text, RLS, or UI visibility as sole UAM authority;
- activity/person detail, cross-realm dashboards, arbitrary exports/destinations, or break-glass data access without approved purpose and minimum contracts;
- a weaker accessibility path, direct database workaround, or exclusion of a critical workflow from the gate;
- restore read/egress/mutation enablement without current authority, tombstone, acknowledged-set, and external audit reconciliation;
- a selected policy engine, design system, BFF product, transparency service, immutable database, or native audit feature without the required exact admission and migration/removal evidence.

**Current status:** the architecture-level conclusions are ready for architecture-forum consideration, but every Batch 05 technical gate and every material production human decision remains open. Until sections A and B are satisfied at their respective levels, the permitted state is strict contracts, pure models, fictional fixtures, isolated prototypes, accessibility tooling, and lab-only fault/restore/recovery evidence—never administrative production use.
