# Prompt 20 result — portal information architecture and administrative workflows

**Result path:** `results/batch-05-portal-governance/20-portal-information-workflows-result.md`  
**Research date:** 1 August 2026  
**Decision status:** **ACCEPT AS AN IMPLEMENTATION BLUEPRINT WITH MANDATORY PROOF GATES — T1 SYNTHETIC PROTOTYPES MAY PROCEED; PRODUCTION ADMINISTRATION REMAINS DISABLED**  
**Authority boundary:** portal information architecture, browser/BFF trust boundary, administrative command patterns, workflow/state design, aggregate-first read models, accessibility, usability, safe recovery, portal observability, and test architecture; **not** legal purpose, lawful basis, prohibited uses, retention, employee consultation, real user groups, role assignments, approval duties, notification duties, production detail access, budget, SLO/RPO/RTO, production technology selection, pilot, or production approval.  
**Predecessors:** accepted Batch 01–04 review results.  
**Primary gate:** **normal administration must be possible without direct database access, generic row mutation, inaccessible controls, hidden production actions, or an unaudited high-risk action.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, accessibility testing, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed Prompt 20 implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

## Evidence boundary and file-presence record

**FACT.** All eight allowlisted project files were present. No other Project file was opened, searched, quoted, summarized, or used. The local suffixes on two review files identify the same logical allowlisted results.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Use and limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted architecture and invariants; not runtime, legal, access, or production approval. |
| I02 | `02-sanitized-application-catalogue-report.md` | same | `2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5` | Safe catalogue shape and quality conditions only; no raw values, owners, roles, purposes, rules, entitlements, or usage. |
| I03 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted decisions, resolved tensions, ordered proof gates, and stop rule. |
| I04 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence quality, human-authority, source, and conflict-handling rules. |
| I05 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted strict contracts, UUIDv7 identity, application registry, monotonic policy, repository boundaries, G1 process authority, and evidence rules. |
| I06 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted source/privacy boundaries, aggregate interpretation limits, data-quality states, and application matching semantics. |
| I07 | `batch-03-review-result.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted release, identity, exact compatibility, closed diagnostics/support, and signed-control principles. |
| I08 | `batch-04-review-result.md` | `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted ingestion/control API boundary, durable audit, lifecycle barriers, deletion/restore truth, integrations/exports limitations, and deferred UI/accessibility decision. |

**FACT.** The sanitized catalogue contains 173 records and 173 case-insensitively unique names; five external correlation IDs are missing; ten names contain non-ASCII characters; nine may end in truncation markers; and one name contains an address-like IPv4 literal. No roles, owners, lifecycle, sensitivity, rules, entitlement, or observed-use dimensions are supplied. [I02]

**RECOMMENDATION.** Use these counts and quality shapes only to create wholly fictional portal fixtures, import warnings, search tests, Unicode tests, truncation tests, and conflict-resolution flows. Never reconstruct, upload, display, or infer the raw catalogue.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Conclusion

**RECOMMENDATION — adopt a same-origin browser application backed by a dedicated ASP.NET Core control BFF inside the accepted modular monolith.** The browser is a presentation and interaction client. It is never an authorization authority, database editor, policy compiler, signing authority, or source of realm identity. Every read and every action passes through an explicit server endpoint that derives the active realm and actor from authenticated server context, checks a named capability against the exact resource and state, validates a closed contract, applies optimistic concurrency, writes the business transition and durable audit in the same transaction, and returns a privacy-safe result.

The portal should be **aggregate-first and least-detail by default**. Its home and fleet views should answer operational questions—coverage, freshness, failure, backlog, rollout, policy, data quality, and safety state—without opening individual activity. “No data” must never be shown as “no activity.” The interface must distinguish `CURRENT`, `STALE`, `OFFLINE`, `UNSUPPORTED`, `DEFERRED`, `PARTIAL`, `SUPPRESSED`, `SAFETY_HOLD`, and `UNKNOWN` using text and semantics, not color alone.

Administrative changes should follow one consistent safety pattern:

```text
read current revision
  -> create/edit draft
  -> validate
  -> compute immutable impact preview
  -> collect required review/approval
  -> execute with If-Match + preview digest + idempotency key + reason
  -> write transition and audit atomically
  -> observe staged progress
  -> pause/kill/rollback through separate explicit commands
  -> verify recovery and close
```

The portal must not expose a generic table editor, arbitrary SQL, scripts, regexes, URLs, file paths, commands, plug-ins, free-form destinations, hidden feature actions, or a “save any fields” endpoint. High-risk actions—policy publication, application-rule publication, release rollout, kill-switch change, export, deletion, connector activation, diagnostic permit, and support-bundle creation—must have explicit command types, impact preview, reason, state preconditions, and audit. Approval separation remains a **HUMAN DECISION**; until assigned, the conservative default is that those actions remain disabled outside T1 fixtures.

**RECOMMENDATION — target WCAG 2.2 Level AA for every in-scope workflow, not only page templates.** WCAG 2.2 is a W3C Recommendation dated 12 December 2024 and explicitly advises use of the current WCAG version. [W01] Native HTML should be preferred; WAI-ARIA should fill semantic gaps rather than replace native controls. [W02–W03] The current published European ICT accessibility standard remains EN 301 549 V3.2.1 (2021-03); ETSI listed V4.1.0 (2026-06) as “On Approval” on the research date, so UAM must re-evaluate the mapping after final publication. [W04–W06]

## 1.2 Decision status by area

| Area | Decision | Status |
|---|---|---|
| Browser/API authority | Browser has no authority; same-origin BFF and domain modules authorize every operation | **Accept** |
| Normal administration | Explicit read models and command endpoints; no direct DB or generic row mutation | **Accept** |
| Information architecture | Realm-scoped, task-oriented navigation in section 3.5 | **Accept for prototype** |
| Detail access | No activity/person detail by default; even the existence of a detail view is human-owned | **Conservative default accepted; human decision open** |
| Mutation safety | Preview, reason, version, idempotency, approval where assigned, atomic audit | **Accept** |
| Workflow engine | Small release-owned state machines in the modular monolith; no generic workflow platform | **Accept** |
| Audit | Relational append-only audit in the mutation transaction; external immutable archival is optional and later | **Accept logical rule; storage technology open** |
| Accessibility | WCAG 2.2 AA workflow target plus named AT matrix | **Accept; policy/AT support matrix human-owned** |
| Portal framework/design system | Standards-first browser client; exact framework/design system selected by a bake-off | **Open CLI/dependency decision** |
| Performance | Server pagination, route splitting, bounded read models, current Core Web Vitals as provisional UX thresholds | **Accept principle; numeric UAM SLOs open** |
| Notifications/escalation | Typed, privacy-safe events and dedupe; recipient/responsibility policy human-owned | **Accept mechanism; ownership open** |
| Exports/deletion/integrations | Typed workflows, truthful limitations, no generic destinations | **Accept mechanism; production use open** |
| Support/diagnostics | Closed safe capabilities and permits; no arbitrary command/file/dump | **Accept** |

## 1.3 Why this is the smallest safe design

**FACT.** The accepted server design already places a control API/BFF in a modular monolith, derives realm/device authority from authenticated context, requires durable audit for privileged mutations, and distinguishes receipt, processing, visibility, deletion, and restore states. [I01, I05, I07, I08]

**INFERENCE.** A same-origin BFF is the smallest portal boundary that preserves those decisions while avoiding browser-held API credentials, cross-origin token handling, client-enforced realm selection, and duplicate authorization logic. A framework-neutral screen contract also allows the browser technology to be measured without reopening the server authority model.

**INFERENCE.** A generic administrator or workflow framework would be larger, not simpler, because UAM’s safety rules are narrow and domain-specific: tenant policy may only narrow a release ceiling; application ambiguity must not be guessed; rollback is a higher revision; receipts do not mean visibility; deletion begins with a visibility barrier; and support may not collect arbitrary data. Explicit state machines are easier to review and falsify.

## 1.4 Confidence and residual risk

| Major conclusion | Confidence | Basis | Evidence that could change it |
|---|---|---|---|
| Browser must not be API authority | **High** | Directly follows accepted authenticated-context, realm, audit, and privacy invariants; consistent with current OAuth security guidance. | A formally reviewed alternative proving equivalent token, CSRF, realm, audit, revocation, and support properties with less complexity. |
| Same-origin BFF is the best initial boundary | **High** | Fits accepted modular monolith and avoids a second public control API trust surface. | A measured deployment constraint that makes same-origin impossible and an alternate architecture passing the same threat matrix. |
| Aggregate-first least-detail IA is appropriate | **High** | Accepted telemetry is fallible and not productivity evidence; exact detail need is human-owned. | A human-approved purpose and workflow that cannot be completed without detail, plus privacy/accessibility proof. |
| Preview/version/reason/audit command pattern is sufficient to implement | **High** | It directly controls stale updates, bulk impact, replay, and privileged mutation evidence. | A state-machine counterexample or usability test showing operators cannot safely complete required work. |
| WCAG 2.2 AA should be the engineering target | **High** | Current W3C Recommendation and strongest stable web target; compatible with future-oriented procurement. | A recorded organizational policy imposing a stricter target or a legal mapping requiring additional clauses. |
| One exact design system can be safely adopted now | **Low** | No UAM component/accessibility/bundle/security bake-off has run. | Prompt 20 CLI evidence across representative workflows and AT combinations. |
| The proposed IA matches priority users | **Medium-Low** | It covers supplied domain functions, but actual user groups and priority workflows are explicitly human decisions. | Task research with authorized representative users and support/operations owners. |
| Production administration is ready | **Low / not established** | Roles, approvals, notifications, accessibility policy, detail need, performance, framework, and production evidence remain open. | Full Prompt 20 gate plus Batch 05 review and human approvals. |

**Residual risk.** Authorized administrators can still make harmful but permitted choices; accessibility varies by browser/AT and custom composition; a design system can regress; large lists and previews may become slow; notification overload can hide incidents; audit storage can be misconfigured; external recipients can retain exports; and a human approval model can become ceremonial. Research cannot prove user comprehension, organizational separation of duties, legal purpose, or operational competence. The controls below reduce and expose these risks; they do not eliminate them.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result defines implementation-ready portal architecture and workflows for:

- fleet health, population, eligibility, compatibility, freshness, and policy coverage;
- policy draft/review/publish/rollback and emergency narrowing;
- application registry import, revision, rules, conflicts, ambiguity, and snapshots;
- release/task rollout, staged rings, pause, kill, rollback, and recovery;
- aggregate evidence, data quality, coverage, freshness, and optional detail boundary;
- diagnostics, errors, support cases, diagnostic permits, and support bundles;
- audit search and privileged-action evidence;
- exports, deletion/lifecycle, holds, limitations, and restore-readiness visibility;
- integrations/connectors and their lifecycle capabilities;
- browser/BFF trust boundaries, authorization, command contracts, errors, feature controls, observability, localization, accessibility, performance, and testing.

## 2.2 Non-goals

The result does not:

- decide legal purpose, lawful basis, prohibited uses, employee consultation, retention, identity level, detail access, or production use;
- invent organizational groups, job titles, approval chains, escalation recipients, or notification SLAs;
- redesign endpoint collection, ingestion, database, retention, restore, signing, device identity, or release architecture accepted by earlier batches;
- choose the production database, audit archival technology, identity provider, browser framework, design system, analytics platform, message broker, or workflow product;
- authorize direct database access, raw activity inspection, unrestricted query builders, arbitrary commands, custom scripts, user-supplied destinations, or production signing;
- treat UI text, a role claim, a route, a hidden button, or a client-supplied realm as authorization;
- claim accessibility from an automated scanner alone;
- claim task success from developer review alone;
- use raw catalogue values, production activity, credentials, addresses, SSH material, employee information, or internal URLs.

## 2.3 Accepted inputs carried forward

The following accepted predecessor decisions are normative inputs:

1. **FACT.** Realm, installation, device, user, and session authority comes from authenticated server/runtime context, never payload claims. [I01, I05, I07, I08]
2. **FACT.** One realm/user/session cannot submit, view, mutate, export, or delete as another. [I01, I05, I08]
3. **FACT.** A privileged mutation cannot succeed without durable audit evidence. [I01, I05, I08]
4. **FACT.** Tenant policy may only narrow the product privacy ceiling. [I01, I05]
5. **FACT.** UAM application identity is a realm-scoped immutable UAM UUIDv7; names, aliases, and external references are not identity or matching authority. [I05]
6. **FACT.** Application rules use a closed grammar; cross-application ambiguity is explicit and is never guessed by order or label. [I05, I06]
7. **FACT.** Control artifacts and revisions are immutable and monotonic; rollback republishes prior approved semantics at a higher revision or sequence. [I05, I07]
8. **FACT.** The initial server is a modular monolith with a control API/BFF and governed contracts. [I01, I08]
9. **FACT.** Diagnostics and support are closed, value-free by default, and cannot become arbitrary command, file, dump, or activity channels. [I07]
10. **FACT.** Exports, integrations, deletion, tombstones, legal holds, and restore readiness have explicit states and limitations; external recipient deletion cannot be falsely claimed. [I08]
11. **FACT.** “No data” is fallible operational evidence, not proof of no activity or productivity. [I01, I06]
12. **FACT.** Exact portal technology and audit storage technology remain provisional. [I01, I08]

## 2.4 Assumptions

- **ASSUMPTION.** The portal is an online enterprise administration surface; endpoint offline capability does not require portal offline mutation.
- **ASSUMPTION.** The initial browser client can be hosted from the same origin as the BFF and can use an enterprise interactive authentication session.
- **ASSUMPTION.** Existing or selected enterprise identity can provide authenticated principals and group/claim inputs; UAM still maps them to release-owned capabilities server-side.
- **ASSUMPTION.** The modular monolith can expose read projections and explicit command handlers without browser access to module persistence tables.
- **ASSUMPTION.** Most normal administration can be completed from aggregates, revisions, statuses, and health evidence rather than raw events.
- **ASSUMPTION.** T1 fictional personas and data can represent capability combinations without claiming actual organizational roles.

Each assumption must be falsified or accepted by a named owner before production use.

## 2.5 Unknowns and their conservative defaults

| Unknown | Conservative temporary default | What resolves it |
|---|---|---|
| Actual user groups and priority workflows | Build capability-based T1 personas; no production role mapping | **HUMAN DECISION** plus representative user research |
| Terminology and accessibility policy | Use neutral operational terms; target WCAG 2.2 AA; avoid productivity language | **HUMAN DECISION** by Product/Accessibility/Legal/Privacy |
| Approval and notification responsibilities | High-risk production commands disabled; T1 self-contained approval fixtures only | **HUMAN DECISION** and separation-of-duties matrix |
| Whether activity/person detail is needed | No detail route or API; aggregate and operational device health only | **HUMAN DECISION** plus purpose/minimization/access review |
| Exact identity provider/session integration | Same-origin BFF abstraction; no browser token storage | IAM ADR and integration test |
| Exact front-end framework/design system | Standards-first component contract and bake-off | Prompt 20 CLI experiments and dependency admission |
| Exact performance SLOs and client budgets | Current Core Web Vitals as provisional UX thresholds; conservative paging | Measured workload and Product/SRE decision |
| Exact staleness/offline thresholds | Display source timestamp and named freshness class from server; never infer in browser | Product/SRE policy revision |
| Audit archival/immutability technology | Transactional relational audit is authoritative initial ledger | Security/Records/Operations decision and restore test |
| Browser/assistive-technology support matrix | Edge+Narrator and Firefox+NVDA prototype minimum; exact versions captured at execution | Accessibility policy and recurring test evidence |
| Localization languages/time zones | Externalized messages, UTC contracts, locale-aware display, pseudolocalization and RTL tests | Product/Localization decision |
| Notification channels and deadlines | In-portal inbox only in prototype; no email/webhook payloads | Human ownership plus privacy/security review |

## 2.6 Conflict handling

**FACT.** No recommendation in this result requires changing an accepted predecessor decision. No baseline change proposal is opened.

A future implementation must open an explicit change proposal before introducing any of these:

- browser-enforced authorization or browser-supplied realm authority;
- direct browser-to-database access;
- a generic mutation/table editor or arbitrary JSON-patch endpoint;
- a privileged command that can commit without durable audit;
- a feature flag that broadens privacy/authorization or bypasses tombstones, realm, audit, release, or approval;
- raw activity/detail as a default view;
- tenant-defined scripts, SQL, regex, paths, commands, destinations, or transforms;
- lower-revision rollback;
- external deletion “completion” inferred from a request or HTTP status;
- hidden production actions unavailable to the same authorization catalogue and audit path.

The proposal must identify the affected invariant, new primary evidence, security/privacy/accessibility impact, smallest falsifying prototype, migration/rollback consequence, and ADR action.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architectural decision

**RECOMMENDATION.** Implement the portal as a same-origin web application and ASP.NET Core control BFF inside the accepted server modular monolith. The BFF composes narrow domain APIs and read models; it does not own business truth or bypass module commands. The browser never receives database credentials, signing keys, integration secrets, device credentials, general API tokens, or raw activity data.

```text
enterprise browser
  -> TLS + enterprise authentication
  -> same-origin Portal BFF session
       - active realm context
       - CSRF/session controls
       - screen read-model composition
       - command contract validation
  -> server authorization policy enforcement
  -> explicit domain command handler
       - state/version/idempotency/preview checks
       - business transition + audit in one transaction
       - outbox/job creation where asynchronous
  -> read projections / job status / safe notification

No browser -> database path
No browser -> endpoint path
No browser -> signing/KMS path
No browser -> connector secret path
No browser -> generic internal module/table API
```

## 3.2 Component responsibilities

| Component | MUST do | MUST NOT do | Trust/data boundary |
|---|---|---|---|
| **Portal Web Client** | Render semantic HTML; maintain local view state; submit closed commands; show freshness, scope, warnings, progress, and recovery; support keyboard/AT/localization | Authorize; infer realm; hide actions as sole control; store bearer tokens/secrets; construct SQL; mutate generic rows; cache sensitive pages offline | Untrusted presentation tier; all inputs hostile |
| **Portal BFF** | Terminate same-origin session; derive actor and active realm; enforce CSRF; compose screen read models; apply route-level limits; call named authorization and domain services; set privacy-safe cache headers | Hold business truth; trust client role/realm; expose persistence models; provide generic proxy or GraphQL schema over modules | Internet/browser boundary to authenticated server context |
| **Realm Context Broker** | Bind one realm to the server session/request; issue fresh anti-CSRF state on switch; clear realm-scoped client caches; require reauthorization | Combine realms by default; trust query/body realm; retain stale realm data after switch | Cross-realm confused-deputy boundary |
| **Authorization Service** | Evaluate `principal × realm × resource × action × state`; deny by default; use release-owned capability IDs; support negative and separation tests; emit safe decision evidence | Depend on button visibility; use free-form role strings in domain code; authorize by name/path/body claim; silently fall back | Privileged command/read boundary |
| **Read Model Gateway** | Expose purpose-built, realm-first, aggregate-first projections with `asOf`, freshness, quality, pagination, and capability-filtered fields | Expose ORM entities, arbitrary joins, event tables, raw payloads, generic query language, hidden columns | Least-detail read boundary |
| **Command Gateway** | Accept only named versioned commands; require idempotency, state/version, reason, and preview where specified; validate closed schema; invoke one domain handler | Accept generic PATCH/table/column mutation; dynamic handler names; arbitrary destination/path/script/SQL | Mutation authority boundary |
| **Impact Preview Service** | Resolve exact candidate scope server-side; compute diff, dependencies, unknowns, stale/offline counts, policy/release effects, rollback path; content-address preview; set expiry | Treat browser-selected counts as authority; execute an expired/changed preview; expose sensitive values | TOCTOU/bulk-action boundary |
| **Workflow/State Modules** | Own explicit finite state machines for policy, rules, releases, exports, deletion, support, integrations; enforce allowed transitions | Implement a general tenant workflow language; permit hidden transitions; let UI write state directly | Domain consistency boundary |
| **Approval Service** | Record approval request/decision against exact content and preview digests; enforce assigned separation rules; expire/revoke approvals | Invent approvers; accept self-approval where policy forbids; approve changed content; use email click alone as authority | Human authority boundary; policy open |
| **Audit Ledger** | Insert immutable action evidence in the same database transaction as every privileged state transition; record actor, authority, realm, command, reason, before/after digests, outcome, time | Store raw activity/selectors/secrets; allow update/delete by normal admin; substitute operational logs | Non-repudiation/accountability boundary |
| **Job/Progress Service** | Represent long operations as durable jobs with finite states, milestones, cancellation rules, recovery links, and idempotent status | Keep progress only in browser memory; infer completion from notification; lose original failure on retry | Async operation boundary |
| **Notification Service** | Consume typed events; deduplicate; create in-portal notifications; use safe templates and opaque links; track acknowledgement | Put activity, names, paths, secrets, or broad identifiers in messages; make notification delivery the business transaction | Secondary delivery boundary |
| **Feature/Kill Control** | Use finite release-owned flags; allow only disable/narrow/pause; bind owner, expiry, scope, reason, audit; surface effective state | Broaden privacy/access; bypass auth/audit/tombstones/realm/release; execute hidden code; self-clear safety hold | Emergency control boundary |
| **Export Service** | Preview exact scope; create manifest; generate bounded approved formats; scan; encrypt/authorize delivery; track retrieval/expiry/deletion and external-copy limitation | Generic table export; formula-active spreadsheet content; raw hidden fields; uncontrolled destinations; claim recipient deletion | Data-egress boundary |
| **Lifecycle Service** | Use typed selector and approved authority; commit suppression barrier/tombstone before physical deletion; expose truthful target/hold/limitation state | Fuzzy lookup; direct row deletion; remove suppression after partial failure; claim legal completion | Rights/lifecycle boundary |
| **Integration Admin** | Manage immutable connector revisions, allowlisted destination classes, opaque secret references, test/activate/deactivate/delete states, capability limitations | Return secrets; accept arbitrary URL/headers/scripts; perform browser-side network test; infer deletion completion | SSRF/secret/egress boundary |
| **Diagnostics/Support** | Expose finite health/error codes, permits, safe bundles, case timelines, and runbooks; enforce expiry/revocation | Arbitrary command/file/registry/log/dump collector; raw exception text; raw activity; remote debugging | Support disclosure/control boundary |
| **Portal Observability** | Emit finite route/action/result/freshness classes and bounded performance/accessibility signals | User/realm/resource IDs as metric labels; free text; request body; application/host names; raw error/stack | Privacy/cardinality boundary |
| **Contract/Capability Catalogue** | Define every route, read model, command, state, action capability, risk class, reason code, preview requirement, audit event, flag, and support owner | Runtime discovery of arbitrary actions; unowned production command | Architecture governance boundary |

## 3.3 Browser session and API security profile

**RECOMMENDATION.** The initial portal uses an opaque server-side session referenced by a `Secure`, `HttpOnly`, `SameSite` cookie. The exact identity protocol is selected by IAM, but the browser should not persist access/refresh tokens in JavaScript-visible storage. RFC 9700 is the current OAuth 2.0 security BCP and should guide any OAuth/OIDC integration. [W12]

The BFF MUST:

- rotate session identifiers after authentication, privilege elevation, and realm switch;
- bind the session to authenticated principal, active realm, authentication context, issuance/expiry, and authorization snapshot/version;
- require an anti-CSRF token or equivalent same-origin proof for every state-changing request;
- reject missing/duplicate/ambiguous origin and content-type conditions;
- set `Cache-Control: no-store` on sensitive or personalized responses and prevent service-worker caching of administration routes initially;
- enforce a restrictive Content Security Policy using nonces/hashes, `frame-ancestors`, and no `unsafe-eval`; CSP is defense in depth, not the primary output-encoding control;
- render untrusted catalogue and integration display strings as text, never HTML;
- reauthorize on every read and command; cached menus are only presentation hints;
- use bounded session inactivity/absolute lifetimes selected by IAM and accessibility policy; warn accessibly before expiry and preserve unsent drafts where safe;
- require step-up/recent authentication for actions designated by human policy, without creating inaccessible cognitive tests.

## 3.4 Server authorization model

Authorization is capability-based and resource/state-aware, not UI-role-name-based.

```text
PortalAuthorizationRequest {
  authenticated_principal
  active_realm
  capability_id
  resource_type
  resource_id?              # opaque UAM ID
  resource_version?
  workflow_state?
  risk_class
  authentication_context
}
```

Examples of release-owned capabilities:

```text
fleet.health.read
fleet.installation.read_operational
policy.draft.create
policy.review.submit
policy.publish
policy.emergency_narrow
application.import.stage
application.rule.approve
application.snapshot.publish
release.rollout.start
release.rollout.pause
release.rollback
kill_switch.activate
kill_switch.clear
aggregate.read
activity_detail.read          # absent/disabled until human decision
support.case.read
support.bundle.request
export.request
lifecycle.deletion.authorize
integration.revision.activate
audit.read
```

Rules:

1. A capability is necessary but not sufficient; realm, resource, state, approval, preview, version, and current safety controls must also pass.
2. Domain code receives an immutable server-created authorization context, not free-form claims from the request body.
3. Every repository key begins with realm. Cross-realm ID lookups return a generic denied/not-found result without existence disclosure.
4. A permission removal or safety hold takes effect on the next request and prevents completion of an uncommitted command.
5. Bulk actions authorize both the command and every resolved resource class; the browser never sends an authoritative list obtained from an earlier query.
6. “Read audit” and “perform action” are distinct capabilities. “Approve” and “execute” separation is a **HUMAN DECISION** represented by policy, not hardcoded job titles.

