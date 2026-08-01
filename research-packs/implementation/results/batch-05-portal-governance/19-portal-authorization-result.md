# Prompt 19 — Portal capability model, RBAC/ABAC, JIT access, approvals, and break-glass

**Result path:** `results/batch-05-portal-governance/19-portal-authorization-result.md`  
**Research date:** 1 August 2026  
**Decision status:** **RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS; IMPLEMENTATION PROTOTYPES MAY PROCEED; THE PORTAL-AUTHORIZATION GATE REMAINS OPEN**  
**Authority boundary:** portal and control-API authorization, browser session security, capability modelling, limited attribute conditions, delegated administration, temporary privilege, approvals, break-glass recovery, service identities, authorization decision evidence, and route-level verification; **not** legal purpose, permitted detail/export use, retention, organizational role assignment, approver identity, break-glass authority, staffing, budget, SLO/RPO/RTO, production access, pilot, or production deployment approval  
**Predecessors:** accepted Batch 01, Batch 02, Batch 03, and Batch 04 review results  
**Primary gate:** **Every API action is denied unless one current explicit capability, authenticated realm, approved purpose, exact target scope, and all release-owned conditions permit it. Cross-realm authorization and data-return tests have zero tolerance.**

---

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement or an accountable decision.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, browser automation, fault injection, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements form the proposed implementation baseline. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

---

## Evidence boundary and reviewed project inputs

**FACT.** All seven allowlisted Project files were present and hash-verified. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | Allowlisted logical file | Reviewed local file | SHA-256 | Role and limitation |
|---|---|---|---|---|
| P01 | `00-accepted-baseline-attachment.md` | same | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted system, privacy, realm, audit, release, durability, and restore invariants; not production authority |
| P02 | `05-decisions-contradictions-and-gates.md` | same | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted proof order and stop rule; no portal technology or role assignment decision |
| P03 | `06-research-evidence-rules.md` | same | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source quality, human-authority boundary, and conflict discipline |
| P04 | `batch-01-review-result.md` | `batch-01-review-result(3).md` | `10d5e1e73fa7e63156d29b7cff238ea7d4e128587b47f4c75b` | strict contracts, UUIDv7 identity, product privacy ceiling, tenant narrowing, registry model, repository boundaries, and role/access decisions left human-owned |
| P05 | `batch-02-review-result.md` | same | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | source/session/realm isolation, endpoint minimization, interpretation separation, and no person/role inference from activity |
| P06 | `batch-03-review-result.md` | same | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | installation identity, signed-control patterns, diagnostics permits, privacy-safe support, release/compatibility controls, and role/approval decisions left human-owned |
| P07 | `batch-04-review-result.md` | `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | server/BFF boundary, durable privileged audit, realm-first keys, deletion barriers, restore read blocking, integrations, exports, and lifecycle authority |

**FACT.** The prompt attachment itself was reviewed separately as the task instruction; SHA-256 `cf729d2551bdfc191974de2f0eac291b4eb0d1515591a925ca050bc1f5e64c5a`.

No accepted-baseline change proposal is raised. This design narrows and implements the accepted invariants rather than changing them.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** Build the first portal authorization system as a **small, explicit authorization kernel inside the accepted modular monolith**, enforced at every control-API/BFF route and again at every privileged transaction boundary.

The design has five simple rules:

1. **Login is not permission.** OpenID Connect authenticates the human or service. UAM decides what that identity may do.
2. **Roles are bundles, not authority by themselves.** A role revision expands to exact release-owned capabilities. There is no `admin` wildcard and no tenant-authored policy language.
3. **Realm, purpose, target, time, and conditions are mandatory inputs.** A capability without the exact authenticated realm and target scope does not authorize an action.
4. **Sensitive access is temporary and approved.** Detail, diagnostics escalation, export, destructive lifecycle work, high-risk release work, and authorization administration use JIT grants or a human-approved exception profile rather than permanent broad access.
5. **Every privileged mutation has durable evidence in the same transaction.** Operational logs, identity-provider group claims, UI button hiding, and database row-level security do not substitute for the UAM authorization decision or audit record.

**RECOMMENDATION.** Use capability RBAC plus a small closed set of ABAC-style conditions. Do not adopt a general policy engine, graph authorization database, or authorization microservice for the first slice. The first implementation must remain easy to audit, fuzz, model, and restore. Open-source engines remain reference material or later bake-off candidates.

## 1.2 Primary technical decision

The authorization predicate is:

```text
ALLOW only when all are true:

  authenticated_actor_is_current
  AND route_descriptor_exists
  AND capability_definition_is_release_owned_and_active
  AND an_active_grant_matches_actor_and_capability
  AND authenticated_realm == target_realm
  AND target_is_within_explicit_scope
  AND approved_purpose_is_present_and_allowed
  AND ticket_or_case_reference_is_present_when_required
  AND required_authentication_strength_and_freshness_hold
  AND required_approval_profile_is_satisfied
  AND grant_and_approval_have_not_expired_or_been_revoked
  AND resource_state_and_version_conditions_hold
  AND product_ceiling, tenant narrowing, emergency controls,
      compatibility, restore state, and local safety permit the action
  AND no separation-of-duty conflict or explicit deny applies
  AND the response-field profile permits the requested output
  AND the durable-audit obligation can be satisfied for a mutation

Otherwise: DENY.
```

Missing, unknown, stale, conflicting, malformed, cross-realm, or multiply resolved authority inputs are denial conditions. The evaluator does not choose a “closest” role, realm, purpose, target, or policy.

## 1.3 Why this fits the accepted project

**FACT.** The accepted baseline requires realm isolation, endpoint-side minimization, a control API/BFF, durable privileged audit, tenant policy that only narrows, and restore behavior that blocks reads until deletion and acknowledged-data state are safe [P01, P04, P07].

**INFERENCE.** Therefore portal authorization cannot be a collection of UI roles or identity-provider groups. It must be a server-side decision system that:

- derives realm authority from the authenticated UAM session or service context;
- understands UAM resources and lifecycle states;
- constrains detail, exports, diagnostics, release, deletion, and integrations by purpose;
- can revoke temporary authority quickly;
- survives restore without reviving stale grants;
- records privileged decisions without copying sensitive payloads.

## 1.4 Gate status

| Gate | Status at research close | Required closure evidence | Non-waivable stop condition |
|---|---|---|---|
| **P19-MODEL — capability model and route completeness** | **OPEN — CLI EXPERIMENT** | immutable capability catalogue; every route and background command mapped to one descriptor; negative test generated for every action | one executable route/job lacks a descriptor, uses wildcard authority, or trusts UI/IdP role alone |
| **P19-REALM — isolation and confused deputy** | **OPEN — CLI EXPERIMENT** | synthetic multi-realm/persona suite across API, BFF, jobs, caches, exports, deletion, audit, and service identities | one cross-realm authorization, row, object, cache hit, job execution, export, or error disclosure |
| **P19-JIT — expiry, revocation, approval, and cache** | **OPEN — CLI EXPERIMENT** | fake-clock and database-time campaigns, approval content binding, self-approval negatives, revocation/epoch invalidation, long-job reauthorization | expired/revoked grant remains effective; stale cache permits; modified request keeps approval; requester self-approves where prohibited |
| **P19-BFF — OIDC/session/token/CSRF boundary** | **OPEN — CLI EXPERIMENT** | confidential-client code flow, PKCE, server-side token/session storage, cookie and CSRF tests, logout/revocation, XSS/token-extraction negatives | access/refresh token reaches browser storage; unsafe cross-site request succeeds; session fixation/mix-up; logout/revocation leaves privileged session active |
| **P19-AUDIT — decision and mutation evidence** | **OPEN — CLI EXPERIMENT** | failpoints around mutation/audit commit; privacy schema/canary tests; exact decision linkage | privileged mutation commits without durable audit; audit contains forbidden payload; decision and mutation disagree silently |
| **P19-RECOVERY — break-glass and lockout** | **OPEN — CLI EXPERIMENT + HUMAN DECISION** | disabled-by-default emergency profile, fixed recovery operations, independent authorization, expiry/revocation, alert/post-review, offline recovery drill | blanket bypass, self-activation, detail/export authority by default, no expiry, no durable alert/evidence, or recovery cannot be revoked |
| **P19-OWNERS — human governance** | **OPEN — HUMAN DECISION** | capability owners, role mapping, approvers, SoD, break-glass authority, purposes, support, and incident owners assigned | any production capability/approval/emergency profile lacks accountable authority |
| **P19-AGG — portal authorization gate** | **OPEN** | all required technical gates pass for one exact portal release/topology; ADRs accepted; evidence current; cleanup complete | any hard failure, missing/expired evidence, unresolved conflict, or blocking owner gap |

## 1.5 Immediate permission and prohibition

**GO now** for:

- pure capability, role-template, grant, JIT, approval, break-glass, service-identity, decision, route-descriptor, and audit models;
- strict schemas and fictional realm/persona/resource fixtures;
- a small in-process reference evaluator in C#/.NET;
- OpenAPI/endpoint metadata inventory and route-completeness tests;
- BFF/OIDC prototypes against a synthetic identity provider;
- synthetic multi-realm negative tests, fake-clock expiry/revocation, cache invalidation, and transaction failpoints;
- a mapping workshop using task descriptions and fictional personas only;
- open-source reference comparison and isolated test spikes after dependency admission.

**STOP** before:

- assigning real people or organization roles to capabilities;
- enabling production detail, export, diagnostic escalation, deletion, release, authorization administration, or break-glass access;
- trusting an IdP group, directory role, job title, department, IP address, VPN state, host name, or tenant-supplied expression as direct UAM authority;
- storing access or refresh tokens in browser-accessible storage;
- deploying an external general policy engine, relationship graph, or commercial PIM dependency without a later measured ADR;
- treating hidden UI controls, OAuth scopes, database RLS, or application logs as the sole enforcement or audit boundary;
- pilot or production deployment.

## 1.6 Confidence and residual risk

| Major conclusion | Confidence | Basis | What could change it |
|---|---|---|---|
| Server-side deny-by-default authorization is required | **High** | directly composes accepted realm, audit, privacy, and lifecycle invariants with current OAuth/OIDC security practice | a stronger, simpler mechanism passing identical route, realm, audit, restore, and operations gates |
| Capability RBAC plus closed conditions is the right first model | **High** | UAM resources/actions are finite; tenant policy may only narrow; general policy languages add unnecessary authority | a bounded prototype showing a different model is materially simpler and equally analyzable without broadening tenant authority |
| BFF with server-side tokens is the right browser boundary | **High** | current IETF browser-app draft and Microsoft .NET guidance support confidential-client/BFF patterns; reduces token extraction surface | a chosen UI architecture that does not need browser API tokens or a safer equivalent supported by the exact IdP/runtime |
| JIT is required for high-risk capability classes | **Medium-High** | narrows standing privilege and matches detail/export/diagnostic/lifecycle risk | human risk decision allowing a narrower standing grant with equivalent audit and operational containment |
| Break-glass can be made safe enough for production | **Medium-Low** | patterns exist, but authority, key custody, monitoring, staffing, and recovery environment are unknown | passed independent recovery drills and accountable human decisions |
| An external policy engine is unnecessary initially | **High** | first slice has finite resources, conditions, and one modular monolith; no measured scale/fan-out need | route/capability growth or independent-service need that makes the internal kernel less correct or more costly |
| Revocation latency and authorization availability are acceptable | **Low / not established** | no SLO, cache, topology, IdP, or outage measurements exist | exact cache/outage/load evidence and human objectives |

**Residual risk.** A malicious or mistaken approver can still authorize harmful work; colluding administrators can defeat separation assumptions; identity-provider compromise can authenticate an attacker; a privileged database or infrastructure operator can bypass application controls; a policy/compiler defect can deny legitimate work or allow excessive work; and fail-closed behavior can cause operational outage. Research and testing can reduce these risks but cannot approve purposes, people, legal authority, staffing, or risk acceptance.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result defines:

- resource, action, scope, realm, purpose, and condition semantics for the portal/control plane;
- capability RBAC, closed-condition ABAC, explicit denies, tenant narrowing, and realm isolation;
- provisional role/persona bundles without organizational assignment;
- standing, delegated, temporary, approval-gated, and emergency grants;
- OIDC/BFF browser sessions, service identities, CSRF, token, and logout boundaries;
- authorization decision caching, invalidation, outage behavior, and lockout recovery;
- durable authorization decision and privileged audit evidence without sensitive payloads;
- route, mutation, background-job, property, realm, and confused-deputy test requirements;
- feature flags, kill switches, error taxonomy, privacy-safe observability, accessibility, support, and incident operations for this topic;
- architecture fitness functions, CLI experiments, ADRs, and backlog.

## 2.2 Non-goals

This result does not:

- decide who receives any capability;
- invent organization roles, departments, owners, reporting lines, or approvers;
- decide legal purpose, lawful basis, permitted detail/export uses, employee consultation, retention, or rights outcomes;
- select the production identity provider, MFA method, portal UI framework, database engine, audit storage technology, KMS/HSM, SIEM, or PIM product;
- redesign endpoint collection, ingestion, facts, deletion, restore, releases, or integrations;
- authorize arbitrary scripts, SQL, regexes, paths, plugins, workflow definitions, or tenant-authored policy programs;
- make UAM evidence sole forensic proof or an employee-productivity score;
- claim production SLOs, revocation time, session duration, JIT duration, cache TTL, capacity, cost, or staffing.

## 2.3 Accepted inputs carried forward

The following are **FACT** from the allowlisted predecessors and are treated as constraints:

1. UAM uses a modular monolith with a control API/BFF and governed integrations [P01, P07].
2. One user, session, installation, or realm cannot view, mutate, export, delete, submit, or act as another [P01].
3. Realm authority is derived from authenticated context rather than payload claims [P04–P07].
4. Tenant policy may only narrow a release-authorized product ceiling [P01, P04, P06].
5. A privileged mutation cannot succeed without durable audit evidence [P01, P04, P07].
6. Operational logs and diagnostics do not substitute for privileged audit [P06, P07].
7. Restore blocks ordinary reads and egress until tombstone, acknowledged-data, derived-store, audit, and readiness checks pass [P07].
8. Detail, diagnostics, exports, lifecycle, release, integration, and authorization roles/purposes remain human decisions [P04, P06, P07].
9. Application names and catalogue external references do not establish identity, role, entitlement, owner, purpose, or authorization [P04].
10. Exact point versions and fast-moving dependencies are execution-time evidence, not timeless architecture [P01–P07].

## 2.4 Assumptions

| ID | Assumption | Consequence if false | Resolution |
|---|---|---|---|
| A19-01 | The first portal is served through the accepted control API/BFF rather than a browser holding direct API bearer tokens. | session/token boundary and CSRF design must change | architecture ADR before UI implementation |
| A19-02 | Human identities are authenticated by one or more OIDC-capable enterprise identity providers. | another federation/authentication profile is needed | IdP capability inventory and interoperability prototype |
| A19-03 | Authorization state can be stored transactionally with or adjacent to the modular-monolith control database. | audit atomicity and cache invalidation may need a different mechanism | database/transaction spike; no distributed authorization service by assumption |
| A19-04 | The first resource/action set is finite and release-owned. | a more expressive policy representation may be required | route/capability inventory and growth evidence |
| A19-05 | Realms are meaningful governance/data isolation boundaries already assigned by the server identity and tenant-control plane. | all scope and delegation semantics become ambiguous | human realm-definition decision from predecessor work |
| A19-06 | UAM can maintain an approved purpose registry using opaque IDs and descriptions outside ordinary authorization logs. | purpose-bound access cannot be implemented safely | human purpose workshop; conservative deny |
| A19-07 | Administrative tasks can be decomposed into author, submitter, approver, executor, and reviewer capabilities. | separation-of-duty profiles may be impossible for some tasks | workflow-specific mapping workshop and explicit exception review |

## 2.5 Unknowns

**UNKNOWN.** The following materially affect production design:

- identity provider, tenant/federation topology, supported logout, PAR, PKCE, step-up, token, session, and group-overage behavior;
- authentication assurance and freshness requirements for each capability;
- real realms, delegated administration boundaries, and whether product-global administration is needed;
- real purposes, prohibited uses, ticket systems, case systems, approvers, quorum, and separation-of-duty rules;
- role assignments, support model, JIT duration, break-glass authority, emergency monitoring, and recovery key custody;
- portal topology, scale-out/session-store design, cache, database, audit store, SIEM, and notification integrations;
- revocation, availability, session, audit, and incident objectives;
- exact detail/export fields, response profiles, download controls, watermarking, recipient duties, and retention;
- whether a commercial PIM or external policy engine provides a justified operational benefit;
- cost, licensing, skills, on-call, accessibility testing capacity, and production ownership.

The conservative state for every unresolved high-risk item is disabled or denied.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Design principles

1. **Authentication and authorization are separate.** OIDC proves a current authenticated subject and context. UAM capabilities authorize actions.
2. **Every authority is explicit.** No implicit admin, wildcard resource, wildcard action, inherited tenant superuser, or default allow.
3. **Realm is an input to every decision and every key.** A product-global capability is a different explicitly defined capability, not a missing realm.
4. **Purpose is not prose.** Purpose is an approved identifier, required for sensitive capability classes, bound to grants, requests, decisions, and audit.
5. **Conditions are closed and release-owned.** Tenants assign values within a safe schema; they do not author code or expressions.
6. **Deny and narrowing win.** Product emergency, tenant emergency, restore block, legal hold, compatibility hold, expired grant, stale authentication, or local safety can stop work but cannot create authority.
7. **Decision and data shape are coupled.** Authorization obligations select a response-field profile, export profile, masking/coarsening rule, and audit class; a broad object is not fetched then “redacted later.”
8. **Mutation and audit are atomic.** The same transaction checks final authority, writes the business mutation, and writes the privileged audit event.
9. **Long operations reauthorize.** A submitted job does not carry permanent authority merely because creation was authorized.
10. **Restore cannot revive permission.** Restored authorization state is read-blocked until epochs, grants, revocations, audit continuity, and current control artifacts reconcile.

## 3.2 Component and authority baseline

| Component | Normative responsibility | Explicit prohibitions | Engineering owner function |
|---|---|---|---|
| Identity Provider adapter | perform OIDC discovery/metadata validation; initiate code flow; validate issuer, audience, nonce, state, code exchange, token signatures, time, and logout; map a minimal external identity reference | no direct UAM capability from IdP group/role claim; no tenant/realm authority from unverified claim; no browser token exposure | Identity/Federation Engineering |
| BFF session manager | hold access/refresh tokens server-side; issue opaque host-only session cookie; bind session, actor, active realm, authn class, grant generation, and expiry; revoke/logout | no token in local/session storage; no broad claims in browser; no session reuse after realm switch or privilege elevation | Portal Platform/IAM |
| CSRF and request-integrity middleware | enforce same-origin unsafe methods, antiforgery token, origin/fetch metadata checks, method semantics, body limits, and request correlation | no state-changing GET/HEAD/OPTIONS; no CSRF bypass for cookie-authenticated JSON endpoints | Portal Security |
| Authenticated actor resolver | map current human/service authentication to immutable UAM principal context and status | no lookup by display name; no body/route override; no stale/disabled principal soft allow | IAM/Control Plane |
| Realm context resolver | bind one active realm for normal sessions; derive target realm from trusted resource lookup; compare them before data access | no realm from request body as authority; no “default tenant”; no closest match; no cache without realm key | Realm Security |
| Route authorization descriptor registry | enumerate every API route, handler, command, job, and response profile with resource/action/purpose/authn/audit rules | no unclassified endpoint; no dynamic fallback; no controller-name inference at runtime | API Architecture |
| Capability catalogue | hold immutable release-owned resource/action definitions, allowed scope kinds, risk class, purpose/approval/authn/audit requirements, and response profiles | no tenant-defined capability/action; no `*`; no executable expression; no silent semantic edit | Authorization Architecture |
| Role-template registry | hold immutable revisions that bundle exact capability IDs and constraints | no role by name alone; no direct UI role authority; no mutable active revision | IAM Governance Engineering |
| Assignment and grant service | create/revoke standing, delegated, JIT, service, and break-glass grants under approved workflows | no self-grant; no grant beyond delegator envelope; no missing expiry where required | IAM Governance Engineering |
| Approval service | bind decisions to the exact immutable request digest, approver eligibility, quorum, SoD, time, and reason code | no approval reuse after request change; no approval by requester where forbidden; no free-form command authority | Workflow/IAM |
| Authorization kernel | evaluate actor, route, capability, grant, realm, target, purpose, ticket, authn, approval, resource state, control artifacts, deny sets, and response obligations | no external network call in the final transaction; no generic script/policy evaluation; no unknown-as-allow | Authorization Architecture |
| Authorization cache | cache immutable definitions and resolved grants by realm/principal/session/grant generation/authorization epoch; subscribe to invalidation | no realm-less key; no indefinite TTL; no cache-only high-risk mutation decision | Platform/SRE |
| Mutation transaction guard | re-evaluate high-risk authority under database lock/current epoch and atomically write mutation plus audit | no stale precheck as final authority; no mutation if audit insert fails | Domain Module Owner + Data Reliability |
| Decision evidence writer | write finite, privacy-safe decision records for required classes and link privileged audit to exact decision | no payload, URL, host, person name, query text, token, claim dump, or arbitrary exception | Security Audit Engineering |
| Background-job authorization guard | carry a grant lease/decision envelope; reauthorize at claim and phase boundaries; pause/revoke future effects | no permanent delegation through queue message; no cross-realm worker cache; no bypass after grant expiry | Job/Workflow Owner |
| Service-identity registry | bind non-human principal, credential, permitted realms, exact capabilities, audiences, endpoints, owner, expiry/rotation, and status | no user impersonation by default; no approval authority; no browser session; no shared fleet credential | Service IAM |
| Emergency recovery controller | expose fixed recovery operations under independent authority, threshold/quorum where selected, expiry, alert, and post-review | no general data read/export; no arbitrary capability grant; no normal-portal dependency as sole recovery | Security Incident/Identity Recovery |
| UI capability adapter | fetch current menu/action model and explain denials/accessibility status without becoming authority | no button visibility as enforcement; no hidden route; no inference from role label | Portal UI/Accessibility |
| Audit reviewer interface | query minimal decision/audit evidence under its own purpose and capability | no raw payload or unrestricted cross-realm search; no audit-store admin through reviewer role | Security Governance |

## 3.3 Trust-boundary flow

```text
Browser
  -> same-origin HTTPS BFF
  -> OIDC confidential-client authorization code flow (+ PKCE; PAR when supported)
  -> server-side session and tokens
  -> CSRF/request-integrity checks
  -> immutable AuthenticatedActorContext
  -> exactly one ActiveRealmContext for ordinary portal use
  -> release-owned RouteAuthorizationDescriptor
  -> trusted target resolver (realm and resource version)
  -> authorization kernel
       capability catalogue
       role/grant expansion
       purpose/ticket
       JIT/approval/break-glass state
       authn class/freshness
       product ceiling + tenant narrowing + kill/restore state
       response field profile
  -> DENY with finite safe reason
     OR ALLOW with obligations and short decision validity
  -> domain repository scoped by realm and target
  -> for mutation: final reauthorization + business write + audit in one transaction
  -> response projection limited to authorized field profile
```

Service flow:

```text
service credential (mTLS or private_key_jwt candidate)
  -> server identity boundary
  -> immutable ServiceActorContext
  -> exact audience + endpoint + realm + capability grant
  -> same route descriptor and authorization kernel
  -> no browser session, no user impersonation, no human approval action
