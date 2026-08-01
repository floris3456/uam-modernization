# UAM product privacy ceiling and tenant-policy narrowing

**Result path:** `batches/01-foundations/05-privacy-ceiling-tenant-policy/result-05-privacy-ceiling-tenant-policy.md`  
**Research date:** 31 July 2026  
**Target path:** `batches/01-foundations/05-privacy-ceiling-tenant-policy/result-05-privacy-ceiling-tenant-policy.md`  
**Status:** proposed refinement of the accepted baseline; not production approval  
**Endpoint platform:** Windows  
**Default implementation family:** C#/.NET  
**Evidence boundary:** only the four allowlisted project attachments were used; all examples are fictional or synthetic  

## How to read this result

The evidence labels have the meanings required by the project research rules [I-04]. In this document, **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** are UAM design requirements, not quotations from an external standard. “Narrower” means permitting no additional collection, detail, capability, destination, diagnostic information, frequency, lookback, or retention compared with another policy.

Internal references are listed in section 15 as `I-*`; public primary sources are listed as `S-*`; reviewed open-source repositories are listed as `R-*`.

---

# 1. Executive conclusion

## 1.1 Decision

**RECOMMENDATION — High confidence.** Implement the privacy control as a small, release-owned, typed policy lattice. The product release carries a signed **product privacy ceiling**. A tenant policy is a separately signed, realm-bound artifact that can select only identifiers and bounds already authorized by that ceiling, and only in a direction formally proved to be narrower. Do not put a general-purpose rule language, script engine, regular expressions, arbitrary URLs, or remotely supplied executable logic on the endpoint.

In easy language: the software release defines the largest box the product is technically allowed to operate inside. A tenant can make that box smaller, switch parts off, choose a more minimizing transformation, reduce frequency, shorten lookback, reduce diagnostics, or disable a destination. A tenant can never make the box larger. If software cannot prove that a policy is valid, current, compatible, correctly signed, for the right realm, and no broader than the release ceiling, that policy creates no collection permission.

The effective authorization is the meet/intersection of all applicable restrictions:

```text
Effective = ProductCeiling
          ∧ TenantPolicy
          ∧ ProductEmergencyNarrowing
          ∧ TenantEmergencyNarrowing
          ∧ LocalSafetyDisablement
          ∧ RuntimeCapabilityAvailability
```

For every evaluation, the implementation MUST assert:

```text
Effective ⪯ ProductCeiling
```

where `x ⪯ y` means “x is no broader than y.” If the relation cannot be decided, evaluation fails closed.

## 1.2 Primary gate

**RECOMMENDATION — High confidence.** The implementation gate is:

> Invalid, expired, unsupported, wrong-realm, rollback, same-revision-conflict, unknown, or broader policy produces zero new collection and a durable, audited, privacy-safe health state.

This is applied precisely as follows:

1. A bad **candidate** never grants a permit and never replaces a valid cached active policy.
2. A malformed or merely unsupported candidate may be quarantined while an unexpired, already-active last-known-good policy continues, because the candidate contributes zero new permission.
3. A candidate indicating probable compromise—invalid signature, wrong realm, unauthorized key, revision rollback, conflicting content at the same revision, broken chain, or attempted broadening—moves the endpoint into `SafetyHold`; all new collection stops until a verified recovery artifact or approved local recovery action succeeds.
4. If the active policy or ceiling is expired, absent, corrupted, unsupported after upgrade, or cannot be related to a trusted ceiling, all collection is disabled. There is no indefinite “keep collecting while offline” exception.

This distinction avoids allowing a trivial malformed candidate to become a remote denial-of-service primitive, while still treating security-significant evidence as an incident.

## 1.3 Why this is the simplest safe design

**FACT.** The accepted baseline already requires a release-authorized ceiling, tenant-only narrowing, endpoint minimization before IPC/storage/logging/transport, a Coordinator/User Host/Task Host boundary, realm isolation, and synthetic data for the first Edge site/domain slice until governance permits otherwise [I-01][I-02].

**INFERENCE.** A constrained typed evaluator fits those decisions better than embedding OPA, Cedar, flagd, or another expressive runtime on endpoints. Those projects contain useful ideas—formal authorization semantics, differential testing, update metadata, configuration tests, kill-switch delivery—but their threat models permit richer expressions, dynamic contexts, remote sources, or general authorization decisions. Those features would enlarge UAM’s policy attack surface and make “tenant policy can only narrow” harder to prove.

**FACT.** JSON object member duplication is interoperability-dangerous, JSON Canonicalization Scheme requires deterministic canonical JSON, JWS General JSON Serialization permits multiple signatures, and ES256 has a defined fixed signature representation [S-03][S-04][S-05][S-06]. These are suitable building blocks for signed data artifacts, provided UAM fixes its algorithms and key rules rather than trusting an artifact to choose them.

**INFERENCE.** No single ordinary plane can broaden collection when authority is split and each boundary rechecks: the portal/API cannot sign; the tenant signer can only sign a schema that references release-owned IDs; the endpoint independently proves monotonicity; User Host and Task Host validate a short-lived permit; Coordinator validates minimized output; the server validates the output schema and provenance; and the server derives realm from authenticated registration rather than payload claims.

## 1.4 Confidence and residual risk

**Confidence: High** for the typed monotonic model, fail-closed behavior, strict parsing, revision rules, realm binding, and independent enforcement. These follow directly from accepted invariants, mature signature/canonicalization standards, and well-understood security design. Confidence would fall if a real requirement demands arbitrary tenant expressions, tenant-defined data transformations, tenant-defined destinations, or person-level dynamic targeting.

**Confidence: Medium** for the exact signing profile, key hierarchy, expiry/clock behavior, operational cardinality caps, and rollout timings. They are implementable, but final choices depend on enterprise PKI/KMS/HSM capability, offline duration, Windows clock behavior, support staffing, and measured runtime cost.

**Residual risk.** A legitimately signed malicious product binary, a compromised Windows kernel, hostile endpoint administrator, signer/key-custody collusion, incorrect release-authored transformation, or a server/portal defect can still violate privacy. Separation, threshold approval, independent checks, canary scans, incident containment, and audit reduce those risks but cannot prove them away. Legal purpose, notice, consultation, source/field approval, prohibited uses, identity/time precision, retention, approvers, emergency authority, and production go-live remain human decisions.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

**RECOMMENDATION.** This result defines:

- the signed product ceiling and signed tenant-policy artifact models;
- a formal partial order and meet operation for sources, fields, transformations, capabilities, destinations, diagnostics, targeting, and numeric bounds;
- authority, key, signing, publication, cache, activation, rollback, expiry, and compatibility behavior;
- enforcement in Task Host, User Host, Coordinator, server, portal, and release pipeline;
- typed feature flags, kill switches, policy simulation, impact preview, audit, safe recovery, and realm isolation;
- privacy-safe error, logging, metrics, support-bundle, incident, and runbook requirements;
- negative, property, crash, cross-version, canary, and recovery tests;
- the minimum CLI/lab evidence needed to accept implementation.

## 2.2 Non-goals

**FACT.** This result does not redesign the accepted endpoint process topology, SQLite outbox, transport, durable server inbox, central database choice, release ownership by MSI/enterprise deployment, or the Edge acquisition method [I-01][I-02].

**HUMAN DECISION.** It does not approve legal purpose, lawful basis, employee notice/consultation, prohibited uses, production sources, fields, hard-deny classes, identity level, time precision, retention, portal access, policy approvers, emergency authority, SLO/RPO/RTO, staffing, budget, or production deployment.

**UNKNOWN.** It does not prove actual Windows session behavior, key storage, TPM availability, proxy/VPN behavior, offline duration, clock reliability, performance, operational competence, or support load. Those need CLI/lab and owner evidence.

## 2.3 Accepted internal inputs

| Ref | Evidence label | Accepted input | Consequence for this design |
|---|---|---|---|
| I-01 | **FACT** | A release-authorized ceiling limits sources, fields, transformations, destinations, and capabilities; tenant policy only narrows it. | This is refined, not reopened. |
| I-01 | **FACT** | Minimize before Coordinator IPC, durable storage, logs, diagnostics, or transport. | Raw values never become policy-evaluation diagnostics or Coordinator payloads. |
| I-01 | **FACT** | Low-privilege Coordinator; ordinary-token User Host per session; restricted, short-lived Task Hosts. | Policy is checked independently at each relevant process boundary. |
| I-01 | **FACT** | User-owned sources are read in the user session; Coordinator does not crawl profiles or mint user tokens. | Permits are bound to session and source; no machine service fallback collection. |
| I-01 | **FACT** | C#/.NET is the default implementation family; exact patches are selected at execution time. | The reference evaluator and tests are .NET-native, with point-in-time dependency review. |
| I-01 | **FACT** | UAM telemetry is fallible evidence, not sole forensic proof or a productivity score. | Policy/schema metadata must preserve uncertainty and forbid score-like inference as a product capability unless separately authorized in a future ceiling. |
| I-02 | **FACT** | Proof-gate order places purpose/source/dummy-data first and privacy transformation/canary containment at G4. | Real collection remains disabled until G0; G4 blocks downstream work. |
| I-02 | **FACT** | Browser acquisition is short read-only, Online Backup fallback, then defer; never raw copy of live main/WAL/SHM. | Policy cannot enable a different acquisition path. |
| I-03 | **FACT** | Catalogue has 173 unique names; 5 missing external IDs; no role, ownership, rule, entitlement, or usage dimensions. | Targeting and matching cannot infer policy from names; UAM stable IDs are required. |
| I-04 | **FACT** | Research labels, evidence hierarchy, human boundaries, and CLI proof requirements. | Claims and implementation gates use those labels. |

## 2.4 Assumptions

| ID | Assumption | Consequence if false |
|---|---|---|
| A-01 | **ASSUMPTION.** A product release can embed or securely install a trusted product root and exact ceiling digest. | A separate bootstrap/attestation design is required before any collection. |
| A-02 | **ASSUMPTION.** Enrollment can bind an endpoint to one realm and a realm-scoped tenant-policy trust anchor. | Realm isolation cannot be established; collection stays disabled. |
| A-03 | **ASSUMPTION.** The control plane can publish immutable artifacts addressed by digest and can retain superseded metadata for audit/recovery. | Add an immutable artifact store or use enterprise deployment for policy packages. |
| A-04 | **ASSUMPTION.** The supported .NET release at implementation time exposes adequate strict UTF-8 JSON tokenization and approved cryptography. | Add a reviewed library or native boundary; re-run dependency and FIPS/crypto review. |
| A-05 | **ASSUMPTION.** A small finite registry of source, field, transformation, capability, destination, diagnostic, and task-host profile IDs can cover initial slices. | The schema must evolve, but tenant-supplied executable expressions remain prohibited. |
| A-06 | **ASSUMPTION.** Device/cohort targeting can be represented by opaque enrollment-owned IDs without HR/person attributes. | A separate privacy review and ceiling capability are required for any richer targeting. |

## 2.5 Unknowns and temporary defaults

| Unknown | Conservative temporary default | Evidence needed to replace it |
|---|---|---|
| Approved purpose and production sources | **HUMAN DECISION:** synthetic provider only; real collectors disabled. | G0 signed purpose/source/dummy-data contract. |
| Exact fields, identity and time precision | No production field authorization; examples are non-normative. | Privacy/legal/owner approval plus canary tests. |
| Hard-deny categories | Deny all unapproved categories; release schema supports an explicit immutable deny registry. | Approved prohibited-use/data-class decision. |
| Policy validity length and offline grace | No grace beyond signed expiry; clock uncertainty disables collection. | Offline/clock lab results and risk decision. |
| Product and tenant signing quorum | Product ceiling/root SHOULD use threshold approval; exact quorum is unset. | Key-custody threat model, KMS/HSM capability, emergency authority decision. |
| Endpoint key storage/encryption | Artifacts are not secrets; signatures are mandatory. Cache encryption is separate and unset. | Device/TPM/DPAPI threat and recovery test. |
| Evaluation latency and memory budget | No architecture number is asserted. | Benchmarks on minimum supported Windows hardware. |
| Metric series caps | Start with strict implementation guards proposed in section 9; tune downward/upward by synthetic load. | Cardinality/memory measurements and observability owner approval. |
| Rollout percentages/timing | No fixed percentages or durations. | Fleet segmentation, support capacity, incident-response rehearsal. |
| Old-agent support horizon | Old agent receives a compatible signed variant or collects nothing new. | Lifecycle policy and compatibility matrix. |

---

# 3. Recommended design: responsibilities and trust boundaries

## 3.1 Formal privacy authority model and monotonic-narrowing algorithm

Let the product ceiling be `C`, tenant policy be `T`, product emergency overlay be `EP`, tenant emergency overlay be `ET`, local safety state be `L`, and runtime capability availability be `R`.

Define `x ⪯ y` to mean every operation and output permitted by `x` is also permitted by `y`, and `x` reveals no more information than `y`. `⊥` means disabled/no collection. The effective authorization is:

```text
E = C ∧ T ∧ EP ∧ ET ∧ L ∧ R
```

The evaluator MUST satisfy:

```text
E ⪯ C
E ⪯ T             when T is active
E ⪯ EP, ET, L, R   when those restrictions apply
x ∧ x = x
x ∧ y = y ∧ x
(x ∧ y) ∧ z = x ∧ (y ∧ z)    for supported dimensions
x ⪯ y  ⇒  x ∧ y = x
T₂ ⪯ T₁ ⇒ Eval(C,T₂) ⪯ Eval(C,T₁)
```

A transform relation that lacks a unique safe meet is not approximated; it is rejected. A missing field, unknown enum, unknown ID, unsupported schema, duplicate member, malformed number, overflow, non-canonical signed payload, or ambiguous relation never widens through a default.

### 3.1.1 Dimension order

| Dimension | Meaning of `x ⪯ y` | Safe meet `x ∧ y` | Reject condition |
|---|---|---|---|
| Source set | `x.sources ⊆ y.sources` | Set intersection | Unknown source ID |
| Field set | `x.fields ⊆ y.fields` | Set intersection | Field not authorized for source/transform/output schema |
| Capability set | `x.capabilities ⊆ y.capabilities` | Set intersection | Capability absent from release registry or hard-denied |
| Destination set | `x.destinations ⊆ y.destinations` | Set intersection | Tenant-provided URI, address, protocol, or unknown destination |
| Enabled boolean | `false ⪯ true` | Logical AND | Non-boolean/coercion |
| Maximum lookback, events, bytes, retries, diagnostics detail | Lower or equal is narrower | Minimum | Negative, overflow, unit ambiguity, ceiling excess |
| Minimum interval between runs | Greater or equal is narrower | Maximum | Zero/negative or violates release bounds |
| Time precision | Coarser or equal is narrower according to release registry | Registry meet | Tenant-supplied unit/rank or incomparable options |
| Identity precision | Less identifying or equal according to release registry | Registry meet | Tenant-supplied algorithm/rank or incomparable options |
| Transform | Output is no more revealing according to release-authored DAG | Unique greatest lower bound in DAG | No relation, cycle, ambiguity, or multiple incomparable meets |
| Diagnostic level | Less detailed or equal in release-authored order | Less detailed level | Unknown level or properties outside level allowlist |
| Target set | Subset of realm-owned opaque device/cohort IDs | Set intersection | Cross-realm, user/HR attribute, unbounded selector, unknown target type |
| Validity interval | Shorter contained interval | Interval intersection | Empty interval, invalid clock relation, expiry beyond ceiling/key validity |

**RECOMMENDATION.** Numeric values always carry an unambiguous schema-defined unit in the field name, such as `maxLookbackSeconds`. The parser rejects floating-point values for discrete limits. Bounds use checked integer arithmetic.

### 3.1.2 Transform lattice, not a tenant rank

The release authors define each transform profile as reviewed code plus an output schema and a directed acyclic narrowing graph. Define an edge `A -> B` as “B is proven at least as minimizing as A.” The evaluator computes reachability from the release registry, not from tenant-supplied numbers or labels.

Fictional example only:

```text
url.full.v1  -> site.domain.v1 -> site.token.daily.v1 -> count.only.daily.v1
                   \----------> category.daily.v1
```

The first node would be hard-denied for the initial product and therefore absent from the actual ceiling; it appears only to illustrate order. `category.daily.v1` and `site.token.daily.v1` may be incomparable. If a meet is required and no unique safe node exists, evaluation returns `POLICY_TRANSFORM_INCOMPARABLE`; it does not guess.

Each transform registry entry MUST bind:

- immutable transform ID and semantic version;
- implementation assembly/type digest or generated-code identity;
- authorized input field IDs;
- exact output schema ID and output field IDs;
- normalization, bucketing, truncation, hashing/tokenization, salt/key purpose, and error behavior where applicable;
- narrowing edges and machine-checked acyclicity;
- forbidden-canary test corpus version;
- deterministic conformance vectors or an explicit reason nondeterminism is safe;
- release approval evidence digest.

Tenant policy can select a release-authored transform ID only. It cannot supply code, regular expressions, scripts, templates, salts, hash algorithms, token keys, browser paths, SQL, or query expressions.

## 3.2 Product privacy ceiling

**RECOMMENDATION.** The ceiling is a signed, immutable, release-specific authorization manifest. It is not a default tenant policy and does not by itself enable collection. It defines the maximum syntactically representable and executable behavior for that exact release.

The ceiling MUST cover at least:

1. **Sources:** fixed IDs, source generation/version, eligible user/session context, approved acquisition mode, supported Windows/browser range, and task-host profile.
2. **Fields:** input classifications, allowed output fields, nullable/unknown behavior, identity/time precision choices, and hard-deny markers.
3. **Transformations:** reviewed profile registry and narrowing DAG.
4. **Capabilities:** source read, transform, local commit, upload, support diagnostic, policy simulation inventory, and any privileged operation. Arbitrary plugin/script/command execution is not a capability.
5. **Destinations:** fixed product endpoints such as Coordinator IPC, endpoint outbox, and authenticated ingest API, represented by product IDs. Tenant policy never contains an address.
6. **Diagnostic levels:** fixed ordered levels and exact property allowlists.
7. **Runtime limits:** lookback, frequency, events/run, bytes/run, CPU/memory/time budgets where approved, and permit lifetime bounds.
8. **Hard-deny registry:** prohibited data classes, capabilities, sources, destinations, and transformations that cannot be enabled by any tenant artifact.
9. **Output schemas:** minimized event and provenance schemas accepted by Coordinator and server.
10. **Metric contract:** instrument names, fixed attributes, enum domains, and hard cardinality behavior.
11. **Compatibility:** interpreter version range, agent build IDs, migration rules, and deprecation date.
12. **Authority:** product ID, release ID, ceiling sequence, product root/key IDs, signature threshold, validity, and previous ceiling digest.

**HUMAN DECISION.** Exact approved entries are not selected here. Until G0 is approved, the real ceiling MUST expose only synthetic source IDs. Illustrative hard-deny IDs in examples are fictional and must not be mistaken for approval.

## 3.3 Tenant policy

**RECOMMENDATION.** A tenant policy is a complete, typed, signed desired state for one realm and one policy stream. It references the exact product ceiling digest and release compatibility. It can:

- disable all collection;
- enable only a subset of ceiling sources;
- select fewer output fields;
- choose an equal or more minimizing release-authored transform;
- reduce maximum lookback/events/bytes/diagnostic detail;
- increase minimum collection interval;
- remove destinations/capabilities;
- target a subset of realm-owned opaque cohorts/devices;
- activate signed emergency disable overlays;
- set privacy-affecting feature flags only to release-defined narrowing states.

It cannot:

- define a new source, field, transform, capability, destination, task-host profile, metric, schema, or diagnostic property;
- contain executable code, SQL, PowerShell, command lines, regular expressions, file paths, browser profile paths, dynamic expressions, or tenant URLs;
- select a more precise identity/time level or a less minimizing transform;
- target by user email, username, HR property, application name, free text, or production activity;
- extend beyond the ceiling/key validity window;
- reduce a revision number or reuse a revision with different content;
- request a different realm or claim server routing information.

## 3.4 Component responsibilities

| Component/plane | Normative responsibilities | Must not be trusted to do alone | Compromise containment |
|---|---|---|---|
| Product privacy authority | Own source/field/transform/capability/destination registries; approve and threshold-sign ceiling digest; approve hard-deny and transform-order changes. | Build or publish binaries; create tenant policy; operate endpoint. | Its signature alone cannot produce an executable release; release manifest and endpoint checks are also required. |
| Build pipeline | Build deterministic artifacts; run schema, property, conformance, canary, SAST/dependency/SBOM tests; produce provenance. | Hold product privacy signing key or tenant key; alter approved ceiling after attestation. | A compromised build cannot authorize a different ceiling without independent signatures. |
| Release authority/repository | Verify build and privacy attestations; sign binary manifest binding exact hashes and ceiling digest; publish immutable-by-digest artifacts; enforce freeze/rollback metadata. | Author privacy semantics or tenant policy. | Repository alteration fails signatures/digests; release signer alone cannot broaden the independently signed ceiling. |
| Tenant portal/control API | Provide typed editor, diff, simulator, impact preview, approval workflow, audit, and emergency-disable request. | Possess online signing key in the web process; emit raw free-form policy; bypass approval. | Compromise can propose but cannot sign/activate; signer revalidates schema, realm, revision, and ceiling monotonicity. |
| Realm policy signer | Verify approval attestation and independently re-evaluate candidate against referenced ceiling; sign realm-bound artifact; keep key in isolated KMS/HSM or equivalent. | Trust portal’s “valid” flag; sign cross-realm or broader policy. | Tenant key can only sign artifacts that endpoints prove are narrower; wrong-realm artifacts fail pinned trust. |
| Artifact distribution | Serve signed artifacts and revocation/rotation metadata; support immutable digest retrieval. | Determine validity, defaults, or activation. | Tampering/replay/freeze detected by signature, expiry, sequence, chain, and endpoint state. |
| Coordinator Service | Verify installed release/ceiling binding; cache artifacts transactionally; verify realm, revision, expiry, signatures and compatibility; calculate local safety state; validate minimized outputs and provenance; atomically commit output/cursor. | Read user-owned sources; construct arbitrary user tokens; accept raw values; decide tenant policy by itself. | A compromised Coordinator cannot force a compliant User Host/Task Host to read without a valid permit; server rejects invalid output. OS/admin compromise remains residual. |
| User Host | Independently verify effective source authorization for its session; create a signed/MACed short-lived permit request/response binding session, source and policy digests; invoke only fixed Task Host entry points; minimize before IPC. | Accept Coordinator command text or arbitrary collector; send raw values to Coordinator/logs. | Coordinator command injection cannot select unknown source or fields; Task Host also rechecks permit. |
| Task Host | Verify permit signature/MAC, source ID, session binding, transform/output schema, expiry and executable profile; read only fixed source using fixed code; transform in memory; emit schema-valid minimized result; clear buffers and exit. | Interpret tenant expressions; choose destination; retain raw cache; log source values. | A compromised User Host cannot ask a compliant Task Host for a broader source/field than permit/ceiling; Task Host compromise is bounded by OS sandbox and Coordinator/server validation. |
| Server ingestion boundary | Authenticate device; derive realm/device from registration; validate release/ceiling/policy/permit provenance, schema, field set, sizes and hard-deny canaries before durable semantic acceptance; quarantine violations. | Trust payload realm or “policy valid” claims; broaden or repair disallowed output. | Endpoint compromise cannot route across realm or introduce unknown fields without rejection/quarantine. |
| Server workers/materializer | Enforce typed schemas and realm partitioning; preserve provenance and quality flags; never infer disallowed detail. | Treat receipt as semantic acceptance; use raw/quarantined payload in portal. | Poison/overbroad batches remain quarantined and invisible. |
| Portal/BFF | Enforce realm-scoped authorization, accessible policy diff/simulation, audit, and field-level presentation; show health without sensitive identifiers. | Query across realm, expose policy bodies in telemetry, or derive productivity scoring. | Server-side realm derivation and query guards limit client compromise; privileged mutations require durable audit. |
| Support/incident tooling | Use fixed error codes, bounded support bundles, signed recovery actions, canary scanner, revocation and cleanup runbooks. | Collect raw history, policy bodies, paths, usernames, URLs, or credentials for convenience. | Support compromise does not yield raw source data; emergency actions narrow or stop only. |

## 3.5 Trust-boundary enforcement sequence

A normal collection run MUST follow this sequence:

1. Coordinator verifies the installed release manifest and its exact ceiling digest before entering collection-capable state.
2. Coordinator loads only a transactionally active, unexpired policy for the pinned realm and computes an effective authorization.
3. User Host independently receives the signed ceiling subset and policy proof needed for its source, re-evaluates that source, and requests a run permit.
4. Coordinator issues a short-lived permit only if current state remains active. The permit binds realm, device installation, Windows logon/session identity handle, source generation, source ID, transform ID, output schema, field IDs, numeric bounds, policy digest, ceiling digest, effective time, expiry, nonce, and executable/task-host profile digest.
5. Task Host verifies the permit locally and refuses unknown or stale values. It reads the fixed source, minimizes in process memory, validates the output schema, clears raw buffers, and returns only minimized output to User Host.
6. User Host rejects any output not matching the permit and transfers only minimized records over authenticated, session-bound IPC.
7. Coordinator revalidates permit currency and output schema/fields/limits, then commits minimized events plus source cursor atomically under the accepted SQLite one-writer model.
8. Upload includes bounded provenance. The server derives realm/device from the authenticated channel, rechecks release/ceiling/policy/output compatibility and hard-deny canaries, then stores or quarantines according to the durable inbox contract.
9. Portal exposes only validated/materialized typed data and policy-safe health/audit information.

A policy narrowing that becomes effective during a run MUST stop issuing permits, cancel affected Task Hosts, reject results produced after the effective instant if no longer authorized, and avoid cursor advancement for discarded results. There is no “let the broader run finish” exception.

## 3.6 Authority and trust model

**RECOMMENDATION.** Use distinct trust domains and keys:

```text
Offline/strongly protected Product Root (threshold)
  ├─ Product Privacy Ceiling keys (threshold recommended)
  ├─ Product Release Manifest keys
  └─ Product Recovery/rotation keys

Realm Enrollment Trust Binding
  └─ Realm Tenant-Policy key(s)
       └─ Realm Emergency-Disable key or constrained signer
```

Rules:

- Product root and ceiling signatures MUST be independent of the ordinary build service identity.
- The release manifest MUST bind binary/package hashes and one exact ceiling digest. A binary cannot substitute a different ceiling at runtime.
- Product ceiling changes that broaden any dimension MUST be visible as such in a generated privacy diff, require the designated human approval, and create a new ceiling sequence/release. A tenant policy cannot cause that change.
- Realm policy keys MUST be realm-scoped. An endpoint pins the realm trust binding at enrollment; a payload `realmId` is only a consistency check, not routing authority.
- Key IDs are allowlisted. Protected JWS headers MUST use a fixed profile; remote `jku`, `x5u`, embedded untrusted `jwk`, arbitrary critical headers, and input-selected algorithms are prohibited.
- Revocation and rotation MUST be versioned and signed by an already trusted predecessor or product root, with overlap sufficient for approved offline behavior. Exact overlap is a measurement/human decision.
- Product ceiling/root SHOULD require M-of-N signatures so one stolen key cannot broaden a release. Exact M and N are a human/key-custody decision.
- Tenant approval and cryptographic signing are separate events. The signer verifies an approval attestation but also independently runs the same canonical schema and monotonicity engine.
- Emergency authority can only sign a short-lived narrowing overlay, normally `disable all` or a release-defined subset disable. It cannot sign broader ordinary policy.

## 3.7 Signing and publication flow

```text
Ceiling registry change
  -> typed review + generated privacy diff
  -> schema/lattice/conformance/canary tests
  -> human privacy authorization attestation
  -> threshold ceiling signatures
  -> build and SBOM/provenance
  -> release signer verifies all attestations
  -> release manifest binds package hashes + ceiling digest
  -> immutable publication by digest
  -> enterprise deployment installs package + trust metadata

Tenant desired-state change
  -> portal creates typed candidate only
  -> server canonical parser + monotonic evaluator
  -> simulation/impact preview on non-activity inventory
  -> required human approval attestation
  -> isolated realm signer repeats validation
  -> JWS signatures over canonical payload
  -> immutable publication by digest and stream revision
  -> endpoint candidate verification
  -> staged/canary activation
  -> fleet expansion
```

The build plane cannot sign; the portal cannot sign; the repository cannot change content; the signer cannot make endpoints accept a broader policy; and the server cannot initiate a source read. This is the practical meaning of “no single compromised plane can broaden collection.”

**Residual limitation.** A malicious product binary signed through all product authorities, collusion among threshold holders, or a compromised endpoint OS/kernel can bypass software boundaries. Those are addressed by release governance, reproducible builds/provenance, code review, endpoint hardening, incident response, and independent canary monitoring, not by tenant-policy algebra alone.

## 3.8 Feature flags and kill switches

All flags MUST be declared in the product ceiling registry with one of these types:

| Flag class | Allowed effect | Signing/activation rule | Example (fictional) |
|---|---|---|---|
| Privacy narrowing | Disable source/field/capability/destination; choose a more minimizing transform; lower diagnostic level. | Tenant policy or short-lived signed emergency overlay. | `edge.site-collection.enabled=false` |
| Operational non-collection | Change retry jitter, UI text variant, or internal scheduling behavior only inside release bounds, with proof it cannot change collected values/volume/destination. | Signed operational config, separately typed; endpoint enforces non-interference contract. | `policy.fetch.backoff-profile=conservative` |
| Privacy broadening | Any increase in source, field, identity/time precision, frequency, lookback, diagnostics, destination, or capability. | Not a flag. Requires new product ceiling/release and human authorization. | Prohibited in tenant policy. |
| Emergency disable | Force `⊥` globally or for fixed registry IDs. | Constrained short-lived signer; immediate audit; expiry and recovery plan. | `disable.source.edge-history=true` |

A generic remote feature-flag daemon/SDK MUST NOT be an endpoint dependency. It commonly supports dynamic evaluation contexts and flexible targeting, which would undermine the finite, provable policy model. Reusable ideas such as immutable flag snapshots, evaluation reasons, and kill-switch health can be copied into the typed design after review.

## 3.9 Realm isolation and targeting

- Enrollment MUST establish the authoritative realm. Every policy signature key, policy stream, cache row, permit, batch, inbox row, query, audit record, and deletion request is bound to that realm.
- Server realm and device identity MUST come from authenticated registration/channel state, never from tenant payload fields.
- A tenant policy MUST name exactly one realm and one stream; wrong-realm artifacts trigger `SafetyHold` and incident evidence.
- Initial targeting is limited to realm-owned opaque `cohortId` and `deviceId` identifiers assigned through enrollment/control inventory. Person identifiers, usernames, email addresses, HR attributes, role strings, free-text queries, and observed-activity selectors are prohibited.
- Policy simulation uses inventory facts such as agent version, ceiling digest, interpreter version, coarse device capability, cohort, and health. It MUST NOT inspect or upload production activity to estimate impact.
- The default impact preview reports aggregate counts by fixed capability/version/cohort buckets. Person/device lists require a separately authorized operational need and access policy; they are not a default.

**FACT.** The supplied catalogue profile contains no role, owner, entitlement, URL/domain rule, process/publisher rule, lifecycle, or usage dimensions, and five external IDs are missing [I-03]. Therefore it cannot supply targeting or authorization semantics. A governed import MUST assign UAM-owned stable application IDs, preserve optional external references, and surface non-ASCII/truncation/address-like quality cases without inferring meaning from names.

## 3.10 Secure coding and review requirements

**RECOMMENDATION.** Treat policy code as a security boundary under an SSDF-aligned secure development process [S-15]:

- one canonical evaluator library/specification with generated conformance vectors used by endpoint, signer, simulator, server, and CLI;
- no divergent “helpful” defaults in UI or server;
- strict UTF-8 input, duplicate-member rejection before object materialization, depth/size/count limits, checked arithmetic, and cancellation/timeouts;
- immutable domain types; explicit units; total functions returning typed errors; no dynamic reflection-based execution from policy values;
- cryptography behind a fixed profile and key configuration; algorithm allowlist; constant-time library primitives; test vectors including malformed signatures;
- two-person review for lattice/schema/transform/crypto/realm changes; generated privacy diff in every pull request;
- dependency lock, SBOM, vulnerability scanning, signed build provenance, and lifecycle checks;
- fuzzing of tokenizer, canonicalizer, envelope parser, semantic validator, transform DAG, meet operation, and state-machine transitions;
- mutation tests proving negative branches are exercised;
- threat-model review for every new source/field/capability/destination/diagnostic property;
- forbidden-canary scanner in unit, integration, Windows lab, and release gates;
- no raw exception objects or policy bodies sent to logs/metrics/support bundles.

.NET 10 was an in-support LTS line on the research date, supported through November 2028, while patches ship monthly and only current servicing levels are supported [S-01][S-02]. Architecture therefore names the supported .NET family/lifecycle, not a timeless patch number; execution selects and records the then-current supported patch.


---

# 4. Alternatives, rejection reasons, and change conditions

| Alternative | Decision | Why rejected now | Evidence/condition that would change the choice |
|---|---|---|---|
| General-purpose OPA/Rego evaluator in every endpoint | **RECOMMENDATION: reject as endpoint dependency; reference/CI use only.** | Expressive policy, external data/input, built-ins, bundles, and general decisions make monotonic privacy narrowing difficult to prove. Adds Go/Wasm/runtime/versioning surface and a second policy semantics stack to C# endpoints. | A formally restricted Rego subset with a machine proof of monotonicity, materially lower total assurance cost, no dynamic input/IO, and measured Windows operational fitness. |
| Cedar as endpoint policy language | **RECOMMENDATION: reject as endpoint dependency; use formal-testing ideas.** | Cedar is designed for authorization decisions, not a product privacy lattice over fields, transforms, rates, diagnostics, and destinations. Rust/FFI and richer expression semantics are unnecessary for the initial finite registry. | A future requirement for complex resource authorization that is orthogonal to collection, plus a bounded integration and proof that collection dimensions remain outside Cedar. |
| OpenFeature/flagd for all endpoint configuration | **RECOMMENDATION: reject as endpoint dependency; reuse typed evaluation-reason/kill-switch ideas.** | Dynamic evaluation contexts, custom targeting attributes, multiple sync sources, and near-real-time flags invite person/activity targeting and create a parallel path that could enable collection. | Only if used server-side for non-privacy operational UI features, with a hard architectural fitness test proving no flag reaches collection authorization. |
| Server-only policy enforcement | **RECOMMENDATION: reject.** | Rejecting data after upload does not prevent endpoint collection, raw IPC, local persistence, or diagnostics. It violates minimization before the endpoint privacy boundary. | Never sufficient alone. Server validation remains mandatory defense in depth. |
| Portal/UI validation only | **RECOMMENDATION: reject.** | A compromised portal, API client, or direct request can bypass UI constraints. | Never sufficient alone. Signer and every enforcement boundary must revalidate. |
| Unsigned JSON/YAML configuration from enterprise management | **RECOMMENDATION: reject for privacy authorization.** | Origin, realm, revision, expiry, and integrity cannot be proven. YAML adds canonicalization and parser-ambiguity risk. | Enterprise deployment may transport the signed artifact, but cannot replace its signatures and semantic checks. |
| Tenant-defined regular expressions, URL rules, scripts, SQL, or plugins | **RECOMMENDATION: prohibit.** | They are executable/complex logic, are hard to order monotonically, can encode secrets, can cause denial of service, and conflict with fixed Task Host boundaries. | A new release-authored typed rule primitive with formal order, bounded complexity, test vectors, review, and a ceiling change. Never arbitrary code. |
| Tenant-defined upload destinations/webhooks | **RECOMMENDATION: prohibit on endpoints.** | Creates exfiltration and realm-routing paths and makes endpoint network policy unbounded. | A governed server-side integration contract, not endpoint policy. |
| Full TUF client/metadata graph for tenant policy | **RECOMMENDATION: do not copy wholesale.** | TUF addresses software update repository compromise and is more general than one realm policy stream. Full role/delegation complexity would increase implementation and operations. | Reconsider if UAM evolves to multi-repository delegation/offline mirrors where measured risks justify a conforming TUF client. Retain TUF-inspired threshold, expiry, rollback/freeze, consistent snapshots, and key rotation now. |
| Lower revision accepted as “rollback” | **RECOMMENDATION: prohibit.** | It makes replay indistinguishable from recovery and defeats anti-rollback. | Never required: republish previous semantics at a new higher revision with `rollbackOfRevision`. |
| Infinite last-known-good while offline | **RECOMMENDATION: prohibit.** | Expiry would cease to be a freeze/revocation control; a decommissioned policy could collect indefinitely. | A human risk decision could authorize bounded, source-specific offline validity in the signed ceiling, supported by clock evidence. It still has a hard expiry. |
| Bad candidate always stops valid active policy | **RECOMMENDATION: reject for non-security parse/compatibility failures.** | It lets anyone able to corrupt a fetch cause fleet-wide denial of service. | Security-significant failures do enter `SafetyHold`; ordinary malformed/unsupported candidates quarantine without becoming active. |
| Bad candidate never stops active policy | **RECOMMENDATION: reject.** | Wrong-realm, signature, rollback, same-revision conflict, or attempted broadening can indicate compromise; continuing silently would suppress incident containment. | No change expected; classification may be tuned through incident exercises. |
| One monolithic central policy engine for endpoint and portal authorization | **RECOMMENDATION: reject.** | Mixes collection privacy semantics with portal access semantics and creates a large shared failure domain. | Shared primitives and conformance vectors are acceptable; distinct bounded contexts remain. |
| No tenant policy—compile all choices into releases | **RECOMMENDATION: reject as the operating model, retain as safe bootstrap.** | Cannot support tenant narrowing, emergency disablement, staged rollout, or offline cached desired state without frequent releases. | Use `⊥`/synthetic-only as bootstrap when no signed tenant policy exists. |

**Change-control rule.** None of these alternatives may be introduced as a library convenience. A change requires an ADR with affected invariants, new primary evidence, licensing/security review, migration and rollback plan, and the smallest falsifying experiment. No accepted baseline decision is contradicted by the recommended choice, so this result does not open a baseline change proposal.

---

# 5. Interfaces, protocols, and normative example contracts

## 5.1 Signed-artifact wire profile

**RECOMMENDATION.** Define `uam-jws-profile/1` as follows:

1. Payload is UTF-8 JSON conforming to the UAM JSON profile and JSON Schema Draft 2020-12 [S-07][S-08].
2. Before object materialization, a streaming tokenizer MUST reject invalid UTF-8, duplicate object member names, excessive depth/size/counts, malformed escapes, trailing data, and numbers outside schema constraints. `additionalProperties:false` does not detect duplicates and is not a substitute.
3. Payload MUST be canonicalized by RFC 8785 JSON Canonicalization Scheme (JCS) and the received decoded bytes MUST exactly equal the canonical bytes [S-05].
4. Signed envelope MUST use JWS General JSON Serialization so threshold signatures can be represented [S-03]. The normal base64url-encoded payload form is used; unencoded payloads (`b64=false`) are prohibited.
5. Each signature MUST have a protected header containing exactly `alg`, `kid`, `typ`, and `uamProfile`. Unprotected headers are absent. Unknown headers fail closed.
6. `typ` is `uam-product-ceiling+jws`, `uam-tenant-policy+jws`, `uam-emergency-overlay+jws`, or another release-defined fixed value.
7. Profile 1 permits only `ES256`: ECDSA P-256 with SHA-256, with the 64-byte `R || S` JWS signature encoding defined by RFC 7518 [S-04]. The expected algorithm comes from trusted key metadata, not from input negotiation. A future algorithm requires a new profile and compatible product release.
8. `kid` MUST resolve only in the pinned product or realm trust store appropriate to the artifact type. Remote key URLs, embedded untrusted JWKs/certificates, and algorithm/key-type confusion are prohibited. RFC 8725 is JWT guidance rather than the governing artifact format, but its algorithm allowlisting/key-separation cautions are deliberately applied [S-09].
9. Product ceiling threshold is checked against the ceiling’s trusted root metadata, not a threshold claimed by the payload. Tenant signature threshold is checked against the pinned realm key policy.
10. Signature verification precedes semantic trust, but strict structural limits precede expensive cryptography to resist resource exhaustion. Error output remains privacy-safe.

Fictional envelope shape; values are not usable signatures:

```json
{
  "payload": "eyJhcnRpZmFjdElkIjoiMDAwMDAwMDAtMDAwMC00MDAwLTgwMDAtMDAwMDAwMDAwMTAxIiwiLi4uIjoiLi4uIn0",
  "signatures": [
    {
      "protected": "eyJhbGciOiJFUzI1NiIsImtpZCI6InByb2R1Y3QtcHJpdmFjeS0wMSIsInR5cCI6InVhbS1wcm9kdWN0LWNlaWxpbmcwandzIiwidWFtUHJvZmlsZSI6InVhbS1qd3MtcHJvZmlsZS8xIn0",
      "signature": "FICTIONAL_BASE64URL_SIGNATURE_1"
    },
    {
      "protected": "eyJhbGciOiJFUzI1NiIsImtpZCI6InByb2R1Y3QtcHJpdmFjeS0wMiIsInR5cCI6InVhbS1wcm9kdWN0LWNlaWxpbmcwandzIiwidWFtUHJvZmlsZSI6InVhbS1qd3MtcHJvZmlsZS8xIn0",
      "signature": "FICTIONAL_BASE64URL_SIGNATURE_2"
    }
  ]
}
```

No private key, certificate chain, credential, address, or internal identifier appears in an artifact example.

## 5.2 Common JSON profile

All signed payload schemas MUST additionally enforce:

- UTC timestamps in RFC 3339 Internet date-time form with `Z`; no local offsets;
- UUIDs serialized lower-case in canonical hyphenated form where UUID is used;
- SHA-256 digests as lower-case `sha256:<64 hex>` strings;
- identifiers as lower-case ASCII registry strings with bounded length;
- arrays with explicit maximum sizes and `uniqueItems:true` where order has no meaning;
- no JSON `null` unless the schema explicitly permits it;
- integers only for counts/durations/revisions, bounded to the JCS/I-JSON interoperable exact range and application limits;
- no floats for policy bounds;
- no free-text comments, descriptions, filenames, paths, URLs, usernames, application names, or exception messages in signed endpoint artifacts;
- all semantic set arrays canonicalized in lexicographic order by the signer, even though semantic comparison treats them as sets;
- every schema version has a complete conformance-vector directory and a migration/retirement rule.

## 5.3 Product ceiling schema

The following is the normative v1 structural schema skeleton. Semantic constraints described after the schema are equally normative and cannot be expressed safely by JSON Schema alone.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/product-ceiling-1.schema.json",
  "title": "UAM product privacy ceiling v1",
  "type": "object",
  "additionalProperties": false,
  "required": [
    "schemaVersion", "artifactId", "productId", "releaseId",
    "ceilingSequence", "previousCeilingDigest", "issuedAt", "notBefore",
    "expiresAt", "interpreter", "hardDenyClasses", "capabilities",
    "destinations", "diagnosticLevels", "fields", "transforms", "sources",
    "outputSchemas", "metricContract"
  ],
  "properties": {
    "schemaVersion": { "const": "uam.product-ceiling/1" },
    "artifactId": { "$ref": "#/$defs/uuid" },
    "productId": { "const": "uam" },
    "releaseId": { "$ref": "#/$defs/registryId" },
    "ceilingSequence": { "type": "integer", "minimum": 1, "maximum": 9007199254740991 },
    "previousCeilingDigest": {
      "oneOf": [{ "$ref": "#/$defs/digest" }, { "type": "null" }]
    },
    "issuedAt": { "$ref": "#/$defs/timestamp" },
    "notBefore": { "$ref": "#/$defs/timestamp" },
    "expiresAt": { "$ref": "#/$defs/timestamp" },
    "interpreter": {
      "type": "object",
      "additionalProperties": false,
      "required": ["min", "max"],
      "properties": {
        "min": { "type": "integer", "minimum": 1, "maximum": 65535 },
        "max": { "type": "integer", "minimum": 1, "maximum": 65535 }
      }
    },
    "hardDenyClasses": {
      "type": "array", "maxItems": 256, "uniqueItems": true,
      "items": { "$ref": "#/$defs/registryId" }
    },
    "capabilities": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["capabilityId", "enabled", "hardDenied"],
        "properties": {
          "capabilityId": { "$ref": "#/$defs/registryId" },
          "enabled": { "type": "boolean" },
          "hardDenied": { "type": "boolean" }
        }
      }
    },
    "destinations": {
      "type": "array", "maxItems": 64,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["destinationId", "kind", "enabled"],
        "properties": {
          "destinationId": { "$ref": "#/$defs/registryId" },
          "kind": { "enum": ["coordinator-ipc", "endpoint-outbox", "ingest-api"] },
          "enabled": { "type": "boolean" }
        }
      }
    },
    "diagnosticLevels": {
      "type": "array", "minItems": 1, "maxItems": 16,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["levelId", "narrowerOrEqualTo", "propertyIds"],
        "properties": {
          "levelId": { "$ref": "#/$defs/registryId" },
          "narrowerOrEqualTo": {
            "type": "array", "maxItems": 16, "uniqueItems": true,
            "items": { "$ref": "#/$defs/registryId" }
          },
          "propertyIds": {
            "type": "array", "maxItems": 128, "uniqueItems": true,
            "items": { "$ref": "#/$defs/registryId" }
          }
        }
      }
    },
    "fields": {
      "type": "array", "maxItems": 2048,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["fieldId", "dataClassId", "hardDenied"],
        "properties": {
          "fieldId": { "$ref": "#/$defs/registryId" },
          "dataClassId": { "$ref": "#/$defs/registryId" },
          "hardDenied": { "type": "boolean" }
        }
      }
    },
    "transforms": {
      "type": "array", "maxItems": 512,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": [
          "transformId", "implementationDigest", "inputFieldIds",
          "outputSchemaId", "outputFieldIds", "narrowerOrEqualTo",
          "conformanceVectorDigest"
        ],
        "properties": {
          "transformId": { "$ref": "#/$defs/registryId" },
          "implementationDigest": { "$ref": "#/$defs/digest" },
          "inputFieldIds": {
            "type": "array", "maxItems": 256, "uniqueItems": true,
            "items": { "$ref": "#/$defs/registryId" }
          },
          "outputSchemaId": { "$ref": "#/$defs/registryId" },
          "outputFieldIds": {
            "type": "array", "maxItems": 256, "uniqueItems": true,
            "items": { "$ref": "#/$defs/registryId" }
          },
          "narrowerOrEqualTo": {
            "type": "array", "maxItems": 512, "uniqueItems": true,
            "items": { "$ref": "#/$defs/registryId" }
          },
          "conformanceVectorDigest": { "$ref": "#/$defs/digest" }
        }
      }
    },
    "sources": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": [
          "sourceId", "sourceGeneration", "capabilityIds", "allowedFieldIds",
          "allowedTransformIds", "allowedDestinationIds", "outputSchemaIds",
          "taskHostProfileId", "maxLookbackSeconds", "minIntervalSeconds",
          "maxEventsPerRun", "maxBytesPerRun", "maxDiagnosticLevelId"
        ],
        "properties": {
          "sourceId": { "$ref": "#/$defs/registryId" },
          "sourceGeneration": { "type": "integer", "minimum": 1, "maximum": 2147483647 },
          "capabilityIds": { "$ref": "#/$defs/idSet" },
          "allowedFieldIds": { "$ref": "#/$defs/idSet" },
          "allowedTransformIds": { "$ref": "#/$defs/idSet" },
          "allowedDestinationIds": { "$ref": "#/$defs/idSet" },
          "outputSchemaIds": { "$ref": "#/$defs/idSet" },
          "taskHostProfileId": { "$ref": "#/$defs/registryId" },
          "maxLookbackSeconds": { "$ref": "#/$defs/nonNegativeInteger" },
          "minIntervalSeconds": { "$ref": "#/$defs/nonNegativeInteger" },
          "maxEventsPerRun": { "$ref": "#/$defs/nonNegativeInteger" },
          "maxBytesPerRun": { "$ref": "#/$defs/nonNegativeInteger" },
          "maxDiagnosticLevelId": { "$ref": "#/$defs/registryId" }
        }
      }
    },
    "outputSchemas": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["outputSchemaId", "schemaDigest", "fieldIds"],
        "properties": {
          "outputSchemaId": { "$ref": "#/$defs/registryId" },
          "schemaDigest": { "$ref": "#/$defs/digest" },
          "fieldIds": { "$ref": "#/$defs/idSet" }
        }
      }
    },
    "metricContract": {
      "type": "object", "additionalProperties": false,
      "required": ["instrumentIds", "attributeIds", "maxAttributesPerPoint", "maxSeriesPerInstrument"],
      "properties": {
        "instrumentIds": { "$ref": "#/$defs/idSet" },
        "attributeIds": { "$ref": "#/$defs/idSet" },
        "maxAttributesPerPoint": { "type": "integer", "minimum": 0, "maximum": 16 },
        "maxSeriesPerInstrument": { "type": "integer", "minimum": 1, "maximum": 100000 }
      }
    }
  },
  "$defs": {
    "uuid": {
      "type": "string", "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "timestamp": {
      "type": "string", "format": "date-time", "pattern": "Z$", "maxLength": 32
    },
    "digest": {
      "type": "string", "pattern": "^sha256:[0-9a-f]{64}$"
    },
    "registryId": {
      "type": "string", "minLength": 1, "maxLength": 128,
      "pattern": "^[a-z0-9]+(?:[.-][a-z0-9]+)*$"
    },
    "nonNegativeInteger": {
      "type": "integer", "minimum": 0, "maximum": 9007199254740991
    },
    "idSet": {
      "type": "array", "maxItems": 2048, "uniqueItems": true,
      "items": { "$ref": "#/$defs/registryId" }
    }
  }
}
```

Semantic ceiling validation MUST additionally prove:

- `notBefore <= issuedAt <= expiresAt` under trusted time rules;
- `interpreter.min <= interpreter.max`;
- ceiling sequence strictly exceeds the trusted predecessor, and `previousCeilingDigest` matches except for an authorized root/recovery event;
- all registry IDs are unique in their namespace;
- hard-denied entries are disabled and unreachable from any source;
- every source reference exists and is not hard-denied;
- every transform graph is acyclic and its declared transitive relation is consistent;
- every transform output field is present in its output schema and authorized for the source;
- every destination is a fixed product destination ID, not an address;
- diagnostic relation is acyclic and every level property set is a subset of broader levels according to the declared order;
- metric attributes have finite enum domains defined in release code; IDs such as realm/device/user/policy digest are prohibited metric attributes;
- all implementation/schema/vector digests resolve to release-manifest content;
- release manifest binds this exact canonical payload digest.

### 5.3.1 Fictional product ceiling example

This example is intentionally synthetic. It does not approve Edge fields, time precision, hard-deny classes, limits, or production collection.

```json
{
  "schemaVersion": "uam.product-ceiling/1",
  "artifactId": "00000000-0000-4000-8000-000000000101",
  "productId": "uam",
  "releaseId": "uam.synthetic-foundation.2026-07",
  "ceilingSequence": 17,
  "previousCeilingDigest": "sha256:1111111111111111111111111111111111111111111111111111111111111111",
  "issuedAt": "2026-07-31T08:00:00Z",
  "notBefore": "2026-07-31T08:00:00Z",
  "expiresAt": "2026-10-31T08:00:00Z",
  "interpreter": { "min": 1, "max": 1 },
  "hardDenyClasses": [
    "fictional.arbitrary-plugin",
    "fictional.arbitrary-script",
    "fictional.raw-url",
    "fictional.tenant-destination"
  ],
  "capabilities": [
    { "capabilityId": "source.synthetic-read", "enabled": true, "hardDenied": false },
    { "capabilityId": "runtime.arbitrary-script", "enabled": false, "hardDenied": true }
  ],
  "destinations": [
    { "destinationId": "endpoint.coordinator-ipc", "kind": "coordinator-ipc", "enabled": true },
    { "destinationId": "endpoint.outbox", "kind": "endpoint-outbox", "enabled": true },
    { "destinationId": "server.ingest-api", "kind": "ingest-api", "enabled": true }
  ],
  "diagnosticLevels": [
    { "levelId": "diagnostic.off", "narrowerOrEqualTo": ["diagnostic.off", "diagnostic.health"], "propertyIds": [] },
    { "levelId": "diagnostic.health", "narrowerOrEqualTo": ["diagnostic.health"], "propertyIds": ["health.error-code", "health.state"] }
  ],
  "fields": [
    { "fieldId": "source.synthetic-domain", "dataClassId": "fictional.synthetic-input", "hardDenied": false },
    { "fieldId": "source.synthetic-time", "dataClassId": "fictional.synthetic-input", "hardDenied": false },
    { "fieldId": "event.synthetic-site-token", "dataClassId": "fictional.minimized-site", "hardDenied": false },
    { "fieldId": "event.synthetic-time-bucket", "dataClassId": "fictional.coarse-time", "hardDenied": false },
    { "fieldId": "source.raw-url", "dataClassId": "fictional.raw-url", "hardDenied": true }
  ],
  "transforms": [
    {
      "transformId": "transform.synthetic-site-token.daily.v1",
      "implementationDigest": "sha256:2222222222222222222222222222222222222222222222222222222222222222",
      "inputFieldIds": ["source.synthetic-domain", "source.synthetic-time"],
      "outputSchemaId": "event.synthetic-site.daily.v1",
      "outputFieldIds": ["event.synthetic-site-token", "event.synthetic-time-bucket"],
      "narrowerOrEqualTo": ["transform.synthetic-site-token.daily.v1"],
      "conformanceVectorDigest": "sha256:3333333333333333333333333333333333333333333333333333333333333333"
    }
  ],
  "sources": [
    {
      "sourceId": "source.synthetic-edge-history.v1",
      "sourceGeneration": 1,
      "capabilityIds": ["source.synthetic-read"],
      "allowedFieldIds": ["event.synthetic-site-token", "event.synthetic-time-bucket"],
      "allowedTransformIds": ["transform.synthetic-site-token.daily.v1"],
      "allowedDestinationIds": ["endpoint.coordinator-ipc", "endpoint.outbox", "server.ingest-api"],
      "outputSchemaIds": ["event.synthetic-site.daily.v1"],
      "taskHostProfileId": "taskhost.synthetic-browser-read.v1",
      "maxLookbackSeconds": 86400,
      "minIntervalSeconds": 3600,
      "maxEventsPerRun": 1000,
      "maxBytesPerRun": 1048576,
      "maxDiagnosticLevelId": "diagnostic.health"
    }
  ],
  "outputSchemas": [
    {
      "outputSchemaId": "event.synthetic-site.daily.v1",
      "schemaDigest": "sha256:4444444444444444444444444444444444444444444444444444444444444444",
      "fieldIds": ["event.synthetic-site-token", "event.synthetic-time-bucket"]
    }
  ],
  "metricContract": {
    "instrumentIds": ["uam.policy.evaluation", "uam.policy.safety-hold"],
    "attributeIds": ["error.class", "policy.state", "schema.version"],
    "maxAttributesPerPoint": 4,
    "maxSeriesPerInstrument": 128
  }
}
```

## 5.4 Tenant-policy schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.example.invalid/uam/tenant-policy-1.schema.json",
  "title": "UAM tenant narrowing policy v1",
  "type": "object",
  "additionalProperties": false,
  "required": [
    "schemaVersion", "policyId", "realmId", "streamId", "revision",
    "previousPolicyDigest", "rollbackOfRevision", "issuedAt", "effectiveAt",
    "expiresAt", "ceilingDigest", "releaseId", "approvalRef", "interpreter",
    "mode", "target", "sources", "destinations", "diagnosticLevelId",
    "featureFlags", "killSwitches"
  ],
  "properties": {
    "schemaVersion": { "const": "uam.tenant-policy/1" },
    "policyId": { "$ref": "#/$defs/uuid" },
    "realmId": { "$ref": "#/$defs/uuid" },
    "streamId": { "$ref": "#/$defs/registryId" },
    "revision": { "type": "integer", "minimum": 1, "maximum": 9007199254740991 },
    "previousPolicyDigest": {
      "oneOf": [{ "$ref": "#/$defs/digest" }, { "type": "null" }]
    },
    "rollbackOfRevision": {
      "oneOf": [
        { "type": "integer", "minimum": 1, "maximum": 9007199254740991 },
        { "type": "null" }
      ]
    },
    "issuedAt": { "$ref": "#/$defs/timestamp" },
    "effectiveAt": { "$ref": "#/$defs/timestamp" },
    "expiresAt": { "$ref": "#/$defs/timestamp" },
    "ceilingDigest": { "$ref": "#/$defs/digest" },
    "releaseId": { "$ref": "#/$defs/registryId" },
    "approvalRef": { "$ref": "#/$defs/opaqueRef" },
    "interpreter": {
      "type": "object", "additionalProperties": false,
      "required": ["min", "max"],
      "properties": {
        "min": { "type": "integer", "minimum": 1, "maximum": 65535 },
        "max": { "type": "integer", "minimum": 1, "maximum": 65535 }
      }
    },
    "mode": { "enum": ["collect", "disabled"] },
    "target": {
      "type": "object", "additionalProperties": false,
      "required": ["cohortIds", "deviceIds"],
      "properties": {
        "cohortIds": { "$ref": "#/$defs/opaqueIdSet" },
        "deviceIds": { "$ref": "#/$defs/opaqueIdSet" }
      }
    },
    "sources": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": [
          "sourceId", "enabled", "fieldIds", "transformId", "destinationIds",
          "maxLookbackSeconds", "minIntervalSeconds", "maxEventsPerRun",
          "maxBytesPerRun"
        ],
        "properties": {
          "sourceId": { "$ref": "#/$defs/registryId" },
          "enabled": { "type": "boolean" },
          "fieldIds": { "$ref": "#/$defs/idSet" },
          "transformId": { "$ref": "#/$defs/registryId" },
          "destinationIds": { "$ref": "#/$defs/idSet" },
          "maxLookbackSeconds": { "$ref": "#/$defs/nonNegativeInteger" },
          "minIntervalSeconds": { "$ref": "#/$defs/nonNegativeInteger" },
          "maxEventsPerRun": { "$ref": "#/$defs/nonNegativeInteger" },
          "maxBytesPerRun": { "$ref": "#/$defs/nonNegativeInteger" }
        }
      }
    },
    "destinations": { "$ref": "#/$defs/idSet" },
    "diagnosticLevelId": { "$ref": "#/$defs/registryId" },
    "featureFlags": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["flagId", "valueId"],
        "properties": {
          "flagId": { "$ref": "#/$defs/registryId" },
          "valueId": { "$ref": "#/$defs/registryId" }
        }
      }
    },
    "killSwitches": {
      "type": "array", "maxItems": 256,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["switchId", "active"],
        "properties": {
          "switchId": { "$ref": "#/$defs/registryId" },
          "active": { "type": "boolean" }
        }
      }
    }
  },
  "$defs": {
    "uuid": {
      "type": "string", "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$"
    },
    "timestamp": { "type": "string", "format": "date-time", "pattern": "Z$", "maxLength": 32 },
    "digest": { "type": "string", "pattern": "^sha256:[0-9a-f]{64}$" },
    "registryId": {
      "type": "string", "minLength": 1, "maxLength": 128,
      "pattern": "^[a-z0-9]+(?:[.-][a-z0-9]+)*$"
    },
    "opaqueRef": {
      "type": "string", "minLength": 1, "maxLength": 128,
      "pattern": "^[A-Za-z0-9_-]+$"
    },
    "nonNegativeInteger": { "type": "integer", "minimum": 0, "maximum": 9007199254740991 },
    "idSet": {
      "type": "array", "maxItems": 2048, "uniqueItems": true,
      "items": { "$ref": "#/$defs/registryId" }
    },
    "opaqueIdSet": {
      "type": "array", "maxItems": 10000, "uniqueItems": true,
      "items": { "type": "string", "minLength": 1, "maxLength": 128, "pattern": "^[A-Za-z0-9_-]+$" }
    }
  }
}
```

