# G0 dummy-data and test-oracle architecture

**Document status:** Proposed implementation foundation; decision-ready for G0 review, not production approval  
**Research cut-off:** 31 July 2026  
**Target:** next-generation UAM  
**Primary gate:** No production-shaped fixture or live pilot data exists without classification, provenance, expected result, owner, and deletion method.  
**Supplied-evidence boundary:** This result uses only `00-accepted-baseline-attachment.md`, `02-sanitized-application-catalogue-report.md`, `04-data-and-schema-evidence-summary.md`, and `06-research-evidence-rules.md`.  
**Normative language:** `MUST`, `MUST NOT`, `SHOULD`, `SHOULD NOT`, and `MAY` are normative only inside this result.

## Evidence vocabulary

- **FACT** — directly supported by supplied evidence or a current primary source.
- **ASSUMPTION** — supplied or inferred but not proven.
- **INFERENCE** — reasoned from facts; the chain is stated.
- **ESTIMATE** — a numerical hypothesis with replaceable inputs.
- **RECOMMENDATION** — a proposed decision with alternatives and trade-offs.
- **UNKNOWN** — evidence is missing.
- **HUMAN DECISION** — policy, legal, ownership, budget, risk, or business authority.
- **CLI EXPERIMENT** — a claim that must be established by code, lab work, or measurement.

---

# 1. Executive conclusion in easy language, with confidence and residual risk

## 1.1 Decision

**RECOMMENDATION — adopt a UAM-owned deterministic data package and independent truth oracle as the G0 foundation.** Each test dataset is a signed-off package containing:

1. a mandatory classification and provenance manifest;
2. fictional or approved aggregate-shaped input records;
3. deterministic generator instructions, fixed clock, and stable identifiers;
4. an independent truth ledger that predicts every accepted, rejected, quarantined, deferred, duplicate, receipt, materialization, visibility, and cursor outcome;
5. canaries and leak-scanning rules;
6. hashes, schema versions, owner, retention/deletion method, and cleanup evidence.

The package format is owned by UAM. Third-party generators, property-based tools, fuzzers, and scanners can help create or challenge tests, but they do not define canonical IDs, time, distributions, or expected results. This separation prevents a library upgrade from silently changing fixtures and prevents production code from marking its own defects as correct.

