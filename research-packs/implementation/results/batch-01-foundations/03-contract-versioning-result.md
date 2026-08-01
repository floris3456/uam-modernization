# UAM contract, compatibility, and versioning strategy

**Research date:** 31 July 2026  
**Result status:** Decision-ready implementation research; not production approval  
**Batch:** 01 — Immediate pre-implementation foundations  
**Primary gate:** **No component integration begins without a versioned contract, accountable owner, size limits, compatibility rule, and explicit rejection behavior.**

## Evidence labels

- **FACT** — directly supported by an allowed supplied source or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proven.
- **INFERENCE** — reasoned from facts; the reasoning is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority is required.
- **CLI EXPERIMENT** — the claim must be established by code, lab work, or measurement.

Normative words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** use the meanings in BCP 14 (RFC 2119 and RFC 8174). Proposed normative rules become binding only after the corresponding ADR is accepted.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision in plain language

**RECOMMENDATION — High confidence.** UAM should treat every boundary as a separately owned, versioned protocol. It should not pass shared C# DTOs from endpoint collection through endpoint storage, server persistence, portal views, and external integrations. The wire format for the first implementation should be strict UTF-8 JSON, described by JSON Schema Draft 2020-12 and, for HTTP APIs, OpenAPI 3.1.2. A short UAM Contract Standard must provide the rules that schemas cannot express: trust source, privacy state, receipt meaning, version compatibility, rollout order, limits, error handling, signing, lifecycle, and ownership.

The simplest workable control plane is a **Git-backed immutable contract catalogue plus CI**, not a network schema-registry service. A runtime registry adds authentication, authorization, availability, import/parser, and operational failure modes before UAM has measured a need for it. Published schema identifiers remain stable HTTPS URIs, but builds and production validators resolve only pinned local bundles; they do not fetch schemas from the network.

UAM should be deliberately strict:

1. Reject duplicate JSON member names, unknown fields, wrong case, implicit defaults, invalid nulls, out-of-range numbers, unsupported versions, over-limit payloads, remote references, and malformed compression.
2. Permit forward extension only at explicitly named, namespaced, bounded extension points. Privacy-bearing endpoint event payloads should have no generic extension bag.
3. Roll consumers before producers. A producer may emit a new representation only after every required consumer proves it can accept it. “Additive” is not automatically forward-compatible when old consumers reject unknown fields.
4. Keep the current producer path available during rollout. Rollback means switching production back while consumers continue dual-reading; it does not mean interpreting new semantics as old semantics.
5. Return a server receipt only after the declared durable inbox transaction commits. The receipt means custody, not validation, materialization, portal visibility, or downstream delivery.
6. Derive realm and installation/device identity from authenticated server context, never from tenant or device claims inside a batch.
7. Require executable old/new producer-consumer matrices and canonical golden vectors. Schema diff tools and generated clients are supporting evidence, not the compatibility oracle.
8. Measure JSON plus gzip with seeded synthetic data before considering a binary encoding.

## 1.2 Temporary compatibility default pending human approval

**HUMAN DECISION.** The organization must approve compatibility duration and rollout policy. Until that occurs, the conservative temporary default is:

- endpoint-to-server ingress and local endpoint IPC consumers support the current and immediately previous **major** contract versions;
- a consumer is deployed before a producer for every minor or major change;
- retirement is not calendar-automatic: it requires explicit approval plus observed evidence that no supported producer or named external consumer still depends on the version;
- external commitments are per named integration and are not inferred from internal rules;
- patches do not change accepted wire instances or semantic behavior.

This temporary default limits indefinite complexity while preserving one rollback generation. It is not a commitment to a customer or external consumer.

## 1.3 Why this fits UAM

**FACT.** The accepted baseline requires endpoint minimization before Coordinator IPC, durable storage, diagnostics, or transport; at-least-once delivery with idempotent business effect; bounded versioned authenticated compressed HTTPS batches; a relational durable inbox; explicit received/validated/materialized/quarantined/visible states; authenticated realm/device derivation; and staged migration. These are protocol invariants, not implementation details.

**INFERENCE.** A permissive, shared-object design would make those invariants difficult to review and easy to bypass. A strict contract at each trust/privacy boundary makes failure visible and containable: bad messages stop at a known boundary, exact versions can be killed, old readers can remain during rollback, and privacy-bearing data cannot silently acquire extra fields.

## 1.4 Confidence and residual risk

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| Strict JSON plus JSON Schema/OpenAPI is the correct first wire stack | High | Standards are mature; .NET has strict parsing controls; UAM needs auditable bounded messages more than encoding density | Reproducible JSON/gzip measurements fail an approved CPU, latency, bandwidth, or disk budget while a binary prototype materially passes without unacceptable tooling/security cost |
| Git-backed catalogue is preferable to a runtime schema registry initially | High | UAM has no proved runtime discovery/fan-out need; registry software carries a substantial attack and operations surface | Measured multi-team deployment evidence shows local bundles cannot meet release independence, compatibility governance, or emergency distribution requirements |
| Consumer-first, dual-read rollout is required | High | Strict readers make producer-first additive changes unsafe; rollback requires old and new read paths | A formally constrained self-describing evolution mechanism is proved across every required consumer and preserves privacy/security semantics |
| Current/previous major is a safe temporary window | Medium | It preserves one rollback generation and bounds complexity | Fleet rollout duration, long-offline distributions, customer commitments, or support data show a broader or narrower window is necessary |
| JCS/JWS should be limited to signed control artifacts at first | Medium | It gives deterministic signatures where authorization matters without burdening every data message | Threat analysis or custody requirements prove application-layer non-repudiation for batches is necessary, and key operations can support it safely |
| Binary encoding should remain measurement-gated | High | No representative size/CPU distributions or failed JSON budget exist | The mandatory synthetic and later metadata-safe measurements meet the binary-evaluation trigger |

**Residual risk.** Research cannot prove Windows IPC isolation, parser behavior under adversarial inputs, durability across power loss, fleet rollout timing, human support competence, external consumer behavior, or acceptable size/performance limits. Contract strictness also creates operational cost: old endpoints may be rejected rather than silently tolerated; emergency version freezes must be practiced; and dual readers increase test surface. Signed policies can still be mis-issued by an authorized human, and a valid schema cannot prove a field is lawful or semantically correct.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 Scope

This result defines implementation-level contract architecture for:

- collector invocation and results inside the user/session boundary;
- privacy transformation and the point at which data becomes Coordinator-readable;
- local Windows IPC;
- product privacy ceiling, tenant policy, and effective-policy artifacts;
- minimized local events and endpoint persistence records;
- upload batches, durable custody receipts, and later processing status;
- quarantine metadata and controlled remediation;
- endpoint/server health messages;
- administrative commands, audit records, and privileged results;
- governed server-side integrations;
- deletion requests, tombstones, application state, and evidence;
- serialization, schema identity, limits, canonicalization, hashing/signing, errors, observability, rollout, rollback, deprecation, and support.

It also defines the minimum repository structure, tests, CLI evidence, fitness functions, and stop gates needed before integration work.

## 2.2 Non-goals

This result does **not**:

- decide business meaning, legal purpose, prohibited uses, identity level, retention, access policy, employee consultation, SLO/RPO/RTO, budget, production ownership, or approval;
- finalize event fields, timestamp precision, first-run lookback, application matching semantics, or role mappings;
- select production database engine, indexes, partitions, portal framework, broker, audit-store technology, device PKI, TPM use, or endpoint encryption/key wrapping;
- redesign the accepted Coordinator/User Host/Task Host topology, endpoint outbox, durable server inbox, modular monolith, deployment boundary, or first Edge slice;
- claim that an OpenAPI document or generated DTO captures business semantics, authorization rules, privacy compliance, or transaction behavior;
- require a runtime schema registry, external broker, binary serialization, consumer contract broker, or autonomous updater;
- use raw production activity, internal addresses, credentials, SSH material, personal data, or confidential catalogue values in examples or tests.

## 2.3 Accepted supplied inputs

| Input | Accepted fact used here | Limitation |
|---|---|---|
| Shared accepted baseline, dated 31 July 2026 | Endpoint/session topology; privacy ceiling; pre-IPC minimization; SQLite WAL one-writer; at-least-once delivery; durable receipt semantics; modular monolith; governed integrations; human-decision boundaries; non-negotiable invariants | Working implementation baseline, not production approval or runtime proof |
| Decisions, contradictions, and proof gates | Ordered proof gates G0–G5 and subsequent release, identity/network, inbox, capacity, outage, deletion/restore gates | A passed gate proves only its stated claim |
| Data and schema evidence summary | Separation of device, installation, session, source, cursor, event, batch, receipt, policy, health, audit, deletion, and integration concepts; authenticated realm/device derivation; processing-state distinctions | No representative volumes, retention, RPO/RTO, or engine benchmark |
| Research evidence rules | Evidence labels, source-quality rules, prohibited evidence, and human authority limits | Rules govern research quality; they do not prove a technical capability |

No supplied evidence requires changing an accepted baseline decision. Therefore this result contains no baseline change proposal.

## 2.4 Assumptions

- **ASSUMPTION.** C#/.NET remains the implementation family and the execution-time baseline selects a supported .NET release under lifecycle policy. On 31 July 2026, .NET 10 LTS is supported; exact patch selection remains release automation, not architecture.
- **ASSUMPTION.** Endpoint and server components can ship generated or copied immutable schema bundles with their binaries.
- **ASSUMPTION.** HTTP ingress can reject unsupported media, version, syntax, digest, and hard size limits before issuing a custody receipt.
- **ASSUMPTION.** A relational transaction can atomically insert inbox content, authenticated tenancy metadata, content digest, idempotency identity, and receipt record in the declared durable failure domain.
- **ASSUMPTION.** The first slice uses only synthetic fictional domains, application names, subjects, realms, devices, and identifiers until governance permits otherwise.
- **ASSUMPTION.** Privileged control artifacts can be distributed with a repository-authorized signing and key-rotation process, but the exact enterprise key service is not selected here.

## 2.5 Unknowns and why they matter

| Unknown | Contract impact | Required resolution |
|---|---|---|
| Approved business semantics and exact event fields | Determines required/optional fields, enums, source precision, and privacy classification | Human field dictionary plus purpose/privacy approval before active schema |
| Longest offline and rollout distributions | Determines supported-version overlap and retirement evidence window | Metadata-safe fleet measurement and deployment-owner decision |
| Batch/event/health size and rate distributions | Determines safe caps, compression, timeouts, allocation budgets, and whether JSON remains fit | Seeded synthetic tests followed by approved metadata-only measurement |
| External consumers and commitments | Determines consumer-specific schemas, version windows, notice, and test ownership | Named-consumer inventory and signed service/contract decision |
| Exact device authentication and proxy/VPN behavior | Determines authenticated context and HTTP retry/error mapping | Device/network lab gate and security architecture decision |
| Signing key service, algorithm profile, rotation, and emergency revocation | Determines signed-policy envelope and runbook | Security/key-management decision and recovery drill |
| Deletion scope, retention, restore order, and legal proof | Determines tombstone fields and lifecycle | Governance decision plus deletion/restore prototype |
| SLO/RPO/RTO and support staffing | Determines time budgets, compatibility alerting, and runbook response | Human operational decision |
| Production database engine | May change transaction/error details but not the wire contracts | Identical benchmark and restore evidence |
| Portal language/localization requirements | Determines human-facing error text and localization catalogue | Accessibility/product decision; stable machine codes are unaffected |

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Architecture overview

**RECOMMENDATION.** Use four contract planes with adapters between them:

```text
User/session private plane
  Collector -> candidate result -> privacy transform
       |  (raw candidate never leaves this plane)
       v
Endpoint minimized plane
  User Host -> session-scoped IPC -> Coordinator -> local event/outbox
       |
       v authenticated HTTPS + bounded gzip JSON
Server custody/processing plane
  Ingress -> durable inbox/receipt -> validator -> materializer/quarantine
       |
       v
Control and integration plane
  BFF/admin + audit + deletion + narrow external adapters
```

Every arrow is a named contract. No domain or persistence object crosses an arrow directly.

## 3.2 Trust and privacy boundaries

| Boundary | Sender trust | Receiver action | Data allowed | Hard rule |
|---|---|---|---|---|
| Collector → privacy transformer, same restricted process/session | Untrusted collector logic and source data | Parse bounded candidate, transform/minimize, discard candidate | Source-specific transient values needed to produce approved minimized output | Candidate **MUST NOT** enter Coordinator IPC, durable storage, logs, traces, crash attachments, or network |
| User Host/Task Host → Coordinator named pipe | Ordinary user/session process; not trusted as machine authority | Authenticate pipe peer/session, validate exact contract and limits, accept only minimized event/result | Product-ceiling-compliant minimized data and bounded diagnostics | Coordinator **MUST NOT** crawl profiles or accept raw source records |
| Coordinator → local SQLite | Coordinator process | One-writer transaction validates and commits event plus source progress | Minimized typed events, cursors, batches, receipts, bounded health | Cursor **MUST NOT** advance ahead of durable events |
| Endpoint → ingestion HTTPS | Authenticated installation/device context, payload still untrusted | Authenticate, derive realm/device, enforce media/version/size/digest/syntax, durably accept | Bounded minimized batches | Payload realm/device claims **MUST NOT** establish tenancy |
| Ingress → durable inbox | Ingress code and database transaction | Commit content, auth context, digest, idempotency identity, receipt | Known supported envelope only | Receipt **MUST NOT** precede durable commit |
| Inbox worker → typed domain | Stored bytes are still untrusted | Validate full schema/semantics/policy provenance; materialize or quarantine | Valid facts and controlled failure metadata | Quarantine **MUST NOT** expose rejected payloads through normal admin surfaces |
| Control API/BFF → privileged domain | Authenticated operator but request untrusted | Authorize, validate, require concurrency token/reason, atomically audit | Narrow commands and safe results | Privileged mutation **MUST NOT** commit without durable audit evidence |
| Server domain → external integration adapter | Internal domain trusted only within its realm | Project into consumer-owned contract; redact/minimize; enforce egress authorization | Explicitly approved export/import fields | No database table or internal DTO is an integration contract |
| Deletion controller → all stores/restore path | Authorized governed command | Apply tombstone/proof state before visibility | Stable target identifiers and status, no unnecessary deleted content | Restore **MUST NOT** make tombstoned data visible before deletion state is replayed |

## 3.3 Components and exact responsibilities

### 3.3.1 Contract Authority repository module

**Accountability function:** `UNASSIGNED — human must name an accountable contract authority.`

Responsibilities:

- maintain the UAM Contract Standard, catalogue manifest, JSON Schemas, OpenAPI documents, examples, golden vectors, compatibility declarations, deprecation records, and change log;
- assign immutable contract names and identifiers;
- enforce lifecycle transitions and owner assignment;
- produce deterministic schema bundles with a manifest and SHA-256 digests;
- run meta-schema validation, lint, compatibility diff, reference closure, code-generation reproducibility, license/SBOM, and old/new matrices;
- block remote `$ref`, cyclic expansion beyond policy, unbounded arrays/maps/strings, generic privacy extension bags, and undocumented nullable/default behavior;
- never act as a runtime network dependency in the initial design.

Suggested repository shape:

```text
/contracts/
  STANDARD.md
  catalogue.json
  metaschema/uam-contract-metadata.schema.json
  endpoint/<family>/<major>/<name>-<version>.schema.json
  ingestion/<family>/<major>/<name>-<version>.schema.json
  control/<family>/<major>/<name>-<version>.schema.json
  integration/<consumer>/<family>/<major>/<name>-<version>.schema.json
  openapi/ingestion-v1.openapi.json
  openapi/control-v1.openapi.json
  vectors/<contract>/<version>/{valid,invalid,canonical}/
  compatibility/<contract>/matrix.yaml
  deprecations/
  bundled/<release-id>/manifest.json
/tools/Uam.Contracts.Cli/
/tests/Uam.Contracts.*
```

### 3.3.2 Endpoint contract adapters

**Accountability function:** `UNASSIGNED — endpoint boundary owner.`

- `CollectorAdapter` creates only a bounded transient candidate inside User Host/Task Host.
- `PrivacyTransformer` is the only code allowed to map candidate data into a Coordinator-readable minimized contract.
- `IpcAdapter` authenticates the pipe peer and session, negotiates supported exact versions, frames messages, enforces time/length limits, and maps errors.
- `LocalEventAdapter` converts minimized IPC messages to endpoint domain commands; it does not expose SQLite rows.
- `OutboxAdapter` serializes the active upload contract from domain events and keeps stable event/batch identities across retries.
- `ReceiptAdapter` verifies the receipt contract and atomically applies it to local batch state.

### 3.3.3 Server ingestion adapters

**Accountability function:** `UNASSIGNED — ingestion boundary owner.`

- `HttpEnvelopeGate`: TLS/auth context, route major, content type/encoding, compressed and uncompressed caps, header caps, digest, UTF-8, duplicate-member rejection, root envelope shape, exact version support.
- `CustodyWriter`: one transaction inserts immutable request content or content-addressed reference, server-derived realm/installation, digest, batch identity, receipt identity, received time, and initial state.
- `ReceiptPresenter`: returns only after commit; on retry with same batch ID and digest, returns the original or equivalent receipt; same ID with different digest returns conflict and security signal.
- `SemanticValidator`: validates full contract, event identities, policy/source provenance, data-quality constraints, and permitted version.
- `Materializer`: maps valid messages to internal domain commands/facts; it never reuses wire DTOs as persistence entities.
- `QuarantineManager`: stores bounded reason metadata and a protected evidence pointer under separate authorization; normal metrics and user interfaces contain no rejected payload.

### 3.3.4 Control, audit, integration, and deletion adapters

**Accountability functions:** `UNASSIGNED — control/audit owner`, `UNASSIGNED — each named integration owner`, and `UNASSIGNED — deletion/restore owner`.

- Control adapters use explicit command/result contracts, optimistic concurrency tokens, stable error codes, reason codes, and durable audit coupling.
- Audit records are append-oriented and contain action identity, authenticated actor reference, realm, target reference, outcome, policy/revision, time, and correlation—not raw activity payload.
- Each external consumer has a separate projection schema, compatibility policy, owner, endpoint, auth, and redaction review. No “enterprise integration DTO” is shared across consumers.
- Deletion uses request, tombstone, application-status, and completion-evidence contracts. Tombstones are applied before restored material becomes visible.

## 3.4 Preventing shared DTO coupling

**RECOMMENDATION — normative architecture rule.** Define separate assemblies and forbid references that collapse boundaries:

```text
Uam.Contracts.Endpoint.*       generated/handwritten wire-only types
Uam.Contracts.Ingestion.*      HTTP wire-only types
Uam.Contracts.Control.*        BFF/control wire-only types
Uam.Contracts.Integration.*    one package per named consumer
Uam.Endpoint.Domain            no server or transport references
Uam.Server.Domain              no endpoint, portal, persistence, or generated-client references
Uam.*.Persistence              database records/entities only
Uam.Portal.ViewModels          accessibility/localization-oriented views only
Uam.*.Adapters                 the only mapping layer
```

Rules:

- wire types **MUST NOT** carry ORM annotations, database column names, UI localization attributes, or cross-consumer convenience fields;
- persistence entities **MUST NOT** be returned by APIs;
- portal view models **MUST NOT** be deserialized from endpoint input;
- external clients **MUST NOT** reference internal contract packages or tables;
- generated code **MUST** be confined to an adapter package and rebuilt deterministically from pinned tools;
- domain types **MUST** encode business invariants independently of transport presence/nullability;
- mapping tests **MUST** prove that forbidden source fields cannot be projected across the privacy boundary.

An architecture test must fail when a forbidden assembly reference, namespace, attribute, or public type exposure appears.

## 3.5 Configuration ownership, feature flags, and kill switches

| Configuration | Authority | Distribution | Safe default | Required controls |
|---|---|---|---|---|
| Product privacy ceiling | Release-authorized product governance and signing authority; exact people are a human decision | Signed immutable control artifact | Deny unlisted source/field/transformation/destination/capability | Signature, version monotonicity, expiry/not-before policy, rollback authorization, audit |
| Tenant policy | Tenant-authorized server control function | Signed or authenticated versioned policy scoped to realm | Narrow ceiling; never widen | Effective-policy proof, realm binding, revision, audit |
| Supported contract versions | Contract authority plus release authority | Signed release manifest and local bundle | Only compiled/tested versions | No remote discovery; downgrade prevention; emergency block list |
| Producer activation | Release/deployment control | Versioned flag scoped by cohort/realm/component | Old producer remains active | Consumer-ready prerequisite, staged percentage/cohort, rollback path |
| Contract kill switch | Incident authority; exact owner is human decision | Signed emergency manifest | Deny affected exact version/capability | Expiry, reason, incident ID, two-person or equivalent policy if approved, durable audit |
| Parser/resource limits | Component owner under contract ADR | Compiled defaults; controlled narrowing at runtime | Conservative hard cap | Runtime cannot increase above release ceiling without new release/ADR |
| Observability sampling | Operations/privacy owners | Server/endpoint config | No payload capture | Bounded labels, protected logs, expiry, audit for diagnostic elevation |

A flag may select an already released and tested behavior. A flag **MUST NOT** silently redefine field semantics, bypass schema validation, widen privacy, turn a nullable field into required, change identity scope, or create an unversioned protocol. Such changes require a contract version.

## 3.6 Secure coding and review requirements

- Two independent reviews are required for privacy-boundary mappings, tenancy derivation, receipt transaction logic, signature verification, deletion/restore ordering, and compatibility exceptions.
- Parsers must use explicit options, never framework defaults: reject duplicate properties, comments, trailing commas, unknown members, invalid UTF-8, excessive depth, non-canonical identifiers, and unapproved number handling.
- Schema and OpenAPI resolution must be offline and allowlist-based. No production or CI validator may fetch arbitrary HTTP(S), file, UNC, package, or other references from a submitted schema.
- Deserialization must not instantiate polymorphic runtime types from an untrusted type name. Unions use explicit discriminator values with closed mappings.
- Compression is streamed through compressed-byte, expanded-byte, ratio, time, and cancellation limits before JSON materialization.
- Error handlers must never echo offending values, whole JSON paths containing private keys, payload fragments, auth tokens, or raw source content.
- Fuzzing corpus, parser differentials, and dependency advisories are release inputs. A parser/library update is not “patch-only” if acceptance behavior changes.
- Code generators run in isolated CI with pinned digest/version, locked dependencies, deterministic outputs, and reviewable generated diffs.

## 3.7 Privacy-safe observability and cardinality

**RECOMMENDATION.** Metrics may label only bounded enumerations such as `contract_family`, `contract_major`, `component`, `stage`, `outcome`, `error_class`, `retry_class`, and `compression`. They **MUST NOT** label realm, tenant, user, subject, device, installation, session, event, batch, receipt, policy revision, URI/domain, application name, exception message, or arbitrary schema/error path.

High-cardinality correlation identifiers belong only in access-controlled structured logs with an approved retention, pseudonymization where feasible, and no payload. A trace span must not include event bodies or source values. Diagnostic elevation must be time-bounded, realm-scoped, audited, and unable to disable the product privacy ceiling.

**ESTIMATE/CLI EXPERIMENT.** Bootstrap series ceilings are 500 active metric series per endpoint process and 5,000 per server module instance. These are engineering guardrails, not capacity facts. CI calculates the Cartesian upper bound from every label enum; load tests measure actual series. Exceeding the approved bound blocks release.

## 3.8 Support, incident response, skills, cost, and operations

Each active contract family must have a named support function and a runbook covering detection, containment, rollback, replay, quarantine, version block, evidence preservation, cleanup, and customer/operator communication authority. Required operational views are aggregate and privacy-safe:

- accepted/rejected by family and major;
- unsupported-version count by component release cohort, not device ID in metrics;
- custody-to-validation and validation-to-materialization lag;
- duplicate and batch-ID/digest-conflict counts;
- quarantine reasons by bounded code;
- old-version producer/consumer population from protected inventory, not public metric labels;
- signature/key/expiry failures;
- contract kill-switch state and expiry.

**INFERENCE.** The proposed stack uses common C#/.NET, JSON, HTTP, JSON Schema, OpenAPI, Git, and relational transactions; this is likely cheaper to staff and operate than adding a registry service, broker, binary compiler, and contract broker. The actual staffing, licensing, incident burden, and hosted-service cost remain **UNKNOWN** until the repository prototypes and operational ownership are reviewed.

## 3.9 Accessibility within this topic

Human-facing contract errors and quarantine/control views should target WCAG 2.2 AA where applicable. Stable machine codes are primary; localized plain-language explanations are secondary. Status must not rely on color alone; keyboard and focus behavior must work; asynchronous validation/quarantine changes must be announced accessibly; tables need meaningful headers; and copyable correlation references must have text labels. Accessibility text never substitutes for the machine contract and must not reveal rejected payload content.

---

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Current decision | Rejection reason now | Condition that would change the choice |
|---|---|---|---|
| Permissive JSON readers that ignore unknown fields | Reject | Hides typos, allows accidental privacy expansion, makes producer-first changes appear safe, and creates parser differentials | Only inside an explicitly bounded namespaced extension point whose contents cannot affect authorization, privacy, storage, identity, routing, or metrics |
| One shared DTO/domain/persistence model | Reject | Couples rollout and storage; leaks persistence/UI concerns into wire; makes external commitments accidental | None for cross-boundary use; small private in-process models may be shared within one bounded component only |
| Protobuf, MessagePack, CBOR, or another binary encoding from day one | Defer | No failed JSON/gzip budget; adds schema/compiler/toolchain and debugging complexity; may not reduce total operational cost | Reproducible JSON/gzip gate fails an approved budget and a binary candidate passes size, CPU, memory, fuzzing, versioning, security, licensing, and support gates |
| Runtime schema-registry service | Reject initially | Adds a production dependency and a broad parser/import/auth/availability attack surface without proved runtime discovery need | Multiple independently released producer/consumer teams cannot meet governance or emergency distribution needs using signed local bundles, as shown by measured incidents or lead time |
| AsyncAPI and broker-first contracts | Defer | Initial architecture has no broker by default; HTTP plus relational inbox is accepted | An ADR adds a broker after measured failure-domain, throughput, replay, fan-out, or cost triggers; then define broker-specific envelopes and AsyncAPI if tool support passes |
| OpenAPI 3.2.0 immediately | Defer, use 3.1.2 | 3.2.0 is current, but UAM's selected diff/generation/validation tools have not yet passed a 3.2 compatibility matrix; 3.1.2 already aligns with JSON Schema 2020-12 | CLI tool matrix proves required 3.2 features and identical validation/code generation across pinned tools; ADR updates dialect |
| OpenAPI alone as the contract | Reject | Cannot fully express receipt semantics, trust source, privacy state, transaction boundaries, rollout, kill switches, support ownership, and many cross-message invariants | Never as sole specification; it remains the HTTP surface description |
| JSON Schema alone | Reject | Cannot specify HTTP status/header behavior, state transitions, consumer rollout, custody meaning, or operational ownership | Never as sole specification; it remains the JSON instance schema |
| Consumer-driven contract broker for every internal call | Reject initially | Adds infrastructure and may reward matching current examples rather than preserving normative privacy/security semantics | Named external or independently governed consumers need provider verification and can operate a broker without production payloads; use Pact-style tests as supplemental evidence |
| Date-based versions | Reject as wire compatibility key | Dates do not encode compatibility and can encourage silent breaking changes | May be included as release metadata, never replace exact semantic contract version |
| Accept unsupported schemas into opaque durable custody | Reject by default | Creates indefinite sensitive opaque storage, unclear receipt meaning, and delayed incompatibility discovery | A separate governed “opaque custody” product requirement is approved with retention, encryption, access, deletion, and replay semantics; requires a new ADR and receipt type |
| Sign every telemetry batch at application layer | Defer | TLS/auth plus digest and durable idempotency address current integrity/custody need; signing adds device key lifecycle and canonicalization burden | Threat model requires application-layer origin proof beyond transport authentication and device key operations pass rotation/revocation/recovery gates |
| Globally normalize Unicode | Reject | Normalization may change source/display identity and signature bytes; not required for ASCII identifiers | A field-specific semantic contract explicitly defines normalization before signing/deduplication and has confusable/security tests |
| Calendar-only deprecation | Reject | Offline endpoints and external commitments are unknown; absence of traffic may be instrumentation failure | Human-approved minimum notice may be one condition, but removal still requires inventory evidence, owner sign-off, rollback proof, and incident readiness |


---

# 5. Interfaces/protocols and example contracts or schemas; normative where possible

## 5.1 What is formally specified

**RECOMMENDATION.** The contract system has four complementary artifacts:

1. **UAM Contract Standard** — normative prose for serialization profile, version semantics, trust source, privacy stage, state machines, transaction meaning, limits, security, rollout, ownership, observability, and rejection.
2. **JSON Schema Draft 2020-12** — normative structure and field constraints for every JSON message. Each schema sets an immutable `$id`, declares the dialect, closes objects, bounds collections/strings, and provides no network-dependent references.
3. **OpenAPI 3.1.2** — normative HTTP routes, methods, media types, headers, authentication scheme references, status codes, and links to the exact JSON Schemas. OpenAPI-generated code is derivative, not normative.
4. **Executable conformance assets** — canonical valid/invalid vectors, cross-version matrices, state-transition scenarios, fuzz seeds, and deterministic generated-code snapshots.

A schema diff report, generated DTO, ORM model, portal type, example, wiki page, or test mock is not an independent source of truth.

## 5.2 Contract identity and catalogue metadata

Every contract has an immutable identity independent of product release:

```json
{
  "contract_name": "uam.ingestion.upload-batch",
  "contract_version": "1.0.0",
  "schema_id": "https://schemas.example.invalid/uam/ingestion/upload-batch/1.0.0/schema.json",
  "schema_sha256": "<64 lowercase hex characters>",
  "lifecycle": "candidate",
  "privacy_stage": "minimized",
  "trust_source": "authenticated-endpoint-untrusted-payload",
  "producer_functions": ["endpoint-outbox"],
  "consumer_functions": ["server-ingress"],
  "accountable_owner": "UNASSIGNED",
  "support_owner": "UNASSIGNED",
  "max_uncompressed_bytes": 4194304,
  "unknown_member_policy": "reject",
  "duplicate_member_policy": "reject",
  "compatibility_policy_id": "consumer-first-current-previous-major-temporary",
  "rejection_contract": "uam.common.problem-details@1.0.0"
}
```

The actual production schema host/domain is a **HUMAN/IMPLEMENTATION DECISION**. The examples use the reserved `.invalid` name and must not be copied as a production endpoint.

Catalogue rules:

- `contract_name` is lower-case ASCII dot-separated, immutable, and globally unique within UAM.
- `contract_version` is exact `MAJOR.MINOR.PATCH`, with no leading `v`, build metadata, range, wildcard, or omitted patch on the wire.
- `$id` is immutable and includes the exact version. Published content at an ID is never replaced; a correction that changes bytes receives a new patch version even when wire behavior is unchanged.
- `schema_sha256` covers the exact UTF-8 schema artifact in the signed bundle manifest.
- Every producer and consumer function is listed. “All services” is invalid ownership metadata.
- Every active/candidate contract has a rejection contract, hard limits, lifecycle, compatibility declaration, owner, support runbook, and vectors.
- The catalogue CI verifies full local `$ref` closure and that referenced artifact digests match the bundle manifest.

## 5.3 Contract catalogue and ownership matrix

The initial catalogue is below. Limits are bootstrap caps for prototype safety, not production-volume facts. A component may narrow a cap but cannot increase it at runtime above its released ceiling.

