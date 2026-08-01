# Prompt 13 result — privacy-safe diagnostics, logging, support bundles, and temporary diagnostic access

**Result path:** `results/batch-03-durability-release-identity/13-diagnostics-support-result.md`  
**Research date:** 31 July 2026  
**Decision status:** **RECOMMENDATION — ACCEPT FOR IMPLEMENTATION PROTOTYPES WITH MANDATORY PRIVACY, REALM, EXPIRY, AND SUPPORTABILITY GATES**  
**Authority boundary:** diagnostics and support architecture; **not** legal basis, support staffing, access approval, retention approval, backend procurement, incident communications, pilot, or production approval  
**Primary gate:** **Support can diagnose the defined failure set without raw URLs, hosts, paths, identities, secrets, source records, or unbounded telemetry.**

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied file or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, or operational authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the proposed implementation contract. They do not convert a human decision into approval or a documented platform capability into UAM fitness.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION.** Build UAM diagnostics as a small, privacy-safe observability subsystem, not as a general log collection or remote debugging facility. It has four controls:

1. a release-owned, compile-time catalogue of every log event, error, metric, span, attribute, safe message, owner, and cardinality bound;
2. bounded OpenTelemetry signals whose schemas contain only finite operational classes and never raw activity or identity values;
3. deterministic support bundles made from hashes, counts, status classes, configuration versions, and bounded value-free timelines only;
4. a signed, purpose-bound, target-bound, level-bound, expiring diagnostic permit with revocation and kill switches.

The endpoint Coordinator is the only endpoint component allowed to persist or export diagnostics. User Hosts and Task Hosts may emit only closed, minimized diagnostic records over the already accepted authenticated IPC boundary. Task Hosts do not write diagnostic files, support archives, or dumps. Endpoint diagnostics are operational side effects and are never part of the event/cursor commit; a diagnostics failure therefore cannot advance a cursor, acknowledge business data, or block the accepted durability transaction.

**FACT.** OpenTelemetry’s current sensitive-data guidance says the strongest prevention is not collecting sensitive data and describes Collector redaction/filtering as processing controls, not a substitute for source minimization [W01]. OpenTelemetry’s standard HTTP conventions can expose full URLs, paths, queries, headers, server addresses, and other sensitive or high-cardinality values [W04–W05]. **INFERENCE.** UAM must use a stricter, release-owned telemetry profile and treat Collector filtering as a second independent barrier, not the privacy boundary.

## 1.2 Decision summary

| Area | Recommended decision | Immediate consequence |
|---|---|---|
| Endpoint logs | Coordinator-owned bounded structured journal; no raw activity, identity, path, exception text, stack, or arbitrary object | ordinary support can inspect operational state without opening user-owned sources |
| Server and portal logs | source-generated, catalogue-owned events; realm is an authorization column, never a metric label or message field | support searches are realm-scoped and auditable without turning telemetry into a cross-realm index |
| Errors | stable finite error codes, categories, retry classes, owner functions, safe message keys, and value-free fingerprints | L1/L2 can route and diagnose without exception text |
| Metrics | closed instrument catalogue, finite enum labels, per-instrument cardinality limits, overflow as a release-blocking defect | no device/user/realm/application/source/URL series explosion |
| Traces | disabled on endpoints at baseline; sampled server traces with static span names, strict attribute allowlists, `tracecontext` only, no baggage | correlation remains useful without propagating identity or business data |
| Access logs | route-template ID, method class, status class, latency, authentication/authorization outcome only | path, query, headers, body, user agent, referrer, client IP, and identity are excluded |
| Crash handling | automatic endpoint process dumps off; finite crash summary only; raw dumps restricted to synthetic lab permits | process memory does not become a routine support artifact |
| Support bundles | canonical manifest plus hashes/counts/status/version data; in-memory plaintext; scan, encrypt, upload, expire, delete | no raw log archive, database copy, registry dump, event log, ETL, PCAP, or process dump |
| Temporary diagnostics | levels D0–D2 only; D3/raw is unrepresentable; permit can only narrow the release privacy ceiling | support cannot switch on a hidden broader collector |
| Incident response | finite runbook catalogue with L1/L2/L3, security, privacy, IAM, endpoint, release, and observability owner functions | failures have containment, recovery, cleanup, and re-enable evidence |

## 1.3 Confidence

- **High** confidence in the “do not collect raw values” rule, closed telemetry catalogues, finite labels, dump prohibition, and permit-bounded access. These follow directly from accepted UAM privacy/realm invariants and current primary guidance.
- **Medium-High** confidence in OpenTelemetry .NET plus a minimal custom Collector gateway as the server-side implementation family. It is mature and current, but exact packages, exporters, backend, load behavior, and operator competence require admission and load tests.
- **Medium** confidence in the exact support-bundle encryption profile, numeric limits, sampling rates, expiry periods, and backend lifecycle. Those are deliberately left as experiments or human decisions.
- **Low** confidence that research alone can prove absence of all leakage through endpoint security products, hypervisors, operating-system paging, backup systems, screenshots, or human support behavior.

## 1.4 Residual risk

The design reduces but cannot eliminate these risks:

- a developer can still introduce a new sink or bypass unless analyzers, architecture tests, canaries, and review stay mandatory;
- a Collector, exporter, backend, browser developer tool, EDR product, crash handler, or operator can create an unreviewed copy outside UAM’s direct control;
- finite fingerprints and rare error combinations may still allow correlation if access is too broad;
- fail-closed observability can make some incidents slower to diagnose;
- a support issue that depends on a specific raw activity value cannot be diagnosed from production diagnostics and must be reproduced with synthetic evidence;
- exact support roles, hours, access authority, retention, backend, incident communication, budget, SLOs, and production risk remain human-owned.

**Next stop/go gate:** implement the catalogue/analyzers, canary harness, cardinality probe, deterministic bundle prototype, and permit state machine with T1 fictional data. **STOP** before production diagnostics export or support-bundle upload until the primary supportability gate, realm isolation, expiry/revocation, encryption interoperability, deletion, and owner gates all pass.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result covers:

- endpoint, server, and portal structured log contracts;
- error taxonomy, severity, retryability, fingerprints, ownership, and user-safe messages;
- OpenTelemetry metrics, traces, propagation, sampling, redaction, storage, and cardinality control;
- crash behavior and safe HTTP access logging;
- deterministic privacy-safe support bundles;
- temporary diagnostic authorization, activation, expiry, revocation, and cleanup;
- incident response, support tiers, runbooks, tests, fitness functions, cost/skills/operations, and residual blind spots.

## 2.2 Non-goals

This result does not:

- approve employee monitoring, a legal basis, purpose, prohibited uses, exact fields, identity, retention, or access;
- redesign event collection, outbox durability, server ingestion, release signing, device identity, database selection, or the portal;
- make diagnostics an audit ledger, receipt ledger, forensic acquisition system, employee-productivity report, data-loss-prevention system, SIEM replacement, or remote shell;
- authorize raw browser data, URLs, hosts, paths, user identities, profile information, source databases, SQL text, network packets, Windows event-log export, ETL traces, process dumps, screenshots, registry dumps, arbitrary files, or arbitrary commands;
- select a production observability backend, encryption key service, support staffing model, support hours, incident communication plan, or retention schedule.

## 2.3 Allowlisted supplied evidence

All five exactly allowlisted files were present and used. No other Project file was opened, searched, quoted, summarized, or used.

| Ref | File reviewed | SHA-256 | Use and limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted architecture, privacy, realm, durability, release, audit, restore, and deletion invariants; not production approval |
| I02 | `01-existing-system-evidence-summary.md` | `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | proves legacy monolithic PowerShell orchestration, direct SQL coupling, deferred executable SQL, broad mutation surfaces, and existing errors/settings/audit; static evidence cannot prove runtime behavior or semantics |
| I03 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions and ordered proof gates; every failed early gate stops dependent work |
| I04 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source quality, human authority, and conflict discipline; it is a research rule, not technical proof |
| I05 | `batch-01-review-result.md` (local attachment `batch-01-review-result(3).md`) | `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b` | accepted predecessor decisions on G0 canaries/oracle, G1 boundaries, strict contracts, privacy lattice, realm isolation, repository/release controls, owner/runbook gates; implementation fitness remains gated |

## 2.4 Accepted inputs carried forward

The following are **FACT** from I01, I03, and I05 and remain non-negotiable for this topic:

| ID | Accepted input applied to diagnostics |
|---|---|
| A-01 | Endpoint contexts remain Coordinator, ordinary-token per-session User Host, and fixed restricted Task Host. Diagnostics cannot create a fourth privileged agent, remote shell, or arbitrary collector channel. |
| A-02 | User-owned values are minimized before Coordinator IPC, durable storage, logs, diagnostics, transport, or support artifacts. |
| A-03 | The release-owned privacy ceiling bounds sources, fields, transformations, destinations, diagnostics, and capabilities; tenant policy only narrows it. |
| A-04 | Realm, installation, device, and session authority comes from authenticated context, not payload claims. One realm cannot view or mutate another. |
| A-05 | A cursor never advances ahead of durable minimized effects; diagnostics are not included in or allowed to delay that transaction. |
| A-06 | A server receipt means durable custody in its declared failure domain, not validation, materialization, integration, or portal visibility. Diagnostics must preserve this distinction. |
| A-07 | Privileged mutations require durable audit evidence. Diagnostic logs are not a substitute for the audit ledger. |
| A-08 | G0 exact canaries, positive controls, all-sink scanning, independent truth, strict contracts, closed schemas, UUIDv7, owner/runbook gates, and repository trust zones are accepted predecessor controls. |
| A-09 | Exact versions, resource limits, cardinality budgets, retention, SLOs, support staffing, backend selection, and crypto profiles remain point-in-time experiments or human decisions. |
| A-10 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |

## 2.5 Evidence-boundary conflict

**FACT.** The project context says this work should consume accepted Batch 1–2 decisions. The exact Prompt 13 allowlist authorizes Batch 01 but does not authorize a Batch 02 result. Every listed allowlisted file was present; no file is missing. The unlisted Batch 02 result was not opened or used.

**UNKNOWN.** This result cannot prove that its contracts and terminology are fully aligned with accepted Batch 02 refinements. It preserves the shared accepted baseline and Batch 01 invariants and does not redesign source acquisition or privacy transformation.

**RECOMMENDATION.** Before this result is accepted by the batch reviewer, perform a narrow cross-review using an allowlist that explicitly includes the accepted Batch 02 review. The reviewer must check only for conflicts in: raw-value boundaries, source/session/realm identifiers, page/failure outcomes, kill switches, canary sinks, and support-visible health states. Any material conflict opens an explicit change proposal; it is not silently repaired here.

## 2.6 Assumptions

| ID | Assumption | Consequence if false |
|---|---|---|
| AS-01 | The existing authenticated endpoint/server control channel can carry bounded diagnostic records and permit artifacts without adding a general endpoint Collector. | A separate transport ADR and network/identity proof would be required. |
| AS-02 | Server and portal code can use supported .NET logging, metrics, and tracing APIs behind UAM-owned wrappers and analyzers. | Another implementation family must prove equal schema, cardinality, and supply-chain controls. |
| AS-03 | Support can solve the defined operational failures from status classes, counts, versions, and state transitions. | The primary gate fails; the design must improve safe signals or explicitly narrow the support promise, not add raw collection. |
| AS-04 | An approved support backend can enforce realm-scoped authorization, case-scoped access, audit, encryption, expiry, and deletion. | Remote bundle upload stays disabled; local evidence only. |
| AS-05 | Product release and policy authorities can sign a dedicated diagnostic permit or authorize an equivalent protected artifact. | Temporary diagnostics remain disabled beyond local T1 lab use. |

## 2.7 Unknowns

- approved support backend, data residency, indexing model, backup behavior, and deletion proof;
- exact diagnostic access approvers, separation of duties, support roles, support hours, escalation and on-call coverage;
- incident communication authority, channels, timing, and employee/customer notification requirements;
- production diagnostic retention, legal hold, evidence retention, and deletion scope;
- exact encryption/key-wrapping, backend public-key distribution, recovery, rotation, revocation, and clock policy;
- actual endpoint/server/portal event rates, failure distributions, cardinality, storage, network, CPU, and support workload;
- proxy/VPN/PKI behavior for any direct OTLP path; no direct endpoint OTLP path is therefore accepted;
- observability backend cost, licenses, operations skills, query latency, restore, availability, and realm-isolation fitness;
- whether enterprise WER, EDR, remote support, hypervisor, paging, or backup settings capture UAM process memory;
- exact accessibility and localization languages, user research, and portal technology;
- whether a future accepted Batch 02 review defines additional state or outcome terms that diagnostics must adopt.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architecture decision

**RECOMMENDATION.** Introduce a `Uam.Diagnostics` bounded subsystem with these deployable and library boundaries:

```text
Release-owned telemetry catalogue and analyzers
        |
        +--> Endpoint Task Host/User Host safe diagnostic records
        |        -> authenticated existing IPC
        |        -> Coordinator Diagnostics Gateway
        |        -> bounded local diagnostic journal / aggregate counters
        |        -> existing authenticated batch/control transport
        |
        +--> Server and Portal UAM wrappers
                 -> OpenTelemetry .NET SDK
                 -> minimal custom OpenTelemetry Collector gateway
                 -> approved observability backend

Signed DiagnosticPermit
        -> Coordinator permit evaluator
        -> D0/D1/D2 state machine
        -> deterministic support-bundle builder
        -> schema validation + canary scan
        -> in-memory plaintext -> encryption
        -> bounded authenticated upload
        -> case-scoped backend access + deletion