**FACT.** The accepted UAM baseline makes the user session and realm security/privacy boundaries; requires minimization before Coordinator IPC, durable storage, logs, diagnostics, or transport; requires event and cursor progress to commit atomically; and requires retries to have one final business effect. The G0 architecture therefore has to model these boundaries and invariants explicitly rather than produce only realistic-looking rows. [P1](#p1)

**FACT.** The sanitized application catalogue proves only a measured shape: 173 case-insensitively unique names, five missing external correlation IDs, ten names with non-ASCII characters, nine possible truncation-marker endings, and one IPv4-like literal. It supplies no role, entitlement, ownership, purpose, lifecycle, matching, or usage truth. [P2](#p2)

**RECOMMENDATION.** Represent that catalogue shape with 173 wholly fictional application records that reproduce the safe counts and quality conditions. Do not copy a name or external ID, and do not infer role-to-application mappings. UAM-owned application IDs are generated independently of optional external references.

## 1.2 The three safe data tiers

| Tier | Name | What it may contain | Where it may live | Default treatment |
|---|---|---|---|---|
| T1 | Fully fictional committed fixtures | Values invented from controlled vocabularies and reserved namespaces; deterministic seeds; expected results; canaries | Main source repository and build artifacts | Reviewable and reproducible; no production-derived values |
| T2 | Sanitized organization-shaped internal data | Approved aggregates, constraints, quality categories, and fictional rows shaped to those aggregates; never raw source values | Access-controlled internal fixture repository or protected build artifact | Data steward approval, lineage, expiry/deletion; no role or purpose inference |
| T3 | Tightly controlled measured evidence | Approved metadata-only measurements needed to replace estimates: counts, byte sizes, timings, retry/error categories, resource use, hashes | Isolated measurement store; never the general fixture repository | Collect nothing until approved; least access; explicit retention and verified deletion |

**RECOMMENDATION.** A dataset is classified by its most sensitive input, not by its output. Transforming T3 measurements into a synthetic distribution does not automatically make the resulting package T1; a steward must demonstrate that no source value or singling-out pattern survived and must issue a new lineage record.

## 1.3 Why this is the simplest safe design

The proposal uses ordinary JSON/NDJSON, JSON Schema 2020-12, canonical JSON for hashing, SHA-256 domain-separated derivation, SQLite for generated harness databases, and a small C#/.NET CLI. It does not introduce a service, broker, synthetic-data platform, machine-learning model, or production-data clone. It keeps G0 executable offline and compatible with the accepted C#/.NET implementation family. JSON Canonicalization Scheme (JCS) supplies a documented invariant byte representation, while the UAM generator first normalizes its own model strings to NFC and then preserves those bytes through JCS. JCS itself does not perform Unicode normalization, so this ordering is part of the UAM contract. [W5](#w5) [W7](#w7)

## 1.4 Confidence and residual risk

**Confidence: High** that the three-tier contract, deterministic package, independent oracle, and fail-closed registry are the correct G0 architecture. They directly enforce accepted UAM invariants and rely on stable, simple primitives.

**Confidence: Medium** that the proposed physical schemas and scenario vocabulary will survive first implementation unchanged. Exact event fields, identity/time precision, batch limits, resource budgets, retention, and production engine details remain provisional or human-owned. [P1](#p1) [P3](#p3)

**Confidence: Low until measured** for Windows/browser lock behavior, crash cut points, 6,000-device capacity, disk-pressure behavior, restore fidelity, and operational support cost. Research can design falsifying experiments but cannot prove those runtime properties. [P4](#p4)

Residual risk remains in four places:

- synthetic fixtures can fail to represent an unmeasured production distribution;
- an oracle can share a conceptual error with the implementation despite code separation;
- leak scanners can miss previously unknown sensitive patterns;
- T2/T3 governance can fail through human misclassification, excessive retention, or owner lapse.

Containment is therefore layered: fail-closed manifest validation, exact canaries, multiple scanners, independent reconciliation, mutation and property tests, access control, expiry, deletion evidence, and proof-gate stop rules. Passing G0 proves the data and oracle contract only; it does not approve live data or prove G1–G12.

---

# 2. Scope, non-goals, accepted inputs, assumptions, and unknowns

## 2.1 In scope

This result defines the repository and test architecture needed to create, classify, generate, scan, execute, reconcile, retain, and delete dummy data and tightly controlled measurements for UAM. It covers:

- organization, realm, role, persona, account, device, installation, session, application, policy, source, generation, cursor, run, event, batch, receipt, audit, deletion, migration, and expected-result models;
- deterministic seeds, clocks, identifiers, integer-weighted distributions, scenario composition, lineage, schema evolution, and truth-ledger rules;
- datasets and falsifying prototypes for G0 through G12;
- privacy canaries, cross-session/realm attacks, browser locks, duplicates, outages, disk pressure, restore, and a 6,000-device structural load dataset;
- data-quality, reproducibility, threat, observability, support, incident, cost, licensing, skills, and accessibility controls within the test-data scope;
- open-source tools as candidate test-only dependencies or design references.

## 2.2 Non-goals

This result does **not**:

- approve a legal purpose, prohibited-use policy, identity level, employee consultation outcome, access policy, retention period, budget, SLO/RPO/RTO, staffing model, or production deployment;
- define the final production event schema, production database physical design, exact batch/resource limits, or final portal technology;
- copy or anonymize production activity, application names, URLs, paths, accounts, device identifiers, addresses, credentials, SSH material, HR/directory records, or confidential reference values;
- infer business roles, entitlements, application ownership, purpose, sensitivity, URL/domain rules, matching rules, observed usage, or lifecycle from the sanitized catalogue;
- replace Windows/browser, crash, restore, network, scale, and operations experiments with prose;
- make UAM telemetry forensic proof or an employee-productivity score.

## 2.3 Accepted inputs

| Input | Accepted fact used here | Limitation carried forward |
|---|---|---|
| Accepted baseline [P1](#p1) | Endpoint/session architecture, minimization boundary, SQLite WAL/one-writer direction, atomic event/cursor invariant, at-least-once/idempotency, durable receipt semantics, realm isolation, synthetic-first Edge slice | Working implementation baseline, not unconditional production authority; many exact limits remain provisional |
| Sanitized catalogue profile [P2](#p2) | Counts and quality shapes listed in section 1.2 | No raw values and no semantic dimensions; no role mapping may be inferred |
| Data/schema summary [P3](#p3) | Target concepts are distinct; realm/device derive from authentication; receipt/validation/materialization/quarantine/visibility are separate; stable dedupe and provenance are required | No representative rate, byte, retry, outage, retention, query, RPO/RTO, or engine benchmark evidence |
| Research evidence rules [P4](#p4) | Evidence labels, current-primary-source preference, and prohibition on claiming runtime proof without CLI/lab work | Quality rules, not technical runtime evidence |

No accepted baseline decision is challenged by this result; no change proposal is required.

## 2.4 Assumptions

- **ASSUMPTION.** A repository can host a .NET CLI and JSON Schema files, with protected branches, code review, package lock files, and CI artifact retention controls.
- **ASSUMPTION.** Test environments can bind an authenticated harness context that is separate from untrusted payload claims, so realm/device derivation can be tested.
- **ASSUMPTION.** UAM can assign accountable roles such as Test Data Steward, Product Privacy Owner, Schema Owner, Endpoint Owner, Ingestion Owner, AppSec, SRE/DBA, Support Owner, and Incident Commander. Names are deliberately not invented.
- **ASSUMPTION.** The first implementation can target a currently supported .NET LTS line. As of 31 July 2026, Microsoft lists .NET 10 as active LTS, latest patch 10.0.10 dated 14 July 2026, with support through 14 November 2028; support requires staying current on patches. The architecture records the reviewed line but execution-time tooling pins the then-current servicing patch. [W1](#w1)
- **ASSUMPTION.** The test CLI can use a modern SQLite build, but it must report the actual native SQLite source ID rather than trust a managed package version string.

## 2.5 Unknowns that block production-shaped evidence, not G0 design

- **UNKNOWN.** Approved purposes, prohibited uses, identity level, application-name policy, role/persona authority, access ownership, and retention.
- **UNKNOWN.** Exact production event fields, time precision, first-run lookback, hard-deny categories, and matching rules.
- **UNKNOWN.** Real endpoint event/byte/batch/retry/outage distributions and resource budgets.
- **UNKNOWN.** Browser/Windows behavior across supported builds, VDI/session technologies, security products, proxy/VPN, sleep/resume, and lock modes.
- **UNKNOWN.** Production database engine, partition/index design, query corpus, capacity, SLO/RPO/RTO, and restore operations.
- **UNKNOWN.** Whether any real application name is permitted in T2 or T3. The conservative default is no.
- **UNKNOWN.** T3 retention and deletion authority. The conservative default is to collect nothing until a named owner and deletion trigger exist.

## 2.6 Research-date dependency posture

**FACT.** Microsoft’s official .NET policy dated 14 July 2026 lists .NET 10.0.10 as the current .NET 10 LTS patch and requires supported installations to remain current on patches. [W1](#w1)

**FACT.** SQLite’s official release history lists 3.53.4 dated 24 July 2026 with source ID `bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`. The history also records a WAL-reset corruption fix in 3.51.3 and again in 3.53.0. [W2](#w2) [W3](#w3)

**RECOMMENDATION.** Do not encode `.NET 10.0.10` or `SQLite 3.53.4` as timeless architecture. At each implementation/release gate, record the then-current supported versions, package hashes, native SQLite source ID, licenses, advisories, and regression results. A provider that cannot expose or validate its native SQLite version fails the G0/G5 dependency gate.

---

# 3. Recommended design with exact component responsibilities and trust boundaries

## 3.1 Context and trust boundaries

```text
                         UAM release-authorized privacy ceiling
                                           |
                                           v
+----------------------+     +------------------------------+
| T1 source repository | --> | Dataset Registry / Gatekeeper|<-- approved T2 metadata
+----------------------+     +---------------+--------------+        |
                                               |                      |
                                               v                      v
                                  +------------------------+   +------------------+
                                  | Deterministic Generator|   | Controlled T3    |
                                  | + Scenario Composer    |   | Measurement Lane |
                                  +-----------+------------+   +------------------+
                                              |
                                  package temp directory
                                              |
             +--------------------------------+--------------------------------+
             |                                |                                |
             v                                v                                v
+--------------------------+    +--------------------------+     +--------------------------+
| Independent Oracle       |    | Canary/Leak Scanner      |     | Harness Materializer     |
| and Truth Ledger         |    | exact + pattern + tools  |     | JSON/NDJSON -> SQLite    |
+------------+-------------+    +------------+-------------+     +-------------+------------+
             |                               |                                 |
             +-------------------------------+---------------------------------+
                                             |
                                      Approved package
                                             |
          +----------------------------------+----------------------------------+
          |                                  |                                  |
          v                                  v                                  v
  Endpoint/session tests              Ingestion/server tests             Portal/support tests
  (user boundary)                     (auth-derived realm/device)         (accessible reports)
          |                                  |                                  |
          +----------------------------- Actual evidence -----------------------+
                                             |
                                             v
                                    Reconciler / Evidence Pack
```

The diagram contains five explicit trust boundaries:

1. **Classification boundary.** Nothing enters generation until tier, provenance, owner, expected-result authority, and deletion method validate.
2. **Endpoint privacy boundary.** Raw source fixtures may exist only inside the authorized User Host or short-lived Task Host test boundary. Forbidden values must not cross to Coordinator IPC, endpoint SQLite, logs, diagnostics, or transport.
3. **User/session boundary.** Fixtures for one synthetic account/session must be inaccessible to another, even on one device.
4. **Realm boundary.** The harness supplies trusted authenticated realm/device context; payload claims are hostile and must not choose tenancy.
5. **Oracle independence boundary.** The oracle shares schemas and enumerated constants only through generated contract artifacts; it does not call production transformation, dedupe, cursor, receipt, or materialization code.

## 3.2 Exact component responsibilities

| Component | MUST do | MUST NOT do | Owner |
|---|---|---|---|
| Dataset Registry/Gatekeeper | Validate manifest, tier, provenance, owner, expiry/deletion, allowed sources, schemas, dependency lock, and approval state; issue immutable dataset revision ID | Infer a tier; default missing ownership; accept “temporary” unclassified files | Test Data Steward, with Product Privacy approval for T2/T3 |
| Deterministic Model Generator | Generate canonical entities from manifest + seed using the algorithm in section 6; emit lineage for every field | Use wall clock, locale defaults, machine randomness, `Guid.NewGuid()`, unordered iteration, or floating-point probability as canonical inputs | Test Architecture |
| Scenario Composer | Compose named, versioned scenario fragments as an acyclic graph; resolve conflicts deterministically; expose overrides | Mutate a base scenario implicitly; depend on file enumeration order | Test Architecture |
| Source-fixture adapters | Materialize browser/source-specific fictional databases/files inside isolated test profiles; declare source version and lock state | Copy live profile main/WAL/SHM files; access another user’s profile; place raw canaries outside scoped source fixture | Endpoint Test Owner |
| Independent Reference Oracle | Interpret declarative policy, privacy ceiling, source generation, cursor, batch, receipt, dedupe, and state rules; emit expected transitions | Reuse production decision functions; consult actual outputs while calculating truth | Separate Oracle Maintainer / Code Owner |
| Truth Ledger Writer | Emit one row per causal input and expected effect, including zero-effect/rejection/quarantine/defer rows and cursor before/after | Record only successful events; treat receipt as semantic acceptance | Oracle Maintainer |
| Package Canonicalizer/Hasher | NFC-normalize model inputs before serialization, validate I-JSON constraints, JCS-canonicalize JSON, hash every file, and emit package root hash | Normalize strings after JCS, include mutable timestamps, or hash OS-dependent paths | Build Engineering |
| Canary Registry and Scanner | Seed unique fictional markers; scan all declared sinks and artifacts; combine exact, pattern, secret, and optional offline PII detectors | Treat one tool as proof of absence; send artifacts to an external scanner; allow broad suppressions | Product Privacy + AppSec |
| Harness Materializer | Build ephemeral SQLite/source stores from canonical package; set required pragmas; record native engine source ID; make teardown idempotent | Commit generated databases; silently repair invalid fixtures; use production credentials | Test Infrastructure |
| Test Driver / Fault Injector | Execute declared sessions, locks, crashes, duplicates, outages, disk limits, restore, deletion, and replay schedules | Change scenario truth at runtime; hide unexecuted steps | Gate Owner |
| Actual-evidence Collector | Collect privacy-safe counters, stable error codes, state transitions, hashes, and timing; redact environment identifiers | Collect raw URLs, paths, account names, payload bodies, exception values, or unbounded labels | Observability Owner |
| Reconciler | Join actual to truth by stable synthetic IDs; report missing, extra, wrong-state, wrong-cursor, and canary leak results | Accept approximate matching for identity/state invariants | Test Architecture |
| Evidence Packager | Produce immutable summary, versions, hashes, environment facts, scan reports, reconciliation, cleanup/deletion evidence | Include secrets, internal addresses, raw activity, or SSH details | Gate Owner |
| Controlled Measurement Importer | Convert approved T3 aggregate measurements into parameter files with provenance and disclosure checks | Import row-level production activity or copy source values into fixtures | Data Steward + Privacy Owner |

## 3.3 Three-tier classification contract

### T1 — fully fictional committed fixtures

A T1 dataset MUST satisfy all of these conditions:

- every semantic value comes from a reviewed fictional vocabulary, deterministic derivation, or reserved example namespace;
- there is no source-derived row, token, free-text fragment, identifier, timestamp, frequency vector, rare combination, or ordering;
- domains use `.invalid`, `.test`, or documented example names; IP literals use TEST-NET ranges; e-mail-like values use an invalid/example domain; secret-shaped values are invalid by construction; [W8](#w8) [W9](#w9)
- organization, role, persona, and application labels make fictional status obvious, such as `Organization-Aster`, `Role-Citrine-Reader`, and `Aster Notes`;
- the manifest says `classification: T1-FICTIONAL-COMMITTED`;
- source control review and automated scanning both pass.

T1 may be retained with source history, subject to repository retention and license policy. Its owner still must provide a deletion method because generated CI artifacts and local test stores require cleanup.

### T2 — sanitized organization-shaped internal data

T2 may contain only approved structure such as counts, missingness, length buckets, quality categories, and bounded distributions. It MUST NOT contain a raw application name, URL/domain, process, publisher, owner, role, account, path, external ID, or activity. A T2 manifest additionally requires:

- source evidence identifier and profile date;
- transformation script/version and source hash known to the steward but not copied into public output unless approved;
- an explicit list of retained aggregates and rejected dimensions;
- re-identification/singling-out review;
- owner, access group, expiry, and deletion verification method;
- a proof that every generated row is fictional.

**Catalogue-shaped T2 profile.** The approved profile for this result may drive exactly these test assertions:

```yaml
recordCount: 173
caseInsensitiveUniqueNameCount: 173
missingNameCount: 0
missingExternalReferenceCount: 5
nonEmptyExternalReferenceCount: 168
duplicateNonEmptyExternalReferenceValueCount: 0
ipv4LikeNameCount: 1
nonAsciiNameCount: 10
possibleTruncationMarkerEndingCount: 9
```

The generator MUST select disjoint fictional row indexes for the non-ASCII, truncation-marker, and IPv4-like categories unless an explicitly versioned scenario tests overlap. That makes the measured counts transparent rather than accidentally dependent on vocabulary content. It MUST NOT generate role, entitlement, owner, purpose, lifecycle, matching rule, usage, or currentness from this profile. [P2](#p2)

### T3 — tightly controlled measured evidence

T3 is not a euphemism for pilot data. It is a separate, approved measurement lane. Permitted examples, subject to human approval, are aggregate batch byte histograms, collection-duration buckets, resource peaks, retry counts by stable error code, lock/defer counts, database page counts, and restore timing. Prohibited examples include raw URLs/domains, browser rows, account/device names, internal addresses, free-text exceptions, credentials, tokens, SSH material, or per-person activity.

T3 MUST have:

- a named measurement question and proof gate;
- minimum fields and aggregation threshold defined before collection;
- source/environment scope and legal/privacy approval reference;
- a collection owner and receiver;
- access list, encryption/handling requirements, expiry timestamp, and deletion command;
- a no-raw-value validation report;
- a derived-output review before any T2/T1 promotion.

**Conservative temporary default:** no T3 collection. A test that lacks approved measurements uses a clearly labeled replaceable estimate and cannot claim capacity or production fitness.

## 3.4 Canonical logical model

All realm-owned entities carry `realm_id`. IDs are synthetic stable identifiers, not payload authority. The server derives real realm/device context from authenticated registration as required by the accepted data principles. [P3](#p3)

| Entity | Purpose | Minimum relationships and invariants |
|---|---|---|
| `organization` | Fictional parent construct for test composition | Owns one or more realms; does not imply a legal or HR structure |
| `realm` | Isolation boundary | Every realm-owned ID is unique with its realm; cross-realm references fail closed |
| `role` | Fictional test grouping | Never presented as organizational truth; may be absent |
| `persona` | Scenario behavior template, not a person | References zero or more fictional roles; cannot contain direct identifiers |
| `account` | Synthetic local/directory-style subject handle | Belongs to one realm; identifier is not reusable across realms unless a collision scenario declares it |
| `device` | Synthetic managed endpoint | Belongs to one realm; payload realm/device claims are ignored by server tests |
| `installation` | Agent lifecycle instance | Distinguishes reinstall from stable device; version and release state are explicit |
| `session` | Eligible/ineligible interactive session | Binds one account, device, logon ID, start/end, integrity/token profile, and eligibility |
| `application` | UAM-owned canonical app record | Stable UAM ID; optional external reference; no inferred role or matching semantics |
| `policy_revision` | Product ceiling plus tenant narrowing for a scenario | Immutable; tenant policy cannot widen product ceiling |
| `source` | Browser or other source definition | Declares owner session, source type, profile, path token, and privacy class |
| `source_generation` | Reset/replacement boundary | New stable generation when source identity changes; cursors never bridge silently |
| `cursor`/`source_progress` | Last durably represented source position | Never advances ahead of durable minimized event/progress marker |
| `run` | One collector attempt | Records fixed start/end and stable error outcomes, not free-text errors |
| `event` | Minimized typed fact | Contains only authorized fields; stable dedupe key; source provenance |
| `batch` | Bounded versioned upload unit | Contains event references and payload hash; retry-safe identity |
| `receipt` | Durable-custody acknowledgement | Does not imply validation/materialization/visibility |
| `inbox_item` | Server durable acceptance state | States separate receipt, validation, quarantine, materialization, visibility |
| `audit_record` | Privileged test mutation evidence | Immutable, causal ID, actor class, action code, before/after digests |
| `deletion_case` | Erasure/expiry scenario | Scope, tombstone, completion, restore behavior, and evidence |
| `migration_case` | Schema/data compatibility scenario | Source/target schema versions, compatibility mode, expected loss or rejection |
| `expected_result` | Oracle verdict for one input/effect | Includes outcome, state, stable error, cursor before/after, and expected sink presence |
| `lineage_record` | Field/file provenance | Generator version, seed stream, scenario, source classification, transform, parent digest |

## 3.5 Configuration ownership, feature flags, and kill switches

- The **Product Privacy Owner** owns the release-authorized privacy ceiling. A test flag MUST NOT add a source or field outside it.
- The **Tenant Policy Owner** may define fictional narrowing scenarios only. A widening request is rejected as `PRV-CEILING-WIDEN-001`.
- The **Schema Owner** owns schema IDs, compatibility declarations, migrations, and deprecation windows.
- The **Test Data Steward** owns classification, provenance, access, expiry, and deletion approval.
- The **Gate Owner** owns scenario activation and evidence acceptance for a proof gate.
- Feature flags are explicit manifest values, never environment-dependent defaults. A missing flag is an error when it affects privacy, source access, cursor behavior, release authorization, or deletion.
- Kill switches are release-authorized, realm-scoped where applicable, auditable, monotonic toward less collection, safe offline, and tested for stale policy, rollback, and restart. A kill switch may stop collection or upload; it may not delete unacknowledged data silently.

## 3.6 Error taxonomy

Errors are stable codes plus bounded attributes. Human-readable messages are templates and MUST NOT interpolate source values.

| Family | Meaning | Example codes |
|---|---|---|
| `TDG` | generator/composition | `TDG-SEED-001`, `TDG-CONFLICT-002`, `TDG-ID-COLLISION-003` |
| `CLS` | classification/approval | `CLS-MISSING-001`, `CLS-OWNER-002`, `CLS-EXPIRED-003` |
| `LIN` | lineage/provenance | `LIN-PARENT-001`, `LIN-DIGEST-002` |
| `SCH` | schema/compatibility | `SCH-UNKNOWN-001`, `SCH-DOWNGRADE-002`, `SCH-MIGRATION-003` |
| `PRV` | privacy ceiling/minimization | `PRV-FORBIDDEN-001`, `PRV-CANARY-002`, `PRV-CEILING-WIDEN-003` |
| `BND` | user/session/realm boundary | `BND-SESSION-001`, `BND-REALM-002`, `BND-AUTH-CONTEXT-003` |
| `SRC` | source access/generation/lock | `SRC-LOCKED-001`, `SRC-DEFERRED-002`, `SRC-GENERATION-003` |
| `CUR` | cursor/progress | `CUR-AHEAD-001`, `CUR-REGRESS-002`, `CUR-GAP-003` |
| `BAT` | batch/envelope | `BAT-LIMIT-001`, `BAT-HASH-002`, `BAT-VERSION-003` |
| `RCPT` | durable receipt | `RCPT-PREMATURE-001`, `RCPT-MISMATCH-002` |
| `INB` | durable inbox/worker | `INB-LEASE-001`, `INB-POISON-002`, `INB-STATE-003` |
| `DUP` | dedupe/idempotency | `DUP-EVENT-001`, `DUP-BATCH-002` |
| `QTN` | quarantine | `QTN-SCHEMA-001`, `QTN-PRIVACY-002`, `QTN-POISON-003` |
| `DEL` | deletion | `DEL-SCOPE-001`, `DEL-RESTORE-002`, `DEL-EVIDENCE-003` |
| `MIG` | migration | `MIG-COMPAT-001`, `MIG-LOSS-002` |
| `OBS` | observability/cardinality | `OBS-FORBIDDEN-LABEL-001`, `OBS-CARDINALITY-002` |
| `REP` | reproducibility/reconciliation | `REP-HASH-001`, `REP-TRUTH-002`, `REP-ENV-003` |

## 3.7 Privacy-safe observability and metric cardinality

**RECOMMENDATION.** Metrics may use only bounded labels such as `component`, `operation`, `result_code_family`, `schema_major`, `dataset_id`, and `gate`, where each label has a reviewed finite value set. They MUST NOT label by realm, organization, account, device, installation, session, event, batch, URL/domain, application name/ID, source path, exception text, seed, or free-form policy ID. OpenTelemetry documents that unique attribute combinations create metric streams and memory use; its SDK limits are a safety net, not permission to emit high-cardinality identifiers. Prometheus likewise advises against unbounded labels. [W15](#w15) [W16](#w16)

Logs and traces carry synthetic correlation IDs only in the test environment and use stable code templates. The canary scanner scans logs, trace exports, metric exposition, test-result attachments, crash artifacts, SQLite dumps, HTTP captures, and console output. OWASP logging guidance is used as a security checklist, but UAM’s product privacy ceiling is stricter where they differ. [W14](#w14)

Suggested bounded metrics:

```text
uam_test_scenario_runs_total{gate,component,result}
uam_test_oracle_mismatches_total{gate,mismatch_kind}
uam_test_canary_findings_total{sink,rule_id}
uam_test_cursor_transitions_total{gate,result}
uam_test_fixture_bytes{dataset_size_class,file_kind}
uam_test_operation_duration_seconds{gate,operation,result}
```

The configuration linter rejects any unknown label key. A cardinality budget is a **HUMAN DECISION** owned by Observability/SRE; until set, the conservative gate is that a single T1 smoke run produces no more series than the static Cartesian product declared in `metrics-allowlist.json`, with no overflow series.

## 3.8 Secure coding, review, and supply-chain controls

- Apply NIST SSDF 1.1 practices to the test-data toolchain: protected source, reviewed changes, reproducible builds where practical, dependency inventory, vulnerability handling, and release provenance. [W10](#w10)
- Separate generator and oracle projects, maintainers, and code-owner approval paths.
- Pin package versions and hashes in lock files. Floating GitHub Action tags and unpinned tool downloads fail CI.
- Use analyzers with warnings as errors for nullability, culture-sensitive conversion, insecure randomness misuse, path traversal, process invocation, serialization, and SQL parameterization.
- All SQL is parameterized. Fixture text is treated as hostile even when fictional.
- Generated source fixtures run in ephemeral directories with ACLs scoped to the test account/session; teardown verifies removal.
- Fuzzing runs in a sandbox with CPU, memory, time, file, and network limits. Crash inputs are classified T1 unless a steward proves otherwise.
- A dependency may be test-only, reference-only, or rejected; no reviewed repository becomes a dependency merely through popularity.

## 3.9 Incident response and support ownership

A canary leak, unexpected non-fictional value, cross-realm/session access, unowned T3 artifact, or deletion failure is a privacy/security incident candidate, not an ordinary flaky test.

Minimum runbooks:

1. **Fixture contamination:** stop publication, revoke package revision, quarantine artifacts, identify lineage parent, scan repository/history/build caches, rotate any exposed real secret, delete under evidence, and open an incident record.
2. **Canary escaped endpoint boundary:** activate collection kill switch for affected source/release, preserve privacy-safe evidence, block release, identify sink and transformation stage, add regression case, clean all test stores.
3. **Oracle disagreement:** freeze the disputed dataset revision, triage implementation and oracle independently, use a hand-worked minimal case, run mutation tests, and issue a schema/ADR change only after root cause.
4. **T3 expiry/owner lapse:** deny access and further processing, execute deletion, verify backups/cache behavior, and require re-approval before recollection.
5. **Dependency compromise/advisory:** block restores/builds using the digest, verify SBOM/lockfiles, select patched version or remove tool, and rerun reproducibility/scanner/oracle gates.

Support owns documented commands and interpretation, not manual fixture edits. Any support workaround becomes a versioned scenario or runbook change with review.

## 3.10 Cost, licensing, skills, operations, and accessibility

**RECOMMENDATION.** Build the canonical path with .NET base libraries plus a small reviewed JSON canonicalization implementation or package selected at execution time. SQLite and JSON files are already consistent with the wider architecture; no paid synthetic-data platform is justified at G0.

Operational cost drivers are CI storage, Windows runners, 6,000-device synthetic scale runs, fuzz CPU, optional NLP scanner dependencies, and human stewardship. These must be measured rather than hidden in a tool choice. Test-only dependencies in section 14 use permissive licenses, but notices, transitive licenses, provenance, vulnerability response, and organizational policy still require review.

Skills required:

- C#/.NET and deterministic/pure-function design;
- SQLite transactions/WAL and fault injection;
- Windows sessions, ACLs, browser SQLite behavior, and process isolation;
- model/property-based testing and fuzzing;
- privacy engineering, data lineage, and incident response;
- CI artifact governance and accessible reporting.

The CLI output must be keyboard-operable, machine-readable, and understandable without color. Text reports use headings, tables, explicit `PASS`/`FAIL`, and non-color symbols. Any web report targets WCAG 2.2 AA; native/non-web reports use WCAG2ICT guidance where applicable. [W11](#w11) [W12](#w12)

# 4. Alternatives, rejection reasons, and conditions that would change the choice

| Alternative | Decision | Why rejected now | Evidence or condition that would change the decision |
|---|---|---|---|
| Copy or subset production activity into test | Reject | Violates minimization and synthetic-first baseline; introduces personal/confidential values, weak deletion, and uncontrolled downstream copies; production shape is not the same as approved test purpose | No foreseeable G0 condition. A later controlled evidence proposal would still use aggregate metadata, not row-level activity |
| “Anonymize” row-level production data | Reject | Pseudonymization does not make data anonymous; rare combinations, timestamps, paths, URLs, and behavior can allow singling out. No need is proven | A separate privacy/legal decision, formal disclosure-risk analysis, approved purpose, isolated controls, and proof that synthetic/aggregate evidence cannot answer the question. This would be a new ADR, not a quiet G0 extension |
| Use the raw internal application catalogue as a fixture | Reject | Raw values are deliberately absent from supplied evidence; catalogue semantics are unproved; one source-like value already has an IPv4-like pattern | Human approval for specifically named internal values, owner/access/retention, and a T2/T3 governance decision. Even then, no role mapping may be inferred |
| Use one off-the-shelf faker as the canonical generator | Reject | Library versions, locales, rule order, and implementation changes can change sequences; “realistic” names/addresses increase accidental resemblance; generator cannot also be the contractual oracle | May be accepted as a pinned test-only helper for peripheral T1 text after a determinism/provenance prototype. Canonical IDs, clocks, distributions, and truth remain UAM-owned |
| Use `System.Random`, a GUID API, current time, or cryptographic RNG for canonical fixtures | Reject | Runtime/library changes, order dependence, concurrency, and wall clock break reproducibility. Cryptographic unpredictability is unnecessary because seeds are non-secret | None for canonical packages. Randomized exploratory/fuzz tests may use separate recorded seeds and must emit a minimized reproducer |
| Use UUIDv4 for all IDs | Reject | Random IDs obscure natural-key lineage and make regenerated packages differ | A standard deterministic UUID profile could replace the current prefixed digest representation only if collision, readability, cross-language, and migration tests pass and an ADR is accepted. RFC 9562 is a design input, not a requirement [W6](#w6) |
| Use production transformation/dedupe code to generate expected results | Reject | Common-mode defects would be blessed as truth; actual output could influence expectation | Shared generated schema constants and enum definitions are allowed. Any additional shared logic requires mutation evidence showing the oracle still detects deliberately seeded production defects |
| Snapshot/golden-file testing only | Reject | Good for serialization drift but weak for state, rejection, cursor, duplicate, crash, and realm properties; snapshots can be updated without understanding | Retain as one layer for canonical package bytes, never the sole oracle |
| Property-based testing only | Reject | Excellent for general properties and shrinking, but does not by itself provide approved fixtures, lineage, classification, deletion, or end-to-end truth | Use as a complementary test-only layer with recorded seeds and minimized counterexamples |
| Model-based framework as the production test contract | Reject for G0 | Adds framework semantics and potentially another runtime; library state models may be unstable or unsupported; UAM’s state space is small enough for a pure C# interpreter | Reconsider after a hand-built model becomes unmaintainable and a proof-of-fit shows deterministic replay, stable API, license/security acceptance, and lower total operational cost |
| Commit generated SQLite databases | Reject | Binary diffs are opaque; WAL/engine differences can create nondeterminism; stale generated stores can outlive source review | Allow immutable generated DBs only as short-lived CI evidence with source package hash and deletion policy. Canonical source remains JSON/NDJSON |
| Store fixture packages in a central test-data service | Reject now | Adds availability, credentials, tenancy, operations, backup, and deletion complexity before a need is measured | Reconsider when repository/artifact size, concurrent reuse, access auditing, or T2/T3 isolation cannot be met by simpler stores and a threat/cost model supports a service |
| Generate truth from statistical similarity to actual output | Reject | A probabilistic match cannot prove security, privacy, cursor, receipt, or dedupe invariants | Statistical tests may validate declared distributions but never replace exact state truth |
| Differentially private synthetic-data model | Not selected | Differential privacy can help release aggregate statistics, but selecting privacy parameters, contribution bounds, utility, and threat model is a human/governance problem. It does not solve deterministic state oracles | Consider only for an approved T3-to-T2 aggregate publication problem with specialist review; do not introduce it merely to make fixtures look realistic [W13](#w13) |
| Machine-learned PII detector as sole privacy gate | Reject | False negatives are unavoidable and context/language/model dependencies add uncertainty; Presidio itself warns it cannot guarantee detection of all sensitive data | May be an offline secondary detector after exact canaries and deterministic rules; model/version, downloads, false-negative corpus, privacy, and operations must be pinned and tested |
| One scanner such as Gitleaks as sole leak gate | Reject | Secret scanners target known patterns, not UAM-specific forbidden fields, behavioral data, realm leaks, or all PII | Use as a pinned second layer with UAM exact markers and schema-aware sink checks |
| Exact 6,000-device synthetic run as proof of production capacity | Reject as a claim | Device count alone says nothing about event rate, bytes, retry/outage distribution, database query mix, hardware, or SLO | Use it as a structural/concurrency smoke test. Capacity claims require approved measured inputs, identical benchmark definitions, and operations/restore evidence |

**RECOMMENDATION.** Change the selected architecture only through an ADR that identifies the affected invariant, new primary evidence, smallest falsifying experiment, migration effect, privacy/security impact, and rollback path. Tool convenience or popularity is not a change trigger.

---

# 5. Interfaces/protocols and example contracts or schemas

## 5.1 Normative package layout

A dataset revision MUST be immutable and self-contained. Canonical relative paths use `/`, UTF-8, NFC model strings, and LF line endings. The package MUST reject path traversal, absolute paths, device names, alternate data streams, symlinks/reparse points, and case-colliding paths.

```text
dataset/
  manifest.json
  approvals/
    classification.json
    privacy-review.json              # required for T2/T3
  model/
    organizations.ndjson
    realms.ndjson
    roles.ndjson
    personas.ndjson
    persona-roles.ndjson
    accounts.ndjson
    devices.ndjson
    installations.ndjson
    sessions.ndjson
    applications.ndjson
    policies.ndjson
    sources.ndjson
    source-generations.ndjson
    runs.ndjson
    source-inputs.ndjson
    events.ndjson
    batches.ndjson
    batch-events.ndjson
    receipts.ndjson
    inbox-items.ndjson
    audits.ndjson
    deletions.ndjson
    migrations.ndjson
  scenarios/
    composition.json
    steps.ndjson
    faults.ndjson
  source-fixtures/
    edge/<fixture-id>/...
  truth/
    expected-results.ndjson
    cursor-ledger.ndjson
    state-transitions.ndjson
    expected-metrics.json
  canaries/
    corpus.ndjson
    rules.json
    allowlist.json
  lineage/
    records.ndjson
  schemas/
    manifest.schema.json
    model/*.schema.json
    truth/*.schema.json
  reports/                              # generated, not canonical input
  hashes.sha256
  package-root.json
```

`reports/` and generated SQLite files are not part of the canonical input hash unless an evidence pack explicitly creates a second signed root. This avoids mixing expected input with actual execution output.

## 5.2 Manifest contract

The complete implementation schema belongs in `schemas/manifest.schema.json`. The following is the normative minimum. Unknown properties fail by default; extensions require a namespaced key and declared schema.

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.uam.example.invalid/test-data/manifest/v1",
  "title": "UAM deterministic dataset manifest v1",
  "type": "object",
  "additionalProperties": false,
  "required": [
    "formatVersion", "datasetId", "revision", "title", "classification",
    "proofGates", "ownerRole", "provenance", "expectedResultAuthority",
    "deletion", "seed", "clock", "generator", "oracle", "schemas",
    "scenarioComposition", "privacyCeilingRevision", "featureFlags"
  ],
  "properties": {
    "formatVersion": {"const": "uam.testdata.manifest/1"},
    "datasetId": {"type": "string", "pattern": "^ds_[a-z2-7]{26}$"},
    "revision": {"type": "integer", "minimum": 1},
    "title": {"type": "string", "minLength": 1, "maxLength": 120},
    "classification": {
      "enum": [
        "T1-FICTIONAL-COMMITTED",
        "T2-SANITIZED-ORG-SHAPED",
        "T3-CONTROLLED-MEASURED-EVIDENCE"
      ]
    },
    "proofGates": {
      "type": "array", "minItems": 1, "uniqueItems": true,
      "items": {"enum": ["G0","G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"]}
    },
    "ownerRole": {"type": "string", "pattern": "^[A-Z][A-Za-z0-9 -]{2,79}$"},
    "approvalIds": {
      "type": "array", "uniqueItems": true,
      "items": {"type": "string", "pattern": "^apr_[a-z2-7]{26}$"}
    },
    "provenance": {
      "type": "object", "additionalProperties": false,
      "required": ["kind", "description", "parentDigests"],
      "properties": {
        "kind": {"enum": ["fictional", "sanitized-aggregate", "controlled-measurement"]},
        "description": {"type": "string", "maxLength": 500},
        "parentDigests": {
          "type": "array", "uniqueItems": true,
          "items": {"type": "string", "pattern": "^sha256:[0-9a-f]{64}$"}
        },
        "profiledAt": {"type": "string", "format": "date-time"},
        "transformationId": {"type": "string", "maxLength": 120}
      }
    },
    "expectedResultAuthority": {
      "type": "object", "additionalProperties": false,
      "required": ["oracleContract", "codeOwnerRole"],
      "properties": {
        "oracleContract": {"type": "string", "pattern": "^uam\\.oracle/[1-9][0-9]*$"},
        "codeOwnerRole": {"type": "string", "maxLength": 80}
      }
    },
    "deletion": {
      "type": "object", "additionalProperties": false,
      "required": ["method", "verification", "artifactScope"],
      "properties": {
        "expiresAt": {"type": ["string", "null"], "format": "date-time"},
        "method": {"type": "string", "maxLength": 300},
        "verification": {"type": "string", "maxLength": 300},
        "artifactScope": {"type": "array", "minItems": 1, "items": {"type": "string"}}
      }
    },
    "seed": {
      "type": "object", "additionalProperties": false,
      "required": ["algorithm", "value"],
      "properties": {
        "algorithm": {"const": "SHA-256-domain-separated-v1"},
        "value": {"type": "string", "pattern": "^(text:|hex:)[A-Za-z0-9._~:+/-]{1,256}$"}
      }
    },
    "clock": {
      "type": "object", "additionalProperties": false,
      "required": ["kind", "origin", "tickUnit", "timezone"],
      "properties": {
        "kind": {"const": "fixed-logical-v1"},
        "origin": {"type": "string", "format": "date-time"},
        "tickUnit": {"enum": ["second", "millisecond", "microsecond"]},
        "timezone": {"const": "UTC"}
      }
    },
    "generator": {
      "type": "object", "additionalProperties": false,
      "required": ["contract", "toolVersion", "sourceRevision", "dependencyLockDigest"],
      "properties": {
        "contract": {"const": "uam.generator/1"},
        "toolVersion": {"type": "string"},
        "sourceRevision": {"type": "string"},
        "dependencyLockDigest": {"type": "string", "pattern": "^sha256:[0-9a-f]{64}$"}
      }
    },
    "oracle": {
      "type": "object", "additionalProperties": false,
      "required": ["contract", "toolVersion", "sourceRevision", "rulesDigest"],
      "properties": {
        "contract": {"const": "uam.oracle/1"},
        "toolVersion": {"type": "string"},
        "sourceRevision": {"type": "string"},
        "rulesDigest": {"type": "string", "pattern": "^sha256:[0-9a-f]{64}$"}
      }
    },
    "schemas": {
      "type": "array", "minItems": 1,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["id", "digest"],
        "properties": {
          "id": {"type": "string", "format": "uri"},
          "digest": {"type": "string", "pattern": "^sha256:[0-9a-f]{64}$"}
        }
      }
    },
    "scenarioComposition": {
      "type": "array", "minItems": 1,
      "items": {
        "type": "object", "additionalProperties": false,
        "required": ["scenarioId", "revision", "parametersDigest"],
        "properties": {
          "scenarioId": {"type": "string", "pattern": "^scn_[a-z2-7]{26}$"},
          "revision": {"type": "integer", "minimum": 1},
          "parametersDigest": {"type": "string", "pattern": "^sha256:[0-9a-f]{64}$"}
        }
      }
    },
    "privacyCeilingRevision": {"type": "string", "pattern": "^pcr_[a-z2-7]{26}$"},
    "featureFlags": {
      "type": "object",
      "propertyNames": {"pattern": "^test\\.[a-z][a-z0-9.-]{1,80}$"},
      "additionalProperties": {"type": ["boolean", "integer", "string"]}
    },
    "notes": {"type": "string", "maxLength": 2000}
  },
  "allOf": [
    {
      "if": {"properties": {"classification": {"const": "T1-FICTIONAL-COMMITTED"}}},
      "then": {"properties": {"provenance": {"properties": {"kind": {"const": "fictional"}}}}}
    },
    {
      "if": {"properties": {"classification": {"enum": ["T2-SANITIZED-ORG-SHAPED", "T3-CONTROLLED-MEASURED-EVIDENCE"]}}},
      "then": {"required": ["approvalIds"], "properties": {"approvalIds": {"minItems": 1}}}
    }
  ]
}
```

The schema uses JSON Schema Draft 2020-12. Validators and their conformance tests must be pinned because a schema document alone does not prove implementation conformance. [W4](#w4)

## 5.3 Example fictional manifest

```json
{
  "formatVersion": "uam.testdata.manifest/1",
  "datasetId": "ds_jx2f4e7gmrw3h5qbn6ytkacpzu",
  "revision": 1,
  "title": "G4 Edge privacy ceiling and canary containment",
  "classification": "T1-FICTIONAL-COMMITTED",
  "proofGates": ["G0", "G4"],
  "ownerRole": "Test Data Steward",
  "approvalIds": [],
  "provenance": {
    "kind": "fictional",
    "description": "All values generated from reviewed fictional vocabularies and reserved namespaces.",
    "parentDigests": []
  },
  "expectedResultAuthority": {
    "oracleContract": "uam.oracle/1",
    "codeOwnerRole": "Oracle Maintainer"
  },
  "deletion": {
    "expiresAt": null,
    "method": "Delete generated work directories and CI evidence artifacts by dataset revision.",
    "verification": "Cleanup command returns zero remaining paths and records artifact-store deletion receipt.",
    "artifactScope": ["work/**", "artifacts/g4/**", "test-results/**"]
  },
  "seed": {
    "algorithm": "SHA-256-domain-separated-v1",
    "value": "text:uam-g4-canary-ceiling-v1"
  },
  "clock": {
    "kind": "fixed-logical-v1",
    "origin": "2042-03-04T05:06:07Z",
    "tickUnit": "millisecond",
    "timezone": "UTC"
  },
  "generator": {
    "contract": "uam.generator/1",
    "toolVersion": "1.0.0",
    "sourceRevision": "git:REPLACE_AT_BUILD",
    "dependencyLockDigest": "sha256:REPLACE_WITH_64_HEX"
  },
  "oracle": {
    "contract": "uam.oracle/1",
    "toolVersion": "1.0.0",
    "sourceRevision": "git:REPLACE_AT_BUILD",
    "rulesDigest": "sha256:REPLACE_WITH_64_HEX"
  },
  "schemas": [
    {
      "id": "https://schemas.uam.example.invalid/test-data/event/v1",
      "digest": "sha256:REPLACE_WITH_64_HEX"
    }
  ],
  "scenarioComposition": [
    {
      "scenarioId": "scn_ry6u2m7qjg4d5he9wx3pkncvaz",
      "revision": 1,
      "parametersDigest": "sha256:REPLACE_WITH_64_HEX"
    }
  ],
  "privacyCeilingRevision": "pcr_b5k7s2m9x4j6q3w8ndhytvcear",
  "featureFlags": {
    "test.edge.site-level-output": true,
    "test.upload.enabled": true,
    "test.raw-source-diagnostics": false
  }
}
```

`REPLACE_AT_BUILD` placeholders are illegal in a published revision. They are shown only to distinguish authoring from publication.

## 5.4 Identifier, string, number, and time contracts

- IDs use `<type-prefix>_<base32lower(first-20-bytes(SHA-256(derivation-input)))>` and therefore carry 160 derived bits in the visible ID. The complete 32-byte digest is retained in lineage for collision detection.
- Prefixes include `org`, `rlm`, `rol`, `per`, `acc`, `dev`, `ins`, `ses`, `app`, `pol`, `src`, `gen`, `run`, `evt`, `bat`, `rcp`, `aud`, `del`, `mig`, `exp`, `lin`, `ds`, and `scn`.
- The generator rejects any visible-ID collision whose full digest differs. It also rejects duplicate natural keys before truncation.
- All semantic strings are validated Unicode scalar sequences and normalized to NFC at model ingress. Source-fixture fuzz bytes may deliberately be malformed but are stored as base64 with an explicit encoding/error scenario; they are not silently decoded.
- No canonical decision uses current culture, locale collation, case folding, or filesystem ordering. Where case-insensitive uniqueness is a scenario requirement, use an explicit versioned comparison profile; do not assume Windows or database collation semantics.
- Canonical distributions use non-negative integers and exact integer weights. Floating-point values are prohibited in manifests and truth where they affect decisions; use scaled integers or decimal strings.
- Instants use RFC 3339-compatible UTC strings in JSON and signed 64-bit epoch microseconds in SQLite. The fixture declares precision. This does not decide production precision.
- Logical sequence and source position are separate from wall time. Equal timestamps are valid and must not become implicit order.

## 5.5 Logical schemas and fictional records

The records below are examples, not an approved business taxonomy. Names are deliberately fictional.

### Organization, realm, role, persona, and account

```jsonl
{"organizationId":"org_r6t3p2e7m5w9k4d8hyqjncazvu","displayName":"Organization-Aster","fictional":true}
{"realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","organizationId":"org_r6t3p2e7m5w9k4d8hyqjncazvu","displayName":"Realm-Aster-Blue","fictional":true}
{"roleId":"rol_x5m2r8q7d4h9k3w6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","label":"Role-Citrine-Reader","semanticStatus":"fictional-test-group-only"}
{"personaId":"per_g8q3m5w2d9k7h4x6ynjpcvtzra","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","label":"Persona-Aster-Shared-Session","behaviorProfile":"shared-device-two-interactive-sessions","fictional":true}
{"accountId":"acc_p4w8m2q7d5k9h3x6ynjrcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","personaId":"per_g8q3m5w2d9k7h4x6ynjpcvtzra","accountKind":"synthetic-local","subjectToken":"SUBJECT-FICTION-0001","fictional":true}
```

### Device, installation, and session

```jsonl
{"deviceId":"dev_m7q2d9w4k5h8x3r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","deviceLabel":"Device-Kestrel-0001","platform":"windows","fictional":true}
{"installationId":"ins_h3w7m5q2d9k4x8r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","deviceId":"dev_m7q2d9w4k5h8x3r6ynjpcvtzba","releaseId":"release-fixture-1","installedAt":"2042-03-04T04:00:00Z","state":"active"}
{"sessionId":"ses_d8m3q7w2k5h9x4r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","deviceId":"dev_m7q2d9w4k5h8x3r6ynjpcvtzba","accountId":"acc_p4w8m2q7d5k9h3x6ynjrcvtzba","logonSequence":17,"sessionKind":"interactive","eligible":true,"startedAt":"2042-03-04T05:00:00Z","endedAt":null}
```

### Application catalogue examples

```jsonl
{"applicationId":"app_q7m3d9w5k2h8x4r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","displayName":"Aster Notes","externalReference":"EXT-FICTION-0001","qualityTags":[]}
{"applicationId":"app_w4m8d2q7k5h9x3r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","displayName":"Élan Viewer","externalReference":"EXT-FICTION-0002","qualityTags":["non-ascii"]}
{"applicationId":"app_k5m2d8q7w4h9x3r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","displayName":"NOVA…","externalReference":null,"qualityTags":["non-ascii","possible-truncation-marker"]}
{"applicationId":"app_x8m4d2q7w5h9k3r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","displayName":"198.51.100.42 Console","externalReference":"EXT-FICTION-0004","qualityTags":["ipv4-like"]}
```

The external reference is optional and never participates alone in the UAM primary ID. The 173-record catalogue-shaped dataset has a generated assertion file proving the exact safe profile counts.

### Policy and source records

```jsonl
{"policyRevisionId":"pol_m6q3d8w2k5h9x4r7ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","productCeilingRevision":"pcr_b5k7s2m9x4j6q3w8ndhytvcear","tenantRevision":"tenant-fictional-narrow-1","sourceType":"edge-history","allowedOutputFields":["siteKey","observedBucket","sourceGenerationId"],"forbiddenSourceParts":["urlUserInfo","path","query","fragment","title"],"transformation":"site-key-v1","status":"active"}
{"sourceId":"src_r4m8d3q7w5h9k2x6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","sessionId":"ses_d8m3q7w2k5h9x4r6ynjpcvtzba","sourceType":"edge-history","profileToken":"PROFILE-FICTION-01","pathToken":"PATH-TOKEN-EDGE-HISTORY","ownerBoundary":"user-session","privacyClass":"raw-source-fixture"}
{"sourceGenerationId":"gen_t7m3d9q5w2h8k4x6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","sourceId":"src_r4m8d3q7w5h9k2x6ynjpcvtzba","generationOrdinal":1,"fingerprint":"sha256:45b2f91b8b855c96793c36bc620a891ca2c49008056c17afca2eefc20b7c0581","createdAt":"2042-03-04T05:00:01Z"}
```

### Raw source input and minimized event

Raw source inputs stay in `source-inputs.ndjson` or source-specific fixtures and are classified as authorized test-source material. The event contains no raw URL.

```jsonl
{"inputId":"inp_j4m8d2q7w5h9k3x6ynrpcvtzba","sourceGenerationId":"gen_t7m3d9q5w2h8k4x6ynjpcvtzba","sourcePosition":41,"observedAt":"2042-03-04T05:05:02.123Z","rawUrl":"https://user-CANARY-URLUSERINFO-0001:pass-CANARY-URLPASS-0001@portal.example.invalid/private/CANARY-PATH-0001?q=CANARY-QUERY-0001#CANARY-FRAGMENT-0001","rawTitle":"CANARY-TITLE-0001","expectedPrivacyDisposition":"minimize"}
{"eventId":"evt_f8m3d7q2w5h9k4x6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","deviceId":"dev_m7q2d9w4k5h8x3r6ynjpcvtzba","sessionId":"ses_d8m3q7w2k5h9x4r6ynjpcvtzba","sourceGenerationId":"gen_t7m3d9q5w2h8k4x6ynjpcvtzba","sourcePosition":41,"eventType":"edge-site-observation","siteKey":"portal.example.invalid","observedBucket":"2042-03-04T05:00:00Z/PT15M","policyRevisionId":"pol_m6q3d8w2k5h9x4r7ynjpcvtzba","dedupeKey":"dedupe:v1:3ef5e7f753ad1118c7885f99bcb3ce5544f91027b98fa15995db4c12ec8af6f0"}
```

### Batch, receipt, inbox, and audit

```jsonl
{"batchId":"bat_n7m3d8q2w5h9k4x6ynjpcvtzba","schemaVersion":"uam.batch/1","installationId":"ins_h3w7m5q2d9k4x8r6ynjpcvtzba","sequence":12,"createdAt":"2042-03-04T05:06:00Z","eventCount":1,"uncompressedBytes":512,"contentEncoding":"gzip","payloadDigest":"sha256:0e2c42625b4b88bc82f81a94d52dfc1b19665ddfd5c93d9a72a02ae9d418a443"}
{"batchId":"bat_n7m3d8q2w5h9k4x6ynjpcvtzba","eventId":"evt_f8m3d7q2w5h9k4x6ynjpcvtzba","ordinal":0}
{"receiptId":"rcp_q8m3d7w2k5h9x4r6ynjpcvtzba","batchId":"bat_n7m3d8q2w5h9k4x6ynjpcvtzba","durableCustodyAt":"2042-03-04T05:06:01Z","failureDomain":"inbox-primary-commit","semanticStatus":"not-yet-evaluated","receiptDigest":"sha256:e96650aa2a85c8103dbce73a7aa481e7e95f3bd8477cd769e51dd6820871b54f"}
{"inboxItemId":"inb_m8q3d7w2k5h9x4r6ynjpcvtzba","batchId":"bat_n7m3d8q2w5h9k4x6ynjpcvtzba","state":"materialized","validatedAt":"2042-03-04T05:06:02Z","materializedAt":"2042-03-04T05:06:03Z","visibleAt":"2042-03-04T05:06:04Z","quarantineCode":null}
{"auditId":"aud_w7m3d8q2k5h9x4r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","actorClass":"synthetic-admin","actionCode":"POLICY_REVISION_ACTIVATE","targetType":"policyRevision","targetId":"pol_m6q3d8w2k5h9x4r7ynjpcvtzba","beforeDigest":"sha256:0000000000000000000000000000000000000000000000000000000000000000","afterDigest":"sha256:a4ad4a4e84bcfa67a9a4e1ae91ebf176f3ca6fc18cc2e4271e50802b472af06b","occurredAt":"2042-03-04T04:59:00Z","causalId":"cause-fixture-0001"}
```

### Deletion and migration

```jsonl
{"deletionCaseId":"del_q5m8d2w7k3h9x4r6ynjpcvtzba","realmId":"rlm_b9d4x7q2m6k3w8h5ynjpcvtzra","scopeType":"synthetic-account","scopeId":"acc_p4w8m2q7d5k9h3x6ynjrcvtzba","requestedAt":"2042-03-05T00:00:00Z","expectedTerminalState":"deleted-not-visible","restoreRule":"tombstone-dominates-restored-snapshot","evidenceMethod":"query-zero-visible-plus-tombstone-and-audit"}
{"migrationCaseId":"mig_d7m3q8w2k5h9x4r6ynjpcvtzba","fromSchema":"uam.event/1","toSchema":"uam.event/2","inputFixture":"event-v1-edge-site-001","compatibility":"forward-reader-required","expectedOutcome":"accepted-and-upconverted","lossAllowed":false}
```

### Expected-result and cursor-ledger records

```jsonl
{"expectedResultId":"exp_k8m3d7q2w5h9x4r6ynjpcvtzba","causalInputId":"inp_j4m8d2q7w5h9k3x6ynrpcvtzba","gate":"G4","expectedOutcome":"accepted","expectedErrorCode":null,"expectedEventId":"evt_f8m3d7q2w5h9k4x6ynjpcvtzba","expectedBatchId":"bat_n7m3d8q2w5h9k4x6ynjpcvtzba","expectedReceiptState":"durable-custody","expectedInboxState":"materialized","expectedVisibility":"visible","cursorBefore":40,"cursorAfter":41,"forbiddenMarkers":["CANARY-URLUSERINFO-0001","CANARY-URLPASS-0001","CANARY-PATH-0001","CANARY-QUERY-0001","CANARY-FRAGMENT-0001","CANARY-TITLE-0001"],"requiredOutput":{"siteKey":"portal.example.invalid"}}
{"ledgerId":"led_m8q3d7w2k5h9x4r6ynjpcvtzba","sourceGenerationId":"gen_t7m3d9q5w2h8k4x6ynjpcvtzba","transactionOrdinal":5,"cursorBefore":40,"representedPositions":[41],"durableEventIds":["evt_f8m3d7q2w5h9k4x6ynjpcvtzba"],"durableProgressMarkerIds":[],"cursorAfter":41,"expectedCommit":"commit"}
```

For a hard-denied source row, the oracle may predict an atomic minimized progress marker so the source does not loop forever. That marker contains only source generation, position, policy-reason code/digest, and transaction ID. It is not an activity event and is not uploaded unless the release-authorized contract explicitly permits that health/progress fact.

## 5.6 Batch upload and receipt contracts

The dataset harness models the accepted bounded, versioned, authenticated, compressed HTTPS protocol. Authentication is supplied by the harness/registration context and not copied into fixture payloads.

```http
POST /v1/ingestion/batches HTTP/1.1
Content-Type: application/vnd.uam.batch+json;version=1
Content-Encoding: gzip
Idempotency-Key: bat_n7m3d8q2w5h9k4x6ynjpcvtzba
X-UAM-Installation-Sequence: 12

<gzip(canonical batch envelope)>
```

```json
{
  "schemaVersion": "uam.batch/1",
  "batchId": "bat_n7m3d8q2w5h9k4x6ynjpcvtzba",
  "installationId": "ins_h3w7m5q2d9k4x8r6ynjpcvtzba",
  "sequence": 12,
  "createdAt": "2042-03-04T05:06:00Z",
  "events": [
    {
      "eventId": "evt_f8m3d7q2w5h9k4x6ynjpcvtzba",
      "eventType": "edge-site-observation",
      "siteKey": "portal.example.invalid",
      "observedBucket": "2042-03-04T05:00:00Z/PT15M",
      "sourceGenerationId": "gen_t7m3d9q5w2h8k4x6ynjpcvtzba",
      "sourcePosition": 41,
      "policyRevisionId": "pol_m6q3d8w2k5h9x4r7ynjpcvtzba",
      "dedupeKey": "dedupe:v1:3ef5e7f753ad1118c7885f99bcb3ce5544f91027b98fa15995db4c12ec8af6f0"
    }
  ],
  "payloadDigest": "sha256:0e2c42625b4b88bc82f81a94d52dfc1b19665ddfd5c93d9a72a02ae9d418a443"
}
```

The endpoint payload intentionally has no authoritative `realmId` or `deviceId` field. Tests may add hostile unknown claims to verify they are ignored or rejected; the server derives tenancy/device from authenticated registration.

A successful receipt is narrow:

```http
HTTP/1.1 202 Accepted
Content-Type: application/vnd.uam.receipt+json;version=1
```

```json
{
  "schemaVersion": "uam.receipt/1",
  "receiptId": "rcp_q8m3d7w2k5h9x4r6ynjpcvtzba",
  "batchId": "bat_n7m3d8q2w5h9k4x6ynjpcvtzba",
  "custody": "durable",
  "semanticStatus": "pending",
  "receivedAt": "2042-03-04T05:06:01Z",
  "receiptDigest": "sha256:e96650aa2a85c8103dbce73a7aa481e7e95f3bd8477cd769e51dd6820871b54f"
}
```

A receipt MUST NOT claim validation, materialization, portal visibility, integration completion, or deletion completion. A duplicate retry returns the same durable custody identity or a cryptographically bound equivalent; it does not create a second business effect.

## 5.7 Canary corpus and leak-scanning rules

Each canary is fictional, unique, non-secret, and linked to allowed and forbidden locations. Secret-shaped values are deliberately invalid: for example, a PEM header without valid key material or a JWT-shaped string with non-base64url sentinel characters.

```jsonl
{"canaryId":"cnr_urluserinfo_0001","class":"url-userinfo","marker":"CANARY-URLUSERINFO-0001","allowedPaths":["source-fixtures/**","model/source-inputs.ndjson","canaries/**"],"forbiddenSinks":["coordinator-ipc","endpoint-sqlite","logs","traces","metrics","upload","exception","crash-artifact"],"severity":"critical"}
{"canaryId":"cnr_query_0001","class":"url-query","marker":"CANARY-QUERY-0001","allowedPaths":["source-fixtures/**","model/source-inputs.ndjson","canaries/**"],"forbiddenSinks":["coordinator-ipc","endpoint-sqlite","logs","traces","metrics","upload"],"severity":"critical"}
{"canaryId":"cnr_email_0001","class":"email-like","marker":"aster.user.0001@example.invalid","allowedPaths":["canaries/**","source-fixtures/**"],"forbiddenSinks":["logs","traces","metrics","upload"],"severity":"high"}
{"canaryId":"cnr_secret_0001","class":"secret-shaped-invalid","marker":"ghp_CANARY_NOT_A_VALID_TOKEN_0001","allowedPaths":["canaries/**","source-fixtures/**"],"forbiddenSinks":["all-produced-artifacts-except-scan-report-redacted-id"],"severity":"critical"}
{"canaryId":"cnr_bidi_0001","class":"unicode-bidi","marker":"CANARY-BIDI-0001-\\u202Etxt","allowedPaths":["canaries/**","source-fixtures/**"],"forbiddenSinks":["logs","report-unescaped-html"],"severity":"high"}
```

Mandatory corpus classes:

- URL userinfo/password, path segment, query key/value, fragment, title;
- `.invalid`/`.example` domains, IDN/punycode and Unicode host labels;
- TEST-NET IPv4 and documentation IPv6;
- fake Windows path, UNC-shaped path, alternate-data-stream and traversal strings;
- synthetic SID-like and directory-style identifiers;
- e-mail/phone/postcode/name-like values explicitly tagged fictional;
- API key, JWT, connection-string, private-key-header, password and bearer-token shapes that are invalid and nonfunctional;
- CR/LF, NUL, tabs, controls, invalid UTF-8 bytes, lone-surrogate attempts, bidi controls, confusables, and NFC/NFD pairs;
- empty, whitespace, maximum length, over-length, possible truncation suffixes, and repeated grapheme clusters;
- SQL, JSON, CSV/spreadsheet formula, HTML/script, shell, format-string, regex, and path injection;
- duplicate IDs, collision-prefix tests, case variants, reordered object properties, equal timestamps, clock regression, and integer boundaries.

Example deterministic rule configuration:

```json
{
  "contract": "uam.canary-rules/1",
  "failClosed": true,
  "scanEncodings": ["utf-8", "utf-16le", "utf-16be", "base64"],
  "maxDecodedLayers": 2,
  "requiredScopes": [
    "repository", "package", "stdout", "stderr", "test-results", "logs",
    "traces", "metrics", "sqlite-dumps", "http-captures", "crash-artifacts"
  ],
  "rules": [
    {"id":"CAN-EXACT-001","kind":"exact-registry","severity":"critical"},
    {"id":"CAN-URL-001","kind":"regex","pattern":"(?i)https?://[^\\s/@]+:[^\\s/@]+@","severity":"critical"},
    {"id":"CAN-QUERY-001","kind":"schema-forbidden-field","fields":["rawUrl","path","query","fragment","title"],"sink":"post-minimization","severity":"critical"},
    {"id":"CAN-SECRET-001","kind":"gitleaks","config":"config/gitleaks-uam.toml","severity":"critical"},
    {"id":"CAN-PII-HEURISTIC-001","kind":"optional-offline-presidio","minimumScore":"0.70","severity":"review"}
  ],
  "allowlistPolicy": {
    "requireCanaryId": true,
    "requireExactPath": true,
    "requirePurpose": true,
    "requireOwner": true,
    "requireExpiry": true,
    "wildcardDirectoryExceptions": false
  }
}
```

The optional heuristic threshold is a test configuration, not proof of privacy. Its false-positive/false-negative corpus must be measured. Broad regular-expression suppressions and “test data” directory exemptions are forbidden.

## 5.8 Lineage contract

Every generated record has field-level or record-level lineage sufficient to answer: where did it come from, why is it present, which seed stream/index produced it, which scenario changed it, and what parent classification applies?

```json
{
  "lineageId": "lin_q8m3d7w2k5h9x4r6ynjpcvtzba",
  "subjectType": "application",
  "subjectId": "app_w4m8d2q7k5h9x3r6ynjpcvtzba",
  "fieldPath": "/displayName",
  "classification": "T2-SANITIZED-ORG-SHAPED",
  "provenanceKind": "fictional-value-shaped-by-approved-aggregate",
  "parentDigest": "sha256:2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5",
  "generatorContract": "uam.generator/1",
  "scenarioId": "scn_catalogue_shape_v1",
  "stream": "application.display-name.non-ascii",
  "index": 3,
  "transform": "fictional-vocabulary-selection-v1",
  "outputDigest": "sha256:7fc5a99e052ddf2af1cb0bde22f74d62b0d0c34810e9e2ff2f0ef02694f89a2c"
}
```

The example `parentDigest` is the SHA-256 of the supplied sanitized report attachment in this research environment; a repository implementation should use its governed evidence identifier rather than assume this path or digest is universally available.

## 5.9 Physical SQLite harness schema

This is a **test-harness reference schema**, not the final production database design. It deliberately makes realm ownership, state, provenance, and cursor/event atomicity visible. The implementation may split files by endpoint/server test lane, but equivalent constraints and queries must remain.

```sql
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA synchronous = FULL;
PRAGMA busy_timeout = 0;          -- tests inject and handle contention explicitly
PRAGMA trusted_schema = OFF;

CREATE TABLE dataset_manifest (
    dataset_id             TEXT NOT NULL,
    revision               INTEGER NOT NULL CHECK (revision >= 1),
    classification         TEXT NOT NULL CHECK (classification IN (
                                'T1-FICTIONAL-COMMITTED',
                                'T2-SANITIZED-ORG-SHAPED',
                                'T3-CONTROLLED-MEASURED-EVIDENCE')),
    manifest_digest        BLOB NOT NULL CHECK (length(manifest_digest) = 32),
    package_root_digest    BLOB NOT NULL CHECK (length(package_root_digest) = 32),
    owner_role             TEXT NOT NULL,
    expires_at_us          INTEGER NULL,
    deletion_method        TEXT NOT NULL,
    PRIMARY KEY (dataset_id, revision)
) STRICT;

CREATE TABLE organization (
    organization_id        TEXT PRIMARY KEY,
    display_name           TEXT NOT NULL,
    fictional              INTEGER NOT NULL CHECK (fictional = 1)
) STRICT;

CREATE TABLE realm (
    realm_id               TEXT PRIMARY KEY,
    organization_id        TEXT NOT NULL REFERENCES organization(organization_id),
    display_name           TEXT NOT NULL,
    fictional              INTEGER NOT NULL CHECK (fictional = 1),
    UNIQUE (organization_id, display_name)
) STRICT;

CREATE TABLE role (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    role_id                TEXT NOT NULL,
    label                  TEXT NOT NULL,
    semantic_status        TEXT NOT NULL CHECK (semantic_status = 'fictional-test-group-only'),
    PRIMARY KEY (realm_id, role_id),
    UNIQUE (realm_id, label)
) STRICT;

CREATE TABLE persona (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    persona_id             TEXT NOT NULL,
    label                  TEXT NOT NULL,
    behavior_profile       TEXT NOT NULL,
    fictional              INTEGER NOT NULL CHECK (fictional = 1),
    PRIMARY KEY (realm_id, persona_id),
    UNIQUE (realm_id, label)
) STRICT;

CREATE TABLE persona_role (
    realm_id               TEXT NOT NULL,
    persona_id             TEXT NOT NULL,
    role_id                TEXT NOT NULL,
    PRIMARY KEY (realm_id, persona_id, role_id),
    FOREIGN KEY (realm_id, persona_id) REFERENCES persona(realm_id, persona_id),
    FOREIGN KEY (realm_id, role_id) REFERENCES role(realm_id, role_id)
) STRICT;

CREATE TABLE account (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    account_id             TEXT NOT NULL,
    persona_id             TEXT NULL,
    account_kind           TEXT NOT NULL CHECK (account_kind IN (
                                'synthetic-local','synthetic-directory','synthetic-service')),
    subject_token          TEXT NOT NULL,
    fictional              INTEGER NOT NULL CHECK (fictional = 1),
    PRIMARY KEY (realm_id, account_id),
    UNIQUE (realm_id, subject_token),
    FOREIGN KEY (realm_id, persona_id) REFERENCES persona(realm_id, persona_id)
) STRICT;

CREATE TABLE device (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    device_id              TEXT NOT NULL,
    device_label           TEXT NOT NULL,
    platform               TEXT NOT NULL CHECK (platform = 'windows'),
    fictional              INTEGER NOT NULL CHECK (fictional = 1),
    PRIMARY KEY (realm_id, device_id),
    UNIQUE (realm_id, device_label)
) STRICT;

CREATE TABLE installation (
    realm_id               TEXT NOT NULL,
    installation_id        TEXT NOT NULL,
    device_id              TEXT NOT NULL,
    release_id             TEXT NOT NULL,
    installed_at_us        INTEGER NOT NULL,
    state                  TEXT NOT NULL CHECK (state IN ('active','retired','rolled-back','uninstalled')),
    PRIMARY KEY (realm_id, installation_id),
    FOREIGN KEY (realm_id, device_id) REFERENCES device(realm_id, device_id)
) STRICT;

CREATE TABLE session (
    realm_id               TEXT NOT NULL,
    session_id             TEXT NOT NULL,
    device_id              TEXT NOT NULL,
    account_id             TEXT NOT NULL,
    logon_sequence         INTEGER NOT NULL CHECK (logon_sequence >= 0),
    session_kind           TEXT NOT NULL CHECK (session_kind IN (
                                'interactive','remote-interactive','disconnected','locked','noninteractive')),
    eligible               INTEGER NOT NULL CHECK (eligible IN (0,1)),
    started_at_us          INTEGER NOT NULL,
    ended_at_us            INTEGER NULL CHECK (ended_at_us IS NULL OR ended_at_us >= started_at_us),
    PRIMARY KEY (realm_id, session_id),
    UNIQUE (realm_id, device_id, logon_sequence),
    FOREIGN KEY (realm_id, device_id) REFERENCES device(realm_id, device_id),
    FOREIGN KEY (realm_id, account_id) REFERENCES account(realm_id, account_id)
) STRICT;

CREATE TABLE application (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    application_id         TEXT NOT NULL,
    display_name           TEXT NOT NULL,
    display_name_ci_key    TEXT NOT NULL,
    external_reference     TEXT NULL,
    quality_tags_json      TEXT NOT NULL CHECK (json_valid(quality_tags_json)),
    PRIMARY KEY (realm_id, application_id),
    UNIQUE (realm_id, display_name_ci_key),
    UNIQUE (realm_id, external_reference)
) STRICT;

CREATE TABLE policy_revision (
    realm_id               TEXT NOT NULL REFERENCES realm(realm_id),
    policy_revision_id     TEXT NOT NULL,
    product_ceiling_id     TEXT NOT NULL,
    tenant_revision        TEXT NOT NULL,
    source_type            TEXT NOT NULL,
    allowed_fields_json    TEXT NOT NULL CHECK (json_valid(allowed_fields_json)),
    forbidden_parts_json   TEXT NOT NULL CHECK (json_valid(forbidden_parts_json)),
    transform_id           TEXT NOT NULL,
    state                  TEXT NOT NULL CHECK (state IN ('draft','active','retired','killed')),
    definition_digest      BLOB NOT NULL CHECK (length(definition_digest) = 32),
    PRIMARY KEY (realm_id, policy_revision_id)
) STRICT;

CREATE TABLE source (
    realm_id               TEXT NOT NULL,
    source_id              TEXT NOT NULL,
    session_id             TEXT NOT NULL,
    source_type            TEXT NOT NULL,
    profile_token          TEXT NOT NULL,
    path_token             TEXT NOT NULL,
    owner_boundary         TEXT NOT NULL CHECK (owner_boundary = 'user-session'),
    privacy_class          TEXT NOT NULL,
    PRIMARY KEY (realm_id, source_id),
    UNIQUE (realm_id, session_id, source_type, profile_token),
    FOREIGN KEY (realm_id, session_id) REFERENCES session(realm_id, session_id)
) STRICT;

CREATE TABLE source_generation (
    realm_id               TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    source_id              TEXT NOT NULL,
    generation_ordinal     INTEGER NOT NULL CHECK (generation_ordinal >= 1),
    fingerprint_digest     BLOB NOT NULL CHECK (length(fingerprint_digest) = 32),
    created_at_us          INTEGER NOT NULL,
    PRIMARY KEY (realm_id, source_generation_id),
    UNIQUE (realm_id, source_id, generation_ordinal),
    UNIQUE (realm_id, source_id, fingerprint_digest),
    FOREIGN KEY (realm_id, source_id) REFERENCES source(realm_id, source_id)
) STRICT;

CREATE TABLE collector_run (
    realm_id               TEXT NOT NULL,
    run_id                 TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    policy_revision_id     TEXT NOT NULL,
    started_at_us          INTEGER NOT NULL,
    ended_at_us            INTEGER NULL,
    result_code            TEXT NULL,
    PRIMARY KEY (realm_id, run_id),
    FOREIGN KEY (realm_id, source_generation_id)
        REFERENCES source_generation(realm_id, source_generation_id),
    FOREIGN KEY (realm_id, policy_revision_id)
        REFERENCES policy_revision(realm_id, policy_revision_id)
) STRICT;

CREATE TABLE source_input (
    realm_id               TEXT NOT NULL,
    input_id               TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    source_position        INTEGER NOT NULL CHECK (source_position >= 0),
    observed_at_us         INTEGER NOT NULL,
    raw_fixture_json       TEXT NOT NULL CHECK (json_valid(raw_fixture_json)),
    expected_disposition   TEXT NOT NULL CHECK (expected_disposition IN (
                                'minimize','hard-deny','reject','quarantine','defer')),
    PRIMARY KEY (realm_id, input_id),
    UNIQUE (realm_id, source_generation_id, source_position),
    FOREIGN KEY (realm_id, source_generation_id)
        REFERENCES source_generation(realm_id, source_generation_id)
) STRICT;

CREATE TABLE minimized_event (
    realm_id               TEXT NOT NULL,
    event_id               TEXT NOT NULL,
    device_id              TEXT NOT NULL,
    session_id             TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    source_position        INTEGER NOT NULL,
    event_type             TEXT NOT NULL,
    policy_revision_id     TEXT NOT NULL,
    dedupe_key             TEXT NOT NULL,
    event_json             TEXT NOT NULL CHECK (json_valid(event_json)),
    durable_at_us          INTEGER NOT NULL,
    PRIMARY KEY (realm_id, event_id),
    UNIQUE (realm_id, dedupe_key),
    UNIQUE (realm_id, source_generation_id, source_position, event_type),
    FOREIGN KEY (realm_id, device_id) REFERENCES device(realm_id, device_id),
    FOREIGN KEY (realm_id, session_id) REFERENCES session(realm_id, session_id),
    FOREIGN KEY (realm_id, source_generation_id)
        REFERENCES source_generation(realm_id, source_generation_id),
    FOREIGN KEY (realm_id, policy_revision_id)
        REFERENCES policy_revision(realm_id, policy_revision_id)
) STRICT;

CREATE TABLE progress_marker (
    realm_id               TEXT NOT NULL,
    marker_id              TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    source_position        INTEGER NOT NULL,
    reason_code            TEXT NOT NULL,
    reason_digest          BLOB NOT NULL CHECK (length(reason_digest) = 32),
    durable_at_us          INTEGER NOT NULL,
    PRIMARY KEY (realm_id, marker_id),
    UNIQUE (realm_id, source_generation_id, source_position),
    FOREIGN KEY (realm_id, source_generation_id)
        REFERENCES source_generation(realm_id, source_generation_id)
) STRICT;

CREATE TABLE source_progress (
    realm_id               TEXT NOT NULL,
    source_generation_id   TEXT NOT NULL,
    last_position          INTEGER NOT NULL CHECK (last_position >= -1),
    transaction_id         TEXT NOT NULL,
    updated_at_us          INTEGER NOT NULL,
    PRIMARY KEY (realm_id, source_generation_id),
    FOREIGN KEY (realm_id, source_generation_id)
        REFERENCES source_generation(realm_id, source_generation_id)
) STRICT;

CREATE TABLE batch (
    realm_id               TEXT NOT NULL,
    batch_id               TEXT NOT NULL,
    installation_id        TEXT NOT NULL,
    sequence               INTEGER NOT NULL CHECK (sequence >= 0),
    schema_version         TEXT NOT NULL,
    created_at_us          INTEGER NOT NULL,
    event_count            INTEGER NOT NULL CHECK (event_count >= 0),
    uncompressed_bytes     INTEGER NOT NULL CHECK (uncompressed_bytes >= 0),
    payload_digest         BLOB NOT NULL CHECK (length(payload_digest) = 32),
    state                  TEXT NOT NULL CHECK (state IN (
                                'building','durable','sending','receipted','retired')),
    PRIMARY KEY (realm_id, batch_id),
    UNIQUE (realm_id, installation_id, sequence),
    FOREIGN KEY (realm_id, installation_id)
        REFERENCES installation(realm_id, installation_id)
) STRICT;

CREATE TABLE batch_event (
    realm_id               TEXT NOT NULL,
    batch_id               TEXT NOT NULL,
    event_id               TEXT NOT NULL,
    ordinal                INTEGER NOT NULL CHECK (ordinal >= 0),
    PRIMARY KEY (realm_id, batch_id, event_id),
    UNIQUE (realm_id, batch_id, ordinal),
    FOREIGN KEY (realm_id, batch_id) REFERENCES batch(realm_id, batch_id),
    FOREIGN KEY (realm_id, event_id) REFERENCES minimized_event(realm_id, event_id)
) STRICT;

CREATE TABLE receipt (
    realm_id               TEXT NOT NULL,
    receipt_id             TEXT NOT NULL,
    batch_id               TEXT NOT NULL,
    durable_custody_at_us  INTEGER NOT NULL,
    failure_domain         TEXT NOT NULL,
    semantic_status        TEXT NOT NULL CHECK (semantic_status IN (
                                'not-yet-evaluated','pending','partially-evaluated')),
    receipt_digest         BLOB NOT NULL CHECK (length(receipt_digest) = 32),
    PRIMARY KEY (realm_id, receipt_id),
    UNIQUE (realm_id, batch_id),
    FOREIGN KEY (realm_id, batch_id) REFERENCES batch(realm_id, batch_id)
) STRICT;

CREATE TABLE inbox_item (
    realm_id               TEXT NOT NULL,
    inbox_item_id          TEXT NOT NULL,
    batch_id               TEXT NOT NULL,
    state                  TEXT NOT NULL CHECK (state IN (
                                'durably-received','validating','validated','quarantined',
                                'materializing','materialized','visible','deleted')),
    lease_owner_token      TEXT NULL,
    lease_until_us         INTEGER NULL,
    quarantine_code        TEXT NULL,
    validated_at_us        INTEGER NULL,
    materialized_at_us     INTEGER NULL,
    visible_at_us          INTEGER NULL,
    PRIMARY KEY (realm_id, inbox_item_id),
    UNIQUE (realm_id, batch_id),
    FOREIGN KEY (realm_id, batch_id) REFERENCES batch(realm_id, batch_id)
) STRICT;

CREATE TABLE audit_record (
    realm_id               TEXT NOT NULL,
    audit_id               TEXT NOT NULL,
    actor_class            TEXT NOT NULL,
    action_code            TEXT NOT NULL,
    target_type            TEXT NOT NULL,
    target_id              TEXT NOT NULL,
    before_digest          BLOB NOT NULL CHECK (length(before_digest) = 32),
    after_digest           BLOB NOT NULL CHECK (length(after_digest) = 32),
    occurred_at_us         INTEGER NOT NULL,
    causal_id              TEXT NOT NULL,
    PRIMARY KEY (realm_id, audit_id),
    UNIQUE (realm_id, causal_id, action_code)
) STRICT;

CREATE TABLE deletion_case (
    realm_id               TEXT NOT NULL,
    deletion_case_id       TEXT NOT NULL,
    scope_type             TEXT NOT NULL,
    scope_id               TEXT NOT NULL,
    requested_at_us        INTEGER NOT NULL,
    expected_terminal_state TEXT NOT NULL,
    restore_rule           TEXT NOT NULL,
    evidence_method        TEXT NOT NULL,
    PRIMARY KEY (realm_id, deletion_case_id)
) STRICT;

CREATE TABLE deletion_tombstone (
    realm_id               TEXT NOT NULL,
    deletion_case_id       TEXT NOT NULL,
    scope_type             TEXT NOT NULL,
    scope_id_digest        BLOB NOT NULL CHECK (length(scope_id_digest) = 32),
    effective_at_us        INTEGER NOT NULL,
    state                  TEXT NOT NULL CHECK (state IN ('pending','effective','verified')),
    PRIMARY KEY (realm_id, deletion_case_id),
    FOREIGN KEY (realm_id, deletion_case_id)
        REFERENCES deletion_case(realm_id, deletion_case_id)
) STRICT;

CREATE TABLE migration_case (
    migration_case_id      TEXT PRIMARY KEY,
    from_schema            TEXT NOT NULL,
    to_schema              TEXT NOT NULL,
    compatibility          TEXT NOT NULL,
    expected_outcome       TEXT NOT NULL,
    loss_allowed           INTEGER NOT NULL CHECK (loss_allowed IN (0,1))
) STRICT;

CREATE TABLE expected_result (
    expected_result_id     TEXT PRIMARY KEY,
    causal_input_id        TEXT NOT NULL,
    gate                   TEXT NOT NULL,
    expected_outcome       TEXT NOT NULL CHECK (expected_outcome IN (
                                'accepted','duplicate-noop','rejected','quarantined','deferred-retry')),
    expected_error_code    TEXT NULL,
    expected_event_id      TEXT NULL,
    expected_batch_id      TEXT NULL,
    expected_receipt_state TEXT NULL,
    expected_inbox_state   TEXT NULL,
    expected_visibility    TEXT NOT NULL CHECK (expected_visibility IN (
                                'not-applicable','not-visible','visible','deleted-not-visible')),
    cursor_before          INTEGER NOT NULL,
    cursor_after           INTEGER NOT NULL,
    forbidden_markers_json TEXT NOT NULL CHECK (json_valid(forbidden_markers_json)),
    required_output_json   TEXT NOT NULL CHECK (json_valid(required_output_json))
) STRICT;

CREATE TABLE lineage_record (
    lineage_id             TEXT PRIMARY KEY,
    subject_type           TEXT NOT NULL,
    subject_id             TEXT NOT NULL,
    field_path             TEXT NULL,
    classification         TEXT NOT NULL,
    provenance_kind        TEXT NOT NULL,
    parent_digest          BLOB NULL CHECK (parent_digest IS NULL OR length(parent_digest) = 32),
    generator_contract     TEXT NOT NULL,
    scenario_id            TEXT NOT NULL,
    stream                 TEXT NOT NULL,
    stream_index           INTEGER NOT NULL CHECK (stream_index >= 0),
    transform_id           TEXT NOT NULL,
    output_digest          BLOB NOT NULL CHECK (length(output_digest) = 32),
    UNIQUE (subject_type, subject_id, field_path)
) STRICT;

CREATE TABLE canary (
    canary_id              TEXT PRIMARY KEY,
    class                  TEXT NOT NULL,
    marker                 TEXT NOT NULL UNIQUE,
    allowed_paths_json     TEXT NOT NULL CHECK (json_valid(allowed_paths_json)),
    forbidden_sinks_json   TEXT NOT NULL CHECK (json_valid(forbidden_sinks_json)),
    severity               TEXT NOT NULL CHECK (severity IN ('review','medium','high','critical'))
) STRICT;
```

Each database connection MUST execute and verify `PRAGMA foreign_keys=ON`; SQLite documents that foreign-key enforcement is not necessarily enabled by default. `PRAGMA integrity_check` and `PRAGMA foreign_key_check` are both required because integrity check does not substitute for foreign-key checking. [W17](#w17) [W18](#w18)

The endpoint crash invariant is made explicit by a single write transaction:

```sql
BEGIN IMMEDIATE;

INSERT INTO minimized_event (
    realm_id, event_id, device_id, session_id, source_generation_id,
    source_position, event_type, policy_revision_id, dedupe_key,
    event_json, durable_at_us
) VALUES (
    $realm_id, $event_id, $device_id, $session_id, $source_generation_id,
    $source_position, $event_type, $policy_revision_id, $dedupe_key,
    $event_json, $durable_at_us
);

INSERT INTO source_progress (
    realm_id, source_generation_id, last_position, transaction_id, updated_at_us
) VALUES (
    $realm_id, $source_generation_id, $source_position, $transaction_id, $updated_at_us
)
ON CONFLICT (realm_id, source_generation_id) DO UPDATE SET
    last_position  = excluded.last_position,
    transaction_id = excluded.transaction_id,
    updated_at_us  = excluded.updated_at_us
WHERE excluded.last_position >= source_progress.last_position;

COMMIT;
```

`BEGIN IMMEDIATE` is expected to fail with `SQLITE_BUSY` under contention rather than create a second writer. Tests must verify retry/backoff without moving the cursor. SQLite WAL permits readers and one writer concurrently but not multiple writers, and all processes must be on the same host; the raw main file alone may not contain transactions still in WAL. [W3](#w3) [W19](#w19)

## 5.10 Truth-ledger outcome semantics

| Outcome | Input validity | Endpoint durable effect | Cursor | Receipt/inbox | Retry behavior |
|---|---|---|---|---|---|
| `accepted` | Valid and authorized | One minimized event or explicitly authorized progress fact | Advances only in same committed transaction | May later receive durable receipt; semantic states separately predicted | Replay is duplicate/no-op |
| `duplicate-noop` | Previously represented stable identity | No second event/business effect | Does not regress; may remain at or beyond position | Existing receipt/business effect reused | Safe repeated retry |
| `rejected` | Structurally invalid, impossible version, or forbidden at boundary | No event; optional local bounded error counter | Does not advance unless an approved minimized progress rule explicitly applies | No receipt for rejected pre-upload item; invalid batch may receive protocol rejection, not custody receipt | Fix/config/schema action required |
| `quarantined` | Durably received but semantically unsafe/unknown/poison | Server keeps bounded quarantined evidence inside declared domain | Endpoint may already have advanced after durable local event and receipt | Receipt can exist; item not materialized/visible | Operator/reprocessor action; no silent drop |
| `deferred-retry` | Transient lock, outage, busy, disk pressure, lease contention | No falsely completed effect | Does not advance past unrepresented input | No premature receipt | Bounded retry/backpressure; preserve data |

The ledger must include expected **absence**. For every raw canary, it records every sink in which the marker must not appear. A missing expected row is a schema error, not an implicit “don’t care.”

# 6. State machines, transaction boundaries, lifecycle, rollout, and compatibility rules

## 6.1 Deterministic generator algorithm

### 6.1.1 Design goals

The generator must be:

- reproducible across runs, machines, cultures, time zones, thread schedules, and supported runtimes;
- stateless for individual draws so adding an unrelated field does not shift every later value;
- explicit about versioning and distributions;
- collision-detecting and lineage-producing;
- incapable of silently reading environment values, live profiles, current time, or network data;
- independent of third-party faker sequence behavior.

### 6.1.2 Byte primitives

```text
UTF8_NFC(s)  = UTF-8 bytes of Unicode NFC(s), rejecting invalid scalar sequences
U32BE(n)     = unsigned 32-bit big-endian n
LP(bytes)    = U32BE(length(bytes)) || bytes
H(parts...)  = SHA-256("UAM-G0/v1\0" || LP(part1) || LP(part2) || ...)
B32(bytes)   = lowercase RFC 4648 base32 without padding
```

`H` is domain separated and length prefixed. Concatenating unframed strings is forbidden because `ab|c` and `a|bc` could otherwise collide at the input encoding level.

### 6.1.3 Seed expansion

```text
rootSeed = H("root-seed", UTF8_NFC(manifest.seed.value))
datasetKey = H("dataset", rootSeed, UTF8_NFC(datasetId), U32BE(revision))
```

The seed is not a secret and must not be used as a credential or production cryptographic key. A T1 seed is committed. A T2/T3 seed may be withheld from broad access if it would expose governance metadata, but secrecy is not relied on for privacy.

### 6.1.4 Stateless draws

```text
Draw256(scenarioId, streamName, index) =
    H("draw", datasetKey,
      UTF8_NFC(scenarioId),
      UTF8_NFC(streamName),
      U64BE(index))

DrawU64(...) = unsigned big-endian integer from bytes 0..7 of Draw256(...)
```

Every semantic field has a named stream. Examples:

```text
organization.display-name
realm.display-name
application.category-selection
application.display-name.ascii
application.display-name.non-ascii
application.external-reference.missing-index
session.start-offset
edge.input.url-shape
fault.crash-cutpoint
```

A stream name is part of the contract. Renaming or changing its derivation is a generator major-version change unless an explicit compatibility mapping preserves bytes.

### 6.1.5 Unbiased bounded integer

For range `[0, exclusiveMax)`:

```text
function Uniform(exclusiveMax, scenarioId, stream, index):
    require 1 <= exclusiveMax <= 2^64
    limit = floor(2^64 / exclusiveMax) * exclusiveMax
    attempt = 0
    loop:
        x = DrawU64(scenarioId, stream + "/attempt", Pair(index, attempt))
        if x < limit:
            return x mod exclusiveMax
        attempt += 1
```

`Pair(index, attempt)` is a fixed bijective encoding of two unsigned 64-bit integers, not string concatenation. Rejection sampling prevents modulo bias.

### 6.1.6 Integer-weighted selection

```text
function WeightedChoice(items, weights, scenarioId, stream, index):
    require count(items) == count(weights) > 0
    require every weight is integer >= 0
    total = checked_sum(weights)
    require total > 0
    r = Uniform(total, scenarioId, stream, index)
    cumulative = 0
    for i in 0..count(items)-1 in declared order:
        cumulative += weights[i]
        if r < cumulative:
            return items[i]
```

Weights and item order are part of the scenario revision. Percentages and floating-point probabilities are prohibited. Statistical conformance tests verify the implementation but do not redefine expected exact outputs.

### 6.1.7 Stable IDs

```text
fullDigest = H(
    "id", UTF8_NFC(entityType), UTF8_NFC(realmIdOrGlobal),
    UTF8_NFC(canonicalNaturalKey)
)
visibleId = prefix(entityType) + "_" + B32(first20(fullDigest))
```

The generator stores `(visibleId, fullDigest, naturalKeyDigest)` in a collision registry. Generation fails on:

- same visible ID with a different full digest;
- same entity natural key emitted twice unintentionally;
- cross-realm reference whose realm component differs;
- ID derivation from optional external reference when a UAM-owned natural key is required.

### 6.1.8 Fixed clock

```text
Instant(tick) = manifest.clock.origin + tick * manifest.clock.tickUnit
```

Scenario events use explicit logical ticks. No generator code may call a real-time API. If a test needs clock skew or regression, the scenario declares a separate clock source and exact sequence, for example `[100, 101, 99, 102]`. Logical source position remains authoritative for cursor ordering.

### 6.1.9 Scenario composition

A scenario fragment has:

```json
{
  "scenarioId": "scn_...",
  "revision": 1,
  "dependsOn": ["scn_..."],
  "provides": ["entities:two-sessions", "fault:cross-session-open"],
  "conflictsWith": ["fault:single-session-only"],
  "parameters": {"sessionCount": 2},
  "mergePolicy": "explicit-field-ownership"
}
```

Composition algorithm:

1. Validate every fragment schema and digest.
2. Build the dependency graph and reject cycles.
3. Topologically sort by dependency, then by bytewise `scenarioId` as a stable tie-breaker.
4. Construct an ownership map for each output record/field and fault step.
5. Reject duplicate ownership unless the later fragment declares an exact `overrideOf` reference and expected parent digest.
6. Evaluate each fragment with its own stream namespace; no fragment consumes a shared mutable PRNG.
7. Sort entity files by declared canonical key, not creation order.
8. Emit lineage and composition digest.

This makes composition order-insensitive for independent fragments and makes every override reviewable.

### 6.1.10 Catalogue-shaped generation

For the 173-row profile:

```text
indexes = [0..172]
missingExternalReferenceIndexes = StableSample(indexes, 5, "catalogue/missing-external")
nonAsciiIndexes                  = StableSample(indexes - prior, 10, "catalogue/non-ascii")
truncationIndexes                = StableSample(indexes - prior, 9, "catalogue/truncation")
ipv4LikeIndexes                  = StableSample(indexes - prior, 1, "catalogue/ipv4-like")
```

The default profile uses disjoint sets so every measured count is unambiguous. An overlap stress scenario uses a separately named stream and truth assertion. Names come from fictional stems and suffixes; external references are `EXT-FICTION-####`; UAM IDs do not depend on them. A post-generation assertion recomputes all ten safe profile measures independently and fails on any mismatch.

### 6.1.11 Canonical serialization and root hash

1. Validate model strings and normalize to NFC before object creation.
2. Serialize each JSON object under I-JSON constraints; reject duplicate names, invalid Unicode, NaN, and Infinity.
3. JCS-canonicalize JSON objects. JCS preserves array order and strings; it does not normalize Unicode. [W5](#w5)
4. NDJSON files contain one JCS object per line, sorted by the entity’s canonical key, with final LF.
5. Hash each canonical file with SHA-256.
6. `hashes.sha256` contains lowercase hex, two spaces, and canonical relative path, sorted bytewise by path.
7. `package-root.json` contains manifest digest, ordered file digest list, generator/oracle/schema digests, and root digest calculated over its JCS form with `rootDigest` omitted.
8. A second implementation recomputes the package root during verification.

### 6.1.12 Generator pseudocode

```text
Generate(manifestPath, outputDirectory):
    manifestBytes = ReadExact(manifestPath)
    manifest = ParseRejectDuplicateKeys(manifestBytes)
    ValidateSchema(manifest, ManifestSchemaV1)
    ValidateClassificationAndApprovals(manifest)
    ValidateNoExpiredApproval(manifest)
    ValidateDependencyLock(manifest.generator.dependencyLockDigest)

    normalizedManifestModel = NormalizeDeclaredModelStringsToNFC(manifest)
    rootSeed = DeriveRootSeed(normalizedManifestModel)
    graph = LoadAndValidateScenarioGraph(manifest.scenarioComposition)
    orderedScenarios = StableTopologicalSort(graph)

    temp = CreateNewSiblingTempDirectory(outputDirectory)
    EnsureNoReparsePoints(temp)
    state = EmptyCanonicalModel()
    collisionRegistry = EmptyCollisionRegistry()

    for scenario in orderedScenarios:
        fragment = EvaluateScenarioPurely(
            scenario, rootSeed, fixedClock=manifest.clock)
        ValidateFragmentOwnership(fragment, state)
        MergeExplicitly(fragment, state)
        AppendLineage(fragment.lineage)

    ValidateLogicalInvariants(state)
    WriteCanonicalModelFiles(temp, state)
    BuildSourceFixturesInSandbox(temp, state)
    GenerateOracleTruthWithSeparateProcess(temp, manifest.oracle)
    WriteCanaryRegistry(temp)
    ValidateEveryInputHasExpectedResult(temp)
    ScanAllCanonicalPackageFiles(temp)
    WriteAndVerifyHashes(temp)
    FsyncFilesAndDirectoryWhereSupported(temp)
    AtomicRename(temp, outputDirectory)

    return Evidence(
        packageRoot, fileDigests, counts, versions, nativeSQLiteSourceId=null)
```

Generation fails and removes the temporary directory on any validation, collision, oracle, canary, or hash error. It never publishes a partial package.

## 6.2 Independent oracle algorithm

### 6.2.1 Independence rules

The oracle is a separate executable and assembly with separate code owners. It may import only:

- generated immutable schema types or schema IDs;
- enumerated error/state constants;
- cryptographic and canonicalization primitives whose test vectors are independently verified.

It may not import production collectors, minimizers, policy evaluators, dedupe code, cursor repositories, batch builders, receipt handlers, inbox workers, portal queries, or deletion implementations. Its rules are written as small pure interpreters over declarative records. Production output is never an oracle input.

### 6.2.2 Oracle inputs

- canonical manifest and scenario steps;
- raw fictional source inputs;
- product privacy ceiling revision fixture;
- tenant narrowing fixture;
- trusted harness authentication context;
- source generation and cursor initial state;
- declared fault schedule;
- protocol/state-machine contract version.

### 6.2.3 Oracle decision procedure

For each causal step, in declared logical order:

```text
OracleStep(modelState, step):
    1. Validate dataset revision, classification, owner, approval, expiry.
       On failure: package invalid; no test execution.

    2. Bind trusted context supplied by harness:
         trustedRealm, trustedDevice, trustedInstallation, trustedSession.
       Treat payload realm/device/session claims as untrusted fields.

    3. Validate actor/session/source boundary:
         source.ownerSession == trustedSession
         source.realm == trustedRealm
         source.device == trustedDevice
       Else outcome = rejected(BND-*), cursor unchanged.

    4. Validate schema and compatibility:
         known version, no forbidden downgrade, bounded fields/lengths.
       Unknown but durably accepted server batch may become quarantined;
       invalid endpoint source input is rejected/deferred per contract.

    5. Resolve policy:
         effective = Intersect(productCeiling, tenantNarrowing)
       Any widening attempt is rejected(PRV-CEILING-WIDEN-*).

    6. Source acquisition state:
         if lock/read attempt succeeds -> read snapshot
         else if online-backup fallback succeeds -> use consistent snapshot
         else -> deferred-retry(SRC-DEFERRED-*), cursor unchanged.
       Never model raw live main/WAL/SHM copy as valid.

    7. Transform before boundary:
         parse URL/source field under declared parser profile;
         hard-deny forbidden category where configured;
         discard userinfo/path/query/fragment/title;
         emit only allowed site/domain-level fields.
       Scan transformed object against exact canaries and forbidden schema.
       Any forbidden value -> rejected/quarantined per boundary and stop.

    8. Compute source generation, canonical source position, event ID,
       and dedupe key from stable inputs.

    9. Determine durable local transaction:
         if new authorized event -> insert event + advance cursor atomically;
         if hard-denied but approved progress marker -> marker + cursor atomically;
         if duplicate -> no second event, cursor stays max(current, represented);
         if disk/busy/crash before commit -> no event/marker and no cursor advance;
         if crash after commit -> both event/marker and cursor visible after recovery.

   10. Batch state:
         include only durable unreceipted authorized events;
         enforce declared test bound exactly;
         stable batch ID and sequence; retry bytes are identical.

   11. Receipt state:
         issue expected receipt only after inbox durable-commit cut point;
         receipt means custody only.

   12. Server semantic state:
         validate -> materialize or quarantine;
         duplicate -> one final effect;
         poison -> bounded quarantine with no lease loop;
         visibility follows materialization and policy, not receipt.

   13. Deletion/restore state:
         tombstone/effective deletion dominates restored older snapshots;
         deleted scope is never visible before restore readiness.

   14. Emit expected result, state transitions, cursor ledger,
       required outputs, forbidden sink markers, metrics bounds, and audit.
```

### 6.2.4 Outcome precedence

When several problems exist, the oracle uses stable precedence to avoid implementation-specific error choice:

1. invalid/unapproved/expired dataset package;
2. authentication and realm boundary;
3. user/session/source ownership boundary;
4. unsupported/downgraded schema;
5. privacy ceiling violation;
6. structural field validation;
7. source acquisition/defer condition;
8. duplicate/idempotency;
9. capacity/backpressure/transient fault;
10. semantic materialization/quarantine.

The expected ledger may record secondary findings, but exactly one primary outcome/error code is used for reconciliation.

### 6.2.5 Reconciliation algorithm

```text
Reconcile(truthLedger, actualEvidence):
    require exact datasetId, revision, packageRoot, schema set,
            generator digest, oracle digest, environment record

    for each expectedResult in truthLedger:
        actual = ExactLookup(expectedResult.causalInputId)
        compare primary outcome and stable error code
        compare event/batch/receipt/inbox/visibility state
        compare cursor before/after
        compare exact required authorized fields
        assert every forbidden marker absent from every declared sink

    report unexpected actual causal IDs
    report missing expected actual IDs
    check global invariants:
        no cross-realm/session effect
        one business effect per dedupe key
        every receipt maps to declared durable record
        no cursor ahead of represented durable positions
        no visible deleted scope
        metric label/value set within allowlist

    fail if any mismatch, scan finding, missing evidence, or unexecuted step
```

Approximate timestamps or unordered collections may have explicit comparison policies, but security/privacy, IDs, outcomes, state transitions, dedupe counts, and cursor positions are exact.

## 6.3 Dataset lifecycle state machine

```text
DRAFT
  | manifest + owner + deletion method
  v
CLASSIFIED
  | provenance validated; T2/T3 approvals present
  v
GENERATED
  | canonical schemas + lineage + hashes
  v
ORACLED
  | every causal input has truth and cursor expectations
  v
SCANNED
  | exact + rule + required tool scans pass
  v
APPROVED
  | code owners and gate owner sign revision digest
  v
PUBLISHED
  | immutable package root available to approved lane
  v
EXERCISED
  | actual evidence reconciled; cleanup recorded
  +--------------------+
  |                    |
  v                    v
RETIRED              REVOKED
  | expiry/replacement  | contamination/advisory/error
  v                    v
DELETION_DUE ------> DELETED_VERIFIED
```

Rules:

- A state transition is append-only and auditable.
- Publication never mutates a revision. A correction creates a new revision and revokes the old one.
- `REVOKED` blocks new executions and causes cached copies to be quarantined/deleted according to incident policy.
- T1 canonical source may have no expiry, but generated work/evidence still has cleanup policy.
- T2/T3 cannot publish without expiry or an explicitly approved event-based retention rule.
- Deletion verification is evidence, not merely a command exit code.

## 6.4 Endpoint source and cursor state machine

```text
UNSEEN
  -> DISCOVERED
  -> OWNERSHIP_VALIDATED
  -> ACQUIRE_ATTEMPT
       -> READ_ONLY_SNAPSHOT
       -> ONLINE_BACKUP_SNAPSHOT
       -> DEFERRED_LOCKED
  -> PARSED
  -> MINIMIZED | HARD_DENIED | REJECTED
  -> LOCAL_TRANSACTION_PENDING
       -> COMMITTED_EVENT_AND_CURSOR
       -> COMMITTED_MARKER_AND_CURSOR
       -> ROLLED_BACK_NO_ADVANCE
  -> BATCH_ELIGIBLE
  -> BATCHED
  -> SENDING
       -> RECEIPTED_DURABLE_CUSTODY
       -> RETRY_PENDING
  -> RETIRED_LOCAL_AFTER_POLICY
```

Invariants:

- `DEFERRED_LOCKED` and `ROLLED_BACK_NO_ADVANCE` preserve the prior cursor.
- A cursor transition references the exact transaction ID and represented event/marker.
- A source fingerprint change creates a new source generation; it does not silently reset or reuse the old cursor.
- Raw source canaries are legal only before `MINIMIZED`; they are forbidden in all later states.
- Local retirement occurs only under the accepted acknowledgement/retention contract and never silently under pressure.

SQLite’s Online Backup API is the valid fallback for obtaining a consistent snapshot in the source fixture tests; copying only the main file of a live WAL database can omit committed transactions. [W20](#w20) [W3](#w3)

## 6.5 Batch, receipt, and server state machine

```text
LOCAL_DURABLE_EVENT
  -> BATCH_BUILDING
  -> BATCH_DURABLE
  -> UPLOAD_ATTEMPT
       -> HTTP_RETRYABLE
       -> PROTOCOL_REJECTED
       -> INBOX_COMMITTING
            -> NO_RECEIPT_IF_COMMIT_FAILED
            -> RECEIPT_DURABLE_CUSTODY
                 -> VALIDATING
                      -> QUARANTINED
                      -> VALIDATED
                           -> MATERIALIZING
                                -> MATERIALIZED
                                     -> VISIBLE
                                     -> NOT_VISIBLE_BY_POLICY
                 -> DELETED/TOMBSTONED
```

A test fail occurs if:

- receipt is issued before the durable inbox commit point;
- retry produces a second inbox/business effect;
- a quarantined item becomes visible;
- a poison item loops leases without bounded terminal/quarantine evidence;
- receipt is interpreted as semantic acceptance in a client or report.

## 6.6 Deletion and restore state machine

```text
DELETION_REQUESTED
  -> SCOPE_VALIDATED
  -> TOMBSTONE_DURABLE
  -> ACTIVE_STORES_DELETING
  -> DERIVED/INDEX/CACHE_DELETING
  -> BACKUP_RULE_RECORDED
  -> COMPLETION_VERIFIED
  -> DELETED_NOT_VISIBLE

RESTORE_STARTED
  -> SNAPSHOT_RESTORED_NOT_READY
  -> TOMBSTONES_REAPPLIED/REPLAYED
  -> ACKNOWLEDGED_EVENTS_RECONCILED
  -> VALIDATION_AND_CANARY_SCAN
  -> READY
  -> VISIBILITY_ENABLED
```

A restored snapshot must not make deleted data visible before deletion state/tombstones are re-established and readiness passes. Exact production backup erasure policy and legal retention are human decisions; the test oracle only expresses the approved rule.

## 6.7 Transaction and durability boundaries

### Package publication

- Generate into a new sibling temporary directory.
- Write canonical files, oracle truth, scans, hashes, and root.
- Flush files and directory metadata where the platform supports it.
- Publish with an atomic same-volume rename.
- If atomic replacement semantics differ on a target filesystem, the CLI must detect and use a versioned immutable destination plus pointer update; a CLI experiment records behavior.

### Endpoint SQLite

- One writer.
- Event/progress marker and source cursor in one transaction.
- Batch membership and batch durable state in a transaction that cannot expose a partial batch.
- Receipt processing marks the matching batch only after receipt validation and durable local commit.
- Disk-full, I/O, busy, and process-kill faults are injected around every statement/commit boundary.

SQLite WAL allows concurrent readers and a writer but still has one writer at a time. `BEGIN IMMEDIATE` begins the write transaction and can return `SQLITE_BUSY`; retry logic must be explicit. [W19](#w19)

### Server durable inbox

- Authentication-derived context, batch bytes/digest, stable batch ID, and custody record commit in the declared durable failure domain before receipt.
- Worker leases and semantic states are later transactions.
- Materialization uses uniqueness/dedupe constraints and records the source inbox item.
- Visibility is a separate state/query condition.

### Audit

A privileged mutation and its durable audit evidence must either both commit or the mutation must fail. Test fixtures include a fault between mutation and audit write to prove there is no unaudited success.

## 6.8 Schema evolution and compatibility rules

### Versioning

- Contract IDs use a stable major: `uam.testdata.manifest/1`, `uam.generator/1`, `uam.oracle/1`, `uam.event/1`.
- Backward-compatible optional fields may be added within a major only when old readers ignore them safely and default behavior is explicit and privacy-narrowing.
- A field that changes identity, ordering, privacy, cursor, dedupe, state, error precedence, or required validation requires a new major.
- Unknown major versions fail closed or quarantine at a durable server boundary; they are never guessed.
- Downgrades are rejected unless an explicit signed migration case permits them and proves no privacy/security widening.

### Compatibility matrix

Each release contains a machine-readable matrix:

```json
{
  "contract": "uam.compatibility/1",
  "readers": {
    "agent-1": ["uam.event/1", "uam.batch/1"],
    "ingestion-1": ["uam.batch/1"],
    "oracle-1": ["uam.event/1", "uam.batch/1", "uam.receipt/1"]
  },
  "migrations": [
    {
      "from": "uam.event/1",
      "to": "uam.event/2",
      "mode": "lossless-upconvert",
      "fixture": "mig_d7m3q8w2k5h9x4r6ynjpcvtzba"
    }
  ]
}
```

### Golden corpus

Every supported major retains:

- canonical valid minimum/maximum records;
- every stable rejection/quarantine code;
- previous-minor records;
- malicious unknown/duplicate fields;
- property-order and Unicode test vectors;
- migration before/after hashes;
- round-trip/no-round-trip declarations.

A schema change is not accepted until old fixtures, new fixtures, migration fixtures, and oracle mutation tests pass.

## 6.9 Rollout

1. **Library-free core prototype.** Implement hash streams, IDs, fixed clock, canonical NDJSON, schema validation, and package root with hand-authored tiny fixtures.
2. **Independent oracle prototype.** Implement G0/G4/G5 state rules and mutation tests in a separate project.
3. **Catalogue-shape package.** Produce 173 fictional records and independent profile assertions.
4. **Canary/scanner lane.** Exact markers first, then pinned Gitleaks; optional Presidio remains off until separately approved/proven.
5. **Ephemeral SQLite materializer.** Record native source ID and run integrity/foreign-key checks.
6. **G1–G5 packages.** Stop at the first failed gate; do not use later packages to normalize an early defect.
7. **G6–G12 packages.** Add release, network, server, scale, outage, restore/deletion, and Windows matrix scenarios only after dependencies pass.
8. **T3 lane.** Remains disabled until human approvals, collector minimization, access, and deletion controls pass.

No autonomous publishing: CI may generate and verify a revision, but approval/promotion is a protected, auditable action.

## 6.10 Compatibility with accepted baseline

This design reinforces rather than changes the baseline:

- user-owned browser fixtures are opened only in their synthetic user session;
- Coordinator-facing evidence is already minimized;
- Task Hosts remain bounded process boundaries, not arbitrary script/plugin channels;
- SQLite WAL/one writer and atomic event/cursor tests are explicit;
- at-least-once upload, stable identity, and central uniqueness are oracle properties;
- receipt remains durable custody, not visibility;
- no external broker or production database choice is introduced;
- first functional slice remains Edge site/domain-level output using synthetic data.

---

# 7. Security/privacy threat and failure register

The register combines security, privacy, integrity, availability, data-quality, and operations failure modes. “Residual” states what remains after controls; none is treated as impossible.

| ID | Trigger / failure | Detection | Containment | Recovery | Cleanup | Owner | Required test | Residual risk |
|---|---|---|---|---|---|---|---|---|
| T01 | Raw production or confidential value is copied into T1/T2 | Exact provenance check, repository scan, secret/PII patterns, reviewer challenge, source-value canary where approved | Block publication; quarantine revision and all derived artifacts; revoke caches | Trace lineage parent; replace with fictional value; incident review; rotate any exposed secret | Scan and remove repository history, CI artifacts, workspaces, caches; record deletion evidence | Test Data Steward + AppSec + Privacy | Seed a known forbidden marker in every input route and verify fail-closed publication | Novel/non-pattern values can evade scanners; human review remains necessary |
| T02 | T2 aggregate is so rare or detailed that it enables singling out | Disclosure review; minimum-cell and uniqueness checks; compare retained dimensions to approved list | Withhold profile/package; reduce dimensions or coarsen buckets | Re-profile under approved transformation; issue new lineage/revision | Delete rejected profile and derivatives | Privacy Owner + Data Steward | Construct singleton/rare-combination profile; validator must reject | Formal anonymity is context-dependent; no claim of anonymization is made |
| T03 | Unowned or expired T3 evidence remains accessible | Registry expiry job, owner-resolution check, access audit, artifact inventory | Deny reads/new processing; quarantine collection job | Assign approved owner or delete/recollect under new approval | Delete primary, replicas, caches and derived unapproved files; verify | Data Steward + Incident Commander | Expire a T3 package and remove owner; all access/execution must fail | Backup/legal constraints may delay physical deletion; visibility must still stop |
| T04 | Generator output changes with OS, culture, timezone, thread order, or dependency update | Cross-matrix hash test; package root mismatch `REP-HASH-001` | Block merge/publish | Identify nondeterministic input; fix stream/serialization; bump contract if intentional | Delete mismatched artifacts | Test Architecture | Generate in Windows/Linux, UTC/non-UTC, multiple cultures, Release/Debug and compare byte-for-byte | Runtime defects or filesystem semantics can still surface on untested platforms |
| T05 | Hash/ID collision or duplicate natural key | Full 256-bit digest collision registry; uniqueness constraints | Abort generation | Change natural key or visible digest length through ADR if genuine collision | Delete partial package | Test Architecture | Inject stub hash collision; generator must fail before publish | Cryptographic collision is extremely unlikely but implementation truncation bugs are plausible |
| T06 | Third-party faker/library drift changes canonical fixture | Lockfile/hash check; golden root; dependency diff | Block update | Keep library out of canonical path or version generator major; regenerate with migration evidence | Remove stale generated packages | Build + Test Architecture | Upgrade helper deliberately; canonical core hashes must remain unchanged | Peripheral text produced by helper can still drift if incorrectly marked canonical |
| T07 | Oracle shares the implementation defect | Mutation testing, separate code owners/projects, hand-worked minimal cases, differential properties | Block gate on suspicious agreement/mutation survivor | Correct oracle or implementation after independent triage; revise ADR if contract wrong | Revoke affected evidence packs | Oracle Maintainer + Gate Owner | Seed mutations in privacy, dedupe, cursor, receipt, realm, deletion logic; oracle must fail them | Conceptual requirements error can affect both teams; human review and external tests remain |
| T08 | Oracle derives expected output from actual output | Build dependency graph, process isolation, input/output access audit | Stop reconciliation; invalidate evidence | Remove dependency/path; regenerate truth from canonical inputs only | Delete tainted truth/evidence | Oracle Maintainer | Make actual output unavailable until truth hash finalized; test must still produce truth | Covert human copying can occur; review and reproducible generation reduce it |
| T09 | Cross-session source read or token confusion | ACL/audit events, harness identity, canary unique per session, access-denied evidence | Stop affected User/Task Host; collection kill switch | Fix session binding/ACL/token logic; rerun G1 | Remove any cross-boundary event/log/artifact and treat as incident | Endpoint Security Owner | Two concurrent users with unique canaries; each host must read only owner source | Windows/session variants may expose untested behavior until lab coverage expands |
| T10 | Cross-realm payload claim changes tenancy | Auth-context vs payload comparison, uniqueness/FK checks, query assertions | Reject/quarantine batch; block realm mutation | Fix ingestion binding; replay synthetic batch after patch | Delete misrouted test rows and verify audits | Ingestion Owner + AppSec | Valid auth for Realm A plus payload IDs for Realm B; zero B effect | Integration layers may reintroduce realm claims; contracts and query tests must cover them |
| T11 | Raw URL/path/query/title canary crosses minimization boundary | Exact marker scan of IPC, SQLite, logs, transport, exceptions, crash files | Fail G4; activate source/release kill switch; block package/release | Fix transform order and error handling; add minimal regression | Purge leaked artifacts; incident evidence remains privacy-safe | Product Privacy + Endpoint Owner | One unique marker per raw field and sink; zero forbidden occurrences | Unknown encodings/compressions may escape scanner; schema-level allowlists add defense |
| T12 | Privacy ceiling is widened by tenant policy or feature flag | Set-intersection validator, signed revision comparison, stable error | Reject configuration; retain previous safe policy | Correct policy; audit attempted widening | Remove invalid configuration from caches/artifacts | Privacy Owner + Config Owner | Tenant asks for forbidden field/source; deterministic `PRV-CEILING-WIDEN-*` | Mis-specified product ceiling remains a human governance risk |
| T13 | Logs/exceptions include source values | Template-code lint, canary scan, logging tests, structured-field allowlist | Disable unsafe diagnostic path; block release | Replace with stable code/bounded attributes; sanitize exception handling | Delete affected logs/test artifacts | AppSec + Observability Owner | Cause parser/SQLite/network faults with canaries; no value interpolation | OS/EDR crash collection may capture memory outside application control; lab policy needed |
| T14 | Metrics create high cardinality or identify subjects | Static label linter, series count report, OTel overflow, `promtool` analysis | Drop/reject forbidden labels at instrumentation wrapper; fail test | Redesign metric and use logs with safe bounded fields if needed | Remove bad dashboards/recordings/test exports | Observability/SRE | Inject 6,000 device IDs and assert series count stays static; no identifier labels | Backend-added resource attributes can add cardinality; collector config must be tested |
| T15 | Browser database is locked; code copies live main/WAL/SHM unsafely | File-access instrumentation, lock scenario, source fixture hashes | Defer; prohibit raw copy path | Use short read-only attempt, Online Backup fallback, then defer | Delete temporary snapshots | Endpoint Owner | Edge fixture with WAL commits and locks; output must be consistent or deferred, never stale partial copy | Exact Edge/SQLite locking behavior varies by version and needs G2 lab proof |
| T16 | Cursor advances without durable event/progress marker | Crash-cutpoint truth ledger, post-recovery SQL query, FK/invariant check | Stop collection/upload; quarantine endpoint state | Restore from last valid transaction or rebuild source generation per approved rule | Remove orphaned rows/temp files | Endpoint Data Owner | Kill before/after each write/commit/fsync cut; only both-or-neither state allowed | Filesystem/power-loss behavior needs real Windows lab and storage coverage |
| T17 | Duplicate retry creates two business effects | Unique constraints, dedupe counters, truth reconciliation | Keep duplicate in no-op state; stop materializer if uniqueness violated | Repair dedupe logic; remove duplicate synthetic effect; replay | Verify one final row/aggregate/audit effect | Ingestion/Data Owner | Same event/batch bytes, reordered request, delayed ACK, concurrent retries | Side-effecting integrations may require their own idempotency contracts |
| T18 | Server issues receipt before durable custody | Fault injection at inbox commit/response boundary; receipt-to-record query | Suppress receipt; fail ingestion instance/gate | Fix transaction ordering; retry batch | Remove orphan receipt evidence | Ingestion Owner + DBA | Kill/rollback around commit and response; every receipt must resolve after recovery | Declared failure domain may be mischaracterized operationally; restore/failover drills needed |
| T19 | Poison item loops worker leases or blocks queue | Attempt counter, lease age, stable poison code, queue progress metric | Quarantine after approved bounded attempts; isolate item | Fix parser/handler; controlled reprocess | Delete test poison artifact after evidence retention | Ingestion Owner + SRE | Invalid-but-durable item followed by valid items; valid work continues | Exact attempt/time bounds are measurements/human decisions |
| T20 | Disk pressure silently deletes unacknowledged data | File/SQLite size, free-space fault, event/batch inventory reconciliation | Stop new collection according to policy; preserve existing data; signal bounded health | Free space, upload, or operator cleanup under approved rules; resume from cursor | Remove only acknowledged/approved-retired data and temp files | Endpoint Owner + Support | Quota/disk-full at every transaction/batch stage; no silent loss | Severe OS-level failure may make storage unavailable; behavior must be operationally rehearsed |
| T21 | Long outage causes retry storm or resource exhaustion | Retry schedule trace, queue depth/bytes, CPU/network counters | Backoff, jitter from deterministic test schedule, bounded concurrency, collection kill switch if approved | Restore connectivity gradually; drain with limits | Delete test queues/workspaces | Endpoint + SRE | Simulated outage then recovery for 6,000 logical devices; no synchronized storm or data loss | Exact network/proxy behavior and safe limits remain measured |
| T22 | Restore loses acknowledged events | Receipt/inbox/event reconciliation before visibility | Keep restored service not ready; block portal visibility | Replay durable logs/backups per design; reconcile every acknowledged ID | Remove failed restore environment | DBA/SRE + Data Owner | Backup after receipt scenarios, restore, compare acknowledged set exactly | RPO/RTO and actual backup topology remain human/operational evidence |
| T23 | Restore resurrects deleted data | Tombstone/deletion ledger query before readiness; canary scope | Keep service unavailable/not visible | Reapply deletion state, rebuild indexes/caches, rerun scan | Purge resurrected rows/caches in test environment | DBA/SRE + Privacy Owner | Snapshot predating deletion restored; deleted synthetic scope never visible | Backup retention and legal hold rules are human decisions |
| T24 | Stale, unsigned, incomplete, frozen, or downgraded release/test contract executes | Release/signature/version/expiry checks; audit | Refuse execution and preserve current authorized version | Deploy authorized release or rollback safely | Remove unauthorized package/cache | Release Owner + AppSec | Tamper, remove file, downgrade schema/release, freeze time; none executes | Enterprise deployment/proxy/offline behavior needs G6/G7 evidence |
| T25 | Feature flag or kill switch silently drops data | Audit, state/cursor/outbox reconciliation, flag ownership check | Fail closed; stop collection/upload without deleting unacknowledged data | Restore authorized config; resume/replay | Remove invalid config and verify cached copies | Config Owner + Endpoint Owner | Toggle at each state and restart/offline; invariant remains | Ambiguous operational ownership can delay correct response |
| T26 | Fixture text exploits SQL/CSV/HTML/path/shell handling | Injection corpus, parameterization/static analysis, output escaping tests | Sandbox; block artifact/report publication | Fix parameterization/encoding/path handling | Delete malicious generated artifacts | AppSec + Component Owner | Canary fuzz corpus through every parser/export/report | New sink types need continuous corpus updates |
| T27 | Scanner tool/package is compromised or unpinned | Hash/signature/SBOM verification, lockfile, provenance policy | Block build; isolate tool runner from network and secrets | Replace/remove tool; rerun scans with trusted version | Delete suspect images/caches/artifacts | Build Security | Tamper binary/hash and floating action; pipeline must refuse | Upstream compromise can precede detection; multiple independent layers reduce exposure |
| T28 | Scanner false negative gives false assurance | Known-canary test suite, scanner mutation, multiple engines, schema sink checks | Treat scan as one layer; fail if mandatory canary not detected | Fix rules/tool config; add regression | Remove unverified packages | Privacy Owner + AppSec | Disable a rule/encode marker; self-test must fail before package scan | Unknown patterns remain possible; claim is “no detected leak under corpus,” not proof of absence |
| T29 | Schema migration drops/changes privacy or identity field | Before/after canonical digest, loss declaration, oracle compatibility tests | Block migration/downgrade | Correct mapping or issue major version/explicit rejection | Delete bad migrated stores | Schema Owner | Golden migrations, unknown fields, downgrade attempts, rollback | Data semantics can be misunderstood despite mechanical preservation |
| T30 | Audit mutation succeeds without durable audit | Transaction fault injection and causal query | Roll back mutation; block admin feature | Fix atomic boundary; replay only after patch | Remove unaudited synthetic mutation | Control API Owner + Audit Owner | Kill/fail audit write around mutation; no state change without audit row | External audit sink failure-domain claims need separate operational proof |
| T31 | Dataset report is inaccessible or misleading | Automated accessibility checks, keyboard/screen-reader review, no-color snapshot | Block report publication; retain machine-readable JSON | Correct semantics/labels/order/error summary | Remove superseded report | Test UX/Accessibility Owner | Navigate/report with keyboard, monochrome, screen reader; errors remain identifiable | Automated checks do not prove usability; human testing remains |
| T32 | Cleanup command deletes outside sandbox | Canonical path check, root token, dry-run inventory, filesystem monitor | Refuse path; sandbox account permissions | Fix path handling; restore test workspace if needed | Audit remaining paths and damage | Test Infrastructure + AppSec | Traversal, junction/reparse point, case tricks, root/symlink attack | Privileged CI misconfiguration can widen damage; least privilege is essential |
| T33 | Cleanup reports success but artifacts remain in CI/cache/backup | Post-delete inventory, artifact API receipt, cache-key scan | Mark deletion incomplete; block closure | Retry approved deletion or escalate store owner | Verify every declared artifact scope | Data Steward + Build Ops | Seed copies in each declared store and confirm removal evidence | Third-party retention windows may prevent immediate physical erasure; access must cease |
| T34 | 6,000-device fixture is mistaken for capacity proof | Evidence label/linter, report banner, absence of production claim | Reject report/ADR conclusion | Rerun with approved measured inputs and benchmark | Correct misleading documentation | Performance Owner + Reviewer | Report parser must label run “structural smoke” unless capacity inputs/criteria supplied | Stakeholders can still overgeneralize; review gate must be explicit |
| T35 | Support manually edits fixture or truth to pass a test | Immutable root, dirty-worktree check, approval audit | Reject evidence; quarantine edited package | Regenerate from source/reviewed change | Delete edited artifact | Support Owner + Gate Owner | Modify one byte in input/truth; verification fails | Out-of-band copies can be edited; evidence acceptance verifies root |

## 7.1 Threat-model conclusions

- **INFERENCE.** The highest-consequence G0 risks are not weak random data quality; they are boundary violations, contaminated fixtures, common-mode oracle errors, and false lifecycle evidence. The architecture therefore spends more control effort on classification, provenance, exact absence assertions, independent truth, and deletion than on “realistic” names.
- **RECOMMENDATION.** Treat a privacy canary escape, cross-session/realm effect, premature receipt, cursor-ahead state, acknowledged-event loss, or deleted-data visibility as a release-blocking invariant failure, never a flaky-test waiver.
- **RECOMMENDATION.** Flaky test handling may retry infrastructure setup, but the original evidence, seed, environment, and failure must be retained. It may not regenerate a new seed until one passes.

---

# 8. Detailed test matrix and smallest falsifying prototypes

## 8.1 Dataset catalogue by proof gate

Retention below is a conservative engineering default for synthetic artifacts, not a production retention decision. T2/T3 values require human approval; “until evidence acceptance + deletion verification” means no unbounded archive.

| Dataset ID / name | Gate(s) | Purpose and key cases | Nominal size | Classification | Retention / deletion | Accountable owner |
|---|---|---|---:|---|---|---|
| `g0-minimal-contract-v1` | G0 | One realm/device/session/source/event; manifest, lineage, truth, hashes | 1 input, 1 event | T1 | Canonical source in VCS; generated work deleted after run | Test Data Steward |
| `g0-repro-matrix-v1` | G0 | Cultures, time zones, OS/runtime/configuration order; same bytes | 100 entities | T1 | Source in VCS; matrix artifacts per CI policy | Test Architecture |
| `g0-catalogue-shape-173-v1` | G0, G3 | 173 fictional apps; 5 missing refs, 10 non-ASCII, 9 truncation-like, 1 IPv4-like, CI uniqueness | 173 apps | T2 | Protected package; expiry and deletion approval required | Data Steward + Catalogue Evidence Owner |
| `g0-classification-negative-v1` | G0 | Missing tier/provenance/owner/expected result/deletion; expired approvals | 20 invalid manifests | T1 | VCS | Test Data Steward |
| `g0-canary-selftest-v1` | G0, G4 | Every canary must be detected in every encoded form and allowed only in exact source paths | 200–500 corpus items | T1 | VCS; generated scan artifacts deleted | Privacy + AppSec |
| `g1-two-users-cross-session-v1` | G1 | Two concurrent eligible sessions, unique canaries, lock/disconnect/reconnect, hostile token/session claims | 2 accounts, 1 device, 2–4 sessions | T1 | VCS; ephemeral profiles deleted | Endpoint Security Owner |
| `g1-two-realms-same-local-ids-v1` | G1, G8 | Same local-looking account/device/event IDs in two realms; no cross-effect | 2 realms, 2 devices | T1 | VCS | AppSec + Ingestion Owner |
| `g2-edge-lock-matrix-v1` | G2 | Read-only success, WAL active, browser lock, Online Backup success/failure, defer, crash during backup | 12 source states | T1 | Source recipe in VCS; databases generated/deleted | Endpoint/Browser Owner |
| `g3-generation-reset-v1` | G3 | Profile replacement, DB recreation, history deletion, same timestamps, cursor gaps, first-run boundary | 4 generations, 100 rows | T1 | VCS | Endpoint Data Owner |
| `g3-cursor-ordering-fuzz-v1` | G3, G5 | Equal/regressing time, out-of-order source positions, duplicates, invalid rows | Property-generated; recorded failing seeds | T1 | Minimal reproducers retained; bulk work deleted | Test Architecture |
| `g4-privacy-ceiling-canary-v1` | G4 | userinfo/path/query/fragment/title/IDN/IP/Unicode/secret-shaped canaries; tenant widening | 100 raw rows | T1 | VCS | Product Privacy Owner |
| `g4-hard-deny-progress-v1` | G4, G5 | Forbidden categories; optional minimized progress marker; no raw value/upload | 20 rows | T1 | VCS | Privacy + Endpoint Data Owner |
| `g5-crash-cutpoints-v1` | G5 | Kill/fault before/after event insert, cursor upsert, commit, batch build, receipt local commit | 30–60 cut points | T1 | Recipes in VCS; crash stores deleted after evidence | Endpoint Data Owner |
| `g5-sqlite-wal-regression-v1` | G5 | Native source ID, WAL checkpoint/reset, multi-connection contention, integrity/FK checks, known regression class | Repeat loop; count set by gate | T1 | Evidence retained per release gate; work DBs deleted | Endpoint Data Owner + Build Security |
| `g6-release-policy-v1` | G6 | valid, stale, expired, unsigned, partial, frozen, downgrade, rollback, offline kill switch | 20 release envelopes | T1 | VCS | Release Owner |
| `g7-auth-network-v1` | G7 | valid/invalid device identity, proxy auth simulation, TLS failures, captive/blocked network, delayed receipt | 20 protocol cases | T1 | VCS; captures deleted | Device Identity + Network Owner |
| `g8-duplicates-poison-v1` | G8 | same/reordered/concurrent duplicate batches, unknown schema, poison item, lease expiry, valid work behind poison | 50 batches, 500 events | T1 | VCS | Ingestion Owner |
| `g8-receipt-failure-domain-v1` | G8, G11 | crash before/after inbox commit and response; retry; receipt maps to durable row | 20 fault schedules | T1 | VCS recipes; DB evidence deleted after acceptance | Ingestion + DBA |
| `g9-6000-structural-smoke-v1` | G9 | 6,000 devices, one batch/device, ten events/batch, realm distribution; structural uniqueness and ingestion concurrency | 6,000 devices, 60,000 events | T1 | Generator recipe in VCS; bulk artifact short-lived | Performance Owner |
| `g9-load-parametric-v1` | G9 | Replaceable formulas for devices × rate × payload × retry/outage; actual benchmark input from approved T3 | Generated from approved parameters | T1 or T2/T3-derived | Per input tier; no capacity claim without approved evidence | Performance + Data Steward |
| `g10-outage-disk-v1` | G10 | multi-day logical outage, retry recovery, quota/disk-full, temp cleanup, no silent loss, backpressure | Adjustable; default smoke 100 devices | T1 | VCS recipe; work stores deleted | Endpoint + SRE |
| `g10-recovery-wave-6000-v1` | G9, G10 | 6,000 logical devices reconnect across deterministic jitter buckets; bound concurrency | 6,000 batches | T1 | Recipe retained; output deleted | SRE/Performance |
| `g11-delete-restore-ack-replay-v1` | G11 | acknowledged event set, snapshot restore, delayed ACK replay, deletion tombstone, no resurrection/duplication | 1,000 events, 10 scopes | T1 | VCS recipe; restore stores deleted | DBA/SRE + Privacy |
| `g11-deletion-artifact-inventory-v1` | G11 | repository/workspace/CI/artifact/cache deletion evidence and remaining-copy detection | 10 seeded copies | T1 | Test evidence per gate | Data Steward + Build Ops |
| `g12-windows-session-matrix-v1` | G12 | supported Windows builds/session types/VDI variants after inventory; accessibility and support diagnostics | **UNKNOWN** until platform decision | T1 plus approved metadata | Matrix revisioned; lab artifacts deleted | Windows Platform Owner |
| `t3-measurement-template-v1` | Any | Empty collector contract demonstrating approval, minimum fields, no-raw validation, expiry/deletion | 0 measurements | T3 template | VCS template; no collected data | Data Steward |

**ESTIMATE.** Structural smoke only: `g9-6000-structural-smoke-v1` uses 6,000 devices × 1 batch × 10 events = 60,000 events. These are convenient bounded inputs, not measured production rates or a capacity target. The benchmark generator accepts replacement parameters and labels every report accordingly.

## 8.2 Gate mapping and stop rules

| Gate | Claim to falsify | Dataset(s) | Stop condition |
|---|---|---|---|
| G0 | Every package is classified, owned, reproducible, scanned, oracled, and deletable | all `g0-*` | Any missing metadata, hash drift, undetected mandatory canary, or truth gap stops G1–G12 package publication |
| G1 | User/session and realm boundaries hold | `g1-*` | Any cross-read, cross-effect, or token confusion stops endpoint functional work |
| G2 | Edge acquisition is consistent and safe under locks/WAL | `g2-*` | Raw live copy, inconsistent snapshot, or unsafe retry stops G3/G4 collector work |
| G3 | Source generation/cursor logic is correct | `g3-*`, catalogue shape | Cursor bridge/reset/gap without declared rule stops G4/G5 |
| G4 | Minimization and canary containment hold | `g4-*`, canary self-test | Any forbidden value after boundary stops release |
| G5 | Event/progress and cursor crash invariant holds | `g5-*` | Any cursor-ahead/orphan/loss stops upload integration |
| G6 | Release/update authorization and rollback hold | `g6-*` | Any stale/unauthorized/downgraded execution stops deployment expansion |
| G7 | Device identity and enterprise network behavior are safe | `g7-*` | Realm/device binding failure or data loss under network conditions stops broad pilot |
| G8 | Durable inbox, receipt, idempotency, and poison handling hold | `g8-*` | Premature receipt, duplicate effect, or poison blockage stops scale test |
| G9 | Reference stores/processes handle declared synthetic workload | `g9-*` | Acceptance criteria miss; no capacity claim and no production engine decision |
| G10 | Disk/backpressure/outage behavior preserves data and resources | `g10-*` | Silent loss, storm, or unrecoverable state stops migration expansion |
| G11 | Deletion, restore, and acknowledged replay are correct | `g11-*` | Acknowledged loss, duplicate effect, or deleted-data visibility stops production approval |
| G12 | Extended Windows/session platform matrix is supported | `g12-*` | Unsupported variant is excluded or architecture changed through ADR; no silent support claim |

## 8.3 Smallest falsifying prototypes

Durations are **ESTIMATE** execution budgets for planning; each run records actual elapsed and environment. A timeout is a failed/inconclusive experiment, never an automatic pass.

### P0 — metadata gate

- **Claim:** no package can exist in a production-shaped lane without classification, provenance, expected result, owner, and deletion method.
- **Setup:** CLI plus 20 manifests, each missing or corrupting one mandatory element; include expired T2 approval and wildcard deletion scope.
- **Instrumentation:** validator JSON report, exit code, audit record, filesystem monitor.
- **Steps:** validate each manifest; attempt generate and publish.
- **Pass:** every invalid case has stable `CLS/LIN/SCH` code; no output package or partial directory remains; valid minimum package publishes.
- **Fail:** any defaulted field, warning-only result, partial package, or non-idempotent cleanup.
- **Evidence:** `validation-results.json`, stdout/stderr scan, directory inventory, valid root hash.
- **Budget:** ≤ 5 minutes on a developer machine.
- **Cleanup:** remove temporary roots and verify zero undeclared paths.

### P1 — deterministic bytes

- **Claim:** canonical T1 package bytes do not depend on OS, culture, time zone, process/thread scheduling, or repeated execution.
- **Setup:** same source/lockfile on at least one Windows and one independent runner; cultures `en-US`, `tr-TR`, `ja-JP`; UTC and non-UTC; single/multi-thread invocation; Release build.
- **Instrumentation:** file hashes, package root, runtime/OS/culture/time-zone record, dependency lock hash.
- **Steps:** generate each matrix cell twice; compare exact bytes and root.
- **Pass:** all canonical file bytes and root hashes match; reports may differ only in explicitly excluded environment fields.
- **Fail:** any canonical mismatch.
- **Evidence:** `repro-matrix.json`, `hashes.sha256`, binary diff summary.
- **Budget:** ≤ 15 minutes in CI.
- **Cleanup:** remove generated work; retain compact matrix report.

### P2 — catalogue shape without copying

- **Claim:** the approved aggregate shape can be reproduced with fictional values and no semantic inference.
- **Setup:** T2 aggregate profile and fictional vocabulary; no access to raw catalogue.
- **Instrumentation:** independent profiler, exact scanner, lineage query.
- **Steps:** generate 173 records; profile counts; verify all UAM IDs, external reference behavior, and absence of semantic dimensions.
- **Pass:** exact safe counts; all values tagged fictional; five null external references; no duplicate non-empty ref; no fields for role/owner/purpose/usage/matching; no internal-value finding.
- **Fail:** copied/unknown value, count drift, or invented semantic relationship.
- **Evidence:** `catalogue-shape-profile.json`, lineage, scan report, package root.
- **Budget:** ≤ 5 minutes.
- **Cleanup:** delete protected generated copy when the T2 approval says; retain approved aggregate report.

### P3 — canary scanner self-test

- **Claim:** every mandatory canary is detected in all declared encodings/sinks and allowed only in exact source locations.
- **Setup:** corpus with exact, UTF-16, base64, compressed capture, split/chunk and escaped forms; deliberately contaminated artifacts.
- **Instrumentation:** scanner rule coverage, finding IDs, false-positive corpus.
- **Steps:** run self-test before any package scan; disable one rule in a negative control.
- **Pass:** all mandatory planted markers detected; disabled rule makes self-test fail; clean fixture has zero critical/high findings outside declared allowlist.
- **Fail:** missed planted marker, wildcard suppression, or scanner unavailable but pipeline continues.
- **Evidence:** `scanner-selftest.json`, rule coverage, tool versions/hashes.
- **Budget:** ≤ 10 minutes without optional NLP; optional lane measured separately.
- **Cleanup:** delete contaminated artifacts after preserving redacted finding IDs.

### P4 — cross-session and cross-realm isolation

- **Claim:** one User Host/session/realm cannot read or submit as another.
- **Setup:** one Windows test device, two synthetic interactive sessions with unique source canaries; two realms with deliberately colliding local-looking IDs.
- **Instrumentation:** process token/session inventory, ACL access events, IPC peer binding, server auth context, database realm query.
- **Steps:** normal reads; hostile profile path; swapped session token/IPC handle; payload Realm B under Realm A authentication; concurrent operations.
- **Pass:** owner session only reads its source; hostile attempts denied with stable code; zero cross-realm events/audit/visibility.
- **Fail:** any canary or effect crosses boundary.
- **Evidence:** redacted identity/session facts, state transitions, canary scan, realm counts.
- **Budget:** ≤ 30 minutes per supported Windows lab baseline.
- **Cleanup:** destroy synthetic profiles/accounts and ephemeral stores; verify canaries absent.

### P5 — Edge lock and consistent snapshot

- **Claim:** acquisition uses short read-only attempt, Online Backup fallback, then defer; never raw copy of live main/WAL/SHM.
- **Setup:** fictional Edge-like SQLite source with WAL commits, active reader/writer locks, controllable backup fault.
- **Instrumentation:** file-open trace, SQLite source ID, query snapshot digest, fault log.
- **Steps:** unlocked read; locked read with successful backup; backup failure; process kill during backup; WAL commit not checkpointed.
- **Pass:** consistent expected rows or `SRC-DEFERRED-*`; no raw copy path; temporary snapshots removed; cursor unchanged on defer.
- **Fail:** missing committed WAL row, partial mix, source mutation, cross-profile access, or raw file trio copy.
- **Evidence:** source/backup digests, trace, truth reconciliation.
- **Budget:** ≤ 20 minutes per SQLite/browser version fixture.
- **Cleanup:** close handles and remove all temporary databases/directories.

### P6 — privacy transform ordering

- **Claim:** forbidden raw values never cross the endpoint boundary, including on error.
- **Setup:** raw URL field containing unique canaries in userinfo, password, path, query, fragment, title; malformed URL and Unicode variants.
- **Instrumentation:** IPC capture, endpoint DB dump, logs/traces/metrics, upload capture, exception/crash files.
- **Steps:** successful parse, parse failure, cancellation, timeout, disk error, diagnostic mode attempt.
- **Pass:** only authorized site/domain-level value appears after User/Task Host transform; zero forbidden markers; errors use stable codes.
- **Fail:** one marker in any forbidden sink or flag widens output.
- **Evidence:** scan report per sink, contract payload, oracle reconciliation.
- **Budget:** ≤ 15 minutes.
- **Cleanup:** delete source fixtures and captures; verify cleanup scan.

### P7 — event/cursor crash invariant

- **Claim:** a cursor never advances ahead of durable minimized events/progress markers.
- **Setup:** one source generation and one new input; deterministic fault points around transaction statements, commit return, process exit, WAL checkpoint, reopen.
- **Instrumentation:** kill-point ID, SQLite trace where safe, post-recovery queries, `integrity_check`, `foreign_key_check`.
- **Steps:** run fresh store once per fault point; hard kill; reopen and reconcile.
- **Pass:** before commit, neither effect nor cursor advance; after commit, both; no corruption; duplicate replay creates no second effect.
- **Fail:** cursor ahead, event without represented progress under contract, corruption, or silent skip.
- **Evidence:** per-cutpoint database digest/query JSON, native SQLite source ID, truth report.
- **Budget:** ≤ 30 minutes for smoke; longer soak is a separate measured gate.
- **Cleanup:** delete every per-cutpoint DB after evidence pack.

### P8 — receipt durability and duplicate effect

- **Claim:** receipt follows durable inbox custody and retries create one business effect.
- **Setup:** one canonical batch, server DB, fault points before/after inbox commit and HTTP response; concurrent duplicate clients.
- **Instrumentation:** transaction/fault IDs, receipt capture, inbox/materialized uniqueness queries.
- **Steps:** inject failure at each point; retry exact and reordered envelopes; process worker.
- **Pass:** no receipt without recovered durable record; any receipt resolves to one batch; one final materialized effect; receipt remains semantically pending until worker states.
- **Fail:** orphan receipt, duplicate materialization, or receipt-as-visible claim.
- **Evidence:** request/receipt digests, DB state, reconciliation.
- **Budget:** ≤ 30 minutes per database engine candidate.
- **Cleanup:** drop isolated test database/schema and erase captures.

### P9 — poison progress

- **Claim:** a poison item is quarantined without blocking valid work.
- **Setup:** valid batch A, durable unknown/poison B, valid C; worker lease faults.
- **Instrumentation:** state/lease transitions, attempt count, queue progress, stable error.
- **Steps:** process A/B/C; crash worker holding B; expire/reacquire lease; reach configured test terminal state.
- **Pass:** A and C materialize once; B becomes bounded quarantine; no infinite hot loop; no visibility for B.
- **Fail:** C blocked, B lost/visible, or unbounded lease churn.
- **Evidence:** timeline, counters, final states.
- **Budget:** ≤ 15 minutes with compressed logical lease clock.
- **Cleanup:** delete isolated inbox records after evidence.

### P10 — 6,000-device structural smoke and recovery wave

- **Claim:** IDs, realm binding, batch construction, bounded metrics, and basic ingestion can structurally handle 6,000 logical endpoints without cardinality explosion; not a production capacity claim.
- **Setup:** 6,000 devices, 60,000 minimized events, deterministic reconnect buckets; declared hardware and process limits.
- **Instrumentation:** generation time/bytes, memory/CPU, ingestion counts, series count, duplicate count, queue depth.
- **Steps:** generate; scan; ingest normal; replay selected duplicates; simulated outage and deterministic recovery wave.
- **Pass:** exact counts and one effect; no realm bleed; no forbidden metric labels; series count equals static allowlist product; no unhandled error or silent loss.
- **Fail:** mismatch, leak, unbounded series, corruption, or misleading “capacity passed” report.
- **Evidence:** parameter file, environment, count reconciliation, metrics cardinality report.
- **Budget:** **ESTIMATE** ≤ 60 minutes for the initial CI/lab smoke; actual measured runtime becomes the next planning input.
- **Cleanup:** delete bulk package/database/artifacts; retain compact hashes and summaries.

### P11 — disk pressure and outage

- **Claim:** pressure/outage defers or stops safely and preserves unacknowledged data.
- **Setup:** ephemeral quota/volume, fixed outbox, network fault proxy or harness, deterministic logical outage/recovery schedule.
- **Instrumentation:** free bytes, DB/file bytes, event/batch/receipt inventories, retry/concurrency schedule, CPU/network.
- **Steps:** fill at transaction, WAL, batch, temp, and receipt points; keep network down; restore gradually.
- **Pass:** no silent deletion; cursor invariant holds; retries bounded; recovery drains without synchronized storm; cleanup only removes acknowledged/approved data.
- **Fail:** lost unacknowledged item, tight loop, uncontrolled resource growth, or corrupted store.
- **Evidence:** inventories before/during/after, fault timeline, reconciliation.
- **Budget:** **ESTIMATE** 30–90 minutes for compressed-time smoke; long-duration soak separately approved.
- **Cleanup:** release quota/faults; securely delete stores/captures.

### P12 — deletion, restore, and acknowledged replay

- **Claim:** restore loses no acknowledged event, creates no duplicate business effect, and never makes deleted data visible before readiness.
- **Setup:** known batches/receipts, materialized rows, deleted synthetic scope, snapshot before/after states, delayed ACK/replay.
- **Instrumentation:** acknowledged-set digest, event/materialization/tombstone queries, readiness/visibility switch, canary scan.
- **Steps:** snapshot; acknowledge; delete scope; restore older snapshot; replay receipts/events/tombstones; validate; enable visibility.
- **Pass:** acknowledged set exactly present once; deleted scope absent from visibility; readiness stays false until reconciliation; audits complete.
- **Fail:** acknowledged loss, duplicate, premature visibility, or resurrection.
- **Evidence:** before/after set digests, restore log, deletion ledger, portal/API query results.
- **Budget:** **UNKNOWN** until engine/backup topology; smoke must record actual and cannot claim RPO/RTO.
- **Cleanup:** destroy restore environment and verify deletion artifact inventory.

## 8.4 Detailed validation matrix

| Test | Setup / generated variation | Instrumentation | Exact pass condition | Failure evidence retained |
|---|---|---|---|---|
| Manifest schema | valid min/max; duplicate JSON keys; unknown fields; invalid Unicode | validating parser + schema validator | only valid declared forms accepted; duplicate keys rejected before schema | input digest, stable code, validator version |
| NFC normalization | composed/decomposed pairs; combining marks | pre/post code-point and byte digest | model ingress normalizes once; JCS output bytes equal for semantically declared normalized pairs; raw fuzz bytes remain explicit | code-point vectors and hashes |
| JCS vectors | RFC vectors plus UAM objects | independent canonicalizers | exact expected bytes; arrays remain ordered; no whitespace | vector ID and diff |
| Hash stream | known seed/stream/index vectors | two implementations | exact 256-bit output for all vectors | vector result |
| Range selection | boundary max, rejection path via injectable hash | property test | output always in range; forced rejected draw consumes declared attempt only | minimized seed/case |
| Weighted choice | zero weights, overflow, item order | property + exact vectors | invalid totals rejected; exact expected item; no float | case and stable code |
| ID collision | injected digest stub; same/different natural keys | collision registry | generation aborts before publication | registry rows and code |
| Composition | reordered independent fragments, cycle, conflict, explicit override | graph report | independent reorder same root; cycle/conflict rejected; override digest exact | graph and diff |
| Referential integrity | cross-realm FKs, orphan IDs | SQLite FK + logical validator | zero FK errors; hostile cross-realm rows rejected | `foreign_key_check` output |
| Catalogue profile | all 173 rows | independent profile script | exact supplied safe counts, zero semantic fields | aggregate report |
| Canary exact | marker in every sink/encoding | scanner self-test | 100% planted mandatory markers detected; clean allowed source exceptions exact | redacted finding IDs |
| Secret scan | invalid secret shapes and clean fixture | pinned Gitleaks | planted patterns found; no broad allowlist | config/tool hash/report |
| Optional PII heuristic | labelled positive/negative fictional corpus | offline Presidio if enabled | measured confusion matrix meets human-approved gate; never sole pass | model/version/corpus hash |
| Log safety | every error family with source canary | log capture | no canary/raw field; only allowlisted attributes/templates | scan + field inventory |
| Metric cardinality | 1, 100, 6,000 devices | OTel/Prometheus export | series count independent of identifier count; no forbidden labels/overflow | exposition and `promtool` report |
| Session isolation | two accounts/sessions | ACL/process/IPC trace | zero foreign source access/effect | boundary report |
| Realm isolation | same IDs across realms, hostile claims | auth + DB query | exact realm-owned counts; no payload-selected realm | auth-context trace and counts |
| Browser lock | lock/WAL/backup/defer matrix | file/SQLite trace | consistent snapshot or defer only | snapshot hash and trace |
| Cursor atomicity | every crash cut | post-recovery queries | both effect+cursor or neither; duplicate replay no-op | per-cut DB query evidence |
| Batch determinism | repeated/reordered build invocation | payload bytes/digest | exact same bytes/ID for same membership/order contract | payload diff |
| Receipt durability | commit/response faults | DB + HTTP capture | every receipt has recovered custody row; no orphan | receipt-to-row map |
| Idempotency | sequential/concurrent duplicate | unique constraints/counts | one final effect and one aggregate contribution | dedupe report |
| Poison | unknown/invalid durable item | lease/state timeline | quarantined boundedly; later valid item progresses | timeline |
| Disk pressure | quota at each cut point | bytes/inventory | no silent loss/cursor-ahead; controlled stop/defer | inventory timeline |
| Outage | compressed logical schedule | retry trace | declared bounded concurrency/backoff; exact eventual set | schedule/result |
| Restore | snapshots + acknowledged set | set digests/readiness | exact acknowledged set once; no visibility early | restore evidence |
| Deletion | active/derived/cache/restore | scope queries | zero visible scope and verified tombstone/audit | deletion evidence |
| Migration | every supported version pair | before/after hashes | declared losslessness/rejection exactly; no downgrade surprise | migration report |
| Accessibility | JSON, text, HTML report | keyboard/screen-reader/manual + automated | status/errors understandable without color; labels/order/heading semantics | accessibility checklist |
| Cleanup | nested paths, reparse/traversal attacks | filesystem monitor | only declared sandbox removed; zero residue; attacks refused | before/after inventory |

## 8.5 Property-based and fuzz campaigns

Property tests complement fixed packages. Every failure emits:

- tool/version/package hash;
- initial and minimized seed/reproducer;
- generator/oracle/schema revisions;
- exact environment;
- classification (normally T1);
- expected/actual diff;
- cleanup status.

Minimum properties:

1. normalization and canonicalization are idempotent;
2. serialize/parse preserves the logical model where round-trip is declared;
3. independent scenario order does not change root;
4. tenant policy output is a subset of product ceiling;
5. adding a realm cannot change another realm’s generated IDs/data;
6. adding an unrelated scenario does not shift existing stream outputs;
7. duplicate input never increases final business-effect cardinality;
8. cursor equals the maximum contiguous represented position under the declared gap rule;
9. no rejected/deferred input creates a forbidden durable effect;
10. receipt implies durable custody row, never the reverse semantic states;
11. deletion is monotonic for visibility across retries/restores;
12. any raw canary is absent from post-minimization values and diagnostics.

Fuzz targets:

- manifest/NDJSON parser and duplicate-key handling;
- URL/site minimizer and Unicode/IDN processing;
- source-generation fingerprint parser;
- batch/receipt parser and decompression limits;
- migration reader;
- canary scanner decoder;
- report encoder/exporters;
- path/package extraction and cleanup logic.

Fuzz inputs are bounded; decompression bombs, recursive JSON, huge lengths, and pathological regex cases have explicit limits. Network access is disabled. A crash, timeout, memory limit, or inconsistent result is a finding; no input is silently discarded.

## 8.6 Data-quality and reproducibility acceptance tests

A dataset revision cannot be approved unless all applicable checks pass:

- required entity counts and declared distributions match exactly;
- every realm-owned row has a valid realm relationship;
- all IDs match prefix/length/digest lineage and are unique in scope;
- all natural keys are explicit and collision-free;
- every source input maps to at least one expected-result row, including zero-effect cases;
- every cursor transition is justified by durable event/progress truth;
- every batch event exists exactly once at one ordinal;
- receipt and inbox state relationships are valid;
- deletion/migration cases have terminal expected outcomes;
- no unapproved field appears in schema or payload;
- all canary allowed locations are exact and all forbidden sinks are scanned;
- canonical hashes match two verification paths;
- cross-environment generation matches byte-for-byte;
- package root, dependency lock, source revision, schema, generator, and oracle digests are recorded;
- generated SQLite passes `integrity_check` and `foreign_key_check` and reports native source ID;
- cleanup inventory is empty for declared ephemeral scopes.

# 9. Architecture fitness functions and measurable acceptance criteria

Fitness functions are automated unless marked human review. A failure blocks the stated gate; a waiver cannot convert failure into proof.

| ID | Fitness function | Measurement | Acceptance criterion | Frequency / gate owner |
|---|---|---|---|---|
| FF-001 | Mandatory governance metadata | Schema + registry query | Every revision has classification, provenance, expected-result authority, owner, and deletion method; T2/T3 also have unexpired approvals and access/expiry | Every generate/publish; Test Data Steward |
| FF-002 | No production-derived T1 value | Provenance graph + scans + review | Every T1 lineage root is fictional; no unknown/controlled parent; zero critical/high scan findings outside exact allowlist | Every revision; Data Steward + AppSec |
| FF-003 | Deterministic canonical bytes | Cross-matrix root comparison | Same source, manifest, seed, schemas, and lock digest produce byte-identical canonical files and package root in every supported matrix cell | Every generator/runtime update; Test Architecture |
| FF-004 | Stream stability | Golden hash vectors | Existing stream/index vectors remain unchanged within generator major | Every commit; Test Architecture |
| FF-005 | Independent truth | Build dependency graph and process ACL | Oracle has no forbidden production-project reference and cannot read actual output before truth root finalization | Every build; Oracle Maintainer |
| FF-006 | Complete truth coverage | Causal input/result join | Exactly one primary expected result per causal step; no implicit `don’t care`; zero orphan truth rows | Every package; Oracle Maintainer |
| FF-007 | Oracle mutation strength | Mutation campaign | All mandatory privacy, realm, session, cursor, dedupe, receipt, deletion, and schema-precedence mutations are killed | Every oracle/contract change; Gate Owner |
| FF-008 | Privacy ceiling monotonicity | Set/subset evaluation | Effective tenant policy is a subset of product ceiling for every scenario; any widening receives stable rejection | Every policy fixture and release; Privacy Owner |
| FF-009 | Canary containment | Exact multi-sink scan | Zero forbidden canary occurrences after the declared endpoint boundary or in diagnostics/transport; scanner self-test detects every planted mandatory marker | Every test run; Privacy + AppSec |
| FF-010 | Schema field minimization | Schema diff + payload validation | Every post-boundary field is in the active allowed-field set; no unknown or raw field | Every build/run; Schema + Privacy Owner |
| FF-011 | Session isolation | Cross-session effect query | Zero foreign source opens that succeed and zero foreign canary/effect; all denied attempts have stable code | G1 and every Windows/session change; Endpoint Security |
| FF-012 | Realm isolation | Auth-context and data query | Zero row, receipt, materialization, audit, deletion, or visibility effect in a realm not bound by trusted authentication | G1/G8 and every ingestion change; AppSec/Ingestion |
| FF-013 | Cursor durability | Per-cutpoint recovery query | For every committed cursor position, a durable event or approved progress marker exists in the same transaction; no cursor-ahead state | G5, every endpoint persistence change; Endpoint Data |
| FF-014 | SQLite integrity and version | Runtime source ID + PRAGMAs | Native SQLite source ID is recorded and approved; foreign keys enabled on every connection; `integrity_check` returns `ok`; `foreign_key_check` returns no rows | Every package/runtime/provider update; Endpoint Data + Build Security |
| FF-015 | Safe browser snapshot | Snapshot/digest/file trace | Each lock state yields a consistent expected snapshot or defer; zero raw live main/WAL/SHM copy path | G2 and browser/SQLite update; Browser Owner |
| FF-016 | Batch determinism and bounds | Byte comparison and limits | Same event membership/order contract yields same batch ID/digest/bytes; declared test limits never exceeded or silently truncated | Every endpoint upload change; Endpoint Owner |
| FF-017 | Receipt durability | Receipt-to-custody query | Every issued receipt resolves to the exact durable batch in the declared failure domain after crash/restart | G8 and storage/failover changes; Ingestion/DBA |
| FF-018 | Idempotent business effect | Dedupe/materialization counts | Replaying any accepted event/batch schedule produces exactly one final effect and one aggregate contribution | G8–G11; Data Owner |
| FF-019 | Poison isolation | Queue state/progress | Poison reaches bounded quarantine; valid later work progresses; no hot lease loop | G8; Ingestion/SRE |
| FF-020 | No silent pressure loss | Inventory reconciliation | Expected unacknowledged event/batch set equals actual under disk/outage faults; removal only after approved acknowledgement/retirement | G10; Endpoint/SRE |
| FF-021 | Restore fidelity | Set digests | Acknowledged event set after restore equals before exactly, with one effect each; service remains not-ready on mismatch | G11; DBA/SRE |
| FF-022 | Deletion monotonicity | Visibility/tombstone queries | Deleted synthetic scope is not visible before or after restore; deletion evidence and audit exist | G11; Privacy/Data Owner |
| FF-023 | Metric cardinality | Static label lint + series count | No forbidden label keys; series set is within reviewed finite Cartesian product and does not grow with device/account/event count | Every instrumentation change and G9/G10; Observability/SRE |
| FF-024 | Privacy-safe errors | Error-template scan | All errors use registered stable code/template; no source value or free-text exception is emitted to forbidden sinks | Every build/run; AppSec |
| FF-025 | Catalogue-shape fidelity | Independent profiler | Exactly 173 records; 173 CI-unique non-empty names; 0 missing names; 5 missing refs; 168 distinct non-empty refs; 0 duplicate non-empty refs; 10 non-ASCII names; 9 truncation-like endings; 1 IPv4-like name | Every catalogue-shaped revision; Data Steward |
| FF-026 | No semantic invention from catalogue | Schema/lineage field check | Catalogue-shaped fixture contains no inferred role, OU, owner, lifecycle, sensitivity, URL/domain, process/publisher/product, alias, entitlement, or usage dimension | Every catalogue-shaped revision; Data Steward + Reviewer |
| FF-027 | Migration compatibility | Golden corpus | Every supported version pair has exact accept/reject/upconvert result and before/after digest; no undeclared loss/downgrade | Every schema change; Schema Owner |
| FF-028 | Package immutability | Root verification | Any byte change changes file/root hash and invalidates approval; published revision cannot be overwritten | Every read/publish; Build Ops |
| FF-029 | Cleanup confinement | Filesystem inventory | Cleanup removes all declared ephemeral scopes and nothing outside sandbox, including under traversal/reparse attacks | Every run and cleanup change; Test Infrastructure |
| FF-030 | Accessibility | Report checks | Machine-readable JSON always produced; text status usable without color; applicable report targets WCAG 2.2 AA/WCAG2ICT review with no blocking issue | Every report UI change; Accessibility Owner |
| FF-031 | Dependency provenance | Lock/SBOM/hash/advisory report | Every dependency/tool has exact version, artifact hash, source/license, and review status; unpinned/floating/unapproved component blocked | Every restore/build; Build Security |
| FF-032 | Evidence completeness | Evidence-pack schema | Setup, versions, environment, steps, actual duration, pass/fail, raw-safe evidence digests, and cleanup status present; unexecuted cases explicit | Every gate; Gate Owner |

## 9.1 Machine-checkable top-level G0 gate

G0 passes only if all are true:

```text
G0_PASS =
    FF-001 && FF-002 && FF-003 && FF-004 && FF-005 && FF-006 &&
    FF-007 && FF-008 && FF-009 && FF-010 && FF-014 && FF-023 &&
    FF-024 && FF-025 && FF-026 && FF-028 && FF-029 && FF-031 && FF-032
```

Where a fitness function is inapplicable to a particular minimum fixture, the package declares `notApplicable` with a contract-defined reason and reviewer; it may not omit the result. `notRun`, `inconclusive`, and timeout are not passes.

## 9.2 Data-quality thresholds

The following criteria are exact rather than percentage-based:

- zero missing mandatory manifest fields;
- zero unknown provenance roots;
- zero unowned records or artifacts;
- zero causal inputs without expected result;
- zero duplicate entity IDs/natural keys outside explicit duplicate-attack inputs;
- zero cross-realm foreign-key or logical references;
- zero critical/high canary findings outside exact allowed source paths;
- zero post-minimization forbidden fields;
- zero oracle reconciliation mismatches;
- zero cursor-ahead states;
- zero orphan receipts;
- exactly one final business effect per stable dedupe identity;
- zero visible deleted-scope records;
- zero forbidden metric label keys;
- zero undeclared residual cleanup paths.

Declared statistical distributions are tested using their exact generated counts for fixed packages. Exploratory property/fuzz distributions report sample count and seed but do not claim production representativeness.

## 9.3 Performance/cost fitness without invented production targets

**UNKNOWN.** No approved event/byte/rate/retry/outage distribution, resource budget, or SLO is supplied. Therefore G0 may enforce only algorithmic and safety bounds:

- generation memory must be measured and reported by entity count and package bytes;
- a package parser must enforce declared maximum nesting, string, record, file, and decompressed bytes selected by implementation review;
- the 6,000-device smoke must complete without correctness failure on declared hardware, and actual duration/CPU/memory/disk must be recorded;
- any proposed CI time/cost budget is a **HUMAN DECISION** after the first measured run;
- no pass statement may use “production capacity,” “SLO met,” or equivalent without approved parameter evidence and a benchmark ADR.

## 9.4 Fitness-function implementation pattern

Each function emits a record:

```json
{
  "fitnessFunctionId": "FF-013",
  "datasetId": "ds_jx2f4e7gmrw3h5qbn6ytkacpzu",
  "revision": 1,
  "gate": "G5",
  "status": "pass",
  "measuredAt": "2042-03-04T06:00:00Z",
  "tool": {
    "name": "Uam.TestData.Verify",
    "version": "1.0.0",
    "sourceRevision": "git:REPLACE_AT_BUILD",
    "artifactDigest": "sha256:REPLACE_WITH_64_HEX"
  },
  "evidence": [
    {"path":"reports/g5/cursor-cutpoints.json","digest":"sha256:REPLACE_WITH_64_HEX"}
  ],
  "summary": {
    "cutpointsExecuted": 37,
    "cursorAheadCount": 0,
    "integrityFailures": 0
  }
}
```

A human approval references the digest of these machine results rather than a mutable dashboard.

---

# 10. Human decisions and owner questions

Research must not decide the following. The temporary defaults minimize collection and access while allowing T1 implementation to start.

## 10.1 Approved purposes and prohibited uses

| Option | Consequence | Conservative temporary default | Accountable role | Questions requiring decision |
|---|---|---|---|---|
| Approve narrowly enumerated operational/security purposes and explicit prohibited uses | Enables policy fixtures and purpose-bound access tests; requires change governance and employee/legal consultation | T1 tests describe only technical behavior; no real-person inference, productivity scoring, disciplinary ranking, covert surveillance, or sole-forensic-proof use is treated as approved | Business Data Controller / Product Owner with Privacy, Legal, Security, Employee Relations/Works Council as applicable | What exact purpose authorizes each source/output? Which decisions may never rely on UAM? What notice/consultation is required? Who approves a new source/field/use? |
| Broad/general monitoring purpose | Easier implementation wording but high misuse, legal, trust, and minimization risk; weak testable boundary | Do not adopt | Same | What narrower purpose cannot meet the need, and what evidence supports necessity/proportionality? |
| No approved purpose yet | Blocks T2/T3/live collection but not T1 architecture work | **Default** | Product/Business Authority | What is needed to obtain approval, and what is the stop date if absent? |

## 10.2 Whether any real application names may be used internally

| Option | Consequence | Conservative temporary default | Accountable role | Questions |
|---|---|---|---|---|
| T1 fictional names only | Lowest leak/inference risk; may miss some exact legacy-name parsing defects | **Default for committed fixtures and all research outputs** | Catalogue/Data Owner + Privacy Owner | Are there defects that cannot be represented by fictional Unicode/length/punctuation shapes? |
| Approved real names in T2 | Better exact import/migration validation; creates internal access, retention, provenance, and deletion obligations; may reveal internal technology/business context | Not allowed until approved | Catalogue Owner + Data Steward + Security | Which exact names, purpose, users, repository, expiry, and deletion? Are names confidential or linked to entitlements/people? |
| Real names only in isolated T3 measurement | Narrowest exact-value test lane but operationally expensive | Disabled until approved | Same plus Lab Owner | Can a hash/shape assertion answer the question instead? Who sees results? |

Regardless of option, no role, entitlement, owner, purpose, matching rule, or usage may be inferred from a name.

## 10.3 Role/persona truth and access ownership

| Option | Consequence | Conservative temporary default | Accountable role | Questions |
|---|---|---|---|---|
| Fictional roles/personas as test composition only | Supports boundary and UI testing without claiming organization truth | **Default** | Test Architecture | Is the UI clear that these are synthetic? |
| Governed authoritative role/persona reference | Enables real entitlement/use-case tests but requires source authority, change process, lawful purpose, access, retention, reconciliation | Not used until owner and contract approved | HR/Directory/IGA/Business Data Owner as applicable | What system is authoritative? Who owns errors? What realm scope and identity level are permitted? |
| No role/persona model | Simplifies privacy; may limit role-based portal testing | Acceptable until a real requirement exists | Product Owner | Which approved requirement requires role mapping? |

The data model therefore makes role/persona optional and marks all G0 values `fictional-test-group-only`.

## 10.4 Retention and controlled evidence policy

| Option | Consequence | Conservative temporary default | Accountable role | Questions |
|---|---|---|---|---|
| Source-controlled T1 canonical fixtures; short-lived generated artifacts | Reproducible, low data risk; CI/storage costs still need policy | Retain reviewed T1 source under repository policy; delete work stores after each run; evidence summaries follow build policy | Engineering/Build Owner | Which T1 files are long-lived source, which generated artifacts are ephemeral, and what build-cache/backup expiry applies? |
| Time-limited T2 | Supports aggregate-shaped fidelity; requires expiry, access, deletion, derivative control | No T2 publication without explicit expiry/event trigger and deletion verification | Data Steward + Evidence Owner | What purpose, expiry event, derivative scope, backup treatment, and deletion verifier are approved? |
| Time-limited T3 | Provides measurements; highest governance and operational cost | Collect nothing until approved; then delete immediately after evidence acceptance or approved expiry, whichever is earlier, subject to legal requirements | Data Controller/Privacy + Measurement Owner | What minimum measurements are authorized, who may access them, and what proves raw and derived deletion? |
| Indefinite T2/T3 archive | Convenient comparison but accumulates disclosure and ownership risk | Do not adopt without explicit authority and necessity | Senior Data Owner | What continuing purpose requires retention? How are backups/derived models handled? |

Questions:

- What are the retention triggers for canonical fixtures, generated DBs, logs, captures, crash inputs, benchmark outputs, CI artifacts, caches, and backups?
- Does deletion mean access revocation, logical erasure, physical erasure, cryptographic erasure, or a documented backup-expiry process for each store?
- Who verifies deletion and owns failures?

## 10.5 Other human-owned decisions exposed by G0

| Decision | Options and consequence | Temporary default | Accountable role |
|---|---|---|---|
| Identity level in minimized events | anonymous/realm-pseudonymous/session/account/device-linked; stronger linkage increases utility and privacy risk | Use synthetic IDs in tests; do not select production identity | Product + Privacy/Data Controller |
| Time precision and lookback | coarse buckets reduce sensitivity; fine time/lookback increases utility/storage/privacy | Fixed fictional clock with scenario-declared precision; no production decision | Product + Privacy + Endpoint Owner |
| Hard-deny categories | explicit deny improves containment but requires approved taxonomy and progress behavior | Test fictional deny cases; no production list claimed | Privacy/Product Owner |
| T3 aggregation thresholds | higher thresholds reduce singling-out but may reduce utility | No T3 collection | Privacy/Data Steward |
| CI/evidence artifact retention | longer aids debugging/audit but increases cost and exposure | shortest operationally useful period, exact value unset | Build Ops + Security |
| Metric cardinality budget | lower cost/privacy risk versus diagnostic detail | static bounded labels only; no identifier labels | Observability/SRE |
| Fuzzer and 6,000-device run budget | broader exploration versus runner cost | begin with measured smoke, then set budget | Engineering/Finance/Operations |
| Open-source dependency acceptance | speed/features versus supply-chain/skills/support | reference/test-only after proof and review; canonical core stays small | Architecture + Security + Legal |
| Production engine/benchmark criteria | operations, licensing, skills, restore, performance | not decided by G0 | Architecture Review Board + DBA/SRE + Procurement |

---

# 11. CLI experiments/measurements and the exact evidence they must produce

Commands use placeholders and local paths only. They do not request or expose internal addresses, credentials, SSH configuration, or production data.

## 11.1 Proposed repository layout

```text
src/
  Uam.TestData.Contracts/
  Uam.TestData.Generator/
  Uam.TestData.Oracle/          # separate project and code owners
  Uam.TestData.Scanner/
  Uam.TestData.Materializer/
  Uam.TestData.Reconciler/
  Uam.TestData.Cli/
tests/
  Uam.TestData.UnitTests/
  Uam.TestData.ContractTests/
  Uam.TestData.OracleMutationTests/
  Uam.TestData.PropertyTests/
  Uam.TestData.FuzzTargets/
  Uam.TestData.WindowsLabTests/
datasets/
  t1/
  t2-protected/                 # separate access; may be separate repository
schemas/
config/
tools/
results/
```

## 11.2 Restore and provenance gate

```powershell
$ErrorActionPreference = 'Stop'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_NOLOGO = '1'

# Versions are selected at execution time and locked in the repository.
dotnet --info | Tee-Object artifacts/environment/dotnet-info.txt
dotnet restore --locked-mode --force-evaluate
dotnet list package --include-transitive --format json `
  > artifacts/environment/packages.json

# Generate SBOM/provenance with the organization-approved pinned tool.
# Tool name/version/hash must be captured; no floating install is allowed.
```

Required evidence:

- `dotnet-info.txt` with no internal path/user leakage after redaction validation;
- lockfile digest and dependency list;
- exact tool/package versions and artifact hashes;
- license inventory and advisory scan result;
- source revision and clean-worktree status;
- proof that the selected .NET line is supported on the review date.

**Pass:** locked restore succeeds and every component is approved/pinned.  
**Fail:** floating dependency/action, missing hash/license/source, unsupported runtime, or unredacted environment identifier.

## 11.3 Generate a canonical package

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  generate `
  --manifest datasets/t1/g4-canary-ceiling/manifest.json `
  --output artifacts/packages/g4-canary-ceiling-r1 `
  --evidence artifacts/evidence/generate-g4.json `
  --fail-if-output-exists
```

Required evidence `generate-g4.json`:

- dataset ID/revision/classification/owner/deletion method;
- manifest/schema/scenario/generator/lock digests;
- seed identifier and fixed clock (not a secret);
- entity/file/byte counts;
- start/end/actual elapsed using evidence clock, while canonical data uses fixed clock;
- canonical file digests and root;
- warnings (must be empty for publishable package);
- temp-directory cleanup state.

**Pass:** immutable complete package and evidence; no placeholders; no partial path.  
**Fail:** warning-only governance defect, hash collision, nondeterminism, or residual temp path.

## 11.4 Verify deterministic hashes

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  verify `
  --package artifacts/packages/g4-canary-ceiling-r1 `
  --recompute-jcs `
  --recompute-root `
  --verify-lineage `
  --verify-truth-coverage `
  --output artifacts/evidence/verify-g4.json

# A clean second generation must compare byte-for-byte.
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  generate --manifest datasets/t1/g4-canary-ceiling/manifest.json `
  --output artifacts/repro/g4-second --fail-if-output-exists

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  compare-packages `
  --left artifacts/packages/g4-canary-ceiling-r1 `
  --right artifacts/repro/g4-second `
  --canonical-only `
  --output artifacts/evidence/repro-g4.json
```

Required evidence:

- two independently computed JCS/root results;
- exact file comparison;
- stream/hash test-vector results;
- environment matrix cell;
- zero lineage/truth gaps.

## 11.5 Run canary and leak scans

```powershell
# UAM exact/schema-aware scanner is mandatory.
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  scanner-selftest `
  --corpus datasets/t1/g0-canary-selftest-v1 `
  --rules config/canary-rules.v1.json `
  --output artifacts/evidence/scanner-selftest.json

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  scan `
  --package artifacts/packages/g4-canary-ceiling-r1 `
  --rules config/canary-rules.v1.json `
  --scope repository,package,stdout,stderr,test-results,logs,traces,metrics,sqlite-dumps,http-captures,crash-artifacts `
  --output artifacts/evidence/canary-scan-g4.json

# Pinned, checksum-verified Gitleaks binary; illustrative path only.
& tools/gitleaks/<PINNED-VERSION>/gitleaks.exe dir . `
  --config config/gitleaks-uam.toml `
  --report-format json `
  --report-path artifacts/evidence/gitleaks.json `
  --redact
```

Required evidence:

- self-test finding for every planted canary/rule/encoding;
- exact UAM scanner findings with sink/path and redacted marker ID;
- Gitleaks version, binary checksum, config digest, and report;
- allowlist entries with canary ID, exact path, purpose, owner, expiry;
- zero critical/high findings outside allowed source locations.

An unavailable scanner or self-test failure blocks the run; it is not a warning.

## 11.6 Build and verify ephemeral SQLite

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  materialize-sqlite `
  --package artifacts/packages/g4-canary-ceiling-r1 `
  --database artifacts/work/g4/uam-test.db `
  --output artifacts/evidence/materialize-g4.json

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  sqlite-check `
  --database artifacts/work/g4/uam-test.db `
  --require-foreign-keys-on `
  --integrity-check `
  --foreign-key-check `
  --require-approved-source-id config/approved-sqlite-source-ids.json `
  --output artifacts/evidence/sqlite-check-g4.json
```

Required evidence:

- managed provider/package identity and native `sqlite_source_id()`/version;
- journal/synchronous/foreign-key pragma values;
- integrity and foreign-key results;
- database/WAL/SHM sizes and hashes where safe;
- materialized counts matching package;
- cleanup path token.

**CLI EXPERIMENT.** The implementation gate must run WAL reset/checkpoint/crash regression tests against the actual native library. SQLite’s 2026 release history documents a WAL-reset corruption bug fixed in 3.51.3 and 3.53.0; a managed package name alone is insufficient evidence. [W2](#w2)

## 11.7 Execute a scenario and reconcile truth

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  execute `
  --package artifacts/packages/g4-canary-ceiling-r1 `
  --lane endpoint-simulated `
  --actual artifacts/actual/g4 `
  --fault-schedule scenarios/g4/faults.ndjson `
  --output artifacts/evidence/execute-g4.json

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  reconcile `
  --truth artifacts/packages/g4-canary-ceiling-r1/truth `
  --actual artifacts/actual/g4 `
  --require-exact-ids `
  --require-zero-extra `
  --require-all-steps-executed `
  --output artifacts/evidence/reconcile-g4.json
```

Required evidence:

- exact package root and executable/release digest;
- every scenario/fault step attempted and state transition observed;
- expected vs actual by causal ID;
- missing/extra/wrong outcome/state/cursor/field counts;
- forbidden-marker scan per sink;
- actual duration and bounded resource measurements;
- stable error codes only.

**Pass:** all mismatch counts zero and all mandatory steps executed.  
**Fail:** approximate join, skipped step, timeout, scanner finding, missing evidence, or any mismatch.

## 11.8 Crash-cutpoint experiment

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  enumerate-cutpoints `
  --contract g5-event-cursor-v1 `
  --output artifacts/g5/cutpoints.json

dotnet test tests/Uam.TestData.WindowsLabTests -c Release --no-restore -- `
  --filter "Category=G5CrashInvariant" `
  --logger "trx;LogFileName=g5-crash.trx" `
  --results-directory artifacts/test-results

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  reconcile-cutpoints `
  --truth datasets/t1/g5-crash-cutpoints-v1/truth `
  --actual-root artifacts/g5/cutpoint-runs `
  --output artifacts/evidence/g5-cutpoints.json
```

Required evidence per cut point:

- fault ID and exact boundary;
- process exit/fault method;
- pre/post DB digests and source ID;
- event/progress/cursor/batch queries after reopen;
- integrity/FK results;
- replay result;
- cleanup.

No test command includes real connection values. Lab launch is handled outside the evidence and redacted before attachment.

## 11.9 Property and fuzz experiments

```powershell
dotnet test tests/Uam.TestData.PropertyTests -c Release --no-restore -- `
  --logger "trx;LogFileName=property.trx" `
  --results-directory artifacts/test-results

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  fuzz `
  --target manifest-parser `
  --corpus datasets/t1/fuzz/manifest `
  --time-budget-seconds 300 `
  --memory-limit-mib 1024 `
  --network disabled `
  --crash-output artifacts/fuzz/manifest `
  --evidence artifacts/evidence/fuzz-manifest.json
```

The shown budgets are **ESTIMATE** smoke settings, not permanent acceptance values. Required evidence includes exact tool version/hash, seed, iterations/executions, coverage metric supported by the chosen tool, minimized reproducers, crash/timeout/resource findings, and sandbox cleanup. A random failure without a saved reproducer fails the toolchain requirement.

## 11.10 Catalogue profile experiment

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  generate `
  --manifest datasets/t2-protected/g0-catalogue-shape-173-v1/manifest.json `
  --output artifacts/t2/catalogue-shape-r1 `
  --evidence artifacts/evidence/catalogue-generate.json

dotnet run --project tools/Uam.CatalogueShapeProfiler -c Release --no-restore -- `
  --input artifacts/t2/catalogue-shape-r1/model/applications.ndjson `
  --expected datasets/t2-protected/g0-catalogue-shape-173-v1/expected-profile.json `
  --reject-semantic-fields `
  --output artifacts/evidence/catalogue-profile.json
```

Exact evidence:

- safe aggregate counts listed in FF-025;
- list of schema fields proving absence of semantic dimensions;
- lineage showing fictional vocabulary selection;
- classification approval/expiry/deletion;
- scan results and cleanup receipt.

The profiler must be independent of the generator’s count assertions.

## 11.11 6,000-device structural smoke

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  generate-load `
  --devices 6000 `
  --batches-per-device 1 `
  --events-per-batch 10 `
  --distribution datasets/t1/g9-6000-structural-smoke-v1/distribution.json `
  --classification T1-FICTIONAL-COMMITTED `
  --label structural-smoke-not-capacity-proof `
  --output artifacts/load/g9-6000 `
  --evidence artifacts/evidence/g9-generation.json

dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  reconcile-load `
  --truth artifacts/load/g9-6000/truth `
  --actual artifacts/load/g9-6000/actual `
  --metrics artifacts/load/g9-6000/metrics.prom `
  --output artifacts/evidence/g9-reconcile.json

# Pinned Prometheus tool if Prometheus exposition is used.
& tools/prometheus/<PINNED-VERSION>/promtool.exe check metrics --extended `
  < artifacts/load/g9-6000/metrics.prom `
  > artifacts/evidence/promtool-g9.txt
```

Required evidence:

- exact input formula and generated counts;
- classification/provenance/root;
- declared hardware/OS/runtime/database configuration;
- actual duration, CPU, peak memory, disk, bytes, retries, queue depth;
- exact accepted/duplicate/quarantined/materialized/visible counts;
- metric label inventory and series/cardinality analysis;
- banner that no capacity/SLO conclusion is made.

## 11.12 Cleanup and deletion verification

```powershell
dotnet run --project src/Uam.TestData.Cli -c Release --no-restore -- `
  cleanup `
  --evidence-pack artifacts/evidence/execute-g4.json `
  --dry-run-output artifacts/evidence/cleanup-plan-g4.json `
  --execute `
  --verify-absent `
  --output artifacts/evidence/cleanup-result-g4.json
```

Required evidence:

- canonical allowed cleanup root and non-reusable run token;
- before inventory and digest;
- dry-run paths;
- reparse/symlink/traversal validation;
- deleted/failed/missing paths;
- artifact-store deletion receipt where applicable;
- after inventory with zero undeclared residue;
- evidence that canonical T1 source was not removed unless explicitly requested.

A failed cleanup does not rewrite a functional pass; the gate remains failed/incomplete and ownership escalates.

## 11.13 Evidence-pack schema

Every experiment emits one package:

```text
evidence/<gate>/<run-id>/
  run.json
  environment.json
  inputs.json
  versions-and-hashes.json
  steps.ndjson
  actual-summary.json
  reconciliation.json
  scans/
  metrics/
  integrity/
  cleanup.json
  hashes.sha256
```

`run.json` records:

- dataset/revision/root and proof gate;
- claim tested and linked fitness functions;
- classification and owner;
- setup and exact commands with sensitive arguments omitted/redacted at source;
- start/end/actual elapsed;
- result `pass|fail|inconclusive|not-run`;
- evidence files/digests;
- known limitations;
- cleanup/deletion status;
- reviewer and approval digest.

# 12. ADR proposals

These ADRs are proposed. Approval belongs to the named accountable role/architecture forum. None changes the accepted UAM baseline.

## ADR-G0-001 — Three-tier test-data classification

- **Decision:** Every dataset uses T1 fictional committed, T2 sanitized organization-shaped, or T3 controlled measured evidence. Classification follows the most sensitive parent. Publication requires provenance, expected-result authority, owner, and deletion method.
- **Status:** Proposed; required for G0.
- **Alternatives:** unclassified “test data”; production subset; row-level anonymization; one shared internal tier.
- **Rationale:** Makes permitted values, access, retention, and proof claims explicit; stops synthetic labels from hiding production-derived data.
- **Evidence:** accepted minimization/synthetic-first baseline [P1](#p1); catalogue limits [P2](#p2); research boundaries [P4](#p4).
- **Owner:** Test Data Steward with Product Privacy approval.
- **Review trigger:** new data source, any T3 request, evidence of excessive governance cost, or a classification incident.

## ADR-G0-002 — UAM-owned deterministic generator contract

- **Decision:** Canonical fixtures use domain-separated SHA-256 streams, fixed logical clock, exact integer distributions, stable digest-derived IDs, NFC model strings, and canonical serialization. Third-party faker/PRNG behavior is not canonical.
- **Status:** Proposed; required for G0.
- **Alternatives:** `System.Random`; GUID/current-time IDs; faker-sequence contract; committed binary DB snapshots.
- **Rationale:** Reproducible, order-independent, explainable, cross-platform, and minimally dependent.
- **Evidence:** JCS need for invariant bytes [W5](#w5); Unicode normalization [W7](#w7); open-source generator drift caveats in section 14.
- **Owner:** Test Architecture.
- **Review trigger:** collision, cross-platform hash failure, performance evidence showing an unacceptable cost, or a standard deterministic-ID proposal with superior migration/interop evidence.

## ADR-G0-003 — Independent reference oracle and truth ledger

- **Decision:** A separately owned pure model calculates expected outcomes/states/cursor transitions before test execution. It does not call production decision code.
- **Status:** Proposed; required for G0.
- **Alternatives:** production-generated expectations; snapshots only; manual spreadsheets; statistical similarity.
- **Rationale:** Detects common implementation defects and represents rejection, defer, duplicate, receipt, quarantine, deletion, and zero-effect outcomes explicitly.
- **Evidence:** accepted cursor/idempotency/receipt/realm invariants [P1](#p1) and target state separation [P3](#p3).
- **Owner:** Oracle Maintainer / independent code owner.
- **Review trigger:** mutation survivors, excessive duplicate logic, contradictory requirements, or a formal model tool proof-of-fit.

## ADR-G0-004 — Canonical JSON/NDJSON package with generated ephemeral SQLite

- **Decision:** JSON/NDJSON under JSON Schema 2020-12 is canonical source; JCS + SHA-256 define roots; SQLite/source databases are generated and short-lived.
- **Status:** Proposed.
- **Alternatives:** committed SQLite binaries; custom binary format; central test-data service.
- **Rationale:** Reviewable diffs, language-neutral contracts, stable hashing, simple offline operation, and explicit physical-store tests.
- **Evidence:** JSON Schema [W4](#w4), JCS [W5](#w5), SQLite backup/WAL constraints [W3](#w3) [W20](#w20).
- **Owner:** Schema Owner + Test Infrastructure.
- **Review trigger:** package size or generation time exceeds an approved budget, or binary artifacts are needed for a proven engine bug and remain derivable with hashes.

## ADR-G0-005 — Catalogue profile informs shape only

- **Decision:** Reproduce the safe 173-record aggregate/quality profile using fictional values and UAM-owned IDs. Do not copy values or infer semantics/role mappings.
- **Status:** Proposed; required for the catalogue-shaped T2 fixture.
- **Alternatives:** raw catalogue fixture; invented role/application mapping; ignore measured shape.
- **Rationale:** Preserves useful import/quality stress while respecting the evidence’s explicit limitations.
- **Evidence:** sanitized catalogue report [P2](#p2).
- **Owner:** Data Steward + Catalogue Evidence Owner.
- **Review trigger:** a new approved sanitized profile, permission to use specific values, or a changed catalogue import contract.

## ADR-G0-006 — Mandatory canary and multi-layer leak gate

- **Decision:** UAM exact canaries and schema-aware scanning are mandatory; pinned secret scanning is secondary; optional offline PII heuristics never act as sole proof.
- **Status:** Proposed.
- **Alternatives:** manual review only; Gitleaks only; ML PII scanner only.
- **Rationale:** Exact markers prove scanner operation for known test values while independent patterns catch accidental classes; no one detector proves absence.
- **Evidence:** logging/privacy sink risks [W14](#w14); Gitleaks and Presidio assessments in section 14.
- **Owner:** Product Privacy + AppSec.
- **Review trigger:** leak incident, false-negative corpus, scanner maintenance transition, new sink/encoding, or unacceptable CI cost.

## ADR-G0-007 — Strict realm/session ownership in every fixture and truth row

- **Decision:** Realm is present in every realm-owned logical/physical relation; session-owned sources bind to one synthetic session; test server context comes from authentication, not payload claims.
- **Status:** Proposed; derived from accepted baseline.
- **Alternatives:** globally unique IDs without realm columns; payload-supplied tenancy; profile crawling.
- **Rationale:** Makes isolation mechanically testable and prevents globally unique IDs from masking missing tenant predicates.
- **Evidence:** accepted endpoint/session and realm invariants [P1](#p1); target data principles [P3](#p3).
- **Owner:** AppSec + Endpoint/Ingestion Owners.
- **Review trigger:** realm model change, shared/global entity proposal, or cross-tenant incident.

## ADR-G0-008 — Execution-time supported dependency selection

- **Decision:** Architecture names capability/lifecycle requirements, while each implementation/release pins then-supported .NET, SQLite/provider, validators, and test tools with hashes, licenses, source mapping, and regression evidence.
- **Status:** Proposed.
- **Alternatives:** timeless patch numbers; floating latest versions; unmanaged transitive native library.
- **Rationale:** Patches and advisories change; managed package version may not prove native SQLite code; support requires current servicing.
- **Evidence:** .NET policy dated 14 July 2026 [W1](#w1); SQLite 2026 release/WAL fix history [W2](#w2).
- **Owner:** Build Security + Component Owners.
- **Review trigger:** every release/dependency update, support lifecycle change, advisory, or native-source mismatch.

## ADR-G0-009 — Receipt, semantic state, and visibility truth are separate

- **Decision:** The oracle and schemas distinguish durable custody, validation, quarantine, materialization, and visibility. Receipts prove only durable custody.
- **Status:** Proposed; restates accepted baseline for testability.
- **Alternatives:** one `success` state; receipt equals accepted/visible.
- **Rationale:** Prevents false client claims and supports poison/repair/replay testing.
- **Evidence:** [P1](#p1) [P3](#p3).
- **Owner:** Ingestion/Data Owner.
- **Review trigger:** ingestion protocol major change or durable failure-domain change.

## ADR-G0-010 — T3 measurement lane disabled by default

- **Decision:** No controlled measurement collection runs until purpose, fields/aggregation, owner, access, expiry, deletion, and no-raw validation are approved. Derived parameters keep parent classification until reviewed.
- **Status:** Proposed.
- **Alternatives:** ad hoc pilot exports; permanent measurement store; automatic T1 promotion after aggregation.
- **Rationale:** Prevents “metadata” from becoming an ungoverned production-data path.
- **Evidence:** missing runtime distributions [P3](#p3); research limitations [P4](#p4).
- **Owner:** Data Steward + Privacy/Data Controller.
- **Review trigger:** first measurement request, owner/access change, retention change, or disclosure finding.

## ADR-G0-011 — Bounded observability schema

- **Decision:** Static allowlisted metric labels; no subject/realm/device/event/application identifiers; stable error codes and template logs; all telemetry is scanned.
- **Status:** Proposed.
- **Alternatives:** unrestricted dimensions; raw diagnostic payloads; rely only on backend cardinality limits.
- **Rationale:** Privacy-safe operations and predictable cost; backend limits are containment, not authorization.
- **Evidence:** OpenTelemetry and Prometheus guidance [W15](#w15) [W16](#w16), OWASP logging [W14](#w14).
- **Owner:** Observability/SRE + Privacy/AppSec.
- **Review trigger:** diagnostic gap, new backend, series overflow, cost event, or privacy incident.

## ADR-G0-012 — Open-source tools are test aids, not architecture owners

- **Decision:** Candidate repositories are assessed and pinned per section 14. Canonical generator/oracle remain UAM-owned. A tool can be dependency, reference only, or rejected after proof-of-fit.
- **Status:** Proposed.
- **Alternatives:** adopt one framework wholesale; ban all third-party test tools.
- **Rationale:** Gains shrinking/fuzz/scanning capabilities without inheriting unsuitable threat models, runtimes, sequence contracts, or maintenance risk.
- **Evidence:** section 14 repository review.
- **Owner:** Architecture + AppSec + Legal/Procurement as applicable.
- **Review trigger:** new release/advisory, maintenance stop, source/package provenance gap, or measured support burden.

---

# 13. Ordered implementation backlog with dependencies and stop gates

Priority order is deliberate. A failed stop gate blocks dependent items and opens an issue/ADR; teams must not bypass it by using later synthetic scenarios.

| Order | Repository task | Deliverable and acceptance | Dependencies | Owner | Stop gate |
|---:|---|---|---|---|---|
| 1 | Create evidence-label and source-register conventions | Markdown/JSON schema; linter for labels, unsupported claims, and structural-smoke banner | None | Research/Architecture | Missing evidence semantics blocks all |
| 2 | Create protected data-classification schema | Manifest classification/provenance/owner/deletion/approval schema and negative fixtures | 1 | Data Steward + Schema Owner | P0/FF-001 must pass |
| 3 | Establish code-owner separation | Separate generator/oracle projects and CODEOWNERS; forbidden dependency test | 1 | Engineering Manager + AppSec | Oracle importing production decision code blocks G0 |
| 4 | Implement canonical byte primitives | NFC ingress, length-prefix framing, SHA-256, base32, JCS, path/line-ending rules, official vectors | 2 | Test Architecture | Cross-implementation vectors must pass |
| 5 | Implement deterministic streams, IDs, clock, weights | Pure APIs, golden vectors, collision registry, no wall-clock/locale/RNG analyzer | 4 | Test Architecture | FF-003/004 and collision negative tests pass |
| 6 | Implement scenario graph/composer | Cycle/conflict/override rules, stable topological order, lineage | 5 | Test Architecture | Reordered independent scenarios same root |
| 7 | Implement canonical entity contracts | JSON Schemas and generated C# types for all logical entities | 2,4 | Schema Owner | Schema conformance and duplicate-key tests pass |
| 8 | Implement registry/gatekeeper | State machine, immutable revision, approval/expiry, revocation, audit | 2,7 | Data Steward + Build Ops | Invalid/unowned package cannot publish |
| 9 | Implement package writer/reader/root verifier | Layout, atomic publish, hashes, path security, immutability | 4–8 | Build Engineering | Byte tamper and partial publish tests pass |
| 10 | Hand-author minimal G0 package | One causal source/event/batch/receipt and complete truth skeleton | 7–9 | Test Architecture | Manual review agrees with schema/invariants |
| 11 | Implement independent oracle v1 | Policy subset, boundary, transform, outcomes, cursor, batch/receipt/inbox state interpreters | 3,7,10 | Oracle Maintainer | Every causal step has exact truth |
| 12 | Implement oracle mutation suite | Mandatory mutations for privacy/realm/session/cursor/dedupe/receipt/deletion | 11 | Gate Owner + AppSec | All mandatory mutations killed |
| 13 | Implement exact canary registry/scanner | Corpus, allowed/forbidden path/sink model, encoding decoder, self-test | 7,9 | Privacy + AppSec | Every planted mandatory canary detected |
| 14 | Add pinned Gitleaks lane | Verified release binary/source/checksum, custom config, redacted report | 13 + dependency review | Build Security | UAM scanner remains primary; tool unavailable blocks scan |
| 15 | Implement lineage and profile validator | Record/field lineage, parent-tier propagation, disclosure checks | 5–9 | Data Steward | Unknown parent/tier promotion fails |
| 16 | Generate catalogue-shaped T2 package | 173 fictional apps and independent profiler; no semantic fields | 6,7,8,13,15 + T2 approval | Data Steward | FF-025/026 exact pass or package revoked |
| 17 | Implement SQLite materializer | Reference DDL, pragmas, native source ID, integrity/FK checks, cleanup | 7,9 | Test Infrastructure | Unsupported/unapproved native source fails |
| 18 | Implement SQLite WAL regression/crash harness | Checkpoint/reset/contention and cut-point runner | 17 | Endpoint Data Owner | Known regression class and atomicity tests pass |
| 19 | Implement source-fixture sandbox | Per-session ACLs, fake Edge DB builder, safe temporary snapshots, no reparse traversal | 7,13,17 | Endpoint Test Owner | Cleanup confinement/session ACL tests pass |
| 20 | Implement reconciler/evidence pack | Exact joins, global invariants, scan aggregation, environment/version/cleanup schema | 9,11,13,17 | Test Architecture | Any skipped/missing/extra result fails |
| 21 | Run full G0 reproducibility matrix | Windows/independent runner, cultures/time zones, repeated builds | 4–20 | Gate Owner | G0 fitness conjunction passes before G1 |
| 22 | Build and run G1 datasets | Two users/sessions and two realms/colliding IDs | 19–21 | Endpoint Security + AppSec | Cross-boundary effect stops G2+ |
| 23 | Build and run G2 Edge lock matrix | Read-only, WAL, online backup, defer, kill | 18,19,21,22 | Browser Owner | Inconsistent/raw copy stops G3+ |
| 24 | Build and run G3 generation/cursor datasets | source reset/replacement, gaps, time ties, catalogue import quality | 16,18,23 | Endpoint Data Owner | Cursor/generation mismatch stops G4/G5 |
| 25 | Build and run G4 privacy datasets | canaries, malformed input, errors, tenant widening, hard-deny progress | 13,22–24 | Privacy + Endpoint | Any canary/field escape blocks release |
| 26 | Build and run G5 crash-cutpoint matrix | event/marker+cursor, batch, ACK local commit; native SQLite evidence | 18,24,25 | Endpoint Data Owner | Cursor-ahead/corruption blocks ingestion work |
| 27 | Add property-based test candidate | Prototype FsCheck and/or CsCheck with recorded seeds and support cost | 5–12 + OSS review | Test Architecture | Do not make canonical; accept one/none by ADR |
| 28 | Add parser fuzz lane | Prototype SharpFuzz in isolated CI; package/source provenance gate | 7,13,17 + OSS review | AppSec/Test | No production dependency; save minimized reproducers |
| 29 | Build G6 release datasets | stale/unsigned/incomplete/downgrade/rollback/offline switch | G0 + release design | Release Owner | Unauthorized execution blocks rollout |
| 30 | Build G7 identity/network datasets | authentication binding and simulated enterprise network states | G1, G5, device/network design | Identity/Network Owners | Realm/device binding or loss blocks broad pilot |
| 31 | Build G8 server datasets | receipt cut points, duplicates, poison, leases, audit atomicity | G5, server persistence | Ingestion/DBA | Premature receipt/duplicate/poison block scale |
| 32 | Build 6,000 structural dataset | parameterized 6,000/60,000 recipe, bounded telemetry, cleanup | G8, metrics lint | Performance/SRE | Correctness/cardinality only; no capacity claim |
| 33 | Define T3 measurement request template | purpose/minimum fields/aggregation/access/expiry/deletion/no-raw proof | 2,8,15 + human policy | Data Steward | Lane remains disabled until approval |
| 34 | Run metadata-only measurements if approved | Replace estimates for rates/bytes/retries/resource behavior | 33 + approval | Measurement Owner | Misclassification/raw value stops collection and triggers incident |
| 35 | Define identical capacity benchmark | Parameter file from approved evidence, database candidates, query/restore/ops evidence | 31,32,34 | Performance + DBA/SRE | No engine/capacity decision without identical evidence |
| 36 | Build G9 benchmark packages/runs | PostgreSQL reference and SQL Server candidate under same contract | 35 | DBA/SRE/Architecture | Missed criteria triggers tuning/ADR, not prose override |
| 37 | Build G10 pressure/outage packages | disk full, quota, long outage, recovery wave, retry storm | G5,G7,G8,G9 | Endpoint/SRE | Silent loss/storm blocks migration expansion |
| 38 | Build G11 deletion/restore/ACK packages | tombstones, snapshot restore, replay, visibility readiness | G8–G10 + human deletion/restore policy | DBA/SRE/Privacy | Loss/duplicate/resurrection blocks production approval |
| 39 | Inventory and approve G12 platform matrix | supported Windows/session/VDI variants and exclusions | Read-only lab inventory + human platform decision | Windows Platform Owner | Unsupported variants explicitly excluded or ADR changed |
| 40 | Build/run G12 packages | platform/session fidelity, diagnostics, support and accessibility | 39, G1–G11 as applicable | Windows/Support/Accessibility | No support claim without passing evidence |
| 41 | Operationalize runbooks | contamination, canary escape, oracle conflict, T3 expiry, dependency incident, cleanup | 13,20, all gate learnings | Support/Incident Owners | Tabletop/drill evidence required before controlled pilot |
| 42 | G0 acceptance review | ADR decisions, source register, CLI evidence, residual risk, owner sign-off | 1–21 | Architecture Review + named humans | **GO only for implementation of G1; NO-GO for live data** |

## 13.1 Immediate repository tickets

The first implementation sprint can be cut into these independently reviewable tickets:

1. `TDG-001` — manifest/classification/deletion JSON Schemas and invalid corpus.
2. `TDG-002` — deterministic hash/LP/base32/fixed-clock library with vectors.
3. `TDG-003` — JCS implementation selection/prototype and cross-language vectors.
4. `TDG-004` — stable stream/range/weight/ID implementation and analyzers.
5. `TDG-005` — scenario DAG, explicit overrides, lineage writer.
6. `TDO-001` — oracle project boundary and forbidden dependency test.
7. `TDO-002` — outcome/state/cursor truth schemas and hand-worked minimal model.
8. `TDO-003` — required mutation suite.
9. `PRV-001` — canary corpus/rules/self-test and sink inventory.
10. `PKG-001` — canonical package writer/root/atomic publication/path hardening.
11. `DBT-001` — ephemeral SQLite schema/materializer/native source ID checks.
12. `CAT-001` — 173-row fictional catalogue profile and independent profiler.
13. `REP-001` — exact reconciler and evidence-pack schema.
14. `CI-001` — locked dependency restore, SBOM/license/advisory/provenance report.
15. `CI-002` — cross-platform/culture/time-zone reproducibility matrix.
16. `RUN-001` — cleanup confinement and deletion evidence.

The sprint stops before browser/session lab code if tickets 1–10 cannot produce a passing minimal G0 package.

---

# 14. Open-source repository assessment table

## 14.1 Selection rule

**FACT.** Repository popularity, download counts, and vendor ownership do not prove UAM fitness. The relevant questions are whether the reviewed source is traceable to the consumed artifact, whether its license and runtime are acceptable, whether it is maintained and tested, whether its failure mode is contained, and whether its threat model matches a privacy-sensitive Windows endpoint system.

**RECOMMENDATION.** Keep the canonical generator, identifier/clock contract, package format, and oracle UAM-owned. Adopt external tools only in test lanes with exact version/hash provenance, locked restores, SBOM and license review, advisory monitoring, deterministic reproducers, bounded output, and an owner. Select at most one general property-based framework after a short proof-of-fit; do not add both FsCheck and CsCheck without a demonstrated capability gap. Use Gitleaks only as a second scanner behind the UAM exact-canary scanner. Treat Coyote, Presidio, and GraphWalker as reference or bounded prototypes unless later evidence changes the decision.

The review point is 31 July 2026. “No matching source commit” below is an evidence result, not a minor documentation omission: the package MUST NOT enter the locked test toolchain until the package bytes, symbols/source link, repository commit, and license can be reconciled and recorded.

| Repository and exact review | License and compatibility | Maintenance/release evidence | Relevant source areas; tests/security posture | UAM similarity and threat-model difference | Reusable ideas; ideas that MUST NOT be copied | Suitability and gate |
|---|---|---|---|---|---|---|
| **Bogus** — [repository](https://github.com/bchavez/Bogus), [release `v35.6.5`](https://github.com/bchavez/Bogus/releases/tag/v35.6.5), [commit `70fd9acc9491058b77283a65f1fb7873483f6bd7`](https://github.com/bchavez/Bogus/commit/70fd9acc9491058b77283a65f1fb7873483f6bd7), [tree](https://github.com/bchavez/Bogus/tree/70fd9acc9491058b77283a65f1fb7873483f6bd7). Relevant areas: `.github`, `Docs`, `Examples`, `Source`, build/test projects. [OSS1](#oss1) | MIT. Native .NET fit is good. Locale datasets and realistic-looking values can nevertheless resemble real people or identifiers and therefore still require UAM vocabulary restrictions and scanning. | Release dated 25/26 October 2025; the release page shows a verified signed commit. Maintenance is recent enough for reference, but not evidence that generated sequences are a stable UAM contract. | Source, documentation, examples, tests, and workflows are present. Documentation exposes global/local seeding and a fixed `DateTime` reference, and warns that code or library changes can change deterministic output. A signed release improves provenance but does not prove generated-data privacy. | Similarity: composable fictional object generation. Difference: it generates plausible values; it does not classify datasets, enforce realm/session boundaries, predict cursor/receipt states, or guarantee byte-for-byte stability across upgrades. | Reuse: local-seed discipline, fixed date reference, builders for non-canonical display text. Do not copy: mutable global seed, implicit locale fallback, `Guid.NewGuid()`, wall-clock time, or library PRNG output as canonical identity/distribution/truth. | **Reference only by default.** MAY become a test-only dependency for peripheral fictional text under a separate ADR. It MUST NOT produce canonical IDs, clocks, weighted choices, catalogue-profile counts, canaries, or truth-ledger rows. |
| **FsCheck** — [repository](https://github.com/fscheck/FsCheck), [release `3.3.4`](https://github.com/fscheck/FsCheck/releases/tag/3.3.4), [commit `7c583d6df4939643fd36f0439694be1456833aff`](https://github.com/fscheck/FsCheck/commit/7c583d6df4939643fd36f0439694be1456833aff), [tree](https://github.com/fscheck/FsCheck/tree/7c583d6df4939643fd36f0439694be1456833aff). Relevant areas: `src`, `tests`, `examples`, `docs`, `.config`. [OSS2](#oss2) | BSD-3-Clause. Usable from C# but brings an F#-implemented library and associated skills/runtime considerations into the test stack. Experimental APIs require extra care. | `3.3.4` released 25 July 2026 and fixes C# record generation; active recent release activity. | Dedicated source, tests, examples, docs, and integrations for xUnit/NUnit/MSTest are present. Shrinking is a core behavior. The existence of tests does not prove properties relevant to UAM, and experimental state-machine APIs can change. | Similarity: generated cases, properties, shrinking, and state-machine concepts can challenge schemas and invariants. Difference: its generator is not the classified canonical package and its shrinker has no knowledge of UAM lineage, canary placement, owner/deletion obligations, authentication-derived realm, or durable receipt semantics. | Reuse: property combinators, shrinking, replayable seed recording, and invariant testing. Do not copy: framework-generated seed as dataset identity, an experimental state-machine API as the production oracle, or a shrunk case that omits mandatory provenance/canary/truth fields. | **Test-dependency candidate.** Prototype against FF-003/004/006/007/008/010 and developer support cost. Pin package and seed; persist minimized reproducers as T1 packages. Accept only one general property framework unless comparative evidence justifies two. |
| **CsCheck** — [repository](https://github.com/AnthonyLloyd/CsCheck), [NuGet `4.7.0`](https://www.nuget.org/packages/CsCheck/4.7.0). Relevant areas visible in the repository: `.github/workflows`, `CsCheck`, `Tests`. **UNKNOWN:** no matching GitHub release/tag or exact source commit for the `4.7.0` package was established in this review. [OSS3](#oss3) | Apache-2.0; notice obligations apply. Package targets .NET 8 or later, which fits a modern test project but remains an execution-time lifecycle choice. | NuGet records `4.7.0` updated 17 May 2026. It advertises PCG-based generation/shrinking, reproducible shrunk seeds, model/metamorphic/parallel/concurrency testing. Recent package activity exists; maintainer concentration increases continuity risk. | Repository has workflows, implementation, and tests. No formal security policy was observed in the reviewed repository view. Most importantly, package-to-source mapping is unresolved, so source review cannot yet attest to the consumed bytes. | Similarity: C#-native property, model, metamorphic, and concurrency tests are close to the desired falsification lane. Difference: its PRNG/shrinker is a test search mechanism, not the UAM canonical stream; it does not supply privacy classification, realm/session containment, or an independent receipt/cursor oracle. | Reuse: compact generators, shrunk seed reproduction, metamorphic checks, and selected model tests. Do not copy: PCG sequence as permanent fixture format, parallel random tests without bounded evidence, or any package whose source provenance is unresolved. | **Conditional test-dependency candidate.** Before use, resolve package hash, signature, Source Link/symbols, exact commit, license files, and advisories; then compare with FsCheck on C# ergonomics, shrink quality, deterministic evidence, AOT/runtime fit, and support burden. Until then: **NO-GO as a dependency**. |
| **Microsoft Coyote** — [repository](https://github.com/microsoft/coyote), [NuGet CLI `1.7.11`](https://www.nuget.org/packages/Microsoft.Coyote.CLI/1.7.11). Relevant areas: `.github/workflows`, `Source`, `Tests`, `Samples`, `Tools`, `docs`, `SECURITY.md`. **UNKNOWN:** no GitHub release/tag or exact repository commit mapped to package `1.7.11` was established. [OSS4](#oss4) | MIT. C#/.NET fit is direct, but the CLI and IL-rewriting/systematic-exploration model adds tooling and runtime compatibility risk. The project states it is provided as-is without formal support. | NuGet records `1.7.11` last updated 18 March 2024. That is materially older than the research date; no matching GitHub release stream was found. | Substantial source, tests, samples, workflows, documentation, and a security policy exist. Systematic concurrency exploration and deterministic replay are valuable, but instrumentation can change execution behavior and requires exact runtime/provider validation. | Similarity: G5/G8 need systematic schedule and crash/interleaving exploration. Difference: Coyote does not model Windows token/session ACLs, browser SQLite locking, external durable storage, or UAM privacy boundaries unless UAM builds those models; systematic exploration is not exhaustive proof of all real schedules. | Reuse: schedule exploration, replay logs, liveness/state assertions, bounded unfair schedules. Do not copy: IL rewriting into production artifacts, a model that substitutes for real SQLite/process crash tests, or a claim that explored schedules prove Windows behavior. | **Reference and bounded prototype only.** A G5/G8 spike MAY compare it with a smaller UAM scheduler harness. Dependency adoption requires source/package mapping, current .NET compatibility, reproducible failure evidence, no production instrumentation, and a support owner. |
| **SharpFuzz** — [repository](https://github.com/Metalnem/sharpfuzz), [NuGet `2.3.0`](https://www.nuget.org/packages/SharpFuzz/2.3.0); latest source tag found was [release `v2.2.0`](https://github.com/Metalnem/sharpfuzz/releases/tag/v2.2.0), [commit `28c353b41a1ff60039bf78293dbd5edd9d7c3014`](https://github.com/Metalnem/sharpfuzz/commit/28c353b41a1ff60039bf78293dbd5edd9d7c3014). Relevant areas: `.github/workflows`, `build`, `dictionaries`, `docs`, `patches`, `scripts`, `src`, `tests`. **UNKNOWN:** exact source commit for package `2.3.0`. [OSS5](#oss5) | MIT; library targets .NET Standard 2.0, while current instrumentation guidance requires a modern .NET SDK. AFL/libFuzzer/native tooling increases Windows CI, CPU, storage, and crash-artifact handling cost. | NuGet records `2.3.0` updated 16 June 2026. GitHub tags found in the review stop at `v2.2.0` from 11 January 2025, creating a provenance gap for the current package. | Workflows, fuzzing dictionaries, instrumentation source, tests, and native-fuzzer integration exist. No formal security policy was established in this review. Fuzz outputs and crash dumps may echo input bytes, so the lane must use T1 only and scan/redact evidence. | Similarity: suitable for parsers of manifest, JSON/NDJSON, compressed batches, SQLite fixture builders, and scanner decoders. Difference: coverage-guided crash discovery does not predict semantic outcomes, cursor progress, realm effects, or deletion state. | Reuse: isolated parser harnesses, dictionaries, minimized crash corpus, timeout/memory limits. Do not copy: run against live/T2/T3 values, publish raw dumps, fuzz production processes, or treat “no crash” as schema/privacy correctness. | **Conditional isolated-CI dependency candidate.** Resolve the `2.3.0` package-to-source mapping and toolchain hashes first. Run only in disposable workers with T1 corpus, resource limits, scanned artifacts, and a fixed retention/deletion rule. |
| **Gitleaks** — [repository](https://github.com/gitleaks/gitleaks), [release `v8.30.1`](https://github.com/gitleaks/gitleaks/releases/tag/v8.30.1), [commit `83d9cd684c87d95d656c1458ef04895a7f1cbd8e`](https://github.com/gitleaks/gitleaks/commit/83d9cd684c87d95d656c1458ef04895a7f1cbd8e), [tree](https://github.com/gitleaks/gitleaks/tree/83d9cd684c87d95d656c1458ef04895a7f1cbd8e). Relevant areas: `.github`, `cmd`, `config`, `detect`, report/config tests, `SECURITY.md`. [OSS6](#oss6) | MIT. Distributed Go binary is operationally simple, but executable provenance/checksums and action pinning are security boundaries. Reports can contain matched text and therefore need redaction. | `v8.30.1` released 21 March 2026 with release assets and checksums. Project documentation describes Gitleaks as feature-complete with future releases focused on security patches, so maintenance monitoring remains necessary and migration risk exists. | Workflows, tests, configuration/detection code, release assets, and a security policy are present. Generic secret rules cannot know UAM’s fictional canary registry, forbidden sink graph, classification manifest, or organization-specific confidential patterns. | Similarity: repository/artifact secret scanning and custom regex/allowlist configuration. Difference: it detects known pattern classes; it cannot prove absence of personal data, internal references, encoded canaries, or semantic leakage across endpoint boundaries. | Reuse: pinned binary, checksum verification, custom rules, SARIF/structured reports after redaction. Do not copy: floating GitHub Action tags, default rules as the only privacy gate, unrestricted report retention, or allowlists that suppress UAM exact canaries. | **Recommended secondary scanner dependency.** UAM exact-canary and sink-aware scanning remains primary. Gate on pinned full commit/release asset hash, custom self-tests, zero mandatory canary misses, redacted reports, and an alternative/removal plan. |
| **Presidio** — [repository](https://github.com/data-privacy-stack/presidio), [release `2.2.364`](https://github.com/data-privacy-stack/presidio/releases/tag/2.2.364), [commit `779dbd286d5ef4d1fbe2514275fb1bce358f2417`](https://github.com/data-privacy-stack/presidio/commit/779dbd286d5ef4d1fbe2514275fb1bce358f2417), [tree](https://github.com/data-privacy-stack/presidio/tree/779dbd286d5ef4d1fbe2514275fb1bce358f2417). Relevant areas: `.github`, `docs`, `e2e-tests`, `presidio-analyzer`, `presidio-anonymizer`, `presidio-cli`, `SECURITY.md`, `SUPPORT.md`. [OSS7](#oss7) | MIT. Python, NLP engines/models, recognizer configuration, containers, and model/package downloads add a second runtime and substantial supply-chain/operations cost. Any use must be offline against local T1/T2-approved artifacts; no external service submission. | `2.2.364` released 22 July 2026 from a verified signed commit; release notes show active recognizer, dependency, CI, and security-fix work. | Component tests, end-to-end tests, workflows, security and support policies are present. The project explicitly warns that automated detection cannot guarantee finding every sensitive value. Model and recognizer behavior varies by language/context/version. | Similarity: heuristic detection of common PII/address/identifier patterns can challenge fictional corpora and scan evidence. Difference: UAM needs exact known-canary detection, provenance, sink rules, and trust-boundary assertions; a statistical/recognizer result cannot authorize data or prove no leak. | Reuse: optional offline second-opinion recognizers, confidence-labelled findings, language-specific adversarial corpus. Do not copy: “anonymize then commit,” automatic approval on no findings, model downloads at test time, sending artifacts to hosted services, or storing raw matched context. | **Reference; optional secondary heuristic only.** Not a G0 default dependency. A future ADR requires measured added detection over exact rules/Gitleaks, pinned models/packages, offline execution, bounded resources, false-positive operations plan, and explicit acknowledgement that it is not a proof oracle. |
| **GraphWalker** — [repository](https://github.com/GraphWalker/graphwalker-project), [release `4.3.3`](https://github.com/GraphWalker/graphwalker-project/releases/tag/4.3.3), [commit `1c28d9c4171b8bda24d01f3268ddc6765b3a2e81`](https://github.com/GraphWalker/graphwalker-project/commit/1c28d9c4171b8bda24d01f3268ddc6765b3a2e81), [tree](https://github.com/GraphWalker/graphwalker-project/tree/1c28d9c4171b8bda24d01f3268ddc6765b3a2e81). Relevant areas: `.github/workflows`, `.mvn/wrapper`, `graphwalker-cli`, `graphwalker-core`, `graphwalker-model-checker`, `graphwalker-studio`. [OSS8](#oss8) | MIT. Requires Java/Maven; Studio also introduces Node/web dependencies. That is a poor default fit for a C#/.NET implementation foundation and increases patching/licensing/skills burden. | `4.3.3` released 26 September 2024 from a verified signed commit. The project website states that GraphWalker is being rewritten in Rust, creating roadmap and migration uncertainty for the Java line. | Core/CLI/model-checker modules, workflows, and release dependency updates/tests are visible. The older release, multi-runtime stack, and rewrite reduce confidence in adopting it as a long-lived test dependency. | Similarity: graph-based lifecycle models, path generation, coverage criteria. Difference: it supplies traversal, not UAM’s privacy classification, deterministic byte contract, independent outcome semantics, or real Windows/SQLite failure execution. | Reuse: explicit state/edge notation, reachability checks, transition coverage, invalid-edge tests. Do not copy: JVM/Studio runtime, generated traversal as proof of complete behavior, or graph paths without causal truth/canary/cleanup obligations. | **Reference only.** Implement the small UAM state graphs in ordinary versioned data/code. Reconsider only if graph complexity exceeds the UAM implementation and a current supported release demonstrates lower total operational cost. |

## 14.2 Dependency admission checklist

A test-tool ADR MUST fail closed unless it records all of the following:

1. exact package/binary version, full repository commit, release/tag, source and binary hashes, signature/checksum result, and download origin;
2. license, notices, transitive licenses, export/usage restrictions if any, and Legal/Procurement owner where required;
3. supported runtime/OS, end-of-support date, native tools/models, network/download behavior, and an offline restore/cache procedure;
4. SBOM, advisory scan, security policy/contact, maintainer/release activity, and a replacement/removal plan;
5. capability-specific proof: planted positive/negative cases, deterministic reproducer, false-positive/negative handling, time/memory/output limits, and cleanup;
6. a statement that no tool result approves classification, legal purpose, retention, live-data use, or production readiness;
7. an owner and review trigger for new release, advisory, support/runtime change, package/source mismatch, maintenance stop, or unacceptable operational cost.

**RECOMMENDATION — initial dependency posture.** Admit no generator framework for the first hand-worked G0 package. Admit a pinned Gitleaks binary only after the UAM scanner self-test passes. Run a time-boxed FsCheck-versus-CsCheck spike later and choose zero or one. Keep SharpFuzz outside required CI until its `2.3.0` source provenance is resolved. Keep Bogus, Coyote, Presidio, and GraphWalker out of the default dependency graph; use their documented ideas and bounded prototypes only.

---

# 15. Source register with stable links, dates, reviewed versions/commits, claims, and limitations

All web and repository sources were reviewed on 31 July 2026. A “living document” date means the publisher does not expose a durable document version/date on the cited page; the review date is recorded, and execution-time use requires a fresh check. Direct links are included so a future ADR can reproduce the review. Source presence proves documented capability or guidance, not UAM-specific fitness.

## 15.1 Supplied project evidence

| ID | Supplied source and integrity record | Source/baseline date | Claim supported in this result | Limitation |
|---|---|---|---|---|
| <a id="p1"></a>**P1** | `00-accepted-baseline-attachment.md`; attachment SHA-256 verified in this run: `919cce38fefa2d5c25ae3b2e904950045f2b2d2c35690b94f94a2ee492e35c7a`; embedded synthesis SHA-256: `acaee72712c9203a8827cc235b36b12fb3caf65136d64ea6f3cb9b80681cd5f1` | Baseline dated 31 July 2026 | Accepted endpoint/session architecture, minimization boundary, SQLite/event-cursor invariant, at-least-once/idempotency, receipt meaning, realm isolation, release and restore invariants, synthetic-first Edge slice, and human-decision boundaries | Condensed working baseline; not production approval or runtime proof; exact limits and several technologies remain provisional |
| <a id="p2"></a>**P2** | `02-sanitized-application-catalogue-report.md`; attachment SHA-256: `2be034d723dbfc6230deef25898c9555677b0c347fc29ad2562ebfa891d556a5`; embedded raw-source SHA-256: `b1f665fb2d381bd220e95b5158d3d84ceed97772cc3dda940a7ac4ed70f2b2e4` | Profiled locally 31 July 2026 | Catalogue shape: 173 case-insensitively unique names; zero missing names; five missing external IDs; 168 distinct non-empty IDs and no observed duplicates; ten non-ASCII names; nine possible truncation endings; one IPv4-like literal | Raw values absent; no role, owner, purpose, lifecycle, sensitivity, URL/domain/process/matching, entitlement, usage, or durable external-ID uniqueness truth |
| <a id="p3"></a>**P3** | `04-data-and-schema-evidence-summary.md`; attachment SHA-256: `1ed93b3d60d37da96c1f67e401deb10c9d57736e4f4dbfa26e16760bd2a19ce6` | July 2026 implementation-research pack; reviewed 31 July 2026 | Target concept separation; authentication-derived realm/device; separate received/validated/materialized/quarantined/visible states; stable dedupe/provenance; missing distribution/capacity/restore evidence | Curated metadata summary, no production rows/configuration; cannot prove semantics, volumes, rates, retention, RPO/RTO, or engine fitness |
| <a id="p4"></a>**P4** | `06-research-evidence-rules.md`; attachment SHA-256: `7e3bab737052c5760f7305ffe443bbe24684365db2b4b7cbb78eebb5e634a729` | July 2026 implementation-research pack; reviewed 31 July 2026 | Evidence labels, primary-source preference, privacy boundaries, change-proposal rule, and requirement for CLI/lab evidence before runtime claims | Research-quality rules; not evidence that any runtime capability works |

## 15.2 Standards, platform, database, security, observability, and accessibility sources

| ID | Stable primary source | Source/release date and reviewed version | Claim supported | Limitation for UAM |
|---|---|---|---|---|
| <a id="w1"></a>**W1** | Microsoft, [.NET and .NET Core Support Policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core) | Last updated 14 July 2026; reviewed table: .NET 10 LTS, latest patch `10.0.10`, patch date 14 July 2026, end of support 14 November 2028 | Supported-line/lifecycle facts and requirement to remain current on servicing patches | Changes over time; does not select deployment model, Windows build support, or prove UAM compatibility/performance |
| <a id="w2"></a>**W2** | SQLite, [Release History](https://www.sqlite.org/changes.html) | Reviewed release `3.53.4`, 24 July 2026; `SQLITE_SOURCE_ID` `2026-07-24 19:02:57 bf7c7f30031888f4e796e429ab3978879485813aaca6f641c7b33e4e09459bcc`; also 3.51.3/3.53.0 WAL-reset fixes | Current source identity and concrete evidence that WAL-related regressions can be version-specific | Release notes are not provider/package provenance or UAM crash evidence; exact native build and compile options must be measured |
| <a id="w3"></a>**W3** | SQLite, [Write-Ahead Logging](https://www.sqlite.org/wal.html) | Living documentation reviewed 31 July 2026 | WAL concurrency/checkpoint/recovery behavior and constraints used to design cut-point tests | Documented SQLite capability only; filesystem, provider, antivirus, process, power-loss, and UAM transaction fitness require lab evidence |
| <a id="w4"></a>**W4** | JSON Schema, [Draft 2020-12](https://json-schema.org/draft/2020-12) | Published 16 June 2022; Core and Validation `draft-bhutton-…-01` documents | Machine-validatable package/contracts and explicit schema dialect | Schema validation cannot establish semantic truth, authorization, privacy, or compatibility by itself |
| <a id="w5"></a>**W5** | IETF, [RFC 8785 — JSON Canonicalization Scheme](https://www.rfc-editor.org/info/rfc8785/) | June 2020, Informational RFC | Deterministic JSON serialization, duplicate-name prohibition, number/string constraints; JCS preserves Unicode strings as supplied | Not on the IETF standards track; does not normalize Unicode or define UAM hashing/domain separation; implementation vectors are still required |
| <a id="w6"></a>**W6** | IETF, [RFC 9562 — UUIDs](https://www.rfc-editor.org/info/rfc9562/) | May 2024 | Current UUID formats/terminology and privacy/security considerations; basis for not relying on MAC-bearing UUIDv1 or random IDs for deterministic fixtures | UAM uses domain-separated deterministic test IDs and must define its own collision/version contract; RFC conformance alone is not uniqueness proof |
| <a id="w7"></a>**W7** | Unicode Consortium, [UAX #15 — Unicode Normalization Forms](https://www.unicode.org/reports/tr15/) | Revision 57, Unicode 17.0.0, 30 July 2025 | NFC normalization and unique binary representation for canonically equivalent fixture strings | Normalization can alter bytes and must occur at the declared ingress only; it does not authorize case folding or semantic equivalence |
| <a id="w8"></a>**W8** | IETF, [RFC 2606 — Reserved Top Level DNS Names](https://www.rfc-editor.org/info/rfc2606/) | June 1999 | Reserved example/test domain namespaces for fictional URLs/domains | Does not prevent a path/query token from resembling sensitive data; scanners and controlled vocabularies remain required |
| <a id="w9"></a>**W9** | IETF, [RFC 5737 — IPv4 Address Blocks Reserved for Documentation](https://www.rfc-editor.org/info/rfc5737/) | January 2010 | Documentation-only IPv4 blocks for fictional address-like test values | Reserved addresses can still trigger detectors and must not become internal-network assumptions or connectivity targets |
| <a id="w10"></a>**W10** | NIST, [SP 800-218 — Secure Software Development Framework 1.1](https://csrc.nist.gov/pubs/sp/800/218/final) | Final 3 February 2022 | Secure development, supply-chain, provenance, review, vulnerability response, and evidence practices | Outcome-oriented framework; UAM must turn it into repository controls and cannot infer compliance from citation |
| <a id="w11"></a>**W11** | W3C, [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | W3C Recommendation 12 December 2024 | Accessible web reports/interfaces and testable success-criteria direction | Does not automatically establish organizational conformance level or cover every user need; human policy and testing remain required |
| <a id="w12"></a>**W12** | W3C, [WCAG2ICT](https://www.w3.org/TR/wcag2ict-22/) | W3C Group Note 11 December 2025 | Informative application of WCAG principles to non-web software and documents, including CLI/report artifacts | Informative, not normative; does not decide UAM’s required accessibility standard or prove assistive-technology usability |
| <a id="w13"></a>**W13** | NIST, [Differentially Private Synthetic Data](https://www.nist.gov/blogs/cybersecurity-insights/differentially-private-synthetic-data) | 3 May 2021 | Warning that synthetic data derived from real data needs a defined privacy model and that naive synthesis can leak | Introductory publication, not a UAM-approved DP mechanism or parameter choice; this result does not propose training on raw production activity |
| <a id="w14"></a>**W14** | OWASP, [Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html) | Living cheat sheet reviewed 31 July 2026 | Excluding sensitive data, consistent event attributes, protection/integrity, and safe failure handling for logs | Community guidance, not a product-specific threat model or proof that every UAM sink is scanned |
| <a id="w15"></a>**W15** | OpenTelemetry, [Metrics concepts](https://opentelemetry.io/docs/concepts/signals/metrics/) and [.NET metrics best practices](https://opentelemetry.io/docs/languages/dotnet/metrics/best-practices/) | Concepts page updated 2 July 2026; .NET page updated 19 May 2026; reviewed 31 July 2026 | Stable metric instruments, bounded attributes, aggregation, and .NET instrumentation practices | SDK/backend behavior and costs vary; UAM label allowlists and cardinality tests remain mandatory |
| <a id="w16"></a>**W16** | Prometheus, [Metric and label naming](https://prometheus.io/docs/practices/naming/) | Living documentation reviewed 31 July 2026 | Consistent metric naming and caution around labels/cardinality | Prometheus-specific guidance; does not authorize subject/device/realm/application labels or bound another backend automatically |
| <a id="w17"></a>**W17** | SQLite, [Foreign Key Support](https://www.sqlite.org/foreignkeys.html) | Living documentation reviewed 31 July 2026 | Need to enable/check foreign-key enforcement and test relational integrity | Provider defaults and compile options vary; `PRAGMA foreign_keys` result must be captured in every evidence run |
| <a id="w18"></a>**W18** | SQLite, [`PRAGMA integrity_check`](https://www.sqlite.org/pragma.html#pragma_integrity_check) | Living documentation reviewed 31 July 2026 | Database integrity evidence after materialization/crash tests | A passing integrity check does not prove business invariants, durability outside tested cuts, or absence of sensitive data |
| <a id="w19"></a>**W19** | SQLite, [Transaction](https://www.sqlite.org/lang_transaction.html) | Living documentation reviewed 31 July 2026 | Transaction modes, commit/rollback behavior, and one-writer test design | Application/provider sequencing and OS failure semantics still require explicit G5 experiments |
| <a id="w20"></a>**W20** | SQLite, [Online Backup API](https://www.sqlite.org/backup.html) | Living documentation reviewed 31 July 2026 | Safe snapshot/backup mechanism used in browser/source and restore prototypes rather than copying live main/WAL/SHM files | Does not prove Edge permits access, snapshot freshness, profile-generation identity, or UAM recovery correctness on supported Windows variants |

## 15.3 Open-source source register

| ID | Repository/package evidence reviewed | Exact release/date/commit | License | Claim supported | Limitation/action |
|---|---|---|---|---|---|
| <a id="oss1"></a>**OSS1** | [Bogus repository](https://github.com/bchavez/Bogus); [release](https://github.com/bchavez/Bogus/releases/tag/v35.6.5); [commit](https://github.com/bchavez/Bogus/commit/70fd9acc9491058b77283a65f1fb7873483f6bd7) | `v35.6.5`; release date 25/26 October 2025; commit `70fd9acc9491058b77283a65f1fb7873483f6bd7`, verified signature shown by GitHub | MIT | Local/global seed and fixed-date ideas; deterministic output can drift when rules/library change | Reference only by default; never canonical UAM PRNG/ID/time/truth |
| <a id="oss2"></a>**OSS2** | [FsCheck repository](https://github.com/fscheck/FsCheck); [release](https://github.com/fscheck/FsCheck/releases/tag/3.3.4); [commit](https://github.com/fscheck/FsCheck/commit/7c583d6df4939643fd36f0439694be1456833aff) | `3.3.4`; 25 July 2026; commit `7c583d6df4939643fd36f0439694be1456833aff` | BSD-3-Clause | Maintained property-based generation/shrinking with C# support | Candidate test dependency after proof-of-fit; experimental APIs and F# support cost noted |
| <a id="oss3"></a>**OSS3** | [CsCheck repository](https://github.com/AnthonyLloyd/CsCheck); [NuGet `4.7.0`](https://www.nuget.org/packages/CsCheck/4.7.0) | Package updated 17 May 2026; exact package-to-source commit/tag **UNKNOWN** | Apache-2.0 | C# property/model/metamorphic/concurrency capabilities and reproducible shrunk seeds | Dependency blocked until package hash/Source Link/exact commit/license/advisory provenance is established |
| <a id="oss4"></a>**OSS4** | [Microsoft Coyote repository](https://github.com/microsoft/coyote); [NuGet CLI `1.7.11`](https://www.nuget.org/packages/Microsoft.Coyote.CLI/1.7.11) | Package last updated 18 March 2024; exact package-to-source commit/tag **UNKNOWN** | MIT | Systematic concurrency schedule exploration and replay concepts | Reference/bounded spike only; source mapping, age, IL rewriting, runtime fit, and no formal support are material concerns |
| <a id="oss5"></a>**OSS5** | [SharpFuzz repository](https://github.com/Metalnem/sharpfuzz); [NuGet `2.3.0`](https://www.nuget.org/packages/SharpFuzz/2.3.0); [last mapped release `v2.2.0`](https://github.com/Metalnem/sharpfuzz/releases/tag/v2.2.0); [commit](https://github.com/Metalnem/sharpfuzz/commit/28c353b41a1ff60039bf78293dbd5edd9d7c3014) | Package `2.3.0` updated 16 June 2026; latest matching repository tag found `v2.2.0`, 11 January 2025, commit `28c353b41a1ff60039bf78293dbd5edd9d7c3014`; `2.3.0` source commit **UNKNOWN** | MIT | Coverage-guided .NET parser fuzzing and minimized crash corpus | Isolated T1-only candidate; blocked until current package provenance is reconciled |
| <a id="oss6"></a>**OSS6** | [Gitleaks repository](https://github.com/gitleaks/gitleaks); [release](https://github.com/gitleaks/gitleaks/releases/tag/v8.30.1); [commit](https://github.com/gitleaks/gitleaks/commit/83d9cd684c87d95d656c1458ef04895a7f1cbd8e) | `v8.30.1`; 21 March 2026; commit `83d9cd684c87d95d656c1458ef04895a7f1cbd8e`; release assets/checksums | MIT | Generic secret scanning as a second independent layer | Not a PII/canary oracle; pin full hashes, use custom self-tests, redact reports, monitor security-only maintenance posture |
| <a id="oss7"></a>**OSS7** | [Presidio repository](https://github.com/data-privacy-stack/presidio); [release](https://github.com/data-privacy-stack/presidio/releases/tag/2.2.364); [commit](https://github.com/data-privacy-stack/presidio/commit/779dbd286d5ef4d1fbe2514275fb1bce358f2417) | `2.2.364`; 22 July 2026; commit `779dbd286d5ef4d1fbe2514275fb1bce358f2417`, verified signature shown by GitHub | MIT | Maintained recognizer/anonymizer ecosystem and explicit false-negative warning | Optional offline heuristic only; Python/model/operations cost; never sole gate or hosted-data path |
| <a id="oss8"></a>**OSS8** | [GraphWalker repository](https://github.com/GraphWalker/graphwalker-project); [release](https://github.com/GraphWalker/graphwalker-project/releases/tag/4.3.3); [commit](https://github.com/GraphWalker/graphwalker-project/commit/1c28d9c4171b8bda24d01f3268ddc6765b3a2e81); [project site](https://graphwalker.github.io/) | `4.3.3`; 26 September 2024; commit `1c28d9c4171b8bda24d01f3268ddc6765b3a2e81`, verified signature shown by GitHub | MIT | Graph/path/model-coverage ideas | Reference only; older Java release, multi-runtime burden, and announced Rust rewrite make dependency adoption unsuitable now |

## 15.4 Evidence interpretation rules

- A source date later than a design’s original publication does not retroactively prove an implementation. The CLI evidence pack records the actual runtime, package, native-source, configuration, OS, and tool hashes used.
- A signed GitHub commit or release helps authenticate publisher attribution; it does not establish secure code, correct behavior, complete testing, or UAM fitness.
- A license listed by a repository/package still requires the exact consumed artifact and transitive dependency notices to be reviewed.
- A living web page can change. Material architecture assertions use stable standards or recorded release/source identifiers; fast-moving dependency choices are re-verified at execution time.
- Internal summaries are authoritative only for the narrow sanitized facts they state. No absent raw value or semantic dimension is reconstructed or inferred.

---

# 16. Confidence table for every major conclusion

Confidence is qualitative and tied to the evidence available at the research cut-off. “High” means the design follows accepted invariants and stable primitives; it does not mean runtime behavior is proved. “Low” usually identifies a deliberately pending CLI/lab or human gate.

| Major conclusion | Confidence | Why and supporting evidence | Evidence that would change the conclusion |
|---|---|---|---|
| The T1/T2/T3 tier model and primary classification/provenance/owner/deletion gate are required before any production-shaped or measured fixture exists | **High** | Directly contains the supplied privacy/evidence boundaries and prevents aggregate shape from becoming an ungoverned raw-data lane. [P1](#p1) [P2](#p2) [P3](#p3) [P4](#p4) | A stronger approved enterprise classification standard that preserves or improves every field, fail-closed transition, expiry, and deletion invariant; or evidence that the proposed gate cannot be operated, followed by an ADR and falsifying prototype |
| The canonical generator, clock, identifiers, distributions, composition, and package root must be UAM-owned and versioned | **High** | Stable test truth cannot depend on mutable library PRNG sequences, locale data, wall time, or library upgrades. Domain-separated hashes and fixed integer algorithms are simple and independently testable. OSS reviews reinforce the drift risk. [W5](#w5) [W7](#w7) [OSS1](#oss1) [OSS2](#oss2) [OSS3](#oss3) | Cross-language vector failure, unacceptable implementation complexity, collision evidence, or a formally specified external generator with stronger long-term compatibility/provenance and lower cost |
| NFC-at-ingress followed by JCS canonicalization and SHA-256/domain-separated framing is suitable for reproducible package hashes | **High** | UAX #15 defines normalization; JCS defines deterministic JSON but preserves strings, so the ordering is explicit; vectors can falsify every primitive. [W5](#w5) [W7](#w7) | Official vector mismatch, duplicate-key/number incompatibility in chosen implementations, a cryptographic standard change, or an inability to reproduce bytes across approved runners |
| An independent oracle and mutation suite must not import production decision code | **High** | Self-oracling would reproduce the same defect as expected truth. Separate declarative truth, hand-worked causal cases, reconciliation, and mandatory mutation kills provide stronger fault detection. [P1](#p1) [P3](#p3) | Demonstrated oracle divergence/maintenance cost that exceeds value, or a verified formal model/code-generation approach with independent semantics and equivalent mutation power |
| The logical model covers the minimum G0 concepts needed for G1–G12 composition | **Medium** | It explicitly represents the distinct concepts required by supplied evidence and the prompt, including realm/session/source generation/cursor/receipt/deletion/migration/truth. [P1](#p1) [P3](#p3) | First implementation reveals an unmodelled causal identity or lifecycle state, or human decisions settle fields/time/identity semantics that require a compatible schema revision |
| The proposed physical SQLite harness schema is an appropriate test materialization, not a production schema decision | **Medium** | SQLite is already the accepted endpoint direction and supports transactions, WAL, FKs, integrity checks, and backup mechanisms. [P1](#p1) [W2](#w2) [W3](#w3) [W17](#w17)–[W20](#w20) | Provider/native source incompatibility, failed crash/integrity tests, schema bottlenecks, or a simpler materialization that preserves all invariants and evidence |
| The sanitized catalogue should influence only count/quality shape through 173 fictional application records | **High** | The supplied profile explicitly proves only those aggregates and explicitly denies semantic dimensions. [P2](#p2) | A separately approved, sanitized evidence pack with new measured dimensions and documented disclosure analysis; role/owner/purpose still require accountable human authority |
| The generated 173-row catalogue can prove shape reproduction but no application semantics or production currentness | **High** | Independent profiling can exactly reconcile the measured counts, while no record-level source values or mappings are available. [P2](#p2) | Governed semantic source data and owner approval; until then any inferred mapping is a test defect |
| Exact canaries plus sink-aware scanning can give high confidence that known planted values are contained | **High** | Exact positive/negative self-tests, encoding variants, allowed-path rules, and every-sink reconciliation are mechanically falsifiable | A planted mandatory canary survives, a sink is unenumerated, decoder ambiguity exists, or scanner output cannot be independently reconciled |
| A clean scanner result proves absence of all unknown sensitive information | **Low** | It does not. Pattern/heuristic tools have false negatives; even Presidio warns detection is not guaranteed. Layering reduces but cannot eliminate this risk. [OSS6](#oss6) [OSS7](#oss7) | A complete formal information-flow proof over every source and sink plus exhaustive controlled vocabularies; practically, this conclusion should remain low and be contained rather than promoted |
| Fail-closed registry publication, immutable revisions, expiry/revocation, and cleanup evidence are necessary controls | **High** | They directly enforce the primary gate and make ownership/retention/deletion operational rather than prose | Demonstrated repository/platform control that provides equivalent immutable provenance and deletion evidence with lower complexity |
| Classification must inherit from the most sensitive ancestor; derived parameters do not automatically become T1 | **High** | Aggregation/synthesis can retain source values or singling-out patterns, and naive synthetic-data approaches need an explicit privacy model. [W13](#w13) | Approved disclosure-risk analysis and steward action for a specific derived artifact; not a blanket downgrade rule |
| The T3 measured-evidence lane should remain disabled by default | **High for safety; Medium for operability** | Required rates/bytes/retries are missing, but collecting them without purpose/field/access/expiry/deletion authority creates a new production-data path. [P3](#p3) [P4](#p4) | Approved measurement policy, minimum schema, no-raw proof, access controls, retention/deletion automation, and successful dry run; operational friction may require process refinement, not silent enablement |
| Realm and session adversarial datasets correctly express the intended isolation claims | **High for model; Low until runtime execution** | The accepted baseline treats realm/session as security/privacy boundaries; the dataset has explicit colliding IDs and cross-session submission/view/mutation/deletion attempts. [P1](#p1) | G1 lab results, Windows token/ACL evidence, authenticated-context implementation, and any discovered boundary not captured by the model |
| Browser-lock/online-backup/defer scenarios are the correct falsifying shape | **Medium for design; Low for actual Edge/Windows behavior** | SQLite documents WAL and Online Backup capability; the accepted baseline requires safe user-session acquisition. [W3](#w3) [W20](#w20) [P1](#p1) | G2 matrix across approved Edge/Windows builds, WAL states, permissions, security products, and process races; failures may require an explicit baseline change proposal |
| Event/source-progress atomicity and cursor-never-ahead can be proved only through G5 crash cut points on the exact provider/native SQLite build | **High as a requirement; Low until experiment** | It is a non-negotiable baseline invariant; SQLite version history shows concrete WAL regressions, so prose/provider version strings are insufficient. [P1](#p1) [W2](#w2) [W19](#w19) | Passing/failing cut-point evidence, native source ID/compile options, integrity/FK results, and restart reconciliation; a failure opens an ADR rather than weakening the invariant |
| Receipt, validation, materialization, quarantine, and visibility must remain separate oracle states | **High** | Supplied data principles and accepted receipt semantics explicitly separate durable custody from semantic acceptance/visibility. [P1](#p1) [P3](#p3) | A versioned protocol change with new durable failure-domain evidence and migration plan; a single `success` flag would conflict with current accepted baseline |
| Stable dedupe identities plus uniqueness should yield one final business effect under retry/replay | **Medium for design; Low until G8/G11 runtime evidence** | It follows the accepted at-least-once/idempotency invariant and is representable in the truth ledger. [P1](#p1) [P3](#p3) | Server cut-point, duplicate, lease, poison, restore, and acknowledged-replay evidence; identity collision or premature receipt failures require redesign |
| A 6,000-device/60,000-event synthetic run is valuable as a structural correctness, isolation, cardinality, and cleanup smoke test | **High** | It directly exercises required endpoint count without inventing a production rate, payload, concurrency, or SLO claim; parameterization keeps estimates replaceable | Evidence that the chosen count/event recipe is too small to exercise structural limits or too costly for routine CI; revise parameters without calling it capacity proof |
| The same 6,000-device synthetic run proves production capacity or database choice | **Low** | No approved rate/byte/retry/outage/query/retention/SLO/RPO/RTO distributions exist. [P3](#p3) | Approved metadata measurements and an identical benchmark with restore, operations, cost, and skills evidence; until then any capacity/engine claim is invalid |
| Disk pressure, long outage, retry-wave, deletion, restore, and acknowledged replay require dedicated G10/G11 evidence | **High as test need; Low as runtime confidence** | These are explicit baseline invariants/unknowns and cannot be inferred from unit tests. [P1](#p1) [P3](#p3) [P4](#p4) | Passing controlled pressure/outage/restore/deletion runs under approved policies and exact software/storage versions; failures trigger containment and ADR review |
| Bounded static metric labels and privacy-safe error/log templates are the correct default observability design | **High for schema; Medium for operations** | OpenTelemetry/Prometheus/OWASP guidance aligns with minimizing sensitive dimensions and cardinality; UAM allowlists make it enforceable. [W14](#w14) [W15](#w15) [W16](#w16) | Backend measurements show legitimate diagnostic gaps or cost/series behavior requiring a bounded schema revision; any proposal to add subject/device/realm/application values needs privacy review and a safer alternative analysis |
| Accessible machine-readable and human-readable reports should be designed from G0 | **Medium** | WCAG 2.2 and WCAG2ICT provide applicable guidance for web/non-web artifacts, and late retrofit is costly. [W11](#w11) [W12](#w12) | Human decision on required conformance, assistive-technology/user testing, and report/portal implementation evidence |
| The current .NET LTS and SQLite source identity should be recorded but not frozen into timeless architecture | **High** | Both are serviced, time-sensitive components; .NET requires current patches and SQLite release history shows relevant defect changes. [W1](#w1) [W2](#w2) | Lifecycle/advisory changes, unsupported Windows target, provider/native mismatch, or a future supported line; execution-time ADR updates the pin, not the architecture principle |
| Gitleaks is suitable only as a secondary scanner | **Medium** | Current signed release/assets and mature scanning code help, but generic secret patterns cannot model UAM canaries, sinks, classifications, or all PII. [OSS6](#oss6) | Proof-of-fit results, planted corpus, false-positive operations cost, maintenance changes, or a better tool; the exact UAM scanner remains mandatory regardless |
| FsCheck or CsCheck may improve property/shrink coverage, but neither should define canonical fixtures | **Medium** | Both offer relevant property-test capabilities; FsCheck has exact current source mapping, while CsCheck has attractive C# features but unresolved package-source mapping. [OSS2](#oss2) [OSS3](#oss3) | Comparative spike results, provenance resolution, support/skills evidence, shrink/replay quality, and maintenance/advisory changes; choose zero or one by ADR |
| SharpFuzz can improve parser robustness only in an isolated T1 lane after provenance resolution | **Medium for capability; Low for immediate admission** | Package activity and established fuzzing architecture are relevant, but current package-to-source mapping is unresolved and native fuzzing raises operational/artifact risks. [OSS5](#oss5) | Exact `2.3.0` source/package mapping, successful bounded Windows CI prototype, scanned minimized corpus, and acceptable support cost |
| Bogus, Coyote, Presidio, and GraphWalker should not be default dependencies | **Medium-High** | Each has reusable ideas, but their sequence stability, source/package age/mapping, runtime/model burden, heuristic limits, or roadmap differ materially from G0’s trust model. [OSS1](#oss1) [OSS4](#oss4) [OSS7](#oss7) [OSS8](#oss8) | A specific measured capability gap, current provenance/security/maintenance evidence, lower total operational cost, and a bounded ADR showing no ownership of canonical truth |
| The proposed design does not require an accepted-baseline change | **High** | It operationalizes, rather than replaces, the accepted architecture and explicitly preserves provisional/human decisions. [P1](#p1) | New primary evidence demonstrating a material conflict; then the required change proposal must state affected decision, evidence, impact, falsifying experiment, migration consequence, and ADR action |

## 16.1 Residual risk and explicit next stop/go gate

What remains unsafe or uncertain after this research:

- **Synthetic representativeness remains uncertain.** Until approved metadata-only measurements exist, rate, byte, retry, outage, disk, resource, and query distributions are hypotheses. A structurally correct 6,000-device package cannot validate production capacity.
- **Oracle common-mode error remains possible.** Code separation, hand-worked examples, mutation tests, metamorphic properties, and actual-result reconciliation reduce it; they cannot prove the model itself has no mistaken requirement.
- **Unknown leakage remains possible.** Exact canaries can prove detection of planted values, not universal absence of personal, confidential, or organization-specific information. Human review and strict source admission remain necessary.
- **Windows/browser/storage behavior remains unproved.** Token/session isolation, ACLs, browser locks, WAL recovery, process termination, disk-full handling, and cleanup require the named CLI/lab gates on approved builds.
- **Deletion and restore remain policy- and operations-dependent.** Research cannot set retention, authorize destruction, prove backup expiry, or guarantee that an operator follows a runbook.
- **T2/T3 governance is operationally costly.** Approval, access, expiry, disclosure review, scanning, deletion verification, and incident handling need named people and protected systems. Automation reduces but does not remove that cost.
- **Dependency maintenance remains time-sensitive.** .NET, native SQLite, scanners, test frameworks, fuzzers, models, and build runners require patching, provenance, advisory review, and reproducible requalification.
- **HUMAN DECISION.** Legal purpose, prohibited use, identity level, real application-name use, role/persona truth, retention, access, budget, SLO/RPO/RTO, and production approval remain outside research authority. No test result can supply that authority.
- **Operational competence cannot be proved by a document.** Support ownership, escalation, contamination response, cleanup, restore, and dependency incidents need rehearsal and retained evidence.

**Next implementation action:** complete backlog items 1–21: implement the minimum manifest/schema validator, deterministic byte/stream/ID/clock primitives, scenario composer, package writer/root verifier, independent oracle, mutation suite, exact canary scanner, lineage/profile validator, ephemeral SQLite materializer, reconciler, and evidence pack. Hand-author the minimal causal package, then generate the fictional catalogue-shaped package only after its T2 approval record exists.

**G0 GO condition:** the primary gate and every mandatory G0 fitness function must pass together: valid classification/provenance/expected result/owner/deletion method; byte-identical deterministic hashes across approved runners/cultures/time zones; exact catalogue profile reconciliation; scanner self-tests and zero forbidden canary sinks; complete actual-to-truth reconciliation; all required oracle mutations killed; native dependency evidence present; bounded telemetry; immutable publication; and verified cleanup. A GO authorizes implementation of G1 only. It does not authorize live data, a pilot, capacity claims, or production.

**G0 NO-GO condition:** stop on any missing or expired approval, unknown lineage parent, classification downgrade without review, owner/deletion gap, hash drift, duplicate JSON key, ID collision, package/source provenance gap, scanner self-test miss, forbidden canary occurrence, oracle mutation survivor, cursor/truth inconsistency, unexpected/missing result, unbounded sensitive telemetry, undeleted artifact, or evidence-pack incompleteness. Revoke/clean the affected package, preserve only privacy-safe incident evidence, assign an owner, and open the relevant issue/ADR before rerun.

**Next stop/go gate: G0 implementation evidence review. Stop on any classification, provenance, truth, owner, deletion, reproducibility, scanner, reconciliation, dependency, or cleanup failure; go only to G1 implementation when every mandatory G0 condition passes.**