| ID | Contract family and initial names | Producer → consumer | Privacy/trust state | Bootstrap hard limit | Rejection behavior | Accountability function to assign |
|---:|---|---|---|---:|---|---|
| C01 | `uam.collector.invoke`, `uam.collector.result` | User Host scheduler → bounded collector adapter → privacy transformer | Pre-minimization, same user/session process boundary; highest leakage risk | invoke 32 KiB; result frame 256 KiB; candidate item 64 KiB; depth 16 | Terminate invocation; classify safe error; discard candidate; no retry unless error class permits | Endpoint collector-contract owner |
| C02 | `uam.privacy.transform-request`, `uam.privacy.transform-result`, `uam.privacy.decision` | Collector adapter → privacy transformer → minimized endpoint domain | Input private/transient; output minimized | request 256 KiB; result 64 KiB | Fail closed; emit only bounded code/counters; never pass candidate to Coordinator | Privacy transformation owner and product privacy authority |
| C03 | `uam.ipc.hello`, `uam.ipc.welcome`, `uam.ipc.frame`, `uam.ipc.problem` | User Host/Task Host ↔ Coordinator | Local cross-process and session security boundary | handshake 16 KiB; message 256 KiB; length prefix 4 bytes | Close pipe on framing/auth/version violation; rate-limit reconnect; safe event-log code | Endpoint IPC/security owner |
| C04 | `uam.policy.privacy-ceiling`, `uam.policy.tenant-policy`, `uam.policy.effective-policy-proof`, `uam.policy.block-manifest` | Release/policy authority → endpoint/server evaluators | Authorization/control artifact; signed; realm binding where applicable | 512 KiB each; depth 16 | Reject/freeze unsupported or invalid artifact; continue last unexpired authorized policy or enter safe deny state per ADR | Product governance, tenant-policy, release-signing owners |
| C05 | `uam.endpoint.minimized-event`, `uam.endpoint.source-progress`, `uam.endpoint.local-batch` | Privacy transformer/endpoint domain → SQLite/outbox | Minimized endpoint durable state | event 16 KiB; progress 8 KiB; local batch metadata 64 KiB | Atomic transaction rollback; do not advance cursor; bounded health signal | Endpoint domain/outbox owner |
| C06 | `uam.ingestion.upload-batch` | Endpoint outbox → server ingress | Minimized, authenticated sender; payload still untrusted | 1 MiB compressed; 4 MiB expanded; 1,000 events; ratio 20:1 | Pre-custody 4xx/429/503 problem; no receipt; retry class explicit | Ingestion contract owner |
| C07 | `uam.ingestion.custody-receipt`, `uam.ingestion.processing-status` | Server ingress/processor → endpoint/control query | Receipt is durable-custody evidence; status is later semantics | receipt 64 KiB; status 256 KiB/page | Endpoint refuses mismatched batch/digest/identity; does not delete local data | Ingestion and endpoint receipt owners |
| C08 | `uam.quarantine.case`, `uam.quarantine.transition`, `uam.quarantine.summary` | Semantic validator/authorized operator → protected quarantine domain | Sensitive failure metadata; rejected body not normal API content | metadata 32 KiB; summary page 1 MiB | Quarantine or deny transition; no payload echo; audit every privileged action | Quarantine/security operations owner |
| C09 | `uam.health.snapshot`, `uam.health.heartbeat`, `uam.health.capabilities` | Endpoint/server components → health ingest/control | Operational metadata; must be privacy-minimized | 64 KiB; bounded code maps | Drop/reject over-limit message without affecting activity custody; aggregate safe code | Health/operations owner |
| C10 | `uam.audit.command`, `uam.audit.command-result`, `uam.audit.record` | BFF/admin → privileged domain → audit store | Privileged cross-boundary command and evidence | 32 KiB each | No mutation without audit transaction; problem response with stable code | Control/audit owner |
| C11 | `uam.integration.<consumer>.import-page`, `export-page`, `notification`, `ack` | Named external adapter ↔ named consumer | Server-side governed egress/ingress; realm scoped | 4 MiB/page unless narrower; 1,000 items | Consumer-specific problem/ack; quarantine import; circuit-break egress | One owner and support function per named consumer |
| C12 | `uam.deletion.request`, `uam.deletion.tombstone`, `uam.deletion.application-status`, `uam.deletion.completion-evidence` | Authorized control/deletion service → stores/restore gate | High-authority lifecycle control, no deleted content in tombstone | request 32 KiB; tombstone 8 KiB; status/evidence 64 KiB | Deny unauthorized/ambiguous target; preserve audit; stop visibility on inconsistency | Deletion/restore owner plus governance authority |
| C13 | `uam.common.problem-details` | Any boundary → caller | Privacy-safe error metadata | HTTP 64 KiB; IPC 16 KiB | Never echo payload; unknown error code maps to safe terminal/retry default | Contract authority and each boundary owner |
| C14 | `uam.contract.bundle-manifest` | Contract build/release → all validators/generators | Signed release supply-chain artifact | 1 MiB; no remote refs | Refuse untrusted, incomplete, stale, frozen, or downgraded bundle | Contract/release authority |

### Ownership rule

A repository placeholder such as `UNASSIGNED`, a group mailbox, or an informal team name does not satisfy the integration gate. Before a contract becomes `candidate`, a human must name:

- an accountable decision owner;
- a producer implementation owner;
- every required consumer owner;
- a support/on-call function;
- a privacy/security reviewer where the contract crosses those boundaries;
- an external-commitment authority for any non-UAM consumer.

The same person may fill multiple functions when separation is not required, but responsibility must be explicit and auditable.

## 5.4 Normative serialization profile: UAM-JSON-1

Unless a contract explicitly states a stricter rule, all UAM JSON wire artifacts conform to **UAM-JSON-1**.

### 5.4.1 Encoding and grammar

1. Messages **MUST** be RFC 8259 JSON encoded as UTF-8.
2. A UTF-8 byte-order mark **MUST NOT** be produced and **MUST** be rejected at a security/privacy boundary.
3. Comments, trailing commas, single-quoted strings, unquoted names, leading-zero numbers, `NaN`, positive/negative infinity, and implementation extensions **MUST** be rejected.
4. The root **MUST** be a JSON object unless a contract explicitly declares another root. Initial UAM contracts all use object roots.
5. Member names are case-sensitive. Case-insensitive binding **MUST NOT** be enabled.
6. Duplicate member names **MUST** be rejected before typed binding. “Last value wins” and “first value wins” are forbidden.
7. Parsers **MUST** enforce depth, byte, string, array, property-count, and processing-time limits before unbounded allocation.
8. The default maximum depth is 16. A schema may lower it; raising it requires an ADR and adversarial resource test.
9. Root objects are limited to 128 members unless a stricter schema applies. Generic maps are forbidden unless their key pattern and maximum property count are explicit.
10. Individual strings default to 4,096 UTF-8 bytes and 4,096 Unicode scalar values unless the field defines a smaller or explicitly reviewed larger maximum. Both limits apply.

**FACT.** RFC 8259 warns that duplicate object names produce unpredictable behavior and permits implementations to set limits on size and depth. UAM turns those interoperability options into mandatory rejection rules.

### 5.4.2 Field presence, nullability, and defaults

1. Presence and nullability are separate dimensions.
2. A required field appears in JSON Schema `required` and **MUST** be present.
3. A nullable field includes `null` in its schema type. Absence **MUST NOT** be interpreted as null unless the contract says so.
4. Optional fields are omitted when unknown/not applicable. They **MUST NOT** be emitted as `null` unless explicitly nullable.
5. Boundary validators **MUST NOT** inject schema defaults into received messages. Defaults are documentation or producer-generation aids only.
6. Adding a required field is breaking. Making a field non-nullable is breaking. Making a formerly required field optional may still be semantically breaking and therefore requires review.
7. Producers **MUST** use a single documented representation for each state; they must not alternate between absent, null, empty string, zero, and empty array as synonyms.
8. A value that is redacted or prohibited is omitted; a generic string such as `"REDACTED"` is not a substitute unless the field semantics explicitly define it.

### 5.4.3 Unknown members, enums, and extension points

1. Every object **MUST** close with `unevaluatedProperties: false` (or an equivalent proven closed form where composition is not used).
2. Unknown members **MUST** be rejected at boundary validation.
3. Unknown enum values **MUST** be rejected unless the field is explicitly declared an opaque token and the consumer is required to preserve it without branching.
4. Generic extension bags are **MUST NOT** appear in privacy-bearing collector outputs, minimized local events, upload event payloads, audit commands, or deletion targets.
5. A reviewed control/integration contract **MAY** define `extensions` as an object with:
   - a namespaced ASCII key pattern such as `org.example.feature`;
   - `maxProperties` and per-value byte/depth limits;
   - no effect on authentication, authorization, realm, privacy ceiling, identity, routing, storage selection, signatures outside its declared scope, or metric labels;
   - a declared preserve/drop/reject rule.
6. An extension that becomes operationally significant graduates to a named versioned field.

### 5.4.4 Numbers and units

1. Core wire contracts use JSON integers only. Binary floating point **MUST NOT** be used for identity, time, counts requiring exactness, policy, money, ratios, or deduplication.
2. Integers **MUST** lie in `[-9007199254740991, 9007199254740991]` unless encoded as a separately specified string type. This preserves exact interoperability across common JSON implementations.
3. Each numeric field includes its unit in the name or type, for example `duration_ms`, `size_bytes`, or `sequence_number`.
4. Decimal values, if approved later, use a canonical string with an explicit regex, scale, range, rounding mode, and unit. Scientific notation is forbidden unless the field standard says otherwise.
5. Counters **MUST** define whether they are interval, cumulative, monotonic, and resettable. Saturation/overflow behavior is explicit.
6. A change of unit, scale, rounding, sentinel meaning, or valid range that can alter behavior is a major compatibility change even when the JSON type is unchanged.

### 5.4.5 Time and duration

1. Instants use an RFC 3339 profile: `YYYY-MM-DDTHH:mm:ss[.fraction]Z`, uppercase `T` and `Z`, UTC only, 0–6 fractional digits, four-digit years, and no leap-second value.
2. Producers emit the shortest precision that truthfully represents the source and approved transformation; they do not manufacture precision.
3. Where precision affects interpretation, a separate closed enum such as `second`, `millisecond`, or `microsecond` is required.
4. Local time and numeric UTC offsets are not accepted for instants. A separate civil-time contract is required if a future business need exists.
5. Durations are integer units in named fields, not ISO 8601 duration strings, unless a contract explicitly requires calendrical semantics.
6. Ordering **MUST NOT** rely on wall-clock time alone. Stable IDs and source/generation/cursor provenance are separate.
7. Exact business time precision is a **HUMAN DECISION** and field-level privacy decision.

### 5.4.6 Identifiers and references

1. New UAM event, batch, receipt, command, audit, tombstone, and message identifiers use canonical lower-case UUIDv7 text (`8-4-4-4-12`).
2. Parsers reject braces, upper-case letters, missing hyphens, alternate encodings, invalid variant/version bits, and nil UUIDs unless a field explicitly permits nil (none initially do).
3. An identifier is opaque to business logic. UUIDv7 time bits may help indexes but are not an authoritative event time or authorization input.
4. `realm_id`, authenticated installation/device identity, and actor identity are derived or bound by authenticated server context. A payload may carry a correlation reference only where the schema calls it that; it cannot override the authenticated identity.
5. External IDs remain typed external references and are never promoted to UAM primary keys without an approved import identity contract.
6. IDs are immutable and never reused after deletion. Aliases and merges are explicit server-side records/contracts.
7. Retry preserves `event_id` and `batch_id`; regeneration does not create a new identity for the same logical item.

### 5.4.7 Unicode and strings

1. JSON strings must contain valid Unicode scalar values; unpaired UTF-16 surrogates are rejected by producer tests and receiver parsing.
2. Identifiers, enum values, contract names, field names, error codes, hash algorithms, key IDs, and extension keys are restricted to field-specific ASCII patterns.
3. Display text may be Unicode. UAM does not globally normalize it; signatures and hashes operate on exact code points after parsing under the selected canonicalization standard.
4. Case folding, normalization, confusable handling, and comparison are field semantics and must be specified per field. They are not inferred from the wire type.
5. Control characters are rejected except JSON escape sequences representing explicitly permitted whitespace in fields that allow it. Initial machine fields permit none.

### 5.4.8 Framing, HTTP, and compression

HTTP:

- request/response JSON media types are `application/json`; errors use `application/problem+json`;
- API route major appears in the path, for example `/ingestion/v1/batches`; the body also carries exact contract name/version;
- `Content-Encoding: gzip` is the only initial compressed upload encoding; identity may be permitted for small lab/control messages where the route says so;
- compressed body limit: 1,048,576 bytes; expanded body limit: 4,194,304 bytes; maximum expansion ratio: 20:1; all are provisional bootstrap limits;
- request header block limit: 32 KiB; individual field limit: 8 KiB; request target limit: 2 KiB, subject to platform/proxy validation;
- unknown content type or encoding returns 415; size returns 413; rate/backpressure returns 429 or 503 with explicit retry class; malformed/digest mismatch returns 400; unsupported/invalid known contract returns 422; ID/content conflict returns 409; authentication/authorization returns 401/403 as applicable;
- a response body and log never echo the batch or offending value.

IPC:

- use a local Windows named pipe with an explicit DACL including only the Coordinator identity and intended logon/session SID as appropriate; do not rely on a default security descriptor;
- remote pipe access is not permitted; pipe names include unguessable per-launch material but secrecy is not the security control;
- frame format is `uint32` unsigned little-endian payload length followed by exactly that many UTF-8 JSON bytes;
- zero length, length above the contract cap, extra bytes, partial-frame timeout, duplicate keys, invalid UTF-8, unsupported version, and wrong session close the connection;
- each connection starts with `hello`/`welcome`; no application frame is accepted first;
- the Coordinator does not impersonate a client by default. Any future impersonation is a separate security ADR and lab gate.

### 5.4.9 Hashes, digests, and signatures

**Content and artifact hash.** SHA-256 is the initial required hash for schema artifacts, bundle manifests, content identities, and HTTP `Content-Digest`. Algorithm agility is represented by a closed algorithm field; no receiver guesses from length.

**HTTP digest.** For uploads, `Content-Digest` follows RFC 9530 and covers the actual HTTP message content after content coding as defined by that RFC and the HTTP stack. It detects corruption but does not authenticate the sender. The endpoint computes it over the exact transmitted content bytes. Retrying the same `batch_id` must use the same logical uncompressed canonical batch and declared `content_sha256`; gzip bytes may differ by compressor metadata unless UAM fixes deterministic gzip. Therefore:

- `Content-Digest` protects the transmitted message instance;
- `batch_content_sha256` inside the validated envelope covers the UAM-defined canonical uncompressed JSON value and drives ID/content conflict detection;
- TLS and device/installation authentication provide transport peer security;
- a custody receipt binds `batch_id`, canonical content hash, authenticated installation context, and durable receipt ID.

**Signed control artifacts.** Privacy ceilings, block manifests, and release/contract bundle manifests should use detached JWS over RFC 8785 JCS canonical bytes. The signed envelope/profile must pin:

- allowed JWS algorithms; algorithm `none` is forbidden;
- key ID and key purpose;
- issuer and intended audience/component class;
- artifact type, exact contract version, content SHA-256;
- issued/not-before/expiry or equivalent release validity rules;
- monotonic revision and explicit authorized rollback token/path;
- realm binding for tenant policy;
- critical-header handling and duplicate-member rejection before canonicalization.

JCS is used only for artifacts whose schemas conform to its I-JSON/number constraints. Verification occurs before applying the artifact. A valid signature proves possession of an authorized key, not that the policy is lawful or wise.

Application-layer signatures on telemetry batches are **DEFERRED** pending device-key threat and operations evidence.

## 5.5 Provisional limit profile and change rule

| Limit | Bootstrap value | Failure response | Evidence required to change |
|---|---:|---|---|
| JSON nesting depth | 16 | Reject before binding | Adversarial parser allocation/latency test and schema need |
| Root properties | 128 | Reject | Contract-specific field review and memory test |
| Default string | 4,096 UTF-8 bytes and scalar values | Reject field/message | Synthetic corpus percentile and approved semantic need |
| IPC invoke | 32 KiB | Safe IPC problem, close if framing violation | Windows lab latency/allocation test |
| IPC result frame | 256 KiB | Kill/defer task; no candidate leakage | Collector synthetic worst-case evidence |
| Transient candidate item | 64 KiB | Discard item/run under defined policy | Privacy transform memory/canary evidence |
| Minimized local event | 16 KiB | Do not commit event/cursor; health code | Approved schema plus outbox/storage test |
| Upload compressed | 1 MiB | HTTP 413 before custody | Proxy/server/endpoint memory and bandwidth test |
| Upload expanded | 4 MiB | HTTP 413 before custody | Streaming decompression test |
| Upload events | 1,000 | HTTP 413/422 before custody | Batch throughput/latency/idempotency test |
| Expansion ratio | 20:1 plus absolute cap | HTTP 400/413 and security count | Compression corpus and bomb test |
| Receipt | 64 KiB | Endpoint rejects; retains batch | Receipt schema need and parser test |
| Policy/ceiling | 512 KiB | Reject artifact; safe-policy state | Rule-corpus and signature performance test |
| Health | 64 KiB | Reject/drop; no activity effect | Cardinality and payload test |
| Audit command/record | 32 KiB | Reject mutation before transaction | Approved audit field dictionary |
| Integration page | 4 MiB / 1,000 items | Consumer-specific 413/422 | Named consumer benchmark |
| Deletion tombstone | 8 KiB | Reject and stop deletion transition | Approved target/proof semantics |
| Quarantine metadata | 32 KiB | Truncate only pre-declared safe diagnostics; never payload | Incident/runbook evidence |

Changing a maximum can be breaking: raising a producer maximum can exceed an older consumer's resources. Therefore a limit increase requires compatibility analysis and normally a major contract version or a separately negotiated capability where old producers remain within the old cap. A limit decrease is breaking for previously valid producers. A server may temporarily narrow an operational admission limit only through an explicit backpressure state that does not misrepresent contract validity and provides retry behavior.

## 5.6 Envelope patterns

### 5.6.1 Common contract reference

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/common/contract-ref/1.0.0/schema.json",
  "title": "UAM contract reference 1.0.0",
  "type": "object",
  "required": ["name", "version"],
  "properties": {
    "name": {
      "type": "string",
      "pattern": "^uam\\.[a-z0-9]+(?:[.-][a-z0-9]+)*$",
      "maxLength": 128
    },
    "version": {
      "type": "string",
      "pattern": "^(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)\\.(0|[1-9][0-9]*)$",
      "maxLength": 32
    }
  },
  "unevaluatedProperties": false
}
```

### 5.6.2 Common message metadata rule

Messages use only fields relevant to their boundary. There is no universal “mega-envelope.” Where applicable:

- `contract` — exact name/version;
- `message_id` — UUIDv7 for this message instance;
- `created_at` or boundary-specific time;
- `correlation_id` — optional opaque UUIDv7, never an authorization input;
- `producer` — bounded component identity/version only when needed for diagnostics/compatibility;
- domain identity fields defined by the contract.

Realm and installation/device may appear in server-originated responses for binding/verification, but endpoint-submitted claims never establish them.

## 5.7 Example contract: minimized local event

This is a structural example, not approval of the final event semantics.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/endpoint/minimized-event/1.0.0/schema.json",
  "title": "UAM minimized endpoint event 1.0.0",
  "type": "object",
  "required": [
    "contract", "event_id", "source", "source_generation_id",
    "observed_at", "observed_precision", "kind", "payload"
  ],
  "properties": {
    "contract": {
      "const": {"name": "uam.endpoint.minimized-event", "version": "1.0.0"}
    },
    "event_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "source": {
      "type": "string",
      "enum": ["edge-history-site"]
    },
    "source_generation_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "observed_at": {
      "type": "string",
      "pattern": "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\\.[0-9]{1,6})?Z$",
      "maxLength": 27
    },
    "observed_precision": {
      "type": "string",
      "enum": ["second", "millisecond", "microsecond"]
    },
    "kind": {
      "const": "site-activity"
    },
    "payload": {
      "type": "object",
      "required": ["site_key", "classification_revision"],
      "properties": {
        "site_key": {
          "type": "string",
          "pattern": "^[a-z0-9.-]{1,253}$"
        },
        "classification_revision": {
          "type": "string",
          "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
        }
      },
      "unevaluatedProperties": false
    }
  },
  "unevaluatedProperties": false
}
```

**HUMAN DECISION.** `site_key`, event time, precision, identity relation, and any additional fields require approved business/privacy semantics. The schema deliberately contains no user, realm, device, URL path, title, query string, or raw browser row.

## 5.8 Example contract: upload batch

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/ingestion/upload-batch/1.0.0/schema.json",
  "title": "UAM upload batch 1.0.0",
  "type": "object",
  "required": [
    "contract", "message_id", "batch_id", "created_at",
    "batch_content_sha256", "events"
  ],
  "properties": {
    "contract": {
      "const": {"name": "uam.ingestion.upload-batch", "version": "1.0.0"}
    },
    "message_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "batch_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "created_at": {
      "type": "string",
      "pattern": "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\\.[0-9]{1,6})?Z$"
    },
    "batch_content_sha256": {
      "type": "string",
      "pattern": "^[0-9a-f]{64}$"
    },
    "events": {
      "type": "array",
      "minItems": 1,
      "maxItems": 1000,
      "items": {
        "$ref": "https://schemas.example.invalid/uam/endpoint/minimized-event/1.0.0/schema.json"
      }
    }
  },
  "unevaluatedProperties": false
}
```

Implementation note: `batch_content_sha256` cannot include itself in its own digest. The normative digest input is the RFC 8785 canonical JSON object with the `batch_content_sha256` member omitted. The computed lowercase hex value is then inserted. This rule is part of the formal standard and golden vectors, not inferred by generators.

Example synthetic message:

```json
{
  "contract": {"name": "uam.ingestion.upload-batch", "version": "1.0.0"},
  "message_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c001",
  "batch_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c002",
  "created_at": "2026-07-31T12:34:56.789Z",
  "batch_content_sha256": "a069f124d1b3fa08417d7e201bfc136efcceb4f063c686b8af941f7c3f5c083d",
  "events": [
    {
      "contract": {"name": "uam.endpoint.minimized-event", "version": "1.0.0"},
      "event_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c003",
      "source": "edge-history-site",
      "source_generation_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c004",
      "observed_at": "2026-07-31T12:30:00Z",
      "observed_precision": "second",
      "kind": "site-activity",
      "payload": {
        "site_key": "synthetic.example.invalid",
        "classification_revision": "018f1f6c-7b00-7a10-8c23-8a4f9b10c005"
      }
    }
  ]
}
```

The batch contains no realm or device authority field. Ingress binds the stored record to the authenticated installation and its realm.

## 5.9 Example contract: durable custody receipt

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/ingestion/custody-receipt/1.0.0/schema.json",
  "title": "UAM durable custody receipt 1.0.0",
  "type": "object",
  "required": [
    "contract", "receipt_id", "batch_id", "batch_content_sha256",
    "custody", "durably_received_at", "status_contract"
  ],
  "properties": {
    "contract": {
      "const": {"name": "uam.ingestion.custody-receipt", "version": "1.0.0"}
    },
    "receipt_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "batch_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "batch_content_sha256": {
      "type": "string",
      "pattern": "^[0-9a-f]{64}$"
    },
    "custody": {
      "type": "string",
      "enum": ["received", "duplicate"]
    },
    "durably_received_at": {
      "type": "string",
      "pattern": "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\\.[0-9]{1,6})?Z$"
    },
    "status_contract": {
      "const": {"name": "uam.ingestion.processing-status", "version": "1.0.0"}
    }
  },
  "unevaluatedProperties": false
}
```

Normative meaning:

- `received` means this request caused the durable inbox/receipt transaction to commit.
- `duplicate` means the authenticated installation, `batch_id`, and canonical content hash match an already committed batch and the server returns its durable custody evidence.
- Neither value means every event is valid, materialized, visible, integrated, or retained permanently.
- The same authenticated installation plus `batch_id` with a different content hash is `409 uam.ingestion.batch-id-content-conflict`; no existing content is overwritten and no custody receipt is issued for the conflicting request.

## 5.10 Example processing status and quarantine separation

```json
{
  "contract": {"name": "uam.ingestion.processing-status", "version": "1.0.0"},
  "batch_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c002",
  "batch_content_sha256": "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
  "state": "quarantined",
  "updated_at": "2026-07-31T12:35:07Z",
  "counts": {
    "received": 1,
    "validated": 0,
    "materialized": 0,
    "quarantined": 1
  },
  "reason_codes": ["uam.validation.event-schema-invalid"]
}
```

`reason_codes` are bounded enums. The status does not contain the invalid value or JSON fragment. Detailed evidence is available only through protected incident/quarantine workflows and must still obey the privacy ceiling.

## 5.11 Example signed privacy ceiling payload

The JWS wrapper is omitted here because key/algorithm selection is not yet approved. The signed payload shape is:

```json
{
  "contract": {"name": "uam.policy.privacy-ceiling", "version": "1.0.0"},
  "artifact_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c010",
  "revision": 1,
  "issued_at": "2026-07-31T12:00:00Z",
  "not_before": "2026-07-31T12:00:00Z",
  "capabilities": [
    {
      "source": "edge-history-site",
      "allowed_output_contract": {
        "name": "uam.endpoint.minimized-event",
        "version": "1.0.0"
      },
      "allowed_fields": [
        "/event_id", "/source", "/source_generation_id", "/observed_at",
        "/observed_precision", "/kind", "/payload/site_key",
        "/payload/classification_revision"
      ],
      "allowed_destinations": ["endpoint-outbox", "uam-ingestion"]
    }
  ]
}
```

The actual allowed fields, source semantics, timing, expiry, and destinations are **HUMAN DECISION** inputs. Tenant policy is an intersection/narrowing operation over this artifact. Unknown capability or field names fail closed.

## 5.12 Example deletion tombstone

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/deletion/tombstone/1.0.0/schema.json",
  "type": "object",
  "required": [
    "contract", "tombstone_id", "request_id", "realm_binding",
    "target_type", "target_id", "effective_at", "revision"
  ],
  "properties": {
    "contract": {
      "const": {"name": "uam.deletion.tombstone", "version": "1.0.0"}
    },
    "tombstone_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "request_id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "realm_binding": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "target_type": {
      "type": "string",
      "enum": ["event", "subject-projection", "installation", "approved-scope"]
    },
    "target_id": {
      "type": "string",
      "maxLength": 128,
      "pattern": "^[A-Za-z0-9._:-]+$"
    },
    "effective_at": {
      "type": "string",
      "pattern": "^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(?:\\.[0-9]{1,6})?Z$"
    },
    "revision": {
      "type": "integer",
      "minimum": 1,
      "maximum": 9007199254740991
    }
  },
  "unevaluatedProperties": false
}
```

Target types and legal deletion semantics remain **HUMAN DECISION**. The tombstone intentionally contains no deleted payload and no free-text reason.

## 5.13 Error taxonomy and Problem Details profile

All HTTP errors use RFC 9457 Problem Details plus UAM members:

```json
{
  "type": "https://errors.example.invalid/uam/ingestion/unsupported-contract-version",
  "title": "Unsupported contract version",
  "status": 422,
  "code": "uam.contract.unsupported-version",
  "retry": "after-upgrade",
  "contract_name": "uam.ingestion.upload-batch",
  "supported_major_versions": [1],
  "correlation_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c099"
}
```

Rules:

- `type` is a stable documentation URI; it need not be dereferenced at runtime.
- `code` is the stable machine decision key and is lower-case ASCII dot-separated.
- `title` is safe, short, localizable display text. Clients do not branch on it.
- `detail` is omitted by default and, when present, contains no payload or private value.
- `retry` is one of `never`, `same-request`, `after-delay`, `after-auth`, `after-policy`, `after-upgrade`, or `operator-action`.
- Unknown retry values are rejected; unknown error codes use the status-class fallback and are recorded safely.
- Retry delay uses `Retry-After` where HTTP defines it; it is not embedded as an unbounded free-form string.

Initial bounded error classes:

| Class | Example codes | HTTP/IPC behavior | Client action |
|---|---|---|---|
| Syntax/framing | `uam.json.invalid`, `uam.json.duplicate-member`, `uam.ipc.frame-length-invalid` | 400 or pipe close | Do not retry unchanged bytes |
| Size/resource | `uam.message.too-large`, `uam.compression.limit-exceeded` | 413 / safe IPC error | Rebatch only under contract; never split one event beyond schema |
| Version/dialect | `uam.contract.unsupported-version`, `uam.contract.bundle-untrusted` | 422 / handshake reject | Upgrade/rollback/operator action |
| Authentication | `uam.auth.missing`, `uam.auth.invalid` | 401 / pipe deny | Re-establish approved identity; no blind loop |
| Authorization/realm | `uam.auth.forbidden`, `uam.realm.binding-mismatch` | 403 | Stop; security signal |
| Idempotency conflict | `uam.ingestion.batch-id-content-conflict` | 409 | Stop; preserve evidence; do not invent new ID automatically |
| Backpressure/transient | `uam.ingestion.busy`, `uam.dependency.unavailable` | 429/503 | Bounded jittered retry; preserve batch |
| Semantic/data quality | `uam.validation.event-schema-invalid`, `uam.validation.provenance-invalid` | Post-custody quarantine/status or pre-custody 422 for envelope | Do not delete local event until custody rule says; operator/remediation path |
| Policy/privacy | `uam.policy.not-authorized`, `uam.privacy.transform-failed` | Deny/fail closed | Stop affected capability; preserve only safe diagnostics |
| Internal failure | `uam.internal.failure` | 500 / generic IPC error | Bounded retry if classified; no exception leak |
| Deletion/restore | `uam.deletion.target-ambiguous`, `uam.restore.deletion-state-not-ready` | 409/422/503 | Stop visibility or require operator action |

## 5.14 Canonical test vector

The following vector is normative for UAM's JCS implementation test. It contains only synthetic data.

### Input JSON value

```json
{
  "sent_at": "2026-07-31T12:34:56.789Z",
  "note": "synthetic-é",
  "message_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c001",
  "contract": {
    "version": "1.0.0",
    "name": "uam.upload-batch"
  }
}
```

### Expected RFC 8785 canonical UTF-8 JSON

```text
{"contract":{"name":"uam.upload-batch","version":"1.0.0"},"message_id":"018f1f6c-7b00-7a10-8c23-8a4f9b10c001","note":"synthetic-é","sent_at":"2026-07-31T12:34:56.789Z"}
```

Expected byte length: `169`.

Expected UTF-8 hex:

```text
7b22636f6e7472616374223a7b226e616d65223a2275616d2e75706c6f61642d6261746368222c2276657273696f6e223a22312e302e30227d2c226d6573736167655f6964223a2230313866316636632d376230302d376131302d386332332d386134663962313063303031222c226e6f7465223a2273796e7468657469632dc3a9222c2273656e745f6174223a22323032362d30372d33315431323a33343a35362e3738395a227d
```

Expected SHA-256 hex:

```text
26d3db6313f9b18ecbf7267a8b7414410d61b47bd8ccf4c1370ab6ce6b3f7a05
```

Expected SHA-256 base64:

```text
JtPbYxP5sY7L9yZ6i3QUQQ1htHvYzPTBNwq2zms/egU=
```

Expected RFC 9530 field value when these exact canonical bytes are the HTTP content:

```text
Content-Digest: sha-256=:JtPbYxP5sY7L9yZ6i3QUQQ1htHvYzPTBNwq2zms/egU=:
```

Required negative vectors:

- duplicate `contract` or `name` member — reject before canonicalization;
- `message_ID` wrong case — reject schema;
- uppercase UUID — reject;
- decomposed `e` plus combining acute — valid Unicode only if the field permits it, but it produces a different hash; no normalization occurs;
- BOM prefix — reject;
- timestamp with `+00:00` rather than `Z` — reject UAM time profile;
- number outside exact integer range — reject;
- unknown root property — reject.

## 5.15 Contract declaration checklist

No contract can move to `candidate` until one machine-readable catalogue entry and one review record prove all of the following:

- exact name/version/schema ID/digest;
- producer and every required consumer;
- accountable and support owner;
- trust source and privacy stage;
- required/optional/null/default semantics;
- identifier, time, number, Unicode, and enum semantics;
- compressed/uncompressed/item/depth/string/property limits;
- duplicate/unknown/extension behavior;
- hash/signature profile if any;
- rejection error/status and retry behavior;
- transaction/custody/idempotency meaning;
- backward/forward compatibility classification;
- rollout, rollback, deprecation, and emergency block behavior;
- logs/metrics permitted and forbidden;
- valid, boundary, invalid, canonical, and adversarial vectors;
- old/new producer-consumer matrix;
- license/SBOM and pinned toolchain;
- runbook and evidence location.


---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Normative versioning rules

### 6.1.1 Version model

Every contract version is `MAJOR.MINOR.PATCH`:

- **MAJOR** changes when an existing producer or consumer can no longer safely exchange the message, or when meaning/security/privacy/resource behavior changes incompatibly.
- **MINOR** changes only for additive capabilities that are safe under the declared consumer-first rollout and do not invalidate any accepted instance of the previous minor for a new consumer.
- **PATCH** changes documentation, examples, annotations, or tests without changing the set of accepted wire instances, emitted instances, error/retry behavior, semantic meaning, security/privacy behavior, transaction meaning, or resource ceiling.

A product release version and a contract version are independent. A single product release may support multiple exact contract versions; a contract may remain unchanged across product releases.

### 6.1.2 Compatibility definitions

For a contract `C`:

- A new consumer is **backward compatible** with version `x` when it accepts every valid message that a conforming supported producer of `x` may emit and preserves its normative semantics.
- A new producer is **forward compatible** with an old consumer only when every message the new producer may emit is valid and semantically equivalent under that old consumer. With strict unknown-field rejection, this is not assumed for an additive field.
- **Round-trip compatibility** requires parse/serialize preservation only where the contract explicitly requires it. Most UAM consumers map into domain types and are not generic round-trippers.
- **Operational compatibility** additionally requires the consumer to stay within approved CPU, memory, latency, storage, and metric-cardinality bounds.
- **Security/privacy compatibility** requires no widening of accepted authority, realm, source, field, destination, identity, logging, or diagnostic behavior.
- A change is compatible only if all relevant dimensions pass; syntactic compatibility alone is insufficient.

### 6.1.3 Changes that require a major version

The following are major unless a narrower pre-declared mechanism proves otherwise:

- add a required member; remove or rename any member; move a member; change case;
- make nullable non-nullable, optional required, or change absence/null/default meaning;
- remove an enum value accepted from a producer; add a producer-emitted enum value before all old consumers are retired;
- change a field type, format, pattern, unit, scale, range, precision, normalization, comparison, or sentinel;
- reinterpret an identifier, dedupe scope, realm binding, actor/source authority, ordering, cursor, or idempotency key;
- change receipt from custody to another meaning, or change when a receipt may be issued;
- change privacy classification, transformation, allowed destination, logging, diagnostics, or redaction behavior;
- change authentication, authorization, signature, key-purpose, audience, or downgrade behavior;
- lower a maximum, or raise a producer maximum beyond a supported old consumer's declared maximum;
- change unknown/duplicate-member behavior, extension semantics, canonicalization, digest input, or compression semantics;
- change HTTP route major, method semantics, status/retry classification, transaction boundary, delivery guarantee, or state-machine transition;
- split/merge events or alter aggregation in a way that changes business effect;
- change a feature flag from selecting behavior to redefining the protocol;
- change a field from informational to authorization/routing/storage/metric-cardinality input;
- begin emitting a previously reserved member name with semantics an old parser may mis-handle.

### 6.1.4 Changes that may be minor

A minor is permitted only after consumer-first proof for all required consumers. Examples:

- add an optional member that old producers omit and new consumers safely understand, while new producers remain disabled until old consumers are gone or a negotiated capability allows emission;
- add a response field when every supported client either accepts it by explicit extension policy or the server does not emit it to strict older clients;
- add an optional operation/route that does not change existing operations;
- add a new error code under an already documented safe fallback, provided clients do not require closed-enum rejection for that field; otherwise it is major;
- add a capability to a signed policy schema while old evaluators reject or ignore it only according to an explicitly safe policy. For privacy authorization, unknown capability is always deny, never allow;
- relax a validation constraint for new consumers while ensuring producers and domain logic preserve semantics. Relaxation is not automatically safe because it may admit data older downstream systems cannot process.

A proposed minor must include a matrix proving:

```text
new consumer <- old producer : required PASS
new consumer <- new producer : required PASS
old consumer <- new producer : PASS only if new producer can reach old consumer;
                               otherwise routing/capability evidence MUST prove impossible