```

The product privacy ceiling remains the upper authority. There is no “debug override.” A diagnostic level that needs data outside the ceiling is unrepresentable.

## 3.2 Components and responsibilities

| Component | MUST do | MUST NOT do |
|---|---|---|
| `Uam.Diagnostics.Catalogue` | define every event, error, metric, span, attribute, enum value, safe message key, severity, retry class, owner, retention class, and cardinality formula | accept runtime-created names, tenant-defined attributes, free-form templates, arbitrary objects, or remote executable rules |
| `Uam.Diagnostics.Analyzers` | fail builds on ad-hoc log calls, interpolated templates, exception capture, unregistered attributes/instruments/spans, forbidden APIs and fields, unbounded label types, missing owner/runbook | infer privacy safety from names alone or allow suppression without owner/expiry |
| Endpoint safe-record library | expose closed structs with enum and bounded primitive fields; serialize with strict contracts; clear operation-local buffers | expose raw URL/path/source/user/application/realm/device/session values, `Exception`, stack, object dictionaries, or reflection-based serialization |
| Task Host | emit only value-free stage/outcome records over its inherited private channel; terminate normally or with a finite crash class | create files, logs, dumps, network connections, support bundles, arbitrary event names, or raw exception records |
| User Host | attach authenticated process/session context internally, validate record schema, forward bounded records | add user/session identifiers to the diagnostic body, persist raw data, or reinterpret Task Host source values |
| Coordinator Diagnostics Gateway | validate release identity, process role, schema, permit state and rate limits; own local journal/counters/export; remap correlation tokens; expose local safe health | read user profiles, accept payload realm/device claims, block event/cursor durability, write raw diagnostic text, or become a remote command executor |
| Endpoint diagnostic journal | store closed finite events and counters separately from the business outbox; enforce byte/age/count limits and integrity | store raw activity, database rows, SQLite file copies, process memory, SQL, paths, or stable user/source/application identifiers |
| Server/portal diagnostics wrapper | emit source-generated catalogue events and UAM-defined OpenTelemetry instruments/spans | call generic logging with arbitrary templates/objects, enable broad auto-instrumentation defaults, or treat telemetry as authorization/audit |
| Minimal Collector gateway | authenticate producer, apply closed allowlist, reject unknown attributes, enforce memory/queue limits, scan canaries, export to one approved destination, expose self-health | run on endpoints, use host/file/process receivers, accept remote arbitrary OTTL/config, silently ignore privacy transform failures, or serve as the sole redaction boundary |
| Support Bundle Builder | freeze one deterministic safe snapshot; collect only manifest-authorized projections; canonicalize, size-check, scan, encrypt and upload | execute commands, glob files, crawl registry/profile, collect raw logs/dumps/EVTX/ETL/PCAP/DB files, or silently truncate |
| Diagnostic Permit Evaluator | verify signature, key purpose, realm/target, release/policy/ceiling digests, level, time, purpose, destination, byte/event limits, approval claims, nonce and anti-rollback | grant new source/field/transform/destination/capability, accept lower revision, trust payload target, or extend itself after expiry |
| Support backend | derive realm/target from authenticated custody context, store encrypted/case-scoped artifact, record access, enforce expiry/deletion, rescan on controlled decryption | provide cross-realm global search, accept a bundle’s realm claim as authority, retain indefinitely by convenience, or expose raw plaintext to broad operators |
| Audit module | record permit issuance, privileged activation, access, download, revocation, deletion, override attempt and re-enable authorization | copy support-bundle content or rely on operational logs as durable audit evidence |

## 3.3 Trust boundaries

### TB-01 — raw source to Task Host

Raw activity may exist only inside the fixed Task Host for its already authorized source operation. The diagnostics API available there accepts finite enums and bounded counters only. It has no string overload for source-derived data.

### TB-02 — Task Host/User Host to Coordinator

The existing authenticated IPC context supplies process and session authority. Diagnostic payloads do not contain authoritative SID, session, realm, device, installation, user, source, application, site, or path fields. The Coordinator rejects an unknown schema/event ID before persistence.

### TB-03 — endpoint to server

Endpoint export uses the accepted authenticated, bounded product transport unless a later device/network ADR proves a direct OTLP path. Server realm/device binding comes from authenticated registration, not diagnostic payload. Endpoint diagnostic upload and business event upload have distinct contract IDs, rate limits, receipts, and storage state.

### TB-04 — application to Collector

Application code is the first privacy enforcement point. The Collector is a separately configured negative-control barrier: unknown or forbidden attributes cause rejection/alert, not silent field removal followed by success. The Collector configuration is release-controlled, content-addressed, tested, and promoted as the same digest.

### TB-05 — support bundle plaintext to encrypted artifact

Plaintext exists only in process memory in a short-lived builder. The builder validates closed schemas, runs exact canary/forbidden-key scans, computes a canonical manifest and digest, then encrypts directly to an authenticated product-owned temporary file or stream. No plaintext temporary directory or archive is created.

### TB-06 — support backend and portal

Realm/target/case authorization is evaluated before metadata or bundle access. Search indexes contain only finite manifest fields. Controlled decryption happens inside the approved backend boundary and is separately audited. A support operator cannot browse all bundles by fingerprint or device.

## 3.4 Configuration ownership, flags, and kill switches

| Control | Owner function | Scope | Rule |
|---|---|---|---|
| Telemetry catalogue | Observability Architecture + Privacy Engineering | release | only source-controlled reviewed changes; consumer-first compatibility |
| Product diagnostic ceiling | Product Privacy Authority + Release/Signing | release | enumerates levels, events, fields, metrics, spans, bundle artefacts, limits, destinations and kill switches |
| Tenant diagnostic policy | Tenant Governance authority | realm | can disable or reduce levels, retention, artefacts and destinations; cannot add expressions or fields |
| Collector allowlist | Observability Platform + Security | environment/release | generated from catalogue, exact digest, no broad wildcards; transform/filter error mode explicitly fails safe |
| Support bundle recipe | Product Support Engineering + Privacy | release | closed collector IDs only; no file/command/plugin collector |
| Diagnostic permit | designated diagnostic access authority | ticket/target/time | one purpose, one target, one level, one destination, strict expiry and byte/event budget |
| Global kill | Product Security/Privacy incident authority | all | disables new permits and active enhanced diagnostics |
| Realm kill | Realm operations/security authority | realm | disables realm activation and uploads |
| Target kill | Endpoint/server control plane | target | revokes one target and discards pending enhanced data |
| Component/source kill | Release-owned finite ID | capability | stops one diagnostic family without changing collection source semantics |
| Local safety kill | Coordinator | local | triggers on canary, clock uncertainty, store corruption, permit mismatch, repeated overflow, or crash loop |
| Backend kill | Support platform owner | destination | prevents upload/decryption when backend integrity or authorization is uncertain |

Flags are typed states, not general key/value feature flags. A tenant cannot provide paths, regex, scripts, commands, OTTL, SQL, log templates, metric labels, span attributes, archive entries, encryption algorithms, URLs, or backend addresses.

## 3.5 Realm isolation

- Realm is derived from authenticated server context and stored as a protected authorization/index column where operational records require realm scope.
- Realm is never a metric label, span attribute, log body, error fingerprint input, bundle filename, or user-visible correlation token.
- Endpoint records do not carry an authoritative realm claim.
- Cache keys, database keys, support case lookup, export queues, deletion jobs and audit records begin with the authenticated realm boundary.
- Bundle encryption metadata uses an opaque destination/key identifier; no human-readable tenant name appears.
- Every query and mutation has same-realm negative tests. Cross-realm denial is a security event with no echo of the requested target.

## 3.6 Cost, licensing, skills, and operations

**RECOMMENDATION.** Use OpenTelemetry .NET as an admitted application library and build a minimal server-side Collector distribution containing only the required receiver, memory limiter, batch/queue, allowlist/redaction backstop, canary control, health, and one exporter. Do not deploy the Collector on endpoints initially.

Operational implications:

- engineering needs .NET source-generated logging, OpenTelemetry SDK, metric-cardinality, tracing, Collector configuration, secure storage, and incident-response skills;
- a custom Collector distribution reduces attack and maintenance surface but requires a pinned build, SBOM/provenance, recurring vulnerability review, config tests, load tests, and an owner;
- storage/query cost is dominated by series count, event rate, trace sampling, retention, indexes, replicas, backups, and support access—not by the SDK license;
- OpenTelemetry projects reviewed here use Apache-2.0, but every package/binary/transitive remains subject to the accepted dependency and license admission process;
- the observability backend, archive encryption library, key service, and commercial support are procurement and human decisions;
- cost estimates must be produced from synthetic load and later approved metadata-only measurements, not a “6,000 endpoints” count alone.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision now | Why rejected or deferred | Condition to reconsider |
|---|---|---|---|
| Free-form text logging with reviewer discipline | **REJECTED** | strings, objects and exceptions make privacy, compatibility, localization, cardinality and ownership unenforceable | no expected reconsideration; closed events are simpler and safer |
| “Log everything locally, redact before upload” | **REJECTED** | violates minimization before durable diagnostics and creates plaintext recovery/backup/support risk | only a baseline change proposal with stronger privacy evidence; unlikely to be acceptable |
| Hash/HMAC raw URL, host, user, path or identity for diagnostics | **REJECTED** | predictable spaces can be enumerable; stable digests create linkability and are unnecessary [W01] | only a specific approved non-reversible need with formal threat analysis; ordinary support is not sufficient |
| Generic ASP.NET Core/HttpClient HTTP logging | **REJECTED BY DEFAULT** | may capture path, query, headers, body and route parameters [W15–W16] | a UAM wrapper proves only route-template ID, method, status class and latency can pass |
| Broad OpenTelemetry auto-instrumentation and default semantic conventions | **REJECTED BY DEFAULT** | standard attributes can include full URL, path/query, addresses, headers and high-cardinality values [W04–W05] | exact instrumentation module and attribute allowlist pass all-sink and semantic-diff tests |
| Endpoint OpenTelemetry Collector/agent | **REJECTED INITIALLY** | adds another service, config plane, queue, plugin surface, endpoint network path and operational footprint | measured need plus device identity/network/release/cleanup proof and smaller total risk than existing transport |
| Collector redaction as primary privacy boundary | **REJECTED** | data already crossed the application boundary; config errors/default changes can silently weaken processing | Collector remains only a tested independent backstop |
| Vendor crash/error SaaS SDK on endpoints | **REJECTED** | common models collect stack, request, user, device, breadcrumbs and attachments; destination and legal/realm surface expand | a separately approved self-hosted profile proving exact zero-raw schema and operational need |
| Automatic WER or .NET dumps in production | **REJECTED** | dumps can contain full process memory and sensitive data [W17–W19] | T1 synthetic lab permit only; production raw dump requires explicit baseline change and human authority |
| Remote diagnostic port or debugger attach | **REJECTED FOR ORDINARY SUPPORT** | creates a process-memory/control boundary outside the product privacy ceiling | isolated T1 lab or exceptional security investigation under a separate privileged forensic process, not this design |
| General support-bundle framework with command/file collectors | **REJECTED** | arbitrary commands, globs and file collection are effectively a remote execution/exfiltration channel | none for endpoints; selected design ideas may be reimplemented as closed collectors |
| Plain ZIP/TAR support bundles | **REJECTED** | plaintext residue, archive traversal, duplicate-name, decompression and accidental attachment risk | no expected production use; encryption and strict manifest are mandatory |
| Full raw log archive in a bundle | **REJECTED** | even nominally safe logs can contain escaped values, unbounded volume, rare identifiers and scanner blind spots | bounded catalogue-derived timeline and aggregates only |
| Dynamic diagnostic level that enables new fields/sources | **REJECTED** | becomes a hidden broader product and violates tenant-only narrowing | level may only enable precompiled safe signals already in the product ceiling |
| Always-on endpoint traces | **REJECTED** | higher volume/correlation, propagation and accidental attributes are not justified for offline endpoints | measured support benefit, zero-leak proof and approved budget; D1 remains permit-bound |
| Head sampling all server errors at 100% | **DEFERRED** | traces are not needed to count errors; error traffic can be attacker-controlled and expensive | measured controlled rate and privacy-safe attributes, or bounded tail sampling proof |
| Tail sampling as initial default | **DEFERRED** | requires all spans of a trace to reach one decision point and adds buffering/state/overload behavior [W10] | load, routing, failure and cost evidence demonstrates material value |
| Use operational logs as audit evidence | **REJECTED** | sampling, expiry, backpressure and support access differ; accepted baseline requires durable audit for privileged mutations | no expected reconsideration |
| One global observability index across realms | **REJECTED** | increases cross-realm search and bulk-correlation risk | no expected reconsideration; physical storage may be shared only behind mandatory realm authorization controls |
| Application-only telemetry without Collector | **ACCEPTABLE FALLBACK** | simplest if approved backend accepts direct bounded OTLP and all controls are in application | choose after backend/network/operations bake-off; endpoint still uses product transport |
| Non-OpenTelemetry proprietary schema | **DEFERRED ALTERNATIVE** | can satisfy privacy but increases adapter/tooling lock-in | reconsider if OpenTelemetry dependencies or backend cannot pass admission, performance, or privacy tests |

A change to the recommended design requires: affected accepted invariant, new primary evidence, threat/privacy/realm impact, cost/skills impact, smallest falsifying experiment, migration/rollback, and an ADR action.

---
# 5. Interfaces/protocols and example contracts or schemas; normative profile

## 5.1 Common telemetry contract rules

Every diagnostic contract MUST record:

- immutable contract name and exact semantic version;
- producer process/component and every consumer;
- privacy stage and trust source;
- event/instrument/span IDs, fixed names, field types and enum values;
- required/optional/null semantics; no implicit defaults;
- byte, item, string, depth, property, rate, queue and cardinality bounds;
- owner function, support tier, safe user message, severity, retry class, and runbook;
- realm authorization behavior and whether realm is an out-of-body storage key;
- log/metric/trace/bundle/access permissions and forbidden fields;
- compatibility, consumer-first rollout, emergency block and retirement rules;
- golden, boundary, invalid, hostile, canary, old/new and resource vectors.

Objects are closed. Unknown fields, duplicate members, wrong case, invalid UTF-8, trailing data, remote references, comments, and over-limit values are rejected. Diagnostic contracts use the accepted strict JSON profile for persisted/exported records; in-process source-generated methods remain strongly typed and do not create an intermediate arbitrary property map.

## 5.2 Error taxonomy — mandatory artifact

### 5.2.1 Categories

| Category | Meaning | Typical owner function | Default retry rule |
|---|---|---|---|
| `INPUT_INVALID` | a closed contract or bounded value failed validation | owning component/contract authority | `NEVER` |
| `AUTHENTICATION` | trusted peer or credential was absent, expired, rejected, or unverifiable | Identity/Device Trust | `AFTER_REAUTH` |
| `AUTHORIZATION` | authenticated actor lacks the operation | IAM/Product Security | `NEVER` unless authority changes |
| `REALM_ISOLATION` | wrong-realm/target/case access or binding mismatch | Product Security/IAM | `UNKNOWN_HOLD` |
| `PRIVACY_POLICY` | ceiling, tenant policy, permit, expiry, field, destination, or canary rule blocked work | Privacy Engineering/Policy | `AFTER_POLICY_REFRESH` or `UNKNOWN_HOLD` |
| `COMPATIBILITY` | unsupported contract, build, configuration, schema, runtime, or capability | Release/Compatibility | `AFTER_OPERATOR` |
| `TRANSIENT_DEPENDENCY` | bounded dependency unavailable, busy, throttled, or temporarily failed | owning Operations/SRE | `SAME_ID_BACKOFF` |
| `RESOURCE_PRESSURE` | disk, queue, memory, CPU, handle, byte, event, cardinality, or time budget reached | SRE/Endpoint Operations | `AFTER_DEPENDENCY_RECOVERY` |
| `CONCURRENCY` | lease, stale version, ordering, replay, lock, or state conflict | owning Engineering team | `SAME_ID_BACKOFF` only when explicitly safe |
| `DURABILITY` | transaction, checksum, receipt, persistence, replay, restore, or deletion invariant uncertain | Storage/Database Reliability | `UNKNOWN_HOLD` |
| `DATA_QUALITY` | expected typed data is missing, contradictory, stale, quarantined, or semantically invalid | Data Quality/Product | `AFTER_OPERATOR` or no retry |
| `SECURITY_INTEGRITY` | signature, release, binary, key, tamper, canary, audit, or anti-rollback failure | Product Security/Release | `UNKNOWN_HOLD` |
| `INTERNAL_DEFECT` | unexpected release-owned code path or mapped exception class | owning Engineering team | `AFTER_OPERATOR` |
| `OPERATOR_ACTION_REQUIRED` | a known safe state explicitly requires a governed action | named runbook owner | `AFTER_OPERATOR` |
| `CANCELLED` | operation ended because permit, session, shutdown, revocation, kill, or caller cancellation applied | owning component | `NEVER` for the same authorization |

### 5.2.2 Retry classes

| Retry class | Normative behavior |
|---|---|
| `NEVER` | do not retry automatically; report one finite outcome |
| `SAME_ID_BACKOFF` | retry the same stable operation identity with bounded exponential backoff and jitter; never mint a new business identity |
| `AFTER_REAUTH` | refresh/re-establish authenticated authority, then retry only if the original operation remains valid |
| `AFTER_POLICY_REFRESH` | wait for a higher/new valid policy or permit; do not reinterpret an expired authority |
| `AFTER_DEPENDENCY_RECOVERY` | retry after an observable finite healthy state, not a fixed infinite loop |
| `AFTER_OPERATOR` | stop until the named runbook produces an authorized recovery action |
| `UNKNOWN_HOLD` | enter `SafetyHold`; no automatic retry or data progression until classified |

Unknown exception/error codes always map to `INTERNAL_DEFECT`, `UNKNOWN_HOLD`, and a generic safe message. They never become “retryable because unknown.”

### 5.2.3 Severity

| Severity | Use | Prohibited misuse |
|---|---|---|
| `TRACE` | temporary D1 state-transition evidence already in the catalogue | raw method arguments, source values, loop-per-item spam |
| `DEBUG` | temporary D1 bounded internal decision classes | production-always-on detail or arbitrary object serialization |
| `INFO` | expected lifecycle, bounded state change, successful custody or cleanup | per-activity record, user behavior, success noise without support value |
| `WARN` | degraded but contained state, retry scheduled, unsupported capability, nearing budget | invariant failure disguised as warning |
| `ERROR` | operation failed with contained impact and known safe recovery path | privacy/realm/durability uncertainty that needs immediate hold |
| `CRITICAL` | privacy, realm, security integrity, durability, audit, deletion, or repeated crash-loop invariant is uncertain or violated | ordinary dependency outage or user input error |

Severity does not determine retryability. Error code metadata does.

### 5.2.4 Error-code format

```text
UAM-<DOMAIN>-<FOUR_DIGIT_NUMBER>
```

Examples are release-owned and fictional:

| Code | Category | Safe meaning | Retry | Owner | User-safe message key |
|---|---|---|---|---|---|
| `UAM-DIAG-0001` | `INPUT_INVALID` | diagnostic record rejected by closed schema | `NEVER` | Observability Architecture | `diagnostics.record_rejected` |
| `UAM-DIAG-0002` | `PRIVACY_POLICY` | diagnostic field or level not authorized | `UNKNOWN_HOLD` | Privacy Engineering | `diagnostics.not_authorized` |
| `UAM-DIAG-0003` | `RESOURCE_PRESSURE` | diagnostic budget reached; product work continues | `AFTER_DEPENDENCY_RECOVERY` | Endpoint Operations | `diagnostics.temporarily_limited` |
| `UAM-DIAG-0004` | `SECURITY_INTEGRITY` | canary or forbidden-field control failed | `UNKNOWN_HOLD` | Product Security + Privacy | `diagnostics.safety_hold` |
| `UAM-DIAG-0005` | `REALM_ISOLATION` | support target did not match authenticated realm | `UNKNOWN_HOLD` | IAM/Product Security | `request.not_authorized` |
| `UAM-DIAG-0006` | `COMPATIBILITY` | diagnostic contract/configuration version unsupported | `AFTER_OPERATOR` | Release Compatibility | `diagnostics.version_unsupported` |
| `UAM-DIAG-0007` | `DURABILITY` | bundle custody/deletion state cannot be proved | `UNKNOWN_HOLD` | Support Platform Reliability | `diagnostics.state_uncertain` |
| `UAM-DIAG-0008` | `CANCELLED` | enhanced diagnostics stopped by expiry/revocation/kill | `NEVER` | Diagnostic Access Authority | `diagnostics.ended` |

The catalogue owns uniqueness. A code is never reused with a different meaning. Renaming an owner or message does not change the code; changing failure semantics requires a new code.

## 5.3 Structured diagnostic event schema — mandatory artifact

### 5.3.1 In-process source-generated API

All .NET log events MUST use source generation with fixed event ID, event name, level, and template [W13]. The approved pattern is:

```csharp
internal static partial class DiagnosticEvents
{
    [LoggerMessage(
        EventId = 130001,
        EventName = "uam.diagnostic.operation.completed",
        Level = LogLevel.Information,
        Message = "Diagnostic operation completed: component={Component}; stage={Stage}; outcome={Outcome}; duration_bucket={DurationBucket}")]
    internal static partial void OperationCompleted(
        ILogger logger,
        UamComponent Component,
        DiagnosticStage Stage,
        OutcomeClass Outcome,
        DurationBucket DurationBucket);
}
```

The generated method MUST NOT accept `Exception`, `object`, dictionaries, arbitrary strings, paths, URIs, identities, source values, request objects, or format providers. A bounded release-owned enum or catalogue ID is preferred to string. A bounded free text field is not permitted in diagnostic events.

These calls are prohibited outside the wrapper:

```text
ILogger.Log(...)
LogInformation/Warning/Error with interpolated or runtime templates
logger.BeginScope with arbitrary values
exception.ToString(), exception.Message, exception.StackTrace, exception.Data
object destructuring, JSON serialization of domain/request/response objects
Activity.AddEvent with arbitrary tags
Meter.Create* with runtime instrument names
```

### 5.3.2 Wire/storage event

```json
{
  "contract": "uam.diagnostic-event",
  "version": "1.0.0",
  "eventId": "019d0000-0000-7000-8000-000000001301",
  "eventName": "uam.diagnostic.operation.completed",
  "catalogueEventId": 130001,
  "timestampUtc": "2026-07-31T12:00:00Z",
  "observedTimestampUtc": "2026-07-31T12:00:01Z",
  "component": "COORDINATOR",
  "processRole": "MACHINE_COORDINATOR",
  "stage": "BUNDLE_SCAN",
  "outcome": "SUCCESS",
  "severity": "INFO",
  "error": null,
  "operationToken": "op_7XK4Q3M9",
  "trace": null,
  "dimensions": {
    "buildMajor": 1,
    "contractMajor": 1,
    "deploymentRing": "LAB",
    "durationBucket": "LT_1S"
  }
}
```

All values are fictional. Normative rules:

- `eventId` is UUIDv7 for record identity; it is never used as a metric label or support search key across cases.
- `operationToken` is random, short-lived, local to one operation, and remapped when included in a support bundle. It is not a device, user, source, event, batch, receipt, application, or realm identifier.
- `timestampUtc` precision is seconds for endpoint diagnostic events unless a stricter operational need is approved. Raw source-event time is never copied.
- `dimensions` is a closed object generated from catalogue fields. It has no extension bag.
- authenticated realm/target binding is stored outside this body by the receiving service and is mandatory for authorization. Payload fields cannot override it.
- endpoint diagnostic events have a bounded local retention class and may be aggregated or dropped under pressure according to section 6; they do not acknowledge business work.

### 5.3.3 Error object

```json
{
  "code": "UAM-DIAG-0006",
  "category": "COMPATIBILITY",
  "retryClass": "AFTER_OPERATOR",
  "ownerFunction": "RELEASE_COMPATIBILITY",
  "safeMessageKey": "diagnostics.version_unsupported",
  "fingerprintVersion": 1,
  "fingerprint": "sha256:1a6a2bc7722ed61aa799b4ad9ffb7635d7d9c4e0e53818f1fce4ac06d5ecb33f",
  "dependencyStatusClass": "UNSUPPORTED_MAJOR"
}
```

No message, stack, file, line, module path, SQL, URL, host, endpoint address, request body, header, user, realm, device, source, application, native ID, or exception data appears.

## 5.4 Value-free error fingerprint

The fingerprint is a grouping hint, not identity, authorization, dedupe, or forensic proof.

```text
fingerprint_v1 = SHA-256(
  "uam-error-fingerprint-v1" || 0x00 ||
  error_code || 0x00 ||
  component_enum || 0x00 ||
  stage_enum || 0x00 ||
  allowlisted_exception_class_id || 0x00 ||
  top_owned_frame_method_token_from_signed_build_map || 0x00 ||
  dependency_status_class || 0x00 ||
  contract_major
)
```

Rules:

- exception class is mapped to a finite release-owned ID. Unknown becomes `EX_UNKNOWN`.
- stack text is never captured. An in-process mapper may inspect frames and retain only the first UAM-owned metadata token that exists in the signed build map. File path, assembly path, method generic arguments, line number and source text are discarded.
- raw exception text, HRESULT text, OS paths, dependency messages and input values do not enter the tuple.
- fingerprint version is explicit; a new algorithm does not silently regroup old records.
- access to fingerprint-level searches is realm/case scoped. Rare fingerprints may be suppressed or coarsened according to an approved access/retention policy.
- hash collisions and common-mode grouping errors are accepted residual risks; the operator always sees the stable error code and build profile too.

## 5.5 User-safe errors and portal accessibility

External HTTP/control API failures SHOULD use an RFC 9457-compatible closed problem object [W24]:

```json
{
  "type": "urn:uam:problem:diagnostics-version-unsupported",
  "title": "This diagnostic request cannot be used by this version.",
  "status": 409,
  "code": "UAM-DIAG-0006",
  "messageKey": "diagnostics.version_unsupported",
  "correlationReference": "case_ref_J6V8Q2",
  "retry": "CONTACT_SUPPORT",
  "helpTopic": "diagnostics-version"
}
```

- The response contains no exception text, stack, internal route, target identifier, realm name, policy content, or authorization detail.
- `correlationReference` is a case-scoped opaque alias; it cannot be used to enumerate global telemetry.
- Portal error text is localized, plain-language, keyboard accessible, and announced as a status message without forcing focus unless user action is required. Field errors identify the field and correction. WCAG 2.2 error-identification and status-message behavior are acceptance targets [W22–W23].
- Color, icon, or severity alone does not communicate state.
- “Durably received,” “validated,” “quarantined,” “materialized,” and “visible” are distinct user-safe states; the portal does not collapse them into “sent” or “failed.”

## 5.6 Safe HTTP access logging

Generic ASP.NET Core or HttpClient logging is disabled unless wrapped by the UAM profile. The only ordinary access record fields are:

```text
route_template_id          finite release-owned enum
method_class               GET | POST | PUT | PATCH | DELETE | OTHER
status_class               1XX | 2XX | 3XX | 4XX | 5XX | CANCELLED
latency_bucket             finite histogram bucket
request_size_bucket        optional finite bucket, approved per route
response_size_bucket       optional finite bucket, approved per route
authentication_outcome     SUCCESS | ABSENT | EXPIRED | INVALID | ERROR
authorization_outcome      ALLOWED | DENIED | ERROR
realm_guard_outcome        MATCH | DENIED | NOT_APPLICABLE
rate_limit_outcome         ALLOWED | THROTTLED | REJECTED
```

The following are always off: URL, scheme, host, port, path, query, fragment, route values, headers, cookies, body, form, referrer, user agent, client/server IP, TLS subject, token claims, username, realm name/ID in the body, device, installation, session, source, application, batch, receipt, event IDs, and exception details.

## 5.7 Metrics catalogue and cardinality budget — mandatory artifact

### 5.7.1 Global rules

**FACT.** The reviewed OpenTelemetry .NET guidance documents a default 2,000-cardinality limit per metric and per-metric configuration through Views; OpenTelemetry also documents that high-cardinality values can create unbounded memory pressure and that overflow aggregates lose distinguishing attributes [W02–W03]. **RECOMMENDATION.** UAM sets lower explicit limits for every instrument and treats any overflow point as a defect, not normal aggregation.

Prohibited metric labels include:

```text
realm/tenant/customer, device/installation, user/person/SID/email,
session/source/generation/profile, application/rule/site/host/URL/path,
event/batch/receipt/correlation/trace/span IDs, policy/config digests,
exception class/message/stack, HTTP path/query/address/header,
file/process path, command line, database/table/SQL, arbitrary version strings
```

Allowed resource attributes are finite and release-owned: `service.name`, `service.namespace`, `service.version_major`, `process.role`, `deployment.environment_class`, and `deployment.ring`. Resource attributes are audited because SDK cardinality limits may not constrain them in the same way as point attributes.

### 5.7.2 Bootstrap budgets

These are **ESTIMATE** values for prototypes, not approved production budgets:

| Runtime | Total active series budget per process | Reason |
|---|---:|---|
| Endpoint Coordinator | 256 | offline, low-resource, no realm/device labels |
| Endpoint User Host | 128 | transient per-session process; most data forwarded as aggregate classes |
| Endpoint Task Host | 64 | short-lived fixed capability; no exported trace baseline |
| Server process | 2,048 | multiple modules and dependencies, still finite |
| Portal/BFF process | 512 | route and authorization classes only |
| Collector instance | its own measured self-telemetry budget | deployment-specific; must not be mixed with UAM product metrics without a separate catalogue |

The build calculates the theoretical maximum:

```text
instrument_max_series = product(cardinality of each allowed label)
process_max_series = sum(instrument_max_series for enabled instruments)
```

A catalogue cannot be accepted if the theoretical process total exceeds the declared budget. Runtime probes then prove actual behavior, including hostile values.

### 5.7.3 Endpoint metric catalogue

| Instrument | Type/unit | Allowed labels | Max series | Purpose |
|---|---|---|---:|---|
| `uam.diagnostic.event.count` | counter `{event}` | `component`, `severity`, `outcome_family` | 45 | volume by finite class |
| `uam.error.count` | counter `{error}` | `component`, `error_category`, `retry_class` | 120 | error routing without messages |
| `uam.process.restart.count` | counter `{restart}` | `process_role`, `exit_class` | 24 | crash-loop detection |
| `uam.ipc.operation.count` | counter `{operation}` | `operation_family`, `outcome_family` | 40 | authenticated IPC health |
| `uam.store.operation.count` | counter `{operation}` | `store_operation`, `outcome_family` | 48 | local diagnostic-journal health, not business rows |
| `uam.store.queue.depth` | histogram `{record}` | `queue_class` | 4 | bounded queue pressure |
| `uam.store.disk.pressure` | gauge `1` | `pressure_class` | 4 | finite disk state, no path/bytes label |
| `uam.upload.batch.count` | counter `{batch}` | `contract_family`, `outcome_family` | 24 | diagnostic transport outcome |
| `uam.upload.backlog.age` | histogram `s` | `age_class` | 6 | bounded age categories |
| `uam.policy.state` | up/down counter `{transition}` | `policy_family`, `state_class` | 30 | active/expired/hold transitions |
| `uam.diagnostic.mode` | gauge `1` | `diagnostic_level`, `state_class` | 20 | D0/D1/D2 state without target identity |
| `uam.metric.overflow.count` | counter `{overflow}` | `instrument_family` | 16 | immediate control alarm |
| `uam.canary.scan.count` | counter `{scan}` | `scan_stage`, `outcome_family` | 24 | scanner operation, never marker value |
| `uam.bundle.lifecycle.count` | counter `{bundle}` | `state_class`, `outcome_family` | 60 | generation/upload/delete lifecycle |

### 5.7.4 Server metric catalogue

| Instrument | Type/unit | Allowed labels | Max series | Purpose |
|---|---|---|---:|---|
| `uam.ingress.request.count` | counter `{request}` | `route_template`, `authn_outcome`, `status_class` | 240 | safe ingress health |
| `uam.ingress.duration` | histogram `s` | `route_template`, `status_class` | 80 | route-template latency |
| `uam.inbox.transition.count` | counter `{transition}` | `from_state`, `to_state`, `outcome_family` | 180 | custody/validation/quarantine state |
| `uam.worker.lease.count` | counter `{lease}` | `worker_family`, `outcome_family` | 48 | leased-work health |
| `uam.materialization.count` | counter `{item}` | `materializer_family`, `outcome_family` | 60 | typed fact processing |
| `uam.quarantine.count` | counter `{item}` | `reason_family`, `contract_major` | 120 | finite poison/compatibility classes |
| `uam.database.operation.count` | counter `{operation}` | `module`, `operation_family`, `outcome_family` | 240 | DB health without SQL/table/key values |
| `uam.support.bundle.lifecycle` | counter `{bundle}` | `state_class`, `outcome_family` | 60 | support-bundle backend lifecycle |
| `uam.diagnostic.access.lifecycle` | counter `{action}` | `action_class`, `outcome_family` | 72 | permit/access operations; identity remains audit-only |
| `uam.realm.guard.denial` | counter `{denial}` | `boundary`, `reason_family` | 48 | cross-realm control health |
| `uam.collector.export.count` | counter `{item}` | `signal`, `outcome_family` | 24 | Collector/exporter health |

### 5.7.5 Portal metric catalogue

| Instrument | Type/unit | Allowed labels | Max series | Purpose |
|---|---|---|---:|---|
| `uam.portal.request.count` | counter `{request}` | `route_template`, `status_class` | 80 | BFF/UI health |
| `uam.portal.authz.count` | counter `{decision}` | `operation_class`, `outcome_family` | 60 | authorization behavior |
| `uam.portal.error.count` | counter `{error}` | `error_category`, `surface_class` | 45 | safe UI error classes |
| `uam.portal.status_message.count` | counter `{message}` | `message_class`, `announcement_outcome` | 24 | accessibility status-message instrumentation using synthetic tests only in production aggregate |

Histogram buckets are selected by CLI measurements and versioned in the catalogue. Exact endpoint, server, and portal budgets require SRE/Product approval.

## 5.8 Trace catalogue, sampling, and propagation — mandatory artifact

### 5.8.1 Baseline

- Endpoint exported traces are **off** at D0.
- D1 may enable only predeclared safe spans for one target and a bounded duration.
- Server and portal use manual UAM-owned spans plus explicitly admitted framework instrumentation after attribute tests.
- Span names are static operation names or route-template IDs; never URLs, paths, SQL, file names, user actions, application names, or values.

### 5.8.2 Safe span names and attributes

| Span name | Kind | Allowed attributes |
|---|---|---|
| `uam.endpoint.diagnostic_export` | CLIENT | `component`, `outcome_family`, `contract_major`, `retry_class` |
| `uam.server.ingress_accept` | SERVER | `route_template`, `method_class`, `status_class`, `authn_outcome`, `authz_outcome` |
| `uam.server.inbox_transition` | INTERNAL | `from_state`, `to_state`, `outcome_family`, `contract_major` |
| `uam.server.worker_operation` | INTERNAL | `worker_family`, `operation_family`, `outcome_family`, `retry_class` |
| `uam.server.database_operation` | CLIENT/INTERNAL | `module`, `operation_family`, `outcome_family`; no statement/table/key |
| `uam.portal.control_operation` | SERVER | `route_template`, `operation_class`, `status_class`, `authz_outcome` |
| `uam.support.bundle_operation` | INTERNAL | `state_class`, `operation_family`, `outcome_family`, `diagnostic_level` |

Prohibited attributes include all URL/network/header/body fields, database statements, peer addresses, end-user fields, realm/device/install/source/application IDs, correlation tokens, exception text and stack. `error.type`, when used, is a finite UAM error-category ID, not a runtime exception name; OpenTelemetry recommends a predictable low-cardinality value [W04].

### 5.8.3 Sampling

- Server/portal baseline uses `ParentBased(TraceIdRatioBased(p))` with deterministic trace-ID sampling [W08].
- **ESTIMATE:** start the synthetic load lane with `p = 0.01`; production `p` is a human/CLI decision based on cost and diagnostic yield.
- Security/privacy/durability error counts are emitted as logs/metrics independently; a trace sample is not required for detection.
- A caller cannot request sampling through headers, query, baggage, account, realm, or tenant policy.
- Tail sampling is disabled initially. It may be introduced only after load, routing, buffering, loss, outage and privacy tests prove all spans for a trace reach the same decision point and no sensitive attribute is retained merely to decide [W10].

### 5.8.4 Propagation

- W3C Trace Context is the only initial propagator [W06].
- W3C Baggage is disabled, rejected on ingress, never created, and removed on egress because it carries arbitrary application-defined properties [W07].
- External `tracestate` is discarded at the untrusted boundary unless a later interop ADR proves a bounded need.
- Trace context never carries authentication, authorization, realm, target, user, device, installation, source, application, policy, ticket, support case, batch, receipt, or business identity.
- The ingress boundary starts a new internal trace after authentication/realm binding when external context is invalid, oversized, duplicated, prohibited, or untrusted.
- Trace/log correlation stores only TraceId/SpanId in controlled server telemetry. Endpoint bundles remap or omit them; trace IDs are never metric labels.

## 5.9 Exception handling and crash behavior

### 5.9.1 Exception mapping

Every trust boundary catches only expected exception classes and maps them to finite catalogue errors. The mapper:

1. classifies release-owned exception type through a generated map;
2. maps selected dependency result/status classes through a finite adapter;
3. optionally resolves one UAM-owned method metadata token from a signed build map;
4. produces the safe error object and fingerprint;
5. discards the exception object before asynchronous export;
6. never serializes message, inner exception, stack text, `Data`, target site, source, path, SQL, HTTP content, headers, or arguments.

An unexpected exception increments a finite crash/defect metric and returns a generic safe outcome. Development console sinks that print exceptions are prohibited in release builds.

### 5.9.2 Crash policy

**FACT.** .NET dumps can contain full process memory [W17]. .NET crash dump generation is disabled unless explicitly enabled, and WER local user-mode dumps require administrative configuration and can collect full dumps [W18–W19].

Normative endpoint policy:

- `DOTNET_DbgEnableMiniDump` and equivalent UAM dump settings remain disabled in production.
- MSI validation and a read-only health check detect UAM-specific WER `LocalDumps` configuration; unexpected enablement enters diagnostic `SafetyHold` and raises an operator-safe alert.
- The Task Host never enables the diagnostic port, debugger attach, dumps, EventPipe file traces, or profiler APIs in ordinary operation.
- A crash summary contains only process role, build major/profile, exit class, safe fingerprint, restart-count bucket, active diagnostic level, and finite last-stage ID.
- Repeated crash threshold is an **ESTIMATE** selected by experiment. Crossing it stops the affected capability and may stop enhanced diagnostics; it does not create a dump automatically.
- Raw dumps are allowed only in an isolated T1 synthetic lab under a separate signed lab permit, never uploaded in a support bundle, and deleted/reverted with evidence.

## 5.10 Support-bundle manifest — mandatory artifact

### 5.10.1 Allowed content

A bundle may contain only these release-owned logical entries:

| Entry | Content |
|---|---|
| `manifest.json` | contract, bundle ID, safe target binding token, permit digest, generator/build/config/schema versions, time window, entry hashes/sizes, encryption profile ID, expiry and lifecycle state |
| `inventory.json` | component/build major, signed file hashes, signature status, contract/config/policy/ceiling version or digest classes; no paths or certificate subjects |
| `health.json` | finite component/source-family states, queue/disk/memory/clock/proxy/TLS/status classes and restart buckets |
| `counters.json` | bounded catalogue metric snapshots and cardinality report |
| `errors.ndjson` | bounded error code/fingerprint counts and last-seen time buckets; no raw event bodies |
| `timeline.ndjson` | bounded value-free state transitions with minute-rounded time, remapped operation token, event code and outcome |
| `storage-status.json` | integrity/status enums, counts, page/queue/age buckets, migration version; no DB copy, row, key, table content or SQL |
| `transport-status.json` | custody/validation/quarantine/materialization/visibility counts and reason classes; no event/batch/receipt IDs |
| `canary-report.json` | scanner/config digest, positive-control pass, sink matrix counts and zero-escape assertion; never marker values in the report |
| `authorization.json` | permit ID/digest, level, purpose class, approvals class, approved consent/notice mode, optional acknowledgement-receipt digest, issued/not-before/expiry, target-binding digest class, kill/revocation status; no human identity in the bundle |
| `cleanup.json` | local artifact deletion and handle/process cleanup result |

Forbidden entries include raw log files, browser/source databases, SQLite/WAL/SHM files, event/outbox rows, SQL, URLs/hosts/paths, profile data, usernames/SIDs/emails/person identifiers, stable realm/device/install/session/source/application IDs, IP/MAC/serial, registry or environment dumps, command lines, config secrets, certificates/private keys/tokens, headers/bodies, Windows EVTX, ETL, PCAP, screenshots, process memory, dumps, arbitrary files, and vendor diagnostic archives.

### 5.10.2 Example manifest

```json
{
  "contract": "uam.support-bundle-manifest",
  "version": "1.0.0",
  "bundleId": "019d0000-0000-7000-8000-000000001350",
  "createdAtUtc": "2026-07-31T12:00:00Z",
  "snapshotAtUtc": "2026-07-31T12:00:00Z",
  "generator": {
    "component": "COORDINATOR",
    "buildMajor": 1,
    "catalogueVersion": "1.0.0",
    "recipeId": "ENDPOINT_STANDARD_D2_V1"
  },
  "authorization": {
    "permitDigest": "sha256:9c44f0d3ce28d40e4fdd920f50d89e9735dc28570ba8e1a9a1ea3374bcbdff7e",
    "diagnosticLevel": "D2_BUNDLE",
    "purposeClass": "DEFINED_FAILURE_DIAGNOSIS",
    "targetBindingClass": "AUTHENTICATED_INSTALLATION",
    "consentMode": "LOCAL_VISIBLE_ACK_T1",
    "consentReceiptDigest": "sha256:73f348d6b3f818c56fcc0ea602af3ca20f4bf0b834d64f27efac244aac91b900",
    "notBeforeUtc": "2026-07-31T11:55:00Z",
    "expiresAtUtc": "2026-07-31T12:15:00Z"
  },
  "privacy": {
    "productCeilingDigest": "sha256:2ce83b24f46256ec148b9cc11a6e82fdcad6b8c4efcfa688bd0a7a9a125c91ea",
    "tenantPolicyDigest": "sha256:1bfd957969f1ba404b7114611d88283c55c3a163123fb8454634cda112c58009",
    "forbiddenFieldScan": "PASS",
    "canaryPositiveControls": "PASS",
    "canaryEscapes": 0
  },
  "limits": {
    "uncompressedBytes": 135200,
    "encryptedBytes": 48200,
    "entryCount": 10,
    "timelineRecords": 84,
    "fingerprintGroups": 12
  },
  "entries": [
    {
      "name": "health.json",
      "mediaType": "application/json",
      "bytes": 6432,
      "sha256": "7f041e5d41e07b939caf2f823d0830a85f83c963b0fa018c78207bc312427a52"
    }
  ],
  "payloadRootSha256": "6a3024df9e1048029e5b0a39b197f7283f808ba75efda088919f38429200e9b4",
  "encryptionProfileId": "PROVISIONAL_ENTERPRISE_ENVELOPE_V1",
  "uploadDestinationId": "APPROVED_SUPPORT_BACKEND_1",
  "deleteAfterUtc": "2026-08-03T12:00:00Z",
  "state": "ENCRYPTED_PENDING_UPLOAD"
}
```

All values are fictional. The manifest is inside the authenticated encrypted payload; an outer transport envelope contains only bundle ID, byte length, ciphertext digest, encryption profile/key ID, one-time upload token reference, and authenticated target context.

### 5.10.3 Determinism

For a fixed T1 system snapshot, permit, recipe, clock, catalogue, and build:

- entries are generated in fixed order;
- JSON/NDJSON uses canonical field/order/encoding rules; no locale, host path, process ID, random archive timestamp, compression timestamp, username, or wall-clock call appears;
- timeline records use fixed sort keys and remapped operation tokens;
- archive entry names are from a closed allowlist and unique after case normalization;
- the same plaintext inputs produce the same plaintext payload-root digest;
- encryption is intentionally randomized and need not produce identical ciphertext.

## 5.11 Bundle size and archive profile

Bootstrap limits are **ESTIMATE** and require measurement:

```text
maximum uncompressed payload:     32 MiB
maximum encrypted artifact:        8 MiB
maximum uncompressed:compressed:   4:1
maximum entries:                  32
maximum timeline records:       1,000
maximum fingerprint groups:       500
maximum collection duration:       permit-bound, initial lab cap 2 minutes
```

The builder fails closed before exceeding a limit. It does not silently truncate, drop high-severity records, or change the recipe. It may emit a separate tiny `BUNDLE_LIMIT_REACHED` status event, not a partial bundle, unless a future recipe explicitly defines a semantically complete bounded subset.

Archive/envelope rules:

- no symbolic links, hard links, devices, alternate data streams, path separators in entry names, `..`, absolute paths, duplicate/case-colliding names, nested archives, executable content, or external references;
- decompression verifies declared per-entry and total sizes before allocation;
- ciphertext digest and authenticated metadata are verified before decryption;
- plaintext schema/canary scan runs again inside the approved backend after controlled decryption;
- extraction uses an in-memory object model or isolated product-owned directory with no executable use and immediate deletion.

## 5.12 Diagnostic permit contract — mandatory artifact

```json
{
  "contract": "uam.diagnostic-permit",
  "version": "1.0.0",
  "permitId": "019d0000-0000-7000-8000-000000001360",
  "revision": 14,
  "purposeClass": "DEFINED_FAILURE_DIAGNOSIS",
  "ticketReference": "opaque_case_4PK6M2",
  "consent": {
    "mode": "LOCAL_VISIBLE_ACK_T1",
    "receiptDigest": "sha256:73f348d6b3f818c56fcc0ea602af3ca20f4bf0b834d64f27efac244aac91b900"
  },
  "realmBinding": "AUTHENTICATED_REALM_DIGEST",
  "targetBinding": {
    "kind": "INSTALLATION",
    "opaqueDigest": "sha256:8c4a06c2fe1af0967f71e40e3fbe6f28226f362e460ddbc8b1e496fe8b932e2b"
  },
  "diagnosticLevel": "D2_BUNDLE",
  "allowedRecipeIds": ["ENDPOINT_STANDARD_D2_V1"],
  "allowedSignalIds": ["ENDPOINT_SAFE_HEALTH_V1"],
  "destinationId": "APPROVED_SUPPORT_BACKEND_1",
  "limits": {
    "maxActivations": 1,
    "maxDurationSeconds": 900,
    "maxEvents": 1000,
    "maxUncompressedBytes": 33554432,
    "maxEncryptedBytes": 8388608
  },
  "authority": {
    "productCeilingDigest": "sha256:2ce83b24f46256ec148b9cc11a6e82fdcad6b8c4efcfa688bd0a7a9a125c91ea",
    "tenantPolicyDigest": "sha256:1bfd957969f1ba404b7114611d88283c55c3a163123fb8454634cda112c58009",
    "releaseManifestDigest": "sha256:554d270349f65814a17783c671995a64b97a09e582c2b1b4c03f8e4c81682c4a",
    "keyPurpose": "UAM_DIAGNOSTIC_PERMIT"
  },
  "notBeforeUtc": "2026-07-31T11:55:00Z",
  "expiresAtUtc": "2026-07-31T12:15:00Z",
  "nonce": "t1-fictional-single-use-nonce",
  "approvals": ["DIAGNOSTIC_ACCESS_AUTHORITY"],
  "signature": {
    "profileId": "PROVISIONAL_SIGNED_CONTROL_PROFILE",
    "keyId": "TEST_KEY_1",
    "value": "T1_TEST_SIGNATURE"
  }
}
```

The concrete signature profile is inherited from the future signed-control-artifact ADR and remains provisional. The permit MUST be immutable, canonical, content-addressed, audience/realm/target bound, strictly revision-monotonic, purpose/key separated, time-bounded, single-use or activation-count bounded, and non-broadening.

**HUMAN DECISION.** Whether a particular deployment requires end-user acknowledgement, local-administrator acknowledgement, enterprise-policy authorization with notice, another lawful interaction, or no runtime interaction cannot be decided by this research. Cryptographic authorization and consent/notice are separate controls: a valid signature does not prove that a required interaction occurred, and login/session presence does not imply consent. When the approved policy requires an acknowledgement, the permit MUST carry one release-owned finite `consent.mode` and a purpose/target/permit-bound receipt digest; absence, mismatch, replay, expiry, or revocation blocks D1/D2. The receipt contains no name, account, SID, free text, activity value, path, address, or stable person identifier. Until HD13-21 is decided, production D2 remains disabled and only a visible local T1 lab acknowledgement is allowed.

The effective authority is:

```text
EffectiveDiagnostics =
    ProductDiagnosticCeiling
  ∧ TenantDiagnosticPolicy
  ∧ DiagnosticPermit
  ∧ ProductEmergencyNarrowing
  ∧ TenantEmergencyNarrowing
  ∧ LocalSafetyDisablement
  ∧ RuntimeCapabilityAvailability