```

## 3.4 Capability/resource/action schema — mandatory artifact

### 3.4.1 Capability identity

A capability is an immutable release-owned tuple:

```text
capability_id = stable UUIDv7
capability_key = resource_type + ":" + action
capability_revision = monotonically increasing immutable revision
```

The key is descriptive; the UUID is authoritative. A semantic change creates a new revision and compatibility review. A deleted capability is retired, never silently repurposed.

### 3.4.2 Normative capability definition

```json
{
  "contract": "uam.authz.capability-definition",
  "version": "1.0.0",
  "capabilityId": "019d0000-0000-7000-8000-000000001901",
  "revision": 1,
  "resourceType": "ACTIVITY_DETAIL",
  "action": "READ_DETAIL",
  "allowedScopeKinds": ["REALM", "RESOURCE_SET", "CASE"],
  "grantModes": ["JIT"],
  "riskClass": "RESTRICTED_DATA",
  "requiresPurpose": true,
  "allowedPurposeClassIds": ["PURPOSE_CLASS_DETAIL_REVIEW"],
  "requiresTicket": true,
  "conditionProfileId": "DETAIL_READ_V1",
  "approvalProfileId": "PROVISIONAL_DETAIL_APPROVAL_V1",
  "authenticationProfileId": "RECENT_STRONG_AUTH_V1",
  "auditClass": "PRIVILEGED_READ",
  "responseFieldProfileId": "DETAIL_MINIMUM_V1",
  "delegable": false,
  "serviceIdentityAllowed": false,
  "breakGlassAllowed": false,
  "productCeilingRevision": 1,
  "status": "CANDIDATE"
}
```

All values are fictional and provisional. Production purpose, approval, authentication, field, and duration choices are **HUMAN DECISION**.

### 3.4.3 Resource and action catalogue

The initial catalogue MUST use exact actions rather than CRUD wildcards.

| Resource type | Representative actions | Mandatory scope/purpose notes |
|---|---|---|
| `FLEET_REALM` | `READ_SUMMARY`, `READ_HEALTH`, `UPDATE_METADATA`, `DISABLE_COLLECTION` | realm required; disable can only narrow; no activity detail |
| `FLEET_INSTALLATION` | `LIST`, `READ_SUMMARY`, `READ_HEALTH`, `REVOKE_IDENTITY`, `DECOMMISSION` | realm + exact installation/resource set; mutation audited |
| `POLICY_PRODUCT_CEILING` | `DRAFT`, `SUBMIT`, `APPROVE`, `PUBLISH`, `FREEZE`, `ROLLBACK` | product-global explicit capability; strong SoD; not tenant-delegable |
| `POLICY_REALM` | `READ`, `DRAFT`, `SUBMIT`, `APPROVE`, `ACTIVATE`, `REVOKE` | realm; tenant can only narrow; author/publisher separation provisional |
| `POLICY_EMERGENCY` | `ACTIVATE_NARROWING`, `REVOKE_NARROWING` | narrowing only; incident reference; short-lived where applicable |
| `APPLICATION` | `LIST`, `READ`, `CREATE_DRAFT`, `UPDATE_DRAFT`, `RETIRE`, `MERGE`, `SPLIT` | realm; names/external refs never authority |
| `APPLICATION_RULE` | `READ`, `DRAFT`, `ANALYZE`, `SUBMIT`, `APPROVE`, `PUBLISH`, `RETIRE` | realm; closed grammar; conflict evidence required |
| `APPLICATION_SNAPSHOT` | `READ`, `PUBLISH`, `ROLLBACK` | realm; higher sequence; release/policy compatibility |
| `ACTIVITY_AGGREGATE` | `READ_SUMMARY`, `QUERY_APPROVED_VIEW` | realm; approved aggregate/output profile; no detail fallback |
| `ACTIVITY_DETAIL` | `READ_DETAIL`, `READ_CASE_SET` | JIT; approved purpose/ticket/target; field profile; no standing default |
| `DIAGNOSTIC_PERMIT` | `REQUEST`, `APPROVE`, `ACTIVATE`, `REVOKE` | realm + target + level + duration; D0/D1/D2 closed profiles only |
| `DIAGNOSTIC_BUNDLE` | `CREATE`, `READ_STATUS`, `DOWNLOAD`, `DELETE` | case/purpose/target; encrypted object; recipient and expiry |
| `EXPORT_DEFINITION` | `DRAFT`, `SUBMIT`, `APPROVE`, `ACTIVATE`, `REVOKE` | purpose/destination/data class; no arbitrary query/path |
| `EXPORT_JOB` | `CREATE`, `CANCEL`, `RETRY`, `READ_STATUS`, `DOWNLOAD` | JIT/approval as chosen; grant lease; object manifest |
| `TASK_DEFINITION` | `READ`, `ENABLE`, `DISABLE` | fixed release-owned task only; no script/command/path |
| `TASK_RUN` | `REQUEST`, `APPROVE`, `EXECUTE`, `CANCEL`, `READ_STATUS` | exact target and task capability; no generic remote command |
| `RELEASE_MANIFEST` | `READ`, `DRAFT`, `SUBMIT`, `APPROVE`, `FREEZE`, `REVOKE` | product-global; release authority separation |
| `RELEASE_RING` | `READ`, `PROMOTE`, `PAUSE`, `ROLLBACK` | exact digest/ring; rollback higher sequence; strong auth/audit |
| `DELETION_CASE` | `CREATE`, `READ_STATUS`, `AUTHORIZE`, `PAUSE_DESTRUCTION`, `RESUME`, `VERIFY`, `CLOSE` | realm + exact case/resolution; barrier cannot be removed after commit |
| `RETENTION_POLICY` | `READ`, `DRAFT`, `SUBMIT`, `APPROVE`, `ACTIVATE`, `RETIRE` | human-owned period/purpose; immutable revisions |
| `LEGAL_HOLD` | `CREATE`, `APPROVE`, `RELEASE`, `READ_STATUS` | realm + exact scope; does not restore ordinary visibility |
| `RESTORE_RUN` | `REQUEST`, `EXECUTE`, `VERIFY_READINESS`, `ENABLE_READS`, `DESTROY` | isolated environment; distinct SoD for readiness and read enable |
| `AUDIT_EVENT` | `QUERY`, `READ`, `VERIFY_CHAIN` | realm/purpose; minimum fields; no arbitrary payload search |
| `AUDIT_EXPORT` | `REQUEST`, `APPROVE`, `DOWNLOAD`, `DELETE` | restricted purpose; JIT; recipient/expiry controls |
| `INTEGRATION_CONNECTOR` | `READ`, `DRAFT`, `APPROVE`, `ACTIVATE`, `PAUSE`, `REVOKE`, `ROTATE_CREDENTIAL` | realm/destination/purpose; no arbitrary URL or secret display |
| `INTEGRATION_DELIVERY` | `READ_STATUS`, `RETRY`, `QUARANTINE`, `CANCEL` | exact destination/message set; no custody/fact rewrite |
| `AUTHZ_CAPABILITY` | `READ`, `PROPOSE_REVISION`, `APPROVE_REVISION`, `ACTIVATE`, `RETIRE` | product-global architecture authority; no runtime ad hoc creation |
| `AUTHZ_ROLE_TEMPLATE` | `READ`, `DRAFT`, `SUBMIT`, `APPROVE`, `ACTIVATE`, `RETIRE` | role is bundle only; immutable revision |
| `AUTHZ_ASSIGNMENT` | `READ`, `REQUEST`, `APPROVE`, `ACTIVATE`, `REVOKE` | exact principal/realm/role; assignment authority cannot self-assign |
| `AUTHZ_JIT_REQUEST` | `CREATE`, `READ_STATUS`, `APPROVE`, `REJECT`, `REVOKE` | exact request digest; requester/approver separation |
| `AUTHZ_BREAK_GLASS` | `REQUEST`, `ACTIVATE`, `REVOKE`, `REVIEW`, `CLOSE` | disabled until human authority; fixed emergency profile only |
| `AUTHZ_SERVICE_IDENTITY` | `REGISTER`, `APPROVE`, `ACTIVATE`, `ROTATE`, `REVOKE` | no human impersonation; owner/expiry/realm/audience exact |

No route may map to an action absent from this or a later approved release-owned catalogue revision.

## 3.5 Scope and realm model

### 3.5.1 Scope kinds

Allowed scope kinds are closed:

```text
GLOBAL_PRODUCT
REALM
RESOURCE_SET
INSTALLATION
APPLICATION
SUBJECT_PROJECTION
CASE
DESTINATION
RELEASE_RING
```

A scope is an explicit immutable selector manifest, not a wildcard string, path prefix, SQL predicate, regex, role name, group name, or directory query.

Examples:

```json
{
  "scopeKind": "RESOURCE_SET",
  "realmId": "019d0000-0000-7000-8000-00000000a001",
  "resourceType": "FLEET_INSTALLATION",
  "resourceIds": [
    "019d0000-0000-7000-8000-00000000b001",
    "019d0000-0000-7000-8000-00000000b002"
  ],
  "manifestDigest": "sha-256:fictional"
}
```

The production representation MAY use a content-addressed set or bounded typed predicate compiled from release-owned options, but the evaluated membership must be reproducible and same-realm.

### 3.5.2 Realm rules

1. A normal human BFF session MUST have exactly one active realm at a time.
2. Realm switching MUST create a new session security context and invalidate realm-scoped decision caches.
3. The target resolver MUST load the target under the authenticated realm key before authorization. A target found only in another realm is reported as the same generic denial/not-found class used for absence.
4. Product-global administration MUST use explicit `GLOBAL_PRODUCT` capabilities and a separate route family. A missing realm is never interpreted as global.
5. Delegated administration MUST remain within the delegator's exact realm, scope, capability set, time, purpose, and delegation-depth envelope.
6. Every database, cache, object, job, search, audit, export, and integration key begins with realm or is protected by a product-global namespace that cannot contain realm data.
7. Database RLS MAY be used as defense in depth but does not replace the application predicate, realm-first key, or negative tests.

## 3.6 Purpose model

**HUMAN DECISION.** The permitted purposes are not selected here.

The technical model requires:

```text
PurposeDefinition {
  purpose_id
  immutable revision
  purpose class
  human-readable approved statement
  permitted resource/action classes
  permitted data/output profiles
  prohibited uses
  ticket/case requirement
  approval profile
  maximum grant mode (standing or JIT only)
  lifecycle/expiry
  accountable owner function
}
```

A request supplies only an approved `purpose_id` and ticket/case reference. Free text may be retained in a separate restricted case system if required, but it is not authorization input and is not copied into ordinary decision logs.

**Conservative temporary default:** the production purpose set for `ACTIVITY_DETAIL`, `EXPORT_*`, `AUDIT_EXPORT`, and enhanced diagnostics is empty. Those actions deny until accountable humans approve exact purpose definitions.

## 3.7 Limited ABAC condition model

The evaluator supports only release-owned condition profiles composed from these primitives:

| Condition primitive | Meaning | Authority source | Unknown behavior |
|---|---|---|---|
| `REALM_MATCH` | actor active realm equals target realm | BFF/server context + target lookup | deny |
| `TARGET_IN_SCOPE` | target appears in immutable scope manifest | grant scope service | deny |
| `RESOURCE_STATE_IN` | resource is in approved state set | locked domain row | deny |
| `RESOURCE_VERSION_EQ` | request/approval bound to current immutable version/digest | domain row | deny |
| `PURPOSE_ALLOWED` | purpose is active and capability-compatible | purpose registry | deny |
| `TICKET_PRESENT_AND_BOUND` | approved ticket/case token binds actor, realm, target, purpose, request | governed integration or typed reference | deny |
| `GRANT_ACTIVE` | not-before, expiry, status, generation, and revoke epoch hold | authorization store/database time | deny |
| `APPROVAL_SATISFIED` | exact request digest has current eligible decisions and quorum | approval store | deny |
| `AUTHN_PROFILE_SATISFIED` | authentication method/class/freshness meets capability profile | validated session context | deny/step-up required |
| `OUTPUT_PROFILE_ALLOWED` | requested response/export fields are subset of capability obligation | route + capability catalogue | deny |
| `DESTINATION_APPROVED` | export/integration destination revision is active and purpose-compatible | connector/export registry | deny |
| `PRODUCT_AND_TENANT_POLICY_ALLOW` | product ceiling and tenant narrowing allow capability | signed/control artefact state | deny |
| `RESTORE_AND_VISIBILITY_READY` | target realm/environment is read-enabled and current tombstones are honored | lifecycle/restore state | deny |
| `COMPATIBILITY_AND_RELEASE_ALLOW` | exact release/control versions are active | release/compatibility state | deny |
| `NO_SOD_CONFLICT` | actor/request/approver/executor combination does not violate profile | assignment/approval graph | deny |
| `RATE_AND_BUDGET_AVAILABLE` | release-owned bounded operation budget remains | transactionally maintained finite counters | deny or safe retry |

Tenant configuration may select allowed values, narrower sets, shorter times, and stricter approval profiles. It cannot introduce a new condition type, expression, external data fetch, executable policy, IP/network rule, SQL, script, regex, path, destination, or transform.

**RECOMMENDATION.** Do not use department, manager, job title, office, IP address, VPN, device posture, or HR attributes in the first authorization model. They are volatile, privacy-sensitive, and lack an accepted authoritative contract. A later ADR may add one bounded attribute only after source authority, correction, outage, privacy, and negative tests are defined.

## 3.8 Authorization policy model and decision flow — mandatory artifact

### 3.8.1 Decision inputs

```text
ActorContext
  principal_id, principal_type
  authentication_session_id
  issuer and subject binding
  active_realm_id or GLOBAL_PRODUCT context
  authentication profile and authenticated_at
  session generation and revocation epoch
  service credential generation where applicable

ActionDescriptor
  route/command ID
  resource_type and action
  required purpose mode
  allowed actor type
  required authentication profile
  audit class
  response/output profile

TargetContext
  target realm
  exact resource ID/type
  resource state/version/digest
  parent scope identifiers
  lifecycle/restore visibility state

RequestContext
  purpose_id
  ticket/case token
  requested output profile
  idempotency key and request digest for mutations
  current database time
```

### 3.8.2 Evaluation order

The evaluator MUST execute a stable order so denial reasons, timing, and tests are predictable:

1. Validate route descriptor and actor type.
2. Validate current session/service credential status and authentication profile.
3. Resolve target under authenticated realm without revealing cross-realm existence.
4. Load capability definition and active release/control revision.
5. Apply product, tenant, emergency, restore, compatibility, and kill-state denies.
6. Expand active role/assignment/JIT/break-glass/service grants to exact capabilities.
7. Match realm and target scope.
8. Validate purpose, ticket/case, output profile, and resource state/version.
9. Validate grant time/generation/revocation and approval/SoD.
10. Calculate obligations and `valid_until` as the earliest relevant expiry.
11. Return `ALLOW` or finite `DENY`; persist decision evidence where required.
12. For mutations and high-risk job phases, repeat steps 2–10 under final transaction state.

The first externally visible denial is deliberately generic. Detailed finite reason codes are available only to separately authorized audit/support paths.

### 3.8.3 Deny precedence

```text
SECURITY_HOLD / WRONG_REALM / INVALID_ROUTE
  > PRODUCT_EMERGENCY_DISABLE
  > RESTORE_OR_VISIBILITY_BLOCK
  > TENANT_EMERGENCY_NARROWING
  > CAPABILITY_RETIRED / RELEASE_INCOMPATIBLE
  > PRINCIPAL_OR_CREDENTIAL_DISABLED
  > GRANT_REVOKED / EXPIRED / NOT_YET_VALID
  > APPROVAL_OR_SOD_FAILURE
  > PURPOSE / TICKET / TARGET / OUTPUT FAILURE
  > NO_MATCHING_GRANT
  > ALLOW
```

An explicit deny or safety hold cannot be overridden by another role, broader grant, service identity, break-glass token, feature flag, or cached allow.

## 3.9 Role/persona proposal — clearly provisional mandatory artifact

The following are **RECOMMENDATION — PROVISIONAL PERSONAS FOR WORKSHOP USE ONLY**. They are not organizational roles and MUST NOT be assigned automatically.

| Provisional persona | Candidate capability boundary | Standing/JIT posture | Required separation or prohibition |
|---|---|---|---|
| Fleet Observer | realm fleet/install summary and health | standing candidate | no activity detail, export, policy, identity, release, deletion, or authorization admin |
| Aggregate Analyst | approved aggregate views only | standing or bounded assignment candidate | cannot fall back to detail; output profile fixed |
| Application Curator | draft application metadata/rules and run analysis | standing candidate | cannot publish own rule revision where SoD chosen; no entitlement inference |
| Application Publisher | approve/publish analyzed application/rule snapshots | JIT or narrow standing candidate | not requester/author for same revision under provisional SoD |
| Realm Policy Author | draft tenant-narrowing policy | standing candidate | cannot broaden product ceiling or activate own revision |
| Realm Policy Publisher | approve/activate/revoke realm policy | JIT candidate | separate from author; current strong authentication |
| Detail Investigator | read exact case-bound detail/output profile | JIT only | approved purpose, ticket, target set, expiry; no export by default |
| Diagnostic Support Operator | baseline safe health; request D1/D2 permit | D0/D1 standing candidate; D2 JIT | no raw source, dump, arbitrary file/command; cannot approve own escalation |
| Export Preparer | draft exact export definition/job | JIT or narrow standing | cannot approve or retrieve own high-risk export under provisional SoD |
| Export Approver | approve exact export request/destination | JIT | cannot alter query/target after approval |
| Export Retriever | download approved encrypted export | JIT | distinct recipient binding; expiry and object deletion |
| Release Operator | stage candidate, read evidence, pause ring | narrow standing candidate | cannot approve signing/release authority or promote own unapproved candidate |
| Release Approver/Promoter | approve/promote/rollback exact digest | JIT | strong auth, exact ring, durable audit, higher-sequence rollback |
| Lifecycle Case Operator | create/resolution workflow and inspect status | standing candidate | cannot authorize own destructive case under provisional SoD |
| Lifecycle Authorizer | authorize exact resolution manifest/barrier | JIT | cannot remove suppression after barrier; separate readiness/read-enable roles |
| Restore Operator | execute isolated restore and evidence steps | JIT | no ordinary reads or production routing |
| Restore Readiness Verifier | verify technical readiness | JIT | cannot enable production reads alone under provisional SoD |
| Audit Reviewer | query minimum decision/audit evidence | JIT or narrow standing | no audit administration or raw payload search |
| Integration Administrator | draft/manage connector revision and credentials | JIT | cannot create arbitrary destination; approval/purpose required |
| Authorization Administrator | draft role assignments and JIT policies | JIT | cannot self-assign, approve own assignment, or alter capability catalogue alone |
| Authorization Approver | approve exact assignment/JIT request | JIT | cannot be requester/beneficiary where SoD profile forbids |
| Emergency Recovery Operator | fixed recovery-only operations | disabled until human decision | no ordinary detail/export; no normal self-activation; mandatory alert/post-review |

### 3.9.1 Mapping workshop

The workshop MUST use tasks, data classes, purposes, failure duties, and separation constraints—not existing role names as truth.

Required inputs:

- inventory of portal/API tasks and background operations;
- resource/action catalogue and response data classifications;
- realm/delegation boundaries;
- approved purpose candidates and prohibited uses;
- required author/approver/executor/reviewer separations;
- support and incident responsibilities;
- accessibility and out-of-hours operational requirements;
- expected grant mode: standing, delegated, JIT, break-glass, or service.

Required outputs:

```text
persona/role-template revision
exact capabilities
scope kinds and maximum scope
purpose classes
standing/JIT mode
approval and SoD profile
authentication profile
maximum duration (human-owned)
response-field profile
owner and support function
positive and negative test IDs
revocation and incident runbook
review/expiry trigger
```

**Conservative temporary default:** no production role assignments. In a fictional lab realm, allow only summary/health reads to synthetic personas. Detail, export, diagnostics escalation, release promotion, deletion authorization, restore enablement, integration credentials, authorization administration, and break-glass remain denied unless their exact lab experiment requires a T1-only temporary grant.

## 3.10 Standing grants, delegation, JIT, approvals, and break-glass

### 3.10.1 Standing grants

Standing grants MAY be used only for low- or moderate-risk capability classes after human review. They MUST still bind:

```text
principal
realm/global context
exact role-template revision or capability set
scope manifest
allowed purpose classes where relevant
not-before and review/expiry
assignment generation
delegation envelope
owner and approver references
```

There is no indefinite “administrator” role. A long review period is still an explicit expiry/review decision.

### 3.10.2 Delegated administration

A delegator can issue only a strict subset of its delegable envelope:

```text
Delegated <= Delegator
by capability set, realm, scope, purpose, grant mode,
authn profile, duration, approval requirements, and delegation depth.
```

Non-delegable capabilities include product ceiling, capability catalogue activation, break-glass authority, root release/signing authority, and any capability human governance marks as non-delegable. Delegation never allows the delegator to approve its own benefit through an alternate account or service identity.

### 3.10.3 JIT grants

A JIT request MUST bind:

- requester and intended beneficiary;
- realm and exact target/resource-set manifest;
- exact capability IDs and revisions;
- approved purpose and ticket/case token;
- requested start/end and maximum profile;
- requested response/output profile;
- request digest and current resource/policy versions;
- required authentication profile;
- approval profile and conflict checks;
- explicit cleanup/revocation behavior.

Approval creates no authority by itself. It authorizes activation of the exact request. Activation creates a separately versioned temporary grant. Any content change supersedes approvals.

### 3.10.4 Approvals and separation of duties

The model supports release-owned profiles such as:

```text
NO_APPROVAL
ONE_ELIGIBLE_APPROVER
TWO_DISTINCT_APPROVERS
AUTHOR_AND_PUBLISHER_DISTINCT
REQUESTER_BENEFICIARY_APPROVER_DISTINCT
EXECUTOR_AND_VERIFIER_DISTINCT
RESTORE_OPERATOR_READ_ENABLER_DISTINCT
```

The real profile for each action is **HUMAN DECISION**. The technical system MUST validate distinct principal IDs, actor types, assignment generations, request digests, time, realm, conflict sets, and revoked/expired approver authority.

### 3.10.5 Break-glass

**RECOMMENDATION.** Break-glass is not a universal bypass. It is a fixed emergency capability profile with these mandatory properties:

- disabled until accountable authority, monitoring, and recovery keys are approved;
- separate emergency identity/credential from normal daily account;
- fixed operations such as freeze portal mutations, revoke compromised grants/sessions, activate a previously approved narrowing control, restore a known-good authorization policy revision, or bind a pre-registered recovery principal to a repair-only plane;
- no ordinary activity detail, export, audit export, connector secret display, or arbitrary role assignment by default;
- exact incident reference, realm/global target, reason class, authentication/recovery proof, activation time, hard expiry, and non-renewable default;
- immediate independent alert and durable audit outside the affected ordinary authorization path where feasible;
- no self-approval through the normal portal;
- revocation and kill available from an independent control path;
- mandatory post-use review before closure.

The exact identities, quorum, key custody, duration, monitored recipients, and allowed recovery operations are **HUMAN DECISION**.

## 3.11 OIDC/BFF session and token boundary

### 3.11.1 Browser architecture

**RECOMMENDATION.** Use an OIDC confidential client in the BFF with Authorization Code flow, PKCE, and PAR when the selected provider supports it. Current IETF and Microsoft guidance support this direction [W01–W04].

Normative browser rules:

1. Access, refresh, and ID tokens MUST remain server-side.
2. The browser receives an opaque session cookie only.
3. The cookie SHOULD use the `__Host-` prefix where topology permits, `Secure`, `HttpOnly`, path `/`, no `Domain`, and the strictest compatible `SameSite` mode.
4. Session fixation is prevented by creating a new session identifier after login, step-up, realm switch, and privilege elevation.
5. The BFF validates issuer, client/audience, state, nonce, redirect URI, PKCE verifier, token signature/algorithm, token time, and provider metadata under an exact profile.
6. Redirect URI and post-logout return targets are fixed release configuration, not tenant/user input.
7. Claims identify the authenticated subject and authentication context. IdP groups/roles are mapped only to non-authoritative evidence for a governed assignment workflow; they do not directly grant UAM actions.
8. The browser user endpoint returns a minimal UI model: opaque actor alias, active realm alias, session expiry class, and permitted UI action IDs. It does not return tokens or the full capability/grant graph.
9. Back-channel logout SHOULD be used when the provider and server-side session store support it. RP-initiated logout and local revocation remain required [W05–W06].
10. Exact idle, absolute, refresh, step-up, and offline/session durations are **HUMAN DECISION** and measured inputs.

### 3.11.2 CSRF and method semantics

All cookie-authenticated unsafe methods MUST require an antiforgery token and same-origin validation. Additional checks MAY include trusted `Origin`/`Referer` policy and Fetch Metadata. These are defense in depth, not replacements for the token.

- `GET`, `HEAD`, and `OPTIONS` MUST be side-effect free.
- Login, logout, realm switch, JIT activation, approval, export download initiation, and break-glass actions receive explicit CSRF analysis; logout must not be a state-changing unauthenticated GET.
- CORS is not an authorization mechanism. The first BFF SHOULD be same-origin and avoid broad credentialed CORS.
- Content types and request bodies are strict and bounded.

### 3.11.3 Session state

A server-side session contains only the minimum required:

```text
session_id
principal_id and principal status version
issuer/subject binding digest
active realm or GLOBAL_PRODUCT mode
authentication profile and authenticated_at
granted/consented upstream token references
grant generation and authorization epoch
CSRF secret/reference
created, last-active, absolute expiry
revoked/logout state
```

Tokens are encrypted/protected at rest according to the selected session-store threat model. The session store and key profile are execution-time/human decisions.

## 3.12 Service identities

Service identities use the same capability catalogue but a different principal type and authentication profile.

Normative rules:

- mTLS or `private_key_jwt` are first candidates; shared API keys are prohibited for privileged integration.
- each identity binds one owner, service purpose, exact audience, allowed endpoints, realm/global scope, capabilities, source workload/release identity where available, validity, credential generation, and rotation/revocation state;
- service identities cannot create or approve human JIT grants, activate break-glass, download human-facing exports, or impersonate a human unless a future explicit delegation contract is approved;
- a background worker receives a narrow service capability and a job authorization envelope; it does not inherit the submitting user's complete session;
- credential rotation has bounded overlap, exact generation checks, and no silent fallback;
- service identity status is checked at request/stream start and at high-risk job phase boundaries.

## 3.13 Caching, invalidation, and outage behavior

### 3.13.1 Cache keys

Authorization caches MUST include:

```text
principal_id
principal type
active realm/global mode
session or credential generation
authorization epoch
grant generation
capability catalogue revision
route descriptor revision
product ceiling and tenant policy revisions
purpose registry revision
resource type/action
scope/target digest
```

A cache entry returns obligations and the earliest `valid_until`; it never extends authority beyond the shortest expiry among its inputs.

### 3.13.2 Invalidation

Revoking a grant, disabling a principal, changing a role assignment, activating a narrowing policy, changing a capability revision, ending a JIT grant, revoking break-glass, or changing restore/read state MUST advance an authorization epoch and publish an invalidation event through the accepted governed server mechanisms. High-risk mutations recheck the current database epoch regardless of cache.

### 3.13.3 Outage behavior

- **Authorization store unavailable:** deny protected actions. Liveness, static login shell, and generic outage status may remain available without realm data.
- **Identity provider unavailable:** existing local sessions MAY continue only within their already approved absolute/authentication freshness limits. No new login, step-up, JIT activation, approval, break-glass activation, or privileged mutation requiring fresh authentication.
- **Invalidation channel unavailable:** high-risk actions query the authoritative store; low-risk cached reads obey the earliest safe expiry and an approved stale policy. Unknown means deny.
- **Audit store/transaction unavailable:** privileged mutation denies. Required privileged reads deny if their decision evidence cannot be written under the approved audit class.
- **Clock uncertain:** expiration-sensitive JIT, approval, break-glass, service rotation, and strong-auth actions deny. Database time is authoritative for transactional state where available.

## 3.14 Emergency lockout recovery

The recovery design has two layers:

1. **Primary emergency access:** pre-provisioned emergency identity at the selected IdP, independently monitored and excluded from ordinary daily use, with only the fixed UAM recovery role after UAM-side activation.
2. **Offline authorization recovery:** a separately protected threshold/quorum-signed recovery envelope consumed by a minimal CLI/control path to perform only fixed operations: freeze portal mutations, revoke sessions/grants, activate known-good authorization catalogue/role revisions, disable a compromised IdP binding, or bind a pre-registered emergency principal to the repair plane for a hard-bounded period.

The offline path MUST NOT query or export activity detail, create arbitrary capabilities, edit resources, accept scripts/SQL, or bypass realm isolation. Its exact cryptographic profile, quorum, custodians, storage, ceremony, and use threshold are **HUMAN DECISION** and must align with the predecessor signed-control architecture.

## 3.15 Authorization decision logging and durable audit

### 3.15.1 Decision record

The minimum privacy-safe decision record is:

```text
decision_id
request/operation token
actor principal ID or case-scoped opaque alias
actor type
session/credential generation
authentication profile class
realm ID or GLOBAL_PRODUCT marker
resource type and opaque target ID/token
action
purpose ID and ticket token digest where required
capability and grant IDs/revisions
approval request/decision digests where applicable
policy, catalogue, route, and authorization-epoch revisions
result = ALLOW | DENY
finite reason code
obligation profile IDs
break-glass flag/case ID if applicable
evaluated_at_database_time
valid_until
audit class
```

It MUST NOT contain request/response payload, URL, host, query, search string, person name, catalogue name, raw subject selector, browser/source value, credential, token, group list, arbitrary claim, exception stack, SQL, or free-form ticket text.

### 3.15.2 Logging classes

- Every privileged mutation: full durable authorization decision linkage plus privileged audit in the mutation transaction.
- Detail, export, audit query/export, diagnostic escalation/download, break-glass, release promotion, deletion authorization, restore readiness/read-enable, connector credential work, authorization administration: durable decision record for allow and selected deny events.
- High-volume summary/aggregate reads: exact durable/logging policy is a **HUMAN DECISION** based on purpose, privacy, cost, and incident needs; finite counters may supplement sampled or case-bound records but cannot replace privileged evidence.
- Public/anonymous and malformed requests: bounded security telemetry only, with no identity enumeration or payload echo.

### 3.15.3 Atomic mutation boundary

```text
BEGIN;
  load current actor/principal/grant/authz epoch;
  load target by authenticated realm and lock expected version;
  evaluate final authorization against database time;
  apply business mutation;
  insert authorization_decision;
  insert privileged_audit_event referencing decision and mutation digest;