## 3.5 Navigation/information architecture — mandatory artifact

### 3.5.1 Global frame

```text
Skip link
Product header
  - UAM product name and environment label
  - active realm switcher / realm status
  - global realm-scoped search
  - notification inbox
  - help and support
  - signed-in identity and session controls
Primary navigation
Page title + breadcrumbs
Page-level freshness/data-quality banner
Main content
Contextual help / runbook links
```

The environment and realm must be continuously visible in text. Production and non-production environments must not differ only by color. Switching realm must be an explicit action that refreshes the server-bound context, clears realm-scoped client state, updates the document title/heading, and announces the change to assistive technology.

### 3.5.2 Primary navigation tree

```text
1. Overview
   - Operational summary
   - Required attention
   - Recent privileged changes

2. Fleet
   - Health
   - Population and eligibility
   - Installations / devices (operational detail only)
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
   - Tasks / jobs
   - Kill switches

6. Evidence
   - Aggregates
   - Coverage and data quality
   - Detail (not present until a human decision approves a purpose and access model)

7. Operations
   - Diagnostics and errors
   - Integrations
   - Exports
   - Deletion and lifecycle
   - Audit

8. Support
   - Cases
   - Support bundles
   - Runbooks and known conditions

9. Administration
   - Realm configuration
   - Capability mappings
   - Notification policies
   - Control-artifact and signing-authority status (read-only)
   - Feature inventory
```

### 3.5.3 Navigation rules

- Navigation is capability-filtered for usability, but direct routes still reauthorize.
- Items are stable and task-oriented; internal service/database names are not primary navigation.
- Each page has one primary heading, a task-oriented title, and a canonical URL that contains no sensitive identifier or realm authority.
- Browser history and deep links restore filters only after server reauthorization and realm validation.
- Search is realm-scoped and metadata-only. It must not become a raw activity, SQL, regex, or arbitrary field query.
- High-risk actions are never accessible only through unlabeled overflow menus; the action name, scope, prerequisites, and risk are visible on the resource page.
- Empty, loading, partial, stale, offline, unsupported, forbidden, and error states are first-class screen contracts rather than generic spinners or blank tables.

## 3.6 Aggregate-first and least-detail defaults

**RECOMMENDATION.** Every evidence and fleet route starts with an aggregate summary, data-quality/freshness statement, and bounded drill-down. It does not start with persons, individual activity events, raw URLs/hosts, profile paths, or unbounded device lists.

A standard summary card contains:

```text
metric label
value or “not available”
as-of time and time zone
population denominator / scope
freshness class
quality class
trend with textual equivalent
reason when unavailable
link to bounded supporting list, if authorized
```

`0`, `NO_DATA`, `NOT_COLLECTED`, `SUPPRESSED`, `UNSUPPORTED`, `OFFLINE`, `DEFERRED`, `PARTIAL`, and `UNKNOWN` are different values. The UI must not collapse them.

Operational installation detail MAY include:

- opaque installation/device display alias approved for operations;
- compatibility state, release, policy revision, last contact/freshness class;
- source/capability health categories, backlog class, receipt/processing status class;
- support-safe error codes and runbook links;
- current rollout/task state.

It MUST NOT include raw activity, URLs, paths, person identity, source database values, arbitrary logs, exception text, or a productivity score. The existence and exact content of any activity-detail view is a **HUMAN DECISION** and is structurally absent from the first prototype.

## 3.7 Screen-level data/action contracts — mandatory artifact

| Screen | Default read model | Authorized actions | Least-detail and state rules |
|---|---|---|---|
| **Overview** | Realm health summary, freshness distribution, policy/release coverage, safety holds, failed jobs, recent privileged audit shells | Navigate; acknowledge own notification | No person/activity. Show `asOf`, partial/unknown, and denominator on every metric. |
| **Fleet health** | Counts/trends by finite health, compatibility, release, policy, freshness, backlog, and source capability classes | Create bounded server-side filter snapshot; open operational installation | Server pagination; no “all rows” download; no data ≠ no activity. |
| **Population & eligibility** | Eligible/ineligible/unknown counts with reason classes and policy/compatibility revision | Preview policy population impact | Unknown remains visible; no inferred role/person mapping. |
| **Installation operational detail** | Safe identity alias, exact state versions, health, release/policy, jobs, value-free errors | Request safe diagnostic, pause capability if authorized, open support case | No raw event/history. Stale context banner. Every action has scope and recovery. |
| **Effective policy** | Product ceiling, tenant narrowing, emergency/local restrictions, effective diff, revision/expiry | Create draft; request preview; publish/rollback when authorized | Effective policy is computed server-side. Tenant broadening is unrepresentable. |
| **Policy draft/review** | Immutable base revision, proposed diff, validation, impact, comments/decisions, approval state | Edit draft fields from closed catalogue; validate; submit; approve/reject; schedule | Content change invalidates approval/preview. Free-form executable values absent. |
| **Application registry** | UAM ID, display revision, external-ref quality state, aliases, lifecycle state, provenance | Stage import; edit draft metadata; merge/split through explicit workflows | Name/external ref is not identity. Search handles Unicode/truncation safely. |
| **Import/data quality** | Fictional/provided file manifest, row counts, missing/duplicate/invalid classes, proposed creates/updates/conflicts | Validate; preview; commit approved import; abandon | Raw source values shown only when explicitly approved; T1 prototype uses fictional values. Five-missing-ID shape tested. |
| **Rules/conflicts** | Closed rule grammar, application target, priority/specificity, overlap/shadow/ambiguity witnesses, snapshot impact | Draft; validate; submit review; approve; publish/rollback | No regex/script/order-based guessing. Ambiguity blocks publication or remains unmatched. |
| **Release rollout** | Release digest/evidence, compatibility scope, rings, counts by state, health gates, kill/rollback readiness | Preview; approve; start; pause; resume; abort; rollback | Staged only. One command per transition. Unknown/incompatible endpoints never silently included. |
| **Tasks/jobs** | Job type, actor, scope digest, state, milestones, safe errors, created/as-of/expiry | Cancel when state allows; retry same identity; open evidence | Preserve first failure and retry lineage. Completion is domain state, not notification. |
| **Aggregates** | Approved aggregate dimensions, denominator, time bucket, quality/freshness, suppression state | Filter; save local view; request approved export | No person ranking or productivity score. Chart always has text/table equivalent. |
| **Diagnostics/errors** | Finite error families/codes, affected count, release/capability class, first/last seen, runbook | Acknowledge; request bounded diagnostic permit; create case | No exception text, URL, path, identity, or unbounded label. Rare-population access policy open. |
| **Audit** | Actor alias/authority, realm, action type, resource type/token, reason code, state before/after digest, outcome, timestamp, approval refs | Filter; view immutable event; export only if separately authorized | No edit/delete. Raw command payload absent. Corrections are linked new events. |
| **Export** | Purpose, scope manifest/digest, format profile, fields, recipient class, state, expiry, retrieval/deletion status | Draft; preview; approve; generate; revoke; delete | No generic table export. External retrieved copy is explicitly uncontrollable. |
| **Deletion/lifecycle** | Case authority, exact resolution summary, barrier/tombstone, targets, holds, external actions, limitations, verification | Draft; authorize; pause destruction; retry typed target; verify | Suppression precedes deletion. Post-barrier cancellation cannot re-expose data. “Complete” is technical, not legal. |
| **Integrations** | Connector type/revision, purpose, owner/support role, allowed destination class, secret reference status, health, deletion capability | Draft/test/approve/activate/deactivate/rotate secret reference/delete | Browser never receives secret or arbitrary URL. Test uses server egress controls. |
| **Support case** | Case-scoped alias, safe symptoms, evidence inventory, runbook steps, permits/bundles, timeline | Assign/acknowledge; request permit; build/revoke bundle; close | No remote shell, raw logs, arbitrary files, dumps, or customer activity. |
| **Administration** | Capability mappings, notification policy revisions, feature/kill inventory, authority status | Draft/review/publish explicit revisions | No generic role editor. Human responsibility and separation decisions remain open. |

## 3.8 Standard page-state contract

Every list, detail, and workflow route MUST implement these states with semantic headings/messages and recovery actions:

| State | Required content | Prohibited behavior |
|---|---|---|
| `LOADING` | Page title, skeleton with accessible status, cancel/navigation remains usable | Indefinite unlabeled spinner; focus stealing |
| `EMPTY_VALID` | Scope, filters, as-of, explanation, next valid action | Imply system failure or no activity |
| `NO_AUTHORITY` | Generic denied result, safe support reference | Reveal cross-realm/resource existence or hidden fields |
| `STALE` | Last successful as-of, freshness class, reason, refresh/recovery | Present stale data as current |
| `OFFLINE_SOURCE` | Affected scope/count, last contact class, known limitations | Treat as zero activity or silently exclude denominator |
| `PARTIAL` | Included/excluded/unknown counts, unavailable dependency, action restrictions | Aggregate partial values without visible denominator/quality |
| `UNSUPPORTED` | Exact capability/profile class and safe remediation | Offer action that cannot succeed |
| `SAFETY_HOLD` | Hold reason family, scope, owner/runbook, safe next step | Self-clear, automatic retry that broadens authority |
| `ERROR_RETRYABLE` | Safe code, operation token, same-id retry, status link | Duplicate command or expose exception text |
| `ERROR_TERMINAL` | Safe code, containment, recovery/rollback path, support link | Generic “something went wrong” with no state certainty |
| `CONFLICT` | Current version, changed scope summary, reload/re-preview | Last-write-wins or silently overwrite |
| `COMPLETED_WITH_LIMITATIONS` | Completed targets, unresolved external/held scope, explicit limitation | Show green “complete” without limitation text |

## 3.9 Configuration ownership, flags, and kill switches

Configuration classes:

| Class | Owner and authority | Portal behavior |
|---|---|---|
| Product ceiling/capability catalogue | Release/Product Privacy authority | Read-only in tenant portal; tenant can only select narrower values |
| Tenant policy | Assigned tenant governance authority | Immutable drafts/revisions; validate/preview/review/publish |
| Emergency product narrowing | Product incident authority | Immediate signed higher sequence; visible globally; cannot broaden |
| Tenant emergency narrowing | Assigned tenant incident authority | Immediate narrower scope; explicit expiry/recovery; audited |
| Local safety hold | Runtime/system | Read-only status; portal may request authorized recovery but cannot overwrite |
| Feature flag | Product/release-owned finite catalogue | Enable only within already authorized ceiling; tenant may disable/narrow; expiry required |
| Kill switch | Product or assigned tenant incident authority | Separate explicit activate/clear command; clear requires higher authorized state and recovery evidence |
| User preferences | Individual presentation only | Locale, time-zone display, density, reduced motion; no data/authority semantics |

A flag or kill switch MUST have: immutable ID, description, owner function, scope, default, allowed values, narrowing proof, effective revision, expiry/review, affected capabilities, preview behavior, audit event, alert/runbook, and removal plan.


## 3.10 Secure coding, review, and support ownership

**RECOMMENDATION.** Treat portal code, contracts, configuration, templates, and dependencies as one security-sensitive control surface. A successful browser demonstration is not review evidence.

- Every route, command, read model, capability, reason code, workflow transition, audit event, notification template, flag, connector capability, and support action MUST have an accountable engineering owner and support owner before it can become a production candidate. An unowned item fails the contract-catalogue gate.
- Changes to realm derivation, authorization, approval binding, preview/scope resolution, audit atomicity, lifecycle barriers, release controls, export/integration egress, diagnostics, or emergency actions MUST receive independent review from the relevant security/privacy/accessibility/domain owner functions. This states required review functions; it does not invent organizational assignments.
- The repository MUST prohibit browser/database clients, dynamic SQL or ORM exposure through the BFF, arbitrary HTML rendering, `eval`/dynamic code loading, generic object serialization into audit/metrics, mass-assignment models, arbitrary redirect/destination inputs, and production-only hidden routes. Exceptions require a named ADR and falsifying test.
- Compiler/analyzer rules, architecture tests, strict schemas, dependency/source locks, SBOM/provenance reconciliation, secret and exact privacy-canary positive controls, SAST, hostile contract vectors, authorization mutations, and accessibility semantic/keyboard tests run in CI. Tool success is supporting evidence only; deliberately planted failures MUST prove each gate can fail.
- Generated clients/components remain boundary-local. Domain, persistence, browser, audit, and wire models MUST stay separate so that adding a UI field cannot silently authorize, persist, log, export, or transmit it.
- Configuration is immutable, versioned, reviewable, environment-independent where possible, and promoted as the same digest. Production administrators cannot upload code, templates, regexes, scripts, SQL, routes, plug-ins, arbitrary CSP, or arbitrary notification/connector payloads.
- Dependency upgrades rerun route/action inventory, authorization, privacy canaries, browser security headers, accessibility, performance, localization, bundle/file inventory, license review, and removal/rollback tests. A security or accessibility incident expires prior evidence for the affected component and workflows.
- Security findings use the finite error/incident taxonomy, preserve the first failure, identify affected releases/routes/capabilities, and define containment, recovery, cleanup, evidence expiry, and re-enable criteria. Support cannot request raw activity or create an undocumented bypass to diagnose a defect.


---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Reason | Condition that could change it |
|---|---|---|---|
| Browser SPA calls public control APIs with bearer tokens | **Reject initially** | Adds token storage/refresh/CORS/API exposure and duplicate realm/CSRF concerns without a need. | A deployment constraint plus a primary-source security design and prototype passing every BFF threat/authorization/audit test. |
| Server-rendered HTML only, no client application state | **Keep as viable rendering candidate** | Small attack/bundle surface and strong semantics, but complex preview/filter/job interactions may require progressive enhancement. | Bake-off shows task success, accessibility, performance, and maintainability are equal or better. |
| React/TypeScript same-origin client | **Candidate, not selected** | Strong ecosystem/design-system options; still requires dependency, accessibility, bundle, and security proof. | Prompt 20 design-system/framework bake-off. |
| Blazor Server | **Defer** | C# skills and server authority fit, but persistent connection, reconnection, scaling, accessibility composition, and failure UX are unproved. | Exact prototype passes disconnection, AT, performance, multi-tab, and operations tests with lower total cost. |
| Blazor WebAssembly | **Reject for first slice** | Larger startup/download and temptation to move token/authority logic into the browser; no demonstrated benefit. | Offline read-only requirement or measured capability that cannot be met safely otherwise. |
| Micro-frontends or portal plug-in architecture | **Reject** | Expands supply chain, cross-bundle consistency, navigation, authorization, and accessibility failure domains; no team-scale need supplied. | Independent teams and release isolation become a measured bottleneck, with a strict signed extension contract and threat proof. |
| Backstage as the portal runtime | **Reject as dependency; reference only** | Broad plugin/catalog/integration model and human-readable entity assumptions do not match UAM’s narrow authority/realm/privacy model. | A constrained fork-free integration proves smaller lifecycle/security cost than purpose-built screens. |
| Grafana as the administrative portal | **Reject** | Dashboard/query/plugin model is not an explicit command workflow; AGPL licensing and broad data-source surface are material concerns. | May remain a separately governed read-only operational dashboard after legal/security review; not mutation authority. |
| Generic admin generator/direct ORM CRUD | **Reject** | Mass assignment, hidden mutations, weak state/preview/audit semantics, and persistence coupling. | No expected change for privileged UAM operations. |
| Generic table editor / JSON Patch endpoint | **Reject** | Cannot express business preconditions, reason, impact, approvals, rollback, or audit safely. | No expected change. |
| GraphQL schema explorer as normal admin surface | **Reject initially** | Broad query/mutation discovery and field authorization/cardinality complexity exceed need. | A narrow persisted-operation profile proves lower cost while preserving closed contracts and field-level privacy. |
| General workflow/BPM engine | **Reject initially** | User-defined workflow/script/connector authority and large operations surface; UAM workflows are finite. | Workflow variants become numerous and code releases demonstrably unsafe/slow, with a closed non-executable model passing threat tests. |
| Separate audit database transaction | **Reject for authoritative mutation evidence** | Can commit business change without audit or audit without change. | A database-supported atomic mechanism across the declared failure domain; async archival may supplement, not replace, local atomic audit. |
| Cross-realm combined dashboard | **Reject by default** | Increases confused-deputy, leakage, caching, and rare-population risk. | A specifically approved central oversight purpose with separate authority, minimum aggregates, suppression, and cross-realm test suite. |
| Individual activity/person detail as default | **Reject** | Conflicts with aggregate-first minimization and the human decision boundary; high misuse risk. | Approved purpose, exact minimum fields, access/retention/appeal controls, employee consultation, and usability/privacy evidence. |
| First-match application rules or manual order | **Reject** | Accepted predecessor requires deterministic ambiguity, not guessing. | Baseline change proposal with stronger evidence; unlikely. |
| Client-side “select all matching” bulk command | **Reject** | Scope can change between query and execution; browser list is incomplete and stale. | No expected change; server filter snapshot/preview is the accepted mechanism. |
| Email approval link as command authority | **Reject** | Link forwarding, stale content, insufficient authentication, and inaccessible context. | Email may notify; decision remains in authenticated portal with exact content/preview. |
| Free-form notification webhooks | **Reject initially** | Destination/secret/PII/SSRF risk and uncontrolled payloads. | Registered connector contract, allowlisted destination, safe fixed payload, and operations owner. |
| Automatic rollback on every alert | **Reject as universal policy** | Alerts can be wrong or partial; rollback compatibility and safety vary by workflow. | Explicit release-owned health gates and approved automated transition for a named rollout state. |
| Service worker/offline portal mutation | **Reject** | Stale authority, replay, secret caching, and ambiguous commit state. | A measured field requirement and a separate signed offline-command protocol; not expected for administration. |

**RECOMMENDATION.** The browser framework and component library are replaceable implementation choices behind the fixed BFF, screen, command, and accessibility contracts. A technology choice changes only after a bake-off compares the same representative workflows, exact dependencies, accessible semantics, bundle/runtime performance, security posture, maintenance, licensing, testing, team skills, and removal cost.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Common portal contract profile

Every portal route, read model, command, preview, approval, job, notification, audit event, export, deletion target, connector, and support capability MUST record:

```text
contract name and exact semantic version
producer, required consumers, accountable owner, support owner
browser/BFF/domain trust boundary
authenticated authority and realm source
required capability and workflow state
privacy stage and permitted fields
strict closed schema; required/optional/null semantics
identifier, time, digest, enum, Unicode and localization rules
item, page, byte, depth, string, allocation and execution limits
ETag/version and optimistic-concurrency meaning
idempotency identity and replay/conflict behavior
impact-preview and approval requirements
transaction, audit, job and notification meaning
retry, ambiguity, cancellation and recovery behavior
compatibility, rollout, rollback, expiry and deprecation
permitted logs, metrics and support evidence
valid, boundary, invalid, adversarial, old/new and accessibility vectors
runbook, evidence, dependency and cleanup requirements
```

The portal API MUST use strict UTF-8 JSON for the initial profile, closed objects, canonical lower-case UUIDv7 UAM identifiers, explicit UTC instants, finite enums, and RFC 9457 problem details. RFC 9457 standardizes machine-readable HTTP API problem details; UAM must use stable safe problem types/codes and must not echo raw input, secrets, SQL, stack traces, certificate material, or cross-realm identifiers. [W07]

## 5.2 Route and authority conventions

```text
GET    /portal/v1/screens/{screen-id}
GET    /portal/v1/resources/{resource-type}/{resource-id}
POST   /portal/v1/previews/{command-type}
POST   /portal/v1/commands/{command-type}
GET    /portal/v1/jobs/{job-id}
POST   /portal/v1/jobs/{job-id}:cancel
GET    /portal/v1/audit/events
GET    /portal/v1/notifications
POST   /portal/v1/notifications/{notification-id}:acknowledge
POST   /portal/v1/session:switch-realm
```

Rules:

- Realm MUST NOT appear as an authority-bearing route, query, header, or body value. The BFF derives it from the active server-side session.
- Resource IDs are opaque UUIDv7 values; display names are not accepted as identifiers.
- Action names are fixed route/command IDs, not caller-supplied handler names.
- `GET` routes are read-only and have no hidden mutation, lock, audit, workflow, or integration side effect beyond bounded access evidence.
- Mutations use `POST` to explicit commands; generic `PUT/PATCH/DELETE` against persistence resources is not a normal administration contract.
- State-changing routes require same-origin/CSRF proof, a compatible content type, strict body bounds, authentication, current authorization, and current session/realm context.
- Sensitive reads and all commands return `Cache-Control: no-store`; shared proxy caching is disabled.
- The BFF MAY call internal module interfaces in-process, but those interfaces remain typed and separately authorized. It is not a blind reverse proxy.

## 5.3 Screen read-model envelope

```json
{
  "contract": "uam.portal.screen-model",
  "version": "1.0.0",
  "screenId": "fleet.health",
  "titleKey": "fleet.health.title",
  "asOfUtc": "2026-08-01T12:00:00Z",
  "displayTimeZone": "Europe/Amsterdam",
  "freshness": {
    "class": "CURRENT",
    "sourceAsOfUtc": "2026-08-01T11:59:40Z",
    "policyRevision": 42,
    "limitations": []
  },
  "dataQuality": {
    "class": "COMPLETE_FOR_DECLARED_SCOPE",
    "includedCount": 6000,
    "excludedCount": 0,
    "unknownCount": 0,
    "reasonCodes": []
  },
  "capabilities": [
    "fleet.health.read",
    "fleet.filter_snapshot.create"
  ],
  "sections": [],
  "links": [],
  "etag": "\"fictional-screen-version\""
}
```

All values are fictional. `capabilities` supports presentation only; server authorization is repeated on every route. `displayTimeZone` is a display preference, not event-time authority. A screen model MUST NOT contain hidden action endpoints, authorization tokens, secrets, persistence types, or fields not displayed for an authorized purpose.

## 5.4 Paged list contract

```json
{
  "contract": "uam.portal.paged-list",
  "version": "1.0.0",
  "resourceType": "INSTALLATION_OPERATIONAL_SUMMARY",
  "asOfUtc": "2026-08-01T12:00:00Z",
  "sort": [
    { "field": "healthSeverity", "direction": "DESC" },
    { "field": "opaqueId", "direction": "ASC" }
  ],
  "pageSize": 50,
  "nextCursor": "opaque-signed-cursor",
  "items": [],
  "summary": {
    "totalClass": "EXACT",
    "total": 6000,
    "unknown": 0
  },
  "freshness": { "class": "CURRENT" },
  "etag": "\"fictional-page-version\""
}
```

Normative rules:

- pagination is server-side with an opaque, integrity-protected, realm/session/filter/sort-bound cursor;
- sort order is total and stable; the server adds an opaque tie-breaker;
- the browser cannot request arbitrary columns, joins, expressions, regexes, SQL, unbounded page sizes, or hidden fields;
- default and maximum page sizes are **ESTIMATE** until measured; the first prototype uses 50 default and 100 maximum rows;
- count may be `EXACT`, `BOUNDED`, `ESTIMATED`, or `UNKNOWN`; the UI labels it correctly;
- a stale cursor produces a safe `CURSOR_STALE` problem and a restart link, never mixed-snapshot results;
- bulk scope uses the filter snapshot contract below, not page items.

## 5.5 Filter snapshot and impact preview

### 5.5.1 Filter snapshot

```json
{
  "contract": "uam.portal.filter-snapshot",
  "version": "1.0.0",
  "snapshotId": "019d0000-0000-7000-8000-000000002001",
  "resourceType": "INSTALLATION",
  "filterProfileId": "fleet-health-filter-v1",
  "normalizedFilter": {
    "healthClasses": ["DEGRADED", "FAILED"],
    "compatibilityClasses": ["QUALIFIED"]
  },
  "scopeDigest": "sha-256:fictional",
  "resolvedCount": 120,
  "unknownCount": 3,
  "createdAtUtc": "2026-08-01T12:00:00Z",
  "expiresAtUtc": "2026-08-01T12:10:00Z"
}
```

The server owns normalization and resolution. The snapshot contains no raw browser list or hidden personal data and is bound to realm, principal/capability, contract version, and source watermarks.

### 5.5.2 Impact preview request

```json
{
  "contract": "uam.portal.preview-request",
  "version": "1.0.0",
  "commandType": "RELEASE_ROLLOUT_START",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "expectedVersion": 7,
  "scope": {
    "filterSnapshotId": "019d0000-0000-7000-8000-000000002001"
  },
  "parameters": {
    "rolloutPlanId": "019d0000-0000-7000-8000-000000002020"
  }
}
```

### 5.5.3 Impact preview response

```json
{
  "contract": "uam.portal.impact-preview",
  "version": "1.0.0",
  "previewId": "019d0000-0000-7000-8000-000000002030",
  "commandType": "RELEASE_ROLLOUT_START",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "resourceVersion": 7,
  "scopeDigest": "sha-256:fictional-scope",
  "commandDigest": "sha-256:fictional-command",
  "previewDigest": "sha-256:fictional-preview",
  "generatedAtUtc": "2026-08-01T12:01:00Z",
  "expiresAtUtc": "2026-08-01T12:06:00Z",
  "riskClass": "HIGH",
  "affected": {
    "eligible": 117,
    "excluded": 3,
    "unknown": 3,
    "alreadyInDesiredState": 0
  },
  "exclusionReasonCounts": [
    { "reasonCode": "COMPATIBILITY_UNKNOWN", "count": 3 }
  ],
  "changes": [],
  "dependencies": [],
  "safetyControls": {
    "staged": true,
    "killSwitchAvailable": true,
    "rollbackCandidateAvailable": true
  },
  "requiredApprovals": ["RELEASE_ROLLOUT_APPROVAL"],
  "limitations": []
}
```