```

For every successful activation, `EffectiveDiagnostics` is a subset of the product ceiling and tenant policy. Unknown or incomparable values disable the affected capability.

## 5.13 Support-bundle encryption and upload protocol

### 5.13.1 Required properties

The chosen profile MUST provide:

- authenticated encryption of the complete canonical payload;
- recipient/key-purpose/audience binding;
- algorithm allowlist with no payload-selected downgrade;
- per-bundle fresh randomness/nonces;
- ciphertext and manifest integrity;
- key rotation, revocation, overlap, recovery and offline behavior;
- interoperability vectors between endpoint/server implementations;
- no plaintext disk file;
- safe failure when the destination key is absent, stale, revoked, wrong realm, or unsupported.

### 5.13.2 Candidate profiles

**RECOMMENDATION FOR EXPERIMENT, NOT FINAL CRYPTO DECISION.** Compare:

1. CMS EnvelopedData with an approved authenticated-encryption content profile and enterprise X.509 recipient key [W27–W28];
2. HPKE with a narrowly admitted implementation and enterprise key-distribution profile [W29].

CMS may fit enterprise certificate operations and .NET/Windows integration better; HPKE can offer a simpler modern hybrid construction but may add dependency, key-format and operations work. Exact algorithms, certificates, KMS/HSM, recipient model, recovery and compliance are **HUMAN DECISION** plus **CLI EXPERIMENT**.

### 5.13.3 Upload

- Upload is bounded HTTPS using endpoint authentication plus a one-time bundle token scoped to permit, authenticated target, destination, max bytes, expiry, and bundle ID.
- Server derives realm/target from authenticated context, validates ciphertext digest/length/profile and stores it in the declared durable failure domain before issuing a custody receipt.
- Receipt means encrypted-bundle custody only. It does not mean decryption, canary scan, support acceptance, visibility, analysis, or deletion scheduling succeeded.
- Client retains only the encrypted product-owned artifact until custody receipt or local expiry, then deletes and records cleanup. It never retains plaintext.
- Retries reuse stable bundle ID/ciphertext; they do not regenerate a different bundle unless the permit and lifecycle explicitly authorize a new snapshot.

## 5.14 Collector gateway profile

A minimal custom Collector distribution SHOULD contain only:

```text
OTLP receiver with authenticated TLS
memory limiter
UAM generated allowlist/forbidden-attribute validator
redaction processor as secondary defense
batch and bounded retry/sending queue
health/self-telemetry endpoints on protected management network
one approved exporter
```

Requirements:

- all component versions and binary hashes are pinned and included in SBOM/provenance;
- no host metrics, file log, Windows event log, process, syslog, journald, Kubernetes, database, packet, profiling, debug, zPages, pprof, remote command, or arbitrary receiver is compiled/enabled unless separately approved;
- filter/transform processors explicitly use fail-safe error behavior. The reviewed Collector Contrib v0.157.0 made top-level filter/transform `error_mode` default to `ignore`, demonstrating why defaults cannot be trusted [W10];
- unknown attributes, scopes, event names, metric instruments, span names, resource attributes and enum values are rejected/quarantined, not silently exported;
- persistent queues, if selected, contain only already-safe telemetry and have encrypted storage, bounds, deletion and restore behavior; they are not the source privacy boundary;
- the memory limiter is not treated as proof against all pre-limit allocations; load tests instrument process memory, queue and drop/retry state;
- Collector logs themselves use a separate safe operational profile and cannot include rejected payload bodies.

---
# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Diagnostic levels

| Level | Name | Permitted behavior | Activation |
|---|---|---|---|
| `D0_BASELINE` | always-safe health | finite counters, errors, state transitions, safe access logs, crash summaries, cardinality/queue/clock/disk classes | compiled and enabled by release/tenant policy; no temporary permit required for the minimum approved set |
| `D1_ENHANCED_SAFE` | temporary safe detail | additional predeclared value-free state events and safe spans, higher bounded sampling, shorter aggregation interval | valid signed diagnostic permit, target/realm match, strict expiry and budget |
| `D2_BUNDLE` | deterministic snapshot | one or a bounded number of approved support-bundle recipes from D0/D1 safe projections | valid signed permit with recipe, destination, bytes, activation count, purpose and approvals |
| `D3_RAW` | raw/debug capture | **unrepresentable and prohibited**: no raw activity, paths, identities, process memory, database/file/log/packet export, arbitrary command, dynamic instrumentation or privacy-ceiling override | never accepted by this architecture |

A release cannot map a numeric/string level to hidden behavior. Level semantics are a closed catalogue and contract version.

## 6.2 Temporary diagnostic-access state machine — mandatory artifact

```text
DISABLED
  -> REQUESTED_LOCAL_OR_SERVER
      -> REJECTED                         invalid purpose/target/authority
      -> AWAITING_APPROVAL                human authority required
          -> REJECTED
          -> AWAITING_REQUIRED_ACK         only when approved consent/notice policy requires an acknowledgement
              -> REJECTED_OR_EXPIRED
              -> AUTHORIZED               signed permit plus valid acknowledgement receipt
          -> AUTHORIZED                   signed permit; only when approved policy requires no runtime acknowledgement
              -> DELIVERED                target durably stores verified permit
                  -> ARMED                not-before reached; all local checks pass
                      -> ACTIVE_D1         enhanced safe signals
                      -> ACTIVE_D2         one deterministic bundle snapshot
                      -> EXPIRING          watchdog or budget near limit
                  -> REVOKED               higher-revision revocation/kill
                  -> SAFETY_HOLD           signature/realm/ceiling/clock/canary/integrity uncertainty

ACTIVE_D1 or ACTIVE_D2
  -> EXPIRING                              time/byte/event/activation budget
  -> REVOKED                               explicit revocation or kill
  -> SAFETY_HOLD                           invariant uncertainty
  -> CLEANUP                               successful completion

EXPIRING or REVOKED or SAFETY_HOLD
  -> CLEANUP
      -> CLOSED                            buffers/records/artifacts deleted or retained only by approved custody state
      -> CLEANUP_FAILED                    remains disabled; operator runbook

CLOSED
  -> DISABLED                              no self-renewal; new permit required