COMMIT;
```

Any failed predicate, zero-row version check, audit insert failure, or commit ambiguity yields no successful response. Retry uses the same idempotency key and reconciles the committed decision/mutation.

## 3.16 Privacy-safe observability and cardinality

Metrics use finite dimensions only:

```text
component
decision_result
reason_family
resource_type
action_class
actor_type
grant_mode
risk_class
authentication_profile_class
cache_outcome
outage_mode
build_ring
```

Forbidden labels include realm, principal, session, grant, target, application, subject, ticket, case, destination, role name, purpose ID, URL, host, query, exact exception, and arbitrary IdP claim. Per-realm operational views, if approved, use access-controlled records rather than global metric labels.

**RECOMMENDATION.** The authorization catalogue tool computes the theoretical series bound before release. Unknown dynamic labels fail CI. Exact cardinality budget is **HUMAN DECISION/ESTIMATE**.

## 3.17 Feature flags and kill switches

Feature flags may:

- hide or disable a candidate UI/workflow;
- disable a capability or actor type;
- force JIT instead of standing access;
- require a stricter authentication/approval profile;
- pause exports, detail reads, diagnostic escalation, release promotion, deletion execution, integration delivery, or break-glass;
- restrict supported realms/rings in a staged rollout.

They MUST NOT bypass authenticated realm, capability, purpose, approval, SoD, audit, tombstone/restore readiness, product ceiling, or response-field controls. Tenant flags only narrow. A kill switch cannot silently re-enable itself.

## 3.18 Accessibility and data quality

- Permission, expiry, approval, denial, and emergency status MUST be programmatically exposed and keyboard-operable, not conveyed by color alone [W20–W21].
- Time-limited JIT sessions SHOULD provide accessible advance warning without extending the grant; the user may save non-sensitive draft state but must reauthorize before a protected action.
- Denial messages to ordinary users are plain and actionable without revealing target existence or hidden policy. Authorized reviewers can access the finite detailed reason.
- Role/capability search uses approved display metadata only; display names never become IDs or authority.
- The UI displays the active realm prominently and requires an explicit realm switch; destructive dialogs repeat a safe realm alias and target class.
- Approval screens show an immutable request summary and digest/version, not mutable underlying form data.
- Locale/time-zone presentation never changes UTC/database-time authorization semantics.

## 3.19 Secure coding and review requirements

- The authorization kernel is a small pure library with no HTTP, ORM, directory, network, script, reflection-discovered policy, or UI dependencies.
- Route descriptors are generated/validated at build and startup; missing or duplicate descriptors fail.
- Domain repositories require an explicit `RealmContext` and typed target key; realm-less overloads are prohibited by architecture tests.
- String-based permission checks and controller-name/action-name inference are prohibited.
- Comparisons use immutable IDs/enums, not localized display text.
- The final mutation evaluator accepts locked typed facts, not arbitrary dictionaries.
- Code review requires an authorization threat-model checklist for every new route, resource, action, output field, background phase, and cache.
- Security-sensitive code has two reviewers from independently accountable engineering functions where staffing permits; the exact human review policy is **HUMAN DECISION**.

---
# 4. Alternatives, rejection reasons, and conditions that would change the choice

## 4.1 Alternative assessment

| Alternative | Decision now | Rejection or deferral reason | Condition that could change the decision |
|---|---|---|---|
| Identity-provider groups/roles are the authorization system | **REJECTED** | authentication claims do not understand UAM realm, target, purpose, output profile, lifecycle state, approval, or durable audit; group drift and naming become hidden authority | IdP remains identity/assignment evidence only; no expected change to UAM final authorization |
| OAuth scopes alone | **REJECTED** | scopes generally describe client/API authority, not exact resource, realm, temporary human grant, purpose, SoD, or response field obligations | may remain one coarse upstream audience/scope control, never sole UAM decision |
| UI-only role checks and hidden buttons | **REJECTED** | direct API/background invocation bypasses UI; cannot protect data returns or transactions | no expected change |
| Database RLS alone | **REJECTED** | does not model purpose, approval, JIT, response profiles, background jobs, break-glass, or durable decision evidence; privileged roles can bypass | retain as defense in depth after application tests |
| Per-user ACL rows on every resource | **REJECTED AS DEFAULT** | high administration and review cost, easy stale grants, poor purpose/SoD model, role explosion | may be represented as an explicit small `RESOURCE_SET` grant for exceptional cases, with expiry and owner |
| Broad ABAC/XACML-style expression language | **REJECTED** | tenant-authored attributes/expressions make monotonic narrowing, testing, data provenance, outage handling, and review substantially harder | a bounded attribute need that cannot be represented by a closed condition primitive and passes a new ADR |
| General OPA/Rego sidecar or service | **DEFERRED / REFERENCE ONLY** | powerful general language, external-data and translation surfaces, additional availability/cache/policy-distribution failure domains; OPA's current release fixed a Compile API SQL-injection vector, illustrating integration risk [W23] | measured policy-growth or service-separation need; exact pinned dependency, subset grammar, fail-closed cache, conformance and fault bake-off beats in-process kernel |
| Cedar as the production evaluator | **DEFERRED / REFERENCE AND TEST CANDIDATE** | strong schema/formal tooling ideas, but Rust/runtime/interoperability surface and principal-action-resource model do not directly encode UAM workflow/audit/lifecycle obligations; no .NET production fit evidence | isolated executable model comparator or dependency bake-off with exact source/binary/license/operations evidence |
| OpenFGA or SpiceDB relationship graph | **DEFERRED / REFERENCE ONLY** | useful for large relationship graphs, but first slice has explicit realm/resource scopes; adds datastore, consistency token, tuple lifecycle, restore, and operations complexity | measured relationship/fan-out/authorization sharing need that cannot be safely represented by bounded manifests |
| Cerbos external PDP | **DEFERRED / REFERENCE ONLY** | broad YAML/CEL policy, separate service/bundle/audit/operations path, and potential overlap with UAM control artifacts; first scope does not need it | later bake-off after policy volume/independent deployment evidence |
| Authorization microservice from day one | **REJECTED INITIALLY** | creates a synchronous distributed dependency and two-phase mutation/audit problem inside an accepted modular monolith | multiple independently deployed control APIs, clear failure-domain benefit, and a proof of atomic decision/mutation/audit semantics |
| Commercial PIM as the core UAM authorization source | **DEFERRED** | PIM may manage eligible assignments and approvals but does not replace exact UAM realm/target/purpose/output/lifecycle evaluation; product/licensing/topology unknown | selected enterprise IAM product provides authoritative workflow integration through a narrow contract and passes outage/revocation/realm tests |
| Microsoft Entra PIM as direct route authority | **REJECTED AS DIRECT AUTHORITY; REFERENCE/INTEGRATION CANDIDATE** | documented JIT/approval/activation patterns are relevant, but Entra role activation cannot independently prove UAM target and data semantics [W18–W19] | use as an upstream approval/eligibility signal only after exact integration contract and fallback behavior |
| Teleport for portal JIT | **REJECTED AS DEPENDENCY / REFERENCE ONLY** | built for infrastructure access proxies and short-lived credentials; large distributed system, different resources/threat model, mixed AGPL/Apache licensing surface | no expected first-slice fit; reuse design/testing lessons only |
| oauth2-proxy as the BFF | **REJECTED FOR CORE BFF** | authentication reverse proxy can forward claims/headers but does not implement UAM server-side session, route authorization, mutation audit, or realm semantics; recent security fixes show session/header risks [W30] | may front a non-sensitive auxiliary UI only after exact threat review; not control API authority |
| Duende BFF as automatic dependency | **DEFERRED / COMMERCIAL CANDIDATE** | good BFF patterns and tests, but production licensing, framework behavior, session storage, and exact UAM fit require procurement/security comparison [W31–W34] | exact version, license, source/package mapping, security test, operational comparison beats built-in ASP.NET Core implementation |
| Browser SPA stores tokens and calls APIs directly | **REJECTED FOR CONTROL PLANE** | exposes bearer/refresh tokens to browser script and complicates CSRF/session revocation and realm switch; inconsistent with chosen BFF boundary | only a separate low-risk public client with no privileged UAM capability, accepted by ADR |
| General remote command/task channel | **REJECTED** | conflicts with fixed release-owned Task/diagnostic/release capabilities and creates arbitrary execution authority | no general channel; each future fixed operation requires a capability and proof gate |
| A single permanent `SuperAdmin` | **REJECTED** | bypasses least privilege, purpose, realm, JIT, SoD, review, and incident containment | fixed recovery operations remain separate break-glass profile; no ordinary superuser |
| Network/IP/VPN-based authorization | **REJECTED** | location is mutable, spoofable through topology, and not identity, purpose, or realm authority | may be risk telemetry or additional deny signal only after exact contract |

## 4.2 Choice-change triggers

An authorization architecture ADR must be reopened when any of these occurs:

- the capability catalogue or route inventory cannot be reviewed or tested within the modular-monolith release process;
- more than one independently deployed product requires the same authorization decisions and local replication creates inconsistent behavior;
- relationship depth/fan-out or per-object ACL volume makes immutable scope manifests operationally unsafe;
- measured decision latency, cache invalidation, or database contention misses approved objectives after simpler optimization;
- a required condition cannot be represented without unsafe duplication and has an authoritative, privacy-approved data source;
- a selected commercial/OSS engine passes an identical semantic, realm, JIT, audit, outage, restore, supply-chain, licensing, and TCO bake-off with materially lower total risk;
- an authorization incident shows a structural weakness in the accepted model.

Any change proposal must preserve the primary zero-tolerance gate and explain migration of active grants, approvals, epochs, audits, background jobs, and restored state.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Common contract rules

Every authorization, approval, session, service-identity, decision, audit, and recovery contract MUST follow the accepted strict contract profile [P04]:

- exact immutable contract version;
- UTF-8 strict JSON where JSON is used;
- closed objects and enums; no duplicate members, wrong case, implicit defaults, remote references, or generic extension bags;
- canonical lower-case UUIDv7 UAM identifiers;
- explicit UTC instants and separately defined precision;
- hard item/string/depth/byte/time/allocation bounds;
- no payload-derived realm authority;
- stable idempotency identity for mutations;
- finite privacy-safe errors;
- consumer-first rollout and executable old/new compatibility tests;
- owner, support function, audit class, runbook, valid/invalid vectors, and cleanup behavior.

## 5.2 Route authorization descriptor

Every executable API route, BFF endpoint, command handler, message/job handler, scheduled operation, and privileged repository method MUST have one compiled descriptor:

```json
{
  "contract": "uam.authz.route-descriptor",
  "version": "1.0.0",
  "routeId": "portal.activity-detail.read.v1",
  "http": {
    "method": "POST",
    "pathTemplateId": "activity-detail-query-v1"
  },
  "resourceType": "ACTIVITY_DETAIL",
  "action": "READ_CASE_SET",
  "actorTypes": ["HUMAN"],
  "realmMode": "ACTIVE_SESSION_REALM",
  "targetResolverId": "CASE_TARGET_SET_V1",
  "purposeMode": "REQUIRED",
  "ticketMode": "REQUIRED",
  "authenticationProfileId": "RECENT_STRONG_AUTH_V1",
  "responseFieldProfileId": "DETAIL_MINIMUM_V1",
  "auditClass": "PRIVILEGED_READ",
  "csrfRequired": true,
  "idempotencyRequired": false,
  "finalTransactionRecheck": false,
  "serviceIdentityAllowed": false,
  "status": "CANDIDATE"
}
```

Build/startup validation MUST fail when:

- an executable route/handler has no descriptor;
- two descriptors claim the same route/handler incompatibly;
- a capability/action is unknown or retired;
- the target resolver can return multiple realms or an unbounded target;
- an unsafe cookie-authenticated method omits CSRF;
- a privileged mutation omits final transaction recheck or audit;
- a response profile is absent;
- a service identity is accepted on a human-only route or vice versa.

## 5.3 Capability definition contract

```text
CapabilityDefinition {
  capability_id: UUIDv7
  revision: positive integer
  resource_type: closed enum
  action: closed enum scoped to resource type
  allowed_scope_kinds: nonempty closed set
  grant_modes: subset of STANDING | DELEGATED | JIT | BREAK_GLASS | SERVICE
  risk_class: PUBLIC_METADATA | OPERATIONAL | GOVERNANCE | RESTRICTED_DATA | DESTRUCTIVE | ROOT_AUTHORITY
  requires_purpose: boolean
  allowed_purpose_class_ids: bounded set
  requires_ticket: boolean
  condition_profile_id
  approval_profile_id? 
  authentication_profile_id
  audit_class
  response_field_profile_id
  delegable: boolean
  service_identity_allowed: boolean
  break_glass_allowed: boolean
  product_ceiling_revision
  not_before / not_after?
  status: DRAFT | CANDIDATE | ACTIVE | DEPRECATED | RETIRED | FROZEN
  content_digest
}
```

An active definition is immutable. Rollback republishes prior semantics at a higher catalogue revision.

## 5.4 Role-template contract

```json
{
  "contract": "uam.authz.role-template-revision",
  "version": "1.0.0",
  "roleTemplateId": "019d0000-0000-7000-8000-000000001910",
  "revision": 3,
  "displayKey": "PROVISIONAL_FLEET_OBSERVER",
  "capabilities": [
    {
      "capabilityId": "019d0000-0000-7000-8000-000000001911",
      "capabilityRevision": 1,
      "constraintProfileId": "REALM_SUMMARY_ONLY_V1"
    }
  ],
  "allowedGrantModes": ["STANDING", "JIT"],
  "maximumScopeKinds": ["REALM", "RESOURCE_SET"],
  "delegable": false,
  "status": "CANDIDATE",
  "contentDigest": "sha-256:fictional"
}
```

`displayKey` is not authority. A grant binds the UUID and revision.

## 5.5 Principal and authenticated context contracts

### 5.5.1 Human actor context

```text
HumanActorContext {
  principal_id
  principal_status_version
  principal_status = ACTIVE
  issuer_id
  external_subject_binding_digest
  authentication_session_id
  session_generation
  authentication_profile_class
  authenticated_at
  active_realm_id or GLOBAL_PRODUCT mode
  authorization_epoch_observed
}
```

### 5.5.2 Service actor context

```text
ServiceActorContext {
  service_principal_id
  owner_function_id
  credential_id and generation
  authentication_method = MTLS | PRIVATE_KEY_JWT
  audience
  authenticated_at
  allowed realm/global context
  authorization_epoch_observed
  workload/release binding digest? 
}
```

These contexts are server-created. Client payload fields cannot override them.

## 5.6 Assignment and grant contracts

### 5.6.1 Assignment request

```json
{
  "contract": "uam.authz.assignment-request",
  "version": "1.0.0",
  "requestId": "019d0000-0000-7000-8000-000000001920",
  "beneficiaryPrincipalId": "019d0000-0000-7000-8000-000000001921",
  "roleTemplateId": "019d0000-0000-7000-8000-000000001910",
  "roleTemplateRevision": 3,
  "realmId": "019d0000-0000-7000-8000-00000000a001",
  "scopeManifestId": "019d0000-0000-7000-8000-000000001922",
  "grantMode": "STANDING",
  "requestedNotBeforeUtc": "2026-08-01T12:00:00Z",
  "requestedNotAfterUtc": "2026-09-01T12:00:00Z",
  "purposeClassIds": [],
  "approvalProfileId": "PROVISIONAL_ASSIGNMENT_APPROVAL_V1",
  "requestDigest": "sha-256:fictional"
}
```

Exact dates are fictional and not recommended production durations.

### 5.6.2 Active grant

```text
Grant {
  grant_id
  principal_id and type
  capability_id/revision or role_template_id/revision
  realm_id or explicit GLOBAL_PRODUCT
  scope_manifest_id/digest
  allowed purpose IDs/classes
  condition_profile_id
  grant_mode and source request/assignment/break-glass/service ID
  not_before / not_after
  generation
  authorization_epoch_at_activation
  delegation_parent_id? and remaining depth
  status = ACTIVE | REVOKED | EXPIRED | SAFETY_HOLD
  activated_by and approval digest
  content_digest
}
```

A grant is immutable except for monotonic state transitions and separately appended revocation evidence.

## 5.7 JIT request and activation contracts

```json
{
  "contract": "uam.authz.jit-request",
  "version": "1.0.0",
  "jitRequestId": "019d0000-0000-7000-8000-000000001930",
  "requesterPrincipalId": "019d0000-0000-7000-8000-000000001931",
  "beneficiaryPrincipalId": "019d0000-0000-7000-8000-000000001931",
  "realmId": "019d0000-0000-7000-8000-00000000a001",
  "capabilityIds": ["019d0000-0000-7000-8000-000000001901"],
  "scopeManifestId": "019d0000-0000-7000-8000-000000001932",
  "purposeId": "PURPOSE_FICTIONAL_CASE_REVIEW",
  "ticketTokenDigest": "sha-256:fictional-ticket-token",
  "requestedStartUtc": "2026-08-01T13:00:00Z",
  "requestedEndUtc": "2026-08-01T14:00:00Z",
  "authenticationProfileId": "RECENT_STRONG_AUTH_V1",
  "responseFieldProfileId": "DETAIL_MINIMUM_V1",
  "resourceVersionDigest": "sha-256:fictional-resource-set",
  "requestDigest": "sha-256:fictional-request"
}
```

Activation command:

```text
ActivateJitGrant {
  jit_request_id
  expected_request_digest
  expected_approval_set_digest
  expected_state_version
  current authentication session and profile
  activation idempotency key
}
```

The activation transaction rechecks all conditions and mints one grant with `valid_until` no later than the approved request end or any shorter policy/authentication boundary.

## 5.8 Approval contract

```json
{
  "contract": "uam.authz.approval-decision",
  "version": "1.0.0",
  "approvalDecisionId": "019d0000-0000-7000-8000-000000001940",
  "requestType": "JIT_ACCESS",
  "requestId": "019d0000-0000-7000-8000-000000001930",
  "requestDigest": "sha-256:fictional-request",
  "approverPrincipalId": "019d0000-0000-7000-8000-000000001941",
  "approverAssignmentGeneration": 7,
  "decision": "APPROVE",
  "reasonCode": "PURPOSE_AND_SCOPE_CONFIRMED",
  "decidedAtUtc": "2026-08-01T12:55:00Z",
  "validUntilUtc": "2026-08-01T13:30:00Z",
  "decisionDigest": "sha-256:fictional-approval"
}
```

No free-form approval text is required in the authorization store. Any case notes remain in a separately governed system and are referenced by a token.

## 5.9 Break-glass contracts

### 5.9.1 Request

```text
BreakGlassRequest {
  case_id
  requester emergency principal
  recovery profile ID
  realm/global target
  incident reference token
  reason class
  requested fixed operation IDs
  requested start/end
  current recovery proof profile
  request digest
}
```

### 5.9.2 Activation result

```text
BreakGlassGrant {
  grant_id
  case_id
  emergency principal
  exact fixed operation capabilities
  realm/global target
  not_before / hard not_after
  non_renewable = true by default
  recovery authority/approval set digest
  alert evidence digest
  generation
  status
}
```

A request cannot express arbitrary capability IDs unless they are members of the selected release-owned emergency profile.

## 5.10 Authorization decision request and result

### 5.10.1 Internal request

```json
{
  "contract": "uam.authz.decision-request",
  "version": "1.0.0",
  "routeId": "portal.activity-detail.read.v1",
  "actorContextRef": "server-created-context",
  "target": {
    "resourceType": "ACTIVITY_DETAIL",
    "resourceId": "019d0000-0000-7000-8000-000000001950",
    "realmId": "019d0000-0000-7000-8000-00000000a001",
    "resourceVersion": 4,
    "resourceDigest": "sha-256:fictional"
  },
  "purposeId": "PURPOSE_FICTIONAL_CASE_REVIEW",
  "ticketTokenDigest": "sha-256:fictional-ticket-token",
  "requestedResponseProfileId": "DETAIL_MINIMUM_V1",
  "operationId": "019d0000-0000-7000-8000-000000001951"
}
```

`actorContextRef` is conceptual and never accepted from the client.

### 5.10.2 Result

```json
{
  "contract": "uam.authz.decision-result",
  "version": "1.0.0",
  "decisionId": "019d0000-0000-7000-8000-000000001952",
  "result": "ALLOW",
  "reasonCode": "EXPLICIT_GRANT_AND_CONDITIONS_SATISFIED",
  "matchedGrantIds": ["019d0000-0000-7000-8000-000000001953"],
  "obligations": {
    "responseFieldProfileId": "DETAIL_MINIMUM_V1",
    "auditClass": "PRIVILEGED_READ",
    "maximumRowsClass": "BOUNDED_CASE_SET",
    "watermarkProfileId": null
  },
  "authorizationEpoch": 42,
  "policyDigest": "sha-256:fictional-policy",
  "evaluatedAtUtc": "2026-08-01T13:05:00Z",
  "validUntilUtc": "2026-08-01T13:06:00Z"
}
```

The duration is fictional. The evaluator computes validity; callers cannot request a longer result.

## 5.11 Background job authorization envelope

```text
JobAuthorizationEnvelope {
  job_id and immutable job request digest
  submitting principal ID and session/grant generation
  realm
  capability/action
  target/scope manifest digest
  purpose/ticket token
  response/destination profile
  source decision ID
  grant lease ID
  not_after
  required reauthorization checkpoints
  authorization epoch at submission
}
```

Workers use their service identity plus this envelope. Neither alone is sufficient. At claim and each listed phase, the worker resolves current state and receives a new phase decision. Payload does not contain a bearer token or the human's complete grants.

## 5.12 Error taxonomy

External HTTP/API problem responses use a small non-enumerating taxonomy:

| External code | Meaning | Typical HTTP class | Retry |
|---|---|---|---|
| `AUTHENTICATION_REQUIRED` | no current authenticated session/credential | 401 | after authentication |
| `REAUTHENTICATION_REQUIRED` | stronger/fresher authentication needed | 401/403 according to profile | after step-up |
| `ACCESS_NOT_PERMITTED` | no matching authorization or target unavailable | 403 or policy-chosen 404 | no until authority changes |
| `REQUEST_NOT_VALID` | strict schema/contract error | 400 | corrected request only |
| `REQUEST_CONFLICT` | stale version/idempotency/content mismatch | 409 | reconcile/correct |
| `AUTHORIZATION_TEMPORARILY_UNAVAILABLE` | authoritative state unavailable; fail closed | 503 | bounded retry |
| `SAFETY_HOLD` | integrity, realm, policy, audit, or emergency hold | 423/503 by route profile | owner recovery only |
| `RATE_OR_BUDGET_LIMIT` | operation budget unavailable | 429/503 | after safe retry time |

Internal finite reasons include `WRONG_REALM`, `NO_ROUTE_DESCRIPTOR`, `NO_ACTIVE_GRANT`, `GRANT_EXPIRED`, `GRANT_REVOKED`, `PURPOSE_REQUIRED`, `PURPOSE_NOT_ALLOWED`, `TICKET_REQUIRED`, `TARGET_OUT_OF_SCOPE`, `APPROVAL_MISSING`, `SELF_APPROVAL_FORBIDDEN`, `APPROVAL_SUPERSEDED`, `SOD_CONFLICT`, `AUTHN_TOO_OLD`, `RESTORE_READ_BLOCKED`, `RESPONSE_PROFILE_TOO_BROAD`, `AUDIT_UNAVAILABLE`, and `CACHE_EPOCH_STALE`. These internal reasons are not automatically exposed to ordinary callers.

## 5.13 Normative logical relational schema

Physical types, indexes, partitioning, RLS, and database engine remain implementation/measurement choices. Keys, constraints, state meaning, and transaction boundaries are normative.

```sql
CREATE TABLE authz_capability_definition (
    capability_id              UUID          NOT NULL,
    revision                   BIGINT        NOT NULL,
    resource_type              VARCHAR(64)   NOT NULL,
    action_code                VARCHAR(64)   NOT NULL,
    risk_class                 VARCHAR(40)   NOT NULL,
    condition_profile_id       VARCHAR(96)   NOT NULL,
    approval_profile_id        VARCHAR(96)   NULL,
    authentication_profile_id  VARCHAR(96)   NOT NULL,
    response_field_profile_id  VARCHAR(96)   NOT NULL,
    audit_class                VARCHAR(48)   NOT NULL,
    delegable                  BOOLEAN       NOT NULL,
    service_identity_allowed   BOOLEAN       NOT NULL,
    break_glass_allowed        BOOLEAN       NOT NULL,
    product_ceiling_revision   BIGINT        NOT NULL,
    status                     VARCHAR(24)   NOT NULL,
    content_digest             BINARY_32     NOT NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (capability_id, revision),
    UNIQUE (resource_type, action_code, revision)
);

CREATE TABLE authz_role_template_revision (
    role_template_id           UUID          NOT NULL,
    revision                   BIGINT        NOT NULL,
    display_key                VARCHAR(96)   NOT NULL,
    status                     VARCHAR(24)   NOT NULL,
    delegable                  BOOLEAN       NOT NULL,
    content_digest             BINARY_32     NOT NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (role_template_id, revision)
);

CREATE TABLE authz_role_capability (
    role_template_id           UUID          NOT NULL,
    role_revision              BIGINT        NOT NULL,
    capability_id              UUID          NOT NULL,
    capability_revision        BIGINT        NOT NULL,
    constraint_profile_id      VARCHAR(96)   NOT NULL,
    PRIMARY KEY (role_template_id, role_revision, capability_id, capability_revision)
);

CREATE TABLE authz_principal (
    principal_id               UUID          NOT NULL PRIMARY KEY,
    principal_type             VARCHAR(24)   NOT NULL,
    status                     VARCHAR(24)   NOT NULL,
    status_version             BIGINT        NOT NULL,
    external_binding_digest    BINARY_32     NULL,
    owner_function_id          VARCHAR(96)   NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    disabled_at_utc            TIMESTAMP_UTC NULL,
    CHECK (principal_type IN ('HUMAN','SERVICE','EMERGENCY'))
);

CREATE TABLE authz_scope_manifest (
    realm_id                   UUID          NULL,
    scope_manifest_id          UUID          NOT NULL,
    scope_kind                 VARCHAR(40)   NOT NULL,
    resource_type              VARCHAR(64)   NOT NULL,
    item_count                 BIGINT        NOT NULL,
    content_digest             BINARY_32     NOT NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    expires_at_utc             TIMESTAMP_UTC NULL,
    PRIMARY KEY (realm_id, scope_manifest_id)
);

CREATE TABLE authz_assignment_request (
    realm_id                   UUID          NULL,
    request_id                 UUID          NOT NULL,
    requester_principal_id     UUID          NOT NULL,
    beneficiary_principal_id   UUID          NOT NULL,
    role_template_id           UUID          NULL,
    role_revision              BIGINT        NULL,
    direct_capability_set_id   UUID          NULL,
    scope_manifest_id          UUID          NOT NULL,
    grant_mode                 VARCHAR(24)   NOT NULL,
    requested_not_before_utc   TIMESTAMP_UTC NOT NULL,
    requested_not_after_utc    TIMESTAMP_UTC NOT NULL,
    approval_profile_id        VARCHAR(96)   NOT NULL,
    state                      VARCHAR(32)   NOT NULL,
    state_version              BIGINT        NOT NULL,
    request_digest             BINARY_32     NOT NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, request_id)
);

CREATE TABLE authz_approval_decision (
    realm_id                   UUID          NULL,
    approval_decision_id       UUID          NOT NULL,
    request_type               VARCHAR(32)   NOT NULL,
    request_id                 UUID          NOT NULL,
    request_digest             BINARY_32     NOT NULL,
    approver_principal_id      UUID          NOT NULL,
    approver_assignment_generation BIGINT    NOT NULL,
    decision                   VARCHAR(16)   NOT NULL,
    reason_code                VARCHAR(64)   NOT NULL,
    decided_at_utc             TIMESTAMP_UTC NOT NULL,
    valid_until_utc            TIMESTAMP_UTC NOT NULL,
    decision_digest            BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, approval_decision_id),
    UNIQUE (realm_id, request_id, request_digest, approver_principal_id)
);

