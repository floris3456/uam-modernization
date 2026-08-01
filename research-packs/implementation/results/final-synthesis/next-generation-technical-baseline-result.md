# Next-generation UAM technical baseline — final synthesis

**Result path:** `results/final-synthesis/next-generation-technical-baseline-result.md`  
**Review date:** 1 August 2026  
**Decision status:** **ACCEPT AS THE IMPLEMENTATION BASELINE WITH MANDATORY CONDITIONS — G0 FOUNDATION WORK MAY START; EVERY LIVE-DATA, PLATFORM-SUPPORT, PILOT, CUTOVER, AND PRODUCTION GATE REMAINS OPEN**  
**Authority boundary:** final technical synthesis of the six allowlisted batch reviews, accepted baseline, and research-evidence rules. This result authorizes only the technical work explicitly marked ready. It does **not** approve legal purpose, lawful basis, prohibited uses, identity or field scope, retention, access, role assignments, employee consultation, budget, licensing, staffing, SLO/RPO/RTO, pilot, cutover, decommission, risk acceptance, or production deployment.

---

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from stated facts; the chain is explained.
- **ESTIMATE** — a numerical hypothesis whose inputs must be replaced by measurement.
- **RECOMMENDATION** — a proposed technical decision with alternatives and trade-offs.
- **UNKNOWN** — required evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, support, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, fault injection, observation, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements define the implementation baseline proposed for ADR acceptance. They do not convert a **HUMAN DECISION**, **UNKNOWN**, **ESTIMATE**, or unexecuted **CLI EXPERIMENT** into approval.

## Evidence boundary and file-presence record

**FACT.** All eight allowlisted files were present. No missing-file substitution was required, and no individual topic result, optional CLI evidence, or other Project file was used.

| Ref | Allowlisted file | SHA-256 reviewed here | Role and limitation |
|---|---|---|---|
| I01 | `batch-01-review-result.md` — local file `batch-01-review-result(3).md` | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | Accepted foundations, contracts, G0/G1, policy, registry, repository, CI, and first proof sequence. Blueprint and planned experiments, not executed implementation proof. |
| I02 | `batch-02-review-result.md` | `98aace500e7af551a1b024118ee52935643bd61c45ea9afc5b67c49967c301ef` | Accepted Edge discovery/acquisition, source lineage, cursor, URL privacy transformation, page boundary, and G2–G4 proof plan. No live-source gate is closed. |
| I03 | `batch-03-review-result.md` | `76854c3d6a12b9b717da90d4e368273bd88a672fc64a315afaeacfb3d701a785` | Accepted endpoint durability, release, installation identity, diagnostics, exact-tuple compatibility, and G5/release/identity/diagnostic proof plans. No engineering canary is authorized. |
| I04 | `batch-04-review-result.md` — local file `batch-04-review-result(1).md` | `232fec004ae866a59e37bad4d0c2e06dd920d1211919ec538aee23ac28305ed4` | Accepted relational custody, leased processing, database comparison, capacity simulation, lifecycle, backup, restore, and deletion architecture. All production receipt, database, capacity, cleanup, and lifecycle decisions remain open. |
| I05 | `batch-05-review-result.md` | `38dc40cc0e07b560da4bcf477d3a0c20e01e2d2aba430e3187eddf21742bed99` | Accepted portal/BFF, authorization, explicit workflows, transactional audit, independent verification, accessibility, and restore authority. No administrative production use is authorized. |
| I06 | `batch-06-review-result.md` | `da2f40b339bcb08f1ad791967e883de640a29024bd4b34150ff4322fa6699119` | Accepted discovery, shadow comparison, authority transfer, rollback, read-only archive, trust removal, residual monitoring, and decommission architecture. No real parallel run, cutover, trust removal, or decommission is authorized. |
| I07 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | Shared accepted architecture and non-negotiable invariants. Working implementation baseline, not production authority. |
| I08 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | Evidence quality, authority boundaries, source preferences, and change-proposal discipline. It proves no technical claim by itself. |

## Current primary-source verification — limited to time-sensitive load-bearing facts

The architecture deliberately avoids freezing patch numbers as timeless design. The following point-in-time facts were rechecked on 1 August 2026 and are recorded only as execution inputs:

| Topic | FACT verified on 1 August 2026 | Architectural consequence |
|---|---|---|
| .NET lifecycle | Microsoft’s [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) lists .NET 10 as active LTS, latest patch 10.0.10 dated 14 July 2026, with support through 14 November 2028. | C#/.NET remains the accepted family. The exact current supported patch is locked and reverified at each build; `10.0.10` is not hard-coded into architecture. |
| PostgreSQL lifecycle | PostgreSQL’s [versioning policy](https://www.postgresql.org/support/versioning/) lists PostgreSQL 18 as supported, current minor 18.4, and recommends current minor releases. | PostgreSQL remains the reference candidate, not the production winner. The exact supported major/minor is an experiment manifest input. |
| SQLite point release | SQLite’s [release history](https://www.sqlite.org/changes.html) lists 3.53.4 dated 24 July 2026 with source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`. | Every endpoint experiment records the actual loaded native source ID; managed package version alone is insufficient. |
| Accessibility standard | [WCAG 2.2](https://www.w3.org/TR/WCAG22/) is a W3C Recommendation dated 12 December 2024. | WCAG 2.2 AA remains the engineering target for complete privileged workflows; legal/procurement conformance remains human-owned. |

**FACT.** These checks do not replace project-specific CLI evidence and do not select a runtime patch, database engine, provider, portal framework, or support matrix.

---

# 1. Executive implementation recommendation

## 1.1 Plain-language recommendation

**RECOMMENDATION.** Build the next-generation UAM as a deliberately narrow sequence of independently falsifiable gates, not as a broad replacement platform assembled in parallel.

The implementation should begin with **G0**, a deterministic fictional-data package, strict contracts, an independently owned truth oracle, and exact privacy canaries. Only after G0 closes should the project prove the Windows process and IPC boundary in **G1**. Live Edge acquisition, source continuity, URL minimization, endpoint durability, release, identity, diagnostics, server custody, capacity, lifecycle, portal administration, audit, migration, and decommissioning then follow in the accepted dependency order.

The first useful product slice remains: **Edge browser history transformed inside a restricted Task Host to an approved site/domain-level minimized event**, using only synthetic data until governance permits otherwise. The endpoint never receives central database credentials, never submits SQL, never sends raw URLs beyond the Task Host, and never advances a cursor ahead of the durable minimized effects it represents.

The server begins as a modular monolith with an authenticated ingestion boundary, relational durable inbox, leased workers, typed facts and aggregates, control BFF, governed integrations, transactional audit, and lifecycle barriers. PostgreSQL remains the reference candidate and SQL Server a serious alternative; the production engine is selected only by an identical semantic, load, restore, operations, skills, licensing, and cost gate.

The portal begins aggregate-first and least-detail, with a same-origin BFF, release-owned capabilities, closed purpose/target/output conditions, explicit commands, same-transaction audit, audit-before-disclose, and accessible complete workflows. Person/activity detail, exports, break-glass, destructive lifecycle actions, and production administration remain disabled until human and technical gates pass.

Migration is dual observation rather than dual authority: legacy remains authoritative while isolated new shadow facts are compared server-side. Endpoint dual-write, shadow promotion, raw deferred-SQL execution, and automatic legacy credential resurrection are prohibited. Authority transfer, trust removal, and final decommission are separate milestones with separate owner decisions.

## 1.2 Final synthesis verdict

**FACT.** Each batch review explicitly concluded that no accepted-baseline change proposal was required. No allowlisted project-specific CLI measurement file was supplied. The batch documents contain architectures and experiment plans, not completed gate evidence.

**RECOMMENDATION — ACCEPT THE CONSOLIDATED ARCHITECTURE WITHOUT BASELINE REPLACEMENT.** Topic-level corrections already accepted by the batch reviews are incorporated here, including:

- canonical lower-case UUIDv7 for new UAM domain and wire identifiers;
- field-specific Unicode handling rather than global normalization;
- codec-neutral logical IPC until JSON/CBOR evidence selects a physical profile;
- separate source lineage, collector/runtime capability, and privacy interpretation identity;
- one page as the endpoint progress authority;
- central ordinary-effect uniqueness by `(realm_id, event_id)`;
- immutable custody separate from mutable processing state;
- canonical `AuditEventV1` with portal projections rather than competing audit ledgers;
- independent audit checkpoints before privileged production use;
- exact-tuple compatibility rather than broad family claims;
- phase-bounded legacy rollback that expires before trust removal; and
- separate authority, validation, ring, archive, trust-removal, and decommission state machines.

## 1.3 What is ready now

**RECOMMENDATION — GO** for:

- repository and dependency-boundary scaffolding;
- strict contract standards, local schemas, invalid/golden vectors, and catalogue tooling;
- deterministic T1 fictional fixtures, UUIDv7 vectors, fixed clocks, and content digests;
- an independent oracle, truth ledger, mutation suite, and exact canary scanner;
- pure policy-lattice, registry, matcher, source, page, durability, release, identity, diagnostics, server, lifecycle, portal, audit, migration, and decommission state models;
- disconnected lab scripts with placeholders only;
- T1-only database, browser, Windows, restore, accessibility, and migration prototypes after their predecessor contracts exist; and
- ADR, owner-decision, evidence-envelope, runbook, and gate-evaluator infrastructure.

## 1.4 What is not ready

**RECOMMENDATION — STOP** before:

- any real activity, production-derived fixture, employee data, live source, or customer configuration;
- production-shaped endpoint integration before the Batch 01 gate;
- live Edge access before G1 and the G2 authorization;
- a production outbox before G2/G3/G4 and the G5 crash invariant;
- endpoint cleanup after receipt before the B04 custody/restore/cleanup conditions pass;
- a production database choice, capacity promise, broker, autonomous updater, PKI, diagnostic backend, portal framework, audit store, archive topology, or retention value;
- any person/activity detail route, export, break-glass activation, destructive lifecycle action, or production administrative command;
- real parallel run, authority transfer, legacy trust removal, archive read enablement, or final decommission;
- pilot, production signing, production deployment, or public support statement.

## 1.5 Answer to the research questions

1. **Accepted decisions, interfaces, schemas, state machines, invariants, and gates:** consolidated in sections 3–10. The core topology and non-negotiable invariants are stable enough to implement behind ordered gates.
2. **Earlier decisions that must change:** **FACT — none.** No stronger allowlisted CLI evidence contradicts the accepted baseline. Topic-level corrections have already been reconciled and do not replace the baseline.
3. **Remaining contradictions:** they are implementation-profile choices or human decisions, not hidden architecture conflicts. Section 9 names each conflict and the exact evidence needed.
4. **Ready, experiment-only, human-owned, deferred:** section 8 provides the status register; section 11 names the immediate implementation; section 12 sequences later work.
5. **Coverage and hidden trust gaps:** the plan covers endpoint, data, release, identity, diagnostics, compatibility, server, lifecycle, portal, audit, migration, operations, and decommissioning. Residual trust gaps remain in Windows composition, browser internals, storage durability, administrator collusion, key custody, operational competence, human misuse, external copies, and unexecuted recovery drills; they are explicitly gated rather than assumed away.

## 1.6 Confidence by major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| The six batch architectures compose without changing the accepted baseline | **High** | Every review preserves predecessor invariants and resolves conflicts through narrower authority, explicit state separation, or a gate. | A prototype showing two accepted invariants cannot coexist without a formal change, such as session isolation requiring Coordinator profile access. |
| G0 is the next safe implementation gate | **High** | It is first in the accepted proof order and has no live-data dependency; all later gates consume its contracts, fixtures, oracle, and canaries. | Evidence that the repository already contains a complete, current, independently verified G0 gate package. No such evidence is allowlisted. |
| The Coordinator/User Host/Task Host topology is the right endpoint boundary | **High at architecture level; Medium-Low at runtime fitness** | It is accepted repeatedly and minimizes privilege and raw-data exposure. Windows task, token, ACL, EDR, and same-user behavior remain unmeasured. | Exact supported-environment G1 campaigns or a falsifier requiring a different process/authority topology. |
| Direct-read/eligible Online Backup/defer is the right Edge acquisition sequence | **Medium-High** | It is narrower than live file copy, VSS, extension, or central profile crawl and matches source-safety invariants. | G2 evidence that the sequence cannot achieve correct zero-write snapshots for the approved estate. |
| Whole-page atomic effect/progress and one-writer SQLite are correct | **High logically; Medium operationally** | They directly express cursor, retry, and no-silent-loss invariants. Actual provider, filesystem, power, EDR, and pressure behavior is unproved. | Model counterexample or G5 crash history producing cursor-ahead, missing effect, changed identity, or ambiguous cleanup. |
| Relational custody plus leased processing is the right initial server design | **High** | It provides the smallest atomic receipt boundary and avoids an unproved broker failure domain. | A smaller alternative passing identical custody, one-effect, realm, replay, restore, operations, and cost gates. |
| PostgreSQL should be selected now | **Low / not established** | Reference status and current support do not prove UAM recovery, workload, skills, licensing, or TCO fitness. | Paired B04 semantic, load, restore, failover, operator, licensing, and TCO evidence plus human selection. |
| A production capacity figure is known | **Low / not established** | No approved event/byte/retry/outage/query/retention distribution or SLO exists. | Qualified simulator, approved distributions, exact topology, recovery/soak results, and human objectives. |
| Same-origin BFF, closed authorization, and transactional audit are the right first portal model | **High at architecture level** | They minimize browser token/realm surfaces and preserve same-transaction authority/audit. | A deployment constraint and alternate design passing the same realm, purpose, audit, restore, accessibility, and support matrix at lower assurance cost. |
| Independent audit checkpoints are required before privileged production use | **High** | Local database/host administrators are inside the threat model; local-only chains cannot detect every rollback or alteration. | A formally accepted threat model excluding those administrators or an equivalent independently recoverable mechanism. |
| One-authority shadow comparison and phase-bounded rollback are correct | **High** | They preserve one-effect, no-endpoint-SQL, and trust-removal invariants while still allowing reversible pre-removal cutover. | A formal baseline change proving dual authority or post-revocation legacy restoration is necessary and safer. |
| Any pilot or production deployment is currently ready | **Low / not established** | All aggregate technical gates and material human decisions remain open. | Current exact evidence passing every applicable gate plus designated risk and production approval. |

---

# 2. Updated constraints, non-goals, prohibited defaults, and residual-risk posture

## 2.1 Non-negotiable constraints

| ID | Normative constraint |
|---|---|
| C-01 | Windows endpoints MUST use a low-privilege machine Coordinator, one ordinary-token User Host per eligible interactive session, and short-lived fixed-capability Task Hosts. |
| C-02 | The Coordinator MUST NOT crawl/load user profiles, create user tokens, read browser sources, impersonate users as its normal identity path, or receive raw source values. |
| C-03 | Task Hosts MUST be fixed release-authorized capabilities, never script, plug-in, assembly, SQL, path, command, tenant algorithm, or arbitrary-code channels. |
| C-04 | C#/.NET is the default implementation family; exact supported patches and fast-moving dependencies are execution-time locked evidence. |
| C-05 | A release-authorized product privacy ceiling bounds sources, fields, transforms, outputs, diagnostics, destinations, and capabilities. Tenant configuration may only narrow it. |
| C-06 | Minimization MUST occur before User Host/Coordinator IPC, durable endpoint storage, logs, diagnostics, support artifacts, transport, portal disclosure, or exports. |
| C-07 | Endpoints MUST NOT receive central database credentials, submit SQL, execute deferred SQL, or know server storage topology. |
| C-08 | Endpoint SQLite WAL with one writer MUST atomically commit minimized effects or deterministic no-event facts with page/source progress. |
| C-09 | Delivery is at least once. Stable event and batch identities plus central uniqueness MUST create one final ordinary business effect. |
| C-10 | A receipt means durable custody in a declared failure domain only; it does not imply validation, materialization, integration, visibility, report inclusion, deletion eligibility, or legal completion. |
| C-11 | The initial server MUST remain a modular monolith with authenticated ingestion, relational custody, leased workers, typed facts/aggregates, a control BFF, and governed integrations. |
| C-12 | An external broker is not a default. It requires measured failure-domain, replay, throughput, fan-out, recovery, or cost evidence and a change ADR. |
| C-13 | PostgreSQL remains the reference candidate and SQL Server a serious alternative. Production selection requires identical semantics, load, restore, operations, skills, licensing, support, and TCO evidence. |
| C-14 | MSI and enterprise deployment own the stable privileged boundary. An autonomous updater is disabled unless separately justified and proved. |
| C-15 | Realm, installation, user, session, and global authority MUST come from authenticated runtime/server context, never payload, browser, route, header, name, path, certificate text, or network location. |
| C-16 | One realm, user, session, installation, or authority epoch MUST NOT submit, view, mutate, approve, export, delete, restore, audit, or execute as another. |
| C-17 | A privileged mutation MUST NOT commit without its final authorization decision and durable canonical audit event in the same transaction. |
| C-18 | No component may silently drop unacknowledged data under pressure. Unknown commit, custody, identity, policy, compatibility, or restore state fails closed. |
| C-19 | Restore MUST NOT expose deleted data, omit acknowledged events, revive stale authority, issue ordinary receipts, or enable egress before readiness. |
| C-20 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| C-21 | Every failed early gate stops dependent work and opens the named ADR/change review. A pass proves only the exact release, environment, workload, and failure tested. |

## 2.2 Non-goals

**RECOMMENDATION.** The first implementation is explicitly not intended to be:

- a general endpoint monitoring, EDR, remote-shell, scripting, plug-in, or policy-execution platform;
- a person-performance, productivity, disciplinary, attendance, behavioral-scoring, or forensic-certification product;
- a browser extension, DevTools/CDP collector, VSS crawler, whole-profile indexer, arbitrary process/file collector, or cross-session attribution engine;
- a generic event bus, workflow platform, schema registry service, microservice estate, search platform, data lake, or broker-led architecture;
- a generic admin console, table editor, GraphQL mutation explorer, direct SQL console, free-form report builder, or tenant-authored ABAC language;
- a universal employee identity/HR/CMDB truth system;
- a guarantee that all historic activity, deleted browser data, synchronized origin, or visit-origin session can be reconstructed;
- a promise that hash chains prove semantic truth, lawfulness, completeness, non-repudiation, or legal admissibility;
- an automatic migration of every legacy behavior or defect; or
- a claim that technical decommission proves deletion of unmanaged or recipient-controlled copies.

## 2.3 Prohibited defaults

The following defaults are rejected unless a formal accepted-baseline change explicitly replaces them:

| Area | Prohibited default |
|---|---|
| Test data | Production copies, row-level “anonymized” activity, raw catalogue values, organization names, real URLs, real identities, or production-derived distributions without approved minimum aggregate evidence. |
| Endpoint authority | Coordinator profile crawl, service-created user token, routine pipe-client impersonation, SYSTEM collector, arbitrary Task Host arguments, shared cross-session pipe, or source access from session 0. |
| Source acquisition | Raw copy of live SQLite main/WAL/SHM, `immutable=1` or `nolock=1` on live source, read/write fallback, source-directory scratch, stopping Edge, VSS, recursive home/profile crawl, network/UNC roots, or command-line process inspection for custom roots. |
| Privacy | Raw URL outside Task Host, raw/reversible URL hash or HMAC for telemetry, path/query/fragment/title output, fuzzy/name/role/person matching, first-match ambiguity, global Unicode normalization, or unknown-as-permitted. |
| Durability | Row-level cursor authority, network I/O in the store transaction, regenerated retry IDs, new batch after ambiguous send, HTTP 2xx as custody, cleanup before valid receipt and approved policy, corruption auto-recover/delete/recreate, or silent pressure loss. |
| Release | Mutable install directory, execute-from-staging, symlink/junction target, lower-sequence rollback, autonomous destructive migration, monolithic privileged downloader/updater, floating dependencies, mutable CI actions, or environment rebuilds. |
| Identity/network | Fleet secret, shared API key, image-enrolled key, PFX/private-key export, payload-derived realm, silent software-key fallback, plain XFCC/header authority, TLS-validation disablement, direct fallback around a required proxy, or broad EDR exclusion. |
| Diagnostics | Arbitrary strings/objects/exceptions, URL/path/user/SID labels, automatic dumps, general OpenTelemetry defaults, raw local logging followed by later redaction, remote debugger/diagnostic port, arbitrary support command/file collector, or diagnostics as audit. |
| Server | Synchronous materialization before custody, mutable receipt, partial first-slice materialization, event uniqueness broadened by installation or partition, broker as initial custody, generic framework handler discovery, RLS as sole realm boundary, or database selection by familiarity/popularity. |
| Lifecycle | Physical deletion before suppression, soft delete as completion, backup checksum as restore proof, read/egress during restore, universal `404=deleted`, indefinite audit/tombstone retention, or external deletion inferred from acceptance. |
| Portal/audit | Browser-held API tokens, UI-only authorization, wildcard admin, IdP groups as final authority, generic policy engine, free-form search/SQL, business mutation then logging, external audit dual-write as primary, editing audit history, break-glass without audit, or inaccessible fallback. |
| Migration | Endpoint dual-write, two ordinary authorities, shadow promotion, new server write-back to live legacy authority by default, generic percentage tolerance, sample-only sign-off, automatic legacy rollback, deferred-SQL execution, login-disable-only trust removal, UI-only read-only, or checklist-only decommission. |

## 2.4 Residual-risk posture

**FACT.** The architecture reduces and contains risk; it cannot eliminate it. Windows kernels, filesystems, firmware, hypervisors, browser internals, EDRs, administrators, key custodians, identity providers, gateways, database operators, and human approvers remain material trust or failure domains.

**RECOMMENDATION.** Residual risk MUST be represented as named, owned, expiring evidence rather than optimistic prose. A technical pass may justify a bounded capability; it never waives legal, privacy, support, budget, or production authority. The final section states the risks that remain even after all planned controls.

---

# 3. Complete component, trust, and data-flow architecture

## 3.1 Architectural shape

**RECOMMENDATION.** The implementation is one governed product with four separately controlled planes:

1. **Endpoint data plane** — machine Coordinator, per-session User Host, fixed Task Hosts, one realm-bound endpoint store, batch/transport, installation identity, compatibility, release, and diagnostics.
2. **Server data plane** — identity boundary, ingestion/custody, leased materialization, typed facts, projections, integrations, lifecycle, backup, and restore.
3. **Control and evidence plane** — product ceiling, tenant narrowing, application registry, release/compatibility artefacts, portal BFF, authorization, audit, verifier, diagnostics permits, and gate evidence.
4. **Migration plane** — one-shot discovery, evidence graph, shadow comparison, authority epochs, cutover rings, archive, trust removal, residual monitoring, and decommission acceptance.

The planes share contracts and authenticated context, not unrestricted runtime libraries or implicit database access.

## 3.2 End-to-end trust-boundary diagram

```text
BUILD / RELEASE AUTHORITY
  source + exact dependencies + locked toolchain
  -> untrusted validation
  -> trusted validation / real Windows & DB labs
  -> reproducible unsigned payloads
  -> SBOM + provenance + file-manifest reconciliation
  -> separately authorized signing
  -> same-digest promotion
                         |
                         v
ENDPOINT MACHINE TRUST ZONE
  MSI-owned launcher/service/task/ACL roots
  MachineBootstrapState + ReleaseAndControlState
                         |
                  Coordinator Service
  low privilege; session 0; machine/realm state; one business-store writer
  NO profile crawl, user-token creation, source read, raw URL, SQL, or arbitrary launch
                         |
          authenticated bootstrap + one-use exact-logon handoff
                         v
USER SESSION TRUST ZONE
  ordinary-token User Host
  exact session eligibility + root discovery + independent policy check
                         |
                 one-use CollectionPermit
                         v
RAW-SOURCE PRIVACY ZONE
  fixed short-lived restricted Task Host
  source read -> parse -> structural deny -> hard deny -> match -> minimize
  raw source bytes exist only here for the bounded operation
                         |
                 minimized page only
                         v
ENDPOINT DURABILITY ZONE
  one-writer SQLite WAL transaction
  native effect/no-event + outbox event + page/run + checkpoint together
  sealed immutable batch + durable PREPARED attempt + authenticated receipt
                         |
                  bounded compressed HTTPS / mTLS
                         v
SERVER IDENTITY BOUNDARY
  validates direct mTLS or approved gateway proof
  creates immutable AuthenticatedDeviceContext
  body/header/route/certificate text cannot override realm or installation
                         |
                         v
SERVER CUSTODY ZONE
  strict ingress -> one relational custody transaction
  immutable batch + exact payload + immutable receipt + work seed
  receipt returned only after commit in declared failure domain
                         |
                         v
SERVER PROCESSING ZONE
  short fenced lease -> parse outside lease transaction
  -> one final materialization transaction
  event identity + typed facts + projection work + integration outbox + terminal state
                         |
         +---------------+----------------+
         |                                |
         v                                v
LIFECYCLE / RESTORE ZONE            CONTROL / PORTAL ZONE
  suppression tombstones             same-origin browser + BFF
  deletion cases/targets              authenticated portal context
  backup catalogue                    closed capability/purpose/target/output checks
  isolated restore                    explicit commands / durable jobs
  read/egress blocked until ready      same-transaction AuthorizationDecision + AuditEvent
         |                                |
         +---------------+----------------+
                         v
AUDIT VERIFICATION ZONE
  canonical audit streams -> hash chain -> sealed segments -> Merkle roots
  independent verifier + separately protected signed checkpoints
  verification failure -> scoped technical hold; no self-clear
                         |
                         v
MIGRATION / DECOMMISSION ZONE
  read-only discovery -> evidence graph -> owner dispositions
  isolated shadow -> deterministic comparison -> approved fence
  authority epoch -> progressive rings -> trust removal -> archive -> residual monitoring
  independent acceptance evaluator + human owner quorum
```

## 3.3 Trust zones and allowed crossings

| Zone | Trusted for | Not trusted for | Allowed crossing |
|---|---|---|---|
| Repository/untrusted CI | compilation feedback, unit tests, static checks | secrets, signing, internal network, deployment, production data | source and declared public dependencies only |
| Trusted build/signing | exact build, manifest, SBOM/provenance, digest-bound signing | business approval, runtime authority, tenant broadening | immutable signed artifacts and evidence only |
| Machine bootstrap/control | installation identity references, release slots, signed-control cache, clock/safety state | activity, source values, outbox, cursor, receipt payload | opaque control facts to Coordinator/launcher |
| Coordinator | authenticated machine/realm context, session reconciliation, policy, local durability, transport | user source authority, raw source, user-token creation, arbitrary code | bounded logical messages and minimized pages |
| User Host | current interactive token/session and user-owned root discovery | machine persistence, central transport, cross-session identity, arbitrary policy | one-use source binding and permit-bound page |
| Task Host | one fixed source capability and transient raw handling | general same-user confidentiality, arbitrary code, network, durable raw data | minimized closed result or value-free failure |
| Endpoint business store | minimized effects, source progress, outbox, batches, attempts, receipts | raw URL/path/profile, policy broadening, network | writer actor only; transport receives exact sealed bytes |
| Network/gateway | transport connectivity and approved TLS termination profile | realm from header/IP, semantic acceptance, custody | authenticated request context and bounded bytes |
| Server identity boundary | credential/status/realm/install/epoch authority | request body, route, IP, host, certificate subject alone | immutable `AuthenticatedDeviceContext` |
| Custody store | immutable receipt-backed batch bytes and identity | semantic validity, visibility, deletion completion | leased processing and restore reconciliation |
| Fact/lifecycle stores | typed materialized truth, tombstones, cases, projections | endpoint source semantics not represented in contract | realm-first repositories through domain services |
| Browser | presentation and user intent | tokens, realm, authorization, target scope, audit, durable job state | opaque session cookie, CSRF token, typed read/command contracts |
| Audit verifier | byte/sequence/checkpoint integrity | semantic truth, legal admissibility, lawful purpose | read-only events and external checkpoint state |
| Migration discovery/comparison | bounded evidence and similarity under a profile | approval to preserve behavior, ordinary business authority | content-addressed evidence and owner decisions |
| External integrations/exports | only their explicit governed contract | UAM custody, deletion completion, realm authority | stable message/object identity and typed receipts/limitations |

## 3.4 Endpoint data flow

1. **Control activation.** The Coordinator loads verified product ceiling, tenant narrowing, emergency/local disablement, compatibility state, release state, and installation identity. Any invalid, expired, wrong-realm, stale, downgraded, or conflicting authority disables new collection.
2. **Session selection.** The Coordinator reconciles eligible interactive sessions but does not create tokens. The MSI-owned task/launcher starts one ordinary-token User Host per eligible session.
3. **IPC authentication.** Bootstrap is handshake-only and bounded. The Coordinator and User Host bind kernel-reported process/session identity, held process handles, token facts, exact logon SID/LUID, protected release identity, and a fresh one-use handoff pipe.
4. **Run intent.** The Coordinator issues a bounded `RunIntent` referencing release-owned source/capability IDs, active policy/ceiling digests, source/generation context, nonce, and budget. It is not final source-read authority.
5. **User-session authority.** The User Host rechecks session, current effective policy, source root kind, and source binding. It issues a one-use short-lived `CollectionPermit` to the fixed Task Host.
6. **Source access and minimization.** The Task Host performs the approved source algorithm. For Edge this is a short hardened read-only snapshot, eligible Online Backup to private memory, or defer. Raw URL remains inside Task Host memory. The first enabled URL profile is strict ASCII HTTP(S) DNS-host matching with exact/suffix rules and deterministic ambiguity.
7. **Whole-page return.** The Task Host returns one page under one source generation, source capability, collector runtime profile, and interpretation. Every source row becomes one minimized event candidate or deterministic no-event fact. Any uncertainty invalidates the whole page.
8. **Atomic local commit.** The Coordinator validates the page and commits record effects, outbox events, witnesses, page/run outcome, and checkpoint in one `BEGIN IMMEDIATE` transaction. ACK follows commit only.
9. **Batching.** Ready events are sealed into immutable bounded batches with stable IDs, canonical uncompressed digest, exact compressed bytes, and wire digest. The delivery attempt is durably `PREPARED` before the first socket write.
10. **Receipt.** Only a matching authenticated durable-custody receipt marks the batch receipted. HTTP success, socket completion, semantic acceptance, or visibility does not. Production payload cleanup remains disabled until B04 proves the required server recovery and lifecycle conditions.

## 3.5 Server data flow

1. The server identity boundary validates the credential and creates `AuthenticatedDeviceContext`.
2. The ingestion API applies exact route, media, encoding, compressed/decompressed, item, time, allocation, contract, and digest limits.
3. One short transaction creates or replays immutable batch identity, exact custody bytes, immutable receipt, and one work seed. Receipt is returned only after commit in the approved failure domain.
4. A worker acquires a short database-time fenced lease. Decompression, parsing, semantic validation, reference lookup, and plan construction occur outside the lease transaction.
5. One final fenced transaction either:
   - inserts/reuses `(realm_id,event_id)` identities, typed facts, projection work, integration outbox, and moves the batch to `MATERIALIZED`; or
   - records an immutable terminal quarantine occurrence and moves the batch to `QUARANTINED_TERMINAL`.
6. Projections and integrations are at least once with stable contribution/message identity. They cannot change custody or fact truth.
7. Reconciliation continuously checks receipt-to-custody, batch terminal state, event-to-effect uniqueness, projection contributions, integration work, tombstone coverage, and restore readiness.

## 3.6 Control, portal, and audit flow

1. The same-origin BFF establishes an opaque server-side session; browser JavaScript never receives access or refresh tokens.
2. The BFF creates `AuthenticatedPortalContextV1` with principal, authentication context, active realm or explicit global plane, session generation, authorization epoch, and expiry.
3. Every route/action maps to an immutable descriptor and exact capability. Realm, purpose, target/scope, output profile, grant/JIT state, approval, authentication freshness, resource version, policy, restore, compatibility, and verification states are evaluated by a deny-by-default in-process kernel.
4. High-impact operations use immutable preview, exact scope digest, `If-Match`, stable `command_id`, required approvals, final transactional reauthorization, canonical audit, and durable job/outbox state.
5. Sensitive reads are buffered. No bytes leave the server until their access-audit transaction commits.
6. Canonical audit events advance a realm/global stream sequence and hash chain in the business transaction. Sealed segments and external checkpoints allow an independent verifier to detect gaps, alteration, forks, or rollback.
7. Verification failure creates an automatic scoped technical hold on affected privileged work and sensitive disclosure. Ordinary administration and break-glass cannot simply mark it passed.

## 3.7 Lifecycle, restore, and deletion flow

1. An authorized request uses exact typed realm-bound subject/scope resolution; ambiguous, stale, zero, incompatible, or cross-realm resolution cannot commit a barrier.
2. One transaction creates active suppression tombstones, advances the realm visibility watermark, creates deterministic store/destination targets, enqueues connector deletion, writes minimal audit, and moves the case to `BARRIER_COMMITTED`.
3. All readers either apply current tombstones at query time or are ineligible until their data and tombstone watermarks are current.
4. Physical deletion runs through typed adapters and is independently verified. Holds may block destruction but never restore ordinary visibility.
5. Restore uses a new isolated environment identity. Ordinary reads, endpoint receipts, connectors, exports, routing, and privileged mutation remain disabled.
6. Readiness requires current tombstones without gap/fork, authoritative acknowledged-set reconciliation, stable replay of recoverable missing batches, derived-store rebuild under the guard, deleted-negative probes, acknowledged-positive probes, audit/checkpoint validation, and no egress.
7. Readiness and actual production read/routing enablement are separate privileged decisions.

## 3.8 Migration and decommission flow

1. A signed one-shot read-only discovery CLI inspects only approved fixed adapters and produces a content-addressed evidence graph. It never executes discovered SQL/scripts or accepts arbitrary path/query/command input.
2. Every material legacy behavior, consumer, credential, configuration, report, integration, buffer, and archive dependency receives evidence, owner state, disposition, target requirement, validation, rollback, and removal proof.
3. During validation, exactly one `AuthorityEpochV1` value exists for each scope: `LEGACY_AUTHORITY`, `FROZEN_NO_AUTHORITY`, or `NEW_AUTHORITY`. `BOTH` is unrepresentable.
4. The new path writes only an isolated shadow namespace with no ordinary portal, projection, integration, export, lifecycle, or decision egress. Endpoints cannot reach both destinations.
5. Server-side comparison uses exact closed ranges/windows, deterministic compatibility projection, counted multiplicities, keyed digests, finite mismatch classes, and owner-approved expiring tolerances. Legacy is evidence, not the truth oracle.
6. Cutover uses immutable cohort/release/config/monitor manifests, progressive rings, complete positive-control-proven monitoring, explicit bake/coverage, automatic pause on hard safety signals, and human promotion.
7. Before rollback expiry and trust removal, a pre-authorized return to intact legacy authority may occur through a new higher epoch and a proved fence. After credential/session/permission/network trust removal begins, legacy rollback is closed.
8. Read-only/archive status requires agreement across UI/API, runtime, database permissions/state, sessions, jobs, network, restore, audit, and monitoring.
9. Final decommission requires layered credential/session/permission/secret/network removal, buffer disposition, residual monitoring with multiple sensors, expiring exceptions, an independent evaluator, and named owner approvals.

## 3.9 Durable-state separation

| Durable state class | Contains | Must not contain | Writer/authority |
|---|---|---|---|
| `MachineBootstrapState` | installation reservation, key references, enrollment status, opaque realm binding, clock/safety state | activity, raw source, outbox, cursor, receipt payload | identity/control writer |
| `ReleaseAndControlState` | release slots, manifests, ceiling/policy/snapshot/compatibility state, kill states | business activity or audit truth | stable launcher/control writer |
| `RealmEndpointStore` | minimized source effects, no-event facts, checkpoints, outbox, batches, attempts, receipts, migration/cleanup evidence | raw URL/path/profile, cross-realm state, policy authority | one endpoint business-store writer |
| `DiagnosticJournal` | closed value-free events/counters, permit and bundle lifecycle | raw strings, business progress, audit evidence | diagnostic writer |
| Server custody store | immutable batch/payload/receipt and narrow work seed | semantic visibility/deletion state on receipt | custody transaction role |
| Server fact/lifecycle store | event identity, typed facts, projections, tombstones, cases, targets | raw endpoint source, payload-derived realm | modular-monolith domain services |
| Canonical audit store | typed immutable events, stream heads, segments/checkpoints | free-form request/response, raw selectors, arbitrary logs | same business transaction + verifier read only |
| Migration evidence store | immutable observations, comparisons, owner decisions, cutover/trust-removal evidence | raw credentials/activity/executable text in shareable pack | migration control plane; independent evaluator read only |

## 3.10 End-to-end hidden-trust-gap checks

The architecture is considered internally connected only when all of these are true:

- the endpoint source authority is the exact user session, not the machine service;
- the first serialization outside Task Host contains no forbidden source value or reversible derivative;
- the endpoint cursor cannot move without the durable effect/no-event fact in the same transaction;
- a retry cannot mint a new event or batch identity;
- the server derives realm/install from authenticated context and enforces realm-first keys;
- the receipt cannot exist without exact committed custody bytes in its declared failure domain;
- materialization cannot commit under a stale lease or create a second ordinary effect;
- privileged portal mutation cannot commit without final authorization and canonical audit;
- sensitive bytes cannot leave before access audit commits;
- deletion suppression is visible before physical deletion and survives older restore/replay paths;
- restore cannot enable reads, receipts, connectors, exports, or stale grants before reconciliation;
- shadow data cannot reach ordinary business surfaces and cannot be relabelled as ordinary history;
- no endpoint can write both legacy and new destinations;
- legacy trust removal includes active sessions, permissions, secret copies, and network paths, not only software removal; and
- every automatic action can only pause, narrow, hold, or select an already authorized known-good state; it cannot create authority, credentials, or destructive approval.

---

# 4. Normative responsibility and dependency map

## 4.1 Component responsibility map

| Component | MUST own | MUST NOT own | Direct dependencies | Accountable engineering function |
|---|---|---|---|---|
| Contract Authority CLI/module | contract catalogue, strict schema bundles, scalar profiles, vectors, compatibility metadata, owners/runbooks | runtime network schema discovery, implicit defaults, business approval | contract standard, local validator tools | Architecture / Contract Governance |
| `Uam.TestData.Generator` | deterministic T1 models, fixed clock, seed, deterministic UUIDv7, lineage, canonical package | truth calculation, wall clock, hidden randomness, production-derived values | contract bundles only | Test Data Engineering |
| `Uam.TestOracle` | independent expected outcomes, state/cursor ledger, reconciliation | production transformation, identity, cursor, policy, storage, receipt, materialization code | declarative rules and canonical fixtures only | Independent Verification |
| `Uam.CanaryScan` | exact canary registry, schema-aware sink checks, encoding decoders, positive controls | one-tool absence claim, external upload, broad suppressions | package/evidence manifests | Privacy Verification |
| Repository/CI guard | project graph, forbidden APIs/packages, trust zones, exact locks, reproducibility, SBOM/provenance reconciliation | production signing key, untrusted-code authority, silent dependency download | source tree, approved package sources | Build/Release Engineering |
| MSI / enterprise deployment | service/task/launcher registration, protected roots/ACLs, bootstrap trust, repair/uninstall, baseline payload | live data, permanent bootstrap secret, arbitrary scripts, tenant code | signed release manifest | Endpoint Deployment |
| Stable launchers | verify path, ACL, signature/hash, release slot, storage compatibility; start exact process | network, source read, policy broadening, staging execution | `ReleaseManifest`, `EndpointStorageCompatibility` | Runtime Bootstrap |
| Coordinator Service | machine/realm state, session reconciliation, RunIntent, IPC peer validation, one business-store writer, batching/transport, bounded health | profile/source read, user-token creation, raw URL, arbitrary child, endpoint SQL | control state, authenticated User Host, endpoint store | Endpoint Runtime |
| User Host Launcher | verify ordinary interactive token/release; create protected User Host in same session; exit | source read, network, persistence, elevation, arbitrary path/args | MSI-owned task and release files | Endpoint Runtime |
| User Host | session lifecycle, release-owned root discovery, independent policy check, source binding, permit, minimized-page validation | machine persistence, upload, SQL, cross-session read, raw Task Host result | Coordinator IPC, Windows APIs, fixed Task Host | Session Runtime |
| Task Host | one fixed source capability, bounded raw handling, parse/match/minimize, value-free failure | network, child process, arbitrary path/SQL/script/plugin, Coordinator pipe, durable raw data | inherited handles, permit, compiled matcher/policy | Source Capability Owner |
| Endpoint store writer | all realm-store transactions, schema/migration, backup coordination, integrity, cleanup eligibility | network, raw source, second writer, automatic salvage/reset | SQLite provider/native profile | Endpoint Storage Reliability |
| Batch/transport worker | exact sealed body send, typed observation, receipt verification, same-identity retry | DB connection, batch rebuild after ambiguity, ACK inference from HTTP | writer actor and identity/network client | Endpoint Transport |
| Installation identity manager | local key creation, enrollment/renewal/retirement, finite assurance/status | private-key export, shared secret, realm from body, silent assurance downgrade | enterprise PKI/RA and server identity service | Device Identity |
| Compatibility evaluator | exact tuple match, evidence expiry, capability verdict, local safety intersection | closest match, family inference, runtime download, tenant-added support | signed manifest + observed inventory | Compatibility Authority |
| Diagnostic gateway/journal | closed catalogue, bounded value-free records, permit, bundle lifecycle | raw strings/objects/exceptions/dumps, business progress, audit substitution | diagnostic catalogue and signed permit | Diagnostics / Support Engineering |
| Server identity boundary | TLS/gateway validation, current credential status, immutable realm/install context | payload/header/subject/IP/host authority, stale soft allow | PKI/status service/gateway proof | Server IAM / Ingestion Security |
| Ingestion API | strict request admission, custody transaction invocation, receipt replay | semantic materialization, application lookup, integration, broad logging | identity context, contract profile, custody writer | Ingestion Service |
| Custody writer/store | immutable batch, exact payload, receipt, work seed in one transaction | processing state on receipt, payload mutation, external I/O | selected relational engine | Data Reliability |
| Work scheduler | short fair fenced leases using DB time; backlog/age | parsing in claim transaction, fairness claim from SQL hint | `ingest_work` and DB adapter | Materialization / SRE |
| Materialization worker | deterministic parse/validation plan, one final fenced transaction | stale-lease commit, first-slice partial success, network I/O in transaction | custody bytes, registry/reference contracts | Materialization Owner |
| Event identity ledger | one ordinary effect per `(realm_id,event_id)`, immutable effect/provenance digest | installation/partition broadening, overwrite, quarantine as permanent effect by default | materialization transaction | Data Correctness |
| Typed fact/projection modules | minimized facts, contribution ledger, reproducible aggregates | generic mutable JSON as normal model, endpoint SQL, cross-realm key | event ledger and domain contracts | Data Platform / Product Data |
| Integration outbox | stable typed message identity, at-least-once delivery, destination state | network in fact transaction, unregistered destination, downstream ACK as custody | fact transaction and connector registry | Integration Owner |
| Lifecycle controller | case state, exact resolver, barrier/tombstones, typed targets, holds, truthful limitations | fuzzy selectors, direct arbitrary SQL, visibility restoration under hold | fact stores, connector/export registry, audit | Lifecycle Engineering |
| Tombstone/visibility guard | monotonic realm sequence, gap/fork detection, read/egress suppression, restore authority | raw selector content, self-expiry, ordinary visibility decision | lifecycle barrier and all readers | Data Reliability / Security |
| Backup catalogue/restore orchestrator | chain/copy/key inventory, isolated restore, ACK/tombstone reconciliation, readiness evidence | timestamp-only expiry, pre-ready read/egress/receipt/routing | DB backups, receipt truth, tombstone authority, verifier | SRE / Data Reliability |
| Portal BFF/session | server-side tokens/session, CSRF, active realm/global context, route mediation | browser token storage, browser realm authority, generic public control API | enterprise IdP and authorization kernel | Portal Security |
| Authorization kernel | release-owned capabilities, closed conditions, JIT/grant/approval decisions, output obligations | wildcard admin, tenant policy language, external arbitrary data fetch | route catalogue, current domain state, DB time | Authorization Architecture |
| Command/job handlers | preview, scope digest, idempotency, version checks, reauthorization, durable job | generic CRUD/patch/SQL, browser-only state, stale preview execution | authorization, domain services, audit | Domain Workflow Owners |
| Canonical audit ledger | typed events, stream sequence, hashes, segment state, same-transaction success evidence | free-form logs, editable rows, semantic/legal overclaim | business transaction and authorization decision | Security Audit Engineering |
| Independent audit verifier | re-canonicalize, recompute, compare external checkpoint, report finite state | mutate audit/business state, self-clear holds, infer lawfulness | read-only ledger + independent checkpoint | Independent Verification / Audit |
| Legacy discovery CLI | fixed read-only adapters, hostile parsing, evidence graph, bounded absence statements | execute script/SQL, broad crawl, arbitrary command/path/query, permanent agent by default | approved scope reference and existing evidence sources | Migration Discovery |
| Shadow/comparator | isolated shadow storage, compatibility projection, exact ranges, mismatch classes | ordinary egress, legacy write-back, shadow promotion, legacy-as-oracle | legacy read adapter, new facts, comparison profile | Migration Data Correctness |
| Cutover controller | immutable plan/cohort/ring state, authority epoch commands, pause, rollback evidence | fictitious cross-system atomicity, automatic destructive rollback, credential creation | deployment, monitors, authority registry, audit | Migration / Release Operations |
| Archive/trust-removal controller | layered read-only proof, credential/session/permission/secret/network removal, residual cases | UI-only read-only, disable-only removal, legacy credential resurrection | IAM/PKI/DB/network/records owners | Decommission Engineering |
| Independent decommission evaluator | recompute predicates, evidence freshness, exception/owner state; emit PASS/HOLD | mutate source evidence, self-approve, claim legal completion | content-addressed migration evidence | Architecture Assurance |

## 4.2 Dependency rules

1. Deployable executables MUST NOT reference another deployable’s implementation assembly.
2. Domain modules MUST NOT reference infrastructure, ORM, HTTP, Windows service APIs, another module’s persistence model, or another module’s internal domain.
3. Boundary-generated models MUST remain in boundary adapters and MUST NOT become shared domain, persistence, or UI models.
4. No broad `Common`, `SharedKernel`, `Utilities`, reflection-discovered plug-in, generic command, or general extension bag is permitted.
5. Coordinator projects MUST NOT reference source collectors, user-profile APIs, user-token creation, PowerShell/scripting, SQL clients, or arbitrary process launch.
6. User Host and Task Host MUST NOT reference server transport, central SQL, general diagnostics exporters, service management, scripting, or dynamic capability discovery.
7. Unsafe/P/Invoke code MUST be isolated in an interop project with typed safe public APIs.
8. The oracle MUST have an architecture test prohibiting references to production decision/mapping/storage code.
9. Audit and business state MUST share a transaction for privileged mutations; diagnostics MUST remain a separate failure domain and MUST NOT affect business transactions.
10. Immutable custody truth MUST be separate from mutable work, retry, quarantine, visibility, lifecycle, and portal state.
11. Machine bootstrap/control state MUST be separate from realm business state. A golden image or unenrolled installation MUST contain no realm store, source progress, or identity credential.
12. Compatibility/control caches and diagnostics journals MUST NOT be hidden tables in the realm business store.
13. Migration evidence, shadow data, archive data, and ordinary production facts MUST remain separately identifiable and separately authorized.
14. A dependency/tool that parses, generates, analyzes, mutates, signs, packages, scans, or runs code is supply-chain code and requires an admission record.

---

# 5. Contract, protocol, schema, state-machine, compatibility, configuration, feature-flag, and kill-switch register

## 5.1 Common contract standard

Every boundary contract MUST record:

- immutable name and exact semantic version;
- producer, required consumers, accountable owner, and support owner;
- authenticated authority source and realm/global scope;
- privacy stage and permitted/forbidden fields;
- strict structural schema with local immutable reference closure;
- identifiers, digest, time, Unicode, enum, required/optional/null/default rules;
- compressed/uncompressed/item/depth/string/property/time/allocation limits;
- duplicate/unknown/extension behavior;
- transaction, idempotency, receipt, ambiguity, retry, conflict, and terminal meaning;
- state preconditions and authoritative transitions;
- rollout, compatibility, rollback, deprecation, expiry, and emergency block behavior;
- logs, metrics, diagnostics, audit, and evidence allowlists;
- valid, boundary, invalid, adversarial, canonical, and old/new vectors;
- dependency/tool identities, runbook, cleanup, and evidence requirements.

For JSON boundaries, the initial profile is strict UTF-8 without BOM, duplicate members, comments, trailing commas, wrong case, implicit defaults, non-finite numbers, generic extension bags, remote references, executable type names, or unbounded values. Closed objects reject unknown authority-bearing fields. A named extension point is allowed only with explicit namespace, key pattern, count, value bounds, preserve/drop/reject semantics, and a proof that it cannot create authority.

New UAM domain/wire identifiers use canonical lower-case UUIDv7. UUID timestamp bits are not business time, ordering, authorization, or evidence precision. SHA-256 is the current content/evidence digest profile; algorithm agility is explicit. Instants use an approved UTC profile with `Z`, while source precision and logical order remain separate fields. Unicode normalization is field-specific; canonicalization never silently normalizes strings.

## 5.2 Contract register

### 5.2.1 Foundation, test, and control contracts

| Contract | Status | Authority / critical invariant |
|---|---|---|
| `G0PackageManifestV1` | **ACCEPTED logical contract; implement now** | Classifies every input, binds seed/fixed clock/generator/oracle/schema/dependency digests, lineage, approvals, expiry/deletion, and package root. No placeholder in a published revision. |
| `TruthLedgerV1` | **ACCEPTED logical contract; implement now** | Independent expected outcomes for success, reject, defer, duplicate, quarantine, custody, validation, materialization, visibility, cursor, deletion, and restore. Never generated from actual output. |
| `CanaryRegistryV1` / `CanaryScanReportV1` | **ACCEPTED logical contract; implement now** | Exact fictional markers, declared sink/encoding coverage, positive controls, precise allowlists, zero mandatory misses. |
| `ContractCatalogueEntryV1` | **ACCEPTED logical contract; implement now** | Name/version/owner/authority/privacy/limits/vectors/compatibility/runbook. Cannot be candidate with `UNASSIGNED` blocking owners. |
| `SignedControlEnvelopeV1` | **ACCEPTED security properties; crypto profile provisional** | Content-addressed, purpose-specific key, audience/realm/release/ceiling binding, monotonic sequence, time validity, anti-rollback, exact schema. |
| `ProductPrivacyCeilingV1` | **ACCEPTED logical contract** | Release-owned finite registries and hard maximums. Tenant cannot add source, field, transform, destination, diagnostic, or capability. |
| `TenantPolicyV1` | **ACCEPTED logical contract** | References release-owned IDs and only disables/removes/coarsens/reduces/increases interval. No code, URL, path, regex, SQL, script, transform, or destination. |
| `ApplicationRegistryRevisionV1` | **ACCEPTED logical contract** | Realm-scoped immutable UUIDv7 identity and revisioned display/provenance claims. Names/external refs are not identity. |
| `MatcherSnapshotV1` | **ACCEPTED logical contract; URL-host subset only** | Immutable same-realm compiled predicates, opaque IDs, monotonic sequence, ceiling/rule/compiler digest; no display/owner/external data. |

### 5.2.2 Endpoint IPC and source contracts

| Contract | Status | Authority / critical invariant |
|---|---|---|
| `BootstrapHello`, `ServerHandoff`, `DedicatedHello`, `DedicatedWelcome` | **ACCEPTED logical state machine; physical codec provisional** | Handshake-only bootstrap, fresh one-use exact-logon handoff, kernel/process/token/release identity, no payload identity authority. |
| `RunIntentV1` | **ACCEPTED** | Coordinator scheduling intent bound to policy/ceiling/source/session/budget; not final source-read authority. |
| `CollectionPermitV1` | **ACCEPTED logical model; authenticator provisional** | User Host one-use short-lived authorization bound to source/transform/schema/fields/session/install/realm/policy/release/intent/nonce/budget. |
| `SourceBindingCandidateV1` | **ACCEPTED** | Dedicated local-only transient open-handle identity; no path/profile/account/SID/URL; Coordinator immediately keys and clears raw identity. |
| `EdgeMinimizedPageV1` | **ACCEPTED logical contract** | One run/source/generation/checkpoint/interpretation/capability; strictly ordered native IDs; event/no-event only; page owns advance; no partial commit. |
| `EdgePageFailureV1` | **ACCEPTED** | Value-free finite outcome/reason/stage; no proposed progress; checkpoint unchanged. |
| `CommitAckV1` | **ACCEPTED** | Issued only after the atomic endpoint transaction; retry of committed identity returns prior result. |
| `EndpointStorageCompatibilityV1` | **ACCEPTED logical contract** | One source of reader/writer schema truth, rollback readable range, migration class, native/runtime profile, compatible releases. |
| `ReleaseManifestV1` | **ACCEPTED logical contract** | Strictly increasing release sequence, package/file digests, architecture/signature requirements, bootstrap/storage/contract/ceiling/compatibility/SBOM/provenance evidence. |
| `PlatformCompatibilityManifestV1` | **ACCEPTED logical contract; tuple values provisional** | Exact release/OS/build/arch/runtime/native/browser/session/profile/network/EDR/power/evidence tuple. Zero or multiple matches means no permit. |
| `DiagnosticPermitV1` | **ACCEPTED logical contract; crypto/backend provisional** | Purpose/realm/target/release/ceiling/catalogue/level/event/bundle/byte/time bounds; no D3/raw mode or arbitrary field/command/path. |
| `DiagnosticEventV1` / `SupportBundleManifestV1` | **ACCEPTED logical contracts** | Closed value-free catalogue IDs and bounded primitives; bundle contains approved safe inventory/status only and is scanned before encryption. |

### 5.2.3 Server contracts

| Contract | Status | Authority / critical invariant |
|---|---|---|
| `AuthenticatedDeviceContextV1` | **ACCEPTED** | Server-created immutable realm/install/enrollment/credential/assurance/status context. Body, route, header, host, IP, subject/SAN cannot override. |
| `IngestBatchCommandV1` | **ACCEPTED logical contract; wire codec/compression provisional** | Stable batch ID, contract versions, exact body, count/size/digests; realm/install omitted as authority. |
| `CustodyReceiptV1` | **ACCEPTED logical contract; production failure-domain class provisional** | Matching batch/content/wire digests and `DURABLY_RECEIVED`; created and returned only after custody commit. |
| `WorkLeaseV1` | **ACCEPTED** | Realm-first work key, random token, incrementing fence, database time, bounded expiry. Stale authority cannot commit. |
| `MaterializationPlanV1` | **ACCEPTED internal contract** | Deterministic parsed plan outside lease transaction; final transaction either whole-batch materialization or terminal quarantine. |
| `DeletionRequestV1` / `DeletionCaseStatusV1` | **ACCEPTED mechanism; policy fields human-owned** | Exact typed selector/scope/policy revision/idempotency; technical status never claims legal completion. |
| `RestoreReadinessDecisionV1` | **ACCEPTED mechanism** | Exact engine/schema/realm/tombstone/receipt/fact/projection/connector/audit/evidence results; ordinary read enablement remains separate. |

### 5.2.4 Portal, authorization, and audit contracts

| Contract | Status | Authority / critical invariant |
|---|---|---|
| `AuthenticatedPortalContextV1` | **ACCEPTED** | Server-created principal/authentication/active realm or explicit global plane/session generation/authorization epoch/expiry. |
| `RouteAuthorizationDescriptorV1` | **ACCEPTED** | Every route/background phase maps to exact capability, scope, purpose, output, risk, audit, and state requirements. |
| `CapabilityDefinitionV1` | **ACCEPTED** | Release-owned exact resource/action; no wildcard/default superuser. |
| `PurposeDefinitionV1` | **ACCEPTED mechanism; registry content human-owned** | Approved immutable purpose ID/revision and permitted capability/output/lifecycle. No free-text authority. |
| `ScopeManifestV1` / `FilterSnapshotV1` | **ACCEPTED** | Server-resolved immutable typed target scope. Browser list/page is not execution authority. |
| `GrantV1` / `JitRequestV1` | **ACCEPTED mechanism; real assignments/durations human-owned** | Principal/realm/capability/scope/purpose/time/approval/authentication/epoch binding. |
| `ApprovalRequestV1` / `ApprovalDecisionV1` | **ACCEPTED** | Approval authorizes exact immutable request/preview, not a changed command or direct business effect. |
| `AuthorizationDecisionV1` | **ACCEPTED canonical decision object** | Final allow/deny with actor/context/capability/purpose/target/grant/approval/policy/output/result/reason/time/digest. |
| `ImpactPreviewV1` | **ACCEPTED** | Exact command/resource/version/scope/digest/count/risk/approval/limitation/recovery snapshot; stale preview cannot execute. |
| `PortalCommandV1` / `CommandResultV1` / `JobStatusV1` | **ACCEPTED** | Stable `command_id`, `If-Match`, preview digest, finite reason, durable job, phase reauthorization, idempotent result. |
| `AuditEventV1` | **ACCEPTED canonical ledger contract** | Typed immutable event referencing authorization decision, stream sequence, previous hash, event hash; no free-form payload or dynamic exception. |
| `AuditCheckpointV1` / `VerificationReportV1` | **ACCEPTED mechanism; key/store/freshness human/CLI-gated** | Independent re-canonicalization, sequence/hash/Merkle/checkpoint continuity; finite PASS/GAP/ALTERED/FORK/STALE/INCOMPLETE/UNAVAILABLE. |
| `AuditEventPortalProjectionV1` | **ACCEPTED read projection only** | Redacted purpose-bound view of canonical audit; never a second write schema or source of truth. |

### 5.2.5 Migration and decommission contracts

| Contract | Status | Authority / critical invariant |
|---|---|---|
| `LegacyEvidenceGraphRevisionV1` | **ACCEPTED logical contract** | Immutable observations/edges/source scope/time/access/limitations/digests; no raw credential/activity/executable text in shareable evidence. |
| `DispositionDecisionV1` | **ACCEPTED mechanism; decisions human-owned** | `PRESERVE_APPROVED_OUTCOME`, `DELIBERATELY_CHANGE`, `RETIRE`, or `INVESTIGATE_QUARANTINE`, with owner/target/test/rollback/removal proof. |
| `AuthorityEpochV1` | **ACCEPTED sole business-authority truth** | Exactly one of legacy/frozen/new and a monotonic sequence. `BOTH` unrepresentable. |
| `ComparisonResultV1` | **ACCEPTED mechanism; semantics/tolerances human-owned** | Exact profile/range/closure/canonicalization/digest/mismatch/tolerance/defect evidence. Unknown material mismatch blocks. |
| `CutoverPlanV1` | **ACCEPTED mechanism** | Immutable cohort/release/config/monitor/fence/rollback/owner/evidence plan; change starts new generation. |
| `CutoverCohortStateV1` | **ACCEPTED operational state** | References authority epoch but does not redefine it. Human promotion; hard-signal pause. |
| `CredentialRemovalCaseV1` | **ACCEPTED mechanism** | Owner/consumer map, disable/revoke, session termination, permission/ownership cleanup, secret-copy removal/rotation, path denial, monitoring. |
| `BufferDispositionRecordV1` | **ACCEPTED mechanism; disposition human-owned** | Drain-before-fence, typed-transform-after-proof, quarantine/hold, or human-approved discard/expiry. Raw SQL never target code. |
| `ResidualExceptionV1` | **ACCEPTED mechanism** | Exact scope/risk/owner/containment/action/evidence/review/expiry; no auto-renew. |
| `DecommissionAcceptanceRecordV1` | **ACCEPTED mechanism; final approval human-owned** | Recomputed gate/evidence/exception/owner state, archive/limitations, technical PASS/HOLD only; no legal completion claim. |

## 5.3 Logical schema and key register

| Domain | Logical entities / tables | Required keys and constraints |
|---|---|---|
| Endpoint source | source, source generation, checkpoint, record effect, overlap witness, page run | all keys begin `(realm_id, installation_id)`; source/generation immutable; natural record key `(realm_id,installation_id,source_id,source_generation_id,native_visit_id)`; one effect per natural key |
| Endpoint outbox | event, batch, batch membership, attempt, receipt, cleanup tombstone | `event_id` minted once and reused; sealed batch immutable; `PREPARED` attempt before network; receipt digest match; cleanup eligibility conjunctive |
| Machine control | installation identity, credential status, release slots, control artefact cache, compatibility state | separate from realm store; no activity; monotonic sequences; exact digest binding |
| Server custody | `ingest_batch`, `ingest_payload`, `custody_receipt`, `ingest_work` | immutable batch/payload/receipt separated from mutable work; same batch/digests replays; mismatch conflicts; realm-first keys |
| Server ordinary effects | event identity ledger, typed fact tables, projection contributions, integration outbox | unique `(realm_id,event_id)`; installation/source/batch are provenance; same digest retry; conflicting digest/provenance holds; one contribution/message effect |
| Lifecycle | policy revisions, subject-resolution manifests, deletion cases, tombstones, visibility epochs, targets, holds, connector/export objects | exact realm-scoped selector/scope; monotonic tombstone sequence; barrier transaction precedes deletion; stable target idempotency; explicit limitations |
| Backup/restore | backup catalogue, chain/copy/key/log range, receipt coverage manifest, restore run, readiness decision | explicit realm scope/digests/watermarks; receipt relation authoritative; restored environment new identity; no pre-ready ordinary authority |
| Authorization | route catalogue, capabilities, purposes, roles, assignments, grants, approvals, scope manifests, authorization decisions, commands, jobs | immutable revisions/digests; exact realm/global scope; stable command/idempotency; no wildcard capability; current version/epoch checks |
| Audit | events, stream heads, segments, checkpoints, verification reports, audit exports | unique stream sequence; previous/event hash; sealed contiguous segment; external checkpoint lineage; source rows immutable; corrections are linked events |
| Migration | evidence observations/edges, dispositions, comparison runs/results, authority epochs, cutover plans/cohorts, credential cases, buffers, exceptions, acceptance | content-addressed revisions; authority uniqueness; shadow namespace; monotonic epochs; owner decisions immutable; expired exception blocks |

## 5.4 Protocol and state-machine register

| State machine | Authoritative states / transitions | Non-negotiable invariant |
|---|---|---|
| Dataset | `Draft -> Validated -> Approved -> Published -> Retired/Revoked` | Published revision immutable; T2/T3 approval/expiry/deletion required; T3 disabled by default. |
| Contract | `Draft -> Candidate -> Active -> Deprecated -> Retired/Frozen` | No candidate without owner, strict vectors, limits, compatibility, and runbook. |
| Policy | candidate -> structural reject / unsupported quarantine / `SafetyHold` / verified-pending / active / superseded / expired-disabled | Invalid candidate grants nothing; security-significant failure holds; lower revision never activates; active invalid/expired disables. |
| Coordinator | `Starting -> SelfChecked -> Listening -> Running -> Draining -> Stopped/SafeDisabled` | Collection only after token/release/policy/store/IPC checks. |
| User Host | `Launched -> Verified -> Connected -> Ready -> Paused/Draining -> Exited` | Lock/disconnect/unknown pauses; fresh handshake after service restart. |
| Task Host | `CreatedSuspended -> RestrictedAndJobBound -> PermitVerified -> Running -> Result/Cancelled -> Exited` | No resume before all controls; no silent weaker profile. |
| Edge source | unseen -> discovered -> baseline pending -> active / unsupported / hold -> absent/suspect/closed/new generation | Processing upgrades do not create source generations; uncertainty cannot advance old lineage. |
| Edge page/cursor | intent -> permit -> snapshot bound -> page prepared -> commit pending -> committed -> acked | Whole page or none; cursor and effect/no-event commit together; retry returns same result. |
| Endpoint batch | ready -> building -> sealed -> attempt prepared -> send observed -> receipted / definite no-custody / ambiguous / hold -> cleanup eligible -> purged/tombstone | Only valid receipt acknowledges; ambiguity replays same exact batch. |
| Release | proposed -> validated -> built A/B -> repro compared -> evidence complete -> signed -> verified -> ring -> current/rollback/revoked | Same digest promoted; lower-sequence rollback prohibited; incomplete/mixed/stale/downgraded never executes. |
| Credential | bootstrap -> staged -> active -> retiring -> retired/expired/revoked/decommissioned; conflict -> duplicate hold | No shared key or silent fallback; realm transfer creates new lineage. |
| Compatibility | candidate -> verified active cache -> observed environment -> exactly one match -> qualified permit; else unknown/no permit | Support is exact and expiring; technical `QUALIFIED` is not human `SUPPORTED`. |
| Server custody | request -> custody transaction -> durably received -> work ready -> leased -> materialized / terminal quarantine / hold | Receipt after commit only; stale lease cannot commit; one final ordinary effect. |
| Deletion | request -> exact resolve -> barrier committed -> deleting/verifying -> complete / partial-held / complete-with-limitations / failed | Suppression precedes physical deletion; technical state is not legal outcome. |
| Restore | isolated -> base recovered -> tombstones/ACKs reconciled -> derived rebuild -> probes -> ready technical -> separate read enablement | No read/egress/receipt/stale authority before readiness. |
| Portal session | unauthenticated -> authenticated -> realm context -> active -> expired/revoked/logout | Realm switch creates new context and cache/session generation. |
| JIT/approval | request -> review -> approved/rejected -> grant active -> expired/revoked; command approval separate | Approval of exact content is not execution; changed content invalidates. |
| Portal command/job | preview -> execute candidate -> final reauth -> transaction -> accepted job -> phase work -> terminal / paused / killed / failed | Same command ID/digest one effect; high-risk phases reauthorize. |
| Audit | event -> stream append -> segment open -> sealed -> checkpointed -> verified / gap/altered/fork/hold | Source event immutable; verification failure does not self-clear. |
| Migration authority | legacy -> frozen -> new; optional pre-trust new -> frozen -> legacy via higher epochs | `BOTH` impossible; legacy return closes before trust removal. |
| Cutover | draft -> prepared -> shadow/reconciled -> ring ready -> promoted/paused/rolled back -> trust removal -> archive/decommission | Ring/comparison state never implies authority. |
| Credential removal | inventoried -> owner/consumer resolved -> disabled/revoked -> sessions terminated -> permissions/secrets/paths removed -> observed -> verified | Disable/revoke alone is incomplete. |
| Final decommission | evidence ready -> evaluator PASS/HOLD -> owner approvals -> accepted technical -> monitoring/late finding reopening | Evaluator cannot self-authorize; late finding creates linked case. |

## 5.5 Compatibility register

1. Compatibility is the intersection of vendor-serviced platform, release-owned representable capability, exact qualified tuple, unexpired evidence, active release/policy/identity, no safety hold, and tenant narrowing.
2. Missing, conflicting, unknown, stale, unsupported, or multiply matching facts produce no collection or privileged capability.
3. Wildcards or build ranges require a proved equivalence class. “Windows 11,” “current Edge,” “third-party EDR,” and “current/previous” are not executable support rules.
4. The first candidate endpoint tuple remains one exact Windows 11 Enterprise 25H2 x64 serviced build, one exact self-contained `win-x64` payload, one exact Edge Stable build/source capability, one console session, one local non-roaming profile, one Defender policy state, and direct mTLS. This is **PROVISIONAL / CLI EXPERIMENT**, not a support promise.
5. Contract support windows are family-specific. Co-installed local IPC may target current plus explicitly authorized rollback compatibility; endpoint/server ingress may temporarily target current plus previous major. Exact windows require owner and fleet/offline evidence.
6. `EndpointStorageCompatibilityV1` is the single source of reader/writer schema and N/N-1 rollback truth. Release and compatibility artefacts reference its digest.
7. Evidence expires at the earliest relevant vendor, release, dependency, support, source capability, incident, exception, or deprecation boundary.
8. `QUALIFIED` is a technical state. `SUPPORTED` is a **HUMAN DECISION** with staffing, service, deprecation, licensing, and risk commitments.

## 5.6 Configuration authority register

| Configuration class | Authority | May do | Must not do |
|---|---|---|---|
| Product ceiling | separately authorized release | define finite representable sources/fields/transforms/destinations/capabilities/diagnostics/hard denies/maxima | accept tenant executable logic or silent runtime discovery |
| Tenant policy | realm governance authority | select release-owned IDs and narrow fields, precision, frequency, scope, lookback, output, diagnostics | add source/path/URL/regex/SQL/script/algorithm/destination or exceed ceiling |
| Emergency narrowing | product or realm emergency authority | disable or reduce capability under incident | broaden, restore lower revision, self-clear without recovery evidence |
| Local safety | endpoint runtime | stop source, upload, diagnostics, release, or capability on local failure | authorize new work, extend expiry, change realm, override signed policy |
| Registry/rule snapshot | registry publication authority | publish approved same-realm compiled predicates and opaque IDs | include names/owners/external keys/raw observations; infer rule from usage |
| Release/compatibility | release and compatibility authorities | select exact signed digest and exact qualified tuple | execute staging/mixed/downgraded/unknown build or infer support by proximity |
| Diagnostic permit | diagnostic authority under product ceiling | enable a bounded precompiled safe signal/bundle profile | add arbitrary fields, commands, files, paths, URLs, dumps, or destinations |
| Portal role/grant/approval | IAM/product governance through typed records | bind exact capabilities, scopes, purposes, time, approvals | wildcard admin, browser/IdP role as direct route authority, tenant policy language |
| Migration plan/tolerance | migration/data owners through immutable decisions | bind exact comparison/cutover semantics, scope, expiry, rollback | suppress hard invariants, unknown mismatch, or create ordinary business authority |

## 5.7 Feature-flag and kill-switch register

**Invariant:** flags and switches may only narrow, pause, disable, select an already authorized known-good state, or place a scope in hold. They cannot bypass realm, privacy, durability, receipt, audit, tombstone, restore, release, or authority-epoch invariants.

| Switch | Scope | Allowed effect | Clear authority / evidence |
|---|---|---|---|
| `source.<id>.enabled` | realm/install/source capability | disable one source/capability | higher valid policy/release plus source incident recovery evidence |
| `collection.global.enabled` | product or realm | stop new collection; retain durable data | product/realm recovery authority; no outstanding safety hold |
| `upload.enabled` | realm/install | pause transport; retain batches | identity/network/receipt recovery evidence |
| `diagnostics.level` | target/release | reduce to D0 or disable enhanced permit | permit authority; expiry/revocation automatic |
| `release.freeze` | product/ring | block activation/promotion | release authority after integrity/rollback evidence |
| `compatibility.hold` | exact tuple/realm | deny capability permits | compatibility authority after current requalification |
| `portal.detail.enabled` | realm/capability | keep detail structurally absent/disabled | approved purpose/field/access/retention and B05 gate |
| `portal.export.enabled` | realm/capability | disable new export/retrieval | export purpose/access/audit/lifecycle recovery evidence |
| `privileged.mutations.enabled` | realm/global stream | hold privileged commands | audit/verifier/identity/restore incident authority; cannot bypass audit |
| `lifecycle.sweep.enabled` | policy/store | pause retention/deletion execution | records/lifecycle authority after resolver/hold/adapter recovery |
| `restore.read.enabled` | isolated restored environment | default false; separate final enable | accepted readiness decision plus privileged audit and human routing approval |
| `shadow.ingest.enabled` | migration cohort/surface | disable shadow intake | migration authority after isolation/reconciliation recovery |
| `cutover.pause` | cohort/ring | freeze promotion/work; never create alternate authority | automatic on hard safety signals; human resume after evidence |
| `legacy.writer.enabled` | pre-trust migration scope only | existing legacy authority remains or is disabled according to epoch | phase-bounded authority command; cannot be re-enabled after trust removal without baseline change |
| `archive.read.enabled` | archive realm/scope | default false until layered read-only and purpose/access pass | archive owner plus BFF/audit/restore readiness evidence |
| `decommission.hold` | system/component/cohort | prevent irreversible removal | independent evaluator and affected owner approvals |

No production code may contain or honor a `skipAudit`, `ignorePurpose`, `allowCrossRealm`, `bypassApproval`, `disableCsrf`, `trustBrowserRealm`, `acceptUnknownReceipt`, `advanceOnError`, `restoreWithoutVerify`, `executeLegacySql`, or equivalent flag.

---

# 6. Security, privacy, realm-isolation, and incident-response baseline

## 6.1 Threat model and trust assumptions

| Threat / failure domain | Baseline treatment | Residual limitation |
|---|---|---|
| Malicious or compromised ordinary user process in another session | Exact logon/session identity, held process handle, one-use pipe, peer release validation, same-session launch, cross-session hostile tests | Same-user processes in the same session may read some same-user-readable data; Task Host is not a complete confidentiality sandbox. |
| Compromised Task Host input/source | Fixed capability, no arbitrary code/path/SQL, restricted token/job/handles/network, permit binding, bounded parser and result, whole-page fail closed | Raw source necessarily exists briefly in Task Host memory; kernel/admin/EDR/hypervisor may observe memory. |
| Compromised Coordinator | Low privilege, no profile/source APIs, no user-token creation, strict IPC and minimized-only schema, architecture tests | Coordinator still controls durable local state and transport; a malicious signed release remains high consequence. |
| Malformed source/contract payload | Strict parser, closed schemas, local references, bounds on bytes/items/depth/time/allocation, finite error taxonomy | Parser/provider/library defects remain possible; fuzz and differential tests reduce but do not remove risk. |
| Credential/key theft or cloning | Per-installation asymmetric key, no fleet secret, non-export target, status checks, duplicate hold, purpose-separated keys | TPM/attestation coverage and operational recovery are unproved; privileged malware may misuse an authorized key. |
| Realm confusion | Server-created authenticated contexts, realm-first keys/caches/jobs, negative tests, no payload/browser authority | Incorrect identity-service configuration or privileged database bypass remains possible and must be tested/audited. |
| Replay/ambiguous network | Stable event/batch IDs, sealed exact bytes, durable PREPARED attempt, matching receipt, central uniqueness | Correlated server/backup failures can invalidate an overbroad receipt class; production cleanup remains disabled until proved. |
| Database/operator error or compromise | Least privilege, immutable custody/audit semantics, RLS defense in depth, external audit checkpoints, restore reconciliation | Superusers/host admins can still alter systems; independent administration can collude or fail. |
| Release/supply-chain compromise | Locked exact inputs, hostile CI zones, reproducible unsigned payloads, file manifest, SBOM/provenance reconciliation, separate signing, same-digest promotion | A compromised authorized signer or malicious reviewed source can produce coherent malicious artifacts. |
| Diagnostic/support leakage | Closed enums/primitives, no raw strings/objects/dumps, separate journal, signed narrowing permits, deterministic scanned bundles | Supportability is intentionally limited; safe signals may be insufficient for rare production-only faults. |
| Portal/session compromise | Server-side tokens, same-origin BFF, CSRF, session generation, final server authorization, purpose/output obligations | A compromised BFF/browser can misuse current authority; human approvals can still be harmful or coerced. |
| Audit alteration/rollback | Same-transaction typed audit, stream sequence/hash, sealed segments, independent re-verification and checkpoints | Hashes/signatures do not prove semantic truth, lawfulness, completeness before checkpoint, or non-collusion. |
| Deleted-data resurrection | Barrier/tombstone first, reader eligibility, current tombstone recovery, authoritative ACK reconciliation, isolated restore | Hidden/manual external copies and untracked consumers can remain outside UAM control. |
| Legacy residual trust | One authority, no dual-write, layered credential/session/permission/secret/network removal, multiple residual sensors | Unreachable devices, dormant consumers, alternate routes, and unmanaged copies may evade observation. |

## 6.2 Privacy baseline

1. **FACT.** The product privacy ceiling is release-owned; tenant policy only narrows.
2. Every source, field, transform, output, diagnostic, destination, support entry, portal route, export, and migration comparison dimension MUST be explicitly represented in a closed registry.
3. Raw source values MUST exist only in the smallest approved process and duration. For the first source, raw URL stays in the Task Host and is neither copied nor transformed into a reversible endpoint diagnostic/dedupe token.
4. Candidate construction MUST build a new minimized object from approved primitives. It MUST NOT clone/redact a broad source DTO.
5. Structural suppression and product hard-deny execute before application assignment. Tenant policy can add denies, not remove product denies.
6. Ambiguous application matches produce no assignment. Unmatched, denied, invalid, unsupported, deferred, retry, and safety-hold outcomes are distinct and value-free.
7. Endpoint, server, portal, audit, diagnostics, migration, and evidence schemas MUST exclude free-form request bodies, arbitrary exceptions, raw selectors, URL/path/profile/account text, secret material, and generic extension dictionaries.
8. Metrics use finite dimensions. Exact realm, principal, source, application, command, case, URL, path, digest, or signature are not global metric labels.
9. Person/activity detail, subject identity, site/domain output, time precision, retention, audit identity, export fields, and comparison identity remain **HUMAN DECISION**.
10. A privacy canary escape is a release-blocking incident candidate, not a suppressible test nuisance.

## 6.3 Realm and authority isolation

- Realm/install/user/session/global authority is injected by authenticated boundaries and remains immutable for one operation.
- Every realm-aware primary, unique, foreign, cache, lease, job, audit-stream, export, deletion, restore, migration, and evidence key begins with or is cryptographically bound to its realm scope.
- Server repositories MUST require authenticated realm context rather than accepting realm as a caller-selected ordinary parameter.
- Realm-scoped and product-global APIs, capabilities, audit streams, caches, routes, and jobs are distinct. Missing realm never means global.
- Cross-realm oversight, if ever approved, requires a separate product-global or case-bound capability and immutable multi-realm scope manifest.
- Connection-pool/session context, RLS, caches, background jobs, exports, restore environments, audit queries, and migration comparison paths receive explicit hostile cross-realm tests.
- Wrong-realm policy, snapshot, permit, credential, batch, event, target, approval, tombstone, checkpoint, archive, or comparison evidence fails closed and enters the appropriate security hold.

## 6.4 Key and credential purpose separation

The following keys/credentials MUST be distinct in purpose, lifecycle, authority, storage, rotation, revocation, and evidence:

- installation/device authentication key;
- enrollment/bootstrap authorization;
- endpoint data-encryption/wrapping key, if selected;
- source-locator HMAC key;
- local IPC/permit transcript key profile;
- release/AuthentiCode signing key;
- signed-control product, tenant, compatibility, diagnostic, and emergency keys;
- optional updater/TUF keys;
- audit-checkpoint/verifier signing key;
- support-bundle recipient/wrapping key;
- comparison-run keyed-digest key;
- provenance/attestation signing key;
- server/gateway workload credentials; and
- legacy credentials being removed.

No key may be reused merely because the same crypto library or HSM supports it. A software-key prototype for local payload protection does not authorize a software fallback for device authentication. A revoked legacy credential cannot be reactivated as rollback.

## 6.5 Security and privacy invariants

| ID | Fitness invariant |
|---|---|
| S-01 | Forbidden source values never cross Task Host output or enter logs, diagnostics, evidence, durable storage, transport, support, portal, or audit. |
| S-02 | One user/session/realm/installation/authority epoch cannot submit, view, mutate, delete, export, restore, or approve as another. |
| S-03 | Tenant, administrator, migration, diagnostic, or feature configuration cannot broaden the product ceiling or create executable authority. |
| S-04 | Unauthorized, incomplete, stale, frozen, mixed, tampered, or downgraded release/control state never executes. |
| S-05 | A privileged mutation cannot commit without final authorization and canonical audit evidence in the same transaction. |
| S-06 | Sensitive read bytes cannot leave the server before their access audit commits. |
| S-07 | A credential clone, wrong realm, expired/revoked key, or stale status cannot authorize a request. |
| S-08 | A restored environment cannot issue ordinary reads, receipts, exports, connectors, or privileged changes before readiness. |
| S-09 | Shadow data cannot become ordinary business truth or ordinary egress. |
| S-10 | After legacy trust removal, no code path may recreate or reuse the old endpoint-to-database trust without a formal baseline change. |

## 6.6 Incident-response baseline

| Incident class | Immediate automatic containment | Required evidence and recovery | Re-enable authority |
|---|---|---|---|
| Privacy canary or forbidden-value escape | stop affected capability; stop bundle/export; preserve immutable first failure; no automatic retry | exact source/release/contract/sink scope, positive-control state, containment scan, affected artifact deletion/hold, code/config fix, full requalification | Product Security + Privacy incident authority; human risk response where required |
| Cross-session or cross-realm acceptance | stop affected realm/product plane; revoke active permits/sessions where safe; block dependent gates | request/process/token/context history, cache/job/DB scope, adversarial reproducer, identity/realm correction, negative campaign | Security/IAM incident authority; no ordinary admin self-clear |
| Source mutation/browser corruption | kill source capability and ring; retain checkpoint; do not advance | filesystem trace, browser integrity, exact binary/provider/environment, cleanup, corrected source profile, G2 rerun | Endpoint Security + Source owner |
| Cursor-ahead, missing effect, duplicate effect, identity conflict | stop collection/upload/materialization for affected scope; retain all data; no cleanup | model/history/replay, store snapshot, failpoint, identity ledger reconciliation, G5/B04 rerun | Data Reliability + Architecture |
| False or conflicting receipt / acknowledged data missing | disable endpoint cleanup globally for affected class; hold receipt class and restore readiness | exact custody rows/bytes/receipt, failure-domain and backup history, replay source, restore proof | Data Reliability + Product Risk |
| Unauthorized/tampered release or control artefact | freeze activation, stop new permits, select only independently verified known-good state | file/manifest/signature/provenance evidence, key/status incident, reproducibility, rollback/repair, clean inventory | Release/Signing/Security authority |
| Credential clone/revocation/status failure | deny/hold all conflicting copies; preserve unacknowledged data | status/version, challenge, credential map, duplicate evidence, re-enrollment/retirement and cleanup | Identity Security/PKI authority |
| Diagnostic permit or support-bundle violation | expire/revoke permit, stop enhanced diagnostics, delete/hold artifacts, canary scan | permit/target/catalogue/config, bundle manifest/digests, access/custody/delete evidence | Support Security + Privacy |
| Audit gap/alteration/fork/stale checkpoint | automatic affected realm/stream privileged-mutation and sensitive-disclosure hold | independent verifier report, external checkpoint, DB/host evidence, gap declaration/repair epoch, restore comparison | Independent incident authority; break-glass cannot mark integrity passed |
| Deleted data visible / restore readiness false | block all ordinary reads/egress/receipts for environment; preserve state | tombstone/ACK/reader/projection/connector/backup history, negative/positive probes, corrected restore | Lifecycle/Data Reliability/Security + separate routing approval |
| Legacy residual successful write | stop cutover/decommission, freeze affected authority, terminate path/session where authorized | credential/session/network/component evidence, source scope, buffer and authority epoch reconciliation | Migration/Security/DB/Network authorities |
| Evidence harness or cleanup failure | no product pass or fail; quarantine run; retain first failure | harness positive-control repair, environment cleanup/revert, clean rerun with new evidence generation | Verification owner |

Incident actions may safely narrow or stop. They MUST NOT create new credentials, lower sequences, discard unacknowledged data, promote shadow facts, delete audit history, waive tombstones, or claim legal completion.

---

# 7. Domain baselines

## 7.1 Endpoint acquisition and durability baseline

**ACCEPTED.** The endpoint consists of the Coordinator/User Host/Task Host topology; raw source access is session-owned; Edge discovery is bounded to release-owned local roots; source identity is UAM-owned and path/name-independent; source generation changes only on observable source discontinuity; collector runtime and privacy interpretation are separate; the first URL profile is strict ASCII HTTP(S) DNS-host exact/suffix matching; the page is the progress authority; one-writer WAL commits effect/progress atomically; at-least-once batching and stable identity produce one final effect.

**PROVISIONAL / CLI EXPERIMENT.** Exact service account/privileges/SDDL/task XML, IPC codec/transcript/limits, SQLite provider/native build/configuration, resource/page/overlap/batch limits, encryption/key wrapping, Unicode IDN, PSL, non-default ports, disk scratch, first-run lookback, supported Edge/Windows/VDI estate, and ACK cleanup grace.

**REJECTED.** Coordinator source access, arbitrary Task Hosts, raw URL escape, live main/WAL/SHM copy, read/write fallback, VSS, browser extension/CDP, recursive profile crawl, timestamp cursor, URL-derived identity, partial page commit, routine historical reinterpretation, and silent advance past uncertainty.

## 7.2 Release and supply-chain baseline

**ACCEPTED.** Enterprise MSI owns the stable privileged boundary. Payloads are immutable and side-by-side; launchers independently verify path, ACL, hash, signature, release manifest, architecture, modules, storage compatibility, and slot. Build inputs are exact; untrusted code has no secrets/signing/deployment authority; canonical unsigned payloads are challenged in two clean builds; SBOM/provenance are reconciled to final files; signing is digest-bound and separate; the same signed digest moves through rings; rollback is a higher sequence to known-good bytes.

**PROVISIONAL / HUMAN DECISION.** Installer tool/EULA, code-signing CA/timestamp/key custody, exact .NET patch, package mirror, CI platform, ring sizes/bake, release support window, and optional autonomous updater.

**REJECTED.** Execute from staging, mutable `current` directory, in-place overwrite, lower-sequence rollback, environment rebuild, floating dependency/action, privileged monolithic self-updater, autonomous destructive migration, and updater bootstrap/root self-modification.

## 7.3 Installation identity and network baseline

**ACCEPTED.** Each specialized installation creates a unique local asymmetric key after imaging. Enrollment uses a one-use short-lived realm/audience-bound authorization. The server assigns authoritative realm/install/epoch/status. Private keys never appear in images, packages, PFX, logs, support, evidence, or servers. Direct origin mTLS/L4 pass-through is the default. Revocation, expiry, wrong realm, clone, duplicate credential, and stale status fail closed. Realm transfer is decommission plus new enrollment/store lineage.

**PROVISIONAL / HUMAN DECISION.** Enterprise CA/MDM/RA, TPM/vTPM coverage and attestation, software-key exceptions, algorithms/EKU/lifetimes, status-cache freshness, proxy/PAC/VPN/TLS inspection, L7 gateway assertion, golden-image process, and support scope.

**REJECTED.** Fleet secrets, shared API keys, image enrollment, private-key export, payload-derived realm, silent software fallback, plain forwarding-header authority, TLS validation disablement, broad EDR exclusions, and shared identity for pooled nonpersistent VDI.

## 7.4 Diagnostics and support baseline

**ACCEPTED.** A compile-time release-owned catalogue defines every diagnostic event, field, metric, span, bundle entry, cardinality formula, owner, and lifecycle. Endpoint diagnostic APIs accept closed enums and bounded primitives only. Task Hosts do not log, dump, trace, bundle, or export. Diagnostics use a separate journal and cannot affect business transactions. Enhanced diagnostics require a signed narrowing permit. Support bundles are deterministic, schema-checked, canary-scanned, encrypted after validation, and contain only approved safe versions/counts/statuses/fingerprints.

**PROVISIONAL / HUMAN DECISION.** Backend/vendor, OpenTelemetry packages/custom collector, retention/access, safe fingerprint policy, bundle encryption/recipient, permit crypto, series budgets, support levels, and staffing.

**REJECTED.** Raw logs, arbitrary strings/objects/exceptions, URLs/paths/users/SIDs, default auto-instrumentation field sets, generic collector redaction as primary boundary, process dumps, remote debugger, arbitrary support commands/files, or diagnostics as audit.

## 7.5 Compatibility baseline

**ACCEPTED.** Compatibility is exact, evidence-bound, expiring, and deny-by-default. A tuple binds release/package, OS/build/edition/update, architecture/RID/native modules, runtime/SQLite source, browser build/source capability, session/profile topology, network, EDR policy, power/lifecycle, and predecessor evidence. Zero/multiple/stale matches mean no capability. `QUALIFIED` is technical; `SUPPORTED` is human-owned.

**PROVISIONAL.** First exact tuple, evidence validity, current/previous windows, exception/deprecation policy, recurring lab cadence, physical power/ARM64/VDI/proxy/third-party EDR coverage.

**REJECTED.** Family/major-only support, version proximity, successful install, hosted ARM build, one RDP test, or vendor lifecycle as UAM support proof.

## 7.6 Server ingestion, processing, database, and capacity baseline

**ACCEPTED.** Authenticated context precedes ingestion. Strict admission and one relational transaction create immutable batch, exact custody bytes, immutable receipt, and work seed; receipt follows commit. Mutable scheduling is separate. Leases are short, fenced, and database-time-based. Parsing occurs outside the lease transaction. The final transaction materializes the whole batch or records terminal quarantine. Central event uniqueness is `(realm_id,event_id)`. Typed facts, projection contributions, and integration messages have stable idempotency. The initial server remains a modular monolith and relational inbox; no broker default.

**PROVISIONAL / CLI EXPERIMENT.** Wire encoding/compression, limits, receipt failure domain, lease/fairness, bulk path, physical schema/partition/index, database engine/topology, reporting corpus, demand distributions, 6k/12k scenario results, headroom, SLOs, and broker thresholds.

**REJECTED.** Receipt before custody, HTTP success as custody, mutable receipt, partial first-slice materialization, event uniqueness broadened by installation, broker as initial acceptance, generic benchmark choice, closed-loop-only load, stateless users as fleet truth, and capacity claim from endpoint count.

## 7.7 Retention, deletion, backup, and restore baseline

**ACCEPTED.** Lifecycle uses immutable policy revisions and exact same-realm typed resolution. Barrier/tombstone/visibility epoch, target graph, connector work, audit, and case transition commit together. Readers suppress or become ineligible. Physical deletion and verification are asynchronous. Holds block destruction but not suppression. Tombstones dominate older backups, endpoint replay, inbox replay, caches, search, replicas, exports, and connectors. Restore is isolated, uses current tombstone authority and authoritative receipt truth, rebuilds under guards, runs deleted-negative and acknowledged-positive probes, and keeps ordinary authority disabled until ready.

**PROVISIONAL / HUMAN DECISION.** Purpose-specific retention, legal holds, subject selectors, audit/tombstone/receipt/quarantine horizons, backup cadence/topology/PITR/copies/immutability, key destruction, sanitization, connector obligations, aggregate survival, endpoint cleanup after ACK, and RPO/RTO.

**REJECTED.** Physical delete before barrier, soft delete as completion, backup checksum as restore proof, universal crypto erase, direct reads during restore, editing all old backups by default, external completion from 2xx/404, or indefinite retention.

## 7.8 Portal authorization, workflows, and accessibility baseline

**ACCEPTED.** The first control plane is a same-origin browser and ASP.NET Core BFF with server-side tokens/session and CSRF. One active realm per normal session; global and multi-realm planes are explicit. A release-owned capability catalogue plus closed purpose/realm/target/time/state/approval/authentication/output/safety conditions is deny-by-default. Portal information architecture is task-oriented and aggregate-first. High-impact work uses immutable preview, content-bound approvals, stable command ID, version checks, final transactional reauthorization, durable jobs, and explicit recovery. WCAG 2.2 AA is the engineering target for complete workflows.

**PROVISIONAL / HUMAN DECISION.** Real users/roles/purposes, standing versus JIT classes, approval/SoD profiles, IdP/session assurance, portal framework/design system, browser/AT/language support, detail/export routes, break-glass, and accessibility conformance policy.

**REJECTED.** IdP groups/OAuth scopes as final authority, UI-only checks, wildcard admin, tenant policy language, external PDP/relationship graph by default, generic CRUD/table editor/SQL, browser bulk scope, person detail default, cross-realm dashboard default, inaccessible fallback, and service-worker/offline mutation.

## 7.9 Transactional audit baseline

**ACCEPTED.** `AuthorizationDecisionV1` and canonical `AuditEventV1` are distinct linked records. Successful privileged mutation, final decision, audit event, stream head, and required job/outbox commit together. Sensitive read bytes release only after access audit commits. Events are closed/minimized, realm/global streams have authoritative sequence, source rows are immutable, and corrections are linked events. Sealed Merkle segments and independently protected checkpoints are required before privileged production use. Verification failure creates a scoped hold.

**PROVISIONAL / HUMAN DECISION.** Canonical byte profile, segment size/cadence, checkpoint technology/freshness, verifier owner/independence, key/time profile, audit fields/access/retention, native SQL Server/PostgreSQL supplemental audit, search/export topology, and evidentiary claims.

**REJECTED.** Log-after-mutation, separate authoritative audit transaction, generic trigger row images, free-form messages/details, ordinary hashes of low-entropy identities, one global stream for all realms, timestamp ordering, editing/pruning unsealed rows, native DB audit as canonical ledger, blockchain/immutable DB by default, and break-glass without audit.

## 7.10 Migration, cutover, archive, and decommission baseline

**ACCEPTED.** Discovery is one-shot, fixed, read-only, hostile-data parsing, and content-addressed evidence. Presence is not approval; every item receives owner-bound disposition. Parallel validation is one authority plus isolated shadow. Endpoints cannot dual-write. Comparison is server-side, minimized, exact-range, counted-multiset, and finite-classification. Tolerances/known defects are scoped, owner-approved, expiring, and cannot suppress hard invariants. Shadow history stays shadow. Cutover uses separate authority epoch, ring, comparison, and workflow states. Promotion is human; hard safety signals pause. Legacy rollback is possible only before explicit expiry/trust removal through higher epochs and a proved fence. Read-only/archive and trust removal are layered. Deferred SQL is never executed by the target. Final acceptance is independently recomputed and multi-owner approved.

**PROVISIONAL / HUMAN DECISION.** Inspection authority, estate population, report semantics, tolerances, real shadow purpose/fields/retention, configuration precedence, cutover fence/rings/bake, rollback expiry, archive purpose/topology/fields/retention, credential/network map, buffer disposition, residual sensors/duration, exceptions, and final deletion.

**REJECTED.** Big bang, dual authority, endpoint fan-out, live legacy write-back by default, shadow promotion, raw row-diff warehouse, legacy as oracle, generic tolerance, sample-only sign-off, automatic legacy rollback, dormant credentials after trust removal, SQL/script execution, uninstall/disable/revoke/firewall/read-only as sole proof, permanent discovery agent, and technical decommission as legal completion.

---

# 8. Decision register

## 8.1 Accepted decisions

| ID | Decision | Status | Notes |
|---|---|---|---|
| D-A01 | Coordinator/User Host/Task Host Windows topology | **accepted** | Runtime fitness still requires G1. |
| D-A02 | Coordinator never crawls profiles or creates user tokens | **accepted** | Formal change required to weaken. |
| D-A03 | Fixed Task Host capabilities; no general code channel | **accepted** | Source-specific compiled capability only. |
| D-A04 | C#/.NET implementation family | **accepted** | Exact patch is lifecycle-selected evidence. |
| D-A05 | Release-owned privacy ceiling and monotonic tenant narrowing | **accepted** | Unknown relation fails closed. |
| D-A06 | Minimize before IPC/durability/logs/diagnostics/transport | **accepted** | Raw URL stays inside Task Host. |
| D-A07 | Endpoint has no central DB credentials/SQL | **accepted** | Also applies during migration. |
| D-A08 | One-writer SQLite WAL and atomic page effect/progress | **accepted** | Provider/native profile remains measured. |
| D-A09 | At-least-once delivery and one final effect | **accepted** | Stable IDs and central uniqueness. |
| D-A10 | Bounded versioned authenticated compressed HTTPS batches | **accepted** | Exact codec/compressor/limits provisional. |
| D-A11 | Receipt means durable custody only | **accepted** | Cleanup not automatically authorized. |
| D-A12 | Modular monolith + relational inbox + leased workers | **accepted** | No external broker default. |
| D-A13 | PostgreSQL reference; SQL Server serious alternative | **accepted decision process** | Production engine remains open. |
| D-A14 | MSI/enterprise management owns privileged boundary | **accepted** | Autonomous updater optional. |
| D-A15 | Edge site/domain minimized first functional slice | **accepted** | Live fields/purpose remain human-owned. |
| D-A16 | UUIDv7 for new UAM IDs; SHA-256 for content/evidence | **accepted** | UUID time not business truth. |
| D-A17 | Field-specific Unicode handling | **accepted** | Canonicalization preserves parsed strings. |
| D-A18 | UAM-owned application identity and deterministic ambiguity | **accepted** | Names/external refs not authority. |
| D-A19 | Separate source, generation, runtime capability, interpretation | **accepted** | Processing upgrade does not reset lineage. |
| D-A20 | Page—not row—is endpoint progress authority | **accepted** | Whole-page commit or none. |
| D-A21 | Central event uniqueness `(realm_id,event_id)` | **accepted** | Installation is provenance/conflict evidence. |
| D-A22 | Immutable custody separate from mutable work | **accepted** | Receipt remains append-only. |
| D-A23 | Whole-batch first-slice materialization/quarantine | **accepted** | Per-event partial model deferred. |
| D-A24 | Suppression/tombstone before physical deletion | **accepted** | Restore must replay current authority. |
| D-A25 | Same-origin BFF and server-side session/tokens | **accepted initial model** | Exact IdP/front-end remains open. |
| D-A26 | Closed capability/purpose/target/output authorization | **accepted** | No general tenant policy language. |
| D-A27 | Explicit preview/command/job workflow | **accepted** | No generic privileged CRUD. |
| D-A28 | Canonical same-transaction audit and audit-before-disclose | **accepted** | Portal audit shape is a projection. |
| D-A29 | Independent external audit checkpoints before privileged production | **accepted production prerequisite** | Exact technology/owner provisional. |
| D-A30 | One business authority during migration; shadow isolated | **accepted** | Endpoint dual-write impossible. |
| D-A31 | Shadow history is never promoted | **accepted** | Historical import is a new governed origin. |
| D-A32 | Phase-bounded legacy rollback expires before trust removal | **accepted** | Post-removal credential recreation requires baseline change. |
| D-A33 | Layered read-only/trust removal/decommission proof | **accepted** | No single control is sufficient. |

## 8.2 Provisional decisions

| ID | Matter | Status | Safe temporary state / resolver |
|---|---|---|---|
| D-P01 | Physical IPC codec, frame, transcript, limits | **provisional** | codec-neutral logical messages; compare strict JSON and deterministic CBOR |
| D-P02 | Signed-control crypto profile, quorum, KMS/HSM | **provisional** | test-signed or unsigned T1 only; security properties fixed |
| D-P03 | Exact event/site/time/identity fields | **provisional** | no live event; synthetic profiles only |
| D-P04 | Unicode IDN and PSL | **provisional** | ASCII host profile; no PSL/registrable-domain output |
| D-P05 | Exact SQLite provider/native profile and encryption | **provisional** | narrow T1 adapter; record actual source ID; no production key decision |
| D-P06 | Page/batch/retry/resource/outage limits | **provisional** | small bounded T1 limits labelled estimates |
| D-P07 | Device PKI/TPM/proxy/VPN/L7 profiles | **provisional** | lab CA, direct mTLS, no silent software fallback |
| D-P08 | Autonomous updater need | **provisional / disabled** | enterprise-only deployment |
| D-P09 | Production database/partition/index/topology | **provisional** | paired candidate labs; no production choice |
| D-P10 | Capacity/headroom/broker triggers | **provisional** | synthetic scenarios only; relational inbox default |
| D-P11 | Retention/backup/cleanup values | **provisional** | no production sweep, expiry, or endpoint cleanup |
| D-P12 | Portal rendering/design system/BFF package | **provisional** | standards-first T1 shell; built-in ASP.NET Core first candidate |
| D-P13 | Audit canonicalization/segment/checkpoint technology | **provisional** | independent T1 vectors and local lab anchor |
| D-P14 | Archive topology and historical workflow | **provisional** | read-blocked; read-only copy behind BFF first candidate |
| D-P15 | Comparison digest/time/tolerance/range profile | **provisional** | exact T1 profile; no active tolerance |

## 8.3 CLI-measurement decisions

| ID | Matter | Status | Required experiment family |
|---|---|---|---|
| D-C01 | G0 determinism, oracle independence, canary containment | **CLI-measurement** | G0 clean-build, mutation, all-sink, cleanup gate |
| D-C02 | Windows launch/token/ACL/IPC/session isolation | **CLI-measurement** | G1 exact-environment hostile campaign |
| D-C03 | Edge zero-write snapshot and backup completion | **CLI-measurement** | G2 source write/lock/churn/impact campaign |
| D-C04 | Source/profile/generation/native-cursor correctness | **CLI-measurement** | G3 controlled recall/replacement/session campaign |
| D-C05 | URL privacy transformation and canary containment | **CLI-measurement** | G4 parser/matcher/realm/all-sink campaign |
| D-C06 | Endpoint crash, receipt, pressure, migration invariants | **CLI-measurement** | G5 model/failpoint/process/VM/disk campaigns |
| D-C07 | Release install/repair/rollback/tamper | **CLI-measurement** | MSI/release exact file/path/state campaigns |
| D-C08 | Installation identity/revocation/clone/network | **CLI-measurement** | key/enrollment/mTLS/status/wrong-realm campaigns |
| D-C09 | Diagnostics catalogue/cardinality/bundle/privacy | **CLI-measurement** | analyzer/canary/permit/bundle/blind-support campaigns |
| D-C10 | Exact platform compatibility | **CLI-measurement** | first tuple inventory + all predecessor lanes |
| D-C11 | Durable server custody, leases, one effect | **CLI-measurement** | response-loss, false-receipt, stale-lease, poison, realm tests |
| D-C12 | Database semantics/recovery/operations | **CLI-measurement** | paired engines, backup/PITR/failover/operator drills |
| D-C13 | Capacity, recovery, fairness, soak | **CLI-measurement** | stateful/open-arrival 6k/12k/endurance scenarios |
| D-C14 | Lifecycle, tombstones, external targets, old-backup restore | **CLI-measurement** | resolver/barrier/connector/ACK/tombstone restore drill |
| D-C15 | Portal session/realm/purpose/JIT/workflow | **CLI-measurement** | BFF/browser/CSRF/cache/job/realm/accessibility campaigns |
| D-C16 | Transactional audit and independent verification | **CLI-measurement** | failpoints, tamper corpus, external checkpoint, restore comparison |
| D-C17 | Discovery safety/coverage/disposition | **CLI-measurement** | read-only adapters, no-execution, population/owner reconciliation |
| D-C18 | Shadow isolation/comparison/fence/cutover | **CLI-measurement** | no-dual-write, exact ranges, configuration transform, rollback drills |
| D-C19 | Trust removal/archive/residual/decommission | **CLI-measurement** | session/permission/secret/path denial, read-only restore, sensors, evaluator |

## 8.4 Human decisions

| ID | Decision class | Status | Conservative state |
|---|---|---|---|
| D-H01 | Legal purpose, lawful basis, prohibited uses, workforce consultation | **human-decision** | T1 fictional only; no live data |
| D-H02 | Source, field, site/domain, identity, time precision, lookback, hard denies | **human-decision** | live event disabled |
| D-H03 | Retention, deletion, holds, audit horizons, backup expiry, external copies | **human-decision** | no production sweep/expiry/deletion claim |
| D-H04 | Realm definition, roles, grants, approvals, access, detail/export | **human-decision** | no production assignment/detail/export |
| D-H05 | PKI, crypto/key custody, signing, recovery, offline/clock | **human-decision** | lab/test keys only |
| D-H06 | Supported Windows/browser/network/EDR/VDI estate | **human-decision** | exact lab tuple only; no support label |
| D-H07 | SLO/RPO/RTO, outage/backlog/resource/headroom objectives | **human-decision** | no production objective/capacity pass |
| D-H08 | Database engine/topology/licensing/support/TCO | **human-decision** | paired candidates only |
| D-H09 | Diagnostics/support backend/access/retention/support promise | **human-decision** | local T1 bundle only |
| D-H10 | Portal users/workflows/purposes/SoD/accessibility policy | **human-decision** | fictional personas; aggregate T1 shell |
| D-H11 | Audit fields/access/retention/verifier owner/evidentiary claim | **human-decision** | lab verifier; no production audit use |
| D-H12 | Migration semantics/tolerances/config precedence/cutover/rollback | **human-decision** | no real shadow/cutover |
| D-H13 | Archive purpose/topology/fields/access/retention | **human-decision** | read-blocked |
| D-H14 | Credential/network removal, buffer disposition, residual exceptions | **human-decision** | no destructive removal/final acceptance |
| D-H15 | Staffing/on-call/support/training/incident command | **human-decision** | affected capability disabled |
| D-H16 | Budget/licensing/procurement | **human-decision** | no unapproved dependency/service spend |
| D-H17 | Pilot, cutover, decommission, production risk/go-live | **human-decision** | prohibited |

## 8.5 Deferred matters

| Matter | Status | Reconsideration trigger |
|---|---|---|
| Process, file, URL-path, filename, role/person matching | **deferred** | approved purpose/fields plus Windows/privacy evidence and new contract |
| Unicode IDN and registrable-domain output | **deferred** | exact implementation/PSL/license/conformance and human decision |
| Disk-backed raw scratch | **deferred** | measured memory-only failure plus full key/remanence/backup/cleanup design |
| External broker | **deferred** | quantitative failure-domain/replay/fan-out/cost trigger and prototype |
| Autonomous updater | **deferred** | approved patch SLA, measured enterprise-management misses, TUF/rollback gate |
| ARM64, RDS/AVD/Citrix/FSLogix, third-party EDR, physical power | **deferred** | named demand and independent exact tuple campaigns |
| Person/activity detail and cross-realm oversight | **deferred** | approved purpose/minimum fields/access/retention/consultation/appeal and B05 gate |
| External PDP/relationship graph/workflow platform | **deferred** | finite model becomes inadequate and alternate passes full semantics |
| Search/CDC/analytical store | **deferred** | measured product/query need plus lifecycle/restore/realm adapters |
| Historical reprocessing/correction | **deferred** | governed supersession contract, privacy/legal approval, one-effect proof |
| Persistent discovery agent | **deferred** | repeated approved need not met by orchestration/existing sensors |
| Compatibility bridge | **deferred / disabled** | indispensable named consumer, typed server-side contract, hard expiry |

## 8.6 Rejected decisions

The following are **rejected**: endpoint SQL/database credentials; arbitrary script/plugin/command channels; raw URL beyond Task Host; endpoint dual-write; two ordinary authorities; shadow promotion; broker as default; autonomous updater as default; wildcard admin or tenant policy language; mutation without same-transaction audit; sensitive disclosure before access audit; read/egress before restore readiness; credential resurrection after trust removal; deferred SQL execution; generic percentage tolerance; checklist-only decommission; production data in tests; broad support/capacity claims without exact evidence; and any technical claim of productivity truth, forensic certainty, legal completion, or universal erasure.

---

# 9. Contradiction and evidence-quality register

## 9.1 Conflict-resolution order

Conflicts are resolved by:

1. preserving the accepted baseline and predecessor invariants;
2. preferring narrower authority and smaller privacy/security surface;
3. separating source truth, implementation capability, interpretation, custody, processing, visibility, audit, and migration authority;
4. preferring one canonical source of truth over overlapping ledgers;
5. distinguishing documented capability from UAM fitness;
6. treating exact versions/numbers as evidence inputs, not architecture;
7. requiring the smallest falsifying CLI experiment where prose cannot decide; and
8. leaving policy/legal/ownership/budget/risk/support choices to humans.

## 9.2 Consolidated contradiction register

| ID | Contradiction / overlap | Evidence quality | Resolution | Evidence that could reopen it |
|---|---|---|---|---|
| CR-01 | Strict JSON versus CBOR/88-byte IPC; repository `.proto` placeholder | All were topic recommendations; no measured codec evidence | Logical IPC remains codec-neutral; compare strict JSON and deterministic CBOR; protobuf absent unless later ADR | Parser/fuzz/resource/cross-version/Windows hostile evidence selecting a profile |
| CR-02 | Custom content-derived IDs, UUIDv4 examples, UUIDv7 | RFC-backed and cross-batch UUIDv7 agreement is stronger | New UAM IDs use lower-case UUIDv7; SHA-256 stays content/lineage digest; deterministic fixtures produce valid UUIDv7 | Interoperability/collision/privacy falsifier and migration proposal |
| CR-03 | Global NFC before canonicalization versus string preservation | RFC/cross-contract evidence favors preservation | Normalization is field-specific; JCS or other canonicalization preserves parsed strings; generator may define NFC only for its controlled fictional vocabulary | A field semantic contract requiring another explicit profile |
| CR-04 | Exact ES256/JWS/quorum versus open crypto profile | Standards prove capability, not enterprise key fitness | Security properties accepted; algorithm/serialization/quorum/KMS/HSM/clock remain provisional | Crypto interoperability, incident, recovery, compliance, and human key-authority evidence |
| CR-05 | Coordinator `CollectionAssignment` versus User Host permit | Privacy/session authority requires independent user-session decision | Coordinator sends `RunIntent`; User Host issues one-use `CollectionPermit`; output binds permit | G1 prototype showing composition infeasible without equivalent independent enforcement |
| CR-06 | Source generation included Edge/.NET/SQLite/adapter/policy versions | Runtime and interpretation are not source lineage | Split `source_generation_id`, `source_schema_capability_id`, `collector_runtime_profile_id`, `interpretation_id` | Source evidence showing a version change necessarily resets native lineage |
| CR-07 | Pre-minted source occurrence ID and row cursor versus native key/page progress | Stable native identity and whole-page transaction are stronger | Natural key excludes interpretation/runtime; Coordinator mints/persists event ID at first commit; page owns progress | A formally proved lower-risk streaming protocol |
| CR-08 | Full UTS #46/PSL versus ASCII first slice | Desired exact .NET/Unicode behavior is unproved; PSL unnecessary for exact/suffix matching | ASCII DNS-host profile first; IDN and PSL disabled until separate gates | Exact implementation conformance, lifecycle, all-sink, license, and human output decision |
| CR-09 | Software key prototype versus no silent software device-key fallback | Different assets and assurance consequences | Software may be T1 data-protection candidate; device A1 remains disabled absent explicit exception; keys never reused | Human threat/assurance decision and exact platform evidence |
| CR-10 | TUF required for release versus updater optional | TUF applies to autonomous repository, not enterprise-only MSI | MSI path can proceed without TUF; enabling updater makes TUF/POUF/recovery blocking | Approved updater need and complete conformance/security/operations gate |
| CR-11 | Broad first compatibility tuple versus exact narrow tuple | No equivalence evidence across dimensions | First candidate is one exact OS/build/arch/browser/session/profile/EDR/network tuple | Equivalence campaign proving a safe bounded range |
| CR-12 | Endpoint cleanup after receipt versus unproved server recovery | Receipt semantics alone do not prove recoverability after endpoint deletion | Production cleanup remains disabled until B04 custody/RPO/ACK/tombstone/restore gate | Exact receipt failure-domain and restore evidence plus human cleanup policy |
| CR-13 | Server event uniqueness `(realm,event)` versus `(realm,installation,event)` | Stable endpoint event identity and clone/conflict detection favor realm-wide uniqueness | Unique `(realm_id,event_id)`; installation is immutable provenance and conflict signal | Explicit predecessor identity redesign with migration/replay proof |
| CR-14 | Quarantine consumes event identity versus separate processing occurrence | Permanent consume can block governed reprocess | Quarantine is immutable batch-processing occurrence; ordinary event identity enters effect ledger on successful effect | Complete per-event terminal/correction model with lower risk and measured need |
| CR-15 | JSON+gzip versus NDJSON+zstd ingestion examples | No comparative UAM wire evidence | One exact profile per contract; codec/compression remain provisional | Compatibility, CPU, decompression, size, support, security evidence |
| CR-16 | Audit decision evidence, portal audit shape, canonical audit ledger | Overlapping schemas risk divergent truth | `AuthorizationDecisionV1` is decision truth; `AuditEventV1` is canonical event; portal shape is redacted projection | A simpler single schema proving equivalent semantics without duplication |
| CR-17 | External audit checkpoint optional versus required | DBA/host threat makes independent state load-bearing | Local transactional audit suffices for T1; current independent checkpoint required before privileged production | Formally accepted threat model excluding those administrators or equivalent mechanism |
| CR-18 | SQL Server Ledger/pgAudit/immutable DB as audit | Native tools lack UAM purpose/workflow semantics and lifecycle fit | Optional defense in depth only after engine-specific tests; canonical app ledger remains authority | Exact selected-engine evidence and human retention/operations decision |
| CR-19 | Migration missing-input blockers in topic chats | Stale topic-chat file presence; final allowlist contains all six reviews | Input-presence issue is resolved; executed inventory/reconciliation gates remain open | New missing/mismatched allowed file at review restart |
| CR-20 | One-way legacy transfer versus pre-trust rollback | Different phases | Higher authority sequences may return to intact legacy before expiry/trust removal; trust removal is one-way milestone | Operational need for indefinite rollback would require baseline change |
| CR-21 | Cutover/validation/discovery ring names reused | Topic-local labels collide | Separate `DISC-D*`, `VAL-V*`, and `CUT-C*`; `AuthorityEpochV1` remains sole business authority | No expected reopen; naming-only correction |
| CR-22 | Shadow promotion or temporary live legacy write-back | Violates authority/provenance | Shadow never promoted; historical import is new origin; live authoritative write-back disabled by default | Separate typed consumer/staging need or formal baseline change for live write-back |
| CR-23 | Read-only DB/UI versus full archive proof | Single controls have blind spots | Layered application, identity, DB, session, job, network, restore, audit, and monitoring proof | Selected archive platform with intrinsically equivalent controls and tests |
| CR-24 | Exact point versions repeated as architecture | Time-sensitive evidence will stale | Record reviewed versions/dates; execution locks current supported exact versions and reruns affected gates | Current lifecycle/advisory/source mapping at build time |
| CR-25 | Public/vendor capability versus project proof | Documentation cannot prove composition | Treat docs as design input; runtime claims require CLI/lab evidence | Reproducible exact environment evidence |
| CR-26 | Tool output/scanner/SBOM/schema diff as oracle | Common-mode defects and blind spots | Independent oracle, positive controls, final-file reconciliation, mutation tests | A formally stronger independently verified tool chain with equivalent controls |

## 9.3 Evidence-quality conclusions

- **High-quality supplied evidence:** accepted batch review decisions, explicit contradiction resolution, stable standards, official platform/database documentation, immutable repository revisions with reviewed license/tests/security.
- **Medium-quality supplied evidence:** topic-level implementation hypotheses carried through reviews, current product/version documentation, upstream browser source, community operational patterns.
- **Low/insufficient evidence:** exact UAM runtime fitness, capacity, support, restore, operations, legal purpose, production data quality, owner assignments, cost, and any claim based only on popularity, vendor marketing, generic benchmarks, mutable branches, short commit prefixes, or scanner exit code.
- **FACT.** Repetition across batches is not treated as proof. A conclusion is accepted because it preserves invariants and has the strongest authority/evidence class, not because it appears often.
- **FACT.** No allowlisted project CLI evidence changes the accepted baseline. The only reported concrete tool failure relevant here is the rejection of the reviewed Gitleaks v8.30.1 as a release gate after a mandatory-positive-control concern; this changes a dependency decision, not the architecture baseline.

---

# 10. Architecture fitness functions and full proof-gate map

## 10.1 Executable architecture fitness functions

| ID | Fitness function | Required executable proof | Failure effect |
|---|---|---|---|
| FF-01 | Repository graph preserves deployable/module boundaries | architecture mutation tests for references, APIs, packages, unsafe interop, shared models | build/release stop |
| FF-02 | Contracts are strict and bounded | official schema subset + UAM invalid/adversarial vectors + allocation/time limits | contract candidate rejected |
| FF-03 | G0 package is deterministic and independently checked | two clean generations across path/locale/time-zone; identical roots; oracle reconciliation; mutation detection | all dependent gates stop |
| FF-04 | Mandatory canaries cannot escape or be missed | positive controls in every declared sink/encoding; zero misses; narrow allowlists | privacy incident/stop |
| FF-05 | Tenant policy never broadens product ceiling | exhaustive finite lattice laws, mutation/property tests, wrong-realm/rollback/expiry cases | policy safety hold |
| FF-06 | Application identity and matcher never guess | fictional import, overlap/shadow witnesses, deterministic ambiguity, realm negatives | registry publication stop |
| FF-07 | G1 preserves session/process authority | effective token/privilege/ACL/task evidence; cross-session/same-account/malformed/DoS campaigns | endpoint implementation stop |
| FF-08 | Task Host capability is contained | child/network/write/handle/job/cancel/kill-tree/residue tests | capability disabled |
| FF-09 | Edge acquisition performs zero source writes | OS denial + per-process trace + positive-control attempted write + source/browser before/after | source gate stop |
| FF-10 | Edge snapshot is complete or deferred | direct/backup lock/churn fixtures; require `SQLITE_DONE` + finish OK; no incomplete query | acquisition gate stop |
| FF-11 | Source/generation/cursor identity is correct | replacement/regression/deletion-gap/same-SID/multi-session/controlled recall tests | G3 stop/new ADR |
| FF-12 | Raw URL and forbidden derivatives never leave Task Host | all-sink canaries, process artifacts, logs/traces/dumps/support/evidence, schema scans | G4 privacy incident |
| FF-13 | Page effect/progress is atomic | failpoints before/after each effect/no-event/witness/checkpoint/commit/ACK boundary | G5 stop |
| FF-14 | Retry creates one endpoint effect and one stable batch | model histories, crash/restart, ambiguous send/replay, digest/ID conflicts | durability hold |
| FF-15 | Unauthorized/mixed/stale/downgraded release never executes | MSI/launcher/file/path/ACL/reparse/tamper/storage-compatibility/rollback tests | release freeze/repair |
| FF-16 | Installation identity is unique, realm-bound, and revocable | key/enrollment/activation/renewal/revoke/clone/wrong-realm/status-cache/cleanup tests | identity hold |
| FF-17 | Diagnostics are closed, bounded, and supportable | analyzers, cardinality bound, all-sink canaries, permit expiry/revoke, deterministic bundle, blind support | diagnostics disabled |
| FF-18 | Compatibility permits only an exact current tuple | inventory/package/native/browser/EDR/session match; stale/multi/unknown negatives | no collection permit |
| FF-19 | Receipt cannot be false | failpoints around custody commit/response loss/replica/failover/restore; exact bytes and receipt reconciliation | cleanup disabled; ingestion hold |
| FF-20 | Server retry/replay yields one ordinary effect | batch/event conflicts, lease fencing, whole-batch poison/reprocess, realm negatives | materialization hold |
| FF-21 | Capacity results represent offered demand | stateful actors, independent open arrivals, generator saturation/clock/evidence checks, backlog drain/fairness | capacity result invalid |
| FF-22 | Database candidate preserves semantics and recoverability | identical oracle/workload/fault/backup/PITR/failover/operator suite on both engines | candidate rejected/no winner |
| FF-23 | Deletion is invisible before physical completion | barrier/tombstone/read-guard/cache/replica/search/export/connector tests | lifecycle stop |
| FF-24 | Restore preserves ACKs and suppresses deletions | old backup + current tombstones + authoritative receipt set + replay + probes + no egress | read remains blocked |
| FF-25 | Portal route/action catalogue is complete | generate direct/background/job-phase negatives; no hidden/unclassified action | no admin candidate |
| FF-26 | Realm/purpose/JIT/approval/command enforcement is current and exact | multi-realm browser/API/cache/job/export tests; fake-clock expiry/revoke; stale preview; response loss | capability disabled |
| FF-27 | Privileged effect and audit are atomic | failpoints for decision/effect/audit/head/job/outbox/commit/response; command reconciliation | privileged plane hold |
| FF-28 | Sensitive read is audited before disclosure | bounded buffer/release tests, audit failure, export retrieval, hostile encodings | disclosure denied |
| FF-29 | Audit tampering and rollback are independently detected | alter/reorder/gap/duplicate/fork/old-restore corpus; independent implementation/checkpoint | scoped integrity hold |
| FF-30 | Critical workflows are accessible end to end | automated semantics plus manual keyboard/screen-reader/zoom/forced-colors/reduced-motion/task evidence | affected capability blocked |
| FF-31 | Discovery is read-only and complete enough for its claim | no-execution/no-mutation, fixed scope, canaries, population reconciliation, bounded absence | migration gate stop |
| FF-32 | Shadow has no ordinary egress and endpoints cannot dual-write | binary/package/credential/network graph, lineage/query/mutation tests | real parallel run prohibited |
| FF-33 | Comparison ranges and semantics are closed | exact fence/window/canonicalization/count/mismatch/tolerance/owner/expiry tests | cutover blocked |
| FF-34 | Authority transfer has no unproved gap/overlap | quiesce/final old range/new boundary/higher epoch/pre-trust rollback drill | authority remains frozen/legacy |
| FF-35 | Trust removal is layered and residual use is observable | credential/session/permission/secret/network removal, positive-control sensors, alternate paths, cleanup | decommission blocked/security incident |
| FF-36 | Final acceptance is independently recomputed | evaluator cannot mutate sources; all evidence current; exceptions/owners complete | `HOLD`, never self-pass |

## 10.2 Global proof-gate order and current state

| Order | Gate | Current state | What it proves | Exact non-waivable stop |
|---:|---|---|---|---|
| 0 | **G0 — purpose/source/dummy-data contract and oracle** | **NEXT / OPEN** | deterministic classified fictional package, strict contracts, independent truth, canary containment | nondeterminism, unclassified input, oracle coupling/mutation survivor, mandatory canary miss, undeletable artifact, blocking owner absent at closure |
| 1 | **G1 — session launch, identity, IPC, Task Host isolation** | **OPEN; depends on G0/contracts** | exact Windows process/token/pipe/session/release/containment behavior | cross-session accepted message, Coordinator profile access, prohibited privilege, peer bypass, escape, unbounded hostile impact, residue |
| 2 | **G2 — live Edge acquisition safety** | **OPEN; live use prohibited** | zero source write, safe direct/backup/defer, bounded impact | any source mutation, incomplete backup accepted, attributable corruption/crash, raw escape, non-success progress, residue |
| 3 | **G3 — profile/source/generation/cursor correctness** | **OPEN** | bounded discovery, source continuity, native-ID progress, exact recall | source/session/realm mix, path/name identity, timestamp cursor, discontinuity retained, duplicate effect |
| 4 | **G4 — privacy transformation and canary containment** | **OPEN** | strict host profile, hard denies, matcher ambiguity, minimization before IPC | forbidden value/derivative escape, guessed ambiguity, tenant broadening, cross-realm result, scanner miss, mixed interpretation |
| 5 | **G5 — endpoint outbox/checkpoint crash invariant** | **OPEN** | one writer, atomic effects/progress, sealed replay, pressure/migration recovery | cursor ahead, missing/double effect, changed retry identity, silent loss, cleanup before valid receipt, corrupt/mixed state accepted |
| 6 | **Release/update authorization and rollback** | **OPEN** | immutable authorized same-digest release, MSI lifecycle, N/N-1 rollback | unauthorized/incomplete/mixed/stale/downgraded executes, known-good absent, repair/data loss, privileged residue |
| 7 | **Device identity and enterprise network compatibility** | **OPEN** | unique realm-bound credential, revoke/clone/wrong-realm denial, direct mTLS | shared/exported key, payload realm, revoked/duplicate authorization, clone winner, TLS bypass |
| 8 | **Diagnostics and exact platform qualification** | **OPEN** | closed safe support signals and one exact engineering tuple | forbidden value, arbitrary field/command/file, dump, cross-realm access, expired permit active, unbounded series, stale/broad tuple |
| 9 | **Durable inbox/idempotency/poison handling** | **OPEN** | atomic custody receipt, fenced processing, one effect, realm isolation | receipt without bytes, stale lease commit, duplicate effect, cross-realm access, unbounded poison |
| 10 | **Database and capacity evidence** | **OPEN** | candidate semantic/recovery/operations parity and bound demand/headroom | semantic divergence, acknowledged loss, deleted visibility, generator saturation, backlog cannot drain, starvation, unknown objectives |
| 11 | **Disk/backpressure/long-outage behavior** | **OPEN** | no silent loss, bounded pause/recovery, replay and operational capacity | unacknowledged drop, store corruption, uncontrolled growth, false recovery |
| 12 | **Deletion, restore, acknowledged replay, extended Windows fidelity** | **OPEN** | tombstone/ACK restore invariant and later platform profiles | deleted data visible, ACK missing/duplicated, tombstone gap/fork, pre-ready authority, unsupported tuple claimed |
| 13 | **Portal authorization/workflows/audit/accessibility** | **OPEN; T1 prototypes only** | complete route catalogue, current purpose/JIT/approval, transactional audit, independent verification, accessible workflows | cross-realm/action leak, stale/revoked authority, effect without audit, disclosure before audit, tamper undetected, critical workflow inaccessible |
| 14 | **Migration discovery/shadow/reconciliation/configuration** | **OPEN; no real parallel run** | bounded estate evidence, owner dispositions, no dual-write/egress, exact comparison/fence | hidden material writer/consumer, endpoint reaches both, shadow egress, open range, unknown mismatch, unowned disposition |
| 15 | **Cutover/read-only/trust-removal/residual/decommission** | **OPEN/BLOCKED** | staged authority transfer, archive safety, layered removal, residual observation, independent acceptance | two writers, ambiguous fence, unsafe rollback, valid legacy trust remains, successful residual write, expired exception, missing owner/cleanup |

**FACT.** Passing a later model or prototype does not close an earlier gate. A result from a different release, environment, contract, database, workload, or evidence generation cannot be silently composed.

## 10.3 Aggregate gate semantics

Every aggregate gate record MUST bind:

- exact allowlisted input/evidence hashes;
- source tree/commit and clean status;
- contract/schema/config/release/control artefact digests;
- SDK/runtime/native/provider/browser/database/tool versions and binary/source mappings;
- environment/support-scope facts;
- fixture package root, seed, fixed clock, oracle revision, and canary registry;
- commands with secrets/connection details removed;
- raw-result digests, normalized result, first failure, retries, and limitations;
- exact pass/fail predicate and zero-tolerance invariants;
- owner/reviewer/exception/expiry state;
- cleanup/revert/deletion receipt; and
- a machine-evaluated `PASS`, `FAIL`, `HOLD`, or `INVALID_HARNESS` result.

A rerun never erases the first failure. An infrastructure retry creates a linked evidence generation. No expired exception, missing owner, stale dependency, failed positive control, or cleanup residue can be silently waived in code or configuration.

---

# 11. Immediate implementation plan for the next unstarted gate: G0

## 11.1 Gate claim and authority boundary

**FACT.** G0 is the next unstarted gate in the accepted sequence. No allowlisted evidence shows it has been implemented or passed.

**RECOMMENDATION.** Implement G0 as the technical foundation that proves all later evidence is reproducible, classified, independently checked, and privacy-canary protected. G0 does **not** decide the legal/business purpose. Instead it makes the conservative human state executable:

```text
productionPurposeState = UNDECIDED
liveSourceEnabled       = false
allowedDatasetTier      = T1_FICTIONAL_ONLY
realRealmMappings       = empty
productionFields        = empty
productionRetention     = unset
```

A correct G0 implementation MUST make it impossible for that undecided state to authorize live data or production-shaped source access.

### G0 primary claim

> From a clean checkout, an exact locked toolchain can generate a classified immutable fictional package twice with byte-identical canonical content; a separately owned oracle can predict every declared outcome without calling production decision code; every mandatory privacy canary is detected in every declared sink and encoding; mutations of mandatory invariants are detected; all ephemeral artifacts can be deleted; and a machine-readable gate record binds the exact inputs, versions, commands, results, owners, limitations, and cleanup.

### What G0 authorizes after pass

- codec-neutral contracts and pure domain/state models;
- production-shaped **synthetic** endpoint shell work after the rest of Batch 01 closes;
- T1 browser/database/Windows/server/portal/migration fixtures;
- deterministic fault histories and evidence envelopes; and
- dependency, repository, and CI gates that consume the same package.

### What G0 never authorizes

- live source access;
- organization-derived row values or production distributions;
- production role/realm/purpose/field/retention mappings;
- production keys, credentials, signing, deployment, support, or data transfer; or
- an inference that fictional test success proves Windows, browser, database, capacity, restore, or operational fitness.

## 11.2 Immediate repository shape

Create only the following initial paths; names may be adapted to the existing repository while preserving boundaries:

```text
/contracts/
  standard/
    uam-contract-standard-v0.md
    scalar-profile-v0.md
    error-taxonomy-v0.md
    contract-catalogue.schema.json
  g0/
    g0-package-manifest.schema.json
    g0-lineage-record.schema.json
    g0-truth-ledger.schema.json
    g0-canary-registry.schema.json
    g0-scan-report.schema.json
    vectors/{valid,boundary,invalid,adversarial}/

/src/foundation/
  Uam.Contracts.Core/
  Uam.TestData.Generator/
  Uam.TestOracle/                 # no production references
  Uam.CanaryScan/
  Uam.ReleaseManifest/

/tests/
  architecture/
  contracts/
  g0/determinism/
  g0/oracle/
  g0/mutations/
  g0/canaries/
  g0/cleanup/
  privacy-canaries/

/fixtures/g0/
  sources/                        # declarative T1 input only
  expected/                       # reviewable oracle rules, not actual output
  canaries/

/eng/
  versions/
  package-sources/
  g0/
    generate.sh|ps1
    verify.sh|ps1
    cleanup.sh|ps1
    gate.sh|ps1

/docs/
  adr/
  decisions/
  evidence/g0/
  runbooks/g0/
```

No production endpoint, server, portal, database, or Windows service project is required to close G0. Empty future directories are acceptable only when they do not imply a chosen technology or runtime trust.

## 11.3 Work packages

### G0-WP01 — Evidence boundary and owner records

**Objective:** make the reviewed inputs, authority limits, owners, and stop rules machine-readable before code generates data.

**Repository tasks**

1. Add an immutable final-synthesis input manifest containing the eight allowlisted filenames, SHA-256 values, review date, and authority limitation.
2. Add the common human-decision record schema and create unresolved records for legal purpose, live source, fields, identity, retention, access, support, budget, and production approval with conservative defaults.
3. Add owner slots for contract authority, test-data steward, independent oracle, privacy-canary scanner, build/release evidence, incident response, and repository support.
4. Add a rule that a blocking owner may be an accountable function during implementation planning, but G0 cannot be marked closed while the final gate record says `UNASSIGNED`.
5. Add a baseline-change record template that cannot be confused with an ordinary implementation ADR.

**Tests**

- missing/extra/unallowlisted evidence file makes the input manifest validator fail;
- altered hash makes validation fail;
- missing authority limitation or conservative state fails;
- a gate record with blocking `UNASSIGNED` owner cannot be `PASS`;
- a human-decision record with no decision remains `disabled`, never an implicit default.

**Evidence**

- input manifest digest;
- schema validation report;
- owner/decision register digest;
- clean-tree proof.

**Stop conditions**

- a source file not in the allowlist is referenced;
- an unresolved human decision is converted into an engineering default;
- evidence metadata contains secret, host, address, raw source, or personal value.

### G0-WP02 — Contract standard and strict validators

**Objective:** freeze the common structural rules needed by every G0 artifact.

**Repository tasks**

1. Write `uam-contract-standard-v0.md` with exact UTF-8, duplicate, unknown, case, comments, trailing data, remote-reference, required/optional/null/default, number, time, UUIDv7, digest, Unicode, extension-point, limit, error, compatibility, and evidence rules.
2. Create `contract-catalogue.schema.json` and the five G0 schemas.
3. Bundle every schema locally with content digests. Build/test validators MUST run with network disabled after restore.
4. Create golden, boundary, invalid, and adversarial vectors for duplicate members, wrong case, BOM, invalid UTF-8, comments, trailing comma/data, wrong UUID version/variant/case, unsupported enum, overlong string, excessive items/depth/properties, remote `$ref`, path/UNC reference, non-finite number, implicit default, unknown member, and ambiguous null/absence.
5. Implement stable finite problem codes; errors MUST NOT echo the invalid value.
6. Create a validator bake-off adapter so candidate libraries can be replaced without changing the contract corpus.

**Tests**

- required JSON Schema Draft 2020-12 subset and UAM vectors;
- deterministic validator output and stable problem codes;
- bounded allocation/time on hostile corpus;
- zero network access during validation;
- generated schema/source diffs are reviewed and reproducible;
- any explicitly allowed extension point is bounded and proven non-authoritative.

**Evidence**

- validator/package/source/binary identities;
- conformance matrix;
- unsupported keyword list;
- allocation/time buckets;
- exact vector digests;
- network-egress log.

**Stop conditions**

- a duplicate or unknown authority-bearing member is accepted;
- remote reference resolution occurs;
- the validator silently coerces or defaults;
- resource use is unbounded or nondeterministic;
- package-to-source or license/security posture is unresolved for the selected validator.

### G0-WP03 — Deterministic scalar and identity primitives

**Objective:** produce repeatable UUIDv7, time, digest, ordering, and canonical byte primitives without wall-clock or ambient randomness.

**Repository tasks**

1. Implement a deterministic bit-stream abstraction with explicit algorithm ID, seed bytes, domain separation, and version.
2. Implement a fixed-clock abstraction that cannot read system time in generator/oracle projects.
3. Implement deterministic UUIDv7 generation using the fixed millisecond clock plus domain-separated uniqueness bits; validate version/variant/canonical lower-case text.
4. Implement SHA-256 content/file/tree digests with explicit algorithm label and canonical byte inputs.
5. Define field-specific Unicode handling for the fictional vocabulary; do not add global normalization to contract/canonicalization code.
6. Implement canonical file ordering, newline, UTF-8, integer, and NDJSON rules.
7. Add architecture analyzers banning `DateTime.Now`, `DateTimeOffset.Now`, random default constructors, process/environment identity, network, production secret APIs, and filesystem enumeration outside the declared package writer.

**Tests**

- same seed/clock/domain gives identical UUIDs and bytes;
- different domains do not reuse streams;
- collision detection under same millisecond and parallel generation;
- clock regression/collision fixtures produce a deterministic safe failure or approved monotonic fixture behavior;
- UUID timestamp is never used as business time/order in model APIs;
- locale/time-zone/current-directory/user/path changes do not change canonical output;
- invalid Unicode and line endings are rejected or canonicalized only under the declared fictional-field rule.

**Evidence**

- scalar/vector bundle;
- deterministic primitive source digest;
- architecture-rule results;
- cross-process rerun roots.

**Stop conditions**

- ambient clock/random/environment changes canonical bytes;
- duplicate fixture identity occurs without explicit expected conflict;
- UUID timestamp enters an authorization, source order, or business-time field;
- string normalization occurs outside a field-specific contract.

### G0-WP04 — Classified fictional package generator

**Objective:** generate a reviewable immutable package using T1 data only.

**Package content**

```text
manifest.json
model/*.ndjson
scenarios/composition.ndjson
scenarios/steps.ndjson
scenarios/faults.ndjson
truth/expected-results.ndjson
truth/cursor-ledger.ndjson
truth/state-transitions.ndjson
canaries/corpus.ndjson
canaries/rules.ndjson
canaries/allowlist.ndjson
lineage/records.ndjson
schemas/**
hashes.sha256
package-root.json
```

**Repository tasks**

1. Define T1/T2/T3 classification in code and schema. The current generator accepts T1 only. Any T2/T3 input produces `DISABLED_REQUIRES_APPROVAL`.
2. Define fictional reserved namespaces and visibly fictional realm, installation, session, source, application, URL, process, owner, case, report, and credential-like values.
3. Create a wholly fictional application-catalogue-shape fixture if needed by registry tests, including the accepted 173-row shape and quality categories without copying any raw name/reference or inferring owner, role, purpose, rule, entitlement, sensitivity, or usage.
4. Generate synthetic Edge roots/profiles/History databases, URL corpora, source replacement/regression cases, policy/rule snapshots, endpoint page/batch/receipt histories, server custody/lease/poison cases, lifecycle/tombstone/restore cases, portal/JIT/audit cases, and migration/authority/cutover cases as declarative T1 assets.
5. Keep generated SQLite/browser/source stores ephemeral. The canonical committed package is reviewable JSON/NDJSON/schemas/digests, not opaque binaries.
6. Record lineage for every generated entity and derivative: generator rule, parent IDs/digests, classification, purpose, expected sink, expiry/deletion.
7. Reject placeholder fields, implicit seed, wall clock, external network, real hostname/domain, raw organization value, and unclassified parent.

**Tests**

- all canonical files byte-identical in two clean workspaces;
- package root changes when one meaningful input changes;
- package root does not change from path/user/locale/time-zone/parallel ordering;
- every model row has classification and lineage;
- every child classification is at least as restrictive as the most restrictive parent;
- no production/customer/internal reserved pattern or actual credential format appears except exact approved canaries;
- generated ephemeral SQLite/source fixtures can be recreated exactly from canonical inputs;
- no committed binary or temporary raw store is required to reproduce truth.

**Evidence**

- two clean package roots and file manifests;
- deterministic diff report;
- classification/lineage completeness report;
- generated-store recreation report;
- source/fixture inventory and deletion receipt.

**Stop conditions**

- any unclassified or real-looking source value;
- any hidden randomness or nondeterministic file order;
- raw catalogue value or semantic inference from a name;
- committed opaque binary becomes the canonical source;
- an ephemeral fixture cannot be deleted or recreated.

### G0-WP05 — Independent oracle and truth ledger

**Objective:** establish expected outcomes before executing production-shaped logic.

**Repository tasks**

1. Create `Uam.TestOracle` with a separate code owner and no reference to production decision, minimization, matcher, policy, cursor, dedupe, storage, receipt, materialization, deletion, or audit implementations.
2. Express oracle rules declaratively and as small pure functions whose inputs are canonical model facts.
3. Produce one truth row for every causal input, including accepted, rejected, deferred, retry, duplicate, conflict, quarantine, no-event, received, validated, materialized, visible, suppressed, deleted, restored, and authority-transition outcomes.
4. Produce expected source cursor before/after, page state, event identity, batch identity, receipt state, final ordinary effect, projection contribution, deletion visibility, restore readiness, authorization decision, audit sequence/hash inputs, and migration authority result.
5. Record rule ID/version and reasoning code for each expected row so failures are explainable without raw input.
6. Create an actual-versus-truth reconciler that rejects missing, extra, duplicate, reordered-when-order-authoritative, wrong-digest, wrong-state, and unclassified outcomes.

**Architecture tests**

- oracle assembly has no prohibited project/package/API references;
- no runtime reflection/plugin path can load production decision code;
- shared constants/schemas are limited and mutation-tested;
- actual output is never read while generating expected truth.

**Mutation and differential tests**

Deliberately mutate at least these mandatory invariants and require the oracle/reconciler to fail:

- cursor advances without effect;
- raw URL copied into result;
- tenant broadens ceiling;
- ambiguity selects first rule;
- source generation changes on runtime upgrade;
- retry mints a new event ID;
- batch rebuilt after ambiguous send;
- receipt emitted before custody commit;
- event uniqueness includes installation and permits a second effect;
- stale lease commits;
- deletion occurs before barrier;
- restored read enabled before tombstone/ACK reconciliation;
- privileged mutation commits without audit;
- sensitive response releases before access audit;
- shadow fact enters ordinary projection;
- lower authority/release sequence activates;
- revoked legacy credential reactivates.

**Evidence**

- oracle dependency graph;
- truth root and rule catalogue;
- mutation list, first detected boundary, and zero mandatory survivors;
- actual/truth reconciliation report.

**Stop conditions**

- oracle calls production decision code;
- a mandatory mutation survives;
- expected truth changes after observing actual output;
- one causal input has no truth row;
- unexplained actual output exists.

### G0-WP06 — Exact canary and all-sink scanner

**Objective:** prove that the evidence system detects deliberately planted forbidden values in every declared sink.

**Repository tasks**

1. Create an exact fictional canary registry with one marker per source component and sensitivity class: URL authority, path, query, fragment, title, profile, account, SID-like token, credential-like token, secret header, SQL text, raw selector, and migration buffer.
2. Define encoding variants: UTF-8/UTF-16, JSON escapes, percent encoding, Base64, hex, gzip/decompression, canonical JSON, SQLite text/blob, log/tracing/event formats, and archive members where applicable.
3. Define the sink inventory: repository, build output, package, stdout/stderr, test results, logs, traces, metrics, DB dumps, IPC/HTTP captures, crash/support artifacts, SBOM/provenance/evidence, browser artifacts, exports, and migration packs.
4. Implement schema-aware scans that understand allowed canary locations and reject all other occurrences.
5. Require each scanner/tool version to detect all mandatory positive controls before scanning product output.
6. Allowlist entries MUST identify exact marker, path, purpose, owner, and expiry. Directory wildcards and generic “test data” suppressions are invalid.
7. Reports MUST redact or replace the marker while retaining enough stable identity to diagnose the sink.

**Tests**

- every mandatory marker is detected in every declared encoding/sink where planted;
- one removed detector makes the harness fail;
- a broad allowlist is rejected;
- scanner output does not leak the complete marker outside its approved test corpus;
- nested archives and compressed payload limits are enforced;
- scan remains deterministic and offline.

**Evidence**

- canary registry/root;
- sink/encoding coverage matrix;
- exact scanner/tool versions and positive-control results;
- zero-escape report;
- allowlist register and expiry validation.

**Stop conditions**

- one mandatory miss;
- scanner/tool egresses artifacts;
- report leaks a forbidden marker or secret;
- broad suppression accepted;
- an undeclared sink exists.

### G0-WP07 — Adversarial, property, and model test corpus

**Objective:** ensure the package is not only deterministic but capable of falsifying the architecture.

**Required corpus partitions**

- strict contract violations;
- identity collisions and wrong UUID versions;
- Unicode and normalization edge cases;
- realm/session/installation cross-product negatives;
- policy monotonicity and rollback conflicts;
- matcher overlap, shadowing, ambiguity, and wrong normalization version;
- source replacement, native-ID regression, deletion gaps, equal timestamps, late sync, same-SID sessions;
- page cancellation, mixed interpretation, invalid row, partial result, cleanup failure;
- crash/ACK ambiguity, disk pressure, corrupted state, migration/rollback;
- receipt replay/conflict, stale lease, poison, reprocess, projection/integration duplicate;
- deletion/hold/tombstone gap/fork, old backup, missing ACK, stale derived reader;
- stale JIT/approval/preview, cross-realm cache/job/export, audit gap/fork/rollback;
- shadow egress, endpoint dual-write, open comparison range, expired tolerance, unsafe rollback, residual credential/path.

**Tests**

- each mandatory invariant has at least one positive, boundary, negative, and mutation case;
- seeds and shrink/reduction output are stable;
- failures produce a minimal reproducible capsule without raw sensitive data;
- property counts are recorded as test-budget inputs, not architecture claims;
- unexplained flakiness is `FlakyUnclassified` and fails the gate.

### G0-WP08 — Reproducibility and supply-chain evidence

**Objective:** prove that G0 itself is reproducible and built from admitted inputs.

**Repository tasks**

1. Pin SDK, tools, package sources, analyzers, generators, CI actions/images, and test data revisions.
2. Restore once through declared sources, then run build/test/generate/verify with network denied.
3. Build in two clean environments differing in path, user, locale, and time zone.
4. Compare canonical unsigned outputs byte-for-byte; classify any expected container/timestamp differences separately.
5. Generate final file manifest, SBOM candidates, dependency lock graph, source mapping, and provenance; reconcile them independently.
6. Add secret/canary positive controls to build/release evidence.
7. Preserve exact compiler/runtime/native/tool identities in the gate record.

**Tests**

- floating version/action/source fails;
- dependency confusion/source-mapping mutation fails;
- missing shipped file/native/generated component fails reconciliation;
- changed subject/material fails provenance verification;
- unexplained output difference fails;
- untrusted lane cannot access secrets/signing/deployment/internal network.

**Evidence**

- locked toolchain manifest;
- restore/egress log;
- two clean build roots;
- file/SBOM/lock/provenance reconciliation;
- trust-zone permission test results.

### G0-WP09 — Gate evaluator and evidence package

**Objective:** issue one machine-readable result that can be independently recomputed.

**Required evidence layout**

```text
evidence/g0/<run-id>/
  gate-request.json
  environment.json
  input-manifest.json
  source-tree.json
  toolchain.json
  dependency-locks/
  fixture-package/
    package-root.json
    hashes.sha256
  oracle/
    truth-root.json
    reconciliation.json
    mutations.json
  canaries/
    registry.json
    coverage.json
    scan-report.json
  tests/
    contract-report.json
    determinism-report.json
    architecture-report.json
    cleanup-report.json
  raw-results/                  # access-controlled; digests in shareable record
  findings/
  owner-decisions/
  exceptions/
  gate-result.json
```

`gate-result.json` MUST include:

```text
result = PASS | FAIL | HOLD | INVALID_HARNESS
claim
exact source and input digests
exact toolchain/dependency identities
package and truth roots
positive-control and mutation results
all primary invariant results
owner and decision state
exceptions and expiry
limitations
cleanup receipt
reviewer identities/functions
generatedAtUtc and evidence expiry
```

The evaluator MUST be a pure reader of evidence. It cannot modify source, test, owner, exception, or result artifacts. It preserves the first failure and reports every primary invariant independently.

### G0-WP10 — Cleanup, revocation, and rerun discipline

**Objective:** leave no uncontrolled test data, generated stores, credentials, listeners, processes, or stale pass state.

**Cleanup requirements**

- delete ephemeral SQLite/browser/source stores, archives, temp directories, traces, captures, and plaintext intermediate bundles;
- ensure no service, scheduled task, user/group, certificate/key, firewall rule, network listener, process, job, container, or VM artifact is created by G0; any future test helper must record before/after state;
- remove test-only keys and canary copies outside the canonical approved corpus;
- prove repository clean state except the intended committed changes;
- preserve only content-addressed minimized evidence according to the T1 manifest;
- mark prior `PASS` evidence superseded—not deleted—when source, dependency, schema, or gate logic changes;
- rerun from a clean checkout with a new evidence generation; never edit a prior failure into pass.

## 11.4 G0 test matrix

| Test family | Minimum claim | Primary assertion |
|---|---|---|
| Input boundary | only allowlisted and declared T1 inputs | no unlisted file/value or hidden network input |
| Contract conformance | strict deterministic validation | exact accept/reject matrix; bounded resources |
| Scalar identity | deterministic UUIDv7/time/digest | repeatable canonical bytes; no business-time misuse |
| Package determinism | clean runs produce same root | byte-identical canonical package |
| Classification/lineage | every item classified and traceable | no unclassified/under-classified derivative |
| Oracle independence | no production decision-code dependency | architecture graph passes; actual output never shapes truth |
| Truth completeness | every causal input has expected result/state | zero unexplained actual/missing/extra outcomes |
| Mutation detection | mandatory invariant defects are caught | zero mandatory mutation survivors |
| Canary positive control | scanner detects all planted values | zero mandatory misses across sink/encoding matrix |
| Privacy containment | generated/evidence outputs contain only approved canary locations | zero forbidden escapes |
| Supply-chain lock | exact offline reproducible inputs | no floating or undeclared source/action/tool |
| Build reproducibility | clean builds agree | no unexplained canonical difference |
| Evidence integrity | gate can be independently recomputed | hashes and result reproduce; evaluator read-only |
| Cleanup | ephemeral artifacts removed | clean tree and deletion receipt; no residue |

## 11.5 G0 pass expression

```text
G0_PASS =
  exact_allowlisted_input_manifest
  AND all_inputs_classified_T1
  AND production_authority_explicitly_disabled
  AND strict_contract_suite_pass
  AND deterministic_scalar_vectors_pass
  AND clean_generation_A_root == clean_generation_B_root
  AND lineage_complete
  AND oracle_has_no_production_decision_dependencies
  AND truth_reconciliation_has_zero_unexpected_results
  AND mandatory_mutation_survivors == 0
  AND mandatory_canary_positive_controls_all_detected
  AND forbidden_canary_escapes == 0
  AND dependency_source_license_security_admission_complete
  AND offline_locked_build_pass
  AND reproducibility_reconciliation_pass
  AND blocking_owner_functions_assigned
  AND no_unexpired_blocking_exception
  AND cleanup_receipt_pass
```

The gate result is `FAIL` for a primary invariant failure, `HOLD` for missing owner/decision/approved dependency or unresolved non-primary blocker, and `INVALID_HARNESS` when the test/evidence/cleanup system itself is unreliable.

## 11.6 Dependencies and permitted parallelism

**Required before G0 closure**

- accepted common contract/UUID/time/Unicode rules;
- repository graph and exact toolchain/package-source lock;
- owner functions for contract, data, oracle, canary, build/release, and incident paths;
- admitted exact validator/property/build dependencies; and
- immutable G0 evidence schema and evaluator.

**May run in parallel after the scalar profile exists**

- package generator;
- independent oracle;
- exact canary scanner;
- pure privacy-lattice evaluator;
- pure registry/URL-host matcher;
- repository reproducibility/SBOM controls.

**Must not begin before G0 and named prerequisites**

- Windows G1 implementation before logical contracts/policy permit/repository gates;
- live source or production-shaped endpoint integration;
- production signing, PKI, server/database selection, portal administration, or migration connection;
- any use of T2/T3 inputs.

## 11.7 G0 stop conditions and escalation

The implementation stops immediately and opens the named ADR/finding when any of the following occurs:

- nondeterministic canonical output;
- unclassified or production-derived value;
- oracle dependence on production decision code;
- mandatory mutation survivor;
- mandatory canary miss or forbidden sink escape;
- validator differential that changes authority/privacy meaning;
- UUID/time/Unicode semantic ambiguity;
- floating/unmapped dependency or license/security gap;
- unexplained reproducibility mismatch;
- report/evidence leakage;
- undeletable ephemeral artifact or cleanup residue;
- blocking owner still unassigned at gate review; or
- a proposed workaround weakens an accepted invariant.

A stop does not authorize a smaller undocumented test, an expired exception, a hidden allowlist, or a weaker production fallback. It produces a reproducible finding, affected decision/contract, smallest counterexample, containment, owner, ADR action, and rerun conditions.

---

# 12. Later roadmap with progressive precision

The roadmap advances only when the predecessor gate produces current evidence for the exact source tree, release, contract, environment, and cleanup state. Dates and throughput promises are intentionally absent because staffing, budget, support, and SLOs are human decisions.

## Phase 0 — G0 evidence foundation

**Ready now.** Implement section 11. Replace broad assumptions with exact contract, fixture, oracle, canary, dependency, and evidence roots. Output: `g0-gate.json`.

**Precision gained:** deterministic identities/bytes, strict error behavior, independent expected outcomes, known test coverage, reproducible evidence.

## Phase 1 — Batch 01 foundations and G1 Windows boundary

**Experiment-only after G0 prerequisites.** Complete pure privacy lattice, registry identity/matcher, build/release evidence, logical IPC, codec bake-off, disconnected lab scripts, then the synthetic Windows service/launcher/User Host/Task Host prototype.

**Precision gained:** exact service/task/token/pipe/ACL/job/firewall behavior for one approved Windows tuple; selected IPC profile and measured limits; actual cleanup behavior.

**Stop:** any cross-session message, Coordinator profile read, prohibited privilege, peer bypass, uncontrolled Task Host capability, or residue.

## Phase 2 — G2/G3/G4 Edge source and privacy slice

**Experiment-only; no real activity.** Use disposable synthetic Edge profiles and localhost/test URLs. Prove bounded root discovery, zero-write direct/backup/defer, source/generation/native-ID continuity, strict ASCII host transformation, deterministic ambiguity, whole-page contract, and all-sink containment.

**Precision gained:** exact supported Edge/OS/native capability; source schema/runtime profile; safe query; measured lock/time/memory/browser impact; output field candidate; error/disposition map.

**Human inputs required before live activation:** purpose, supported estate, lookback, site/domain field, time/identity precision, hard denies, retention/access.

## Phase 3 — G5 endpoint durability, release, identity, diagnostics, compatibility

**Experiment-only.** Implement one-writer realm store, atomic page/outbox, immutable batching/attempts/receipts, pressure/migration/corruption holds, enterprise MSI lifecycle, per-installation identity, direct mTLS, safe diagnostics, and one exact compatibility tuple.

**Precision gained:** actual SQLite/provider/native/flush/checkpoint behavior; resource pressure and outage limits; N/N-1 storage/release compatibility; identity assurance; supportable failure set; exact qualified tuple.

**Canary threshold:** a T1 engineering canary is eligible only after the Batch 03 aggregate gate and separate human canary decision.

## Phase 4 — Server custody and one-effect vertical slice

**Experiment-only.** Scaffold the modular monolith and implement authenticated identity boundary, strict ingress, relational custody transaction, receipt replay, work leases, whole-batch materialization/quarantine, event identity ledger, one typed Edge fact, one projection, one no-op/fictional integration, and reconciliation.

**Precision gained:** real receipt transaction duration/failure behavior; lease/fence semantics; poison/reprocess model; one-effect proof; exact wire profile; minimal operator runbook.

**Stop:** false receipt, stale lease commit, duplicate effect, cross-realm access, unbounded poison, custody/terminal mismatch.

## Phase 5 — Paired database, capacity, pressure, and recovery evidence

**Experiment-only plus human objectives.** Run the identical semantic/restore/workload harness against PostgreSQL and SQL Server. Qualify the stateful/open-arrival simulator. Run steady, reconnect, multi-day backlog, query/report/maintenance, backup, failover, fairness, saturation, and endurance scenarios.

**Precision gained:** production-candidate engine/topology choices; physical schema/index/partition candidates; connection/worker/lease limits; offered-load knee; backlog-drain/headroom evidence; skills and TCO inputs.

**Human inputs required:** demand distributions, SLO/error budget, RPO/RTO, maximum outage, headroom, cost/licensing/support and operations owner.

## Phase 6 — Lifecycle, retention, deletion, and restore readiness

**Experiment-only until policy decisions.** Implement exact resolver, barrier/tombstone/read guard, store adapters, legal-hold mechanics, connector/export registry, backup catalogue, chain-aware expiry, old-backup restore, current tombstone replay, authoritative ACK reconciliation, derived rebuild, probes, and readiness audit.

**Precision gained:** exact resurrection-path inventory, adapter semantics, restore duration/steps, evidence that endpoint cleanup can or cannot be enabled, truthful external limitations.

**Human inputs required:** purpose-specific retention, rights/hold policy, subject selectors, backup policy, sanitization, connector obligations, audit/tombstone horizons.

## Phase 7 — Portal, authorization, audit, accessibility, and support operations

**T1 prototypes may begin earlier; production candidate waits for underlying server/lifecycle identity.** Implement same-origin BFF, session/CSRF, route/capability catalogue, purpose/target/output kernel, JIT/approval, previews/commands/jobs, aggregate-first screens, canonical audit, access-audit, verifier/checkpoint, break-glass prototype, and complete accessibility tests.

**Precision gained:** exact critical workflows, required safe read models, route completeness, transaction/audit contention, checkpoint cadence candidates, browser/AT behavior, support gaps.

**Human inputs required:** real users/roles/purposes, detail/export need, SoD/quorum, IdP, audit fields/access/retention/verifier owner, accessibility support policy, break-glass authority.

## Phase 8 — Legacy discovery and isolated parallel validation

**No real connection until inspection authority.** Run fixed read-only discovery, reconcile population and consumers, obtain owner dispositions, transform approved configurations, create isolated new shadow state, define report/comparison semantics, and execute exact range/mismatch evidence.

**Precision gained:** actual estate/consumer/credential/buffer/archive graph; required target outcomes; known defects; comparison identity/time/tolerance profiles; candidate cutover cohorts.

**Human inputs required:** inspection authority, system/consumer owners, purpose, semantics, tolerances, configuration precedence, real parallel-run legal/privacy profile.

## Phase 9 — Cutover rehearsal, archive, trust removal, and decommission game days

**Lab/staging only until production authority.** Prove authority fence, pre-trust rollback, progressive rings, complete monitors, layered read-only archive, credential/session/permission/secret/network removal, buffer dispositions, residual sensors, exceptions, and independent acceptance.

**Precision gained:** exact commands/owners/rollback expiry; archive topology; trust-removal evidence horizon; cleanup and support effort; final decommission predicates.

## Phase 10 — Pilot and production candidacy

**HUMAN DECISION.** Technical evidence may produce a bounded production-candidate package. Production authority still requires approved purpose/lawfulness/prohibited uses, employee consultation, fields/identity/retention/access, supported estate, staffing/on-call/support, budget/licensing, SLO/RPO/RTO, incident readiness, accessibility, cutover/decommission plan, risk acceptance, and go-live approval.

## Progressive-precision rule

At each phase:

1. replace only the estimates relevant to that phase with measured distributions or explicit owner decisions;
2. bind exact versions to evidence, not architecture prose;
3. retain unsupported dimensions as disabled or separate future tuples;
4. avoid broadening a prior contract merely to make a test pass;
5. expire evidence on dependency, release, environment, incident, or support change;
6. preserve first failures and limitations; and
7. update the baseline only with accepted decisions whose named gate has passed.

---

# 13. Human decision register and workshop sequence

## 13.1 Consolidated human decision register

The table groups overlapping decisions from all six batches. It does not make them. Accountable roles are functions, not assigned people.

| ID | HUMAN DECISION | Options and consequences | Accountable role/function | Safe temporary state | Earliest blocked work |
|---|---|---|---|---|---|
| HD-F01 | Product purpose, lawful basis, prohibited uses, and whether UAM is appropriate | Approve narrow operational purpose; approve with conditions; reject. Consequences affect every field, access, retention, report, migration, and support path. | Data Controller / Business Product Owner with Legal, Privacy, Workforce Governance | T1 fictional data only; no live collection or person interpretation | any live source, pilot, production |
| HD-F02 | Workforce consultation, notice, appeal, and prohibited productivity/disciplinary use | Required process and affected populations; consequences include delay or scope reduction. | Employee Relations / Works Council authority with Legal/Privacy | no workforce deployment | pilot/production |
| HD-F03 | Source list and first Edge slice enablement | Edge only; other sources later; no source. Each source adds privacy/compatibility/support obligations. | Product/Data Owner with Privacy/Security | release registry contains synthetic source only; live disabled | G2 live activation |
| HD-F04 | Event/site/time/identity fields and precision | app+host, app+registrable domain, other minimum; UTC precision; subject/device/session relation. More detail increases privacy/retention/access burden. | Product/Data Owner with Privacy, IAM, Legal | no production event; app-only T1 negative profile | G4 output contract, reports |
| HD-F05 | First-run lookback and schedule | zero lookback, bounded time, time+count; frequency/quiet hours. Lookback increases historic collection and load. | Product/Data Owner with Privacy/Legal/Operations | atomic zero-lookback technical fallback; live disabled | checkpoint initialization/live policy |
| HD-F06 | Hard-deny categories, port, IDN, PSL semantics | structural only; approved semantic deny list; ASCII-only or Unicode; canonical host or registrable domain. | Product Privacy Authority with Security/Internationalization/Accessibility | ASCII, default ports, no PSL, structural deny, output disabled | live G4 profile |
| HD-F07 | Realm definition and identity projection | customer/legal/data boundary; device/install/subject relationships; central oversight. | Data Controller/Product Governance with IAM/Data Architecture | one fictional realm; no person relation | production enrollment, portal, deletion |
| HD-F08 | Retention and deletion by purpose/store/destination | periods, age bases, holds, audit/tombstone/receipt/quarantine horizons, external copies. | Records Management/Data Controller with Legal/Privacy/Security | no production sweep/expiry; suppress/retain T1 by fixture manifest | storage sizing, deletion, backup expiry |
| HD-F09 | Subject-resolution and rights workflow | approved selectors/sources, conflict behavior, response/evidence burden. | Data Governance/IAM with Legal/Privacy | fictional exact selector only | production deletion/rights cases |
| HD-F10 | Access, roles, standing/JIT, approvals, SoD, delegation | who can view/change/export/approve; quorum and staffing consequences. | IAM/Product Governance/Security with domain owners | no production assignments; high-risk disabled | portal/admin/support |
| HD-F11 | Real portal tasks, detail/export necessity, aggregate semantics | aggregate-only; limited operational detail; approved person/activity detail; export purpose/recipients. | Product Governance/Data Owner with Privacy/Legal/Workforce Governance | aggregate T1 shell; no detail/export | IA/read models/workflows |
| HD-F12 | Identity provider, authentication assurance, session policy | issuer/federation, MFA/passkeys, reauth, logout, guests, shared devices, accessibility alternatives. | Enterprise IAM/Federation with Security/Risk/Accessibility | synthetic issuer; finite T1 session | production BFF/session/high-risk commands |
| HD-F13 | PKI, device assurance, algorithms, key custody, recovery | TPM/A2/A3 requirements, software exceptions, CA/MDM/RA, certificate profile/lifetime, HSM/KMS/quorum. | PKI/Cryptographic Authority with Product Security/Operations | lab CA/test keys; A1 disabled | production enrollment/signing/control/audit |
| HD-F14 | Network/gateway/proxy/VPN/TLS inspection support | direct mTLS, L4, L7 signed assertion, proxy/PAC/VPN profiles, fail policy. | Network Security/Architecture with IAM/API/SRE | direct mTLS only | enterprise network support |
| HD-F15 | Supported Windows/browser/profile/EDR/platform matrix | exact OS/build/arch/Edge/session/profile/EDR; RDS/VDI/FSLogix/Citrix/ARM64/power. | Product Support/Endpoint Platform/Security/Accessibility | one exact lab tuple; no `SUPPORTED` claim | engineering canary/commercial support |
| HD-F16 | Resource, storage, batch, outage, and loss policy | endpoint quotas, offline duration, pressure pause/loss, page/batch/retry/budget, support impact. | Product/Risk/Data Owner/SRE/Records | pause and retain; small T1 limits; no lossy terminal state | production endpoint sizing/outage promise |
| HD-F17 | Receipt failure domain, endpoint cleanup, RPO/RTO | commit/replica/archive boundary; ACK grace; replay source; clock; cleanup horizon; maximum loss. | Product Risk/Data Owner/Data Reliability/SRE/Records | production cleanup disabled | endpoint deletion after ACK |
| HD-F18 | Database engine, topology, operations, licensing, TCO | PostgreSQL/SQL Server, managed/self-managed, HA/DR, edition, support, skills, maintenance. | Architecture/Product/Operations/Procurement/Finance/Legal | paired T1 candidates | production server schema/topology |
| HD-F19 | Demand, capacity, SLO, headroom, fairness, backlog objectives | fleet/activity/bytes/retries/outages/query/retention distributions; tails/headroom/drain/cost. | Product/Data/Endpoint Operations/SRE/Risk | synthetic scenarios; no production pass threshold | capacity/support/broker decision |
| HD-F20 | Broker or other platform expansion | remain relational; add broker/search/CDC/analytical store after measured triggers. | Architecture/SRE/Security/Finance/Product | absent | any external broker/search/CDC adoption |
| HD-F21 | Diagnostics/support scope, backend, access, retention, encryption | safe signal catalogue, failures support must solve, backend/vendor, roles, bundle recipients, residency/deletion. | Support Operations/SRE with Privacy/Security/Legal/Procurement | local T1 bundle, no remote backend/permit | production support and support promise |
| HD-F22 | Release/signing/updater policy | installer tool/license, code-signing CA/timestamp/key quorum, enterprise patch SLA, autonomous updater need/TUF. | Release/Signing/Endpoint Management with Security/Legal/Procurement | enterprise-only, lab signing | production release/updater |
| HD-F23 | Audit purpose, fields, access, retention, verifier, checkpoint, evidentiary claim | operational accountability only or stronger external claim; independent owner/store/key/time; pruning/holds. | Security/Audit/Records/Legal/Privacy/Risk | T1 taxonomy/verifier/local anchor; no legal claim | privileged production surface |
| HD-F24 | Accessibility and localization support policy | WCAG target, EN 301 549 mapping, browser/AT matrix, languages/RTL, exceptions, support. | Accessibility Owner/Product/Legal/Procurement/Support | WCAG 2.2 AA engineering target; T1 matrix | production portal/support statement |
| HD-F25 | Legal holds, backup, sanitization, crypto erase, external recipient deletion | authority/scope/review/release; backup chain/copies/PITR; key/media destruction; recipient limitations. | Legal/Records/Security/SRE/Data Controller | hold blocks destruction but not suppression; no crypto-erasure claim | lifecycle/decommission |
| HD-F26 | Inspection authority and authoritative legacy population | systems/fields/time/access; CMDB/population source; coverage owner. | System/Data Owners with Security/Privacy/Legal | no real connection; T1/offline only | real discovery/migration |
| HD-F27 | Legacy outcome dispositions, report semantics, known defects, tolerances, configuration precedence | preserve/change/retire/investigate; exact versus deliberate change; scoped expiring tolerances. | Product/Data/Application/Report Owners with Architecture/Privacy/Security | all unknown items quarantined; no active tolerances | reconciliation/cutover |
| HD-F28 | Real parallel-run profile and comparison identity | purpose/cohort/fields/access/retention; source-range/event/aggregate identity; time/bucket/late semantics. | Data Controller/Product/Data Owners with Privacy/Legal/Workforce Governance | T1 shadow only | real parallel validation |
| HD-F29 | Cutover cohorts, fence, promotion, bake, rollback expiry | common boundary, gap/overlap policy, rings, monitor coverage, new N-1, pre-trust legacy contingency. | Production/Change Risk Authority with Migration/SRE/Data Reliability | no authority transfer; human promotion; automatic pause only | cutover |
| HD-F30 | Archive purpose/topology/fields/access/retention and compatibility bridge | original DB read-only, copy behind BFF, typed import; whether a temporary named consumer bridge is allowed. | Data Controller/Records/Product/Data Architecture/Integration | read-blocked; no bridge | historical access/final decommission |
| HD-F31 | Credential/session/permission/secret/network removal and evidence horizon | owner/consumer map, revoke/rotate, session kill, secret-copy cleanup, alternate routes, monitoring duration. | Security/IAM/PKI/DB/Network Owners with Records | no destructive removal until mapped; central trust not silently prolonged | trust-removal gate |
| HD-F32 | Legacy buffer disposition and unreachable devices | drain pre-fence, typed transform, quarantine/hold, approved discard; revoke trust and re-enroll returning devices. | Data Owner/Records/Privacy/Legal/Data Reliability/Endpoint Owner | frozen/quarantined; never execute/delete automatically | buffer/trust-removal/decommission |
| HD-F33 | Residual exceptions and final decommission risk acceptance | exact contained exceptions, expiry, external-copy limitations, final deletion, owner quorum. | Designated Production/Risk Authority with affected owners | every unresolved exception blocks or explicitly limits technical acceptance | final decommission |
| HD-F34 | Staffing, skills, on-call, support hours, incident command, training | sustainable owners and recurring evidence/lab/accessibility/restore/migration coverage. | Engineering/Operations/Security Leadership | capability disabled without coverage | canary/pilot/production |
| HD-F35 | Budget, licensing, procurement, commercial support | tools, DB, PKI/HSM, CI/lab, observability, support, archive, accessibility. | Product/Finance/Procurement/Legal | no unapproved spend or dependency | technology selection/operations |
| HD-F36 | Engineering canary, pilot, production, cutover, and go-live approval | exact scope, residual risk, rollback, communications, customer/workforce/regulatory obligations. | Designated Lab/Architecture/Risk/Production authorities | prohibited | all non-T1 use |

## 13.2 Workshop sequence

Workshops are decision forums, not substitutes for technical gates. Each produces immutable decisions, dissent/limitations, owners, review triggers, and safe states.

### Workshop 1 — Purpose, prohibited uses, and workforce governance

**Decisions:** HD-F01, HD-F02.  
**Inputs:** accepted telemetry limitations, first-slice description, misuse scenarios, consultation obligations.  
**Outputs:** purpose registry candidate, prohibited-use controls, notice/consultation plan, explicit no-go populations/use cases.  
**Safe state if unresolved:** T1 only.

### Workshop 2 — Data-minimization and source contract

**Decisions:** HD-F03–HD-F07.  
**Inputs:** G0 fictional examples, G2/G4 candidate semantics, identity/time/site alternatives, hard-deny/IDN/PSL trade-offs.  
**Outputs:** exact live source/field/precision/lookback candidate, identity relation, hard-deny ownership, disabled alternatives.  
**Safe state:** no live event.

### Workshop 3 — Retention, rights, holds, backup, and external copies

**Decisions:** HD-F08, HD-F09, HD-F25.  
**Inputs:** lifecycle copy/resurrection map, resolver choices, audit/tombstone/receipt needs, backup/connector/export capabilities.  
**Outputs:** immutable policy candidates, selector authority, hold model, truthful limitation language, review triggers.  
**Safe state:** suppress/retain; no sweep/expiry/legal-completion claim.

### Workshop 4 — Realm, access, authorization, and portal purpose

**Decisions:** HD-F07, HD-F10–HD-F12.  
**Inputs:** capability catalogue, aggregate-first IA, JIT/approval/SoD options, detail/export risks, IdP inventory.  
**Outputs:** realm/global model, initial user/task map, purpose/role/grant/approval profiles, disabled capabilities, authentication candidate.  
**Safe state:** fictional personas; no production access.

### Workshop 5 — Cryptographic, identity, network, release, and emergency authority

**Decisions:** HD-F13, HD-F14, HD-F22, relevant break-glass/key parts of HD-F23.  
**Inputs:** key-purpose map, PKI estate, direct/L7/proxy options, MSI/updater evidence requirements, incident/recovery paths.  
**Outputs:** candidate assurance profiles, key owners/quorum, test PKI/production boundary, network profiles, updater decision, break-glass constraints.  
**Safe state:** lab keys, direct mTLS, enterprise-only deployment, break-glass disabled.

### Workshop 6 — Reliability objectives, endpoint limits, receipt, and capacity

**Decisions:** HD-F16–HD-F20.  
**Inputs:** G5/B04 models, synthetic scenarios, outage/recovery equations, receipt failure-domain alternatives, DB candidate responsibilities.  
**Outputs:** measurement inputs, candidate SLO/RPO/RTO/headroom/cleanup conditions, database comparison profile, broker trigger categories.  
**Safe state:** no cleanup/capacity/engine/broker decision.

### Workshop 7 — Diagnostics, support, audit, accessibility, and evidentiary scope

**Decisions:** HD-F21, HD-F23, HD-F24, HD-F34 support aspects.  
**Inputs:** safe diagnostic catalogue, blind-support results, audit threat model, verifier options, critical workflows, AT/browser inventory.  
**Outputs:** support promise, backend/access/retention candidates, independent verifier owner, audit purpose/fields/access, accessibility support matrix.  
**Safe state:** local T1 support; no privileged production/audit claim.

### Workshop 8 — Legacy discovery, semantic dispositions, and parallel-run profile

**Decisions:** HD-F26–HD-F28.  
**Inputs:** read-only discovery scope, owner/population inventory, report/configuration contracts, shadow isolation, comparison options.  
**Outputs:** inspection authorization, population/owner map, disposition process, exact comparison semantics, real shadow purpose/access/retention candidate.  
**Safe state:** offline/T1 only.

### Workshop 9 — Cutover, archive, trust removal, buffers, and decommission

**Decisions:** HD-F29–HD-F33.  
**Inputs:** reconciliation results, authority fence/rollback drills, archive candidates, credential/network/buffer inventory, residual sensors/exceptions.  
**Outputs:** cutover plan, rollback expiry, archive contract, removal cases, exception policy, decommission owner quorum and final-deletion boundaries.  
**Safe state:** legacy remains authoritative; no trust removal or final deletion.

### Workshop 10 — Production-candidate and go-live authority

**Decisions:** HD-F34–HD-F36 plus confirmation of all earlier decisions.  
**Inputs:** current aggregate technical gate package, operations/support/cost/licensing/accessibility/incident evidence, residual-risk register, communications.  
**Outputs:** approve bounded pilot/production, approve with conditions, or reject/return to a gate.  
**Safe state:** no pilot/production.

---

# 14. CLI measurement and experiment register, with evidence ingestion method

## 14.1 Evidence record required for every experiment

Every CLI/lab experiment MUST emit a machine-readable record with at least:

```yaml
experimentId: ""
claim: "one falsifiable sentence"
status: "PASS | FAIL | HOLD | INVALID_HARNESS"
source:
  repositoryCommit: ""
  cleanTree: true
  fileManifestDigest: "sha-256:..."
contracts:
  catalogueDigest: "sha-256:..."
  schemaDigests: []
configuration:
  productCeilingDigest: ""
  policyDigest: ""
  featureAndKillStateDigest: ""
release:
  releaseId: ""
  packageDigest: ""
  fileManifestDigest: ""
environment:
  scopeLabel: ""
  osBuildClass: ""
  architecture: ""
  runtimeVersions: []
  nativeSourceIds: []
  browserOrDatabaseVersions: []
  securityNetworkProfile: ""
toolchain:
  sdk: ""
  tools: []
  packageSourcesDigest: ""
fixtures:
  classification: "T1 | T2 | T3"
  packageRoot: ""
  seedAlgorithm: ""
  seed: ""
  fixedClockUtc: ""
  oracleRevision: ""
  canaryRegistryDigest: ""
execution:
  commandTemplate: "redacted placeholders only"
  startedAtUtc: ""
  completedAtUtc: ""
  faultPlanDigest: ""
  repetitions: null
results:
  rawArtifactDigests: []
  normalizedResultDigest: ""
  firstFailureRef: null
  retryRefs: []
  assertions: []
  resourceEvidence: {}
  limitations: []
privacyAndSecurity:
  positiveControlsPassed: true
  forbiddenEscapeCount: 0
  redactionAndCanaryScanDigest: ""
cleanup:
  beforeAfterDigest: ""
  status: "PASS | FAIL"
ownership:
  accountableFunction: ""
  reviewerFunctions: []
  humanDecisionRefs: []
  exceptionRefs: []
  evidenceExpiresAtUtc: ""
```

The record stores no credential, private key, raw activity, actual SSH command, host, address, port, internal URL, real identity, or customer configuration.

## 14.2 Evidence ingestion pipeline

```text
approved experiment request
  -> exact scope / authority / T1-T3 classification
  -> immutable run plan and pass/fail predicate
  -> sealed fixture + oracle + canary package
  -> isolated execution
  -> raw artifacts quarantined in the lab
  -> preserve first failure
  -> normalize to finite privacy-safe evidence
  -> exact canary/secret scan with positive controls
  -> hash raw and normalized artifacts
  -> cleanup/revert and before/after proof
  -> content-addressed evidence package
  -> independent reviewer verifies source/tool/environment/result mapping
  -> gate evaluator reads evidence only
  -> PASS / FAIL / HOLD / INVALID_HARNESS
  -> expiry and rerun trigger registered
```

### Ingestion rules

1. **Raw before normalized.** Raw results remain access-controlled and immutable long enough to investigate the run; the shareable package contains digests and minimum normalized facts.
2. **No repair in place.** A failed or malformed record is never edited into pass. The corrected run receives a new ID and links to the first failure.
3. **Harness is testable.** Every gate has a “harness lies” campaign that breaks one checker, canary, cleanup step, evidence field, or test hook and requires the gate to fail.
4. **Exact environment binding.** Results from another release, source tree, native provider, browser/database build, policy, fixture, or topology are not composed silently.
5. **Evidence expiry.** Dependency update, security advisory, release change, OS/browser/database update, source capability change, incident, support-policy change, or expired human exception invalidates affected claims.
6. **T3 stronger than prose, not broader than approval.** Reproducible project-specific measured evidence outranks generic vendor capability for the tested claim, but cannot authorize fields, purpose, access, retention, risk, or production.
7. **Cleanup is part of the result.** A technically correct result with service/task/file/key/rule/process/VM/container residue is a failed gate.
8. **Positive controls are mandatory.** Absence or quiet-window claims are invalid unless the relevant sensor/scanner/checker first detects the planted control.

## 14.3 Consolidated experiment register

| ID | Experiment family | Input class | Current status | Pass establishes | Primary stop |
|---|---|---|---|---|---|
| EXP-00 | Evidence input/toolchain/source mapping | T1 metadata | **open** | exact reproducible review/build boundary | unlisted input, floating/unmapped tool, leaked secret |
| EXP-01 | Strict contract/UUID/time/Unicode vectors | T1 | **open** | common contract/scalar profile | authority-bearing false accept, remote ref, nondeterminism |
| EXP-02 | G0 deterministic package/oracle/mutation/canary | T1 | **next/open** | reusable evidence foundation | nondeterminism, oracle coupling, mutation survivor, canary miss |
| EXP-03 | Repository graph/reproducibility/SBOM/provenance | T1 | **open** | build/release evidence integrity | forbidden dependency, unexplained bytes, inventory omission |
| EXP-04 | Policy lattice/registry/matcher pure models | T1 | **open** | monotonic policy and deterministic application assignment | tenant broadening, guessed ambiguity, cross-realm relation |
| EXP-05 | IPC codec/parser bake-off | T1 | **blocked by contracts/G0** | selected physical local protocol | both candidates fail security/resource/compatibility |
| EXP-06 | Windows G1 install/token/task/pipe/containment | T1 disposable VM | **blocked by G0/codec/lab authority** | one exact endpoint trust-boundary tuple | cross-session access, prohibited privilege, escape, residue |
| EXP-07 | Edge G2 zero-write direct/backup/defer | T1 disposable Edge VM | **blocked by G1** | safe acquisition for exact tuple | source write/corruption/incomplete backup/raw escape |
| EXP-08 | Edge G3 source/generation/native cursor | T1 disposable Edge VM | **blocked by G2** | controlled recall and continuity | source/session/realm mix, timestamp cursor, false generation |
| EXP-09 | Edge G4 URL minimization/matcher/all-sink | T1 disposable Edge VM | **blocked by G2/G3/purpose field candidate** | pre-IPC privacy containment | forbidden escape, guessed ambiguity, mixed interpretation |
| EXP-10 | G5 pure model and instruction failpoints | T1 | **blocked by unified page contract** | logical atomicity, stable retry identity | cursor ahead, missing/double effect, ambiguous deletion |
| EXP-11 | G5 real process/reboot/disk/WAL/security-product faults | T1 Windows/VM/physical as required | **blocked by EXP-10/G1** | operational endpoint durability for exact tuple | corruption, silent loss, false recovery, cleanup residue |
| EXP-12 | MSI lifecycle/release tamper/rollback/storage compatibility | T1 Windows | **blocked by repo/release scaffolding** | immutable authorized N/N-1 release | mixed/unauthorized/downgraded execute, repair/data loss |
| EXP-13 | Installation identity/enrollment/revocation/clone/mTLS | T1 lab CA | **blocked by PKI test profile** | unique realm-bound credential | shared/exported key, wrong realm accepted, clone wins |
| EXP-14 | Diagnostic catalogue/cardinality/permit/bundle/support | T1 | **open after contracts** | privacy-safe support for named failures | raw escape, arbitrary input, permit residue, undiagnosable critical set |
| EXP-15 | Exact compatibility evaluator and first endpoint tuple | T1 exact environment | **blocked by EXP-06–14** | `QUALIFIED` engineering tuple | stale/broad/multiple match, missing predecessor evidence |
| EXP-16 | Server atomic custody/response loss/receipt conflict | T1 DB lab | **blocked by contract/server scaffold** | durable receipt semantics | receipt without exact committed bytes |
| EXP-17 | Server lease/one-effect/poison/reprocess/realm | T1 DB lab | **blocked by EXP-16** | idempotent materialization and quarantine | stale commit, duplicate effect, cross-realm, unbounded poison |
| EXP-18 | Projection/integration/reconciliation | T1 DB lab | **blocked by EXP-17** | derived one-effect and reconcileability | duplicate/missing contribution/message or unexplained state |
| EXP-19 | Paired PostgreSQL/SQL Server semantic parity | T1 identical harness | **blocked by server model** | both candidates meet hard semantics | semantic divergence, false receipt, restore invariant fail |
| EXP-20 | Backup/PITR/failover/operator recovery | T1 exact topology | **blocked by candidate profiles** | real recoverability/operations evidence | acknowledged loss, false readiness, split-brain, unowned operation |
| EXP-21 | Stateful/open-arrival simulator qualification | T1 | **open after wire contract** | trustworthy offered-demand model | generator saturation, hidden drop, clock/evidence error |
| EXP-22 | 6k/12k/reconnect/endurance/fairness capacity | T1 + approved aggregate inputs later | **blocked by EXP-21/human objectives** | bounded scenario result, not generic support | correctness failure, no drain, starvation, unknown threshold |
| EXP-23 | Resolver/barrier/tombstone/store adapters | T1 | **open after lifecycle contracts** | immediate invisibility and exact target authority | wrong subject/realm, stale reader, effect before barrier |
| EXP-24 | Connector/export/backup catalogue/expiry | T1 | **blocked by typed adapters** | capability-bounded lifecycle evidence | false external completion, unknown copy/key/chain |
| EXP-25 | Old-backup + current tombstone + ACK restore drill | T1 exact DB profile | **blocked by EXP-16–24** | restore invariant and readiness | deleted visible, ACK missing/duplicate, gap/fork, egress before ready |
| EXP-26 | BFF/session/CSRF/realm/caches/logout | T1 synthetic IdP/browser | **open after portal scaffold** | browser trust boundary | browser token, CSRF state change, stale/cross-realm session |
| EXP-27 | Capability/purpose/JIT/approval/command/jobs | T1 fictional personas | **open after catalogue** | current exact authorization/workflow | missing purpose, stale/revoked authority, duplicate effect |
| EXP-28 | Transactional audit/access-before-disclose | T1 both DB candidates | **blocked by EXP-27/server transaction** | effect/decision/audit atomicity and read audit | effect without audit, false success, bytes before audit |
| EXP-29 | Audit tamper/checkpoint/restore verifier | T1 isolated verifier | **blocked by canonical profile/key test** | independent gap/alteration/fork/rollback detection | tamper survives, local rollback trusted, self-clear |
| EXP-30 | Accessibility complete workflows | T1 supported browser/AT candidates | **open incrementally** | critical task completion/understanding | pointer/vision/color/inaccessible-auth dependency |
| EXP-31 | Legacy discovery no-execution/no-mutation/coverage | T1 then approved read-only estate | **real run human-blocked** | bounded evidence graph and coverage claim | arbitrary execution, mutation, raw/secret escape, unknown writer/consumer |
| EXP-32 | Shadow isolation/no-dual-write/comparison | T1 then approved real profile | **real run human-blocked** | one authority and exact comparison behavior | endpoint reaches both, shadow ordinary egress, open range |
| EXP-33 | Configuration transform/fence/rollback/rings | T1 lab/staging | **human-blocked for real cutover** | no-broadening transform and safe authority transfer | ambiguous fence, two writers, unsafe rollback, monitor blind |
| EXP-34 | Archive read-only/trust removal/buffer/residual | T1 lab/staging | **human-blocked** | layered denial and observable residue | successful write/path/session, raw SQL execution, expired exception |
| EXP-35 | Independent decommission acceptance | T1 game day then production evidence | **blocked** | reproducible technical PASS/HOLD record | missing owner/evidence, stale result, exception/residue, evaluator mutation |

## 14.4 Evidence ingestion into the technical baseline

A CLI result may update this baseline only when:

1. its experiment is in the register or an accepted ADR adds it;
2. the input, source, release, contract, environment, tool, fixture, oracle, and canary identities are exact and current;
3. the pass predicate was preregistered and no primary invariant was waived;
4. the first failure, raw digests, normalized evidence, limitations, and cleanup are preserved;
5. the evidence is independently reviewed;
6. all blocking human owner functions and required decisions are present;
7. the result applies to the same architecture decision being updated;
8. no adjacent component is silently redesigned; and
9. the update states whether the conclusion is architecture-level, exact-tuple qualification, production-candidate, or human production approval.

A failed experiment may narrow or reject a candidate implementation. It changes the accepted architecture only through a formal change proposal containing the affected decision, new evidence, invariant impact, alternatives, smallest falsifying experiment, migration/rollback consequence, and ADR action.

---

# 15. Operational ownership, runbooks, cost/skills/licensing, accessibility, and support gaps

## 15.1 Operational ownership map

Accountable functions must be assigned before their capability gate closes. One person may hold multiple functions only when the approved separation-of-duty profile permits it.

| Function | Owns | Must be independent from / constrained by | Current gap |
|---|---|---|---|
| Chief Architecture / Baseline Authority | accepted architecture, gate order, baseline changes, ADR coherence | cannot approve legal purpose or production risk alone | named individual/forum not supplied |
| Contract Authority | contract catalogue, scalar profile, compatibility, deprecation | domain owners and security/privacy review | owner not supplied |
| Test Data Steward | T1/T2/T3 classification, lineage, expiry/deletion | independent oracle and privacy review | owner not supplied |
| Independent Oracle / Verification | truth, model histories, mutation, gate evaluator | no production decision-code ownership for the same rule | owner/organizational independence not supplied |
| Privacy Verification | canaries, sink inventory, scanner positive controls, incident containment | source/feature owners cannot waive misses | owner not supplied |
| Repository / Build / Release Engineering | locks, CI trust zones, reproducibility, SBOM/provenance, signing handoff | signing authority separate; untrusted lane no secrets | platform/tooling choice and owner open |
| Endpoint Runtime Owner | Coordinator/User Host/Task Host, IPC, session lifecycle | Windows Security and Source Capability review | owner and on-call open |
| Windows Security / Compatibility Authority | token/ACL/task/service/firewall/EDR/platform tuple | cannot infer support from vendor family | lab/support matrix and owner open |
| Source Capability Owner | Edge discovery/acquisition/parser/minimization | privacy and endpoint runtime boundaries | owner and recurring Edge qualification open |
| Endpoint Storage Reliability | SQLite writer, migrations, batches, pressure, recovery | transport cannot write store directly | provider/support/owner open |
| Device Identity / PKI Authority | enrollment, key assurance, certificate/status lifecycle | realm/product governance and security risk | production PKI and owner open |
| Diagnostics / Support Engineering | safe catalogue, permits, journal, bundles, support workflows | no raw fallback; privacy/support access governance | backend/support promise/owner open |
| Server IAM / Ingestion Security | authenticated context, credential status, gateway proof | payload cannot create realm | topology and owner open |
| Data Reliability / Database Engineering | custody, leases, one effect, backup/restore, DB operations | receipt semantics and lifecycle owners | engine/topology/on-call open |
| Materialization / Data Correctness | semantic plan, event ledger, quarantine/reprocess | lease fencing and realm isolation | owner open |
| Product Data / Projection Owners | facts, aggregates, interpretation/quality | cannot create new collection purpose | fields/semantics owners open |
| Integration Owners | typed destination contracts, receipts, deletion capability | UAM custody/fact truth remain independent | destinations/owners unknown |
| Lifecycle / Records Engineering | resolver, barrier, tombstones, targets, restore readiness | legal/records decisions remain human; holds separate | owner/policy open |
| Portal Security / Authorization | BFF/session, capabilities, purpose/target/output, JIT/approval | IAM input is not final authority | real IdP/roles/owners open |
| Audit Engineering / Independent Verifier | canonical ledger, access audit, segments/checkpoints, verification | verifier credentials/state/admin separate | independent owner/store/key open |
| Accessibility Owner | critical workflow standards, browser/AT matrix, regression | cannot be replaced by automated scanner/design-system claim | owner/support matrix open |
| Migration Discovery / Data Reconciliation | evidence graph, dispositions, comparison, fence | legacy is not oracle; no authority creation | inspection authority/owners unknown |
| Cutover / Change Authority | rings, pause, promotion, rollback expiry | technical evaluator cannot self-promote | named authority and support coverage open |
| Security/IAM/PKI/DB/Network Decommission Owners | trust removal and residual evidence | no single control proves completion | estate maps and owners unknown |
| Independent Decommission Evaluator | recompute predicates/evidence/exception state | cannot mutate source evidence or approve risk | implementation/owner open |
| Incident Command | privacy, realm, durability, receipt, identity, audit, restore, migration incidents | ordinary product admins cannot self-clear critical holds | staffing/escalation/communications open |
| Product Risk / Production Authority | canary, pilot, cutover, production, final decommission risk acceptance | must consume current technical and human evidence | no approval supplied |

## 15.2 Runbook register

| Runbook | Minimum content | Required before | Current state |
|---|---|---|---|
| RB-01 G0 deterministic evidence | clean generation, oracle, mutation, canary, cleanup, gate recomputation | G0 closure | **to create now** |
| RB-02 Contract/schema incident | freeze contract, affected producers/consumers, vector correction, compatibility rollback | active contract | **missing** |
| RB-03 Windows G1 install/cleanup | preflight, install, token/ACL evidence, hostile tests, uninstall/revert | G1 execution | **missing** |
| RB-04 Source write/privacy incident | stop capability/ring, preserve checkpoint, trace/canary scope, cleanup, requalification | G2/G4 | **missing** |
| RB-05 Endpoint corruption/pressure/ACK ambiguity | hold store, preserve data, classify commit/custody, same-ID retry, no cleanup | G5/canary | **missing** |
| RB-06 Release tamper/mixed version/rollback | freeze, verify slots/files/manifests, select known good, enterprise repair | release gate | **missing** |
| RB-07 Key/certificate revoke/clone/re-enroll | deny, duplicate hold, status propagation, new key/epoch/store implications, cleanup | identity gate | **missing** |
| RB-08 Diagnostic permit/bundle incident | revoke/expire, stop enhanced signals, canary scan, artifact custody/deletion, support communication | diagnostics gate | **missing** |
| RB-09 False receipt/lost acknowledged data | disable endpoint cleanup, reconcile custody/backup, restore/replay, incident authority | server production candidacy | **missing** |
| RB-10 Poison/quarantine/reprocess | classify, bound retries, preserve custody, approve new generation, reconcile one effect | ingestion gate | **missing** |
| RB-11 Database failover/restore | failover fencing, receipt/read authority, backup/PITR restore, operator evidence, rollback | DB selection | **missing** |
| RB-12 Capacity/backlog emergency | pause/narrow, admission/fairness, preserve data, drain under new arrivals, evidence | capacity gate | **missing** |
| RB-13 Deletion/tombstone/connector failure | maintain suppression, hold destruction, target retry/limitations, audit | lifecycle gate | **missing** |
| RB-14 Isolated restore/readiness | new identity, no egress/receipt, tombstone/ACK reconciliation, probes, separate enable | lifecycle/production | **missing** |
| RB-15 Portal JIT/approval/job failure | revoke/expire, reconcile command ID, stop future phases, preserve audit | B05 gate | **missing** |
| RB-16 Audit gap/fork/checkpoint failure | scoped hold, external state comparison, gap declaration/linked epoch, no self-clear | privileged production | **missing** |
| RB-17 Accessible authentication/recovery outage | accessible alternative, authority unchanged, draft preservation, reauth | portal support | **missing** |
| RB-18 Discovery false-positive/false-negative | preserve evidence, owner challenge, population reconciliation, rerun | real discovery | **missing** |
| RB-19 Cutover pause/pre-trust rollback | freeze authority, close ranges, higher epoch, stable IDs, support communication | real ring | **missing** |
| RB-20 Legacy trust removal/residual write | terminate session/path, preserve evidence, reopen case, block acceptance | trust removal | **missing** |
| RB-21 Final decommission/late finding | independent recomputation, owner quorum, limitations, linked reopening, no history edit | final decommission | **missing** |

## 15.3 Skills and operational competence gaps

| Skill area | Required competence | Evidence still missing |
|---|---|---|
| C#/.NET secure systems | strict parsing, async/resource bounds, source generation, native interop, Windows services, cryptography, deterministic tests | named maintainers and current supported patch/process |
| Windows internals | service/task tokens, logon SID/LUID, named pipes, ACL/SDDL, restricted tokens, Job Objects, integrity, reparse/path safety, firewall/EDR | exact lab/estate competence and on-call |
| SQLite reliability | native provider/source mapping, WAL/checkpoint/backup/limits, crash/pressure/corruption/migration, filesystem durability | selected provider/support owner and real fault evidence |
| Browser internals | Edge profile/policy/schema/locking/sync behavior, compatibility qualification | recurring exact-build qualification owner |
| PKI/crypto | Windows CNG/TPM, enterprise CA/RA, mTLS, status/revocation, KMS/HSM, key ceremonies, canonical signing | production architecture, custodians, recovery drills |
| Relational database engineering | PostgreSQL and SQL Server transactions, locking, partitioning, backup/PITR/failover, security, tuning, operator drills | paired operational team/skills/TCO evidence |
| SRE/capacity | stateful/open-arrival modeling, backpressure, fairness, outage recovery, observability cardinality, SLO/error budgets | approved objectives, distributions, recurring load/lab capability |
| Privacy/data governance | purpose/field/identity/retention/access, hard denies, employee consultation, rights/holds/external copies | accountable decisions and review cadence |
| Secure web/identity | BFF/OIDC, CSRF/session, authorization, JIT/SoD, cache/job realm safety | exact IdP/topology and operators |
| Audit/verification | transactional audit, canonicalization, hash/Merkle, independent checkpoints, incident/restore verification | independent owner, key/store/time, evidentiary scope |
| Accessibility/UX | WCAG 2.2 complete-process testing, screen readers, keyboard, zoom/reflow, forced colors, accessible security workflows | real user/browser/AT/language matrix and owner |
| Migration/decommission | read-only discovery, report semantics, comparison/fences, progressive rollout, credential/network removal, archive/records | estate inventory, owners, game-day experience |

## 15.4 Cost, licensing, and procurement register

No cost or product selection is approved. The following categories require explicit option, unit, volume, term, owner, and exit-cost evidence:

| Category | Cost/licensing questions | Safe state |
|---|---|---|
| .NET/runtime/build | self-contained patching responsibility, package mirror, trusted runners, Windows lab/physical hardware | use accepted family and T1 tooling only |
| Installer/signing | WiX or alternative EULA/source terms, code-signing CA/timestamp, HSM/KMS, ceremonies | test MSI/lab signing only |
| Endpoint native SQLite | provider/native bundle, commercial support, SEE/SQLCipher or other encryption licensing | prototype adapter only |
| Database | PostgreSQL support provider/managed service; SQL Server edition/core/replica/licensing; storage/HA/backup/DR | paired lab candidates |
| PKI/identity | CA/MDM/RA, HSM/KMS, status service, TPM/vTPM support, certificate operations | disposable lab CA |
| CI/test/lab | Windows images, physical devices, browsers, container/fault tooling, accessibility/AT, destructive lab isolation | minimum T1 environment |
| Observability/support | backend/vendor, storage/index/search/retention, secure bundle case system, support staffing | local T1 bundle only |
| Portal/design system/BFF | commercial BFF, design-system assets/fonts, browser/AT support, localization | built-in/local standards-first prototype |
| Audit checkpoint | separate account/object/WORM/witness service, keys, verifier operations, long-term validation | local isolated T1 anchor |
| Migration/archive | discovery orchestration, SQL/endpoint/network/PKI operations, shadow storage, archive DB/storage, residual monitoring | offline/T1 prototypes |
| External tools | package/image/transitive licenses, AGPL/source-available/commercial terms, security support, exit/migration | reference-only until admitted |

A three-year TCO decision for the database and major services must include engineering, on-call, licensing, support, training, upgrades, backup/restore, labs, accessibility regression, incident work, and exit/migration—not only infrastructure list price.

## 15.5 Accessibility gaps

- No actual workforce browser/assistive-technology/language matrix is supplied.
- No complete critical workflow has passed keyboard, screen-reader, zoom/reflow, forced-colors, reduced-motion, status-message, timeout, authentication, error-recovery, and destructive-confirmation tests.
- No formal EN 301 549/procurement mapping or conformance statement is approved.
- Design-system candidates have not been admitted or tested in composed UAM workflows.
- CLI/evidence/review tools also need accessible output and an alternative review format; inaccessible approval evidence is not valid process evidence.
- Accessibility regressions must expire platform/portal compatibility evidence just like security or browser changes.

## 15.6 Support gaps

- No support promise defines which failures L1/L2/L3 must solve without raw activity.
- No production diagnostic backend, case system, encrypted bundle recipient, access model, retention, deletion, or staffing exists.
- No exact endpoint platform is commercially supported; at most a future tuple may become technically `QUALIFIED`.
- No database/on-call/restoration team has demonstrated the required drills.
- No independent audit verifier or decommission evaluator owner is assigned.
- Fail-closed behavior can cause coverage gaps, backlog, administrative outage, or archive unavailability; communication and escalation expectations are unknown.
- No out-of-hours support/cutover/rollback window or incident command is approved.
- Supporting a broader platform or richer diagnostic path is not a hidden implementation default; it is a measured capability and human commitment.

---

# 16. ADR creation and update plan

## 16.1 ADR governance rules

1. An ADR records a technical decision, its scope, evidence, alternatives, consequences, migration/rollback, and review triggers. It does not approve a **HUMAN DECISION**.
2. A proposed ADR is not `Accepted` merely because this synthesis recommends it. Its accountable owner, dependent contracts, and applicable proof gate must be recorded first.
3. An accepted-baseline invariant may be changed only through a formal change proposal containing the affected decision, new primary or CLI evidence, security/privacy/realm/durability impact, alternatives, smallest falsifying experiment, migration consequence, and rollback/ADR action.
4. Exact versions, limits, timeouts, retries, budgets, algorithms, key lifetimes, support tuples, and retention values belong in evidence-backed profiles or decision records. They are not copied into timeless architecture ADRs unless the protocol itself requires the value.
5. Superseded batch/topic ADRs are mapped to one consolidated ADR rather than duplicated. Historic decisions remain immutable and link to the superseding record.
6. Every ADR has one state from `Proposed`, `Experimenting`, `Accepted`, `Rejected`, `Superseded`, `Deferred`, or `Withdrawn`; an open **HUMAN DECISION** or failed hard gate prevents `Accepted` where it is load-bearing.
7. Every accepted ADR records its invalidation triggers: dependency lifecycle change, semantic-contract change, evidence expiry, incident, platform change, failed fitness function, owner change, or new legal/business constraint.

## 16.2 Consolidated ADR catalogue

| ADR | Title and decision boundary | Initial status | Required evidence or authority before acceptance | Updates or supersedes |
|---|---|---|---|---|
| ADR-FS-001 | Final synthesis scope, accepted invariants, proof-gate order, and stop rule | **Proposed for immediate acceptance** | architecture forum confirms this eight-file synthesis and records owners; no technical CLI result required to preserve the supplied baseline | umbrella index for all batch review decisions |
| ADR-FS-002 | Evidence vocabulary, immutable evidence records, first-failure retention, expiry, cleanup, and independent gate evaluation | **Proposed** | G0 evidence schema and evaluator self-tests | evidence rules and batch gate formats |
| ADR-FS-003 | Contract catalogue and strict scalar profile: JSON Schema 2020-12, closed JSON, UUIDv7, SHA-256 profile, UTC/time precision, field-specific Unicode | **Experimenting** | parser/validator/UUID/time/Unicode vectors; tool admission; compatibility matrix | Batch 01 contract and scalar ADRs |
| ADR-FS-004 | Monorepo boundaries, deployable/module dependencies, locked restore, CI trust zones, reproducibility, SBOM, provenance, signing handoff | **Experimenting** | architecture mutations, sealed restore, two clean builds, file/SBOM/provenance reconciliation | Batch 01 repository/release ADRs |
| ADR-FS-005 | G0 fictional-data classification, deterministic package, independent oracle, truth ledger, mutation suite, and exact canaries | **Next gate — Experimenting** | section 11 G0 gate passes; owners assigned; cleanup receipt valid | Batch 01 G0 ADRs |
| ADR-FS-006 | Windows Coordinator/User Host/Task Host authority topology and launch model | **Proposed; runtime-unproved** | exact-tuple G1 token/task/service/ACL/session/cleanup evidence | Batch 01 G1 topology ADRs |
| ADR-FS-007 | Local IPC physical profile and transcript authentication | **Deferred pending bake-off** | same logical state machine implemented in strict JSON and deterministic CBOR; parser/fuzz/resource/cross-version/hostile-client evidence; dependency admission | codec-conflicting Batch 01 recommendations |
| ADR-FS-008 | Product privacy ceiling, tenant narrowing lattice, signed control-artifact envelope, candidate state machine, and collection permit | **Proposed; crypto profile open** | lattice laws, candidate/expiry/realm tests; crypto/key human decisions and vectors before production use | Batch 01 policy/control ADRs |
| ADR-FS-009 | Application identity, registry revisions, closed matcher grammar, ambiguity, and minimized snapshots | **Proposed for first synthetic host matcher** | fictional catalogue-shape tests, URL-host analyzer witnesses, realm-negative tests; human owner/taxonomy decisions before real publication | Batch 01 registry/matching ADRs |
| ADR-FS-010 | Edge root/profile discovery and read-only acquisition sequence: short direct read, eligible Online Backup to memory, otherwise defer | **Proposed; G2 open** | exact Edge/Windows/native SQLite zero-write, lock/churn, backup-completion, source-identity, browser-impact, cleanup evidence | Batch 02 acquisition ADRs |
| ADR-FS-011 | Source/source-generation/runtime/interpretation separation, native-ID cursor, one-page progress authority, and whole-page failure | **Proposed; G3/G4/G5 handoff open** | synthetic model first, then source replacement/cursor/privacy/page campaigns | Batch 02 lineage/page ADRs |
| ADR-FS-012 | Realm endpoint store, one writer, WAL, atomic effects/progress, batching, ambiguous attempts, receipts, pressure, migration, and cleanup hold | **Proposed; G5 open** | model/failpoint/process/VM/disk/receipt histories; encryption and cleanup human decisions | Batch 03 endpoint durability ADRs |
| ADR-FS-013 | Enterprise MSI privileged boundary, immutable release slots, same-digest promotion, N/N-1 rollback, optional updater trigger | **Proposed; release gate open** | install/repair/upgrade/tamper/rollback/cleanup evidence; updater remains disabled unless separate need/TUF gate passes | Batch 03 release/update ADRs |
| ADR-FS-014 | Per-installation key and identity, server-derived realm, enrollment, revocation, clone hold, realm transfer, and network authority | **Proposed; identity/PKI open** | exact local key/enrollment/mTLS/revoke/clone/wrong-realm evidence plus PKI/network human decisions | Batch 03 identity/network ADRs |
| ADR-FS-015 | Closed diagnostics catalogue, separate journal, D0–D2 permits, deterministic support bundle, and no raw dump/remote shell | **Proposed; diagnostic gate open** | all-sink canaries, cardinality/resource tests, expiry/revocation, blind support exercise; backend/access/retention decisions | Batch 03 diagnostic ADRs |
| ADR-FS-016 | Signed, expiring exact-tuple compatibility manifest and `QUALIFIED` versus `SUPPORTED` distinction | **Proposed; no tuple qualified** | one exact tuple passes predecessor, release, identity, diagnostics, resource, lifecycle, and cleanup evidence; human support decision for `SUPPORTED` | Batch 03 compatibility ADRs |
| ADR-FS-017 | Server ingestion custody transaction, immutable receipt, mutable work lease, whole-batch terminal outcome, and realm-wide event uniqueness | **Proposed; B04-INGEST open** | receipt-response-loss, conflict, fencing, poison, realm, reconciliation, exact restore evidence | Batch 04 ingestion ADRs |
| ADR-FS-018 | PostgreSQL/SQL Server paired semantic, load, backup, failover, operator, licensing, skills, and TCO comparison | **Experimenting later; engine open** | identical harness and actual restores/operator drills; human selection | Batch 04 database ADRs |
| ADR-FS-019 | Stateful/open-arrival capacity simulator, fairness, outage recovery, headroom, and measured broker triggers | **Proposed; all values open** | qualified generator, approved distributions/objectives, 6k/12k/reconnect/backlog/soak scenarios, correctness first | Batch 04 capacity/broker ADRs |
| ADR-FS-020 | Suppress-first lifecycle, tombstones, exact subject resolution, store/connector targets, backup catalogue, isolated restore, acknowledged-set reconciliation | **Proposed; lifecycle gate open** | deletion/hold/connector/old-backup/restore/readiness campaigns plus human purpose/retention/rights decisions | Batch 04 lifecycle ADRs |
| ADR-FS-021 | Same-origin control BFF, confidential-client session, server-side tokens, CSRF, one active realm, and browser trust boundary | **Proposed; B05-SESSION open** | exact IdP/session/fixation/mix-up/logout/CSRF/cache/realm-switch tests | Batch 05 BFF/session ADRs |
| ADR-FS-022 | Release-owned capability RBAC with closed purpose/target/output/state conditions, JIT, approvals, service authority, and explicit commands | **Proposed; authority profiles empty** | complete route/action catalogue, realm/purpose/JIT/workflow tests; human roles/purposes/SoD owners | Batch 05 authorization/workflow ADRs |
| ADR-FS-023 | `AuthorizationDecisionV1`, canonical `AuditEventV1`, same-transaction mutation/audit, stable command identity, and audit-before-disclose | **Proposed; atomic/access gates open** | transaction failpoints, unknown-commit reconciliation, read/export buffering and release tests | Batch 05 transactional audit ADRs |
| ADR-FS-024 | Audit stream sequence/hash, sealed Merkle segments, independent verifier/checkpoint, holds, whole-segment pruning, and restore comparison | **Proposed; verifier/crypto/retention open** | independent implementations, tamper/gap/fork/rollback corpus, external checkpoint and old-backup restore; owners and key policy | Batch 05 verification ADRs |
| ADR-FS-025 | WCAG 2.2 AA complete-workflow engineering gate and accessible recovery/approval/audit paths | **Proposed; support matrix open** | automated plus keyboard/screen-reader/zoom/reflow/forced-colors/reduced-motion/task evidence; human formal policy | Batch 05 accessibility ADRs |
| ADR-FS-026 | One-shot read-only legacy discovery, hostile static parsers, content-addressed evidence graph, bounded non-observation, and owner disposition | **Proposed; discovery gates open** | no-execution/no-mutation/canary/coverage/population/cleanup evidence; owner approvals | Batch 06 discovery ADRs |
| ADR-FS-027 | One-authority shadow validation, no endpoint dual-write, server-side compatibility projection, exact ranges, counted comparison, tolerances/defects, configuration transform | **Proposed; real semantics open** | shadow-egress/credential graph tests, exact range and digest vectors, report/config owner decisions | Batch 06 comparison/configuration ADRs |
| ADR-FS-028 | Monotonic authority epochs, progressive cutover rings, common fence, automatic pause, human promotion, pre-trust phase-bounded rollback | **Proposed; cutover blocked** | fence/range/rollback/ring/game-day evidence; human cohort, objectives, promotion and rollback decisions | Batch 06 cutover ADRs |
| ADR-FS-029 | Layered archive read-only, writer trust removal, buffer dispositions, residual monitoring/exceptions, and independent decommission acceptance | **Proposed; all irreversible gates blocked** | read-only/write-denial, sessions/permissions/secrets/network, buffer, sensors, late-finding, archive, lifecycle and owner-quorum evidence | Batch 06 decommission ADRs |
| ADR-FS-030 | Numeric-control ownership, source labels, execution-time profiles, evidence expiry, and prohibition on hardening estimates | **Proposed** | profile schema and CI checks; human owners for production values | all batches’ provisional numeric recommendations |
| ADR-FS-031 | Safety holds and incident response across privacy, identity, release, durability, receipt, audit, restore, and migration | **Proposed** | runbook table in section 15 exercised at the relevant gate; no self-clear | cross-batch incident rules |
| ADR-FS-032 | Open-source and external dependency admission, reference/dependency classification, exact source/package/binary mapping, removal path | **Proposed** | section 17 admission record and positive/negative controls for every selected artifact | all batch source/dependency reviews |

## 16.3 ADR execution order

The first ADRs to create in the repository are `ADR-FS-001` through `ADR-FS-005`, plus `ADR-FS-030` and `ADR-FS-032`. They define the evidence and dependency rules required to trust later ADR experiments. `ADR-FS-006` through `ADR-FS-009` may be drafted in parallel but cannot become runtime claims before G0. Later ADRs remain indexed and traceable but are activated only when their predecessor gate is reached.

Every implementation pull request must name the ADR and contract revision it implements, the gate it advances, the evidence it emits, the new authority it does **not** gain, and the cleanup/rollback path. A pull request that silently changes an accepted invariant is rejected even when all tests pass.

---

# 17. Source and open-source register

## 17.1 Supplied-source register

The authoritative supplied source set is exactly I01–I08 in the evidence table at the beginning of this result. Its strengths and limits are:

| Source class | Strength | Limitation | Permitted use |
|---|---|---|---|
| Accepted baseline | stable topology, invariants, human-authority boundary, and change discipline | condensed; no implementation proof | normative starting point unless changed formally |
| Six batch reviews | reconciled interfaces, schemas, state machines, contradictions, experiments, sources, and dependency findings | planned evidence, not passed aggregate gates; some exact versions will age | implementation design and gate specification |
| Research-evidence rules | consistent labels, source quality, CLI priority, and conflict handling | proves no product behavior | mandatory method and reporting rules |
| Current official primary sources | point-in-time lifecycle and standards capability | generic documentation cannot prove UAM composition or operations | execution profile selection and disputed-fact correction |

A repeated claim across these files is not counted as independent evidence. The final synthesis prefers explicit invariants and the strongest direct evidence rather than frequency or confidence of wording.

## 17.2 Standards and official documentation register

| Source | Reviewed status and use | Classification and limitation |
|---|---|---|
| [RFC 8259 — JSON](https://www.rfc-editor.org/rfc/rfc8259) | wire syntax reference for strict UTF-8 JSON | **primary standard**; UAM adds closed-schema and resource rules |
| [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12) | structural schema dialect | **primary specification**; the selected validator must pass pinned tests and hostile resource cases |
| [RFC 9562 — UUIDs](https://www.rfc-editor.org/rfc/rfc9562) | UUIDv7 layout and canonical representation | **primary standard**; timestamp bits are not business time or authority |
| [RFC 8785 — JCS](https://www.rfc-editor.org/rfc/rfc8785) | candidate canonical JSON profile for bounded signed/audit/comparison artifacts | **primary standard, conditional fit**; preserves parsed strings and has numeric/I-JSON constraints |
| [RFC 8949 — CBOR](https://www.rfc-editor.org/rfc/rfc8949) | deterministic CBOR candidate for local IPC | **primary standard, deferred codec**; package/parser/resource evidence is still required |
| [RFC 9162 — Certificate Transparency v2](https://www.rfc-editor.org/rfc/rfc9162) | domain-separated Merkle construction concepts | **reference for audit/comparison profiles**; not a ready-made UAM log service |
| [RFC 9700 — OAuth 2.0 Security BCP](https://www.rfc-editor.org/rfc/rfc9700) | current OAuth security baseline for BFF/IdP integration | **primary standard**; exact IdP and session behavior still require tests |
| [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | execution-time supported .NET release/patch selection | **official lifecycle source**; recheck each build, do not freeze a patch |
| [SQLite documentation and release history](https://www.sqlite.org/changes.html) | exact native source ID, WAL/backup/read-only API behavior, and patch advisories | **official engine source**; loaded binary and Windows composition require CLI evidence |
| [PostgreSQL versioning policy](https://www.postgresql.org/support/versioning/) | current supported release-line selection | **official lifecycle source**; reference status does not choose the production engine |
| [Microsoft SQL Server documentation](https://learn.microsoft.com/en-us/sql/) | candidate engine, Windows identity, session, audit, backup, and lifecycle primitives | **official capability source**; edition/topology/UAM semantics and operations remain unproved |
| [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | engineering target for complete portal and recovery workflows | **W3C Recommendation**; formal legal/procurement mapping is human-owned |

Official documentation is not promoted to project-specific proof. Any statement about zero source writes, process isolation, durable custody, one effect, capacity, restore, accessibility task success, or decommission completeness still requires its named UAM experiment.

## 17.3 Reproducibly pinned open-source candidates

**RECOMMENDATION.** The following repositories are the only consolidated candidates listed here because the allowlisted reviews provide an immutable full revision, an acceptable or explicitly reviewable license, active maintenance/test evidence, a useful bounded fit, and a clear classification. A row is not an adoption decision; it authorizes only a dependency-admission experiment.

| Repository and reproducible permalink | Reviewed license/posture | Useful UAM fit | Classification and mandatory admission conditions |
|---|---|---|---|
| [FsCheck 3.3.4 — `7c583d6df4939643fd36f0439694be1456833aff`](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff) | BSD-3-Clause; maintained with tests/docs | deterministic property/model testing and shrinking | **test candidate**; select at most one general property framework; exact NuGet/source mapping, fixed seeds, custom history/shrink/evidence ownership |
| [Microsoft CsWin32 0.3.298 — `e4a7320acd0c62f7490efd4c34421c181212dd8d`](https://github.com/microsoft/CsWin32/tree/e4a7320acd0c62f7490efd4c34421c181212dd8d) | MIT; Microsoft-maintained generator with tests | narrow Windows API generation | **pinned build-time candidate**; `PrivateAssets`, API allowlist, generated-source diff/review, no broad native surface, manual fallback |
| [oasdiff v1.27.0 — `fb8babb92c123991e7cff4500bb35cafe97e5f7b`](https://github.com/Tufin/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b) | Apache-2.0; active tests and security guidance | secondary HTTP contract-difference detection | **build candidate behind a UAM adapter**; never the semantic/privacy compatibility oracle |
| [NSwag v14.7.1 — `2389c0721d069fa8ea07e35b925b66121e577c81`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81) | MIT; active and tested | boundary-local client/code generation | **bake-off candidate**; generated snapshots, nullability/compatibility tests, no shared domain DTO authority |
| [Corvus.JsonSchema 5.2.10 — `a67f993cecd7b64eec7f8e4bd6e540555b91bfd2`](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2) | Apache-2.0; tests, benchmarks, specification-suite integration | strict schema validation/source generation | **validator bake-off candidate**; official-suite subset, UAM hostile corpus, deterministic output, allocation/time/remote-reference gates |
| [JSON Schema Test Suite — `c7257e92580678a086f0b9243a1903ed88bd27f7`](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7) | MIT; language-neutral test corpus | pinned specification conformance input | **test/reference input**; supplement with duplicate, remote-ref, depth, size, allocation and semantic/privacy vectors |
| [ArchUnitNET 0.13.3 — `b25c4f940b1d067e97092783d0ef16e4fe12d8c3`](https://github.com/TNG/ArchUnitNET/tree/b25c4f940b1d067e97092783d0ef16e4fe12d8c3) | Apache-2.0; current and tested | project/assembly dependency checks | **test candidate** only where it catches mutations beyond simpler source/graph guards; failure must be independently demonstrated |
| [Microsoft SBOM Tool v4.1.5 — `c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3`](https://github.com/microsoft/sbom-tool/tree/c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3) | MIT; maintained/tested | one SBOM evidence producer | **tool candidate**; exact binary, offline/egress, positive controls, final-file/lock reconciliation; zero exit is not completeness |
| [CycloneDX .NET v6.2.0 — `55877e2ae058ae9686783ac084d2257d3fcedab1`](https://github.com/CycloneDX/cyclonedx-dotnet/tree/55877e2ae058ae9686783ac084d2257d3fcedab1) | Apache-2.0; active tests/e2e | independent secondary dependency inventory | **secondary SBOM candidate**; reconcile disagreement rather than vote; not whole-release inventory by itself |
| [Testcontainers for .NET 4.13.0 — `1717807affaae9b967035516ebedcd76dd7eaffb`](https://github.com/testcontainers/testcontainers-dotnet/tree/1717807affaae9b967035516ebedcd76dd7eaffb) | MIT; security policy and tested packages | disposable server/database integration environments | **trusted test candidate**; isolated Docker authority; never Windows session, physical durability, power, EDR, or production topology proof |
| [actions/attest v4.2.1 — `508db95dd578ae2727ebd6217d5ba78e4fbda05d`](https://github.com/actions/attest/tree/508db95dd578ae2727ebd6217d5ba78e4fbda05d) | MIT; maintained verified release | CI-platform provenance adapter | **conditional candidate only if GitHub is selected**; pin action by full commit, verify subject/materials, keep architecture platform-neutral |
| [.NET runtime v10.0.10 — `8f030f80c0dd2722eb2f618984e9db6784765963`](https://github.com/dotnet/runtime/tree/8f030f80c0dd2722eb2f618984e9db6784765963) | MIT plus component notices; extensive tests/security process | inherent runtime/source reference for exact behavior | **accepted family, execution-time point only**; installed file/runtime/globalization/native identities and patch semantic regression are evidence; never URL/IDNA authority by itself |
| [OpenTelemetry .NET core-1.17.0 — `e432cd549a81dabfc8b1c7c346c03cdf933013f1`](https://github.com/open-telemetry/opentelemetry-dotnet/tree/e432cd549a81dabfc8b1c7c346c03cdf933013f1) | Apache-2.0; active maintained project | server/portal telemetry behind UAM’s closed catalogue | **server/portal candidate**; exact packages/transitives, no broad auto-instrumentation, attribute/canary/cardinality/performance/removal tests; endpoint product transport remains separate |
| [OpenTelemetry Collector Contrib v0.157.0 — `89e43555904cd97c2d36605347c5d5237b1bdc8c`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/89e43555904cd97c2d36605347c5d5237b1bdc8c) | Apache-2.0; active but defaults can change | optional custom server telemetry gateway | **conditional custom-distribution candidate**; include only required components, explicitly fail closed, no host/file/process receivers, all-sink and load tests; never endpoint privacy boundary |
| [Npgsql v10.0.3 — `d3768398c17877b3a916c3c4d87e8e11698991fc`](https://github.com/npgsql/npgsql/tree/d3768398c17877b3a916c3c4d87e8e11698991fc) | PostgreSQL License; mature tests/security process | thin PostgreSQL adapter, COPY, cancellation, pooling experiments | **runtime candidate after engine/profile admission**; provider types stay outside domain contracts; exact NuGet/transitives/protocol/security/support evidence |
| [Microsoft.Data.SqlClient v7.0.2 — `8c70cec98444338ddb0b97be94c34fde93970241`](https://github.com/dotnet/SqlClient/tree/8c70cec98444338ddb0b97be94c34fde93970241) | MIT plus native/transitive notices; broad Microsoft tests/security | thin SQL Server adapter and bulk/pooling/session-context experiments | **runtime candidate after engine/profile admission**; exact managed/native SNI, auth, encryption, retry, pooling and platform evidence |
| [pgBackRest 2.59.0 — `f84c8357d49ea9452cd606531e9c4c322c41bc2e`](https://github.com/pgbackrest/pgbackrest/tree/f84c8357d49ea9452cd606531e9c4c322c41bc2e) | MIT; active with backup/restore/archive tests | PostgreSQL backup-chain and operations candidate | **conditional tool candidate only if PostgreSQL is selected**; credentials/operations containment, exact binary, actual restore/lifecycle tests; tool success is not readiness |
| [dbatools v2.8.3 — `e1f250f786c3d585a4e52ab73a9707297368d134`](https://github.com/dataplat/dbatools/tree/e1f250f786c3d585a4e52ab73a9707297368d134) | MIT; active with broad Pester tests/docs; high-authority PowerShell surface | optional SQL Server lab/runbook automation | **lab/operations candidate after admission**; fixed command allowlist, isolated credentials, no runtime/production general shell, independent result checks |
| [Toxiproxy v2.12.0 — `3ccd6a79cbc6c6a72b884d295ad314b75cdf3962`](https://github.com/Shopify/toxiproxy/tree/3ccd6a79cbc6c6a72b884d295ad314b75cdf3962) | MIT; full commit and security policy available | controlled network latency/reset/response-loss faults | **test-only candidate**; exact binary/image digest, isolated network authority, cleanup and fault-oracle evidence; never production component or custody oracle |
| [smallstep certificates v0.30.2 — `6e8ec61405239cf3f37b2bbf260a587b7d2e4e31`](https://github.com/smallstep/certificates/tree/6e8ec61405239cf3f37b2bbf260a587b7d2e4e31) | Apache-2.0; active CA implementation with tests/security process | disposable lab CA/ACME and certificate-state experiments | **lab-only candidate**; no production PKI inference, isolated roots/keys, deterministic fixtures, full cleanup |

## 17.4 Rejected, weak, stale, or reference-only claims

| Item | Evidence weakness or mismatch | Status and reconsideration rule |
|---|---|---|
| Gitleaks v8.30.1, commit [`83d9cd684c87d95d656c1458ef04895a7f1cbd8e`](https://github.com/gitleaks/gitleaks/commit/83d9cd684c87d95d656c1458ef04895a7f1cbd8e) | reviewed positive control missed a canonical GitHub PAT and exited successfully | **REJECTED as reviewed**; a later exact binary must pass every UAM mandatory canary and remains secondary to the exact scanner |
| SharpFuzz 2.3.0 | exact package-to-reviewed-source mapping was unresolved | **NO-GO** until full source/package/provenance mapping and isolated fuzz admission |
| CsCheck, Microsoft Coyote CLI, `DotNet.ReproducibleBuilds` | exact package/source provenance or support posture was unresolved/weak for a load-bearing gate | **NO-GO as defaults**; bounded reference spikes only after a specific need and full admission |
| JsonSchema.Net 9.4.0 | source-license appearance did not settle reviewed binary/EULA/maintenance terms | **PROCUREMENT/LEGAL BLOCKED**; no binary use until terms and conformance/resource behavior are approved |
| WiX v7 candidate | exact current binary/source/EULA/procurement and full revision profile were not accepted; reviewed binary use may be subject to OSMF terms | **PROVISIONAL INSTALLER CANDIDATE**, not “open-source admitted”; Legal/Procurement and exact package evidence required |
| TLA+ Tools v1.8.0 pre-release and short-prefix candidates such as Stryker, Playwright, Selenium, portal design systems, and migration tools | pre-release status or incomplete immutable revision/package mapping weakens reproducibility | **REFERENCE/BAKE-OFF ONLY** until full commit, exact package/binary, license, security, tests and removal path are captured |
| OpenTelemetry semantic conventions | broad URL, path, header, database and network attributes are not UAM-safe by default | **REFERENCE VOCABULARY ONLY**; never auto-adopt fields or defaults |
| Chromium, Tailscale, PowerToys, go-winio, uBlock Origin, Presidio, GraphWalker, distributed logs/workflow/broker products | valuable design/test patterns but different authority, privacy, runtime, language, licensing, or operational boundary | **REFERENCE ONLY**; no source/binary/service adoption from architectural analogy |
| Mutable branches, “latest”, short commit prefixes, mutable action/container tags, unverified downloaded drivers/browser bundles | cannot reproduce or bind the reviewed claim | **PROHIBITED for load-bearing evidence** |
| Repository popularity, release cadence, vendor marketing, package download count, generic benchmark, or “exactly once” framework claim | does not prove UAM semantic, privacy, durability, operations, restore, or licensing fitness | **WEAK EVIDENCE**; may only motivate a candidate experiment |
| Any point version named in this result | can become unsupported or security-stale after 1 August 2026 | **STALE BY DESIGN AT EXECUTION** unless revalidated and locked in the experiment/build manifest |

## 17.5 Dependency admission record

Before any external artifact executes in build, test, release, runtime, migration, or operations, one immutable record must contain:

```text
name and purpose
classification = RUNTIME | BUILD | TEST | OPERATIONS | REFERENCE
exact tag and full source commit permalink
exact package/binary/container/action digest and source mapping
license, notices, binary/EULA/commercial terms and approver
transitive dependency and native-component inventory
maintenance and support status on the admission date
security policy, advisories and vulnerability assessment
required tests, positive/negative controls and resource limits
network/filesystem/credential authority and trust zone
privacy/realm/audit/diagnostic implications
owner, support owner, replacement/removal path and exit cost
approved versions, expiry and re-review triggers
admission result and evidence digests
```

A missing field means `NOT_ADMITTED`. Reference-only material is never restored, executed, packaged, mirrored, or deployed merely because it appears in this register.

---

# 18. Exact first 20 project actions

The actions below are ordered. “Done” means the stated artifact and acceptance check exist in a clean checkout; opening a pull request is not completion.

| # | Exact action | Accountable function | Required output and acceptance | Stop condition |
|---:|---|---|---|---|
| 1 | Commit this final synthesis and an eight-input review manifest. | Architecture Governance | result at the requested path; input logical names, local names, SHA-256 values, date, allowlist assertion, no optional CLI evidence; clean-tree digest | any input/hash mismatch or unallowlisted dependency on another Project file |
| 2 | Create `ADR-FS-001`, `002`, `003`, `004`, `005`, `030`, and `032` in `docs/adr/`. | Chief Architect + Evidence Governance | each ADR has owner, status, scope, invariants, alternatives, evidence/gate, rollback, invalidation trigger, links to this result | an ADR silently approves a human decision or changes a baseline invariant |
| 3 | Create machine-readable decision, owner, contract, evidence, exception, and gate schemas. | Contract Authority | closed JSON Schema 2020-12 bundles, strict parser profile, valid/boundary/invalid vectors, local refs only | unknown fields/defaults/remote refs accepted or any blocking owner field optional |
| 4 | Assign accountable functions and support functions for G0, contract authority, oracle, canary scanning, dependency admission, repository/release, privacy, security incident, and architecture gate. | Engineering Leadership + Governance | immutable owner-decision records; no blocking `UNASSIGNED`; deputies/escalation and conflict rules | one load-bearing responsibility remains unassigned or self-approves where separation is required |
| 5 | Scaffold the canonical monorepo directories and deployable/module project graph without production-shaped endpoint code. | Repository/Build Owner | solution builds offline with foundation/test/tools projects; no broad `Common`, plug-in, scripting, SQL, HTTP endpoint collector, or deployable implementation reference | forbidden dependency/API/package appears or architecture test cannot express the boundary |
| 6 | Build the architecture-mutation harness and prove it detects injected violations. | Verification Architecture | one injected-and-reverted mutation per dependency/trust rule; first failure retained; final clean-tree proof | any forbidden mutation passes, mutation cleanup leaves a diff, or the harness cannot fail itself |
| 7 | Lock the .NET SDK, package sources, analyzers, generators, tools, actions/images, locale/time-zone inputs, and restore graph for the first T1 lane. | Build/Dependency Owner | `global.json`, central versions, lockfiles, source mapping, tool manifest, exact digests, no floating/mutable input; current lifecycle recheck | unsupported/floating/unmapped input, undeclared source, post-restore network need, or license unknown |
| 8 | Publish the strict contract/scalar profile `candidate-1` and executable parser vectors. | Contract Authority | UTF-8/no-BOM/closed-object/duplicate/wrong-case/null/default/enum/number/time/Unicode/UUIDv7/digest rules; deterministic parser results | any forbidden form accepted, valid form rejected without ADR, or resource bounds unmeasured/unbounded |
| 9 | Run the schema-validator and contract-tool bake-off and admit only the minimum winning tools. | Contract Authority + Dependency Review | official 2020-12 subset, UAM hostile corpus, determinism/resource report, license/source/binary record, removal path | unresolved differential, remote resolution, nondeterminism, resource escape, or provenance/legal gap |
| 10 | Implement the foundation scalar library for canonical UUIDv7, digests, fixed clocks, time precision, bounded strings/enums, and field-specific Unicode policies. | Foundation Engineering | independent RFC/field vectors, deterministic collision/regression cases, no use of UUID time as authority, mutation tests | duplicate/invalid ID, normalization drift, wall clock/randomness leak, or semantic default not explicit |
| 11 | Implement T1/T2/T3 classification, lineage, approval, expiry, deletion, and derivation rules. | Test-Data Steward + Privacy | pure models/schemas; parent-sensitive inheritance; T3 disabled by default; unclassified input impossible to publish | derivative silently downgraded, T3 activates without approval, or deletion/expiry is absent |
| 12 | Implement `Uam.TestData.Generator` with a fixed seed/clock and canonical JSON/NDJSON package writer. | G0 Generator Owner | byte-stable package containing manifest, models, scenarios, lineage, hashes, canaries and schemas; no production code dependency for truth | wall clock, implicit randomness, unstable ordering/serialization, placeholder, or real/organization value appears |
| 13 | Add wholly fictional ephemeral source fixtures, including the approved 173-row catalogue quality shape and synthetic Edge/SQLite cases. | Fixture Owner | generated-at-test-time fixtures, exact aggregate shape, reserved domains/identities, no copied raw label/reference/role/owner/purpose/rule | count/shape drift, raw value, inferred organizational semantics, or committed canonical database binary becomes truth |
| 14 | Implement `Uam.TestOracle` as a separately owned pure expected-outcome engine. | Independent Oracle Owner | expected result, zero-effect, cursor/state, receipt/visibility and cleanup truth ledgers generated before execution; architecture guard against production decision code | oracle consults actual output, imports production transform/dedupe/cursor logic, or lacks a causal row for an input |
| 15 | Implement actual-versus-truth reconciliation and the mandatory implementation/oracle mutation corpus. | Verification Architecture | exact missing/extra/conflict reports; mutations for identity, privacy, state, cursor, receipt, realm and cleanup; minimal deterministic reproducers | one mandatory mutation survives, first failure is overwritten, or a mismatch is rounded/tolerated without typed authority |
| 16 | Implement the exact fictional canary registry and all-sink scanner with self-tests. | Privacy Verification Owner | exact/schema-aware markers across repository, package, output, logs, traces, metrics, dumps/captures/support/evidence encodings; redacted report; every positive control detected | one mandatory canary miss, broad suppression, report leakage, external egress, or a generic scanner is treated as sole proof |
| 17 | Run G0 generation twice in challenged clean environments after a sealed restore and network cut. | Reproducibility Owner | byte-identical canonical package roots despite different path/user/time-zone/locale; tool/input manifests; no undeclared egress | unexplained byte difference, host identity/time leakage, post-cut dependency fetch, or mutable artifact |
| 18 | Generate final file manifests, two independent dependency inventories where practical, SBOM, provenance, and subject/material reconciliation for the unsigned G0 artifact. | Supply-Chain Evidence Owner | every shipped file and dependency explained; provenance subject equals final digest; deliberate substitution/omission detected | unexplained file/component, invented license conclusion, subject/material mismatch, scanner positive-control miss |
| 19 | Execute the full G0 gate, cleanup, and independent gate recomputation. | Gate Evaluator independent of implementation owners | `g0-gate.json` with all evidence digests, owners, first failures, canary result, mutation result, reproducibility result, cleanup receipt and exact `PASS`/`HOLD`; evaluator read-only to source evidence | any hard predicate false, stale/missing evidence, unassigned owner, undeletable artifact, exception without authority, or evaluator can alter evidence |
| 20 | Hold the architecture gate review and either close G0 or stop the programme at G0. | Architecture Forum + Privacy/Security/Evidence Owners | immutable decision: on `PASS`, authorize only the next contract/policy/registry and disconnected codec-neutral G1 prototype work; on `HOLD`, issue defects/ADR changes and no dependent work | conditional/partial pass, waived canary/mutation/reproducibility failure, live data, connected Windows source work, or production-shaped integration begins before closure |

The first 20 actions intentionally do not install a service, touch a live browser profile, connect to a Windows lab, select a database, create production keys, or implement a portal mutation. Those activities depend on evidence these actions create.

---

# 19. Residual risk and exact next invalidating gate

Even if every planned control and gate eventually passes, material risk remains:

- A validly signed, correctly isolated release can still implement the wrong business purpose, overbroad field choice, misleading interpretation, or harmful human-approved workflow.
- A local administrator, kernel/firmware/hypervisor compromise, privileged security product, database superuser, release signer, CA/KMS administrator, or colluding authorities can observe or manipulate state inside their failure domain.
- Windows servicing, Edge internals, SQLite/native providers, database engines, drivers, proxies, EDR, VDI/profile systems, browsers, assistive technologies, and dependencies can regress after qualification; evidence expires and cannot guarantee future builds.
- Filesystem and storage durability ultimately depend on hardware, virtualization, firmware, cloud, operating-system, and operator behavior below the application’s direct control.
- Synthetic models, implementation code, oracle logic, canaries, validators, and independent verifiers can share a conceptual defect. Mutation, differential testing, and real-boundary faults reduce but do not eliminate common-mode error.
- Fail-closed controls can cause collection gaps, backlog, administrative outage, archive unavailability, delayed deletion, support burden, and recovery cost. No SLO, staffing, or risk acceptance is yet approved.
- Minimized aggregates, rare populations, timestamps, application/site identifiers, audit metadata, migration evidence, and exported artefacts can still permit inference or misuse.
- External recipient copies, unmanaged spreadsheets, screenshots, human memory, copied legacy data, and systems outside the reconciled population cannot be technically recalled or universally proved absent.
- Restore, decommission, and tamper-evidence claims remain bounded by the completeness and independence of receipt sets, tombstones, checkpoints, sensors, owners, keys, and population evidence.
- Human error, coercion, compromised identity, inaccessible process, inadequate consultation, weak incident response, or deliberate misuse can defeat technically correct controls.

**Containment, not elimination, is the correct claim.** The architecture limits each authority, makes critical state explicit, preserves immutable evidence, requires independent checks, stops on unknowns, and separates reversible prototypes from irreversible production actions. Production safety still depends on recurring evidence renewal, competent operations, accountable human decisions, and truthful communication of limitations.

**Exact next invalidating gate: G0 — purpose/source/dummy-data contract and deterministic evidence oracle.** The plan is invalidated at the first gate if the package is nondeterministic; an input is unclassified; the oracle depends on production decision logic or misses a mandatory mutation; a forbidden canary escapes or a positive control is missed; a dependency cannot be reproduced or legally admitted; a blocking owner is unassigned; first-failure evidence is overwritten; cleanup leaves residue; or the independent evaluator cannot recompute the result. Any such outcome is `G0 = HOLD`, stops G1 and all dependent implementation, and requires the relevant ADR/evidence correction before work can proceed.