```

### 6.2.1 Transition rules

- `REQUESTED` is not authority and changes no endpoint behavior.
- `AWAITING_REQUIRED_ACK` exists only when the human-approved consent/notice policy requires a local interaction. It times out with the request and cannot be satisfied by login, session presence, a server assertion alone, or a reusable receipt.
- `AUTHORIZED` requires a valid signed permit and, where required, a valid purpose/target/permit-bound acknowledgement receipt. It does not activate until local ceiling, tenant policy, release, target, realm, clock, destination, capability and kill checks pass.
- `DELIVERED` records the verified permit durably enough to survive process restart; it contains no raw diagnostic data.
- `ARMED` is reached only after not-before time and a local canary/scanner self-test.
- `ACTIVE_D1` and `ACTIVE_D2` use one immutable permit revision. A policy, release, ceiling, destination key, clock-confidence or target-binding change cancels active work unless explicitly proved compatible and still narrowing.
- Expiry is enforced by an independent monotonic-duration watchdog and trusted UTC policy. Clock uncertainty stops enhanced diagnostics rather than extending it.
- Revocation and every kill switch stop new records immediately, cancel bundle collection/encryption/upload where safe, and enter cleanup.
- The endpoint cannot renew or extend a permit. Rollback/recovery is a higher revision, not a lower revision or edited expiry.
- `CLEANUP_FAILED` is a safe-disabled state and cannot be bypassed by a new permit.

**ESTIMATE.** A prototype watchdog checks at least every 60 seconds and before every entry/record/export. The maximum revocation-to-stop objective is one watchdog interval. Production value is measured and approved; expiry is also checked at each sensitive operation so the interval is not the only control.

## 6.3 Permit verification order

```text
1. strict parse and schema limits
2. canonical bytes/content digest
3. signature profile and key-purpose allowlist
4. issuer/audience/product/release binding
5. authenticated realm and target binding
6. monotonic revision, nonce, activation count and replay state
7. product ceiling and tenant-policy subset proof
8. purpose, ticket class, level, recipe/signal allowlist and destination
9. approved consent/notice mode and any required purpose/target/permit-bound acknowledgement receipt
10. not-before, expiry, clock confidence and maximum duration
11. byte/event/entry/cardinality budgets
12. current global/realm/target/component/local/backend kill state
13. runtime capability and scanner positive-control self-test
14. durable permit-state transition
```

Any structural/signature/key/realm/target/rollback/broadening/chain/canary failure enters `SafetyHold`. A merely unsupported future contract candidate is quarantined and does not replace a valid active D0 configuration; it grants no new diagnostic authority.

## 6.4 Endpoint diagnostic journal lifecycle

```text
EMPTY
  -> HEALTHY
      -> NEAR_LIMIT
          -> DEGRADED_AGGREGATION
          -> HEALTHY
      -> FULL_OR_CORRUPT
          -> SAFE_MINIMUM_ONLY
          -> REINITIALIZED_AFTER_EVIDENCE

Any state -> PRIVACY_HOLD on forbidden-field/canary/integrity failure
```

Rules:

- D0 finite counters and critical state are retained preferentially; low-severity duplicate events may be aggregated by catalogue key.
- Under pressure, the journal may drop oldest low-severity diagnostic records only under a declared policy and must increment a finite `diagnostics_degraded` counter. It never silently drops unacknowledged business events or changes source progress.
- Critical privacy/realm/durability/security events are retained within a separately bounded emergency ring if safe; if that ring cannot persist, a protected local finite status is raised and diagnostics stop. No raw emergency dump is created.
- Journal corruption may be reinitialized only after recording a value-free local recovery fact and preserving business-store independence. A diagnostic-store repair must not run SQL against the business outbox.
- Exact journal size, retention and drop policy are **ESTIMATE/HUMAN DECISION**.

## 6.5 Transaction boundaries

### 6.5.1 Business transaction separation

```text
BEGIN business transaction
  write minimized event/no-event/progress/outbox state
  update cursor/checkpoint atomically
COMMIT
ACK business work

then, independently:
  enqueue safe diagnostic outcome best-effort within diagnostics budget
```

A diagnostic write failure cannot roll back, delay, or cause retry of an already committed business transaction. Conversely, a diagnostic success cannot prove the business commit occurred; the event contract includes a finite committed/not-committed source state supplied by the business component after its transaction result.

### 6.5.2 Diagnostic event append

The Coordinator validates schema/catalogue/permit/rate before one short local diagnostics transaction. Duplicate stable diagnostic event IDs are idempotent. Aggregation counters and append records may commit together within the diagnostic store. No cursor, outbox, source checkpoint, receipt, policy activation, or audit mutation participates.

### 6.5.3 Bundle snapshot

1. acquire a short diagnostics snapshot lease bound to permit and recipe;
2. freeze safe projections at `snapshotAtUtc` and immutable version/digest inputs;
3. read only diagnostic tables/views and release/file manifest status APIs; never read source or business payload columns;
4. build entries in memory and compute canonical digests;
5. validate schema, limits and forbidden-key rules;
6. run exact canary/encoding scan and positive-control check;
7. encrypt to one product-owned temporary artifact or stream;
8. transactionally record bundle ID, ciphertext digest, state and expiry in the diagnostic store;
9. release snapshot lease and zero/dispose plaintext buffers where APIs permit;
10. upload/retry identical ciphertext; record custody receipt independently;
11. delete local ciphertext on durable custody or local expiry and record cleanup.

A crash before step 8 produces no uploadable bundle and cleanup removes any authenticated temporary artifact. A crash after step 8 retries the same ciphertext and ID. A new snapshot requires a remaining activation count and explicit state transition.

### 6.5.4 Backend custody and access

Backend state:

```text
UPLOAD_AUTHORIZED
  -> CIPHERTEXT_RECEIVED
  -> DURABLY_STORED              receipt may be issued here
  -> DECRYPTION_PENDING
      -> SCAN_FAILED -> QUARANTINED -> DELETED/INCIDENT_HOLD
      -> SCAN_PASSED
          -> SUPPORT_AVAILABLE
              -> ACCESSED_CASE_SCOPED
              -> EXPIRED
          -> DELETION_PENDING
              -> DELETED_PRIMARY
              -> DELETED_BACKUP_OR_EXPIRED_BACKUP
              -> DELETION_EVIDENCE_COMPLETE
```

The portal never describes `DURABLY_STORED` as “support reviewed.” Access and deletion are privileged audited mutations. Operational logs cannot substitute for their audit records.

## 6.6 Collector configuration lifecycle

```text
DRAFT
  -> STATIC_VALIDATED
  -> GENERATED_ALLOWLIST_MATCHED
  -> CANARY_TESTED
  -> LOAD_TESTED
  -> SIGNED_OR_RELEASE_AUTHORIZED
  -> DEPLOYED_SHADOW
  -> DEPLOYED_CANARY
  -> DEPLOYED_BROAD
  -> CURRENT
  -> REVOKED/ROLLED_BACK_HIGHER_REVISION