CREATE TABLE authz_grant (
    realm_id                   UUID          NULL,
    grant_id                   UUID          NOT NULL,
    principal_id               UUID          NOT NULL,
    principal_type             VARCHAR(24)   NOT NULL,
    source_type                VARCHAR(24)   NOT NULL,
    source_id                  UUID          NOT NULL,
    role_template_id           UUID          NULL,
    role_revision              BIGINT        NULL,
    direct_capability_set_id   UUID          NULL,
    scope_manifest_id          UUID          NOT NULL,
    condition_profile_id       VARCHAR(96)   NOT NULL,
    not_before_utc             TIMESTAMP_UTC NOT NULL,
    not_after_utc              TIMESTAMP_UTC NOT NULL,
    generation                 BIGINT        NOT NULL,
    delegation_parent_grant_id UUID          NULL,
    delegation_depth_remaining BIGINT        NOT NULL,
    status                     VARCHAR(24)   NOT NULL,
    activated_at_utc           TIMESTAMP_UTC NOT NULL,
    revoked_at_utc             TIMESTAMP_UTC NULL,
    content_digest             BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, grant_id),
    CHECK (not_after_utc > not_before_utc),
    CHECK (status IN ('ACTIVE','REVOKED','EXPIRED','SAFETY_HOLD'))
);

CREATE TABLE authz_jit_request (
    realm_id                   UUID          NOT NULL,
    jit_request_id             UUID          NOT NULL,
    requester_principal_id     UUID          NOT NULL,
    beneficiary_principal_id   UUID          NOT NULL,
    scope_manifest_id          UUID          NOT NULL,
    purpose_id                 VARCHAR(96)   NOT NULL,
    ticket_token_digest        BINARY_32     NOT NULL,
    requested_start_utc        TIMESTAMP_UTC NOT NULL,
    requested_end_utc          TIMESTAMP_UTC NOT NULL,
    authentication_profile_id  VARCHAR(96)   NOT NULL,
    response_field_profile_id  VARCHAR(96)   NOT NULL,
    approval_profile_id        VARCHAR(96)   NOT NULL,
    state                      VARCHAR(32)   NOT NULL,
    state_version              BIGINT        NOT NULL,
    request_digest             BINARY_32     NOT NULL,
    created_at_utc             TIMESTAMP_UTC NOT NULL,
    PRIMARY KEY (realm_id, jit_request_id)
);

CREATE TABLE authz_break_glass_case (
    realm_id                   UUID          NULL,
    break_glass_case_id        UUID          NOT NULL,
    emergency_principal_id     UUID          NOT NULL,
    recovery_profile_id        VARCHAR(96)   NOT NULL,
    incident_token_digest      BINARY_32     NOT NULL,
    state                      VARCHAR(32)   NOT NULL,
    state_version              BIGINT        NOT NULL,
    requested_at_utc           TIMESTAMP_UTC NOT NULL,
    activated_at_utc           TIMESTAMP_UTC NULL,
    hard_expires_at_utc        TIMESTAMP_UTC NULL,
    revoked_at_utc             TIMESTAMP_UTC NULL,
    request_digest             BINARY_32     NOT NULL,
    alert_evidence_digest      BINARY_32     NULL,
    review_evidence_digest     BINARY_32     NULL,
    PRIMARY KEY (realm_id, break_glass_case_id)
);

CREATE TABLE authz_realm_epoch (
    realm_id                   UUID          NOT NULL PRIMARY KEY,
    authorization_epoch        BIGINT        NOT NULL,
    last_change_reason         VARCHAR(64)   NOT NULL,
    updated_at_utc             TIMESTAMP_UTC NOT NULL
);

CREATE TABLE authz_global_epoch (
    singleton_id               INTEGER       NOT NULL PRIMARY KEY,
    authorization_epoch        BIGINT        NOT NULL,
    last_change_reason         VARCHAR(64)   NOT NULL,
    updated_at_utc             TIMESTAMP_UTC NOT NULL,
    CHECK (singleton_id = 1)
);

CREATE TABLE authz_decision (
    realm_id                   UUID          NULL,
    decision_id                UUID          NOT NULL,
    operation_id               UUID          NOT NULL,
    actor_principal_id         UUID          NOT NULL,
    actor_type                 VARCHAR(24)   NOT NULL,
    session_or_credential_generation BIGINT NOT NULL,
    resource_type              VARCHAR(64)   NOT NULL,
    target_token               BINARY_32     NULL,
    action_code                VARCHAR(64)   NOT NULL,
    purpose_id                 VARCHAR(96)   NULL,
    ticket_token_digest        BINARY_32     NULL,
    result                     VARCHAR(16)   NOT NULL,
    reason_code                VARCHAR(64)   NOT NULL,
    matched_grant_set_digest   BINARY_32     NULL,
    obligation_profile_digest  BINARY_32     NOT NULL,
    authorization_epoch        BIGINT        NOT NULL,
    policy_digest              BINARY_32     NOT NULL,
    evaluated_at_utc           TIMESTAMP_UTC NOT NULL,
    valid_until_utc            TIMESTAMP_UTC NOT NULL,
    audit_class                VARCHAR(48)   NOT NULL,
    content_digest             BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, decision_id),
    UNIQUE (realm_id, operation_id, decision_id)
);

CREATE TABLE privileged_audit_event (
    realm_id                   UUID          NULL,
    audit_event_id             UUID          NOT NULL,
    decision_id                UUID          NOT NULL,
    operation_id               UUID          NOT NULL,
    actor_principal_id         UUID          NOT NULL,
    action_code                VARCHAR(64)   NOT NULL,
    target_class               VARCHAR(64)   NOT NULL,
    target_token               BINARY_32     NULL,
    mutation_or_result_digest  BINARY_32     NOT NULL,
    outcome                    VARCHAR(24)   NOT NULL,
    occurred_at_utc            TIMESTAMP_UTC NOT NULL,
    previous_chain_digest      BINARY_32     NULL,
    content_digest             BINARY_32     NOT NULL,
    chain_digest               BINARY_32     NOT NULL,
    PRIMARY KEY (realm_id, audit_event_id),
    UNIQUE (realm_id, operation_id)
);
```

### 5.13.1 Normative constraints

- `authz_capability_definition`, active role revisions, approvals, grants, decisions, and audit events are append-only or monotonic-state entities.
- Realm-scoped foreign keys include realm; product-global rows use an explicit global table/namespace, not `NULL` interpreted opportunistically. The logical `NULL` above represents an adapter choice that MUST be replaced by an unambiguous global namespace or split table in physical design.
- A principal cannot be both requester/beneficiary and prohibited approver under the selected profile.
- Approval decision uniqueness does not itself prove quorum; the activation transaction evaluates eligibility and distinctness.
- A grant activation/revocation transaction advances the relevant authorization epoch.
- Decision/audit target tokens are purpose-separated keyed tokens or opaque IDs, never raw selector values.
- Retention, partitioning, chain technology, and audit store are **HUMAN DECISION/CLI EXPERIMENT**.

## 5.14 Protocol requirements

### 5.14.1 OIDC client

- use discovery metadata only from configured issuer roots and validate issuer equality;
- authorization code flow; PKCE; PAR where supported and interoperable;
- reject implicit and resource-owner-password flows;
- exact redirect URI; state and nonce; no open redirect;
- confidential client authentication by approved secret or preferably private-key method where supported;
- validate token algorithms and keys under provider profile; no algorithm from token input alone;
- minimize scopes/claims; no `offline_access` unless refresh behavior is required and approved;
- prevent mix-up across multiple issuers by binding session transaction to issuer/client/redirect;
- support provider-key rotation and metadata failure without soft-allowing invalid tokens;
- log only finite outcome codes.

### 5.14.2 Service clients

- exact audience and endpoint binding;
- mTLS according to RFC 8705 or JWT client assertion according to RFC 7523 when selected [W10–W11];
- bounded clock/skew profile and replay-resistant assertion IDs;
- no bearer credential in URL/query/log;
- credential status and generation checked by server.

### 5.14.3 Ticket/case binding

A ticket integration MUST return or validate a typed assertion containing only:

```text
ticket token ID/digest
realm
approved purpose ID
approved target/scope digest
requester/beneficiary binding where applicable
status/version
not-before/not-after
authoritative issuer/audience
```

The authorization evaluator never parses free-form ticket text. A ticket outage fails closed for capabilities that require it.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 BFF session state machine

```text
ANONYMOUS
  -> OIDC_TRANSACTION_CREATED
      -> CALLBACK_REJECTED -> ANONYMOUS
      -> AUTHENTICATED_BASE
  -> REALM_SELECTION_REQUIRED
      -> REALM_BOUND_SESSION
          -> STEP_UP_REQUIRED
              -> STEP_UP_REJECTED -> REALM_BOUND_SESSION(low privilege)
              -> STEP_UP_SATISFIED -> REALM_BOUND_SESSION(new generation)
          -> REALM_SWITCH_REQUESTED
              -> NEW_REALM_BOUND_SESSION(new session ID; caches cleared)
          -> LOGOUT_REQUESTED
              -> LOCAL_REVOKED
              -> PROVIDER_LOGOUT_PENDING/COMPLETE
          -> SESSION_EXPIRED
          -> BACK_CHANNEL_REVOKED
          -> PRINCIPAL_DISABLED
```

Rules:

- OIDC transaction state/nonce/PKCE verifier is one-use and bounded.
- Successful authentication rotates the browser session ID.
- Step-up and realm switch rotate the security session generation.
- Logout/revocation invalidates server session and authorization cache before outward redirect.
- Provider logout failure cannot reactivate the local session.

## 6.2 Role-template lifecycle

```text
DRAFT
  -> VALIDATING
      -> REJECTED
      -> REVIEW_REQUIRED
  -> APPROVED_CANDIDATE
  -> ACTIVE
      -> DEPRECATED
      -> FROZEN
      -> SUPERSEDED
      -> RETIRED
```

Active revisions are immutable. A new capability set creates a new revision. Assignments remain bound to their exact revision until a governed migration/reapproval. Role display-name changes do not change authority, but are revisioned for audit/accessibility.

## 6.3 Assignment lifecycle

```text
DRAFT
  -> SUBMITTED
  -> VALIDATING
      -> REJECTED
      -> PENDING_APPROVAL
  -> APPROVED_PENDING_ACTIVATION
      -> ACTIVATION_REJECTED (state/authn/version changed)
      -> ACTIVE_GRANT
          -> REVIEW_DUE
          -> EXPIRED
          -> REVOKED
          -> SAFETY_HOLD
  -> CANCELLED
  -> SUPERSEDED
```

The request digest includes beneficiary, role/capabilities, realm, scope, purpose classes, grant mode, time, and approval profile. Any change supersedes decisions.

## 6.4 JIT/approval state machine — mandatory artifact

### 6.4.1 JIT request

```text
DRAFT
  -> SUBMITTED
  -> VALIDATING
      -> REJECTED_INVALID
      -> REJECTED_SOD
      -> PENDING_APPROVAL
          -> REJECTED
          -> EXPIRED_UNAPPROVED
          -> APPROVED_PENDING_ACTIVATION
              -> ACTIVATION_REQUIRES_STEP_UP
              -> ACTIVE
                  -> EXPIRED
                  -> REVOKED
                  -> SAFETY_HOLD
                  -> COMPLETED_EARLY
          -> SUPERSEDED (request content/version changed)
  -> CANCELLED_BY_REQUESTER (before activation)
```

### 6.4.2 Individual approval

```text
OPEN
  -> APPROVED
  -> REJECTED
  -> WITHDRAWN
  -> EXPIRED
  -> SUPERSEDED
  -> APPROVER_AUTHORITY_REVOKED
```

An approval is effective only while the request digest, approver authority generation, realm, approval profile, and time remain current. Revoking an approver's role may invalidate pending approvals according to the approved profile; active grants are separately evaluated/revoked rather than silently assumed valid.

### 6.4.3 Quorum evaluation

```text
NO_EFFECTIVE_APPROVALS
  -> PARTIAL_QUORUM
  -> QUORUM_SATISFIED
  -> QUORUM_INVALIDATED (expiry/revoke/content change/conflict)
```

Activation locks the request and effective approval rows, recomputes quorum, validates beneficiary/requester/approver distinctness, and creates the grant atomically.

## 6.5 Break-glass state machine — mandatory artifact

```text
PROFILE_DISABLED
  -> PROFILE_SEALED_AND_READY (human authority, keys, monitoring, runbook)

PROFILE_SEALED_AND_READY
  -> REQUESTED
      -> DENIED_INVALID_PROOF
      -> DENIED_OPERATION_NOT_IN_PROFILE
      -> PENDING_INDEPENDENT_AUTHORIZATION
          -> REJECTED
          -> EXPIRED_UNACTIVATED
          -> VERIFIED_PENDING_ACTIVATION
              -> ACTIVE
                  -> REVOKED
                  -> HARD_EXPIRED
                  -> KILLED_BY_INCIDENT_CONTROL
                  -> SAFETY_HOLD
              -> REVIEW_REQUIRED
                  -> CLOSED
                  -> REMEDIATION_REQUIRED
```

Mandatory transition effects:

- activation increments relevant authorization epoch, writes durable case/audit, and emits independent alert evidence;
- expiry/revocation invalidates sessions/caches and stops new operations;
- already committed safety-narrowing or deletion barriers are not undone by expiry;
- review records exact fixed operations and outcomes, not raw portal payload;
- profile returns to ready only after post-use checks and human closure.

## 6.6 Service identity lifecycle

```text
PROPOSED
  -> APPROVED
  -> CREDENTIAL_STAGED
  -> PROOF_VALIDATED
  -> ACTIVE
      -> ROTATION_STAGED
          -> DUAL_VALID_BOUNDED
          -> NEW_ACTIVE / OLD_RETIRED
      -> SUSPENDED
      -> REVOKED
      -> EXPIRED
      -> COMPROMISED_HOLD
  -> DECOMMISSIONED
```

Credential state and grant state are both required. Rotating a credential does not broaden capabilities. Decommission revokes grants and credentials and leaves minimal audit evidence.

## 6.7 Cache lifecycle

```text
MISS
  -> AUTHORITATIVE_LOAD
      -> LOAD_FAILED -> DENY/OUTAGE
      -> ACTIVE(epoch, generation, valid_until)
          -> HIT
          -> EXPIRED -> MISS
          -> INVALIDATION_RECEIVED -> INVALIDATED
          -> EPOCH_MISMATCH_ON_FINAL_CHECK -> INVALIDATED
          -> SAFETY_HOLD -> INVALIDATED
```

An invalidation event can arrive late; the final transaction epoch check is the hard guard for privileged mutations. Cache failure never creates authority.

## 6.8 Long-running job lifecycle

```text
REQUEST_DRAFT
  -> SUBMIT_AUTHORIZATION
      -> DENIED
      -> SUBMITTED_AUTHORIZED(grant lease)
  -> QUEUED
  -> CLAIM_REAUTHORIZATION
      -> PAUSED_AUTHZ
      -> CLAIMED
  -> PHASE_1
  -> PHASE_REAUTHORIZATION
      -> PAUSED_AUTHZ / CANCELLED
      -> PHASE_2
  -> TERMINAL_VERIFY
      -> COMPLETED
      -> COMPLETED_WITH_LIMITATIONS
      -> FAILED
```

Rules by operation class:

- Export: expiry/revocation before object creation prevents creation; after an object is created, download remains separately authorized and object expiry/deletion continues.
- Deletion: expiry before barrier prevents barrier; after barrier, suppression remains and physical deletion may pause for reauthorization, never reveal data.
- Release: each promotion ring reauthorizes exact digest/ring/current evidence; expiry prevents later rings.
- Diagnostics: permit expiry stops enhanced collection and export; cleanup continues under fixed safety authority.
- Restore: operator authority may expire while environment remains read-blocked; a new verifier/read-enable decision is required.

## 6.9 Authorization catalogue rollout

```text
DRAFT_CATALOGUE_REVISION
  -> SCHEMA/STATIC_ANALYSIS
  -> ROUTE_COMPATIBILITY_MATRIX
  -> SYNTHETIC_REALM/PERSONA TESTS
  -> APPROVED_CANDIDATE
  -> SERVER_CONSUMERS_DEPLOYED
  -> DORMANT_ACTIVE_CAPABILITIES
  -> FICTIONAL/LAB ASSIGNMENTS
  -> STAGED_REALM ENABLEMENT (human gate)
  -> CURRENT
  -> DEPRECATED / FROZEN / HIGHER_REVISION_ROLLBACK
```

Consumer-first rules:

1. Server code that recognizes and denies a new capability deploys before any assignment/policy can reference it.
2. Unknown capability/action/condition denies on old and new releases.
3. A capability may be recognized but dormant until its feature, purpose, workflow, and owner gates pass.
4. Role-template migration does not silently move assignments. Each migration is simulated and reviewed; high-risk changes require reapproval.
5. Rollback republishes known-good catalogue semantics at a higher revision; revision never decrements.
6. Old BFF sessions observe epoch change and reload; high-risk operations do not rely on session-start capability snapshots.

## 6.10 Compatibility rules

- Route descriptors and capability definitions have exact versions and executable old/new matrices.
- A producer does not issue a grant referencing a capability unknown to all supported server consumers.
- UI may render unknown action IDs as unavailable; it must not guess or hide a server error as success.
- Session schema changes use current/previous consumer migration or revoke old sessions; no silent claim reinterpretation.
- Approval and grant records retain exact semantic revisions. A new evaluator must reproduce old active semantics until migration or expiry.
- A background job is executed only by a worker compatible with its job contract, capability revision, authorization envelope, and output profile.
- Exact support windows are **HUMAN DECISION**; no global “current and previous” promise is accepted without evidence.

## 6.11 Mutation transaction boundaries

### 6.11.1 Assignment/JIT activation

```text
BEGIN;
  lock request and current version;
  load actor, beneficiary, realm, capability/role revision;
  load effective approvals and SoD conflicts;
  verify database time, authn profile, policy/kill state;
  create immutable active grant;
  increment realm/global authorization epoch;
  insert authorization decision and privileged audit;
  mark request activated;
COMMIT;
```

### 6.11.2 Revocation

```text
BEGIN;
  authorize revoker and target realm/grant;
  lock active grant;
  append revocation and set monotonic state;
  increment authorization epoch;
  revoke/mark linked sessions or job leases as required;
  insert decision and audit;
COMMIT;
then publish invalidation/alert; publication failure leaves epoch hard guard active.
```

### 6.11.3 Domain mutation

Every privileged module follows the section 3.15 atomic boundary. A pre-authorization may improve UX, but only the final locked decision authorizes commit.

## 6.12 Restore and disaster-recovery lifecycle

Authorization state in a restored environment starts as:

```text
RESTORED_AUTHZ_READ_BLOCKED
  -> SCHEMA_AND_REALM_VERIFIED
  -> CURRENT_CAPABILITY/ROLE CATALOGUE RECONCILED
  -> PRINCIPAL/GRANT/REVOCATION EPOCH RECONCILED
  -> BREAK_GLASS AND SERVICE STATUS RECONCILED
  -> AUDIT CONTINUITY VERIFIED
  -> TOMBSTONE/RESTORE READINESS VERIFIED
  -> SYNTHETIC DENY/ALLOW PROBES PASS
  -> AUTHZ_TECHNICALLY_READY
  -> SEPARATE AUDITED READ/MUTATION ENABLEMENT