Semantic tenant validation MUST additionally prove:

- artifact signature threshold and key are trusted for the pinned realm and policy stream;
- `realmId` equals the enrolled realm, not a request/payload selection;
- exact referenced ceiling is trusted, installed/compatible, unexpired, and bound to release;
- `issuedAt <= effectiveAt < expiresAt`, with expiry contained by ceiling and signing-key validity;
- interpreter range intersects the agent interpreter exactly as defined by compatibility rules;
- revision is strictly greater than trusted active/seen revision, `previousPolicyDigest` chains correctly, and same revision cannot have another digest;
- `rollbackOfRevision`, when present, is less than the new `revision` and refers to an audited historic semantic snapshot; it does not change anti-rollback checks;
- targets are local realm-owned opaque inventory IDs and include the endpoint/cohort, or evaluation is a non-error `TargetMiss` with no collection;
- every source/field/transform/destination/diagnostic/flag/switch ID is present in the exact ceiling registry;
- every tenant dimension is `⪯` its ceiling dimension;
- disabled source entries carry no hidden permission: implementation normalizes their effective fields/destinations/bounds to `⊥`;
- duplicate source/flag/switch IDs are rejected;
- policy mode `disabled` normalizes the whole effective policy to `⊥`, regardless of other entries;
- all arrays and identifiers are canonicalized and digest-bound.

### 5.4.1 Fictional narrower tenant-policy example

```json
{
  "schemaVersion": "uam.tenant-policy/1",
  "policyId": "00000000-0000-4000-8000-000000000201",
  "realmId": "00000000-0000-4000-8000-000000000301",
  "streamId": "endpoint.collection.default",
  "revision": 43,
  "previousPolicyDigest": "sha256:5555555555555555555555555555555555555555555555555555555555555555",
  "rollbackOfRevision": null,
  "issuedAt": "2026-07-31T09:00:00Z",
  "effectiveAt": "2026-07-31T10:00:00Z",
  "expiresAt": "2026-08-31T10:00:00Z",
  "ceilingDigest": "sha256:6666666666666666666666666666666666666666666666666666666666666666",
  "releaseId": "uam.synthetic-foundation.2026-07",
  "approvalRef": "fictional_approval_2026_0043",
  "interpreter": { "min": 1, "max": 1 },
  "mode": "collect",
  "target": {
    "cohortIds": ["fictional_canary_cohort"],
    "deviceIds": []
  },
  "sources": [
    {
      "sourceId": "source.synthetic-edge-history.v1",
      "enabled": true,
      "fieldIds": ["event.synthetic-site-token", "event.synthetic-time-bucket"],
      "transformId": "transform.synthetic-site-token.daily.v1",
      "destinationIds": ["endpoint.coordinator-ipc", "endpoint.outbox", "server.ingest-api"],
      "maxLookbackSeconds": 43200,
      "minIntervalSeconds": 7200,
      "maxEventsPerRun": 500,
      "maxBytesPerRun": 524288
    }
  ],
  "destinations": ["endpoint.coordinator-ipc", "endpoint.outbox", "server.ingest-api"],
  "diagnosticLevelId": "diagnostic.off",
  "featureFlags": [
    { "flagId": "source.synthetic-edge-history.enabled", "valueId": "flag.enabled" }
  ],
  "killSwitches": [
    { "switchId": "disable.source.synthetic-edge-history", "active": false }
  ]
}
```

### 5.4.2 Fictional rollback-as-new-revision example

A recovery to revision 41 semantics is published as revision 44, not as revision 41:

```json
{
  "schemaVersion": "uam.tenant-policy/1",
  "policyId": "00000000-0000-4000-8000-000000000202",
  "realmId": "00000000-0000-4000-8000-000000000301",
  "streamId": "endpoint.collection.default",
  "revision": 44,
  "previousPolicyDigest": "sha256:7777777777777777777777777777777777777777777777777777777777777777",
  "rollbackOfRevision": 41,
  "issuedAt": "2026-07-31T11:00:00Z",
  "effectiveAt": "2026-07-31T11:05:00Z",
  "expiresAt": "2026-08-31T11:05:00Z",
  "ceilingDigest": "sha256:6666666666666666666666666666666666666666666666666666666666666666",
  "releaseId": "uam.synthetic-foundation.2026-07",
  "approvalRef": "fictional_recovery_2026_0044",
  "interpreter": { "min": 1, "max": 1 },
  "mode": "disabled",
  "target": { "cohortIds": ["fictional_canary_cohort"], "deviceIds": [] },
  "sources": [],
  "destinations": [],
  "diagnosticLevelId": "diagnostic.off",
  "featureFlags": [],
  "killSwitches": [{ "switchId": "disable.all-collection", "active": true }]
}
```

## 5.5 Emergency narrowing overlay

An emergency overlay is a separate signed artifact so emergency authority cannot rewrite ordinary desired state. It MUST contain only:

```text
schemaVersion, overlayId, realm/product scope, streamId, sequence,
issuedAt, effectiveAt, expiresAt, referenced ceiling/policy digests,
fixed disable switch IDs, reasonCode (fixed enum), approvalRef
```

It MUST NOT contain source enablement, fields, transforms, destinations, selectors, free-text reason, or any value that increases permission. Multiple overlays meet/intersect. Expiry removes only that overlay; it never resurrects an expired or invalid base policy. The control plane MUST preview the post-expiry effective state before activation.

## 5.6 Policy evaluation result contract

Every evaluator implementation MUST return the same typed result:

```csharp
public sealed record PolicyEvaluationResult(
    EvaluationDisposition Disposition,     // Active, Disabled, TargetMiss, Quarantined, SafetyHold
    string ErrorCode,                      // fixed enum; "NONE" on success
    string CeilingDigest,
    string? CandidatePolicyDigest,
    string? ActivePolicyDigest,
    long? ActiveRevision,
    EffectivePolicy? EffectivePolicy,      // null unless Active/Disabled
    IReadOnlyList<SafeEvidenceCode> EvidenceCodes,
    DateTimeOffset EvaluatedAtUtc,
    ClockConfidence ClockConfidence);
```

`SafeEvidenceCode` contains only fixed enums and bounded counters. It contains no policy JSON, source values, target IDs, realm/device/user IDs, application names, paths, URLs, or raw exception text.

## 5.7 Run-intent and collection-permit contracts

To avoid trusting one endpoint process, collection authorization is a two-step handshake:

1. **Coordinator `RunIntent`:** schedule intent bound to active policy/ceiling digests, source, run nonce, current source generation/cursor epoch, and bounded run budget.
2. **User Host `CollectionPermit`:** after independently evaluating signed artifacts and session eligibility, the User Host accepts the intent and creates a short-lived permit MAC/signature using a per-session ephemeral key passed only to the child Task Host through a protected inherited handle or equivalent approved IPC mechanism.

Logical permit schema:

```text
permitVersion:                 uint16
runId:                         128-bit random
runNonce:                      128-bit random from RunIntent
realmBindingDigest:            sha256
installationBindingDigest:     sha256
sessionBindingDigest:          sha256
sourceId:                      registry ID
sourceGeneration:              uint32
transformId:                   registry ID
outputSchemaId:                registry ID
fieldIds:                      sorted registry-ID set
capabilityIds:                 sorted registry-ID set
maxLookbackSeconds:            uint64
maxEvents:                     uint64
maxOutputBytes:                uint64
notBeforeUtc:                  timestamp
expiresAtUtc:                  timestamp
ceilingDigest:                 sha256
policyDigest:                  sha256
policyRevision:                uint64
userHostInstanceNonce:         128-bit random
coordinatorRunIntentDigest:    sha256
executableProfileDigest:       sha256
permitAuthenticator:           fixed algorithm and bytes
```

Rules:

- Encoding MUST be generated and typed with bounded lengths; no dictionary/extension fields or arbitrary object graph. The project may select a reviewed generated binary encoding in the IPC ADR; this logical schema is invariant.
- Task Host validates parent/session binding, protected handle provenance, permit authenticator, time, executable profile, source/transform/output schema/fields/limits, and one-time run nonce.
- User Host enforces source interval and per-session budgets independently. Coordinator enforces durable interval/budget and source cursor state. Server detects rate/provenance anomalies. A single process is therefore not the sole policy authority.
- Permit is single-use and expires quickly within ceiling bounds. Exact lifetime is a CLI measurement and human risk decision.
- Cancellation or policy change invalidates the nonce. Task Host output after invalidation is discarded and cursor does not advance.
- Task Host has no general network destination and can write only to the bounded parent IPC/handle.

## 5.8 Minimized output and provenance contract

Every output record/batch MUST bind:

```text
realm/device:       derived server-side from authenticated enrollment, not trusted payload claims
sourceId/sourceGeneration
outputSchemaId/schemaDigest
transformId/implementationDigest
ceilingDigest/releaseId
policyDigest/policyRevision
permit/runId
sourceEventStableId or dedupe material (minimized and approved)
qualityStatus: fixed enum
minimized fields only
```

Policy/ceiling digests may be carried in a batch-level dictionary to reduce bytes, but they MUST NOT be metric labels. Unknown fields, schema mismatch, unrecognized provenance, wrong release relationship, limit excess, or hard-deny canary causes quarantine—not silent truncation or “best effort” materialization.

## 5.9 Control-plane API contracts

The portal/BFF exposes typed operations, not raw artifact upload by ordinary administrators:

```text
POST /realms/{boundRealm}/policy-candidates
POST /realms/{boundRealm}/policy-candidates/{id}:simulate
POST /realms/{boundRealm}/policy-candidates/{id}:approve
POST /realms/{boundRealm}/policy-candidates/{id}:sign
POST /realms/{boundRealm}/policy-candidates/{id}:publish
POST /realms/{boundRealm}/emergency-overlays
GET  /realms/{boundRealm}/policy-streams/{stream}/status
GET  /realms/{boundRealm}/policy-audit/{eventId}
```

The route realm is resolved from authenticated authorization context; it is not accepted from a body as routing authority. Every mutation uses an idempotency key, optimistic concurrency against latest revision/digest, durable audit transaction, and fixed error code. The signer endpoint is not directly exposed to browsers and accepts only a digest plus immutable candidate/approval references retrieved from trusted storage.

## 5.10 Error taxonomy

| Class | Fixed codes | Endpoint behavior |
|---|---|---|
| Envelope/key | `POLICY_SIG_INVALID`, `POLICY_KEY_UNKNOWN`, `POLICY_HEADER_INVALID`, `POLICY_CANONICALIZATION_INVALID` | Candidate no permit; security-significant cases `SafetyHold`; audit safe code. |
| Syntax/schema | `POLICY_UTF8_INVALID`, `POLICY_DUPLICATE_MEMBER`, `POLICY_UNKNOWN_MEMBER`, `POLICY_SCHEMA_UNSUPPORTED`, `POLICY_LIMIT_EXCEEDED` | Quarantine candidate; active LKG may continue if unexpired and no compromise evidence. |
| Scope/time | `POLICY_REALM_MISMATCH`, `POLICY_NOT_YET_VALID`, `POLICY_EXPIRED`, `POLICY_CLOCK_UNTRUSTED`, `POLICY_TARGET_MISS` | Wrong realm/clock rollback: `SafetyHold`; expired: disabled; not-yet-valid staged; target miss: no collection, normal health. |
| Revision/chain | `POLICY_REVISION_ROLLBACK`, `POLICY_SAME_REVISION_CONFLICT`, `POLICY_CHAIN_BREAK`, `POLICY_FREEZE_SUSPECTED` | `SafetyHold`, stop new collection, incident. |
| Monotonicity | `POLICY_BROADER_SOURCE`, `POLICY_BROADER_FIELD`, `POLICY_BROADER_TRANSFORM`, `POLICY_TRANSFORM_INCOMPARABLE`, `POLICY_BROADER_DESTINATION`, `POLICY_BROADER_DIAGNOSTIC`, `POLICY_BROADER_LIMIT`, `POLICY_BROADER_TARGET`, `POLICY_UNKNOWN_CAPABILITY` | `SafetyHold`; candidate never activates. |
| Compatibility/cache | `POLICY_AGENT_INCOMPATIBLE`, `POLICY_CEILING_MISMATCH`, `POLICY_CACHE_CORRUPT`, `CEILING_INVALID` | Unsupported candidate quarantined; incompatible/corrupt active state disabled; refetch/recovery. |
| Runtime permit/output | `KILL_SWITCH_ACTIVE`, `PERMIT_STALE`, `PERMIT_REPLAY`, `PERMIT_SESSION_MISMATCH`, `OUTPUT_SCHEMA_VIOLATION`, `OUTPUT_LIMIT_EXCEEDED`, `CANARY_DETECTED` | Cancel/discard; no cursor advance; quarantine/incident as classified. |

Error strings are never dynamically formatted with identifiers or values in production telemetry. A local privileged support view may correlate an opaque event ID to protected audit evidence under approved access, not to raw source data.

---

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility

## 6.1 Policy evaluation state machine for candidates

```text
Absent
  -> Received
  -> EnvelopeVerified
  -> CanonicalPayloadVerified
  -> StrictlyParsed
  -> SchemaValid
  -> RealmAndStreamValid
  -> TimeValidOrStaged
  -> RevisionAndChainValid
  -> CeilingBound
  -> Monotonic
  -> AgentCompatible
  -> TargetEvaluated
  -> Staged
  -> CanaryActive
  -> Active
  -> Superseded
  -> Expired/Disabled
```

Failure transitions:

- resource/syntax/schema/unsupported failure before activation -> `QuarantinedCandidate`;
- not-yet-effective -> `Staged` with no permit before `effectiveAt`;
- target miss -> `InactiveTargetMiss`, no permit and no error storm;
- expired base -> `DisabledExpired`;
- wrong realm/key/signature/rollback/conflict/chain/broadening/clock rollback -> `SafetyHold`;
- corrupt or incompatible active cache with no valid replacement -> `DisabledRecoveryRequired`;
- canary failure -> `CanaryFailed`, candidate disabled; if forbidden data appears, `SafetyHold` and incident cleanup.

Only one transactionally active base policy per realm/stream/ceiling compatibility variant exists. Emergency overlays are separate, independently versioned restrictions.

## 6.2 Evaluation decision table

| Candidate condition | Candidate contribution | Existing unexpired active policy | Resulting collection state |
|---|---:|---|---|
| Valid, narrower, compatible, targeted, effective | Candidate effective policy | Replaced atomically after rollout gate | Active under new revision |
| Valid but `effectiveAt` future | None before time | Continues | Staged |
| Valid but target miss | None | Endpoint’s applicable active state remains, subject to stream targeting semantics | No policy contribution; normally disabled for that stream if no other targeted policy |
| Unsupported schema/interpreter | None | Continues only if independently valid/unexpired/compatible | Candidate quarantined; privacy-safe health |
| Malformed/duplicate/unknown member | None | Continues only if independently valid/unexpired | Candidate quarantined |
| Expired candidate | None | Continues if valid/unexpired | Candidate rejected |
| Active/LKG expires | None | None | All collection disabled |
| Broader dimension | None | Stopped | `SafetyHold` |
| Invalid/unknown key or signature | None | Stopped | `SafetyHold` |
| Wrong realm | None | Stopped | `SafetyHold`, cross-realm incident |
| Lower revision/same revision different digest/broken chain | None | Stopped | `SafetyHold`, replay/freeze investigation |
| Cache torn/corrupt | None | Do not reconstruct from fragments | Disabled; recover from trusted artifact store |
| Clock moves backward beyond approved tolerance | None | Stopped | `SafetyHold`/clock recovery |

This table is the implementation interpretation of “bad policy produces zero new collection.” It deliberately distinguishes candidate quarantine from security containment.

## 6.3 Rollout state machine

```text
Draft
  -> Linted
  -> Simulated
  -> ImpactReviewed
  -> Approved
  -> Signed
  -> PublishedImmutable
  -> EndpointStaged
  -> SyntheticCanary
  -> FleetCanary
  -> ExpandedInStages
  -> Stable
  -> Superseded
  -> Archived
```

Exceptional transitions:

```text
Any pre-sign state -> Rejected
Published/Canary/Expanded -> Paused
Published/Canary/Expanded -> EmergencyNarrowingOverlay
Canary/Expanded -> RecoveryPolicy(new higher revision)
Any active state -> Expired -> Disabled
Forbidden-canary/signature/realm/rollback incident -> SafetyHold
```

Rules:

- A candidate cannot be signed until the exact canonical digest, generated diff, simulation snapshot digest, approval reference, and conformance result are immutable.
- Canary order is synthetic first, then approved non-production/lab, then a small explicitly governed fleet cohort. Exact fleet percentages/durations are human/operational decisions.
- Expansion is stopped automatically on fixed privacy/security health signals, not on activity-volume business targets.
- Rollback creates a higher revision using known prior semantics and fresh validity/signatures. It is tested through the same canary path unless an emergency disable overlay is needed immediately.
- Emergency disable is allowed to bypass ordinary expansion timing but not signature, realm, ceiling, expiry, audit, or monotonic checks.

## 6.4 Permit/run state machine

```text
CoordinatorRunIntentCreated
  -> UserHostIndependentlyEvaluated
  -> PermitMinted
  -> TaskHostStarted
  -> PermitVerified
  -> SourceOpenedReadOnly
  -> RawReadInTaskMemory
  -> MinimizedInTaskMemory
  -> TaskOutputSchemaValidated
  -> UserHostValidated
  -> CoordinatorValidated
  -> EventAndCursorCommittedAtomically
  -> RawBuffersCleared
  -> TaskHostExited
```

Abort paths from every state:

```text
Policy/ceiling/overlay change -> Cancel -> Discard output -> No cursor advance
Permit expiry/replay/session mismatch -> Reject -> Safe health event
Source error -> Defer -> No cursor advance beyond durable events
Output/canary/schema violation -> Quarantine/incident -> No cursor advance
Process crash -> recover from atomic event/cursor state; no raw recovery file
```

Task Hosts never write a raw recovery file, live database copy, diagnostic dump, or general cache. Browser acquisition remains the accepted read-only/Online Backup/defer method; tenant policy cannot select another path [I-02].

## 6.5 Key lifecycle state machine

```text
Proposed -> Approved -> Active -> Overlap -> Retiring -> Revoked -> Archived
```

- New key metadata is signed by an already trusted predecessor/root and has a monotonically increasing sequence.
- During overlap, both old and new signatures may be required or accepted according to trusted metadata, not payload claims.
- Revocation stops new activation. Whether already active artifacts signed before compromise remain valid is an incident/human risk decision encoded by signed recovery metadata; default is `SafetyHold` until re-signed.
- Endpoint stores highest-seen root/key-metadata sequence and digest to detect rollback.
- Key rotation must be rehearsed with endpoints offline across the intended overlap. Exact windows are not chosen by research.
- Loss of all valid signing keys is recovered only by the pre-established product/realm recovery authority or enterprise reinstall/re-enrollment path. No unsigned break-glass policy exists.

## 6.6 Clock-confidence state machine

Signed expiry is meaningful only with defensible time handling:

```text
Unknown -> WallClockObserved -> ServerTimeCorroborated -> TrustedEnough
TrustedEnough -> BackwardJumpSuspected -> SafetyHold
TrustedEnough -> StaleWithoutCorroboration -> Restricted/Disabled at signed expiry
BackwardJumpSuspected -> Recorroborated -> TrustedEnough
```

**RECOMMENDATION.** Persist the maximum authenticated server/release timestamp observed and boot/session monotonic-time anchors. A wall-clock move backward beyond an approved tolerance never extends artifact validity. If time cannot prove `notBefore/effectiveAt/expiresAt`, the endpoint does not start a new run. Exact tolerance and offline strategy require a Windows lab experiment; there is no research-invented grace.

## 6.7 Endpoint cache transaction boundaries

Use the accepted SQLite WAL/one-writer model [I-01]. Suggested logical tables are topic-local, not a broader data-model decision:

```text
policy_blob(
  digest PK, artifact_type, canonical_payload, envelope,
  received_at, verification_state, schema_version, expires_at)

policy_candidate(
  realm_binding, stream_id, digest, revision, state,
  error_code, evaluated_at, evaluation_evidence_digest)

policy_active(
  realm_binding, stream_id, ceiling_digest, policy_digest,
  revision, activated_at, effective_policy_digest, state)

policy_overlay_active(
  realm_binding, stream_id, overlay_digest, sequence, expires_at)

policy_seen_head(
  realm_binding, stream_id, highest_revision, digest, observed_at)

policy_clock_state(
  singleton, max_authenticated_utc, boot_anchor, confidence, updated_at)

policy_audit_event(
  event_id, safe_event_code, state_from, state_to,
  artifact_digest, revision, occurred_at, evidence_digest)
```

Transaction rules:

1. Download writes a complete bounded blob under a temporary digest and fsync/commit; partial files are never parsed as active.
2. Verification reads immutable blob bytes and stores a typed result. Verification result is not trusted across evaluator-version change without re-evaluation.
3. Activation transaction checks expected current revision/digest, writes candidate state, active pointer, highest-seen head, and audit event atomically.
4. A bad candidate cannot overwrite active pointer or highest-seen trusted head except to record a higher observed conflicting revision for incident evidence.
5. Overlay activation/deactivation is atomic with effective-policy recomputation and audit.
6. Event/cursor commit rechecks active effective-policy digest/permit nonce at transaction start. A stale permit cannot commit after policy narrowing.
7. Cache corruption never triggers permissive reconstruction. Delete/quarantine corrupt blobs, retain safe metadata if valid, refetch by digest, and remain disabled until verified.
8. Cleanup deletes superseded payloads only after retention/audit policy permits and no active/recovery reference exists. Artifacts contain no raw activity, but integrity/audit retention remains a human decision.

## 6.8 Server transaction boundaries

- Policy candidate creation and immutable canonical digest are one transaction.
- Approval writes an immutable attestation tied to candidate digest; editing after approval creates a new candidate.
- Signing retrieves candidate/approval by digest in the isolated signer; signature publication and signer audit are atomic or compensating with an unambiguous failed state.
- Publication uses immutable digest storage plus monotonically versioned stream head. Stream-head update uses compare-and-swap on prior revision/digest.
- Ingestion authenticates and derives realm before parsing business payload. Unknown/overbroad output is quarantined in the declared durable inbox failure domain and is not materialized/visible.
- A privileged policy mutation cannot report success unless its durable audit record commits, consistent with the accepted invariant [I-01].

## 6.9 Compatibility rules

### 6.9.1 Interpreter and schema

- Agent declares one or more exact supported interpreter versions in registration/inventory.
- A payload schema version is never treated as “close enough.” Unknown major/minor semantics are unsupported.
- Control plane generates and signs a compatibility-specific policy variant for each supported agent/ceiling cohort. Variants share a desired-state change reference but have independent canonical payloads, signatures, revisions, and audit.
- Unsupported candidate contributes no permit. An independently valid unexpired LKG for the installed release may continue unless the failure is security-significant.
- Old agents never ignore unknown fields. `additionalProperties:false` plus strict parser makes accidental permissive forward compatibility impossible.

### 6.9.2 Release/ceiling change

- A tenant policy binds an exact ceiling digest. It is not automatically rebound to a new release.
- Before release rollout, the control plane simulates and obtains signatures for policy variants referencing the new ceiling. Upgrade readiness requires a valid variant or explicitly accepts collection-disabled state.
- If new ceiling narrows, generated tenant variant is the meet of desired state and new ceiling. If semantics change or become incomparable, owner approval is required; no silent remapping.
- If new ceiling broadens, existing tenant desired state remains bounded, but a newly signed variant is still required so tenant authorization is explicit and digest-bound.
- After installation, absence of a valid policy for the installed ceiling means `DisabledNoCompatiblePolicy`.
- A release downgrade is not a policy recovery mechanism. Enterprise rollback installs a separately authorized release sequence and matching policy variant under the release/update ADR.

### 6.9.3 Transform/schema evolution

- Transform IDs are immutable in semantics. Behavior change creates a new ID/version and implementation digest.
- A transform migration includes old/new conformance vectors, privacy-order proof, output-schema compatibility, data-quality impact, and canary scan.
- Old and new transforms may coexist in a ceiling during staged migration. Tenant policy selects one exact ID.
- Server accepts only explicitly supported provenance combinations; it does not reinterpret an old transform as a new one.

### 6.9.4 Policy rollback and recovery

- Never decrement revision.
- Republish prior semantics at `revision = current + 1` or higher, set `rollbackOfRevision`, use fresh times/signatures/approval, and chain to current digest.
- If the current policy may be malicious, activate a constrained emergency disable overlay first, rotate/revoke keys if required, then publish recovery policy.
- Endpoint retains enough digest/revision audit metadata to prove the sequence without retaining sensitive content.

## 6.10 Safe deletion and cleanup after policy narrowing

Policy narrowing controls future collection; it does not by itself authorize deletion of already collected data. On a detected over-collection incident:

1. stop new collection with signed overlay/local safety hold;
2. quarantine affected endpoint/server records by provenance digest and time/run range;
3. preserve privacy-safe incident evidence and immutable audit;
4. obtain the accountable deletion/legal decision;
5. execute governed deletion across endpoint outbox, server inbox/quarantine/materialized stores, backups/exports/integrations according to their contracts;
6. verify deletion/non-visibility and restore behavior;
7. rotate compromised keys/releases if needed;
8. close only after canary scans and recovery tests pass.

No component silently “scrubs” a forbidden field and then treats the record as valid, because the presence proves a privacy-boundary failure.


---

# 7. Security/privacy threat and failure register

## 7.1 Threat model and assurance boundary

### Assets

- approved product ceiling semantics and hard-deny registry;
- realm tenant desired state, signing keys, revision/chain heads, and approval evidence;
- endpoint realm/session identity and policy cache;
- raw source values while transiently present inside the restricted Task Host;
- minimized events, cursor integrity, provenance, audit, and emergency disablement;
- privacy-safe health/observability and support evidence;
- release/package/transform/schema integrity.

### Plausible adversaries/failures

- compromised portal account, browser, control API, CI worker, artifact repository, signer service, tenant key, product release key, endpoint process, local administrator, or server worker;
- malicious or malformed policy/artifact/source data designed for parser, canonicalization, signature, transform, logging, or cardinality failure;
- replay, rollback, freeze, key-rotation gap, cross-realm substitution, stale cache, disk corruption, crash, clock rollback, offline expiry, and split rollout;
- coding error in lattice order, transform graph, schema, permit binding, sink redaction, realm filters, or compatibility logic;
- support/incident action that accidentally collects or reveals raw data.

### Assurance boundary

**RECOMMENDATION.** The design prevents a single ordinary **policy/control plane** from authorizing broader collection: portal, control API, signer, repository, release pipeline, server, and endpoint components each face an independent check or lack collection authority. A single compromised data-plane process is constrained by source/session rights, fixed executable profile, no general network, bounded IPC, schema checks, canary detection, and downstream rejection.