A preview MUST state:

- exact realm-scoped resource and command type;
- before/after or semantic diff;
- resolved, excluded, unknown, stale, offline, unsupported, held, and already-satisfied counts;
- affected data/capability classes and privacy-ceiling relation;
- dependencies, compatibility, rollout, audit, export, deletion, integration, and support effects where relevant;
- approval classes required by current human policy;
- recovery, pause, kill, and rollback availability;
- generation/expiry and content/scope digests.

Preview and execution are separate operations. Execution recomputes current preconditions and scope. Any changed resource version, policy, capability, approval, filter snapshot, source watermark, kill state, or resolved scope returns `PREVIEW_STALE`; the server never silently applies the old preview to the new world.

## 5.6 Command envelope

```json
{
  "contract": "uam.portal.command",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000002100",
  "commandType": "RELEASE_ROLLOUT_START",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "expectedVersion": 7,
  "previewId": "019d0000-0000-7000-8000-000000002030",
  "previewDigest": "sha-256:fictional-preview",
  "reasonCode": "PLANNED_RELEASE",
  "approvalIds": [
    "019d0000-0000-7000-8000-000000002110"
  ],
  "parameters": {
    "rolloutPlanId": "019d0000-0000-7000-8000-000000002020"
  }
}
```

The HTTP request MUST also carry `If-Match` for revisioned resources. RFC 9110 defines validators and conditional request semantics; UAM uses `If-Match` to prevent lost updates, while the domain version in the body supports audit and deterministic command validation. [W08]

Normative command rules:

1. The BFF supplies actor, realm, authentication context, request time, and correlation/operation token. The body cannot override them.
2. `commandId` is the idempotency identity. Same realm/command ID and same command digest returns the prior result; same ID and different digest is `IDEMPOTENCY_CONFLICT`.
3. `expectedVersion` and `If-Match` are mandatory for revision/state resources. Mismatch is `STALE_VERSION` with no mutation.
4. A preview is mandatory for high-impact or bulk commands; the command digest must match the preview.
5. `reasonCode` is a finite release-owned enum. An optional bounded comment is disabled by default and requires a separate privacy/retention decision.
6. Approval IDs are references to exact approved content/preview digests. The server retrieves and validates them; the body does not assert approval claims.
7. The domain transition and authoritative audit insert occur in one transaction. Audit failure rolls back the transition.
8. If work continues asynchronously, the transaction creates a durable job/outbox row and returns `202 Accepted` with a job contract. `202` means a durable command/job exists, not that the outcome completed.
9. A browser retry uses the same `commandId`. The UI never generates a new command because the response was lost.
10. Command handlers return only finite safe outcomes and no dynamic exception text.

## 5.7 Command result and asynchronous job

### 5.7.1 Immediate result

```json
{
  "contract": "uam.portal.command-result",
  "version": "1.0.0",
  "commandId": "019d0000-0000-7000-8000-000000002100",
  "outcome": "ACCEPTED",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "resourceVersion": 8,
  "jobId": "019d0000-0000-7000-8000-000000002120",
  "auditEventId": "019d0000-0000-7000-8000-000000002130",
  "acceptedAtUtc": "2026-08-01T12:02:00Z",
  "links": {
    "job": "/portal/v1/jobs/019d0000-0000-7000-8000-000000002120",
    "resource": "/portal/releases/019d0000-0000-7000-8000-000000002010"
  }
}
```

### 5.7.2 Job model

```json
{
  "contract": "uam.portal.job-status",
  "version": "1.0.0",
  "jobId": "019d0000-0000-7000-8000-000000002120",
  "jobType": "RELEASE_ROLLOUT",
  "state": "RUNNING_RING",
  "stateVersion": 4,
  "createdAtUtc": "2026-08-01T12:02:00Z",
  "updatedAtUtc": "2026-08-01T12:05:00Z",
  "scopeDigest": "sha-256:fictional-scope",
  "progress": {
    "currentStage": "RING_1",
    "completed": 10,
    "succeeded": 9,
    "failed": 1,
    "deferred": 0,
    "unknown": 0,
    "total": 10
  },
  "availableActions": ["PAUSE", "ABORT"],
  "safeIssueCodes": ["HEALTH_GATE_FAILED"],
  "recoveryLinks": []
}
```

Jobs preserve the first failure and every retry/transition. Browser loss or refresh does not lose state. Real-time updates MAY use server-sent events or polling; the transport is presentation only. The browser always reconciles from the durable job resource after reconnect. WebSocket/SSE messages do not authorize or prove completion.

## 5.8 Approval contract

```json
{
  "contract": "uam.portal.approval-request",
  "version": "1.0.0",
  "approvalRequestId": "019d0000-0000-7000-8000-000000002200",
  "approvalClass": "RELEASE_ROLLOUT_APPROVAL",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "resourceVersion": 7,
  "contentDigest": "sha-256:fictional-content",
  "previewDigest": "sha-256:fictional-preview",
  "requestedAtUtc": "2026-08-01T12:01:30Z",
  "expiresAtUtc": "2026-08-02T12:01:30Z",
  "state": "PENDING"
}
```

```json
{
  "contract": "uam.portal.approval-decision",
  "version": "1.0.0",
  "approvalDecisionId": "019d0000-0000-7000-8000-000000002210",
  "approvalRequestId": "019d0000-0000-7000-8000-000000002200",
  "decision": "APPROVE",
  "reasonCode": "REVIEW_COMPLETED",
  "expectedRequestVersion": 1
}
```

Approval policies are immutable revisions that define required capability combinations, independence constraints, quorum if any, expiry, re-authentication, and emergency behavior. These values are **HUMAN DECISION**. The technical mechanism enforces whatever approved policy exists; absent policy means high-risk production execution remains disabled.

## 5.9 Audit event contract

```json
{
  "contract": "uam.audit.privileged-event",
  "version": "1.0.0",
  "auditEventId": "019d0000-0000-7000-8000-000000002130",
  "realmId": "server-context-only-in-production",
  "actorPrincipalId": "019d0000-0000-7000-8000-000000002300",
  "authorityContextDigest": "sha-256:fictional-authority",
  "actionType": "RELEASE_ROLLOUT_START",
  "resourceType": "RELEASE",
  "resourceId": "019d0000-0000-7000-8000-000000002010",
  "commandId": "019d0000-0000-7000-8000-000000002100",
  "reasonCode": "PLANNED_RELEASE",
  "approvalDecisionIds": [
    "019d0000-0000-7000-8000-000000002210"
  ],
  "beforeStateDigest": "sha-256:fictional-before",
  "afterStateDigest": "sha-256:fictional-after",
  "previewDigest": "sha-256:fictional-preview",
  "outcome": "COMMITTED",
  "occurredAtUtc": "2026-08-01T12:02:00Z"
}
```

Production realm is derived and stored by the server, not accepted from this example body. Audit MUST record denied and conflict outcomes when they are security- or governance-relevant, but it must remain minimized. It must not contain raw policy payload, activity data, selector text, connector secret, URL, path, SQL, arbitrary comment, exception, or request body. Corrections create new linked events; normal administrators cannot edit or delete prior events.

## 5.10 Notification contract

```json
{
  "contract": "uam.portal.notification",
  "version": "1.0.0",
  "notificationId": "019d0000-0000-7000-8000-000000002400",
  "type": "ROLLOUT_AUTO_PAUSED",
  "severity": "HIGH",
  "state": "OPEN",
  "subjectResourceType": "ROLLOUT",
  "subjectResourceToken": "opaque-case-scoped-token",
  "titleKey": "notification.rollout_auto_paused.title",
  "bodyKey": "notification.rollout_auto_paused.body",
  "reasonCodes": ["HEALTH_GATE_FAILED"],
  "createdAtUtc": "2026-08-01T12:05:00Z",
  "dedupeKey": "opaque-finite-key",
  "link": "/portal/releases/rollouts/opaque"
}
```

Templates are localized by key and bounded parameters. Email or webhook notifications, if later approved, contain no sensitive data and direct the recipient to the authenticated portal. Notification acknowledgement is not incident resolution, approval, or business completion.

## 5.11 Error taxonomy and RFC 9457 profile

| UAM code | HTTP class | Meaning | UI recovery |
|---|---:|---|---|
| `AUTHENTICATION_REQUIRED` | 401 | No current authenticated session | Accessible sign-in/re-auth route |
| `REAUTHENTICATION_REQUIRED` | 403 | Current auth context insufficient for named action | Re-authenticate, preserve safe draft |
| `FORBIDDEN` | 403 | Capability/resource/state denied | Return to authorized page; no existence detail |
| `REALM_CONTEXT_MISMATCH` | 403 | Session/request resource context does not match | Clear page state; select authorized realm |
| `APPROVAL_REQUIRED` | 409 | Required approval absent/expired/invalid | Open exact approval request |
| `INVALID_CONTRACT` | 400 | Closed schema/field/bound violation | Error summary linked to fields |
| `UNSUPPORTED_VERSION` | 409 | Client/server contract incompatible | Reload/update client; do not coerce |
| `AMBIGUOUS_SELECTOR` | 409 | Selector resolves to more than one authorized target | Refine through explicit choices |
| `STALE_VERSION` | 412 | `If-Match`/domain version changed | Show safe diff; reload/re-preview |
| `PREVIEW_STALE` | 409 | Scope, policy, state, or preview changed | Generate a new preview |
| `IDEMPOTENCY_CONFLICT` | 409 | Same command ID, different command digest | Stop; investigate client/session |
| `CURSOR_STALE` | 409 | Paged snapshot no longer valid | Restart list with preserved filters |
| `SAFETY_HOLD` | 423 | Security/privacy/compatibility hold | Show runbook and authorized recovery only |
| `KILL_SWITCH_ACTIVE` | 423 | Action disabled by effective kill state | Explain scope/revision; no bypass |
| `INCOMPATIBLE_RELEASE` | 409 | Exact release/control compatibility failed | Select supported path or stop |
| `DEPENDENCY_UNAVAILABLE` | 503 | Required internal dependency unavailable | Same-id retry or wait; current state visible |
| `PARTIAL_DATA` | 200/206 profile | Read model is incomplete | Label included/excluded/unknown and restrict actions |
| `STALE_DATA` | 200 profile | Last known data exceeds freshness policy | Show as-of and refresh/recovery |
| `SOURCE_OFFLINE` | 200 profile | Operational source not currently connected | Do not interpret as no activity |
| `DETAIL_SUPPRESSED` | 403/404 profile | Detail is not authorized/implemented | Stay aggregate-first |
| `WAITING_EXTERNAL` | 202 profile | External target has no terminal evidence | Show capability/owner/limitation |
| `PARTIAL_HELD` | 200 profile | Suppression active; destruction blocked by hold | Preserve invisibility; show held targets |
| `COMPLETE_WITH_LIMITATIONS` | 200 profile | Technical work completed except uncontrolled scope | Display limitation prominently |
| `UNKNOWN` | 500/503 | Unclassified safe failure | Fail closed; operation token/support path |

Example:

```json
{
  "type": "https://errors.uam.invalid/preview-stale",
  "title": "The impact preview is no longer current",
  "status": 409,
  "code": "PREVIEW_STALE",
  "operationToken": "opaque-support-token",
  "instance": "/portal/v1/commands/RELEASE_ROLLOUT_START",
  "recovery": {
    "action": "REPREVIEW",
    "link": "/portal/releases/opaque/preview"
  }
}
```

The actual production problem-type origin is an approved UAM documentation origin. Problem bodies never contain a raw resource name, query, SQL, stack, internal address, certificate, policy payload, or cross-realm hint.

## 5.12 Export format profile

A production export is a named data product, not “download this table.” Its manifest binds:

```text
export ID and revision
realm and actor from authenticated context
approved purpose and field profile
scope manifest and digest
source as-of/freshness/data-quality
format profile and schema version
recipient class and delivery method
row/byte/time limits
creation, expiry and retrieval state
content digest, encryption/key profile, scan evidence
external-copy and deletion capability class
approval/reason/audit references
```

CSV, if authorized, MUST use a defined encoding/delimiter profile and neutralize spreadsheet formula interpretation for cells beginning with formula-active characters. A structured JSON/NDJSON or signed report may be safer for machine use. Exact formats are **HUMAN DECISION** and **CLI EXPERIMENT**. The portal never provides an arbitrary column picker over hidden data.

## 5.13 Integration revision contract

```json
{
  "contract": "uam.integration.revision",
  "version": "1.0.0",
  "connectorId": "019d0000-0000-7000-8000-000000002500",
  "revision": 3,
  "connectorType": "APPROVED_DIRECTORY_CONTRACT_V1",
  "purposeId": "fictional-approved-purpose",
  "destinationClass": "REGISTERED_INTERNAL_SERVICE",
  "destinationReferenceId": "019d0000-0000-7000-8000-000000002501",
  "secretReferenceId": "019d0000-0000-7000-8000-000000002502",
  "contractVersion": "1.0.0",
  "deletionCapability": "OBJECT_DELETE_WITH_RECEIPT",
  "state": "DRAFT",
  "configurationDigest": "sha-256:fictional"
}
```

The destination and secret references are resolved only in server infrastructure under allowlist and egress controls. The browser cannot read or submit raw secrets, DNS names, IP addresses, URLs, arbitrary headers, scripts, or certificates. A connector test uses a fixed capability and records a safe result; it is not a browser-originated fetch.

## 5.14 Compatibility rules

- Browser assets and BFF contracts deploy consumer-first or atomically from the same release; the server supports only explicit bounded compatibility windows.
- A stale browser client receives `UNSUPPORTED_VERSION` and reload guidance; the server does not silently reinterpret a command.
- In-progress drafts record their schema version and migration status. Unsupported drafts are read-only until a governed migration or new draft.
- A workflow state is never inferred from visual component state or URL.
- A design-system upgrade requires exact component visual/semantic/keyboard/AT snapshots and representative workflow tests, not only package tests.
- Exact browser/AT/dependency versions are execution-time evidence and expire on major changes, security incidents, accessibility regressions, or policy review.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.0 Workflow/state diagrams — mandatory artifact

The diagrams in sections 6.1–6.10 are the normative portal workflow views. They identify legal transitions, transaction and approval boundaries, cancellation/kill/rollback paths, stale or ambiguous outcomes, and the UI recovery state after browser, BFF, worker, or dependency failure. Visual styling is non-authoritative; server state and transition contracts are authoritative.

## 6.1 Generic revision workflow

```text
DRAFT
  -> VALIDATING
       -> DRAFT_WITH_ERRORS
       -> REVIEW_REQUIRED
  -> ABANDONED

REVIEW_REQUIRED
  -> CHANGES_REQUESTED -> DRAFT
  -> APPROVED
  -> EXPIRED

APPROVED
  -> SCHEDULED
  -> PUBLISHING
  -> INVALIDATED_BY_CONTENT_CHANGE -> DRAFT
  -> EXPIRED

SCHEDULED / PUBLISHING
  -> PUBLISHED
  -> FAILED_NO_ACTIVATION
  -> SAFETY_HOLD

PUBLISHED
  -> SUPERSEDED
  -> REVOKED / EMERGENCY_NARROWED
  -> ROLLBACK_REQUESTED
       -> new higher revision containing prior approved semantics
```

Rules:

- content is immutable once submitted for review; an edit creates a new draft content digest and invalidates preview/approval;
- approval binds resource version, content digest, preview digest, approval class, actor, and expiry;
- publishing creates one atomic active-revision transition and audit; partial activation is explicit and cannot be represented as `PUBLISHED`;
- rollback never decrements revision or sequence;
- a failed candidate does not overwrite an unexpired valid active revision unless the failure is security-significant and the domain state machine requires `SAFETY_HOLD`;
- the UI cannot set state directly; it submits one legal transition command.

This workflow applies with domain-specific validation to policy, application metadata, rules, notification policy, capability mappings, and connector revisions.

## 6.2 Policy workflow

```text
DRAFT
  -> STRUCTURAL_VALIDATION
  -> MONOTONIC_NARROWING_PROOF
  -> IMPACT_PREVIEW
  -> REVIEW_REQUIRED
  -> APPROVED
  -> SCHEDULED
  -> VERIFIED_PENDING_EFFECTIVE
  -> ACTIVE
  -> SUPERSEDED

Any broadening, wrong realm, rollback, same-revision conflict,
signature/key/chain failure -> SAFETY_HOLD
Ordinary malformed/unsupported candidate -> QUARANTINED_CANDIDATE
Active expiry/corruption with no valid authority -> COLLECTION_DISABLED
```

The portal displays product ceiling, tenant draft, emergency/local restrictions, and effective meet separately. It never presents the tenant draft as the final effective policy until the server has computed and verified it.

## 6.3 Application import and rule workflow

### 6.3.1 Import

```text
FILE/FEED_REGISTERED
  -> STAGED
  -> PROFILED
  -> VALIDATED
       -> REJECTED
       -> REVIEW_REQUIRED
  -> PREVIEWED
  -> APPROVED
  -> COMMITTING
       -> COMMITTED
       -> FAILED_NO_PARTIAL_IMPORT
  -> RECONCILED
```

The first T1 import fixture contains 173 wholly fictional applications and reproduces the safe quality shape from I02. Missing external references become quality warnings, not new identity rules. Duplicate/non-unique conditions become explicit conflicts. No application rule is automatically created from an imported name or reference.

### 6.3.2 Rule and snapshot

```text
RULE_DRAFT
  -> NORMALIZATION_VALIDATED
  -> OVERLAP/SHADOW/AMBIGUITY_ANALYZED
       -> BLOCKED_UNKNOWN
       -> REVIEW_REQUIRED
  -> APPROVED
  -> SNAPSHOT_BUILDING
  -> SNAPSHOT_VALIDATED
  -> SNAPSHOT_AUTHORIZED
  -> PUBLISHED_HIGHER_SEQUENCE
  -> ACTIVE
  -> SUPERSEDED / REVOKED
```

Cross-target equally maximal matches remain `AMBIGUOUS`; author order, row order, name, creation time, and lexical UUID cannot resolve them. Snapshot rollback is a higher sequence referencing prior semantics.

## 6.4 Release rollout workflow — mandatory diagram

```text
RELEASE_VERIFIED
  -> ROLLOUT_DRAFT
  -> IMPACT_PREVIEWED
  -> APPROVAL_PENDING
  -> SCHEDULED
  -> RUNNING_RING_0
       -> HEALTH_GATE_PASS -> RUNNING_RING_1
       -> HEALTH_GATE_FAIL -> AUTO_PAUSED
       -> OPERATOR_PAUSE   -> PAUSED
       -> KILL             -> ABORTING
  -> RUNNING_RING_N ...
       -> COMPLETED
       -> PAUSED
       -> AUTO_PAUSED
       -> ABORTING

PAUSED / AUTO_PAUSED
  -> REPREVIEWED + AUTHORIZED_RESUME -> RUNNING_CURRENT_RING
  -> ROLLBACK_REQUESTED
  -> ABORTING

ROLLBACK_REQUESTED
  -> ROLLBACK_PREVIEWED
  -> APPROVED
  -> ROLLING_BACK_HIGHER_SEQUENCE
  -> ROLLED_BACK / ROLLBACK_FAILED_SAFETY_HOLD

ABORTING
  -> ABORTED_WITH_CURRENT_STATE_RECONCILED
```

Rules:

- ring definitions are immutable release-owned or approved plan revisions;
- the server resolves eligible scope at each ring under current compatibility, policy, identity, safety, and kill state;
- unknown/incompatible/offline endpoints are counted and never silently treated as success;
- health gates use finite release-owned metrics and approved thresholds; exact thresholds are **HUMAN DECISION/ESTIMATE**;
- resume always requires a new preview because scope and evidence may have changed;
- kill switch activation is a separate narrowing transition available during partial rollout control-plane degradation;
- rollback selects independently verified prior bytes and compatibility; it is not a client-side state reversal;
- UI progress derives from durable rollout/job state, not optimistic local counts.

## 6.5 Bulk-action workflow

```text
FILTER_ENTERED
  -> SERVER_NORMALIZED
  -> FILTER_SNAPSHOT_CREATED
  -> SCOPE_RESOLVED
  -> IMPACT_PREVIEWED
  -> OPERATOR_REVIEWS_INCLUDED/EXCLUDED/UNKNOWN
  -> APPROVAL_PENDING (when policy requires)
  -> EXECUTE_WITH_PREVIEW_DIGEST
       -> PREVIEW_STALE -> RESTART
       -> JOB_ACCEPTED
  -> CHUNKED_DOMAIN_WORK UNDER ONE PARENT COMMAND
  -> RECONCILED
       -> COMPLETED
       -> COMPLETED_WITH_LIMITATIONS
       -> FAILED / SAFETY_HOLD
```

No checkbox, client list, visible page, or count is authoritative. The parent command records the immutable scope digest and child operation identities. Partial results are explicit. Retry reuses identities and cannot reapply a completed child effect.

## 6.6 Kill-switch lifecycle

```text
INACTIVE(sequence N)
  -> ACTIVATE_REQUESTED
  -> AUTHORIZED
  -> ACTIVE(sequence N+1, narrower scope)
  -> PROPAGATING
  -> EFFECTIVE / PARTIAL_EFFECTIVE

ACTIVE
  -> EXTEND_WITH_HIGHER_SEQUENCE
  -> CLEAR_REQUESTED
       -> RECOVERY_EVIDENCE_VALIDATED
       -> APPROVED
       -> CLEARED_BY_HIGHER_SEQUENCE
       -> REJECTED / SAFETY_HOLD
```

Activation must be possible through a minimal, explicit, accessible route with current realm/environment visible. It cannot require loading a heavy dashboard or healthy downstream integration. Clearing never happens automatically on expiry; expiry moves to an explicit safe state determined by the control policy, normally remaining disabled until authorized recovery.

## 6.7 Export lifecycle

```text
DRAFT
  -> PURPOSE/FIELD/SCOPE_VALIDATED
  -> IMPACT_PREVIEWED
  -> APPROVAL_PENDING
  -> GENERATION_QUEUED
  -> GENERATING
       -> SCHEMA/CANARY/BOUND_PASS
       -> FAILED_NO_DELIVERY
  -> READY_ENCRYPTED
  -> RETRIEVED / EXPIRED / REVOKED
  -> DELETION_PENDING
  -> DELETED

RETRIEVED -> EXTERNAL_COPY_UNCONTROLLED (truthful persistent limitation)
```

A revoked or expired export is no longer downloadable. Retrieval creates audit evidence. UAM cannot erase a copy already retrieved by a human or unsupported recipient; the UI must retain that limitation rather than return to an unqualified green state.

## 6.8 Deletion/lifecycle state machine — mandatory diagram

```text
DRAFT
  -> AUTHORIZED
  -> RESOLVING
       -> AMBIGUOUS / REJECTED
       -> RESOLVED
  -> BARRIER_COMMIT_PENDING
  -> BARRIER_COMMITTED (ordinary visibility suppressed)
  -> EXECUTING
       -> WAITING_EXTERNAL
       -> PARTIAL_HELD
       -> RETRY_WAIT
  -> VERIFYING
       -> EXECUTING
       -> FAILED
       -> COMPLETE
       -> COMPLETE_WITH_LIMITATIONS
```

Before `BARRIER_COMMITTED`, cancellation may end the case with no visibility change. After the barrier, an operator may pause destruction, but cannot remove suppression. The portal shows technical state and limitations; it does not decide or claim the legal outcome of a rights request.

## 6.9 Integration lifecycle

```text
DRAFT
  -> STRUCTURAL_VALIDATION
  -> SERVER_SIDE_CONNECTIVITY_TEST
       -> TEST_FAILED
       -> REVIEW_REQUIRED
  -> APPROVED
  -> ACTIVATING
  -> ACTIVE
  -> DEGRADED / SAFETY_HOLD
  -> DEACTIVATING
  -> INACTIVE
  -> DELETION/RETENTION_RECONCILIATION
  -> RETIRED
```

A configuration or secret-reference change creates a new immutable revision and requires a new test/review/activation. The previous active revision remains until the activation transaction succeeds. Test success does not imply production deletion capability or recipient-side compliance.

## 6.10 Diagnostic permit and support bundle lifecycle

```text
D0_BASELINE
  -> PERMIT_DRAFT
  -> IMPACT/CONTENT PREVIEW
  -> APPROVAL_PENDING
  -> ACTIVE_D1_OR_D2
  -> SAFE_SNAPSHOT_FROZEN
  -> BUNDLE_BUILT_IN_MEMORY
  -> SCHEMA/CANARY/CARDINALITY_PASS
  -> ENCRYPTED
  -> LOCAL_HANDOFF_OR_AUTHENTICATED_UPLOAD
  -> CUSTODY/CASE_STATE
  -> EXPIRED / REVOKED / DELETED

Any wrong realm/target/release, forbidden field, canary, clock,
expiry, revocation or config mismatch -> DIAGNOSTIC_SAFETY_HOLD
```

There is no raw D3 level, arbitrary command, debugger, dump, file selector, or generic log collection route.

## 6.11 Notification and escalation state