```

An older backup cannot revive expired/revoked grants, old role revisions, stale service credentials, or break-glass cases. Current authoritative epochs and revocations are replayed before ordinary reads. A gap/fork/conflict keeps the environment blocked.

## 6.13 Incident response and cleanup lifecycle

Authorization incidents use finite classes:

```text
CROSS_REALM_OR_WRONG_TARGET
UNAUTHORIZED_ALLOW
STALE_GRANT_OR_CACHE
TOKEN_OR_SESSION_COMPROMISE
APPROVAL_OR_SOD_BYPASS
BREAK_GLASS_MISUSE
AUDIT_GAP_OR_TAMPER
POLICY/CATALOGUE_SUPPLY_CHAIN
IDENTITY_PROVIDER_COMPROMISE
SERVICE_CREDENTIAL_COMPROMISE
RESTORE_REVIVED_AUTHORITY
```

Minimum response:

1. activate capability/realm/global narrowing or safety hold;
2. revoke affected sessions, grants, service credentials, and job leases;
3. preserve content-addressed privacy-safe decision/audit evidence;
4. identify every operation authorized under affected generation/epoch;
5. stop or contain future phases without undoing safety barriers;
6. repair catalogue/policy/code and publish higher revision;
7. run targeted and neighboring negative tests;
8. clean stale caches/sessions/objects and verify deletion/expiry;
9. conduct human impact/legal/privacy assessment outside technical research;
10. re-enable only through an audited owner decision and passed gate.

---
# 7. Security/privacy threat and failure register

## 7.1 Threat and failure matrix — mandatory artifact

| ID | Trigger/threat | Detection | Immediate containment | Recovery | Cleanup/evidence | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T19-01 | Cross-realm IDOR: attacker changes target ID/route/body realm | realm-first repository mismatch, decision reason, zero-row scoped lookup, synthetic canary | generic deny/not-found; hold affected route/build on any confirmed allow | fix target resolver/key; publish higher route/catalogue release; invalidate sessions/caches | enumerate decisions/jobs/exports under affected build; delete exposed temporary objects under incident authority | Realm Security + API Owner | all routes with same IDs in multiple synthetic realms; response/body/error comparison | privileged DB/infrastructure access can bypass app boundary |
| T19-02 | Confused deputy background job executes beneficiary work in worker's realm or scope | job-envelope/service-context comparison, phase decision mismatch | pause job and destination; revoke job lease/service grant if systemic | correct envelope and claim/phase checks; replay only idempotently | verify no cross-realm object/fact/export; retain safe job/decision evidence | Job Owner + Service IAM | submit in realm A, manipulate worker/cache to realm B, target collision | complex distributed jobs can hide a missing phase recheck |
| T19-03 | UI hides action but API route lacks enforcement | route inventory/descriptor CI, penetration negative test | disable route/feature | add descriptor/evaluator and regression test | inspect audit/operations since route release | API Architecture | invoke every route directly with no grant and mismatched UI state | undocumented alternate protocols may escape inventory |
| T19-04 | IdP group/role claim accidentally mapped directly to capability | architecture analyzer, claim-to-grant mutation, decision provenance | disable mapping and affected sessions | require governed assignment workflow and new generation | revoke claim-derived grants; inspect decisions | IAM/Federation | inject arbitrary/overage/stale group claims | IdP compromise can still authenticate attacker |
| T19-05 | Session fixation or stolen session cookie | session ID reuse test, anomaly counters, logout/revoke mismatch | revoke session family; rotate server protection keys if needed | fix rotation/cookie/session binding; force reauthentication | clear server sessions and caches; preserve finite event evidence | Portal IAM | preseed cookie, login/step-up/realm switch, replay from second client | browser compromise can use a valid current session until detected |
| T19-06 | XSS attempts token extraction | browser storage/cookie inspection, CSP/reporting where selected, canary token tests | revoke sessions; disable affected UI route/build | remove injection; maintain server-side token boundary | clear rendered/cache artifacts; no token in reports | Portal Security | hostile script reads storage, DOM, JS globals, responses, diagnostics | XSS can still perform same-origin actions as user; CSRF does not stop it |
| T19-07 | CSRF on approval, realm switch, logout, export, or mutation | antiforgery failure metric, Origin/Fetch Metadata, browser automation | reject before authorization/domain work | fix route/method/token policy | invalidate any ambiguous session/operation; inspect audit | Portal Security | cross-site form/fetch/navigation for every unsafe route | browser bugs/extensions and XSS remain |
| T19-08 | OIDC mix-up/open redirect/incorrect issuer | transaction issuer/client/redirect/state/nonce mismatch | reject callback; clear transaction | fix exact provider profile and redirect list | purge transaction state; preserve finite failure code | Federation Engineering | multiple synthetic issuers, swapped codes/state, encoded redirects | provider compromise or metadata key compromise remains |
| T19-09 | Access/refresh token appears in browser/log/support bundle | token canaries, browser storage/network scan, log schema guard | revoke token/session; stop affected build and export | move storage server-side; remove logging/diagnostic path | delete contaminated artifacts per incident/records authority | Portal IAM + Privacy | all-sink canary across browser, logs, traces, bundles, errors | privileged browser/OS tooling may observe session use, not server token |
| T19-10 | Stale cache allows after grant/principal/policy revocation | epoch mismatch at final transaction, revocation latency probe | deny high-risk operations from cache; force authoritative mode | repair invalidation; reduce or remove cache for affected class | flush cache/session, inspect decisions during stale interval | Platform/SRE + IAM | revoke during concurrent calls at every cache boundary | low-risk read may remain available within approved stale window if humans accept it |
| T19-11 | Clock rollback extends JIT/approval/break-glass/session | database-time comparison, clock-confidence signal | deny expiration-sensitive actions; revoke emergency grants | restore time confidence and reauthenticate/reactivate | invalidate affected cache entries and sessions | Platform Security/SRE | wall-clock step forward/back, DB/client disagreement, leap boundaries | database clock or infrastructure compromise can still falsify time |
| T19-12 | Requester self-approves or colluding alternate account bypasses SoD | principal/conflict graph, request/approval actor comparison, audit analytics | reject activation; hold suspicious principals/request | correct profile/mapping; independent review | revoke grant, cancel jobs/exports, inspect related approvals | IAM Governance + Security | same principal, linked service, dual identity, revoked approver, quorum permutations | collusion among properly distinct authorized humans cannot be fully prevented technically |
| T19-13 | Approval replay after request target/purpose/content changes | immutable request digest/version mismatch | mark approval superseded; deny activation | create new request and decisions | remove no data; retain immutable supersession evidence | Workflow/IAM | mutate every bound field between approval and activation | external ticket content can change unless assertion is version-bound |
| T19-14 | Ticket/case token is forged, stale, wrong realm, or too broad | signature/status/version/realm/target/purpose checks | deny; do not reveal ticket existence | fix integration or issue corrected assertion | invalidate caches and pending requests | Workflow Integration | forged/replayed/expired/wrong-audience/wrong-realm assertions | upstream case system compromise can authorize bad purpose/target within its authority |
| T19-15 | Target substituted between authorization and mutation (TOCTOU) | final transaction resource version/digest and realm lock | rollback mutation | bind request/approval to immutable target/version; retry through new approval if material | inspect no partial mutation/audit | Domain Owner + Data Reliability | concurrent target move/state/version change at each transaction boundary | some external targets cannot be atomically locked and require compensating verification |
| T19-16 | Response returns fields broader than allowed | response schema/profile validation, canaries, serializer architecture tests | block response and hold route if sensitive | use projection/query shaped by obligation, not post-fetch clone/redact | delete caches/exports; scan sinks | API/Data Privacy | inject extra DTO/property/ORM include; compare profiles | indirect inference from allowed fields remains a human/privacy risk |
| T19-17 | Service identity impersonates human or approves access | actor-type descriptor check, service capability catalogue, audit | reject and suspend service identity | correct route/grants; rotate credential if abused | revoke jobs/credentials; inspect decisions | Service IAM | service calls human-only/JIT/approval/download/break-glass routes | compromised permitted service can misuse its exact capabilities |
| T19-18 | Service credential copied/replayed | credential generation, mTLS/private-key proof, JWT ID replay cache where applicable | revoke credential and linked service grants | rotate key and investigate workload/release provenance | remove old key/trust; verify no residual jobs | Service IAM + PKI | replay assertions, clone cert/key in T1 lab, rotation overlap | local admin/workload compromise may use a valid nonexportable key |
| T19-19 | Tenant policy or feature flag broadens product capability | monotonicity validator, catalogue diff, property tests | reject candidate; preserve active known-good | correct candidate; publish higher revision | remove candidate caches; retain rejection evidence | Authorization Architecture + Privacy | generated narrowing/broadening mutations | malicious product authority can still publish overly broad ceiling |
| T19-20 | Capability/role semantic change silently affects active grants | content digest/revision binding, compatibility migration report | freeze new revision/assignments | explicit migration and reapproval or allow old revision until expiry | invalidate decision caches; audit migration | IAM Governance + Release | old/new matrix and role diff mutation | long-lived old revisions increase support burden |
| T19-21 | Break-glass used for ordinary access or remains active | fixed operation allowlist, hard expiry, independent alert, post-review gate | revoke/kill; freeze emergency profile | investigate and rotate recovery credentials; remediate authority | close sessions, grants, caches, temporary objects; immutable review | Security Incident + Identity Recovery | attempt detail/export/arbitrary grant/self-extension/no-alert | colluding custodians or compromised recovery authority remains high impact |
| T19-22 | Ordinary admin lockout prevents revocation/recovery | heartbeat/ready check for independent recovery path, scheduled drills | use fixed offline/IdP emergency recovery operations | restore known-good catalogue/IdP binding; reissue normal authority | revoke emergency grant and rotate/reseal as required | Identity Recovery | corrupt role catalogue, disable all admins, IdP outage, DB failover | recovery keys/process may be unavailable or unsafe under real disaster |
| T19-23 | Authorization store outage creates fail-open workaround | explicit outage mode, error taxonomy, no matching code path | deny protected actions; show generic outage | restore store/reconcile epochs; no manual DB grant | remove emergency temporary artifacts; inspect failed attempts | Authorization Platform/SRE | disconnect DB/cache/invalidation separately during reads/mutations | fail-closed outage can materially disrupt operations |
| T19-24 | Audit insert fails but mutation succeeds | same transaction and failpoint, reconciliation | rollback transaction; safety hold on repeated failure | repair audit/store; retry idempotently | verify no orphan mutation; preserve first failure | Data Reliability + Audit | kill/error before/after decision/audit/business write/commit/response | privileged DB operator can alter both business and audit unless separately protected |
| T19-25 | Audit or decision logs leak payload, URL, subject, claims, ticket text | schema allowlist, exact canaries, static analyzers, sink scan | stop export/route and revoke affected access | remove field/path; rotate compromised secrets if present | delete/contain contaminated logs/backups under authority | Privacy + Security Audit | schema mutation and all-sink encoded canary corpus | opaque identifiers and rare combinations may still enable linkage |
| T19-26 | Audit query/export becomes a broad surveillance path | separate capabilities/purposes/JIT, output profile, query bounds | revoke query/export grant; pause audit export | narrow fields/targets; independent review | delete temporary export and recipient keys where controlled | Security Governance + Privacy | wrong-realm, broad-time, free-text, join, export-reuse tests | authorized reviewers can misuse permitted evidence; human governance required |
| T19-27 | Restore revives expired/revoked grants or stale sessions | authoritative epoch/revocation comparison, synthetic probes | keep restored environment read/mutation blocked | replay current control/revocation state; rebuild sessions/caches | destroy unsafe restored environment if reconciliation fails | Restore + IAM + Data Reliability | restore old backup with later revocations/JIT/break-glass | incomplete independent revocation authority can prevent safe readiness |
| T19-28 | Direct database/admin path bypasses application authorization | privileged DB audit, network/role controls, reconciliation anomalies | restrict connection/role; incident hold | rotate credentials, repair least privilege, assess mutations | identify and govern direct changes; no silent SQL repair | Database Security + Governance | app roles cannot write grants/audit/business privileged mutations directly; controlled negative DB tests | database owner/root can ultimately bypass logical controls |
| T19-29 | Role/grant explosion makes review and revocation unreliable | inventory bounds, orphan/duplicate/shadow reports, owner/expiry checks | stop new assignments in affected class | consolidate templates/scopes; expire stale grants | revoke orphan grants, preserve migration audit | IAM Governance | generated large fictional inventory, duplicate/conflict/orphan detection | human review fatigue remains even with good tooling |
| T19-30 | Authorization evaluation or cache is DoS target | bounded parser/evaluator, load/resource metrics, per-principal/route budgets | rate-limit unauthenticated/abusive clients; preserve emergency/revoke priority | capacity/tune without weakening decisions | clear attack sessions; retain finite counters | Portal SRE + Security | open-arrival allow/deny/cross-realm load, cache stampede, outage recovery | high-cost target resolution may still exhaust dependent stores |
| T19-31 | Error behavior reveals target/realm/principal existence | response-equivalence tests, reason exposure review | generic external error | normalize route responses/timing where practical | no data cleanup; inspect access evidence | API Security | absent vs other-realm vs unauthorized vs retired comparison | perfect timing indistinguishability is difficult; contain material differences |
| T19-32 | Accessibility failure causes unsafe approval or accidental realm/target action | accessible name/state tests, keyboard and screen-reader review, usability incident | pause high-risk UI path; API remains safely denied without valid request | correct immutable summary, focus, status messages, confirmation | cancel ambiguous drafts/requests; no authority from incomplete UI | Portal UI + Accessibility + Workflow Owner | keyboard-only, zoom, screen reader, expiry warning, non-color status | human misunderstanding cannot be eliminated technically |
| T19-33 | Supply-chain compromise alters evaluator/catalogue/BFF | reproducible build/provenance, signed release, dependency scan, route/canary tests | freeze release/rings; rollback higher sequence | rebuild from trusted source; rotate affected credentials/keys | revoke sessions/grants issued by bad build where necessary; evidence | Release/Supply Chain + IAM | tampered package, changed descriptor, missing analyzer, dependency substitution | trusted signing/release authority compromise remains catastrophic |
| T19-34 | Authentication assurance mapped incorrectly across providers | exact provider profile, normalized authn-class tests, no unknown mapping | deny step-up/high-risk action | correct mapping; force reauthentication | revoke high-risk sessions/grants activated under bad mapping | Federation + Security | missing/multiple `acr`/`amr`, provider differences, stale authentication | IdP assertion may be semantically wrong despite valid signature |
| T19-35 | OAuth/BFF logout gap leaves upstream or local session active | local session state, back-channel/RP logout evidence, post-logout probe | revoke local first; deny current session | complete provider logout and session-store cleanup | delete server session/tokens; verify browser cookies | Portal IAM | IdP logout failure, lost back-channel, multi-tab, old cookie replay | another unaffected IdP session may reauthenticate user as designed |
| T19-36 | Purpose is selected merely to satisfy form, without genuine authority | purpose-ticket-target binding, approval review, audit analytics | deny invalid/missing binding; revoke suspicious grant | governance review and purpose redesign | inspect operations under misused purpose; human incident handling | Product Governance + Privacy | purpose mismatch, broad purpose, expired purpose, ticket different target | truthful human intent and lawful use cannot be proved by software alone |

## 7.2 Mandatory runbooks

Before P19-AGG can pass, T1 exercises must exist for:

1. cross-realm allow or response-field escape;
2. stale grant/cache or principal revocation failure;
3. IdP/OIDC/session/token incident;
4. self-approval/SoD or ticket-binding bypass;
5. privileged mutation without audit or audit privacy escape;
6. break-glass misuse and emergency credential rotation;
7. authorization store or invalidation outage;
8. service credential compromise;
9. catalogue/role/release supply-chain incident;
10. restore revived stale authority;
11. UI/accessibility ambiguity on high-risk workflow;
12. direct database administrative change.

Each runbook names detection, authority to contain, exact kill/narrowing operation, affected realm/global scope, evidence, user/support communication, object/job cleanup, re-enable gate, and post-incident review owner.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Authorization test catalogue — mandatory artifact

Every route/command/job descriptor generates a baseline catalogue. A route cannot be active unless all applicable cases exist and pass.

| Test family | Required cases | Expected invariant |
|---|---|---|
| Authentication | anonymous, expired session, disabled principal, wrong issuer/audience, stale authn, insufficient authn class, revoked service credential | no protected action; finite safe result |
| Descriptor | missing descriptor, duplicate descriptor, retired capability, wrong actor type, unsafe method without CSRF, mutation without audit class | build/startup fails, not runtime fallback |
| Capability | no grant, wrong action, wrong resource type, capability revision mismatch, retired/frozen capability, grant mode not allowed | deny |
| Realm | same target ID in realms A/B, route/body realm spoof, cache key collision, global/realm confusion, target moved realm, product-global route from realm session | zero cross-realm authorization/data/evidence |
| Scope | target not in set, empty set, expired manifest, manifest digest mismatch, scope type confusion, oversized set, delegated subset/superset | only exact membership permits |
| Purpose/ticket | missing, inactive, wrong class, wrong realm/target, expired, replayed, malformed, free-text-only, purpose/output mismatch | deny; no payload echo |
| Grant time/state | before start, exact boundary, after expiry, revoked, safety hold, generation mismatch, duplicated grant, role superseded | database-time and monotonic state enforced |
| Approval | none, partial quorum, self-approval, same approver twice, wrong request digest, expired/revoked approver, altered target/purpose/duration/output, approval replay | no activation until exact effective quorum |
| SoD | author=publisher, requester=approver, executor=verifier, restore operator=read enabler, alternate service identity, linked conflict set | selected profile enforced |
| Authentication freshness | fresh, exact limit, stale, provider missing assurance, realm switch after step-up, step-up session fixation | high-risk action only under exact profile |
| Resource state/version | wrong state, stale version, concurrent mutation, target deleted/retired, restore blocked, legal hold interaction | final locked state controls |
| Output/profile | exact fields, omitted field, injected extra field, aggregate-to-detail fallback, export destination mismatch, serialization extension | no unauthorized field/object |
| CSRF/session | same-origin valid, missing/invalid token, cross-site form/fetch, login/logout CSRF, cookie flags, session fixation, multi-tab realm switch | unsafe cross-site action never succeeds |
| Cache | cold/hit, epoch change, revoke during request, invalidation loss, TTL boundary, realm collision, stale definition, store outage | equivalent to authoritative decision within approved model; high-risk final check |
| Background job | submit allowed then revoke, worker wrong realm, service-only grant, grant expires between phases, job replay, target changes, output destination revoked | no future unauthorized phase; stable idempotency |
| Audit | allow/deny schema, mutation failpoints, audit unavailable, duplicate retry, wrong realm audit query, forbidden canaries, chain/reconciliation | no privileged mutation without exact durable evidence; no sensitive payload |
| Break-glass | profile disabled, invalid proof, self-activation, operation outside profile, hard expiry, revoke, no alert, detail/export attempt, post-review gap | fixed recovery only, bounded and observable |
| Service identity | wrong audience/realm/endpoint, key generation, replay, human-only route, approval attempt, credential rotation/revoke | exact non-human authority only |
| Restore | old grants, later revoke, expired JIT, active old session, break-glass case, service rotation, epoch gap/fork | restored environment remains blocked until current state |
| Error/privacy | absent vs wrong realm vs unauthorized, malformed IDs, target enumeration, exception injection, timing distribution, log canaries | no material existence disclosure or raw input sink |
| Accessibility | keyboard, focus, programmatic state, non-color status, expiry warning, immutable approval summary, zoom/reflow | high-risk workflow operable and unambiguous |
| Property/model | grant removal, narrower scope, shorter time, stricter purpose/authn/approval, realm permutation, request mutation, cache interleaving | narrowing never changes deny to allow; realm noninterference |

## 8.2 Route completeness method

A build tool reads endpoint metadata/OpenAPI plus registered command/job handlers and emits:

```text
route ID
handler identity
method/path or command type
resource/action
actor types
realm mode/target resolver
purpose/ticket/authn/approval requirements
CSRF/idempotency/audit/final-recheck flags
response profile
positive test ID
required negative test IDs
```

The tool compares this inventory with the committed descriptor catalogue. The following are build failures:

- unclassified handler;
- descriptor without handler;
- handler reachable through more than one path with inconsistent descriptor;
- route generated at runtime without committed metadata;
- generic fallback policy such as “authenticated user”; 
- response schema not linked to an output profile;
- background handler lacking service identity and job-envelope policy.

## 8.3 Property and model tests

### 8.3.1 Monotonic narrowing

For any valid decision input `x` and authority state `S`:

```text
if DENY(S, x), then DENY(Narrow(S), x)
```

where `Narrow` may remove a grant/capability/scope item/purpose, shorten time, add approval/authn requirement, disable a feature, add a deny, move resource to blocked state, or reduce output fields.

A counterexample is a release blocker.

### 8.3.2 Realm noninterference

For two synthetic realms with identical opaque IDs in different namespaces:

```text
Changing all facts outside actor realm R
must not change an authorization result or response in R,
except product-global safety state explicitly designed to do so.
```

No cache/database/object/job/audit key collision is permitted.

### 8.3.3 Approval content binding

For any approved request `q`, mutating one bound field creates `q'` such that old approvals are ineffective. Fields include beneficiary, realm, capability, target/scope, purpose, ticket, time, authn, output, destination, resource version, and approval profile.

### 8.3.4 Cache equivalence

For each interleaving of load, allow, revoke, epoch increment, invalidation loss/delay, expiry, and final transaction check, the cached evaluator must not produce a committed privileged effect that the authoritative evaluator denies.

### 8.3.5 Decision/response conformance

Every response field/object is justified by the decision obligation. Serializer/domain mutations adding a field must fail a schema or canary test.

## 8.4 Smallest falsifying prototypes

All durations below are **ESTIMATE** for planning and are not delivery commitments or production SLOs.

### P19-01 — route completeness and deny-by-default kernel

**Claim.** Every executable API route and background handler is denied without a committed descriptor and exact capability.

**Setup.** Minimal ASP.NET Core control API with fictional fleet summary, policy draft, detail read, export create, deletion authorize, audit query, authorization assignment, one background export handler, and synthetic realms/personas. No real data or IdP.

**Instrumentation.** Endpoint data-source inventory, command-handler registry, architecture analyzer, strict descriptor parser, authorization decision trace with finite codes, code-coverage map.

**Steps.**

1. Generate route/handler inventory.
2. Remove one descriptor; expect build/startup failure.
3. Change action/resource/actor/audit/CSRF metadata independently; expect failure.
4. Invoke every route anonymously, authenticated without grant, wrong action, and exact positive grant.
5. Add a second hidden route/handler alias and verify inventory catches it.
6. Mutate evaluator default from deny to allow; mutation test must fail.

**Pass.** One-to-one descriptor coverage; all negative calls deny; exact positives alone allow; every deliberate omission/mutation detected.

**Fail/stop.** Any executable path operates under generic authentication, implicit role, missing audit, or missing response profile.

**Evidence.** `p19-01/{route-inventory.json,descriptor-catalogue.json,mutation-results.json,requests.ndjson,decisions.ndjson,build-manifest.json,cleanup.json}`.

**Duration estimate.** 0.5–1 lab day after repository/contract scaffold.

**Cleanup.** Delete fictional database/session artifacts; verify clean tree and no listener/process.

### P19-02 — cross-realm and confused-deputy zero-tolerance campaign

**Claim.** No human/service/job can authorize, return, mutate, export, audit-query, or delete a resource from another realm.

**Setup.** Three fictional realms; same UUID-shaped resource IDs repeated across realms; human personas, service identity, cached resolver, export job, lifecycle case, audit records, and object store emulator.

**Instrumentation.** Realm-keyed SQL/object/cache trace, decision logs, row/object response manifests, job phase trace, canaries unique to each fictional realm.

**Steps.**

1. Run exact positive actions in each realm.
2. Substitute target IDs, body realm, route realm, scope manifest, ticket, cache key, object token, and job envelope across every ordered pair of realms.
3. Race realm switch with in-flight calls and background job claim.
4. Reuse service credential/grant from realm A on B.
5. Query audit/export/deletion status with wrong realm.
6. Compare external responses for absent, unauthorized, and other-realm targets.

**Pass.** Zero cross-realm allows, rows, fields, object bytes, mutations, jobs, audit facts, or materially distinguishing errors. Exact positives remain correct.

**Fail/stop.** One cross-realm effect or disclosure. Stop all dependent portal work and open incident/change ADR.

**Evidence.** `p19-02/{fixture-root.json,realm-matrix.json,decision-ledger.ndjson,sql-object-cache-manifest.json,job-trace.ndjson,canary-report.json,cleanup.json}`.

**Duration estimate.** 1–2 lab days for the minimal route set.

**Cleanup.** Destroy realm databases/objects/credentials; prove zero residual fixture canary outside evidence allowlist.

### P19-03 — JIT approval, expiry, revocation, and cache interleavings

**Claim.** An exact temporary grant starts no earlier than approved, ends no later than the earliest authority boundary, and cannot survive revocation or stale cache in a privileged commit.

**Setup.** Fake clock plus authoritative database time; two approvers; fictional detail/export capabilities; in-memory and distributed-cache adapter candidates; revocation/invalidation controller; long-running export phases.

**Instrumentation.** State transition ledger, epoch/generation trace, cache key/hit trace, database transaction failpoints, minimal counterexample shrinker.

**Steps.**

1. Generate JIT requests across time boundaries and approval profiles.
2. Test no/partial/self/duplicate/revoked/expired/wrong-digest approvals.
3. Activate at before/exact/after boundaries.
4. Revoke grant, principal, purpose, role, capability, and policy during cache hit and during final transaction.
5. Drop/delay invalidation events.
6. Let export job cross grant expiry between phases.
7. Step database and application clocks independently.

**Pass.** Only exact effective quorum activates; `valid_until` is correctly minimized; no committed effect after authoritative revoke/expiry; job stops future phases; deterministic replay.

**Fail/stop.** Stale allow commits, approval survives content change, self-approval passes, or clock uncertainty extends authority.

**Evidence.** `p19-03/{state-model.json,seeds/,minimal-counterexamples/,cache-trace.ndjson,db-snapshots/,decision-audit-ledger.ndjson,cleanup.json}`.

**Duration estimate.** 2–4 lab days after the model exists.

**Cleanup.** Revoke all fixture grants/sessions; empty caches; drop fixture DB; verify no scheduled job.

### P19-04 — OIDC BFF, token containment, session, and CSRF

**Claim.** The browser receives no access/refresh token and cannot execute unsafe cookie-authenticated actions cross-site; session fixation, issuer mix-up, and logout/revocation are contained.

**Setup.** Disposable local synthetic OIDC provider(s), BFF, browser automation, HTTPS test certificates, same-origin portal, malicious cross-site origin, fictional identities/realms. Exact runtime selected at execution time.

**Instrumentation.** Browser storage/DOM/network recorder, server token/session store inventory, cookie attribute capture, OIDC transaction trace without token values, CSRF test matrix, logout/revocation trace, all-sink token canaries.

**Steps.**

1. Execute code flow with PKCE and PAR where provider supports it.
2. Inspect browser storage, JS globals, DOM, responses, service worker/cache, history, and logs for token canaries.
3. Attempt state/nonce/issuer/code/redirect/PKCE mix-up and replay.
4. Preseed/steal/reuse session identifier; login, step-up, and realm switch must rotate it.
5. Execute cross-site form/fetch/navigation against every unsafe route, including logout and approval.
6. Revoke/back-channel logout during active session and verify protected calls deny.
7. Restart BFF/session store according to chosen profile and verify no unsafe fallback.

**Pass.** Zero browser token exposure; every invalid OIDC transaction rejects; unsafe cross-site actions fail; sessions rotate and revoke; only exact same-origin authorized requests work.

**Fail/stop.** Token in browser-accessible sink, CSRF success, session fixation, wrong issuer/code acceptance, or revoked session retains privileged authority.

**Evidence.** `p19-04/{provider-profile.json,browser-manifest.json,cookie-matrix.json,oidc-negative-results.json,csrf-results.json,logout-timeline.ndjson,canary-report.json,cleanup.json}`.

**Duration estimate.** 2–3 lab days per selected IdP profile after BFF scaffold.

**Cleanup.** Revoke test clients/sessions; remove test certificates, provider state, browser profiles, and local hosts/listeners.

### P19-05 — privileged mutation and audit atomicity/privacy

**Claim.** A privileged mutation and its authorization/audit evidence either commit together or not at all, and evidence contains no forbidden payload.

**Setup.** Fictional policy activation, role assignment, release promotion, deletion authorization, and connector activation mutations; one relational candidate; deterministic failpoint controller; canary payloads/claims/tickets.

**Instrumentation.** Failpoints before/after final decision, business write, decision insert, audit insert, commit, and response; database snapshots; strict audit schema and sink scanner.

**Steps.**

1. Execute each mutation normally and reconcile operation/decision/audit IDs.
2. Kill/error at every failpoint and reopen database.
3. Retry same idempotency key after ambiguous response.
4. Make audit store unavailable or schema invalid.
5. Inject forbidden values in body, claim, URL, ticket text, exception, and target display name.
6. Query audit under wrong realm/purpose.

**Pass.** Every durable state is old or complete; no mutation without decision/audit; retries do not duplicate; canaries absent; wrong-realm audit denies.

**Fail/stop.** Orphan mutation, missing audit, duplicate effect, mismatched decision, or forbidden value in evidence.

**Evidence.** `p19-05/{failpoint-plan.json,db-snapshots/,reconciliation.json,audit-schema.json,canary-report.json,cleanup.json}`.

**Duration estimate.** 2–4 lab days after domain transaction adapters exist.

**Cleanup.** Drop fixture database and evidence staging; verify no test controller in production artifact.

### P19-06 — break-glass and emergency lockout recovery

**Claim.** Independent emergency recovery can restore control after ordinary lockout without granting general portal/data authority, and it expires/revokes cleanly.

**Setup.** Fictional emergency principals, test-only threshold/recovery keys, intentionally corrupted/locked authorization catalogue and ordinary admin assignments, synthetic IdP outage variant, fixed recovery operation profile, independent alert sink.

**Instrumentation.** Ceremony/action transcript by finite codes/digests, decision/audit, alert delivery, session/cache/epoch state, operation allowlist trace, post-review checklist.

**Steps.**

1. Verify profile disabled before authority setup.
2. Remove all ordinary authorization admins and/or make IdP unavailable.
3. Attempt recovery with insufficient proof, wrong operation, wrong realm, expired envelope, replay, and self-extension.
4. Activate exact recovery profile and perform only freeze/revoke/known-good restore operations.
5. Attempt activity detail, export, connector secret, arbitrary assignment, and duration extension.
6. Revoke/expire recovery; verify sessions/caches/jobs deny.
7. Run post-use review and reseal/rotate fixture credentials.

**Pass.** Recovery restores ordinary control plane or safely freezes it; every non-profile action denies; independent alert/audit exists; hard expiry/revocation works; no residual emergency authority.

**Fail/stop.** Blanket bypass, insufficient proof works, data access succeeds, no alert/evidence, or emergency authority cannot be removed.

**Evidence.** `p19-06/{recovery-profile.json,proof-matrix.json,operation-trace.ndjson,alert-evidence.json,decision-audit.json,post-review.json,key-cleanup.json}`.

**Duration estimate.** 1–2 lab days for a T1 prototype; production ceremony requires separate human planning.

**Cleanup.** Destroy test recovery keys/trust, revoke emergency principals/grants, clear sessions/caches, restore clean fixture snapshot.

### P19-07 — authorization outage, load, and bounded observability

**Claim.** Under load and partial outages, the system fails closed without unbounded resources or metric cardinality, while revoke/recovery operations retain priority.

**Setup.** Stateful fictional human/service actors across multiple realms, open-arrival request scheduler, authorization DB/cache/invalidation/IdP fault controls, summary/detail/mutation mix.

**Instrumentation.** offered/started/completed load, decision latency and outcome classes, DB/cache/CPU/memory/thread/connection metrics, theoretical/actual series count, revoke-latency probes, queue/backlog.

**Steps.**

1. Qualify generator at target offered profile.
2. Run steady read/mutation/JIT mix.
3. Drop cache, invalidate storm, disconnect DB, delay invalidation, and make IdP unavailable separately.
4. Revoke grants/principals during each condition.
5. Generate hostile distinct IDs/claims/reasons to challenge metric labels.
6. Recover dependencies while new arrivals continue.

**Pass.** Zero unauthorized commits/cross-realm results; no dynamic metric labels; bounded resource growth; protected actions deny during unknown state; revoke/recovery work completes under approved measured criteria.

**Fail/stop.** Fail-open, stale privileged commit, hidden generator drop, unbounded cache/series/queue, or recovery starvation.

**Evidence.** `p19-07/{scenario.json,generator-proof.json,results.ndjson,resource-timeseries/,series-bound.json,revocation-probes.json,cleanup.json}`.

**Duration estimate.** diagnostic run 1–2 hours and an endurance run selected after observed maintenance/failure timescales; exact duration is not architecture.

**Cleanup.** Tear down load agents, credentials, databases, caches, and telemetry; verify no residual series/test identities.

## 8.5 Test evidence rules

Every experiment records:

```text
experiment/prototype ID and falsifiable claim
source tree and clean/dirty state
release, route, catalogue, role, condition, purpose, schema, and policy digests
runtime/package/browser/IdP/database exact versions and source/binary mapping
fixture root, seed, synthetic realms/personas/resources
commands/tool identities with secrets/addresses removed
start/end UTC and environment class
first failure, shrink chain, and every rerun outcome
decision/audit/DB/object/job manifests by digest
canary/cardinality results
cleanup/revert receipt
owner/reviewer functions, ADRs, exceptions, and expiry
```

A rerun does not erase the first failure. A harness fault is neither product pass nor product fail until repaired, but its original evidence remains. No raw credential, token, internal address, SSH material, real person, real ticket, real activity, or confidential configuration enters shareable evidence.

---
# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness functions

| ID | Fitness function | Measurement point | Pass criterion | Failure action |
|---|---|---|---|---|
| FF19-01 | Route/handler authorization completeness | every build and startup | `described_executable_paths == executable_paths`; no duplicate/inconsistent descriptor | block build/startup |
| FF19-02 | Deny-by-default | unit/property/mutation and integration | every missing/unknown/malformed authority input denies; default-allow mutation detected | block release |
| FF19-03 | No wildcard/general authority | catalogue/schema/static scan | zero `*`, arbitrary expressions, scripts, SQL, regex, path, dynamic action/resource, or generic admin bypass | block catalogue/release |
| FF19-04 | Cross-realm noninterference | every route/job/adapter test and recurring gate | zero cross-realm allow, returned row/field, mutation, export/object, audit fact, cache hit, or job phase | stop batch, incident/change ADR |
| FF19-05 | Exact capability/action | route and model tests | one active capability revision and matching grant required for each allow | block route |
| FF19-06 | Purpose/ticket binding | sensitive-route tests | every applicable allow contains active permitted purpose and exact ticket/case binding | keep capability disabled |
| FF19-07 | Monotonic narrowing | property/mutation tests | no generated narrowing operation changes `DENY` to `ALLOW` | block policy/catalogue |
| FF19-08 | JIT boundary correctness | fake/database-time tests | zero allow before not-before or at/after expiry; no activation without exact quorum/authn | block JIT capability |
| FF19-09 | Revocation/cache safety | concurrent integration/fault tests | zero privileged commit after authoritative revoke/epoch change; bounded measured low-risk behavior must match approved policy | disable cache or route |
| FF19-10 | SoD and approval binding | model/integration tests | zero prohibited self/conflict approval; every changed request invalidates old approval | block workflow |
| FF19-11 | Mutation/audit atomicity | failpoint tests | privileged mutation count without matching committed decision/audit = 0; orphan audit/mutation = 0 | block mutation capability |
| FF19-12 | Output minimization | schema/canary/integration | zero field/object outside decision obligation and response profile | stop route and treat as privacy incident candidate |
| FF19-13 | Browser token containment | browser/all-sink tests | zero access/refresh token in browser-accessible storage, DOM, response, log, trace, bundle, or evidence | block BFF release |
| FF19-14 | CSRF/session integrity | browser automation | zero unsafe cross-site success; login/step-up/realm switch rotate security session; revoked session denies | block portal |
| FF19-15 | Service-human separation | route/model tests | service identities cannot use human-only/approval/break-glass/download routes; humans cannot use service-only route by session claim | block identity profile |
| FF19-16 | Break-glass boundedness | recovery drill | only fixed operations; zero data detail/export; hard expiry/revoke/alert/review and cleanup pass | keep profile disabled |
| FF19-17 | Restore authority freshness | restore drill | no ordinary authorization until current epochs/revocations/catalogue/audit/visibility reconcile; stale grant/session probes deny | keep restored environment blocked |
| FF19-18 | Privacy-safe evidence | schema/static/canary scan | zero forbidden value/claim/payload in decision, audit, telemetry, support, test result, or evidence | incident/stop |
| FF19-19 | Metric cardinality | build-time formula and load | all labels closed; actual/theoretical series within approved budget; zero dynamic identity/value label | block observability config |
| FF19-20 | Bounded evaluator | fuzz/load | strict input limits; no unbounded CPU/memory/stack/cache; generator sustains intended offered load | fail scenario, tune without weakening |
| FF19-21 | Dependency and release integrity | each build/release | exact supported runtime/dependency/source mapping, SBOM/provenance, same signed digest, no test/recovery key in product | block release |
| FF19-22 | Accessibility | component/workflow test | WCAG 2.2 AA target where selected; keyboard, focus, programmatic status, non-color state, immutable approval summary pass | block high-risk UI workflow |
| FF19-23 | Owner/runbook completeness | gate aggregation | every active capability/route/purpose/approval/emergency/service identity has accountable owner/support/runbook | keep disabled |
| FF19-24 | Evidence freshness | startup/release/gate | all evidence/catalogue/provider/runtime/security profiles current and content-bound | state unknown/deny |