```

### 6.1.5 Changes that may be patch

Patch-only examples:

- correct spelling in description/title without changing machine fields;
- add or correct a non-normative example that matches existing rules;
- add invalid/fuzz vectors for behavior already required;
- reorganize source files while preserving exact bundled schema bytes and IDs, or publish a new artifact patch solely to correct metadata without changing validation;
- clarify ambiguous prose only when implementation and conformance tests already agree. If conforming implementations could reasonably differ, the clarification is at least a compatibility review and may be major.

### 6.1.6 Version negotiation

- HTTP route major selects the protocol family boundary; the body `contract.version` selects the exact schema.
- Named-pipe `hello` lists bounded exact versions supported by the producer for each required message family. `welcome` selects one exact version per direction.
- Version ranges such as `>=1`, `1.x`, or “latest” are forbidden on the wire and in receipts.
- Servers may advertise supported major/exact versions in a bounded safe error or authenticated capability endpoint. This does not authorize a producer to switch without its released producer capability.
- A producer never retries the same bytes under a different declared version.
- Downgrade to an older producer requires an authorized rollout transition; the receiver must still validate exact bytes against the declared old schema. It must not coerce a new message into an old model.

## 6.2 Compatibility window, deprecation, reservation, and retirement

### 6.2.1 Supported-version window

**HUMAN DECISION.** Compatibility duration and rollout policy need approval. Temporary default:

- each local IPC and ingestion consumer supports active major `N` and previous major `N-1`;
- a producer emits one exact active version at a time per contract/cohort, while retaining the prior producer implementation for rollback;
- minor versions may coexist only where routing/negotiation proves the selected consumer supports the exact version;
- patch versions do not change accepted/emitted instance sets or semantics. Because the exact version is carried on the wire, consumers must explicitly bundle and accept a new patch before a producer emits it; explicitly proved patch versions may share one reader/compatibility class, while unknown patches remain rejected;
- no version is removed solely because a date passed.

A broader window may be needed for long-offline devices or external commitments. A narrower window may be acceptable for atomically deployed in-process components. Both require explicit evidence and an ADR.

### 6.2.2 Deprecation record

A version can enter `deprecated` only with:

- replacement version and migration guide;
- accountable owner and named affected consumers;
- earliest removal conditions and any human-approved notice commitment;
- protected inventory query showing producer/consumer population by release cohort;
- compatibility and rollback test results;
- support and incident runbook;
- privacy/security impact;
- exact kill-switch and freeze behavior;
- audit record of approval.

Deprecation is observable metadata, not a runtime rejection. The receiver continues its declared support until `retired` or `emergency-blocked`.

### 6.2.3 Reservation and reuse

- Removed member names, enum values, route names, error codes, and discriminator values remain permanently reserved within that contract family/major.
- Numeric enum codes are discouraged. Where used, removed numbers are never reused.
- Contract names and `$id`s are never repointed.
- UUID identities and external reference mappings are never reassigned to a different entity.
- A retired major can be reimplemented only under its original normative contract and security support decision; new semantics use a new major.

### 6.2.4 Retirement gate

A version becomes `retired` only when all are true:

1. human compatibility/commitment authority approves removal;
2. every named consumer owner signs off or its commitment has ended under approved terms;
3. protected fleet/integration inventory shows no supported producers for an approved observation window, with instrumentation health proved;
4. long-offline/recovery/restore scenarios are assessed;
5. old/new/rollback matrices pass on the final release that removes support;
6. emergency re-enable or supported rollback plan is tested, or the authority explicitly accepts that recovery requires upgrade;
7. metrics/alerts and runbooks recognize retired-version attempts;
8. the contract bundle, implementation, and documentation preserve historical schemas/vectors for replay/audit.

The observation window length is a **HUMAN DECISION**; this result does not invent one.

## 6.3 Contract lifecycle state machine

```text
DRAFT
  | owner + limits + trust/privacy + schema + vectors + rejection defined
  v
EXPERIMENTAL
  | smallest prototype passes; no production dependency
  v
CANDIDATE
  | all required consumers, security/privacy review, compatibility matrix,
  | runbook, signed bundle, release gate
  v
ACTIVE
  | deployed under approved rollout
  v
DEPRECATED
  | replacement and retirement conditions published
  v
FROZEN
  | no new producers; consumers remain for rollback/replay
  v
RETIRED

Any non-retired state --incident authority--> EMERGENCY_BLOCKED
EMERGENCY_BLOCKED --fixed version/explicit authorization--> prior safe state or RETIRED
```

Transition rules:

| From → to | Mandatory evidence | Forbidden shortcut |
|---|---|---|
| Draft → Experimental | Name/version/owner placeholder resolved; trust/privacy classification; hard caps; parser profile; initial valid/invalid vectors | Calling a handwritten DTO a contract |
| Experimental → Candidate | Schemas/OAS; deterministic bundle; matrices; threat review; synthetic prototype; support owner; rejection contract | Integrating merely because code compiles |
| Candidate → Active | Release authorization; consumer readiness; staged plan; rollback path; signed artifacts; all earlier project gates required by dependency | Producer-first activation |
| Active → Deprecated | Replacement, migration, inventory, commitments, notice authority, runbook | Logging a warning without governance record |
| Deprecated → Frozen | New producer disabled; old readers retained; replay/restore need known | Deleting schema/code immediately |
| Frozen → Retired | Retirement gate in 6.2.4 | Calendar expiry alone |
| Any → Emergency-blocked | Incident reason, affected exact versions/capabilities, signed block, expiry/review, audit | Broad unsigned config edit |

An `experimental` contract must not be a production persistence or external commitment. Synthetic data only unless separately approved.

## 6.4 Producer/consumer rollout state machine

### 6.4.1 Major-version rollout

```text
R0: N-only consumers; N producers
  |
  | deploy code that can read N and N+1, but still emits N
  v
R1: dual-read consumers proved; N producers
  |
  | enable N+1 producer for synthetic/canary cohort
  v
R2: dual-read consumers; mixed N/N+1 producers
  |
  | observe correctness, privacy, resources, quarantine, rollback
  v
R3: dual-read consumers; N+1 default producer; N rollback path retained
  |
  | human retirement gate, zero supported N producers/consumers as applicable
  v
R4: N+1 consumer; N+1 producer; N frozen/retired
```

Rollback transitions:

- `R2 → R1`: disable N+1 producer for canary; affected N+1 messages already in custody continue through the N+1 consumer or quarantine. They are not relabeled as N.
- `R3 → R1/R2`: reactivate N producer for new data; retain N+1 consumer until all N+1 outbox/inbox/replay data and restore scenarios are resolved.
- Consumer rollback from dual-read to N-only is forbidden while any N+1 data can arrive or be replayed.
- A privacy/security incident may emergency-block N+1 before semantic processing. Custodied data follows incident/quarantine/deletion authority; it is not silently discarded.

### 6.4.2 Minor-version rollout

For `N.m → N.m+1`:

1. release and activate consumers that understand both exact versions;
2. prove old producer/new consumer and new producer/new consumer matrices;
3. prove routing/capability prevents new producer reaching an old strict consumer, or keep new fields un-emitted;
4. activate producer by synthetic/canary cohort;
5. observe safe metrics and data-quality invariants;
6. make new producer default;
7. deprecate the older minor only under the supported-window policy.

A schema that adds an optional property but immediately emits it to an old strict consumer is a breaking deployment even if its source-control version was labeled minor.

### 6.4.3 Patch rollout

Patch changes do not require a second domain model or semantic migration because accepted/emitted instance sets and semantics do not change. They still use **consumer-first activation**: every required consumer must receive the exact patch artifact and prove acceptance before a producer places that exact patch version on the wire. Multiple explicitly bundled patch versions may dispatch to the same reader only after schema-equivalence, golden-vector, generated-code, and error-behavior checks pass; an unknown patch is never accepted by range or wildcard. When a correction affects only catalogue prose or build metadata and need not identify a new wire artifact, producers should continue emitting the existing wire version. If a patch changes parser acceptance, generated nullability, enum behavior, canonical bytes, limits, or errors, it was misclassified and the gate fails.

## 6.5 Endpoint IPC compatibility handshake

Example `hello`:

```json
{
  "contract": {"name": "uam.ipc.hello", "version": "1.0.0"},
  "message_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c101",
  "launch_nonce": "N2JkQm9uZGVkU3ludGhldGljTm9uY2U",
  "session_binding": "<OS-derived binding proof, not a username>",
  "supported": [
    {"name": "uam.ipc.frame", "versions": ["1.0.0"]},
    {"name": "uam.privacy.transform-result", "versions": ["1.0.0"]}
  ]
}
```

Example `welcome`:

```json
{
  "contract": {"name": "uam.ipc.welcome", "version": "1.0.0"},
  "message_id": "018f1f6c-7b00-7a10-8c23-8a4f9b10c102",
  "in_reply_to": "018f1f6c-7b00-7a10-8c23-8a4f9b10c101",
  "selected": [
    {"name": "uam.ipc.frame", "version": "1.0.0"},
    {"name": "uam.privacy.transform-result", "version": "1.0.0"}
  ],
  "max_frame_bytes": 262144
}
```

Normative behavior:

- OS token/logon/session checks and pipe DACL are authoritative; self-declared `session_binding` is only a correlation/proof input as specified by the implementation ADR.
- No common exact version means close with a safe reason and disable/defer the affected capability. Do not fall back to an unlisted version.
- The selected limit is the minimum of released sender cap, receiver cap, and policy cap; negotiation cannot exceed either compiled ceiling.
- Handshake arrays are bounded and duplicate contract names/versions reject the handshake.
- A Task Host receives only contracts needed for its single invocation; it is not a general plugin channel.

## 6.6 Endpoint event, cursor, batch, and receipt transaction boundaries

### 6.6.1 Event/cursor commit

Within the SQLite one-writer transaction:

```text
BEGIN IMMEDIATE
  verify source generation and expected cursor precondition
  insert minimized event(s) with stable IDs/dedupe keys
  update source cursor/progress to the position represented by those events
  record run outcome/provenance needed for recovery
COMMIT
```

If any statement, validation, disk operation, process, or power event fails before commit, neither event nor cursor advance is considered durable. On restart, the source may be re-read and stable identities/dedupe suppress duplicate business effect.

The serialized wire DTO is not stored as an opaque mutable object if doing so would couple endpoint storage to server schema. Store explicit local domain/persistence fields plus the exact contract/provenance needed to deterministically build a supported batch. Any stored serialized snapshot is immutable evidence, not the database model used by all layers.

### 6.6.2 Local batch construction

- Select only committed unacknowledged events.
- Assign one stable `batch_id` and exact upload contract version.
- Produce deterministic logical JSON and compute canonical `batch_content_sha256` under the contract rule.
- Persist batch membership, version, hash, and state before network transmission.
- Retries reuse the same batch identity, membership, logical content, and hash. Recompression may alter HTTP `Content-Digest`, but not logical content hash.
- A producer upgrade must not mutate an already-created batch to a new schema. It either sends the old batch through a supported old producer path or performs an explicit, atomic, audited re-envelope operation whose identity/provenance semantics are specified in a major contract. Initial design keeps the old path.

### 6.6.3 Applying a receipt

In one local writer transaction:

```text
validate receipt exact version and signature/digest if defined
verify receipt batch_id and content hash equal persisted local batch
verify authenticated server context
mark batch custody-received with receipt_id/time
mark member events eligible for local cleanup under approved retention
COMMIT
```

A malformed, unsupported, mismatched, or ambiguous receipt leaves events unacknowledged. A network timeout after server commit causes a retry; the server returns duplicate custody evidence.

## 6.7 Server ingress and custody state machine

### 6.7.1 Pre-custody gate

The server performs only bounded checks needed to decide whether it can safely enter custody:

1. route/method and TLS/device authentication;
2. derive server-side realm and installation identity;
3. header and request-target limits;
4. allowed media type and `gzip` encoding;
5. compressed byte, streaming expanded byte, expansion ratio, time, and cancellation limits;
6. `Content-Digest` verification;
7. UTF-8, JSON grammar, duplicate member, root envelope, exact contract name/version, required batch ID/hash, and maximum event count checks;
8. supported/non-blocked version and signed release policy;
9. idempotency lookup for authenticated installation plus `batch_id`.

A failure here returns a safe non-custody Problem Details response. No custody receipt is issued. Minimal security evidence may be recorded under its own retention/privacy rules, but the rejected body is not copied to ordinary logs or quarantine.

### 6.7.2 Durable custody transaction

For a new supported batch:

```text
BEGIN
  insert immutable inbox record:
    server-derived realm_id and installation_id
    batch_id and canonical content hash
    exact contract name/version
    received time and bounded transport metadata
    durable content/content-addressed reference
    state = RECEIVED
  insert durable receipt record bound to the inbox record
  insert idempotency uniqueness key
COMMIT
return custody receipt
```

Uniqueness is at least `(authenticated_installation_id, batch_id)` and the stored content hash is compared. The exact relational key is implementation-specific but must preserve realm isolation and stable replay effect.

A database error before commit yields no receipt and is retriable according to the problem code. A process crash after commit but before response yields a duplicate retry and the same/equivalent receipt. A receipt table outside the declared durable transaction is forbidden.

### 6.7.3 Post-custody processing states

```text
RECEIVED
  -> VALIDATING (lease acquired)
       -> VALIDATED
            -> MATERIALIZING
                 -> MATERIALIZED
                      -> VISIBLE (only after visibility rules/readiness)
       -> QUARANTINED
  -> QUARANTINED (batch-level supported-content failure)

Lease expiry: VALIDATING/MATERIALIZING -> retry same state with attempt evidence
Deletion/tombstone: any materialized/visible state -> SUPPRESSED/DELETING -> DELETED
```

Rules:

- leases do not change custody;
- retries create one final business effect through stable event uniqueness;
- validation distinguishes contract-invalid, semantic-invalid, policy/provenance-invalid, and transient dependency failure;
- a quarantined batch/event remains in custody but not normal visible data;
- portal visibility is a separate state and not implied by materialization;
- counts in status are derived and consistent with item states;
- state transitions are monotonic except explicit retry/repair transitions with audit;
- worker code is version-aware and retains readers needed for all accepted inbox content and restore/replay.

## 6.8 Unsupported-schema behavior

| Situation | Boundary response | Custody? | Producer action | Operational evidence |
|---|---|---:|---|---|
| Unknown route major | 404/410 according to published route lifecycle | No | Upgrade/configuration correction | Bounded route-major count |
| Known route, unsupported body major | 422 `uam.contract.unsupported-version` | No | Use only released supported producer or upgrade | Family/major/outcome metric; protected cohort lookup |
| Exact version emergency-blocked | 422/403-style policy code as specified | No new custody; existing custody quarantined/frozen by incident plan | Stop capability; await signed recovery | Block ID/version, no payload |
| Known supported envelope but invalid event semantics discovered later | Receipt, then processing status `quarantined` | Yes | Do not resend under new ID; follow remediation | Quarantine reason code/count |
| Batch ID repeated with same hash | Existing/equivalent duplicate receipt | Already | Apply receipt | Duplicate counter |
| Batch ID repeated with different hash | 409 conflict/security signal | No for conflicting content | Stop automatic retry; incident path | Conflict count and protected identifiers |
| Schema bundle missing/corrupt on receiver | 503/endpoint safe-disable; do not parse permissively | No new boundary acceptance | Repair authorized release | Bundle digest/version health |
| Old consumer receives unnegotiated new minor | Reject exact version | No | Roll back producer/routing | Compatibility breach alert |

Unsupported content is not silently downgraded, partially parsed, stored in a generic “extra” column, or accepted under “latest.”

## 6.9 Quarantine lifecycle

```text
OPEN
  -> TRIAGED
       -> REPLAY_AUTHORIZED -> REPLAYING -> RESOLVED
       -> DATA_FIX_AUTHORIZED -> REPROCESSING -> RESOLVED
       -> DELETE_AUTHORIZED -> DELETING -> RESOLVED
       -> VERSION_BLOCKED
  -> EXPIRED/DELETED only under approved retention/deletion policy
```

Every privileged transition requires authorization, reason code, concurrency token, durable audit, and realm binding. Free-text notes, if allowed, are separate protected content with stricter access and are never metric labels. Reprocessing uses the original immutable content and exact reader version; it does not edit evidence in place. A corrected derived fact is a new domain action linked to the quarantine case.

## 6.10 Policy/ceiling lifecycle and downgrade prevention

```text
BUILT -> SIGNED -> RELEASE_AUTHORIZED -> STAGED -> ACTIVE
                                      \-> REVOKED/BLOCKED
ACTIVE -> SUPERSEDED -> RETAINED_FOR_VERIFICATION -> RETIRED
```

An evaluator accepts an artifact only when:

- signature, key purpose, issuer/audience, contract, canonical hash, and bundle chain validate;
- current time/validity rule passes under approved clock-skew policy;
- revision is not lower than the highest accepted revision, unless an explicit signed rollback authorization names both revisions and scope;
- tenant policy belongs to the authenticated realm and computes only an intersection/narrowing of the active product ceiling;
- every source, field, transformation, destination, and capability is known to that evaluator;
- the artifact is not emergency-blocked.

Unknown or invalid authorization fails closed. The last known authorized policy may remain active only under an explicitly approved offline/expiry rule; otherwise affected collection stops. This offline behavior is a **HUMAN DECISION** and must be tested.

## 6.11 Deletion and restore ordering

Deletion states:

```text
REQUESTED -> AUTHORIZED -> TOMBSTONED -> APPLYING -> VERIFIED -> COMPLETE
             \-> REJECTED