```text
EVENT_OCCURRED
  -> DEDUPED/AGGREGATED
  -> NOTIFICATION_OPEN
  -> DELIVERED_IN_PORTAL
  -> ACKNOWLEDGED
  -> RESOLVED_BY_DOMAIN_STATE
  -> CLOSED

Delivery failure -> RETRY_WAIT / CHANNEL_DISABLED
Notification ACK does not resolve domain incident
Domain resolution closes linked notifications through a typed event
```

Channel, recipient, urgency, working hours, acknowledgement deadline, and escalation responsibility are **HUMAN DECISION**. The temporary default is in-portal delivery to the initiating T1 persona and no external channel.

## 6.12 Transaction boundaries

| Operation | Atomic unit | Must be in same transaction | Must be outside transaction |
|---|---|---|---|
| Draft save | One immutable draft revision/update under expected version | revision, content digest, state, minimal audit | external validation, notifications |
| Submit for review | State transition | review request, content/preview binding, audit | notification delivery |
| Approval decision | One decision transition | decision, authority context, exact digests, audit | notification delivery |
| Publish/activate | One active-revision transition | prior/current relation, new active state, job/outbox if needed, audit | endpoint/network propagation |
| High-risk command accept | One parent command | idempotency record, preview binding, job/outbox, resource state, audit | long-running work, external I/O |
| Kill-switch activate | One control revision | higher sequence, scope, reason, effective state, audit/outbox | propagation/reconciliation |
| Export request | One export case | manifest/scope/purpose, job, audit | query/generation/encryption/delivery |
| Deletion barrier | One lifecycle transaction | case state, tombstone/barrier, visibility epoch, targets/outbox, audit | physical deletion/external calls |
| Integration activation | One revision transition | active pointer, revision/digest, job/outbox, audit | connectivity/delivery |
| Support permit activation | One permit transition | target/scope/expiry, audit, activation outbox | bundle collection/upload |

The browser response may be lost after commit. Retrying the same command ID returns the committed result. A transport response is never itself the business transaction evidence.

## 6.13 Compatibility and rollout rules

1. Browser and BFF contract versions are exact and content-bound to the release.
2. Consumers are deployed before producers where versions overlap; unsupported commands fail closed rather than coercing fields.
3. A browser asset release is promoted by the same signed digest through environments; environments do not rebuild it.
4. Component-library and browser upgrades rerun keyboard, AT, contrast, zoom, forced-colors, reduced-motion, localization, visual and semantic regressions for all critical workflows.
5. A workflow transition added in a new release is inaccessible to an old client unless the compatibility matrix explicitly supports it.
6. Feature flags do not substitute for schema/state compatibility; disabled code still cannot be an unreviewed hidden production action.
7. A rollback must preserve draft/job/audit readability for the declared compatibility window. Incompatible control-store migrations are enterprise maintenance, not autonomous portal activation.

---

# 7. Security/privacy threat and failure register

## 7.1 Threat-model assumptions

The portal threat model includes:

- unauthenticated internet/client attacks;
- authenticated principals with insufficient or wrong-realm authority;
- compromised browser content, extension, or session;
- malicious or mistaken authorized administrator;
- stale browser state and concurrent administrators;
- compromised connector or notification destination;
- dependency/design-system/supply-chain defect;
- database, cache, projection, job, audit, notification, IdP, and network failures;
- accessibility barriers that cause an operator to misunderstand scope or recovery;
- operational pressure that encourages direct DB or hidden bypasses.

A local/server administrator, signing-root compromise, malicious signed release, or database superuser can exceed ordinary portal controls; containment relies on release, infrastructure, audit, separation, monitoring, restore, and human governance. This residual risk must remain explicit.

## 7.2 Consolidated register

| ID | Trigger / threat | Detection | Containment | Recovery and cleanup | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|
| T20-01 | Cross-realm IDOR or guessed resource ID | Realm-negative contract tests; audit/security alert on mismatched context; repository invariant | Realm from session; realm-first keys; generic deny/not-found; no cross-realm cache | Revoke session; investigate audit; invalidate caches; verify no read/export | IAM + Portal Security | Every read/command with same UUID in two fictional realms; property tests | Privileged infrastructure roles may bypass app layer |
| T20-02 | Browser-supplied realm or role becomes authority | Schema/API architecture tests; forbidden field mutation | Realm/actor structurally absent from bodies; server-created context | Reject build; remove field; replay negative suite | Portal/BFF owner | Inject body/query/header/route realm and role values | Misconfigured gateway/session middleware |
| T20-03 | Hidden button or client route is sole authorization | Direct endpoint tests without UI; capability catalogue reconciliation | Server reauthorizes every request; deny by default | Disable affected command; review all routes; add mutation test | IAM + Domain owner | Call every action directly as every synthetic capability set | Human policy mapping can still overgrant |
| T20-04 | CSRF or session fixation executes command | Same-site/origin/CSRF telemetry; session anomaly | HttpOnly Secure SameSite session; rotation; anti-CSRF; strict content type/origin | Revoke sessions; rotate keys; audit affected commands; user notification policy | IAM/Portal Security | Cross-site form/fetch, missing/duplicate token, pre/post-login session ID | Browser/IdP implementation defects |
| T20-05 | XSS through catalogue name, Unicode, truncation marker, connector label, error | CSP reports; canary; DOM sink tests | Text rendering; no raw HTML; sanitization only for approved rich text; CSP nonces; no unsafe eval | Kill affected route; revoke sessions; remove payload from projections; dependency patch | Front-end/AppSec | Fictional `<script>`, bidi, control, long/truncated, IPv4-like values across all sinks | Browser extensions and compromised dependencies |
| T20-06 | Mass assignment/generic mutation changes hidden fields | Contract rejection metrics; architecture scan | Closed command DTO; explicit mapping; no ORM entity binding or generic PATCH | Roll back release; audit/reconcile changed records | Domain + AppSec | Unknown/case-variant/duplicate/nested fields; hidden state/realm attempts | Developer may add an unsafe endpoint later |
| T20-07 | Lost update or stale browser overwrites newer revision | `STALE_VERSION` events; version/audit reconciliation | `If-Match`, expectedVersion, immutable revisions, no last-write-wins | Reload safe diff; recreate preview/approval; same-id retry | Domain owner | Two concurrent admins edit/approve/publish every revision type | Users may intentionally recreate old semantics |
| T20-08 | Impact preview TOCTOU changes bulk scope | Preview/scope digest mismatch; scope count drift | Short-lived server snapshot; execute recomputes; `PREVIEW_STALE` | Re-preview; no partial command accepted | Domain + Data correctness | Add/remove/change resources between preview and execution | Rapidly changing fleets can create operational friction |
| T20-09 | Client “select all” omits hidden pages or expands unexpectedly | Parent/child reconciliation; count mismatch | Server-resolved immutable filter snapshot; explicit unknown/excluded counts | Cancel before commit; reconcile child jobs; new preview | Portal/Product | 10k fictional rows, pagination, concurrent changes, filter localization | Snapshot may be expensive under load |
| T20-10 | Approval bypass, reuse, self-approval, or approval of changed content | Approval/content digest audit; policy evaluator alert | Exact digest binding, expiry, state version, separation policy, reauth | Revoke approval; hold command; investigate audit; republish policy | Governance/IAM | Self, wrong capability, wrong realm, expired, changed content, replay | Separation policy itself may be weak or ceremonial |
| T20-11 | Privileged mutation commits without audit | Transaction invariant/reconciler; missing-audit hard alert | Business transition and audit insert in same transaction | Safety hold affected command; restore/reconcile; no manual DB fix as normal path | Domain + Audit owner | Failpoint before/after transition/audit/commit/response | DB superuser or storage corruption |
| T20-12 | Audit leaks raw data or secrets | Schema/canary scan; forbidden-key analyzer | Minimal typed audit shell; digests and opaque tokens; strict access | Quarantine event export; remove projection; incident/deletion under authority | Security/Privacy | Canary in command fields/errors/selectors; search/export audit | Digests can remain linkable; privileged readers exist |
| T20-13 | Audit tampering/deletion | Append-only constraints; chain/reconciliation/backup tests; privileged audit | Separate roles, immutable rows, durable backup/archive, alert on gap | Restore isolated; compare digests; hold production mutations | Audit/Data reliability | Update/delete attempts, backup restore, gap/fork injection | Database superuser/root compromise |
| T20-14 | Feature flag or kill switch broadens authority or bypasses invariant | Static narrowing proof; capability catalogue diff; runtime assertion | Finite values; only disable/narrow; hardcoded non-bypassable invariants | Activate product kill; revert higher sequence; investigate | Release/Product Security | Mutation attempts to enable forbidden field, bypass audit/tombstone/realm | Malicious signed release can change catalogue |
| T20-15 | Kill switch unavailable during incident | Synthetic dependency outage; route SLO/health | Minimal independent route/read model; cached current control state; no heavy dashboard dependency | Out-of-band signed product control; recovery runbook; reconcile propagation | Incident/Control-plane owner | DB read pressure, projection/notification down, stale browser, AT-only operation | Total control-plane outage may require enterprise release action |
| T20-16 | Export exfiltrates hidden fields or formula payload | Export schema/canary scan; manifest/row reconciliation | Named field profile; preview/approval; server generation; formula-neutralization; encryption/expiry | Revoke download; delete object/key; audit recipients; incident process | Export/Data Governance | Hidden-field, CSV formula, oversized, stale scope, wrong realm, link forwarding | Retrieved external copies cannot be recalled |
| T20-17 | Arbitrary connector destination causes SSRF or secret leak | Egress deny logs; destination registry mismatch; secret-access audit | Allowlisted destination class/reference; server DNS/IP/route policy; opaque secrets; no raw URL | Deactivate connector; rotate secret; block egress; reconcile deliveries | Integration/Security | Loopback/link-local/internal metadata, DNS rebinding, redirects, header injection | Approved destination may itself be compromised |
| T20-18 | Connector test is mistaken for delivery/deletion capability | State/receipt reconciliation | Separate test, active, delivery, custody, and deletion states; exact capability contract | Correct status; retry/query same identity; show limitation | Integration owner | HTTP success without terminal receipt; ambiguous response; unsupported delete | Recipient-side truth may remain unverifiable |
| T20-19 | Support workflow becomes remote shell/file/dump channel | Contract/analyzer/canary; bundle manifest | Closed D0–D2 catalogue; fixed permits; no arbitrary strings/paths/files/commands/dumps | Revoke permit; delete bundle; rotate keys; incident | Support/Security/Privacy | Unknown field, path, command, dump, expired permit, wrong target/realm | Some failures may remain undiagnosable without raw data |
| T20-20 | Dynamic exception/log leaks raw input or internal details | All-sink canaries; log-schema linter | Finite safe codes; generic problem details; no exception object/string APIs in portal boundary | Disable noisy route; purge where authorized; add regression | AppSec/Observability | Malformed Unicode/JSON/connector/catalogue inputs through every error path | Third-party middleware may log before UAM filters |
| T20-21 | Metric cardinality leaks or overloads observability | Series-budget test; unknown-label rejection | Fixed labels: route class, action class, result family, freshness class, build ring; no IDs/names | Drop unsafe instrument/config; purge/retention process; incident | SRE/Privacy | Adversarial distinct IDs/names/reason strings | Rare finite combinations may still identify small groups |
| T20-22 | Stale/offline/partial state shown as no activity or success | UI semantic snapshot; task test; data-quality invariant | Explicit classes, as-of, denominator, unknown/excluded counts; actions restricted | Correct projection; notification; retrain/runbook; audit decisions made on stale data | Product/Data Quality | Offline fleet, partial projection, stale cache, zero count, unknown denominator | Users may still misinterpret despite labels |
| T20-23 | Cache/service worker/browser history exposes another realm/session | Cache headers; realm-switch test; browser storage scan | No-store; no sensitive service-worker cache; realm-bound keys; clear client state on switch/logout | Revoke session; clear caches/site data; incident if shared device | Portal Security | Back/forward, multi-tab, logout, switch realm, shared browser profile | Browser/extension may retain screenshots/history |
| T20-24 | Clickjacking or deceptive environment/realm leads wrong action | CSP/frame tests; usability study | `frame-ancestors`; visible text environment/realm; confirm exact scope; no color-only cues | Revoke session; audit command; rollback if safe | AppSec/Product | iframe attempts, zoom/mobile, high contrast, multiple environments | Social engineering outside browser |
| T20-25 | Expensive search/filter/preview/export causes denial | Per-route cost telemetry; queue/backlog; generator load | Bounded grammar, pagination, rate/cost budgets, async jobs, cancellation, quotas | Throttle/pause feature; kill specific capability; drain/reconcile | SRE/Domain owner | Worst-case filters, concurrent previews/exports, cancellation, slow DB | Legitimate large tasks may be delayed |
| T20-26 | Notification storm hides critical event | Dedupe/aggregation metrics; acknowledgement lag | Typed severity, dedupe key, grouping, in-portal queue, escalation policy | Suppress noisy source; preserve critical; incident review | Operations/Product | Repeated same fault, multi-realm excluded by default, channel failure | Human attention remains finite |
| T20-27 | Notification contains sensitive content | Template/parameter schema; canary | Localization key + finite params; opaque authenticated link; no activity/identity/path/secret | Disable channel; purge where possible; notify incident owner | Notification/Privacy | Every template with canary and unexpected parameter | Email systems/recipients retain messages |
| T20-28 | Accessibility defect blocks pause/kill/rollback | Manual AT/keyboard gate; critical-action smoke | Native controls, focus order/visibility, shortcuts not required, alternate routes, no drag-only action | Use accessible minimal emergency route; rollback UI release; support runbook | Accessibility + Incident owner | Edge/Narrator, Firefox/NVDA, keyboard, high contrast, 400% zoom during incident | AT/browser regressions can occur after release |
| T20-29 | Modal/focus/live-region error causes wrong confirmation | AT transcripts; focus assertions; usability observation | Native/dialog pattern; explicit heading/scope; focus trap/restore; restrained live region | Close/reopen safely; no command until final explicit activation | Front-end/Accessibility | Nested dialogs prohibited, async validation, timeout, stale preview | Cognitive overload cannot be fully automated |
| T20-30 | Complex table/grid inaccessible or misleading | Accessibility-tree snapshot; keyboard/AT task test | Native table first; caption/headers; server pagination; avoid virtualization unless proved; text status | Fall back to simple table/list; disable feature | Front-end/Accessibility | Sort/filter/select/pagination/expanded rows under AT | Very wide data may still require task redesign |
| T20-31 | Chart excludes nonvisual/color-blind users | Automated contrast + manual AT/task test | Text summary and data table; patterns/labels; no color-only; zoom/reflow | Hide chart, retain table; correct component | Product/Accessibility | No CSS, forced colors, screen reader, grayscale, 400% zoom | Dense trends may be cognitively difficult |
| T20-32 | Localization/RTL changes meaning, truncates action, or parses numbers/time incorrectly | Pseudolocalization/RTL snapshots; contract tests | Message keys; no string concatenation; locale display only; UTC/API stable; absolute timezone labels | Disable affected locale; fall back to approved language; patch | Localization/Product | Long/RTL/mixed scripts, pluralization, DST boundaries | Translation quality is human-dependent |
| T20-33 | Authentication timeout loses work or creates inaccessible repeated entry | Session tests; user observation | Warn accessibly; save non-sensitive draft server-side; accessible reauth; no puzzle/CAPTCHA dependency | Resume draft after reauth/version check; discard secrets | IAM/Accessibility | Timeout during every workflow and screen-reader interaction | IdP UI may be outside UAM control |
| T20-34 | Dependency/design-system update changes semantics or includes vulnerable code | Lock/provenance/SBOM; accessibility/visual/semantic diffs; advisory monitoring | Exact versions; no floating tags; same-digest promotion; component allowlist; architecture tests | Pin/rollback; remove affected component; rerun gate | Supply Chain/Front-end | Upgrade every critical component and inject semantic mutation | Transitive/browser supply chain remains large |
| T20-35 | Generic plugin or dynamic component executes hidden production action | Build graph/action catalogue reconciliation; CSP; runtime route inventory | No plugin/microfrontend discovery; explicit imports/routes/commands; release manifest | Disable release; revoke action; audit usage | Architecture/AppSec | Add undeclared route/action and verify CI fails | Malicious signed source change |
| T20-36 | Direct DB/manual script becomes normal recovery | Access/audit review; runbook test; missing portal capability tracking | Normal admin accounts have no DB access; safe recovery commands; break-glass separate and audited | Build missing typed recovery; investigate break-glass; reconcile data | Operations/Security | Complete representative tasks with DB network blocked | Severe incidents may still need human-approved break-glass |
| T20-37 | Browser double-submit/retry creates duplicate effect | Command idempotency metrics; reconciliation | Stable command ID; disabled visual duplicate only as UX; server idempotency authoritative | Return prior result; hold ID conflict; fix client | Domain owner | Double click, refresh, response loss, multi-tab same command | Incorrect client may create distinct IDs intentionally |
| T20-38 | Job retry hides first failure or reports success despite failed child | Parent/child ledger reconciliation | Preserve first failure; explicit partial/limitation; stable child identities | Reopen/repair/retry eligible children; never overwrite history | Job/Domain owner | Fail each child boundary and response loss | External systems may not support status query |
| T20-39 | Deletion UI removes suppression after partial failure | Lifecycle state invariant/audit | Post-barrier state cannot transition to visible; portal has no “undo deletion” | Keep barrier; retry/hold targets; separate authorized supersession only if policy permits | Lifecycle/Data Reliability | Cancel/pause/retry/crash at every state | Privileged direct DB bypass remains residual |
| T20-40 | Restore environment appears in normal portal before readiness | Environment identity/routing/read guard tests | New isolated identity; prominent restore banner; no ordinary route/receipt/egress until readiness and separate enablement | Destroy/quarantine restore; reconcile tombstones/receipts; incident | SRE/Security/Data Reliability | Old backup restore, stale bookmark, wrong DNS/routing, read enable race | Infrastructure administrator error |
| T20-41 | Catalogue display values inferred as ownership/role/rule | Review and fixture assertions | Separate identity/provenance fields; explicit “unknown”; no automatic rule/owner | Remove inference; re-run import; audit affected decisions | Registry/Data Governance | Names resembling roles/IPs/owners/non-ASCII/truncation | Human reviewers can still infer informally |
| T20-42 | Accessibility scanner passes while workflow remains unusable | Manual task success, AT transcript, disabled-scanner mutation | Automated tools are support only; critical workflows require human keyboard/AT tests | Block release; redesign; record known limitation | Accessibility owner | Deliberately introduce focus/order/instruction defect scanner misses | Limited representative user participation |
| T20-43 | Usability test uses real production data or reveals organization | Fixture lineage/canary; evidence review | T1 fictional personas/catalogue/realms; no production screenshots or names | Delete/revert artifacts; incident if leak; regenerate fixture | Research/Test Data owner | Scan recordings/screenshots/results and test environment | Human participant speech may include sensitive context |
| T20-44 | Browser telemetry or replay/session-recording captures sensitive admin content | Dependency/config scan; network capture | No session replay; no generic analytics; approved finite performance events only | Disable/rotate endpoint; delete collected data under authority | Privacy/AppSec/SRE | Network capture and third-party script absence | Browser/enterprise monitoring outside UAM |
| T20-45 | Security control conflicts with accessible authentication | WCAG/auth flow task test; IAM review | Avoid memory/cognitive tests; support password managers/paste where policy allows; step-up has alternatives | IAM remediation/fallback channel; preserve draft | IAM/Accessibility/Security | Keyboard/AT/password manager/timeout/reauth | Upstream IdP policy may remain inaccessible |

## 7.3 Safety and recovery patterns — mandatory artifact

### Pattern A — preview then commit

Use for every high-impact/bulk command. Preview is immutable, short-lived, exact, and non-authoritative until execution. Execution rechecks all state. Failure leaves no mutation and provides a re-preview path.

### Pattern B — atomic mutation plus audit

The authoritative domain transition, idempotency result, and audit event commit together. Notifications and external propagation occur afterward. If audit cannot commit, the mutation does not commit.

### Pattern C — last-known-good candidate handling

An ordinary malformed/incompatible candidate does not replace a valid active revision. Security-significant wrong-realm/signature/rollback/conflict/broadening conditions enter `SAFETY_HOLD`. The portal shows candidate and active states separately.

### Pattern D — higher-revision rollback

Rollback creates a new authorized revision/sequence that references prior semantics. The UI shows the semantic return and the new revision; it never edits history or decrements version.

### Pattern E — staged rollout with independent kill

Rollouts use rings and health gates. A separate narrowing kill switch can stop work even if the rollout screen or downstream service is impaired. Resume requires new evidence/preview.

### Pattern F — barrier before destruction

Deletion commits suppression/tombstones before asynchronous physical deletion. Post-barrier failure cannot re-expose data. Holds can stop destruction but not visibility suppression.

### Pattern G — durable job with stable retry identity

Long operations have one parent command/job and stable child identities. Browser refresh, process restart, response loss, and retry cannot create a second ordinary effect or erase the first failure.

### Pattern H — truthful limitation

When UAM cannot prove an external outcome, state remains `WAITING_EXTERNAL`, `EXTERNAL_ACTION_REQUIRED`, or `COMPLETE_WITH_LIMITATIONS`. The UI never converts uncertainty into green success.

### Pattern I — safe empty/stale/offline state

Every aggregate shows denominator, as-of, freshness, and unknown/excluded counts. `NO_DATA` is not `ZERO`. Actions that require current/complete data are disabled by server precondition, not just UI.

### Pattern J — accessible emergency path

Pause, kill, and rollback have a minimal semantic route that works by keyboard, screen reader, zoom, forced colors, and reduced motion and does not depend on charts, drag-and-drop, hover, or color.

## 7.4 Mandatory incident-response runbooks

Before the Prompt 20 gate can pass, T1 exercises must cover:

1. cross-realm access or cache leak;
2. privileged mutation without matching audit evidence;
3. stale preview/bulk-scope mismatch;
4. unauthorized or reused approval;
5. XSS/canary in a catalogue or integration display value;
6. export forbidden-field/formula/canary escape;
7. connector SSRF/secret exposure;
8. diagnostic/support forbidden capability;
9. feature flag or kill-switch invariant bypass;
10. inaccessible pause/kill/rollback route;
11. audit projection/storage outage;
12. portal/BFF release rollback with active drafts/jobs;
13. notification storm or sensitive notification;
14. restore environment accidentally routed to normal portal;
15. deletion case stuck after the visibility barrier.

Each runbook must name trigger, authority, immediate containment, affected commands/routes, evidence, recovery, rollback, cleanup, neighboring-canary checks, user/support communication, and re-enable condition.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test-data and persona rules

All portal tests use T1 fictional data unless a later separately approved evidence request permits otherwise. The canonical portal fixture contains:

- at least two fictional realms with deliberately colliding UUID/display patterns to expose realm bugs;
- 6,000 fictional installations for the named scale scenario, with controlled current/stale/offline/unsupported/deferred/held states;
- 173 wholly fictional applications reproducing only the safe catalogue shape in I02, including five missing external references, ten non-ASCII names, nine apparent truncation markers, and one address-like name;
- fictional policy, rule, snapshot, release, rollout, job, notification, audit, export, deletion, connector, support, and restore records;
- exact canaries in every field that must never reach a screen, log, metric, audit event, export, notification, or support bundle;
- deterministic clock, IDs, revisions, scopes, approvals, errors, retries, and expected task outcomes.

Synthetic personas are capability bundles, not invented organizational roles:

| Persona ID | Capability intent | Purpose in tests |
|---|---|---|
| `P-OBSERVE` | Read operational aggregates and fleet health | Least-detail/read-only path |
| `P-OPERATE` | Run allowed operational tasks and pause jobs | Command/idempotency/recovery path |
| `P-DRAFT` | Create and edit drafts but not approve/publish | State and separation negative tests |
| `P-APPROVE` | Review/approve exact revisions but not edit them | Approval binding and independent review |
| `P-PUBLISH` | Execute approved publication/rollout commands | High-risk command and audit path |
| `P-AUDIT` | Read immutable audit and evidence | Audit access, no mutation |
| `P-SUPPORT` | Use safe cases/permits/bundles | Diagnostics minimization |
| `P-LIFECYCLE` | Authorize/operate approved deletion/export flows | Barrier, hold, limitation truth |
| `P-INTEGRATE` | Manage registered connector revisions | SSRF/secret/capability path |
| `P-NONE` | Authenticated with no UAM capability | Deny-by-default baseline |

Actual user groups, mappings, and priorities remain **HUMAN DECISION**. The T1 capability matrix proves mechanism only.

## 8.2 Detailed functional, authorization, security, and recovery matrix