```

Unknown component, receiver, processor, exporter, attribute, scope, signal or destination fails validation. Promotion moves the same config/binary digest. Rollback republishes an approved configuration at a higher sequence; it does not restore an unsigned lower revision.

## 6.7 Rollout

1. catalogue/schema consumers and backend indexes deploy first;
2. Collector understands old and candidate event/instrument/span versions, with strict allowlists;
3. server/portal producers deploy in shadow/export-disabled mode and compare expected counts/cardinality/canaries;
4. endpoint contract support deploys with D1/D2 disabled;
5. synthetic canary realm and ring enable D0 export;
6. D1/D2 permit prototype runs on T1 targets only;
7. expand only after zero forbidden values, zero cross-realm access, zero overflow, bounded cost and runbook drills;
8. retire old version only after producer inventory, offline window, rollback, support and deletion evidence.

There is no tenant-first rollout of a field the installed release does not represent. A portal cannot activate diagnostics on an endpoint whose release/contract/recipe digest does not match.

## 6.8 Compatibility

- Event/error codes are append-only within a major version; meaning cannot change.
- New optional fields are not silently tolerated in closed records. A new minor consumer must deploy before the producer and the exact compatibility matrix must pass.
- Metric and span names/labels are versioned catalogue entries. Adding a label is a cardinality/privacy compatibility change, not a harmless minor edit.
- Removing/renaming a label, bucket, enum or state requires a migration and dashboard/alert compatibility test.
- A fingerprint algorithm change increments `fingerprintVersion`; old and new groups coexist for a bounded approved period.
- Bundle recipe/manifest/encryption/permit versions have independent compatibility windows.
- Exact “current plus previous” windows are not globally accepted. Each contract family needs fleet/offline/support evidence and a named owner.
- A frozen, stale, expired, lower-revision, unsupported, or mismatched diagnostic artifact never activates.

## 6.9 Cleanup rules

Cleanup is a first-class state with evidence:

- close leases, handles, streams and collector sessions;
- cancel timers/samplers/exporters and clear active permit state;
- remove product-owned temporary ciphertext by manifest identity, never broad directory deletion;
- verify no plaintext file, dump, trace file, archive extraction, process, task, firewall rule, certificate/private key, diagnostic port or temporary config remains;
- record ciphertext custody/deletion state, not content;
- invalidate one-time upload tokens and permit activation nonce;
- preserve audit records according to human-approved retention;
- keep capability disabled on cleanup uncertainty.

---

# 7. Security/privacy threat and failure register

## 7.1 Register

| ID | Trigger / threat | Detection | Containment | Recovery | Cleanup | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T13-01 | raw URL, host, path, identity, secret or source value passed to logging API | analyzer, schema guard, exact canary in every sink | build/release block; runtime record rejection; privacy kill | remove field/API, add adjacent canaries, rerun all sinks | delete/quarantine contaminated artefacts under incident authority | Privacy Engineering + AppSec | E13-02 | unknown encodings/sinks may evade finite scanners |
| T13-02 | exception message/stack/inner data leaks through generic logger | forbidden API analyzer, hostile exception corpus, sink scan | reject event; map to `EX_UNKNOWN`; disable affected event family | fix mapper/wrapper; dependency-specific safe adapter | purge contaminated records/bundles where authorized | Runtime Engineering + Privacy | E13-03 | runtime/vendor may log outside wrapper |
| T13-03 | HTTP auto-instrumentation emits URL/path/query/header/address | attribute allowlist diff, canaries, Collector rejection | disable instrumentation/export; route-template-only fallback | pin/fix instrumentation profile and retest patch | delete rejected/quarantined telemetry | Web Platform + Observability | E13-06 | framework updates may introduce new attributes |
| T13-04 | dynamic metric label causes series explosion or covert identity channel | theoretical catalogue calculation, runtime cardinality probe, `otel.metric.overflow` | stop instrument/export; D0 finite alarm; preserve product work | remove/coarsen label; update dashboards/budgets | expire unusable high-cardinality series per backend policy | Observability/SRE + Privacy | E13-04 | backend/resource attributes may bypass SDK assumptions |
| T13-05 | realm/device/user/source used as metric label or trace attribute | compile-time forbidden-key list, backend schema lint, realm-negative query | reject batch; disable producer/config | remove attribute and invalidate dashboards/indexes | delete/age out contaminated index under approved process | IAM + Observability + Privacy | E13-04/E13-13 | rare combinations can still correlate targets |
| T13-06 | baggage or untrusted trace context carries identity/commands | ingress propagation tests, header canaries, trace scan | drop baggage/tracestate; start new internal trace | fix propagator config/library profile | remove contaminated spans | Platform Security | E13-05 | third-party proxies may retain headers outside UAM |
| T13-07 | Collector filter/transform error silently ignored | config lint asserts explicit mode; fault injection; rejected-item counters | fail config activation or quarantine signal; keep prior valid config | higher-revision corrected config and canary test | remove rejected queue data | Observability Platform + Security | E13-08 | component default/behavior can change by release |
| T13-08 | Collector or exporter unavailable | self-health, queue age/depth, export failure counters | bounded queue/retry; diagnostics degrade; business path continues | recover dependency or switch approved destination through ADR | delete expired safe queue data | SRE/Observability Platform | E13-09 | telemetry gaps remain; no retroactive truth |
| T13-09 | endpoint diagnostic journal full/corrupt | finite pressure/integrity state and local self-check | aggregate/drop declared low-severity data; safe-minimum mode; never touch business store | reinitialize diagnostics store after evidence | remove only product-owned corrupt store; retain recovery fact | Endpoint Operations | E13-09 | useful detail may be lost during the incident |
| T13-10 | diagnostics blocks event/cursor/outbox transaction | timing/failpoint test and architecture guard | circuit-break diagnostic append; commit business transaction | repair diagnostic subsystem independently | clear diagnostic queue only | Endpoint Storage + Diagnostics | E13-09 | timing effects may still consume CPU/disk budget |
| T13-11 | automatic dump/diagnostic port/profiler enabled | startup/config health check, registry/env inventory, process inspection in lab | SafetyHold enhanced diagnostics; disable source/capability where possible | remove unauthorized configuration through governed endpoint management | delete T1 artefacts; production artefact handling by incident authority | Endpoint Security | E13-07 | EDR/hypervisor captures may be invisible to UAM |
| T13-12 | crash loop floods logs or creates raw vendor crash artefact | restart bucket, file/process residue scan, EDR/WER configuration check | source/component kill, rate limit, no dump, safe crash summary | rollback/fix release and rerun lifecycle | remove product-owned residue; verify no dump | Release + Endpoint Operations | E13-07/E13-16 | crash root cause may remain hard without raw memory |
| T13-13 | fingerprint includes sensitive/high-cardinality input | algorithm source review, mutation tests, preimage/corpus analysis | reject fingerprint version and related export | regenerate from release-owned tuple at new version | expire/delete unsafe groups | Security Engineering + Privacy | E13-03 | finite fingerprint may still distinguish rare defects |
| T13-14 | fingerprint collision merges unrelated defects | synthetic collision/grouping challenge and support misdiagnosis test | show code/build/stage alongside fingerprint; never authorize by fingerprint | version algorithm or add safe finite tuple element | no content cleanup unless privacy affected | Diagnostics Engineering | E13-14 | cryptographic collision is remote, semantic collision remains possible |
| T13-15 | support bundle collector reads file/registry/command unexpectedly | architecture/API guard, recipe diff, filesystem/registry/process trace | abort, privacy kill, no encryption/upload | remove collector capability; rerun deterministic recipe | delete in-memory/ciphertext artefact and verify no plaintext | Endpoint Security + Privacy | E13-10/E13-11 | OS dependencies may read hidden files unless narrowly wrapped |
| T13-16 | plaintext bundle or extraction residue reaches disk | filesystem trace, canary, before/after manifest | abort, delete product-owned artefact, SafetyHold | use direct streaming/in-memory implementation | verify no file/USN/search-index/backup-visible product artefact where measurable | Bundle Engineering + Endpoint Security | E13-11 | storage/filter/backup internals cannot be fully proved by UAM |
| T13-17 | archive traversal, duplicate name, decompression bomb or executable entry | hostile archive corpus and bounded parser | reject before extraction/decryption use; quarantine ciphertext | fix parser/profile and rotate recipe version | delete quarantined artefact after evidence policy | Support Platform Security | E13-11 | parser/library defects remain |
| T13-18 | permit forged, wrong key purpose, wrong realm/target, replayed or downgraded | signature/realm/target/revision/nonce vectors and audit | `SafetyHold`; global/realm/target kill; no activation | key/revision recovery with higher authorized artifact | invalidate nonce/token and remove pending data | Signing Authority + IAM + Security | E13-12/E13-13 | key compromise can authorize malicious but syntactically valid permits |
| T13-19 | expiry/clock rollback/restart extends diagnostics | monotonic watchdog, trusted UTC confidence, restart state tests | stop enhanced diagnostics; cleanup; no offline grace by default | restore clock confidence and issue new permit | delete pending enhanced records/ciphertext | Security + Endpoint Operations | E13-12 | trusted time can be unavailable offline |
| T13-20 | revocation/kill not applied promptly | control-plane/endpoint timeline and active-event counter | local kill, cancel work, disable upload | repair propagation; new permit only after runbook | discard post-revocation enhanced data | Diagnostic Access Authority + Operations | E13-12 | disconnected endpoint sees revocation only when channel returns; expiry is fallback |
| T13-21 | permit widens product/tenant ceiling | formal meet/property tests and counterexample generator | reject and `SafetyHold` | correct permit/policy; higher revision | delete unauthorized candidate | Privacy Policy Authority | E13-12 | signer can still approve a mistaken broad product ceiling |
| T13-22 | bundle uploaded to wrong target/realm/destination | authenticated target binding, one-time token, server negative tests | reject custody; quarantine ciphertext; realm kill | issue corrected permit/token; do not rebind existing bundle | delete wrong-context ciphertext and record audit | IAM + Support Platform | E13-13 | compromised registration authority remains upstream risk |
| T13-23 | backend support operator browses bulk/cross-realm bundles | mandatory realm/case auth, audit, honey-token/negative tests | revoke session/role; lock affected cases; security incident | IAM correction, access review, reauthorization | delete unauthorized local downloads; preserve audit | Support IAM + Product Security | E13-13/E13-15 | screenshots/manual copies outside platform remain human risk |
| T13-24 | backend compromise exposes encrypted/plaintext bundles | security monitoring, key/access audit, canaries | disable destination/upload/decryption, revoke keys/tokens | rebuild/restore trusted backend, rotate keys, reassess affected bundles | verified deletion/crypto-shred where supported | Security Incident Lead + Platform Owner | E13-16 | previously decrypted operator copies may persist |
| T13-25 | canary scanner misses split/encoded/compressed value | mandatory positive controls for every encoding/sink/version, mutation corpus | block release/bundle and treat as privacy incident candidate | expand scanner/neighboring corpus; rerun all sinks | quarantine/delete artefacts | Privacy Engineering + AppSec | E13-02 | no finite scanner proves universal absence |
| T13-26 | scanner report itself leaks canary/secret | report schema/canary scan and manual review | suppress value, retain only marker ID class/count | fix reporter | delete unsafe reports | AppSec | E13-02 | external scanner tooling may create its own logs |
| T13-27 | bundle limit silently truncates critical evidence | manifest completeness and recipe assertions | fail bundle as a whole; emit finite status | revise recipe/budget through measured ADR | delete incomplete artefact | Product Support Engineering | E13-10/E13-11 | support remains blind until a safe smaller recipe exists |
| T13-28 | support staff request raw URL/path/dump to solve case | case workflow lint, training, audit, mock support exercise | refuse/close upload path; synthetic reproduction escalation | improve safe signal or reproduce T1; update runbook | delete unauthorized attachment if received | Support Leadership + Privacy | E13-14/E13-16 | users may send raw data through channels outside UAM |
| T13-29 | diagnostic flag becomes arbitrary code/config channel | schema/architecture tests and hostile permit recipes | reject candidate; signing/policy `SafetyHold` | remove general expression/runner and republish | delete unauthorized config | Product Security + Release | E13-12 | future maintainers may reintroduce convenience escape hatches |
| T13-30 | diagnostics/audit/custody states are conflated | contract/state tests and portal wording/accessibility tests | block release; show explicit states | correct UI/API and data model | no content cleanup; correct misleading record if governed | Architecture + Product + Accessibility | E13-14 | operators may still misinterpret fallible telemetry |
| T13-31 | deletion removes primary copy but backup/search/cache remains | deletion job state, backup expiry evidence, index/cache scans | block “deleted” final state; restrict access | complete deletion/expiry/crypto-shred according to approved policy | issue deletion evidence record | Records Management + Platform Reliability | E13-15 | immutable backup/legal hold may delay deletion by human decision |
| T13-32 | incident evidence is overwritten by routine retention/aggregation | critical finite event ring and audit linkage | freeze approved metadata under incident authority; no raw expansion | export value-free incident evidence to approved store | expire after incident retention decision | Incident Lead + Records Management | E13-16 | preserving more metadata increases correlation risk |
| T13-33 | inaccessible or misleading portal error/status | automated accessibility tests, screen-reader/keyboard/manual review | prevent UI release; provide safe API code | fix message/focus/status semantics | not applicable | Portal + Accessibility Owner | E13-14 | localization quality still needs human testing |
| T13-34 | observability cost/volume exceeds budget | per-signal usage/cost forecast and load test | reduce sampling/retention or disable nonessential signal; preserve safety metrics | catalogue/ADR change with support-impact review | expire excess safe telemetry | Product/SRE/Finance | E13-17 | lower telemetry can increase time to diagnose |
| T13-35 | unsupported version silently drops new fields/events | compatibility matrix, unknown-event rejection counters | stop producer ring or quarantine signal | deploy consumer first or rollback higher revision | delete/quarantine incompatible records | Release Compatibility | E13-08/E13-18 | long-offline endpoints extend support window pressure |
| T13-36 | missing Batch 02 cross-review causes semantic mismatch | batch-review comparison of explicitly authorized predecessor | hold acceptance of affected contracts | reconcile through explicit ADR/change proposal | not applicable | Batch Reviewer/Architecture | reviewer gate | mismatch may be discovered late because file was not authorized here |
| T13-37 | required consent/notice acknowledgement is absent, forged, replayed, expired, or bound to another purpose/target/permit | receipt signature/digest, nonce, target and state-machine tests; access audit | reject authorization, stop D1/D2, enter `SafetyHold` on integrity failure | issue a fresh request/permit under the approved interaction policy; investigate forged or reused receipts | delete pending enhanced records/ciphertext and invalidate receipt nonce | Data Controller/Product Owner + Privacy/IAM | E13-12 | a technical receipt proves only the configured interaction, not legal validity or free choice |

## 7.2 Defined diagnosable failure set

The primary gate requires support to correctly identify and route at least these failures without raw values:

1. policy/ceiling/permit absent, unsupported, invalid, expired, revoked, downgraded or wrong target;
2. authentication, authorization, realm-guard, proxy, TLS and destination-key outcome classes;
3. clock unavailable/uncertain/outside permit window;
4. endpoint diagnostic journal pressure/corruption and product business-store health class without rows or paths;
5. SQLite/storage busy, integrity, migration and disk-pressure classes without database copies or SQL;
6. outbox/backlog/age and retry state without event, batch or receipt IDs;
7. durable custody versus validation, quarantine, materialization, integration and portal visibility;
8. contract/build/config/runtime incompatibility;
9. process crash loop and safe fingerprint/build/stage grouping;
10. portal authentication/authorization denial and safe route-template status;
11. Collector overload, queue/exporter outage and signal rejection;
12. metric cardinality overflow or unexpected attribute;
13. canary/forbidden-field failure and resulting `SafetyHold`;
14. bundle generation, encryption, upload, custody, access, expiry and deletion lifecycle;
15. diagnostic permit expiry/revocation/cleanup failure.

A data-specific semantic complaint that cannot be explained from these states must be reproduced with a deterministic T1 fixture. It does not authorize collection of the real value.

## 7.3 Runbook and ownership catalogue — mandatory artifact

Role names are functions, not assigned people or approved staffing.

| Runbook ID | Trigger | L1 responsibility | L2 responsibility | L3/security/privacy responsibility | Re-enable evidence |
|---|---|---|---|---|---|
| RB13-01 `METRIC_OVERFLOW` | overflow point or budget breach | record safe code and case | disable instrument/dashboard dependence; preserve series counts | fix catalogue/labels and rerun cardinality/canary tests | zero overflow under hostile load and approved budget |
| RB13-02 `EXPORT_OUTAGE` | endpoint/server export queue age/failed sends | communicate diagnostics degraded, not product-data loss | recover backend/network; watch bounded queue | engineering if retry/drop semantics wrong | queue drains within approved bounds; no business-path impact |
| RB13-03 `ENDPOINT_DIAG_PRESSURE` | journal near/full/corrupt | route device-safe status | enter safe-minimum mode; verify business store unaffected | repair/reinitialize diagnostics store | integrity pass, cleanup receipt, no cursor/outbox change |
| RB13-04 `COLLECTOR_OVERLOAD` | memory/queue/rejection alarm | route platform incident | scale/recover approved gateway; block producer rollout | security reviews rejected payload/processor behavior | load/canary test and config digest approved |
| RB13-05 `CANARY_OR_REDACTION_FAILURE` | one forbidden marker/field escape or scanner miss | stop requesting bundles; do not copy evidence | global/realm/ring diagnostic kill; quarantine | Privacy/Security incident, sink inventory, code/config repair | all-sink positive controls and zero escapes; deletion/containment evidence |
| RB13-06 `BUNDLE_LIMIT_OR_BUILD_FAILURE` | deterministic recipe cannot complete | explain bundle unavailable using safe code | retry only after transient safe state; no ad-hoc collection | adjust recipe/budget through ADR or fix defect | deterministic complete bundle within bounds |
| RB13-07 `BUNDLE_UPLOAD_CUSTODY_MISMATCH` | client/server ciphertext/receipt disagreement | do not claim support has bundle | stop retries if integrity uncertain; preserve ciphertext digest/state | storage/reliability investigates custody contract | stable retry returns same custody result; no duplicate exposure |
| RB13-08 `BUNDLE_ACCESS_OR_DELETION` | unauthorized access, expiry miss or deletion incomplete | do not download/share | revoke access, lock case, start deletion workflow | IAM/Security/Records incident and evidence | access review complete; all required deletion states evidenced |
| RB13-09 `PERMIT_EXPIRY_OR_REVOCATION_FAILURE` | D1/D2 active beyond authority | route critical safe code | target/realm/global kill; disconnect upload | signing/IAM/runtime fix and state-machine replay test | stop latency within approved bound; cleanup complete |
| RB13-10 `WRONG_REALM_OR_TARGET` | binding mismatch or cross-realm attempt | reveal no target detail | reject/lock operation and audit | Product Security/IAM investigate | realm-negative suite, cache/index/query review pass |
| RB13-11 `CRASH_LOOP_OR_DUMP_DETECTED` | repeated process exit or dump config/file | report product degraded, no dump upload | kill affected capability; inspect safe inventory | Release/Endpoint Security fix or rollback; privacy incident if dump existed | lifecycle test, no dump/residue, stable restart |
| RB13-12 `BACKEND_COMPROMISE` | support backend/key/access integrity uncertain | stop bundle requests | disable destination/decryption/upload; revoke sessions/tokens | Security Incident Lead, key rotation, rebuild, impact assessment | trusted rebuild, key/access audit, canary and deletion status |
| RB13-13 `SCHEMA_OR_VERSION_MISMATCH` | unknown event/attribute/recipe/permit | route compatibility code | stop producer ring or use prior supported path | deploy consumer first; update matrix | old/new matrix and rollback tests pass |
| RB13-14 `DATA_QUALITY_STATE` | quarantine/missing/stale/contradictory status | explain telemetry is fallible and state-specific | identify finite state and owner; no raw query | owning Data/Engineering team uses T1 reproducer | typed state transition fixed; no silent reinterpretation |
| RB13-15 `CLOCK_UNCERTAIN` | trusted time unavailable/rollback | explain enhanced diagnostics unavailable | stop D1/D2; restore managed time | Security/Endpoint Operations validate policy | clock confidence and expiry tests pass; new permit issued |
| RB13-16 `SUPPORT_WITHOUT_RAW_DATA` | defined failure unresolved | collect safe code/manifest only | run approved D0/D2 recipe | L3 builds T1 reproduction; privacy owner reviews missing safe signal | case resolved or support promise narrowed through ADR; no raw artefact |

Ownership routing:

| Tier/function | Permitted access and action | Prohibited action |
|---|---|---|
| L1 Service Desk | user-safe code, case reference, documented status, runbook selection | request URL/path/dump/DB/log archive; access decrypted bundle by default |
| L2 Product Operations/SRE | realm/case-scoped safe dashboards, approved D2 bundle projections, kill/retry/runbook actions | bulk cross-realm search, ad-hoc query for identities, change catalogue/permit authority |
| L3 Engineering | source/build/config versions, safe fingerprints, T1 reproduction, code/config fixes | direct production raw source access through diagnostics; silently add a field |
| Product Security | realm/integrity incident containment, kill, key/access review | approve legal purpose/retention alone |
| Privacy Incident Lead | forbidden-data containment, affected sinks, deletion/notification coordination | operate arbitrary forensic tooling through UAM diagnostics |
| IAM/Realm Owner | realm/target/case authorization, role review, revocation | view bundle content without case purpose/role |
| Endpoint Platform Owner | process/config/dump/cleanup controls and enterprise compatibility | ask Coordinator to crawl profiles or elevate diagnostic capability |
| Observability Platform Owner | Collector/backend/config/load/cost/retention implementation | redefine product privacy ceiling or use backend defaults as authority |
| Release/Signing Authority | binary/config/permit signing profile, revocation and rollback | inspect support content by virtue of signing role |
| Records Management | retention/deletion/legal-hold policy and evidence | expand collected content |

Support roles, named teams, staffing, hours and on-call coverage remain **HUMAN DECISION**.

---
# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test-data and evidence rules

Every test uses T1 fictional inputs unless a later approved measurement plan explicitly authorizes a more sensitive tier. Tests MUST NOT use production activity, organization-derived URLs, real user/device/realm identifiers, internal addresses, credentials, certificates, support tickets, or production backend data.

Each run emits an immutable evidence envelope containing:

- experiment/test ID and one falsifiable claim;
- source tree, catalogue, schemas, configuration, permit/recipe and release digests;
- exact SDK/runtime/package/Collector/backend emulator versions and hashes;
- runner/VM/container image and environment class;
- T1 fixture/canary package root and independent expected result;
- start/end UTC, test seed, command identity, exit code, first failure, and retry linkage;
- actual event/instrument/span/series/bytes/state distributions;
- positive-control result, all-sink scan, forbidden-key scan and zero-escape count;
- resource and cost measurements;
- cleanup/deletion receipt;
- owner/reviewer functions and exceptions with expiry.

A rerun never overwrites the first failure. Raw ETL/PCAP/process/file traces from a T1 disposable lab remain in restricted test storage; shareable evidence contains normalized operation categories/counts and digests.

## 8.2 Redaction/canary test design — mandatory artifact

### 8.2.1 Canary classes

The deterministic T1 canary package creates exact markers for:

- URL scheme, host, port, path, query, fragment, title and userinfo;
- Windows local path, UNC-like path, alternate data stream and registry-like string;
- fictional username, SID-shaped value, email, person ID, session/source/application/device/realm-shaped ID;
- reserved IPv4/IPv6 address, MAC/serial-shaped value and internal-host-shaped value;
- fictional credential, bearer token, API key, private-key header, cookie, authorization header and certificate subject;
- SQL statement, table/column name, command line and environment-variable-shaped secret;
- exception message, inner exception, stack/file/line text and dependency response body;
- Unicode, confusable, control, line-separator and non-ASCII variants;
- known disallowed derivatives, including hashes/HMAC-like representations generated only inside the T1 oracle.

Markers are planted independently in every success, retry, reject, cancellation, timeout, exception, crash, pressure, permit, realm-denial, bundle-limit, encryption, upload, access and deletion path.

### 8.2.2 Encodings and transformations

The scanner exercises exact and split representations in:

```text
UTF-8, UTF-16LE/BE, JSON escaping, XML/HTML escaping, URL encoding,
base64/base64url, hexadecimal, case changes, Unicode normalization variants,
line wrapping, prefix/suffix concatenation, structured fields, gzip/deflate,
ZIP entry bytes, OTLP protobuf bytes, and backend/index serialization
```

The scanner may decode only declared formats with strict size/depth/ratio limits. A decompression or parser failure is a failed scan, not “not found.” Exact markers and known deterministic derivatives are primary; heuristic secret/PII tools are secondary challengers.

### 8.2.3 Sink matrix

Every mandatory marker is positively controlled in at least one approved test-only sink and absent from every forbidden sink:

| Layer | Sinks inspected |
|---|---|
| Source/process | managed/native buffers where test hooks permit, stdout/stderr, console, debug output, Windows event log/provider output, crash/dump directories, diagnostic port/profiler artefacts |
| Local IPC/storage | both IPC captures, shared memory/pipe test capture, diagnostic SQLite/main/WAL/SHM, business SQLite/main/WAL/SHM negative check, temp/scratch/search-index-visible product files |
| Application telemetry | structured log records, metric points/exemplars, span/events/links/resources, HTTP access logs, exporter batches, retry queues |
| Collector | receiver capture, processors, rejected data, internal logs, persistent queue if enabled, exporter payload |
| Network/backend | TLS test endpoint after controlled termination, object/blob metadata, indexes, dashboards, alerts, query exports, caches, backups in emulator |
| Support | bundle object model, canonical plaintext before encryption, ciphertext metadata, controlled decrypted bundle, support portal DOM/API, download/export, access/deletion evidence |
| CI/evidence | test results, snapshots, coverage, fuzz corpus, screenshots, failure attachments, SBOM/provenance, evidence envelopes and scanner reports |

A scanner update cannot be accepted until every mandatory positive control is detected. One miss or one forbidden escape is a release-blocking privacy incident candidate.

## 8.3 Detailed matrix

Durations are **ESTIMATE** wall-clock targets for one clean run and exclude human review.

| ID | Setup | Instrumentation | Steps | Pass | Fail/stop | Evidence | Est. duration | Cleanup |
|---|---|---|---|---|---|---|---|---|
| T13-01 Catalogue/analyzer mutations | buildable T1 solution; generated catalogue | compiler diagnostics, architecture graph, source scan | inject one ad-hoc template, interpolation, exception, object, dynamic instrument/span, forbidden field and suppression; revert each | every mutation fails build with stable rule; clean tree passes | any bypass, broad suppression or nondeterministic generation | mutation matrix, generated API/schema digests, clean-tree proof | 20 min | revert mutations; verify no generated residue |
| T13-02 All-sink canary containment | full synthetic endpoint→server→Collector→backend chain | canary scanner, IPC/network captures, SQLite/file diff, backend emulator | seed every class/encoding through all success/failure/crash paths; run positive controls first | positive controls all detected; zero marker/derivative in forbidden sinks | one miss, one escape, undecodable/unchecked sink or external egress | marker/sink/encoding matrix, scanner/config digests, redacted report | 60 min | delete/revert all test stores/queues/bundles/captures |
| T13-03 Exception and fingerprint corpus | mapped and hostile fictional exceptions, dependency adapters, signed build map | event capture, allocation/time, grouping oracle | throw nested/large/cyclic/data-rich exceptions at each boundary; mutate mapper; compare fingerprints | no text/stack/path leaves mapper; stable expected groups; unknown maps safe; bounded resources | raw leak, attacker-controlled group, unstable mapping or mapper recursion | exception class matrix, fingerprints, minimal counterexamples | 30 min | clear test artefacts; scan outputs |
| T13-04 Cardinality and overflow | generated finite and hostile label streams for every metric | SDK View limits, process memory, point/series export, overflow counter | emit all legal combinations; then millions of unique prohibited strings through hostile adapters | theoretical maxima match catalogue; actual <= per-instrument/process budget; hostile values rejected; no normal overflow | overflow, memory growth beyond bound, dynamic label accepted, resource attr leak | per-instrument combinations, peak memory/CPU, overflow points | 45 min | dispose providers; clear backend series namespace |
| T13-05 Trace propagation/sampling | synthetic multi-service graph and malicious headers | span exporter, header capture, sample decision oracle | valid/invalid/oversized/duplicate traceparent, baggage/tracestate canaries, retries and async hops | tracecontext only; baggage absent; untrusted context cannot influence auth/realm/sampling; static spans/allowlist only | any baggage/identity propagation, dynamic name, missing bound or unauthorized sample control | header/span matrix and sample distribution | 30 min | clear traces and emulator stores |
| T13-06 Safe HTTP logging | synthetic server/portal with hostile URLs, headers, bodies, route values | all application/framework logs, spans, metrics and Collector capture | exercise each route and failure with generic logging toggles/mutations | only route-template/method/status/latency/auth outcome; zero raw request attributes | path/query/header/body/address/user value in any signal | route-by-signal matrix and canary result | 30 min | remove test logs/indexes |
| T13-07 Crash/dump controls | disposable Windows VM, T1 processes, managed endpoint config | WER/.NET env/registry inventory, file/process trace, restart monitor | crash each process role, enable forbidden dump config in negative test, attempt diagnostic-port attach | production profile creates no dump/trace; detects forbidden config; finite crash summary; loop kill works | dump/process memory artefact, attach success, raw exception or uncontrolled restart | sanitized config classes, file operation counts, crash states | 45 min | delete test dumps, remove config, revert VM |
| T13-08 Collector config and rejection | pinned minimal Collector and generated config | config validator, receiver/exporter captures, self-metrics | unknown fields/signals, transform faults, overload, version rollback, malicious resource attrs | config fails before deploy or data quarantines; explicit safe error mode; prior config remains; no payload echo in Collector logs | silent ignore/export, forbidden receiver/component, raw rejected body, default drift | binary/config/SBOM digests, rejection matrix, load state | 45 min | destroy Collector instance/queues and secrets |
| T13-09 Outage/backpressure/business independence | endpoint/server harness with fault-injected journal, network, Collector/backend | business transaction truth, queue/disk/CPU/latency, failpoints | fill/corrupt diagnostics store, cut network, slow exporter, crash between business commit/diagnostic append | business effects/cursors unchanged; diagnostic degradation explicit; bounded resources and recovery | business rollback/retry/loss caused by diagnostics, silent unbounded queue or store cross-write | transaction ledger, resource curves, store diffs | 60 min | reinitialize diagnostic store; clear safe queues |
| T13-10 Deterministic bundle | fixed T1 snapshot, permit, clock, recipe | file/API access trace, canonical diff, memory/file monitor | collect twice in different path/user/locale/time zone with same fixed inputs; mutate collector list | identical plaintext root/entries; only allowlisted reads; no plaintext file; unknown collector rejected | nondeterminism, path/user/time leakage, unlisted access, silent truncation | manifests, roots, access categories, memory/file diff | 45 min | zero/dispose buffers; remove ciphertext; revert runner |
| T13-11 Bundle limits/archive/encryption/upload | hostile sizes/names/compression, two crypto candidates, backend emulator | allocations, archive parser, ciphertext/receipt/state capture | boundary/over-limit entries, duplicates/traversal/bombs, key rotation/wrong key, retry/crash/ACK loss | limits fail closed; authenticated encryption interoperates; same ciphertext retry; custody semantics exact; no plaintext residue | traversal, expansion/alloc breach, algorithm downgrade, wrong-target decrypt, ACK-before-durable, residue | vectors, ciphertext digests, state/failpoint ledger | 90 min | delete keys/artifacts/emulator objects; verify receipts/deletion |
| T13-12 Permit lifecycle/expiry/revocation/acknowledgement | signed T1 permits, revocations and fictional acknowledgement receipts; controllable UTC/monotonic clocks | state trace, active signals, filesystem/network capture | malformed/unsupported/wrong key/realm/target/lower rev, missing/forged/replayed/wrong-purpose/wrong-target/expired acknowledgement, not-before/expiry, clock rollback, restart, offline, kill, cleanup failure | only a valid narrowing permit plus any policy-required bound acknowledgement activates; expiry/revoke stops within approved bound and before each operation; no self-renewal | one invalid activation, acknowledgement bypass, post-expiry record/upload, rollback, cleanup bypass | transition ledger, signature/receipt vectors, stop latency | 60 min | invalidate test keys/nonces/receipts, clear permit state |
| T13-13 Realm/target/access isolation | two fictional realms with colliding IDs/tickets/bundle IDs and multiple roles | DB/query/cache/index/object/audit capture | create/read/search/download/delete/revoke across every realm/target combination | zero cross-realm success or metadata leak; authenticated context wins; all privileged actions audited | one cross-realm result, payload authority, bulk search or cache collision | authorization matrix and audit ledger | 60 min | delete fictional realm stores and roles |
| T13-14 Support blind-diagnosis challenge | hidden randomized instances of defined failure set; L1/L2 only safe UI/bundles | answer scoring, access audit, time/actions, raw-request detector, accessibility tools | participants identify category/state/owner/runbook and next safe action without source values | 100% defined failures correctly classified/routed; zero raw request/access; status accessible | any wrong business claim, raw request, unresolved defined failure or inaccessible critical state | per-case truth/answers/actions and blind-spot list | 90 min | delete case/bundle data and participant exports |
| T13-15 Retention/access/deletion/backup | backend emulator with primary/index/cache/backup and expiry jobs | object inventory, key/access/deletion/audit states | expire/delete/access/revoke under normal, crash, retry, legal-hold simulation | no access after expiry except approved hold; final state only after all required layers complete; audit retained separately | “deleted” while searchable/downloadable/backup-restorable contrary to policy | lifecycle ledger and restoration negative test | 60 min | destroy emulator snapshots/keys per manifest |
| T13-16 Incident/runbook drills | injected canary, wrong realm, backend compromise, permit overrun, crash loop | timeline, decisions, kill/revoke/delete evidence | execute RB13-01–16 using T1 environment and handoffs | trigger recognized, authority correct, containment before expansion, cleanup/re-enable evidence complete | raw workaround, self-reenable, unclear owner, missing evidence or neighboring gate skipped | runbook receipts and after-action items | 2–4 h | full environment reset and access review |
| T13-17 Load/cost/skills | synthetic 6,000-endpoint-equivalent distributions with replaceable event rates | CPU/memory/disk/network/series/storage/query/cost model | steady, outage catch-up, retry storm, rare error, D1/D2 bursts and backend degradation | meets human-approved budgets/SLOs; no overflow/loss outside declared policy; operators complete tasks | count-only claim, budget breach, unbounded cost, unavailable skills/runbook | reproducible load inputs, resource/cost/ops results | 2–8 h | delete load data and infrastructure |
| T13-18 Compatibility/rollout | old/current/candidate app, catalogue, Collector, backend, permit, bundle recipe/encryption versions | matrix runner and ring state | consumer-first, producer-first negative, rollback, long-offline, unknown field/instrument and frozen config | only declared combinations work; incompatible producer blocked; same-digest promotion and higher-revision rollback | silent drop/coercion, stale activation, dashboard/alert semantic drift | executable matrix and ring timeline | 60 min | undeploy candidates, clear test state |
| T13-19 Batch 02 cross-review | explicitly authorized accepted Batch 02 review plus this result | scoped contradiction checklist | compare raw boundary, IDs, states, canaries, health and kill terms only | no material conflict or explicit change proposal accepted | unreviewed contradiction or unauthorized source use | reviewer record and ADR actions | human review | no data cleanup; evidence manifest update |

## 8.4 Smallest falsifying prototypes

### P13-01 — typed telemetry boundary

**Claim.** Release code cannot emit an unregistered or source-derived log/metric/span through the supported API.

**Setup.** One library with generated catalogue, one endpoint process, one server process, in-memory exporters, T1 marker types, and architecture/analyzer tests.

**Steps.** Implement one legal event. Then attempt: interpolated logging, arbitrary string, `Exception`, object destructuring, dynamic instrument/span name, URL attribute, realm label and direct OTel SDK access outside the wrapper.

**Pass.** Legal event emits exact expected bytes/points/spans. Every unsafe attempt fails compile/build/architecture validation. Reflection/dynamic test cannot reach a public unsafe overload.

**Fail.** One unsafe value reaches an exporter or one supported bypass exists.

**Evidence.** Generated API/schema, compiler rule IDs, mutation results and captured signals. **Duration:** 15 minutes. **Cleanup:** revert mutations and scan build/test artefacts.

### P13-02 — cardinality containment

**Claim.** A hostile producer cannot turn a UAM metric into per-user/per-URL/per-device series or unbounded memory.

**Setup.** One metric with two finite labels and declared max 12 series; hostile adapter generates one million unique strings.

**Pass.** Strings are rejected before recording; exactly 12 or fewer legal series; no overflow; memory stabilizes within the measured bound.

**Fail.** Any dynamic label appears, `otel.metric.overflow=true` occurs in the legal profile, or memory grows with unique strings.

**Evidence.** Series set, SDK View config, memory curve, rejection counts. **Duration:** 10 minutes. **Cleanup:** dispose MeterProvider and delete backend namespace.

### P13-03 — deterministic safe support bundle

**Claim.** A defined endpoint failure can produce a useful deterministic D2 bundle without reading a raw source, file, registry subtree, command output, log file or process memory.

**Setup.** Fixed T1 health/error/state store, fixed permit/clock/recipe, file/registry/process/network tracing and canaries.

**Pass.** Two runs produce identical plaintext roots; all entries are allowlisted; support identifies the hidden failure; no plaintext file or forbidden marker exists; encrypted artifact is within bounds.

**Fail.** Bundle differs for path/user/locale reasons, reads an unlisted object, leaks a marker, silently truncates, or cannot diagnose the defined failure.

**Evidence.** Manifests, roots, access categories, scan and support answer. **Duration:** 20 minutes. **Cleanup:** delete ciphertext, dispose buffers, revert VM.

### P13-04 — expiry and revocation

**Claim.** D1/D2 cannot remain active after permit expiry, revocation, target/realm mismatch, restart or clock uncertainty.

**Setup.** Controllable clocks and one signed T1 permit, one higher-revision revocation, event/bundle monitor.

**Pass.** Only valid target activates; each sensitive operation checks authority; expiry/revoke stops within approved bound; restart does not extend; cleanup completes; no post-authority export.

**Fail.** One enhanced record, bundle entry or upload occurs outside authority, or a lower revision reactivates.

**Evidence.** State and signal timeline. **Duration:** 20 minutes. **Cleanup:** invalidate nonce/key and clear test state.

### P13-05 — realm-isolated support

**Claim.** A support actor in fictional Realm A cannot discover, access, download, revoke or delete Realm B’s diagnostic metadata or bundle even when IDs collide.

**Setup.** Two realms, colliding external references and bundle IDs, realm-scoped roles, caches/indexes/backend emulator.

**Pass.** All cross-realm attempts are denied without target metadata; same-realm permitted action succeeds and is audited.

**Fail.** Any metadata/content/state leaks or payload realm controls authorization.

**Evidence.** Authorization matrix and audit facts. **Duration:** 20 minutes. **Cleanup:** remove roles, cases, bundles and caches.

### P13-06 — crash without dump

**Claim.** An unexpected Task Host/Coordinator crash yields only a finite safe summary and no production dump or diagnostic-port artefact.

**Setup.** Disposable Windows VM with release-like config and T1 process; file/config/process tracing.

**Pass.** No dump/trace file, no raw exception, finite summary, bounded restart and capability kill; forbidden WER/dump configuration is detected in the negative variant.

**Fail.** Process memory artefact, attach path, raw error or uncontrolled loop appears.

**Evidence.** sanitized configuration classes, file-operation count and lifecycle. **Duration:** 20 minutes. **Cleanup:** remove negative test config/dumps and revert VM.

### P13-07 — primary supportability gate

**Claim.** L1/L2 can diagnose every defined failure class using only safe event codes, state transitions, finite metrics and one approved D2 bundle.

**Setup.** Randomized hidden fault injector and independent truth oracle. Participants cannot inspect source fixtures or debug stores.

**Pass.** Every case is correctly classified, assigned to the right owner/runbook, and given the right safe next action; no raw request is made; custody/visibility and telemetry uncertainty are described correctly.

**Fail.** One defined failure needs a raw value, is misclassified as user activity, or causes an unsafe workaround.

**Evidence.** truth ledger, participant decisions, action log and residual blind-spot list. **Duration:** 60–90 minutes. **Cleanup:** delete cases and bundles.

---
# 9. Architecture fitness functions and measurable acceptance criteria

## 9.1 Fitness functions

| ID | Fitness function | Automated measurement | Acceptance |
|---|---|---|---|
| FF13-01 Catalogue closure | every release event/error/metric/span/attribute/message/owner/runbook exists in one catalogue | generator + architecture/analyzer scan | zero unregistered names, fields or direct SDK/logging bypasses |
| FF13-02 Source minimization | forbidden values never enter diagnostic APIs or sinks | exact T1 canary/forbidden-key scan across section 8.2 | zero escapes; every positive control detected |
| FF13-03 Exception safety | exceptions cannot become text or arbitrary properties | hostile exception/mutation corpus | zero message/stack/path/data output; unknown maps to finite safe class |
| FF13-04 Cardinality | theoretical and actual series remain within declared finite budget | catalogue Cartesian calculation + runtime hostile probe | no dynamic labels; actual series <= declared per-instrument/process limit; zero unexpected overflow |
| FF13-05 Resource isolation | diagnostics cannot destabilize or change business durability | failpoints, outage, disk/queue/load tests | zero business cursor/effect/outbox difference attributable to diagnostics; bounded CPU/memory/disk/network |
| FF13-06 Trace safety | traces carry only static spans and allowed finite attributes | exporter/header capture and propagation tests | no baggage; no forbidden attributes; external context cannot affect auth/realm/sampling |
| FF13-07 Access-log safety | HTTP records contain only safe route/method/status/latency/auth classes | request canary matrix | zero path/query/header/body/address/identity values |
| FF13-08 Crash safety | production endpoint crash produces no raw dump or attach artefact | Windows config/file/process trace | zero dump/trace/profile artefacts; finite crash summary and bounded restart |
| FF13-09 Permit monotonicity | temporary diagnostics is an intersection, never a widening | exhaustive small-domain/property tests | zero broadening counterexamples; lower revision/invalid key/realm/target never activates |
| FF13-10 Expiry/revocation | active diagnostics stops and cleans up within approved bound | controlled clock/revocation/restart timeline | zero post-authority records/uploads; cleanup complete; no self-renewal |
| FF13-11 Bundle determinism | same safe snapshot/permit/clock/recipe gives same plaintext root | two challenged clean runs | byte-identical canonical entries/root; encryption may differ |
| FF13-12 Bundle collection scope | recipe reads only named safe projections | filesystem/registry/process/API trace | zero unlisted read/command/glob/source-store access |
| FF13-13 Bundle bounds | bundle cannot exceed declared complete recipe limits | size/entry/ratio/time hostile corpus | within approved limits or whole-bundle failure; no silent truncation |
| FF13-14 Encryption/custody | only authenticated recipient can decrypt and receipt semantics are exact | interop, wrong-key/target, failpoint and retry tests | wrong key/target rejected; same ciphertext retry; receipt only after durable ciphertext custody |
| FF13-15 Realm isolation | all logs/bundles/cases/access/deletion are realm scoped | two-realm collision matrix | zero cross-realm metadata/content/mutation success; payload realm not authoritative |
| FF13-16 Supportability | defined failures are diagnosed without raw values | blind L1/L2 challenge against independent truth | every defined case correctly classified/routed; zero raw request/access; blind spots recorded |
| FF13-17 State truth | custody, validation, quarantine, availability, access, expiry and deletion remain distinct | contract/UI/state-machine tests | no illegal transition or misleading “sent/complete/deleted” message |
| FF13-18 Cleanup | diagnostic artefacts and authority do not remain after close/revoke/failure | before/after VM/store/backend diff | zero plaintext, process, port, token, temp config or unauthorized ciphertext residue |
| FF13-19 Compatibility | old/new components fail explicitly and consumer-first rollout works | executable version matrix | no silent drop/coercion; incompatible producer blocked; higher-revision rollback only |
| FF13-20 Accessibility | critical status/errors are perceivable, identified and operable | automated + keyboard/screen-reader test | WCAG 2.2 target checks pass; no color-only state; safe message announced appropriately |
| FF13-21 Supply chain | every telemetry/bundle dependency maps to reviewed source/license/binary | lock/SBOM/provenance/file reconciliation | zero unmapped package/native/binary/config; exact version passes canary and security tests |
| FF13-22 Operations/cost | selected design is supportable within approved resources | synthetic load/cost/operator exercise | human-approved budgets/SLOs met; no count-only capacity claim |

## 9.2 Primary acceptance expression

```text
G13_SUPPORTABILITY_PASS =
    CATALOGUE_UNREGISTERED_COUNT = 0
    AND UNSAFE_LOGGING_OR_SDK_BYPASSES = 0
    AND MANDATORY_CANARY_MISSES = 0
    AND FORBIDDEN_VALUE_OR_DERIVATIVE_ESCAPES = 0
    AND DYNAMIC_METRIC_LABELS = 0
    AND UNEXPECTED_METRIC_OVERFLOW_POINTS = 0
    AND FORBIDDEN_TRACE_OR_ACCESS_LOG_ATTRIBUTES = 0
    AND ENDPOINT_PRODUCTION_DUMPS_OR_DIAGNOSTIC_ATTACHES = 0
    AND DIAGNOSTIC_CAUSED_BUSINESS_STATE_DIFFERENCES = 0
    AND PERMIT_BROADENING_COUNTEREXAMPLES = 0
    AND INVALID_OR_EXPIRED_PERMIT_ACTIVATIONS = 0
    AND POST_REVOCATION_OR_EXPIRY_ENHANCED_RECORDS = 0
    AND CROSS_REALM_DISCOVERY_ACCESS_MUTATION_SUCCESSES = 0
    AND BUNDLE_UNLISTED_READS_OR_COMMANDS = 0
    AND BUNDLE_PLAINTEXT_DISK_RESIDUE = 0
    AND BUNDLE_SILENT_TRUNCATIONS = 0
    AND WRONG_KEY_OR_TARGET_DECRYPTIONS = 0
    AND PREMATURE_CUSTODY_RECEIPTS = 0
    AND DEFINED_FAILURE_MISDIAGNOSES = 0
    AND RAW_SUPPORT_REQUESTS_OR_ACCESSES = 0
    AND CLEANUP_RESIDUE = 0
    AND BLOCKING_OWNER_COUNT = 0
    AND BLOCKING_ADR_COUNT = 0