## 9.2 Exact primary gate expression

```text
P19_TECHNICAL_PASS =
    ROUTE_DESCRIPTOR_MISSING_COUNT = 0
    AND GENERIC_OR_WILDCARD_AUTHORITY_COUNT = 0
    AND DEFAULT_ALLOW_COUNTEREXAMPLES = 0
    AND CROSS_REALM_ALLOWS = 0
    AND CROSS_REALM_ROWS_FIELDS_OBJECTS_JOBS_AUDIT = 0
    AND PRIVILEGED_MUTATIONS_WITHOUT_DECISION_AND_AUDIT = 0
    AND OUTPUT_PROFILE_ESCAPES = 0
    AND JIT_BEFORE_START_OR_AFTER_EXPIRY_ALLOWS = 0
    AND REVOKED_OR_STALE_CACHE_PRIVILEGED_COMMITS = 0
    AND APPROVAL_CONTENT_OR_SOD_BYPASSES = 0
    AND BROWSER_ACCESS_OR_REFRESH_TOKEN_ESCAPES = 0
    AND UNSAFE_CSRF_SUCCESSES = 0
    AND SERVICE_HUMAN_IMPERSONATION_SUCCESSES = 0
    AND BREAK_GLASS_OUTSIDE_PROFILE_SUCCESSES = 0
    AND FORBIDDEN_DECISION_AUDIT_OBSERVABILITY_VALUES = 0
    AND RESTORE_REVIVED_AUTHORITY_SUCCESSES = 0
    AND BLOCKING_CLEANUP_FAILURES = 0
    AND BLOCKING_OWNER_OR_ADR_COUNT = 0
```

Latency, throughput, availability, cache hit rate, session count, or operational convenience cannot compensate for a nonzero hard invariant count.

## 9.3 Quantitative criteria that remain measurements or human decisions

The following MUST NOT be invented by architecture prose:

- maximum session idle/absolute duration;
- authentication freshness/assurance by capability;
- JIT/approval/break-glass maximum duration and quorum;
- revocation and cache invalidation objectives;
- authorization decision latency and availability objectives;
- route/cache/load headroom and database sizing;
- decision/audit retention, sampling, search, and export limits;
- metric-cardinality budget and alert thresholds;
- maximum scope-manifest size and role/grant inventory;
- owner review cadence and stale-grant deadline;
- support hours, incident response time, and recovery ceremony frequency.

Each accepted value must record owner, units, source, workload/topology, uncertainty, safety behavior when unknown, review trigger, and compatibility impact.

---

# 10. Human decisions and owner questions

## 10.1 Human decision register

The table provides options, consequences, a conservative temporary default, and an accountable function. It does not claim an option is approved.

| ID | Human decision | Options and consequences | Conservative temporary default | Accountable role/function |
|---|---|---|---|---|
| HD19-01 | Who receives each capability/role template | task-based assignment; group-driven proposal; individual assignment; each affects review and stale access | no production assignment; fictional lab personas only | Product Governance + IAM + line/accountable business owners |
| HD19-02 | Realm definition and delegated boundaries | customer/tenant/legal/data boundary; product-global authority may be separate and high impact | one fictional realm; no product-global human grant except T1 recovery test | Data Controller/Product Governance + IAM/Data Architecture |
| HD19-03 | Approvers and quorum by action | one approver is simpler; two/distinct functions reduce unilateral risk but increase outage/latency | high-risk capability disabled; T1 profile uses distinct synthetic requester/approver | Product/Risk + Security/IAM + domain owner |
| HD19-04 | Separation-of-duty conflict sets | author/publisher; requester/approver; executor/verifier; recovery/read-enable; stricter separation reduces misuse but needs staffing | enforce strongest practical synthetic profile; production disabled until mapped | Security Governance + Product/Operations Leadership |
| HD19-05 | Break-glass authority and custodians | IdP emergency accounts, offline quorum, or both; stronger independence increases operational ceremony | break-glass disabled | Security Incident Authority + Identity Recovery + Cryptographic Authority |
| HD19-06 | Break-glass allowed operations | freeze/revoke/known-good restore only vs broader repair; broader authority increases recovery options and abuse impact | fixed freeze/revoke/known-good authorization repair only; no detail/export | same as HD19-05 plus Architecture |
| HD19-07 | Break-glass monitoring and post-review | independent SOC/on-call alert, quorum witnessing, mandatory retrospective; cost/staffing impact | no activation without independent test alert and review owner | Security Operations + Audit/Governance |
| HD19-08 | Permitted detail purposes | case review, support, investigation, or none; each has legal/privacy consequences | empty purpose registry, therefore deny | Data Controller/Product Owner + Legal/Privacy/Workforce Governance |
| HD19-09 | Permitted export purposes/destinations | no export; approved encrypted case export; governed integration; recipient copies have different controllability | export capabilities disabled | Data Controller/Product/Data Governance + Legal/Privacy |
| HD19-10 | Diagnostic escalation purposes/levels | baseline D0/D1; D2 JIT; no raw D3; supportability vs privacy trade-off | predecessor closed profiles only; production enhanced permit disabled | Support Product Owner + Privacy/Security |
| HD19-11 | Authentication strength/freshness by capability | provider AAL/step-up/passkey/MFA profiles; stricter controls may exclude users or fail during IdP outage | high-risk action requires fresh strong profile candidate; no production activation until provider mapped | Identity Security + Risk/Product Accessibility |
| HD19-12 | Identity provider(s) and federation topology | single enterprise IdP, multiple issuers, guest/federated identities; complexity affects subject binding and logout | one synthetic issuer in lab; no guest/federated production access | Enterprise IAM/Federation Authority |
| HD19-13 | Session, refresh, idle, and absolute limits | shorter reduces exposure, increases interruption; longer aids offline/outage operation | finite short T1 values; no production promise | IAM Security + Product/SRE/Accessibility |
| HD19-14 | JIT maximum durations and early completion | per risk/action; renewable vs non-renewable; longer increases standing exposure | T1-only short grants; non-renewable break-glass | Domain owner + IAM/Risk |
| HD19-15 | Standing capability classes | summary/health/admin drafts may be standing; high-risk JIT; affects operations and review | only fictional summary/health standing | Product Governance + Security/Privacy |
| HD19-16 | Delegation authority/depth | none, one-level realm admin, bounded multi-level; deeper delegation increases hidden inheritance | delegation disabled or one-level T1 negative tests only | IAM Governance + Realm/Product owner |
| HD19-17 | Directory/HR attributes in authorization | none; bounded authoritative attribute; broad dynamic ABAC; correction/outage/privacy complexity grows | none | IAM/Data Governance + Privacy/HR authority |
| HD19-18 | Ticket/case system and binding | exact signed assertion, online lookup, manual reference; availability and tamper properties differ | T1 local fictional assertion; sensitive capability production disabled | Workflow/Case System Owner + IAM/Security |
| HD19-19 | Service identities and workload binding | mTLS, private-key JWT, workload identity; owner/rotation/support required | no production service grant; T1 test credential only | Service IAM + Domain/Application owner |
| HD19-20 | Audit purpose, fields, access, retention, and store | relational ledger, dedicated append store, WORM/object evidence; privacy/cost/search trade-offs | minimum T1 action shell; short fixture retention | Security Governance + Privacy/Records + Data Reliability |
| HD19-21 | Decision logging for high-volume reads/denies | full, sampled, case-bound, finite counters; evidence vs privacy/cost | full for privileged classes; finite aggregate T1 counters for summary reads | Security/SRE + Privacy/Data Governance |
| HD19-22 | Audit reviewer and export access | narrow realm reviewer, product-global security, JIT export; cross-realm/search risks | no production access/export | Security Governance + IAM + Privacy |
| HD19-23 | Authorization/cache/revocation objectives | no cache, short cache, event invalidation + final check; availability/latency trade-off | high-risk authoritative final check; fail closed | Product/SRE/Risk + IAM |
| HD19-24 | IdP/authorization outage policy | terminate all sessions; allow existing low-risk reads; no new privilege; affects continuity | no new login/step-up/JIT/privileged mutation; protected unknown denies | Product/Risk + IAM/SRE |
| HD19-25 | Error disclosure and existence-hiding policy | 403 vs 404, support correlation, timing normalization; usability vs enumeration | generic `ACCESS_NOT_PERMITTED`/route-specific non-enumerating response | API Security + Product/Support |
| HD19-26 | Portal/BFF technology and dependency | built-in ASP.NET Core, Duende BFF, other product; licensing/security/skills differ | built-in minimal prototype; no production dependency selected | Architecture + Platform Engineering + Security/Legal/Procurement |
| HD19-27 | External policy/PIM product | none, reference only, integrated upstream workflow, production PDP; operational and lock-in costs | no external PDP; PIM only future integration signal | Architecture + IAM + Procurement/Security |
| HD19-28 | Accessibility target and testing support | WCAG 2.2 AA target or stricter organizational standard; staffing/tooling needed | design/test high-risk workflows to WCAG 2.2 AA candidate | Product Accessibility + UX/Engineering |
| HD19-29 | Incident, revoke, and recovery ownership | 24/7 vs business hours; realm vs product teams; affects safe JIT/break-glass | high-risk capabilities disabled without named coverage | Security/Operations/Engineering Leadership |
| HD19-30 | Role/grant review cadence and orphan handling | periodic certification, expiry-only, event-driven; cost vs stale access | every grant finite/review-due in T1; no indefinite production assumption | IAM Governance + capability owner |
| HD19-31 | Metric/cardinality/retention budgets | richer labels/search aid operations but increase privacy/cost | fixed finite dimensions only; no realm/principal labels | SRE + Privacy/Data Governance |
| HD19-32 | SLO/RPO/RTO and capacity | decision latency, authorization availability, revoke time, session recovery, audit durability | no production objective claimed | Product/Risk + SRE/Data Reliability |
| HD19-33 | Budget, licensing, staffing, support, training | affects IdP/PIM/BFF/audit/lab/on-call choices | no unapproved production dependency/service | Product/Finance/Procurement/Engineering Leadership |
| HD19-34 | Pilot and production approval | scope, residual risk, legal/privacy consultation, support readiness | T1 synthetic prototypes only | Designated Production/Risk Authority |

## 10.2 Owner questions

1. What exact tasks require portal access, and what is the minimum data/action needed for each?
2. Which tasks may be standing, and which must always be JIT?
3. Which exact purpose and ticket/case authority is valid for detail, diagnostics, export, audit export, deletion, and restore?
4. Which roles must be distinct for drafting, approval, execution, verification, and read enablement?
5. Can enough independent humans be available to satisfy the desired quorum during incidents and out of hours?
6. What is the realm boundary, and is any human product-global authority genuinely necessary?
7. Are delegated realm administrators allowed to assign access, and what subset/depth may they delegate?
8. Which authentication methods and freshness are required for each risk class, including accessibility and recovery consequences?
9. What happens when the IdP, authorization database, invalidation channel, ticket system, or audit store is unavailable?
10. What revocation delay is tolerable for summary reads, detail, export, destructive actions, and background phases?
11. What fields can a detail response or export contain, at what precision, and with what recipient/object controls?
12. Who can query authorization/audit evidence, across which realms, for what purpose, and for how long?
13. Which service identities exist, who owns them, and why can the task not use a human-submitted job envelope instead?
14. What fixed operations must break-glass support, who holds independent authority, and how is every use detected and reviewed?
15. How often are emergency recovery and restore-authority drills performed, and who can declare them passed?
16. Which role/assignment changes require reapproval of active grants?
17. How are leavers, transfers, disabled accounts, contractors, guests, and duplicate identities handled without relying on display names?
18. Which errors may support see without revealing target existence or sensitive policy?
19. What accessibility standard and assistive-technology test set is required for time-limited high-risk workflows?
20. Who can stop and later re-enable a capability after a cross-realm, audit, BFF, or break-glass incident?

---
# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Evidence rules

Every command runs against T1 fictional realms, principals, purposes, tickets, resources, and data. Commands use placeholders for environment-specific endpoints and credentials; actual addresses, users, secrets, identity paths, SSH material, production claims, and personal data are excluded from evidence.

Every experiment emits an immutable manifest with:

```text
experiment ID and exact assertion
source commit/tree and clean-state proof
application/runtime/package/tool/browser/IdP/database versions and hashes
route/capability/role/condition/purpose/approval/output/audit schema digests
fixture root, seed, synthetic realm/persona/resource counts
command/tool identity with secrets and connection details removed
start/end UTC and database clock facts
first failure and all rerun/shrink links
decision, DB, object, job, browser, and audit evidence digests
canary/cardinality results
cleanup/revert receipt
owner/reviewer functions, ADRs, exceptions, and evidence expiry
```

## 11.2 Ordered CLI/lab experiments

| ID | Experiment and command outline | Exact evidence | Pass | Fail/stop |
|---|---|---|---|---|
| E19-00 | **Input and toolchain inventory.** Hash seven allowlisted inputs; `dotnet --info`; package/source locks; browser/IdP/DB test-profile identities | `inputs.sha256`, `environment.json`, dependency/source/binary/license mapping | exact known inputs; supported execution-time versions; no mutable dependency | missing/unallowlisted input, floating/unmapped executable dependency |
| E19-01 | **Catalogue/schema strictness.** `dotnet test --filter Category=AuthzContracts`; official/local strict JSON vectors; invalid capability/action/scope/condition/approval schemas | valid/invalid result matrix, parser limits, allocation/time, schema bundle digest | unknown/duplicate/wildcard/free-form authority rejected | permissive parse, remote reference, unbounded input |
| E19-02 | **Route inventory.** `dotnet run --project tools/Uam.AuthzCheck -- routes --assembly ... --openapi ... --catalogue ...` | executable path list, descriptor diff, handler graph, test links | one descriptor per path; no generic auth fallback | missing/duplicate/inconsistent route or handler |
| E19-03 | **Architecture mutations.** Inject string permission, realm-less repository, UI-only check, IdP-role direct grant, mutation without audit, service/human bypass, dynamic policy | mutation report and reverted clean-tree proof | every forbidden mutation fails build/test | one survives or cleanup leaves diff |
| E19-04 | **Synthetic world generation.** `dotnet run --project tools/Uam.AuthzLab -- generate --seed <T1> --realms 3 --personas provisional --id-collisions cross-realm` | deterministic package twice, lineage/truth/canaries, fictional-only scan | byte-identical canonical roots; exact expected shape | nondeterminism or real/internal value |
| E19-05 | **Reference evaluator/model.** `dotnet test --filter Category=AuthzModel`; exhaustive small domain and generated histories | seeds, minimal counterexamples, law coverage, mutation detection | deny/default, narrowing, realm, approval, time laws hold | any hard counterexample or mutation survivor |
| E19-06 | **Route negative suite.** `dotnet test --filter Category=AuthorizationNegative` | route × test-family matrix and decision ledger | every applicable negative denies; exact positive allows | missing test or unauthorized allow |
| E19-07 | **Realm/deputy campaign.** `dotnet test --filter Category=RealmIsolation`; run API, jobs, caches, exports, deletion, audit/object adapters | realm permutation matrix, row/object/job manifests, canary scan | zero cross-realm effect/disclosure | one cross-realm result |
| E19-08 | **JIT/approval state.** `dotnet test --filter Category=JitApproval`; fake clock and DB time; generated quorum/SoD/request mutations | state ledger, approval-set digest, minimal counterexamples | exact content-bound quorum only; boundary times correct | self/replay/stale/expired approval or grant succeeds |
| E19-09 | **Revocation/cache.** `dotnet test --filter Category=AuthzCacheFaults`; drop/delay invalidation, cache collision, concurrent revoke/final commit | epoch/cache/transaction trace and authoritative comparison | zero stale privileged commit | stale/revoked authority commits |
| E19-10 | **Privileged transaction failpoints.** `dotnet test --filter Category=AuthzAuditFailpoints` | DB snapshots at every boundary, operation reconciliation | old or fully committed state; one mutation/decision/audit | orphan, duplicate, or ambiguous success |
| E19-11 | **OIDC/BFF protocol.** start disposable synthetic provider/BFF; execute code/PKCE/PAR and callback attacks | provider/client profile, transaction results, session generations | exact valid flow only; mix-up/replay/open redirect reject | invalid transaction accepted |
| E19-12 | **Browser token/CSRF/session.** browser automation against same-origin and malicious origin; inspect browser sinks | token canary scan, cookie matrix, CSRF matrix, logout/revoke timeline | zero token escape; zero unsafe cross-site success; session rotation/revoke | any token or CSRF/session failure |
| E19-13 | **Service identities.** test mTLS/private-key JWT candidate, audience/realm/endpoint, rotation/revoke, human-route attempts | credential generation and request matrix | exact service operations only; no human impersonation | wrong audience/realm/human route or revoked credential succeeds |
| E19-14 | **Output minimization.** mutate DTOs, serializers, ORM includes, export fields, error bodies; all-sink canaries | response/object schemas, canary report, field-justification map | every returned field maps to obligation; zero escape | extra field/object or raw value |
| E19-15 | **Break-glass/recovery.** corrupt ordinary assignments/catalogue/IdP path; run fixed recovery CLI with test-only keys | proof matrix, operation trace, independent alert/audit, cleanup | recovery works only with exact proof/profile; expires/revokes | blanket/data access/no alert/no cleanup |
| E19-16 | **Outage and load.** open-arrival synthetic actors; DB/cache/invalidation/IdP/ticket/audit faults; revoke probes | generator proof, outcome/resource/time-series, series bound | no fail-open/cross-realm; bounded resources/cardinality; recovery | hard invariant, hidden offered-load drop, unbounded state |
| E19-17 | **Restore authority.** restore older T1 authz DB with later revokes/epochs; replay current authority; test old sessions/grants | restore transition ledger, epoch/revocation/catalogue/audit digests, probes | no old authority before readiness; current state reconciles | revived grant/session/service/break-glass or gap accepted |
| E19-18 | **Accessibility.** automated static checks plus keyboard/screen-reader/manual workflow scripts for realm, JIT, approval, expiry, error, break-glass | conformance results, task completion/errors, accessible tree snapshots without sensitive data | selected target met; no ambiguous high-risk action | inaccessible or misleading protected workflow |
| E19-19 | **OSS/PDP comparator (optional reference lane).** replay same canonical decisions in a pinned reference engine/model without production dependency | semantic diff, unsupported feature list, resource/dependency evidence | reference agrees on representable subset and helps find defects | reference disagreement unexplained; never use to override UAM oracle automatically |
| E19-20 | **Aggregate gate.** `dotnet run --project tools/Uam.AuthzCheck -- gate --evidence <dir> --catalogue <digest>` | `prompt-19-gate.json` with inputs, first failures, owners, expiry, productionApproved=false | section 9 expression true; required humans recorded | no partial pass or manual override |

## 11.3 Illustrative repository commands

These commands are normative in intent, not fixed filenames/tool versions until the repository scaffold selects them:

```powershell
# Build and strict tests
 dotnet restore --locked-mode
 dotnet build -c Release --no-restore
 dotnet test -c Release --no-build --filter "Category=AuthorizationNegative"
 dotnet test -c Release --no-build --filter "Category=RealmIsolation"
 dotnet test -c Release --no-build --filter "Category=JitApproval|Category=AuthzCacheFaults"
 dotnet test -c Release --no-build --filter "Category=AuthzAuditFailpoints"

# Route and catalogue completeness
 dotnet run -c Release --project tools/Uam.AuthzCheck -- \
   routes --assembly artifacts/Uam.Server.Host.dll \
   --openapi artifacts/openapi.json \
   --catalogue contracts/authz/catalogue.json \
   --output evidence/routes.json

# Deterministic fictional worlds
 dotnet run -c Release --project tools/Uam.AuthzLab -- \
   generate --seed 190019001900 \
   --realms 3 --personas provisional \
   --cross-realm-id-collisions true \
   --output evidence/fixture-a

# Compare a second clean generation
 dotnet run -c Release --project tools/Uam.AuthzLab -- \
   generate --seed 190019001900 \
   --realms 3 --personas provisional \
   --cross-realm-id-collisions true \
   --output evidence/fixture-b

# Evaluate the evidence gate
 dotnet run -c Release --project tools/Uam.AuthzCheck -- \
   gate --evidence evidence/ \
   --catalogue contracts/authz/catalogue.json \
   --output evidence/prompt-19-gate.json
```

Connection values, test client secrets, certificate private keys, browser profile paths, and provider endpoints are supplied through disposable lab configuration and redacted from evidence.

## 11.4 Exact gate artifact

`prompt-19-gate.json` MUST contain:

```text
result = PASS | FAIL | BLOCKED
technical scope and exact release/topology
all input/evidence/catalogue/schema/provider/runtime digests
per-fitness-function status
all first failures and rerun links
cross-realm/unauthorized/output/audit/token/CSRF hard counts
authorization owners and unresolved human decisions
evidence expiry and review triggers
cleanup receipt
implementationPrototypeAuthorized = true/false
productionApproved = false
```

No user-editable `pass` field is accepted. The gate tool recomputes results from content-addressed evidence.

---

# 12. ADR proposals

| ADR | Decision | Proposed status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-P19-001 | Use an in-process typed authorization kernel in the modular monolith | **PROPOSED — ACCEPT FOR PROTOTYPE** | external PDP/service, IdP roles, RLS only | smallest failure domain; composes with final transaction/audit; no measured external need | Authorization Architecture | service split, scale, incident, engine bake-off |
| ADR-P19-002 | Capability RBAC with release-owned closed condition profiles | **PROPOSED — ACCEPT** | pure RBAC, broad ABAC/XACML, general policy language | finite UAM resources/actions plus purpose/target/time needs; tenant only narrows | Authorization Architecture + Privacy | required condition cannot be represented safely |
| ADR-P19-003 | Deny-by-default and no wildcard/general admin | **PROPOSED — ACCEPT** | authenticated-user default, superadmin | primary gate and least privilege | Security Architecture | no ordinary relaxation; only formal baseline change |
| ADR-P19-004 | Realm-first one-active-realm BFF session and explicit product-global plane | **PROPOSED — ACCEPT** | multi-realm session, payload realm, default tenant | reduces confused-deputy/cache risk and preserves accepted realm authority | Realm Security + Portal IAM | proven workflow requires safe multi-realm view |
| ADR-P19-005 | Roles are immutable versioned capability bundles, not authority labels | **PROPOSED — ACCEPT** | mutable role rows, IdP role direct mapping | reproducible review/migration/audit | IAM Governance | role-volume/operations evidence |
| ADR-P19-006 | Sensitive classes use JIT and exact purpose/ticket/target binding | **PROPOSED — ACCEPT PRINCIPLE; HUMAN PROFILE OPEN** | broad standing privilege | reduces exposure; supports detail/export/diagnostic/lifecycle purpose gates | IAM/Product/Privacy | human risk decision or operational evidence |
| ADR-P19-007 | Approvals bind immutable request digest and enforce selected SoD profile | **PROPOSED — ACCEPT MECHANISM; PROFILE OPEN** | informal ticket approval, mutable request | prevents replay/target substitution; human approvers unresolved | Workflow/IAM | workflow/authority decision or incident |
| ADR-P19-008 | Break-glass is fixed recovery-only and disabled by default | **PROPOSED — ACCEPT** | permanent superadmin, normal portal self-activation | contains lockout recovery without general data bypass | Identity Recovery/Security | approved authority/ceremony and passed drills |
| ADR-P19-009 | OIDC confidential-client BFF with server-side tokens, code+PKCE, PAR when supported | **PROPOSED — ACCEPT** | SPA tokens, auth proxy only | current standards/runtime guidance; reduces extraction surface | Portal IAM/Federation | UI topology/IdP interoperability evidence |
| ADR-P19-010 | Cookie-authenticated unsafe routes require antiforgery and side-effect-free safe methods | **PROPOSED — ACCEPT** | SameSite/CORS alone | explicit CSRF boundary | Portal Security | browser/framework change or incident |
| ADR-P19-011 | IdP claims identify subject/authn only; UAM grants remain authoritative | **PROPOSED — ACCEPT** | direct group/role mapping | keeps realm/purpose/target/audit semantics in UAM | IAM Governance | no expected ordinary change |
| ADR-P19-012 | Service identities use exact non-human grants and cannot impersonate/approve | **PROPOSED — ACCEPT** | shared API key, user token delegation by default | purpose separation and revocation | Service IAM | approved delegated-user protocol need |
| ADR-P19-013 | High-risk mutations reauthorize under transaction and write audit atomically | **PROPOSED — ACCEPT** | precheck only, async audit | protects TOCTOU and accepted audit invariant | Data Reliability + Domain Owners | database topology prevents composition; requires change proposal |
| ADR-P19-014 | Cache by realm/principal/generation/epoch; final authoritative check for high risk | **PROPOSED — ACCEPT** | no cache, TTL-only cache | balances performance and revocation safety; values measured | Platform/SRE + IAM | load/revocation objective or incident |
| ADR-P19-015 | Authorization decision/audit schema excludes payload and dynamic values | **PROPOSED — ACCEPT** | full request/claim logging | privacy boundary and cardinality containment | Security Audit + Privacy | defined support/legal evidence need with minimization review |
| ADR-P19-016 | Background jobs use service identity + grant lease and phase reauthorization | **PROPOSED — ACCEPT** | snapshot full user grants at submission | prevents queued authority from outliving JIT/revoke | Job/Workflow Architecture | job semantics prove single atomic phase only |
| ADR-P19-017 | Restore starts authorization read-blocked and reconciles current epochs/revocations | **PROPOSED — ACCEPT** | restore backup and trust old authz state | composes accepted restore invariant | Restore/Data Reliability/IAM | new authoritative recovery substrate |
| ADR-P19-018 | No external PDP/ReBAC/PIM dependency in first slice; reference review only | **PROPOSED — ACCEPT** | OPA, Cedar, OpenFGA, SpiceDB, Cerbos, commercial PIM | no measured need; reduces availability/consistency/operations/licensing surface | Architecture | triggers in section 4.2 |
| ADR-P19-019 | Feature flags/kill switches only narrow or disable | **PROPOSED — ACCEPT** | bypass flags, tenant feature authority | preserves product ceiling and safety | Product/Release/Privacy | no ordinary relaxation |
| ADR-P19-020 | Provisional personas are workshop artefacts only | **PROPOSED — ACCEPT** | infer organization roles or copy legacy names | source evidence does not establish roles/entitlements | Product Governance/IAM | human mapping workshop results |
| ADR-P19-021 | WCAG 2.2 accessible state/approval/expiry behavior is a portal gate candidate | **PROPOSED — HUMAN TARGET OPEN** | accessibility deferred | high-risk workflow correctness and current standard | Accessibility/Product | approved organizational standard and user testing |