APPLYING -> PARTIAL_FAILURE -> APPLYING/OPERATOR_ACTION
```

Restore readiness ordering:

1. restore immutable custody/domain data into an isolated non-visible state;
2. restore/obtain the authoritative deletion/tombstone stream and latest revisions;
3. validate realm bindings and apply tombstones/suppression;
4. verify deletion checkpoints and completion evidence;
5. only then enable queries/portal/integrations;
6. audit readiness transition.

A restore that cannot prove deletion state remains non-visible. Replaying an acknowledged event after deletion must result in suppression/deletion according to the authoritative tombstone, not resurrection.

## 6.12 Compatibility observability

Required metrics use bounded labels only:

- `uam_contract_messages_total{family,major,direction,outcome}`;
- `uam_contract_rejections_total{family,major,error_class}`;
- `uam_contract_unsupported_total{family,major,component_class}`;
- `uam_contract_custody_total{major,custody}`;
- `uam_contract_processing_total{major,state}`;
- `uam_contract_rollout_state{family,major,state}` as a small gauge;
- `uam_contract_bundle_status{component_class,bundle_status}`;
- `uam_contract_quarantine_total{family,reason_code}`;
- `uam_contract_kill_switch{family,major,state}`;
- histograms for bounded payload bytes, expansion ratio, validation time, custody latency, and processing lag.

Protected inventory—not metric labels—answers which installation/cohort or named consumer is old. It must support:

- count of supported producers by exact contract version and software cohort;
- count of required consumers by read capability;
- last observed production time with instrumentation-health status;
- accepted inbox content by exact version still requiring replay/restore support;
- named external commitment and owner status.

Alert examples:

- any new producer version observed before all required consumers are ready;
- unsupported version above an approved noise threshold (threshold is operational decision);
- batch-ID/content conflict greater than zero;
- custody receipt issued without matching durable row (fitness check/continuous reconciliation);
- sudden unknown-member/duplicate-member or decompression-limit increase;
- active version with missing bundle/schema digest;
- kill switch near expiry without resolution;
- metric-series count above guardrail;
- old version population not decreasing or reappearing after freeze;
- deletion/restore readiness inconsistency.

## 6.13 Contract test strategy

The compatibility oracle is a layered executable suite:

1. **Meta/schema conformance** — every schema validates against Draft 2020-12; every local `$ref` resolves from the pinned bundle; official test-suite subset passes for the selected validator.
2. **Parser profile** — raw-byte tests prove duplicate, BOM, invalid UTF-8, depth, comments, trailing commas, number, time, UUID, unknown field, and null rules before typed binding.
3. **Golden vectors** — every producer emits byte/value-equivalent valid vectors; every consumer accepts them; invalid vectors fail with the specified code and no payload echo.
4. **Semantic property tests** — stable IDs, idempotency, realm binding, cursor/event atomicity, receipt meaning, policy intersection, and deletion suppression.
5. **Old/new matrix** — compiled historical producers and consumers exchange seeded messages in containers/processes; expected pass/fail is declared in source.
6. **Differential tests** — schema validator, runtime binder, generated client, and server endpoint agree on acceptance. Any disagreement fails the build.
7. **State/fault tests** — crash before/after commit, response loss, lease expiry, replay, rollback, kill switch, missing bundle, and restore/deletion order.
8. **Adversarial tests** — fuzz parsers and decompressors; remote-reference attempts; huge strings/maps; signature confusion; realm spoof; cardinality injection.
9. **Non-functional tests** — JSON/gzip bytes, CPU, allocation, latency; schema-validation cost; codegen determinism; metric series; accessibility checks for human surfaces.
10. **Release fitness tests** — no active contract lacks owner, limits, rejection, vectors, matrix, runbook, source register, or supported dependency evidence.

Passing a schema diff alone never authorizes rollout. Diff tools can miss semantic meaning, transaction behavior, generated-code regressions, and runtime parser differences.


---

# 7. Security/privacy threat and failure register

Owners below are accountability functions that must be assigned to named people/teams before candidate status. “Evidence” means privacy-safe artifacts: commands, versions, hashes, pass/fail output, bounded counters, and synthetic fixtures—not raw activity or credentials.

| ID | Threat/failure and trigger | Detection | Containment | Recovery | Cleanup/evidence | Owner function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T01 | Duplicate JSON members cause parser disagreement; attacker sends two `contract`, ID, realm-like, or policy fields | Raw-byte parser rejection counter; differential parser test | Reject before typed binding/custody; close IPC on violation | Correct producer; no replay of unchanged bytes | Retain safe code, family, major, digest/correlation only | Boundary parser owner | Duplicate at root/nested/object-discriminator across every parser/generator | A future library update may change behavior; pin and continuously test |
| T02 | Unknown/misspelled field is ignored and privacy/security meaning changes | Schema/runtime acceptance differential; unknown-member count | `unevaluatedProperties:false`; explicit disallow-unmapped options | Fix producer under version control; do not alias typo silently | Invalid vector and safe error code; no value echo | Contract authority + consumer owner | One unknown at each nesting level; case variants; extension-bag attempts | Extension points can still be abused if their invariants are weak |
| T03 | Over-depth, huge map/string/array, integer edge, or pathological JSON consumes memory/CPU | Byte/depth/allocation/latency limits; process health; fuzz telemetry | Stream/scan with hard caps and cancellation; reject pre-custody | Restart isolated worker if needed; patch parser/limits; block version if exploitable | Store seed hash, stack classification, tool/runtime version | Parser/security owner | Boundary values plus fuzz campaign and OOM-resistant harness | Unknown parser complexity or runtime bug may remain |
| T04 | Gzip/zip-style expansion bomb or malformed stream | Compressed/expanded byte and ratio counters; timeout | Stream decompression through absolute and ratio caps; abort; no body log | Fix producer or parser; temporary exact-version block | Seed digest and safe reason; no expanded bytes retained | Ingress owner | Nested/malformed gzip, truncated stream, high ratio, slow stream | CPU can be consumed below byte caps; time/allocation caps required |
| T05 | Remote `$ref`/schema import causes SSRF, local file read, UNC access, or supply-chain substitution | Build/runtime network-deny test; reference closure lint | Resolve only from signed local bundle allowlist; disable network schemes | Rebuild trusted bundle; rotate/revoke compromised artifact | Bundle manifest, ref graph, digests, build logs | Contract/release authority | HTTP/file/UNC/package refs, redirects, cycles, missing digest | Build tooling may fetch indirectly through plugins/dependencies |
| T06 | Version confusion/downgrade: body, route, signed artifact, or negotiated version disagree | Exact-version mismatch counter; monotonic revision check | Reject; never coerce; signed rollback only; emergency block | Roll forward or use authorized old producer path | Record versions, release/cohort, block/rollback authorization | Release + contract owner | Route/body mismatch, old revision, unlisted negotiation, replayed manifest | Authorized rollback could still re-enable a known-vulnerable version by human error |
| T07 | Tenant policy widens product privacy ceiling | Effective-policy proof fails intersection; canary fields | Fail closed; stop affected source/capability; retain last safe policy only under approved rule | Correct and re-sign policy; verify revision/realm | Safe capability/field identifiers and policy digests; audit | Privacy/policy authority | Property-based intersection tests, unknown capability, duplicate field, stale revision | A permitted field may still be legally or semantically inappropriate |
| T08 | Pre-minimization candidate leaks through Coordinator IPC, SQLite, logs, trace, dump, or network | Canary tokens and repository/runtime scanners; egress assertions | Kill task/source; isolate process; disable diagnostics; block release | Remove leak path; purge governed test artifacts; rerun G4/G5 | Canary-only evidence, storage/log scans, no real data | Privacy-transform + endpoint owners | Synthetic forbidden canaries through success, every exception, cancellation, crash | OS/EDR crash capture outside UAM control may collect process memory; host policy needed |
| T09 | Cross-session or unauthorized process connects to named pipe | OS token/session/DACL check failure; connection audit code | Explicit DACL/logon SID; per-launch nonce; close; rate-limit | Recreate pipe/process under correct session; security incident if repeated | SID class/session result, not username; binary/version hash | Endpoint IPC/security owner | Same user different session, different user, low integrity, service, remote attempt | Windows/environment products may alter tokens; lab matrix required |
| T10 | User Host submits as another realm/device via payload claim | Server compares/ignores claims; realm-isolation assertion | Derive realm/installation only from auth context; reject forbidden authority fields | Fix producer; revoke credentials on malicious conflict | Authenticated installation reference in protected log; safe metric class | Device identity + ingestion owner | Cross-realm claim, stolen/revoked credential simulation, route confusion | Compromised valid device identity can submit within its own realm until revoked |
| T11 | Replay creates duplicate business effect | Unique-key conflicts, duplicate custody count, aggregate reconciliation | Stable event/batch IDs; canonical hash; transactionally idempotent materialization | Re-run safely; repair derived view from immutable facts | Receipt/event uniqueness evidence and replay run log | Ingestion/domain owner | Retry before/after response, parallel duplicate, worker replay, restore replay | Incorrect semantic dedupe key may merge distinct events or miss duplicates |
| T12 | Same batch ID is reused with different content | ID/hash conflict counter and alert | 409; do not overwrite; stop automated retry; protect evidence | Determine producer corruption/compromise; rebuild only via explicit new logical identity policy | Two hashes, auth context reference, versions; never payload | Endpoint outbox + ingestion/security owners | Sequential/parallel conflict, compressor changes, canonicalization differential | Hash collision is cryptographically remote; canonicalization bugs are more plausible |
| T13 | Server returns receipt before durable commit or outside failure domain | Fault injection and reconciliation: every receipt maps to committed row | Single transaction; response only after commit; block ingress version if invariant fails | Restore/repair; endpoints retry; reconcile issued receipts | Database LSN/transaction evidence appropriate to engine, receipt IDs, no payload | Ingestion persistence owner | Crash/power/process/network fault at every transaction boundary | Storage system may acknowledge before true durable media under its configuration; engine/infra proof needed |
| T14 | Endpoint applies forged/mismatched receipt and deletes unacknowledged data | Local receipt validation error; batch/hash mismatch | Reject receipt; retain events; authenticate server; atomic apply | Retry/query known server; rotate trust if compromised | Safe mismatch code, receipt/batch refs in protected log | Endpoint receipt owner | Wrong batch/hash/version/server, duplicate receipt, crash during apply | Endpoint trust-store compromise could accept forged server identity |
| T15 | Full-schema/semantic failure after custody leaks rejected payload through quarantine/UI | DLP/canary scan; authorization and API contract test | Quarantine body in protected store/pointer; normal API exposes codes/counts only | Authorized replay/delete; patch validator/producer | Case metadata, access/audit records, payload hash only in normal evidence | Quarantine/security operations owner | Forbidden canary in errors, metrics, portal, exports, support bundles | Authorized responders may access sensitive evidence; governance and retention remain human |
| T16 | Metric label injection/cardinality DoS from IDs, domains, paths, errors, extension values | CI label-enum calculation; runtime series count | Allowlisted bounded labels; reject arbitrary label values; disable offending instrumentation | Patch metric mapping; restart exporter if needed | Series inventory and instrument/version; no high-cardinality values | Observability owner | Corpus of unique IDs/domains/errors; upper-bound test; exporter stress | Logs/traces can still become high-cardinality/costly if review misses a field |
| T17 | Generated client/server changes nullability, presence, enum, or defaults silently | Generated-code golden diff; compile/analyzer and vector matrix | Pin tool/version/digest; isolate generated code; block drift | Revert tool; update under explicit compatibility review | Generator binary/package digest, config, output hash | Contract toolchain owner | Required-nullable truth table, old/new generated clients, deterministic rebuild | Generator may have semantic bugs not covered by fixtures |
| T18 | Shared DTO couples persistence/API/portal/external consumer | Architecture test and dependency graph | Separate assemblies; adapter-only mapping; ban ORM/UI annotations in wire types | Refactor before integration; new external projection/version if already exposed | Dependency graph, public API baseline, mapping tests | Architecture owner | Forbidden reference/attribute/public exposure injected intentionally | Teams may duplicate semantics inconsistently; field dictionary/governance still needed |
| T19 | Contract/schema changes without version bump or wrong bump | CI diff + manually declared semantic checklist + matrix | Block merge/release; require ADR and correct version | Reclassify, regenerate, rerun all consumers | Diff report, reviewer decision, matrices | Contract authority | Corpus of breaking/additive/patch examples; tool false-negative tests | Semantic changes can evade automated diff and reviewer understanding |
| T20 | Old version removed while offline endpoint, inbox replay, restore, or external consumer still needs it | Protected capability/inventory and historical inbox/version query | Freeze removal; retain readers/bundles; stop release | Re-enable supported reader or upgrade producer/consumer under incident plan | Inventory health, last-seen, commitments, replay test | Compatibility/support owner | Long-offline synthetic endpoint, restored old inbox, named-consumer stub | “No observations” may reflect broken telemetry; human commitment inventory can be incomplete |
| T21 | Producer-first rollout sends new minor/major to strict old consumer | Readiness gate and version-by-stage metrics | Routing denies activation; kill producer flag; keep old producer | Roll back producer; continue new reader for custodied data | Cohort/version/outcome evidence, flag audit | Release owner + every consumer owner | Deliberately start producer first; race during rolling deployment | Undocumented consumer may exist outside inventory |
| T22 | Feature flag changes semantics or bypasses policy/schema | Static flag registry and runtime invariant checks | Flags select only released behaviors; privacy/validation cannot be disabled; signed config | Revert flag; block exact release/capability; audit | Flag ID, scope, revision, actor, before/after—not payload | Release/config owner | Unauthorized flag, stale config, widening attempt, restart persistence | Excessive flag combinations multiply untested states |
| T23 | Signed control artifact algorithm/key/audience confusion or canonicalization mismatch | Signature verification codes; golden cross-implementation vectors | Algorithm allowlist, key purpose/audience/issuer, JCS, duplicate rejection, revocation/block | Roll keys/artifact; use safe deny/last-safe policy per approved offline rule | Key ID/purpose, artifact digest/revision, verification result | Key management + policy/release owner | `alg:none`, wrong key type/purpose/audience, duplicate, Unicode/number vector, stale key | Authorized key compromise or mis-issuance remains high impact |
| T24 | Clock skew rejects valid policy or accepts stale one | Signed-time failure metrics and bounded clock-health status | Do not use event clock for auth; approved skew/offline rule; source kill on unsafe state | Restore trusted time or issue authorized artifact; incident review | Clock class/delta bucket, not device ID in metrics | Endpoint platform + policy owner | Future/past clocks, suspend/resume, DST irrelevant UTC, expired artifact offline | Time service compromise can affect availability or validity decisions |
| T25 | Deletion tombstone missing/stale during restore resurrects data | Restore-readiness reconciliation and tombstone revision checkpoint | Keep restored data non-visible; stop integrations | Obtain/apply authoritative deletion state; repeat verification | Restore manifest, deletion revision/checkpoints, readiness audit | Deletion/restore owner | Restore before/after deletion, partial tombstone stream, acknowledged replay | External copies or backups outside UAM control require separate commitments |
| T26 | Audit write fails but privileged mutation succeeds | Transaction invariant/reconciliation | Couple mutation and durable audit in one boundary/transaction or fail mutation | Retry authorized command with idempotency; repair only under incident control | Command ID, outcome, transaction evidence | Control/audit owner | Crash and storage fault around every mutation/audit step | Different audit technology may make atomicity harder; design proof required |
| T27 | Data quality error is syntactically valid but semantically wrong | Provenance, invariant, aggregate reconciliation, reason-code trends | Quarantine affected items/version; do not “fix” silently in adapter | Correct mapping/source rule under new revision; replay immutable custody data | Rule/schema revisions, counts, synthetic expected outputs | Domain/data-quality owner | Boundary dates, generation reset, identity/dedupe ambiguity, changed classification | Business meaning is human-defined and may be wrong despite passing tests |
| T28 | Error/diagnostic response exposes source values, tokens, internal paths, or stack traces | Canary/DLP scans of logs, Problem Details, traces, support bundles | Central safe-error mapper; no exception/body echo; disable unsafe diagnostic mode | Patch, rotate exposed secrets if any, governed deletion of diagnostics | Canary findings, affected code/version, cleanup proof | Every boundary owner + privacy/security review | Exceptions at parse/map/DB/network/signature stages with canaries | Third-party infrastructure may log headers/bodies unless configured and verified |
| T29 | Contract dependency/license/security posture changes unnoticed | Lockfile/SBOM/license/advisory diff; pinned source/release review | Block upgrades/new dependency; use reference implementation only where possible | Replace/revert/update after review | Package/repo commit, license texts, advisory results, reproducible build | Supply-chain/legal/security owners | Tampered package, missing provenance, license-policy gate, vulnerable transitive dependency | Zero-day and maintainer compromise cannot be eliminated |
| T30 | Accessibility failure hides status/error or prevents keyboard operation in admin contract views | Automated checks plus manual keyboard/screen-reader test | Block UI release; machine API remains stable; provide accessible non-payload status | Fix view/localization without changing machine contract | Test reports and screenshots using synthetic records only | Portal/accessibility owner | Focus, status announcement, table headers, no color-only, zoom/text spacing | Automated tools do not prove full accessibility; human evaluation required |
| T31 | Incident kill switch itself is unavailable, stale, overbroad, or never expires | Signed-manifest health, expiry alert, deployment convergence | Compiled safe deny for affected capability; bounded scope; independent distribution path where approved | Reissue signed switch, roll release, reconcile endpoints/servers | Block ID, versions, scope, expiry, convergence counts | Incident/release authority | Offline endpoint, stale cache, invalid signature, expired block, rollback | Offline devices may not receive a central block until reconnect; local release controls matter |
| T32 | Unsupported old parser remains reachable through forgotten route/worker | Route and binary inventory; active-reader manifest reconciliation | Remove network reachability or block exact version; retain only isolated replay tooling | Upgrade/retire under gate; verify no path accepts it | Deployed component hashes and route map | Platform/release owner | Endpoint/API discovery, worker replay with old messages, shadow route probe | Asset inventory can be incomplete; continuous reconciliation needed |

## 7.1 Incident response pattern for contract incidents

Every runbook uses the same phases:

1. **Detect:** identify exact contract family/version, component release, stage, error class, first/last safe time, and whether custody/privacy/realm/audit/deletion invariants may be affected.
2. **Contain:** stop only the affected producer, consumer route, capability, or exact version using signed/repository-authorized controls; preserve unacknowledged endpoint data; quarantine already-custodied content; prevent visibility/integration if uncertain.
3. **Recover:** choose roll-forward, producer rollback, consumer dual-read restoration, policy/key correction, deterministic replay, or deletion. Never relabel bytes or silently drop.
4. **Clean up:** expire temporary flags/blocks; remove unsafe diagnostics; reconcile receipts, inbox, materialization, audit, and tombstones; rotate credentials/keys if relevant; delete governed test evidence.
5. **Prove:** attach synthetic reproduction, tool/runtime/schema/release hashes, commands, fault points, aggregate counts, and invariant assertions. No raw activity is required.
6. **Review:** decide whether the contract version, compatibility policy, limit, dependency, runbook, or ADR must change and whether external notification authority is engaged.

Severity is determined by impact to privacy, realm isolation, acknowledged data, deletion, privileged audit, and recoverability—not merely HTTP error rate. Exact severity labels and notification rules are **HUMAN DECISION**.


---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Required test matrix by contract family

Legend: **M** mandatory before candidate; **R** required before active release; **N/A** structurally not applicable. “Matrix” means executable old/new producer-consumer combinations, not a spreadsheet assertion.

| Family | Meta/schema | Raw parser | Golden/canonical | Old/new matrix | Auth/realm/session | Crash/transaction | Fuzz/resource | Privacy canary | Rollback/kill | Accessibility |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Collector invocation/result | M | M | M | M | R session | R process/cancel | M | M | R | N/A |
| Privacy transformation | M | M | M | M | R session | R failure paths | M | M | R source kill | N/A |
| IPC handshake/frame | M | M | M | M | M | M disconnect/restart | M | M | M | N/A |
| Ceiling/policy/block manifest | M | M | M + JCS/JWS | M evaluator/artifact | M realm/key | M atomic apply | M | M | M | R admin view |
| Local event/progress/batch | M | M | M | M | R local identity | M SQLite fault | M | M | M | N/A |
| Upload batch | M | M | M + digest | M | M auth/realm | M response-loss | M | M | M | N/A |
| Receipt/status | M | M | M | M | M server binding | M atomic apply | M | R | M | R status view |
| Quarantine | M | M | M | M replay readers | M realm/RBAC | M transition/audit | M | M | M | M |
| Health | M | M | M | M | M realm/component | R drop/no activity effect | M cardinality | M | R | M dashboard |
| Audit command/record | M | M | M | M | M RBAC/realm | M mutation/audit | M | M | M | M |
| Named integration | M | M | M | M per consumer | M auth/realm | M retry/idempotency | M | M | M | R human surfaces |
| Deletion/tombstone/evidence | M | M | M + signature if selected | M restore readers | M auth/realm | M deletion/restore | M | M | M | M |
| Problem Details | M | M | M | M client fallback | R safe identity | R failure mapper | M | M | R | M |
| Bundle manifest | M | M | M + JCS/JWS | M component/bundle | M key/audience | M atomic activation | M refs/archive | M | M | R release UI |

## 8.2 Prototype evidence format

Each prototype writes an immutable evidence directory containing:

```text
/evidence/<prototype-id>/<run-id>/
  README.md                 # purpose, date, operator function, synthetic-only declaration
  environment.json         # OS/runtime/tool versions; no host address/user/credential
  inputs.manifest.json      # fixture names and SHA-256
  commands.txt              # redacted, reproducible commands
  results.json              # machine assertions and bounded measurements
  stdout.txt / stderr.txt   # scrubbed; no payload beyond approved synthetic fixtures
  artifacts.manifest.json   # outputs and SHA-256
  cleanup.json              # resources removed and verification
```

A result that lacks fixture hashes, exact tool/runtime versions, command line, and cleanup status is not gate evidence.

## 8.3 Smallest falsifying prototypes

### P01 — Strict parser and validator differential

**Claim to falsify:** every supported .NET parser path and JSON Schema validator accepts/rejects UAM-JSON-1 identically.

- **Setup:** one .NET test project with the production raw-byte scanner/binder, selected JSON Schema validator candidate(s), and a generated-model adapter. Pin the SDK and packages. Use only synthetic fixtures.
- **Instrumentation:** input byte count, depth, allocations, elapsed time, acceptance stage, stable error code, exception class stripped of message, and process peak working set.
- **Steps:** run valid boundary fixtures; then duplicate keys at each depth, BOM, invalid UTF-8, comments, trailing commas, wrong case, unknown fields, absent/null pairs, out-of-range integers, upper-case/invalid UUIDs, invalid timestamps, 15/16/17 depth, oversized strings/maps/arrays, and unpaired surrogates. Compare raw scanner, binder, schema validator, and HTTP/IPC adapter outcomes.
- **Pass:** all valid vectors are accepted; all invalid vectors fail at or before the declared stage with the exact safe code; no parser disagreement; no payload appears in logs; 17-depth and over-limit inputs do not cause unbounded allocation.
- **Fail/stop:** any disagreement, ignored duplicate/unknown member, case-insensitive binding, default injection, exception/body echo, or resource escape. Stop all component integration using that parser/toolchain.
- **Evidence:** `results.json` per vector, package lock, binaries/hashes, allocation trace summary, scrub scan.
- **Duration (ESTIMATE):** setup 0.5–1 engineer-day; deterministic suite under 10 minutes; fuzz extension separately.
- **Cleanup:** delete temp fixtures/process dumps; retain only approved synthetic vectors and aggregate traces.

### P02 — Schema lint, reference closure, and immutable bundle

**Claim to falsify:** a contract bundle is self-contained, deterministic, and cannot cause network/file reference resolution.

- **Setup:** `Uam.Contracts.Cli`, pinned schemas, local Draft 2020-12 metaschemas, pinned official JSON Schema Test Suite subset, and a network-denied CI container/job.
- **Instrumentation:** reference graph, resolved URI scheme, schema digest, bundle digest, deterministic rebuild comparison, linter rule results.
- **Steps:** validate every schema; traverse every `$ref`; build twice in clean workspaces; inject HTTP, redirect, `file:`, UNC-like, missing, cyclic, and digest-mismatch references; attempt to replace content under the same `$id`.
- **Pass:** valid bundle resolves only manifest-pinned local artifacts; clean builds are byte-identical; every injected reference/content mutation is rejected; official conformance subset passes.
- **Fail/stop:** any network request, local-file escape, mutable `$id`, unresolved ref, different clean-build bytes, or validator conformance failure. No candidate transition.
- **Evidence:** ref graph, network-deny log, two manifests/digests, test-suite commit, tool versions.
- **Duration (ESTIMATE):** setup 1 day; run under 5 minutes.
- **Cleanup:** destroy build workspaces and containers; retain manifests and synthetic schemas.

### P03 — Canonical JSON, hash, digest, and signed-artifact interoperability

**Claim to falsify:** independent implementations produce the exact Section 5.14 bytes/hash and verify signed control artifacts consistently.

- **Setup:** at least two independent JCS implementations or one implementation plus RFC/reference vectors; a test-only key; detached JWS verifier profile; no production keys.
- **Instrumentation:** canonical UTF-8 hex, SHA-256, protected header, signature result, verification error code, elapsed/allocation.
- **Steps:** reproduce the normative vector; test property order, escapes, composed/decomposed Unicode, permitted integer boundaries, duplicate names, unsupported numbers, wrong key/purpose/audience, `alg:none`, modified payload, stale revision, and unknown critical header.
- **Pass:** exact 169 bytes and published digest match; all valid cross-implementation signatures verify; every confusion/mutation fails closed with bounded code; duplicate names are rejected before canonicalization.
- **Fail/stop:** byte/hash disagreement or any invalid signature accepted. Signed policy/release work stops.
- **Evidence:** canonical bytes, hashes, test public key fingerprint, implementation versions/commits, vector outcomes.
- **Duration (ESTIMATE):** 1–2 days setup; run under 5 minutes.
- **Cleanup:** destroy private test keys; record destruction; retain public test material and synthetic vectors.

### P04 — Old/new producer-consumer executable matrix

**Claim to falsify:** declared compatibility and rollout order match runtime behavior.

- **Setup:** build immutable fixtures/binaries for `producer N`, `producer N+1`, `consumer N`, and `consumer N+1`; define expected matrix in source. Include minor additive and major breaking examples.
- **Instrumentation:** producer version, emitted contract/hash, consumer version, accept/reject code, mapped domain result hash, resource measurements.
- **Steps:** execute every pair; run new consumer with old producer, new/new, old consumer/new producer, rollback producer after mixed traffic, and replay stored N/N+1 batches. Deliberately mislabel a breaking schema as minor.
- **Pass:** outcomes exactly match declared matrix; consumer-first pairs pass; prohibited producer-first path is prevented or safely rejected; rollback preserves new reader until all N+1 data drains; misclassified change fails CI.
- **Fail/stop:** an undeclared acceptance/rejection, semantic output mismatch, or removal of a reader needed for replay. Stop rollout.
- **Evidence:** binary/schema digests, full matrix JSON, mapped result hashes, route/capability configuration.
- **Duration (ESTIMATE):** initial harness 2–3 days; each matrix run under 20 minutes.
- **Cleanup:** remove containers/temp databases; retain synthetic messages and results.

### P05 — Generated-code nullability and deterministic build

**Claim to falsify:** pinned code generation preserves presence/nullability/enums and yields deterministic adapter-only output.

- **Setup:** selected OpenAPI generator(s), truth-table schema with required nullable, required non-nullable, optional nullable, optional non-nullable, enum, unknown field, and default cases; Windows and Linux CI where supported.
- **Instrumentation:** generated source hashes, public API signature, compiler/analyzer warnings, serialization outcomes.
- **Steps:** generate twice on each OS; compile with nullable warnings as errors; run all presence/null combinations; update generator to a candidate version and compare; scan generated code for persistence/UI dependencies.
- **Pass:** same normalized output/public API across clean runs or a documented deterministic platform pin; truth table matches schema; no silent nullability loss; adapter-only dependency rule passes.
- **Fail/stop:** a generator changes acceptance, drops nullability, injects defaults, or differs nondeterministically without controlled normalization. Revert/pin; no rollout.
- **Evidence:** generator package/image digest, config, generated diff/hash, test table.
- **Duration (ESTIMATE):** 1–2 days setup; run under 10 minutes.
- **Cleanup:** delete generated temp trees; retain approved snapshot and hashes.

### P06 — Windows named-pipe session isolation and framing

**Claim to falsify:** only the intended session process can complete handshake and exchange bounded frames with the Coordinator.

- **Setup:** approved Windows lab; low-privilege Coordinator test service; two synthetic local test users and at least two interactive sessions where available; User Host test binary. Use placeholder deployment commands and no connection details in evidence.
- **Instrumentation:** OS token class, session/logon binding result, DACL summary without account names, handshake/version result, frame length/timing, process exit code.
- **Steps:** intended session connects; different user, same user/different session, service context, low-integrity or otherwise restricted process where supported, guessed pipe name, stale nonce, unsupported version, partial/over-limit frame, reconnect storm, and Coordinator restart attempts.
- **Pass:** only intended peer succeeds; all others fail before application data; no remote access; over-limit/partial frames close safely; no raw candidate or identity name in logs; restart creates fresh binding.
- **Fail/stop:** any cross-session/user connection or default broad ACL. Stop G1 and all dependent IPC work.
- **Evidence:** sanitized DACL/SID-class assertions, test case results, binary/OS build/runtime versions, event-code scan.
- **Duration (ESTIMATE):** 1–3 lab days depending on session environment; suite 30–60 minutes.
- **Cleanup:** uninstall test service/binaries, remove test users/sessions and pipe artifacts under lab procedure, scrub logs to approved evidence.

### P07 — Privacy transformation canary containment

**Claim to falsify:** forbidden source values never cross the privacy boundary in success, error, cancellation, crash, or diagnostics.

- **Setup:** synthetic collector fixture containing unique canaries for path, query, title, username-like text, raw row, internal-address-like text, and secret-like token; all fictional. Instrument Coordinator IPC, SQLite, logs, traces, dumps/support bundle, and captured network.
- **Instrumentation:** exact canary scanner over approved lab artifacts; process boundary events; safe error codes; memory/disk/network destinations.
- **Steps:** normal transform; schema failure; policy deny; timeout/cancel; collector exception; transformer exception; Coordinator disconnect; disk full; process crash; diagnostic elevation; batch upload.
- **Pass:** only approved minimized value appears beyond transformer; every forbidden canary count is zero in Coordinator-visible/durable/diagnostic/network artifacts; cursor does not advance on failed transform.
- **Fail/stop:** any forbidden canary escapes. Stop G4/G5 and open incident/change ADR.
- **Evidence:** canary manifest hashes, scan paths/classes, zero/nonzero result, process/build/config hashes.
- **Duration (ESTIMATE):** 2–4 days setup; run 30–90 minutes.
- **Cleanup:** securely remove lab artifacts containing canaries; keep hashes and zero-result report, not dump contents.

### P08 — Atomic minimized-event and cursor crash invariant

**Claim to falsify:** a source cursor never advances ahead of durable minimized events.

- **Setup:** endpoint SQLite schema and one-writer implementation; seeded synthetic source generation with deterministic event IDs; fault hooks before/after each SQL statement and commit boundary.
- **Instrumentation:** transaction hook, WAL state summary, event/cursor counts and hashes, restart/recovery outcomes.
- **Steps:** inject exception/process termination and, in an approved VM, power-loss-equivalent termination at each hook; restart; re-read source; repeat event; run WAL checkpoint variants; disk-full and busy cases.
- **Pass:** after every restart, cursor is either old with no new durable events or new with all represented events durable; retry may duplicate attempted reads but final event uniqueness/business effect is one; no silent loss.
- **Fail/stop:** cursor ahead, missing represented event, or acknowledged cleanup before receipt. Stop G5.
- **Evidence:** fault-point matrix, database integrity output, event/cursor hashes, build/runtime/SQLite versions.
- **Duration (ESTIMATE):** harness 2–4 days; automated run 1–3 hours.
- **Cleanup:** delete synthetic databases and VM snapshots; retain matrix and hashes.

### P09 — Durable receipt transaction and response-loss matrix

**Claim to falsify:** every issued receipt corresponds to committed durable custody and every committed batch can recover from a lost response.

- **Setup:** ingestion service, selected relational engine candidate/config, durable inbox/receipt transaction, synthetic authenticated installation/realm, network proxy/fault injector.
- **Instrumentation:** transaction IDs/commit markers, receipt/inbox reconciliation, HTTP fault point, restart logs, storage durability settings.
- **Steps:** fail before insert, between inbox/receipt operations, before commit, after commit/before response, mid-response, and during duplicate retry; restart service/database where approved; query reconciliation.
- **Pass:** no pre-commit receipt; after-commit loss returns duplicate custody on retry; one immutable inbox row and one logical receipt; realm/install derived from auth; no payload in logs.
- **Fail/stop:** orphan receipt, committed batch unrecoverable by retry, or duplicate business effect. Stop server integration.
- **Evidence:** fault matrix, SQL transaction/reconciliation scripts and outputs, config/version hashes, synthetic IDs.
- **Duration (ESTIMATE):** 3–5 days harness per engine; run 1–2 hours.
- **Cleanup:** drop synthetic realm/data and test credentials; verify zero rows; retain aggregate evidence.

### P10 — Idempotent replay and batch-ID/content conflict

**Claim to falsify:** retries/replays create one business effect and conflicting content cannot overwrite custody.

- **Setup:** endpoint batch builder, ingress, worker/materializer, uniqueness constraints, deterministic synthetic events.
- **Instrumentation:** inbox/event/fact counts, hashes, receipt IDs, conflict counter, worker attempts.
- **Steps:** same request sequentially and concurrently; same logical JSON with different gzip byte stream; worker lease expiry; server restart; restore/replay; same batch ID with one-byte logical mutation; same event in differently formed batch only where contract permits.
- **Pass:** same logical batch yields duplicate custody and one final fact; gzip instance digest may differ but canonical content hash matches; conflicting logical hash returns 409, no overwrite, no automatic new ID; replay remains one effect.
- **Fail/stop:** duplicate fact, overwrite, or false conflict for equivalent canonical content. Stop ingestion/materialization.
- **Evidence:** request/receipt/fact hash graph, database uniqueness output, concurrent test report.
- **Duration (ESTIMATE):** 1–2 days setup; run 20–60 minutes.
- **Cleanup:** remove synthetic data/credentials; retain graph and counts.

### P11 — JSON/gzip measurement gate before binary encoding

**Claim to falsify:** strict JSON plus gzip is adequate for the approved performance/resource budget.

- **Setup:** versioned generator creates seeded synthetic corpora across small/median/large/boundary events, repeated and high-entropy site keys, multiple batch counts, and offline backlog shapes. Benchmark endpoint serialize/hash/gzip and server stream/decompress/parse/validate.
- **Instrumentation:** raw/compressed bytes, ratio, CPU time, wall time, allocations, peak working set, throughput, p50/p95/p99 over repeated runs, machine/runtime configuration and thermal/power mode where applicable.
- **Steps:** warm up; run uncompressed and gzip levels selected for evaluation; vary 1/10/100/1,000 events and caps; measure endpoint and server independently; verify output against golden schema; repeat on representative minimum endpoint class when available.
- **Pass:** meet human-approved budgets with margin and no invariant/compatibility failure. Until budgets exist, result is measurement only, not a production pass.
- **Fail/stop:** after budgets are approved, any reproducible budget miss or invariant/compatibility failure fails JSON fitness for the tested profile. Before budgets exist, the production encoding gate remains `STOP`; absence of a budget cannot be used either to approve JSON for production or to justify binary.
- **Binary-evaluation trigger:** one or more approved byte/CPU/latency/memory budgets fail reproducibly and profiling attributes a material share to encoding; then prototype one binary candidate under a separate ADR using identical corpus. A failed JSON test does not itself approve the binary candidate.
- **Evidence:** corpus seed/generator commit, benchmark raw data, summary, environment, flame/allocation profiles with synthetic symbols only.
- **Duration (ESTIMATE):** harness 2–3 days; each platform run 1–3 hours.
- **Cleanup:** remove large generated corpus/profiles after hashing; retain generator, seed, summaries.

### P12 — Compression and parser resource-abuse gate

**Claim to falsify:** hard limits contain malicious/broken inputs without service instability.

- **Setup:** ingress/IPC parsers in isolated resource-constrained processes; synthetic bomb corpus; cancellation and concurrency driver.
- **Instrumentation:** CPU, allocations, peak memory, handles, threads, queue depth, request duration, post-test health.
- **Steps:** exact cap ±1 byte/item/depth; 20:1 ± boundary; truncated/corrupt gzip; repeated keys; deeply nested arrays; long property names; many small requests; slow body; cancellation; parallel attack while valid traffic runs.
- **Pass:** invalid inputs reject within released resource/time caps; valid traffic retains an approved minimum service level once defined; no crash, leak, starvation, payload log, or receipt.
- **Fail/stop:** cap bypass, process instability, or receipt for rejected content. Block boundary release.
- **Evidence:** corpus hashes, resource graphs, error counts, valid-traffic results.
- **Duration (ESTIMATE):** 2–4 days harness; run 1–4 hours.
- **Cleanup:** delete bomb corpus and traces after hashing/scrub; reset service and verify health.

### P13 — Privacy ceiling, tenant narrowing, signed block, and rollback

**Claim to falsify:** policy evaluation cannot widen the ceiling or accept untrusted/stale/downgraded artifacts.

- **Setup:** synthetic ceiling/policies, test signing keys, endpoint/server evaluators, staged flag/block controller.
- **Instrumentation:** artifact/revision/digest, effective capability/field set hash, verification result, collection activation, audit transition.
- **Steps:** subset policy; attempted added field/source/destination; unknown capability; wrong realm/audience/key/purpose; expired/future/replayed revision; signed authorized rollback; unsigned rollback; exact-version block while offline/reconnect; block expiry.
- **Pass:** effective policy is mathematical subset; all widening/invalid cases deny; authorized rollback alone succeeds; block stops only declared scope; audit and expiry behavior are exact; no candidate value leaks.
- **Fail/stop:** any widening or untrusted/downgraded acceptance. Stop policy and collection release.
- **Evidence:** synthetic artifact/public-key hashes, set comparisons, state/audit results.
- **Duration (ESTIMATE):** 2–3 days setup; run 20–40 minutes.
- **Cleanup:** destroy test private keys; remove policies and synthetic data; retain public vectors/results.

### P14 — Realm isolation and authenticated-context binding

**Claim to falsify:** no payload, route, replay, query, quarantine, audit, integration, or deletion message can cross realm authority.

- **Setup:** two fictional realms with separate synthetic authenticated installations and operators; identical-looking IDs where feasible; ingress, control, quarantine, integration stub, deletion service.
- **Instrumentation:** server-derived realm at each boundary, authorization decision, database query plan/filter assertion where useful, audit record.
- **Steps:** claim other realm in body/header/path; replay realm A batch under B identity; query A receipt/status as B; mutate/quarantine/replay/delete A as B; integration callback/ack with swapped realm; restore/tombstone mismatch.
- **Pass:** every cross-realm attempt is denied before data disclosure/mutation; no existence oracle beyond approved generic response; all accepted rows derive realm from authenticated context; audits bind the actual realm.
- **Fail/stop:** any cross-realm read/write/delete or payload-derived realm. Stop production approval.
- **Evidence:** synthetic authorization matrix, schema/query assertions, safe audit results.
- **Duration (ESTIMATE):** 3–5 days initial harness; run under 1 hour.
- **Cleanup:** delete fictional realms/credentials/data; verify no residual rows; retain matrix.

### P15 — Quarantine, errors, logs, traces, and support-bundle privacy

**Claim to falsify:** rejected content never appears in normal observability or operator surfaces.

- **Setup:** synthetic invalid batches with unique canaries; full logging/tracing/metrics stack and quarantine/control UI/API; support-bundle generator if any.
- **Instrumentation:** canary scanner, API/UI response capture, metric label/series inventory, access/audit record.
- **Steps:** trigger every error class at parser, auth, schema, semantic, DB, worker, integration, and deletion stages; inspect standard and elevated diagnostics; attempt unauthorized quarantine access; export/support bundle.
- **Pass:** zero forbidden canaries outside separately authorized protected evidence store; Problem Details/status contain only allowed codes; metric labels are bounded; unauthorized access denied/audited; no stack/internal path/token.
- **Fail/stop:** any payload/canary leak. Disable affected diagnostics/surface and block release.
- **Evidence:** canary hashes, scan result by destination class, access matrix, series count.
- **Duration (ESTIMATE):** 2–4 days setup; run 30–90 minutes.
- **Cleanup:** delete protected synthetic evidence and diagnostics; verify; retain scan report.

### P16 — Deletion, acknowledged replay, and restore readiness

**Claim to falsify:** restore/replay cannot resurrect data covered by an authoritative tombstone.

- **Setup:** synthetic realm/events with receipts, materialized facts, portal/integration projection, deletion request/tombstone/status, backup/restore test environment.
- **Instrumentation:** custody/materialization/visibility/deletion states, tombstone revision/checkpoint, query/integration results, audit chain.
- **Steps:** acknowledge and materialize; delete; replay endpoint batch and worker; restore backup from before deletion; attempt visibility before tombstones; apply partial/out-of-order tombstones; finish deletion state; enable readiness.
- **Pass:** deleted target never becomes visible/exported after tombstone authority; restore remains closed until deletion state is complete; replay is suppressed; completion evidence and audit are consistent.
- **Fail/stop:** any resurrection or readiness without deletion proof. Stop restore/production gate.
- **Evidence:** state timeline, backup/tombstone manifests/hashes, query/export assertions, audit IDs.
- **Duration (ESTIMATE):** 3–7 days setup depending on storage; run 2–4 hours.
- **Cleanup:** destroy restore environment and synthetic backups/data under lab procedure; retain manifests/results.

### P17 — Metric-cardinality fitness

**Claim to falsify:** contract observability remains within bounded series and contains no prohibited labels.

- **Setup:** instrumentation manifest and synthetic messages with thousands of unique IDs, domains, versions outside support, errors, policies, realms, and extensions.
- **Instrumentation:** exporter series inventory, label names/values, memory/CPU, scrape/ingest size.
- **Steps:** static compute Cartesian upper bound; run high-uniqueness corpus; trigger each state/error; compare actual series to manifest; inspect exemplars/traces/log linkage.
- **Pass:** no prohibited label; endpoint ≤500 and server module ≤5,000 bootstrap series or approved replacement bound; arbitrary values do not create labels; resource use is bounded.
- **Fail/stop:** identifier/domain/error text appears as label or series exceeds ceiling. Block instrumentation release.
- **Evidence:** instrument manifest, series dump scrubbed of prohibited data, upper-bound calculation, resource summary.
- **Duration (ESTIMATE):** 1–2 days setup; run 20–60 minutes.
- **Cleanup:** delete test time series/traces/logs; verify retention; retain aggregate report.

### P18 — Named integration projection and consumer contract

**Claim to falsify:** an external integration is isolated from internal DTO/storage changes and receives only approved fields.

- **Setup:** one fictional consumer stub, consumer-specific schema, projection adapter, old/new consumer versions, synthetic realm data, network failure simulator.
- **Instrumentation:** projection field set/hash, consumer version, auth/realm, retry/idempotency, internal-public dependency scan.
- **Steps:** change internal persistence/view model without changing projection; old/new matrix; add an unapproved internal field; cross-realm callback; timeout/duplicate ack; consumer unavailable; deletion/tombstone before export.
- **Pass:** external bytes change only with consumer contract version; unapproved field never exits; retries are idempotent; realm/deletion enforced; no internal package/table exposure.
- **Fail/stop:** accidental wire drift or privacy/realm leak. Stop that integration only.
- **Evidence:** consumer schema/binary hashes, projection diff, matrix, captured synthetic bytes.
- **Duration (ESTIMATE):** 2–4 days per consumer after shared harness; run under 30 minutes.
- **Cleanup:** remove stub credentials/data/captures; retain synthetic vectors/results.

### P19 — Accessible contract-status and error surface

**Claim to falsify:** an operator can perceive and operate compatibility/quarantine/deletion status without visual-only cues or inaccessible controls.

- **Setup:** synthetic portal pages for unsupported version, rollout state, quarantine summary, and restore blocked state; automated accessibility scanner plus manual keyboard/screen-reader checklist.
- **Instrumentation:** rule results, focus order, accessible names/roles/live-region announcements, zoom/text-spacing screenshots using synthetic data.
- **Steps:** keyboard-only navigation; trigger asynchronous state update; sort/filter table; open details; copy correlation reference; test 200%/400% zoom as applicable; verify color-independent status and localized text fallback.
- **Pass:** approved WCAG 2.2 AA test set passes; all critical flows complete with keyboard and announced status; no payload is exposed through accessible descriptions.
- **Fail/stop:** inaccessible critical action/status or hidden private content. Block the UI release, not the stable machine API.
- **Evidence:** automated and manual report, synthetic screenshots, browser/assistive-technology versions.
- **Duration (ESTIMATE):** 1–2 days per initial surface; regression under 20 minutes plus manual checks.
- **Cleanup:** delete screenshots/session data not retained as approved synthetic evidence.

## 8.4 Test-data rules

- Every fixture is generated from a seed and contains fictional `.invalid` domains, fictional realms/applications, and non-person identities.
- Negative privacy tests use conspicuous synthetic canaries, not copied real values.
- Performance corpora model distributions parametrically; they do not claim production representativeness until approved metadata-only measurements replace the parameters.
- Fuzz/minimized reproducers are reviewed before retention to ensure they contain no accidental environment data.
- Test credentials and signing keys are isolated, non-production, rotated/destroyed after runs, and never included in evidence.


---

# 9. Architecture fitness functions and measurable acceptance criteria

These are executable release gates. “Zero” means zero in the tested corpus/build/deployment scope; it is not a claim of universal absence.

| FF | Fitness function | Measurement | Acceptance criterion | Frequency / gate | Evidence and accountable function |
|---:|---|---|---|---|---|
| FF01 | Every integration boundary has a complete catalogue record | Catalogue lint over source and deployed manifests | Zero candidate/active contracts missing exact version, owner, producers/consumers, trust/privacy state, caps, compatibility rule, rejection, runbook, vectors | Every commit and release | Lint JSON; contract authority |
| FF02 | Immutable schema identity | Rebuild and compare `$id` → SHA-256 map with history | Existing `$id` never maps to different bytes; no duplicate name/version or digest mismatch | Every contract build | Signed bundle manifest; contract/release authority |
| FF03 | Offline reference closure | Resolve every `$ref` in a network-denied job | 100% local manifest-pinned resolution; zero HTTP/file/UNC/unknown schemes; bounded graph | Every build | Ref graph/network-deny log; toolchain owner |
| FF04 | JSON Schema conformance | Run selected validator against pinned official 2020-12 suite subset and UAM cases | All required official/UAM cases match expected outcome; no unexplained skip | Dependency update and release | Test results with suite/validator commits; parser owner |
| FF05 | Duplicate/unknown rejection | Raw-byte corpus against all boundary parsers | 100% duplicate, case variant, and unknown-member cases reject before domain mapping/custody | Every build | Per-vector stage/code; boundary owners |
| FF06 | Presence/nullability truth | Cross generator/runtime truth table | Every required/optional × nullable/non-nullable case matches schema; no default injection | Generator/schema change | Matrix and generated public API; toolchain/consumer owners |
| FF07 | Canonicalization stability | Section 5.14 and RFC/reference vectors across implementations | Exact bytes, length, SHA-256, and signature outcomes match | Every build using JCS; dependency update | Golden output; signing/toolchain owners |
| FF08 | Strict numeric/time/ID profile | Boundary vectors | All in-range/canonical values pass; every out-of-range/non-canonical value rejects with declared code | Every build | Vector report; contract owner |
| FF09 | Closed privacy output | Static mapping allowlist plus runtime canary scan | Output field set is subset of signed ceiling; zero forbidden canary occurrences beyond transformer | G4, every privacy mapping/release | Mapping proof and scan; privacy/endpoint owners |
| FF10 | Session IPC isolation | Windows lab matrix | Only intended session peer completes handshake; zero unauthorized frame acceptance; all caps/timeouts enforced | G1, Windows/runtime/security change | Sanitized matrix; IPC/security owner |
| FF11 | Cursor/event atomicity | Fault injection at every transaction hook | Zero states where cursor exceeds durable represented events; SQLite integrity passes | G5, schema/storage/runtime change | Fault matrix; endpoint persistence owner |
| FF12 | Stable batch identity | Rebuild/retry tests | Same persisted batch produces same logical canonical hash and membership; no upgrade mutates existing batch | Every endpoint outbox change | Hash/membership report; outbox owner |
| FF13 | Receipt durability | Server fault/reconciliation test | Every returned receipt maps to committed inbox/receipt rows; zero committed new batches without recoverable duplicate receipt path | Ingestion persistence/engine/config change | Fault matrix and reconciliation; ingestion owner |
| FF14 | One final business effect | Concurrent retry/replay/restore test | Exactly one materialized effect per stable event identity; expected duplicate custody only | Every ingestion/domain change | Counts/unique constraints/state graph; domain owner |
| FF15 | Batch ID/content conflict safety | Same ID, different canonical content | 100% return conflict/no overwrite/no receipt for conflicting bytes; security signal emitted | Every ingestion release | Test and row hashes; ingestion/security owner |
| FF16 | Realm isolation | Two-fictional-realm authorization matrix | Zero cross-realm read/write/replay/quarantine/audit/integration/deletion successes; no unauthorized existence disclosure beyond approved response | Every boundary/control release | Matrix; identity and boundary owners |
| FF17 | Policy only narrows | Property-based set intersection and signature/revision tests | Effective set ⊆ ceiling for all generated cases; all invalid/widening/downgrade cases deny | Every policy evaluator/artifact change | Set proof/results; policy/privacy owners |
| FF18 | Consumer-first rollout | Deployment manifest/capability query before flag activation | Producer activation impossible until every required consumer reports tested support and bundle digest; rollback producer retained | Every rollout | Signed readiness record/flag audit; release + consumer owners |
| FF19 | Compatibility matrix completeness | Historical binaries/schemas versus declared matrix | Every supported producer/consumer pair executed; actual equals declared; no missing replay/restore reader | Every contract minor/major and retirement | Matrix JSON; compatibility owner |
| FF20 | Version bump correctness | Automated diff plus semantic change declaration/reviewer | No accepted breaking change with non-major bump; no wire/semantic change in patch | Every contract change | Diff/checklist/approval; contract authority |
| FF21 | Unsupported version containment | Route/IPC tests | Unsupported/blocked versions receive declared rejection, no custody/application frame, no permissive fallback | Every release | Response/handshake report; boundary owners |
| FF22 | Resource caps | Boundary ±1 and adversarial corpus | Hard byte/item/depth/ratio/time/allocation caps enforced; no crash or receipt on rejection | Every parser/compression change | Resource report; boundary/security owners |
| FF23 | JSON/gzip fitness | Seeded benchmark | Meets human-approved budgets; until set, captures raw/compressed bytes, CPU, allocations, p50/p95/p99 with reproducibility and cannot authorize binary by assertion | Gated measurement and platform/runtime change | Benchmark dataset; endpoint/ingress/performance owners |
| FF24 | Code generation reproducibility | Clean cross-run/cross-OS build | Approved generated tree/public API is deterministic or platform is pinned with documented reason; compile/analyzers pass | Every generator update | Hash/diff/lock; toolchain owner |
| FF25 | Dependency provenance/license | Lockfile, SBOM, source/release/license/security review | Zero unpinned packages; all direct/transitive licenses allowed or explicitly approved; no unresolved applicable critical security finding under policy | Every dependency change/release | SBOM/license/advisory record; supply-chain/legal/security owners |
| FF26 | Error privacy | Canary scan of errors/logs/traces/metrics/support/UI | Zero forbidden canaries/payload fragments/tokens/internal paths; all errors use stable bounded codes | Every boundary and diagnostics release | Scan report; boundary/privacy owners |
| FF27 | Metric cardinality | Static label set × values and stress run | No prohibited label; ≤ bootstrap 500 endpoint series/process and 5,000 server series/module instance or approved replacement | Every instrumentation change | Manifest/series/resource report; observability owner |
| FF28 | Quarantine isolation | RBAC/realm/UI/API/export tests | Unauthorized access zero; normal status contains codes/counts only; every privileged transition audited | Every quarantine/control release | Access matrix/audit report; quarantine owner |
| FF29 | Audit-coupled mutation | Fault injection/reconciliation | Zero successful privileged mutations without durable audit record; retries idempotent | Every control/audit/storage change | Fault matrix; control/audit owner |
| FF30 | Deletion survives replay/restore | Pre/post-delete replay and backup restore | Zero tombstoned data visible/exported; readiness blocked until authoritative deletion revision applied | Deletion/restore gate and storage change | Timeline/manifests/query assertions; deletion/restore owner |
| FF31 | Kill-switch fitness | Staged/offline/reconnect/expiry test | Exact scope blocked, unaffected contracts continue, switch verifies, converges under approved assumptions, expires/reviews as specified, and is audited | Every release and incident drill cadence set by humans | Drill report; incident/release authority |
| FF32 | No shared DTO boundary leak | Dependency/public API/attribute scan | Zero forbidden assembly refs, ORM/UI annotations in wire types, persistence types in API, internal types in external clients | Every build | Architecture-test report; architecture owner |
| FF33 | Data-quality invariants | Synthetic domain property/reconciliation tests | Provenance present; counts/state sums consistent; invalid semantic cases quarantine; no silent coercion | Every schema/domain change | Property-test report; data-quality owner |
| FF34 | Accessibility of human surfaces | Automated + manual approved WCAG 2.2 AA set | Zero critical/serious gate failures; all critical flows keyboard operable and status announced; no color-only/private accessible text | Every UI release | Accessibility report; portal/accessibility owner |
| FF35 | Historical reproducibility | Checkout/tag and rebuild old bundle/reader in isolated environment | Every supported/frozen version needed for replay can be rebuilt or a verified binary/artifact is retained under supply-chain policy | Release and retirement gate | Artifact provenance/rebuild report; release/compatibility owner |
| FF36 | Evidence hygiene | Scan evidence bundle | Zero credentials, addresses, raw production activity, personal data, internal URLs, or non-approved dump content; manifest/cleanup present | Every experiment upload/review | Evidence lint; experiment owner + privacy review |

## 9.1 Gate aggregation

A release gate must calculate, not manually summarize:

```text
contract_ready =
  catalogue_complete
  AND schema_bundle_valid
  AND parser_profile_passed
  AND privacy_and_realm_invariants_passed
  AND required_version_matrix_passed
  AND transaction_invariants_passed_for_affected_boundaries
  AND limits_and_observability_passed
  AND owners_and_runbooks_assigned
  AND dependency_and_evidence_hygiene_passed
  AND all prerequisite project proof gates passed