**Residual risk.** Software cannot fully prove non-exfiltration from a malicious process that already has legitimate source-read access, nor from a compromised Windows kernel/local administrator. An allowed-shaped output can be abused as a covert channel. Sandboxing, fixed transforms, deterministic vectors, output-rate limits, multiple validators, endpoint/network controls, code integrity, and canary tests reduce but do not eliminate this risk.

## 7.2 Threat and failure register

The “owner” column names an accountable **function** that must be assigned by humans; it does not assert an existing organization chart.

| ID | Threat/failure and trigger | Detection/evidence | Immediate containment | Recovery | Cleanup | Accountable function | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| F-01 | Tenant candidate adds an unauthorized source/field/capability/destination or weakens a bound. | Semantic evaluator emits fixed `POLICY_BROADER_*`; candidate/effective digests and counterexample dimension in protected audit. | Candidate contributes no permit; enter `SafetyHold`. | Correct desired state, new higher revision, fresh approval/signature; review signer/control-plane path. | Remove candidate from publish head after preserving audit; verify no permits/events were produced. | Product policy semantics + tenant policy operations. | T-010, T-011. | Lattice bug could misclassify; property/differential tests are essential. |
| F-02 | Candidate uses unknown member, duplicate JSON member, malformed UTF-8, overflow, excess depth/items, or noncanonical bytes. | Strict tokenizer/schema code; bounded parse counters. | Quarantine candidate; valid unexpired active state may continue. | Generate canonical supported artifact at higher revision if revision was reserved; republish. | Delete partial/temp payloads; retain digest/error code only as permitted. | Endpoint policy runtime + control-plane API. | T-001, T-002, T-030. | Parser/library vulnerability remains possible. |
| F-03 | Artifact selects `none`, unexpected algorithm, wrong key type, untrusted key URL, embedded JWK, or malformed signature. | Fixed JOSE profile rejects protected header/key mismatch. | `SafetyHold`; stop new collection. | Investigate publication/signing compromise; rotate/revoke; re-sign known-good state. | Purge untrusted artifacts from distribution/cache; scan audit access. | Key custody + incident response. | T-003, T-023. | Cryptographic library or root compromise. |
| F-04 | Policy signed by a valid key for another realm or claims another realm. | Pinned enrollment binding/key namespace and server-auth realm mismatch. | `SafetyHold`; cross-realm incident; no permit/ingestion. | Re-enroll only through governed device identity process or publish correct realm artifact. | Quarantine/delete cross-realm payload according to incident/legal decision; verify no visibility. | Realm identity + incident response. | T-004, T-018, T-019. | Enrollment/root compromise can defeat realm binding. |
| F-05 | Replay of lower revision or older stream head. | Highest-seen revision/digest and chain check. | `SafetyHold`; freeze/replay alert. | Publish fresh higher revision; validate repository and clocks. | Remove stale mirror/cache entry; preserve replay evidence. | Policy distribution + incident response. | T-005, T-024. | First-install endpoint without trusted head relies on enrollment/bootstrap metadata. |
| F-06 | Different content appears at the same revision. | Same `(realm,stream,revision)` with different digest. | `SafetyHold`; stop stream. | Determine authorized digest, rotate key if compromise suspected, publish next revision. | Remove conflicting artifact; reconcile immutable logs. | Signer + policy distribution. | T-006. | Colluding signer/store may falsify history unless audit is independently durable. |
| F-07 | Stream head freezes while endpoints continue an old policy. | Signed expiry, expected sequence checks, fleet age distribution, fetch health. | Collection stops at hard expiry; before expiry, raise `POLICY_FREEZE_SUSPECTED` according to approved threshold. | Restore distribution or publish signed recovery metadata/policy. | Validate mirrors/caches and close stale alerts. | Policy distribution + endpoint operations. | T-007, T-022, T-024. | Long offline operation conflicts with fast revocation; human trade-off remains. |
| F-08 | Active policy or ceiling expires offline. | Local trusted-time evaluation and health state. | At expiry, cancel runs and disable all collection; keep privacy-safe fetch diagnostics. | Reconnect and obtain valid artifact, or approved enterprise policy package. | Discard stale permits/candidates; retain bounded audit. | Endpoint operations + tenant policy operations. | T-007. | Clock uncertainty can stop legitimate collection. |
| F-09 | Wall clock moves backward to extend validity or forward to force expiry. | Persisted max authenticated time, monotonic anchors, discontinuity event. | Backward/unprovable time: `SafetyHold`; forward anomaly: disabled pending corroboration, no silent reactivation. | Corroborate via authenticated server/release time; repair host time under runbook; re-evaluate artifacts. | Clear only signed/authorized clock hold; preserve safe event. | Endpoint operations + security incident response. | T-008. | Sophisticated OS/admin compromise can alter all local time sources/state. |
| F-10 | Old agent receives unsupported schema/interpreter/transform. | Compatibility range and registration matrix. | Candidate quarantined; no permission from it; LKG continues only if valid and compatible. | Publish signed version-specific variant or upgrade agent. | Remove accidental head assignment; update rollout guard. | Release management + tenant policy operations. | T-009, T-024. | Maintaining many cohorts increases cost and error probability. |
| F-11 | New release installs without a policy signed for its exact ceiling. | Release readiness and endpoint `POLICY_CEILING_MISMATCH`. | `DisabledNoCompatiblePolicy`; no source permit. | Publish/approve compatible variant or roll forward to authorized release package. | Reconcile rollout inventory; no automatic digest rebinding. | Release management + tenant policy operations. | T-027, T-024. | Availability loss if policy/release coordination fails. |
| F-12 | Transform graph has a cycle, false edge, or incomparable meet is guessed. | Build-time graph proof, differential/property tests, semantic validator. | Ceiling/release rejected; no collection-capable install. | Correct registry/code, new ceiling/release, review all affected output. | Quarantine any data from faulty release and run canary/deletion incident flow. | Product privacy authority + transform engineering. | T-011, T-016. | Human approval of an incorrectly minimizing transform remains possible. |
| F-13 | Candidate write/cache activation crashes or disk corrupts. | SQLite integrity/state checks; active pointer/digest mismatch; crash-injection trace. | Never use partial candidate; preserve old committed active policy if valid; corrupt active state disables collection. | Refetch immutable artifact; rebuild cache transactionally; reinstall/re-enroll only if trust metadata is lost. | Delete orphan temp blobs/WAL remnants after evidence capture; verify no permissive reconstruction. | Endpoint policy runtime + endpoint operations. | T-013. | Storage/OS compromise can falsify local state; signed artifacts and highest-head protection limit it. |
| F-14 | Policy narrows while a Task Host is reading or has output buffered. | Effective-policy digest/nonce mismatch at User Host and Coordinator commit. | Cancel Task Host; discard post-effective output; no cursor advance. | Start new run under new permit; source cursor remains at last durable authorized event. | Clear buffers/process; scan IPC/database/log sinks for canaries. | Endpoint collection runtime. | T-015, T-016. | Race in process termination could allow additional in-memory read; no output may cross boundary. |
| F-15 | Coordinator compromise overschedules or requests broad source. | User Host independently evaluates source, interval/budget, signed artifacts, and RunIntent; server anomaly metrics. | User Host rejects; Task Host not launched; incident if repeated. | Repair/reinstall Coordinator release; verify binary and cache; rotate local session secrets. | Scan endpoint sinks and run history; no raw diagnostic capture. | Endpoint security + incident response. | T-015, T-028. | A compromised Coordinator with OS-level escalation may bypass boundaries. |
| F-16 | User Host compromise mints broad/rapid permits. | Task Host fixed ceiling/permit profile and Coordinator durable schedule/output validation; server provenance/rate checks. | Reject unknown/broad permit/output; terminate session host; local safety hold. | Restart trusted User Host under verified release; invalidate ephemeral keys/nonces. | Scan outputs/outbox/server quarantine; investigate session. | Endpoint security + incident response. | T-015, T-017, T-028. | Allowed-shaped covert output remains difficult to distinguish. |
| F-17 | Task Host compromise reads more data or emits raw/encoded values. | Sandbox/no-network profile, permit bounds, output schema, deterministic transform vectors, forbidden-canary scanner including encodings. | Kill Task Host; reject output; no cursor advance; `SafetyHold` on canary. | Replace release, investigate source/transform, rotate relevant tokenization key if applicable. | Quarantine/delete affected events after human decision; scan all sinks and dumps. | Endpoint security + privacy incident response. | T-016, T-017, T-028. | Semantic covert channels and unknown encodings cannot be exhaustively proved absent. |
| F-18 | Coordinator accepts raw or unknown output through IPC. | Generated schema/field allowlist, size limits, policy/permit digest checks, sink canary. | Reject transaction; no cursor advance; stop source/collection on canary. | Correct process/release; re-run under clean permit. | Scan SQLite DB/WAL/log/dumps/support bundle; delete/quarantine under incident plan. | Endpoint collection runtime. | T-016, T-017. | Validator defect shared with other components if code is not diversified/differentially tested. |
| F-19 | Server trusts payload realm or accepts overbroad fields/provenance. | Authenticated registration-derived realm; schema/provenance/hard-deny validation; cross-realm tests. | Quarantine before materialization/visibility; incident on realm/canary. | Correct server release/rules; replay only verified permitted batches. | Governed deletion from inbox/quarantine/materialized/exports; restore verification. | Ingestion security + data operations. | T-017, T-018. | Server compromise can still expose/delete data; realm DB controls and audit are separate defenses. |
| F-20 | Portal/BFF omits realm filter, exposes policy body, or permits unaudited mutation. | Query/mutation authorization tests, audit invariant, DLP/canary scans, security review. | Disable affected endpoint/API; revoke sessions; stop policy publication if integrity affected. | Patch, reauthorize, replay only immutable audited state. | Access review, cache/search/export cleanup, affected-realm notification decision. | Portal security + incident response. | T-019, T-021, T-026. | Browser screenshots/user misuse and authorized insider access remain human/access risks. |
| F-21 | Logs include policy JSON, source values, path, username, URL, exception object, target, or identifiers. | Static sink analyzer, runtime canary scan, structured-log schema allowlist. | Disable offending diagnostic path/source; `SafetyHold` for forbidden canary. | Patch formatter; redeploy; validate support paths. | Delete/rotate logs, exports, crash dumps, indexes, and backups according to incident decision. | Observability + privacy incident response. | T-021. | Third-party EDR/crash tooling outside UAM may capture process memory; must be assessed operationally. |
| F-22 | Metrics use realm/device/user/policy digest or unbounded error/source values, causing leakage/cost/memory exhaustion. | Instrument/attribute allowlist; hard series counters; `uam_metric_cardinality_dropped_total`. | Drop/collapse excess to fixed `other`; never spill raw value into log. | Fix instrumentation/View; reset exporter/process if needed. | Delete offending time series where feasible; review dashboards/alerts. | Observability engineering. | T-020, T-030. | Cardinality cap does not make sensitive labels acceptable; allowlist remains primary. |
| F-23 | Emergency kill switch cannot reach offline endpoint or expires unexpectedly. | Fleet policy age/overlay status by coarse buckets; simulation of expiry state. | Online endpoints disable immediately; offline endpoints rely on local signed expiry/ceiling and cannot be guaranteed immediate. | Enterprise deployment/local approved recovery action; reconnect; publish renewed overlay with fresh authorization. | Reconcile endpoint states; close overlay only after base policy safe. | Incident response + endpoint operations. | T-014, T-022, T-024. | Immediate remote control of disconnected devices is impossible. |
| F-24 | Kill-switch signer is abused to enable data or target people. | Constrained schema/key policy accepts disable IDs only; signer monotonic check. | Reject and `SafetyHold`; revoke constrained key. | Rotate key; inspect signer service/control requests. | Remove malicious candidate and audit credentials. | Key custody + incident response. | T-014, T-023. | Signer implementation bug/collusion. |
| F-25 | Policy simulation or impact preview queries production activity/person data. | Data-access allowlist and query tests; simulator input schema; audit. | Block query; disable simulator feature; no signing. | Replace with inventory-only aggregate simulation. | Delete preview exports/cache; incident/access review if data was exposed. | Control-plane privacy + data governance. | T-029, T-019. | Coarse inventory can still be identifying in very small cohorts; suppression rules need human approval. |
| F-26 | Cohort/target membership drifts or is cross-realm. | Enrollment-owned membership revision/digest, realm constraint, simulation/activation snapshot. | Target miss or disable affected policy; no fallback to all devices. | Correct membership, publish new higher policy revision if semantics change. | Audit membership changes; no activity-based backfill. | Device inventory + tenant policy operations. | T-004, T-029. | Stale inventory can cause availability gaps or unintended but realm-local scope. |
| F-27 | Application catalogue import treats missing external ID/name text as authority or silently merges records. | Import validation report, UAM ID uniqueness, no inferred role/rule fields. | Reject ambiguous merge; quarantine invalid row; no collection policy generated. | Owner resolves mapping through governed import revision. | Remove inferred rules; re-run synthetic tests. | Application catalogue governance. | T-025. | Catalogue currentness/meaning remains unknown without owner evidence. |
| F-28 | Signing key compromise or unauthorized signing approval. | Key-use audit, threshold mismatch, unusual revision/diff, independent endpoint monotonicity. | Revoke/rotate; emergency disable; `SafetyHold` for suspect stream. | Re-establish root/realm trust through recovery ceremony; re-sign known-good artifacts. | Investigate all artifacts signed in exposure window; quarantine/delete affected data. | Key custody + incident response. | T-023. | If enough threshold keys and approvals are compromised, signatures cannot distinguish attacker. |
| F-29 | Product release binary is malicious but carries a valid broad ceiling. | Independent privacy/release thresholds, reproducible build/provenance, binary-ceiling digest linkage, canary and code review. | Stop deployment/execute emergency disable; enterprise rollback via authorized release. | New clean release and keys if needed; forensic/release incident process. | Scan and delete over-collected data; verify endpoints and integrations. | Product security + release authority + privacy authority. | T-027, T-028. | Collusion or supply-chain compromise across all authorities is residual. |
| F-30 | Policy parser/evaluator consumes excessive CPU/memory or cardinality under adversarial input. | Size/depth/count guards, benchmark/fuzz harness, allocation/time metrics with fixed labels. | Reject before/within bounded work; quarantine candidate; rate-limit fetch retry. | Patch and re-release; keep old active policy if safe. | Remove malicious blobs and diagnostic artifacts. | Endpoint policy runtime + product security. | T-030. | Algorithmic complexity bug or crypto DoS may remain. |
| F-31 | Support bundle includes sensitive data or becomes a general collection channel. | Schema allowlist, deterministic bundle test, canary scan, size cap. | Abort bundle creation; disable support feature if canary. | Patch; issue new release; use fixed health codes meanwhile. | Delete bundles from endpoint/ticket/store/export; access review. | Support engineering + privacy incident response. | T-021. | External ticketing/user-added attachments remain outside automated guarantees. |
| F-32 | Policy UI is inaccessible, leading to mistaken broad rollout or inability to emergency-disable. | WCAG 2.2 checks, keyboard/screen-reader manual tests, non-color status and confirmation tests. | Provide accessible CLI/operational fallback that still signs/audits; pause rollout. | Correct UI and rerun approval simulation. | Review affected changes for operator error. | Portal product/accessibility + policy operations. | T-026. | Accessibility testing cannot cover every assistive technology; human validation remains. |
| F-33 | Data quality is silently changed by minimization or policy migration. | Transform/schema provenance, quality enum, deterministic vectors, before/after synthetic comparison. | Quarantine incompatible output; do not coerce/merge. | New transform/schema/version and explicit migration. | Correct derived aggregates; replay only allowed minimized source events. | Data quality + transform engineering. | T-011, T-017. | Minimized data may be insufficient for some business interpretation; that is a product trade-off, not a reason to collect more silently. |

## 7.3 Privacy-safe observability contract

**RECOMMENDATION.** Endpoint and control-plane telemetry uses fixed schemas and low-cardinality enums only.

Permitted examples:

```text
policy.state = active|disabled|quarantined|safety_hold|target_miss
error.class = none|syntax|signature|realm|time|revision|monotonicity|compatibility|cache|runtime
schema.version = 1
component = coordinator|user_host|task_host|ingest|portal|signer
```

Prohibited attributes/message interpolation:

```text
realmId, deviceId, user/session identifier, username/email, policy/artifact digest,
revision as a metric label, cohort/target ID, source value, URL/domain/path/title,
application name/external correlation ID, filename/profile path, IP/address,
exception message/stack containing values, policy JSON, signature/certificate body
```

A digest/revision may be stored in protected audit/provenance, not a metric label. The default support bundle contains fixed error/state codes, schema/interpreter versions, counts, bounded timestamps (rounded where approved), software release ID, and opaque local correlation IDs. It does not contain policy bodies, selectors, raw events, file paths, identifiers, or memory dumps.

OpenTelemetry warns that dimensions such as user IDs or raw URL paths can create unbounded cardinality, and its .NET SDK documentation describes a default limit of 2,000 metric points per metric that can be configured through Views [S-10][S-11][S-12]. **RECOMMENDATION:** UAM starts much stricter—at most 4 attributes per point, 128 series per instrument per process, and 1,024 total active series per process—with overflow collapsed into a fixed `other` series and counted by `uam_metric_cardinality_dropped_total`. These are initial engineering guards, not production SLOs; T-020/T-030 must measure memory and usefulness before acceptance.

## 7.4 Incident-response classes and runbooks

| Incident class | Examples | Required first action | Required runbook evidence |
|---|---|---|---|
| P0 privacy boundary | Forbidden canary in IPC/storage/log/network/server/portal; cross-realm visibility. | Stop collection via local hold and signed overlay; quarantine affected data. | Timeline, provenance range, all-sink scan, deletion decision/execution, clean canary rerun, key/release decision. |
| P1 policy integrity | Invalid trusted signature, wrong realm, rollback, same-revision conflict, broader signed policy, key compromise. | `SafetyHold`, freeze publication, preserve immutable audit. | Artifact digests, key-use audit, head history, revocation/rotation, recovery revision, endpoint convergence. |
| P2 availability/safety | Expired policy, incompatible agent, distribution outage, cache corruption, inaccessible UI. | Keep collection disabled or LKG only under defined safe case; diagnose with fixed codes. | Fleet state by coarse bucket, recovery test, no raw support collection. |
| P3 quality/operability | Target miss, transform/schema mismatch, metric overflow, simulation discrepancy. | Pause rollout/materialization; do not broaden collection as a workaround. | Synthetic reproduction, corrected version, quality impact, rollout evidence. |

Every runbook MUST name decision authority, technical executor, communications path, audit location, evidence retention, deletion/cleanup owner, recovery gate, and post-incident ADR trigger. The names are human decisions; the fields are mandatory.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Test principles

- Tests use only synthetic data and fictional realm/device/cohort/application identifiers.
- Every negative case asserts **no new permit, no new minimized event, no cursor advance, and a fixed privacy-safe health/audit code** unless the case is a normal `TargetMiss`.
- A test passes only on evidence, not a console claim. Evidence includes signed fixture hashes, state-machine traces, transaction snapshots, packet/IPC captures sanitized by the scanner, TRX/JUnit results, deterministic seeds, and all-sink canary reports.
- Property failures persist the minimal counterexample and seed as a regression fixture.
- “Duration” below is an **ESTIMATE** for planning and must be replaced by measured CI/lab duration. It is not a production SLO.
- Any forbidden-canary hit is an immediate stop gate; do not continue downstream gates to collect more evidence.

## 8.2 Smallest falsifying prototypes

### P-01 — Pure monotonic evaluator

| Field | Specification |
|---|---|
| Setup | One .NET solution containing immutable domain types, strict semantic validator, transform DAG, `IsNarrowerOrEqual`, `Meet`, and test generators. No Windows source access. |
| Instrumentation | TRX/JUnit, deterministic seeds, branch/mutation coverage, serialized minimal counterexample, evaluator version/digest. |
| Steps | Generate valid ceilings; generate equal/narrower policies; mutate one dimension broader/unknown/incomparable; evaluate algebraic laws and postcondition. |
| Pass | All valid narrower policies satisfy `E ⪯ C`; every broader/unknown mutation yields no effective permit and correct fixed code; meet laws hold for supported dimensions. |
| Fail | Any counterexample, exception, nondeterministic result, timeout, or permissive default. |
| Evidence | Test report, seeds, counterexample corpus, coverage/mutation report, canonical fixture manifest. |
| Duration | **ESTIMATE:** 1–3 engineer-days for first executable model; PR suite minutes; nightly larger corpus. |
| Cleanup | Synthetic temp files only; archive failed counterexamples in repository. |

### P-02 — Strict signed-artifact verifier

| Field | Specification |
|---|---|
| Setup | Synthetic ES256 keys, JCS/JWS fixtures, duplicate-member raw byte fixtures, unknown headers/algorithms/keys, size/depth bombs. |
| Instrumentation | Phase timing/allocation counters with fixed labels; typed trace showing last successful phase; no payload logging. |
| Steps | Verify valid threshold envelope; mutate bytes/headers/order/encoding/signature; test canonical byte equality and key/profile binding. |
| Pass | Only exact canonical, correctly signed, allowlisted-profile artifact verifies; all failures return bounded fixed codes and zero semantic activation. |
| Fail | Parser normalizes duplicates, accepts a noncanonical equivalent, follows remote key material, accepts wrong algorithm/key, or leaks payload. |
| Evidence | Fixture hashes, test report, fuzz corpus, allocation/time report, sink scan. |
| Duration | **ESTIMATE:** 2–4 engineer-days. |
| Cleanup | Destroy synthetic private keys after fixture generation unless checked-in test keys are explicitly marked non-secret. |

### P-03 — SQLite cache/activation crash harness

| Field | Specification |
|---|---|
| Setup | Temporary SQLite WAL database, candidate/active schema, deterministic failpoints before/after every write/commit/fsync boundary. |
| Instrumentation | Transaction trace, DB integrity check, active/head rows, policy state/audit rows, file hashes. |
| Steps | Activate revision N; attempt N+1 while injecting process kill/power-loss simulation at each failpoint; reopen and evaluate. Corrupt candidate and active pages separately. |
| Pass | State is either fully N or fully N+1; partial candidate never active; highest head never rolls back; corrupt active disables/refetches; no permissive reconstruction. |
| Fail | Mixed state, candidate activation without audit, rollback, or collection enabled from corrupt data. |
| Evidence | Failpoint matrix, DB snapshots, integrity output, state traces. |
| Duration | **ESTIMATE:** 2–5 engineer-days plus automated run. |
| Cleanup | Securely delete synthetic DB/WAL/SHM files after artifact capture. |

### P-04 — Three-process permit harness

| Field | Specification |
|---|---|
| Setup | Coordinator/User Host/Task Host test executables under synthetic session identities; fixed synthetic source; protected local IPC; controllable clock/policy changes. |
| Instrumentation | Process/permit state trace, bounded IPC capture, source-read counter, output/cursor transaction trace, handle/network policy checks. |
| Steps | Run valid permit; forge each binding; replay; change policy mid-read; kill each process; attempt unknown source/transform/field/extra output. |
| Pass | Only a valid one-time permit yields minimized output; policy narrowing cancels/discards; no cursor advance on failure; Task Host has no general network/write path. |
| Fail | Any raw canary crosses Task Host boundary, stale permit commits, or one process alone authorizes broader collection. |
| Evidence | Signed fixture manifest, process trace, IPC scan, DB state, Windows security configuration output sanitized of internal values. |
| Duration | **ESTIMATE:** 5–10 engineer-days; lab run under one hour after automation. |
| Cleanup | Remove test service/tasks/users/source DB and all synthetic artifacts; verify no test process remains. |

### P-05 — End-to-end forbidden-canary sink scanner

| Field | Specification |
|---|---|
| Setup | Synthetic source rows containing unique canaries in raw URL/path/title/query-like fields and encoding variants; endpoint/test server/portal sinks. |
| Instrumentation | Scanner reads only test artifacts; packet/IPC capture; SQLite DB/WAL/SHM; logs; traces; dumps; support bundle; inbox/quarantine/materialized DB; API/UI export. |
| Steps | Run valid minimizing transform, error paths, crash paths, diagnostics, retries, policy failures, and support collection. Scan literal, case, UTF-8/UTF-16, URL/base64/hex, compressed, hashed-known-fixture, and fragmented variants. |
| Pass | Zero forbidden canary or reversible encoding in every sink beyond Task Host transient input; only approved minimized synthetic token/bucket appears. |
| Fail | Any hit, including in exception, crash dump, metric label, audit, temp file, network body, or quarantine visible to portal. |
| Evidence | Machine-readable sink inventory and zero-hit report with hashes; packet/DB/log manifests. |
| Duration | **ESTIMATE:** 3–7 engineer-days for scanner/integration; automated run hours. |
| Cleanup | Delete all test sinks/exports/dumps and confirm with second scan. |

### P-06 — Server/portal realm and provenance harness

| Field | Specification |
|---|---|
| Setup | Two fictional realms, devices, policies, batches, users/roles; synthetic durable inbox and BFF. |
| Instrumentation | Database/query audit, authenticated realm context, response capture, mutation audit transaction, canary scan. |
| Steps | Swap payload realm/device/policy; cross-query; omit realm filter; inject unknown fields/provenance; force audit failure; test policy mutation and simulation inputs. |
| Pass | Auth context determines realm; all cross-realm/unknown/overbroad data rejects/quarantines; failed audit prevents mutation success; portal cannot see quarantine/raw policy bodies. |
| Fail | Payload chooses realm, cross-realm result/mutation, unaudited success, or policy simulation reads activity. |
| Evidence | Integration tests, query plans/SQL capture with synthetic IDs, audit rows, response hashes, scan report. |
| Duration | **ESTIMATE:** 4–8 engineer-days. |
| Cleanup | Drop synthetic realms/databases and revoke test credentials. |

### P-07 — Compatibility, expiry, rotation, and offline harness

| Field | Specification |
|---|---|
| Setup | Agent interpreters v1/v2 test doubles, old/new ceilings, policy variants, key overlap/revocation, controllable authenticated/wall/monotonic time, offline artifact cache. |
| Instrumentation | State transitions, highest-seen sequences, key-use evidence, policy/ceiling compatibility matrix. |
| Steps | Deliver unsupported policy; upgrade release without variant; expire offline; rotate keys through overlap; replay old metadata; jump clocks; recover with higher revision. |
| Pass | Compatible variant only activates; old agent never ignores unknowns; expiry disables; rollback/freeze detected; recovery preserves monotonic heads. |
| Fail | Automatic ceiling rebinding, indefinite LKG, lower revision recovery, or clock rollback extends permission. |
| Evidence | Matrix report, state traces, fixture manifest, no-permit assertions. |
| Duration | **ESTIMATE:** 3–6 engineer-days. |
| Cleanup | Delete synthetic keys/caches and reset virtual clocks/test doubles. |

## 8.3 Detailed test matrix