| Test family | Setup / stimulus | Instrumentation | Pass | Fail / stop | Evidence |
|---|---|---|---|---|---|
| Contract strictness | Valid/boundary/duplicate/unknown/case/null/over-limit JSON for every read/command | Raw request parser result, safe problem, allocation/time | Exact matrix; no unknown/default coercion | Any hidden field accepted, remote reference, dynamic type, unbounded resource | Contract-vector report and corpus digest |
| Realm isolation | Same IDs/names in two fictional realms; every persona/action | Server auth decisions, DB query realm keys, cache keys, audit | Zero cross-realm read/action/existence disclosure | One cross-realm result or realm-less query/cache | Realm-negative matrix and minimal reproducer |
| Capability isolation | Every persona against every route/field/action/state | Route/action catalogue vs decisions | Exact allow/deny matrix; direct route equals UI behavior | Hidden endpoint, UI-only control, overbroad capability | Capability matrix, route inventory |
| Session/CSRF | Login fixation, multi-tab, logout, realm switch, cross-site requests, timeout | Cookie/session IDs, CSRF decisions, storage/cache scan | Rotation and deny behavior exact; no sensitive browser storage | Cross-site mutation, stale realm, retained secret/token | Sanitized HTTP/session trace |
| Optimistic concurrency | Two admins edit/approve/publish same revision | Versions, ETags, audit, command outcomes | One transition; stale client receives safe conflict | Last-write-wins or overwrite | Concurrency history |
| Command idempotency | Double click, refresh, network response loss, same/different digest | Command table, jobs/effects/audit | Same ID/same digest returns one outcome; different digest holds | Duplicate effect/job/audit or silent conflict | Command reconciliation report |
| Preview TOCTOU | Change scope/policy/resource/approval after preview | Preview/scope/current digests | Execution rejects as `PREVIEW_STALE`; zero mutation | Old preview executes against changed state | Preview transition history |
| Bulk safety | 6,000 rows, paging, changing eligibility, unknown/offline | Filter snapshot, scope manifest, child job ledger | Exact included/excluded/unknown; stable child identity | Browser page/list becomes authority; unbounded fan-out | Scope and child reconciliation |
| Audit atomicity | Fail before/after domain write, audit insert, commit, response | Database failpoints and transaction log | Mutation and audit both absent or both committed | Mutation without audit or mutable prior audit | Failpoint capsules and audit reconciliation |
| Workflow legality | Attempt every forbidden transition and stale approval | Domain state history | Only declared transitions; content change invalidates approval | UI or API directly sets state; lower revision rollback | State-machine coverage report |
| Rollout safety | Ring health pass/fail, pause, kill, resume, rollback, offline endpoints | Durable job/control states and eligibility snapshots | Staged, explicit counts, current re-preview, higher-sequence rollback | Unknown included as success; stale work commits; kill bypass | Rollout timeline and evidence digest |
| Deletion barrier | Fail/crash before/after barrier and each target | Visibility/read probes, tombstone, job, audit | No visibility after barrier; retry stable; truthful limitation | Re-exposure, wrong realm, completion before verification | Lifecycle failpoint pack |
| Export safety | Forbidden fields, formula values, over-limit, stale scope, link forwarding | Manifest/row/canary, download auth, object/key lifecycle | Approved fields only; safe format; expiry/revocation; audit | Hidden/canary field, active formula, cross-user download | Export manifest and scan |
| Integration safety | Registered/unregistered destinations, redirects, DNS rebinding, secret rotation, ambiguous receipts | Egress gateway, secret access, connector state | Only registered class; no secret to browser; truthful status | SSRF, raw secret, test=delivery/deletion | Connector security report |
| Support/diagnostics | Unknown capability, raw strings, path/file/dump, wrong target/realm, expired permit | Contract/analyzer/canary/bundle manifest | Closed D0–D2 only; permit expiry/revoke; zero escape | Arbitrary command/file/dump/raw value | Support evidence and cleanup receipt |
| Feature/kill controls | Attempt broadening/bypass/self-clear and partial outage | Effective-control proof, route availability, audit | Only narrow/disable; minimal emergency path works | Invariant bypass or inaccessible emergency action | Control mutation matrix |
| Empty/stale/offline/partial | All state combinations and zero counts | DOM/accessibility tree and task observation | State text, denominator, as-of, restrictions correct | Blank/green success/no-activity inference | Semantic snapshot set |
| Error privacy | Malformed data at each middleware/domain/dependency boundary | Problem body, logs, metrics, traces, browser console | Finite safe code and operation token only | Exception/SQL/name/path/secret/canary leak | All-sink canary report |
| Browser cache/history | Back/forward, realm switch, logout, shared profile, tabs | DevTools-equivalent cache/storage inventory | No sensitive cached response/storage; stale page reauthorizes | Prior realm/session data displayed | Cache/storage report |
| Supply chain | Upgrade/replace component, change transitive package, inject undeclared action | Lock/SBOM/provenance/action inventory/semantic tests | Exact admitted bytes; undeclared change blocks | Floating dependency or hidden action | Dependency and route manifests |
| Accessibility semantics | Each critical route/component | Accessibility tree, HTML/ARIA assertions | Correct name/role/state/relationships; native-first | Missing/incorrect semantics or bad ARIA | Semantic report and screenshots |
| Keyboard | Complete all critical workflows without pointer | Key/focus trace and observation | All actions reachable; logical order; visible focus; no trap | Pointer/drag/hover-only or focus loss | Keyboard transcript |
| Screen reader | Complete tasks with named browser/AT combinations | Spoken transcript, accessibility tree, observation | Purpose/state/scope/errors/progress understandable and operable | Unannounced change, ambiguous control, wrong order | AT transcript and issue log |
| Zoom/reflow/text spacing | 200% and 400%, narrow viewport, text-spacing overrides | Screenshots, overflow/focus checks | No loss, overlap, two-dimensional scroll except essential tables | Hidden action/content/focus or clipped text | Visual/reflow evidence |
| Forced colors/contrast | High contrast/forced colors, grayscale, dark/light where supported | Contrast and screenshot comparison | State/focus/action visible without color alone | Invisible focus/status/control | Contrast/forced-color report |
| Reduced motion | OS/browser reduced-motion preference | Animation inventory and timing | Nonessential motion disabled; no information loss | Vestibular/attention-blocking motion | Motion report |
| Chart alternatives | Disable CSS/canvas, screen reader, table-only | Text/table comparison to chart data | Exact same meaning and scope available | Color/visual only or mismatched values | Chart/table reconciliation |
| Localization/RTL | Pseudolocales, long strings, Arabic/Hebrew-style RTL fixtures, plural cases, UTC/DST boundaries | Screenshots, DOM, message-key coverage | No concatenation/truncation meaning loss; correct layout/time labels | Action ambiguity, clipped text, locale alters API semantics | Localization report |
| Accessible authentication | Login/reauth/timeout with keyboard, AT, password manager/paste | Task observation and session trace | No cognitive-memory barrier; warning and draft recovery work | Inaccessible repeated entry or lost draft | Auth accessibility scorecard |
| Usability/task success | Representative users/capability personas perform priority tasks | Task completion, errors, time-on-task, help, confidence interview | No wrong-scope/high-risk action; task-specific owner threshold met | Repeated confusion, direct DB request, hidden state, unsafe workaround | Anonymized task scorecard with T1 data |
| Performance | Cold/warm routes, 6k fleet, 173 apps, audit/jobs, slow network/CPU profiles | Web Vitals, asset sizes, API timings, memory, long tasks | Current provisional budgets in 8.6 or approved replacements | Unbounded list, main-thread freeze, critical action delay | Reproducible performance trace |
| Resilience | BFF/module/DB/notification/IdP/network interruption at each workflow step | Job/state/audit/HTTP histories | Known state, same-id recovery, no duplicate/hidden commit | Ambiguous mutation, first failure lost, inaccessible recovery | Fault capsule |
| Cleanup | Test users/sessions/files/objects/keys/notifications/jobs | Before/after inventory | Exact T1 cleanup/revert and no credential/data residue | Residue or unproved deletion | Cleanup receipt |

## 8.3 Accessibility test matrix — mandatory artifact

The engineering target is WCAG 2.2 AA for the complete representative workflows. Automated tests are necessary but not sufficient; WCAG itself expects a combination of automated and human evaluation. [W01]

| Requirement area | Automated evidence | Manual keyboard/visual evidence | Assistive-technology evidence | Primary portal cases |
|---|---|---|---|---|
| Structure and landmarks | One `main`, unique titles/headings, landmark/name checks | Skip link and heading navigation | Landmark/heading list is meaningful | All routes |
| Accessible names/descriptions | Label/association checks | Visible label/instruction clarity | Name, role, description match visual intent | Forms, filters, commands |
| Focus order/visibility | Focusable/hidden/inert assertions | Tab/Shift+Tab order; focus not obscured; restore after dialogs | Current item and context announced | Navigation, dialogs, jobs |
| Keyboard operation | No positive tabindex; event parity | Every task without pointer; no trap; no drag-only | Key model follows expected widget pattern | Tables, menus, wizards, bulk actions |
| Dialogs/confirmation | Role/name/modal/inert checks | Initial focus, scope review, Escape/cancel, restore | Dialog title, consequences, errors announced | Publish, rollout, export, deletion, kill |
| Dynamic status | Live-region scope/duplication checks | No focus theft; status remains readable | Job progress, validation, stale/hold updates announced once | Previews, jobs, notifications |
| Forms/errors | Invalid/required/described-by checks | Error summary links; correction preserves input | Field and summary error announced with instruction | Drafts, filters, approvals |
| Tables/lists | Native table/header/caption relationships | Sorting/filtering/pagination and selection | Headers, current sort, row expansion and count understandable | Fleet, audit, registry, targets |
| Charts | Data equality test | Text summary/table; no color-only | Trend/scope/denominator available without chart | Overview, aggregates, rollout |
| Color/contrast | Programmatic contrast where measurable | Forced colors, grayscale, focus/status visibility | State names spoken, not color labels | All critical states |
| Reflow/zoom/text spacing | Layout assertions at breakpoints | 200/400%, 320 CSS px equivalent, text-spacing override | Reading/order remains coherent | All routes, wide tables |
| Motion/timing | Reduced-motion CSS/config test | No essential info in animation; pause where needed | Progress not announced excessively | Notifications, transitions, charts |
| Authentication/session | Label/timeout component checks | Keyboard/password-manager/paste; warning and extension | Reauth and timeout instructions/completion | Login, publish, export/deletion |
| Target size/drag | Pointer target geometry check | Alternate non-drag operation | Controls discoverable and named | Ring ordering if any, column arrangement |
| Consistent help | Route/template check | Help location and terminology consistent | Help landmark/link found consistently | Every critical workflow |
| Localization/RTL | Message-key and pseudolocale coverage | Long strings, RTL, mixed scripts, date/time | Reading order and control names correct | All critical workflows |
| Cognitive clarity | No reliable automation | Plain language, progressive disclosure, one primary action, review scope | Instructions and state comprehensible | High-risk confirmations/recovery |

### Minimum prototype browser/AT matrix

| Environment | Purpose | Status |
|---|---|---|
| Current supported Microsoft Edge + Windows Narrator | Windows enterprise baseline and native Windows AT | **CLI EXPERIMENT** |
| Current supported Firefox ESR/current + NVDA | Independent browser/accessibility stack | **CLI EXPERIMENT** |
| Current supported Edge or Chrome + JAWS | Enterprise screen-reader coverage where licensed and supportable | **HUMAN DECISION + CLI EXPERIMENT** |
| Keyboard only, no screen reader | Motor/access path and visible focus | Mandatory |
| Windows forced-colors/high-contrast and 400% zoom | Low-vision/enterprise Windows path | Mandatory |
| Reduced motion and pseudolocale/RTL | Preference/localization resilience | Mandatory |

Exact versions and support windows are selected at execution and recorded. A pass on one combination is not inherited to another.

## 8.4 Representative critical tasks

The first prototype must support these T1 tasks without direct database or developer intervention:

1. `P-OBSERVE`: identify why a fleet-health count is incomplete and distinguish offline from no activity.
2. `P-OPERATE`: create a server-side filter snapshot, review excluded/unknown scope, and start an allowed bounded task.
3. `P-DRAFT`: create a narrower policy draft, correct validation errors, and submit for review.
4. `P-APPROVE`: compare exact content/impact, reject stale content, and approve the current revision.
5. `P-PUBLISH`: publish an approved policy or application snapshot and verify active revision/audit.
6. `P-PUBLISH`: start a staged rollout, detect a health failure, pause, inspect current scope, and execute approved rollback.
7. `P-DRAFT/P-APPROVE`: stage the 173-row fictional catalogue, resolve missing-ref quality cases without using the reference as identity, and commit the approved import.
8. `P-DRAFT/P-APPROVE`: identify an application-rule ambiguity and refuse to guess a winner.
9. `P-AUDIT`: find the immutable evidence for a privileged command without seeing raw payload or hidden data.
10. `P-LIFECYCLE`: preview and authorize a fictional deletion, confirm the visibility barrier, interpret a legal hold and an uncontrolled external-copy limitation.
11. `P-LIFECYCLE`: request an approved export, verify field/scope/expiry, retrieve it, and understand the external-copy limitation.
12. `P-INTEGRATE`: create and test a registered connector revision without viewing a secret or entering an arbitrary URL.
13. `P-SUPPORT`: diagnose a defined fictional failure using safe health, create a bounded permit/bundle, and revoke it.
14. Any authorized persona: switch fictional realm and verify no prior realm data/action survives.
15. Any high-risk persona: complete pause/kill/rollback by keyboard and screen reader through the minimal emergency route.

## 8.5 Usability measurement protocol

**HUMAN DECISION.** Actual user groups and priority tasks must be selected by Product/Operations/Support/Accessibility owners. Until then, T1 capability personas and the tasks above are the conservative proxy.

For each test session record:

```text
fixture and build digests
persona/capability profile, not real job title
browser/AT/input method/display settings
starting state and exact task statement
task completion and terminal state
critical/noncritical errors and unsafe attempts
requests for direct DB/raw detail/workaround
assistance and help usage
time-on-task and number of reversals
ability to state active realm, affected scope, stale/unknown counts,
reason, approval state, recovery/rollback, and final outcome
accessibility barriers and participant-reported confidence
```

**ESTIMATE — provisional task benchmark.** Before the technical gate, every critical task must be successfully completed in the lab by at least one independent keyboard-only and one independent screen-reader run with zero wrong-realm or unintended high-risk commit. For representative user research, Product should set a sample and acceptance target; a starting hypothesis is at least five participants per priority capability group and at least 90% unassisted critical-task completion. These numbers are replaceable research inputs, not production policy.

Any request for direct database access, raw activity, a hidden command, or developer repair is treated as a design failure unless the task is explicitly classified as break-glass and separately governed.

## 8.6 Provisional performance budgets

Core Web Vitals currently define “good” thresholds as LCP no more than 2.5 seconds, INP no more than 200 ms, and CLS no more than 0.1 at the 75th percentile. [W09] UAM adopts these as provisional browser-experience thresholds, not business SLOs.

| Budget | Classification | Prototype target | Replacement evidence |
|---|---|---:|---|
| LCP | Current external UX threshold | ≤ 2.5 s at p75 on named desktop profile | Field/lab distribution and Product/SRE decision |
| INP | Current external UX threshold | ≤ 200 ms at p75 | Same |
| CLS | Current external UX threshold | ≤ 0.1 at p75 | Same |
| Initial route JS+CSS compressed | **ESTIMATE** | ≤ 350 KiB | Framework/design-system bake-off and supported network/CPU profile |
| Additional route payload compressed | **ESTIMATE** | ≤ 150 KiB | Route-level bundle analysis |
| Default/max list page | **ESTIMATE** | 50 / 100 items | Task and API/database measurement |
| Read-model p95 server time | **ESTIMATE** | ≤ 1 s in T1 6k scenario | Approved SLO and production-shaped measurement |
| Impact-preview p95 server time | **ESTIMATE** | ≤ 2 s for bounded scope | Same; long previews become durable jobs |
| Main-thread long task | **ESTIMATE** | No task > 50 ms during ordinary interaction on named profile | Browser trace and accessibility/task evidence |
| Browser heap after 30-minute admin session | **ESTIMATE** | No unbounded growth; ≤ 25% growth after repeated navigation loop | Leak profile and chosen framework |
| Table rendering | Mandatory principle | No full 6k DOM; server pagination; virtualization only after AT proof | Accessibility/performance bake-off |
| Critical pause/kill route | Mandatory principle | Interactive even when noncritical projections/notifications fail | Fault and accessibility prototype |

A performance pass is invalid if the generator/browser cannot produce the intended interactions, if accessibility is weakened, if correctness/privacy fails, or if a faster test-only API differs from production contracts.

## 8.7 Smallest falsifying prototypes

### P20-01 — BFF authority, realm isolation, and no direct DB

**Claim.** Every normal portal read/action can be mediated by the same-origin BFF and explicit domain contracts without browser authority or database access.

**Setup.** Two fictional realms with colliding resource IDs; all T1 personas; browser, BFF, modular-monolith test modules; database network reachable only from server; direct DB blocked for personas.

**Instrumentation.** Route/action catalogue, server authorization decisions, realm-first query guard, network capture, browser storage scan, audit, canaries.

**Steps.** Exercise every route/action with every persona, direct endpoint calls, body/query/header realm injection, stale realm tabs, switch/logout/back navigation, and database outage.

**Pass.** Zero cross-realm reads/actions; zero browser token/secret/DB path; every allowed command has matching audit; every denied route is generic; normal tasks remain possible through portal contracts.

**Fail/stop.** One cross-realm result, client role/realm authority, generic proxy, browser token persistence, or required direct DB operation.

**Evidence.** `p20-01-authority/{route-catalogue,authz-matrix,realm-negative,network,storage,audit,canary,cleanup}`.

**ESTIMATE run duration.** 60–90 minutes after fixture provisioning.  
**Cleanup.** Revoke sessions, delete T1 realms/databases, verify browser storage and server artifact inventory, revert environment.

### P20-02 — preview, concurrency, approval, idempotency, and atomic audit

**Claim.** A high-risk command cannot apply stale/changed scope, bypass approval, duplicate on retry, or commit without audit.

**Setup.** Fictional policy/rule/release resources; two concurrent personas; failpoints around preview, approval, domain write, audit, commit, response.

**Instrumentation.** Command/idempotency ledger, ETags/versions, preview/scope digests, approval records, database transaction snapshots, audit reconciliation.

**Steps.** Preview, mutate source state, execute; edit after approval; self/wrong-realm/expired approval; double-submit; lose response; crash at every transaction boundary.

**Pass.** Stale execution rejected; approval invalidated on change; same command returns one effect; different digest holds; mutation and audit are both committed or both absent.

**Fail/stop.** Last-write-wins, approval reuse, duplicate effect/job, mutation without audit, or ambiguous state after recovery.

**Evidence.** Deterministic failure capsules and state-history/oracle comparison.

**ESTIMATE run duration.** 45–75 minutes.  
**Cleanup.** Remove fixture revisions/jobs/approvals and verify audit fixture retention/deletion manifest.

### P20-03 — aggregate-first accessible IA and critical task flow

**Claim.** Fleet triage and policy draft/review/publish can be completed without activity detail and with keyboard/screen reader.

**Setup.** 6,000 fictional installations, 173 fictional applications, controlled stale/offline/partial states; prototype IA and semantic components.

**Instrumentation.** Accessibility tree, keyboard/focus trace, AT transcript, task observation, data-quality oracle, performance trace.

**Steps.** Execute tasks 1–5 and realm switch with keyboard-only, Edge/Narrator, and Firefox/NVDA; repeat at 400% zoom and forced colors.

**Pass.** Correct realm/scope/freshness/quality understood; all actions reachable; focus/state/progress announced; no detail/raw data required; WCAG 2.2 AA critical checks pass.

**Fail/stop.** Participant interprets offline as no activity, cannot locate action/recovery, needs pointer/detail/DB, or inaccessible control blocks task.

**Evidence.** Task scorecards, AT transcripts, semantic/visual snapshots, issue severity and retest.

**ESTIMATE run duration.** 2–3 hours per environment/AT matrix pass.  
**Cleanup.** Delete recordings that contain participant voice under the approved research retention; retain sanitized findings only.

### P20-04 — design-system/framework bake-off

**Claim.** One implementation stack can meet the fixed UAM screen/accessibility/security/performance contracts with acceptable skills and removal cost.

**Setup.** Implement the same navigation, paged table, form/error summary, dialog, impact preview, job progress, notification, and emergency kill flow in the shortlisted standards-first stacks/design systems.

**Instrumentation.** Exact lock/SBOM/provenance, bundle graph, semantic/accessibility tree snapshots, keyboard/AT matrix, Core Web Vitals, memory, test coverage, security review, developer change exercise.

**Steps.** Run identical fixture/tasks; upgrade one dependency; inject a semantic regression; remove/replace one component; compare build/release/support documentation.

**Pass.** One candidate passes all hard safety/accessibility gates and has measured lower total implementation/maintenance cost. License and asset terms approved.

**Fail/stop.** No candidate passes, or choice relies on popularity, visual preference, inaccessible custom wrappers, mutable packages, or unapproved license/assets.

**Evidence.** Weighted decision record with hard-gate results first; no performance score after hard failure.

**ESTIMATE run duration.** 1–2 hours of automated run plus human AT/task sessions per candidate; implementation effort is not estimated here.

**Cleanup.** Remove unselected dependencies/prototypes, lockfiles, assets, and generated bundles; verify clean repository graph.

### P20-05 — staged rollout, kill, rollback, and recovery

**Claim.** An authorized operator can safely start, pause/kill, resume only after re-preview, and roll back through a higher sequence, including under partial dependency failure.

**Setup.** Fictional release, three rings, controlled compatibility/offline/health outcomes, notification/projection failure injection.

**Instrumentation.** Rollout/job/control state, eligibility snapshots, audit, notification, endpoint simulator acknowledgements, accessibility trace.

**Steps.** Start ring; fail health gate; auto-pause; invoke kill via minimal route while dashboard projection is unavailable; recover; re-preview; approved rollback; lose browser response/restart BFF.

**Pass.** No new work after kill; unknown/offline explicit; resume cannot use stale preview; rollback higher sequence; one durable outcome/audit; emergency route keyboard/AT accessible.

**Fail/stop.** Stale work commits, kill depends on dashboard, lower-sequence rollback, unknown treated success, or inaccessible emergency control.

**Evidence.** End-to-end state timeline and reconciliation.

**ESTIMATE run duration.** 60–120 minutes.  
**Cleanup.** Reconcile all fictional tasks, revoke controls, return test environment to baseline, prove no active permit/job.

### P20-06 — export, deletion, integration, and truthful limitation

**Claim.** UAM can execute typed egress/lifecycle workflows without generic export/SSRF/direct delete and without falsely claiming external completion.

**Setup.** Fictional facts/aggregates, approved field profile, one controllable and one uncontrollable recipient, registered connector, legal hold, old restore snapshot.

**Instrumentation.** Export manifest/canary, egress proxy, secret access, tombstone/read probes, target states, audit, restore readiness.

**Steps.** Generate/retrieve/revoke export; attempt hidden/formula fields; connector redirect/rebinding/ambiguous delete; authorize deletion; fail after barrier; apply hold; restore old data and replay tombstones.

**Pass.** No forbidden export or SSRF; secrets absent; data invisible after barrier; held destruction explicit; uncontrolled copy remains limitation; old restore blocked until tombstone/readiness proof.

**Fail/stop.** Generic table export, raw URL/secret, data reappears, barrier removed, HTTP success shown as external deletion, or restore readable early.

**Evidence.** Egress, lifecycle and restore evidence pack.

**ESTIMATE run duration.** 2–4 hours.  
**Cleanup.** Delete test objects/keys, reset connector, destroy isolated restore, verify no external test recipient residue.

### P20-07 — performance, scale, freshness, and browser memory

**Claim.** The aggregate-first portal remains responsive and understandable for the named 6,000-installation and 173-application T1 scenario without full-list DOM or unbounded client state.

**Setup.** Production-shaped screen/read contracts, named desktop/network/CPU profiles, current and degraded dependencies, deterministic interaction script.

**Instrumentation.** Core Web Vitals, asset/bundle sizes, API timings, browser memory/long tasks, DOM node count, network bytes, screen-reader response, generator saturation.

**Steps.** Cold/warm overview, filter/paginate/sort fleet, registry search, preview bulk scope, audit search, 30-minute navigation loop, slow dependency, stale cursor.

**Pass.** Provisional budgets or approved replacements; bounded DOM/memory; no hidden full export; freshness/partial states remain correct; AT operation remains usable.

**Fail/stop.** Generator saturation, full 6k DOM, unbounded memory, main-thread lock blocking kill/pause, or performance achieved by removing semantics/detail warnings.

**Evidence.** Reproducible traces, run plan, environment and fixture digests.

**ESTIMATE run duration.** 45–90 minutes per profile.  
**Cleanup.** Clear browser/server caches and T1 data; prove no performance trace contains forbidden values.

### P20-08 — privacy-safe support and blind diagnosis

**Claim.** Defined failures can be diagnosed and recovered through safe signals and bundles without raw activity, logs, paths, exceptions, or arbitrary commands.

**Setup.** Fictional failure corpus, safe diagnostic catalogue, permit/bundle workflow, one support tester without implementation internals.

**Instrumentation.** Analyzer, all-sink canaries, bundle manifest, permit timeline, task scorecard, cleanup inventory.

**Steps.** Wrong-target/realm/expiry/revoke tests; build bundle; inject unknown/forbidden field; response loss; blind support operator classifies and follows runbook.

**Pass.** Zero canary/forbidden value; permit cannot outlive authority; bundle deterministic before encryption; defined failures solved; no request for raw data/remote shell.

**Fail/stop.** Hidden raw field, arbitrary collector, plaintext residue, unresolved required failure, or expired permit remains active.

**Evidence.** Permit matrix, bundle evidence, blind-support scorecard, cleanup receipt.

**ESTIMATE run duration.** 90–150 minutes.  
**Cleanup.** Revoke permit, delete bundle/plaintext buffers/test keys, verify journal/object/storage inventory.