```

No success percentage, risk waiver, scanner reputation, sampling rate, support intuition, or “temporary debug” flag compensates for a nonzero primary invariant count.

## 9.3 Bootstrap measurable values that remain provisional

| Measure | Prototype hypothesis | Replacement evidence |
|---|---:|---|
| Endpoint active series budget | 256 Coordinator / 128 User Host / 64 Task Host | cardinality and resource experiment plus SRE/Product approval |
| Server active series budget | 2,048 per process | load/cost/backend query evidence |
| Portal active series budget | 512 per process | route/UI load evidence |
| Server head sampling | 0.01 in synthetic lane | support yield, cost, load, privacy and incident evidence |
| Revocation watchdog interval | 60 seconds maximum in prototype | control-path and offline measurements; risk owner approval |
| Bundle uncompressed/encrypted limit | 32 MiB / 8 MiB | defined-failure bundle distributions and network/backend budgets |
| Bundle timeline/fingerprint limits | 1,000 / 500 | supportability and size measurements |
| Bundle collection duration | 2 minutes in lab | endpoint impact and support value evidence |
| Local encrypted artefact grace | no production default; lab only | custody retry/outage policy and human retention decision |
| Backend retention | disabled/unselected | Records Management, Privacy, Legal, Support and backend deletion evidence |

---

# 10. Human decisions and owner questions

Research does not approve the decisions below. Conservative defaults preserve a disabled or minimum-data state.

| ID | Human decision | Options and consequences | Conservative temporary default | Accountable role/function |
|---|---|---|---|---|
| HD13-01 | support roles, tiers, named teams and hours | 24×7 reduces recovery time but costs more; business-hours lowers cost but lengthens outages; outsourced support expands access/supply-chain scope | no live D1/D2 or production support promise until named coverage and escalation exist | Engineering Leadership + Service Management |
| HD13-02 | diagnostic access authority and approval separation | single approver is simpler but weaker; two-function approval improves control but may delay cases; local-only avoids backend risk but limits remote support | D1/D2 production disabled; T1 lab permits only | Product Security/IAM + Privacy Governance |
| HD13-03 | production diagnostic retention | short retention reduces exposure but limits trend/incident evidence; longer retention increases cost, access, deletion and correlation risk | D0 minimum not approved for production; no D2 backend retention | Records Management/Data Controller/Privacy |
| HD13-04 | approved support backend and data residency | existing observability platform may reduce operations but must prove realm/access/deletion; dedicated store narrows access but costs more; local-only avoids remote custody | no production remote bundle upload | Architecture/Product/Operations/Security/Procurement |
| HD13-05 | incident communication authority, channels and timing | centralized incident command improves consistency; distributed communication may be faster but inconsistent; legal/employee/customer notices depend on context | technical containment and internal escalation only; no automated external communication | Incident Command + Legal/Privacy/Communications |
| HD13-06 | bundle encryption/key service/profile | enterprise CMS/X.509 may fit existing PKI; HPKE may be simpler cryptographically but adds key/dependency operations; backend-side only encryption leaves transport/temp exposure | production D2 disabled until one profile passes and key owner accepts recovery/rotation | Cryptographic/Signing Authority + Security/Operations |
| HD13-07 | metric cardinality/resource budgets | lower budgets protect endpoints/cost but reduce dimensions; higher budgets improve diagnosis but increase memory/index/correlation risk | finite bootstrap estimates only; no per-target labels | Product/SRE/Finance/Privacy |
| HD13-08 | trace sampling and tail sampling | lower head sampling saves cost; higher improves rare-path detail; tail sampling adds buffering/routing complexity | endpoint traces off; server synthetic rate 0.01; tail sampling off | SRE/Observability Architecture/Product |
| HD13-09 | log/metric/trace backend access roles | broad SRE access is convenient but increases cross-realm/rare-group risk; case-scoped access is safer but slower | case/realm scoped; no bulk fingerprint search | Security IAM + Product Governance |
| HD13-10 | bundle access/download policy | in-browser controlled view reduces copies; download helps offline analysis but creates uncontrolled retention; no download is safest | no plaintext download; controlled view only if backend approved | Support Leadership + Security/Privacy |
| HD13-11 | audit retention and relationship to diagnostics | longer audit supports accountability but increases identity retention; must remain separate from telemetry | durable audit required for privileged actions, exact retention undecided | Records Management + Security Audit Owner |
| HD13-12 | crash dump, WER, EDR and remote-support policy | raw dumps can solve low-level defects but expose process memory; vendor agents may already capture data outside UAM | UAM dumps/diagnostic attach off; production raw dump not part of this design | Endpoint Security + Privacy + Incident Response |
| HD13-13 | rare fingerprint suppression/access | full grouping helps engineering; suppression/coarsening reduces singling-out but hides rare defects | fingerprint visible only in case/realm scope; no global operator query | Privacy + Product Support Engineering |
| HD13-14 | data-quality and coverage statements shown to administrators | detailed states prevent false “no activity” claims but require education; simplified status risks misinterpretation | explicit fallible states and safe uncertainty; no productivity conclusion | Product/Data Governance/Legal/Privacy |
| HD13-15 | exact bundle recipes and defined support promise | broader recipe may diagnose more but increases surface; narrower recipe is safer but may leave blind spots | only the standard D2 safe recipe prototype; unsupported issues go to T1 reproduction | Product Support + Privacy + Engineering |
| HD13-16 | deletion, backup, legal hold and crypto-shred semantics | immediate deletion may conflict with backup/hold; expiry-based backup deletion is slower; crypto-shred depends on key architecture | no final “deleted” state until approved layers are evidenced | Records Management/Legal/Platform Reliability |
| HD13-17 | cost/licensing/procurement and vendor support | open-source self-operation avoids license fee but needs skills; commercial backend/support may lower toil but adds contracts/data processing | no production vendor/backend commitment | Product/Finance/Procurement/Legal/Operations |
| HD13-18 | SLO/RPO/RTO and diagnostics availability | high availability increases cost; diagnostics may be lower priority than business ingestion; bundle loss may require reauthorization | diagnostics may degrade without blocking product data; exact objective unset | Product/SRE/Operations |
| HD13-19 | supported Windows/server/portal environments | broad support increases qualification matrix; narrow support excludes estates | only named lab environments; no general production claim | Endpoint Platform/Product Support/Architecture |
| HD13-20 | production/pilot risk acceptance | technical gates reduce risk but do not approve purpose, access or operations | fictional/disposable prototype only | Designated Production/Risk Authority |
| HD13-21 | consent, notice and acknowledgement model for temporary diagnostics/support bundles | end-user acknowledgement is visible but may be impractical; local-administrator acknowledgement supports managed devices but may not satisfy workforce expectations; enterprise-policy authorization with notice scales but needs governance; no runtime interaction is possible only if approved authorities determine it is appropriate | production D1/D2 disabled; visible local T1 lab acknowledgement only | Data Controller/Product Owner + Privacy/Legal/Employee Relations |

## 10.1 Owner questions

1. Which support failures must be diagnosable at L1, L2 and L3, and which may require only a T1 reproduction?
2. Who can request, approve, revoke and re-enable D1/D2, and must request/approval be separated?
3. Is one target permit enough, or are realm/server-module permits needed? Bulk endpoint permits should be presumed prohibited until specifically justified.
4. Is plaintext bundle download ever necessary, or can support use a controlled view with copy restrictions and auditing?
5. What retention applies separately to D0 events, metrics, traces, encrypted bundles, decrypted views, access audit and deletion evidence?
6. Which backend and regions are approved, and how are primary/index/cache/backup deletion and restore tested?
7. What is the maximum acceptable revocation/expiry latency for offline endpoints?
8. Which enterprise WER, EDR, remote-support, pagefile, hibernation, backup and hypervisor controls affect UAM process memory?
9. What are the approved metric series, event-rate, trace, CPU, memory, disk, network, query and monthly cost budgets?
10. Which exact incident communication authority decides whether and how to notify employees, customers, regulators or vendors?
11. Who owns each error domain and runbook, and what support hours make the claimed recovery credible?
12. What evidence is required to declare a bundle deleted when backups or legal holds exist?
13. Is a global fingerprint trend operationally necessary, and if so how will rare groups be protected from target correlation?
14. Which languages and assistive technologies must portal safe messages and status workflows support?
15. Who performs the explicitly authorized Batch 02 cross-review before accepting this result?
16. Which consent/notice/acknowledgement mode is required for each D1/D2 use case, who approves it, what must the user or local administrator see, and what evidence may be retained without storing identity?

---

# 11. CLI experiments/measurements and the exact evidence they must produce

Commands use placeholders and T1 data only. They do not contain connection values, credentials, internal addresses, real users, or production identifiers.

## E13-00 — evidence boundary and toolchain

```powershell
Get-FileHash -Algorithm SHA256 <ALLOWLISTED_FILE_PATHS> |
  ConvertTo-Json -Depth 4 > artifacts/e13-00-inputs.json

dotnet --info > artifacts/e13-00-dotnet-info.txt
dotnet list <SOLUTION> package --include-transitive > artifacts/e13-00-packages.txt
```

**Must produce:** exact five input hashes, source tree, SDK/runtime/OS class, lock/source mapping, package graph, tool hashes, and proof no extra Project input was used. **Pass:** exact inputs and supported pinned tools. **Fail:** missing/extra input, floating package/tool or secret in output.

## E13-01 — telemetry catalogue and analyzer mutations

```powershell
dotnet run --project tools/Uam.TelemetryCatalogue -- generate \
  --catalog contracts/diagnostics/catalogue.yaml \
  --out artifacts/e13-01-generated

dotnet test tests/Uam.Diagnostics.Architecture.Tests \
  --filter Category=TelemetryContract

dotnet run --project tools/Uam.TelemetryMutation -- \
  --rules artifacts/e13-01-mutations.json
```

**Must produce:** catalogue root, generated source/schema/docs hashes, event/instrument/span uniqueness, theoretical cardinality, every unsafe mutation result and clean-tree proof. **Pass:** all mutations fail. **Fail:** any ad-hoc/dynamic/exception/forbidden-field path builds.

## E13-02 — all-sink canary campaign

```powershell
dotnet run --project tools/Uam.T1Canaries -- generate \
  --seed <FIXED_SEED> --clock 2026-07-31T12:00:00Z \
  --out artifacts/e13-02-canaries

dotnet test tests/Uam.Diagnostics.Privacy.Tests \
  --filter Category=AllSinkCanary

dotnet run --project tools/Uam.CanaryScan -- scan \
  --registry artifacts/e13-02-canaries/registry.json \
  --sink-manifest artifacts/e13-02-sinks.json \
  --report artifacts/e13-02-report.json
```

**Must produce:** marker/sink/encoding matrix, scanner and decoder identities, all positive controls, zero-escape assertion, undecoded-sink count, redacted report and cleanup receipt. **Pass:** all positive controls found, no mandatory miss, zero forbidden escape.

## E13-03 — exception/fingerprint safety

```powershell
dotnet test tests/Uam.Diagnostics.Exception.Tests \
  --filter Category=HostileException \
  --logger "trx;LogFileName=e13-03.trx"

dotnet run --project tools/Uam.FingerprintCheck -- \
  --build-map artifacts/t1-signed-build-map.json \
  --vectors contracts/diagnostics/fingerprint-v1-vectors.json
```

**Must produce:** finite exception mapping, fingerprints, allocation/time distribution, mutation survivors and proof no exception text/stack/path appears.

## E13-04 — cardinality and resource measurement

```powershell
dotnet run --project tools/Uam.CardinalityProbe -- \
  --catalog contracts/diagnostics/catalogue.yaml \
  --seed <FIXED_SEED> --unique-hostile-values 1000000 \
  --out artifacts/e13-04
```

**Must produce:** theoretical/actual series per instrument/process, overflow points, resource attributes, peak memory/CPU, point counts and hostile rejection counts. **Pass:** no dynamic series and no legal-profile overflow.

## E13-05 — trace propagation and sampling

```powershell
dotnet test tests/Uam.Diagnostics.Trace.Tests \
  --filter Category=PropagationAndSampling
```

**Must produce:** header vectors, baggage/tracestate stripping, trace/span set, sample-decision distribution, attribute allowlist and proof trace context did not affect realm/auth/sampling authority.

## E13-06 — access-log negative test

```powershell
dotnet test tests/Uam.Diagnostics.Http.Tests \
  --filter Category=PrivacySafeAccessLogging
```

**Must produce:** route-by-signal matrix for hostile URLs/headers/bodies/route values, canary result and exact safe fields. **Pass:** only route-template/method/status/latency/auth classes.

## E13-07 — Windows crash/dump/attach controls

```powershell
# Run only in an approved disposable T1 Windows VM.
$env:DOTNET_DbgEnableMiniDump
Get-ItemProperty -Path '<UAM_WER_POLICY_PLACEHOLDER>' -ErrorAction SilentlyContinue |
  Select-Object '<SAFE_PROPERTY_CLASSES>' |
  ConvertTo-Json > artifacts/e13-07-dump-config.json

dotnet test tests/Uam.Diagnostics.WindowsVm.Tests \
  --filter Category=CrashWithoutDump
```

**Must produce:** sanitized dump/diagnostic-port configuration classes, process/file operation counts, crash/restart/kill states and before/after cleanup. No real registry path or machine identity enters shareable evidence.

## E13-08 — Collector distribution/configuration

```powershell
<OTELCOL_CUSTOM_PLACEHOLDER> validate --config <GENERATED_CONFIG>
<OTELCOL_CUSTOM_PLACEHOLDER> components > artifacts/e13-08-components.txt
dotnet test tests/Uam.Diagnostics.Collector.Tests \
  --filter Category=AllowlistRedactionAndFailureModes
```

**Must produce:** Collector binary/source/config hashes, compiled component list, SBOM/provenance, explicit processor error modes, unknown-attribute rejection, canaries, queue/memory/resource behavior and no payload echo in internal logs.

## E13-09 — outage, pressure and business isolation

```powershell
dotnet test tests/Uam.Diagnostics.Resilience.Tests \
  --filter Category=BusinessIsolationAndBackpressure
```

**Must produce:** business truth ledger before/after every diagnostic failpoint, diagnostic queue/store states, CPU/memory/disk/network curves and recovery. **Pass:** business state identical to oracle and diagnostics remain bounded.

## E13-10 — deterministic support bundle

```powershell
dotnet run --project tools/Uam.SupportBundle -- collect \
  --permit fixtures/t1/diagnostic-permit.json \
  --recipe ENDPOINT_STANDARD_D2_V1 \
  --snapshot fixtures/t1/diagnostic-snapshot \
  --clock 2026-07-31T12:00:00Z \
  --out artifacts/e13-10-run-a
# Repeat in challenged path/user/locale/time-zone environment as run-b.
dotnet run --project tools/Uam.BundleCompare -- \
  artifacts/e13-10-run-a artifacts/e13-10-run-b
```

**Must produce:** entry/root digests, allowed-read trace, deterministic diff, size counts, canary report and zero plaintext-disk proof.

## E13-11 — archive, encryption, upload and receipt

```powershell
dotnet test tests/Uam.Diagnostics.BundleSecurity.Tests \
  --filter Category=ArchiveEncryptionUploadFailpoints
```

**Must produce:** hostile archive/size vectors; exact crypto implementation/key/test-vector identities; ciphertext digests; wrong-key/target results; upload retry/custody ledger; local/backend cleanup. **Pass:** authenticated interoperable profile and no premature receipt/residue. A production choice remains human-owned.

## E13-12 — permit expiry and revocation

```powershell
dotnet run --project tools/Uam.DiagnosticPermitModel -- verify \
  --vectors contracts/diagnostics/permit-state-vectors.json \
  --exhaustive-small-domain

dotnet test tests/Uam.Diagnostics.Permit.Tests \
  --filter Category=ExpiryRevocationRestartClock
```

**Must produce:** state transitions, minimal broadening counterexamples, acknowledgement-mode and receipt-binding vectors, missing/forged/replayed/wrong-purpose/wrong-target/expired receipt results, stop latency, post-expiry record count, nonce/revision/restart behavior and cleanup.

## E13-13 — realm/target isolation

```powershell
dotnet test tests/Uam.Diagnostics.Realm.Tests \
  --filter Category=CrossRealmNegativeMatrix