```

A waived fitness function is a failed gate unless a time-bounded, owner-approved exception records affected invariant, containment, expiry, and ADR. Privacy ceiling, realm isolation, durable receipt, cursor/event atomicity, privileged audit, deletion/restore, and unauthorized release invariants are not silently waivable by an implementation team.


---

# 10. Human decisions and owner questions

Research supplies technical options and a conservative temporary default where safe. It does not approve business semantics, legal/privacy policy, compatibility promises, budget, or production risk.

## 10.1 Decision matrix

| Human decision | Options and consequences | Conservative temporary default | Accountable function that must decide | Questions that must be answered |
|---|---|---|---|---|
| Business semantic meaning of every field | **A:** minimal site-level event; lower privacy/complexity but may not satisfy purpose. **B:** richer fields; higher utility and higher privacy, storage, access, deletion, and compatibility burden. **C:** defer field/source. | Only structural synthetic schema; no production field is approved by this result | Business-purpose authority with privacy/legal governance and data owner | What exact purpose does each field serve? Is it necessary? What are prohibited interpretations/uses? What precision and provenance are required? |
| Identity level and subject relation | Device/install/session/pseudonymous subject/directory person have different privacy, correction, deletion, and realm risks | Server-derived installation context; do not add person identity to first wire schema | Business/privacy/identity authority | Who or what is the subject? Can identity change? How are shared devices/VDI handled? Which systems are authoritative? |
| Time precision and semantics | Coarse time minimizes privacy; fine time may improve ordering but creates surveillance/detail risk and false precision | UTC instant with explicit source precision; exact allowed precision remains unset | Business/privacy/data authority | Is time observed, collected, transformed, received, or materialized? What precision is necessary? How is clock uncertainty represented? |
| Compatibility duration and rollout policy | **N only:** lowest complexity, weak offline rollback. **N/N-1:** one generation rollback. **Broader:** supports long offline/external consumers but multiplies readers/tests/security support. | Current and previous major for ingress/IPC; consumer first; no automatic calendar retirement | Product/release/support authority with every boundary owner | Longest supported offline period? Maximum rollout duration? Restore/replay horizon? Who funds old-reader security support? What observation proves zero use? |
| External consumer commitments | **No commitment:** internal only. **Per-consumer:** explicit version, notice, support and tests. **General public contract:** largest governance/support burden. | No external commitment; every integration is named and separately gated | External-contract/commercial/service authority plus integration owner | Who are consumers? Are they independently deployed? What notice/support/availability/data-use/deletion promises exist? Who can end them? |
| Exact size/resource limits | Lower caps contain risk but may reject legitimate events; higher caps increase endpoint/server/proxy cost and DoS surface | Section 5 bootstrap caps for prototypes only | Endpoint/ingestion operations and risk authority | Approved CPU/memory/disk/network/latency budgets? Minimum endpoint class? Proxy limits? Expected outage/backlog distributions? |
| Policy validity while offline | **Stop at expiry:** strongest authorization, lower availability. **Grace:** availability, but stale policy risk. **No expiry:** simplest offline, weak revocation. | Fail closed when no valid authorized policy, unless a separately approved last-safe grace rule exists | Privacy/policy/risk authority | How long can endpoints be offline? How quickly must a revoked source stop? What clock trust exists? Which capabilities can safely continue? |
| Signing algorithms and key service | Enterprise signing/HSM, code-signing service, or dedicated service have different lifecycle and separation; unsigned is not acceptable for high-authority artifacts | Test-only profile; production algorithm/key system undecided | Security/key-management/release authority | Who may sign which artifact? Rotation/revocation/recovery? Offline verification? Two-person controls? Audit and key-purpose separation? |
| Application-layer batch signatures | Add origin proof beyond TLS but add device keys, canonicalization and support burden | Do not sign telemetry batches initially; use TLS/auth, content digest, canonical hash, receipt binding | Security/device-identity/risk authority | What threat remains after authenticated TLS? Is non-repudiation required? Can device keys be secured, rotated and revoked at scale? |
| Receipt and local cleanup grace | Short grace saves disk; long grace helps reconciliation/replay but increases endpoint storage/privacy exposure | Receipt makes events cleanup-eligible; exact grace/retention remains unset | Operations/privacy/retention authority | How are receipt disputes handled? Required ACK replay horizon? Disk budget? What survives restore or server loss? |
| Quarantine body retention/access | Keep body enables repair but increases sensitive storage; metadata-only reduces exposure but may prevent diagnosis | Normal surfaces metadata only; protected body retention undecided and deny by default | Security/privacy/retention/support authority | Is body retention necessary? Where encrypted? Who can access? For how long? Can synthetic reproduction replace it? |
| Error/detail and support diagnostics | More detail speeds support but risks payload/identity leakage | Stable codes and bounded safe metadata only; no payload capture | Support/privacy/security authority | Which fields may appear in protected logs? Retention? Diagnostic elevation approval, scope, expiry, and deletion? |
| Metric-series ceilings | Tight cap controls cost; loose cap may ease instrumentation but causes cardinality risk | 500 endpoint process / 5,000 server module bootstrap gate pending measurement | Observability/operations/budget authority | Backend cost/limit? Scrape topology? Required dimensions? Which protected inventory handles high-cardinality diagnosis? |
| OpenAPI dialect migration to 3.2 | 3.2 is current and may add useful capabilities; 3.1.2 has the planned compatibility/tool matrix | Use 3.1.2 until tool matrix passes; revisit via ADR | Contract/toolchain authority | Which 3.2 feature is needed? Do validator/diff/generator/doc/security tools fully support it? Migration effects? |
| Schema validator and code generator dependencies | JsonSchema.Net, Corvus, NSwag, others differ in source generation, runtime validation, license/security and behavior | Run at least two candidates; no dependency approval from research alone | Architecture/toolchain, legal, security, support authority | License acceptable? Conformance/performance? Supply-chain support? Can UAM maintain a fallback? |
| Runtime schema registry | Better central discovery/governance at cost of service, auth, availability, and parser/import surface | No runtime registry; signed Git bundles | Architecture/operations/budget/security authority | Is runtime discovery required? What outage behavior? Multi-realm auth? Who operates/upgrades/restores it? |
| Binary encoding | May reduce bytes/CPU; adds compiler/tooling/debugging/version rules | No binary until JSON/gzip fails approved budget | Architecture/performance/operations authority | Which budget failed? Which candidate? Does it preserve strictness, deterministic testability, support and security? |
| Production retention/deletion proof | Different periods and storage copies change tombstone and compatibility/replay horizon | No period invented; design retains explicit states/IDs | Legal/privacy/records/data owner | What is retained at each state/store? Backups? External copies? Proof standard? Litigation/hold exceptions? |
| SLO/RPO/RTO and incident severity | Determines alerts, retry, retention, failover, old-reader horizon, support staffing | No production targets invented | Service/operations/business risk authority | Required availability and data-loss window? Which invariants are absolute? Escalation and communication authority? |
| Accessibility/localization scope | AA target and locales influence portal copy, test matrix and support | WCAG 2.2 AA target for applicable human surfaces; machine codes stable | Product/accessibility authority | Required locales/assistive technologies? Formal conformance? Who performs manual evaluation? |
| Final accountable owners | Central authority may speed consistency; federated owners scale but require governance | All placeholders block candidate status | Executive/product governance function | Name the accountable contract authority, boundary owners, support, privacy/security reviewers, external commitment and deletion/restore authorities |

## 10.2 Mandatory owner questions before the first contract ADR is accepted

1. Who has authority to approve the **meaning** and privacy classification of a field, and where is that approval recorded?
2. Who can declare a change breaking when delivery pressure favors “minor”?
3. Who owns a reader after its producer has moved on, including security patching for replay/restore?
4. Who has authority to activate and revoke a producer, exact contract version, source capability, and signed policy?
5. Which support function receives unsupported-version, batch-ID conflict, quarantine, signature, and deletion/restore alerts?
6. Who owns each external consumer commitment and can approve its end?
7. Who approves evidence that contains protected identifiers or quarantine content, and who verifies cleanup?
8. Who decides that a measured budget failure justifies binary encoding or a runtime registry?
9. Who accepts the residual risk when a version cannot be safely rolled back or an offline endpoint cannot receive an emergency block?
10. Who signs the stop/go record for the primary integration gate?

Until these functions are named, contracts remain `draft` or `experimental`.

---

# 11. CLI experiments/measurements and the exact evidence they must produce

## 11.1 Proposed repository CLI

**RECOMMENDATION.** Implement one repository-owned .NET tool, `Uam.Contracts.Cli`, so the gate does not depend on ad hoc shell logic. External validators/diff/generators run behind pinned adapters. Commands below are the required interface; implementation tasks appear in Section 13.

All commands accept `--evidence <directory>`, refuse a non-empty evidence directory unless `--resume` is explicit, write a manifest, and return nonzero on gate failure. They never fetch schemas from the network.

### E01 — Capture sanitized environment

```powershell
$RunId = [guid]::NewGuid().ToString('N')
$Evidence = Join-Path 'evidence' "contract-foundation-$RunId"
New-Item -ItemType Directory -Path $Evidence | Out-Null

dotnet --info | Out-File (Join-Path $Evidence 'dotnet-info.txt') -Encoding utf8

dotnet run --project tools/Uam.Contracts.Cli -- `
  evidence init `
  --research-date 2026-07-31 `
  --synthetic-only `
  --out $Evidence
```

**Must produce:** OS edition/build class, architecture, .NET SDK/runtime, repository commit, dirty-state flag, UTC time, tool manifest, and a scan proving no username, machine name, address, credential, internal URL, or environment secret was captured. Exact runtime patch is evidence, not architecture.

### E02 — Restore/build deterministically

```powershell
dotnet restore Uam.sln --locked-mode

dotnet build Uam.sln `
  --configuration Release `
  --no-restore `
  /p:ContinuousIntegrationBuild=true `
  /p:Deterministic=true `
  /warnaserror
```

**Must produce:** lockfile hashes, build command, SDK/compiler versions, binary/source-link or equivalent provenance where configured, warnings/errors, and output hashes. Failure on unlocked or floating dependencies.

### E03 — Catalogue and schema lint

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  catalogue lint `
  --root contracts `
  --require-owner `
  --require-limits `
  --require-rejection `
  --require-compatibility `
  --evidence $Evidence

dotnet run --project tools/Uam.Contracts.Cli -- `
  schema validate `
  --root contracts `
  --dialect 2020-12 `
  --offline `
  --reject-remote-ref `
  --evidence $Evidence
```

**Must produce:** contract count by lifecycle/family, missing-field list, `$id` uniqueness, schema/meta-schema results, unbounded keyword findings, extension-policy findings, full `$ref` graph, URI schemes, and selected validator/version/commit. Any candidate/active owner placeholder or remote reference fails.

### E04 — Build and reproduce signed bundle input

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  bundle build `
  --root contracts `
  --out artifacts/contracts-bundle `
  --manifest artifacts/contracts-bundle/manifest.json `
  --evidence $Evidence

dotnet run --project tools/Uam.Contracts.Cli -- `
  bundle reproduce `
  --root contracts `
  --runs 2 `
  --evidence $Evidence
```

**Must produce:** sorted manifest of path, size, SHA-256, contract name/version/ID; total bundle hash; two clean-build comparisons; no signature with production keys. A later signing lane signs the manifest/JCS bytes and records only public key ID/fingerprint and verification results.

### E05 — Golden and invalid vectors

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  vectors run `
  --root contracts/vectors `
  --parsers production,validator,generated `
  --require-stage-and-code `
  --evidence $Evidence
```

**Must produce:** for every fixture, input SHA-256/size, expected and actual accept/reject, stage, safe code, canonical output/hash where relevant, parser/validator/generator versions, allocation/time bounds, and a log scrub result. It must reproduce Section 5.14 exactly.

### E06 — Official JSON Schema conformance subset

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  schema conformance `
  --suite third_party/JSON-Schema-Test-Suite `
  --suite-commit c7257e92580678a086f0b9243a1903ed88bd27f7 `
  --draft 2020-12 `
  --profile contracts/conformance-profile.json `
  --evidence $Evidence
```

**Must produce:** included/excluded cases with rationale, exact suite commit, validator version, pass/fail counts, and every disagreement. Unexplained skips fail.

### E07 — OpenAPI validation and compatibility diff

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  openapi validate `
  --root contracts/openapi `
  --oas 3.1.2 `
  --evidence $Evidence

dotnet run --project tools/Uam.Contracts.Cli -- `
  compatibility diff `
  --base refs/tags/contracts-baseline `
  --revision HEAD `
  --tool oasdiff `
  --tool-version 1.27.0 `
  --policy contracts/compatibility-policy.json `
  --evidence $Evidence
```

**Must produce:** OAS version, local schema linkage, route/media/status/header findings, tool release/commit/license, machine diff, declared semantic change/bump, reviewer decision, and known tool limitations. A clean automated diff does not waive semantic review.

### E08 — Generated-code truth table and reproducibility

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  codegen verify `
  --config contracts/codegen `
  --truth-table tests/fixtures/nullability-presence `
  --clean-runs 2 `
  --compile `
  --architecture-rules `
  --evidence $Evidence
```

**Must produce:** generator/version/package or image digest, config hash, generated-tree hashes, normalized cross-run/cross-OS diff, compiled public API, nullable/presence outcomes, dependency scan, and license/SBOM. Any silent drift fails.

### E09 — Old/new producer-consumer matrix

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  matrix run `
  --definition contracts/compatibility/uam.ingestion.upload-batch/matrix.yaml `
  --artifacts artifacts/compatibility `
  --include-rollback `
  --include-replay `
  --evidence $Evidence
```

**Must produce:** every binary/schema hash, producer/consumer pair, expected/actual outcome, error code, mapped semantic result hash, route/capability evidence, resources, and rollback/replay outcome. Missing combinations or mismatches fail.

### E10 — Raw parser/fuzz/resource tests

```powershell
dotnet test tests/Uam.Contracts.Parser.Tests `
  --configuration Release `
  --no-build `
  --logger "trx;LogFileName=parser.trx"

dotnet run --project tools/Uam.Contracts.Cli -- `
  parser adversarial `
  --corpus tests/corpus/json `
  --depth 16 `
  --max-expanded-bytes 4194304 `
  --max-ratio 20 `
  --concurrency-profile tests/profiles/parser-load.json `
  --evidence $Evidence
```

**Must produce:** fixture hashes, exact cap ±1 results, duration/allocation/working-set per class, crash/hang count, safe errors, post-run health, and log/canary scan. Fuzz seeds and minimized reproducers must pass evidence hygiene.

### E11 — Windows IPC isolation lane

```powershell
dotnet test tests/Uam.Ipc.WindowsLab.Tests `
  --configuration Release `
  --filter "Category=Isolation|Category=Framing|Category=Restart" `
  --logger "trx;LogFileName=ipc-lab.trx"

dotnet run --project tools/Uam.Contracts.Cli -- `
  evidence import-test `
  --trx tests/TestResults/ipc-lab.trx `
  --sanitize-profile evidence/sanitize/windows-lab.json `
  --evidence $Evidence
```

**Must produce:** sanitized OS/runtime/binary versions, DACL/session assertion classes, intended/unauthorized outcomes, handshake/version/frame cap results, restart behavior, and scrub report. It must not record connection details, account names, SIDs in full, addresses, credentials, or raw source data.

### E12 — Privacy canary lane

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  canary generate `
  --profile tests/privacy/canaries.json `
  --seed 20260731 `
  --out artifacts/synthetic-canaries `
  --evidence $Evidence

dotnet test tests/Uam.Privacy.Boundary.Tests `
  --configuration Release `
  --filter Category=CanaryContainment

dotnet run --project tools/Uam.Contracts.Cli -- `
  canary scan `
  --manifest artifacts/synthetic-canaries/manifest.json `
  --targets artifacts/lab-captures `
  --forbid-beyond privacy-transformer `
  --evidence $Evidence
```

**Must produce:** canary hashes/classes, tested success/error/cancel/crash paths, destination-class zero/nonzero counts, mapping/ceiling revision hashes, and cleanup verification. Any forbidden nonzero result stops G4/G5.

### E13 — Endpoint transaction fault matrix

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  endpoint fault-matrix `
  --scenario tests/scenarios/event-cursor-atomicity.json `
  --database artifacts/test/endpoint.db `
  --restart-each-fault `
  --evidence $Evidence
```

**Must produce:** SQLite/runtime/build versions, each injected hook, pre/post event and cursor hashes/counts, integrity result, restart behavior, stable-ID/dedupe result, and cleanup. Any cursor-ahead state fails G5.

### E14 — Server custody/idempotency fault matrix

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  ingestion fault-matrix `
  --scenario tests/scenarios/custody-receipt.json `
  --include-response-loss `
  --include-parallel-retry `
  --include-id-content-conflict `
  --evidence $Evidence
```

**Must produce:** engine/config/version, fault point, transaction outcome, HTTP outcome, inbox/receipt/fact uniqueness, duplicate response equivalence, conflict outcome, realm-source assertion, and reconciliation. No credentials/connection strings appear.

### E15 — Realm authorization matrix

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  realm matrix `
  --scenario tests/scenarios/two-fictional-realms.json `
  --boundaries ingress,control,quarantine,integration,deletion,restore `
  --evidence $Evidence