## 8.8 Primary Prompt 20 acceptance expression

```text
PROMPT20_TECHNICAL_PASS =
    ZERO_DIRECT_DB_REQUIRED_FOR_NORMAL_ADMIN
    AND ZERO_GENERIC_ROW_MUTATION_ENDPOINTS
    AND ZERO_BROWSER_AUTHORITY_OR_REALM_CLAIMS
    AND ZERO_CROSS_REALM_READS_OR_ACTIONS
    AND ZERO_PRIVILEGED_MUTATIONS_WITHOUT_ATOMIC_AUDIT
    AND ZERO_STALE_PREVIEW_OR_VERSION_COMMITS
    AND ZERO_IDEMPOTENCY_DUPLICATE_EFFECTS
    AND ZERO_HIDDEN_PRODUCTION_ACTIONS
    AND ZERO_FORBIDDEN_VALUE_OR_SECRET_ESCAPES
    AND ZERO_FEATURE_FLAG_INVARIANT_BYPASSES
    AND ZERO_INACCESSIBLE_CRITICAL_WORKFLOWS
    AND ZERO_INACCESSIBLE_PAUSE_KILL_ROLLBACK_PATHS
    AND ZERO_WRONG_SCOPE_HIGH_RISK_TASK_COMMITS
    AND ALL_REQUIRED_EMPTY_STALE_OFFLINE_PARTIAL_STATES_EXPLICIT
    AND ALL_CRITICAL_TASKS_PASS_NAMED_KEYBOARD_AT_MATRIX
    AND PERFORMANCE_BUDGETS_PASS_OR_HAVE_APPROVED_REPLACEMENTS
    AND ALL_BLOCKING_OWNER_FUNCTIONS_ASSIGNED
    AND ALL_HUMAN_DECISION_DEFAULTS_REMAIN_DISABLED_OR_RECORDED
    AND ALL_EVIDENCE_CURRENT_AND_CONTENT_BOUND
    AND ZERO_CLEANUP_RESIDUE
```

No automated accessibility score, average task time, throughput result, visual review, or design-system claim can compensate for a nonzero hard invariant.

---

# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Repository and architecture fitness functions

| ID | Fitness function | Measurement | Acceptance |
|---|---|---|---|
| F20-001 | Browser cannot reference persistence/DB clients or internal module entities | Dependency/API graph and forbidden package scan | Zero forbidden references |
| F20-002 | Portal BFF exposes only registered read/command routes | Build-time route catalogue vs runtime inventory | Exact equality; undeclared route blocks build |
| F20-003 | Every mutation maps to one named command and capability | Command/authorization catalogue reconciliation | 100% mapped; no generic PATCH/editor |
| F20-004 | Realm/actor are not authority-bearing body/query fields | Schema lint and hostile vectors | Zero accepted authority fields |
| F20-005 | Every privileged command declares risk, reason, idempotency, version, audit; preview/approval where required | Contract metadata lint | 100% complete; unowned command cannot build |
| F20-006 | Domain transition and audit are atomic | Failpoint suite and reconciliation | Zero transition/audit mismatch |
| F20-007 | UI actions are a subset of registered authorized commands | Static route/action scan and runtime DOM crawl | No hidden/unregistered production action |
| F20-008 | Feature flags/kill switches are narrowing only | Lattice/property tests and mutation corpus | Zero broadening/bypass counterexample |
| F20-009 | No raw-detail route or field exists in first prototype | Route/schema/field inventory | Zero activity/person/raw URL/path fields |
| F20-010 | All list endpoints are bounded and server-paged | Contract lint and load test | No unbounded page/list/export |
| F20-011 | Every aggregate contains as-of, denominator, freshness and quality | Read-model schema lint | 100% of aggregate metrics |
| F20-012 | Error/log/metric/audit/notification schemas are finite and safe | Schema/analyzer/canary | Zero forbidden field/marker |
| F20-013 | Connector/export/support contracts cannot express arbitrary URL/path/command/secret | Schema negative vectors | Zero representable arbitrary capability |
| F20-014 | All critical components have accessible semantics and tests | Component catalogue vs semantic test inventory | 100% covered before use |
| F20-015 | Unselected design-system components cannot enter bundle | Import allowlist/bundle graph | Zero undeclared component/package |
| F20-016 | Browser assets are exact and promoted without rebuild | File manifest/provenance/digest comparison | Same digest through rings |

## 9.2 Runtime authorization and realm fitness functions

```text
for every registered route R,
for every synthetic capability set C,
for every realm pair A != B,
for every resource state S:
    observed_authorization(R,C,A,B,S) == reference_policy(R,C,A,B,S)
```

Acceptance:

- zero cross-realm success;
- zero route authorized solely because it is present in the UI;
- zero field returned outside the capability/field projection;
- zero stale session capability after revocation on the next request;
- zero wrong-realm cache hit;
- zero response distinction that reveals an unauthorized resource across realms beyond approved generic policy.

## 9.3 Command and audit fitness functions

```text
committed_privileged_transitions
  == committed_authoritative_audit_events
  == committed_idempotency_results
```

For asynchronous commands:

```text
committed_parent_commands
  == committed_jobs_or_terminal_immediate_results
```

Acceptance:

- exact one-to-one reconciliation by realm/command ID;
- same ID/same digest returns same result;
- same ID/different digest is a conflict;
- no stale version/preview/approval commit;
- no lower-revision rollback;
- first failure and retry lineage preserved;
- response loss does not create ambiguity after status lookup.

## 9.4 Accessibility fitness functions

Hard gates for each critical workflow:

- one meaningful page title, `h1`, and main landmark;
- skip link works and focus is visible/not obscured;
- all controls have correct accessible name/role/state/value;
- keyboard-only completion with no trap, pointer, drag, hover, or timing dependency;
- screen-reader completion on the named minimum matrix;
- errors identified, described, summarized, and focus-managed;
- async validation/progress/hold/completion announced without repeated noise or focus theft;
- 200%/400% zoom, text spacing, forced colors, and reduced motion do not remove information or action;
- chart meaning available as text/table;
- critical state and severity never rely on color alone;
- accessible authentication and timeout recovery preserve safe draft state;
- no unresolved Level A or AA failure in the tested scope.

**FACT.** Automated accessibility tools cannot prove all these properties. Manual and AT evidence is mandatory. [W01–W03]

## 9.5 Usability fitness functions

For each human-approved priority task:

```text
safe_task_success =
    terminal task state is correct
    AND active realm is correct
    AND affected scope is understood
    AND stale/unknown/partial conditions are understood
    AND no unauthorized/detail/DB workaround is used
    AND recovery/rollback is identified
    AND no unintended high-risk command commits
```

The gate requires zero unintended high-risk commits and no systemic blocker. Completion-rate/time/help thresholds are **HUMAN DECISION** informed by measured baseline; provisional hypotheses appear in section 8.5.

## 9.6 Performance and operability fitness functions

- Core Web Vitals meet the current provisional thresholds at p75 on the named profiles. [W09]
- No critical action route loads an unbounded data set or depends on a noncritical chart/notification/integration.
- Generator saturation, client CPU/memory, and evidence sink saturation are measured; a saturated driver invalidates the result.
- The minimal pause/kill/rollback route remains usable during projection/notification degradation.
- Browser refresh/restart and BFF restart recover from durable command/job state.
- No normal-administration runbook includes direct SQL, database table editing, arbitrary script, raw log/dump, or developer-only hidden endpoint.
- Every production command has a support owner and a tested recovery path; absent owner means disabled capability.

## 9.7 Privacy and observability fitness functions

Allowed portal metric dimensions are finite, for example:

```text
route_class
action_class
result_family
risk_class
freshness_class
data_quality_class
job_state_class
build_ring
browser_family_class
accessibility_test_profile
```

Forbidden labels/attributes include realm, tenant, user, principal, installation, device, source, application, rule, event, export, deletion case, connector, support case, URL, host, path, query, raw error, arbitrary message, exact ID, and any user-entered text.

Acceptance:

- theoretical and observed series fit the human-approved cardinality budget;
- unknown labels/attributes reject rather than pass through;
- exact canaries are detected by positive controls and absent from every portal sink;
- no session-replay or generic analytics script appears in the release bundle;
- operational evidence is sufficient to diagnose defined portal failures without sensitive labels.

## 9.8 Gate artifact

The Prompt 20 gate evaluator produces:

```json
{
  "contract": "uam.research.prompt20-gate",
  "version": "1.0.0",
  "result": "PASS_OR_FAIL",
  "sourceTreeDigest": "sha-256:fictional",
  "portalAssetDigest": "sha-256:fictional",
  "bffReleaseDigest": "sha-256:fictional",
  "fixtureRootDigest": "sha-256:fictional",
  "routeAndCommandCatalogueDigest": "sha-256:fictional",
  "authorizationMatrixDigest": "sha-256:fictional",
  "accessibilityEvidenceDigest": "sha-256:fictional",
  "taskEvidenceDigest": "sha-256:fictional",
  "performanceEvidenceDigest": "sha-256:fictional",
  "securityEvidenceDigest": "sha-256:fictional",
  "cleanupEvidenceDigest": "sha-256:fictional",
  "blockingOwnerCount": 0,
  "blockingHumanDecisionCount": 0,
  "productionApproved": false
}
```

The aggregator cannot accept a manually typed pass. It verifies evidence content, expiry, scope, first failures, cleanup, ADR and owner state.

---

# 10. Human decisions and owner questions

Research defines safe options and conservative defaults; it does not assign real people or approve policy. Role names below are accountable functions.

## 10.1 Mandatory Prompt 20 human decisions

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable role/function |
|---|---|---|---|---|
| HD20-01 | **User groups and priority workflows** | A: broad operational roles increase reach but enlarge access/testing/support; B: narrow task-specific capability groups reduce blast radius but add administration; C: central-only administration reduces tenant autonomy but concentrates power | Use fictional capability personas only; no production mapping; implement read-only aggregate and draft workflows first | Product Governance with IAM, Operations, Support, Privacy |
| HD20-02 | **Terminology and accessibility policy** | A: WCAG 2.2 AA baseline; B: AA plus selected AAA/cognitive provisions; C: stricter procurement/organizational standard. Terminology can reduce or amplify employee-monitoring/productivity interpretation | Target WCAG 2.2 AA and plain neutral operational language; prohibit “productivity,” “performance score,” or forensic-certainty wording | Product Owner with Accessibility, Legal, Privacy, Workforce Governance |
| HD20-03 | **Approval and notification responsibilities** | A: single authorized actor is faster but weaker separation; B: maker/checker separation improves control but adds delay; C: quorum/multi-domain approval improves high-consequence assurance but increases availability/operations burden. Notification channels can create privacy and alert-fatigue risk | High-risk production actions disabled. T1 fixtures model separate drafter/approver/publisher. In-portal notifications only | Product Governance with Security IAM, Release, Privacy, Operations, Support |
| HD20-04 | **Whether any detail view is needed** | A: no activity detail minimizes misuse and breach surface; B: limited operational detail supports diagnostics; C: subject/activity detail may support a specific approved purpose but adds legal, privacy, access, retention, appeal, audit, and accessibility obligations | No activity/person detail route or API. Operational installation health only | Data Controller/Product Owner with Legal, Privacy, Workforce Governance, IAM |

## 10.2 Extended decision register

| ID | HUMAN DECISION | Conservative state until decided | Consequence of delay / blocked work | Accountable function |
|---|---|---|---|---|
| HD20-05 | Legal purpose, lawful basis, prohibited uses, employee consultation and notice | T1 fictional data only; no live administration of activity | Blocks production evidence/detail/export and production activation | Data Controller/Product Governance + Legal/Privacy/Workforce Governance |
| HD20-06 | Exact portal capability catalogue and mapping from enterprise identity | No production capabilities; T1 personas only | Blocks production authentication/authorization | IAM/Security + Product Governance |
| HD20-07 | Separation-of-duties rules, self-approval, quorum, emergency authority, reauth | High-risk actions disabled | Blocks publish/rollout/export/deletion/integration/diagnostic activation | Security Governance + Domain owners |
| HD20-08 | Reason-code taxonomy and whether bounded comments are permitted | Closed reason codes; no comments | May reduce contextual audit/support detail; avoids uncontrolled personal data | Product Governance + Records/Privacy/Security |
| HD20-09 | Notification channels, recipients, timing, acknowledgement and escalation | In-portal T1 only; no external delivery | Blocks email/webhook/on-call automation | Operations/Support/Product + Privacy/Security |
| HD20-10 | Accessibility conformance policy, AT/browser support, exception/VPAT/procurement evidence | WCAG 2.2 AA engineering target; no formal conformance claim | Blocks published accessibility statement and support commitment | Accessibility Owner + Legal/Procurement/Product |
| HD20-11 | Supported locales, translation governance, terminology ownership, time-zone defaults | Source-language T1 plus pseudolocalization/RTL | Blocks localized production UI | Product/Localization + Accessibility/Support |
| HD20-12 | Session lifetime, reauth triggers, accessible timeout and shared-device policy | Conservative server session; exact values unset | Blocks production IAM profile | IAM/Security + Accessibility/Product |
| HD20-13 | Portal framework, design system and commercial support strategy | No dependency selected; prototype bake-off | Blocks production front-end scaffold lock | Architecture/Front-end + Accessibility + Legal/Procurement |
| HD20-14 | Browser/version support and update cadence | Exact lab versions only | Blocks enterprise support statement | Product Support + Endpoint/Browser Platform + Accessibility |
| HD20-15 | Performance SLOs, client budgets, data freshness and task latency objectives | Provisional section 8.6 budgets; explicit as-of | Blocks production performance acceptance and alert thresholds | Product + SRE/Operations |
| HD20-16 | Metric cardinality, retention, access and rare-population suppression | Fixed minimal T1 metrics | Blocks production portal telemetry backend/config | SRE + Privacy/Data Governance |
| HD20-17 | Audit fields, retention, access, archival/immutability technology and restore objective | Minimal relational audit shell; no indefinite retention or export | Blocks production audit compliance/support claim | Security/Audit + Records/Privacy + Data Reliability |
| HD20-18 | Which aggregates, dimensions, time buckets and data-quality thresholds are approved | Only fictional operational aggregates | Blocks production evidence views | Product/Data Owner + Privacy/Legal |
| HD20-19 | Approved operational installation identifiers/aliases | Opaque fictional IDs only | Blocks human-friendly production support workflows | IAM/Asset/Data Governance + Privacy |
| HD20-20 | Export purposes, fields, formats, recipients, encryption, expiry, retrieval and deletion | Export feature T1-only and disabled in production | Blocks production export | Data Owner/Controller + Privacy/Legal/Security/Records |
| HD20-21 | Deletion selector types, authority, holds, deadlines, status wording and legal response | T1 lifecycle mechanism only; no real request outcome | Blocks production deletion/rights handling | Data Controller/Records/Legal/Privacy + Lifecycle owner |
| HD20-22 | Connector destinations, purposes, owners, contracts, secret system, deletion evidence and recipient copies | Fictional registered connector only | Blocks production integrations | Integration Owner + Security/Privacy/Legal/Procurement |
| HD20-23 | Support promise, safe failure set, support levels/hours, permit approvers, bundle access/retention | T1 blind-support only | Blocks production support workflow | Product Support + Security/Privacy/Operations |
| HD20-24 | Kill-switch and emergency recovery authorities, scope, expiry and communication | T1 control only; production source remains disabled | Blocks production emergency operation | Product Security/Incident + Release/Operations |
| HD20-25 | Rollout rings, health gates, pause/rollback thresholds, maintenance windows | T1 fictional plan only | Blocks production release/task rollout | Release/Product Risk + Operations/SRE |
| HD20-26 | Whether cross-realm oversight exists | No cross-realm view | Blocks central multi-realm dashboard | Data Controller/Product Governance + IAM/Privacy |
| HD20-27 | Whether free-form search, saved views or user preferences are allowed and retained | Closed filters; local non-sensitive presentation preferences only | May reduce convenience; blocks advanced production personalization | Product + Privacy/Security/Records |
| HD20-28 | Direct DB break-glass authority, conditions, audit, reconciliation and drills | No normal DB access; break-glass undefined and disabled | Severe recovery remains an operations decision, not portal bypass | Security/Database Operations/Data Reliability |
| HD20-29 | Ownership, on-call, incident command, support, accessibility remediation and release cadence | Capability disabled when blocking owner absent | Blocks Prompt 20 aggregate gate | Engineering/Operations Leadership |
| HD20-30 | Budget, staffing, licenses, assistive technology, user research, lab and commercial support | No unapproved spend/dependency | Blocks selected stack and sustainable recurring test matrix | Product/Finance/Procurement/Legal/Leadership |
| HD20-31 | Pilot and production risk acceptance | T1 lab only | Blocks pilot/production even after technical pass | Designated Production/Risk Authority |

## 10.3 Owner questions

### Product and governance

1. Which three to five workflows are genuinely most frequent, most consequential, and most time-sensitive?
2. Which questions must administrators answer, and which questions must the portal intentionally not answer?
3. What language prevents UAM aggregates from being interpreted as productivity, disciplinary, or forensic certainty?
4. Is operational installation detail sufficient? What exact approved purpose would justify any activity/person detail?
5. What constitutes a high-risk action, and which require maker/checker, quorum, or recent authentication?
6. Which changes may be scheduled, which require immediate activation, and which must remain unavailable outside release/incident authority?

### IAM and security

7. What enterprise identity inputs are authoritative, and how are they mapped to UAM capability revisions?
8. Which capability combinations are prohibited even when one person belongs to multiple upstream groups?
9. How quickly must revocation take effect, and what happens to in-progress drafts, approvals, sessions, and jobs?
10. Which emergency authorities exist if the ordinary IAM, portal projection, or notification path is impaired?
11. What direct DB/break-glass procedure exists, and how is it proven exceptional, time-limited, independently approved, and reconciled?

### Accessibility and localization

12. Is WCAG 2.2 AA the formal policy, and which EN 301 549 clauses/support documents apply to procurement and conformance evidence?
13. Which browser/AT combinations receive a support commitment, and how often are they requalified?
14. Who can accept an accessibility exception, for how long, and can a critical workflow ship with one? The recommended answer for critical workflows is no.
15. Which languages, RTL layouts, date/number formats, and time-zone displays are required?
16. Who owns translated safety terminology, error messages, runbooks, and notifications?

### Operations, support, and data

17. What freshness classes and thresholds must be visible, and when does stale/partial data block an action?
18. Which safe diagnostic signals must solve which support cases without raw data?
19. What notification needs immediate human acknowledgement versus ordinary work-queue handling?
20. What exact audit evidence must be searchable, for how long, and by whom?
21. Which exports/integrations create copies UAM cannot control, and how will that limitation be communicated?
22. Which deletion targets, holds, backups, exports, connectors and recipients are in scope, and what technical state words are approved?
23. What performance and task-success objectives justify the selected framework/design system and staffing model?

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 CLI/lab evidence rules

Every command below is a repository-owned wrapper or illustrative project path. Exact tool/package versions are selected, locked, and admitted at execution time. Commands use placeholders and T1 data only. No host, user, address, credential, token, certificate private material, production identifier, raw activity, internal URL, or SSH configuration may appear in evidence.

Every experiment writes an immutable evidence envelope containing:

```text
experiment ID and one falsifiable claim
source tree and dirty-state digest
portal/BFF/domain artifact and file-manifest digests
SDK/runtime/package/browser/AT/OS test-profile identities
route/command/capability/schema/catalogue digests
fixture/oracle/canary root digests
seed, fixed clock, scenario and fault-plan digests
start/end UTC and sanitized environment class
all test outcomes, first failure, rerun links and shrink/reproducer
accessibility tree/transcript/screenshot evidence as approved
performance/generator saturation and resource evidence
all-sink canary/cardinality results
owner/reviewer, ADRs, exceptions and expiry
cleanup/revert receipt and final residue inventory
```

A rerun never overwrites the first failure. Harness failure is neither product pass nor product fail. Cleanup failure is a gate failure.

## 11.2 Ordered experiments

### E20-00 — input and evidence manifest

```bash
./eng/portal/evidence-inputs verify \
  --allowlist eng/portal/prompt20-inputs.json \
  --out artifacts/e20-00-inputs
```

**Must produce:** exact eight input names/hashes, source date, public-source register digest, no extra project file, clean evidence directory.  
**Pass:** exact allowlist and hashes in this result.  
**Fail:** missing, substituted, changed, or extra project input.

### E20-01 — deterministic T1 portal fixture and oracle

```bash
dotnet run --project src/tools/Uam.PortalFixture -- \
  generate --profile prompt20-t1 --seed 2001 \
  --out artifacts/fixtures/run-a

dotnet run --project src/tools/Uam.PortalFixture -- \
  generate --profile prompt20-t1 --seed 2001 \
  --out artifacts/fixtures/run-b
./eng/portal/compare-canonical artifacts/fixtures/run-a artifacts/fixtures/run-b
```

**Must produce:** byte-identical canonical fixture roots, 6k/173 shape, two-realm collisions, truth ledger, canary registry, lineage, deletion manifest.  
**Pass:** deterministic equality; no real value; exact safe catalogue counts; independent oracle.  
**Fail:** nondeterminism, copied catalogue value, unclassified data, oracle dependency on production decisions.

### E20-02 — contract and route catalogue

```bash
dotnet test tests/Uam.Portal.Contracts.Tests \
  --logger "trx;LogFileName=e20-02-contracts.trx"
dotnet run --project src/tools/Uam.PortalContractCheck -- \
  verify --release-manifest artifacts/release/manifest.json
```

**Must produce:** route/read/command/problem/schema inventory; owners; capabilities; risk/preview/audit/limits; valid/invalid vectors; runtime route reconciliation.  
**Pass:** every route/command owned and closed; zero generic mutation/proxy; no authority-bearing realm/actor field.  
**Fail:** unregistered route/action, missing owner, unknown fields accepted, generic editor/proxy.

### E20-03 — repository architecture and hidden-action mutations

```bash
dotnet test tests/Uam.Portal.Architecture.Tests
./eng/portal/run-architecture-mutations --profile prompt20
```

Inject one forbidden browser DB/API dependency, persistence DTO, dynamic route, generic PATCH, plugin discovery, arbitrary destination, direct audit bypass, and hidden action, then revert each.

**Must produce:** dependency graph, API/package/action mutations and results, clean-tree proof.  
**Pass:** every mutation fails.  
**Fail:** one forbidden mutation builds or runs.

### E20-04 — authorization and realm matrix

```bash
dotnet test tests/Uam.Portal.Authorization.Tests \
  --filter Category=Prompt20 \
  --logger "trx;LogFileName=e20-04-authz.trx"
```

**Must produce:** every persona × route × action × state × two-realm result, reference/implementation comparison, minimal counterexample, cache/session negative results.  
**Pass:** exact equality and zero cross-realm success/existence leak.  
**Fail:** any mismatch or client claim changes authority.

### E20-05 — session, CSRF, cache and browser-storage lane

```bash
npm --prefix src/portal-web ci
npm --prefix src/portal-web run test:session-security -- \
  --evidence artifacts/e20-05-session
```

**Must produce:** cookie/session rotation, CSRF/origin/content-type matrix, logout/realm-switch/multi-tab/back-forward results, cache/storage/service-worker inventory.  
**Pass:** no cross-site mutation or sensitive retained client state.  
**Fail:** stale realm, browser token/secret, shared cache, or state-changing request without proof.

### E20-06 — command state, preview, approval, idempotency and audit failpoints

```bash
dotnet test tests/Uam.Portal.Commands.ModelTests
./eng/portal/run-command-failpoints --profile all-high-risk \
  --out artifacts/e20-06-commands
```

**Must produce:** deterministic state histories and DB snapshots for every boundary in P20-02.  
**Pass:** stale/changed content never commits; one effect; atomic audit.  
**Fail:** duplicate, overwrite, approval reuse, mutation/audit mismatch, or unknown recovery state.

### E20-07 — screen semantics and automated accessibility

```bash
npm --prefix src/portal-web run test:components
npm --prefix src/portal-web run test:a11y:auto -- \
  --fixture prompt20-t1 --out artifacts/e20-07-a11y-auto
```

**Must produce:** HTML/accessibility-tree snapshots, names/roles/states, landmark/heading/form/error/table/dialog/live-region assertions, automated violations and positive-control detection.  
**Pass:** zero unresolved A/AA automated finding in critical routes and every deliberate semantic mutation detected.  
**Fail:** missing positive control, incorrect semantic relation, or scanner pass presented as full conformance.

### E20-08 — manual keyboard, AT, zoom, forced-colors and reduced-motion lane

```bash
./eng/portal/a11y-session prepare --profile edge-narrator
./eng/portal/a11y-session prepare --profile firefox-nvda
./eng/portal/a11y-session evidence-check artifacts/e20-08-a11y-manual
```

The wrappers prepare instructions/evidence schemas; human execution is required.

**Must produce:** exact browser/AT/OS profile, task/keyboard/focus/spoken transcript, 400% zoom/forced-color/reduced-motion/RTL evidence, issue severity and retest.  
**Pass:** every critical workflow and emergency route succeeds.  
**Fail:** one blocking inaccessible control/state/recovery.

### E20-09 — task-success study

```bash
./eng/portal/usability-session prepare \
  --tasks eng/portal/tasks/prompt20-critical.json \
  --fixture prompt20-t1
./eng/portal/usability-session aggregate artifacts/e20-09-task-sessions
```