| Test | Setup/input | Instrumentation and steps | Pass/fail gate | Evidence | Duration/cleanup |
|---|---|---|---|---|---|
| T-001 Duplicate/unknown strict parse | Valid canonical policy; raw variants with duplicate `mode`, duplicate source ID, unknown member, invalid UTF-8, trailing bytes. | P-02 tokenizer before object parse. | Each variant rejects with exact code; zero candidate activation/permit; no value logged. | Fixture hashes, typed phase trace, sink scan. | **ESTIMATE:** minutes/run; delete temp fixtures. |
| T-002 JCS determinism | Semantically equivalent whitespace/property-order/escape forms. | Canonicalize across CLI, signer, endpoint test double, server. | All produce one canonical digest; noncanonical signed bytes reject if byte-equality required. | Cross-implementation digest table. | Minutes; retain public fixtures. |
| T-003 JOSE/key confusion | `none`, ES384, RS256, wrong P-256 key, malformed R/S, duplicate signature, unknown header, `jku/x5u/jwk`. | P-02 verification matrix. | Only configured ES256/key IDs/threshold pass; no network key fetch. | Matrix + network capture. | Minutes; destroy synthetic private keys if ephemeral. |
| T-004 Wrong realm/key | Realm A policy signed by A delivered to B; payload realm edited; B key signs A body. | P-07/P-06. | `SafetyHold`, zero permits, server rejection, privacy-safe incident event. | Endpoint/server traces. | Minutes; drop synthetic realms. |
| T-005 Revision rollback | Active 43, deliver 42 or replay 41; deliver stream head older than highest seen. | P-03/P-07. | `POLICY_REVISION_ROLLBACK`, `SafetyHold`, active run cancelled. | Cache/head/audit snapshots. | Minutes; reset DB. |
| T-006 Same revision conflict | Revision 43 digest A active, deliver 43 digest B validly signed. | P-03/P-07. | Conflict detected even with valid signature; collection stops. | State trace and digests. | Minutes. |
| T-007 Expiry/no indefinite LKG | Candidate expired; active reaches expiry offline; ceiling expires. | Controlled clocks P-07. | Candidate no effect; active/ceiling expiry cancels runs and disables. | Time/state/permit trace. | Minutes virtual time; reset clock. |
| T-008 Clock rollback/forward | Move wall clock backward/forward around validity; preserve monotonic/authenticated max. | P-07. | Backward does not extend permission; uncertain time issues no permit; recovery requires corroboration. | Clock state snapshots. | Minutes; restore host/test clock. |
| T-009 Unsupported old agent | v1 agent receives schema/interpreter/transform v2. | P-07. | Candidate quarantined, no new permission; valid v1 LKG behavior follows table; no ignored unknowns. | Compatibility matrix. | Minutes. |
| T-010 Per-dimension broadening | Mutate source, field, capability, destination, lookback, interval, event/byte limit, diagnostic, target, validity. | P-01 generated boundary cases. | Every mutation rejects exact dimension; no meet result broader than ceiling. | Counterexample corpus + report. | PR/nightly; persist failures. |
| T-011 Transform lattice | Valid DAG; cycles; false/missing edge; incomparable nodes; multiple lower bounds. | Graph validator + property/differential tests. | Cycles/incomparable meet reject; reachability deterministic; conformance vectors match. | Graph proof output, test corpus. | Minutes to hours. |
| T-012 Bad candidate vs LKG | Active valid LKG; deliver malformed/unsupported vs invalid-signature/wrong-realm/broader candidates. | P-03/P-07 state table. | Ordinary malformed/unsupported candidate quarantines and LKG continues; security-significant candidate triggers `SafetyHold`. | State transition coverage. | Minutes. |
| T-013 Cache crash matrix | Failpoint at every candidate/blob/activation/head/audit write boundary; page corruption. | P-03. | Only old/new committed states; never mixed/permissive; audit and pointer atomic. | Failpoint matrix/DB hashes. | Hours automated; purge temp DBs. |
| T-014 Kill-switch monotonicity | Emergency signer attempts disable, enable, target person, extend expiry, add source. | P-01/P-07. | Only fixed short-lived disable overlay signs/activates; expiry preview correct. | Signer/evaluator tests and audit. | Minutes. |
| T-015 Mid-run narrowing and process compromise simulation | Long synthetic read; activate narrower policy; forge Coordinator intent/User Host permit; replay nonce. | P-04. | Task cancelled, buffered output discarded, no cursor advance; forged/replayed values reject. | Process/IPC/DB trace. | Under hour; remove harness. |
| T-016 Forbidden raw canaries | Unique raw canaries and encoded variants through success/error/crash paths. | P-05 all-sink scanner. | Zero hits beyond transient Task Host input; any hit stops G4. | Signed zero-hit report. | Hours; delete test sinks and rescan. |
| T-017 Output/provenance schema | Unknown field, allowed-shaped raw canary, wrong transform/schema/permit digest, oversize output. | P-04/P-06. | User Host/Coordinator/server reject; no cursor/materialization; canary incident if matched. | Traces and quarantine state. | Minutes-hours. |
| T-018 Server realm derivation | Auth device A sends payload claiming B; cross-realm batch/policy provenance. | P-06. | Realm from auth; mismatch rejected; no cross-realm durable semantic effect/visibility. | DB/audit/API report. | Minutes. |
| T-019 Portal/BFF realm and audit | Cross-realm route/body/query, direct signer call, mutation with audit DB failure, simulation activity query. | P-06. | All deny; mutation cannot report success without audit; signer unreachable from browser path. | Security integration report. | Hours. |
| T-020 Metric cardinality | Generate unique fake realms/devices/errors/digests/source IDs beyond caps. | In-memory/exporter measurement, inspect labels. | Prohibited labels never emitted; allowlisted series cap enforced; overflow fixed `other`; bounded memory. | Series/allocation/export snapshot. | Minutes-hours; clear test backend. |
| T-021 Log/support/crash sink | Trigger every error and support-bundle path with canaries in policy/source/path/exception. | Static sink analyzer + P-05. | Fixed codes only; zero canary/identifier/policy body in all sinks. | Sink manifest/scan. | Hours; purge bundles/logs. |
| T-022 Offline key rotation | Endpoint offline before/during/after key overlap; old metadata replay; revocation. | P-07. | Approved overlap works; stale/revoked metadata cannot activate; no unsigned escape. | Rotation timeline/state matrix. | Virtual days in minutes. |
| T-023 Key compromise/recovery | Sign broader tenant policy with compromised realm key; compromise one product ceiling key below threshold; revoke and recover. | P-01/P-07. | Endpoint ceiling still rejects tenant broadening; one product key insufficient; recovery higher sequences only. | Signature/threshold/recovery report. | Hours; destroy test keys. |
| T-024 Rollout/canary/recovery | Stage synthetic->canary->expand; inject health/canary failure; recover prior semantics at higher revision. | Control-plane state harness. | Auto pause; no lower revision; overlay can disable; convergence report accurate without personal data. | State/audit/fleet-bucket report. | Hours virtual rollout. |
| T-025 Catalogue import safety | Synthetic 173-row shape with 5 missing external refs, non-ASCII, truncation-like, address-like names, no rule dimensions. | Import validator and ID mapping. | 173 UAM stable IDs; no name/role/rule inference; missing refs remain optional/flagged; duplicates reject. | Deterministic aggregate report only. | Minutes; delete synthetic values. |
| T-026 Accessibility | Policy editor/diff/simulator/emergency flow with keyboard, zoom/reflow, high contrast, screen reader, error status. | Automated WCAG checks plus manual assistive-tech scripts. | WCAG 2.2 AA target for applicable criteria; no color-only state; emergency action and rollback operable. | Tool report + manual checklist/video only if privacy-approved. | **ESTIMATE:** 1–2 days per major flow; remove test accounts. |
| T-027 Release-ceiling binding | Swap ceiling file, transform assembly, output schema, conformance vectors, package after signing; install without matching policy. | Manifest verifier and endpoint startup. | Any digest mismatch prevents collection-capable execution; missing matching tenant variant disables. | Manifest/provenance/startup trace. | Minutes. |
| T-028 Process/release attack simulation | Replace one test process/binary, attempt arbitrary command/plugin/network/file write and allowed-shaped covert values. | Code-integrity/sandbox/network/IPC checks and scanners. | Fixed profiles block command/plugin/network; downstream rejects detectable violations; residual covert-channel limits documented. | Security harness report. | Days to implement; hours/run; restore VM snapshot. |
| T-029 Targeting/simulation privacy | Submit username/email/HR/free-text/activity selector; tiny cohorts; cross-realm membership. | API/schema/query/audit tests. | Unsupported target fields reject; simulator uses inventory-only schema; no fallback-to-all. | Query/input/output report. | Hours. |
| T-030 Resource/DoS fuzz | Max-size arrays, deep JSON, large signatures, transform graph extremes, repeated candidates, cardinality flood. | Fuzz + timeout/allocation counters. | Work bounded by approved measured budgets; no crash/hang/unbounded memory/log storm; active safe policy unaffected. | Fuzz corpus and percentile/allocation report. | Nightly hours; retain minimal crashes only. |

## 8.4 Mandatory canary inventory and scan procedure

Create unique synthetic canaries per forbidden class and run, for example:

```text
UAMCANARY_RAWURL_<run-id>
UAMCANARY_QUERY_<run-id>
UAMCANARY_TITLE_<run-id>
UAMCANARY_PATH_<run-id>
UAMCANARY_USER_<run-id>
UAMCANARY_POLICYBODY_<run-id>
UAMCANARY_REALM_A_<run-id>
```

The scanner MUST search:

1. literal UTF-8 and UTF-16 forms;
2. case-normalized and Unicode-normalized forms;
3. URL/form encoding, JSON escaping, base64/base64url, hex, and common compression containers used by UAM;
4. known salted/unsalted test hashes and token outputs where the test keys are controlled;
5. fragment windows across record/chunk boundaries;
6. endpoint process standard output/error, Windows event channels used by UAM, structured logs, traces, metrics/exemplars, temp files, crash dumps, support bundles;
7. Coordinator/User Host/Task Host IPC captures;
8. endpoint SQLite database, WAL, SHM, outbox, backups, and deleted-page test copies where safely available;
9. HTTPS request/response captures in the synthetic lab;
10. server durable inbox, quarantine, validation errors, worker state, materialized tables, audit, logs, traces, metrics, cache, search/index, API response, portal render/export;
11. test integrations/exports/backups included in the slice.

**Pass:** zero forbidden canary/reversible representation outside the Task Host’s controlled transient raw-input buffer. The scan itself records only canary IDs and sink hashes, never raw production values. **Failure:** immediately stop G4 and dependent gates, preserve minimal sanitized evidence, activate disablement, and execute the P0 runbook.

## 8.5 Failure/recovery canary matrix

| Injected failure | Expected collection state | Expected durable state | Recovery proof | Cleanup proof |
|---|---|---|---|---|
| Invalid signature candidate | `SafetyHold`, zero new permits | Candidate/error audit only; active pointer unchanged | Revocation/known-good higher revision re-enables only after verification | Untrusted blob removed; all-sink zero canary |
| Unsupported candidate | LKG may continue if valid; candidate zero permission | Candidate quarantined; active pointer intact | Compatible signed variant activates atomically | Unsupported blob retired per cache policy |
| Active expiry offline | Disabled at expiry | Expired state/audit; cursor unchanged | Fresh signed artifact plus trusted time | Stale permits/blobs cannot reactivate |
| Broader field/transform/limit | `SafetyHold` | Counterexample dimension/code; no event/cursor commit | Correct higher revision after investigation | Scan proves no forbidden output |
| Crash before activation commit | Old active state | No partial active pointer | Restart/re-evaluate candidate | Orphan temp rows/files removed |
| Crash after activation commit | New active state with audit/head | Fully committed new state | Restart yields same digest/revision | No duplicate/mixed state |
| Policy narrows mid-run | Task cancelled; no stale output commit | Cursor at last authorized durable event | New permit/run starts from safe cursor | Buffers/process removed; sinks zero canary |
| Task Host raw-canary emission | Source/stream stopped, `SafetyHold` | Rejected/quarantine evidence only | Clean release and canary rerun | Governed deletion + second zero scan |
| Server cross-realm claim | Endpoint may upload, server rejects/quarantines | No cross-realm materialized/visible effect | Correct authenticated provenance replay if otherwise valid | Quarantine cleanup and realm query proof |
| Kill-switch delivery outage | Online targets disabled; offline governed by local expiry | Overlay state by reached endpoint; no false success claim | Reconnect/enterprise delivery and convergence evidence | Overlay expiry/base-policy preview validated |


---

# 9. Architecture fitness functions and measurable acceptance criteria

The numerical test counts below are **RECOMMENDATION** acceptance floors for engineering assurance, not fleet SLOs or capacity claims. A prototype may propose a different count only with measured runtime, equivalent boundary coverage, and an ADR; it may not remove the properties.

| ID | Fitness function/invariant | Measurement | Acceptance criterion | Stop/action on failure |
|---|---|---|---|---|
| FF-01 | `∀C,T: Valid(C,T) ⇒ Eval(C,T) ⪯ C` | Property generator plus exhaustive boundary partitions for every dimension. | Zero counterexamples in at least 10,000 deterministic generated cases per PR and 1,000,000 nightly; every enum/boundary pair covered. | Stop policy implementation; persist minimal counterexample; no G4. |
| FF-02 | Tenant narrowing is monotonic: `T₂ ⪯ T₁ ⇒ Eval(C,T₂) ⪯ Eval(C,T₁)`. | Generate policy pairs and compare normalized effective permits. | Zero counterexamples; tests include source/field removal, tighter bound, coarser transform/diagnostic, smaller target. | Stop; lattice/meet ADR review. |
| FF-03 | Meet algebra is safe. | Check idempotence, commutativity, associativity for supported dimensions and `x ⪯ y ⇔ x ∧ y = x`. | Zero counterexamples; incomparable transforms return typed rejection, not value. | Stop; transform registry cannot ship. |
| FF-04 | Unknown/ambiguous input grants nothing. | Mutation corpus for unknown members/IDs/enums, duplicates, unsupported schema, overflow, null/coercion, graph ambiguity. | 100% reject before activation; no permit/event/cursor; exact fixed code. | Stop G4; add regression fixture. |
| FF-05 | Primary bad-policy gate. | T-001–T-012 and state-table assertions. | Every invalid, expired, unsupported, wrong-realm, rollback, conflict, chain-break, or broader artifact contributes zero new collection permission and produces audited privacy-safe health. | Stop all dependent work. |
| FF-06 | Security-significant failures contain. | Inject signature/realm/rollback/conflict/broadening/clock rollback during active collection. | `SafetyHold` cancels active runs; no stale commit; incident event durable. | P0/P1 runbook; block rollout. |
| FF-07 | Ordinary bad candidate does not trivially DoS safe LKG. | Malformed/unsupported candidate with independently valid unexpired active policy. | Candidate quarantined; active digest/pointer unchanged; no permission comes from candidate. | Fix classification/state machine. |
| FF-08 | Revision and chain never go backward. | Replay lower head/artifact; same-revision conflict; rollback recovery. | Highest-seen revision/digest never decreases; recovery uses higher revision and chains to current head. | `SafetyHold`; distribution/key investigation. |
| FF-09 | Realm isolation. | Pairwise cross-realm matrix at artifact, key, target, permit, upload, inbox, query, mutation, audit, deletion. | 100% cross-realm operations reject; realm derived from enrollment/auth; zero visibility/effect. | Stop release; P0 incident for any visible effect. |
| FF-10 | No single ordinary control plane broadens. | Compromise/fault injection independently at portal, API, signer, repository, Coordinator, User Host, Task Host, server. | For each single-plane case, a separate boundary rejects or plane lacks source-read/activation authority; residual process covert-channel limitations documented. | Threat model/architecture ADR before G4. |
| FF-11 | Forbidden values never cross endpoint privacy boundary. | P-05 scan over the complete enumerated sink inventory for normal/error/crash/retry/support paths. | Exactly zero forbidden canary/reversible encoding outside controlled Task Host raw input. | Immediate G4 failure/P0 incident; no downstream tests. |
| FF-12 | Event/cursor and policy/permit commit safety. | Crash/failpoint matrix at every relevant SQLite write/commit boundary; mid-run policy change. | State is fully old or new; cursor never advances for discarded/uncommitted unauthorized output. | Stop G5 and policy rollout. |
| FF-13 | Release/ceiling/transform/schema binding. | Swap each artifact after signing; missing tenant variant after upgrade. | Any digest mismatch prevents collection-capable execution; no automatic ceiling rebinding. | Stop release/update gate. |
| FF-14 | Compatibility is explicit. | Agent×schema×interpreter×ceiling×transform matrix. | Every supported cell has signed conformance fixture; unsupported cell produces no new permit; no ignored fields. | Block affected cohort/release. |
| FF-15 | Expiry and time cannot increase permission. | Virtual offline/clock jump tests. | No backward jump extends validity; hard expiry disables; uncertain time cannot start a run. | Stop until clock/offline ADR accepted. |
| FF-16 | Emergency controls are narrowing-only and recoverable. | Attempt every forbidden overlay mutation; simulate activation/expiry/base state. | Only fixed disable IDs accepted; overlay is short-lived/audited; expiry never revives invalid/expired base. | Revoke emergency signer; block production. |
| FF-17 | Output/provenance validation is total. | Generated records with every unknown/mismatched/oversize provenance combination. | 100% invalid records reject/quarantine before materialization/visibility; valid records preserve exact provenance. | Stop ingestion gate. |
| FF-18 | Privileged mutation requires audit. | Fault audit store before/during policy, key, target, approval, publish, recovery mutation. | Operation cannot report success without durable audit; retries are idempotent. | Stop portal/control release. |
| FF-19 | Simulator is privacy-minimal. | Static query policy plus runtime DB/query capture and adversarial selector tests. | Only approved inventory schema read; no activity/person attributes; default result aggregate and realm-scoped. | Disable simulator/signing path. |
| FF-20 | Observability is bounded and non-sensitive. | Static sink schema check, cardinality flood, memory/allocation measurement, all-sink canary. | Only allowlisted instruments/attributes; ≤4 attributes/point, ≤128 series/instrument/process and ≤1,024 total initially; excess collapsed; zero prohibited labels/values. | Disable offending instrument/exporter; tune only through ADR/evidence. |
| FF-21 | Policy evaluation resists resource exhaustion. | Fuzz/benchmark max structural limits on minimum supported hardware. | No crash/hang; 99th-percentile time, peak allocation, and process memory remain within an explicitly approved budget produced by CLI evidence. No budget is invented here. | Stop release; reduce limits/optimize and remeasure. |
| FF-22 | Transform quality is explicit. | Synthetic conformance vectors and old/new transform comparison. | Deterministic expected output; unknown/error represented by fixed quality enum; no silent precision increase or schema coercion. | Reject transform/release. |
| FF-23 | Catalogue import does not infer authority. | Synthetic profile matching I-03 quality shape. | Stable UAM IDs for all rows; optional external refs preserved; no policy/role/rule generated from names; ambiguous merge rejects. | Stop import/mapping use. |
| FF-24 | Recovery leaves a safe state. | Run each F-01–F-33 recovery and cleanup checklist. | New higher trusted state, no stale permit, zero canary, required audit, cleanup verification, owner sign-off. | Keep `SafetyHold`/disabled. |
| FF-25 | Policy UI supports safe operation accessibly. | Automated and manual keyboard/screen-reader/reflow/non-color testing against WCAG 2.2 [S-14]. | Applicable WCAG 2.2 AA target passes; approve/diff/emergency/recovery usable without mouse or color; errors focus and explain safe effect. | Pause UI rollout; use audited accessible CLI fallback. |
| FF-26 | Dependency/repository evidence is current. | Execution-time SBOM, license/security/release review for exact versions. | All runtime/test dependencies supported, pinned, licensed, vulnerability-reviewed; point-in-time versions recorded, not embedded as timeless architecture. | Block build/release. |
| FF-27 | Runbooks are executable. | Tabletop plus synthetic technical exercise for P0/P1/P2. | Every required decision/executor/contact/evidence/cleanup/recovery field assigned; emergency disable, key rotation, and policy recovery complete with no raw support collection. | No production approval. |

## 9.1 Formal reference specification

The repository SHOULD contain a small language-neutral reference document and machine-readable conformance corpus. At minimum, the model defines:

```text
PolicyValue = Disabled
            | Enabled {
                Sources,
                FieldsBySource,
                TransformBySource,
                CapabilitiesBySource,
                DestinationsBySource,
                BoundsBySource,
                DiagnosticLevel,
                Target,
                Validity
              }
```

Normalization removes irrelevant values under disabled nodes. This prevents a disabled source with hidden broad fields from becoming dangerous if a later bug flips only `enabled`.

Reference pseudocode:

```text
function Evaluate(ceilingEnvelope, policyEnvelope, trust, endpoint, now): Result
    Cbytes = VerifyEnvelopeAndCanonicalBytes(
        ceilingEnvelope,
        trust.productPrivacyKeys,
        expectedType = "uam-product-ceiling+jws")
    C = StrictParseAndValidateCeiling(Cbytes)
    RequireReleaseBindsCeiling(endpoint.installedRelease, Digest(Cbytes))
    RequireTimeAndSequence(C, trust.ceilingHead, now)

    Pbytes = VerifyEnvelopeAndCanonicalBytes(
        policyEnvelope,
        trust.realmPolicyKeys(endpoint.pinnedRealm),
        expectedType = "uam-tenant-policy+jws")
    P = StrictParseAndValidateTenantPolicy(Pbytes)

    Require(P.realmId == endpoint.pinnedRealm)
    Require(P.streamId == endpoint.expectedStream)
    Require(P.ceilingDigest == Digest(Cbytes))
    Require(P.releaseId == C.releaseId)
    RequireTimeContained(P, C, now)
    RequireRevisionChain(P, trust.policyHead)
    RequireInterpreterCompatible(P, C, endpoint.interpreter)

    if not TargetIncludes(P.target, endpoint.inventoryBinding):
        return TargetMiss(noPermit)

    if P.mode == Disabled:
        E = Bottom
    else:
        E = EmptyEffectivePolicy()
        for each pSource in P.sources:
            cSource = RequireKnownSource(C, pSource.sourceId)
            Require(pSource.enabled <= cSource.enabled)
            Require(Set(pSource.fieldIds) subsetOf Set(cSource.allowedFieldIds))
            Require(Set(pSource.destinationIds) subsetOf Set(cSource.allowedDestinationIds))
            Require(TransformNarrowerOrEqual(C.transformDAG,
                                             pSource.transformId,
                                             cSource.allowedTransformIds))
            Require(pSource.maxLookbackSeconds <= cSource.maxLookbackSeconds)
            Require(pSource.minIntervalSeconds >= cSource.minIntervalSeconds)
            Require(pSource.maxEventsPerRun <= cSource.maxEventsPerRun)
            Require(pSource.maxBytesPerRun <= cSource.maxBytesPerRun)
            Require(AllCapabilitiesKnownAndAllowed(...))
            E.add(NormalizeMeet(cSource, pSource))

        Require(DiagnosticNarrowerOrEqual(C, P.diagnosticLevelId))
        Require(AllFlagsAndSwitchesNarrowOnly(C, P))
        E = Meet(E, ActiveProductOverlays, ActiveTenantOverlays,
                 LocalSafetyState, RuntimeAvailability)

    assert NarrowerOrEqual(E, C)
    return ActiveOrDisabled(E, fixedEvidenceCodes)
```

Every `Require` failure is typed and produces no `EffectivePolicy`. There is no catch-all that returns ceiling defaults.

---

# 10. Human decisions and owner questions

Research supplies conservative temporary defaults; it does not claim approval. Each accountable function below must be assigned to a named role/person through governance.

**FACT / boundary.** GDPR Articles 5 and 25 and EDPB Guidelines 4/2019 provide primary context for data minimization and data protection by design/default [S-13][S-16]. They do not establish UAM's purpose, legal basis, necessity, proportionality, notice, consultation, or production approval; those remain **HUMAN DECISIONS**.

| ID | HUMAN DECISION | Options and consequences | Conservative temporary default | Accountable function to appoint | Owner question / stop gate |
|---|---|---|---|---|---|
| H-01 | Approved purpose(s) and prohibited uses | One narrow operational purpose is easier to minimize/audit; multiple purposes require purpose-specific fields/access/retention and risk incompatible reuse. Productivity scoring/sole forensic use conflicts with accepted baseline. | Synthetic research only; no production activity collection. | Product/privacy governance with legal authority. | What exact purpose authorizes each source/field/output, and which uses are prohibited? G0 stops until signed. |
| H-02 | Approved production sources | Edge site/domain first slice is accepted only as the intended functional slice, not governance approval. Additional browser/process/recent-file sources materially change risk. | Synthetic Edge-like provider only. | Product privacy authorization + source owner. | Which exact source IDs may enter the first production ceiling? |
| H-03 | Approved output fields | More fields/detail improve some analyses but increase privacy, storage, access, and inference risk. | No production fields; fictional examples only. | Product privacy authorization + business purpose owner. | For each field, what purpose, minimization transform, consumers, and quality limitations justify it? |
| H-04 | Identity precision | Device, installation, session, pseudonymous subject, or named person have increasing linkage/consequence. | Lowest non-personal level compatible with synthetic tests; no username/email/HR selector. | Privacy/legal + business purpose owner. | What is the minimum identity needed, and where is re-identification permitted? |
| H-05 | Time precision/lookback | Fine timestamps and long lookback improve correlation but reveal behavior; coarse buckets reduce risk and utility. | Coarsest/no production value; no first-run production lookback. | Privacy/legal + source/business owner. | What precision/lookback is necessary per source, and why? |
| H-06 | Hard-deny classes/capabilities | An explicit permanent deny list gives strong product assurance; too vague a list leaves interpretation; too broad may constrain future products. | Anything not explicitly approved is denied; arbitrary script/plugin/destination prohibited. | Product privacy authority + product security. | Which data/capability classes can never appear in any UAM release? |
| H-07 | Tenant policy approvers | Single approval is faster but increases insider/key risk; multi-party separation improves assurance/costs time. | No ordinary production signing until approvers and separation are named. | Tenant governance authority. | Who may propose, approve, sign, publish, and audit; which combinations are forbidden? |
| H-08 | Emergency authority | Broad break-glass is risky; constrained disable-only signer is safer but cannot repair configuration. | Disable-only, short-lived overlay; no broadening. | Incident governance + key custody. | Who may disable product/realm/source, for how long, and who reviews/renews? |
| H-09 | Product ceiling/root signature threshold | M-of-N reduces one-key compromise; increases ceremony/availability/cost. | Require threshold in design; exact M/N unset. | Product key custody + release/privacy authorities. | What KMS/HSM, quorum, geographic/organizational separation, recovery, and audit are supportable? |
| H-10 | Tenant key custody and threshold | Per-realm keys strengthen isolation; many keys add operations. Shared service with key isolation may be simpler but expands failure domain. | Realm-scoped keys; signer isolated from portal; exact hardware/threshold unset. | Tenant key custody/security. | Is per-realm HSM/KMS isolation available and how is emergency recovery governed? |
| H-11 | Validity/offline window | Short expiry improves revocation/freeze containment but can stop offline devices; long expiry increases stale collection. | Hard signed expiry; no grace research assumption. | Privacy/security risk owner + endpoint operations. | What measured offline distribution and incident revocation need justify each validity window? |
| H-12 | Clock tolerance/corroboration | Strict clock handling may disable devices; permissive handling enables rollback/expiry bypass. | Untrusted/backward time stops new collection. | Endpoint security/operations. | What Windows clock sources, drift, sleep/hibernation behavior, and tolerance pass the lab? |
| H-13 | Targeting scope | Cohort-only is simpler/minimal; device-level enables canary/support; person/HR/activity targeting is materially more invasive. | Opaque cohort/device IDs only; no person/activity selectors. | Tenant privacy governance + device inventory owner. | Are device-level targets necessary, who can view membership, and what minimum cohort suppression applies? |
| H-14 | Diagnostics/support level | More diagnostics speed recovery but risk leakage and cardinality. | `off` or fixed health codes only; no raw exceptions/policy bodies. | Support/observability + privacy owner. | Which fixed properties are essential at each level and where may protected audit correlation occur? |
| H-15 | Policy/audit/artifact retention | Longer retention supports investigation/recovery; increases access/cost and may preserve sensitive targeting metadata. | Retain only what is needed for implementation tests; production unset. | Records/privacy/legal + operations. | What retention/deletion/backup rules apply separately to policy bodies, signatures, audits, health, and provenance? |
| H-16 | Over-collected data deletion | Immediate deletion may conflict with evidence/legal holds; retaining increases harm. | Quarantine and prevent visibility; do not silently scrub; obtain decision. | Privacy incident authority + records/legal. | Who authorizes deletion, evidence preservation, notification, backup handling, and closure? |
| H-17 | Accessibility acceptance | WCAG 2.2 AA is a strong target; organization may require additional standards/testing. | WCAG 2.2 AA target plus manual keyboard/screen-reader checks. | Portal product/accessibility owner. | Which assistive technologies, languages, and acceptance process are required? |
| H-18 | Support/on-call ownership | Distributed ownership can create gaps during key/policy incidents. | No production until all P0–P3 runbook fields and escalation owners are assigned. | Service ownership/governance. | Who owns endpoint, signer, distribution, ingestion, portal, observability, key, privacy, deletion, and communications actions 24×7 or during agreed coverage? |
| H-19 | Cost/licensing/skills | Custom C# evaluator avoids runtime engine/license but requires formal modeling/testing skills; KMS/HSM, simulator, audit, and incident exercises carry cost. | Use standard .NET/OS primitives and reference-only OSS; no new runtime engine. | Architecture/engineering management + procurement/legal. | Are C# security/crypto/property-testing skills, KMS/HSM, CI, accessibility, and operations funded and staffed? |
| H-20 | Production approval | Passing technical gates proves only scoped properties. | Not approved. | Designated production risk authority. | Have purpose/legal/consultation, security, privacy, operations, restore, capacity, support, and rollback evidence all passed? |

## 10.1 Cost, licensing, skills, and operations implications

**RECOMMENDATION.** The custom typed evaluator has no separate runtime license and fits the accepted C#/.NET family, but it is not “free.” It requires:

- security-focused C# engineers comfortable with immutable types, parsers, cryptography APIs, property/fuzz/mutation testing, SQLite crash behavior, and Windows process/IPC boundaries;
- product privacy engineers who can author a finite source/field/transform lattice and review generated privacy diffs;
- isolated signing/key infrastructure, ceremonies, audit, rotation/recovery exercises, and operator access control;
- a typed portal simulator/diff, compatibility variant generator, artifact store, fleet state reporting, and accessible emergency flow;
- an all-sink canary scanner and synthetic multi-process/Windows/server lab;
- on-call/runbook ownership across endpoint, control plane, keys, ingestion, portal, observability, privacy incident, deletion, and support;
- periodic dependency/security/license review. Permissive OSS licenses still require legal review and notices; the TUF specification uses the Community Specification License, not a typical code license.