```

**Must produce:** fictional realm/identity references, attempted action, authenticated-context realm, stored/query realm, result, disclosure assertion, and audit outcome. Any cross-realm success fails the release.

### E16 — JSON/gzip benchmark

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  corpus generate `
  --profile benchmarks/contracts/synthetic-corpus.json `
  --seed 20260731 `
  --out artifacts/benchmark-corpus `
  --evidence $Evidence

dotnet run --project benchmarks/Uam.Contracts.Benchmarks -- `
  --corpus artifacts/benchmark-corpus `
  --batch-sizes 1,10,100,1000 `
  --encodings json,json-gzip `
  --iterations 30 `
  --out (Join-Path $Evidence 'json-gzip')
```

**Must produce:** seed/generator/schema hashes, raw and compressed bytes/ratio, CPU/wall time, allocations, peak memory, throughput, p50/p95/p99, endpoint/server separation, environment and profiles. It must state the approved budget inputs or `UNKNOWN`; without budgets it cannot conclude pass or justify binary.

### E17 — Metric-cardinality calculation and load

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  observability lint `
  --manifest observability/instruments.json `
  --forbidden-labels realm_id,tenant_id,user_id,device_id,installation_id,session_id,event_id,batch_id,domain,exception_message `
  --endpoint-series-ceiling 500 `
  --server-series-ceiling 5000 `
  --evidence $Evidence

dotnet run --project tools/Uam.Contracts.Cli -- `
  observability stress `
  --scenario tests/scenarios/high-cardinality-synthetic.json `
  --evidence $Evidence
```

**Must produce:** instrument/label/value manifest, Cartesian bound, actual series/resource count, prohibited-label scan, and cleanup. Replacing bootstrap ceilings requires an approved decision and measured evidence.

### E18 — Deletion/restore/replay lane

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  lifecycle deletion-restore `
  --scenario tests/scenarios/deletion-restore-replay.json `
  --require-tombstone-before-visible `
  --evidence $Evidence
```

**Must produce:** synthetic state timeline, custody/visibility/deletion revisions, backup/restore manifests, replay outcomes, query/export assertions, audit completeness, and cleanup. Any resurrection or readiness without deletion state fails.

### E19 — Dependency, repository, license, and security review

```powershell
dotnet list Uam.sln package --include-transitive | `
  Out-File (Join-Path $Evidence 'packages-transitive.txt') -Encoding utf8

dotnet run --project tools/Uam.Contracts.Cli -- `
  supply-chain review `
  --lockfiles . `
  --repositories contracts/third-party-repositories.json `
  --require-commit `
  --require-license `
  --require-security-posture `
  --evidence $Evidence
```

**Must produce:** direct/transitive packages, versions, hashes/provenance where available, licenses, repository URL and exact tag/commit, last reviewed release/activity date, security/testing notes, applicable advisories, legal-review status, and suitability decision. Popularity is not a field or decision input.

### E20 — Evidence hygiene and final gate

```powershell
dotnet run --project tools/Uam.Contracts.Cli -- `
  evidence lint `
  --root $Evidence `
  --forbid-secrets `
  --forbid-addresses `
  --forbid-internal-urls `
  --forbid-personal-data `
  --forbid-raw-activity `
  --require-cleanup `
  --evidence $Evidence

dotnet run --project tools/Uam.Contracts.Cli -- `
  gate evaluate `
  --gate primary-contract-integration `
  --inputs $Evidence `
  --out (Join-Path $Evidence 'gate-result.json')