**Must produce:** sanitized per-task outcomes from section 8.5, no participant personal data beyond approved research metadata, wrong-scope/unsafe attempts, assistance, direct-DB/raw-detail requests, findings and design changes.  
**Pass:** owner-approved task criteria and zero wrong-scope high-risk commit.  
**Fail:** systemic blocker, unsafe workaround, or real/production data in evidence.

### E20-10 — design-system/framework bake-off

```bash
./eng/portal/bakeoff run \
  --scenario eng/portal/scenarios/component-bakeoff.json \
  --candidates eng/portal/candidates/approved.json \
  --out artifacts/e20-10-bakeoff
```

**Must produce:** exact tags/commits/packages/licenses/assets, lock/SBOM/provenance, component source map, bundle/performance, AT/keyboard, semantic regression, upgrade/removal exercise, security/advisory posture, team skill/support notes.  
**Pass:** selected candidate passes every hard gate; decision does not use popularity.  
**Fail:** license/provenance gap, inaccessible critical component, unbounded bundle, hidden plugin/action, or no safe candidate.

### E20-11 — large-list, preview, performance and memory lane

```bash
npm --prefix src/portal-web run test:perf -- \
  --scenario prompt20-6k-173 \
  --profiles eng/portal/perf/profiles.json \
  --out artifacts/e20-11-performance
```

**Must produce:** offered interactions, generator saturation, asset/network, LCP/INP/CLS, API time, long tasks, DOM nodes, heap over navigation loop, screen-reader interaction timing, stale-cursor behavior.  
**Pass:** section 8.6 or approved replacements; bounded DOM/memory; zero semantic/privacy weakening.  
**Fail:** saturated generator, full 6k DOM, blocked emergency action, unbounded growth, or inaccessible optimization.

### E20-12 — rollout/kill/rollback fault lane

```bash
dotnet test tests/Uam.Portal.Rollout.Tests
./eng/portal/run-rollout-faults --profile prompt20 \
  --out artifacts/e20-12-rollout
```

**Must produce:** exact eligibility/ring/control/job/audit timeline under projection, notification, BFF and response faults; accessible emergency-route evidence.  
**Pass:** staged/kill/repreview/higher-sequence rollback invariants.  
**Fail:** stale work, inaccessible kill, unknown success, or lower sequence.

### E20-13 — export/lifecycle/integration safety lane

```bash
dotnet test tests/Uam.Portal.EgressLifecycle.Tests
./eng/portal/run-egress-lifecycle-faults --profile prompt20 \
  --out artifacts/e20-13-egress-lifecycle
```

**Must produce:** export schema/canary/formula results, object/key lifecycle, SSRF/redirect/rebinding/secret results, deletion barrier/read probes/holds/external limitations, restore isolation/readiness.  
**Pass:** P20-06.  
**Fail:** forbidden egress, secret exposure, reappearance, false completion, or pre-ready restore read.

### E20-14 — diagnostics/support blind exercise

```bash
dotnet test tests/Uam.Portal.Support.Tests
./eng/portal/support-exercise prepare --corpus prompt20-safe-failures
./eng/portal/support-exercise evaluate artifacts/e20-14-support
```

**Must produce:** permit matrix, analyzer/canary, deterministic bundle-before-encryption, blind task scorecard, expiry/revoke/delete/cleanup.  
**Pass:** required failures diagnosed with safe data; no arbitrary capability.  
**Fail:** raw escape, unresolved required failure, plaintext residue, or permit overrun.

### E20-15 — portal observability and cardinality

```bash
dotnet test tests/Uam.Portal.Observability.Tests
./eng/portal/cardinality-check --catalogue eng/portal/telemetry-catalogue.json \
  --out artifacts/e20-15-observability
```

**Must produce:** theoretical/observed series, unknown-label rejection, all-sink canary, no session-replay/generic analytics bundle scan.  
**Pass:** finite approved budget and zero forbidden value.  
**Fail:** dynamic label/event, canary escape, or unapproved third-party telemetry.

### E20-16 — browser/BFF release, upgrade and rollback

```bash
./eng/portal/release-matrix --from previous --to candidate \
  --active-drafts-jobs --out artifacts/e20-16-release
```

**Must produce:** same-digest asset promotion, old/new contract matrix, active draft/job readability, rollback, stale browser behavior, accessibility/performance rerun, cleanup.  
**Pass:** no unsupported command executes; drafts/jobs/audit remain coherent; prior known-good restored.  
**Fail:** mixed client/server semantics, hidden action, data loss, or inaccessible rollback release.

### E20-17 — incident runbooks

```bash
./eng/portal/runbook-exercise --catalogue eng/portal/runbooks/prompt20.json \
  --out artifacts/e20-17-runbooks
```

**Must produce:** exercise timeline for all section 7.4 incidents, owner/authority decisions, containment, evidence, recovery, cleanup, re-enable condition.  
**Pass:** every incident contained without direct normal DB access/raw data/hidden command; all cleanup proved.  
**Fail:** unassigned owner, unsafe workaround, missing evidence, or self-reenable.

### E20-18 — aggregate gate

```bash
dotnet run --project src/tools/Uam.PortalGate -- \
  evaluate --profile prompt20 \
  --evidence artifacts \
  --out artifacts/prompt20-gate.json
```

**Must produce:** the gate artifact in section 9.8 with all exact input/evidence/owner/ADR/expiry/first-failure/cleanup references and `productionApproved=false`.  
**Pass:** exact expression in section 8.8.  
**Fail:** no partial permission; failed lane and dependent backlog stop.

---

# 12. ADR proposals

| ADR | Decision | Proposed status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-P20-001 | Same-origin ASP.NET Core control BFF; browser is presentation only | **Accept** | Public SPA API, direct module API | Preserves authenticated context, realm, audit and modular-monolith decisions | Portal Architecture/IAM | Deployment topology constraint or security incident |
| ADR-P20-002 | Task-oriented realm-scoped IA in section 3.5 | **Accept for prototype** | Service-centric navigation, generic dashboard | Covers supplied workflows with aggregate-first defaults | Product Design | Human priority-workflow research |
| ADR-P20-003 | Aggregate-first least-detail and no activity/person detail route initially | **Accept** | Default event/person drill-down | Minimization, misuse containment, human decision boundary | Product/Data Governance/Privacy | Approved purpose/detail decision |
| ADR-P20-004 | Explicit read models and named command endpoints; no generic CRUD/PATCH/editor | **Accept** | Admin generator, GraphQL mutations, table editor | State/preview/reason/audit/realm safety | Domain Architecture | Demonstrated missing capability requiring contract extension |
| ADR-P20-005 | Server-resolved filter snapshot and impact preview for bulk/high-risk actions | **Accept** | Browser selected IDs, direct execute | Prevents stale/incomplete scope and exposes unknowns | Data Correctness/Domain | Performance evidence requires async preview variant |
| ADR-P20-006 | `If-Match` + domain version + stable command ID/idempotency | **Accept** | Last-write-wins, random retry | Prevents overwrite/duplicate and handles response loss | Domain/API owner | Contract interoperability issue |
| ADR-P20-007 | Privileged transition and authoritative audit in one transaction | **Accept** | Async-only audit | Accepted audit invariant and failpoint safety | Audit/Data Reliability | Different storage mechanism proves equivalent atomicity |
| ADR-P20-008 | Immutable draft/review/approval/publish; rollback is higher revision | **Accept** | In-place edit and lower-version rollback | Preserves predecessor monotonic control rules | Domain Governance | State-machine counterexample |
| ADR-P20-009 | Staged rollout plus separate narrowing kill switch and accessible emergency route | **Accept** | Big-bang rollout, hidden emergency endpoint | Failure containment and operations/accessibility | Release/Incident | Measured workflow/availability evidence |
| ADR-P20-010 | Feature flags can only narrow/disable and never bypass core invariants | **Accept** | General experimentation flag engine | Protects privacy, realm, audit, tombstone, release | Product Security/Release | Explicit change proposal only |
| ADR-P20-011 | WCAG 2.2 AA workflow target; current EN 301 549 mapping tracked | **Accept** | WCAG 2.1 only, automated-only claim | Current primary standards and future applicability | Accessibility/Product | EN 301 549 V4 final publication or policy change |
| ADR-P20-012 | Native HTML first; design system/framework selected by identical bake-off | **Proposed / blocking production** | Preselect PatternFly/Fluent/Carbon/Blazor | No UAM-specific accessibility/performance/dependency proof | Front-end/Accessibility/Architecture | E20-10 result, major upgrade/incident |
| ADR-P20-013 | Server pagination, opaque cursors, no full-fleet browser list | **Accept** | Client-side full list/virtualization by default | Bounded performance/privacy and AT safety | Portal/Data Platform | Measured use case needing different bounded view |
| ADR-P20-014 | Standard page-state taxonomy with explicit stale/offline/partial/unknown | **Accept** | Blank/zero/generic error | Prevents evidence misinterpretation | Product/Data Quality | Human terminology policy |
| ADR-P20-015 | Closed RFC 9457 safe error profile | **Accept** | Dynamic exception/API errors | Interoperability and privacy-safe recovery | API/AppSec | New standard or consumer need |
| ADR-P20-016 | In-portal typed notifications first; external channels deferred | **Accept for prototype** | Email/webhook by default | Reduces disclosure/SSRF/alert surface while ownership open | Operations/Product | Human notification decision and connector proof |
| ADR-P20-017 | Export is a named data product with manifest, approval, expiry and limitation | **Accept mechanism** | Generic table download | Minimization, egress, deletion truth | Data Governance/Export | Approved production export profile |
| ADR-P20-018 | Connector administration uses registered destination/secret references only | **Accept** | Arbitrary URL/secret form | SSRF/secret/contract containment | Integration/Security | New connector class and full gate |
| ADR-P20-019 | Deletion UI follows barrier-first lifecycle and truthful limitations | **Accept** | Direct row delete/soft delete only | Accepted Batch 04 lifecycle invariant | Lifecycle/Data Reliability | Baseline change proposal only |
| ADR-P20-020 | Support uses closed D0–D2 permits/bundles; no arbitrary command/file/dump | **Accept** | Remote shell/generic logs/dumps | Accepted Batch 03 support boundary | Support/Security/Privacy | Defined support case cannot be solved safely |
| ADR-P20-021 | Portal telemetry is finite, value-free and no session replay | **Accept** | Generic web analytics/replay | Privacy/cardinality and admin sensitivity | SRE/Privacy | Approved telemetry expansion with evidence |
| ADR-P20-022 | No service-worker caching/offline mutation initially | **Accept** | Offline-capable portal | Avoids stale authority/replay/cache risk | Portal Security | Approved offline requirement and protocol |
| ADR-P20-023 | Cross-realm combined views absent by default | **Accept** | Central multi-realm dashboard | Realm isolation and minimization | Product Governance/IAM | Approved oversight purpose and dedicated gate |
| ADR-P20-024 | Prompt 20 gate expression and evidence schema | **Accept** | Manual checklist/pass | Reproducibility and hard-gate aggregation | Verification Governance | Gate defect or superior evidence system |

No ADR may be marked accepted for production while its accountable owner is `UNASSIGNED`, its named human decision is absent, or its CLI gate is open.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Phased portal backlog and acceptance criteria — mandatory artifact

### Phase 0 — governance and contract foundation

| Order | Repository task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 1 | Record Prompt 20 input/source/evidence manifest | None | E20-00 passes | Any unallowlisted/missing input |
| 2 | Create portal route/read/command/capability/risk/reason/error/state catalogue schemas | Batch 01 contract rules | Every entry owned, closed, versioned | Generic/unowned action or authority field |
| 3 | Create T1 portal fixture/oracle/canary package | G0 accepted rules | E20-01 passes; exact 6k/173 shape | Nondeterminism or real value |
| 4 | Create ADRs, owner and human-decision registers | 1–3 | No silent decision or owner gap | Blocking `UNASSIGNED` for next phase |
| 5 | Add architecture tests and forbidden dependencies/APIs | Repository scaffold | E20-03 baseline passes | Forbidden mutation survives |

**Phase 0 permission:** contracts, fixtures, pure models, schemas, tests.  
**Phase 0 prohibition:** authenticated production routes, live data, production role mapping.

### Phase 1 — BFF/session/realm/authorization skeleton

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 6 | Implement same-origin BFF host and opaque server session abstraction | Phase 0 | No browser token/secret; strict headers/cache | Session/CSRF design unresolved |
| 7 | Implement realm context broker and switch lifecycle | 6 | Realm visible; switch rotates/clears/re-authorizes | Cross-realm cache/session result |
| 8 | Implement capability policy evaluator and immutable server authorization context | 2,6–7 | E20-04 reference matrix | One direct-route mismatch |
| 9 | Implement screen read-model envelope, safe errors, route catalogue reconciliation | 2,8 | E20-02; no persistence types | Generic proxy/entity exposure |
| 10 | Implement CSRF/session/cache/storage negative tests | 6–9 | E20-05 passes | Cross-site mutation or sensitive storage |

**Stop gate BFF-1:** zero browser authority, zero cross-realm success, zero unregistered route.

### Phase 2 — standards-first shell and read-only IA

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 11 | Implement semantic global frame, skip link, realm/environment, primary navigation | Phase 1 | Keyboard/landmark/heading tests | Inaccessible realm/emergency context |
| 12 | Implement standard page-state components | 11 | All states in 3.8; no zero/no-data collapse | Stale/offline misrepresented |
| 13 | Implement server-paged list/filter/cursor components and routes | 9,11–12 | Bounded, stable, accessible table/list | Full-list/browser authority |
| 14 | Implement read-only Overview, Fleet Health, Population/Eligibility | 12–13 | Aggregate-first contracts and data quality | Raw/detail field or unbounded list |
| 15 | Implement read-only Policy, Application Registry/Quality, Release/Job, Audit shells | 12–13 | Least-detail and exact state/as-of | Generic entity model exposed |
| 16 | Run component/framework/design-system bake-off | 11–15 | E20-10 selects or reports no winner | No candidate passes hard gates |

**Stop gate IA-1:** critical read-only workflows pass keyboard/AT/zoom/forced-colors and show correct realm/freshness/quality.

### Phase 3 — reusable safe command infrastructure

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 17 | Implement immutable filter snapshot and impact preview service | Phase 2 | Exact scope/diff/unknowns/expiry | Preview TOCTOU failure |
| 18 | Implement command gateway, `If-Match`, command ID/idempotency and safe result | 17 | E20-06 identity/version cases | Duplicate/overwrite/unknown state |
| 19 | Implement same-transaction privileged audit and reconciler | 18 | Atomic failpoints pass | Mutation without audit |
| 20 | Implement generic revision/approval state modules as code libraries, not workflow language | 18–19 | Exact finite transitions/digests | Dynamic tenant workflow/action |
| 21 | Implement durable job/progress/cancel/retry model | 18–20 | Browser/BFF restart recovery; first failure retained | In-memory-only progress or duplicate child |
| 22 | Implement in-portal notification inbox/dedupe/ack | 21 | Safe templates, no business-state authority | Sensitive/dynamic notification |

**Stop gate CMD-1:** P20-02 passes for every high-risk command archetype.

### Phase 4 — domain workflows

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 23 | Policy draft/validate/preview/review/publish/rollback | Phase 3 + accepted policy model | Tenant never broadens; higher revision rollback | Any broadening or wrong-realm activation |
| 24 | Application import/data-quality/revision workflow with 173-row fixture | 23 shared infrastructure | Missing refs non-authoritative; no semantic inference | Name/ref used as identity/rule |
| 25 | Rule conflict/analyzer/snapshot publish workflow | 24 | Ambiguity explicit; no first-match | Guessed target/unknown treated safe |
| 26 | Release rollout/rings/health/pause/kill/resume/rollback | 21–23 | P20-05 and E20-12 | Stale work, inaccessible kill, lower sequence |
| 27 | Task/job and privileged-audit operator screens | 21,26 | Durable exact progress/evidence | Notification presented as completion |

**Stop gate WF-1:** policy, registry, rule and rollout critical tasks pass authorization, atomic audit, accessibility and recovery.

### Phase 5 — operations, egress, lifecycle and support

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 28 | Diagnostics/error aggregate and safe runbook screens | Phase 2/3 + Batch 03 catalogue | Finite safe states/cardinality | Raw exception/value or unbounded label |
| 29 | Support case/permit/bundle workflow | 28 + human support scope for production | P20-08 T1 pass | Arbitrary capability or raw escape |
| 30 | Integration revision/test/activate/deactivate screen | Phase 3 + registered fictional connector | SSRF/secret tests pass | Arbitrary URL/secret or false receipt |
| 31 | Export preview/generate/retrieve/revoke/delete screen | Phase 3 + approved T1 profile | Manifest/canary/formula/expiry pass | Generic export or forbidden field |
| 32 | Deletion/lifecycle/hold/limitation screen | Phase 3 + Batch 04 lifecycle prototype | Barrier/read probes and truthful state | Re-exposure or false completion |
| 33 | Restore-readiness read-only screen and environment banner | 32 + restore evidence | No ordinary read/egress before readiness | Restore appears production-ready early |

**Stop gate OPS-1:** E20-13/14 pass. Production features remain disabled until corresponding human decisions and Batch 04/03 gates.

### Phase 6 — accessibility, usability, localization and performance qualification

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 34 | Complete automated semantic/component coverage and positive controls | Phases 2–5 | E20-07 | Scanner/harness miss or critical violation |
| 35 | Execute keyboard/AT/zoom/forced-colors/reduced-motion/RTL matrix | 34 | E20-08 | One critical blocker |
| 36 | Conduct human-approved representative task research | 35 + HD20-01/02 | E20-09 criteria | Wrong-scope commit/systemic unsafe workaround |
| 37 | Run 6k/173 performance/memory/slow-dependency profiles | Phases 2–5 | E20-11 | Generator saturation/unbounded client/action delay |
| 38 | Verify portal observability/cardinality/all-sink canaries | All | E20-15 | Dynamic/forbidden telemetry |
| 39 | Run browser/BFF upgrade/rollback and active-state matrix | All | E20-16 | Mixed semantics/data loss/inaccessible rollback |
| 40 | Exercise incident runbooks | All | E20-17 | Unassigned/unsafe recovery or cleanup failure |

### Phase 7 — aggregate Prompt 20 gate

| Order | Task | Depends on | Acceptance | Stop gate |
|---:|---|---|---|---|
| 41 | Resolve blocking ADR/owner/human decisions for intended scope | Phases 0–6 | No blocking unresolved item; disabled features explicit | Missing authority or silent default |
| 42 | Run aggregate evaluator | 41 | E20-18 `PASS`, `productionApproved=false` | Any hard invariant/evidence/cleanup failure |
| 43 | Submit result and evidence to Batch 05 reviewer | 42 | Reviewer accepts/conditions architecture | No independent production permission |

## 13.2 Dependency graph

```text
contracts + T1 fixtures + architecture tests
  -> BFF/session/realm/authz
  -> semantic shell + page states + bounded reads
  -> design-system/framework decision
  -> preview/idempotency/concurrency/atomic audit/jobs
  -> policy/registry/rule/release workflows
  -> diagnostics/integrations/exports/deletion/support
  -> accessibility + task success + performance + incident evidence
  -> Prompt 20 technical gate
  -> Batch 05 review
  -> separate human pilot/production decision
```

No domain workflow may bypass the shared command/audit/preview infrastructure for schedule convenience. No accessibility test is deferred until “after functionality”; component and route tests begin in Phase 2 and remain release gates.

## 13.3 Explicit stop/go gates

**GO now:** sections 0–3 of the backlog using T1 fictional data, including contracts, fixtures, BFF skeleton, read-only aggregate screens, architecture tests, and design-system bake-off.

**STOP** before production role mapping, production authentication exposure, high-risk mutation, live activity/detail, export, deletion, connector activation, diagnostic permits, rollout, production support, or production deployment until the named human decisions and CLI gates pass.

A failed gate opens the corresponding ADR and stops dependent work. It never authorizes a weaker undocumented workaround, direct database edit, hidden endpoint, raw diagnostic, or accessibility exception for a critical workflow.

---

# 14. Open-source repository assessment table

## 14.1 Assessment method and decision rule

**FACT.** Open-source projects were reviewed as design evidence, not as automatic dependencies. Popularity, screenshots, vendor reputation, or a successful demonstration do not prove UAM accessibility, authorization, privacy, realm isolation, recovery, supportability, licensing fitness, or lifecycle cost.

A repository may be classified as:

- **dependency candidate** — only after the exact package/source/binary, license, transitive graph, maintenance, security, accessibility, test, bundle, and removal gates pass;
- **reference only** — useful patterns or negative lessons, but the runtime/source is not proposed for UAM;
- **neither** — no material reusable value or unacceptable unresolved risk.

The design-system bake-off in E20-10 may select **at most one** general component system for the first slice. A no-winner result is acceptable; UAM can use standards-first local components rather than lowering a hard gate. No reviewed fleet/admin product is an architectural template for the UAM control plane.

## 14.2 Repository assessment

