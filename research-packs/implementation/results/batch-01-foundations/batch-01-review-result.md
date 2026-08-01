# Batch 01 review result — immediate pre-implementation foundations

**Result path:** `results/batch-01-foundations/batch-01-review-result.md`  
**Review date:** 31 July 2026  
**Decision status:** **ACCEPT WITH MANDATORY CONDITIONS**  
**Authority boundary:** implementation-foundation architecture review; **not** legal, privacy, budget, licensing, staffing, risk-acceptance, pilot, or production approval  
**Primary batch gate:** accept the G0 data contract, G1 blueprint, contract rules, application identity model, privacy ceiling, and repository boundaries before production-shaped endpoint code  
**Immediate permission:** repository scaffolding, pure contract/model code, fictional fixtures, offline validators, test oracles, decision templates, disconnected Windows-lab preparation, and hostile synthetic prototypes after their prerequisites  
**Immediate prohibition:** live-source collection, production or organization-derived activity, production-shaped endpoint integration, production credentials, production signing, production deployment, or bypass of the ordered G0–G5 proof gates

## Evidence vocabulary

This result uses the required labels:

- **FACT** — directly supported by an allowlisted supplied result or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proved.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, business, or production authority is required.
- **CLI EXPERIMENT** — code, lab work, or measurement must establish the claim.

Normative `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` statements are the consolidated Batch 01 implementation baseline proposed for ADR acceptance. They do not convert any **HUMAN DECISION** into a technical approval.

## Evidence boundary and file-presence record

**FACT.** All nine allowlisted project files were present. No missing-file substitution was required. This review did not use another Project file.