No ADR may become `Accepted` while its accountable function is unassigned or its mandatory CLI gate is unpassed.

---

# 13. Ordered implementation backlog with dependencies and stop gates

| Order | Backlog item | Depends on | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | Record Prompt 19 evidence manifest and ADR placeholders | allowlisted inputs | hashes, authority boundary, owner placeholders | changed/missing/unallowlisted input |
| 2 | Assign engineering owner functions for authorization, portal IAM, realm, audit, workflow, service IAM, recovery, testing | leadership decision | owner/escalation matrix | blocking owner `UNASSIGNED` |
| 3 | Add authorization projects and architecture boundaries | Batch 01 repository baseline | `Uam.Authorization.Model`, `.Evaluator`, `.Contracts`, `.TestOracle`, `.Tools`; no UI/ORM/network in evaluator | forbidden dependency/API mutation survives |
| 4 | Define strict resource/action/scope/condition/response/audit enums and schemas | 3 | contract bundle, valid/invalid vectors | wildcard/free-form/unknown accepted |
| 5 | Build route/handler inventory and descriptor checker | 3–4 | build/startup completeness tool | any executable path unclassified |
| 6 | Implement pure reference evaluator and independent model oracle | 4 | deterministic decisions, laws, mutation suite | default/narrowing/realm counterexample or common decision code |
| 7 | Generate deterministic fictional realms/personas/resources/purposes/tickets | 4–6 | T1 fixture package with cross-realm ID collisions and canaries | nondeterminism or real value |
| 8 | Implement realm-first typed repositories and target resolvers for a minimal route set | 5–7 | summary/policy/detail/export/deletion/audit/authz test modules | realm-less overload or cross-realm result |
| 9 | Implement capability catalogue and role-template revision store | 4–8 | immutable definitions, diffs, lifecycle | semantic edit in place or unknown allow |
| 10 | Implement principal, assignment, scope-manifest, grant, and epoch stores | 6–9 | standing/delegated grant model; no production assignment | self/delegation broadening or epoch flaw |
| 11 | Implement JIT request, approval, SoD, activation/revocation | 6, 9–10 | state machines and fake-clock tests | approval replay/self/expiry/revoke failure |
| 12 | Implement decision/result obligations and output-field profiles | 6, 8–11 | query/serialization shaping, canary tests | extra field/object escape |
| 13 | Implement mutation transaction guard and durable audit linkage | 8–12, Batch 04 transaction boundary | failpoint-tested atomicity | mutation without audit/decision |
| 14 | Implement background job grant lease/phase authorization | 10–13 | export/deletion/release synthetic job tests | job phase after expiry/revoke or wrong realm |
| 15 | Build minimal ASP.NET Core OIDC BFF with synthetic provider | 3–6 | confidential-client code+PKCE/PAR candidate, server session | token exposure or invalid transaction accepted |
| 16 | Add cookie/session/CSRF/logout/realm-switch browser tests | 15 | P19-04 evidence | cross-site success, fixation, revoke gap |
| 17 | Implement service-identity context and narrow grants | 4–14 | mTLS/private-key JWT candidate tests | human impersonation/wrong audience/realm |
| 18 | Implement cache keyed by generation/epoch and authoritative final checks | 10–17 | revocation/cache fault evidence | stale privileged commit |
| 19 | Implement privacy-safe metrics, decision schema, canary/cardinality gates | 5–18 | closed catalogue and all-sink evidence | dynamic label or forbidden value |
| 20 | Implement disabled break-glass state/model and fixed T1 recovery CLI | 4, 6, 10–13 | recovery prototype with test-only keys | blanket/data access/no expiry/alert |
| 21 | Run human role/purpose/approval/break-glass mapping workshop | technical catalogue ready | signed decision inputs; no automatic assignment | unresolved purpose/authority means capability stays disabled |
| 22 | Integrate selected enterprise IdP in isolated lab | 15–16, human IdP profile | exact interoperability/logout/authn-class evidence | unclassified provider behavior or token/session failure |
| 23 | Run outage/load/cardinality and restore-authority campaigns | 13–22 | P19-07/P19-17 evidence | hard invariant or unbounded state |
| 24 | Run accessibility and blind operational/support exercises | UI/workflows and human target | keyboard/status/expiry/recovery/support scorecards | unsafe/inaccessible workflow or undefined support owner |
| 25 | Reconcile OSS/dependency candidates and production choice | 15–24 | admission records, license/TCO/security comparison | unapproved dependency/license/provenance |
| 26 | Aggregate P19 gate | 1–25 | `prompt-19-gate.json`, ADR and owner review | any hard failure/missing evidence/owner/cleanup |
| 27 | Enable one T1 portal prototype slice | P19-AGG technical pass and lab authority | fictional summary plus selected governance workflow | any real data/identity/purpose or production claim |
| 28 | Prepare Batch 05 reviewer package with Prompts 20–21 | accepted topic outputs | contradictions/gates/evidence manifest | do not treat this topic result as final batch acceptance |

## 13.1 Parallelism and stop rules

After schemas exist, the pure evaluator/model, route inventory, fictional data generator, BFF protocol prototype, and OSS reference review may proceed in parallel.

The following MUST NOT proceed early:

- UI role assignment before capability/route/realm contracts and human mapping;
- real IdP groups as grants before governed assignment integration;
- sensitive output/query code before response profiles and field canaries;
- JIT activation before approval digest/SoD/time model;
- privileged mutation before transaction/audit failpoints;
- background export/deletion/release execution before grant-lease reauthorization;
- break-glass activation before independent authority/monitoring and passed T1 drill;
- production access or real data before the eventual Batch 05 review and all human approvals.

A failure of route completeness, cross-realm isolation, output minimization, mutation/audit atomicity, BFF token/CSRF boundary, JIT revocation, or break-glass boundedness stops every dependent item. It does not authorize a weaker undocumented fallback.

---
# 14. Open-source repository assessment table

## 14.1 Assessment method

**FACT.** The repositories below were reviewed as design evidence at immutable releases or commits current to 1 August 2026. Popularity, a project's own security claims, or a passing upstream test suite is not UAM fitness. Each entry was assessed against the Prompt 19 boundary: typed capability authorization, realm isolation, purpose/target/time conditions, JIT workflow, BFF session security, revocation, durable audit, and zero-tolerance cross-realm testing.

**RECOMMENDATION.** The initial UAM implementation should depend on the supported ASP.NET Core security primitives already implied by the accepted .NET family, subject to exact-version admission. It should not add a general external policy, relationship-graph, JIT-infrastructure, or authentication-proxy service for the first slice. The remaining projects are references or future bake-off candidates, not approved dependencies.