```

**Must produce:** scan rules/version, findings with safe location only, cleanup status, every required fitness function/evidence pointer, owner approvals, prerequisite gate state, final `STOP` or `GO`, and reason. The tool cannot convert an unresolved human decision into `GO`.

## 11.2 Minimum command exit semantics

- `0` — all machine criteria passed; human approvals may still be pending and are reported separately.
- `2` — contract/test failure; release/integration stops.
- `3` — evidence incomplete or unknown input; gate remains stop.
- `4` — prohibited evidence or secret/privacy finding; isolate evidence and invoke cleanup/incident process.
- `5` — tool/dependency/environment unsupported; do not infer pass.

Output must be deterministic JSON plus readable Markdown. A nonzero result must not dump the offending payload.


---

# 12. ADR proposals: decision, status, alternatives, rationale, evidence, owner, and review trigger

All ADRs below are **Proposed**. None becomes accepted merely because it appears in this research result. `UNASSIGNED` is an intentional stop condition: the project must name an accountable function or person before the ADR can move to `Accepted`. Evidence references point to sections of this result and the source register in Section 15.

## 12.1 ADR-CV-001 — Govern every integration boundary as a separately owned contract

- **Decision:** Every process, persistence, HTTP, administrative, deletion, and external-integration boundary listed in the contract catalogue **MUST** have a unique contract name, immutable version, accountable owner, trust/privacy classification, size limits, compatibility rule, rejection behavior, test vectors, and support runbook before integration. A library call inside one component need not be a public contract unless it crosses a security, privacy, process, persistence, release, or organizational boundary.
- **Status:** Proposed; foundational and blocking.
- **Alternatives:** Allow teams to integrate first and document later; treat all internal calls as one shared model; apply formal contracts only to public HTTP APIs.
- **Rationale:** UAM’s privacy boundary, endpoint transaction invariant, durable-custody meaning, realm derivation, at-least-once replay, staged migration, and deletion/restore ordering are boundary semantics. They cannot be reliably inferred from C# types or database tables.
- **Evidence:** Accepted baseline and proof gates; Sections 3, 5.3, 5.15, 6, 7, 9; primary gate in this result.
- **Owner:** **UNASSIGNED — human must name the contract-governance authority.** Each catalogue row also requires a boundary owner and support owner.
- **Review trigger:** A new boundary, deployment unit, persistence store, external consumer, trust transition, or privacy state; an incident caused by an undocumented assumption; evidence that the catalogue gate materially blocks safe delivery without reducing risk.

## 12.2 ADR-CV-002 — Adopt the strict `UAM-JSON-1` serialization profile

- **Decision:** Initial JSON contracts **MUST** use the `UAM-JSON-1` profile in Section 5.2: UTF-8 without BOM; one JSON value; duplicate-name rejection; case-sensitive member names; schema-known fields only unless an explicit bounded extension point exists; explicit absence/null rules; exact-integer and decimal-string rules; restricted UTC timestamp profile; canonical identifier strings; bounded depth/count/string/number sizes; no comments, trailing commas, non-finite numbers, remote schema loading, or polymorphic type names.
- **Status:** Proposed; blocking for JSON contract publication.
- **Alternatives:** Default `System.Text.Json` behavior; tolerant readers that ignore unknown/duplicate fields; JSON5/YAML on the wire; “Postel’s law” acceptance with best-effort interpretation.
- **Rationale:** Ambiguous or permissive parsing creates parser differentials, downgrade opportunities, hidden schema drift, unreviewed privacy fields, and non-deterministic hashing. Strictness makes malformed or unsupported input fail at a known boundary with a stable code.
- **Evidence:** RFC 8259, RFC 7493, Microsoft strict-parsing controls; Sections 5.2, 5.5, 7, 8 P01–P04, 9 FF-JSON-*.
- **Owner:** **UNASSIGNED — contract-governance authority with security/privacy review.**
- **Review trigger:** A demonstrated interoperability problem with a named consumer; a parser/library change; a security advisory; a measured need for an extension mechanism; adoption of a non-JSON representation.

## 12.3 ADR-CV-003 — Use JSON Schema Draft 2020-12 and OpenAPI 3.1.2, with a UAM normative companion specification

- **Decision:** Data/message schemas **MUST** target JSON Schema Draft 2020-12. HTTP APIs **MUST** be described by OpenAPI 3.1.2 during the initial implementation. The UAM Contract Standard remains normative for semantics not expressible or consistently enforced by those formats: authenticated context, privacy state, receipt meaning, transaction boundaries, compatibility, rollout, limits, signatures, error mapping, lifecycle, and ownership. OpenAPI 3.2 adoption is a separately tested migration, not an automatic tool upgrade.
- **Status:** Proposed.
- **Alternatives:** OpenAPI-only; code-first attributes as the source of truth; protobuf/Avro IDL first; OpenAPI 3.2 immediately; custom schema language.
- **Rationale:** JSON Schema 2020-12 is the mature schema vocabulary aligned with OpenAPI 3.1. OpenAPI 3.1.2 is recent and better established in the reviewed .NET tooling than 3.2. Schema syntax alone cannot encode UAM’s custody, privacy, identity, and rollout invariants.
- **Evidence:** OpenAPI 3.1.2/3.2.0 and JSON Schema 2020-12 primary specifications; Sections 5.1, 5.4, 8 P05, 9 FF-SCHEMA-*; repository assessments.
- **Owner:** **UNASSIGNED — API/contract authority.**
- **Review trigger:** Generator/validator failure against required 2020-12 features; full OpenAPI 3.2 tool-chain conformance; a standard erratum/security issue; a binary-encoding ADR.

## 12.4 ADR-CV-004 — Keep an immutable Git-backed catalogue and ship pinned local schema bundles

- **Decision:** Contract source, schemas, examples, compatibility manifests, and generated-bundle manifests **MUST** be version-controlled and immutable after publication. Build and runtime validation **MUST** resolve only a pinned local bundle with recorded hashes; production components **MUST NOT** fetch `$ref` targets or schemas from the network. No runtime schema-registry service is introduced initially. Stable HTTPS schema identifiers are names, not runtime download dependencies.
- **Status:** Proposed.
- **Alternatives:** Runtime registry; mutable “latest” schema endpoint; schemas embedded only in code; package feed without source catalogue.
- **Rationale:** Local immutable bundles meet the current deployment need with fewer availability, authorization, SSRF, parser, import, backup, and operational failure modes. A runtime registry is justified only by measured independent-deployment or governance needs.
- **Evidence:** Sections 3.4, 4, 5.4, 7, 8 P03/P05, 9 FF-BUNDLE-*; Apicurio Registry review and its recent parser/import/security fixes.
- **Owner:** **UNASSIGNED — contract authority; build/release function owns bundle reproducibility.**
- **Review trigger:** Multiple independently released producers/consumers cannot receive bundles safely; emergency schema distribution misses an approved objective; registry capability is required by an approved external commitment; measured operational comparison favors a service.

## 12.5 ADR-CV-005 — Version contracts semantically and roll consumers before producers

- **Decision:** Contract versions **MUST** be immutable `MAJOR.MINOR.PATCH` values under Section 6.1. Breaking changes require a new major. Additive minor changes are permitted only when every affected old consumer’s declared behavior is proven compatible; strict consumers normally require consumer-first rollout. Patches cannot change the accepted instance set or semantics. Temporary bootstrap support is current and immediately previous major for endpoint ingress and endpoint IPC consumers, with retirement based on evidence and human approval rather than time alone.
- **Status:** Proposed; the version syntax and rollout safety rule can be accepted technically, while the duration/window remains a **HUMAN DECISION**.
- **Alternatives:** Date versions; endpoint build number as protocol version; server accepts everything; producer-first “additive” rollout; indefinite support; exact-version-only with no overlap.
- **Rationale:** One explicit rollback generation bounds complexity while allowing recovery. Consumer-first rollout avoids new fields or representations reaching strict old readers. Calendar-only retirement is unsafe for long-offline endpoints and unknown external commitments.
- **Evidence:** Sections 1.2, 6.1–6.4, 8 P08/P18, 9 FF-COMPAT-*; SemVer; oasdiff version-policy behavior.
- **Owner:** **UNASSIGNED — compatibility policy authority; deployment owner supplies fleet evidence.**
- **Review trigger:** Offline/rollout distribution exceeds the window; emergency block cannot reach an old version; external commitments differ; support cost becomes unacceptable; a rollback exercise fails.

## 12.6 ADR-CV-006 — Prohibit shared transport/persistence/view DTOs

- **Decision:** Endpoint source candidates, minimized endpoint events, endpoint SQLite records, upload messages, server inbox records, typed domain facts, portal/BFF views, audit records, and external-integration messages **MUST** have separate models and explicit mapping functions. Generated transport types **MUST** remain in boundary-specific assemblies/namespaces and **MUST NOT** be referenced by domain or persistence projects. Database entities and UI models **MUST NOT** be serialized directly across a boundary.
- **Status:** Proposed.
- **Alternatives:** One shared `Contracts` assembly containing all DTOs; database-first models; AutoMapper/reflection maps without field-level review; portal directly queries storage entities.
- **Rationale:** Shared DTOs turn an internal field addition into unreviewed wire, persistence, privacy, and external behavior. Explicit adapters create review points for minimization, authenticated context, semantic conversion, defaulting, and loss.
- **Evidence:** Sections 3.5, 5.3, 7 T02/T03/T16, 8 P07/P18, 9 FF-BOUNDARY-*.
- **Owner:** **UNASSIGNED — architecture authority; each adapter has a boundary owner.**
- **Review trigger:** Assembly dependency fitness function fails; a field crosses layers accidentally; mapping overhead is claimed to be a material measured bottleneck.

## 12.7 ADR-CV-007 — Negotiate local IPC explicitly and bind it to Windows session identity

- **Decision:** Named-pipe endpoints **MUST** use explicit DACLs, local-only access, message framing, bounded timeouts/sizes, peer process/session/logon checks appropriate to the boundary, and a negotiation handshake that selects an exact supported contract version or fails closed. The Coordinator **MUST NOT** accept a User Host/Task Host merely because the process can open the pipe. No raw candidate payload may cross into Coordinator-visible IPC.
- **Status:** Proposed; final Windows ACL/token details remain subject to proof gate G1.
- **Alternatives:** Inherited/default pipe ACLs; machine-global pipe with payload session claims; no negotiation because MSI versions “should match”; HTTP loopback.
- **Rationale:** User/session boundaries are security/privacy boundaries, and installation rollback or partial upgrades can create version skew even under coordinated MSI deployment. A logon SID can help separate Terminal Services sessions, but UAM-specific correctness requires a Windows lab proof.
- **Evidence:** Microsoft named-pipe security documentation; Sections 3.2, 5.6, 6.5, 7, 8 P06, 9 FF-IPC-*; accepted G1.
- **Owner:** **UNASSIGNED — endpoint security/boundary owner.**
- **Review trigger:** G1 failure; RDS/VDI/FSLogix/Citrix support; Windows platform/API changes; a required cross-session operation; updater topology change.

## 12.8 ADR-CV-008 — Define ingestion acceptance as durable custody, not semantic success

- **Decision:** Ingress **MUST** authenticate first, derive realm/installation from trusted context, enforce transport/media/compression/hard envelope limits, verify digest and basic supported envelope, and atomically commit inbox bytes plus authenticated context, idempotency identity, and receipt before returning a custody receipt. Full event validation/materialization occurs after custody and yields separate processing state. Unsupported envelopes that cannot be safely stored/processed are rejected before receipt. Replays of the same batch identity and content return the same custody outcome; same identity with different content fails as a conflict/security event.
- **Status:** Proposed; dependent on durable-inbox proof.
- **Alternatives:** Validate/materialize synchronously before ACK; ACK on network receipt; receipt implies portal visibility; accept unknown schemas into a general poison store; submit SQL.
- **Rationale:** This preserves the accepted receipt invariant and failure containment while avoiding long synchronous processing. It also makes retry semantics explicit and keeps semantic failure observable without lying about custody.
- **Evidence:** Accepted baseline; Sections 3.3, 5.8–5.10, 6.7–6.9, 7, 8 P09/P10, 9 FF-CUSTODY-*.
- **Owner:** **UNASSIGNED — ingestion/durability owner with database operations owner.**
- **Review trigger:** Fault-injection failure; database-engine selection changes transactional behavior; a requirement for broker custody; RPO/RTO changes; receipt dispute or replay incident.

## 12.9 ADR-CV-009 — Sign release-authorized control artifacts; do not add per-batch application signatures initially

- **Decision:** Privacy ceilings, policy/control manifests, release authorization, capability blocks, and key-transition artifacts **MUST** use a versioned signed envelope with protected algorithm/key/version context and replay/downgrade fields. Canonical JSON for signing uses RFC 8785 JCS where the selected key profile supports the exact JSON value constraints; signatures use a narrowly profiled JWS or an approved equivalent. Upload batches initially rely on authenticated TLS/device identity, `Content-Digest`, immutable custody metadata, and server-side audit rather than a second application signature.
- **Status:** Proposed; key service, algorithms, rotation, offline trust, and emergency revocation are unresolved human/security decisions.
- **Alternatives:** Sign nothing; sign every event/batch; XML signatures; bespoke canonicalization/signature; payload hash without authorization signature.
- **Rationale:** Signed control artifacts prevent an untrusted endpoint component or intermediary from expanding privacy/capability beyond release authorization. Per-batch signatures add key lifecycle and CPU/forensics cost without a proved threat requirement; transport authentication plus durable digest is simpler initially.
- **Evidence:** RFC 8785, RFC 7515, RFC 7797, RFC 9530; Sections 5.2, 5.11, 6.10, 7, 8 P13, 9 FF-SIGN-*.
- **Owner:** **UNASSIGNED — security/key-management authority plus product privacy authority.**
- **Review trigger:** Threat model requires application-layer origin proof beyond TLS; key compromise; algorithm deprecation; canonicalization interoperability failure; custody/non-repudiation requirement.

## 12.10 ADR-CV-010 — Standardize machine errors with privacy-safe Problem Details and bounded observability

- **Decision:** HTTP errors **MUST** use the UAM RFC 9457 profile with stable namespaced machine codes, a correlation identifier, retry classification, contract/version context where safe, and no raw payload, source value, internal address, stack trace, subject identity, or unrestricted exception text. Non-HTTP boundaries use the same error catalogue semantics. Metrics **MUST** use an allowlisted low-cardinality label set and place high-cardinality identifiers only in access-controlled evidence/log records under retention policy. Health and quarantine views expose bounded metadata, not raw activity.
- **Status:** Proposed.
- **Alternatives:** Free-text exceptions; status code alone; raw validation errors; event/domain/device labels in metrics; one generic “failed” code.
- **Rationale:** Stable errors support retry and runbooks while preventing diagnostics from becoming a privacy bypass or telemetry-cardinality denial of service.
- **Evidence:** RFC 9457; Sections 3.8–3.10, 5.13, 6.12, 7, 8 P15/P17, 9 FF-OBS-*.
- **Owner:** **UNASSIGNED — observability/support owner with privacy/security review.**
- **Review trigger:** Incident where code lacks diagnostic power; privacy leak; cardinality budget failure; monitoring platform change; external API error commitment.

## 12.11 ADR-CV-011 — Represent quarantine and deletion as governed lifecycle contracts, not flags

- **Decision:** Quarantine **MUST** record bounded reason/status/provenance and preserve custody identity without making rejected content available to ordinary portal or integration paths. Reprocessing requires a new validator/materializer revision, authorization, and audit. Deletion **MUST** use versioned request, tombstone/application-state, and evidence contracts with monotonic revisions and explicit restore/replay ordering; restore cannot declare readiness until applicable deletion state is restored/applied and visibility checks pass.
- **Status:** Proposed; exact deletion scope, retention, legal proof, and quarantine access are **HUMAN DECISIONS**.
- **Alternatives:** Boolean `is_bad`/`is_deleted`; mutate or discard poison records without custody evidence; manual SQL cleanup; restore first and re-delete later; expose raw quarantine payload to support by default.
- **Rationale:** Distinct lifecycle states make custody, semantic failure, remediation, deletion propagation, and resurrection prevention auditable and testable.
- **Evidence:** Accepted data principles; Sections 5.10, 5.12, 6.9, 6.11, 7, 8 P16, 9 FF-LIFECYCLE-*.
- **Owner:** **UNASSIGNED — data governance/deletion authority and platform recovery owner.**
- **Review trigger:** Approved retention/deletion policy; restore architecture change; a resurrection incident; quarantine backlog/cost breach; regulator or legal requirement.

## 12.12 ADR-CV-012 — Defer binary encoding until JSON/gzip fails a declared budget

- **Decision:** The first implementation **MUST** use JSON over the defined IPC/HTTPS boundaries, with gzip for upload where effective and safe. The project **MUST** execute seeded, reproducible JSON/plain and JSON/gzip measurements before proposing another encoding. A binary proposal must define the failed approved budget, measure candidate encoding end-to-end, retain strict schema/version/rejection semantics and inspectability, and include migration/dual-stack/security/tooling costs.
- **Status:** Proposed.
- **Alternatives:** Protobuf, MessagePack, CBOR, Avro, FlatBuffers, or bespoke binary from the start; never consider binary.
- **Rationale:** No representative payload/CPU/network distribution or approved performance budget currently proves JSON inadequate. Starting binary would add ecosystem and migration complexity without evidence; refusing forever would be equally dogmatic.
- **Evidence:** Sections 1, 4, 5.1, 8 P11/P12, 9 FF-ENCODING-*; CLI E11/E12.
- **Owner:** **UNASSIGNED — performance/capacity authority with contract and operations owners.**
- **Review trigger:** JSON/gzip exceeds an approved endpoint CPU, memory, latency, bandwidth, storage, or cost budget; device class changes; a named integration mandates another format.

## 12.13 ADR-CV-013 — Treat validators, generators, diff tools, and CDC frameworks as replaceable build dependencies

- **Decision:** Every schema validator, OpenAPI generator, compatibility diff, canonicalizer, and consumer-driven contract framework **MUST** be pinned by exact package/tool version and lockfile; invoked behind a repository-owned adapter; tested against UAM golden/adversarial vectors; included in license/security/provenance review; and prevented from network schema resolution. Generated output is reviewed and compiled/tested; it is not authoritative. No single third-party tool decides compatibility.
- **Status:** Proposed; exact runtime validator/generator selection is a CLI bake-off result, not decided here.
- **Alternatives:** Trust one generator/validator; float to latest; hand-write every client; vendor a fork immediately; use hosted broker/CI with production examples.
- **Rationale:** Reviewed projects show active maintenance and value, but also regressions, differing schema coverage, native dependencies, and licensing/security concerns. Replaceable adapters avoid architecture lock-in.
- **Evidence:** Sections 3.7, 5.1, 6.13, 8 P05, 11 E19, 14; NSwag nullability regression/fix; registry parser hardening; schema-library license concerns.
- **Owner:** **UNASSIGNED — build/supply-chain owner with legal/security review.**
- **Review trigger:** Dependency upgrade, advisory, license change, conformance failure, unsupported .NET release, generator output drift, maintenance inactivity.

## 12.14 ADR-CV-014 — Give every external integration a consumer-specific adapter and commitment

- **Decision:** External systems **MUST NOT** consume endpoint events, inbox rows, server persistence entities, or portal DTOs directly. Each named external consumer gets a narrow server-side contract, adapter, data-purpose/minimization review, version/support commitment, compatibility suite, authentication/realm rules, deletion behavior, error/retry semantics, and an accountable commitment owner. Consumer-driven tests may supplement the provider schema but cannot override UAM privacy/security invariants.
- **Status:** Proposed; exact consumers and commitments are **HUMAN DECISIONS**.
- **Alternatives:** Shared enterprise event schema; database views/SQL access; export internal DTO; one universal integration endpoint; informal CSV.
- **Rationale:** Consumer-specific adapters prevent legacy or third-party needs from expanding endpoint collection, persistence coupling, or all consumers’ support windows. They also make deletion and realm boundaries reviewable.
- **Evidence:** Accepted modular-monolith/integration boundary; Sections 3.3, 3.5, 5.3, 6.2, 8 P18, 9 FF-INTEGRATION-*; Pact review.
- **Owner:** **UNASSIGNED — named external commitment owner per integration.**
- **Review trigger:** New consumer, changed purpose/field set, data residency/realm requirement, SLA/compatibility commitment, consumer retirement, repeated integration-specific transformations.

## 12.15 ADR decision order and stop logic

The ADRs are not independent. Accept them in this order:

1. `ADR-CV-001` boundary governance and owner model.
2. `ADR-CV-002` serialization profile, `ADR-CV-003` formal-spec stack, and `ADR-CV-004` catalogue/bundle model.
3. `ADR-CV-005` version/rollout rules and the explicit human compatibility-window decision.
4. `ADR-CV-006` model separation and `ADR-CV-013` replaceable tool dependencies.
5. Boundary-specific ADRs `007` through `011` and `014` as their contracts enter `candidate` state.
6. `ADR-CV-012` is accepted as a defer-and-measure rule; any binary format requires a new ADR.

A dependent ADR remains `Proposed` when an upstream owner, human policy, or proof gate is unresolved. A rejected ADR must record the alternative selected, affected invariants, migration consequence, and the smallest falsifying experiment. No ADR may use “temporary” to bypass a contract owner, rejection behavior, or privacy/security review.

---

# 13. Ordered implementation backlog with dependencies and stop gates

The backlog is ordered to minimize throwaway integration code. Items may run in parallel only where their dependency column permits it. `STOP` means dependent integration or release work must not begin; it does not mean investigation and isolated synthetic prototypes must stop.

## 13.1 Work packages

| Order / ID | Repository task and concrete deliverable | Dependencies | Exit evidence | Stop gate |
|---|---|---|---|---|
| 1 / B01 | **Name accountable functions.** Populate contract authority, boundary owner, semantic/privacy approver, security reviewer, release owner, support owner, external commitment owner, and deletion/restore authority in `contracts/OWNERS.yaml`; prohibit group aliases without an accountable escalation path. | None | Reviewed ownership file; no `UNASSIGNED` owner for a candidate contract | **STOP all candidate/active contracts** if absent |
| 2 / B02 | **Record human policy options.** Create decision records for field semantics, compatibility window/rollout, and external commitments; record conservative temporary defaults without presenting them as approval. | B01 | Signed/approved decision references or explicit unresolved state | **STOP affected contract activation** while unresolved |
| 3 / B03 | **Create repository skeleton.** Add `contracts/standard/`, `catalogue/`, `schemas/`, `openapi/`, `examples/`, `vectors/`, `compatibility/`, `bundles/`, `tools/`, `tests/`, `observability/`, `runbooks/`, `evidence/README.md`, and CODEOWNERS/branch protection. | B01 | Deterministic tree manifest and protected review paths | STOP publication without protected review |
| 4 / B04 | **Submit ADR-CV-001 through ADR-CV-006 and ADR-CV-013.** Link owners and unresolved human decisions; do not mark boundary ADRs accepted prematurely. | B01–B03 | ADR review records and dependency graph | STOP contract implementation on rejected/unresolved foundation |
| 5 / B05 | **Write `UAM Contract Standard v1.0-draft`.** Transcribe Sections 5 and 6 into a concise normative specification, including terminology, strict profile, identifiers, limits, versioning, lifecycle, errors, signing, evidence, and governance. | B04 | Normative document lint; BCP 14 usage review; no contradictions | STOP schema publication without standard |
| 6 / B06 | **Define catalogue meta-schema and ownership manifest.** Machine-check every catalogue row for owner, classification, direction, transport, schema ID, limits, compatibility, reject code, lifecycle, support/runbook, and evidence pointers. | B03, B05 | Meta-schema validation and negative fixtures | Primary gate fails on any missing field |
| 7 / B07 | **Implement `Uam.Contracts.Cli` evidence core.** Deterministic manifest, redaction scan, exit semantics, environment capture, evidence hashing, and cleanup declaration. | B03 | CLI unit tests, synthetic evidence fixture, no sensitive output | STOP accepting CLI evidence if hygiene fails |
| 8 / B08 | **Pin toolchain and dependency policy.** Locked .NET SDK policy, NuGet lockfiles, source provenance, license/advisory review, external CLI hashes, no floating actions/images. | B03, B07 | Reproducible restore/build and supply-chain manifest | STOP merge on unlocked/floating critical dependency |
| 9 / B09 | **Validator bake-off.** Evaluate at least the selected `System.Text.Json` parsing layer plus two JSON Schema candidates against official Draft 2020-12 tests, UAM strictness vectors, remote-ref denial, resource caps, concurrency, NativeAOT/trimming if relevant, and licenses. | B05, B07, B08 | P05 evidence and selection ADR amendment | STOP runtime schema dependency selection without pass/legal status |
| 10 / B10 | **OpenAPI lint/diff adapter.** Pin OpenAPI 3.1.2 validation; wrap `oasdiff` or a selected equivalent; elevate required rules to errors; add UAM rule overlay and false-positive/negative fixtures. | B05, B07, B08 | Versioned adapter, deterministic reports, mutation-test corpus | STOP treating tool output as sole oracle |
| 11 / B11 | **Immutable bundle builder.** Resolve only repository-local refs; package schemas/OpenAPI/examples/vectors/catalogue subset; generate manifest with content hashes and tool versions; verify byte reproducibility. | B06, B09, B10 | Two clean builds have identical bundle/hash | STOP runtime network schema lookup |
| 12 / B12 | **Strict JSON adapter.** Central bounded UTF-8 reader that detects duplicates before object mapping, rejects unknown/case-mismatched members, enforces depth/token/string/number limits, and emits safe stable errors. | B05, B09 | P01–P04 plus fuzz corpus and allocation evidence | STOP all JSON boundary integration on parser ambiguity |
| 13 / B13 | **Common normative scalar schemas.** Contract descriptor, UUID, timestamp, digest, content type, bounded error code, revision, pagination/cursor, provenance, authenticated-context reference; no business event semantics. | B05, B09, B12 | Golden positive/negative vectors and codegen compile tests | STOP downstream schema duplication/divergence |
| 14 / B14 | **Error catalogue and observability manifest.** Implement RFC 9457 profile, retry classes, safe details, log/trace fields, metric instruments/labels, bootstrap cardinality bounds, and runbook links. | B05, B13 | P15/P17 evidence; privacy canary scan | STOP boundary activation on raw payload/identity telemetry |
| 15 / B15 | **IPC handshake/framing contracts.** Coordinator, User Host, and Task Host hello/select/reject/close messages; exact versions/capabilities; frame length; timeouts; session-bound identity context. | B13, B14 | Schemas, vectors, Windows harness contract | STOP G1 integration until B25 passes |
| 16 / B16 | **Collector invocation/result contracts.** Source-specific typed invocation and bounded candidate result inside the restricted user process; explicit cancellation, deadlines, generation/cursor provenance, and error taxonomy; no arbitrary command/script field. | B13–B15 | Source adapter tests using fictional Edge data | STOP collector-host integration without Task Host restriction review |
| 17 / B17 | **Privacy transformation contracts.** Candidate-to-minimized transformation input/output, product-ceiling reference, transformation revision, canary tests, discard semantics, and no raw-value diagnostics. | B13, B16 | Golden vectors and P07 evidence | **STOP G4** on any forbidden-value escape |
| 18 / B18 | **Signed ceiling/policy/effective-policy contracts.** JCS/JWS profile candidate, version monotonicity, scope, expiry/activation, capability/source/field restrictions, tenant-narrows-only proof, key transition and emergency block messages. | B13, B17; security/key decision | P13 evidence and signing runbook drill | STOP policy activation without authorized key/profile |
| 19 / B19 | **Local minimized event and source-progress contracts.** Stable event/dedupe identity, source/generation/cursor/run provenance, privacy revision, field presence rules, and persistence adapter model separate from wire. | B13, B17 | SQLite schema/migration mapping tests, golden vectors | STOP persistence integration if cursor/event atomicity absent |
| 20 / B20 | **Batch, receipt, and status contracts.** Bounded upload envelope, digest/media headers, event array/count/expanded size, idempotency, durable receipt, processing-status query, quarantine summary, and explicit receipt semantics. | B13, B14, B19 | P08–P10 schemas/vectors/matrix | STOP endpoint-server integration until durability gate passes |
| 21 / B21 | **Health contracts.** Endpoint local health, server health intake/summary, compatibility status, backlog bands, failure codes, clock-quality flags, no raw activity or per-event labels. | B13, B14, B20 | Cardinality model and privacy tests | STOP health upload if it becomes alternate activity channel |
| 22 / B22 | **Administrative command/result and audit contracts.** Concurrency token, reason code, authorization context reference, before/after safe summary, immutable audit correlation, and atomic mutation/audit rule. | B13, B14 | Authorization/audit transaction tests | STOP privileged mutation without durable audit |
| 23 / B23 | **Quarantine contracts and tools.** Reason/status/revision, bounded evidence pointer, access role, reprocess request/result, validator/materializer revisions, and disposal/retention hooks; no ordinary raw-payload UI. | B20, B22 | Poison corpus, P10, access tests, runbook | STOP auto-replay/manual mutation without authorization/audit |
| 24 / B24 | **Deletion/tombstone/application-state contracts.** Request scope, authoritative revision, propagation evidence, replay/restore readiness, conflict handling, query/export/integration suppression. | B13, B22; governance decision | P16 evidence and restore runbook | STOP production deletion claims while policy/evidence unresolved |
| 25 / B25 | **Execute G1 IPC isolation prototype.** Multi-user/session/service lab with low privilege, explicit DACL/logon SID, wrong-session clients, pipe squatting, restart/skew, frame abuse, and cleanup. | B15, B16, approved lab lane | P06 immutable evidence bundle | **STOP all dependent endpoint integration on failure** |
| 26 / B26 | **Execute G4 privacy containment prototype.** Forbidden synthetic canaries across source result, process memory boundary, IPC, SQLite, logs, traces, dumps, evidence and upload. | B17, B18, B25 | P07 evidence and zero canary outside allowed transient plane | **STOP dependent collection/persistence work on failure** |
| 27 / B27 | **Execute G5 outbox/checkpoint crash invariant.** SQLite one-writer transactions and fault points before/during/after commit, batch formation, receipt apply, restart, disk-full and WAL recovery. | B19, B20, B26 | P08 evidence; invariant checker | **STOP upload integration on cursor-ahead/data-loss failure** |
| 28 / B28 | **Implement durable inbox harness and fault injection.** Transactional accept/receipt, connection loss, process kill, database restart/failover model, duplicate/same-ID-different-content, post-custody validation/quarantine. | B20, B23 | P09/P10 evidence for candidate engines | **STOP custody receipt endpoint on any premature ACK** |
| 29 / B29 | **Execute old/new matrices and rollback.** Build N and N+1 producer/consumer artifacts for IPC, batch, receipt/status, policy, audit, deletion and selected integration; include strict readers, reserved fields, downgrade, kill switch, rollback. | B15–B24, B25–B28 | P08/P18 matrix with artifact hashes | Primary gate fails on any required pair not proved/rejected as declared |
| 30 / B30 | **Measure JSON/plain and JSON/gzip.** Seeded synthetic tiny/typical/worst/maximum event sets; endpoint and server serialize/parse, allocations, compressed/expanded size, ratio guard, corruption, cancellation, sustained queues. | B20, representative synthetic generator | P11/P12 evidence against approved or explicitly provisional budgets | STOP binary discussion until evidence exists; STOP release if hard cap unsafe |
| 31 / B31 | **Realm isolation and authenticated-context tests.** Two or more fictional realms, payload claim spoofing, identifier collision, cache/lease/query/export/audit/deletion paths, backup/restore scenario. | B20–B24, B28 | P14 evidence and authorization matrix | **STOP server integration on any cross-realm effect** |
| 32 / B32 | **Compatibility observability implementation.** Supported/observed version counts, rejection/quarantine reasons, rollout readiness, exact-version kill state, backlog bands and runbook alerts without high-cardinality labels. | B14, B20, B21, B29 | P15/P17 evidence | STOP retirement when observer coverage is incomplete |
| 33 / B33 | **External integration template and synthetic reference consumer.** Dedicated schema/adapter, purpose/minimization metadata, contract commitment placeholder, CDC suite, deletion and realm tests. | B14, B22, B24; named owner for real integration | P18 evidence; no internal DTO reference | STOP any real external integration without named commitment owner |
| 34 / B34 | **Accessible operator surfaces for contract failures.** BFF/view models for compatibility, quarantine, kill/freeze, deletion and evidence state; keyboard, focus, status/error semantics, text alternatives, localization-safe machine codes. | B14, B21–B24 | P19 automated plus manual WCAG 2.2 AA-oriented evidence | STOP applicable admin release on critical accessibility failure |
| 35 / B35 | **Generate boundary adapters only after schemas stabilize.** Generate or hand-write transport models into isolated assemblies; commit generator config/hash; compile under nullable/warnings-as-errors; snapshot output; explicit maps to domain/persistence/view models. | B09–B13, boundary schema at candidate | Deterministic generated diff and dependency tests | STOP generated code update on unexplained semantic/nullability drift |
| 36 / B36 | **Run supply-chain, license, and security acceptance.** Select validator/generator/diff/canonicalizer dependencies from Section 14 or alternatives; legal review unusual terms; advisory scan; SBOM/provenance; update runbook. | B08–B12, B35 | E19 evidence and approved dependency ADR amendment | STOP dependency promotion on license/security unknown |
| 37 / B37 | **Build first synthetic Edge slice end to end.** Only after G1/G4/G5: User Host acquisition adapter → privacy transform → Coordinator IPC → local transaction → batch → durable inbox → validation/materialization/quarantine → bounded admin view. | B25–B36 plus prior Edge acquisition gates G2/G3 | Contract bundle, matrices, synthetic E2E evidence, cleanup | STOP on any prerequisite gate failure; no real activity data |
| 38 / B38 | **Canary rollout rehearsal.** Install/upgrade/rollback N/N+1 in isolated lab; consumer-first order; freeze/kill exact producer/contract; long-offline simulation; policy downgrade; server rollback; evidence/runbooks. | B29, B32, B37 | Timeline, inventory, alerts, rollback and cleanup evidence | STOP pilot on inability to freeze/rollback safely |
| 39 / B39 | **Primary contract-integration gate review.** Machine-evaluate every candidate contract for version, owner, limits, compatibility, rejection, vectors, matrices, runbooks, evidence and prerequisite gate status; obtain human signatures. | B01–B38 applicable to slice | Immutable `gate-result.json` and signed decision record | Default result is **STOP** unless every applicable criterion passes |
| 40 / B40 | **Pilot recommendation, not production approval.** Package residual risks, unresolved human decisions, support rota, release manifest, rollback threshold, retention/access status and evidence links for the authorized decision body. | B39 `GO` | Explicit pilot authorization or rejection | Production remains separately gated |

## 13.2 Parallelization rules

- B09 (validator bake-off) and B10 (OpenAPI adapter) may run in parallel after B05/B07/B08.
- Boundary schema work B15–B24 may branch after B13/B14, but no two branches may redefine common scalars, error codes, authenticated context, or lifecycle vocabulary.
- P06/G1, P07/G4, and P08/G5 remain sequential in the accepted proof-gate order because later work depends on the earlier security/privacy/transaction claim.
- Server-only synthetic work that cannot consume endpoint output may proceed in isolation, but it cannot be called endpoint integration or satisfy an earlier gate.
- Documentation, runbook drafting, mutation corpus creation, and accessibility test scaffolding may run early; their pass evidence must be regenerated against the candidate artifacts.

## 13.3 Definition of done for every backlog item that publishes a contract

A contract-publishing item is not done until:

1. its catalogue row and owners are complete;
2. schema and normative prose agree;
3. all hard and provisional limits are machine-readable;
4. accepted, rejected, duplicate, unknown, null, boundary, Unicode, numeric, time, identifier, and oversized vectors exist;
5. producer/consumer support and rejection are declared;
6. diff plus executable compatibility tests pass;
7. safe errors, metrics, logs, and runbook actions are defined;
8. privacy/security/realm impact is reviewed;
9. generated code, if any, is reproducible and isolated;
10. evidence is synthetic/sanitized, hashed, complete, and cleaned up.

A checklist assertion without the referenced machine evidence is `UNKNOWN`, not pass.

---

# 14. Open-source repository assessment table

## 14.1 Decision summary

**RECOMMENDATION.** Use open-source projects as pinned, replaceable tools or candidates after UAM conformance, security, performance, operations, and license gates. Do not copy a registry platform or consumer-driven-contract operating model wholesale. None of the projects below is evidence that UAM itself meets its privacy, custody, realm, Windows-session, or rollback invariants.

| Repository | Reviewed revision as of 31 July 2026 | License / material concern | Maintenance, testing, and security signal | UAM suitability |
|---|---|---|---|---|
| `oasdiff/oasdiff` | Release `v1.27.0`, 30 Jul 2026; commit `fb8babb92c123991e7cff4500bb35cafe97e5f7b` | Apache-2.0; external Go binary/tool-chain provenance must be pinned | Very recent release; substantial tests/data; supports validation and breaking-change reports; security guidance for external refs. Version-policy findings default to informational unless configured | **Build dependency candidate** behind UAM adapter; never sole compatibility oracle |
| `Apicurio/apicurio-registry` | Release `3.3.1`, 27 Jul 2026; commit `06c984f524542b584278bba6e75cd64f7f61b890` | Apache-2.0; large Java/service operational and transitive surface | Active large project with integration tests. Same release includes hardening for ZIP expansion, XML/XXE/entity expansion, WSDL SSRF, HSTS, and digest pinning, plus distributed-state/audit issues | **Architecture/security reference only** initially; do not deploy as UAM runtime dependency without a new measured ADR |
| `pact-foundation/pact-net` | Release `5.0.1`, 22 Mar 2025; commit `171c82c2da0f000d424fd94a1ccd4fe910955d0e` | MIT; packages include native Pact FFI/platform dependencies and optional broker ecosystem | Mature tests and examples; latest reviewed release is older than other candidates, so maintenance/support must be rechecked at adoption | **Optional test dependency/reference** for named external consumer contracts; not UAM’s normative schema/version authority |
| `RicoSuter/NSwag` | Release `v14.7.1`, 20 Apr 2026; commit `2389c0721d069fa8ea07e35b925b66121e577c81` | MIT; broad generator dependencies/output surface | Active release stream and integration tests. `v14.7.1` corrected a nullability regression from `v14.7.0`, demonstrating need for generated-output snapshots and compilation tests | **Code-generation candidate** for selected HTTP clients/servers after bake-off; generated code remains boundary-local |
| `json-everything/json-everything` (`JsonSchema.Net`) | NuGet `JsonSchema.Net 9.4.0`, 26 Jul 2026; reviewed commit `399f198431f65cf6896fe6038f833ef6d0b27a39` | Source repository states MIT, while project-supplied binary releases carry an Open Source Maintenance Fee EULA for revenue-generating users; legal/procurement review required | Very active, broad System.Text.Json suite, official test-suite integration and conformance reporting; no UAM-specific resource-limit/security proof | **Runtime validator candidate only after legal, conformance, adversarial, allocation, and support review**; not preselected |
| `corvus-dotnet/Corvus.JsonSchema` | Release family `5.2.10`, Jul 2026; reviewed commit `a67f993cecd7b64eec7f8e4bd6e540555b91bfd2` | Apache-2.0; source-generation complexity and generated-code footprint | Active; source, test, benchmark and pinned specification-suite submodules; broad JSON Schema/OpenAPI variants. Determinism and platform/toolchain behavior still require UAM proof | **Source-generation/runtime candidate** in bake-off; attractive reference for strongly typed boundary models |
| `json-schema-org/JSON-Schema-Test-Suite` | Commit `c7257e92580678a086f0b9243a1903ed88bd27f7`, 22 Apr 2026 | MIT; tests specification behavior, not parser resource safety or UAM profile | Official language-neutral conformance corpus for multiple drafts, including 2020-12; optional tests require deliberate interpretation | **Pinned test/reference dependency**; mandatory input to validator bake-off, supplemented by UAM adversarial tests |
| `cyberphone/json-canonicalization` | Commit `19d51d7fe467d4706a3ff08adf8a748f29fc21e0`, 13 Dec 2024 | Apache-2.0; multi-language example code has uneven maintenance and is not an assurance package | Useful cross-language JCS implementations and test data; older reviewed activity and no identified independent security audit in the reviewed material | **Reference/test-vector source only**; do not import an implementation unchanged into the signing trust boundary |

## 14.2 Detailed repository reviews

### R01 — `oasdiff/oasdiff`

- **Repository and revision:** [repository](https://github.com/oasdiff/oasdiff); [release `v1.27.0`](https://github.com/oasdiff/oasdiff/releases/tag/v1.27.0); [exact tree at `fb8babb92c123991e7cff4500bb35cafe97e5f7b`](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b).
- **Relevant reviewed paths:** [`checker/`](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b/checker), [`validate/`](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b/validate), [`data/`](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b/data), [`docs/`](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b/docs), [license](https://github.com/oasdiff/oasdiff/blob/fb8babb92c123991e7cff4500bb35cafe97e5f7b/LICENSE), and [security policy](https://github.com/oasdiff/oasdiff/security/policy).
- **License and compatibility:** Apache-2.0 is generally compatible with commercial/internal use, subject to normal notice and dependency review. Running a downloaded Go binary introduces provenance, update, and platform packaging obligations; pin tag, commit, binary hash, and action/container digest.
- **Maintenance/release activity:** `v1.27.0` was released one day before the research date. It added version-policy checks, more validation lints, and rule-set changes. This is strong maintenance evidence, not long-term support assurance.
- **Testing/security posture:** The repository contains dedicated checker/validation code and test data. It documents controls around external `$ref` loading. UAM must disable remote input resolution and must mutation-test the exact configured checks. Release notes state version-bump rules default to `INFO`; a default invocation therefore does not enforce UAM policy.
- **Architectural similarity:** It compares OpenAPI revisions and identifies potential consumer-visible breakage, matching one part of UAM CI.
- **Threat-model difference:** It does not know UAM privacy ceilings, authenticated realm derivation, receipt semantics, local persistence, semantic field meaning, or actual deployed consumer behavior. It may miss a UAM semantic break or flag a harmless change.
- **Reusable ideas:** Stable change IDs, severity configuration, machine-readable diff, explicit version-bump checks, local-file operation, and validation rules.
- **Do not copy:** “Tool says non-breaking, therefore rollout is safe”; remote URLs in CI; default severities; hosted review service with protected contracts unless separately approved.
- **Suitability:** **Candidate pinned build tool** behind `Uam.Contracts.Cli`; output is supporting evidence combined with golden vectors and executable matrices.

### R02 — `Apicurio/apicurio-registry`

- **Repository and revision:** [repository](https://github.com/Apicurio/apicurio-registry); [release `3.3.1`](https://github.com/Apicurio/apicurio-registry/releases/tag/3.3.1); [exact tree at `06c984f524542b584278bba6e75cd64f7f61b890`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890).
- **Relevant reviewed paths:** [`app/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/app), [`common/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/common), [`schema-validation/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/schema-validation), [`contracts-rules/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/contracts-rules), [`integration-tests/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/integration-tests), [`operator/`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890/operator), and [license](https://github.com/Apicurio/apicurio-registry/blob/06c984f524542b584278bba6e75cd64f7f61b890/LICENSE).
- **License and compatibility:** Apache-2.0. A deployment would still require Java/runtime/container/database/operator skills, backup/restore, identity/RBAC, network exposure, patching, monitoring, and transitive-license/advisory management.
- **Maintenance/release activity:** `3.3.1` was released 27 July 2026. The repository has a large active issue/release surface and multiple language SDK/CLI/operator/UI components.
- **Testing/security posture:** Integration-test and validation modules are present. The reviewed release includes decompressed ZIP size/entry limits, XML parser hardening, WSDL remote-dereference/SSRF protection, HSTS corrections, and image digest pinning. It also lists distributed-state/audit consistency and configuration issues. Those are useful, honest signals of both maintenance and the attack/operations surface of a runtime registry.
- **Architectural similarity:** Immutable artifacts, versions, compatibility rules, identifiers, import/export and registry APIs overlap with contract governance concerns.
- **Threat-model difference:** UAM initially has a bounded set of components shipped as coordinated artifacts and no proved runtime discovery requirement. A registry becomes another highly privileged online control service; compromise could distribute or bless malicious schemas. Its general multi-format import surface is broader than UAM needs.
- **Reusable ideas:** Immutable artifact versions, compatibility policy as data, content hashes, audit of changes, export/backup, bounded import, reference controls, and explicit lifecycle.
- **Do not copy:** General-purpose import of archives/XML/WSDL/remote references; mutable global rules without proven cluster durability; online lookup in endpoint/runtime validation; operator/UI/SDK estate before need.
- **Suitability:** **Reference only now.** Reconsider as a dependency only after a new ADR demonstrates deployment independence or governance value that pinned bundles cannot meet, and after a dedicated security/operations benchmark.

### R03 — `pact-foundation/pact-net`

- **Repository and revision:** [repository](https://github.com/pact-foundation/pact-net); [release `5.0.1`](https://github.com/pact-foundation/pact-net/releases/tag/5.0.1); [exact tree at `171c82c2da0f000d424fd94a1ccd4fe910955d0e`](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e).
- **Relevant reviewed paths:** [`src/PactNet/`](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e/src/PactNet), [`tests/`](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e/tests), [`samples/`](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e/samples), [package/build files](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e/build), and [license](https://github.com/pact-foundation/pact-net/blob/171c82c2da0f000d424fd94a1ccd4fe910955d0e/LICENSE.txt).
- **License and compatibility:** MIT. Review direct and native Pact FFI packages for supported Windows/server architectures, vulnerability response, package provenance, and release cadence. A hosted Pact Broker is a separate service/security/retention decision.
- **Maintenance/release activity:** The reviewed latest release was 22 March 2025. That is not abandonment evidence, but at adoption time UAM must verify current commits/releases and .NET support rather than assuming 2025 behavior remains current.
- **Testing/security posture:** Repository tests and samples demonstrate provider/consumer verification. Native FFI reduces the amount of duplicated implementation but broadens platform and supply-chain testing. No reviewed material proves UAM privacy or payload-hygiene controls.
- **Architectural similarity:** Named consumers can publish expectations and providers can verify them before release, useful where UAM has an independently managed external consumer.
- **Threat-model difference:** Consumer expectations do not authorize new data collection, override the product privacy ceiling, establish realm identity, or prove a server receipt transaction. Internal UAM components already have a normative schema catalogue and can run direct matrices without a broker.
- **Reusable ideas:** Provider states, explicit consumer/provider identities, verification at the provider commit, pending contracts during rollout, and recording which consumer was proved.
- **Do not copy:** Letting consumers dictate privacy-bearing fields; publishing raw production interactions; making a broker an availability dependency for runtime; replacing schema/semantic review with examples.
- **Suitability:** **Optional test dependency or reference** for named external consumers after current maintenance/platform review. Direct UAM matrix tests remain mandatory.

### R04 — `RicoSuter/NSwag`

- **Repository and revision:** [repository](https://github.com/RicoSuter/NSwag); [release `v14.7.1`](https://github.com/RicoSuter/NSwag/releases/tag/v14.7.1); [exact tree at `2389c0721d069fa8ea07e35b925b66121e577c81`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81).
- **Relevant reviewed paths:** [`src/NSwag.Core/`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81/src/NSwag.Core), [`src/NSwag.CodeGeneration/`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81/src/NSwag.CodeGeneration), [`src/NSwag.Generation.AspNetCore/`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81/src/NSwag.Generation.AspNetCore), [`src/`](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81/src), and [license](https://github.com/RicoSuter/NSwag/blob/2389c0721d069fa8ea07e35b925b66121e577c81/LICENSE.md).
- **License and compatibility:** MIT. Review transitive NJsonSchema and templating/tool packages. Pin the generator and its configuration; do not let developer-global tools determine output.
- **Maintenance/release activity:** `v14.7.1` was released 20 April 2026. The preceding `v14.7.0` introduced a nullability regression and `v14.7.1` fixed it. This is evidence of responsive maintenance and of generator-upgrade risk.
- **Testing/security posture:** Integration tests cover generated clients/servers across targets. Generators consume complex specifications and emit executable source; UAM must prohibit remote refs, constrain inputs to the repository bundle, scan generated code, compile warnings-as-errors, and execute wire vectors.
- **Architectural similarity:** It can create boundary-specific C# API clients and DTOs from OpenAPI, reducing hand transcription.
- **Threat-model difference:** It does not enforce UAM’s anti-shared-DTO architecture, semantic versioning, realm derivation, privacy ceiling, or receipt meaning. A generated nullable/default choice can silently alter behavior despite a valid OpenAPI document.
- **Reusable ideas:** Configuration-as-code, deterministic CLI generation, integration test corpus, and generated client/server separation.
- **Do not copy:** Code-first OpenAPI as authority; unchecked generated DTO reuse in domain/persistence/view layers; automatic upgrades; accepting template output diffs without semantic review.
- **Suitability:** **Candidate build dependency** for selected HTTP boundaries after P05/P18. Snapshot, compile, and behavior-test output at every upgrade.

### R05 — `json-everything/json-everything` / `JsonSchema.Net`

- **Repository and revision:** [repository](https://github.com/json-everything/json-everything); [exact tree at `399f198431f65cf6896fe6038f833ef6d0b27a39`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39); [NuGet `JsonSchema.Net 9.4.0`](https://www.nuget.org/packages/JsonSchema.Net/9.4.0).
- **Relevant reviewed paths:** [`src/JsonSchema/`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39/src/JsonSchema), [`src/JsonSchema.Tests/`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39/src/JsonSchema.Tests), [`Meta-Schemas/`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39/Meta-Schemas), [`ref-repos/`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39/ref-repos), [source `LICENSE`](https://github.com/json-everything/json-everything/blob/399f198431f65cf6896fe6038f833ef6d0b27a39/LICENSE), and [`OSMFEULA.txt`](https://github.com/json-everything/json-everything/blob/399f198431f65cf6896fe6038f833ef6d0b27a39/OSMFEULA.txt).
- **License and compatibility:** The source is presented under MIT, while the repository and package model state that project-provided compiled binaries carry a maintenance-fee EULA for revenue-generating users. This is not a routine MIT-only procurement conclusion. Legal/procurement must decide whether package use, source build, fee, notices, and ongoing updates are acceptable; research does not give legal advice.
- **Maintenance/release activity:** `JsonSchema.Net 9.4.0` was published 26 July 2026 and the reviewed commit is from the same period. The project supports current .NET targets and a broad family of JSON specifications.
- **Testing/security posture:** Dedicated tests and official JSON Schema Test Suite references are strong conformance signals. Runtime use still requires UAM tests for duplicate detection before mapping, `unevaluatedProperties`, format policy, remote-ref denial, pathological schemas/instances, cancellation, memory/CPU bounds, thread safety, AOT/trimming if applicable, and safe error redaction. No conformance badge establishes those UAM properties.
- **Architectural similarity:** A System.Text.Json-native Draft 2020-12 validator fits UAM’s C# family and local-bundle design.
- **Threat-model difference:** General schema evaluation may support dynamic/ref features UAM forbids, and validator diagnostics can include instance values. Package licensing/maintenance terms create organizational cost not reflected in API fitness.
- **Reusable ideas:** Explicit dialect/vocabulary support, official-suite integration, immutable schema registration/cache under a UAM wrapper, and structured evaluation output.
- **Do not copy:** Runtime network schema retrieval; unconstrained custom vocabularies; raw instance values in validation reports; package adoption before legal review.
- **Suitability:** **Conditional runtime/build candidate.** It may win B09 only after legal approval and every P01–P05/resource test passes. Maintain an adapter so replacement does not change contracts.

### R06 — `corvus-dotnet/Corvus.JsonSchema`

- **Repository and revision:** [repository](https://github.com/corvus-dotnet/Corvus.JsonSchema); [release `5.2.10`](https://github.com/corvus-dotnet/Corvus.JsonSchema/releases/tag/5.2.10); [exact reviewed tree at `a67f993cecd7b64eec7f8e4bd6e540555b91bfd2`](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2).
- **Relevant reviewed paths:** [`src/`](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/src), [`tests/`](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/tests), [`benchmarks/`](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/benchmarks), [pinned `JSON-Schema-Test-Suite` submodule](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/JSON-Schema-Test-Suite), [`ARCHITECTURE.md`](https://github.com/corvus-dotnet/Corvus.JsonSchema/blob/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/ARCHITECTURE.md), and [license](https://github.com/corvus-dotnet/Corvus.JsonSchema/blob/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2/LICENSE).
- **License and compatibility:** Apache-2.0. Review generated-source notices, transitive packages, build-time tooling, and whether source-generator execution is deterministic under the pinned SDK.
- **Maintenance/release activity:** The reviewed `5.2.10` release family and commit are from July 2026. Repository content includes broad specification/test-suite updates, source generators and benchmarks.
- **Testing/security posture:** Strong test/benchmark structure and specification-suite submodules are positive. Generated parsers/types can reduce reflection and allocations, but UAM must prove duplicate/unknown handling, resource caps, exact formats, diagnostics redaction, deterministic output, Windows/server equivalence, and compatibility of generated code across SDK updates. Open issues are not automatically blockers but must be triaged at adoption.
- **Architectural similarity:** Schema-first strongly typed boundary values align with explicit adapters and compile-time separation.
- **Threat-model difference:** Generated types do not by themselves authenticate peers, protect privacy candidates, constrain process boundaries, or establish transaction semantics. Generator compromise/output drift enters the build trust boundary.
- **Reusable ideas:** Schema-first source generation, value types, official-suite tests, benchmarks, pinned schema repositories, and avoiding reflection-heavy dynamic mapping.
- **Do not copy:** Let generated types become domain/persistence/view DTOs; assume generator conformance equals strict UAM profile; regenerate with an unpinned SDK/tool.
- **Suitability:** **Candidate build/runtime dependency** in B09/B35. It may be selected for boundary types even if a different library performs server-side dynamic validation, but two validators must not silently disagree.

### R07 — `json-schema-org/JSON-Schema-Test-Suite`

- **Repository and revision:** [repository](https://github.com/json-schema-org/JSON-Schema-Test-Suite); [exact tree at `c7257e92580678a086f0b9243a1903ed88bd27f7`](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7).
- **Relevant reviewed paths:** [`tests/draft2020-12/`](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7/tests/draft2020-12), [`remotes/`](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7/remotes), [`bin/`](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7/bin), [`optional/` under the draft suite](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7/tests/draft2020-12/optional), and [license](https://github.com/json-schema-org/JSON-Schema-Test-Suite/blob/c7257e92580678a086f0b9243a1903ed88bd27f7/LICENSE).
- **License and compatibility:** MIT. Vendoring/pinning the corpus is straightforward with attribution. The repository may contain tests UAM intentionally disables, such as remote references or optional formats; exclusions must be explicit and justified, not silently skipped.
- **Maintenance/release activity:** The reviewed commit is 22 April 2026. It tracks multiple drafts and serves as an ecosystem conformance baseline rather than an application library.
- **Testing/security posture:** It is the primary reusable conformance corpus, but it is not a fuzz suite, denial-of-service benchmark, duplicate-member test at the raw parser layer, signature test, or application semantic suite. Some schema behavior is intentionally implementation-defined or optional.
- **Architectural similarity:** It supplies deterministic schema/instance/expected-result triples suitable for the UAM validator adapter.
- **Threat-model difference:** It assumes a validator test environment and may exercise remote resources; UAM production forbids runtime network resolution and imposes tighter limits/profile rules.
- **Reusable ideas:** Pinned test cases, draft-specific organization, optional-test labelling, and language-neutral result comparison.
- **Do not copy:** Treating “passes official suite” as full security fitness; enabling remote fixtures in production; ignoring optional cases without recording policy.
- **Suitability:** **Required pinned reference/test input** for B09, augmented by UAM vectors and fuzz/resource tests. Not a runtime dependency.

### R08 — `cyberphone/json-canonicalization`

- **Repository and revision:** [repository](https://github.com/cyberphone/json-canonicalization); [exact tree at `19d51d7fe467d4706a3ff08adf8a748f29fc21e0`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0).
- **Relevant reviewed paths:** [`dotnet/`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0/dotnet), [`java/`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0/java), [`node-es6/`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0/node-es6), [`testdata/`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0/testdata), and [license](https://github.com/cyberphone/json-canonicalization/blob/19d51d7fe467d4706a3ff08adf8a748f29fc21e0/LICENSE).
- **License and compatibility:** Apache-2.0. Individual sample implementations must be reviewed for dependency, Unicode/number behavior, supported runtime, and secure coding before reuse.
- **Maintenance/release activity:** The reviewed commit is 13 December 2024, older than the active schema tools. That is acceptable for stable test vectors but raises dependency-maintenance questions for a signing-critical runtime implementation.
- **Testing/security posture:** Cross-language implementations and test data are useful interoperability evidence. The repository is not a substitute for RFC 8785, cryptographic review, constant-time key operations, key storage, signature verification policy, resource limits, or malformed-Unicode testing. No independent audit was identified in the reviewed repository material; this is not evidence that none exists elsewhere.
- **Architectural similarity:** UAM needs deterministic JSON bytes for signed privacy/policy artifacts and cross-implementation vectors.
- **Threat-model difference:** Canonicalization is only one step in a high-trust signing and verification system; this repository does not manage authorization, anti-replay, key rotation, algorithm constraints, or privacy semantics.
- **Reusable ideas:** Cross-language vectors, separation of parse/canonicalize/hash, and pathological numeric/Unicode examples.
- **Do not copy:** An example implementation directly into production signing; canonicalize already-ambiguous JSON; accept duplicate members then sign one parser’s interpretation; use JCS outside its number/string constraints.
- **Suitability:** **Reference and vector source only** initially. Select or implement the production canonicalizer under a separate cryptographic/code review and differential test.

## 14.3 Repository selection gate

A repository moves from “candidate/reference” to a UAM dependency only when its exact revision satisfies all of the following:

- documented license and legal/procurement decision, including binary/package terms;
- active maintenance/support assessment appropriate to the boundary’s lifetime;
- reproducible package/binary provenance and locked transitive dependencies;
- official conformance tests plus UAM strict, adversarial, resource, privacy, and compatibility vectors;
- no runtime remote schema/reference fetching;
- safe diagnostics and bounded resource behavior;
- supported .NET/Windows/server targets and operational skill coverage;
- upgrade/rollback runbook and adapter replacement path;
- security advisory monitoring and a patch owner;
- no architecture import that expands UAM’s data, trust, or operations surface without an ADR.

Failure of one criterion means **reference only** or **neither**, not “temporary dependency.”

---

# 15. Source register with stable links, dates, reviewed versions/commits, claims, and limitations

## 15.1 Allowed supplied evidence

Only the four project attachments allowed by the research brief were used as evidence. No other project file was searched, quoted, summarized, or relied on.

| ID | Supplied source | Date / fingerprint | Claim supported in this result | Limitation |
|---|---|---|---|---|
| I01 | `00-accepted-baseline-attachment.md` — Shared accepted baseline | Baseline date 31 Jul 2026; SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Accepted endpoint process topology; pre-IPC minimization; SQLite one-writer event/cursor invariant; at-least-once/idempotency; bounded authenticated compressed batches; custody receipt; modular monolith/inbox; no broker by default; governed integrations; synthetic first slice; non-negotiable realm/audit/release/restore invariants | Condensed working baseline, not full evidence, human approval, runtime proof, or production authority |
| I02 | `05-decisions-contradictions-and-gates.md` — Accepted decisions, contradictions, and proof gates | July 2026 synthesis; SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Same accepted architecture plus ordered G0–G5 and later proof gates; failed early gate stops dependent work and opens an ADR change | Implementation-research authority only; a passed gate proves only its stated claim |
| I03 | `04-data-and-schema-evidence-summary.md` — Data and schema evidence summary | Supplied 31 Jul 2026; deterministic curated summary; source hash not stated in the attachment | Separate target concepts; authenticated realm/device derivation; explicit received/validated/materialized/quarantined/visible states; stable dedupe/provenance; narrow server integrations; missing volume/retention/query/RPO evidence | No production row values, rates, representative payload distributions, retention, or engine benchmark; legacy shape does not define target semantics |
| I04 | `06-research-evidence-rules.md` — Research evidence rules | Supplied 31 Jul 2026; deterministic research instruction | Evidence labels, source hierarchy, conflict handling, human-decision limits, need for CLI/lab proof, and prohibition on sensitive/internal/raw evidence | Governs research quality; does not establish a technical capability |

## 15.2 Normative and standards sources

| ID | Primary source and stable link | Source date / reviewed version | Claim supported | Limitation / UAM-specific caution |
|---|---|---|---|---|
| S01 | [RFC 2119 — Key words for use in RFCs to Indicate Requirement Levels](https://www.rfc-editor.org/rfc/rfc2119.html) | Mar 1997 | Meanings of MUST/SHOULD/MAY vocabulary | Must be combined with RFC 8174 capitalization clarification; does not make this proposed ADR automatically approved |
| S02 | [RFC 8174 — Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words](https://www.rfc-editor.org/rfc/rfc8174.html) | May 2017 | BCP 14 capitalization rule | Editorial norm only |
| S03 | [RFC 8259 — The JavaScript Object Notation (JSON) Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259.html) | Dec 2017 | JSON grammar, interoperability issues, duplicate-name warning, number/string/object rules, UTF-8 requirement for interoperable network JSON | RFC permits behaviors UAM intentionally narrows; it does not require unknown-field rejection or UAM limits |
| S04 | [RFC 7493 — The I-JSON Message Format](https://www.rfc-editor.org/rfc/rfc7493.html) | Mar 2015 | Interoperability profile: Unicode, number range, duplicate member avoidance, timestamps and identifiers guidance | UAM-JSON-1 is stricter; I-JSON alone does not define schema, privacy, size, or rollout |
| S05 | [JSON Schema Draft 2020-12 landing page](https://json-schema.org/draft/2020-12), [Core](https://json-schema.org/draft/2020-12/json-schema-core), and [Validation](https://json-schema.org/draft/2020-12/json-schema-validation) | Published 16 Jun 2022; Draft 2020-12 | Schema dialect, vocabularies, `$id`/`$ref`, applicators, validation keywords, `unevaluatedProperties` | Implementations vary in optional formats and edge behavior; official tests plus UAM tests are required; runtime remote resolution is prohibited by UAM profile |
| S06 | [OpenAPI Specification 3.1.2](https://spec.openapis.org/oas/v3.1.2.html) | 19 Sep 2025; version 3.1.2 | HTTP API description aligned with JSON Schema 2020-12 vocabulary, media types, operations, responses and reusable components | Does not express all custody/privacy/transaction/rollout semantics; tooling conformance must be proved |
| S07 | [OpenAPI Specification 3.2.0](https://spec.openapis.org/oas/v3.2.0.html) | 19 Sep 2025; version 3.2.0 | Confirms a newer OpenAPI version exists at research date and provides an adoption alternative | Current existence is not evidence that the selected .NET generator/diff stack is ready; migration remains gated |
| S08 | [RFC 3339 — Date and Time on the Internet: Timestamps](https://www.rfc-editor.org/rfc/rfc3339.html) | Jul 2002 | Internet timestamp syntax and UTC offset representation | UAM selects a stricter UTC `Z` subset and declared precision; RFC validity does not prove clock quality |
| S09 | [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785.html) | Jun 2020 | Deterministic JSON canonicalization for hashing/signing, including member ordering and ECMAScript-compatible number serialization | JCS has input constraints and does not resolve duplicate/member ambiguity or authorize content; use only after strict parse and with cross-language vectors |
| S10 | [RFC 9562 — Universally Unique IDentifiers](https://www.rfc-editor.org/rfc/rfc9562.html) | May 2024 | UUID formats, including time-ordered UUID version 7 | UUID uniqueness remains probabilistic/implementation-dependent; identifiers do not establish realm authority or event semantics |
| S11 | [RFC 9530 — Digest Fields](https://www.rfc-editor.org/rfc/rfc9530.html) | Feb 2024 | `Content-Digest`/`Repr-Digest` fields and digest syntax/semantics | Integrity digest is not an authorization signature and does not establish durable custody by itself |
| S12 | [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html) | Jul 2023 | Standard HTTP problem-details structure and extensibility | UAM must constrain extensions and redact details; status/type/title alone do not define retry or support ownership |
| S13 | [RFC 7515 — JSON Web Signature](https://www.rfc-editor.org/rfc/rfc7515.html) | May 2015 | JWS protected headers, signature representation and verification model | Broad algorithm/options surface requires a narrow UAM profile; JWS does not solve key authorization, storage, rotation or replay |
| S14 | [RFC 7797 — JWS Unencoded Payload Option](https://www.rfc-editor.org/rfc/rfc7797.html) | Feb 2016 | Option for signing an unencoded payload and required critical-header handling | Optional complexity; use only if the final signed-envelope profile proves a need and interoperability |
| S15 | [RFC 9421 — HTTP Message Signatures](https://www.rfc-editor.org/rfc/rfc9421.html) | Feb 2024 | Standard alternative for signing selected HTTP message components | Not selected initially; proxy transformations, component selection, key policy and replay need dedicated proof |
| S16 | [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html) | Jun 2022 | HTTP methods/status semantics, content negotiation, validators and general response behavior | HTTP success does not define UAM durable receipt or semantic processing; UAM profiles status/retry behavior explicitly |
| S17 | [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) | Version 2.0.0; page reviewed 31 Jul 2026 | `MAJOR.MINOR.PATCH` vocabulary and incompatibility/addition/fix intent | Library API SemVer is not automatically wire compatibility; UAM’s strict-reader and semantic/privacy rules prevail |
| S18 | [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | W3C Recommendation edition updated 12 Dec 2024 | Accessibility success criteria for applicable admin/portal surfaces, including focus, status, error and input behavior | Automated tests cannot establish full conformance; scope, target level, locales and manual evaluation remain human/product decisions |

## 15.3 Microsoft/.NET/Windows primary sources

| ID | Primary source and stable link | Source/release date and reviewed version | Claim supported | Limitation / UAM-specific caution |
|---|---|---|---|---|
| M01 | [.NET and .NET Core Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Page last updated 14 Jul 2026; reviewed 31 Jul 2026. .NET 10 `10.0.10` LTS active through 14 Nov 2028; .NET 9/8 also supported at that point | Exact point-in-time support status; supported releases require current patches | Dynamic lifecycle facts change. Architecture names the lifecycle policy, not a timeless patch. Supported .NET does not prove UAM fitness or Windows estate compatibility |
| M02 | [Download .NET](https://dotnet.microsoft.com/en-us/download) | Reviewed 31 Jul 2026; .NET 10 SDK `10.0.302`, released 14 Jul 2026; .NET 11 preview also listed | Confirms current recommended SDK family at research date and that preview is not the default | Download page is dynamic. Execution must recapture exact SDK/runtime and use supported GA releases under repository policy |
| M03 | [`JsonSerializerOptions.AllowDuplicateProperties`](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions.allowduplicateproperties?view=net-10.0), [`UnmappedMemberHandling`](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions.unmappedmemberhandling?view=net-10.0), and [`MaxDepth`](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions.maxdepth?view=net-10.0) | .NET 10 documentation reviewed 31 Jul 2026 | Documented controls for duplicate-property rejection, unknown-member handling and maximum depth in the accepted implementation family | Defaults may be permissive and APIs can vary by target. These options do not enforce all UAM token/string/number/schema/resource rules; P01–P05 remain required |
| M04 | [System.Text.Json migration/feature comparison documentation](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/migrate-from-newtonsoft) | Microsoft Learn page reviewed 31 Jul 2026 | Documents strict/default behavior differences and configuration points relevant to safe migration and parsing | General guidance, not a security review or proof of selected settings under hostile input |
| M05 | [Named Pipe Security and Access Rights](https://learn.microsoft.com/en-us/windows/win32/ipc/named-pipe-security-and-access-rights) | Last updated 7 Jan 2021; reviewed 31 Jul 2026 | Explicit security descriptors/DACL checks; risks in default ACL; use of logon SID to restrict remote/different Terminal Services sessions; access-right nuance | Documentation proves platform capability, not UAM’s correct ACL/token/session implementation. G1 multi-session lab proof is mandatory |

## 15.4 Open-source source register

| ID | Repository/release source | Release/revision date and exact reviewed revision | Claim supported | Limitation |
|---|---|---|---|---|
| R01 | [`oasdiff/oasdiff`](https://github.com/oasdiff/oasdiff), [release `v1.27.0`](https://github.com/oasdiff/oasdiff/releases/tag/v1.27.0), [commit tree](https://github.com/oasdiff/oasdiff/tree/fb8babb92c123991e7cff4500bb35cafe97e5f7b) | 30 Jul 2026; `fb8babb92c123991e7cff4500bb35cafe97e5f7b` | Maintained OpenAPI diff/validation tool; version-policy and rule severity behavior; Apache-2.0 repository | Tool output is not UAM semantic/deployed compatibility proof; exact binary/transitive provenance and configured severities must be captured |
| R02 | [`Apicurio/apicurio-registry`](https://github.com/Apicurio/apicurio-registry), [release `3.3.1`](https://github.com/Apicurio/apicurio-registry/releases/tag/3.3.1), [commit tree](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890) | 27 Jul 2026; `06c984f524542b584278bba6e75cd64f7f61b890` | Registry capabilities and concrete import/parser/network/cluster/operations attack surface; Apache-2.0 | General Java registry differs from UAM’s initial local-bundle need; release issues are signals, not proof the project is insecure or unfit generally |
| R03 | [`pact-foundation/pact-net`](https://github.com/pact-foundation/pact-net), [release `5.0.1`](https://github.com/pact-foundation/pact-net/releases/tag/5.0.1), [commit tree](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e) | 22 Mar 2025; `171c82c2da0f000d424fd94a1ccd4fe910955d0e` | .NET consumer/provider contract-testing patterns and native FFI package surface; MIT | Maintenance/current .NET support must be reverified at adoption; CDC examples cannot authorize fields or replace normative schema/privacy rules |
| R04 | [`RicoSuter/NSwag`](https://github.com/RicoSuter/NSwag), [release `v14.7.1`](https://github.com/RicoSuter/NSwag/releases/tag/v14.7.1), [commit tree](https://github.com/RicoSuter/NSwag/tree/2389c0721d069fa8ea07e35b925b66121e577c81) | 20 Apr 2026; `2389c0721d069fa8ea07e35b925b66121e577c81` | Active .NET OpenAPI code generation; nullability regression/fix demonstrates upgrade-testing need; MIT | Generated code may be semantically wrong for UAM despite successful generation; exact OpenAPI 3.1 feature behavior requires bake-off |
| R05 | [`json-everything/json-everything`](https://github.com/json-everything/json-everything), [commit tree](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39), [JsonSchema.Net 9.4.0](https://www.nuget.org/packages/JsonSchema.Net/9.4.0), [`OSMFEULA.txt`](https://github.com/json-everything/json-everything/blob/399f198431f65cf6896fe6038f833ef6d0b27a39/OSMFEULA.txt) | Package and commit 26 Jul 2026; `399f198431f65cf6896fe6038f833ef6d0b27a39` | Active System.Text.Json JSON Schema implementation/test integration; material binary-maintenance-fee terms requiring review | Research is not legal advice; conformance does not prove resource/privacy/security fitness; runtime selection remains experimental |
| R06 | [`corvus-dotnet/Corvus.JsonSchema`](https://github.com/corvus-dotnet/Corvus.JsonSchema), [release `5.2.10`](https://github.com/corvus-dotnet/Corvus.JsonSchema/releases/tag/5.2.10), [commit tree](https://github.com/corvus-dotnet/Corvus.JsonSchema/tree/a67f993cecd7b64eec7f8e4bd6e540555b91bfd2) | Jul 2026; `a67f993cecd7b64eec7f8e4bd6e540555b91bfd2` | Active Apache-2.0 JSON Schema source generation, tests, benchmarks and specification-suite submodules | UAM must prove deterministic generation, strict-profile behavior, diagnostics, resource use and supported targets; exact release/commit mapping should be captured by package provenance at execution |
| R07 | [`json-schema-org/JSON-Schema-Test-Suite`](https://github.com/json-schema-org/JSON-Schema-Test-Suite), [commit tree](https://github.com/json-schema-org/JSON-Schema-Test-Suite/tree/c7257e92580678a086f0b9243a1903ed88bd27f7) | 22 Apr 2026; `c7257e92580678a086f0b9243a1903ed88bd27f7` | Official language-neutral Draft 2020-12 conformance vectors; MIT | Not a security/fuzz/resource/application-semantic suite; optional and remote-reference cases require explicit UAM policy |
| R08 | [`cyberphone/json-canonicalization`](https://github.com/cyberphone/json-canonicalization), [commit tree](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0) | 13 Dec 2024; `19d51d7fe467d4706a3ff08adf8a748f29fc21e0` | Apache-2.0 multi-language JCS examples/test data for differential vectors | Older activity; example implementations are not a signing-security assurance. RFC 8785 remains normative and production implementation needs review |

## 15.5 Source interpretation rules

- A standards document supports **documented capability or syntax**, not UAM-specific fitness, safety, performance, legal approval, or operational competence.
- A current release page proves a release existed on the research date, not that it will be supported when implementation executes. Execution must pin and recapture exact versions.
- Repository activity, tests, licenses, and security fixes are inputs to suitability, not popularity-based approval.
- A supplied baseline fact is accepted for this research but does not replace its prerequisite proof gate or human authority.
- Where source behavior and UAM policy differ, the stricter UAM profile is intentional and must be tested. Any future relaxation requires an ADR, threat review, compatibility impact, and falsifying experiment.

---

# 16. Confidence table for every major conclusion

Confidence expresses the strength of the research conclusion, not the probability that an unbuilt implementation will work. A **High** research confidence still requires the specified CLI/lab evidence.

| Major conclusion | Confidence | Evidence and reasoning | What would materially change the conclusion |
|---|---|---|---|
| Every security/privacy/process/persistence/release/organizational boundary needs a separately named and owned contract | High | Accepted invariants are boundary semantics; explicit ownership, limits and rejection create testable containment; no credible simpler alternative preserves all required review points | A prototype demonstrates that fewer boundaries preserve privacy, realm, custody, rollback and independent release invariants with less coupling and equivalent evidence |
| Initial wire representation should be strict UTF-8 JSON | High | Mature standards, accepted .NET family, inspectability, broad tooling, and absence of an approved failed resource budget | Reproducible JSON/gzip tests exceed approved endpoint/server/network/storage budgets while a candidate encoding passes with acceptable migration/tool/security cost |
| `UAM-JSON-1` should reject duplicate, unknown, wrong-case, invalid-null and over-limit input by default | High | RFC interoperability concerns, documented parser controls, privacy-field expansion risk, parser differential threats and deterministic contract behavior | A named consumer cannot comply and a bounded explicit compatibility mechanism proves equivalent security/privacy semantics; or selected runtime cannot enforce strictness safely |
| Forward extension should occur only at named, namespaced, bounded extension points, with no generic bag in privacy-bearing events | High | Generic extension bags bypass schema review, minimization and compatibility analysis; strict closed events make field growth visible | A concrete extension use case cannot be represented through versioned typed fields and proves an allowlisted extension profile with field-level privacy authorization and old-reader behavior |
| JSON Schema Draft 2020-12 should define JSON instance shape | High | Stable primary specification, official conformance suite and multiple active .NET implementations | Required semantics cannot be represented without unsafe custom vocabulary, or implementation bake-off shows no supportable validator meets conformance/resource/security needs |
| OpenAPI 3.1.2 should describe initial HTTP APIs rather than adopting 3.2 immediately | Medium | 3.1.2 aligns with Draft 2020-12 and has more established reviewed tooling; 3.2 exists but tool-chain fitness is unproved | Pinned OpenAPI 3.2 validators, diff and generators pass all UAM fixtures and provide a needed feature with no migration regression |
| A UAM normative companion specification is required beyond schemas/OpenAPI | High | Receipt meaning, authenticated context, privacy state, transaction boundaries, rollout, support and human authority are not fully captured by instance schemas | A formal language/toolchain is proven to encode and execute all these semantics without adding disproportionate complexity; prose would still be needed for governance and threat context |
| Git-backed immutable catalogue and local bundles are preferable to a runtime registry initially | High | No measured runtime discovery need; local bundles satisfy coordinated deployment and remove an online control service/attack surface | Independent release/governance measurements show bundles cannot meet an approved objective, and a registry security/operations/restore benchmark passes |
| Runtime schema/reference fetching must be prohibited | High | Removes SSRF, mutable dependency, availability and downgrade paths; all required schemas can ship in a bundle | A formally authorized dynamic ecosystem requires runtime discovery and can prove authenticated, pinned, bounded, cached, revocable resolution without privacy/availability regression |
| Contract versions should be immutable `MAJOR.MINOR.PATCH`, with patches instance/semantic neutral | High | Familiar unambiguous vocabulary; supports machine gates; protects deployed interpretation | A different version model better represents a named integration’s evolution and preserves all matrix/rollback/deprecation evidence; internal build numbers remain insufficient |
| Consumers must roll before producers for changes not already accepted by all old readers | High | Strict unknown-field behavior makes producer-first “additive” changes unsafe; consumer-first preserves rollback | Every required old reader is proven to accept a self-describing new representation without semantic/privacy ambiguity, or negotiated exact-version routing removes exposure |
| Current/previous major is a conservative temporary internal window | Medium | One rollback generation bounds complexity while tolerating skew | Measured long-offline/rollout distribution, support cost, emergency response, or external commitment requires broader/narrower support; human authority decides |
| Retirement must be evidence-based and explicitly approved, not automatic by calendar | High | Offline endpoints and unknown external consumers make time alone insufficient; observed producer/consumer inventory is needed | Fleet is proven always-online/atomically upgraded and no external commitment exists, with an approved alternative retirement safeguard |
| Endpoint persistence, server persistence, domain, portal and integration models must be separate | High | Prevents one field change from silently becoming storage/wire/view/privacy behavior; explicit mapping is a review boundary | Measured mapping overhead is material and a generated architecture can enforce the same dependency/privacy separation with formal proof and tests |
| Generated types/code should be boundary-local, pinned, reviewed and tested | High | Active generator projects still exhibit regressions; generation does not prove semantics; output can be compiled and snapshotted | A formally verified generator and toolchain eliminates relevant drift risk and maintains strict architectural dependency controls; review remains prudent |
| Local IPC must negotiate exact versions and bind access to Windows session/logon identity with explicit ACLs | High for the design; Low for implementation proof | Platform docs support explicit DACL/logon SID controls; accepted architecture makes sessions a boundary. No UAM lab result exists yet | G1 lab demonstrates a different Windows primitive is safer/simpler, or named pipes cannot meet multi-session/VDI requirements; then open a baseline change ADR |
| Raw source candidates must remain inside the restricted user/session process and only minimized output may cross Coordinator IPC | High | Direct accepted privacy invariant and process topology; prevents machine service/log/DB exposure | New primary evidence proves an approved source cannot be minimized inside the user boundary and a safer alternative preserves the ceiling; requires explicit baseline change proposal |
| Event plus source-progress cursor must commit atomically under one writer | High for architecture; Low for runtime proof | Accepted non-negotiable invariant and at-least-once design; transaction model is clear | G5 fault injection fails under selected SQLite/runtime/filesystem behavior, requiring transaction/outbox redesign and migration ADR |
| Batch identity plus content digest and central uniqueness should make retries idempotent; same ID/different content must conflict | High | At-least-once requires stable identity; conflict detection prevents equivocation/corruption from being mistaken for replay | A different idempotency construction proves one final effect across retries, restore and concurrency with lower risk/cost |
| A receipt must be issued only after durable inbox commit and mean custody only | High for semantics; Low for engine/failure-domain proof | Accepted baseline explicitly distinguishes custody from semantic acceptance/visibility; state model and transaction boundary are precise | P09 fault injection or engine/HA topology shows commit/ACK ordering cannot meet the declared failure domain; then receipt semantics or infrastructure must change via ADR |
| Unsupported envelope/media/compression/major versions should be rejected before receipt | High | Server cannot safely promise custody for content outside its declared parser/storage/support capability; prevents unbounded poison retention | A bounded raw-custody service with independent retention/security/replay mandate is approved and proves durable handling of unknown formats |
| Full post-custody semantic failures should quarantine, not retroactively invalidate the receipt | High | Preserves truthful custody and separates durable receive from processing; poison handling remains observable | Human policy requires all-or-nothing semantic acceptance and synchronous validation meets SLO/failure budgets without premature ACK risk |
| Realm and installation identity must derive from authenticated server context, never payload claims | High | Accepted data principle and isolation invariant; payload is untrusted | Authentication architecture changes but still supplies equivalent trusted context; payload-only authority would conflict with baseline and needs new primary evidence |
| Release-authorized privacy ceilings/control artifacts should be signed and monotonic/replay-protected | High for need; Medium for exact JCS/JWS profile | Endpoint must not expand authorized capabilities; standard canonical/signature formats exist; exact key operations are unresolved | Enterprise release system supplies a different authenticated, rollback-safe mechanism that proves equivalent offline verification, rotation and emergency revocation |
| JCS/JWS should initially be limited to signed control artifacts | Medium | Concentrates cryptographic complexity where authorization matters; no approved per-batch non-repudiation requirement | Threat/legal/custody evidence requires origin proof beyond TLS, and per-batch signing/key operations pass cost/recovery/privacy tests |
| `Content-Digest` should protect representation integrity but not be treated as identity, authorization or custody | High | RFC 9530 semantics and cryptographic separation; server transaction/authentication provide other properties | None expected absent a new standard; algorithms/profile may change under security policy |
| Problem Details plus stable UAM machine codes should define HTTP errors | High | RFC standard supports structured errors; stable codes serve retries/runbooks while safe details prevent leaks | A transport or integration cannot use RFC 9457 and a mapped error envelope provides equivalent semantics; machine catalogue remains necessary |
| Metrics need an allowlisted low-cardinality label set; identifiers/raw values belong only in controlled evidence | High | Prevents privacy leakage and metric-cardinality denial of service; IDs are not needed as metric dimensions | Measured support need requires a bounded additional label with approved classification/cardinality and platform capacity evidence |
| Compatibility observability is required before version retirement | High | Without observed producer/consumer/reject/quarantine coverage, retirement is guesswork | A deployment mechanism proves complete atomic fleet replacement and no replay/restore/external path can produce the old version |
| Quarantine must be a governed state with bounded metadata and audited reprocessing | High | Separates poison handling from normal visibility and prevents silent mutation/drop; accepted state distinction | A different workflow proves equal custody, privacy, audit, replay and cleanup properties with lower operational cost |
| Deletion needs versioned tombstone/application-state/evidence contracts and restore ordering | High for structure; Low for approved semantics/runtime proof | Accepted restore/deletion invariant and state separation require monotonic authority and evidence; exact scope/retention are unknown | Governance selects different legal/operational semantics, or P16 shows the proposed state model cannot prevent resurrection in selected backup/integration topology |
| External integrations must use narrow consumer-specific server adapters, not internal DTOs/DB access | High | Accepted governed-integration boundary; prevents endpoint/privacy/storage coupling and supports per-consumer commitments/deletion | A common external standard is approved and proves all consumers share semantics, privacy, realm, deletion and lifecycle without internal model exposure |
| Consumer-driven contracts are optional supporting tests, not the normative authority | High | Consumer examples cannot authorize collection or override security/privacy; direct schema/matrix tests cover internal boundaries | A named external ecosystem formally mandates CDC as its commitment mechanism; UAM invariants still remain provider constraints |
| Third-party validators/generators/diff/canonicalizers must be replaceable pinned dependencies | High | Reviewed tools have differing coverage, regressions, native surfaces and license/security concerns; adapters bound lock-in | A platform-owned supported component becomes an approved standard with contractual support and still should be pinned/tested |
| Binary encoding must remain measurement-gated | High | No representative distribution or approved failed budget exists; JSON/gzip is simpler and inspectable | P11/P12 plus approved budgets prove JSON materially unfit and a binary prototype passes end-to-end compatibility/security/operations gates |
| Applicable admin/portal contract-failure workflows should target WCAG 2.2 AA and retain stable machine codes independent of localized text | Medium | Current W3C standard and operational need for accessible errors/status; exact portal scope/locales are unknown | Product/accessibility authority selects a different conformance scope/level based on applicable obligations and user research; critical accessibility remains required where applicable |
| Proposed numerical caps are safe only as bootstrap fail-closed hypotheses | Medium for fail-closed direction; Low for exact values | Bounded allocation/compression is necessary, but representative rates/sizes and approved budgets are missing | P01–P12 and metadata-safe measurements justify replacements; any cap that rejects valid approved use must be revised through version/rollout analysis |
| This result does not require a baseline architecture change | High | Recommendations implement the allowed accepted decisions and preserve their invariants; no current primary source showed a material contradiction | Any early gate fails and new primary evidence shows an accepted decision cannot meet its stated invariant; then file the required explicit change proposal/ADR |

## 16.1 Residual risk

The proposed architecture contains risk; it does not eliminate it.

### Unsafe or unproved through research alone

- **Windows isolation remains unproved.** Named-pipe DACL, token, logon SID, process identity, service restart, pipe squatting, RDS/VDI and partial-upgrade behavior require G1 lab evidence. A documentation-correct ACL can still be incorrectly assembled or checked.
- **Privacy containment remains unproved.** A field can escape through exception messages, heap/crash capture, third-party instrumentation, generated `ToString()`, temporary files, test evidence, or a later adapter. G4 synthetic canaries and recurring static/runtime fitness tests are required.
- **Crash/durability semantics remain unproved.** SQLite, filesystem, database, connection, process and power-failure behavior must be fault-injected. Research cannot certify that a selected HA database topology’s “commit” matches the declared custody failure domain.
- **Parser and canonicalization agreement remains unproved.** Duplicate names, Unicode, numbers, normalization assumptions, limits, compression and schema edge cases can produce different interpretations across endpoint, server, generator, validator, signature and support tools.
- **Deletion cannot be proved complete from schema alone.** Backups, replicas, caches, exports, integrations, evidence stores and disaster recovery can resurrect or retain data. Exact deletion scope and legal proof are human decisions.
- **An authorized bad decision remains possible.** A validly signed privacy ceiling, policy, contract or release can still authorize an inappropriate field, source, destination or use. Cryptography proves provenance, not lawfulness or wisdom.
- **Offline emergency control is limited.** A compromised or obsolete endpoint that cannot reach the service cannot receive a new kill/block policy. Release expiry, local deny defaults and enterprise deployment controls reduce but do not remove this risk.
- **External behavior is not under UAM control.** A named consumer may retain data, mis-handle deletion, deploy an incompatible reader, or violate its commitment. The adapter can contain exposure and stop delivery; it cannot prove downstream conduct.
- **Clock and identifiers are fallible.** UTC syntax and UUIDv7 do not prove wall-clock accuracy, event ordering, uniqueness implementation quality, or subject identity. Contracts must carry quality/provenance and avoid forensic certainty claims.

### Operational and cost risk

- Strict rejection produces visible outages instead of silently accepting drift. This is intentional, but it requires on-call ownership, version inventory, evidence-safe diagnosis, kill/freeze controls and practiced rollback.
- Current/previous-major readers, dual write/read periods, replay fixtures and restore compatibility increase code and test surface. Supporting more offline generations increases this cost nonlinearly.
- Golden vectors, mutation tests, full old/new matrices, fuzz/resource tests, accessible admin flows, deletion/restore drills and dependency reviews are ongoing work, not one-time foundation tasks.
- A local catalogue avoids registry operations but places discipline on Git review, immutable publication, bundle distribution, branch protection, ownership continuity and emergency release mechanics.
- Source generation may reduce runtime cost while increasing build complexity and upgrade sensitivity. Dynamic validation may simplify publication while increasing runtime allocations and attack surface. The bake-off must include available team skills and supportability, not throughput alone.
- Third-party terms can change. `JsonSchema.Net` package terms need explicit legal/procurement resolution; every dependency requires a patch owner and replacement path. No repository review guarantees future maintenance.
- Provisional size/cardinality/time limits may be too low for an approved use or too high for hostile inputs. Changing them can itself be a compatibility and resource-risk event.
- Human-readable errors and status interfaces need localization/accessibility work while logs/evidence need privacy controls. Stable machine codes reduce, but do not remove, this dual maintenance burden.

### Human-dependent unknowns

The following remain unresolved and cannot be approved by this research: business meaning and privacy classification of fields; legal purpose and prohibited uses; identity level; retention and deletion scope; access; employee consultation; SLO/RPO/RTO; budget; compatibility duration; rollout and long-offline policy; external consumer commitments; signing/key authority; production support ownership; acceptable risk; and production deployment.

## 16.2 Next stop/go gate

**NEXT GATE — Primary contract-integration gate. Current state: `STOP`.** This research result defines the gate; it does not execute or pass it.

A specific component integration may receive `GO` only when all of the following are true for every contract it crosses:

1. the contract has an immutable name/version/schema ID and catalogue entry;
2. accountable semantic, boundary, compatibility, support, privacy/security and release functions are named;
3. source and destination trust/privacy states and authenticated context are explicit;
4. hard or clearly marked provisional size/depth/count/time/compression/cardinality limits are machine-enforced;
5. field presence/nullability, numeric/time/identifier, unknown/duplicate/reserved-field and extension behavior are normative;
6. accepted and rejected behavior has stable privacy-safe error codes and retry classification;
7. producer/consumer versions, rollout order, rollback path, freeze/kill behavior, deprecation and unsupported-schema handling are declared;
8. schema lint, official conformance cases, UAM golden/canonical vectors, adversarial/fuzz/resource tests and generated-code checks pass;
9. every required old/new producer-consumer pair and rollback sequence passes with pinned artifact hashes;
10. dependency licenses, security posture, transitive packages, provenance and exact revisions are approved and reproducible;
11. observability stays within the approved privacy and metric-cardinality profile, with actionable runbooks;
12. synthetic/sanitized evidence is complete, hashed, reproducible, cleaned up and contains no secret, internal address/URL, personal data or raw activity;
13. applicable earlier proof gates are passed in order—at minimum G1 session/IPC isolation, G4 privacy transformation/canary containment and G5 event/cursor crash invariant for the endpoint slice, plus durable-inbox/idempotency/poison evidence for endpoint-to-server integration;
14. JSON/plain and JSON/gzip have been measured before any binary proposal;
15. relevant realm-isolation, deletion/restore, audit and accessibility tests pass; and
16. unresolved human decisions are either approved by the accountable authority or explicitly block the contract from `active` status.

**GO authorizes only the stated synthetic or implementation integration scope.** It does not approve real employee activity, production retention, external commitments, production capacity, legal basis, SLO/RPO/RTO, or production deployment. Any failed criterion leaves the decision at **`STOP`**, records the failure evidence, contains/cleans up the experiment, and opens or updates the applicable ADR before dependent work resumes.