| Ref | Repository and exact review point | Relevant files/directories | License and compatibility | Maintenance, testing, and security posture at review | Architectural fit, reusable ideas, and prohibited copying | Classification |
|---|---|---|---|---|---|---|
| **O01** | [PatternFly React](https://github.com/patternfly/patternfly-react), release [`v6.6.0`](https://github.com/patternfly/patternfly-react/releases/tag/v6.6.0), released 28 July 2026, release commit [`6f2385b`](https://github.com/patternfly/patternfly-react/commit/6f2385b) | [`packages/react-core`](https://github.com/patternfly/patternfly-react/tree/v6.6.0/packages/react-core), [`react-table`](https://github.com/patternfly/patternfly-react/tree/v6.6.0/packages/react-table), [`react-templates`](https://github.com/patternfly/patternfly-react/tree/v6.6.0/packages/react-templates), [`react-integration`](https://github.com/patternfly/patternfly-react/tree/v6.6.0/packages/react-integration), `testSetup.ts`, docs/examples | MIT. Trademark/brand assets and icon choices still require ordinary product/legal review. | Current release activity; package, integration, example, and test structure is visible. The reviewed release added a high-contrast option and RTL table/status corrections. Upstream component tests and examples are useful but do not prove a complete UAM workflow with the chosen browsers and assistive technologies. A dedicated security policy was not established as a load-bearing fact in this review. | Strong fit for dense enterprise navigation, tables, banners, drawers, progress, empty/error states, and accessibility-oriented examples. Reuse component semantics and test cases. Do **not** copy a component merely because its example renders; UAM must own focus recovery, bulk-action confirmation, realm/staleness context, and command safety. | **Dependency candidate after E20-10**; also a strong reference. |
| **O02** | [Fluent UI](https://github.com/microsoft/fluentui), exact package release cluster on 26 May 2026 at source revision `9317e51`; representative tag [`@fluentui/react-tree_v9.16.1`](https://github.com/microsoft/fluentui/releases/tag/%40fluentui%2Freact-tree_v9.16.1), with `react-aria` `9.17.12`, `react-tabster` `9.26.15`, tooltip `9.10.2`, toolbar `9.8.1`, and toast `9.7.18` in the same release cluster | [`packages/react-components/react-aria`](https://github.com/microsoft/fluentui/tree/%40fluentui%2Freact-tree_v9.16.1/packages/react-components/react-aria), [`react-tabster`](https://github.com/microsoft/fluentui/tree/%40fluentui%2Freact-tree_v9.16.1/packages/react-components/react-tabster), [`react-dialog`](https://github.com/microsoft/fluentui/tree/%40fluentui%2Freact-tree_v9.16.1/packages/react-components/react-dialog), [`react-table`](https://github.com/microsoft/fluentui/tree/%40fluentui%2Freact-tree_v9.16.1/packages/react-components/react-table), [`react-tree`](https://github.com/microsoft/fluentui/tree/%40fluentui%2Freact-tree_v9.16.1/packages/react-components/react-tree) | MIT source license; the repository license explicitly states that referenced fonts and icons have separate terms. Exact asset use requires Legal/Brand review. | Active package releases and a large component/conformance structure. Fine-grained package publication improves selective adoption but creates a larger exact-version and transitive-compatibility burden. The reviewed tree contains dedicated ARIA, focus-navigation, and component packages; UAM still must prove integrated workflows and browser/AT behavior. | Useful for native Windows/Microsoft visual familiarity, focus management, trees, dialogs, tables, toasts, and accessible primitives. Do **not** adopt the whole package family, browser token assumptions, or Fluent role semantics by default. Pin only the minimum package closure and forbid preview/compat components unless separately admitted. | **Dependency candidate after E20-10**; exact package set, assets, and transitive closure are blocking. |
| **O03** | [Carbon Design System](https://github.com/carbon-design-system/carbon), release [`v11.113.0`](https://github.com/carbon-design-system/carbon/releases/tag/v11.113.0), released 30 July 2026, release commit [`a57cf8a89`](https://github.com/carbon-design-system/carbon/commit/a57cf8a89) | [`packages/react`](https://github.com/carbon-design-system/carbon/tree/v11.113.0/packages/react), [`packages/styles`](https://github.com/carbon-design-system/carbon/tree/v11.113.0/packages/styles), [`packages/feature-flags`](https://github.com/carbon-design-system/carbon/tree/v11.113.0/packages/feature-flags), component examples/tests and release tooling | Apache-2.0; NOTICE, trademarks, icons, and bundled third-party assets require normal attribution and legal review. | Current release activity with a verified release commit. The reviewed release includes feature-flag notification improvements and a broad package release train. Component and package tests are useful; no upstream suite proves UAM authorization, recovery, or complete accessibility. | Useful for structured admin layouts, data tables, inline notifications, progress, forms, and design tokens. Do **not** allow Carbon's feature-flag package—or any design-system flag facility—to become an authority plane. UAM flags remain finite, server-evaluated, narrowing-only controls. | **Dependency candidate after E20-10**; reference for component/test patterns. |
| **O04** | [Fleet](https://github.com/fleetdm/fleet), release [`fleet-v4.89.2`](https://github.com/fleetdm/fleet/releases/tag/fleet-v4.89.2), released 24 July 2026, release commit [`89b1cb5`](https://github.com/fleetdm/fleet/commit/89b1cb5) | [`frontend`](https://github.com/fleetdm/fleet/tree/fleet-v4.89.2/frontend), `server`, `docs`, and separately licensed `ee` | Mixed. Client-side JavaScript and most code are MIT Expat; `docs/` is CC BY-SA 4.0; `ee/` uses a separate license. Source copying requires exact path/license provenance. | Active device-management release stream. The reviewed patch fixed a false-success software-install status and stale-version install behavior—direct evidence that administrative state labels and retries require explicit tests. Its broad endpoint-management and query surface has a materially different threat model from minimized UAM telemetry. | Reuse ideas for fleet-health facets, host-state vocabulary, rollout/error aggregation, filter chips, and visible failure. Do **not** copy raw host/query/detail access, software-management authority, generic query execution, or its commercial/enterprise boundaries. | **Reference only.** |
| **O05** | [Argo CD](https://github.com/argoproj/argo-cd), release [`v3.4.6`](https://github.com/argoproj/argo-cd/releases/tag/v3.4.6), released 31 July 2026, release commit [`e1becb7`](https://github.com/argoproj/argo-cd/commit/e1becb7) | [`ui`](https://github.com/argoproj/argo-cd/tree/v3.4.6/ui), `server`, `controller`, `manifests`, release-verification documentation | Apache-2.0. Kubernetes/Helm/container transitive use is irrelevant unless UAM later adopts those deployment paths. | Active patch release. The release page states that images are signed with cosign and provenance is generated for qualifying images/CLI binaries to SLSA Level 3. The project has broad controllers and integration tests, but its GitOps/Kubernetes correctness model differs from UAM realm/privacy authority. | Reuse ideas for desired-versus-observed diff, health state, staged synchronization, rollback visibility, resource history, and provenance presentation. Do **not** copy auto-sync as an authorization model, cluster credentials, repository plug-ins, manifest mutation, or “Git says desired” as business approval. | **Reference only.** |
| **O06** | [Backstage](https://github.com/backstage/backstage), release [`v1.53.1`](https://github.com/backstage/backstage/releases/tag/v1.53.1), released 29 July 2026, release commit [`eb8e4c0`](https://github.com/backstage/backstage/commit/eb8e4c0) | [`packages/core-components`](https://github.com/backstage/backstage/tree/v1.53.1/packages/core-components), `packages/app`, `plugins/catalog`, permission framework and test packages | Apache-2.0, with third-party notices and plug-in licenses requiring exact inventory. | Very active large monorepo and plug-in ecosystem. The reviewed patch changed configuration-schema errors so they no longer blocked build/start and became warnings; UAM must take the opposite posture for authority-bearing schemas. Testing breadth is substantial, but plug-in breadth increases supply-chain and authorization review. | Reuse navigation, search, catalogue relation, ownership display, and plug-in governance lessons. Do **not** adopt Backstage as the initial portal platform, use human-readable names as identity, or expose a plug-in marketplace/integration surface. UAM contracts remain closed and schema failure remains blocking. | **Reference only; not an initial dependency.** |
| **O07** | [Grafana](https://github.com/grafana/grafana), release [`v13.1.1`](https://github.com/grafana/grafana/releases/tag/v13.1.1), released 21 July 2026, release commit [`a9cee6e`](https://github.com/grafana/grafana/commit/a9cee6e) | [`public/app`](https://github.com/grafana/grafana/tree/v13.1.1/public/app), dashboard, alerting, pagination, and shared UI packages | GNU AGPL-3.0 for the reviewed repository. Network/server and modification obligations are material; no dependency is allowed without Legal approval and architecture analysis. | Active release. The reviewed patch fixed screen-reader announcement for `InlineToast`, added `aria-current` to active pagination, and fixed a stale dashboard data defect. Strong dashboard and alerting test experience does not prove UAM privacy or mutation safety; the plug-in/query surface is much broader. | Reuse ideas for aggregate dashboards, time/freshness labels, alert grouping, no-data/stale-state separation, and accessible notification/pagination tests. Do **not** copy query builders, arbitrary data-source plug-ins, dashboards as authority, or Grafana source into the portal. | **Reference only; dependency NO-GO pending Legal and a later ADR.** |
| **O08** | [Keycloak](https://github.com/keycloak/keycloak), release [`26.7.0`](https://github.com/keycloak/keycloak/releases/tag/26.7.0), released 9 July 2026, release commit [`6c73e30`](https://github.com/keycloak/keycloak/commit/6c73e30) | [`js/apps/admin-ui`](https://github.com/keycloak/keycloak/tree/26.7.0/js/apps/admin-ui), `services`, `testsuite`, realm/admin themes and authorization code | Apache-2.0 with NOTICE and third-party dependency review. | Active security- and standards-oriented release stream. The reviewed release strengthened client-level authorization and restricted an external-token API to confidential clients. It has extensive IAM/admin tests, but its purpose is to be an identity authority, not a minimized operational portal. | Reuse realm-switch visibility, explicit authorization, session, error, and admin-console testing ideas. Do **not** turn UAM into an identity provider, copy Keycloak's broad user/credential administration, or treat IdP roles as direct domain authority without UAM capability mapping. | **Reference only.** |

## 14.3 Consolidated open-source decision

**RECOMMENDATION.** PatternFly React, Fluent UI, and Carbon are the only reviewed general component-system candidates. E20-10 must compare the exact admitted package sets using the same UAM shell, critical components, keyboard model, screen-reader script, zoom/forced-colors/RTL cases, bundle budget, security headers, dependency inventory, release cadence, and removal prototype. The result may select one candidate or standards-first local components.

Fleet, Argo CD, Backstage, Grafana, and Keycloak are design and threat-model references only. Copying their product architecture would import permissions, data surfaces, plug-ins, identifiers, operational assumptions, licenses, or failure semantics that conflict with UAM's accepted baseline.

No repository assessment approves production use, procurement, support, trademark use, or ongoing maintenance capacity. Exact versions are review points; adoption requires execution-time lifecycle and advisory verification.

---

# 15. Source register with stable links, dates, versions/commits, claims, and limitations

## 15.1 Supplied project evidence

| Ref | Source and reviewed identity | Source/review date | Claim supported | Limitation |
|---|---|---|---|---|
| **I01** | `00-accepted-baseline-attachment.md`; SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Baseline 31 July 2026 | Accepted architecture, realm/privacy/audit/release/restore invariants and human-decision boundary | Condensed working baseline; not runtime, legal, access, or production proof |
| **I02** | `02-sanitized-application-catalogue-report.md`; SHA-256 `2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5` | Profiled 31 July 2026 | 173-record catalogue shape, missing external IDs, Unicode/truncation/address-like quality conditions, safe synthetic-fixture inputs | No raw values; no role, owner, purpose, rule, entitlement, lifecycle, sensitivity, usage, or currentness evidence |
| **I03** | `05-decisions-contradictions-and-gates.md`; SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | July 2026 synthesis | Accepted decisions, resolved tensions, proof-gate order, failed-gate stop rule | Implementation-research authority only; not production approval |
| **I04** | `06-research-evidence-rules.md`; SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | 2026 research package | Evidence labels, source hierarchy, human authority, confidentiality and conflict handling | Research-quality rules; not proof of a technical claim |
| **I05** | `batch-01-review-result.md`; SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Reviewed 31 July 2026 | Strict contracts, UUIDv7 identity, application registry/matcher, monotonic privacy controls, repository boundaries, G1 authority | Accepted predecessor with mandatory gates; not passed production behavior |
| **I06** | `batch-02-review-result.md`; SHA-256 `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Reviewed 31 July 2026 | Source/privacy boundary, interpretation separation, quality/freshness semantics, application ambiguity, aggregate limitations | Prototype authority; live-source and production gates remain open |
| **I07** | `batch-03-review-result.md`; SHA-256 `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Reviewed 31 July 2026 | Endpoint durability, release, identity/realm, closed diagnostics/support and exact compatibility concepts | No engineering canary or supported platform established by that review alone |
| **I08** | `batch-04-review-result.md`; SHA-256 `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Reviewed 1 August 2026 | Modular-monolith control boundary, durable audit, typed lifecycle/export/integration states, restore-readiness truth and portal technology deferral | Batch 04 gates open; no database/capacity/retention/production cleanup decision |

## 15.2 Standards, specifications, and primary guidance

| Ref | Stable source | Publication/review identity | Claim supported | Limitation |
|---|---|---|---|---|
| **W01** | W3C, [WCAG 2.2](https://www.w3.org/TR/2024/REC-WCAG22-20241212/) | W3C Recommendation, 12 December 2024 | Current stable WCAG 2.x target; A/AA criteria; complete-process conformance; keyboard, focus, reflow, target size, error prevention, accessible authentication and status-message requirements | Conformance still needs human evaluation; does not address every disability need or prove a particular workflow |
| **W02** | W3C, [WAI-ARIA 1.2](https://www.w3.org/TR/2023/REC-wai-aria-1.2-20230606/) | W3C Recommendation, 6 June 2023 | Roles, states, properties and interoperability semantics for accessible widgets | ARIA does not make an interaction accessible by itself; native HTML remains preferable where available |
| **W03** | W3C WAI, [ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/) | Living guide reviewed 1 August 2026 | Keyboard models, names/descriptions, landmarks, patterns and functional examples | Informative guidance/examples, not a conformance specification or UAM test result |
| **W04** | ETSI/CEN/CENELEC, [EN 301 549 V3.2.1](https://www.etsi.org/deliver/etsi_en/301500_301599/301549/03.02.01_60/en_301549v030201p.pdf) | Published 2021-03 | Current published European ICT accessibility requirement set at the research date, including web/software and assistive-technology interoperability | Older than WCAG 2.2; legal/procurement applicability is a human/legal decision |
| **W05** | ETSI TC Human Factors, [standards page](https://www.etsi.org/technical-groups/hf/) | Reviewed 1 August 2026 | ETSI listed EN 301 549 V4.1.0 (2026-06) as **On Approval** | Dynamic status page; not a final published standard and may change |
| **W06** | ETSI, [EN 301 549 revision work item REN/HF-00301561](https://portal.etsi.org/webapp/WorkProgram/Report_WorkItem.asp?WKI_ID=64282) | V4.1.0; final-deliverable voting initiated 25 June 2026; reviewed 1 August 2026 | Confirms the exact revision, approval activity, and need for a post-publication mapping review | Work-item state is process evidence, not final normative text |
| **W07** | IETF, [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/info/rfc9457/) | Proposed Standard, July 2023 | Common machine-readable API problem format and security warning against implementation-detail leakage | UAM must still define closed safe problem types/extensions; RFC examples are not privacy-safe defaults |
| **W08** | IETF, [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html) | Internet Standard, June 2022 | HTTP validators and conditional requests, including `ETag`/`If-Match` semantics used as one optimistic-concurrency control | HTTP validators do not replace domain state/version, preview, authorization, idempotency or audit |
| **W09** | web.dev, [Web Vitals](https://web.dev/articles/vitals) | Living guidance reviewed 1 August 2026 | Current Core Web Vitals and “good” thresholds: LCP ≤2.5 s, INP ≤200 ms, CLS ≤0.1 at p75 | Google guidance and evolving metrics; provisional UX budgets, not UAM business SLOs or accessibility proof |
| **W10** | OWASP, [Application Security Verification Standard](https://owasp.org/www-project-application-security-verification-standard/) | ASVS 5.0.0, released 30 May 2025 | Structured, versioned verification requirements for web application security controls and procurement/test planning | Community standard; must be tailored to UAM threat model and cannot substitute for domain/realm/privacy tests |
| **W11** | OWASP, [Top 10:2025](https://owasp.org/Top10/2025/) | 2025 edition, reviewed 1 August 2026 | Current broad web-application risk categories for threat-review completeness | Awareness taxonomy, not a verification standard or proof of UAM control fitness |
| **W12** | IETF, [RFC 9700 — Best Current Practice for OAuth 2.0 Security](https://www.rfc-editor.org/rfc/rfc9700.html) | BCP 240, January 2025 | Current OAuth 2.0 threat/security advice for any later OIDC/OAuth integration | Does not select UAM identity provider, session architecture, claims, roles, or assurance level |
| **W13** | IETF, [RFC 9111 — HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html) | Internet Standard, June 2022 | Cache-control semantics and the need to design sensitive response caching explicitly | `no-store` and browser headers are only one layer; service workers, browser storage, intermediaries and screenshots remain separate risks |
| **W14** | W3C, [Content Security Policy Level 3](https://www.w3.org/TR/2026/WD-CSP3-20260729/) | Working Draft, 29 July 2026 | Current CSP mechanism and test direction for limiting page resource execution/fetch | Work in progress, not endorsed as a Recommendation; UAM should use stable interoperable directives and test browser behavior |

## 15.3 Open-source review register

| Ref | Repository/release link | Review date/version | Claim supported | Limitation |
|---|---|---|---|---|
| **O01** | [PatternFly React v6.6.0](https://github.com/patternfly/patternfly-react/releases/tag/v6.6.0) | 28 July 2026; commit `6f2385b` | Enterprise component and accessibility-oriented reference; active release | Upstream components are not UAM workflow proof; dependency not selected |
| **O02** | [Fluent UI release list/package tag](https://github.com/microsoft/fluentui/releases/tag/%40fluentui%2Freact-tree_v9.16.1) | 26 May 2026 package cluster; revision `9317e51` | ARIA/focus/component package reference and candidate | Fragmented package closure; separate font/icon terms; exact dependency set open |
| **O03** | [Carbon v11.113.0](https://github.com/carbon-design-system/carbon/releases/tag/v11.113.0) | 30 July 2026; commit `a57cf8a89` | Enterprise component/reference candidate and feature-flag caution | Not UAM authority/accessibility proof; package surface remains unadmitted |
| **O04** | [Fleet fleet-v4.89.2](https://github.com/fleetdm/fleet/releases/tag/fleet-v4.89.2) | 24 July 2026; commit `89b1cb5` | Fleet-health/status/reference and false-success negative evidence | Mixed licensing; much broader device/query/management threat model |
| **O05** | [Argo CD v3.4.6](https://github.com/argoproj/argo-cd/releases/tag/v3.4.6) | 31 July 2026; commit `e1becb7` | Diff/health/rollout/provenance UI reference | Kubernetes/GitOps authority and credential model differs materially |
| **O06** | [Backstage v1.53.1](https://github.com/backstage/backstage/releases/tag/v1.53.1) | 29 July 2026; commit `eb8e4c0` | Navigation/catalogue/plugin-governance reference and schema-warning caution | Very broad plug-in/runtime surface; not proposed as portal platform |
| **O07** | [Grafana v13.1.1](https://github.com/grafana/grafana/releases/tag/v13.1.1) | 21 July 2026; commit `a9cee6e` | Dashboard/stale-state/accessibility test reference | AGPL-3.0; broad query/plugin surface; dependency blocked pending Legal/ADR |
| **O08** | [Keycloak 26.7.0](https://github.com/keycloak/keycloak/releases/tag/26.7.0) | 9 July 2026; commit `6c73e30` | Realm/admin/authorization/session reference | IAM authority and user/credential surface are out of UAM portal scope |

## 15.4 Source-quality conclusion

The supplied predecessor reviews are the strongest project authority for accepted architecture and invariants. W3C, IETF, ETSI, and OWASP sources support standards capabilities and test direction; they do not prove UAM fitness. Open-source repositories supply reusable interaction/testing ideas and negative evidence; none authorizes dependency use or architecture copying. Every time-sensitive version, release, package, standard status, browser/AT combination, and dependency advisory must be rechecked at execution.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| A same-origin BFF should mediate all portal reads and commands | **High** | It preserves accepted authenticated-context, realm, modular-monolith, contract and audit boundaries while keeping browser secrets/authority small | A falsifying prototype showing the same guarantees are simpler and stronger with another topology, including session, CSRF, realm and audit proof |
| The browser must not be an authorization or realm authority | **High** | Client state is attacker-controlled; accepted predecessors require server-derived realm and one realm cannot act as another | No expected ordinary change; any alternative requires a baseline change proposal and formal security proof |
| Normal administration must use explicit commands, not generic row/table mutation | **High** | Closed commands make purpose, state, preview, risk, reason, auth and audit testable; generic mutation defeats those controls | A bounded generic mechanism that proves equivalent closed authority for every field/state and reduces total risk—not merely developer convenience |
| Privileged business transition and audit must commit atomically | **High** | Accepted invariant requires no privileged mutation without durable audit; separate transactions permit orphan mutations/evidence | A different atomic durability substrate proving the same failure behavior and restore semantics |
| Aggregate-first, least-detail read models are the safest default | **High** | Accepted privacy ceiling, minimization, fallible evidence and human-open detail decision all favor the smallest operational view | Human approval of a defined detail purpose/field/access model plus comparative task evidence showing aggregate-only is insufficient |
| No person/activity detail route should exist until explicitly approved | **High for the conservative default** | The prompt forbids research from deciding detail need; absence is safer and easier to change than accidental collection/access | Human decision, legal/privacy/access review, exact schema, representative-user need, and misuse/authorization tests |
| The proposed task-oriented navigation is a sound prototype IA | **Medium** | It maps accepted domain states and prompt-required workflows without exposing storage tables | Representative user-group and priority-workflow research showing different task groupings, terminology or frequency |
| One shared safe-command pattern should serve policy, registry, rollout, export, deletion, integration and support | **High** | Preview/version/idempotency/reason/audit/jobs are cross-domain invariants; reuse prevents bypasses | A domain proof that a different pattern is necessary and no invariant is weakened |
| Approval duties and separation cannot be encoded until humans assign them | **High** | Prompt explicitly reserves approval/notification responsibility; inventing roles would exceed evidence | Approved role/capability/separation matrix and accountable owners |
| Revision rollback must be a higher authorized revision, never sequence decrement | **High** | Accepted predecessor anti-rollback semantics apply to policy, rules, release and signed controls | A baseline change with equivalent freeze/rollback/security and migration proof |
| Feature flags and kill switches must only narrow, pause or disable | **High** | A parallel broadening plane would defeat the product privacy ceiling, authorization, tombstones and release authority | No ordinary change; a broadening flag requires formal policy/release authority and baseline change |
| Long-running actions require durable jobs and recoverable UI state | **High** | Browser/network restarts and ambiguous outcomes are normal; in-memory progress creates false completion and duplicate actions | A strictly synchronous bounded action proving completion and audit before response under all named failures |
| Export, deletion and integration UIs must state external limitations truthfully | **High** | Batch 04 explicitly rejects inferred external deletion/completion and uncontrolled recipient claims | A destination-specific contract and independently verified terminal evidence that removes a named limitation |
| Closed privacy-safe diagnostics/support must remain separate from raw activity | **High** | Batch 03 accepted the closed diagnostics boundary; raw support channels undermine endpoint minimization | A separately approved purpose/privacy boundary and proof that no safer signal can diagnose a critical supported failure |
| WCAG 2.2 AA is the correct engineering target for complete workflows | **High** | It is the current stable W3C Recommendation and includes relevant focus, error prevention, authentication and status criteria | Human accessibility policy requiring a stronger/different target, or a later stable standard mapped and accepted |
| EN 301 549 V3.2.1 is the current published European reference while V4.1.0 is pending | **High as of 1 August 2026** | Direct ETSI publication and status pages support the distinction | Final publication, harmonisation or legal/procurement policy after the research date |
| Automated accessibility tests are necessary but insufficient | **High** | WCAG conformance and widget behavior require human/AT evaluation; scanners miss task/focus/meaning defects | No expected change; tools may improve coverage but cannot prove complete interaction quality alone |
| The provisional browser/AT matrix is sufficient for an initial prototype gate | **Medium** | It covers Windows built-in and common independent AT/browser combinations plus keyboard/visual modes | Human accessibility policy, actual workforce technology, platform support scope, or defects requiring a wider matrix |
| A design-system dependency should be selected only by the same UAM bake-off | **High** | Candidate popularity and upstream claims do not establish integrated accessibility, bundle, licensing, security or removal cost | One candidate passes E20-10 decisively with accepted license/support ownership, or all fail and local components win |
| PatternFly, Fluent UI and Carbon are plausible component candidates | **Medium** | Current releases, enterprise component surfaces and accessibility-oriented packages/examples make them credible | Exact package/advisory/license/AT/bundle results, maintenance decline, or a better candidate at execution time |
| Fleet, Argo CD, Backstage, Grafana and Keycloak are reference-only | **High for this slice** | Their authority, data, plugin, licensing or runtime scopes materially exceed UAM needs | A later measured requirement and ADR showing a bounded component/service is safer and cheaper than local implementation |
| Core Web Vitals are useful provisional UX budgets, not UAM SLOs | **High** | They are current user-centric web thresholds but do not encode UAM workload, accessibility or business objectives | Product/SRE-approved measured budgets for named devices, network and workflows |
| The proposed 6,000-row/173-application UI fixture is a valid test shape | **High as a synthetic test shape** | It carries accepted minimum fleet and safe catalogue counts without production values | Approved larger distributions, page/query measurements, or a new capacity scope; never raw activity |
| The portal can meet the primary normal-administration gate | **Medium** | The architecture removes known bypasses and defines falsifying tests, but no prototype evidence exists yet | E20-00–18 execution, especially authorization, audit failpoints, critical task success, accessibility and recovery |
| Any production portal workflow is currently approved | **Low / not established** | User groups, roles, detail, purpose, approval, notification, IAM, retention, support, SLO, technology and production gates remain open | Accepted Batch 05 review, named human decisions, exact evidence, pilot/risk approval and production authorization |

---

# Residual risk and next stop/go gate

## What remains unsafe, uncertain, costly, or human-dependent

- **HUMAN DECISION.** Actual user groups, priority workflows, terminology, accessibility policy, approval separation, notification/escalation duties, whether detail exists, purpose, prohibited use, access, retention, staffing, budget, support and production authority remain unset. The prototype cannot turn fictional personas into production roles.
- **UNKNOWN.** The exact identity provider, session lifetime, claims mapping, break-glass design, browser/AT support set, portal framework, component system, audit archival technology, notification channels and production hosting topology are not selected.
- **CLI EXPERIMENT.** No code has yet proved zero direct-table mutation, zero hidden production action, zero cross-realm success, atomic audit under failure, safe bulk preview, durable recovery, complete keyboard/AT operation, bounded client performance, or task success.
- **Residual security risk.** A correctly authorized person can still misuse legitimate access or approve harmful semantics. Separation, preview and audit reduce risk but cannot make human judgment correct. A compromised browser, IdP, BFF, signing authority, privileged operator or supply chain can still cause high-impact failure.
- **Residual privacy risk.** Aggregates, small populations, rare error categories, export manifests and audit metadata can still support inference or singling out. Suppression thresholds, access, retention and interpretation are human-owned and need measured tests.
- **Residual accessibility risk.** WCAG conformance does not cover every user need. Assistive-technology/browser updates can change behavior, and a design-system upgrade can regress focus, names, status announcements, forced colors, reflow or keyboard operation.
- **Operational cost.** Exact realm/capability matrices, accessibility regression lanes, design-system updates, critical-workflow research, incident exercises, support ownership and evidence expiry require recurring staff and lab capacity. Fail-closed behavior can produce administrative outage and backlog.
- **External-control limit.** UAM cannot technically recall a human-downloaded export or prove deletion by an unsupported recipient. The interface can only state the limitation and preserve evidence.
- **Research limit.** This report proves design coherence against the allowlisted evidence and current primary sources. It does not prove runtime correctness, user comprehension, legal sufficiency, organizational readiness or production safety.

## Explicit next stop/go gate

**GO** for the Phase 0–2 T1 work only: contract and route catalogues, fictional 6,000-endpoint/173-application fixtures, same-origin BFF/session/realm skeleton, read-only aggregate screens, standard page states, architecture tests, accessibility scaffolding and the three-candidate design-system bake-off.

**STOP** before production role mapping, live data/detail, a high-risk mutation, release/policy/rule publication, connector activation, export, deletion, diagnostic permit, support bundle, rollout, production authentication exposure, pilot or deployment until all of the following are true:

1. E20-18 reports `PASS` over current immutable E20-00–17 evidence with zero hard invariant, accessibility, privacy-canary, cross-realm, hidden-action, unaudited-mutation or cleanup failure;
2. the required human decisions and owner functions for the intended scope are recorded, with unapproved capabilities structurally disabled;
3. the Batch 05 reviewer accepts this result and reconciles Prompts 19–21 without weakening predecessor invariants; and
4. any later pilot or production authority separately accepts the exact release, realm, roles, workflows, accessibility matrix, residual risk and runbooks.

**Primary gate restated:** normal administration must be demonstrably possible without direct database access, generic row mutation, inaccessible controls, hidden production actions, or an unaudited high-risk action. Passing that gate authorizes only the named T1 implementation scope; it is not production approval.