| Repository and relevant files/directories | Exact revision reviewed | License and compatibility concern | Maintenance, tests, and security posture | Similarity to UAM and threat-model difference | Reusable ideas | Ideas that MUST NOT be copied | Suitability |
|---|---|---|---|---|---|---|---|
| [ASP.NET Core](https://github.com/dotnet/aspnetcore/tree/v10.0.10), especially [`src/Security/Authentication`](https://github.com/dotnet/aspnetcore/tree/v10.0.10/src/Security/Authentication), [`src/Security/Authorization`](https://github.com/dotnet/aspnetcore/tree/v10.0.10/src/Security/Authorization), and [`src/Antiforgery`](https://github.com/dotnet/aspnetcore/tree/v10.0.10/src/Antiforgery) | `v10.0.10`, released 15 July 2026, tag commit shown as `2adedfc` [W35–W37] | MIT for the repository; transitive/runtime notices still require the accepted dependency manifest. Exact supported patch is execution evidence, not architecture. | Microsoft-maintained supported runtime line with extensive unit/integration tests, security servicing, source, issue, and advisory processes. Framework correctness does not prove UAM route completeness, realm binding, purpose semantics, or transaction/audit composition. | Directly matches the C#/.NET BFF, cookie, OIDC, authorization-handler, and antiforgery implementation family. ASP.NET Core authorization is a framework mechanism; it does not provide UAM's resource/action catalogue, realm model, JIT states, or data-shaping obligations. | Confidential-client OIDC handlers, cookie/session primitives, antiforgery validation, policy/handler composition, test-host/browser integration patterns, secure defaults made explicit in code. | Do not map generic claims or IdP roles directly to UAM authority; do not depend on endpoint attributes alone without target loading and realm checks; do not use framework success as durable-audit proof. | **DEPENDENCY CANDIDATE / EXPECTED PLATFORM PRIMITIVE**, after exact package/runtime/source admission, security review, provider interoperability, and UAM negative tests. |
| [Open Policy Agent](https://github.com/open-policy-agent/opa/tree/1e32c796e8979b1bda2f768138500b1deb95ff24), especially `ast/`, `rego/`, `topdown/`, `compile/`, `plugins/logs/`, `server/`, and `tester/` | `v1.19.0`, commit `1e32c796e8979b1bda2f768138500b1deb95ff24`, released 30 July 2026 [W23] | Apache-2.0. Embedding or operating it adds Go/WASM/runtime, bundle, configuration, decision-log, and policy-language supply-chain surfaces. | Very active, broad unit/integration/benchmark/conformance coverage and a security policy. The reviewed release fixed a Compile API SQL-injection vector and tightened language safety, demonstrating both active maintenance and the risk of translating policy into query logic. | Strong general-purpose attribute/policy evaluation and decision logging. UAM's first model is deliberately smaller: release-owned finite conditions, no tenant-authored Rego, no external data fetch, and high-risk decisions inside the modular-monolith transaction. | Policy corpus testing, deterministic evaluation, decision IDs, config validation, bundle versioning, fuzz/property ideas, explicit unknown/error handling, mutation tests against partial evaluation. | Do not expose Rego or arbitrary built-ins to tenants; do not generate SQL filters as the sole row boundary; do not add an online PDP/bundle service before measured need; do not permit external data or unbounded decision logs. | **REFERENCE ONLY** for the first slice. A later dependency/service bake-off requires parity on UAM semantics, outage/revocation, licensing/operations, and total assurance cost. |
| [Cedar](https://github.com/cedar-policy/cedar/tree/fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5), especially `cedar-policy-core/`, `cedar-policy-validator/`, `cedar-policy-formatter/`, `cedar-policy-cli/`, `cedar-policy-symcc/`, `cedar-policy/`, and `cedar-wasm/` | `v4.12.0`, commit `fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5`, released 28 July 2026 [W24] | Apache-2.0 with repository notices. A Rust/WASM evaluator would add a second implementation/runtime family and FFI or service boundary. | Active releases, dedicated parser/validator/evaluator tests, symbolic-analysis tooling, dependency controls, and security reporting. The reviewed release adds stricter malformed-input/duplicate-ID rejection and partial-evaluation inspection. | Close conceptual match to principal/action/resource authorization with schemas and explicit permit/forbid semantics. UAM additionally requires authenticated realm authority, purpose/ticket conditions, output obligations, workflow state, transaction-audit atomicity, and lifecycle composition. | Closed schema design, explicit action/resource typing, forbid precedence, validation before activation, counterexample/symbolic analysis, policy-diff and corpus generation ideas. | Do not import an unrestricted policy language, entity graph, extensions, or partial-evaluation result as a database filter without independent realm/data-shaping checks; do not make a Rust engine an unreviewed mandatory runtime. | **REFERENCE AND OPTIONAL TEST COMPARATOR**. Not an initial runtime dependency. |
| [OpenFGA](https://github.com/openfga/openfga/tree/69efbd95b3d44afb2e2567d485dcc792c7d79e3f), especially `internal/graph/`, `internal/condition/`, `pkg/server/`, `pkg/storage/`, `tests/`, and `cmd/` | `v1.18.1`, commit `69efbd95b3d44afb2e2567d485dcc792c7d79e3f`, released 29 June 2026 [W25] | Apache-2.0. A deployment adds a relationship store, consistency model, APIs, migration, backup/restore, telemetry, and operational ownership. | Active, broad tests and release automation; release artefacts include modern provenance/SBOM practices. The reviewed release contains diagnostic comparison of future graph algorithms and deterministic model serialization work, which is relevant to compatibility discipline. | Strong for fine-grained relationship-based authorization and multi-tenant stores. UAM first-slice relationships are shallow and typed; UAM must also bind purpose, ticket, JIT lifecycle, exact output profile, durable audit, and current realm/lifecycle state. | Tuple-model conformance tests, model versioning, deterministic serialization, consistency-token thinking, recursive-graph adversarial tests, cross-store tenant tests. | Do not create a second authorization datastore/source of truth; do not rely on eventual relationship propagation for high-risk commits; do not model purpose or approval as free-form tuples; do not infer realm from a store/body identifier. | **REFERENCE ONLY**. Reconsider only if real relationship depth/volume exceeds the typed relational model and a measured prototype passes restore, consistency, revocation, realm, and TCO gates. |
| [SpiceDB](https://github.com/authzed/spicedb/tree/8422483147151728d39c47b439b5ed8090966d48), especially `internal/graph/`, `internal/caveats/`, `pkg/schema/`, `internal/services/`, `internal/datastore/`, and `pkg/embedded/` | `v1.56.0`, commit `8422483147151728d39c47b439b5ed8090966d48`, released 24 July 2026 [W26] | Apache-2.0. Server mode adds gRPC, datastore, consistency-token, dispatch, cache, schema, and operational surfaces; embedded mode still adds a large Go engine and datastore semantics. | Active releases, integration tests, multiple datastore suites, security reporting, and explicit performance/consistency work. The reviewed release added an embedded package, caveat caching by schema revision, test-container migration, and concurrency fixes. | Rich ReBAC with caveats and consistency controls. UAM's ABAC conditions are intentionally closed and not a general CEL/caveat language; UAM also requires transaction-local final checks and output obligations. | Consistency/freshness vocabulary, caveat/schema version pinning, relationship-graph property tests, debug-vs-production path separation, cache invalidation tests, bulk-check adversarial cases. | Do not expose CEL/caveats to tenant authors; do not accept a remote check as the sole authority for a destructive transaction; do not let consistency tokens replace UAM grant epochs or durable audit. | **REFERENCE ONLY** for initial work; possible future bake-off if graph complexity and shared authorization-service economics are demonstrated. |
| [Cerbos](https://github.com/cerbos/cerbos/tree/6b40a5f9fa6305a7014a8ea274afefaaa7771679), especially `internal/engine/`, `internal/compile/`, `internal/audit/`, `cmd/cerbos/`, `schema/`, `test/`, and `hack/loadtest/` | `v0.54.0`, commit `6b40a5f9fa6305a7014a8ea274afefaaa7771679`, released 20 July 2026 [W27] | Apache-2.0. Adds Go binaries/sidecar or embedded PDP, YAML/CEL policy, bundle/Hub options, audit formats, and operational/configuration ownership. | Active release, E2E tests, parser/compiler work, load/performance regression tests, security dependency updates, and audit features. The reviewed release also exposes options that would be unsafe if copied blindly, such as disabling TLS verification for a Hub client. | Resource/action/role policies and derived outputs resemble part of UAM's model. UAM needs a smaller release-owned grammar, no tenant expressions, strict realm derivation, and database/audit transaction composition. | Policy compile-before-activate, structured outputs/obligations, performance-regression tests, parser-error stability, bundle identity, audit schema testing. | Do not copy general YAML/CEL authoring, remote policy distribution, TLS-verification bypass, role-name authority, or sidecar availability dependency into the first slice. | **REFERENCE ONLY / LATER BAKE-OFF CANDIDATE**. |
| [Teleport](https://github.com/gravitational/teleport/tree/ddaa46b8f4ee579d43480cd2d3b6a14b18e3ef7d), especially access-request, role, certificate, audit, session, and Web UI test areas under `lib/`, `api/`, `tool/`, and `web/` | `v18.10.0`, commit `ddaa46b8f4ee579d43480cd2d3b6a14b18e3ef7d`, released 9 July 2026 [W28] | Mixed licensing at this revision: the repository license distinguishes Apache-2.0 portions such as `api/` from AGPL/commercially governed portions and distribution terms [W29]. Legal review is mandatory before any use beyond reference. | Very active large security product with substantial tests, release notes, security fixes, short-lived credential/access-request workflows, and operational complexity. The reviewed release includes stricter role/request validation fixes, which reinforces fail-closed authoring needs. | Strong JIT infrastructure access, request/reviewer workflow, short credentials, session/audit, and emergency operations. Threat model is infrastructure/session brokering across many protocols, not UAM privacy-sensitive portal data and domain transactions. | Access-request state names, short-lived activation, review expiry, reviewer constraints, alerting, session revocation, recovery drills, immutable request snapshot, UI status patterns. | Do not copy the proxy/cluster/certificate/session-recording architecture, wildcard role expressions, broad infrastructure roles, or mixed-license code into UAM. Do not infer that infrastructure JIT solves UAM purpose/output/lifecycle authorization. | **REFERENCE ONLY; NOT AN INITIAL DEPENDENCY**. |
| [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy/tree/66b3a17db09f0b51a4bc3159d4c7fe3fbeca1288), especially `oauthproxy.go`, `pkg/apis/sessions/`, `providers/`, `middleware/`, `integration_tests/`, and `contrib/` | `v7.15.3`, commit `66b3a17db09f0b51a4bc3159d4c7fe3fbeca1288`, released 9 June 2026 [W30] | MIT. Still introduces a separate reverse-proxy, provider configuration, cookie/session format, header trust, and upgrade/operations boundary. | Active, integration tests, security/advisory process, and frequent dependency/security updates. The reviewed release explicitly addresses multiple vulnerabilities, so exact-version and provider/session testing are essential. | Provides authentication proxying and session/header forwarding, not UAM's BFF or domain authorization. Its boundary can be useful as hostile reference for header spoofing, cookie/session, provider, and redirect tests. | Provider interoperability corpus, session-cookie rotation tests, redirect/header sanitization, reverse-proxy negative tests, deployment hardening checklist. | Do not treat authenticated upstream headers as UAM realm/capability authority; do not expose browser tokens; do not use the proxy as the complete BFF or authorization layer; do not enable broad email/domain/group admission as portal permission. | **REFERENCE ONLY**. A separate auth proxy is not required for the first slice. |
| [Duende BFF](https://github.com/DuendeSoftware/products/tree/de013a7802cb49e7584eeebcabb1a9d511ccef8c/bff), especially `src/`, `test/`, `hosts/`, `templates/`, `migrations/`, and `performance/` | BFF `4.2.0` source point represented by commit `de013a7802cb49e7584eeebcabb1a9d511ccef8c`, 10 June 2026 review point [W31–W34] | Source-available/commercial: development/testing is permitted by the published terms, but production use generally requires a paid license; Community Edition eligibility is conditional [W32, W34]. Procurement and Legal approval are mandatory. | Dedicated BFF framework with source, integration/performance tests, server-side sessions, token management, logout notifications, endpoint protection, and private security reporting/support. Commercial support may reduce implementation burden but does not replace UAM tests. | Very close to the proposed confidential-client BFF boundary. It does not provide UAM capabilities, realm isolation, JIT, approval, break-glass, target resolution, or durable mutation audit. | Server-side session/token patterns, logout/back-channel handling, anti-CSRF endpoint patterns, session management, provider integration tests, token forwarding minimization, performance harness. | Do not let generic BFF endpoint protection stand in for domain authorization; do not enable arbitrary remote API forwarding; do not assume a commercial license or product fit; do not copy source without license compliance. | **COMMERCIAL DEPENDENCY CANDIDATE OR REFERENCE**, to compare against a small native ASP.NET Core implementation using security, maintenance, skills, support, licensing, and TCO evidence. |

## 14.2 Dependency decision gate

A repository can move from reference to candidate only when an admission record proves all of the following:

1. exact tag/commit, package/image/binary digest, source mapping, licence and notices;
2. supported runtime and maintenance horizon aligned with the selected UAM release;
3. security policy/advisory review and no unresolved relevant critical issue;
4. deterministic configuration/policy inputs and strict unknown-field behavior;
5. positive and negative UAM conformance, cross-realm, purpose, JIT, revocation, cache, outage, restore, and audit tests;
6. no increase in authority: tenant input still cannot add code, expressions, external data, destination, wildcard, or bypass;
7. failure containment, upgrade/rollback, backup/restore, incident response, observability, and complete cleanup;
8. skills, on-call, licensing, procurement, data residency, support, and three-year cost evidence;
9. a removal/migration path that does not rewrite capability or audit meaning;
10. evidence that the candidate lowers total defect and operational risk compared with the in-process typed evaluator.

**RECOMMENDATION.** Until such a record passes, the only expected security dependency surface is the admitted ASP.NET Core/.NET stack and the selected enterprise OIDC provider integration. The UAM authorization semantics, catalogue, evaluator oracle, state machines, and tests remain UAM-owned.

---
# 15. Source register with stable links, dates, reviewed versions, claims, and limitations

## 15.1 Supplied project evidence

**FACT.** All seven allowlisted project files were present. No other Project file was opened, searched, quoted, summarized, or used. Local suffixes are recorded where they differed from the logical filename.

| Ref | Allowlisted logical file / reviewed local file | SHA-256 | Project claim supported | Limitation |
|---|---|---|---|---|
| P01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Accepted endpoint/server architecture, realm/session isolation, durable privileged audit, restore/deletion invariants, telemetry limitations, and human-decision boundary. | Condensed working baseline dated 31 July 2026; not runtime, legal, support, or production proof. |
| P02 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | Accepted relational modular-monolith/control API posture, no-broker default, ordered proof gates, and stop-on-failure rule. | Curated synthesis; values and downstream portal details remain provisional. |
| P03 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence labels, current-primary-source requirements, human authority, sanitization, conflict/change-proposal discipline. | Governs evidence quality; it is not evidence that a technical claim is true. |
| P04 | `batch-01-review-result.md` / local `batch-01-review-result(3).md` | `10d5e1e73fa7e63156d29b7cff238ea7d4e128587b47f4c75b` | Strict contracts, UUIDv7, realm-first authorization context, privacy ceiling, application identity, repository boundaries, control-artifact rules, and durable privileged audit invariant. | Accepted foundation architecture with mandatory gates; no organizational role mapping or production authorization. |
| P05 | `batch-02-review-result.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Source/privacy boundary, minimized first slice, interpretation separation, exact realm/session authority, whole-page transaction handoff, and privacy-safe observability. | Endpoint source/privacy result; does not approve portal access, event fields, identity, purpose, or live data. |
| P06 | `batch-03-review-result.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Per-installation identity, authenticated server context, control-artifact/cache separation, release authorization, diagnostics boundaries, exact compatibility, and engineering-canary gates. | Architecture accepted with open gates; no IdP, PKI, diagnostics backend, support, platform, or production approval. |
| P07 | `batch-04-review-result.md` / local `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Modular-monolith server, durable relational transactions, realm-first data keys, immutable audit/custody, lifecycle barriers, background work, restore read blocking, and truthful external status. | Implementation-prototype baseline with all Batch 04 gates open; production database, capacity, retention, deletion, restore, export, and endpoint cleanup remain unapproved. |

## 15.2 Current public standards and official product documentation

All public sources were reviewed on 1 August 2026. “Documented capability” below is not a claim that UAM has implemented or passed it.

| Ref | Stable source and source/release date | Reviewed version or scope | Claim supported | Limitation |
|---|---|---|---|---|
| W01 | [IETF OAuth 2.0 for Browser-Based Applications](https://datatracker.ietf.org/doc/draft-ietf-oauth-browser-based-apps/), revision dated 6 July 2026; Datatracker last updated 17 July 2026 | `draft-ietf-oauth-browser-based-apps-27` | Current browser-OAuth threat analysis; BFF pattern; malicious-JavaScript/token-extraction risks; Authorization Code + PKCE direction. | Internet-Draft/work in progress in the RFC Editor queue, not yet a final RFC; provider/browser/UAM fitness still requires tests. |
| W02 | [RFC 9700, Best Current Practice for OAuth 2.0 Security](https://www.rfc-editor.org/info/rfc9700/), January 2025 | BCP 240 / RFC 9700 | Current OAuth security baseline: avoid deprecated flows, bind authorization responses, protect redirects/tokens, use modern client practices. | General OAuth BCP; does not define UAM authorization, realm, JIT, audit, or session duration. |
| W03 | [Microsoft: Configure OpenID Connect Web authentication in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/configure-oidc-web-authentication?view=aspnetcore-10.0), updated 22 January 2026 | ASP.NET Core 10.0 documentation | Confidential interactive client, code flow + PKCE, PAR when provider supports it, fallback authorization policy, server-side BFF recommendation, PII logging warning. | Documentation/sample, not a complete secure UAM configuration; examples must be narrowed and tested against the selected IdP. |
| W04 | [Microsoft: Map, customize, and transform claims in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/claims?view=aspnetcore-10.0), reviewed 1 August 2026 | ASP.NET Core 10.0 documentation | Claims mapping/transformation capability and distinction between identity claims and application authorization semantics. | Provider claims can be stale, over-broad, or ambiguous; UAM does not accept role/group claims as direct authority. |
| W05 | [OpenID Connect RP-Initiated Logout 1.0](https://openid.net/specs/openid-connect-rpinitiated-1_0.html), final 12 September 2022 | Final 1.0 | RP-initiated logout parameters and provider interaction. | Logout support and semantics vary by provider; does not guarantee immediate UAM grant/session revocation. |
| W06 | [OpenID Connect Back-Channel Logout 1.0 incorporating errata set 1](https://openid.net/specs/openid-connect-backchannel-1_0.html), 15 December 2023 | Final 1.0 + errata | Server-to-server logout notification model and session identifiers. | Optional provider capability; delivery can fail and does not replace UAM session/epoch expiry and revocation checks. |
| W07 | [OpenID Connect Core 1.0 incorporating errata set 2](https://openid.net/specs/openid-connect-core-1_0.html), 15 December 2023 | OIDC Core 1.0 | ID Token validation, issuer/audience/nonce/session/claims concepts, authorization code flow. | Broad protocol specification; provider profile and implementation behavior require interoperability testing. |
| W08 | [RFC 7636, Proof Key for Code Exchange](https://www.rfc-editor.org/info/rfc7636/), September 2015 | RFC 7636 | PKCE challenge/verifier mechanism against authorization-code interception. | PKCE is one control; it does not prevent XSS, CSRF, session fixation, malicious redirects, or authorization defects. |
| W09 | [RFC 9126, OAuth 2.0 Pushed Authorization Requests](https://www.rfc-editor.org/info/rfc9126/), September 2021 | RFC 9126 | PAR protects authorization request parameters at a back-channel endpoint and reduces front-channel manipulation. | Provider support/configuration differs; UAM must test fallback/required behavior and cannot assume PAR universally. |
| W10 | [RFC 8705, OAuth 2.0 Mutual-TLS Client Authentication and Certificate-Bound Access Tokens](https://www.rfc-editor.org/info/rfc8705/), February 2020 | RFC 8705 | mTLS client authentication and sender-constrained access-token profile for service identities/gateways. | Does not define UAM realm/capability mapping, certificate lifecycle, proxy behavior, or operations fitness. |
| W11 | [RFC 7523, JWT Profile for OAuth 2.0 Client Authentication and Authorization Grants](https://www.rfc-editor.org/info/rfc7523/), May 2015 | RFC 7523 | Private-key/JWT client assertion mechanism for confidential service clients. | Replay, key, issuer/audience, clock, rotation, and registration profiles remain UAM/IdP decisions and tests. |
| W12 | [RFC 9396, OAuth 2.0 Rich Authorization Requests](https://www.rfc-editor.org/info/rfc9396/), May 2023 | RFC 9396 | Structured authorization details can bind type-specific requested authority. | Not required for the first UAM BFF; does not replace UAM's internal capability/JIT/approval state or grant final resource authority. |
| W13 | [NIST SP 800-63B-4, Authentication and Authenticator Management](https://csrc.nist.gov/pubs/sp/800/63/b/4/final), final 31 July 2025 | SP 800-63B-4 | Authentication assurance, authenticator lifecycle, phishing-resistant/strong authentication considerations for high-risk activation/recovery. | US federal guidance; organizational assurance target and IdP implementation remain human decisions. |
| W14 | [NIST SP 800-63C-4, Federation and Assertions](https://csrc.nist.gov/pubs/sp/800/63/c/4/final), final 31 July 2025 | SP 800-63C-4 | Federation/assertion assurance, relying-party and identity-provider relationships. | Does not define UAM capabilities, realm mappings, or legal/business authorization. |
| W15 | [NIST SP 800-162, Guide to ABAC Definition and Considerations](https://csrc.nist.gov/pubs/sp/800/162/upd2/final), updates through 2 August 2019 | SP 800-162 update 2 | ABAC evaluates subject, object, operation, and environmental attributes; supports the limited-condition model. | General model; broad ABAC can create policy complexity, stale attributes, hidden authority, and difficult review. |
| W16 | [NIST Role-Based Access Control FAQ](https://csrc.nist.gov/projects/role-based-access-control/faqs), page reviewed 1 August 2026 | NIST RBAC project material | Roles as permission collections, role activation, constraints, static/dynamic separation of duty, and distinction from ordinary groups. | Historical/project guidance, not a UAM implementation standard or organizational role source. |
| W17 | [NIST SP 800-53 Rev. 5, Security and Privacy Controls](https://csrc.nist.gov/pubs/sp/800/53/r5/upd1/final), update 1 final 10 December 2020 with current CSRC errata/resources | AC/AU/IA/IR control families | Control themes for least privilege, separation of duties, privileged functions, audit, identification/authentication, and incident response. | Control catalogue, not a direct product design or compliance conclusion; applicability is a human governance decision. |
| W18 | [Microsoft Entra Privileged Identity Management overview](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-configure), updated 23 April 2026 | Current Entra PIM documentation | JIT/eligible vs active assignments, time bounds, approval, MFA, justification, notifications, access reviews, audit. | Microsoft cloud service and licence; does not authorize UAM roles or guarantee UAM target/purpose/audit semantics. |
| W19 | [Microsoft Entra PIM role settings](https://learn.microsoft.com/en-us/entra/id-governance/privileged-identity-management/pim-how-to-change-default-settings), updated 23 April 2026 | Current Entra PIM documentation | Activation maximum duration, authentication context, justification, ticket field, approval, assignment duration, notification, lockout risks. | Ticket number is information-only unless UAM verifies it; Entra activation controls can persist beyond the activation browser/device; exact UAM final checks are still required. |
| W20 | [W3C Web Content Accessibility Guidelines 2.2](https://www.w3.org/TR/WCAG22/), W3C Recommendation 5 October 2023 | WCAG 2.2 | Accessible keyboard, focus, status, error, authentication, and interaction design target for sensitive workflows. | The organizational conformance level and audit method are human decisions; specification text does not prove UAM UI conformance. |
| W21 | [W3C Understanding Success Criterion 4.1.3: Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html), WCAG 2.2 supporting guidance | SC 4.1.3 guidance | Approval, expiry, denial, revocation, and recovery status changes should be programmatically exposed without forcing focus. | Supporting guidance, not a complete accessibility test plan; assistive-technology/user testing remains required. |
| W22 | [Microsoft Entra emergency access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access), updated 5 June 2026 | Current Entra emergency-access guidance | Need for independently monitored recovery access, multiple recovery authorities/accounts, testing, alerting, and use only during lockout/outage. | Entra's Global Administrator emergency model is much broader than acceptable UAM break-glass; UAM must remain fixed-purpose and data-minimized. |

## 15.3 Open-source and implementation source register

| Ref | Stable source and release date | Reviewed version/commit | Claim supported | Limitation |
|---|---|---|---|---|
| W23 | [Open Policy Agent v1.19.0](https://github.com/open-policy-agent/opa/releases/tag/v1.19.0), released 30 July 2026 | `v1.19.0`, commit [`1e32c796e8979b1bda2f768138500b1deb95ff24`](https://github.com/open-policy-agent/opa/tree/1e32c796e8979b1bda2f768138500b1deb95ff24) | Active general policy engine; tests/config/decision-log patterns; reviewed release fixed Compile API SQL injection and tightened safety. | General Rego/external-data/partial-evaluation architecture is broader than UAM and introduces new runtime/service risks. |
| W24 | [Cedar v4.12.0](https://github.com/cedar-policy/cedar/releases/tag/v4.12.0), released 28 July 2026 | `v4.12.0`, commit [`fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5`](https://github.com/cedar-policy/cedar/tree/fdcbaed32bdb8c8d13e4eaf2b58db5555e9fb8c5) | Typed principal/action/resource policies, schema validation, forbid/permit semantics, symbolic/counterexample tooling. | Does not supply UAM realm/purpose/JIT/output/audit composition and would add Rust/WASM or service integration. |
| W25 | [OpenFGA v1.18.1](https://github.com/openfga/openfga/releases/tag/v1.18.1), released 29 June 2026 | `v1.18.1`, commit [`69efbd95b3d44afb2e2567d485dcc792c7d79e3f`](https://github.com/openfga/openfga/tree/69efbd95b3d44afb2e2567d485dcc792c7d79e3f) | Relationship-model versioning, deterministic serialization, graph/conformance/consistency testing practices. | Adds a second datastore/service and relationship consistency model; no automatic UAM fitness. |
| W26 | [SpiceDB v1.56.0](https://github.com/authzed/spicedb/releases/tag/v1.56.0), released 24 July 2026 | `v1.56.0`, commit [`8422483147151728d39c47b439b5ed8090966d48`](https://github.com/authzed/spicedb/tree/8422483147151728d39c47b439b5ed8090966d48) | ReBAC, caveats, consistency/cache concepts, embedded/server alternatives, concurrency and datastore tests. | Caveat/CEL and distributed graph semantics are broader than the closed UAM condition model; operations and restore burden are material. |
| W27 | [Cerbos v0.54.0](https://github.com/cerbos/cerbos/releases/tag/v0.54.0), released 20 July 2026 | `v0.54.0`, commit [`6b40a5f9fa6305a7014a8ea274afefaaa7771679`](https://github.com/cerbos/cerbos/tree/6b40a5f9fa6305a7014a8ea274afefaaa7771679) | Resource policies, outputs, compile/bundle/audit patterns, parser/load/performance tests. | General YAML/CEL/sidecar/Hub architecture; some configurable capabilities, such as TLS-verification disablement, are explicitly unsuitable for UAM defaults. |
| W28 | [Teleport 18.10.0](https://github.com/gravitational/teleport/releases/tag/v18.10.0), released 9 July 2026 | `v18.10.0`, commit [`ddaa46b8f4ee579d43480cd2d3b6a14b18e3ef7d`](https://github.com/gravitational/teleport/tree/ddaa46b8f4ee579d43480cd2d3b6a14b18e3ef7d) | Mature JIT access requests, short-lived credentials, session/audit, reviewer constraints, and validation/incident lessons. | Infrastructure access product with a much larger proxy/cluster/protocol threat model; not a UAM portal dependency recommendation. |
| W29 | [Teleport repository licence at v18.10.0](https://github.com/gravitational/teleport/blob/v18.10.0/LICENSE), reviewed 1 August 2026 | `v18.10.0` | Mixed repository/distribution licensing must be understood before reuse; `api/` and other portions differ from the whole product. | Legal interpretation belongs to Legal/Procurement; this research makes no licence approval. |
| W30 | [oauth2-proxy v7.15.3](https://github.com/oauth2-proxy/oauth2-proxy/releases/tag/v7.15.3), released 9 June 2026 | `v7.15.3`, commit [`66b3a17db09f0b51a4bc3159d4c7fe3fbeca1288`](https://github.com/oauth2-proxy/oauth2-proxy/tree/66b3a17db09f0b51a4bc3159d4c7fe3fbeca1288) | Auth-proxy provider/session/header/redirect tests and evidence that exact security servicing matters. | Authentication proxy, not BFF/domain authorization; upstream headers cannot become UAM authority. |
| W31 | [Duende BFF documentation](https://docs.duendesoftware.com/bff/), updated/reviewed 23 April 2026 | BFF 4.x documentation | BFF architecture, server-side tokens/sessions, endpoint protection, logout and token-management patterns. | Product documentation; exact UAM provider/session/security behavior needs an isolated bake-off. |
| W32 | [Duende licensing documentation](https://docs.duendesoftware.com/general/licensing/), reviewed 1 August 2026 | Current licensing terms | Production use normally requires a licence, with conditional Community Edition. | No legal/procurement approval or eligibility conclusion is made. |
| W33 | [Duende BFF server-side session documentation](https://docs.duendesoftware.com/bff/fundamentals/session/), updated/reviewed 23 April 2026 | BFF 4.x | Server-side session state, management, revocation and lifecycle patterns. | Product-specific; does not define UAM capability/grant epochs or replace UAM session tests. |
| W34 | [Duende BFF source review point](https://github.com/DuendeSoftware/products/tree/de013a7802cb49e7584eeebcabb1a9d511ccef8c/bff), 10 June 2026 review point | BFF 4.2.0, commit `de013a7802cb49e7584eeebcabb1a9d511ccef8c` | Source, integration/performance tests, host/templates/migrations, explicit source-available production licensing. | Candidate/reference only; copying or production use must comply with licence and pass dependency/TCO/security gates. |
| W35 | [ASP.NET Core v10.0.10](https://github.com/dotnet/aspnetcore/releases/tag/v10.0.10), released 15 July 2026 | `v10.0.10`, tag commit shown as `2adedfc` | Exact reviewed framework release line for BFF/authn/authz/antiforgery source. | Execution-time patch and transitive dependencies can change; exact release must be re-admitted at implementation. |
| W36 | [ASP.NET Core security source at v10.0.10](https://github.com/dotnet/aspnetcore/tree/v10.0.10/src/Security), 15 July 2026 release | `v10.0.10` | Authentication, authorization, data-protection and security implementation/test reference. | Framework primitives only; no UAM domain/realm/JIT/audit semantics. |
| W37 | [ASP.NET Core antiforgery source at v10.0.10](https://github.com/dotnet/aspnetcore/tree/v10.0.10/src/Antiforgery), 15 July 2026 release | `v10.0.10` | Antiforgery implementation and tests for cookie-authenticated unsafe requests. | Correct integration, proxy/origin/cookie settings, endpoint classification, and browser testing remain UAM work. |
| W38 | [Microsoft ASP.NET Core antiforgery guidance](https://learn.microsoft.com/en-us/aspnet/core/security/anti-request-forgery?view=aspnetcore-10.0), updated 21 July 2026 | ASP.NET Core 10.0 documentation | Cookie/Windows-authenticated endpoints need CSRF protection; token/header patterns and extensibility. | Documentation contains multiple application patterns; UAM must define one closed route/header/cookie profile and test it. |
| W39 | [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), reviewed 1 August 2026 | .NET 10 active LTS; exact patch recorded at execution | Lifecycle selection and recurring servicing requirement for the accepted implementation family. | Support status and patches change; does not prove package/runtime compatibility or UAM security. |
| W40 | [NIST SP 800-61 Rev. 3, Incident Response Recommendations and Considerations](https://csrc.nist.gov/pubs/sp/800/61/r3/final), final 3 April 2025 | SP 800-61 Rev. 3 | Incident preparation, detection, response, recovery, lessons and integration with risk management. | General guidance; UAM incident ownership, evidence, notification, retention, and legal duties are human decisions. |
| W41 | [RFC 8693, OAuth 2.0 Token Exchange](https://www.rfc-editor.org/info/rfc8693/), January 2020 | RFC 8693 | Standard option for explicitly governed delegation/token exchange if a future integration requires it. | Deferred; using it would add impersonation/delegation complexity and does not itself preserve UAM purpose/realm/audit semantics. |
| W42 | [RFC 9449, OAuth 2.0 Demonstrating Proof of Possession](https://www.rfc-editor.org/info/rfc9449/), September 2023 | RFC 9449 | Sender-constrained token option for future browser/backend/downstream scenarios. | Deferred; browser key storage, replay, nonce, provider, proxy, and operational interoperability require a separate ADR and tests. |

## 15.4 Source-quality conclusion

**FACT.** Current primary sources support the underlying mechanisms: confidential-client OIDC/BFF, code + PKCE, PAR where supported, server-side session/cookie and antiforgery controls, mTLS/private-key service authentication, RBAC/ABAC concepts, JIT activation patterns, emergency recovery, and accessible workflow status.

**INFERENCE.** None of those sources proves UAM's composition. UAM-specific fitness depends on the typed capability catalogue, authenticated realm binding, exact target resolution, purpose/ticket semantics, JIT and approval state, final transaction reauthorization, durable audit, minimized output obligations, lifecycle/restore interaction, and the zero-tolerance test catalogue in this result.

---
# 16. Confidence table for every major conclusion

## 16.1 Conclusion confidence

No numerical confidence percentages are used. Confidence reflects the quality and agreement of supplied evidence and current primary sources, not implementation or production proof.

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| The first authorization implementation should be an in-process typed kernel inside the modular monolith | **High** | Preserves the accepted server architecture, keeps the final high-risk decision beside the domain transaction/audit, and avoids an unproved availability/consistency/operations boundary. | A same-semantics external-PDP prototype that materially reduces defects/cost while passing realm, revocation, transaction, restore, outage, and migration gates. |
| Capability RBAC plus a small release-owned ABAC condition set is the right model | **High** | UAM has a finite resource/action surface and clear need for realm, target, purpose, ticket, time, authentication, and workflow conditions; pure RBAC is too coarse and broad ABAC is harder to govern. | A required authorized workflow that cannot be represented without unsafe exception logic, or formal analysis showing a simpler equivalent model. |
| Every executable route, handler, command, job phase, export, and mutation must deny unless explicitly catalogued | **High** | Directly implements the primary gate and the accepted deny-by-default/realm/audit invariants; route omission is otherwise a silent bypass. | No expected ordinary evidence. A change would require an accepted-baseline proposal with equivalent completeness proof. |
| Authenticated realm authority must be server-derived and one active realm should be bound to a browser session | **High** | Accepted predecessors reject payload realm authority. One active realm sharply reduces confused-deputy, cache, routing, and UI context errors. | A proven cross-realm workflow whose benefit justifies a separately typed product-global plane or safely isolated multi-realm session, with zero-tolerance tests. |
| Product-global administration must be a separate explicit plane, not an implied “all realms” wildcard | **High** | A wildcard would defeat realm-first keys and create a catastrophic confused-deputy path. Explicit global resources/actions allow narrower recovery and governance. | No ordinary change; only an alternative with equivalent non-wildcard proof. |
| Roles should be immutable versioned bundles of capabilities, while personas remain provisional workshop artefacts | **High** | Supplied evidence explicitly lacks organizational roles/owners/entitlements. Versioned bundles make review, diff, migration, expiry, and audit reproducible. | Completed human role-mapping evidence can create approved role revisions, but it would not change the bundle-not-label architecture. |
| IdP groups/roles should identify or propose assignments, not authorize UAM actions directly | **High** | IdP claims cannot encode exact UAM target, purpose, approval, output, lifecycle, or transaction context and may be stale. | A formally governed integration that maps immutable IdP assertions to separately approved UAM grants; even then the grant remains UAM authority. |
| Sensitive detail, exports, diagnostics, tasks, releases, deletion, and high-impact audit access should support JIT grants | **High for mechanism; Low for exact profile** | Current IAM practice and UAM risk support temporary authority, exact purpose/target binding, expiry, revocation, and notification. Who may request/approve and exact duration remain human decisions. | Approved risk/use-case evidence could classify a specific capability as standing or disabled; measured operational failure could change activation workflow, not the need for bounded authority. |
| Approval must bind the exact immutable request digest and selected separation-of-duty constraints | **High** | Prevents target/scope/purpose substitution after review and makes the decision reproducible. NIST RBAC and PIM sources support role constraints/approval patterns. | A simpler mechanism that cryptographically and transactionally proves equivalent content binding and SoD. |
| Break-glass should be disabled by default, fixed-purpose, independently authorized, short-lived, and normally unable to view detail or export | **High for architecture; Medium-Low for operational fitness** | Avoids a permanent superuser while preserving recovery from IdP/authorization lockout. Exact authority, key custody, monitoring, and recovery procedures are unresolved. | Passed recovery drills and assigned human authority could raise confidence; a drill showing the narrow capability cannot recover the defined failure set would require adding a still-bounded operation. |
| A confidential-client OIDC BFF with server-side tokens, code + PKCE, and PAR where supported is the right browser boundary | **High** | Current IETF and Microsoft guidance converges on BFF/confidential-client patterns that keep sensitive tokens out of browser JavaScript/storage. | Selected provider incompatibility or a different UI topology that passes equivalent token-containment, session, logout, CSRF, and XSS tests. |
| Cookie-authenticated unsafe operations require explicit antiforgery validation; SameSite/CORS are not sufficient | **High** | Browsers automatically attach cookies, and official framework guidance requires CSRF protection for cookie/Windows-authenticated unsafe endpoints. | No ordinary relaxation; only an alternative proof of same-origin request authorization for every unsafe route. |
| Human and service identities must have separate grant types and service identities must not impersonate users or approve requests | **High** | Prevents shared-secret/fleet identity and confused-deputy paths and composes with accepted per-installation/service identity boundaries. | A future delegated-user integration with explicit token exchange/delegation semantics, purpose, audience, expiry, and audit could add—not replace—this model. |
| High-risk mutations must reauthorize under current database state and write durable audit in the same transaction | **High** | Precheck-only authorization is vulnerable to revocation/target/approval TOCTOU and would violate the accepted privileged-audit invariant. | A different storage architecture proving equivalent atomic decision/mutation/audit semantics through a formal change proposal. |
| Read/query authorization must shape rows and fields, not merely guard controller entry | **High** | Detail, aggregate, audit, and export privacy depends on realm predicates, target predicates, output profiles, and serializer closure. Controller-only checks allow over-fetch or serialization leakage. | No expected ordinary change; implementation evidence may refine where shaping occurs. |
| Background jobs must run as service identities under a persisted grant lease and reauthorize at irreversible phases | **High** | A queued job may outlive user session/JIT approval; phase checks prevent expiry/revocation from being bypassed by asynchronous work. | A specific operation proved to be one indivisible transaction could reduce phase count, but not grant/realm/audit binding. |
| Authorization caches should be keyed by realm, principal/grant generation, catalogue revision, target revision, and revocation epoch | **Medium-High** | These keys directly prevent cross-realm and stale-grant reuse while permitting bounded performance. Exact invalidation topology and TTL are unmeasured. | Load/revocation experiments, distributed topology, or incident evidence may alter cache location and limits; stale privileged commits remain zero-tolerance. |
| Authorization failure should fail closed, while only explicitly bounded last-known-good session/read behavior may continue | **High for fail-closed authority; Medium for availability profile** | Unknown authority cannot safely broaden access. Some low-risk already-authorized reads may tolerate a bounded dependency outage, but exact risk/SLO inputs are absent. | Human risk/SLO decisions plus outage experiments for each capability class. |
| Authorization decision logs and audit must be privacy-safe and avoid payloads, dynamic labels, raw tickets, subjects, and free-form exceptions | **High** | Accepted minimization applies to diagnostics/audit; high-cardinality or sensitive logging becomes a new disclosure/search surface. | A defined legal/support evidence need may add a separately protected minimal field after privacy/records approval and canary tests. |
| Restore must start authorization-read-blocked and reconcile current grants, epochs, revocations, catalogue revisions, and break-glass state before enablement | **High** | Trusting restored authorization state can resurrect expired/revoked authority and conflicts with accepted restore-readiness invariants. | A single authoritative recovery substrate that intrinsically contains current authorization state and passes old-backup drills. |
| Feature flags and kill switches may only narrow, pause, or disable authorization | **High** | A broadening/bypass flag would become an unaudited parallel authority plane and violate the product privacy ceiling. | No expected ordinary relaxation. |
| An external policy/ReBAC/PIM engine is unnecessary for the first slice | **Medium-High** | The typed model is small enough to own, and external systems add service/datastore/consistency/licensing/operations risk. Repository review offers ideas but no UAM fitness. | Measured relationship/policy complexity, independent scale, multi-product reuse, or lower total assurance cost demonstrated by a full bake-off. |
| ASP.NET Core security primitives are a suitable implementation basis | **Medium-High** | They match the accepted .NET family, are actively maintained, and provide necessary OIDC/cookie/authorization/antiforgery primitives. Exact provider, patch, configuration, and UAM composition are untested. | Dependency admission, provider/browser campaigns, security advisories, lifecycle changes, or an alternative BFF bake-off. |
| Production authorization is ready | **Low / not established** | No route catalogue, evaluator, realm campaign, JIT/revocation test, BFF provider test, audit failpoint, break-glass drill, human mapping, or aggregate gate has passed. | Accepted `prompt-19-gate.json`, eventual Batch 05 reviewer acceptance, all human decisions/owners, real-environment evidence, and production risk approval. |

## 16.2 Residual risk and containment

The result deliberately leaves the following risk visible:

- **Human policy error.** A technically valid capability, role bundle, purpose, approval, or break-glass profile can still be unwise, unlawful, over-broad, or assigned to the wrong person. Containment is immutable revisions, dual control where selected, access review, diff/evidence, expiry, notification, and accountable human approval; research cannot eliminate the risk.
- **Identity-provider or session compromise.** A compromised IdP, authenticator, BFF host, browser origin, administrator workstation, or recovery credential can authorize malicious activity. Containment is phishing-resistant/high-assurance activation where chosen, short sessions/grants, server-side tokens, CSRF controls, target/purpose checks, transaction reauthorization, alerting, and kill/revocation; a sufficiently privileged compromise remains high impact.
- **Authorization implementation defect or common-mode oracle defect.** Route descriptors, evaluator, query shaping, serializer, cache, audit, and independent oracle can share a mistaken assumption. Containment is independent model code, hand-worked cases, mutation/property tests, cross-engine reference comparators, route completeness, negative generation, failpoints, code ownership, and real-boundary tests; formal research cannot prove absence of all defects.
- **Realm confused-deputy paths.** A cache, background job, global lookup, object store, export, audit query, restore, or service identity can accidentally omit or replace the realm. Containment is realm-first keys/types, no default realm, one-realm sessions, typed target loaders, capability descriptors, zero-tolerance synthetic ID collisions, and final transaction predicates.
- **Stale authority.** Distributed caches, queues, provider sessions, long-running jobs, browser tabs, database replicas, and restore copies can outlive grant expiry or revocation. Containment is epochs/generations, database time, phase reauthorization, bounded sessions, revocation fan-out, read blocking, and no privileged commit on stale evidence. Exact propagation objectives remain unapproved.
- **Break-glass abuse or unusable recovery.** Emergency authority can become a hidden superuser, or a design so narrow that it fails during a real outage. Containment is a fixed operation catalogue, independent custody, disabled-by-default state, short expiry, no default detail/export, immediate alerts, post-use review, recurring drills, and out-of-band revocation. Human authority and operational competence remain open.
- **Data inference despite correct authorization.** Authorized aggregate, detail, audit, or export access may permit re-identification, rare-population inference, linkage, or misuse. Containment is human-approved purpose/fields/precision, output profiles, row/field minimization, export controls, suppression, monitoring, and prohibited-use governance. Authorization alone cannot make sensitive data harmless.
- **External copies and downstream integrations.** A correctly authorized export or integration can leave UAM control. Containment is destination capability contracts, stable object manifests, deletion limitations, purpose/expiry, encryption, audit, and truthful `EXTERNAL_ACTION_REQUIRED` states; recipient-side behavior can remain unprovable.
- **Availability and operational cost.** Strict fail-closed checks, JIT approvals, IdP outages, database contention, revocation, and restore blocking can delay support or recovery. Containment is capability-specific outage profiles, bounded last-known-good behavior only where approved, independent recovery, measured caches, runbooks, staffing, and SLO decisions. No availability promise is made.
- **Technology and dependency change.** Browser, IdP, ASP.NET Core, cryptographic, repository, and commercial-licensing behavior can change after this review. Containment is exact release admission, supported lifecycle, recurring interoperability/security tests, evidence expiry, same-digest promotion, and replaceable adapters.

## 16.3 Explicit next stop/go gate

**GO now** only for repository tasks that use fictional T1 data and test identities: strict contracts, route/handler inventory, pure evaluator and independent oracle, synthetic realms/personas/targets, immutable capability/role/grant/JIT state, transaction/audit failpoints, a minimal isolated BFF, browser/CSRF/logout tests, service-identity negatives, privacy-safe decision telemetry, accessibility prototypes, and disabled test-only break-glass drills.

**STOP** before real user assignments, real organizational roles/groups, real activity/detail, production exports, production deletion/release/task authority, production IdP trust, production break-glass, pilot, support claim, or deployment.

The immediate technical stop/go gate is:

```text
P19_TOPIC_TECHNICAL_GO =
    P19_MODEL_PASS
    AND P19_REALM_PASS
    AND P19_JIT_PASS
    AND P19_BFF_PASS
    AND P19_AUDIT_PASS
    AND P19_RECOVERY_TECHNICAL_PASS
    AND ZERO_UNAUTHORIZED_ALLOWS
    AND ZERO_CROSS_REALM_EFFECTS_OR_DISCLOSURES
    AND ZERO_FORBIDDEN_OUTPUT_OR_AUDIT_ESCAPES
    AND ZERO_STALE_PRIVILEGED_COMMITS
    AND ZERO_MUTATIONS_WITHOUT_DURABLE_AUDIT
    AND ZERO_CLEANUP_RESIDUE
    AND ALL_REQUIRED_EVIDENCE_CURRENT
```

Even when that expression passes, `implementationPrototypeAuthorized` can become `true` only for the exact T1 release/topology in `prompt-19-gate.json`; `productionApproved` remains `false`.

The next suite-level gate is the **Batch 05 portal-governance reviewer** after Prompts 19–21 are available. That reviewer must reconcile authorization with the other portal workflow/audit results, preserve accepted predecessor invariants, resolve conflicts, and confirm the human owner/role/purpose/approval/break-glass decisions. Until then, this topic result is decision-ready implementation research, not final Batch 05 or production authority.