**UNKNOWN.** Budget, staffing, HSM/KMS licensing, support coverage, and training are not supplied. If these cannot be supported, the safe fallback is a less dynamic system—signed release ceiling plus enterprise-deployed disabled/default tenant package—not an unsigned or more permissive policy path.

---

# 11. CLI experiments and exact required evidence

**CLI EXPERIMENT.** The commands below are proposed interfaces for repository tasks. They use placeholders and synthetic paths only. They never request SSH commands, credentials, hosts, internal addresses, personal data, raw activity, or confidential values.

## 11.1 Reproducible environment record

```powershell
$ErrorActionPreference = 'Stop'
dotnet --info | Tee-Object artifacts/toolchain/dotnet-info.txt
git rev-parse HEAD | Out-File artifacts/toolchain/repository-commit.txt
Get-FileHash -Algorithm SHA256 schemas/*.json, testdata/**/*.json |
  ConvertTo-Json -Depth 4 | Out-File artifacts/toolchain/input-hashes.json
```

**Evidence required:** supported .NET runtime/SDK and OS metadata, repository commit, exact dependency lock/SBOM, schema/fixture hashes. Redact machine/user/path values from attached evidence; retain only approved generic OS/runtime facts.

## 11.2 Schema and canonicalization conformance

```powershell
dotnet run --project tools/Uam.PolicyCli -- schema validate `
  --schema schemas/uam.product-ceiling-1.schema.json `
  --input testdata/ceiling/fictional-valid.json `
  --strict-duplicates --require-jcs `
  --report artifacts/schema/ceiling-valid.json

dotnet run --project tools/Uam.PolicyCli -- corpus verify `
  --manifest testdata/canonicalization/manifest.json `
  --report artifacts/schema/canonicalization-report.json
```

**Evidence required:** per-fixture pass/fail, fixed error code, canonical digest from CLI/signer/endpoint/server implementations, zero payload values in logs, tool version/commit. **Pass:** exact expected matrix; cross-implementation digests identical.

## 11.3 JWS threshold and key-profile verification

```powershell
dotnet run --project tools/Uam.PolicyCli -- signature verify `
  --trust testdata/keys/fictional-product-trust.json `
  --artifact testdata/envelopes/fictional-ceiling.jws.json `
  --expected-type uam-product-ceiling+jws `
  --profile uam-jws-profile/1 `
  --report artifacts/signature/valid.json

dotnet test tests/Uam.Policy.Signature.Tests `
  --filter 'Category=NegativeJose' `
  --logger 'trx;LogFileName=signature-negative.trx' `
  --results-directory artifacts/signature
```

**Evidence required:** threshold/key IDs as fictional test identifiers, header/algorithm matrix, no network key retrieval, malformed signature corpus, allocation/time bounds, TRX. **Pass:** only trusted profile succeeds.

## 11.4 Monotonicity/property tests

```powershell
dotnet test tests/Uam.Policy.PropertyTests `
  --filter 'Category=Monotonicity|Category=MeetLaws|Category=UnknownFailsClosed' `
  --settings tests/runsettings/property-pr.runsettings `
  --logger 'trx;LogFileName=policy-properties.trx' `
  --results-directory artifacts/properties

dotnet run --project tools/Uam.PolicyCli -- properties replay `
  --corpus testdata/counterexamples `
  --report artifacts/properties/replay.json
```

**Evidence required:** case count, seed list, generator distribution by dimension/boundary, zero counterexamples, persisted minimal counterexample on failure, branch/mutation coverage. **Primary pass:** FF-01–FF-05.

## 11.5 Policy lint, compare, and effective diff

```powershell
dotnet run --project tools/Uam.PolicyCli -- policy lint `
  --ceiling testdata/ceiling/fictional-valid.jws.json `
  --policy testdata/policy/fictional-narrow.jws.json `
  --endpoint testdata/inventory/fictional-endpoint.json `
  --at 2026-07-31T10:30:00Z `
  --report artifacts/policy/lint.json

dotnet run --project tools/Uam.PolicyCli -- policy diff `
  --from testdata/policy/fictional-rev-42.jws.json `
  --to testdata/policy/fictional-rev-43.jws.json `
  --ceiling testdata/ceiling/fictional-valid.jws.json `
  --format json `
  --out artifacts/policy/privacy-diff.json
```

**Evidence required:** normalized effective policy digest, per-dimension relation (`narrower/equal/broader/incomparable`), no raw identifiers, stable human-readable and machine diff, exact error code. **Pass:** fictional narrow policy active; every adversarial mutation no permit.

## 11.6 Compatibility matrix

```powershell
dotnet run --project tools/Uam.PolicyCli -- compatibility matrix `
  --agents testdata/compat/agents.json `
  --ceilings testdata/compat/ceilings `
  --policies testdata/compat/policies `
  --out artifacts/compat/matrix.json
```

**Evidence required:** every agent/interpreter/ceiling/policy cell, expected state, exact signed variant digest, missing-cell disabled behavior, no fallback/ignored fields. **Pass:** FF-14.

## 11.7 Revision, rollback, expiry, and clock simulation

```powershell
dotnet run --project tools/Uam.PolicyCli -- lifecycle simulate `
  --scenario testdata/lifecycle/revision-expiry-clock.json `
  --out artifacts/lifecycle/state-trace.json
```

Scenario MUST include lower revision, same revision conflict, broken chain, future policy, expired candidate, active expiry offline, backward/forward clock jump, key overlap/revocation, and recovery as higher revision.

**Evidence required:** deterministic timestamped state trace, permit count by fixed state, highest-seen head after each transition, no-permit assertions. **Pass:** T-005–T-009/T-022.

## 11.8 SQLite crash/failpoint matrix

```powershell
dotnet test tests/Uam.Policy.CacheCrashTests `
  --filter 'Category=EveryWriteBoundary' `
  --logger 'trx;LogFileName=cache-crash.trx' `
  --results-directory artifacts/cache

dotnet run --project tools/Uam.PolicyCli -- cache inspect `
  --database artifacts/cache/final-test.db `
  --redact `
  --out artifacts/cache/final-state.json
```

**Evidence required:** named failpoint list covering every transaction boundary, old/new state classification, SQLite integrity result, active/head/audit consistency, file hashes. **Pass:** no mixed/permissive state. Delete synthetic DB/WAL/SHM after retaining sanitized reports.

## 11.9 Three-process permit lab

```powershell
dotnet run --project lab/Uam.Policy.ProcessHarness -- `
  --scenario testdata/process/permit-midrun-narrowing.json `
  --artifacts artifacts/process `
  --synthetic-only
```

**Evidence required:** process tree with generic identities, security profile/handle/IPC assertions, permit fields/digests using fictional values, source-read count, cancellation, IPC size/schema, event/cursor result, no network route for Task Host, sanitized traces. **Pass:** T-015/T-017/T-028.

## 11.10 All-sink forbidden-canary scan

```powershell
dotnet run --project tools/Uam.CanaryCli -- generate `
  --run-id fictional-run-0001 `
  --out artifacts/canary/canaries.json

dotnet run --project tools/Uam.CanaryCli -- scan `
  --manifest testdata/sinks/synthetic-sink-manifest.json `
  --canaries artifacts/canary/canaries.json `
  --encodings literal,utf16,url,json,base64,base64url,hex,compressed,fragmented,known-test-hash `
  --report artifacts/canary/scan-report.json `
  --fail-on-hit
```

**Evidence required:** complete enumerated sink manifest, scanner version, sink hashes, encoding coverage, zero-hit signed report, cleanup second scan. The manifest uses local placeholders and excludes any connection secret/address. **Pass:** exactly zero forbidden hits.

## 11.11 Server/portal realm, provenance, and audit integration

```powershell
dotnet test tests/Uam.ControlPlane.SecurityIntegrationTests `
  --filter 'Category=RealmIsolation|Category=PolicyAudit|Category=Provenance|Category=SimulatorPrivacy' `
  --logger 'trx;LogFileName=control-security.trx' `
  --results-directory artifacts/control
```

**Evidence required:** two-fictional-realm matrix, authenticated context vs payload claim, durable inbox/materialization state, audit-failure injection, query/input schema, response hashes, zero canary. **Pass:** T-018/T-019/T-029.

## 11.12 Metric cardinality and sink schema

```powershell
dotnet run --project lab/Uam.ObservabilityHarness -- `
  --scenario testdata/observability/cardinality-flood.json `
  --series-per-instrument 128 `
  --total-series 1024 `
  --out artifacts/observability

dotnet run --project tools/Uam.SinkSchemaCli -- verify `
  --contract schemas/uam-observability-contract.json `
  --inputs artifacts/observability `
  --report artifacts/observability/schema-report.json
```

**Evidence required:** emitted series/attributes, dropped count, peak memory/allocation, exporter payload, prohibited-label scan. **Pass:** FF-20; tune caps only through recorded measurement/ADR.

## 11.13 Resource/fuzz measurement

```powershell
dotnet test tests/Uam.Policy.FuzzRegressionTests `
  --logger 'trx;LogFileName=fuzz-regression.trx' `
  --results-directory artifacts/fuzz

dotnet run --project lab/Uam.Policy.BenchmarkHarness -- `
  --corpus testdata/fuzz/max-bounded-corpus `
  --iterations 1000 `
  --out artifacts/performance
```

**Evidence required:** corpus/seed hashes, no crashes/timeouts, phase percentiles, peak allocations/memory, minimum supported test hardware facts sanitized, approved budget comparison. **Pass:** FF-21; research supplies no fabricated budget.

## 11.14 Catalogue import validator

```powershell
dotnet run --project tools/Uam.CatalogueCli -- validate-import `
  --input testdata/catalogue/fictional-173-shape.csv `
  --assign-uam-ids `
  --no-inference `
  --report artifacts/catalogue/validation.json
```

**Evidence required:** aggregate counts only, stable-ID assignment, missing external-ref handling, Unicode/truncation/address-like flags, duplicate/ambiguous failure cases, proof no policy/rule/role fields were synthesized. **Pass:** T-025 and I-03 constraints.

## 11.15 Accessibility evidence

```powershell
dotnet test tests/Uam.Portal.AccessibilityTests `
  --filter 'Category=PolicyCriticalFlow' `
  --logger 'trx;LogFileName=accessibility.trx' `
  --results-directory artifacts/accessibility
```

Also execute a human checklist for keyboard-only, focus order, screen reader names/status, reflow/zoom, high contrast, error recovery, non-color status, diff comprehension, and emergency disable/rollback.

**Evidence required:** automated report, manual checklist with fictional data, defects and remediation; no production screenshots/person data. **Pass:** FF-25.

## 11.16 Release binding and dependency evidence

```powershell
dotnet run --project tools/Uam.ReleaseCli -- verify-privacy-binding `
  --manifest artifacts/release/fictional-release-manifest.json `
  --package artifacts/release/fictional-package `
  --ceiling artifacts/release/fictional-ceiling.jws.json `
  --out artifacts/release/binding-report.json

dotnet list Uam.sln package --vulnerable --include-transitive `
  | Out-File artifacts/release/dependency-vulnerability-report.txt
```

**Evidence required:** package/binary/ceiling/schema/transform/vector hashes, signatures/threshold status, SBOM/provenance, exact supported dependency versions and licenses, vulnerability review, tamper-negative cases. **Pass:** FF-13/FF-26.

## 11.17 Evidence manifest and redaction gate

```powershell
dotnet run --project tools/Uam.EvidenceCli -- package `
  --input artifacts `
  --allowlist schemas/evidence-allowlist.json `
  --forbid patterns/forbidden-evidence-patterns.json `
  --out artifacts-package `
  --manifest artifacts-package/sha256-manifest.json `
  --fail-on-forbidden