```

**Must produce:** full actor/realm/target/case/action matrix across API, DB, cache, index, object store, portal and deletion; audit facts; zero cross-realm metadata/content success.

## E13-14 — support blind-diagnosis and accessibility

```powershell
dotnet run --project tools/Uam.SupportChallenge -- \
  --truth fixtures/t1/support-challenge-truth.json \
  --cases 60 --seed <FIXED_SEED> \
  --out artifacts/e13-14

dotnet test tests/Uam.Portal.Accessibility.Tests \
  --filter Category=DiagnosticStatusAndErrors
```

**Must produce:** hidden truth, answers, route/runbook/owner accuracy, raw-request detector, time/actions, unresolved blind spots, keyboard/status-message results. **Pass:** every defined case correct and zero unsafe access/request.

## E13-15 — access, expiry and deletion

```powershell
dotnet test tests/Uam.Diagnostics.Retention.Tests \
  --filter Category=PrimaryIndexCacheBackupDeletion
```

**Must produce:** lifecycle state for primary/index/cache/backup/key, access after expiry, restore negative test, legal-hold branch and durable audit. Exact policy values remain human-owned.

## E13-16 — incident/runbook drill

```powershell
dotnet run --project tools/Uam.RunbookExercise -- \
  --scenario-set fixtures/t1/diagnostic-incidents.json \
  --out artifacts/e13-16
```

**Must produce:** trigger, authority, containment time/order, kill/revoke, evidence preservation, cleanup, re-enable gate and after-action defects for RB13-01–16.

## E13-17 — load, cost and operational skills

```powershell
dotnet run --project tools/Uam.DiagnosticsLoad -- \
  --model fixtures/t1/replaceable-load-model.json \
  --endpoints 6000 --outage-scenarios fixtures/t1/outages.json \
  --out artifacts/e13-17
```

**Must produce:** exact replaceable input distributions, series/events/spans/bytes, CPU/memory/disk/network, queue age, storage/index/backup/query costs, support task completion and bottlenecks. The endpoint count alone is not a pass condition.

## E13-18 — compatibility and aggregate gate

```powershell
dotnet test tests/Uam.Diagnostics.Compatibility.Tests \
  --filter Category=OldNewRollbackOffline

dotnet run --project tools/Uam.DiagnosticsGate -- evaluate \
  --evidence artifacts/e13-* \
  --out artifacts/g13-diagnostics-gate.json
```

**Must produce:** executable compatibility matrix, ring/rollback timeline and one immutable gate binding all inputs, versions, owners, ADRs, tests, canaries, cleanup and exceptions. **Pass:** primary expression true with no unassigned blocker or expired exception.

## E13-19 — authorized Batch 02 cross-review

No command can replace architecture review. The evidence must name the explicitly authorized Batch 02 file/hash, reviewer, scoped comparison, conflicts, and ADR actions. Until this exists, this result remains conditionally acceptable rather than batch-final.

---
# 12. ADR proposals

| ADR | Decision | Status | Alternatives | Rationale/evidence | Owner function | Review trigger |
|---|---|---|---|---|---|---|
| ADR-G13-001 | Adopt a privacy-safe observability kernel: source-owned closed signals, bounded transport, deterministic bundles and permit state machine | **Proposed — accept for prototype** | free-form logs; vendor agent; Collector-first redaction | accepted minimization/realm invariants; OTel “do not collect” guidance [I01, I05, W01] | Architecture + Privacy Engineering | primary gate failure or a safer simpler composition |
| ADR-G13-002 | Every event/error/metric/span/attribute is compile-time catalogued and emitted only through generated UAM APIs | **Proposed — accept** | reviewer-only discipline; runtime schema registry | makes privacy, cardinality, ownership, localization and compatibility executable | Observability Architecture | analyzer bypass, catalogue scale/ergonomics evidence |
| ADR-G13-003 | Use the finite error taxonomy, retry classes, owner functions, safe messages and value-free versioned fingerprints in section 5 | **Proposed — accept** | raw exception/stack grouping; vendor fingerprint | raw grouping leaks data; finite tuple supports routing while preserving boundaries | Diagnostics Engineering + Security | blind-support failure, semantic collision or unsafe preimage evidence |
| ADR-G13-004 | Endpoint Coordinator is the sole diagnostic persistence/export owner; Task/User Hosts emit closed records only | **Proposed — accept** | per-process log files; endpoint Collector | aligns with accepted process/privacy boundary and limits durable sinks | Endpoint Architecture | runtime evidence that Coordinator ownership violates another accepted invariant |
| ADR-G13-005 | Diagnostic storage and writes are transactionally independent from business event/cursor/outbox durability | **Proposed — accept** | shared commit; synchronous remote log | diagnostics must never advance, block or retry business work | Endpoint Storage + Diagnostics | failpoint evidence showing unavoidable coupling and explicit change proposal |
| ADR-G13-006 | Use explicit per-instrument cardinality budgets and finite enum labels; overflow is a defect | **Proposed — accept; values provisional** | rely on SDK default; backend-only limiting | OTel documents high-cardinality pressure and overflow information loss [W02–W03] | Observability/SRE + Privacy | measured support need and approved higher bound |
| ADR-G13-007 | Endpoint traces off at D0; server uses static safe spans, head sampling and `tracecontext` only; baggage/tail sampling off initially | **Proposed — accept profile; rates provisional** | always-on traces; baggage; tail sampling default | smaller correlation/volume surface; tail sampling adds buffering/routing [W06–W08, W10] | Observability Architecture + Security | support-yield/load evidence and privacy-safe tail-sampling proof |
| ADR-G13-008 | Disable generic HTTP logging; permit only route-template/method/status/latency/auth classes through UAM wrapper | **Proposed — accept** | framework defaults; full access logs with redaction | official features can collect path/header/body/route values [W15–W16] | Web Platform + Privacy | a route-specific bounded need passes all-sink review |
| ADR-G13-009 | Automatic endpoint dumps, profiler and diagnostic attach are off; T1 lab dump is a separate permit and never a support bundle | **Proposed — accept** | automatic WER/.NET dumps; remote debugger | dumps contain process memory [W17–W20] | Endpoint Security + Privacy | explicit forensic baseline change with stronger authority and containment |
| ADR-G13-010 | Support bundles contain only closed hashes/counts/status/version projections; no files/commands/raw logs; plaintext is in memory only | **Proposed — accept** | generic support bundle tool; raw log ZIP | prevents support bundle from becoming exfiltration/remote execution | Support Engineering + Privacy | defined failure cannot be diagnosed and a safe additional projection passes the gate |
| ADR-G13-011 | D0–D2 levels and the signed non-broadening permit state machine; D3/raw unrepresentable | **Proposed — accept** | admin debug switch; tenant-defined collector | preserves product ceiling, expiry, target/realm binding and kill behavior | Privacy Policy + Signing/IAM | formal counterexample or approved stronger control design |
| ADR-G13-012 | Compare CMS authenticated envelope and HPKE; production D2 remains disabled until crypto/key profile is accepted | **Proposed — experiment / blocking for production D2** | plaintext ZIP; transport TLS only; backend-generated encryption | bundle needs end-to-end authenticated encryption and enterprise recovery/rotation [W27–W29] | Cryptographic/Signing Authority | interoperability, compliance, key operations, incident drill |
| ADR-G13-013 | Use OpenTelemetry .NET and a minimal custom server-side Collector distribution after dependency admission; no endpoint Collector initially | **Proposed — accept family, exact versions provisional** | direct proprietary telemetry; full contrib distro; endpoint agent | standards/tooling benefit with minimized components; current releases active [W10–W12] | Observability Platform + Supply Chain Security | package/security incident, performance failure, backend incompatibility |
| ADR-G13-014 | Realm/case authorization is out-of-body and mandatory; realm is not a metric/span/body/fingerprint value; access/download/deletion are audited | **Proposed — accept** | payload realm; global support index | accepted realm isolation and least disclosure | IAM/Product Security | realm-negative failure or new approved tenancy architecture |
| ADR-G13-015 | Use the lifecycle states and custody semantics in sections 6 and 7; telemetry is not audit or forensic proof | **Proposed — accept** | one “sent” state; logs as audit | accepted receipt/audit/fallibility invariants | Architecture + Product/Data Governance | implementation model proves incompatible and change proposal accepted |
| ADR-G13-016 | Require the runbook/ownership catalogue and blind support challenge before enabling production diagnostics | **Proposed — accept** | documentation after release; engineering-only support | supportability is the primary gate; owner absence drives unsafe workarounds | Support Leadership + Operations | changed support promise/organization or failed exercise |
| ADR-G13-017 | Numeric limits, sampling, retention, series and cost budgets remain replaceable estimates until measured and approved | **Proposed — accept** | hard-code report values as architecture | no representative rates, SLOs, budget or backend evidence | Product/SRE/Finance/Privacy | each measured and approved value receives its own ADR/config revision |
| ADR-G13-018 | Perform an explicitly authorized Batch 02 semantic cross-review before batch-final acceptance | **Proposed — blocking review condition** | infer/use unlisted file; ignore project-context requirement | exact allowlist did not authorize Batch 02; no silent evidence substitution | Batch Reviewer/Architecture | authorized review completed and conflicts resolved |

No ADR is accepted for production while its accountable owner is unassigned, its mandatory experiment is missing, a human decision is implicitly enabled, or a primary invariant has a nonzero failure count.

---

# 13. Ordered implementation backlog with dependencies and stop gates

## 13.1 Immediate permission and prohibition

**GO now** for pure contracts, catalogue/analyzers, T1 canaries, finite metrics/spans, in-memory exporters, deterministic bundle models, permit state model, backend emulator, accessibility fixtures and disconnected Windows scripts.

**STOP now** before live production export, endpoint D1/D2, remote support bundle upload, real support access, production crypto keys, production backend data, raw dump/diagnostic attach, or any real activity/identity input.

## 13.2 Critical path

| Order | Backlog item | Dependencies | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | record five-file evidence manifest and open ADR/decision records | none | exact hashes, source register, owner placeholders | missing/extra/unallowlisted input or digest mismatch |
| 2 | arrange explicitly authorized Batch 02 scoped cross-review | governance | reviewer record/ADR actions | final batch acceptance blocked; pure prototype work may continue |
| 3 | assign owner functions for catalogue, privacy, endpoint, server, portal, Collector, support, IAM, signing, incident, records and accessibility | human governance | owner/escalation register | affected contract cannot become candidate while `UNASSIGNED` |
| 4 | scaffold `Uam.Diagnostics.*`, contracts, tests and architecture rules in accepted monorepo | Batch 01 repository controls | buildable empty boundaries | direct unsafe dependency/API mutation survives |
| 5 | define telemetry catalogue metaschema and error taxonomy | 3–4 | catalogue v1, error/message/owner/runbook records | extension bag, arbitrary strings, missing owner or ambiguous retry |
| 6 | build source generators and analyzers | 5 | generated APIs/schemas/docs and mutation suite | ad-hoc log/metric/span/exception/object path remains |
| 7 | create deterministic T1 diagnostic fixtures, independent truth and canary corpus | G0 predecessor, 5–6 | all failure paths, encodings, sink manifest and scanner self-test | nondeterminism, real value, scanner miss or oracle production-code dependency |
| 8 | implement safe event/error/fingerprint library | 5–7 | closed records, mapper/build map, vectors | raw exception/message/stack/path or attacker-controlled fingerprint input |
| 9 | implement metrics catalogue, Views and cardinality probe | 5–7 | finite labels, theoretical/runtime budget report | dynamic label, normal overflow or unbounded memory |
| 10 | implement trace/propagation wrapper | 5–7 | static spans, attribute allowlist, head sampler, baggage removal | forbidden attribute/baggage or auth/realm influence |
| 11 | implement safe server/portal access logging and problem responses | 5–10 | route-template profile and accessibility tests | request path/query/header/body/address/identity leak |
| 12 | implement endpoint safe-record IPC and Coordinator gateway with synthetic processes | accepted G1 logical boundary, 4–8 | closed process-role records and rate/schema validation | raw field, payload realm authority, Task Host file/network log |
| 13 | implement independent bounded endpoint diagnostic journal | 12 | schema/migrations, pressure/corruption/safe-minimum states | business-store reference/write or business commit dependency |
| 14 | implement server/portal OTel .NET integration behind wrappers | 8–11 | in-memory/OTLP T1 signals | direct SDK/auto-instrumentation bypass |
| 15 | build and admit minimal Collector distribution | 7, 9–10, 14, dependency process | exact components/config/SBOM/provenance and rejection tests | forbidden component, silent processor error, payload echo or unmapped binary |
| 16 | implement dump/diagnostic-port policy checks and T1 Windows crash lane | 4, 7–8, approved lab | no-dump crash summary, loop kill, cleanup | production-profile dump/attach or raw crash output |
| 17 | implement diagnostic permit pure model and exhaustive subset/state tests | privacy lattice/signing invariants, 5–7 | D0–D2/D3 rules and vectors | broadening, lower revision, wrong realm/target or expiry activation |
| 18 | implement Coordinator permit persistence/watchdog/kill/cleanup with T1 keys | 12–13, 17 | restart-safe state machine and stop timeline | self-renewal, post-authority output or cleanup bypass |
| 19 | implement closed support-bundle recipe/projections and deterministic builder | 7–9, 13, 17–18 | canonical in-memory entries/root and access trace | file/command/registry/source read, plaintext file, nondeterminism or truncation |
| 20 | compare/admit encryption profiles | 19, human crypto requirements | interoperability/key rotation/recovery/wrong-target evidence and ADR | no profile satisfies security/operations; D2 remains disabled |
| 21 | implement bounded upload/custody/backend emulator | 18–20 | stable ciphertext retry, custody receipt and target/realm binding | premature receipt, wrong context, duplicate plaintext or unbounded retry |
| 22 | implement case-scoped backend/portal access, audit, expiry and deletion states | 3, 11, 21 | authorization matrix, controlled view, lifecycle/deletion evidence | cross-realm/bulk access, audit gap or false deleted state |
| 23 | run full all-sink canary, pressure, crash, realm, compatibility and cleanup campaigns | 7–22 | E13-02–13 evidence | any primary invariant failure |
| 24 | run blind L1/L2 support challenge and accessibility review | 3, 11, 19–23 | support truth/answers/blind spots and WCAG evidence | one defined failure misdiagnosed or raw workaround requested |
| 25 | run load/cost/backend/operator bake-off | 9, 14–15, 21–24 | replaceable model, resource/cost/skills evidence | count-only capacity claim, overflow/unbounded cost or unsupported operations |
| 26 | exercise RB13-01–16 and incident/recovery/deletion drills | 16–25, assigned roles | runbook receipts and after-actions | unclear authority, raw capture, self-reenable or incomplete cleanup |
| 27 | complete human decisions for production scope | evidence from 20–26 | approved access, retention, backend, crypto, communication, budgets, support and risk records | any required decision absent or unsafe default assumed |
| 28 | generate immutable `g13-diagnostics-gate.json` | 1–27 | exact inputs/versions/ADRs/owners/tests/canaries/cost/cleanup/exceptions | primary expression false, expired exception, digest mismatch or unresolved Batch 02 conflict |
| 29 | batch architecture review and baseline patch | passed 28 | accept/reject result and only approved refinements | silent redesign or estimate hardened as timeless fact |
| 30 | synthetic canary-ring D0 rollout | accepted 29 and release controls | same-digest release/config in approved environment | leakage, overflow, cross-realm, product impact or runbook failure |
| 31 | separately authorize limited D1/D2 pilot | human pilot/risk approval and passed production-like evidence | named targets/purposes/owners/expiry/backend | not implied by D0 success; any primary failure stops |
| 32 | broader production enablement | all applicable later project gates and recurring evidence | approved operational service | no implicit approval from this research |

## 13.3 Stop/go sequence

1. **GO** for catalogue, code generation, T1 canaries, pure models, emulators and disconnected lab scripts.
2. **STOP** if any unsafe API cannot be prevented at build time.
3. **GO** for synthetic signal/Collector/journal prototypes only after catalogue/canary positive controls pass.
4. **STOP** on one raw/derivative escape, dynamic label, baggage field, generic HTTP value, dump/attach artefact, business-state coupling or cross-realm success.
5. **GO** for deterministic D2 builder only after D0/D1 signals and permit model pass.
6. **STOP** on unlisted read/command, plaintext disk, silent truncation, nondeterminism, crypto downgrade, wrong-target decrypt or premature receipt.
7. **GO** for support challenge only with safe T1 cases and case-scoped access.
8. **STOP** if a defined failure requires production raw data or an unsafe support action.
9. **GO** for batch review only after the authorized Batch 02 cross-review and complete gate evidence.
10. **STOP before production** until human access, retention, backend, crypto, communication, support, budget/SLO and risk decisions are recorded.

---
# 14. Open-source repository assessment table

No repository is admitted as a dependency merely by this research. Admission requires exact package/source/binary mapping, license/notice approval, current security/advisory review, locked inputs, tests, T1 canaries, resource evidence, owner, SBOM/provenance, and a removal path.

| Repository and exact revision reviewed | Relevant files/directories | License and compatibility | Maintenance, tests and security posture | Similarities and threat-model differences | Reusable ideas / ideas not to copy | Suitability |
|---|---|---|---|---|---|---|
| [open-telemetry/opentelemetry-dotnet `core-1.17.0`](https://github.com/open-telemetry/opentelemetry-dotnet/tree/e432cd549a81dabfc8b1c7c346c03cdf933013f1), commit `e432cd549a81dabfc8b1c7c346c03cdf933013f1`, released 16 Jul 2026 | `src/OpenTelemetry`, `src/OpenTelemetry.Api`, OTLP exporter/hosting projects, `test/` | Apache-2.0; package/transitive and backend compatibility still need Legal/Supply Chain admission | active immutable signed release, extensive SDK/API/exporter tests and public security process; exact UAM performance/privacy not proved | strong fit for .NET metrics/traces/log correlation; generic SDK permits arbitrary attributes and standard instrumentation can expose sensitive values | reuse API/SDK/export pipeline and Views; do not expose SDK directly, enable broad auto-instrumentation, or treat OTel schema as UAM privacy authority | **Dependency candidate after admission** for server/portal; endpoint only through UAM wrappers and product transport initially |
| [open-telemetry/opentelemetry-collector-contrib `v0.157.0`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/89e43555904cd97c2d36605347c5d5237b1bdc8c), commit `89e43555904cd97c2d36605347c5d5237b1bdc8c`, released 21 Jul 2026 | `processor/redactionprocessor`, `processor/filterprocessor`, `processor/transformprocessor`, `processor/tailsamplingprocessor`, connectors/exporter helper tests | Apache-2.0; very large transitive/component surface if full distribution is used | active signed release, broad CI/tests/security; release changed filter/transform default error behavior, proving config-default risk | useful gateway processors/queues/health; generic multi-tenant telemetry routing is much broader than UAM and redaction occurs after collection | reuse selected processors and test patterns in a minimal custom distro; do not ship full contrib, host/file/process receivers, remote arbitrary config or rely on redaction alone | **Server gateway candidate after custom-build admission**; **not endpoint agent** |
| [open-telemetry/semantic-conventions `v1.43.0`](https://github.com/open-telemetry/semantic-conventions/tree/89aae438b3b3b0a8dd33003c9d70592baf7dbd0d), commit `89aae438b3b3b0a8dd33003c9d70592baf7dbd0d`, released 3 Jul 2026 | `model/`, generated `docs/`, HTTP/URL/error/log registries and tests/tools | Apache-2.0 | active specification repository with generated schema/docs and review process; stability varies by convention | useful naming/stability/cardinality documentation; many standard HTTP/URL/end-user/network attributes conflict with UAM minimization | reuse generation/versioning and low-cardinality guidance; explicitly opt out of sensitive/high-cardinality conventions and keep UAM catalogue authoritative | **Reference/schema input only**, not a direct field allowlist |
| [replicatedhq/troubleshoot `v0.131.1`](https://github.com/replicatedhq/troubleshoot/tree/b279b2bef9cbad8e5ad36df2a91dd5a3488f79e0), commit `b279b2bef9cbad8e5ad36df2a91dd5a3488f79e0`, released 10 Jul 2026 | `pkg/`, collector/redactor/analyzer areas, `schemas/`, `test/`, `testdata/` | Apache-2.0 | current signed release and active Go project with schemas/tests; no UAM-specific Windows/privacy proof | support-bundle manifests, analyzers and redactors are relevant; Kubernetes cluster discovery, commands, files, logs and remote specs have far broader authority | reuse declarative manifest, preview/analyzer, deterministic test-data and collector/redactor separation ideas; do not copy broad collectors, commands, cluster scans or raw archives | **Reference only**; no endpoint dependency or source copy without separate review |
| [hashicorp/hcdiag `v0.5.13`](https://github.com/hashicorp/hcdiag/tree/v0.5.13), release 27 May 2026, release commit shown as `a9c30a1` (full SHA not captured in this review) | `command/`, `op/`, `product/`, `redact/`, `runner/`, `tests/` | MPL-2.0; file-level copyleft and notices require Legal review for code reuse | active repository/release, tests and security policy; exact full commit/source-asset provenance remains a limitation | transparency, dry-run, declarative configuration and bundle manifest are useful; custom runners execute arbitrary commands and regex redaction is post-collection | reuse dry-run/preview and explicit collection plan concepts; never copy arbitrary runner/command or regex-as-primary-privacy architecture | **Reference only**; full commit must be captured before deeper review |
| [mozilla/glean `v69.0.0`](https://github.com/mozilla/glean/tree/v69.0.0), released 22 Jun 2026, release commit shown as `566b08e` (full SHA not captured) | `glean-core/`, language binding areas, metric-definition/parser/storage/testing areas in tagged tree | MPL-2.0; no direct C# dependency fit established | active release; v69 introduced major SQLite-backed storage migration and preserved monitoring metrics, showing mature typed telemetry/migration attention | typed metric definitions, validation, expiration/error metrics and test tooling are relevant; client telemetry product, identifiers, ping/storage semantics and platform scope differ | reuse schema validation, metric expiry, generated API and self-error patterns; do not copy ping/identifier/collection policy or storage architecture without UAM fit | **Reference only** for typed telemetry design |
| [getsentry/sentry `26.7.2`](https://github.com/getsentry/sentry/tree/a8da553fe6f01f51cb05d253c641d2a074e38484), commit `a8da553fe6f01f51cb05d253c641d2a074e38484`, released 28 Jul 2026 | `src/sentry/grouping/`, grouping/fingerprint configuration and corresponding `tests/sentry/grouping/` areas | FSL-1.1-Apache-2.0 future license for the main web app; not OSI open source during the change period; Legal review required | very active large platform with extensive tests/security, but high operational complexity | versioned grouping/fingerprint ideas are relevant; normal Sentry events deliberately include stacks, requests, users, breadcrumbs, attachments and broad integrations that UAM prohibits | reuse only conceptual lessons: version grouping algorithms and keep fingerprint distinct from identity; do not copy raw event model, SDK defaults, SaaS architecture or code under current license without approval | **Reference only; neither dependency nor backend recommendation** |
| [elastic/support-diagnostics `v9.4.1`](https://github.com/elastic/support-diagnostics/tree/v9.4.1), released 2 Jul 2026, release commit shown as `ebab5af` (full SHA not captured) | tagged `src/main/`, `src/test/`, configuration and product collector/archive areas | Elastic License 2.0; restrictions require Legal/Procurement review | current signed release, active dependency/test work; full commit and exact security policy not established in this review | mature product diagnostics and manifest/archive lifecycle; expects broad product APIs, commands/files/configuration and powerful credentials unlike minimized UAM endpoints | reuse only checklist ideas for manifests, version inventory and lifecycle; do not copy collectors, credential model, raw files/logs, archive or license-restricted code | **No-go as UAM dependency; reference only at most** |

## 14.1 Repository conclusions

- OpenTelemetry .NET is the strongest dependency candidate because it matches the accepted C#/.NET family, but the UAM catalogue/wrapper—not the SDK—owns privacy semantics.
- A custom Collector distribution is preferred over the full contrib image. The selected component set is treated as executable production code, not configuration glue.
- Support-bundle projects consistently show that generality comes from command, file, log, cluster or API collectors. Those are precisely the capabilities UAM must not copy.
- Error platforms show valuable grouping/versioning patterns but normally assume raw stacks, requests and user context. UAM copies only the idea of a versioned value-free grouping key.
- MPL, FSL and Elastic License entries make code reuse materially different from reading a design. Reference status grants no copying or dependency approval.
- Tags with only short release commits (`hcdiag`, `Glean`, `support-diagnostics`) are enough to identify the reviewed release but not enough for a package/source provenance gate; full commits and asset hashes are mandatory before any deeper admission.

---

# 15. Source register with stable links, dates, versions/commits, claims, and limitations

## 15.1 Supplied evidence register

| Ref | Source and reviewed digest/date | Claim supported | Limitation |
|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md`, SHA-256 `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a`, baseline 31 Jul 2026 | process topology, minimization, durability, realm, release, audit, receipt, restore/deletion and fallibility invariants | condensed working baseline; not production or human approval |
| I02 | `01-existing-system-evidence-summary.md`, SHA-256 `bb34186d2f936a133515644dd7e7cf18c77a2588afa14d1dbe4d94cb2ead7fa6` | legacy monolithic endpoint, direct SQL/deferred executable SQL, errors/settings/audit and broad admin mutation surface | static sanitized summary; no runtime settings, values, consumers or volumes |
| I03 | `05-decisions-contradictions-and-gates.md`, SHA-256 `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions, direct-read/backup/defer predecessor and ordered proof gates | implementation research baseline, not unconditional production approval |
| I04 | `06-research-evidence-rules.md`, SHA-256 `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence labels, source quality, human-decision and conflict rules | governs research quality; does not prove technical claims |
| I05 | `batch-01-review-result.md` local `batch-01-review-result(3).md`, SHA-256 `10d5e1e73fa7e63156ddc942c8f63156d29b7cff238ea7d4e128587b47f4c75b`, review 31 Jul 2026 | G0 canary/oracle, G1 boundaries, strict contracts, UUIDv7, privacy lattice, realm, repository/release, owner/runbook controls | accepted with mandatory conditions; runtime/human/later gates remain open |