| Ref | Allowlisted file | SHA-256 of reviewed attachment | Use in this review |
|---|---|---|---|
| I01 | `01-g0-dummy-data-test-oracle-result.md` | `0e2cfb7320d97cc784a032636513c35bcf6974372aa9974bbc5df143a351e3ca` | G0 tiers, deterministic package, oracle, canaries, tests, proposed IDs and dependencies |
| I02 | `02-g1-windows-runtime-ipc-result.md` | `2da27adabb4038f06c3db95ac2699ea77e88abd8d96a31025416a8908c535ea1` | Windows process topology, launch, identity, named pipes, Task Host, hostile proof plan |
| I03 | `03-contract-versioning-result.md` | `34d6284fc2dd46cdf1af479cc8e2fb53510fa48f236f5b19597ab13788d31967` | strict contract profile, catalogue, compatibility, receipt and rollout rules |
| I04 | `04-application-registry-matching-result.md` | `c677fbaa1a0e3d3d7b5d2f5c3e0c2fc1868bb926d1a6e4fb10a95295d90ea6a5` | application identity, aliases, rule grammar, conflict analysis and snapshots |
| I05 | `05-privacy-ceiling-tenant-policy-result.md` | `55966752695939f0c9efe110338b55fcad80739936a0ab1f10f62b280e9cefc2` | typed privacy lattice, candidate failure handling, permits and signed artifacts |
| I06 | `06-repository-build-ci-result.md` | `07f23bad9fcb13b897a365e6c2a32b8a082b04d3ce000f267d7ccfa34a3ba116` | monorepo, dependency graph, CI trust zones, reproducibility, SBOM and provenance |
| I07 | `00-accepted-baseline-attachment.md` | `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a` | accepted baseline and non-negotiable invariants |
| I08 | `05-decisions-contradictions-and-gates.md` | `ed67d887f2a825737f0575cd768cc311aa407392869d68c075b6e1da8f4c6b7a` | accepted decisions, resolved tensions, ordered proof gates and stop rule |
| I09 | `06-research-evidence-rules.md` | `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | evidence quality, human authority and conflict-handling rules |

---

# 1. Executive batch verdict and residual risk

## 1.1 Verdict

**RECOMMENDATION — ACCEPT WITH MANDATORY CONDITIONS.** The batch has enough agreement and evidence to accept the following six architectural foundations:

1. **G0:** a classified, deterministic, fictional-first data package with an independently owned truth oracle;
2. **G1:** the three-context Windows blueprint and its least-authority, session-bound, named-pipe security intent;
3. **Contracts:** separately owned, strict, bounded, versioned contracts with consumer-first rollout and narrow receipt semantics;
4. **Application identity:** UAM-owned immutable application identity, source-qualified external references, a closed matcher grammar, deterministic ambiguity, and minimized endpoint snapshots;
5. **Privacy control:** a release-owned finite privacy ceiling with formally monotonic tenant narrowing and fail-closed evaluation;
6. **Repository/release:** a governed monorepo with hard deployable/module boundaries, exact dependency inputs, hostile CI trust zones, reproducibility evidence, separate signing authority, and same-digest promotion.

**INFERENCE.** These conclusions agree because each protects a different layer of the same accepted invariants: G0 makes claims testable; G1 preserves machine/session/process authority; contracts prevent semantic drift; application identity prevents catalogue labels from becoming authority; the privacy lattice prevents tenant broadening; and repository controls prevent build-time erosion of those boundaries. No majority vote is needed: the conclusions are mutually reinforcing and consistent with I07–I08.

## 1.2 What this verdict authorizes

**RECOMMENDATION — GO** for the following immediate work:

- create the governed monorepo and architecture tests;
- create the contract catalogue, strict parser profile, schemas, golden and invalid vectors;
- create deterministic fictional UUID, time, application, realm, session and catalogue-shape seeds;
- implement the G0 generator, independent oracle, truth ledger, canary registry and all-sink scanner using T1 data;
- implement pure application-registry identity/revision models and URL-host matcher/analyzer using fictional inputs;
- implement the pure privacy-lattice reference evaluator, policy state machine and unsigned canonical artifact model;
- prepare ADR and human-decision templates;
- prepare, but do not connect to, the Windows lab; generate inventory and evidence scripts containing placeholders only;
- after the contract/identifier/permit prerequisites in this review are accepted, build a **synthetic hostile G1 prototype** with no real collector and no live source.

## 1.3 What this verdict does not authorize

**RECOMMENDATION — STOP** before any of the following:

- production-shaped Coordinator/User Host/Task Host integration before the consolidated contracts and G1 hostile gate pass;
- live Edge acquisition before G2;
- real profile/source-generation/cursor use before G3;
- any production-derived or organization-shaped activity before governance approval and G4 canary containment;
- a production signing key, production PKI, production deployment, pilot, or production promotion;
- process matching, URL-path matching, filename matching, person/role targeting, or role-to-application mapping;
- an external broker, runtime schema-registry service, general endpoint policy engine, arbitrary plug-in/script channel, or autonomous updater;
- treating any proposed numeric limit, exact SDDL, exact patch number, crypto algorithm, version window, or repository tool as accepted without its named evidence.

## 1.4 Conditions for closing the Batch 01 gate

The batch gate is closed only when all of the following are true:

| Gate condition | Classification | Required evidence | Stop condition |
|---|---|---|---|
| B01-G0 | **CLI EXPERIMENT** | deterministic package generated twice from a clean checkout; byte-identical roots; truth reconciliation; mutation detection; canary positive controls; cleanup evidence | any nondeterministic canonical byte, oracle mutation survivor in a mandatory invariant, mandatory canary miss, unclassified input, or undeletable artifact |
| B01-CONTRACT | **CLI EXPERIMENT** | strict parser, official JSON Schema 2020-12 suite subset, UAM invalid vectors, UUIDv7 vectors, field-specific Unicode vectors, executable compatibility matrix | duplicate/unknown member accepted where forbidden, remote reference resolved, unsupported version silently coerced, identity/time semantic mismatch |
| B01-POLICY | **CLI EXPERIMENT** | monotonicity, meet laws, rollback-as-higher-revision, candidate classification, expiry/clock and realm-negative tests | any tenant broadening, wrong-realm activation, lower revision accepted, invalid active artifact authorizing work, or expired authority collecting |
| B01-REGISTRY | **CLI EXPERIMENT** | 173-row wholly fictional shape; external refs non-authoritative; URL-host normalization; overlap/shadow/ambiguity witnesses; realm-negative tests | name/external reference becomes primary identity, cross-target tie is guessed, real value appears, cross-realm relation succeeds |
| B01-REPO | **CLI EXPERIMENT** | architecture mutations, locked restore/source mapping, secret positive controls, double clean build R2, dependency admission records, SBOM/file reconciliation and provenance-subject checks | forbidden project/package/API mutation passes, untrusted lane gains authority, unexplained build mismatch, scanner misses a required positive control, SBOM/provenance subject mismatch |
| B01-G1 | **CLI EXPERIMENT** | supported-environment inventory; service/task/token/ACL evidence; cross-session and malformed-client campaigns; Task Host containment; lifecycle and cleanup | any cross-session accepted message, Coordinator profile read, prohibited privilege, peer-identity bypass, uncontrolled child/network/write, unbounded hostile impact, or residue |
| B01-OWNERS | **HUMAN DECISION** | accountable owner and support function assigned for every candidate contract, test data, G1 boundary, privacy authority, registry publication, repository/release and incident path | any blocking item remains `UNASSIGNED` |
| B01-ADRS | **HUMAN DECISION** | architecture forum accepts or explicitly rejects the ADR actions in section 9 | unresolved blocker-level contradiction or silent divergence from this result |

## 1.5 Residual risk

**FACT.** Public documentation establishes Windows and standards capabilities, not UAM fitness. Microsoft documents required-service-privilege reduction, restricted service SIDs, interactive group tasks, named-pipe peer process/session queries, and restricted tokens; none proves the proposed composition under the supported estate, GPO, EDR, RDS/VDI, or runtime. [W07–W14]

**UNKNOWN.** The largest remaining risks are:

- G1 process/token/ACL and launch behavior may fail under real enterprise policy;
- the Task Host is fault and resource containment, not protection against all same-user-readable data;
- the final IPC codec, frame, crypto transcript and exact limits are not yet selected;
- signing-key custody, quorum, rotation, revocation, clock and offline policy are not decided;
- the independent oracle may share a conceptual defect with the implementation;
- canary and secret scanners have unknown false negatives;
- URL normalization and Windows process metadata may differ across libraries/platform variants;
- no real capacity, outage, restore, deletion, support-cost or production database evidence exists;
- legal purpose, prohibited uses, fields, precision, retention, access, employee consultation, ownership, staffing, budget, SLO/RPO/RTO and production authority remain human-owned.

**Containment.** The accepted sequence limits exposure by keeping inputs fictional, making every boundary strict and versioned, stopping on early-gate failure, separating oracle from implementation, preventing tenant broadening, requiring real Windows evidence, and separating build, signing and promotion authority.

---

# 2. Accepted decisions and invariants

## 2.1 Accepted baseline carried forward without change

The following are **FACT** from I07–I08 and remain non-negotiable:

| ID | Accepted invariant |
|---|---|
| A-01 | Windows endpoints use a low-privilege machine Coordinator Service, one ordinary-token User Host per eligible interactive session, and short-lived restricted Task Hosts for risky collection. |
| A-02 | The Coordinator does not crawl user profiles, load user profiles, authenticate users, or create user tokens. User-owned sources are read in the user session. |
| A-03 | Task Hosts are fixed release-authorized process boundaries, not arbitrary plug-in, script, command, path, assembly or policy-execution channels. |
| A-04 | C#/.NET is the default implementation family. Exact supported patches and fast-moving dependencies are selected and recorded at execution time under lifecycle policy. |
| A-05 | A release-authorized product privacy ceiling limits sources, fields, transformations, destinations and capabilities. Tenant policy may only narrow it. |
| A-06 | Minimization occurs before Coordinator IPC, durable endpoint storage, logs, diagnostics or transport. Endpoints never receive central database credentials or submit SQL. |
| A-07 | SQLite WAL with one writer stores minimized events and source progress atomically. A cursor never advances ahead of the durable minimized events or approved progress facts it represents. |
| A-08 | Delivery is at least once; stable event/batch identities and central uniqueness make the final business effect idempotent. |
| A-09 | Uploads are bounded, versioned, authenticated, compressed HTTPS batches. A receipt means durable custody in the declared failure domain, not semantic acceptance, materialization, integration or portal visibility. |
| A-10 | The initial server is a modular monolith with an ingestion boundary, relational durable inbox, leased workers, typed facts/aggregates, control API/BFF and governed integrations. |
| A-11 | No external broker is the default. It requires measured failure-domain, throughput, replay, fan-out or cost evidence. |
| A-12 | PostgreSQL is the target reference; SQL Server remains a serious transition/fallback candidate. Production selection requires an identical benchmark plus restore, operations, skills, licensing and support evidence. |
| A-13 | MSI and enterprise deployment own the stable privileged boundary. Any autonomous updater is optional, minimal, repository-authorized, rollback-safe and separately justified. |
| A-14 | The first functional slice is Edge browser history at site/domain-level minimized output using synthetic data until governance permits otherwise. |
| A-15 | UAM telemetry is fallible operational evidence, not sole forensic proof and not an employee-productivity score. |
| A-16 | One user, session or realm cannot submit, view, mutate or delete as another. Realm/device authority comes from authenticated context, not payload claims. |
| A-17 | A privileged mutation cannot succeed without durable audit evidence. |
| A-18 | An unauthorized, incomplete, stale, frozen or downgraded release never executes. |
| A-19 | No component silently drops unacknowledged data under pressure. |
| A-20 | Restore does not lose acknowledged events and does not make deleted data visible before deletion state is ready. |

No accepted-baseline change proposal is raised by this review.

## 2.2 Accepted Batch 01 refinements

### 2.2.1 G0 data and oracle

- **RECOMMENDATION — ACCEPT.** Every dataset is classified as T1 fictional committed, T2 sanitized organization-shaped, or T3 controlled measured evidence. Classification follows the most sensitive parent.
- **RECOMMENDATION — ACCEPT.** T3 collection is disabled by default. A T3 request requires approved question, fields/aggregation, owner, access, expiry, deletion and no-raw-value evidence.
- **RECOMMENDATION — ACCEPT.** The canonical test package is reviewable JSON/NDJSON with JSON Schema 2020-12, content digests and generated ephemeral SQLite/source fixtures. Committed SQLite binaries are not canonical.
- **RECOMMENDATION — ACCEPT.** A separately owned pure oracle produces a truth ledger before execution and does not call production transformation, identity, cursor, dedupe, receipt, policy or materialization logic.
- **RECOMMENDATION — ACCEPT.** Truth covers successful and zero-effect outcomes: accepted, rejected, deferred, duplicate, quarantined, received, validated, materialized, visible, cursor and deletion/restore states.
- **RECOMMENDATION — ACCEPT.** Exact fictional canaries and schema-aware sink checks are mandatory; general secret/PII tools are secondary.
- **RECOMMENDATION — ACCEPT WITH CORRECTION.** The safe catalogue shape may be recreated with 173 wholly fictional rows and the reported quality counts. No raw label or external reference may be copied and no role, owner, purpose, rule, entitlement or usage may be inferred.

### 2.2.2 Contract and scalar profile

- **RECOMMENDATION — ACCEPT.** Every process, persistence, HTTP, administrative, deletion and external-integration boundary has a separately named and owned contract with exact version, trust/privacy stage, limits, rejection, compatibility, rollout, runbook and vectors.
- **RECOMMENDATION — ACCEPT.** The initial JSON profile is strict UTF-8: no BOM, duplicate members, wrong case, comments, trailing commas, implicit defaults, unknown members outside an explicit bounded extension point, invalid nulls, unbounded values, remote references or polymorphic type names.
- **RECOMMENDATION — ACCEPT.** JSON Schema Draft 2020-12 is the structural schema dialect. OpenAPI 3.1.2 is the initial HTTP tool profile pending the tool matrix; it is not claimed to be the newest OpenAPI version.
- **RECOMMENDATION — ACCEPT.** Build and runtime validators resolve pinned local bundles only. No schema is fetched from the network.
- **RECOMMENDATION — ACCEPT.** Consumers deploy before producers; compatibility is established by executable old/new matrices and semantic/security/privacy rules, not schema-diff output alone.
- **RECOMMENDATION — ACCEPT.** Receipt, validation, quarantine, materialization and visibility remain different contracts/states.
- **RECOMMENDATION — ACCEPT.** New UAM domain/wire identifiers use canonical lower-case UUIDv7; external identifiers are typed opaque references; SHA-256 remains the artifact/content digest. UUID time bits are not business time, authorization, evidence precision or source ordering.
- **RECOMMENDATION — ACCEPT.** Time is explicit UTC plus separately declared precision where precision matters. Exact production precision remains a human privacy/business decision.
- **RECOMMENDATION — ACCEPT.** Unicode normalization is field-specific. JCS preserves parsed strings as-is; it does not globally normalize them. A fictional generator may define NFC for its own controlled vocabulary, but that rule is not silently applied to every production field.

### 2.2.3 G1 Windows blueprint

- **RECOMMENDATION — ACCEPT AT BLUEPRINT LEVEL.** The Coordinator, launcher, User Host and Task Host responsibilities and trust boundaries are accepted.
- **RECOMMENDATION — ACCEPT AS PROTOTYPE HYPOTHESIS.** `LocalService`, a restricted service SID and an SCM required-privilege list beginning with only `SeChangeNotifyPrivilege` are the first configuration to falsify. The effective token, not the requested configuration, is the gate.
- **RECOMMENDATION — ACCEPT AS PROTOTYPE HYPOTHESIS.** An MSI-owned `INTERACTIVE` group Scheduled Task with least privilege starts a small ordinary-token launcher; the launcher creates the protected User Host in the same logon session. The service does not create the token.
- **RECOMMENDATION — ACCEPT.** Local IPC uses a two-stage named-pipe design: a tightly bounded bootstrap and a fresh one-use exact-logon-SID handoff pipe. Both peers validate kernel-reported process/session identity and protected release identity; payload identity claims are never authoritative.
- **RECOMMENDATION — ACCEPT.** The Coordinator does not use named-pipe client impersonation as the normal identity path and must not retain `SeImpersonatePrivilege` merely for convenience.
- **RECOMMENDATION — ACCEPT.** Task Host is a fixed capability with a restricted token, low integrity where compatible, one-process Job Object, explicit handles, bounded resources, private scratch and network denial. It is not an arbitrary-code sandbox or complete same-user confidentiality boundary.
- **RECOMMENDATION — ACCEPT.** A Coordinator schedule message is a `RunIntent`, not final source-read authority. The User Host independently validates session and effective policy and issues a one-use, short-lived `CollectionPermit` to the fixed Task Host. Task Host output must bind to that permit.
- **RECOMMENDATION — ACCEPT WITH DEFERRAL.** Physical frame layout, JSON versus CBOR, exact HMAC transcript, buffer sizes, timeouts and quotas remain a protocol ADR/CLI gate. The two-stage transport and identity state machine are accepted independently of codec.
- **RECOMMENDATION — ACCEPT WITH DEFERRAL.** Literal SDDL, access masks, service/task XML and process mitigations are expected configurations, not accepted runtime facts until effective-access and hostile lab evidence passes.

### 2.2.4 Application registry and matching

- **RECOMMENDATION — ACCEPT.** Every application has a UAM-owned immutable, realm-scoped UUIDv7. It is not derived from a name, alias, external reference, URL, process, owner, category or observed use.
- **RECOMMENDATION — ACCEPT.** External references are optional, source-qualified claims with source-defined comparison/uniqueness. Missing or duplicated values create quality/conflict cases, not automatic merges.
- **RECOMMENDATION — ACCEPT.** Names and aliases support display, search and reconciliation only. They do not identify or match an application.
- **RECOMMENDATION — ACCEPT.** Rules use a closed versioned grammar. No arbitrary regular expression, wildcard language, script, general policy engine, fuzzy classifier or first-match order is permitted.
- **RECOMMENDATION — ACCEPT.** After priority and provable specificity, equally maximal rules for different applications produce `AMBIGUOUS` with no application assignment.
- **RECOMMENDATION — ACCEPT FOR FIRST SLICE.** The only executable matcher family in Batch 01 is synthetic HTTP(S) exact/suffix host matching. URL paths and all process families are compiled off pending privacy, security and Windows evidence.
- **RECOMMENDATION — ACCEPT.** A realm snapshot is immutable, minimized, signed/authorized, sequence-monotonic and contains opaque application/rule identifiers and compiled predicates only. It excludes names, aliases, owners, categories, sensitivity, external keys and raw observations.
- **RECOMMENDATION — ACCEPT.** Rollback republishes previously approved semantics at a higher sequence; sequence never decrements.

### 2.2.5 Privacy ceiling and policy

- **RECOMMENDATION — ACCEPT.** The effective policy is the meet/intersection of product ceiling, tenant policy, emergency narrowing, local safety disablement and runtime availability. An undecidable relation fails closed.
- **RECOMMENDATION — ACCEPT.** Tenant policy can only select release-owned identifiers and narrower bounds; it cannot supply executable logic, addresses, paths, regexes, SQL, scripts, transforms, algorithms or new destinations.
- **RECOMMENDATION — ACCEPT.** An ordinary malformed or unsupported candidate does not replace an unexpired active last-known-good policy and grants no new permit. A signature, key, realm, rollback, same-revision-content, chain or broadening failure enters `SafetyHold`. An absent, corrupt, expired or unrelated active authority disables collection.
- **RECOMMENDATION — ACCEPT.** Policy rollback is a new higher revision referencing prior semantics. Lower revisions are never accepted as rollback.
- **RECOMMENDATION — ACCEPT.** Product, realm-policy and emergency-narrowing authority are separate. The portal/build/repository cannot alone sign or authorize a broadened policy.
- **RECOMMENDATION — ACCEPT WITH DEFERRAL.** Canonical signed control artifacts, algorithm allowlisting, key-purpose separation, realm/audience binding, expiry and anti-rollback are required. Exact JWS serialization, ES256, threshold/quorum, KMS/HSM, certificate profile and rotation/recovery are provisional.

### 2.2.6 Repository, build and CI

- **RECOMMENDATION — ACCEPT.** Use one governed monorepo during the first slice, with separately built/promoted artifacts and hard dependency rules. Repository unity does not imply runtime trust.
- **RECOMMENDATION — ACCEPT.** Add explicit projects for the User Host launcher and Windows interop. Contract source is codec-neutral until the IPC ADR; no `.proto` placeholder is treated as a decision.
- **RECOMMENDATION — ACCEPT.** No broad `Common`, `Shared`, shared domain DTO or plug-in assembly. Boundary-local generated types/adapters are allowed; domain and persistence types remain separate.
- **RECOMMENDATION — ACCEPT.** Exact SDK, package, analyzer, generator, action, image and tool inputs are locked. Floating versions and mutable action tags are prohibited for release evidence.
- **RECOMMENDATION — ACCEPT.** Untrusted code receives no secrets, internal network, privileged cache, persistent runner, release artifact input, signing or deployment authority.
- **RECOMMENDATION — ACCEPT.** Real disposable/reverted Windows VMs are mandatory for service, session, ACL, MSI, certificate and cleanup claims.
- **RECOMMENDATION — ACCEPT.** Canonical unsigned payloads require two challenged clean builds and byte-identical R2 evidence. Installer container reproducibility is separately proved or bounded by an explicit R3 ADR; unexplained differences stop release.
- **RECOMMENDATION — ACCEPT.** SBOM and provenance are reconciled against the final file manifest and lock graph. A zero-exit tool result is not proof of completeness.
- **RECOMMENDATION — ACCEPT.** Signing is a separately authorized digest-bound operation. Promotion moves the same signed digest through rings; environments do not rebuild it.

---

# 3. Rejected or deferred recommendations

## 3.1 Rejected now

| Recommendation | Decision | Reason |
|---|---|---|
| Copy/subset production activity or row-level “anonymized” activity into tests | **REJECTED** | conflicts with synthetic-first minimization; creates uncontrolled disclosure, lineage and deletion risk; no need is proved |
| Use raw catalogue names or external IDs as fixtures, primary identity or rules | **REJECTED** | allowed evidence proves shape only; names/external refs have no durable authority contract |
| Infer role, owner, purpose, sensitivity, entitlement, usage or matching from names | **REJECTED** | exceeds evidence and human authority; high false-attribution/privacy risk |
| Use G0 custom 160-bit prefixed digest IDs as the production domain/wire identity | **REJECTED FOR PRODUCTION CONTRACTS** | conflicts with the broader contract/registry UUIDv7 profile and interoperability; SHA-256 remains useful for deterministic fixture derivation and digests |
| Apply global NFC normalization to all JSON/wire/signed strings | **REJECTED** | JCS requires string preservation; normalization is field semantics and can alter identity/signatures |
| Make G1 deterministic CBOR and the exact 88-byte header final without comparison evidence | **DEFERRED, NOT ACCEPTED** | conflicts with the strict JSON-first contract result; adds a package/tooling/parser surface; no UAM benchmark or fuzz evidence exists |
| Treat repository `endpoint-ipc/*.proto` as an accepted IDL | **REJECTED** | no protobuf decision exists; it silently preselects a third conflicting codec |
| Ignore unknown fields generally for “forward compatibility” | **REJECTED** | hides typos/privacy expansion and contradicts strict contracts; only explicit bounded namespaced extension points may be tolerant |
| Fix ES256, JWS General JSON and M-of-N threshold as final production crypto | **DEFERRED** | documented capability exists, but enterprise key, compliance, offline, rotation and recovery requirements are unknown |
| Treat literal G1 SDDL, ACL masks, Scheduled Task XML, firewall and privilege lists as proved | **REJECTED AS FACT** | they are implementation hypotheses; supported-environment effective access must be measured |
| Claim Task Host prevents all same-user reads or is a general untrusted-code sandbox | **REJECTED** | restricted ordinary-user processes can still read many same-user-readable resources; arbitrary code remains prohibited |
| Enable URL-path, process signer/path or filename matching in the first slice | **DEFERRED** | privacy authority, source fields, Windows metadata reliability, TOCTOU and operational budgets are unresolved |
| Use a general endpoint policy engine, feature daemon, scripts, regex or tenant-defined transforms/destinations | **REJECTED** | undermines monotonic proof, expands attack surface and risks arbitrary collection/exfiltration |
| Deploy a runtime schema registry initially | **REJECTED** | no runtime-discovery need; adds online authority, parser/import, availability and operational failure domains |
| Share one DTO/domain/persistence/UI model across boundaries | **REJECTED** | couples rollout and lets privacy/persistence/UI concerns leak across trust boundaries |
| Add an external broker by default | **REJECTED** | accepted baseline requires measured trigger evidence |
| Add an autonomous updater by default | **REJECTED** | MSI/enterprise deployment is the accepted privileged boundary; updater requires a separate ADR and gate |
| Treat exact .NET/SQLite/tool patches as timeless architecture | **REJECTED** | lifecycle and advisory state changes; execution-time lock/evidence is required |
| Treat a 6,000-device synthetic smoke test as production capacity proof | **REJECTED AS CLAIM** | count alone omits events, bytes, retries, outage, hardware, query mix, SLO and operations |
| Treat a passing scanner, SBOM generator, schema diff or generated client as the oracle | **REJECTED** | tool-specific blind spots and common-mode defects remain; positive controls and independent reconciliation are required |

## 3.2 Provisional technologies and numeric values

The following remain **ESTIMATE**, **UNKNOWN**, **HUMAN DECISION**, or **CLI EXPERIMENT** rather than accepted architecture:

| Area | Provisional items | Resolution |
|---|---|---|
| IPC | JSON vs CBOR; fixed header; HMAC transcript; HKDF inputs; frame cap; handshake count; timeouts; queues; buffer sizes | ADR-B01-004 plus parser/fuzz/allocation/latency and hostile Windows tests |
| Windows service | `LocalService`, only `SeChangeNotifyPrivilege`, exact service SID type, process/token DACLs, Task XML/triggers, mitigations, firewall merge | supported-environment effective-token/access and lifecycle campaign |
| Task Host | low integrity, `WRITE_RESTRICTED`, unique restricting SID, `CreateProcessAsUser`, memory/CPU/time caps, scratch behavior | token-launch/write/network/child/runtime compatibility experiment |
| G0 | exact package/file limits, seed grammar, generated-store pragmas, canary corpus size, property/fuzz case counts | repository and runtime measurement; mandatory invariants remain fixed |
| Contract limits | 16-depth, 4 KiB strings, 256 KiB IPC, 1/4 MiB upload, 1,000 events, 20:1 compression, header/time limits | synthetic and later T3 metadata-safe measurement plus owner approval |
| Compatibility | current/previous major; current plus one rollback release; deprecation duration; offline window | per-contract evidence and **HUMAN DECISION**; no global window is accepted |
| Policy crypto | JWS profile, algorithm, key format, threshold, KMS/HSM, key overlap, clock tolerance, policy validity | crypto/key-management ADR, lab vectors, incident drill and human authority |
| Application matching | path permission, process fields, publisher profile, path bases, case behavior, snapshot size/expiry | privacy/security decision plus URL/Windows CLI evidence |
| Repository | CI vendor, package mirror, installer tool, SBOM/provenance tool, signing service, portal framework | platform bake-off and human procurement/ownership |
| Runtime versions | exact .NET SDK/runtime, SQLite provider/native source, Windows SDK and dependencies | execution-time lifecycle selection and lock manifest |
| Operational | resource budgets, metric series, retry counts, ring size/duration, SLO/RPO/RTO, retention | measurement plus accountable human decision |

---

# 4. Contradiction register and evidence-quality resolution

## 4.1 Resolution method

Conflicts were resolved by this order:

1. preserve I07–I08 accepted invariants;
2. prefer the rule with the narrower authority and smaller privacy/security surface;
3. distinguish documented platform capability from UAM composition fitness;
4. prefer an explicit versioned contract over an implementation convenience;
5. prefer an independently falsifiable rule over an unmeasured numeric or library claim;
6. where evidence is insufficient, make the disagreement an explicit ADR/CLI gate rather than silently selecting a side.

## 4.2 Register

| ID | Overlap or contradiction | Evidence-quality assessment | Consolidated resolution | ADR/action |
|---|---|---|---|---|
| C-01 | G1 fixes deterministic CBOR + 88-byte frame; contract result chooses strict JSON and measures binary later; repository shows `.proto` placeholder | All are recommendations; no baseline codec exists. G1 has strongest local-security detail, contract result has broader versioning authority, neither has UAM benchmark/fuzz proof | Accept the G1 transport/identity state machine and contract strictness; keep logical IPC contracts codec-neutral. Compare strict JSON and deterministic CBOR. No protobuf assumption. Final codec is blocking before production-shaped IPC | ADR-B01-004; update ADR-G1-006 and repository tree |
| C-02 | G0 uses prefixed truncated SHA-256 IDs; contract and registry use UUIDv7; privacy schemas show UUIDv4 regex | RFC 9562 is a current standards-track source; UUIDv7 has broader cross-component agreement. G0 IDs are useful determinism machinery, not required baseline | New UAM domain/wire IDs are lower-case UUIDv7. G0 deterministically generates valid UUIDv7 under a fixed test clock/seed. SHA-256 is retained for digests and lineage. Update privacy schemas from v4 to v7 | ADR-B01-003; update G0-002 and privacy schemas |
| C-03 | Contract rejects unknown members; G1 reserves unknown CBOR keys; registry text permits some unknown optional fields | Strict rejection best preserves privacy and typo detection. Forward extension can be explicit rather than global | Closed schemas by default. Only a named, namespaced, bounded extension point with declared preserve/drop/reject semantics may tolerate unknowns. No generic extension bag in privacy-bearing IPC, policy, rule, event, audit or deletion contracts | ADR-B01-002; update G1 and registry compatibility text |
| C-04 | G0 NFC-normalizes model strings before JCS; contract says no global normalization; registry normalizes selected display/search fields | RFC 8785 explicitly preserves parsed strings and does not perform Unicode normalization [W02]. Field-specific normalization is the only safe common rule | G0 may define NFC at ingress for its own controlled fictional vocabulary. Production contract fields preserve exact code points unless that field’s semantic contract requires NFC/other handling. JCS never normalizes | ADR-B01-006 |
| C-05 | Privacy result fixes ES256/JWS General and recommends threshold; contract leaves exact signing profile open | Standards prove capability, not enterprise key fitness. Exact algorithm/quorum are security and operational choices | Require canonical signed control artifacts, allowlisted algorithms, key-purpose separation, realm/audience/expiry/anti-rollback and independent verification. Defer exact algorithm, serialization, quorum and key service | ADR-B01-007; update ADR-05.2 |
| C-06 | G1 has `CollectionAssignment`; privacy result requires Coordinator `RunIntent` plus User Host permit | Privacy permit supplies an additional independent enforcement point consistent with accepted user-session authority | Rename/constrain assignment to `RunIntent`. User Host independently evaluates session/policy and issues one-use `CollectionPermit` to Task Host. Coordinator and Task Host both validate output/provenance | ADR-B01-005; update G1 message/state model and ADR-05.6 |
| C-07 | Contract proposes current/previous major; G1 proposes current release plus one signed rollback release | Different contract families have different rollout topology. Both windows are provisional and human-dependent | Version support is per contract family. Co-installed local IPC initially supports current + explicitly authorized rollback compatibility; endpoint/server ingress temporary planning target is current + previous major. Retirement still needs inventory, rollback and owner approval | ADR-B01-012 |
| C-08 | Repository tree omits User Host launcher and includes `.proto`; G1 requires launcher and a protocol project | G1 launch race argument is specific and testable; repository placeholder is explicitly provisional | Canonical tree adds `Uam.UserHost.Launcher` and `Uam.Windows.Interop`; replaces `.proto` with codec-neutral contract source until ADR-B01-004 | update ADR-006-001/002 and scaffold |
| C-09 | G0 says signed-off package; signing details are not decided | “Signed-off” can mean review approval, while cryptographic signing is a separate control | G0 publication requires immutable digest, review/approval evidence and owner. Cryptographic signature is required only where the release/control artifact ADR says so | update G0 manifest wording |
| C-10 | G0 initially recommends Gitleaks v8.30.1 as secondary; repository review identifies a reported positive-control miss in that reviewed release | Direct positive-control failure evidence is more relevant than general project activity | Reject v8.30.1. Future version may be reconsidered only after exact-version mandatory canaries pass. UAM exact/schema-aware scanning remains primary | ADR-B01-010; dependency deny record |
| C-11 | Privacy report reviews FsCheck 3.3.3; G0 reviews newer 3.3.4 | More recent stable tagged release with exact commit is stronger point-in-time evidence | Use 3.3.4 as the only reviewed FsCheck candidate; still test-only and not admitted until package/license/security/provenance gate | dependency record correction |
| C-12 | Contract selects OpenAPI 3.1.2 while OpenAPI 3.2.0 was published 19 September 2025 | 3.2.0 is the current specification [W05], but tool support is not proved | Keep 3.1.2 as the initial **tool profile**, not a claim of latest specification. Run 3.1.2/3.2.0 validator/diff/codegen matrix; update by ADR when support is equal or better | ADR-B01-002 review trigger |
| C-13 | G1 implies `System.Formats.Cbor` is a shared-framework capability | Official package page shows a PackageReference (`System.Formats.Cbor` 10.0.10 at review time) [W06] | Treat CBOR as a separately admitted Microsoft-maintained package/API, not a zero-dependency framework assumption. This strengthens the codec bake-off requirement | update G1 source/dependency claim |
| C-14 | G1 exact SDDL/privileges/task/mitigation language is normative; evidence is documentation only | Microsoft documents primitives but not UAM effective behavior under estate policy | Accept access intent and prohibited outcomes; literal descriptors are candidate vectors. Binary ACL/effective-access and token evidence decide | ADR-B01-013 / G1 lab gate |
| C-15 | Registry allows URL paths/process matching in its broader design; accepted first slice is site/domain Edge | Accepted baseline sets the first slice and exact fields remain provisional | Accept registry model, but compile URL paths/process families off. Only synthetic exact/suffix host matching enters Batch 01 | ADR-B01-008 |
| C-16 | Privacy candidate failure handling might appear inconsistent: fail closed versus keep last-known-good | The privacy report explicitly separates ordinary incompatible candidates from compromise evidence | Preserve that distinction: candidate never grants permission; ordinary malformed/unsupported candidate quarantines without replacing valid active policy; security-significant candidate triggers `SafetyHold`; invalid/expired active authority disables | ADR-B01-009 |
| C-17 | G0 canonical package uses content-derived identifiers; production retries require stable identity across regeneration | Deterministic test identity and production identity are different concerns | Test generator emits deterministic UUIDv7 values; production components mint/persist UUIDv7 according to the owning contract. Tests never infer business time from UUID timestamp | ADR-B01-003 |
| C-18 | Some topic examples include realm/device in payloads while contract baseline derives them from authenticated context | Accepted baseline is explicit | Endpoint-submitted realm/device fields are absent as authority. Test vectors may include hostile claims to prove rejection/ignore behavior. Server stores authenticated binding separately | contract/schema corrections |
| C-19 | Topic results propose many exact limits as if normative | No representative rate/byte/resource evidence exists | Keep hard implementation safety ceilings only as labeled bootstrap estimates. They cannot become production budgets or producer maxima without compatibility and measurement review | ADR-B01-014 |
| C-20 | Repository R2/R3 reproducibility language can be read as requiring byte-identical signed installers | Signatures/timestamps legitimately change signed containers | Require R2 canonical unsigned payload identity; prove R3 unsigned installer identity where possible; signed output differences are limited to approved signature/timestamp structures and independently verified | update ADR-006-007 |

---

# 5. Normative component, interface, schema and state-machine baseline

## 5.1 Components and trust boundaries

| Component | Normative responsibility | Forbidden responsibility | Initial status |
|---|---|---|---|
| `Uam.TestData.Generator` | deterministic T1/T2-approved fictional models, fixed clock, deterministic UUIDv7, lineage and canonical package | truth calculation, live data, wall clock, implicit randomness, production identity authority | foundation implementation allowed |
| `Uam.TestOracle` | independent pure expected outcomes, state/cursor ledger and reconciliation | reference to production decision/mapping/storage code; consulting actual output to create truth | foundation implementation allowed; separate code owner required |
| `Uam.CanaryScan` | exact registry, schema-aware sink scan, encoding decoders, positive controls and redacted reports | one-tool proof, external upload of artifacts, broad suppressions | foundation implementation allowed |
| Contract Authority module/CLI | immutable catalogue, local schema bundle, lint, compatibility, vectors, generator snapshots and owner/runbook metadata | runtime network schema discovery; remote `$ref`; silent defaults | foundation implementation allowed |
| Coordinator Service | session reconciliation, trusted machine/realm state, policy/kill switch, IPC peer validation, minimized-event validation, one-writer storage, later transport | source/profile crawl, user token creation, client impersonation as normal identity, raw source receipt, arbitrary code | G1 synthetic prototype only after prerequisites |
| User Host Launcher | verify ordinary interactive token/release; create protected User Host in same session; exit | source read, policy meaning, network, persistence, elevation, arbitrary child path | G1 synthetic prototype only |
| User Host | exact-session lifecycle, independent effective-policy check, fixed collector coordination, permit issuance, minimization before Coordinator | machine persistence, upload, central SQL, cross-session reads, arbitrary Task Host arguments | G1 synthetic prototype only |
| Task Host | one compiled release-authorized capability under restricted token/job/handles/bounds; validate permit; return minimized result | plugins/scripts/assembly paths, network, child process, Coordinator IPC, durable raw data, general source path | G1 synthetic capability only |
| Application Registry module | UAM ID/revisions, aliases, external refs, ownership/taxonomy proposals, import staging and provenance | infer identity/rules/owners from names; publish without owner/test/conflict result | pure/server module foundation allowed |
| Matcher core/analyzer | closed URL-host grammar, normalization version, deterministic candidate/maximal-set result and static witnesses | first-match ordering, regex, fuzzy/ML, network lookup, production observation upload | synthetic URL host only |
| Policy reference evaluator | finite lattice, meet, candidate classification, revision/realm/expiry checks and effective-policy proof | executable tenant language, arbitrary destinations/targets, crypto key custody | pure foundation allowed |
| Snapshot/policy compiler | select approved same-realm rules, intersect product ceiling, emit minimized immutable artifact and analysis evidence | include display/owner/external data; sign arbitrary client bytes; widen ceiling | unsigned synthetic artifacts initially |
| Server modular monolith | bounded modules and contracts; later durable inbox/processing/control/audit/integrations | endpoint source access; cross-module tables/DTO coupling; payload-derived realm authority | scaffold and pure contracts only in Batch 01 |
| Build/release tooling | locked inputs, architecture checks, reproducibility, file manifest, SBOM/provenance/evidence and signing handoff | hold production signing key, execute untrusted code with authority, rebuild per environment | foundation implementation allowed |

### Trust-boundary sequence

```text
T1/T2-approved source package
  -> classification/provenance gate
  -> deterministic generator
  -> independent oracle + canary scan

MSI/enterprise installation boundary
  -> Coordinator in session 0
  -> bootstrap named pipe
  -> kernel-validated one-use exact-logon-SID pipe
  -> ordinary-token User Host
  -> Coordinator RunIntent
  -> User Host independent policy/session check
  -> one-use CollectionPermit
  -> fixed restricted Task Host
  -> in-process minimization
  -> minimized result only
  -> Coordinator validation
  -> atomic event/progress commit
  -> ACK after commit

Release/tenant control plane
  -> product ceiling
  -> tenant narrowing
  -> emergency/local/runtime restrictions
  -> effective policy proof

Repository
  -> untrusted validation
  -> trusted validation + real Windows proof
  -> two clean unsigned builds
  -> evidence/SBOM/provenance quarantine
  -> separate digest-bound signing
  -> same-digest promotion
```

## 5.2 Canonical repository and dependency boundaries

The canonical scaffold MUST include at least:

```text
/contracts/                         # source schemas/catalogue/vectors; codec-neutral where unresolved
/src/foundation/
  Uam.Contracts.Core/
  Uam.TestData.Generator/
  Uam.TestOracle/                   # no production references
  Uam.CanaryScan/
  Uam.ApplicationRegistry.Domain/
  Uam.ApplicationMatching/
  Uam.PrivacyPolicy.Model/
/src/edge/
  Uam.Coordinator.Service/
  Uam.Coordinator.Core/
  Uam.Coordinator.Storage/
  Uam.UserHost.Launcher/
  Uam.UserHost/
  Uam.UserHost.Core/
  Uam.TaskHost/
  Uam.Windows.Interop/
  Uam.Ipc.Windows/
/src/server/
  Uam.Server.Host/
  modules/{ingestion,policy,registry,audit,processing,integrations}/
/src/tools/
  Uam.RepoGuard/
  Uam.ContractCheck/
  Uam.ReleaseManifest/
/tests/{unit,architecture,contracts,g0,policy,registry,windows-vm,reproducibility,privacy-canaries}/
/eng/{ci,repro,sbom,provenance,signing-handoff,versions}/
/docs/{adr,decisions,threat-models,runbooks,evidence}/
```

Normative dependency rules:

1. Deployable executables MUST NOT reference another deployable’s implementation assembly.
2. Domain projects MUST NOT reference infrastructure, HTTP, ORM, Windows service or another module’s domain.
3. Boundary-generated types MUST remain in boundary-local adapters and MUST NOT become domain/persistence/UI models.
4. Coordinator projects MUST NOT reference source collectors, user-profile APIs, token-creation APIs, PowerShell, scripting, SQL clients or arbitrary process launch.
5. User Host/Task Host MUST NOT reference HTTP clients, central storage/transport, SQL clients, service management, scripting or dynamic capability discovery.
6. Unsafe/P/Invoke code MUST remain in `Uam.Windows.Interop`; public APIs MUST expose safe typed handles/results rather than raw pointers.
7. No broad `Common`, `SharedKernel`, `Utilities`, reflection-discovered plug-in or generic executable command path is allowed.
8. The generator and oracle MUST have an architecture test preventing production decision-code references in the oracle.
9. A codec library, schema validator, generator, analyzer, MSBuild task or CI action is executable supply-chain code and requires the same admission record as a runtime package.

## 5.3 Contract and serialization baseline

### 5.3.1 Common rules

Every candidate contract MUST record:

- immutable contract name and exact `MAJOR.MINOR.PATCH`;
- producer and every required consumer;
- accountable owner and support function;
- trust source and privacy stage;
- strict structural schema and local-reference closure;
- required/optional/null/default semantics;
- scalar/identifier/time/Unicode rules;
- compressed/uncompressed/item/depth/string/property limits;
- duplicate/unknown/extension behavior;
- transaction, receipt, idempotency and retry meaning;
- errors and stable retry classes;
- compatibility, rollout, rollback, deprecation and emergency block behavior;
- permitted/forbidden logs, metrics and diagnostics;
- valid, boundary, invalid, canonical, adversarial and old/new vectors;
- dependency/tool identities and runbook.

A contract cannot move to `candidate` with an `UNASSIGNED` accountable owner or support owner.

### 5.3.2 UAM JSON profile

For JSON boundaries, the initial profile MUST:

- use RFC 8259 UTF-8 without BOM;
- reject invalid UTF-8, duplicate members, wrong case, comments, trailing commas, non-finite numbers and trailing data;
- close objects with `unevaluatedProperties: false` or an equivalent proved closed form;
- reject unknown enum values unless the field is explicitly an opaque preserve-only token;
- separate required, nullable and optional states; receivers do not inject schema defaults;
- use integers only within exact interoperable range for core decisions; field names/types include units;
- bound bytes, scalar values, items, properties, depth, decompression ratio, processing time and allocations;
- use local immutable schema bundles; reject remote URL/file/UNC/package references;
- prohibit generic extension bags in privacy-bearing events, IPC, policies, rules, audit commands and deletion targets;
- allow an extension point only when its namespace, key pattern, count, value bounds and non-authority semantics are explicit.

**FACT.** JSON Schema Draft 2020-12 is the accepted schema dialect [W04]. **FACT.** OpenAPI 3.2.0 is current as of the research date [W05]; **RECOMMENDATION.** use 3.1.2 initially only because I03’s selected toolchain has not proved 3.2.0 parity.

### 5.3.3 Identifiers, digests, time and Unicode

- New UAM entity/message/event/batch/receipt/policy/rule/snapshot/audit/deletion IDs MUST be canonical lower-case UUIDv7 text.
- Deterministic G0 fixtures MUST generate valid UUIDv7 values from the fixed fixture clock plus a domain-separated deterministic bit stream. They MUST NOT make the UUID timestamp authoritative business time.
- External keys MUST be typed opaque references, source-qualified and non-authoritative unless an approved source contract explicitly says otherwise.
- SHA-256 MUST identify canonical content, schema bundles, files and lineage. Algorithm agility is explicit; no receiver guesses from length.
- Instants MUST use an approved RFC 3339 UTC profile with `Z`; source precision and logical ordering are separate fields where material.
- JCS MAY be used only after strict parse and semantic validation for artifacts that fit its I-JSON/number restrictions. JCS MUST preserve string code points as parsed and MUST NOT perform normalization [W02].
- Display/search fields MAY declare NFC or another field-specific comparison profile. Raw/source/signed identity fields MUST not be silently normalized.

### 5.3.4 IPC codec decision boundary

The logical G1 contracts are:

```text
BootstrapHello
ServerHandoff
DedicatedHello
DedicatedWelcome
RunIntent
RunIntentResult
CollectionPermit               # User Host -> fixed Task Host
CollectionResultPage           # already minimized
CommitAck
PauseOrCancel
DrainAndExit
Problem
```

Each logical message MUST have an exact version, closed fields, hard limits, state preconditions, sequence/replay rules, and privacy stage. Realm/device/user claims MUST NOT establish authority.

**UNKNOWN / CLI EXPERIMENT.** The physical codec is not final. The decision gate compares:

- strict length-bounded UTF-8 JSON under the common profile; and
- deterministic CBOR under RFC 8949 with an independently reviewed package/decoder profile.

Both prototypes MUST implement the same logical state machine and transcript authentication. The selected codec must pass exact vectors, duplicate/unknown/malformed corpus, allocation/time limits, fuzzing, cross-version tests and Windows hostile-client tests. Protobuf is not a candidate unless a later ADR introduces it with the same evidence.

## 5.4 G0 package, oracle and canary baseline

### 5.4.1 Dataset classification

| Tier | Allowed content | Default location | Additional gate |
|---|---|---|---|
| T1 fictional committed | reviewed invented values, reserved namespaces, fixed seeds/clocks, expected truth and canaries | source repository/build artifact | automated and human review; no production-derived value/distribution |
| T2 sanitized organization-shaped | approved aggregate counts/constraints plus wholly fictional rows shaped to those aggregates | controlled internal fixture artifact/repository | steward/privacy approval, lineage, expiry/deletion, singling-out review |
| T3 controlled measured evidence | pre-approved minimum aggregate metadata required to replace estimates | isolated measurement store | named question/owner/access/retention/deletion/no-raw proof; disabled by default |

A derivative does not automatically become T1; a steward must issue a new classification and prove no source value or singling-out pattern survived.

### 5.4.2 Package minimum

A published package revision MUST be immutable and include:

```text
manifest.json
approvals/                       # when required
model/*.ndjson
scenarios/{composition,steps,faults}.ndjson/json
truth/{expected-results,cursor-ledger,state-transitions}.ndjson/json
canaries/{corpus,rules,allowlist}.ndjson/json
lineage/records.ndjson
schemas/**
hashes.sha256
package-root.json
```

The manifest MUST include classification, proof gates, owner, provenance, parent digests, expected-result authority, deletion/expiry, seed algorithm/value, fixed clock, generator/oracle source revisions, dependency-lock digest, schemas, scenario composition, privacy-ceiling revision and feature flags. Placeholders are illegal in a published revision.

### 5.4.3 Oracle independence

The oracle MUST:

- be separately owned and reviewed;
- consume declarative rules and canonical inputs;
- calculate expected results before execution;
- record one row for every causal input, including rejection/defer/zero-effect;
- calculate cursor before/after and state transitions;
- distinguish custody, validation, quarantine, materialization and visibility;
- never call production minimization, dedupe, cursor, receipt, policy or mapping functions;
- survive mutation testing of the implementation and of the oracle’s own rules.

Shared generated constants/schemas are allowed only when mutation tests prove they do not erase independence.

### 5.4.4 Canary rule

- Exact fictional markers MUST be seeded into every forbidden source part and declared sink test.
- The scanner MUST scan repository, package, stdout/stderr, test results, logs, traces, metrics, database dumps, HTTP/IPC captures, crash artifacts and support/evidence bundles in declared encodings.
- Every scanner/tool update MUST first detect all mandatory positive controls.
- Allowlists MUST identify exact marker/path/purpose/owner/expiry. Directory wildcards and generic “test data” suppressions are forbidden.
- A mandatory canary miss is a release-blocking privacy incident candidate.

## 5.5 G1 Windows baseline

### 5.5.1 Process and authority model

| Process | Identity | Normative authority | Primary negative gate |
|---|---|---|---|
| Coordinator | first prototype: `LocalService`, session 0, restricted service SID, SCM privilege allowlist | machine state, policy, IPC server, minimized storage, later upload | no user-profile read, token creation, impersonation privilege, source collector or prohibited privilege |
| Launcher | existing ordinary interactive token | verify token/release; create protected User Host in same session; exit | no elevation, source read, network, persistence, arbitrary args |
| User Host | ordinary medium-integrity exact logon/session token | session lifecycle, user-owned read orchestration, independent policy check, permit, minimization | no machine configuration, upload, SQL, cross-session read or raw Coordinator message |
| Task Host | restricted duplicate, low integrity/write restriction where compatible, one-process job | one fixed capability and bounded result | no child, network, UI, write outside scratch, arbitrary source/capability, Coordinator pipe |

### 5.5.2 Launch and IPC

- MSI/enterprise deployment MUST own signed files, protected manifests, service/task/firewall/ACL configuration and repair/uninstall.
- The Scheduled Task MUST use an existing interactive token and least privilege. Password, S4U, highest-available, service-created-token and user-modifiable startup mechanisms are forbidden.
- The launcher MUST create the User Host protected from the first instruction where the supported Windows APIs permit; exact process/token ACLs are verified in the lab.
- Bootstrap pipe exposure MUST be handshake-only, local-only, rate/instance/time bounded and unable to accept an application data frame.
- The Coordinator MUST derive client PID/session from the pipe, hold a process handle, bind creation time, validate process token/logon SID/authentication LUID/WTS session/integrity/elevation and protected release image, then repeat on the dedicated pipe.
- The User Host MUST verify the pipe server PID/session against SCM and the protected release before trusting handoff.
- A dedicated pipe MUST be fresh, one-use and ACL-scoped to the exact logon SID. Same account in another logon is a different boundary.
- Every post-handoff frame MUST be sequence-strict, transcript-authenticated, bounded and rejected on version, state, identity, MAC, replay or size failure.
- The service MUST not trust payload SID/session/realm/device and MUST not impersonate the client as the routine identity mechanism.

### 5.5.3 Task Host limits

Task Host MUST:

- dispatch only a compiled capability ID in the signed release manifest;
- inherit only explicitly listed request/result handles;
- run in a one-process kill-on-close Job Object before resume;
- use a restricted token and low-integrity/write-restricted profile where the runtime proof passes;
- have a private scratch directory with final-path/reparse checks;
- have no network dependency and an effective outbound/inbound block proved after policy refresh;
- receive no raw source path or arbitrary command text unless a later source contract explicitly and safely defines a protected handle-based alternative;
- cooperatively cancel, then be killed as a tree after a bounded grace;
- clear buffers and leave no residual process, job, file, certificate or rule after cleanup.

Failure to achieve a stronger token/write profile does not authorize a silent weaker profile; it opens an ADR with compensating controls or stops the capability.

## 5.6 Privacy ceiling, policy and permit baseline

### 5.6.1 Lattice

```text
Effective = ProductCeiling
          ∧ TenantPolicy
          ∧ ProductEmergencyNarrowing
          ∧ TenantEmergencyNarrowing
          ∧ LocalSafetyDisablement
          ∧ RuntimeCapabilityAvailability
```

For every successful evaluation, `Effective ⪯ ProductCeiling`. Sets intersect; maxima take the lower bound; minimum intervals take the greater bound; transforms use a release-authored acyclic narrowing relation with a unique safe meet. Unknown, incomparable, overflow or missing values disable the affected authorization.

### 5.6.2 Artifact and state rules

- Product ceiling, tenant policy, emergency overlay and matcher snapshot are immutable content-addressed control artifacts.
- Product ceiling defines the representable release-owned source, field, transform, output schema, capability, destination, diagnostic, metric and hard-deny registries.
- Tenant policy references those IDs only and can disable/remove/coarsen/reduce/increase interval; it cannot introduce code, address, path, algorithm or target expression.
- Revision and sequence are strictly monotonic. Rollback republishes prior semantics at a higher revision/sequence and records `rollbackOf`.
- A valid signature does not make a policy lawful or wise; purpose/fields/retention/access remain human decisions.

### 5.6.3 Candidate state machine

```text
FetchedCandidate
  -> StructuralRejected                     # no permission, active valid policy unchanged
  -> QuarantinedUnsupported                 # no permission, active valid policy unchanged
  -> SafetyHold                             # signature/key/realm/rollback/conflict/broadening/chain
  -> VerifiedPendingEffective
  -> Active
  -> Superseded
  -> ExpiredOrCorrupt -> Disabled
```

`SafetyHold` stops new collection until a verified recovery artifact or approved local recovery action succeeds. An expired or unverifiable active authority never receives indefinite offline grace unless a future signed ceiling and human risk decision explicitly defines a bounded source-specific window.

### 5.6.4 RunIntent and CollectionPermit

1. Coordinator creates a bounded `RunIntent` bound to active policy/ceiling digests, source, source generation/cursor epoch, session tuple, nonce and run budget.
2. User Host independently verifies session eligibility and policy/ceiling relation.
3. User Host creates a one-use, short-lived `CollectionPermit` bound to source, transform, output schema, fields, limits, session, installation/realm binding digests, policy/ceiling digests, executable profile, intent digest and nonce.
4. Task Host validates the permit and fixed capability before source access.
5. Task Host returns only minimized schema-valid output bound to the permit.
6. User Host and Coordinator revalidate; Coordinator commits event/progress atomically, then ACKs.
7. Policy narrowing/cancellation invalidates outstanding work; discarded results do not advance the cursor.

The exact local permit authenticator/key exchange is part of ADR-B01-004/005 and G1 evidence.

## 5.7 Application registry and matching baseline

### 5.7.1 Identity and revisions

- `application_id` is realm-scoped UUIDv7, immutable and never reused.
- Merge preserves both IDs and records a same-realm successor; split allocates new IDs and preserves lineage.
- Human-readable/governance fields are immutable revisions, not mutable history-free columns.
- External refs, aliases, owners, taxonomies and CMDB links are separate revisioned/provenance-bearing claims.
- No import automatically creates an executable rule.

### 5.7.2 Batch 01 matcher grammar

Only this subset is active:

```text
Observation: absolute HTTP(S) URL, in user/session memory
Rule: URL_HOST
  schemes: non-empty subset of {http, https}
  host mode: EXACT or DNS-label-boundary SUFFIX
  includeApex: explicit for SUFFIX
  port: DEFAULT_OR_OMITTED or EXACT
  path: NONE
```

The normalizer is versioned, rejects credentials/userinfo, unsupported schemes, malformed host/escapes, controls and bounds violations, and stores/compares canonical ASCII host form. Query, fragment, title and path do not cross the privacy boundary.

Match order is:

1. active/effective rule set for exact realm and normalization version;
2. evaluate all matching rules;
3. maximum explicit priority;
4. maximum fixed family authority;
5. maximal set under provable partial-order specificity;
6. one target application -> `MATCHED`; more than one -> `AMBIGUOUS`; none -> `UNMATCHED`.

Author order, row order, creation time, display name and lexicographic rule ID cannot resolve cross-application ambiguity.

### 5.7.3 Snapshot

A snapshot MUST bind realm, schema/interpreter/matcher versions, product-ceiling revision/digest, rule-set digest, sequence, generated/not-before/soft/hard expiry, compiler/analyzer identity, payload digest and authorization. It contains only compiled predicates and opaque identifiers. Candidate activation is transactional with current/previous state; wrong realm, lower sequence, unsupported version, invalid signature/authorization or over-limit payload fails closed.

## 5.8 State-machine and transaction baseline

| State machine | Normative transitions/invariant |
|---|---|
| Dataset | `Draft -> Validated -> Approved -> Published -> Retired/Revoked`; T2/T3 require approvals and expiry/deletion; publication is immutable |
| Contract | `Draft -> Candidate -> Active -> Deprecated -> Retired/Frozen`; no candidate without owner, vectors, limits, compatibility and runbook |
| Coordinator | `Starting -> SelfChecked -> Listening -> Running -> Draining -> Stopped/SafeDisabled`; collection-capable only after token/release/policy/store/IPC checks |
| User Host | `Launched -> Verified -> Connected -> Ready -> Paused/Draining -> Exited`; lock/disconnect/unknown pauses; fresh handshake after service restart |
| Task Host | `CreatedSuspended -> RestrictedAndJobBound -> PermitVerified -> Running -> Result/Cancelled -> Exited`; no resume before all controls pass |
| Local assignment | `Intent -> Permit -> PagePrepared -> CommitPending -> Committed -> Acked`; retry of identical committed identity returns prior outcome; cursor and event/progress commit together |
| Policy | `Candidate -> Quarantined/VerifiedPending/Active/SafetyHold/Disabled -> Superseded`; lower revision never activates |
| Application | `Draft -> Active -> Retired` or `Active/Retired -> Merged`; IDs never reused |
| Rule | `Draft -> Validating -> ReviewRequired -> Approved -> Scheduled -> Published -> Superseded/Retired`; content change invalidates approval |
| Snapshot | `Building -> Validated -> Authorized/Signed -> Published -> Active -> Superseded/Revoked`; rollback is higher sequence |
| Ingestion | `DurablyReceived -> Validated -> Materialized -> Visible` or `Quarantined`; receipt is emitted only after durable-receipt transaction |
| Release | `Proposed -> Validated -> BuiltA/B -> ReproCompared -> EvidenceComplete -> Quarantined -> Signed -> Verified -> Pilot/Broader/Current -> RolledBack/Revoked`; same digest promoted |

---

# 6. Human decision register

Research must not approve these matters. The accountable role names below are role functions, not invented organizational assignments.

| ID | Human decision | Accountable role/function | Consequence of delay | Earliest blocked work |
|---|---|---|---|---|
| H-01 | legal/business purpose, lawful basis and prohibited uses | Data Controller/Business Product Owner with Legal and Privacy | no live source or organization-derived activity may be collected | T2/T3 approval, G2/G4, pilot |
| H-02 | employee consultation, notice and workforce governance | Employee Relations/Works Council authority with Legal/Privacy | production workforce use remains prohibited | pilot/production |
| H-03 | production source list and hard-deny data classes | Product Privacy Authority and Security | real ceiling cannot authorize a collector | G2/G4 |
| H-04 | exact event fields, identity relation and time precision | Product/Data Owner with Privacy | active production schemas/policies cannot be approved | contract activation, G4 |
| H-05 | first-run lookback, scheduling/frequency and diagnostic detail | Product/Privacy/Operations | numeric limits remain synthetic estimates | G2/G4/pilot |
| H-06 | retention, deletion scope, evidence retention and legal hold | Records Management/Data Controller/Privacy | T2/T3, logs, audit, backups and deletion contracts cannot be finalized | T2/T3, later deletion/restore gate |
| H-07 | portal/control/access roles and privileged approval separation | Security IAM/Product Governance | candidate contract/rule/policy/admin surfaces remain unassigned | server/control implementation |
| H-08 | contract authority and support owners | Architecture Governance/Engineering Leadership | no contract can move to candidate | B01-CONTRACT |
| H-09 | test-data steward, oracle owner and deletion authority | Engineering/Privacy Governance | G0 package cannot be approved | B01-G0 |
| H-10 | supported Windows editions/builds/architectures and RDS/VDI/FSLogix/Citrix scope | Endpoint Platform/Product Support | G1 pass applies to no production support scope | B01-G1 and release |
| H-11 | same-session adversary threat scope | Product Security/Risk Owner | restricted Task Host assurance boundary remains ambiguous | Task Host profile, process collectors |
| H-12 | application source-of-truth and field-authority matrix | Application/CMDB/Data Governance | imports remain proposals; no owner/taxonomy truth | real registry data |
| H-13 | application owners, taxonomy and sensitivity vocabularies | Business/Application Governance with Privacy/Security | real rule publication gate cannot close | registry publication |
| H-14 | permission for URL paths, per-user paths or process fields | Product Privacy and Endpoint Security | those matcher families remain compiled off | later matcher slice |
| H-15 | policy/release/signing approvers and emergency authority | Security/Release Governance | signed production artifacts cannot exist | production control/release |
| H-16 | KMS/HSM/PKI, algorithm/compliance profile, quorum and key recovery | Cryptographic/Signing Authority | crypto ADR remains prototype-only | production policy/snapshot/release signing |
| H-17 | offline validity, clock uncertainty and revocation tolerance | Product Security/Operations/Risk | expiry/offline behavior stays fail-closed default | enterprise rollout |
| H-18 | contract support windows and deprecation commitments | Product/Release/Support | current/previous windows remain temporary planning assumptions | external/long-offline release |
| H-19 | CI/hosting platform, package source/mirror and runner model | Platform Engineering/Security/Procurement | protected release lanes cannot be enabled | release build |
| H-20 | dependency and license allow/deny policy | Legal/Procurement/Security | no candidate OSS package/tool can be admitted | dependency use |
| H-21 | production signing service, timestamp and certificate policy | Signing Authority/Release | no production artifact can be signed/promoted | release |
| H-22 | staffing, support/on-call and incident command | Engineering Leadership/Operations | runbooks and pilot support are not credible | pilot |
| H-23 | budget and acceptable operating cost | Product/Finance/Operations | capacity, runner, artifact, telemetry and support choices remain unapproved | pilot/production |
| H-24 | SLO, RPO, RTO, resource and metric-cardinality budgets | Product/Operations/SRE | exact operational acceptance thresholds remain unknown | capacity/pilot |
| H-25 | production database engine, portal technology and audit-store technology | Architecture/Product/Operations/Procurement | downstream implementation remains provisional | later batches |
| H-26 | pilot, production risk acceptance and go-live | Designated Production/Risk Authority | no production deployment | production |

---

# 7. CLI experiment and measurement plan

## 7.1 Evidence rules for every experiment

Every experiment MUST emit a machine-readable evidence record containing:

- experiment ID and exact pass/fail assertion;
- source commit/tree and configuration/contract digests;
- toolchain, package, native library, runner/VM image and command identities;
- start/end UTC, environment facts and supported-scope label;
- input dataset classification/revision/root hash;
- stdout/stderr/test artifacts by digest;
- canary-scan result and redaction status;
- cleanup/deletion result;
- owner/reviewer and exception references;
- no credential, address, SSH material, real user, raw source value or internal identifier.

A rerun does not erase the first failure. Infrastructure retries retain and classify the original result.

## 7.2 Ordered experiments

| ID | Classification and command outline | Evidence produced | Pass | Fail / stop |
|---|---|---|---|---|
| E-00 | **FACT/CLI EXPERIMENT — input profile**: hash the nine allowlisted inputs and write the review manifest | file names, sizes, SHA-256, review date | exactly the hashes in the evidence table; no extra input | missing/changed/unallowlisted input without explicit review restart |
| E-01 | **CLI EXPERIMENT — toolchain capture**: `dotnet --info`; validate `global.json`, toolchain lock, package sources; query native SQLite `sqlite_version()` and `sqlite_source_id()` | sanitized environment JSON, SDK/runtime patch, OS build class, tool/package hashes, native SQLite source ID | supported .NET family/current servicing; all tools exact; native SQLite identifiable | unsupported patch, floating tool, provider/native mismatch, unidentifiable native SQLite |
| E-02 | **CLI EXPERIMENT — repository scaffold and architecture mutations**: build canonical solution; inject and revert one forbidden reference/API/package per rule | graph, mutation list, test result, clean-tree proof | every forbidden mutation fails and clean graph passes | any mutation survives or cleanup leaves diff |
| E-03 | **CLI EXPERIMENT — strict JSON parser**: duplicate, wrong case, BOM, invalid UTF-8, trailing data, remote ref, depth/size/allocation corpus | vector IDs, parser results, allocation/time buckets | exact acceptance/rejection matrix; bounded resource use | parser differential, duplicate/unknown accepted where closed, network fetch, unbounded allocation/time |
| E-04 | **CLI EXPERIMENT — schema validator bake-off**: official JSON Schema 2020-12 suite subset plus UAM adversarial vectors; OpenAPI 3.1.2 and 3.2.0 tool matrix | conformance report, unsupported keyword list, generated-code/diff results, license/provenance | selected validator/tool profile passes required suite and UAM vectors with deterministic output | unresolved false accept/reject, remote resolution, legal/provenance gap, nondeterminism |
| E-05 | **CLI EXPERIMENT — UUID/scalar vectors**: RFC 9562 UUIDv7 vectors, deterministic fixture generation under clock collisions/regression, time/number/Unicode vectors | canonical bytes and expected values | valid v7/variant, collision detection, stable replay, no business-time inference | invalid layout, duplicate natural key, non-repeatable fixture, normalization mismatch |
| E-06 | **CLI EXPERIMENT — G0 determinism/oracle**: generate package in two clean directories/time zones; reconcile; inject implementation and oracle mutations | roots, file manifests, truth/actual diff, mutation score by mandatory invariant | byte-identical canonical input; zero unexpected actuals; every mandatory mutation detected | canonical mismatch, unexplained extra/missing result, mandatory mutation survivor |
| E-07 | **CLI EXPERIMENT — canary scanner self-test**: plant every exact/encoded canary and known-invalid secret shape; run all selected scanners | rule/tool versions, each positive-control result, redacted report | all mandatory canaries detected in every declared sink/encoding; no report leaks marker value beyond approved location | one mandatory miss, broad suppression, report leaks secret/canary, external egress |
| E-08 | **CLI EXPERIMENT — fictional catalogue shape**: generate 173 fictional applications; compute profile and lineage | counts and disjoint/overlap declaration | exact approved shape; zero copied names/refs; UAM UUIDv7 independent of external ref | count drift, raw value, inferred semantic field, external ref used as identity |
| E-09 | **CLI EXPERIMENT — privacy lattice**: exhaustive small-domain laws plus property/mutation tests; wrong realm, unknown ID, broadening, rollback, expiry, target miss | law results, minimal counterexamples, state transitions | meet laws hold; tenant never broadens; security failures `SafetyHold`; invalid active disables | any broadening, lower revision, wrong-realm activation, permissive unknown/default |
| E-10 | **CLI EXPERIMENT — registry/matcher**: synthetic ID/import/revision tests; URL normalization corpus; generated overlap/shadow witnesses and realm collisions | matcher vectors, analyzer witnesses, snapshot payload | exact/suffix host semantics and ambiguity match reference; no display metadata in snapshot | first-match guess, missed cross-target overlap, raw URL sink, cross-realm relation |
| E-11 | **CLI EXPERIMENT — signed-artifact profile comparison**: JCS vectors; candidate JWS/algorithm/key profiles with malformed headers, duplicate members, key confusion, rollback and rotation | canonical bytes, signature vectors, failure taxonomy, operations notes | at least one profile has deterministic interoperable verification and recovery model | algorithm input controls verifier, duplicate/header accepted, key-purpose/realm confusion, no recovery path |
| E-12 | **CLI EXPERIMENT — locked restore and egress cut**: empty cache, mapped sources, locked restore, then network denied during build/test | source/package graph, hashes, egress log | build/test succeeds after sealed restore; no undeclared source/network | dependency confusion, floating resolution, post-cut network need, credential in log |
| E-13 | **CLI EXPERIMENT — challenged double build**: two clean environments differing in path, user, time zone and locale | unsigned file manifests and binary diff | R2 byte-identical payloads; every allowed installer/signature difference classified | unexplained mismatch or metadata leakage |
| E-14 | **CLI EXPERIMENT — SBOM/provenance/release evidence**: generate two candidate inventories; reconcile with file tree and locks; verify provenance subject; simulate substitution | file manifest, SBOM(s), reconciliation, provenance, tamper results | no unexplained shipped file/component omission; changed subject/material rejected | omission, invented license conclusion, subject mismatch, mutable promotion |
| E-15 | **CLI EXPERIMENT — IPC codec bake-off**: same logical messages in strict JSON and deterministic CBOR; canonical vectors, fuzz, allocation, size/latency and cross-version tests | codec report and reproducer corpus | one codec meets all security/compatibility/resource gates with lower total assurance cost | both fail; parser differential; unbounded resource; dependency admission failure |
| E-16 | **CLI EXPERIMENT — disconnected Windows-lab preparation**: generate placeholder-only inventory/install/test/cleanup scripts and evidence schema; do not connect | script hashes, lint result, proof no endpoint/credential/address/identity data | scripts contain placeholders only, read-only preflight first, synthetic principals/certs and cleanup | any connection detail, credential, real identity, mutating preflight or prohibited data |
| E-17 | **CLI EXPERIMENT — approved Windows inventory**: after human lab authorization, run read-only sanitized inventory | OS/build/arch/session/task/service/GPO/firewall/runtime capability categories | environment is explicitly approved for a named support claim | unsupported/unknown environment treated as passed |
| E-18 | **CLI EXPERIMENT — G1 install/identity**: install synthetic signed build; verify service/task/token/session/image/ACL; no source collection | effective token privilege/SID categories, task XML/SDDL hashes, process tuples, ProcMon category report | Coordinator has only allowed effective privileges; User Host ordinary exact session; no profile access | prohibited privilege, elevated/incorrect host, service profile read, mutable release/config |
| E-19 | **CLI EXPERIMENT — hostile G1 IPC**: **ESTIMATE** minimum 10,000 cross-session/same-account-different-logon attempts and 10,000 malformed/oversized/replay/out-of-order/slow attempts per supported environment | attempt counts, accepted-message count, resource curves, stable error categories | zero unauthorized accepted application messages; bounded handles/memory/CPU/threads; recovery succeeds | one unauthorized accepted message, pipe squatting, replay/PID-reuse bypass or unbounded resource growth |
| E-20 | **CLI EXPERIMENT — Task Host containment**: token/IL/job/handle/child/write/network/cancel/kill-tree corpus | token facts, handle list, file/network results, job notifications, residue report | no child, network or outside-scratch write; one-process job; bounded kill; no residue | any escape, inherited Coordinator pipe, prohibited privilege, orphan or silent weakening |
| E-21 | **CLI EXPERIMENT — lifecycle**: logon/lock/unlock/fast-switch/RDP connect/disconnect/reconnect/logoff/service restart/upgrade/rollback/uninstall matrix | state transition trace, event/cursor facts, task/service/file/cert/rule before/after diff | fail-closed pauses; fresh handshakes; no unacknowledged loss; complete cleanup | collection while ineligible/unknown, stale channel reuse, cursor advance on discard, residue |
| E-22 | **CLI EXPERIMENT — aggregate gate**: verify every evidence manifest, owner, ADR and exception; generate `batch-01-gate.json` | signed/reviewed gate report by digest | all required gates pass; no unexpired blocker/exception/UNASSIGNED owner | any missing evidence, exception, owner, canary, contradiction or mismatched digest |

## 7.3 Windows-lab handling constraints

- No command, host, user, address, port, identity path, key, SSH configuration or credential appears in repository evidence or this result.
- Preflight is read-only and precedes installation.
- All principals, certificates, realms, applications, URLs and events are visibly fictional.
- Raw ProcMon/ETW or equivalent traces remain in the restricted lab; shareable evidence contains normalized categories/counts only.
- Test certificates are generated inside the disposable VM, never production-trusted, and removed with private keys and trust entries.
- Cleanup compares services, tasks, users/groups, files, registry, firewall, certificates, processes/jobs and temporary data before/after. Failure to prove cleanup invalidates the run.

---

# 8. Threat, failure and recovery gaps

| ID | Gap or threat | Current containment | Missing evidence/recovery path | Owner/gate |
|---|---|---|---|---|
| T-01 | Coordinator cannot query prepared User Host process/token under hardened policy without extra privilege | launcher-prepared ACL intent; no impersonation | effective-access prototype; fallback must not silently add privilege | Windows Security, E-18 |
| T-02 | same-account different-logon process handle/DACL race | logon SID, authentication LUID, owner-rights intent, protected launch | 10,000 handle-theft attempts and supported-OS ACL proof | G1, E-19 |
| T-03 | bootstrap pipe DoS/squatting/resource exhaustion | first-instance intent, local-only, handshake-only quotas | hostile resource curves, restart/recovery and pipe ownership proof | IPC, E-19 |
| T-04 | PID reuse or fake signed/path-equivalent peer | held process handle, creation time, file ID/hash/signature | race and release-replacement campaign | IPC/Release, E-19 |
| T-05 | Task Host can still read same-user-readable data | fixed capability, no arbitrary code, permit and restricted process | human threat-scope decision; AppContainer/broker only if required | H-11, later ADR |
| T-06 | restricted-token launch requires prohibited privilege or runtime writes outside scratch | stop-on-failure rule | token-launch and dependency compatibility; no silent fallback | Sandbox, E-20 |
| T-07 | enterprise firewall policy overrides local executable block | no network dependency, MSI rule intent | effective policy export and synthetic egress; incident kill switch | Endpoint Security, E-20 |
| T-08 | codec/parser common-mode vulnerability | closed schemas, independent vectors, codec bake-off | fuzz, differential parser and allocation evidence | Protocol, E-03/E-15 |
| T-09 | per-frame key/transcript design is wrong | sequence/replay/MAC requirement | cryptographic review, exact vectors, handle-dup/replay tests | Protocol Security, ADR-B01-004 |
| T-10 | policy key compromise, freeze or rollback | signatures, monotonic revision, expiry, `SafetyHold` | key hierarchy, quorum, revocation, rotation, recovery drill | Signing Authority, E-11 |
| T-11 | clock rollback/uncertainty causes stale authority | explicit clock-confidence state, fail closed | Windows clock/offline distribution and recovery policy | Security/Operations, H-17 |
| T-12 | validly signed malicious or mistaken ceiling | authority separation, release binding, canary tests | human approval design, reproducible build/provenance and incident revocation | Product Privacy/Release |
| T-13 | oracle and implementation share conceptual error | separate code ownership and mutation | hand-worked minimal cases, third implementation/model comparator for critical laws | Test Architecture, E-06 |
| T-14 | scanner false negative | exact canaries and multiple layers | expanding corpus, positive controls for each version, incident scan of all sinks | Privacy/AppSec, E-07 |
| T-15 | T2/T3 misclassification or retained derivative | most-sensitive-parent rule, T3 off | steward approval, access/expiry/deletion and promotion review | Human, H-06/H-09 |
| T-16 | schema/tool accepts remote refs, duplicates or unsupported semantics | strict profile/local bundles | validator bake-off and runtime raw-parser checks | Contract Authority, E-03/E-04 |
| T-17 | UUIDv7 clock/monotonic generator collision or information misuse | collision check, opacity rule, explicit business time | deterministic and runtime generator vectors; privacy review of exposed IDs | Contract Owner, E-05 |
| T-18 | URL normalization differential changes application attribution | versioned normalizer and golden corpus | WHATWG/IDNA/library differential tests; snapshot compatibility | Registry, E-10 |
| T-19 | process metadata TOCTOU/signature/path ambiguity | process family off | later handle/file-ID/signature/case-mode lab and privacy decision | later matcher gate |
| T-20 | rule priority shadows broad domains or analyzer misses overlap | closed grammar and exact static witnesses | generated exhaustive/property comparison; fail on `UNKNOWN` | Registry, E-10 |
| T-21 | active snapshot/policy corruption during crash | immutable artifacts, transactional activation, previous state | SQLite failpoint matrix, checksum/recovery and no stale resurrection | Policy/Registry later prototype |
| T-22 | event/cursor ACK crash invariant not yet implemented | accepted invariant and G0 truth ledger | G5 failpoints after G1; no production storage claim now | Endpoint Storage, G5 |
| T-23 | server receipt issued outside durable failure domain | accepted contract only | G8 relational fault injection/idempotency/poison proof | later ingestion gate |
| T-24 | long-offline endpoint exceeds version/policy window | fail closed after expiry; version inventory required | measured offline/rollout distribution and human support window | H-17/H-18 |
| T-25 | deletion/restore ordering makes deleted data visible | baseline invariant and future tombstones | deletion/restore/replay prototype and human scope/retention | later gate 12 |
| T-26 | build dependency/action/generator compromise | exact lock, trust lanes, SBOM/provenance | selected platform/mirror, egress capture, incident drill | Repo/Security, E-12–E-14 |
| T-27 | untrusted PR poisons cache or reaches signing/deploy | T0 isolation and separate lanes | CI-platform negative tests and destruction receipt | Platform Security |
| T-28 | unsigned/installer nondeterminism hides substitution | R2/R3 comparison | selected installer proof and bounded exception process | Build/Release, E-13 |
| T-29 | SBOM/provenance omits shipped/native/generated content | independent file/lock reconciliation | selected tools and consumer/legal validation | Build/Security/Legal, E-14 |
| T-30 | production owner/support gap turns fail-closed into indefinite outage or unsafe workaround | mandatory owner/runbook gate | named people, drills, escalation and support hours | H-08/H-22 |

Minimum recovery runbooks before a synthetic G1 gate is accepted:

1. contaminated fixture/canary escape;
2. service privilege/ACL/release mismatch;
3. pipe squatting, fake peer, replay or cross-session acceptance;
4. stale/orphan User Host or Task Host;
5. task/GPO/firewall incompatibility;
6. policy `SafetyHold`, expiry, key rotation and higher-revision rollback;
7. oracle disagreement;
8. runner/cache/dependency compromise;
9. reproducibility/SBOM/provenance mismatch;
10. test certificate/residue cleanup failure.

Each runbook must name authorization, containment, evidence, rollback/recovery, cleanup, neighboring-canary protection, and the condition for re-enablement.

---

# 9. ADR create/update list

## 9.1 Batch-level ADRs to create

| ADR | Decision | Status from this review | Dependency/review trigger |
|---|---|---|---|
| ADR-B01-001 | Batch 01 accepted scope, conditional gate and prohibition on production-shaped code before evidence | **Create — accept** | update only through explicit baseline change proposal |
| ADR-B01-002 | Strict UAM JSON/contract profile, local bundles, explicit extension points, OpenAPI 3.1.2 initial tool profile | **Create — accept** | validator/tool matrix, OpenAPI 3.2 parity, incident |
| ADR-B01-003 | UUIDv7 production/domain identity; deterministic UUIDv7 fixtures; SHA-256 content digests; opaque external refs | **Create — accept** | collision/interoperability/privacy evidence |
| ADR-B01-004 | G1 physical IPC codec/framing/transcript decision is measurement-gated; no protobuf placeholder | **Create — proposed/blocking** | E-03/E-15/E-19 and crypto review |
| ADR-B01-005 | Coordinator `RunIntent` plus independent User Host `CollectionPermit` and permit-bound Task Host output | **Create — accept logical model** | G1 three-process lab and protocol review |
| ADR-B01-006 | Field-specific Unicode normalization; JCS preserves strings; generator-owned NFC is local to fictional model | **Create — accept** | new field semantic/signature scheme |
| ADR-B01-007 | Signed control-artifact invariants; exact algorithm/quorum/key service deferred | **Create — accept invariants / defer profile** | E-11 and human signing authority |
| ADR-B01-008 | Application identity/revision model and synthetic URL-host-only matcher; path/process compiled off | **Create — accept** | approved privacy/use case and matcher lab |
| ADR-B01-009 | Policy candidate quarantine versus `SafetyHold`; active expiry/corruption disables; rollback is higher revision | **Create — accept** | incident exercise or new primary evidence |
| ADR-B01-010 | OSS admission policy and explicit v8.30.1 Gitleaks rejection | **Create — accept** | resolved newer release plus positive controls |
| ADR-B01-011 | Canonical monorepo project graph including launcher/interop and no codec assumption | **Create — accept** | independent access/release boundary evidence |
| ADR-B01-012 | Compatibility windows are contract-family-specific and owner-approved | **Create — accept principle / provisional windows** | fleet/offline/external commitment evidence |
| ADR-B01-013 | G1 Windows object/access intent; literal SDDL/privileges/tasks remain effective-access CLI evidence | **Create — accept principle** | supported-environment lab results |
| ADR-B01-014 | Numeric values are bootstrap safety estimates until compatibility-aware measurements replace them | **Create — accept** | each measured/approved budget |
| ADR-B01-015 | G0 classified package and independent oracle are mandatory prerequisites | **Create — accept** | G0 incident or superior formal model evidence |

## 9.2 Topic ADR actions

| Topic ADR | Action |
|---|---|
| ADR-G0-001, 003, 005–007, 009–012 | **Accept with owner assignment and this review’s scalar/profile corrections** |
| ADR-G0-002 | **Update:** deterministic generator remains; replace production-style prefixed IDs with deterministic UUIDv7 fixtures; retain SHA-256 streams/digests |
| ADR-G0-004 | **Accept:** canonical JSON/NDJSON and ephemeral SQLite; apply field-specific Unicode rule |
| ADR-G0-008 | **Accept:** execution-time dependency selection |
| ADR-G1-001, 004, 005, 008, 009, 011–013, 015 | **Accept direction; G1 lab remains mandatory** |
| ADR-G1-002, 003, 007 | **Accept as first falsifiable Windows profile, not proven deployment fact** |
| ADR-G1-006 | **Supersede/update by ADR-B01-004:** CBOR/88-byte frame is a candidate, not accepted final |
| ADR-G1-010 | **Update by ADR-B01-012:** contract-family-specific window |
| ADR-G1-014 | **Keep proposed:** CsWin32 build-time candidate only after admission |
| ADR-CV-001–006 and receipt/rollout/realm rules | **Accept with owner assignment** |
| ADR-CV JSON identifier rules | **Accept UUIDv7; update all contradictory v4/custom patterns** |
| ADR-CV signing profile | **Accept signed-control-artifact scope; exact crypto remains ADR-B01-007** |
| Registry identity, aliases, external refs, revisions, ambiguity and snapshots | **Accept** |
| Registry URL-path and process ADRs | **Defer/compiled off** |
| ADR-05.1, 05.3–05.10 | **Accept with owner assignment and G1 integration** |
| ADR-05.2 | **Update:** strict JSON/JCS accepted; threshold JWS/ES256 provisional |
| ADR-05.6 | **Accept and merge with ADR-B01-005** |
| Repository ADRs for monorepo, boundaries, locked inputs, trust zones, R2, SBOM, provenance, separate signing, observability and incident evidence | **Accept** |
| Repository canonical tree | **Update:** add launcher/interop; remove `.proto` as a decision |

No topic ADR may be marked `Accepted` while its owner is `UNASSIGNED` or its required CLI gate has not passed.

---

# 10. Ordered implementation backlog and dependency/stop gates

## 10.1 Critical path

| Order | Backlog item | Depends on | Deliverable | Stop gate |
|---:|---|---|---|---|
| 1 | record Batch 01 evidence manifest and ADR templates | none | immutable input hashes, decision/owner templates | extra/missing input or unreviewed contradiction |
| 2 | assign accountable owner functions | human governance | owner register and escalation map | any blocking `UNASSIGNED` |
| 3 | scaffold canonical monorepo and protected paths | ADR-B01-011 | buildable empty boundaries, CODEOWNERS equivalent, architecture test harness | forbidden reference/API mutation survives |
| 4 | establish exact toolchain/package-source lock and T0/T1 trust policy | 3 | `global.json`, toolchain lock, source mapping, no-secret untrusted lane | floating dependency or authority leak |
| 5 | publish UAM Contract Standard v0 candidate | 2–4, ADR-B01-002/003/006/012 | scalar/profile rules, catalogue metaschema, lifecycle and problem codes | owner/limits/vectors missing |
| 6 | run validator/OpenAPI/codegen bake-off | 5 | selected strict validator/tool profile and locked vectors | conformance/provenance/legal failure |
| 7 | implement deterministic UUIDv7/vector library | 5 | RFC/UAM vectors and generator interface | invalid/non-repeatable identity |
| 8 | implement G0 generator/package/lineage | 5–7 | T1 package CLI and fictional catalogue shape | nondeterminism or unclassified data |
| 9 | implement independent oracle/truth ledger | 5, 8 | separate project/owner, mutation-tested reconciliation | production-code reference or mutation survivor |
| 10 | implement exact canary/sink scanner and positive controls | 3–9 | mandatory scanner gate; dependency deny for Gitleaks v8.30.1 | any mandatory miss |
| 11 | implement pure privacy lattice and state machine | 5–7, ADR-B01-009 | reference evaluator, exhaustive/property vectors | tenant broadening or failure-state mismatch |
| 12 | implement registry identity/revision/import model and synthetic URL-host matcher | 5–8, ADR-B01-008 | realm-negative, ambiguity and snapshot vectors | name/ref identity or guessed ambiguity |
| 13 | implement release/build evidence controls | 3–6 | R2 double build, file manifest, SBOM/provenance reconciliation | unexplained mismatch or subject omission |
| 14 | define codec-neutral G1 logical contracts and RunIntent/Permit | 5, 7, 11, ADR-B01-005 | state machine and vectors; no Windows implementation yet | privacy/identity field ambiguity |
| 15 | compare JSON/CBOR physical profiles | 6, 10, 14 | ADR-B01-004 evidence and selected profile | neither candidate passes |
| 16 | prepare disconnected Windows lab scripts and fictional identities | 3–15 | placeholder-only inventory/install/test/cleanup bundle | any connection or real identifier in evidence |
| 17 | obtain supported-environment and lab authorization decisions | human H-10/H-11 | approved matrix | no approved environment |
| 18 | build synthetic G1 service/launcher/User Host/Task Host prototype | 15–17 | signed lab-only fixed capability, no source collector | architecture/static gate violation |
| 19 | execute G1 identity/IPC/containment/lifecycle campaign | 18 | evidence bundle and cleanup receipt | any primary G1 failure |
| 20 | aggregate Batch 01 gate | 1–19 | `batch-01-gate.json`, ADR/owner/evidence review | any failed/expired/missing item |
| 21 | begin production-shaped endpoint shell using synthetic provider only | 20 | Coordinator/User Host/Task Host shell and minimized synthetic event | live source, real data or G2/G3/G4 work sneaks in |
| 22 | proceed to G2, then G3, G4 and G5 in accepted order | 21 | later-gate evidence | failed early gate stops dependent work and opens ADR |

## 10.2 Parallelism rules

The following may run in parallel after the contract scalar profile exists:

- G0 package/oracle/canary;
- pure privacy evaluator;
- application identity and URL-host matcher;
- repository restore/reproducibility/SBOM controls.

The following may not start early:

- G1 Windows security implementation before codec-neutral logical contracts, policy permit and repository architecture gates;
- production-shaped endpoint integration before full Batch 01 gate;
- live Edge acquisition before G2;
- production event/cursor semantics before G3/G4 field and privacy decisions;
- G5 storage claims before G1–G4 prerequisites;
- signing/promotion before human authority and build evidence.

## 10.3 Batch stop/go rule

**GO** after item 20 only for a production-shaped **synthetic** endpoint shell.  
**STOP** on any unresolved cross-session acceptance, privacy canary, owner gap, schema ambiguity, broadening policy, unexplained binary mismatch, dependency provenance gap, or cleanup residue.  
A stop opens the named ADR; it does not permit a weaker undocumented fallback.

---

# 11. Source and open-source quality corrections

## 11.1 Public time-sensitive verification corrections

| Claim | Verification and resolution |
|---|---|
| .NET line | **FACT.** Microsoft’s support table reviewed 31 July 2026 lists .NET 10 as active LTS, patch 10.0.10 dated 14 July 2026, supported through 14 November 2028 [W01]. This is a point-in-time execution input, not timeless architecture. |
| SQLite line | **FACT.** SQLite’s release history lists 3.53.4 dated 24 July 2026 and source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`; the history also records the WAL-reset corruption fix [W15]. Providers must expose the actual native source ID. |
| UUID | **FACT.** RFC 9562, May 2024, is standards-track and defines UUIDv7 as Unix-epoch-millisecond time-ordered plus uniqueness bits [W03]. UAM adopts UUIDv7 but does not treat its timestamp as business truth. |
| JCS/Unicode | **FACT.** RFC 8785, June 2020, requires duplicate-free I-JSON-compatible data and states parsed string data is preserved as-is; JCS does not perform Unicode normalization [W02]. |
| OpenAPI | **FACT.** OpenAPI 3.2.0 is a published current specification [W05]. I03’s 3.1.2 selection is retained only as an initial tool-profile choice pending matrix evidence. |
| Task Scheduler | **FACT.** Microsoft’s protocol specifies `TASK_LOGON_GROUP` runs interactively for any logged-on group member [W07]. UAM fitness still requires lab proof. |
| Service privilege/SID | **FACT.** Microsoft documents SCM removal of undeclared required privileges and restricted service SID behavior/restart effect [W08–W09]. Effective token evidence remains mandatory. |
| Named-pipe identity | **FACT.** Microsoft exposes client/server process and session ID queries for named pipes [W10–W13]. Those values must be combined with held process/token/release evidence; PID alone is not authority. |
| Restricted token | **FACT.** `CreateRestrictedToken` can disable privileges, add restricting SIDs and perform two access checks; `DISABLE_MAX_PRIVILEGE` retains `SeChangeNotifyPrivilege` [W14]. It does not by itself provide a complete sandbox. |
| CBOR package | **FACT.** `System.Formats.Cbor` is distributed through PackageReference on NuGet at the reviewed point [W06]. Treat it as an admitted package dependency if selected, not as an unreviewed shared-framework assumption. |

## 11.2 Quality corrections by supplied result

| Result | Strong contribution accepted | Correction required |
|---|---|---|
| G0 | best treatment of classification, deterministic evidence, truth and canaries | replace custom production-style IDs with deterministic UUIDv7 fixtures; limit NFC rule to generator-owned fields; “signed-off” is approval/digest unless crypto ADR applies; reject reviewed Gitleaks version |
| G1 | strongest Windows trust-boundary and hostile-proof blueprint | exact SDDL/privilege/task/mitigation/limits are hypotheses; CBOR/header not final; CBOR package claim corrected; integrate RunIntent/Permit |
| Contract/versioning | strongest cross-boundary authority, strictness, receipt and rollout discipline | 3.1.2 is a tool profile, not latest OpenAPI; version window is provisional; physical IPC codec remains separate |
| Registry/matching | strongest identity, provenance, ambiguity and closed-grammar model | first slice limited to URL host; path/process disabled; all owner/taxonomy/source authority remains human |
| Privacy | strongest monotonic/fail-state model and independent permit | exact ES256/JWS/quorum/key service exceeds available authority; UUID regexes must be v7; crypto profile remains gated |
| Repository/build | strongest supply-chain, CI, reproducibility and signing separation | add launcher/interop to tree; remove `.proto` assumption; exact tools remain candidates; installer R3 separated from signed-byte identity |

## 11.3 Consolidated open-source audit

**Decision rule.** No open-source runtime/build/test dependency is admitted merely by this review. A candidate requires exact source/package/binary mapping, stable tag/commit, license approval, recent maintenance/support evidence, tests, security/advisory posture, UAM fit, positive/negative controls, owner and removal path. Entries without one of those are rejected or reference-only.

### Candidate after an admission experiment

| Project and reviewed revision | License | Maintenance/tests/security summary | Classification and correction |
|---|---|---|---|
| FsCheck `3.3.4`, commit `7c583d6df4939643fd36f0439694be1456833aff` | BSD-3-Clause | current 25 Jul 2026; tests/docs/integrations; no property framework proves UAM alone | **test candidate**; use one property framework; supersedes privacy report’s 3.3.3 review |
| Microsoft CsWin32 `0.3.298`, commit `e4a7320acd0c62f7490efd4c34421c181212dd8d` | MIT | active Microsoft source generator with tests; generated surface still supply-chain code | **pinned build-time candidate** only, `PrivateAssets`, API allowlist, generated diff and manual fallback |
| `oasdiff` `v1.27.0`, commit `fb8babb92c123991e7cff4500bb35cafe97e5f7b` | Apache-2.0 | 30 Jul 2026; tests/validation/security guidance | **build candidate behind UAM adapter**; never compatibility oracle |
| NSwag `v14.7.1`, commit `2389c0721d069fa8ea07e35b925b66121e577c81` | MIT | active 2026; tests; recent nullability regression shows need for snapshots | **codegen bake-off candidate**; boundary-local generated output only |
| Corvus.JsonSchema `5.2.10`, commit `a67f993cecd7b64eec7f8e4bd6e540555b91bfd2` | Apache-2.0 | active; tests/benchmarks/spec-suite submodules | **validator/sourcegen bake-off candidate** after determinism/resource tests |
| JSON Schema Test Suite commit `c7257e92580678a086f0b9243a1903ed88bd27f7` | MIT | official language-neutral suite | **pinned test/reference input**, supplemented by adversarial resource tests |
| ArchUnitNET `0.13.3`, commit `b25c4f940b1d067e97092783d0ef16e4fe12d8c3` | Apache-2.0 | current 2026 and tested | **test candidate** only if it adds detection beyond custom graph/source guards |
| `microsoft/sbom-tool` `v4.1.5`, commit `c83b43dee2dd70b4d6ba16a97cde6b43f971d9c3` | MIT | maintained/tests; output completeness not guaranteed | **tool candidate** after exact binary, egress and reconciliation tests |
| `cyclonedx-dotnet` `v6.2.0`, commit `55877e2ae058ae9686783ac084d2257d3fcedab1` | Apache-2.0 | active/tests/end-to-end | **secondary SBOM candidate**, not whole-release inventory by itself |
| Testcontainers .NET `4.13.0`, commit `1717807affaae9b967035516ebedcd76dd7eaffb` | MIT | current, security policy and attested packages | **trusted server-integration candidate only**; never Windows-session proof; Docker authority must be isolated |
| `actions/attest` `v4.2.1`, commit `508db95dd578ae2727ebd6217d5ba78e4fbda05d` | MIT | current verified release/tests | **platform adapter candidate only if GitHub is selected**; architecture stays platform-neutral |
| Bogus `v35.6.5`, commit `70fd9acc9491058b77283a65f1fb7873483f6bd7` | MIT | maintained/tests/docs, but sequence changes with library/code | **optional peripheral T1 text candidate only**; never IDs, clocks, distributions or truth |
| SharpFuzz `2.3.0` package; source mapping unresolved beyond tag `v2.2.0` commit `28c353b41a1ff60039bf78293dbd5edd9d7c3014` | MIT | current package, fuzz harness/tests, but source provenance gap | **NO-GO until exact package-to-source mapping**; then isolated T1 fuzz candidate |
| Task Scheduler wrapper `v2.12.2`, commit `59a6a2234a44ce885133301345b85f9d2bd6b86a` | MIT | tested broad wrapper; 2025 release | **possible installer-only candidate later** if direct COM proof shows lower risk; reference for G1 now |

### Rejected or no-go as reviewed

| Project and reviewed revision | License/provenance | Maintenance, tests and security evidence | Decision and UAM-fit reason |
|---|---|---|---|
| Gitleaks [`v8.30.1`](https://github.com/gitleaks/gitleaks/releases/tag/v8.30.1), commit [`83d9cd684c87d95d656c1458ef04895a7f1cbd8e`](https://github.com/gitleaks/gitleaks/commit/83d9cd684c87d95d656c1458ef04895a7f1cbd8e) | MIT; release assets/checksums exist | active project with tests and security policy, but the supplied review records a public positive-control report in which this exact binary missed a canonical GitHub PAT and exited successfully | **REJECT this reviewed version.** A scanner that misses a mandatory planted value cannot be trusted as a release gate. A later release requires exact binary provenance and independent UAM positive controls; it remains secondary to the exact canary scanner. |
| CsCheck NuGet `4.7.0` | Apache-2.0; exact package-to-source tag/commit **UNKNOWN** | package updated 17 May 2026 and repository exposes implementation/tests/workflows; no formal security policy was established in the review | **NO-GO as a dependency until provenance is resolved.** Attractive C# property/model testing does not justify consuming bytes that cannot be tied to reviewed source. Select at most one general property framework. |
| Microsoft Coyote CLI `1.7.11` | MIT; exact package-to-source tag/commit **UNKNOWN** | substantial source/tests/samples/workflows/security policy, but reviewed package dates from 18 March 2024 and is described as without formal support | **NO-GO as a default dependency; bounded reference spike only.** IL rewriting and systematic exploration may help concurrency research but cannot prove Windows/SQLite/process behavior and adds runtime/support risk. |
| `DotNet.ReproducibleBuilds` `2.0.5` | MIT; package current, exact source commit for the package **UNKNOWN** | repository has dedicated tests and isolation settings | **NO-GO until source/package provenance and imported MSBuild behavior are established.** Even then it cannot replace independent R2 double-clean-build evidence. |
| `JsonSchema.Net` `9.4.0`, commit [`399f198431f65cf6896fe6038f833ef6d0b27a39`](https://github.com/json-everything/json-everything/tree/399f198431f65cf6896fe6038f833ef6d0b27a39) | repository source states MIT; supplied review identifies project-supplied binary EULA/maintenance-fee terms requiring Legal/Procurement decision | very active; broad specification/test-suite integration; UAM resource and adversarial behavior not proved | **NO-GO pending Legal/Procurement and conformance/resource review.** Do not treat source-license appearance as binary-use approval. |

### Reference only — not dependencies

Every row below has an immutable tag or commit and a reviewed license. “Reference only” means no package, binary, source copy, service or runtime is authorized by this batch.

| Project and immutable revision | License | Maintenance, tests and security evidence reviewed | UAM fit and classification |
|---|---|---|---|
| Tailscale [`v1.98.10`](https://github.com/tailscale/tailscale/releases/tag/v1.98.10), commit [`36550d57f4a4055246ef7412f4e650a012a465f1`](https://github.com/tailscale/tailscale/commit/36550d57f4a4055246ef7412f4e650a012a465f1) | BSD-3-Clause | released 28 July 2026; security policy and Windows named-pipe tests; finite timeout/PID/token patterns | **Reference only.** Useful pipe sequencing and hostile tests; Go/VPN daemon scope and impersonation/broad-user ACL model do not satisfy UAM session/privacy authority. |
| Microsoft `go-winio` [`v0.6.2`](https://github.com/microsoft/go-winio/releases/tag/v0.6.2), commit [`3c9576c9346a1892dee136329e7e15309e82fb4f`](https://github.com/microsoft/go-winio/commit/3c9576c9346a1892dee136329e7e15309e82fb4f) | MIT | released 19 April 2024; pipe/security-descriptor tests and security policy; older maintenance point | **Reference only.** Useful low-level race/deadline/error cases; Go transport wrapper has no UAM image, logon-session, privacy or protocol authority. |
| Microsoft PowerToys [`v0.100.2`](https://github.com/microsoft/PowerToys/releases/tag/v0.100.2), commit [`1d11b732b7ba7dbb265d1151531655fd8d83c76d`](https://github.com/microsoft/PowerToys/commit/1d11b732b7ba7dbb265d1151531655fd8d83c76d) | MIT plus third-party notices | released 26 June 2026; broad CI/tests, security policy and installer/release evidence | **Reference only.** Multi-process/installer/resource lessons apply; its plugin, action, UI, elevation and updater surface is explicitly unsuitable. |
| Chromium Windows sandbox commit [`ee302baa5ed512cef29f848253dd8f4e9991b140`](https://chromium.googlesource.com/chromium/src/sandbox/+/ee302baa5ed512cef29f848253dd8f4e9991b140) | BSD-style plus extensive third-party notices | authored 3 February 2026; mature restricted-token/job/mitigation code and dedicated adversarial tests; continuous security maintenance | **Reference only.** Strongest containment design input, but importing a browser broker/interception system would create an enormous mismatched boundary; no equivalence claim. |
| Presidio [`2.2.364`](https://github.com/data-privacy-stack/presidio/releases/tag/2.2.364), commit [`779dbd286d5ef4d1fbe2514275fb1bce358f2417`](https://github.com/data-privacy-stack/presidio/commit/779dbd286d5ef4d1fbe2514275fb1bce358f2417) | MIT | released 22 July 2026; component/e2e tests, workflows, security/support policies and active fixes; project warns detection is not complete | **Reference/optional offline heuristic only.** It may challenge T1/T2-approved artifacts but can never authorize data or prove absence; Python/model/operations cost is material. |
| GraphWalker [`4.3.3`](https://github.com/GraphWalker/graphwalker-project/releases/tag/4.3.3), commit [`1c28d9c4171b8bda24d01f3268ddc6765b3a2e81`](https://github.com/GraphWalker/graphwalker-project/commit/1c28d9c4171b8bda24d01f3268ddc6765b3a2e81) | MIT | released 26 September 2024; workflows/core/model-checker tests; announced Rust rewrite creates roadmap uncertainty | **Reference only.** State/path notation is useful; JVM/Studio/runtime burden and roadmap do not justify dependency for UAM’s small explicit state machines. |
| Apicurio Registry [`3.3.1`](https://github.com/Apicurio/apicurio-registry/releases/tag/3.3.1), commit [`06c984f524542b584278bba6e75cd64f7f61b890`](https://github.com/Apicurio/apicurio-registry/tree/06c984f524542b584278bba6e75cd64f7f61b890) | Apache-2.0 | released 27 July 2026; integration tests and active hardening for archive expansion, XML/XXE, SSRF, HSTS and digest pinning | **Reference only.** Concrete registry/parser/operations threat evidence; a large online Java service is unnecessary for the initial signed local-bundle model. |
| Pact .NET [`5.0.1`](https://github.com/pact-foundation/pact-net/releases/tag/5.0.1), commit [`171c82c2da0f000d424fd94a1ccd4fe910955d0e`](https://github.com/pact-foundation/pact-net/tree/171c82c2da0f000d424fd94a1ccd4fe910955d0e) | MIT plus native Pact FFI/transitives | released 22 March 2025; mature tests/examples; recency and current .NET support must be rechecked at adoption | **Reference/optional named-external-consumer test candidate only.** Consumer examples do not replace normative schemas, privacy authority or deployed compatibility evidence. |
| `cyberphone/json-canonicalization` commit [`19d51d7fe467d4706a3ff08adf8a748f29fc21e0`](https://github.com/cyberphone/json-canonicalization/tree/19d51d7fe467d4706a3ff08adf8a748f29fc21e0) | Apache-2.0 | reviewed 13 December 2024; multi-language implementations and test data; no independent security audit established | **Reference/test-vector source only.** RFC 8785 remains normative; do not import example code unchanged into a signing boundary. |
| OPA [`v1.19.0`](https://github.com/open-policy-agent/opa/releases/tag/v1.19.0) | Apache-2.0 | released 30 July 2026; extensive unit/e2e/benchmark tests, security policy and published audit; selected release includes a Compile-API security fix | **Reference only.** Policy/testing/bundle ideas are useful; Rego, built-ins, external data and general compilation make monotonic endpoint privacy assurance harder, not easier. |
| Cedar [`v4.12.0`](https://github.com/cedar-policy/cedar/tree/v4.12.0) | Apache-2.0 with NOTICE | released 28 July 2026; dedicated testing, symbolic-counterexample tooling, security policy and dependency-deny configuration; parser/duplicate/nesting hardening | **Reference only.** Authorization-schema and counterexample practices apply; principal/action/resource semantics do not replace UAM’s field/transform/rate/destination lattice. |
| flagd [`flagd/v0.16.1`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1) | Apache-2.0 | released 27 July 2026; schemas, conformance harness, security policy and dependency/timeout fixes | **Reference only.** Disabled-state/reason/sync ideas apply; dynamic contexts, multiple sources and percentage/person targeting must not become a parallel collection-authority plane. |
| Conftest [`v0.68.2`](https://github.com/open-policy-agent/conftest/tree/v0.68.2) | Apache-2.0 plus OPA/Go transitives | released 15 April 2026; unit/acceptance tests and security policy; embeds an older OPA than the separately reviewed current release | **Reference/optional isolated CI comparator only.** Structured-policy test workflow is useful; arbitrary Rego and many parser formats cannot become runtime or normative policy authority. |
| TUF specification [`v1.0.35`](https://github.com/theupdateframework/specification/tree/v1.0.35) | Community Specification License 1.0 | released 15 July 2026; governed versioned specification with release checks/history | **Reference only.** Threshold, expiry, rollback/freeze and root-rotation patterns inform signed artifacts; full repository-role/delegation machinery is unnecessary without a future update-repository need. |
| python-tuf [`v7.0.0`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0) | MIT and Apache-2.0 dual license | released 18 May 2026; maintained implementation with tests/security handling; release included Windows delegation-path fix | **Reference only.** Useful recovery/path edge cases; Python/update-repository semantics do not fit the C# endpoint privacy-authority boundary. |
| Backstage [`v1.53.1`](https://github.com/backstage/backstage/releases/tag/v1.53.1) | Apache-2.0 | released 29 July 2026; active large Node/TypeScript monorepo with tests/CI and plugin ecosystem | **Reference only.** Provenance/relation/catalogue ideas apply; plugin/integration surface and human-readable name-centric identity do not fit offline endpoint matching or realm isolation. |
| Envoy [`v1.39.0`](https://github.com/envoyproxy/envoy/releases/tag/v1.39.0) | Apache-2.0 | released 14 July 2026; mature tests/security maintenance; selected release contains CVE and parser/resource-bound fixes | **Reference only.** Typed host/path predicate/index fixtures are useful; first-match proxy semantics and broad C++ network-control surface are unsuitable. |
| osquery [`5.23.1`](https://github.com/osquery/osquery/releases/tag/5.23.1) | Apache-2.0 OR GPL-2.0-only | released 24 June 2026; mature tests/CI; selected security release fixes Windows process/authenticode heap overflows | **Reference only.** Valuable evidence that Windows metadata parsing is risky; broad SQL/table/command-line telemetry agent is explicitly outside UAM’s minimization and fixed-capability model. |
| uBlock Origin [`1.72.2`](https://github.com/gorhill/uBlock/releases/tag/1.72.2) | GPL-3.0 | released 8 July 2026; active parser/matcher tests | **Reference only; no code reuse.** URL indexing/fixture ideas apply, but copyleft and a highly expressive browser-filter grammar/precedence model do not fit UAM. |
| Z3 [`z3-5.0.0`](https://github.com/Z3Prover/z3/releases/tag/z3-5.0.0) | MIT | released 17 July 2026; CI, .NET bindings/examples, release/security-hardening work; complex solver can return `unknown` or consume significant resources | **Reference/optional offline cross-check only.** Exact finite analyzer remains authoritative; timeout or `unknown` must block rather than mean safe. |
| `dotnet/runtime` [`v10.0.10`](https://github.com/dotnet/runtime/releases/tag/v10.0.10), commit [`8f030f80c0dd2722eb2f618984e9db6784765963`](https://github.com/dotnet/runtime/commit/8f030f80c0dd2722eb2f618984e9db6784765963) | MIT plus component notices | release page dated 15 July 2026; very broad tests/build infrastructure and public security process | **Reference only.** Root build/test/generated-source conventions are useful; do not copy runtime-repository scale, Arcade complexity or broad friend-assembly patterns. |

---

# 12. Confidence by major conclusion and evidence that could change it

| Major conclusion | Confidence | Why | Evidence that would change it |
|---|---|---|---|
| The six foundation directions are mutually compatible | **High** | they independently enforce the accepted privacy, session, durability, realm and release invariants | a CLI result showing an accepted boundary cannot operate without violating another invariant |
| G0 classified deterministic package + independent oracle is the right prerequisite | **High** | directly makes every later claim reproducible, privacy-scoped and falsifiable | mutation evidence showing unavoidable common-mode error and a superior independently reviewable method |
| Strict separately owned contracts and local schema bundles are required | **High** | UAM has multiple trust/privacy/process/release boundaries and strict rejection contains drift | executable evidence that a more permissive mechanism preserves every privacy/security/rollback invariant with lower total risk |
| UUIDv7 is the common UAM identity profile | **High** | current standards-track definition and agreement between contract/registry designs; interoperable 128-bit form | collision/interop/privacy evidence or an approved external constraint requiring another standard profile and migration ADR |
| Field-specific normalization is safer than global NFC | **High** | JCS explicitly preserves strings and identity/display fields have different semantics | a field contract proving a different canonical form before signing/dedupe, with migration and confusable tests |
| G1 three-process and two-stage pipe blueprint is the right Windows direction | **High for topology; Medium for exact mechanisms** | accepted baseline plus documented Windows primitives | any primary G1 failure on an approved supported environment, especially inability to query identity without prohibited privilege |
| `LocalService` + restricted service SID + minimal privilege is viable | **Medium** | documented controls are appropriate; enterprise compatibility is untested | effective-token/access failure, required API needing prohibited privilege, or safer virtual-account evidence |
| Task Host restricted token/job/handles materially contains faults | **Medium** | documented mechanisms and mature design references; UAM runtime fit unproved | outside-scratch write, network/child escape, launch incompatibility, or human requirement for stronger same-user confidentiality |
| Physical IPC codec must be measurement-gated | **High** | three conflicting proposals and no UAM evidence; security state machine can be codec-neutral | a completed bake-off showing one candidate unequivocally meets all gates and is accepted by ADR |
| Typed privacy lattice and candidate failure split are correct | **High** | directly expresses tenant-only narrowing and prevents malformed-candidate DoS from becoming authority | a real requirement that cannot be represented finitely, with formal monotonic proof and migration evidence |
| RunIntent + independent User Host permit is the right composition | **Medium-High** | preserves Coordinator scheduling while ensuring the user-session side is not a passive deputy | lab evidence that secure permit transfer cannot be implemented without unacceptable complexity or weaker authority |
| UAM-owned application identity and deterministic ambiguity are correct | **High** | allowed reports explicitly lack durable identity/rule authority; guessing is unsafe | an approved source contract proving immutable source identity and a lower-risk migration, while still preserving UAM history |
| URL-host-only is the safe first matcher slice | **High** | aligns with accepted first slice and avoids path/process privacy/TOCTOU | human approval plus successful path/process privacy and Windows conformance gates |
| Governed monorepo is the right initial repository | **High** | supports atomic cross-boundary changes; no independent access/release requirement exists | approved legal/access/release separation that cannot be enforced by path/artifact controls, plus cross-repo provenance proof |
| R2 double clean build, reconciled SBOM/provenance and separate signing are required | **High** | direct containment of supply-chain substitution and promotion drift | selected toolchain proves a narrower control gives equivalent verifiable subject/input binding; unexplained differences remain a stop |
| Exact numeric limits and production capacity remain unknown | **High** | allowed evidence explicitly lacks representative distributions, budgets and SLOs | approved T3 measurements, synthetic load and identical operational/restore benchmark |
| Batch 01 is not production approval | **High** | human-decision and later-gate boundaries are explicit in I07–I09 | only designated human authorities and all later proof gates can change this status |

## 12.1 Exact conditions for updating the main technical baseline

This batch may update the main technical baseline only when:

1. the architecture forum accepts ADR-B01-001, 002, 003, 005, 006, 008, 009, 011, 013, 014 and 015;
2. the physical IPC and signed-control-artifact ADRs are either accepted from their experiments or remain explicitly provisional without production-shaped use;
3. all blocking owner functions in section 6 are assigned;
4. E-03 through E-10 and E-12 through E-14 pass using T1 data;
5. the supported Windows matrix is human-approved and E-17 through E-21 pass for every environment claimed;
6. `batch-01-gate.json` binds the exact evidence/ADRs/owners and contains no failed, expired or waived primary invariant;
7. the update text distinguishes accepted invariant, provisional implementation and human decision; and
8. no later-batch component is silently redesigned.

The baseline update may then add the accepted Batch 01 refinements in section 2. It must leave exact limits, codec until decided, crypto/key profile, real fields, retention, access, production Windows scope, production signing, process/path matching, capacity and production approval provisional.

## 12.2 Unresolved risks and blocked dependencies

**UNKNOWN.** Until the conditions above are met, the batch remains blocked on:

- accountable contract, test-data, G1, privacy, registry, release and incident owners;
- physical IPC/permit cryptographic profile;
- effective Windows task/service/token/ACL/firewall behavior;
- policy/signing key and clock/offline decisions;
- validator/tool/dependency admission and CI platform selection;
- production source/field/precision/purpose/retention/access decisions;
- later G2–G5 runtime evidence and all later capacity/outage/deletion/restore gates.

**Final stop condition:** any forbidden value crossing the endpoint privacy boundary, cross-session/realm authority failure, cursor-ahead commit, premature receipt, retry double effect, unauthorized release, unacknowledged-data loss, or restore/deletion visibility failure stops dependent implementation and requires an explicit ADR/change proposal. There is no silent risk acceptance in code.

---

# Appendix A. Primary public source register

| Ref | Primary source, date/version reviewed | Load-bearing claim and limitation |
|---|---|---|
| W01 | Microsoft, [.NET and .NET Core support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core), reviewed 31 July 2026 | .NET 10 active LTS; 10.0.10 dated 14 July 2026; support through 14 November 2028. Point-in-time lifecycle evidence, not UAM compatibility proof. |
| W02 | IETF/RFC Editor, [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/rfc/rfc8785.html), June 2020 | invariant JSON for hashing/signing; duplicate-free I-JSON constraints; strings preserved as-is and no Unicode normalization. Informational RFC; UAM must test implementation. |
| W03 | IETF, [RFC 9562 — UUIDs](https://datatracker.ietf.org/doc/html/rfc9562), May 2024 | standards-track UUID and UUIDv7 layout/best practices. Does not make timestamp authoritative business evidence. |
| W04 | JSON Schema, [Draft 2020-12 Core](https://json-schema.org/draft/2020-12/json-schema-core), 2020-12 | structural schema dialect. Validator conformance/resource safety still requires CLI evidence. |
| W05 | OpenAPI Initiative, [OpenAPI Specification 3.2.0](https://spec.openapis.org/oas/v3.2.0.html), published 19 September 2025 | current specification existence. UAM tool support is unproved; initial 3.1.2 profile is provisional. |
| W06 | NuGet, [`System.Formats.Cbor`](https://www.nuget.org/packages/System.Formats.Cbor), package page reviewed 31 July 2026 | distributed through PackageReference; exact version and package admission are execution-time decisions. |
| W07 | Microsoft Open Specifications, [`TASK_LOGON_GROUP` behavior](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-tsch/849c131a-64e4-46ef-b015-9d4c599c5167), reviewed 31 July 2026 | group task runs in interactive session for any logged-on member. Does not prove UAM’s XML/GPO/duplicate behavior. |
| W08 | Microsoft Learn, [Service changes / required privileges](https://learn.microsoft.com/en-us/windows/win32/services/service-changes-for-windows-vista), reviewed 31 July 2026 | SCM can remove undeclared privileges and service SIDs can isolate objects. Effective configuration still measured. |
| W09 | Microsoft Learn, [`SERVICE_SID_INFO`](https://learn.microsoft.com/en-us/windows/win32/api/winsvc/ns-winsvc-service_sid_info), reviewed 31 July 2026 | restricted service SID enters restricted list; change takes effect next system start. |
| W10 | Microsoft Learn, [`GetNamedPipeClientProcessId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeclientprocessid), updated 22 February 2024 | retrieves named-pipe client PID; PID alone is insufficient authority. |
| W11 | Microsoft Learn, [`GetNamedPipeServerProcessId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeserverprocessid), updated 22 February 2024 | retrieves named-pipe server PID; must be bound to SCM/process/release evidence. |
| W12 | Microsoft Learn, [`GetNamedPipeClientSessionId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeclientsessionid), updated 22 February 2024 | retrieves client session ID; logon SID/LUID/token checks remain required. |
| W13 | Microsoft Learn, [`GetNamedPipeServerSessionId`](https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getnamedpipeserversessionid), updated 22 February 2024 | retrieves server session ID. |
| W14 | Microsoft Learn, [`CreateRestrictedToken`](https://learn.microsoft.com/en-us/windows/win32/api/securitybaseapi/nf-securitybaseapi-createrestrictedtoken) and [Restricted Tokens](https://learn.microsoft.com/en-us/windows/win32/secauthz/restricted-tokens), reviewed 31 July 2026 | privilege deletion, restricting SIDs, double access check and restricted-process capability. Not a complete same-user sandbox. |
| W15 | SQLite, [Release History](https://www.sqlite.org/changes.html), 3.53.4 dated 24 July 2026 | current reviewed release/source ID and WAL-reset bug history. Managed provider version does not prove native code. |
| W16 | IETF/RFC Editor, [RFC 8949 — CBOR](https://www.rfc-editor.org/rfc/rfc8949.html), December 2020 | CBOR and deterministic encoding design basis. Does not select it for UAM. |
| W17 | IETF/RFC Editor, [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html), July 2023 | standard HTTP problem shape; UAM still defines safe codes/retry/redaction. |
| W18 | IETF/RFC Editor, [RFC 9530 — Digest Fields](https://www.rfc-editor.org/rfc/rfc9530.html), February 2024 | HTTP content-digest semantics; digest is integrity, not sender authentication. |

# Appendix B. Decision/ADR template

```markdown
# ADR-<id> — <title>

Status: Proposed | Accepted | Rejected | Superseded
Date:
Accountable owner:
Support owner:
Affected baseline decision/invariants:
Evidence labels:

## Decision

## Context and trust/privacy boundary

## Alternatives and trade-offs

## Primary evidence and reviewed versions/dates

## Security/privacy/realm/durability impact

## Smallest falsifying CLI experiment

## Pass/fail and stop behavior

## Migration, compatibility, rollback and cleanup

## Dependencies, license and operations

## Human decisions not made here

## Review triggers
```

# Appendix C. Human-decision record template

```yaml
id: HD-000
question: ""
accountableRole: "UNASSIGNED"
consultedRoles: []
requiredByGate: ""
conservativeDefaultUntilDecision: "disabled"
options: []
evidenceNeeded: []
consequenceOfDelay: ""
decision: null
decidedAt: null
reviewTrigger: ""
```

---

# Final residual risk, blocked dependencies and baseline-update condition

**UNKNOWN.** Batch 01 still carries material residual risk in Windows token/task/ACL/firewall behavior; local IPC codec and permit authentication; policy/signing key custody, clock and offline recovery; oracle common-mode error; scanner false negatives; URL/Windows normalization; dependency and CI-platform fitness; and all later durability, capacity, outage, deletion and restore claims.

**Blocked dependencies.** Production-shaped work remains blocked by unassigned accountable owners; unresolved ADR-B01-004 and the production profile under ADR-B01-007; strict-parser/validator and dependency admission; the approved Windows support matrix and successful G1 campaign; human purpose/source/field/precision/retention/access decisions; and the ordered G2–G5 gates. Production signing, pilot and production deployment additionally remain blocked by signing, support, budget, SLO/RPO/RTO and risk authorities.

**Exact baseline-update condition.** This batch may update the main technical baseline only when the mandatory ADRs named in section 12.1 are accepted, all blocking owner functions are assigned, the required T1 CLI experiments pass without expired exception, every claimed Windows environment passes the primary G1 gate, and an immutable `batch-01-gate.json` binds the exact inputs, ADRs, owners, tool/native versions, evidence and cleanup results. The update may add only the accepted refinements in section 2. It must keep the physical IPC profile until decided, production crypto/key profile, exact limits, live fields/sources, retention/access, process/path matching, production support matrix, capacity, signing, pilot and production approval explicitly provisional.

**Non-waivable stop rule.** Any forbidden value crossing the endpoint privacy boundary; cross-session or cross-realm authority failure; cursor-ahead commit; premature durable receipt; replay creating more than one business effect; unauthorized/stale/downgraded release execution; silent loss of unacknowledged data; or restore making deleted data visible stops dependent work and requires an explicit change proposal and ADR. It cannot be accepted silently in code, configuration or an expired exception.