```

**Exact final evidence package:** repository commit; toolchain/runtime lifecycle record; dependency lock/SBOM/license/security review; signed fictional fixtures and hashes; TRX/JUnit/property/fuzz/mutation reports; state-machine traces; crash matrix; compatibility matrix; realm tests; canary zero-hit and cleanup scan; metric/resource report; accessibility evidence; release binding; runbook exercise; SHA-256 manifest. It must contain no internal addresses, credentials, SSH material, personal data, raw production activity, confidential reference values, or prohibited project attachments.

---

# 12. ADR proposals

These ADRs refine the accepted baseline rather than replacing it. **FACT:** no reviewed evidence establishes a material problem with the accepted ceiling/tenant-narrowing decision, so this result creates no baseline change proposal. Each ADR remains proposed until the named accountable owner is assigned and the associated stop gate passes.

## ADR-05.1 — Use a finite typed privacy lattice, not a general endpoint policy language

| Field | Proposal |
| --- | --- |
| Decision | Implement the endpoint evaluator as a small, deterministic C#/.NET library over release-defined registries and typed dimensions. Define `tenant ⪯ ceiling`; compute the effective policy by meet/intersection; reject any dimension whose order or meet is unknown, cyclic, ambiguous, or broader. No scripts, expressions, reflection-based extension points, network calls, clocks chosen by policy, external data lookup, or user-provided functions are allowed. |
| Status | **Proposed — foundation implementation.** It operationalizes an accepted decision. |
| Alternatives | OPA/Rego, Cedar, JSON Logic, OpenFeature/flagd, a generic rules engine, hand-written imperative `if` trees without a reference model. |
| Rationale | A finite registry makes every permission dimension enumerable, reviewable, property-testable, and bindable to a release. General languages add semantics that are unnecessary for the first slice and make universal monotonicity much harder to establish. The reference model plus an optimized implementation allows differential testing. |
| Evidence | Accepted baseline [I-01][I-02]; formal model and algorithms in sections 3, 5, and 9; prototypes P-01/P-02; OSS differences [R-03]–[R-06]. |
| Accountable owner | **HUMAN DECISION:** name the person accountable for product privacy architecture. Required participating functions: endpoint engineering, product security, privacy engineering, and test/assurance. |
| Review trigger | A new policy dimension lacks a finite order; transforms require runtime expressions; the registry becomes operationally unmanageable; a restricted external engine demonstrates equal or stronger monotonic proof at lower assurance and lifecycle cost; or a property/differential test finds semantic divergence. |

## ADR-05.2 — Use strict JSON, JCS, and threshold JWS profiles for signed artifacts

| Field | Proposal |
| --- | --- |
| Decision | Encode product ceilings, tenant policies, trust metadata, and emergency overlays as bounded JSON Schema 2020-12 artifacts under the UAM JSON profile; reject duplicate members before binding; require exact RFC 8785 canonical bytes; use JWS General JSON Serialization with an explicit `uam-jws-profile/1`, fixed `ES256`, pinned keys, exact protected headers, and threshold verification where configured. Disallow remote key references, embedded untrusted JWK/certificates, unsecured or detached payload variants, algorithm negotiation, and unknown headers. |
| Status | **Proposed — implementation and cryptographic review required.** |
| Alternatives | CMS/PKCS #7, COSE/CBOR, XML signatures, a single detached signature file, platform-specific serialized objects, unsigned HTTPS-only configuration. |
| Rationale | JSON is operationally accessible, JCS provides deterministic signing input, and JWS General JSON represents multiple signatures. A UAM profile removes optionality that otherwise creates parsing and algorithm-confusion risk. Transport authentication alone cannot protect an offline cache, repository compromise, rollback, or a compromised control plane. |
| Evidence | RFCs and JSON Schema [S-03]–[S-09]; contracts in section 5; TUF threshold/expiry lessons [R-01][R-02]; P-03 and T-001/T-004/T-005. |
| Accountable owner | **HUMAN DECISION:** name cryptographic design and release-security approvers. |
| Review trigger | Independent cryptographic review rejects the profile; Windows/.NET implementation cannot provide safe deterministic ES256 verification; a mandated enterprise algorithm/profile conflicts; post-quantum or regulatory requirements change; or conformance vectors reveal cross-runtime ambiguity. A new algorithm requires a new profile and compatible release, never silent substitution. |

## ADR-05.3 — Separate product ceiling, realm policy, and emergency signing authority

| Field | Proposal |
| --- | --- |
| Decision | Product release authority signs the release-bound ceiling using a product threshold. Realm policy authority signs only tenant-narrowing policy for its realm. Product emergency authority and realm emergency authority sign separate disable-only overlays. Portal, repository, CDN, ingestion, database, and deployment systems distribute or record artifacts but hold no key that can independently broaden endpoint collection. Signers receive canonical unsigned payloads and independently verify schema, scope, digest, revision, and monotonic diff before signing. |
| Status | **Proposed — key-custody and approval decisions outstanding.** |
| Alternatives | One online service key for all artifacts; portal/database administrators directly edit active policy; one shared key across realms; product ceiling derived at runtime from tenant policy. |
| Rationale | Authority separation prevents one ordinary control-plane compromise from authorizing collection outside the release. Separate disable-only authority makes emergency containment possible without granting broad configuration power. Thresholds reduce single-key risk but do not remove collusion or ceremony risk. |
| Evidence | Authority model in section 3.4; signing flow in 3.5; threat register F-01/F-03/F-06/F-20/F-21; TUF concepts [R-01][R-02]. |
| Accountable owner | **HUMAN DECISION:** name product release authority, realm policy authority, emergency authority, key custodian, audit owner, and incident commander; define separation-of-duty constraints. |
| Review trigger | Key-management technology or staffing cannot support the chosen threshold; an incident shows unacceptable emergency latency; realms require independently rooted trust; or release/update ADRs choose a conforming metadata framework that safely subsumes this flow. |

## ADR-05.4 — Make revision monotonic; represent rollback as a higher revision

| Field | Proposal |
| --- | --- |
| Decision | Maintain a per-realm/per-stream highest-seen revision and digest chain. Reject lower revisions, same-revision/different-digest artifacts, and broken predecessor chains. Operational rollback republishes an audited earlier semantic snapshot as a newly signed artifact with a higher revision and `rollbackOfRevision`; it never reduces the anti-rollback counter. Product ceilings similarly use a strictly increasing sequence bound to release/recovery rules. |
| Status | **Proposed — required for P-04 and P-05.** |
| Alternatives | Allow a signed `forceDowngrade`; compare timestamps only; let operators reset local state; accept any valid signature; overwrite policy rows in place. |
| Rationale | A valid old signature is not evidence of current authorization. New-revision recovery preserves ordering, audit, and replay resistance while still restoring known semantics. Local reset would turn endpoint administration into a broadening channel. |
| Evidence | Section 5.4.2, state machine section 6, F-07/F-08/F-09, T-008/T-009, TUF rollback/freeze design [R-01][R-02]. |
| Accountable owner | **HUMAN DECISION:** policy operations and release recovery owner. |
| Review trigger | A recovery drill cannot restore service without counter reset; durable state corruption cannot be recovered from signed server evidence; or a formal protocol with equivalent rollback/freeze protection replaces the chain. Any counter-reset design requires a separate threshold-authorized recovery ADR and lab proof. |

## ADR-05.5 — Use disable-only emergency overlays and bounded feature flags

| Field | Proposal |
| --- | --- |
| Decision | Collection-affecting feature flags are typed values in the ceiling lattice; a flag cannot introduce a source, field, transform, destination, diagnostic property, target attribute, or capability. Emergency overlays contain fixed disable switches only, have short bounded validity, intersect with base policy, are independently signed/audited, and cannot edit ordinary desired state. Local administrative disablement is allowed; local enablement beyond signed effective policy is not. |
| Status | **Proposed — emergency authority and expiry policy are human decisions.** |
| Alternatives | General remote feature-flag daemon; portal Boolean that bypasses policy signing; emergency editing of the active policy; local registry/GPO enable switches; permanent unexpired kill switches. |
| Rationale | A separate monotone overlay can contain harm even when ordinary policy workflow is impaired. General flags create a second authorization plane and often use rich evaluation contexts inappropriate for privacy-sensitive collection. Expiry limits stale emergency state but must never cause unsafe resurrection. |
| Evidence | Sections 3.7, 5.5, 6.7; F-11/F-22/F-23; T-017/T-018; flagd/OpenFeature review [R-05]. |
| Accountable owner | **HUMAN DECISION:** emergency authority, policy operations, and incident-response owner. |
| Review trigger | Measured propagation is too slow; overlay expiry behavior causes availability or resurrection risk; a non-collection feature platform needs flags; or operators cannot reliably distinguish desired, effective, and emergency state. |

## ADR-05.6 — Require a Coordinator intent plus independent User Host permit

| Field | Proposal |
| --- | --- |
| Decision | A Coordinator may schedule only a `RunIntent`. The ordinary-token User Host independently verifies signed artifacts, session eligibility, target, and bounds, then issues a single-use short-lived `CollectionPermit` bound to realm, installation, session, source generation, transform, output schema, fields, limits, release/ceiling/policy digests, executable profile, and nonces. The Task Host validates the permit and enforces it locally. Coordinator validates output/provenance before the atomic event+cursor commit. |
| Status | **Proposed — Windows IPC/handle mechanism requires G1 lab proof.** |
| Alternatives | Coordinator passes plain command-line parameters; User Host trusts Coordinator evaluation; Task Host reads policy from a mutable shared file; one long-lived collector; server-only enforcement. |
| Rationale | Redundant verification and digest-bound permits prevent one ordinary process or mutable IPC message from silently widening a run. It preserves the accepted user/session boundary and minimization-before-IPC rule. It cannot contain a malicious signed binary or OS/kernel compromise, which remain release and platform risks. |
| Evidence | Sections 3.8 and 5.7; transaction rules 6.8; F-12–F-16; P-06/T-019/T-024; accepted topology [I-01][I-02]. |
| Accountable owner | **HUMAN DECISION:** endpoint security architecture owner, with Windows platform and endpoint engineering. |
| Review trigger | G1 finds handle/IPC provenance cannot be assured; permit lifetime/clock creates unacceptable failures; resource measurements are excessive; or a simpler Windows primitive demonstrates the same independent checks and replay resistance. |

## ADR-05.7 — Target only realm-owned opaque device/cohort IDs

| Field | Proposal |
| --- | --- |
| Decision | Tenant policy target selectors are finite sets of opaque, realm-owned inventory cohort/device IDs resolved server-side. Endpoint policy contains no HR attribute, username, email, role, organization-unit, application-name inference, observed activity, URL/domain, process, entitlement, percentage hash, arbitrary expression, or negative selector. Enrollment binds the endpoint to one realm; realm/device are derived from authenticated registration, never payload claims. |
| Status | **Proposed — targeting governance and inventory contract outstanding.** |
| Alternatives | ABAC over directory/HR attributes; per-user targeting; application-catalogue-name rules; arbitrary expressions; percentage rollout on personal identifiers. |
| Rationale | Finite opaque membership is easier to preview, audit, isolate, and remove. The supplied catalogue cannot prove role, owner, entitlement, or rule semantics, so using its names/legacy references for authorization would fabricate meaning. Cohort definitions themselves remain governed server-side data and require access controls. |
| Evidence | Section 3.6; catalogue limits [I-03]; F-04/F-05/F-24; T-015/T-025/T-027. |
| Accountable owner | **HUMAN DECISION:** inventory/configuration owner and realm data owner; privacy approval for any targeting dimension. |
| Review trigger | A justified use case cannot be represented by finite inventory cohorts; cohort maintenance causes material operational harm; or a privacy-approved attribute model with formal non-person/activity targeting and realm isolation is proved. |

## ADR-05.8 — Quarantine ordinary incompatibility; safety-hold security-significant candidates

| Field | Proposal |
| --- | --- |
| Decision | A malformed, unknown-schema, or unsupported-interpreter candidate is quarantined and cannot become active; a previously verified, compatible, unexpired last-known-good policy may continue. Signature failure, wrong realm/release/ceiling, rollback/equivocation/chain break, broadening, trust conflict, or cache tamper enters `SafetyHold` and stops all new collection. Expiry of active authority enters `DisabledExpired`; no LKG may run past its own expiry. All outcomes emit fixed privacy-safe health codes and durable audit. |
| Status | **Proposed — medium confidence pending incident and outage simulation.** |
| Alternatives | Fail open; stop on every malformed candidate; silently ignore every invalid candidate; extend expiry automatically while offline. |
| Rationale | Blindly stopping for any unauthenticated garbage creates a trivial denial-of-service vector; blindly ignoring security-significant evidence hides compromise. The asymmetric taxonomy preserves a verified active authority for ordinary compatibility errors while stopping on evidence that trust, scope, or ordering may be violated. |
| Evidence | Sections 6.3–6.6; F-02/F-07/F-08/F-10/F-11; P-04/P-05; T-006–T-014. |
| Accountable owner | **HUMAN DECISION:** product security incident owner and endpoint operations owner. |
| Review trigger | Threat modelling or exercises show a class is miscategorized; malformed-candidate floods exhaust resources; offline operations cannot safely meet expiry; or trusted-time evidence is insufficient. |

## ADR-05.9 — Make observability a finite privacy contract

| Field | Proposal |
| --- | --- |
| Decision | Release code defines a finite error taxonomy, instruments, attribute names, and enum domains. Metrics/logs/traces/audit/support bundles may contain only allowlisted fixed codes, bounded counts, versions, and digests explicitly approved for that sink. They never contain source values, policy JSON, target IDs, realm/device/user IDs, paths, URLs, application names, exception messages, stack traces with values, or arbitrary tags. Initial engineering caps are 4 attributes per point, 128 active series per instrument per process, and 1,024 total active series per process, with overflow to a fixed `other`; measurement may tighten or revise them by ADR. |
| Status | **Proposed — caps are hypotheses, not production SLOs.** |
| Alternatives | Log serialized policy and exceptions; add tenant/device/policy digest as metric labels; rely only on exporter backend limits; disable all diagnostics. |
| Rationale | Privacy failure often occurs through secondary sinks. A finite sink schema makes all-sink canary scanning possible and controls memory/cost/cardinality. Some detailed local evidence may be necessary for support, but must use an explicit separately approved collection flow rather than automatic logging. |
| Evidence | Sections 3.11, 7.4, 8.4, and 9; OpenTelemetry material [S-10]–[S-12]; F-17/F-18/F-30/F-31; T-020/T-021/T-030. |
| Accountable owner | **HUMAN DECISION:** observability platform owner, product security, privacy engineering, and support owner. |
| Review trigger | Lab measurements show caps lose essential health signals or exceed budgets; a new sink is introduced; incident response needs additional fields; or a canary reaches any sink. |

## ADR-05.10 — Bind policy variants explicitly to release ceilings and interpreter ranges

| Field | Proposal |
| --- | --- |
| Decision | Every endpoint release embeds/verifies one exact product ceiling and interpreter range. Tenant policy references the exact release ID and ceiling digest. The control plane may produce separately signed compatibility variants with the same intended narrowing for known release/ceiling families, but an agent never auto-rebinds a policy to another ceiling. Upgrade activation requires a compatible policy variant and successful preflight; otherwise collection remains under the old valid release/policy or is disabled according to lifecycle rules. Unknown IDs or semantics are never ignored. |
| Status | **Proposed — compatibility matrix and release pipeline proof required.** |
| Alternatives | One policy interpreted loosely by all agents; ignore unknown fields; auto-intersect against any installed ceiling; let new release defaults collect until policy arrives. |
| Rationale | Explicit binding prevents an old tenant artifact from accidentally authorizing a newly added source/field and prevents a new policy from being partially interpreted by an old agent. Compatibility variants preserve operational rollout without weakening semantics. |
| Evidence | Sections 5.3/5.4 and 6.9; F-09/F-19/F-25; P-05/T-010/T-016/T-028; release invariant [I-01]. |
| Accountable owner | **HUMAN DECISION:** release engineering, policy operations, and endpoint product owner. |
| Review trigger | Variant count becomes unmanageable; staged release deadlocks; schema evolution needs more than one interpreter; or a mechanically verified translation can safely replace explicit variants. |

# 13. Ordered implementation backlog with dependencies and stop gates

**RECOMMENDATION.** Implement in the following order. A failed stop gate blocks all dependent items and opens or revises an ADR; it does not invite an exception that weakens the invariant. Real employee/production activity is prohibited throughout this backlog until separately approved. All fixtures are fictional or synthetic.

| Order / item | Repository-ready output | Depends on | Required participating function; accountable person remains a HUMAN DECISION | Stop gate / acceptance evidence |
| --- | --- | --- | --- | --- |
| B-00 — G0 purpose/source/dummy-data contract | Approved machine-readable source/purpose placeholder contract; prohibited-use and synthetic-fixture rules; named decision owners; no production values. | None | Privacy/legal/business authority, product owner, security. | **STOP** all collector work if approved purpose/source/dummy-data scope is absent. Research cannot approve it. |
| B-01 — Privacy vocabulary and registry specification | `docs/privacy-lattice.md`; registries for sources, fields/data classes, capabilities, destinations, diagnostics, transforms, feature values, kill switches, output schemas, error codes; ownership and change process. | B-00 for any real source; may use fictional registry earlier. | Privacy architecture + endpoint/server engineering. | Every ID has type, order/meet, owner, provenance, hard-deny status, release binding, and tests; no free-form extension namespace. |
| B-02 — Strict schemas and parser profile | Versioned JSON Schemas; duplicate-member scanner; bounded UTF-8 parser; JCS canonicalizer wrapper; conformance vectors for valid/invalid numbers, Unicode, order, duplicates, depth, and unknown members. | B-01 | Security engineering + platform engineering. | P-01/T-001/T-002 pass cross-runtime; all noncanonical/ambiguous inputs rejected before signature semantics. |
| B-03 — Executable reference lattice | Pure reference evaluator, `IsNarrowerOrEqual`, `Meet`, normalization, transform DAG validation, proof-report model, deterministic serializer; no IPC/storage/network. | B-01/B-02 | Privacy architecture + test engineering. | P-02, mutation tests, differential tests, and mandatory property suite pass; every generated broaden mutation is rejected or yields no permits. **STOP** signing/endpoints on any counterexample. |
| B-04 — Cryptographic profile and trust fixtures | JWS General JSON verifier/signer test library; fixed ES256 profile; threshold rules; key purpose/realm/validity metadata; pinned synthetic roots; malformed/duplicate/algorithm-confusion vectors; key-rotation/revocation fixtures. | B-02/B-03 | Cryptographic/security reviewer + release engineering. | P-03/T-004/T-005/T-023 pass; independent cryptographic review resolves all high findings. Do not connect production keys. |
| B-05 — Release ceiling binding pipeline | Release manifest schema; ceiling compiler from reviewed registry; implementation/schema/vector digest binding; build/repository authorization checks; SBOM/provenance; reproducible verification CLI. | B-03/B-04 | Release engineering + product security. | FF-13/FF-26 and T-028 pass; package without exact valid ceiling cannot install/execute collection; tampered or stale release stops. |
| B-06 — Tenant policy authoring/compiler | Typed authoring model; realm scope; revision/digest chain; monotonic compiler; simulation/diff; approval reference; unsigned canonical package for independent signing; no raw catalogue-name/HR selectors. | B-03/B-04; B-00 for non-fictional choices | Control-plane engineering + privacy/security review. | Broader/unknown/ambiguous policy cannot reach signing queue; every signed artifact has proof report and durable audit in one server transaction. |
| B-07 — Endpoint policy cache and lifecycle state machine | SQLite cache tables/migrations; verify-before-activate; atomic active pointer; highest-seen counters; LKG; quarantine/safety-hold/expiry states; crash/failpoint recovery; bounded artifact retention; cleanup. | B-04/B-06; accepted SQLite design | Endpoint engineering + reliability/security test. | P-04/P-05, T-006–T-014, T-022 pass; no torn/invalid/broader state becomes active; expiry yields zero new collection. |
| B-08 — Coordinator/User Host/Task Host authorization handshake | Generated bounded IPC messages; `RunIntent`; per-session ephemeral authorization primitive; single-use `CollectionPermit`; cancellation; process/profile/session/realm binding; nonce replay cache; zero permit on invalid state. | B-03/B-05/B-07 and G1 session/IPC foundation | Windows endpoint engineering + security architecture. | P-06/T-019/T-024 pass in approved Windows lab; one compromised ordinary process cannot widen tested dimensions; mid-run policy change discards output and cursor stays put. |
| B-09 — Transform/output/provenance enforcement | Release-authored transform interface; raw-value confinement; output schema validator; forbidden-field scanner; provenance tuple; Coordinator commit guard; server independent validation and realm derivation. | B-05/B-08 | Endpoint + ingestion engineering, privacy security. | T-003/T-024/T-027 pass; forbidden canaries never cross Task Host privacy boundary or enter event/cursor transaction; wrong provenance is rejected/quarantined. |
| B-10 — Policy simulation, impact preview, and accessible operations flow | Desired/effective state UI and CLI; deterministic target counts from realm inventory; semantic diff; broader-risk banner; expiry/kill-switch preview; approval summary; keyboard/screen-reader/reflow/non-color support; export contains fictional or approved metadata only. | B-06; B-09 for exact output model | Portal/control-plane product, accessibility, privacy operations. | P-07/T-015/T-026 pass; preview and endpoint evaluator agree byte-for-byte on effective digest/disposition for corpus; critical flow meets applicable WCAG 2.2 AA target. |
| B-11 — Emergency overlays and key lifecycle | Product/realm disable-only overlay schemas and signers; expiry preview; threshold policy; rotation/revocation/recovery ceremonies; offline key custody; exercise scripts; audit and cleanup. | B-04/B-06/B-07/B-10 | Security incident response + key custodians + policy operations. | T-017/T-018/T-023 pass; overlay can only meet/narrow; removal never revives invalid/expired authority; loss/compromise exercises produce evidence. |
| B-12 — Privacy-safe observability and sink contracts | Fixed code enums; generated sink schema; metric cap/overflow implementation; structured redaction at source; exporter/test sinks; artifact/log/cache/ETW/crash/support-bundle scanner; sanitized health API. | B-01/B-07/B-08/B-09 | Observability, endpoint/server operations, product security. | T-020/T-021/T-030 pass; zero forbidden canary hits across every enumerated sink and cleanup scan; cardinality/resource guard behaves deterministically. **STOP** on any hit. |
| B-13 — Realm isolation and control-plane transaction tests | Realm-derived authorization middleware; database constraints; signed artifact realm binding; cross-realm negative suite; audit-outbox transaction; repository object isolation; restore tests for policy metadata. | B-04/B-06/B-09 | Server/control-plane security + database engineering. | T-015/T-027/T-029 pass; cross-realm submit/read/mutate/delete/sign/distribute attempts fail with durable privacy-safe audit. |
| B-14 — Compatibility and staged rollout controller | Release/ceiling/interpreter matrix; separately signed policy variants; preflight coverage; deterministic canary/cohort progression; freeze/pause/abort; rollback-as-new-revision; old-agent dashboards without personal labels. | B-05/B-06/B-07/B-10/B-13 | Release engineering + endpoint/control-plane operations. | T-010/T-016/T-028/T-029 pass; uncovered agents collect nothing new; upgrade never auto-rebinds; canary failure halts wider stage. |
| B-15 — Windows lab clock/offline/crash/resource campaign | Approved read-only lab inventory; synthetic source; clock-step/suspend/resume/offline/expiry matrix; concurrent-session and process-kill tests; SQLite failpoints; CPU/memory/disk/latency/cardinality measurements; sanitized evidence. | B-07/B-08/B-09/B-12/B-14 | Windows lab owner + performance/reliability engineering. | T-013/T-014/T-019/T-022/T-024/T-030 pass against approved budgets. Unknown budgets remain HUMAN DECISION; failure blocks rollout rather than inventing values. |
| B-16 — Runbooks, ownership, and exercises | Published runbooks for safety hold, expiry, malformed flood, key compromise, lost signer, realm misdelivery, kill switch, rollback, cache corruption, canary leak, clock anomaly, cleanup, and evidence packaging; support escalation and on-call ownership; accessible CLI fallback. | B-11/B-12/B-13/B-14/B-15 | Operations/support/security incident functions; named people required. | Tabletop plus technical exercise for every severity class; evidence shows detection, containment, recovery, cleanup, and audit; no confidential details in package. |
| B-17 — G4 privacy transformation and canary containment gate | Reproducible gate runner aggregating schemas, property/mutation/fuzz, signing, lifecycle, multi-process permit, realm, crash, all-sink canary, compatibility, accessibility, and evidence-manifest results. | B-00–B-16; G1–G3 prerequisites as applicable | Independent assurance/release approval function. | **PRIMARY GATE:** invalid, expired, unsupported, or broader policy produces zero new collection and an audited, privacy-safe health state. Zero canary sink hits. Any failure is **STOP**, opens ADR action, and blocks G5/dependent work. |
| B-18 — Post-G4 integration only | Connect the accepted event+cursor transaction/outbox and subsequent ingestion gates using synthetic data, preserving this policy/provenance contract. | G4 pass | Existing endpoint/ingestion owners. | G4 pass is necessary, not sufficient. Continue accepted proof-gate order; no production approval is implied. |

## 13.1 Backlog dependency rules

1. B-00 governs any real-world choice but does not prevent implementation of the fictional schemas/test harnesses.
2. B-03 is the semantic root. Every endpoint, portal, server, and CLI evaluator MUST consume the same generated registry/conformance package or prove differential equivalence to the reference implementation.
3. B-05 and B-06 are separate: release engineering may authorize product capability, while a realm policy may only select a subset. Neither pipeline can sign for the other.
4. B-07 activates only artifacts that have passed B-02–B-06. Network receipt never equals activation.
5. B-08 and B-09 must fail closed before touching a user-owned source. Until then, Task Host tests use a synthetic in-memory source.
6. B-12 is not optional observability polish. No source gate can pass until every sink has a finite contract and the scanner can prove zero forbidden canary hits.
7. B-17 is the topic stop/go gate. Passing it does not approve purpose, production data, production retention, employee consultation, SLOs, or deployment.

---

# 14. Open-source repository assessment table

**Method.** Repositories were reviewed as of **31 July 2026** at the exact tags/releases below. Popularity was not used as a fitness argument. A release being maintained or well tested does not make its threat model suitable for UAM. “Dependency” means production or test code would take a package/runtime dependency; “reference” means ideas, tests, and threat lessons may be reused without importing the implementation.

| ID / repository and exact revision | Relevant files/directories reviewed | License and compatibility concerns | Maintenance, testing, and security posture at the reviewed revision | Architectural similarity and threat-model difference | Reusable ideas; ideas not to copy | UAM suitability |
| --- | --- | --- | --- | --- | --- | --- |
| **R-01 — TUF specification** — [repository](https://github.com/theupdateframework/specification), [tag `v1.0.35`](https://github.com/theupdateframework/specification/tree/v1.0.35), release commit [`7cccae7`](https://github.com/theupdateframework/specification/commit/7cccae7), released **15 July 2026**. | [`tuf-spec.md`](https://github.com/theupdateframework/specification/blob/v1.0.35/tuf-spec.md), [`historical/`](https://github.com/theupdateframework/specification/tree/v1.0.35/historical), [`.github/`](https://github.com/theupdateframework/specification/tree/v1.0.35/.github), [`check_release.py`](https://github.com/theupdateframework/specification/blob/v1.0.35/check_release.py), [`LICENSE.md`](https://github.com/theupdateframework/specification/blob/v1.0.35/LICENSE.md), governance/maintainers/roadmap. | Community Specification License, not a conventional runtime-code license. It permits specification implementation under its terms but requires legal review before copying normative text or representations. No endpoint package is proposed. | Active stable specification release in July 2026; tagged, release-checked, governed, with historical versions and a release workflow. It is a specification, so implementation security depends on conforming clients and local profiles. | Strong similarity: threshold roles, trusted roots, expiry, rollback/freeze protection, version chains, repository compromise assumptions. Difference: TUF authorizes software targets in a repository; UAM authorizes a finite collection ceiling plus realm narrowing and has session/raw-data privacy boundaries. | **Reuse:** threshold/key separation, trusted bootstrap, expiry, anti-rollback/freeze, consistent immutable digests, root/key rotation ceremony, explicit recovery. **Do not copy:** the full root/targets/snapshot/timestamp/delegation graph, path delegation, mirror logic, or metadata role complexity without a measured update-repository requirement. | **Reference only — High fitness as design evidence; not an endpoint dependency.** Reconsider a conforming TUF client only if future multi-repository/offline-mirror update requirements justify it. |
| **R-02 — python-tuf** — [repository](https://github.com/theupdateframework/python-tuf), [tag `v7.0.0`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0), release commit [`353bdb7`](https://github.com/theupdateframework/python-tuf/commit/353bdb7), released **18 May 2026**. | [`tuf/`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0/tuf), [`tests/`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0/tests), [`docs/`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0/docs), [`verify_release/`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0/verify_release), [`.github/`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0/.github), [`SECURITY.md`](https://github.com/theupdateframework/python-tuf/blob/v7.0.0/SECURITY.md), licenses and package metadata. | Dual MIT/Apache-2.0. Permissive, but a Python runtime/library is inconsistent with the accepted C# endpoint family and would add packaging, patching, and support surface. Legal/SBOM review would still be required. | Large test suite, release verification directory, security policy, active maintenance. v7.0.0 fixed **GHSA-qp9x-wp8f-qgjj**, incorrect delegation-path matching on Windows. That fix is especially relevant evidence that seemingly small cross-platform canonicalization/matching rules can become security defects. | Concrete signed-metadata client with trusted bootstrap and update workflow. Difference: Python-TUF’s path/delegation/network repository machinery is outside UAM’s typed privacy lattice; UAM cannot let path matching or delegated metadata select user data sources. | **Reuse:** bootstrap tests, metadata verification sequencing, version/expiry test shapes, release verification, explicit security advisories, Windows-specific negative testing. **Do not copy:** Python runtime, delegation/path semantics, generic updater network client, or assumption that a valid target is a collection authorization. | **Reference only; neither endpoint nor server dependency.** Use its tests/advisory history to strengthen UAM canonicalization and Windows cases. |
| **R-03 — Open Policy Agent (OPA)** — [repository](https://github.com/open-policy-agent/opa), [tag `v1.19.0`](https://github.com/open-policy-agent/opa/tree/v1.19.0), release commit [`1e32c79`](https://github.com/open-policy-agent/opa/commit/1e32c79), released **30 July 2026**. | [`ast/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/ast), [`rego/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/rego), [`topdown/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/topdown), [`bundle/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/bundle), [`sdk/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/sdk), [`wasm/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/wasm), [`test/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/test), [`e2e/`](https://github.com/open-policy-agent/opa/tree/v1.19.0/e2e), [`SECURITY.md`](https://github.com/open-policy-agent/opa/blob/v1.19.0/SECURITY.md), [`SECURITY_AUDIT.pdf`](https://github.com/open-policy-agent/opa/blob/v1.19.0/SECURITY_AUDIT.pdf), workflows and capabilities metadata. | Apache-2.0; notices/transitive Go/Wasm dependencies require review. Embedding native/Wasm/sidecar OPA would add a second runtime and language lifecycle to C# endpoints. CI-only use would still require pinned binaries, SBOM, vulnerability review, and sandboxing of untrusted policies. | Very active, extensive unit/e2e/benchmark infrastructure, security policy and published audit. The current release fixed a Compile API SQL-injection vector, tightened assignment safety, changed its Wasm runtime, and warns on some unknown configuration. This is evidence of responsive maintenance and also of the continuing attack/semantic surface in a general engine. | Similarity: deterministic policy evaluation, schemas/capabilities, bundles, testing, partial evaluation. Difference: Rego is a general-purpose declarative language over dynamic input/data with many built-ins, external bundles, partial evaluation, server/SDK modes, and potentially caller-controlled context. UAM needs a finite monotone permission lattice and no policy-selected I/O. | **Reuse:** policy-as-code discipline, capability/version metadata, parser/fuzz/e2e practices, deterministic result reasons, rejecting/flagging unknown configuration, differential testing ideas. **Do not copy:** Rego as endpoint language, arbitrary input/data documents, built-ins, external data/bundles, policy-generated SQL, partial evaluation as collection authorization, or a sidecar that can become the sole gate. | **Reference; optional isolated CI experiment only. Not a production endpoint dependency.** A future proposal must prove a restricted subset is monotone and cheaper to assure than the custom evaluator. |
| **R-04 — Cedar** — [repository](https://github.com/cedar-policy/cedar), [tag `v4.12.0`](https://github.com/cedar-policy/cedar/tree/v4.12.0), release commit [`fdcbaed`](https://github.com/cedar-policy/cedar/commit/fdcbaed), released **28 July 2026**. | [`cedar-policy/`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy), [`cedar-policy-core/`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-core), [`cedar-policy-symcc/`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-symcc), [`cedar-testing/`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-testing), [`cedar-policy-cli/`](https://github.com/cedar-policy/cedar/tree/v4.12.0/cedar-policy-cli), [`SECURITY.md`](https://github.com/cedar-policy/cedar/blob/v4.12.0/SECURITY.md), [`deny.toml`](https://github.com/cedar-policy/cedar/blob/v4.12.0/deny.toml), license/notices/workflows. | Apache-2.0 with NOTICE and third-party-license inventory. Embedding would add Rust/FFI or Wasm, crate lifecycle, unsafe-boundary review, and operational skill requirements to a C# endpoint. | Active release days before the research date; dedicated testing and symbolic-counterexample tooling; security policy and dependency-deny configuration. v4.12.0 tightened malformed protobuf/policy-set validation, duplicate-ID handling, and nesting-depth checks—useful secure-parser lessons. | Similarity: schema-validated policy, deny-by-default authorization, analyzability, concrete counterexamples. Difference: Cedar models principal/action/resource authorization and expressive RBAC/ABAC. UAM’s order spans fields, transforms, destinations, frequency/lookback/volume, diagnostics, source generation, and kill switches; those are not ordinary access-control tuples. | **Reuse:** schema validation, separate parser/validator/evaluator, concrete counterexample generation, bounded nesting, duplicate-ID rejection, unchecked APIs only for demonstrably trusted input, symbolic-test mindset. **Do not copy:** Cedar language/entity graph as collection policy, per-person ABAC, Rust FFI, or the assumption that authorization `Permit` establishes privacy minimization. | **Reference only; not an endpoint dependency.** Cedar may be reconsidered separately for portal/resource authorization, never as a substitute for the collection lattice without a new ADR. |
| **R-05 — flagd** — [repository](https://github.com/open-feature/flagd), [tag `flagd/v0.16.1`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1), release commit [`fce1090`](https://github.com/open-feature/flagd/commit/fce1090), released **27 July 2026**. | [`config/`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1/config), [`core/`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1/core), [`flagd/`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1/flagd), [`schemas` submodule at `cdc2907`](https://github.com/open-feature/schemas/tree/cdc2907), [`test-harness` submodule at `df6a843`](https://github.com/open-feature/test-harness/tree/df6a843), [`test/`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1/test), [`.github/`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1/.github), security/license/contributing files. | Apache-2.0; Go daemon, gRPC/HTTP, containers, schemas and submodules add runtime/transitive support. OpenFeature ecosystem compatibility is useful operationally but not proof that a flag is a safe privacy authority. | Active release four days before the research date; test harness and schemas; security policy; v0.16.1 updated security dependencies/gRPC, added timeouts, and fixed invalid-selector handling. | Similarity: typed flag values, disabled states, evaluation reasons, distribution, near-real-time kill switches. Difference: flagd deliberately supports multiple local/remote data sources, flexible rule targeting, percentage rollout, dynamic evaluation context, and live updates. Those features can create a parallel broadening/person-targeting plane. | **Reuse:** fixed evaluation reasons, explicit disabled semantics, conformance harness, clear sync health, monotone disable switch UX, bounded stale-state reporting. **Do not copy:** arbitrary remote URI sources, multiple authority sources, percentage/person targeting, general object flags, policy-selected context, hot updates that bypass signed revision/ceiling checks, or default-value semantics as authorization. | **Reference only.** A general feature service MAY be used server-side for non-collection UI behavior if a fitness test proves it cannot influence collection authorization. |
| **R-06 — Conftest** — [repository](https://github.com/open-policy-agent/conftest), [tag `v0.68.2`](https://github.com/open-policy-agent/conftest/tree/v0.68.2), release commit [`36f23bf`](https://github.com/open-policy-agent/conftest/commit/36f23bf), released **15 April 2026**. | [`policy/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/policy), [`parser/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/parser), [`output/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/output), [`internal/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/internal), [`examples/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/examples), [`tests/`](https://github.com/open-policy-agent/conftest/tree/v0.68.2/tests), [`acceptance.bats`](https://github.com/open-policy-agent/conftest/blob/v0.68.2/acceptance.bats), [`SECURITY.md`](https://github.com/open-policy-agent/conftest/blob/v0.68.2/SECURITY.md), workflows and license. | Apache-2.0 plus OPA/Go dependencies. A separate CI binary introduces supply-chain/version drift. The reviewed release embeds OPA 1.15.2, older than the OPA 1.19.0 current on the research date, so vulnerability and semantic review must be independent. | Maintained release, unit/acceptance tests, security policy, signed tag; dependency automation visible. Its purpose is structured-configuration testing, not runtime authorization. | Similarity: repository policy tests, many structured input formats, machine-readable failure output. Difference: assertions are arbitrary Rego and prove only the tested rules/files, not UAM’s runtime monotonicity or process-boundary enforcement. | **Reuse:** `policy test` developer workflow, deterministic violation messages/codes, fixtures in source control, CI gates over generated artifacts, parse-failure discipline. **Do not copy:** accepting many serialization formats, arbitrary Rego, or treating a passing CI scan as the endpoint’s runtime gate. | **Reference only; optional isolated CI comparator, not required.** Prefer the native UAM CLI/reference evaluator so production and CI semantics cannot drift. |
| **R-07 — FsCheck** — [repository](https://github.com/fscheck/FsCheck), [tag `3.3.3`](https://github.com/fscheck/FsCheck/tree/3.3.3), release commit [`ec83a8d`](https://github.com/fscheck/FsCheck/commit/ec83a8d), released **26 April 2026**. | [`src/`](https://github.com/fscheck/FsCheck/tree/3.3.3/src), [`tests/`](https://github.com/fscheck/FsCheck/tree/3.3.3/tests), [`docs/`](https://github.com/fscheck/FsCheck/tree/3.3.3/docs), [`examples/`](https://github.com/fscheck/FsCheck/tree/3.3.3/examples), build files, release notes, [`License.txt`](https://github.com/fscheck/FsCheck/blob/3.3.3/License.txt). | BSD-3-Clause, generally compatible for a test-only dependency subject to normal legal notice, exact NuGet package provenance, transitive dependency, and vulnerability review. Do not ship it in endpoint production binaries unless separately justified. | Active 2026 release; repository contains unit tests and .NET build/test workflow. FsCheck generates many cases, records distribution, shrinks failures, and reports minimal counterexamples. No dedicated `SECURITY.md` was observed at the reviewed tag; test-only dependency governance is still required. | Strong similarity for proving algebraic laws over finite generated policies and state transitions. Difference: property-based testing samples cases; it is not a formal proof and does not test OS/IPC/storage behavior unless modeled and integrated. | **Reuse:** generators for ceilings/policies/mutations, shrinking, reproducible seeds/replay, classification/coverage, state-machine command models, cross-checking reference and optimized evaluators. **Do not copy:** reliance on default generators, unconstrained huge objects, nondeterministic CI without seed capture, or treating successful random runs as proof of all behavior. | **Candidate test-only dependency.** Accept only after package/license/security review at implementation time. Keep deterministic exhaustive tests for small domains and explicit negative vectors alongside it. |

## 14.1 Dependency decision

**RECOMMENDATION.** The production endpoint takes **none** of R-01 through R-06 as a runtime dependency. R-07 is a reasonable **test-only** candidate, not a decision imposed by this research. The UAM repository should record exact dependency versions, hashes, SBOM, license notices, security review, and a replacement plan at the implementation commit. Current releases are point-in-time evidence, not timeless architecture.

**INFERENCE.** The repository review strengthens rather than weakens the custom evaluator choice. Mature projects repeatedly add parser validation, unknown-option handling, depth limits, dependency security updates, and fixes for path matching, SQL generation, selector handling, and malformed input. UAM should borrow those defensive practices while avoiding features its use case does not need.

---
# 15. Source register with stable links, dates, reviewed versions, claims, and limitations

**Research cut-off:** 31 July 2026. **FACT.** Only the four project attachments listed in §15.1 were opened or used. Public claims were checked against primary standards, official documentation, official regulator material, or the repository/release records pinned below. A current release proves documented capability and maintenance state at this cut-off; it does not prove UAM fitness. Dynamic documentation pages are recorded with the review date because their content can change without a new URL.

## 15.1 Allowed supplied project evidence

| ID | Supplied source and stable identity | Source date / reviewed version | Claim supported in this result | Classification and limitation |
|---|---|---|---|---|
| **I-01** | `00-accepted-baseline-attachment.md`; SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Baseline dated **31 July 2026** | Accepted endpoint process boundaries; C#/.NET family; release-authorized privacy ceiling; tenant-only narrowing; pre-IPC minimization; release, realm, audit, cursor, and forbidden-value invariants; first synthetic Edge site/domain slice. | Internal sanitized working baseline. It is not legal authority, unconditional production approval, runtime proof, or evidence for provisional numeric choices. |
| **I-02** | `05-decisions-contradictions-and-gates.md`; source synthesis SHA-256 `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | July 2026 final synthesis | Accepted design tensions; browser acquisition boundary; proof-gate order G0–G5 and later gates; rule that failed gates stop dependent work. | Internal sanitized curated extract for implementation research. It does not prove Windows behavior, production capacity, operations, or approval. |
| **I-03** | `02-sanitized-application-catalogue-report.md`; source SHA-256 `b1f665fb2d381bd220e95b5158d3d84ceed97772cc3dda940a7ac4ed70f2b2e4` | Profiled **31 July 2026** | Catalogue shape used only for import/data-quality constraints: 173 unique names in the measured snapshot, five missing external references, no duplicated non-empty references, one address-like name, ten non-ASCII names, nine possible truncation markers; absence of role, owner, rule, entitlement, and observed-use dimensions. | Internal sanitized aggregate profile. Raw values are absent. It cannot authorize sources, fields, matching, roles, targeting, ownership, purpose, or currentness. |
| **I-04** | `06-research-evidence-rules.md` | July 2026 research package; no content hash supplied | Evidence labels, source-quality hierarchy, human-decision boundaries, conflict handling, confidence convention, and prohibition on sensitive internal material. | Research-governance instruction, not evidence that any technical capability is true. |

## 15.2 Public primary specifications, official documentation, and regulator material

| ID | Direct stable source | Source / release date and version reviewed | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| **S-01** | [Microsoft .NET and .NET Core lifecycle](https://learn.microsoft.com/en-us/lifecycle/products/microsoft-net-and-net-core) | Dynamic official lifecycle page reviewed **31 July 2026**; .NET 10 lifecycle row starts 11 November 2025 and ends 14 November 2028 | .NET 10 is an LTS line within the accepted implementation family at this research cut-off. | The lifecycle table does not select a UAM patch, prove compatibility, or replace implementation-time servicing/lab evidence. |
| **S-02** | [Microsoft — .NET releases, patches, and support](https://learn.microsoft.com/en-us/dotnet/core/releases-and-support) | Dynamic official documentation reviewed **31 July 2026** | Supported .NET releases receive monthly servicing and only the latest servicing level is supported; exact patches must remain lifecycle-managed rather than architectural constants. | Does not prove that any package, cryptographic API use, Windows mode, or UAM build is secure or supported. |
| **S-03** | [RFC 7515 — JSON Web Signature (JWS)](https://www.rfc-editor.org/rfc/rfc7515) | **May 2015**, RFC 7515 | JWS serialization and signature-input rules; support for multiple signatures in General JSON Serialization. | JWS permits many choices. UAM must define a much narrower algorithm/header/serialization profile and test it independently. |
| **S-04** | [RFC 7518 — JSON Web Algorithms (JWA)](https://www.rfc-editor.org/rfc/rfc7518) | **May 2015**, RFC 7518 | Standard identifiers and encoding requirements for algorithms including ES256. | Algorithm availability is not key custody, implementation correctness, threshold governance, or resistance to misuse. |
| **S-05** | [RFC 8785 — JSON Canonicalization Scheme (JCS)](https://www.rfc-editor.org/rfc/rfc8785) | **June 2020**, RFC 8785 | Deterministic JSON canonicalization suitable for hashing/signing under a constrained I-JSON data model. | Canonicalization does not validate policy semantics, reject every ambiguous parser behavior by itself, or provide signatures. |
| **S-06** | [RFC 8259 — The JavaScript Object Notation (JSON) Data Interchange Format](https://www.rfc-editor.org/rfc/rfc8259) | **December 2017**, RFC 8259 | Base JSON syntax and interoperability warnings, including non-unique object-member behavior across implementations. | Base JSON deliberately leaves interoperability hazards; UAM therefore rejects duplicate members and restricts numbers, depth, size, and Unicode handling. |
| **S-07** | [JSON Schema Core, Draft 2020-12](https://json-schema.org/draft/2020-12/json-schema-core) | **Draft 2020-12**, official specification reviewed **31 July 2026** | Vocabulary, schema-document, identifier, reference, and applicator model for versioned strict schemas. | JSON Schema validation alone is not cryptographic authenticity or monotonic-policy proof. Implementation support must be tested against UAM vectors. |
| **S-08** | [JSON Schema Validation, Draft 2020-12](https://json-schema.org/draft/2020-12/json-schema-validation) | **Draft 2020-12**, official specification reviewed **31 July 2026** | Validation keywords used for typed bounds, required members, enums, arrays, and formats. | Format handling and implementation behavior vary. UAM uses explicit bounded checks and conformance tests rather than assuming every library behavior. |
| **S-09** | [RFC 8725 — JSON Web Token Best Current Practices](https://www.rfc-editor.org/rfc/rfc8725) | **February 2020**, RFC 8725 / BCP 225 | Security practices relevant to JOSE processing: algorithm verification, explicit typing, mutually exclusive validation rules, and distrust of received claims. | It addresses JWT deployments, while UAM signs typed configuration artifacts rather than authentication tokens. Guidance is applied selectively and does not define UAM policy semantics. |
| **S-10** | [OpenTelemetry — Metrics concepts](https://opentelemetry.io/docs/concepts/signals/metrics/) | Dynamic official documentation reviewed **31 July 2026** | Metrics use attributes/dimensions and can create many distinct time series; aggregation and dimensionality affect cost and operability. | It does not set UAM’s privacy allowlist or numeric cardinality limits. |
| **S-11** | [OpenTelemetry Specification — Metrics SDK](https://opentelemetry.io/docs/specs/otel/metrics/sdk/) | Current specification page reviewed **31 July 2026** | Views, aggregation, attribute selection, and cardinality-limiting behavior are implementable control points. | SDK controls contain resource use; they do not make sensitive labels safe. UAM must prevent forbidden attributes before instrumentation. |
| **S-12** | [OpenTelemetry .NET — Metrics best practices](https://opentelemetry.io/docs/languages/dotnet/metrics/best-practices/) | Official page last modified **19 May 2026**, reviewed 31 July 2026 | .NET guidance describes cardinality management and the SDK’s default 2,000 points-per-metric behavior with overflow handling. | The 2,000 value is not a UAM target. This result proposes materially smaller initial caps as a replaceable engineering hypothesis pending measurement. |
| **S-13** | [Regulation (EU) 2016/679 — consolidated GDPR text](https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX%3A02016R0679-20160504) | Regulation adopted **27 April 2016**; official consolidated text reviewed **31 July 2026** | Articles 5 and 25 provide primary context for data minimization and data protection by design/default. | Research does not determine UAM’s legal basis, necessity, proportionality, employee notice/consultation, rights handling, or approval. Jurisdiction-specific advice is required. |
| **S-14** | [W3C Web Content Accessibility Guidelines (WCAG) 2.2](https://www.w3.org/TR/WCAG22/) | W3C Recommendation dated **12 December 2024**, reviewed 31 July 2026 | Stable accessibility criteria for the policy simulator, approval, audit, and emergency-disable interfaces; AA is a defensible engineering target. | Conformance cannot be inferred from framework choice or automated scans alone; representative manual and assistive-technology testing is required. |
| **S-15** | [NIST SP 800-218 — Secure Software Development Framework (SSDF) v1.1](https://csrc.nist.gov/pubs/sp/800/218/final) | Final publication **February 2022**, version 1.1 | Primary secure-development practices for preparing the organization, protecting software, producing well-secured software, and responding to vulnerabilities. | It is outcome-oriented guidance, not a UAM design, cryptographic profile, assurance certificate, or substitute for tests. |
| **S-16** | [EDPB Guidelines 4/2019 on Article 25 — Data Protection by Design and by Default](https://www.edpb.europa.eu/documents/guideline/guidelines-42019-on-article-25-data-protection-by-design-and-by-default_en) | Final version adopted **20 October 2020**; reviewed 31 July 2026 | Regulator guidance on implementing data-protection principles and default safeguards through measures and governance. | It does not approve UAM’s purposes, fields, hard-deny classes, identity precision, retention, or deployment; accountable legal/privacy review remains mandatory. |
| **S-17** | [The Update Framework Specification, stable](https://theupdateframework.github.io/specification/latest/) | Specification **v1.0.35**, released **15 July 2026**; repository revision `7cccae7` reviewed | Threshold roles, version/freshness, rollback/freeze protection, root/key rotation, consistent snapshots, and trusted-state update patterns used as reference for signed policy delivery. | TUF secures software-update metadata/targets. It does not prove semantic narrowing, session authorization, pre-IPC minimization, or tenant policy governance. |
| **S-18** | [OpenFeature Specification — Evaluation Context](https://openfeature.dev/specification/sections/evaluation-context/) | Current official specification section reviewed **31 July 2026** | General feature-flag systems may evaluate contextual attributes and targeting data, clarifying why unrestricted feature targeting must not become UAM collection authority. | This is a comparison source, not a finding that every OpenFeature implementation is unsafe. UAM could use such systems for non-collection behavior behind a proven separation boundary. |

## 15.3 Open-source repositories and exact revisions reviewed

The detailed maintenance, testing, security, threat-model, reuse, and dependency findings are in §14. This table is the compact provenance register.

| ID | Repository and exact revision | Release date | License observed | Claim supported and important limitation |
|---|---|---:|---|---|
| **R-01** | [theupdateframework/specification](https://github.com/theupdateframework/specification), tag [`v1.0.35`](https://github.com/theupdateframework/specification/tree/v1.0.35), release commit [`7cccae7`](https://github.com/theupdateframework/specification/commit/7cccae7) | 15 July 2026 | Community Specification License 1.0 | Strong reference for signed metadata roles, expiry/version/rollback and root rotation. It is a specification, not an endpoint policy library and not proof of semantic monotonicity. |
| **R-02** | [theupdateframework/python-tuf](https://github.com/theupdateframework/python-tuf), tag [`v7.0.0`](https://github.com/theupdateframework/python-tuf/tree/v7.0.0), release commit [`353bdb7`](https://github.com/theupdateframework/python-tuf/commit/353bdb7) | 18 May 2026 | MIT and Apache-2.0 dual licensing | Maintained reference implementation with tests and security handling; the release included a fix for incorrect Windows delegation-path matching. Python/runtime/update semantics do not fit the C# endpoint authorization boundary as a dependency. |
| **R-03** | [open-policy-agent/opa](https://github.com/open-policy-agent/opa), tag [`v1.19.0`](https://github.com/open-policy-agent/opa/tree/v1.19.0), release commit [`1e32c79`](https://github.com/open-policy-agent/opa/commit/1e32c79) | 30 July 2026 | Apache-2.0 | Mature policy engine and strong testing/security lessons. The current release included security-relevant fixes, but Rego’s expressive general-purpose model is broader than the finite UAM privacy lattice and would add a large endpoint attack/assurance surface. |
| **R-04** | [cedar-policy/cedar](https://github.com/cedar-policy/cedar), tag [`v4.12.0`](https://github.com/cedar-policy/cedar/tree/v4.12.0), release commit [`fdcbaed`](https://github.com/cedar-policy/cedar/commit/fdcbaed) | 28 July 2026 | Apache-2.0 with notices | Useful schema, validation, bounded parsing, and symbolic-counterexample ideas. Principal/action/resource authorization is not equivalent to multi-dimensional collection minimization; Rust/FFI or Wasm would add endpoint complexity. |
| **R-05** | [open-feature/flagd](https://github.com/open-feature/flagd), tag [`flagd/v0.16.1`](https://github.com/open-feature/flagd/tree/flagd/v0.16.1), release commit [`fce1090`](https://github.com/open-feature/flagd/commit/fce1090) | 27 July 2026 | Apache-2.0 | Useful disabled-state, reason-code, conformance, and synchronization patterns. General contextual/percentage targeting and multiple data sources must not become a parallel collection-authority plane. |
| **R-06** | [open-policy-agent/conftest](https://github.com/open-policy-agent/conftest), tag [`v0.68.2`](https://github.com/open-policy-agent/conftest/tree/v0.68.2), release commit [`36f23bf`](https://github.com/open-policy-agent/conftest/commit/36f23bf) | 15 April 2026 | Apache-2.0 | Useful repository/CI policy-test workflow. It embeds OPA 1.15.2 at the reviewed release and cannot replace native runtime/evaluator conformance or prove process-boundary enforcement. |
| **R-07** | [fscheck/FsCheck](https://github.com/fscheck/FsCheck), tag [`3.3.3`](https://github.com/fscheck/FsCheck/tree/3.3.3), release commit [`ec83a8d`](https://github.com/fscheck/FsCheck/commit/ec83a8d) | 26 April 2026 | BSD-3-Clause | Good test-only candidate for generators, shrinking, seed replay, and state-machine properties. Sampling is not formal proof; deterministic exhaustive vectors, mutation, differential, fuzz, crash, and Windows tests remain required. |

## 15.4 Evidence interpretation and freshness rules

1. **FACT.** Standards describe formats and documented behavior; they do not prove the chosen UAM composition is secure, private, fast, operable, or legally sufficient.
2. **RECOMMENDATION.** At implementation and every dependency/release review, re-resolve lifecycle status, exact package/tag, source hash, signature/provenance, license, vulnerability record, transitive dependencies, and supported runtime. Do not copy the point-in-time versions above into timeless architecture rules.
3. **CLI EXPERIMENT.** Archive a machine-readable evidence manifest containing source URL, retrieved/reviewed timestamp, tag, resolved full commit, artifact hash, license hash, test command/result, vulnerability-scan result, and reviewer. The report may retain short display commits; the implementation manifest must resolve and pin the complete object IDs.
4. **UNKNOWN.** Repository activity and published security policies cannot establish undisclosed vulnerabilities, maintainer continuity, organizational support capacity, or UAM-specific threat fitness.
5. **FACT.** No vendor marketing page, popularity count, search snippet, raw internal catalogue, credential, address, person, production activity, or confidential configuration was used as proof.

# 16. Confidence table for every major conclusion

Confidence means strength of the available design/evidence chain at the research cut-off, not a probability or production approval. “Would change it” identifies evidence that must cause review, a revised ADR, or a baseline change proposal rather than silent drift.

| ID | Major conclusion | Confidence | Why / present evidence | Evidence that would change the conclusion or confidence |
|---|---|---|---|---|
| C-01 | A release-authorized finite product privacy ceiling with tenant-only narrowing is the correct authority model. | **High** | Accepted baseline and invariants [I-01][I-02]; finite types permit deterministic proof, strict failure, independent enforcement, and test generation. | Primary evidence that a required approved use cannot be represented without unsafe ambiguity; a falsifying monotonicity counterexample; or a formally smaller model with equal process-boundary assurance and lower operational cost. |
| C-02 | Effective authority should be the meet/intersection of ceiling, tenant policy, product disable overlay, tenant disable overlay, local safety state, and runtime capability. | **High** for the algebra; **Medium** for complete production dimensions | Set, Boolean, ordered-bound, diagnostics, transform, destination, and feature operations are formalizable; the design never uses union/default-enable. | Discovery of an incomparable dimension without a unique safe meet; an approved source requiring semantics absent from the registry; or differential/property tests finding a broadened effective result. |
| C-03 | Unknown IDs, members, algorithms, semantics, or transform relations must never be ignored or defaulted into collection. | **High** | JSON/JOSE interoperability risks [S-03]–[S-09], accepted stale/incomplete release invariant [I-01], and the primary gate make permissive parsing unsafe. | A mechanically proven, versioned, one-way translation that maps an unknown form to a strictly narrower known form, with independent conformance and migration evidence. |
| C-04 | A small immutable typed C# evaluator is preferable to embedding OPA, Cedar, or a general feature-flag engine on endpoints. | **High** for the first implementation | It fits the accepted implementation family, finite lattice, offline path, and minimal attack surface. Repository review shows useful ideas but materially broader languages/runtime threats (§14). | A bounded external engine profile that is formally monotone, has smaller/equivalent binary and vulnerability surface, deterministic cross-version behavior, supported C# integration, license/skills fit, and better measured lifecycle cost. This requires a new ADR and CLI comparison. |
| C-05 | JSON Schema 2020-12 + duplicate-member rejection + JCS + a fixed JWS General JSON ES256 profile is a sound artifact envelope. | **High** for strict typed signed artifacts; **Medium** for the exact cryptographic profile | Primary standards [S-03]–[S-09] and independently testable bytes/signatures. General JSON supports multiple signatures without inventing a container. | Cryptographic review finds unsafe library behavior, Windows key-provider incompatibility, algorithm-policy conflict, unacceptable signature size/performance, or a supported enterprise profile with stronger operational evidence. Exact algorithm/threshold changes must preserve typed semantics and migration. |
| C-06 | Product ceiling authorization needs separated threshold signatures; realm policy needs a realm-confined signer separated from portal, repository, and build identities. | **High** for separation; **Medium** for exact ceremony | Prevents any ordinary single plane/key from broadening and borrows mature root/role separation patterns [R-01][R-02]. | Key-management/availability evidence shows the proposed separation cannot be operated; threat review identifies an unseparated signer path; or an alternative threshold/attestation design proves equal containment. Exact M-of-N remains a human decision. |
| C-07 | “Rollback” must be a new, higher monotonic revision that references the prior semantic content; lower revisions are never reaccepted. | **High** | It preserves anti-rollback while enabling recovery and yields a simple highest-seen invariant/test. | A recovery drill proves this blocks safe recovery under a defined failure mode and a different protocol preserves anti-rollback, audit, and offline correctness. |
| C-08 | Verify-before-cache, one atomic activation transaction, highest-seen counters, and immutable LKG artifacts are required endpoint cache rules. | **High** for the invariant; **Medium** until crash-tested | Prevents torn/invalid activation and aligns with accepted atomicity/recovery principles; explicit failpoints make it falsifiable. | SQLite/lab crash tests expose an unhandled atomicity/fsync/rollback path, or a simpler durable mechanism produces stronger evidence without weakening offline behavior. |
| C-09 | Ordinary incompatible/malformed candidates may be quarantined while a still-valid compatible LKG continues, but signature, realm, chain, rollback, conflict, or broadening evidence enters `SafetyHold`. | **Medium** | Asymmetric handling avoids turning every malformed distribution item into a fleet-wide denial while treating authority-integrity evidence as an incident. | Threat exercises show quarantine permits an attacker to freeze unsafe authority, or availability tests show `SafetyHold` can be weaponized without adequate authenticated recovery. Exact classification may be refined only while the primary zero-new-collection gate remains true. |
| C-10 | Expired authority produces no new collection; there is no implicit grace period. | **High** as a safe default; **Medium** operationally | Primary gate explicitly requires expired policy to collect nothing. A hidden grace weakens signed expiry. | Human-approved offline-risk evidence, legal/privacy decision, and a protocol proving a bounded, signed, ceiling-narrowing offline lease is necessary. Such a change needs ADR, threat review, and expiry/clock experiments. |
| C-11 | Clock rollback or inability to establish trustworthy time must stop new collection rather than extend policy life. | **Medium** | It blocks easy expiry bypass and is conservative. Exact Windows sleep, domain time, offline, VM snapshot, and drift behavior is unmeasured. | Approved Windows lab evidence supports a bounded corroborated clock algorithm; fleet metadata establishes tolerances; or availability harm requires a signed alternative that cannot extend authorization. |
| C-12 | Coordinator intent plus User Host/session authorization plus a single-use Task Host permit is the right multi-process enforcement pattern. | **Medium** | It respects accepted process/session boundaries and gives Task Host and Coordinator independent checks. The protocol is specified and falsifiable but not yet proven on Windows. | G1/P-06 lab evidence finds token/session/IPC/cancellation/replay flaws, or a smaller Windows primitive provides stronger unforgeability and lifecycle binding. |
| C-13 | A policy/ceiling change during a run invalidates the run permit; output is discarded and the source cursor does not advance. | **High** for privacy/cursor safety; **Medium** for measured cost | It prevents post-revocation output and preserves the accepted cursor invariant. Run nonce and provenance make enforcement explicit. | Performance measurements show unacceptable repeat work and an alternative can prove an atomic snapshot/lease whose signed validity cannot outlive authority or commit forbidden data. |
| C-14 | Enforcement must exist in Task Host, User Host, Coordinator, server, portal/control plane, and release pipeline; no one ordinary compromised plane should broaden. | **High** as defense-in-depth requirement; **Medium** for achieved compromise containment | Independent typed checks and provenance stop common single-plane mistakes/compromises. Test matrix includes bypasses at each plane. | Red-team evidence finds a single plane that can mint accepted permits/events or alter the release ceiling; or implementation collapses supposedly independent keys/code paths. A malicious valid signed binary, OS/kernel, local administrator, or colluding signers remains outside this guarantee. |
| C-15 | Every tenant policy variant must bind to an exact release/ceiling digest and interpreter range; agents do not auto-rebind or partially interpret. | **High** for privacy compatibility; **Medium** for operational scale | Prevents old policy from authorizing new release capability and old agents from ignoring new semantics. | Fleet simulation demonstrates variant explosion or rollout deadlock, and a verified translation/proof-carrying compatibility mechanism safely reduces variants without defaulting unknown semantics. |
| C-16 | Emergency authority must be disable-only and monotone; enabling or broadening requires the normal reviewed policy/release path. | **High** | Boolean AND/deny overlays are simple, independently testable, and limit key/portal incident impact. | An incident class demonstrably requires emergency enabling to prevent greater harm, with explicit human approval and a separately bounded authority model that cannot collect new data. This would be a material change proposal. |
| C-17 | Targeting should use realm-scoped opaque inventory IDs/cohorts, not names, HR attributes, activity, URLs, application strings, or payload-derived identity. | **High** for the boundary; **Medium** for inventory implementation | Realm isolation and minimization; allowed catalogue evidence cannot establish role/owner/rules [I-03]. Opaque targets reduce policy/audit exposure. | Human-approved purpose/legal evidence requires a more specific selector and a threat/privacy assessment proves it can be represented without sensitive policy content or cross-realm inference. |
| C-18 | The sanitized application catalogue can inform validation/synthetic fixtures but cannot authorize policy, role mapping, match rules, ownership, entitlement, or targeting. | **High** | Directly bounded by the supplied profile’s missing dimensions and stated limitation [I-03]. | A separately governed, current, quality-assessed source supplies those semantics with accountable provenance and approval. It would be new evidence, not an inference from names. |
| C-19 | Transform programs must be release-authored, allowlisted immutable implementations with declared input/output schemas and conformance vectors; tenant policy selects but cannot supply code. | **High** | Prevents tenant policy from becoming a plugin/script/exfiltration channel and supports pre-IPC minimization. | A safe declarative transform language is formally bounded, non-Turing-complete, monotone, resource-limited, cross-version deterministic, and independently reviewed; accepting it requires a new ADR. |
| C-20 | Server and portal must independently reject/quarantine impossible provenance, wrong realm, unsupported ceiling/policy/transform/output schema, and forbidden fields even if endpoints err. | **High** | Defense in depth, authenticated realm derivation, and the fact endpoint enforcement can fail. Independent validation prevents visibility/materialization of impossible data. | A proof that all endpoint paths are invulnerable—which is not realistically available—or evidence the server check creates greater risk than it contains. Performance can change implementation, not the invariant. |
| C-21 | Observability must use a finite privacy allowlist and fixed error taxonomy; source/policy/target/user/device values and arbitrary exception text are forbidden from automatic sinks. | **High** for privacy; **Medium** for exact useful schema | Secondary sinks are common exfiltration paths; fixed codes enable all-sink canary tests. OTel documents cardinality controls [S-10]–[S-12]. | Support exercises prove a missing diagnostic is indispensable and a separately approved, access-controlled, time-bounded support evidence flow can contain it. Automatic free-form logging remains rejected. |
| C-22 | Initial metric caps (≤4 attributes/point, ≤128 active series/instrument/process, ≤1,024 total/process) are conservative replaceable hypotheses, not SLOs. | **Low** for exact numbers; **High** that explicit caps are required | Values intentionally sit below general SDK defaults and make bounded testing possible, but no representative load/cost evidence exists. | Synthetic/lab and staged-fleet measurements of signal loss, memory, CPU, exporter/backend cost, and incident usefulness. Revise by ADR without permitting sensitive dimensions. |
| C-23 | Policy simulation and impact preview must execute the same reference semantics as endpoint policy, show desired versus effective state, expiry/compatibility, and exact target counts without revealing target identities by default. | **High** for need; **Medium** for exact UX | Prevents broad/empty/mistargeted rollout and supports human approval. Accessibility requirements are grounded in WCAG 2.2 [S-14]. | Usability/accessibility testing finds the model misleading, or differential tests show simulator/runtime drift; any alternative must preserve deterministic proof and privacy-safe targeting. |
| C-24 | Property, exhaustive-small-domain, mutation, differential, fuzz, crash, multi-process, and all-sink canary tests are all required; none alone is sufficient. | **High** | Different classes falsify algebra, parser, optimized evaluator, durability, boundary, and leakage claims. FsCheck is useful only as one test aid [R-07]. | A formally verified implementation may reduce some randomized scope, but OS/storage/IPC/sink integration still requires empirical tests. Any omitted class needs equivalent evidence and ADR rationale. |
| C-25 | The production endpoint should not take TUF, python-tuf, OPA, Cedar, flagd, or Conftest as runtime dependencies for this decision; FsCheck is only a candidate test dependency. | **High** for the first slice; **Medium** over product lifetime | Reviewed projects add useful ideas but unnecessary runtime languages/daemons/data planes and different threat models (§14). | Implementation-time comparative prototype shows a dependency materially lowers code/assurance/operations cost while preserving finite monotonic semantics, C#/Windows support, offline behavior, licensing, patchability, and independent enforcement. |
| C-26 | Passing the primary G4 privacy/canary gate is necessary but does not approve production or prove G5 durability, capacity, restore, legal basis, consultation, support, or operations. | **High** | Accepted proof-gate order and evidence boundaries [I-01][I-02][I-04]. | Only subsequent scoped evidence and accountable human approvals can change those separate states; a G4 pass cannot logically substitute for them. |
| C-27 | No accepted baseline decision needs a change proposal as a result of this research. | **High** | The recommendation refines the accepted ceiling/narrowing decision and process boundaries rather than contradicting them. | A reviewer identifies an implicit change to an accepted invariant, or a required experiment falsifies the proposed realization. Then stop, document affected decision/evidence/migration, and open an ADR change proposal. |

# Residual risk and explicit next stop/go gate

## What remains unsafe, uncertain, costly, or human-dependent

- **Residual authority risk:** a malicious but correctly threshold-signed product release/ceiling, colluding authorized signers, compromised key ceremony, or corrupted approved transform can still authorize harmful collection within its signed content. Separation, protected keys, reproducible review, transparency/audit, and independent runtime checks reduce but do not eliminate this risk.
- **Residual platform risk:** a compromised Windows kernel, trusted installer/release chain, local administrator, EDR/injection-capable security product, hypervisor, or memory-reading privileged process can bypass ordinary process boundaries or read raw source memory. This design contains ordinary plane compromise; it is not a trusted-computing proof against the platform owner.
- **Residual semantic/covert-channel risk:** a transform may technically emit allowed fields while encoding more information than intended; output sizes, timing, order, error behavior, or identifiers may become covert channels. Registry review, information-budget reasoning, deterministic transforms, output-schema checks, synthetic canaries, cardinality limits, and adversarial review are required, but research cannot prove absence of every channel.
- **Residual offline risk:** no control plane can guarantee an immediate remote kill for an unreachable endpoint. Signed expiry and locally cached disable state bound future collection only according to the approved validity/clock model. Exact validity windows, clock tolerance, network/proxy behavior, sleep, VM snapshots, and extended offline operation remain unmeasured.
- **Residual compatibility risk:** multiple release/ceiling/policy variants can create rollout deadlock or operational load. Automatic fallback is deliberately rejected; simulation, canaries, fleet-state observability, staged deployment, and bounded support windows must prove manageability.
- **Residual operational risk:** key custody, threshold ceremonies, realm onboarding/offboarding, signer availability, audit review, emergency disablement, artifact distribution, recovery, and deletion require trained people and rehearsed runbooks. Documentation cannot prove competence, coverage, segregation of duties, or budget.
- **Residual observability risk:** an unregistered sink, library diagnostic, crash dump, Windows event, tracing exporter, support bundle, test artifact, or CI output could retain a forbidden canary. The all-sink inventory and scanner are necessary but can be incomplete; every new sink is a stop-gated schema change.
- **Residual data-quality risk:** source generations, cursors, transformations, inventory targeting, and application references may be stale or wrong without exposing a policy violation. UAM evidence remains fallible operational evidence, not sole forensic proof or a productivity score [I-01].
- **Residual supply-chain risk:** current dependencies, specifications, and repositories can change or disclose new vulnerabilities after 31 July 2026. Exact versions and commits in this report are reviewed evidence, not permanent selection. Build provenance, SBOM, patch policy, re-review, and recoverable release controls remain required.
- **Residual accessibility risk:** WCAG-oriented design and automated checks do not prove an emergency or approval flow is usable by all operators. Manual keyboard, zoom/reflow, contrast, screen-reader, error-recovery, localization, cognitive-load, and time-pressure exercises remain necessary.
- **Human-dependent decisions:** approved purposes, prohibited uses, sources, fields, hard-deny classes, transforms, identity/time precision, first-run lookback, policy approvers, emergency authority, key thresholds, notice/consultation/legal assessment, retention, access, deletion, staffing, budget, SLO/RPO/RTO, and production approval remain **HUMAN DECISIONS**. Conservative defaults do not constitute approval.
- **Research boundary:** prose and standards cannot prove Windows token/session behavior, IPC isolation, parser/library correctness, signature/key-provider behavior, SQLite crash durability, clock logic, endpoint resource budgets, 6,000-endpoint rollout, support readiness, server isolation, deletion, or restore. Those are CLI/lab/operational evidence gates.

## Explicit stop/go decision

**Current decision: STOP production and real-activity collection.** The result is sufficiently specified to **GO only to repository implementation and synthetic/fictional G0–G4 experiments**, subject to accepting the proposed ADRs and assigning owners. No raw catalogue values, internal addresses, credentials, personal data, production activity, or confidential configuration may enter that lane.

**Next stop/go gate: G4 — privacy transformation, monotonic policy, and all-sink canary containment.** A reviewer may mark this topic **GO for dependent G5 work** only when one reproducible, sanitized evidence bundle proves all of the following for the exact build, schemas, registry, ceiling, key fixtures, policy fixtures, and interpreter under review:

1. strict schemas, duplicate-member rejection, canonicalization, and signature verification pass independent conformance, negative, malformed, algorithm-confusion, threshold, key-purpose, realm, expiry, rotation, and revocation vectors;
2. exhaustive-small-domain plus property, mutation, differential, and fuzz suites establish reflexivity, antisymmetry/equivalence handling, transitivity, meet laws, idempotence, commutativity, associativity where defined, `effective ⪯ policy ⪯ ceiling`, and non-escalation under every generated narrowing/disable operation;
3. every invalid, expired, unsupported, wrong-realm, wrong-release, wrong-ceiling, stale, rollback, conflicting, or broader artifact produces **zero new collection permits and zero new collection**, with only an allowlisted privacy-safe audited health state;
4. cache failpoints and restart tests prove no unverified/torn artifact activates, the highest-seen anti-rollback state cannot regress, LKG behavior matches the state machine, and recovery never silently broadens;
5. the Coordinator/User Host/Task Host Windows lab proves session/profile/realm binding, unforgeable single-use permits, nonce replay rejection, expiry/cancellation, and no tested ordinary single-plane bypass;
6. a policy, ceiling, emergency overlay, session, or release change during a run invalidates authorization; discarded output cannot enter Coordinator IPC/outbox/transport and the source cursor does not advance;
7. release-authored transforms accept only declared inputs, emit only the exact signed output schema, satisfy conformance vectors and resource bounds, and cannot invoke arbitrary code, destinations, plugins, scripts, network, or hidden diagnostics;
8. endpoint, IPC, SQLite, Windows event/crash facilities, logs, metrics, traces, dumps, support bundles, server inbox/quarantine/materialization, portal/audit/export, CI, and test artifacts are inventoried and scanned; every forbidden synthetic canary count is exactly zero outside the deliberately isolated raw-source fixture, with scan coverage and cleanup evidence recorded;
9. server/portal independent checks reject or quarantine impossible provenance, forbidden fields, unsupported schemas/transforms, and wrong-realm submissions before visibility/materialization, while producing bounded fixed-code audit evidence;
10. simulation/diff, approval, publication, rollback-as-new-revision, disable-only emergency operation, expiry, key rotation/revocation/recovery, compatibility variants, and staged canary rollout are reproducible, auditable, privacy-safe, and accessible by the agreed test process;
11. the evidence manifest records exact source/build/package hashes, full commits, SBOM, signer/key fixture IDs, commands, seeds, generated counterexamples, failpoint schedules, clocks, environment inventory, results, sink inventory, cleanup, and reviewer decisions without sensitive values; and
12. every open high-severity security/privacy finding is closed or accepted by an accountable human authority without weakening the primary gate.

**Failure action:** on any failed item, stop collection in the affected scope, revoke/cancel permits, prevent cursor advance and visibility, preserve only privacy-safe audit evidence, quarantine artifacts/output, scan and clean synthetic canaries, rotate/revoke test keys when relevant, record exact reproduction evidence, and open or revise the responsible ADR/change proposal. Do not proceed to G5 by exception.

**Passing G4 proves only this scoped privacy-policy gate.** It does not approve real data, production deployment, legal basis, employee consultation, retention/access, durability G5, release/update authorization, device/network identity, server capacity, long-outage behavior, deletion, restore, or extended Windows/VDI support. Continue in the accepted proof-gate order [I-02].