## 15.2 Primary public sources

| Ref | Primary source and stable link | Date/version reviewed | Claim supported | Limitation |
|---|---|---|---|---|
| W01 | OpenTelemetry, [Handling sensitive data](https://opentelemetry.io/docs/security/handling-sensitive-data/) | page last modified 14 Jan 2026; reviewed 31 Jul 2026 | strongest prevention is not collecting sensitive data; Collector filter/redaction/transform options; hashing can remain reversible/linkable in predictable spaces | guidance, not UAM implementation proof |
| W02 | OpenTelemetry, [.NET metrics best practices](https://opentelemetry.io/docs/languages/dotnet/metrics/best-practices/) | last modified 19 May 2026 | .NET SDK default 2,000 cardinality per metric, View-based limit and overflow behavior | default is not UAM budget; exact package/runtime must be tested |
| W03 | OpenTelemetry, [Metrics concepts](https://opentelemetry.io/docs/concepts/signals/metrics/) | last modified 2 Jul 2026 | user IDs/raw URL paths are high-cardinality; overflow aggregation loses distinguishing attributes and can undermine alerts | explanatory documentation, not backend behavior proof |
| W04 | OpenTelemetry, [HTTP span semantic conventions](https://opentelemetry.io/docs/specs/semconv/http/http-spans/) | semantic conventions 1.43.0, reviewed 31 Jul 2026 | standard HTTP instrumentation fields, low-cardinality route rule, predictable `error.type` guidance | UAM intentionally uses a narrower profile; instrumentation implementation differs |
| W05 | OpenTelemetry, [URL attribute registry](https://opentelemetry.io/docs/specs/semconv/registry/attributes/url/) | semantic conventions 1.43.0 | URL full/path/query/original can be sensitive; original can contain credentials | registry documents attributes, not a privacy approval |
| W06 | W3C, [Trace Context](https://www.w3.org/TR/trace-context/) | Recommendation 23 Nov 2021 | interoperable `traceparent`/`tracestate` propagation | does not provide authentication, authorization or realm authority |
| W07 | W3C, [Baggage](https://www.w3.org/TR/baggage/) | Candidate Recommendation Snapshot 30 May 2024 | baggage carries application-defined properties across services | reason for UAM prohibition; spec does not itself require sensitive data |
| W08 | OpenTelemetry, [Trace SDK specification](https://opentelemetry.io/docs/specs/otel/trace/sdk/) | current spec reviewed 31 Jul 2026 | deterministic TraceIdRatio-based sampling and ParentBased composition | exact .NET behavior/load still tested |
| W09 | OpenTelemetry, [Security configuration best practices](https://opentelemetry.io/docs/security/config-best-practices/) | reviewed 31 Jul 2026 | minimize components, authenticate/encrypt, protect config, consider queues/buffers | general guidance; UAM-specific threat model is stricter |
| W10 | OpenTelemetry Collector Contrib, [`v0.157.0` release](https://github.com/open-telemetry/opentelemetry-collector-contrib/releases/tag/v0.157.0) and [tagged source](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/89e43555904cd97c2d36605347c5d5237b1bdc8c) | 21 Jul 2026; commit `89e43555904cd97c2d36605347c5d5237b1bdc8c` | current component activity; filter/transform default error mode changed to `ignore`; processors/queues/tail-sampling implementation references | contrib is large; exact custom distribution and load/security require admission |
| W11 | OpenTelemetry, [Collector distributions](https://opentelemetry.io/docs/collector/distributions/) and [custom Collector guidance](https://opentelemetry.io/docs/collector/extend/ocb/) | reviewed 31 Jul 2026 | custom distributions can select components | build/provenance/fitness remain UAM responsibility |
| W12 | OpenTelemetry .NET, [`core-1.17.0` release](https://github.com/open-telemetry/opentelemetry-dotnet/releases/tag/core-1.17.0) and [source](https://github.com/open-telemetry/opentelemetry-dotnet/tree/e432cd549a81dabfc8b1c7c346c03cdf933013f1) | 16 Jul 2026; commit `e432cd549a81dabfc8b1c7c346c03cdf933013f1` | current reviewed .NET SDK/API/OTLP release and signed immutable release activity | point-in-time; exact packages/transitives/performance/security need lock/admission |
| W13 | Microsoft Learn, [.NET source-generated logging](https://learn.microsoft.com/en-us/dotnet/core/extensions/logging/source-generation) | updated 27 Jul 2026 | `LoggerMessageAttribute` compile-time generated logging methods with event IDs/names and diagnostics | source generation does not automatically make values private |
| W14 | Microsoft Learn, [.NET data redaction](https://learn.microsoft.com/en-us/dotnet/core/extensions/data-redaction) | updated 7 Jun 2025 | erasing and experimental HMAC redactors exist | secondary defense only; exact package/status/admission and HMAC linkability remain concerns |
| W15 | Microsoft Learn, [HTTP logging in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/http-logging/?view=aspnetcore-10.0) | updated 7 Dec 2025 | middleware can log request/response properties, headers and bodies; interceptor can alter fields | configuration does not prove every sink stays safe; UAM disables broad profile |
| W16 | Microsoft Learn, [Extended HttpClient logging](https://learn.microsoft.com/en-us/dotnet/core/extensions/httpclient-logging) | updated 13 Feb 2026 | extended logging can collect query, body and route parameters | reason to keep it off; exact future behavior may change |
| W17 | Microsoft Learn, [.NET dumps](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/dumps) | updated 23 Feb 2026 | dumps may contain full process memory and sensitive information | platform capability, not estate policy evidence |
| W18 | Microsoft Learn, [Collect dumps on crash](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/collect-dumps-crash) | updated 20 Jan 2026 | .NET crash dump enablement/configuration and disabled default | enterprise environment can override; lab/startup checks required |
| W19 | Microsoft Learn, [WER user-mode dumps](https://learn.microsoft.com/en-us/windows/win32/wer/collecting-user-mode-dumps) | reviewed 31 Jul 2026 | LocalDumps is administrative configuration and can generate full dumps | does not reveal estate GPO/EDR settings |
| W20 | Microsoft Learn, [.NET diagnostic port](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/diagnostic-port) | reviewed 31 Jul 2026 | diagnostic-port mechanisms enable external diagnostics/attach | UAM ordinary production profile rejects this capability |
| W21 | NIST, [SP 800-61 Rev. 3](https://csrc.nist.gov/pubs/sp/800/61/r3/final) | final Apr 2025 | incident response integrated with CSF 2.0 risk management | process guidance, not UAM staffing/legal authority |
| W22 | W3C, [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | Recommendation 5 Oct 2023 | accessibility criteria including error identification and status messages | conformance requires technology/user testing |
| W23 | W3C WAI, [Understanding Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html) | reviewed 31 Jul 2026 | programmatic status announcements without unnecessary focus movement | explanatory guidance; portal technology and assistive-tech matrix unknown |
| W24 | RFC Editor, [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html) | Jul 2023 | standard problem-response shape | UAM still defines closed safe fields/codes and authorization behavior |
| W25 | EUR-Lex, [Regulation (EU) 2016/679](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng) | official text, 2016 | data minimization, storage limitation, security/accountability context | research does not decide legal basis, applicability or compliance |
| W26 | NIST, [SP 800-92 — Guide to Computer Security Log Management](https://csrc.nist.gov/pubs/sp/800/92/final) | Sep 2006 | log-management lifecycle and operational practices | old guidance; not modern cloud/OTel or UAM-specific proof |
| W27 | RFC Editor, [RFC 5652 — Cryptographic Message Syntax](https://www.rfc-editor.org/rfc/rfc5652.html) | Sep 2009 | CMS EnvelopedData and signed/enveloped content framework | does not select algorithms, certificate/key operations or UAM profile |
| W28 | RFC Editor, [RFC 5084 — AES-CCM and AES-GCM in CMS](https://www.rfc-editor.org/rfc/rfc5084.html) | Nov 2007 | authenticated-encryption algorithm identifiers for CMS | exact modern implementation/compliance/interoperability must be tested |
| W29 | RFC Editor, [RFC 9180 — HPKE](https://www.rfc-editor.org/rfc/rfc9180.html) | Feb 2022 | modern hybrid public-key encryption framework | dependency/key distribution/enterprise operations are unresolved |
| W30 | OpenTelemetry Semantic Conventions, [`v1.43.0` release](https://github.com/open-telemetry/semantic-conventions/releases/tag/v1.43.0) and [source](https://github.com/open-telemetry/semantic-conventions/tree/89aae438b3b3b0a8dd33003c9d70592baf7dbd0d) | 3 Jul 2026; commit `89aae438b3b3b0a8dd33003c9d70592baf7dbd0d` | current reviewed semantic-convention release | semantic conventions are not UAM field authority |
| W31 | OpenTelemetry, [Logs Data Model](https://opentelemetry.io/docs/specs/otel/logs/data-model/) | current spec reviewed 31 Jul 2026 | timestamp, observed time, trace/span, severity, body, attributes, event name model | UAM omits/freezes many generic fields |
| W32 | OpenTelemetry, [SDK environment-variable configuration](https://opentelemetry.io/docs/specs/otel/configuration/sdk-environment-variables/) | current spec reviewed 31 Jul 2026 | default propagator list can include `tracecontext,baggage` | UAM explicitly configures tracecontext only and does not trust defaults |
| W33 | Microsoft, [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | reviewed 31 Jul 2026; .NET 10 active LTS, 10.0.10 dated 14 Jul 2026, support to 14 Nov 2028 | point-in-time implementation family/lifecycle input | exact patch is not timeless architecture; recheck at execution |
| W34 | Replicated, [Troubleshoot `v0.131.1`](https://github.com/replicatedhq/troubleshoot/releases/tag/v0.131.1) | 10 Jul 2026; commit `b279b2bef9cbad8e5ad36df2a91dd5a3488f79e0` | active support-bundle/schema/test reference | Kubernetes/general collector threat model differs; no dependency approval |
| W35 | HashiCorp, [hcdiag `v0.5.13`](https://github.com/hashicorp/hcdiag/tree/v0.5.13) | release 27 May 2026; short release commit `a9c30a1` | dry-run/transparency/runner/redaction reference | arbitrary commands and regex redaction unsuitable; full commit not captured |
| W36 | Mozilla, [Glean `v69.0.0`](https://github.com/mozilla/glean/releases/tag/v69.0.0) | 22 Jun 2026; short release commit `566b08e` | typed telemetry/storage migration and self-metric reference | different platform/product policy; full commit not captured |
| W37 | Sentry, [`26.7.2` release](https://github.com/getsentry/sentry/releases/tag/26.7.2), [source](https://github.com/getsentry/sentry/tree/a8da553fe6f01f51cb05d253c641d2a074e38484), and [licensing](https://open.sentry.io/licensing/) | 28 Jul 2026; commit `a8da553fe6f01f51cb05d253c641d2a074e38484` | versioned grouping/fingerprint reference and current activity | FSL web-app license; raw stack/request/user threat model and high operational cost mismatch |
| W38 | Elastic, [support-diagnostics `v9.4.1`](https://github.com/elastic/support-diagnostics/releases/tag/v9.4.1) and [Elastic License 2.0](https://github.com/elastic/support-diagnostics/blob/v9.4.1/LICENSE.txt) | 2 Jul 2026; short release commit `ebab5af` | mature broad support-diagnostics lifecycle reference | restricted license, broad credentials/files/commands; no dependency fit; full commit not captured |
| W39 | OpenTelemetry, [Collector release distribution `v0.157.0`](https://github.com/open-telemetry/opentelemetry-collector-releases/releases/tag/v0.157.0) | 22 Jul 2026 | official packaged Collector distribution point | UAM should build/attest a minimal custom distribution, not assume full package fitness |

## 15.3 Source-quality conclusions

1. Primary standards and vendor documentation establish capabilities and risks, not UAM fitness. Every load-bearing operational claim has a CLI/lab gate.
2. OpenTelemetry conventions are intentionally broad. UAM adopts the signal transport/model but defines a narrower privacy profile.
3. Redaction, hashing, sampling, cardinality overflow, queues and dumps all have failure modes; none replaces source minimization.
4. Repository popularity is not evidence. Exact revision, license, tests, security posture, threat-model fit and removal path decide suitability.
5. The unlisted Batch 02 result was not used. Cross-batch semantic consistency remains a named reviewer gate.

---

# 16. Confidence table for every major conclusion

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Diagnostics must never collect raw activity/identity values | **High** | direct accepted minimization invariant and current OTel guidance; simplest containment | only an explicit accepted-baseline change with stronger primary evidence and human authority; not an ordinary support request |
| Closed compile-time telemetry catalogue is required | **High** | converts privacy/cardinality/ownership/compatibility into executable rules | proof that an equally strict simpler mechanism prevents every mutation with lower cost |
| Source generation is useful but not sufficient alone | **High** | Microsoft documents generated methods, but values remain developer-controlled | a language/runtime feature that enforces semantic data classes end-to-end |
| Coordinator-only endpoint persistence/export is the right direction | **High** | matches accepted process boundary and minimizes sinks | hostile/runtime evidence that it creates an invariant conflict and a safer alternative passes |
| Diagnostic transaction must remain separate from event/cursor/outbox | **High** | protects accepted durability and prevents support failure from changing business state | formal/CLI evidence for a shared transaction with no blocking/retry/cursor risk and explicit ADR |
| Finite error taxonomy and value-free fingerprints are sufficient for routing/grouping | **Medium-High** | supports owner/retry/runbook without text/stack; Sentry-like grouping patterns show versioning value | blind support challenge fails or semantic collisions prevent defined diagnosis; improve only with safe tuple fields |
| Raw exception messages/stacks must be excluded | **High** | common source of paths/inputs/secrets; dumps/stacks expand exposure | no expected ordinary change; synthetic lab remains separate |
| Explicit low cardinality budgets and zero normal overflow are required | **High** | OTel documents memory pressure and information loss; UAM has no need for per-target labels | measured approved need with a finite higher catalogue bound |
| Bootstrap cardinality numbers are correct | **Low** | estimates without real rates/backend/resource budgets | E13-04/E13-17 plus human approval replaces them |
| Endpoint traces should be off at D0 | **Medium-High** | low support benefit relative to correlation/volume on offline endpoints | safe trace prototype materially improves blind diagnosis within resource/privacy budget |
| Server head sampling and tracecontext-only profile are sound | **High for profile; Low for rate** | standard deterministic sampling and minimal propagation; baggage arbitrary | load/support evidence changes rate; interop ADR may add tightly bounded tracestate |
| Tail sampling should be deferred | **Medium-High** | buffering/routing/overload complexity and no proved need | measured rare-error diagnostic value and safe routing/load proof |
| Generic HTTP logging/auto-instrumentation should be disabled | **High** | official features/conventions can collect paths, queries, headers, bodies and addresses | exact module profile proves only UAM safe attributes across versions |
| Automatic endpoint dumps/attach should be off | **High** | official docs say dumps can contain full memory; conflicts with support-bundle scope | separate forensic baseline change, not this diagnostics design |
| Deterministic hash/count/status/version support bundles are the right model | **High** | directly satisfies minimization and makes collection reviewable/testable | defined-failure challenge shows a missing safe projection; add that projection through ADR rather than raw data |
| Suggested bundle size/time limits are correct | **Low** | bootstrap hypotheses only | measured bundle distributions, impact and backend/network budgets |
| D0–D2 permit model and D3 prohibition are correct | **High** | preserves privacy ceiling, target/realm/time bounds and no arbitrary channel | formal counterexample or stronger simpler authorization composition |
| Revocation watchdog prototype value is correct | **Low** | unmeasured estimate | control-path/offline tests and risk-owner objective |
| CMS or HPKE can satisfy bundle encryption | **Medium** | both are established standards with suitable properties | implementation/interoperability/key operations/compliance tests may reject one or both |
| Exact crypto/key profile is ready for production | **Low** | KMS/HSM/PKI/recovery/rotation/compliance and backend unknown | accepted crypto ADR and incident drill |
| OpenTelemetry .NET is a suitable dependency family | **Medium-High** | current active release, .NET fit and broad test ecosystem | admission/performance/security/backend failure or unsupported lifecycle |
| Minimal custom Collector is preferable to full contrib | **High** | smaller component/config/attack surface and observed default drift | operations evidence shows custom build cost exceeds a safer direct-export design |
| Collector redaction can be only a backstop | **High** | source minimization must precede transport; config can fail/change | no expected change |
| Realm must be out-of-body authorization context, not telemetry label | **High** | direct accepted realm invariant and cardinality/correlation containment | new accepted tenancy architecture with equal isolation proof |
| Case-scoped controlled access is safer than bulk/download | **High** | reduces cross-realm and uncontrolled-copy risk | approved support workflow demonstrates a bounded download need with equal controls |
| Runbooks and owner assignment are blocking | **High** | unowned fail-closed systems invite unsafe workarounds; predecessor already requires owner/support functions | demonstrated automated recovery eliminating the human path for a specific failure, with approved governance |
| Blind support challenge is a valid primary gate | **High** | directly tests the requested outcome without raw data | challenge fails to model a critical approved support requirement; update the defined set/oracle |
| Accessibility belongs in diagnostics acceptance | **High** | support/admin users must understand safe error and state distinctions; WCAG provides primary criteria | portal/UI removed from scope entirely; API semantics still need clarity |
| Research can approve retention, access, backend, staffing or communication | **High confidence that it cannot** | explicit human-decision boundary in prompt and supplied evidence | only designated accountable authorities can decide |
| This result is fully reconciled with Batch 02 | **Low** | exact allowlist did not authorize Batch 02 | explicitly authorized scoped cross-review with no unresolved conflicts |
| Technical pass equals production approval | **High confidence that it does not** | human and later proof gates remain open | only designated production/risk authority after all applicable gates |

---

# Final residual risk and next stop/go gate

**Residual risk.** Even after all technical tests pass, UAM cannot prove that every operating-system, EDR, hypervisor, backup, browser, remote-support or human workflow never captures process memory or screen content. It cannot prove a finite scanner recognizes every future encoding or sink. Rare finite error groups can still aid correlation if access is broad. Fail-closed diagnostics can leave difficult incidents unresolved, and operators can make unsafe requests outside the product. Observability dependencies and backend defaults can change. Encryption protects custody but does not prevent an authorized recipient from mishandling plaintext. Deletion can remain delayed by approved backups or legal hold. Research cannot establish lawful purpose, access legitimacy, retention, communication, staffing, budget, SLOs or production competence.

**Blocked dependencies.** Batch-final acceptance is blocked by the explicitly authorized Batch 02 cross-review, owner assignments, telemetry catalogue/analyzer mutations, all-sink canaries, cardinality/resource proof, Windows dump/cleanup evidence, deterministic bundle and crypto interoperability, permit expiry/revocation, realm/case isolation, backend access/deletion evidence, blind support challenge, runbook drills, load/cost/skills evidence, and the named human decisions.

**Next stop/go gate — G13 privacy-safe supportability.**

**GO** only when an immutable `g13-diagnostics-gate.json` binds the exact source tree, five allowlisted inputs, authorized Batch 02 review, catalogue/config/permit/recipe/crypto/backend versions, owners, ADRs, experiments, canary positive controls, resource/cost results, accessibility evidence and cleanup/deletion receipts, and the primary acceptance expression is true.

**STOP** on any forbidden value or reversible derivative outside its allowed T1 source; any unregistered event/attribute; dynamic metric label or normal overflow; baggage/unsafe HTTP attribute; endpoint production dump or diagnostic attach; diagnostic-caused business-state change; invalid/expired/revoked permit activation; cross-realm discovery/access/mutation; unlisted bundle read or command; plaintext residue; wrong-target decryption; premature custody receipt; silent truncation; defined failure requiring raw production data; raw support request; misleading custody/deletion state; missing owner; or unresolved evidence conflict.

There is no silent risk acceptance through code, configuration, a “temporary debug” flag, support custom command, scanner waiver, expired exception, or operator convenience.
